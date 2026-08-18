import { useState, useRef } from 'react'
import { Link } from 'react-router-dom'
import { motion, useInView } from 'framer-motion'
import { useQuery } from '@tanstack/react-query'
import { Wifi, UtensilsCrossed, Tv, Wind, Search, ArrowRight, CalendarDays } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { PublicLayout } from '@/components/layout/PublicLayout'

const PISO_GRADIENT: Record<number, string> = {
  1: 'from-zinc-900 via-stone-900 to-neutral-900',
  2: 'from-slate-900 via-zinc-900 to-stone-900',
  3: 'from-neutral-900 via-zinc-800 to-stone-900',
  4: 'from-stone-900 via-amber-950 to-zinc-900',
}
const PISO_ACCENT: Record<number, string> = {
  1:'text-zinc-400', 2:'text-slate-400', 3:'text-neutral-400', 4:'text-amber-400/80',
}
const PISO_NOMBRE: Record<number, string> = {
  1:'Primera planta', 2:'Segunda planta', 3:'Tercera planta', 4:'Cuarta planta — Vista panorámica',
}

const AMENIDADES = [
  { icon: Wifi,           label: 'WiFi alta velocidad' },
  { icon: UtensilsCrossed,label: 'Cocina equipada' },
  { icon: Tv,             label: 'Smart TV' },
  { icon: Wind,           label: 'Aire acondicionado' },
]

function formatPrecio(p: number) {
  return new Intl.NumberFormat('es-CO', { style:'currency', currency:'COP', maximumFractionDigits:0 }).format(p)
}

async function fetchHabitaciones(entrada: string, salida: string) {
  const { data, error } = await supabase
    .from('habitaciones')
    .select('id, numero, piso, precio_base, estado')
    .order('numero')
  if (error) throw error
  if (!entrada || !salida || !data) return data ?? []

  // Filtrar por disponibilidad si hay fechas
  const resultados = await Promise.all(
    data.map(async h => {
      const { data: ok } = await supabase.rpc('habitacion_disponible', {
        p_habitacion_id: h.id,
        p_fecha_entrada: entrada,
        p_fecha_salida: salida,
      })
      return ok ? h : null
    })
  )
  return resultados.filter(Boolean) as typeof data
}

function Reveal({ children, delay = 0, className = '' }: {
  children: React.ReactNode; delay?: number; className?: string
}) {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-60px' })
  return (
    <motion.div ref={ref} className={className}
      initial={{ opacity: 0, y: 24 }}
      animate={inView ? { opacity: 1, y: 0 } : {}}
      transition={{ duration: 0.5, ease: 'easeOut', delay }}>
      {children}
    </motion.div>
  )
}

function CardHabitacion({ hab, index, disponible, fechaE, fechaS }: {
  hab: any; index: number; disponible: boolean; fechaE: string; fechaS: string
}) {
  const noches = fechaE && fechaS
    ? Math.max(0, (new Date(fechaS).getTime() - new Date(fechaE).getTime()) / 86400000)
    : 0

  const url = fechaE && fechaS
    ? `/reservar?habitacion=${hab.id}&entrada=${fechaE}&salida=${fechaS}`
    : `/reservar?habitacion=${hab.id}`

  return (
    <Reveal delay={index * 0.06}>
      <motion.div
        whileHover={{ y: -4 }}
        transition={{ duration: 0.2 }}
        className={`group glass rounded-2xl overflow-hidden border transition-all duration-300 ${
          disponible
            ? 'border-white/8 hover:border-dorado/30 hover:shadow-dorado cursor-pointer'
            : 'border-white/5 opacity-50 cursor-not-allowed'
        }`}
      >
        {/* Visual */}
        <div className={`h-44 bg-gradient-to-br ${PISO_GRADIENT[hab.piso] ?? 'from-zinc-900 to-stone-900'} relative overflow-hidden`}>
          <div className={`absolute inset-0 flex items-center justify-center font-mono font-black opacity-[0.08] ${PISO_ACCENT[hab.piso]}`}
            style={{ fontSize: '7rem' }}>
            {hab.numero}
          </div>
          {/* Glow sutil en hover */}
          <div className="absolute inset-0 bg-dorado/0 group-hover:bg-dorado/5 transition-colors duration-300" />
          <div className="absolute inset-0 flex flex-col justify-end p-4">
            <p className="text-body-xs text-blanco-roto/40 uppercase tracking-widest">{PISO_NOMBRE[hab.piso]}</p>
            <p className="font-mono font-black text-blanco-roto text-display-sm leading-none">{hab.numero}</p>
          </div>
          <div className="absolute top-3 right-3">
            {disponible
              ? <span className="text-body-xs px-2.5 py-1 rounded-full bg-green-900/70 border border-green-700/50 text-green-300 backdrop-blur-sm font-semibold">Disponible</span>
              : <span className="text-body-xs px-2.5 py-1 rounded-full bg-red-900/70 border border-red-700/50 text-red-300 backdrop-blur-sm font-semibold">Ocupada</span>
            }
          </div>
        </div>

        {/* Info */}
        <div className="p-5 space-y-4">
          <div className="flex items-end justify-between">
            <div>
              <p className="text-body-xs text-blanco-roto/40">Desde</p>
              <p className="font-mono font-bold text-mono-lg text-blanco-roto">{formatPrecio(hab.precio_base)}</p>
              <p className="text-body-xs text-blanco-roto/30">por noche</p>
            </div>
            {noches > 0 && (
              <div className="text-right">
                <p className="font-mono font-bold text-mono-md text-dorado">{formatPrecio(hab.precio_base * noches)}</p>
                <p className="text-body-xs text-blanco-roto/30">{noches} {noches === 1 ? 'noche' : 'noches'}</p>
              </div>
            )}
          </div>

          {/* Amenidades */}
          <div className="grid grid-cols-2 gap-1.5">
            {AMENIDADES.map(({ icon: Icon, label }) => (
              <div key={label} className="flex items-center gap-1.5">
                <Icon size={11} className="text-dorado/60 shrink-0" />
                <span className="text-body-xs text-blanco-roto/40">{label}</span>
              </div>
            ))}
          </div>

          {disponible ? (
            <Link to={url}
              className="block w-full py-3 bg-dorado/10 border border-dorado/30 text-dorado font-bold text-body-sm text-center rounded-xl hover:bg-dorado hover:text-negro-absoluto transition-all duration-200 group-hover:bg-dorado group-hover:text-negro-absoluto">
              Reservar esta habitación
            </Link>
          ) : (
            <div className="w-full py-3 bg-white/3 text-blanco-roto/30 font-semibold text-body-sm text-center rounded-xl">
              No disponible
            </div>
          )}
        </div>
      </motion.div>
    </Reveal>
  )
}

export default function Habitaciones() {
  const hoy     = new Date().toISOString().split('T')[0]
  const manana  = new Date(Date.now() + 86400000).toISOString().split('T')[0]
  const [fechaE, setFechaE] = useState('')
  const [fechaS, setFechaS] = useState('')
  const [buscando, setBuscando] = useState(false)

  const { data: habitaciones = [], isLoading, refetch } = useQuery({
    queryKey: ['hab-publicas', fechaE, fechaS],
    queryFn: () => fetchHabitaciones(fechaE, fechaS),
    staleTime: 60_000,
  })

  function handleBuscar() {
    if (fechaE && fechaS && fechaS > fechaE) {
      setBuscando(true)
      refetch().finally(() => setBuscando(false))
    }
  }

  const pisos = [4, 3, 2, 1] // de arriba hacia abajo
  const noches = fechaE && fechaS ? Math.max(0, (new Date(fechaS).getTime() - new Date(fechaE).getTime()) / 86400000) : 0

  return (
    <PublicLayout>

      {/* Hero compacto */}
      <section className="pt-32 pb-16 px-6 text-center">
        <motion.div
          initial={{ opacity: 0, y: 24 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, ease: 'easeOut' }}>
          <p className="text-body-xs text-dorado uppercase tracking-widest mb-3">24 estudios boutique</p>
          <h1 className="font-display font-black text-display-lg text-blanco-roto mb-4">
            Encuentra tu habitación
          </h1>
          <p className="text-body-md text-blanco-roto/50 max-w-md mx-auto">
            Cada estudio tiene cocina equipada, WiFi de alta velocidad y cerradura digital.
          </p>
        </motion.div>
      </section>

      {/* Buscador de fechas */}
      <section className="px-6 pb-12 max-w-3xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.2 }}
          className="glass rounded-2xl p-5 border border-white/10">
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider mb-4 flex items-center gap-2">
            <CalendarDays size={13} className="text-dorado"/>
            Verificar disponibilidad por fechas
          </p>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            <div className="space-y-1">
              <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Check-in</label>
              <input type="date" value={fechaE} min={hoy}
                onChange={e => setFechaE(e.target.value)}
                className="w-full bg-negro-absoluto border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50 [color-scheme:dark] transition-colors"/>
            </div>
            <div className="space-y-1">
              <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Check-out</label>
              <input type="date" value={fechaS} min={fechaE || manana}
                onChange={e => setFechaS(e.target.value)}
                className="w-full bg-negro-absoluto border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50 [color-scheme:dark] transition-colors"/>
            </div>
            <button onClick={handleBuscar}
              disabled={!fechaE || !fechaS || fechaS <= fechaE || buscando}
              className="flex items-center justify-center gap-2 py-2.5 bg-dorado text-negro-absoluto font-bold text-body-sm rounded-xl hover:shadow-glow disabled:opacity-40 disabled:cursor-not-allowed transition-all self-end">
              {buscando ? 'Buscando...' : <><Search size={15}/> Buscar</>}
            </button>
          </div>
          {noches > 0 && (
            <p className="text-body-xs text-dorado mt-3">{noches} {noches === 1 ? 'noche' : 'noches'} seleccionadas</p>
          )}
        </motion.div>
      </section>

      {/* Lista de habitaciones por piso */}
      <section className="px-6 pb-24 max-w-6xl mx-auto">

        {isLoading && (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
            {Array.from({length:8}).map((_,i) => (
              <div key={i} className="h-80 rounded-2xl shimmer"/>
            ))}
          </div>
        )}

        {!isLoading && pisos.map(piso => {
          const habsPiso = habitaciones.filter((h:any) => h.piso === piso)
          if (!habsPiso.length) return null
          const disponibles = habsPiso.filter((h:any) => h.estado === 'disponible').length

          return (
            <div key={piso} className="mb-14">
              <Reveal>
                <div className="flex items-center gap-4 mb-6">
                  <div className="flex-1 h-px bg-white/5"/>
                  <div className="flex items-center gap-3">
                    <span className="font-display font-black text-dorado text-display-sm">PISO {piso}</span>
                    <span className="text-body-xs text-blanco-roto/30">—</span>
                    <span className="text-body-xs text-blanco-roto/40">{PISO_NOMBRE[piso]}</span>
                    {fechaE && fechaS && (
                      <span className={`text-body-xs px-2 py-0.5 rounded-full ${disponibles > 0 ? 'text-green-400 bg-green-900/30' : 'text-red-400 bg-red-900/30'}`}>
                        {disponibles} disponible{disponibles !== 1 ? 's' : ''}
                      </span>
                    )}
                  </div>
                  <div className="flex-1 h-px bg-white/5"/>
                </div>
              </Reveal>
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
                {habsPiso.map((h:any, i:number) => (
                  <CardHabitacion key={h.id} hab={h} index={i}
                    disponible={h.estado === 'disponible'} fechaE={fechaE} fechaS={fechaS}/>
                ))}
              </div>
            </div>
          )
        })}

        {!isLoading && habitaciones.length === 0 && fechaE && fechaS && (
          <div className="text-center py-20 space-y-4">
            <p className="font-display font-bold text-display-sm text-blanco-roto/40">Sin disponibilidad</p>
            <p className="text-body-md text-blanco-roto/30">No hay habitaciones disponibles para esas fechas.</p>
            <button onClick={() => { setFechaE(''); setFechaS('') }}
              className="text-body-sm text-dorado hover:text-dorado/80 transition-colors">
              Ver todas las habitaciones
            </button>
          </div>
        )}
      </section>

      {/* CTA inferior */}
      <section className="px-6 py-16 bg-negro-profundo border-t border-white/5 text-center">
        <Reveal>
          <p className="text-body-sm text-blanco-roto/50 mb-4">¿Prefieres hablar con nosotros antes de reservar?</p>
          <a href="https://wa.me/573000000000" target="_blank" rel="noreferrer"
            className="inline-flex items-center gap-2 px-6 py-3 glass border border-green-800/40 text-green-400 rounded-xl hover:border-green-600/50 transition-all text-body-sm font-semibold">
            Escribir por WhatsApp <ArrowRight size={15}/>
          </a>
        </Reveal>
      </section>
    </PublicLayout>
  )
}
