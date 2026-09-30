// Crea usuarios IT BREAK + Administración y carga objetivos cumplidos con PDF.
import { getSupabaseAdmin } from "../_shared/supabase-admin.ts";
import { buildBreakPdf, type PdfBlock } from "../_shared/break-pdf.ts";

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

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return json({ ok: true });
  const body = await req.json().catch(() => ({}));
  if (body.clave !== "BreakHormiga26") {
    return json({ ok: false, error: "Clave de seed inválida" }, 403);
  }
  const admin = getSupabaseAdmin();

  const it = await upsertUsuario(admin, {
    email: "it@breakmanizales.com",
    password: "BreakIT.5340*",
    nombre: "IT BREAK",
    rol: "ti",
  });
  const adm = await upsertUsuario(admin, {
    email: "administracion@breakmanizales.com",
    password: "BreakAdm.5340*",
    nombre: "Administración Break",
    rol: "administracion",
  });

  const informes = informesTi();
  const creados: string[] = [];

  for (const inf of informes) {
    const { data: existente } = await admin
      .from("objetivos")
      .select("id")
      .eq("owner_id", it.id)
      .eq("titulo", inf.titulo)
      .maybeSingle();
    let objetivoId = existente?.id as string | undefined;
    if (!objetivoId) {
      const { data: obj, error: oErr } = await admin
        .from("objetivos")
        .insert({
          titulo: inf.titulo,
          descripcion: inf.descripcion,
          area: "ti",
          estado: "cumplido",
          owner_id: it.id,
          fecha_objetivo: inf.fecha,
          cumplido_at: `${inf.fecha}T18:00:00-05:00`,
        })
        .select("id")
        .single();
      if (oErr || !obj) throw new Error(oErr?.message ?? "objetivo");
      objetivoId = obj.id;
      for (const [i, t] of inf.tareas.entries()) {
        await admin.from("tareas").insert({
          objetivo_id: obj.id,
          titulo: t,
          estado: "completa",
          asignado_id: it.id,
          created_by: it.id,
          orden: i,
          completada_at: `${inf.fecha}T17:00:00-05:00`,
        });
      }
    }

    const pdf = buildBreakPdf(inf.bloques);
    await reemplazarPdf(admin, objetivoId, it.id, inf.archivo, pdf);
    creados.push(existente ? inf.titulo + " (pdf nuevo)" : inf.titulo);
  }

  const { data: objAdm } = await admin
    .from("objetivos")
    .select("id")
    .eq("owner_id", adm.id)
    .eq("titulo", "Definir funciones por cargo")
    .maybeSingle();
  if (!objAdm) {
    await admin.from("objetivos").insert({
      titulo: "Definir funciones por cargo",
      descripcion: "Gerencia recortará accesos de TI y Administración cuando el mapa de funciones esté listo. Mientras tanto, ambos ven el panel gerencial.",
      area: "administracion",
      estado: "en_curso",
      owner_id: adm.id,
      fecha_objetivo: "2026-10-15",
    });
  }

  const { data: objSire } = await admin
    .from("objetivos")
    .select("id")
    .eq("titulo", "Actualización SIRE y TRA")
    .maybeSingle();
  let sireId = objSire?.id as string | undefined;
  if (!sireId) {
    const { data: sire } = await admin
      .from("objetivos")
      .insert({
        titulo: "Actualización SIRE y TRA",
        descripcion: "Reporte de extranjeros (SIRE) y TRA. Última carga a SIRE: 23 de septiembre de 2026. Queda el cierre del 24 en adelante.",
        area: "administracion",
        estado: "en_curso",
        owner_id: adm.id,
        fecha_objetivo: "2026-09-23",
      })
      .select("id")
      .single();
    sireId = sire?.id;
    if (sire) {
      const tareasSire = [
        { titulo: "Cargue SIRE de extranjeros hasta el 23 de septiembre", ok: true },
        { titulo: "Cruce TRA contra reservas del mes", ok: true },
        { titulo: "Revisión de documentos de llegada", ok: true },
        { titulo: "Ajustes de inconsistencias SIRE", ok: true },
        { titulo: "Cierre SIRE del 24 de septiembre en adelante", ok: false },
      ];
      for (const [i, t] of tareasSire.entries()) {
        await admin.from("tareas").insert({
          objetivo_id: sire.id,
          titulo: t.titulo,
          estado: t.ok ? "completa" : "pendiente",
          asignado_id: adm.id,
          created_by: adm.id,
          orden: i,
          completada_at: t.ok ? "2026-09-23T18:00:00-05:00" : null,
        });
      }
    }
  }
  if (sireId) {
    const pdfSire = buildBreakPdf([
      { kind: "meta", kicker: "SIRE", title: "SIRE y TRA", sub: "Última carga SIRE: 23 de septiembre de 2026  ·  Administración" },
      { kind: "kpi", items: [
        { label: "Avance", value: "80%" },
        { label: "Listas", value: "4/5" },
        { label: "Corte SIRE", value: "23 sep" },
      ]},
      { kind: "section", title: "Qué ya está" },
      { kind: "li", text: "Cargue SIRE de extranjeros hasta el 23 de septiembre.", strong: true },
      { kind: "li", text: "Cruce TRA contra reservas del mes." },
      { kind: "li", text: "Revisión de documentos de llegada." },
      { kind: "li", text: "Ajustes de inconsistencias SIRE." },
      { kind: "section", title: "Qué falta" },
      { kind: "li", text: "Cierre SIRE del 24 de septiembre en adelante.", strong: true },
      { kind: "p", text: "El tablero queda en 80% hasta que Administración cierre el tramo que sigue." },
    ]);
    await reemplazarPdf(admin, sireId, adm.id, "ADM-01-sire-tra.pdf", pdfSire);
    creados.push("Actualización SIRE y TRA (pdf nuevo)");
  }

  return json({
    ok: true,
    it: { id: it.id, email: it.email },
    administracion: { id: adm.id, email: adm.email },
    objetivos: creados,
  });
});

async function upsertUsuario(
  admin: ReturnType<typeof getSupabaseAdmin>,
  p: { email: string; password: string; nombre: string; rol: string },
) {
  const { data: existing } = await admin
    .from("usuarios")
    .select("id, email")
    .eq("email", p.email)
    .maybeSingle();
  if (existing) return existing as { id: string; email: string };

  const { data: created, error } = await admin.auth.admin.createUser({
    email: p.email,
    password: p.password,
    email_confirm: true,
  });
  if (error || !created.user) {
    const { data: list } = await admin.auth.admin.listUsers();
    const found = list.users.find(u => u.email === p.email);
    if (!found) throw new Error(error?.message ?? "no user");
    await admin.from("usuarios").upsert({
      id: found.id,
      nombre: p.nombre,
      rol: p.rol,
      email: p.email,
      activo: true,
    });
    return { id: found.id, email: p.email };
  }
  await admin.from("usuarios").insert({
    id: created.user.id,
    nombre: p.nombre,
    rol: p.rol,
    email: p.email,
    activo: true,
  });
  return { id: created.user.id, email: p.email };
}

async function reemplazarPdf(
  admin: ReturnType<typeof getSupabaseAdmin>,
  objetivoId: string,
  userId: string,
  archivo: string,
  pdf: Uint8Array,
) {
  const { data: olds } = await admin
    .from("trazabilidad_adjuntos")
    .select("id, path")
    .eq("objetivo_id", objetivoId);
  const paths = (olds ?? []).map((a: { path: string }) => a.path).filter(Boolean);
  if (paths.length) await admin.storage.from("trazabilidad").remove(paths);
  if (olds?.length) {
    await admin.from("trazabilidad_adjuntos").delete().eq("objetivo_id", objetivoId);
  }
  const path = `${userId}/${crypto.randomUUID()}.pdf`;
  const { error: upErr } = await admin.storage
    .from("trazabilidad")
    .upload(path, pdf, { contentType: "application/pdf", upsert: false });
  if (upErr) throw new Error(upErr.message);
  await admin.from("trazabilidad_adjuntos").insert({
    objetivo_id: objetivoId,
    nombre: archivo,
    mime: "application/pdf",
    path,
    bytes: pdf.byteLength,
    subido_por: userId,
  });
}

function informesTi(): {
  titulo: string
  descripcion: string
  fecha: string
  tareas: string[]
  archivo: string
  bloques: PdfBlock[]
}[] {
  return [
    {
      titulo: "Mostrador único Break Digital",
      descripcion: "Reemplazar los cuatro Excel por un panel único en el celular y el computador.",
      fecha: "2026-08-28",
      tareas: [
        "PWA admin en administracion.hotelbreakmanizales.com",
        "Login del equipo con roles",
        "Mapa de 24 estudios como pantalla de inicio",
      ],
      archivo: "IT-01-mostrador-unico.pdf",
      bloques: [
        { kind: "meta", kicker: "IT-01", title: "Mostrador único", sub: "28 de agosto de 2026  ·  IT BREAK  ·  cumplido" },
        { kind: "kpi", items: [
          { label: "Avance", value: "100%" },
          { label: "Área", value: "IT" },
          { label: "Tareas", value: "3/3" },
        ]},
        { kind: "section", title: "Qué se logró" },
        { kind: "li", text: "Un solo panel para reservas, huéspedes, aseo, finanzas y conversaciones.", strong: true },
        { kind: "li", text: "Entrada: administracion.hotelbreakmanizales.com" },
        { kind: "li", text: "El equipo ve el mismo edificio en el celular y en el computador." },
        { kind: "section", title: "De dónde veníamos" },
        { kind: "li", text: "Base_de_Datos.xlsx — CRM a mano" },
        { kind: "li", text: "Break_1.xlsx — una hoja por habitación" },
        { kind: "li", text: "Ventas_2026.xlsx — ocupación e ingresos" },
        { kind: "li", text: "Aseos.xlsx — control de limpieza" },
        { kind: "section", title: "Tareas cerradas" },
        { kind: "li", text: "PWA admin en el dominio de administración" },
        { kind: "li", text: "Login del equipo con roles" },
        { kind: "li", text: "Mapa de 24 estudios como pantalla de inicio" },
      ],
    },
    {
      titulo: "Ocupación en vivo y puente PxSol",
      descripcion: "El mapa no miente: ocupada solo después del check-in de las 15:00.",
      fecha: "2026-09-12",
      tareas: [
        "Sync PxSol de reservas y habitaciones físicas",
        "Estados: libre, reservada, hospedada, bloqueada",
        "Botón Actualizar PxSol en el dashboard",
      ],
      archivo: "IT-02-ocupacion-pxsol.pdf",
      bloques: [
        { kind: "meta", kicker: "IT-02", title: "Ocupación y PxSol", sub: "12 de septiembre de 2026  ·  IT BREAK  ·  cumplido" },
        { kind: "kpi", items: [
          { label: "Avance", value: "100%" },
          { label: "Estudios", value: "24" },
          { label: "Check-in", value: "15:00" },
        ]},
        { kind: "section", title: "Regla de oro" },
        { kind: "p", text: "Una reserva para hoy no pinta la cama ocupada hasta las 15:00 Colombia. Mesa reservada no es mesa ocupada." },
        { kind: "section", title: "Qué se ve en el mapa" },
        { kind: "li", text: "Libre — nadie durmió ahí.", strong: true },
        { kind: "li", text: "Reservada / llega 3pm — vendida, cama vacía." },
        { kind: "li", text: "Hospedada — ya hizo check-in." },
        { kind: "li", text: "Bloqueada — fuera de venta (mantenimiento PxSol)." },
        { kind: "section", title: "Tareas cerradas" },
        { kind: "li", text: "Sync PxSol de reservas y habitaciones físicas" },
        { kind: "li", text: "Botón Actualizar PxSol en el Inicio" },
        { kind: "li", text: "Hormiga y Byte leen el mismo mapa, en ramas distintas" },
      ],
    },
    {
      titulo: "Chat por QR y conversaciones",
      descripcion: "Cada estudio tiene un hilo con recepción. Foto, audio y texto.",
      fecha: "2026-09-16",
      tareas: [
        "QR por habitación /h/:token",
        "Bandeja admin con no leídos",
        "Puente a WhatsApp PxSol Conversaciones",
      ],
      archivo: "IT-03-chat-qr.pdf",
      bloques: [
        { kind: "meta", kicker: "IT-03", title: "Chat por QR", sub: "16 de septiembre de 2026  ·  IT BREAK  ·  cumplido" },
        { kind: "kpi", items: [
          { label: "Avance", value: "100%" },
          { label: "Canal", value: "QR" },
          { label: "WhatsApp", value: "PxSol" },
        ]},
        { kind: "section", title: "Para el huésped" },
        { kind: "li", text: "Escanea el QR del estudio y habla sin login.", strong: true },
        { kind: "li", text: "Texto, foto o audio." },
        { kind: "li", text: "Al final se invita a calificar en Google." },
        { kind: "section", title: "Para el equipo" },
        { kind: "li", text: "Globo de chat arriba a la derecha — no está en el menú." },
        { kind: "li", text: "Chats internos: número grande y nombre completo." },
        { kind: "li", text: "WhatsApp PxSol en el mismo interruptor." },
        { kind: "li", text: "Botón QRs para imprimir y pegar en cada estudio." },
      ],
    },
    {
      titulo: "Facturación Siigo y compras DIAN",
      descripcion: "Autorizar factura desde la reserva y subir ZIP de compras.",
      fecha: "2026-09-23",
      tareas: [
        "siigo-facturar-reserva desde el panel",
        "Bandeja compras_inbox + parser ZIP DIAN",
        "Valores en pesos completos, sin abreviar",
      ],
      archivo: "IT-04-siigo-compras.pdf",
      bloques: [
        { kind: "meta", kicker: "IT-04", title: "Siigo y compras DIAN", sub: "23 de septiembre de 2026  ·  IT BREAK  ·  cumplido" },
        { kind: "kpi", items: [
          { label: "Avance", value: "100%" },
          { label: "Factura", value: "Siigo" },
          { label: "Compras", value: "DIAN" },
        ]},
        { kind: "section", title: "Factura de venta" },
        { kind: "li", text: "No se dispara sola: alguien autoriza en Reservas.", strong: true },
        { kind: "li", text: "Cédula real o Consumidor Final." },
        { kind: "li", text: "Montos completos: $1.240.000, nunca 1.2M." },
        { kind: "section", title: "Compras" },
        { kind: "li", text: "Llegan por correo o se suben como ZIP DIAN." },
        { kind: "li", text: "El módulo Compras lista pendientes, listas y enviadas a Siigo." },
      ],
    },
    {
      titulo: "PWA, claves y trazabilidad de equipo",
      descripcion: "App instalable, bóveda de claves y tablero de objetivos con PDF.",
      fecha: "2026-09-28",
      tareas: [
        "PWA con service worker y recarga segura",
        "Bóveda de claves con PIN 2571",
        "Tablero de objetivos, zumbido y asistentes Hormiga/Byte",
      ],
      archivo: "IT-05-pwa-trazabilidad.pdf",
      bloques: [
        { kind: "meta", kicker: "IT-05", title: "PWA y trazabilidad", sub: "28 de septiembre de 2026  ·  IT BREAK  ·  cumplido" },
        { kind: "kpi", items: [
          { label: "Avance", value: "100%" },
          { label: "PIN claves", value: "2571" },
          { label: "IA", value: "2 ramas" },
        ]},
        { kind: "section", title: "App del equipo" },
        { kind: "li", text: "PWA instalable en el celular.", strong: true },
        { kind: "li", text: "Claves del hotel detrás del PIN 2571." },
        { kind: "li", text: "Usuarios IT BREAK y Administración, mismo panel gerencial por ahora." },
        { kind: "section", title: "Tablero" },
        { kind: "li", text: "Cada objetivo y cada tarea pueden llevar PDF, Word o JPG." },
        { kind: "li", text: "Gerencia abre el archivo ahí mismo, sin descargar." },
        { kind: "li", text: "Zumbido: vibra el celular del empleado si tiene el panel abierto." },
      ],
    },
    {
      titulo: "Carta al gerente — panorama de la casa",
      descripcion: "Resumen corto, en voz de amigo, de lo que ya vive en Break Digital.",
      fecha: "2026-09-28",
      tareas: [
        "Reunir lo que ya hace el panel",
        "Bajar los informes gerenciales a un lenguaje de pasillo",
        "Dejar el PDF para leerlo en el celular, sin descargar",
      ],
      archivo: "Carta-gerente-panorama.pdf",
      bloques: [
        { kind: "meta", kicker: "Carta", title: "El panorama de la casa", sub: "28 de septiembre de 2026  ·  para gerencia" },
        { kind: "kpi", items: [
          { label: "Estudios", value: "24" },
          { label: "Excel", value: "0" },
          { label: "Panel", value: "1" },
        ]},
        { kind: "p", text: "Parce, esto va corto y sin humo. No es un manual. Es para que sepas qué ya tienes en la casa." },
        { kind: "section", title: "En una frase" },
        { kind: "p", text: "Break Digital es el mostrador único. Los cuatro Excel cumplieron. Ahora todos miran el mismo edificio." },
        { kind: "section", title: "Cómo se usa" },
        { kind: "li", text: "Entras a administracion.hotelbreakmanizales.com y caes en el Inicio.", strong: true },
        { kind: "li", text: "Tocas un número: estado, huésped y chat de ese estudio." },
        { kind: "li", text: "Los chats están en el globo de arriba a la derecha, no en el menú." },
        { kind: "li", text: "Ocupada de verdad solo después de las 15:00." },
        { kind: "section", title: "Lo que ya vive" },
        { kind: "li", text: "Reservas, huéspedes, aseo, lavandería, finanzas, compras, marketing." },
        { kind: "li", text: "Factura Siigo con autorización humana. Claves detrás del PIN." },
        { kind: "li", text: "IT y Administración con usuario propio. Hormiga para ti, Byte para IT." },
        { kind: "section", title: "Lo que falta" },
        { kind: "li", text: "Que gerencia recorte qué ve cada cargo. El resto ya está en la casa.", strong: true },
      ],
    },
  ];
}
