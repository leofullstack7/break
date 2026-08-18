# Break Hotel — Proyecto Digital

## Identidad del negocio
Break es un hotel boutique lifestyle ubicado en Av. Santander, Carrera 23 #53-40, 
Manizales, Colombia. Estrato 6, sector El Triángulo.
24 estudios tipo apartaestudio (pisos 1-4, habitaciones 105 a 407).
Eco-friendly: paneles solares, caldera centralizada.

## ADN de marca
- Tagline principal: "La pausa también es estrategia"
- Tagline secundario: "Una pausa bien pensada también es avanzar"
- Paleta: tonos cálidos, negro, dorado, beige, minimalismo
- Tipografía: moderna, elegante, sin serifa
- NO es un hotel tradicional. Es una marca lifestyle.
- Público: ejecutivos, nómadas digitales, parejas, viajeros 25-45 años
- Ciudades objetivo: Manizales, Pereira, Armenia, Medellín

## Stack tecnológico del proyecto
- Frontend: React + Vite (PWA — Progressive Web App)
- Backend/DB: Supabase (PostgreSQL + Auth + Storage)
- Deploy: Netlify
- Styling: Tailwind CSS
- Lenguaje: TypeScript

## Estructura del proyecto
- /agents → instrucciones de cada agente IA
- /app → código fuente de la web app
- /data → archivos Excel actuales del hotel
- /docs → documentación del proyecto

## Módulos de la web app
### Panel Administrativo (solo staff)
- Dashboard de ocupación en tiempo real
- Gestión de reservas (crear, editar, cancelar)
- CRM de huéspedes
- Finanzas (ingresos, comisiones, reportes)
- Control de aseo y lavandería
- Agenda de operaciones

### Portal de Huéspedes (público)
- Reservar habitación
- Check-in digital
- Servicios durante la estadía
- WhatsApp integrado

### Marketing Digital
- Base de datos de huéspedes repetidos
- Envío de mailing
- Difusión WhatsApp
- Métricas y analytics

## Contexto de datos actuales
El hotel maneja actualmente 4 archivos Excel:
1. Base_de_Datos.xlsx → CRM manual (~37 huéspedes repetidos)
2. Break_1.xlsx → Reservas por habitación (hoja por cada habitación)
3. Ventas_2026.xlsx → Reporte mensual de ocupación e ingresos
4. Aseos.xlsx → Control de lavandería y limpieza

Ocupación actual enero 2026: 31.6% (235 noches sobre 744 disponibles)
Meta: superar 60% de ocupación con estrategia digital

## Reglas para todos los agentes
1. Siempre respetar el ADN de marca de Break
2. El código debe ser limpio, escalable y bien comentado
3. Priorizar mobile-first (la mayoría de usuarios son móvil)
4. Idioma de la interfaz: español colombiano
5. Idioma del código y comentarios: español
6. Consultar al usuario antes de decisiones arquitectónicas mayores
7. Los archivos Excel en /data son solo referencia — no modificarlos