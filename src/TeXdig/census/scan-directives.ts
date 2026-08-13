/**
 * Position-preserving scanner for literal source and bibliography directives.
 *
 * Input is already stratified. The scanner recognizes syntax only; filesystem
 * resolution and policy remain source-graph responsibilities.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { IncludeDirective, SourceId, SourceSpan } from "../core/types.ts";

export interface DirectiveTarget {
  targetRaw: string;
  targetSpan: SourceSpan;
}

export interface ScannedDirective {
  command: "input" | "include" | "subfile" | "bibliography" | "addbibresource" | "bibliographystyle";
  directive: IncludeDirective;
  /** Full directive site: control sequence through the literal argument. */
  span: SourceSpan;
  targets: DirectiveTarget[];
}

const DIRECTIVES = new Map<ScannedDirective["command"], IncludeDirective>([
  ["input", "input"],
  ["include", "include"],
  ["subfile", "include"],
  ["bibliography", "bibliography"],
  ["addbibresource", "addbibresource"],
  ["bibliographystyle", "bibliographystyle"],
]);

function isAsciiLetter(character: string): boolean {
  return /[A-Za-z]/.test(character);
}

function skipWhitespace(text: string, start: number): number {
  let cursor = start;
  while (cursor < text.length && /\s/.test(text[cursor])) cursor++;
  return cursor;
}

function isEscaped(text: string, index: number): boolean {
  let backslashes = 0;
  for (let cursor = index - 1; cursor >= 0 && text[cursor] === "\\"; cursor--) {
    backslashes++;
  }
  return backslashes % 2 === 1;
}

function scanBalanced(
  text: string,
  openIndex: number,
  openCharacter: "{" | "[",
  closeCharacter: "}" | "]"
): { contentStart: number; contentEnd: number; end: number } | undefined {
  let depth = 1;
  let cursor = openIndex + 1;
  while (cursor < text.length) {
    const character = text[cursor];
    if (!isEscaped(text, cursor)) {
      if (character === openCharacter) depth++;
      else if (character === closeCharacter) {
        depth--;
        if (depth === 0) {
          return { contentStart: openIndex + 1, contentEnd: cursor, end: cursor + 1 };
        }
      }
    }
    cursor++;
  }
  return undefined;
}

function splitTargets(
  sourceId: SourceId,
  text: string,
  payloadStart: number,
  payloadEnd: number,
  commaSeparated: boolean
): DirectiveTarget[] {
  const targets: DirectiveTarget[] = [];
  const payload = text.slice(payloadStart, payloadEnd);
  const pieces = commaSeparated ? payload.split(",") : [payload];
  let offset = 0;

  for (const piece of pieces) {
    const leading = piece.length - piece.trimStart().length;
    const targetRaw = piece.trim();
    if (targetRaw) {
      const startUtf16 = payloadStart + offset + leading;
      targets.push({
        targetRaw,
        targetSpan: {
          sourceId,
          startUtf16,
          endUtf16: startUtf16 + targetRaw.length,
        },
      });
    }
    offset += piece.length + (commaSeparated ? 1 : 0);
  }

  return targets;
}

export function scanDirectives(sourceId: SourceId, text: string): ScannedDirective[] {
  const sightings: ScannedDirective[] = [];
  let cursor = 0;

  while (cursor < text.length) {
    if (text[cursor] !== "\\") {
      cursor++;
      continue;
    }

    const commandStart = cursor;
    const nameStart = cursor + 1;
    if (nameStart >= text.length) break;

    // A control symbol consumes the following non-letter. Advancing over both
    // characters prevents the second slash of `\\\\input` becoming a command.
    if (!isAsciiLetter(text[nameStart])) {
      cursor = Math.min(text.length, nameStart + 1);
      continue;
    }

    let nameEnd = nameStart;
    while (nameEnd < text.length && isAsciiLetter(text[nameEnd])) nameEnd++;
    const command = text.slice(nameStart, nameEnd) as ScannedDirective["command"];
    const directive = DIRECTIVES.get(command);
    if (!directive) {
      cursor = nameEnd;
      continue;
    }

    let argumentStart = skipWhitespace(text, nameEnd);
    if (command === "addbibresource" && text[argumentStart] === "[") {
      const optional = scanBalanced(text, argumentStart, "[", "]");
      if (!optional) {
        cursor = nameEnd;
        continue;
      }
      argumentStart = skipWhitespace(text, optional.end);
    }

    let payloadStart: number;
    let payloadEnd: number;
    let directiveEnd: number;
    if (text[argumentStart] === "{") {
      const braced = scanBalanced(text, argumentStart, "{", "}");
      if (!braced) {
        cursor = nameEnd;
        continue;
      }
      payloadStart = braced.contentStart;
      payloadEnd = braced.contentEnd;
      directiveEnd = braced.end;
    } else {
      // TeX's literal bare filename form. A control sequence or grouping token
      // starts a dynamic/non-literal argument and therefore produces no edge.
      if (
        argumentStart >= text.length ||
        text[argumentStart] === "\\" ||
        text[argumentStart] === "[" ||
        text[argumentStart] === "]" ||
        text[argumentStart] === "}"
      ) {
        cursor = nameEnd;
        continue;
      }
      payloadStart = argumentStart;
      directiveEnd = argumentStart;
      while (
        directiveEnd < text.length &&
        !/\s/.test(text[directiveEnd]) &&
        text[directiveEnd] !== "\\" &&
        text[directiveEnd] !== "{" &&
        text[directiveEnd] !== "}" &&
        text[directiveEnd] !== "%"
      ) {
        directiveEnd++;
      }
      payloadEnd = directiveEnd;
    }

    const targets = splitTargets(
      sourceId,
      text,
      payloadStart,
      payloadEnd,
      command === "bibliography"
    );
    if (targets.length > 0) {
      sightings.push({
        command,
        directive,
        span: { sourceId, startUtf16: commandStart, endUtf16: directiveEnd },
        targets,
      });
    }
    cursor = Math.max(directiveEnd, nameEnd);
  }

  return sightings;
}
