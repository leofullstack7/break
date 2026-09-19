-- ============================================================================
-- Migración: sync de contactos/huéspedes desde PxSol
-- Repo: break-digital  ·  Ejecutar en el SQL Editor de Supabase.
--
-- PxSol no expone un CRM de contactos dedicado en la API pública.
-- El sync deriva huéspedes desde vouchers (pax_id) y bookings (guest_details).
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Huéspedes: columnas de integración PxSol
-- ----------------------------------------------------------------------------
alter table public.huespedes
  add column if not exists pxsol_pax_id  text unique,
  add column if not exists pxsol_raw     jsonb,
  add column if not exists pxsol_sync_at timestamptz;

comment on column public.huespedes.pxsol_pax_id is
  'pax_id de PxSol (atributo del voucher / persona). Llave primaria de sync CRM.';
comment on column public.huespedes.pxsol_raw is
  'Último payload de contacto derivado de PxSol (voucher attrs o guest_details), sin transformar.';
comment on column public.huespedes.pxsol_sync_at is
  'Última vez que se sincronizó este huésped desde PxSol.';

create index if not exists idx_huespedes_pxsol_pax_id
  on public.huespedes (pxsol_pax_id)
  where pxsol_pax_id is not null;

create index if not exists idx_huespedes_correo
  on public.huespedes (correo)
  where correo is not null;

-- Cursor de sync (integraciones_config):
--   clave = 'pxsol_contactos_sync_cursor'
--   valor = { "updated_at_start_date": "YYYY-MM-DD HH:mm:ss", "last_run_at": "..." }
