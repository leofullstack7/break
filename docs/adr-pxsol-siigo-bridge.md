# ADR — Puente PXSOL ↔ Break Digital ↔ SIIGO

**Estado:** Aceptado (decisiones confirmadas por Zaven en sesión del 15-ago-2026)
**Contexto:** El hotel opera PxSol como PMS/motor de reservas/CRM y necesita facturación electrónica DIAN vía Siigo. Break Digital (Supabase Edge Functions) es el puente entre ambos.

---

## 1. Fuente de verdad: PXSOL

**Decisión:** PxSol es la fuente de verdad de reservas, disponibilidad, tarifas y folios/pagos.

- Las funciones `pxsol-*` usan Edge Functions + `integraciones_config` (tokens) + columnas `*_id` / `*_raw` / `*_sync_at` + logs.
- Break Digital sigue siendo el **cache enriquecido**: aseo, lavandería, check-in/checkout digital, CRM de huéspedes, dashboard operativo. No reemplaza a PxSol como sistema operativo del hotel.

## 2. Dirección de datos

```
PXSOL (operación: reservas, folios, pagos, huéspedes)
   │  pull periódico (no hay webhook confirmado por PxSol) — GET /v2/voucher/list/v2, /v2/ota/hotels/:id/bookings/:id
   ▼
Break Digital / Supabase (cache enriquecido: reservas, huespedes, pxsol_vouchers)
   │  al detectar un voucher de PxSol con group_type="Venta" y status="Finished"
   ▼
SIIGO (contabilidad + facturación electrónica DIAN) — POST /v1/customers, POST /v1/invoices (stamp:true)
   │  respuesta: factura + CUFE + PDF
   ▼
Break Digital / Supabase (guarda siigo_factura_id, siigo_cufe, siigo_pdf_url, siigo_estado)
```

Cada tramo es de **lectura libre / escritura quirúrgica**: Break lee de PxSol pero nunca escribe de vuelta en PxSol en esta fase; Break escribe en Siigo solo lo estrictamente necesario para facturar (terceros y facturas), nunca modifica configuración de Siigo Nube.

## 3. Evento que dispara la factura en Siigo

**Decisión:** el disparador es la aparición de un **voucher de PxSol** con `group_type: "Venta"` y `status: "Finished"` en `/v2/voucher/list/v2` (es decir, un cobro ya efectuado, no una reserva pendiente de pago).

Como PxSol puede emitir varios vouchers por una misma reserva (ej. "P 2/2" = pago parcial 2 de 2, visto en los ejemplos de su documentación), **la unidad de sincronización es el voucher, no la reserva completa**.

## 4. Un documento Siigo por voucher de PxSol (no por reserva ni por huésped/mes)

**Decisión:** se crea **una factura de venta en Siigo por cada voucher de PxSol**, usando el `id` del voucher como `Idempotency-Key` (evita duplicados en reintentos) y como llave de conciliación.

Alternativas descartadas por ahora:
- Una factura por reserva completa: obligaría a esperar a que la reserva esté 100% pagada antes de facturar, lo cual no encaja con pagos parciales/anticipos que PxSol ya está registrando como vouchers independientes.
- Una factura consolidada por huésped/mes: más compleja de conciliar y no es el patrón que expone la API de PxSol (que entrega vouchers, no resúmenes).

## 5. Terceros en Siigo

**Decisión:** se usa la identificación real del huésped (`document_type`/`document_number` del voucher de PxSol → `id_type`/`identification` en Siigo) cuando sea un tipo de documento válido para Siigo (cédula, NIT, pasaporte, cédula de extranjería, etc.).

Si el huésped es extranjero sin documento mapeable, o PxSol no trae identificación válida, se factura contra un tercero genérico **"Consumidor Final"** que el equipo de Break debe crear una sola vez en Siigo Nube (Configuración manual, fuera de esta integración) y cuyo `identification` se guarda como secret/config (`SIIGO_CONSUMIDOR_FINAL_ID`).

**Pendiente de confirmar con el equipo:** el `identification` exacto que Siigo Nube tiene configurado para "Consumidor Final" en la cuenta de Break Hotel.

## 6. Comisiones de operadores (Airbnb, Booking, Terceros) — fuera de alcance de la Fase 1

**Decisión:** en esta primera fase se factura en Siigo el valor bruto cobrado al huésped según el voucher de PxSol. La comisión del operador (`comision`, `ingreso_operador` en `reservas`) **no se modela como cuenta por pagar en Siigo todavía** — sigue siendo un reporte interno de Break (`/admin/finanzas`).

Si más adelante se quiere llevar también las cuentas por pagar a operadores dentro de Siigo, es una Fase 2 separada (usaría `/v1/purchases` o `/v1/journals` de Siigo) y debe decidirse con Zaven/Mauricio.

## 7. `aseo_cobrado` y otros cargos adicionales

**Decisión:** si el voucher de PxSol ya lo trae desglosado como un `voucher_item` propio (debería, dado que PxSol registra cargos línea a línea), se mapea a su propio código de producto en Siigo (ver `mapeo-campos-pxsol-siigo.md`). Si en la práctica PxSol no lo desglosa y Break lo calcula internamente, queda documentado como **TODO** — no se inventa un ítem que no viene de la fuente de verdad (PxSol) sin confirmarlo primero.

## 8. Dueño de la verdad ante divergencias

- **PxSol manda** en todo lo operativo: reservas, disponibilidad, tarifas, folios, pagos.
- **Siigo manda** en todo lo fiscal/contable: una vez facturado, ese documento es el legal ante la DIAN: no se edita, se anula con nota crédito si hay un error.
- **Break Digital nunca es la fuente de verdad** de estos datos — es un cache de lectura enriquecido. Si algo diverge, se corrige en el sistema de origen (PxSol o Siigo) y se re-sincroniza; nunca se edita manualmente el dato en la tabla de Supabase para "maquillar" una divergencia.

## 9. Facturación electrónica DIAN

**Decisión (confirmada 15-ago-2026):** Siigo es quien timbra ante la DIAN (`stamp: true` en `POST /v1/invoices`). PxSol es solo la fuente de los datos de la venta.

**Riesgo abierto:** los ejemplos de la documentación pública de PxSol muestran campos de facturación argentina (`cae`, tipos "Factura B/T/A" estilo AFIP). Antes de pasar esto a producción real con huéspedes, alguien del equipo de Break debe **confirmar con Sebastian Berti (PxSol)** que la operación colombiana de Break Hotel no está generando también un documento fiscal DIAN desde PxSol — si lo estuviera, facturar también desde Siigo generaría una doble factura ante la DIAN.

## 10. No implementar en producción hasta aprobación explícita

Este diseño (código + migraciones) ya está integrado en el repo `break-digital`. **No se ha ejecutado ninguna migración ni desplegado ninguna función** — eso lo decide y ejecuta el equipo del hotel, con Zaven como responsable de aprobar el paso a producción, especialmente antes de facturar con datos reales de huéspedes o de habilitar el módulo de pago en PxSol (USD 50/mes).
