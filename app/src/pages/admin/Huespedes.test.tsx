import { beforeEach, describe, expect, it, vi } from 'vitest'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { MemoryRouter } from 'react-router-dom'

const fromMock = vi.fn()
const syncMock = vi.fn(async () => ({
  ok: true,
  creados: 2,
  actualizados: 4,
  contactos_unicos: 30,
  errores: 0,
}))

vi.mock('@/lib/supabase', () => ({
  supabaseUrl: 'https://demo.supabase.co',
  supabase: {
    from: (...args: unknown[]) => fromMock(...args),
    auth: { getSession: vi.fn(async () => ({ data: { session: null } })) },
  },
}))

vi.mock('@/lib/pxsol-contactos', () => ({
  syncContactosPxsol: (...args: unknown[]) => syncMock(...args),
}))

import Huespedes from '@/pages/admin/Huespedes'

function mockHuespedesQuery(data: unknown[]) {
  fromMock.mockImplementation(() => {
    const result = Promise.resolve({ data, error: null })
    const chain: Record<string, unknown> = {
      is: () => chain,
      order: () => chain,
      limit: () => chain,
      or: () => chain,
      then: (onFulfilled: (v: unknown) => unknown, onRejected?: (e: unknown) => unknown) =>
        result.then(onFulfilled, onRejected),
    }
    return {
      select: () => chain,
    }
  })
}

function renderPage() {
  const qc = new QueryClient({
    defaultOptions: { queries: { retry: false } },
  })
  return render(
    <QueryClientProvider client={qc}>
      <MemoryRouter>
        <Huespedes />
      </MemoryRouter>
    </QueryClientProvider>,
  )
}

describe('Huespedes — sync PxSol', () => {
  beforeEach(() => {
    syncMock.mockClear()
    fromMock.mockClear()
  })

  it('muestra el botón de sincronizar contactos', async () => {
    mockHuespedesQuery([
      {
        id: '1',
        nombre: 'Ana Restrepo',
        celular: '3001112233',
        correo: 'ana@test.com',
        nacionalidad: 'colombiana',
        pxsol_pax_id: '99',
        reservas: [{ count: 2 }],
      },
    ])

    renderPage()

    expect(
      await screen.findByRole('button', { name: /Sincronizar contactos PxSol/i }),
    ).toBeInTheDocument()
  })

  it('al hacer clic dispara sync y muestra el resumen', async () => {
    mockHuespedesQuery([])

    renderPage()
    const btn = await screen.findByRole('button', {
      name: /Sincronizar contactos PxSol/i,
    })
    fireEvent.click(btn)

    await waitFor(() => {
      expect(syncMock).toHaveBeenCalledWith({ force: true })
    })
    expect(
      await screen.findByText(/2 nuevos · 4 actualizados/i),
    ).toBeInTheDocument()
  })
})
