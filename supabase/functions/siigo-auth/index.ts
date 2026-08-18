// supabase/functions/siigo-auth/index.ts
//
// Fuerza la renovación del token de Siigo y lo deja cacheado en
// integraciones_config["siigo_token"]. En la práctica, siigo-client.ts
// (getValidSiigoToken) ya renueva automáticamente cuando el token cacheado
// está por expirar, así que esta función es principalmente para:
//   - un chequeo manual/cron independiente (alertar si las credenciales
//     dejaron de funcionar, sin esperar a que falle una factura real).
//   - forzar una renovación inmediata si se rotan SIIGO_USERNAME /
//     SIIGO_ACCESS_KEY.
//
// config.toml: verify_jwt = true.

import { getValidSiigoToken } from "../_shared/siigo-client.ts";
import { logSync } from "../_shared/supabase-admin.ts";

Deno.serve(async (_req: Request) => {
  try {
    const token = await getValidSiigoToken();
    await logSync({ integracion: "siigo", evento: "auth_check", estado: "ok" });

    return new Response(
      JSON.stringify({ ok: true, token_preview: `${token.slice(0, 8)}...` }),
      { status: 200, headers: { "Content-Type": "application/json" } },
    );
  } catch (err) {
    await logSync({
      integracion: "siigo",
      evento: "auth_check",
      estado: "error",
      detalle: { message: String(err) },
    });
    return new Response(JSON.stringify({ ok: false, error: String(err) }), {
      status: 502,
      headers: { "Content-Type": "application/json" },
    });
  }
});
