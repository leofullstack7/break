// supabase/functions/_shared/compra-mapper.ts
//
// Mapea una factura DIAN parseada → payload Siigo POST /v1/purchases.
// Requiere secrets:
//   SIIGO_PURCHASE_DOCUMENT_TYPE_ID
//   SIIGO_PURCHASE_PAYMENT_ID
//   SIIGO_PURCHASE_DEFAULT_PRODUCT_CODE
// Opcional: SIIGO_PURCHASE_TAX_IVA_ID (id impuesto 19% en Siigo)

import type { DianFacturaParseada } from "./dian-zip-parser.ts";
import type { SiigoCustomerPayload, SiigoPurchasePayload } from "./siigo-types.ts";

function requiredEnv(name: string): string {
  const v = Deno.env.get(name);
  if (!v) throw new Error(`Falta el secret ${name} para sincronizar compras.`);
  return v;
}

export function buildSupplierPayload(parsed: DianFacturaParseada): SiigoCustomerPayload {
  if (!parsed.proveedor_nit) {
    throw new Error("La factura no trae NIT del proveedor");
  }
  const nombre = (parsed.proveedor_nombre || `Proveedor ${parsed.proveedor_nit}`).trim();
  // NIT colombiano → Company; cédulas cortas → Person (heurística)
  const esEmpresa = parsed.proveedor_nit.length >= 9;
  return {
    person_type: esEmpresa ? "Company" : "Person",
    id_type: esEmpresa ? "31" : "13",
    identification: parsed.proveedor_nit,
    branch_office: 0,
    name: esEmpresa ? [nombre] : nombre.split(/\s+/).length >= 2
      ? [nombre.split(/\s+/).slice(0, -1).join(" "), nombre.split(/\s+/).slice(-1)[0]]
      : [nombre, "."],
    address: {
      address: "Colombia",
      city: { country_code: "Co", state_code: "17", city_code: "17001" }, // Manizales fallback
    },
    fiscal_responsibilities: [{ code: "R-99-PN" }],
    ...(parsed.proveedor_email
      ? {
          contacts: [{
            first_name: nombre.split(/\s+/)[0] || "Contacto",
            email: parsed.proveedor_email,
          }],
        }
      : {}),
  };
}

export function buildPurchasePayload(parsed: DianFacturaParseada): SiigoPurchasePayload {
  const documentId = Number(requiredEnv("SIIGO_PURCHASE_DOCUMENT_TYPE_ID"));
  const paymentId = Number(requiredEnv("SIIGO_PURCHASE_PAYMENT_ID"));
  const productCode = requiredEnv("SIIGO_PURCHASE_DEFAULT_PRODUCT_CODE");
  const taxIvaId = Deno.env.get("SIIGO_PURCHASE_TAX_IVA_ID");

  if (!parsed.proveedor_nit) throw new Error("Sin NIT de proveedor");
  if (!parsed.fecha_factura) throw new Error("Sin fecha de factura");
  if (!parsed.numero_factura && !parsed.cufe) {
    throw new Error("Sin número de factura ni CUFE");
  }

  const lineas = parsed.lineas.length > 0
    ? parsed.lineas
    : [{
      descripcion: `Compra ${parsed.prefijo ?? ""}${parsed.numero_factura ?? ""}`.trim(),
      cantidad: 1,
      precio: parsed.total ?? parsed.subtotal ?? 0,
      total: parsed.total ?? parsed.subtotal ?? 0,
      iva_porcentaje: null,
    }];

  const items = lineas.map((l) => ({
    type: "Product" as const,
    code: productCode,
    description: l.descripcion,
    quantity: Number(l.cantidad.toFixed(2)) || 1,
    price: Number(l.precio.toFixed(6)),
    ...(taxIvaId && (l.iva_porcentaje == null || l.iva_porcentaje > 0)
      ? { taxes: [{ id: Number(taxIvaId) }] }
      : {}),
  }));

  const totalPago = parsed.total ??
    items.reduce((s, i) => s + i.quantity * i.price, 0);

  return {
    document: { id: documentId },
    date: parsed.fecha_factura,
    supplier: {
      identification: parsed.proveedor_nit,
      branch_office: 0,
    },
    provider_invoice: {
      ...(parsed.prefijo ? { prefix: parsed.prefijo } : {}),
      number: String(parsed.numero_factura ?? parsed.cufe?.slice(0, 20) ?? "1"),
    },
    items,
    payments: [{
      id: paymentId,
      value: Number(totalPago.toFixed(2)),
    }],
    observations: [
      "Importado desde Break Digital (ZIP/XML DIAN)",
      parsed.cufe ? `CUFE: ${parsed.cufe}` : null,
      parsed.proveedor_nombre ? `Proveedor: ${parsed.proveedor_nombre}` : null,
    ].filter(Boolean).join(" · "),
  };
}

export function idempotencyKeyCompra(parsed: DianFacturaParseada): string {
  if (parsed.cufe) return `cufe-${parsed.cufe}`.slice(0, 72);
  return `fc-${parsed.proveedor_nit}-${parsed.prefijo ?? ""}-${parsed.numero_factura}`.slice(0, 72);
}
