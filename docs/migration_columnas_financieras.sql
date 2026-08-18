-- 1. Agregar columnas financieras faltantes a la tabla reservas
-- Ejecutar PRIMERO en Supabase SQL Editor

ALTER TABLE public.reservas
  ADD COLUMN IF NOT EXISTS aseo_cobrado      numeric(12,2),
  ADD COLUMN IF NOT EXISTS ingreso_hotel     numeric(12,2),
  ADD COLUMN IF NOT EXISTS ingreso_operador  numeric(12,2),
  ADD COLUMN IF NOT EXISTS ingreso_neto      numeric(12,2),
  ADD COLUMN IF NOT EXISTS check_in_early    text,
  ADD COLUMN IF NOT EXISTS check_out_late    text,
  ADD COLUMN IF NOT EXISTS verificacion      numeric(12,2);

-- 2. Actualizar registros existentes con datos financieros del Excel
-- 659 actualizaciones

UPDATE public.reservas r SET
  comision         = 518526,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 1723432,
  ingreso_operador = 544242,
  ingreso_neto     = 2292674,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Sandra Romero';
UPDATE public.reservas r SET
  comision         = 92225,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 294709,
  ingreso_operador = 93066,
  ingreso_neto     = 407775,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-10'
  AND g.nombre ILIKE 'Dora Patricia Montaña';
UPDATE public.reservas r SET
  comision         = 216175,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 711227,
  ingreso_operador = 224598,
  ingreso_neto     = 955825,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-01-10'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Mario Machado';
UPDATE public.reservas r SET
  comision         = 65664,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 205455,
  ingreso_operador = 64881,
  ingreso_neto     = 290336,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-01-30'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Jennifer Nuhma';
UPDATE public.reservas r SET
  comision         = 23610,
  aseo_cobrado     = 0,
  ingreso_hotel    = 90820,
  ingreso_operador = 13571,
  ingreso_neto     = 104390,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-02-15'
  AND r.fecha_salida  = '2026-02-16'
  AND g.nombre ILIKE 'John Alejandro Rios Gonzalez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 114750,
  ingreso_operador = 0,
  ingreso_neto     = 114750,
  verificacion     = 20250,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-02-20'
  AND r.fecha_salida  = '2026-02-21'
  AND g.nombre ILIKE 'Mateo Botero Botero';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 170000,
  ingreso_operador = 0,
  ingreso_neto     = 170000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-02-28'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Carlos Marulanda';
UPDATE public.reservas r SET
  comision         = 46400,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 153136,
  ingreso_operador = 27024,
  ingreso_neto     = 205160,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-03-11'
  AND r.fecha_salida  = '2026-03-13'
  AND g.nombre ILIKE 'Wolfgang Buitrago';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172768,
  ingreso_operador = 30488,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-03-13'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Duvan Felipe Palacio Ocampo';
UPDATE public.reservas r SET
  comision         = 57157,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 193563,
  ingreso_operador = 34158,
  ingreso_neto     = 252721,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-22'
  AND g.nombre ILIKE 'Paula Ospina';
UPDATE public.reservas r SET
  comision         = 31731,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 98006,
  ingreso_operador = 17295,
  ingreso_neto     = 140301,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-03-22'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Andres Felipe Mesa Londoño';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 261531,
  ingreso_operador = 0,
  ingreso_neto     = 286531,
  verificacion     = 46152,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-04'
  AND g.nombre ILIKE 'Sebastián Bedoya';
UPDATE public.reservas r SET
  comision         = 32892,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 102369,
  ingreso_operador = 18065,
  ingreso_neto     = 145435,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-04-11'
  AND r.fecha_salida  = '2026-04-12'
  AND g.nombre ILIKE 'Jorge Castellanos Restrepo';
UPDATE public.reservas r SET
  comision         = 31326,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 96483,
  ingreso_operador = 17026,
  ingreso_neto     = 138510,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-04-18'
  AND r.fecha_salida  = '2026-04-19'
  AND g.nombre ILIKE 'Manuel Henao';
UPDATE public.reservas r SET
  comision         = 31326,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 96483,
  ingreso_operador = 17026,
  ingreso_neto     = 138510,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Santiago Perez';
UPDATE public.reservas r SET
  comision         = 31326,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 96483,
  ingreso_operador = 17026,
  ingreso_neto     = 138510,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Jhon Alejandro Suarez Jimenez';
UPDATE public.reservas r SET
  comision         = 54843,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 184866,
  ingreso_operador = 32623,
  ingreso_neto     = 242489,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Ana Maria Rodriguez Rendon';
UPDATE public.reservas r SET
  comision         = 37895,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 121172,
  ingreso_operador = 21383,
  ingreso_neto     = 167555,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-23'
  AND g.nombre ILIKE 'Juan Arias';
UPDATE public.reservas r SET
  comision         = 33106,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103174,
  ingreso_operador = 18207,
  ingreso_neto     = 146381,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 105
  AND r.fecha_entrada = '2026-05-23'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Sebastian Rodriguez';
UPDATE public.reservas r SET
  comision         = 512771,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 1707894,
  ingreso_operador = 539335,
  ingreso_neto     = 2267229,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Juan David Pachon Perez';
UPDATE public.reservas r SET
  comision         = 66372,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 207835,
  ingreso_operador = 65632,
  ingreso_neto     = 293468,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-01-14'
  AND r.fecha_salida  = '2026-01-16'
  AND g.nombre ILIKE 'Nicolas Perez';
UPDATE public.reservas r SET
  comision         = 18140,
  aseo_cobrado     = 0,
  ingreso_hotel    = 78121,
  ingreso_operador = 24670,
  ingreso_neto     = 102791,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-01-21'
  AND r.fecha_salida  = '2026-01-22'
  AND g.nombre ILIKE 'David Alejandro Diaz Pinilla';
UPDATE public.reservas r SET
  comision         = 30329,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 86718,
  ingreso_operador = 27385,
  ingreso_neto     = 134103,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Andrea Gallego Osma';
UPDATE public.reservas r SET
  comision         = 36990,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 124889,
  ingreso_operador = 18662,
  ingreso_neto     = 163550,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-02-13'
  AND r.fecha_salida  = '2026-02-14'
  AND g.nombre ILIKE 'Adrian Felipe Bedoya Galindo';
UPDATE public.reservas r SET
  comision         = 174253,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 633644,
  ingreso_operador = 111819,
  ingreso_neto     = 770463,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-03-13'
  AND r.fecha_salida  = '2026-03-21'
  AND g.nombre ILIKE 'Hannah Galeano';
UPDATE public.reservas r SET
  comision         = 66331,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 228041,
  ingreso_operador = 40242,
  ingreso_neto     = 293283,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-03-21'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Juan Sarria';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 376100,
  ingreso_operador = 66371,
  ingreso_neto     = 467471,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-03-30'
  AND r.fecha_salida  = '2026-04-02'
  AND g.nombre ILIKE 'andres rodriguez';
UPDATE public.reservas r SET
  comision         = 70421,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 243412,
  ingreso_operador = 42955,
  ingreso_neto     = 311367,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-04'
  AND g.nombre ILIKE 'Carlos Lozano';
UPDATE public.reservas r SET
  comision         = 68303,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 235452,
  ingreso_operador = 41550,
  ingreso_neto     = 302002,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-04-11'
  AND r.fecha_salida  = '2026-04-13'
  AND g.nombre ILIKE 'Emmanuel Rubiano';
UPDATE public.reservas r SET
  comision         = 28921,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 87444,
  ingreso_operador = 15431,
  ingreso_neto     = 127875,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Juan Diego Gomez Gutierrez';
UPDATE public.reservas r SET
  comision         = 28921,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 87444,
  ingreso_operador = 15431,
  ingreso_neto     = 127875,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-04-29'
  AND r.fecha_salida  = '2026-04-30'
  AND g.nombre ILIKE 'Edwin Garcia Garcia';
UPDATE public.reservas r SET
  comision         = 57842,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 196137,
  ingreso_operador = 34612,
  ingreso_neto     = 255750,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Manuela Osorio';
UPDATE public.reservas r SET
  comision         = 54843,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 184866,
  ingreso_operador = 32623,
  ingreso_neto     = 242489,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Ana Maria Rodriguez Rendon';
UPDATE public.reservas r SET
  comision         = 39949,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 128888,
  ingreso_operador = 22745,
  ingreso_neto     = 176633,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-05-23'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Mateo Rojas Saraza';
UPDATE public.reservas r SET
  comision         = 71129,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 246073,
  ingreso_operador = 43425,
  ingreso_neto     = 314497,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 106
  AND r.fecha_entrada = '2026-05-26'
  AND r.fecha_salida  = '2026-05-28'
  AND g.nombre ILIKE 'Lucia Garcia Giraldo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 123947,
  ingreso_operador = 39141,
  ingreso_neto     = 163088,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-07'
  AND g.nombre ILIKE 'daniela andrea ruiz';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 798000,
  ingreso_operador = 252000,
  ingreso_neto     = 1050000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Felipe Agurto';
UPDATE public.reservas r SET
  comision         = 35031,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 102516,
  ingreso_operador = 32373,
  ingreso_neto     = 154889,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Beto Hidalgo';
UPDATE public.reservas r SET
  comision         = 27859,
  aseo_cobrado     = 0,
  ingreso_hotel    = 93617,
  ingreso_operador = 29563,
  ingreso_neto     = 123181,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-01-12'
  AND r.fecha_salida  = '2026-01-13'
  AND g.nombre ILIKE 'Jorge Chaparro Lopez';
UPDATE public.reservas r SET
  comision         = 20894,
  aseo_cobrado     = 0,
  ingreso_hotel    = 70213,
  ingreso_operador = 22173,
  ingreso_neto     = 92386,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-01-15'
  AND r.fecha_salida  = '2026-01-16'
  AND g.nombre ILIKE 'Jhon James Osorio';
UPDATE public.reservas r SET
  comision         = 27195,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 76186,
  ingreso_operador = 24059,
  ingreso_neto     = 120245,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-01-17'
  AND r.fecha_salida  = '2026-01-18'
  AND g.nombre ILIKE 'Jorge Mario Betancur Ortiz';
UPDATE public.reservas r SET
  comision         = 26999,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 75528,
  ingreso_operador = 23851,
  ingreso_neto     = 119379,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Luis Eduardo Portocarrero';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 180120,
  ingreso_operador = 56880,
  ingreso_neto     = 237000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-02-12'
  AND r.fecha_salida  = '2026-02-14'
  AND g.nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 180120,
  ingreso_operador = 56880,
  ingreso_neto     = 237000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-02-14'
  AND r.fecha_salida  = '2026-02-16'
  AND g.nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 206190,
  ingreso_operador = 30810,
  ingreso_neto     = 262000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-02-16'
  AND r.fecha_salida  = '2026-02-18'
  AND g.nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 313200,
  ingreso_operador = 46800,
  ingreso_neto     = 360000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-02-18'
  AND r.fecha_salida  = '2026-02-21'
  AND g.nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga';
UPDATE public.reservas r SET
  comision         = 45335,
  aseo_cobrado     = 0,
  ingreso_hotel    = 152645,
  ingreso_operador = 22809,
  ingreso_neto     = 175454,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Juan David Santacruz L';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 97750,
  ingreso_operador = 17250,
  ingreso_neto     = 140000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-03-14'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Cristian Asprilla';
UPDATE public.reservas r SET
  comision         = 95521,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 337747,
  ingreso_operador = 59602,
  ingreso_neto     = 422350,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-03-18'
  AND r.fecha_salida  = '2026-03-22'
  AND g.nombre ILIKE 'Sofia Zapata Diossa';
UPDATE public.reservas r SET
  comision         = 29166,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 88364,
  ingreso_operador = 15594,
  ingreso_neto     = 128957,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-03-22'
  AND r.fecha_salida  = '2026-03-24'
  AND g.nombre ILIKE 'Kerstinck Sarmiento';
UPDATE public.reservas r SET
  comision         = 58156,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 197318,
  ingreso_operador = 34821,
  ingreso_neto     = 257139,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Alejandro Alvarez Uribe';
UPDATE public.reservas r SET
  comision         = 49425,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 164505,
  ingreso_operador = 29030,
  ingreso_neto     = 218535,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-10'
  AND r.fecha_salida  = '2026-04-12'
  AND g.nombre ILIKE 'Juan Pablo Duque Gallego';
UPDATE public.reservas r SET
  comision         = 47072,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 155659,
  ingreso_operador = 27469,
  ingreso_neto     = 208128,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-16'
  AND r.fecha_salida  = '2026-04-18'
  AND g.nombre ILIKE 'Juan camilo Casas Castillo';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-18'
  AND r.fecha_salida  = '2026-04-19'
  AND g.nombre ILIKE 'Steven Escobar Castaño';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-20'
  AND r.fecha_salida  = '2026-04-21'
  AND g.nombre ILIKE 'Esteban Barragan';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-23'
  AND r.fecha_salida  = '2026-04-24'
  AND g.nombre ILIKE 'Addy Dayana Luna Drith';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-24'
  AND r.fecha_salida  = '2026-04-25'
  AND g.nombre ILIKE 'Santiago Marin Tobar';
UPDATE public.reservas r SET
  comision         = 22653,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 63888,
  ingreso_operador = 11274,
  ingreso_neto     = 100162,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Robinson Diaz';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-27'
  AND r.fecha_salida  = '2026-04-28'
  AND g.nombre ILIKE 'Edwar Salaza';
UPDATE public.reservas r SET
  comision         = 47072,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 155659,
  ingreso_operador = 27469,
  ingreso_neto     = 208128,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-04-29'
  AND r.fecha_salida  = '2026-05-01'
  AND g.nombre ILIKE 'Andrea Carolina Guerrero Rodriguez';
UPDATE public.reservas r SET
  comision         = 30728,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 94237,
  ingreso_operador = 16630,
  ingreso_neto     = 135867,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Santiago Cardona Quintero';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Juan David Valencia Salazar';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-08'
  AND r.fecha_salida  = '2026-05-09'
  AND g.nombre ILIKE 'Diego Alejandro Restrepo Garcia';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 98600,
  ingreso_operador = 0,
  ingreso_neto     = 123600,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-10'
  AND r.fecha_salida  = '2026-05-11'
  AND g.nombre ILIKE 'montoya lopez vianey';
UPDATE public.reservas r SET
  comision         = 45306,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 149025,
  ingreso_operador = 26299,
  ingreso_neto     = 200324,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-12'
  AND r.fecha_salida  = '2026-05-14'
  AND g.nombre ILIKE 'Yeiny Covaleda Guzman';
UPDATE public.reservas r SET
  comision         = 22653,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 63888,
  ingreso_operador = 11274,
  ingreso_neto     = 100162,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-16'
  AND g.nombre ILIKE 'Jaime Mariottyz';
UPDATE public.reservas r SET
  comision         = 54843,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 184866,
  ingreso_operador = 32623,
  ingreso_neto     = 242489,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Ana Maria Rodriguez Rendon';
UPDATE public.reservas r SET
  comision         = 28147,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84535,
  ingreso_operador = 14918,
  ingreso_neto     = 124453,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-18'
  AND r.fecha_salida  = '2026-05-19'
  AND g.nombre ILIKE 'Alejandro Arboleda';
UPDATE public.reservas r SET
  comision         = 27117,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 80665,
  ingreso_operador = 14235,
  ingreso_neto     = 119901,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-20'
  AND r.fecha_salida  = '2026-05-21'
  AND g.nombre ILIKE 'Luz Darly Reyes Guzman';
UPDATE public.reservas r SET
  comision         = 30501,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93380,
  ingreso_operador = 16479,
  ingreso_neto     = 134859,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-21'
  AND r.fecha_salida  = '2026-05-22'
  AND g.nombre ILIKE 'Sharin Tacha';
UPDATE public.reservas r SET
  comision         = 50800,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 169672,
  ingreso_operador = 29942,
  ingreso_neto     = 224615,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Brian Alexander Reyes Giraldo';
UPDATE public.reservas r SET
  comision         = 90025,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 317089,
  ingreso_operador = 55957,
  ingreso_neto     = 398045,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 107
  AND r.fecha_entrada = '2026-05-24'
  AND r.fecha_salida  = '2026-05-29'
  AND g.nombre ILIKE 'Aleyda Marcela Bechara Cordoba';
UPDATE public.reservas r SET
  comision         = 74552,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 235323,
  ingreso_operador = 74313,
  ingreso_neto     = 329636,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-01-03'
  AND r.fecha_salida  = '2026-01-05'
  AND g.nombre ILIKE 'Carlos Quinche';
UPDATE public.reservas r SET
  comision         = 268910,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 888433,
  ingreso_operador = 280558,
  ingreso_neto     = 1188990,
  verificacion     = NULL,
  check_in_early   = NULL,
  check_out_late   = '$20.000',
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Marco Garcia';
UPDATE public.reservas r SET
  comision         = 74208,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 234165,
  ingreso_operador = 73947,
  ingreso_neto     = 328112,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-13'
  AND g.nombre ILIKE 'Lisseth Carolina Guerrero Sierra';
UPDATE public.reservas r SET
  comision         = 79614,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 252333,
  ingreso_operador = 79684,
  ingreso_neto     = 352017,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-01-20'
  AND r.fecha_salida  = '2026-01-23'
  AND g.nombre ILIKE 'Mitchell Simpson';
UPDATE public.reservas r SET
  comision         = 78126,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 247330,
  ingreso_operador = 78104,
  ingreso_neto     = 345434,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-01-24'
  AND r.fecha_salida  = '2026-01-26'
  AND g.nombre ILIKE 'Rafael Quezada';
UPDATE public.reservas r SET
  comision         = 34443,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 100541,
  ingreso_operador = 31750,
  ingreso_neto     = 152291,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-01-31'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Juan Diego Gomez Gutierrez';
UPDATE public.reservas r SET
  comision         = 34443,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 100541,
  ingreso_operador = 31750,
  ingreso_neto     = 152291,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-02-04'
  AND r.fecha_salida  = '2026-02-05'
  AND g.nombre ILIKE 'Cesar Osorio';
UPDATE public.reservas r SET
  comision         = 29830,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 85039,
  ingreso_operador = 26854,
  ingreso_neto     = 131893,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-02-06'
  AND r.fecha_salida  = '2026-02-07'
  AND g.nombre ILIKE 'Valentina Giraldo Morales';
UPDATE public.reservas r SET
  comision         = 154384,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 503585,
  ingreso_operador = 159027,
  ingreso_neto     = 682612,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-02-12'
  AND r.fecha_salida  = '2026-02-17'
  AND g.nombre ILIKE 'Joe Rico';
UPDATE public.reservas r SET
  comision         = 66119,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 232593,
  ingreso_operador = 34755,
  ingreso_neto     = 292349,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-02-19'
  AND r.fecha_salida  = '2026-02-21'
  AND g.nombre ILIKE 'Isabella Hurtado Medina';
UPDATE public.reservas r SET
  comision         = 35365,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 114291,
  ingreso_operador = 17078,
  ingreso_neto     = 156369,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-02-21'
  AND r.fecha_salida  = '2026-02-22'
  AND g.nombre ILIKE 'Wendy Guzman';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 126150,
  ingreso_operador = 0,
  ingreso_neto     = 151150,
  verificacion     = 18850,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-02-28'
  AND g.nombre ILIKE 'Manuel Jose Sierra';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 126150,
  ingreso_operador = 0,
  ingreso_neto     = 151150,
  verificacion     = 18850,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-02-28'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Manuel Jose Sierra';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 86411,
  ingreso_operador = 12912,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-03-12'
  AND r.fecha_salida  = '2026-03-13'
  AND g.nombre ILIKE 'esteban cardona';
UPDATE public.reservas r SET
  comision         = 66380,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 228225,
  ingreso_operador = 40275,
  ingreso_neto     = 293500,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-03-13'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Diego Jesús Molano Acelas';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 174250,
  ingreso_operador = 30750,
  ingreso_neto     = 230000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-21'
  AND g.nombre ILIKE 'Andres Velasquez';
UPDATE public.reservas r SET
  comision         = 59018,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 200556,
  ingreso_operador = 35392,
  ingreso_neto     = 260948,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-03-21'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Maycoll Denis Toro Salazar';
UPDATE public.reservas r SET
  comision         = 56847,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 192400,
  ingreso_operador = 33953,
  ingreso_neto     = 251353,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-03-27'
  AND r.fecha_salida  = '2026-03-29'
  AND g.nombre ILIKE 'Maria Camila Echeverri';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 110500,
  ingreso_operador = 0,
  ingreso_neto     = 0,
  verificacion     = 19500,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-02'
  AND g.nombre ILIKE 'wendy dayana yepes sorio';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 110500,
  ingreso_operador = 0,
  ingreso_neto     = 0,
  verificacion     = 19500,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Mariana Hernandez restrepo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 95367,
  ingreso_operador = 16829,
  ingreso_neto     = 137196,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Daniela Valencia Castaño';
UPDATE public.reservas r SET
  comision         = 30728,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 94237,
  ingreso_operador = 16630,
  ingreso_neto     = 135867,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Juan David Cadavid Gomez';
UPDATE public.reservas r SET
  comision         = 30728,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 94237,
  ingreso_operador = 16630,
  ingreso_neto     = 135867,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Silvana Montoya';
UPDATE public.reservas r SET
  comision         = 33532,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 104774,
  ingreso_operador = 18490,
  ingreso_neto     = 148264,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-05-09'
  AND r.fecha_salida  = '2026-05-10'
  AND g.nombre ILIKE 'Catalina Gomez';
UPDATE public.reservas r SET
  comision         = 69684,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 240641,
  ingreso_operador = 42466,
  ingreso_neto     = 308107,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-17'
  AND g.nombre ILIKE 'catalina gomez';
UPDATE public.reservas r SET
  comision         = 32279,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 100063,
  ingreso_operador = 17658,
  ingreso_neto     = 142721,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-05-18'
  AND r.fecha_salida  = '2026-05-19'
  AND g.nombre ILIKE 'Luis Marin Botero';
UPDATE public.reservas r SET
  comision         = 71129,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 246073,
  ingreso_operador = 43425,
  ingreso_neto     = 314497,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Romulo Hernandez';
UPDATE public.reservas r SET
  comision         = 96797,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 342542,
  ingreso_operador = 60449,
  ingreso_neto     = 427990,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 201
  AND r.fecha_entrada = '2026-05-28'
  AND r.fecha_salida  = '2026-05-31'
  AND g.nombre ILIKE 'Manuel Torres';
UPDATE public.reservas r SET
  comision         = 122526,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 396533,
  ingreso_operador = 125221,
  ingreso_neto     = 541754,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-01-02'
  AND r.fecha_salida  = '2026-01-05'
  AND g.nombre ILIKE 'Natalia Hernandez';
UPDATE public.reservas r SET
  comision         = 47219,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 143473,
  ingreso_operador = 45307,
  ingreso_neto     = 208781,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Gustavo Antonio Sands Porras';
UPDATE public.reservas r SET
  comision         = 257209,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 849114,
  ingreso_operador = 268141,
  ingreso_neto     = 1137255,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'santiago botero';
UPDATE public.reservas r SET
  comision         = 27509,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 77239,
  ingreso_operador = 24391,
  ingreso_neto     = 121630,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-01-24'
  AND r.fecha_salida  = '2026-01-25'
  AND g.nombre ILIKE 'Santiago Alexander Vasquez Murcia';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 106400,
  ingreso_operador = 33600,
  ingreso_neto     = 140000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-02-01'
  AND r.fecha_salida  = '2026-02-02'
  AND g.nombre ILIKE 'Kelly Alexandra Alzate Marin';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 106250,
  ingreso_operador = 0,
  ingreso_neto     = 125000,
  verificacion     = 18750,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-02-14'
  AND r.fecha_salida  = '2026-02-15'
  AND g.nombre ILIKE 'Brayan Duque galvis';
UPDATE public.reservas r SET
  comision         = 69254,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 244650,
  ingreso_operador = 36557,
  ingreso_neto     = 306206,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-03-01'
  AND r.fecha_salida  = '2026-03-04'
  AND g.nombre ILIKE 'Henry Enrique Sanchez';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-03-12'
  AND r.fecha_salida  = '2026-03-13'
  AND g.nombre ILIKE 'Juan David Villada Zuluaga';
UPDATE public.reservas r SET
  comision         = 30729,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 94240,
  ingreso_operador = 16631,
  ingreso_neto     = 135871,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-03-16'
  AND r.fecha_salida  = '2026-03-17'
  AND g.nombre ILIKE 'Andy Lind';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-21'
  AND g.nombre ILIKE 'Andrés Valencia';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 228744,
  ingreso_operador = 0,
  ingreso_neto     = 253744,
  verificacion     = 40367,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-03-21'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Nataly Paredes';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 106250,
  ingreso_operador = 0,
  ingreso_neto     = 131250,
  verificacion     = 18750,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-03-26'
  AND r.fecha_salida  = '2026-03-27'
  AND g.nombre ILIKE 'Juan Esteban Lopez valencia';
UPDATE public.reservas r SET
  comision         = 76809,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 267422,
  ingreso_operador = 47192,
  ingreso_neto     = 339615,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-03-28'
  AND r.fecha_salida  = '2026-03-31'
  AND g.nombre ILIKE 'Jorge Pinilla';
UPDATE public.reservas r SET
  comision         = 32035,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 99148,
  ingreso_operador = 17497,
  ingreso_neto     = 141645,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-03-31'
  AND r.fecha_salida  = '2026-04-01'
  AND g.nombre ILIKE 'Jesús Ospina Atehortua';
UPDATE public.reservas r SET
  comision         = 32035,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 99148,
  ingreso_operador = 17497,
  ingreso_neto     = 141645,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-02'
  AND g.nombre ILIKE 'Juan Diego Castro Hernandez';
UPDATE public.reservas r SET
  comision         = 95209,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 336575,
  ingreso_operador = 59396,
  ingreso_neto     = 420971,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-05'
  AND g.nombre ILIKE 'Johnnatan Delgado';
UPDATE public.reservas r SET
  comision         = 30367,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 92878,
  ingreso_operador = 0,
  ingreso_neto     = 117878,
  verificacion     = 16390,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-04-10'
  AND r.fecha_salida  = '2026-04-11'
  AND g.nombre ILIKE 'Leandro Soto';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-04-19'
  AND r.fecha_salida  = '2026-04-20'
  AND g.nombre ILIKE 'Esteban Cardona';
UPDATE public.reservas r SET
  comision         = 28921,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 87444,
  ingreso_operador = 15431,
  ingreso_neto     = 127875,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Magda Johana Oviedo Franco';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 95367,
  ingreso_operador = 16829,
  ingreso_neto     = 137196,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Juan Pablo Ramirez';
UPDATE public.reservas r SET
  comision         = 30728,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 94237,
  ingreso_operador = 16630,
  ingreso_neto     = 135867,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Maria Fernanda Muñoz';
UPDATE public.reservas r SET
  comision         = 30514,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93430,
  ingreso_operador = 16488,
  ingreso_neto     = 134918,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-05-10'
  AND r.fecha_salida  = '2026-05-11'
  AND g.nombre ILIKE 'Theresa Noll';
UPDATE public.reservas r SET
  comision         = 38414,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 123119,
  ingreso_operador = 21727,
  ingreso_neto     = 169846,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-16'
  AND g.nombre ILIKE 'Camila Arboleda Mira';
UPDATE public.reservas r SET
  comision         = 36425,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 115647,
  ingreso_operador = 20408,
  ingreso_neto     = 161055,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-17'
  AND g.nombre ILIKE 'Mauricio Palma';
UPDATE public.reservas r SET
  comision         = 38414,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 123119,
  ingreso_operador = 21727,
  ingreso_neto     = 169846,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 202
  AND r.fecha_entrada = '2026-05-17'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Paula Gomez';
UPDATE public.reservas r SET
  comision         = 29519,
  aseo_cobrado     = 0,
  ingreso_hotel    = 99165,
  ingreso_operador = 31315,
  ingreso_neto     = 130480,
  verificacion     = 1,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-04'
  AND r.fecha_salida  = '2026-01-05'
  AND g.nombre ILIKE 'Jorge Recio';
UPDATE public.reservas r SET
  comision         = 29519,
  aseo_cobrado     = 0,
  ingreso_hotel    = 99165,
  ingreso_operador = 31315,
  ingreso_neto     = 130480,
  verificacion     = 1,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-05'
  AND r.fecha_salida  = '2026-01-06'
  AND g.nombre ILIKE 'Tatiana Leon Leon';
UPDATE public.reservas r SET
  comision         = 41501,
  aseo_cobrado     = 0,
  ingreso_hotel    = 139459,
  ingreso_operador = 44040,
  ingreso_neto     = 183499,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-07'
  AND g.nombre ILIKE 'Marcela Garcia';
UPDATE public.reservas r SET
  comision         = 83003,
  aseo_cobrado     = 0,
  ingreso_hotel    = 278918,
  ingreso_operador = 88079,
  ingreso_neto     = 366998,
  verificacion     = NULL,
  check_in_early   = NULL,
  check_out_late   = '$40.000',
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Natalia Loaiza';
UPDATE public.reservas r SET
  comision         = 143723,
  aseo_cobrado     = 0,
  ingreso_hotel    = 482962,
  ingreso_operador = 152514,
  ingreso_neto     = 635477,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Alejandro Niño';
UPDATE public.reservas r SET
  comision         = 31342,
  aseo_cobrado     = 0,
  ingreso_hotel    = 105319,
  ingreso_operador = 33259,
  ingreso_neto     = 138578,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Alexandra Valencia Quintero';
UPDATE public.reservas r SET
  comision         = 31342,
  aseo_cobrado     = 0,
  ingreso_hotel    = 105319,
  ingreso_operador = 33259,
  ingreso_neto     = 138578,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-12'
  AND r.fecha_salida  = '2026-01-13'
  AND g.nombre ILIKE 'Andrey Muñoz';
UPDATE public.reservas r SET
  comision         = 27424,
  aseo_cobrado     = 0,
  ingreso_hotel    = 92155,
  ingreso_operador = 29101,
  ingreso_neto     = 121256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-16'
  AND r.fecha_salida  = '2026-01-17'
  AND g.nombre ILIKE 'Juan David Ospina';
UPDATE public.reservas r SET
  comision         = 27424,
  aseo_cobrado     = 0,
  ingreso_hotel    = 92155,
  ingreso_operador = 29101,
  ingreso_neto     = 121256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-17'
  AND r.fecha_salida  = '2026-01-18'
  AND g.nombre ILIKE 'Sebastian Gutiérrez Vanegas';
UPDATE public.reservas r SET
  comision         = 23506,
  aseo_cobrado     = 0,
  ingreso_hotel    = 78990,
  ingreso_operador = 24944,
  ingreso_neto     = 103934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-20'
  AND r.fecha_salida  = '2026-01-21'
  AND g.nombre ILIKE 'Santiago Gómez Salazar';
UPDATE public.reservas r SET
  comision         = 23506,
  aseo_cobrado     = 0,
  ingreso_hotel    = 78990,
  ingreso_operador = 24944,
  ingreso_neto     = 103934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-21'
  AND r.fecha_salida  = '2026-01-22'
  AND g.nombre ILIKE 'Sergio Nieto Giraldo';
UPDATE public.reservas r SET
  comision         = 23506,
  aseo_cobrado     = 0,
  ingreso_hotel    = 78990,
  ingreso_operador = 24944,
  ingreso_neto     = 103934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-22'
  AND r.fecha_salida  = '2026-01-23'
  AND g.nombre ILIKE 'Maria Fernanda Diaz Amador';
UPDATE public.reservas r SET
  comision         = 23506,
  aseo_cobrado     = 0,
  ingreso_hotel    = 78990,
  ingreso_operador = 24944,
  ingreso_neto     = 103934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-23'
  AND r.fecha_salida  = '2026-01-24'
  AND g.nombre ILIKE 'Melissa Ramos Lemos';
UPDATE public.reservas r SET
  comision         = 28403,
  aseo_cobrado     = 0,
  ingreso_hotel    = 95446,
  ingreso_operador = 30141,
  ingreso_neto     = 125587,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-24'
  AND r.fecha_salida  = '2026-01-25'
  AND g.nombre ILIKE 'Juan Camilo Díaz Castaño';
UPDATE public.reservas r SET
  comision         = 28403,
  aseo_cobrado     = 0,
  ingreso_hotel    = 95446,
  ingreso_operador = 30141,
  ingreso_neto     = 125587,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-25'
  AND r.fecha_salida  = '2026-01-26'
  AND g.nombre ILIKE 'Mateo Rincón';
UPDATE public.reservas r SET
  comision         = 22723,
  aseo_cobrado     = 0,
  ingreso_hotel    = 76357,
  ingreso_operador = 24113,
  ingreso_neto     = 100469,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-28'
  AND r.fecha_salida  = '2026-01-29'
  AND g.nombre ILIKE 'Andee Zeta';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 91200,
  ingreso_operador = 28800,
  ingreso_neto     = 120000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-29'
  AND r.fecha_salida  = '2026-01-30'
  AND g.nombre ILIKE 'Andee Zeta';
UPDATE public.reservas r SET
  comision         = 51126,
  aseo_cobrado     = 0,
  ingreso_hotel    = 171802,
  ingreso_operador = 54253,
  ingreso_neto     = 226056,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-01-30'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Mauricio Suarez Perdomo';
UPDATE public.reservas r SET
  comision         = 25563,
  aseo_cobrado     = 0,
  ingreso_hotel    = 85901,
  ingreso_operador = 27127,
  ingreso_neto     = 113028,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-02-05'
  AND r.fecha_salida  = '2026-02-06'
  AND g.nombre ILIKE 'Angelica Arango Gutiérrez';
UPDATE public.reservas r SET
  comision         = 25563,
  aseo_cobrado     = 0,
  ingreso_hotel    = 85901,
  ingreso_operador = 27127,
  ingreso_neto     = 113028,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-02-06'
  AND r.fecha_salida  = '2026-02-07'
  AND g.nombre ILIKE 'Jorge Ocampo';
UPDATE public.reservas r SET
  comision         = 23669,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 64338,
  ingreso_operador = 20317,
  ingreso_neto     = 104655,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-02-08'
  AND r.fecha_salida  = '2026-02-09'
  AND g.nombre ILIKE 'Lorenza García';
UPDATE public.reservas r SET
  comision         = 25563,
  aseo_cobrado     = 0,
  ingreso_hotel    = 85901,
  ingreso_operador = 27127,
  ingreso_neto     = 113028,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-02-12'
  AND r.fecha_salida  = '2026-02-13'
  AND g.nombre ILIKE 'Manuel F Garizao';
UPDATE public.reservas r SET
  comision         = 56807,
  aseo_cobrado     = 0,
  ingreso_hotel    = 218521,
  ingreso_operador = 32653,
  ingreso_neto     = 251173,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-02-13'
  AND r.fecha_salida  = '2026-02-15'
  AND g.nombre ILIKE 'Sebastian Aguirre';
UPDATE public.reservas r SET
  comision         = 63119,
  aseo_cobrado     = 0,
  ingreso_hotel    = 242801,
  ingreso_operador = 36281,
  ingreso_neto     = 279081,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-02-19'
  AND r.fecha_salida  = '2026-02-21'
  AND g.nombre ILIKE 'Javier Colon';
UPDATE public.reservas r SET
  comision         = 61416,
  aseo_cobrado     = 0,
  ingreso_hotel    = 214511,
  ingreso_operador = 32053,
  ingreso_neto     = 246564,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-02-21'
  AND r.fecha_salida  = '2026-02-23'
  AND g.nombre ILIKE 'Juan Diego Murillo Ospina';
UPDATE public.reservas r SET
  comision         = 69254,
  aseo_cobrado     = 0,
  ingreso_hotel    = 244649,
  ingreso_operador = 36557,
  ingreso_neto     = 281206,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-02-26'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Aled Johnson';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 104400,
  ingreso_operador = 15600,
  ingreso_neto     = 145000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-03'
  AND r.fecha_salida  = '2026-03-04'
  AND g.nombre ILIKE 'Brayan Medicis';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 161763,
  ingreso_operador = 24171,
  ingreso_neto     = 210934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-05'
  AND r.fecha_salida  = '2026-03-07'
  AND g.nombre ILIKE 'Diego Rico';
UPDATE public.reservas r SET
  comision         = 26158,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77063,
  ingreso_operador = 13599,
  ingreso_neto     = 115662,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-08'
  AND r.fecha_salida  = '2026-03-09'
  AND g.nombre ILIKE 'Santiago Prado';
UPDATE public.reservas r SET
  comision         = 129190,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 464277,
  ingreso_operador = 81931,
  ingreso_neto     = 571208,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-09'
  AND r.fecha_salida  = '2026-03-14'
  AND g.nombre ILIKE 'Corinna Spruss';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 158044,
  ingreso_operador = 27890,
  ingreso_neto     = 210934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-14'
  AND r.fecha_salida  = '2026-03-16'
  AND g.nombre ILIKE 'Alejandro Díaz';
UPDATE public.reservas r SET
  comision         = 26159,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77062,
  ingreso_operador = 13599,
  ingreso_neto     = 115661,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-16'
  AND r.fecha_salida  = '2026-03-17'
  AND g.nombre ILIKE 'Jorge Humberto Díaz Uribe';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 98600,
  ingreso_operador = 17400,
  ingreso_neto     = 141000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-17'
  AND r.fecha_salida  = '2026-03-18'
  AND g.nombre ILIKE 'Felipe Charry';
UPDATE public.reservas r SET
  comision         = 49712,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 165581,
  ingreso_operador = 29220,
  ingreso_neto     = 219801,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-21'
  AND g.nombre ILIKE 'Paulina Orozco Viana';
UPDATE public.reservas r SET
  comision         = 57029,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 193083,
  ingreso_operador = 34073,
  ingreso_neto     = 252157,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-21'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Liliana Carolina Cortes Velasquez';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172768,
  ingreso_operador = 30488,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-25'
  AND r.fecha_salida  = '2026-03-27'
  AND g.nombre ILIKE 'Juan Gabriel Alzate Gallego';
UPDATE public.reservas r SET
  comision         = 53166,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 178565,
  ingreso_operador = 31511,
  ingreso_neto     = 235077,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-27'
  AND r.fecha_salida  = '2026-03-29'
  AND g.nombre ILIKE 'Alexandra Castañeda';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-30'
  AND r.fecha_salida  = '2026-03-31'
  AND g.nombre ILIKE 'María De Los Angeles Pavas Marin';
UPDATE public.reservas r SET
  comision         = 53583,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 180130,
  ingreso_operador = 31788,
  ingreso_neto     = 236917,
  verificacion     = 0,
  check_in_early   = 'ASEO PUESTO EN MARZO',
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-03-31'
  AND r.fecha_salida  = '2026-04-02'
  AND g.nombre ILIKE 'Stephanny Agudelo Osorio';
UPDATE public.reservas r SET
  comision         = 59942,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 204030,
  ingreso_operador = 36005,
  ingreso_neto     = 265036,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-04'
  AND g.nombre ILIKE 'Maria Camila Ortiz Tasama';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 127500,
  ingreso_operador = 0,
  ingreso_neto     = 152500,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-04-08'
  AND r.fecha_salida  = '2026-04-09'
  AND g.nombre ILIKE 'Ivan Santiago Rios';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-04-17'
  AND r.fecha_salida  = '2026-04-18'
  AND g.nombre ILIKE 'Jefferson Arteaga';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-04-18'
  AND r.fecha_salida  = '2026-04-19'
  AND g.nombre ILIKE 'Mateo Gomez';
UPDATE public.reservas r SET
  comision         = 77708,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 270800,
  ingreso_operador = 47788,
  ingreso_neto     = 343588,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-04-21'
  AND r.fecha_salida  = '2026-04-24'
  AND g.nombre ILIKE 'Tangarife Julian';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Orlando Marin';
UPDATE public.reservas r SET
  comision         = 76737,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 267149,
  ingreso_operador = 47144,
  ingreso_neto     = 339292,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-04-30'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Yuliana Herrera';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-05-05'
  AND r.fecha_salida  = '2026-05-06'
  AND g.nombre ILIKE 'Juan Camilo Barrera Nieto';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-05-09'
  AND r.fecha_salida  = '2026-05-10'
  AND g.nombre ILIKE 'Jhonatan Rodriguez';
UPDATE public.reservas r SET
  comision         = 56417,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 190780,
  ingreso_operador = 33667,
  ingreso_neto     = 249447,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-05-13'
  AND r.fecha_salida  = '2026-05-15'
  AND g.nombre ILIKE 'Raul Forjan';
UPDATE public.reservas r SET
  comision         = 56417,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 190780,
  ingreso_operador = 33667,
  ingreso_neto     = 249447,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-17'
  AND g.nombre ILIKE 'Andrés López Alzate';
UPDATE public.reservas r SET
  comision         = 30514,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93430,
  ingreso_operador = 16488,
  ingreso_neto     = 134918,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-05-17'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Edward Agudelo Aristizabal';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 114750,
  ingreso_operador = 0,
  ingreso_neto     = 139750,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-23'
  AND g.nombre ILIKE 'vicente lancheros';
UPDATE public.reservas r SET
  comision         = 54474,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 183479,
  ingreso_operador = 32379,
  ingreso_neto     = 240857,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-05-23'
  AND r.fecha_salida  = '2026-05-25'
  AND g.nombre ILIKE 'Isabella Lemos';
UPDATE public.reservas r SET
  comision         = 33106,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103174,
  ingreso_operador = 18207,
  ingreso_neto     = 146381,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-05-25'
  AND r.fecha_salida  = '2026-05-26'
  AND g.nombre ILIKE 'Juan Camilo Barrera Nieto';
UPDATE public.reservas r SET
  comision         = 147508,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 533127,
  ingreso_operador = 94081,
  ingreso_neto     = 652208,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 203
  AND r.fecha_entrada = '2026-05-27'
  AND r.fecha_salida  = '2026-06-01'
  AND g.nombre ILIKE 'mariana giraldo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 99171,
  ingreso_operador = 31317,
  ingreso_neto     = 130488,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-01-05'
  AND r.fecha_salida  = '2026-01-06'
  AND g.nombre ILIKE 'Daniela Andrea Ruiz Guzman';
UPDATE public.reservas r SET
  comision         = 36890,
  aseo_cobrado     = 0,
  ingreso_hotel    = 123964,
  ingreso_operador = 39146,
  ingreso_neto     = 163110,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-07'
  AND g.nombre ILIKE 'Daniela Andrea Ruiz Guzman';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 798000,
  ingreso_operador = 252000,
  ingreso_neto     = 1050000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Wills Danns';
UPDATE public.reservas r SET
  comision         = 41299,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 123580,
  ingreso_operador = 39025,
  ingreso_neto     = 182605,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Daniel Antonio Aristizabal';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 114000,
  ingreso_operador = 36000,
  ingreso_neto     = 150000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-01-12'
  AND r.fecha_salida  = '2026-01-13'
  AND g.nombre ILIKE 'Daniel Diaz';
UPDATE public.reservas r SET
  comision         = 42692,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 128261,
  ingreso_operador = 40503,
  ingreso_neto     = 188764,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-01-24'
  AND r.fecha_salida  = '2026-01-26'
  AND g.nombre ILIKE 'Sivan Tas';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 129200,
  ingreso_operador = 40800,
  ingreso_neto     = 170000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-01-30'
  AND r.fecha_salida  = '2026-01-31'
  AND g.nombre ILIKE 'Daniela Ocampo';
UPDATE public.reservas r SET
  comision         = 58537,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 181505,
  ingreso_operador = 57318,
  ingreso_neto     = 258823,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-02-03'
  AND r.fecha_salida  = '2026-02-05'
  AND g.nombre ILIKE 'Steve Rodriguez';
UPDATE public.reservas r SET
  comision         = 28403,
  aseo_cobrado     = 0,
  ingreso_hotel    = 95446,
  ingreso_operador = 30141,
  ingreso_neto     = 125587,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Nicol Ortiz';
UPDATE public.reservas r SET
  comision         = 23800,
  aseo_cobrado     = 0,
  ingreso_hotel    = 79977,
  ingreso_operador = 25256,
  ingreso_neto     = 105233,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-02-11'
  AND r.fecha_salida  = '2026-02-12'
  AND g.nombre ILIKE 'Alejandro Cardenas Valencia';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 106400,
  ingreso_operador = 33600,
  ingreso_neto     = 140000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-02-12'
  AND r.fecha_salida  = '2026-02-13'
  AND g.nombre ILIKE 'Kelly Alexandra Alzate Marin';
UPDATE public.reservas r SET
  comision         = 32035,
  aseo_cobrado     = 0,
  ingreso_hotel    = 101481,
  ingreso_operador = 15164,
  ingreso_neto     = 116645,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-02-22'
  AND r.fecha_salida  = '2026-02-23'
  AND g.nombre ILIKE 'Julian Herrera';
UPDATE public.reservas r SET
  comision         = 26158,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 78876,
  ingreso_operador = 11786,
  ingreso_neto     = 115662,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-03-01'
  AND r.fecha_salida  = '2026-03-02'
  AND g.nombre ILIKE 'Santiago Marulanda Lòpez';
UPDATE public.reservas r SET
  comision         = 61931,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 281303,
  ingreso_operador = 49642,
  ingreso_neto     = 350945,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-03-11'
  AND r.fecha_salida  = '2026-03-14'
  AND g.nombre ILIKE 'Gerold Mairhofer';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 158044,
  ingreso_operador = 27890,
  ingreso_neto     = 210934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-03-14'
  AND r.fecha_salida  = '2026-03-16'
  AND g.nombre ILIKE 'Laura Viviana Mora Ospina';
UPDATE public.reservas r SET
  comision         = 50891,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 170014,
  ingreso_operador = 30002,
  ingreso_neto     = 225016,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-22'
  AND g.nombre ILIKE 'Laura Valentina Conde Andrade';
UPDATE public.reservas r SET
  comision         = 29167,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 88367,
  ingreso_operador = 15594,
  ingreso_neto     = 128961,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-03-22'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Daniela Panesso Cortes';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 110500,
  ingreso_operador = 19500,
  ingreso_neto     = 155000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-03-25'
  AND r.fecha_salida  = '2026-03-26'
  AND g.nombre ILIKE 'vanessa tabares';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 138377,
  ingreso_operador = 0,
  ingreso_neto     = 163377,
  verificacion     = 24420,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-03-28'
  AND r.fecha_salida  = '2026-03-29'
  AND g.nombre ILIKE 'Daniela Franco';
UPDATE public.reservas r SET
  comision         = 55060,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 185682,
  ingreso_operador = 32767,
  ingreso_neto     = 243450,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Raffa Valencia';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 101682,
  ingreso_operador = 0,
  ingreso_neto     = 126682,
  verificacion     = 17944,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-04-17'
  AND r.fecha_salida  = '2026-04-18'
  AND g.nombre ILIKE 'Jorge Pains';
UPDATE public.reservas r SET
  comision         = 51805,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 173450,
  ingreso_operador = 30609,
  ingreso_neto     = 229059,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-04-18'
  AND r.fecha_salida  = '2026-04-20'
  AND g.nombre ILIKE 'Nikole Somerson';
UPDATE public.reservas r SET
  comision         = 30628,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93859,
  ingreso_operador = 16563,
  ingreso_neto     = 135422,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-04-23'
  AND r.fecha_salida  = '2026-04-24'
  AND g.nombre ILIKE 'JOHAN PACHON';
UPDATE public.reservas r SET
  comision         = 77708,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 270800,
  ingreso_operador = 47788,
  ingreso_neto     = 343588,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-28'
  AND g.nombre ILIKE 'Yoannys Hernández';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-04-30'
  AND r.fecha_salida  = '2026-05-01'
  AND g.nombre ILIKE 'Mateo Echeverria Pelaez';
UPDATE public.reservas r SET
  comision         = 38242,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 122476,
  ingreso_operador = 21613,
  ingreso_neto     = 169090,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'marlon baquero';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 106250,
  ingreso_operador = 0,
  ingreso_neto     = 131250,
  verificacion     = 18750,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-05-07'
  AND r.fecha_salida  = '2026-05-08'
  AND g.nombre ILIKE 'anyeli flores';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 83196,
  ingreso_operador = 0,
  ingreso_neto     = 108196,
  verificacion     = 14682,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-05-09'
  AND r.fecha_salida  = '2026-05-10'
  AND g.nombre ILIKE 'Ana Sofia Leon Londoño';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 0,
  ingreso_operador = 0,
  ingreso_neto     = 25000,
  verificacion     = 122878,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-05-13'
  AND r.fecha_salida  = '2026-05-14'
  AND g.nombre ILIKE 'maria paula marin vitola';
UPDATE public.reservas r SET
  comision         = 74794,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 259848,
  ingreso_operador = 45855,
  ingreso_neto     = 330703,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Juan Felipe Díaz Gómez';
UPDATE public.reservas r SET
  comision         = 33106,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103174,
  ingreso_operador = 18207,
  ingreso_neto     = 146381,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-05-23'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Satizabal Alejo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 0,
  ingreso_operador = 0,
  ingreso_neto     = 25000,
  verificacion     = 122815,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 204
  AND r.fecha_entrada = '2026-05-28'
  AND r.fecha_salida  = '2026-05-29'
  AND g.nombre ILIKE 'martha tarola';
UPDATE public.reservas r SET
  comision         = 100039,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 320966,
  ingreso_operador = 101358,
  ingreso_neto     = 442324,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-01-02'
  AND r.fecha_salida  = '2026-01-04'
  AND g.nombre ILIKE 'Jhonatan Gallego';
UPDATE public.reservas r SET
  comision         = 55925,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 172729,
  ingreso_operador = 54546,
  ingreso_neto     = 247275,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-07'
  AND g.nombre ILIKE 'Yulitza Valencia';
UPDATE public.reservas r SET
  comision         = 65083,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 203502,
  ingreso_operador = 64264,
  ingreso_neto     = 287766,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Emerson Perez';
UPDATE public.reservas r SET
  comision         = 278974,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 922252,
  ingreso_operador = 291238,
  ingreso_neto     = 1233490,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Ricardo Prieto';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 122189,
  ingreso_operador = 0,
  ingreso_neto     = 147189,
  verificacion     = 21563,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-02-28'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Juan Diego Herrera Marin';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 653325,
  ingreso_operador = 0,
  ingreso_neto     = 678325,
  verificacion     = 115293,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-03-05'
  AND r.fecha_salida  = '2026-03-12'
  AND g.nombre ILIKE 'Marian Rodriguez Buitrago';
UPDATE public.reservas r SET
  comision         = 97264,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 344297,
  ingreso_operador = 60758,
  ingreso_neto     = 430056,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-03-12'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Finca Victoria';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 361250,
  ingreso_operador = 63750,
  ingreso_neto     = 450000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'ALEJANDRO DIAZ CAMBIO';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 142681,
  ingreso_operador = 0,
  ingreso_neto     = 167681,
  verificacion     = 25179,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-03-28'
  AND r.fecha_salida  = '2026-03-29'
  AND g.nombre ILIKE 'mateo rojas zaraza';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 380381,
  ingreso_operador = 0,
  ingreso_neto     = 405381,
  verificacion     = 67126,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-03-31'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'diana clavijo';
UPDATE public.reservas r SET
  comision         = 62653,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 214217,
  ingreso_operador = 37803,
  ingreso_neto     = 277019,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-04-23'
  AND r.fecha_salida  = '2026-04-25'
  AND g.nombre ILIKE 'Yunes Elamin';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-04-26'
  AND r.fecha_salida  = '2026-04-27'
  AND g.nombre ILIKE 'Junior Mejia';
UPDATE public.reservas r SET
  comision         = 55280,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 186510,
  ingreso_operador = 32914,
  ingreso_neto     = 244424,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-04-28'
  AND r.fecha_salida  = '2026-04-30'
  AND g.nombre ILIKE 'Narenn Santiago Charry Lombana';
UPDATE public.reservas r SET
  comision         = 33284,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103841,
  ingreso_operador = 18325,
  ingreso_neto     = 147166,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Julian Londoño';
UPDATE public.reservas r SET
  comision         = 33284,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103841,
  ingreso_operador = 18325,
  ingreso_neto     = 147166,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Daniel Vasquez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 476000,
  ingreso_operador = 0,
  ingreso_neto     = 0,
  verificacion     = 84000,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-05-12'
  AND r.fecha_salida  = '2026-05-16'
  AND g.nombre ILIKE 'Jhojan Javier Carrillo Díaz';
UPDATE public.reservas r SET
  comision         = 41228,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 133696,
  ingreso_operador = 23593,
  ingreso_neto     = 182289,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-17'
  AND g.nombre ILIKE 'Santiago Perez';
UPDATE public.reservas r SET
  comision         = 204789,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 748409,
  ingreso_operador = 132072,
  ingreso_neto     = 905481,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 205
  AND r.fecha_entrada = '2026-05-17'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Cade DeNazario Akers';
UPDATE public.reservas r SET
  comision         = 118885,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 384297,
  ingreso_operador = 121357,
  ingreso_neto     = 525654,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-01-04'
  AND r.fecha_salida  = '2026-01-06'
  AND g.nombre ILIKE 'Gabriel Mota Lopez';
UPDATE public.reservas r SET
  comision         = 189075,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 620161,
  ingreso_operador = 195840,
  ingreso_neto     = 836001,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Anthony Ordoñez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 176178,
  ingreso_operador = 26325,
  ingreso_neto     = 202503,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-02-28'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Andrés Felipe Morales';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 361250,
  ingreso_operador = 63750,
  ingreso_neto     = 450000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-03-12'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Natalia Ramirez';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172768,
  ingreso_operador = 30488,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-21'
  AND g.nombre ILIKE 'Kerstinck Sarmiento';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 200659,
  ingreso_operador = 35410,
  ingreso_neto     = 256069,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-03-21'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Tatiana Moreno Pino';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 123250,
  ingreso_operador = 21750,
  ingreso_neto     = 170000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-03-26'
  AND r.fecha_salida  = '2026-03-27'
  AND g.nombre ILIKE 'anyely flores lopez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 231476,
  ingreso_operador = 0,
  ingreso_neto     = 256476,
  verificacion     = 40849,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-03-30'
  AND r.fecha_salida  = '2026-04-01'
  AND g.nombre ILIKE 'david cuartas';
UPDATE public.reservas r SET
  comision         = 126773,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 455199,
  ingreso_operador = 80329,
  ingreso_neto     = 560528,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-05'
  AND g.nombre ILIKE 'Jaime Ivan Garzon Corrales';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 95367,
  ingreso_operador = 16829,
  ingreso_neto     = 137196,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Addy Dayana Luna Drith';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-04-26'
  AND r.fecha_salida  = '2026-04-27'
  AND g.nombre ILIKE 'Juan Camilo Barrera Nieto';
UPDATE public.reservas r SET
  comision         = 28921,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 87444,
  ingreso_operador = 15431,
  ingreso_neto     = 127876,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Sofia Aristizabal';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 0,
  ingreso_operador = 0,
  ingreso_neto     = 25000,
  verificacion     = 125000,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Jaime ramirez';
UPDATE public.reservas r SET
  comision         = 56294,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 190320,
  ingreso_operador = 33586,
  ingreso_neto     = 248906,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-05-04'
  AND r.fecha_salida  = '2026-05-06'
  AND g.nombre ILIKE 'Yunes Elamin';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 127500,
  ingreso_operador = 0,
  ingreso_neto     = 152500,
  verificacion     = 22500,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-05-07'
  AND r.fecha_salida  = '2026-05-08'
  AND g.nombre ILIKE 'anyeli flores';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 0,
  ingreso_operador = 0,
  ingreso_neto     = 25000,
  verificacion     = 122878,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-05-13'
  AND r.fecha_salida  = '2026-05-14'
  AND g.nombre ILIKE 'maria paula marin vitola';
UPDATE public.reservas r SET
  comision         = 72216,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 250159,
  ingreso_operador = 44146,
  ingreso_neto     = 319304,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-17'
  AND g.nombre ILIKE 'Mario Fernando Noreña Chica';
UPDATE public.reservas r SET
  comision         = 99871,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 354093,
  ingreso_operador = 62487,
  ingreso_neto     = 441580,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-05-17'
  AND r.fecha_salida  = '2026-05-20'
  AND g.nombre ILIKE 'Daniela Sanchez';
UPDATE public.reservas r SET
  comision         = 33106,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103174,
  ingreso_operador = 18207,
  ingreso_neto     = 146381,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-05-23'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Oscar Edo Llain Suarez';
UPDATE public.reservas r SET
  comision         = 154276,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 558564,
  ingreso_operador = 98570,
  ingreso_neto     = 682134,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 206
  AND r.fecha_entrada = '2026-05-27'
  AND r.fecha_salida  = '2026-06-01'
  AND g.nombre ILIKE 'Cristian Unigarro';
UPDATE public.reservas r SET
  comision         = 77469,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 245124,
  ingreso_operador = 77407,
  ingreso_neto     = 342531,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-08'
  AND g.nombre ILIKE 'Bryan Alvarez Jimenez';
UPDATE public.reservas r SET
  comision         = 47763,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 145302,
  ingreso_operador = 45885,
  ingreso_neto     = 211187,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Eric Mauricio Castillo sanchez';
UPDATE public.reservas r SET
  comision         = 151249,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 493051,
  ingreso_operador = 155700,
  ingreso_neto     = 668751,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Javier Chavez';
UPDATE public.reservas r SET
  comision         = 22494,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 60388,
  ingreso_operador = 19070,
  ingreso_neto     = 99458,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-01-24'
  AND r.fecha_salida  = '2026-01-25'
  AND g.nombre ILIKE 'Ramon Abreu';
UPDATE public.reservas r SET
  comision         = 22494,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 60388,
  ingreso_operador = 19070,
  ingreso_neto     = 99458,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-01-25'
  AND r.fecha_salida  = '2026-01-26'
  AND g.nombre ILIKE 'Laura Viviana Mora Ospina';
UPDATE public.reservas r SET
  comision         = 25479,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 70419,
  ingreso_operador = 22238,
  ingreso_neto     = 112657,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-01-30'
  AND r.fecha_salida  = '2026-01-31'
  AND g.nombre ILIKE 'Lorenza García';
UPDATE public.reservas r SET
  comision         = 97714,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 313155,
  ingreso_operador = 98891,
  ingreso_neto     = 432046,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-01-31'
  AND r.fecha_salida  = '2026-02-04'
  AND g.nombre ILIKE 'Daniela Morales';
UPDATE public.reservas r SET
  comision         = 43650,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 131479,
  ingreso_operador = 41520,
  ingreso_neto     = 192998,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-02-06'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Ruben Dario Henao Amu';
UPDATE public.reservas r SET
  comision         = 27195,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 87213,
  ingreso_operador = 13032,
  ingreso_neto     = 120245,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-02-13'
  AND r.fecha_salida  = '2026-02-14'
  AND g.nombre ILIKE 'Daniel Steven Castaño Aristizábal';
UPDATE public.reservas r SET
  comision         = 44662,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 150052,
  ingreso_operador = 22422,
  ingreso_neto     = 197474,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-02-14'
  AND r.fecha_salida  = '2026-02-16'
  AND g.nombre ILIKE 'David Gutiérrez Molina';
UPDATE public.reservas r SET
  comision         = 28177,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 64609,
  ingreso_operador = 9654,
  ingreso_neto     = 99263,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-02-21'
  AND r.fecha_salida  = '2026-02-22'
  AND g.nombre ILIKE 'Sebastián Osorio Ospina';
UPDATE public.reservas r SET
  comision         = 26158,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77063,
  ingreso_operador = 13599,
  ingreso_neto     = 115662,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-03-13'
  AND r.fecha_salida  = '2026-03-14'
  AND g.nombre ILIKE 'Juan Carlos Caro';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 106250,
  ingreso_operador = 18750,
  ingreso_neto     = 150000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-03-14'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Gonzales Paula Andrea';
UPDATE public.reservas r SET
  comision         = 26700,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 79097,
  ingreso_operador = 13958,
  ingreso_neto     = 118056,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-20'
  AND g.nombre ILIKE 'Vanessa Marin';
UPDATE public.reservas r SET
  comision         = 26159,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77062,
  ingreso_operador = 13599,
  ingreso_neto     = 115661,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-21'
  AND g.nombre ILIKE 'Jefferson Arteaga';
UPDATE public.reservas r SET
  comision         = 55213,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 186258,
  ingreso_operador = 32869,
  ingreso_neto     = 244127,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-03-21'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Jaqueline Henao Arias';
UPDATE public.reservas r SET
  comision         = 28307,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 85135,
  ingreso_operador = 15024,
  ingreso_neto     = 125159,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-03-29'
  AND r.fecha_salida  = '2026-03-30'
  AND g.nombre ILIKE 'Alejandra Betancour';
UPDATE public.reservas r SET
  comision         = 30076,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 91786,
  ingreso_operador = 16198,
  ingreso_neto     = 132984,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-03-31'
  AND r.fecha_salida  = '2026-04-01'
  AND g.nombre ILIKE 'Gloria Marcela Criollo Sanchez';
UPDATE public.reservas r SET
  comision         = 55060,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 185682,
  ingreso_operador = 32767,
  ingreso_neto     = 243450,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Maira Alejandra Miranda Parra';
UPDATE public.reservas r SET
  comision         = 24713,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 71627,
  ingreso_operador = 0,
  ingreso_neto     = 96627,
  verificacion     = 12640,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-04-11'
  AND r.fecha_salida  = '2026-04-12'
  AND g.nombre ILIKE 'José Antonio Cely';
UPDATE public.reservas r SET
  comision         = 94143,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 332568,
  ingreso_operador = 58689,
  ingreso_neto     = 416257,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-04-15'
  AND r.fecha_salida  = '2026-04-19'
  AND g.nombre ILIKE 'Juan Pablo Duque Gallego';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-04-21'
  AND r.fecha_salida  = '2026-04-22'
  AND g.nombre ILIKE 'Andrea Diaz';
UPDATE public.reservas r SET
  comision         = 30628,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93859,
  ingreso_operador = 16563,
  ingreso_neto     = 135422,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-04-23'
  AND r.fecha_salida  = '2026-04-24'
  AND g.nombre ILIKE 'JOHAN PACHON';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-04-24'
  AND r.fecha_salida  = '2026-04-25'
  AND g.nombre ILIKE 'Omar Scuratti';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Nicolas Duplat Tissot';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-04-30'
  AND r.fecha_salida  = '2026-05-01'
  AND g.nombre ILIKE 'Jeronimo Contreras';
UPDATE public.reservas r SET
  comision         = 45306,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 149025,
  ingreso_operador = 26299,
  ingreso_neto     = 200324,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Nataly Ramirez Arias';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-03'
  AND r.fecha_salida  = '2026-05-04'
  AND g.nombre ILIKE 'Julian Posada';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-07'
  AND r.fecha_salida  = '2026-05-08'
  AND g.nombre ILIKE 'Cristian Mendez Mendez';
UPDATE public.reservas r SET
  comision         = 22653,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 63888,
  ingreso_operador = 11274,
  ingreso_neto     = 100162,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-08'
  AND r.fecha_salida  = '2026-05-09'
  AND g.nombre ILIKE 'Santiago Yarce Gomez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 127500,
  ingreso_operador = 0,
  ingreso_neto     = 152500,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-10'
  AND r.fecha_salida  = '2026-05-11'
  AND g.nombre ILIKE 'federico Garcia';
UPDATE public.reservas r SET
  comision         = 28147,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84535,
  ingreso_operador = 14918,
  ingreso_neto     = 124453,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-12'
  AND r.fecha_salida  = '2026-05-13'
  AND g.nombre ILIKE 'Blanca Montoya';
UPDATE public.reservas r SET
  comision         = 51683,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172990,
  ingreso_operador = 30528,
  ingreso_neto     = 228517,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-13'
  AND r.fecha_salida  = '2026-05-15'
  AND g.nombre ILIKE 'Pryanka Gonzalez Sifontes';
UPDATE public.reservas r SET
  comision         = 67519,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 232505,
  ingreso_operador = 41030,
  ingreso_neto     = 298535,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-16'
  AND g.nombre ILIKE 'Juan Castaneda';
UPDATE public.reservas r SET
  comision         = 49918,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 166355,
  ingreso_operador = 29357,
  ingreso_neto     = 220712,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'John Villegas';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 284708,
  ingreso_operador = 0,
  ingreso_neto     = 309708,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-18'
  AND r.fecha_salida  = '2026-05-21'
  AND g.nombre ILIKE 'Carlos José Rubio ruiz';
UPDATE public.reservas r SET
  comision         = 30501,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93380,
  ingreso_operador = 16479,
  ingreso_neto     = 134859,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-21'
  AND r.fecha_salida  = '2026-05-22'
  AND g.nombre ILIKE 'Valentin Alvarado Benitez';
UPDATE public.reservas r SET
  comision         = 34748,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 109344,
  ingreso_operador = 19296,
  ingreso_neto     = 153640,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Ana Lícia Calheiros';
UPDATE public.reservas r SET
  comision         = 19111,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 50576,
  ingreso_operador = 8925,
  ingreso_neto     = 84502,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-24'
  AND r.fecha_salida  = '2026-05-25'
  AND g.nombre ILIKE 'Ana Lícia Calheiros';
UPDATE public.reservas r SET
  comision         = 30501,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93380,
  ingreso_operador = 16479,
  ingreso_neto     = 134859,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 207
  AND r.fecha_entrada = '2026-05-28'
  AND r.fecha_salida  = '2026-05-29'
  AND g.nombre ILIKE 'Jorge Eliecer Lozano Ospina';
UPDATE public.reservas r SET
  comision         = 111338,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 358934,
  ingreso_operador = 113348,
  ingreso_neto     = 492281,
  verificacion     = NULL,
  check_in_early   = NULL,
  check_out_late   = '$300.000',
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-01-02'
  AND r.fecha_salida  = '2026-01-04'
  AND g.nombre ILIKE 'Damian Baumann';
UPDATE public.reservas r SET
  comision         = 105343,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 338792,
  ingreso_operador = 106987,
  ingreso_neto     = 465779,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-10'
  AND g.nombre ILIKE 'Marvin Ramos';
UPDATE public.reservas r SET
  comision         = 195918,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 643156,
  ingreso_operador = 203102,
  ingreso_neto     = 866258,
  verificacion     = NULL,
  check_in_early   = NULL,
  check_out_late   = '$40.000',
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-01-10'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Sofia Moreno';
UPDATE public.reservas r SET
  comision         = 70682,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 222317,
  ingreso_operador = 70205,
  ingreso_neto     = 312522,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-01-21'
  AND r.fecha_salida  = '2026-01-23'
  AND g.nombre ILIKE 'Laura Rodriguez';
UPDATE public.reservas r SET
  comision         = 51328,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 180046,
  ingreso_operador = 26903,
  ingreso_neto     = 226950,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-02-13'
  AND r.fecha_salida  = '2026-02-15'
  AND g.nombre ILIKE 'Sophie Marrugo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 122189,
  ingreso_operador = 21563,
  ingreso_neto     = 168752,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-03-07'
  AND r.fecha_salida  = '2026-03-08'
  AND g.nombre ILIKE 'Sebastián Osorio Ospina';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 504149,
  ingreso_operador = 0,
  ingreso_neto     = 529149,
  verificacion     = 88967,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-03-12'
  AND r.fecha_salida  = '2026-03-16'
  AND g.nombre ILIKE 'Rafael Palacio Gomez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 105796,
  ingreso_operador = 0,
  ingreso_neto     = 130796,
  verificacion     = 18670,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-20'
  AND g.nombre ILIKE 'D Johan';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-21'
  AND g.nombre ILIKE 'Teresa Del Mar Angulo Medina';
UPDATE public.reservas r SET
  comision         = 60053,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 204448,
  ingreso_operador = 36079,
  ingreso_neto     = 265528,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-03-21'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Alejandro Acevedo Arcila';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 114750,
  ingreso_operador = 0,
  ingreso_neto     = 0,
  verificacion     = 20250,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-03-28'
  AND r.fecha_salida  = '2026-03-29'
  AND g.nombre ILIKE 'Gustavo Gonzales';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 131750,
  ingreso_operador = 0,
  ingreso_neto     = 156750,
  verificacion     = 23250,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-02'
  AND g.nombre ILIKE 'Jasson Cardona';
UPDATE public.reservas r SET
  comision         = 76251,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 265323,
  ingreso_operador = 46822,
  ingreso_neto     = 337145,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-04'
  AND g.nombre ILIKE 'sophi marrugo';
UPDATE public.reservas r SET
  comision         = 28921,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 87444,
  ingreso_operador = 15431,
  ingreso_neto     = 127876,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Sofia Aristizabal';
UPDATE public.reservas r SET
  comision         = 30728,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 94237,
  ingreso_operador = 16630,
  ingreso_neto     = 135867,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Claudia Fernanda Ipaz Sabogal';
UPDATE public.reservas r SET
  comision         = 72216,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 250159,
  ingreso_operador = 44146,
  ingreso_neto     = 319304,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 301
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Jhoan Sebastian Cruz Barbosa';
UPDATE public.reservas r SET
  comision         = 123038,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 398253,
  ingreso_operador = 125764,
  ingreso_neto     = 544018,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-01-03'
  AND r.fecha_salida  = '2026-01-05'
  AND g.nombre ILIKE 'John Burgos';
UPDATE public.reservas r SET
  comision         = 101197,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 324857,
  ingreso_operador = 102586,
  ingreso_neto     = 447443,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Daniel Avellaneda';
UPDATE public.reservas r SET
  comision         = 169452,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 554219,
  ingreso_operador = 175017,
  ingreso_neto     = 749236,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Santiago Segura';
UPDATE public.reservas r SET
  comision         = 19207,
  aseo_cobrado     = 0,
  ingreso_hotel    = 82717,
  ingreso_operador = 26121,
  ingreso_neto     = 108838,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-01-22'
  AND r.fecha_salida  = '2026-01-23'
  AND g.nombre ILIKE 'Camilo Andres Russi Soto';
UPDATE public.reservas r SET
  comision         = 48978,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 149383,
  ingreso_operador = 47174,
  ingreso_neto     = 216556,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-02-06'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Will Mendoza Reinel';
UPDATE public.reservas r SET
  comision         = 258764,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 854340,
  ingreso_operador = 269791,
  ingreso_neto     = 1144131,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-02-10'
  AND r.fecha_salida  = '2026-02-20'
  AND g.nombre ILIKE 'Nacho Villegas';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 104400,
  ingreso_operador = 15600,
  ingreso_neto     = 120000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-02-20'
  AND r.fecha_salida  = '2026-02-21'
  AND g.nombre ILIKE 'Nacho Villegas';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172768,
  ingreso_operador = 30488,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-03-07'
  AND r.fecha_salida  = '2026-03-09'
  AND g.nombre ILIKE 'Lissett Ramos';
UPDATE public.reservas r SET
  comision         = 100217,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 355394,
  ingreso_operador = 62717,
  ingreso_neto     = 443111,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-03-13'
  AND r.fecha_salida  = '2026-03-17'
  AND g.nombre ILIKE 'Knut Morten Powilleit';
UPDATE public.reservas r SET
  comision         = 56935,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 192730,
  ingreso_operador = 34011,
  ingreso_neto     = 251742,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-22'
  AND g.nombre ILIKE 'Julio Enrique Barco Franco';
UPDATE public.reservas r SET
  comision         = 30965,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 95127,
  ingreso_operador = 16787,
  ingreso_neto     = 136914,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-03-22'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Paola Perdomo';
UPDATE public.reservas r SET
  comision         = 75414,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 262178,
  ingreso_operador = 46267,
  ingreso_neto     = 333445,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-03-26'
  AND r.fecha_salida  = '2026-03-29'
  AND g.nombre ILIKE 'Daniel Donado';
UPDATE public.reservas r SET
  comision         = 97845,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 346480,
  ingreso_operador = 61143,
  ingreso_neto     = 432623,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-04'
  AND g.nombre ILIKE 'Jose G Castano';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 101707,
  ingreso_operador = 0,
  ingreso_neto     = 126707,
  verificacion     = 17948,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-04-05'
  AND r.fecha_salida  = '2026-04-06'
  AND g.nombre ILIKE 'Erfanipur Asian pasha';
UPDATE public.reservas r SET
  comision         = 28921,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 87444,
  ingreso_operador = 15431,
  ingreso_neto     = 127876,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Sofia Aristizabal';
UPDATE public.reservas r SET
  comision         = 106018,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 377198,
  ingreso_operador = 66564,
  ingreso_neto     = 468762,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 302
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Pryanka Gonzalez Sifontes';
UPDATE public.reservas r SET
  comision         = 29512,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 83971,
  ingreso_operador = 26517,
  ingreso_neto     = 130488,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-04'
  AND r.fecha_salida  = '2026-01-05'
  AND g.nombre ILIKE 'Lady Laura Prieto Esguerra';
UPDATE public.reservas r SET
  comision         = 33201,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 96367,
  ingreso_operador = 30432,
  ingreso_neto     = 146799,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-07'
  AND g.nombre ILIKE 'Esteban Tobon';
UPDATE public.reservas r SET
  comision         = 41501,
  aseo_cobrado     = 0,
  ingreso_hotel    = 139459,
  ingreso_operador = 44040,
  ingreso_neto     = 183499,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-08'
  AND g.nombre ILIKE 'Daniela Loaiza';
UPDATE public.reservas r SET
  comision         = 41501,
  aseo_cobrado     = 0,
  ingreso_hotel    = 139459,
  ingreso_operador = 44040,
  ingreso_neto     = 183499,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Beatriz Helena Montoya Ruiz';
UPDATE public.reservas r SET
  comision         = 152577,
  aseo_cobrado     = 0,
  ingreso_hotel    = 512713,
  ingreso_operador = 161910,
  ingreso_neto     = 674623,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Juan Manuel Marmolejo';
UPDATE public.reservas r SET
  comision         = 22200,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 80408,
  ingreso_operador = 25392,
  ingreso_neto     = 125800,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Laura Lorena Villar Contreras';
UPDATE public.reservas r SET
  comision         = 31342,
  aseo_cobrado     = 0,
  ingreso_hotel    = 105319,
  ingreso_operador = 33259,
  ingreso_neto     = 138578,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-12'
  AND r.fecha_salida  = '2026-01-13'
  AND g.nombre ILIKE 'Jose Alexander Giraldo Hurtado';
UPDATE public.reservas r SET
  comision         = 47013,
  aseo_cobrado     = 0,
  ingreso_hotel    = 157979,
  ingreso_operador = 49888,
  ingreso_neto     = 207867,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-16'
  AND r.fecha_salida  = '2026-01-18'
  AND g.nombre ILIKE 'Paola Castaño Leiva';
UPDATE public.reservas r SET
  comision         = 50147,
  aseo_cobrado     = 0,
  ingreso_hotel    = 168511,
  ingreso_operador = 53214,
  ingreso_neto     = 221725,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-19'
  AND r.fecha_salida  = '2026-01-21'
  AND g.nombre ILIKE 'Angelica Gallego';
UPDATE public.reservas r SET
  comision         = 26445,
  aseo_cobrado     = 0,
  ingreso_hotel    = 88863,
  ingreso_operador = 28062,
  ingreso_neto     = 116925,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-22'
  AND r.fecha_salida  = '2026-01-23'
  AND g.nombre ILIKE 'Fabian Naranjo';
UPDATE public.reservas r SET
  comision         = 47600,
  aseo_cobrado     = 0,
  ingreso_hotel    = 159954,
  ingreso_operador = 50512,
  ingreso_neto     = 210466,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-24'
  AND r.fecha_salida  = '2026-01-26'
  AND g.nombre ILIKE 'Juliana Toro';
UPDATE public.reservas r SET
  comision         = 21420,
  aseo_cobrado     = 0,
  ingreso_hotel    = 71979,
  ingreso_operador = 22730,
  ingreso_neto     = 94709,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-27'
  AND r.fecha_salida  = '2026-01-28'
  AND g.nombre ILIKE 'Angel David Gallego Pelaez';
UPDATE public.reservas r SET
  comision         = 26445,
  aseo_cobrado     = 0,
  ingreso_hotel    = 88863,
  ingreso_operador = 28062,
  ingreso_neto     = 116925,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-01-31'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Steven Escobar Castaño';
UPDATE public.reservas r SET
  comision         = 26445,
  aseo_cobrado     = 0,
  ingreso_hotel    = 88863,
  ingreso_operador = 28062,
  ingreso_neto     = 116925,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-02'
  AND r.fecha_salida  = '2026-02-03'
  AND g.nombre ILIKE 'Joan Sebastian Salazar Hernandez';
UPDATE public.reservas r SET
  comision         = 26445,
  aseo_cobrado     = 0,
  ingreso_hotel    = 88863,
  ingreso_operador = 28062,
  ingreso_neto     = 116925,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-04'
  AND r.fecha_salida  = '2026-02-05'
  AND g.nombre ILIKE 'Carlos Gomez';
UPDATE public.reservas r SET
  comision         = 26445,
  aseo_cobrado     = 0,
  ingreso_hotel    = 88863,
  ingreso_operador = 28062,
  ingreso_neto     = 116925,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-06'
  AND r.fecha_salida  = '2026-02-07'
  AND g.nombre ILIKE 'Ximena Gómez';
UPDATE public.reservas r SET
  comision         = 26445,
  aseo_cobrado     = 0,
  ingreso_hotel    = 88863,
  ingreso_operador = 28062,
  ingreso_neto     = 116925,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Steven Escobar Castaño';
UPDATE public.reservas r SET
  comision         = 23800,
  aseo_cobrado     = 0,
  ingreso_hotel    = 79977,
  ingreso_operador = 25256,
  ingreso_neto     = 105233,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-10'
  AND r.fecha_salida  = '2026-02-11'
  AND g.nombre ILIKE 'Juan Andres Zuluaga Zuñiga';
UPDATE public.reservas r SET
  comision         = 52889,
  aseo_cobrado     = 0,
  ingreso_hotel    = 203450,
  ingreso_operador = 30401,
  ingreso_neto     = 233851,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-13'
  AND r.fecha_salida  = '2026-02-15'
  AND g.nombre ILIKE 'Laura Riaño';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 115000,
  ingreso_operador = 0,
  ingreso_neto     = 140000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-18'
  AND r.fecha_salida  = '2026-02-19'
  AND g.nombre ILIKE 'Daniela Lopez Salgado';
UPDATE public.reservas r SET
  comision         = 31055,
  aseo_cobrado     = 0,
  ingreso_hotel    = 97714,
  ingreso_operador = 14601,
  ingreso_neto     = 112315,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-19'
  AND r.fecha_salida  = '2026-02-20'
  AND g.nombre ILIKE 'Sebastián Pérez Velásquez';
UPDATE public.reservas r SET
  comision         = 31055,
  aseo_cobrado     = 0,
  ingreso_hotel    = 97714,
  ingreso_operador = 14601,
  ingreso_neto     = 112315,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-20'
  AND r.fecha_salida  = '2026-02-21'
  AND g.nombre ILIKE 'Ana María González Durán';
UPDATE public.reservas r SET
  comision         = 52889,
  aseo_cobrado     = 0,
  ingreso_hotel    = 203450,
  ingreso_operador = 30401,
  ingreso_neto     = 233851,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-21'
  AND r.fecha_salida  = '2026-02-23'
  AND g.nombre ILIKE 'Juan Esteban Sanchez Rios';
UPDATE public.reservas r SET
  comision         = 26158,
  aseo_cobrado     = 0,
  ingreso_hotel    = 78876,
  ingreso_operador = 11786,
  ingreso_neto     = 90662,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-02-23'
  AND r.fecha_salida  = '2026-02-24'
  AND g.nombre ILIKE 'Isabela Castaño Cardenas';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 114750,
  ingreso_operador = 20250,
  ingreso_neto     = 160000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-03-07'
  AND r.fecha_salida  = '2026-03-08'
  AND g.nombre ILIKE 'Xiomara Cardona';
UPDATE public.reservas r SET
  comision         = 26158,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77063,
  ingreso_operador = 13599,
  ingreso_neto     = 115662,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-03-09'
  AND r.fecha_salida  = '2026-03-10'
  AND g.nombre ILIKE 'Daniel Morales';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93502,
  ingreso_operador = 0,
  ingreso_neto     = 118502,
  verificacion     = 16500,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-03-13'
  AND r.fecha_salida  = '2026-03-14'
  AND g.nombre ILIKE 'Estefania Parra';
UPDATE public.reservas r SET
  comision         = 90801,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 320007,
  ingreso_operador = 56472,
  ingreso_neto     = 401479,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-03-14'
  AND r.fecha_salida  = '2026-03-18'
  AND g.nombre ILIKE 'Gustavo Perez';
UPDATE public.reservas r SET
  comision         = 26700,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 79097,
  ingreso_operador = 13958,
  ingreso_neto     = 118056,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-20'
  AND g.nombre ILIKE 'Jhoan Martinez';
UPDATE public.reservas r SET
  comision         = 79622,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 277994,
  ingreso_operador = 49058,
  ingreso_neto     = 352052,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Jorge Isaac Mosquera Murillo';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-03-29'
  AND r.fecha_salida  = '2026-03-30'
  AND g.nombre ILIKE 'Jorge Eduardo Montes Escobar';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-03-31'
  AND r.fecha_salida  = '2026-04-01'
  AND g.nombre ILIKE 'Diego Arteaga';
UPDATE public.reservas r SET
  comision         = 30076,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 91786,
  ingreso_operador = 16198,
  ingreso_neto     = 132984,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Liceth Valencia';
UPDATE public.reservas r SET
  comision         = 58447,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 198410,
  ingreso_operador = 35013,
  ingreso_neto     = 258423,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-04-03'
  AND r.fecha_salida  = '2026-04-05'
  AND g.nombre ILIKE 'Paola Chaparro Castillo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 214946,
  ingreso_operador = 0,
  ingreso_neto     = 239946,
  verificacion     = 37932,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-04-18'
  AND r.fecha_salida  = '2026-04-20'
  AND g.nombre ILIKE 'Yeni Paola Gaitán';
UPDATE public.reservas r SET
  comision         = 77708,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 270800,
  ingreso_operador = 47788,
  ingreso_neto     = 343588,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-04-24'
  AND r.fecha_salida  = '2026-04-27'
  AND g.nombre ILIKE 'Luisa Fernanda Silva Núñez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 83196,
  ingreso_operador = 0,
  ingreso_neto     = 108196,
  verificacion     = 14682,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-04-29'
  AND r.fecha_salida  = '2026-04-30'
  AND g.nombre ILIKE 'Jhon edward piedrahita Quiceno';
UPDATE public.reservas r SET
  comision         = 51805,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 173450,
  ingreso_operador = 30609,
  ingreso_neto     = 229059,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-04-30'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Nicolas Mauricio Zutta Arellano';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Carolina Alzate';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-05-06'
  AND r.fecha_salida  = '2026-05-07'
  AND g.nombre ILIKE 'Jefferson Arteaga';
UPDATE public.reservas r SET
  comision         = 180049,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 655427,
  ingreso_operador = 115664,
  ingreso_neto     = 796091,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-05-10'
  AND r.fecha_salida  = '2026-05-20'
  AND g.nombre ILIKE 'Eliana Carolina Diaz Moreno';
UPDATE public.reservas r SET
  comision         = 61602,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 210267,
  ingreso_operador = 37106,
  ingreso_neto     = 272372,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Juan Ortiz';
UPDATE public.reservas r SET
  comision         = 33106,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103174,
  ingreso_operador = 18207,
  ingreso_neto     = 146381,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 303
  AND r.fecha_entrada = '2026-05-26'
  AND r.fecha_salida  = '2026-05-27'
  AND g.nombre ILIKE 'Juan Camilo Barrera Nieto';
UPDATE public.reservas r SET
  comision         = 40579,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 121160,
  ingreso_operador = 38261,
  ingreso_neto     = 179421,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-07'
  AND g.nombre ILIKE 'Antonio de la Cruz';
UPDATE public.reservas r SET
  comision         = 40579,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 121160,
  ingreso_operador = 38261,
  ingreso_neto     = 179421,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-08'
  AND g.nombre ILIKE 'Kidinson Vega';
UPDATE public.reservas r SET
  comision         = 45190,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 136655,
  ingreso_operador = 43154,
  ingreso_neto     = 199810,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Juan Alvear';
UPDATE public.reservas r SET
  comision         = 109932,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 354212,
  ingreso_operador = 111856,
  ingreso_neto     = 486068,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-10'
  AND g.nombre ILIKE 'Valentina Gonzales';
UPDATE public.reservas r SET
  comision         = 97714,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 313155,
  ingreso_operador = 98891,
  ingreso_neto     = 432046,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-10'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Adrian Estrada';
UPDATE public.reservas r SET
  comision         = 66372,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 207835,
  ingreso_operador = 65632,
  ingreso_neto     = 293468,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-13'
  AND g.nombre ILIKE 'Adrian Estrada';
UPDATE public.reservas r SET
  comision         = 27195,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 76186,
  ingreso_operador = 24059,
  ingreso_neto     = 120245,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-16'
  AND r.fecha_salida  = '2026-01-17'
  AND g.nombre ILIKE 'Sharly Rengifo Fernandez';
UPDATE public.reservas r SET
  comision         = 27195,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 76186,
  ingreso_operador = 24059,
  ingreso_neto     = 120245,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-17'
  AND r.fecha_salida  = '2026-01-18'
  AND g.nombre ILIKE 'David Steven Ochoa Muñoz';
UPDATE public.reservas r SET
  comision         = 27548,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 77370,
  ingreso_operador = 24433,
  ingreso_neto     = 121803,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-24'
  AND r.fecha_salida  = '2026-01-25'
  AND g.nombre ILIKE 'Sebastian Antonio';
UPDATE public.reservas r SET
  comision         = 31113,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 89351,
  ingreso_operador = 28216,
  ingreso_neto     = 137567,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-01-31'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Felipe Campuzano';
UPDATE public.reservas r SET
  comision         = 27822,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 78292,
  ingreso_operador = 24724,
  ingreso_neto     = 123016,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-02-06'
  AND r.fecha_salida  = '2026-02-07'
  AND g.nombre ILIKE 'Derek Matias Botero Ocampo';
UPDATE public.reservas r SET
  comision         = 69507,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 218367,
  ingreso_operador = 68958,
  ingreso_neto     = 307325,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-02-08'
  AND r.fecha_salida  = '2026-02-11'
  AND g.nombre ILIKE 'Sindry Paola Camargo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 196080,
  ingreso_operador = 61920,
  ingreso_neto     = 258000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-02-11'
  AND r.fecha_salida  = '2026-02-13'
  AND g.nombre ILIKE 'Sindry Paola Camargo';
UPDATE public.reservas r SET
  comision         = 28958,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 93995,
  ingreso_operador = 14045,
  ingreso_neto     = 128040,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-02-13'
  AND r.fecha_salida  = '2026-02-14'
  AND g.nombre ILIKE 'Sergio Ochoa Orozco';
UPDATE public.reservas r SET
  comision         = 24682,
  aseo_cobrado     = 0,
  ingreso_hotel    = 94943,
  ingreso_operador = 14187,
  ingreso_neto     = 109130,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-02-15'
  AND r.fecha_salida  = '2026-02-16'
  AND g.nombre ILIKE 'Heidy Stefania Galviz Montoya';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 137460,
  ingreso_operador = 20540,
  ingreso_neto     = 158000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-02-18'
  AND r.fecha_salida  = '2026-02-19'
  AND g.nombre ILIKE 'Camila Lopez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 140000,
  ingreso_operador = 0,
  ingreso_neto     = 140000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-02-21'
  AND r.fecha_salida  = '2026-02-22'
  AND g.nombre ILIKE 'Laura Ines Garavito Correa';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 0,
  ingreso_hotel    = 161763,
  ingreso_operador = 24171,
  ingreso_neto     = 185934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Omar Eduardo Cifuentes Rubiano';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 380300,
  ingreso_operador = 49439,
  ingreso_neto     = 454739,
  verificacion     = NULL,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-03-04'
  AND r.fecha_salida  = '2026-03-07'
  AND g.nombre ILIKE 'Dora Marcela Uribe Usuga';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 158044,
  ingreso_operador = 27890,
  ingreso_neto     = 210934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-03-12'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Ernesto Rojas';
UPDATE public.reservas r SET
  comision         = 26159,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77062,
  ingreso_operador = 13599,
  ingreso_neto     = 115661,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-03-17'
  AND r.fecha_salida  = '2026-03-18'
  AND g.nombre ILIKE 'Ben Siegler';
UPDATE public.reservas r SET
  comision         = 121094,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 433856,
  ingreso_operador = 76563,
  ingreso_neto     = 535419,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-03-18'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Esteban Ocampo';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-03-31'
  AND r.fecha_salida  = '2026-04-01'
  AND g.nombre ILIKE 'Sofia Quintero Valencia';
UPDATE public.reservas r SET
  comision         = 30076,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 91786,
  ingreso_operador = 16198,
  ingreso_neto     = 132984,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Juan David Valencia Salazar';
UPDATE public.reservas r SET
  comision         = 58998,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 200483,
  ingreso_operador = 35379,
  ingreso_neto     = 260862,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-04-03'
  AND r.fecha_salida  = '2026-04-05'
  AND g.nombre ILIKE 'Mario German Alvarez Pulgarin';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-04-17'
  AND r.fecha_salida  = '2026-04-18'
  AND g.nombre ILIKE 'Jorge Eduardo Montes Escobar';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-04-18'
  AND r.fecha_salida  = '2026-04-19'
  AND g.nombre ILIKE 'Luis Manuel Gallego';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-27'
  AND g.nombre ILIKE 'Sergio Alonso Mariño Duque';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 110500,
  ingreso_operador = 0,
  ingreso_neto     = 135500,
  verificacion     = 19500,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-04-29'
  AND r.fecha_salida  = '2026-04-30'
  AND g.nombre ILIKE 'Carlos Marulanda toro';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 83196,
  ingreso_operador = 14682,
  ingreso_neto     = 122878,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-04-30'
  AND r.fecha_salida  = '2026-05-01'
  AND g.nombre ILIKE 'Sara Morales';
UPDATE public.reservas r SET
  comision         = 31326,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 96483,
  ingreso_operador = 17026,
  ingreso_neto     = 138510,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Joshua Elrich';
UPDATE public.reservas r SET
  comision         = 22653,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 63888,
  ingreso_operador = 11274,
  ingreso_neto     = 100162,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Xiomara Valeria Marin Salazar';
UPDATE public.reservas r SET
  comision         = 103611,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 368150,
  ingreso_operador = 64968,
  ingreso_neto     = 458117,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-05-10'
  AND r.fecha_salida  = '2026-05-14'
  AND g.nombre ILIKE 'Margot Cristina Gil Sanchez';
UPDATE public.reservas r SET
  comision         = 33105,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103169,
  ingreso_operador = 18206,
  ingreso_neto     = 146375,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-16'
  AND g.nombre ILIKE 'John Osorio Zuluaga';
UPDATE public.reservas r SET
  comision         = 29542,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 89779,
  ingreso_operador = 15843,
  ingreso_neto     = 130623,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-17'
  AND g.nombre ILIKE 'Valentina Ocampo Parra';
UPDATE public.reservas r SET
  comision         = 29542,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 89779,
  ingreso_operador = 15843,
  ingreso_neto     = 130623,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-05-17'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Martha López Peñate';
UPDATE public.reservas r SET
  comision         = 61602,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 210267,
  ingreso_operador = 37106,
  ingreso_neto     = 272372,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Juan Esteban Rivera Gonzalez';
UPDATE public.reservas r SET
  comision         = 33106,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103174,
  ingreso_operador = 18207,
  ingreso_neto     = 146381,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 304
  AND r.fecha_entrada = '2026-05-24'
  AND r.fecha_salida  = '2026-05-25'
  AND g.nombre ILIKE 'Esteban Cardona';
UPDATE public.reservas r SET
  comision         = 184688,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 605416,
  ingreso_operador = 191184,
  ingreso_neto     = 816600,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-01-02'
  AND r.fecha_salida  = '2026-01-05'
  AND g.nombre ILIKE 'Kelly Jhoana Vidal';
UPDATE public.reservas r SET
  comision         = 62455,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 194670,
  ingreso_operador = 61475,
  ingreso_neto     = 276145,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-07'
  AND g.nombre ILIKE 'Miguel Angel Jurado';
UPDATE public.reservas r SET
  comision         = 331210,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 1097785,
  ingreso_operador = 346669,
  ingreso_neto     = 1464454,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Roberto Martin';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 510000,
  ingreso_operador = 0,
  ingreso_neto     = 510000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-01-28'
  AND r.fecha_salida  = '2026-01-31'
  AND g.nombre ILIKE 'Gustavo Adolfo Gonzalez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 170000,
  ingreso_operador = 0,
  ingreso_neto     = 170000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-02-05'
  AND r.fecha_salida  = '2026-02-06'
  AND g.nombre ILIKE 'Gustavo Adolfo Gonzalez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 170000,
  ingreso_operador = 0,
  ingreso_neto     = 170000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-02-06'
  AND r.fecha_salida  = '2026-02-07'
  AND g.nombre ILIKE 'Gustavo Adolfo Gonzalez';
UPDATE public.reservas r SET
  comision         = 38513,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 130750,
  ingreso_operador = 19537,
  ingreso_neto     = 170287,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-02-15'
  AND r.fecha_salida  = '2026-02-16'
  AND g.nombre ILIKE 'Lina Arango Rosecreekpark';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 86411,
  ingreso_operador = 12912,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-02-28'
  AND g.nombre ILIKE 'Cristhian Sanchez';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 176833,
  ingreso_operador = 26423,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-02-28'
  AND r.fecha_salida  = '2026-03-02'
  AND g.nombre ILIKE 'Oscar Villarreal Ballesteros';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 86411,
  ingreso_operador = 12912,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-03-02'
  AND r.fecha_salida  = '2026-03-03'
  AND g.nombre ILIKE 'César García';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 86411,
  ingreso_operador = 12912,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-03-06'
  AND r.fecha_salida  = '2026-03-07'
  AND g.nombre ILIKE 'Bryan Campuzano';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172768,
  ingreso_operador = 30488,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-03-11'
  AND r.fecha_salida  = '2026-03-13'
  AND g.nombre ILIKE 'Diana Cristina Benavides Escobar';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172768,
  ingreso_operador = 30488,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-03-13'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Yessica Juliana Gonzalez Giraldo';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-20'
  AND g.nombre ILIKE 'Juan David Giraldo Quintero';
UPDATE public.reservas r SET
  comision         = 83061,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 290919,
  ingreso_operador = 51339,
  ingreso_neto     = 367258,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Juan Gutierrez';
UPDATE public.reservas r SET
  comision         = 172278,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 626221,
  ingreso_operador = 110510,
  ingreso_neto     = 761731,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-03-27'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Lars Luomanen';
UPDATE public.reservas r SET
  comision         = 70607,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 244114,
  ingreso_operador = 43079,
  ingreso_neto     = 312193,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-04-26'
  AND r.fecha_salida  = '2026-04-29'
  AND g.nombre ILIKE 'Michael Carucci';
UPDATE public.reservas r SET
  comision         = 33284,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103841,
  ingreso_operador = 18325,
  ingreso_neto     = 147166,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Jeronimo Contreras';
UPDATE public.reservas r SET
  comision         = 33284,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 103841,
  ingreso_operador = 18325,
  ingreso_neto     = 147166,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Jess Tapia Rodriguez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 105065,
  ingreso_operador = 18541,
  ingreso_neto     = 148606,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-05-08'
  AND r.fecha_salida  = '2026-05-09'
  AND g.nombre ILIKE 'eduardo alzate';
UPDATE public.reservas r SET
  comision         = 107999,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 384643,
  ingreso_operador = 67878,
  ingreso_neto     = 477521,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Jairo Andres Romero Herrera';
UPDATE public.reservas r SET
  comision         = 35938,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 113814,
  ingreso_operador = 20085,
  ingreso_neto     = 158898,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-05-19'
  AND r.fecha_salida  = '2026-05-20'
  AND g.nombre ILIKE 'Ramirez Juan D';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 492150,
  ingreso_operador = 0,
  ingreso_neto     = 517150,
  verificacion     = 86850,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 305
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-25'
  AND g.nombre ILIKE 'jose Vargas';
UPDATE public.reservas r SET
  comision         = 107994,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 347700,
  ingreso_operador = 109800,
  ingreso_neto     = 477500,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-01-02'
  AND r.fecha_salida  = '2026-01-04'
  AND g.nombre ILIKE 'Ale Hernandez Montiel';
UPDATE public.reservas r SET
  comision         = 45269,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 136920,
  ingreso_operador = 43238,
  ingreso_neto     = 200158,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Cristina Blanco';
UPDATE public.reservas r SET
  comision         = 304570,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 1008263,
  ingreso_operador = 318399,
  ingreso_neto     = 1346662,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Andres Carrillo';
UPDATE public.reservas r SET
  comision         = 23748,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 64600,
  ingreso_operador = 20400,
  ingreso_neto     = 105000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-02-12'
  AND r.fecha_salida  = '2026-02-13'
  AND g.nombre ILIKE 'Juan David Giraldo Quintero';
UPDATE public.reservas r SET
  comision         = 46400,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 156739,
  ingreso_operador = 23421,
  ingreso_neto     = 205160,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Manuel Henao';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-03-16'
  AND r.fecha_salida  = '2026-03-17'
  AND g.nombre ILIKE 'Daniela Serna Gómez';
UPDATE public.reservas r SET
  comision         = 115482,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 412764,
  ingreso_operador = 72841,
  ingreso_neto     = 510605,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-03-18'
  AND r.fecha_salida  = '2026-03-22'
  AND g.nombre ILIKE 'Andrea Tatiana Campos Del Cairo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 191250,
  ingreso_operador = 33750,
  ingreso_neto     = 250000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-03-22'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Mauricio Andrés Fernández Guevara';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 144500,
  ingreso_operador = 0,
  ingreso_neto     = 169500,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-03-27'
  AND r.fecha_salida  = '2026-03-28'
  AND g.nombre ILIKE 'carlos marulanda';
UPDATE public.reservas r SET
  comision         = 70421,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 243412,
  ingreso_operador = 42955,
  ingreso_neto     = 311367,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-04'
  AND g.nombre ILIKE 'Luisa Corrales';
UPDATE public.reservas r SET
  comision         = 57842,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 196137,
  ingreso_operador = 34612,
  ingreso_neto     = 255750,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-04-27'
  AND r.fecha_salida  = '2026-04-29'
  AND g.nombre ILIKE 'Liliana Estrada';
UPDATE public.reservas r SET
  comision         = 28921,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 87444,
  ingreso_operador = 15431,
  ingreso_neto     = 127876,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Sofia Aristizabal';
UPDATE public.reservas r SET
  comision         = 30728,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 94237,
  ingreso_operador = 16630,
  ingreso_neto     = 135867,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Diego Andres Gutierrez Gutierrez';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 256564,
  ingreso_operador = 0,
  ingreso_neto     = 281564,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'sara manuela gonzales gutierrez';
UPDATE public.reservas r SET
  comision         = 39949,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 128888,
  ingreso_operador = 22745,
  ingreso_neto     = 176633,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 306
  AND r.fecha_entrada = '2026-05-23'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Elizabeth Paloma';
UPDATE public.reservas r SET
  comision         = 36890,
  aseo_cobrado     = 0,
  ingreso_hotel    = 123964,
  ingreso_operador = 39146,
  ingreso_neto     = 163110,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-07'
  AND g.nombre ILIKE 'Daniela Andrea Ruiz';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 171000,
  ingreso_operador = 54000,
  ingreso_neto     = 225000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Daniela Loaiza';
UPDATE public.reservas r SET
  comision         = 191739,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 629113,
  ingreso_operador = 198667,
  ingreso_neto     = 847781,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Gabriel Jaramillo Toro';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 121600,
  ingreso_operador = 38400,
  ingreso_neto     = 160000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Crisitan Felipe Ramirez Patiño';
UPDATE public.reservas r SET
  comision         = 24583,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 67409,
  ingreso_operador = 21287,
  ingreso_neto     = 108697,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-01-17'
  AND r.fecha_salida  = '2026-01-18'
  AND g.nombre ILIKE 'Andrés Felipe Muñoz Avila';
UPDATE public.reservas r SET
  comision         = 49722,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 151884,
  ingreso_operador = 47963,
  ingreso_neto     = 219848,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-01-23'
  AND r.fecha_salida  = '2026-01-25'
  AND g.nombre ILIKE 'Juan Esteban Mattos Cruz';
UPDATE public.reservas r SET
  comision         = 31113,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 89351,
  ingreso_operador = 28216,
  ingreso_neto     = 137567,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-01-31'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Julio Caro';
UPDATE public.reservas r SET
  comision         = 28371,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 80135,
  ingreso_operador = 25306,
  ingreso_neto     = 125441,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Juan Pablo Gomez Montes';
UPDATE public.reservas r SET
  comision         = 29292,
  aseo_cobrado     = 0,
  ingreso_hotel    = 90932,
  ingreso_operador = 13588,
  ingreso_neto     = 104520,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-02-18'
  AND r.fecha_salida  = '2026-02-19'
  AND g.nombre ILIKE 'Angie Viviana Fuentes Quimbayo';
UPDATE public.reservas r SET
  comision         = 76436,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 250529,
  ingreso_operador = 37435,
  ingreso_neto     = 312964,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-03-02'
  AND g.nombre ILIKE 'Juan Carlos Neira Cardona';
UPDATE public.reservas r SET
  comision         = 69255,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 217774,
  ingreso_operador = 38431,
  ingreso_neto     = 281205,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-03-11'
  AND r.fecha_salida  = '2026-03-14'
  AND g.nombre ILIKE 'Brayan Quintero';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 216750,
  ingreso_operador = 38250,
  ingreso_neto     = 280000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-03-15'
  AND r.fecha_salida  = '2026-03-17'
  AND g.nombre ILIKE 'Ivan Santiago Rios';
UPDATE public.reservas r SET
  comision         = 79200,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 276405,
  ingreso_operador = 48777,
  ingreso_neto     = 350182,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Miguel Madrigal Beltran';
UPDATE public.reservas r SET
  comision         = 30076,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 91786,
  ingreso_operador = 16198,
  ingreso_neto     = 132984,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-03-29'
  AND r.fecha_salida  = '2026-03-30'
  AND g.nombre ILIKE 'Tatiana Aristizábal';
UPDATE public.reservas r SET
  comision         = 55920,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 188914,
  ingreso_operador = 33338,
  ingreso_neto     = 247252,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Cristina Lopez Gomez';
UPDATE public.reservas r SET
  comision         = 24713,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 71627,
  ingreso_operador = 12640,
  ingreso_neto     = 109267,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-04-11'
  AND r.fecha_salida  = '2026-04-12'
  AND g.nombre ILIKE 'David Steven Ochoa Muñoz';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-04-15'
  AND r.fecha_salida  = '2026-04-16'
  AND g.nombre ILIKE 'Raul Forjan';
UPDATE public.reservas r SET
  comision         = 22968,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67687,
  ingreso_operador = 11945,
  ingreso_neto     = 104632,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-04-16'
  AND r.fecha_salida  = '2026-04-17'
  AND g.nombre ILIKE 'Mayra Arias Marin';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-04-18'
  AND r.fecha_salida  = '2026-04-19'
  AND g.nombre ILIKE 'Mateo Botero Botero';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-04-20'
  AND r.fecha_salida  = '2026-04-21'
  AND g.nombre ILIKE 'Leidys Muñoz';
UPDATE public.reservas r SET
  comision         = 116797,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 417706,
  ingreso_operador = 73713,
  ingreso_neto     = 516418,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-04-23'
  AND r.fecha_salida  = '2026-04-28'
  AND g.nombre ILIKE 'Hibet Herrera';
UPDATE public.reservas r SET
  comision         = 47072,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 155659,
  ingreso_operador = 27469,
  ingreso_neto     = 208128,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-04-30'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Jimmy Andres Vega Rodriguez';
UPDATE public.reservas r SET
  comision         = 22968,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 62943,
  ingreso_operador = 11108,
  ingreso_neto     = 99050,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Viviana Sepulveda';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-07'
  AND r.fecha_salida  = '2026-05-08'
  AND g.nombre ILIKE 'Raul Forjan';
UPDATE public.reservas r SET
  comision         = 22653,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 63888,
  ingreso_operador = 11274,
  ingreso_neto     = 100162,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-08'
  AND r.fecha_salida  = '2026-05-09'
  AND g.nombre ILIKE 'Juan Camilo Muñoz Patiño';
UPDATE public.reservas r SET
  comision         = 47072,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 155659,
  ingreso_operador = 27469,
  ingreso_neto     = 208128,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-09'
  AND r.fecha_salida  = '2026-05-11'
  AND g.nombre ILIKE 'Stephanny Agudelo Osorio';
UPDATE public.reservas r SET
  comision         = 28147,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84535,
  ingreso_operador = 14918,
  ingreso_neto     = 124453,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-13'
  AND r.fecha_salida  = '2026-05-14'
  AND g.nombre ILIKE 'Angie Viviana Fuentes Quimbayo';
UPDATE public.reservas r SET
  comision         = 67519,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 232505,
  ingreso_operador = 41030,
  ingreso_neto     = 298535,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-16'
  AND g.nombre ILIKE 'Juan Castaneda';
UPDATE public.reservas r SET
  comision         = 51683,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172990,
  ingreso_operador = 30528,
  ingreso_neto     = 228517,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'ANGIE MELISSA RODRIGUEZ GALARZA';
UPDATE public.reservas r SET
  comision         = 51683,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172990,
  ingreso_operador = 30528,
  ingreso_neto     = 228517,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-18'
  AND r.fecha_salida  = '2026-05-20'
  AND g.nombre ILIKE 'Shirley 丁';
UPDATE public.reservas r SET
  comision         = 51683,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172990,
  ingreso_operador = 30528,
  ingreso_neto     = 228517,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Mauricio Baquero Diaz';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 104393,
  ingreso_operador = 18422,
  ingreso_neto     = 147815,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 307
  AND r.fecha_entrada = '2026-05-24'
  AND r.fecha_salida  = '2026-05-25'
  AND g.nombre ILIKE 'Mónica Gaitán Bedoya';
UPDATE public.reservas r SET
  comision         = 65448,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 204728,
  ingreso_operador = 64651,
  ingreso_neto     = 289379,
  verificacion     = NULL,
  check_in_early   = NULL,
  check_out_late   = '$150.000',
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-01-01'
  AND r.fecha_salida  = '2026-01-03'
  AND g.nombre ILIKE 'Laura Chacon';
UPDATE public.reservas r SET
  comision         = 385014,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 1278583,
  ingreso_operador = 403763,
  ingreso_neto     = 1702346,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Darius Bell';
UPDATE public.reservas r SET
  comision         = 56970,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 176239,
  ingreso_operador = 55655,
  ingreso_neto     = 251894,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-01-16'
  AND r.fecha_salida  = '2026-01-18'
  AND g.nombre ILIKE 'Jorge Andres Jimenez Montoya';
UPDATE public.reservas r SET
  comision         = 76820,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 242942,
  ingreso_operador = 76718,
  ingreso_neto     = 339660,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-01-23'
  AND r.fecha_salida  = '2026-01-25'
  AND g.nombre ILIKE 'Adriana Noguera';
UPDATE public.reservas r SET
  comision         = 36010,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 105807,
  ingreso_operador = 33413,
  ingreso_neto     = 159220,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-01-25'
  AND r.fecha_salida  = '2026-01-26'
  AND g.nombre ILIKE 'Gustavo Gonzalez';
UPDATE public.reservas r SET
  comision         = 36010,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 105807,
  ingreso_operador = 33413,
  ingreso_neto     = 159220,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-01-31'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Sebastián García Idárraga';
UPDATE public.reservas r SET
  comision         = 36010,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 105807,
  ingreso_operador = 33413,
  ingreso_neto     = 159220,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Carolina Valencia';
UPDATE public.reservas r SET
  comision         = 30468,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 95453,
  ingreso_operador = 14263,
  ingreso_neto     = 134716,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-02-14'
  AND r.fecha_salida  = '2026-02-15'
  AND g.nombre ILIKE 'Sebastián Osorio Ospina';
UPDATE public.reservas r SET
  comision         = 30468,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 95453,
  ingreso_operador = 14263,
  ingreso_neto     = 134716,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-02-17'
  AND r.fecha_salida  = '2026-02-18'
  AND g.nombre ILIKE 'Andrea Durán';
UPDATE public.reservas r SET
  comision         = 36932,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 120319,
  ingreso_operador = 17979,
  ingreso_neto     = 163298,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-02-21'
  AND r.fecha_salida  = '2026-02-22'
  AND g.nombre ILIKE 'César Camacho';
UPDATE public.reservas r SET
  comision         = 50691,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 173246,
  ingreso_operador = 0,
  ingreso_neto     = 198246,
  verificacion     = 25887,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-02-25'
  AND r.fecha_salida  = '2026-02-27'
  AND g.nombre ILIKE 'Manuel Jose Sierra';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 176833,
  ingreso_operador = 26423,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Lorena Castro Lombana';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 161763,
  ingreso_operador = 24171,
  ingreso_neto     = 210934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-02'
  AND r.fecha_salida  = '2026-03-04'
  AND g.nombre ILIKE 'Maria Isabel Ocampo';
UPDATE public.reservas r SET
  comision         = 28117,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 86411,
  ingreso_operador = 12912,
  ingreso_neto     = 124323,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-05'
  AND r.fecha_salida  = '2026-03-06'
  AND g.nombre ILIKE 'Juan David Villada Zuluaga';
UPDATE public.reservas r SET
  comision         = 75130,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 267255,
  ingreso_operador = 39935,
  ingreso_neto     = 332190,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-06'
  AND r.fecha_salida  = '2026-03-09'
  AND g.nombre ILIKE 'Juan Diego Gómez';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-10'
  AND r.fecha_salida  = '2026-03-11'
  AND g.nombre ILIKE 'Yohany Gaviria';
UPDATE public.reservas r SET
  comision         = 80706,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 282067,
  ingreso_operador = 49776,
  ingreso_neto     = 356843,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-11'
  AND r.fecha_salida  = '2026-03-14'
  AND g.nombre ILIKE 'Angela Quintero Yepes';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172768,
  ingreso_operador = 30488,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-14'
  AND r.fecha_salida  = '2026-03-16'
  AND g.nombre ILIKE 'Alejandra Marin Campos';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-20'
  AND g.nombre ILIKE 'Tatiana Aristizábal';
UPDATE public.reservas r SET
  comision         = 108899,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 388023,
  ingreso_operador = 68475,
  ingreso_neto     = 481497,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-24'
  AND g.nombre ILIKE 'Mike Ortiz';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-24'
  AND r.fecha_salida  = '2026-03-25'
  AND g.nombre ILIKE 'Andres Felipe Ramirez Ospina';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-25'
  AND r.fecha_salida  = '2026-03-26'
  AND g.nombre ILIKE 'Daniela Franco Rincon';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-26'
  AND r.fecha_salida  = '2026-03-27'
  AND g.nombre ILIKE 'Edisson Culma Avila';
UPDATE public.reservas r SET
  comision         = 55667,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 187964,
  ingreso_operador = 33170,
  ingreso_neto     = 246134,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-28'
  AND r.fecha_salida  = '2026-03-30'
  AND g.nombre ILIKE 'Mayerly Quintero';
UPDATE public.reservas r SET
  comision         = 59459,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 202216,
  ingreso_operador = 35685,
  ingreso_neto     = 262901,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-03-30'
  AND r.fecha_salida  = '2026-04-01'
  AND g.nombre ILIKE 'Shangri La Giraldo Fernandez';
UPDATE public.reservas r SET
  comision         = 32035,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 99148,
  ingreso_operador = 17497,
  ingreso_neto     = 141645,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-02'
  AND g.nombre ILIKE 'Johan Alexander Paniagua Bedoya';
UPDATE public.reservas r SET
  comision         = 35161,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 110897,
  ingreso_operador = 19570,
  ingreso_neto     = 155467,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Valentina Ocampo Parra';
UPDATE public.reservas r SET
  comision         = 70500,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 243711,
  ingreso_operador = 43008,
  ingreso_neto     = 311719,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-04-03'
  AND r.fecha_salida  = '2026-04-05'
  AND g.nombre ILIKE 'Hector Fabio Valencia Zorrilla';
UPDATE public.reservas r SET
  comision         = 32035,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 99148,
  ingreso_operador = 17497,
  ingreso_neto     = 141645,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-04-08'
  AND r.fecha_salida  = '2026-04-09'
  AND g.nombre ILIKE 'Julián Bolaños';
UPDATE public.reservas r SET
  comision         = 170370,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 619049,
  ingreso_operador = 109244,
  ingreso_neto     = 753293,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-04-13'
  AND r.fecha_salida  = '2026-04-19'
  AND g.nombre ILIKE 'luis lira';
UPDATE public.reservas r SET
  comision         = 32035,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 99148,
  ingreso_operador = 17497,
  ingreso_neto     = 141645,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-04-20'
  AND r.fecha_salida  = '2026-04-21'
  AND g.nombre ILIKE 'natalia meneses';
UPDATE public.reservas r SET
  comision         = 32500,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 100895,
  ingreso_operador = 17805,
  ingreso_neto     = 143700,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-04-21'
  AND r.fecha_salida  = '2026-04-22'
  AND g.nombre ILIKE 'Juan Camilo Barrera Nieto';
UPDATE public.reservas r SET
  comision         = 28921,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 87444,
  ingreso_operador = 15431,
  ingreso_neto     = 127876,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Sofia Aristizabal';
UPDATE public.reservas r SET
  comision         = 32500,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 100895,
  ingreso_operador = 17805,
  ingreso_neto     = 143700,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Fabián Gelvis Gelvis Medina';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 127500,
  ingreso_operador = 0,
  ingreso_neto     = 152500,
  verificacion     = 22500,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-17'
  AND g.nombre ILIKE 'Carlos Gabriel Rincon Vargas';
UPDATE public.reservas r SET
  comision         = 38414,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 123119,
  ingreso_operador = 21727,
  ingreso_neto     = 169846,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-05-17'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Diego Acero';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 134107,
  ingreso_operador = 0,
  ingreso_neto     = 159107,
  verificacion     = 23666,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 401
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-23'
  AND g.nombre ILIKE 'andres velasquez montoya';
UPDATE public.reservas r SET
  comision         = 165752,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 541786,
  ingreso_operador = 171090,
  ingreso_neto     = 732876,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-01-02'
  AND r.fecha_salida  = '2026-01-04'
  AND g.nombre ILIKE 'Say Buritica';
UPDATE public.reservas r SET
  comision         = 194351,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 637890,
  ingreso_operador = 201439,
  ingreso_neto     = 859329,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Andres Valencia';
UPDATE public.reservas r SET
  comision         = 25558,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 70686,
  ingreso_operador = 22322,
  ingreso_neto     = 113008,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-01-24'
  AND r.fecha_salida  = '2026-01-25'
  AND g.nombre ILIKE 'David Colorado';
UPDATE public.reservas r SET
  comision         = 34443,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 100541,
  ingreso_operador = 31750,
  ingreso_neto     = 152291,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-01-31'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Sebastian Gutiérrez Vanegas';
UPDATE public.reservas r SET
  comision         = 31368,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 90206,
  ingreso_operador = 28486,
  ingreso_neto     = 138692,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Mateo Rojas Saraza';
UPDATE public.reservas r SET
  comision         = 34443,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 115093,
  ingreso_operador = 17198,
  ingreso_neto     = 152291,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-02-14'
  AND r.fecha_salida  = '2026-02-15'
  AND g.nombre ILIKE 'Sebastian Gutiérrez Vanegas';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 139200,
  ingreso_operador = 20800,
  ingreso_neto     = 160000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-02-19'
  AND r.fecha_salida  = '2026-02-20'
  AND g.nombre ILIKE 'Camila Lopez';
UPDATE public.reservas r SET
  comision         = 55335,
  aseo_cobrado     = 0,
  ingreso_hotel    = 212859,
  ingreso_operador = 31806,
  ingreso_neto     = 244665,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-02-21'
  AND r.fecha_salida  = '2026-02-22'
  AND g.nombre ILIKE 'Estefania Ruiz';
UPDATE public.reservas r SET
  comision         = 25506,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76364,
  ingreso_operador = 11411,
  ingreso_neto     = 112774,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-02-25'
  AND r.fecha_salida  = '2026-02-26'
  AND g.nombre ILIKE 'Iván Andres Urrego Izquierdo';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 176833,
  ingreso_operador = 26423,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Jean Cherubin';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 134484,
  ingreso_operador = 0,
  ingreso_neto     = 159484,
  verificacion     = 23733,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-03-08'
  AND r.fecha_salida  = '2026-03-09'
  AND g.nombre ILIKE 'Andrés Felipe Gonzalez';
UPDATE public.reservas r SET
  comision         = 98636,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 349455,
  ingreso_operador = 61669,
  ingreso_neto     = 436124,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-03-11'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Ana Gabriela Bagaroza Escobar';
UPDATE public.reservas r SET
  comision         = 125629,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 450900,
  ingreso_operador = 79571,
  ingreso_neto     = 555470,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-03-15'
  AND r.fecha_salida  = '2026-03-20'
  AND g.nombre ILIKE 'Gilberto Durango Sepulveda';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-21'
  AND g.nombre ILIKE 'Andres Felipe Bedoya';
UPDATE public.reservas r SET
  comision         = 59106,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 200887,
  ingreso_operador = 35451,
  ingreso_neto     = 261338,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-03-21'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Andrea Gutierrez';
UPDATE public.reservas r SET
  comision         = 127007,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 456079,
  ingreso_operador = 80485,
  ingreso_neto     = 561564,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-03-25'
  AND r.fecha_salida  = '2026-03-30'
  AND g.nombre ILIKE 'David Chavez';
UPDATE public.reservas r SET
  comision         = 32035,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 99148,
  ingreso_operador = 17497,
  ingreso_neto     = 141645,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-03-31'
  AND r.fecha_salida  = '2026-04-01'
  AND g.nombre ILIKE 'Lorena Tenorio';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 159584,
  ingreso_operador = 0,
  ingreso_neto     = 184584,
  verificacion     = 28162,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-04-03'
  AND r.fecha_salida  = '2026-04-04'
  AND g.nombre ILIKE 'Juan Jose Arias Gutierrez';
UPDATE public.reservas r SET
  comision         = 62585,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 213964,
  ingreso_operador = 37758,
  ingreso_neto     = 276723,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-02'
  AND g.nombre ILIKE 'Mateo Gomez';
UPDATE public.reservas r SET
  comision         = 62585,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67158,
  ingreso_operador = 11851,
  ingreso_neto     = 104010,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-05-02'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Sebastian Amaya Acosta';
UPDATE public.reservas r SET
  comision         = 62585,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 102573,
  ingreso_operador = 18101,
  ingreso_neto     = 145675,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-17'
  AND g.nombre ILIKE 'Maritza Rivas';
UPDATE public.reservas r SET
  comision         = 62585,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 102573,
  ingreso_operador = 18101,
  ingreso_neto     = 145675,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 402
  AND r.fecha_entrada = '2026-05-17'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Kevin Alexis Taborda Orozco';
UPDATE public.reservas r SET
  comision         = 77469,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 245124,
  ingreso_operador = 77407,
  ingreso_neto     = 342531,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-01-06'
  AND r.fecha_salida  = '2026-01-08'
  AND g.nombre ILIKE 'Hasbleidy Ibarra';
UPDATE public.reservas r SET
  comision         = 40579,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 121160,
  ingreso_operador = 38261,
  ingreso_neto     = 179421,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-01-08'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Heidi Barreto';
UPDATE public.reservas r SET
  comision         = 180761,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 592222,
  ingreso_operador = 187017,
  ingreso_neto     = 799239,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Felipe Cardozo';
UPDATE public.reservas r SET
  comision         = 22200,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 80408,
  ingreso_operador = 25392,
  ingreso_neto     = 125800,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Katherine Correa';
UPDATE public.reservas r SET
  comision         = 31342,
  aseo_cobrado     = 0,
  ingreso_hotel    = 105319,
  ingreso_operador = 33259,
  ingreso_neto     = 138578,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-01-12'
  AND r.fecha_salida  = '2026-01-13'
  AND g.nombre ILIKE 'Jose Alexander Giraldo Hurtado';
UPDATE public.reservas r SET
  comision         = 184252,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 603954,
  ingreso_operador = 190722,
  ingreso_neto     = 814676,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-01-19'
  AND r.fecha_salida  = '2026-01-26'
  AND g.nombre ILIKE 'Jacobo Arango';
UPDATE public.reservas r SET
  comision         = 55520,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 171368,
  ingreso_operador = 54116,
  ingreso_neto     = 245485,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-01-30'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Daniela Delgado';
UPDATE public.reservas r SET
  comision         = 27822,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 78292,
  ingreso_operador = 24724,
  ingreso_neto     = 123016,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Alejandro Correa Álvarez';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 0,
  ingreso_hotel    = 161763,
  ingreso_operador = 24171,
  ingreso_neto     = 185934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-03-01'
  AND g.nombre ILIKE 'Samuel Hernandez';
UPDATE public.reservas r SET
  comision         = 74610,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 350427,
  ingreso_operador = 52363,
  ingreso_neto     = 422790,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-03-02'
  AND r.fecha_salida  = '2026-03-05'
  AND g.nombre ILIKE 'Ivan Santiago Rios';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 106250,
  ingreso_operador = 0,
  ingreso_neto     = 131250,
  verificacion     = 18750,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-03-06'
  AND r.fecha_salida  = '2026-03-07'
  AND g.nombre ILIKE 'Mateo Marin';
UPDATE public.reservas r SET
  comision         = 97819,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 346384,
  ingreso_operador = 61127,
  ingreso_neto     = 432510,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-03-11'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Jose Luis Diaz Montaña';
UPDATE public.reservas r SET
  comision         = 26159,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77062,
  ingreso_operador = 13599,
  ingreso_neto     = 115661,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-03-18'
  AND r.fecha_salida  = '2026-03-19'
  AND g.nombre ILIKE 'Angie Viviana Fuentes Quimbayo';
UPDATE public.reservas r SET
  comision         = 47715,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 158078,
  ingreso_operador = 27896,
  ingreso_neto     = 210974,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-21'
  AND g.nombre ILIKE 'Paula Alvarez';
UPDATE public.reservas r SET
  comision         = 55761,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 188315,
  ingreso_operador = 33232,
  ingreso_neto     = 246546,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-03-21'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Steven Escobar Castaño';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 158044,
  ingreso_operador = 27890,
  ingreso_neto     = 210934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-03-25'
  AND r.fecha_salida  = '2026-03-27'
  AND g.nombre ILIKE 'Adriana Largo';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172768,
  ingreso_operador = 30488,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-03-28'
  AND r.fecha_salida  = '2026-03-30'
  AND g.nombre ILIKE 'Juan Sebastian Lopez';
UPDATE public.reservas r SET
  comision         = 51624,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172768,
  ingreso_operador = 30488,
  ingreso_neto     = 228256,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-03-30'
  AND r.fecha_salida  = '2026-04-01'
  AND g.nombre ILIKE 'Angel Gonzalez';
UPDATE public.reservas r SET
  comision         = 87038,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 305866,
  ingreso_operador = 53976,
  ingreso_neto     = 384843,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-05'
  AND g.nombre ILIKE 'Denis Honorio Silva';
UPDATE public.reservas r SET
  comision         = 26159,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77062,
  ingreso_operador = 13599,
  ingreso_neto     = 115661,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-04-06'
  AND r.fecha_salida  = '2026-04-07'
  AND g.nombre ILIKE 'Heidi Barreto';
UPDATE public.reservas r SET
  comision         = 30076,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 91786,
  ingreso_operador = 16198,
  ingreso_neto     = 132984,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-04-15'
  AND r.fecha_salida  = '2026-04-16'
  AND g.nombre ILIKE 'Angie Viviana Fuentes Quimbayo';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-04-17'
  AND r.fecha_salida  = '2026-04-18'
  AND g.nombre ILIKE 'Derek Matias Botero Ocampo';
UPDATE public.reservas r SET
  comision         = 112972,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 403332,
  ingreso_operador = 71176,
  ingreso_neto     = 499508,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-04-27'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Fernando Marulanda Moreno';
UPDATE public.reservas r SET
  comision         = 30514,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93430,
  ingreso_operador = 16488,
  ingreso_neto     = 134918,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-05-09'
  AND r.fecha_salida  = '2026-05-10'
  AND g.nombre ILIKE 'Sebastian Gutiérrez Vanegas';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 0,
  ingreso_operador = 0,
  ingreso_neto     = 25000,
  verificacion     = 115000,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-05-11'
  AND r.fecha_salida  = '2026-05-12'
  AND g.nombre ILIKE 'natalia giraldo giraldo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 0,
  ingreso_operador = 0,
  ingreso_neto     = 25000,
  verificacion     = 122878,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-05-13'
  AND r.fecha_salida  = '2026-05-14'
  AND g.nombre ILIKE 'maria paula marin vitola';
UPDATE public.reservas r SET
  comision         = 48747,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 161955,
  ingreso_operador = 28580,
  ingreso_neto     = 215535,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-05-14'
  AND r.fecha_salida  = '2026-05-16'
  AND g.nombre ILIKE 'Diego Andres Chavarro Bahos';
UPDATE public.reservas r SET
  comision         = 106279,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 378178,
  ingreso_operador = 66737,
  ingreso_neto     = 469916,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-20'
  AND g.nombre ILIKE 'Juan Diego Bermúdez Orozco';
UPDATE public.reservas r SET
  comision         = 90097,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 317360,
  ingreso_operador = 56005,
  ingreso_neto     = 398364,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 403
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-25'
  AND g.nombre ILIKE 'Pryanka Gonzalez Sifontes';
UPDATE public.reservas r SET
  comision         = 278380,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 920256,
  ingreso_operador = 290607,
  ingreso_neto     = 1230863,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-10'
  AND g.nombre ILIKE 'Maria Camila Dominguez';
UPDATE public.reservas r SET
  comision         = 55985,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 225910,
  ingreso_operador = 71340,
  ingreso_neto     = 317250,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-10'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Cesar Augusto Mejia Patiño';
UPDATE public.reservas r SET
  comision         = 35031,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 102516,
  ingreso_operador = 32373,
  ingreso_neto     = 154889,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Martha Lucía Martinez Ramirez';
UPDATE public.reservas r SET
  comision         = 45478,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 137622,
  ingreso_operador = 43460,
  ingreso_neto     = 201082,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-14'
  AND r.fecha_salida  = '2026-01-16'
  AND g.nombre ILIKE 'Camilo Hurtado Euse';
UPDATE public.reservas r SET
  comision         = 27195,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 76186,
  ingreso_operador = 24059,
  ingreso_neto     = 120245,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-17'
  AND r.fecha_salida  = '2026-01-18'
  AND g.nombre ILIKE 'Melisa Gomez Cardenas';
UPDATE public.reservas r SET
  comision         = 23434,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 63547,
  ingreso_operador = 20068,
  ingreso_neto     = 103615,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-20'
  AND r.fecha_salida  = '2026-01-21'
  AND g.nombre ILIKE 'Julian León';
UPDATE public.reservas r SET
  comision         = 23434,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 63547,
  ingreso_operador = 20068,
  ingreso_neto     = 103615,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-21'
  AND r.fecha_salida  = '2026-01-22'
  AND g.nombre ILIKE 'Julian Posada';
UPDATE public.reservas r SET
  comision         = 28371,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 80135,
  ingreso_operador = 25306,
  ingreso_neto     = 125441,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-24'
  AND r.fecha_salida  = '2026-01-25'
  AND g.nombre ILIKE 'David Steven Ochoa Muñoz';
UPDATE public.reservas r SET
  comision         = 53052,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 163075,
  ingreso_operador = 51497,
  ingreso_neto     = 234572,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-25'
  AND r.fecha_salida  = '2026-01-27'
  AND g.nombre ILIKE 'Camila Mojica Ramirez';
UPDATE public.reservas r SET
  comision         = 28371,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 80135,
  ingreso_operador = 25306,
  ingreso_neto     = 125441,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-30'
  AND r.fecha_salida  = '2026-01-31'
  AND g.nombre ILIKE 'Julian Herrera';
UPDATE public.reservas r SET
  comision         = 140809,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 457969,
  ingreso_operador = 144622,
  ingreso_neto     = 622591,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-01-31'
  AND r.fecha_salida  = '2026-02-05'
  AND g.nombre ILIKE 'Maria Waleska Gonzalez Perez';
UPDATE public.reservas r SET
  comision         = 25628,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 70920,
  ingreso_operador = 22396,
  ingreso_neto     = 113316,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-02-06'
  AND r.fecha_salida  = '2026-02-07'
  AND g.nombre ILIKE 'Monica Alejandra Ramirez Hernandez';
UPDATE public.reservas r SET
  comision         = 25628,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 70920,
  ingreso_operador = 22396,
  ingreso_neto     = 113316,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Urano Idarraga Becerra';
UPDATE public.reservas r SET
  comision         = 31113,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 102283,
  ingreso_operador = 15284,
  ingreso_neto     = 137567,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-02-14'
  AND r.fecha_salida  = '2026-02-15'
  AND g.nombre ILIKE 'Fabian Naranjo';
UPDATE public.reservas r SET
  comision         = 69253,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 244650,
  ingreso_operador = 36557,
  ingreso_neto     = 306207,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-02-27'
  AND r.fecha_salida  = '2026-03-02'
  AND g.nombre ILIKE 'Laura Camila Perez Castro';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 129195,
  ingreso_operador = 19305,
  ingreso_neto     = 173500,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-04'
  AND r.fecha_salida  = '2026-03-05'
  AND g.nombre ILIKE 'Santiago Yepez';
UPDATE public.reservas r SET
  comision         = 69253,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 244650,
  ingreso_operador = 36557,
  ingreso_neto     = 306207,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-05'
  AND r.fecha_salida  = '2026-03-08'
  AND g.nombre ILIKE 'David Fernando Ríos Osorio';
UPDATE public.reservas r SET
  comision         = 26158,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77063,
  ingreso_operador = 13599,
  ingreso_neto     = 115662,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-10'
  AND r.fecha_salida  = '2026-03-11'
  AND g.nombre ILIKE 'Natalia Diaz Rengifo';
UPDATE public.reservas r SET
  comision         = 26158,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77063,
  ingreso_operador = 13599,
  ingreso_neto     = 115662,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-11'
  AND r.fecha_salida  = '2026-03-12'
  AND g.nombre ILIKE 'Iván Andres Urrego Izquierdo';
UPDATE public.reservas r SET
  comision         = 50114,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 167094,
  ingreso_operador = 29487,
  ingreso_neto     = 221581,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-12'
  AND r.fecha_salida  = '2026-03-14'
  AND g.nombre ILIKE 'Iván Andres Urrego Izquierdo';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 257341,
  ingreso_operador = 45413,
  ingreso_neto     = 327754,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-14'
  AND r.fecha_salida  = '2026-03-16'
  AND g.nombre ILIKE 'Camilo Garcia';
UPDATE public.reservas r SET
  comision         = 26159,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77062,
  ingreso_operador = 13599,
  ingreso_neto     = 115661,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-18'
  AND r.fecha_salida  = '2026-03-19'
  AND g.nombre ILIKE 'Johan Varela';
UPDATE public.reservas r SET
  comision         = 26159,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 77062,
  ingreso_operador = 13599,
  ingreso_neto     = 115661,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-20'
  AND g.nombre ILIKE 'Carolina Diaz Zuñiga';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 206844,
  ingreso_operador = 0,
  ingreso_neto     = 231844,
  verificacion     = 36502,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-22'
  AND g.nombre ILIKE 'juan pablo restrepo robledo';
UPDATE public.reservas r SET
  comision         = 27422,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 81811,
  ingreso_operador = 14437,
  ingreso_neto     = 121249,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-22'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Oscar Alejandro Fajardo Rojas';
UPDATE public.reservas r SET
  comision         = 52494,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 176040,
  ingreso_operador = 31066,
  ingreso_neto     = 232106,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-24'
  AND r.fecha_salida  = '2026-03-26'
  AND g.nombre ILIKE 'Brenda Lozano';
UPDATE public.reservas r SET
  comision         = 28118,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 84424,
  ingreso_operador = 14898,
  ingreso_neto     = 124322,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-26'
  AND r.fecha_salida  = '2026-03-27'
  AND g.nombre ILIKE 'Carolina Diaz Zuñiga';
UPDATE public.reservas r SET
  comision         = 55060,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 185682,
  ingreso_operador = 32767,
  ingreso_neto     = 243450,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-03-31'
  AND r.fecha_salida  = '2026-04-02'
  AND g.nombre ILIKE 'Laura Bedoya';
UPDATE public.reservas r SET
  comision         = 58263,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 197719,
  ingreso_operador = 34892,
  ingreso_neto     = 257611,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-04-02'
  AND r.fecha_salida  = '2026-04-04'
  AND g.nombre ILIKE 'Juan Diego Palacio';
UPDATE public.reservas r SET
  comision         = 25903,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 76100,
  ingreso_operador = 13429,
  ingreso_neto     = 114529,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Perez Quintero Jhon Jairo';
UPDATE public.reservas r SET
  comision         = 77708,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 270800,
  ingreso_operador = 47788,
  ingreso_neto     = 343588,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-04-30'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'David Garcia Botina';
UPDATE public.reservas r SET
  comision         = 30514,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93430,
  ingreso_operador = 16488,
  ingreso_neto     = 134918,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-05-09'
  AND r.fecha_salida  = '2026-05-10'
  AND g.nombre ILIKE 'Juan Camilo Avila Restrepo';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 0,
  ingreso_operador = 0,
  ingreso_neto     = 25000,
  verificacion     = 122878,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-05-13'
  AND r.fecha_salida  = '2026-05-14'
  AND g.nombre ILIKE 'maria paula marin vitola';
UPDATE public.reservas r SET
  comision         = 48747,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 161955,
  ingreso_operador = 28580,
  ingreso_neto     = 215535,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-05-14'
  AND r.fecha_salida  = '2026-05-16'
  AND g.nombre ILIKE 'Diego Andres Chavarro Bahos';
UPDATE public.reservas r SET
  comision         = 54843,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 184866,
  ingreso_operador = 32623,
  ingreso_neto     = 242489,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'Ana Maria Rodriguez Rendon';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 104393,
  ingreso_operador = 18422,
  ingreso_neto     = 147815,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 404
  AND r.fecha_entrada = '2026-05-24'
  AND r.fecha_salida  = '2026-05-25'
  AND g.nombre ILIKE 'Mónica Gaitán Bedoya';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 0,
  ingreso_hotel    = 700000,
  ingreso_operador = 0,
  ingreso_neto     = 700000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-01-03'
  AND r.fecha_salida  = '2026-01-05'
  AND g.nombre ILIKE 'Luis Fernando Chaverra';
UPDATE public.reservas r SET
  comision         = 320864,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 1059216,
  ingreso_operador = 334489,
  ingreso_neto     = 1418705,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-01-05'
  AND r.fecha_salida  = '2026-01-10'
  AND g.nombre ILIKE 'Mialet Pierre';
UPDATE public.reservas r SET
  comision         = 170845,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 558900,
  ingreso_operador = 176495,
  ingreso_neto     = 755395,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-01-10'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Camilo Blanco';
UPDATE public.reservas r SET
  comision         = 30468,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 95453,
  ingreso_operador = 14263,
  ingreso_neto     = 134716,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-02-14'
  AND r.fecha_salida  = '2026-02-15'
  AND g.nombre ILIKE 'César García';
UPDATE public.reservas r SET
  comision         = 30468,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 95453,
  ingreso_operador = 14263,
  ingreso_neto     = 134716,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-02-15'
  AND r.fecha_salida  = '2026-02-16'
  AND g.nombre ILIKE 'César García';
UPDATE public.reservas r SET
  comision         = 69254,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 244650,
  ingreso_operador = 36557,
  ingreso_neto     = 306206,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-02-19'
  AND r.fecha_salida  = '2026-02-21'
  AND g.nombre ILIKE 'César García';
UPDATE public.reservas r SET
  comision         = 32035,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 101481,
  ingreso_operador = 15164,
  ingreso_neto     = 141645,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-02-21'
  AND r.fecha_salida  = '2026-02-22'
  AND g.nombre ILIKE 'Santiago Stuart Ospina Muñoz';
UPDATE public.reservas r SET
  comision         = 75130,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 261111,
  ingreso_operador = 46078,
  ingreso_neto     = 332190,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-03-07'
  AND r.fecha_salida  = '2026-03-10'
  AND g.nombre ILIKE 'Stefan Billing';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 275000,
  ingreso_operador = 41250,
  ingreso_neto     = 341250,
  verificacion     = NULL,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-03-13'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Jenifer Sandoval Alvarado';
UPDATE public.reservas r SET
  comision         = 167771,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 609283,
  ingreso_operador = 107520,
  ingreso_neto     = 741803,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-03-17'
  AND r.fecha_salida  = '2026-03-24'
  AND g.nombre ILIKE 'Juanita Calle Duque';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 150878,
  ingreso_operador = 0,
  ingreso_neto     = 175878,
  verificacion     = 26625,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-03-28'
  AND r.fecha_salida  = '2026-03-29'
  AND g.nombre ILIKE 'Ramirez Ramirez Gonzalo de Jesus';
UPDATE public.reservas r SET
  comision         = 64115,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 219712,
  ingreso_operador = 38773,
  ingreso_neto     = 283485,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Moises Cuello';
UPDATE public.reservas r SET
  comision         = 87495,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 307583,
  ingreso_operador = 54279,
  ingreso_neto     = 386862,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-04-03'
  AND r.fecha_salida  = '2026-04-05'
  AND g.nombre ILIKE 'Ana Maria Mora';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 244089,
  ingreso_operador = 0,
  ingreso_neto     = 0,
  verificacion     = 43075,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-04-08'
  AND r.fecha_salida  = '2026-04-10'
  AND g.nombre ILIKE 'helena groso rodriguez';
UPDATE public.reservas r SET
  comision         = 70607,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 244114,
  ingreso_operador = 43079,
  ingreso_neto     = 312193,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-04-24'
  AND r.fecha_salida  = '2026-04-27'
  AND g.nombre ILIKE 'Christian Figueroa';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 446250,
  ingreso_operador = 0,
  ingreso_neto     = 471250,
  verificacion     = 78750,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-04'
  AND g.nombre ILIKE 'edison huerta montoya';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 138962,
  ingreso_operador = 0,
  ingreso_neto     = 163962,
  verificacion     = 24523,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-17'
  AND g.nombre ILIKE 'Juan David Vergara Cardona';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 382500,
  ingreso_operador = 0,
  ingreso_neto     = 407500,
  verificacion     = 67500,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-05-19'
  AND r.fecha_salida  = '2026-05-22'
  AND g.nombre ILIKE 'Johan Javier Carrillo días';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 252630,
  ingreso_operador = 0,
  ingreso_neto     = 277630,
  verificacion     = 44582,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 405
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Carlos Pérez De la cruz';
UPDATE public.reservas r SET
  comision         = 117508,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 379667,
  ingreso_operador = 119895,
  ingreso_neto     = 519562,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-01-01'
  AND r.fecha_salida  = '2026-01-04'
  AND g.nombre ILIKE 'Jhoa Ariza';
UPDATE public.reservas r SET
  comision         = 235739,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 776967,
  ingreso_operador = 245358,
  ingreso_neto     = 1042325,
  verificacion     = NULL,
  check_in_early   = NULL,
  check_out_late   = '$40.000',
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-10'
  AND g.nombre ILIKE 'Peter Dario Carvajal';
UPDATE public.reservas r SET
  comision         = 212634,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 699326,
  ingreso_operador = 220840,
  ingreso_neto     = 940166,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-01-10'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Carlos Enrique Toro Vera';
UPDATE public.reservas r SET
  comision         = 112863,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 364059,
  ingreso_operador = 114966,
  ingreso_neto     = 499025,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-01-30'
  AND r.fecha_salida  = '2026-02-03'
  AND g.nombre ILIKE 'Catalina Rodriguez';
UPDATE public.reservas r SET
  comision         = 26608,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 74211,
  ingreso_operador = 23435,
  ingreso_neto     = 117646,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-02-07'
  AND r.fecha_salida  = '2026-02-08'
  AND g.nombre ILIKE 'Sindry Paola Camargo';
UPDATE public.reservas r SET
  comision         = 75130,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 261111,
  ingreso_operador = 46078,
  ingreso_neto     = 332190,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-03-12'
  AND r.fecha_salida  = '2026-03-15'
  AND g.nombre ILIKE 'Juan Jiménez';
UPDATE public.reservas r SET
  comision         = 84937,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 297968,
  ingreso_operador = 52583,
  ingreso_neto     = 375550,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-03-20'
  AND r.fecha_salida  = '2026-03-23'
  AND g.nombre ILIKE 'Daniel Duarte';
UPDATE public.reservas r SET
  comision         = 51674,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 172956,
  ingreso_operador = 30522,
  ingreso_neto     = 228477,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-03-27'
  AND r.fecha_salida  = '2026-03-29'
  AND g.nombre ILIKE 'Sergio Velasquez';
UPDATE public.reservas r SET
  comision         = 53067,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 178190,
  ingreso_operador = 31445,
  ingreso_neto     = 234635,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-03-30'
  AND r.fecha_salida  = '2026-04-01'
  AND g.nombre ILIKE 'Juan David García Quintero';
UPDATE public.reservas r SET
  comision         = 64115,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 219712,
  ingreso_operador = 38773,
  ingreso_neto     = 283485,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-04-01'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Rosie Mohr';
UPDATE public.reservas r SET
  comision         = 90025,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 317089,
  ingreso_operador = 55957,
  ingreso_neto     = 398045,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-05'
  AND g.nombre ILIKE 'Julieth Beltran';
UPDATE public.reservas r SET
  comision         = 76914,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 267815,
  ingreso_operador = 47261,
  ingreso_neto     = 340076,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-05-10'
  AND r.fecha_salida  = '2026-05-12'
  AND g.nombre ILIKE 'Julián David Mendoza quintero';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 255782,
  ingreso_operador = 0,
  ingreso_neto     = 280782,
  verificacion     = 45138,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 406
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-18'
  AND g.nombre ILIKE 'jose Vargas';
UPDATE public.reservas r SET
  comision         = 77469,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 245124,
  ingreso_operador = 77407,
  ingreso_neto     = 342531,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-01-07'
  AND r.fecha_salida  = '2026-01-09'
  AND g.nombre ILIKE 'Ali Rudi';
UPDATE public.reservas r SET
  comision         = 38514,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 114222,
  ingreso_operador = 36070,
  ingreso_neto     = 170292,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-01-09'
  AND r.fecha_salida  = '2026-01-10'
  AND g.nombre ILIKE 'Sandra Bustos';
UPDATE public.reservas r SET
  comision         = 61733,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 192244,
  ingreso_operador = 60709,
  ingreso_neto     = 272952,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-01-10'
  AND r.fecha_salida  = '2026-01-11'
  AND g.nombre ILIKE 'Jorge Andres Moreno Velez';
UPDATE public.reservas r SET
  comision         = 31548,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 90814,
  ingreso_operador = 28678,
  ingreso_neto     = 139492,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-01-11'
  AND r.fecha_salida  = '2026-01-12'
  AND g.nombre ILIKE 'Leonardo Saavedra Delgado';
UPDATE public.reservas r SET
  comision         = 26608,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 74211,
  ingreso_operador = 23435,
  ingreso_neto     = 117646,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-01-31'
  AND r.fecha_salida  = '2026-02-01'
  AND g.nombre ILIKE 'Juan Pablo Machado';
UPDATE public.reservas r SET
  comision         = 26608,
  aseo_cobrado     = 20000,
  ingreso_hotel    = 74211,
  ingreso_operador = 23435,
  ingreso_neto     = 117646,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-02-06'
  AND r.fecha_salida  = '2026-02-07'
  AND g.nombre ILIKE 'Brayan Rendon Gonzalez';
UPDATE public.reservas r SET
  comision         = 45837,
  aseo_cobrado     = 0,
  ingreso_hotel    = 176324,
  ingreso_operador = 26347,
  ingreso_neto     = 202671,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-02-14'
  AND r.fecha_salida  = '2026-02-16'
  AND g.nombre ILIKE 'Victor Hugo Osorio Gutierrez';
UPDATE public.reservas r SET
  comision         = 25465,
  aseo_cobrado     = 0,
  ingreso_hotel    = 97958,
  ingreso_operador = 14637,
  ingreso_neto     = 112595,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-02-21'
  AND r.fecha_salida  = '2026-02-22'
  AND g.nombre ILIKE 'Sebastian Gutiérrez Vanegas';
UPDATE public.reservas r SET
  comision         = 47706,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 161763,
  ingreso_operador = 24171,
  ingreso_neto     = 210934,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-02-28'
  AND r.fecha_salida  = '2026-03-02'
  AND g.nombre ILIKE 'Adrián Zapata';
UPDATE public.reservas r SET
  comision         = 47694,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 158054,
  ingreso_operador = 27892,
  ingreso_neto     = 210946,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-03-11'
  AND r.fecha_salida  = '2026-03-13'
  AND g.nombre ILIKE 'Eder Quintero';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 575000,
  ingreso_operador = 0,
  ingreso_neto     = 600000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-03-19'
  AND r.fecha_salida  = '2026-03-24'
  AND g.nombre ILIKE 'Edwin Samuel Lopez Cadena';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 100300,
  ingreso_operador = 17700,
  ingreso_neto     = 143000,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-03-29'
  AND r.fecha_salida  = '2026-03-30'
  AND g.nombre ILIKE 'Juan David García Quintero';
UPDATE public.reservas r SET
  comision         = 78566,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 274026,
  ingreso_operador = 48358,
  ingreso_neto     = 347384,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-03-31'
  AND r.fecha_salida  = '2026-04-03'
  AND g.nombre ILIKE 'Adriana Suarez Rojas';
UPDATE public.reservas r SET
  comision         = 58950,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 200301,
  ingreso_operador = 35347,
  ingreso_neto     = 260648,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-04-03'
  AND r.fecha_salida  = '2026-04-05'
  AND g.nombre ILIKE 'Carlos Blanco';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-04-17'
  AND r.fecha_salida  = '2026-04-18'
  AND g.nombre ILIKE 'Natalia Lopez Soto';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-04-18'
  AND r.fecha_salida  = '2026-04-19'
  AND g.nombre ILIKE 'Luisa Gil Henao';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-04-24'
  AND r.fecha_salida  = '2026-04-25'
  AND g.nombre ILIKE 'Manuel Mejia';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-04-25'
  AND r.fecha_salida  = '2026-04-26'
  AND g.nombre ILIKE 'Daniel Tirado Pelaez';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-04-28'
  AND r.fecha_salida  = '2026-04-29'
  AND g.nombre ILIKE 'Camilo Hurtado Euse';
UPDATE public.reservas r SET
  comision         = 47072,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 155659,
  ingreso_operador = 27469,
  ingreso_neto     = 208128,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-04-29'
  AND r.fecha_salida  = '2026-05-01'
  AND g.nombre ILIKE 'Omar Gomez Taborda';
UPDATE public.reservas r SET
  comision         = 45306,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 149025,
  ingreso_operador = 26299,
  ingreso_neto     = 200324,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-01'
  AND r.fecha_salida  = '2026-05-03'
  AND g.nombre ILIKE 'Everton Ávila';
UPDATE public.reservas r SET
  comision         = 23536,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 67205,
  ingreso_operador = 11860,
  ingreso_neto     = 104064,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-07'
  AND r.fecha_salida  = '2026-05-08'
  AND g.nombre ILIKE 'Juan David López Mejía';
UPDATE public.reservas r SET
  comision         = 45306,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 149025,
  ingreso_operador = 26299,
  ingreso_neto     = 200324,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-08'
  AND r.fecha_salida  = '2026-05-10'
  AND g.nombre ILIKE 'Laura Canon';
UPDATE public.reservas r SET
  comision         = 46189,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 152342,
  ingreso_operador = 26884,
  ingreso_neto     = 204226,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-12'
  AND r.fecha_salida  = '2026-05-14'
  AND g.nombre ILIKE 'Yeiny Covaleda Guzman';
UPDATE public.reservas r SET
  comision         = 67519,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 232505,
  ingreso_operador = 41030,
  ingreso_neto     = 298535,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Booking' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-15'
  AND r.fecha_salida  = '2026-05-16'
  AND g.nombre ILIKE 'Juan Castaneda';
UPDATE public.reservas r SET
  comision         = 75219,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 261444,
  ingreso_operador = 46137,
  ingreso_neto     = 332581,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-16'
  AND r.fecha_salida  = '2026-05-19'
  AND g.nombre ILIKE 'Laura Loaiza';
UPDATE public.reservas r SET
  comision         = 0,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 94903,
  ingreso_operador = 0,
  ingreso_neto     = 119903,
  verificacion     = 16748,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Terceros' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-19'
  AND r.fecha_salida  = '2026-05-20'
  AND g.nombre ILIKE 'fabio andres jaramillo';
UPDATE public.reservas r SET
  comision         = 17374,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 44047,
  ingreso_operador = 7773,
  ingreso_neto     = 76820,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Alexander' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-22'
  AND r.fecha_salida  = '2026-05-23'
  AND g.nombre ILIKE 'CARLOS A FRAGOZO L';
UPDATE public.reservas r SET
  comision         = 30501,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93380,
  ingreso_operador = 16479,
  ingreso_neto     = 134859,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-23'
  AND r.fecha_salida  = '2026-05-24'
  AND g.nombre ILIKE 'Valentina Lopez Obando';
UPDATE public.reservas r SET
  comision         = 30501,
  aseo_cobrado     = 25000,
  ingreso_hotel    = 93380,
  ingreso_operador = 16479,
  ingreso_neto     = 134859,
  verificacion     = 0,
  check_in_early   = NULL,
  check_out_late   = NULL,
  operador_id      = (SELECT id FROM public.operadores WHERE nombre = 'Airbnb' LIMIT 1)
FROM public.habitaciones h, public.huespedes g
WHERE r.habitacion_id = h.id
  AND r.huesped_id    = g.id
  AND h.numero        = 407
  AND r.fecha_entrada = '2026-05-24'
  AND r.fecha_salida  = '2026-05-25'
  AND g.nombre ILIKE 'Valentina Lopez Obando';
