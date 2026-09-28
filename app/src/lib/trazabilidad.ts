import { supabase, supabaseUrl } from '@/lib/supabase'
import type {
  AsistenteMensaje,
  EstadoObjetivo,
  EstadoTarea,
  Objetivo,
  Tarea,
  TrazabilidadAdjunto,
  Usuario,
  Zumbido,
} from '@/types/database.types'

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const db = supabase as any

export async function fetchEquipoGerencial(): Promise<Pick<Usuario, 'id' | 'nombre' | 'rol' | 'email'>[]> {
  const { data, error } = await db
    .from('usuarios')
    .select('id, nombre, rol, email')
    .in('rol', ['ti', 'administracion', 'gerente'])
    .eq('activo', true)
    .order('nombre')
  if (error) throw error
  return data ?? []
}

export async function fetchObjetivos(): Promise<Objetivo[]> {
  const { data: objetivos, error } = await db
    .from('objetivos')
    .select('*')
    .order('created_at', { ascending: false })
  if (error) throw error

  const rows = (objetivos ?? []) as Objetivo[]
  const ids = rows.map(o => o.id)
  const ownerIds = [...new Set(rows.map(o => o.owner_id))]
  if (ids.length === 0) return []

  const [{ data: tareas }, { data: adjuntos }, { data: owners }] = await Promise.all([
    db.from('tareas').select('*').in('objetivo_id', ids).order('orden'),
    db.from('trazabilidad_adjuntos').select('*').in('objetivo_id', ids),
    db.from('usuarios').select('id, nombre, rol, email').in('id', ownerIds),
  ])

  const tareasIds = (tareas ?? []).map((t: Tarea) => t.id)
  const { data: adjTareas } = tareasIds.length
    ? await db.from('trazabilidad_adjuntos').select('*').in('tarea_id', tareasIds)
    : { data: [] }

  const adjPorTarea = new Map<string, TrazabilidadAdjunto[]>()
  for (const a of (adjTareas ?? []) as TrazabilidadAdjunto[]) {
    if (!a.tarea_id) continue
    const arr = adjPorTarea.get(a.tarea_id) ?? []
    arr.push(a)
    adjPorTarea.set(a.tarea_id, arr)
  }

  const tareasPorObj = new Map<string, Tarea[]>()
  for (const t of (tareas ?? []) as Tarea[]) {
    const arr = tareasPorObj.get(t.objetivo_id) ?? []
    arr.push({ ...t, adjuntos: adjPorTarea.get(t.id) ?? [] })
    tareasPorObj.set(t.objetivo_id, arr)
  }

  const adjPorObj = new Map<string, TrazabilidadAdjunto[]>()
  for (const a of (adjuntos ?? []) as TrazabilidadAdjunto[]) {
    if (!a.objetivo_id) continue
    const arr = adjPorObj.get(a.objetivo_id) ?? []
    arr.push(a)
    adjPorObj.set(a.objetivo_id, arr)
  }

  return rows.map(o => ({
    ...o,
    owner: ((owners ?? []) as Pick<Usuario, 'id' | 'nombre' | 'rol' | 'email'>[]).find(u => u.id === o.owner_id) ?? null,
    tareas: tareasPorObj.get(o.id) ?? [],
    adjuntos: adjPorObj.get(o.id) ?? [],
  }))
}

export async function crearObjetivo(input: {
  titulo: string
  descripcion?: string
  area: Objetivo['area']
  owner_id: string
  fecha_objetivo?: string | null
}): Promise<Objetivo> {
  const { data, error } = await db
    .from('objetivos')
    .insert({
      titulo: input.titulo,
      descripcion: input.descripcion ?? null,
      area: input.area,
      owner_id: input.owner_id,
      fecha_objetivo: input.fecha_objetivo ?? null,
      estado: 'abierto',
    })
    .select('*')
    .single()
  if (error) throw error
  return data as Objetivo
}

export async function crearTarea(input: {
  objetivo_id: string
  titulo: string
  descripcion?: string
  asignado_id?: string | null
  created_by: string
}): Promise<Tarea> {
  const { data, error } = await db
    .from('tareas')
    .insert({
      objetivo_id: input.objetivo_id,
      titulo: input.titulo,
      descripcion: input.descripcion ?? null,
      asignado_id: input.asignado_id ?? input.created_by,
      created_by: input.created_by,
      estado: 'pendiente',
    })
    .select('*')
    .single()
  if (error) throw error
  return data as Tarea
}

export async function setEstadoObjetivo(id: string, estado: EstadoObjetivo): Promise<void> {
  const patch: Record<string, unknown> = { estado }
  if (estado === 'cumplido') patch.cumplido_at = new Date().toISOString()
  const { error } = await db.from('objetivos').update(patch).eq('id', id)
  if (error) throw error
}

export async function setEstadoTarea(id: string, estado: EstadoTarea): Promise<void> {
  const patch: Record<string, unknown> = { estado }
  if (estado === 'completa') patch.completada_at = new Date().toISOString()
  else patch.completada_at = null
  const { error } = await db.from('tareas').update(patch).eq('id', id)
  if (error) throw error
}

export async function subirAdjunto(params: {
  file: File
  objetivoId?: string
  tareaId?: string
  userId: string
}): Promise<TrazabilidadAdjunto> {
  const ext = params.file.name.split('.').pop()?.toLowerCase() ?? 'bin'
  const id = crypto.randomUUID()
  const path = `${params.userId}/${id}.${ext}`

  const { error: upErr } = await supabase.storage
    .from('trazabilidad')
    .upload(path, params.file, { contentType: params.file.type, upsert: false })
  if (upErr) throw upErr

  const { data, error } = await db
    .from('trazabilidad_adjuntos')
    .insert({
      objetivo_id: params.objetivoId ?? null,
      tarea_id: params.tareaId ?? null,
      nombre: params.file.name,
      mime: params.file.type || 'application/octet-stream',
      path,
      bytes: params.file.size,
      subido_por: params.userId,
    })
    .select('*')
    .single()
  if (error) throw error
  return data as TrazabilidadAdjunto
}

export async function urlAdjunto(path: string): Promise<string | null> {
  const { data, error } = await supabase.storage
    .from('trazabilidad')
    .createSignedUrl(path, 3600)
  if (error || !data?.signedUrl) return null
  return data.signedUrl
}

export async function enviarZumbido(paraId: string, mensaje?: string): Promise<Zumbido> {
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) throw new Error('Sin sesión')
  const { data, error } = await db
    .from('zumbidos')
    .insert({
      de_id: user.id,
      para_id: paraId,
      mensaje: mensaje ?? 'La gerencia te zumbó.',
    })
    .select('*')
    .single()
  if (error) throw error
  return data as Zumbido
}

export async function marcarZumbidoLeido(id: string): Promise<void> {
  await db.from('zumbidos').update({ leido_at: new Date().toISOString() }).eq('id', id)
}

export async function fetchAsistente(rama: 'gerente' | 'ti'): Promise<AsistenteMensaje[]> {
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return []
  const { data, error } = await db
    .from('asistente_mensajes')
    .select('*')
    .eq('rama', rama)
    .eq('user_id', user.id)
    .order('created_at', { ascending: true })
    .limit(40)
  if (error) throw error
  return (data ?? []) as AsistenteMensaje[]
}

export async function preguntarAsistente(rama: 'gerente' | 'ti', mensaje: string): Promise<string> {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) throw new Error('Sin sesión')
  const res = await fetch(`${supabaseUrl}/functions/v1/asistente-equipo`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${session.access_token}`,
      apikey: import.meta.env.VITE_SUPABASE_ANON_KEY as string,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ rama, mensaje }),
  })
  const body = await res.json().catch(() => ({}))
  if (!res.ok || !body.ok) throw new Error(body.error ?? `HTTP ${res.status}`)
  return String(body.respuesta ?? '')
}
