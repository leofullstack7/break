/**
 * Enlaces al panel PxSol Conversaciones (WhatsApp + bot).
 * Base documentada: https://pms.pxsol.com/
 *
 * PxSol no publica deep-links oficiales a un chat concreto.
 * Pasamos booking_id / teléfono / nombre como query para facilitar
 * búsqueda manual y por si el PMS los interpreta en el futuro.
 * Ajustable con VITE_PXSOL_CONVERSACIONES_URL.
 */

const DEFAULT_BASE = 'https://pms.pxsol.com/'

export function getPxsolConversacionesBaseUrl(): string {
  const fromEnv = import.meta.env.VITE_PXSOL_CONVERSACIONES_URL as string | undefined
  return (fromEnv?.trim() || DEFAULT_BASE).replace(/\/?$/, '/')
}

export function buildPxsolConversacionesUrl(opts?: {
  bookingId?: string | null
  telefono?: string | null
  nombre?: string | null
  habitacion?: number | string | null
}): string {
  const url = new URL(getPxsolConversacionesBaseUrl())

  // Pistas de navegación (no oficiales; inofensivas si el PMS las ignora)
  url.searchParams.set('app', 'conversaciones')
  url.searchParams.set('section', 'clientes')

  if (opts?.bookingId) url.searchParams.set('booking_id', String(opts.bookingId))
  if (opts?.habitacion != null) url.searchParams.set('room', String(opts.habitacion))
  if (opts?.nombre) url.searchParams.set('q', opts.nombre)
  if (opts?.telefono) {
    const digits = String(opts.telefono).replace(/\D/g, '')
    if (digits) url.searchParams.set('phone', digits)
  }

  return url.toString()
}

/** Abre Conversaciones en pestaña nueva (móvil / escritorio). */
export function abrirPxsolConversaciones(opts?: Parameters<typeof buildPxsolConversacionesUrl>[0]) {
  const href = buildPxsolConversacionesUrl(opts)
  window.open(href, '_blank', 'noopener,noreferrer')
}
