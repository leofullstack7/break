// Tipos TypeScript que reflejan el esquema de Supabase
// Nova los mantiene sincronizados con database.md
// Ariel los usa en todos los componentes y hooks

export type RolUsuario = 'gerente' | 'recepcion' | 'aseo' | 'marketing' | 'huesped'

export type EstadoHabitacion = 'disponible' | 'ocupada' | 'aseo' | 'mantenimiento'

export type EstadoReserva = 'pendiente' | 'confirmada' | 'activa' | 'completada' | 'cancelada'

export type EstadoHospedaje =
  | 'libre'
  | 'reserva_futura'
  | 'hospedado'           // todavía está en el hotel
  | 'checkout_pendiente'  // la fecha pasó y aún no se registra la salida
  | 'bloqueada'           // fuera de venta / bloqueo PxSol (estado_habitacion=mantenimiento)
  | 'aseo'

export type TipoAseo = 'salida' | 'mantenimiento' | 'diario'
export type EstadoAseo = 'pendiente' | 'en_proceso' | 'completado'
export type TipoFinanza = 'ingreso' | 'egreso' | 'comision'

// ── TABLAS ──────────────────────────────────────────────────────

export interface Habitacion {
  id: string
  numero: number
  piso: 1 | 2 | 3 | 4
  tipo: string
  capacidad: number
  estado: EstadoHabitacion
  precio_base: number
  chat_token: string | null
  created_at: string
  updated_at: string
}

export type ChatMensajeTipo = 'texto' | 'imagen' | 'audio'
export type ChatMensajeRol = 'huesped' | 'admin' | 'bot' | 'sistema'

export interface Chat {
  id: string
  habitacion_id: string | null
  reserva_id: string | null
  huesped_id: string | null
  titulo: string | null
  estado: 'abierto' | 'cerrado' | 'bot_activo'
  bot_activo: boolean
  ultimo_mensaje_at: string | null
  ultimo_mensaje: string | null
  ultimo_rol: ChatMensajeRol | null
  no_leidos_admin: number
  no_leidos_huesped: number
  created_at: string
  updated_at: string
}

export interface ChatMensaje {
  id: string
  chat_id: string
  rol: ChatMensajeRol
  autor_id: string | null
  contenido: string
  tipo: ChatMensajeTipo
  media_path: string | null
  metadata: Record<string, unknown> | null
  created_at: string
}

export interface Huesped {
  id: string
  nombre: string
  cedula: string
  celular: string | null
  correo: string | null
  nacionalidad: string             // default: 'colombiana'
  notas: string | null
  fecha_registro: string
  deleted_at: string | null
  siigo_tercero_id: string | null
  siigo_sync_at: string | null
  created_at: string
  updated_at: string
}

export interface Operador {
  id: string
  nombre: string
  porcentaje_comision: number
  activo: boolean
  created_at: string
}

export interface Reserva {
  id: string
  habitacion_id: string
  huesped_id: string
  acompanante: string | null
  fecha_entrada: string
  fecha_salida: string
  noches: number                   // calculado automáticamente
  pago_total: number
  comision: number | null          // calculada automáticamente por trigger
  operador_id: string | null
  metodo_pago: string | null
  incluye_aseo: boolean
  incluye_break: boolean
  estado: EstadoReserva
  observaciones: string | null
  deleted_at: string | null
  created_at: string
  updated_at: string
  canal_origen: string | null      // 'Airbnb', 'Booking.com', 'Directo', etc.
  pxsol_booking_id: string | null
  pxsol_raw: Record<string, unknown> | null
  pxsol_sync_at: string | null
  siigo_estado: string | null
  siigo_factura_id: string | null
  siigo_numero: string | null
  siigo_cufe: string | null
  siigo_pdf_url: string | null
  siigo_error: string | null
  siigo_sync_at: string | null
  siigo_autorizado_por: string | null
  siigo_autorizado_at: string | null
}

export interface Aseo {
  id: string
  habitacion_id: string
  reserva_id: string | null
  fecha: string
  estado: EstadoAseo
  tipo_aseo: TipoAseo
  responsable: string | null
  observaciones: string | null
  created_at: string
  updated_at: string
}

export interface Lavanderia {
  id: string
  fecha: string
  habitacion_id: string | null
  tipo_prenda: string
  cantidad: number
  tiempo_minutos: number | null
  estado: 'en_proceso' | 'listo' | 'entregado'
  responsable: string | null
  created_at: string
}

export interface Finanza {
  id: string
  reserva_id: string | null
  concepto: string
  monto: number
  tipo: TipoFinanza
  fecha: string
  created_at: string
}

export interface Usuario {
  id: string
  nombre: string
  rol: RolUsuario
  email: string
  activo: boolean
  created_at: string
  updated_at: string
}

// ── VISTAS ──────────────────────────────────────────────────────

// v_mapa_habitaciones — lo que el dashboard admin muestra en tiempo real
export interface MapaHabitacion {
  habitacion_id: string
  numero: number
  piso: number
  estado_habitacion: EstadoHabitacion
  precio_base: number
  // Datos de la reserva activa (null si está libre)
  reserva_id: string | null
  fecha_entrada: string | null
  fecha_salida: string | null
  noches: number | null
  pago_total: number | null
  estado_reserva: EstadoReserva | null
  acompanante: string | null
  // Datos del huésped (null si está libre)
  huesped_id: string | null
  huesped_nombre: string | null
  huesped_celular: string | null
  huesped_nacionalidad: string | null
  // Estado en tiempo real — LA CLAVE DEL DASHBOARD
  estado_hospedaje: EstadoHospedaje
  dias_restantes: number | null    // negativo = checkout vencido (alerta)
}

// v_ocupacion_mensual — reporte financiero
export interface OcupacionMensual {
  mes: string
  total_reservas: number
  noches_ocupadas: number
  habitaciones_activas: number
  porcentaje_ocupacion: number
  ingresos_brutos: number
  total_comisiones: number
  ingresos_netos: number
}

export interface IntegracionConfig {
  clave: string
  valor: string
  expira_en: string | null
  actualizado_en: string
}

export type SiigoEstadoVoucher = 'pendiente' | 'facturado' | 'nota_credito' | 'error' | 'omitido'

export interface PxsolVoucher {
  id: number
  booking_id: string | null
  reserva_id: string | null
  folio_id: number | null
  folio_name: string | null
  voucher_type: string | null
  group_type: string | null
  status: string | null
  payment_type: string | null
  payment_status: string | null
  currency: string | null
  sub_total: number | null
  iva: number | null
  other_taxes: number | null
  total: number | null
  fecha_voucher: string | null
  fecha_vencimiento: string | null
  huesped_nombre: string | null
  huesped_tipo_doc: string | null
  huesped_num_doc: string | null
  huesped_email: string | null
  huesped_tipo_persona: string | null
  has_credit_note: boolean
  credit_note: boolean
  credit_note_voucher_id: number | null
  pxsol_pdf_url: string | null
  voucher_raw: Record<string, unknown> | null
  pxsol_sync_at: string | null
  siigo_estado: SiigoEstadoVoucher
  siigo_factura_id: string | null
  siigo_numero: string | null
  siigo_cufe: string | null
  siigo_pdf_url: string | null
  siigo_error: string | null
  siigo_intentos: number
  siigo_sync_at: string | null
  created_at: string
}

export interface SiigoCatalogoMap {
  id: number
  tipo: 'producto' | 'forma_pago' | 'impuesto' | 'documento_identidad' | 'ciudad'
  clave_pxsol: string
  valor_siigo: string
  descripcion: string | null
  activo: boolean
  created_at: string
}

export interface SyncLog {
  id: number
  integracion: 'pxsol' | 'siigo'
  evento: string
  referencia_id: string | null
  estado: 'ok' | 'error'
  detalle: Record<string, unknown> | null
  created_at: string
}

export type PxsolWriteTipo =
  | 'editar_huesped'
  | 'agregar_acompanante'
  | 'check_in'
  | 'check_out'
  | 'actualizar_reserva'

export type PxsolWriteEstado =
  | 'pendiente_aprobacion'
  | 'aprobado'
  | 'rechazado'
  | 'enviado'
  | 'error'

export interface PxsolWriteQueueItem {
  id: number
  tipo: PxsolWriteTipo
  booking_id: string | null
  reserva_id: string | null
  payload: Record<string, unknown>
  estado: PxsolWriteEstado
  solicitado_por: string | null
  aprobado_por: string | null
  aprobado_at: string | null
  pxsol_response: Record<string, unknown> | null
  error: string | null
  created_at: string
  sent_at: string | null
}

// ── TIPO DATABASE PARA SUPABASE CLIENT ──────────────────────────

export interface Database {
  public: {
    Tables: {
      habitaciones: {
        Row: Habitacion
        Insert: Omit<Habitacion, 'id' | 'created_at' | 'updated_at' | 'chat_token'> & { chat_token?: string | null }
        Update: Partial<Omit<Habitacion, 'id' | 'created_at' | 'updated_at'>>
      }
      huespedes: {
        Row: Huesped
        Insert: Omit<Huesped, 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Omit<Huesped, 'id' | 'created_at' | 'updated_at'>>
      }
      operadores: {
        Row: Operador
        Insert: Omit<Operador, 'id' | 'created_at'>
        Update: Partial<Omit<Operador, 'id' | 'created_at'>>
      }
      reservas: {
        Row: Reserva
        Insert: Omit<Reserva, 'id' | 'noches' | 'comision' | 'created_at' | 'updated_at'>
        Update: Partial<Omit<Reserva, 'id' | 'noches' | 'created_at' | 'updated_at'>>
      }
      integraciones_config: {
        Row: IntegracionConfig
        Insert: Omit<IntegracionConfig, 'actualizado_en'>
        Update: Partial<IntegracionConfig>
      }
      aseos: {
        Row: Aseo
        Insert: Omit<Aseo, 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Omit<Aseo, 'id' | 'created_at' | 'updated_at'>>
      }
      lavanderia: {
        Row: Lavanderia
        Insert: Omit<Lavanderia, 'id' | 'created_at'>
        Update: Partial<Omit<Lavanderia, 'id' | 'created_at'>>
      }
      finanzas: {
        Row: Finanza
        Insert: Omit<Finanza, 'id' | 'created_at'>
        Update: Partial<Omit<Finanza, 'id' | 'created_at'>>
      }
      usuarios: {
        Row: Usuario
        Insert: Omit<Usuario, 'created_at' | 'updated_at'>
        Update: Partial<Omit<Usuario, 'id' | 'created_at' | 'updated_at'>>
      }
      pxsol_vouchers: {
        Row: PxsolVoucher
        Insert: Omit<PxsolVoucher, 'created_at'>
        Update: Partial<Omit<PxsolVoucher, 'id' | 'created_at'>>
      }
      siigo_catalogo_map: {
        Row: SiigoCatalogoMap
        Insert: Omit<SiigoCatalogoMap, 'id' | 'created_at'>
        Update: Partial<Omit<SiigoCatalogoMap, 'id' | 'created_at'>>
      }
      sync_logs: {
        Row: SyncLog
        Insert: Omit<SyncLog, 'id' | 'created_at'>
        Update: Partial<Omit<SyncLog, 'id' | 'created_at'>>
      }
      pxsol_write_queue: {
        Row: PxsolWriteQueueItem
        Insert: Omit<PxsolWriteQueueItem, 'id' | 'created_at' | 'sent_at' | 'aprobado_at' | 'pxsol_response' | 'error'>
        Update: Partial<Omit<PxsolWriteQueueItem, 'id' | 'created_at'>>
      }
      chats: {
        Row: Chat
        Insert: Omit<Chat, 'id' | 'created_at' | 'updated_at' | 'no_leidos_admin' | 'no_leidos_huesped'>
        Update: Partial<Omit<Chat, 'id' | 'created_at'>>
      }
      chat_mensajes: {
        Row: ChatMensaje
        Insert: Omit<ChatMensaje, 'id' | 'created_at'>
        Update: Partial<Omit<ChatMensaje, 'id' | 'created_at'>>
      }
    }
    Views: {
      v_mapa_habitaciones: { Row: MapaHabitacion }
      v_ocupacion_mensual: { Row: OcupacionMensual }
    }
    Functions: {
      habitacion_disponible: {
        Args: {
          p_habitacion_id: string
          p_fecha_entrada: string
          p_fecha_salida: string
        }
        Returns: boolean
      }
      get_mi_rol: { Args: Record<never, never>; Returns: string }
      chat_habitacion_por_token: { Args: { p_token: string }; Returns: Record<string, unknown> }
      chat_enviar_huesped: {
        Args: { p_token: string; p_tipo: string; p_contenido: string; p_media_path?: string | null }
        Returns: Record<string, unknown>
      }
      chat_marcar_leido_huesped: { Args: { p_token: string }; Returns: undefined }
      chat_marcar_leido_admin: { Args: { p_chat_id: string }; Returns: undefined }
    }
  }
}
