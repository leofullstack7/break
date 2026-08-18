// Edge Function: send-campaign
// Envío masivo de emails de marketing usando Resend.
// Recibe lista de destinatarios + asunto + mensaje y envía a cada uno
// con la plantilla de marca de Break.
//
// Límites Resend free: 100 emails/día, 3.000/mes.
// La función envía en lotes de 50 con pausa entre lotes.

import { supabaseAdmin } from '../_shared/supabase-admin.ts'
import { enviarEmail } from '../_shared/resend.ts'
import { plantillaCampana, type DatosCampana } from '../_shared/email-templates.ts'

interface SendCampaignRequest {
  asunto: string
  mensaje: string
  destinatarios: string[]
  nombre_campana: string
  cta_texto?: string
  cta_url?: string
}

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const BATCH_SIZE = 10
const BATCH_DELAY_MS = 1000

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: CORS_HEADERS })
  }

  if (req.method !== 'POST') {
    return respuesta(405, { error: 'Método no permitido' })
  }

  let body: SendCampaignRequest
  try {
    body = await req.json()
  } catch {
    return respuesta(400, { error: 'Body JSON inválido' })
  }

  const { asunto, mensaje, destinatarios, nombre_campana, cta_texto, cta_url } = body

  if (!asunto || !mensaje || !destinatarios?.length || !nombre_campana) {
    return respuesta(400, { error: 'Campos requeridos: asunto, mensaje, destinatarios[], nombre_campana' })
  }

  if (destinatarios.length > 100) {
    return respuesta(400, { error: 'Máximo 100 destinatarios por campaña (límite diario Resend free)' })
  }

  const datosCampana: DatosCampana = { asunto, mensaje, nombre_campana, cta_texto, cta_url }
  const { subject, html } = plantillaCampana(datosCampana)
  const fromEmail = Deno.env.get('RESEND_FROM_EMAIL') ?? 'Break Hotel <onboarding@resend.dev>'

  console.log(`[send-campaign] Iniciando "${nombre_campana}" → ${destinatarios.length} destinatarios`)

  let enviados = 0
  let fallidos = 0
  const errores: string[] = []

  for (let i = 0; i < destinatarios.length; i += BATCH_SIZE) {
    const lote = destinatarios.slice(i, i + BATCH_SIZE)

    const promesas = lote.map(async (email) => {
      const resultado = await enviarEmail({
        from: fromEmail,
        to: email,
        subject,
        html,
        reply_to: 'reservas@breakmanizales.com',
      })

      await supabaseAdmin.from('email_logs').insert({
        tipo: 'campana',
        destinatario: email,
        asunto: subject,
        resend_id: resultado.ok ? resultado.id : null,
        estado: resultado.ok ? 'enviado' : 'fallido',
        error: resultado.ok ? null : resultado.error,
        metadata: { nombre_campana, cta_texto, cta_url },
      })

      if (resultado.ok) {
        enviados++
      } else {
        fallidos++
        errores.push(`${email}: ${resultado.error}`)
      }
    })

    await Promise.all(promesas)

    if (i + BATCH_SIZE < destinatarios.length) {
      await new Promise(r => setTimeout(r, BATCH_DELAY_MS))
    }
  }

  console.log(`[send-campaign] "${nombre_campana}" completada: ${enviados} enviados, ${fallidos} fallidos`)

  return respuesta(200, {
    ok: true,
    nombre_campana,
    total: destinatarios.length,
    enviados,
    fallidos,
    errores: errores.length > 0 ? errores : undefined,
  })
})

function respuesta(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS_HEADERS, 'Content-Type': 'application/json' },
  })
}
