import { Search } from 'lucide-react'

interface SearchInputProps {
  value: string
  onChange: (v: string) => void
  placeholder?: string
  className?: string
}

export function SearchInput({ value, onChange, placeholder = 'Buscar...', className = '' }: SearchInputProps) {
  return (
    <div className={`relative ${className}`}>
      <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-blanco-roto/30" />
      <input
        type="text"
        value={value}
        onChange={e => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full bg-negro-profundo border border-white/10 rounded-xl pl-9 pr-4 py-2.5 text-body-sm text-blanco-roto placeholder:text-blanco-roto/30 focus:outline-none focus:border-dorado/50 transition-colors"
      />
    </div>
  )
}
