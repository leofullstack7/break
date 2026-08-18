// supabase/functions/_shared/pxsol-client.ts
//
// Cliente delgado para la API pública de PxSol (v2). PxSol usa una API Key
// estática: se genera en My API Keys y se pega como secret PXSOL_API_KEY.
// No hay intercambio OAuth — pxsol-auth solo valida que la key siga viva.
//
// Docs: https://developers.pxsol.com/

import type {
  PxSolBooking,
  PxSolVoucherInfoResponse,
  PxSolVoucherListResponse,
} from "./pxsol-types.ts";

function getBaseUrl(): string {
  const url = Deno.env.get("PXSOL_BASE_URL");
  if (!url) throw new Error("Falta PXSOL_BASE_URL en los secrets.");
  return url.replace(/\/$/, "");
}

function getApiKey(): string {
  const key = Deno.env.get("PXSOL_API_KEY");
  if (!key) throw new Error("Falta PXSOL_API_KEY en los secrets.");
  return key;
}

async function pxsolFetch<T>(path: string, params?: Record<string, string | number | undefined>): Promise<T> {
  const base = getBaseUrl();
  const url = new URL(`${base}${path}`);
  if (params) {
    for (const [k, v] of Object.entries(params)) {
      if (v !== undefined && v !== null) url.searchParams.set(k, String(v));
    }
  }

  const res = await fetch(url.toString(), {
    method: "GET",
    headers: {
      Authorization: `Bearer ${getApiKey()}`,
      Accept: "application/json",
    },
  });

  if (!res.ok) {
    const body = await res.text().catch(() => "");
    throw new Error(`PxSol API ${res.status} en ${path}: ${body.slice(0, 500)}`);
  }

  return (await res.json()) as T;
}

/**
 * Lista vouchers (facturas/recibos) generados en PxSol, filtrados por
 * ventana de actualización — pensado para correr cada 15-30 min tomando
 * `updated_at_start_date` desde el último cursor guardado en
 * integraciones_config["pxsol_sync_cursor"].
 */
export async function listVouchersV2(opts: {
  updatedAtStart?: string; // "YYYY-MM-DD HH:mm:ss"
  updatedAtEnd?: string;
  page?: number;
  perPage?: number;
}): Promise<PxSolVoucherListResponse> {
  return pxsolFetch<PxSolVoucherListResponse>("/voucher/list/v2", {
    updated_at_start_date: opts.updatedAtStart,
    updated_at_end_date: opts.updatedAtEnd,
    page: opts.page ?? 1,
    per_page: opts.perPage ?? 20,
  });
}

/** Detalle completo de un voucher, incluye voucher_items[] (línea a línea). */
export async function getVoucherInfo(voucherId: number | string): Promise<PxSolVoucherInfoResponse> {
  return pxsolFetch<PxSolVoucherInfoResponse>(`/voucher/info/${voucherId}`);
}

/** Detalle de una reserva (útil para completar datos de huésped que el voucher no traiga). */
export async function getBooking(hotelId: number | string, bookingId: number | string): Promise<{ status: string; data: { booking: PxSolBooking } }> {
  return pxsolFetch(`/ota/hotels/${hotelId}/bookings/${bookingId}`);
}

/**
 * Chequeo simple de que la API Key sigue viva: pide 1 voucher. Se usa desde
 * pxsol-auth como "health check" ya que no hay endpoint de auth dedicado.
 */
export async function checkApiKeyAlive(): Promise<boolean> {
  try {
    await pxsolFetch<PxSolVoucherListResponse>("/voucher/list/v2", { per_page: 1, page: 1 });
    return true;
  } catch (err) {
    console.error("[pxsol] checkApiKeyAlive falló:", err);
    return false;
  }
}
