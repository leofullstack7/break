// supabase/functions/pxsol-ocupacion-sync/index.ts
//
// Sincroniza ocupación real desde PxSol → habitaciones/reservas Break.
// Fuente:
//   1) /booking/list  → habitación física (physical_rooms.name = "303")
//   2) /ota/.../bookings/pending → quién está in-house hoy
//   3) /hotel/.../physical-rooms + /ota/.../availability → bloqueos
//      (PxSol no expone OOO por unidad; se infiere por categoría)
//
// Invocable por el dashboard (JWT staff) o cron (service_role).

import {
  getOtaAvailabilityForDay,
  listBookingsDetailed,
  listHotelPhysicalRooms,
  listPendingBookings,
} from "../_shared/pxsol-client.ts";
import type { PxSolBookingListItem } from "../_shared/pxsol-types.ts";
import {
  getIntegracionConfig,
  getSupabaseAdmin,
  logSync,
  setIntegracionConfig,
} from "../_shared/supabase-admin.ts";

const BLOQUEOS_CONFIG_KEY = "pxsol_bloqueos_activos";

function todayBogotaISO(): string {
  // Colombia UTC-5 sin DST
  return new Date(Date.now() - 5 * 3600_000).toISOString().slice(0, 10);
}

function hotelId(): string {
  return Deno.env.get("PXSOL_HOTEL_ID") ?? "27224";
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function isInHouse(checkIn: string, checkOut: string, today: string): boolean {
  return checkIn <= today && checkOut > today;
}

function parseNumeroHabitacion(name: string | null | undefined): number | null {
  if (!name) return null;
  const n = Number.parseInt(String(name).trim(), 10);
  return Number.isFinite(n) ? n : null;
}

function mapEstadoReserva(state: string | undefined, checkIn: string, today: string): "activa" | "confirmada" {
  const s = (state ?? "").toLowerCase();
  if (s === "inhouse" || s === "checkin" || s === "checked_in") return "activa";
  if (checkIn <= today) return "activa";
  return "confirmada";
}

/**
 * Por categoría: vendibles (availability.quantity) + ocupadas conocidas
 * → el resto de unidades físicas se tratan como bloqueadas/fuera de venta.
 * Si no sabemos cuáles exactamente, priorizamos las ya marcadas por sync
 * anterior y completamos de forma estable por número de habitación.
 */
function elegirBloqueadas(opts: {
  porCategoria: Map<string, number[]>;
  ocupadas: Set<number>;
  quantityPorCategoria: Map<string, number>;
  prevBloqueadas: number[];
}): number[] {
  const elegidas: number[] = [];
  const prevSet = new Set(opts.prevBloqueadas);

  for (const [catId, numeros] of opts.porCategoria) {
    const libres = numeros
      .filter((n) => !opts.ocupadas.has(n))
      .sort((a, b) => a - b);
    if (libres.length === 0) continue;

    const qty = opts.quantityPorCategoria.get(catId);
    // Si falta inventario para esa categoría, no inventamos bloqueos
    if (qty === undefined) continue;

    const bloqueadasNecesarias = Math.max(0, libres.length - Math.max(0, qty));
    if (bloqueadasNecesarias === 0) continue;

    const preferidas = libres.filter((n) => prevSet.has(n));
    const resto = libres.filter((n) => !prevSet.has(n));
    const pick = [...preferidas, ...resto].slice(0, bloqueadasNecesarias);
    elegidas.push(...pick);
  }

  return [...new Set(elegidas)].sort((a, b) => a - b);
}

Deno.serve(async (_req: Request) => {
  const supabase = getSupabaseAdmin();
  const today = todayBogotaISO();
  const hid = hotelId();

  const stats = {
    hoy: today,
    listados: 0,
    in_house: 0,
    upserted: 0,
    liberadas: 0,
    sin_habitacion: 0,
    bloqueadas: 0,
    bloqueos_liberados: 0,
    errores: 0,
  };

  try {
    const [detailed, pendingRes, physicalRooms, dayAvail] = await Promise.all([
      listBookingsDetailed({ hotelId: hid, page: 1, perPage: 100 }),
      listPendingBookings(hid),
      listHotelPhysicalRooms(hid),
      getOtaAvailabilityForDay(hid, today),
    ]);

    stats.listados = detailed.length;

    const byId = new Map<string, PxSolBookingListItem>();
    for (const item of detailed) {
      if (item?.booking_id) byId.set(String(item.booking_id), item);
    }

    // Priorizar IDs in-house desde pending OTA (más fiable para "quién está hoy")
    const pending = Object.values(pendingRes.data?.bookings ?? {});
    const inHouseIds = new Set<string>();
    for (const b of pending) {
      if (!b?.booking_id) continue;
      if (String(b.status).toLowerCase() === "cancelled") continue;
      if (isInHouse(b.checkin, b.checkout, today)) {
        inHouseIds.add(String(b.booking_id));
      }
    }

    // Completar con los del listado detallado que también estén in-house
    for (const item of detailed) {
      if (!item?.booking_id) continue;
      // noventa / checkout no ocupan aunque las fechas se solapen
      const state = String(item.reservation_state ?? "").toLowerCase();
      if (state === "noventa" || state === "checkout" || state === "cancelled" || state === "cancelada") {
        continue;
      }
      if (isInHouse(item.check_in, item.check_out, today)) {
        inHouseIds.add(String(item.booking_id));
      }
    }

    stats.in_house = inHouseIds.size;

    const { data: habitaciones, error: habErr } = await supabase
      .from("habitaciones")
      .select("id, numero, estado");
    if (habErr) throw habErr;

    const habByNumero = new Map<number, { id: string; numero: number; estado: string }>();
    for (const h of habitaciones ?? []) {
      habByNumero.set(h.numero, h);
    }

    const ocupadasPxsol = new Set<string>(); // habitacion_id
    const ocupadasNumeros = new Set<number>();
    const bookingIdsActivos: string[] = [];

    for (const bookingId of inHouseIds) {
      try {
        const item = byId.get(bookingId);
        if (!item) {
          stats.sin_habitacion++;
          continue;
        }

        const phys = (item.physical_rooms ?? []).find((p) => p.assigned !== false) ??
          (item.physical_rooms ?? [])[0];
        const numero = parseNumeroHabitacion(phys?.name);
        if (!numero || !habByNumero.has(numero)) {
          stats.sin_habitacion++;
          await logSync({
            integracion: "pxsol",
            evento: "ocupacion_sin_habitacion",
            referencia_id: bookingId,
            estado: "error",
            detalle: { physical_rooms: item.physical_rooms, guest: item.guest_details },
          });
          continue;
        }

        const hab = habByNumero.get(numero)!;
        const nombre = [item.guest_details?.name, item.guest_details?.last_name]
          .filter(Boolean)
          .join(" ")
          .trim() || `Huésped PxSol #${bookingId}`;
        const celular = item.guest_details?.phone ?? null;
        const correo = item.guest_details?.email ?? null;
        const cedula = `PXSOL-${bookingId}`;
        const pago = Number(item.subtotal ?? 0) + Number(item.taxes ?? 0);
        const estado = mapEstadoReserva(item.reservation_state, item.check_in, today);
        const canal = item.origin || item.source || "PxSol";

        const { data: huespedExistente } = await supabase
          .from("huespedes")
          .select("id")
          .eq("cedula", cedula)
          .maybeSingle();

        let huespedId = huespedExistente?.id as string | undefined;
        if (huespedId) {
          await supabase
            .from("huespedes")
            .update({
              nombre,
              celular,
              correo,
              deleted_at: null,
              updated_at: new Date().toISOString(),
            })
            .eq("id", huespedId);
        } else {
          const { data: creado, error: hErr } = await supabase
            .from("huespedes")
            .insert({
              nombre,
              cedula,
              celular,
              correo,
              nacionalidad: "colombiana",
            })
            .select("id")
            .single();
          if (hErr) throw hErr;
          huespedId = creado.id;
        }

        const payloadReserva = {
          habitacion_id: hab.id,
          huesped_id: huespedId,
          fecha_entrada: item.check_in,
          fecha_salida: item.check_out,
          pago_total: Number.isFinite(pago) ? pago : 0,
          estado,
          canal_origen: String(canal),
          observaciones: `Sync PxSol · ${item.reservation_state ?? "n/a"} · hab ${numero}`,
          pxsol_booking_id: bookingId,
          pxsol_raw: item,
          pxsol_sync_at: new Date().toISOString(),
          deleted_at: null,
        };

        const { data: reservaExistente } = await supabase
          .from("reservas")
          .select("id, estado")
          .eq("pxsol_booking_id", bookingId)
          .maybeSingle();

        if (reservaExistente?.id) {
          const { error: uErr } = await supabase
            .from("reservas")
            .update(payloadReserva)
            .eq("id", reservaExistente.id);
          if (uErr) throw uErr;
        } else {
          const { error: iErr } = await supabase.from("reservas").insert(payloadReserva);
          if (iErr) throw iErr;
        }

        if (estado === "activa" && hab.estado !== "ocupada") {
          await supabase.from("habitaciones").update({ estado: "ocupada" }).eq("id", hab.id);
          hab.estado = "ocupada";
        }

        ocupadasPxsol.add(hab.id);
        ocupadasNumeros.add(numero);
        bookingIdsActivos.push(bookingId);
        stats.upserted++;
      } catch (err) {
        stats.errores++;
        await logSync({
          integracion: "pxsol",
          evento: "ocupacion_upsert",
          referencia_id: bookingId,
          estado: "error",
          detalle: { message: String(err) },
        });
      }
    }

    // Liberar reservas PxSol activas que ya no están in-house
    const { data: prevActivas } = await supabase
      .from("reservas")
      .select("id, habitacion_id, pxsol_booking_id, estado")
      .not("pxsol_booking_id", "is", null)
      .in("estado", ["confirmada", "activa"])
      .is("deleted_at", null);

    for (const r of prevActivas ?? []) {
      if (!r.pxsol_booking_id) continue;
      if (bookingIdsActivos.includes(String(r.pxsol_booking_id))) continue;

      await supabase
        .from("reservas")
        .update({
          estado: "completada",
          pxsol_sync_at: new Date().toISOString(),
        })
        .eq("id", r.id);

      if (r.habitacion_id && !ocupadasPxsol.has(r.habitacion_id)) {
        // No forzar disponible aquí: el paso de bloqueos decide mantenimiento vs libre
        await supabase
          .from("habitaciones")
          .update({ estado: "disponible" })
          .eq("id", r.habitacion_id)
          .neq("estado", "mantenimiento")
          .neq("estado", "aseo")
          .neq("estado", "ocupada");
      }
      stats.liberadas++;
    }

    // ── Bloqueos inferidos por inventario de categoría ──────────────
    const porCategoria = new Map<string, number[]>();
    for (const pr of physicalRooms) {
      const num = parseNumeroHabitacion(pr.name);
      if (!num || !habByNumero.has(num)) continue;
      const list = porCategoria.get(pr.categoryId) ?? [];
      list.push(num);
      porCategoria.set(pr.categoryId, list);
    }

    const quantityPorCategoria = new Map<string, number>();
    for (const a of dayAvail) {
      // closed=true → nada vendible ese día en la categoría
      quantityPorCategoria.set(a.roomId, a.closed ? 0 : a.quantity);
    }

    const prevBloqueadas =
      (await getIntegracionConfig<number[]>(BLOQUEOS_CONFIG_KEY)) ?? [];

    const bloqueadasNums = elegirBloqueadas({
      porCategoria,
      ocupadas: ocupadasNumeros,
      quantityPorCategoria,
      prevBloqueadas: Array.isArray(prevBloqueadas) ? prevBloqueadas : [],
    });
    const bloqueadasSet = new Set(bloqueadasNums);

    for (const num of bloqueadasNums) {
      const hab = habByNumero.get(num);
      if (!hab || ocupadasPxsol.has(hab.id)) continue;
      if (hab.estado === "aseo") continue; // respetar aseo operativo local
      if (hab.estado !== "mantenimiento") {
        await supabase.from("habitaciones").update({ estado: "mantenimiento" }).eq("id", hab.id);
        hab.estado = "mantenimiento";
      }
      stats.bloqueadas++;
    }

    // Liberar bloqueos previos del sync que ya no aplican
    for (const num of Array.isArray(prevBloqueadas) ? prevBloqueadas : []) {
      if (bloqueadasSet.has(num) || ocupadasNumeros.has(num)) continue;
      const hab = habByNumero.get(num);
      if (!hab) continue;
      if (hab.estado !== "mantenimiento") continue;
      await supabase.from("habitaciones").update({ estado: "disponible" }).eq("id", hab.id);
      hab.estado = "disponible";
      stats.bloqueos_liberados++;
    }

    await setIntegracionConfig(BLOQUEOS_CONFIG_KEY, bloqueadasNums);

    await logSync({
      integracion: "pxsol",
      evento: "ocupacion_sync",
      estado: "ok",
      detalle: {
        ...stats,
        bloqueadas_nums: bloqueadasNums,
        inventory: Object.fromEntries(quantityPorCategoria),
      },
    });

    // Si hubo altas/cambios de ocupación, intentar emparejar formularios pendientes.
    if (stats.upserted > 0) {
      const url = Deno.env.get("SUPABASE_URL");
      const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
      if (url && key) {
        const syncPromise = fetch(`${url}/functions/v1/formulario-sync`, {
          method: "POST",
          headers: {
            Authorization: `Bearer ${key}`,
            apikey: key,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            trigger: "pxsol_ocupacion",
            upserted: stats.upserted,
          }),
        }).catch((e) => console.error("formulario-sync trigger:", e));

        // @ts-ignore EdgeRuntime en Supabase Edge
        if (typeof EdgeRuntime !== "undefined" && EdgeRuntime?.waitUntil) {
          // @ts-ignore
          EdgeRuntime.waitUntil(syncPromise);
        }
      }
    }

    return jsonResponse({
      ok: true,
      ...stats,
      habitaciones_ocupadas: ocupadasPxsol.size,
      bloqueadas_nums: bloqueadasNums,
    });
  } catch (err) {
    await logSync({
      integracion: "pxsol",
      evento: "ocupacion_sync",
      estado: "error",
      detalle: { message: String(err) },
    });
    return jsonResponse({ ok: false, error: String(err), ...stats }, 500);
  }
});
