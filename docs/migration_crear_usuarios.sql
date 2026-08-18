-- ============================================================
-- Break Hotel — Crear usuarios del equipo
-- Ejecutar en: Supabase Dashboard → SQL Editor → New query
--
-- Este script crea 5 usuarios (uno por rol) en auth.users
-- y sus perfiles en public.usuarios.
--
-- IMPORTANTE: Después de ejecutar, cada usuario puede iniciar
-- sesión en /login con su correo y contraseña.
-- ============================================================

-- Generar IDs fijos para poder vincular auth.users con public.usuarios
DO $$
DECLARE
  v_id_gerente    uuid;
  v_id_recepcion  uuid;
  v_id_aseo       uuid;
  v_id_marketing  uuid;
BEGIN
  -- ── 1. GERENTE (CEO — Zaven) ──
  INSERT INTO auth.users (
    instance_id, id, aud, role,
    email, encrypted_password,
    email_confirmed_at, created_at, updated_at,
    raw_app_meta_data, raw_user_meta_data,
    confirmation_token, recovery_token, email_change_token_new,
    is_super_admin
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(), 'authenticated', 'authenticated',
    'gerencia@breakmanizales.com',
    crypt('Break2026!Gerencia', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}', '{}',
    '', '', '', false
  ) RETURNING id INTO v_id_gerente;

  INSERT INTO auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
  VALUES (gen_random_uuid(), v_id_gerente, 'gerencia@breakmanizales.com',
    jsonb_build_object('sub', v_id_gerente::text, 'email', 'gerencia@breakmanizales.com'),
    'email', now(), now(), now());

  INSERT INTO public.usuarios (id, nombre, rol, email, activo)
  VALUES (v_id_gerente, 'Zaven', 'gerente', 'gerencia@breakmanizales.com', true);


  -- ── 2. RECEPCIÓN ──
  INSERT INTO auth.users (
    instance_id, id, aud, role,
    email, encrypted_password,
    email_confirmed_at, created_at, updated_at,
    raw_app_meta_data, raw_user_meta_data,
    confirmation_token, recovery_token, email_change_token_new,
    is_super_admin
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(), 'authenticated', 'authenticated',
    'recepcion@breakmanizales.com',
    crypt('Break2026!Recepcion', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}', '{}',
    '', '', '', false
  ) RETURNING id INTO v_id_recepcion;

  INSERT INTO auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
  VALUES (gen_random_uuid(), v_id_recepcion, 'recepcion@breakmanizales.com',
    jsonb_build_object('sub', v_id_recepcion::text, 'email', 'recepcion@breakmanizales.com'),
    'email', now(), now(), now());

  INSERT INTO public.usuarios (id, nombre, rol, email, activo)
  VALUES (v_id_recepcion, 'Recepción', 'recepcion', 'recepcion@breakmanizales.com', true);


  -- ── 3. ASEO ──
  INSERT INTO auth.users (
    instance_id, id, aud, role,
    email, encrypted_password,
    email_confirmed_at, created_at, updated_at,
    raw_app_meta_data, raw_user_meta_data,
    confirmation_token, recovery_token, email_change_token_new,
    is_super_admin
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(), 'authenticated', 'authenticated',
    'aseo@breakmanizales.com',
    crypt('Break2026!Aseo', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}', '{}',
    '', '', '', false
  ) RETURNING id INTO v_id_aseo;

  INSERT INTO auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
  VALUES (gen_random_uuid(), v_id_aseo, 'aseo@breakmanizales.com',
    jsonb_build_object('sub', v_id_aseo::text, 'email', 'aseo@breakmanizales.com'),
    'email', now(), now(), now());

  INSERT INTO public.usuarios (id, nombre, rol, email, activo)
  VALUES (v_id_aseo, 'Equipo Aseo', 'aseo', 'aseo@breakmanizales.com', true);


  -- ── 4. MARKETING ──
  INSERT INTO auth.users (
    instance_id, id, aud, role,
    email, encrypted_password,
    email_confirmed_at, created_at, updated_at,
    raw_app_meta_data, raw_user_meta_data,
    confirmation_token, recovery_token, email_change_token_new,
    is_super_admin
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(), 'authenticated', 'authenticated',
    'marketing@breakmanizales.com',
    crypt('Break2026!Marketing', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}', '{}',
    '', '', '', false
  ) RETURNING id INTO v_id_marketing;

  INSERT INTO auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
  VALUES (gen_random_uuid(), v_id_marketing, 'marketing@breakmanizales.com',
    jsonb_build_object('sub', v_id_marketing::text, 'email', 'marketing@breakmanizales.com'),
    'email', now(), now(), now());

  INSERT INTO public.usuarios (id, nombre, rol, email, activo)
  VALUES (v_id_marketing, 'Marketing', 'marketing', 'marketing@breakmanizales.com', true);

  RAISE NOTICE '✅ 4 usuarios creados exitosamente';
  RAISE NOTICE 'Gerente:    gerencia@breakmanizales.com';
  RAISE NOTICE 'Recepción:  recepcion@breakmanizales.com';
  RAISE NOTICE 'Aseo:       aseo@breakmanizales.com';
  RAISE NOTICE 'Marketing:  marketing@breakmanizales.com';
END $$;
