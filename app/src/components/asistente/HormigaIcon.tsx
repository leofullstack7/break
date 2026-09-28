import { motion } from 'framer-motion'

interface Props {
  size?: number
  className?: string
  walking?: boolean
}

/** Hormiga Break — asistente de gerencia. */
export function HormigaIcon({ size = 28, className, walking = true }: Props) {
  return (
    <motion.svg
      width={size}
      height={size}
      viewBox="0 0 64 64"
      fill="none"
      className={className}
      aria-hidden
      animate={walking ? { y: [0, -2, 0] } : undefined}
      transition={{ duration: 1.4, repeat: Infinity, ease: 'easeInOut' }}
    >
      <ellipse cx="32" cy="44" rx="11" ry="9" fill="#C9A227" />
      <ellipse cx="32" cy="30" rx="9" ry="8" fill="#E8C547" />
      <circle cx="32" cy="16" r="7" fill="#C9A227" />
      <circle cx="29" cy="14" r="1.4" fill="#0a0a0a" />
      <circle cx="35" cy="14" r="1.4" fill="#0a0a0a" />
      <motion.path
        d="M26 11 Q18 2 14 6"
        stroke="#C9A227"
        strokeWidth="1.6"
        strokeLinecap="round"
        fill="none"
        animate={{ rotate: [-6, 8, -6] }}
        style={{ originX: '26px', originY: '11px' }}
        transition={{ duration: 1.1, repeat: Infinity }}
      />
      <motion.path
        d="M38 11 Q46 2 50 6"
        stroke="#C9A227"
        strokeWidth="1.6"
        strokeLinecap="round"
        fill="none"
        animate={{ rotate: [6, -8, 6] }}
        style={{ originX: '38px', originY: '11px' }}
        transition={{ duration: 1.1, repeat: Infinity }}
      />
      <motion.path
        d="M22 30 L10 24 M22 34 L8 36 M24 42 L12 50"
        stroke="#C9A227"
        strokeWidth="1.8"
        strokeLinecap="round"
        animate={{ x: [-1, 1, -1] }}
        transition={{ duration: 0.45, repeat: Infinity }}
      />
      <motion.path
        d="M42 30 L54 24 M42 34 L56 36 M40 42 L52 50"
        stroke="#C9A227"
        strokeWidth="1.8"
        strokeLinecap="round"
        animate={{ x: [1, -1, 1] }}
        transition={{ duration: 0.45, repeat: Infinity }}
      />
    </motion.svg>
  )
}

/** Chip técnico — asistente de IT, rama distinta a la hormiga. */
export function ChipTiIcon({ size = 28, className }: { size?: number; className?: string }) {
  return (
    <motion.svg
      width={size}
      height={size}
      viewBox="0 0 64 64"
      fill="none"
      className={className}
      aria-hidden
      animate={{ rotate: [0, 2, 0, -2, 0] }}
      transition={{ duration: 3.2, repeat: Infinity }}
    >
      <rect x="16" y="16" width="32" height="32" rx="6" fill="#1a1a1a" stroke="#C9A227" strokeWidth="2" />
      <rect x="24" y="24" width="16" height="16" rx="2" fill="#C9A227" opacity="0.85" />
      {[18, 28, 38, 46].map(y => (
        <g key={y}>
          <path d={`M16 ${y} H8`} stroke="#C9A227" strokeWidth="2" />
          <path d={`M48 ${y} H56`} stroke="#C9A227" strokeWidth="2" />
        </g>
      ))}
      {[18, 28, 38, 46].map(x => (
        <g key={`v${x}`}>
          <path d={`M${x} 16 V8`} stroke="#C9A227" strokeWidth="2" />
          <path d={`M${x} 48 V56`} stroke="#C9A227" strokeWidth="2" />
        </g>
      ))}
    </motion.svg>
  )
}
