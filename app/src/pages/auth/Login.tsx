import { useState } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { supabase } from '@/lib/supabase'

export default function Login() {
  const navigate  = useNavigate()
  const location  = useLocation()
  const fromState = (location.state as { from?: Location })?.from?.pathname

  const [email,    setEmail]    = useState('')
  const [password, setPassword] = useState('')
  const [error,    setError]    = useState<string | null>(null)
  const [loading,  setLoading]  = useState(false)

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const { data: authData, error: authError } = await supabase.auth.signInWithPassword({ email, password })

    if (authError) {
      setError('Correo o contraseña incorrectos.')
      setLoading(false)
      return
    }

    const { data: perfil } = await supabase
      .from('usuarios')
      .select('rol')
      .eq('id', authData.user.id)
      .single() as { data: { rol: string } | null }

    const rol = perfil?.rol ?? 'huesped'

    if (fromState) {
      navigate(fromState, { replace: true })
    } else if (rol === 'huesped') {
      navigate('/huesped', { replace: true })
    } else {
      navigate('/admin', { replace: true })
    }
  }

  return (
    <main className="min-h-screen bg-negro-absoluto flex items-center justify-center p-4">
      <div className="glass rounded-2xl p-8 w-full max-w-sm space-y-6">
        <div className="text-center">
          <h1 className="font-display text-display-sm text-blanco-roto">BREAK</h1>
          <p className="text-body-sm text-blanco-roto/50 mt-1">Panel del equipo</p>
        </div>

        <form onSubmit={handleLogin} className="space-y-4">
          <div className="space-y-1">
            <label className="text-body-xs uppercase tracking-wider text-blanco-roto/50">
              Correo
            </label>
            <input
              type="email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              required
              className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-3 text-body-md text-blanco-roto focus:outline-none focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
              placeholder="tu@breakmanizales.com"
            />
          </div>

          <div className="space-y-1">
            <label className="text-body-xs uppercase tracking-wider text-blanco-roto/50">
              Contraseña
            </label>
            <input
              type="password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              required
              className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-3 text-body-md text-blanco-roto focus:outline-none focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
              placeholder="••••••••"
            />
          </div>

          {error && (
            <p className="text-body-sm text-red-400 text-center">{error}</p>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-dorado text-negro-absoluto font-semibold py-3 rounded-xl hover:shadow-glow disabled:opacity-50 transition-all"
          >
            {loading ? 'Entrando...' : 'Entrar'}
          </button>
        </form>
      </div>
    </main>
  )
}
