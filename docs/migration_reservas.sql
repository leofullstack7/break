-- Migración de reservas desde Break (1).xlsx
-- 667 reservas encontradas

-- NOTA: las reservas usan los huéspedes creados en migration_huespedes.sql
-- Si un titular no existe, la reserva se omite (ON CONFLICT)

INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sandra Romero' LIMIT 1),
  'Nicolas Rojas',
  '2026-01-07'::date,
  '2026-01-09'::date,
  2811200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sandra Romero' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Dora Patricia Montaña' LIMIT 1),
  'carlos quibides',
  '2026-01-09'::date,
  '2026-01-10'::date,
  500000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Dora Patricia Montaña' LIMIT 1) IS NOT NULL
  AND '2026-01-10'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mario Machado' LIMIT 1),
  'Tania Tusa',
  '2026-01-10'::date,
  '2026-01-12'::date,
  1172000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mario Machado' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jennifer Nuhma' LIMIT 1),
  'Laura Aristizabal',
  '2026-01-30'::date,
  '2026-02-01'::date,
  356000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jennifer Nuhma' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'John Alejandro Rios Gonzalez' LIMIT 1),
  NULL,
  '2026-02-15'::date,
  '2026-02-16'::date,
  128000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'John Alejandro Rios Gonzalez' LIMIT 1) IS NOT NULL
  AND '2026-02-16'::date > '2026-02-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Botero Botero' LIMIT 1),
  NULL,
  '2026-02-20'::date,
  '2026-02-21'::date,
  135000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Botero Botero' LIMIT 1) IS NOT NULL
  AND '2026-02-21'::date > '2026-02-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Marulanda' LIMIT 1),
  NULL,
  '2026-02-28'::date,
  '2026-03-01'::date,
  170000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Marulanda' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Wolfgang Buitrago' LIMIT 1),
  'Valeria Montoya',
  '2026-03-11'::date,
  '2026-03-13'::date,
  251560,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Wolfgang Buitrago' LIMIT 1) IS NOT NULL
  AND '2026-03-13'::date > '2026-03-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Duvan Felipe Palacio Ocampo' LIMIT 1),
  'Ana Sofia Salazar',
  '2026-03-13'::date,
  '2026-03-15'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Duvan Felipe Palacio Ocampo' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paula Ospina' LIMIT 1),
  'Beatriz',
  '2026-03-20'::date,
  '2026-03-22'::date,
  309878,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paula Ospina' LIMIT 1) IS NOT NULL
  AND '2026-03-22'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Felipe Mesa Londoño' LIMIT 1),
  'Alvarez Salinas Juan José',
  '2026-03-22'::date,
  '2026-03-23'::date,
  172032,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Felipe Mesa Londoño' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Bedoya' LIMIT 1),
  NULL,
  '2026-04-02'::date,
  '2026-04-04'::date,
  332683,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Bedoya' LIMIT 1) IS NOT NULL
  AND '2026-04-04'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Castellanos Restrepo' LIMIT 1),
  NULL,
  '2026-04-11'::date,
  '2026-04-12'::date,
  178327,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Castellanos Restrepo' LIMIT 1) IS NOT NULL
  AND '2026-04-12'::date > '2026-04-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Henao' LIMIT 1),
  NULL,
  '2026-04-18'::date,
  '2026-04-19'::date,
  169836,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Henao' LIMIT 1) IS NOT NULL
  AND '2026-04-19'::date > '2026-04-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Perez' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  169836,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Perez' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhon Alejandro Suarez Jimenez' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  169836,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhon Alejandro Suarez Jimenez' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Rodriguez Rendon' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-18'::date,
  297332,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Rodriguez Rendon' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Arias' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-23'::date,
  205450,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Arias' LIMIT 1) IS NOT NULL
  AND '2026-05-23'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 105),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Rodriguez' LIMIT 1),
  NULL,
  '2026-05-23'::date,
  '2026-05-24'::date,
  179487,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Pachon Perez' LIMIT 1),
  'Alexandra Silva',
  '2026-01-07'::date,
  '2026-01-12'::date,
  2780000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Pachon Perez' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nicolas Perez' LIMIT 1),
  NULL,
  '2026-01-14'::date,
  '2026-01-16'::date,
  359840,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nicolas Perez' LIMIT 1) IS NOT NULL
  AND '2026-01-16'::date > '2026-01-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Alejandro Diaz Pinilla' LIMIT 1),
  NULL,
  '2026-01-21'::date,
  '2026-01-22'::date,
  120931,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Alejandro Diaz Pinilla' LIMIT 1) IS NOT NULL
  AND '2026-01-22'::date > '2026-01-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Gallego Osma' LIMIT 1),
  NULL,
  '2026-02-07'::date,
  '2026-02-08'::date,
  164432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Gallego Osma' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adrian Felipe Bedoya Galindo' LIMIT 1),
  NULL,
  '2026-02-13'::date,
  '2026-02-14'::date,
  200540,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adrian Felipe Bedoya Galindo' LIMIT 1) IS NOT NULL
  AND '2026-02-14'::date > '2026-02-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Hannah Galeano' LIMIT 1),
  'Maria Helena Cortes Agudelo',
  '2026-03-13'::date,
  '2026-03-21'::date,
  944716,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Hannah Galeano' LIMIT 1) IS NOT NULL
  AND '2026-03-21'::date > '2026-03-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Sarria' LIMIT 1),
  NULL,
  '2026-03-21'::date,
  '2026-03-23'::date,
  359614,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Sarria' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'andres rodriguez' LIMIT 1),
  NULL,
  '2026-03-30'::date,
  '2026-04-02'::date,
  467471,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'andres rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-04-02'::date > '2026-03-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Lozano' LIMIT 1),
  'diana mrcela alzate',
  '2026-04-02'::date,
  '2026-04-04'::date,
  381788,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Lozano' LIMIT 1) IS NOT NULL
  AND '2026-04-04'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Emmanuel Rubiano' LIMIT 1),
  NULL,
  '2026-04-11'::date,
  '2026-04-13'::date,
  370305,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Emmanuel Rubiano' LIMIT 1) IS NOT NULL
  AND '2026-04-13'::date > '2026-04-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Gomez Gutierrez' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  156796,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Gomez Gutierrez' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edwin Garcia Garcia' LIMIT 1),
  NULL,
  '2026-04-29'::date,
  '2026-04-30'::date,
  156796,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edwin Garcia Garcia' LIMIT 1) IS NOT NULL
  AND '2026-04-30'::date > '2026-04-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuela Osorio' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-03'::date,
  313592,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuela Osorio' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Rodriguez Rendon' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-18'::date,
  297332,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Rodriguez Rendon' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Rojas Saraza' LIMIT 1),
  NULL,
  '2026-05-23'::date,
  '2026-05-24'::date,
  216582,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Rojas Saraza' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 106),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lucia Garcia Giraldo' LIMIT 1),
  NULL,
  '2026-05-26'::date,
  '2026-05-28'::date,
  385626,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lucia Garcia Giraldo' LIMIT 1) IS NOT NULL
  AND '2026-05-28'::date > '2026-05-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'daniela andrea ruiz' LIMIT 1),
  NULL,
  '2026-01-06'::date,
  '2026-01-07'::date,
  163088,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'daniela andrea ruiz' LIMIT 1) IS NOT NULL
  AND '2026-01-07'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Felipe Agurto' LIMIT 1),
  NULL,
  '2026-01-08'::date,
  '2026-01-11'::date,
  1050000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Felipe Agurto' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Beto Hidalgo' LIMIT 1),
  NULL,
  '2026-01-11'::date,
  '2026-01-12'::date,
  189920,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Beto Hidalgo' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Chaparro Lopez' LIMIT 1),
  'Diana Paola Duque',
  '2026-01-12'::date,
  '2026-01-13'::date,
  151040,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Chaparro Lopez' LIMIT 1) IS NOT NULL
  AND '2026-01-13'::date > '2026-01-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhon James Osorio' LIMIT 1),
  NULL,
  '2026-01-15'::date,
  '2026-01-16'::date,
  113280,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhon James Osorio' LIMIT 1) IS NOT NULL
  AND '2026-01-16'::date > '2026-01-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Mario Betancur Ortiz' LIMIT 1),
  'Maria Luisa Mesa',
  '2026-01-17'::date,
  '2026-01-18'::date,
  147440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Mario Betancur Ortiz' LIMIT 1) IS NOT NULL
  AND '2026-01-18'::date > '2026-01-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luis Eduardo Portocarrero' LIMIT 1),
  NULL,
  '2026-02-07'::date,
  '2026-02-08'::date,
  146378,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luis Eduardo Portocarrero' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga' LIMIT 1),
  NULL,
  '2026-02-12'::date,
  '2026-02-14'::date,
  237000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga' LIMIT 1) IS NOT NULL
  AND '2026-02-14'::date > '2026-02-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga' LIMIT 1),
  NULL,
  '2026-02-14'::date,
  '2026-02-16'::date,
  237000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga' LIMIT 1) IS NOT NULL
  AND '2026-02-16'::date > '2026-02-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga' LIMIT 1),
  NULL,
  '2026-02-16'::date,
  '2026-02-18'::date,
  262000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga' LIMIT 1) IS NOT NULL
  AND '2026-02-18'::date > '2026-02-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga' LIMIT 1),
  NULL,
  '2026-02-18'::date,
  '2026-02-21'::date,
  360000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yenny Andrea Alvarez Saldarriaga' LIMIT 1) IS NOT NULL
  AND '2026-02-21'::date > '2026-02-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Santacruz L' LIMIT 1),
  'Roiber Nuñez',
  '2026-02-27'::date,
  '2026-03-01'::date,
  220789,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Santacruz L' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristian Asprilla' LIMIT 1),
  NULL,
  '2026-03-14'::date,
  '2026-03-15'::date,
  140000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristian Asprilla' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Zapata Diossa' LIMIT 1),
  NULL,
  '2026-03-18'::date,
  '2026-03-22'::date,
  517871,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Zapata Diossa' LIMIT 1) IS NOT NULL
  AND '2026-03-22'::date > '2026-03-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kerstinck Sarmiento' LIMIT 1),
  NULL,
  '2026-03-22'::date,
  '2026-03-24'::date,
  158123,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kerstinck Sarmiento' LIMIT 1) IS NOT NULL
  AND '2026-03-24'::date > '2026-03-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Alvarez Uribe' LIMIT 1),
  'daniela cruz',
  '2026-04-01'::date,
  '2026-04-03'::date,
  315295,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Alvarez Uribe' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Duque Gallego' LIMIT 1),
  NULL,
  '2026-04-10'::date,
  '2026-04-12'::date,
  267960,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Duque Gallego' LIMIT 1) IS NOT NULL
  AND '2026-04-12'::date > '2026-04-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan camilo Casas Castillo' LIMIT 1),
  NULL,
  '2026-04-16'::date,
  '2026-04-18'::date,
  255200,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan camilo Casas Castillo' LIMIT 1) IS NOT NULL
  AND '2026-04-18'::date > '2026-04-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steven Escobar Castaño' LIMIT 1),
  NULL,
  '2026-04-18'::date,
  '2026-04-19'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steven Escobar Castaño' LIMIT 1) IS NOT NULL
  AND '2026-04-19'::date > '2026-04-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Barragan' LIMIT 1),
  NULL,
  '2026-04-20'::date,
  '2026-04-21'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Barragan' LIMIT 1) IS NOT NULL
  AND '2026-04-21'::date > '2026-04-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Addy Dayana Luna Drith' LIMIT 1),
  NULL,
  '2026-04-23'::date,
  '2026-04-24'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Addy Dayana Luna Drith' LIMIT 1) IS NOT NULL
  AND '2026-04-24'::date > '2026-04-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Marin Tobar' LIMIT 1),
  NULL,
  '2026-04-24'::date,
  '2026-04-25'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Marin Tobar' LIMIT 1) IS NOT NULL
  AND '2026-04-25'::date > '2026-04-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Robinson Diaz' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  122815,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Robinson Diaz' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edwar Salaza' LIMIT 1),
  NULL,
  '2026-04-27'::date,
  '2026-04-28'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edwar Salaza' LIMIT 1) IS NOT NULL
  AND '2026-04-28'::date > '2026-04-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Carolina Guerrero Rodriguez' LIMIT 1),
  NULL,
  '2026-04-29'::date,
  '2026-05-01'::date,
  255200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Carolina Guerrero Rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-05-01'::date > '2026-04-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Cardona Quintero' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  166595,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Cardona Quintero' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Valencia Salazar' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Valencia Salazar' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Alejandro Restrepo Garcia' LIMIT 1),
  NULL,
  '2026-05-08'::date,
  '2026-05-09'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Alejandro Restrepo Garcia' LIMIT 1) IS NOT NULL
  AND '2026-05-09'::date > '2026-05-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'montoya lopez vianey' LIMIT 1),
  NULL,
  '2026-05-10'::date,
  '2026-05-11'::date,
  141000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'montoya lopez vianey' LIMIT 1) IS NOT NULL
  AND '2026-05-11'::date > '2026-05-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yeiny Covaleda Guzman' LIMIT 1),
  NULL,
  '2026-05-12'::date,
  '2026-05-14'::date,
  245630,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yeiny Covaleda Guzman' LIMIT 1) IS NOT NULL
  AND '2026-05-14'::date > '2026-05-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jaime Mariottyz' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-16'::date,
  122815,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jaime Mariottyz' LIMIT 1) IS NOT NULL
  AND '2026-05-16'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Rodriguez Rendon' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-18'::date,
  297332,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Rodriguez Rendon' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Arboleda' LIMIT 1),
  NULL,
  '2026-05-18'::date,
  '2026-05-19'::date,
  152600,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Arboleda' LIMIT 1) IS NOT NULL
  AND '2026-05-19'::date > '2026-05-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luz Darly Reyes Guzman' LIMIT 1),
  NULL,
  '2026-05-20'::date,
  '2026-05-21'::date,
  147018,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luz Darly Reyes Guzman' LIMIT 1) IS NOT NULL
  AND '2026-05-21'::date > '2026-05-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sharin Tacha' LIMIT 1),
  NULL,
  '2026-05-21'::date,
  '2026-05-22'::date,
  165360,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sharin Tacha' LIMIT 1) IS NOT NULL
  AND '2026-05-22'::date > '2026-05-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brian Alexander Reyes Giraldo' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-24'::date,
  275415,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brian Alexander Reyes Giraldo' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 107),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Aleyda Marcela Bechara Cordoba' LIMIT 1),
  NULL,
  '2026-05-24'::date,
  '2026-05-29'::date,
  488070,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Aleyda Marcela Bechara Cordoba' LIMIT 1) IS NOT NULL
  AND '2026-05-29'::date > '2026-05-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Quinche' LIMIT 1),
  'Diana Rodriguez',
  '2026-01-03'::date,
  '2026-01-05'::date,
  404188,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Quinche' LIMIT 1) IS NOT NULL
  AND '2026-01-05'::date > '2026-01-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Marco Garcia' LIMIT 1),
  'Sandra',
  '2026-01-08'::date,
  '2026-01-11'::date,
  1457900,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Marco Garcia' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lisseth Carolina Guerrero Sierra' LIMIT 1),
  'Vercher Folgado',
  '2026-01-11'::date,
  '2026-01-13'::date,
  402320,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lisseth Carolina Guerrero Sierra' LIMIT 1) IS NOT NULL
  AND '2026-01-13'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mitchell Simpson' LIMIT 1),
  NULL,
  '2026-01-20'::date,
  '2026-01-23'::date,
  431631,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mitchell Simpson' LIMIT 1) IS NOT NULL
  AND '2026-01-23'::date > '2026-01-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Rafael Quezada' LIMIT 1),
  NULL,
  '2026-01-24'::date,
  '2026-01-26'::date,
  423560,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Rafael Quezada' LIMIT 1) IS NOT NULL
  AND '2026-01-26'::date > '2026-01-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Gomez Gutierrez' LIMIT 1),
  'Sindy Mariana Grueso',
  '2026-01-31'::date,
  '2026-02-01'::date,
  186734,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Gomez Gutierrez' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cesar Osorio' LIMIT 1),
  NULL,
  '2026-02-04'::date,
  '2026-02-05'::date,
  186734,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cesar Osorio' LIMIT 1) IS NOT NULL
  AND '2026-02-05'::date > '2026-02-04'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Giraldo Morales' LIMIT 1),
  NULL,
  '2026-02-06'::date,
  '2026-02-07'::date,
  161723,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Giraldo Morales' LIMIT 1) IS NOT NULL
  AND '2026-02-07'::date > '2026-02-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Joe Rico' LIMIT 1),
  NULL,
  '2026-02-12'::date,
  '2026-02-17'::date,
  836996,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Joe Rico' LIMIT 1) IS NOT NULL
  AND '2026-02-17'::date > '2026-02-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Isabella Hurtado Medina' LIMIT 1),
  'Cristian Morales',
  '2026-02-19'::date,
  '2026-02-21'::date,
  358468,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Isabella Hurtado Medina' LIMIT 1) IS NOT NULL
  AND '2026-02-21'::date > '2026-02-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Wendy Guzman' LIMIT 1),
  NULL,
  '2026-02-21'::date,
  '2026-02-22'::date,
  191734,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Wendy Guzman' LIMIT 1) IS NOT NULL
  AND '2026-02-22'::date > '2026-02-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Jose Sierra' LIMIT 1),
  NULL,
  '2026-02-27'::date,
  '2026-02-28'::date,
  170000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Jose Sierra' LIMIT 1) IS NOT NULL
  AND '2026-02-28'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Jose Sierra' LIMIT 1),
  NULL,
  '2026-02-28'::date,
  '2026-03-01'::date,
  170000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Jose Sierra' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'esteban cardona' LIMIT 1),
  NULL,
  '2026-03-12'::date,
  '2026-03-13'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'esteban cardona' LIMIT 1) IS NOT NULL
  AND '2026-03-13'::date > '2026-03-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Jesús Molano Acelas' LIMIT 1),
  NULL,
  '2026-03-13'::date,
  '2026-03-15'::date,
  359880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Jesús Molano Acelas' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Velasquez' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-21'::date,
  230000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Velasquez' LIMIT 1) IS NOT NULL
  AND '2026-03-21'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maycoll Denis Toro Salazar' LIMIT 1),
  'carolina Zuluaga aristizabal',
  '2026-03-21'::date,
  '2026-03-23'::date,
  319966,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maycoll Denis Toro Salazar' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Camila Echeverri' LIMIT 1),
  NULL,
  '2026-03-27'::date,
  '2026-03-29'::date,
  308200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Camila Echeverri' LIMIT 1) IS NOT NULL
  AND '2026-03-29'::date > '2026-03-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'wendy dayana yepes sorio' LIMIT 1),
  NULL,
  '2026-04-01'::date,
  '2026-04-02'::date,
  155000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'wendy dayana yepes sorio' LIMIT 1) IS NOT NULL
  AND '2026-04-02'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mariana Hernandez restrepo' LIMIT 1),
  'santiago hernandez',
  '2026-04-02'::date,
  '2026-04-03'::date,
  155000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mariana Hernandez restrepo' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Valencia Castaño' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  137196,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Valencia Castaño' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Cadavid Gomez' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  166595,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Cadavid Gomez' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Silvana Montoya' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  166595,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Silvana Montoya' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Catalina Gomez' LIMIT 1),
  NULL,
  '2026-05-09'::date,
  '2026-05-10'::date,
  181796,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Catalina Gomez' LIMIT 1) IS NOT NULL
  AND '2026-05-10'::date > '2026-05-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'catalina gomez' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-17'::date,
  377791,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'catalina gomez' LIMIT 1) IS NOT NULL
  AND '2026-05-17'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luis Marin Botero' LIMIT 1),
  NULL,
  '2026-05-18'::date,
  '2026-05-19'::date,
  175000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luis Marin Botero' LIMIT 1) IS NOT NULL
  AND '2026-05-19'::date > '2026-05-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Romulo Hernandez' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-24'::date,
  385626,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Romulo Hernandez' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 201),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Torres' LIMIT 1),
  NULL,
  '2026-05-28'::date,
  '2026-05-31'::date,
  524787,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Torres' LIMIT 1) IS NOT NULL
  AND '2026-05-31'::date > '2026-05-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Hernandez' LIMIT 1),
  'Maria fernanda Gonzales',
  '2026-01-02'::date,
  '2026-01-05'::date,
  664280,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Hernandez' LIMIT 1) IS NOT NULL
  AND '2026-01-05'::date > '2026-01-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Antonio Sands Porras' LIMIT 1),
  'Maria Estrada Robledo',
  '2026-01-08'::date,
  '2026-01-09'::date,
  256000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Antonio Sands Porras' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'santiago botero' LIMIT 1),
  'maria jose botero',
  '2026-01-09'::date,
  '2026-01-12'::date,
  1394464,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'santiago botero' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Alexander Vasquez Murcia' LIMIT 1),
  NULL,
  '2026-01-24'::date,
  '2026-01-25'::date,
  149139,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Alexander Vasquez Murcia' LIMIT 1) IS NOT NULL
  AND '2026-01-25'::date > '2026-01-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kelly Alexandra Alzate Marin' LIMIT 1),
  NULL,
  '2026-02-01'::date,
  '2026-02-02'::date,
  140000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kelly Alexandra Alzate Marin' LIMIT 1) IS NOT NULL
  AND '2026-02-02'::date > '2026-02-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brayan Duque galvis' LIMIT 1),
  NULL,
  '2026-02-14'::date,
  '2026-02-15'::date,
  125000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brayan Duque galvis' LIMIT 1) IS NOT NULL
  AND '2026-02-15'::date > '2026-02-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Henry Enrique Sanchez' LIMIT 1),
  NULL,
  '2026-03-01'::date,
  '2026-03-04'::date,
  375460,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Henry Enrique Sanchez' LIMIT 1) IS NOT NULL
  AND '2026-03-04'::date > '2026-03-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Villada Zuluaga' LIMIT 1),
  NULL,
  '2026-03-12'::date,
  '2026-03-13'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Villada Zuluaga' LIMIT 1) IS NOT NULL
  AND '2026-03-13'::date > '2026-03-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andy Lind' LIMIT 1),
  NULL,
  '2026-03-16'::date,
  '2026-03-17'::date,
  166600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andy Lind' LIMIT 1) IS NOT NULL
  AND '2026-03-17'::date > '2026-03-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés Valencia' LIMIT 1),
  'acero milena',
  '2026-03-20'::date,
  '2026-03-21'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés Valencia' LIMIT 1) IS NOT NULL
  AND '2026-03-21'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nataly Paredes' LIMIT 1),
  NULL,
  '2026-03-21'::date,
  '2026-03-23'::date,
  294111,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nataly Paredes' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Esteban Lopez valencia' LIMIT 1),
  'ramirez valeria',
  '2026-03-26'::date,
  '2026-03-27'::date,
  150000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Esteban Lopez valencia' LIMIT 1) IS NOT NULL
  AND '2026-03-27'::date > '2026-03-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Pinilla' LIMIT 1),
  NULL,
  '2026-03-28'::date,
  '2026-03-31'::date,
  416424,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Pinilla' LIMIT 1) IS NOT NULL
  AND '2026-03-31'::date > '2026-03-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jesús Ospina Atehortua' LIMIT 1),
  NULL,
  '2026-03-31'::date,
  '2026-04-01'::date,
  173680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jesús Ospina Atehortua' LIMIT 1) IS NOT NULL
  AND '2026-04-01'::date > '2026-03-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Castro Hernandez' LIMIT 1),
  NULL,
  '2026-04-01'::date,
  '2026-04-02'::date,
  173680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Castro Hernandez' LIMIT 1) IS NOT NULL
  AND '2026-04-02'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Johnnatan Delgado' LIMIT 1),
  NULL,
  '2026-04-02'::date,
  '2026-04-05'::date,
  516180,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Johnnatan Delgado' LIMIT 1) IS NOT NULL
  AND '2026-04-05'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Leandro Soto' LIMIT 1),
  NULL,
  '2026-04-10'::date,
  '2026-04-11'::date,
  164635,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Leandro Soto' LIMIT 1) IS NOT NULL
  AND '2026-04-11'::date > '2026-04-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Cardona' LIMIT 1),
  NULL,
  '2026-04-19'::date,
  '2026-04-20'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Cardona' LIMIT 1) IS NOT NULL
  AND '2026-04-20'::date > '2026-04-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Magda Johana Oviedo Franco' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  156796,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Magda Johana Oviedo Franco' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Ramirez' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  137196,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Ramirez' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Fernanda Muñoz' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  166595,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Fernanda Muñoz' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Theresa Noll' LIMIT 1),
  NULL,
  '2026-05-10'::date,
  '2026-05-11'::date,
  165432,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Theresa Noll' LIMIT 1) IS NOT NULL
  AND '2026-05-11'::date > '2026-05-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camila Arboleda Mira' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-16'::date,
  208260,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camila Arboleda Mira' LIMIT 1) IS NOT NULL
  AND '2026-05-16'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mauricio Palma' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-17'::date,
  197480,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mauricio Palma' LIMIT 1) IS NOT NULL
  AND '2026-05-17'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 202),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paula Gomez' LIMIT 1),
  NULL,
  '2026-05-17'::date,
  '2026-05-18'::date,
  208260,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paula Gomez' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Recio' LIMIT 1),
  'Leidy Vanegas',
  '2026-01-04'::date,
  '2026-01-05'::date,
  160000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Recio' LIMIT 1) IS NOT NULL
  AND '2026-01-05'::date > '2026-01-04'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tatiana Leon Leon' LIMIT 1),
  NULL,
  '2026-01-05'::date,
  '2026-01-06'::date,
  160000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tatiana Leon Leon' LIMIT 1) IS NOT NULL
  AND '2026-01-06'::date > '2026-01-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Marcela Garcia' LIMIT 1),
  'Mauricio Ramirez',
  '2026-01-06'::date,
  '2026-01-07'::date,
  225000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Marcela Garcia' LIMIT 1) IS NOT NULL
  AND '2026-01-07'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Loaiza' LIMIT 1),
  NULL,
  '2026-01-07'::date,
  '2026-01-09'::date,
  450000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Loaiza' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Niño' LIMIT 1),
  'Maria Jose Fajardo Jaramillo',
  '2026-01-09'::date,
  '2026-01-11'::date,
  779200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Niño' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alexandra Valencia Quintero' LIMIT 1),
  NULL,
  '2026-01-11'::date,
  '2026-01-12'::date,
  169920,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alexandra Valencia Quintero' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrey Muñoz' LIMIT 1),
  'Kerly Trujillo',
  '2026-01-12'::date,
  '2026-01-13'::date,
  169920,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrey Muñoz' LIMIT 1) IS NOT NULL
  AND '2026-01-13'::date > '2026-01-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Ospina' LIMIT 1),
  NULL,
  '2026-01-16'::date,
  '2026-01-17'::date,
  148680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Ospina' LIMIT 1) IS NOT NULL
  AND '2026-01-17'::date > '2026-01-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1),
  NULL,
  '2026-01-17'::date,
  '2026-01-18'::date,
  148680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1) IS NOT NULL
  AND '2026-01-18'::date > '2026-01-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Gómez Salazar' LIMIT 1),
  'María Teresa Gómez Salazar',
  '2026-01-20'::date,
  '2026-01-21'::date,
  127440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Gómez Salazar' LIMIT 1) IS NOT NULL
  AND '2026-01-21'::date > '2026-01-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sergio Nieto Giraldo' LIMIT 1),
  NULL,
  '2026-01-21'::date,
  '2026-01-22'::date,
  127440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sergio Nieto Giraldo' LIMIT 1) IS NOT NULL
  AND '2026-01-22'::date > '2026-01-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Fernanda Diaz Amador' LIMIT 1),
  'Wilson Jafet Cubides Montes',
  '2026-01-22'::date,
  '2026-01-23'::date,
  127440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Fernanda Diaz Amador' LIMIT 1) IS NOT NULL
  AND '2026-01-23'::date > '2026-01-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Melissa Ramos Lemos' LIMIT 1),
  'Marcela Carolina Espitia',
  '2026-01-23'::date,
  '2026-01-24'::date,
  127440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Melissa Ramos Lemos' LIMIT 1) IS NOT NULL
  AND '2026-01-24'::date > '2026-01-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Díaz Castaño' LIMIT 1),
  'Paola Grisales Correa',
  '2026-01-24'::date,
  '2026-01-25'::date,
  153990,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Díaz Castaño' LIMIT 1) IS NOT NULL
  AND '2026-01-25'::date > '2026-01-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Rincón' LIMIT 1),
  'Jesus David Cifuentes',
  '2026-01-25'::date,
  '2026-01-26'::date,
  153990,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Rincón' LIMIT 1) IS NOT NULL
  AND '2026-01-26'::date > '2026-01-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andee Zeta' LIMIT 1),
  NULL,
  '2026-01-28'::date,
  '2026-01-29'::date,
  123192,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andee Zeta' LIMIT 1) IS NOT NULL
  AND '2026-01-29'::date > '2026-01-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andee Zeta' LIMIT 1),
  NULL,
  '2026-01-29'::date,
  '2026-01-30'::date,
  120000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andee Zeta' LIMIT 1) IS NOT NULL
  AND '2026-01-30'::date > '2026-01-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mauricio Suarez Perdomo' LIMIT 1),
  'Claudia Gonzalez Valencia',
  '2026-01-30'::date,
  '2026-02-01'::date,
  277182,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mauricio Suarez Perdomo' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angelica Arango Gutiérrez' LIMIT 1),
  NULL,
  '2026-02-05'::date,
  '2026-02-06'::date,
  138591,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angelica Arango Gutiérrez' LIMIT 1) IS NOT NULL
  AND '2026-02-06'::date > '2026-02-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Ocampo' LIMIT 1),
  'Piedad Zapata',
  '2026-02-06'::date,
  '2026-02-07'::date,
  138591,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Ocampo' LIMIT 1) IS NOT NULL
  AND '2026-02-07'::date > '2026-02-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lorenza García' LIMIT 1),
  NULL,
  '2026-02-08'::date,
  '2026-02-09'::date,
  128324,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lorenza García' LIMIT 1) IS NOT NULL
  AND '2026-02-09'::date > '2026-02-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel F Garizao' LIMIT 1),
  NULL,
  '2026-02-12'::date,
  '2026-02-13'::date,
  138591,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel F Garizao' LIMIT 1) IS NOT NULL
  AND '2026-02-13'::date > '2026-02-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Aguirre' LIMIT 1),
  'Ana Mileidy Giraldo',
  '2026-02-13'::date,
  '2026-02-15'::date,
  307980,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Aguirre' LIMIT 1) IS NOT NULL
  AND '2026-02-15'::date > '2026-02-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Javier Colon' LIMIT 1),
  'Carolina Sanchez',
  '2026-02-19'::date,
  '2026-02-21'::date,
  342200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Javier Colon' LIMIT 1) IS NOT NULL
  AND '2026-02-21'::date > '2026-02-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Murillo Ospina' LIMIT 1),
  NULL,
  '2026-02-21'::date,
  '2026-02-23'::date,
  307980,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Murillo Ospina' LIMIT 1) IS NOT NULL
  AND '2026-02-23'::date > '2026-02-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Aled Johnson' LIMIT 1),
  NULL,
  '2026-02-26'::date,
  '2026-03-01'::date,
  350460,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Aled Johnson' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brayan Medicis' LIMIT 1),
  NULL,
  '2026-03-03'::date,
  '2026-03-04'::date,
  145000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brayan Medicis' LIMIT 1) IS NOT NULL
  AND '2026-03-04'::date > '2026-03-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Rico' LIMIT 1),
  NULL,
  '2026-03-05'::date,
  '2026-03-07'::date,
  258640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Rico' LIMIT 1) IS NOT NULL
  AND '2026-03-07'::date > '2026-03-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Prado' LIMIT 1),
  'Valentina Pinilla',
  '2026-03-08'::date,
  '2026-03-09'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Prado' LIMIT 1) IS NOT NULL
  AND '2026-03-09'::date > '2026-03-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Corinna Spruss' LIMIT 1),
  NULL,
  '2026-03-09'::date,
  '2026-03-14'::date,
  700398,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Corinna Spruss' LIMIT 1) IS NOT NULL
  AND '2026-03-14'::date > '2026-03-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Díaz' LIMIT 1),
  NULL,
  '2026-03-14'::date,
  '2026-03-16'::date,
  258640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Díaz' LIMIT 1) IS NOT NULL
  AND '2026-03-16'::date > '2026-03-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Humberto Díaz Uribe' LIMIT 1),
  NULL,
  '2026-03-16'::date,
  '2026-03-17'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Humberto Díaz Uribe' LIMIT 1) IS NOT NULL
  AND '2026-03-17'::date > '2026-03-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Felipe Charry' LIMIT 1),
  NULL,
  '2026-03-17'::date,
  '2026-03-18'::date,
  141000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Felipe Charry' LIMIT 1) IS NOT NULL
  AND '2026-03-18'::date > '2026-03-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paulina Orozco Viana' LIMIT 1),
  'José Manuel Buitrago Alzate',
  '2026-03-19'::date,
  '2026-03-21'::date,
  269513,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paulina Orozco Viana' LIMIT 1) IS NOT NULL
  AND '2026-03-21'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Liliana Carolina Cortes Velasquez' LIMIT 1),
  NULL,
  '2026-03-21'::date,
  '2026-03-23'::date,
  309186,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Liliana Carolina Cortes Velasquez' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Gabriel Alzate Gallego' LIMIT 1),
  NULL,
  '2026-03-25'::date,
  '2026-03-27'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Gabriel Alzate Gallego' LIMIT 1) IS NOT NULL
  AND '2026-03-27'::date > '2026-03-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alexandra Castañeda' LIMIT 1),
  NULL,
  '2026-03-27'::date,
  '2026-03-29'::date,
  288243,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alexandra Castañeda' LIMIT 1) IS NOT NULL
  AND '2026-03-29'::date > '2026-03-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'María De Los Angeles Pavas Marin' LIMIT 1),
  'luis garcia',
  '2026-03-30'::date,
  '2026-03-31'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'María De Los Angeles Pavas Marin' LIMIT 1) IS NOT NULL
  AND '2026-03-31'::date > '2026-03-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Stephanny Agudelo Osorio' LIMIT 1),
  NULL,
  '2026-03-31'::date,
  '2026-04-02'::date,
  290500,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Stephanny Agudelo Osorio' LIMIT 1) IS NOT NULL
  AND '2026-04-02'::date > '2026-03-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Camila Ortiz Tasama' LIMIT 1),
  NULL,
  '2026-04-02'::date,
  '2026-04-04'::date,
  324978,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Camila Ortiz Tasama' LIMIT 1) IS NOT NULL
  AND '2026-04-04'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ivan Santiago Rios' LIMIT 1),
  NULL,
  '2026-04-08'::date,
  '2026-04-09'::date,
  175000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ivan Santiago Rios' LIMIT 1) IS NOT NULL
  AND '2026-04-09'::date > '2026-04-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jefferson Arteaga' LIMIT 1),
  NULL,
  '2026-04-17'::date,
  '2026-04-18'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jefferson Arteaga' LIMIT 1) IS NOT NULL
  AND '2026-04-18'::date > '2026-04-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Gomez' LIMIT 1),
  NULL,
  '2026-04-18'::date,
  '2026-04-19'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Gomez' LIMIT 1) IS NOT NULL
  AND '2026-04-19'::date > '2026-04-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tangarife Julian' LIMIT 1),
  NULL,
  '2026-04-21'::date,
  '2026-04-24'::date,
  421296,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tangarife Julian' LIMIT 1) IS NOT NULL
  AND '2026-04-24'::date > '2026-04-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Orlando Marin' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Orlando Marin' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yuliana Herrera' LIMIT 1),
  NULL,
  '2026-04-30'::date,
  '2026-05-03'::date,
  416029,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yuliana Herrera' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-04-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1),
  NULL,
  '2026-05-05'::date,
  '2026-05-06'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1) IS NOT NULL
  AND '2026-05-06'::date > '2026-05-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhonatan Rodriguez' LIMIT 1),
  NULL,
  '2026-05-09'::date,
  '2026-05-10'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhonatan Rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-05-10'::date > '2026-05-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Raul Forjan' LIMIT 1),
  NULL,
  '2026-05-13'::date,
  '2026-05-15'::date,
  305864,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Raul Forjan' LIMIT 1) IS NOT NULL
  AND '2026-05-15'::date > '2026-05-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés López Alzate' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-17'::date,
  305864,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés López Alzate' LIMIT 1) IS NOT NULL
  AND '2026-05-17'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edward Agudelo Aristizabal' LIMIT 1),
  NULL,
  '2026-05-17'::date,
  '2026-05-18'::date,
  165432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edward Agudelo Aristizabal' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'vicente lancheros' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-23'::date,
  160000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'vicente lancheros' LIMIT 1) IS NOT NULL
  AND '2026-05-23'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Isabella Lemos' LIMIT 1),
  NULL,
  '2026-05-23'::date,
  '2026-05-25'::date,
  295331,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Isabella Lemos' LIMIT 1) IS NOT NULL
  AND '2026-05-25'::date > '2026-05-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1),
  NULL,
  '2026-05-25'::date,
  '2026-05-26'::date,
  179487,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1) IS NOT NULL
  AND '2026-05-26'::date > '2026-05-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 203),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'mariana giraldo' LIMIT 1),
  NULL,
  '2026-05-27'::date,
  '2026-06-01'::date,
  799716,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'mariana giraldo' LIMIT 1) IS NOT NULL
  AND '2026-06-01'::date > '2026-05-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Andrea Ruiz Guzman' LIMIT 1),
  NULL,
  '2026-01-05'::date,
  '2026-01-06'::date,
  130488,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Andrea Ruiz Guzman' LIMIT 1) IS NOT NULL
  AND '2026-01-06'::date > '2026-01-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Andrea Ruiz Guzman' LIMIT 1),
  NULL,
  '2026-01-06'::date,
  '2026-01-07'::date,
  200000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Andrea Ruiz Guzman' LIMIT 1) IS NOT NULL
  AND '2026-01-07'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Wills Danns' LIMIT 1),
  NULL,
  '2026-01-08'::date,
  '2026-01-11'::date,
  1050000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Wills Danns' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Antonio Aristizabal' LIMIT 1),
  NULL,
  '2026-01-11'::date,
  '2026-01-12'::date,
  223904,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Antonio Aristizabal' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Diaz' LIMIT 1),
  NULL,
  '2026-01-12'::date,
  '2026-01-13'::date,
  150000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Diaz' LIMIT 1) IS NOT NULL
  AND '2026-01-13'::date > '2026-01-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sivan Tas' LIMIT 1),
  NULL,
  '2026-01-24'::date,
  '2026-01-26'::date,
  231456,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sivan Tas' LIMIT 1) IS NOT NULL
  AND '2026-01-26'::date > '2026-01-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Ocampo' LIMIT 1),
  NULL,
  '2026-01-30'::date,
  '2026-01-31'::date,
  170000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Ocampo' LIMIT 1) IS NOT NULL
  AND '2026-01-31'::date > '2026-01-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steve Rodriguez' LIMIT 1),
  'Jackeline Cifuentes',
  '2026-02-03'::date,
  '2026-02-05'::date,
  317360,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steve Rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-02-05'::date > '2026-02-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nicol Ortiz' LIMIT 1),
  'Vanessa Calderon',
  '2026-02-07'::date,
  '2026-02-08'::date,
  153990,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nicol Ortiz' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Cardenas Valencia' LIMIT 1),
  NULL,
  '2026-02-11'::date,
  '2026-02-12'::date,
  129033,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Cardenas Valencia' LIMIT 1) IS NOT NULL
  AND '2026-02-12'::date > '2026-02-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kelly Alexandra Alzate Marin' LIMIT 1),
  NULL,
  '2026-02-12'::date,
  '2026-02-13'::date,
  140000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kelly Alexandra Alzate Marin' LIMIT 1) IS NOT NULL
  AND '2026-02-13'::date > '2026-02-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Herrera' LIMIT 1),
  NULL,
  '2026-02-22'::date,
  '2026-02-23'::date,
  148680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Herrera' LIMIT 1) IS NOT NULL
  AND '2026-02-23'::date > '2026-02-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Marulanda Lòpez' LIMIT 1),
  NULL,
  '2026-03-01'::date,
  '2026-03-02'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Marulanda Lòpez' LIMIT 1) IS NOT NULL
  AND '2026-03-02'::date > '2026-03-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gerold Mairhofer' LIMIT 1),
  NULL,
  '2026-03-11'::date,
  '2026-03-14'::date,
  412876,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gerold Mairhofer' LIMIT 1) IS NOT NULL
  AND '2026-03-14'::date > '2026-03-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Viviana Mora Ospina' LIMIT 1),
  NULL,
  '2026-03-14'::date,
  '2026-03-16'::date,
  258640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Viviana Mora Ospina' LIMIT 1) IS NOT NULL
  AND '2026-03-16'::date > '2026-03-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Valentina Conde Andrade' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-22'::date,
  275907,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Valentina Conde Andrade' LIMIT 1) IS NOT NULL
  AND '2026-03-22'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Panesso Cortes' LIMIT 1),
  'Jorge Luis Castro Giraldo',
  '2026-03-22'::date,
  '2026-03-23'::date,
  158128,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Panesso Cortes' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'vanessa tabares' LIMIT 1),
  NULL,
  '2026-03-25'::date,
  '2026-03-26'::date,
  155000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'vanessa tabares' LIMIT 1) IS NOT NULL
  AND '2026-03-26'::date > '2026-03-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Franco' LIMIT 1),
  NULL,
  '2026-03-28'::date,
  '2026-03-29'::date,
  187797,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Franco' LIMIT 1) IS NOT NULL
  AND '2026-03-29'::date > '2026-03-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Raffa Valencia' LIMIT 1),
  'leonardo diaz',
  '2026-04-01'::date,
  '2026-04-03'::date,
  298510,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Raffa Valencia' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Pains' LIMIT 1),
  NULL,
  '2026-04-17'::date,
  '2026-04-18'::date,
  144626,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Pains' LIMIT 1) IS NOT NULL
  AND '2026-04-18'::date > '2026-04-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nikole Somerson' LIMIT 1),
  NULL,
  '2026-04-18'::date,
  '2026-04-20'::date,
  280864,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nikole Somerson' LIMIT 1) IS NOT NULL
  AND '2026-04-20'::date > '2026-04-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'JOHAN PACHON' LIMIT 1),
  NULL,
  '2026-04-23'::date,
  '2026-04-24'::date,
  166050,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'JOHAN PACHON' LIMIT 1) IS NOT NULL
  AND '2026-04-24'::date > '2026-04-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yoannys Hernández' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-28'::date,
  421296,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yoannys Hernández' LIMIT 1) IS NOT NULL
  AND '2026-04-28'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Echeverria Pelaez' LIMIT 1),
  NULL,
  '2026-04-30'::date,
  '2026-05-01'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Echeverria Pelaez' LIMIT 1) IS NOT NULL
  AND '2026-05-01'::date > '2026-04-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'marlon baquero' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-03'::date,
  207332,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'marlon baquero' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'anyeli flores' LIMIT 1),
  NULL,
  '2026-05-07'::date,
  '2026-05-08'::date,
  150000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'anyeli flores' LIMIT 1) IS NOT NULL
  AND '2026-05-08'::date > '2026-05-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Sofia Leon Londoño' LIMIT 1),
  NULL,
  '2026-05-09'::date,
  '2026-05-10'::date,
  122878,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Sofia Leon Londoño' LIMIT 1) IS NOT NULL
  AND '2026-05-10'::date > '2026-05-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'maria paula marin vitola' LIMIT 1),
  NULL,
  '2026-05-13'::date,
  '2026-05-14'::date,
  147878,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'maria paula marin vitola' LIMIT 1) IS NOT NULL
  AND '2026-05-14'::date > '2026-05-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Felipe Díaz Gómez' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-18'::date,
  405497,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Felipe Díaz Gómez' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Satizabal Alejo' LIMIT 1),
  NULL,
  '2026-05-23'::date,
  '2026-05-24'::date,
  179487,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Satizabal Alejo' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 204),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'martha tarola' LIMIT 1),
  NULL,
  '2026-05-28'::date,
  '2026-05-29'::date,
  147815,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'martha tarola' LIMIT 1) IS NOT NULL
  AND '2026-05-29'::date > '2026-05-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhonatan Gallego' LIMIT 1),
  'Leidy Jhoana Lada',
  '2026-01-02'::date,
  '2026-01-04'::date,
  542363,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhonatan Gallego' LIMIT 1) IS NOT NULL
  AND '2026-01-04'::date > '2026-01-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yulitza Valencia' LIMIT 1),
  NULL,
  '2026-01-06'::date,
  '2026-01-07'::date,
  303200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yulitza Valencia' LIMIT 1) IS NOT NULL
  AND '2026-01-07'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Emerson Perez' LIMIT 1),
  NULL,
  '2026-01-08'::date,
  '2026-01-09'::date,
  352849,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Emerson Perez' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ricardo Prieto' LIMIT 1),
  'Diana Gordillo',
  '2026-01-09'::date,
  '2026-01-12'::date,
  1512464,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ricardo Prieto' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Herrera Marin' LIMIT 1),
  'Gabriela Rojas Calleja',
  '2026-02-28'::date,
  '2026-03-01'::date,
  168752,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Herrera Marin' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Marian Rodriguez Buitrago' LIMIT 1),
  'Julian Pelufo',
  '2026-03-05'::date,
  '2026-03-12'::date,
  793618,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Marian Rodriguez Buitrago' LIMIT 1) IS NOT NULL
  AND '2026-03-12'::date > '2026-03-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Finca Victoria' LIMIT 1),
  'Lizet acevedo, veronica torres',
  '2026-03-12'::date,
  '2026-03-15'::date,
  527320,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Finca Victoria' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'ALEJANDRO DIAZ CAMBIO' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-23'::date,
  450000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'ALEJANDRO DIAZ CAMBIO' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'mateo rojas zaraza' LIMIT 1),
  NULL,
  '2026-03-28'::date,
  '2026-03-29'::date,
  192860,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'mateo rojas zaraza' LIMIT 1) IS NOT NULL
  AND '2026-03-29'::date > '2026-03-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'diana clavijo' LIMIT 1),
  NULL,
  '2026-03-31'::date,
  '2026-04-03'::date,
  472507,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'diana clavijo' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-03-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yunes Elamin' LIMIT 1),
  NULL,
  '2026-04-23'::date,
  '2026-04-25'::date,
  339672,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yunes Elamin' LIMIT 1) IS NOT NULL
  AND '2026-04-25'::date > '2026-04-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Junior Mejia' LIMIT 1),
  NULL,
  '2026-04-26'::date,
  '2026-04-27'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Junior Mejia' LIMIT 1) IS NOT NULL
  AND '2026-04-27'::date > '2026-04-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Narenn Santiago Charry Lombana' LIMIT 1),
  NULL,
  '2026-04-28'::date,
  '2026-04-30'::date,
  299704,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Narenn Santiago Charry Lombana' LIMIT 1) IS NOT NULL
  AND '2026-04-30'::date > '2026-04-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Londoño' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  180450,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Londoño' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Vasquez' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  180450,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Vasquez' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhojan Javier Carrillo Díaz' LIMIT 1),
  NULL,
  '2026-05-12'::date,
  '2026-05-16'::date,
  585000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhojan Javier Carrillo Díaz' LIMIT 1) IS NOT NULL
  AND '2026-05-16'::date > '2026-05-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Perez' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-17'::date,
  223517,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Perez' LIMIT 1) IS NOT NULL
  AND '2026-05-17'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 205),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cade DeNazario Akers' LIMIT 1),
  NULL,
  '2026-05-17'::date,
  '2026-05-24'::date,
  1110270,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cade DeNazario Akers' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gabriel Mota Lopez' LIMIT 1),
  'Dahiana Espinoza',
  '2026-01-04'::date,
  '2026-01-06'::date,
  644539,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gabriel Mota Lopez' LIMIT 1) IS NOT NULL
  AND '2026-01-06'::date > '2026-01-04'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Anthony Ordoñez' LIMIT 1),
  NULL,
  '2026-01-09'::date,
  '2026-01-11'::date,
  1025076,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Anthony Ordoñez' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés Felipe Morales' LIMIT 1),
  NULL,
  '2026-02-28'::date,
  '2026-03-01'::date,
  202503,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés Felipe Morales' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Ramirez' LIMIT 1),
  NULL,
  '2026-03-12'::date,
  '2026-03-15'::date,
  450000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Ramirez' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kerstinck Sarmiento' LIMIT 1),
  NULL,
  '2026-03-19'::date,
  '2026-03-21'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kerstinck Sarmiento' LIMIT 1) IS NOT NULL
  AND '2026-03-21'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tatiana Moreno Pino' LIMIT 1),
  NULL,
  '2026-03-21'::date,
  '2026-03-23'::date,
  256069,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tatiana Moreno Pino' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'anyely flores lopez' LIMIT 1),
  NULL,
  '2026-03-26'::date,
  '2026-03-27'::date,
  170000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'anyely flores lopez' LIMIT 1) IS NOT NULL
  AND '2026-03-27'::date > '2026-03-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'david cuartas' LIMIT 1),
  NULL,
  '2026-03-30'::date,
  '2026-04-01'::date,
  297325,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'david cuartas' LIMIT 1) IS NOT NULL
  AND '2026-04-01'::date > '2026-03-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jaime Ivan Garzon Corrales' LIMIT 1),
  'estefania ardila',
  '2026-04-01'::date,
  '2026-04-05'::date,
  687301,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jaime Ivan Garzon Corrales' LIMIT 1) IS NOT NULL
  AND '2026-04-05'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Addy Dayana Luna Drith' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  137196,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Addy Dayana Luna Drith' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1),
  NULL,
  '2026-04-26'::date,
  '2026-04-27'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1) IS NOT NULL
  AND '2026-04-27'::date > '2026-04-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  156797,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jaime ramirez' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  150000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jaime ramirez' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yunes Elamin' LIMIT 1),
  NULL,
  '2026-05-04'::date,
  '2026-05-06'::date,
  305200,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yunes Elamin' LIMIT 1) IS NOT NULL
  AND '2026-05-06'::date > '2026-05-04'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'anyeli flores' LIMIT 1),
  NULL,
  '2026-05-07'::date,
  '2026-05-08'::date,
  175000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'anyeli flores' LIMIT 1) IS NOT NULL
  AND '2026-05-08'::date > '2026-05-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'maria paula marin vitola' LIMIT 1),
  NULL,
  '2026-05-13'::date,
  '2026-05-14'::date,
  147878,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'maria paula marin vitola' LIMIT 1) IS NOT NULL
  AND '2026-05-14'::date > '2026-05-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mario Fernando Noreña Chica' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-17'::date,
  391520,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mario Fernando Noreña Chica' LIMIT 1) IS NOT NULL
  AND '2026-05-17'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Sanchez' LIMIT 1),
  NULL,
  '2026-05-17'::date,
  '2026-05-20'::date,
  541451,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Sanchez' LIMIT 1) IS NOT NULL
  AND '2026-05-20'::date > '2026-05-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Oscar Edo Llain Suarez' LIMIT 1),
  NULL,
  '2026-05-23'::date,
  '2026-05-24'::date,
  179487,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Oscar Edo Llain Suarez' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 206),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristian Unigarro' LIMIT 1),
  NULL,
  '2026-05-27'::date,
  '2026-06-01'::date,
  836410,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristian Unigarro' LIMIT 1) IS NOT NULL
  AND '2026-06-01'::date > '2026-05-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Bryan Alvarez Jimenez' LIMIT 1),
  NULL,
  '2026-01-06'::date,
  '2026-01-08'::date,
  420000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Bryan Alvarez Jimenez' LIMIT 1) IS NOT NULL
  AND '2026-01-08'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Eric Mauricio Castillo sanchez' LIMIT 1),
  'Maria del Portillo',
  '2026-01-08'::date,
  '2026-01-09'::date,
  258950,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Eric Mauricio Castillo sanchez' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Javier Chavez' LIMIT 1),
  'Jorge Galeano',
  '2026-01-09'::date,
  '2026-01-11'::date,
  820000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Javier Chavez' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ramon Abreu' LIMIT 1),
  'Hilmar Salas',
  '2026-01-24'::date,
  '2026-01-25'::date,
  121952,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ramon Abreu' LIMIT 1) IS NOT NULL
  AND '2026-01-25'::date > '2026-01-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Viviana Mora Ospina' LIMIT 1),
  NULL,
  '2026-01-25'::date,
  '2026-01-26'::date,
  121952,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Viviana Mora Ospina' LIMIT 1) IS NOT NULL
  AND '2026-01-26'::date > '2026-01-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lorenza García' LIMIT 1),
  'Valeria Giraldo Garcia',
  '2026-01-30'::date,
  '2026-01-31'::date,
  138136,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lorenza García' LIMIT 1) IS NOT NULL
  AND '2026-01-31'::date > '2026-01-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Morales' LIMIT 1),
  'Blanca Toro Aguirre',
  '2026-01-31'::date,
  '2026-02-04'::date,
  529760,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Morales' LIMIT 1) IS NOT NULL
  AND '2026-02-04'::date > '2026-01-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ruben Dario Henao Amu' LIMIT 1),
  NULL,
  '2026-02-06'::date,
  '2026-02-08'::date,
  236648,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ruben Dario Henao Amu' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Steven Castaño Aristizábal' LIMIT 1),
  NULL,
  '2026-02-13'::date,
  '2026-02-14'::date,
  147440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Steven Castaño Aristizábal' LIMIT 1) IS NOT NULL
  AND '2026-02-14'::date > '2026-02-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Gutiérrez Molina' LIMIT 1),
  'Valentina Hernandez',
  '2026-02-14'::date,
  '2026-02-16'::date,
  242136,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Gutiérrez Molina' LIMIT 1) IS NOT NULL
  AND '2026-02-16'::date > '2026-02-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Osorio Ospina' LIMIT 1),
  NULL,
  '2026-02-21'::date,
  '2026-02-22'::date,
  127440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Osorio Ospina' LIMIT 1) IS NOT NULL
  AND '2026-02-22'::date > '2026-02-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Carlos Caro' LIMIT 1),
  'Juliana Maria Pirazan+',
  '2026-03-13'::date,
  '2026-03-14'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Carlos Caro' LIMIT 1) IS NOT NULL
  AND '2026-03-14'::date > '2026-03-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gonzales Paula Andrea' LIMIT 1),
  NULL,
  '2026-03-14'::date,
  '2026-03-15'::date,
  150000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gonzales Paula Andrea' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Vanessa Marin' LIMIT 1),
  NULL,
  '2026-03-19'::date,
  '2026-03-20'::date,
  144756,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Vanessa Marin' LIMIT 1) IS NOT NULL
  AND '2026-03-20'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jefferson Arteaga' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-21'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jefferson Arteaga' LIMIT 1) IS NOT NULL
  AND '2026-03-21'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jaqueline Henao Arias' LIMIT 1),
  NULL,
  '2026-03-21'::date,
  '2026-03-23'::date,
  299340,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jaqueline Henao Arias' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandra Betancour' LIMIT 1),
  NULL,
  '2026-03-29'::date,
  '2026-03-30'::date,
  153466,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandra Betancour' LIMIT 1) IS NOT NULL
  AND '2026-03-30'::date > '2026-03-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gloria Marcela Criollo Sanchez' LIMIT 1),
  NULL,
  '2026-03-31'::date,
  '2026-04-01'::date,
  163060,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gloria Marcela Criollo Sanchez' LIMIT 1) IS NOT NULL
  AND '2026-04-01'::date > '2026-03-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maira Alejandra Miranda Parra' LIMIT 1),
  'maira alejandra parra',
  '2026-04-01'::date,
  '2026-04-03'::date,
  298510,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maira Alejandra Miranda Parra' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'José Antonio Cely' LIMIT 1),
  NULL,
  '2026-04-11'::date,
  '2026-04-12'::date,
  133980,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'José Antonio Cely' LIMIT 1) IS NOT NULL
  AND '2026-04-12'::date > '2026-04-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Duque Gallego' LIMIT 1),
  NULL,
  '2026-04-15'::date,
  '2026-04-19'::date,
  510400,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Duque Gallego' LIMIT 1) IS NOT NULL
  AND '2026-04-19'::date > '2026-04-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Diaz' LIMIT 1),
  NULL,
  '2026-04-21'::date,
  '2026-04-22'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Diaz' LIMIT 1) IS NOT NULL
  AND '2026-04-22'::date > '2026-04-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'JOHAN PACHON' LIMIT 1),
  NULL,
  '2026-04-23'::date,
  '2026-04-24'::date,
  166050,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'JOHAN PACHON' LIMIT 1) IS NOT NULL
  AND '2026-04-24'::date > '2026-04-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Omar Scuratti' LIMIT 1),
  NULL,
  '2026-04-24'::date,
  '2026-04-25'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Omar Scuratti' LIMIT 1) IS NOT NULL
  AND '2026-04-25'::date > '2026-04-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nicolas Duplat Tissot' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nicolas Duplat Tissot' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jeronimo Contreras' LIMIT 1),
  NULL,
  '2026-04-30'::date,
  '2026-05-01'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jeronimo Contreras' LIMIT 1) IS NOT NULL
  AND '2026-05-01'::date > '2026-04-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nataly Ramirez Arias' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-03'::date,
  245630,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nataly Ramirez Arias' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Posada' LIMIT 1),
  NULL,
  '2026-05-03'::date,
  '2026-05-04'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Posada' LIMIT 1) IS NOT NULL
  AND '2026-05-04'::date > '2026-05-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristian Mendez Mendez' LIMIT 1),
  NULL,
  '2026-05-07'::date,
  '2026-05-08'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristian Mendez Mendez' LIMIT 1) IS NOT NULL
  AND '2026-05-08'::date > '2026-05-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Yarce Gomez' LIMIT 1),
  NULL,
  '2026-05-08'::date,
  '2026-05-09'::date,
  122815,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Yarce Gomez' LIMIT 1) IS NOT NULL
  AND '2026-05-09'::date > '2026-05-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'federico Garcia' LIMIT 1),
  NULL,
  '2026-05-10'::date,
  '2026-05-11'::date,
  175000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'federico Garcia' LIMIT 1) IS NOT NULL
  AND '2026-05-11'::date > '2026-05-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Blanca Montoya' LIMIT 1),
  NULL,
  '2026-05-12'::date,
  '2026-05-13'::date,
  152600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Blanca Montoya' LIMIT 1) IS NOT NULL
  AND '2026-05-13'::date > '2026-05-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Pryanka Gonzalez Sifontes' LIMIT 1),
  NULL,
  '2026-05-13'::date,
  '2026-05-15'::date,
  280200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Pryanka Gonzalez Sifontes' LIMIT 1) IS NOT NULL
  AND '2026-05-15'::date > '2026-05-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Castaneda' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-16'::date,
  366054,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Castaneda' LIMIT 1) IS NOT NULL
  AND '2026-05-16'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'John Villegas' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-18'::date,
  270630,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'John Villegas' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos José Rubio ruiz' LIMIT 1),
  NULL,
  '2026-05-18'::date,
  '2026-05-21'::date,
  359950,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos José Rubio ruiz' LIMIT 1) IS NOT NULL
  AND '2026-05-21'::date > '2026-05-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentin Alvarado Benitez' LIMIT 1),
  NULL,
  '2026-05-21'::date,
  '2026-05-22'::date,
  165360,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentin Alvarado Benitez' LIMIT 1) IS NOT NULL
  AND '2026-05-22'::date > '2026-05-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Lícia Calheiros' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-24'::date,
  188388,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Lícia Calheiros' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Lícia Calheiros' LIMIT 1),
  NULL,
  '2026-05-24'::date,
  '2026-05-25'::date,
  103613,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Lícia Calheiros' LIMIT 1) IS NOT NULL
  AND '2026-05-25'::date > '2026-05-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 207),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Eliecer Lozano Ospina' LIMIT 1),
  NULL,
  '2026-05-28'::date,
  '2026-05-29'::date,
  165360,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Eliecer Lozano Ospina' LIMIT 1) IS NOT NULL
  AND '2026-05-29'::date > '2026-05-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Damian Baumann' LIMIT 1),
  NULL,
  '2026-01-02'::date,
  '2026-01-04'::date,
  603619,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Damian Baumann' LIMIT 1) IS NOT NULL
  AND '2026-01-04'::date > '2026-01-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Marvin Ramos' LIMIT 1),
  NULL,
  '2026-01-08'::date,
  '2026-01-10'::date,
  571122,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Marvin Ramos' LIMIT 1) IS NOT NULL
  AND '2026-01-10'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Moreno' LIMIT 1),
  'Agustin Hoyos',
  '2026-01-10'::date,
  '2026-01-12'::date,
  1062176,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Moreno' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Rodriguez' LIMIT 1),
  'Sebastian Rangel',
  '2026-01-21'::date,
  '2026-01-23'::date,
  383204,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-01-23'::date > '2026-01-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sophie Marrugo' LIMIT 1),
  NULL,
  '2026-02-13'::date,
  '2026-02-15'::date,
  278278,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sophie Marrugo' LIMIT 1) IS NOT NULL
  AND '2026-02-15'::date > '2026-02-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Osorio Ospina' LIMIT 1),
  NULL,
  '2026-03-07'::date,
  '2026-03-08'::date,
  168752,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Osorio Ospina' LIMIT 1) IS NOT NULL
  AND '2026-03-08'::date > '2026-03-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Rafael Palacio Gomez' LIMIT 1),
  NULL,
  '2026-03-12'::date,
  '2026-03-16'::date,
  618116,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Rafael Palacio Gomez' LIMIT 1) IS NOT NULL
  AND '2026-03-16'::date > '2026-03-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'D Johan' LIMIT 1),
  NULL,
  '2026-03-19'::date,
  '2026-03-20'::date,
  149466,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'D Johan' LIMIT 1) IS NOT NULL
  AND '2026-03-20'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Teresa Del Mar Angulo Medina' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-21'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Teresa Del Mar Angulo Medina' LIMIT 1) IS NOT NULL
  AND '2026-03-21'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Acevedo Arcila' LIMIT 1),
  NULL,
  '2026-03-21'::date,
  '2026-03-23'::date,
  325581,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Acevedo Arcila' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Gonzales' LIMIT 1),
  NULL,
  '2026-03-28'::date,
  '2026-03-29'::date,
  160000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Gonzales' LIMIT 1) IS NOT NULL
  AND '2026-03-29'::date > '2026-03-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jasson Cardona' LIMIT 1),
  'maria camila',
  '2026-04-01'::date,
  '2026-04-02'::date,
  180000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jasson Cardona' LIMIT 1) IS NOT NULL
  AND '2026-04-02'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'sophi marrugo' LIMIT 1),
  NULL,
  '2026-04-02'::date,
  '2026-04-04'::date,
  413396,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'sophi marrugo' LIMIT 1) IS NOT NULL
  AND '2026-04-04'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  156797,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Claudia Fernanda Ipaz Sabogal' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  166595,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Claudia Fernanda Ipaz Sabogal' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 301),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhoan Sebastian Cruz Barbosa' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-18'::date,
  391520,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhoan Sebastian Cruz Barbosa' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'John Burgos' LIMIT 1),
  'Tatiana pineda',
  '2026-01-03'::date,
  '2026-01-05'::date,
  667056,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'John Burgos' LIMIT 1) IS NOT NULL
  AND '2026-01-05'::date > '2026-01-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Avellaneda' LIMIT 1),
  NULL,
  '2026-01-07'::date,
  '2026-01-09'::date,
  548640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Avellaneda' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Segura' LIMIT 1),
  'Sandra Ramirez',
  '2026-01-09'::date,
  '2026-01-11'::date,
  918688,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Segura' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Andres Russi Soto' LIMIT 1),
  NULL,
  '2026-01-22'::date,
  '2026-01-23'::date,
  128045,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Andres Russi Soto' LIMIT 1) IS NOT NULL
  AND '2026-01-23'::date > '2026-01-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Will Mendoza Reinel' LIMIT 1),
  'Leidis Baza',
  '2026-02-06'::date,
  '2026-02-08'::date,
  265534,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Will Mendoza Reinel' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nacho Villegas' LIMIT 1),
  NULL,
  '2026-02-10'::date,
  '2026-02-20'::date,
  1402895,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nacho Villegas' LIMIT 1) IS NOT NULL
  AND '2026-02-20'::date > '2026-02-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nacho Villegas' LIMIT 1),
  NULL,
  '2026-02-20'::date,
  '2026-02-21'::date,
  120000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nacho Villegas' LIMIT 1) IS NOT NULL
  AND '2026-02-21'::date > '2026-02-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lissett Ramos' LIMIT 1),
  NULL,
  '2026-03-07'::date,
  '2026-03-09'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lissett Ramos' LIMIT 1) IS NOT NULL
  AND '2026-03-09'::date > '2026-03-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Knut Morten Powilleit' LIMIT 1),
  NULL,
  '2026-03-13'::date,
  '2026-03-17'::date,
  543328,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Knut Morten Powilleit' LIMIT 1) IS NOT NULL
  AND '2026-03-17'::date > '2026-03-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julio Enrique Barco Franco' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-22'::date,
  308677,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julio Enrique Barco Franco' LIMIT 1) IS NOT NULL
  AND '2026-03-22'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paola Perdomo' LIMIT 1),
  NULL,
  '2026-03-22'::date,
  '2026-03-23'::date,
  167879,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paola Perdomo' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Donado' LIMIT 1),
  'salome gomez',
  '2026-03-26'::date,
  '2026-03-29'::date,
  408859,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Donado' LIMIT 1) IS NOT NULL
  AND '2026-03-29'::date > '2026-03-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jose G Castano' LIMIT 1),
  NULL,
  '2026-04-01'::date,
  '2026-04-04'::date,
  530468,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jose G Castano' LIMIT 1) IS NOT NULL
  AND '2026-04-04'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Erfanipur Asian pasha' LIMIT 1),
  NULL,
  '2026-04-05'::date,
  '2026-04-06'::date,
  144655,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Erfanipur Asian pasha' LIMIT 1) IS NOT NULL
  AND '2026-04-06'::date > '2026-04-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  156797,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 302),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Pryanka Gonzalez Sifontes' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-18'::date,
  574780,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Pryanka Gonzalez Sifontes' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lady Laura Prieto Esguerra' LIMIT 1),
  'Fabio Cardona',
  '2026-01-04'::date,
  '2026-01-05'::date,
  160000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lady Laura Prieto Esguerra' LIMIT 1) IS NOT NULL
  AND '2026-01-05'::date > '2026-01-04'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Tobon' LIMIT 1),
  'Maria Camila Londoño',
  '2026-01-06'::date,
  '2026-01-07'::date,
  180000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Tobon' LIMIT 1) IS NOT NULL
  AND '2026-01-07'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Loaiza' LIMIT 1),
  'Alejandro Franco',
  '2026-01-07'::date,
  '2026-01-08'::date,
  225000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Loaiza' LIMIT 1) IS NOT NULL
  AND '2026-01-08'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Beatriz Helena Montoya Ruiz' LIMIT 1),
  'Francisco Quintana',
  '2026-01-08'::date,
  '2026-01-09'::date,
  225000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Beatriz Helena Montoya Ruiz' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Manuel Marmolejo' LIMIT 1),
  'Yury  Sanchez',
  '2026-01-09'::date,
  '2026-01-11'::date,
  827200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Manuel Marmolejo' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Lorena Villar Contreras' LIMIT 1),
  'Johan Camilo Gonzalez Enciso',
  '2026-01-11'::date,
  '2026-01-12'::date,
  148000,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Lorena Villar Contreras' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jose Alexander Giraldo Hurtado' LIMIT 1),
  NULL,
  '2026-01-12'::date,
  '2026-01-13'::date,
  169920,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jose Alexander Giraldo Hurtado' LIMIT 1) IS NOT NULL
  AND '2026-01-13'::date > '2026-01-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paola Castaño Leiva' LIMIT 1),
  'Martha Leiva Cedas',
  '2026-01-16'::date,
  '2026-01-18'::date,
  254880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paola Castaño Leiva' LIMIT 1) IS NOT NULL
  AND '2026-01-18'::date > '2026-01-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angelica Gallego' LIMIT 1),
  NULL,
  '2026-01-19'::date,
  '2026-01-21'::date,
  271872,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angelica Gallego' LIMIT 1) IS NOT NULL
  AND '2026-01-21'::date > '2026-01-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Fabian Naranjo' LIMIT 1),
  NULL,
  '2026-01-22'::date,
  '2026-01-23'::date,
  143370,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Fabian Naranjo' LIMIT 1) IS NOT NULL
  AND '2026-01-23'::date > '2026-01-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juliana Toro' LIMIT 1),
  'Laura Patino Sanchez',
  '2026-01-24'::date,
  '2026-01-26'::date,
  258066,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juliana Toro' LIMIT 1) IS NOT NULL
  AND '2026-01-26'::date > '2026-01-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angel David Gallego Pelaez' LIMIT 1),
  NULL,
  '2026-01-27'::date,
  '2026-01-28'::date,
  116129,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angel David Gallego Pelaez' LIMIT 1) IS NOT NULL
  AND '2026-01-28'::date > '2026-01-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steven Escobar Castaño' LIMIT 1),
  'Sarah Medrano',
  '2026-01-31'::date,
  '2026-02-01'::date,
  143370,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steven Escobar Castaño' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Joan Sebastian Salazar Hernandez' LIMIT 1),
  NULL,
  '2026-02-02'::date,
  '2026-02-03'::date,
  143370,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Joan Sebastian Salazar Hernandez' LIMIT 1) IS NOT NULL
  AND '2026-02-03'::date > '2026-02-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Gomez' LIMIT 1),
  NULL,
  '2026-02-04'::date,
  '2026-02-05'::date,
  143370,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Gomez' LIMIT 1) IS NOT NULL
  AND '2026-02-05'::date > '2026-02-04'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ximena Gómez' LIMIT 1),
  NULL,
  '2026-02-06'::date,
  '2026-02-07'::date,
  143370,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ximena Gómez' LIMIT 1) IS NOT NULL
  AND '2026-02-07'::date > '2026-02-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steven Escobar Castaño' LIMIT 1),
  'Sarah Medrano',
  '2026-02-07'::date,
  '2026-02-08'::date,
  143370,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steven Escobar Castaño' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Andres Zuluaga Zuñiga' LIMIT 1),
  'Viviana Orozco',
  '2026-02-10'::date,
  '2026-02-11'::date,
  129033,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Andres Zuluaga Zuñiga' LIMIT 1) IS NOT NULL
  AND '2026-02-11'::date > '2026-02-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Riaño' LIMIT 1),
  'Oscar Felipe Arciniegas',
  '2026-02-13'::date,
  '2026-02-15'::date,
  286740,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Riaño' LIMIT 1) IS NOT NULL
  AND '2026-02-15'::date > '2026-02-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Lopez Salgado' LIMIT 1),
  NULL,
  '2026-02-18'::date,
  '2026-02-19'::date,
  140000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Lopez Salgado' LIMIT 1) IS NOT NULL
  AND '2026-02-19'::date > '2026-02-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Pérez Velásquez' LIMIT 1),
  NULL,
  '2026-02-19'::date,
  '2026-02-20'::date,
  143370,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Pérez Velásquez' LIMIT 1) IS NOT NULL
  AND '2026-02-20'::date > '2026-02-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana María González Durán' LIMIT 1),
  NULL,
  '2026-02-20'::date,
  '2026-02-21'::date,
  143370,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana María González Durán' LIMIT 1) IS NOT NULL
  AND '2026-02-21'::date > '2026-02-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Esteban Sanchez Rios' LIMIT 1),
  NULL,
  '2026-02-21'::date,
  '2026-02-23'::date,
  286740,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Esteban Sanchez Rios' LIMIT 1) IS NOT NULL
  AND '2026-02-23'::date > '2026-02-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Isabela Castaño Cardenas' LIMIT 1),
  'Santiago Loaiza',
  '2026-02-23'::date,
  '2026-02-24'::date,
  116820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Isabela Castaño Cardenas' LIMIT 1) IS NOT NULL
  AND '2026-02-24'::date > '2026-02-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Xiomara Cardona' LIMIT 1),
  NULL,
  '2026-03-07'::date,
  '2026-03-08'::date,
  160000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Xiomara Cardona' LIMIT 1) IS NOT NULL
  AND '2026-03-08'::date > '2026-03-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Morales' LIMIT 1),
  NULL,
  '2026-03-09'::date,
  '2026-03-10'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Morales' LIMIT 1) IS NOT NULL
  AND '2026-03-10'::date > '2026-03-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Estefania Parra' LIMIT 1),
  NULL,
  '2026-03-13'::date,
  '2026-03-14'::date,
  135002,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Estefania Parra' LIMIT 1) IS NOT NULL
  AND '2026-03-14'::date > '2026-03-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Perez' LIMIT 1),
  'Yolanda Perez',
  '2026-03-14'::date,
  '2026-03-18'::date,
  492280,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Perez' LIMIT 1) IS NOT NULL
  AND '2026-03-18'::date > '2026-03-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhoan Martinez' LIMIT 1),
  NULL,
  '2026-03-19'::date,
  '2026-03-20'::date,
  144756,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhoan Martinez' LIMIT 1) IS NOT NULL
  AND '2026-03-20'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Isaac Mosquera Murillo' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-23'::date,
  431674,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Isaac Mosquera Murillo' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Eduardo Montes Escobar' LIMIT 1),
  'montes jorge',
  '2026-03-29'::date,
  '2026-03-30'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Eduardo Montes Escobar' LIMIT 1) IS NOT NULL
  AND '2026-03-30'::date > '2026-03-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Arteaga' LIMIT 1),
  'valeria melo',
  '2026-03-31'::date,
  '2026-04-01'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Arteaga' LIMIT 1) IS NOT NULL
  AND '2026-04-01'::date > '2026-03-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Liceth Valencia' LIMIT 1),
  NULL,
  '2026-04-02'::date,
  '2026-04-03'::date,
  163060,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Liceth Valencia' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paola Chaparro Castillo' LIMIT 1),
  NULL,
  '2026-04-03'::date,
  '2026-04-05'::date,
  316870,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paola Chaparro Castillo' LIMIT 1) IS NOT NULL
  AND '2026-04-05'::date > '2026-04-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yeni Paola Gaitán' LIMIT 1),
  'gabriela rubio',
  '2026-04-18'::date,
  '2026-04-20'::date,
  277878,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yeni Paola Gaitán' LIMIT 1) IS NOT NULL
  AND '2026-04-20'::date > '2026-04-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luisa Fernanda Silva Núñez' LIMIT 1),
  NULL,
  '2026-04-24'::date,
  '2026-04-27'::date,
  421296,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luisa Fernanda Silva Núñez' LIMIT 1) IS NOT NULL
  AND '2026-04-27'::date > '2026-04-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhon edward piedrahita Quiceno' LIMIT 1),
  'Sandra Liliana Diaz Londoño',
  '2026-04-29'::date,
  '2026-04-30'::date,
  122878,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhon edward piedrahita Quiceno' LIMIT 1) IS NOT NULL
  AND '2026-04-30'::date > '2026-04-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nicolas Mauricio Zutta Arellano' LIMIT 1),
  NULL,
  '2026-04-30'::date,
  '2026-05-02'::date,
  280864,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Nicolas Mauricio Zutta Arellano' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-04-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carolina Alzate' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carolina Alzate' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jefferson Arteaga' LIMIT 1),
  NULL,
  '2026-05-06'::date,
  '2026-05-07'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jefferson Arteaga' LIMIT 1) IS NOT NULL
  AND '2026-05-07'::date > '2026-05-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Eliana Carolina Diaz Moreno' LIMIT 1),
  NULL,
  '2026-05-10'::date,
  '2026-05-20'::date,
  976140,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Eliana Carolina Diaz Moreno' LIMIT 1) IS NOT NULL
  AND '2026-05-20'::date > '2026-05-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Ortiz' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-24'::date,
  333974,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Ortiz' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 303),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1),
  NULL,
  '2026-05-26'::date,
  '2026-05-27'::date,
  179487,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1) IS NOT NULL
  AND '2026-05-27'::date > '2026-05-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Antonio de la Cruz' LIMIT 1),
  NULL,
  '2026-01-06'::date,
  '2026-01-07'::date,
  220000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Antonio de la Cruz' LIMIT 1) IS NOT NULL
  AND '2026-01-07'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kidinson Vega' LIMIT 1),
  'David Ardila',
  '2026-01-07'::date,
  '2026-01-08'::date,
  220000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kidinson Vega' LIMIT 1) IS NOT NULL
  AND '2026-01-08'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Alvear' LIMIT 1),
  'Celine Brispot',
  '2026-01-08'::date,
  '2026-01-09'::date,
  245000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Alvear' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Gonzales' LIMIT 1),
  'Pablo Bustos',
  '2026-01-09'::date,
  '2026-01-10'::date,
  596000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Gonzales' LIMIT 1) IS NOT NULL
  AND '2026-01-10'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adrian Estrada' LIMIT 1),
  'yorgelis odalys vizcaya',
  '2026-01-10'::date,
  '2026-01-11'::date,
  529760,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adrian Estrada' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adrian Estrada' LIMIT 1),
  'yorgelis odalys vizcaya',
  '2026-01-11'::date,
  '2026-01-13'::date,
  359840,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adrian Estrada' LIMIT 1) IS NOT NULL
  AND '2026-01-13'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sharly Rengifo Fernandez' LIMIT 1),
  'Christian Castaño',
  '2026-01-16'::date,
  '2026-01-17'::date,
  147440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sharly Rengifo Fernandez' LIMIT 1) IS NOT NULL
  AND '2026-01-17'::date > '2026-01-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Steven Ochoa Muñoz' LIMIT 1),
  NULL,
  '2026-01-17'::date,
  '2026-01-18'::date,
  147440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Steven Ochoa Muñoz' LIMIT 1) IS NOT NULL
  AND '2026-01-18'::date > '2026-01-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Antonio' LIMIT 1),
  NULL,
  '2026-01-24'::date,
  '2026-01-25'::date,
  149351,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Antonio' LIMIT 1) IS NOT NULL
  AND '2026-01-25'::date > '2026-01-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Felipe Campuzano' LIMIT 1),
  'Manyeli Toro',
  '2026-01-31'::date,
  '2026-02-01'::date,
  168680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Felipe Campuzano' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Derek Matias Botero Ocampo' LIMIT 1),
  'Samuel Alba',
  '2026-02-06'::date,
  '2026-02-07'::date,
  150838,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Derek Matias Botero Ocampo' LIMIT 1) IS NOT NULL
  AND '2026-02-07'::date > '2026-02-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sindry Paola Camargo' LIMIT 1),
  NULL,
  '2026-02-08'::date,
  '2026-02-11'::date,
  376832,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sindry Paola Camargo' LIMIT 1) IS NOT NULL
  AND '2026-02-11'::date > '2026-02-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sindry Paola Camargo' LIMIT 1),
  NULL,
  '2026-02-11'::date,
  '2026-02-13'::date,
  258000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sindry Paola Camargo' LIMIT 1) IS NOT NULL
  AND '2026-02-13'::date > '2026-02-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sergio Ochoa Orozco' LIMIT 1),
  'Loaiza Noreña Nesly Natalia',
  '2026-02-13'::date,
  '2026-02-14'::date,
  156998,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sergio Ochoa Orozco' LIMIT 1) IS NOT NULL
  AND '2026-02-14'::date > '2026-02-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Heidy Stefania Galviz Montoya' LIMIT 1),
  NULL,
  '2026-02-15'::date,
  '2026-02-16'::date,
  133812,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Heidy Stefania Galviz Montoya' LIMIT 1) IS NOT NULL
  AND '2026-02-16'::date > '2026-02-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camila Lopez' LIMIT 1),
  NULL,
  '2026-02-18'::date,
  '2026-02-19'::date,
  158000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camila Lopez' LIMIT 1) IS NOT NULL
  AND '2026-02-19'::date > '2026-02-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Ines Garavito Correa' LIMIT 1),
  NULL,
  '2026-02-21'::date,
  '2026-02-22'::date,
  140000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Ines Garavito Correa' LIMIT 1) IS NOT NULL
  AND '2026-02-22'::date > '2026-02-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Omar Eduardo Cifuentes Rubiano' LIMIT 1),
  'Claudia Marcela Robles',
  '2026-02-27'::date,
  '2026-03-01'::date,
  233640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Omar Eduardo Cifuentes Rubiano' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Dora Marcela Uribe Usuga' LIMIT 1),
  NULL,
  '2026-03-04'::date,
  '2026-03-07'::date,
  405300,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Dora Marcela Uribe Usuga' LIMIT 1) IS NOT NULL
  AND '2026-03-07'::date > '2026-03-04'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ernesto Rojas' LIMIT 1),
  'Natalia Ibañez',
  '2026-03-12'::date,
  '2026-03-15'::date,
  258640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ernesto Rojas' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ben Siegler' LIMIT 1),
  NULL,
  '2026-03-17'::date,
  '2026-03-18'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ben Siegler' LIMIT 1) IS NOT NULL
  AND '2026-03-18'::date > '2026-03-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Ocampo' LIMIT 1),
  NULL,
  '2026-03-18'::date,
  '2026-03-23'::date,
  656513,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Ocampo' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Quintero Valencia' LIMIT 1),
  'andres duque puerta',
  '2026-03-31'::date,
  '2026-04-01'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Quintero Valencia' LIMIT 1) IS NOT NULL
  AND '2026-04-01'::date > '2026-03-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Valencia Salazar' LIMIT 1),
  'vasco laura',
  '2026-04-02'::date,
  '2026-04-03'::date,
  163060,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Valencia Salazar' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mario German Alvarez Pulgarin' LIMIT 1),
  NULL,
  '2026-04-03'::date,
  '2026-04-05'::date,
  319860,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mario German Alvarez Pulgarin' LIMIT 1) IS NOT NULL
  AND '2026-04-05'::date > '2026-04-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Eduardo Montes Escobar' LIMIT 1),
  NULL,
  '2026-04-17'::date,
  '2026-04-18'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Eduardo Montes Escobar' LIMIT 1) IS NOT NULL
  AND '2026-04-18'::date > '2026-04-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luis Manuel Gallego' LIMIT 1),
  NULL,
  '2026-04-18'::date,
  '2026-04-19'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luis Manuel Gallego' LIMIT 1) IS NOT NULL
  AND '2026-04-19'::date > '2026-04-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sergio Alonso Mariño Duque' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-27'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sergio Alonso Mariño Duque' LIMIT 1) IS NOT NULL
  AND '2026-04-27'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Marulanda toro' LIMIT 1),
  NULL,
  '2026-04-29'::date,
  '2026-04-30'::date,
  155000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Marulanda toro' LIMIT 1) IS NOT NULL
  AND '2026-04-30'::date > '2026-04-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sara Morales' LIMIT 1),
  NULL,
  '2026-04-30'::date,
  '2026-05-01'::date,
  122878,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sara Morales' LIMIT 1) IS NOT NULL
  AND '2026-05-01'::date > '2026-04-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Joshua Elrich' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  169836,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Joshua Elrich' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Xiomara Valeria Marin Salazar' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  122815,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Xiomara Valeria Marin Salazar' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Margot Cristina Gil Sanchez' LIMIT 1),
  NULL,
  '2026-05-10'::date,
  '2026-05-14'::date,
  561728,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Margot Cristina Gil Sanchez' LIMIT 1) IS NOT NULL
  AND '2026-05-14'::date > '2026-05-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'John Osorio Zuluaga' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-16'::date,
  179480,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'John Osorio Zuluaga' LIMIT 1) IS NOT NULL
  AND '2026-05-16'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Ocampo Parra' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-17'::date,
  160165,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Ocampo Parra' LIMIT 1) IS NOT NULL
  AND '2026-05-17'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Martha López Peñate' LIMIT 1),
  NULL,
  '2026-05-17'::date,
  '2026-05-18'::date,
  160165,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Martha López Peñate' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Esteban Rivera Gonzalez' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-24'::date,
  333974,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Esteban Rivera Gonzalez' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 304),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Cardona' LIMIT 1),
  NULL,
  '2026-05-24'::date,
  '2026-05-25'::date,
  179487,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Esteban Cardona' LIMIT 1) IS NOT NULL
  AND '2026-05-25'::date > '2026-05-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kelly Jhoana Vidal' LIMIT 1),
  'dik hurtado',
  '2026-01-02'::date,
  '2026-01-05'::date,
  1001288,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kelly Jhoana Vidal' LIMIT 1) IS NOT NULL
  AND '2026-01-05'::date > '2026-01-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Miguel Angel Jurado' LIMIT 1),
  'Valentina Vargas',
  '2026-01-06'::date,
  '2026-01-07'::date,
  338600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Miguel Angel Jurado' LIMIT 1) IS NOT NULL
  AND '2026-01-07'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Roberto Martin' LIMIT 1),
  NULL,
  '2026-01-07'::date,
  '2026-01-11'::date,
  1795664,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Roberto Martin' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Adolfo Gonzalez' LIMIT 1),
  NULL,
  '2026-01-28'::date,
  '2026-01-31'::date,
  510000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Adolfo Gonzalez' LIMIT 1) IS NOT NULL
  AND '2026-01-31'::date > '2026-01-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Adolfo Gonzalez' LIMIT 1),
  NULL,
  '2026-02-05'::date,
  '2026-02-06'::date,
  170000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Adolfo Gonzalez' LIMIT 1) IS NOT NULL
  AND '2026-02-06'::date > '2026-02-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Adolfo Gonzalez' LIMIT 1),
  NULL,
  '2026-02-06'::date,
  '2026-02-07'::date,
  170000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Adolfo Gonzalez' LIMIT 1) IS NOT NULL
  AND '2026-02-07'::date > '2026-02-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lina Arango Rosecreekpark' LIMIT 1),
  NULL,
  '2026-02-15'::date,
  '2026-02-16'::date,
  208800,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lina Arango Rosecreekpark' LIMIT 1) IS NOT NULL
  AND '2026-02-16'::date > '2026-02-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristhian Sanchez' LIMIT 1),
  NULL,
  '2026-02-27'::date,
  '2026-02-28'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristhian Sanchez' LIMIT 1) IS NOT NULL
  AND '2026-02-28'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Oscar Villarreal Ballesteros' LIMIT 1),
  NULL,
  '2026-02-28'::date,
  '2026-03-02'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Oscar Villarreal Ballesteros' LIMIT 1) IS NOT NULL
  AND '2026-03-02'::date > '2026-02-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César García' LIMIT 1),
  NULL,
  '2026-03-02'::date,
  '2026-03-03'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César García' LIMIT 1) IS NOT NULL
  AND '2026-03-03'::date > '2026-03-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Bryan Campuzano' LIMIT 1),
  NULL,
  '2026-03-06'::date,
  '2026-03-07'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Bryan Campuzano' LIMIT 1) IS NOT NULL
  AND '2026-03-07'::date > '2026-03-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diana Cristina Benavides Escobar' LIMIT 1),
  'Carlos Eduardo Arango',
  '2026-03-11'::date,
  '2026-03-13'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diana Cristina Benavides Escobar' LIMIT 1) IS NOT NULL
  AND '2026-03-13'::date > '2026-03-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yessica Juliana Gonzalez Giraldo' LIMIT 1),
  NULL,
  '2026-03-13'::date,
  '2026-03-15'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yessica Juliana Gonzalez Giraldo' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Giraldo Quintero' LIMIT 1),
  'Maritza Mejía Lopez',
  '2026-03-19'::date,
  '2026-03-20'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Giraldo Quintero' LIMIT 1) IS NOT NULL
  AND '2026-03-20'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Gutierrez' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-23'::date,
  450319,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Gutierrez' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lars Luomanen' LIMIT 1),
  NULL,
  '2026-03-27'::date,
  '2026-04-03'::date,
  934009,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lars Luomanen' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-03-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Michael Carucci' LIMIT 1),
  NULL,
  '2026-04-26'::date,
  '2026-04-29'::date,
  382800,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Michael Carucci' LIMIT 1) IS NOT NULL
  AND '2026-04-29'::date > '2026-04-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jeronimo Contreras' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  180450,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jeronimo Contreras' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jess Tapia Rodriguez' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  180450,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jess Tapia Rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'eduardo alzate' LIMIT 1),
  'monica andrea cardenas',
  '2026-05-08'::date,
  '2026-05-09'::date,
  148606,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'eduardo alzate' LIMIT 1) IS NOT NULL
  AND '2026-05-09'::date > '2026-05-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jairo Andres Romero Herrera' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-18'::date,
  585520,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jairo Andres Romero Herrera' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ramirez Juan D' LIMIT 1),
  NULL,
  '2026-05-19'::date,
  '2026-05-20'::date,
  194836,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ramirez Juan D' LIMIT 1) IS NOT NULL
  AND '2026-05-20'::date > '2026-05-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 305),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'jose Vargas' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-25'::date,
  604000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'jose Vargas' LIMIT 1) IS NOT NULL
  AND '2026-05-25'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ale Hernandez Montiel' LIMIT 1),
  NULL,
  '2026-01-02'::date,
  '2026-01-04'::date,
  585494,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ale Hernandez Montiel' LIMIT 1) IS NOT NULL
  AND '2026-01-04'::date > '2026-01-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristina Blanco' LIMIT 1),
  NULL,
  '2026-01-08'::date,
  '2026-01-09'::date,
  245427,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristina Blanco' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Carrillo' LIMIT 1),
  'ayda hernandez',
  '2026-01-09'::date,
  '2026-01-12'::date,
  1651232,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Carrillo' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Giraldo Quintero' LIMIT 1),
  NULL,
  '2026-02-12'::date,
  '2026-02-13'::date,
  128748,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Giraldo Quintero' LIMIT 1) IS NOT NULL
  AND '2026-02-13'::date > '2026-02-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Henao' LIMIT 1),
  NULL,
  '2026-02-27'::date,
  '2026-03-01'::date,
  251560,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Henao' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Serna Gómez' LIMIT 1),
  'Simon Rodriguez',
  '2026-03-16'::date,
  '2026-03-17'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Serna Gómez' LIMIT 1) IS NOT NULL
  AND '2026-03-17'::date > '2026-03-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Tatiana Campos Del Cairo' LIMIT 1),
  NULL,
  '2026-03-18'::date,
  '2026-03-22'::date,
  626087,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Tatiana Campos Del Cairo' LIMIT 1) IS NOT NULL
  AND '2026-03-22'::date > '2026-03-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mauricio Andrés Fernández Guevara' LIMIT 1),
  NULL,
  '2026-03-22'::date,
  '2026-03-23'::date,
  250000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mauricio Andrés Fernández Guevara' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'carlos marulanda' LIMIT 1),
  NULL,
  '2026-03-27'::date,
  '2026-03-28'::date,
  195000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'carlos marulanda' LIMIT 1) IS NOT NULL
  AND '2026-03-28'::date > '2026-03-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luisa Corrales' LIMIT 1),
  'jhon perez',
  '2026-04-02'::date,
  '2026-04-04'::date,
  381788,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luisa Corrales' LIMIT 1) IS NOT NULL
  AND '2026-04-04'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Liliana Estrada' LIMIT 1),
  NULL,
  '2026-04-27'::date,
  '2026-04-29'::date,
  313592,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Liliana Estrada' LIMIT 1) IS NOT NULL
  AND '2026-04-29'::date > '2026-04-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  156797,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Andres Gutierrez Gutierrez' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  166595,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Andres Gutierrez Gutierrez' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'sara manuela gonzales gutierrez' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-18'::date,
  326840,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'sara manuela gonzales gutierrez' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 306),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Elizabeth Paloma' LIMIT 1),
  NULL,
  '2026-05-23'::date,
  '2026-05-24'::date,
  216582,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Elizabeth Paloma' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Andrea Ruiz' LIMIT 1),
  'Stharlin arboleda',
  '2026-01-06'::date,
  '2026-01-07'::date,
  200000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Andrea Ruiz' LIMIT 1) IS NOT NULL
  AND '2026-01-07'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Loaiza' LIMIT 1),
  'Alejandro Franco',
  '2026-01-08'::date,
  '2026-01-09'::date,
  225000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Loaiza' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gabriel Jaramillo Toro' LIMIT 1),
  'Nicolas Jaramillo',
  '2026-01-09'::date,
  '2026-01-11'::date,
  1039520,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gabriel Jaramillo Toro' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Crisitan Felipe Ramirez Patiño' LIMIT 1),
  NULL,
  '2026-01-11'::date,
  '2026-01-12'::date,
  160000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Crisitan Felipe Ramirez Patiño' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés Felipe Muñoz Avila' LIMIT 1),
  NULL,
  '2026-01-17'::date,
  '2026-01-18'::date,
  133280,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés Felipe Muñoz Avila' LIMIT 1) IS NOT NULL
  AND '2026-01-18'::date > '2026-01-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Esteban Mattos Cruz' LIMIT 1),
  'Laura Camila Martinez',
  '2026-01-23'::date,
  '2026-01-25'::date,
  269570,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Esteban Mattos Cruz' LIMIT 1) IS NOT NULL
  AND '2026-01-25'::date > '2026-01-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julio Caro' LIMIT 1),
  'Camila Iglesias',
  '2026-01-31'::date,
  '2026-02-01'::date,
  168680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julio Caro' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Gomez Montes' LIMIT 1),
  NULL,
  '2026-02-07'::date,
  '2026-02-08'::date,
  153812,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Gomez Montes' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angie Viviana Fuentes Quimbayo' LIMIT 1),
  'Juan Pablo Duque',
  '2026-02-18'::date,
  '2026-02-19'::date,
  133812,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angie Viviana Fuentes Quimbayo' LIMIT 1) IS NOT NULL
  AND '2026-02-19'::date > '2026-02-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Carlos Neira Cardona' LIMIT 1),
  NULL,
  '2026-02-27'::date,
  '2026-03-02'::date,
  389400,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Carlos Neira Cardona' LIMIT 1) IS NOT NULL
  AND '2026-03-02'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brayan Quintero' LIMIT 1),
  NULL,
  '2026-03-11'::date,
  '2026-03-14'::date,
  350460,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brayan Quintero' LIMIT 1) IS NOT NULL
  AND '2026-03-14'::date > '2026-03-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ivan Santiago Rios' LIMIT 1),
  NULL,
  '2026-03-15'::date,
  '2026-03-17'::date,
  280000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ivan Santiago Rios' LIMIT 1) IS NOT NULL
  AND '2026-03-17'::date > '2026-03-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Miguel Madrigal Beltran' LIMIT 1),
  'Angie Vanessa',
  '2026-03-20'::date,
  '2026-03-23'::date,
  429382,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Miguel Madrigal Beltran' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tatiana Aristizábal' LIMIT 1),
  NULL,
  '2026-03-29'::date,
  '2026-03-30'::date,
  163060,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tatiana Aristizábal' LIMIT 1) IS NOT NULL
  AND '2026-03-30'::date > '2026-03-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristina Lopez Gomez' LIMIT 1),
  'martha lopez',
  '2026-04-01'::date,
  '2026-04-03'::date,
  303172,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cristina Lopez Gomez' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Steven Ochoa Muñoz' LIMIT 1),
  NULL,
  '2026-04-11'::date,
  '2026-04-12'::date,
  133980,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Steven Ochoa Muñoz' LIMIT 1) IS NOT NULL
  AND '2026-04-12'::date > '2026-04-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Raul Forjan' LIMIT 1),
  NULL,
  '2026-04-15'::date,
  '2026-04-16'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Raul Forjan' LIMIT 1) IS NOT NULL
  AND '2026-04-16'::date > '2026-04-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mayra Arias Marin' LIMIT 1),
  NULL,
  '2026-04-16'::date,
  '2026-04-17'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mayra Arias Marin' LIMIT 1) IS NOT NULL
  AND '2026-04-17'::date > '2026-04-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Botero Botero' LIMIT 1),
  NULL,
  '2026-04-18'::date,
  '2026-04-19'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Botero Botero' LIMIT 1) IS NOT NULL
  AND '2026-04-19'::date > '2026-04-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Leidys Muñoz' LIMIT 1),
  NULL,
  '2026-04-20'::date,
  '2026-04-21'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Leidys Muñoz' LIMIT 1) IS NOT NULL
  AND '2026-04-21'::date > '2026-04-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Hibet Herrera' LIMIT 1),
  NULL,
  '2026-04-23'::date,
  '2026-04-28'::date,
  633215,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Hibet Herrera' LIMIT 1) IS NOT NULL
  AND '2026-04-28'::date > '2026-04-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jimmy Andres Vega Rodriguez' LIMIT 1),
  NULL,
  '2026-04-30'::date,
  '2026-05-02'::date,
  255200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jimmy Andres Vega Rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-04-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Viviana Sepulveda' LIMIT 1),
  'rosa giraldo',
  '2026-05-02'::date,
  '2026-05-03'::date,
  122018,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Viviana Sepulveda' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Raul Forjan' LIMIT 1),
  NULL,
  '2026-05-07'::date,
  '2026-05-08'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Raul Forjan' LIMIT 1) IS NOT NULL
  AND '2026-05-08'::date > '2026-05-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Muñoz Patiño' LIMIT 1),
  NULL,
  '2026-05-08'::date,
  '2026-05-09'::date,
  122815,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Muñoz Patiño' LIMIT 1) IS NOT NULL
  AND '2026-05-09'::date > '2026-05-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Stephanny Agudelo Osorio' LIMIT 1),
  NULL,
  '2026-05-09'::date,
  '2026-05-11'::date,
  255200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Stephanny Agudelo Osorio' LIMIT 1) IS NOT NULL
  AND '2026-05-11'::date > '2026-05-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angie Viviana Fuentes Quimbayo' LIMIT 1),
  NULL,
  '2026-05-13'::date,
  '2026-05-14'::date,
  152600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angie Viviana Fuentes Quimbayo' LIMIT 1) IS NOT NULL
  AND '2026-05-14'::date > '2026-05-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Castaneda' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-16'::date,
  366054,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Castaneda' LIMIT 1) IS NOT NULL
  AND '2026-05-16'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'ANGIE MELISSA RODRIGUEZ GALARZA' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-18'::date,
  280200,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'ANGIE MELISSA RODRIGUEZ GALARZA' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Shirley 丁' LIMIT 1),
  NULL,
  '2026-05-18'::date,
  '2026-05-20'::date,
  280200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Shirley 丁' LIMIT 1) IS NOT NULL
  AND '2026-05-20'::date > '2026-05-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mauricio Baquero Diaz' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-24'::date,
  280200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mauricio Baquero Diaz' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 307),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mónica Gaitán Bedoya' LIMIT 1),
  NULL,
  '2026-05-24'::date,
  '2026-05-25'::date,
  147815,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mónica Gaitán Bedoya' LIMIT 1) IS NOT NULL
  AND '2026-05-25'::date > '2026-05-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Chacon' LIMIT 1),
  'Diego Ramirez',
  '2026-01-01'::date,
  '2026-01-03'::date,
  354827,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Chacon' LIMIT 1) IS NOT NULL
  AND '2026-01-03'::date > '2026-01-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Darius Bell' LIMIT 1),
  'Lithzy Arci',
  '2026-01-08'::date,
  '2026-01-12'::date,
  2087360,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Darius Bell' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Andres Jimenez Montoya' LIMIT 1),
  'Jacqueline Cardenas',
  '2026-01-16'::date,
  '2026-01-18'::date,
  308864,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Andres Jimenez Montoya' LIMIT 1) IS NOT NULL
  AND '2026-01-18'::date > '2026-01-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adriana Noguera' LIMIT 1),
  NULL,
  '2026-01-23'::date,
  '2026-01-25'::date,
  416480,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adriana Noguera' LIMIT 1) IS NOT NULL
  AND '2026-01-25'::date > '2026-01-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Gonzalez' LIMIT 1),
  'Mario Marin',
  '2026-01-25'::date,
  '2026-01-26'::date,
  195230,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gustavo Gonzalez' LIMIT 1) IS NOT NULL
  AND '2026-01-26'::date > '2026-01-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián García Idárraga' LIMIT 1),
  NULL,
  '2026-01-31'::date,
  '2026-02-01'::date,
  195230,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián García Idárraga' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carolina Valencia' LIMIT 1),
  NULL,
  '2026-02-07'::date,
  '2026-02-08'::date,
  195230,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carolina Valencia' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Osorio Ospina' LIMIT 1),
  'Laura Duque Ocampo',
  '2026-02-14'::date,
  '2026-02-15'::date,
  165184,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastián Osorio Ospina' LIMIT 1) IS NOT NULL
  AND '2026-02-15'::date > '2026-02-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Durán' LIMIT 1),
  NULL,
  '2026-02-17'::date,
  '2026-02-18'::date,
  165184,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Durán' LIMIT 1) IS NOT NULL
  AND '2026-02-18'::date > '2026-02-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César Camacho' LIMIT 1),
  'Paulina Ceballos',
  '2026-02-21'::date,
  '2026-02-22'::date,
  200230,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César Camacho' LIMIT 1) IS NOT NULL
  AND '2026-02-22'::date > '2026-02-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Jose Sierra' LIMIT 1),
  NULL,
  '2026-02-25'::date,
  '2026-02-27'::date,
  274825,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Jose Sierra' LIMIT 1) IS NOT NULL
  AND '2026-02-27'::date > '2026-02-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lorena Castro Lombana' LIMIT 1),
  NULL,
  '2026-02-27'::date,
  '2026-03-01'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lorena Castro Lombana' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Isabel Ocampo' LIMIT 1),
  'Elena Valencia',
  '2026-03-02'::date,
  '2026-03-04'::date,
  258640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Isabel Ocampo' LIMIT 1) IS NOT NULL
  AND '2026-03-04'::date > '2026-03-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Villada Zuluaga' LIMIT 1),
  'Sofia Villegas',
  '2026-03-05'::date,
  '2026-03-06'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Villada Zuluaga' LIMIT 1) IS NOT NULL
  AND '2026-03-06'::date > '2026-03-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Gómez' LIMIT 1),
  'Tatiana Sepulveda',
  '2026-03-06'::date,
  '2026-03-09'::date,
  407320,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Gómez' LIMIT 1) IS NOT NULL
  AND '2026-03-09'::date > '2026-03-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yohany Gaviria' LIMIT 1),
  NULL,
  '2026-03-10'::date,
  '2026-03-11'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yohany Gaviria' LIMIT 1) IS NOT NULL
  AND '2026-03-11'::date > '2026-03-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angela Quintero Yepes' LIMIT 1),
  NULL,
  '2026-03-11'::date,
  '2026-03-14'::date,
  437549,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angela Quintero Yepes' LIMIT 1) IS NOT NULL
  AND '2026-03-14'::date > '2026-03-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandra Marin Campos' LIMIT 1),
  NULL,
  '2026-03-14'::date,
  '2026-03-16'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandra Marin Campos' LIMIT 1) IS NOT NULL
  AND '2026-03-16'::date > '2026-03-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tatiana Aristizábal' LIMIT 1),
  NULL,
  '2026-03-19'::date,
  '2026-03-20'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Tatiana Aristizábal' LIMIT 1) IS NOT NULL
  AND '2026-03-20'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mike Ortiz' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-24'::date,
  590396,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mike Ortiz' LIMIT 1) IS NOT NULL
  AND '2026-03-24'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Felipe Ramirez Ospina' LIMIT 1),
  NULL,
  '2026-03-24'::date,
  '2026-03-25'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Felipe Ramirez Ospina' LIMIT 1) IS NOT NULL
  AND '2026-03-25'::date > '2026-03-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Franco Rincon' LIMIT 1),
  'rojas edwin',
  '2026-03-25'::date,
  '2026-03-26'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Franco Rincon' LIMIT 1) IS NOT NULL
  AND '2026-03-26'::date > '2026-03-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edisson Culma Avila' LIMIT 1),
  NULL,
  '2026-03-26'::date,
  '2026-03-27'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edisson Culma Avila' LIMIT 1) IS NOT NULL
  AND '2026-03-27'::date > '2026-03-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mayerly Quintero' LIMIT 1),
  'lina maria torres',
  '2026-03-28'::date,
  '2026-03-30'::date,
  301801,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mayerly Quintero' LIMIT 1) IS NOT NULL
  AND '2026-03-30'::date > '2026-03-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Shangri La Giraldo Fernandez' LIMIT 1),
  NULL,
  '2026-03-30'::date,
  '2026-04-01'::date,
  322360,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Shangri La Giraldo Fernandez' LIMIT 1) IS NOT NULL
  AND '2026-04-01'::date > '2026-03-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Johan Alexander Paniagua Bedoya' LIMIT 1),
  'maria paula fanco',
  '2026-04-01'::date,
  '2026-04-02'::date,
  173680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Johan Alexander Paniagua Bedoya' LIMIT 1) IS NOT NULL
  AND '2026-04-02'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Ocampo Parra' LIMIT 1),
  'cristian camilo velazues',
  '2026-04-02'::date,
  '2026-04-03'::date,
  190628,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Ocampo Parra' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Hector Fabio Valencia Zorrilla' LIMIT 1),
  'juan guillermo galenao',
  '2026-04-03'::date,
  '2026-04-05'::date,
  382219,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Hector Fabio Valencia Zorrilla' LIMIT 1) IS NOT NULL
  AND '2026-04-05'::date > '2026-04-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julián Bolaños' LIMIT 1),
  NULL,
  '2026-04-08'::date,
  '2026-04-09'::date,
  173680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julián Bolaños' LIMIT 1) IS NOT NULL
  AND '2026-04-09'::date > '2026-04-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'luis lira' LIMIT 1),
  'isidro rojas paredes',
  '2026-04-13'::date,
  '2026-04-19'::date,
  923663,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'luis lira' LIMIT 1) IS NOT NULL
  AND '2026-04-19'::date > '2026-04-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'natalia meneses' LIMIT 1),
  NULL,
  '2026-04-20'::date,
  '2026-04-21'::date,
  173680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'natalia meneses' LIMIT 1) IS NOT NULL
  AND '2026-04-21'::date > '2026-04-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1),
  NULL,
  '2026-04-21'::date,
  '2026-04-22'::date,
  176200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Barrera Nieto' LIMIT 1) IS NOT NULL
  AND '2026-04-22'::date > '2026-04-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  156797,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sofia Aristizabal' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Fabián Gelvis Gelvis Medina' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  176200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Fabián Gelvis Gelvis Medina' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Gabriel Rincon Vargas' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-17'::date,
  175000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Gabriel Rincon Vargas' LIMIT 1) IS NOT NULL
  AND '2026-05-17'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Acero' LIMIT 1),
  NULL,
  '2026-05-17'::date,
  '2026-05-18'::date,
  208260,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Acero' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 401),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'andres velasquez montoya' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-23'::date,
  182773,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'andres velasquez montoya' LIMIT 1) IS NOT NULL
  AND '2026-05-23'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Say Buritica' LIMIT 1),
  'Sofia Rodriguez',
  '2026-01-02'::date,
  '2026-01-04'::date,
  898628,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Say Buritica' LIMIT 1) IS NOT NULL
  AND '2026-01-04'::date > '2026-01-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Valencia' LIMIT 1),
  NULL,
  '2026-01-09'::date,
  '2026-01-11'::date,
  1053680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Valencia' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Colorado' LIMIT 1),
  'Marisol Osorio',
  '2026-01-24'::date,
  '2026-01-25'::date,
  138566,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Colorado' LIMIT 1) IS NOT NULL
  AND '2026-01-25'::date > '2026-01-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1),
  NULL,
  '2026-01-31'::date,
  '2026-02-01'::date,
  186734,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Rojas Saraza' LIMIT 1),
  NULL,
  '2026-02-07'::date,
  '2026-02-08'::date,
  170060,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Rojas Saraza' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1),
  NULL,
  '2026-02-14'::date,
  '2026-02-15'::date,
  186734,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1) IS NOT NULL
  AND '2026-02-15'::date > '2026-02-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camila Lopez' LIMIT 1),
  NULL,
  '2026-02-19'::date,
  '2026-02-20'::date,
  160000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camila Lopez' LIMIT 1) IS NOT NULL
  AND '2026-02-20'::date > '2026-02-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Estefania Ruiz' LIMIT 1),
  NULL,
  '2026-02-21'::date,
  '2026-02-22'::date,
  300000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Estefania Ruiz' LIMIT 1) IS NOT NULL
  AND '2026-02-22'::date > '2026-02-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Iván Andres Urrego Izquierdo' LIMIT 1),
  NULL,
  '2026-02-25'::date,
  '2026-02-26'::date,
  138280,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Iván Andres Urrego Izquierdo' LIMIT 1) IS NOT NULL
  AND '2026-02-26'::date > '2026-02-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jean Cherubin' LIMIT 1),
  'Johana Alvarez',
  '2026-02-27'::date,
  '2026-03-01'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jean Cherubin' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés Felipe Gonzalez' LIMIT 1),
  NULL,
  '2026-03-08'::date,
  '2026-03-09'::date,
  183217,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrés Felipe Gonzalez' LIMIT 1) IS NOT NULL
  AND '2026-03-09'::date > '2026-03-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Gabriela Bagaroza Escobar' LIMIT 1),
  NULL,
  '2026-03-11'::date,
  '2026-03-15'::date,
  534760,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Gabriela Bagaroza Escobar' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gilberto Durango Sepulveda' LIMIT 1),
  NULL,
  '2026-03-15'::date,
  '2026-03-20'::date,
  681099,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Gilberto Durango Sepulveda' LIMIT 1) IS NOT NULL
  AND '2026-03-20'::date > '2026-03-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Felipe Bedoya' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-21'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andres Felipe Bedoya' LIMIT 1) IS NOT NULL
  AND '2026-03-21'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Gutierrez' LIMIT 1),
  'andres Masmela Luna',
  '2026-03-21'::date,
  '2026-03-23'::date,
  320444,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Andrea Gutierrez' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Chavez' LIMIT 1),
  NULL,
  '2026-03-25'::date,
  '2026-03-30'::date,
  688571,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Chavez' LIMIT 1) IS NOT NULL
  AND '2026-03-30'::date > '2026-03-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lorena Tenorio' LIMIT 1),
  NULL,
  '2026-03-31'::date,
  '2026-04-01'::date,
  173680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Lorena Tenorio' LIMIT 1) IS NOT NULL
  AND '2026-04-01'::date > '2026-03-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Jose Arias Gutierrez' LIMIT 1),
  NULL,
  '2026-04-03'::date,
  '2026-04-04'::date,
  212746,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Jose Arias Gutierrez' LIMIT 1) IS NOT NULL
  AND '2026-04-04'::date > '2026-04-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Gomez' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-02'::date,
  166595,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Gomez' LIMIT 1) IS NOT NULL
  AND '2026-05-02'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Amaya Acosta' LIMIT 1),
  NULL,
  '2026-05-02'::date,
  '2026-05-03'::date,
  166595,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Amaya Acosta' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maritza Rivas' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-17'::date,
  208260,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maritza Rivas' LIMIT 1) IS NOT NULL
  AND '2026-05-17'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 402),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kevin Alexis Taborda Orozco' LIMIT 1),
  NULL,
  '2026-05-17'::date,
  '2026-05-18'::date,
  208260,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Kevin Alexis Taborda Orozco' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Hasbleidy Ibarra' LIMIT 1),
  'diego herrera molina',
  '2026-01-06'::date,
  '2026-01-08'::date,
  420000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Hasbleidy Ibarra' LIMIT 1) IS NOT NULL
  AND '2026-01-08'::date > '2026-01-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Heidi Barreto' LIMIT 1),
  'Fernando duque',
  '2026-01-08'::date,
  '2026-01-09'::date,
  220000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Heidi Barreto' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Felipe Cardozo' LIMIT 1),
  'valentina perez',
  '2026-01-09'::date,
  '2026-01-11'::date,
  980000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Felipe Cardozo' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Katherine Correa' LIMIT 1),
  NULL,
  '2026-01-11'::date,
  '2026-01-12'::date,
  148000,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Katherine Correa' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jose Alexander Giraldo Hurtado' LIMIT 1),
  'Maikol Gaviria',
  '2026-01-12'::date,
  '2026-01-13'::date,
  169920,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jose Alexander Giraldo Hurtado' LIMIT 1) IS NOT NULL
  AND '2026-01-13'::date > '2026-01-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jacobo Arango' LIMIT 1),
  NULL,
  '2026-01-19'::date,
  '2026-01-26'::date,
  998928,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jacobo Arango' LIMIT 1) IS NOT NULL
  AND '2026-01-26'::date > '2026-01-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Delgado' LIMIT 1),
  'Santiago Garcia',
  '2026-01-30'::date,
  '2026-02-01'::date,
  301005,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniela Delgado' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Correa Álvarez' LIMIT 1),
  'Natalia Buitrago',
  '2026-02-07'::date,
  '2026-02-08'::date,
  150838,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Alejandro Correa Álvarez' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Samuel Hernandez' LIMIT 1),
  'Luisa Fernanda Serrano',
  '2026-02-27'::date,
  '2026-03-01'::date,
  233640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Samuel Hernandez' LIMIT 1) IS NOT NULL
  AND '2026-03-01'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ivan Santiago Rios' LIMIT 1),
  NULL,
  '2026-03-02'::date,
  '2026-03-05'::date,
  497400,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ivan Santiago Rios' LIMIT 1) IS NOT NULL
  AND '2026-03-05'::date > '2026-03-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Marin' LIMIT 1),
  NULL,
  '2026-03-06'::date,
  '2026-03-07'::date,
  150000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mateo Marin' LIMIT 1) IS NOT NULL
  AND '2026-03-07'::date > '2026-03-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jose Luis Diaz Montaña' LIMIT 1),
  NULL,
  '2026-03-11'::date,
  '2026-03-15'::date,
  530329,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jose Luis Diaz Montaña' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angie Viviana Fuentes Quimbayo' LIMIT 1),
  NULL,
  '2026-03-18'::date,
  '2026-03-19'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angie Viviana Fuentes Quimbayo' LIMIT 1) IS NOT NULL
  AND '2026-03-19'::date > '2026-03-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paula Alvarez' LIMIT 1),
  'Emanuel Alvarez Vasquez',
  '2026-03-19'::date,
  '2026-03-21'::date,
  258689,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Paula Alvarez' LIMIT 1) IS NOT NULL
  AND '2026-03-21'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steven Escobar Castaño' LIMIT 1),
  'Medrano Sarah',
  '2026-03-21'::date,
  '2026-03-23'::date,
  302307,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Steven Escobar Castaño' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adriana Largo' LIMIT 1),
  'juan ablo vargas',
  '2026-03-25'::date,
  '2026-03-27'::date,
  258640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adriana Largo' LIMIT 1) IS NOT NULL
  AND '2026-03-27'::date > '2026-03-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Sebastian Lopez' LIMIT 1),
  'hugo aristizabal',
  '2026-03-28'::date,
  '2026-03-30'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Sebastian Lopez' LIMIT 1) IS NOT NULL
  AND '2026-03-30'::date > '2026-03-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angel Gonzalez' LIMIT 1),
  'juan camilo rios giraldo',
  '2026-03-30'::date,
  '2026-04-01'::date,
  279880,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angel Gonzalez' LIMIT 1) IS NOT NULL
  AND '2026-04-01'::date > '2026-03-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Denis Honorio Silva' LIMIT 1),
  'brayan david rengel',
  '2026-04-02'::date,
  '2026-04-05'::date,
  471881,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Denis Honorio Silva' LIMIT 1) IS NOT NULL
  AND '2026-04-05'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Heidi Barreto' LIMIT 1),
  NULL,
  '2026-04-06'::date,
  '2026-04-07'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Heidi Barreto' LIMIT 1) IS NOT NULL
  AND '2026-04-07'::date > '2026-04-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angie Viviana Fuentes Quimbayo' LIMIT 1),
  NULL,
  '2026-04-15'::date,
  '2026-04-16'::date,
  163060,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Angie Viviana Fuentes Quimbayo' LIMIT 1) IS NOT NULL
  AND '2026-04-16'::date > '2026-04-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Derek Matias Botero Ocampo' LIMIT 1),
  NULL,
  '2026-04-17'::date,
  '2026-04-18'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Derek Matias Botero Ocampo' LIMIT 1) IS NOT NULL
  AND '2026-04-18'::date > '2026-04-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Fernando Marulanda Moreno' LIMIT 1),
  NULL,
  '2026-04-27'::date,
  '2026-05-03'::date,
  612480,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Fernando Marulanda Moreno' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-04-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1),
  NULL,
  '2026-05-09'::date,
  '2026-05-10'::date,
  165432,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1) IS NOT NULL
  AND '2026-05-10'::date > '2026-05-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'natalia giraldo giraldo' LIMIT 1),
  NULL,
  '2026-05-11'::date,
  '2026-05-12'::date,
  140000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'natalia giraldo giraldo' LIMIT 1) IS NOT NULL
  AND '2026-05-12'::date > '2026-05-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'maria paula marin vitola' LIMIT 1),
  NULL,
  '2026-05-13'::date,
  '2026-05-14'::date,
  147878,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'maria paula marin vitola' LIMIT 1) IS NOT NULL
  AND '2026-05-14'::date > '2026-05-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Andres Chavarro Bahos' LIMIT 1),
  NULL,
  '2026-05-14'::date,
  '2026-05-16'::date,
  264282,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Andres Chavarro Bahos' LIMIT 1) IS NOT NULL
  AND '2026-05-16'::date > '2026-05-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Bermúdez Orozco' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-20'::date,
  576195,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Bermúdez Orozco' LIMIT 1) IS NOT NULL
  AND '2026-05-20'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 403),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Pryanka Gonzalez Sifontes' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-25'::date,
  488461,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Pryanka Gonzalez Sifontes' LIMIT 1) IS NOT NULL
  AND '2026-05-25'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Camila Dominguez' LIMIT 1),
  'Daniel Hoyos',
  '2026-01-07'::date,
  '2026-01-10'::date,
  1509243,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Camila Dominguez' LIMIT 1) IS NOT NULL
  AND '2026-01-10'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cesar Augusto Mejia Patiño' LIMIT 1),
  'marlin lopez',
  '2026-01-10'::date,
  '2026-01-11'::date,
  373235,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Cesar Augusto Mejia Patiño' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Martha Lucía Martinez Ramirez' LIMIT 1),
  NULL,
  '2026-01-11'::date,
  '2026-01-12'::date,
  189920,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Martha Lucía Martinez Ramirez' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Hurtado Euse' LIMIT 1),
  'Caril Roman Perez',
  '2026-01-14'::date,
  '2026-01-16'::date,
  246560,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Hurtado Euse' LIMIT 1) IS NOT NULL
  AND '2026-01-16'::date > '2026-01-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Melisa Gomez Cardenas' LIMIT 1),
  NULL,
  '2026-01-17'::date,
  '2026-01-18'::date,
  147440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Melisa Gomez Cardenas' LIMIT 1) IS NOT NULL
  AND '2026-01-18'::date > '2026-01-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian León' LIMIT 1),
  'David palacio',
  '2026-01-20'::date,
  '2026-01-21'::date,
  127049,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian León' LIMIT 1) IS NOT NULL
  AND '2026-01-21'::date > '2026-01-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Posada' LIMIT 1),
  NULL,
  '2026-01-21'::date,
  '2026-01-22'::date,
  127049,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Posada' LIMIT 1) IS NOT NULL
  AND '2026-01-22'::date > '2026-01-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Steven Ochoa Muñoz' LIMIT 1),
  NULL,
  '2026-01-24'::date,
  '2026-01-25'::date,
  153812,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Steven Ochoa Muñoz' LIMIT 1) IS NOT NULL
  AND '2026-01-25'::date > '2026-01-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camila Mojica Ramirez' LIMIT 1),
  NULL,
  '2026-01-25'::date,
  '2026-01-27'::date,
  287624,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camila Mojica Ramirez' LIMIT 1) IS NOT NULL
  AND '2026-01-27'::date > '2026-01-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Herrera' LIMIT 1),
  NULL,
  '2026-01-30'::date,
  '2026-01-31'::date,
  153812,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julian Herrera' LIMIT 1) IS NOT NULL
  AND '2026-01-31'::date > '2026-01-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Waleska Gonzalez Perez' LIMIT 1),
  'Ivan Antonio Henao',
  '2026-01-31'::date,
  '2026-02-05'::date,
  763400,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Maria Waleska Gonzalez Perez' LIMIT 1) IS NOT NULL
  AND '2026-02-05'::date > '2026-01-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Monica Alejandra Ramirez Hernandez' LIMIT 1),
  'Juan Sebastian Galindo',
  '2026-02-06'::date,
  '2026-02-07'::date,
  138944,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Monica Alejandra Ramirez Hernandez' LIMIT 1) IS NOT NULL
  AND '2026-02-07'::date > '2026-02-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Urano Idarraga Becerra' LIMIT 1),
  'Veronica Román agudelo',
  '2026-02-07'::date,
  '2026-02-08'::date,
  138944,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Urano Idarraga Becerra' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Fabian Naranjo' LIMIT 1),
  NULL,
  '2026-02-14'::date,
  '2026-02-15'::date,
  168680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Fabian Naranjo' LIMIT 1) IS NOT NULL
  AND '2026-02-15'::date > '2026-02-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Camila Perez Castro' LIMIT 1),
  'Juan Esteban Musiry',
  '2026-02-27'::date,
  '2026-03-02'::date,
  375460,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Camila Perez Castro' LIMIT 1) IS NOT NULL
  AND '2026-03-02'::date > '2026-02-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Yepez' LIMIT 1),
  NULL,
  '2026-03-04'::date,
  '2026-03-05'::date,
  173500,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Yepez' LIMIT 1) IS NOT NULL
  AND '2026-03-05'::date > '2026-03-04'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Fernando Ríos Osorio' LIMIT 1),
  'Maria Antonia Rios',
  '2026-03-05'::date,
  '2026-03-08'::date,
  375460,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Fernando Ríos Osorio' LIMIT 1) IS NOT NULL
  AND '2026-03-08'::date > '2026-03-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Diaz Rengifo' LIMIT 1),
  NULL,
  '2026-03-10'::date,
  '2026-03-11'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Diaz Rengifo' LIMIT 1) IS NOT NULL
  AND '2026-03-11'::date > '2026-03-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Iván Andres Urrego Izquierdo' LIMIT 1),
  NULL,
  '2026-03-11'::date,
  '2026-03-12'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Iván Andres Urrego Izquierdo' LIMIT 1) IS NOT NULL
  AND '2026-03-12'::date > '2026-03-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Iván Andres Urrego Izquierdo' LIMIT 1),
  NULL,
  '2026-03-12'::date,
  '2026-03-14'::date,
  271695,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Iván Andres Urrego Izquierdo' LIMIT 1) IS NOT NULL
  AND '2026-03-14'::date > '2026-03-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Garcia' LIMIT 1),
  NULL,
  '2026-03-14'::date,
  '2026-03-16'::date,
  375460,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Garcia' LIMIT 1) IS NOT NULL
  AND '2026-03-16'::date > '2026-03-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Johan Varela' LIMIT 1),
  NULL,
  '2026-03-18'::date,
  '2026-03-19'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Johan Varela' LIMIT 1) IS NOT NULL
  AND '2026-03-19'::date > '2026-03-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carolina Diaz Zuñiga' LIMIT 1),
  NULL,
  '2026-03-19'::date,
  '2026-03-20'::date,
  141820,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carolina Diaz Zuñiga' LIMIT 1) IS NOT NULL
  AND '2026-03-20'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'juan pablo restrepo robledo' LIMIT 1),
  'ana sofa moreno',
  '2026-03-20'::date,
  '2026-03-22'::date,
  268346,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'juan pablo restrepo robledo' LIMIT 1) IS NOT NULL
  AND '2026-03-22'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Oscar Alejandro Fajardo Rojas' LIMIT 1),
  'Rojas Maria Paula',
  '2026-03-22'::date,
  '2026-03-23'::date,
  148671,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Oscar Alejandro Fajardo Rojas' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brenda Lozano' LIMIT 1),
  NULL,
  '2026-03-24'::date,
  '2026-03-26'::date,
  284600,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brenda Lozano' LIMIT 1) IS NOT NULL
  AND '2026-03-26'::date > '2026-03-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carolina Diaz Zuñiga' LIMIT 1),
  NULL,
  '2026-03-26'::date,
  '2026-03-27'::date,
  152440,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carolina Diaz Zuñiga' LIMIT 1) IS NOT NULL
  AND '2026-03-27'::date > '2026-03-26'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Bedoya' LIMIT 1),
  'melo natalia',
  '2026-03-31'::date,
  '2026-04-02'::date,
  298510,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Bedoya' LIMIT 1) IS NOT NULL
  AND '2026-04-02'::date > '2026-03-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Palacio' LIMIT 1),
  'karen duarte',
  '2026-04-02'::date,
  '2026-04-04'::date,
  315874,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Diego Palacio' LIMIT 1) IS NOT NULL
  AND '2026-04-04'::date > '2026-04-02'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Perez Quintero Jhon Jairo' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  140432,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Perez Quintero Jhon Jairo' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Garcia Botina' LIMIT 1),
  NULL,
  '2026-04-30'::date,
  '2026-05-03'::date,
  421296,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'David Garcia Botina' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-04-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Avila Restrepo' LIMIT 1),
  NULL,
  '2026-05-09'::date,
  '2026-05-10'::date,
  165432,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Camilo Avila Restrepo' LIMIT 1) IS NOT NULL
  AND '2026-05-10'::date > '2026-05-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'maria paula marin vitola' LIMIT 1),
  NULL,
  '2026-05-13'::date,
  '2026-05-14'::date,
  147878,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'maria paula marin vitola' LIMIT 1) IS NOT NULL
  AND '2026-05-14'::date > '2026-05-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Andres Chavarro Bahos' LIMIT 1),
  NULL,
  '2026-05-14'::date,
  '2026-05-16'::date,
  264282,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Diego Andres Chavarro Bahos' LIMIT 1) IS NOT NULL
  AND '2026-05-16'::date > '2026-05-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Rodriguez Rendon' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-18'::date,
  297332,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Rodriguez Rendon' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 404),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mónica Gaitán Bedoya' LIMIT 1),
  NULL,
  '2026-05-24'::date,
  '2026-05-25'::date,
  147815,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mónica Gaitán Bedoya' LIMIT 1) IS NOT NULL
  AND '2026-05-25'::date > '2026-05-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luis Fernando Chaverra' LIMIT 1),
  NULL,
  '2026-01-03'::date,
  '2026-01-05'::date,
  700000,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luis Fernando Chaverra' LIMIT 1) IS NOT NULL
  AND '2026-01-05'::date > '2026-01-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mialet Pierre' LIMIT 1),
  'Luisa Pulido',
  '2026-01-05'::date,
  '2026-01-10'::date,
  1739569,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Mialet Pierre' LIMIT 1) IS NOT NULL
  AND '2026-01-10'::date > '2026-01-05'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Blanco' LIMIT 1),
  NULL,
  '2026-01-10'::date,
  '2026-01-12'::date,
  926240,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Blanco' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César García' LIMIT 1),
  NULL,
  '2026-02-14'::date,
  '2026-02-15'::date,
  165184,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César García' LIMIT 1) IS NOT NULL
  AND '2026-02-15'::date > '2026-02-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César García' LIMIT 1),
  NULL,
  '2026-02-15'::date,
  '2026-02-16'::date,
  165184,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César García' LIMIT 1) IS NOT NULL
  AND '2026-02-16'::date > '2026-02-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César García' LIMIT 1),
  NULL,
  '2026-02-19'::date,
  '2026-02-21'::date,
  375460,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'César García' LIMIT 1) IS NOT NULL
  AND '2026-02-21'::date > '2026-02-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Stuart Ospina Muñoz' LIMIT 1),
  NULL,
  '2026-02-21'::date,
  '2026-02-22'::date,
  173680,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Santiago Stuart Ospina Muñoz' LIMIT 1) IS NOT NULL
  AND '2026-02-22'::date > '2026-02-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Stefan Billing' LIMIT 1),
  NULL,
  '2026-03-07'::date,
  '2026-03-10'::date,
  407320,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Stefan Billing' LIMIT 1) IS NOT NULL
  AND '2026-03-10'::date > '2026-03-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jenifer Sandoval Alvarado' LIMIT 1),
  NULL,
  '2026-03-13'::date,
  '2026-03-15'::date,
  300000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jenifer Sandoval Alvarado' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-13'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juanita Calle Duque' LIMIT 1),
  'Julian Tabares',
  '2026-03-17'::date,
  '2026-03-24'::date,
  909574,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juanita Calle Duque' LIMIT 1) IS NOT NULL
  AND '2026-03-24'::date > '2026-03-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ramirez Ramirez Gonzalo de Jesus' LIMIT 1),
  NULL,
  '2026-03-28'::date,
  '2026-03-29'::date,
  202503,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ramirez Ramirez Gonzalo de Jesus' LIMIT 1) IS NOT NULL
  AND '2026-03-29'::date > '2026-03-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Moises Cuello' LIMIT 1),
  NULL,
  '2026-04-01'::date,
  '2026-04-03'::date,
  347600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Moises Cuello' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Mora' LIMIT 1),
  NULL,
  '2026-04-03'::date,
  '2026-04-05'::date,
  474357,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ana Maria Mora' LIMIT 1) IS NOT NULL
  AND '2026-04-05'::date > '2026-04-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'helena groso rodriguez' LIMIT 1),
  NULL,
  '2026-04-08'::date,
  '2026-04-10'::date,
  312164,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'helena groso rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-04-10'::date > '2026-04-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Christian Figueroa' LIMIT 1),
  NULL,
  '2026-04-24'::date,
  '2026-04-27'::date,
  382800,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Christian Figueroa' LIMIT 1) IS NOT NULL
  AND '2026-04-27'::date > '2026-04-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'edison huerta montoya' LIMIT 1),
  'juan esteban blanco montoya',
  '2026-05-01'::date,
  '2026-05-04'::date,
  550000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'edison huerta montoya' LIMIT 1) IS NOT NULL
  AND '2026-05-04'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Vergara Cardona' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-17'::date,
  188485,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David Vergara Cardona' LIMIT 1) IS NOT NULL
  AND '2026-05-17'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Johan Javier Carrillo días' LIMIT 1),
  NULL,
  '2026-05-19'::date,
  '2026-05-22'::date,
  475000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Johan Javier Carrillo días' LIMIT 1) IS NOT NULL
  AND '2026-05-22'::date > '2026-05-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 405),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Pérez De la cruz' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-24'::date,
  322212,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Pérez De la cruz' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhoa Ariza' LIMIT 1),
  '3105136852',
  '2026-01-01'::date,
  '2026-01-04'::date,
  637070,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jhoa Ariza' LIMIT 1) IS NOT NULL
  AND '2026-01-04'::date > '2026-01-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Peter Dario Carvajal' LIMIT 1),
  'Adriana Largo',
  '2026-01-07'::date,
  '2026-01-10'::date,
  1278064,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Peter Dario Carvajal' LIMIT 1) IS NOT NULL
  AND '2026-01-10'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Enrique Toro Vera' LIMIT 1),
  'Elisa Aristizabal',
  '2026-01-10'::date,
  '2026-01-12'::date,
  1152800,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Enrique Toro Vera' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Catalina Rodriguez' LIMIT 1),
  NULL,
  '2026-01-30'::date,
  '2026-02-03'::date,
  611888,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Catalina Rodriguez' LIMIT 1) IS NOT NULL
  AND '2026-02-03'::date > '2026-01-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sindry Paola Camargo' LIMIT 1),
  NULL,
  '2026-02-07'::date,
  '2026-02-08'::date,
  144254,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sindry Paola Camargo' LIMIT 1) IS NOT NULL
  AND '2026-02-08'::date > '2026-02-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Jiménez' LIMIT 1),
  NULL,
  '2026-03-12'::date,
  '2026-03-15'::date,
  407320,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Jiménez' LIMIT 1) IS NOT NULL
  AND '2026-03-15'::date > '2026-03-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Duarte' LIMIT 1),
  NULL,
  '2026-03-20'::date,
  '2026-03-23'::date,
  460487,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Duarte' LIMIT 1) IS NOT NULL
  AND '2026-03-23'::date > '2026-03-20'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sergio Velasquez' LIMIT 1),
  NULL,
  '2026-03-27'::date,
  '2026-03-29'::date,
  280151,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sergio Velasquez' LIMIT 1) IS NOT NULL
  AND '2026-03-29'::date > '2026-03-27'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David García Quintero' LIMIT 1),
  NULL,
  '2026-03-30'::date,
  '2026-04-01'::date,
  287702,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David García Quintero' LIMIT 1) IS NOT NULL
  AND '2026-04-01'::date > '2026-03-30'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Rosie Mohr' LIMIT 1),
  'andres sntiago ocoro',
  '2026-04-01'::date,
  '2026-04-03'::date,
  347600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Rosie Mohr' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-04-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julieth Beltran' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-05'::date,
  488070,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julieth Beltran' LIMIT 1) IS NOT NULL
  AND '2026-05-05'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julián David Mendoza quintero' LIMIT 1),
  NULL,
  '2026-05-10'::date,
  '2026-05-12'::date,
  416990,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Julián David Mendoza quintero' LIMIT 1) IS NOT NULL
  AND '2026-05-12'::date > '2026-05-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 406),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'jose Vargas' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-18'::date,
  325920,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'jose Vargas' LIMIT 1) IS NOT NULL
  AND '2026-05-18'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ali Rudi' LIMIT 1),
  NULL,
  '2026-01-07'::date,
  '2026-01-09'::date,
  420000,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Ali Rudi' LIMIT 1) IS NOT NULL
  AND '2026-01-09'::date > '2026-01-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sandra Bustos' LIMIT 1),
  NULL,
  '2026-01-09'::date,
  '2026-01-10'::date,
  208806,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sandra Bustos' LIMIT 1) IS NOT NULL
  AND '2026-01-10'::date > '2026-01-09'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Andres Moreno Velez' LIMIT 1),
  'Luisa Durango',
  '2026-01-10'::date,
  '2026-01-11'::date,
  334685,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Jorge Andres Moreno Velez' LIMIT 1) IS NOT NULL
  AND '2026-01-11'::date > '2026-01-10'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Leonardo Saavedra Delgado' LIMIT 1),
  'Sebastian Saavedra',
  '2026-01-11'::date,
  '2026-01-12'::date,
  171040,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Leonardo Saavedra Delgado' LIMIT 1) IS NOT NULL
  AND '2026-01-12'::date > '2026-01-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Machado' LIMIT 1),
  'Mary Luz Martinez',
  '2026-01-31'::date,
  '2026-02-01'::date,
  144254,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Pablo Machado' LIMIT 1) IS NOT NULL
  AND '2026-02-01'::date > '2026-01-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brayan Rendon Gonzalez' LIMIT 1),
  NULL,
  '2026-02-06'::date,
  '2026-02-07'::date,
  144254,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Brayan Rendon Gonzalez' LIMIT 1) IS NOT NULL
  AND '2026-02-07'::date > '2026-02-06'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Victor Hugo Osorio Gutierrez' LIMIT 1),
  NULL,
  '2026-02-14'::date,
  '2026-02-16'::date,
  248508,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Victor Hugo Osorio Gutierrez' LIMIT 1) IS NOT NULL
  AND '2026-02-16'::date > '2026-02-14'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1),
  NULL,
  '2026-02-21'::date,
  '2026-02-22'::date,
  138060,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Sebastian Gutiérrez Vanegas' LIMIT 1) IS NOT NULL
  AND '2026-02-22'::date > '2026-02-21'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adrián Zapata' LIMIT 1),
  'Yorgelis karime Urbano',
  '2026-02-28'::date,
  '2026-03-02'::date,
  258640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adrián Zapata' LIMIT 1) IS NOT NULL
  AND '2026-03-02'::date > '2026-02-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Eder Quintero' LIMIT 1),
  NULL,
  '2026-03-11'::date,
  '2026-03-13'::date,
  258640,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Eder Quintero' LIMIT 1) IS NOT NULL
  AND '2026-03-13'::date > '2026-03-11'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edwin Samuel Lopez Cadena' LIMIT 1),
  NULL,
  '2026-03-19'::date,
  '2026-03-24'::date,
  600000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Edwin Samuel Lopez Cadena' LIMIT 1) IS NOT NULL
  AND '2026-03-24'::date > '2026-03-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David García Quintero' LIMIT 1),
  NULL,
  '2026-03-29'::date,
  '2026-03-30'::date,
  143000,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David García Quintero' LIMIT 1) IS NOT NULL
  AND '2026-03-30'::date > '2026-03-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adriana Suarez Rojas' LIMIT 1),
  'willian jaramillo',
  '2026-03-31'::date,
  '2026-04-03'::date,
  425950,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Adriana Suarez Rojas' LIMIT 1) IS NOT NULL
  AND '2026-04-03'::date > '2026-03-31'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Blanco' LIMIT 1),
  NULL,
  '2026-04-03'::date,
  '2026-04-05'::date,
  319598,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Carlos Blanco' LIMIT 1) IS NOT NULL
  AND '2026-04-05'::date > '2026-04-03'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Lopez Soto' LIMIT 1),
  NULL,
  '2026-04-17'::date,
  '2026-04-18'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Natalia Lopez Soto' LIMIT 1) IS NOT NULL
  AND '2026-04-18'::date > '2026-04-17'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luisa Gil Henao' LIMIT 1),
  NULL,
  '2026-04-18'::date,
  '2026-04-19'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Luisa Gil Henao' LIMIT 1) IS NOT NULL
  AND '2026-04-19'::date > '2026-04-18'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Mejia' LIMIT 1),
  NULL,
  '2026-04-24'::date,
  '2026-04-25'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Manuel Mejia' LIMIT 1) IS NOT NULL
  AND '2026-04-25'::date > '2026-04-24'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Tirado Pelaez' LIMIT 1),
  NULL,
  '2026-04-25'::date,
  '2026-04-26'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Daniel Tirado Pelaez' LIMIT 1) IS NOT NULL
  AND '2026-04-26'::date > '2026-04-25'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Hurtado Euse' LIMIT 1),
  NULL,
  '2026-04-28'::date,
  '2026-04-29'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Camilo Hurtado Euse' LIMIT 1) IS NOT NULL
  AND '2026-04-29'::date > '2026-04-28'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Omar Gomez Taborda' LIMIT 1),
  NULL,
  '2026-04-29'::date,
  '2026-05-01'::date,
  255200,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Omar Gomez Taborda' LIMIT 1) IS NOT NULL
  AND '2026-05-01'::date > '2026-04-29'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Everton Ávila' LIMIT 1),
  NULL,
  '2026-05-01'::date,
  '2026-05-03'::date,
  245630,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Everton Ávila' LIMIT 1) IS NOT NULL
  AND '2026-05-03'::date > '2026-05-01'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David López Mejía' LIMIT 1),
  NULL,
  '2026-05-07'::date,
  '2026-05-08'::date,
  127600,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan David López Mejía' LIMIT 1) IS NOT NULL
  AND '2026-05-08'::date > '2026-05-07'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Canon' LIMIT 1),
  NULL,
  '2026-05-08'::date,
  '2026-05-10'::date,
  245630,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Canon' LIMIT 1) IS NOT NULL
  AND '2026-05-10'::date > '2026-05-08'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yeiny Covaleda Guzman' LIMIT 1),
  NULL,
  '2026-05-12'::date,
  '2026-05-14'::date,
  250415,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Yeiny Covaleda Guzman' LIMIT 1) IS NOT NULL
  AND '2026-05-14'::date > '2026-05-12'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Castaneda' LIMIT 1),
  NULL,
  '2026-05-15'::date,
  '2026-05-16'::date,
  366054,
  (SELECT id FROM public.operadores WHERE nombre = 'Booking'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Juan Castaneda' LIMIT 1) IS NOT NULL
  AND '2026-05-16'::date > '2026-05-15'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Loaiza' LIMIT 1),
  NULL,
  '2026-05-16'::date,
  '2026-05-19'::date,
  407800,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Laura Loaiza' LIMIT 1) IS NOT NULL
  AND '2026-05-19'::date > '2026-05-16'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'fabio andres jaramillo' LIMIT 1),
  NULL,
  '2026-05-19'::date,
  '2026-05-20'::date,
  136650,
  (SELECT id FROM public.operadores WHERE nombre = 'Terceros'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'fabio andres jaramillo' LIMIT 1) IS NOT NULL
  AND '2026-05-20'::date > '2026-05-19'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'CARLOS A FRAGOZO L' LIMIT 1),
  NULL,
  '2026-05-22'::date,
  '2026-05-23'::date,
  94194,
  (SELECT id FROM public.operadores WHERE nombre = 'Alexander'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'CARLOS A FRAGOZO L' LIMIT 1) IS NOT NULL
  AND '2026-05-23'::date > '2026-05-22'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Lopez Obando' LIMIT 1),
  NULL,
  '2026-05-23'::date,
  '2026-05-24'::date,
  165360,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Lopez Obando' LIMIT 1) IS NOT NULL
  AND '2026-05-24'::date > '2026-05-23'::date;
INSERT INTO public.reservas (habitacion_id, huesped_id, acompanante, fecha_entrada, fecha_salida, pago_total, operador_id, estado)
SELECT
  (SELECT id FROM public.habitaciones WHERE numero = 407),
  (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Lopez Obando' LIMIT 1),
  NULL,
  '2026-05-24'::date,
  '2026-05-25'::date,
  165360,
  (SELECT id FROM public.operadores WHERE nombre = 'Airbnb'),
  'completada'
WHERE (SELECT id FROM public.huespedes WHERE nombre ILIKE 'Valentina Lopez Obando' LIMIT 1) IS NOT NULL
  AND '2026-05-25'::date > '2026-05-24'::date;
