-- ================================================================
-- Nuevos estados, timestamps de check-in/out, y función auto-ocupada
-- Ejecutar en Supabase SQL Editor
-- ================================================================

-- 1. Agregar 'recien_ingreso' al constraint de habitaciones
ALTER TABLE public.habitaciones
  DROP CONSTRAINT IF EXISTS estado_habitacion_valido;

ALTER TABLE public.habitaciones
  ADD CONSTRAINT estado_habitacion_valido
  CHECK (estado IN ('disponible','ocupada','aseo','mantenimiento','recien_ingreso'));

-- 2. Timestamps reales de check-in y check-out en reservas
ALTER TABLE public.reservas
  ADD COLUMN IF NOT EXISTS fecha_checkin_real  timestamptz,
  ADD COLUMN IF NOT EXISTS fecha_checkout_real timestamptz;

-- 3. Función: auto-transición recien_ingreso → ocupada pasada 1 hora
--    Se llama desde el frontend al cargar el dashboard/aseo
CREATE OR REPLACE FUNCTION public.auto_ocupada()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE public.habitaciones h
  SET estado = 'ocupada'
  FROM public.reservas r
  WHERE h.id = r.habitacion_id
    AND h.estado = 'recien_ingreso'
    AND r.estado = 'activa'
    AND r.fecha_checkin_real IS NOT NULL
    AND r.fecha_checkin_real < now() - interval '1 hour';
END;
$$;

-- 4. Trigger: al hacer check-out desde reservas → habitación pasa a 'aseo'
--    y se crea tarea de aseo automáticamente
CREATE OR REPLACE FUNCTION public.fn_checkout_aseo()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  -- Solo actuar cuando pasa de activa → completada
  IF NEW.estado = 'completada'
     AND OLD.estado IN ('activa','confirmada')
     AND NEW.fecha_checkout_real IS NOT NULL THEN

    -- Marcar habitación para aseo
    UPDATE public.habitaciones
    SET estado = 'aseo'
    WHERE id = NEW.habitacion_id;

    -- Crear tarea de aseo si no existe para hoy
    INSERT INTO public.aseos (habitacion_id, reserva_id, fecha, estado, tipo_aseo)
    VALUES (NEW.habitacion_id, NEW.id, CURRENT_DATE, 'pendiente', 'salida')
    ON CONFLICT (habitacion_id, fecha) DO UPDATE
      SET estado = 'pendiente';

  END IF;

  -- Al hacer check-in → habitación pasa a recien_ingreso
  IF NEW.fecha_checkin_real IS NOT NULL
     AND OLD.fecha_checkin_real IS NULL THEN
    UPDATE public.habitaciones
    SET estado = 'recien_ingreso'
    WHERE id = NEW.habitacion_id;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_checkout_aseo ON public.reservas;
CREATE TRIGGER trg_checkout_aseo
  AFTER UPDATE OF estado, fecha_checkin_real, fecha_checkout_real ON public.reservas
  FOR EACH ROW EXECUTE FUNCTION public.fn_checkout_aseo();

-- 5. Política: huésped puede actualizar SU reserva (check-in/out)
DROP POLICY IF EXISTS "huesped puede hacer checkin" ON public.reservas;
CREATE POLICY "huesped puede hacer checkin"
  ON public.reservas FOR UPDATE
  USING (
    public.get_mi_rol() = 'huesped'
    AND huesped_id = (
      SELECT id FROM public.huespedes
      WHERE correo = auth.email()
      LIMIT 1
    )
  );
