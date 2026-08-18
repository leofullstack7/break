import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// Cliente con service_role — bypasea RLS. Solo para Edge Functions.
export const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  { auth: { persistSession: false } }
)

/** Alias usado por las funciones pxsol-* / siigo-*. */
export function getSupabaseAdmin() {
  return supabaseAdmin
}

/** Escribe una fila en sync_logs. No lanza si falla el log en sí. */
export async function logSync(params: {
  integracion: 'pxsol' | 'siigo'
  evento: string
  referencia_id?: string | number | null
  estado: 'ok' | 'error'
  detalle?: unknown
}): Promise<void> {
  try {
    const { error } = await supabaseAdmin.from('sync_logs').insert({
      integracion: params.integracion,
      evento: params.evento,
      referencia_id: params.referencia_id != null ? String(params.referencia_id) : null,
      estado: params.estado,
      detalle: params.detalle ?? null,
    })
    if (error) {
      console.error('[sync_logs] error insertando log:', error.message)
    }
  } catch (err) {
    console.error('[sync_logs] excepción insertando log:', err)
  }
}

/**
 * Lee un valor de integraciones_config (KV real: clave / valor / expira_en).
 * Si `valor` es JSON, lo parsea; si no, lo devuelve como string.
 */
export async function getIntegracionConfig<T = unknown>(key: string): Promise<T | null> {
  const { data, error } = await supabaseAdmin
    .from('integraciones_config')
    .select('valor, expira_en')
    .eq('clave', key)
    .maybeSingle()

  if (error) {
    console.error(`[integraciones_config] error leyendo "${key}":`, error.message)
    return null
  }
  if (!data?.valor) return null

  try {
    return JSON.parse(data.valor) as T
  } catch {
    return data.valor as T
  }
}

/**
 * Upsert en integraciones_config usando las columnas reales
 * (clave, valor, expira_en, actualizado_en).
 */
export async function setIntegracionConfig(
  key: string,
  value: unknown,
  expiraEn?: string | null,
): Promise<void> {
  const valor = typeof value === 'string' ? value : JSON.stringify(value)

  let expira_en = expiraEn ?? null
  if (
    !expira_en &&
    typeof value === 'object' &&
    value !== null &&
    'expires_at' in value &&
    typeof (value as { expires_at?: unknown }).expires_at === 'string'
  ) {
    expira_en = (value as { expires_at: string }).expires_at
  }

  const { error } = await supabaseAdmin.from('integraciones_config').upsert(
    {
      clave: key,
      valor,
      expira_en,
      actualizado_en: new Date().toISOString(),
    },
    { onConflict: 'clave' },
  )

  if (error) {
    throw new Error(`No se pudo guardar integraciones_config["${key}"]: ${error.message}`)
  }
}
