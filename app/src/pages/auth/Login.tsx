import { useState, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { motion } from 'framer-motion'
import { Eye, EyeOff, Lock } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/store/authStore'
import { PageLoader } from '@/components/ui/PageLoader'

const ROLES_STAFF = new Set(['gerente', 'recepcion', 'aseo', 'marketing'])

export default function Login() {
  const navigate  = useNavigate()
  const location  = useLocation()
  const fromState = (location.state as { from?: { pathname?: string } } | null)?.from?.pathname
  const { user, rol, inicializado } = useAuthStore()

  const [email,     setEmail]     = useState('')
  const [password,  setPassword]  = useState('')
  const [mostrar,   setMostrar]   = useState(false)
  const [error,     setError]     = useState<string | null>(null)
  const [loading,   setLoading]   = useState(false)

  // Ya autenticado como staff → entrar al panel
  useEffect(() => {
    if (!inicializado) return
    if (user && rol && ROLES_STAFF.has(rol)) {
      navigate(fromState?.startsWith('/admin') ? fromState : '/admin', { replace: true })
    }
  }, [inicializado, user, rol, fromState, navigate])

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
      email: email.trim(),
      password,
    })

    if (authError || !authData.user) {
      setError('Correo o contraseña incorrectos.')
      setLoading(false)
      return
    }

    const { data: perfil } = await supabase
      .from('usuarios')
      .select('rol')
      .eq('id', authData.user.id)
      .single() as { data: { rol: string } | null }

    const rolUsuario = perfil?.rol ?? 'huesped'

    if (!ROLES_STAFF.has(rolUsuario)) {
      await supabase.auth.signOut()
      setError('Esta plataforma es solo para el equipo Break.')
      setLoading(false)
      return
    }

    navigate(fromState?.startsWith('/admin') ? fromState : '/admin', { replace: true })
  }

  if (!inicializado) return <PageLoader />

  if (user && rol && ROLES_STAFF.has(rol)) return <PageLoader />

  return (
    <main className="relative min-h-dvh flex items-center justify-center overflow-hidden">
      {/* Fondo hotel */}
      <div className="absolute inset-0">
        <img
          src="/banner.webp"
          alt=""
          className="h-full w-full object-cover object-center scale-105 animate-hero-zoom"
        />
        <div className="absolute inset-0 bg-gradient-to-br from-negro-absoluto/85 via-negro-absoluto/70 to-negro-absoluto/90" />
        <div className="absolute inset-0 grain pointer-events-none" />
      </div>

      <motion.div
        initial={{ opacity: 0, y: 18 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.55, ease: 'easeOut' }}
        className="relative z-10 w-full max-w-md px-4"
      >
        <div className="mb-8 text-center">
          <p className="text-body-xs uppercase tracking-[0.35em] text-dorado/80 mb-3">
            Gestión interna
          </p>
          <h1
            className="font-display font-black text-blanco-roto tracking-[0.28em]"
            style={{ fontSize: 'clamp(2.4rem, 8vw, 3.4rem)' }}
          >
            BREAK
          </h1>
          <p className="mt-3 text-body-sm text-blanco-roto/45">
            La pausa también es estrategia
          </p>
        </div>

        <div className="glass rounded-2xl border border-white/10 p-7 sm:p-8 shadow-2xl shadow-black/40">
          <div className="flex items-center gap-2 mb-6 text-blanco-roto/40">
            <Lock size={14} className="text-dorado/70" />
            <span className="text-body-xs uppercase tracking-wider">Acceso del equipo</span>
          </div>

          <form onSubmit={handleLogin} className="space-y-4">
            <div className="space-y-1.5">
              <label className="text-body-xs uppercase tracking-wider text-blanco-roto/45">
                Correo
              </label>
              <input
                type="email"
                autoComplete="username"
                value={email}
                onChange={e => setEmail(e.target.value)}
                required
                className="w-full bg-negro-absoluto/50 border border-white/10 rounded-xl px-4 py-3.5 text-body-md text-blanco-roto placeholder:text-blanco-roto/25 focus:outline-none focus:border-dorado/50 focus:ring-1 focus:ring-dorado/20 transition-all"
                placeholder="tu@breakmanizales.com"
              />
            </div>

            <div className="space-y-1.5">
              <label className="text-body-xs uppercase tracking-wider text-blanco-roto/45">
                Contraseña
              </label>
              <div className="relative">
                <input
                  type={mostrar ? 'text' : 'password'}
                  autoComplete="current-password"
                  value={password}
                  onChange={e => setPassword(e.target.value)}
                  required
                  className="w-full bg-negro-absoluto/50 border border-white/10 rounded-xl px-4 py-3.5 pr-12 text-body-md text-blanco-roto placeholder:text-blanco-roto/25 focus:outline-none focus:border-dorado/50 focus:ring-1 focus:ring-dorado/20 transition-all"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  onClick={() => setMostrar(v => !v)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 p-1.5 text-blanco-roto/35 hover:text-blanco-roto/70 transition-colors"
                  aria-label={mostrar ? 'Ocultar contraseña' : 'Mostrar contraseña'}
                >
                  {mostrar ? <EyeOff size={16} /> : <Eye size={16} />}
                </button>
              </div>
            </div>

            {error && (
              <p className="text-body-sm text-red-400/90 text-center py-1">{error}</p>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full mt-2 bg-dorado text-negro-absoluto font-semibold py-3.5 rounded-xl hover:shadow-glow disabled:opacity-50 transition-all tracking-wide"
            >
              {loading ? 'Entrando…' : 'Entrar al panel'}
            </button>
          </form>

          <p className="mt-6 text-center text-body-xs text-blanco-roto/25">
            La sesión permanece activa en este dispositivo
          </p>
        </div>
      </motion.div>
    </main>
  )
}
