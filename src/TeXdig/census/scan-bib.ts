/**
 * TeXdig lexical scanner witness for .bib files.
 *
 * Scans BibTeX files for @entry, @string, @preamble, @comment, and inter-entry text.
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { SourceId, SourceSpan } from "../core/types.ts";

export type BibLexicalKind = "bib-entry" | "bib-string" | "bib-preamble" | "bib-comment";

export interface BibLexicalSighting {
  kind: BibLexicalKind;
  span: SourceSpan;
  entryType?: string;
  citeKey?: string;
  abbreviationName?: string;
  detail?: string;
}

export function scanBib(sourceId: SourceId, rawText: string): BibLexicalSighting[] {
  const sightings: BibLexicalSighting[] = [];
  const len = rawText.length;
  let i = 0;
  let lastEntryEnd = 0;

  while (i < len) {
    if (rawText[i] === "@") {
      // Record any inter-entry run: text becomes an implicit comment, pure
      // whitespace is still SEEN (coverage must claim every code unit).
      if (i > lastEntryEnd) {
        const interText = rawText.slice(lastEntryEnd, i);
        sightings.push({
          kind: "bib-comment",
          span: { sourceId, startUtf16: lastEntryEnd, endUtf16: i },
          detail: interText.trim().length > 0 ? "implicit-comment" : "implicit-blank",
        });
      }

      const start = i;
      let cursor = i + 1;
      while (cursor < len && /[a-zA-Z]/.test(rawText[cursor])) {
        cursor++;
      }
      const entryType = rawText.slice(start + 1, cursor).toLowerCase();

      // Skip whitespace
      while (cursor < len && /\s/.test(rawText[cursor])) {
        cursor++;
      }

      if (cursor < len && (rawText[cursor] === "{" || rawText[cursor] === "(")) {
        const openChar = rawText[cursor];
        const closeChar = openChar === "{" ? "}" : ")";
        let depth = 1;
        cursor++;

        while (cursor < len && depth > 0) {
          if (rawText[cursor] === openChar) depth++;
          else if (rawText[cursor] === closeChar) depth--;
          cursor++;
        }

        const end = cursor;
        lastEntryEnd = end;

        if (entryType === "string") {
          sightings.push({
            kind: "bib-string",
            span: { sourceId, startUtf16: start, endUtf16: end },
            detail: "string",
          });
        } else if (entryType === "preamble") {
          sightings.push({
            kind: "bib-preamble",
            span: { sourceId, startUtf16: start, endUtf16: end },
            detail: "preamble",
          });
        } else if (entryType === "comment") {
          sightings.push({
            kind: "bib-comment",
            span: { sourceId, startUtf16: start, endUtf16: end },
            detail: "comment",
          });
        } else {
          sightings.push({
            kind: "bib-entry",
            entryType,
            span: { sourceId, startUtf16: start, endUtf16: end },
            detail: `entry:${entryType}`,
          });
        }

        i = end;
        continue;
      }
    }

    i++;
  }

  // Any trailing inter-entry run
  if (lastEntryEnd < len) {
    const trailingText = rawText.slice(lastEntryEnd);
    sightings.push({
      kind: "bib-comment",
      span: { sourceId, startUtf16: lastEntryEnd, endUtf16: len },
      detail: trailingText.trim().length > 0 ? "implicit-comment" : "implicit-blank",
    });
  }

  return sightings;
}
