// supabase/functions/_shared/factura-mapper.ts
//
// Funciones puras (sin llamadas de red) que traducen un voucher de PxSol +
// sus voucher_items a los payloads que espera Siigo. Los mapeos específicos
// de la cuenta de Break Hotel (productos, formas de pago, impuestos,
// ciudades, tipos de documento) se resuelven contra la tabla
// siigo_catalogo_map (ver 02-mapeo-campos-pxsol-siigo.md), no se hardcodean
// acá — así se pueden ajustar sin redeploy.

import { getSupabaseAdmin } from "./supabase-admin.ts";
import type { PxSolVoucherAttributes, PxSolVoucherItem } from "./pxsol-types.ts";
import type { SiigoCustomerPayload, SiigoInvoiceItem, SiigoInvoicePayment } from "./siigo-types.ts";

type CatalogoTipo = "producto" | "forma_pago" | "impuesto" | "documento_identidad" | "ciudad";

/** Carga todo siigo_catalogo_map de un tipo dado como Map<clave_pxsol, valor_siigo>. */
async function loadCatalogoMap(tipo: CatalogoTipo): Promise<Map<string, string>> {
  const supabase = getSupabaseAdmin();
  const { data, error } = await supabase
    .from("siigo_catalogo_map")
    .select("clave_pxsol, valor_siigo")
    .eq("tipo", tipo)
    .eq("activo", true);

  if (error) throw new Error(`No se pudo leer siigo_catalogo_map[${tipo}]: ${error.message}`);

  const map = new Map<string, string>();
  for (const row of data ?? []) map.set(row.clave_pxsol, row.valor_siigo);
  return map;
}

export class MapeoFaltanteError extends Error {
  constructor(public tipo: CatalogoTipo, public clave: string) {
    super(`Falta mapeo en siigo_catalogo_map: tipo="${tipo}" clave_pxsol="${clave}". Configúralo antes de reintentar.`);
  }
}

/**
 * Construye el customer payload de Siigo a partir de los atributos del
 * voucher de PxSol. Si el documento no es mapeable (extranjero sin
 * identificación válida), usar buildConsumidorFinalPayload en su lugar
 * (decisión en el llamador, ver siigo-sync-factura/index.ts).
 */
export async function buildCustomerPayload(attrs: PxSolVoucherAttributes): Promise<SiigoCustomerPayload> {
  const docTypeMap = await loadCatalogoMap("documento_identidad");
  const ciudadMap = await loadCatalogoMap("ciudad");

  const pxsolDocType = attrs.document_type ?? "";
  const idType = docTypeMap.get(pxsolDocType);
  if (!idType) throw new MapeoFaltanteError("documento_identidad", pxsolDocType);

  const ciudadKey = (attrs.city ?? "").trim().toLowerCase();
  const ciudadValor = ciudadMap.get(ciudadKey);
  // Fallback documentado (no silencioso): si no hay match de ciudad, se usa
  // Bogotá y se deja constancia en el log del llamador para revisión manual.
  const [country_code, state_code, city_code] = (ciudadValor ?? "CO|11|11001").split("|");

  const isCompany = attrs.person_type === "Company";
  const name = isCompany
    ? [attrs.social_reason ?? "Cliente sin nombre"]
    : [attrs.name || "Huesped", attrs.last_name || "PxSol"];

  const payload: SiigoCustomerPayload = {
    person_type: attrs.person_type,
    id_type: idType,
    identification: attrs.document_number ?? "",
    branch_office: 0,
    name,
    address: {
      address: attrs.address || "N/A",
      city: { country_code, state_code, city_code },
    },
    fiscal_responsibilities: [{ code: "R-99-PN" }],
    ...(attrs.email ? { contacts: [{ first_name: name[0], last_name: name[1], email: attrs.email }] } : {}),
  };

  return payload;
}

/** Payload de tercero genérico "Consumidor Final" para huéspedes sin documento mapeable. */
export function buildConsumidorFinalPayload(consumidorFinalId: string): { identification: string } {
  return { identification: consumidorFinalId };
}

/** Mapea voucher_items de PxSol a items[] de la factura de Siigo. */
export async function buildInvoiceItems(items: PxSolVoucherItem[]): Promise<SiigoInvoiceItem[]> {
  const productoMap = await loadCatalogoMap("producto");
  const impuestoMap = await loadCatalogoMap("impuesto");

  const result: SiigoInvoiceItem[] = [];
  for (const item of items) {
    const productKey = item.product_id != null ? String(item.product_id) : item.code;
    const siigoCode = productoMap.get(productKey);
    if (!siigoCode) throw new MapeoFaltanteError("producto", productKey);

    const taxes: { id: number }[] = [];
    const porcentaje = (item.taxes ?? "0").toString();
    if (parseFloat(porcentaje) > 0) {
      const impuestoId = impuestoMap.get(porcentaje);
      if (!impuestoId) throw new MapeoFaltanteError("impuesto", porcentaje);
      taxes.push({ id: Number(impuestoId) });
    }

    result.push({
      code: siigoCode,
      description: item.description,
      quantity: item.units,
      price: Number(item.price),
      discount: item.discount ? Number(item.discount) : undefined,
      taxes: taxes.length ? taxes : undefined,
    });
  }
  return result;
}

/** Mapea la forma de pago de PxSol (viene como "[Tarjeta_de_Credito]") a payments[] de Siigo. */
export async function buildPayments(attrs: PxSolVoucherAttributes): Promise<SiigoInvoicePayment[]> {
  const formaPagoMap = await loadCatalogoMap("forma_pago");
  // PxSol lo trae entre corchetes, ej. "[Tarjeta_de_Credito]" — normalizar.
  const raw = (attrs.payment_type ?? "").replace(/^\[|\]$/g, "");
  const siigoId = formaPagoMap.get(raw);
  if (!siigoId) throw new MapeoFaltanteError("forma_pago", raw);

  return [
    {
      id: Number(siigoId),
      value: Number(attrs.total),
    },
  ];
}
