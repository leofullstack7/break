import { NavLink } from 'react-router-dom'
import {
  LayoutDashboard, CalendarDays, Users, Sparkles,
  Shirt, TrendingUp, Megaphone, LogOut, X, UserCog, KeyRound,
} from 'lucide-react'
import { useAuthStore } from '@/store/authStore'
import type { RolUsuario } from '@/types/database.types'

interface NavItem {
  path: string
  label: string
  Icon: React.ElementType
}

const NAV_POR_ROL: Record<RolUsuario, NavItem[]> = {
  gerente: [
    { path: '/admin',             label: 'Dashboard',   Icon: LayoutDashboard },
    { path: '/admin/reservas',    label: 'Reservas',    Icon: CalendarDays },
    { path: '/admin/huespedes',   label: 'Huéspedes',   Icon: Users },
    { path: '/admin/aseo',        label: 'Aseo',        Icon: Sparkles },
    { path: '/admin/lavanderia',  label: 'Lavandería',  Icon: Shirt },
    { path: '/admin/finanzas',    label: 'Finanzas',    Icon: TrendingUp },
    { path: '/admin/marketing',   label: 'Marketing',   Icon: Megaphone },
    { path: '/admin/usuarios',    label: 'Usuarios',    Icon: UserCog },
    { path: '/admin/claves',      label: 'Claves',      Icon: KeyRound },
  ],
  recepcion: [
    { path: '/admin',           label: 'Dashboard', Icon: LayoutDashboard },
    { path: '/admin/reservas',  label: 'Reservas',  Icon: CalendarDays },
    { path: '/admin/huespedes', label: 'Huéspedes', Icon: Users },
    { path: '/admin/aseo',      label: 'Aseo',      Icon: Sparkles },
    { path: '/admin/claves',    label: 'Claves',    Icon: KeyRound },
  ],
  aseo: [
    { path: '/admin',            label: 'Dashboard',  Icon: LayoutDashboard },
    { path: '/admin/aseo',       label: 'Aseo',       Icon: Sparkles },
    { path: '/admin/lavanderia', label: 'Lavandería', Icon: Shirt },
  ],
  marketing: [
    { path: '/admin',           label: 'Dashboard', Icon: LayoutDashboard },
    { path: '/admin/huespedes', label: 'Huéspedes', Icon: Users },
    { path: '/admin/marketing', label: 'Marketing', Icon: Megaphone },
  ],
  huesped: [],
}

interface SidebarProps {
  onClose?: () => void
}

export function Sidebar({ onClose }: SidebarProps) {
  const { rol, nombre, signOut } = useAuthStore()
  const items = rol ? (NAV_POR_ROL[rol] ?? []) : []
  const inicial = nombre?.charAt(0).toUpperCase() ?? 'U'

  return (
    <aside className="flex flex-col h-full w-64 bg-negro-profundo border-r border-white/[0.06]">

      {/* ── Header / Logo ── */}
      <div className="px-5 pt-6 pb-5 border-b border-white/[0.06]">
        <div className="flex items-center justify-between">
          <div>
            <span className="font-display font-black tracking-[0.2em] text-dorado"
              style={{ fontSize: '1.35rem', letterSpacing: '0.2em' }}>
              BREAK
            </span>
            <div className="flex items-center gap-2 mt-1">
              <div className="h-px flex-1 bg-gradient-to-r from-dorado/40 to-transparent" />
              <p className="text-body-xs text-blanco-roto/20 uppercase tracking-widest shrink-0"
                style={{ fontSize: '0.6rem' }}>
                Hotel
              </p>
            </div>
          </div>
          {onClose && (
            <button
              onClick={onClose}
              className="lg:hidden w-7 h-7 flex items-center justify-center rounded-lg text-blanco-roto/30 hover:text-blanco-roto hover:bg-white/5 transition-all"
            >
              <X size={15} />
            </button>
          )}
        </div>
      </div>

      {/* ── Navegación ── */}
      <nav className="flex-1 px-3 py-4 overflow-y-auto space-y-0.5">
        {items.map(({ path, label, Icon }) => (
          <NavLink
            key={path}
            to={path}
            end={path === '/admin'}
            onClick={onClose}
            className={({ isActive }) =>
              `relative flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-body-sm font-medium transition-all duration-150 group ${
                isActive
                  ? 'bg-dorado/12 text-dorado'
                  : 'text-blanco-roto/50 hover:text-blanco-roto hover:bg-white/[0.06]'
              }`
            }
          >
            {({ isActive }) => (
              <>
                {/* Indicador activo */}
                {isActive && (
                  <span className="absolute left-0 top-1/2 -translate-y-1/2 w-0.5 h-5 bg-dorado rounded-r-full" />
                )}
                <Icon size={16} className="shrink-0" strokeWidth={isActive ? 2 : 1.75} />
                <span>{label}</span>
              </>
            )}
          </NavLink>
        ))}
      </nav>

      {/* ── Footer de usuario ── */}
      <div className="px-3 pb-4 pt-2 border-t border-white/[0.06]">
        {/* Card de usuario */}
        <div className="flex items-center gap-3 px-3 py-3 rounded-xl mb-1">
          <div className="w-8 h-8 rounded-full bg-gradient-to-br from-dorado/40 to-dorado/10 border border-dorado/30 flex items-center justify-center shrink-0">
            <span className="text-body-xs font-black text-dorado">{inicial}</span>
          </div>
          <div className="min-w-0">
            <p className="text-body-sm font-semibold text-blanco-roto/90 truncate leading-tight">{nombre ?? 'Usuario'}</p>
            <p className="text-body-xs text-blanco-roto/30 capitalize leading-tight">{rol ?? ''}</p>
          </div>
        </div>

        {/* Logout */}
        <button
          onClick={signOut}
          className="flex items-center gap-3 w-full px-3.5 py-2.5 rounded-xl text-body-sm text-blanco-roto/35 hover:text-red-400 hover:bg-red-500/8 transition-all border border-transparent"
        >
          <LogOut size={15} />
          Cerrar sesión
        </button>
      </div>

    </aside>
  )
}
