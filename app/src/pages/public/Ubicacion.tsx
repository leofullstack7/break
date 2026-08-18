import { motion } from 'framer-motion'
import { MapPin, Car, Navigation, Clock } from 'lucide-react'
import { Link } from 'react-router-dom'
import { PublicLayout } from '@/components/layout/PublicLayout'

export default function Ubicacion() {
  return (
    <PublicLayout>
      <div className="pt-32 pb-24 px-6 max-w-4xl mx-auto">
        <motion.div initial={{ opacity:0, y:24 }} animate={{ opacity:1, y:0 }}
          className="text-center mb-12">
          <p className="text-body-xs text-dorado uppercase tracking-widest mb-3">Cómo llegar</p>
          <h1 className="font-display font-black text-display-lg text-blanco-roto mb-4">Estamos en el corazón de Manizales</h1>
          <p className="text-body-md text-blanco-roto/50">Carrera 23 #53-40 · El Triángulo · Estrato 6</p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <motion.div initial={{ opacity:0, y:20 }} animate={{ opacity:1, y:0 }} transition={{ delay:0.2 }}
            className="glass rounded-2xl p-7 space-y-5">
            <div className="flex items-start gap-3">
              <MapPin size={20} className="text-dorado shrink-0 mt-0.5"/>
              <div>
                <p className="text-body-sm font-semibold text-blanco-roto mb-1">Dirección exacta</p>
                <p className="text-body-sm text-blanco-roto/60">Carrera 23 #53-40</p>
                <p className="text-body-sm text-blanco-roto/60">El Triángulo, Manizales</p>
                <p className="text-body-sm text-blanco-roto/60">Caldas, Colombia</p>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <Clock size={20} className="text-dorado shrink-0 mt-0.5"/>
              <div>
                <p className="text-body-sm font-semibold text-blanco-roto mb-1">Horarios</p>
                <p className="text-body-sm text-blanco-roto/60">Check-in: desde las 3:00 PM</p>
                <p className="text-body-sm text-blanco-roto/60">Check-out: hasta las 12:00 PM</p>
                <p className="text-body-sm text-blanco-roto/60">Acceso: 24/7 con cerradura digital</p>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <Car size={20} className="text-dorado shrink-0 mt-0.5"/>
              <div>
                <p className="text-body-sm font-semibold text-blanco-roto mb-1">Parqueadero</p>
                <p className="text-body-sm text-blanco-roto/60">No contamos con parqueadero propio.</p>
                <p className="text-body-sm text-blanco-roto/60">Parqueaderos públicos cercanos disponibles.</p>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <Navigation size={20} className="text-dorado shrink-0 mt-0.5"/>
              <div>
                <p className="text-body-sm font-semibold text-blanco-roto mb-1">Desde el aeropuerto</p>
                <p className="text-body-sm text-blanco-roto/60">Aeropuerto La Nubia: ~15 min en taxi</p>
                <p className="text-body-sm text-blanco-roto/60">Zona Rosa: ~5 min caminando</p>
              </div>
            </div>
          </motion.div>

          <motion.div initial={{ opacity:0, y:20 }} animate={{ opacity:1, y:0 }} transition={{ delay:0.3 }}
            className="glass rounded-2xl overflow-hidden border border-white/10">
            <a href="https://maps.google.com/?q=Carrera+23+%2353-40+Manizales" target="_blank" rel="noreferrer"
              className="block h-full min-h-64 relative group">
              <div className="absolute inset-0 bg-gradient-to-br from-zinc-900 to-stone-900 flex flex-col items-center justify-center gap-4">
                <div className="w-16 h-16 rounded-2xl bg-dorado/10 border border-dorado/30 flex items-center justify-center group-hover:bg-dorado/20 transition-colors">
                  <MapPin size={28} className="text-dorado"/>
                </div>
                <p className="text-body-sm font-semibold text-blanco-roto">Abrir en Google Maps</p>
                <p className="text-body-xs text-blanco-roto/40">Carrera 23 #53-40 · Manizales</p>
              </div>
            </a>
          </motion.div>
        </div>

        <motion.div initial={{ opacity:0 }} animate={{ opacity:1 }} transition={{ delay:0.5 }}
          className="text-center mt-12">
          <Link to="/reservar"
            className="inline-flex items-center gap-2 px-8 py-4 bg-dorado text-negro-absoluto font-black text-body-md rounded-2xl hover:shadow-glow hover:scale-105 transition-all">
            Reservar ahora
          </Link>
        </motion.div>
      </div>
    </PublicLayout>
  )
}
