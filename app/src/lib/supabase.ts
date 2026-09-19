import { createClient } from '@supabase/supabase-js'
import type { Database } from '@/types/database.types'

export const supabaseUrl = import.meta.env.VITE_SUPABASE_URL as string
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  throw new Error(
    'Faltan las variables de entorno de Supabase. ' +
    'Copia .env.example a .env.local y agrega los valores.'
  )
}

const AUTH_STORAGE_KEY = 'break-admin-auth'

export const supabase = createClient<Database>(supabaseUrl, supabaseKey, {
  auth: {
    // Sesión larga: localStorage + refresh automático del access token
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
    storage: typeof window !== 'undefined' ? window.localStorage : undefined,
    storageKey: AUTH_STORAGE_KEY,
    // Evita que un refresh en otra pestaña invalide esta sesión de inmediato
    flowType: 'pkce',
  },
  realtime: {
    params: {
      log_level: import.meta.env.DEV ? 'info' : 'error',
    },
  },
})

export async function getMiRol(): Promise<string | null> {
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return null

  const { data } = await supabase
    .from('usuarios')
    .select('rol')
    .eq('id', user.id)
    .single()

  return data?.rol ?? null
}
