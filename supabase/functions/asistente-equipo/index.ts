// Hormiga (gerencia) y Byte (IT). Ramas separadas.
import { getSupabaseAdmin } from "../_shared/supabase-admin.ts";
import { buildBreakPdf, type PdfBlock } from "../_shared/break-pdf.ts";
import {
  listBookingsDetailed,
  listHotelPhysicalRooms,
} from "../_shared/pxsol-client.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });
}

function norm(s: string) {
  return s.toLowerCase().normalize("NFD").replace(/\p{M}/gu, "");
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return json({ ok: true });

  const auth = req.headers.get("Authorization");
  if (!auth) return json({ ok: false, error: "Sin autorización" }, 401);

  const admin = getSupabaseAdmin();
  const token = auth.replace("Bearer ", "");
  const { data: { user }, error: authErr } = await admin.auth.getUser(token);
  if (authErr || !user) return json({ ok: false, error: "Token inválido" }, 401);

  const { data: perfil } = await admin
    .from("usuarios")
    .select("id, nombre, rol")
    .eq("id", user.id)
    .single();

  const body = await req.json().catch(() => ({}));
  const rama = body.rama === "ti" ? "ti" : "gerente";
  const mensaje = String(body.mensaje ?? "").trim();
  if (!mensaje) return json({ ok: false, error: "Falta mensaje" }, 400);

  if (rama === "gerente" && perfil?.rol !== "gerente") {
    return json({ ok: false, error: "Hormiga es solo de gerencia" }, 403);
  }
  if (rama === "ti" && perfil?.rol !== "ti" && perfil?.rol !== "gerente") {
    return json({ ok: false, error: "Byte es el asistente de IT" }, 403);
  }

  await admin.from("asistente_mensajes").insert({
    rama,
    user_id: user.id,
    rol: "user",
    contenido: mensaje,
  });

  const ctx = await armarContexto(admin, rama);
  const quierePdf = pidePdf(mensaje);
  let pdf: { nombre: string; path: string; mime: string } | undefined;

  let pdfError = "";
  if (quierePdf && rama === "gerente") {
    try {
      pdf = await generarInformePdf(admin, user.id, mensaje, ctx);
    } catch (e) {
      pdfError = e instanceof Error ? e.message : "No pude armar el PDF.";
      console.error("pdf hormiga", e);
    }
  }

  let respuesta = await conLlm(rama, mensaje, ctx, !!pdf);
  if (!respuesta) respuesta = responderLocal(rama, mensaje, ctx, !!pdf);
  if (pdfError) respuesta += `\n\n• El PDF no salió: ${pdfError}`
  respuesta = formatearMensaje(respuesta);

  await admin.from("asistente_mensajes").insert({
    rama,
    user_id: user.id,
    rol: "assistant",
    contenido: respuesta,
  });

  return json({ ok: true, respuesta, pdf: pdf ?? null });
});

interface ObjRow {
  id: string;
  titulo: string;
  descripcion: string | null;
  estado: string;
  area: string;
  owner_id: string;
  fecha_objetivo: string | null;
  cumplido_at: string | null;
  created_at: string;
}

interface TareaRow {
  titulo: string;
  estado: string;
  objetivo_id: string;
  asignado_id: string | null;
  completada_at: string | null;
  created_at: string;
}

interface AdjRow {
  nombre: string;
  created_at: string;
  objetivo_id: string | null;
}

interface Ctx {
  mapa: string;
  ocupadas: number;
  bloqueadas: number;
  objetivos: string;
  rendimiento: string;
  informes: string;
  pxsol: string;
  nombreGerente: string;
  recortes: ObjRow[];
  tareas: TareaRow[];
  adjuntos: AdjRow[];
}

async function armarContexto(
  admin: ReturnType<typeof getSupabaseAdmin>,
  rama: string,
): Promise<Ctx> {
  const { data: mapa } = await admin
    .from("v_mapa_habitaciones")
    .select("numero, piso, estado_habitacion, estado_hospedaje, huesped_nombre, fecha_entrada, fecha_salida")
    .order("numero");

  const ocupadas = (mapa ?? []).filter((h: { estado_hospedaje: string }) =>
    h.estado_hospedaje === "hospedado" || h.estado_hospedaje === "checkout_pendiente",
  );
  const bloqueadas = (mapa ?? []).filter((h: { estado_habitacion: string }) =>
    h.estado_habitacion === "mantenimiento",
  );

  const lineasMapa = (mapa ?? []).slice(0, 24).map((h: Record<string, unknown>) =>
    `${h.numero} P${h.piso} ${h.estado_hospedaje || h.estado_habitacion} ${h.huesped_nombre ?? ""} ${h.fecha_entrada ?? ""}–${h.fecha_salida ?? ""}`.trim(),
  );

  const mapaTxt =
    `Hoy hay ${ocupadas.length} de 24 ocupadas de verdad (ya hicieron check-in). ${bloqueadas.length} bloqueadas.\n` +
    lineasMapa.join("\n");

  let objetivos = "";
  let rendimiento = "";
  let informes = "";
  let recortes: ObjRow[] = [];
  let tareas: TareaRow[] = [];
  let adjuntos: AdjRow[] = [];
  let nombreGerente = "jefe";

  if (rama === "gerente") {
    const { data: objs } = await admin
      .from("objetivos")
      .select("id, titulo, descripcion, estado, area, owner_id, fecha_objetivo, cumplido_at, created_at")
      .order("created_at", { ascending: false })
      .limit(30);
    recortes = (objs ?? []) as ObjRow[];

    const { data: ts } = await admin
      .from("tareas")
      .select("titulo, estado, objetivo_id, asignado_id, completada_at, created_at")
      .limit(120);
    tareas = (ts ?? []) as TareaRow[];

    const { data: ads } = await admin
      .from("trazabilidad_adjuntos")
      .select("nombre, created_at, objetivo_id")
      .order("created_at", { ascending: false })
      .limit(40);
    adjuntos = (ads ?? []) as AdjRow[];

    const { data: users } = await admin
      .from("usuarios")
      .select("id, nombre, rol")
      .in("rol", ["ti", "administracion", "gerente"]);

    nombreGerente = (users ?? []).find((u: { rol: string }) => u.rol === "gerente")?.nombre?.split(" ")[0] ?? "jefe";
    const nombre = (id: string) =>
      (users ?? []).find((u: { id: string }) => u.id === id)?.nombre ?? "el equipo";

    objetivos = recortes.map((o) => {
      const tset = tareas.filter(t => t.objetivo_id === o.id);
      const ok = tset.filter(t => t.estado === "completa").length;
      const pct = tset.length ? Math.round((ok / tset.length) * 100) : (o.estado === "cumplido" ? 100 : 0);
      return `${o.titulo} · ${pct}% · ${o.estado}/${o.area} · ${nombre(o.owner_id)} · fecha ${o.fecha_objetivo ?? o.created_at.slice(0, 10)}${o.descripcion ? ` · ${o.descripcion}` : ""}`;
    }).join("\n");

    rendimiento = (users ?? [])
      .filter((u: { rol: string }) => u.rol !== "gerente")
      .map((u: { id: string; nombre: string; rol: string }) => {
        const mias = tareas.filter(t => t.asignado_id === u.id);
        const ok = mias.filter(t => t.estado === "completa").length;
        return `${u.nombre} (${u.rol}): ${ok} de ${mias.length} tareas listas`;
      }).join("\n");

    informes = adjuntos.map(a => `${a.created_at.slice(0, 10)} ${a.nombre}`).join("\n");
  }

  let pxsol = "";
  try {
    const hotelId = Deno.env.get("PXSOL_HOTEL_ID");
    if (hotelId && Deno.env.get("PXSOL_API_KEY")) {
      const [rooms, bookings] = await Promise.all([
        listHotelPhysicalRooms(hotelId).catch(() => []),
        listBookingsDetailed({ hotelId, perPage: 30 }).catch(() => []),
      ]);
      pxsol =
        `PxSol: ${rooms.length} habitaciones físicas.\n` +
        bookings.slice(0, 12).map((b) => {
          const a = (b as { attributes?: Record<string, unknown> }).attributes ?? {};
          return `${a.booking_id ?? ""} ${a.status ?? ""} ${a.check_in ?? ""} ${a.check_out ?? ""}`;
        }).join("\n");
    }
  } catch (e) {
    pxsol = `PxSol no contestó: ${e instanceof Error ? e.message : "error"}`;
  }

  return {
    mapa: mapaTxt,
    ocupadas: ocupadas.length,
    bloqueadas: bloqueadas.length,
    objetivos,
    rendimiento,
    informes,
    pxsol,
    nombreGerente,
    recortes,
    tareas,
    adjuntos,
  };
}

function pidePdf(pregunta: string) {
  const q = norm(pregunta);
  return /\b(pdf|informe|resumen|reporte|exporta|bajame|armame|arma(me)? un|genera(me)?|hazme)\b/.test(q);
}

function extraerRango(pregunta: string): { desde: string; hasta: string; label: string } {
  const q = norm(pregunta);
  const meses: Record<string, string> = {
    enero: "01", febrero: "02", marzo: "03", abril: "04", mayo: "05", junio: "06",
    julio: "07", agosto: "08", septiembre: "09", setiembre: "09", octubre: "10",
    noviembre: "11", diciembre: "12",
  };
  const year = q.match(/20\d{2}/)?.[0] ?? "2026";
  for (const [nombre, mm] of Object.entries(meses)) {
    if (q.includes(nombre)) {
      const dia = q.match(new RegExp(`(\\d{1,2})\\s+(de\\s+)?${nombre}`))?.[1];
      if (dia) {
        const d = `${year}-${mm}-${dia.padStart(2, "0")}`;
        return { desde: d, hasta: d, label: `${dia} de ${nombre} ${year}` };
      }
      const last = new Date(Number(year), Number(mm), 0).getDate();
      return {
        desde: `${year}-${mm}-01`,
        hasta: `${year}-${mm}-${String(last).padStart(2, "0")}`,
        label: `${nombre} ${year}`,
      };
    }
  }
  if (q.includes("esta semana")) {
    const now = new Date();
    const d = now.toISOString().slice(0, 10);
    return { desde: d, hasta: d, label: "esta semana" };
  }
  return { desde: "2026-01-01", hasta: "2026-12-31", label: "lo que va de 2026" };
}

function enRango(fecha: string | null | undefined, desde: string, hasta: string) {
  if (!fecha) return false;
  const d = fecha.slice(0, 10);
  return d >= desde && d <= hasta;
}

async function conLlm(
  rama: string,
  pregunta: string,
  ctx: Ctx,
  conPdf: boolean,
): Promise<string | null> {
  const key = Deno.env.get("OPENAI_API_KEY");
  if (!key) return null;
  const sistema = rama === "gerente"
    ? `Eres Hormiga, asistente de gerencia del Hotel Break (Manizales). Hablas como un parce de confianza: cercana, colombiana, de tú. Datos precisos del contexto. Si no está, lo dices. NUNCA un párrafo corrido. Formato OBLIGATORIO:
1) Una línea de saludo corta.
2) Línea en blanco.
3) Cada idea en su propia viñeta que empiece con "• ".
4) Si hay un título de bloque, una línea sola que termine en ":" (ejemplo: Equipo:).
Máximo 10 viñetas. ${conPdf ? "Cierra con una viñeta: el PDF ya está listo para abrir en el chat." : ""}`
    : `Eres Byte, IT Break. Cercano y técnico. Solo PxSol y ocupación. Cada idea en una viñeta "• ". Nunca un párrafo corrido.`;

  const res = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4o-mini",
      temperature: 0.55,
      messages: [
        { role: "system", content: sistema },
        {
          role: "user",
          content: `MAPA:\n${ctx.mapa}\n\nOBJETIVOS:\n${ctx.objetivos}\n\nEQUIPO:\n${ctx.rendimiento}\n\nPDFS SUBIDOS:\n${ctx.informes}\n\nPXSOL:\n${ctx.pxsol}\n\nPREGUNTA:\n${pregunta}`,
        },
      ],
    }),
  });
  if (!res.ok) return null;
  const jsonBody = await res.json();
  return jsonBody.choices?.[0]?.message?.content ?? null;
}

function formatearMensaje(texto: string): string {
  const raw = texto.replace(/\r/g, "").trim();
  const partes = raw.split(/\n+/).map(l => l.trim()).filter(Boolean);
  const out: string[] = [];
  for (const linea of partes) {
    if (/^[•\-\*]\s+/.test(linea) || /:$/.test(linea) || out.length === 0) {
      out.push(linea.replace(/^[\-\*]\s+/, "• "));
      continue;
    }
    if (linea.length < 90 && !linea.includes(". ")) {
      out.push(linea.startsWith("• ") ? linea : `• ${linea}`);
      continue;
    }
    for (const frase of linea.split(/(?<=[.!?])\s+/)) {
      const f = frase.trim();
      if (!f) continue;
      out.push(f.startsWith("• ") ? f : `• ${f}`);
    }
  }
  return out.join("\n\n");
}

function responderLocal(rama: string, pregunta: string, ctx: Ctx, conPdf: boolean): string {
  const q = norm(pregunta);
  const nombre = ctx.nombreGerente;
  const pie = conPdf ? "• El PDF ya está listo. Ábrelo aquí mismo, sin bajarlo." : "";
  const objs = ctx.objetivos.split("\n").filter(Boolean).slice(0, 6).map(l => `• ${l}`);

  if (rama === "gerente" && (q.includes("rendim") || q.includes("equipo") || q.includes("como van"))) {
    return [`Listo ${nombre}, así va el equipo:`, "", ...ctx.rendimiento.split("\n").filter(Boolean).map(l => `• ${l}`), "", ...objs, pie].filter(Boolean).join("\n");
  }
  if (rama === "gerente" && (q.includes("objetivo") || q.includes("tablero") || q.includes("avance") || q.includes("sire") || q.includes("tra"))) {
    return [`Te lo dejo por puntos:`, "", ...objs, pie].filter(Boolean).join("\n");
  }

  const num = pregunta.match(/\b([1-4]\d{2})\b/);
  if (num && ctx.mapa.includes(num[1])) {
    const linea = ctx.mapa.split("\n").find(l => l.startsWith(num[1])) ?? "";
    return linea
      ? `La ${num[1]}:\n\n• ${linea}`
      : `• No vi la ${num[1]} en el mapa de hoy.`;
  }

  if (q.includes("ocup") || q.includes("mapa") || q.includes("habitacion")) {
    return [
      `Hoy, sin mentiras:`,
      "",
      `• ${ctx.ocupadas} ocupadas de 24 (ya hicieron check-in).`,
      `• ${ctx.bloqueadas} bloqueadas.`,
      ...ctx.mapa.split("\n").slice(1, 5).map(l => `• ${l}`),
      pie,
    ].filter(Boolean).join("\n");
  }
  if (q.includes("informe") || q.includes("resumen") || q.includes("pdf")) {
    return [`Resumen del tablero:`, "", ...objs, pie].filter(Boolean).join("\n");
  }
  if (q.includes("pxsol") || q.includes("reserva") || q.includes("huesped")) {
    return (ctx.pxsol || ctx.mapa).split("\n").filter(Boolean).slice(0, 8).map(l => `• ${l}`).join("\n");
  }

  if (rama === "ti") {
    return [`Byte al habla.`, "", `• ${ctx.mapa.split("\n")[0]}`, `• ${(ctx.pxsol || "PxSol no mandó payload; uso el mapa interno.").slice(0, 220)}`].join("\n");
  }
  return [
    `Dime más fino, ${nombre}.`,
    "",
    "• Puedo hablarte del mapa o de un número de habitación.",
    "• De cómo va IT o Administración.",
    "• O armarte un PDF de un mes (ejemplo: PDF de septiembre).",
  ].join("\n");
}

async function generarInformePdf(
  admin: ReturnType<typeof getSupabaseAdmin>,
  userId: string,
  pregunta: string,
  ctx: Ctx,
): Promise<{ nombre: string; path: string; mime: string }> {
  const rango = extraerRango(pregunta);
  const delMes = ctx.recortes.filter(o =>
    enRango(o.fecha_objetivo, rango.desde, rango.hasta) ||
    enRango(o.cumplido_at, rango.desde, rango.hasta) ||
    enRango(o.created_at, rango.desde, rango.hasta),
  );
  const lista = delMes.length ? delMes : ctx.recortes;
  const ads = ctx.adjuntos.filter(a =>
    enRango(a.created_at, rango.desde, rango.hasta) || !delMes.length,
  );

  const bloques: PdfBlock[] = [
    {
      kind: "meta",
      kicker: "Hormiga",
      title: `Resumen ${rango.label}`,
      sub: `${rango.desde} a ${rango.hasta}  ·  generado para gerencia`,
    },
    { kind: "section", title: "Hoy en el hotel" },
    {
      kind: "kpi",
      items: [
        { label: "Ocupadas reales", value: `${ctx.ocupadas}/24` },
        { label: "Bloqueadas", value: String(ctx.bloqueadas) },
        { label: "Objetivos en el corte", value: String(lista.length) },
      ],
    },
  ];
  const mapaLineas = ctx.mapa.split("\n").filter(Boolean).slice(1, 7);
  if (mapaLineas.length) {
    bloques.push({ kind: "section", title: "Mapa de hoy" });
    for (const linea of mapaLineas) bloques.push({ kind: "li", text: linea });
  }
  bloques.push({ kind: "section", title: "Equipo" });
  for (const linea of ctx.rendimiento.split("\n").filter(Boolean)) {
    bloques.push({ kind: "li", text: linea, strong: true });
  }
  if (!ctx.rendimiento) bloques.push({ kind: "p", text: "Todavía no hay tareas asignadas al equipo." });

  bloques.push({ kind: "section", title: delMes.length ? `Avances de ${rango.label}` : "Avances del tablero" });
  if (!delMes.length) {
    bloques.push({
      kind: "p",
      text: `No encontré recortes solo de ${rango.label}. Te dejo el panorama completo del tablero.`,
    });
  }
  for (const o of lista) {
    const ts = ctx.tareas.filter(t => t.objetivo_id === o.id);
    const ok = ts.filter(t => t.estado === "completa").length;
    const pct = ts.length ? Math.round((ok / ts.length) * 100) : (o.estado === "cumplido" ? 100 : 0);
    bloques.push({
      kind: "li",
      text: `${o.titulo}  —  ${pct}%  (${labelEstado(o.estado)})`,
      strong: true,
    });
    if (o.descripcion) bloques.push({ kind: "p", text: o.descripcion });
    for (const t of ts.slice(0, 5)) {
      bloques.push({
        kind: "li",
        text: `${t.estado === "completa" ? "Listo" : "Pendiente"}: ${t.titulo}`,
      });
    }
  }

  if (ads.length) {
    bloques.push({ kind: "section", title: "Informes que ya subió el equipo" });
    for (const a of ads.slice(0, 10)) {
      bloques.push({ kind: "li", text: `${a.created_at.slice(0, 10)}  ·  ${a.nombre}` });
    }
  }

  const pdf = buildBreakPdf(bloques);
  if (pdf.byteLength < 800) throw new Error("El PDF salió vacío.");
  const nombre = `Hormiga-${rango.desde}-resumen.pdf`;
  const path = `${userId}/${crypto.randomUUID()}.pdf`;

  const { error: upErr } = await admin.storage
    .from("trazabilidad")
    .upload(path, pdf, { contentType: "application/pdf", upsert: false });
  if (upErr) throw new Error(upErr.message);

  let { data: obj } = await admin
    .from("objetivos")
    .select("id")
    .eq("titulo", "Informes de Hormiga")
    .maybeSingle();
  if (!obj) {
    const { data: created } = await admin.from("objetivos").insert({
      titulo: "Informes de Hormiga",
      descripcion: "PDFs que arma Hormiga cuando gerencia pide un resumen.",
      area: "gerencia",
      estado: "en_curso",
      owner_id: userId,
    }).select("id").single();
    obj = created;
  }
  if (obj) {
    await admin.from("trazabilidad_adjuntos").insert({
      objetivo_id: obj.id,
      nombre,
      mime: "application/pdf",
      path,
      bytes: pdf.byteLength,
      subido_por: userId,
    });
  }

  return { nombre, path, mime: "application/pdf" };
}

function labelEstado(estado: string) {
  if (estado === "cumplido") return "cumplido";
  if (estado === "en_curso") return "en curso";
  if (estado === "abierto") return "abierto";
  return estado;
}

