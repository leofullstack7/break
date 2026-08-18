# Mapeo de campos: PXSOL → Break Digital → SIIGO

## 1. Voucher de PxSol → `pxsol_vouchers` (Break Digital)

| Campo PxSol (`voucher.attributes`) | Columna en `pxsol_vouchers` | Notas |
|---|---|---|
| `id` (del voucher, nivel raíz) | `id` (PK) | Es el `Idempotency-Key` que se envía a Siigo |
| `booking_id` | `booking_id` | Cruza con `reservas.pxsol_booking_id` |
| `folio_id`, `folio_name` | `folio_id`, `folio_name` | Referencia interna de PxSol |
| `voucher_type` | `voucher_type` | Ej. "Factura B" — **confirmar nomenclatura real en Colombia** |
| `group_type` | `group_type` | Debe ser `"Venta"` para disparar factura |
| `status` | `status` | Debe ser `"Finished"` para disparar factura |
| `payment_type` | `payment_type` | Ver mapeo de formas de pago (sección 4) |
| `payment_status` | `payment_status` | |
| `sub_total`, `iva`, `total`, `other_taxes` | `sub_total`, `iva`, `total`, `other_taxes` | Numéricos, ya vienen calculados por PxSol |
| `currency` | `currency` | Debe ser `COP` en operación colombiana; si no, revisar `currency.exchange_rate` en Siigo |
| `date`, `due_date`, `fiscal_date` | `fecha_voucher`, `fecha_vencimiento`, `fecha_fiscal` | |
| `social_reason`, `name`, `last_name` | `huesped_nombre` (concatenado) | Razón social o nombre completo |
| `document_type`, `document_number` | `huesped_tipo_doc`, `huesped_num_doc` | Ver mapeo de identificación (sección 3) |
| `email` | `huesped_email` | |
| `address`, `city`, `country`, `zip_code` | `direccion` (jsonb) | Ver mapeo de ciudad/país DIAN (sección 3) |
| `person_type` | `huesped_tipo_persona` | `Person` → `person_type: "Person"` en Siigo; `Company` → `"Company"` |
| `pdf` | `pxsol_pdf_url` | PDF que genera PxSol (no confundir con el PDF que genera Siigo) |
| `has_credit_note`, `credit_note`, `credit_note_voucher_id` | `has_credit_note`, `credit_note`, `credit_note_voucher_id` | Dispara `POST /v1/credit-notes` en vez de `/v1/invoices` |
| resto del objeto | `voucher_raw` (jsonb) | Payload crudo completo, sin transformar |

## 2. `voucher_items[]` (desde `GET /v2/voucher/info/:id`) → `items[]` de la factura Siigo

| Campo PxSol (`voucher_items[i]`) | Campo Siigo (`items[i]`) | Notas |
|---|---|---|
| `code` | — | Código interno de PxSol, **no** el `code` de Siigo. Se usa como llave para buscar en `siigo_catalogo_map` (tabla nueva, ver migración) |
| `description` | `description` | Se puede pasar directo, o se sobreescribe con el `name` del producto Siigo si el mapeo lo define |
| `units` | `quantity` | |
| `price` | `price` | Ojo: en PxSol `price` es el valor **sin impuesto** (`sub_total` del ítem); confirmar que coincide con la definición de `price` en Siigo (valor unitario antes de IVA) |
| `discount` | `discount` | |
| `tax_id`, `taxes` (%), `iva` (valor) | `taxes[].id` | El `tax_id` de PxSol NO es el `id` de impuesto de Siigo — hay que mapear por porcentaje (`taxes` en PxSol = %) contra `GET /v1/taxes` de Siigo, o mantener una tabla fija de mapeo si los porcentajes de IVA aplicables son conocidos (0%, 5%, 19%) |
| `product_id` | — | Referencia interna de PxSol (tipo de habitación/servicio); es la llave más confiable para `siigo_catalogo_map` en vez de `code` |

**Importante:** antes de mapear impuestos automáticamente, confirmar en Siigo Nube (`Configuración > Transacciones > Catálogos > Impuestos`) los `id` reales de IVA 19%, IVA 5% y Excluido/Exento para la cuenta de Break Hotel — estos son específicos de cada empresa en Siigo, no son fijos entre clientes.

## 3. Huésped de PxSol → `customer` de Siigo

| PxSol | Siigo | Notas |
|---|---|---|
| `document_type` (ej. `DNI`, `CUIT` en los ejemplos de PxSol — **verificar valores reales para Colombia**, esperados: `CC`, `NIT`, `CE`, `PPT`, `Pasaporte`) | `id_type` | Requiere tabla de mapeo `pxsol_document_type → siigo_id_type_code` (13=Cédula, 31=NIT, 22=Cédula extranjería, 41=Pasaporte, 91=NUIP, 47=PEP, etc.) |
| `document_number` | `identification` | |
| `person_type: "Person"` / `"Company"` | `person_type: "person"` / `"company"` | |
| `name` + `last_name` (Person) / `social_reason` (Company) | `name: [nombres, apellidos]` o `name: [razón social]` | Siigo exige array; para `Company` es un solo elemento |
| `email` | `Contacts[0].email` | Siigo requiere al menos un contacto con email para que la factura electrónica se pueda enviar |
| `address`, `city`, `country`, `zip_code` | `address.address`, `address.city.country_code/state_code/city_code` | PxSol trae texto libre de ciudad/país; Siigo exige **códigos DIAN exactos**. Se necesita una tabla de mapeo ciudad-texto → código DIAN (ver `siigo_catalogo_map`, tipo `'ciudad'`), poblada progresivamente o pre-cargada con las ciudades de Colombia más comunes + fallback a Bogotá/CO/11/11001 si no hay match, marcando el registro como `requiere_revision: true` |
| — | `fiscal_responsibilities.code` | Por defecto `"R-99-PN"` (No aplica - Otros) salvo que el huésped sea una empresa con responsabilidad fiscal distinta |
| Extranjero sin documento válido | — | Usar tercero `SIIGO_CONSUMIDOR_FINAL_ID` (ver ADR sección 5) |

## 4. Forma de pago de PxSol → `payments[]` de Siigo

PxSol expone estos valores de `payment_type` (ver documentación, sección "payment_type values"):

`Cobranza electrónica`, `Contado`, `Cuenta Corriente`, `Tarjeta de Débito`, `Tarjeta de Crédito`, `Cheque`, `Ticket`, `Transferencia Bancaria`, `MercadoPago`, `Otro`

Estos deben mapearse contra `GET /v1/payment-types?document_type=FV` de Siigo (formas de pago configuradas para Factura de Venta en la cuenta de Break Hotel), guardando el resultado en `siigo_catalogo_map` (tipo `'forma_pago'`). Ninguna forma de pago con vencimiento (`due_date: true` en Siigo) puede combinarse con otra en el mismo `payments[]` — si PxSol trae "Cuenta Corriente" (que sí maneja cartera/vencimiento), debe ir sola.

## 5. Nueva tabla de configuración: `siigo_catalogo_map`

En vez de hardcodear estos mapeos en el código (que cambiarían si Siigo Nube se reconfigura), se guardan en una tabla editable:

| tipo | clave_pxsol | valor_siigo | notas |
|---|---|---|---|
| `producto` | `product_id` de PxSol (texto) | `code` de producto en Siigo | Ej. habitaciones → "ALOJAMIENTO" |
| `forma_pago` | `payment_type` de PxSol | `id` de forma de pago en Siigo | |
| `impuesto` | `%` de IVA de PxSol (ej. `"19.00"`) | `id` de impuesto en Siigo | |
| `documento_identidad` | `document_type` de PxSol | `id_type` code de Siigo | |
| `ciudad` | texto de ciudad de PxSol | `country_code\|state_code\|city_code` | |

Ver la migración SQL (`migration_pxsol_siigo.sql`) para el `CREATE TABLE`.
