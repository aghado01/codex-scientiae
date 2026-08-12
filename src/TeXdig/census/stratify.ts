/**
 * TeXdig census stratifier — comment and verbatim stratification.
 *
 * Precedes EVERYTHING in the census pipeline, including include-graph construction.
 * Masked text preserves exact UTF-16 code unit positions and newline boundaries
 * while replacing comment and verbatim content with whitespace.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { SourceId, SourceSpan } from "../core/types.ts";

export type StratumKind = "comment" | "verbatim-inline" | "verbatim";

export interface Stratum {
  kind: StratumKind;
  span: SourceSpan;
  /** For inline verbatim, the delimiter character used. */
  delimiter?: string;
  /** For block verbatim, the environment name. */
  envName?: string;
}

export interface StratificationResult {
  sourceId: SourceId;
  strata: Stratum[];
  /** Stratified text with comments and verbatims blanked out (spaces + newlines). */
  stratifiedText: string;
}

const VERBATIM_ENVS = new Set([
  "verbatim",
  "verbatim*",
  "lstlisting",
  "minted",
  "alltt",
  "comment",
  "filecontents",
  "filecontents*",
]);

export function stratify(sourceId: SourceId, rawText: string): StratificationResult {
  const strata: Stratum[] = [];
  const chars = Array.from(rawText); // Note: for UTF-16 index tracking, we index into rawText directly
  const len = rawText.length;
  let i = 0;

  // We build a masked string by replacing stratified regions with spaces (preserving \n and \r)
  const maskBuffer: string[] = rawText.split("");

  function blankOut(start: number, end: number) {
    for (let pos = start; pos < end; pos++) {
      const ch = rawText[pos];
      if (ch === "\n" || ch === "\r") {
        maskBuffer[pos] = ch;
      } else {
        maskBuffer[pos] = " ";
      }
    }
  }

  while (i < len) {
    const ch = rawText[i];

    // Check for comment: % preceded by even number of backslashes
    if (ch === "%") {
      let backslashCount = 0;
      let b = i - 1;
      while (b >= 0 && rawText[b] === "\\") {
        backslashCount++;
        b--;
      }

      if (backslashCount % 2 === 0) {
        // Active comment: runs until newline or EOF
        const commentStart = i;
        while (i < len && rawText[i] !== "\n" && rawText[i] !== "\r") {
          i++;
        }
        const commentEnd = i;
        strata.push({
          kind: "comment",
          span: {
            sourceId,
            startUtf16: commentStart,
            endUtf16: commentEnd,
          },
        });
        blankOut(commentStart, commentEnd);
        continue;
      }
    }

    // Check for \verb or \verb*
    if (ch === "\\" && rawText.startsWith("\\verb", i)) {
      let backslashCount = 0;
      let b = i - 1;
      while (b >= 0 && rawText[b] === "\\") {
        backslashCount++;
        b--;
      }

      if (backslashCount % 2 === 0) {
        let cursor = i + 5; // length of '\verb'
        if (cursor < len && rawText[cursor] === "*") {
          cursor++;
        }
        if (cursor < len) {
          const delim = rawText[cursor];
          // Delimiter cannot be space, newline, or alphanumeric in LaTeX
          if (delim !== " " && delim !== "\n" && delim !== "\r" && !/[a-zA-Z]/.test(delim)) {
            const verbStart = i;
            cursor++;
            while (cursor < len && rawText[cursor] !== delim && rawText[cursor] !== "\n" && rawText[cursor] !== "\r") {
              cursor++;
            }
            if (cursor < len && rawText[cursor] === delim) {
              cursor++; // include closing delim
              const verbEnd = cursor;
              strata.push({
                kind: "verbatim-inline",
                delimiter: delim,
                span: {
                  sourceId,
                  startUtf16: verbStart,
                  endUtf16: verbEnd,
                },
              });
              blankOut(verbStart, verbEnd);
              i = cursor;
              continue;
            }
          }
        }
      }
    }

    // Check for \begin{verbatim|lstlisting|minted|...}
    if (ch === "\\" && rawText.startsWith("\\begin{", i)) {
      let backslashCount = 0;
      let b = i - 1;
      while (b >= 0 && rawText[b] === "\\") {
        backslashCount++;
        b--;
      }

      if (backslashCount % 2 === 0) {
        const envNameStart = i + 7; // length of '\begin{'
        const envNameEnd = rawText.indexOf("}", envNameStart);
        if (envNameEnd !== -1) {
          const envName = rawText.slice(envNameStart, envNameEnd).trim();
          if (VERBATIM_ENVS.has(envName)) {
            const blockStart = i;
            const endMarker = `\\end{${envName}}`;
            const endIdx = rawText.indexOf(endMarker, envNameEnd + 1);
            if (endIdx !== -1) {
              const blockEnd = endIdx + endMarker.length;
              strata.push({
                kind: "verbatim",
                envName,
                span: {
                  sourceId,
                  startUtf16: blockStart,
                  endUtf16: blockEnd,
                },
              });
              blankOut(blockStart, blockEnd);
              i = blockEnd;
              continue;
            }
          }
        }
      }
    }

    i++;
  }

  return {
    sourceId,
    strata,
    stratifiedText: maskBuffer.join(""),
  };
}
