interface BadgeProps {
  children: React.ReactNode
  variant?: 'disponible' | 'ocupada' | 'aseo' | 'mantenimiento' |
            'confirmada' | 'activa' | 'completada' | 'cancelada' | 'pendiente' |
            'hospedado' | 'libre' | 'checkout'
  className?: string
}

const ESTILOS: Record<string, string> = {
  disponible:  'bg-green-900/30  text-green-300  border-green-700/40',
  libre:       'bg-green-900/30  text-green-300  border-green-700/40',
  ocupada:     'bg-red-900/30    text-red-300    border-red-700/40',
  hospedado:   'bg-red-900/30    text-red-300    border-red-700/40',
  activa:      'bg-red-900/30    text-red-300    border-red-700/40',
  aseo:        'bg-amber-900/30  text-amber-300  border-amber-700/40',
  pendiente:   'bg-amber-900/30  text-amber-300  border-amber-700/40',
  checkout:    'bg-orange-900/30 text-orange-300 border-orange-700/40',
  mantenimiento:'bg-zinc-800/50  text-zinc-400   border-zinc-600/40',
  cancelada:   'bg-zinc-800/50   text-zinc-400   border-zinc-600/40',
  confirmada:  'bg-blue-900/30   text-blue-300   border-blue-700/40',
  completada:  'bg-zinc-800/40   text-zinc-400   border-zinc-600/30',
}

export function Badge({ children, variant = 'confirmada', className = '' }: BadgeProps) {
  const estilos = ESTILOS[variant] ?? ESTILOS.confirmada
  return (
    <span className={`inline-flex items-center px-2 py-0.5 rounded-md text-body-xs font-medium border ${estilos} ${className}`}>
      {children}
    </span>
  )
}
