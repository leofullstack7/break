import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { PublicNav } from './PublicNav'
import { MessageCircle, MapPin, Instagram, Sun, Leaf, ArrowRight, Phone } from 'lucide-react'

interface PublicLayoutProps {
  children: React.ReactNode
}

function Footer() {
  const navLinks = [
    { to: '/',             label: 'Inicio' },
    { to: '/habitaciones', label: 'Habitaciones' },
    { to: '/reservar',     label: 'Reservar' },
    { to: '/nosotros',     label: 'Nosotros' },
    { to: '/ubicacion',    label: 'Cómo llegar' },
    { to: '/login',        label: 'Ingresar' },
  ]

  return (
    <footer className="relative bg-negro-profundo">

      {/* Línea superior con gradiente dorado */}
      <div className="h-px bg-gradient-to-r from-transparent via-dorado/40 to-transparent" />

      {/* Franja CTA */}
      <div className="border-b border-white/5">
        <div className="max-w-6xl mx-auto px-6 py-10 flex flex-col sm:flex-row items-center justify-between gap-6">
          <div>
            <p className="font-display font-black text-display-sm text-blanco-roto leading-tight">
              Una pausa bien pensada.
            </p>
            <p className="text-body-sm text-blanco-roto/40 mt-1.5">
              Canal directo · Sin intermediarios · Mejor precio garantizado
            </p>
          </div>
          <Link
            to="/reservar"
            className="group flex items-center gap-2 px-7 py-3.5 bg-dorado text-negro-absoluto font-black text-body-sm rounded-2xl hover:shadow-glow hover:scale-105 active:scale-95 transition-all shrink-0"
          >
            Reservar ahora
            <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </div>
      </div>

      {/* Grid principal */}
      <div className="max-w-6xl mx-auto px-6 py-14">
        <div className="grid grid-cols-2 md:grid-cols-12 gap-10">

          {/* Columna marca — ocupa más espacio */}
          <div className="col-span-2 md:col-span-4 space-y-5">
            <div>
              <span className="font-display font-black tracking-widest text-dorado"
                style={{ fontSize: '1.75rem' }}>
                BREAK
              </span>
              <div className="h-px bg-gradient-to-r from-dorado/50 to-transparent mt-2 mb-1 w-16" />
              <p className="text-body-xs text-blanco-roto/25 uppercase tracking-widest">
                Hotel Boutique · Lifestyle · Manizales
              </p>
            </div>

            <p className="text-body-sm text-blanco-roto/45 leading-relaxed max-w-xs">
              Diseñado para ejecutivos, nómadas digitales y parejas que entienden que
              descansar bien también es avanzar.
            </p>

            {/* Badges eco */}
            <div className="flex flex-wrap gap-2">
              <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-amber-900/20 border border-amber-700/20 text-body-xs text-amber-400/80">
                <Sun size={10} /> Paneles solares
              </span>
              <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-green-900/20 border border-green-800/20 text-body-xs text-green-400/80">
                <Leaf size={10} /> Eco-friendly
              </span>
            </div>

            {/* Rating decorativo */}
            <div className="flex items-center gap-2">
              <div className="flex gap-0.5">
                {Array.from({ length: 5 }).map((_, i) => (
                  <svg key={i} className="w-3.5 h-3.5 text-dorado fill-current" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                  </svg>
                ))}
              </div>
              <span className="text-body-xs text-blanco-roto/30">Estrato 6 · El Triángulo</span>
            </div>
          </div>

          {/* Separador vertical sutil */}
          <div className="hidden md:block md:col-span-1">
            <div className="w-px h-full bg-white/5 mx-auto" />
          </div>

          {/* Navegación */}
          <div className="col-span-1 md:col-span-2 space-y-4">
            <p className="text-body-xs text-blanco-roto/25 uppercase tracking-widest font-semibold">
              Hotel
            </p>
            <div className="space-y-2.5">
              {navLinks.map(l => (
                <Link
                  key={l.to}
                  to={l.to}
                  className="flex items-center gap-1.5 text-body-sm text-blanco-roto/50 hover:text-dorado transition-colors duration-200 group"
                >
                  <span className="w-0 h-px bg-dorado group-hover:w-3 transition-all duration-200 shrink-0" />
                  {l.label}
                </Link>
              ))}
            </div>
          </div>

          {/* Contacto */}
          <div className="col-span-1 md:col-span-2 space-y-4">
            <p className="text-body-xs text-blanco-roto/25 uppercase tracking-widest font-semibold">
              Contacto
            </p>
            <div className="space-y-3.5">
              <a
                href="https://maps.google.com/?q=Carrera+23+53-40+Manizales"
                target="_blank"
                rel="noreferrer"
                className="flex items-start gap-2.5 group"
              >
                <MapPin size={13} className="text-dorado shrink-0 mt-0.5" />
                <p className="text-body-sm text-blanco-roto/50 group-hover:text-blanco-roto/70 transition-colors leading-snug">
                  Carrera 23 #53-40<br />El Triángulo, Manizales
                </p>
              </a>

              <a
                href="https://wa.me/573000000000"
                target="_blank"
                rel="noreferrer"
                className="flex items-center gap-2.5 text-body-sm text-green-400/80 hover:text-green-300 transition-colors"
              >
                <MessageCircle size={13} />
                WhatsApp directo
              </a>

              <a
                href="tel:+573000000000"
                className="flex items-center gap-2.5 text-body-sm text-blanco-roto/40 hover:text-blanco-roto/70 transition-colors"
              >
                <Phone size={13} />
                Llamar al hotel
              </a>
            </div>
          </div>

          {/* Redes sociales */}
          <div className="col-span-2 md:col-span-3 space-y-4">
            <p className="text-body-xs text-blanco-roto/25 uppercase tracking-widest font-semibold">
              Síguenos
            </p>

            <a
              href="https://instagram.com/breakhotelmanizales"
              target="_blank"
              rel="noreferrer"
              className="group flex items-center gap-3 p-3 rounded-xl border border-white/5 hover:border-dorado/20 hover:bg-dorado/3 transition-all"
            >
              <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-pink-600 to-purple-600 flex items-center justify-center shrink-0">
                <Instagram size={14} className="text-white" />
              </div>
              <div className="min-w-0">
                <p className="text-body-sm text-blanco-roto group-hover:text-dorado transition-colors">@breakhotelmanizales</p>
                <p className="text-body-xs text-blanco-roto/30">Instagram</p>
              </div>
            </a>

            <a
              href="https://wa.me/573000000000"
              target="_blank"
              rel="noreferrer"
              className="group flex items-center gap-3 p-3 rounded-xl border border-white/5 hover:border-green-700/30 hover:bg-green-900/5 transition-all"
            >
              <div className="w-8 h-8 rounded-lg bg-green-700/30 border border-green-700/30 flex items-center justify-center shrink-0">
                <MessageCircle size={14} className="text-green-400" />
              </div>
              <div className="min-w-0">
                <p className="text-body-sm text-blanco-roto group-hover:text-green-400 transition-colors">WhatsApp</p>
                <p className="text-body-xs text-blanco-roto/30">Respuesta inmediata</p>
              </div>
            </a>

            {/* Horario */}
            <div className="p-3 rounded-xl border border-white/5 bg-white/[0.02]">
              <p className="text-body-xs text-blanco-roto/25 uppercase tracking-wider mb-2">Recepción</p>
              <p className="text-body-sm text-blanco-roto/60">Lun — Dom</p>
              <p className="font-mono text-mono-sm text-dorado">7:00 am — 10:00 pm</p>
            </div>
          </div>

        </div>

        {/* Barra inferior */}
        <div className="border-t border-white/5 mt-12 pt-6 flex flex-col sm:flex-row items-center justify-between gap-3">
          <p className="text-body-xs text-blanco-roto/20">
            © 2026 Break Hotel · Manizales, Colombia · NIT XXX.XXX.XXX-X
          </p>
          <div className="flex items-center gap-4 text-body-xs text-blanco-roto/20">
            <span>Av. Santander</span>
            <span className="w-px h-3 bg-white/10" />
            <span>24 estudios</span>
            <span className="w-px h-3 bg-white/10" />
            <span>Pisos 1–4</span>
          </div>
        </div>
      </div>
    </footer>
  )
}

export function PublicLayout({ children }: PublicLayoutProps) {
  return (
    <div className="min-h-screen bg-negro-absoluto text-blanco-roto">
      <PublicNav />
      <motion.main
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{ duration: 0.3 }}
      >
        {children}
      </motion.main>
      <Footer />
    </div>
  )
}
