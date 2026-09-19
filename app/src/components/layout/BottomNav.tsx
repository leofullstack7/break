import { NavLink } from 'react-router-dom'
import { LayoutDashboard, CalendarDays, Users, Sparkles, Megaphone, TrendingUp } from 'lucide-react'
import { useAuthStore } from '@/store/authStore'
import type { RolUsuario } from '@/types/database.types'

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
    <nav
      className="lg:hidden fixed bottom-0 left-0 right-0 z-40 border-t border-white/10 bg-negro-profundo/95 backdrop-blur-md"
      style={{ paddingBottom: 'env(safe-area-inset-bottom, 0px)' }}
    >
      <div className="h-16 max-w-lg mx-auto flex items-stretch justify-around px-1">
        {items.map(({ path, label, Icon, end }) => (
          <NavLink
            key={path}
            to={path}
            end={end}
            className={({ isActive }) =>
              `flex-1 min-w-0 flex flex-col items-center justify-center gap-0.5 px-1 rounded-xl transition-all ${
                isActive ? 'text-dorado' : 'text-blanco-roto/45'
              }`
            }
          >
            <Icon size={20} className="shrink-0" />
            <span className="text-[0.65rem] leading-none truncate max-w-full">{label}</span>
          </NavLink>
        ))}
      </div>
    </nav>
  )
}
