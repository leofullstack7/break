import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { supabase } from '@/lib/supabase'
import { StatCard } from '@/components/ui/StatCard'
import { LayoutDashboard, CalendarDays, LogIn, LogOut } from 'lucide-react'
import type { MapaHabitacion } from '@/types/database.types'

interface ResumenDia {
  checkins_hoy:  number
  checkouts_hoy: number
  ocupadas:      number
  disponibles:   number
}

interface MovimientoDia {
  id:                string
  habitacion_numero: number
  huesped_nombre:    string
  tipo:              'entrada' | 'salida'
  fecha:             string
}

async function fetchMapa(): Promise<MapaHabitacion[]> {
  const { data, error } = await supabase
    .from('v_mapa_habitaciones')
    .select('*')
    .order('piso').order('numero')
  if (error) throw error
  return data as MapaHabitacion[]
}

async function fetchResumenHoy(): Promise<ResumenDia> {
  const hoy = new Date().toISOString().split('T')[0]
  const [{ count: checkins }, { count: checkouts }, { data: estados }] = await Promise.all([
    supabase.from('reservas').select('*', { count: 'exact', head: true })
      .eq('fecha_entrada', hoy).in('estado', ['confirmada', 'activa']),
    supabase.from('reservas').select('*', { count: 'exact', head: true })
      .eq('fecha_salida', hoy).in('estado', ['confirmada', 'activa']),
    supabase.from('habitaciones').select('estado'),
  ])
  return {
    checkins_hoy:  checkins  ?? 0,
    checkouts_hoy: checkouts ?? 0,
    ocupadas:    estados?.filter(h => h.estado === 'ocupada').length    ?? 0,
    disponibles: estados?.filter(h => h.estado === 'disponible').length ?? 0,
  }
}

async function fetchMovimientosHoy(): Promise<MovimientoDia[]> {
  const hoy = new Date().toISOString().split('T')[0]
  const { data } = await supabase
    .from('reservas')
    .select('id, fecha_entrada, fecha_salida, habitaciones(numero), huespedes(nombre)')
    .or(`fecha_entrada.eq.${hoy},fecha_salida.eq.${hoy}`)
    .in('estado', ['confirmada', 'activa', 'completada'])
    .limit(20)
  return (data ?? []).map((r: any) => ({
    id:                r.id,
    habitacion_numero: r.habitaciones?.numero ?? 0,
    huesped_nombre:    r.huespedes?.nombre ?? '—',
    tipo:              r.fecha_entrada === hoy ? 'entrada' : 'salida',
    fecha:             r.fecha_entrada === hoy ? r.fecha_entrada : r.fecha_salida,
  }))
}

export default function Dashboard() {
  const navigate = useNavigate()

  const { data: mapa, isLoading: loadMapa } = useQuery({
    queryKey: ['mapa'], queryFn: fetchMapa, refetchInterval: 30_000,
  })
  const { data: resumen } = useQuery({
    queryKey: ['resumen-hoy'], queryFn: fetchResumenHoy, refetchInterval: 60_000,
  })
  const { data: movimientos } = useQuery({
    queryKey: ['movimientos-hoy'], queryFn: fetchMovimientosHoy, refetchInterval: 60_000,
  })

  const ocupacion   = resumen ? Math.round((resumen.ocupadas / 24) * 100) : 0
  const ocupacionPx = `${ocupacion}%`

  return (
    <div className="p-4 lg:p-6 space-y-6">

      {/* ── Stats ── */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        <StatCard
          label="Ocupación"
          value={`${ocupacion}%`}
          sub={`${resumen?.ocupadas ?? '—'} de 24 hab.`}
          accent
          icon={LayoutDashboard}
        />
        <StatCard
          label="Disponibles"
          value={resumen?.disponibles ?? '—'}
          sub="habitaciones libres"
          icon={LayoutDashboard}
        />
        <StatCard
          label="Check-ins hoy"
          value={resumen?.checkins_hoy ?? '—'}
          icon={LogIn}
        />
        <StatCard
          label="Check-outs hoy"
          value={resumen?.checkouts_hoy ?? '—'}
          icon={LogOut}
        />
      </div>

      {/* ── Barra de ocupación ── */}
      {resumen && (
        <div className="glass rounded-2xl p-5 space-y-3">
          <div className="flex items-center justify-between">
            <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider font-medium">Ocupación en tiempo real</p>
            <span className="font-mono text-mono-sm font-bold text-dorado">{ocupacionPx}</span>
          </div>
          <div className="h-2.5 bg-white/5 rounded-full overflow-hidden">
            <div
              className="h-full rounded-full bg-gradient-to-r from-dorado/80 to-dorado transition-all duration-700"
              style={{ width: ocupacionPx }}
            />
          </div>
          <div className="flex justify-between text-body-xs text-blanco-roto/25">
            <span>0 hab.</span>
            <span>12 hab. — 50%</span>
            <span>24 hab.</span>
          </div>
        </div>
      )}

      {/* ── Mapa + Movimientos ── */}
      <div className="grid lg:grid-cols-3 gap-6">

        {/* Mapa de habitaciones */}
        <div className="lg:col-span-2 space-y-4">
          <div className="flex items-center justify-between">
            <p className="text-body-xs font-semibold text-blanco-roto/40 uppercase tracking-wider">
              Mapa de habitaciones
            </p>
            <button
              onClick={() => navigate('/admin/reservas')}
              className="text-body-xs text-dorado/60 hover:text-dorado transition-colors"
            >
              Ver reservas →
            </button>
          </div>

          {loadMapa && (
            <div className="grid grid-cols-4 sm:grid-cols-7 gap-2">
              {Array.from({ length: 24 }).map((_, i) => (
                <div key={i} className="h-[72px] rounded-xl shimmer" />
              ))}
            </div>
          )}

          {mapa && (
            <MapaHabitaciones
              habitaciones={mapa}
              onClickHabitacion={() => navigate('/admin/reservas')}
            />
          )}
        </div>

        {/* Movimientos del día */}
        <div className="space-y-4">
          <p className="text-body-xs font-semibold text-blanco-roto/40 uppercase tracking-wider">
            Movimientos de hoy
          </p>

          {!movimientos?.length ? (
            <div className="glass rounded-2xl p-8 text-center border border-dashed border-white/5">
              <CalendarDays size={28} className="mx-auto text-blanco-roto/15 mb-3" />
              <p className="text-body-sm text-blanco-roto/30">Sin movimientos para hoy</p>
            </div>
          ) : (
            <div className="space-y-2">
              {movimientos.map(m => (
                <div
                  key={m.id}
                  className="glass rounded-xl p-3.5 flex items-center gap-3 hover:border-white/10 transition-colors"
                >
                  {/* Chip tipo */}
                  <div className={`shrink-0 w-7 h-7 rounded-lg flex items-center justify-center ${
                    m.tipo === 'entrada'
                      ? 'bg-green-900/40 border border-green-700/30'
                      : 'bg-amber-900/30 border border-amber-700/25'
                  }`}>
                    {m.tipo === 'entrada'
                      ? <LogIn size={13} className="text-green-400" />
                      : <LogOut size={13} className="text-amber-400" />
                    }
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="text-body-sm text-blanco-roto font-medium truncate">{m.huesped_nombre}</p>
                    <p className="text-body-xs text-blanco-roto/35">
                      Hab. {m.habitacion_numero} · {m.tipo === 'entrada' ? 'Check-in' : 'Check-out'}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

// ── Mapa visual ──────────────────────────────────────────────────
function MapaHabitaciones({ habitaciones, onClickHabitacion }: {
  habitaciones: MapaHabitacion[]
  onClickHabitacion: (h: MapaHabitacion) => void
}) {
  const pisos = [4, 3, 2, 1]

  const estiloCard: Record<string, string> = {
    libre:              'border-estado-disponible/25 bg-estado-disponible/8 hover:border-estado-disponible/50 hover:bg-estado-disponible/12',
    reserva_futura:     'border-blue-600/25 bg-blue-900/10 hover:border-blue-500/40',
    hospedado:          'border-estado-ocupada/30 bg-estado-ocupada/10 hover:border-estado-ocupada/50',
    checkout_pendiente: 'border-orange-500/50 bg-orange-900/15 hover:border-orange-400/70 animate-pulse',
  }

  const colorNumero: Record<string, string> = {
    libre:              'text-green-400',
    reserva_futura:     'text-blue-400',
    hospedado:          'text-red-400',
    checkout_pendiente: 'text-orange-400',
  }

  return (
    <div className="space-y-5">
      {pisos.map(piso => {
        const hab = habitaciones.filter(h => h.piso === piso)
        return (
          <div key={piso}>
            <div className="flex items-center gap-3 mb-2.5">
              <p className="text-body-xs text-blanco-roto/25 uppercase tracking-widest">P{piso}</p>
              <div className="h-px flex-1 bg-white/[0.04]" />
              <p className="text-body-xs text-blanco-roto/20">{hab.filter(h => h.estado_hospedaje === 'hospedado').length} ocupadas</p>
            </div>
            <div className="grid grid-cols-4 sm:grid-cols-7 gap-2">
              {hab.map(h => (
                <button
                  key={h.habitacion_id}
                  onClick={() => onClickHabitacion(h)}
                  className={`glass rounded-xl p-3 border text-left transition-all duration-200 ${estiloCard[h.estado_hospedaje] ?? estiloCard.libre}`}
                >
                  <p className={`font-mono text-mono-sm font-black ${colorNumero[h.estado_hospedaje] ?? 'text-blanco-roto'}`}>
                    {h.numero}
                  </p>
                  <p className="text-blanco-roto/40 truncate mt-0.5 leading-tight" style={{ fontSize: '0.6rem' }}>
                    {h.huesped_nombre
                      ? h.huesped_nombre.split(' ')[0]
                      : h.estado_hospedaje === 'reserva_futura'
                        ? 'Reservada'
                        : 'Libre'
                    }
                  </p>
                  {h.dias_restantes !== null && h.dias_restantes <= 1 && h.estado_hospedaje === 'hospedado' && (
                    <p className="text-dorado mt-0.5 leading-tight font-semibold" style={{ fontSize: '0.6rem' }}>
                      {h.dias_restantes === 0 ? 'Sale hoy' : 'Mañana'}
                    </p>
                  )}
                </button>
              ))}
            </div>
          </div>
        )
      })}

      {/* Leyenda */}
      <div className="flex flex-wrap gap-4 pt-1 border-t border-white/[0.04]">
        {[
          { color: 'bg-green-400',  label: 'Libre' },
          { color: 'bg-red-400',    label: 'Hospedado' },
          { color: 'bg-blue-400',   label: 'Reservada' },
          { color: 'bg-orange-400', label: 'Check-out pendiente' },
        ].map(l => (
          <div key={l.label} className="flex items-center gap-1.5">
            <div className={`w-1.5 h-1.5 rounded-full ${l.color}`} />
            <span className="text-body-xs text-blanco-roto/30">{l.label}</span>
          </div>
        ))}
      </div>
    </div>
  )
}
