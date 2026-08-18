-- ============================================================
-- Break Hotel — Migración: tabla email_logs
-- Ejecutar en: Supabase Dashboard → SQL Editor → New query
-- ============================================================

-- Tabla para registrar cada email enviado por la Edge Function send-email
create table if not exists public.email_logs (
  id            uuid primary key default uuid_generate_v4(),
  tipo          text not null,               -- confirmacion_reserva, pre_checkin, post_estadia
  destinatario  text not null,               -- email del huésped
  asunto        text not null,               -- subject del email
  resend_id     text,                        -- ID devuelto por Resend API
  estado        text not null default 'enviado'
                  check (estado in ('enviado', 'fallido')),
  error         text,                        -- mensaje de error si falló
  metadata      jsonb,                       -- datos de la reserva usados para renderizar
  created_at    timestamptz not null default now()
);

-- Índices para consultas frecuentes
create index if not exists idx_email_logs_tipo on public.email_logs(tipo);
create index if not exists idx_email_logs_destinatario on public.email_logs(destinatario);
create index if not exists idx_email_logs_created_at on public.email_logs(created_at desc);

-- RLS: solo service_role (Edge Functions) puede insertar; gerente puede leer
alter table public.email_logs enable row level security;

create policy "gerente lee email_logs"
  on public.email_logs for select
  using (public.get_mi_rol() = 'gerente');

comment on table public.email_logs is 'Log de emails transaccionales enviados por Resend. Insertado por la Edge Function send-email.';
