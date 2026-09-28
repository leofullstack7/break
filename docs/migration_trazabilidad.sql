-- Trazabilidad de equipo (TI / Administración), objetivos, tareas, zumbidos.
-- Idempotente.

-- 1) Roles nuevos. TI y Administración ven lo gerencial (get_mi_rol los mapea).
alter table public.usuarios drop constraint if exists usuarios_rol_check;
alter table public.usuarios
  add constraint usuarios_rol_check
  check (rol in ('gerente','ti','administracion','recepcion','aseo','marketing','huesped'));

create or replace function public.get_mi_rol()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select case
    when rol in ('ti', 'administracion') then 'gerente'
    else rol
  end
  from public.usuarios
  where id = auth.uid();
$$;

create or replace function public.get_mi_rol_real()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select rol from public.usuarios where id = auth.uid();
$$;

-- 2) Objetivos
create table if not exists public.objetivos (
  id              uuid primary key default gen_random_uuid(),
  titulo          text not null,
  descripcion     text,
  area            text not null default 'ti'
                    check (area in ('ti','administracion','gerencia')),
  estado          text not null default 'abierto'
                    check (estado in ('abierto','en_curso','cumplido','archivado')),
  owner_id        uuid not null references public.usuarios(id),
  fecha_objetivo  date,
  cumplido_at     timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index if not exists idx_objetivos_owner on public.objetivos (owner_id, estado);
create index if not exists idx_objetivos_area on public.objetivos (area, created_at desc);

-- 3) Tareas
create table if not exists public.tareas (
  id             uuid primary key default gen_random_uuid(),
  objetivo_id    uuid not null references public.objetivos(id) on delete cascade,
  titulo         text not null,
  descripcion    text,
  estado         text not null default 'pendiente'
                   check (estado in ('pendiente','en_curso','completa')),
  asignado_id    uuid references public.usuarios(id),
  created_by     uuid references public.usuarios(id),
  orden          int not null default 0,
  completada_at  timestamptz,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

create index if not exists idx_tareas_objetivo on public.tareas (objetivo_id, orden);

-- 4) Adjuntos (PDF, Word, JPG)
create table if not exists public.trazabilidad_adjuntos (
  id           uuid primary key default gen_random_uuid(),
  objetivo_id  uuid references public.objetivos(id) on delete cascade,
  tarea_id     uuid references public.tareas(id) on delete cascade,
  nombre       text not null,
  mime         text not null,
  path         text not null,
  bytes        int,
  subido_por   uuid references public.usuarios(id),
  created_at   timestamptz not null default now(),
  constraint adjunto_padre check (objetivo_id is not null or tarea_id is not null)
);

-- 5) Zumbidos gerencia → empleado
create table if not exists public.zumbidos (
  id          uuid primary key default gen_random_uuid(),
  de_id       uuid not null references public.usuarios(id),
  para_id     uuid not null references public.usuarios(id),
  mensaje     text,
  leido_at    timestamptz,
  created_at  timestamptz not null default now()
);

create index if not exists idx_zumbidos_para on public.zumbidos (para_id, created_at desc);

-- 6) Historial de asistentes (ramas separadas)
create table if not exists public.asistente_mensajes (
  id          uuid primary key default gen_random_uuid(),
  rama        text not null check (rama in ('gerente','ti')),
  user_id     uuid not null references public.usuarios(id),
  rol         text not null check (rol in ('user','assistant')),
  contenido   text not null,
  created_at  timestamptz not null default now()
);

create index if not exists idx_asistente_user on public.asistente_mensajes (rama, user_id, created_at);

drop trigger if exists trg_objetivos_updated_at on public.objetivos;
create trigger trg_objetivos_updated_at
  before update on public.objetivos
  for each row execute function public.set_updated_at();

drop trigger if exists trg_tareas_updated_at on public.tareas;
create trigger trg_tareas_updated_at
  before update on public.tareas
  for each row execute function public.set_updated_at();

alter table public.objetivos enable row level security;
alter table public.tareas enable row level security;
alter table public.trazabilidad_adjuntos enable row level security;
alter table public.zumbidos enable row level security;
alter table public.asistente_mensajes enable row level security;

drop policy if exists "staff gerencial ve objetivos" on public.objetivos;
create policy "staff gerencial ve objetivos"
  on public.objetivos for select to authenticated
  using (public.get_mi_rol() = 'gerente');

drop policy if exists "staff gerencial escribe objetivos" on public.objetivos;
create policy "staff gerencial escribe objetivos"
  on public.objetivos for all to authenticated
  using (public.get_mi_rol() = 'gerente')
  with check (public.get_mi_rol() = 'gerente');

drop policy if exists "staff gerencial ve tareas" on public.tareas;
create policy "staff gerencial ve tareas"
  on public.tareas for select to authenticated
  using (public.get_mi_rol() = 'gerente');

drop policy if exists "staff gerencial escribe tareas" on public.tareas;
create policy "staff gerencial escribe tareas"
  on public.tareas for all to authenticated
  using (public.get_mi_rol() = 'gerente')
  with check (public.get_mi_rol() = 'gerente');

drop policy if exists "staff gerencial ve adjuntos" on public.trazabilidad_adjuntos;
create policy "staff gerencial ve adjuntos"
  on public.trazabilidad_adjuntos for select to authenticated
  using (public.get_mi_rol() = 'gerente');

drop policy if exists "staff gerencial escribe adjuntos" on public.trazabilidad_adjuntos;
create policy "staff gerencial escribe adjuntos"
  on public.trazabilidad_adjuntos for all to authenticated
  using (public.get_mi_rol() = 'gerente')
  with check (public.get_mi_rol() = 'gerente');

drop policy if exists "staff gerencial ve zumbidos" on public.zumbidos;
create policy "staff gerencial ve zumbidos"
  on public.zumbidos for select to authenticated
  using (public.get_mi_rol() = 'gerente');

drop policy if exists "gerente envia zumbidos" on public.zumbidos;
create policy "gerente envia zumbidos"
  on public.zumbidos for insert to authenticated
  with check (
    public.get_mi_rol_real() = 'gerente'
    and de_id = auth.uid()
  );

drop policy if exists "destinatario marca zumbido" on public.zumbidos;
create policy "destinatario marca zumbido"
  on public.zumbidos for update to authenticated
  using (para_id = auth.uid());

drop policy if exists "dueno ve su asistente" on public.asistente_mensajes;
create policy "dueno ve su asistente"
  on public.asistente_mensajes for select to authenticated
  using (user_id = auth.uid());

drop policy if exists "dueno escribe su asistente" on public.asistente_mensajes;
create policy "dueno escribe su asistente"
  on public.asistente_mensajes for insert to authenticated
  with check (user_id = auth.uid());

-- Storage
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'trazabilidad',
  'trazabilidad',
  false,
  10485760,
  array[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'image/jpeg',
    'image/png',
    'image/webp'
  ]
)
on conflict (id) do nothing;

drop policy if exists "staff sube trazabilidad" on storage.objects;
create policy "staff sube trazabilidad"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'trazabilidad'
    and public.get_mi_rol() = 'gerente'
  );

drop policy if exists "staff lee trazabilidad" on storage.objects;
create policy "staff lee trazabilidad"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'trazabilidad'
    and public.get_mi_rol() = 'gerente'
  );

drop policy if exists "staff borra trazabilidad" on storage.objects;
create policy "staff borra trazabilidad"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'trazabilidad'
    and public.get_mi_rol() = 'gerente'
  );

do $$
begin
  begin
    alter publication supabase_realtime add table public.zumbidos;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table public.objetivos;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table public.tareas;
  exception when duplicate_object then null;
  end;
end $$;
