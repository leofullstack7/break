import { useState, useMemo, useCallback } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { CalendarDays, ChevronRight, ChevronLeft, Eye, Plus, Search, X, Pencil, Trash2, AlertTriangle, FileText } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { autorizarFacturaSiigo } from '@/lib/siigo-facturar'
import { Badge } from '@/components/ui/Badge'
import { SearchInput } from '@/components/ui/SearchInput'
import { Modal } from '@/components/ui/Modal'
import type { EstadoReserva, Huesped, Operador } from '@/types/database.types'

const PAGE_SIZE = 20

// ── Tipos ─────────────────────────────────────────────────────────
interface ReservaFila {
  id: string
  habitacion_numero: number
  huesped_id: string
  huesped_nombre: string
  huesped_cedula: string | null
  huesped_celular: string | null
  acompanante: string | null
  cc_acompanante: string | null
  fecha_entrada: string
  fecha_salida: string
  noches: number
  pago_total: number
  comision: number | null
  aseo_cobrado: number | null
  ingreso_hotel: number | null
  ingreso_operador: number | null
  ingreso_neto: number | null
  check_in_early: string | null
  check_out_late: string | null
  verificacion: number | null
  operador_nombre: string | null
  metodo_pago: string | null
  estado: EstadoReserva
  observaciones: string | null
  siigo_estado: string | null
  siigo_numero: string | null
  siigo_factura_id: string | null
  siigo_error: string | null
}

// ── Queries ───────────────────────────────────────────────────────
async function fetchReservas(): Promise<ReservaFila[]> {
  const { data, error } = await supabase
    .from('reservas')
    .select(`
      id, fecha_entrada, fecha_salida, noches, pago_total, comision,
      aseo_cobrado, ingreso_hotel, ingreso_operador, ingreso_neto,
      check_in_early, check_out_late, verificacion,
      estado, acompanante, cc_acompanante, metodo_pago, observaciones, huesped_id,
      siigo_estado, siigo_numero, siigo_factura_id, siigo_error,
      habitaciones(numero),
      huespedes(nombre, cedula, celular),
      operadores(nombre)
    `)
    .is('deleted_at', null)
    .order('fecha_entrada', { ascending: false })
    .limit(1000)
  if (error) throw error
  return (data ?? []).map((r: any): ReservaFila => ({
    id: r.id,
    habitacion_numero: r.habitaciones?.numero ?? 0,
    huesped_id: r.huesped_id,
    huesped_nombre: r.huespedes?.nombre ?? '—',
    huesped_cedula: r.huespedes?.cedula ?? null,
    huesped_celular: r.huespedes?.celular ?? null,
    acompanante: r.acompanante,
    cc_acompanante: r.cc_acompanante,
    fecha_entrada: r.fecha_entrada,
    fecha_salida: r.fecha_salida,
    noches: r.noches ?? 0,
    pago_total: r.pago_total ?? 0,
    comision: r.comision,
    aseo_cobrado: r.aseo_cobrado,
    ingreso_hotel: r.ingreso_hotel,
    ingreso_operador: r.ingreso_operador,
    ingreso_neto: r.ingreso_neto,
    check_in_early: r.check_in_early,
    check_out_late: r.check_out_late,
    verificacion: r.verificacion,
    operador_nombre: r.operadores?.nombre ?? null,
    metodo_pago: r.metodo_pago,
    estado: r.estado,
    observaciones: r.observaciones,
    siigo_estado: r.siigo_estado ?? null,
    siigo_numero: r.siigo_numero ?? null,
    siigo_factura_id: r.siigo_factura_id ?? null,
    siigo_error: r.siigo_error ?? null,
  }))
}

async function fetchOperadores(): Promise<Operador[]> {
  const { data } = await supabase.from('operadores').select('*').eq('activo', true).order('nombre')
  return (data ?? []) as Operador[]
}

async function fetchHabitacionesDisponibles(entrada: string, salida: string) {
  if (!entrada || !salida || entrada >= salida) return []
  const { data } = await supabase
    .from('habitaciones')
    .select('id, numero, piso, precio_base')
    .order('numero')
  if (!data) return []
  const disponibles = await Promise.all(
    data.map(async h => {
      const { data: ok } = await supabase.rpc('habitacion_disponible', {
        p_habitacion_id: h.id, p_fecha_entrada: entrada, p_fecha_salida: salida,
      })
      return ok ? h : null
    })
  )
  return disponibles.filter(Boolean) as typeof data
}

async function buscarHuespedes(q: string): Promise<Huesped[]> {
  if (q.length < 2) return []
  const { data } = await supabase
    .from('huespedes')
    .select('*')
    .or(`nombre.ilike.%${q}%,cedula.ilike.%${q}%,celular.ilike.%${q}%`)
    .is('deleted_at', null)
    .limit(8)
  return (data ?? []) as Huesped[]
}

// ── Formatters ────────────────────────────────────────────────────
const fFecha = (f: string) =>
  new Date(f + 'T12:00:00').toLocaleDateString('es-CO', { day: 'numeric', month: 'short', year: '2-digit' })

const fMonto = (m: number | null | undefined) => {
  if (m == null) return '—'
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', maximumFractionDigits: 0 }).format(m)
}
const fMontoCorto = (m: number | null | undefined) => fMonto(m)

const ESTADOS_FILTRO = [
  { value: '', label: 'Todos' },
  { value: 'activa', label: 'Activa' },
  { value: 'confirmada', label: 'Confirmada' },
  { value: 'completada', label: 'Completada' },
  { value: 'cancelada', label: 'Cancelada' },
  { value: 'pendiente', label: 'Pendiente' },
]
const LABEL_ESTADO: Record<EstadoReserva, string> = {
  pendiente: 'Pendiente', confirmada: 'Confirmada', activa: 'Activa',
  completada: 'Completada', cancelada: 'Cancelada',
}

const esCedulaReal = (c: string | null) => c && !c.startsWith('SIN_CC_')
const mostrarCedula = (c: string | null) => {
  if (!c) return 'No registrada'
  if (c.startsWith('SIN_CC_')) return 'No registrada'
  return c
}

// ── Modal Editar Reserva ──────────────────────────────────────────
function ModalEditar({ r, onClose }: { r: ReservaFila; onClose: () => void }) {
  const qc = useQueryClient()
  const [fechaE,   setFechaE]   = useState(r.fecha_entrada)
  const [fechaS,   setFechaS]   = useState(r.fecha_salida)
  const [pago,     setPago]     = useState(String(r.pago_total))
  const [metodo,   setMetodo]   = useState(r.metodo_pago ?? 'Transferencia')
  const [acomp,    setAcomp]    = useState(r.acompanante ?? '')
  const [ccAcomp,  setCcAcomp]  = useState(r.cc_acompanante ?? '')
  const [obs,      setObs]      = useState(r.observaciones ?? '')
  const [error,    setError]    = useState('')
  const [guardando,setGuardando]= useState(false)

  const inputCls = "w-full bg-negro-absoluto border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:outline-none focus:border-dorado/50 transition-colors"
  const labelCls = "block text-body-xs text-blanco-roto/40 uppercase tracking-wider mb-1"

  async function handleGuardar() {
    setError('')
    if (!fechaE || !fechaS || fechaE >= fechaS) { setError('Las fechas no son válidas'); return }
    setGuardando(true)
    try {
      const { error: e } = await supabase
        .from('reservas')
        .update({
          fecha_entrada:   fechaE,
          fecha_salida:    fechaS,
          pago_total:      Number(pago) || r.pago_total,
          metodo_pago:     metodo || null,
          acompanante:     acomp  || null,
          cc_acompanante:  ccAcomp || null,
          observaciones:   obs    || null,
        } as any)
        .eq('id', r.id)
      if (e) throw new Error(e.message)
      qc.invalidateQueries({ queryKey: ['reservas-completas'] })
      onClose()
    } catch (e: any) {
      setError(e.message ?? 'Error al guardar')
    } finally {
      setGuardando(false)
    }
  }

  return (
    <Modal isOpen onClose={onClose} title={`Editar — Hab. ${r.habitacion_numero}`} size="md">
      <div className="space-y-4">
        <div className="glass rounded-xl px-4 py-3 flex items-center gap-2">
          <span className="text-body-xs text-blanco-roto/40">Titular:</span>
          <span className="text-body-sm text-blanco-roto font-semibold">{r.huesped_nombre}</span>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className={labelCls}>Check-in *</label>
            <input type="date" className={`${inputCls} [color-scheme:dark]`} value={fechaE}
              onChange={e => setFechaE(e.target.value)} />
          </div>
          <div>
            <label className={labelCls}>Check-out *</label>
            <input type="date" className={`${inputCls} [color-scheme:dark]`} value={fechaS}
              onChange={e => setFechaS(e.target.value)} />
          </div>
        </div>

        <div>
          <label className={labelCls}>Pago total (COP)</label>
          <input className={inputCls} type="number" value={pago}
            onChange={e => setPago(e.target.value)} />
        </div>

        <div>
          <label className={labelCls}>Método de pago</label>
          <select className={inputCls} value={metodo} onChange={e => setMetodo(e.target.value)}>
            {['Transferencia', 'Efectivo', 'Tarjeta', 'Nequi', 'Daviplata'].map(m => (
              <option key={m}>{m}</option>
            ))}
          </select>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className={labelCls}>Acompañante</label>
            <input className={inputCls} value={acomp}
              onChange={e => setAcomp(e.target.value)} placeholder="Nombre" />
          </div>
          <div>
            <label className={labelCls}>CC acompañante</label>
            <input className={inputCls} value={ccAcomp}
              onChange={e => setCcAcomp(e.target.value)} placeholder="Cédula" />
          </div>
        </div>

        <div>
          <label className={labelCls}>Observaciones</label>
          <textarea className={`${inputCls} resize-none`} rows={2} value={obs}
            onChange={e => setObs(e.target.value)} />
        </div>

        {error && <p className="text-body-sm text-red-400">{error}</p>}

        <div className="flex gap-3 pt-1">
          <button onClick={handleGuardar} disabled={guardando}
            className="flex-1 py-3 bg-dorado text-negro-absoluto font-semibold text-body-sm rounded-xl hover:shadow-glow disabled:opacity-50 transition-all">
            {guardando ? 'Guardando...' : 'Guardar cambios'}
          </button>
          <button onClick={onClose}
            className="px-4 text-body-sm text-blanco-roto/40 hover:text-blanco-roto transition-colors">
            Cancelar
          </button>
        </div>
      </div>
    </Modal>
  )
}

// ── Modal Cancelar Reserva ────────────────────────────────────────
function ModalCancelar({ r, onClose }: { r: ReservaFila; onClose: () => void }) {
  const qc = useQueryClient()
  const [cancelando, setCancelando] = useState(false)

  async function handleCancelar() {
    setCancelando(true)
    try {
      await supabase.from('reservas').update({ estado: 'cancelada' } as any).eq('id', r.id)
      qc.invalidateQueries({ queryKey: ['reservas-completas'] })
      qc.invalidateQueries({ queryKey: ['mapa'] })
      onClose()
    } finally {
      setCancelando(false)
    }
  }

  return (
    <Modal isOpen onClose={onClose} title="Cancelar reserva" size="sm">
      <div className="space-y-5 text-center">
        <div className="w-14 h-14 rounded-full bg-red-900/20 border border-red-700/30 flex items-center justify-center mx-auto">
          <AlertTriangle size={24} className="text-red-400" />
        </div>
        <div>
          <p className="text-body-md font-semibold text-blanco-roto">
            ¿Cancelar esta reserva?
          </p>
          <p className="text-body-sm text-blanco-roto/50 mt-1.5">
            Hab. {r.habitacion_numero} · {r.huesped_nombre}<br />
            {new Date(r.fecha_entrada + 'T12:00:00').toLocaleDateString('es-CO', { day: 'numeric', month: 'short' })}
            {' → '}
            {new Date(r.fecha_salida + 'T12:00:00').toLocaleDateString('es-CO', { day: 'numeric', month: 'short' })}
          </p>
        </div>
        <p className="text-body-xs text-blanco-roto/30 glass rounded-xl px-4 py-2.5">
          La habitación quedará disponible automáticamente.
        </p>
        <div className="flex gap-3">
          <button onClick={onClose}
            className="flex-1 py-3 border border-white/10 text-blanco-roto/60 hover:text-blanco-roto text-body-sm rounded-xl transition-all">
            Mantener
          </button>
          <button onClick={handleCancelar} disabled={cancelando}
            className="flex-1 py-3 bg-red-600/80 hover:bg-red-600 text-white font-semibold text-body-sm rounded-xl disabled:opacity-50 transition-all">
            {cancelando ? 'Cancelando...' : 'Sí, cancelar'}
          </button>
        </div>
      </div>
    </Modal>
  )
}

// ── Modal Autorizar factura Siigo ─────────────────────────────────
function ModalFacturarSiigo({ r, onClose }: { r: ReservaFila; onClose: () => void }) {
  const qc = useQueryClient()
  const [busquedaH, setBusquedaH] = useState(r.huesped_nombre !== '—' ? r.huesped_nombre : '')
  const [huespedSel, setHuespedSel] = useState<Huesped | null>(null)
  const [mostrarResultados, setMostrarResultados] = useState(false)
  const [monto, setMonto] = useState(String(r.pago_total > 0 ? r.pago_total : 1))
  const [metodo, setMetodo] = useState(r.metodo_pago || 'Transferencia')
  const docInicial = (r.huesped_cedula && !r.huesped_cedula.startsWith('PXSOL-') && !r.huesped_cedula.startsWith('SIN_CC_'))
    ? r.huesped_cedula
    : ''
  const [documento, setDocumento] = useState(docInicial)
  const [usarConsumidorFinal, setUsarConsumidorFinal] = useState(
    !!(r.huesped_cedula && /^PXSOL-/i.test(r.huesped_cedula)),
  )
  const [autorizado, setAutorizado] = useState(false)
  const [error, setError] = useState('')
  const [okMsg, setOkMsg] = useState('')
  const [enviando, setEnviando] = useState(false)

  const { data: resultados = [] } = useQuery({
    queryKey: ['buscar-h-siigo', busquedaH],
    queryFn: () => buscarHuespedes(busquedaH),
    enabled: busquedaH.length >= 2,
    staleTime: 10_000,
  })

  const titularActual = {
    id: r.huesped_id,
    nombre: r.huesped_nombre,
    cedula: r.huesped_cedula ?? '',
    celular: r.huesped_celular,
  } as Huesped
  const seleccionado = huespedSel ?? titularActual
  const docSintetico = !!(seleccionado.cedula && (/^PXSOL-/i.test(seleccionado.cedula) || /^SIN_CC_/i.test(seleccionado.cedula)))

  async function handleAutorizar() {
    setError('')
    setOkMsg('')
    if (!autorizado) { setError('Marca la casilla de autorizacion para continuar'); return }
    const valor = Number(monto)
    if (!Number.isFinite(valor) || valor <= 0) {
      setError('El monto debe ser mayor a 0'); return
    }
    if (!seleccionado?.id) { setError('Selecciona el huesped a facturar'); return }
    if (!usarConsumidorFinal && !documento.trim() && (docSintetico || !seleccionado.cedula)) {
      setError('Escribe la cedula real, o marca Consumidor Final para prueba'); return
    }

    setEnviando(true)
    try {
      const res = await autorizarFacturaSiigo({
        reservaId: r.id,
        huespedId: seleccionado.id,
        actualizarTitular: seleccionado.id !== r.huesped_id,
        metodoPago: metodo,
        monto: valor,
        documento: documento.trim() || undefined,
        usarConsumidorFinal,
      })
      if (!res.ok) throw new Error(res.error || 'No se pudo facturar')
      setOkMsg(
        `Factura enviada a Siigo` +
          (res.siigo?.numero ? ` · N° ${res.siigo.numero}` : '') +
          (res.consumidor_final ? ' · Consumidor Final' : '') +
          (res.stamp ? ' (timbrada DIAN)' : ' (borrador)'),
      )
      qc.invalidateQueries({ queryKey: ['reservas-completas'] })
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Error al facturar')
    } finally {
      setEnviando(false)
    }
  }

  const yaFacturada = r.siigo_estado === 'facturado'

  return (
    <Modal isOpen onClose={onClose} title="Autorizar factura Siigo" size="md">
      <div className="space-y-4">
        <p className="text-body-sm text-blanco-roto/55">
          Hab. {r.habitacion_numero} · {fFecha(r.fecha_entrada)} → {fFecha(r.fecha_salida)}
        </p>

        {yaFacturada && (
          <div className="rounded-xl border border-green-700/30 bg-green-900/20 px-4 py-3 text-body-sm text-green-300">
            Ya facturada{r.siigo_numero ? ` · N° ${r.siigo_numero}` : ''}.
          </div>
        )}

        {/* Solo errores del intento actual (no el histórico de siigo_error) */}
        {error && (
          <div className="flex items-start gap-2 text-body-sm text-red-400">
            <AlertTriangle size={14} className="mt-0.5 shrink-0" />
            <span className="break-words">{error}</span>
          </div>
        )}

        {docSintetico && !yaFacturada && (
          <div className="rounded-xl border border-amber-600/30 bg-amber-900/15 px-4 py-3 text-body-sm text-amber-200/90">
            Documento interno de PxSol (<span className="font-mono">{seleccionado.cedula}</span>).
            No sirve para Siigo: ingresa cedula real o marca Consumidor Final.
          </div>
        )}

        <div className="space-y-2">
          <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Facturar a (huesped)</label>
          <div className="glass rounded-xl px-4 py-3">
            <p className="text-body-sm font-semibold text-blanco-roto truncate">{seleccionado.nombre}</p>
            <p className="text-body-xs text-blanco-roto/50 font-mono">{mostrarCedula(seleccionado.cedula)}</p>
          </div>
          <div className="relative">
            <div className="flex items-center gap-2 bg-negro-profundo border border-white/10 rounded-xl px-3 py-2.5">
              <Search size={14} className="text-blanco-roto/30 shrink-0" />
              <input
                value={busquedaH}
                onChange={e => { setBusquedaH(e.target.value); setMostrarResultados(true) }}
                placeholder="Buscar otro huesped…"
                className="flex-1 bg-transparent text-body-sm text-blanco-roto focus:outline-none placeholder:text-blanco-roto/25"
              />
            </div>
            {mostrarResultados && resultados.length > 0 && (
              <div className="absolute z-20 mt-1 w-full rounded-xl border border-white/10 bg-negro-profundo shadow-xl overflow-hidden">
                {resultados.map(h => (
                  <button
                    key={h.id}
                    type="button"
                    onClick={() => {
                      setHuespedSel(h)
                      setBusquedaH(h.nombre)
                      setMostrarResultados(false)
                      if (h.cedula && !/^PXSOL-/i.test(h.cedula) && !/^SIN_CC_/i.test(h.cedula)) {
                        setDocumento(h.cedula)
                        setUsarConsumidorFinal(false)
                      }
                    }}
                    className="w-full text-left px-3 py-2.5 hover:bg-white/5 border-b border-white/5 last:border-0"
                  >
                    <p className="text-body-sm text-blanco-roto">{h.nombre}</p>
                    <p className="text-body-xs text-blanco-roto/40 font-mono">{mostrarCedula(h.cedula)}</p>
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>

        <div className="space-y-1">
          <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Documento (cedula / NIT)</label>
          <input
            value={documento}
            onChange={e => setDocumento(e.target.value)}
            placeholder="Ej. 1053812345"
            disabled={usarConsumidorFinal}
            className="w-full bg-negro-profundo border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50 disabled:opacity-40"
          />
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div className="space-y-1">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Monto COP</label>
            <input
              type="number"
              min={1}
              value={monto}
              onChange={e => setMonto(e.target.value)}
              className="w-full bg-negro-profundo border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50"
            />
          </div>
          <div className="space-y-1">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Forma de pago</label>
            <select
              value={metodo}
              onChange={e => setMetodo(e.target.value)}
              className="w-full bg-negro-profundo border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50"
            >
              {['Transferencia', 'Contado', 'Efectivo', 'Tarjeta de Credito', 'Tarjeta de Debito', 'Otro'].map(m => (
                <option key={m} value={m}>{m}</option>
              ))}
            </select>
          </div>
        </div>

        <label className="flex items-start gap-3 glass rounded-xl px-4 py-3 cursor-pointer">
          <input
            type="checkbox"
            checked={usarConsumidorFinal}
            onChange={e => setUsarConsumidorFinal(e.target.checked)}
            className="mt-1 accent-dorado"
            disabled={yaFacturada}
          />
          <span className="text-body-sm text-blanco-roto/80">
            Facturar como <strong className="text-blanco-roto">Consumidor Final</strong>
            {' '}(solo si no hay cédula real).
          </span>
        </label>

        <label className="flex items-start gap-3 glass rounded-xl px-4 py-3 cursor-pointer">
          <input
            type="checkbox"
            checked={autorizado}
            onChange={e => setAutorizado(e.target.checked)}
            className="mt-1 accent-dorado"
            disabled={yaFacturada}
          />
          <span className="text-body-sm text-blanco-roto/80">
            Autorizo crear la factura en <strong className="text-dorado font-semibold">Siigo</strong> a
            nombre de <strong className="text-blanco-roto">{seleccionado.nombre}</strong> por {fMonto(Number(monto) || 0)}.
          </span>
        </label>

        {okMsg && (
          <div className="rounded-xl border border-green-700/30 bg-green-900/20 px-4 py-3 text-body-sm text-green-300">
            {okMsg}
          </div>
        )}

        <div className="flex gap-2 pt-1">
          <button type="button" onClick={onClose}
            className="flex-1 py-2.5 rounded-xl border border-white/10 text-body-sm text-blanco-roto/60">
            {okMsg ? 'Cerrar' : 'Cancelar'}
          </button>
          {!yaFacturada && !okMsg && (
            <button
              type="button"
              onClick={() => void handleAutorizar()}
              disabled={enviando || !autorizado}
              className="flex-1 py-2.5 rounded-xl bg-dorado text-negro-absoluto font-semibold text-body-sm disabled:opacity-40"
            >
              {enviando ? 'Enviando…' : 'Autorizar y facturar'}
            </button>
          )}
        </div>
      </div>
    </Modal>
  )
}

// ── Modal "Ver más" ───────────────────────────────────────────────
function ModalDetalle({ r, onClose, onEditar, onCancelar, onFacturar }: {
  r: ReservaFila
  onClose: () => void
  onEditar: () => void
  onCancelar: () => void
  onFacturar: () => void
}) {
  const fila = (label: string, val: React.ReactNode) => val != null && val !== '' && val !== '—' ? (
    <div className="flex items-start justify-between py-2.5 border-b border-white/5 last:border-0 gap-4">
      <span className="text-body-sm text-blanco-roto/50 shrink-0">{label}</span>
      <span className="text-body-sm text-blanco-roto text-right">{val}</span>
    </div>
  ) : null

  const filaMoneda = (label: string, val: number | null | undefined, accent = false) => val != null ? (
    <div className="flex items-center justify-between py-2.5 border-b border-white/5 last:border-0">
      <span className="text-body-sm text-blanco-roto/50">{label}</span>
      <span className={`font-mono text-mono-sm font-semibold ${accent ? 'text-dorado' : 'text-blanco-roto'}`}>
        {fMonto(val)}
      </span>
    </div>
  ) : null

  const puedeEditar = r.estado !== 'completada' && r.estado !== 'cancelada'

  return (
    <Modal isOpen onClose={onClose} title={`Hab. ${r.habitacion_numero}`} size="md">
      <div className="space-y-5">

        {/* Resumen */}
        <section className="glass rounded-xl px-4">
          {fila('Titular', r.huesped_nombre)}
          {fila('CC titular', mostrarCedula(r.huesped_cedula))}
          {fila('Celular', r.huesped_celular)}
          {r.acompanante && fila('Acompañante', r.acompanante)}
          {r.acompanante && fila('CC acompañante', r.cc_acompanante || 'No registrada')}
          {fila('Fechas', `${fFecha(r.fecha_entrada)} → ${fFecha(r.fecha_salida)}`)}
          {fila('Noches', r.noches)}
          {fila('Estado', <Badge variant={r.estado}>{LABEL_ESTADO[r.estado]}</Badge>)}
        </section>

        {/* Financiero */}
        <section>
          <p className="text-body-xs text-blanco-roto/30 uppercase tracking-wider mb-2">Desglose financiero</p>
          <div className="glass rounded-xl px-4">
            {filaMoneda('Pago total', r.pago_total, true)}
            {filaMoneda('Comisión Airbnb / Booking', r.comision)}
            {filaMoneda('Aseo cobrado', r.aseo_cobrado)}
            {filaMoneda('Ingreso Break Hotel', r.ingreso_hotel)}
            {filaMoneda('Ingreso operador', r.ingreso_operador)}
            {filaMoneda('Total neto (Break + Op.)', r.ingreso_neto)}
            {r.verificacion != null && r.verificacion > 0 && filaMoneda('Verificación', r.verificacion)}
          </div>
        </section>

        {/* Adicional */}
        <section>
          <p className="text-body-xs text-blanco-roto/30 uppercase tracking-wider mb-2">Información adicional</p>
          <div className="glass rounded-xl px-4">
            {fila('Canal de reserva', r.operador_nombre)}
            {fila('Método de pago', r.metodo_pago)}
            {fila('Check-in early', r.check_in_early)}
            {fila('Check-out late', r.check_out_late)}
            {fila('Observaciones', r.observaciones)}
            {fila(
              'Siigo',
              r.siigo_estado === 'facturado'
                ? `Facturado${r.siigo_numero ? ` · ${r.siigo_numero}` : ''}`
                : r.siigo_estado === 'error'
                  ? 'Error al facturar'
                  : r.siigo_estado === 'pendiente'
                    ? 'Pendiente'
                    : 'Sin factura',
            )}
          </div>
        </section>

        {r.estado !== 'cancelada' && (
          <button
            type="button"
            onClick={onFacturar}
            className="w-full flex items-center justify-center gap-2 py-3 rounded-xl border border-dorado/40 text-dorado font-semibold text-body-sm hover:bg-dorado/10"
          >
            <FileText size={16} />
            {r.siigo_estado === 'facturado' ? 'Ver factura Siigo' : 'Autorizar factura Siigo'}
          </button>
        )}

        {/* Acciones */}
        {puedeEditar && (
          <div className="flex gap-2 pt-1 border-t border-white/5">
            <button
              onClick={onEditar}
              className="flex items-center gap-1.5 flex-1 justify-center py-2.5 rounded-xl border border-white/10 text-body-sm text-blanco-roto/60 hover:text-dorado hover:border-dorado/30 transition-all"
            >
              <Pencil size={14} /> Editar
            </button>
            <button
              onClick={onCancelar}
              className="flex items-center gap-1.5 flex-1 justify-center py-2.5 rounded-xl border border-red-800/20 text-body-sm text-red-400/60 hover:text-red-400 hover:border-red-700/40 hover:bg-red-900/10 transition-all"
            >
              <Trash2 size={14} /> Cancelar reserva
            </button>
          </div>
        )}
      </div>
    </Modal>
  )
}

// ── Formulario Nueva Reserva ──────────────────────────────────────
function ModalNuevaReserva({ onClose }: { onClose: () => void }) {
  const qc = useQueryClient()

  // Datos del huésped
  const [busquedaH, setBusquedaH] = useState('')
  const [huespedSel, setHuespedSel] = useState<Huesped | null>(null)
  const [mostrarResultados, setMostrarResultados] = useState(false)
  const [nuevoHuesped, setNuevoHuesped] = useState(false)
  const [nh, setNh] = useState({ nombre: '', cedula: '', celular: '', correo: '' })

  // Datos de la reserva
  const [fechaE, setFechaE] = useState('')
  const [fechaS, setFechaS] = useState('')
  const [habId, setHabId]   = useState('')
  const [opId, setOpId]     = useState('')
  const [acomp, setAcomp]   = useState('')
  const [ccAcomp, setCcAcomp] = useState('')
  const [pago, setPago]     = useState('')
  const [metodo, setMetodo] = useState('Transferencia')
  const [obs, setObs]       = useState('')

  const [error, setError]   = useState('')
  const [guardando, setGuardando] = useState(false)

  const { data: huespedes_resultados = [] } = useQuery({
    queryKey: ['buscar-h', busquedaH],
    queryFn: () => buscarHuespedes(busquedaH),
    enabled: busquedaH.length >= 2,
    staleTime: 10_000,
  })

  const { data: operadores = [] } = useQuery({
    queryKey: ['operadores'],
    queryFn: fetchOperadores,
    staleTime: 300_000,
  })

  const { data: habitacionesDisp = [] } = useQuery({
    queryKey: ['hab-disp', fechaE, fechaS],
    queryFn: () => fetchHabitacionesDisponibles(fechaE, fechaS),
    enabled: !!(fechaE && fechaS && fechaE < fechaS),
    staleTime: 30_000,
  })

  const noches = useMemo(() => {
    if (!fechaE || !fechaS) return 0
    const diff = (new Date(fechaS).getTime() - new Date(fechaE).getTime()) / 86400000
    return diff > 0 ? diff : 0
  }, [fechaE, fechaS])

  async function handleGuardar() {
    setError('')
    if (!huespedSel && !nuevoHuesped) { setError('Selecciona o crea un huésped'); return }
    if (nuevoHuesped && (!nh.nombre || !nh.cedula)) { setError('Nombre y cédula son obligatorios'); return }
    if (!fechaE || !fechaS || fechaE >= fechaS) { setError('Las fechas no son válidas'); return }
    if (!habId) { setError('Selecciona una habitación disponible'); return }

    setGuardando(true)
    try {
      // Crear huésped si es nuevo
      let hId = huespedSel?.id
      if (nuevoHuesped) {
        const { data, error: e } = await supabase
          .from('huespedes')
          .insert({ nombre: nh.nombre, cedula: nh.cedula, celular: nh.celular || null, correo: nh.correo || null })
          .select('id')
          .single()
        if (e) throw new Error(e.message)
        hId = data.id
      }

      // Crear la reserva
      const { error: re } = await supabase.from('reservas').insert({
        habitacion_id: habId,
        huesped_id: hId,
        fecha_entrada: fechaE,
        fecha_salida: fechaS,
        pago_total: Number(pago) || 0,
        operador_id: opId || null,
        acompanante: acomp || null,
        cc_acompanante: ccAcomp || null,
        metodo_pago: metodo || null,
        observaciones: obs || null,
        estado: 'confirmada',
      })
      if (re) throw new Error(re.message)

      qc.invalidateQueries({ queryKey: ['reservas-completas'] })
      onClose()
    } catch (e: any) {
      setError(e.message ?? 'Error al guardar')
    } finally {
      setGuardando(false)
    }
  }

  const inputCls = "w-full bg-negro-absoluto border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:outline-none focus:border-dorado/50 transition-colors"
  const labelCls = "block text-body-xs text-blanco-roto/40 uppercase tracking-wider mb-1"

  return (
    <Modal isOpen onClose={onClose} title="Nueva reserva" size="md">
      <div className="space-y-5">

        {/* Búsqueda de huésped */}
        <div>
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider mb-3">Titular</p>

          {!huespedSel && !nuevoHuesped && (
            <div className="relative">
              <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-blanco-roto/30" />
              <input
                className={`${inputCls} pl-9`}
                placeholder="Buscar por nombre o cédula..."
                value={busquedaH}
                onChange={e => { setBusquedaH(e.target.value); setMostrarResultados(true) }}
                onFocus={() => setMostrarResultados(true)}
              />
              {mostrarResultados && huespedes_resultados.length > 0 && (
                <div className="absolute top-full mt-1 left-0 right-0 bg-negro-profundo border border-white/10 rounded-xl overflow-hidden z-10 shadow-dorado-sm">
                  {huespedes_resultados.map(h => (
                    <button
                      key={h.id}
                      onClick={() => { setHuespedSel(h); setMostrarResultados(false); setBusquedaH('') }}
                      className="w-full text-left px-4 py-3 hover:bg-white/5 transition-colors border-b border-white/5 last:border-0"
                    >
                      <p className="text-body-sm text-blanco-roto">{h.nombre}</p>
                      {esCedulaReal(h.cedula) && <p className="text-body-xs text-blanco-roto/40">CC: {h.cedula}</p>}
                    </button>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Huésped seleccionado — mostrar todos sus datos */}
          {huespedSel && (
            <div className="glass rounded-xl p-4 space-y-2">
              <div className="flex items-start justify-between gap-2">
                <p className="text-body-sm font-bold text-blanco-roto">{huespedSel.nombre}</p>
                <button onClick={() => setHuespedSel(null)} className="text-blanco-roto/30 hover:text-blanco-roto shrink-0">
                  <X size={14} />
                </button>
              </div>
              <div className="grid grid-cols-2 gap-x-4 gap-y-1">
                <p className="text-body-xs text-blanco-roto/40">Cédula</p>
                <p className="text-body-xs text-blanco-roto/80 font-mono">{mostrarCedula(huespedSel.cedula)}</p>
                {huespedSel.celular && <>
                  <p className="text-body-xs text-blanco-roto/40">Celular</p>
                  <p className="text-body-xs text-blanco-roto/80 font-mono">{huespedSel.celular}</p>
                </>}
                {huespedSel.correo && <>
                  <p className="text-body-xs text-blanco-roto/40">Correo</p>
                  <p className="text-body-xs text-blanco-roto/80 truncate">{huespedSel.correo}</p>
                </>}
              </div>
            </div>
          )}

          {/* Toggle crear nuevo */}
          {!huespedSel && (
            <button
              onClick={() => setNuevoHuesped(v => !v)}
              className="mt-2 text-body-xs text-dorado hover:text-dorado/80 transition-colors"
            >
              {nuevoHuesped ? '← Buscar existente' : '+ Crear nuevo huésped'}
            </button>
          )}

          {/* Form nuevo huésped */}
          {nuevoHuesped && !huespedSel && (
            <div className="mt-3 space-y-3 glass rounded-xl p-4">
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className={labelCls}>Nombre *</label>
                  <input className={inputCls} value={nh.nombre} onChange={e => setNh(p => ({...p, nombre: e.target.value}))} placeholder="Nombre completo" />
                </div>
                <div>
                  <label className={labelCls}>Cédula *</label>
                  <input className={inputCls} value={nh.cedula} onChange={e => setNh(p => ({...p, cedula: e.target.value}))} placeholder="Número de documento" />
                </div>
                <div>
                  <label className={labelCls}>Celular</label>
                  <input className={inputCls} value={nh.celular} onChange={e => setNh(p => ({...p, celular: e.target.value}))} placeholder="3XXXXXXXXX" />
                </div>
                <div>
                  <label className={labelCls}>Correo</label>
                  <input className={inputCls} type="email" value={nh.correo} onChange={e => setNh(p => ({...p, correo: e.target.value}))} placeholder="correo@..." />
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Fechas */}
        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className={labelCls}>Check-in *</label>
            <input type="date" className={`${inputCls} [color-scheme:dark]`} value={fechaE}
              onChange={e => setFechaE(e.target.value)} />
          </div>
          <div>
            <label className={labelCls}>Check-out *</label>
            <input type="date" className={`${inputCls} [color-scheme:dark]`} value={fechaS}
              onChange={e => setFechaS(e.target.value)} />
          </div>
        </div>

        {noches > 0 && (
          <p className="text-body-xs text-blanco-roto/40 -mt-2">
            {noches} {noches === 1 ? 'noche' : 'noches'}
          </p>
        )}

        {/* Habitación */}
        <div>
          <label className={labelCls}>Habitación disponible *</label>
          {!fechaE || !fechaS || fechaE >= fechaS ? (
            <p className="text-body-xs text-blanco-roto/30 py-2">Selecciona las fechas primero</p>
          ) : habitacionesDisp.length === 0 ? (
            <p className="text-body-xs text-red-400 py-2">Sin habitaciones disponibles para esas fechas</p>
          ) : (
            <div className="grid grid-cols-4 gap-2">
              {habitacionesDisp.map(h => (
                <button
                  key={h.id}
                  onClick={() => setHabId(h.id)}
                  className={`py-2 rounded-xl border text-body-sm font-mono font-bold transition-all ${
                    habId === h.id
                      ? 'bg-dorado/20 border-dorado text-dorado'
                      : 'border-white/10 text-blanco-roto/60 hover:border-white/20'
                  }`}
                >
                  {h.numero}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Canal y pago */}
        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className={labelCls}>Canal</label>
            <select className={inputCls} value={opId} onChange={e => setOpId(e.target.value)}>
              <option value="">Sin canal</option>
              {operadores.map(o => <option key={o.id} value={o.id}>{o.nombre}</option>)}
            </select>
          </div>
          <div>
            <label className={labelCls}>Método de pago</label>
            <select className={inputCls} value={metodo} onChange={e => setMetodo(e.target.value)}>
              {['Transferencia','Efectivo','Tarjeta','Nequi','Daviplata'].map(m => (
                <option key={m}>{m}</option>
              ))}
            </select>
          </div>
        </div>

        <div>
          <label className={labelCls}>Pago total (COP)</label>
          <input className={inputCls} type="number" value={pago} onChange={e => setPago(e.target.value)}
            placeholder="Ej: 250000" />
        </div>

        {/* Acompañante */}
        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className={labelCls}>Acompañante</label>
            <input className={inputCls} value={acomp} onChange={e => setAcomp(e.target.value)} placeholder="Nombre" />
          </div>
          <div>
            <label className={labelCls}>CC acompañante</label>
            <input className={inputCls} value={ccAcomp} onChange={e => setCcAcomp(e.target.value)} placeholder="Cédula" />
          </div>
        </div>

        <div>
          <label className={labelCls}>Observaciones</label>
          <textarea className={`${inputCls} resize-none`} rows={2} value={obs}
            onChange={e => setObs(e.target.value)} placeholder="Notas internas..." />
        </div>

        {error && <p className="text-body-sm text-red-400">{error}</p>}

        <div className="flex gap-3 pt-1">
          <button
            onClick={handleGuardar}
            disabled={guardando}
            className="flex-1 py-3 bg-dorado text-negro-absoluto font-semibold text-body-sm rounded-xl hover:shadow-glow disabled:opacity-50 transition-all"
          >
            {guardando ? 'Guardando...' : 'Confirmar reserva'}
          </button>
          <button onClick={onClose} className="px-4 text-body-sm text-blanco-roto/40 hover:text-blanco-roto transition-colors">
            Cancelar
          </button>
        </div>
      </div>
    </Modal>
  )
}

// ── Página principal ──────────────────────────────────────────────
export default function Reservas() {
  const navigate = useNavigate()
  const [busqueda,    setBusqueda]    = useState('')
  const [estado,      setEstado]      = useState('')
  const [fechaDesde,  setFechaDesde]  = useState('')
  const [fechaHasta,  setFechaHasta]  = useState('')
  const [pagina,      setPagina]      = useState(1)
  const [modalVer,      setModalVer]      = useState<ReservaFila | null>(null)
  const [modalEditar,   setModalEditar]   = useState<ReservaFila | null>(null)
  const [modalCancelar, setModalCancelar] = useState<ReservaFila | null>(null)
  const [modalFacturar, setModalFacturar] = useState<ReservaFila | null>(null)
  const [modalNueva,    setModalNueva]    = useState(false)

  const { data: todas = [], isLoading } = useQuery({
    queryKey: ['reservas-completas'],
    queryFn: fetchReservas,
    staleTime: 30_000,
  })

  const filtradas = useMemo(() => todas.filter(r => {
    if (estado     && r.estado !== estado)             return false
    if (fechaDesde && r.fecha_entrada < fechaDesde)    return false
    if (fechaHasta && r.fecha_salida  > fechaHasta)    return false
    if (busqueda.trim()) {
      const b = busqueda.toLowerCase()
      return r.huesped_nombre.toLowerCase().includes(b) ||
             String(r.habitacion_numero).includes(b) ||
             !!(r.operador_nombre?.toLowerCase().includes(b))
    }
    return true
  }), [todas, estado, fechaDesde, fechaHasta, busqueda])

  const totalPags = Math.ceil(filtradas.length / PAGE_SIZE)
  const pag       = Math.min(pagina, totalPags || 1)
  const inicio    = (pag - 1) * PAGE_SIZE
  const items     = filtradas.slice(inicio, inicio + PAGE_SIZE)

  const cambiar = useCallback((fn: () => void) => { fn(); setPagina(1) }, [])

  const totalBruto = filtradas.reduce((s, r) => s + r.pago_total, 0)
  const totalCom   = filtradas.reduce((s, r) => s + (r.comision ?? 0), 0)

  return (
    <div className="p-4 lg:p-6 space-y-5">

      {/* Header con botón Nueva Reserva */}
      <div className="flex items-center justify-between gap-4">
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 flex-1">
          <div className="glass rounded-xl p-3">
            <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Reservas</p>
            <p className="font-mono text-mono-lg font-bold text-dorado">{filtradas.length}</p>
          </div>
          <div className="glass rounded-xl p-3">
            <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Bruto</p>
            <p className="font-mono text-mono-lg font-bold text-blanco-roto">{fMontoCorto(totalBruto)}</p>
          </div>
          <div className="glass rounded-xl p-3 hidden sm:block">
            <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Neto</p>
            <p className="font-mono text-mono-lg font-bold text-green-400">{fMontoCorto(totalBruto - totalCom)}</p>
          </div>
        </div>

        {/* Botón principal — muy visible */}
        <button
          onClick={() => setModalNueva(true)}
          className="flex items-center gap-2 px-5 py-3 bg-dorado text-negro-absoluto font-bold text-body-sm rounded-xl hover:shadow-glow active:scale-95 transition-all shrink-0"
        >
          <Plus size={18} strokeWidth={2.5} />
          <span className="hidden sm:inline">Nueva reserva</span>
          <span className="sm:hidden">Nueva</span>
        </button>
      </div>

      {/* Filtros */}
      <div className="space-y-3">
        <div className="flex gap-3 flex-col sm:flex-row">
          <SearchInput value={busqueda} onChange={v => cambiar(() => setBusqueda(v))}
            placeholder="Huésped, habitación u operador..." className="flex-1" />
          <select value={estado} onChange={e => cambiar(() => setEstado(e.target.value))}
            className="bg-negro-profundo border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50 sm:w-44">
            {ESTADOS_FILTRO.map(e => <option key={e.value} value={e.value}>{e.label}</option>)}
          </select>
        </div>
        <div className="flex gap-3 flex-col sm:flex-row items-end">
          <div className="flex-1 space-y-1">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider px-1">Entrada desde</label>
            <input type="date" value={fechaDesde}
              onChange={e => cambiar(() => setFechaDesde(e.target.value))}
              className="w-full bg-negro-profundo border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50 [color-scheme:dark]" />
          </div>
          <div className="flex-1 space-y-1">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider px-1">Salida hasta</label>
            <input type="date" value={fechaHasta}
              onChange={e => cambiar(() => setFechaHasta(e.target.value))}
              className="w-full bg-negro-profundo border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50 [color-scheme:dark]" />
          </div>
          {(fechaDesde || fechaHasta || busqueda || estado) && (
            <button
              onClick={() => { setBusqueda(''); setEstado(''); setFechaDesde(''); setFechaHasta(''); setPagina(1) }}
              className="px-4 py-2.5 text-body-sm text-blanco-roto/50 hover:text-blanco-roto border border-white/10 rounded-xl transition-colors"
            >Limpiar</button>
          )}
        </div>
      </div>

      {/* Skeleton */}
      {isLoading && <div className="space-y-2">{Array.from({length:6}).map((_,i)=><div key={i} className="h-16 rounded-xl shimmer"/>)}</div>}

      {/* Vacío */}
      {!isLoading && filtradas.length === 0 && (
        <div className="glass rounded-2xl p-12 text-center">
          <CalendarDays size={32} className="mx-auto text-blanco-roto/20 mb-3"/>
          <p className="text-body-md text-blanco-roto/50">No hay reservas con estos filtros</p>
        </div>
      )}

      {/* Tabla desktop */}
      {!isLoading && items.length > 0 && (
        <>
          <div className="hidden lg:block glass rounded-2xl overflow-hidden">
            <table className="w-full">
              <thead>
                <tr className="border-b border-white/5">
                  {['Hab.','Huésped','Entrada','Salida','N','Total','Canal','Estado',''].map(h => (
                    <th key={h} className="text-left text-body-xs text-blanco-roto/40 uppercase tracking-wider px-4 py-3">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {items.map(r => (
                  <tr key={r.id} className="hover:bg-white/5 transition-colors group">
                    <td className="px-4 py-3">
                      <span className="font-mono text-mono-sm font-bold text-blanco-roto">{r.habitacion_numero}</span>
                    </td>
                    <td className="px-4 py-3">
                      <p className="text-body-sm text-blanco-roto hover:text-dorado cursor-pointer transition-colors"
                        onClick={() => navigate(`/admin/huespedes/${r.huesped_id}`)}>
                        {r.huesped_nombre}
                      </p>
                      {r.acompanante && <p className="text-body-xs text-blanco-roto/40">+{r.acompanante}</p>}
                    </td>
                    <td className="px-4 py-3 font-mono text-mono-sm text-blanco-roto/70">{fFecha(r.fecha_entrada)}</td>
                    <td className="px-4 py-3 font-mono text-mono-sm text-blanco-roto/70">{fFecha(r.fecha_salida)}</td>
                    <td className="px-4 py-3 font-mono text-mono-sm text-blanco-roto/60 text-center">{r.noches}</td>
                    <td className="px-4 py-3">
                      <p className="font-mono text-mono-sm text-blanco-roto">{fMontoCorto(r.pago_total)}</p>
                      {r.comision ? <p className="text-body-xs text-red-400/60">-{fMontoCorto(r.comision)}</p> : null}
                    </td>
                    <td className="px-4 py-3 text-body-sm text-blanco-roto/60">{r.operador_nombre ?? '—'}</td>
                    <td className="px-4 py-3"><Badge variant={r.estado}>{LABEL_ESTADO[r.estado]}</Badge></td>
                    <td className="px-3 py-3">
                      <button onClick={() => setModalVer(r)}
                        className="flex items-center gap-1 px-2.5 py-1 rounded-lg border border-white/10 text-body-xs text-blanco-roto/50 hover:text-dorado hover:border-dorado/30 transition-all">
                        <Eye size={12}/> Ver más
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Lista mobile */}
          <div className="lg:hidden space-y-2">
            {items.map(r => (
              <div key={r.id} className="glass rounded-xl p-4 flex items-center gap-3">
                <div className="w-10 text-center shrink-0">
                  <p className="font-mono text-mono-md font-bold text-blanco-roto">{r.habitacion_numero}</p>
                </div>
                <div className="flex-1 min-w-0 cursor-pointer" onClick={() => navigate(`/admin/huespedes/${r.huesped_id}`)}>
                  <p className="text-body-sm font-medium text-blanco-roto truncate">{r.huesped_nombre}</p>
                  <p className="text-body-xs text-blanco-roto/40">{fFecha(r.fecha_entrada)} → {fFecha(r.fecha_salida)}</p>
                </div>
                <div className="shrink-0 flex flex-col items-end gap-1.5">
                  <p className="font-mono text-mono-sm text-blanco-roto">{fMontoCorto(r.pago_total)}</p>
                  <button onClick={() => setModalVer(r)}
                    className="flex items-center gap-1 px-2 py-0.5 rounded-md border border-white/10 text-body-xs text-blanco-roto/50 hover:text-dorado hover:border-dorado/30 transition-all">
                    <Eye size={11}/> Ver más
                  </button>
                </div>
              </div>
            ))}
          </div>

          {/* Paginación */}
          <div className="flex items-center justify-between">
            <p className="text-body-xs text-blanco-roto/30">
              {inicio + 1}–{Math.min(inicio + PAGE_SIZE, filtradas.length)} de {filtradas.length}
            </p>
            <div className="flex items-center gap-1.5">
              <button onClick={() => setPagina(p => Math.max(1,p-1))} disabled={pag<=1}
                className="p-2 rounded-xl border border-white/10 text-blanco-roto/50 hover:text-blanco-roto disabled:opacity-30 disabled:cursor-not-allowed transition-all">
                <ChevronLeft size={15}/>
              </button>
              {Array.from({length: Math.min(totalPags,5)}, (_,i) => {
                const num = totalPags<=5 ? i+1 : pag<=3 ? i+1 : pag>=totalPags-2 ? totalPags-4+i : pag-2+i
                return (
                  <button key={num} onClick={() => setPagina(num)}
                    className={`w-8 h-8 rounded-lg text-body-xs font-mono transition-all ${num===pag ? 'bg-dorado text-negro-absoluto font-bold' : 'border border-white/10 text-blanco-roto/50 hover:text-blanco-roto'}`}>
                    {num}
                  </button>
                )
              })}
              <button onClick={() => setPagina(p => Math.min(totalPags,p+1))} disabled={pag>=totalPags}
                className="p-2 rounded-xl border border-white/10 text-blanco-roto/50 hover:text-blanco-roto disabled:opacity-30 disabled:cursor-not-allowed transition-all">
                <ChevronRight size={15}/>
              </button>
            </div>
          </div>
        </>
      )}

      {/* Modales */}
      {modalVer && (
        <ModalDetalle
          r={modalVer}
          onClose={() => setModalVer(null)}
          onEditar={() => { setModalEditar(modalVer); setModalVer(null) }}
          onCancelar={() => { setModalCancelar(modalVer); setModalVer(null) }}
          onFacturar={() => { setModalFacturar(modalVer); setModalVer(null) }}
        />
      )}
      {modalEditar   && <ModalEditar   r={modalEditar}   onClose={() => setModalEditar(null)} />}
      {modalCancelar && <ModalCancelar r={modalCancelar} onClose={() => setModalCancelar(null)} />}
      {modalFacturar && <ModalFacturarSiigo r={modalFacturar} onClose={() => setModalFacturar(null)} />}
      {modalNueva    && <ModalNuevaReserva onClose={() => setModalNueva(false)} />}
    </div>
  )
}
