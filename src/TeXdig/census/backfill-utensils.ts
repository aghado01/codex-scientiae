/**
 * TeXdig backfill instrument — latex-utensils.latexParser as the third rung
 * of the recovery ladder.
 *
 * unified-latex reparses alignment environments (eqnarray, align, array,
 * cases…) with positions in a LOCAL frame, so their interiors degrade to
 * lexical-only sites. latex-utensils' pegjs parser tracks GLOBAL positions on
 * every node, including dedicated subscript/superscript nodes — so a
 * lexical-only site whose name latex-utensils independently confirms at the
 * same offset becomes a genuinely two-witness agreed entity: lexical position
 * + typed parser confirmation, each from a separate instrument.
 *
 * The backfill only ever UPGRADES: it runs after reconciliation, touches
 * nothing that already agreed, and a failed utensils parse leaves the honest
 * lexical-only degradation in place with a named diagnostic.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { CensusEntity, Diagnostic, SourceId } from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import type { Dependencies } from "../core/loader.ts";

export interface UtensilsIndex {
  parsed: boolean;
  /** Control-sequence-like sites by start offset: commands, scripts, linebreaks. */
  csByStart: Map<number, { name: string; endUtf16: number }>;
  /** Environments by their begin-fence start offset. */
  envByStart: Map<number, { name: string; endUtf16: number }>;
}

export function buildUtensilsIndex(
  sourceId: SourceId,
  text: string,
  deps: Dependencies
): { index: UtensilsIndex; diagnostic?: Diagnostic } {
  const index: UtensilsIndex = {
    parsed: false,
    csByStart: new Map(),
    envByStart: new Map(),
  };

  let ast: any;
  try {
    ast = deps.utensils.latexParser.parse(text, { timeout: 30000 });
  } catch (err: any) {
    return {
      index,
      diagnostic: {
        code: DiagnosticCodes.BackfillUnavailable,
        severity: "info",
        message: `latex-utensils could not parse '${sourceId}' (${err?.message || err}); lexical-only sites stay single-witness`,
        sourceId,
        witness: "parser",
      },
    };
  }
  index.parsed = true;

  const seen = new Set<any>();
  function record(node: any) {
    const loc = node.location;
    if (!loc || !loc.start || !loc.end) return;
    const start = loc.start.offset;
    const end = loc.end.offset;
    const kind = String(node.kind || "");

    if (kind.startsWith("command") && typeof node.name === "string") {
      const tokenText = `\\${node.name}`;
      const tokenEnd = text.startsWith(tokenText, start) ? start + tokenText.length : end;
      index.csByStart.set(start, { name: node.name, endUtf16: tokenEnd });
    } else if (kind === "subscript") {
      index.csByStart.set(start, { name: "_", endUtf16: end });
    } else if (kind === "superscript") {
      index.csByStart.set(start, { name: "^", endUtf16: end });
    } else if (kind === "linebreak") {
      index.csByStart.set(start, { name: "\\", endUtf16: end });
    } else if (kind.startsWith("env") && typeof node.name === "string") {
      index.envByStart.set(start, { name: node.name, endUtf16: end });
    }
  }

  function walk(value: any) {
    if (value === null || typeof value !== "object") return;
    if (seen.has(value)) return;
    seen.add(value);
    if (Array.isArray(value)) {
      for (const item of value) walk(item);
      return;
    }
    if (typeof value.kind === "string") record(value);
    for (const key of Object.keys(value)) {
      if (key === "location") continue;
      walk(value[key]);
    }
  }
  walk(ast.content);

  return { index };
}

/**
 * Upgrade lexical-only entities the utensils index independently confirms.
 * Returns the surviving diagnostics (disagreement rows for upgraded entities
 * are withdrawn — the disagreement no longer exists).
 */
export function backfillLexicalOnly(
  entities: CensusEntity[],
  diagnostics: Diagnostic[],
  index: UtensilsIndex
): { diagnostics: Diagnostic[]; upgraded: number } {
  if (!index.parsed) return { diagnostics, upgraded: 0 };

  const upgradedIds = new Set<string>();
  for (const entity of entities) {
    if (entity.agreement !== "lexical-only") continue;

    let hit: { name: string; endUtf16: number } | undefined;
    let expected = "";
    if (entity.kind === "macro-invocation") {
      hit = index.csByStart.get(entity.span.startUtf16);
      expected = entity.name;
    } else if (entity.kind === "environment") {
      hit = index.envByStart.get(entity.span.startUtf16);
      expected = entity.name;
    } else {
      continue;
    }

    if (!hit || hit.name !== expected || hit.endUtf16 !== entity.span.endUtf16) continue;
    entity.witnesses.push({
      witness: "parser",
      instrument: "latex-utensils",
      span: {
        sourceId: entity.span.sourceId,
        startUtf16: entity.span.startUtf16,
        endUtf16: hit.endUtf16,
      },
      spanRole: entity.kind === "environment" ? "construct" : "token",
      detail: `backfill:${hit.name}`,
    });
    entity.agreement = "agreed";
    entity.agreementBasis = "two-instrument";
    upgradedIds.add(entity.id);
  }

  if (upgradedIds.size === 0) return { diagnostics, upgraded: 0 };
  const remaining = diagnostics.filter(
    (d) =>
      !(d.code === DiagnosticCodes.WitnessDisagreement && d.entityId && upgradedIds.has(d.entityId))
  );
  return { diagnostics: remaining, upgraded: upgradedIds.size };
}
