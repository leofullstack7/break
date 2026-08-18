import { NavLink } from 'react-router-dom'
import { LayoutDashboard, CalendarDays, Users, Sparkles, Megaphone, TrendingUp } from 'lucide-react'
import { useAuthStore } from '@/store/authStore'
import type { RolUsuario } from '@/types/database.types'

// Solo los 4 items más importantes por rol para el nav móvil
const BOTTOM_POR_ROL: Record<RolUsuario, { path: string; label: string; Icon: React.ElementType; end?: boolean }[]> = {
  gerente: [
    { path: '/admin',           label: 'Inicio',    Icon: LayoutDashboard, end: true },
    { path: '/admin/reservas',  label: 'Reservas',  Icon: CalendarDays },
    { path: '/admin/huespedes', label: 'Huéspedes', Icon: Users },
    { path: '/admin/finanzas',  label: 'Finanzas',  Icon: TrendingUp },
  ],
  recepcion: [
    { path: '/admin',           label: 'Inicio',    Icon: LayoutDashboard, end: true },
    { path: '/admin/reservas',  label: 'Reservas',  Icon: CalendarDays },
    { path: '/admin/huespedes', label: 'Huéspedes', Icon: Users },
    { path: '/admin/aseo',      label: 'Aseo',      Icon: Sparkles },
  ],
  aseo: [
    { path: '/admin',            label: 'Inicio', Icon: LayoutDashboard, end: true },
    { path: '/admin/aseo',       label: 'Aseo',   Icon: Sparkles },
  ],
  marketing: [
    { path: '/admin',           label: 'Inicio',    Icon: LayoutDashboard, end: true },
    { path: '/admin/huespedes', label: 'Huéspedes', Icon: Users },
    { path: '/admin/marketing', label: 'Marketing', Icon: Megaphone },
  ],
  huesped: [],
}

export function BottomNav() {
  const { rol } = useAuthStore()
  const items = rol ? (BOTTOM_POR_ROL[rol] ?? []) : []
  if (items.length === 0) return null

  return (
    <nav className="lg:hidden fixed bottom-0 left-0 right-0 h-16 bg-negro-profundo/95 backdrop-blur-md border-t border-white/10 flex items-center justify-around px-2 z-40">
      {items.map(({ path, label, Icon, end }) => (
        <NavLink
          key={path}
          to={path}
          end={end}
          className={({ isActive }) =>
            `flex flex-col items-center gap-1 px-4 py-1 rounded-xl transition-all ${
              isActive ? 'text-dorado' : 'text-blanco-roto/50'
            }`
          }
        >
          <Icon size={20} />
          <span className="text-body-xs">{label}</span>
        </NavLink>
      ))}
    </nav>
  )
}
