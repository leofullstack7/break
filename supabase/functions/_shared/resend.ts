// Cliente Resend para enviar emails transaccionales.
// Docs: https://resend.com/docs/api-reference/emails/send-email

const RESEND_API_URL = 'https://api.resend.com/emails'

interface ResendPayload {
  from: string
  to: string | string[]
  subject: string
  html: string
  reply_to?: string
}

interface ResendResponse {
  id: string
}

interface ResendError {
  statusCode: number
  message: string
  name: string
}

export async function enviarEmail(payload: ResendPayload): Promise<{ ok: true; id: string } | { ok: false; error: string }> {
  const apiKey = Deno.env.get('RESEND_API_KEY')
  if (!apiKey) {
    return { ok: false, error: 'RESEND_API_KEY no configurada en secrets' }
  }

  const res = await fetch(RESEND_API_URL, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  })

  if (!res.ok) {
    const err: ResendError = await res.json()
    return { ok: false, error: `Resend ${res.status}: ${err.message}` }
  }

  const data: ResendResponse = await res.json()
  return { ok: true, id: data.id }
}
