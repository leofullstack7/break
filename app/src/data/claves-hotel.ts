export type CategoriaClave =
  | 'acceso'
  | 'redes'
  | 'cuentas'
  | 'canales'
  | 'finanzas'
  | 'entretenimiento'

export interface ClaveHotel {
  id: string
  nombre: string
  usuario: string
  clave: string
  notas?: string
  extra?: string
  categoria: CategoriaClave
}

export const CATEGORIAS_CLAVE: Record<
  CategoriaClave,
  { label: string; descripcion: string }
> = {
  acceso:          { label: 'Acceso y seguridad',  descripcion: 'Cámaras, NVR y chapas' },
  redes:           { label: 'Redes y TV',          descripcion: 'Wifi, Omada y televisión' },
  cuentas:         { label: 'Correo y nubes',      descripcion: 'Gmail e iCloud' },
  canales:         { label: 'Canales y reservas',  descripcion: 'OTAs, PMS y redes' },
  finanzas:        { label: 'Finanzas',            descripcion: 'Facturación y datáfonos' },
  entretenimiento: { label: 'Entretenimiento',     descripcion: 'Cuentas de streaming' },
}

export const CLAVES_HOTEL: ClaveHotel[] = [
  // ── Acceso y seguridad ────────────────────────────────────────
  {
    id: 'nvr-admin',
    nombre: 'Clave admin NVR',
    usuario: 'admin',
    clave: 'sM1357900',
    notas: 'Para ambos NVR Critical y Break',
    categoria: 'acceso',
  },
  {
    id: 'cifrado-critical',
    nombre: 'Código cifrado Critical',
    usuario: '',
    clave: 'Critical2024',
    categoria: 'acceso',
  },
  {
    id: 'cifrado-break',
    nombre: 'Código cifrado Break',
    usuario: '',
    clave: 'BREAK1',
    categoria: 'acceso',
  },
  {
    id: 'camaras-pc',
    nombre: 'Cámaras PC',
    usuario: 'hotelbreak',
    clave: 'Break53400',
    categoria: 'acceso',
  },
  {
    id: 'camaras-celular',
    nombre: 'Cámaras celular',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Break53400',
    categoria: 'acceso',
  },
  {
    id: 'yale-chapas',
    nombre: 'Yale chapas',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Break5340.',
    notas: 'Para controlar todas las chapas',
    categoria: 'acceso',
  },
  {
    id: 'clave-maestra',
    nombre: 'Clave maestra',
    usuario: 'Todas las chapas',
    clave: '25751',
    notas: 'Abre todas las puertas',
    categoria: 'acceso',
  },

  // ── Redes y TV ────────────────────────────────────────────────
  {
    id: 'movistar-tv',
    nombre: 'Movistar TV',
    usuario: 'diazpinillealejandro@gmail.com',
    clave: 'Brillo1002C$',
    notas: 'Para ver TV nacional',
    categoria: 'redes',
  },
  {
    id: 'omada',
    nombre: 'Omada',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Break5340.',
    notas: 'Controla el wifi del edificio',
    categoria: 'redes',
  },
  {
    id: 'wifi-admin',
    nombre: 'Wifi administración',
    usuario: 'Break-admin',
    clave: 'Break53400',
    notas: 'Solo para administración',
    categoria: 'redes',
  },
  {
    id: 'wifi-huespedes',
    nombre: 'Wifi huéspedes',
    usuario: 'Break-huespedes',
    clave: '534020266',
    notas: 'Solo para los huéspedes',
    categoria: 'redes',
  },
  {
    id: 'wifi-recepcion',
    nombre: 'Wifi recepción',
    usuario: 'Break Recepción',
    clave: 'o7^\\',
    notas: 'El de Movistar original',
    categoria: 'redes',
  },

  // ── Correo y nubes ────────────────────────────────────────────
  {
    id: 'gmail',
    nombre: 'Gmail',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Bre@k6871*',
    categoria: 'cuentas',
  },
  {
    id: 'icloud',
    nombre: 'iCloud',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Apartaestudio5340.',
    notas: 'iCloud de Apple',
    categoria: 'cuentas',
  },

  // ── Canales y reservas ────────────────────────────────────────
  {
    id: 'instagram',
    nombre: 'Instagram',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Break108038660',
    notas: 'Instagram nuevo Break',
    categoria: 'canales',
  },
  {
    id: 'octorate-antiguo',
    nombre: 'Octorate antiguo',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Break40553',
    notas: 'El de Alojamiento Colombia',
    categoria: 'canales',
  },
  {
    id: 'octorate-nuevo',
    nombre: 'Octorate nuevo',
    usuario: 'Breakhotel',
    clave: 'Break40553',
    notas: 'Nuestro propio',
    categoria: 'canales',
  },
  {
    id: 'booking',
    nombre: 'Booking',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Bre@k6871*',
    notas: 'Cuenta Booking',
    categoria: 'canales',
  },
  {
    id: 'airbnb',
    nombre: 'Airbnb',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Bre@k6871*',
    notas: 'Cuenta Airbnb',
    extra: 'Break534010',
    categoria: 'canales',
  },
  {
    id: 'trivago',
    nombre: 'Trivago',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Break5340.',
    notas: 'Cuenta Trivago',
    categoria: 'canales',
  },
  {
    id: 'pxsol',
    nombre: 'Cuenta PXSOL',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'hotel53400',
    categoria: 'canales',
  },
  {
    id: 'expedia',
    nombre: 'Cuenta Expedia',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Vedqur-5goddo-jygytub',
    categoria: 'canales',
  },

  // ── Finanzas ──────────────────────────────────────────────────
  {
    id: 'dian',
    nombre: 'DIAN',
    usuario: '1053830247',
    clave: '1053830247Bmm.',
    notas: 'DIAN Brandon persona natural',
    categoria: 'finanzas',
  },
  {
    id: 'rnt',
    nombre: 'RNT',
    usuario: '1053830247',
    clave: 'Brandon1053830247*',
    notas: 'Registro Nacional de Turismo · 273625, 273626, 273627',
    categoria: 'finanzas',
  },
  {
    id: 'siigo',
    nombre: 'Siigo',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'J%7wTKyagt',
    notas: 'Facturación electrónica',
    categoria: 'finanzas',
  },
  {
    id: 'link-pago',
    nombre: 'Link de pago',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Hotel534020266*',
    categoria: 'finanzas',
  },
  {
    id: 'datafono',
    nombre: 'Datáfono',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: '5340266',
    notas: 'Cuenta datáfono',
    categoria: 'finanzas',
  },
  {
    id: 'datafono-bolt',
    nombre: 'Datáfono Bolt',
    usuario: 'Pin de inicio',
    clave: '534020266',
    categoria: 'finanzas',
  },
  {
    id: 'datafono-redeban',
    nombre: 'Datáfono Redeban',
    usuario: 'Clave administrador',
    clave: '15266',
    notas: 'Teléfono soporte 3108510065',
    categoria: 'finanzas',
  },
  {
    id: 'usuario-redeban',
    nombre: 'Usuario Redeban',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Break534020266*',
    notas: 'Teléfono soporte 3108510065',
    categoria: 'finanzas',
  },
  {
    id: 'credibanco',
    nombre: 'Credibanco',
    usuario: 'BREAK_SERVICIOS_TURL_1-operador',
    clave: 'Break.534020266*',
    notas: 'Terminal BJ26XE',
    categoria: 'finanzas',
  },
  {
    id: 'credibanco-admin',
    nombre: 'Credibanco admin',
    usuario: 'admin-pagos',
    clave: 'Break.534020266*',
    categoria: 'finanzas',
  },
  {
    id: 'credibanco-operador',
    nombre: 'Credibanco operador',
    usuario: 'operadorbreak',
    clave: 'Breakoperador5340%',
    categoria: 'finanzas',
  },
  {
    id: 'hub-credibanco',
    nombre: 'Hub Connect Credibanco',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Break.534020266*',
    categoria: 'finanzas',
  },

  // ── Entretenimiento ───────────────────────────────────────────
  {
    id: 'netflix-1',
    nombre: 'Netflix 1',
    usuario: 'mauriciozulaga100@gmail.com',
    clave: 'M10286871',
    notas: 'Ingreso con Gmail',
    categoria: 'entretenimiento',
  },
  {
    id: 'netflix-2',
    nombre: 'Netflix 2',
    usuario: 'hotelbreakmanizales@gmail.com',
    clave: 'Bre@k6871*',
    notas: 'Ingreso con Gmail',
    categoria: 'entretenimiento',
  },
]
