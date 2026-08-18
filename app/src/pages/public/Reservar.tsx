import { useState, useMemo } from 'react'
import { useSearchParams } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { useQuery, useMutation } from '@tanstack/react-query'
import { Check, ChevronRight, Search, X, CalendarDays, User, CreditCard, CheckCircle2, MessageCircle, ArrowRight } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { PublicLayout } from '@/components/layout/PublicLayout'

// ── Fetch ─────────────────────────────────────────────────────────
async function fetchHabitacionesDisponibles(entrada: string, salida: string) {
  if (!entrada || !salida || entrada >= salida) return []
  const { data } = await supabase.from('habitaciones').select('id, numero, piso, precio_base').order('numero')
  if (!data) return []
  const res = await Promise.all(data.map(async h => {
    const { data: ok } = await supabase.rpc('habitacion_disponible', {
      p_habitacion_id: h.id, p_fecha_entrada: entrada, p_fecha_salida: salida,
    })
    return ok ? h : null
  }))
  return res.filter(Boolean) as typeof data
}

async function buscarHuespedes(q: string) {
  if (q.length < 2) return []
  const { data } = await supabase
    .from('huespedes').select('id, nombre, cedula, celular, correo')
    .or(`nombre.ilike.%${q}%,cedula.ilike.%${q}%,celular.ilike.%${q}%`)
    .is('deleted_at', null).limit(6)
  return data ?? []
}

async function fetchOperadores() {
  const { data } = await supabase.from('operadores').select('id, nombre').eq('activo', true).order('nombre')
  return data ?? []
}

// ── Helpers ───────────────────────────────────────────────────────
const esCedulaReal = (c: string | null) => c && !c.startsWith('SIN_CC_')
const fFecha = (f: string) => new Date(f+'T12:00:00').toLocaleDateString('es-CO',{day:'numeric',month:'long',year:'numeric'})
const fMonto = (m: number) => new Intl.NumberFormat('es-CO',{style:'currency',currency:'COP',maximumFractionDigits:0}).format(m)

const PISO_GRADIENT: Record<number, string> = {
  1:'from-zinc-900 to-stone-900', 2:'from-slate-900 to-zinc-900',
  3:'from-neutral-900 to-zinc-800', 4:'from-stone-900 to-amber-950',
}

// ── Step indicator ────────────────────────────────────────────────
function StepIndicator({ step }: { step: number }) {
  const steps = [
    { n: 1, label: 'Fechas y habitación', icon: CalendarDays },
    { n: 2, label: 'Tus datos',           icon: User },
    { n: 3, label: 'Confirmar',           icon: CreditCard },
  ]
  return (
    <div className="flex items-center justify-center gap-0 mb-12">
      {steps.map((s, i) => {
        const done    = step > s.n
        const active  = step === s.n
        const Icon    = s.icon
        return (
          <div key={s.n} className="flex items-center">
            <div className="flex flex-col items-center gap-1.5">
              <motion.div
                animate={{
                  backgroundColor: done ? '#c9a84c' : active ? 'rgba(201,168,76,0.15)' : 'rgba(255,255,255,0.05)',
                  borderColor: done || active ? '#c9a84c' : 'rgba(255,255,255,0.1)',
                  scale: active ? 1.1 : 1,
                }}
                className="w-10 h-10 rounded-full border-2 flex items-center justify-center transition-all duration-300">
                {done
                  ? <Check size={16} className="text-negro-absoluto" strokeWidth={3}/>
                  : <Icon size={15} className={active ? 'text-dorado' : 'text-blanco-roto/30'}/>
                }
              </motion.div>
              <p className={`text-body-xs hidden sm:block transition-colors ${active ? 'text-dorado font-semibold' : done ? 'text-blanco-roto/60' : 'text-blanco-roto/20'}`}>
                {s.label}
              </p>
            </div>
            {i < steps.length - 1 && (
              <div className={`w-16 sm:w-24 h-px mx-2 mb-5 transition-colors duration-500 ${step > s.n ? 'bg-dorado' : 'bg-white/10'}`}/>
            )}
          </div>
        )
      })}
    </div>
  )
}

const inputCls = "w-full bg-negro-absoluto border border-white/10 rounded-xl px-4 py-3 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:outline-none focus:border-dorado/50 transition-colors"
const labelCls = "block text-body-xs text-blanco-roto/40 uppercase tracking-wider mb-1.5"

// ── Pantalla de éxito ─────────────────────────────────────────────
function PantallaExito({ reservaId, hab, huesped, fechaE, fechaS, noches, total }: {
  reservaId: string; hab: any; huesped: any; fechaE: string; fechaS: string; noches: number; total: number
}) {
  const codigo = reservaId.slice(-8).toUpperCase()
  return (
    <motion.div initial={{ opacity:0, scale:0.96 }} animate={{ opacity:1, scale:1 }} transition={{ duration:0.5 }}
      className="text-center space-y-8 py-8">

      <div className="flex justify-center">
        <motion.div
          initial={{ scale:0 }} animate={{ scale:1 }}
          transition={{ type:'spring', stiffness:200, damping:15, delay:0.2 }}
          className="w-24 h-24 rounded-full bg-green-900/30 border-2 border-green-600/40 flex items-center justify-center">
          <CheckCircle2 size={44} className="text-green-400"/>
        </motion.div>
      </div>

      <div>
        <p className="text-body-xs text-dorado uppercase tracking-widest mb-2">Reserva confirmada</p>
        <h2 className="font-display font-black text-display-lg text-blanco-roto">¡Todo listo!</h2>
        <p className="text-body-md text-blanco-roto/50 mt-2">Tu pausa en Break está confirmada.</p>
      </div>

      <div className="glass rounded-2xl p-6 max-w-sm mx-auto text-left space-y-3">
        <div className="flex items-center justify-between pb-3 border-b border-white/5">
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Código</p>
          <p className="font-mono font-bold text-mono-md text-dorado">{codigo}</p>
        </div>
        <div className="flex justify-between">
          <span className="text-body-sm text-blanco-roto/50">Habitación</span>
          <span className="font-mono font-bold text-blanco-roto">{hab?.numero} — Piso {hab?.piso}</span>
        </div>
        <div className="flex justify-between">
          <span className="text-body-sm text-blanco-roto/50">Check-in</span>
          <span className="text-body-sm text-blanco-roto capitalize">{fFecha(fechaE)}</span>
        </div>
        <div className="flex justify-between">
          <span className="text-body-sm text-blanco-roto/50">Check-out</span>
          <span className="text-body-sm text-blanco-roto capitalize">{fFecha(fechaS)}</span>
        </div>
        <div className="flex justify-between">
          <span className="text-body-sm text-blanco-roto/50">Noches</span>
          <span className="font-mono text-blanco-roto">{noches}</span>
        </div>
        <div className="flex justify-between pt-3 border-t border-white/5">
          <span className="text-body-sm font-semibold text-blanco-roto">Total</span>
          <span className="font-mono font-bold text-dorado">{fMonto(total)}</span>
        </div>
      </div>

      <div className="space-y-3 max-w-sm mx-auto">
        <p className="text-body-sm text-blanco-roto/40">
          El equipo de Break te contactará para confirmar los detalles del pago.
        </p>
        <a href="https://wa.me/573000000000" target="_blank" rel="noreferrer"
          className="flex items-center justify-center gap-2 w-full py-4 glass border border-green-800/40 text-green-400 rounded-xl font-semibold hover:border-green-600/50 transition-all">
          <MessageCircle size={18}/>
          Escribir al hotel por WhatsApp
        </a>
      </div>
    </motion.div>
  )
}

// ── Página Reservar ───────────────────────────────────────────────
export default function Reservar() {
  const [searchParams] = useSearchParams()

  // Estado del flujo
  const [step, setStep]             = useState(1)
  const [exitoData, setExitoData]   = useState<any>(null)

  // Step 1: Fechas y habitación
  const hoy = new Date().toISOString().split('T')[0]
  const [fechaE, setFechaE] = useState(searchParams.get('entrada') ?? '')
  const [fechaS, setFechaS] = useState(searchParams.get('salida')  ?? '')
  const [habId,  setHabId]  = useState(searchParams.get('habitacion') ?? '')

  // Step 2: Datos del huésped
  const [busquedaH,     setBusquedaH]     = useState('')
  const [huespedSel,    setHuespedSel]    = useState<any>(null)
  const [showResults,   setShowResults]   = useState(false)
  const [nuevoHuesped,  setNuevoHuesped]  = useState(false)
  const [nh, setNh] = useState({ nombre:'', cedula:'', celular:'', correo:'' })
  const [acomp,    setAcomp]    = useState('')
  const [ccAcomp,  setCcAcomp]  = useState('')

  // Step 3: Confirmación
  const [metodo,   setMetodo]   = useState('Transferencia')
  const [obs,      setObs]      = useState('')
  const [opId,     setOpId]     = useState('')
  const [error,    setError]    = useState('')

  const noches = useMemo(() => {
    if (!fechaE || !fechaS) return 0
    return Math.max(0, (new Date(fechaS).getTime() - new Date(fechaE).getTime()) / 86400000)
  }, [fechaE, fechaS])

  const { data: habitaciones = [], isLoading: loadingHabs } = useQuery({
    queryKey: ['hab-disp-reservar', fechaE, fechaS],
    queryFn: () => fetchHabitacionesDisponibles(fechaE, fechaS),
    enabled: !!(fechaE && fechaS && fechaS > fechaE),
    staleTime: 30_000,
  })

  const { data: resultadosH = [] } = useQuery({
    queryKey: ['buscar-h-pub', busquedaH],
    queryFn: () => buscarHuespedes(busquedaH),
    enabled: busquedaH.length >= 2,
  })

  const { data: operadores = [] } = useQuery({
    queryKey: ['operadores-pub'],
    queryFn: fetchOperadores,
    staleTime: 300_000,
  })

  const habSeleccionada = habitaciones.find((h: any) => h.id === habId) ?? null
  const total = habSeleccionada ? habSeleccionada.precio_base * noches : 0

  const { mutate: confirmar, isPending: guardando } = useMutation({
    mutationFn: async () => {
      setError('')
      let hId = huespedSel?.id
      if (nuevoHuesped) {
        if (!nh.nombre || !nh.cedula) throw new Error('Nombre y cédula son obligatorios')
        const { data, error: e } = await supabase
          .from('huespedes')
          .insert({ nombre:nh.nombre, cedula:nh.cedula, celular:nh.celular||null, correo:nh.correo||null })
          .select('id').single()
        if (e) throw new Error(e.message)
        hId = data.id
      }
      if (!hId) throw new Error('Selecciona o crea un huésped')
      if (!habId || !fechaE || !fechaS) throw new Error('Faltan datos de la reserva')

      const { data: reserva, error: re } = await supabase
        .from('reservas')
        .insert({
          habitacion_id: habId, huesped_id: hId,
          fecha_entrada: fechaE, fecha_salida: fechaS,
          pago_total: total, operador_id: opId || null,
          acompanante: acomp || null, cc_acompanante: ccAcomp || null,
          metodo_pago: metodo, observaciones: obs || null,
          estado: 'confirmada',
        })
        .select('id').single()
      if (re) throw new Error(re.message)
      return reserva
    },
    onSuccess: (reserva) => {
      setExitoData({
        reservaId: reserva.id, hab: habSeleccionada,
        huesped: huespedSel ?? nh, fechaE, fechaS, noches, total
      })
    },
    onError: (e: any) => setError(e.message ?? 'Error al confirmar'),
  })

  if (exitoData) {
    return (
      <PublicLayout>
        <div className="min-h-screen pt-24 pb-16 px-6 max-w-2xl mx-auto">
          <PantallaExito {...exitoData} />
        </div>
      </PublicLayout>
    )
  }

  return (
    <PublicLayout>
      <div className="min-h-screen pt-24 pb-16 px-6">
        <div className="max-w-2xl mx-auto">

          {/* Header */}
          <motion.div initial={{ opacity:0, y:20 }} animate={{ opacity:1, y:0 }} className="text-center mb-10">
            <p className="text-body-xs text-dorado uppercase tracking-widest mb-2">Reserva directa</p>
            <h1 className="font-display font-black text-display-lg text-blanco-roto">Tu pausa en Break</h1>
          </motion.div>

          <StepIndicator step={step} />

          <AnimatePresence mode="wait">

            {/* ── STEP 1: Fechas y habitación ── */}
            {step === 1 && (
              <motion.div key="step1"
                initial={{ opacity:0, x:30 }} animate={{ opacity:1, x:0 }} exit={{ opacity:0, x:-30 }}
                transition={{ duration:0.3 }} className="space-y-6">

                {/* Fechas */}
                <div className="glass rounded-2xl p-6 space-y-4">
                  <p className="text-body-sm font-semibold text-blanco-roto flex items-center gap-2">
                    <CalendarDays size={16} className="text-dorado"/> Selecciona tus fechas
                  </p>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className={labelCls}>Check-in</label>
                      <input type="date" value={fechaE} min={hoy}
                        onChange={e => { setFechaE(e.target.value); setHabId('') }}
                        className={`${inputCls} [color-scheme:dark]`}/>
                    </div>
                    <div>
                      <label className={labelCls}>Check-out</label>
                      <input type="date" value={fechaS} min={fechaE || hoy}
                        onChange={e => { setFechaS(e.target.value); setHabId('') }}
                        className={`${inputCls} [color-scheme:dark]`}/>
                    </div>
                  </div>
                  {noches > 0 && (
                    <p className="text-body-xs text-dorado font-semibold">
                      {noches} {noches === 1 ? 'noche' : 'noches'} seleccionadas
                    </p>
                  )}
                </div>

                {/* Habitaciones disponibles */}
                {fechaE && fechaS && fechaS > fechaE && (
                  <div className="glass rounded-2xl p-6 space-y-4">
                    <p className="text-body-sm font-semibold text-blanco-roto">
                      Habitaciones disponibles
                    </p>
                    {loadingHabs && (
                      <div className="grid grid-cols-3 gap-2">
                        {Array.from({length:6}).map((_,i) => <div key={i} className="h-20 rounded-xl shimmer"/>)}
                      </div>
                    )}
                    {!loadingHabs && habitaciones.length === 0 && (
                      <p className="text-body-sm text-blanco-roto/40 text-center py-4">Sin disponibilidad para esas fechas</p>
                    )}
                    {!loadingHabs && habitaciones.length > 0 && (
                      <div className="grid grid-cols-3 sm:grid-cols-4 gap-2">
                        {habitaciones.map((h: any) => (
                          <button key={h.id} onClick={() => setHabId(h.id)}
                            className={`relative rounded-xl border-2 overflow-hidden transition-all duration-200 ${
                              habId === h.id
                                ? 'border-dorado scale-105 shadow-dorado-sm'
                                : 'border-white/10 hover:border-white/25'
                            }`}>
                            <div className={`h-16 bg-gradient-to-br ${PISO_GRADIENT[h.piso]}`}>
                              <div className="absolute inset-0 flex flex-col items-center justify-center">
                                <p className="font-mono font-black text-blanco-roto text-body-lg leading-none">{h.numero}</p>
                                <p className="text-body-xs text-blanco-roto/40">P{h.piso}</p>
                              </div>
                              {habId === h.id && (
                                <div className="absolute top-1 right-1 w-4 h-4 rounded-full bg-dorado flex items-center justify-center">
                                  <Check size={10} className="text-negro-absoluto" strokeWidth={3}/>
                                </div>
                              )}
                            </div>
                            <div className="py-1.5 text-center">
                              <p className="font-mono text-body-xs font-bold text-blanco-roto/70">
                                ${(h.precio_base/1000).toFixed(0)}k
                              </p>
                            </div>
                          </button>
                        ))}
                      </div>
                    )}
                    {habSeleccionada && noches > 0 && (
                      <div className="bg-dorado/10 border border-dorado/30 rounded-xl p-4 flex items-center justify-between">
                        <div>
                          <p className="text-body-sm text-blanco-roto font-semibold">Habitación {habSeleccionada.numero} · Piso {habSeleccionada.piso}</p>
                          <p className="text-body-xs text-blanco-roto/50">{noches} noches × {fMonto(habSeleccionada.precio_base)}</p>
                        </div>
                        <p className="font-mono font-black text-dorado text-mono-lg">{fMonto(total)}</p>
                      </div>
                    )}
                  </div>
                )}

                <button
                  onClick={() => setStep(2)}
                  disabled={!habId || !fechaE || !fechaS || noches < 1}
                  className="w-full flex items-center justify-center gap-2 py-4 bg-dorado text-negro-absoluto font-black text-body-md rounded-2xl hover:shadow-glow disabled:opacity-30 disabled:cursor-not-allowed transition-all">
                  Continuar <ChevronRight size={18}/>
                </button>
              </motion.div>
            )}

            {/* ── STEP 2: Datos del huésped ── */}
            {step === 2 && (
              <motion.div key="step2"
                initial={{ opacity:0, x:30 }} animate={{ opacity:1, x:0 }} exit={{ opacity:0, x:-30 }}
                transition={{ duration:0.3 }} className="space-y-5">

                <div className="glass rounded-2xl p-6 space-y-4">
                  <p className="text-body-sm font-semibold text-blanco-roto flex items-center gap-2">
                    <User size={16} className="text-dorado"/> Titular de la reserva
                  </p>

                  {/* Búsqueda */}
                  {!huespedSel && !nuevoHuesped && (
                    <div className="relative">
                      <Search size={14} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-blanco-roto/30"/>
                      <input className={`${inputCls} pl-10`}
                        placeholder="Buscar por nombre, cédula o celular..."
                        value={busquedaH}
                        onChange={e => { setBusquedaH(e.target.value); setShowResults(true) }}
                        onFocus={() => setShowResults(true)}/>
                      {showResults && resultadosH.length > 0 && (
                        <div className="absolute top-full mt-1.5 left-0 right-0 bg-negro-profundo border border-white/10 rounded-xl overflow-hidden z-10 shadow-xl">
                          {resultadosH.map((h: any) => (
                            <button key={h.id}
                              onClick={() => { setHuespedSel(h); setShowResults(false); setBusquedaH('') }}
                              className="w-full text-left px-4 py-3 hover:bg-white/5 border-b border-white/5 last:border-0 transition-colors">
                              <p className="text-body-sm font-medium text-blanco-roto">{h.nombre}</p>
                              <p className="text-body-xs text-blanco-roto/40">
                                {esCedulaReal(h.cedula) ? `CC: ${h.cedula}` : ''}
                                {h.celular ? ` · ${h.celular}` : ''}
                              </p>
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  )}

                  {/* Huésped seleccionado */}
                  {huespedSel && !nuevoHuesped && (
                    <div className="glass rounded-xl p-4 space-y-2">
                      <div className="flex items-start justify-between">
                        <p className="text-body-sm font-bold text-blanco-roto">{huespedSel.nombre}</p>
                        <button onClick={() => setHuespedSel(null)} className="text-blanco-roto/30 hover:text-blanco-roto">
                          <X size={14}/>
                        </button>
                      </div>
                      <div className="grid grid-cols-2 gap-x-4 gap-y-1">
                        <p className="text-body-xs text-blanco-roto/40">Cédula</p>
                        <p className="text-body-xs text-blanco-roto/80 font-mono">
                          {esCedulaReal(huespedSel.cedula) ? huespedSel.cedula : 'No registrada'}
                        </p>
                        {huespedSel.celular && (<>
                          <p className="text-body-xs text-blanco-roto/40">Celular</p>
                          <p className="text-body-xs text-blanco-roto/80 font-mono">{huespedSel.celular}</p>
                        </>)}
                        {huespedSel.correo && (<>
                          <p className="text-body-xs text-blanco-roto/40">Correo</p>
                          <p className="text-body-xs text-blanco-roto/80 truncate">{huespedSel.correo}</p>
                        </>)}
                      </div>
                    </div>
                  )}

                  {/* Crear nuevo */}
                  {!huespedSel && (
                    <button onClick={() => setNuevoHuesped(v => !v)}
                      className="text-body-xs text-dorado hover:text-dorado/80 transition-colors">
                      {nuevoHuesped ? '← Buscar huésped existente' : '+ Primera vez en Break — ingresar datos'}
                    </button>
                  )}

                  {nuevoHuesped && !huespedSel && (
                    <div className="space-y-3 pt-1">
                      <div className="grid grid-cols-2 gap-3">
                        <div>
                          <label className={labelCls}>Nombre completo *</label>
                          <input className={inputCls} value={nh.nombre} onChange={e => setNh(p=>({...p,nombre:e.target.value}))} placeholder="Nombre"/>
                        </div>
                        <div>
                          <label className={labelCls}>Cédula *</label>
                          <input className={inputCls} value={nh.cedula} onChange={e => setNh(p=>({...p,cedula:e.target.value}))} placeholder="Número"/>
                        </div>
                        <div>
                          <label className={labelCls}>Celular</label>
                          <input className={inputCls} value={nh.celular} onChange={e => setNh(p=>({...p,celular:e.target.value}))} placeholder="3XXXXXXXXX"/>
                        </div>
                        <div>
                          <label className={labelCls}>Correo</label>
                          <input className={inputCls} type="email" value={nh.correo} onChange={e => setNh(p=>({...p,correo:e.target.value}))} placeholder="correo@..."/>
                        </div>
                      </div>
                    </div>
                  )}
                </div>

                {/* Acompañante */}
                <div className="glass rounded-2xl p-6 space-y-3">
                  <p className="text-body-sm font-semibold text-blanco-roto">Acompañante <span className="text-blanco-roto/30 font-normal">(opcional)</span></p>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className={labelCls}>Nombre</label>
                      <input className={inputCls} value={acomp} onChange={e => setAcomp(e.target.value)} placeholder="Nombre completo"/>
                    </div>
                    <div>
                      <label className={labelCls}>Cédula</label>
                      <input className={inputCls} value={ccAcomp} onChange={e => setCcAcomp(e.target.value)} placeholder="Número"/>
                    </div>
                  </div>
                </div>

                <div className="flex gap-3">
                  <button onClick={() => setStep(1)}
                    className="px-6 py-4 glass border border-white/10 text-blanco-roto/60 font-semibold text-body-sm rounded-2xl hover:text-blanco-roto transition-all">
                    Atrás
                  </button>
                  <button onClick={() => setStep(3)}
                    disabled={!huespedSel && (!nuevoHuesped || !nh.nombre || !nh.cedula)}
                    className="flex-1 flex items-center justify-center gap-2 py-4 bg-dorado text-negro-absoluto font-black text-body-md rounded-2xl hover:shadow-glow disabled:opacity-30 disabled:cursor-not-allowed transition-all">
                    Continuar <ChevronRight size={18}/>
                  </button>
                </div>
              </motion.div>
            )}

            {/* ── STEP 3: Confirmar ── */}
            {step === 3 && (
              <motion.div key="step3"
                initial={{ opacity:0, x:30 }} animate={{ opacity:1, x:0 }} exit={{ opacity:0, x:-30 }}
                transition={{ duration:0.3 }} className="space-y-5">

                {/* Resumen */}
                <div className="glass rounded-2xl p-6 space-y-3">
                  <p className="text-body-sm font-semibold text-blanco-roto">Resumen de tu reserva</p>
                  <div className="divide-y divide-white/5">
                    {[
                      ['Habitación', `${habSeleccionada?.numero ?? '—'} · Piso ${habSeleccionada?.piso ?? '—'}`],
                      ['Titular', huespedSel?.nombre ?? nh.nombre],
                      ['Check-in', fFecha(fechaE)],
                      ['Check-out', fFecha(fechaS)],
                      ['Noches', noches],
                    ].map(([k,v]) => (
                      <div key={String(k)} className="flex justify-between py-2.5">
                        <span className="text-body-sm text-blanco-roto/50">{k}</span>
                        <span className="text-body-sm text-blanco-roto capitalize">{v}</span>
                      </div>
                    ))}
                    <div className="flex justify-between py-3">
                      <span className="text-body-sm font-bold text-blanco-roto">Total</span>
                      <span className="font-mono font-black text-dorado text-mono-lg">{fMonto(total)}</span>
                    </div>
                  </div>
                </div>

                {/* Detalles de pago */}
                <div className="glass rounded-2xl p-6 space-y-4">
                  <p className="text-body-sm font-semibold text-blanco-roto">Detalles adicionales</p>
                  <div>
                    <label className={labelCls}>Método de pago preferido</label>
                    <select value={metodo} onChange={e => setMetodo(e.target.value)} className={inputCls}>
                      {['Transferencia','Efectivo','Nequi','Daviplata','Tarjeta'].map(m => <option key={m}>{m}</option>)}
                    </select>
                  </div>
                  <div>
                    <label className={labelCls}>Canal <span className="text-blanco-roto/20 normal-case">(si aplica)</span></label>
                    <select value={opId} onChange={e => setOpId(e.target.value)} className={inputCls}>
                      <option value="">Reserva directa</option>
                      {(operadores as any[]).map(o => <option key={o.id} value={o.id}>{o.nombre}</option>)}
                    </select>
                  </div>
                  <div>
                    <label className={labelCls}>Observaciones</label>
                    <textarea value={obs} onChange={e => setObs(e.target.value)} rows={2} placeholder="Llegada tarde, necesidades especiales..."
                      className={`${inputCls} resize-none`}/>
                  </div>
                </div>

                {error && (
                  <p className="text-body-sm text-red-400 text-center">{error}</p>
                )}

                <p className="text-body-xs text-blanco-roto/30 text-center">
                  Al confirmar, el equipo de Break se pondrá en contacto para coordinar el pago.
                </p>

                <div className="flex gap-3">
                  <button onClick={() => setStep(2)}
                    className="px-6 py-4 glass border border-white/10 text-blanco-roto/60 font-semibold text-body-sm rounded-2xl hover:text-blanco-roto transition-all">
                    Atrás
                  </button>
                  <button onClick={() => confirmar()} disabled={guardando}
                    className="flex-1 flex items-center justify-center gap-2 py-4 bg-dorado text-negro-absoluto font-black text-body-md rounded-2xl hover:shadow-glow disabled:opacity-50 transition-all">
                    {guardando ? 'Confirmando...' : <><CheckCircle2 size={18}/> Confirmar reserva</>}
                  </button>
                </div>
              </motion.div>
            )}

          </AnimatePresence>
        </div>
      </div>
    </PublicLayout>
  )
}
