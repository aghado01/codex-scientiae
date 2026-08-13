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
  bodySpan?: SourceSpan;
  entryType?: string;
  citeKey?: string;
  abbreviationName?: string;
  commentForm?: "explicit" | "implicit";
  detail?: string;
}

function constructEnd(text: string, openAt: number): number {
  const open = text[openAt];
  const close = open === "{" ? "}" : ")";
  let depth = 1;
  let braceDepth = 0;
  let quoted = false;

  for (let i = openAt + 1; i < text.length; i++) {
    const ch = text[i];
    if (ch === "\\") {
      i++;
      continue;
    }
    if (open === "(" && ch === '"' && braceDepth === 0) {
      quoted = !quoted;
      continue;
    }
    if (open === "(" && quoted) continue;
    if (open === "(" && ch === "{") {
      braceDepth++;
      continue;
    }
    if (open === "(" && ch === "}" && braceDepth > 0) {
      braceDepth--;
      continue;
    }
    if (open === "(" && braceDepth > 0) continue;
    if (ch === open) depth++;
    else if (ch === close) {
      depth--;
      if (depth === 0) return i + 1;
    }
  }
  return text.length;
}

export function scanBib(sourceId: SourceId, rawText: string): BibLexicalSighting[] {
  const sightings: BibLexicalSighting[] = [];
  const len = rawText.length;
  let i = 0;
  let lastEntryEnd = 0;

  while (i < len) {
    if (rawText[i] === "@") {
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
        // Record any inter-entry run only after confirming this is an actual
        // @construct. Stray @ characters remain part of the implicit text.
        if (start > lastEntryEnd) {
          const interText = rawText.slice(lastEntryEnd, start);
          sightings.push({
            kind: "bib-comment",
            span: { sourceId, startUtf16: lastEntryEnd, endUtf16: start },
            commentForm: "implicit",
            detail: interText.trim().length > 0 ? "implicit-comment" : "implicit-blank",
          });
        }

        const openAt = cursor;
        const end = constructEnd(rawText, openAt);
        const closed = end > openAt && (rawText[end - 1] === "}" || rawText[end - 1] === ")");
        const bodySpan: SourceSpan = {
          sourceId,
          startUtf16: openAt + 1,
          endUtf16: closed ? end - 1 : end,
        };
        const bodyRaw = rawText.slice(bodySpan.startUtf16, bodySpan.endUtf16);
        lastEntryEnd = end;

        if (entryType === "string") {
          const equals = bodyRaw.indexOf("=");
          sightings.push({
            kind: "bib-string",
            span: { sourceId, startUtf16: start, endUtf16: end },
            bodySpan,
            abbreviationName: equals >= 0 ? bodyRaw.slice(0, equals).trim() : undefined,
            detail: "string",
          });
        } else if (entryType === "preamble") {
          sightings.push({
            kind: "bib-preamble",
            span: { sourceId, startUtf16: start, endUtf16: end },
            bodySpan,
            detail: "preamble",
          });
        } else if (entryType === "comment") {
          sightings.push({
            kind: "bib-comment",
            span: { sourceId, startUtf16: start, endUtf16: end },
            bodySpan,
            commentForm: "explicit",
            detail: "comment",
          });
        } else {
          sightings.push({
            kind: "bib-entry",
            entryType,
            citeKey: bodyRaw.split(",", 1)[0].trim() || undefined,
            span: { sourceId, startUtf16: start, endUtf16: end },
            bodySpan,
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
      commentForm: "implicit",
      detail: trailingText.trim().length > 0 ? "implicit-comment" : "implicit-blank",
    });
  }

  return sightings;
}
