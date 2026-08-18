# Decisiones del Proyecto — Break Digital
**Mantenido por:** Orion  
**Formato:** ADR (Architecture Decision Record) adaptado para negocio

---

## DECISIONES PENDIENTES

### DEC-001: Dominio del sitio web
**Presentada:** 2026-05-31  
**Presentada por:** Orion  
**Estado:** ⏳ Pendiente de Zaven  

**Opciones:** A) breakhotel.co · B) breakhotel.com · C) break.hotel  
**Recomendación de Orion:** breakhotel.co  
**Desbloquea:** Cipher (Netlify), Atlas (SEO), Flux (email corporativo)

---

### DEC-002: Plan de Supabase
**Presentada:** 2026-05-31  
**Presentada por:** Orion  
**Estado:** ⏳ Pendiente de Zaven  

**Opciones:** A) Free ($0) para desarrollo → Pro ($25 USD/mes) al lanzar · B) Pro desde el inicio  
**Recomendación de Orion:** Free para desarrollo (3-4 semanas), Pro obligatorio antes del primer huésped real  
**Desbloquea:** Nova (puede crear las tablas definitivas)

---

### DEC-003: Roles del sistema y estructura del staff
**Presentada:** 2026-05-31  
**Presentada por:** Orion  
**Estado:** ⏳ Pendiente de Zaven — requiere info del staff actual  

**Opciones:** A) 2 roles (admin / huésped) · B) 4 roles (gerente / recepción / aseo / huésped)  
**Recomendación de Orion:** 4 roles — escalable sin costo adicional  
**Información requerida:** ¿Cuántas personas del staff necesitan acceso? ¿Qué hace cada una?  
**Desbloquea:** Nova (esquema de usuarios), Ariel (guards de rutas)

---

### DEC-004: Presupuesto mensual de operación digital
**Presentada:** 2026-05-31  
**Presentada por:** Orion  
**Estado:** ⏳ Pendiente de Zaven  

**Opciones:** A) ~$35 USD/mes (mínimo) · B) ~$75 USD/mes (estándar) · C) ~$130 USD/mes (completo)  
**Recomendación de Orion:** A durante desarrollo → B al lanzar → C cuando ocupación supere 45%  
**Desbloquea:** Flux (dimensionamiento de integraciones), Luna (alcance de campañas)

---

### DEC-005: Prioridad del primer módulo a construir
**Presentada:** 2026-05-31  
**Presentada por:** Orion  
**Estado:** ⏳ Pendiente de Zaven  

**Opciones:** A) Panel Admin primero · B) Portal Huéspedes primero · C) Ambos en paralelo  
**Recomendación de Orion:** Admin primero — sin sistema interno, el portal web genera más trabajo manual  
**Desbloquea:** Ariel (sabe por dónde empezar a construir)

---

## DECISIONES TOMADAS

### DEC-001: Dominio del sitio web
**Fecha:** 2026-05-31  
**Decidida por:** Zaven  
**Estado:** ✅ Tomada  

**Decisión:** breakmanizales.com — ya registrado en Hostinger  
**Impacto:** Cipher configura Netlify apuntando a Hostinger DNS. Atlas ajusta estrategia SEO con keyword "break manizales" como término ancla. Email corporativo será @breakmanizales.com.  
**Revisable cuando:** Si se decide abrir mercado internacional o renombrar la marca.

---

### DEC-002: Plan de Supabase
**Fecha:** 2026-05-31  
**Decidida por:** Zaven  
**Estado:** ✅ Tomada  

**Decisión:** Free durante desarrollo. Migrar a Pro ($25 USD/mes) obligatoriamente antes del primer huésped real en el sistema.  
**Razón:** No destinar presupuesto hasta que el producto esté listo. El Free tiene la limitación de pausarse a los 7 días de inactividad — inaceptable en producción.  
**Alerta de Orion:** Antes del lanzamiento, Zaven debe aprobar el upgrade a Pro. Es el único costo no negociable del proyecto.

---

### DEC-003: Roles del sistema
**Fecha:** 2026-05-31  
**Decidida por:** Zaven  
**Estado:** ✅ Tomada  

**Decisión:** 5 roles de staff + huésped (6 roles en total)  

| Rol | Acceso | Quién |
|---|---|---|
| `gerente` | Todo — sin restricciones | Zaven |
| `recepcion` | Reservas, check-in/out, CRM básico | Recepcionista |
| `aseo` | Tareas de limpieza y lavandería | Personal de aseo |
| `marketing` | CRM completo, campañas, métricas, analytics | Estratega de marketing |
| `huesped` | Solo su reserva y servicios durante la estadía | Público |

**Impacto:** Nova diseña la tabla `usuarios` y las políticas RLS con estos 5 roles. Ariel configura los guards de rutas por rol.

---

### DEC-004: Presupuesto mensual de operación digital
**Fecha:** 2026-05-31  
**Decidida por:** Zaven  
**Estado:** ✅ Tomada  

**Decisión:** $0/mes durante desarrollo. Evaluar al momento del lanzamiento.  
**Stack gratuito confirmado para desarrollo:**
- Supabase Free — base de datos y auth
- Netlify Free — deploy y hosting (100GB bandwidth/mes)
- Resend Free — 3.000 emails/mes
- WhatsApp Business API — 1.000 conversaciones gratuitas/mes (iniciadas por usuario)

**Único costo obligatorio antes de producción:** Supabase Pro ($25 USD/mes) para evitar la pausa automática. Sin este upgrade, el sistema se cae solo. Orion alertará cuando sea el momento.

---

### DEC-005: Prioridad del primer módulo
**Fecha:** 2026-05-31  
**Decidida por:** Zaven  
**Estado:** ✅ Tomada  

**Decisión:** Panel Admin es la prioridad número 1.  
**Razón:** Sin sistema interno funcionando, el portal web solo genera más trabajo manual. El admin es la base operativa del hotel.  
**Orden confirmado:** Admin → Portal Huéspedes → Integraciones → Marketing

---

### DEC-006: Puente PXSOL ↔ SIIGO (fuente de verdad y facturación DIAN)
**Fecha:** 2026-08-15  
**Presentada por:** Flux  
**Decidida por:** Zaven  
**Estado:** ✅ Tomada  

**Contexto:** El hotel opera PxSol como PMS y necesita facturación electrónica DIAN vía Siigo.  
**Decisión:** PxSol es fuente de verdad operativa. Siigo timbra ante la DIAN (`stamp: true`). Break Digital es el puente (cache enriquecido). 1 voucher PxSol = 1 factura Siigo.  
**Impacto:** Edge Functions `pxsol-*` y `siigo-*`. Migración `docs/migration_pxsol_siigo.sql`. No desplegar a producción sin aprobación explícita.  
**Detalle:** `docs/adr-pxsol-siigo-bridge.md`  
**Revisable cuando:** PxSol confirme (o no) que ya emite documento DIAN en Colombia; o si se quiere modelar comisiones de OTAs en Siigo (Fase 2).

---

## PLANTILLA PARA NUEVAS DECISIONES

```
### DEC-XXX: [Título]
**Fecha:** YYYY-MM-DD  
**Presentada por:** [agente]  
**Decidida por:** Zaven  
**Estado:** ✅ Tomada  

**Contexto:** [por qué era necesaria]  
**Opciones evaluadas:** [resumen]  
**Decisión:** Opción [X]  
**Razón:** [justificación en 1-2 líneas]  
**Impacto:** [qué cambia]  
**Revisable cuando:** [condición que haría reconsiderar]
```
