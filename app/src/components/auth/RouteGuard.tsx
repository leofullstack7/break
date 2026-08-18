import { type ReactNode } from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuthStore } from '@/store/authStore'
import type { RolUsuario } from '@/types/database.types'
import { PageLoader } from '@/components/ui/PageLoader'

interface RouteGuardProps {
  children: ReactNode
  roles: RolUsuario[]
}

export function RouteGuard({ children, roles }: RouteGuardProps) {
  const location = useLocation()
  const { user, rol, inicializado } = useAuthStore()

  // Esperar a que el store inicialice (lectura de sesión)
  if (!inicializado) return <PageLoader />

  // Sin sesión → login
  if (!user) return <Navigate to="/login" state={{ from: location }} replace />

  // Con sesión pero sin rol válido para esta ruta → redirigir según rol
  if (!rol || !roles.includes(rol)) {
    const destino = rol === 'huesped' ? '/huesped' : rol ? '/admin' : '/'
    return <Navigate to={destino} replace />
  }

  return <>{children}</>
}
