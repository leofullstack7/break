import { useState } from 'react'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { ChevronRight, RefreshCw, Users } from 'lucide-react'
import { supabase } from '@/lib/supabase'
import { syncContactosPxsol } from '@/lib/pxsol-contactos'
import { SearchInput } from '@/components/ui/SearchInput'
import type { Huesped } from '@/types/database.types'

interface HuespedConVisitas extends Huesped {
  total_visitas: number
}

async function fetchHuespedes(busqueda: string): Promise<HuespedConVisitas[]> {
  let q = supabase
    .from('huespedes')
    .select('*, reservas(count)')
    .is('deleted_at', null)
    .order('nombre')
    .limit(500)

  if (busqueda.trim()) {
    q = q.or(
      `nombre.ilike.%${busqueda}%,celular.ilike.%${busqueda}%,correo.ilike.%${busqueda}%`
    )
  }

  const { data, error } = await q
  if (error) throw error

  return (data ?? []).map((h: any) => ({
    ...h,
    total_visitas: h.reservas?.[0]?.count ?? 0,
  }))
}

export default function Huespedes() {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const [busqueda, setBusqueda] = useState('')
  const [filtroNac, setFiltroNac] = useState('')
  const [syncing, setSyncing] = useState(false)
  const [syncMsg, setSyncMsg] = useState<string | null>(null)

  const { data: huespedes = [], isLoading } = useQuery({
    queryKey: ['huespedes', busqueda],
    queryFn: () => fetchHuespedes(busqueda),
    staleTime: 60_000,
  })

  const filtrados = filtroNac
    ? huespedes.filter(h => h.nacionalidad?.toLowerCase().includes(filtroNac.toLowerCase()))
    : huespedes

  const extranjeros = huespedes.filter(h => h.nacionalidad !== 'colombiana').length

  async function sincronizarContactos() {
    setSyncing(true)
    setSyncMsg(null)
    try {
      const r = await syncContactosPxsol({ force: true })
      if (r.ok) {
        setSyncMsg(
          `PxSol · ${r.creados ?? 0} nuevos · ${r.actualizados ?? 0} actualizados` +
            (r.errores ? ` · ${r.errores} errores` : '') +
            ` · ${r.contactos_unicos ?? 0} en origen`,
        )
        await queryClient.invalidateQueries({ queryKey: ['huespedes'] })
        await queryClient.invalidateQueries({ queryKey: ['marketing-contactos'] })
      } else {
        setSyncMsg(r.error ?? 'No se pudo sincronizar contactos con PxSol')
      }
    } catch (e) {
      setSyncMsg(e instanceof Error ? e.message : 'Error de sync')
    } finally {
      setSyncing(false)
    }
  }

  return (
    <div className="p-4 lg:p-6 space-y-5">

      {/* Cabecera + sync manual */}
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <p className="text-body-xs text-blanco-roto/35 uppercase tracking-wider">
            CRM de huéspedes
          </p>
          {syncMsg && (
            <p className="text-body-xs text-blanco-roto/45 mt-1 break-words">{syncMsg}</p>
          )}
        </div>
        <button
          type="button"
          onClick={() => void sincronizarContactos()}
          disabled={syncing}
          className="inline-flex items-center gap-2 px-3 py-2 rounded-xl border border-white/10 text-body-xs text-blanco-roto/70 hover:text-blanco-roto hover:border-dorado/40 disabled:opacity-50 transition-colors shrink-0"
        >
          <RefreshCw size={14} className={syncing ? 'animate-spin text-dorado' : 'text-dorado/80'} />
          {syncing ? 'Sincronizando…' : 'Sincronizar contactos PxSol'}
        </button>
      </div>

      {/* Stats rápidas */}
      <div className="grid grid-cols-2 lg:grid-cols-3 gap-3">
        <div className="glass rounded-xl p-4">
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Total huéspedes</p>
          <p className="font-mono text-mono-lg font-bold text-dorado mt-1">{huespedes.length}</p>
        </div>
        <div className="glass rounded-xl p-4">
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Extranjeros</p>
          <p className="font-mono text-mono-lg font-bold text-blanco-roto mt-1">{extranjeros}</p>
        </div>
        <div className="glass rounded-xl p-4 hidden lg:block">
          <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">Colombianos</p>
          <p className="font-mono text-mono-lg font-bold text-blanco-roto mt-1">{huespedes.length - extranjeros}</p>
        </div>
      </div>

      {/* Filtros */}
      <div className="flex gap-3 flex-col sm:flex-row">
        <SearchInput
          value={busqueda}
          onChange={setBusqueda}
          placeholder="Buscar por nombre, celular o correo..."
          className="flex-1"
        />
        <select
          value={filtroNac}
          onChange={e => setFiltroNac(e.target.value)}
          className="bg-negro-profundo border border-white/10 rounded-xl px-3 py-2.5 text-body-sm text-blanco-roto focus:outline-none focus:border-dorado/50 sm:w-48"
        >
          <option value="">Todos los países</option>
          <option value="colombiana">Colombia</option>
          <option value="" disabled>—</option>
          {[...new Set(huespedes.filter(h => h.nacionalidad !== 'colombiana').map(h => h.nacionalidad))]
            .sort()
            .map(n => <option key={n} value={n ?? ''}>{n}</option>)}
        </select>
      </div>

      {/* Tabla / Lista */}
      {isLoading && (
        <div className="space-y-2">
          {Array.from({ length: 8 }).map((_, i) => (
            <div key={i} className="h-16 rounded-xl shimmer" />
          ))}
        </div>
      )}

      {!isLoading && filtrados.length === 0 && (
        <div className="glass rounded-2xl p-12 text-center">
          <Users size={32} className="mx-auto text-blanco-roto/20 mb-3" />
          <p className="text-body-md text-blanco-roto/50">No se encontraron huéspedes</p>
          {busqueda && (
            <button onClick={() => setBusqueda('')} className="mt-3 text-body-sm text-dorado">
              Limpiar búsqueda
            </button>
          )}
        </div>
      )}

      {/* Desktop: tabla */}
      {!isLoading && filtrados.length > 0 && (
        <>
          <div className="hidden lg:block glass rounded-2xl overflow-hidden">
            <table className="w-full">
              <thead>
                <tr className="border-b border-white/5">
                  <th className="text-left text-body-xs text-blanco-roto/40 uppercase tracking-wider px-5 py-3">Nombre</th>
                  <th className="text-left text-body-xs text-blanco-roto/40 uppercase tracking-wider px-5 py-3">Celular</th>
                  <th className="text-left text-body-xs text-blanco-roto/40 uppercase tracking-wider px-5 py-3">Correo</th>
                  <th className="text-left text-body-xs text-blanco-roto/40 uppercase tracking-wider px-5 py-3">País</th>
                  <th className="text-right text-body-xs text-blanco-roto/40 uppercase tracking-wider px-5 py-3">Visitas</th>
                  <th className="px-3 py-3" />
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {filtrados.map(h => (
                  <tr
                    key={h.id}
                    onClick={() => navigate(`/admin/huespedes/${h.id}`)}
                    className="hover:bg-white/5 cursor-pointer transition-colors group"
                  >
                    <td className="px-5 py-3.5">
                      <p className="text-body-sm font-medium text-blanco-roto">{h.nombre}</p>
                      {h.pxsol_pax_id && (
                        <p className="text-body-xs text-blanco-roto/25 font-mono mt-0.5">
                          PxSol · {h.pxsol_pax_id}
                        </p>
                      )}
                    </td>
                    <td className="px-5 py-3.5">
                      <p className="text-body-sm text-blanco-roto/60 font-mono">{h.celular ?? '—'}</p>
                    </td>
                    <td className="px-5 py-3.5">
                      <p className="text-body-sm text-blanco-roto/60 truncate max-w-48">{h.correo ?? '—'}</p>
                    </td>
                    <td className="px-5 py-3.5">
                      <p className="text-body-sm text-blanco-roto/60 capitalize">{h.nacionalidad}</p>
                    </td>
                    <td className="px-5 py-3.5 text-right">
                      <span className="font-mono text-mono-sm text-blanco-roto/80">{h.total_visitas}</span>
                    </td>
                    <td className="px-3 py-3.5">
                      <ChevronRight size={14} className="text-blanco-roto/20 group-hover:text-dorado transition-colors" />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Mobile: lista */}
          <div className="lg:hidden space-y-2">
            {filtrados.map(h => (
              <button
                key={h.id}
                onClick={() => navigate(`/admin/huespedes/${h.id}`)}
                className="glass rounded-xl p-4 flex items-center gap-3 w-full text-left hover:border-dorado/20 transition-all"
              >
                <div className="w-9 h-9 rounded-full bg-dorado/10 border border-dorado/20 flex items-center justify-center shrink-0">
                  <span className="text-body-sm font-bold text-dorado">{h.nombre.charAt(0).toUpperCase()}</span>
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-body-sm font-medium text-blanco-roto truncate">{h.nombre}</p>
                  <p className="text-body-xs text-blanco-roto/40 truncate">{h.celular ?? h.correo ?? '—'}</p>
                </div>
                <div className="text-right shrink-0">
                  <p className="font-mono text-mono-sm text-blanco-roto/60">{h.total_visitas}x</p>
                  <ChevronRight size={14} className="text-blanco-roto/20 ml-auto mt-0.5" />
                </div>
              </button>
            ))}
          </div>

          <p className="text-body-xs text-blanco-roto/30 text-center">
            Mostrando {filtrados.length} huéspedes
          </p>
        </>
      )}
    </div>
  )
}
