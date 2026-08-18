import { useRef, useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { motion, useScroll, useTransform, useInView } from 'framer-motion'
import { ArrowRight, Leaf, Wifi, MapPin, Star, MessageCircle } from 'lucide-react'
import { useQuery } from '@tanstack/react-query'
import { supabase } from '@/lib/supabase'
import { PublicLayout } from '@/components/layout/PublicLayout'

// ── Fetch habitaciones destacadas (más caras = más altas = piso 4) ──
async function fetchHabitacionesDestacadas() {
  const { data } = await supabase
    .from('habitaciones')
    .select('id, numero, piso, precio_base, estado')
    .eq('estado', 'disponible')
    .order('precio_base', { ascending: false })
    .limit(3)
  return data ?? []
}

// ── Componente: reveal al hacer scroll ───────────────────────────────
function Reveal({ children, delay = 0, className = '' }: {
  children: React.ReactNode; delay?: number; className?: string
}) {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-80px' })
  return (
    <motion.div ref={ref} className={className}
      initial={{ opacity: 0, y: 32 }}
      animate={inView ? { opacity: 1, y: 0 } : {}}
      transition={{ duration: 0.6, ease: 'easeOut', delay }}>
      {children}
    </motion.div>
  )
}

// ── Gradientes por piso ───────────────────────────────────────────────
const PISO_GRADIENT: Record<number, string> = {
  1: 'from-zinc-900 to-stone-900',
  2: 'from-slate-900 to-zinc-900',
  3: 'from-neutral-900 to-zinc-800',
  4: 'from-stone-900 to-amber-950',
}

const PISO_ACCENT: Record<number, string> = {
  1: 'text-zinc-400', 2: 'text-slate-400', 3: 'text-neutral-400', 4: 'text-amber-400/80',
}

function formatPrecio(p: number) {
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', maximumFractionDigits: 0 }).format(p)
}

// ── Hero word-by-word reveal ─────────────────────────────────────────
const HERO_WORDS = ['La', 'pausa', 'también', 'es', 'estrategia.']

export default function Landing() {
  const heroRef = useRef(null)
  const { scrollYProgress } = useScroll({ target: heroRef, offset: ['start start', 'end start'] })
  const heroY       = useTransform(scrollYProgress, [0, 1], ['0%', '30%'])
  const heroOpacity = useTransform(scrollYProgress, [0, 0.7], [1, 0])

  const { data: habitaciones = [] } = useQuery({
    queryKey: ['hab-destacadas'],
    queryFn: fetchHabitacionesDestacadas,
    staleTime: 300_000,
  })

  return (
    <PublicLayout>

      {/* ── HERO — Banner full-width desde top 0, detrás del nav ── */}
      <section ref={heroRef} className="relative min-h-screen flex items-center justify-center overflow-hidden -mt-16">

        {/* Imagen banner — full width, parallax, zoom inicial */}
        <motion.div className="absolute inset-0" style={{ y: heroY }}>
          <div className="absolute inset-0 animate-hero-zoom origin-center">
            <img
              src="/banner.webp"
              alt="Break Hotel Manizales"
              className="w-full h-full object-cover object-center"
            />
          </div>
          {/* Overlay oscuro para legibilidad del texto */}
          <div className="absolute inset-0 bg-negro-absoluto/40" />
          {/* Gradiente inferior para fusión con el siguiente section */}
          <div className="absolute inset-x-0 bottom-0 h-48 bg-gradient-to-t from-negro-absoluto via-negro-absoluto/80 to-transparent" />
          {/* Viñeta superior sutil */}
          <div className="absolute inset-x-0 top-0 h-32 bg-gradient-to-b from-negro-absoluto/50 to-transparent" />
        </motion.div>

        {/* Luces flotantes decorativas */}
        <div className="absolute inset-0 pointer-events-none overflow-hidden">
          <div className="absolute top-1/4 left-1/4 w-96 h-96 rounded-full bg-dorado/[0.04] blur-[100px] animate-float-light" />
          <div className="absolute bottom-1/3 right-1/5 w-72 h-72 rounded-full bg-dorado/[0.03] blur-[80px] animate-float-light"
            style={{ animationDelay: '3s' }} />
        </div>

        {/* Contenido del hero */}
        <motion.div style={{ opacity: heroOpacity }}
          className="relative z-10 text-center px-6 max-w-4xl mx-auto pt-16">

          {/* Eyebrow con brillo */}
          <motion.div
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.3 }}
            className="flex items-center justify-center gap-4 mb-8">
            <span className="h-px w-0 bg-gradient-to-r from-transparent to-dorado/60 animate-line-expand" style={{ animationDelay: '0.8s' }} />
            <p className="text-body-xs text-dorado uppercase tracking-[0.3em] animate-text-glow">
              Break Hotel · Manizales · El Triángulo
            </p>
            <span className="h-px w-0 bg-gradient-to-l from-transparent to-dorado/60 animate-line-expand" style={{ animationDelay: '0.8s' }} />
          </motion.div>

          {/* Título palabra por palabra con efectos de luz */}
          <h1 className="font-display font-black text-blanco-roto mb-6 leading-tight"
            style={{ fontSize: 'clamp(3rem, 8vw, 5.5rem)' }}>
            {HERO_WORDS.map((word, i) => (
              <motion.span key={i}
                initial={{ opacity: 0, y: 40, filter: 'blur(8px)' }}
                animate={{ opacity: 1, y: 0, filter: 'blur(0px)' }}
                transition={{ duration: 0.6, delay: 0.5 + i * 0.12, ease: 'easeOut' }}
                className={`inline-block mr-[0.25em] ${
                  word === 'estrategia.'
                    ? 'text-shimmer animate-text-glow-strong'
                    : 'animate-text-glow'
                }`}>
                {word}
              </motion.span>
            ))}
          </h1>

          {/* Subtítulo con glow sutil */}
          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 1.1 }}
            className="text-body-lg text-blanco-roto/70 max-w-xl mx-auto leading-relaxed mb-10 drop-shadow-[0_0_20px_rgba(201,169,110,0.08)]">
            Apartaestudios boutique en el corazón de Manizales. Para quienes saben que descansar bien también es avanzar.
          </motion.p>

          {/* CTAs */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 1.4 }}
            className="flex items-center justify-center gap-4 flex-wrap">
            <Link to="/reservar"
              className="group flex items-center gap-2 px-8 py-4 bg-dorado text-negro-absoluto font-black text-body-md rounded-2xl hover:shadow-glow hover:scale-105 active:scale-95 transition-all duration-200 shadow-[0_0_30px_rgba(201,169,110,0.2)]">
              Elige tu pausa
              <ArrowRight size={18} className="group-hover:translate-x-1 transition-transform" />
            </Link>
            <Link to="/habitaciones"
              className="px-8 py-4 bg-negro-absoluto/40 backdrop-blur-md border border-white/20 text-blanco-roto font-semibold text-body-md rounded-2xl hover:border-dorado/40 hover:bg-dorado/5 transition-all duration-200">
              Ver habitaciones
            </Link>
          </motion.div>

          {/* Scroll indicator */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 2.2, duration: 1 }}
            className="absolute bottom-10 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2">
            <motion.div animate={{ y: [0, 8, 0] }} transition={{ duration: 1.5, repeat: Infinity, ease: 'easeInOut' }}
              className="w-px h-10 bg-gradient-to-b from-dorado/60 to-transparent"/>
          </motion.div>
        </motion.div>
      </section>

      {/* ── HABITACIONES DESTACADAS ── */}
      <section className="py-24 px-6 max-w-6xl mx-auto">
        <Reveal>
          <div className="text-center mb-14">
            <p className="text-body-xs text-dorado uppercase tracking-widest mb-3">Tu espacio en Manizales</p>
            <h2 className="font-display font-black text-display-lg text-blanco-roto">
              Cada habitación, un refugio
            </h2>
            <p className="text-body-md text-blanco-roto/50 mt-3 max-w-md mx-auto">
              24 estudios boutique diseñados para que el espacio trabaje contigo.
            </p>
          </div>
        </Reveal>

        {/* Grid de habitaciones */}
        {habitaciones.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {habitaciones.map((h: any, i) => (
              <Reveal key={h.id} delay={i * 0.12}>
                <Link to={`/reservar?habitacion=${h.id}`}
                  className="group block glass rounded-2xl overflow-hidden hover:border-dorado/30 border border-white/5 transition-all duration-300 hover:scale-[1.02] hover:shadow-dorado">

                  {/* Visual de habitación */}
                  <div className={`h-48 bg-gradient-to-br ${PISO_GRADIENT[h.piso] ?? 'from-zinc-900 to-stone-900'} relative overflow-hidden`}>
                    {/* Número grande decorativo */}
                    <div className={`absolute inset-0 flex items-center justify-center font-mono font-black opacity-10 ${PISO_ACCENT[h.piso]}`}
                      style={{ fontSize: '8rem' }}>
                      {h.numero}
                    </div>
                    {/* Info encima */}
                    <div className="absolute inset-0 flex flex-col justify-end p-5">
                      <p className="text-body-xs text-blanco-roto/40 uppercase tracking-widest">Piso {h.piso} · Apartaestudio</p>
                      <p className="font-mono font-black text-blanco-roto text-display-sm leading-none mt-1">{h.numero}</p>
                    </div>
                    {/* Estado disponible badge */}
                    <div className="absolute top-4 right-4">
                      <span className="text-body-xs font-semibold px-2.5 py-1 rounded-full bg-green-900/60 border border-green-700/50 text-green-300 backdrop-blur-sm">
                        Disponible
                      </span>
                    </div>
                  </div>

                  <div className="p-5">
                    <div className="flex items-end justify-between mb-3">
                      <div>
                        <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Desde</p>
                        <p className="font-mono font-bold text-mono-lg text-blanco-roto">{formatPrecio(h.precio_base)}</p>
                        <p className="text-body-xs text-blanco-roto/30">por noche</p>
                      </div>
                      <span className="text-body-sm text-dorado font-semibold group-hover:translate-x-1 transition-transform">
                        Reservar →
                      </span>
                    </div>
                    {/* Amenidades */}
                    <div className="flex gap-2 flex-wrap">
                      {['WiFi', 'Cocina', 'Smart TV', 'A/C'].map(a => (
                        <span key={a} className="text-body-xs px-2 py-0.5 rounded-md bg-white/5 text-blanco-roto/40">{a}</span>
                      ))}
                    </div>
                  </div>
                </Link>
              </Reveal>
            ))}
          </div>
        ) : (
          // Placeholders mientras carga
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {[4, 3, 2].map(piso => (
              <Reveal key={piso} delay={(4 - piso) * 0.1}>
                <Link to="/habitaciones"
                  className="group block glass rounded-2xl overflow-hidden border border-white/5 hover:border-dorado/30 transition-all duration-300 hover:scale-[1.02] hover:shadow-dorado">
                  <div className={`h-48 bg-gradient-to-br ${PISO_GRADIENT[piso]} relative overflow-hidden`}>
                    <div className={`absolute inset-0 flex items-center justify-center font-mono font-black opacity-10 ${PISO_ACCENT[piso]}`}
                      style={{ fontSize: '8rem' }}>
                      {piso}0{piso}
                    </div>
                    <div className="absolute inset-0 flex flex-col justify-end p-5">
                      <p className="text-body-xs text-blanco-roto/40 uppercase tracking-widest">Piso {piso} · Apartaestudio</p>
                      <p className="font-mono font-black text-blanco-roto text-display-sm leading-none mt-1">{piso}0{piso}</p>
                    </div>
                  </div>
                  <div className="p-5">
                    <div className="flex items-end justify-between">
                      <div>
                        <p className="text-body-xs text-blanco-roto/40">Desde</p>
                        <p className="font-mono font-bold text-mono-lg text-blanco-roto">${(120 + (piso - 1) * 10).toLocaleString('es-CO')}.000</p>
                        <p className="text-body-xs text-blanco-roto/30">por noche</p>
                      </div>
                      <span className="text-body-sm text-dorado font-semibold group-hover:translate-x-1 transition-transform">Ver →</span>
                    </div>
                  </div>
                </Link>
              </Reveal>
            ))}
          </div>
        )}

        <Reveal delay={0.3} className="text-center mt-10">
          <Link to="/habitaciones"
            className="inline-flex items-center gap-2 text-body-sm text-dorado hover:text-dorado/80 transition-colors font-semibold group">
            Ver todas las habitaciones
            <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </Reveal>
      </section>

      {/* ── POR QUÉ BREAK ── */}
      <section className="relative py-24 px-6 overflow-hidden">

        {/* Imagen de fondo */}
        <div className="absolute inset-0">
          <img src="/banner2.webp" alt="" className="w-full h-full object-cover object-left" />
          {/* Overlay blanco desde la derecha para legibilidad */}
          <div className="absolute inset-0 bg-gradient-to-r from-white/60 via-white/85 to-white" />
          {/* Refuerzo inferior y superior */}
          <div className="absolute inset-x-0 top-0 h-16 bg-gradient-to-b from-white/90 to-transparent" />
          <div className="absolute inset-x-0 bottom-0 h-16 bg-gradient-to-t from-white/90 to-transparent" />
        </div>

        <div className="relative max-w-6xl mx-auto">
          <Reveal className="text-center mb-16">
            <p className="text-body-xs font-bold uppercase tracking-widest mb-3 text-amber-700">Diseñado para ti</p>
            <h2 className="font-display font-black text-display-lg text-negro-absoluto drop-shadow-[0_1px_2px_rgba(0,0,0,0.1)]">
              No es solo un hotel.
            </h2>
          </Reveal>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              {
                icon: Star,
                title: 'Diseño boutique',
                body: 'Cada detalle fue pensado. Desde la cerradura digital hasta el WiFi de alta velocidad. Sin filas, sin esperas, a tu ritmo.',
                delay: 0,
              },
              {
                icon: Leaf,
                title: 'Eco-friendly',
                body: 'Paneles solares en la terraza. Caldera centralizada. Un hotel que piensa en el día siguiente — porque nosotros también lo hacemos.',
                delay: 0.1,
              },
              {
                icon: MapPin,
                title: 'El Triángulo',
                body: 'Av. Santander, estrato 6, Manizales. A minutos de la Zona Rosa, los mejores restaurantes y las vistas más limpias a los nevados.',
                delay: 0.2,
              },
            ].map(({ icon: Icon, title, body, delay }) => (
              <Reveal key={title} delay={delay}>
                <div className="group p-8 rounded-2xl bg-white/70 backdrop-blur-sm border border-negro-absoluto/8 hover:border-amber-700/30 hover:shadow-xl hover:bg-white/90 transition-all duration-300">
                  <div className="w-12 h-12 rounded-xl bg-amber-700/10 border border-amber-700/20 flex items-center justify-center mb-5 group-hover:bg-amber-700/20 transition-colors">
                    <Icon size={20} className="text-amber-700" />
                  </div>
                  <h3 className="font-display font-bold text-display-sm text-negro-absoluto mb-3">{title}</h3>
                  <p className="text-body-sm text-negro-absoluto/60 leading-relaxed">{body}</p>
                </div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* ── TAGLINE INTERMEDIA — con parallax propio y luces ── */}
      <TaglineSection />

      {/* ── STATS — contadores animados ── */}
      <StatsSection />

      {/* ── CTA FINAL — con efectos de luz y pulso ── */}
      <CtaFinalSection />

    </PublicLayout>
  )
}

// ══════════════════════════════════════════════════════════════════
// TAGLINE — parallax, split text, luces flotantes
// ══════════════════════════════════════════════════════════════════
function TaglineSection() {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-100px' })
  const { scrollYProgress } = useScroll({ target: ref, offset: ['start end', 'end start'] })
  const bgY = useTransform(scrollYProgress, [0, 1], ['0%', '15%'])

  const linea1 = ['Tu', 'ciudad.', 'Otro', 'ritmo.']
  const linea2 = ['Una', 'noche', 'que', 'cambia', 'la', 'semana.']

  return (
    <section ref={ref} className="relative py-40 px-6 text-center overflow-hidden">

      {/* Fondo parallax con gradientes */}
      <motion.div className="absolute inset-0" style={{ y: bgY }}>
        <div className="absolute inset-0 bg-negro-absoluto" />
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] rounded-full bg-dorado/[0.03] blur-[120px] animate-float-light" />
        <div className="absolute top-1/3 right-0 w-80 h-80 rounded-full bg-dorado/[0.04] blur-[100px] animate-float-light" style={{ animationDelay: '4s' }} />
        {/* Líneas horizontales sutiles */}
        <div className="absolute inset-0 opacity-[0.02]"
          style={{ backgroundImage: 'repeating-linear-gradient(0deg, transparent, transparent 120px, rgba(201,169,110,0.5) 120px, rgba(201,169,110,0.5) 121px)' }} />
      </motion.div>

      <div className="relative z-10 max-w-3xl mx-auto">

        {/* Eyebrow animado */}
        <motion.div
          initial={{ opacity: 0, scale: 0.8 }}
          animate={inView ? { opacity: 1, scale: 1 } : {}}
          transition={{ duration: 0.6 }}
          className="flex items-center justify-center gap-4 mb-8">
          <span className="h-px bg-gradient-to-r from-transparent to-dorado/40" style={{ width: inView ? 60 : 0, transition: 'width 1s ease-out 0.3s' }} />
          <p className="text-body-xs text-dorado uppercase tracking-[0.3em] animate-text-glow">Manizales, Colombia</p>
          <span className="h-px bg-gradient-to-l from-transparent to-dorado/40" style={{ width: inView ? 60 : 0, transition: 'width 1s ease-out 0.3s' }} />
        </motion.div>

        {/* Línea 1 — palabra por palabra */}
        <div className="font-display font-black text-blanco-roto leading-tight mb-2"
          style={{ fontSize: 'clamp(2rem, 5vw, 3.5rem)' }}>
          {linea1.map((word, i) => (
            <motion.span key={i}
              initial={{ opacity: 0, y: 30, filter: 'blur(6px)' }}
              animate={inView ? { opacity: 1, y: 0, filter: 'blur(0px)' } : {}}
              transition={{ duration: 0.5, delay: 0.2 + i * 0.1 }}
              className="inline-block mr-[0.25em] animate-text-glow">
              {word}
            </motion.span>
          ))}
        </div>

        {/* Línea 2 — dorada, con shimmer */}
        <div className="font-display font-black leading-tight"
          style={{ fontSize: 'clamp(2rem, 5vw, 3.5rem)' }}>
          {linea2.map((word, i) => (
            <motion.span key={i}
              initial={{ opacity: 0, y: 30, filter: 'blur(6px)' }}
              animate={inView ? { opacity: 1, y: 0, filter: 'blur(0px)' } : {}}
              transition={{ duration: 0.5, delay: 0.6 + i * 0.08 }}
              className="inline-block mr-[0.25em] text-shimmer animate-text-glow-strong">
              {word}
            </motion.span>
          ))}
        </div>

        {/* Subtítulo */}
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.7, delay: 1.2 }}
          className="text-body-md text-blanco-roto/45 mt-8 max-w-md mx-auto leading-relaxed">
          No tienes que salir de Manizales para desconectarte. A veces la pausa que necesitas está a 10 minutos de tu casa.
        </motion.p>
      </div>
    </section>
  )
}

// ══════════════════════════════════════════════════════════════════
// STATS — contadores animados + hover interactivo
// ══════════════════════════════════════════════════════════════════
function AnimatedCounter({ target, suffix = '' }: { target: number; suffix?: string }) {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true })
  const [count, setCount] = useState(0)

  useEffect(() => {
    if (!inView) return
    const duration = 1800
    const steps = 40
    const increment = target / steps
    let current = 0
    const timer = setInterval(() => {
      current += increment
      if (current >= target) {
        setCount(target)
        clearInterval(timer)
      } else {
        setCount(Math.floor(current))
      }
    }, duration / steps)
    return () => clearInterval(timer)
  }, [inView, target])

  return <span ref={ref}>{count}{suffix}</span>
}

function StatsSection() {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-80px' })

  const stats = [
    { num: 24,  suffix: '',  label: 'Estudios boutique' },
    { num: 4,   suffix: '',  label: 'Pisos con vista' },
    { num: 100, suffix: '%', label: 'Energía solar' },
    { num: 0,   suffix: '',  label: 'Filas en recepción', static: true },
  ]

  return (
    <section ref={ref} className="relative py-20 px-6 overflow-hidden">

      {/* Fondo con textura */}
      <div className="absolute inset-0 bg-negro-profundo">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_60%_50%_at_50%_50%,rgba(201,169,110,0.04),transparent)]" />
        <div className="absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-dorado/20 to-transparent" />
        <div className="absolute inset-x-0 bottom-0 h-px bg-gradient-to-r from-transparent via-dorado/20 to-transparent" />
      </div>

      <div className="relative max-w-4xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
        {stats.map(({ num, suffix, label, static: isStatic }, i) => (
          <motion.div
            key={label}
            initial={{ opacity: 0, y: 40, scale: 0.9 }}
            animate={inView ? { opacity: 1, y: 0, scale: 1 } : {}}
            transition={{ duration: 0.5, delay: i * 0.12, ease: 'easeOut' }}
            whileHover={{ scale: 1.08, y: -4 }}
            className="group cursor-default"
          >
            <div className="relative">
              {/* Glow detrás del número */}
              <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-500">
                <div className="w-20 h-20 rounded-full bg-dorado/10 blur-xl" />
              </div>
              <p className="relative font-mono font-black text-dorado animate-text-glow" style={{ fontSize: '2.8rem', lineHeight: 1 }}>
                {isStatic ? '0' : <AnimatedCounter target={num} suffix={suffix} />}
              </p>
            </div>

            {/* Línea decorativa */}
            <motion.div
              initial={{ width: 0 }}
              animate={inView ? { width: 32 } : {}}
              transition={{ duration: 0.6, delay: 0.8 + i * 0.1 }}
              className="h-px bg-gradient-to-r from-transparent via-dorado/40 to-transparent mx-auto mt-3 mb-2"
            />

            <p className="text-body-sm text-blanco-roto/40 group-hover:text-blanco-roto/70 transition-colors duration-300">{label}</p>
          </motion.div>
        ))}
      </div>
    </section>
  )
}

// ══════════════════════════════════════════════════════════════════
// CTA FINAL — luces pulsantes, efectos de entrada escalonados
// ══════════════════════════════════════════════════════════════════
function CtaFinalSection() {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-100px' })

  return (
    <section ref={ref} className="relative py-36 px-6 text-center overflow-hidden">

      {/* Luces de fondo */}
      <div className="absolute inset-0 bg-negro-absoluto">
        <motion.div
          animate={{ scale: [1, 1.2, 1], opacity: [0.03, 0.07, 0.03] }}
          transition={{ duration: 6, repeat: Infinity, ease: 'easeInOut' }}
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] rounded-full bg-dorado blur-[150px]"
        />
        <motion.div
          animate={{ scale: [1, 1.15, 1], opacity: [0.02, 0.05, 0.02] }}
          transition={{ duration: 8, repeat: Infinity, ease: 'easeInOut', delay: 2 }}
          className="absolute top-1/3 left-1/4 w-72 h-72 rounded-full bg-amber-500 blur-[120px]"
        />
        <motion.div
          animate={{ scale: [1.1, 1, 1.1], opacity: [0.02, 0.04, 0.02] }}
          transition={{ duration: 7, repeat: Infinity, ease: 'easeInOut', delay: 4 }}
          className="absolute bottom-1/4 right-1/4 w-60 h-60 rounded-full bg-dorado blur-[100px]"
        />
      </div>

      <div className="relative z-10 max-w-2xl mx-auto">

        {/* Eyebrow */}
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="flex items-center justify-center gap-4 mb-6">
          <span className="h-px bg-gradient-to-r from-transparent to-dorado/40" style={{ width: inView ? 50 : 0, transition: 'width 0.8s ease-out 0.3s' }} />
          <p className="text-body-xs text-dorado uppercase tracking-widest animate-text-glow">¿Cuándo es tu próxima pausa?</p>
          <span className="h-px bg-gradient-to-l from-transparent to-dorado/40" style={{ width: inView ? 50 : 0, transition: 'width 0.8s ease-out 0.3s' }} />
        </motion.div>

        {/* Título con reveal por palabra */}
        <div className="font-display font-black text-display-lg leading-tight mb-6">
          {['Reserva', 'directo.'].map((word, i) => (
            <motion.span key={i}
              initial={{ opacity: 0, y: 40, filter: 'blur(8px)' }}
              animate={inView ? { opacity: 1, y: 0, filter: 'blur(0px)' } : {}}
              transition={{ duration: 0.5, delay: 0.2 + i * 0.15 }}
              className="inline-block mr-[0.25em] text-blanco-roto animate-text-glow">
              {word}
            </motion.span>
          ))}
          <br />
          {['Sin', 'intermediarios.'].map((word, i) => (
            <motion.span key={i}
              initial={{ opacity: 0, y: 40, filter: 'blur(8px)' }}
              animate={inView ? { opacity: 1, y: 0, filter: 'blur(0px)' } : {}}
              transition={{ duration: 0.5, delay: 0.5 + i * 0.15 }}
              className={`inline-block mr-[0.25em] ${
                word === 'intermediarios.'
                  ? 'text-shimmer animate-text-glow-strong'
                  : 'text-blanco-roto animate-text-glow'
              }`}>
              {word}
            </motion.span>
          ))}
        </div>

        {/* Subtítulo */}
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6, delay: 0.9 }}
          className="text-body-md text-blanco-roto/50 mb-12 max-w-sm mx-auto">
          Canal directo = mejor precio. Sin comisiones de Airbnb ni Booking.
        </motion.p>

        {/* CTAs */}
        <motion.div
          initial={{ opacity: 0, y: 24 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6, delay: 1.1 }}
          className="flex items-center justify-center gap-4 flex-wrap">
          <motion.div whileHover={{ scale: 1.06 }} whileTap={{ scale: 0.96 }}>
            <Link to="/reservar"
              className="group flex items-center gap-2 px-10 py-5 bg-dorado text-negro-absoluto font-black text-body-lg rounded-2xl shadow-[0_0_40px_rgba(201,169,110,0.25)] hover:shadow-[0_0_60px_rgba(201,169,110,0.4)] transition-shadow duration-300">
              Reservar ahora
              <ArrowRight size={20} className="group-hover:translate-x-1 transition-transform" />
            </Link>
          </motion.div>
          <motion.div whileHover={{ scale: 1.04 }} whileTap={{ scale: 0.97 }}>
            <a href="https://wa.me/573000000000" target="_blank" rel="noreferrer"
              className="flex items-center gap-2 px-8 py-5 bg-negro-absoluto/40 backdrop-blur-md border border-green-700/40 text-green-400 font-semibold text-body-md rounded-2xl hover:border-green-500/60 hover:shadow-[0_0_30px_rgba(74,222,128,0.1)] transition-all duration-300">
              <MessageCircle size={18} />
              Escribir por WhatsApp
            </a>
          </motion.div>
        </motion.div>
      </div>
    </section>
  )
}
