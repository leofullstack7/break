import { useState, useMemo } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase, supabaseUrl } from '@/lib/supabase'
import { syncContactosPxsol } from '@/lib/pxsol-contactos'
import { Modal } from '@/components/ui/Modal'
import {
  Users, Globe, MessageCircle, Mail, Send, Copy, Check,
  ExternalLink, Loader2, AlertTriangle, CheckCircle2, BarChart3, RefreshCw,
} from 'lucide-react'

// ── Tipos ─────────────────────────────────────────────────────────
interface HuespedContacto {
  id: string
  nombre: string
  celular: string | null
  correo: string | null
  nacionalidad: string
  visitas: number
}

type TabId = 'metricas' | 'mailing' | 'whatsapp'
type FiltroDestinatarios = 'todos' | 'frecuentes' | 'extranjeros' | 'personalizado'

const WA_MENSAJE_DEFAULT = 'Break Hotel Manizales, abre sus puertas a una experiencia de paz y tranquilidad en un espacio privado y de excelente ambiente. Te invitamos a reservar pronto el apartaestudio "Deluxe".'

// ── Queries ───────────────────────────────────────────────────────
async function fetchContactos(): Promise<HuespedContacto[]> {
  const { data } = await supabase
    .from('huespedes')
    .select('id, nombre, celular, correo, nacionalidad, reservas(count)')
    .is('deleted_at', null)
    .order('nombre')
    .limit(500)
  return (data ?? []).map((h: any) => ({
    id: h.id,
    nombre: h.nombre,
    celular: h.celular,
    correo: h.correo,
    nacionalidad: h.nacionalidad,
    visitas: h.reservas?.[0]?.count ?? 0,
  }))
}

async function fetchHistorialEmail() {
  const { data } = await supabase
    .from('email_logs')
    .select('*')
    .eq('tipo', 'campana')
    .order('created_at', { ascending: false })
    .limit(50)
  return data ?? []
}

// ── Enviar campaña email ──────────────────────────────────────────
async function enviarCampana(params: {
  asunto: string
  mensaje: string
  destinatarios: string[]
  nombre_campana: string
  cta_texto?: string
  cta_url?: string
}) {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) throw new Error('Sin sesión')

  const res = await fetch(
    `${supabaseUrl}/functions/v1/send-campaign`,
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${session.access_token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(params),
    }
  )

  const body = await res.json()
  if (!res.ok) throw new Error(body.error ?? 'Error enviando campaña')
  return body as { enviados: number; fallidos: number; errores?: string[] }
}

// ── Enviar WhatsApp masivo ────────────────────────────────────────
async function enviarWhatsAppMasivo(params: {
  destinatarios: { numero: string; nombre: string }[]
  mensaje: string
  nombre_campana?: string
}) {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) throw new Error('Sin sesión')

  const res = await fetch(
    `${supabaseUrl}/functions/v1/send-whatsapp`,
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${session.access_token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(params),
    }
  )

  const body = await res.json()
  if (!res.ok && body.api_configurada === false) {
    throw new Error('WA_NOT_CONFIGURED')
  }
  if (!res.ok) throw new Error(body.error ?? 'Error enviando WhatsApp')
  return body as { enviados: number; fallidos: number; errores?: string[] }
}

// ── Componente principal ──────────────────────────────────────────
export default function Marketing() {
  const queryClient = useQueryClient()
  const [tab, setTab] = useState<TabId>('metricas')
  const [syncing, setSyncing] = useState(false)
  const [syncMsg, setSyncMsg] = useState<string | null>(null)

  const { data: contactos = [] } = useQuery({
    queryKey: ['marketing-contactos'],
    queryFn: fetchContactos,
  })

  const conEmail   = contactos.filter(h => h.correo).length
  const conCelular = contactos.filter(h => h.celular).length
  const extranjeros = contactos.filter(h => h.nacionalidad !== 'colombiana').length
  const frecuentes = contactos.filter(h => h.visitas >= 2)

  const TABS: { id: TabId; label: string; Icon: React.ElementType }[] = [
    { id: 'metricas',  label: 'Métricas',  Icon: BarChart3 },
    { id: 'mailing',   label: 'Mailing',   Icon: Mail },
    { id: 'whatsapp',  label: 'WhatsApp',  Icon: MessageCircle },
  ]

  async function sincronizarContactos() {
    setSyncing(true)
    setSyncMsg(null)
    try {
      const r = await syncContactosPxsol({ force: true })
      if (r.ok) {
        setSyncMsg(
          `PxSol · ${r.creados ?? 0} nuevos · ${r.actualizados ?? 0} actualizados` +
            (r.errores ? ` · ${r.errores} errores` : ''),
        )
        await queryClient.invalidateQueries({ queryKey: ['marketing-contactos'] })
        await queryClient.invalidateQueries({ queryKey: ['huespedes'] })
      } else {
        setSyncMsg(r.error ?? 'No se pudo sincronizar con PxSol')
      }
    } catch (e) {
      setSyncMsg(e instanceof Error ? e.message : 'Error de sync')
    } finally {
      setSyncing(false)
    }
  }

  return (
    <div className="p-4 lg:p-6 space-y-6">

      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <p className="text-body-xs text-blanco-roto/35 uppercase tracking-wider">
            Base de contactos
          </p>
          {syncMsg && (
            <p className="text-body-xs text-blanco-roto/45 mt-1 break-words">{syncMsg}</p>
          )}
        </div>
        <button
          type="button"
          onClick={() => void sincronizarContactos()}
          disabled={syncing}
          className="inline-flex items-center gap-2 px-3 py-2 rounded-xl border border-white/10 text-body-xs text-blanco-roto/70 hover:text-blanco-roto hover:border-dorado/40 disabled:opacity-50 transition-colors shrink-0"
        >
          <RefreshCw size={14} className={syncing ? 'animate-spin text-dorado' : 'text-dorado/80'} />
          {syncing ? 'Sincronizando…' : 'Sincronizar contactos PxSol'}
        </button>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-negro-profundo/60 rounded-xl p-1 border border-white/[0.06]">
        {TABS.map(({ id, label, Icon }) => (
          <button
            key={id}
            onClick={() => setTab(id)}
            className={`flex items-center gap-2 px-4 py-2.5 rounded-lg text-body-sm font-medium transition-all flex-1 justify-center ${
              tab === id
                ? 'bg-dorado/12 text-dorado'
                : 'text-blanco-roto/40 hover:text-blanco-roto hover:bg-white/[0.04]'
            }`}
          >
            <Icon size={15} />
            <span className="hidden sm:inline">{label}</span>
          </button>
        ))}
      </div>

      {/* Métricas (siempre visibles arriba) */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        <MetricCard icon={Users}          color="text-dorado"      valor={contactos.length} label="Contactos totales" />
        <MetricCard icon={Mail}           color="text-blue-400"    valor={conEmail}          label="Con email" />
        <MetricCard icon={MessageCircle}  color="text-green-400"   valor={conCelular}        label="Con WhatsApp" />
        <MetricCard icon={Globe}          color="text-purple-400"  valor={extranjeros}       label="Extranjeros" />
      </div>

      {/* Contenido por tab */}
      {tab === 'metricas' && (
        <TabMetricas frecuentes={frecuentes} />
      )}

      {tab === 'mailing' && (
        <TabMailing contactos={contactos} conEmail={conEmail} />
      )}

      {tab === 'whatsapp' && (
        <TabWhatsApp contactos={contactos} conCelular={conCelular} />
      )}
    </div>
  )
}

// ── Métrica card ──────────────────────────────────────────────────
function MetricCard({ icon: Icon, color, valor, label }: {
  icon: React.ElementType; color: string; valor: number; label: string
}) {
  return (
    <div className="glass rounded-xl p-4">
      <Icon size={16} className={`${color} mb-2`} />
      <p className={`font-mono text-mono-lg font-bold ${color === 'text-dorado' ? 'text-dorado' : 'text-blanco-roto'}`}>{valor}</p>
      <p className="text-body-xs text-blanco-roto/40 mt-1">{label}</p>
    </div>
  )
}

// ── Botón copiar reutilizable ─────────────────────────────────────
function CopyBtn({ texto }: { texto: string }) {
  const [ok, setOk] = useState(false)
  async function copiar() {
    await navigator.clipboard.writeText(texto)
    setOk(true)
    setTimeout(() => setOk(false), 1500)
  }
  return (
    <button onClick={copiar} title="Copiar"
      className="p-1 rounded-md hover:bg-white/10 text-blanco-roto/25 hover:text-blanco-roto transition-all">
      {ok ? <Check size={12} className="text-green-400" /> : <Copy size={12} />}
    </button>
  )
}

// ══════════════════════════════════════════════════════════════════
// TAB: MÉTRICAS (huéspedes frecuentes)
// ══════════════════════════════════════════════════════════════════
function TabMetricas({ frecuentes }: { frecuentes: HuespedContacto[] }) {
  const top = frecuentes.sort((a, b) => b.visitas - a.visitas).slice(0, 20)
  const waMsgEncoded = encodeURIComponent(WA_MENSAJE_DEFAULT)

  return (
    <div className="space-y-3">
      <div className="flex items-center justify-between">
        <h2 className="text-body-sm font-semibold text-blanco-roto/60 uppercase tracking-wider">
          Huéspedes frecuentes (2+ estadías)
        </h2>
        <span className="text-body-xs text-blanco-roto/30">{top.length} contactos</span>
      </div>

      {top.length === 0 ? (
        <div className="glass rounded-xl p-8 text-center">
          <p className="text-body-sm text-blanco-roto/40">No hay suficientes datos todavía</p>
        </div>
      ) : (
        <div className="glass rounded-2xl overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-white/5">
                  {['Nombre', 'Celular', 'Correo', 'Estadías', ''].map(h => (
                    <th key={h} className="text-left text-body-xs text-blanco-roto/40 uppercase tracking-wider px-4 py-3">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {top.map(h => (
                  <tr key={h.id} className="hover:bg-white/5 transition-colors">
                    <td className="px-4 py-3 text-body-sm font-medium text-blanco-roto">{h.nombre}</td>
                    <td className="px-4 py-3">
                      {h.celular ? (
                        <div className="flex items-center gap-1">
                          <span className="text-body-sm text-blanco-roto/60 font-mono">{h.celular}</span>
                          <CopyBtn texto={h.celular} />
                        </div>
                      ) : <span className="text-body-sm text-blanco-roto/30">—</span>}
                    </td>
                    <td className="px-4 py-3">
                      {h.correo ? (
                        <div className="flex items-center gap-1">
                          <span className="text-body-sm text-blue-400 truncate max-w-40">{h.correo}</span>
                          <CopyBtn texto={h.correo} />
                        </div>
                      ) : <span className="text-body-sm text-blanco-roto/30">—</span>}
                    </td>
                    <td className="px-4 py-3">
                      <span className="font-mono text-mono-sm font-bold text-dorado">{h.visitas}x</span>
                    </td>
                    <td className="px-4 py-2">
                      {h.celular && (
                        <a
                          href={`https://wa.me/${h.celular.replace(/\D/g,'')}?text=${waMsgEncoded}`}
                          target="_blank"
                          rel="noreferrer"
                          className="inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg bg-green-900/30 border border-green-700/30 text-green-400 text-body-xs font-medium hover:bg-green-900/50 hover:border-green-600/50 transition-all whitespace-nowrap"
                        >
                          <MessageCircle size={12} />
                          WhatsApp
                        </a>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  )
}

// ══════════════════════════════════════════════════════════════════
// TAB: MAILING (campañas de email con Resend)
// ══════════════════════════════════════════════════════════════════
function TabMailing({ contactos, conEmail }: { contactos: HuespedContacto[]; conEmail: number }) {
  const [filtro, setFiltro]       = useState<FiltroDestinatarios>('todos')
  const [asunto, setAsunto]       = useState('')
  const [mensaje, setMensaje]     = useState('')
  const [ctaTexto, setCtaTexto]   = useState('')
  const [ctaUrl, setCtaUrl]       = useState('')
  const [confirmar, setConfirmar] = useState(false)

  // Selección personalizada
  const [seleccionados, setSeleccionados] = useState<Set<string>>(new Set())
  const [busquedaContacto, setBusquedaContacto] = useState('')
  const [emailsManuales, setEmailsManuales] = useState('')

  const contactosConEmail = useMemo(() => contactos.filter(h => h.correo), [contactos])

  const contactosFiltrados = useMemo(() => {
    if (!busquedaContacto.trim()) return contactosConEmail.slice(0, 50)
    const q = busquedaContacto.toLowerCase()
    return contactosConEmail.filter(h =>
      h.nombre.toLowerCase().includes(q) || h.correo!.toLowerCase().includes(q)
    ).slice(0, 50)
  }, [contactosConEmail, busquedaContacto])

  function toggleContacto(id: string) {
    setSeleccionados(prev => {
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }

  const emailsFinales = useMemo(() => {
    if (filtro === 'personalizado') {
      const deContactos = contactosConEmail
        .filter(h => seleccionados.has(h.id))
        .map(h => h.correo!)
      const deManuales = emailsManuales
        .split(/[\n,;]+/)
        .map(e => e.trim().toLowerCase())
        .filter(e => e && e.includes('@'))
      return [...new Set([...deContactos, ...deManuales])]
    }
    let lista = contactosConEmail
    if (filtro === 'frecuentes') lista = lista.filter(h => h.visitas >= 2)
    if (filtro === 'extranjeros') lista = lista.filter(h => h.nacionalidad !== 'colombiana')
    return lista.map(d => d.correo!).filter(Boolean)
  }, [contactosConEmail, filtro, seleccionados, emailsManuales])

  const { data: historial = [] } = useQuery({
    queryKey: ['email-historial'],
    queryFn: fetchHistorialEmail,
  })

  const { mutate: enviar, isPending, data: resultado, reset } = useMutation({
    mutationFn: () => enviarCampana({
      asunto,
      mensaje,
      destinatarios: emailsFinales,
      nombre_campana: `Campaña ${new Date().toLocaleDateString('es-CO')}`,
      cta_texto: ctaTexto || undefined,
      cta_url: ctaUrl || undefined,
    }),
    onSuccess: () => setConfirmar(false),
    onError: () => setConfirmar(false),
  })

  const puedeEnviar = asunto.trim() && mensaje.trim() && emailsFinales.length > 0

  const campaignGrouped = useMemo(() => {
    const groups: Record<string, { total: number; enviados: number; fallidos: number; fecha: string }> = {}
    historial.forEach((log: any) => {
      const campana = log.metadata?.nombre_campana ?? 'Sin nombre'
      if (!groups[campana]) {
        groups[campana] = { total: 0, enviados: 0, fallidos: 0, fecha: log.created_at }
      }
      groups[campana].total++
      if (log.estado === 'enviado') groups[campana].enviados++
      else groups[campana].fallidos++
    })
    return Object.entries(groups).slice(0, 10)
  }, [historial])

  return (
    <div className="space-y-6">

      {/* Resultado de envío */}
      {resultado && (
        <div className="glass rounded-xl p-4 border border-green-700/30 flex items-start gap-3">
          <CheckCircle2 size={18} className="text-green-400 shrink-0 mt-0.5" />
          <div>
            <p className="text-body-sm font-semibold text-green-300">Campaña enviada</p>
            <p className="text-body-xs text-blanco-roto/50 mt-1">
              {resultado.enviados} enviados · {resultado.fallidos} fallidos de {resultado.enviados + resultado.fallidos} total
            </p>
            <button onClick={() => reset()} className="text-body-xs text-dorado mt-2 hover:underline">Cerrar</button>
          </div>
        </div>
      )}

      {/* Formulario */}
      <div className="glass rounded-2xl p-5 space-y-4">
        <h3 className="text-body-sm font-semibold text-blanco-roto/60 uppercase tracking-wider">Nueva campaña de email</h3>

        {/* Filtro de destinatarios */}
        <div className="space-y-1.5">
          <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Destinatarios</label>
          <select
            value={filtro}
            onChange={e => { setFiltro(e.target.value as FiltroDestinatarios); setSeleccionados(new Set()); setEmailsManuales('') }}
            className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-2.5 text-body-sm text-blanco-roto focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
          >
            <option value="todos">Todos con email ({conEmail})</option>
            <option value="frecuentes">Frecuentes 2+ estadías ({contactos.filter(h => h.correo && h.visitas >= 2).length})</option>
            <option value="extranjeros">Extranjeros con email ({contactos.filter(h => h.correo && h.nacionalidad !== 'colombiana').length})</option>
            <option value="personalizado">Seleccionar manualmente...</option>
          </select>
          <p className="text-body-xs text-dorado/60">{emailsFinales.length} destinatarios seleccionados</p>
        </div>

        {/* Selector personalizado */}
        {filtro === 'personalizado' && (
          <div className="space-y-3 p-4 rounded-xl bg-white/[0.02] border border-white/5">

            {/* Chips de seleccionados */}
            {seleccionados.size > 0 && (
              <div className="flex flex-wrap gap-1.5">
                {contactosConEmail.filter(h => seleccionados.has(h.id)).map(h => (
                  <button
                    key={h.id}
                    onClick={() => toggleContacto(h.id)}
                    className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-dorado/10 border border-dorado/25 text-body-xs text-dorado hover:bg-red-900/20 hover:border-red-700/30 hover:text-red-300 transition-all group"
                  >
                    {h.nombre.split(' ')[0]}
                    <span className="text-dorado/40 group-hover:text-red-400">✕</span>
                  </button>
                ))}
              </div>
            )}

            {/* Buscar contacto */}
            <div className="space-y-1.5">
              <label className="text-body-xs text-blanco-roto/30">Buscar huésped por nombre o correo</label>
              <input
                type="text"
                value={busquedaContacto}
                onChange={e => setBusquedaContacto(e.target.value)}
                placeholder="Escribir nombre o correo..."
                className="w-full bg-negro-profundo border border-gris-carbon rounded-lg px-3 py-2 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 transition-all"
              />
            </div>

            {/* Lista de contactos seleccionables */}
            <div className="max-h-48 overflow-y-auto rounded-lg border border-white/5 divide-y divide-white/5">
              {contactosFiltrados.map(h => (
                <label
                  key={h.id}
                  className={`flex items-center gap-3 px-3 py-2 cursor-pointer transition-colors ${
                    seleccionados.has(h.id) ? 'bg-dorado/5' : 'hover:bg-white/[0.03]'
                  }`}
                >
                  <input
                    type="checkbox"
                    checked={seleccionados.has(h.id)}
                    onChange={() => toggleContacto(h.id)}
                    className="rounded border-gris-carbon text-dorado focus:ring-dorado/30 bg-negro-profundo"
                  />
                  <div className="min-w-0 flex-1">
                    <p className="text-body-sm text-blanco-roto truncate">{h.nombre}</p>
                    <p className="text-body-xs text-blanco-roto/30 truncate">{h.correo}</p>
                  </div>
                </label>
              ))}
              {contactosFiltrados.length === 0 && (
                <p className="px-3 py-4 text-body-xs text-blanco-roto/30 text-center">Sin resultados</p>
              )}
            </div>

            {/* Pegar emails manuales */}
            <div className="space-y-1.5">
              <label className="text-body-xs text-blanco-roto/30">O pegar correos directamente (uno por línea o separados por coma)</label>
              <textarea
                value={emailsManuales}
                onChange={e => setEmailsManuales(e.target.value)}
                rows={3}
                placeholder={"juan@email.com\nmaria@email.com, pedro@hotel.co"}
                className="w-full bg-negro-profundo border border-gris-carbon rounded-lg px-3 py-2 text-body-xs text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 transition-all resize-none font-mono"
              />
            </div>
          </div>
        )}

        {/* Asunto */}
        <div className="space-y-1.5">
          <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Asunto del email</label>
          <input
            type="text"
            value={asunto}
            onChange={e => setAsunto(e.target.value)}
            placeholder="Ej: Tu próxima pausa te espera en Break"
            className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-2.5 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
          />
        </div>

        {/* Mensaje */}
        <div className="space-y-1.5">
          <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Mensaje</label>
          <textarea
            value={mensaje}
            onChange={e => setMensaje(e.target.value)}
            rows={6}
            placeholder={"Escribe el contenido del email.\nCada línea será un párrafo.\n\nEl diseño de Break (logo, colores, footer) se aplica automáticamente."}
            className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-3 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all resize-none"
          />
        </div>

        {/* CTA opcional */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div className="space-y-1.5">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Botón CTA (opcional)</label>
            <input
              type="text"
              value={ctaTexto}
              onChange={e => setCtaTexto(e.target.value)}
              placeholder="Ej: Reservar ahora"
              className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-2.5 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
            />
          </div>
          <div className="space-y-1.5">
            <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">URL del botón</label>
            <input
              type="url"
              value={ctaUrl}
              onChange={e => setCtaUrl(e.target.value)}
              placeholder="https://breakmanizales.com/reservar"
              className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-2.5 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
            />
          </div>
        </div>

        {/* Advertencia límites */}
        {emailsFinales.length > 80 && (
          <div className="flex items-start gap-2 px-3 py-2 rounded-lg bg-amber-900/20 border border-amber-700/30">
            <AlertTriangle size={14} className="text-amber-400 shrink-0 mt-0.5" />
            <p className="text-body-xs text-amber-300">
              Resend tiene límite de 100 emails/día en plan gratuito. Tienes {emailsFinales.length} seleccionados.
            </p>
          </div>
        )}

        {/* Botón enviar */}
        <button
          onClick={() => setConfirmar(true)}
          disabled={!puedeEnviar || isPending}
          className="w-full flex items-center justify-center gap-2 py-3 bg-dorado text-negro-absoluto font-semibold rounded-xl hover:shadow-glow disabled:opacity-40 disabled:cursor-not-allowed transition-all"
        >
          <Send size={16} />
          Enviar campaña ({emailsFinales.length} emails)
        </button>
      </div>

      {/* Modal confirmación */}
      <Modal isOpen={confirmar} onClose={() => setConfirmar(false)} title="Confirmar envío" size="sm">
        <div className="space-y-4">
          <p className="text-body-sm text-blanco-roto/70">
            Vas a enviar <strong className="text-dorado">{emailsFinales.length} emails</strong> con el asunto:
          </p>
          <p className="text-body-sm text-blanco-roto font-medium italic">"{asunto}"</p>
          <div className="flex gap-3">
            <button
              onClick={() => setConfirmar(false)}
              className="flex-1 py-2.5 glass rounded-xl text-body-sm text-blanco-roto/60 hover:text-blanco-roto transition-colors"
            >
              Cancelar
            </button>
            <button
              onClick={() => enviar()}
              disabled={isPending}
              className="flex-1 py-2.5 bg-dorado text-negro-absoluto font-semibold rounded-xl hover:shadow-glow disabled:opacity-50 flex items-center justify-center gap-2 transition-all"
            >
              {isPending ? <Loader2 size={15} className="animate-spin" /> : <Send size={15} />}
              {isPending ? 'Enviando...' : 'Confirmar envío'}
            </button>
          </div>
        </div>
      </Modal>

      {/* Historial */}
      {campaignGrouped.length > 0 && (
        <div className="space-y-3">
          <h3 className="text-body-sm font-semibold text-blanco-roto/60 uppercase tracking-wider">Campañas enviadas</h3>
          <div className="space-y-2">
            {campaignGrouped.map(([nombre, stats]) => (
              <div key={nombre} className="glass rounded-xl p-4 flex items-center justify-between">
                <div>
                  <p className="text-body-sm font-medium text-blanco-roto">{nombre}</p>
                  <p className="text-body-xs text-blanco-roto/30 mt-0.5">
                    {new Date(stats.fecha).toLocaleDateString('es-CO', { day: 'numeric', month: 'short', year: 'numeric' })}
                  </p>
                </div>
                <div className="flex items-center gap-3">
                  <span className="text-body-xs text-green-400">{stats.enviados} enviados</span>
                  {stats.fallidos > 0 && <span className="text-body-xs text-red-400">{stats.fallidos} fallidos</span>}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}

// ══════════════════════════════════════════════════════════════════
// TAB: WHATSAPP (difusión masiva)
// ══════════════════════════════════════════════════════════════════
function TabWhatsApp({ contactos, conCelular }: { contactos: HuespedContacto[]; conCelular: number }) {
  const [filtro, setFiltro]     = useState<FiltroDestinatarios>('todos')
  const [mensaje, setMensaje]   = useState('')
  const [copiado, setCopiado]   = useState(false)
  const [busqueda, setBusqueda] = useState('')
  const [enviando, setEnviando] = useState(false)
  const [resultado, setResultado] = useState<{ enviados: number; fallidos: number } | null>(null)
  const [modoApi, setModoApi]   = useState<boolean | null>(null)

  const destinatarios = useMemo(() => {
    let lista = contactos.filter(h => h.celular)
    if (filtro === 'frecuentes') lista = lista.filter(h => h.visitas >= 2)
    if (filtro === 'extranjeros') lista = lista.filter(h => h.nacionalidad !== 'colombiana')
    if (busqueda.trim()) {
      const q = busqueda.toLowerCase()
      lista = lista.filter(h => h.nombre.toLowerCase().includes(q) || h.celular?.includes(q))
    }
    return lista
  }, [contactos, filtro, busqueda])

  const mensajeEncoded = encodeURIComponent(mensaje)

  async function copiarMensaje() {
    await navigator.clipboard.writeText(mensaje)
    setCopiado(true)
    setTimeout(() => setCopiado(false), 2000)
  }

  async function intentarEnvioMasivo() {
    if (!mensaje.trim() || destinatarios.length === 0) return
    setEnviando(true)
    setResultado(null)
    try {
      const res = await enviarWhatsAppMasivo({
        destinatarios: destinatarios.map(d => ({ numero: d.celular!, nombre: d.nombre })),
        mensaje,
        nombre_campana: `WhatsApp ${new Date().toLocaleDateString('es-CO')}`,
      })
      setResultado({ enviados: res.enviados, fallidos: res.fallidos })
      setModoApi(true)
    } catch (err) {
      if ((err as Error).message === 'WA_NOT_CONFIGURED') {
        setModoApi(false)
      } else {
        setResultado({ enviados: 0, fallidos: destinatarios.length })
      }
    } finally {
      setEnviando(false)
    }
  }

  return (
    <div className="space-y-6">

      {/* Resultado de envío API */}
      {resultado && (
        <div className={`glass rounded-xl p-4 border flex items-start gap-3 ${
          resultado.fallidos === 0 ? 'border-green-700/30' : 'border-amber-700/30'
        }`}>
          <CheckCircle2 size={18} className={resultado.fallidos === 0 ? 'text-green-400' : 'text-amber-400'} />
          <div>
            <p className="text-body-sm font-semibold text-blanco-roto">Difusión completada</p>
            <p className="text-body-xs text-blanco-roto/50 mt-1">
              {resultado.enviados} enviados · {resultado.fallidos} fallidos
            </p>
            <button onClick={() => setResultado(null)} className="text-body-xs text-dorado mt-2 hover:underline">Cerrar</button>
          </div>
        </div>
      )}

      {/* Compositor */}
      <div className="glass rounded-2xl p-5 space-y-4">
        <h3 className="text-body-sm font-semibold text-blanco-roto/60 uppercase tracking-wider">Difusión WhatsApp</h3>

        {/* Filtro */}
        <div className="space-y-1.5">
          <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Destinatarios</label>
          <select
            value={filtro}
            onChange={e => setFiltro(e.target.value as FiltroDestinatarios)}
            className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-2.5 text-body-sm text-blanco-roto focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all"
          >
            <option value="todos">Todos con celular ({conCelular})</option>
            <option value="frecuentes">Frecuentes 2+ estadías ({contactos.filter(h => h.celular && h.visitas >= 2).length})</option>
            <option value="extranjeros">Extranjeros con celular ({contactos.filter(h => h.celular && h.nacionalidad !== 'colombiana').length})</option>
          </select>
        </div>

        {/* Mensaje */}
        <div className="space-y-1.5">
          <label className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Mensaje</label>
          <textarea
            value={mensaje}
            onChange={e => setMensaje(e.target.value)}
            rows={5}
            placeholder={"Hola, te escribimos desde Break Hotel Manizales.\n\n¿Cuándo vienes de nuevo? Tenemos tarifas especiales para huéspedes como tú. Reserva directo con nosotros y obtén el mejor precio.\n\n¡Te esperamos!"}
            className="w-full bg-negro-profundo border border-gris-carbon rounded-xl px-4 py-3 text-body-sm text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 focus:ring-1 focus:ring-dorado/20 transition-all resize-none"
          />
          <p className="text-body-xs text-blanco-roto/25">{mensaje.length} caracteres</p>
        </div>

        {/* Acciones */}
        <div className="flex gap-3">
          <button
            onClick={copiarMensaje}
            disabled={!mensaje.trim()}
            className="flex items-center gap-2 px-4 py-2.5 glass rounded-xl text-body-sm text-blanco-roto/60 hover:text-blanco-roto disabled:opacity-30 transition-all"
          >
            {copiado ? <Check size={14} className="text-green-400" /> : <Copy size={14} />}
            {copiado ? 'Copiado' : 'Copiar mensaje'}
          </button>

          {modoApi !== false && (
            <button
              onClick={intentarEnvioMasivo}
              disabled={!mensaje.trim() || destinatarios.length === 0 || enviando}
              className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-green-600 text-white font-semibold rounded-xl hover:bg-green-500 disabled:opacity-40 disabled:cursor-not-allowed transition-all"
            >
              {enviando ? <Loader2 size={15} className="animate-spin" /> : <Send size={15} />}
              {enviando ? 'Enviando...' : `Enviar a ${destinatarios.length} contactos`}
            </button>
          )}
        </div>

        {/* Aviso modo manual */}
        {modoApi === false && (
          <div className="flex items-start gap-2 px-3 py-2.5 rounded-lg bg-amber-900/20 border border-amber-700/30">
            <AlertTriangle size={14} className="text-amber-400 shrink-0 mt-0.5" />
            <div>
              <p className="text-body-xs text-amber-300 font-medium">API de WhatsApp no configurada</p>
              <p className="text-body-xs text-blanco-roto/40 mt-1">
                Usa los botones de cada contacto para enviar manualmente. Cuando se configure la API, el envío será automático.
              </p>
            </div>
          </div>
        )}
      </div>

      {/* Lista de contactos con botón individual */}
      <div className="space-y-3">
        <div className="flex items-center justify-between gap-3">
          <h3 className="text-body-sm font-semibold text-blanco-roto/60 uppercase tracking-wider shrink-0">
            Contactos ({destinatarios.length})
          </h3>
          <input
            type="text"
            value={busqueda}
            onChange={e => setBusqueda(e.target.value)}
            placeholder="Buscar nombre o número..."
            className="flex-1 max-w-64 bg-negro-profundo border border-gris-carbon rounded-lg px-3 py-1.5 text-body-xs text-blanco-roto placeholder:text-blanco-roto/20 focus:border-dorado/60 transition-all"
          />
        </div>

        <div className="glass rounded-2xl overflow-hidden">
          <div className="max-h-[420px] overflow-y-auto divide-y divide-white/5">
            {destinatarios.slice(0, 100).map(h => (
              <div key={h.id} className="flex items-center gap-3 px-4 py-3 hover:bg-white/[0.03] transition-colors">
                <div className="min-w-0 flex-1">
                  <p className="text-body-sm font-medium text-blanco-roto truncate">{h.nombre}</p>
                  <p className="text-body-xs text-blanco-roto/30 font-mono">{h.celular}</p>
                </div>
                {h.visitas >= 2 && (
                  <span className="text-body-xs text-dorado font-mono shrink-0">{h.visitas}x</span>
                )}
                <a
                  href={mensaje.trim()
                    ? `https://wa.me/${h.celular!.replace(/\D/g,'')}?text=${mensajeEncoded}`
                    : `https://wa.me/${h.celular!.replace(/\D/g,'')}`
                  }
                  target="_blank"
                  rel="noreferrer"
                  className="shrink-0 flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-green-900/30 border border-green-700/30 text-green-400 text-body-xs font-medium hover:bg-green-900/50 hover:border-green-600/50 transition-all"
                >
                  <ExternalLink size={12} />
                  Enviar
                </a>
              </div>
            ))}
            {destinatarios.length > 100 && (
              <div className="px-4 py-3 text-center text-body-xs text-blanco-roto/25">
                Mostrando los primeros 100 de {destinatarios.length} contactos
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
