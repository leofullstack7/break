// supabase/functions/pxsol-sync/index.ts
//
// Job periódico (cron sugerido: cada 15-30 min) que:
//   1. Lee vouchers nuevos/actualizados de PxSol desde el último cursor.
//   2. Los guarda (upsert) en pxsol_vouchers, sin transformar (voucher_raw).
//   3. Intenta cruzar cada voucher con una reserva existente por booking_id
//      (escritura quirúrgica: solo toca las columnas pxsol_* de reservas,
//      nunca los campos operativos que gestiona el staff).
//   4. Avanza el cursor en integraciones_config["pxsol_sync_cursor"].
//
// NO llama a Siigo directamente — eso lo hace siigo-sync-factura, leyendo
// de pxsol_vouchers con siigo_estado = 'pendiente'. Mantenerlos separados
// permite reintentar la parte contable sin volver a pegarle a PxSol.
//
// config.toml: verify_jwt = true (se invoca por cron/service_role, no por
// usuarios finales).

import { getVoucherInfo, listVouchersV2 } from "../_shared/pxsol-client.ts";
import {
  getIntegracionConfig,
  getSupabaseAdmin,
  logSync,
  setIntegracionConfig,
} from "../_shared/supabase-admin.ts";
import type { PxSolVoucherAttributes } from "../_shared/pxsol-types.ts";

const CURSOR_KEY = "pxsol_sync_cursor";
const MAX_PAGES_PER_RUN = 20; // corte de seguridad para no correr indefinidamente en una sola invocación

function formatForPxSol(date: Date): string {
  // PxSol espera "YYYY-MM-DD HH:mm:ss"
  return date.toISOString().slice(0, 19).replace("T", " ");
}

function toVoucherRow(id: number, attrs: PxSolVoucherAttributes) {
  return {
    id,
    booking_id: attrs.booking_id != null ? String(attrs.booking_id) : null,
    folio_id: attrs.folio_id ?? null,
    folio_name: attrs.folio_name ?? null,
    voucher_type: attrs.voucher_type ?? null,
    group_type: attrs.group_type ?? null,
    status: attrs.status ?? null,
    payment_type: attrs.payment_type ?? null,
    payment_status: attrs.payment_status ?? null,
    currency: attrs.currency ?? null,
    sub_total: attrs.sub_total ? Number(attrs.sub_total) : null,
    iva: attrs.iva ? Number(attrs.iva) : null,
    other_taxes: attrs.other_taxes ? Number(attrs.other_taxes) : null,
    total: attrs.total ? Number(attrs.total) : null,
    fecha_voucher: attrs.date ?? null,
    fecha_vencimiento: attrs.due_date ?? null,
    huesped_nombre: attrs.person_type === "Company"
      ? attrs.social_reason
      : [attrs.name, attrs.last_name].filter(Boolean).join(" ") || null,
    huesped_tipo_doc: attrs.document_type ?? null,
    huesped_num_doc: attrs.document_number ?? null,
    huesped_email: attrs.email ?? null,
    huesped_tipo_persona: attrs.person_type ?? null,
    has_credit_note: !!attrs.has_credit_note,
    credit_note: !!attrs.credit_note,
    credit_note_voucher_id: attrs.credit_note_voucher_id || null,
    pxsol_pdf_url: attrs.pdf ?? null,
    voucher_raw: attrs,
    pxsol_sync_at: new Date().toISOString(),
  };
}

Deno.serve(async (_req: Request) => {
  const supabase = getSupabaseAdmin();

  const cursor = await getIntegracionConfig<{ updated_at_start_date?: string }>(CURSOR_KEY);
  const startDate = cursor?.updated_at_start_date ?? formatForPxSol(new Date(Date.now() - 24 * 60 * 60 * 1000));
  const endDate = formatForPxSol(new Date());

  let page = 1;
  let totalUpserted = 0;
  let totalErrors = 0;

  try {
    while (page <= MAX_PAGES_PER_RUN) {
      const list = await listVouchersV2({
        updatedAtStart: startDate,
        updatedAtEnd: endDate,
        page,
        perPage: 20,
      });

      if (!list.data?.length) break;

      for (const voucher of list.data) {
        try {
          // Traemos el detalle (incluye voucher_items) porque list/v2 no
          // trae las líneas — necesarias para armar la factura en Siigo.
          const info = await getVoucherInfo(voucher.id);
          const attrs = info.data.attributes;

          const row = toVoucherRow(voucher.id, attrs);

          const { error: upsertError } = await supabase
            .from("pxsol_vouchers")
            .upsert(row, { onConflict: "id" });

          if (upsertError) throw upsertError;

          // Guardamos también voucher_items crudos dentro de voucher_raw
          // para que factura-mapper no tenga que volver a pegarle a PxSol.
          await supabase
            .from("pxsol_vouchers")
            .update({ voucher_raw: { ...attrs, voucher_items: info.data.attributes.voucher_items } })
            .eq("id", voucher.id);

          // Cruce quirúrgico: si ya hay una reserva con este booking_id de PxSol,
          // se enlaza el voucher. No se inventa match por huésped/fechas.
          if (attrs.booking_id) {
            const { data: reserva } = await supabase
              .from("reservas")
              .select("id")
              .eq("pxsol_booking_id", String(attrs.booking_id))
              .maybeSingle();

            if (reserva?.id) {
              await supabase
                .from("pxsol_vouchers")
                .update({ reserva_id: reserva.id })
                .eq("id", voucher.id);

              await supabase
                .from("reservas")
                .update({ pxsol_sync_at: new Date().toISOString() })
                .eq("id", reserva.id);
            }
          }

          totalUpserted++;
        } catch (voucherErr) {
          totalErrors++;
          await logSync({
            integracion: "pxsol",
            evento: "voucher_upsert",
            referencia_id: voucher.id,
            estado: "error",
            detalle: { message: String(voucherErr) },
          });
        }
      }

      if (page >= list.meta.last_page) break;
      page++;
    }

    await setIntegracionConfig(CURSOR_KEY, { updated_at_start_date: endDate });

    await logSync({
      integracion: "pxsol",
      evento: "voucher_list_pull",
      estado: "ok",
      detalle: { startDate, endDate, pages: page, totalUpserted, totalErrors },
    });

    return new Response(
      JSON.stringify({ ok: true, totalUpserted, totalErrors, startDate, endDate }),
      { status: 200, headers: { "Content-Type": "application/json" } },
    );
  } catch (err) {
    await logSync({
      integracion: "pxsol",
      evento: "voucher_list_pull",
      estado: "error",
      detalle: { message: String(err), startDate, endDate },
    });
    return new Response(JSON.stringify({ ok: false, error: String(err) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
