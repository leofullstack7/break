import { lazy, Suspense } from 'react'
import { Routes, Route, useLocation, Navigate } from 'react-router-dom'
import { AnimatePresence } from 'framer-motion'
import { RouteGuard } from '@/components/auth/RouteGuard'
import { AdminLayout } from '@/components/layout/AdminLayout'
import { PageLoader } from '@/components/ui/PageLoader'

const Login = lazy(() => import('@/pages/auth/Login'))

// ── ADMIN ─────────────────────────────────────────────────────
const Dashboard  = lazy(() => import('@/pages/admin/Dashboard'))
const Reservas   = lazy(() => import('@/pages/admin/Reservas'))
const Huespedes  = lazy(() => import('@/pages/admin/Huespedes'))
const HuespedDet = lazy(() => import('@/pages/admin/HuespedDetalle'))
const Aseo       = lazy(() => import('@/pages/admin/Aseo'))
const Lavanderia = lazy(() => import('@/pages/admin/Lavanderia'))
const Finanzas   = lazy(() => import('@/pages/admin/Finanzas'))
const Marketing  = lazy(() => import('@/pages/admin/Marketing'))
const Usuarios   = lazy(() => import('@/pages/admin/Usuarios'))
const Claves     = lazy(() => import('@/pages/admin/Claves'))
const Conversaciones = lazy(() => import('@/pages/admin/Conversaciones'))

// ── ARCHIVO: sitio público + portal huésped (apartados, no son la entrada) ──
const Landing      = lazy(() => import('@/pages/public/Landing'))
const Habitaciones = lazy(() => import('@/pages/public/Habitaciones'))
const Reservar     = lazy(() => import('@/pages/public/Reservar'))
const Nosotros     = lazy(() => import('@/pages/public/Nosotros'))
const Ubicacion    = lazy(() => import('@/pages/public/Ubicacion'))
const HuespedPortal  = lazy(() => import('@/pages/huesped/Portal'))
const HuespedReserva = lazy(() => import('@/pages/huesped/MiReserva'))
const ChatHabitacion = lazy(() => import('@/pages/public/ChatHabitacion'))

function AdminRoute({ roles, children }: {
  roles: ('gerente' | 'recepcion' | 'aseo' | 'marketing')[]
  children: React.ReactNode
}) {
  return (
    <RouteGuard roles={roles}>
      <AdminLayout>{children}</AdminLayout>
    </RouteGuard>
  )
}

export default function App() {
  const location = useLocation()

  return (
    <AnimatePresence mode="wait">
      <Suspense fallback={<PageLoader />}>
        <Routes location={location} key={location.pathname}>

          {/* Entrada: login administrativo */}
          <Route path="/" element={<Login />} />
          <Route path="/login" element={<Navigate to="/" replace />} />

          {/* Panel admin */}
          <Route path="/admin" element={
            <AdminRoute roles={['gerente', 'recepcion', 'aseo', 'marketing']}>
              <Dashboard />
            </AdminRoute>
          } />
          <Route path="/admin/reservas" element={
            <AdminRoute roles={['gerente', 'recepcion']}>
              <Reservas />
            </AdminRoute>
          } />
          <Route path="/admin/huespedes" element={
            <AdminRoute roles={['gerente', 'recepcion', 'marketing']}>
              <Huespedes />
            </AdminRoute>
          } />
          <Route path="/admin/huespedes/:id" element={
            <AdminRoute roles={['gerente', 'recepcion', 'marketing']}>
              <HuespedDet />
            </AdminRoute>
          } />
          <Route path="/admin/aseo" element={
            <AdminRoute roles={['gerente', 'aseo', 'recepcion']}>
              <Aseo />
            </AdminRoute>
          } />
          <Route path="/admin/lavanderia" element={
            <AdminRoute roles={['gerente', 'aseo']}>
              <Lavanderia />
            </AdminRoute>
          } />
          <Route path="/admin/finanzas" element={
            <AdminRoute roles={['gerente']}>
              <Finanzas />
            </AdminRoute>
          } />
          <Route path="/admin/marketing" element={
            <AdminRoute roles={['gerente', 'marketing']}>
              <Marketing />
            </AdminRoute>
          } />
          <Route path="/admin/usuarios" element={
            <AdminRoute roles={['gerente']}>
              <Usuarios />
            </AdminRoute>
          } />
          <Route path="/admin/claves" element={
            <AdminRoute roles={['gerente', 'recepcion']}>
              <Claves />
            </AdminRoute>
          } />
          <Route path="/admin/conversaciones" element={
            <AdminRoute roles={['gerente', 'recepcion']}>
              <Conversaciones />
            </AdminRoute>
          } />

          {/* Chat huésped por QR — público, sin login */}
          <Route path="/h/:token" element={<ChatHabitacion />} />

          {/* Sitio público y portal huésped — conservados bajo /sitio */}
          <Route path="/sitio" element={<Landing />} />
          <Route path="/sitio/habitaciones" element={<Habitaciones />} />
          <Route path="/sitio/reservar" element={<Reservar />} />
          <Route path="/sitio/nosotros" element={<Nosotros />} />
          <Route path="/sitio/ubicacion" element={<Ubicacion />} />
          <Route path="/sitio/huesped" element={
            <RouteGuard roles={['huesped']}>
              <HuespedPortal />
            </RouteGuard>
          } />
          <Route path="/sitio/huesped/mi-reserva" element={
            <RouteGuard roles={['huesped']}>
              <HuespedReserva />
            </RouteGuard>
          } />

          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </Suspense>
    </AnimatePresence>
  )
}
