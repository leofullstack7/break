// Hormiga (gerencia) y Byte (IT). Ramas separadas.
import { getSupabaseAdmin } from "../_shared/supabase-admin.ts";
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

  if (quierePdf && rama === "gerente") {
    try {
      pdf = await generarInformePdf(admin, user.id, mensaje, ctx);
    } catch (e) {
      console.error("pdf hormiga", e);
    }
  }

  let respuesta = await conLlm(rama, mensaje, ctx, !!pdf);
  if (!respuesta) respuesta = responderLocal(rama, mensaje, ctx, !!pdf);

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
  return /\b(pdf|informe|resumen|reporte|exporta|bajame|armame|arma un)\b/.test(q);
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
    ? `Eres Hormiga, la asistente de gerencia del Hotel Break en Manizales. Hablas como un parce de confianza: cálida, cercana, colombiana, sin grosería pesada. Tú y el gerente se tratan de "tú". Das datos precisos (números, fechas, nombres) que SÍ estén en el contexto. Si no está, lo dices. No inventes ocupación ni avances. Frases cortas. Máximo 8 líneas. ${conPdf ? "Al final menciona que ya le dejaste el PDF listo para abrir en el chat, sin descargar." : ""}`
    : `Eres Byte, asistente de IT Break. Cercano pero técnico. Solo PxSol, habitaciones, huéspedes y estados. No hables de rendimiento ni zumbidos. No inventes datos.`;

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

function responderLocal(rama: string, pregunta: string, ctx: Ctx, conPdf: boolean): string {
  const q = norm(pregunta);
  const nombre = ctx.nombreGerente;
  const pie = conPdf ? "\n\nTe dejé el PDF abajito, ábrelo ahí mismo." : "";

  if (rama === "gerente" && (q.includes("rendim") || q.includes("equipo") || q.includes("como van") || q.includes("cómo van"))) {
    return `Parce ${nombre}, así va la casa:\n${ctx.rendimiento || "Aún no hay tareas asignadas."}\n\n${resumenCorto(ctx)}${pie}`;
  }
  if (rama === "gerente" && (q.includes("objetivo") || q.includes("tablero") || q.includes("avance") || q.includes("sire") || q.includes("tra"))) {
    return `Mira, te lo dejo claro:\n${ctx.objetivos || "Todavía no hay objetivos en el tablero."}${pie}`;
  }

  const num = pregunta.match(/\b([1-4]\d{2})\b/);
  if (num && ctx.mapa.includes(num[1])) {
    const linea = ctx.mapa.split("\n").find(l => l.startsWith(num[1])) ?? "";
    return linea
      ? `La ${num[1]} está así: ${linea}.`
      : `No la vi en el mapa de hoy, ${nombre}.`;
  }

  if (q.includes("ocup") || q.includes("mapa") || q.includes("habitacion")) {
    return `Hoy, sin mentiras: ${ctx.ocupadas} ocupadas de 24. ${ctx.bloqueadas} bloqueadas.\n${ctx.mapa.split("\n").slice(1, 6).join("\n")}${pie}`;
  }
  if (q.includes("informe") || q.includes("resumen") || q.includes("pdf")) {
    return `Te resumo lo que hay en el tablero:\n${resumenCorto(ctx)}${pie}`;
  }
  if (q.includes("pxsol") || q.includes("reserva") || q.includes("huesped")) {
    return (ctx.pxsol || ctx.mapa).slice(0, 700) + pie;
  }

  if (rama === "ti") {
    return `Byte al habla. Mapa: ${ctx.mapa.split("\n")[0]}\n${(ctx.pxsol || "PxSol no mandó payload ahora; uso el mapa interno.").slice(0, 500)}`;
  }
  return `Dime con más detalle, ${nombre}. Puedo hablarte del mapa, de un número de habitación, de cómo va IT o Administración, o armarte un PDF de un mes.${pie}`;
}

function resumenCorto(ctx: Ctx): string {
  const lineas = ctx.objetivos.split("\n").filter(Boolean).slice(0, 6);
  return lineas.join("\n") || "Sin objetivos cargados.";
}

async function generarInformePdf(
  admin: ReturnType<typeof getSupabaseAdmin>,
  userId: string,
  pregunta: string,
  ctx: Ctx,
): Promise<{ nombre: string; path: string; mime: string }> {
  const rango = extraerRango(pregunta);
  const objs = ctx.recortes.filter(o =>
    enRango(o.fecha_objetivo, rango.desde, rango.hasta) ||
    enRango(o.cumplido_at, rango.desde, rango.hasta) ||
    enRango(o.created_at, rango.desde, rango.hasta) ||
    (rango.label.includes("2026") && rango.desde <= "2026-01-01"),
  );
  const lista = objs.length ? objs : ctx.recortes.slice(0, 8);
  const ads = ctx.adjuntos.filter(a => enRango(a.created_at, rango.desde, rango.hasta));

  const lineas: string[] = [
    `Periodo: ${rango.label} (${rango.desde} a ${rango.hasta})`,
    `Ocupacion de hoy: ${ctx.ocupadas}/24 reales. ${ctx.bloqueadas} bloqueadas.`,
    "",
    "Avance del equipo",
    ctx.rendimiento || "Sin tareas asignadas.",
    "",
    "Objetivos y avances",
  ];
  for (const o of lista) {
    const ts = ctx.tareas.filter(t => t.objetivo_id === o.id);
    const ok = ts.filter(t => t.estado === "completa").length;
    const pct = ts.length ? Math.round((ok / ts.length) * 100) : (o.estado === "cumplido" ? 100 : 0);
    lineas.push(`- ${o.titulo}  ${pct}%  (${o.estado})`);
    if (o.descripcion) lineas.push(`  ${o.descripcion}`);
    for (const t of ts.slice(0, 4)) {
      lineas.push(`    [${t.estado === "completa" ? "x" : " "}] ${t.titulo}`);
    }
  }
  if (ads.length) {
    lineas.push("", "Informes que ya subio el equipo");
    for (const a of ads.slice(0, 10)) lineas.push(`- ${a.created_at.slice(0, 10)}  ${a.nombre}`);
  }

  const pdf = makeInformeElegante(`Resumen ${rango.label}`, lineas);
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

function wrapLine(s: string, max = 86): string[] {
  if (!s) return [""];
  const words = s.split(/\s+/);
  const out: string[] = [];
  let cur = "";
  for (const w of words) {
    const next = cur ? `${cur} ${w}` : w;
    if (next.length > max) {
      if (cur) out.push(cur);
      cur = w;
    } else cur = next;
  }
  if (cur) out.push(cur);
  return out;
}

function makeInformeElegante(title: string, lines: string[]): Uint8Array {
  const safe = (s: string) => s.replace(/\\/g, "\\\\").replace(/\(/g, "\\(").replace(/\)/g, "\\)");
  const wrapped = lines.flatMap(l => wrapLine(l, 88));
  const perPage = 32;
  const pages: string[][] = [];
  for (let i = 0; i < wrapped.length; i += perPage) pages.push(wrapped.slice(i, i + perPage));
  if (!pages.length) pages.push([]);

  const pageIds = pages.map((_, i) => 3 + i);
  const contentIds = pages.map((_, i) => 3 + pages.length + i);
  const fontId = 3 + pages.length * 2;
  const objects: string[] = new Array(2 + pages.length * 2 + 1);
  objects[0] = "1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj";
  objects[1] = `2 0 obj << /Type /Pages /Kids [${pageIds.map(id => `${id} 0 R`).join(" ")}] /Count ${pages.length} >> endobj`;

  for (let i = 0; i < pages.length; i++) {
    objects[pageIds[i] - 1] =
      `${pageIds[i]} 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents ${contentIds[i]} 0 R /Resources << /Font << /F1 ${fontId} 0 R >> >> >> endobj`;
    const ops: string[] = [
      "0.79 0.64 0.16 rg",
      "36 742 540 28 re f",
      "0.05 0.05 0.05 rg",
      "36 40 540 1.2 re f",
      "BT",
      "/F1 16 Tf",
      "1 1 1 rg",
      "50 750 Td",
      "(BREAK) Tj",
      "0.05 0.05 0.05 rg",
      "/F1 13 Tf",
      "50 710 Td",
      `(${safe(title)}) Tj`,
      "/F1 9 Tf",
      "0 -16 Td",
      "(Hotel Break Boutique  ·  Manizales  ·  Hormiga) Tj",
      "0 -22 Td",
    ];
    for (const line of pages[i]) {
      ops.push(`(${safe(line)}) Tj`, "0 -15 Td");
    }
    ops.push("ET");
    const stream = ops.join("\n");
    objects[contentIds[i] - 1] =
      `${contentIds[i]} 0 obj << /Length ${stream.length} >> stream\n${stream}\nendstream endobj`;
  }
  objects[fontId - 1] = `${fontId} 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj`;

  let body = "%PDF-1.4\n";
  const offsets = [0];
  for (const obj of objects) {
    offsets.push(body.length);
    body += obj + "\n";
  }
  const xrefPos = body.length;
  let xref = `xref\n0 ${objects.length + 1}\n0000000000 65535 f \n`;
  for (let i = 1; i <= objects.length; i++) {
    xref += `${String(offsets[i]).padStart(10, "0")} 00000 n \n`;
  }
  body += xref;
  body += `trailer << /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xrefPos}\n%%EOF`;
  return new TextEncoder().encode(body);
}
