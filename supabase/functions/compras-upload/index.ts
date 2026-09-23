// supabase/functions/compras-upload/index.ts
//
// Upload manual de ZIP/XML DIAN desde el panel admin → compras_inbox.
// JWT staff (gerente).

import { guardarCompraDesdeBytes } from "../_shared/compras-inbox.ts";
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

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ ok: false, error: "Método no permitido" }, 405);

  try {
    const auth = req.headers.get("Authorization") ?? "";
    const jwt = auth.replace(/^Bearer\s+/i, "");
    if (!jwt) return json({ ok: false, error: "Sin autorización" }, 401);

    const supabase = getSupabaseAdmin();
    const { data: userData, error: userErr } = await supabase.auth.getUser(jwt);
    if (userErr || !userData.user) return json({ ok: false, error: "Sesión inválida" }, 401);

    const { data: perfil } = await supabase
      .from("usuarios")
      .select("rol")
      .eq("id", userData.user.id)
      .maybeSingle();

    if (!perfil || !["gerente", "recepcion"].includes(perfil.rol)) {
      return json({ ok: false, error: "Sin permiso" }, 403);
    }

    const form = await req.formData();
    const archivo = form.get("archivo");
    if (!(archivo instanceof File)) {
      return json({ ok: false, error: "Falta el archivo ZIP/XML" }, 400);
    }
    if (archivo.size > 5 * 1024 * 1024) {
      return json({ ok: false, error: "El archivo supera 5 MB" }, 400);
    }

    const bytes = new Uint8Array(await archivo.arrayBuffer());
    const result = await guardarCompraDesdeBytes({
      bytes,
      nombre: archivo.name || "factura.zip",
      mime: archivo.type || "application/zip",
      origen: "manual",
      creado_por: userData.user.id,
    });

    return json({ ok: true, ...result });
  } catch (err) {
    return json({ ok: false, error: err instanceof Error ? err.message : String(err) }, 500);
  }
});
