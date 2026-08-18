# AGENTS_WORKFLOW.md
# Protocolo de Comunicación y Flujos de Trabajo
# Break Hotel — Plataforma Digital

---

## ÍNDICE

1. [Principios Fundamentales del Flujo](#1-principios-fundamentales-del-flujo)
2. [El Equipo — Mapa de Agentes](#2-el-equipo--mapa-de-agentes)
3. [Carpetas de Entregables por Agente](#3-carpetas-de-entregables-por-agente)
4. [Orden Estricto de Dependencias — Las 6 Fases](#4-orden-estricto-de-dependencias--las-6-fases)
5. [Protocolo de Comunicación entre Agentes](#5-protocolo-de-comunicación-entre-agentes)
6. [Tiempos Estimados por Tipo de Tarea](#6-tiempos-estimados-por-tipo-de-tarea)
7. [Flujos Completos de Trabajo](#7-flujos-completos-de-trabajo)
8. [Reglas de Oro](#8-reglas-de-oro)
9. [Referencia Rápida — Quién hace qué](#9-referencia-rápida--quién-hace-qué)

---

## 1. PRINCIPIOS FUNDAMENTALES DEL FLUJO

Estos principios no son sugerencias — son el protocolo que mantiene el proyecto coherente, eficiente y en la dirección correcta.

| # | Principio | Por qué existe |
|---|---|---|
| 1 | **Ningún agente empieza sin dependencias completas** | Construir sobre cimientos incompletos crea deuda que cuesta el doble resolver |
| 2 | **Cada entregable va a `/docs` antes de pasar al siguiente** | El conocimiento que vive solo en la conversación muere cuando se borra el contexto |
| 3 | **Las tareas se ejecutan completas — nunca a medias** | Un módulo al 70% no es un módulo — es un problema futuro |
| 4 | **Orion coordina el orden — nadie se activa sin su confirmación** | Sin coordinación central, los agentes se bloquean entre sí o duplican trabajo |
| 5 | **Zaven revisa y aprueba antes de pasar a producción** | El proyecto es de Zaven — las decisiones estratégicas también lo son |
| 6 | **El ritmo es deliberado — calidad sobre velocidad** | Break es una marca premium; su plataforma digital debe serlo también |

---

## 2. EL EQUIPO — MAPA DE AGENTES

### Visión general

```
                          ZAVEN (dueño del proyecto)
                                    │
                                    │ aprueba / decide
                                    ▼
                              ┌─────────┐
                              │  ORION  │ ← segundo al mando
                              │Director │   coordina todo el equipo
                              └────┬────┘
                                   │
          ┌──────────┬─────────────┼─────────────┬──────────┐
          ▼          ▼             ▼             ▼          ▼
       ARIEL       NOVA          SAGE          FLUX      CIPHER
   Arquitectura  Base de datos  UI/UX       Integraciones  QA/DevOps
                                │
              ┌─────────────────┤
              ▼                 ▼
            VERSO             NOIR
          Copywriter      Dir. Arte
              │
    ┌─────────┤
    ▼         ▼
  ATLAS      LUNA
   SEO     Marketing
```

### Tabla de agentes — referencia completa

| Agente | Rol | Instrucciones | Entrega en |
|---|---|---|---|
| **Orion** | Director de proyecto, segundo al mando | `agents/segundo-al-mando.md` | `/docs/estado-proyecto.md` |
| **Ariel** | Arquitecto full-stack | `agents/arquitecto-fullstack.md` | `/docs/arquitectura.md` + `/app` |
| **Nova** | Base de datos y CRM | `agents/ingeniero-base-de-datos.md` | `/docs/database.md` |
| **Flux** | Integraciones y APIs | `agents/ingeniero-integraciones.md` | `/docs/integraciones.md` |
| **Sage** | UI/UX y sistema de diseño | `agents/disenador-ui-ux.md` | `/docs/design-system.md` + `/app/components` |
| **Cipher** | QA, seguridad y DevOps | `agents/qa-devops.md` | `/docs/devops.md` + `/docs/security-checklist.md` |
| **Atlas** | SEO técnico y de contenido | `agents/especialista-seo.md` | `/docs/seo-strategy.md` |
| **Luna** | Marketing digital y CRM | `agents/especialista-marketing-digital.md` | `/docs/marketing-strategy.md` |
| **Noir** | Diseño visual y piezas gráficas | `agents/disenador-visual.md` | `/docs/brand-guidelines.md` + `/docs/assets` |
| **Verso** | Copywriting y storytelling | `agents/copywriter.md` | `/docs/brand-voice.md` + `/docs/copies` |

---

## 3. CARPETAS DE ENTREGABLES POR AGENTE

Cada agente tiene su espacio asignado. **Nadie escribe en el espacio de otro.**

```
break-digital/
│
├── agents/                          ← instrucciones de cada agente
│   ├── segundo-al-mando.md          (Orion)
│   ├── arquitecto-fullstack.md      (Ariel)
│   ├── ingeniero-base-de-datos.md   (Nova)
│   ├── ingeniero-integraciones.md   (Flux)
│   ├── disenador-ui-ux.md           (Sage)
│   ├── qa-devops.md                 (Cipher)
│   ├── especialista-seo.md          (Atlas)
│   ├── especialista-marketing-digital.md (Luna)
│   ├── disenador-visual.md          (Noir)
│   └── copywriter.md                (Verso)
│
├── docs/                            ← entregables y documentación
│   ├── estado-proyecto.md           (Orion — estado general y tareas)
│   ├── decisiones.md                (Orion — registro de decisiones ADR)
│   ├── arquitectura.md              (Ariel — diseño técnico y estructura)
│   ├── database.md                  (Nova — esquema SQL, RLS, relaciones)
│   ├── integraciones.md             (Flux — flujos, APIs, webhooks)
│   ├── design-system.md             (Sage — tokens, componentes, guías)
│   ├── devops.md                    (Cipher — infraestructura, pipeline)
│   ├── security-checklist.md        (Cipher — checklist de seguridad)
│   ├── seo-strategy.md              (Atlas — keywords, URLs, plan SEO)
│   ├── marketing-strategy.md        (Luna — campañas, CRM, calendario)
│   ├── brand-guidelines.md          (Noir — identidad visual, uso de marca)
│   ├── brand-voice.md               (Verso — tono, vocabulario, ejemplos)
│   ├── decisiones-tecnicas/         (Ariel — ADRs técnicos)
│   │   └── ADR-001-*.md
│   ├── copies/                      (Verso + Noir)
│   │   ├── web/                     ← textos de landing y páginas
│   │   ├── emails/                  ← secuencias de email
│   │   ├── whatsapp/                ← mensajes automáticos
│   │   ├── social/                  ← copies de redes sociales
│   │   └── ads/                     ← copies de anuncios
│   └── assets/                      (Noir)
│       ├── feed/                    ← piezas de Instagram
│       ├── stories/                 ← templates de stories
│       ├── ads/                     ← creativos de anuncios
│       ├── whatsapp/                ← imágenes de difusión
│       └── impreso/                 ← carta de bienvenida, señalética
│
├── app/                             ← código fuente (Ariel + Sage)
│   └── [estructura definida por Ariel en /docs/arquitectura.md]
│
├── data/                            ← archivos Excel originales (solo lectura)
│   ├── Base_de_Datos.xlsx
│   ├── Break_1.xlsx
│   ├── Ventas_2026.xlsx
│   └── Aseos.xlsx
│
├── CLAUDE.md                        ← instrucciones del proyecto
└── AGENTS_WORKFLOW.md               ← este archivo
```

---

## 4. ORDEN ESTRICTO DE DEPENDENCIAS — LAS 6 FASES

El diagrama de dependencias es la ley del proyecto. **No se puede saltar una fase por urgencia.**

### FASE 0 — Fundamentos estratégicos
*Nadie codifica hasta que esto esté completo y aprobado por Zaven*

```
┌─────────────────────────────────────────────────────────────────┐
│                         FASE 0                                  │
│                    FUNDAMENTOS ESTRATÉGICOS                      │
└─────────────────────────────────────────────────────────────────┘

Orion lee todos los archivos de /agents
         ↓
Orion presenta a Zaven:
  • Mapa del equipo
  • Orden de trabajo
  • Las 5 decisiones iniciales (dominio, Supabase, roles, presupuesto, migración)
         ↓
Zaven toma las 5 decisiones
         ↓
         ├──────────────────────────────────┐
         ▼                                  ▼
Ariel diseña arquitectura de /app    Nova diseña esquema de BD
  → entrega: /docs/arquitectura.md     → entrega: /docs/database.md
         │                                  │
         └──────────────┬───────────────────┘
                        ▼
              Zaven revisa y aprueba ambos
                        ↓
              ┌─────────┴──────────┐
              ▼                    ▼
Sage diseña sistema de diseño  Cipher configura infraestructura
  → entrega: /docs/design-system   → entrega: /docs/devops.md
              │                    │          + netlify.toml
              └─────────┬──────────┘
                        ▼
              Zaven revisa y aprueba
                        ↓
                   ✅ FASE 0 COMPLETA
              (se puede empezar Fase 2)
```

### FASE 1 — Identidad y estrategia
*Corre en paralelo con Fase 0 — no depende del código*

```
┌─────────────────────────────────────────────────────────────────┐
│                         FASE 1                                  │
│                    IDENTIDAD Y ESTRATEGIA                        │
└─────────────────────────────────────────────────────────────────┘

    ┌──────────────────────────────────────┐
    ▼                                      ▼
Luna define estrategia de marketing    Atlas define estrategia SEO
  → entrega: /docs/marketing-strategy     → entrega: /docs/seo-strategy.md
    │                                      │
    ▼                                      │
Verso escribe brand voice                  │
  (basado en estrategia de Luna)           │
  → entrega: /docs/brand-voice.md          │
    │                                      │
    ▼                                      │
Noir crea moodboard visual                 │
  (basado en brand voice de Verso)         │
  → entrega: /docs/brand-guidelines.md     │
    │                                      │
    └─────────────────┬────────────────────┘
                      ▼
            Orion consolida todo
            y presenta resumen a Zaven
                      ↓
            Zaven revisa y aprueba
                      ↓
                 ✅ FASE 1 COMPLETA
```

### FASE 2 — Construcción base
*Depende de: Fase 0 aprobada*

```
┌─────────────────────────────────────────────────────────────────┐
│                         FASE 2                                  │
│                       CONSTRUCCIÓN BASE                          │
└─────────────────────────────────────────────────────────────────┘

Ariel configura el proyecto
  (Vite + React + TypeScript + Tailwind + Supabase)
         ↓
         ├──────────────────────────────────┐
         ▼                                  ▼
Nova crea las tablas en Supabase    Sage crea componentes base
  (basado en /docs/database.md)       (basado en /docs/design-system.md)
  → RLS configurado                    → Button, Input, Card, Modal, Badge
  → Datos de prueba insertados         → exportados desde /app/components
         │                                  │
         └──────────────┬───────────────────┘
                        ▼
            Cipher configura CI/CD en Netlify
              → GitHub Actions pipeline
              → Preview deploys por rama
              → Variables de entorno
                        ↓
            Cipher ejecuta primera auditoría
              → headers de seguridad
              → RLS verificado
              → npm audit limpio
                        ↓
                 ✅ FASE 2 COMPLETA
              (se puede empezar Fases 3 y 4)
```

### FASE 3 — Módulo Admin
*Depende de: Fase 2 completa*

```
┌─────────────────────────────────────────────────────────────────┐
│                         FASE 3                                  │
│                       MÓDULO ADMIN                               │
└─────────────────────────────────────────────────────────────────┘

Sage diseña pantallas del admin
  (mapa de habitaciones, reservas, CRM, aseo)
         ↓
Ariel construye estructura de rutas admin
  → /admin/dashboard
  → /admin/reservas
  → /admin/huespedes
  → /admin/habitaciones
  → /admin/aseo
         ↓
         ├──────────────────────────────────┐
         ▼                                  ▼
Nova crea queries y vistas SQL         Ariel implementa pantallas
  (dashboard, ocupación, reportes)       (usando componentes de Sage)
         │                                  │
         └──────────────┬───────────────────┘
                        ▼
            Flux conecta notificaciones al staff
              (WhatsApp: nueva reserva, check-in próximo)
                        ↓
            Cipher testea seguridad del módulo admin
              → RLS: huésped no accede a admin
              → Tests E2E del flujo de login admin
              → Lighthouse audit
                        ↓
            Orion presenta módulo a Zaven para revisión
                        ↓
            Zaven prueba y aprueba
                        ↓
                 ✅ FASE 3 COMPLETA
```

### FASE 4 — Portal Huéspedes
*Depende de: Fase 2 completa (puede correr en paralelo con Fase 3)*

```
┌─────────────────────────────────────────────────────────────────┐
│                         FASE 4                                  │
│                      PORTAL HUÉSPEDES                            │
└─────────────────────────────────────────────────────────────────┘

Verso escribe todos los textos del portal
  → landing page completa
  → descripciones de habitaciones
  → textos de confirmación y bienvenida
  → /docs/copies/web/
         ↓
         ├──────────────────────────────────┐
         ▼                                  ▼
Noir diseña piezas visuales           Sage diseña flujos del huésped
  (hero, habitaciones, sección valor)    → reserva (3 pasos)
  → /docs/assets/                         → portal de estadía
                                           → check-in digital
         │                                  │
         └──────────────┬───────────────────┘
                        ▼
            Ariel implementa
              → landing pública
              → flujo de reserva
              → portal autenticado del huésped
                        ↓
            Flux conecta automáticos
              → confirmación por WhatsApp y email
              → bienvenida 2h antes del check-in
              → post-estadía (reseña)
                        ↓
            Atlas optimiza SEO
              → meta tags, schema.org, sitemap
              → keywords en textos de Verso
              → Core Web Vitals
                        ↓
            Cipher testea y audita
              → flujo de reserva end-to-end (E2E)
              → formularios sanitizados
              → Lighthouse ≥ 90
                        ↓
            Orion presenta a Zaven para revisión final
                        ↓
            Zaven aprueba
                        ↓
                 ✅ FASE 4 COMPLETA
```

### FASE 5 — Marketing digital y lanzamiento
*Depende de: Fases 3 y 4 completas*

```
┌─────────────────────────────────────────────────────────────────┐
│                         FASE 5                                  │
│                   MARKETING Y LANZAMIENTO                        │
└─────────────────────────────────────────────────────────────────┘

Luna activa campañas de Meta Ads y TikTok Ads
  → campaña "Una noche fuera de casa"
  → campaña "Work from Break"
         ↓
         ├──────────────────────────────────┐
         ▼                                  ▼
Flux conecta formularios de leads      Nova registra leads en Supabase
  → integración Mailchimp               → CRM actualizado en tiempo real
  → captura de datos en reserva          → segmentación automática
         │                                  │
         └──────────────┬───────────────────┘
                        ▼
            Atlas monitorea posicionamiento
              → Google Search Console activo
              → Google Business Profile optimizado
              → primeras keywords en top 20
                        ↓
            Cipher valida seguridad de formularios
              → sin exposición de datos
              → CAPTCHA o rate limiting en formularios públicos
                        ↓
                 ✅ FASE 5 COMPLETA
```

### FASE 6 — Lanzamiento oficial
*Depende de: Todas las fases anteriores*

```
┌─────────────────────────────────────────────────────────────────┐
│                         FASE 6                                  │
│                      LANZAMIENTO OFICIAL                         │
└─────────────────────────────────────────────────────────────────┘

Cipher ejecuta auditoría completa pre-lanzamiento
  → checklist de seguridad de 30 puntos
  → tests E2E de los 5 flujos críticos
  → Lighthouse ≥ 90 en todas las páginas principales
  → npm audit limpio
  → headers de seguridad: A+ en securityheaders.com
         ↓
Orion presenta checklist completo a Zaven
  → qué está listo
  → qué está pendiente (si algo)
  → plan de comunicación del lanzamiento
         ↓
Zaven revisa y da aprobación de lanzamiento
         ↓
Cipher ejecuta deploy final a producción
  → dominio personalizado configurado
  → DNS propagado
  → SSL activo
  → Sentry activo y recibiendo eventos
         ↓
Luna activa comunicaciones de lanzamiento
  → WhatsApp a los 37 huéspedes repetidos
  → Email de lanzamiento a la base
  → Posts de lanzamiento en Instagram y TikTok
         ↓
Orion documenta el lanzamiento
  → /docs/estado-proyecto.md actualizado
  → /docs/decisiones.md con el historial completo
         ↓
                 🚀 BREAK DIGITAL EN PRODUCCIÓN
```

---

## 5. PROTOCOLO DE COMUNICACIÓN ENTRE AGENTES

### Cuando un agente TERMINA su entregable

El agente que termina debe:

```markdown
## Entregable completado — [Nombre del agente]

**Tarea completada:** [nombre de la tarea]
**Entregable guardado en:** [ruta del archivo en /docs]
**Fecha:** YYYY-MM-DD

**Resumen (máximo 5 líneas):**
[qué se hizo, qué decisiones se tomaron, qué quedó pendiente para otro agente]

**Siguiente agente:** [nombre del agente que recibe este trabajo]
**Qué necesita del entregable:** [qué parte específica del entregable usa el siguiente]
**Bloqueos detectados:** [si hay algo que impide avanzar]
```

Este mensaje va a Orion, quien actualiza `/docs/estado-proyecto.md` y activa al siguiente agente.

### Cuando un agente RECIBE trabajo de otro

El agente que recibe debe:

1. **Leer el entregable completo** antes de empezar — sin atajos
2. **Confirmar que entiende** lo que necesita: repetir en 2 líneas qué va a hacer y por qué
3. **Si hay dudas** → preguntar a Orion, nunca asumir
4. **Nunca modificar** el entregable del agente anterior — solo construir sobre él
5. **Si detecta un problema** en el entregable que recibió → alertar a Orion antes de continuar

### Cuando hay un CONFLICTO entre agentes

Ejemplo: Sage diseña una pantalla que Ariel considera imposible de construir con el stack actual.

```
Proceso de resolución:

1. Ninguno de los dos agentes en conflicto toma una decisión unilateral
2. Ambos presentan su argumento a Orion en máximo 3 líneas cada uno
3. Orion evalúa el impacto en el negocio y el proyecto
4. Orion decide y lo documenta en /docs/decisiones.md
5. Si el conflicto afecta a Zaven (presupuesto, tiempo, marca) → Orion lo escala
6. La decisión de Orion es final, salvo que Zaven la modifique
```

### Señales de bloqueo que todo agente debe reportar

Un agente está bloqueado cuando:
- Necesita información que otro agente aún no ha entregado
- Detecta una contradicción entre dos entregables anteriores
- La tarea requiere una decisión que solo Zaven puede tomar
- Algo en el entorno técnico no funciona (error de Supabase, Netlify, etc.)

**Cuando hay un bloqueo:**
1. El agente lo reporta a Orion inmediatamente
2. No intenta rodear el bloqueo por su cuenta
3. Orion evalúa y decide: esperar, reasignar o escalar a Zaven

---

## 6. TIEMPOS ESTIMADOS POR TIPO DE TAREA

Estos tiempos son estimados por sesión de trabajo con Claude. Una sesión = una conversación continua.

| Tipo de tarea | Sesiones estimadas | Agente principal | Notas |
|---|---|---|---|
| Documento de estrategia (brand voice, marketing, SEO) | 1 sesión completa | Verso / Luna / Atlas | No interrumpir — producen mejor en flujo continuo |
| Diseño de esquema de BD completo | 1-2 sesiones | Nova | Requiere revisión de Zaven antes de implementar |
| Arquitectura de carpetas y configuración inicial | 1 sesión | Ariel | Una sola vez — decisión permanente |
| Sistema de diseño completo | 2-3 sesiones | Sage | Tokens + componentes base + documentación |
| Componente React individual | 1 tarea por sesión | Ariel + Sage | Máximo 2-3 componentes por sesión |
| Pantalla completa (diseño + implementación) | 2 sesiones | Sage → Ariel | Sesión 1: diseño; Sesión 2: implementación |
| Integración de API externa | 2 sesiones | Flux | Sesión 1: diseño del flujo; Sesión 2: implementación |
| Secuencia de email completa | 1 sesión | Verso | Incluye subjects, preheaders y cuerpos |
| Campaña de marketing completa | 3 sesiones | Luna → Verso → Noir | Estrategia → copies → piezas visuales |
| Migración de un Excel a Supabase | 1 sesión | Nova | Incluye limpieza, migración y validación |
| Auditoría de seguridad completa | 1 sesión | Cipher | Pre-lanzamiento o después de features grandes |
| Deploy a producción | 1 sesión | Cipher | Solo con checklist completo — no apresurar |
| Post-mortem de incidente | 1 sesión | Cipher + Orion | Máximo 24h después del incidente |
| Plan semanal | 1 sesión parcial | Orion | Lunes, al inicio del día |

---

## 7. FLUJOS COMPLETOS DE TRABAJO

### FLUJO A — Nueva funcionalidad en el panel admin

```
TRIGGER: Zaven identifica una necesidad o Orion la propone en el plan semanal

1. ORION prioriza la funcionalidad
   → Evalúa: ¿impacta en ocupación o en operación del hotel?
   → Confirma dependencias: ¿la BD lo soporta? ¿el diseño existe?

2. ARIEL diseña la solución técnica
   → Documenta en /docs/arquitectura.md o en un ADR específico
   → Define: componentes necesarios, queries a la BD, rutas afectadas
   → Entrega a: Nova (si necesita cambios en BD) y Sage (si necesita diseño nuevo)

3. NOVA actualiza la BD si es necesario
   → Nueva tabla, columna o vista → actualiza /docs/database.md
   → Verifica que RLS sigue siendo correcto
   → Entrega a: Ariel (la nueva estructura está lista para usar)

4. SAGE diseña la pantalla o componente
   → Basado en el sistema de diseño ya aprobado
   → Mobile-first, dark mode, accesible
   → Entrega a: Ariel (el diseño está definido, se puede construir)

5. ARIEL implementa
   → Usa los componentes de Sage y las queries de Nova
   → Código en inglés, comentarios en español
   → Commit con descripción clara

6. FLUX conecta notificaciones o automatizaciones si aplica
   → WhatsApp al staff, email al huésped, webhook, etc.
   → Entrega a: Cipher (integración lista para revisar)

7. CIPHER testea y aprueba
   → Unit tests + integration tests actualizados
   → RLS verificado con usuario huésped y usuario admin
   → Lighthouse audit si es una pantalla nueva
   → No aprueba si algo falla — sin excepciones

8. ORION presenta a Zaven
   → Resumen en lenguaje de negocio: qué hace, cómo se usa
   → Demo o descripción del flujo

9. ZAVEN aprueba o pide ajustes

10. CIPHER deploya a producción
    → Solo si Zaven aprobó explícitamente
    → Documenta el deploy en /docs/devops.md

TIEMPO TOTAL ESTIMADO: 3-5 sesiones según complejidad
```

### FLUJO B — Campaña de marketing completa

```
TRIGGER: Luna o Zaven identifica una oportunidad de campaña (temporada, fecha especial, retargeting)

1. ORION agenda la campaña con Luna
   → Confirma presupuesto disponible con Zaven
   → Confirma que los activos necesarios (fotos del hotel) están disponibles

2. LUNA define la estrategia
   → Objetivo, audiencia, presupuesto, canales, KPIs
   → Documenta en /docs/marketing-strategy.md
   → Entrega a: Verso (estrategia aprobada, empezar copies)

3. VERSO escribe los copies
   → Copies de ads (headline + texto + CTA)
   → Caption de posts de redes sociales
   → Mensajes de WhatsApp si aplica
   → Guión de TikTok/Reel si aplica
   → Entrega a: Luna (para revisión de estrategia) + Noir (para diseño)

4. LUNA revisa los copies
   → Verifica que el tono y la estrategia estén alineados
   → Aprueba o pide ajuste a Verso
   → Entrega a: Noir (copies aprobados, empezar piezas)

5. NOIR diseña las piezas visuales
   → Basado en los copies de Verso y el sistema de diseño de Sage
   → 3 variantes de cada pieza (A conservadora, B recomendada, C arriesgada)
   → Formatos: feed, stories, ads según lo que Luna necesite
   → Entrega a: Luna (piezas para revisar)

6. LUNA revisa las piezas
   → Verifica coherencia con la estrategia
   → Elige variante final de cada pieza
   → Aprueba o pide ajuste a Noir

7. ATLAS verifica SEO si aplica
   → Si la campaña incluye landing page → keywords naturales en copies de Verso
   → Si hay blog post → estructura SEO correcta
   → Solo si aplica — no todas las campañas tocan SEO

8. FLUX configura automatizaciones
   → Si hay secuencia de WhatsApp → configura en Meta Cloud API
   → Si hay secuencia de email → configura en Resend
   → Si hay formulario de captura → conecta con Supabase via Nova

9. CIPHER valida seguridad
   → Formularios con validación y sanitización
   → Rate limiting en endpoints de captura de leads
   → Sin exposición de datos sensibles en el cliente

10. ORION presenta todo el paquete a Zaven
    → Estrategia, copies, piezas visuales, automatizaciones
    → Presupuesto de ads confirmado

11. ZAVEN aprueba y da luz verde

12. LUNA activa la campaña
    → Configura y lanza ads en Meta Ads Manager / TikTok Ads
    → Publica posts orgánicos
    → Activa secuencias automáticas

13. LUNA reporta resultados
    → Semana 1: primeras métricas (alcance, CTR, CPC)
    → Mes 1: ROAS, costo por reserva, conversiones
    → Documenta en /docs/marketing-strategy.md

TIEMPO TOTAL ESTIMADO: 3-5 sesiones según complejidad de la campaña
```

### FLUJO C — Bug en producción

```
TRIGGER: Sentry detecta un spike de errores O Zaven o un huésped reporta un problema

1. CIPHER detecta y clasifica
   → Severidad: Crítica (afecta reservas) / Alta (afecta acceso) / Media / Baja
   → Alerta inmediata a Zaven y Orion si es Crítica o Alta

2. ORION evalúa el impacto en el negocio
   → ¿Afecta el flujo de reservas? → Rollback inmediato a la versión anterior
   → ¿Es cosmético? → Fix en la próxima sesión
   → Comunica decisión a Cipher

3. CIPHER ejecuta rollback si es necesario
   → Netlify dashboard → deploy anterior → "Publish deploy"
   → Tiempo estimado: < 2 minutos

4. ARIEL corrige el bug
   → Reproduce localmente antes de tocar producción
   → Fix mínimo y quirúrgico — sin refactors aprovechados
   → Commit con mensaje claro: "fix: [descripción del bug]"

5. CIPHER verifica el fix
   → El test que fallaba ahora pasa
   → No hay regresiones en los tests existentes
   → El flujo afectado funciona en staging/preview

6. CIPHER hace deploy urgente a producción
   → Solo el fix, nada más
   → Monitorea Sentry los siguientes 30 minutos

7. ORION documenta el post-mortem
   → Qué pasó, cuándo, por qué, cómo se resolvió
   → Tiempo de inactividad si lo hubo
   → Medidas preventivas para evitar que se repita
   → Documenta en /docs/devops.md

TIEMPO TOTAL OBJETIVO:
  → Detección a rollback: < 5 minutos (si es crítico)
  → Detección a fix definitivo: < 2 horas (si es crítico)
  → Post-mortem: máximo 24h después del incidente
```

### FLUJO D — Inicio de sesión diaria con Zaven

```
TRIGGER: Zaven escribe "Orion, ¿cómo vamos?" o abre una nueva sesión

1. ORION lee el estado actual
   → /docs/estado-proyecto.md → ¿qué está en progreso, qué está bloqueado?
   → /docs/decisiones.md → ¿hay decisiones pendientes?
   → Contexto de la última sesión si está disponible

2. ORION presenta resumen ejecutivo (formato estándar)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   BREAK DIGITAL — Estado [Fecha]
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ✅ COMPLETADO: [lista]
   🔄 EN PROGRESO: [lista]
   ⏸ BLOQUEADO: [lista + razón]
   🔴 DECISIONES PENDIENTES: [lista]
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   PROPUESTA PARA HOY:
   1. [tarea más importante] — [agente] — [tiempo est.]
   2. [segunda tarea] — [agente]
   3. [tercera tarea] — [agente]
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ¿Hay algo urgente que cambie esta prioridad?

3. ZAVEN responde
   → Aprueba el plan → Orion activa agentes en orden
   → Ajusta prioridades → Orion actualiza y activa
   → Tiene algo urgente → Orion reorganiza

4. ORION activa los agentes necesarios
   → En el orden correcto según las dependencias
   → Un agente a la vez cuando las tareas son secuenciales
   → En paralelo cuando las tareas son independientes

5. Cada AGENTE trabaja su tarea completa
   → Sin interrupciones de otros temas
   → Entrega en su carpeta de /docs
   → Reporta a Orion cuando termina

6. ORION hace cierre al final de la sesión
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   CIERRE DE SESIÓN — [Fecha]
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   LOGRADO HOY: [lista]
   PARA LA PRÓXIMA SESIÓN: [lista priorizada]
   ZAVEN NECESITA REVISAR: [enlace o descripción]
   DECISIONES PENDIENTES: [si las hay]
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Estado actualizado en /docs/estado-proyecto.md

TIEMPO: variable según las tareas del día
```

### FLUJO E — Migración de datos desde Excel

```
TRIGGER: Fase 3 (módulo admin) está completa, las tablas de Supabase existen

1. ORION coordina con Nova y Zaven
   → Confirma que todas las tablas necesarias existen en Supabase
   → Agenda sesión de migración fuera de temporada alta

2. NOVA prepara los scripts de migración
   → Python + pandas para leer cada Excel
   → Limpieza de datos: deduplicación, formatos, teléfonos, fechas
   → Script idempotente — puede ejecutarse múltiples veces sin duplicar
   → Prueba en base de datos de staging primero

3. NOVA ejecuta migración en staging
   → Carga los 37 huéspedes de Base_de_Datos.xlsx
   → Carga las reservas de Break_1.xlsx (las más recientes)
   → Carga los datos de Ventas_2026.xlsx para finanzas
   → Verifica integridad con queries de validación

4. ORION presenta resultados a Zaven
   → N huéspedes migrados, N reservas importadas
   → Cualquier dato que no pudo migrarse y por qué

5. ZAVEN valida los datos
   → Revisa que sus huéspedes conocidos estén en el sistema
   → Verifica que una reserva reciente esté correcta
   → Aprueba o pide correcciones

6. NOVA ejecuta migración en producción
   → Solo después de aprobación de Zaven
   → Con backup previo de la BD (Supabase lo hace automáticamente en plan Pro)

7. ORION documenta la migración
   → Fecha, registros migrados, incidencias
   → Los Excel pasan a estado "archivados" — referencia histórica
   → Actualiza /docs/estado-proyecto.md

TIEMPO TOTAL ESTIMADO: 2 sesiones (preparación + ejecución)
```

---

## 8. REGLAS DE ORO

Las 10 reglas que no tienen excepción.

```
╔══════════════════════════════════════════════════════════════════╗
║           LAS 10 REGLAS DE ORO — BREAK DIGITAL                  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  1. UN AGENTE A LA VEZ POR TAREA                                ║
║     El multitasking desenfocado produce trabajo mediocre.        ║
║     Cada agente termina lo suyo antes de empezar otra cosa.      ║
║                                                                  ║
║  2. DOCUMENTAR ANTES DE CODIFICAR                               ║
║     Si no está escrito en /docs, no existe.                      ║
║     El código sin diseño previo es deuda técnica instantánea.    ║
║                                                                  ║
║  3. ZAVEN APRUEBA LOS HITOS — NO LOS DETALLES                  ║
║     Zaven no revisa cada línea de código ni cada pixel.          ║
║     Aprueba la dirección, el diseño y el resultado final.        ║
║                                                                  ║
║  4. CIPHER TIENE PODER DE VETO ABSOLUTO EN SEGURIDAD           ║
║     Si Cipher dice que algo no va a producción,                  ║
║     no va a producción. Sin argumentos, sin excepciones.         ║
║                                                                  ║
║  5. ORION TIENE PODER DE REASIGNAR TAREAS                      ║
║     Si un agente está bloqueado más de una sesión,               ║
║     Orion puede reasignar la tarea o cambiar el enfoque.         ║
║                                                                  ║
║  6. NINGÚN DEPLOY SIN CHECKLIST DE CIPHER COMPLETO             ║
║     No importa la urgencia. No importa el viernes.               ║
║     El checklist es el contrato de calidad del proyecto.         ║
║                                                                  ║
║  7. EL PROYECTO AVANZA EN FASES — NUNCA SE SALTA UNA           ║
║     La urgencia no justifica saltarse fundamentos.               ║
║     Construir sobre cimientos flojos siempre cuesta más.         ║
║                                                                  ║
║  8. LOS TOKENS SON RECURSOS — CADA PROMPT TIENE PROPÓSITO      ║
║     Antes de activar un agente, Orion verifica que              ║
║     la tarea está clara y las dependencias están listas.         ║
║                                                                  ║
║  9. AL FINAL DE CADA SESIÓN, /docs/estado-proyecto.md ACTUALIZADO ║
║     La documentación que no se actualiza en el momento           ║
║     no se actualiza nunca.                                       ║
║                                                                  ║
║ 10. LA CALIDAD DEL TRABAJO DIGITAL REFLEJA LA CALIDAD DEL HOTEL ║
║     Break es una marca premium. Su plataforma digital            ║
║     debe serlo también. Sin mediocridades.                       ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 9. REFERENCIA RÁPIDA — QUIÉN HACE QUÉ

### Por tipo de situación

| Situación | Quién actuar primero | Luego |
|---|---|---|
| Nueva sesión de trabajo | **Orion** siempre | Según el plan del día |
| Nueva funcionalidad | **Orion** prioriza → **Ariel** diseña | Según flujo A |
| Bug en producción | **Cipher** detecta y alerta | Según flujo C |
| Campaña de marketing | **Orion** + **Luna** coordinan | Según flujo B |
| Cambio en el diseño | **Sage** propone → **Orion** valida impacto | Ariel implementa |
| Cambio en la BD | **Nova** propone → **Cipher** valida RLS | Ariel adapta el código |
| Decisión de presupuesto | **Orion** presenta opciones → **Zaven** decide | Nadie actúa hasta que Zaven decide |
| Texto para cualquier canal | **Verso** escribe → **Luna** revisa (si es marketing) | **Noir** diseña sobre el texto |
| Nueva integración | **Flux** diseña el flujo → **Orion** valida | **Cipher** audita antes de activar |
| Lanzamiento | **Cipher** audita → **Orion** presenta → **Zaven** aprueba | **Cipher** deploya |

### Reglas de coordinación entre agentes (resumen)

```
ARIEL     → siempre primero en arquitectura — nadie codifica sin su diseño
NOVA      → define el esquema de BD antes de que Flux o Ariel toquen datos
SAGE      → diseña antes de que Ariel construya — nunca al revés
VERSO     → escribe antes de que Noir diseñe — el copy define el espacio visual
LUNA      → aprueba la estrategia antes de que Verso empiece a escribir
ATLAS     → revisa después de Verso — el SEO se integra, no se agrega al final
CIPHER    → revisa siempre de último — nada a producción sin su aprobación
ORION     → coordina todo — nadie empieza sin su confirmación de dependencias
```

### Matriz de dependencias — quién depende de quién

|  | Ariel | Nova | Flux | Sage | Cipher | Atlas | Luna | Noir | Verso |
|---|---|---|---|---|---|---|---|---|---|
| **Ariel** | — | ✓ BD lista | — | ✓ diseño listo | — | — | — | — | — |
| **Nova** | ✓ arquitectura | — | — | — | — | — | — | — | — |
| **Flux** | ✓ rutas listas | ✓ tablas listas | — | — | — | — | — | — | — |
| **Sage** | ✓ stack listo | — | — | — | — | — | — | — | ✓ copy listo |
| **Cipher** | ✓ code listo | ✓ RLS listo | ✓ webhooks listos | — | — | — | — | — | — |
| **Atlas** | — | — | — | — | — | — | — | — | ✓ textos listos |
| **Luna** | — | — | ✓ automatizaciones | — | — | — | — | ✓ piezas listas | ✓ copies listos |
| **Noir** | — | — | — | ✓ sistema diseño | — | — | — | — | ✓ copy listo |
| **Verso** | — | — | — | — | — | ✓ keywords | ✓ estrategia | — | — |

*(✓ = necesita que ese entregable esté listo antes de empezar)*

---

*Documento mantenido por Orion. Última actualización: al crear el equipo.*  
*Cualquier modificación a este protocolo requiere aprobación de Zaven.*
