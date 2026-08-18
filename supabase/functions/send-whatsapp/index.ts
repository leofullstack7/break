// Edge Function: send-whatsapp
// Envía mensajes de WhatsApp vía Cloud API (Meta Business).
// Soporta envío individual y masivo (difusión).
//
// Requiere secrets:
//   WHATSAPP_ACCESS_TOKEN   — token permanente de Meta
//   WHATSAPP_PHONE_NUMBER_ID — ID del número de negocio
//
// POST /send-whatsapp
// Body: { destinatarios: [{ numero, nombre }], mensaje: string }

import { supabaseAdmin } from '../_shared/supabase-admin.ts'

interface Destinatario {
  numero: string
  nombre: string
}

interface SendWhatsAppRequest {
  destinatarios: Destinatario[]
  mensaje: string
  nombre_campana?: string
}

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const BATCH_DELAY_MS = 1500

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: CORS_HEADERS })
  }

  if (req.method !== 'POST') {
    return respuesta(405, { error: 'Método no permitido' })
  }

  const token = Deno.env.get('WHATSAPP_ACCESS_TOKEN')
  const phoneId = Deno.env.get('WHATSAPP_PHONE_NUMBER_ID')

  if (!token || !phoneId) {
    return respuesta(503, {
      error: 'WhatsApp API no configurada. Agregar WHATSAPP_ACCESS_TOKEN y WHATSAPP_PHONE_NUMBER_ID en Supabase Secrets.',
      api_configurada: false,
    })
  }

  let body: SendWhatsAppRequest
  try {
    body = await req.json()
  } catch {
    return respuesta(400, { error: 'Body JSON inválido' })
  }

  const { destinatarios, mensaje, nombre_campana } = body

  if (!destinatarios?.length || !mensaje) {
    return respuesta(400, { error: 'Campos requeridos: destinatarios[], mensaje' })
  }

  console.log(`[send-whatsapp] Difusión "${nombre_campana ?? 'sin nombre'}" → ${destinatarios.length} contactos`)

  let enviados = 0
  let fallidos = 0
  const errores: string[] = []

  for (const dest of destinatarios) {
    const numero = dest.numero.replace(/\D/g, '')
    if (!numero) {
      fallidos++
      continue
    }

    try {
      const res = await fetch(
        `https://graph.facebook.com/v21.0/${phoneId}/messages`,
        {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            messaging_product: 'whatsapp',
            to: numero,
            type: 'text',
            text: { body: mensaje },
          }),
        }
      )

      const data = await res.json()

      if (res.ok) {
        enviados++
        await supabaseAdmin.from('whatsapp_messages').insert({
          wa_message_id: data.messages?.[0]?.id ?? `out_${Date.now()}`,
          from_numero: phoneId,
          to_numero: numero,
          nombre_contacto: dest.nombre,
          tipo: 'text',
          contenido: mensaje,
          payload: { direction: 'outbound', campana: nombre_campana },
        })
      } else {
        fallidos++
        const errorMsg = data.error?.message ?? `HTTP ${res.status}`
        errores.push(`${dest.nombre} (${numero}): ${errorMsg}`)
        console.error(`[send-whatsapp] Error enviando a ${numero}:`, errorMsg)
      }
    } catch (err) {
      fallidos++
      errores.push(`${dest.nombre}: ${(err as Error).message}`)
    }

    if (destinatarios.indexOf(dest) < destinatarios.length - 1) {
      await new Promise(r => setTimeout(r, BATCH_DELAY_MS))
    }
  }

  console.log(`[send-whatsapp] Completado: ${enviados} enviados, ${fallidos} fallidos`)

  return respuesta(200, {
    ok: true,
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
