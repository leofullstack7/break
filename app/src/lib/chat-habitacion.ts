import { supabase, supabaseUrl } from '@/lib/supabase'
import type { Chat, ChatMensaje, ChatMensajeTipo, MapaHabitacion } from '@/types/database.types'

// El cliente tipado del proyecto no incluye Relationships (supabase-js 2.10+).
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const db = supabase as any

export const GOOGLE_REVIEW_URL =
  (import.meta.env.VITE_GOOGLE_REVIEW_URL as string | undefined)
  || 'https://www.google.com/maps/search/?api=1&query=Break+Estudios+Manizales+Av+Santander+53-40'

export function urlPublicaChat(token: string) {
  const base = (import.meta.env.VITE_APP_URL as string | undefined)?.replace(/\/$/, '')
    || window.location.origin
  return `${base}/h/${token}`
}

export function urlMediaChat(path: string | null | undefined) {
  if (!path) return null
  if (path.startsWith('http')) return path
  return `${supabaseUrl}/storage/v1/object/public/chat-adjuntos/${path}`
}

export interface ChatHabitacionPublico {
  habitacion_id: string
  numero: number
  piso: number
  chat_id: string
  huesped_id: string | null
  huesped_nombre: string | null
  estado_hospedaje: string | null
  mensajes: ChatMensaje[]
}

export interface InboxChat extends Chat {
  numero: number
  piso: number
  chat_token: string | null
  huesped_nombre: string | null
  huesped_id_mapa: string | null
}

export async function abrirChatPorToken(token: string): Promise<ChatHabitacionPublico> {
  const { data, error } = await db.rpc('chat_habitacion_por_token', { p_token: token })
  if (error) throw error
  const raw = data as unknown as ChatHabitacionPublico
  return {
    ...raw,
    mensajes: Array.isArray(raw.mensajes) ? raw.mensajes : [],
  }
}

export async function enviarMensajeHuesped(params: {
  token: string
  tipo: ChatMensajeTipo
  contenido: string
  mediaPath?: string | null
}): Promise<ChatMensaje> {
  const { data, error } = await db.rpc('chat_enviar_huesped', {
    p_token: params.token,
    p_tipo: params.tipo,
    p_contenido: params.contenido,
    p_media_path: params.mediaPath ?? null,
  })
  if (error) throw error
  return data as unknown as ChatMensaje
}

export async function marcarLeidoHuesped(token: string) {
  await db.rpc('chat_marcar_leido_huesped', { p_token: token })
}

export async function marcarLeidoAdmin(chatId: string) {
  await db.rpc('chat_marcar_leido_admin', { p_chat_id: chatId })
}

export async function enviarMensajeAdmin(params: {
  chatId: string
  autorId: string
  tipo: ChatMensajeTipo
  contenido: string
  mediaPath?: string | null
}): Promise<ChatMensaje> {
  const { data, error } = await db
    .from('chat_mensajes')
    .insert({
      chat_id: params.chatId,
      rol: 'admin',
      autor_id: params.autorId,
      tipo: params.tipo,
      contenido: params.contenido,
      media_path: params.mediaPath ?? null,
      metadata: null,
    })
    .select('*')
    .single()
  if (error) throw error
  return data as ChatMensaje
}

export async function fetchInboxChats(): Promise<InboxChat[]> {
  const [{ data: chats, error }, { data: mapa }] = await Promise.all([
    db
      .from('chats')
      .select('*')
      .not('habitacion_id', 'is', null)
      .order('ultimo_mensaje_at', { ascending: false }),
    db
      .from('v_mapa_habitaciones')
      .select('habitacion_id, numero, piso, huesped_id, huesped_nombre'),
  ])
  if (error) throw error

  const { data: habs } = await db
    .from('habitaciones')
    .select('id, numero, piso, chat_token')
    .order('numero')

  const mapaPorHab = new Map<string, Pick<MapaHabitacion, 'habitacion_id' | 'huesped_id' | 'huesped_nombre'>>()
  for (const row of (mapa ?? []) as Pick<MapaHabitacion, 'habitacion_id' | 'huesped_id' | 'huesped_nombre'>[]) {
    mapaPorHab.set(row.habitacion_id, row)
  }
  const chatPorHab = new Map<string, Chat>()
  for (const c of (chats ?? []) as Chat[]) {
    if (c.habitacion_id) chatPorHab.set(c.habitacion_id, c)
  }

  return ((habs ?? []) as { id: string; numero: number; piso: number; chat_token: string | null }[]).map(h => {
    const chat = chatPorHab.get(h.id)
    const m = mapaPorHab.get(h.id)
    return {
      id: chat?.id ?? `pending-${h.id}`,
      habitacion_id: h.id,
      reserva_id: chat?.reserva_id ?? null,
      huesped_id: chat?.huesped_id ?? m?.huesped_id ?? null,
      titulo: chat?.titulo ?? `Habitación ${h.numero}`,
      estado: chat?.estado ?? 'abierto',
      bot_activo: chat?.bot_activo ?? false,
      ultimo_mensaje_at: chat?.ultimo_mensaje_at ?? null,
      ultimo_mensaje: chat?.ultimo_mensaje ?? null,
      ultimo_rol: chat?.ultimo_rol ?? null,
      no_leidos_admin: chat?.no_leidos_admin ?? 0,
      no_leidos_huesped: chat?.no_leidos_huesped ?? 0,
      created_at: chat?.created_at ?? '',
      updated_at: chat?.updated_at ?? '',
      numero: h.numero,
      piso: h.piso,
      chat_token: h.chat_token,
      huesped_nombre: m?.huesped_nombre ?? null,
      huesped_id_mapa: m?.huesped_id ?? null,
    } satisfies InboxChat
  }).sort((a, b) => {
    if (a.no_leidos_admin !== b.no_leidos_admin) return b.no_leidos_admin - a.no_leidos_admin
    const ta = a.ultimo_mensaje_at ? new Date(a.ultimo_mensaje_at).getTime() : 0
    const tb = b.ultimo_mensaje_at ? new Date(b.ultimo_mensaje_at).getTime() : 0
    if (ta !== tb) return tb - ta
    return a.numero - b.numero
  })
}

export async function fetchMensajes(chatId: string): Promise<ChatMensaje[]> {
  const { data, error } = await db
    .from('chat_mensajes')
    .select('*')
    .eq('chat_id', chatId)
    .order('created_at', { ascending: true })
  if (error) throw error
  return (data ?? []) as ChatMensaje[]
}

export async function subirAdjuntoChat(params: {
  archivo: Blob
  nombre: string
  tipo: 'imagen' | 'audio'
  token?: string
}): Promise<{ path: string; url: string }> {
  const form = new FormData()
  form.append('archivo', params.archivo, params.nombre)
  form.append('tipo', params.tipo)
  if (params.token) form.append('token', params.token)

  const { data: { session } } = await supabase.auth.getSession()
  const headers: Record<string, string> = {}
  if (session?.access_token) headers.Authorization = `Bearer ${session.access_token}`

  const res = await fetch(`${supabaseUrl}/functions/v1/chat-media`, {
    method: 'POST',
    headers,
    body: form,
  })
  const body = await res.json()
  if (!res.ok || !body.ok) throw new Error(body.error ?? 'No se pudo subir el archivo')
  return { path: body.path, url: body.url }
}

export async function comprimirImagen(file: File, maxLado = 1600): Promise<Blob> {
  if (!file.type.startsWith('image/')) return file
  const bmp = await createImageBitmap(file)
  const escala = Math.min(1, maxLado / Math.max(bmp.width, bmp.height))
  if (escala >= 1 && file.size < 1_200_000) return file
  const canvas = document.createElement('canvas')
  canvas.width = Math.round(bmp.width * escala)
  canvas.height = Math.round(bmp.height * escala)
  const ctx = canvas.getContext('2d')
  if (!ctx) return file
  ctx.drawImage(bmp, 0, 0, canvas.width, canvas.height)
  return await new Promise(resolve => {
    canvas.toBlob(b => resolve(b ?? file), 'image/jpeg', 0.82)
  })
}

export function formatHoraChat(iso: string) {
  const d = new Date(iso)
  const ahora = new Date()
  const mismoDia = d.toDateString() === ahora.toDateString()
  if (mismoDia) {
    return d.toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit' })
  }
  return d.toLocaleDateString('es-CO', { day: 'numeric', month: 'short' })
    + ' '
    + d.toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit' })
}
