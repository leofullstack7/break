import { useEffect, useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { Loader2, X } from 'lucide-react'
import { descargarAdjunto } from '@/lib/trazabilidad'

export interface AdjuntoVista {
  nombre: string
  path: string
  mime: string
}

function esPdf(mime: string, nombre: string) {
  return mime.includes('pdf') || nombre.toLowerCase().endsWith('.pdf')
}

function esImagen(mime: string, nombre: string) {
  if (mime.startsWith('image/')) return true
  return /\.(jpe?g|png|webp|gif)$/i.test(nombre)
}

export function VisorAdjunto({
  adjunto,
  onClose,
}: {
  adjunto: AdjuntoVista | null
  onClose: () => void
}) {
  const [src, setSrc] = useState<string | null>(null)
  const [paginas, setPaginas] = useState<string[]>([])
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!adjunto) return
    let objectUrl: string | null = null
    const pageUrls: string[] = []
    let cancelado = false

    void (async () => {
      setSrc(null)
      setPaginas([])
      setError(null)
      const blob = await descargarAdjunto(adjunto.path)
      if (!blob) {
        if (!cancelado) setError('No pude abrir este archivo.')
        return
      }
      if (esPdf(adjunto.mime, adjunto.nombre)) {
        try {
          const urls = await renderizarPdf(blob)
          if (!cancelado) {
            pageUrls.push(...urls)
            setPaginas(urls)
          } else {
            urls.forEach(u => URL.revokeObjectURL(u))
          }
        } catch {
          if (!cancelado) setError('Este PDF no se pudo leer. Pídele a Hormiga que lo regenere.')
        }
        return
      }
      objectUrl = URL.createObjectURL(blob)
      if (!cancelado) setSrc(objectUrl)
    })()

    return () => {
      cancelado = true
      if (objectUrl) URL.revokeObjectURL(objectUrl)
      pageUrls.forEach(u => URL.revokeObjectURL(u))
    }
  }, [adjunto])

  return (
    <AnimatePresence>
      {adjunto && (
        <motion.div
          className="fixed inset-0 z-[75] flex items-end sm:items-center justify-center p-0 sm:p-4"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
        >
          <div className="absolute inset-0 bg-negro-absoluto/85 backdrop-blur-md" onClick={onClose} />
          <motion.div
            initial={{ y: 40, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: 24, opacity: 0 }}
            transition={{ type: 'spring', stiffness: 300, damping: 28 }}
            className="relative w-full sm:max-w-3xl h-[92dvh] sm:h-[min(860px,90dvh)] bg-negro-profundo border border-white/10 rounded-t-3xl sm:rounded-3xl flex flex-col overflow-hidden"
          >
            <header className="px-4 py-3 border-b border-white/5 flex items-center gap-3 shrink-0">
              <p className="flex-1 min-w-0 font-medium text-blanco-roto truncate">{adjunto.nombre}</p>
              <button
                type="button"
                onClick={onClose}
                className="p-2 rounded-xl text-blanco-roto/40 hover:text-blanco-roto"
                aria-label="Cerrar vista previa"
              >
                <X size={18} />
              </button>
            </header>
            <div className="flex-1 min-h-0 bg-[#1a1a1a] overflow-y-auto">
              {!src && paginas.length === 0 && !error && (
                <div className="h-full flex items-center justify-center text-blanco-roto/40">
                  <Loader2 size={22} className="animate-spin" />
                </div>
              )}
              {error && (
                <p className="p-6 text-body-sm text-blanco-roto/50">{error}</p>
              )}
              {src && esImagen(adjunto.mime, adjunto.nombre) && (
                <img src={src} alt={adjunto.nombre} className="w-full h-full object-contain" />
              )}
              {paginas.length > 0 && (
                <div className="p-3 space-y-3">
                  {paginas.map((u, i) => (
                    <img
                      key={u}
                      src={u}
                      alt={`Página ${i + 1}`}
                      className="w-full rounded-lg shadow-lg bg-white"
                    />
                  ))}
                </div>
              )}
              {src && !esPdf(adjunto.mime, adjunto.nombre) && !esImagen(adjunto.mime, adjunto.nombre) && (
                <div className="p-6 text-body-sm text-blanco-roto/55 leading-relaxed">
                  Este archivo (Word u otro) no se puede leer aquí. Los PDF y las fotos sí.
                </div>
              )}
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}

async function renderizarPdf(blob: Blob): Promise<string[]> {
  const pdfjs = await import('pdfjs-dist')
  const worker = await import('pdfjs-dist/build/pdf.worker.min.mjs?url')
  pdfjs.GlobalWorkerOptions.workerSrc = worker.default
  const data = new Uint8Array(await blob.arrayBuffer())
  const doc = await pdfjs.getDocument({ data }).promise
  const urls: string[] = []
  const max = Math.min(doc.numPages, 8)
  for (let i = 1; i <= max; i++) {
    const page = await doc.getPage(i)
    const viewport = page.getViewport({ scale: 1.45 })
    const canvas = document.createElement('canvas')
    canvas.width = viewport.width
    canvas.height = viewport.height
    const ctx = canvas.getContext('2d')
    if (!ctx) continue
    await page.render({ canvasContext: ctx, viewport }).promise
    urls.push(canvas.toDataURL('image/jpeg', 0.86))
  }
  return urls
}
