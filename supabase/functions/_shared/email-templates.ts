// Plantillas HTML de email transaccional — Break Hotel
// ADN de marca: tonos cálidos, negro, dorado, beige, minimalismo, lifestyle

// ─── Datos para las plantillas ───

export interface DatosReserva {
  nombre_huesped: string
  habitacion_numero: number
  fecha_entrada: string   // YYYY-MM-DD
  fecha_salida: string    // YYYY-MM-DD
  noches: number
  pago_total: number
  codigo_reserva?: string // ID corto para referencia
}

// ─── Datos para campañas de marketing ───

export interface DatosCampana {
  asunto: string
  mensaje: string        // Texto plano — se convierte a HTML con párrafos
  nombre_campana: string
  cta_texto?: string     // Texto del botón CTA (opcional)
  cta_url?: string       // URL del botón CTA (opcional)
}

// ─── Utilidades ───

function formatearFecha(fecha: string): string {
  const meses = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ]
  const [anio, mes, dia] = fecha.split('-').map(Number)
  return `${dia} de ${meses[mes - 1]} de ${anio}`
}

function formatearPrecio(monto: number): string {
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', minimumFractionDigits: 0 }).format(monto)
}

// ─── Layout base ───

function layoutBase(contenido: string): string {
  return `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Break Hotel</title>
</head>
<body style="margin:0;padding:0;background-color:#f5f0eb;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;color:#1a1a1a;">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#f5f0eb;padding:32px 16px;">
    <tr>
      <td align="center">
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:560px;background-color:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.06);">
          <!-- Header -->
          <tr>
            <td style="background-color:#1a1a1a;padding:28px 32px;text-align:center;">
              <h1 style="margin:0;font-size:28px;font-weight:300;letter-spacing:4px;color:#c9a96e;">BREAK</h1>
              <p style="margin:4px 0 0;font-size:11px;letter-spacing:2px;color:#a0a0a0;text-transform:uppercase;">Hotel · Manizales</p>
            </td>
          </tr>
          <!-- Contenido -->
          <tr>
            <td style="padding:32px;">
              ${contenido}
            </td>
          </tr>
          <!-- Footer -->
          <tr>
            <td style="background-color:#f9f6f2;padding:24px 32px;border-top:1px solid #e8e0d8;">
              <p style="margin:0 0 8px;font-size:12px;color:#8a7d72;text-align:center;font-style:italic;">La pausa también es estrategia</p>
              <p style="margin:0;font-size:11px;color:#a09890;text-align:center;">
                Av. Santander, Cra 23 #53-40 · Manizales, Colombia<br>
                <a href="https://wa.me/573001234567" style="color:#c9a96e;text-decoration:none;">WhatsApp</a> ·
                <a href="https://breakmanizales.com" style="color:#c9a96e;text-decoration:none;">breakmanizales.com</a>
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`
}

// ─── 1. Confirmación de reserva ───

export function plantillaConfirmacionReserva(datos: DatosReserva): { subject: string; html: string } {
  const contenido = `
    <h2 style="margin:0 0 8px;font-size:22px;font-weight:400;color:#1a1a1a;">¡Reserva confirmada!</h2>
    <p style="margin:0 0 24px;font-size:15px;color:#5a5550;line-height:1.5;">
      Hola <strong>${datos.nombre_huesped}</strong>, tu estadía en Break está lista. Aquí tienes los detalles:
    </p>

    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#faf8f5;border-radius:8px;padding:20px;margin-bottom:24px;">
      <tr>
        <td style="padding:8px 16px;border-bottom:1px solid #ede8e3;">
          <span style="font-size:12px;color:#8a7d72;text-transform:uppercase;letter-spacing:1px;">Habitación</span><br>
          <span style="font-size:16px;font-weight:600;color:#1a1a1a;">Estudio ${datos.habitacion_numero}</span>
        </td>
      </tr>
      <tr>
        <td style="padding:8px 16px;border-bottom:1px solid #ede8e3;">
          <span style="font-size:12px;color:#8a7d72;text-transform:uppercase;letter-spacing:1px;">Check-in</span><br>
          <span style="font-size:16px;color:#1a1a1a;">${formatearFecha(datos.fecha_entrada)}</span>
        </td>
      </tr>
      <tr>
        <td style="padding:8px 16px;border-bottom:1px solid #ede8e3;">
          <span style="font-size:12px;color:#8a7d72;text-transform:uppercase;letter-spacing:1px;">Check-out</span><br>
          <span style="font-size:16px;color:#1a1a1a;">${formatearFecha(datos.fecha_salida)}</span>
        </td>
      </tr>
      <tr>
        <td style="padding:8px 16px;border-bottom:1px solid #ede8e3;">
          <span style="font-size:12px;color:#8a7d72;text-transform:uppercase;letter-spacing:1px;">Noches</span><br>
          <span style="font-size:16px;color:#1a1a1a;">${datos.noches}</span>
        </td>
      </tr>
      <tr>
        <td style="padding:8px 16px;">
          <span style="font-size:12px;color:#8a7d72;text-transform:uppercase;letter-spacing:1px;">Total</span><br>
          <span style="font-size:18px;font-weight:600;color:#c9a96e;">${formatearPrecio(datos.pago_total)}</span>
        </td>
      </tr>
    </table>

    <p style="margin:0 0 16px;font-size:14px;color:#5a5550;line-height:1.6;">
      El check-in es a partir de las <strong>3:00 p.m.</strong> y el check-out hasta las <strong>12:00 p.m.</strong>
      Recibirás un correo 2 horas antes de tu llegada con las instrucciones de acceso.
    </p>

    <p style="margin:0 0 4px;font-size:14px;color:#5a5550;">¿Preguntas? Escríbenos por WhatsApp.</p>
    <a href="https://wa.me/573001234567" style="display:inline-block;margin-top:12px;padding:12px 28px;background-color:#1a1a1a;color:#c9a96e;text-decoration:none;border-radius:6px;font-size:14px;font-weight:500;letter-spacing:0.5px;">Escribir por WhatsApp</a>
  `

  return {
    subject: `Reserva confirmada — Estudio ${datos.habitacion_numero} · Break Hotel`,
    html: layoutBase(contenido),
  }
}

// ─── 2. Pre check-in (2 horas antes) ───

export function plantillaPreCheckin(datos: DatosReserva): { subject: string; html: string } {
  const contenido = `
    <h2 style="margin:0 0 8px;font-size:22px;font-weight:400;color:#1a1a1a;">Tu estudio te espera</h2>
    <p style="margin:0 0 24px;font-size:15px;color:#5a5550;line-height:1.5;">
      Hola <strong>${datos.nombre_huesped}</strong>, faltan pocas horas para tu llegada. Todo está listo para recibirte en Break.
    </p>

    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#faf8f5;border-radius:8px;padding:20px;margin-bottom:24px;">
      <tr>
        <td style="padding:8px 16px;border-bottom:1px solid #ede8e3;">
          <span style="font-size:12px;color:#8a7d72;text-transform:uppercase;letter-spacing:1px;">Tu estudio</span><br>
          <span style="font-size:16px;font-weight:600;color:#1a1a1a;">Habitación ${datos.habitacion_numero} · Piso ${Math.floor(datos.habitacion_numero / 100)}</span>
        </td>
      </tr>
      <tr>
        <td style="padding:8px 16px;">
          <span style="font-size:12px;color:#8a7d72;text-transform:uppercase;letter-spacing:1px;">Check-in</span><br>
          <span style="font-size:16px;color:#1a1a1a;">Hoy desde las 3:00 p.m.</span>
        </td>
      </tr>
    </table>

    <h3 style="margin:0 0 12px;font-size:16px;font-weight:500;color:#1a1a1a;">Instrucciones de llegada</h3>
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:24px;">
      <tr>
        <td style="padding:6px 0;font-size:14px;color:#5a5550;line-height:1.6;">
          <strong style="color:#c9a96e;">1.</strong> Dirígete a Av. Santander, Cra 23 #53-40 (sector El Triángulo).
        </td>
      </tr>
      <tr>
        <td style="padding:6px 0;font-size:14px;color:#5a5550;line-height:1.6;">
          <strong style="color:#c9a96e;">2.</strong> En recepción te entregarán la llave de tu estudio.
        </td>
      </tr>
      <tr>
        <td style="padding:6px 0;font-size:14px;color:#5a5550;line-height:1.6;">
          <strong style="color:#c9a96e;">3.</strong> WiFi del hotel: <strong>Break_Guest</strong> — la contraseña estará en tu habitación.
        </td>
      </tr>
    </table>

    <p style="margin:0 0 16px;font-size:14px;color:#5a5550;line-height:1.6;">
      Si necesitas check-in anticipado o llegada tardía, avísanos por WhatsApp y lo coordinamos.
    </p>

    <a href="https://wa.me/573001234567" style="display:inline-block;margin-top:8px;padding:12px 28px;background-color:#1a1a1a;color:#c9a96e;text-decoration:none;border-radius:6px;font-size:14px;font-weight:500;letter-spacing:0.5px;">Escribir por WhatsApp</a>
  `

  return {
    subject: `Tu estudio te espera hoy — Break Hotel`,
    html: layoutBase(contenido),
  }
}

// ─── 3. Post-estadía (solicitud de reseña) ───

export function plantillaPostEstadia(datos: DatosReserva): { subject: string; html: string } {
  const contenido = `
    <h2 style="margin:0 0 8px;font-size:22px;font-weight:400;color:#1a1a1a;">Gracias por tu visita</h2>
    <p style="margin:0 0 24px;font-size:15px;color:#5a5550;line-height:1.5;">
      Hola <strong>${datos.nombre_huesped}</strong>, esperamos que hayas disfrutado tu pausa en Break. Tu opinión nos ayuda a seguir mejorando.
    </p>

    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#faf8f5;border-radius:8px;padding:20px;margin-bottom:24px;">
      <tr>
        <td style="padding:8px 16px;border-bottom:1px solid #ede8e3;">
          <span style="font-size:12px;color:#8a7d72;text-transform:uppercase;letter-spacing:1px;">Tu estadía</span><br>
          <span style="font-size:16px;color:#1a1a1a;">Estudio ${datos.habitacion_numero} · ${datos.noches} noche${datos.noches > 1 ? 's' : ''}</span>
        </td>
      </tr>
      <tr>
        <td style="padding:8px 16px;">
          <span style="font-size:12px;color:#8a7d72;text-transform:uppercase;letter-spacing:1px;">Fechas</span><br>
          <span style="font-size:14px;color:#5a5550;">${formatearFecha(datos.fecha_entrada)} — ${formatearFecha(datos.fecha_salida)}</span>
        </td>
      </tr>
    </table>

    <p style="margin:0 0 20px;font-size:15px;color:#5a5550;line-height:1.6;">
      ¿Podrías dejarnos una reseña rápida? Toma menos de un minuto y nos ayuda muchísimo.
    </p>

    <div style="text-align:center;margin-bottom:24px;">
      <a href="https://g.page/r/BREAK_GOOGLE_REVIEW_LINK/review" style="display:inline-block;padding:14px 32px;background-color:#c9a96e;color:#1a1a1a;text-decoration:none;border-radius:6px;font-size:15px;font-weight:600;letter-spacing:0.5px;">Dejar mi reseña en Google</a>
    </div>

    <p style="margin:0 0 8px;font-size:14px;color:#5a5550;line-height:1.6;">
      Y si quieres volver, recuerda que reservando directo con nosotros obtienes el mejor precio garantizado.
    </p>

    <p style="margin:16px 0 0;font-size:14px;color:#8a7d72;">
      ¡Te esperamos de vuelta!<br>
      <strong style="color:#1a1a1a;">Equipo Break</strong>
    </p>
  `

  return {
    subject: `Gracias por hospedarte en Break, ${datos.nombre_huesped}`,
    html: layoutBase(contenido),
  }
}

// ─── 4. Campaña de marketing (contenido libre) ───

export function plantillaCampana(datos: DatosCampana): { subject: string; html: string } {
  const parrafos = datos.mensaje
    .split('\n')
    .filter(p => p.trim())
    .map(p => `<p style="margin:0 0 16px;font-size:15px;color:#5a5550;line-height:1.6;">${p}</p>`)
    .join('\n')

  const botonCta = datos.cta_texto && datos.cta_url
    ? `<div style="text-align:center;margin:24px 0;">
        <a href="${datos.cta_url}" style="display:inline-block;padding:14px 32px;background-color:#c9a96e;color:#1a1a1a;text-decoration:none;border-radius:6px;font-size:15px;font-weight:600;letter-spacing:0.5px;">${datos.cta_texto}</a>
      </div>`
    : ''

  const contenido = `
    ${parrafos}
    ${botonCta}
    <p style="margin:24px 0 0;font-size:13px;color:#a09890;line-height:1.5;">
      Recibiste este correo porque te hospedaste en Break Hotel.
      Si no deseas recibir más correos, responde a este mensaje con "No más emails".
    </p>
  `

  return {
    subject: datos.asunto,
    html: layoutBase(contenido),
  }
}
