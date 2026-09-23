// supabase/functions/siigo-sync-compra/index.ts
//
// Toma una fila de compras_inbox y crea la factura de compra en Siigo
// vía POST /v1/purchases. Body: { "compra_id": "uuid" }. Solo gerente.

import {
  buildPurchasePayload,
  buildSupplierPayload,
  idempotencyKeyCompra,
} from "../_shared/compra-mapper.ts";
import { parseDianArchivo } from "../_shared/dian-zip-parser.ts";
import { createPurchase, ensureSupplier } from "../_shared/siigo-client.ts";
import { getSupabaseAdmin, logSync } from "../_shared/supabase-admin.ts";

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

  const supabase = getSupabaseAdmin();
  let compraId: string | null = null;

  try {
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
    if (!perfil || perfil.rol !== "gerente") {
      return json({ ok: false, error: "Solo gerente puede enviar a Siigo" }, 403);
    }

    const body = await req.json().catch(() => ({}));
    compraId = (body as { compra_id?: string }).compra_id ?? null;
    if (!compraId) return json({ ok: false, error: "Falta compra_id" }, 400);

    const { data: compra, error: cErr } = await supabase
      .from("compras_inbox")
      .select("*")
      .eq("id", compraId)
      .single();
    if (cErr || !compra) return json({ ok: false, error: "Compra no encontrada" }, 404);

    if (compra.estado === "enviado_siigo" && compra.siigo_compra_id) {
      return json({
        ok: true,
        already: true,
        siigo_compra_id: compra.siigo_compra_id,
        siigo_compra_name: compra.siigo_compra_name,
      });
    }

    if (!compra.archivo_path) {
      return json({
        ok: false,
        error: "Esta fila no tiene archivo ZIP/XML. Súbelo primero.",
      }, 400);
    }

    const { data: fileBlob, error: dlErr } = await supabase.storage
      .from("facturas-compra")
      .download(compra.archivo_path);
    if (dlErr || !fileBlob) {
      throw new Error(`No se pudo leer el archivo: ${dlErr?.message ?? "sin data"}`);
    }

    const bytes = new Uint8Array(await fileBlob.arrayBuffer());
    const { parsed } = await parseDianArchivo(
      bytes,
      compra.archivo_mime || compra.archivo_nombre || "factura.zip",
    );

    await supabase.from("compras_inbox").update({
      cufe: parsed.cufe,
      prefijo: parsed.prefijo,
      numero_factura: parsed.numero_factura,
      fecha_factura: parsed.fecha_factura,
      proveedor_nit: parsed.proveedor_nit,
      proveedor_nombre: parsed.proveedor_nombre,
      receptor_nit: parsed.receptor_nit,
      moneda: parsed.moneda,
      subtotal: parsed.subtotal,
      iva: parsed.iva,
      total: parsed.total,
      lineas: parsed.lineas,
      parse_error: null,
      estado: "listo",
    }).eq("id", compraId);

    await ensureSupplier(buildSupplierPayload(parsed));
    const created = await createPurchase(
      buildPurchasePayload(parsed),
      idempotencyKeyCompra(parsed),
    );

    await supabase.from("compras_inbox").update({
      estado: "enviado_siigo",
      siigo_compra_id: created.id,
      siigo_compra_name: created.name ?? null,
      siigo_sync_at: new Date().toISOString(),
      siigo_error: null,
      revisado_por: userData.user.id,
      revisado_at: new Date().toISOString(),
    }).eq("id", compraId);

    await logSync({
      integracion: "siigo",
      evento: "compra_creada",
      referencia_id: compraId,
      estado: "ok",
      detalle: {
        siigo_id: created.id,
        name: created.name,
        proveedor: parsed.proveedor_nit,
        total: parsed.total,
      },
    });

    return json({
      ok: true,
      siigo_compra_id: created.id,
      siigo_compra_name: created.name,
      total: created.total ?? parsed.total,
    });
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    if (compraId) {
      await supabase.from("compras_inbox").update({
        estado: "error",
        siigo_error: message.slice(0, 1000),
      }).eq("id", compraId);
      await logSync({
        integracion: "siigo",
        evento: "compra_creada",
        referencia_id: compraId,
        estado: "error",
        detalle: { message },
      });
    }
    return json({ ok: false, error: message }, 500);
  }
});
