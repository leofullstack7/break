// Subida de foto/audio del chat por habitación.
// Huésped: token del QR. Staff: JWT de sesión.

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

const MIME_OK = new Set([
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/gif",
  "audio/webm",
  "audio/mp4",
  "audio/mpeg",
  "audio/ogg",
  "audio/wav",
  "audio/aac",
  "audio/x-m4a",
]);

function extDeMime(mime: string, tipo: string) {
  if (mime.includes("png")) return "png";
  if (mime.includes("webp")) return "webp";
  if (mime.includes("gif")) return "gif";
  if (mime.includes("mp4") || mime.includes("m4a")) return "m4a";
  if (mime.includes("mpeg")) return "mp3";
  if (mime.includes("ogg")) return "ogg";
  if (mime.includes("wav")) return "wav";
  if (mime.includes("webm")) return tipo === "audio" ? "webm" : "webm";
  return tipo === "audio" ? "webm" : "jpg";
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ ok: false, error: "Método no permitido" }, 405);

  try {
    const form = await req.formData();
    const token = String(form.get("token") ?? "").trim();
    const tipo = String(form.get("tipo") ?? "imagen");
    const archivo = form.get("archivo");

    if (tipo !== "imagen" && tipo !== "audio") {
      return json({ ok: false, error: "Tipo inválido" }, 400);
    }
    if (!(archivo instanceof File)) {
      return json({ ok: false, error: "Falta el archivo" }, 400);
    }
    if (archivo.size > 12 * 1024 * 1024) {
      return json({ ok: false, error: "El archivo supera 12 MB" }, 400);
    }

    const mime = archivo.type || (tipo === "audio" ? "audio/webm" : "image/jpeg");
    if (!MIME_OK.has(mime)) {
      return json({ ok: false, error: "Formato no permitido" }, 400);
    }

    const supabase = getSupabaseAdmin();
    let carpeta = "staff";

    if (token) {
      const { data: hab, error } = await supabase
        .from("habitaciones")
        .select("id, chat_token")
        .eq("chat_token", token)
        .maybeSingle();
      if (error || !hab) return json({ ok: false, error: "Token inválido" }, 403);
      carpeta = hab.chat_token;
    } else {
      const auth = req.headers.get("Authorization") ?? "";
      const jwt = auth.replace(/^Bearer\s+/i, "");
      if (!jwt) return json({ ok: false, error: "Sin autorización" }, 401);
      const { data: userData, error: userErr } = await supabase.auth.getUser(jwt);
      if (userErr || !userData.user) return json({ ok: false, error: "Sesión inválida" }, 401);
      const { data: perfil } = await supabase
        .from("usuarios")
        .select("rol")
        .eq("id", userData.user.id)
        .maybeSingle();
      if (!perfil || !["gerente", "recepcion", "marketing"].includes(perfil.rol)) {
        return json({ ok: false, error: "Sin permiso" }, 403);
      }
    }

    const ext = extDeMime(mime, tipo);
    const path = `${carpeta}/${crypto.randomUUID()}.${ext}`;
    const buffer = new Uint8Array(await archivo.arrayBuffer());

    const { error: upErr } = await supabase.storage
      .from("chat-adjuntos")
      .upload(path, buffer, { contentType: mime, upsert: false });

    if (upErr) return json({ ok: false, error: upErr.message }, 500);

    const { data: pub } = supabase.storage.from("chat-adjuntos").getPublicUrl(path);

    return json({ ok: true, path, url: pub.publicUrl, tipo });
  } catch (err) {
    return json({ ok: false, error: err instanceof Error ? err.message : "Error interno" }, 500);
  }
});
