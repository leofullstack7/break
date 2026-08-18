// Loader de página completa — aparece mientras React.lazy carga un chunk
// Nunca spinner genérico — shimmer elegante con el logo Break
export function PageLoader() {
  return (
    <div className="fixed inset-0 bg-negro-absoluto flex flex-col items-center justify-center gap-6">
      {/* Logo Break como texto mientras no haya SVG */}
      <span className="font-display text-display-md font-bold tracking-widest text-dorado select-none">
        BREAK
      </span>

      {/* Barra de progreso sutil */}
      <div className="w-24 h-px bg-gris-carbon overflow-hidden rounded-full">
        <div className="h-full bg-dorado shimmer" />
      </div>
    </div>
  )
}
