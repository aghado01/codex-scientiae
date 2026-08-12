/**
 * TeXdig pillar claims overlay generator.
 *
 * Emits positive claims across the three pillars:
 * - envelope: document structure and structural markers
 * - spine: positive text runs and prose stream
 * - fence: environments, math carriers, verbatim, comments, and bib entries
 *
 * Spine claims are POSITIVE claims, never defined as the complement.
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type {
  SourceId,
  SourceSpan,
  CensusEntity,
  PillarClaim,
  Pillar,
} from "../core/types.ts";

export interface SpineRun {
  span: SourceSpan;
  /** `text-run` for content, `blank-run` for pure whitespace. */
  role: "text-run" | "blank-run";
}

export function generatePillarClaims(
  sourceId: SourceId,
  entities: CensusEntity[],
  spineRuns: SpineRun[],
  extraClaims: PillarClaim[]
): PillarClaim[] {
  const claims: PillarClaim[] = [...extraClaims];

  // 1. Claims from Census Entities
  for (const ent of entities) {
    let pillar: Pillar = "fence";
    let role = ent.kind;

    switch (ent.kind) {
      case "envelope-marker":
        pillar = "envelope";
        role = ent.marker;
        break;
      case "environment":
        pillar = "fence";
        role = ent.role;
        break;
      case "math":
        pillar = "fence";
        role = `math:${ent.mode}`;
        break;
      case "verbatim-inline":
        pillar = "fence";
        role = "verbatim-inline";
        break;
      case "comment":
        pillar = "fence";
        role = "comment";
        break;
      case "macro-definition":
        pillar = "envelope";
        role = `macro-def:${ent.definedName}`;
        break;
      case "environment-definition":
        pillar = "envelope";
        role = `env-def:${ent.definedName}`;
        break;
      case "include":
        pillar = "envelope";
        role = `include:${ent.directive}`;
        break;
      case "macro-invocation":
        pillar = "envelope";
        role = `macro:${ent.name}`;
        break;
      case "bib-entry":
        pillar = "fence";
        role = `bib-entry:${ent.entryType}`;
        break;
      case "bib-string":
        pillar = "fence";
        role = `bib-string:${ent.abbreviationName}`;
        break;
      case "bib-preamble":
        pillar = "fence";
        role = "bib-preamble";
        break;
      case "bib-comment":
        pillar = "spine";
        role = "bib-comment";
        break;
      case "bib-field":
        pillar = "fence";
        role = `bib-field:${ent.fieldName}`;
        break;
    }

    claims.push({
      pillar,
      entityId: ent.id,
      span: ent.span,
      role,
    });
  }

  // 2. Positive Spine Claims from Text Runs
  for (const tr of spineRuns) {
    claims.push({
      pillar: "spine",
      span: tr.span,
      role: tr.role,
    });
  }

  return claims;
}
