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
    });
    return { sourceId, entries, strings, preambles, comments, diagnostics };
  }

  const seenKeys = new Set<string>();

  if (ast && ast.content && Array.isArray(ast.content)) {
    for (const item of ast.content) {
      if (!item || !item.location) continue;

      const itemSpan: SourceSpan = {
        sourceId,
        startUtf16: item.location.start.offset,
        endUtf16: item.location.end.offset,
      };

      if (item.entryType === "string") {
        const valSpan: SourceSpan | undefined = item.value?.location
          ? {
              sourceId,
              startUtf16: item.value.location.start.offset,
              endUtf16: item.value.location.end.offset,
            }
          : undefined;

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

            const fValSpan: SourceSpan = {
              sourceId,
              startUtf16: field.value.location.start.offset,
              endUtf16: field.value.location.end.offset,
            };
            const fShape = mapValueShape(field.value.kind);

            let parts: { span: SourceSpan; shape: Exclude<BibValueShape, "concat"> }[] | undefined;
            if (fShape === "concat" && Array.isArray(field.value.content)) {
              parts = [];
              for (const part of field.value.content) {
                if (part && part.location) {
                  parts.push({
                    span: {
                      sourceId,
                      startUtf16: part.location.start.offset,
                      endUtf16: part.location.end.offset,
                    },
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
