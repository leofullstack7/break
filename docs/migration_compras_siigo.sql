-- ============================================================================
-- Migración: bandeja de facturas de COMPRA → Siigo
-- Repo: break-digital  ·  Ejecutar en el SQL Editor de Supabase.
--
-- Flujo:
--   1) Correo inbound (Resend webhook, asunto ~ "facturación") o upload manual
--   2) ZIP/XML se guarda en storage `facturas-compra`
--   3) Fila en `compras_inbox` (pendiente → revisado → enviado_siigo | error)
--   4) Edge `siigo-sync-compra` parsea XML DIAN y hace POST /v1/purchases
--
-- Nota: Siigo API NO acepta ZIP directo; solo JSON en /v1/purchases.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Tabla bandeja
-- ----------------------------------------------------------------------------
create table if not exists public.compras_inbox (
  id                uuid primary key default gen_random_uuid(),
  origen            text not null default 'manual'
                      check (origen in ('email', 'manual')),
  estado            text not null default 'pendiente'
                      check (estado in (
                        'pendiente',      -- llegó (email o upload), aún no revisado
                        'listo',          -- XML parseado OK, listo para enviar a Siigo
                        'enviado_siigo',  -- creado en Siigo
                        'error',          -- falló parseo o sync
                        'descartado'      -- staff lo ignoró
                      )),
  -- Metadatos del correo (si origen = email)
  email_id          text,                 -- Resend receiving email_id
  email_from        text,
  email_subject     text,
  email_recibido_at timestamptz,
  -- Archivo
  archivo_nombre    text,
  archivo_path      text,                 -- path en storage facturas-compra
  archivo_mime      text,
  archivo_bytes     integer,
  -- Datos parseados del XML DIAN (nullable hasta parsear)
  cufe              text,
  prefijo           text,
  numero_factura    text,
  fecha_factura     date,
  proveedor_nit     text,
  proveedor_nombre  text,
  receptor_nit      text,
  moneda            text default 'COP',
  subtotal          numeric(14,2),
  iva               numeric(14,2),
  total             numeric(14,2),
  lineas            jsonb,                -- [{descripcion, cantidad, precio, total, impuestos[]}]
  xml_raw_path      text,                 -- path del XML extraído (opcional)
  parse_error       text,
  -- Siigo
  siigo_compra_id   text,
  siigo_compra_name text,
  siigo_sync_at     timestamptz,
  siigo_error       text,
  -- Auditoría
  creado_por        uuid references public.usuarios(id),
  revisado_por      uuid references public.usuarios(id),
  revisado_at       timestamptz,
  notas             text,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

comment on table public.compras_inbox is
  'Bandeja de facturas de compra (ZIP/XML DIAN) pendientes de registrar en Siigo.';

create unique index if not exists idx_compras_inbox_cufe
  on public.compras_inbox (cufe)
  where cufe is not null;

create unique index if not exists idx_compras_inbox_email_id
  on public.compras_inbox (email_id)
  where email_id is not null;

create index if not exists idx_compras_inbox_estado
  on public.compras_inbox (estado, created_at desc);

create index if not exists idx_compras_inbox_proveedor
  on public.compras_inbox (proveedor_nit)
  where proveedor_nit is not null;

-- updated_at
create or replace function public.trg_compras_inbox_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists compras_inbox_updated_at on public.compras_inbox;
create trigger compras_inbox_updated_at
  before update on public.compras_inbox
  for each row execute function public.trg_compras_inbox_updated_at();

-- ----------------------------------------------------------------------------
-- 2. RLS — solo gerente (y recepción lectura)
-- ----------------------------------------------------------------------------
alter table public.compras_inbox enable row level security;

drop policy if exists "gerente gestiona compras_inbox" on public.compras_inbox;
create policy "gerente gestiona compras_inbox"
  on public.compras_inbox for all
  using (public.get_mi_rol() = 'gerente')
  with check (public.get_mi_rol() = 'gerente');

drop policy if exists "recepcion lee compras_inbox" on public.compras_inbox;
create policy "recepcion lee compras_inbox"
  on public.compras_inbox for select
  using (public.get_mi_rol() in ('gerente', 'recepcion'));

-- ----------------------------------------------------------------------------
-- 3. Storage bucket privado para ZIP/XML
-- ----------------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'facturas-compra',
  'facturas-compra',
  false,
  5242880, -- 5 MB (Siigo UI permite 3 MB; dejamos margen)
  array[
    'application/zip',
    'application/x-zip-compressed',
    'application/xml',
    'text/xml',
    'application/pdf'
  ]
)
on conflict (id) do update set
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- Staff puede leer; escritura solo vía service_role (edge functions)
drop policy if exists "staff lee facturas-compra" on storage.objects;
create policy "staff lee facturas-compra"
  on storage.objects for select
  using (
    bucket_id = 'facturas-compra'
    and public.get_mi_rol() in ('gerente', 'recepcion')
  );

-- ----------------------------------------------------------------------------
-- Secrets / config esperados (Edge Functions):
--   RESEND_API_KEY
--   RESEND_WEBHOOK_SECRET          (svix / Resend signing secret)
--   COMPRAS_EMAIL_ASUNTO_FILTRO    (default: facturacion)
--   SIIGO_PURCHASE_DOCUMENT_TYPE_ID
--   SIIGO_PURCHASE_PAYMENT_ID
--   SIIGO_PURCHASE_DEFAULT_PRODUCT_CODE
--   BREAK_NIT                      (opcional: validar receptor del XML)
-- ============================================================================
