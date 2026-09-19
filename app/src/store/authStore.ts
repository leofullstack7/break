import { create } from 'zustand'
import { supabase } from '@/lib/supabase'
import type { User } from '@supabase/supabase-js'
import type { RolUsuario } from '@/types/database.types'

interface AuthState {
  user: User | null
  rol: RolUsuario | null
  nombre: string | null
  inicializado: boolean
  fetchPerfil: (userId: string) => Promise<void>
  signOut: () => Promise<void>
  init: () => void
}

let authListenerBound = false

export const useAuthStore = create<AuthState>((set, get) => ({
  user: null,
  rol: null,
  nombre: null,
  inicializado: false,

  fetchPerfil: async (userId: string) => {
    const { data } = await supabase
      .from('usuarios')
      .select('rol, nombre')
      .eq('id', userId)
      .single()
    set({ rol: (data?.rol as RolUsuario) ?? null, nombre: data?.nombre ?? null })
  },

  signOut: async () => {
    await supabase.auth.signOut({ scope: 'local' })
    set({ user: null, rol: null, nombre: null })
  },

  init: () => {
    if (authListenerBound) return
    authListenerBound = true

    supabase.auth.getSession().then(({ data: { session } }) => {
      const user = session?.user ?? null
      set({ user, inicializado: true })
      if (user) get().fetchPerfil(user.id)
    })

    supabase.auth.onAuthStateChange((event, session) => {
      if (event === 'SIGNED_OUT') {
        set({ user: null, rol: null, nombre: null, inicializado: true })
        return
      }

      const user = session?.user ?? null
      set({ user, inicializado: true })
      if (user) get().fetchPerfil(user.id)
      else set({ rol: null, nombre: null })
    })
  },
}))
