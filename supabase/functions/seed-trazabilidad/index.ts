// Crea usuarios IT BREAK + Administración y carga objetivos cumplidos con PDF.
import { getSupabaseAdmin } from "../_shared/supabase-admin.ts";

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
    if (existente) {
      creados.push(inf.titulo + " (ya existía)");
      continue;
    }

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

    const pdf = makePdf(inf.pdfTitulo, inf.pdfCuerpo);
    const path = `${it.id}/${crypto.randomUUID()}.pdf`;
    const { error: upErr } = await admin.storage
      .from("trazabilidad")
      .upload(path, pdf, { contentType: "application/pdf", upsert: false });
    if (upErr) throw new Error(upErr.message);

    await admin.from("trazabilidad_adjuntos").insert({
      objetivo_id: obj.id,
      nombre: inf.archivo,
      mime: "application/pdf",
      path,
      bytes: pdf.byteLength,
      subido_por: it.id,
    });
    creados.push(inf.titulo);
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

function informesTi() {
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
      pdfTitulo: "IT-01 Mostrador único",
      pdfCuerpo: [
        "Hotel Break Boutique, Manizales. Informe IT BREAK.",
        "La plataforma unifica reservas, huespedes, aseo, finanzas y conversaciones.",
        "Entrada: administracion.hotelbreakmanizales.com",
        "Antes: Base_de_Datos.xlsx, Break_1.xlsx, Ventas_2026.xlsx, Aseos.xlsx.",
        "Ahora el equipo mira el mismo edificio en tiempo real.",
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
      pdfTitulo: "IT-02 Ocupacion y PxSol",
      pdfCuerpo: [
        "El mapa usa v_mapa_habitaciones y el puente PxSol.",
        "Una reserva para hoy no cuenta como ocupada hasta las 15:00 Colombia.",
        "Bloqueos de PxSol se ven como habitacion en mantenimiento.",
        "Gerencia puede preguntar a Hormiga por un numero de habitacion o un huesped.",
        "IT pregunta lo mismo a Byte, sin mezclar el tablero de empleados.",
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
      pdfTitulo: "IT-03 Chat QR",
      pdfCuerpo: [
        "El huesped escanea el QR del estudio y habla sin login.",
        "Recepcion ve el hilo en Conversaciones, con el nombre completo.",
        "Al final del chat se invita a calificar en Google.",
        "Los adjuntos viven en storage chat-adjuntos.",
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
      pdfTitulo: "IT-04 Siigo y compras",
      pdfCuerpo: [
        "Desde Reservas se autoriza la factura electronica en Siigo.",
        "Las compras llegan por correo o se suben a mano como ZIP DIAN.",
        "El modulo Compras lista pendientes, listas y enviadas a Siigo.",
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
      pdfTitulo: "IT-05 PWA y trazabilidad",
      pdfCuerpo: [
        "El panel es una PWA. Se instala en el celular del equipo.",
        "Claves del hotel detras de PIN. Usuarios TI y Administracion.",
        "Cada tarea puede llevar PDF, Word o JPG.",
        "Gerencia zumbido: vibra el celular del empleado si la app esta abierta.",
      ],
    },
  ];
}

function makePdf(title: string, lines: string[]): Uint8Array {
  const safe = (s: string) => s.replace(/\\/g, "\\\\").replace(/\(/g, "\\(").replace(/\)/g, "\\)");
  const content: string[] = [
    "BT",
    "/F1 16 Tf",
    "50 760 Td",
    `(${safe(title)}) Tj`,
    "/F1 10 Tf",
    "0 -28 Td",
    "(Break Hotel Boutique · IT BREAK · 2026) Tj",
  ];
  for (const line of lines) {
    content.push("0 -18 Td", `(${safe(line)}) Tj`);
  }
  content.push("ET");
  const stream = content.join("\n");
  const objects = [
    "1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj",
    "2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj",
    "3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >> endobj",
    `4 0 obj << /Length ${stream.length} >> stream\n${stream}\nendstream endobj`,
    "5 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj",
  ];
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
