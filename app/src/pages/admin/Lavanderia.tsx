import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { Shirt, Plus, CheckCircle2 } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { Badge } from '@/components/ui/Badge'

interface LavFila {
  id: string
  fecha: string
  habitacion_numero: number | null
  tipo_prenda: string
  cantidad: number
  tiempo_minutos: number | null
  estado: 'en_proceso' | 'listo' | 'entregado'
  responsable: string | null
}

const hoy = new Date().toISOString().split('T')[0]

async function fetchLavanderia(): Promise<LavFila[]> {
  const { data, error } = await supabase
    .from('lavanderia')
    .select('*, habitaciones(numero)')
    .gte('fecha', hoy)
    .order('fecha', { ascending: false })
    .limit(100)
  if (error) throw error
  return (data ?? []).map((l: any) => ({
    id: l.id, fecha: l.fecha,
    habitacion_numero: l.habitaciones?.numero ?? null,
    tipo_prenda: l.tipo_prenda, cantidad: l.cantidad,
    tiempo_minutos: l.tiempo_minutos, estado: l.estado,
    responsable: l.responsable,
  }))
}

async function crearRegistro(data: { tipo_prenda: string; cantidad: number; tiempo_minutos?: number }) {
  const { error } = await supabase.from('lavanderia').insert({ ...data, fecha: hoy })
  if (error) throw error
}

async function avanzarEstado(id: string, estadoActual: string) {
  const siguiente = estadoActual === 'en_proceso' ? 'listo' : 'entregado'
  const { error } = await supabase.from('lavanderia').update({ estado: siguiente }).eq('id', id)
  if (error) throw error
}

const ESTADO_LABEL: Record<string, string> = {
  en_proceso: 'En proceso', listo: 'Listo', entregado: 'Entregado'
}

const TIPO_BADGE: Record<string, 'pendiente' | 'confirmada' | 'completada'> = {
  en_proceso: 'pendiente', listo: 'confirmada', entregado: 'completada'
}

const PRENDAS = ['Sábana', 'Funda', 'Toalla grande', 'Toalla pequeña', 'Cubrecama', 'Toalla de piso', 'Otro']

export default function Lavanderia() {
  const qc = useQueryClient()
  const [mostrarForm, setMostrarForm] = useState(false)
  const [prenda, setPrenda] = useState('Sábana')
  const [cantidad, setCantidad] = useState(1)
  const [tiempo, setTiempo] = useState('')

  const { data: items = [], isLoading } = useQuery({
    queryKey: ['lavanderia'],
    queryFn: fetchLavanderia,
    refetchInterval: 60_000,
  })

  const { mutate: crear } = useMutation({
    mutationFn: crearRegistro,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['lavanderia'] }); setMostrarForm(false) },
  })

  const { mutate: avanzar } = useMutation({
    mutationFn: ({ id, estado }: { id: string; estado: string }) => avanzarEstado(id, estado),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['lavanderia'] }),
  })

  const enProceso  = items.filter(i => i.estado === 'en_proceso')
  const listos     = items.filter(i => i.estado === 'listo')
  const entregados = items.filter(i => i.estado === 'entregado')

  return (
    <div className="p-4 lg:p-6 space-y-5">

      {/* Stats + botón */}
      <div className="flex items-start gap-3">
        <div className="grid grid-cols-3 gap-3 flex-1">
          <div className="glass rounded-xl p-3 text-center">
            <p className="font-mono text-mono-md font-bold text-amber-400">{enProceso.length}</p>
            <p className="text-body-xs text-blanco-roto/40 mt-0.5">Lavando</p>
          </div>
          <div className="glass rounded-xl p-3 text-center">
            <p className="font-mono text-mono-md font-bold text-green-400">{listos.length}</p>
            <p className="text-body-xs text-blanco-roto/40 mt-0.5">Listos</p>
          </div>
          <div className="glass rounded-xl p-3 text-center">
            <p className="font-mono text-mono-md font-bold text-blanco-roto/60">{entregados.length}</p>
            <p className="text-body-xs text-blanco-roto/40 mt-0.5">Entregados</p>
          </div>
        </div>
        <button
          onClick={() => setMostrarForm(v => !v)}
          className="flex items-center gap-2 px-4 py-3 bg-dorado text-negro-absoluto font-semibold text-body-sm rounded-xl hover:shadow-glow transition-all shrink-0"
        >
          <Plus size={16} />
          <span className="hidden sm:inline">Registrar</span>
        </button>
      </div>

      {/* Formulario rápido */}
      {mostrarForm && (
        <div className="glass rounded-xl p-5 space-y-4">
          <h3 className="text-body-sm font-semibold text-blanco-roto">Nuevo registro de lavandería</h3>
          <div className="grid sm:grid-cols-3 gap-3">
            <div className="space-y-1">
              <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Prenda</label>
              <select value={prenda} onChange={e => setPrenda(e.target.value)}
                className="w-full bg-negro-absoluto border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50">
                {PRENDAS.map(p => <option key={p}>{p}</option>)}
              </select>
            </div>
            <div className="space-y-1">
              <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Cantidad</label>
              <input type="number" min={1} value={cantidad} onChange={e => setCantidad(Number(e.target.value))}
                className="w-full bg-negro-absoluto border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50" />
            </div>
            <div className="space-y-1">
              <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Tiempo (min)</label>
              <input type="number" min={1} value={tiempo} onChange={e => setTiempo(e.target.value)}
                placeholder="Opcional"
                className="w-full bg-negro-absoluto border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:outline-none focus:border-dorado/50" />
            </div>
          </div>
          <div className="flex gap-2">
            <button
              onClick={() => crear({ tipo_prenda: prenda, cantidad, tiempo_minutos: tiempo ? Number(tiempo) : undefined })}
              className="px-4 py-2 bg-dorado text-negro-absoluto font-semibold text-body-sm rounded-xl"
            >
              Guardar
            </button>
            <button onClick={() => setMostrarForm(false)} className="px-4 py-2 text-body-sm text-blanco-roto/50 hover:text-blanco-roto">
              Cancelar
            </button>
          </div>
        </div>
      )}

      {isLoading && <div className="h-48 rounded-xl shimmer" />}

      {!isLoading && items.length === 0 && (
        <div className="glass rounded-2xl p-12 text-center">
          <Shirt size={32} className="mx-auto text-blanco-roto/20 mb-3" />
          <p className="text-body-md text-blanco-roto/50">Sin registros de lavandería</p>
        </div>
      )}

      {/* Lista */}
      {items.length > 0 && (
        <div className="space-y-2">
          {[...enProceso, ...listos, ...entregados].map(item => (
            <div key={item.id} className="glass rounded-xl p-4 flex items-center gap-4">
              <Shirt size={18} className="text-blanco-roto/30 shrink-0" />
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 flex-wrap">
                  <p className="text-body-sm font-medium text-blanco-roto">
                    {item.cantidad}x {item.tipo_prenda}
                  </p>
                  <Badge variant={TIPO_BADGE[item.estado]}>
                    {ESTADO_LABEL[item.estado]}
                  </Badge>
                </div>
                <p className="text-body-xs text-blanco-roto/40 mt-0.5">
                  {item.habitacion_numero ? `Hab. ${item.habitacion_numero} · ` : ''}
                  {item.tiempo_minutos ? `${item.tiempo_minutos} min` : ''}
                </p>
              </div>
              {item.estado !== 'entregado' && (
                <button
                  onClick={() => avanzar({ id: item.id, estado: item.estado })}
                  className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-green-900/30 border border-green-700/40 text-green-300 text-body-xs hover:bg-green-900/50 transition-colors shrink-0"
                >
                  <CheckCircle2 size={12} />
                  {item.estado === 'en_proceso' ? 'Listo' : 'Entregar'}
                </button>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
