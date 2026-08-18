# Dependencias de Animación — Break Digital
## Guía de instalación, configuración y tokens globales

**Documento de referencia para:** Ariel (antes de configurar el proyecto) y Sage (antes de proponer cualquier animación)  
**Mantenido por:** Ariel  
**Última actualización:** al configurar el proyecto inicial

---

## ÍNDICE

1. [Arsenal de animación del proyecto](#1-arsenal-de-animación-del-proyecto)
2. [Instalación](#2-instalación)
3. [Configuración inicial por librería](#3-configuración-inicial-por-librería)
4. [Tokens de animación globales](#4-tokens-de-animación-globales)
5. [Reglas de performance](#5-reglas-de-performance)
6. [Cuándo usar cada librería](#6-cuándo-usar-cada-librería)

---

## 1. ARSENAL DE ANIMACIÓN DEL PROYECTO

| Librería | Versión | Propósito | Instalación |
|---|---|---|---|
| **Framer Motion** | latest | Animaciones de componentes React, transiciones de página, gestos | npm |
| **Three.js + R3F** | latest | Fondos 3D, partículas, efectos volumétricos en heroes | npm |
| **Lottie (React)** | latest | Animaciones vectoriales exportadas de After Effects / LottieFiles | npm |
| **CSS Animations** | nativo | Micro-interacciones, shimmer, loops simples, hover | — nativo del navegador |
| **Aura.js** | latest | Animaciones de scroll, reveal al entrar al viewport | CDN o módulo ES |

---

## 2. INSTALACIÓN

### Comando único — ejecutar una sola vez al iniciar el proyecto

```bash
# Instalar el arsenal completo de animación
npm install framer-motion @lottiefiles/react-lottie-player three @types/three @react-three/fiber @react-three/drei
```

### Desglose por paquete

```bash
# Animaciones de componentes React y transiciones de página
npm install framer-motion

# Motor 3D (Three.js) con su wrapper para React
npm install three @types/three
npm install @react-three/fiber @react-three/drei

# Animaciones Lottie (archivos .json exportados de After Effects / LottieFiles)
npm install @lottiefiles/react-lottie-player
```

### CSS Animations — no requiere instalación

CSS Animations es nativo del navegador. Se configura directamente en `src/styles/animations.css` o como clases de Tailwind con el plugin de animaciones. No hay paquete que instalar.

```css
/* Ejemplo directo en CSS — sin dependencia externa */
@keyframes shimmer {
  0%   { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}
```

### Aura.js — CDN o módulo ES

**Opción A — CDN en `index.html`** (recomendada para simplicidad):
```html
<!-- En public/index.html, antes del cierre de </body> -->
<script src="https://unpkg.com/aura.js@latest/dist/aura.min.js"></script>
```

**Opción B — Módulo ES** (recomendada si se necesita tree-shaking):
```bash
npm install aura.js
```
```typescript
// En src/main.tsx
import Aura from 'aura.js'
```

---

## 3. CONFIGURACIÓN INICIAL POR LIBRERÍA

### 3.1 Framer Motion — AnimatePresence con React Router v6

Configurar en `src/main.tsx` o en el componente raíz del router. `AnimatePresence` debe envolver el outlet de las rutas para que las animaciones de salida funcionen correctamente.

```tsx
// src/main.tsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import { AnimatePresence } from 'framer-motion'
import App from './App'
import './styles/index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <BrowserRouter>
      {/* mode="wait" espera a que la salida termine antes de animar la entrada */}
      <AnimatePresence mode="wait">
        <App />
      </AnimatePresence>
    </BrowserRouter>
  </React.StrictMode>
)
```

```tsx
// src/App.tsx — el router debe leer la location para que AnimatePresence funcione
import { Routes, Route, useLocation } from 'react-router-dom'
import { AnimatePresence } from 'framer-motion'
import { PageTransition } from '@/components/ui/PageTransition'

// Importar páginas (con lazy loading)
import Landing from '@/pages/Landing'
import Habitaciones from '@/pages/Habitaciones'
import Reservar from '@/pages/Reservar'

export default function App() {
  const location = useLocation()

  return (
    // key={location.pathname} es lo que dispara la animación de salida/entrada
    <AnimatePresence mode="wait">
      <Routes location={location} key={location.pathname}>
        <Route path="/" element={<PageTransition><Landing /></PageTransition>} />
        <Route path="/habitaciones" element={<PageTransition><Habitaciones /></PageTransition>} />
        <Route path="/reservar" element={<PageTransition><Reservar /></PageTransition>} />
      </Routes>
    </AnimatePresence>
  )
}
```

```tsx
// src/components/ui/PageTransition.tsx
// Componente wrapper reutilizable para todas las transiciones de página
import { motion } from 'framer-motion'
import { pageTransition } from '@/styles/animations'

interface PageTransitionProps {
  children: React.ReactNode
}

export function PageTransition({ children }: PageTransitionProps) {
  return (
    <motion.div
      initial={pageTransition.initial}
      animate={pageTransition.animate}
      exit={pageTransition.exit}
      style={{ width: '100%' }}
    >
      {children}
    </motion.div>
  )
}
```

---

### 3.2 Three.js con React Three Fiber — canvas base con lazy loading

**Principio de performance:** Three.js NO debe cargarse en móviles de baja gama ni en conexiones lentas. Se detecta el dispositivo antes de renderizar el canvas 3D.

```tsx
// src/components/3d/Scene3D.tsx
// Componente base para cualquier escena 3D del proyecto
import React, { Suspense } from 'react'
import { Canvas } from '@react-three/fiber'
import { useDeviceCapability } from '@/hooks/useDeviceCapability'

interface Scene3DProps {
  children: React.ReactNode
  // Altura del canvas — default: pantalla completa
  height?: string
  // Clase CSS adicional para el contenedor
  className?: string
}

export function Scene3D({ children, height = '100vh', className = '' }: Scene3DProps) {
  const { canRender3D } = useDeviceCapability()

  // Si el dispositivo no puede renderizar 3D, retornar null
  // El componente padre debe tener un fallback visual en CSS
  if (!canRender3D) return null

  return (
    <div style={{ height }} className={className}>
      <Canvas
        // Reducir pixel ratio en móvil para mejor performance
        dpr={[1, 2]}
        // Fondo transparente — el color de fondo viene del CSS
        gl={{ alpha: true, antialias: true }}
        // Cámara por defecto para la mayoría de escenas Break
        camera={{ position: [0, 0, 5], fov: 45 }}
      >
        {/* Suspense es obligatorio para cualquier asset que se cargue async */}
        <Suspense fallback={null}>
          {children}
        </Suspense>
      </Canvas>
    </div>
  )
}
```

```typescript
// src/hooks/useDeviceCapability.ts
// Hook que detecta si el dispositivo puede manejar animaciones 3D complejas
export function useDeviceCapability() {
  const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i
    .test(navigator.userAgent)

  // Detectar conexión lenta (API de Network Information)
  const connection = (navigator as Navigator & {
    connection?: { effectiveType: string }
  }).connection

  const isSlowConnection = connection
    ? ['slow-2g', '2g', '3g'].includes(connection.effectiveType)
    : false

  // Detectar memoria RAM limitada (API de Device Memory)
  const deviceMemory = (navigator as Navigator & { deviceMemory?: number }).deviceMemory
  const isLowMemory = deviceMemory !== undefined && deviceMemory < 4

  // Solo renderizar 3D en desktop o móviles de alta gama con buena conexión
  const canRender3D = !isMobile || (!isSlowConnection && !isLowMemory)

  return {
    isMobile,
    isSlowConnection,
    isLowMemory,
    canRender3D,
  }
}
```

```tsx
// src/pages/Landing.tsx — ejemplo de uso con fallback CSS
import React, { lazy, Suspense } from 'react'
import { useDeviceCapability } from '@/hooks/useDeviceCapability'

// Lazy import de Three.js — NO se carga hasta que se necesita
const ParticleBackground = lazy(() =>
  import('@/components/3d/ParticleBackground').then(m => ({ default: m.ParticleBackground }))
)

export default function Landing() {
  const { canRender3D } = useDeviceCapability()

  return (
    <section className="relative min-h-screen bg-negro-absoluto">

      {/* Fondo: 3D en desktop, gradient CSS en móvil */}
      {canRender3D ? (
        <Suspense fallback={<div className="absolute inset-0 bg-negro-absoluto" />}>
          <div className="absolute inset-0">
            <ParticleBackground />
          </div>
        </Suspense>
      ) : (
        // Fallback para móvil: gradiente CSS que no consume GPU
        <div className="absolute inset-0 bg-gradient-to-b from-negro-absoluto to-negro-profundo" />
      )}

      {/* Contenido sobre el fondo */}
      <div className="relative z-10">
        {/* ... */}
      </div>

    </section>
  )
}
```

---

### 3.3 Lottie — componente base reutilizable

```tsx
// src/components/ui/LottieAnimation.tsx
// Componente base para todas las animaciones Lottie del proyecto
import { Player } from '@lottiefiles/react-lottie-player'
import { useRef } from 'react'

interface LottieAnimationProps {
  // Ruta al archivo .json — debe estar en /public/lottie/
  src: string
  // Reproducción automática al montar el componente
  autoplay?: boolean
  // Si la animación se repite indefinidamente
  loop?: boolean
  // Velocidad de reproducción (1 = normal, 2 = doble velocidad)
  speed?: number
  // Dimensiones del contenedor
  width?: number | string
  height?: number | string
  // Clase CSS adicional
  className?: string
  // Callback cuando la animación termina (útil para loop: false)
  onComplete?: () => void
}

export function LottieAnimation({
  src,
  autoplay = true,
  loop = false,
  speed = 1,
  width = '100%',
  height = 'auto',
  className = '',
  onComplete,
}: LottieAnimationProps) {
  const playerRef = useRef<InstanceType<typeof Player>>(null)

  return (
    <Player
      ref={playerRef}
      src={src}
      autoplay={autoplay}
      loop={loop}
      speed={speed}
      style={{ width, height }}
      className={className}
      onEvent={event => {
        if (event === 'complete' && onComplete) {
          onComplete()
        }
      }}
    />
  )
}
```

```
// Estructura de carpetas para archivos Lottie
public/
└── lottie/
    ├── loading-break.json       ← shimmer/loader de la marca
    ├── check-success.json       ← confirmación de reserva exitosa
    ├── error-gentle.json        ← error elegante (sin rojo agresivo)
    ├── empty-state.json         ← pantalla vacía de habitaciones
    └── welcome-stars.json       ← bienvenida al huésped
```

```tsx
// Ejemplo de uso — estado de carga en el dashboard
import { LottieAnimation } from '@/components/ui/LottieAnimation'

function LoadingState() {
  return (
    <div className="flex items-center justify-center min-h-[200px]">
      <LottieAnimation
        src="/lottie/loading-break.json"
        autoplay
        loop
        width={80}
        height={80}
      />
    </div>
  )
}

// Ejemplo de uso — confirmación de reserva exitosa
function ReservaConfirmada() {
  return (
    <LottieAnimation
      src="/lottie/check-success.json"
      autoplay
      loop={false}
      speed={0.8}
      width={120}
      height={120}
      onComplete={() => console.log('animación terminó')}
    />
  )
}
```

---

### 3.4 Aura.js — inicialización en main.tsx

Aura.js maneja las animaciones de scroll (reveal al entrar al viewport). Se inicializa una vez en el punto de entrada de la app.

```tsx
// src/main.tsx — configuración completa con Aura.js
import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import { AnimatePresence } from 'framer-motion'
import App from './App'
import './styles/index.css'

// Importar Aura según la opción elegida (CDN o módulo)
// Opción módulo ES:
import Aura from 'aura.js'

// Inicializar Aura con las opciones del proyecto Break
Aura.init({
  // Porcentaje del elemento visible para disparar la animación
  // 0.1 = cuando el 10% del elemento es visible en el viewport
  threshold: 0.1,

  // Clase que Aura agrega cuando el elemento es visible
  // Se define la animación en CSS usando esta clase
  activeClass: 'aura-visible',

  // Si la animación se ejecuta solo una vez o cada vez que entra al viewport
  // "once" es mejor para performance — no hay que observar continuamente
  once: true,

  // Margen del viewport — negativo hace que la animación empiece
  // antes de que el elemento entre completamente
  rootMargin: '0px 0px -50px 0px',
})

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <BrowserRouter>
      <AnimatePresence mode="wait">
        <App />
      </AnimatePresence>
    </BrowserRouter>
  </React.StrictMode>
)
```

```css
/* src/styles/aura.css — animaciones de scroll con Aura.js */

/* Estado inicial: elemento invisible y desplazado */
[data-aura] {
  opacity: 0;
  transform: translateY(20px);
  transition:
    opacity 400ms ease-out,
    transform 400ms ease-out;
}

/* Estado visible: Aura agrega .aura-visible cuando el elemento entra al viewport */
[data-aura].aura-visible {
  opacity: 1;
  transform: translateY(0);
}

/* Variante con delay escalonado para listas y grids */
[data-aura][data-aura-delay="1"] { transition-delay: 50ms; }
[data-aura][data-aura-delay="2"] { transition-delay: 100ms; }
[data-aura][data-aura-delay="3"] { transition-delay: 150ms; }
[data-aura][data-aura-delay="4"] { transition-delay: 200ms; }
[data-aura][data-aura-delay="5"] { transition-delay: 250ms; }
[data-aura][data-aura-delay="6"] { transition-delay: 300ms; }

/* Variante de solo fade (sin movimiento) — para elementos que ya tienen posición fija */
[data-aura="fade"] {
  opacity: 0;
  transform: none;
  transition: opacity 500ms ease-out;
}
[data-aura="fade"].aura-visible {
  opacity: 1;
}

/* Variante de entrada desde la izquierda */
[data-aura="slide-left"] {
  opacity: 0;
  transform: translateX(-30px);
  transition: opacity 400ms ease-out, transform 400ms ease-out;
}
[data-aura="slide-left"].aura-visible {
  opacity: 1;
  transform: translateX(0);
}
```

```tsx
// Ejemplo de uso en JSX
function SeccionValor() {
  return (
    <section>
      <h2 data-aura>La pausa que también es estrategia</h2>

      <div className="grid grid-cols-3 gap-6">
        {/* delay escalonado para cada card del grid */}
        <div data-aura data-aura-delay="1">Card 1</div>
        <div data-aura data-aura-delay="2">Card 2</div>
        <div data-aura data-aura-delay="3">Card 3</div>
      </div>

      {/* Solo fade, sin movimiento vertical */}
      <p data-aura="fade">Texto que aparece suavemente</p>
    </section>
  )
}
```

---

## 4. TOKENS DE ANIMACIÓN GLOBALES

Todos los agentes que crean animaciones deben importar los tokens desde este archivo. **Nunca usar valores hardcoded de duración o easing.**

```typescript
// src/styles/animations.ts
// Tokens de animación globales del proyecto Break Digital
// Importar desde aquí — nunca hardcodear valores de duración o easing

import { Variants, Transition } from 'framer-motion'

// ─── DURACIONES ────────────────────────────────────────────────────────────────

export const duration = {
  /** 150ms — hover, focus, micro-interacciones imperceptibles */
  fast: 0.15,
  /** 300ms — la mayoría de transiciones de UI */
  normal: 0.3,
  /** 500ms — entradas de elementos, modales */
  slow: 0.5,
  /** 800ms — heroes, reveals cinematográficos */
  cinematic: 0.8,
} as const

/** Versiones en milisegundos para CSS y Aura.js */
export const durationMs = {
  fast: 150,
  normal: 300,
  slow: 500,
  cinematic: 800,
} as const

// ─── EASINGS ───────────────────────────────────────────────────────────────────

/** Easings para Framer Motion */
export const easing = {
  /** Salida suave — para la mayoría de entradas de elementos */
  easeOut: [0.0, 0.0, 0.2, 1.0],
  /** Entrada y salida — para elementos que se mueven de un estado a otro */
  easeInOut: [0.4, 0.0, 0.2, 1.0],
  /** Sin aceleración — para loops como shimmer o rotaciones */
  linear: [0.0, 0.0, 1.0, 1.0],
} as const

/** Easings como strings CSS para usar con Tailwind o CSS puro */
export const easingCss = {
  easeOut: 'cubic-bezier(0.0, 0.0, 0.2, 1.0)',
  easeInOut: 'cubic-bezier(0.4, 0.0, 0.2, 1.0)',
  linear: 'linear',
} as const

/** Configuración de spring para Framer Motion — rebote natural, no mecánico */
export const spring: Transition = {
  type: 'spring',
  stiffness: 300,
  damping: 30,
  mass: 1,
}

/** Spring suave — para modales y elementos grandes */
export const springGentle: Transition = {
  type: 'spring',
  stiffness: 200,
  damping: 25,
  mass: 1.2,
}

// ─── DELAYS DE STAGGER ─────────────────────────────────────────────────────────

/** Delays para animar elementos de una lista o grid en secuencia */
export const stagger = {
  /** Entre ítems de una lista — 50ms */
  list: 0.05,
  /** Entre secciones de una página — 100ms */
  section: 0.1,
  /** Entre letras en animación de texto — 30ms */
  letter: 0.03,
  /** Entre palabras en animación de texto — 80ms */
  word: 0.08,
} as const

// ─── VARIANTES DE FRAMER MOTION — REUTILIZABLES ────────────────────────────────

/**
 * Entrada estándar de elementos (fade + slide up 20px)
 * Uso: <motion.div variants={fadeSlideUp} initial="hidden" animate="visible">
 */
export const fadeSlideUp: Variants = {
  hidden: {
    opacity: 0,
    y: 20,
  },
  visible: {
    opacity: 1,
    y: 0,
    transition: {
      duration: duration.slow,
      ease: easing.easeOut,
    },
  },
}

/**
 * Contenedor con stagger para listas y grids
 * Uso: envolver la lista con este variant y cada ítem con fadeSlideUp
 */
export const staggerContainer: Variants = {
  hidden: {},
  visible: {
    transition: {
      staggerChildren: stagger.list,
      delayChildren: 0.1,
    },
  },
}

/**
 * Stagger para secciones — delay mayor entre secciones de página
 */
export const staggerSections: Variants = {
  hidden: {},
  visible: {
    transition: {
      staggerChildren: stagger.section,
    },
  },
}

/**
 * Hover en cards — escala sutil + sombra dorada
 * Uso: <motion.div variants={cardHover} initial="rest" whileHover="hover">
 */
export const cardHover: Variants = {
  rest: {
    scale: 1,
    boxShadow: '0 0 0 rgba(201, 168, 76, 0)',
    transition: { duration: duration.fast },
  },
  hover: {
    scale: 1.02,
    boxShadow: '0 8px 32px rgba(201, 168, 76, 0.15)',
    transition: { duration: duration.fast, ease: easing.easeOut },
  },
}

/**
 * Animación de texto letra por letra — para heroes
 * Uso: map sobre las letras con custom={index}
 */
export const letterReveal: Variants = {
  hidden: {
    opacity: 0,
    y: 40,
  },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: {
      delay: i * stagger.letter,
      duration: duration.slow,
      ease: easing.easeOut,
    },
  }),
}

/**
 * Animación de texto palabra por palabra — alternativa a letterReveal
 */
export const wordReveal: Variants = {
  hidden: {
    opacity: 0,
    y: 20,
  },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: {
      delay: i * stagger.word,
      duration: duration.normal,
      ease: easing.easeOut,
    },
  }),
}

/**
 * Transición de página — fade + blur
 * Aplicar en el componente PageTransition
 */
export const pageTransition = {
  initial: {
    opacity: 0,
    filter: 'blur(4px)',
  },
  animate: {
    opacity: 1,
    filter: 'blur(0px)',
    transition: {
      duration: duration.normal,
      ease: easing.easeOut,
    },
  },
  exit: {
    opacity: 0,
    filter: 'blur(2px)',
    transition: {
      duration: duration.fast,
      ease: easing.easeOut,
    },
  },
}

/**
 * Modal — aparece desde escala 0.95 con spring
 * Uso: initial="hidden" animate="visible" exit="hidden"
 */
export const modalVariants: Variants = {
  hidden: {
    opacity: 0,
    scale: 0.95,
    y: 8,
  },
  visible: {
    opacity: 1,
    scale: 1,
    y: 0,
    transition: spring,
  },
}

/**
 * Overlay de modal — fade simple
 */
export const overlayVariants: Variants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: { duration: duration.normal },
  },
}

// ─── UMBRALES DE SCROLL PARA AURA.JS ──────────────────────────────────────────

/** Configuración de umbrales de scroll para Aura.js */
export const auraConfig = {
  /**
   * Umbral por defecto — 0.1 = animar cuando el 10% del elemento es visible
   * Adecuado para la mayoría de elementos en la landing
   */
  threshold: 0.1,

  /**
   * Umbral para elementos grandes (heroes, secciones full-screen)
   * 0.05 = animar cuando solo el 5% es visible — se activa antes
   */
  thresholdLarge: 0.05,

  /**
   * Umbral para elementos pequeños (badges, íconos)
   * 0.2 = más del elemento debe ser visible antes de animar
   */
  thresholdSmall: 0.2,

  /**
   * Margen del viewport — el elemento empieza a animarse
   * 50px antes de entrar completamente al viewport
   */
  rootMargin: '0px 0px -50px 0px',
} as const
```

---

## 5. REGLAS DE PERFORMANCE

Estas reglas no son opcionales. Un hotel que proyecta calidad no puede tener una app con animaciones que traban.

### Regla 1 — `will-change` solo donde se necesita

```css
/* ✅ CORRECTO — solo en el elemento que realmente se animará */
.card-habitacion {
  will-change: transform;
}

/* ❌ INCORRECTO — aplicar globalmente destruye el performance */
* {
  will-change: transform; /* nunca hacer esto */
}

/* ❌ INCORRECTO — después de la animación, remover will-change */
.card-habitacion:not(:hover) {
  will-change: auto; /* liberar recursos cuando no se usa */
}
```

### Regla 2 — Solo `transform` y `opacity` en animaciones CSS

El navegador puede animar `transform` y `opacity` en el hilo del compositor (GPU) sin reflow. Cualquier otra propiedad animada puede causar layout thrashing.

```css
/* ✅ PROPIEDADES SEGURAS — no causan reflow */
.elemento {
  transition: transform 300ms ease-out, opacity 300ms ease-out;
}

/* ❌ PROPIEDADES PROHIBIDAS en animaciones — causan reflow */
.elemento {
  transition:
    width 300ms,      /* reflow */
    height 300ms,     /* reflow */
    top 300ms,        /* reflow */
    left 300ms,       /* reflow */
    margin 300ms,     /* reflow */
    padding 300ms;    /* reflow */
}

/* ✅ ALTERNATIVA — usar transform en lugar de top/left */
.elemento-que-se-mueve {
  /* en lugar de top: 20px, usar: */
  transform: translateY(20px);
}
```

### Regla 3 — `requestAnimationFrame` para JavaScript manual

Si por alguna razón hay que animar con JavaScript puro (no Framer Motion), usar siempre `requestAnimationFrame`.

```typescript
// ✅ CORRECTO — sincronizado con el ciclo de repintado del browser
function animateManual(element: HTMLElement, targetOpacity: number) {
  let currentOpacity = 0

  function step() {
    currentOpacity += 0.02
    element.style.opacity = String(currentOpacity)

    if (currentOpacity < targetOpacity) {
      requestAnimationFrame(step) // siguiente frame
    }
  }

  requestAnimationFrame(step) // iniciar
}

// ❌ INCORRECTO — setInterval no está sincronizado con el browser
function animateWrong(element: HTMLElement) {
  const interval = setInterval(() => {
    // esto puede ejecutarse en momentos incorrectos del ciclo de render
    element.style.opacity = String(parseFloat(element.style.opacity) + 0.02)
  }, 16) // nunca hacer esto
}
```

### Regla 4 — Intersection Observer para activar animaciones al scroll

Para animaciones que se activan al entrar al viewport (si NO se usa Aura.js), usar Intersection Observer nativo. Nunca calcular posición de scroll con `window.scrollY` en un event listener.

```typescript
// src/hooks/useScrollReveal.ts
// Hook para activar animaciones cuando un elemento entra al viewport
import { useEffect, useRef } from 'react'

interface UseScrollRevealOptions {
  threshold?: number
  rootMargin?: string
  once?: boolean
}

export function useScrollReveal({
  threshold = 0.1,
  rootMargin = '0px 0px -50px 0px',
  once = true,
}: UseScrollRevealOptions = {}) {
  const elementRef = useRef<HTMLElement>(null)

  useEffect(() => {
    const element = elementRef.current
    if (!element) return

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible')
          if (once) {
            observer.unobserve(entry.target) // dejar de observar si es once
          }
        } else if (!once) {
          entry.target.classList.remove('is-visible')
        }
      },
      { threshold, rootMargin }
    )

    observer.observe(element)
    return () => observer.disconnect()
  }, [threshold, rootMargin, once])

  return elementRef
}

// Uso:
// const ref = useScrollReveal()
// <section ref={ref as React.RefObject<HTMLElement>} className="fade-on-scroll">
```

```css
/* CSS complementario para useScrollReveal */
.fade-on-scroll {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 400ms ease-out, transform 400ms ease-out;
}
.fade-on-scroll.is-visible {
  opacity: 1;
  transform: translateY(0);
}
```

### Regla 5 — Lazy loading obligatorio para Three.js

Three.js pesa varios cientos de KB. **Nunca importarlo de forma estática** si no es necesario en el primer render.

```tsx
// ✅ CORRECTO — import dinámico, Three.js solo se descarga si se necesita
const HeroBackground3D = lazy(() =>
  import('@/components/3d/HeroBackground3D').then(m => ({
    default: m.HeroBackground3D
  }))
)

// Siempre con Suspense y fallback visible
function HeroSection() {
  return (
    <div className="relative h-screen">
      <Suspense fallback={
        // Fallback: fondo CSS que se ve mientras Three.js carga
        <div className="absolute inset-0 bg-gradient-to-b from-negro-absoluto to-negro-profundo" />
      }>
        <HeroBackground3D />
      </Suspense>
    </div>
  )
}

// ❌ INCORRECTO — import estático, Three.js bloquea la carga inicial
import { HeroBackground3D } from '@/components/3d/HeroBackground3D' // nunca así
```

### Regla 6 — Reducir movimiento si el usuario lo prefiere

Respetar la preferencia del sistema operativo del usuario.

```css
/* En src/styles/index.css — aplicar globalmente */
@media (prefers-reduced-motion: reduce) {
  /* Desactivar todas las animaciones CSS */
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

```typescript
// Hook para respetar la preferencia en Framer Motion
// src/hooks/usePrefersReducedMotion.ts
import { useEffect, useState } from 'react'

export function usePrefersReducedMotion(): boolean {
  const [prefersReduced, setPrefersReduced] = useState(
    window.matchMedia('(prefers-reduced-motion: reduce)').matches
  )

  useEffect(() => {
    const mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)')
    const handler = (e: MediaQueryListEvent) => setPrefersReduced(e.matches)
    mediaQuery.addEventListener('change', handler)
    return () => mediaQuery.removeEventListener('change', handler)
  }, [])

  return prefersReduced
}

// Uso en componentes con Framer Motion:
// const prefersReduced = usePrefersReducedMotion()
// <motion.div animate={prefersReduced ? {} : { y: 0, opacity: 1 }}>
```

---

## 6. CUÁNDO USAR CADA LIBRERÍA

Guía de decisión rápida para Sage y Ariel.

| Situación | Librería recomendada | Por qué |
|---|---|---|
| Hover en cards, botones, inputs | **CSS (Tailwind)** | Más rápido, sin overhead de JS |
| Shimmer / skeleton de carga | **CSS Animations** | Loop infinito — CSS es más eficiente |
| Transición entre páginas | **Framer Motion** | AnimatePresence maneja el unmount |
| Modal que aparece/desaparece | **Framer Motion** | Spring natural, maneja exit animation |
| Lista de items que entran con stagger | **Framer Motion** | `staggerChildren` es la solución nativa |
| Texto que aparece letra por letra | **Framer Motion** | `custom` prop + variantes por índice |
| Elementos que aparecen al hacer scroll | **Aura.js** | Intersection Observer sin boilerplate |
| Loading con personalidad de marca | **Lottie** | Archivos .json de After Effects / LottieFiles |
| Estado vacío con carácter | **Lottie** | Más expresivo que un ícono estático |
| Fondo de partículas en hero (desktop) | **Three.js + R3F** | Requiere GPU — solo en desktop capaz |
| Efecto de profundidad o volumétrico | **Three.js + R3F** | No hay alternativa en CSS/Framer |
| Animación de un gráfico de ocupación | **Framer Motion** | `animate` prop sobre valores numéricos |
| Parallax sutil en imagen hero | **CSS (`transform`)** | Intersection Observer + CSS — sin librería |
| Gestos táctiles (swipe en móvil) | **Framer Motion** | `drag`, `dragConstraints`, `onDragEnd` |

### Jerarquía de decisión

```
¿Se puede resolver con CSS nativo?
  SÍ → usar CSS (Tailwind o animations.css)
  NO ↓

¿Necesita reaccionar al scroll para aparecer?
  SÍ → usar Aura.js
  NO ↓

¿Es una animación de componente React (enter/exit, estado, gesto)?
  SÍ → usar Framer Motion
  NO ↓

¿Es un loader o ilustración animada de marca?
  SÍ → usar Lottie
  NO ↓

¿Necesita 3D, partículas o WebGL?
  SÍ → usar Three.js (solo en desktop capaz, con lazy loading obligatorio)
  NO → revisar si realmente necesita animación
```

---

*Documento creado por Ariel. Cualquier modificación debe pasar por Ariel y ser revisada por Sage.*  
*Las reglas de performance son competencia compartida de Ariel y Cipher.*
