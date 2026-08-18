// supabase/functions/pxsol-auth/index.ts
//
// PxSol usa una API Key estática que un humano genera manualmente en la UI
// de PxSol (My API Keys) y pega como secret PXSOL_API_KEY. Por eso esta
// función NO obtiene ni renueva ningún token: solo hace un "health check"
// función NO obtiene ni renueva ningún token: solo hace un "health check"
// contra la API y deja constancia en integraciones_config de cuándo se
// verificó por última vez, para poder alertar antes de que la key expire.
//
// Uso recomendado: llamarla desde un cron aparte (ej. 1 vez al día) o antes
// de pxsol-sync como chequeo previo.
//
// config.toml: verify_jwt = true (solo se llama internamente / por cron con
// service_role, no expuesta a usuarios finales).

import { checkApiKeyAlive } from "../_shared/pxsol-client.ts";
import { logSync, setIntegracionConfig } from "../_shared/supabase-admin.ts";

Deno.serve(async (_req: Request) => {
  const alive = await checkApiKeyAlive();
  const checkedAt = new Date().toISOString();

  await setIntegracionConfig("pxsol_api_key_status", {
    last_checked_at: checkedAt,
    alive,
  });

  await logSync({
    integracion: "pxsol",
    evento: "api_key_health_check",
    estado: alive ? "ok" : "error",
    detalle: { checkedAt },
  });

  if (!alive) {
    console.error("[pxsol-auth] La PXSOL_API_KEY no respondió correctamente. Revisar expiración/permisos en PxSol.");
  }

  return new Response(JSON.stringify({ alive, checked_at: checkedAt }), {
    status: alive ? 200 : 502,
    headers: { "Content-Type": "application/json" },
  });
});
