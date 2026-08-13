/**
 * UTF-16 source-span validation and interval operations.
 *
 * These helpers do not repair coordinates. Callers retain responsibility for
 * diagnosing rejected parser evidence and selecting an alternate witness.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { SourceSpan } from "./types.ts";

export type SpanValidationCode =
  | "missing-source-id"
  | "non-integer-offset"
  | "negative-start"
  | "end-before-start"
  | "invalid-source-length"
  | "end-past-source";

export type SpanValidationResult =
  | { valid: true }
  | { valid: false; code: SpanValidationCode };

/** Validate one half-open UTF-16 span, optionally against its source length. */
export function validateSourceSpan(
  span: SourceSpan,
  sourceLengthUtf16?: number
): SpanValidationResult {
  if (typeof span.sourceId !== "string" || span.sourceId.length === 0) {
    return { valid: false, code: "missing-source-id" };
  }
  if (!Number.isInteger(span.startUtf16) || !Number.isInteger(span.endUtf16)) {
    return { valid: false, code: "non-integer-offset" };
  }
  if (span.startUtf16 < 0) {
    return { valid: false, code: "negative-start" };
  }
  if (span.endUtf16 < span.startUtf16) {
    return { valid: false, code: "end-before-start" };
  }
  if (
    sourceLengthUtf16 !== undefined &&
    (!Number.isInteger(sourceLengthUtf16) || sourceLengthUtf16 < 0)
  ) {
    return { valid: false, code: "invalid-source-length" };
  }
  if (sourceLengthUtf16 !== undefined && span.endUtf16 > sourceLengthUtf16) {
    return { valid: false, code: "end-past-source" };
  }
  return { valid: true };
}

/** Boolean form of validateSourceSpan. */
export function isValidSourceSpan(
  span: SourceSpan,
  sourceLengthUtf16?: number
): boolean {
  return validateSourceSpan(span, sourceLengthUtf16).valid;
}

/** Exact identity of two half-open source spans. */
export function sourceSpansEqual(left: SourceSpan, right: SourceSpan): boolean {
  return (
    left.sourceId === right.sourceId &&
    left.startUtf16 === right.startUtf16 &&
    left.endUtf16 === right.endUtf16
  );
}

/**
 * True when inner is wholly contained by outer on the same source.
 * Zero-length spans are contained at either boundary.
 */
export function sourceSpanContains(outer: SourceSpan, inner: SourceSpan): boolean {
  if (!isValidSourceSpan(outer) || !isValidSourceSpan(inner)) return false;
  return (
    outer.sourceId === inner.sourceId &&
    inner.startUtf16 >= outer.startUtf16 &&
    inner.endUtf16 <= outer.endUtf16
  );
}

/**
 * Smallest half-open span containing every input span.
 * Undefined denotes an empty, invalid, or mixed-source input.
 */
export function sourceSpanHull(spans: readonly SourceSpan[]): SourceSpan | undefined {
  if (spans.length === 0) return undefined;

  const sourceId = spans[0].sourceId;
  let startUtf16 = Infinity;
  let endUtf16 = -Infinity;
  for (const span of spans) {
    if (!isValidSourceSpan(span) || span.sourceId !== sourceId) return undefined;
    if (span.startUtf16 < startUtf16) startUtf16 = span.startUtf16;
    if (span.endUtf16 > endUtf16) endUtf16 = span.endUtf16;
  }

  return { sourceId, startUtf16, endUtf16 };
}
