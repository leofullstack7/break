import { useEffect, useRef, useState } from 'react'
import { ImagePlus, Mic, Send, Square, X } from 'lucide-react'
import { comprimirImagen } from '@/lib/chat-habitacion'

interface Props {
  disabled?: boolean
  enviando?: boolean
  onEnviar: (payload: {
    tipo: 'texto' | 'imagen' | 'audio'
    contenido: string
    archivo?: Blob
    nombreArchivo?: string
  }) => Promise<void>
}

function mimeAudioPreferido() {
  if (typeof MediaRecorder === 'undefined') return ''
  if (MediaRecorder.isTypeSupported('audio/webm;codecs=opus')) return 'audio/webm;codecs=opus'
  if (MediaRecorder.isTypeSupported('audio/mp4')) return 'audio/mp4'
  if (MediaRecorder.isTypeSupported('audio/webm')) return 'audio/webm'
  return ''
}

export function ChatComposer({ disabled, enviando, onEnviar }: Props) {
  const [texto, setTexto] = useState('')
  const [grabando, setGrabando] = useState(false)
  const [segundos, setSegundos] = useState(0)
  const [preview, setPreview] = useState<{ tipo: 'imagen' | 'audio'; blob: Blob; url: string; nombre: string } | null>(null)
  const mediaRef = useRef<MediaRecorder | null>(null)
  const chunksRef = useRef<Blob[]>([])
  const timerRef = useRef<number | null>(null)
  const fileRef = useRef<HTMLInputElement>(null)
  const taRef = useRef<HTMLTextAreaElement>(null)

  useEffect(() => {
    return () => {
      if (timerRef.current) window.clearInterval(timerRef.current)
      if (preview?.url) URL.revokeObjectURL(preview.url)
    }
  }, [preview?.url])

  async function enviarTexto() {
    const msg = texto.trim()
    if (!msg || enviando) return
    setTexto('')
    await onEnviar({ tipo: 'texto', contenido: msg })
    taRef.current?.focus()
  }

  async function elegirFoto(file: File | undefined) {
    if (!file) return
    const blob = await comprimirImagen(file)
    const url = URL.createObjectURL(blob)
    setPreview({ tipo: 'imagen', blob, url, nombre: file.name || 'foto.jpg' })
  }

  async function iniciarGrabacion() {
    if (grabando || !navigator.mediaDevices?.getUserMedia) return
    const mime = mimeAudioPreferido()
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
    const rec = mime ? new MediaRecorder(stream, { mimeType: mime }) : new MediaRecorder(stream)
    chunksRef.current = []
    rec.ondataavailable = e => {
      if (e.data.size) chunksRef.current.push(e.data)
    }
    rec.onstop = () => {
      stream.getTracks().forEach(t => t.stop())
      const blob = new Blob(chunksRef.current, { type: rec.mimeType || 'audio/webm' })
      const ext = rec.mimeType.includes('mp4') ? 'm4a' : 'webm'
      const url = URL.createObjectURL(blob)
      setPreview({ tipo: 'audio', blob, url, nombre: `nota.${ext}` })
    }
    mediaRef.current = rec
    rec.start()
    setGrabando(true)
    setSegundos(0)
    timerRef.current = window.setInterval(() => setSegundos(s => s + 1), 1000)
  }

  function detenerGrabacion() {
    mediaRef.current?.stop()
    mediaRef.current = null
    setGrabando(false)
    if (timerRef.current) window.clearInterval(timerRef.current)
  }

  function cancelarPreview() {
    if (preview?.url) URL.revokeObjectURL(preview.url)
    setPreview(null)
  }

  async function enviarPreview() {
    if (!preview || enviando) return
    const p = preview
    setPreview(null)
    await onEnviar({
      tipo: p.tipo,
      contenido: '',
      archivo: p.blob,
      nombreArchivo: p.nombre,
    })
    URL.revokeObjectURL(p.url)
  }

  return (
    <div className="border-t border-white/[0.06] bg-negro-profundo/90 backdrop-blur-md px-3 pt-2 pb-[max(0.75rem,env(safe-area-inset-bottom))]">
      {preview && (
        <div className="mb-2 rounded-xl border border-white/10 bg-white/[0.04] p-2 flex items-center gap-2">
          {preview.tipo === 'imagen' ? (
            <img src={preview.url} alt="Vista previa" className="h-14 w-14 rounded-lg object-cover" />
          ) : (
            <audio src={preview.url} controls className="flex-1 min-w-0" />
          )}
          <button type="button" onClick={cancelarPreview} className="w-8 h-8 rounded-lg text-blanco-roto/40 hover:text-red-300">
            <X size={16} />
          </button>
          <button
            type="button"
            onClick={enviarPreview}
            disabled={enviando}
            className="w-9 h-9 rounded-full bg-dorado text-negro-absoluto flex items-center justify-center disabled:opacity-50"
          >
            <Send size={15} />
          </button>
        </div>
      )}

      {grabando && (
        <div className="mb-2 flex items-center justify-between rounded-xl bg-red-500/10 border border-red-500/20 px-3 py-2">
          <span className="text-body-sm text-red-300">Grabando {segundos}s</span>
          <button
            type="button"
            onClick={detenerGrabacion}
            className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-red-500 text-white text-body-xs"
          >
            <Square size={12} />
            Detener
          </button>
        </div>
      )}

      <div className="flex items-end gap-2">
        <input
          ref={fileRef}
          type="file"
          accept="image/*"
          capture="environment"
          className="hidden"
          onChange={e => {
            void elegirFoto(e.target.files?.[0])
            e.target.value = ''
          }}
        />
        <button
          type="button"
          disabled={disabled || enviando}
          onClick={() => fileRef.current?.click()}
          className="w-10 h-10 rounded-xl border border-white/10 text-blanco-roto/50 hover:text-dorado hover:border-dorado/30 flex items-center justify-center disabled:opacity-40"
          aria-label="Enviar foto"
        >
          <ImagePlus size={18} />
        </button>
        <button
          type="button"
          disabled={disabled || enviando || grabando}
          onClick={() => void iniciarGrabacion()}
          className="w-10 h-10 rounded-xl border border-white/10 text-blanco-roto/50 hover:text-dorado hover:border-dorado/30 flex items-center justify-center disabled:opacity-40"
          aria-label="Grabar audio"
        >
          <Mic size={18} />
        </button>
        <textarea
          ref={taRef}
          rows={1}
          value={texto}
          disabled={disabled || enviando}
          placeholder="Escribe un mensaje..."
          onChange={e => setTexto(e.target.value)}
          onKeyDown={e => {
            if (e.key === 'Enter' && !e.shiftKey) {
              e.preventDefault()
              void enviarTexto()
            }
          }}
          className="flex-1 min-h-[2.5rem] max-h-28 resize-none rounded-xl bg-negro-absoluto border border-white/10 px-3 py-2 text-blanco-roto placeholder:text-blanco-roto/30 focus:outline-none focus:border-dorado/40"
        />
        <button
          type="button"
          disabled={disabled || enviando || !texto.trim()}
          onClick={() => void enviarTexto()}
          className="w-10 h-10 rounded-full bg-dorado text-negro-absoluto flex items-center justify-center disabled:opacity-30"
          aria-label="Enviar"
        >
          <Send size={16} />
        </button>
      </div>
    </div>
  )
}
