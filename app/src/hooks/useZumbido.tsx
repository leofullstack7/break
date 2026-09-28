import { useEffect, useRef, useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { supabase } from '@/lib/supabase'
import { useAuthStore } from '@/store/authStore'
import { esGerencial } from '@/lib/roles'
import { marcarZumbidoLeido } from '@/lib/trazabilidad'
import { mostrarNotificacion, pedirPermisoNotificaciones, sonarAviso } from '@/lib/notificaciones'
import type { Zumbido } from '@/types/database.types'

function vibrarZumbido() {
  try {
    navigator.vibrate?.([80, 40, 120, 40, 200, 80, 80, 40, 400])
  } catch { /* sin API */ }
}

export function useZumbido() {
  const { user, rol } = useAuthStore()
  const [zumbido, setZumbido] = useState<Zumbido | null>(null)
  const visto = useRef<Set<string>>(new Set())

  useEffect(() => {
    if (!user || !esGerencial(rol) || rol === 'gerente') return
    void pedirPermisoNotificaciones()

    const canal = supabase
      .channel(`zumbidos-${user.id}`)
      .on(
        'postgres_changes',
        { event: 'INSERT', schema: 'public', table: 'zumbidos' },
        payload => {
          const z = payload.new as Zumbido
          if (z.para_id !== user.id) return
          if (visto.current.has(z.id)) return
          visto.current.add(z.id)
          vibrarZumbido()
          sonarAviso()
          mostrarNotificacion({
            titulo: 'Zumbido de gerencia',
            cuerpo: z.mensaje || 'La gerencia te necesita.',
            tag: `zumbido-${z.id}`,
          })
          setZumbido(z)
        },
      )
      .subscribe()

    return () => {
      void supabase.removeChannel(canal)
    }
  }, [user, rol])

  async function dismiss() {
    if (zumbido) await marcarZumbidoLeido(zumbido.id)
    setZumbido(null)
  }

  return { zumbido, dismiss }
}

export function ZumbidoOverlay() {
  const { zumbido, dismiss } = useZumbido()

  useEffect(() => {
    if (!zumbido) return
    vibrarZumbido()
    const t = window.setInterval(vibrarZumbido, 1600)
    return () => window.clearInterval(t)
  }, [zumbido])

  return (
    <AnimatePresence>
      {zumbido && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-[80] bg-negro-absoluto/80 backdrop-blur-md flex items-end sm:items-center justify-center p-4"
          onClick={() => void dismiss()}
        >
          <motion.div
            initial={{ y: 80, scale: 0.92 }}
            animate={{ y: 0, scale: 1 }}
            exit={{ y: 40, opacity: 0 }}
            transition={{ type: 'spring', stiffness: 320, damping: 24 }}
            onClick={e => e.stopPropagation()}
            className="w-full max-w-sm rounded-3xl border border-dorado/40 bg-negro-profundo p-6 text-center"
          >
            <motion.div
              animate={{ scale: [1, 1.08, 1] }}
              transition={{ duration: 0.5, repeat: 3 }}
              className="mx-auto mb-4 h-14 w-14 rounded-2xl bg-dorado/15 border border-dorado/30 flex items-center justify-center text-dorado font-display font-black"
            >
              Z
            </motion.div>
            <p className="text-body-xs uppercase tracking-[0.25em] text-dorado/80 mb-2">Zumbido</p>
            <h2 className="font-display text-xl text-blanco-roto mb-2">Gerencia te llama</h2>
            <p className="text-body-sm text-blanco-roto/60 mb-6">
              {zumbido.mensaje || 'Revisa el tablero de objetivos.'}
            </p>
            <button
              type="button"
              onClick={() => void dismiss()}
              className="w-full py-3 rounded-xl bg-dorado text-negro-absoluto font-semibold"
            >
              Entendido
            </button>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
