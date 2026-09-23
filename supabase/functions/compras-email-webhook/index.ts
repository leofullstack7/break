// supabase/functions/compras-email-webhook/index.ts
//
// Webhook Resend inbound (email.received).
// Filtra asuntos con "facturación" / filtro configurable, descarga adjuntos
// ZIP/XML y los mete en compras_inbox.
//
// Config Resend:
//   1. Activar Receiving en el dominio
//   2. Webhook → esta URL, evento email.received
//   3. Secret RESEND_WEBHOOK_SECRET (Svix) opcional pero recomendado
//
// verify_jwt = false (firma propia Resend/Svix)

import { asuntoEsFacturacion, guardarCompraDesdeBytes } from "../_shared/compras-inbox.ts";
import { logSync } from "../_shared/supabase-admin.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, svix-id, svix-timestamp, svix-signature",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });
}

interface ResendReceivedEvent {
  type?: string;
  created_at?: string;
  data?: {
    email_id?: string;
    created_at?: string;
    from?: string;
    to?: string[];
    subject?: string;
    attachments?: Array<{
      id: string;
      filename?: string;
      content_type?: string;
    }>;
  };
}

async function verificarFirmaSvix(req: Request, rawBody: string): Promise<boolean> {
  const secret = Deno.env.get("RESEND_WEBHOOK_SECRET");
  if (!secret) return true; // sin secret configurado: aceptar (dev)

  const id = req.headers.get("svix-id");
  const ts = req.headers.get("svix-timestamp");
  const sig = req.headers.get("svix-signature");
  if (!id || !ts || !sig) return false;

  // secret viene como whsec_BASE64
  const keyB64 = secret.startsWith("whsec_") ? secret.slice(6) : secret;
  const keyBytes = Uint8Array.from(atob(keyB64), (c) => c.charCodeAt(0));
  const toSign = new TextEncoder().encode(`${id}.${ts}.${rawBody}`);
  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    keyBytes,
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const mac = await crypto.subtle.sign("HMAC", cryptoKey, toSign);
  const digest = btoa(String.fromCharCode(...new Uint8Array(mac)));

  // svix-signature: "v1,xxx v1,yyy"
  const candidates = sig.split(" ").map((p) => p.replace(/^v1,/, "").trim());
  return candidates.some((c) => c === digest);
}

async function listAttachments(emailId: string): Promise<Array<{
  id: string;
  filename?: string;
  content_type?: string;
  download_url?: string;
}>> {
  const key = Deno.env.get("RESEND_API_KEY");
  if (!key) throw new Error("Falta RESEND_API_KEY");

  const res = await fetch(
    `https://api.resend.com/emails/receiving/${emailId}/attachments`,
    { headers: { Authorization: `Bearer ${key}` } },
  );
  if (!res.ok) {
    throw new Error(`Resend attachments ${res.status}: ${(await res.text()).slice(0, 300)}`);
  }
  const body = await res.json();
  return body.data ?? [];
}

function esAdjuntoFactura(filename?: string, contentType?: string): boolean {
  const n = (filename || "").toLowerCase();
  const t = (contentType || "").toLowerCase();
  return (
    n.endsWith(".zip") ||
    n.endsWith(".xml") ||
    t.includes("zip") ||
    t.includes("xml")
  );
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ ok: false, error: "Método no permitido" }, 405);

  const rawBody = await req.text();
  const firmaOk = await verificarFirmaSvix(req, rawBody);
  if (!firmaOk) return json({ ok: false, error: "Firma webhook inválida" }, 401);

  let event: ResendReceivedEvent;
  try {
    event = JSON.parse(rawBody);
  } catch {
    return json({ ok: false, error: "JSON inválido" }, 400);
  }

  if (event.type !== "email.received") {
    return json({ ok: true, ignored: true, reason: "evento no relevante" });
  }

  const data = event.data ?? {};
  const subject = data.subject ?? "";
  const emailId = data.email_id;

  if (!asuntoEsFacturacion(subject)) {
    await logSync({
      integracion: "siigo",
      evento: "compras_email_ignorado",
      estado: "ok",
      detalle: { subject, emailId, reason: "asunto sin facturación" },
    });
    return json({ ok: true, ignored: true, reason: "asunto no coincide" });
  }

  if (!emailId) return json({ ok: false, error: "Sin email_id" }, 400);

  try {
    const attachments = await listAttachments(emailId);
    const facturas = attachments.filter((a) => esAdjuntoFactura(a.filename, a.content_type));

    if (facturas.length === 0) {
      // Crear ítem pendiente sin archivo para que staff suba el ZIP a mano
      const { getSupabaseAdmin } = await import("../_shared/supabase-admin.ts");
      const sb = getSupabaseAdmin();
      const { data: row, error } = await sb.from("compras_inbox").insert({
        origen: "email",
        estado: "pendiente",
        email_id: emailId,
        email_from: data.from ?? null,
        email_subject: subject,
        email_recibido_at: data.created_at ?? event.created_at ?? new Date().toISOString(),
        parse_error: "Correo de facturación sin adjunto ZIP/XML — subir manualmente",
        notas: `Para: ${(data.to ?? []).join(", ")}`,
      }).select("id").single();
      if (error && error.code !== "23505") throw error;

      return json({
        ok: true,
        email_id: emailId,
        creados: row ? 1 : 0,
        sin_adjunto: true,
        id: row?.id,
      });
    }

    const creados: unknown[] = [];
    for (const att of facturas) {
      if (!att.download_url) {
        // Re-fetch single attachment if list didn't include URL
        const key = Deno.env.get("RESEND_API_KEY")!;
        const r = await fetch(
          `https://api.resend.com/emails/receiving/${emailId}/attachments/${att.id}`,
          { headers: { Authorization: `Bearer ${key}` } },
        );
        const j = await r.json();
        att.download_url = j.download_url;
      }
      if (!att.download_url) continue;

      const fileRes = await fetch(att.download_url);
      if (!fileRes.ok) continue;
      const bytes = new Uint8Array(await fileRes.arrayBuffer());
      const saved = await guardarCompraDesdeBytes({
        bytes,
        nombre: att.filename || `factura-${att.id}.zip`,
        mime: att.content_type || "application/zip",
        origen: "email",
        email: {
          email_id: emailId,
          email_from: data.from,
          email_subject: subject,
          email_recibido_at: data.created_at ?? event.created_at,
        },
      });
      creados.push(saved);
    }

    await logSync({
      integracion: "siigo",
      evento: "compras_email_recibido",
      referencia_id: emailId,
      estado: "ok",
      detalle: { subject, from: data.from, creados },
    });

    return json({ ok: true, email_id: emailId, creados });
  } catch (err) {
    await logSync({
      integracion: "siigo",
      evento: "compras_email_recibido",
      referencia_id: emailId,
      estado: "error",
      detalle: { message: String(err), subject },
    });
    return json({ ok: false, error: String(err) }, 500);
  }
});
