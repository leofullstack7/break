// supabase/functions/pxsol-webhook/index.ts
//
// ESTADO: reservada para el futuro, NO activa todavía.
//
// La documentación pública de PxSol (https://developers.pxsol.com/)
// revisada el 15-ago-2026 NO menciona soporte de webhooks salientes.
// La sincronización actual depende enteramente de pxsol-sync (polling).
//
// Se deja este archivo como placeholder (verify_jwt=false en config.toml:
// un webhook real vendría sin JWT de Supabase, con su propia firma HMAC)
// para que, si PxSol agrega webhooks más adelante, solo haya que completar
// la verificación de firma y el parseo del payload real.
//
// NO exponer este endpoint como "funcional" ante el equipo hasta que se
// confirme con PxSol que existe y se implemente la verificación HMAC real.

import { logSync } from "../_shared/supabase-admin.ts";

Deno.serve(async (req: Request) => {
  await logSync({
    integracion: "pxsol",
    evento: "webhook_received_unconfigured",
    estado: "error",
    detalle: {
      note: "pxsol-webhook no está implementado: PxSol no documenta webhooks salientes. Usar pxsol-sync (polling).",
      method: req.method,
    },
  });

  return new Response(
    JSON.stringify({
      ok: false,
      message: "pxsol-webhook no está activo. La sincronización de PxSol es por polling (ver pxsol-sync).",
    }),
    { status: 501, headers: { "Content-Type": "application/json" } },
  );
});
