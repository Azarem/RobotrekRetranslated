import { readdirSync, readFileSync, writeFileSync, statSync, mkdirSync } from 'fs';
import path from 'path';

const SEPARATOR = '---------------------------------------';
const STRING_LINE_RE = /^(string_([0-9A-Fa-f]+)\s+`[\s\S]*?`)\s*$/;

type StringHit = {
  id: string;
  label: string;
  definition: string;
  actor: string;
  sourceFile: string;
};

function walkAsmFiles(dir: string, out: string[] = []): string[] {
  for (const entry of readdirSync(dir)) {
    const full = path.join(dir, entry);
    if (statSync(full).isDirectory()) {
      walkAsmFiles(full, out);
    } else if (entry.endsWith('.asm')) {
      out.push(full);
    }
  }
  return out;
}

function normalizeId(id: string): string {
  return id.replace(/^0x/i, '').toUpperCase().padStart(6, '0');
}

function buildStringIndex(extractedDir: string): Map<string, StringHit> {
  const index = new Map<string, StringHit>();

  for (const file of walkAsmFiles(extractedDir)) {
    const actor = path.basename(file, '.asm');
    const lines = readFileSync(file, 'utf8').split(/\r?\n/);

    for (const line of lines) {
      const match = line.match(STRING_LINE_RE);
      if (!match) continue;

      const id = normalizeId(match[2]);
      index.set(id, {
        id,
        label: `string_${id}`,
        definition: match[1],
        actor,
        sourceFile: file,
      });
    }
  }

  return index;
}

/** Emit strings in ID-list order; include each actor once before its first string. */
function formatChapter(hits: StringHit[]): string {
  const included = new Set<string>();
  const lines: string[] = [''];

  for (const hit of hits) {
    if (!included.has(hit.actor)) {
      if (included.size > 0) {
        lines.push('');
        lines.push(SEPARATOR);
      }
      lines.push(`?INCLUDE '${hit.actor}'`);
      lines.push(SEPARATOR);
      included.add(hit.actor);
    }
    lines.push(hit.definition);
  }

  lines.push('');
  return lines.join('\n');
}

export function extractChapter(options: {
  idsPath: string;
  extractedDir: string;
  outPath: string;
}): { found: number; missing: string[] } {
  const idsRaw = JSON.parse(readFileSync(options.idsPath, 'utf8')) as string[];
  if (!Array.isArray(idsRaw)) {
    throw new Error(`Expected an array of string IDs in ${options.idsPath}`);
  }

  const ids = idsRaw.map(normalizeId);
  const index = buildStringIndex(options.extractedDir);

  const hits: StringHit[] = [];
  const missing: string[] = [];

  for (const id of ids) {
    const hit = index.get(id);
    if (!hit) {
      missing.push(id);
      continue;
    }
    hits.push(hit);
  }

  const output = formatChapter(hits);

  mkdirSync(path.dirname(options.outPath), { recursive: true });
  writeFileSync(options.outPath, output, 'utf8');

  return { found: hits.length, missing };
}

const isMainModule =
  process.argv[1]?.includes('extract-chapter.ts') ||
  process.argv[1]?.includes('extract-chapter.js');

if (isMainModule) {
  const args = process.argv.slice(2);
  const idsPath = args[0] ?? 'scripts/chapter01_ids.json';
  const extractedDir = args[1] ?? 'extracted';
  const outPath = args[2] ?? 'modules/base/chapters/chapter_extracted.patch.asm';

  try {
    const result = extractChapter({ idsPath, extractedDir, outPath });
    console.log(`Wrote ${result.found} strings to ${outPath}`);
    if (result.missing.length) {
      console.error(`Missing ${result.missing.length} string(s): ${result.missing.join(', ')}`);
      process.exit(1);
    }
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}
