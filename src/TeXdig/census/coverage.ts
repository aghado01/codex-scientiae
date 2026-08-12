/**
 * TeXdig coverage accounting and gate evaluation.
 *
 * Computes exact UTF-16 code unit coverage over every parsed source file,
 * identifies all residue spans, and evaluates Gate 1 (Coverage) and Gate 2 (Agreement).
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type {
  SourceId,
  SourceSpan,
  PillarClaim,
  SourceCoverage,
  Diagnostic,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";

export interface Interval {
  start: number;
  end: number;
}

export function mergeIntervals(intervals: Interval[]): Interval[] {
  if (intervals.length === 0) return [];

  // Sort by start, then end
  const sorted = intervals
    .filter(iv => iv.start < iv.end)
    .sort((a, b) => a.start - b.start || a.end - b.end);

  if (sorted.length === 0) return [];

  const merged: Interval[] = [sorted[0]];

  for (let i = 1; i < sorted.length; i++) {
    const current = sorted[i];
    const last = merged[merged.length - 1];

    if (current.start <= last.end) {
      last.end = Math.max(last.end, current.end);
    } else {
      merged.push(current);
    }
  }

  return merged;
}

export function computeSourceCoverage(
  sourceId: SourceId,
  lengthUtf16: number,
  claims: PillarClaim[]
): { coverage: SourceCoverage; diagnostics: Diagnostic[] } {
  const diagnostics: Diagnostic[] = [];

  const rawIntervals: Interval[] = claims.map(c => ({
    start: Math.max(0, c.span.startUtf16),
    end: Math.min(lengthUtf16, c.span.endUtf16),
  }));

  const merged = mergeIntervals(rawIntervals);

  let claimedUtf16 = 0;
  for (const iv of merged) {
    claimedUtf16 += iv.end - iv.start;
  }

  // Find residue gaps
  const residue: SourceSpan[] = [];
  let cursor = 0;

  for (const iv of merged) {
    if (iv.start > cursor) {
      residue.push({
        sourceId,
        startUtf16: cursor,
        endUtf16: iv.start,
      });
    }
    cursor = Math.max(cursor, iv.end);
  }

  if (cursor < lengthUtf16) {
    residue.push({
      sourceId,
      startUtf16: cursor,
      endUtf16: lengthUtf16,
    });
  }

  const residueUtf16 = lengthUtf16 - claimedUtf16;

  // Emit diagnostic for each residue span
  for (const r of residue) {
    diagnostics.push({
      code: DiagnosticCodes.Residue,
      severity: "warning",
      message: `Unclaimed residue span [${r.startUtf16}, ${r.endUtf16}] (${r.endUtf16 - r.startUtf16} UTF-16 units)`,
      span: r,
    });
  }

  return {
    coverage: {
      sourceId,
      lengthUtf16,
      claimedUtf16,
      residueUtf16,
      residue,
    },
    diagnostics,
  };
}
