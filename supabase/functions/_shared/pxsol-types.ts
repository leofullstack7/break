// supabase/functions/_shared/pxsol-types.ts
//
// Tipos mínimos para lo que consumimos de la API pública de PxSol (v2).
// Basado en los ejemplos de https://developers.pxsol.com/ (sección
// "Vouchers" y "Booking"). Los ejemplos públicos muestran datos de una
// operación argentina (campos tipo AFIP como `cae`); en Colombia hay que
// confirmar cómo se ven realmente estos valores antes de asumir el mapeo al
// 100%. Los campos marcados "confirmar" son los más sospechosos de variar.

export interface PxSolVoucherAttributes {
  partial_payment: number | null;
  origin: string | null;
  created_at: string;
  deleted_at: string | null;
  folio_name: string | null;
  payment_name: string | null;
  credit_note: number; // 0 | 1
  debit_note: number; // 0 | 1
  has_credit_note: number; // 0 | 1
  pax_id: number;
  folio_id: number;
  company_id: number;
  description: string | null;
  voucher_type: string; // ej. "Factura B" — confirmar nomenclatura CO
  currency: string; // esperado "COP" en operación colombiana
  exchange: number | null;
  imputation_date: string | null;
  fiscal_date: string | null;
  date: string;
  due_date: string | null;
  dispatch: string | null;
  payment_type: string; // ej. "[Tarjeta_de_Credito]" — confirmar formato exacto
  status: string; // debe ser "Finished" para facturar
  payment_status: string;
  group_type: string; // debe ser "Venta" para facturar
  subsidiary_id: number | null;
  other_taxes: string | null;
  iva: string;
  total: string;
  sub_total: string;
  name: string | null;
  last_name: string | null;
  social_reason: string | null;
  document_type: string | null; // confirmar valores CO: CC, NIT, CE, Pasaporte...
  email: string | null;
  person_type: "Person" | "Company";
  pdf: string | null;
  cae: string | null; // campo argentino (AFIP) — probablemente vacío/irrelevante en CO, confirmar
  book_type: string | null;
  account_type: string | null;
  receiver_id_number: string | null;
  receiver_social_reason: string | null;
  receiver_address: string | null;
  credit_note_voucher_id: number;
  hotel_id: number;
  booking_id: number;
  address: string | null;
  city: string | null;
  country: string | null;
  zip_code: string | null;
  tax_status: string | null;
  document_number: string | null;
  [key: string]: unknown; // el resto se guarda tal cual en voucher_raw
}

export interface PxSolVoucher {
  type: "voucher";
  id: number;
  attributes: PxSolVoucherAttributes;
}

export interface PxSolVoucherListResponse {
  data: PxSolVoucher[];
  status: string;
  message: string;
  meta: {
    total_on_page: number;
    total: number;
    per_page: number;
    current_page: number;
    last_page: number;
  };
}

export interface PxSolVoucherItem {
  id: number;
  voucher_id: number;
  date: string;
  price: string; // valor sin impuesto (aprox. sub_total del ítem)
  type: string; // ej. "Payment"
  code: string; // código interno PxSol, no confundir con code de Siigo
  description: string;
  units: number;
  discount: string;
  sub_total: string;
  tax_id: number | null;
  taxes: string; // porcentaje, ej. "19.00"
  iva: string; // valor de IVA calculado
  total: string;
  room_id: number | null;
  product_id: number | null; // llave más confiable para el mapeo de productos
  [key: string]: unknown;
}

export interface PxSolVoucherInfoResponse {
  data: {
    id: number;
    type: "voucher";
    attributes: PxSolVoucherAttributes & {
      voucher_items: PxSolVoucherItem[];
    };
  };
}

export interface PxSolBookingCustomer {
  first_name: string;
  last_name: string;
  email: string | null;
  phone: string | null;
  address: string | null;
  city: string | null;
  zip_code: string | null;
  country: string | null;
}

export interface PxSolBooking {
  booking_id: number;
  hotel_id: number;
  status: string;
  checkin: string;
  checkout: string;
  reservation_date: string;
  customer: PxSolBookingCustomer;
  rooms: number;
  adults: number;
  children: number;
  currency: string;
  total: number;
  subtotal: number;
  taxes: number;
  [key: string]: unknown;
}
