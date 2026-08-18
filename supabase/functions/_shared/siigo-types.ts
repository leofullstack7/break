// supabase/functions/_shared/siigo-types.ts
//
// Tipos mínimos para lo que usamos de Siigo API.
// Docs: https://siigoapi.docs.apiary.io/

export interface SiigoAuthResponse {
  access_token: string;
  token_type?: string;
  expires_in?: number; // segundos, si Siigo lo trae; si no, asumir 24h fijas
}

export interface SiigoCustomerName {
  // Person: [nombres, apellidos] · Company: [razón social]
}

export interface SiigoCustomerPayload {
  person_type: "Person" | "Company";
  id_type: string; // "13" cédula, "31" NIT, "22" CE, "41" pasaporte, etc.
  identification: string;
  branch_office?: number;
  name: string[];
  address: {
    address: string;
    city: {
      country_code: string;
      state_code: string;
      city_code: string;
    };
  };
  phones?: Array<{ indicative?: string; number?: string; extension?: string }>;
  fiscal_responsibilities?: Array<{ code: string }>;
  contacts?: Array<{ first_name: string; last_name?: string; email?: string }>;
}

export interface SiigoInvoiceItemTax {
  id: number;
}

export interface SiigoInvoiceItem {
  code: string;
  description?: string;
  quantity: number;
  price: number;
  discount?: number;
  taxes?: SiigoInvoiceItemTax[];
  seller?: number;
  warehouse?: number;
}

export interface SiigoInvoicePayment {
  id: number;
  value: number;
  due_date?: string; // yyyy-MM-dd, obligatorio si la forma de pago maneja vencimiento
}

export interface SiigoInvoicePayload {
  document: { id: number };
  date: string; // yyyy-MM-dd
  customer: { identification: string; branch_office?: number } | SiigoCustomerPayload;
  seller: number;
  items: SiigoInvoiceItem[];
  payments: SiigoInvoicePayment[];
  observations?: string;
  stamp?: boolean; // true = enviar a la DIAN automáticamente
  mail?: boolean; // true = enviar por correo al cliente
  cost_center?: number;
  currency?: { code: string; exchange_rate: number };
}

export interface SiigoInvoiceResponse {
  id: string;
  document?: { id: number };
  number?: number;
  name?: string;
  date?: string;
  customer?: unknown;
  cufe?: string;
  pdf?: { file_name: string };
  total?: number;
  [key: string]: unknown;
}

export interface SiigoApiError {
  Status: number;
  Errors: Array<{ Code: string; Message: string; Params?: string[]; Detail?: string }>;
}
