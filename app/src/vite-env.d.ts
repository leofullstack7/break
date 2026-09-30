/// <reference types="vite/client" />

declare module 'pdfjs-dist/build/pdf.worker.min.mjs?url' {
  const src: string
  export default src
}

interface ImportMetaEnv {
  readonly VITE_SUPABASE_URL: string
  readonly VITE_SUPABASE_ANON_KEY: string
  readonly VITE_APP_URL?: string
  readonly VITE_APP_NAME?: string
  readonly VITE_GOOGLE_REVIEW_URL?: string
  readonly VITE_PXSOL_CONVERSACIONES_URL?: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

interface WindowEventMap {
  'vite:preloadError': Event
}
