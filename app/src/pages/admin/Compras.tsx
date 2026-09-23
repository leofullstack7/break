import { useMemo, useRef, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  AlertTriangle, CheckCircle2, FileArchive, Inbox, Loader2,
  RefreshCw, Send, Trash2, Upload,
} from 'lucide-react'
import { formatCOP } from '@/lib/dinero'
import {
  descartarCompra,
  enviarCompraASiigo,
  fetchComprasInbox,
  subirCompraZip,
  type CompraEstado,
  type CompraInbox,
} from '@/lib/compras-siigo'

type Filtro = CompraEstado | 'todas' | 'pendientes'

const FILTROS: { id: Filtro; label: string }[] = [
  { id: 'pendientes', label: 'Pendientes' },
  { id: 'listo', label: 'Listas' },
  { id: 'enviado_siigo', label: 'En Siigo' },
  { id: 'error', label: 'Error' },
  { id: 'todas', label: 'Todas' },
]

function badgeEstado(estado: CompraEstado) {
  switch (estado) {
    case 'pendiente':
      return 'bg-amber-500/15 text-amber-300 border-amber-500/30'
    case 'listo':
      return 'bg-sky-500/15 text-sky-300 border-sky-500/30'
    case 'enviado_siigo':
      return 'bg-emerald-500/15 text-emerald-300 border-emerald-500/30'
    case 'error':
      return 'bg-red-500/15 text-red-300 border-red-500/30'
    case 'descartado':
      return 'bg-white/5 text-blanco-roto/40 border-white/10'
  }
}

function labelEstado(estado: CompraEstado) {
  const map: Record<CompraEstado, string> = {
    pendiente: 'Pendiente',
    listo: 'Lista p/ Siigo',
    enviado_siigo: 'En Siigo',
    error: 'Error',
    descartado: 'Descartada',
  }
  return map[estado]
}

export default function Compras() {
  const qc = useQueryClient()
  const fileRef = useRef<HTMLInputElement>(null)
  const [filtro, setFiltro] = useState<Filtro>('pendientes')
  const [seleccionId, setSeleccionId] = useState<string | null>(null)
  const [msg, setMsg] = useState<string | null>(null)

  const { data: todas = [], isLoading, refetch, isFetching } = useQuery({
    queryKey: ['compras-inbox'],
    queryFn: () => fetchComprasInbox('todas'),
    staleTime: 20_000,
  })

  const lista = useMemo(() => {
    if (filtro === 'todas') return todas
    if (filtro === 'pendientes') {
      return todas.filter(c => c.estado === 'pendiente' || c.estado === 'listo' || c.estado === 'error')
    }
    return todas.filter(c => c.estado === filtro)
  }, [todas, filtro])

  const seleccion = lista.find(c => c.id === seleccionId) ?? lista[0] ?? null

  const upload = useMutation({
    mutationFn: async (file: File) => subirCompraZip(file),
    onSuccess: async (r) => {
      if (!r.ok) {
        setMsg(r.error ?? 'No se pudo subir')
        return
      }
      setMsg(`ZIP cargado · estado: ${r.estado}`)
      await qc.invalidateQueries({ queryKey: ['compras-inbox'] })
      if (r.id) setSeleccionId(r.id)
    },
    onError: (e) => setMsg(e instanceof Error ? e.message : 'Error al subir'),
  })

  const enviar = useMutation({
    mutationFn: async (id: string) => enviarCompraASiigo(id),
    onSuccess: async (r) => {
      if (!r.ok) {
        setMsg(r.error ?? 'No se pudo enviar a Siigo')
      } else {
        setMsg(
          r.already
            ? `Ya estaba en Siigo · ${r.siigo_compra_name ?? r.siigo_compra_id}`
            : `Creada en Siigo · ${r.siigo_compra_name ?? r.siigo_compra_id}`,
        )
      }
      await qc.invalidateQueries({ queryKey: ['compras-inbox'] })
    },
    onError: (e) => setMsg(e instanceof Error ? e.message : 'Error Siigo'),
  })

  const descartar = useMutation({
    mutationFn: async (id: string) => descartarCompra(id),
    onSuccess: async () => {
      setMsg('Compra descartada')
      await qc.invalidateQueries({ queryKey: ['compras-inbox'] })
    },
  })

  const pendientesCount = todas.filter(
    c => c.estado === 'pendiente' || c.estado === 'listo' || c.estado === 'error',
  ).length

  return (
    <div className="h-full min-h-0 flex flex-col p-4 lg:p-6 gap-4">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 shrink-0">
        <div>
          <p className="text-body-xs text-blanco-roto/35 uppercase tracking-wider">
            Compras · Siigo
          </p>
          <h1 className="font-display text-blanco-roto text-lg mt-0.5">
            Facturas pendientes
          </h1>
          {msg && <p className="text-body-xs text-blanco-roto/45 mt-1 break-words">{msg}</p>}
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          <button
            type="button"
            onClick={() => void refetch()}
            className="inline-flex items-center gap-2 px-3 py-2 rounded-xl border border-white/10 text-body-xs text-blanco-roto/70 hover:border-dorado/40"
          >
            <RefreshCw size={14} className={isFetching ? 'animate-spin text-dorado' : 'text-dorado/80'} />
            Actualizar
          </button>
          <input
            ref={fileRef}
            type="file"
            accept=".zip,.xml,application/zip,application/xml,text/xml"
            className="hidden"
            onChange={e => {
              const f = e.target.files?.[0]
              if (f) upload.mutate(f)
              e.target.value = ''
            }}
          />
          <button
            type="button"
            disabled={upload.isPending}
            onClick={() => fileRef.current?.click()}
            className="inline-flex items-center gap-2 px-3 py-2 rounded-xl bg-dorado text-negro-absoluto text-body-xs font-medium disabled:opacity-50"
          >
            {upload.isPending
              ? <Loader2 size={14} className="animate-spin" />
              : <Upload size={14} />}
            Subir ZIP / XML
          </button>
        </div>
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 shrink-0">
        <StatMini icon={Inbox} label="Pendientes" valor={pendientesCount} accent />
        <StatMini
          icon={FileArchive}
          label="Desde correo"
          valor={todas.filter(c => c.origen === 'email').length}
        />
        <StatMini
          icon={CheckCircle2}
          label="En Siigo"
          valor={todas.filter(c => c.estado === 'enviado_siigo').length}
        />
        <StatMini
          icon={AlertTriangle}
          label="Con error"
          valor={todas.filter(c => c.estado === 'error').length}
        />
      </div>

      <div className="flex gap-1 overflow-x-auto shrink-0">
        {FILTROS.map(f => (
          <button
            key={f.id}
            type="button"
            onClick={() => setFiltro(f.id)}
            className={`px-3 py-1.5 rounded-lg text-body-xs whitespace-nowrap transition-colors ${
              filtro === f.id
                ? 'bg-dorado/15 text-dorado'
                : 'text-blanco-roto/40 hover:text-blanco-roto hover:bg-white/[0.04]'
            }`}
          >
            {f.label}
          </button>
        ))}
      </div>

      <div className="flex-1 min-h-0 grid lg:grid-cols-[minmax(0,1fr)_minmax(0,1.1fr)] gap-4">
        {/* Lista */}
        <section className="glass rounded-2xl overflow-hidden flex flex-col min-h-0">
          {isLoading ? (
            <div className="p-4 space-y-2">
              {Array.from({ length: 5 }).map((_, i) => (
                <div key={i} className="h-16 rounded-xl shimmer" />
              ))}
            </div>
          ) : lista.length === 0 ? (
            <div className="flex-1 flex flex-col items-center justify-center p-8 text-center">
              <Inbox size={28} className="text-blanco-roto/20 mb-3" />
              <p className="text-body-sm text-blanco-roto/50">No hay facturas en este filtro</p>
              <p className="text-body-xs text-blanco-roto/30 mt-1 max-w-xs">
                Sube un ZIP DIAN o configura el webhook de correo con asunto «facturación».
              </p>
            </div>
          ) : (
            <ul className="overflow-y-auto divide-y divide-white/5">
              {lista.map(c => (
                <li key={c.id}>
                  <button
                    type="button"
                    onClick={() => setSeleccionId(c.id)}
                    className={`w-full text-left px-4 py-3 hover:bg-white/[0.03] transition-colors ${
                      seleccion?.id === c.id ? 'bg-dorado/8' : ''
                    }`}
                  >
                    <div className="flex items-start justify-between gap-2">
                      <div className="min-w-0">
                        <p className="text-body-sm text-blanco-roto truncate font-medium">
                          {c.proveedor_nombre || c.email_from || c.archivo_nombre || 'Sin proveedor'}
                        </p>
                        <p className="text-body-xs text-blanco-roto/40 truncate mt-0.5">
                          {[c.prefijo, c.numero_factura].filter(Boolean).join('-') || c.email_subject || '—'}
                          {c.total != null ? ` · ${formatCOP(c.total)}` : ''}
                        </p>
                      </div>
                      <span className={`shrink-0 text-[10px] uppercase tracking-wider px-2 py-0.5 rounded-md border ${badgeEstado(c.estado)}`}>
                        {labelEstado(c.estado)}
                      </span>
                    </div>
                  </button>
                </li>
              ))}
            </ul>
          )}
        </section>

        {/* Detalle */}
        <section className="glass rounded-2xl overflow-hidden flex flex-col min-h-0">
          {!seleccion ? (
            <div className="flex-1 flex items-center justify-center p-8 text-blanco-roto/40 text-body-sm">
              Selecciona una factura
            </div>
          ) : (
            <DetalleCompra
              compra={seleccion}
              enviando={enviar.isPending}
              descartando={descartar.isPending}
              onEnviar={() => enviar.mutate(seleccion.id)}
              onDescartar={() => descartar.mutate(seleccion.id)}
            />
          )}
        </section>
      </div>
    </div>
  )
}

function StatMini({
  icon: Icon,
  label,
  valor,
  accent,
}: {
  icon: React.ElementType
  label: string
  valor: number
  accent?: boolean
}) {
  return (
    <div className="glass rounded-xl p-3">
      <Icon size={14} className={accent ? 'text-dorado mb-1.5' : 'text-blanco-roto/35 mb-1.5'} />
      <p className={`font-mono text-mono-md font-bold ${accent ? 'text-dorado' : 'text-blanco-roto'}`}>
        {valor}
      </p>
      <p className="text-body-xs text-blanco-roto/40 mt-0.5">{label}</p>
    </div>
  )
}

function DetalleCompra({
  compra,
  enviando,
  descartando,
  onEnviar,
  onDescartar,
}: {
  compra: CompraInbox
  enviando: boolean
  descartando: boolean
  onEnviar: () => void
  onDescartar: () => void
}) {
  const puedeEnviar =
    compra.estado !== 'enviado_siigo' &&
    compra.estado !== 'descartado' &&
    Boolean(compra.archivo_path)

  return (
    <>
      <div className="px-5 py-4 border-b border-white/5 shrink-0">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <p className="font-display text-blanco-roto text-base truncate">
              {compra.proveedor_nombre || 'Proveedor por identificar'}
            </p>
            <p className="text-body-xs text-blanco-roto/40 mt-1 font-mono">
              NIT {compra.proveedor_nit || '—'}
              {compra.prefijo || compra.numero_factura
                ? ` · ${[compra.prefijo, compra.numero_factura].filter(Boolean).join('-')}`
                : ''}
            </p>
          </div>
          <span className={`text-[10px] uppercase tracking-wider px-2 py-0.5 rounded-md border ${badgeEstado(compra.estado)}`}>
            {labelEstado(compra.estado)}
          </span>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-5 py-4 space-y-4 text-body-sm">
        <dl className="grid grid-cols-2 gap-3">
          <Campo label="Origen" valor={compra.origen === 'email' ? 'Correo' : 'Manual'} />
          <Campo label="Fecha factura" valor={compra.fecha_factura || '—'} />
          <Campo label="Total" valor={compra.total != null ? formatCOP(compra.total) : '—'} />
          <Campo label="IVA" valor={compra.iva != null ? formatCOP(compra.iva) : '—'} />
          <Campo label="Archivo" valor={compra.archivo_nombre || 'Sin archivo'} span />
          {compra.email_subject && (
            <Campo label="Asunto" valor={compra.email_subject} span />
          )}
          {compra.email_from && (
            <Campo label="De" valor={compra.email_from} span />
          )}
          {compra.cufe && (
            <Campo label="CUFE" valor={compra.cufe} span mono />
          )}
          {compra.siigo_compra_name && (
            <Campo label="Siigo" valor={compra.siigo_compra_name} span />
          )}
        </dl>

        {(compra.parse_error || compra.siigo_error) && (
          <div className="rounded-xl border border-red-500/25 bg-red-500/10 px-3 py-2 text-body-xs text-red-200">
            {compra.siigo_error || compra.parse_error}
          </div>
        )}

        {compra.lineas && compra.lineas.length > 0 && (
          <div>
            <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider mb-2">
              Líneas ({compra.lineas.length})
            </p>
            <ul className="space-y-2">
              {compra.lineas.map((l, i) => (
                <li key={i} className="rounded-lg bg-white/[0.03] border border-white/5 px-3 py-2">
                  <p className="text-blanco-roto/80 truncate">{l.descripcion}</p>
                  <p className="text-body-xs text-blanco-roto/40 font-mono mt-0.5">
                    {l.cantidad} × {formatCOP(l.precio)} = {formatCOP(l.total)}
                  </p>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>

      <div className="px-5 py-3 border-t border-white/5 flex gap-2 shrink-0">
        {compra.estado !== 'descartado' && compra.estado !== 'enviado_siigo' && (
          <button
            type="button"
            disabled={descartando}
            onClick={onDescartar}
            className="inline-flex items-center gap-1.5 px-3 py-2 rounded-xl border border-white/10 text-body-xs text-blanco-roto/50 hover:text-red-300 hover:border-red-500/30"
          >
            <Trash2 size={13} />
            Descartar
          </button>
        )}
        <button
          type="button"
          disabled={!puedeEnviar || enviando}
          onClick={onEnviar}
          className="ml-auto inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-dorado text-negro-absoluto text-body-xs font-medium disabled:opacity-40"
        >
          {enviando ? <Loader2 size={14} className="animate-spin" /> : <Send size={14} />}
          {compra.estado === 'enviado_siigo' ? 'Ya en Siigo' : 'Enviar a Siigo'}
        </button>
      </div>
    </>
  )
}

function Campo({
  label,
  valor,
  span,
  mono,
}: {
  label: string
  valor: string
  span?: boolean
  mono?: boolean
}) {
  return (
    <div className={span ? 'col-span-2' : ''}>
      <dt className="text-body-xs text-blanco-roto/35 uppercase tracking-wider">{label}</dt>
      <dd className={`text-blanco-roto/80 mt-0.5 break-all ${mono ? 'font-mono text-body-xs' : ''}`}>
        {valor}
      </dd>
    </div>
  )
}
