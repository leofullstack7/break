/** Helpers MIME para audio del chat (MediaRecorder ↔ chat-media). */

/** MediaRecorder pide codecs; el Blob/upload usan solo el tipo base. */
export function mimeAudioBase(raw: string): string {
  const base = (raw || '').split(';')[0].trim().toLowerCase()
  if (base.startsWith('audio/')) return base
  return 'audio/webm'
}

export function mimeAudioPreferido(): string {
  if (typeof MediaRecorder === 'undefined') return ''
  if (MediaRecorder.isTypeSupported('audio/webm;codecs=opus')) return 'audio/webm;codecs=opus'
  if (MediaRecorder.isTypeSupported('audio/mp4')) return 'audio/mp4'
  if (MediaRecorder.isTypeSupported('audio/webm')) return 'audio/webm'
  return ''
}
