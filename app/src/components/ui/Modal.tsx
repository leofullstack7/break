import { useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { X } from 'lucide-react'

interface ModalProps {
  isOpen: boolean
  onClose: () => void
  title: string
  children: React.ReactNode
  size?: 'sm' | 'md' | 'lg'
}

const SIZES = {
  sm: 'max-w-sm',
  md: 'max-w-lg',
  lg: 'max-w-2xl',
}

export function Modal({ isOpen, onClose, title, children, size = 'md' }: ModalProps) {
  useEffect(() => {
    if (!isOpen) return
    const fn = (e: KeyboardEvent) => { if (e.key === 'Escape') onClose() }
    document.addEventListener('keydown', fn)
    // Bloquear scroll del body
    document.body.style.overflow = 'hidden'
    return () => {
      document.removeEventListener('keydown', fn)
      document.body.style.overflow = ''
    }
  }, [isOpen, onClose])

  return (
    <AnimatePresence>
      {isOpen && (
        // Contenedor fixed que cubre toda la pantalla con flex centering
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">

          {/* Overlay */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.18 }}
            className="absolute inset-0 bg-negro-absoluto/85 backdrop-blur-sm"
            onClick={onClose}
          />

          {/* Panel — siempre centrado en la pantalla */}
          <motion.div
            initial={{ opacity: 0, scale: 0.95, y: 16 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: 16 }}
            transition={{ type: 'spring', stiffness: 340, damping: 30 }}
            className={`relative w-full ${SIZES[size]} glass rounded-2xl flex flex-col max-h-[90vh]`}
          >
            {/* Header */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-white/5 shrink-0">
              <h2 className="font-display text-display-sm font-semibold text-blanco-roto leading-tight">
                {title}
              </h2>
              <button
                onClick={onClose}
                className="p-1.5 rounded-lg text-blanco-roto/40 hover:text-blanco-roto hover:bg-white/5 transition-all"
              >
                <X size={16} />
              </button>
            </div>

            {/* Contenido con scroll interno */}
            <div className="overflow-y-auto px-6 py-5 flex-1">
              {children}
            </div>
          </motion.div>

        </div>
      )}
    </AnimatePresence>
  )
}
