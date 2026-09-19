import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import { syncOcupacionPxsol } from '@/lib/pxsol-ocupacion'
import { HabitacionDetalleSheet } from '@/components/admin/HabitacionDetalleSheet'
import { StatCard } from '@/components/ui/StatCard'
import { LayoutDashboard, CalendarDays, LogIn, LogOut, RefreshCw } from 'lucide-react'
import type { EstadoHospedaje, MapaHabitacion } from '@/types/database.types'

interface ResumenDia {
  checkins_hoy:  number
  checkouts_hoy: number
  ocupadas:      number
  disponibles:   number
  bloqueadas:    number
}

/** Prioriza estado físico de la habitación sobre la reserva al pintar el mapa. */
function estadoVisual(h: MapaHabitacion): EstadoHospedaje | string {
  if (h.estado_habitacion === 'mantenimiento') return 'bloqueada'
  if (h.estado_habitacion === 'aseo') return 'aseo'
  if (h.estado_hospedaje === 'hospedado') return 'hospedado'
  if (h.estado_hospedaje === 'checkout_pendiente') return 'checkout_pendiente'
  if (h.estado_hospedaje === 'reserva_futura') return 'reserva_futura'
  if (h.estado_habitacion === 'ocupada') return 'hospedado'
  return h.estado_hospedaje || 'libre'
}

function estaOcupada(h: MapaHabitacion): boolean {
  const visual = estadoVisual(h)
  return visual === 'hospedado' || visual === 'checkout_pendiente'
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
    supabase.from('v_mapa_habitaciones').select('*'),
  ])
  const mapaHoy = (estados ?? []) as MapaHabitacion[]
  return {
    checkins_hoy:  checkins  ?? 0,
    checkouts_hoy: checkouts ?? 0,
    ocupadas:    mapaHoy.filter(estaOcupada).length,
    disponibles: mapaHoy.filter(h => estadoVisual(h) === 'libre').length,
    bloqueadas:  mapaHoy.filter(h => estadoVisual(h) === 'bloqueada').length,
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
  const queryClient = useQueryClient()
  const [syncMsg, setSyncMsg] = useState<string | null>(null)
  const [syncing, setSyncing] = useState(false)

  async function refrescarDesdePxsol(silent = false) {
    if (!silent) setSyncing(true)
    try {
      const r = await syncOcupacionPxsol()
      if (r.ok) {
        const bloq = (r as { bloqueadas?: number }).bloqueadas
        setSyncMsg(
          `PxSol · ${r.habitaciones_ocupadas ?? r.upserted ?? 0} ocupadas` +
            (bloq != null ? ` · ${bloq} bloqueadas` : '') +
            ` · ${r.in_house ?? 0} in-house`,
        )
        await queryClient.invalidateQueries({ queryKey: ['mapa'] })
        await queryClient.invalidateQueries({ queryKey: ['resumen-hoy'] })
        await queryClient.invalidateQueries({ queryKey: ['movimientos-hoy'] })
      } else if (!silent) {
        setSyncMsg(r.error ?? 'No se pudo sincronizar con PxSol')
      }
    } catch (e) {
      if (!silent) setSyncMsg(e instanceof Error ? e.message : 'Error de sync')
    } finally {
      if (!silent) setSyncing(false)
    }
  }

  // Sync al entrar + cada 2 min
  useEffect(() => {
    void refrescarDesdePxsol(true)
    const id = window.setInterval(() => void refrescarDesdePxsol(true), 120_000)
    return () => window.clearInterval(id)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

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
  const [habSeleccionada, setHabSeleccionada] = useState<MapaHabitacion | null>(null)

  return (
    <div className="w-full max-w-5xl mx-auto px-3 sm:px-4 lg:px-6 py-4 lg:py-6 space-y-5 sm:space-y-6 overflow-x-hidden">

      <div className="flex items-center justify-between gap-3">
        <div>
          <p className="text-body-xs text-blanco-roto/35 uppercase tracking-wider">Panel operativo</p>
          {syncMsg && (
            <p className="text-body-xs text-blanco-roto/45 mt-1">{syncMsg}</p>
          )}
        </div>
        <button
          type="button"
          onClick={() => void refrescarDesdePxsol(false)}
          disabled={syncing}
          className="inline-flex items-center gap-2 px-3 py-2 rounded-xl border border-white/10 text-body-xs text-blanco-roto/70 hover:text-blanco-roto hover:border-dorado/40 disabled:opacity-50 transition-colors"
        >
          <RefreshCw size={14} className={syncing ? 'animate-spin text-dorado' : 'text-dorado/80'} />
          {syncing ? 'Sincronizando…' : 'Actualizar PxSol'}
        </button>
      </div>

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
          sub={
            resumen?.bloqueadas
              ? `${resumen.bloqueadas} bloqueadas en PxSol`
              : 'habitaciones libres'
          }
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
              onClickHabitacion={(h) => setHabSeleccionada(h)}
            />
          )}
        </div>

        {/* Movimientos del día */}
        <div className="space-y-4 min-w-0">
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
                  className="glass rounded-xl p-3.5 flex items-center gap-3 hover:border-white/10 transition-colors min-w-0"
                >
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

      <HabitacionDetalleSheet
        habitacion={habSeleccionada}
        onClose={() => setHabSeleccionada(null)}
      />
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
    bloqueada:          'border-zinc-500/35 bg-zinc-800/40 hover:border-zinc-400/45',
    aseo:               'border-amber-600/30 bg-amber-900/15 hover:border-amber-500/45',
  }

  const colorNumero: Record<string, string> = {
    libre:              'text-green-400',
    reserva_futura:     'text-blue-400',
    hospedado:          'text-red-400',
    checkout_pendiente: 'text-orange-400',
    bloqueada:          'text-zinc-400',
    aseo:               'text-amber-400',
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
              <p className="text-body-xs text-blanco-roto/20">
                {hab.filter(estaOcupada).length} ocupadas
                {hab.some(h => estadoVisual(h) === 'bloqueada')
                  ? ` · ${hab.filter(h => estadoVisual(h) === 'bloqueada').length} bloq.`
                  : ''}
              </p>
            </div>
            <div className="grid grid-cols-4 sm:grid-cols-6 md:grid-cols-7 gap-1.5 sm:gap-2">
              {hab.map(h => {
                const visual = estadoVisual(h)
                return (
                  <button
                    key={h.habitacion_id}
                    onClick={() => onClickHabitacion(h)}
                    className={`glass rounded-xl p-2 sm:p-3 border text-left transition-all duration-200 min-w-0 active:scale-[0.97] ${estiloCard[visual] ?? estiloCard.libre}`}
                  >
                    <p className={`font-mono text-sm sm:text-mono-sm font-black ${colorNumero[visual] ?? 'text-blanco-roto'}`}>
                      {h.numero}
                    </p>
                    <p className="text-blanco-roto/40 truncate mt-0.5 leading-tight" style={{ fontSize: '0.6rem' }}>
                      {visual === 'bloqueada'
                        ? 'Bloqueada'
                        : visual === 'aseo'
                          ? 'Aseo'
                          : h.huesped_nombre
                            ? h.huesped_nombre
                            : visual === 'reserva_futura'
                              ? 'Reservada'
                              : 'Libre'
                      }
                    </p>
                    {h.dias_restantes !== null && h.dias_restantes <= 1 && visual === 'hospedado' && (
                      <p className="text-dorado mt-0.5 leading-tight font-semibold" style={{ fontSize: '0.6rem' }}>
                        {h.dias_restantes === 0 ? 'Sale hoy' : 'Mañana'}
                      </p>
                    )}
                  </button>
                )
              })}
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
          { color: 'bg-zinc-400',   label: 'Bloqueada' },
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
