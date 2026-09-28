// Asistentes de equipo. Ramas separadas:
//   rama=gerente → Hormiga (tablero + rendimiento + PxSol/ocupación)
//   rama=ti      → Byte (solo PxSol / habitaciones / huéspedes)
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
  let respuesta = await conLlm(rama, mensaje, ctx);
  if (!respuesta) respuesta = responderLocal(rama, mensaje, ctx);

  await admin.from("asistente_mensajes").insert({
    rama,
    user_id: user.id,
    rol: "assistant",
    contenido: respuesta,
  });

  return json({ ok: true, respuesta });
});

interface Ctx {
  mapa: string;
  objetivos: string;
  rendimiento: string;
  pxsol: string;
}

async function armarContexto(admin: ReturnType<typeof getSupabaseAdmin>, rama: string): Promise<Ctx> {
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
    `Ocupadas ${ocupadas.length}/24. Bloqueadas ${bloqueadas.length}.\n` +
    lineasMapa.join("\n");

  let objetivos = "";
  let rendimiento = "";
  if (rama === "gerente") {
    const { data: objs } = await admin
      .from("objetivos")
      .select("id, titulo, estado, area, owner_id")
      .order("created_at", { ascending: false })
      .limit(20);
    const { data: tareas } = await admin
      .from("tareas")
      .select("titulo, estado, objetivo_id, asignado_id")
      .limit(80);
    const { data: users } = await admin
      .from("usuarios")
      .select("id, nombre, rol")
      .in("rol", ["ti", "administracion", "gerente"]);

    const nombre = (id: string) =>
      (users ?? []).find((u: { id: string }) => u.id === id)?.nombre ?? "equipo";

    objetivos = (objs ?? []).map((o: { titulo: string; estado: string; area: string; owner_id: string; id: string }) => {
      const ts = (tareas ?? []).filter((t: { objetivo_id: string }) => t.objetivo_id === o.id);
      const ok = ts.filter((t: { estado: string }) => t.estado === "completa").length;
      return `${o.titulo} [${o.estado}/${o.area}] dueño ${nombre(o.owner_id)} · ${ok}/${ts.length} tareas`;
    }).join("\n");

    rendimiento = (users ?? [])
      .filter((u: { rol: string }) => u.rol !== "gerente")
      .map((u: { id: string; nombre: string; rol: string }) => {
        const mias = (tareas ?? []).filter((t: { asignado_id: string }) => t.asignado_id === u.id);
        const ok = mias.filter((t: { estado: string }) => t.estado === "completa").length;
        return `${u.nombre} (${u.rol}): ${ok}/${mias.length} tareas completas`;
      }).join("\n");
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
        `PxSol rooms: ${rooms.length}. ` +
        rooms.slice(0, 24).map(r => r.name).join(", ") +
        `\nReservas PxSol recientes: ` +
        bookings.slice(0, 12).map((b) => {
          const a = (b as { attributes?: Record<string, unknown> }).attributes ?? {};
          return `${a.booking_id ?? ""} ${a.status ?? ""} ${a.check_in ?? ""} ${a.check_out ?? ""}`;
        }).join(" | ");
    }
  } catch (e) {
    pxsol = `PxSol no disponible: ${e instanceof Error ? e.message : "error"}`;
  }

  return { mapa: mapaTxt, objetivos, rendimiento, pxsol };
}

async function conLlm(rama: string, pregunta: string, ctx: Ctx): Promise<string | null> {
  const key = Deno.env.get("OPENAI_API_KEY");
  if (!key) return null;
  const sistema = rama === "gerente"
    ? "Eres Hormiga, asistente de gerencia del Hotel Break (Manizales). Hablas español colombiano, corto y concreto. Monitoreas a TI y Administración: objetivos, tareas, PDFs subidos, ocupación. Puedes hablar de PxSol (huéspedes, habitaciones, estados). No inventes números que no estén en el contexto."
    : "Eres Byte, asistente de IT Break. Rama técnica separada de gerencia. Respondes en español colombiano sobre PxSol: habitaciones, huéspedes, estados, ocupación. No hables de rendimiento de empleados ni zumbidos. No inventes datos.";

  const res = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4o-mini",
      temperature: 0.3,
      messages: [
        { role: "system", content: sistema },
        { role: "user", content: `CONTEXTO\nMAPA:\n${ctx.mapa}\n\nOBJETIVOS:\n${ctx.objetivos}\n\nRENDIMIENTO:\n${ctx.rendimiento}\n\nPXSOL:\n${ctx.pxsol}\n\nPREGUNTA:\n${pregunta}` },
      ],
    }),
  });
  if (!res.ok) return null;
  const jsonBody = await res.json();
  return jsonBody.choices?.[0]?.message?.content ?? null;
}

function responderLocal(rama: string, pregunta: string, ctx: Ctx): string {
  const q = norm(pregunta);

  if (rama === "gerente" && (q.includes("rendim") || q.includes("equipo") || q.includes("tareas"))) {
    return ctx.rendimiento
      ? `Así va el equipo:\n${ctx.rendimiento}\n\nObjetivos:\n${ctx.objetivos || "Sin objetivos."}`
      : "Todavía no hay tareas cargadas para medir al equipo.";
  }
  if (rama === "gerente" && (q.includes("objetivo") || q.includes("tablero") || q.includes("it break"))) {
    return ctx.objetivos || "No hay objetivos en el tablero todavía.";
  }

  const num = pregunta.match(/\b([1-4]\d{2})\b/);
  if (num && ctx.mapa.includes(num[1])) {
    const linea = ctx.mapa.split("\n").find(l => l.startsWith(num[1])) ?? "";
    return linea
      ? `Habitación ${num[1]}: ${linea}.`
      : `No encontré la ${num[1]} en el mapa de hoy.`;
  }

  if (q.includes("ocup") || q.includes("mapa") || q.includes("habitacion")) {
    return ctx.mapa.split("\n").slice(0, 8).join("\n");
  }
  if (q.includes("pxsol") || q.includes("reserva") || q.includes("huesped")) {
    return (ctx.pxsol || ctx.mapa).slice(0, 900);
  }

  if (rama === "ti") {
    return `Byte · PxSol/ocupación:\n${ctx.mapa.split("\n")[0]}\n${(ctx.pxsol || "Sin payload PxSol en este momento; uso el mapa interno sincronizado.").slice(0, 500)}`;
  }
  return `Hormiga · ${ctx.mapa.split("\n")[0]}\n${ctx.rendimiento || "Sin métricas de equipo aún."}`;
}
