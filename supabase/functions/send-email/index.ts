// Edge Function: send-email
// Envía emails transaccionales del hotel usando Resend.
// URL: https://<project>.supabase.co/functions/v1/send-email
//
// POST → envía un email según el tipo especificado
// Tipos: confirmacion_reserva | pre_checkin | post_estadia
//
// Requiere secret: RESEND_API_KEY
// Requiere secret: RESEND_FROM_EMAIL (ej: Break Hotel <reservas@breakmanizales.com>)

import { supabaseAdmin } from '../_shared/supabase-admin.ts'
import { enviarEmail } from '../_shared/resend.ts'
import {
  plantillaConfirmacionReserva,
  plantillaPreCheckin,
  plantillaPostEstadia,
  type DatosReserva,
} from '../_shared/email-templates.ts'

type TipoEmail = 'confirmacion_reserva' | 'pre_checkin' | 'post_estadia'

interface SendEmailRequest {
  tipo: TipoEmail
  destinatario: string
  datos_reserva: DatosReserva
}

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: CORS_HEADERS })
  }

  if (req.method !== 'POST') {
    return new Response('Método no permitido', { status: 405, headers: CORS_HEADERS })
  }

  let body: SendEmailRequest
  try {
    body = await req.json()
  } catch {
    return respuesta(400, { error: 'Body JSON inválido' })
  }

  const { tipo, destinatario, datos_reserva } = body

  if (!tipo || !destinatario || !datos_reserva) {
    return respuesta(400, { error: 'Campos requeridos: tipo, destinatario, datos_reserva' })
  }

  const tiposValidos: TipoEmail[] = ['confirmacion_reserva', 'pre_checkin', 'post_estadia']
  if (!tiposValidos.includes(tipo)) {
    return respuesta(400, { error: `Tipo inválido. Usar: ${tiposValidos.join(', ')}` })
  }

  const { subject, html } = generarPlantilla(tipo, datos_reserva)
  const fromEmail = Deno.env.get('RESEND_FROM_EMAIL') ?? 'Break Hotel <onboarding@resend.dev>'

  console.log(`[send-email] Enviando ${tipo} a ${destinatario}`)

  const resultado = await enviarEmail({
    from: fromEmail,
    to: destinatario,
    subject,
    html,
    reply_to: 'reservas@breakmanizales.com',
  })

  await registrarEnvio({
    tipo,
    destinatario,
    asunto: subject,
    resend_id: resultado.ok ? resultado.id : null,
    estado: resultado.ok ? 'enviado' : 'fallido',
    error: resultado.ok ? null : resultado.error,
    datos_reserva,
  })

  if (!resultado.ok) {
    console.error(`[send-email] Error: ${resultado.error}`)
    return respuesta(502, { error: resultado.error })
  }

  console.log(`[send-email] Enviado OK — Resend ID: ${resultado.id}`)
  return respuesta(200, { ok: true, resend_id: resultado.id })
})

function generarPlantilla(tipo: TipoEmail, datos: DatosReserva): { subject: string; html: string } {
  switch (tipo) {
    case 'confirmacion_reserva':
      return plantillaConfirmacionReserva(datos)
    case 'pre_checkin':
      return plantillaPreCheckin(datos)
    case 'post_estadia':
      return plantillaPostEstadia(datos)
  }
}

interface RegistroEmail {
  tipo: string
  destinatario: string
  asunto: string
  resend_id: string | null
  estado: 'enviado' | 'fallido'
  error: string | null
  datos_reserva: DatosReserva
}

async function registrarEnvio(registro: RegistroEmail): Promise<void> {
  const { error } = await supabaseAdmin.from('email_logs').insert({
    tipo: registro.tipo,
    destinatario: registro.destinatario,
    asunto: registro.asunto,
    resend_id: registro.resend_id,
    estado: registro.estado,
    error: registro.error,
    metadata: registro.datos_reserva,
  })

  if (error) {
    console.error('[send-email] Error guardando log:', error.message)
  }
}

function respuesta(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS_HEADERS, 'Content-Type': 'application/json' },
  })
}
