import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase, supabaseUrl } from '@/lib/supabase'
import { Modal } from '@/components/ui/Modal'
import {
  UserPlus, Shield, ShieldCheck, ShieldX, Eye, EyeOff,
  Loader2, CheckCircle2, AlertTriangle,
} from 'lucide-react'

interface UsuarioRow {
  id: string
  nombre: string
  email: string
  rol: string
  activo: boolean
  created_at: string
}

const ROLES: { value: string; label: string; desc: string }[] = [
  { value: 'gerente',   label: 'Gerente',    desc: 'Acceso total al sistema' },
  { value: 'recepcion', label: 'Recepción',  desc: 'Reservas, huéspedes, aseo' },
  { value: 'aseo',      label: 'Aseo',       desc: 'Limpieza y lavandería' },
  { value: 'marketing', label: 'Marketing',  desc: 'Contactos, mailing, WhatsApp' },
  { value: 'huesped',   label: 'Huésped',    desc: 'Portal del huésped' },
]

const ROL_BADGE: Record<string, string> = {
  gerente:   'bg-dorado/15 border-dorado/30 text-dorado',
  recepcion: 'bg-blue-900/30 border-blue-700/30 text-blue-300',
  aseo:      'bg-green-900/30 border-green-700/30 text-green-300',
  marketing: 'bg-purple-900/30 border-purple-700/30 text-purple-300',
  huesped:   'bg-zinc-800 border-zinc-600 text-zinc-400',
}

async function getAuthHeaders() {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) throw new Error('Sin sesión')
  return {
    'Authorization': `Bearer ${session.access_token}`,
    'Content-Type': 'application/json',
  }
}

async function fetchUsuarios(): Promise<UsuarioRow[]> {
  const headers = await getAuthHeaders()
  const res = await fetch(`${supabaseUrl}/functions/v1/admin-users`, { headers })
  const body = await res.json()
  if (!res.ok) throw new Error(body.error)
  return body.usuarios
}

async function crearUsuario(data: { nombre: string; email: string; password: string; rol: string }) {
  const headers = await getAuthHeaders()
  const res = await fetch(`${supabaseUrl}/functions/v1/admin-users`, {
    method: 'POST',
    headers,
    body: JSON.stringify(data),
  })
  const body = await res.json()
  if (!res.ok) throw new Error(body.error)
  return body
}

async function toggleUsuario(id: string, activo: boolean) {
  const headers = await getAuthHeaders()
  const res = await fetch(`${supabaseUrl}/functions/v1/admin-users`, {
    method: 'PATCH',
    headers,
    body: JSON.stringify({ id, activo }),
  })
  const body = await res.json()
  if (!res.ok) throw new Error(body.error)
  return body
}

export default function Usuarios() {
  const queryClient = useQueryClient()
  const [modalAbierto, setModalAbierto] = useState(false)
  const [nombre, setNombre]     = useState('')
  const [email, setEmail]       = useState('')
  const [password, setPassword] = useState('')
  const [rol, setRol]           = useState('recepcion')
  const [verPassword, setVerPassword] = useState(false)
  const [error, setError]       = useState<string | null>(null)
  const [exito, setExito]       = useState<string | null>(null)

  const { data: usuarios = [], isLoading } = useQuery({
    queryKey: ['admin-usuarios'],
    queryFn: fetchUsuarios,
  })

  const { mutate: crear, isPending: creando } = useMutation({
    mutationFn: () => crearUsuario({ nombre, email, password, rol }),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ['admin-usuarios'] })
      setExito(`Usuario ${data.usuario.email} creado como ${data.usuario.rol}`)
      setModalAbierto(false)
      limpiarForm()
    },
    onError: (err: Error) => setError(err.message),
  })

  const { mutate: toggle } = useMutation({
    mutationFn: ({ id, activo }: { id: string; activo: boolean }) => toggleUsuario(id, activo),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['admin-usuarios'] }),
  })

  function limpiarForm() {
    setNombre('')
    setEmail('')
    setPassword('')
    setRol('recepcion')
    setError(null)
    setVerPassword(false)
  }

  function abrirModal() {
    limpiarForm()
    setModalAbierto(true)
  }

  const puedeCrear = nombre.trim() && email.trim() && password.length >= 6

  return (
    <div className="p-4 lg:p-6 space-y-6">

      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-body-sm font-semibold text-blanco-roto/60 uppercase tracking-wider">
            Equipo Break
          </h2>
          <p className="text-body-xs text-blanco-roto/30 mt-1">{usuarios.length} usuarios registrados</p>
        </div>
        <button
          onClick={abrirModal}
          className="flex items-center gap-2 px-4 py-2.5 bg-dorado text-negro-absoluto font-semibold text-body-sm rounded-xl hover:shadow-glow hover:scale-105 active:scale-95 transition-all"
        >
          <UserPlus size={16} />
          Nuevo usuario
        </button>
      </div>

      {/* Alerta éxito */}
      {exito && (
        <div className="glass rounded-xl p-4 border border-green-700/30 flex items-start gap-3">
          <CheckCircle2 size={18} className="text-green-400 shrink-0 mt-0.5" />
          <div className="flex-1">
            <p className="text-body-sm text-green-300">{exito}</p>
          </div>
          <button onClick={() => setExito(null)} className="text-body-xs text-blanco-roto/30 hover:text-blanco-roto">✕</button>
        </div>
      )}

      {/* Lista de usuarios */}
      {isLoading ? (
        <div className="glass rounded-2xl p-12 flex justify-center">
          <Loader2 size={24} className="text-dorado animate-spin" />
        </div>
      ) : (
        <div className="space-y-2">
          {usuarios.map(u => (
            <div
              key={u.id}
              className={`glass rounded-xl p-4 flex items-center gap-4 transition-all ${
                !u.activo ? 'opacity-50' : ''
              }`}
            >
              {/* Avatar */}
              <div className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0 ${
                u.activo
                  ? 'bg-gradient-to-br from-dorado/30 to-dorado/10 border border-dorado/30'
                  : 'bg-zinc-800 border border-zinc-700'
              }`}>
                <span className={`text-body-sm font-black ${u.activo ? 'text-dorado' : 'text-zinc-500'}`}>
                  {u.nombre.charAt(0).toUpperCase()}
                </span>
              </div>

              {/* Info */}
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 flex-wrap">
                  <p className="text-body-sm font-semibold text-blanco-roto truncate">{u.nombre}</p>
                  <span className={`text-body-xs font-medium px-2 py-0.5 rounded-full border ${ROL_BADGE[u.rol] ?? ROL_BADGE.huesped}`}>
                    {u.rol}
                  </span>
                  {!u.activo && (
                    <span className="text-body-xs text-red-400 font-medium">Inactivo</span>
                  )}
                </div>
                <p className="text-body-xs text-blanco-roto/30 truncate mt-0.5">{u.email}</p>
              </div>

              {/* Acción toggle */}
              <button
                onClick={() => toggle({ id: u.id, activo: !u.activo })}
                title={u.activo ? 'Desactivar usuario' : 'Activar usuario'}
                className={`shrink-0 p-2 rounded-lg transition-all ${
                  u.activo
                    ? 'text-blanco-roto/30 hover:text-red-400 hover:bg-red-900/20'
                    : 'text-blanco-roto/30 hover:text-green-400 hover:bg-green-900/20'
                }`}
              >
                {u.activo ? <ShieldX size={18} /> : <ShieldCheck size={18} />}
              </button>
            </div>
          ))}
        </div>
      )}

      {/* Info de roles */}
      <div className="glass rounded-2xl p-5 space-y-3">
        <h3 className="text-body-xs font-semibold text-blanco-roto/40 uppercase tracking-wider">Permisos por rol</h3>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
          {ROLES.filter(r => r.value !== 'huesped').map(r => (
            <div key={r.value} className="flex items-center gap-3 px-3 py-2 rounded-lg bg-white/[0.02]">
              <Shield size={14} className={r.value === 'gerente' ? 'text-dorado' : 'text-blanco-roto/30'} />
              <div>
                <p className="text-body-sm text-blanco-roto font-medium">{r.label}</p>
                <p className="text-body-xs text-blanco-roto/30">{r.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Modal crear usuario */}
      <Modal isOpen={modalAbierto} onClose={() => setModalAbierto(false)} title="Nuevo usuario" size="sm">
        <div className="space-y-4">

          {error && (
            <div className="flex items-start gap-2 px-3 py-2 rounded-lg bg-red-900/20 border border-red-700/30">
              <AlertTriangle size={14} className="text-red-400 shrink-0 mt-0.5" />
              <p className="text-body-xs text-red-300">{error}</p>
            </div>
          )}

          {/* Nombre */}
          <div className="space-y-1.5">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Nombre</label>
            <input
              type="text"
              value={nombre}
              onChange={e => { setNombre(e.target.value); setError(null) }}
              placeholder="Ej: Catalina López"
              className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-2.5 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
            />
          </div>

          {/* Email */}
          <div className="space-y-1.5">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Correo electrónico</label>
            <input
              type="email"
              value={email}
              onChange={e => { setEmail(e.target.value); setError(null) }}
              placeholder="catalina@breakmanizales.com"
              className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-2.5 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
            />
          </div>

          {/* Contraseña */}
          <div className="space-y-1.5">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Contraseña</label>
            <div className="relative">
              <input
                type={verPassword ? 'text' : 'password'}
                value={password}
                onChange={e => { setPassword(e.target.value); setError(null) }}
                placeholder="Mínimo 6 caracteres"
                className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-2.5 pr-10 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
              />
              <button
                type="button"
                onClick={() => setVerPassword(v => !v)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-blanco-roto/30 hover:text-blanco-roto transition-colors"
              >
                {verPassword ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>
          </div>

          {/* Rol */}
          <div className="space-y-1.5">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Rol</label>
            <div className="space-y-1.5">
              {ROLES.map(r => (
                <label
                  key={r.value}
                  className={`flex items-center gap-3 px-3 py-2.5 rounded-xl border cursor-pointer transition-all ${
                    rol === r.value
                      ? 'border-dorado/40 bg-dorado/8'
                      : 'border-white/5 hover:border-white/10 bg-white/[0.02]'
                  }`}
                >
                  <input
                    type="radio"
                    name="rol"
                    value={r.value}
                    checked={rol === r.value}
                    onChange={e => setRol(e.target.value)}
                    className="sr-only"
                  />
                  <div className={`w-3.5 h-3.5 rounded-full border-2 flex items-center justify-center ${
                    rol === r.value ? 'border-dorado' : 'border-white/20'
                  }`}>
                    {rol === r.value && <div className="w-1.5 h-1.5 rounded-full bg-dorado" />}
                  </div>
                  <div>
                    <p className={`text-body-sm font-medium ${rol === r.value ? 'text-dorado' : 'text-blanco-roto/70'}`}>{r.label}</p>
                    <p className="text-body-xs text-blanco-roto/30">{r.desc}</p>
                  </div>
                </label>
              ))}
            </div>
          </div>

          {/* Botón crear */}
          <button
            onClick={() => crear()}
            disabled={!puedeCrear || creando}
            className="w-full flex items-center justify-center gap-2 py-3 bg-dorado text-negro-absoluto font-semibold rounded-xl hover:shadow-glow disabled:opacity-40 disabled:cursor-not-allowed transition-all mt-2"
          >
            {creando ? <Loader2 size={16} className="animate-spin" /> : <UserPlus size={16} />}
            {creando ? 'Creando...' : 'Crear usuario'}
          </button>
        </div>
      </Modal>
    </div>
  )
}
