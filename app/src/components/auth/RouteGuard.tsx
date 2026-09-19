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

  if (!inicializado) return <PageLoader />

  if (!user) {
    return <Navigate to="/" state={{ from: location }} replace />
  }

  if (!rol || !roles.includes(rol)) {
    // Staff sin permiso → dashboard; huésped → login admin
    const destino = rol && rol !== 'huesped' ? '/admin' : '/'
    return <Navigate to={destino} replace />
  }

  return <>{children}</>
}
