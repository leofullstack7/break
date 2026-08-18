import { useState, useEffect } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { Menu, X, LogIn } from 'lucide-react'

export function PublicNav() {
  const [scrolled,   setScrolled]   = useState(false)
  const [menuOpen,   setMenuOpen]   = useState(false)
  const location = useLocation()

  useEffect(() => {
    const fn = () => setScrolled(window.scrollY > 40)
    window.addEventListener('scroll', fn, { passive: true })
    return () => window.removeEventListener('scroll', fn)
  }, [])

  // Cerrar menú al navegar
  useEffect(() => { setMenuOpen(false) }, [location])

  const links = [
    { href: '/habitaciones', label: 'Habitaciones' },
    { href: '/nosotros',     label: 'Nosotros' },
    { href: '/ubicacion',    label: 'Ubicación' },
  ]

  return (
    <>
      <motion.header
        className={`fixed top-0 left-0 right-0 z-40 transition-all duration-500 ${
          scrolled
            ? 'bg-negro-profundo/90 backdrop-blur-xl border-b border-white/5 shadow-lg'
            : 'bg-transparent'
        }`}
        initial={{ y: -80, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ duration: 0.6, ease: 'easeOut', delay: 0.2 }}
      >
        <div className="max-w-6xl mx-auto px-6 h-16 flex items-center justify-between">
          {/* Logo */}
          <Link to="/" className="group">
            <span className="font-display font-black tracking-widest text-blanco-roto text-body-lg group-hover:text-dorado transition-colors duration-300">
              BREAK
            </span>
          </Link>

          {/* Desktop nav */}
          <nav className="hidden md:flex items-center gap-8">
            {links.map(l => (
              <Link key={l.href} to={l.href}
                className="text-body-sm text-blanco-roto/60 hover:text-blanco-roto transition-colors duration-200 relative group">
                {l.label}
                <span className="absolute -bottom-0.5 left-0 w-0 h-px bg-dorado group-hover:w-full transition-all duration-300" />
              </Link>
            ))}
          </nav>

          {/* CTA + login + hamburger */}
          <div className="flex items-center gap-3">
            <Link to="/login"
              className="hidden md:flex items-center gap-1.5 px-4 py-2 text-body-sm text-blanco-roto/50 hover:text-blanco-roto border border-white/10 hover:border-white/20 rounded-xl transition-all duration-200">
              <LogIn size={14} />
              Ingresar
            </Link>
            <Link to="/reservar"
              className="hidden md:flex items-center px-5 py-2 bg-dorado text-negro-absoluto font-bold text-body-sm rounded-xl hover:shadow-glow hover:scale-105 active:scale-95 transition-all duration-200">
              Reservar
            </Link>
            <button onClick={() => setMenuOpen(v => !v)}
              className="md:hidden p-2 text-blanco-roto/70 hover:text-blanco-roto transition-colors">
              {menuOpen ? <X size={22} /> : <Menu size={22} />}
            </button>
          </div>
        </div>
      </motion.header>

      {/* Mobile fullscreen menu */}
      <AnimatePresence>
        {menuOpen && (
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            transition={{ duration: 0.25 }}
            className="fixed inset-0 z-30 bg-negro-absoluto flex flex-col items-center justify-center gap-8 md:hidden"
          >
            <span className="font-display font-black tracking-widest text-dorado text-display-md absolute top-5 left-6">
              BREAK
            </span>
            {links.map((l, i) => (
              <motion.div key={l.href}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.08 }}>
                <Link to={l.href}
                  className="font-display font-bold text-display-md text-blanco-roto hover:text-dorado transition-colors">
                  {l.label}
                </Link>
              </motion.div>
            ))}
            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}>
              <Link to="/reservar"
                className="px-10 py-4 bg-dorado text-negro-absoluto font-black text-body-lg rounded-2xl">
                Reservar ahora
              </Link>
            </motion.div>
            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.4 }}>
              <Link to="/login"
                className="flex items-center gap-2 text-body-md text-blanco-roto/50 hover:text-dorado transition-colors">
                <LogIn size={16} />
                Ingresar al panel
              </Link>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  )
}
