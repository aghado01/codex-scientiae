/**
 * Raw UTF-16 argument attachment for bound TeX occurrences.
 *
 * The supported signature vocabulary is `m`, `o`, `O{default}`, and `s`.
 * Other xparse forms remain structured deferred evidence. Slot numbers are
 * zero-based and follow signature order.
 *
 * Erasable-syntax TypeScript only (Node native type stripping).
 */

import type { ArgumentAttachment } from "../core/contracts.ts";
import type { SignatureEvidence, SourceSpan } from "../core/types.ts";

export type SupportedSignatureSlot =
  | { kind: "mandatory"; specifier: "m" }
  | { kind: "optional"; specifier: "o" }
  | { kind: "optional-default"; specifier: "O"; defaultText: string }
  | { kind: "star"; specifier: "s" };

export type SignatureDeferredReason =
  | "custom-parser"
  | "unknown-signature"
  | "unsupported-signature"
  | "invalid-signature";

export type AttachmentDeferredReason =
  | SignatureDeferredReason
  | "control-sequence-boundary-unavailable";

/** Canonical physical-token evidence available at this source occurrence. */
export interface ArgumentAttachmentOptions {
  controlSequenceSpans?: readonly SourceSpan[];
}

/** Literal source-graph evidence for one executable include directive. */
export interface LiteralIncludeEvidence {
  directiveSpan: SourceSpan;
  targetRaw: string;
  targetSpan?: SourceSpan;
}

export type SignatureParseResult =
  | {
      status: "supported";
      spec: string;
      slots: SupportedSignatureSlot[];
    }
  | {
      status: "deferred";
      reason: SignatureDeferredReason;
      detail: string;
      offset?: number;
    };

export type AttachmentMalformedReason =
  | "missing-mandatory"
  | "unclosed-brace"
  | "unclosed-bracket"
  | "incomplete-control-sequence";

export type InvocationAttachmentResult =
  | {
      status: "attached";
      span: SourceSpan;
      arguments: ArgumentAttachment[];
    }
  | {
      status: "deferred";
      span: SourceSpan;
      arguments: [];
      reason: AttachmentDeferredReason;
      detail: string;
      offset?: number;
    }
  | {
      status: "malformed";
      span: SourceSpan;
      arguments: ArgumentAttachment[];
      slot: number;
      reason: AttachmentMalformedReason;
      detail: string;
      errorSpan: SourceSpan;
    };

type ClosedDelimiter = {
  closed: true;
  endUtf16: number;
  contentEndUtf16: number;
};

type UnclosedDelimiter = {
  closed: false;
};

type DelimiterScan = ClosedDelimiter | UnclosedDelimiter;

function sourceSpan(siteSpan: SourceSpan, startUtf16: number, endUtf16: number): SourceSpan {
  return { sourceId: siteSpan.sourceId, startUtf16, endUtf16 };
}

function isAsciiLetter(character: string): boolean {
  return (
    (character >= "A" && character <= "Z") ||
    (character >= "a" && character <= "z")
  );
}

function isTeXWhitespace(character: string): boolean {
  return (
    character === " " ||
    character === "\t" ||
    character === "\r" ||
    character === "\n" ||
    character === "\f"
  );
}

function codePointWidth(text: string, offset: number): number {
  const point = text.codePointAt(offset);
  return point !== undefined && point > 0xffff ? 2 : 1;
}

/** End of one physical control-sequence token, excluding following trivia. */
function controlSequenceEnd(text: string, startUtf16: number): number | undefined {
  if (text[startUtf16] !== "\\" || startUtf16 + 1 >= text.length) return undefined;

  let cursor = startUtf16 + 1;
  if (isAsciiLetter(text[cursor])) {
    cursor += 1;
    while (cursor < text.length && isAsciiLetter(text[cursor])) cursor += 1;
    return cursor;
  }

  return cursor + codePointWidth(text, cursor);
}

type EvidencedControlSequenceEnd =
  | { status: "known"; endUtf16: number }
  | { status: "unavailable" };

function evidencedControlSequenceEnd(
  text: string,
  siteSpan: SourceSpan,
  startUtf16: number,
  options: ArgumentAttachmentOptions
): EvidencedControlSequenceEnd | undefined {
  if (text[startUtf16] !== "\\" || startUtf16 + 1 >= text.length) return undefined;

  const matchingEnds = new Set<number>();
  for (const span of options.controlSequenceSpans ?? []) {
    if (span.sourceId !== siteSpan.sourceId || span.startUtf16 !== startUtf16) continue;
    if (
      !Number.isInteger(span.endUtf16)
      || span.endUtf16 <= startUtf16 + 1
      || span.endUtf16 > text.length
    ) {
      throw new RangeError("controlSequenceSpans must be bounded physical token spans.");
    }
    matchingEnds.add(span.endUtf16);
  }
  if (matchingEnds.size > 1) {
    throw new RangeError(`Conflicting physical control-sequence spans at UTF-16 offset ${startUtf16}.`);
  }
  const evidencedEnd = matchingEnds.values().next().value as number | undefined;
  if (evidencedEnd !== undefined) return { status: "known", endUtf16: evidencedEnd };

  const ordinaryEnd = controlSequenceEnd(text, startUtf16);
  if (ordinaryEnd === undefined) return undefined;
  const first = text[startUtf16 + 1];
  if (first === "@" || text[ordinaryEnd] === "@") return { status: "unavailable" };
  return { status: "known", endUtf16: ordinaryEnd };
}

/** Skip TeX whitespace and comments. The returned coordinate remains raw UTF-16. */
function skipTrivia(text: string, startUtf16: number): number {
  let cursor = startUtf16;
  while (cursor < text.length) {
    if (isTeXWhitespace(text[cursor])) {
      cursor += 1;
      continue;
    }
    if (text[cursor] !== "%") break;

    cursor += 1;
    while (cursor < text.length && text[cursor] !== "\r" && text[cursor] !== "\n") {
      cursor += 1;
    }
    if (text[cursor] === "\r" && text[cursor + 1] === "\n") cursor += 2;
    else if (cursor < text.length) cursor += 1;
  }
  return cursor;
}

/** Scan a brace group while ignoring delimiter characters in comments and control sequences. */
function scanBraceGroup(text: string, openUtf16: number): DelimiterScan {
  let depth = 1;
  let cursor = openUtf16 + 1;

  while (cursor < text.length) {
    const character = text[cursor];
    if (character === "\\") {
      const tokenEnd = controlSequenceEnd(text, cursor);
      cursor = tokenEnd ?? text.length;
      continue;
    }
    if (character === "%") {
      cursor = skipTrivia(text, cursor);
      continue;
    }
    if (character === "{") {
      depth += 1;
      cursor += 1;
      continue;
    }
    if (character === "}") {
      depth -= 1;
      if (depth === 0) {
        return { closed: true, contentEndUtf16: cursor, endUtf16: cursor + 1 };
      }
    }
    cursor += codePointWidth(text, cursor);
  }

  return { closed: false };
}

/** Scan a bracket group with brace-protected and nested bracket content. */
function scanBracketGroup(text: string, openUtf16: number): DelimiterScan {
  let bracketDepth = 1;
  let braceDepth = 0;
  let cursor = openUtf16 + 1;

  while (cursor < text.length) {
    const character = text[cursor];
    if (character === "\\") {
      const tokenEnd = controlSequenceEnd(text, cursor);
      cursor = tokenEnd ?? text.length;
      continue;
    }
    if (character === "%") {
      cursor = skipTrivia(text, cursor);
      continue;
    }
    if (character === "{") {
      braceDepth += 1;
      cursor += 1;
      continue;
    }
    if (character === "}" && braceDepth > 0) {
      braceDepth -= 1;
      cursor += 1;
      continue;
    }
    if (braceDepth === 0 && character === "[") {
      bracketDepth += 1;
      cursor += 1;
      continue;
    }
    if (braceDepth === 0 && character === "]") {
      bracketDepth -= 1;
      if (bracketDepth === 0) {
        return { closed: true, contentEndUtf16: cursor, endUtf16: cursor + 1 };
      }
    }
    cursor += codePointWidth(text, cursor);
  }

  return { closed: false };
}

function unsupportedSignature(spec: string, offset: number): SignatureParseResult {
  const point = spec.codePointAt(offset);
  const token = point === undefined ? "end of signature" : JSON.stringify(String.fromCodePoint(point));
  return {
    status: "deferred",
    reason: "unsupported-signature",
    detail: `Unsupported signature form at UTF-16 offset ${offset}: ${token}.`,
    offset,
  };
}

/** Parse a known signature without attaching source text. */
export function parseKnownSignatureSpec(spec: string): SignatureParseResult {
  const slots: SupportedSignatureSlot[] = [];
  let cursor = 0;

  while (true) {
    cursor = skipTrivia(spec, cursor);
    if (cursor >= spec.length) return { status: "supported", spec, slots };

    const specifier = spec[cursor];
    if (specifier === "m") {
      slots.push({ kind: "mandatory", specifier: "m" });
      cursor += 1;
      continue;
    }
    if (specifier === "o") {
      slots.push({ kind: "optional", specifier: "o" });
      cursor += 1;
      continue;
    }
    if (specifier === "s") {
      slots.push({ kind: "star", specifier: "s" });
      cursor += 1;
      continue;
    }
    if (specifier !== "O") return unsupportedSignature(spec, cursor);

    const defaultOpen = skipTrivia(spec, cursor + 1);
    if (spec[defaultOpen] !== "{") {
      return {
        status: "deferred",
        reason: "invalid-signature",
        detail: `O at UTF-16 offset ${cursor} requires a braced default.`,
        offset: cursor,
      };
    }
    const group = scanBraceGroup(spec, defaultOpen);
    if (!group.closed) {
      return {
        status: "deferred",
        reason: "invalid-signature",
        detail: `Unclosed O default beginning at UTF-16 offset ${defaultOpen}.`,
        offset: defaultOpen,
      };
    }
    slots.push({
      kind: "optional-default",
      specifier: "O",
      defaultText: spec.slice(defaultOpen + 1, group.contentEndUtf16),
    });
    cursor = group.endUtf16;
  }
}

/** Resolve the signature-evidence state into a supported or deferred parse. */
export function parseAttachmentSignature(signature: SignatureEvidence): SignatureParseResult {
  if (signature.state === "known") return parseKnownSignatureSpec(signature.spec);
  if (signature.state === "custom-parser") {
    return {
      status: "deferred",
      reason: "custom-parser",
      detail: signature.detail,
    };
  }
  return {
    status: "deferred",
    reason: "unknown-signature",
    detail: signature.detail ?? "No argument signature is known at this occurrence.",
  };
}

function validateSiteSpan(rawText: string, siteSpan: SourceSpan): void {
  if (
    typeof siteSpan.sourceId !== "string" ||
    siteSpan.sourceId.length === 0 ||
    !Number.isInteger(siteSpan.startUtf16) ||
    !Number.isInteger(siteSpan.endUtf16) ||
    siteSpan.startUtf16 < 0 ||
    siteSpan.endUtf16 < siteSpan.startUtf16 ||
    siteSpan.endUtf16 > rawText.length
  ) {
    throw new RangeError("siteSpan must be a bounded UTF-16 span on the supplied raw text.");
  }
}

function malformedResult(
  siteSpan: SourceSpan,
  argumentsSoFar: ArgumentAttachment[],
  hullEndUtf16: number,
  slot: number,
  reason: AttachmentMalformedReason,
  detail: string,
  errorStartUtf16: number,
  errorEndUtf16: number
): InvocationAttachmentResult {
  return {
    status: "malformed",
    span: sourceSpan(siteSpan, siteSpan.startUtf16, hullEndUtf16),
    arguments: argumentsSoFar,
    slot,
    reason,
    detail,
    errorSpan: sourceSpan(siteSpan, errorStartUtf16, errorEndUtf16),
  };
}

/**
 * Attach supported arguments from exact raw text after `siteSpan.endUtf16`.
 * Omitted lookahead does not consume trivia. Parser coordinates are not used.
 */
export function attachInvocationArguments(
  rawText: string,
  siteSpan: SourceSpan,
  signature: SignatureEvidence,
  options: ArgumentAttachmentOptions = {}
): InvocationAttachmentResult {
  validateSiteSpan(rawText, siteSpan);

  const parsed = parseAttachmentSignature(signature);
  if (parsed.status === "deferred") {
    return {
      status: "deferred",
      span: { ...siteSpan },
      arguments: [],
      reason: parsed.reason,
      detail: parsed.detail,
      ...(parsed.offset === undefined ? {} : { offset: parsed.offset }),
    };
  }

  const argumentsAttached: ArgumentAttachment[] = [];
  let cursor = siteSpan.endUtf16;
  let hullEndUtf16 = siteSpan.endUtf16;

  for (let slot = 0; slot < parsed.slots.length; slot += 1) {
    const signatureSlot = parsed.slots[slot];
    const candidate = skipTrivia(rawText, cursor);

    if (signatureSlot.kind === "star") {
      if (rawText[candidate] === "*") {
        const span = sourceSpan(siteSpan, candidate, candidate + 1);
        argumentsAttached.push({
          slot,
          kind: "star",
          source: "explicit",
          delimiter: "none",
          span,
          marker: "*",
        });
        cursor = candidate + 1;
        hullEndUtf16 = cursor;
      } else {
        argumentsAttached.push({
          slot,
          kind: "star",
          source: "omitted",
          delimiter: "none",
        });
      }
      continue;
    }

    if (signatureSlot.kind === "optional" || signatureSlot.kind === "optional-default") {
      if (rawText[candidate] !== "[") {
        if (signatureSlot.kind === "optional-default") {
          argumentsAttached.push({
            slot,
            kind: "optional",
            source: "default",
            delimiter: "none",
            defaultText: signatureSlot.defaultText,
          });
        } else {
          argumentsAttached.push({
            slot,
            kind: "optional",
            source: "omitted",
            delimiter: "none",
          });
        }
        continue;
      }

      const bracket = scanBracketGroup(rawText, candidate);
      if (!bracket.closed) {
        return malformedResult(
          siteSpan,
          argumentsAttached,
          rawText.length,
          slot,
          "unclosed-bracket",
          `Optional argument in slot ${slot} has no closing bracket.`,
          candidate,
          rawText.length
        );
      }
      const span = sourceSpan(siteSpan, candidate, bracket.endUtf16);
      argumentsAttached.push({
        slot,
        kind: "optional",
        source: "explicit",
        delimiter: "bracket",
        span,
        contentSpan: sourceSpan(siteSpan, candidate + 1, bracket.contentEndUtf16),
      });
      cursor = bracket.endUtf16;
      hullEndUtf16 = cursor;
      continue;
    }

    if (candidate >= rawText.length) {
      return malformedResult(
        siteSpan,
        argumentsAttached,
        hullEndUtf16,
        slot,
        "missing-mandatory",
        `Mandatory argument in slot ${slot} is absent.`,
        candidate,
        candidate
      );
    }

    if (rawText[candidate] === "{") {
      const group = scanBraceGroup(rawText, candidate);
      if (!group.closed) {
        return malformedResult(
          siteSpan,
          argumentsAttached,
          rawText.length,
          slot,
          "unclosed-brace",
          `Mandatory argument in slot ${slot} has no closing brace.`,
          candidate,
          rawText.length
        );
      }
      const span = sourceSpan(siteSpan, candidate, group.endUtf16);
      argumentsAttached.push({
        slot,
        kind: "mandatory",
        source: "explicit",
        delimiter: "brace",
        span,
        contentSpan: sourceSpan(siteSpan, candidate + 1, group.contentEndUtf16),
      });
      cursor = group.endUtf16;
      hullEndUtf16 = cursor;
      continue;
    }

    if (rawText[candidate] === "\\") {
      const token = evidencedControlSequenceEnd(rawText, siteSpan, candidate, options);
      if (token === undefined) {
        return malformedResult(
          siteSpan,
          argumentsAttached,
          rawText.length,
          slot,
          "incomplete-control-sequence",
          `Mandatory argument in slot ${slot} ends with an incomplete control sequence.`,
          candidate,
          rawText.length
        );
      }
      if (token.status === "unavailable") {
        return {
          status: "deferred",
          span: { ...siteSpan },
          arguments: [],
          reason: "control-sequence-boundary-unavailable",
          detail: `Mandatory argument in slot ${slot} has an @-sensitive control-sequence boundary without canonical token evidence.`,
          offset: candidate,
        };
      }
      const tokenEnd = token.endUtf16;
      const span = sourceSpan(siteSpan, candidate, tokenEnd);
      argumentsAttached.push({
        slot,
        kind: "mandatory",
        source: "explicit",
        delimiter: "control-sequence",
        span,
        contentSpan: span,
      });
      cursor = tokenEnd;
      hullEndUtf16 = cursor;
      continue;
    }

    const tokenEnd = candidate + codePointWidth(rawText, candidate);
    const span = sourceSpan(siteSpan, candidate, tokenEnd);
    argumentsAttached.push({
      slot,
      kind: "mandatory",
      source: "explicit",
      delimiter: "bare-character",
      span,
      contentSpan: span,
    });
    cursor = tokenEnd;
    hullEndUtf16 = cursor;
  }

  return {
    status: "attached",
    span: sourceSpan(siteSpan, siteSpan.startUtf16, hullEndUtf16),
    arguments: argumentsAttached,
  };
}

function sameSpan(left: SourceSpan, right: SourceSpan): boolean {
  return left.sourceId === right.sourceId
    && left.startUtf16 === right.startUtf16
    && left.endUtf16 === right.endUtf16;
}

function containsSpan(container: SourceSpan, contained: SourceSpan): boolean {
  return container.sourceId === contained.sourceId
    && container.startUtf16 <= contained.startUtf16
    && contained.endUtf16 <= container.endUtf16;
}

/**
 * Attach a literal `\\input`, `\\include`, or `\\subfile` filename from
 * canonical census/source-graph evidence. Dynamic filename syntax is not
 * accepted by this primitive.
 */
export function attachLiteralIncludeInvocation(
  rawText: string,
  siteSpan: SourceSpan,
  evidence: LiteralIncludeEvidence
): InvocationAttachmentResult {
  validateSiteSpan(rawText, siteSpan);
  validateSiteSpan(rawText, evidence.directiveSpan);
  if (
    evidence.directiveSpan.sourceId !== siteSpan.sourceId
    || evidence.directiveSpan.startUtf16 !== siteSpan.startUtf16
    || !containsSpan(evidence.directiveSpan, siteSpan)
  ) {
    throw new RangeError("Literal include directiveSpan must contain and share the start of siteSpan.");
  }
  const command = rawText.slice(siteSpan.startUtf16 + 1, siteSpan.endUtf16);
  if (command !== "input" && command !== "include" && command !== "subfile") {
    throw new RangeError(`Literal include attachment does not support \\${command}.`);
  }
  if (evidence.targetRaw.length === 0) {
    throw new RangeError("Literal include targetRaw must be non-empty.");
  }

  let candidate = skipTrivia(rawText, siteSpan.endUtf16);
  let targetSpan = evidence.targetSpan;
  if (targetSpan !== undefined) {
    validateSiteSpan(rawText, targetSpan);
    if (!containsSpan(evidence.directiveSpan, targetSpan)) {
      throw new RangeError("Literal include targetSpan must be contained by directiveSpan.");
    }
    if (rawText.slice(targetSpan.startUtf16, targetSpan.endUtf16) !== evidence.targetRaw) {
      throw new RangeError("Literal include targetSpan contradicts targetRaw.");
    }
  }

  if (rawText[candidate] === "{") {
    const group = scanBraceGroup(rawText, candidate);
    if (!group.closed || group.endUtf16 !== evidence.directiveSpan.endUtf16) {
      throw new RangeError("Literal braced include evidence does not match its directiveSpan.");
    }
    const contentSpan = sourceSpan(siteSpan, candidate + 1, group.contentEndUtf16);
    if (rawText.slice(contentSpan.startUtf16, contentSpan.endUtf16).trim() !== evidence.targetRaw) {
      throw new RangeError("Literal braced include content contradicts targetRaw.");
    }
    if (targetSpan !== undefined && !containsSpan(contentSpan, targetSpan)) {
      throw new RangeError("Literal braced include targetSpan escapes its content span.");
    }
    const span = sourceSpan(siteSpan, candidate, group.endUtf16);
    return {
      status: "attached",
      span: { ...evidence.directiveSpan },
      arguments: [{
        slot: 0,
        kind: "mandatory",
        source: "explicit",
        delimiter: "brace",
        span,
        contentSpan,
      }],
    };
  }

  targetSpan ??= sourceSpan(siteSpan, candidate, candidate + evidence.targetRaw.length);
  if (
    rawText.slice(targetSpan.startUtf16, targetSpan.endUtf16) !== evidence.targetRaw
    || targetSpan.startUtf16 !== candidate
    || targetSpan.endUtf16 !== evidence.directiveSpan.endUtf16
  ) {
    throw new RangeError("Literal bare include evidence does not match its directiveSpan.");
  }
  const expectedDirective = sourceSpan(
    siteSpan,
    siteSpan.startUtf16,
    targetSpan.endUtf16
  );
  if (!sameSpan(expectedDirective, evidence.directiveSpan)) {
    throw new RangeError("Literal bare include hull contradicts directiveSpan.");
  }
  return {
    status: "attached",
    span: { ...evidence.directiveSpan },
    arguments: [{
      slot: 0,
      kind: "until",
      source: "explicit",
      delimiter: "none",
      span: { ...targetSpan },
      contentSpan: { ...targetSpan },
    }],
  };
}
