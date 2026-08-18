import { useQuery } from '@tanstack/react-query'
import { useParams, useNavigate } from 'react-router-dom'
import { ArrowLeft, Phone, Mail, Globe, CalendarDays, MessageCircle } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { Badge } from '@/components/ui/Badge'
import type { Huesped, Reserva, EstadoReserva } from '@/types/database.types'

interface ReservaConDetalles extends Reserva {
  habitaciones: { numero: number }
  operadores: { nombre: string } | null
}

async function fetchHuesped(id: string) {
  const [{ data: huesped }, { data: reservas }] = await Promise.all([
    supabase.from('huespedes').select('*').eq('id', id).single(),
    supabase
      .from('reservas')
      .select('*, habitaciones(numero), operadores(nombre)')
      .eq('huesped_id', id)
      .is('deleted_at', null)
      .order('fecha_entrada', { ascending: false }),
  ])
  return { huesped: huesped as Huesped, reservas: (reservas ?? []) as ReservaConDetalles[] }
}

function formatFecha(f: string) {
  return new Date(f + 'T12:00:00').toLocaleDateString('es-CO', { day: 'numeric', month: 'short', year: 'numeric' })
}

function formatMonto(m: number) {
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', maximumFractionDigits: 0 }).format(m)
}

const LABEL_ESTADO: Record<EstadoReserva, string> = {
  pendiente: 'Pendiente', confirmada: 'Confirmada', activa: 'Activa',
  completada: 'Completada', cancelada: 'Cancelada',
}

export default function HuespedDetalle() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()

  const { data, isLoading } = useQuery({
    queryKey: ['huesped', id],
    queryFn:  () => fetchHuesped(id!),
    enabled:  !!id,
  })

  const { huesped, reservas = [] } = data ?? {}

  const totalGastado = reservas
    .filter(r => r.estado === 'completada')
    .reduce((sum, r) => sum + (r.pago_total ?? 0), 0)

  const esCedulaReal = huesped && !huesped.cedula.startsWith('SIN_CC_')

  if (isLoading) {
    return (
      <div className="p-6 space-y-4">
        <div className="h-32 rounded-2xl shimmer" />
        <div className="h-48 rounded-2xl shimmer" />
      </div>
    )
  }

  if (!huesped) return (
    <div className="p-6 text-center text-blanco-roto/50">Huésped no encontrado</div>
  )

  return (
    <div className="p-4 lg:p-6 space-y-5 max-w-3xl mx-auto">

      {/* Back */}
      <button onClick={() => navigate(-1)} className="flex items-center gap-2 text-body-sm text-blanco-roto/50 hover:text-blanco-roto transition-colors">
        <ArrowLeft size={16} />
        Huéspedes
      </button>

      {/* Perfil */}
      <div className="glass rounded-2xl p-5">
        <div className="flex items-start gap-4">
          <div className="w-14 h-14 rounded-2xl bg-dorado/10 border border-dorado/20 flex items-center justify-center shrink-0">
            <span className="font-display text-display-sm font-bold text-dorado">
              {huesped.nombre.charAt(0).toUpperCase()}
            </span>
          </div>
          <div className="flex-1 min-w-0">
            <h1 className="font-display text-display-sm font-semibold text-blanco-roto">{huesped.nombre}</h1>
            <p className="text-body-xs text-blanco-roto/40 capitalize mt-0.5">{huesped.nacionalidad}</p>
          </div>
        </div>

        <div className="grid sm:grid-cols-2 gap-3 mt-5">
          {huesped.celular && (
            <a href={`tel:${huesped.celular}`} className="flex items-center gap-2 text-body-sm text-blanco-roto/70 hover:text-dorado transition-colors">
              <Phone size={14} className="shrink-0 text-blanco-roto/30" />
              {huesped.celular}
            </a>
          )}
          {huesped.correo && (
            <a href={`mailto:${huesped.correo}`} className="flex items-center gap-2 text-body-sm text-blanco-roto/70 hover:text-dorado transition-colors truncate">
              <Mail size={14} className="shrink-0 text-blanco-roto/30" />
              <span className="truncate">{huesped.correo}</span>
            </a>
          )}
          {huesped.celular && (
            <a href={`https://wa.me/${huesped.celular.replace(/\D/g, '')}`} target="_blank" rel="noreferrer"
              className="flex items-center gap-2 text-body-sm text-green-400 hover:text-green-300 transition-colors">
              <MessageCircle size={14} />
              WhatsApp
            </a>
          )}
          {esCedulaReal && (
            <p className="flex items-center gap-2 text-body-sm text-blanco-roto/40">
              <Globe size={14} />
              CC: {huesped.cedula}
            </p>
          )}
        </div>
      </div>

      {/* Métricas */}
      <div className="grid grid-cols-3 gap-3">
        <div className="glass rounded-xl p-3 text-center">
          <p className="font-mono text-mono-lg font-bold text-dorado">{reservas.length}</p>
          <p className="text-body-xs text-blanco-roto/40 mt-1">Estadías</p>
        </div>
        <div className="glass rounded-xl p-3 text-center">
          <p className="font-mono text-mono-lg font-bold text-blanco-roto">
            {reservas.reduce((s, r) => s + (r.noches ?? 0), 0)}
          </p>
          <p className="text-body-xs text-blanco-roto/40 mt-1">Noches total</p>
        </div>
        <div className="glass rounded-xl p-3 text-center">
          <p className="font-mono text-mono-sm font-bold text-blanco-roto">
            {totalGastado > 0 ? `$${(totalGastado / 1_000_000).toFixed(1)}M` : '—'}
          </p>
          <p className="text-body-xs text-blanco-roto/40 mt-1">Gastado</p>
        </div>
      </div>

      {/* Historial de reservas */}
      <div className="space-y-3">
        <h2 className="text-body-sm font-semibold text-blanco-roto/60 uppercase tracking-wider">
          Historial de estadías
        </h2>

        {reservas.length === 0 && (
          <div className="glass rounded-xl p-8 text-center">
            <CalendarDays size={24} className="mx-auto text-blanco-roto/20 mb-2" />
            <p className="text-body-sm text-blanco-roto/40">Sin reservas registradas</p>
          </div>
        )}

        <div className="space-y-2">
          {reservas.map(r => (
            <div key={r.id} className="glass rounded-xl p-4 flex items-center gap-4">
              <div className="shrink-0 text-center w-10">
                <p className="font-mono text-mono-lg font-bold text-blanco-roto/80">{r.habitaciones?.numero}</p>
                <p className="text-body-xs text-blanco-roto/30">hab.</p>
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 flex-wrap">
                  <p className="text-body-sm text-blanco-roto">
                    {formatFecha(r.fecha_entrada)} → {formatFecha(r.fecha_salida)}
                  </p>
                  <Badge variant={r.estado as EstadoReserva}>{LABEL_ESTADO[r.estado as EstadoReserva]}</Badge>
                </div>
                <p className="text-body-xs text-blanco-roto/40 mt-0.5">
                  {r.noches} {r.noches === 1 ? 'noche' : 'noches'} · {r.operadores?.nombre ?? '—'}
                </p>
              </div>
              <div className="shrink-0 text-right">
                <p className="font-mono text-mono-sm text-blanco-roto/80">{formatMonto(r.pago_total)}</p>
                {r.comision && (
                  <p className="text-body-xs text-blanco-roto/30">-{formatMonto(r.comision)} com.</p>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Notas */}
      {huesped.notas && (
        <div className="glass rounded-xl p-4">
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider mb-2">Notas internas</p>
          <p className="text-body-sm text-blanco-roto/70">{huesped.notas}</p>
        </div>
      )}
    </div>
  )
}
