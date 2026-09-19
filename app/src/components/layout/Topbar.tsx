import { Link } from 'react-router-dom'
import { Menu, MessageCircle } from 'lucide-react'
import { useAuthStore } from '@/store/authStore'
import { useChatInbox } from '@/hooks/useChatInbox'

interface TopbarProps {
  titulo: string
  onMenuClick: () => void
}

const FECHA_HOY = new Date().toLocaleDateString('es-CO', {
  weekday: 'long', day: 'numeric', month: 'long',
})

export function Topbar({ titulo, onMenuClick }: TopbarProps) {
  const { nombre, rol } = useAuthStore()
  const { noLeidos, habilitado } = useChatInbox()
  const inicial = nombre?.charAt(0).toUpperCase() ?? 'U'

  return (
    <header className="h-14 border-b border-white/[0.06] bg-negro-profundo/60 backdrop-blur-md flex items-center justify-between px-4 lg:px-6 shrink-0 gap-4">

      <div className="flex items-center gap-3 min-w-0">
        <button
          onClick={onMenuClick}
          className="lg:hidden w-8 h-8 flex items-center justify-center rounded-lg text-blanco-roto/40 hover:text-blanco-roto hover:bg-white/5 transition-all shrink-0"
        >
          <Menu size={18} />
        </button>

        <div className="min-w-0">
          <h1 className="font-display font-semibold text-blanco-roto leading-none truncate"
            style={{ fontSize: '1.1rem' }}>
            {titulo}
          </h1>
          <p className="text-body-xs text-blanco-roto/25 capitalize hidden sm:block leading-tight mt-0.5">
            {FECHA_HOY}
          </p>
        </div>
      </div>

      <div className="flex items-center gap-2 sm:gap-3 shrink-0">
        <div className="hidden sm:flex items-center gap-2 px-3 py-1.5 rounded-full bg-white/[0.04] border border-white/[0.06]">
          <span className="w-1.5 h-1.5 rounded-full bg-green-400 animate-pulse shrink-0" />
          <span className="text-body-xs text-blanco-roto/40 capitalize">{rol}</span>
        </div>

        {habilitado && (
          <Link
            to="/admin/conversaciones"
            className="relative w-9 h-9 rounded-full border border-white/10 bg-white/[0.04] flex items-center justify-center text-blanco-roto/70 hover:text-dorado hover:border-dorado/40 transition-all"
            aria-label="Conversaciones"
          >
            <MessageCircle size={17} />
            {noLeidos > 0 && (
              <span className="absolute -top-1 -right-1 min-w-4 h-4 px-1 rounded-full bg-dorado text-negro-absoluto text-[0.6rem] font-bold flex items-center justify-center leading-none">
                {noLeidos > 99 ? '99+' : noLeidos}
              </span>
            )}
          </Link>
        )}

        <div className="w-8 h-8 rounded-full bg-gradient-to-br from-dorado/30 to-dorado/10 border border-dorado/30 flex items-center justify-center">
          <span className="text-body-xs font-black text-dorado">{inicial}</span>
        </div>
      </div>
    </header>
  )
}
