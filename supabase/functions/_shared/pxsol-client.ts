// supabase/functions/_shared/pxsol-client.ts
//
// Cliente delgado para la API pública de PxSol (v2). PxSol usa una API Key
// estática: se genera en My API Keys y se pega como secret PXSOL_API_KEY.
// No hay intercambio OAuth — pxsol-auth solo valida que la key siga viva.
//
// Docs: https://developers.pxsol.com/

import type {
  PxSolBooking,
  PxSolBookingListItem,
  PxSolDayAvailability,
  PxSolPendingBooking,
  PxSolPhysicalRoom,
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

async function pxsolFetch<T>(
  path: string,
  params?: Record<string, string | number | undefined>,
): Promise<T> {
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
export async function getVoucherInfo(
  voucherId: number | string,
): Promise<PxSolVoucherInfoResponse> {
  return pxsolFetch<PxSolVoucherInfoResponse>(`/voucher/info/${voucherId}`);
}

/** Detalle de una reserva (útil para completar datos de huésped que el voucher no traiga). */
export async function getBooking(
  hotelId: number | string,
  bookingId: number | string,
): Promise<{ status: string; data: { booking: PxSolBooking } }> {
  return pxsolFetch(`/ota/hotels/${hotelId}/bookings/${bookingId}`);
}

/**
 * Listado detallado de reservas con habitación física y guest_details.
 * Endpoint documentado en integraciones PxSol: GET /booking/list
 */
export async function listBookingsDetailed(opts: {
  hotelId: string | number;
  page?: number;
  perPage?: number;
  checkInFrom?: string;
  checkInTo?: string;
}): Promise<PxSolBookingListItem[]> {
  const raw = await pxsolFetch<Record<string, unknown>>("/booking/list", {
    hotel_id: opts.hotelId,
    page: opts.page ?? 1,
    per_page: opts.perPage ?? 100,
    check_in_from: opts.checkInFrom,
    check_in_to: opts.checkInTo,
  });

  return normalizeBookingList(raw);
}

/** Reservas pending/in-house vía OTA. */
export async function listPendingBookings(
  hotelId: string | number,
): Promise<{ data?: { bookings?: Record<string, PxSolPendingBooking> } }> {
  return pxsolFetch(`/ota/hotels/${hotelId}/bookings/pending`);
}

/** Habitaciones físicas del hotel (nombre = número, ej. "303"). */
export async function listHotelPhysicalRooms(
  hotelId: string | number,
): Promise<PxSolPhysicalRoom[]> {
  const raw = await pxsolFetch<Record<string, unknown>>(
    `/hotel/${hotelId}/physical-rooms`,
  );

  const candidates = [
    raw.data,
    (raw.data as Record<string, unknown> | undefined)?.rooms,
    (raw.data as Record<string, unknown> | undefined)?.physical_rooms,
    raw.physical_rooms,
    raw.rooms,
    Array.isArray(raw) ? raw : null,
  ];

  for (const c of candidates) {
    if (Array.isArray(c)) {
      return c.map((r) => normalizePhysicalRoom(r as Record<string, unknown>));
    }
    if (c && typeof c === "object" && !Array.isArray(c)) {
      return Object.values(c as Record<string, unknown>).map((r) =>
        normalizePhysicalRoom(r as Record<string, unknown>)
      );
    }
  }
  return [];
}

/** Disponibilidad OTA de un día (por categoría). */
export async function getOtaAvailabilityForDay(
  hotelId: string | number,
  date: string,
): Promise<PxSolDayAvailability[]> {
  const raw = await pxsolFetch<Record<string, unknown>>(
    `/ota/hotels/${hotelId}/availability`,
    { start_date: date, end_date: date },
  );

  const list =
    (raw.data as unknown[]) ??
    (raw.availability as unknown[]) ??
    (Array.isArray(raw) ? raw : []);

  if (!Array.isArray(list)) return [];

  return list.map((item) => {
    const r = item as Record<string, unknown>;
    return {
      roomId: String(r.room_id ?? r.roomId ?? r.category_id ?? ""),
      quantity: Number(r.quantity ?? r.available ?? 0),
      closed: Boolean(r.closed ?? r.stop_sell ?? false),
      ...r,
    };
  });
}

/**
 * Chequeo simple de que la API Key sigue viva: pide 1 voucher. Se usa desde
 * pxsol-auth como "health check" ya que no hay endpoint de auth dedicado.
 */
export async function checkApiKeyAlive(): Promise<boolean> {
  try {
    await pxsolFetch<PxSolVoucherListResponse>("/voucher/list/v2", {
      per_page: 1,
      page: 1,
    });
    return true;
  } catch (err) {
    console.error("[pxsol] checkApiKeyAlive falló:", err);
    return false;
  }
}

// ── helpers de normalización ──────────────────────────────────────

function normalizeBookingList(raw: Record<string, unknown>): PxSolBookingListItem[] {
  const candidates = [
    raw.data,
    (raw.data as Record<string, unknown> | undefined)?.bookings,
    raw.bookings,
    Array.isArray(raw) ? raw : null,
  ];

  let items: unknown[] = [];
  for (const c of candidates) {
    if (Array.isArray(c)) {
      items = c;
      break;
    }
    if (c && typeof c === "object" && !Array.isArray(c)) {
      items = Object.values(c as Record<string, unknown>);
      break;
    }
  }

  return items.map((item) => normalizeBookingItem(item as Record<string, unknown>));
}

function normalizeBookingItem(r: Record<string, unknown>): PxSolBookingListItem {
  const guest = (r.guest_details ?? r.guest ?? r.customer ?? null) as
    | Record<string, unknown>
    | null;

  const checkIn = String(
    r.check_in ?? r.checkin ?? r.arrival ?? r.start_date ?? "",
  );
  const checkOut = String(
    r.check_out ?? r.checkout ?? r.departure ?? r.end_date ?? "",
  );

  return {
    ...r,
    booking_id: (r.booking_id ?? r.id ?? r.reservation_id) as string | number,
    check_in: checkIn,
    check_out: checkOut,
    reservation_state: String(
      r.reservation_state ?? r.status ?? r.state ?? "",
    ),
    guest_details: guest
      ? {
          name: (guest.name ?? guest.first_name ?? null) as string | null,
          last_name: (guest.last_name ?? guest.lastname ?? null) as string | null,
          phone: (guest.phone ?? guest.celular ?? guest.mobile ?? null) as
            | string
            | null,
          email: (guest.email ?? guest.correo ?? null) as string | null,
          document_number: (guest.document_number ?? guest.dni ?? guest.cedula ??
            null) as string | null,
          document_type: (guest.document_type ?? null) as string | null,
          pax_id: (guest.pax_id ?? guest.id ?? null) as string | number | null,
          ...guest,
        }
      : null,
    physical_rooms: Array.isArray(r.physical_rooms)
      ? (r.physical_rooms as PxSolBookingListItem["physical_rooms"])
      : Array.isArray(r.rooms)
      ? (r.rooms as PxSolBookingListItem["physical_rooms"])
      : [],
    subtotal: Number(r.subtotal ?? r.sub_total ?? 0),
    taxes: Number(r.taxes ?? r.iva ?? 0),
    origin: (r.origin as string | undefined) ?? undefined,
    source: (r.source as string | undefined) ?? undefined,
  };
}

function normalizePhysicalRoom(r: Record<string, unknown>): PxSolPhysicalRoom {
  return {
    ...r,
    id: (r.id ?? r.room_id) as string | number | undefined,
    name: (r.name ?? r.number ?? r.room_name ?? null) as string | null,
    categoryId: String(
      r.categoryId ?? r.category_id ?? r.room_type_id ?? r.category_code ?? "",
    ),
  };
}
