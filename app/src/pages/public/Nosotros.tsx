import { motion } from 'framer-motion'
import { Leaf, Sun, Zap, MapPin } from 'lucide-react'
import { Link } from 'react-router-dom'
import { PublicLayout } from '@/components/layout/PublicLayout'

export default function Nosotros() {
  return (
    <PublicLayout>
      <div className="pt-32 pb-24 px-6 max-w-4xl mx-auto">
        <motion.div initial={{ opacity:0, y:24 }} animate={{ opacity:1, y:0 }} transition={{ duration:0.6 }}
          className="text-center mb-16">
          <p className="text-body-xs text-dorado uppercase tracking-widest mb-3">Nuestra historia</p>
          <h1 className="font-display font-black text-display-lg text-blanco-roto mb-5">
            Break no es un hotel más.
          </h1>
          <p className="text-body-lg text-blanco-roto/50 max-w-xl mx-auto leading-relaxed">
            Es una declaración de que el descanso también es parte del plan. Que pausar con intención es la forma más inteligente de avanzar.
          </p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-16">
          {[
            { icon: Leaf, title: 'Eco-friendly de verdad', body: 'Paneles solares en la terraza que alimentan las áreas comunes. Caldera centralizada de alta eficiencia. No es marketing — es la forma en que operamos.' },
            { icon: Sun,  title: 'Diseño con propósito', body: '24 estudios boutique. Cerradura digital, WiFi de alta velocidad, cocina equipada, Smart TV. Sin filas, sin recepción a las 11pm. Tu llegada, a tu ritmo.' },
            { icon: Zap,  title: 'Tecnología al servicio', body: 'Check-in digital desde tu celular. Sistema de reservas directo. Sin intermediarios, sin comisiones adicionales. La tecnología que simplifica, no la que complica.' },
            { icon: MapPin, title: 'Ubicación estratégica', body: 'Av. Santander, El Triángulo, estrato 6. A minutos de la Zona Rosa, los mejores restaurantes de Milán, el Cable Aéreo y las vistas más limpias a los nevados del Ruiz.' },
          ].map(({ icon:Icon, title, body }, i) => (
            <motion.div key={title}
              initial={{ opacity:0, y:20 }} animate={{ opacity:1, y:0 }} transition={{ delay: 0.2 + i*0.1 }}
              className="glass rounded-2xl p-7 border border-white/5 hover:border-dorado/20 transition-colors">
              <Icon size={22} className="text-dorado mb-4"/>
              <h3 className="font-display font-bold text-display-sm text-blanco-roto mb-3">{title}</h3>
              <p className="text-body-sm text-blanco-roto/50 leading-relaxed">{body}</p>
            </motion.div>
          ))}
        </div>

        <motion.div initial={{ opacity:0 }} animate={{ opacity:1 }} transition={{ delay:0.6 }}
          className="text-center">
          <Link to="/reservar"
            className="inline-flex items-center gap-2 px-8 py-4 bg-dorado text-negro-absoluto font-black text-body-md rounded-2xl hover:shadow-glow hover:scale-105 transition-all">
            Reservar ahora
          </Link>
        </motion.div>
      </div>
    </PublicLayout>
  )
}
