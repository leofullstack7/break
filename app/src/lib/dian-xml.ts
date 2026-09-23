/**
 * Parser ligero de Invoice UBL DIAN (solo XML, sin ZIP).
 * Espejo de supabase/functions/_shared/dian-zip-parser.ts para tests y preview.
 */

export interface DianLinea {
  descripcion: string
  cantidad: number
  precio: number
  total: number
  iva_porcentaje?: number | null
}

export interface DianFacturaParseada {
  cufe: string | null
  prefijo: string | null
  numero_factura: string | null
  fecha_factura: string | null
  proveedor_nit: string | null
  proveedor_nombre: string | null
  receptor_nit: string | null
  moneda: string
  subtotal: number | null
  iva: number | null
  total: number | null
  lineas: DianLinea[]
}

function tag(xml: string, name: string): string | null {
  const re = new RegExp(
    `<(?:[\\w-]+:)?${name}(?:\\s[^>]*)?>([^<]*)</(?:[\\w-]+:)?${name}>`,
    'i',
  )
  const m = xml.match(re)
  return m?.[1]?.trim() || null
}

function allTags(xml: string, name: string): string[] {
  const re = new RegExp(
    `<(?:[\\w-]+:)?${name}(?:\\s[^>]*)?>([^<]*)</(?:[\\w-]+:)?${name}>`,
    'gi',
  )
  const out: string[] = []
  let m: RegExpExecArray | null
  while ((m = re.exec(xml)) !== null) {
    if (m[1]?.trim()) out.push(m[1].trim())
  }
  return out
}

function blocks(xml: string, name: string): string[] {
  const re = new RegExp(
    `<(?:[\\w-]+:)?${name}\\b[^>]*>([\\s\\S]*?)</(?:[\\w-]+:)?${name}>`,
    'gi',
  )
  const out: string[] = []
  let m: RegExpExecArray | null
  while ((m = re.exec(xml)) !== null) out.push(m[1])
  return out
}

function num(v: string | null | undefined): number | null {
  if (v == null || v === '') return null
  const n = Number(String(v).replace(',', '.'))
  return Number.isFinite(n) ? n : null
}

function limpiarNit(raw: string | null): string | null {
  if (!raw) return null
  const s = raw.replace(/[^\d]/g, '')
  return s.length >= 5 ? s : null
}

function splitPrefijoNumero(id: string | null): { prefijo: string | null; numero: string | null } {
  if (!id) return { prefijo: null, numero: null }
  const clean = id.trim()
  const m = clean.match(/^([A-Za-z]+)[-_]?(\d+)$/)
  if (m) return { prefijo: m[1].toUpperCase(), numero: m[2] }
  if (/^\d+$/.test(clean)) return { prefijo: null, numero: clean }
  return { prefijo: null, numero: clean }
}

export function asuntoEsFacturacion(subject: string, filtro = 'facturacion'): boolean {
  const norm = (s: string) =>
    s.toLowerCase().normalize('NFD').replace(/\p{M}/gu, '')
  const subj = norm(subject)
  const f = norm(filtro)
  return subj.includes(f) || subj.includes('factura')
}

export function parseDianInvoiceXml(xmlInput: string): DianFacturaParseada {
  let xml = xmlInput
  if (!(/InvoiceLine/i.test(xml))) {
    const cdata = xml.match(/<!\[CDATA\[([\s\S]*?<Invoice[\s\S]*?<\/Invoice>)\]\]>/i)
    if (cdata?.[1]) xml = cdata[1]
  }

  const cufe = tag(xml, 'UUID') || tag(xml, 'CUFE') || null
  const ids = allTags(xml, 'ID').filter(x => !/^[0-9a-f-]{36}$/i.test(x))
  const { prefijo, numero } = splitPrefijoNumero(ids[0] || tag(xml, 'ID'))

  const supplierXml = blocks(xml, 'AccountingSupplierParty')[0] ?? ''
  const customerXml = blocks(xml, 'AccountingCustomerParty')[0] ?? ''
  const monetary = blocks(xml, 'LegalMonetaryTotal')[0] ?? ''

  const lineas: DianLinea[] = blocks(xml, 'InvoiceLine').map(line => {
    const cantidad = num(tag(line, 'InvoicedQuantity')) ?? 1
    const totalLinea = num(tag(line, 'LineExtensionAmount')) ?? 0
    const precio =
      num(tag(blocks(line, 'Price')[0] ?? '', 'PriceAmount')) ??
      (cantidad ? totalLinea / cantidad : totalLinea)
    return {
      descripcion: (tag(line, 'Description') || tag(line, 'Name') || 'Ítem').slice(0, 200),
      cantidad,
      precio,
      total: totalLinea,
      iva_porcentaje: num(tag(line, 'Percent')),
    }
  })

  return {
    cufe,
    prefijo,
    numero_factura: numero,
    fecha_factura: tag(xml, 'IssueDate'),
    proveedor_nit: limpiarNit(tag(supplierXml, 'CompanyID')),
    proveedor_nombre: tag(supplierXml, 'RegistrationName') || tag(supplierXml, 'Name'),
    receptor_nit: limpiarNit(tag(customerXml, 'CompanyID')),
    moneda: tag(xml, 'DocumentCurrencyCode') || 'COP',
    subtotal: num(tag(monetary, 'LineExtensionAmount')) || num(tag(monetary, 'TaxExclusiveAmount')),
    iva: num(tag(blocks(xml, 'TaxTotal')[0] ?? '', 'TaxAmount')),
    total: num(tag(monetary, 'PayableAmount')) || num(tag(monetary, 'TaxInclusiveAmount')),
    lineas,
  }
}
