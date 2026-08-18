import { useQuery } from '@tanstack/react-query'
import { supabase } from '@/lib/supabase'
import { StatCard } from '@/components/ui/StatCard'
import type { OcupacionMensual } from '@/types/database.types'

async function fetchOcupacion(): Promise<OcupacionMensual[]> {
  const { data, error } = await supabase
    .from('v_ocupacion_mensual')
    .select('*')
    .limit(12)
  if (error) throw error
  return data as OcupacionMensual[]
}

async function fetchComisionesPorOperador() {
  const { data } = await supabase
    .from('reservas')
    .select('comision, operadores(nombre)')
    .is('deleted_at', null)
    .not('comision', 'is', null)
  return data ?? []
}

function formatMonto(m: number) {
  if (m >= 1_000_000) return `$${(m / 1_000_000).toFixed(1)}M`
  return `$${(m / 1_000).toFixed(0)}k`
}

function formatMes(fechaStr: string) {
  const d = new Date(fechaStr + 'T12:00:00')
  return d.toLocaleDateString('es-CO', { month: 'long', year: 'numeric' })
}

export default function Finanzas() {
  const { data: meses = [], isLoading } = useQuery({
    queryKey: ['ocupacion-mensual'],
    queryFn: fetchOcupacion,
  })

  const { data: comisionesRaw = [] } = useQuery({
    queryKey: ['comisiones-operador'],
    queryFn: fetchComisionesPorOperador,
  })

  // Agrupar comisiones por operador
  const comisionesPorOp: Record<string, number> = {}
  comisionesRaw.forEach((r: any) => {
    const op = r.operadores?.nombre ?? 'Sin operador'
    comisionesPorOp[op] = (comisionesPorOp[op] ?? 0) + (r.comision ?? 0)
  })

  const mesActual = meses[0]
  const totalBruto = meses.reduce((s, m) => s + m.ingresos_brutos, 0)
  const totalNeto  = meses.reduce((s, m) => s + m.ingresos_netos,  0)
  const totalCom   = meses.reduce((s, m) => s + m.total_comisiones, 0)

  return (
    <div className="p-4 lg:p-6 space-y-6">

      {/* Totales globales */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        <StatCard label="Ingresos brutos"  value={formatMonto(totalBruto)} accent />
        <StatCard label="Ingresos netos"   value={formatMonto(totalNeto)} />
        <StatCard label="Comisiones totales" value={formatMonto(totalCom)} />
        <StatCard
          label="Mes actual"
          value={mesActual ? `${mesActual.porcentaje_ocupacion}%` : '—'}
          sub={mesActual ? `${mesActual.noches_ocupadas} noches` : ''}
        />
      </div>

      {/* Tabla por mes */}
      <div className="space-y-3">
        <h2 className="text-body-sm font-semibold text-blanco-roto/60 uppercase tracking-wider">
          Reporte por mes
        </h2>

        {isLoading && <div className="h-64 rounded-2xl shimmer" />}

        {!isLoading && meses.length === 0 && (
          <div className="glass rounded-2xl p-10 text-center">
            <p className="text-body-md text-blanco-roto/50">Sin datos financieros</p>
            <p className="text-body-sm text-blanco-roto/30 mt-1">Sube las reservas para ver los reportes</p>
          </div>
        )}

        {meses.length > 0 && (
          <div className="glass rounded-2xl overflow-hidden">
            <table className="w-full">
              <thead>
                <tr className="border-b border-white/5">
                  {['Mes', 'Reservas', 'Noches', 'Ocupación', 'Bruto', 'Comisiones', 'Neto'].map(h => (
                    <th key={h} className="text-left text-body-xs text-blanco-roto/40 uppercase tracking-wider px-4 py-3">
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {meses.map(m => (
                  <tr key={m.mes} className="hover:bg-white/5 transition-colors">
                    <td className="px-4 py-3.5 text-body-sm font-medium text-blanco-roto capitalize">
                      {formatMes(m.mes)}
                    </td>
                    <td className="px-4 py-3.5 font-mono text-mono-sm text-blanco-roto/70">{m.total_reservas}</td>
                    <td className="px-4 py-3.5 font-mono text-mono-sm text-blanco-roto/70">{m.noches_ocupadas}</td>
                    <td className="px-4 py-3.5">
                      <div className="flex items-center gap-2">
                        <div className="flex-1 h-1.5 bg-negro-profundo rounded-full overflow-hidden max-w-16">
                          <div
                            className="h-full bg-dorado rounded-full"
                            style={{ width: `${Math.min(m.porcentaje_ocupacion, 100)}%` }}
                          />
                        </div>
                        <span className="font-mono text-mono-sm text-blanco-roto/70">{m.porcentaje_ocupacion}%</span>
                      </div>
                    </td>
                    <td className="px-4 py-3.5 font-mono text-mono-sm text-blanco-roto">{formatMonto(m.ingresos_brutos)}</td>
                    <td className="px-4 py-3.5 font-mono text-mono-sm text-red-400/70">-{formatMonto(m.total_comisiones)}</td>
                    <td className="px-4 py-3.5 font-mono text-mono-sm text-green-400">{formatMonto(m.ingresos_netos)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Comisiones por operador */}
      {Object.keys(comisionesPorOp).length > 0 && (
        <div className="space-y-3">
          <h2 className="text-body-sm font-semibold text-blanco-roto/60 uppercase tracking-wider">
            Comisiones por canal
          </h2>
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-3">
            {Object.entries(comisionesPorOp)
              .sort(([, a], [, b]) => b - a)
              .map(([op, total]) => (
                <div key={op} className="glass rounded-xl p-4">
                  <p className="text-body-xs text-blanco-roto/40 uppercase tracking-wider">{op}</p>
                  <p className="font-mono text-mono-lg font-bold text-red-400/80 mt-1">{formatMonto(total)}</p>
                </div>
              ))}
          </div>
        </div>
      )}
    </div>
  )
}
