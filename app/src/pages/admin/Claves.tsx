import { useEffect, useMemo, useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import {
  Check, Copy, Delete, Eye, EyeOff, KeyRound, Lock, Search, ShieldCheck,
} from 'lucide-react'
import {
  CATEGORIAS_CLAVE,
  CLAVES_HOTEL,
  type CategoriaClave,
  type ClaveHotel,
} from '@/data/claves-hotel'

const PIN_CLAVE = '2571'
const SESSION_KEY = 'break-claves-desbloqueado'
const ORDEN_CATEGORIAS: CategoriaClave[] = [
  'acceso', 'redes', 'cuentas', 'canales', 'finanzas', 'entretenimiento',
]

function normalizar(texto: string) {
  return texto
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .toLowerCase()
    .trim()
}

function coincide(clave: ClaveHotel, query: string) {
  if (!query) return true
  const q = normalizar(query)
  return [
    clave.nombre,
    clave.usuario,
    clave.notas ?? '',
    clave.extra ?? '',
    CATEGORIAS_CLAVE[clave.categoria].label,
  ].some(campo => normalizar(campo).includes(q))
}

function PinGate({ onUnlock }: { onUnlock: () => void }) {
  const [pin, setPin] = useState('')
  const [error, setError] = useState(false)

  function pulsar(digito: string) {
    if (pin.length >= 4) return
    const siguiente = pin + digito
    setPin(siguiente)
    setError(false)

    if (siguiente.length === 4) {
      if (siguiente === PIN_CLAVE) {
        sessionStorage.setItem(SESSION_KEY, '1')
        onUnlock()
        return
      }
      setError(true)
      window.setTimeout(() => setPin(''), 280)
    }
  }

  function borrar() {
    setError(false)
    setPin(prev => prev.slice(0, -1))
  }

  return (
    <div className="min-h-full flex items-center justify-center px-4 py-10">
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-sm"
      >
        <div className="text-center mb-8">
          <div className="mx-auto mb-5 w-14 h-14 rounded-2xl bg-gradient-to-br from-dorado/25 to-dorado/5 border border-dorado/30 flex items-center justify-center shadow-dorado-sm">
            <Lock size={22} className="text-dorado" />
          </div>
          <p className="text-body-xs uppercase tracking-[0.28em] text-dorado/70 mb-2">
            Acceso restringido
          </p>
          <h2 className="font-display font-semibold text-blanco-roto text-xl">
            Claves del hotel
          </h2>
          <p className="mt-2 text-body-sm text-blanco-roto/40">
            Ingresa el PIN para ver las credenciales
          </p>
        </div>

        <motion.div
          animate={error ? { x: [0, -8, 8, -6, 6, 0] } : { x: 0 }}
          transition={{ duration: 0.32 }}
          className="flex justify-center gap-3 mb-3"
        >
          {[0, 1, 2, 3].map(i => (
            <span
              key={i}
              className={`w-3.5 h-3.5 rounded-full border transition-all ${
                pin.length > i
                  ? error
                    ? 'bg-red-400 border-red-400'
                    : 'bg-dorado border-dorado shadow-dorado-sm'
                  : 'bg-transparent border-white/20'
              }`}
            />
          ))}
        </motion.div>

        <p className={`text-center text-body-xs h-5 mb-5 ${error ? 'text-red-400' : 'text-transparent'}`}>
          PIN incorrecto
        </p>

        <div className="grid grid-cols-3 gap-2.5">
          {['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'].map(tecla => {
            if (!tecla) return <span key="empty" />
            if (tecla === 'del') {
              return (
                <button
                  key="del"
                  type="button"
                  onClick={borrar}
                  className="h-14 rounded-2xl border border-white/8 bg-white/[0.03] text-blanco-roto/50 hover:text-blanco-roto hover:bg-white/[0.07] transition-all flex items-center justify-center"
                >
                  <Delete size={18} />
                </button>
              )
            }
            return (
              <button
                key={tecla}
                type="button"
                onClick={() => pulsar(tecla)}
                className="h-14 rounded-2xl border border-white/8 bg-white/[0.04] font-display text-xl text-blanco-roto hover:border-dorado/40 hover:bg-dorado/10 hover:text-dorado transition-all"
              >
                {tecla}
              </button>
            )
          })}
        </div>
      </motion.div>
    </div>
  )
}

function CopiarCampo({ valor, label }: { valor: string; label: string }) {
  const [copiado, setCopiado] = useState(false)

  async function copiar() {
    if (!valor) return
    await navigator.clipboard.writeText(valor)
    setCopiado(true)
    window.setTimeout(() => setCopiado(false), 1400)
  }

  return (
    <button
      type="button"
      onClick={copiar}
      className="shrink-0 w-8 h-8 rounded-lg flex items-center justify-center text-blanco-roto/30 hover:text-dorado hover:bg-dorado/10 transition-all"
      aria-label={`Copiar ${label}`}
    >
      {copiado ? <Check size={14} className="text-dorado" /> : <Copy size={14} />}
    </button>
  )
}

function TarjetaClave({ clave }: { clave: ClaveHotel }) {
  const [visible, setVisible] = useState(false)

  return (
    <article className="rounded-2xl border border-white/[0.07] bg-negro-profundo/80 p-4 hover:border-dorado/25 transition-colors">
      <div className="flex items-start justify-between gap-3 mb-3">
        <div className="min-w-0">
          <h3 className="font-display font-semibold text-blanco-roto truncate">
            {clave.nombre}
          </h3>
          {clave.notas && (
            <p className="text-body-xs text-blanco-roto/35 mt-0.5 leading-relaxed">
              {clave.notas}
            </p>
          )}
        </div>
        <span className="shrink-0 w-8 h-8 rounded-lg bg-dorado/10 border border-dorado/20 flex items-center justify-center">
          <KeyRound size={13} className="text-dorado" />
        </span>
      </div>

      <div className="space-y-2">
        {clave.usuario && (
          <div className="flex items-center gap-2 rounded-xl bg-white/[0.03] px-3 py-2">
            <div className="min-w-0 flex-1">
              <p className="text-[0.62rem] uppercase tracking-wider text-blanco-roto/30">Usuario</p>
              <p className="text-body-sm text-blanco-roto/85 truncate font-mono">{clave.usuario}</p>
            </div>
            <CopiarCampo valor={clave.usuario} label="usuario" />
          </div>
        )}

        <div className="flex items-center gap-2 rounded-xl bg-white/[0.03] px-3 py-2">
          <div className="min-w-0 flex-1">
            <p className="text-[0.62rem] uppercase tracking-wider text-blanco-roto/30">Clave</p>
            <p className="text-body-sm text-dorado/90 truncate font-mono tracking-wide">
              {visible ? clave.clave : '•'.repeat(Math.min(clave.clave.length, 12))}
            </p>
          </div>
          <button
            type="button"
            onClick={() => setVisible(v => !v)}
            className="shrink-0 w-8 h-8 rounded-lg flex items-center justify-center text-blanco-roto/30 hover:text-dorado hover:bg-dorado/10 transition-all"
            aria-label={visible ? 'Ocultar clave' : 'Mostrar clave'}
          >
            {visible ? <EyeOff size={14} /> : <Eye size={14} />}
          </button>
          <CopiarCampo valor={clave.clave} label="clave" />
        </div>

        {clave.extra && (
          <div className="flex items-center gap-2 rounded-xl bg-white/[0.03] px-3 py-2">
            <div className="min-w-0 flex-1">
              <p className="text-[0.62rem] uppercase tracking-wider text-blanco-roto/30">Dato extra</p>
              <p className="text-body-sm text-blanco-roto/85 truncate font-mono">{clave.extra}</p>
            </div>
            <CopiarCampo valor={clave.extra} label="dato extra" />
          </div>
        )}
      </div>
    </article>
  )
}

export default function Claves() {
  const [desbloqueado, setDesbloqueado] = useState(false)
  const [busqueda, setBusqueda] = useState('')
  const [categoriaActiva, setCategoriaActiva] = useState<CategoriaClave | 'todas'>('todas')

  useEffect(() => {
    if (sessionStorage.getItem(SESSION_KEY) === '1') {
      setDesbloqueado(true)
    }
  }, [])

  const filtradas = useMemo(() => {
    return CLAVES_HOTEL.filter(clave => {
      const porCategoria = categoriaActiva === 'todas' || clave.categoria === categoriaActiva
      return porCategoria && coincide(clave, busqueda)
    })
  }, [busqueda, categoriaActiva])

  const agrupadas = useMemo(() => {
    return ORDEN_CATEGORIAS
      .map(cat => ({
        categoria: cat,
        items: filtradas.filter(c => c.categoria === cat),
      }))
      .filter(grupo => grupo.items.length > 0)
  }, [filtradas])

  function bloquear() {
    sessionStorage.removeItem(SESSION_KEY)
    setDesbloqueado(false)
    setBusqueda('')
    setCategoriaActiva('todas')
  }

  if (!desbloqueado) {
    return <PinGate onUnlock={() => setDesbloqueado(true)} />
  }

  return (
    <div className="p-4 lg:p-6 space-y-5">
      <div className="flex items-start justify-between gap-3">
        <div>
          <p className="text-body-xs uppercase tracking-[0.22em] text-dorado/70">Bóveda</p>
          <h2 className="font-display font-semibold text-blanco-roto mt-1">
            Credenciales operativas
          </h2>
          <p className="text-body-sm text-blanco-roto/40 mt-1">
            {filtradas.length} de {CLAVES_HOTEL.length} claves
          </p>
        </div>
        <button
          type="button"
          onClick={bloquear}
          className="shrink-0 inline-flex items-center gap-1.5 px-3 py-2 rounded-xl border border-white/10 text-body-xs text-blanco-roto/50 hover:text-dorado hover:border-dorado/30 transition-all"
        >
          <ShieldCheck size={13} />
          Bloquear
        </button>
      </div>

      <div className="sticky top-0 z-10 -mx-4 px-4 py-3 bg-negro-absoluto/90 backdrop-blur-md border-b border-white/[0.04] lg:-mx-6 lg:px-6">
        <div className="relative">
          <Search size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-blanco-roto/30" />
          <input
            type="search"
            value={busqueda}
            onChange={e => setBusqueda(e.target.value)}
            placeholder="Buscar por nombre de la contraseña..."
            autoComplete="off"
            className="w-full bg-negro-profundo border border-white/10 rounded-2xl pl-10 pr-4 py-3 text-blanco-roto placeholder:text-blanco-roto/30 focus:outline-none focus:border-dorado/50 transition-colors"
          />
        </div>

        <div className="flex gap-2 overflow-x-auto pt-3 pb-0.5 -mx-1 px-1">
          <button
            type="button"
            onClick={() => setCategoriaActiva('todas')}
            className={`shrink-0 px-3 py-1.5 rounded-full text-body-xs border transition-all ${
              categoriaActiva === 'todas'
                ? 'bg-dorado/15 border-dorado/40 text-dorado'
                : 'border-white/10 text-blanco-roto/45 hover:text-blanco-roto'
            }`}
          >
            Todas
          </button>
          {ORDEN_CATEGORIAS.map(cat => (
            <button
              key={cat}
              type="button"
              onClick={() => setCategoriaActiva(cat)}
              className={`shrink-0 px-3 py-1.5 rounded-full text-body-xs border transition-all ${
                categoriaActiva === cat
                  ? 'bg-dorado/15 border-dorado/40 text-dorado'
                  : 'border-white/10 text-blanco-roto/45 hover:text-blanco-roto'
              }`}
            >
              {CATEGORIAS_CLAVE[cat].label}
            </button>
          ))}
        </div>
      </div>

      {agrupadas.length === 0 && (
        <div className="rounded-2xl border border-white/[0.06] px-5 py-12 text-center">
          <p className="text-blanco-roto/50">No hay claves que coincidan con esa búsqueda.</p>
        </div>
      )}

      <AnimatePresence mode="popLayout">
        {agrupadas.map(grupo => (
          <motion.section
            key={grupo.categoria}
            layout
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
            className="space-y-3"
          >
            <div>
              <h3 className="text-body-sm font-semibold text-blanco-roto/70 uppercase tracking-wider">
                {CATEGORIAS_CLAVE[grupo.categoria].label}
              </h3>
              <p className="text-body-xs text-blanco-roto/30">
                {CATEGORIAS_CLAVE[grupo.categoria].descripcion}
              </p>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-3">
              {grupo.items.map(clave => (
                <TarjetaClave key={clave.id} clave={clave} />
              ))}
            </div>
          </motion.section>
        ))}
      </AnimatePresence>
    </div>
  )
}
