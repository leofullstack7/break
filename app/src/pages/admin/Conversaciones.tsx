import { useEffect, useMemo, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { QRCodeSVG } from 'qrcode.react'
import {
  ArrowLeft, Download, ExternalLink, QrCode, Search, UserRound, X,
} from 'lucide-react'
import { getPxsolConversacionesBaseUrl } from '@/lib/pxsol-conversaciones'
import { ChatComposer } from '@/components/chat/ChatComposer'
import { ChatThread } from '@/components/chat/ChatThread'
import {
  enviarMensajeAdmin,
  fetchInboxChats,
  fetchMensajes,
  marcarLeidoAdmin,
  subirAdjuntoChat,
  urlPublicaChat,
  type InboxChat,
} from '@/lib/chat-habitacion'
import { useAuthStore } from '@/store/authStore'
import { supabase } from '@/lib/supabase'
import type { ChatMensaje } from '@/types/database.types'

export default function Conversaciones() {
  const [params, setParams] = useSearchParams()
  const habParam = params.get('hab')
  const [busqueda, setBusqueda] = useState('')
  const [mostrarQrs, setMostrarQrs] = useState(false)
  const [canal, setCanal] = useState<'internos' | 'whatsapp'>('internos')
  const queryClient = useQueryClient()
  const { user } = useAuthStore()

  const { data: inbox = [], isLoading } = useQuery({
    queryKey: ['chat-inbox'],
    queryFn: fetchInboxChats,
  })

  const seleccion = useMemo(
    () => inbox.find(c => c.habitacion_id === habParam) ?? null,
    [inbox, habParam],
  )

  const { data: mensajes = [] } = useQuery({
    queryKey: ['chat-mensajes', seleccion?.id],
    queryFn: () => fetchMensajes(seleccion!.id),
    enabled: !!seleccion && !seleccion.id.startsWith('pending-'),
    refetchInterval: 4000,
  })

  useEffect(() => {
    if (!seleccion || seleccion.id.startsWith('pending-')) return
    void marcarLeidoAdmin(seleccion.id).then(() => {
      void queryClient.invalidateQueries({ queryKey: ['chat-inbox'] })
    })
  }, [seleccion?.id, queryClient])

  useEffect(() => {
    if (!seleccion || seleccion.id.startsWith('pending-')) return
    const canal = supabase
      .channel(`admin-thread-${seleccion.id}`)
      .on(
        'postgres_changes',
        { event: 'INSERT', schema: 'public', table: 'chat_mensajes', filter: `chat_id=eq.${seleccion.id}` },
        () => {
          void queryClient.invalidateQueries({ queryKey: ['chat-mensajes', seleccion.id] })
        },
      )
      .subscribe()
    return () => {
      void supabase.removeChannel(canal)
    }
  }, [seleccion?.id, queryClient])

  const filtrados = inbox.filter(c => {
    const q = busqueda.trim().toLowerCase()
    if (!q) return true
    return String(c.numero).includes(q)
      || (c.huesped_nombre ?? '').toLowerCase().includes(q)
      || (c.ultimo_mensaje ?? '').toLowerCase().includes(q)
  })

  const enviar = useMutation({
    mutationFn: async (payload: {
      tipo: 'texto' | 'imagen' | 'audio'
      contenido: string
      archivo?: Blob
      nombreArchivo?: string
    }) => {
      if (!seleccion || !user || seleccion.id.startsWith('pending-')) {
        throw new Error('Chat no listo')
      }
      let mediaPath: string | undefined
      if (payload.archivo && payload.tipo !== 'texto') {
        const up = await subirAdjuntoChat({
          archivo: payload.archivo,
          nombre: payload.nombreArchivo ?? 'adjunto',
          tipo: payload.tipo,
        })
        mediaPath = up.path
      }
      return enviarMensajeAdmin({
        chatId: seleccion.id,
        autorId: user.id,
        tipo: payload.tipo,
        contenido: payload.contenido,
        mediaPath,
      })
    },
    onSuccess: (msg: ChatMensaje) => {
      queryClient.setQueryData<ChatMensaje[]>(['chat-mensajes', seleccion?.id], old => [...(old ?? []), msg])
      void queryClient.invalidateQueries({ queryKey: ['chat-inbox'] })
    },
  })

  function abrirHab(c: InboxChat) {
    setParams({ hab: c.habitacion_id! })
  }

  const huespedId = seleccion?.huesped_id_mapa || seleccion?.huesped_id

  return (
    <div className="h-full min-h-0 flex flex-col pb-16 lg:pb-0">
      <div className="shrink-0 px-4 lg:px-6 py-3 border-b border-white/[0.06] space-y-3">
        <div className="flex items-center justify-between gap-3">
          <div>
            <p className="text-body-xs uppercase tracking-[0.2em] text-dorado/70">Recepción</p>
            <h2 className="font-display font-semibold text-blanco-roto">Conversaciones</h2>
          </div>
          {canal === 'internos' && (
            <button
              type="button"
              onClick={() => setMostrarQrs(true)}
              className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-dorado text-negro-absoluto text-body-sm font-semibold"
            >
              <QrCode size={16} />
              QRs
            </button>
          )}
        </div>
        <div className="grid grid-cols-2 p-1 rounded-2xl bg-white/[0.04] border border-white/[0.06]">
          <button
            type="button"
            onClick={() => setCanal('internos')}
            className={`py-2 rounded-xl text-body-sm font-semibold transition-all ${
              canal === 'internos' ? 'bg-dorado text-negro-absoluto' : 'text-blanco-roto/50'
            }`}
          >
            Chats internos
          </button>
          <button
            type="button"
            onClick={() => setCanal('whatsapp')}
            className={`py-2 rounded-xl text-body-sm font-semibold transition-all ${
              canal === 'whatsapp' ? 'bg-dorado text-negro-absoluto' : 'text-blanco-roto/50'
            }`}
          >
            WhatsApp PxSol
          </button>
        </div>
      </div>

      {canal === 'whatsapp' && (
        <div className="flex-1 min-h-0 flex flex-col">
          <div className="px-4 py-3 flex items-center justify-between gap-3 border-b border-white/[0.06]">
            <p className="text-body-sm text-blanco-roto/50">
              WhatsApp y el bot viven en PxSol Conversaciones.
            </p>
            <a
              href={getPxsolConversacionesBaseUrl()}
              target="_blank"
              rel="noreferrer"
              className="inline-flex items-center gap-1.5 px-3 py-2 rounded-xl border border-white/10 text-body-xs text-dorado hover:border-dorado/40"
            >
              Abrir en pestaña
              <ExternalLink size={13} />
            </a>
          </div>
          <iframe
            title="WhatsApp PxSol"
            src={getPxsolConversacionesBaseUrl()}
            className="flex-1 w-full min-h-0 border-0 bg-negro-absoluto"
          />
        </div>
      )}

      {canal === 'internos' && (
      <div className="flex-1 min-h-0 grid grid-cols-1 lg:grid-cols-[340px_1fr]">
        <aside className={`border-r border-white/[0.06] flex flex-col min-h-0 ${seleccion ? 'hidden lg:flex' : 'flex'}`}>
          <div className="p-3">
            <div className="relative">
              <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-blanco-roto/30" />
              <input
                value={busqueda}
                onChange={e => setBusqueda(e.target.value)}
                placeholder="Habitación o huésped..."
                className="w-full bg-negro-profundo border border-white/10 rounded-xl pl-9 pr-3 py-2 text-body-sm text-blanco-roto placeholder:text-blanco-roto/30 focus:outline-none focus:border-dorado/40"
              />
            </div>
          </div>
          <div className="flex-1 overflow-y-auto">
            {isLoading && <div className="mx-3 h-24 rounded-xl shimmer" />}
            {filtrados.map(c => {
              const activo = c.habitacion_id === habParam
              return (
                <button
                  key={c.habitacion_id}
                  type="button"
                  onClick={() => abrirHab(c)}
                  className={`w-full text-left px-4 py-3 border-b border-white/[0.04] transition-colors ${
                    activo ? 'bg-dorado/10' : 'hover:bg-white/[0.03]'
                  }`}
                >
                  <div className="flex items-start justify-between gap-2">
                    <p className="font-display font-black text-blanco-roto leading-none" style={{ fontSize: '1.65rem' }}>
                      {c.numero}
                    </p>
                    {c.no_leidos_admin > 0 && (
                      <span className="min-w-5 h-5 px-1 rounded-full bg-dorado text-negro-absoluto text-[0.65rem] font-bold flex items-center justify-center">
                        {c.no_leidos_admin}
                      </span>
                    )}
                  </div>
                  <p className="text-body-sm text-blanco-roto/80 mt-1.5 leading-snug">
                    {c.huesped_nombre || 'Sin huésped ahora'}
                  </p>
                  <p className="text-body-xs text-blanco-roto/30 truncate mt-0.5">
                    {c.ultimo_mensaje || 'Sin mensajes'}
                  </p>
                </button>
              )
            })}
          </div>
        </aside>

        <section className={`min-h-0 flex flex-col ${seleccion ? 'flex' : 'hidden lg:flex'}`}>
          {!seleccion && (
            <div className="flex-1 flex items-center justify-center text-blanco-roto/35 text-body-sm px-6 text-center">
              Elige una habitación para ver el chat.
            </div>
          )}
          {seleccion && (
            <>
              <header className="shrink-0 flex items-center gap-3 px-3 lg:px-5 py-3 border-b border-white/[0.06]">
                <button
                  type="button"
                  className="lg:hidden w-8 h-8 rounded-lg text-blanco-roto/50"
                  onClick={() => setParams({})}
                >
                  <ArrowLeft size={18} />
                </button>
                <div className="min-w-0 flex-1">
                  <p className="font-display font-black text-blanco-roto leading-none" style={{ fontSize: '1.7rem' }}>
                    {seleccion.numero}
                  </p>
                  <p className="text-body-sm text-blanco-roto/70 mt-1">
                    {seleccion.huesped_nombre || 'Sin huésped registrado'}
                  </p>
                </div>
                {huespedId && (
                  <Link
                    to={`/admin/huespedes/${huespedId}`}
                    className="inline-flex items-center gap-1.5 px-3 py-2 rounded-xl border border-white/10 text-body-xs text-blanco-roto/70 hover:text-dorado hover:border-dorado/30"
                  >
                    <UserRound size={14} />
                    Ficha
                  </Link>
                )}
              </header>
              <ChatThread mensajes={mensajes} ladoPropio="admin" />
              <ChatComposer
                enviando={enviar.isPending}
                disabled={seleccion.id.startsWith('pending-')}
                onEnviar={async p => { await enviar.mutateAsync(p) }}
              />
            </>
          )}
        </section>
      </div>
      )}

      {mostrarQrs && (
        <ModalQrs inbox={inbox} onClose={() => setMostrarQrs(false)} />
      )}
    </div>
  )
}

function ModalQrs({ inbox, onClose }: { inbox: InboxChat[]; onClose: () => void }) {
  const ordenados = [...inbox].sort((a, b) => a.numero - b.numero)

  function descargarSvg(numero: number, token: string) {
    const svg = document.getElementById(`qr-hab-${numero}`)
    if (!svg) return
    const blob = new Blob([svg.outerHTML], { type: 'image/svg+xml' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `break-habitacion-${numero}.svg`
    a.click()
    URL.revokeObjectURL(url)
    void token
  }

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
      <button type="button" className="absolute inset-0 bg-negro-absoluto/80" onClick={onClose} />
      <div className="relative z-10 w-full max-w-5xl max-h-[92dvh] overflow-y-auto rounded-t-3xl sm:rounded-3xl bg-negro-profundo border border-white/10 p-4 sm:p-6">
        <div className="flex items-center justify-between mb-4">
          <div>
            <p className="text-body-xs uppercase tracking-[0.2em] text-dorado/70">Imprimir</p>
            <h3 className="font-display font-semibold text-blanco-roto text-lg">QR por habitación</h3>
          </div>
          <button type="button" onClick={onClose} className="w-9 h-9 rounded-xl text-blanco-roto/40 hover:text-blanco-roto">
            <X size={18} />
          </button>
        </div>
        <p className="text-body-sm text-blanco-roto/45 mb-5">
          Coloca el QR en cada estudio. Al escanearlo, el huésped entra al chat con recepción y puede calificar en Google.
        </p>
        <div className="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-3">
          {ordenados.map(c => {
            if (!c.chat_token) return null
            const url = urlPublicaChat(c.chat_token)
            return (
              <article key={c.habitacion_id} className="rounded-2xl bg-white p-3 text-negro-absoluto">
                <div className="flex items-center justify-between mb-2">
                  <p className="font-display font-bold">Hab. {c.numero}</p>
                  <button
                    type="button"
                    onClick={() => descargarSvg(c.numero, c.chat_token!)}
                    className="text-negro-absoluto/45 hover:text-negro-absoluto"
                    aria-label={`Descargar QR ${c.numero}`}
                  >
                    <Download size={14} />
                  </button>
                </div>
                <div className="flex justify-center bg-white">
                  <QRCodeSVG
                    id={`qr-hab-${c.numero}`}
                    value={url}
                    size={148}
                    bgColor="#ffffff"
                    fgColor="#111111"
                    level="M"
                    includeMargin
                  />
                </div>
                <p className="mt-2 text-center text-[0.65rem] font-semibold tracking-[0.18em]">BREAK</p>
                <p className="text-center text-[0.6rem] text-negro-absoluto/50">Chat con recepción</p>
              </article>
            )
          })}
        </div>
      </div>
    </div>
  )
}
