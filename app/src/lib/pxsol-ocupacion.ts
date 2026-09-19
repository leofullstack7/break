import { supabase, supabaseUrl } from '@/lib/supabase'

/** Dispara sync de ocupación PxSol → Break. Requiere sesión staff. */
export async function syncOcupacionPxsol(): Promise<{
  ok: boolean
  in_house?: number
  upserted?: number
  habitaciones_ocupadas?: number
  bloqueadas?: number
  bloqueadas_nums?: number[]
  error?: string
}> {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) throw new Error('Sin sesión')

  const res = await fetch(`${supabaseUrl}/functions/v1/pxsol-ocupacion-sync`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${session.access_token}`,
      apikey: import.meta.env.VITE_SUPABASE_ANON_KEY as string,
      'Content-Type': 'application/json',
    },
    body: '{}',
  })

  const body = await res.json().catch(() => ({}))
  if (!res.ok) {
    return { ok: false, error: body.error ?? `HTTP ${res.status}` }
  }
  return body
}
