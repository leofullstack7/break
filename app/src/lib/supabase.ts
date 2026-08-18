import { createClient } from '@supabase/supabase-js'
import type { Database } from '@/types/database.types'

export const supabaseUrl  = import.meta.env.VITE_SUPABASE_URL as string
const supabaseKey  = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  throw new Error(
    'Faltan las variables de entorno de Supabase. ' +
    'Copia .env.example a .env.local y agrega los valores.'
  )
}

export const supabase = createClient<Database>(supabaseUrl, supabaseKey, {
  auth: {
    // Persistir sesión en localStorage
    persistSession: true,
    // Detectar sesión desde URL (para magic links si se usan)
    detectSessionInUrl: true,
    // Auto-refrescar el token antes de que expire
    autoRefreshToken: true,
  },
  realtime: {
    params: {
      // Log level para desarrollo — cambiar a 'error' en producción
      log_level: import.meta.env.DEV ? 'info' : 'error',
    },
  },
})

// Helper: obtener el rol del usuario actual desde la tabla usuarios
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
