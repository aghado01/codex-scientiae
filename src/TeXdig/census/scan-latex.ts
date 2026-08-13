/**
 * TeXdig lexical scanner witness for LaTeX and .bbl files.
 *
 * Fast, position-complete character scanner providing complete UTF-16 spans
 * and shallow typing for all control sequences, environment fences, math carriers,
 * and structural envelope markers.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { Diagnostic, SourceId, SourceSpan, WitnessRecord } from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";

export type LexicalSightingKind =
  | "macro-invocation"
  | "macro-definition"
  | "environment-definition"
  | "environment-begin"
  | "environment-end"
  | "math"
  | "envelope-marker"
  | "include"
  | "comment"
  | "verbatim";

export interface LexicalSighting {
  kind: LexicalSightingKind;
  span: SourceSpan;
  name?: string;
  detail?: string;
  mode?: "inline" | "display";
  delimiter?: string;
}

// Starred variants are covered by the base csname: the scanner records the
// star as content, matching the parser witness (star = s-type argument).
const ENVELOPE_COMMANDS = new Set([
  "documentclass",
  "section",
  "subsection",
  "subsubsection",
  "paragraph",
  "subparagraph",
  "appendix",
  "title",
  "author",
  "date",
  "maketitle",
  "tableofcontents",
]);

const DEFINITION_COMMANDS = new Set([
  "newcommand",
  "renewcommand",
  "providecommand",
  "DeclareMathOperator",
  "DeclarePairedDelimiter",
  "NewDocumentCommand",
  "RenewDocumentCommand",
  "ProvideDocumentCommand",
  "def",
  "gdef",
  "edef",
  "xdef",
  "let",
]);

const ENV_DEF_COMMANDS = new Set([
  "newtheorem",
  "newenvironment",
  "renewenvironment",
  "newfloat",
]);

const INCLUDE_COMMANDS = new Set([
  "input",
  "include",
  "subfile",
  "bibliography",
  "addbibresource",
  "bibliographystyle",
]);

export interface ScanLatexResult {
  sightings: LexicalSighting[];
  diagnostics: Diagnostic[];
}

export function scanLatex(sourceId: SourceId, rawText: string): ScanLatexResult {
  const sightings: LexicalSighting[] = [];
  const diagnostics: Diagnostic[] = [];
  const len = rawText.length;
  let i = 0;
  let atIsLetter = false;

  // Math carriers are sighted as spans, but the scan STEPS INTO the interior —
  // control sequences and scripts inside math must be lexically witnessed too.
  // Only the closing delimiter itself is skipped (offset -> delimiter length).
  const skipAt = new Map<number, number>();

  while (i < len) {
    const skip = skipAt.get(i);
    if (skip !== undefined) {
      skipAt.delete(i);
      i += skip;
      continue;
    }
    const ch = rawText[i];

    // 1. Comments
    if (ch === "%") {
      let backslashes = 0;
      let b = i - 1;
      while (b >= 0 && rawText[b] === "\\") {
        backslashes++;
        b--;
      }
      if (backslashes % 2 === 0) {
        const start = i;
        while (i < len && rawText[i] !== "\n" && rawText[i] !== "\r") {
          i++;
        }
        sightings.push({
          kind: "comment",
          span: { sourceId, startUtf16: start, endUtf16: i },
          detail: "comment",
        });
        continue;
      }
    }

    // 2. Math: $$...$$ or $...$
    if (ch === "$") {
      let backslashes = 0;
      let b = i - 1;
      while (b >= 0 && rawText[b] === "\\") {
        backslashes++;
        b--;
      }
      if (backslashes % 2 === 0) {
        if (i + 1 < len && rawText[i + 1] === "$") {
          // Display math $$...$$
          const start = i;
          let closeIdx = rawText.indexOf("$$", i + 2);
          if (closeIdx !== -1) {
            const end = closeIdx + 2;
            sightings.push({
              kind: "math",
              mode: "display",
              delimiter: "$$",
              span: { sourceId, startUtf16: start, endUtf16: end },
              detail: "double-dollar",
            });
            skipAt.set(closeIdx, 2);
            i = start + 2;
            continue;
          }
          diagnostics.push({
            code: DiagnosticCodes.UnterminatedMath,
            severity: "warning",
            message: "Display math '$$' opened without a closing '$$'",
            sourceId,
            span: { sourceId, startUtf16: start, endUtf16: Math.min(start + 2, len) },
            witness: "lexical",
          });
        } else {
          // Inline math $...$
          const start = i;
          let cursor = i + 1;
          let closed = false;
          while (cursor < len) {
            if (rawText[cursor] === "$") {
              let bs = 0;
              let k = cursor - 1;
              while (k >= start && rawText[k] === "\\") {
                bs++;
                k--;
              }
              if (bs % 2 === 0) {
                closed = true;
                break;
              }
            }
            if (rawText[cursor] === "\n" && cursor + 1 < len && rawText[cursor + 1] === "\n") {
              // Paragraph break breaks inline math
              break;
            }
            cursor++;
          }
          if (closed) {
            const end = cursor + 1;
            sightings.push({
              kind: "math",
              mode: "inline",
              delimiter: "$",
              span: { sourceId, startUtf16: start, endUtf16: end },
              detail: "dollar",
            });
            skipAt.set(cursor, 1);
            i = start + 1;
            continue;
          }
          diagnostics.push({
            code: DiagnosticCodes.UnterminatedMath,
            severity: "warning",
            message: "Inline math '$' not closed before paragraph break or end of file",
            sourceId,
            span: { sourceId, startUtf16: start, endUtf16: start + 1 },
            witness: "lexical",
          });
        }
      }
    }

    // 3. Sub/superscript operators: not control sequences, but the parser
    // witness emits them as macro nodes `^`/`_`, so the lexical witness must
    // sight them too or every script site would be parser-only noise.
    if (ch === "^" || ch === "_") {
      sightings.push({
        kind: "macro-invocation",
        name: ch,
        span: { sourceId, startUtf16: i, endUtf16: i + 1 },
        detail: ch,
      });
      i++;
      continue;
    }

    // 4. Control sequences starting with backslash \
    if (ch === "\\") {
      let backslashes = 0;
      let b = i - 1;
      while (b >= 0 && rawText[b] === "\\") {
        backslashes++;
        b--;
      }
      if (backslashes % 2 === 0) {
        // Escaped \( ... \) or \[ ... \]
        if (i + 1 < len && rawText[i + 1] === "(") {
          const start = i;
          const closeIdx = rawText.indexOf("\\)", i + 2);
          if (closeIdx !== -1) {
            const end = closeIdx + 2;
            sightings.push({
              kind: "math",
              mode: "inline",
              delimiter: "\\(",
              span: { sourceId, startUtf16: start, endUtf16: end },
              detail: "paren",
            });
            skipAt.set(closeIdx, 2);
            i = start + 2;
            continue;
          }
          diagnostics.push({
            code: DiagnosticCodes.UnterminatedMath,
            severity: "warning",
            message: "Inline math '\\(' opened without a closing '\\)'",
            sourceId,
            span: { sourceId, startUtf16: start, endUtf16: start + 2 },
            witness: "lexical",
          });
        }
        if (i + 1 < len && rawText[i + 1] === "[") {
          const start = i;
          const closeIdx = rawText.indexOf("\\]", i + 2);
          if (closeIdx !== -1) {
            const end = closeIdx + 2;
            sightings.push({
              kind: "math",
              mode: "display",
              delimiter: "\\[",
              span: { sourceId, startUtf16: start, endUtf16: end },
              detail: "bracket",
            });
            skipAt.set(closeIdx, 2);
            i = start + 2;
            continue;
          }
          diagnostics.push({
            code: DiagnosticCodes.UnterminatedMath,
            severity: "warning",
            message: "Display math '\\[' opened without a closing '\\]'",
            sourceId,
            span: { sourceId, startUtf16: start, endUtf16: start + 2 },
            witness: "lexical",
          });
        }

        // Check for \begin{...} or \end{...}
        if (rawText.startsWith("\\begin{", i)) {
          const envStart = i + 7;
          const envEnd = rawText.indexOf("}", envStart);
          if (envEnd !== -1) {
            const envName = rawText.slice(envStart, envEnd).trim();
            const totalEnd = envEnd + 1;
            sightings.push({
              kind: envName === "document" ? "envelope-marker" : "environment-begin",
              name: envName,
              span: { sourceId, startUtf16: i, endUtf16: totalEnd },
              detail: `begin:${envName}`,
            });
            i = totalEnd;
            continue;
          }
        }
        if (rawText.startsWith("\\end{", i)) {
          const envStart = i + 5;
          const envEnd = rawText.indexOf("}", envStart);
          if (envEnd !== -1) {
            const envName = rawText.slice(envStart, envEnd).trim();
            const totalEnd = envEnd + 1;
            sightings.push({
              kind: envName === "document" ? "envelope-marker" : "environment-end",
              name: envName,
              span: { sourceId, startUtf16: i, endUtf16: totalEnd },
              detail: `end:${envName}`,
            });
            i = totalEnd;
            continue;
          }
        }

        // General control sequence: \letters or \singleNonLetter.
        // The `*` after a starred command is NOT part of the csname — gluing it
        // on would corrupt byte-exact join keys and disagree with the parser
        // witness, which records `\section*` as macro `section` + star argument.
        const csStart = i;
        let csEnd = i + 1;
        const isControlLetter = (value: string) =>
          /[a-zA-Z]/.test(value) || (atIsLetter && value === "@");
        if (csEnd < len && isControlLetter(rawText[csEnd])) {
          while (csEnd < len && isControlLetter(rawText[csEnd])) {
            csEnd++;
          }
        } else if (csEnd < len) {
          csEnd++; // Single non-letter character (e.g. \1, \%, \\, \ )
        }

        const csName = rawText.slice(csStart + 1, csEnd);
        const csSpan: SourceSpan = { sourceId, startUtf16: csStart, endUtf16: csEnd };

        // TeX permits whitespace between \begin/\end and the mandatory group.
        // Fence identity includes the whole written fence, including that gap.
        if (csName === "begin" || csName === "end") {
          let envOpen = csEnd;
          while (envOpen < len && /\s/.test(rawText[envOpen])) envOpen++;
          if (rawText[envOpen] === "{") {
            const envEnd = rawText.indexOf("}", envOpen + 1);
            if (envEnd !== -1) {
              const envName = rawText.slice(envOpen + 1, envEnd).trim();
              const totalEnd = envEnd + 1;
              sightings.push({
                kind: envName === "document" ? "envelope-marker" : csName === "begin" ? "environment-begin" : "environment-end",
                name: envName,
                span: { sourceId, startUtf16: csStart, endUtf16: totalEnd },
                detail: `${csName}:${envName}`,
              });
              i = totalEnd;
              continue;
            }
          }
        }

        if (DEFINITION_COMMANDS.has(csName)) {
          sightings.push({
            kind: "macro-definition",
            name: csName,
            span: csSpan,
            detail: csName,
          });
        } else if (ENV_DEF_COMMANDS.has(csName)) {
          sightings.push({
            kind: "environment-definition",
            name: csName,
            span: csSpan,
            detail: csName,
          });
        } else if (ENVELOPE_COMMANDS.has(csName)) {
          sightings.push({
            kind: "envelope-marker",
            name: csName,
            span: csSpan,
            detail: csName,
          });
        } else if (INCLUDE_COMMANDS.has(csName)) {
          sightings.push({
            kind: "include",
            name: csName,
            span: csSpan,
            detail: csName,
          });
        } else {
          sightings.push({
            kind: "macro-invocation",
            name: csName,
            span: csSpan,
            detail: csName,
          });
        }

        if (csName === "makeatletter") atIsLetter = true;
        else if (csName === "makeatother") atIsLetter = false;

        i = csEnd;
        continue;
      }
    }

    i++;
  }

  return { sightings, diagnostics };
}

export function toWitnessRecord(sighting: LexicalSighting): WitnessRecord {
  const spanRole = sighting.kind === "environment-begin"
    ? "begin-fence"
    : sighting.kind === "environment-end"
      ? "end-fence"
      : sighting.kind === "macro-invocation" || sighting.kind === "macro-definition" ||
          sighting.kind === "environment-definition" || sighting.kind === "envelope-marker" ||
          sighting.kind === "include"
        ? "token"
        : "construct";
  return {
    witness: "lexical",
    span: sighting.span,
    spanRole,
    detail: sighting.detail || sighting.name,
  };
}
