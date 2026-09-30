/** PDF Break: cabecera dorada, títulos en negrita y viñetas. WinAnsi. */

export type PdfBlock =
  | { kind: 'meta'; kicker: string; title: string; sub: string }
  | { kind: 'section'; title: string }
  | { kind: 'kpi'; items: { label: string; value: string }[] }
  | { kind: 'p'; text: string }
  | { kind: 'li'; text: string; strong?: boolean }
  | { kind: 'gap' }

const WIN: Record<string, number> = {
  'Á': 0xC1, 'É': 0xC9, 'Í': 0xCD, 'Ó': 0xD3, 'Ú': 0xDA, 'Ñ': 0xD1, 'Ü': 0xDC,
  'á': 0xE1, 'é': 0xE9, 'í': 0xED, 'ó': 0xF3, 'ú': 0xFA, 'ñ': 0xF1, 'ü': 0xFC,
  '¿': 0xBF, '¡': 0xA1, '°': 0xB0, '—': 0x97, '–': 0x96, '•': 0x95,
}

function pdfStr(raw: string): string {
  let out = '('
  for (const ch of raw) {
    if (ch === '(') out += '\\('
    else if (ch === ')') out += '\\)'
    else if (ch === '\\') out += '\\\\'
    else if (ch === '\n') out += ' '
    else {
      const code = WIN[ch] ?? ch.charCodeAt(0)
      if (code < 32 || code > 126) out += `\\${code.toString(8).padStart(3, '0')}`
      else out += ch
    }
  }
  return out + ')'
}

function wrap(text: string, max: number): string[] {
  if (!text) return ['']
  const words = text.split(/\s+/)
  const lines: string[] = []
  let cur = ''
  for (const w of words) {
    const next = cur ? `${cur} ${w}` : w
    if (next.length > max) {
      if (cur) lines.push(cur)
      cur = w
    } else cur = next
  }
  if (cur) lines.push(cur)
  return lines
}

export function buildBreakPdf(blocks: PdfBlock[]): Uint8Array {
  type Op = { y: number; cmd: string }
  const pages: Op[][] = []
  let ops: Op[] = []
  let y = 690

  const newPage = () => {
    if (ops.length) pages.push(ops)
    ops = []
    y = 690
  }

  const need = (h: number) => {
    if (y - h < 64) newPage()
  }

  for (const b of blocks) {
    if (b.kind === 'meta') {
      need(78)
      ops.push({ y, cmd: `MARK_KICKER ${b.kicker}` })
      y -= 22
      ops.push({
        y,
        cmd: `0.05 0.05 0.05 rg /F2 20 Tf ${pdfStr(b.title)} Tj`,
      })
      y -= 22
      ops.push({
        y,
        cmd: `/F1 10 Tf 0.35 0.35 0.35 rg ${pdfStr(b.sub)} Tj`,
      })
      y -= 12
      ops.push({ y, cmd: 'MARK_RULE' })
      y -= 22
      continue
    }
    if (b.kind === 'section') {
      need(36)
      y -= 8
      ops.push({
        y,
        cmd: 'MARK_SECTION ' + b.title,
      })
      y -= 26
      continue
    }
    if (b.kind === 'kpi') {
      need(46)
      const col = 168
      b.items.slice(0, 3).forEach((it, i) => {
        const x = 48 + i * col
        ops.push({
          y,
          cmd: `MARK_KPI ${x} ${it.label}|||${it.value}`,
        })
      })
      y -= 48
      continue
    }
    if (b.kind === 'p') {
      for (const line of wrap(b.text, 86)) {
        need(16)
        ops.push({ y, cmd: `/F1 10 Tf 0.12 0.12 0.12 rg ${pdfStr(line)} Tj` })
        y -= 15
      }
      y -= 6
      continue
    }
    if (b.kind === 'li') {
      for (const [i, line] of wrap(b.text, 80).entries()) {
        need(16)
        const font = b.strong && i === 0 ? '/F2 11 Tf' : '/F1 10 Tf'
        const color = b.strong && i === 0 ? '0.25 0.18 0.04 rg' : '0.12 0.12 0.12 rg'
        const prefix = i === 0 ? '•  ' : '    '
        ops.push({
          y,
          cmd: `${font} ${color} ${pdfStr(prefix + line)} Tj`,
        })
        y -= 15
      }
      y -= 4
      continue
    }
    y -= 10
  }
  if (ops.length) pages.push(ops)
  if (!pages.length) pages.push([])

  const kids: string[] = []
  const objects: string[] = [
    '1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj',
    'PLACEHOLDER_PAGES',
    '3 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >> endobj',
    '4 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >> endobj',
  ]

  const pageObjIds: number[] = []
  const contentObjIds: number[] = []

  for (let i = 0; i < pages.length; i++) {
    const stream = pageStream(pages[i], i, pages.length)
    const contentId = objects.length + 1
    objects.push(`${contentId} 0 obj << /Length ${stream.length} >> stream\n${stream}\nendstream endobj`)
    contentObjIds.push(contentId)
    const pageId = objects.length + 1
    objects.push(
      `${pageId} 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents ${contentId} 0 R /Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> >> endobj`,
    )
    pageObjIds.push(pageId)
    kids.push(`${pageId} 0 R`)
  }

  objects[1] = `2 0 obj << /Type /Pages /Kids [${kids.join(' ')}] /Count ${pages.length} >> endobj`

  let body = '%PDF-1.4\n'
  const offsets = [0]
  for (const obj of objects) {
    offsets.push(lengthUtf8(body))
    body += obj + '\n'
  }
  const xrefPos = lengthUtf8(body)
  let xref = `xref\n0 ${objects.length + 1}\n0000000000 65535 f \n`
  for (let i = 1; i <= objects.length; i++) {
    xref += `${String(offsets[i]).padStart(10, '0')} 00000 n \n`
  }
  body += xref
  body += `trailer << /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xrefPos}\n%%EOF`
  return new TextEncoder().encode(body)
}

function lengthUtf8(s: string): number {
  return new TextEncoder().encode(s).length
}

function pageStream(ops: { y: number; cmd: string }[], pageIndex: number, total: number): string {
  const parts: string[] = [
    '0.79 0.64 0.16 rg',
    '0 748 612 44 re f',
    '0.05 0.05 0.05 rg',
    '0 0 612 36 re f',
    'BT',
    '/F2 18 Tf',
    '1 1 1 rg',
    '48 762 Td',
    `${pdfStr('BREAK')} Tj`,
    '/F1 9 Tf',
    '360 0 Td',
    `${pdfStr('Hotel boutique  ·  Manizales')} Tj`,
    'ET',
    'BT',
    '/F1 8 Tf',
    '1 1 1 rg',
    `48 16 Td`,
    `${pdfStr(`La pausa también es estrategia   ·   pág. ${pageIndex + 1} de ${total}`)} Tj`,
    'ET',
  ]

  for (const op of ops) {
    if (op.cmd === 'MARK_RULE') {
      parts.push('0.79 0.64 0.16 rg', `48 ${op.y} 120 2.5 re f`)
      continue
    }
    if (op.cmd.startsWith('MARK_KICKER ')) {
      const kicker = op.cmd.slice(12)
      parts.push(
        '0.79 0.64 0.16 rg',
        `48 ${op.y - 6} 86 18 re f`,
        'BT',
        '/F2 8 Tf',
        '1 1 1 rg',
        `56 ${op.y} Td`,
        `${pdfStr(kicker.toUpperCase())} Tj`,
        'ET',
      )
      continue
    }
    if (op.cmd.startsWith('MARK_SECTION ')) {
      const title = op.cmd.slice(13)
      parts.push(
        '0.79 0.64 0.16 rg',
        `48 ${op.y - 4} 4 16 re f`,
        '0.96 0.90 0.70 rg',
        `56 ${op.y - 6} 508 20 re f`,
        'BT',
        '/F2 11 Tf',
        '0.25 0.18 0.04 rg',
        `64 ${op.y} Td`,
        `${pdfStr(title.toUpperCase())} Tj`,
        'ET',
      )
      continue
    }
    if (op.cmd.startsWith('MARK_KPI ')) {
      const rest = op.cmd.slice(9)
      const sp = rest.indexOf(' ')
      const x = Number(rest.slice(0, sp))
      const [label, value] = rest.slice(sp + 1).split('|||')
      parts.push(
        '0.97 0.95 0.88 rg',
        `${x} ${op.y - 28} 156 40 re f`,
        'BT',
        '/F2 14 Tf',
        '0.79 0.64 0.16 rg',
        `${x + 10} ${op.y - 4} Td`,
        `${pdfStr(value)} Tj`,
        '/F1 8 Tf',
        '0.35 0.35 0.35 rg',
        `0 -14 Td`,
        `${pdfStr(label)} Tj`,
        'ET',
      )
      continue
    }
    parts.push('BT', `/F1 10 Tf 48 ${op.y} Td`, op.cmd, 'ET')
  }
  return parts.join('\n')
}
