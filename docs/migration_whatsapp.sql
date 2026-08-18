-- ============================================================
-- MIGRACIÓN: Webhook WhatsApp Business (Meta Cloud API) — Break Hotel
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- Fecha: 2026-06-10
-- ============================================================

-- 1. Tabla: whatsapp_messages
-- Registra cada mensaje entrante recibido por la Edge Function whatsapp-webhook
create table if not exists public.whatsapp_messages (
  id              uuid primary key default uuid_generate_v4(),
  wa_message_id   text unique,            -- ID del mensaje en WhatsApp (evita duplicados)
  from_numero     text not null,          -- número del remitente (formato wa_id)
  to_numero       text,                   -- número del hotel que recibió el mensaje
  nombre_contacto text,                   -- nombre de perfil de WhatsApp del contacto
  tipo            text not null default 'text', -- text, image, audio, document, button, interactive, etc.
  contenido       text,                   -- texto legible del mensaje (si aplica)
  payload         jsonb not null,         -- JSON completo del mensaje recibido
  procesado       boolean not null default false,
  created_at      timestamptz not null default now()
);

comment on table public.whatsapp_messages is 'Mensajes entrantes de WhatsApp Business API (Meta Cloud API), recibidos por whatsapp-webhook.';
comment on column public.whatsapp_messages.wa_message_id is 'ID único del mensaje asignado por WhatsApp.';
comment on column public.whatsapp_messages.payload is 'JSON completo del mensaje, para auditoría y campos no mapeados.';
comment on column public.whatsapp_messages.procesado is 'Marca si el mensaje ya fue atendido/respondido.';

create index if not exists idx_whatsapp_messages_from_numero
  on public.whatsapp_messages(from_numero);

create index if not exists idx_whatsapp_messages_created_at
  on public.whatsapp_messages(created_at);


-- 2. Row Level Security
alter table public.whatsapp_messages enable row level security;

-- Recepción, marketing y gerente pueden ver los mensajes entrantes
create policy "staff puede ver mensajes whatsapp"
  on public.whatsapp_messages for select
  using (public.get_mi_rol() in ('gerente','recepcion','marketing'));

-- Solo gerente y marketing pueden marcar mensajes como procesados
create policy "gerente y marketing gestionan mensajes whatsapp"
  on public.whatsapp_messages for update
  using (public.get_mi_rol() in ('gerente','marketing'));

-- Sin policy de insert para usuarios: solo service_role (Edge Function) inserta


-- ============================================================
-- VERIFICACIÓN: correr esto para confirmar que todo quedó bien
-- ============================================================
select table_name from information_schema.tables
where table_name = 'whatsapp_messages';

select column_name, data_type
from information_schema.columns
where table_name = 'whatsapp_messages'
order by ordinal_position;
