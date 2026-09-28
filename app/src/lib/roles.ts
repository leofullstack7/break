import type { RolUsuario } from '@/types/database.types'

/** Quien entra al panel. */
export const ROLES_STAFF: RolUsuario[] = [
  'gerente', 'ti', 'administracion', 'recepcion', 'aseo', 'marketing',
]

/**
 * TI y Administración ven todo lo gerencial hasta que gerencia
 * recorte permisos por cargo.
 */
export const ROLES_GERENCIALES: RolUsuario[] = [
  'gerente', 'ti', 'administracion',
]

export function esStaff(rol: string | null | undefined): boolean {
  return !!rol && (ROLES_STAFF as string[]).includes(rol)
}

export function esGerencial(rol: string | null | undefined): boolean {
  return rol === 'gerente' || rol === 'ti' || rol === 'administracion'
}

export function labelRol(rol: string | null | undefined): string {
  switch (rol) {
    case 'gerente': return 'Gerencia'
    case 'ti': return 'IT Break'
    case 'administracion': return 'Administración'
    case 'recepcion': return 'Recepción'
    case 'aseo': return 'Aseo'
    case 'marketing': return 'Marketing'
    default: return rol ?? ''
  }
}
