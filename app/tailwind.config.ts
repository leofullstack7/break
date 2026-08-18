import type { Config } from 'tailwindcss'

const config: Config = {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  darkMode: 'class', // dark mode via clase — el default es dark en Break
  theme: {
    extend: {
      // ── PALETA SAGRADA DE BREAK ──────────────────────────────
      colors: {
        // Negros
        'negro-absoluto':  '#0a0a0a',  // heroes, máximo impacto
        'negro-profundo':  '#1a1a1a',  // fondo principal de la app
        'gris-carbon':     '#3d3d3d',  // superficies elevadas, texto secundario

        // Cálidos
        'beige-calido':    '#f5f0e8',  // contraste suave, calidez
        'blanco-roto':     '#fafaf8',  // texto sobre fondos oscuros
        'dorado':          '#c9a84c',  // acento premium — nunca dominante

        // Estados (panel admin)
        'estado-disponible':   '#2d6a4f',  // verde oscuro elegante
        'estado-ocupada':      '#8b2635',  // rojo terroso
        'estado-aseo':         '#b7791f',  // ámbar cálido
        'estado-mantenimiento':'#4a5568',  // gris neutro
      },

      // ── TIPOGRAFÍA ───────────────────────────────────────────
      fontFamily: {
        display: ['Clash Display', 'Cabinet Grotesk', 'sans-serif'],
        body:    ['Plus Jakarta Sans', 'sans-serif'],
        mono:    ['JetBrains Mono', 'monospace'],
      },

      // ── ESCALA TIPOGRÁFICA ───────────────────────────────────
      fontSize: {
        'display-2xl': ['4.5rem',  { lineHeight: '1.1' }],  // 72px — hero landing
        'display-xl':  ['3.5rem',  { lineHeight: '1.15' }], // 56px — títulos hero
        'display-lg':  ['2.625rem',{ lineHeight: '1.2' }],  // 42px — títulos de página
        'display-md':  ['2rem',    { lineHeight: '1.25' }], // 32px — títulos sección
        'display-sm':  ['1.5rem',  { lineHeight: '1.3' }],  // 24px — subtítulos
        'body-xl':     ['1.25rem', { lineHeight: '1.6' }],  // 20px — párrafos destacados
        'body-lg':     ['1.125rem',{ lineHeight: '1.6' }],  // 18px — cuerpo principal
        'body-md':     ['1rem',    { lineHeight: '1.5' }],  // 16px — UI estándar
        'body-sm':     ['0.875rem',{ lineHeight: '1.5' }],  // 14px — texto secundario
        'body-xs':     ['0.75rem', { lineHeight: '1.4' }],  // 12px — metadatos
        'mono-lg':     ['1.25rem', { lineHeight: '1.2' }],  // 20px — precios
        'mono-md':     ['1rem',    { lineHeight: '1.2' }],  // 16px — fechas, códigos
        'mono-sm':     ['0.8125rem',{ lineHeight: '1.2' }], // 13px — métricas
      },

      // ── ESPACIADO (múltiplos de 4px) ─────────────────────────
      spacing: {
        '18': '4.5rem',   // 72px
        '22': '5.5rem',   // 88px
        '30': '7.5rem',   // 120px — separación entre secciones hero
      },

      // ── SOMBRAS CON DORADO ───────────────────────────────────
      boxShadow: {
        'dorado-sm': '0 4px 16px rgba(201, 168, 76, 0.10)',
        'dorado':    '0 8px 32px rgba(201, 168, 76, 0.15)',
        'dorado-lg': '0 16px 64px rgba(201, 168, 76, 0.20)',
        'glow':      '0 0 20px rgba(201, 168, 76, 0.30)',
      },

      // ── RADIOS DE BORDE ──────────────────────────────────────
      borderRadius: {
        'xl':  '0.75rem',   // 12px — cards normales
        '2xl': '1rem',      // 16px — cards glassmorphism
        '3xl': '1.5rem',    // 24px — modales, secciones grandes
      },

      // ── BACKDROP BLUR ────────────────────────────────────────
      backdropBlur: {
        'xs': '2px',
        'md': '12px',  // glassmorphism cards
        'xl': '24px',  // modales
      },

      // ── ANIMACIONES CSS ──────────────────────────────────────
      keyframes: {
        shimmer: {
          '0%':   { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition:  '200% 0' },
        },
        'fade-in': {
          '0%':   { opacity: '0' },
          '100%': { opacity: '1' },
        },
        'slide-up': {
          '0%':   { opacity: '0', transform: 'translateY(20px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        pulse: {
          '0%, 100%': { opacity: '1' },
          '50%':      { opacity: '0.4' },
        },
      },
      animation: {
        shimmer:   'shimmer 1.5s linear infinite',
        'fade-in': 'fade-in 0.4s ease-out forwards',
        'slide-up':'slide-up 0.4s ease-out forwards',
        pulse:     'pulse 2s ease-in-out infinite',
      },
    },
  },
  plugins: [],
}

export default config
