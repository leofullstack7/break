import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { VitePWA } from 'vite-plugin-pwa'
import path from 'path'

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      // manifest está en public/manifest.webmanifest — no generarlo desde aquí
      manifest: false,
      workbox: {
        // Cachear assets estáticos agresivamente
        globPatterns: ['**/*.{js,css,html,ico,png,svg,woff2}'],
        // No cachear llamadas a Supabase — siempre fresh
        navigateFallbackDenylist: [/^\/api/, /^\/rest/, /^\/auth/],
        runtimeCaching: [
          {
            urlPattern: /^https:\/\/.*\.supabase\.co\/.*/i,
            handler: 'NetworkFirst',
            options: {
              cacheName: 'supabase-cache',
              expiration: { maxEntries: 50, maxAgeSeconds: 60 },
            },
          },
        ],
      },
    }),
  ],
  resolve: {
    alias: {
      // @ apunta a /src — todos los agentes usan este alias
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    port: 5173,
    open: true,
  },
  build: {
    // Alerta si un chunk supera 500KB
    chunkSizeWarningLimit: 500,
    rollupOptions: {
      output: {
        // Separar Three.js en su propio chunk (es muy pesado)
        manualChunks: {
          'vendor-react': ['react', 'react-dom', 'react-router-dom'],
          'vendor-supabase': ['@supabase/supabase-js'],
          'vendor-query': ['@tanstack/react-query'],
          'vendor-motion': ['framer-motion'],
        },
      },
    },
  },
})
