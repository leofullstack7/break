// supabase/functions/_shared/compras-inbox.ts
// Helpers compartidos para guardar ZIP/XML en storage + fila compras_inbox.

import { getSupabaseAdmin } from "./supabase-admin.ts";
import { parseDianArchivo, type DianFacturaParseada } from "./dian-zip-parser.ts";

const BUCKET = "facturas-compra";

export function asuntoEsFacturacion(subject: string | null | undefined): boolean {
  const filtro = (Deno.env.get("COMPRAS_EMAIL_ASUNTO_FILTRO") || "facturacion")
    .toLowerCase()
    .normalize("NFD")
    .replace(/\p{M}/gu, "");
  const subj = (subject || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/\p{M}/gu, "");
  return subj.includes(filtro) || subj.includes("factura");
}

function aplicarParseo(
  row: Record<string, unknown>,
  parsed: DianFacturaParseada,
): Record<string, unknown> {
  const breakNit = Deno.env.get("BREAK_NIT")?.replace(/\D/g, "") || null;
  let parse_error: string | null = null;
  let estado = "listo";

  if (breakNit && parsed.receptor_nit && parsed.receptor_nit !== breakNit) {
    // Aviso, no bloqueamos: a veces el XML trae DV distinto
    parse_error = `Receptor XML (${parsed.receptor_nit}) ≠ BREAK_NIT (${breakNit})`;
  }
  if (!parsed.proveedor_nit || !parsed.fecha_factura) {
    estado = "error";
    parse_error = parse_error ||
      "XML incompleto: falta NIT proveedor o fecha";
  }

  return {
    ...row,
    estado,
    cufe: parsed.cufe,
    prefijo: parsed.prefijo,
    numero_factura: parsed.numero_factura,
    fecha_factura: parsed.fecha_factura,
    proveedor_nit: parsed.proveedor_nit,
    proveedor_nombre: parsed.proveedor_nombre,
    receptor_nit: parsed.receptor_nit,
    moneda: parsed.moneda,
    subtotal: parsed.subtotal,
    iva: parsed.iva,
    total: parsed.total,
    lineas: parsed.lineas,
    parse_error,
  };
}

export async function guardarCompraDesdeBytes(opts: {
  bytes: Uint8Array;
  nombre: string;
  mime: string;
  origen: "email" | "manual";
  email?: {
    email_id?: string;
    email_from?: string;
    email_subject?: string;
    email_recibido_at?: string;
  };
  creado_por?: string | null;
}): Promise<{ id: string; estado: string; parsed: DianFacturaParseada | null; error?: string }> {
  const supabase = getSupabaseAdmin();
  const stamp = Date.now();
  const safeName = opts.nombre.replace(/[^a-zA-Z0-9._-]/g, "_").slice(0, 80);
  const path = `${opts.origen}/${stamp}-${safeName}`;

  const { error: upErr } = await supabase.storage
    .from(BUCKET)
    .upload(path, opts.bytes, {
      contentType: opts.mime || "application/zip",
      upsert: false,
    });
  if (upErr) throw new Error(`Storage: ${upErr.message}`);

  let row: Record<string, unknown> = {
    origen: opts.origen,
    estado: "pendiente",
    archivo_nombre: opts.nombre,
    archivo_path: path,
    archivo_mime: opts.mime,
    archivo_bytes: opts.bytes.byteLength,
    email_id: opts.email?.email_id ?? null,
    email_from: opts.email?.email_from ?? null,
    email_subject: opts.email?.email_subject ?? null,
    email_recibido_at: opts.email?.email_recibido_at ?? null,
    creado_por: opts.creado_por ?? null,
  };

  let parsed: DianFacturaParseada | null = null;
  try {
    const result = await parseDianArchivo(opts.bytes, opts.mime || opts.nombre);
    parsed = result.parsed;

    // Guardar XML extraído
    const xmlPath = path.replace(/\.(zip|xml)$/i, "") + "-invoice.xml";
    await supabase.storage.from(BUCKET).upload(xmlPath, result.xmlBytes, {
      contentType: "application/xml",
      upsert: true,
    });
    row.xml_raw_path = xmlPath;
    row = aplicarParseo(row, parsed);

    // Dedup por CUFE
    if (parsed.cufe) {
      const { data: existing } = await supabase
        .from("compras_inbox")
        .select("id, estado")
        .eq("cufe", parsed.cufe)
        .maybeSingle();
      if (existing?.id) {
        return {
          id: existing.id,
          estado: existing.estado,
          parsed,
          error: "Ya existía una compra con este CUFE",
        };
      }
    }
  } catch (err) {
    row.estado = "error";
    row.parse_error = err instanceof Error ? err.message : String(err);
  }

  const { data, error } = await supabase
    .from("compras_inbox")
    .insert(row)
    .select("id, estado")
    .single();

  if (error) {
    // Colisión email_id
    if (error.code === "23505" && opts.email?.email_id) {
      const { data: ex } = await supabase
        .from("compras_inbox")
        .select("id, estado")
        .eq("email_id", opts.email.email_id)
        .maybeSingle();
      if (ex) return { id: ex.id, estado: ex.estado, parsed };
    }
    throw error;
  }

  return {
    id: data.id,
    estado: data.estado,
    parsed,
    error: row.parse_error as string | undefined,
  };
}
