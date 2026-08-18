-- ============================================================
-- Quitar columnas de Octorate (ya no se usan)
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- ============================================================

drop index if exists public.idx_reservas_octorate_id;

alter table public.reservas
  drop column if exists octorate_id,
  drop column if exists octorate_raw,
  drop column if exists octorate_sync_at;

alter table public.habitaciones
  drop column if exists octorate_product_id;

delete from public.integraciones_config
where clave like 'octorate%';
