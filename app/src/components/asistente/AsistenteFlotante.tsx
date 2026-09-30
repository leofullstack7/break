import { useEffect, useRef, useState } from 'react'
import { useLocation } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import { FileText, Loader2, Send, Vibrate, X } from 'lucide-react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useAuthStore } from '@/store/authStore'
import { esGerencial } from '@/lib/roles'
import {
  enviarZumbido,
  fetchAsistente,
  fetchEquipoGerencial,
  preguntarAsistente,
} from '@/lib/trazabilidad'
import { VisorAdjunto, type AdjuntoVista } from '@/components/objetivos/VisorAdjunto'
import { ChipTiIcon, HormigaIcon } from './HormigaIcon'

export function AsistenteFlotante() {
  const { rol, user } = useAuthStore()
  if (!user || !esGerencial(rol)) return null
  if (rol === 'gerente') return <Panel rama="gerente" />
  if (rol === 'ti') return <Panel rama="ti" />
  return null
}

function Panel({ rama }: { rama: 'gerente' | 'ti' }) {
  const loc = useLocation()
  const listaLarga = loc.pathname.startsWith('/admin/reservas')
    || loc.pathname.startsWith('/admin/huespedes')
  const [abierto, setAbierto] = useState(false)
  const [texto, setTexto] = useState('')
  const [zumbando, setZumbando] = useState<string | null>(null)
  const [pendiente, setPendiente] = useState<string | null>(null)
  const [errorChat, setErrorChat] = useState<string | null>(null)
  const [pdfChip, setPdfChip] = useState<AdjuntoVista | null>(null)
  const [preview, setPreview] = useState<AdjuntoVista | null>(null)
  const fondo = useRef<HTMLDivElement>(null)
  const qc = useQueryClient()
  const esHormiga = rama === 'gerente'

  const { data: historial = [] } = useQuery({
    queryKey: ['asistente', rama],
    queryFn: () => fetchAsistente(rama),
    enabled: abierto,
  })

  const { data: equipo = [] } = useQuery({
    queryKey: ['equipo-gerencial'],
    queryFn: fetchEquipoGerencial,
    enabled: abierto && esHormiga,
  })

  const preguntar = useMutation({
    mutationFn: (m: string) => preguntarAsistente(rama, m),
    onSuccess: (data) => {
      setPendiente(null)
      setErrorChat(null)
      if (data.pdf) setPdfChip(data.pdf)
      void qc.invalidateQueries({ queryKey: ['asistente', rama] })
      void qc.invalidateQueries({ queryKey: ['objetivos'] })
    },
    onError: (err: Error) => {
      setErrorChat(err.message || 'No pude contestarte. Intenta de nuevo.')
    },
  })

  useEffect(() => {
    const el = fondo.current
    if (el) el.scrollTop = el.scrollHeight
  }, [historial, preguntar.isPending, abierto, pendiente, pdfChip])

  async function enviar(e: React.FormEvent) {
    e.preventDefault()
    const m = texto.trim()
    if (!m || preguntar.isPending) return
    setTexto('')
    setPendiente(m)
    setErrorChat(null)
    setPdfChip(null)
    await preguntar.mutateAsync(m).catch(() => undefined)
  }

  const empleados = equipo.filter(u => u.rol === 'ti' || u.rol === 'administracion')

  return (
    <>
      <motion.button
        type="button"
        onClick={() => setAbierto(true)}
        className={`fixed z-[60] right-4 w-14 h-14 rounded-2xl bg-negro-profundo border border-dorado/40 flex items-center justify-center ${
          listaLarga
            ? 'bottom-[calc(8.75rem+env(safe-area-inset-bottom,0px))] lg:bottom-[4.5rem]'
            : 'bottom-[5.5rem] lg:bottom-6'
        }`}
        whileTap={{ scale: 0.92 }}
        animate={{ boxShadow: ['0 0 0 0 rgba(201,162,39,0.0)', '0 0 0 10px rgba(201,162,39,0.08)', '0 0 0 0 rgba(201,162,39,0.0)'] }}
        transition={{ duration: 2.4, repeat: Infinity }}
        aria-label={esHormiga ? 'Hormiga, asistente de gerencia' : 'Asistente IT PxSol'}
      >
        {esHormiga ? <HormigaIcon size={34} /> : <ChipTiIcon size={30} />}
      </motion.button>

      <AnimatePresence>
        {abierto && (
          <motion.div
            className="fixed inset-0 z-[70] flex items-end sm:items-center sm:justify-end p-0 sm:p-4"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          >
            <div className="absolute inset-0 bg-negro-absoluto/70" onClick={() => setAbierto(false)} />
            <motion.aside
              initial={{ y: 40, opacity: 0, scale: 0.98 }}
              animate={{ y: 0, opacity: 1, scale: 1 }}
              exit={{ y: 30, opacity: 0 }}
              transition={{ type: 'spring', stiffness: 280, damping: 28 }}
              className="relative w-full sm:max-w-md h-[88dvh] sm:h-[min(720px,90dvh)] bg-negro-profundo border border-white/10 rounded-t-3xl sm:rounded-3xl flex flex-col overflow-hidden"
            >
              <header className="px-4 pt-3 pb-3 border-b border-white/5 flex items-center gap-3">
                {esHormiga ? <HormigaIcon size={36} /> : <ChipTiIcon size={32} />}
                <div className="min-w-0 flex-1">
                  <p className="font-display font-semibold text-blanco-roto leading-tight">
                    {esHormiga ? 'Hormiga' : 'Byte'}
                  </p>
                  <p className="text-body-xs text-blanco-roto/40">
                    {esHormiga
                      ? 'Tu parce de gerencia · tablero, PxSol y PDFs'
                      : 'Asistente IT · consultas PxSol'}
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => setAbierto(false)}
                  className="p-2 rounded-xl text-blanco-roto/40 hover:text-blanco-roto"
                  aria-label="Cerrar"
                >
                  <X size={18} />
                </button>
              </header>

              {esHormiga && empleados.length > 0 && (
                <div className="px-4 py-3 border-b border-white/5 space-y-2">
                  <p className="text-[0.65rem] uppercase tracking-widest text-blanco-roto/35">Enviar zumbido</p>
                  <div className="flex gap-2 overflow-x-auto">
                    {empleados.map(e => (
                      <button
                        key={e.id}
                        type="button"
                        disabled={zumbando === e.id}
                        onClick={async () => {
                          setZumbando(e.id)
                          try {
                            await enviarZumbido(e.id, `Zumbido para ${e.nombre}`)
                          } finally {
                            setZumbando(null)
                          }
                        }}
                        className="shrink-0 inline-flex items-center gap-1.5 px-3 py-2 rounded-xl border border-dorado/30 text-dorado text-body-xs"
                      >
                        {zumbando === e.id
                          ? <Loader2 size={12} className="animate-spin" />
                          : <Vibrate size={12} />}
                        {e.nombre.split(' ')[0]}
                      </button>
                    ))}
                  </div>
                </div>
              )}

              <div ref={fondo} className="flex-1 overflow-y-auto px-4 py-4 space-y-3">
                {historial.length === 0 && !pendiente && (
                  <p className="text-body-sm text-blanco-roto/40 leading-relaxed">
                    {esHormiga
                      ? 'Pregúntame cómo va IT, un número de habitación o “hazme el PDF de septiembre”. Te hablo claro, con los números del tablero.'
                      : 'Pregúntame por habitaciones, reservas o estados en PxSol. Esta rama no mezcla el tablero de gerencia.'}
                  </p>
                )}
                {historial.map(m => (
                  <BurbujaMensaje key={m.id} rol={m.rol} texto={m.contenido} />
                ))}
                {pendiente && (
                  <div className="max-w-[90%] ml-auto rounded-2xl px-3.5 py-2.5 text-body-sm bg-dorado/15 text-blanco-roto">
                    {pendiente}
                  </div>
                )}
                {preguntar.isPending && (
                  <div className="bg-white/[0.04] rounded-2xl px-3.5 py-2.5 text-body-xs text-blanco-roto/40 w-fit">
                    Dame un segundo…
                  </div>
                )}
                {errorChat && (
                  <div className="bg-red-900/20 border border-red-700/30 rounded-2xl px-3.5 py-2.5 text-body-xs text-red-300">
                    {errorChat}
                  </div>
                )}
                {pdfChip && (
                  <button
                    type="button"
                    onClick={() => setPreview(pdfChip)}
                    className="inline-flex items-center gap-2 px-3 py-2 rounded-xl bg-dorado/15 border border-dorado/30 text-dorado text-body-xs"
                  >
                    <FileText size={14} />
                    Ver {pdfChip.nombre}
                  </button>
                )}
              </div>

              <form onSubmit={e => void enviar(e)} className="p-3 border-t border-white/5 flex gap-2">
                <input
                  value={texto}
                  onChange={e => setTexto(e.target.value)}
                  placeholder={esHormiga ? 'Ej: PDF de avances de septiembre…' : 'Pregúntale a Byte por PxSol…'}
                  className="flex-1 bg-negro-absoluto/50 border border-white/10 rounded-xl px-3 py-3 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/40"
                />
                <button
                  type="submit"
                  disabled={preguntar.isPending || !texto.trim()}
                  className="w-12 rounded-xl bg-dorado text-negro-absoluto flex items-center justify-center disabled:opacity-40"
                  aria-label="Enviar"
                >
                  <Send size={16} />
                </button>
              </form>
            </motion.aside>
          </motion.div>
        )}
      </AnimatePresence>

      <VisorAdjunto adjunto={preview} onClose={() => setPreview(null)} />
    </>
  )
}

function BurbujaMensaje({ rol, texto }: { rol: string; texto: string }) {
  const esUser = rol === 'user'
  const lineas = texto.replace(/\r/g, '').split(/\n+/).map(l => l.trim()).filter(Boolean)

  if (esUser) {
    return (
      <div className="max-w-[90%] ml-auto rounded-2xl px-3.5 py-2.5 text-body-sm leading-relaxed bg-dorado/15 text-blanco-roto">
        {texto}
      </div>
    )
  }

  return (
    <div className="max-w-[90%] rounded-2xl px-3.5 py-3 text-body-sm bg-white/[0.04] text-blanco-roto/90 space-y-2">
      {lineas.map((linea, i) => {
        const titulo = /:$/.test(linea) && !linea.startsWith('•')
        const vineta = /^[•\-\*]\s+/.test(linea)
        const cuerpo = linea.replace(/^[•\-\*]\s+/, '')
        if (titulo) {
          return (
            <p key={i} className="font-semibold text-dorado pt-1 first:pt-0">
              {linea}
            </p>
          )
        }
        if (vineta) {
          return (
            <p key={i} className="flex gap-2 leading-snug">
              <span className="text-dorado shrink-0 font-semibold">•</span>
              <span>{cuerpo}</span>
            </p>
          )
        }
        return (
          <p key={i} className={i === 0 ? 'font-medium text-blanco-roto' : 'leading-snug'}>
            {linea}
          </p>
        )
      })}
    </div>
  )
}
