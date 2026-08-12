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
  /** \let-alias chain walked from the site's name to the governing definition. */
  viaAliases?: string[];
  span: SourceSpan;
  /** Site position on the shared traversal order space. */
  seq: number;
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
  /** Definition position on the shared order space; -1 for pre-traversal (configured). */
  seq: number;
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
function countExpandable(nodes: any[], table: Map<string, unknown>): Map<string, number> {
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
  entities: CensusEntity[],
  seqByAddress: Map<string, number>
): { rows: ExpansionRecord[]; diagnostics: Diagnostic[] } {
  const rows: ExpansionRecord[] = [];
  const diagnostics: Diagnostic[] = [];

  const seqOf = (span: SourceSpan): number =>
    seqByAddress.get(`${span.sourceId}:${span.startUtf16}`) ?? -1;

  // Census indices: elaborable definitions by name (ALL of them — shadowing
  // resolves per site on the shared seq scale), \let aliases by name, and
  // invocations by source + start offset.
  const definitionsByName = new Map<string, (CensusEntity & { kind: "macro-definition" })[]>();
  const aliasTarget = new Map<string, { target: string; seq: number }[]>();
  const invocationByStart = new Map<SourceId, Map<number, CensusEntity & { kind: "macro-invocation" }>>();
  for (const ent of entities) {
    if (ent.kind === "macro-definition") {
      if (ent.elaborable && ent.dialect !== "configured") {
        const list = definitionsByName.get(ent.definedName) || [];
        list.push(ent);
        definitionsByName.set(ent.definedName, list);
      } else if (ent.dialect === "let" && ent.bodySpan) {
        // \let\alias\target: the body span IS the target token.
        const file = files.find((f) => f.sourceId === ent.bodySpan!.sourceId);
        if (file) {
          const targetSlice = file.rawText
            .slice(ent.bodySpan.startUtf16, ent.bodySpan.endUtf16)
            .trim();
          if (targetSlice.startsWith("\\")) {
            const list = aliasTarget.get(ent.definedName) || [];
            list.push({ target: targetSlice.slice(1), seq: seqOf(ent.span) });
            aliasTarget.set(ent.definedName, list);
          }
        }
      }
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
  const table = new Map<string, ExpansionTableEntry[]>();
  function addTableEntry(name: string, entry: ExpansionTableEntry) {
    const list = table.get(name) || [];
    list.push(entry);
    table.set(name, list);
  }

  for (const file of files) {
    let ast: any;
    try {
      ast = parser.parse(file.stratifiedText);
    } catch {
      continue; // the census already diagnosed this file's parse failure
    }
    asts.set(file.sourceId, ast);

    for (const spec of deps.macros.listNewcommands(ast)) {
      // Match this occurrence to ITS census definition entity by position —
      // redefinitions of one name are distinct entries on the seq scale.
      const defs = definitionsByName.get(spec.name);
      if (!defs) continue;
      const specStart = spec.definition?.position?.start?.offset;
      const def =
        defs.find(
          (d) => d.span.sourceId === file.sourceId && d.span.startUtf16 === specStart
        ) ?? defs[defs.length - 1];
      addTableEntry(spec.name, {
        body: spec.body,
        definitionEntityId: def.id,
        seq: seqOf(def.span),
      });
    }
  }

  for (const [name, defs] of definitionsByName) {
    for (const def of defs) {
      if (def.dialect !== "math-operator" || !def.bodySpan) continue;
      const file = files.find((f) => f.sourceId === def.bodySpan!.sourceId);
      if (!file) continue;
      const bodySlice = file.rawText.slice(def.bodySpan.startUtf16, def.bodySpan.endUtf16);
      try {
        const fragment = parser.parse(`\\operatorname{${bodySlice}}`);
        addTableEntry(name, {
          body: fragment.content,
          definitionEntityId: def.id,
          seq: seqOf(def.span),
        });
      } catch {
        // Unparseable operator body: the definition stays census-only.
      }
    }
  }

  if (table.size === 0) return { rows, diagnostics };
  for (const list of table.values()) list.sort((a, b) => a.seq - b.seq);

  /** Governing entry for a name at a site position: latest definition strictly before it. */
  function governingEntry(name: string, siteSeq: number): ExpansionTableEntry | undefined {
    const list = table.get(name);
    if (!list) return undefined;
    let chosen: ExpansionTableEntry | undefined;
    for (const entry of list) {
      if (entry.seq < siteSeq) chosen = entry;
      else break;
    }
    return chosen;
  }

  /** Resolve a site name through \let-alias chains to a governing table entry. */
  function resolveSiteName(
    name: string,
    siteSeq: number
  ): { entry: ExpansionTableEntry; viaAliases: string[] } | undefined {
    const via: string[] = [];
    let current = name;
    for (let hop = 0; hop < 8; hop++) {
      const direct = governingEntry(current, siteSeq);
      if (direct) return { entry: direct, viaAliases: via };
      const aliases = aliasTarget.get(current);
      if (!aliases) return undefined;
      let chosen: { target: string; seq: number } | undefined;
      for (const a of aliases) {
        if (a.seq < siteSeq) chosen = a;
        else break;
      }
      if (!chosen || via.includes(current)) return undefined;
      via.push(current);
      current = chosen.target;
    }
    return undefined;
  }

  // Redefinition-free documents (the common case) share one substitution view;
  // documents with redefinitions build a per-site view.
  const hasRedefinitions = [...table.values()].some((l) => l.length > 1);
  const sharedBodies = hasRedefinitions
    ? null
    : [...table.entries()].map(([name, l]) => ({ name, body: l[0].body }));
  function bodiesForSite(siteSeq: number): { name: string; body: any[] }[] {
    if (sharedBodies) return sharedBodies;
    const out: { name: string; body: any[] }[] = [];
    for (const [name] of table) {
      const entry = governingEntry(name, siteSeq);
      if (entry) out.push({ name, body: entry.body });
    }
    return out;
  }

  for (const list of aliasTarget.values()) list.sort((a, b) => a.seq - b.seq);

  // -------------------------------------------------------------------------
  // Per-site expansion to a bounded fixed point over a clone. The governing
  // definition is resolved on the shared seq scale (shadowing), through
  // \let-alias chains where the site's name is an alias.
  // -------------------------------------------------------------------------
  for (const file of files) {
    const ast = asts.get(file.sourceId);
    if (!ast) continue;
    const invocations = invocationByStart.get(file.sourceId);
    if (!invocations) continue;

    walkMacroNodes(ast.content, (node) => {
      const name = typeof node.content === "string" ? node.content : "";
      if (!table.has(name) && !aliasTarget.has(name)) return;
      const start = node.position?.start?.offset;
      if (start === undefined) return; // untrusted/positionless: no census site to chain to
      const invocation = invocations.get(start);
      if (!invocation) return; // definition name tokens etc.

      const siteSeq = seqOf(invocation.span);
      const resolved = resolveSiteName(name, siteSeq);
      if (!resolved) return; // no governing definition before this site
      const { entry, viaAliases } = resolved;

      // Site-level containment: a toolkit failure on one site is that SITE's
      // finding, never the worker's death.
      let holder: { type: string; content: any[] };
      let rounds = 1;
      let remaining: Map<string, number>;
      let toolkitError: string | undefined;
      try {
        const expander = deps.macros.createMacroExpander(entry.body);
        holder = { type: "root", content: expander(structuredClone(node)) };
        const siteBodies = bodiesForSite(siteSeq);
        remaining = countExpandable(holder.content, table);
        while (remaining.size > 0 && rounds < MAX_ROUNDS) {
          const before = [...remaining.entries()].map(([n, c]) => `${n}:${c}`).join(",");
          deps.macros.expandMacrosExcludingDefinitions(holder, siteBodies);
          rounds++;
          remaining = countExpandable(holder.content, table);
          const after = [...remaining.entries()].map(([n, c]) => `${n}:${c}`).join(",");
          if (after === before) break; // no progress: unexpandable interior
        }
      } catch (err: any) {
        toolkitError = err?.message || String(err);
        holder = { type: "root", content: [] };
        remaining = new Map([[name, 1]]);
      }

      const expandedText = toolkitError
        ? file.rawText.slice(invocation.span.startUtf16, invocation.span.endUtf16)
        : deps.printRaw.printRaw(holder.content);
      const unexpanded = [...remaining.keys()].sort();
      const danglingParameter = !toolkitError && /#\d/.test(expandedText);
      const status: ExpansionRecord["status"] =
        !toolkitError && rounds >= MAX_ROUNDS && remaining.size > 0
          ? "non-converging"
          : toolkitError || remaining.size > 0 || danglingParameter
            ? "partial"
            : "expanded";

      const id = `exp:${invocation.span.sourceId}:${invocation.span.startUtf16}-${invocation.span.endUtf16}`;
      rows.push({
        id,
        entityId: invocation.id,
        definitionEntityId: entry.definitionEntityId,
        definedName: name,
        viaAliases: viaAliases.length > 0 ? viaAliases : undefined,
        span: invocation.span,
        seq: siteSeq,
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
          message: toolkitError
            ? `Expansion of \\${name} failed in the substitution toolkit (${toolkitError}); site kept unexpanded`
            : danglingParameter
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
