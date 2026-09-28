import { useEffect, useRef, useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { Send, X, Vibrate, Loader2 } from 'lucide-react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useAuthStore } from '@/store/authStore'
import { esGerencial } from '@/lib/roles'
import {
  enviarZumbido,
  fetchAsistente,
  fetchEquipoGerencial,
  preguntarAsistente,
} from '@/lib/trazabilidad'
import { ChipTiIcon, HormigaIcon } from './HormigaIcon'

export function AsistenteFlotante() {
  const { rol, user } = useAuthStore()
  if (!user || !esGerencial(rol)) return null
  if (rol === 'gerente') return <Panel rama="gerente" />
  if (rol === 'ti') return <Panel rama="ti" />
  return null
}

function Panel({ rama }: { rama: 'gerente' | 'ti' }) {
  const [abierto, setAbierto] = useState(false)
  const [texto, setTexto] = useState('')
  const [zumbando, setZumbando] = useState<string | null>(null)
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
    onSuccess: () => {
      void qc.invalidateQueries({ queryKey: ['asistente', rama] })
    },
  })

  useEffect(() => {
    const el = fondo.current
    if (el) el.scrollTop = el.scrollHeight
  }, [historial, preguntar.isPending, abierto])

  async function enviar(e: React.FormEvent) {
    e.preventDefault()
    const m = texto.trim()
    if (!m || preguntar.isPending) return
    setTexto('')
    await preguntar.mutateAsync(m)
  }

  const empleados = equipo.filter(u => u.rol === 'ti' || u.rol === 'administracion')

  return (
    <>
      <motion.button
        type="button"
        onClick={() => setAbierto(true)}
        className="fixed z-[60] right-4 bottom-[5.5rem] lg:bottom-6 w-14 h-14 rounded-2xl bg-negro-profundo border border-dorado/40 flex items-center justify-center"
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
                      ? 'Asistente de gerencia · equipo, PxSol y tablero'
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
                {historial.length === 0 && (
                  <p className="text-body-sm text-blanco-roto/40 leading-relaxed">
                    {esHormiga
                      ? 'Pregúntame por objetivos, tareas de IT, ocupación o un huésped. Me alimento de lo que el equipo sube al tablero.'
                      : 'Pregúntame por habitaciones, reservas o estados en PxSol. Esta rama no mezcla el tablero de gerencia.'}
                  </p>
                )}
                {historial.map(m => (
                  <div
                    key={m.id}
                    className={`max-w-[90%] rounded-2xl px-3.5 py-2.5 text-body-sm leading-relaxed ${
                      m.rol === 'user'
                        ? 'ml-auto bg-dorado/15 text-blanco-roto'
                        : 'bg-white/[0.04] text-blanco-roto/85'
                    }`}
                  >
                    {m.contenido}
                  </div>
                ))}
                {preguntar.isPending && (
                  <div className="bg-white/[0.04] rounded-2xl px-3.5 py-2.5 text-body-xs text-blanco-roto/40 w-fit">
                    Pensando…
                  </div>
                )}
              </div>

              <form onSubmit={e => void enviar(e)} className="p-3 border-t border-white/5 flex gap-2">
                <input
                  value={texto}
                  onChange={e => setTexto(e.target.value)}
                  placeholder={esHormiga ? 'Pregúntale a Hormiga…' : 'Pregúntale a Byte por PxSol…'}
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
    </>
  )
}
