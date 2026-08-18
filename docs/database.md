# Esquema de Base de Datos — Break Digital
## Nova — Ingeniera de Base de Datos
**Estado:** Implementado · **Fecha:** 2026-05-31

---

## Diagrama de relaciones

```
habitaciones ──────────────────────────────────────────────────┐
     │                                                          │
     │ 1:N                                                      │
     ▼                                                          │
  reservas ──── N:1 ──── huespedes                             │
     │                                                          │
     │ 1:1 (nullable)                                           │
     ▼                                                          │
  finanzas                                                      │
     │                                                          │
  operadores ── 1:N ── reservas                                 │
                                                                │
  aseos ─────────────────────────────────── N:1 ───────────────┘
  lavanderia (independiente, puede asociarse a habitacion)
  usuarios (staff del hotel, separado de auth.users)
```

---

## SQL Completo — ejecutar en Supabase SQL Editor en este orden

```sql
-- ============================================================
-- 0. EXTENSIONES
-- ============================================================
create extension if not exists "uuid-ossp";


-- ============================================================
-- 1. TABLA: operadores
-- (va primero porque reservas la referencia)

-- ============================================================
create table public.operadores (
  id               uuid primary key default uuid_generate_v4(),
  nombre           text not null,
  porcentaje_comision numeric(5,2) not null default 0,
  activo           boolean not null default true,
  created_at       timestamptz not null default now()
);

comment on table public.operadores is 'Canales de reserva: Airbnb, Booking, Terceros, Alexander';

-- Datos semilla: los 4 operadores del hotel
insert into public.operadores (nombre, porcentaje_comision) values
  ('Airbnb',    15.00),
  ('Booking',   15.00),
  ('Terceros',  10.00),
  ('Alexander',  0.00);  -- canal directo, sin comisión


-- ============================================================
-- 2. TABLA: habitaciones
-- ============================================================
create table public.habitaciones (
  id          uuid primary key default uuid_generate_v4(),
  numero      integer unique not null,
  piso        integer not null check (piso between 1 and 4),
  tipo        text not null default 'apartaestudio',
  capacidad   integer not null default 2,
  estado      text not null default 'disponible',
  precio_base numeric(12,2) not null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),

  constraint estado_habitacion_valido
    check (estado in ('disponible','ocupada','aseo','mantenimiento'))
);

comment on table public.habitaciones is '24 estudios tipo apartaestudio, pisos 1-4';
comment on column public.habitaciones.estado is 'disponible | ocupada | aseo | mantenimiento';

-- Datos semilla: las 24 habitaciones
insert into public.habitaciones (numero, piso, precio_base) values
  -- Piso 1 (3 habitaciones)
  (105, 1, 120000),
  (106, 1, 120000),
  (107, 1, 120000),
  -- Piso 2 (7 habitaciones)
  (201, 2, 130000),
  (202, 2, 130000),
  (203, 2, 130000),
  (204, 2, 130000),
  (205, 2, 130000),
  (206, 2, 130000),
  (207, 2, 130000),
  -- Piso 3 (7 habitaciones)
  (301, 3, 140000),
  (302, 3, 140000),
  (303, 3, 140000),
  (304, 3, 140000),
  (305, 3, 140000),
  (306, 3, 140000),
  (307, 3, 140000),
  -- Piso 4 (7 habitaciones)
  (401, 4, 150000),
  (402, 4, 150000),
  (403, 4, 150000),
  (404, 4, 150000),
  (405, 4, 150000),
  (406, 4, 150000),
  (407, 4, 150000);


-- ============================================================
-- 3. TABLA: huespedes
-- Campos agregados por Zaven: celular (confirmado), nacionalidad (nuevo)
-- ============================================================
create table public.huespedes (
  id              uuid primary key default uuid_generate_v4(),
  nombre          text not null,
  cedula          text unique not null,
  celular         text,                              -- solicitado por Zaven
  correo          text,
  nacionalidad    text not null default 'colombiana', -- solicitado por Zaven
  notas           text,
  fecha_registro  date not null default current_date,
  deleted_at      timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

comment on table public.huespedes is 'CRM de huéspedes. Soft delete via deleted_at.';
comment on column public.huespedes.nacionalidad is 'Default: colombiana. Registrar huéspedes extranjeros.';
comment on column public.huespedes.deleted_at is 'Soft delete — nunca borrar registros reales.';


-- ============================================================
-- 4. TABLA: reservas
-- ============================================================
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
  estado          text not null default 'confirmada',
  observaciones   text,
  deleted_at      timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),

  constraint estado_reserva_valido
    check (estado in ('pendiente','confirmada','activa','completada','cancelada')),
  constraint fechas_validas
    check (fecha_salida > fecha_entrada)
);

comment on table public.reservas is 'Reservas del hotel. noches es columna calculada automáticamente.';
comment on column public.reservas.estado is 'pendiente | confirmada | activa | completada | cancelada';
comment on column public.reservas.noches is 'Calculado automáticamente: fecha_salida - fecha_entrada';


-- ============================================================
-- 5. TABLA: aseos
-- ============================================================
create table public.aseos (
  id            uuid primary key default uuid_generate_v4(),
  habitacion_id uuid not null references public.habitaciones(id),
  reserva_id    uuid references public.reservas(id),
  fecha         date not null default current_date,
  estado        text not null default 'pendiente',
  tipo_aseo     text not null default 'salida',
  responsable   text,
  observaciones text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),

  constraint estado_aseo_valido
    check (estado in ('pendiente','en_proceso','completado')),
  constraint tipo_aseo_valido
    check (tipo_aseo in ('salida','mantenimiento','diario'))
);

comment on table public.aseos is 'Control de aseo por habitación. Tipo: salida | mantenimiento | diario.';


-- ============================================================
-- 6. TABLA: lavanderia
-- ============================================================
create table public.lavanderia (
  id            uuid primary key default uuid_generate_v4(),
  fecha         date not null default current_date,
  habitacion_id uuid references public.habitaciones(id),
  tipo_prenda   text not null,
  cantidad      integer not null check (cantidad > 0),
  tiempo_minutos integer,
  estado        text not null default 'en_proceso',
  responsable   text,
  created_at    timestamptz not null default now(),

  constraint estado_lavanderia_valido
    check (estado in ('en_proceso','listo','entregado'))
);

comment on table public.lavanderia is 'Control de lavandería. tipo_prenda: Sábana, Toalla, Funda, etc.';


-- ============================================================
-- 7. TABLA: finanzas
-- ============================================================
create table public.finanzas (
  id          uuid primary key default uuid_generate_v4(),
  reserva_id  uuid references public.reservas(id),
  concepto    text not null,
  monto       numeric(12,2) not null,
  tipo        text not null,
  fecha       date not null default current_date,
  created_at  timestamptz not null default now(),

  constraint tipo_finanzas_valido
    check (tipo in ('ingreso','egreso','comision'))
);

comment on table public.finanzas is 'Movimientos financieros. Tipo: ingreso | egreso | comision.';


-- ============================================================
-- 8. TABLA: usuarios
-- Vinculada a auth.users de Supabase por el mismo id
-- ============================================================
create table public.usuarios (
  id      uuid primary key references auth.users(id) on delete cascade,
  nombre  text not null,
  rol     text not null default 'recepcion',
  email   text not null,
  activo  boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint rol_valido
    check (rol in ('gerente','recepcion','aseo','marketing','huesped'))
);

comment on table public.usuarios is 'Staff del hotel. id = auth.users.id de Supabase. 5 roles definidos.';
comment on column public.usuarios.rol is 'gerente | recepcion | aseo | marketing | huesped';


-- ============================================================
-- 9. TRIGGERS: updated_at automático en todas las tablas
-- ============================================================
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


-- ============================================================
-- 10. TRIGGER: calcular comisión automáticamente al crear/editar reserva
-- ============================================================
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


-- ============================================================
-- 11. TRIGGER: actualizar estado de habitación al cambiar reserva
-- ============================================================
create or replace function public.sync_estado_habitacion()
returns trigger language plpgsql as $$
begin
  -- Al activar una reserva → habitación ocupada
  if new.estado = 'activa' then
    update public.habitaciones set estado = 'ocupada'
    where id = new.habitacion_id;
  end if;
  -- Al completar o cancelar → habitación disponible (aseo lo cambia luego)
  if new.estado in ('completada','cancelada') and
     (old.estado is null or old.estado not in ('completada','cancelada')) then
    update public.habitaciones set estado = 'disponible'
    where id = new.habitacion_id;
    -- Crear tarea de aseo automáticamente al completar
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


-- ============================================================
-- 12. ÍNDICES para búsquedas frecuentes
-- ============================================================
create index idx_reservas_habitacion_id   on public.reservas(habitacion_id);
create index idx_reservas_huesped_id      on public.reservas(huesped_id);
create index idx_reservas_fecha_entrada   on public.reservas(fecha_entrada);
create index idx_reservas_fecha_salida    on public.reservas(fecha_salida);
create index idx_reservas_estado          on public.reservas(estado);
create index idx_huespedes_cedula         on public.huespedes(cedula);
create index idx_huespedes_celular        on public.huespedes(celular);
create index idx_aseos_habitacion_fecha   on public.aseos(habitacion_id, fecha);
create index idx_aseos_estado             on public.aseos(estado);
create index idx_finanzas_fecha           on public.finanzas(fecha);


-- ============================================================
-- 13. VISTA: mapa de habitaciones con estado en tiempo real
-- REQUERIMIENTO DE ZAVEN: mostrar si huésped está hospedado o ya se fue
-- ============================================================
create or replace view public.v_mapa_habitaciones as
select
  h.id                as habitacion_id,
  h.numero,
  h.piso,
  h.estado            as estado_habitacion,
  h.precio_base,

  -- Reserva activa (si existe)
  r.id                as reserva_id,
  r.fecha_entrada,
  r.fecha_salida,
  r.noches,
  r.pago_total,
  r.estado            as estado_reserva,
  r.acompanante,

  -- Datos del huésped actual
  g.id                as huesped_id,
  g.nombre            as huesped_nombre,
  g.celular           as huesped_celular,
  g.nacionalidad      as huesped_nacionalidad,

  -- ESTADO EN TIEMPO REAL (lo que pide Zaven)
  -- Responde: ¿está todavía hospedado o ya se fue?
  case
    when r.id is null
      then 'libre'
    when current_date < r.fecha_entrada
      then 'reserva_futura'           -- llegará pronto
    when current_date >= r.fecha_entrada
     and current_date < r.fecha_salida
      then 'hospedado'                -- TODAVÍA ESTÁ
    when current_date >= r.fecha_salida
     and r.estado in ('confirmada','activa')
      then 'checkout_pendiente'       -- YA DEBERÍA HABERSE IDO (alerta)
    else 'libre'
  end                 as estado_hospedaje,

  -- Días restantes (negativo = checkout vencido)
  (r.fecha_salida - current_date) as dias_restantes

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

comment on view public.v_mapa_habitaciones is
  'Vista principal del dashboard admin. Estado en tiempo real por habitación.
   estado_hospedaje: libre | reserva_futura | hospedado | checkout_pendiente';


-- ============================================================
-- 14. VISTA: reporte de ocupación mensual
-- ============================================================
create or replace view public.v_ocupacion_mensual as
select
  date_trunc('month', r.fecha_entrada)::date as mes,
  count(distinct r.id)                        as total_reservas,
  sum(r.noches)                               as noches_ocupadas,
  count(distinct r.habitacion_id)             as habitaciones_activas,
  -- 744 = 24 habitaciones × 31 días (ajustar si el mes tiene menos)
  round(sum(r.noches)::numeric / (24 * 30) * 100, 1) as porcentaje_ocupacion,
  sum(r.pago_total)                           as ingresos_brutos,
  sum(r.comision)                             as total_comisiones,
  sum(r.pago_total) - sum(coalesce(r.comision,0)) as ingresos_netos
from public.reservas r
where r.estado in ('activa','completada')
  and r.deleted_at is null
group by date_trunc('month', r.fecha_entrada)
order by mes desc;

comment on view public.v_ocupacion_mensual is
  'Reporte mensual de ocupación e ingresos. Reemplaza Ventas_2026.xlsx';


-- ============================================================
-- 15. FUNCIÓN: verificar disponibilidad de habitación
-- Útil para el flujo de reserva en el frontend
-- ============================================================
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
      -- Hay traslape si: entrada < salida_existente AND salida > entrada_existente
      and p_fecha_entrada < fecha_salida
      and p_fecha_salida  > fecha_entrada
  );
$$;

comment on function public.habitacion_disponible is
  'Retorna true si la habitación está disponible para el rango de fechas dado.';


-- ============================================================
-- 16. ROW LEVEL SECURITY — Habilitar en todas las tablas
-- ============================================================
alter table public.habitaciones  enable row level security;
alter table public.huespedes     enable row level security;
alter table public.operadores    enable row level security;
alter table public.reservas      enable row level security;
alter table public.aseos         enable row level security;
alter table public.lavanderia    enable row level security;
alter table public.finanzas      enable row level security;
alter table public.usuarios      enable row level security;


-- ============================================================
-- 17. FUNCIÓN HELPER: obtener el rol del usuario actual
-- ============================================================
create or replace function public.get_mi_rol()
returns text language sql stable security definer as $$
  select rol from public.usuarios where id = auth.uid();
$$;


-- ============================================================
-- 18. RLS POLICIES — por tabla y por rol
-- ============================================================

-- ── HABITACIONES ─────────────────────────────────────────────
-- Staff (todos los roles internos) puede leer habitaciones
create policy "staff puede ver habitaciones"
  on public.habitaciones for select
  using (public.get_mi_rol() in ('gerente','recepcion','aseo','marketing'));

-- Solo gerente puede modificar habitaciones
create policy "gerente puede modificar habitaciones"
  on public.habitaciones for all
  using (public.get_mi_rol() = 'gerente');

-- Huéspedes pueden ver habitaciones para el portal de reservas
create policy "huesped puede ver habitaciones disponibles"
  on public.habitaciones for select
  using (true); -- público para el portal de reservas

-- ── HUÉSPEDES (CRM) ──────────────────────────────────────────
-- Gerente y marketing ven todos los huéspedes
create policy "gerente y marketing ven todos los huespedes"
  on public.huespedes for select
  using (public.get_mi_rol() in ('gerente','marketing'));

-- Recepción puede leer y crear/editar huéspedes
create policy "recepcion gestiona huespedes"
  on public.huespedes for all
  using (public.get_mi_rol() = 'recepcion');

-- Huésped solo se ve a sí mismo
create policy "huesped ve solo su perfil"
  on public.huespedes for select
  using (
    public.get_mi_rol() = 'huesped'
    and id = auth.uid()
  );

-- ── RESERVAS ─────────────────────────────────────────────────
-- Gerente ve y gestiona todo
create policy "gerente gestiona todas las reservas"
  on public.reservas for all
  using (public.get_mi_rol() = 'gerente');

-- Recepción puede ver y crear reservas
create policy "recepcion gestiona reservas"
  on public.reservas for all
  using (public.get_mi_rol() = 'recepcion');

-- Marketing puede ver reservas (para analíticas y CRM)
create policy "marketing puede ver reservas"
  on public.reservas for select
  using (public.get_mi_rol() = 'marketing');

-- Huésped solo ve sus propias reservas
create policy "huesped ve solo sus reservas"
  on public.reservas for select
  using (
    public.get_mi_rol() = 'huesped'
    and huesped_id = auth.uid()
  );

-- ── ASEOS ────────────────────────────────────────────────────
-- Aseo puede ver y actualizar sus tareas
create policy "aseo gestiona sus tareas"
  on public.aseos for all
  using (public.get_mi_rol() in ('gerente','aseo'));

-- Recepción puede ver estado de aseo
create policy "recepcion ve aseos"
  on public.aseos for select
  using (public.get_mi_rol() = 'recepcion');

-- ── LAVANDERÍA ───────────────────────────────────────────────
create policy "aseo y gerente gestionan lavanderia"
  on public.lavanderia for all
  using (public.get_mi_rol() in ('gerente','aseo'));

create policy "recepcion ve lavanderia"
  on public.lavanderia for select
  using (public.get_mi_rol() = 'recepcion');

-- ── FINANZAS ─────────────────────────────────────────────────
-- Solo gerente accede a finanzas
create policy "solo gerente ve finanzas"
  on public.finanzas for all
  using (public.get_mi_rol() = 'gerente');

-- ── OPERADORES ───────────────────────────────────────────────
create policy "staff puede ver operadores"
  on public.operadores for select
  using (public.get_mi_rol() in ('gerente','recepcion','marketing'));

create policy "gerente gestiona operadores"
  on public.operadores for all
  using (public.get_mi_rol() = 'gerente');

-- ── USUARIOS ─────────────────────────────────────────────────
-- Gerente gestiona el equipo
create policy "gerente gestiona usuarios"
  on public.usuarios for all
  using (public.get_mi_rol() = 'gerente');

-- Cada usuario puede ver su propio perfil
create policy "usuario ve su propio perfil"
  on public.usuarios for select
  using (id = auth.uid());


-- ============================================================
-- 19. REALTIME: habilitar para el mapa en tiempo real
-- ============================================================
-- Ejecutar en Supabase Dashboard → Database → Replication
-- O via SQL:
alter publication supabase_realtime add table public.reservas;
alter publication supabase_realtime add table public.habitaciones;
alter publication supabase_realtime add table public.aseos;
```

---

## Resumen de tablas

| Tabla | Filas esperadas | Notas |
|---|---|---|
| `habitaciones` | 24 (fijas) | Ya insertadas con datos semilla |
| `operadores` | 4 (fijos) | Airbnb, Booking, Terceros, Alexander — ya insertados |
| `huespedes` | ~37 iniciales → crece | Migrar desde Base_de_Datos.xlsx |
| `reservas` | ~hundreds/año | Migrar desde Break_1.xlsx |
| `aseos` | ~365+/año | Se crean automáticamente al completar reserva |
| `lavanderia` | ~hundreds/año | Migrar desde Aseos.xlsx |
| `finanzas` | ~hundreds/año | Migrar desde Ventas_2026.xlsx |
| `usuarios` | 5 (staff) | Crear manualmente en Supabase Auth |

## Campos agregados por Zaven

| Campo | Tabla | Tipo | Por qué |
|---|---|---|---|
| `celular` | huespedes | text | Confirmado por Zaven — canal principal de contacto |
| `nacionalidad` | huespedes | text DEFAULT 'colombiana' | Identificar huéspedes extranjeros |
| `estado_hospedaje` | v_mapa_habitaciones (vista) | text calculado | Real-time: hospedado vs checkout_pendiente |
| `dias_restantes` | v_mapa_habitaciones (vista) | integer calculado | Días hasta check-out (negativo = vencido) |

## Valores de `estado_hospedaje` (vista en tiempo real)

| Valor | Significado | Color en dashboard |
|---|---|---|
| `libre` | Habitación sin reserva activa | Verde |
| `reserva_futura` | Hay reserva pero aún no llega | Azul |
| `hospedado` | Huésped actualmente en el hotel | Rojo (ocupada) |
| `checkout_pendiente` | Fecha de salida pasó — alerta | Ámbar parpadeante |
