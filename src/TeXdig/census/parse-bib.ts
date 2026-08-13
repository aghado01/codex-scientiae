/**
 * TeXdig parser witness for .bib files using latex-utensils.
 *
 * Extracts structured entries, @string definitions, @preamble, @comment,
 * and typed field values with exact source spans.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type {
  SourceId,
  SourceSpan,
  BibValueShape,
  Diagnostic,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import { isValidSourceSpan, sourceSpanContains } from "../core/spans.ts";
import type { Dependencies } from "../core/loader.ts";

export interface ParsedBibField {
  fieldName: string;
  valueSpan: SourceSpan;
  valueShape: BibValueShape;
  parts?: { span: SourceSpan; shape: Exclude<BibValueShape, "concat"> }[];
}

export interface ParsedBibEntry {
  entryType: string;
  citeKey?: string;
  span: SourceSpan;
  bodySpan?: SourceSpan;
  fields: ParsedBibField[];
}

export interface ParsedBibString {
  abbreviationName: string;
  span: SourceSpan;
  valueSpan?: SourceSpan;
}

export interface ParsedBibPreamble {
  span: SourceSpan;
}

export interface ParsedBibComment {
  span: SourceSpan;
}

export interface ParseBibResult {
  sourceId: SourceId;
  entries: ParsedBibEntry[];
  strings: ParsedBibString[];
  preambles: ParsedBibPreamble[];
  comments: ParsedBibComment[];
  diagnostics: Diagnostic[];
}

function mapValueShape(kind: string): BibValueShape {
  if (kind === "text_string") return "text";
  if (kind === "number") return "number";
  if (kind === "abbreviation") return "abbreviation";
  if (kind === "concat") return "concat";
  return "text";
}

export function parseBib(
  sourceId: SourceId,
  rawText: string,
  deps: Dependencies
): ParseBibResult {
  const entries: ParsedBibEntry[] = [];
  const strings: ParsedBibString[] = [];
  const preambles: ParsedBibPreamble[] = [];
  const comments: ParsedBibComment[] = [];
  const diagnostics: Diagnostic[] = [];

  let ast: any;
  try {
    ast = deps.utensils.bibtexParser.parse(rawText);
  } catch (err: any) {
    diagnostics.push({
      code: DiagnosticCodes.BibParseError,
      severity: "defect",
      message: `BibTeX parse error: ${err.message || String(err)}`,
      sourceId,
      witness: "parser",
    });
    return { sourceId, entries, strings, preambles, comments, diagnostics };
  }

  const seenKeys = new Set<string>();

  function locationSpan(value: any, label: string): SourceSpan | undefined {
    const start = value?.location?.start?.offset;
    const end = value?.location?.end?.offset;
    const span: SourceSpan = { sourceId, startUtf16: start, endUtf16: end };
    if (isValidSourceSpan(span, rawText.length)) return span;
    diagnostics.push({
      code: DiagnosticCodes.InvalidSpan,
      severity: "defect",
      message: `Discarded invalid latex-utensils ${label} span`,
      sourceId,
      witness: "parser",
    });
    return undefined;
  }

  function constructBodySpan(span: SourceSpan): SourceSpan | undefined {
    const brace = rawText.indexOf("{", span.startUtf16);
    const paren = rawText.indexOf("(", span.startUtf16);
    const openAt = brace < 0 ? paren : paren < 0 ? brace : Math.min(brace, paren);
    if (openAt < span.startUtf16 || openAt >= span.endUtf16) return undefined;
    const closeAt = span.endUtf16 - 1;
    const expected = rawText[openAt] === "{" ? "}" : ")";
    if (rawText[closeAt] !== expected) return undefined;
    const body: SourceSpan = { sourceId, startUtf16: openAt + 1, endUtf16: closeAt };
    return sourceSpanContains(span, body) ? body : undefined;
  }

  if (ast && ast.content && Array.isArray(ast.content)) {
    for (const item of ast.content) {
      if (!item || !item.location) continue;

      const itemSpan = locationSpan(item, `@${String(item.entryType || "construct")}`);
      if (!itemSpan) continue;

      if (item.entryType === "string") {
        const valSpan = item.value?.location ? locationSpan(item.value, "@string value") : undefined;

        strings.push({
          abbreviationName: item.abbreviation || "",
          span: itemSpan,
          valueSpan: valSpan,
        });
      } else if (item.entryType === "preamble") {
        preambles.push({ span: itemSpan });
      } else if (item.entryType === "comment") {
        comments.push({ span: itemSpan });
      } else {
        // Normal entry
        const entryType = (item.entryType || "").toLowerCase();
        const citeKey = item.internalKey || undefined;

        if (citeKey) {
          if (seenKeys.has(citeKey)) {
            diagnostics.push({
              code: DiagnosticCodes.BibDuplicateKey,
              severity: "warning",
              message: `Duplicate BibTeX cite key '${citeKey}'`,
              sourceId,
              span: itemSpan,
            });
          } else {
            seenKeys.add(citeKey);
          }
        }

        const fields: ParsedBibField[] = [];
        if (item.content && Array.isArray(item.content)) {
          for (const field of item.content) {
            if (!field || !field.name || !field.value || !field.value.location) continue;

            const fValSpan = locationSpan(field.value, `Bib field '${String(field.name)}' value`);
            if (!fValSpan || !sourceSpanContains(itemSpan, fValSpan)) {
              if (fValSpan) {
                diagnostics.push({
                  code: DiagnosticCodes.UntrustedParserSpan,
                  severity: "defect",
                  message: `Discarded Bib field '${String(field.name)}' span outside its entry`,
                  sourceId,
                  witness: "parser",
                });
              }
              continue;
            }
            const fShape = mapValueShape(field.value.kind);

            let parts: { span: SourceSpan; shape: Exclude<BibValueShape, "concat"> }[] | undefined;
            if (fShape === "concat" && Array.isArray(field.value.content)) {
              parts = [];
              for (const part of field.value.content) {
                if (part && part.location) {
                  const partSpan = locationSpan(part, `Bib field '${String(field.name)}' concat part`);
                  if (!partSpan || !sourceSpanContains(fValSpan, partSpan)) continue;
                  parts.push({
                    span: partSpan,
                    shape: mapValueShape(part.kind) as Exclude<BibValueShape, "concat">,
                  });
                }
              }
            }

            fields.push({
              fieldName: field.name.toLowerCase(),
              valueSpan: fValSpan,
              valueShape: fShape,
              parts,
            });
          }
        }

        entries.push({
          entryType,
          citeKey,
          span: itemSpan,
          bodySpan: constructBodySpan(itemSpan),
          fields,
        });
      }
    }
  }

  return {
    sourceId,
    entries,
    strings,
    preambles,
    comments,
    diagnostics,
  };
}
