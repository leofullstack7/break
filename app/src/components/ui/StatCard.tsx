import type { LucideIcon } from 'lucide-react'
import { TrendingUp, TrendingDown } from 'lucide-react'

interface StatCardProps {
  label: string
  value: string | number
  sub?: string
  accent?: boolean
  icon?: LucideIcon
  trend?: { value: number; label?: string }
}

export function StatCard({ label, value, sub, accent = false, icon: Icon, trend }: StatCardProps) {
  const trendPositive = trend && trend.value >= 0

  return (
    <div className={`relative glass rounded-2xl p-5 overflow-hidden group transition-all duration-300 hover:shadow-dorado-sm ${
      accent ? 'border-l-2 border-l-dorado' : ''
    }`}>

      {/* Fondo sutil con gradiente cuando es accent */}
      {accent && (
        <div className="absolute inset-0 bg-gradient-to-br from-dorado/5 to-transparent pointer-events-none" />
      )}

      {/* Icono */}
      {Icon && (
        <div className={`absolute top-4 right-4 w-8 h-8 rounded-xl flex items-center justify-center transition-colors ${
          accent
            ? 'bg-dorado/15 text-dorado'
            : 'bg-white/5 text-blanco-roto/30 group-hover:text-blanco-roto/50'
        }`}>
          <Icon size={15} strokeWidth={1.75} />
        </div>
      )}

      <div className="relative space-y-1">
        <p className="text-body-xs uppercase tracking-wider text-blanco-roto/40 font-medium pr-10">
          {label}
        </p>
        <p className={`font-mono font-black leading-none ${
          accent ? 'text-dorado' : 'text-blanco-roto'
        }`} style={{ fontSize: '1.75rem' }}>
          {value}
        </p>

        {/* Sub y trend en la misma línea */}
        <div className="flex items-center justify-between pt-0.5">
          {sub && (
            <p className="text-body-xs text-blanco-roto/35">{sub}</p>
          )}
          {trend && (
            <div className={`flex items-center gap-0.5 text-body-xs font-semibold ml-auto ${
              trendPositive ? 'text-green-400' : 'text-red-400'
            }`}>
              {trendPositive
                ? <TrendingUp size={11} />
                : <TrendingDown size={11} />
              }
              {trend.value > 0 ? '+' : ''}{trend.value}%
              {trend.label && (
                <span className="text-blanco-roto/20 font-normal ml-1">{trend.label}</span>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
