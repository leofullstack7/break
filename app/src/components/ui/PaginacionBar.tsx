import { ChevronLeft, ChevronRight } from 'lucide-react'

interface Props {
  pagina: number
  totalPags: number
  desde: number
  hasta: number
  total: number
  onPagina: (n: number) => void
}

/** Barra fija sobre el bottom nav, para que Hormiga no tape los números. */
export function PaginacionBar({ pagina, totalPags, desde, hasta, total, onPagina }: Props) {
  if (totalPags <= 1) return null
  const nums = Array.from({ length: Math.min(totalPags, 5) }, (_, i) => {
    if (totalPags <= 5) return i + 1
    if (pagina <= 3) return i + 1
    if (pagina >= totalPags - 2) return totalPags - 4 + i
    return pagina - 2 + i
  })

  return (
    <div className="sticky bottom-0 z-30 -mx-4 lg:-mx-6 mt-2 px-4 lg:px-6 py-2.5 bg-negro-absoluto/95 backdrop-blur-md border-t border-white/10">
      <div className="flex items-center justify-between gap-3">
        <p className="text-body-xs text-blanco-roto/35 shrink-0">
          {desde}–{hasta} de {total}
        </p>
        <div className="flex items-center gap-1.5">
          <button
            type="button"
            onClick={() => onPagina(Math.max(1, pagina - 1))}
            disabled={pagina <= 1}
            className="p-2 rounded-xl border border-white/10 text-blanco-roto/50 disabled:opacity-30"
            aria-label="Anterior"
          >
            <ChevronLeft size={15} />
          </button>
          {nums.map(num => (
            <button
              key={num}
              type="button"
              onClick={() => onPagina(num)}
              className={`w-8 h-8 rounded-lg text-body-xs font-mono ${
                num === pagina
                  ? 'bg-dorado text-negro-absoluto font-bold'
                  : 'border border-white/10 text-blanco-roto/50'
              }`}
            >
              {num}
            </button>
          ))}
          <button
            type="button"
            onClick={() => onPagina(Math.min(totalPags, pagina + 1))}
            disabled={pagina >= totalPags}
            className="p-2 rounded-xl border border-white/10 text-blanco-roto/50 disabled:opacity-30"
            aria-label="Siguiente"
          >
            <ChevronRight size={15} />
          </button>
        </div>
      </div>
    </div>
  )
}
