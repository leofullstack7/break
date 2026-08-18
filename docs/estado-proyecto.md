# Estado del Proyecto — Break Digital
**Última actualización:** 2026-08-15  
**Actualizado por:** Flux  

---

## Fase actual
**Fase 3 — Módulo Admin** — 85% completada  
**Progreso general del proyecto:** ~40%

---

## Progreso por módulo

| Módulo | Estado | % | Próximo paso |
|---|---|---|---|
| Panel Admin | Funcional en producción | 85% | Reserva desde admin, editar/cancelar reserva |
| Portal Huéspedes | Base funcional | 40% | WiFi, solicitud de servicios, mejor UX |
| Integraciones PXSOL ↔ SIIGO | Código en repo, no desplegado | 40% | Correr `migration_pxsol_siigo.sql` + secrets sandbox Siigo |
| Integraciones WhatsApp | Webhook desplegado (Fase 2) | 15% | Pausado — retomar en Fase 2 |
| Email Transaccional (Resend) | Edge Function + plantillas listas | 70% | Zaven: crear cuenta Resend + secrets |
| Marketing Digital | No iniciado | 5% | Brand Voice, Landing, campañas (Luna + Verso) |
| Landing pública | Scaffold | 5% | Diseño completo (Sage + Verso + Noir) |
| SEO | No iniciado | 0% | Meta tags, sitemap, GBP (Atlas) |
| Finanzas | Funcional básico | 60% | Exportar reportes, filtros por fecha |

---

## Completado ✅ (sesiones 1–3)

### Infraestructura y configuración
- CLAUDE.md con identidad del negocio y stack
- 10 agentes especializados definidos (Ariel, Nova, Flux, Sage, Cipher, Atlas, Luna, Noir, Verso, Orion)
- AGENTS_WORKFLOW.md — protocolo completo de flujos entre agentes
- Proyecto React + Vite + TypeScript + Tailwind inicializado en `/app`
- Tailwind configurado con paleta y tipografía completa de Break
- PWA configurada (manifest.webmanifest, Vite PWA plugin)
- Netlify configurado (netlify.toml con headers de seguridad, redirects)
- Variables de entorno configuradas (.env.local con credenciales Supabase)

### Base de datos (Nova)
- 8 tablas: habitaciones, huespedes, operadores, reservas, aseos, lavanderia, finanzas, usuarios
- 24 habitaciones con datos semilla (pisos 1–4, 105–407)
- 4 operadores: Airbnb (15%), Booking (15%), Terceros (10%), Alexander (0%)
- Vistas: v_mapa_habitaciones (estado en tiempo real), v_ocupacion_mensual
- Función: habitacion_disponible(), get_mi_rol(), auto_ocupada()
- Triggers: updated_at, calcular_comision, sync_estado_habitacion, fn_aseo_completado, fn_checkout_aseo
- RLS completo para 5 roles: gerente, recepcion, aseo, marketing, huesped
- Estados de habitación: disponible, ocupada, aseo, mantenimiento, **recien_ingreso** (nuevo)
- Columnas financieras: aseo_cobrado, ingreso_hotel, ingreso_operador, ingreso_neto, verificacion
- Timestamps de check-in/out real: fecha_checkin_real, fecha_checkout_real
- cc_acompanante añadido a reservas
- ultima_limpieza añadido a habitaciones

### Migración de datos (Nova)
- 397 huéspedes migrados desde Base_de_Datos.xlsx
- 651 reservas migradas desde Break (1).xlsx (24 hojas, una por habitación)
- 659 registros financieros actualizados (comisión Airbnb, ingreso Break, ingreso operador, neto, verificación)
- Datos exportados a JSON intermedios en /data (para auditoría)

### Panel Admin — páginas funcionales
- **Dashboard**: mapa visual 24 habitaciones en tiempo real con colores, stats del día (ocupación, check-ins, check-outs, disponibles), movimientos del día
- **Reservas**: tabla con paginación de 20, filtros por estado + rango de fechas + búsqueda, "Ver más" modal con desglose financiero completo (CC titular, acompañante, CC acompañante), botón "Nueva Reserva" con búsqueda de huésped (nombre/cédula/celular), selección de habitaciones disponibles, validación de fechas
- **Huéspedes CRM**: 397 contactos, búsqueda por nombre/celular/correo, filtro por nacionalidad, tabla desktop + lista mobile
- **Perfil de huésped**: historial de reservas, datos de contacto, WhatsApp directo, métricas (noches, estadías, gasto)
- **Aseo**: navegación semanal con barras de progreso por día (rojo/ámbar/verde), tarjetas de habitación con estado visual grande (Sucia/Repasar/OK), disponibilidad (Ocupada/Desocupada/Recién ingreso), modal "Cambiar estado" con observaciones, aseadoras (Catalina, Rosa, Paula), botón "Repartir aseo" (solo gerente)
- **Lavandería**: registro de prendas, avance de estados (lavando → listo → entregado), formulario rápido
- **Finanzas**: reporte mensual con ocupación, ingresos brutos/netos/comisiones, barra de progreso por mes, desglose por canal
- **Marketing**: métricas de base de contactos, tabla de huéspedes frecuentes con WhatsApp/email directos

### Navegación y sistema de roles
- Sidebar desktop (240px fijo) con menú diferente por rol
- Bottom nav mobile (4 ítems por rol)
- AdminLayout con drawer animado (Framer Motion)
- RouteGuard usando Zustand (no re-consulta DB en cada navegación)
- 5 roles implementados: gerente, recepcion, aseo, marketing, huesped

### Portal del huésped
- Visualización de reserva activa (buscada por correo del usuario auth)
- Botón "Hacer Check-in" → activa reserva + habitación pasa a "Recién ingreso"
- Botón "Hacer Check-out" → completa reserva + habitación pasa a "En aseo" + crea tarea de aseo
- Información del hotel (WiFi, ubicación, horarios)
- WhatsApp directo al hotel

### Componentes UI
- Modal (centrado, con Escape, bloquea scroll del body)
- Badge (estados de reserva, aseo, habitación)
- StatCard (métricas del dashboard)
- SearchInput (búsqueda con ícono)
- PageLoader (shimmer elegante)

---

## En progreso 🔄

- Pendiente ejecutar migration_checkin_estados.sql (nuevo estado recien_ingreso + triggers check-in/out)
- Migración cc_acompanante pendiente de re-extracción del Excel

---

## Bloqueado ⏸

- **Flux — PXSOL ↔ SIIGO**: código integrado, **no desplegado**. Bloqueantes antes de producción:
  - Confirmar con Sebastian Berti que PxSol no timbra DIAN en Colombia (doble factura)
  - Crear tercero "Consumidor Final" en Siigo y guardar `SIIGO_CONSUMIDOR_FINAL_ID`
  - Poblar `siigo_catalogo_map` con IDs reales de Siigo Nube
  - Aprobar costo módulo PxSol API (USD 50/mes) si se habilita pago/API Key
- **Flux — WhatsApp**: webhook desplegado y verificado. Pasa a Fase 2 — no se avanza más por ahora
- **Flux — Email Resend**: Edge Function y plantillas listas. Falta que Zaven cree cuenta en Resend y configure secrets
- **Atlas**: no puede hacer SEO técnico sin la landing pública construida
- **Luna/Verso/Noir**: no pueden activar marketing sin la landing y el brand voice aprobados

---

## Pendiente priorizado 📋

### Crítico ahora
1. Ejecutar migration_checkin_estados.sql (Zaven — 5 min en Supabase)
2. Landing pública completa (Sage + Verso + Noir)
3. Flujo de reserva pública funcional (Ariel)
4. Editar / cancelar reserva desde el admin (Ariel)

### Siguiente sprint
5. WhatsApp Business API — Fase 2 (Flux) — webhook listo, avance pausado
6. ~~Email transaccional — Resend (Flux)~~ ✅ Implementado 2026-06-23
7. SEO técnico básico (Atlas)
8. Campañas de reactivación para los 37 huéspedes (Luna)

### Puente PXSOL ↔ SIIGO (siguiente, sin producción todavía)
9. Ejecutar `docs/migration_pxsol_siigo.sql` en SQL Editor
10. Sandbox Siigo: `siigo-auth` + poblar `siigo_catalogo_map` (ver `docs/secrets-pxsol-siigo.md`)
11. Probar `siigo-sync-factura` con un voucher inventado en SQL
12. Recién entonces API Key PxSol de solo lectura y `pxsol-sync`

---

## Decisiones tomadas ✅

| # | Decisión | Resultado |
|---|---|---|
| 1 | Dominio | breakmanizales.com — ya en Hostinger |
| 2 | Supabase | Free en desarrollo → Pro antes de producción real |
| 3 | Roles del sistema | 5 roles: gerente, recepcion, aseo, marketing, huesped |
| 4 | Presupuesto | $0 en desarrollo — stack 100% gratuito |
| 5 | Prioridad módulos | Admin primero → Huéspedes → Integraciones → Marketing |

## Métricas del proyecto

- Sesiones trabajadas: 3 sesiones intensivas
- Archivos de código creados: 29 archivos TypeScript/TSX
- Documentos en /docs: 11 archivos
- Scripts SQL de migración: 6 archivos
- Módulos en producción: 0 (aún en desarrollo local)
- Huéspedes en el CRM: 397
- Reservas en el sistema: 651
- Líneas de código estimadas: ~4.000
