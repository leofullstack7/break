import { useEffect, useRef, useState } from 'react'
import { formatHoraChat, urlMediaChat } from '@/lib/chat-habitacion'
import type { ChatMensaje } from '@/types/database.types'

interface Props {
  mensajes: ChatMensaje[]
  ladoPropio: 'huesped' | 'admin'
}

export function ChatThread({ mensajes, ladoPropio }: Props) {
  const fondo = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const el = fondo.current
    if (!el) return
    el.scrollTop = el.scrollHeight
  }, [mensajes.length, mensajes[mensajes.length - 1]?.id])

  return (
    <div ref={fondo} className="flex-1 min-h-0 overflow-y-auto px-3 py-4 space-y-2">
      {mensajes.length === 0 && (
        <p className="text-center text-body-sm text-blanco-roto/35 px-6 py-10">
          Aún no hay mensajes. Este es el canal directo con recepción.
        </p>
      )}
      {mensajes.map(m => {
        const propio = m.rol === ladoPropio || (ladoPropio === 'admin' && m.rol === 'bot')
        return (
          <article
            key={m.id}
            className={`flex ${propio ? 'justify-end' : 'justify-start'}`}
          >
            <div
              className={`max-w-[85%] rounded-2xl px-3 py-2 ${
                propio
                  ? 'bg-dorado text-negro-absoluto rounded-br-md'
                  : 'bg-white/[0.07] border border-white/10 text-blanco-roto rounded-bl-md'
              }`}
            >
              {m.tipo === 'imagen' && m.media_path && (
                <LightboxImagen src={urlMediaChat(m.media_path)!} propio={propio} />
              )}
              {m.tipo === 'audio' && m.media_path && (
                <audio
                  controls
                  src={urlMediaChat(m.media_path)!}
                  className="w-52 max-w-full mt-0.5"
                  preload="metadata"
                />
              )}
              {m.contenido && (
                <p className="text-body-sm whitespace-pre-wrap break-words leading-relaxed">
                  {m.contenido}
                </p>
              )}
              <p className={`text-[0.62rem] mt-1 ${propio ? 'text-negro-absoluto/50' : 'text-blanco-roto/30'}`}>
                {m.rol === 'bot' ? 'Asistente · ' : ''}
                {formatHoraChat(m.created_at)}
              </p>
            </div>
          </article>
        )
      })}
    </div>
  )
}

function LightboxImagen({ src, propio }: { src: string; propio: boolean }) {
  const [abierto, setAbierto] = useState(false)
  return (
    <>
      <button type="button" onClick={() => setAbierto(true)} className="block mb-1">
        <img
          src={src}
          alt="Foto del chat"
          className={`max-h-52 rounded-xl object-cover ${propio ? '' : 'border border-white/10'}`}
        />
      </button>
      {abierto && (
        <div
          className="fixed inset-0 z-[80] bg-negro-absoluto/90 flex items-center justify-center p-4"
          onClick={() => setAbierto(false)}
        >
          <img src={src} alt="Foto ampliada" className="max-w-full max-h-full rounded-lg object-contain" />
        </div>
      )}
    </>
  )
}
