import { useState } from 'react'
import { useLocation } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import { Sidebar } from './Sidebar'
import { Topbar } from './Topbar'
import { BottomNav } from './BottomNav'

// Mapa de ruta → título de página
const TITULOS: Record<string, string> = {
  '/admin':             'Dashboard',
  '/admin/reservas':    'Reservas',
  '/admin/huespedes':   'Huéspedes',
  '/admin/aseo':        'Aseo',
  '/admin/lavanderia':  'Lavandería',
  '/admin/finanzas':    'Finanzas',
  '/admin/marketing':   'Marketing',
  '/admin/usuarios':    'Usuarios',
}

interface AdminLayoutProps {
  children: React.ReactNode
}

export function AdminLayout({ children }: AdminLayoutProps) {
  const location  = useLocation()
  const [sidebarAbierto, setSidebarAbierto] = useState(false)
  const titulo = TITULOS[location.pathname] ?? 'Panel'

  return (
    <div className="flex h-screen bg-negro-absoluto overflow-hidden">

      {/* ── SIDEBAR DESKTOP (fijo, siempre visible en lg+) ── */}
      <div className="hidden lg:flex shrink-0">
        <Sidebar />
      </div>

      {/* ── SIDEBAR MOBILE (drawer animado) ── */}
      <AnimatePresence>
        {sidebarAbierto && (
          <>
            {/* Overlay */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.2 }}
              className="fixed inset-0 bg-negro-absoluto/80 z-40 lg:hidden"
              onClick={() => setSidebarAbierto(false)}
            />
            {/* Drawer */}
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

      {/* ── CONTENIDO PRINCIPAL ── */}
      <div className="flex flex-col flex-1 min-w-0">
        <Topbar titulo={titulo} onMenuClick={() => setSidebarAbierto(true)} />

        <main className="flex-1 overflow-y-auto pb-20 lg:pb-0">
          {children}
        </main>
      </div>

      {/* ── BOTTOM NAV MOBILE ── */}
      <BottomNav />

    </div>
  )
}
