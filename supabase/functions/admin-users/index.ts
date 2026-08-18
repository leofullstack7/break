// Edge Function: admin-users
// Gestión de usuarios del equipo (crear, listar, desactivar).
// Solo accesible por usuarios con rol 'gerente'.
//
// GET  → listar usuarios
// POST → crear usuario nuevo (auth + public.usuarios)
// PATCH → activar/desactivar usuario

import { supabaseAdmin } from '../_shared/supabase-admin.ts'

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const ROLES_VALIDOS = ['gerente', 'recepcion', 'aseo', 'marketing', 'huesped']

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: CORS_HEADERS })
  }

  const authHeader = req.headers.get('Authorization')
  if (!authHeader) return respuesta(401, { error: 'Sin autorización' })

  const token = authHeader.replace('Bearer ', '')
  const { data: { user }, error: authError } = await supabaseAdmin.auth.getUser(token)
  if (authError || !user) return respuesta(401, { error: 'Token inválido' })

  const { data: perfil } = await supabaseAdmin
    .from('usuarios')
    .select('rol')
    .eq('id', user.id)
    .single()

  if (perfil?.rol !== 'gerente') {
    return respuesta(403, { error: 'Solo el gerente puede gestionar usuarios' })
  }

  switch (req.method) {
    case 'GET':
      return listarUsuarios()
    case 'POST':
      return crearUsuario(await req.json())
    case 'PATCH':
      return toggleUsuario(await req.json())
    default:
      return respuesta(405, { error: 'Método no permitido' })
  }
})

async function listarUsuarios(): Promise<Response> {
  const { data, error } = await supabaseAdmin
    .from('usuarios')
    .select('id, nombre, rol, email, activo, created_at')
    .order('created_at', { ascending: true })

  if (error) return respuesta(500, { error: error.message })
  return respuesta(200, { usuarios: data })
}

async function crearUsuario(body: {
  nombre: string
  email: string
  password: string
  rol: string
}): Promise<Response> {
  const { nombre, email, password, rol } = body

  if (!nombre?.trim() || !email?.trim() || !password || !rol) {
    return respuesta(400, { error: 'Campos requeridos: nombre, email, password, rol' })
  }

  if (!ROLES_VALIDOS.includes(rol)) {
    return respuesta(400, { error: `Rol inválido. Usar: ${ROLES_VALIDOS.join(', ')}` })
  }

  if (password.length < 6) {
    return respuesta(400, { error: 'La contraseña debe tener al menos 6 caracteres' })
  }

  const { data: authUser, error: authError } = await supabaseAdmin.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  })

  if (authError) {
    if (authError.message.includes('already been registered')) {
      return respuesta(409, { error: 'Ya existe un usuario con ese correo' })
    }
    return respuesta(500, { error: `Error creando usuario: ${authError.message}` })
  }

  const { error: perfilError } = await supabaseAdmin
    .from('usuarios')
    .insert({
      id: authUser.user.id,
      nombre: nombre.trim(),
      rol,
      email: email.trim().toLowerCase(),
      activo: true,
    })

  if (perfilError) {
    await supabaseAdmin.auth.admin.deleteUser(authUser.user.id)
    return respuesta(500, { error: `Error creando perfil: ${perfilError.message}` })
  }

  console.log(`[admin-users] Usuario creado: ${email} (${rol})`)

  return respuesta(201, {
    ok: true,
    usuario: {
      id: authUser.user.id,
      nombre: nombre.trim(),
      email: email.trim().toLowerCase(),
      rol,
    },
  })
}

async function toggleUsuario(body: { id: string; activo: boolean }): Promise<Response> {
  const { id, activo } = body

  if (!id || typeof activo !== 'boolean') {
    return respuesta(400, { error: 'Campos requeridos: id, activo (boolean)' })
  }

  const { error } = await supabaseAdmin
    .from('usuarios')
    .update({ activo })
    .eq('id', id)

  if (error) return respuesta(500, { error: error.message })

  if (!activo) {
    await supabaseAdmin.auth.admin.updateUserById(id, { ban_duration: '876600h' })
  } else {
    await supabaseAdmin.auth.admin.updateUserById(id, { ban_duration: 'none' })
  }

  console.log(`[admin-users] Usuario ${id} ${activo ? 'activado' : 'desactivado'}`)
  return respuesta(200, { ok: true })
}

function respuesta(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS_HEADERS, 'Content-Type': 'application/json' },
  })
}
