// supabase/functions/_shared/siigo-client.ts
//
// Cliente delgado para Siigo API, con caché de token en integraciones_config.
// El token de Siigo dura 24h — se renueva antes de expirar, no solo cuando
// falla una petición.
//
// Docs: https://siigoapi.docs.apiary.io/

import { getIntegracionConfig, setIntegracionConfig } from "./supabase-admin.ts";
import type {
  SiigoAuthResponse,
  SiigoCustomerPayload,
  SiigoInvoicePayload,
  SiigoInvoiceResponse,
} from "./siigo-types.ts";

const SIIGO_BASE_URL = "https://api.siigo.com";
const TOKEN_CONFIG_KEY = "siigo_token";
// Siigo documenta 24h; renovamos con 30 min de margen para evitar carreras.
const TOKEN_SAFETY_MARGIN_MS = 30 * 60 * 1000;

interface CachedToken {
  access_token: string;
  expires_at: string; // ISO
}

function requiredEnv(name: string): string {
  const v = Deno.env.get(name);
  if (!v) throw new Error(`Falta el secret ${name}.`);
  return v;
}

function partnerHeaders(extra?: Record<string, string>): Record<string, string> {
  return {
    "Content-Type": "application/json",
    Accept: "application/json",
    "Partner-Id": requiredEnv("SIIGO_PARTNER_ID"),
    ...extra,
  };
}

/** Pide un access_token nuevo a Siigo (POST /auth). No usar directo: usar getValidSiigoToken(). */
async function requestNewToken(): Promise<CachedToken> {
  const username = requiredEnv("SIIGO_USERNAME");
  const accessKey = requiredEnv("SIIGO_ACCESS_KEY");

  const res = await fetch(`${SIIGO_BASE_URL}/auth`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ username, access_key: accessKey }),
  });

  if (!res.ok) {
    const body = await res.text().catch(() => "");
    throw new Error(`Siigo /auth respondió ${res.status}: ${body.slice(0, 500)}`);
  }

  const json = (await res.json()) as SiigoAuthResponse;
  if (!json.access_token) throw new Error("Siigo /auth no devolvió access_token.");

  // Siigo no siempre informa expires_in; asumir 24h si no viene.
  const ttlMs = (json.expires_in ?? 24 * 60 * 60) * 1000;
  const expiresAt = new Date(Date.now() + ttlMs).toISOString();

  const cached: CachedToken = { access_token: json.access_token, expires_at: expiresAt };
  await setIntegracionConfig(TOKEN_CONFIG_KEY, cached);
  return cached;
}

/** Devuelve un token válido, renovando automáticamente si está por expirar. */
export async function getValidSiigoToken(): Promise<string> {
  const cached = await getIntegracionConfig<CachedToken>(TOKEN_CONFIG_KEY);

  if (cached?.access_token && cached.expires_at) {
    const expiresAt = new Date(cached.expires_at).getTime();
    if (expiresAt - Date.now() > TOKEN_SAFETY_MARGIN_MS) {
      return cached.access_token;
    }
  }

  const fresh = await requestNewToken();
  return fresh.access_token;
}

async function siigoFetch<T>(
  path: string,
  init: { method?: string; body?: unknown; idempotencyKey?: string } = {},
): Promise<T> {
  const token = await getValidSiigoToken();
  const res = await fetch(`${SIIGO_BASE_URL}${path}`, {
    method: init.method ?? "GET",
    headers: partnerHeaders({
      Authorization: `Bearer ${token}`,
      ...(init.idempotencyKey ? { "Idempotency-Key": init.idempotencyKey } : {}),
    }),
    body: init.body ? JSON.stringify(init.body) : undefined,
  });

  const text = await res.text();
  let json: unknown = null;
  try {
    json = text ? JSON.parse(text) : null;
  } catch {
    // respuesta no-JSON, se deja json=null y se reporta el texto crudo abajo
  }

  if (!res.ok) {
    throw new Error(`Siigo API ${res.status} en ${path}: ${text.slice(0, 800)}`);
  }

  return json as T;
}

/** Busca un tercero por identificación. Devuelve null si no existe. */
export async function findCustomerByIdentification(identification: string): Promise<{ id: string } | null> {
  const result = await siigoFetch<{ results: Array<{ id: string }> }>(
    `/v1/customers?identification=${encodeURIComponent(identification)}`,
  );
  return result.results?.[0] ?? null;
}

/** Crea un tercero en Siigo. */
export async function createCustomer(payload: SiigoCustomerPayload): Promise<{ id: string }> {
  return siigoFetch<{ id: string }>("/v1/customers", { method: "POST", body: payload });
}

/**
 * Devuelve el id del tercero en Siigo, creándolo si no existe. No actualiza
 * un tercero ya existente (escritura quirúrgica: no pisamos datos que un
 * humano pudo haber corregido directamente en Siigo Nube).
 */
export async function ensureCustomer(payload: SiigoCustomerPayload): Promise<string> {
  const existing = await findCustomerByIdentification(payload.identification);
  if (existing) return existing.id;
  const created = await createCustomer(payload);
  return created.id;
}

/**
 * Crea una factura de venta. `idempotencyKey` debe ser el id del voucher de
 * PxSol (como string), así un reintento no crea una factura duplicada.
 */
export async function createInvoice(
  payload: SiigoInvoicePayload,
  idempotencyKey: string,
): Promise<SiigoInvoiceResponse> {
  return siigoFetch<SiigoInvoiceResponse>("/v1/invoices", {
    method: "POST",
    body: payload,
    idempotencyKey,
  });
}
