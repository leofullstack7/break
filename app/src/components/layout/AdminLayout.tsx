import { useState } from 'react'
import { useLocation } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import { Sidebar } from './Sidebar'
import { Topbar } from './Topbar'
import { BottomNav } from './BottomNav'
import { useChatInbox } from '@/hooks/useChatInbox'

const TITULOS: Record<string, string> = {
  '/admin':             'Dashboard',
  '/admin/reservas':    'Reservas',
  '/admin/huespedes':   'Huéspedes',
  '/admin/aseo':        'Aseo',
  '/admin/lavanderia':  'Lavandería',
  '/admin/finanzas':    'Finanzas',
  '/admin/compras':     'Compras Siigo',
  '/admin/marketing':   'Marketing',
  '/admin/usuarios':    'Usuarios',
  '/admin/claves':      'Claves',
  '/admin/conversaciones': 'Conversaciones',
}

interface AdminLayoutProps {
  children: React.ReactNode
}

export function AdminLayout({ children }: AdminLayoutProps) {
  const location  = useLocation()
  const [sidebarAbierto, setSidebarAbierto] = useState(false)
  useChatInbox({ escuchar: true })
  const esChat = location.pathname.startsWith('/admin/conversaciones')
  const titulo = TITULOS[location.pathname] ??
    (location.pathname.startsWith('/admin/huespedes/') ? 'Huésped' : 'Panel')

  return (
    <div className="flex h-[100dvh] max-h-[100dvh] bg-negro-absoluto overflow-hidden w-full max-w-[100vw]">

      <div className="hidden lg:flex shrink-0">
        <Sidebar />
      </div>

      <AnimatePresence>
        {sidebarAbierto && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.2 }}
              className="fixed inset-0 bg-negro-absoluto/80 z-40 lg:hidden"
              onClick={() => setSidebarAbierto(false)}
            />
            <motion.div
              initial={{ x: -240 }}
              animate={{ x: 0 }}
              exit={{ x: -240 }}
              transition={{ type: 'spring', stiffness: 300, damping: 30 }}
              className="fixed left-0 top-0 bottom-0 z-50 lg:hidden"
            >
              <Sidebar onClose={() => setSidebarAbierto(false)} />
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* Columna principal tipo app (ancho contenido centrado en móvil grande) */}
      <div className="flex flex-col flex-1 min-w-0 min-h-0 overflow-hidden">
        <Topbar titulo={titulo} onMenuClick={() => setSidebarAbierto(true)} />

        <main
          className={`flex-1 min-h-0 overflow-x-hidden ${esChat ? 'overflow-hidden' : 'overflow-y-auto overscroll-y-contain'}`}
          style={{ paddingBottom: esChat ? 0 : 'calc(4.5rem + env(safe-area-inset-bottom, 0px))' }}
        >
          <div className={`w-full min-w-0 ${esChat ? 'h-full' : ''}`}>
            {children}
          </div>
        </main>
      </div>

      <BottomNav />
    </div>
  )
}
