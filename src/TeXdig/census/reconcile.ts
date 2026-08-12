/**
 * TeXdig witness reconciliation and entity generator.
 *
 * Fuses lexical and parser sightings, synthesizes argument hulls for parser position gaps,
 * records agreement states and witness provenance, and mints deterministic census entities.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type {
  SourceId,
  SourceSpan,
  CensusEntity,
  WitnessRecord,
  AgreementState,
  SpanProvenance,
  Diagnostic,
  MathCarrier,
  EnvironmentRole,
  EnvelopeMarkerKind,
  IncludeDirective,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import type { LexicalSighting } from "./scan-latex.ts";
import type { ParseLatexResult } from "./parse-latex.ts";
import type { ParseBibResult } from "./parse-bib.ts";
import type { StratificationResult } from "./stratify.ts";
import type { BibLexicalSighting } from "./scan-bib.ts";

export interface ReconcileResult {
  sourceId: SourceId;
  entities: CensusEntity[];
  diagnostics: Diagnostic[];
}

function mintEntityId(kind: string, span: SourceSpan): string {
  return `ent:${kind}@${span.sourceId}:${span.startUtf16}-${span.endUtf16}`;
}

const KNOWN_FLOAT_ENVS = new Set(["figure", "figure*", "table", "table*", "algorithm"]);
const KNOWN_MATH_ENVS = new Set([
  "equation",
  "equation*",
  "align",
  "align*",
  "gather",
  "gather*",
  "multline",
  "multline*",
  "flalign",
  "flalign*",
  "split",
  "cases",
  "matrix",
  "pmatrix",
  "bmatrix",
  "vmatrix",
  "Vmatrix",
]);

function classifyEnvRole(envName: any): EnvironmentRole {
  const lower = String(envName || "").toLowerCase();
  if (lower === "thebibliography") return "bibliography";
  if (KNOWN_FLOAT_ENVS.has(lower)) return "float";
  if (KNOWN_MATH_ENVS.has(lower)) return "math";
  if (lower === "verbatim" || lower === "verbatim*" || lower === "lstlisting" || lower === "minted") {
    return "verbatim";
  }
  return "generic";
}

function classifyEnvelopeMarker(cmdName: any): EnvelopeMarkerKind | undefined {
  const lower = String(cmdName || "").toLowerCase();
  if (lower === "documentclass") return "documentclass";
  if (lower === "appendix") return "appendix";
  if (lower === "bibliography") return "bibliography";
  if (
    lower === "section" ||
    lower === "section*" ||
    lower === "subsection" ||
    lower === "subsection*" ||
    lower === "subsubsection" ||
    lower === "subsubsection*" ||
    lower === "paragraph" ||
    lower === "paragraph*" ||
    lower === "subparagraph" ||
    lower === "subparagraph*"
  ) {
    return "section";
  }
  return undefined;
}

export function reconcileLatex(
  sourceId: SourceId,
  rawText: string,
  strat: StratificationResult,
  lexSightings: LexicalSighting[],
  parseResult: ParseLatexResult
): ReconcileResult {
  const entities: CensusEntity[] = [];
  const diagnostics: Diagnostic[] = [];

  // 1. Comments from stratification
  for (const s of strat.strata) {
    if (s.kind === "comment") {
      const id = mintEntityId("comment", s.span);
      entities.push({
        id,
        kind: "comment",
        span: s.span,
        spanProvenance: "lexical",
        witnesses: [
          {
            witness: "lexical",
            span: s.span,
            detail: "stratify:comment",
          },
        ],
        agreement: "agreed",
      });
    } else if (s.kind === "verbatim-inline") {
      const id = mintEntityId("verbatim-inline", s.span);
      entities.push({
        id,
        kind: "verbatim-inline",
        delimiter: s.delimiter || "|",
        span: s.span,
        spanProvenance: "lexical",
        witnesses: [
          {
            witness: "lexical",
            span: s.span,
            detail: "stratify:verbatim-inline",
          },
        ],
        agreement: "agreed",
      });
    }
  }

  // 2. Reconcile Macro Definitions and Environment Definitions from Parser
  for (const mdef of parseResult.macroDefinitions) {
    let span = mdef.span;
    let spanProv: SpanProvenance = "parser";

    // If body span extends past command, compute hull
    if (mdef.bodySpan && mdef.bodySpan.endUtf16 > span.endUtf16) {
      span = {
        sourceId,
        startUtf16: span.startUtf16,
        endUtf16: mdef.bodySpan.endUtf16 + 1, // include closing brace
      };
      spanProv = "synthesized-hull";
      diagnostics.push({
        code: DiagnosticCodes.SpanSynthesized,
        severity: "info",
        message: `Synthesized macro definition hull for \\${mdef.definedName}`,
        span,
      });
    }

    const id = mintEntityId("macro-definition", span);
    entities.push({
      id,
      kind: "macro-definition",
      definedName: mdef.definedName,
      dialect: mdef.dialect,
      bodySpan: mdef.bodySpan,
      elaborable: mdef.dialect !== "def" && mdef.dialect !== "let",
      span,
      spanProvenance: spanProv,
      witnesses: [
        {
          witness: "parser",
          instrument: "unified-latex",
          span: mdef.span,
          detail: mdef.dialect,
        },
      ],
      agreement: "agreed",
    });
  }

  for (const edef of parseResult.envDefinitions) {
    const id = mintEntityId("environment-definition", edef.span);
    entities.push({
      id,
      kind: "environment-definition",
      definedName: edef.definedName,
      mechanism: edef.mechanism,
      bodySpan: edef.bodySpan,
      span: edef.span,
      spanProvenance: "parser",
      witnesses: [
        {
          witness: "parser",
          instrument: "unified-latex",
          span: edef.span,
          detail: edef.mechanism,
        },
      ],
      agreement: "agreed",
    });
  }

  // 3. Process Parser Sightings (Macros, Envs, Math)
  for (const ps of parseResult.sightings) {
    if (!ps.span) continue;

    if (ps.nodeType === "macro") {
      const name = ps.name || "";
      if (
        name === "newcommand" ||
        name === "renewcommand" ||
        name === "providecommand" ||
        name === "newtheorem" ||
        name === "begin" ||
        name === "end"
      ) {
        continue; // Handled in definition or environment processing
      }

      let span = ps.span;
      let spanProv: SpanProvenance = "parser";

      // Check if macro has attached argument spans that extend beyond the csname
      if (ps.argSpans && ps.argSpans.length > 0) {
        const lastArg = ps.argSpans[ps.argSpans.length - 1];
        if (lastArg.endUtf16 > span.endUtf16) {
          // Adjust span to include argument delimiters
          let finalEnd = lastArg.endUtf16;
          if (finalEnd < rawText.length && (rawText[finalEnd] === "}" || rawText[finalEnd] === "]")) {
            finalEnd++;
          }
          span = {
            sourceId,
            startUtf16: span.startUtf16,
            endUtf16: finalEnd,
          };
          spanProv = "synthesized-hull";
          diagnostics.push({
            code: DiagnosticCodes.SpanSynthesized,
            severity: "info",
            message: `Synthesized argument hull for \\${name}`,
            span,
          });
        }
      }

      // Check if this macro is an envelope marker or include
      const envMarker = classifyEnvelopeMarker(name);
      if (envMarker) {
        const id = mintEntityId("envelope-marker", span);
        entities.push({
          id,
          kind: "envelope-marker",
          marker: envMarker,
          name,
          span,
          spanProvenance: spanProv,
          witnesses: [
            {
              witness: "parser",
              instrument: "unified-latex",
              span: ps.span,
              detail: name,
            },
          ],
          agreement: "agreed",
        });
      } else if (
        name === "input" ||
        name === "include" ||
        name === "subfile" ||
        name === "bibliography" ||
        name === "addbibresource" ||
        name === "bibliographystyle"
      ) {
        const id = mintEntityId("include", span);
        let directive: IncludeDirective = "input";
        if (name === "include" || name === "subfile") directive = "include";
        else if (name === "bibliography") directive = "bibliography";
        else if (name === "addbibresource") directive = "addbibresource";
        else if (name === "bibliographystyle") directive = "bibliographystyle";

        entities.push({
          id,
          kind: "include",
          directive,
          targetRaw: "",
          span,
          spanProvenance: spanProv,
          witnesses: [
            {
              witness: "parser",
              instrument: "unified-latex",
              span: ps.span,
              detail: name,
            },
          ],
          agreement: "agreed",
        });
      } else {
        const id = mintEntityId("macro-invocation", span);
        entities.push({
          id,
          kind: "macro-invocation",
          name,
          inMathMode: ps.inMathMode,
          argumentSpans: ps.argSpans,
          span,
          spanProvenance: spanProv,
          witnesses: [
            {
              witness: "parser",
              instrument: "unified-latex",
              span: ps.span,
              detail: name,
            },
          ],
          agreement: "agreed",
        });
      }
    } else if (ps.nodeType === "environment" || ps.nodeType === "mathenv") {
      const name = ps.name || "";
      const role = classifyEnvRole(name);
      const span = ps.span;

      const envId = mintEntityId("environment", span);
      entities.push({
        id: envId,
        kind: "environment",
        name,
        role,
        bodySpan: ps.bodySpan,
        span,
        spanProvenance: "parser",
        witnesses: [
          {
            witness: "parser",
            instrument: "unified-latex",
            span,
            detail: `environment:${name}`,
          },
        ],
        agreement: "agreed",
      });

      // If it's a math environment, also emit an overlay math carrier entity
      if (role === "math" || ps.nodeType === "mathenv") {
        const mathId = mintEntityId("math", span);
        entities.push({
          id: mathId,
          kind: "math",
          mode: "display",
          carrier: { form: "env", name },
          fenceEntityId: envId,
          span,
          spanProvenance: "parser",
          witnesses: [
            {
              witness: "parser",
              instrument: "unified-latex",
              span,
              detail: `mathenv:${name}`,
            },
          ],
          agreement: "agreed",
        });
      }
    } else if (ps.nodeType === "inlinemath") {
      const span = ps.span;
      const id = mintEntityId("math", span);
      const rawSlice = rawText.slice(span.startUtf16, span.endUtf16);
      const form = rawSlice.startsWith("\\(") ? "paren" : "dollar";

      entities.push({
        id,
        kind: "math",
        mode: "inline",
        carrier: { form },
        span,
        spanProvenance: "parser",
        witnesses: [
          {
            witness: "parser",
            instrument: "unified-latex",
            span,
            detail: `inlinemath:${form}`,
          },
        ],
        agreement: "agreed",
      });
    } else if (ps.nodeType === "displaymath") {
      const span = ps.span;
      const id = mintEntityId("math", span);
      const rawSlice = rawText.slice(span.startUtf16, span.endUtf16);
      const form = rawSlice.startsWith("\\[") ? "bracket" : "double-dollar";

      entities.push({
        id,
        kind: "math",
        mode: "display",
        carrier: { form },
        span,
        spanProvenance: "parser",
        witnesses: [
          {
            witness: "parser",
            instrument: "unified-latex",
            span,
            detail: `displaymath:${form}`,
          },
        ],
        agreement: "agreed",
      });
    }
  }

  // 4. Lexical sightings cross-check for unparsed or lexical-only items
  for (const ls of lexSightings) {
    if (ls.kind === "envelope-marker" && (ls.name === "begin" || ls.name === "end")) {
      const id = mintEntityId("envelope-marker", ls.span);
      entities.push({
        id,
        kind: "envelope-marker",
        marker: ls.name === "begin" ? "begin-document" : "end-document",
        span: ls.span,
        spanProvenance: "lexical",
        witnesses: [
          {
            witness: "lexical",
            span: ls.span,
            detail: ls.detail,
          },
        ],
        agreement: "agreed",
      });
    }
  }

  return {
    sourceId,
    entities,
    diagnostics,
  };
}

export function reconcileBib(
  sourceId: SourceId,
  rawText: string,
  lexSightings: BibLexicalSighting[],
  parseResult: ParseBibResult
): ReconcileResult {
  const entities: CensusEntity[] = [];
  const diagnostics: Diagnostic[] = [...parseResult.diagnostics];

  // 1. Bib Entries
  for (const entry of parseResult.entries) {
    const entryId = mintEntityId("bib-entry", entry.span);
    entities.push({
      id: entryId,
      kind: "bib-entry",
      entryType: entry.entryType,
      citeKey: entry.citeKey,
      bodySpan: entry.bodySpan,
      span: entry.span,
      spanProvenance: "parser",
      witnesses: [
        {
          witness: "parser",
          instrument: "latex-utensils",
          span: entry.span,
          detail: `bib-entry:${entry.entryType}`,
        },
      ],
      agreement: "agreed",
    });

    // Fields
    for (const field of entry.fields) {
      const fieldId = mintEntityId("bib-field", field.valueSpan);
      entities.push({
        id: fieldId,
        kind: "bib-field",
        entryId,
        fieldName: field.fieldName,
        valueSpan: field.valueSpan,
        valueShape: field.valueShape,
        parts: field.parts,
        span: field.valueSpan,
        spanProvenance: "parser",
        witnesses: [
          {
            witness: "parser",
            instrument: "latex-utensils",
            span: field.valueSpan,
            detail: `bib-field:${field.fieldName}`,
          },
        ],
        agreement: "agreed",
      });
    }
  }

  // 2. Bib Strings
  for (const str of parseResult.strings) {
    const id = mintEntityId("bib-string", str.span);
    entities.push({
      id,
      kind: "bib-string",
      abbreviationName: str.abbreviationName,
      valueSpan: str.valueSpan,
      span: str.span,
      spanProvenance: "parser",
      witnesses: [
        {
          witness: "parser",
          instrument: "latex-utensils",
          span: str.span,
          detail: "bib-string",
        },
      ],
      agreement: "agreed",
    });
  }

  // 3. Bib Preambles
  for (const pre of parseResult.preambles) {
    const id = mintEntityId("bib-preamble", pre.span);
    entities.push({
      id,
      kind: "bib-preamble",
      span: pre.span,
      spanProvenance: "parser",
      witnesses: [
        {
          witness: "parser",
          instrument: "latex-utensils",
          span: pre.span,
          detail: "bib-preamble",
        },
      ],
      agreement: "agreed",
    });
  }

  // 4. Bib Comments (explicit & implicit)
  for (const comm of parseResult.comments) {
    const id = mintEntityId("bib-comment", comm.span);
    entities.push({
      id,
      kind: "bib-comment",
      span: comm.span,
      spanProvenance: "parser",
      witnesses: [
        {
          witness: "parser",
          instrument: "latex-utensils",
          span: comm.span,
          detail: "bib-comment",
        },
      ],
      agreement: "agreed",
    });
  }

  // Add implicit comments from lexical scan
  for (const lex of lexSightings) {
    if (lex.kind === "bib-comment" && lex.detail === "implicit-comment") {
      const id = mintEntityId("bib-comment", lex.span);
      entities.push({
        id,
        kind: "bib-comment",
        span: lex.span,
        spanProvenance: "lexical",
        witnesses: [
          {
            witness: "lexical",
            span: lex.span,
            detail: "implicit-comment",
          },
        ],
        agreement: "agreed",
      });
    }
  }

  return {
    sourceId,
    entities,
    diagnostics,
  };
}
