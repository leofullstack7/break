import { supabase, supabaseUrl } from '@/lib/supabase'

export interface SyncContactosResultado {
  ok: boolean
  vouchers_leidos?: number
  bookings_leidos?: number
  contactos_unicos?: number
  creados?: number
  actualizados?: number
  sin_cambios?: number
  errores?: number
  start_date?: string
  end_date?: string
  error?: string
}

/**
 * Dispara sync de contactos PxSol → huespedes.
 * Requiere sesión staff. Con force=true reinicia el cursor (~3 años atrás).
 */
export async function syncContactosPxsol(
  opts: { force?: boolean } = {},
): Promise<SyncContactosResultado> {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) throw new Error('Sin sesión')

  const res = await fetch(`${supabaseUrl}/functions/v1/pxsol-contactos-sync`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${session.access_token}`,
      apikey: import.meta.env.VITE_SUPABASE_ANON_KEY as string,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ force: opts.force ?? true }),
  })

  const body = await res.json().catch(() => ({}))
  if (!res.ok) {
    return { ok: false, error: body.error ?? `HTTP ${res.status}`, ...body }
  }
  return body as SyncContactosResultado
}
