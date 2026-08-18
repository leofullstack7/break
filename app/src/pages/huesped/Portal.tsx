import { useEffect, useState } from 'react'
import { useQuery, useMutation } from '@tanstack/react-query'
import { LogIn, LogOut, Wifi, Phone, MapPin, Clock, CheckCircle2, Loader2 } from 'lucide-react'
import { supabase } from '@/lib/supabase'

interface ReservaActiva {
  id: string
  habitacion_id: string
  habitacion_numero: number
  fecha_entrada: string
  fecha_salida: string
  noches: number
  estado: string
  fecha_checkin_real: string | null
  fecha_checkout_real: string | null
  pago_total: number
}

async function fetchMiReserva(): Promise<ReservaActiva | null> {
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return null

  // Buscar huésped por email
  const { data: huesped } = await supabase
    .from('huespedes')
    .select('id')
    .eq('correo', user.email ?? '')
    .maybeSingle()

  if (!huesped) return null

  const hoy = new Date().toISOString().split('T')[0]

  // Buscar reserva activa o de hoy
  const { data } = await supabase
    .from('reservas')
    .select('id, habitacion_id, fecha_entrada, fecha_salida, noches, estado, fecha_checkin_real, fecha_checkout_real, pago_total, habitaciones(numero)')
    .eq('huesped_id', huesped.id)
    .in('estado', ['confirmada', 'activa'])
    .lte('fecha_entrada', hoy)
    .gte('fecha_salida', hoy)
    .order('fecha_entrada', { ascending: false })
    .limit(1)
    .maybeSingle()

  if (!data) return null

  return {
    id: data.id,
    habitacion_id: data.habitacion_id,
    habitacion_numero: (data as any).habitaciones?.numero ?? 0,
    fecha_entrada: data.fecha_entrada,
    fecha_salida: data.fecha_salida,
    noches: data.noches ?? 0,
    estado: data.estado,
    fecha_checkin_real: data.fecha_checkin_real,
    fecha_checkout_real: data.fecha_checkout_real,
    pago_total: data.pago_total,
  }
}

async function hacerCheckin(reservaId: string) {
  const { error } = await supabase
    .from('reservas')
    .update({
      estado: 'activa',
      fecha_checkin_real: new Date().toISOString(),
    })
    .eq('id', reservaId)
  if (error) throw error
}

async function hacerCheckout(reservaId: string) {
  const { error } = await supabase
    .from('reservas')
    .update({
      estado: 'completada',
      fecha_checkout_real: new Date().toISOString(),
    })
    .eq('id', reservaId)
  if (error) throw error
}

function formatFecha(f: string) {
  return new Date(f + 'T12:00:00').toLocaleDateString('es-CO', {
    weekday: 'long', day: 'numeric', month: 'long'
  })
}

function formatHora(ts: string) {
  return new Date(ts).toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit' })
}

export default function HuespedPortal() {
  const hoy = new Date().toISOString().split('T')[0]

  const { data: reserva, isLoading, refetch } = useQuery({
    queryKey: ['mi-reserva'],
    queryFn: fetchMiReserva,
    refetchInterval: 60_000,
  })

  const { mutate: checkin, isPending: checkingIn } = useMutation({
    mutationFn: () => hacerCheckin(reserva!.id),
    onSuccess: () => refetch(),
  })

  const { mutate: checkout, isPending: checkingOut } = useMutation({
    mutationFn: () => hacerCheckout(reserva!.id),
    onSuccess: () => refetch(),
  })

  const puedeCheckin  = reserva && reserva.estado === 'confirmada' && reserva.fecha_entrada <= hoy && !reserva.fecha_checkin_real
  const puedeCheckout = reserva && reserva.estado === 'activa' && reserva.fecha_checkin_real && !reserva.fecha_checkout_real
  const yaHizoCheckin = !!reserva?.fecha_checkin_real
  const yaHizoCheckout = !!reserva?.fecha_checkout_real

  if (isLoading) {
    return (
      <div className="min-h-screen bg-negro-absoluto flex items-center justify-center">
        <Loader2 size={32} className="text-dorado animate-spin" />
      </div>
    )
  }

  if (!reserva) {
    return (
      <div className="min-h-screen bg-negro-absoluto flex flex-col items-center justify-center p-8 text-center">
        <div className="w-16 h-16 rounded-2xl bg-dorado/10 border border-dorado/20 flex items-center justify-center mb-6">
          <LogIn size={24} className="text-dorado" />
        </div>
        <h1 className="font-display text-display-md font-bold text-blanco-roto mb-3">
          Sin reserva activa
        </h1>
        <p className="text-body-md text-blanco-roto/50 max-w-sm">
          No encontramos una reserva activa para hoy asociada a tu correo.
          Contacta al hotel si crees que hay un error.
        </p>
        <a
          href={`https://wa.me/57${''}`}
          className="mt-6 flex items-center gap-2 text-body-sm text-green-400 hover:text-green-300 transition-colors"
        >
          <Phone size={16} />
          Contactar al hotel
        </a>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-negro-absoluto pb-8">

      {/* Hero con número de habitación */}
      <div className="relative overflow-hidden bg-negro-profundo border-b border-white/5 px-6 py-10 text-center">
        <div className="absolute inset-0 bg-gradient-to-b from-dorado/5 to-transparent" />
        <div className="relative">
          <p className="text-body-xs text-dorado uppercase tracking-widest mb-2">Break Hotel · Manizales</p>
          <p className="text-body-md text-blanco-roto/50 mb-1">Tu habitación</p>
          <p className="font-display font-black text-dorado" style={{ fontSize: '6rem', lineHeight: 1 }}>
            {reserva.habitacion_numero}
          </p>
          <div className={`inline-flex items-center gap-2 mt-4 px-4 py-2 rounded-full text-body-sm font-semibold ${
            yaHizoCheckin && !yaHizoCheckout
              ? 'bg-green-900/40 border border-green-700/40 text-green-300'
              : yaHizoCheckout
                ? 'bg-zinc-800 border border-zinc-600 text-zinc-400'
                : 'bg-dorado/10 border border-dorado/30 text-dorado'
          }`}>
            <div className={`w-2 h-2 rounded-full ${yaHizoCheckin && !yaHizoCheckout ? 'bg-green-400 animate-pulse' : yaHizoCheckout ? 'bg-zinc-500' : 'bg-dorado'}`} />
            {yaHizoCheckout ? 'Check-out realizado' : yaHizoCheckin ? 'Hospedado' : 'Reserva confirmada'}
          </div>
        </div>
      </div>

      <div className="max-w-md mx-auto px-4 mt-6 space-y-4">

        {/* Fechas */}
        <div className="glass rounded-2xl p-5 space-y-3">
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Tu estadía</p>
          <div className="space-y-2">
            <div className="flex items-center gap-3">
              <LogIn size={16} className="text-green-400 shrink-0" />
              <div>
                <p className="text-body-xs text-blanco-roto/40">Check-in</p>
                <p className="text-body-sm text-blanco-roto capitalize">{formatFecha(reserva.fecha_entrada)}</p>
                {reserva.fecha_checkin_real && (
                  <p className="text-body-xs text-green-400">Realizado a las {formatHora(reserva.fecha_checkin_real)}</p>
                )}
              </div>
            </div>
            <div className="flex items-center gap-3">
              <LogOut size={16} className="text-amber-400 shrink-0" />
              <div>
                <p className="text-body-xs text-blanco-roto/40">Check-out</p>
                <p className="text-body-sm text-blanco-roto capitalize">{formatFecha(reserva.fecha_salida)}</p>
                {reserva.fecha_checkout_real && (
                  <p className="text-body-xs text-amber-400">Realizado a las {formatHora(reserva.fecha_checkout_real)}</p>
                )}
              </div>
            </div>
            <div className="flex items-center gap-3">
              <Clock size={16} className="text-blanco-roto/30 shrink-0" />
              <p className="text-body-sm text-blanco-roto/60">{reserva.noches} {reserva.noches === 1 ? 'noche' : 'noches'}</p>
            </div>
          </div>
        </div>

        {/* Info del hotel */}
        <div className="glass rounded-2xl p-5 space-y-3">
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Información del hotel</p>
          <div className="space-y-2.5">
            <div className="flex items-start gap-3">
              <Wifi size={16} className="text-dorado shrink-0 mt-0.5" />
              <div>
                <p className="text-body-sm text-blanco-roto">WiFi</p>
                <p className="text-body-xs text-blanco-roto/40">Solicita la clave en recepción o WhatsApp</p>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <MapPin size={16} className="text-dorado shrink-0 mt-0.5" />
              <div>
                <p className="text-body-sm text-blanco-roto">Ubicación</p>
                <p className="text-body-xs text-blanco-roto/40">Carrera 23 #53-40, El Triángulo, Manizales</p>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <Clock size={16} className="text-dorado shrink-0 mt-0.5" />
              <div>
                <p className="text-body-sm text-blanco-roto">Horarios</p>
                <p className="text-body-xs text-blanco-roto/40">Check-in desde 3:00 PM · Check-out hasta 12:00 PM</p>
              </div>
            </div>
          </div>
        </div>

        {/* Botón check-in */}
        {puedeCheckin && (
          <button
            onClick={() => checkin()}
            disabled={checkingIn}
            className="w-full flex items-center justify-center gap-3 py-5 bg-dorado text-negro-absoluto font-black text-body-lg rounded-2xl hover:shadow-glow active:scale-98 disabled:opacity-50 transition-all"
          >
            {checkingIn ? <Loader2 size={22} className="animate-spin" /> : <LogIn size={22} />}
            {checkingIn ? 'Procesando...' : 'Hacer Check-in'}
          </button>
        )}

        {/* Botón check-out */}
        {puedeCheckout && (
          <button
            onClick={() => checkout()}
            disabled={checkingOut}
            className="w-full flex items-center justify-center gap-3 py-5 glass border-2 border-amber-600/40 text-amber-300 font-black text-body-lg rounded-2xl hover:border-amber-500/60 active:scale-98 disabled:opacity-50 transition-all"
          >
            {checkingOut ? <Loader2 size={22} className="animate-spin" /> : <LogOut size={22} />}
            {checkingOut ? 'Procesando...' : 'Hacer Check-out'}
          </button>
        )}

        {/* Check-out completado */}
        {yaHizoCheckout && (
          <div className="glass rounded-2xl p-6 text-center border border-green-800/30">
            <CheckCircle2 size={32} className="text-green-400 mx-auto mb-3" />
            <p className="font-display text-display-sm font-bold text-blanco-roto">¡Hasta pronto!</p>
            <p className="text-body-sm text-blanco-roto/50 mt-1">
              Gracias por quedarte en Break. Esperamos verte de nuevo.
            </p>
          </div>
        )}

        {/* WhatsApp */}
        <a
          href="https://wa.me/573000000000"
          target="_blank"
          rel="noreferrer"
          className="flex items-center justify-center gap-2 w-full py-3 glass rounded-xl border border-green-800/30 text-green-400 text-body-sm font-semibold hover:border-green-600/50 transition-all"
        >
          <Phone size={16} />
          Contactar al hotel por WhatsApp
        </a>
      </div>
    </div>
  )
}
