/**
 * TeXdig elaboration: per-site macro expansion (expansion.jsonl).
 *
 * The census is mechanical and stays that way; THIS lane interprets. For every
 * invocation site of an elaborable in-document definition, the site's attached
 * arguments are substituted into the definition body and driven to a BOUNDED
 * FIXED POINT over a CLONE (the toolkit mutates), then serialized. Every row
 * is origin-chained to census ids — the invocation entity it expands and the
 * definition entity it expands THROUGH — satisfying gate 3 (closure).
 *
 * Doctrine notes:
 * - Source slices come from the raw stream as always. `expandedText` is
 *   DERIVED content with no raw stream to slice; printRaw is its only
 *   serializer, and that use is sanctioned (the printRaw ban protects source
 *   slices, not derived renderings).
 * - The audit is structural, never a printRaw-vs-source string compare:
 *   leftover expandable names and dangling parameter tokens are counted on
 *   the expanded AST/text and named per site.
 * - `\def`/`\let` dialects are detected-when-knowable and stay unexpanded by
 *   design; `configured` declarations carry no body. Neither enters the
 *   expansion table, so their sites simply produce no row here — the census
 *   already carries their evidence.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type {
  CensusEntity,
  Diagnostic,
  SourceId,
  SourceSpan,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import type { Dependencies } from "../core/loader.ts";
import type { SignatureRegistry } from "../census/parse-latex.ts";

export const EXPANSION_SCHEMA_VERSION = "texdig-expansion/0.1" as const;

/** Fixed-point bound: real chains are shallow; hitting this means recursion. */
const MAX_ROUNDS = 25;

export interface ExpansionRecord {
  id: string; // exp:{sourceId}:{startUtf16}-{endUtf16}
  /** Census macro-invocation entity this row expands (origin). */
  entityId: string;
  /** Census macro-definition entity it expands through (origin). */
  definitionEntityId: string;
  definedName: string;
  span: SourceSpan;
  /** Exact raw slice of the invocation site (hull extent). */
  sourceSlice: string;
  /** Derived: the site driven to fixed point, serialized via printRaw. */
  expandedText: string;
  rounds: number;
  status: "expanded" | "partial" | "non-converging";
  /** Expandable names still present when status is not `expanded`. */
  unexpanded: string[];
}

export interface ExpandDocumentInput {
  sourceId: SourceId;
  stratifiedText: string;
  rawText: string;
}

interface ExpansionTableEntry {
  body: any[];
  definitionEntityId: string;
}

// Definition-forming commands whose arguments the audit and site walk must
// not descend into: a body or name inside a definition is a mention.
const DEFINITION_COMMANDS = new Set([
  "newcommand",
  "renewcommand",
  "providecommand",
  "NewDocumentCommand",
  "RenewDocumentCommand",
  "ProvideDocumentCommand",
  "DeclareMathOperator",
  "DeclarePairedDelimiter",
  "newenvironment",
  "renewenvironment",
  "newtheorem",
]);

function walkMacroNodes(
  nodes: any,
  visit: (node: any) => void
): void {
  if (!Array.isArray(nodes)) return;
  for (const n of nodes) {
    if (!n || typeof n !== "object") continue;
    if (n.type === "macro") {
      const name = typeof n.content === "string" ? n.content : "";
      visit(n);
      if (DEFINITION_COMMANDS.has(name)) continue; // do not descend into definition args
      if (Array.isArray(n.args)) {
        for (const a of n.args) walkMacroNodes(a.content, visit);
      }
      continue;
    }
    if (Array.isArray(n.content)) walkMacroNodes(n.content, visit);
    if (Array.isArray(n.args)) {
      for (const a of n.args) walkMacroNodes(a.content, visit);
    }
  }
}

/** Count remaining occurrences of expandable names outside definition args. */
function countExpandable(nodes: any[], table: Map<string, ExpansionTableEntry>): Map<string, number> {
  const counts = new Map<string, number>();
  walkMacroNodes(nodes, (n) => {
    const name = typeof n.content === "string" ? n.content : "";
    if (table.has(name)) counts.set(name, (counts.get(name) || 0) + 1);
  });
  return counts;
}

export function expandDocument(
  files: ExpandDocumentInput[],
  deps: Dependencies,
  registry: SignatureRegistry,
  entities: CensusEntity[]
): { rows: ExpansionRecord[]; diagnostics: Diagnostic[] } {
  const rows: ExpansionRecord[] = [];
  const diagnostics: Diagnostic[] = [];

  // Census indices: definitions by name (elaborable only), invocations by
  // source + start offset. The document's own definition always wins over any
  // duplicate (last definition in entity order — shadowing proper is cut 2).
  const definitionByName = new Map<string, CensusEntity & { kind: "macro-definition" }>();
  const invocationByStart = new Map<SourceId, Map<number, CensusEntity & { kind: "macro-invocation" }>>();
  for (const ent of entities) {
    if (ent.kind === "macro-definition" && ent.elaborable && ent.dialect !== "configured") {
      definitionByName.set(ent.definedName, ent);
    } else if (ent.kind === "macro-invocation") {
      let bySource = invocationByStart.get(ent.span.sourceId);
      if (!bySource) {
        bySource = new Map();
        invocationByStart.set(ent.span.sourceId, bySource);
      }
      bySource.set(ent.span.startUtf16, ent);
    }
  }

  // -------------------------------------------------------------------------
  // Expansion table: substitution bodies as ASTs.
  //  - newcommand family + xparse: bodies via listNewcommands on each file's
  //    registry-parse (argument attachment inside bodies comes free).
  //  - math-operator: synthesized `\operatorname{<body slice>}` — that IS the
  //    definition's meaning and the slice is raw-stream evidence.
  //  - paired-delimiter: no faithful argument-free body form; stays out.
  // -------------------------------------------------------------------------
  const parser = deps.parse.getParser({
    macros: registry.macros,
    environments: registry.environments,
  });

  const asts = new Map<SourceId, any>();
  const table = new Map<string, ExpansionTableEntry>();

  for (const file of files) {
    let ast: any;
    try {
      ast = parser.parse(file.stratifiedText);
    } catch {
      continue; // the census already diagnosed this file's parse failure
    }
    asts.set(file.sourceId, ast);

    for (const spec of deps.macros.listNewcommands(ast)) {
      const def = definitionByName.get(spec.name);
      if (!def) continue; // e.g. definitions the census excluded
      table.set(spec.name, { body: spec.body, definitionEntityId: def.id });
    }
  }

  for (const [name, def] of definitionByName) {
    if (table.has(name)) continue;
    if (def.dialect !== "math-operator" || !def.bodySpan) continue;
    const file = files.find((f) => f.sourceId === def.bodySpan!.sourceId);
    if (!file) continue;
    const bodySlice = file.rawText.slice(def.bodySpan.startUtf16, def.bodySpan.endUtf16);
    try {
      const fragment = parser.parse(`\\operatorname{${bodySlice}}`);
      table.set(name, { body: fragment.content, definitionEntityId: def.id });
    } catch {
      // Unparseable operator body: the definition stays census-only.
    }
  }

  if (table.size === 0) return { rows, diagnostics };
  const allBodies = [...table.entries()].map(([name, e]) => ({ name, body: e.body }));

  // -------------------------------------------------------------------------
  // Per-site expansion to a bounded fixed point over a clone.
  // -------------------------------------------------------------------------
  for (const file of files) {
    const ast = asts.get(file.sourceId);
    if (!ast) continue;
    const invocations = invocationByStart.get(file.sourceId);
    if (!invocations) continue;

    walkMacroNodes(ast.content, (node) => {
      const name = typeof node.content === "string" ? node.content : "";
      const entry = table.get(name);
      if (!entry) return;
      const start = node.position?.start?.offset;
      if (start === undefined) return; // untrusted/positionless: no census site to chain to
      const invocation = invocations.get(start);
      if (!invocation) return; // definition name tokens etc.

      const expander = deps.macros.createMacroExpander(entry.body);
      const seed: any[] = expander(structuredClone(node));
      const holder = { type: "root", content: seed };

      let rounds = 1;
      let remaining = countExpandable(holder.content, table);
      while (remaining.size > 0 && rounds < MAX_ROUNDS) {
        const before = [...remaining.entries()].map(([n, c]) => `${n}:${c}`).join(",");
        deps.macros.expandMacrosExcludingDefinitions(holder, allBodies);
        rounds++;
        remaining = countExpandable(holder.content, table);
        const after = [...remaining.entries()].map(([n, c]) => `${n}:${c}`).join(",");
        if (after === before) break; // no progress: unexpandable interior
      }

      const expandedText = deps.printRaw.printRaw(holder.content);
      const unexpanded = [...remaining.keys()].sort();
      const danglingParameter = /#\d/.test(expandedText);
      const status: ExpansionRecord["status"] =
        rounds >= MAX_ROUNDS && remaining.size > 0
          ? "non-converging"
          : remaining.size > 0 || danglingParameter
            ? "partial"
            : "expanded";

      const id = `exp:${invocation.span.sourceId}:${invocation.span.startUtf16}-${invocation.span.endUtf16}`;
      rows.push({
        id,
        entityId: invocation.id,
        definitionEntityId: entry.definitionEntityId,
        definedName: name,
        span: invocation.span,
        sourceSlice: file.rawText.slice(invocation.span.startUtf16, invocation.span.endUtf16),
        expandedText,
        rounds,
        status,
        unexpanded,
      });

      if (status === "non-converging") {
        diagnostics.push({
          code: DiagnosticCodes.ExpansionNonConverging,
          severity: "defect",
          message: `Expansion of \\${name} did not reach a fixed point within ${MAX_ROUNDS} rounds (remaining: ${unexpanded.join(", ")})`,
          span: invocation.span,
          entityId: invocation.id,
        });
      } else if (status === "partial") {
        diagnostics.push({
          code: DiagnosticCodes.ExpansionIncomplete,
          severity: "warning",
          message: danglingParameter
            ? `Expansion of \\${name} left dangling parameter tokens`
            : `Expansion of \\${name} stalled with expandable names remaining: ${unexpanded.join(", ")}`,
          span: invocation.span,
          entityId: invocation.id,
        });
      }
    });
  }

  return { rows, diagnostics };
}
