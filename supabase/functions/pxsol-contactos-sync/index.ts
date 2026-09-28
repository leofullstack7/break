// supabase/functions/pxsol-contactos-sync/index.ts
//
// Sincroniza la lista de contactos/huéspedes desde PxSol → tabla huespedes.
//
// PxSol no documenta un endpoint CRM de contactos. Derivamos la lista desde:
//   1) GET /voucher/list/v2  → pax_id + nombre + email + documento
//   2) GET /booking/list     → guest_details (teléfono, email, nombre)
//
// Match order al upsert:
//   pxsol_pax_id → cédula/documento real → correo → crear nuevo
//
// Invocable desde /admin/huespedes (JWT staff) o cron (service_role).
// Body opcional: { "force": true } reinicia el cursor ~3 años atrás.

import { listBookingsDetailed, listVouchersV2 } from "../_shared/pxsol-client.ts";
import type { PxSolVoucherAttributes } from "../_shared/pxsol-types.ts";
import {
  getIntegracionConfig,
  getSupabaseAdmin,
  logSync,
  setIntegracionConfig,
} from "../_shared/supabase-admin.ts";

const CURSOR_KEY = "pxsol_contactos_sync_cursor";
const MAX_VOUCHER_PAGES = 40;
const MAX_BOOKING_PAGES = 20;
/** Primera sync / force: ~3 años atrás para traer contactos históricos. */
const FULL_LOOKBACK_MS = 3 * 365 * 24 * 60 * 60 * 1000;

interface ContactoPxsol {
  clave: string; // llave dedupe en esta corrida
  pxsol_pax_id: string | null;
  nombre: string;
  cedula: string | null;
  celular: string | null;
  correo: string | null;
  nacionalidad: string | null;
  raw: Record<string, unknown>;
  fuente: "voucher" | "booking";
}

interface Stats {
  vouchers_leidos: number;
  bookings_leidos: number;
  contactos_unicos: number;
  creados: number;
  actualizados: number;
  sin_cambios: number;
  errores: number;
  start_date: string;
  end_date: string;
}

function hotelId(): string {
  return Deno.env.get("PXSOL_HOTEL_ID") ?? "27224";
}

function formatForPxSol(date: Date): string {
  return date.toISOString().slice(0, 19).replace("T", " ");
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function limpiarTexto(v: unknown): string | null {
  if (v == null) return null;
  const s = String(v).trim();
  return s.length > 0 ? s : null;
}

function normalizarEmail(v: unknown): string | null {
  const e = limpiarTexto(v)?.toLowerCase() ?? null;
  if (!e || !e.includes("@")) return null;
  return e;
}

function normalizarCedula(v: unknown): string | null {
  const raw = limpiarTexto(v);
  if (!raw) return null;
  // Ignorar placeholders sintéticos
  if (/^PXSOL-/i.test(raw) || /^SIN_CC_/i.test(raw)) return null;
  // Solo dígitos / alfanumérico razonable
  const cleaned = raw.replace(/\s+/g, "");
  if (cleaned.length < 4) return null;
  return cleaned;
}

function nombreDesdeAttrs(attrs: PxSolVoucherAttributes): string {
  if (attrs.person_type === "Company" && attrs.social_reason) {
    return String(attrs.social_reason).trim();
  }
  const n = [attrs.name, attrs.last_name].filter(Boolean).join(" ").trim();
  return n || `Huésped PxSol #${attrs.pax_id ?? "s/n"}`;
}

function contactoDesdeVoucher(attrs: PxSolVoucherAttributes): ContactoPxsol | null {
  const paxId = attrs.pax_id != null ? String(attrs.pax_id) : null;
  const cedula = normalizarCedula(attrs.document_number);
  const correo = normalizarEmail(attrs.email);
  const nombre = nombreDesdeAttrs(attrs);

  if (!paxId && !cedula && !correo) return null;
  // Sin nombre útil y sin identificador estable → saltar
  if (!nombre && !paxId) return null;

  const clave = paxId
    ? `pax:${paxId}`
    : cedula
    ? `doc:${cedula}`
    : `email:${correo}`;

  return {
    clave,
    pxsol_pax_id: paxId,
    nombre: nombre || `Contacto PxSol`,
    cedula,
    celular: null, // vouchers no traen teléfono de forma fiable
    correo,
    nacionalidad: null,
    raw: attrs as unknown as Record<string, unknown>,
    fuente: "voucher",
  };
}

function contactoDesdeBooking(
  bookingId: string,
  guest: Record<string, unknown> | null | undefined,
): ContactoPxsol | null {
  if (!guest) return null;

  const paxId = guest.pax_id != null ? String(guest.pax_id) : null;
  const cedula = normalizarCedula(guest.document_number ?? guest.dni ?? guest.cedula);
  const correo = normalizarEmail(guest.email);
  const celular = limpiarTexto(guest.phone ?? guest.celular ?? guest.mobile);
  const nombre = [guest.name, guest.last_name]
    .filter(Boolean)
    .join(" ")
    .trim() || `Huésped PxSol #${bookingId}`;

  if (!paxId && !cedula && !correo && !celular) return null;

  const clave = paxId
    ? `pax:${paxId}`
    : cedula
    ? `doc:${cedula}`
    : correo
    ? `email:${correo}`
    : `booking:${bookingId}`;

  return {
    clave,
    pxsol_pax_id: paxId,
    nombre,
    cedula,
    celular,
    correo,
    nacionalidad: null,
    raw: { booking_id: bookingId, ...guest },
    fuente: "booking",
  };
}

/** Fusiona dos contactos de la misma clave; booking aporta teléfono, voucher documento. */
function mergeContacto(a: ContactoPxsol, b: ContactoPxsol): ContactoPxsol {
  return {
    clave: a.clave,
    pxsol_pax_id: a.pxsol_pax_id ?? b.pxsol_pax_id,
    nombre: a.nombre.length >= b.nombre.length ? a.nombre : b.nombre,
    cedula: a.cedula ?? b.cedula,
    celular: a.celular ?? b.celular,
    correo: a.correo ?? b.correo,
    nacionalidad: a.nacionalidad ?? b.nacionalidad,
    raw: { ...b.raw, ...a.raw, _fuentes: [a.fuente, b.fuente] },
    fuente: a.fuente === "voucher" || b.fuente === "voucher" ? "voucher" : a.fuente,
  };
}

function cedulaParaInsert(c: ContactoPxsol): string {
  if (c.cedula) return c.cedula;
  if (c.pxsol_pax_id) return `PXSOL-PAX-${c.pxsol_pax_id}`;
  if (c.correo) return `PXSOL-EMAIL-${c.correo.slice(0, 40)}`;
  return `PXSOL-TMP-${c.clave.replace(/[^a-zA-Z0-9]/g, "").slice(0, 40)}`;
}

Deno.serve(async (req: Request) => {
  const supabase = getSupabaseAdmin();
  const hid = hotelId();

  let force = false;
  try {
    if (req.method === "POST") {
      const body = await req.json().catch(() => ({}));
      force = Boolean((body as { force?: boolean })?.force);
    }
  } catch {
    // body vacío ok
  }

  const cursor = await getIntegracionConfig<{
    updated_at_start_date?: string;
  }>(CURSOR_KEY);

  const endDate = formatForPxSol(new Date());
  const startDate = force || !cursor?.updated_at_start_date
    ? formatForPxSol(new Date(Date.now() - FULL_LOOKBACK_MS))
    : cursor.updated_at_start_date;

  const stats: Stats = {
    vouchers_leidos: 0,
    bookings_leidos: 0,
    contactos_unicos: 0,
    creados: 0,
    actualizados: 0,
    sin_cambios: 0,
    errores: 0,
    start_date: startDate,
    end_date: endDate,
  };

  const porClave = new Map<string, ContactoPxsol>();

  try {
    // ── 1. Vouchers → contactos con pax_id / documento ────────────
    let page = 1;
    while (page <= MAX_VOUCHER_PAGES) {
      const list = await listVouchersV2({
        updatedAtStart: startDate,
        updatedAtEnd: endDate,
        page,
        perPage: 50,
      });

      if (!list.data?.length) break;

      for (const voucher of list.data) {
        stats.vouchers_leidos++;
        const contacto = contactoDesdeVoucher(voucher.attributes);
        if (!contacto) continue;
        const prev = porClave.get(contacto.clave);
        porClave.set(
          contacto.clave,
          prev ? mergeContacto(prev, contacto) : contacto,
        );
      }

      if (page >= (list.meta?.last_page ?? page)) break;
      page++;
    }

    // ── 2. Bookings → teléfono y datos de guest_details ───────────
    let bPage = 1;
    while (bPage <= MAX_BOOKING_PAGES) {
      let detailed: Awaited<ReturnType<typeof listBookingsDetailed>> = [];
      try {
        detailed = await listBookingsDetailed({
          hotelId: hid,
          page: bPage,
          perPage: 100,
        });
      } catch (err) {
        // Si /booking/list no está habilitado en la API Key, no abortamos:
        // los vouchers ya aportan la mayoría de contactos.
        await logSync({
          integracion: "pxsol",
          evento: "contactos_booking_list",
          estado: "error",
          detalle: { message: String(err), page: bPage },
        });
        break;
      }

      if (!detailed.length) break;
      stats.bookings_leidos += detailed.length;

      for (const item of detailed) {
        const bookingId = String(item.booking_id ?? "");
        if (!bookingId) continue;
        const contacto = contactoDesdeBooking(
          bookingId,
          item.guest_details as Record<string, unknown> | null,
        );
        if (!contacto) continue;

        // Si ya hay uno por pax/doc/email, fusionar; si no, indexar
        const prev = porClave.get(contacto.clave);
        if (prev) {
          porClave.set(contacto.clave, mergeContacto(prev, contacto));
        } else {
          // Intentar cruzar con un voucher del mismo email/doc
          let fused = false;
          for (const [k, existing] of porClave) {
            const samePax =
              contacto.pxsol_pax_id &&
              existing.pxsol_pax_id === contacto.pxsol_pax_id;
            const sameDoc =
              contacto.cedula && existing.cedula === contacto.cedula;
            const sameEmail =
              contacto.correo && existing.correo === contacto.correo;
            if (samePax || sameDoc || sameEmail) {
              porClave.set(k, mergeContacto(existing, contacto));
              fused = true;
              break;
            }
          }
          if (!fused) porClave.set(contacto.clave, contacto);
        }
      }

      if (detailed.length < 100) break;
      bPage++;
    }

    stats.contactos_unicos = porClave.size;

    // ── 3. Upsert en huespedes ────────────────────────────────────
    for (const contacto of porClave.values()) {
      try {
        const now = new Date().toISOString();
        let existente: {
          id: string;
          nombre: string;
          celular: string | null;
          correo: string | null;
          cedula: string;
          pxsol_pax_id: string | null;
        } | null = null;

        // Match 1: pxsol_pax_id
        if (contacto.pxsol_pax_id) {
          const { data } = await supabase
            .from("huespedes")
            .select("id, nombre, celular, correo, cedula, pxsol_pax_id")
            .eq("pxsol_pax_id", contacto.pxsol_pax_id)
            .maybeSingle();
          existente = data;
        }

        // Match 2: cédula real
        if (!existente && contacto.cedula) {
          const { data } = await supabase
            .from("huespedes")
            .select("id, nombre, celular, correo, cedula, pxsol_pax_id")
            .eq("cedula", contacto.cedula)
            .maybeSingle();
          existente = data;
        }

        // Match 3: correo
        if (!existente && contacto.correo) {
          const { data } = await supabase
            .from("huespedes")
            .select("id, nombre, celular, correo, cedula, pxsol_pax_id")
            .ilike("correo", contacto.correo)
            .is("deleted_at", null)
            .limit(1)
            .maybeSingle();
          existente = data;
        }

        if (existente?.id) {
          const update: Record<string, unknown> = {
            pxsol_sync_at: now,
            deleted_at: null,
            updated_at: now,
            pxsol_raw: contacto.raw,
          };

          if (contacto.pxsol_pax_id && !existente.pxsol_pax_id) {
            update.pxsol_pax_id = contacto.pxsol_pax_id;
          }
          // Solo enriquecer campos vacíos o mejorar cédula sintética
          if (contacto.celular && !existente.celular) {
            update.celular = contacto.celular;
          }
          if (contacto.correo && !existente.correo) {
            update.correo = contacto.correo;
          }
          if (
            contacto.cedula &&
            (/^PXSOL-/i.test(existente.cedula) || /^SIN_CC_/i.test(existente.cedula))
          ) {
            update.cedula = contacto.cedula;
          }
          if (contacto.nombre && contacto.nombre !== existente.nombre) {
            // Actualizar nombre si el actual es genérico de sync
            if (/^Huésped PxSol/i.test(existente.nombre) || /^Contacto PxSol/i.test(existente.nombre)) {
              update.nombre = contacto.nombre;
            }
          }

          const { error } = await supabase
            .from("huespedes")
            .update(update)
            .eq("id", existente.id);
          if (error) throw error;

          const cambioReal = Object.keys(update).some(
            (k) => !["pxsol_sync_at", "updated_at", "deleted_at", "pxsol_raw"].includes(k),
          );
          if (cambioReal) stats.actualizados++;
          else stats.sin_cambios++;
        } else {
          const { error } = await supabase.from("huespedes").insert({
            nombre: contacto.nombre,
            cedula: cedulaParaInsert(contacto),
            celular: contacto.celular,
            correo: contacto.correo,
            nacionalidad: contacto.nacionalidad ?? "colombiana",
            pxsol_pax_id: contacto.pxsol_pax_id,
            pxsol_raw: contacto.raw,
            pxsol_sync_at: now,
          });
          if (error) {
            // Colisión de cédula única: reintentar como update
            if (error.code === "23505" && contacto.cedula) {
              const { error: uErr } = await supabase
                .from("huespedes")
                .update({
                  pxsol_pax_id: contacto.pxsol_pax_id,
                  pxsol_raw: contacto.raw,
                  pxsol_sync_at: now,
                  celular: contacto.celular,
                  correo: contacto.correo,
                  deleted_at: null,
                  updated_at: now,
                })
                .eq("cedula", contacto.cedula);
              if (uErr) throw uErr;
              stats.actualizados++;
            } else {
              throw error;
            }
          } else {
            stats.creados++;
          }
        }
      } catch (err) {
        stats.errores++;
        await logSync({
          integracion: "pxsol",
          evento: "contacto_upsert",
          referencia_id: contacto.pxsol_pax_id ?? contacto.clave,
          estado: "error",
          detalle: { message: String(err), contacto },
        });
      }
    }

    await setIntegracionConfig(CURSOR_KEY, {
      updated_at_start_date: endDate,
      last_run_at: new Date().toISOString(),
      last_stats: stats,
    });

    await logSync({
      integracion: "pxsol",
      evento: "contactos_sync",
      estado: "ok",
      detalle: stats,
    });

    return jsonResponse({ ok: true, ...stats });
  } catch (err) {
    await logSync({
      integracion: "pxsol",
      evento: "contactos_sync",
      estado: "error",
      detalle: { message: String(err), ...stats },
    });
    return jsonResponse({ ok: false, error: String(err), ...stats }, 500);
  }
});
