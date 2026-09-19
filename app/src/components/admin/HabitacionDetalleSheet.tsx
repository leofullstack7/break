import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import {
  X, User, Users, BedDouble, CalendarDays, MessageCircle,
  Phone, Mail, MapPin, ExternalLink, FileImage, Building2,
} from 'lucide-react'
import { useQuery } from '@tanstack/react-query'
import { supabase } from '@/lib/supabase'
import { abrirPxsolConversaciones } from '@/lib/pxsol-conversaciones'
import type { MapaHabitacion } from '@/types/database.types'

interface Props {
  habitacion: MapaHabitacion | null
  onClose: () => void
}

type Tab = 'estado' | 'huesped' | 'chat'

type FormularioCheckin = {
  id: string
  nombre: string
  numero_identificacion: string
  correo: string | null
  whatsapp: string | null
  ciudad: string | null
  pais_residencia: string | null
  nacionalidad_pais: string | null
  fecha_llegada: string | null
  tiene_acompanante: boolean
  acompanante_nombre: string | null
  acompanante_documento: string | null
  acompanante_mayor_edad: string | null
  facturacion_misma: boolean
  facturacion_tipo_documento: string | null
  facturacion_documento: string | null
  facturacion_nombre: string | null
  facturacion_telefono: string | null
  facturacion_correo: string | null
  documento_frente_path: string | null
  documento_reverso_path: string | null
}

async function fetchDetalleReserva(reservaId: string | null) {
  if (!reservaId) return null
  const { data, error } = await supabase
    .from('reservas')
    .select(`
      id, estado, fecha_entrada, fecha_salida, noches, pago_total,
      acompanante, cc_acompanante, canal_origen, observaciones,
      metodo_pago, pxsol_booking_id, pxsol_raw, formulario_checkin_id,
      huespedes(id, nombre, cedula, celular, correo, nacionalidad)
    `)
    .eq('id', reservaId)
    .maybeSingle()
  if (error) throw error
  return data
}

async function fetchFormulario(formId: string | null, huespedId: string | null) {
  if (formId) {
    const { data } = await supabase
      .from('formulario_checkin')
      .select('*')
      .eq('id', formId)
      .maybeSingle()
    if (data) return data as FormularioCheckin
  }
  if (huespedId) {
    const { data } = await supabase
      .from('formulario_checkin')
      .select('*')
      .eq('huesped_id', huespedId)
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle()
    if (data) return data as FormularioCheckin
  }
  return null
}

async function signedDocUrl(path: string | null): Promise<string | null> {
  if (!path) return null
  const { data, error } = await supabase.storage
    .from('formulario-documentos')
    .createSignedUrl(path, 3600)
  if (error || !data?.signedUrl) return null
  return data.signedUrl
}

const LABEL_ESTADO: Record<string, string> = {
  libre: 'Libre',
  reserva_futura: 'Reservada',
  hospedado: 'Hospedado',
  checkout_pendiente: 'Check-out pendiente',
  bloqueada: 'Bloqueada',
  aseo: 'En aseo',
  mantenimiento: 'Bloqueada / mantenimiento',
  disponible: 'Disponible',
  ocupada: 'Ocupada',
}

function labelEstadoHab(h: NonNullable<Props['habitacion']>): string {
  if (h.estado_habitacion === 'mantenimiento') return 'Bloqueada'
  if (h.estado_habitacion === 'aseo') return 'En aseo'
  return LABEL_ESTADO[h.estado_hospedaje] ?? h.estado_hospedaje
}

export function HabitacionDetalleSheet({ habitacion, onClose }: Props) {
  const abierto = !!habitacion
  const [tab, setTab] = useState<Tab>('estado')
  const navigate = useNavigate()

  useEffect(() => {
    if (!abierto) return
    setTab(habitacion?.reserva_id ? 'huesped' : 'estado')
    document.body.style.overflow = 'hidden'
    return () => { document.body.style.overflow = '' }
  }, [abierto, habitacion?.habitacion_id, habitacion?.reserva_id])

  const { data: detalle } = useQuery({
    queryKey: ['hab-detalle', habitacion?.reserva_id],
    queryFn: () => fetchDetalleReserva(habitacion?.reserva_id ?? null),
    enabled: !!habitacion?.reserva_id,
  })

  const huesped = (detalle as { huespedes?: {
    id?: string; nombre?: string; cedula?: string; celular?: string; correo?: string; nacionalidad?: string
  } } | null)?.huespedes

  const formId = (detalle as { formulario_checkin_id?: string } | null)?.formulario_checkin_id ?? null

  const { data: form } = useQuery({
    queryKey: ['hab-formulario', formId, huesped?.id],
    queryFn: () => fetchFormulario(formId, huesped?.id ?? null),
    enabled: !!habitacion?.reserva_id && (!!formId || !!huesped?.id),
  })

  const { data: docUrls } = useQuery({
    queryKey: ['hab-docs', form?.documento_frente_path, form?.documento_reverso_path],
    queryFn: async () => ({
      frente: await signedDocUrl(form?.documento_frente_path ?? null),
      reverso: await signedDocUrl(form?.documento_reverso_path ?? null),
    }),
    enabled: !!(form?.documento_frente_path || form?.documento_reverso_path),
  })

  const raw = (detalle as { pxsol_raw?: Record<string, unknown> } | null)?.pxsol_raw ?? null
  const phys = Array.isArray(raw?.physical_rooms) ? (raw!.physical_rooms as { name?: string; category_code?: string; assigned?: boolean }[])[0] : null
  const bookingId = (detalle as { pxsol_booking_id?: string } | null)?.pxsol_booking_id ?? null
  const telefono = form?.whatsapp ?? huesped?.celular ?? habitacion?.huesped_celular ?? null
  const nombre = form?.nombre ?? huesped?.nombre ?? habitacion?.huesped_nombre ?? null
  const cedula = form?.numero_identificacion
    ?? (huesped?.cedula && !String(huesped.cedula).startsWith('PXSOL-') && !String(huesped.cedula).startsWith('SIN_CC_')
      ? huesped.cedula
      : null)
  const correo = form?.correo ?? huesped?.correo ?? null
  const acompanante = form?.acompanante_nombre
    ?? (detalle as { acompanante?: string } | null)?.acompanante
    ?? null
  const ccAcompanante = form?.acompanante_documento
    ?? (detalle as { cc_acompanante?: string } | null)?.cc_acompanante
    ?? null

  function irAConversaciones() {
    abrirPxsolConversaciones({
      bookingId,
      telefono,
      nombre,
      habitacion: habitacion?.numero,
    })
  }

  return (
    <AnimatePresence>
      {abierto && habitacion && (
        <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-negro-absoluto/80 backdrop-blur-sm"
            onClick={onClose}
          />

          <motion.div
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', stiffness: 320, damping: 32 }}
            className="relative w-full max-w-lg sm:max-w-xl max-h-[92dvh] sm:max-h-[88vh] bg-negro-profundo border border-white/10 rounded-t-3xl sm:rounded-2xl flex flex-col overflow-hidden shadow-2xl"
          >
            <div className="sm:hidden flex justify-center pt-2 pb-1">
              <div className="w-10 h-1 rounded-full bg-white/20" />
            </div>

            <header className="px-4 sm:px-5 pb-3 pt-1 border-b border-white/5 shrink-0">
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0">
                  <p className="text-body-xs uppercase tracking-wider text-blanco-roto/35">Habitación</p>
                  <h2 className="font-display text-xl font-semibold text-blanco-roto flex items-center gap-2">
                    <BedDouble size={18} className="text-dorado shrink-0" />
                    {habitacion.numero}
                    <span className="text-body-sm font-normal text-blanco-roto/40">· Piso {habitacion.piso}</span>
                  </h2>
                  <p className="text-body-sm text-dorado/90 mt-0.5">
                    {labelEstadoHab(habitacion)}
                  </p>
                </div>
                <button
                  type="button"
                  onClick={onClose}
                  className="p-2 rounded-xl text-blanco-roto/40 hover:text-blanco-roto hover:bg-white/5"
                  aria-label="Cerrar"
                >
                  <X size={18} />
                </button>
              </div>

              {/* CTA principal: chat WhatsApp vía PxSol */}
              <button
                type="button"
                onClick={irAConversaciones}
                className="mt-3 w-full flex items-center justify-center gap-2 py-3 rounded-xl bg-dorado text-negro-absoluto font-semibold text-body-sm active:scale-[0.98] transition-transform"
              >
                <MessageCircle size={16} />
                Abrir chat en PxSol Conversaciones
                <ExternalLink size={14} className="opacity-70" />
              </button>

              <div className="mt-3 grid grid-cols-3 gap-1 p-1 rounded-xl bg-white/[0.04]">
                {([
                  ['estado', 'Estado'],
                  ['huesped', 'Huésped'],
                  ['chat', 'Chat'],
                ] as const).map(([id, label]) => (
                  <button
                    key={id}
                    type="button"
                    onClick={() => setTab(id)}
                    className={`py-2 rounded-lg text-body-xs font-medium transition-colors ${
                      tab === id ? 'bg-white/10 text-blanco-roto' : 'text-blanco-roto/50 hover:text-blanco-roto'
                    }`}
                  >
                    {label}
                  </button>
                ))}
              </div>
            </header>

            <div className="flex-1 overflow-y-auto overscroll-contain px-4 sm:px-5 py-4 min-h-0"
              style={{ paddingBottom: 'max(1rem, env(safe-area-inset-bottom))' }}
            >
              {tab === 'estado' && (
                <div className="space-y-4">
                  <div className="grid grid-cols-2 gap-3">
                    <InfoChip label="Estado habitación" value={habitacion.estado_habitacion} />
                    <InfoChip label="Hospedaje" value={labelEstadoHab(habitacion)} />
                    <InfoChip label="Entrada" value={habitacion.fecha_entrada ?? '—'} icon={CalendarDays} />
                    <InfoChip label="Salida" value={habitacion.fecha_salida ?? '—'} icon={CalendarDays} />
                    <InfoChip label="Noches" value={habitacion.noches?.toString() ?? '—'} />
                    <InfoChip
                      label="Días restantes"
                      value={habitacion.dias_restantes != null ? String(habitacion.dias_restantes) : '—'}
                    />
                  </div>

                  {phys && (
                    <div className="glass rounded-xl p-3 text-body-sm text-blanco-roto/70 space-y-1">
                      <p className="text-body-xs uppercase tracking-wider text-blanco-roto/35">PxSol · asignación</p>
                      <p>Hab. física <span className="text-blanco-roto font-medium">{phys.name}</span></p>
                      {phys.category_code && <p>Categoría {phys.category_code}</p>}
                      {phys.assigned != null && <p>{phys.assigned ? 'Asignada' : 'Sin asignar'}</p>}
                    </div>
                  )}

                  {(detalle as { observaciones?: string } | null)?.observaciones && (
                    <div className="glass rounded-xl p-3">
                      <p className="text-body-xs uppercase tracking-wider text-blanco-roto/35 mb-1">Notas</p>
                      <p className="text-body-sm text-blanco-roto/75 whitespace-pre-wrap">
                        {(detalle as { observaciones: string }).observaciones}
                      </p>
                    </div>
                  )}

                  {!habitacion.reserva_id && (
                    <p className="text-body-sm text-blanco-roto/40 text-center py-6">
                      Sin reserva activa en esta habitación.
                    </p>
                  )}
                </div>
              )}

              {tab === 'huesped' && (
                <div className="space-y-4">
                  {huesped || habitacion.huesped_nombre || form ? (
                    <>
                      {form && (
                        <p className="text-body-xs text-dorado/80 uppercase tracking-wider">
                          Datos del formulario de llegada
                        </p>
                      )}

                      <div className="glass rounded-xl p-4 space-y-3">
                        <div className="flex items-center gap-2 text-dorado">
                          <User size={16} />
                          <span className="text-body-xs uppercase tracking-wider">Titular</span>
                        </div>
                        <p className="text-lg text-blanco-roto font-medium">{nombre}</p>
                        <div className="space-y-2 text-body-sm text-blanco-roto/65">
                          {cedula && <p>Documento: <span className="font-mono text-blanco-roto/85">{cedula}</span></p>}
                          {telefono && (
                            <p className="flex items-center gap-2">
                              <Phone size={14} className="text-blanco-roto/30" />
                              {telefono}
                            </p>
                          )}
                          {correo && (
                            <p className="flex items-center gap-2 break-all">
                              <Mail size={14} className="text-blanco-roto/30 shrink-0" />
                              {correo}
                            </p>
                          )}
                          {(form?.ciudad || form?.pais_residencia || huesped?.nacionalidad || habitacion.huesped_nacionalidad) && (
                            <p className="flex items-center gap-2">
                              <MapPin size={14} className="text-blanco-roto/30" />
                              {[form?.ciudad, form?.pais_residencia || form?.nacionalidad_pais || huesped?.nacionalidad || habitacion.huesped_nacionalidad]
                                .filter(Boolean)
                                .join(' · ')}
                            </p>
                          )}
                          {form?.fecha_llegada && (
                            <p className="flex items-center gap-2">
                              <CalendarDays size={14} className="text-blanco-roto/30" />
                              Llegada declarada: {form.fecha_llegada}
                            </p>
                          )}
                        </div>
                      </div>

                      <div className="glass rounded-xl p-4 space-y-2">
                        <div className="flex items-center gap-2 text-dorado">
                          <Users size={16} />
                          <span className="text-body-xs uppercase tracking-wider">Acompañantes</span>
                        </div>
                        {acompanante ? (
                          <div className="text-body-sm text-blanco-roto/75">
                            <p>{acompanante}</p>
                            {ccAcompanante && (
                              <p className="text-blanco-roto/45">CC {ccAcompanante}</p>
                            )}
                            {form?.acompanante_mayor_edad && (
                              <p className="text-blanco-roto/45">
                                Mayor de edad: {form.acompanante_mayor_edad === 'si' ? 'Sí' : form.acompanante_mayor_edad === 'no' ? 'No' : form.acompanante_mayor_edad}
                              </p>
                            )}
                          </div>
                        ) : (
                          <p className="text-body-sm text-blanco-roto/40">Sin acompañante registrado.</p>
                        )}
                      </div>

                      {form && (
                        <div className="glass rounded-xl p-4 space-y-2">
                          <div className="flex items-center gap-2 text-dorado">
                            <Building2 size={16} />
                            <span className="text-body-xs uppercase tracking-wider">Facturación</span>
                          </div>
                          {form.facturacion_misma ? (
                            <p className="text-body-sm text-blanco-roto/65">Misma información del huésped principal</p>
                          ) : (
                            <div className="text-body-sm text-blanco-roto/65 space-y-1">
                              {form.facturacion_nombre && <p>{form.facturacion_nombre}</p>}
                              {(form.facturacion_tipo_documento || form.facturacion_documento) && (
                                <p className="font-mono text-blanco-roto/80">
                                  {[form.facturacion_tipo_documento, form.facturacion_documento].filter(Boolean).join(' ')}
                                </p>
                              )}
                              {form.facturacion_telefono && <p>{form.facturacion_telefono}</p>}
                              {form.facturacion_correo && <p className="break-all">{form.facturacion_correo}</p>}
                            </div>
                          )}
                        </div>
                      )}

                      {(docUrls?.frente || docUrls?.reverso) && (
                        <div className="glass rounded-xl p-4 space-y-3">
                          <div className="flex items-center gap-2 text-dorado">
                            <FileImage size={16} />
                            <span className="text-body-xs uppercase tracking-wider">Documento de identidad</span>
                          </div>
                          <div className="grid grid-cols-2 gap-2">
                            {docUrls.frente && (
                              <a href={docUrls.frente} target="_blank" rel="noreferrer" className="block rounded-lg overflow-hidden border border-white/10 hover:border-dorado/40">
                                <img src={docUrls.frente} alt="Frente documento" className="w-full h-28 object-cover bg-negro-absoluto" />
                                <p className="text-[0.65rem] text-center py-1 text-blanco-roto/50">Frente</p>
                              </a>
                            )}
                            {docUrls.reverso && (
                              <a href={docUrls.reverso} target="_blank" rel="noreferrer" className="block rounded-lg overflow-hidden border border-white/10 hover:border-dorado/40">
                                <img src={docUrls.reverso} alt="Reverso documento" className="w-full h-28 object-cover bg-negro-absoluto" />
                                <p className="text-[0.65rem] text-center py-1 text-blanco-roto/50">Reverso</p>
                              </a>
                            )}
                          </div>
                        </div>
                      )}

                      <div className="grid grid-cols-2 gap-3">
                        <InfoChip label="Canal" value={(detalle as { canal_origen?: string } | null)?.canal_origen ?? '—'} />
                        <InfoChip label="Booking PxSol" value={bookingId ?? '—'} />
                      </div>
                    </>
                  ) : (
                    <p className="text-body-sm text-blanco-roto/40 text-center py-8">
                      Habitación libre · sin huésped asociado.
                    </p>
                  )}
                </div>
              )}

              {tab === 'chat' && (
                <div className="flex flex-col items-center text-center gap-4 py-6 px-2">
                  <div className="w-14 h-14 rounded-2xl bg-dorado/15 border border-dorado/25 flex items-center justify-center">
                    <MessageCircle className="text-dorado" size={26} />
                  </div>
                  <div className="space-y-2 max-w-sm">
                    <h3 className="text-blanco-roto font-medium">Chat de la habitación {habitacion.numero}</h3>
                    <p className="text-body-sm text-blanco-roto/50 leading-relaxed">
                      El huésped escribe desde el QR del estudio. Aquí ves el hilo con recepción
                      {nombre ? ` · ${nombre}` : ''}.
                    </p>
                  </div>
                  <button
                    type="button"
                    onClick={() => {
                      onClose()
                      navigate(`/admin/conversaciones?hab=${habitacion.habitacion_id}`)
                    }}
                    className="w-full max-w-sm flex items-center justify-center gap-2 py-3.5 rounded-xl bg-dorado text-negro-absoluto font-semibold text-body-sm"
                  >
                    Abrir conversación
                  </button>
                  <button
                    type="button"
                    onClick={irAConversaciones}
                    className="text-body-xs text-blanco-roto/35 hover:text-blanco-roto/60 inline-flex items-center gap-1"
                  >
                    WhatsApp PxSol
                    <ExternalLink size={12} />
                  </button>
                </div>
              )}
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  )
}

function InfoChip({
  label,
  value,
  icon: Icon,
}: {
  label: string
  value: string
  icon?: React.ElementType
}) {
  return (
    <div className="glass rounded-xl p-3 min-w-0">
      <p className="text-[0.65rem] uppercase tracking-wider text-blanco-roto/35 mb-1 flex items-center gap-1">
        {Icon && <Icon size={11} />}
        {label}
      </p>
      <p className="text-body-sm text-blanco-roto truncate capitalize">{value}</p>
    </div>
  )
}
