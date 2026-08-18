# Secrets, orden de implementación, riesgos y fallback manual

## 1. Secrets necesarios (Supabase Edge Functions Secrets — nunca en el cliente)

| Secret | Origen | Notas |
|---|---|---|
| `PXSOL_API_KEY` | Se genera manualmente en PxSol → Integraciones → "Integraciones Generales (API Keys)" → My API Keys → Create API Key | Token estático con fecha de expiración (ej. 12 meses). No hay OAuth: alguien del equipo debe copiarlo y pegarlo al crearlo (se muestra una sola vez). Requiere habilitar el módulo de pago (USD 50/mes) en PxSol primero. |
| `PXSOL_BASE_URL` | `https://gateway-prod.pxsol.com/v2` (o `https://gateway-dev.pxsol.com/v2` en pruebas) | |
| `SIIGO_USERNAME` | Usuario API de Siigo (`sandbox@siigoapi.com` en pruebas; en producción se genera desde Siigo Nube → Alianzas → "Mi Credencial API") | |
| `SIIGO_ACCESS_KEY` | Access Key entregado por Siigo junto al usuario API | En pruebas viene en el correo recibido |
| `SIIGO_PARTNER_ID` | Nombre de la integración a reportar a Siigo (header `Partner-Id`) | Sugerido: `BreakDigitalPxsol` (3-100 caracteres alfanuméricos, sin espacios) |
| `SIIGO_CONSUMIDOR_FINAL_ID` | `identification` del tercero "Consumidor Final" ya creado en Siigo Nube | Ver ADR sección 5 — pendiente de que el equipo lo cree/confirme |
| `SIIGO_DOCUMENT_TYPE_ID` | `id` del tipo de comprobante "Factura de Venta electrónica" en Siigo Nube (`GET /v1/document-types`) | Específico de la cuenta de Break Hotel |
| `SIIGO_DEFAULT_SELLER_ID` | `id` de un usuario vendedor por defecto en Siigo (`GET /v1/users`) | Para cuando PxSol no trae un vendedor asociado |

## 2. Orden de implementación sugerido

1. **Sandbox de Siigo primero, sin tocar PxSol todavía.** Correr `siigo-auth` contra las credenciales de prueba del correo y confirmar que se obtiene el token. Cero riesgo, cero costo.
2. **Con el sandbox de Siigo, poblar `siigo_catalogo_map` manualmente** con los `id` reales de: tipo de documento (factura), formas de pago, impuestos (IVA 19%/5%/excluido), y al menos un producto de prueba ("Alojamiento"). Esto se hace consultando los catálogos de Siigo (`/v1/document-types`, `/v1/payment-types`, `/v1/taxes`) — no adivinar los IDs.
3. **Probar `siigo-sync-factura` con un voucher inventado a mano** (insertado directo en `pxsol_vouchers` vía SQL, sin depender todavía de PxSol) para validar que la factura se crea correctamente en el sandbox de Siigo Nube.
4. **Solo entonces** coordinar con Sebastian Berti (PxSol) el acceso de prueba (`gateway-dev`) o una API Key de solo lectura en producción, y correr `pxsol-sync` en modo lectura, sin conectar todavía a `siigo-sync-factura`.
5. **Validar manualmente** unos cuantos vouchers reales de PxSol contra lo que se esperaría facturar, antes de conectar el flujo completo automático.
6. **Habilitar el flujo completo** (`pxsol-sync` → `siigo-sync-factura`) primero apuntando a Siigo sandbox con datos reales de PxSol (de solo lectura), y solo cuando Zaven lo apruebe explícitamente, apuntar a Siigo producción.
7. Configurar el cron (Supabase `pg_cron` o scheduler externo) para `pxsol-sync` cada 15-30 minutos, y `siigo-sync-factura` inmediatamente después (o encadenado dentro de la misma corrida).

## 3. Riesgos

- **Doble facturación ante la DIAN:** si PxSol ya está timbrando en Colombia (ver ADR sección 9), facturar también desde Siigo duplica el documento fiscal. **Bloqueante — confirmar con PxSol antes de producción real.**
- **Mapeo de ciudades/países incompleto:** Siigo exige códigos DIAN exactos; PxSol trae texto libre. Un huésped con ciudad no mapeada no debe facturarse con datos incorrectos — mejor que la sincronización falle explícitamente (`siigo_estado = 'error'`) a que se facture con la ciudad equivocada.
- **Costo del módulo de PxSol (USD 50/mes):** debe aprobarlo Mauricio/Zaven antes de habilitarlo, es un gasto recurrente nuevo.
- **Límite de tasa de Siigo:** 100 req/min en producción (10/min en sandbox). Con 24 habitaciones el volumen es bajo, no debería ser un problema, pero el cron no debe correr con una ventana tan amplia que genere ráfagas grandes de facturas de golpe la primera vez que se activa (recomendado: procesar en lotes pequeños con backoff).
- **Token de Siigo expira cada 24h:** `siigo-auth` debe renovar automáticamente antes de que expire, no solo cuando falle una petición.
- **Facturas rechazadas por configuración faltante en Siigo Nube** (`document_settings`, `customer_settings`, `invalid_dian_resolution`, etc.): no reintentar indefinidamente un voucher rechazado por datos inválidos — after N intentos (sugerido: 3), marcar `siigo_estado = 'error'` y depender del fallback manual.

## 4. Fallback manual para recepción

Si `siigo-sync-factura` falla o queda pausado:

1. Recepción puede seguir operando normalmente en PxSol (no depende de Siigo para cerrar folios).
2. Los vouchers con `siigo_estado = 'error'` quedan visibles en una vista/reporte simple (a construir en `/admin/finanzas` o una tabla de administración) para que alguien facture manualmente esa venta desde Siigo Nube directamente, y luego actualice `pxsol_vouchers.siigo_estado = 'facturado'` a mano con el número de factura real, para no reprocesarlo por error.
3. `sync_logs` permite ver el detalle del último error de cada voucher fallido.
