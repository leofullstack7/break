// supabase/functions/siigo-sync-factura/index.ts
//
// Corazón del puente: toma los vouchers de PxSol ya guardados en
// pxsol_vouchers con siigo_estado = 'pendiente' (poblados por pxsol-sync),
// y crea la factura de venta correspondiente en Siigo.
//
// Reglas duras (ver ADR 01-ADR-pxsol-siigo-bridge.md):
//   - 1 voucher de PxSol = 1 factura en Siigo (Idempotency-Key = id del voucher).
//   - Solo se procesan vouchers con group_type = 'Venta' y status = 'Finished'.
//   - stamp: true → Siigo timbra ante la DIAN (decisión confirmada 15-ago-2026).
//   - Si falta un mapeo en siigo_catalogo_map, NO se inventa un valor por
//     defecto silencioso (salvo el fallback de ciudad, que sí queda
//     registrado) — se marca el voucher como error y se loguea, para que
//     alguien lo complete y se reintente.
//   - Máximo SIIGO_MAX_INTENTOS reintentos automáticos por voucher; después
//     queda en 'error' para el fallback manual (ver 04-secrets-riesgos-fallback.md).
//
// config.toml: verify_jwt = true. Pensado para correr encadenado después de
// pxsol-sync en el mismo cron (o en un cron propio unos minutos después).

import { getSupabaseAdmin, logSync } from "../_shared/supabase-admin.ts";
import { createInvoice, ensureCustomer } from "../_shared/siigo-client.ts";
import {
  MapeoFaltanteError,
  buildCustomerPayload,
  buildInvoiceItems,
  buildPayments,
} from "../_shared/factura-mapper.ts";
import type { PxSolVoucherAttributes, PxSolVoucherItem } from "../_shared/pxsol-types.ts";
import type { SiigoInvoicePayload } from "../_shared/siigo-types.ts";

const MAX_INTENTOS = 3;
const BATCH_SIZE = 25; // procesar en lotes chicos, no toda la cola de una vez

interface PxSolVoucherRow {
  id: number;
  voucher_raw: PxSolVoucherAttributes & { voucher_items?: PxSolVoucherItem[] };
  siigo_intentos: number;
  fecha_voucher: string | null;
}

function requiredEnvNumber(name: string): number {
  const raw = Deno.env.get(name);
  if (!raw) throw new Error(`Falta el secret ${name}.`);
  const n = Number(raw);
  if (Number.isNaN(n)) throw new Error(`El secret ${name} no es numérico: "${raw}".`);
  return n;
}

Deno.serve(async (_req: Request) => {
  const supabase = getSupabaseAdmin();

  const { data: pendientes, error } = await supabase
    .from("pxsol_vouchers")
    .select("id, voucher_raw, siigo_intentos, fecha_voucher")
    .eq("siigo_estado", "pendiente")
    .eq("group_type", "Venta")
    .eq("status", "Finished")
    .lt("siigo_intentos", MAX_INTENTOS)
    .order("fecha_voucher", { ascending: true })
    .limit(BATCH_SIZE);

  if (error) {
    await logSync({ integracion: "siigo", evento: "sync_factura_batch", estado: "error", detalle: { message: error.message } });
    return new Response(JSON.stringify({ ok: false, error: error.message }), { status: 500 });
  }

  let creadas = 0;
  let fallidas = 0;

  for (const row of (pendientes ?? []) as PxSolVoucherRow[]) {
    try {
      await procesarVoucher(row);
      creadas++;
    } catch (err) {
      fallidas++;
      await marcarError(row, err);
    }
  }

  await logSync({
    integracion: "siigo",
    evento: "sync_factura_batch",
    estado: "ok",
    detalle: { procesados: (pendientes ?? []).length, creadas, fallidas },
  });

  return new Response(JSON.stringify({ ok: true, creadas, fallidas }), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
});

async function procesarVoucher(row: PxSolVoucherRow): Promise<void> {
  const supabase = getSupabaseAdmin();
  const attrs = row.voucher_raw;
  const items = attrs.voucher_items ?? [];

  if (!items.length) {
    throw new Error("El voucher no trae voucher_items — no se puede facturar sin líneas.");
  }

  // Nota de crédito en vez de factura: fuera de alcance del primer corte de
  // esta función (ver ADR). Se marca 'omitido' para no bloquear la cola.
  if (attrs.credit_note) {
    await supabase
      .from("pxsol_vouchers")
      .update({ siigo_estado: "omitido", siigo_error: "Es nota crédito — pendiente de implementar POST /v1/credit-notes." })
      .eq("id", row.id);
    return;
  }

  const documentTypeId = requiredEnvNumber("SIIGO_DOCUMENT_TYPE_ID");
  const defaultSellerId = requiredEnvNumber("SIIGO_DEFAULT_SELLER_ID");
  const consumidorFinalId = Deno.env.get("SIIGO_CONSUMIDOR_FINAL_ID");

  const tieneDocumentoValido = !!(attrs.document_type && attrs.document_number);

  let customerIdentification: string;
  if (tieneDocumentoValido) {
    try {
      const customerPayload = await buildCustomerPayload(attrs);
      customerIdentification = await ensureCustomer(customerPayload);
    } catch (err) {
      if (err instanceof MapeoFaltanteError && consumidorFinalId) {
        // No hay mapeo de documento/ciudad para este huésped puntual:
        // se cae a Consumidor Final en vez de bloquear la factura,
        // pero queda log explícito para revisión.
        await logSync({
          integracion: "siigo",
          evento: "customer_fallback_consumidor_final",
          referencia_id: row.id,
          estado: "error",
          detalle: { message: err.message },
        });
        customerIdentification = consumidorFinalId;
      } else {
        throw err;
      }
    }
  } else {
    if (!consumidorFinalId) {
      throw new Error("Huésped sin documento válido y falta el secret SIIGO_CONSUMIDOR_FINAL_ID.");
    }
    customerIdentification = consumidorFinalId;
  }

  const invoiceItems = await buildInvoiceItems(items);
  const payments = await buildPayments(attrs);

  const payload: SiigoInvoicePayload = {
    document: { id: documentTypeId },
    date: attrs.date,
    customer: { identification: customerIdentification },
    seller: defaultSellerId,
    items: invoiceItems,
    payments,
    observations: `PxSol voucher #${row.id} · folio ${attrs.folio_name ?? "N/A"} · booking ${attrs.booking_id ?? "N/A"}`,
    stamp: true, // Siigo timbra ante la DIAN — decisión confirmada en el ADR
    mail: !!attrs.email,
  };

  const factura = await createInvoice(payload, String(row.id));

  await supabase
    .from("pxsol_vouchers")
    .update({
      siigo_estado: "facturado",
      siigo_factura_id: factura.id,
      siigo_numero: factura.number != null ? String(factura.number) : null,
      siigo_cufe: factura.cufe ?? null,
      siigo_pdf_url: factura.pdf?.file_name ?? null,
      siigo_error: null,
      siigo_sync_at: new Date().toISOString(),
    })
    .eq("id", row.id);

  await logSync({
    integracion: "siigo",
    evento: "invoice_create",
    referencia_id: row.id,
    estado: "ok",
    detalle: { siigo_factura_id: factura.id },
  });
}

async function marcarError(row: PxSolVoucherRow, err: unknown): Promise<void> {
  const supabase = getSupabaseAdmin();
  const nuevosIntentos = (row.siigo_intentos ?? 0) + 1;

  // Se queda en 'pendiente' para reintentar hasta agotar MAX_INTENTOS.
  // Solo entonces pasa a 'error' y entra al fallback manual.
  await supabase
    .from("pxsol_vouchers")
    .update({
      siigo_estado: nuevosIntentos >= MAX_INTENTOS ? "error" : "pendiente",
      siigo_error: String(err instanceof Error ? err.message : err).slice(0, 2000),
      siigo_intentos: nuevosIntentos,
      siigo_sync_at: new Date().toISOString(),
    })
    .eq("id", row.id);

  await logSync({
    integracion: "siigo",
    evento: "invoice_create",
    referencia_id: row.id,
    estado: "error",
    detalle: { message: String(err), intento: nuevosIntentos },
  });
}
