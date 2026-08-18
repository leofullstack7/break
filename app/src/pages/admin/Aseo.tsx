import { useState, useMemo, useCallback } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { ChevronLeft, ChevronRight, CheckCircle2, Loader2, Pencil, Shuffle, User } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { Modal } from '@/components/ui/Modal'
import { useAuthStore } from '@/store/authStore'

// ── Helpers fecha ─────────────────────────────────────────────────
function startOfWeek(offset = 0): Date {
  const d = new Date(); d.setHours(0,0,0,0)
  const dow = d.getDay() === 0 ? 7 : d.getDay()
  d.setDate(d.getDate() - dow + 1 + offset * 7)
  return d
}
function addDays(d: Date, n: number) { const r = new Date(d); r.setDate(r.getDate()+n); return r }
const toISO  = (d: Date) => d.toISOString().split('T')[0]
const HOY    = toISO(new Date())
const DIAS   = ['Lun','Mar','Mié','Jue','Vie','Sáb','Dom']

// ── Estados de aseo ───────────────────────────────────────────────
type EstadoAseo = 'pendiente' | 'en_proceso' | 'completado'
const ASEADORAS = ['Catalina', 'Rosa', 'Paula'] as const

const ASEO_CFG: Record<EstadoAseo, { label: string; bg: string; border: string; dot: string; text: string }> = {
  pendiente:  { label:'Sucia',   bg:'bg-red-950/50',   border:'border-red-700/60',   dot:'bg-red-500',   text:'text-red-300' },
  en_proceso: { label:'Repasar', bg:'bg-amber-950/50', border:'border-amber-600/60', dot:'bg-amber-400', text:'text-amber-300' },
  completado: { label:'OK',      bg:'bg-green-950/40', border:'border-green-700/50', dot:'bg-green-500', text:'text-green-300' },
}

// Estado de disponibilidad de la habitación
const HAB_BADGE: Record<string, { bg: string; label: string }> = {
  ocupada:       { bg:'bg-red-900/50 border border-red-700/40 text-red-300',       label:'Ocupada' },
  recien_ingreso:{ bg:'bg-blue-900/50 border border-blue-700/40 text-blue-300',    label:'Recién ingreso' },
  disponible:    { bg:'bg-green-900/30 border border-green-700/30 text-green-400', label:'Desocupada' },
  aseo:          { bg:'bg-amber-900/30 border border-amber-700/30 text-amber-300', label:'En aseo' },
  mantenimiento: { bg:'bg-zinc-800 border border-zinc-600 text-zinc-400',          label:'Mant.' },
}

// ── Tipos ─────────────────────────────────────────────────────────
interface HabRow { id:string; numero:number; piso:number; estado:string; ultima_limpieza:string|null }
interface AseoRow { id:string; habitacion_id:string; fecha:string; estado:EstadoAseo; observaciones:string; responsable:string|null }

// ── Queries ───────────────────────────────────────────────────────
async function fetchHabs(): Promise<HabRow[]> {
  const { data } = await supabase.from('habitaciones').select('id,numero,piso,estado,ultima_limpieza').order('numero')
  return (data ?? []) as HabRow[]
}

async function fetchAseosSemana(start:string, end:string): Promise<AseoRow[]> {
  const { data } = await supabase.from('aseos')
    .select('id,habitacion_id,fecha,estado,observaciones,responsable')
    .gte('fecha', start).lte('fecha', end)
  return (data ?? []) as AseoRow[]
}

// Guardar siempre con maybeSingle — no depende del constraint único
async function saveAseo(args: { habitacion_id:string; fecha:string; estado:EstadoAseo; observaciones:string; responsable?:string|null }) {
  const { data: ex } = await supabase.from('aseos').select('id').eq('habitacion_id',args.habitacion_id).eq('fecha',args.fecha).maybeSingle()
  const payload = {
    estado: args.estado,
    observaciones: args.observaciones,
    ...(args.responsable !== undefined ? { responsable: args.responsable } : {}),
  }
  if (ex?.id) {
    const { error } = await supabase.from('aseos').update(payload).eq('id', ex.id)
    if (error) throw error
  } else {
    const { error } = await supabase.from('aseos').insert({ ...args, tipo_aseo:'diario' })
    if (error) throw error
  }
}

// ── Modal cambiar estado ──────────────────────────────────────────
function ModalCambiarEstado({ hab, aseoActual, fecha, onClose, onGuardado }: {
  hab: HabRow; aseoActual: AseoRow|undefined; fecha:string; onClose:()=>void; onGuardado:()=>void
}) {
  const [estado, setEstado] = useState<EstadoAseo>(aseoActual?.estado ?? 'pendiente')
  const [obs,    setObs]    = useState(aseoActual?.observaciones ?? '')
  const [saving, setSaving] = useState(false)
  const [error,  setError]  = useState('')
  const disp = HAB_BADGE[hab.estado] ?? HAB_BADGE.disponible

  async function guardar() {
    setSaving(true); setError('')
    try {
      await saveAseo({ habitacion_id:hab.id, fecha, estado, observaciones:obs })
      onGuardado(); onClose()
    } catch (e:any) { setError(e.message ?? 'Error al guardar') }
    finally { setSaving(false) }
  }

  return (
    <Modal isOpen onClose={onClose} title={`Habitación ${hab.numero} — Piso ${hab.piso}`} size="sm">
      <div className="space-y-5">
        {/* Estado actual */}
        <div className="glass rounded-xl p-4 flex items-center gap-3">
          <div className={`w-3 h-3 rounded-full ${ASEO_CFG[aseoActual?.estado ?? 'pendiente'].dot}`}/>
          <span className={`font-semibold text-body-md ${ASEO_CFG[aseoActual?.estado ?? 'pendiente'].text}`}>
            {ASEO_CFG[aseoActual?.estado ?? 'pendiente'].label}
          </span>
          <span className={`ml-auto text-body-xs px-2 py-0.5 rounded-lg ${disp.bg}`}>{disp.label}</span>
        </div>

        {/* Selector de estado */}
        <div className="space-y-2">
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Nuevo estado de aseo</p>
          <div className="grid grid-cols-3 gap-2">
            {(['pendiente','en_proceso','completado'] as EstadoAseo[]).map(e => {
              const c = ASEO_CFG[e]; const sel = estado === e
              return (
                <button key={e} onClick={() => setEstado(e)}
                  className={`py-4 rounded-xl border-2 font-bold text-body-sm transition-all ${
                    sel ? `${c.bg} ${c.border} ${c.text} scale-105` : 'border-white/10 text-blanco-roto/40 hover:border-white/25'
                  }`}>
                  <div className={`w-2.5 h-2.5 rounded-full mx-auto mb-2 ${sel ? c.dot : 'bg-blanco-roto/20'}`}/>
                  {c.label}
                </button>
              )
            })}
          </div>
        </div>

        {/* Observaciones */}
        <div className="space-y-1.5">
          <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Observaciones</label>
          <textarea value={obs} onChange={e => setObs(e.target.value)} rows={3}
            placeholder="Ej: Toallas sucias, ventana rota, platón sucio..."
            className="w-full bg-negro-absoluto border border-white/10 rounded-xl px-4 py-3 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:outline-none focus:border-dorado/50 resize-none transition-colors"/>
        </div>

        {error && <p className="text-body-sm text-red-400">{error}</p>}

        <div className="flex gap-3">
          <button onClick={guardar} disabled={saving}
            className="flex-1 flex items-center justify-center gap-2 py-3 bg-dorado text-negro-absoluto font-bold text-body-sm rounded-xl hover:shadow-glow disabled:opacity-50 transition-all">
            {saving ? <Loader2 size={15} className="animate-spin"/> : <CheckCircle2 size={15}/>}
            {saving ? 'Guardando...' : 'Guardar'}
          </button>
          <button onClick={onClose} className="px-4 text-body-sm text-blanco-roto/40 hover:text-blanco-roto transition-colors">Cancelar</button>
        </div>
      </div>
    </Modal>
  )
}

// ── Tarjeta de habitación ─────────────────────────────────────────
function CardHabitacion({ hab, aseo, onCambiar }: { hab:HabRow; aseo:AseoRow|undefined; onCambiar:()=>void }) {
  const estado = aseo?.estado ?? 'pendiente'
  const c      = ASEO_CFG[estado]
  const disp   = HAB_BADGE[hab.estado] ?? HAB_BADGE.disponible

  return (
    <div className={`relative rounded-2xl border-2 ${c.bg} ${c.border} overflow-hidden transition-all duration-300 hover:scale-[1.03] hover:shadow-xl`}>
      <div className={`h-1.5 w-full ${c.dot}`}/>
      <div className="p-4 space-y-3">
        {/* Número + disponibilidad */}
        <div className="flex items-start justify-between gap-2">
          <span className="font-mono text-mono-lg font-black text-blanco-roto leading-none">{hab.numero}</span>
          <span className={`text-body-xs font-medium px-2 py-0.5 rounded-lg shrink-0 ${disp.bg}`}>{disp.label}</span>
        </div>

        {/* Estado de aseo — grande */}
        <div className="flex items-center gap-2">
          <div className={`w-3 h-3 rounded-full shrink-0 ${c.dot} ${estado === 'completado' ? '' : 'animate-pulse'}`}/>
          <span className={`font-display font-black text-display-sm ${c.text}`}>{c.label}</span>
        </div>

        {/* Aseadora asignada */}
        {aseo?.responsable && (
          <div className="flex items-center gap-1.5 text-body-xs text-blanco-roto/50">
            <User size={11} className="shrink-0"/>
            {aseo.responsable}
          </div>
        )}

        {/* Observación */}
        {aseo?.observaciones && (
          <p className="text-body-xs text-blanco-roto/50 italic leading-tight line-clamp-2">{aseo.observaciones}</p>
        )}

        {/* Última limpieza */}
        {hab.ultima_limpieza && (
          <p className="text-body-xs text-blanco-roto/25">
            Limpieza:{' '}
            {new Date(hab.ultima_limpieza+'T12:00:00').toLocaleDateString('es-CO',{day:'numeric',month:'short'})}
          </p>
        )}

        {/* Botón cambiar */}
        <button onClick={onCambiar}
          className="w-full flex items-center justify-center gap-2 py-2.5 rounded-xl border border-white/15 text-body-xs font-semibold text-blanco-roto/60 hover:text-blanco-roto hover:border-dorado/40 hover:bg-dorado/5 active:scale-95 transition-all">
          <Pencil size={12}/>
          Cambiar estado
        </button>
      </div>
    </div>
  )
}

// ── Página principal ──────────────────────────────────────────────
export default function Aseo() {
  const qc = useQueryClient()
  const { rol } = useAuthStore()
  const esGerente = rol === 'gerente'

  const [weekOffset, setWeekOffset] = useState(0)
  const [diaISO,     setDiaISO]     = useState(HOY)
  const [modalHab,   setModalHab]   = useState<HabRow | null>(null)
  const [repartiendo, setRepartiendo] = useState(false)

  const semana = useMemo(() => {
    const inicio = startOfWeek(weekOffset)
    return Array.from({length:7}, (_,i) => {
      const d = addDays(inicio,i)
      return { iso:toISO(d), nombre:DIAS[i], num:d.getDate() }
    })
  }, [weekOffset])

  const weekStart = semana[0].iso
  const weekEnd   = semana[6].iso

  const { data: habs = [] } = useQuery({ queryKey:['habs-aseo'], queryFn:fetchHabs, staleTime:60_000 })

  const { data: aseosSemana = [], refetch } = useQuery({
    queryKey: ['aseos-semana', weekStart, weekEnd],
    queryFn:  () => fetchAseosSemana(weekStart, weekEnd),
    staleTime: 0,
  })

  // Progreso por día para las barras
  const progreso = useMemo(() => {
    const m: Record<string,number> = {}
    semana.forEach(d => { m[d.iso] = aseosSemana.filter(a => a.fecha===d.iso && a.estado==='completado').length / 24 })
    return m
  }, [aseosSemana, semana])

  // Aseos del día indexados
  const aseosDia = useMemo(() => {
    const m: Record<string,AseoRow> = {}
    aseosSemana.filter(a => a.fecha===diaISO).forEach(a => { m[a.habitacion_id]=a })
    return m
  }, [aseosSemana, diaISO])

  // Stats
  const stats = useMemo(() => ({
    sucias:  habs.filter(h => (aseosDia[h.id]?.estado ?? 'pendiente')==='pendiente').length,
    repasar: habs.filter(h => aseosDia[h.id]?.estado==='en_proceso').length,
    ok:      habs.filter(h => aseosDia[h.id]?.estado==='completado').length,
  }), [habs, aseosDia])

  // Repartir aseadoras equitativamente
  const handleRepartir = useCallback(async () => {
    if (!esGerente) return
    setRepartiendo(true)
    try {
      const shuffled = [...habs].sort(() => Math.random() - 0.5)
      const porAseadora = Math.ceil(shuffled.length / ASEADORAS.length)
      await Promise.all(shuffled.map((hab, i) =>
        saveAseo({
          habitacion_id: hab.id,
          fecha: diaISO,
          estado: aseosDia[hab.id]?.estado ?? 'pendiente',
          observaciones: aseosDia[hab.id]?.observaciones ?? '',
          responsable: ASEADORAS[Math.floor(i / porAseadora)],
        })
      ))
      refetch()
      qc.invalidateQueries({ queryKey: ['habs-aseo'] })
    } finally {
      setRepartiendo(false)
    }
  }, [habs, diaISO, aseosDia, esGerente, refetch, qc])

  const pisos = [1,2,3,4]
  const PISO_TOTAL: Record<number,number> = {1:3,2:7,3:7,4:7}

  function colorBarra(pct:number) {
    if (pct>=0.7) return 'bg-green-500'
    if (pct>=0.4) return 'bg-amber-500'
    if (pct>0)    return 'bg-red-500'
    return 'bg-negro-profundo'
  }

  const mes = new Date(diaISO+'T12:00:00').toLocaleDateString('es-CO',{month:'long',year:'numeric'})

  return (
    <div className="p-4 lg:p-6 space-y-6">

      {/* Navegación semanal */}
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <button onClick={() => setWeekOffset(o=>o-1)}
            className="flex items-center gap-1 px-3 py-2 rounded-xl border border-white/10 text-body-sm text-blanco-roto/60 hover:text-blanco-roto hover:border-white/20 transition-all">
            <ChevronLeft size={15}/> Anterior
          </button>
          <div className="text-center">
            <p className="text-body-sm font-semibold text-blanco-roto capitalize">{mes}</p>
            <p className="text-body-xs text-blanco-roto/40">{weekOffset===0?'Semana actual':`${Math.abs(weekOffset)} sem. atrás`}</p>
          </div>
          <button onClick={() => setWeekOffset(o=>o+1)} disabled={weekOffset>=0}
            className="flex items-center gap-1 px-3 py-2 rounded-xl border border-white/10 text-body-sm text-blanco-roto/60 hover:text-blanco-roto hover:border-white/20 disabled:opacity-30 disabled:cursor-not-allowed transition-all">
            Siguiente <ChevronRight size={15}/>
          </button>
        </div>

        <div className="grid grid-cols-7 gap-1.5">
          {semana.map(d => {
            const pct  = progreso[d.iso] ?? 0
            const fill = Math.round(pct*100)
            const sel  = d.iso===diaISO
            const esHoy = d.iso===HOY
            return (
              <button key={d.iso} onClick={() => setDiaISO(d.iso)}
                className={`relative overflow-hidden rounded-xl border text-center py-3 px-1 transition-all ${
                  sel ? 'border-dorado ring-1 ring-dorado/40 shadow-dorado-sm' : 'border-white/10 hover:border-white/25'}`}>
                <div className={`absolute bottom-0 left-0 right-0 transition-all duration-700 ease-out ${colorBarra(pct)} opacity-25`} style={{height:`${fill}%`}}/>
                <div className="relative z-10">
                  <p className={`text-body-xs ${sel?'text-dorado font-bold':'text-blanco-roto/50'}`}>{d.nombre}</p>
                  <p className={`font-mono font-black mt-0.5 ${sel?'text-dorado text-body-lg':'text-blanco-roto text-body-sm'}`}>{d.num}</p>
                  {esHoy && <p className="text-body-xs font-black text-dorado mt-0.5">HOY</p>}
                  {fill>0 && <p className="text-body-xs mt-0.5 text-blanco-roto/40">{fill}%</p>}
                </div>
              </button>
            )
          })}
        </div>
      </div>

      {/* Stats + Botón repartir */}
      <div className="flex gap-3 items-stretch">
        <div className="grid grid-cols-3 gap-3 flex-1">
          {[
            { key:'sucias',  val:stats.sucias,  label:'Sucias',  dot:'bg-red-500',   text:'text-red-300',   border:'border-red-800/30' },
            { key:'repasar', val:stats.repasar, label:'Repasar', dot:'bg-amber-400', text:'text-amber-300', border:'border-amber-700/30' },
            { key:'ok',      val:stats.ok,      label:'OK',      dot:'bg-green-500', text:'text-green-300', border:'border-green-800/30' },
          ].map(s => (
            <div key={s.key} className={`glass rounded-xl p-4 border ${s.border}`}>
              <div className="flex items-center gap-2 mb-1">
                <div className={`w-2.5 h-2.5 rounded-full ${s.dot}`}/>
                <p className={`text-body-xs ${s.text} opacity-70 uppercase tracking-wider`}>{s.label}</p>
              </div>
              <p className={`font-mono text-mono-lg font-black ${s.text}`}>{s.val}</p>
            </div>
          ))}
        </div>

        {/* Botón Repartir — solo gerente */}
        {esGerente && (
          <button onClick={handleRepartir} disabled={repartiendo}
            className="flex flex-col items-center justify-center gap-2 px-5 py-4 glass rounded-xl border border-dorado/20 hover:border-dorado/50 hover:bg-dorado/5 text-dorado transition-all disabled:opacity-50 shrink-0">
            {repartiendo ? <Loader2 size={20} className="animate-spin"/> : <Shuffle size={20}/>}
            <span className="text-body-xs font-semibold text-center leading-tight">
              {repartiendo ? 'Repartiendo...' : 'Repartir aseo'}
            </span>
          </button>
        )}
      </div>

      {/* Leyenda aseadoras */}
      {esGerente && (
        <div className="flex gap-3 flex-wrap">
          <p className="text-body-xs text-blanco-roto/30 uppercase tracking-wider self-center">Aseadoras:</p>
          {ASEADORAS.map(a => (
            <span key={a} className="flex items-center gap-1.5 text-body-xs text-blanco-roto/50 glass px-3 py-1 rounded-full">
              <User size={11}/> {a}
            </span>
          ))}
        </div>
      )}

      {/* Habitaciones por piso */}
      <div className="space-y-8">
        {pisos.map(piso => {
          const habsPiso = habs.filter(h => h.piso===piso)
          const okPiso   = habsPiso.filter(h => aseosDia[h.id]?.estado==='completado').length
          const total    = PISO_TOTAL[piso] ?? habsPiso.length
          const pct      = total > 0 ? okPiso/total : 0

          return (
            <section key={piso}>
              {/* Header piso */}
              <div className="flex items-center gap-4 mb-4">
                <div className="flex-1 h-px bg-white/5"/>
                <div className="flex items-center gap-3 px-5 py-3 rounded-2xl bg-dorado/10 border border-dorado/30">
                  <span className="font-display text-display-md font-black text-dorado">PISO {piso}</span>
                  <div className="w-px h-7 bg-dorado/20"/>
                  {/* Mini barra del piso */}
                  <div className="flex flex-col items-center gap-1">
                    <p className={`font-mono text-mono-sm font-bold ${pct>=0.7?'text-green-400':pct>=0.4?'text-amber-400':'text-red-400'}`}>
                      {okPiso}/{total}
                    </p>
                    <div className="w-16 h-1.5 bg-negro-profundo rounded-full overflow-hidden">
                      <div className={`h-full rounded-full transition-all duration-700 ${pct>=0.7?'bg-green-500':pct>=0.4?'bg-amber-400':'bg-red-500'}`}
                        style={{width:`${Math.round(pct*100)}%`}}/>
                    </div>
                  </div>
                </div>
                <div className="flex-1 h-px bg-white/5"/>
              </div>

              <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3">
                {habsPiso.map(hab => (
                  <CardHabitacion key={hab.id} hab={hab} aseo={aseosDia[hab.id]} onCambiar={() => setModalHab(hab)}/>
                ))}
              </div>
            </section>
          )
        })}
      </div>

      {modalHab && (
        <ModalCambiarEstado
          hab={modalHab}
          aseoActual={aseosDia[modalHab.id]}
          fecha={diaISO}
          onClose={() => setModalHab(null)}
          onGuardado={() => { refetch(); qc.invalidateQueries({queryKey:['habs-aseo']}) }}
        />
      )}
    </div>
  )
}
