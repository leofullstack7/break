# Facturas de compra → Siigo (bandeja + email + ZIP)
## Flux — Break Digital
**Estado:** Código en repo · **Fecha:** 2026-09-23

## Idea

Cuando llega un correo con asunto «facturación» (o se sube un ZIP a mano),
Break lo pone en una bandeja de **compras pendientes**. Un gerente revisa y
pulsa **Enviar a Siigo**. Break parsea el XML DIAN del ZIP y crea la factura
de compra con `POST /v1/purchases`.

> Siigo API **no** acepta el ZIP directamente (eso solo existe en Siigo Nube UI).
> Por eso el flujo es: ZIP → parseo UBL → JSON Siigo.

```
Correo (Resend inbound, asunto ~ facturación)
   │  webhook compras-email-webhook
   │  descarga adjuntos ZIP/XML
   ▼
Storage facturas-compra + tabla compras_inbox
   │
Upload manual (panel /admin/compras) ──┘
   │
   ▼
UI bandeja (pendiente / listo / error / enviado)
   │  botón Enviar a Siigo
   ▼
siigo-sync-compra → ensureSupplier + POST /v1/purchases
```

## Activación

### 1. SQL
Correr `docs/migration_compras_siigo.sql` en Supabase SQL Editor.

### 2. Secrets (Edge Functions)

| Secret | Uso |
|---|---|
| `RESEND_API_KEY` | Ya existe (outbound). También para descargar adjuntos inbound. |
| `RESEND_WEBHOOK_SECRET` | Firma Svix del webhook `email.received` (recomendado). |
| `COMPRAS_EMAIL_ASUNTO_FILTRO` | Default `facturacion` (sin tilde; match flexible). |
| `BREAK_NIT` | Opcional: valida NIT receptor del XML. |
| `SIIGO_PURCHASE_DOCUMENT_TYPE_ID` | `id` del tipo FC en Siigo (`GET /v1/document-types?type=FC`). |
| `SIIGO_PURCHASE_PAYMENT_ID` | Medio de pago FC (`GET /v1/payment-types?document_type=FC`). |
| `SIIGO_PURCHASE_DEFAULT_PRODUCT_CODE` | Código de producto/gasto en Siigo para las líneas. |
| `SIIGO_PURCHASE_TAX_IVA_ID` | Opcional: id impuesto IVA 19%. |

### 3. Resend Receiving
1. En Resend → Receiving: crear dirección p.ej. `compras@breakmanizales.com` (o alias).
2. Webhook URL: `https://<project>.supabase.co/functions/v1/compras-email-webhook`
3. Evento: `email.received`
4. Copiar signing secret → `RESEND_WEBHOOK_SECRET`
5. Reenviar/filtrar en el buzón real los correos con asunto «facturación» hacia esa dirección.

### 4. Desplegar funciones
- `compras-email-webhook` (`verify_jwt = false`)
- `compras-upload`
- `siigo-sync-compra`

## UI
Ruta: `/admin/compras` (gerente + recepción lectura; solo gerente envía a Siigo).

## Edge Functions

| Función | JWT | Rol |
|---|---|---|
| `compras-email-webhook` | no | Ingestión correo Resend |
| `compras-upload` | sí | Upload ZIP/XML manual |
| `siigo-sync-compra` | sí | Parseo + POST /v1/purchases |

## Límites / riesgos
- Retenciones (ReteIVA/ReteICA) del XML pueden requerir edición manual en Siigo.
- El producto Siigo de las líneas es uno por defecto; conviene mapear catálogo después.
- Tamaño máx. ~5 MB en storage (Siigo UI permite 3 MB).
