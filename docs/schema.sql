-- ============================================================
-- Break Hotel — Schema completo de Supabase
-- Ejecutar completo en: Supabase Dashboard → SQL Editor → New query
-- ============================================================


-- 0. EXTENSIONES
create extension if not exists "uuid-ossp";


-- 1. OPERADORES
create table public.operadores (
  id                   uuid primary key default uuid_generate_v4(),
  nombre               text not null,
  porcentaje_comision  numeric(5,2) not null default 0,
  activo               boolean not null default true,
  created_at           timestamptz not null default now()
);

insert into public.operadores (nombre, porcentaje_comision) values
  ('Airbnb',    15.00),
  ('Booking',   15.00),
  ('Terceros',  10.00),
  ('Alexander',  0.00);


-- 2. HABITACIONES
create table public.habitaciones (
  id          uuid primary key default uuid_generate_v4(),
  numero      integer unique not null,
  piso        integer not null check (piso between 1 and 4),
  tipo        text not null default 'apartaestudio',
  capacidad   integer not null default 2,
  estado      text not null default 'disponible'
                check (estado in ('disponible','ocupada','aseo','mantenimiento')),
  precio_base numeric(12,2) not null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

insert into public.habitaciones (numero, piso, precio_base) values
  (105, 1, 120000), (106, 1, 120000), (107, 1, 120000),
  (201, 2, 130000), (202, 2, 130000), (203, 2, 130000),
  (204, 2, 130000), (205, 2, 130000), (206, 2, 130000), (207, 2, 130000),
  (301, 3, 140000), (302, 3, 140000), (303, 3, 140000),
  (304, 3, 140000), (305, 3, 140000), (306, 3, 140000), (307, 3, 140000),
  (401, 4, 150000), (402, 4, 150000), (403, 4, 150000),
  (404, 4, 150000), (405, 4, 150000), (406, 4, 150000), (407, 4, 150000);


-- 3. HUÉSPEDES
create table public.huespedes (
  id              uuid primary key default uuid_generate_v4(),
  nombre          text not null,
  cedula          text unique not null,
  celular         text,
  correo          text,
  nacionalidad    text not null default 'colombiana',
  notas           text,
  fecha_registro  date not null default current_date,
  deleted_at      timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);


-- 4. RESERVAS
create table public.reservas (
  id              uuid primary key default uuid_generate_v4(),
  habitacion_id   uuid not null references public.habitaciones(id),
  huesped_id      uuid not null references public.huespedes(id),
  acompanante     text,
  fecha_entrada   date not null,
  fecha_salida    date not null,
  noches          integer generated always as (fecha_salida - fecha_entrada) stored,
  pago_total      numeric(12,2) not null,
  comision        numeric(12,2),
  operador_id     uuid references public.operadores(id),
  metodo_pago     text,
  incluye_aseo    boolean not null default false,
  incluye_break   boolean not null default false,
  estado          text not null default 'confirmada'
                    check (estado in ('pendiente','confirmada','activa','completada','cancelada')),
  observaciones   text,
  deleted_at      timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  constraint fechas_validas check (fecha_salida > fecha_entrada)
);


-- 5. ASEOS
create table public.aseos (
  id            uuid primary key default uuid_generate_v4(),
  habitacion_id uuid not null references public.habitaciones(id),
  reserva_id    uuid references public.reservas(id),
  fecha         date not null default current_date,
  estado        text not null default 'pendiente'
                  check (estado in ('pendiente','en_proceso','completado')),
  tipo_aseo     text not null default 'salida'
                  check (tipo_aseo in ('salida','mantenimiento','diario')),
  responsable   text,
  observaciones text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);


-- 6. LAVANDERIA
create table public.lavanderia (
  id             uuid primary key default uuid_generate_v4(),
  fecha          date not null default current_date,
  habitacion_id  uuid references public.habitaciones(id),
  tipo_prenda    text not null,
  cantidad       integer not null check (cantidad > 0),
  tiempo_minutos integer,
  estado         text not null default 'en_proceso'
                   check (estado in ('en_proceso','listo','entregado')),
  responsable    text,
  created_at     timestamptz not null default now()
);


-- 7. FINANZAS
create table public.finanzas (
  id          uuid primary key default uuid_generate_v4(),
  reserva_id  uuid references public.reservas(id),
  concepto    text not null,
  monto       numeric(12,2) not null,
  tipo        text not null check (tipo in ('ingreso','egreso','comision')),
  fecha       date not null default current_date,
  created_at  timestamptz not null default now()
);


-- 8. USUARIOS (vinculada a auth.users)
create table public.usuarios (
  id          uuid primary key references auth.users(id) on delete cascade,
  nombre      text not null,
  rol         text not null default 'recepcion'
                check (rol in ('gerente','recepcion','aseo','marketing','huesped')),
  email       text not null,
  activo      boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);


-- 9. TRIGGER: updated_at automático
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger trg_habitaciones_updated_at
  before update on public.habitaciones
  for each row execute function public.set_updated_at();

create trigger trg_huespedes_updated_at
  before update on public.huespedes
  for each row execute function public.set_updated_at();

create trigger trg_reservas_updated_at
  before update on public.reservas
  for each row execute function public.set_updated_at();

create trigger trg_aseos_updated_at
  before update on public.aseos
  for each row execute function public.set_updated_at();

create trigger trg_usuarios_updated_at
  before update on public.usuarios
  for each row execute function public.set_updated_at();


-- 10. TRIGGER: calcular comisión automáticamente
create or replace function public.calcular_comision()
returns trigger language plpgsql as $$
declare
  v_porcentaje numeric;
begin
  if new.operador_id is not null and new.pago_total is not null then
    select porcentaje_comision into v_porcentaje
    from public.operadores where id = new.operador_id;
    new.comision := round((new.pago_total * v_porcentaje / 100)::numeric, 0);
  end if;
  return new;
end;
$$;

create trigger trg_calcular_comision
  before insert or update of pago_total, operador_id on public.reservas
  for each row execute function public.calcular_comision();


-- 11. TRIGGER: sincronizar estado de habitación con reserva
create or replace function public.sync_estado_habitacion()
returns trigger language plpgsql as $$
begin
  if new.estado = 'activa' then
    update public.habitaciones set estado = 'ocupada'
    where id = new.habitacion_id;
  end if;

  if new.estado in ('completada','cancelada')
     and (old.estado is null or old.estado not in ('completada','cancelada')) then
    update public.habitaciones set estado = 'disponible'
    where id = new.habitacion_id;

    if new.estado = 'completada' then
      insert into public.aseos (habitacion_id, reserva_id, tipo_aseo, estado)
      values (new.habitacion_id, new.id, 'salida', 'pendiente');
    end if;
  end if;

  return new;
end;
$$;

create trigger trg_sync_estado_habitacion
  after insert or update of estado on public.reservas
  for each row execute function public.sync_estado_habitacion();


-- 12. ÍNDICES
create index idx_reservas_habitacion_id  on public.reservas(habitacion_id);
create index idx_reservas_huesped_id     on public.reservas(huesped_id);
create index idx_reservas_fecha_entrada  on public.reservas(fecha_entrada);
create index idx_reservas_fecha_salida   on public.reservas(fecha_salida);
create index idx_reservas_estado         on public.reservas(estado);
create index idx_huespedes_cedula        on public.huespedes(cedula);
create index idx_huespedes_celular       on public.huespedes(celular);
create index idx_aseos_habitacion_fecha  on public.aseos(habitacion_id, fecha);
create index idx_aseos_estado            on public.aseos(estado);
create index idx_finanzas_fecha          on public.finanzas(fecha);


-- 13. VISTA: mapa en tiempo real (estado_hospedaje que pidió Zaven)
create or replace view public.v_mapa_habitaciones as
select
  h.id                                        as habitacion_id,
  h.numero,
  h.piso,
  h.estado                                    as estado_habitacion,
  h.precio_base,
  r.id                                        as reserva_id,
  r.fecha_entrada,
  r.fecha_salida,
  r.noches,
  r.pago_total,
  r.estado                                    as estado_reserva,
  r.acompanante,
  g.id                                        as huesped_id,
  g.nombre                                    as huesped_nombre,
  g.celular                                   as huesped_celular,
  g.nacionalidad                              as huesped_nacionalidad,
  case
    when r.id is null                                                       then 'libre'
    when current_date < r.fecha_entrada                                     then 'reserva_futura'
    when current_date >= r.fecha_entrada and current_date < r.fecha_salida  then 'hospedado'
    when current_date >= r.fecha_salida
         and r.estado in ('confirmada','activa')                            then 'checkout_pendiente'
    else 'libre'
  end                                         as estado_hospedaje,
  (r.fecha_salida - current_date)             as dias_restantes
from public.habitaciones h
left join public.reservas r on (
  r.habitacion_id = h.id
  and r.estado in ('confirmada','activa')
  and r.deleted_at is null
  and r.fecha_salida >= current_date - interval '1 day'
)
left join public.huespedes g on (
  g.id = r.huesped_id
  and g.deleted_at is null
)
order by h.piso, h.numero;


-- 14. VISTA: ocupación mensual
create or replace view public.v_ocupacion_mensual as
select
  date_trunc('month', r.fecha_entrada)::date          as mes,
  count(distinct r.id)                                 as total_reservas,
  sum(r.noches)                                        as noches_ocupadas,
  round(sum(r.noches)::numeric / (24 * 30) * 100, 1)  as porcentaje_ocupacion,
  sum(r.pago_total)                                    as ingresos_brutos,
  sum(r.comision)                                      as total_comisiones,
  sum(r.pago_total) - sum(coalesce(r.comision, 0))     as ingresos_netos
from public.reservas r
where r.estado in ('activa','completada')
  and r.deleted_at is null
group by date_trunc('month', r.fecha_entrada)
order by mes desc;


-- 15. FUNCIÓN: verificar disponibilidad
create or replace function public.habitacion_disponible(
  p_habitacion_id uuid,
  p_fecha_entrada date,
  p_fecha_salida  date
)
returns boolean language sql stable as $$
  select not exists (
    select 1 from public.reservas
    where habitacion_id = p_habitacion_id
      and estado in ('pendiente','confirmada','activa')
      and deleted_at is null
      and p_fecha_entrada < fecha_salida
      and p_fecha_salida  > fecha_entrada
  );
$$;


-- 16. FUNCIÓN: obtener rol del usuario actual
create or replace function public.get_mi_rol()
returns text language sql stable security definer as $$
  select rol from public.usuarios where id = auth.uid();
$$;


-- 17. ROW LEVEL SECURITY
alter table public.habitaciones  enable row level security;
alter table public.huespedes     enable row level security;
alter table public.operadores    enable row level security;
alter table public.reservas      enable row level security;
alter table public.aseos         enable row level security;
alter table public.lavanderia    enable row level security;
alter table public.finanzas      enable row level security;
alter table public.usuarios      enable row level security;


-- 18. POLÍTICAS RLS

-- habitaciones: todo el staff puede ver; solo gerente modifica
create policy "staff ve habitaciones"
  on public.habitaciones for select
  using (true);

create policy "gerente modifica habitaciones"
  on public.habitaciones for all
  using (public.get_mi_rol() = 'gerente');

-- huespedes: gerente y marketing ven todo; recepción gestiona; huesped solo se ve
create policy "gerente y marketing ven huespedes"
  on public.huespedes for select
  using (public.get_mi_rol() in ('gerente','marketing'));

create policy "recepcion gestiona huespedes"
  on public.huespedes for all
  using (public.get_mi_rol() = 'recepcion');

create policy "huesped ve su perfil"
  on public.huespedes for select
  using (public.get_mi_rol() = 'huesped' and id = auth.uid());

-- operadores: staff lee; gerente modifica
create policy "staff ve operadores"
  on public.operadores for select
  using (public.get_mi_rol() in ('gerente','recepcion','marketing'));

create policy "gerente modifica operadores"
  on public.operadores for all
  using (public.get_mi_rol() = 'gerente');

-- reservas: gerente y recepcion gestionan; marketing lee; huesped solo las suyas
create policy "gerente gestiona reservas"
  on public.reservas for all
  using (public.get_mi_rol() = 'gerente');

create policy "recepcion gestiona reservas"
  on public.reservas for all
  using (public.get_mi_rol() = 'recepcion');

create policy "marketing lee reservas"
  on public.reservas for select
  using (public.get_mi_rol() = 'marketing');

create policy "huesped ve sus reservas"
  on public.reservas for select
  using (public.get_mi_rol() = 'huesped' and huesped_id = auth.uid());

-- aseos: gerente y aseo gestionan; recepcion lee
create policy "gerente y aseo gestionan aseos"
  on public.aseos for all
  using (public.get_mi_rol() in ('gerente','aseo'));

create policy "recepcion lee aseos"
  on public.aseos for select
  using (public.get_mi_rol() = 'recepcion');

-- lavanderia: gerente y aseo gestionan
create policy "gerente y aseo gestionan lavanderia"
  on public.lavanderia for all
  using (public.get_mi_rol() in ('gerente','aseo'));

-- finanzas: solo gerente
create policy "solo gerente ve finanzas"
  on public.finanzas for all
  using (public.get_mi_rol() = 'gerente');

-- usuarios: gerente gestiona; cada uno ve su propio perfil
create policy "gerente gestiona usuarios"
  on public.usuarios for all
  using (public.get_mi_rol() = 'gerente');

create policy "usuario ve su perfil"
  on public.usuarios for select
  using (id = auth.uid());


-- 19. REALTIME para el mapa en tiempo real
alter publication supabase_realtime add table public.reservas;
alter publication supabase_realtime add table public.habitaciones;
alter publication supabase_realtime add table public.aseos;
