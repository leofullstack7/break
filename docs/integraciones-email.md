# Integración Email Transaccional — Resend
## Flux — Ingeniero de Integraciones
**Estado:** Implementado · **Fecha:** 2026-06-23

---

## 1. Visión General

Resend es el servicio de email transaccional del hotel. Envía correos automáticos en momentos clave de la estadía del huésped. Plan gratuito: **3.000 emails/mes** — más que suficiente para la operación actual (~650 reservas/año × 3 emails = ~1.950 emails/año).

```
Evento en la app
    │
    ├── Reserva confirmada → email confirmación
    ├── 2 horas antes del check-in → email pre check-in
    └── Después del check-out → email post-estadía (reseña)
    │
    ▼
Edge Function: send-email
    │
    ├── Renderiza plantilla HTML (ADN Break)
    ├── Envía vía Resend API
    └── Guarda log en tabla email_logs
```

---

## 2. Configuración de Resend (Zaven — 10 min)

### Paso 1: Crear cuenta

1. Ir a [resend.com](https://resend.com) → **Sign up** con Google o email
2. Confirmar el correo de verificación

### Paso 2: Obtener API Key

1. En el dashboard de Resend → **API Keys** (menú lateral)
2. Click **Create API Key**
   - Nombre: `break-hotel-supabase`
   - Permisos: **Sending access** (solo enviar)
   - Dominio: **All domains** (por ahora)
3. Copiar la API Key (empieza con `re_`)
4. **Guardarla de forma segura** — solo se muestra una vez

### Paso 3: Configurar dominio (opcional pero recomendado)

Para enviar desde `@breakmanizales.com` en vez del dominio de prueba:

1. En Resend → **Domains** → **Add Domain**
2. Escribir: `breakmanizales.com`
3. Resend mostrará 3 registros DNS que hay que agregar en Hostinger:
   - **SPF** (TXT record)
   - **DKIM** (TXT record)
   - **DMARC** (TXT record, opcional pero recomendado)
4. Ir a **Hostinger** → DNS Zone del dominio → agregar los 3 registros TXT
5. Volver a Resend → **Verify** — puede tardar hasta 24h

**Sin dominio verificado:** los emails se envían desde `onboarding@resend.dev` (funcional para pruebas, pero llega como "vía resend.dev" y puede caer en spam).

### Paso 4: Guardar secrets en Supabase

En **Supabase Dashboard → Edge Functions → Secrets**, agregar:

```
RESEND_API_KEY=re_xxxxxxxxxxxxxxxxxxxxxxxxxxxx
RESEND_FROM_EMAIL=Break Hotel <reservas@breakmanizales.com>
```

Si aún no se verifica el dominio, usar temporalmente:
```
RESEND_FROM_EMAIL=Break Hotel <onboarding@resend.dev>
```

---

## 3. Edge Function: `send-email`

### 3.1 Ubicación

```
supabase/functions/
  send-email/
    index.ts          ← función principal
  _shared/
    resend.ts         ← cliente Resend
    email-templates.ts ← plantillas HTML
    supabase-admin.ts ← cliente Supabase (ya existía)
```

### 3.2 Endpoint

```
POST https://<project>.supabase.co/functions/v1/send-email
Authorization: Bearer <jwt_o_service_role_key>
Content-Type: application/json
```

### 3.3 Body del request

```json
{
  "tipo": "confirmacion_reserva",
  "destinatario": "huesped@email.com",
  "datos_reserva": {
    "nombre_huesped": "María García",
    "habitacion_numero": 301,
    "fecha_entrada": "2026-07-15",
    "fecha_salida": "2026-07-18",
    "noches": 3,
    "pago_total": 420000
  }
}
```

### 3.4 Tipos de email disponibles

| Tipo | Cuándo se envía | Subject |
|---|---|---|
| `confirmacion_reserva` | Al confirmar una reserva | "Reserva confirmada — Estudio 301 · Break Hotel" |
| `pre_checkin` | 2 horas antes del check-in | "Tu estudio te espera hoy — Break Hotel" |
| `post_estadia` | Después del check-out | "Gracias por hospedarte en Break, María" |

### 3.5 Respuestas

**Éxito (200):**
```json
{ "ok": true, "resend_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890" }
```

**Error de validación (400):**
```json
{ "error": "Campos requeridos: tipo, destinatario, datos_reserva" }
```

**Error de envío (502):**
```json
{ "error": "Resend 403: Invalid API key" }
```

---

## 4. Plantillas de Email

Las 3 plantillas siguen el ADN de Break: fondo beige `#f5f0eb`, header negro `#1a1a1a` con logo dorado `#c9a96e`, tipografía sans-serif, diseño minimalista y responsive.

### 4.1 Confirmación de reserva

- **Trigger:** reserva pasa a estado `confirmada`
- **Contenido:** detalles de la reserva (habitación, fechas, noches, total), horarios de check-in/out, CTA de WhatsApp
- **Tono:** cálido, profesional, informativo

### 4.2 Pre check-in (2 horas antes)

- **Trigger:** cron job o trigger temporal 2h antes de `fecha_entrada`
- **Contenido:** número de habitación y piso, instrucciones de llegada (dirección, recepción, WiFi), CTA de WhatsApp para cambios
- **Tono:** acogedor, práctico

### 4.3 Post-estadía (solicitud de reseña)

- **Trigger:** reserva pasa a estado `completada`
- **Contenido:** resumen de la estadía, CTA prominente para reseña en Google, invitación a reservar directo la próxima vez
- **Tono:** agradecido, breve, sin presión

---

## 5. Tabla `email_logs`

Cada email enviado queda registrado para auditoría y debugging.

### 5.1 Schema

```sql
create table public.email_logs (
  id            uuid primary key default uuid_generate_v4(),
  tipo          text not null,
  destinatario  text not null,
  asunto        text not null,
  resend_id     text,
  estado        text not null check (estado in ('enviado', 'fallido')),
  error         text,
  metadata      jsonb,
  created_at    timestamptz not null default now()
);
```

### 5.2 RLS

- Solo `service_role` puede insertar (la Edge Function)
- Solo `gerente` puede leer (para ver historial en el admin)

### 5.3 Migración

Archivo: `docs/migration_email_logs.sql` — ejecutar en Supabase SQL Editor.

---

## 6. Despliegue

### Paso 1: Ejecutar migración SQL (Zaven — 2 min)

1. Abrir **Supabase Dashboard → SQL Editor → New query**
2. Copiar y pegar el contenido de `docs/migration_email_logs.sql`
3. Ejecutar

### Paso 2: Configurar secrets (Zaven — 2 min)

En **Supabase Dashboard → Edge Functions → Secrets**:

```
RESEND_API_KEY=re_xxxxxxxxxxxx
RESEND_FROM_EMAIL=Break Hotel <reservas@breakmanizales.com>
```

### Paso 3: Desplegar la función (Zaven — 2 min)

```bash
supabase functions deploy send-email --project-ref <ref>
```

O desde el dashboard: **Edge Functions → Deploy** y subir el directorio `supabase/functions/send-email/`.

### Paso 4: Probar

```bash
curl -X POST https://<project>.supabase.co/functions/v1/send-email \
  -H "Authorization: Bearer <service_role_key>" \
  -H "Content-Type: application/json" \
  -d '{
    "tipo": "confirmacion_reserva",
    "destinatario": "manizalescompartedigital@gmail.com",
    "datos_reserva": {
      "nombre_huesped": "Zaven (Test)",
      "habitacion_numero": 301,
      "fecha_entrada": "2026-07-01",
      "fecha_salida": "2026-07-03",
      "noches": 2,
      "pago_total": 280000
    }
  }'
```

---

## 7. Automatización futura

Estos triggers se implementarán cuando la app lo requiera:

| Evento | Implementación |
|---|---|
| Reserva confirmada | Llamar `send-email` desde el flujo de creación de reserva (frontend o backend) |
| Pre check-in (2h antes) | Cron job de Supabase (`pg_cron`) que consulta reservas con check-in hoy y envía 2h antes |
| Post-estadía | Trigger de base de datos cuando reserva cambia a `completada`, o cron diario |

---

## 8. Límites del plan gratuito de Resend

| Límite | Valor |
|---|---|
| Emails por mes | 3.000 |
| Emails por día | 100 |
| Dominios | 1 |
| API Keys | Sin límite |
| Logs de emails | 1 día de retención |
| Supresiones | Automáticas |

Con ~650 reservas/año y 3 emails por reserva = ~1.950 emails/año (~163/mes). Estamos al **5.4%** del límite mensual.

---

## 9. Notas de seguridad

- La API Key de Resend **nunca** se expone al frontend — solo vive en Supabase Edge Function Secrets
- La función `send-email` requiere JWT válido (`verify_jwt = true`) — solo puede ser llamada por la app autenticada o por otras Edge Functions usando `service_role`
- Los emails se envían con `reply_to: reservas@breakmanizales.com` para que las respuestas lleguen al correo del hotel

---

*Documentación generada por Flux — Ingeniero de Integraciones*
*Servicio: [Resend](https://resend.com) · [API Docs](https://resend.com/docs/api-reference/emails/send-email)*
