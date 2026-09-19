import { beforeEach, describe, expect, it, vi } from 'vitest'

vi.mock('@/lib/supabase', () => ({
  supabaseUrl: 'https://demo.supabase.co',
  supabase: {
    auth: {
      getSession: vi.fn(async () => ({ data: { session: null } })),
    },
  },
}))

describe('subirAdjuntoChat — MIME audio', () => {
  beforeEach(() => {
    vi.stubGlobal('fetch', vi.fn())
    vi.stubEnv('VITE_SUPABASE_ANON_KEY', 'anon-demo')
  })

  it('envía File con tipo base (sin codecs) a chat-media', async () => {
    const fetchMock = vi.mocked(fetch)
    fetchMock.mockResolvedValue({
      ok: true,
      json: async () => ({ ok: true, path: 'tok/abc.webm', url: 'https://cdn/abc.webm' }),
    } as Response)

    const { subirAdjuntoChat } = await import('@/lib/chat-habitacion')
    const blob = new Blob([new Uint8Array([1, 2, 3])], {
      type: 'audio/webm;codecs=opus',
    })

    const result = await subirAdjuntoChat({
      archivo: blob,
      nombre: 'nota.webm',
      tipo: 'audio',
      token: 'qr-token',
    })

    expect(result.path).toBe('tok/abc.webm')
    expect(fetchMock).toHaveBeenCalledOnce()
    const [, init] = fetchMock.mock.calls[0]
    const form = init?.body as FormData
    const file = form.get('archivo') as File
    expect(file).toBeInstanceOf(File)
    expect(file.type).toBe('audio/webm')
    expect(form.get('tipo')).toBe('audio')
    expect(form.get('token')).toBe('qr-token')
  })
})
