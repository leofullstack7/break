import { useMemo, useRef, useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  Check, FileText, Loader2, Paperclip, Plus, Target, Upload,
} from 'lucide-react'
import { useAuthStore } from '@/store/authStore'
import { esGerencial, labelRol } from '@/lib/roles'
import {
  crearObjetivo,
  crearTarea,
  fetchObjetivos,
  setEstadoObjetivo,
  setEstadoTarea,
  subirAdjunto,
} from '@/lib/trazabilidad'
import { VisorAdjunto, type AdjuntoVista } from '@/components/objetivos/VisorAdjunto'
import type { EstadoObjetivo, Objetivo, Tarea, TrazabilidadAdjunto } from '@/types/database.types'

const FILTROS: { id: EstadoObjetivo | 'todas'; label: string }[] = [
  { id: 'todas', label: 'Todas' },
  { id: 'en_curso', label: 'En curso' },
  { id: 'cumplido', label: 'Cumplidas' },
  { id: 'abierto', label: 'Abiertas' },
]

export default function Objetivos() {
  const { user, rol } = useAuthStore()
  const qc = useQueryClient()
  const [filtro, setFiltro] = useState<(typeof FILTROS)[number]['id']>('todas')
  const [abiertoId, setAbiertoId] = useState<string | null>(null)
  const [nuevo, setNuevo] = useState(false)
  const [titulo, setTitulo] = useState('')
  const [desc, setDesc] = useState('')
  const [preview, setPreview] = useState<AdjuntoVista | null>(null)

  const { data: objetivos = [], isLoading } = useQuery({
    queryKey: ['objetivos'],
    queryFn: fetchObjetivos,
    staleTime: 10_000,
  })

  const lista = useMemo(() => {
    if (filtro === 'todas') return objetivos
    return objetivos.filter(o => o.estado === filtro)
  }, [objetivos, filtro])

  const stats = useMemo(() => ({
    total: objetivos.length,
    cumplidos: objetivos.filter(o => o.estado === 'cumplido').length,
    curso: objetivos.filter(o => o.estado === 'en_curso').length,
    tareasOk: objetivos.flatMap(o => o.tareas ?? []).filter(t => t.estado === 'completa').length,
    tareas: objetivos.flatMap(o => o.tareas ?? []).length,
  }), [objetivos])

  const crear = useMutation({
    mutationFn: async () => {
      if (!user || !titulo.trim()) return
      const area = rol === 'administracion' ? 'administracion' : rol === 'gerente' ? 'gerencia' : 'ti'
      return crearObjetivo({
        titulo: titulo.trim(),
        descripcion: desc.trim() || undefined,
        area,
        owner_id: user.id,
      })
    },
    onSuccess: () => {
      setTitulo('')
      setDesc('')
      setNuevo(false)
      void qc.invalidateQueries({ queryKey: ['objetivos'] })
    },
  })

  const pct = stats.tareas ? Math.round((stats.tareasOk / stats.tareas) * 100) : 0

  return (
    <div className="w-full max-w-3xl mx-auto px-3 sm:px-4 py-4 space-y-5">
      <div className="flex items-end justify-between gap-3">
        <div>
          <p className="text-body-xs uppercase tracking-[0.28em] text-dorado/70">Trazabilidad</p>
          <h2 className="font-display text-2xl font-semibold text-blanco-roto mt-1">Objetivos</h2>
        </div>
        <button
          type="button"
          onClick={() => setNuevo(v => !v)}
          className="inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-dorado text-negro-absoluto text-body-xs font-semibold"
        >
          <Plus size={14} /> Nuevo
        </button>
      </div>

      <div className="grid grid-cols-3 gap-2">
        <MiniStat label="Cumplidos" valor={stats.cumplidos} />
        <MiniStat label="En curso" valor={stats.curso} />
        <MiniStat label="Avance" valor={`${pct}%`} />
      </div>

      <div className="h-1.5 rounded-full bg-white/5 overflow-hidden">
        <motion.div
          className="h-full bg-dorado"
          initial={{ width: 0 }}
          animate={{ width: `${pct}%` }}
          transition={{ duration: 0.7, ease: 'easeOut' }}
        />
      </div>

      <AnimatePresence>
        {nuevo && (
          <motion.form
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            onSubmit={e => { e.preventDefault(); void crear.mutate() }}
            className="glass rounded-2xl p-4 space-y-3 overflow-hidden"
          >
            <input
              value={titulo}
              onChange={e => setTitulo(e.target.value)}
              placeholder="Nombre del objetivo"
              required
              className="w-full bg-negro-absoluto/40 border border-white/10 rounded-xl px-3 py-3 text-body-sm text-blanco-roto"
            />
            <textarea
              value={desc}
              onChange={e => setDesc(e.target.value)}
              placeholder="Para qué existe (opcional)"
              rows={2}
              className="w-full bg-negro-absoluto/40 border border-white/10 rounded-xl px-3 py-3 text-body-sm text-blanco-roto"
            />
            <button
              type="submit"
              disabled={crear.isPending}
              className="w-full py-3 rounded-xl bg-dorado text-negro-absoluto font-semibold text-body-sm"
            >
              {crear.isPending ? 'Guardando…' : 'Crear objetivo'}
            </button>
          </motion.form>
        )}
      </AnimatePresence>

      <div className="flex gap-1 overflow-x-auto">
        {FILTROS.map(f => (
          <button
            key={f.id}
            type="button"
            onClick={() => setFiltro(f.id)}
            className={`px-3 py-1.5 rounded-lg text-body-xs whitespace-nowrap ${
              filtro === f.id ? 'bg-dorado/15 text-dorado' : 'text-blanco-roto/40'
            }`}
          >
            {f.label}
          </button>
        ))}
      </div>

      {isLoading && (
        <div className="space-y-2">
          {Array.from({ length: 4 }).map((_, i) => (
            <div key={i} className="h-24 rounded-2xl shimmer" />
          ))}
        </div>
      )}

      <div className="space-y-3">
        {lista.map((o, i) => (
          <TarjetaObjetivo
            key={o.id}
            objetivo={o}
            delay={i * 0.04}
            abierta={abiertoId === o.id}
            onToggle={() => setAbiertoId(abiertoId === o.id ? null : o.id)}
            onPreview={setPreview}
          />
        ))}
      </div>

      <VisorAdjunto adjunto={preview} onClose={() => setPreview(null)} />
    </div>
  )
}

function MiniStat({ label, valor }: { label: string; valor: string | number }) {
  return (
    <div className="glass rounded-2xl p-3">
      <p className="font-display text-xl text-dorado">{valor}</p>
      <p className="text-[0.65rem] uppercase tracking-wider text-blanco-roto/40">{label}</p>
    </div>
  )
}

function TarjetaObjetivo({
  objetivo, abierta, onToggle, delay, onPreview,
}: {
  objetivo: Objetivo
  abierta: boolean
  onToggle: () => void
  delay: number
  onPreview: (a: AdjuntoVista) => void
}) {
  const { user } = useAuthStore()
  const qc = useQueryClient()
  const fileRef = useRef<HTMLInputElement>(null)
  const [tareaTitulo, setTareaTitulo] = useState('')
  const tareas = objetivo.tareas ?? []
  const hechas = tareas.filter(t => t.estado === 'completa').length
  const pct = tareas.length ? Math.round((hechas / tareas.length) * 100) : (objetivo.estado === 'cumplido' ? 100 : 0)

  const toggleObj = useMutation({
    mutationFn: () => setEstadoObjetivo(
      objetivo.id,
      objetivo.estado === 'cumplido' ? 'en_curso' : 'cumplido',
    ),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['objetivos'] }),
  })

  const addTarea = useMutation({
    mutationFn: () => {
      if (!user || !tareaTitulo.trim()) return Promise.resolve()
      return crearTarea({
        objetivo_id: objetivo.id,
        titulo: tareaTitulo.trim(),
        created_by: user.id,
        asignado_id: user.id,
      })
    },
    onSuccess: () => {
      setTareaTitulo('')
      void qc.invalidateQueries({ queryKey: ['objetivos'] })
    },
  })

  const upload = useMutation({
    mutationFn: (file: File) => {
      if (!user) throw new Error('Sin sesión')
      return subirAdjunto({ file, objetivoId: objetivo.id, userId: user.id })
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['objetivos'] }),
  })

  return (
    <motion.article
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay }}
      className="glass rounded-2xl overflow-hidden"
    >
      <button type="button" onClick={onToggle} className="w-full text-left p-4">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <div className="flex items-center gap-2 mb-1">
              <Target size={14} className="text-dorado shrink-0" />
              <p className="font-medium text-blanco-roto truncate">{objetivo.titulo}</p>
            </div>
            <p className="text-body-xs text-blanco-roto/40">
              {labelRol(objetivo.owner?.rol)} · {objetivo.owner?.nombre ?? 'Equipo'}
              {objetivo.fecha_objetivo ? ` · ${objetivo.fecha_objetivo}` : ''}
            </p>
          </div>
          <span className={`text-[0.65rem] uppercase tracking-wider px-2 py-1 rounded-lg border ${
            objetivo.estado === 'cumplido'
              ? 'text-emerald-300 border-emerald-500/30'
              : 'text-dorado/80 border-dorado/25'
          }`}>
            {objetivo.estado === 'cumplido' ? 'Cumplido' : objetivo.estado.replace('_', ' ')}
          </span>
        </div>
        <div className="mt-3 h-1 rounded-full bg-white/5 overflow-hidden">
          <div className="h-full bg-dorado/80" style={{ width: `${pct}%` }} />
        </div>
        <p className="text-[0.65rem] text-blanco-roto/30 mt-1">{hechas}/{tareas.length} tareas</p>
      </button>

      <AnimatePresence>
        {abierta && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            className="overflow-hidden"
          >
            <div className="px-4 pb-4 space-y-3 border-t border-white/5 pt-3">
              {objetivo.descripcion && (
                <p className="text-body-sm text-blanco-roto/60">{objetivo.descripcion}</p>
              )}

              <div className="space-y-2">
                {tareas.map(t => (
                  <FilaTarea key={t.id} tarea={t} onPreview={onPreview} />
                ))}
              </div>

              <form
                onSubmit={e => { e.preventDefault(); void addTarea.mutate() }}
                className="flex gap-2"
              >
                <input
                  value={tareaTitulo}
                  onChange={e => setTareaTitulo(e.target.value)}
                  placeholder="Nueva tarea"
                  className="flex-1 bg-negro-absoluto/40 border border-white/10 rounded-xl px-3 py-2 text-body-xs text-blanco-roto"
                />
                <button type="submit" className="px-3 rounded-xl border border-white/10 text-dorado">
                  <Plus size={14} />
                </button>
              </form>

              <div className="flex flex-wrap gap-2">
                {(objetivo.adjuntos ?? []).map(a => (
                  <AdjuntoChip key={a.id} adjunto={a} onPreview={onPreview} />
                ))}
                <button
                  type="button"
                  onClick={() => fileRef.current?.click()}
                  className="inline-flex items-center gap-1 px-2.5 py-1.5 rounded-lg border border-white/10 text-body-xs text-blanco-roto/50"
                >
                  {upload.isPending ? <Loader2 size={12} className="animate-spin" /> : <Upload size={12} />}
                  PDF / Word / JPG
                </button>
                <input
                  ref={fileRef}
                  type="file"
                  accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.webp,application/pdf,image/*"
                  className="hidden"
                  onChange={e => {
                    const f = e.target.files?.[0]
                    if (f) void upload.mutate(f)
                    e.target.value = ''
                  }}
                />
              </div>

              {esGerencial(useAuthStore.getState().rol) && (
                <button
                  type="button"
                  onClick={() => void toggleObj.mutate()}
                  className="w-full py-2.5 rounded-xl border border-dorado/30 text-dorado text-body-xs font-medium"
                >
                  {objetivo.estado === 'cumplido' ? 'Reabrir objetivo' : 'Marcar objetivo cumplido'}
                </button>
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.article>
  )
}

function FilaTarea({ tarea, onPreview }: { tarea: Tarea; onPreview: (a: AdjuntoVista) => void }) {
  const { user } = useAuthStore()
  const qc = useQueryClient()
  const fileRef = useRef<HTMLInputElement>(null)
  const hecha = tarea.estado === 'completa'
  const toggle = useMutation({
    mutationFn: () => setEstadoTarea(tarea.id, hecha ? 'pendiente' : 'completa'),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['objetivos'] }),
  })
  const upload = useMutation({
    mutationFn: (file: File) => {
      if (!user) throw new Error('Sin sesión')
      return subirAdjunto({
        file,
        tareaId: tarea.id,
        userId: user.id,
      })
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['objetivos'] }),
  })

  return (
    <div className="rounded-xl bg-white/[0.03] p-2.5 space-y-2">
      <button
        type="button"
        onClick={() => void toggle.mutate()}
        className="w-full flex items-start gap-3 text-left"
      >
        <span className={`mt-0.5 w-5 h-5 rounded-full border flex items-center justify-center shrink-0 ${
          hecha ? 'bg-dorado border-dorado text-negro-absoluto' : 'border-white/20'
        }`}>
          {hecha && <Check size={12} />}
        </span>
        <span className={`text-body-sm ${hecha ? 'text-blanco-roto/40 line-through' : 'text-blanco-roto'}`}>
          {tarea.titulo}
        </span>
      </button>
      <div className="pl-8 flex flex-wrap gap-1.5">
        {(tarea.adjuntos ?? []).map(a => (
          <AdjuntoChip key={a.id} adjunto={a} onPreview={onPreview} />
        ))}
        <button
          type="button"
          onClick={() => fileRef.current?.click()}
          className="inline-flex items-center gap-1 px-2 py-1 rounded-lg border border-white/10 text-[0.65rem] text-blanco-roto/45"
        >
          {upload.isPending ? <Loader2 size={10} className="animate-spin" /> : <Paperclip size={10} />}
          Soporte
        </button>
        <input
          ref={fileRef}
          type="file"
          accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.webp,application/pdf,image/*"
          className="hidden"
          onChange={e => {
            const f = e.target.files?.[0]
            if (f) void upload.mutate(f)
            e.target.value = ''
          }}
        />
      </div>
    </div>
  )
}

function AdjuntoChip({
  adjunto,
  onPreview,
}: {
  adjunto: TrazabilidadAdjunto
  onPreview: (a: AdjuntoVista) => void
}) {
  return (
    <button
      type="button"
      onClick={() => onPreview({
        nombre: adjunto.nombre,
        path: adjunto.path,
        mime: adjunto.mime,
      })}
      className="inline-flex items-center gap-1 px-2.5 py-1.5 rounded-lg bg-dorado/10 text-dorado text-body-xs"
    >
      <FileText size={12} />
      <Paperclip size={10} />
      {adjunto.nombre}
    </button>
  )
}
