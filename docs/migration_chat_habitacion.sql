-- Chat por habitación (QR huésped ↔ recepción)
-- Idempotente. Ejecutar en SQL Editor de Supabase.

-- ── Tablas base (por si aún no corrió migration_chat_conocimiento) ──
create table if not exists public.chats (
  id              uuid primary key default gen_random_uuid(),
  habitacion_id   uuid references public.habitaciones(id),
  reserva_id      uuid references public.reservas(id),
  huesped_id      uuid references public.huespedes(id),
  titulo          text,
  estado          text not null default 'abierto'
                    check (estado in ('abierto','cerrado','bot_activo')),
  bot_activo      boolean not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create table if not exists public.chat_mensajes (
  id           uuid primary key default gen_random_uuid(),
  chat_id      uuid not null references public.chats(id) on delete cascade,
  rol          text not null check (rol in ('huesped','admin','bot','sistema')),
  autor_id     uuid,
  contenido    text not null default '',
  metadata     jsonb,
  created_at   timestamptz not null default now()
);

create index if not exists idx_chats_habitacion on public.chats (habitacion_id);
create index if not exists idx_chat_mensajes_chat on public.chat_mensajes (chat_id, created_at);

alter table public.habitaciones
  add column if not exists chat_token uuid;

update public.habitaciones
set chat_token = gen_random_uuid()
where chat_token is null;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'habitaciones_chat_token_key'
  ) then
    alter table public.habitaciones
      add constraint habitaciones_chat_token_key unique (chat_token);
  end if;
end $$;

alter table public.chats
  add column if not exists ultimo_mensaje_at timestamptz,
  add column if not exists ultimo_mensaje text,
  add column if not exists ultimo_rol text,
  add column if not exists no_leidos_admin integer not null default 0,
  add column if not exists no_leidos_huesped integer not null default 0;

alter table public.chat_mensajes
  add column if not exists tipo text,
  add column if not exists media_path text;

update public.chat_mensajes set tipo = 'texto' where tipo is null;

alter table public.chat_mensajes
  alter column tipo set default 'texto';

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'chat_mensajes_tipo_valido'
  ) then
    alter table public.chat_mensajes
      add constraint chat_mensajes_tipo_valido
      check (tipo in ('texto','imagen','audio'));
  end if;
end $$;

-- Un hilo por habitación
delete from public.chats a
using public.chats b
where a.habitacion_id is not null
  and a.habitacion_id = b.habitacion_id
  and a.created_at > b.created_at;

create unique index if not exists idx_chats_una_habitacion
  on public.chats (habitacion_id)
  where habitacion_id is not null;

insert into public.chats (habitacion_id, titulo, bot_activo, estado)
select h.id, 'Habitación ' || h.numero, false, 'abierto'
from public.habitaciones h
where not exists (
  select 1 from public.chats c where c.habitacion_id = h.id
);

alter table public.chats enable row level security;
alter table public.chat_mensajes enable row level security;

drop policy if exists "staff gestiona chats" on public.chats;
create policy "staff gestiona chats"
  on public.chats for all
  using (public.get_mi_rol() in ('gerente','recepcion','marketing'))
  with check (public.get_mi_rol() in ('gerente','recepcion','marketing'));

drop policy if exists "staff gestiona mensajes" on public.chat_mensajes;
create policy "staff gestiona mensajes"
  on public.chat_mensajes for all
  using (public.get_mi_rol() in ('gerente','recepcion','marketing'))
  with check (public.get_mi_rol() in ('gerente','recepcion','marketing'));

-- ── Trigger de último mensaje / no leídos ──
create or replace function public.trg_chat_mensaje_despues()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.chats set
    updated_at = now(),
    ultimo_mensaje_at = new.created_at,
    ultimo_mensaje = case
      when new.tipo = 'imagen' then 'Foto'
      when new.tipo = 'audio' then 'Audio'
      else left(coalesce(new.contenido, ''), 140)
    end,
    ultimo_rol = new.rol,
    no_leidos_admin = case
      when new.rol = 'huesped' then no_leidos_admin + 1
      else no_leidos_admin
    end,
    no_leidos_huesped = case
      when new.rol in ('admin', 'bot') then no_leidos_huesped + 1
      else no_leidos_huesped
    end
  where id = new.chat_id;
  return new;
end;
$$;

drop trigger if exists trg_chat_mensaje_despues on public.chat_mensajes;
create trigger trg_chat_mensaje_despues
  after insert on public.chat_mensajes
  for each row execute function public.trg_chat_mensaje_despues();

-- ── RPC: abrir chat con token del QR ──
create or replace function public.chat_habitacion_por_token(p_token uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_hab public.habitaciones%rowtype;
  v_chat public.chats%rowtype;
  v_mapa public.v_mapa_habitaciones%rowtype;
  v_msgs jsonb;
begin
  if p_token is null then
    raise exception 'TOKEN_INVALIDO';
  end if;

  select * into v_hab
  from public.habitaciones
  where chat_token = p_token;

  if not found then
    raise exception 'TOKEN_INVALIDO';
  end if;

  insert into public.chats (habitacion_id, titulo, bot_activo, estado)
  select v_hab.id, 'Habitación ' || v_hab.numero, false, 'abierto'
  where not exists (
    select 1 from public.chats c where c.habitacion_id = v_hab.id
  );

  select * into v_chat
  from public.chats
  where habitacion_id = v_hab.id
  limit 1;

  select * into v_mapa
  from public.v_mapa_habitaciones
  where habitacion_id = v_hab.id;

  if v_mapa.reserva_id is not null then
    update public.chats
    set reserva_id = v_mapa.reserva_id,
        huesped_id = v_mapa.huesped_id,
        updated_at = now()
    where id = v_chat.id;
    v_chat.reserva_id := v_mapa.reserva_id;
    v_chat.huesped_id := v_mapa.huesped_id;
  end if;

  select coalesce(jsonb_agg(row_to_json(m) order by m.created_at), '[]'::jsonb)
  into v_msgs
  from public.chat_mensajes m
  where m.chat_id = v_chat.id;

  return jsonb_build_object(
    'habitacion_id', v_hab.id,
    'numero', v_hab.numero,
    'piso', v_hab.piso,
    'chat_id', v_chat.id,
    'huesped_id', v_mapa.huesped_id,
    'huesped_nombre', v_mapa.huesped_nombre,
    'estado_hospedaje', v_mapa.estado_hospedaje,
    'mensajes', v_msgs
  );
end;
$$;

-- ── RPC: huésped envía mensaje ──
create or replace function public.chat_enviar_huesped(
  p_token uuid,
  p_tipo text,
  p_contenido text,
  p_media_path text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_hab_id uuid;
  v_chat_id uuid;
  v_msg public.chat_mensajes%rowtype;
  v_tipo text;
begin
  v_tipo := coalesce(nullif(p_tipo, ''), 'texto');
  if v_tipo not in ('texto','imagen','audio') then
    raise exception 'TIPO_INVALIDO';
  end if;

  select h.id, c.id
  into v_hab_id, v_chat_id
  from public.habitaciones h
  join public.chats c on c.habitacion_id = h.id
  where h.chat_token = p_token;

  if v_chat_id is null then
    perform public.chat_habitacion_por_token(p_token);
    select h.id, c.id
    into v_hab_id, v_chat_id
    from public.habitaciones h
    join public.chats c on c.habitacion_id = h.id
    where h.chat_token = p_token;
  end if;

  if v_chat_id is null then
    raise exception 'TOKEN_INVALIDO';
  end if;

  if v_tipo = 'texto' and coalesce(trim(p_contenido), '') = '' then
    raise exception 'MENSAJE_VACIO';
  end if;

  insert into public.chat_mensajes (chat_id, rol, tipo, contenido, media_path)
  values (
    v_chat_id,
    'huesped',
    v_tipo,
    coalesce(p_contenido, ''),
    p_media_path
  )
  returning * into v_msg;

  return row_to_json(v_msg)::jsonb;
end;
$$;

create or replace function public.chat_marcar_leido_huesped(p_token uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.chats c
  set no_leidos_huesped = 0, updated_at = now()
  from public.habitaciones h
  where h.chat_token = p_token
    and c.habitacion_id = h.id;
end;
$$;

create or replace function public.chat_marcar_leido_admin(p_chat_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if public.get_mi_rol() not in ('gerente','recepcion','marketing') then
    raise exception 'SIN_PERMISO';
  end if;

  update public.chats
  set no_leidos_admin = 0, updated_at = now()
  where id = p_chat_id;
end;
$$;

revoke all on function public.chat_habitacion_por_token(uuid) from public;
revoke all on function public.chat_enviar_huesped(uuid, text, text, text) from public;
revoke all on function public.chat_marcar_leido_huesped(uuid) from public;
revoke all on function public.chat_marcar_leido_admin(uuid) from public;

grant execute on function public.chat_habitacion_por_token(uuid) to anon, authenticated;
grant execute on function public.chat_enviar_huesped(uuid, text, text, text) to anon, authenticated;
grant execute on function public.chat_marcar_leido_huesped(uuid) to anon, authenticated;
grant execute on function public.chat_marcar_leido_admin(uuid) to authenticated;

-- ── Storage ──
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'chat-adjuntos',
  'chat-adjuntos',
  true,
  15728640,
  array[
    'image/jpeg','image/png','image/webp','image/gif',
    'audio/webm','audio/mp4','audio/mpeg','audio/ogg','audio/wav','audio/aac','audio/x-m4a'
  ]
)
on conflict (id) do update
set public = excluded.public,
    file_size_limit = excluded.file_size_limit,
    allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "staff sube chat adjuntos" on storage.objects;
create policy "staff sube chat adjuntos"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'chat-adjuntos'
    and public.get_mi_rol() in ('gerente','recepcion','marketing')
  );

drop policy if exists "staff lee chat adjuntos" on storage.objects;
create policy "staff lee chat adjuntos"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'chat-adjuntos'
    and public.get_mi_rol() in ('gerente','recepcion','marketing','aseo')
  );

-- ── Realtime ──
do $$
begin
  begin
    alter publication supabase_realtime add table public.chats;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table public.chat_mensajes;
  exception when duplicate_object then null;
  end;
end $$;

comment on column public.habitaciones.chat_token is 'Token del QR de la habitación. Quien lo tenga entra al chat con recepción.';
