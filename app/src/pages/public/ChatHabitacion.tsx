import { useCallback, useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { Star } from 'lucide-react'
import { ChatComposer } from '@/components/chat/ChatComposer'
import { ChatThread } from '@/components/chat/ChatThread'
import {
  GOOGLE_REVIEW_URL,
  abrirChatPorToken,
  enviarMensajeHuesped,
  marcarLeidoHuesped,
  subirAdjuntoChat,
  type ChatHabitacionPublico,
} from '@/lib/chat-habitacion'
import { mostrarNotificacion, pedirPermisoNotificaciones, sonarAviso } from '@/lib/notificaciones'
import type { ChatMensaje } from '@/types/database.types'

export default function ChatHabitacion() {
  const { token } = useParams<{ token: string }>()
  const [sala, setSala] = useState<ChatHabitacionPublico | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [enviando, setEnviando] = useState(false)

  const refrescar = useCallback(async (silencioso = false) => {
    if (!token) return
    try {
      const data = await abrirChatPorToken(token)
      setSala(prev => {
        const ultimoNuevo = data.mensajes[data.mensajes.length - 1]
        const ultimoViejo = prev?.mensajes[prev.mensajes.length - 1]
        if (
          prev
          && ultimoNuevo
          && ultimoNuevo.id !== ultimoViejo?.id
          && ultimoNuevo.rol !== 'huesped'
        ) {
          sonarAviso()
          mostrarNotificacion({
            titulo: 'Break · Recepción',
            cuerpo: ultimoNuevo.tipo === 'imagen'
              ? 'Te enviaron una foto'
              : ultimoNuevo.tipo === 'audio'
                ? 'Te enviaron un audio'
                : (ultimoNuevo.contenido || 'Nuevo mensaje'),
            tag: `huesped-${data.chat_id}`,
          })
        }
        return data
      })
      setError(null)
      await marcarLeidoHuesped(token)
    } catch {
      if (!silencioso) setError('No encontramos esta habitación. Pide un QR nuevo en recepción.')
    }
  }, [token])

  useEffect(() => {
    void refrescar()
    void pedirPermisoNotificaciones()
    const id = window.setInterval(() => void refrescar(true), 2500)
    return () => window.clearInterval(id)
  }, [refrescar])

  useEffect(() => {
    if (!sala) return
    document.title = `Habitación ${sala.numero} · Break`
  }, [sala])

  async function onEnviar(payload: {
    tipo: 'texto' | 'imagen' | 'audio'
    contenido: string
    archivo?: Blob
    nombreArchivo?: string
  }) {
    if (!token) return
    setEnviando(true)
    try {
      let mediaPath: string | undefined
      if (payload.archivo && payload.tipo !== 'texto') {
        const up = await subirAdjuntoChat({
          archivo: payload.archivo,
          nombre: payload.nombreArchivo ?? 'adjunto',
          tipo: payload.tipo,
          token,
        })
        mediaPath = up.path
      }
      const msg = await enviarMensajeHuesped({
        token,
        tipo: payload.tipo,
        contenido: payload.contenido,
        mediaPath,
      })
      setSala(prev => prev ? { ...prev, mensajes: [...prev.mensajes, msg as ChatMensaje] } : prev)
    } catch (e) {
      // Re-lanzar para que ChatComposer restaure preview / muestre error
      throw e instanceof Error ? e : new Error('No se pudo enviar el mensaje')
    } finally {
      setEnviando(false)
    }
  }

  if (error) {
    return (
      <main className="min-h-dvh bg-negro-absoluto flex items-center justify-center px-6 text-center">
        <div>
          <p className="font-display text-dorado tracking-[0.25em] mb-3">BREAK</p>
          <p className="text-blanco-roto/60">{error}</p>
        </div>
      </main>
    )
  }

  if (!sala) {
    return (
      <main className="min-h-dvh bg-negro-absoluto flex items-center justify-center">
        <div className="w-40 h-20 rounded-2xl shimmer" />
      </main>
    )
  }

  return (
    <main className="h-[100dvh] max-h-[100dvh] bg-negro-absoluto flex flex-col overflow-hidden">
      <header className="shrink-0 border-b border-white/[0.06] bg-negro-profundo/90 backdrop-blur-md px-4 pt-[max(0.75rem,env(safe-area-inset-top))] pb-3">
        <p className="text-[0.62rem] uppercase tracking-[0.28em] text-dorado/70">Break · Recepción</p>
        <div className="flex items-start justify-between gap-3 mt-1">
          <div className="min-w-0">
            <h1 className="font-display font-semibold text-blanco-roto text-lg">
              Habitación {sala.numero}
            </h1>
            <p className="text-body-sm text-blanco-roto/45 truncate">
              {sala.huesped_nombre || 'Huésped'}
            </p>
          </div>
          <a
            href={GOOGLE_REVIEW_URL}
            target="_blank"
            rel="noreferrer"
            className="shrink-0 inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-dorado text-negro-absoluto text-body-xs font-semibold"
          >
            <Star size={13} />
            Calificar
          </a>
        </div>
      </header>

      <ChatThread mensajes={sala.mensajes} ladoPropio="huesped" />
      <ChatComposer enviando={enviando} onEnviar={onEnviar} />
    </main>
  )
}
