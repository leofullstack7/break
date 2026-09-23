import { describe, expect, it } from 'vitest'
import { asuntoEsFacturacion, parseDianInvoiceXml } from '@/lib/dian-xml'

const FIXTURE = `<?xml version="1.0" encoding="UTF-8"?>
<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
  xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
  xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
  <cbc:UUID>abc123cufe0000000000000000000000000001</cbc:UUID>
  <cbc:ID>SETT98765</cbc:ID>
  <cbc:IssueDate>2026-03-15</cbc:IssueDate>
  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>
  <cac:AccountingSupplierParty>
    <cac:Party>
      <cac:PartyTaxScheme>
        <cbc:RegistrationName>Proveedor Ejemplo SAS</cbc:RegistrationName>
        <cbc:CompanyID>900123456</cbc:CompanyID>
      </cac:PartyTaxScheme>
    </cac:Party>
  </cac:AccountingSupplierParty>
  <cac:AccountingCustomerParty>
    <cac:Party>
      <cac:PartyTaxScheme>
        <cbc:CompanyID>901234567</cbc:CompanyID>
      </cac:PartyTaxScheme>
    </cac:Party>
  </cac:AccountingCustomerParty>
  <cac:TaxTotal>
    <cbc:TaxAmount>19000.00</cbc:TaxAmount>
  </cac:TaxTotal>
  <cac:LegalMonetaryTotal>
    <cbc:LineExtensionAmount>100000.00</cbc:LineExtensionAmount>
    <cbc:TaxInclusiveAmount>119000.00</cbc:TaxInclusiveAmount>
    <cbc:PayableAmount>119000.00</cbc:PayableAmount>
  </cac:LegalMonetaryTotal>
  <cac:InvoiceLine>
    <cbc:InvoicedQuantity>2</cbc:InvoicedQuantity>
    <cbc:LineExtensionAmount>100000.00</cbc:LineExtensionAmount>
    <cac:Item>
      <cbc:Description>Servicio de aseo</cbc:Description>
    </cac:Item>
    <cac:Price>
      <cbc:PriceAmount>50000.00</cbc:PriceAmount>
    </cac:Price>
  </cac:InvoiceLine>
</Invoice>`

describe('asuntoEsFacturacion', () => {
  it('detecta facturación con tilde', () => {
    expect(asuntoEsFacturacion('Facturación electrónica marzo')).toBe(true)
  })
  it('detecta sin tilde', () => {
    expect(asuntoEsFacturacion('FW: facturacion proveedor')).toBe(true)
  })
  it('rechaza asuntos irrelevantes', () => {
    expect(asuntoEsFacturacion('Confirmación de reserva')).toBe(false)
  })
})

describe('parseDianInvoiceXml', () => {
  it('extrae proveedor, totales y líneas de un Invoice UBL', () => {
    const p = parseDianInvoiceXml(FIXTURE)
    expect(p.proveedor_nit).toBe('900123456')
    expect(p.proveedor_nombre).toBe('Proveedor Ejemplo SAS')
    expect(p.prefijo).toBe('SETT')
    expect(p.numero_factura).toBe('98765')
    expect(p.fecha_factura).toBe('2026-03-15')
    expect(p.total).toBe(119000)
    expect(p.iva).toBe(19000)
    expect(p.lineas).toHaveLength(1)
    expect(p.lineas[0].descripcion).toBe('Servicio de aseo')
    expect(p.lineas[0].cantidad).toBe(2)
  })
})
