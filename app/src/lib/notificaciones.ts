function puedeNotificar() {
  return typeof window !== 'undefined' && 'Notification' in window
}

export async function pedirPermisoNotificaciones(): Promise<boolean> {
  if (!puedeNotificar()) return false
  if (Notification.permission === 'granted') return true
  if (Notification.permission === 'denied') return false
  const res = await Notification.requestPermission()
  return res === 'granted'
}

export function sonarAviso() {
  try {
    const ctx = new AudioContext()
    const osc = ctx.createOscillator()
    const gain = ctx.createGain()
    osc.type = 'sine'
    osc.frequency.value = 880
    gain.gain.value = 0.04
    osc.connect(gain)
    gain.connect(ctx.destination)
    osc.start()
    osc.frequency.exponentialRampToValueAtTime(660, ctx.currentTime + 0.12)
    gain.gain.exponentialRampToValueAtTime(0.0001, ctx.currentTime + 0.28)
    osc.stop(ctx.currentTime + 0.3)
  } catch {
    // Silencio si el navegador bloquea audio
  }
}

export function mostrarNotificacion(params: {
  titulo: string
  cuerpo: string
  tag?: string
  onClick?: () => void
}) {
  if (!puedeNotificar() || Notification.permission !== 'granted') return
  if (typeof document !== 'undefined' && !document.hidden && !params.tag) return

  const n = new Notification(params.titulo, {
    body: params.cuerpo,
    tag: params.tag,
    silent: true,
  })
  n.onclick = () => {
    window.focus()
    params.onClick?.()
    n.close()
  }
}
