/**
 * TeXdig census stratifier for comments and verbatim-like syntax.
 *
 * Masking preserves exact UTF-16 code-unit positions and newline boundaries.
 * `alltt` is a hybrid: control sequences and braces stay active, while literal
 * special characters are neutralized so downstream LaTeX scanners do not
 * reinterpret them as comments, math, or scripts.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { Diagnostic, SourceId, SourceSpan } from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";

export type StratumKind = "comment" | "verbatim-inline" | "verbatim" | "alltt";

export interface Stratum {
  kind: StratumKind;
  span: SourceSpan;
  /** For inline verbatim, the delimiter character used. */
  delimiter?: string;
  /** For block verbatim and alltt, the environment name. */
  envName?: string;
}

export interface StratificationResult {
  sourceId: SourceId;
  strata: Stratum[];
  /** Stratified text with inactive syntax replaced by spaces plus original newlines. */
  stratifiedText: string;
  diagnostics: Diagnostic[];
}

export interface StratifyOptions {
  /** `.bbl` uses biblatex's `\verb{field} ... \endverb` field construct. */
  dialect?: "latex" | "biblatex-bbl";
}

const OPAQUE_VERBATIM_ENVS = new Set([
  "verbatim",
  "verbatim*",
  "lstlisting",
  "minted",
  "comment",
  "filecontents",
  "filecontents*",
]);

interface EnvironmentFence {
  envName: string;
  end: number;
}

function isActiveControlStart(text: string, index: number): boolean {
  let backslashes = 0;
  for (let cursor = index - 1; cursor >= 0 && text[cursor] === "\\"; cursor--) {
    backslashes++;
  }
  return backslashes % 2 === 0;
}

function parseEnvironmentFence(
  text: string,
  index: number,
  command: "begin" | "end"
): EnvironmentFence | undefined {
  const control = `\\${command}`;
  if (!text.startsWith(control, index) || !isActiveControlStart(text, index)) return undefined;

  let cursor = index + control.length;
  // `\beginning` is one control word, not `\begin` followed by an argument.
  if (cursor < text.length && /[A-Za-z@]/.test(text[cursor])) return undefined;
  while (cursor < text.length && /\s/.test(text[cursor])) cursor++;
  if (text[cursor] !== "{") return undefined;
  const nameStart = cursor + 1;
  const nameEnd = text.indexOf("}", nameStart);
  if (nameEnd === -1) return undefined;
  return { envName: text.slice(nameStart, nameEnd).trim(), end: nameEnd + 1 };
}

function findEnvironmentEnd(
  text: string,
  from: number,
  envName: string
): EnvironmentFence & { start: number } | undefined {
  let cursor = from;
  while ((cursor = text.indexOf("\\end", cursor)) !== -1) {
    const fence = parseEnvironmentFence(text, cursor, "end");
    if (fence?.envName === envName) return { ...fence, start: cursor };
    cursor += 4;
  }
  return undefined;
}

export function stratify(
  sourceId: SourceId,
  rawText: string,
  options: StratifyOptions = {}
): StratificationResult {
  const strata: Stratum[] = [];
  const diagnostics: Diagnostic[] = [];
  const len = rawText.length;
  let i = 0;

  const maskBuffer: string[] = rawText.split("");

  function blankOut(start: number, end: number) {
    for (let pos = start; pos < end; pos++) {
      const character = rawText[pos];
      maskBuffer[pos] = character === "\n" || character === "\r" ? character : " ";
    }
  }

  function neutralizeAlltt(start: number, end: number) {
    // In alltt, only backslash and braces keep their ordinary LaTeX meanings.
    // These characters otherwise trigger the downstream lexical scanner.
    for (let pos = start; pos < end; pos++) {
      if (rawText[pos] === "%" || rawText[pos] === "$" || rawText[pos] === "^" || rawText[pos] === "_") {
        maskBuffer[pos] = " ";
      }
    }
  }

  while (i < len) {
    const character = rawText[i];

    if (character === "%" && isActiveControlStart(rawText, i)) {
      const commentStart = i;
      while (i < len && rawText[i] !== "\n" && rawText[i] !== "\r") i++;
      strata.push({
        kind: "comment",
        span: { sourceId, startUtf16: commentStart, endUtf16: i },
      });
      blankOut(commentStart, i);
      continue;
    }

    if (character === "\\" && rawText.startsWith("\\verb", i) && isActiveControlStart(rawText, i)) {
      let cursor = i + 5;
      if (cursor < len && rawText[cursor] === "*") cursor++;
      if (cursor < len) {
        const delimiter = rawText[cursor];
        const braceIsBblField = options.dialect === "biblatex-bbl" && delimiter === "{";
        // A letter continues the `\verb...` control word; space/newline cannot
        // delimit inline verbatim. Digits and punctuation, including `{` in
        // ordinary LaTeX, are valid delimiter characters.
        if (
          !braceIsBblField &&
          delimiter !== " " &&
          delimiter !== "\t" &&
          delimiter !== "\n" &&
          delimiter !== "\r" &&
          !/[A-Za-z@]/.test(delimiter)
        ) {
          const verbStart = i;
          cursor++;
          while (
            cursor < len &&
            rawText[cursor] !== delimiter &&
            rawText[cursor] !== "\n" &&
            rawText[cursor] !== "\r"
          ) {
            cursor++;
          }
          if (cursor < len && rawText[cursor] === delimiter) {
            cursor++;
          } else {
            diagnostics.push({
              code: DiagnosticCodes.UnterminatedVerbatim,
              severity: "defect",
              message: `\\verb delimiter '${delimiter}' not closed before end of line`,
              span: { sourceId, startUtf16: verbStart, endUtf16: cursor },
            });
          }
          strata.push({
            kind: "verbatim-inline",
            delimiter,
            span: { sourceId, startUtf16: verbStart, endUtf16: cursor },
          });
          blankOut(verbStart, cursor);
          i = cursor;
          continue;
        }
      }
    }

    if (character === "\\") {
      const begin = parseEnvironmentFence(rawText, i, "begin");
      if (begin && (begin.envName === "alltt" || OPAQUE_VERBATIM_ENVS.has(begin.envName))) {
        const blockStart = i;
        const closing = findEnvironmentEnd(rawText, begin.end, begin.envName);
        const blockEnd = closing?.end ?? len;
        if (!closing) {
          diagnostics.push({
            code: DiagnosticCodes.UnterminatedVerbatim,
            severity: "defect",
            message: `\\begin{${begin.envName}} without matching \\end{${begin.envName}}; stratified to end of file`,
            span: { sourceId, startUtf16: blockStart, endUtf16: blockEnd },
          });
        }

        if (begin.envName === "alltt") {
          strata.push({
            kind: "alltt",
            envName: "alltt",
            span: { sourceId, startUtf16: blockStart, endUtf16: blockEnd },
          });
          neutralizeAlltt(begin.end, closing?.start ?? blockEnd);
        } else {
          strata.push({
            kind: "verbatim",
            envName: begin.envName,
            span: { sourceId, startUtf16: blockStart, endUtf16: blockEnd },
          });
          blankOut(blockStart, blockEnd);
        }
        i = blockEnd;
        continue;
      }
    }

    i++;
  }

  return {
    sourceId,
    strata,
    stratifiedText: maskBuffer.join(""),
    diagnostics,
  };
}
