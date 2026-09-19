import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { Check, Loader2, X } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { aprobarCambioPxsol, rechazarCambioPxsol } from '@/lib/pxsol-write'
import { useAuthStore } from '@/store/authStore'
import type { PxsolWriteQueueItem } from '@/types/database.types'

const LABEL_TIPO: Record<PxsolWriteQueueItem['tipo'], string> = {
  editar_huesped: 'Editar huésped',
  agregar_acompanante: 'Agregar acompañante',
  check_in: 'Check-in',
  check_out: 'Check-out',
  actualizar_reserva: 'Actualizar reserva',
}

async function fetchPendientes(): Promise<PxsolWriteQueueItem[]> {
  const { data, error } = await supabase
    .from('pxsol_write_queue')
    .select('*')
    .eq('estado', 'pendiente_aprobacion')
    .order('created_at', { ascending: false })
    .limit(50)
  if (error) throw error
  return (data ?? []) as PxsolWriteQueueItem[]
}

export function PxsolWriteQueuePanel() {
  const qc = useQueryClient()
  const { rol, user } = useAuthStore()
  const esGerente = rol === 'gerente'

  const { data: pendientes = [], isLoading, isError, error } = useQuery({
    queryKey: ['pxsol-write-queue'],
    queryFn: fetchPendientes,
    refetchInterval: 30_000,
  })

  const mutAprobar = useMutation({
    mutationFn: (id: number) => aprobarCambioPxsol(id, user?.email ?? null),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['pxsol-write-queue'] }),
  })

  const mutRechazar = useMutation({
    mutationFn: (id: number) => rechazarCambioPxsol(id, user?.email ?? null),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['pxsol-write-queue'] }),
  })

  if (isLoading) {
    return (
      <div className="glass rounded-2xl px-4 py-3 flex items-center gap-2 text-body-sm text-blanco-roto/50">
        <Loader2 size={14} className="animate-spin" />
        Cargando cola PxSol…
      </div>
    )
  }

  if (isError) {
    return (
      <div className="glass rounded-2xl px-4 py-3 text-body-sm text-rojo-alerta/80">
        No se pudo leer la cola PxSol: {(error as Error).message}
      </div>
    )
  }

  if (pendientes.length === 0) return null

  return (
    <section className="glass rounded-2xl p-4 space-y-3 border border-dorado/20">
      <div className="flex items-center justify-between gap-3">
        <div>
          <h2 className="text-body-sm font-semibold text-blanco-roto">
            Cola PxSol (auditoría)
          </h2>
          <p className="text-body-xs text-blanco-roto/40 mt-0.5">
            Los cambios se envían directo a PxSol. Aquí solo quedan pendientes si el envío falló o quedó en cola.
          </p>
        </div>
        <span className="text-body-xs px-2 py-1 rounded-lg bg-dorado/15 text-dorado border border-dorado/30">
          {pendientes.length}
        </span>
      </div>

      <ul className="space-y-2">
        {pendientes.map((item) => (
          <li
            key={item.id}
            className="rounded-xl border border-white/10 bg-negro-absoluto/40 px-3 py-3 flex flex-col sm:flex-row sm:items-center gap-3"
          >
            <div className="flex-1 min-w-0">
              <p className="text-body-sm text-blanco-roto font-medium">
                {LABEL_TIPO[item.tipo]}
                {item.booking_id ? (
                  <span className="text-blanco-roto/40 font-normal"> · booking {item.booking_id}</span>
                ) : null}
              </p>
              <p className="text-body-xs text-blanco-roto/35 truncate">
                {item.solicitado_por ?? 'sin solicitante'} ·{' '}
                {new Date(item.created_at).toLocaleString('es-CO')}
              </p>
            </div>

            {esGerente && (
              <div className="flex items-center gap-2 shrink-0">
                <button
                  type="button"
                  disabled={mutAprobar.isPending || mutRechazar.isPending}
                  onClick={() => mutAprobar.mutate(item.id)}
                  className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-dorado/15 border border-dorado/30 text-dorado text-body-xs hover:bg-dorado/25 disabled:opacity-50"
                >
                  <Check size={13} />
                  Aprobar
                </button>
                <button
                  type="button"
                  disabled={mutAprobar.isPending || mutRechazar.isPending}
                  onClick={() => mutRechazar.mutate(item.id)}
                  className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-white/5 border border-white/10 text-blanco-roto/70 text-body-xs hover:bg-white/10 disabled:opacity-50"
                >
                  <X size={13} />
                  Rechazar
                </button>
              </div>
            )}
          </li>
        ))}
      </ul>

      {(mutAprobar.isError || mutRechazar.isError) && (
        <p className="text-body-xs text-rojo-alerta/80">
          {(mutAprobar.error as Error)?.message ?? (mutRechazar.error as Error)?.message}
        </p>
      )}
    </section>
  )
}
