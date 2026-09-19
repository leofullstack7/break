# Integración PXSOL ↔ SIIGO — Break Hotel
## Flux — Ingeniero de Integraciones
**Estado:** Código integrado en el repo · **No desplegado** · **Fecha:** 2026-08-15

Break Digital es el puente: lee vouchers de PxSol y crea facturas electrónicas en Siigo (DIAN). PxSol es la fuente de verdad operativa. Siigo es la fuente de verdad fiscal. Break nunca escribe de vuelta en PxSol en esta fase.

```
PXSOL (reservas, folios, pagos)
   │  pull periódico — pxsol-sync
   ▼
Supabase (pxsol_vouchers + cache de reservas)
   │  voucher group_type=Venta + status=Finished
   ▼
SIIGO (POST /v1/customers + POST /v1/invoices stamp:true)
   ▼
Supabase (siigo_factura_id, CUFE, PDF, siigo_estado)
```

## Documentos

| Archivo | Contenido |
|---|---|
| `docs/adr-pxsol-siigo-bridge.md` | Decisiones de arquitectura (aceptadas 15-ago-2026) |
| `docs/mapeo-campos-pxsol-siigo.md` | Mapeo campo a campo PxSol → Siigo |
| `docs/migration_pxsol_siigo.sql` | DDL — correr a mano en SQL Editor |
| `docs/secrets-pxsol-siigo.md` | Secrets, orden de implementación, riesgos, fallback |

## Edge Functions

| Función | JWT | Rol |
|---|---|---|
| `pxsol-auth` | sí | Health check de la API Key (no hay OAuth) |
| `pxsol-sync` | sí | Pull de vouchers → `pxsol_vouchers` |
| `pxsol-ocupacion-sync` | sí | Pull ocupación in-house → habitaciones/reservas |
| `pxsol-contactos-sync` | sí | Pull contactos CRM → `huespedes` (vouchers + bookings) |
| `pxsol-webhook` | no | Placeholder 501 — PxSol no documenta webhooks |
| `siigo-auth` | sí | Renueva / chequea token Siigo (24h) |
| `siigo-sync-factura` | sí | Crea factura DIAN por voucher pendiente |

Helpers en `supabase/functions/_shared/`: `pxsol-client.ts`, `siigo-client.ts`, `factura-mapper.ts`.

## Antes de activar

1. Correr `docs/migration_pxsol_siigo.sql` en Supabase SQL Editor.
2. Poblar `siigo_catalogo_map` con IDs reales de la cuenta Siigo Nube de Break. Sin eso, `siigo-sync-factura` falla con `MapeoFaltanteError` (a propósito).
3. Configurar secrets listados en `docs/secrets-pxsol-siigo.md` — nunca en el cliente.
4. Sandbox de Siigo primero. PxSol al final. Producción solo con aprobación explícita de Zaven.
5. Confirmar con Sebastian Berti (PxSol) que la operación colombiana **no** timbra también ante la DIAN (riesgo de doble factura).

## Preguntas abiertas

1. `identification` del tercero "Consumidor Final" en Siigo Nube (`SIIGO_CONSUMIDOR_FINAL_ID`).
2. Confirmación con PxSol sobre facturación DIAN desde su lado.
