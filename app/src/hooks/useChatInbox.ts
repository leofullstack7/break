import { useEffect, useRef } from 'react'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { supabase } from '@/lib/supabase'
import { fetchInboxChats } from '@/lib/chat-habitacion'
import { mostrarNotificacion, pedirPermisoNotificaciones, sonarAviso } from '@/lib/notificaciones'
import { useAuthStore } from '@/store/authStore'
import type { ChatMensaje } from '@/types/database.types'

export function useChatInbox(opts?: { escuchar?: boolean }) {
  const { rol } = useAuthStore()
  const habilitado = rol === 'gerente' || rol === 'recepcion' || rol === 'marketing'
  const queryClient = useQueryClient()
  const navigate = useNavigate()
  const vistoRef = useRef<Set<string>>(new Set())

  const query = useQuery({
    queryKey: ['chat-inbox'],
    queryFn: fetchInboxChats,
    enabled: habilitado,
    refetchInterval: 20_000,
  })

  useEffect(() => {
    if (!habilitado || !opts?.escuchar) return
    void pedirPermisoNotificaciones()

    const canal = supabase
      .channel('admin-chat-inbox')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'chats' }, () => {
        void queryClient.invalidateQueries({ queryKey: ['chat-inbox'] })
      })
      .on(
        'postgres_changes',
        { event: 'INSERT', schema: 'public', table: 'chat_mensajes' },
        payload => {
          const msg = payload.new as ChatMensaje
          void queryClient.invalidateQueries({ queryKey: ['chat-inbox'] })
          void queryClient.invalidateQueries({ queryKey: ['chat-mensajes', msg.chat_id] })

          if (msg.rol !== 'huesped') return
          if (vistoRef.current.has(msg.id)) return
          vistoRef.current.add(msg.id)

          const inbox = queryClient.getQueryData<Awaited<ReturnType<typeof fetchInboxChats>>>(['chat-inbox'])
          const hab = inbox?.find(c => c.id === msg.chat_id)
          const titulo = hab ? `Habitación ${hab.numero}` : 'Nuevo mensaje'
          const cuerpo = msg.tipo === 'imagen'
            ? 'Envió una foto'
            : msg.tipo === 'audio'
              ? 'Envió un audio'
              : (msg.contenido || 'Nuevo mensaje')

          sonarAviso()
          mostrarNotificacion({
            titulo,
            cuerpo,
            tag: `chat-${msg.chat_id}`,
            onClick: () => navigate(`/admin/conversaciones?hab=${hab?.habitacion_id ?? ''}`),
          })
        },
      )
      .subscribe()

    return () => {
      void supabase.removeChannel(canal)
    }
  }, [habilitado, navigate, queryClient, opts?.escuchar])

  const noLeidos = (query.data ?? []).reduce((s, c) => s + (c.no_leidos_admin ?? 0), 0)

  return { ...query, noLeidos, habilitado }
}
