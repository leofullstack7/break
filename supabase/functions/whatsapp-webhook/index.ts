// Edge Function: whatsapp-webhook
// Webhook de Meta WhatsApp Business API (Cloud API).
// URL pública: https://<project>.supabase.co/functions/v1/whatsapp-webhook
// Configurar en Meta for Developers → WhatsApp → Configuration → Webhook
//
// GET  → verificación del webhook (Meta envía hub.mode, hub.verify_token, hub.challenge)
// POST → mensajes entrantes, se guardan en la tabla whatsapp_messages

import { supabaseAdmin } from '../_shared/supabase-admin.ts'

// Debe coincidir con el "Verify Token" configurado en el panel de Meta
const VERIFY_TOKEN = 'break_hotel_whatsapp_2026'

interface WhatsAppWebhookPayload {
  object?: string
  entry?: WhatsAppEntry[]
}

interface WhatsAppEntry {
  id: string
  changes?: WhatsAppChange[]
}

interface WhatsAppChange {
  field: string
  value: WhatsAppValue
}

interface WhatsAppValue {
  messaging_product?: string
  metadata?: {
    display_phone_number?: string
    phone_number_id?: string
  }
  contacts?: {
    profile?: { name?: string }
    wa_id: string
  }[]
  messages?: WhatsAppMessage[]
}

interface WhatsAppMessage {
  from: string
  id: string
  timestamp: string
  type: string
  text?: { body: string }
  button?: { text: string }
  interactive?: {
    button_reply?: { title: string }
    list_reply?: { title: string }
  }
  [key: string]: unknown
}

Deno.serve(async (req) => {
  const url = new URL(req.url)

  if (req.method === 'GET') {
    return verificarWebhook(url)
  }

  if (req.method === 'POST') {
    return recibirMensajes(req)
  }

  return new Response('Método no permitido', { status: 405 })
})

// Meta llama a este endpoint con GET para confirmar la URL del webhook
function verificarWebhook(url: URL): Response {
  const mode = url.searchParams.get('hub.mode')
  const token = url.searchParams.get('hub.verify_token')
  const challenge = url.searchParams.get('hub.challenge')

  if (mode === 'subscribe' && token === VERIFY_TOKEN && challenge) {
    console.log('[whatsapp-webhook] Verificación de Meta exitosa')
    return new Response(challenge, { status: 200 })
  }

  console.warn('[whatsapp-webhook] Verificación de Meta fallida')
  return new Response('Token de verificación inválido', { status: 403 })
}

async function recibirMensajes(req: Request): Promise<Response> {
  let payload: WhatsAppWebhookPayload

  try {
    payload = await req.json()
  } catch {
    return new Response('Body inválido', { status: 400 })
  }

  console.log('[whatsapp-webhook] Payload recibido:', JSON.stringify(payload))

  try {
    await guardarMensajes(payload)
  } catch (err) {
    console.error('[whatsapp-webhook] Error guardando mensaje:', err)
    // El error queda en los logs de Supabase
  }

  // Meta requiere 200 OK rápido para no reintentar el envío
  return new Response('OK', { status: 200 })
}

async function guardarMensajes(payload: WhatsAppWebhookPayload): Promise<void> {
  for (const entry of payload.entry ?? []) {
    for (const change of entry.changes ?? []) {
      const valor = change.value
      const mensajes = valor.messages ?? []

      for (const mensaje of mensajes) {
        const contacto = valor.contacts?.find((c) => c.wa_id === mensaje.from)

        const { error } = await supabaseAdmin.from('whatsapp_messages').insert({
          wa_message_id: mensaje.id,
          from_numero: mensaje.from,
          to_numero: valor.metadata?.display_phone_number ?? null,
          nombre_contacto: contacto?.profile?.name ?? null,
          tipo: mensaje.type,
          contenido: extraerContenido(mensaje),
          payload: mensaje,
        })

        if (error) {
          console.error('[whatsapp-webhook] Error insertando mensaje:', error.message)
        }
      }
    }
  }
}

// Extrae el texto legible del mensaje según su tipo
function extraerContenido(mensaje: WhatsAppMessage): string | null {
  switch (mensaje.type) {
    case 'text':
      return mensaje.text?.body ?? null
    case 'button':
      return mensaje.button?.text ?? null
    case 'interactive':
      return mensaje.interactive?.button_reply?.title ?? mensaje.interactive?.list_reply?.title ?? null
    default:
      return null
  }
}
