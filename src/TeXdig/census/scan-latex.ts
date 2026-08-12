/**
 * TeXdig lexical scanner witness for LaTeX and .bbl files.
 *
 * Fast, position-complete character scanner providing complete UTF-16 spans
 * and shallow typing for all control sequences, environment fences, math carriers,
 * and structural envelope markers.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { SourceId, SourceSpan, WitnessRecord } from "../core/types.ts";

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

const ENVELOPE_COMMANDS = new Set([
  "documentclass",
  "section",
  "section*",
  "subsection",
  "subsection*",
  "subsubsection",
  "subsubsection*",
  "paragraph",
  "paragraph*",
  "subparagraph",
  "subparagraph*",
  "appendix",
  "title",
  "author",
  "date",
  "maketitle",
  "tableofcontents",
]);

const DEFINITION_COMMANDS = new Set([
  "newcommand",
  "newcommand*",
  "renewcommand",
  "renewcommand*",
  "providecommand",
  "providecommand*",
  "DeclareMathOperator",
  "DeclareMathOperator*",
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
  "newtheorem*",
  "newenvironment",
  "newenvironment*",
  "renewenvironment",
  "renewenvironment*",
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

export function scanLatex(sourceId: SourceId, rawText: string): LexicalSighting[] {
  const sightings: LexicalSighting[] = [];
  const len = rawText.length;
  let i = 0;

  while (i < len) {
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
            i = end;
            continue;
          }
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
            i = end;
            continue;
          }
        }
      }
    }

    // 3. Control sequences starting with backslash \
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
            i = end;
            continue;
          }
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
            i = end;
            continue;
          }
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

        // General control sequence: \letters or \singleNonLetter
        const csStart = i;
        let csEnd = i + 1;
        if (csEnd < len && /[a-zA-Z@]/.test(rawText[csEnd])) {
          while (csEnd < len && /[a-zA-Z@]/.test(rawText[csEnd])) {
            csEnd++;
          }
          if (csEnd < len && rawText[csEnd] === "*") {
            csEnd++; // Handle starred variants e.g. \section*, \newcommand*
          }
        } else if (csEnd < len) {
          csEnd++; // Single non-letter character (e.g. \1, \%, \\, \ )
        }

        const csName = rawText.slice(csStart + 1, csEnd);
        const csSpan: SourceSpan = { sourceId, startUtf16: csStart, endUtf16: csEnd };

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

        i = csEnd;
        continue;
      }
    }

    i++;
  }

  return sightings;
}

export function toWitnessRecord(sighting: LexicalSighting): WitnessRecord {
  return {
    witness: "lexical",
    span: sighting.span,
    detail: sighting.detail || sighting.name,
  };
}
