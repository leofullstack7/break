-- ============================================================================
-- Migración: puente PXSOL ↔ SIIGO
-- Repo: break-digital  ·  Ejecutar en el SQL Editor de Supabase (igual que las
-- demás migraciones del proyecto: no hay supabase/migrations versionadas).
--
-- Sigue el patrón de integraciones: columnas *_id / *_raw / *_sync_at
-- sobre tablas existentes + tablas de log/config nuevas.
-- NO se ejecuta automáticamente: revisar y correr manualmente cuando el
-- equipo (Zaven) apruebe pasar a la siguiente fase.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Reservas: columnas de integración PxSol
-- ----------------------------------------------------------------------------
alter table public.reservas
  add column if not exists pxsol_booking_id text unique,
  add column if not exists pxsol_raw        jsonb,
  add column if not exists pxsol_sync_at    timestamptz;

comment on column public.reservas.pxsol_booking_id is 'booking_id de PxSol (GET /v2/ota/hotels/:hotel_id/bookings/:booking_id). Fuente de verdad de reservas.';
comment on column public.reservas.pxsol_raw is 'Payload crudo de la reserva devuelto por PxSol, sin transformar.';
comment on column public.reservas.pxsol_sync_at is 'Última vez que se sincronizó esta reserva desde PxSol.';

create index if not exists idx_reservas_pxsol_booking_id on public.reservas (pxsol_booking_id);

-- ----------------------------------------------------------------------------
-- 2. Huéspedes: cachear el tercero de Siigo para no recrearlo en cada factura
-- ----------------------------------------------------------------------------
alter table public.huespedes
  add column if not exists siigo_tercero_id text,
  add column if not exists siigo_sync_at    timestamptz;

comment on column public.huespedes.siigo_tercero_id is 'identification del tercero ya creado/verificado en Siigo (POST o GET /v1/customers).';

-- ----------------------------------------------------------------------------
-- 3. pxsol_vouchers: unidad de sincronización hacia Siigo (1 voucher = 1
--    factura o 1 nota crédito). Ver ADR sección 3-4: PxSol puede emitir
--    varios vouchers por una misma reserva (pagos parciales), por eso NO se
--    cuelga directamente de "reservas" con columnas siigo_* sino en su
--    propia tabla.
-- ----------------------------------------------------------------------------
create table if not exists public.pxsol_vouchers (
  id                        bigint primary key,             -- id del voucher en PxSol
  booking_id                text,                            -- cruza con reservas.pxsol_booking_id
  reserva_id                uuid references public.reservas(id),    -- resuelto en pxsol-sync, puede quedar null si no hay match
  folio_id                  bigint,
  folio_name                text,
  voucher_type              text,                            -- ej. "Factura B" (confirmar nomenclatura CO)
  group_type                text,                            -- debe ser 'Venta' para facturar
  status                    text,                            -- debe ser 'Finished' para facturar
  payment_type              text,
  payment_status            text,
  currency                  text,
  sub_total                 numeric(14,2),
  iva                       numeric(14,2),
  other_taxes               numeric(14,2),
  total                     numeric(14,2),
  fecha_voucher             date,
  fecha_vencimiento         date,
  huesped_nombre            text,
  huesped_tipo_doc          text,
  huesped_num_doc           text,
  huesped_email             text,
  huesped_tipo_persona      text,
  has_credit_note           boolean default false,
  credit_note               boolean default false,
  credit_note_voucher_id    bigint,
  pxsol_pdf_url             text,
  voucher_raw               jsonb,                           -- payload crudo completo de voucher/info
  pxsol_sync_at             timestamptz default now(),

  -- estado de la sincronización hacia Siigo
  siigo_estado              text default 'pendiente' check (siigo_estado in ('pendiente','facturado','nota_credito','error','omitido')),
  siigo_factura_id          text,
  siigo_numero              text,
  siigo_cufe                text,
  siigo_pdf_url             text,
  siigo_error               text,
  siigo_intentos            int default 0,
  siigo_sync_at             timestamptz,

  created_at                timestamptz default now()
);

create index if not exists idx_pxsol_vouchers_booking_id on public.pxsol_vouchers (booking_id);
create index if not exists idx_pxsol_vouchers_siigo_estado on public.pxsol_vouchers (siigo_estado) where siigo_estado in ('pendiente','error');
create index if not exists idx_pxsol_vouchers_reserva_id on public.pxsol_vouchers (reserva_id);

comment on table public.pxsol_vouchers is 'Vouchers (facturas/recibos) leídos desde PxSol. Cada fila con group_type=Venta y status=Finished dispara la creación de una factura en Siigo. 1 voucher de PxSol = 1 documento en Siigo.';

-- ----------------------------------------------------------------------------
-- 4. siigo_catalogo_map: mapeos configurables PxSol → Siigo (ver
--    02-mapeo-campos-pxsol-siigo.md sección 5). Evita hardcodear IDs de
--    Siigo Nube (productos, formas de pago, impuestos, ciudades) en el
--    código, ya que son específicos de la cuenta de Break Hotel y pueden
--    cambiar si se reconfigura Siigo Nube.
-- ----------------------------------------------------------------------------
create table if not exists public.siigo_catalogo_map (
  id            bigint generated always as identity primary key,
  tipo          text not null check (tipo in ('producto','forma_pago','impuesto','documento_identidad','ciudad')),
  clave_pxsol   text not null,      -- ej. product_id de PxSol, o payment_type, o % de IVA
  valor_siigo   text not null,      -- ej. code de producto, id de forma de pago/impuesto, o "CO|11|11001"
  descripcion   text,
  activo        boolean default true,
  created_at    timestamptz default now(),
  unique (tipo, clave_pxsol)
);

comment on table public.siigo_catalogo_map is 'Tabla de mapeo editable PxSol -> Siigo (productos, formas de pago, impuestos, tipos de documento, ciudades). Se puebla manualmente/por script una vez, antes de activar siigo-sync-factura en producción.';

-- ----------------------------------------------------------------------------
-- 5. sync_logs: log genérico reutilizable (mismo espíritu que email_logs)
--    para ambas integraciones nuevas.
-- ----------------------------------------------------------------------------
create table if not exists public.sync_logs (
  id            bigint generated always as identity primary key,
  integracion   text not null check (integracion in ('pxsol','siigo')),
  evento        text not null,           -- ej. 'voucher_list_pull', 'invoice_create', 'customer_create'
  referencia_id text,                    -- id de voucher, reserva, factura, etc.
  estado        text not null check (estado in ('ok','error')),
  detalle       jsonb,                   -- payload/response/error crudo
  created_at    timestamptz default now()
);

create index if not exists idx_sync_logs_integracion_evento on public.sync_logs (integracion, evento, created_at desc);
create index if not exists idx_sync_logs_referencia on public.sync_logs (referencia_id);

comment on table public.sync_logs is 'Log de eventos de las integraciones PxSol y Siigo, para depuración y fallback manual en recepción.';

-- ----------------------------------------------------------------------------
-- 6. integraciones_config: se reutiliza la tabla existente (columnas reales:
--    clave text PK, valor text, expira_en timestamptz, actualizado_en).
--    Las Edge Functions serializan JSON en `valor`. Claves usadas:
--
--    clave = 'pxsol_api_key_status'  -> { "last_checked_at": ..., "alive": true }
--    clave = 'pxsol_sync_cursor'     -> { "updated_at_start_date": "..." }
--    clave = 'siigo_token'           -> { "access_token": "...", "expires_at": "..." }
--
-- No requiere DDL adicional.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- 7. RLS: estas tablas solo las toca service_role (Edge Functions), igual
--    que integraciones_config. Sin políticas para anon/authenticated.
-- ----------------------------------------------------------------------------
alter table public.pxsol_vouchers enable row level security;
alter table public.siigo_catalogo_map enable row level security;
alter table public.sync_logs enable row level security;
-- Sin "create policy" para anon/authenticated: por defecto RLS bloquea todo
-- salvo service_role (que la ignora). Si el equipo quiere exponer lectura a
-- 'gerente' desde /admin/finanzas más adelante, agregar política explícita
-- de SELECT ahí, no aquí.
