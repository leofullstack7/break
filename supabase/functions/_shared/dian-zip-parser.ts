// supabase/functions/_shared/dian-zip-parser.ts
//
// Extrae datos de una factura electrónica DIAN (Colombia) desde ZIP o XML.
// Siigo API no acepta el ZIP: hay que mapear a POST /v1/purchases.
//
// Estructura típica del ZIP DIAN:
//   - *.xml  (Invoice UBL o AttachedDocument con Invoice embebida)
//   - *.pdf  (representación gráfica, opcional)

import JSZip from "https://esm.sh/jszip@3.10.1";

export interface DianLinea {
  descripcion: string;
  cantidad: number;
  precio: number;
  total: number;
  iva_porcentaje?: number | null;
}

export interface DianFacturaParseada {
  cufe: string | null;
  prefijo: string | null;
  numero_factura: string | null;
  fecha_factura: string | null; // YYYY-MM-DD
  proveedor_nit: string | null;
  proveedor_nombre: string | null;
  proveedor_email: string | null;
  receptor_nit: string | null;
  moneda: string;
  subtotal: number | null;
  iva: number | null;
  total: number | null;
  lineas: DianLinea[];
  xml_nombre: string | null;
}

function tag(xml: string, name: string): string | null {
  // Soporta namespaces: <cbc:ID>...</cbc:ID> o <ID>...</ID>
  const re = new RegExp(
    `<(?:[\\w-]+:)?${name}(?:\\s[^>]*)?>([^<]*)</(?:[\\w-]+:)?${name}>`,
    "i",
  );
  const m = xml.match(re);
  return m?.[1]?.trim() || null;
}

function allTags(xml: string, name: string): string[] {
  const re = new RegExp(
    `<(?:[\\w-]+:)?${name}(?:\\s[^>]*)?>([^<]*)</(?:[\\w-]+:)?${name}>`,
    "gi",
  );
  const out: string[] = [];
  let m: RegExpExecArray | null;
  while ((m = re.exec(xml)) !== null) {
    if (m[1]?.trim()) out.push(m[1].trim());
  }
  return out;
}

function blocks(xml: string, name: string): string[] {
  const re = new RegExp(
    `<(?:[\\w-]+:)?${name}\\b[^>]*>([\\s\\S]*?)</(?:[\\w-]+:)?${name}>`,
    "gi",
  );
  const out: string[] = [];
  let m: RegExpExecArray | null;
  while ((m = re.exec(xml)) !== null) {
    out.push(m[1]);
  }
  return out;
}

function num(v: string | null | undefined): number | null {
  if (v == null || v === "") return null;
  const n = Number(String(v).replace(",", "."));
  return Number.isFinite(n) ? n : null;
}

function limpiarNit(raw: string | null): string | null {
  if (!raw) return null;
  // Quitar DV si viene con guión: 900123456-1 → 900123456
  const s = raw.replace(/[^\d]/g, "");
  if (s.length < 5) return null;
  // Si tiene 10+ dígitos y parece NIT+DV, dejar como está (Siigo a veces quiere sin DV)
  return s;
}

function splitPrefijoNumero(id: string | null): { prefijo: string | null; numero: string | null } {
  if (!id) return { prefijo: null, numero: null };
  const clean = id.trim();
  // Ej: SETT12345, FE-123, FV123, 12345
  const m = clean.match(/^([A-Za-z]+)[-_]?(\d+)$/);
  if (m) return { prefijo: m[1].toUpperCase(), numero: m[2] };
  if (/^\d+$/.test(clean)) return { prefijo: null, numero: clean };
  return { prefijo: null, numero: clean };
}

/** Si es AttachedDocument, extrae el Invoice embebido (CDATA o Description). */
function extraerInvoiceXml(xml: string): string {
  if (/Invoice\b/i.test(xml) && /InvoiceLine/i.test(xml)) return xml;

  // AttachedDocument → cac:Attachment → cbc:Description con CDATA Invoice
  const cdata = xml.match(/<!\[CDATA\[([\s\S]*?<Invoice[\s\S]*?<\/Invoice>)\]\]>/i);
  if (cdata?.[1]) return cdata[1];

  const desc = blocks(xml, "Description").find((d) => /<Invoice[\s\S]*<\/Invoice>/i.test(d));
  if (desc) {
    const inv = desc.match(/<Invoice[\s\S]*<\/Invoice>/i);
    if (inv) return inv[0];
  }
  return xml;
}

export function parseDianInvoiceXml(xmlInput: string): DianFacturaParseada {
  const xml = extraerInvoiceXml(xmlInput);

  const cufe =
    tag(xml, "UUID") ||
    tag(xml, "CUFE") ||
    null;

  const idFactura = tag(xml, "ID");
  // El primer ID suele ser el de la factura; filtrar UUIDs
  const ids = allTags(xml, "ID").filter((x) => !/^[0-9a-f-]{36}$/i.test(x));
  const numeroRaw = ids[0] || idFactura;
  const { prefijo, numero } = splitPrefijoNumero(numeroRaw);

  const fecha = tag(xml, "IssueDate");

  // Proveedor: primer AccountingSupplierParty
  const supplierBlocks = blocks(xml, "AccountingSupplierParty");
  const supplierXml = supplierBlocks[0] ?? "";
  const proveedor_nit =
    limpiarNit(tag(supplierXml, "CompanyID")) ||
    limpiarNit(allTags(supplierXml, "CompanyID")[0] ?? null);
  const proveedor_nombre =
    tag(supplierXml, "RegistrationName") ||
    tag(supplierXml, "Name") ||
    null;
  const proveedor_email = tag(supplierXml, "ElectronicMail");

  // Receptor
  const customerBlocks = blocks(xml, "AccountingCustomerParty");
  const customerXml = customerBlocks[0] ?? "";
  const receptor_nit =
    limpiarNit(tag(customerXml, "CompanyID")) ||
    limpiarNit(allTags(customerXml, "CompanyID")[0] ?? null);

  const moneda = tag(xml, "DocumentCurrencyCode") || "COP";

  // Totales
  const monetary = blocks(xml, "LegalMonetaryTotal")[0] ?? "";
  const subtotal =
    num(tag(monetary, "LineExtensionAmount")) ||
    num(tag(monetary, "TaxExclusiveAmount"));
  const total =
    num(tag(monetary, "PayableAmount")) ||
    num(tag(monetary, "TaxInclusiveAmount"));

  // IVA: primer TaxTotal con TaxAmount
  const taxBlocks = blocks(xml, "TaxTotal");
  let iva: number | null = null;
  for (const tb of taxBlocks) {
    const scheme = tag(tb, "ID") || tag(tb, "Name") || "";
    const amount = num(tag(tb, "TaxAmount"));
    if (amount == null) continue;
    if (/01|IVA|iva/i.test(scheme) || iva == null) {
      iva = (iva ?? 0) + amount;
      if (/01|IVA/i.test(scheme)) break;
    }
  }

  // Líneas
  const lineas: DianLinea[] = [];
  for (const line of blocks(xml, "InvoiceLine")) {
    const descripcion =
      tag(line, "Description") ||
      tag(line, "Name") ||
      "Ítem factura";
    const cantidad = num(tag(line, "InvoicedQuantity")) ?? 1;
    const totalLinea = num(tag(line, "LineExtensionAmount")) ?? 0;
    const precio =
      num(tag(blocks(line, "Price")[0] ?? "", "PriceAmount")) ??
      (cantidad ? totalLinea / cantidad : totalLinea);
    const taxPercent = num(tag(line, "Percent"));
    lineas.push({
      descripcion: descripcion.slice(0, 200),
      cantidad,
      precio,
      total: totalLinea,
      iva_porcentaje: taxPercent,
    });
  }

  return {
    cufe,
    prefijo,
    numero_factura: numero,
    fecha_factura: fecha,
    proveedor_nit,
    proveedor_nombre,
    proveedor_email,
    receptor_nit,
    moneda,
    subtotal,
    iva,
    total,
    lineas,
    xml_nombre: null,
  };
}

/** Abre un ZIP DIAN y parsea el primer XML de factura encontrado. */
export async function parseDianZip(
  bytes: Uint8Array,
): Promise<{ parsed: DianFacturaParseada; xmlBytes: Uint8Array; xmlNombre: string }> {
  const zip = await JSZip.loadAsync(bytes);
  const xmlEntries = Object.keys(zip.files).filter(
    (n) => n.toLowerCase().endsWith(".xml") && !zip.files[n].dir,
  );
  if (xmlEntries.length === 0) {
    throw new Error("El ZIP no contiene ningún archivo XML");
  }

  // Preferir Invoice / attached sobre otros
  xmlEntries.sort((a, b) => {
    const score = (n: string) =>
      /invoice|attached|factura/i.test(n) ? 0 : 1;
    return score(a) - score(b);
  });

  const nombre = xmlEntries[0];
  const xmlText = await zip.files[nombre].async("text");
  const parsed = parseDianInvoiceXml(xmlText);
  parsed.xml_nombre = nombre.split("/").pop() ?? nombre;
  const xmlBytes = new TextEncoder().encode(xmlText);
  return { parsed, xmlBytes, xmlNombre: parsed.xml_nombre };
}

/** Detecta si el buffer es ZIP (PK..) o XML. */
export async function parseDianArchivo(
  bytes: Uint8Array,
  mimeOrName: string,
): Promise<{ parsed: DianFacturaParseada; xmlBytes: Uint8Array; xmlNombre: string }> {
  const name = mimeOrName.toLowerCase();
  const isZip =
    name.includes("zip") ||
    (bytes[0] === 0x50 && bytes[1] === 0x4b); // PK

  if (isZip) return parseDianZip(bytes);

  const xmlText = new TextDecoder().decode(bytes);
  if (!/<Invoice|<AttachedDocument/i.test(xmlText)) {
    throw new Error("El archivo no parece una factura DIAN (Invoice/AttachedDocument)");
  }
  const parsed = parseDianInvoiceXml(xmlText);
  parsed.xml_nombre = "factura.xml";
  return {
    parsed,
    xmlBytes: bytes,
    xmlNombre: "factura.xml",
  };
}
