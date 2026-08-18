-- ================================================================
-- CAMBIOS DE ESQUEMA PARA ASEO Y RESERVAS
-- Ejecutar en Supabase → SQL Editor → New query
-- ================================================================

-- 1. Cédula del acompañante en reservas
ALTER TABLE public.reservas
  ADD COLUMN IF NOT EXISTS cc_acompanante text;

-- 2. Constraint único en aseos (una entrada por habitación por día)
--    Permite usar upsert desde el frontend
ALTER TABLE public.aseos
  DROP CONSTRAINT IF EXISTS aseos_habitacion_fecha_unique;

ALTER TABLE public.aseos
  ADD CONSTRAINT aseos_habitacion_fecha_unique
  UNIQUE (habitacion_id, fecha);

-- 3. Guardar fecha del último aseo completado en habitaciones
ALTER TABLE public.habitaciones
  ADD COLUMN IF NOT EXISTS ultima_limpieza date;

-- 4. Trigger: cuando aseo se marca completado → actualizar ultima_limpieza
--    y poner habitación en "disponible"
CREATE OR REPLACE FUNCTION public.fn_aseo_completado()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.estado = 'completado'
     AND (OLD.estado IS NULL OR OLD.estado <> 'completado') THEN

    -- Registrar última limpieza
    UPDATE public.habitaciones
    SET ultima_limpieza = NEW.fecha
    WHERE id = NEW.habitacion_id
      AND (ultima_limpieza IS NULL OR ultima_limpieza <= NEW.fecha);

    -- Marcar habitación disponible (si estaba en aseo)
    UPDATE public.habitaciones
    SET estado = 'disponible'
    WHERE id = NEW.habitacion_id
      AND estado IN ('aseo', 'ocupada');

  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_aseo_completado ON public.aseos;
CREATE TRIGGER trg_aseo_completado
  AFTER INSERT OR UPDATE OF estado ON public.aseos
  FOR EACH ROW EXECUTE FUNCTION public.fn_aseo_completado();

-- 5. Política RLS para aseos — marketing también puede ver
DROP POLICY IF EXISTS "marketing lee aseos" ON public.aseos;
CREATE POLICY "marketing lee aseos"
  ON public.aseos FOR SELECT
  USING (public.get_mi_rol() = 'marketing');
