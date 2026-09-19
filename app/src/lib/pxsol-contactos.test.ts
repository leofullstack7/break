import { beforeEach, describe, expect, it, vi } from 'vitest'

vi.mock('@/lib/supabase', () => ({
  supabaseUrl: 'https://demo.supabase.co',
  supabase: {
    auth: {
      getSession: vi.fn(async () => ({
        data: {
          session: { access_token: 'token-demo' },
        },
      })),
    },
  },
}))

describe('syncContactosPxsol', () => {
  beforeEach(() => {
    vi.stubGlobal('fetch', vi.fn())
    vi.stubEnv('VITE_SUPABASE_ANON_KEY', 'anon-demo')
  })

  it('llama a pxsol-contactos-sync con force=true por defecto', async () => {
    const fetchMock = vi.mocked(fetch)
    fetchMock.mockResolvedValue({
      ok: true,
      json: async () => ({
        ok: true,
        creados: 3,
        actualizados: 5,
        contactos_unicos: 40,
        errores: 0,
      }),
    } as Response)

    const { syncContactosPxsol } = await import('@/lib/pxsol-contactos')
    const result = await syncContactosPxsol()

    expect(fetchMock).toHaveBeenCalledOnce()
    const [url, init] = fetchMock.mock.calls[0]
    expect(String(url)).toContain('/functions/v1/pxsol-contactos-sync')
    expect(init?.method).toBe('POST')
    expect(init?.headers).toMatchObject({
      Authorization: 'Bearer token-demo',
      'Content-Type': 'application/json',
    })
    expect(JSON.parse(String(init?.body))).toEqual({ force: true })
    expect(result).toMatchObject({ ok: true, creados: 3, actualizados: 5 })
  })

  it('propaga error HTTP de la edge function', async () => {
    vi.mocked(fetch).mockResolvedValue({
      ok: false,
      status: 500,
      json: async () => ({ error: 'Falta PXSOL_API_KEY en los secrets.' }),
    } as Response)

    // Re-import no necesario — módulo ya cargado; función pura
    const { syncContactosPxsol } = await import('@/lib/pxsol-contactos')
    const result = await syncContactosPxsol({ force: false })

    expect(result.ok).toBe(false)
    expect(result.error).toContain('PXSOL_API_KEY')
    expect(JSON.parse(String(vi.mocked(fetch).mock.calls[0][1]?.body))).toEqual({
      force: false,
    })
  })
})
