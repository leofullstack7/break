import { supabase, supabaseUrl } from '@/lib/supabase'

// El cliente tipado aún no incluye compras_inbox
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const db = supabase as any

export type CompraEstado =
  | 'pendiente'
  | 'listo'
  | 'enviado_siigo'
  | 'error'
  | 'descartado'

export interface CompraLinea {
  descripcion: string
  cantidad: number
  precio: number
  total: number
  iva_porcentaje?: number | null
}

export interface CompraInbox {
  id: string
  origen: 'email' | 'manual'
  estado: CompraEstado
  email_id: string | null
  email_from: string | null
  email_subject: string | null
  email_recibido_at: string | null
  archivo_nombre: string | null
  archivo_path: string | null
  archivo_mime: string | null
  archivo_bytes: number | null
  cufe: string | null
  prefijo: string | null
  numero_factura: string | null
  fecha_factura: string | null
  proveedor_nit: string | null
  proveedor_nombre: string | null
  receptor_nit: string | null
  moneda: string | null
  subtotal: number | null
  iva: number | null
  total: number | null
  lineas: CompraLinea[] | null
  parse_error: string | null
  siigo_compra_id: string | null
  siigo_compra_name: string | null
  siigo_sync_at: string | null
  siigo_error: string | null
  notas: string | null
  created_at: string
  updated_at: string
}

async function authHeaders(): Promise<Record<string, string>> {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) throw new Error('Sin sesión')
  return {
    Authorization: `Bearer ${session.access_token}`,
    apikey: import.meta.env.VITE_SUPABASE_ANON_KEY as string,
  }
}

export async function fetchComprasInbox(estado?: CompraEstado | 'todas'): Promise<CompraInbox[]> {
  let q = db
    .from('compras_inbox')
    .select('*')
    .order('created_at', { ascending: false })
    .limit(100)

  if (estado && estado !== 'todas') {
    q = q.eq('estado', estado)
  }

  const { data, error } = await q
  if (error) throw error
  return (data ?? []) as CompraInbox[]
}

/** Sube ZIP/XML manualmente a la bandeja. */
export async function subirCompraZip(file: File): Promise<{
  ok: boolean
  id?: string
  estado?: string
  error?: string
}> {
  const headers = await authHeaders()
  const form = new FormData()
  form.append('archivo', file, file.name)

  const res = await fetch(`${supabaseUrl}/functions/v1/compras-upload`, {
    method: 'POST',
    headers,
    body: form,
  })
  const body = await res.json().catch(() => ({}))
  if (!res.ok || !body.ok) {
    return { ok: false, error: body.error ?? `HTTP ${res.status}` }
  }
  return body
}

/** Envía una compra parseada a Siigo (POST /v1/purchases). */
export async function enviarCompraASiigo(compraId: string): Promise<{
  ok: boolean
  siigo_compra_id?: string
  siigo_compra_name?: string
  already?: boolean
  error?: string
}> {
  const headers = await authHeaders()
  const res = await fetch(`${supabaseUrl}/functions/v1/siigo-sync-compra`, {
    method: 'POST',
    headers: { ...headers, 'Content-Type': 'application/json' },
    body: JSON.stringify({ compra_id: compraId }),
  })
  const body = await res.json().catch(() => ({}))
  if (!res.ok || !body.ok) {
    return { ok: false, error: body.error ?? `HTTP ${res.status}` }
  }
  return body
}

export async function descartarCompra(id: string): Promise<void> {
  const { error } = await db
    .from('compras_inbox')
    .update({ estado: 'descartado' })
    .eq('id', id)
  if (error) throw error
}
