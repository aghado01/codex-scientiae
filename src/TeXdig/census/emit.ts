/**
 * TeXdig store emitter.
 *
 * Emits the Evidence Tier (sources.jsonl, entities.jsonl, claims.jsonl) and
 * Audit Tier (coverage.json, diagnostics.jsonl, summary.json) per the landed contract.
 * Slices are extracted directly from raw UTF-16 source strings (never printRaw).
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import fs from "node:fs";
import path from "node:path";
import type {
  SourceFileRecord,
  CensusEntity,
  PillarClaim,
  SourceCoverage,
  Diagnostic,
  CensusSummary,
  SourceId,
} from "../core/types.ts";
import { CENSUS_SCHEMA_VERSION } from "../core/types.ts";

export interface EmitBundle {
  slug: string;
  treeSha256: string;
  entrypoint: SourceId;
  sources: SourceFileRecord[];
  entities: CensusEntity[];
  claims: PillarClaim[];
  coverage: SourceCoverage[];
  diagnostics: Diagnostic[];
  rawContents: Map<SourceId, string>;
  /** Elaboration tier: per-site macro expansions (rows shaped by elaborate/expand.ts). */
  expansionRows?: object[];
}

export function emitCensusBundle(bundle: EmitBundle, outDir: string): CensusSummary {
  const resolvedOutDir = path.resolve(outDir);
  if (!fs.existsSync(resolvedOutDir)) {
    fs.mkdirSync(resolvedOutDir, { recursive: true });
  }

  // 1. sources.jsonl
  const sourcesPath = path.join(resolvedOutDir, "sources.jsonl");
  const sourcesContent = bundle.sources.map(s => JSON.stringify(s)).join("\n") + (bundle.sources.length > 0 ? "\n" : "");
  fs.writeFileSync(sourcesPath, sourcesContent, { encoding: "utf-8" });

  // 2. entities.jsonl (with inline raw slice)
  const entitiesPath = path.join(resolvedOutDir, "entities.jsonl");
  const entityRows = bundle.entities.map(ent => {
    const raw = bundle.rawContents.get(ent.span.sourceId);
    let textSlice = "";
    if (raw) {
      textSlice = raw.slice(ent.span.startUtf16, ent.span.endUtf16);
    }
    return JSON.stringify({
      ...ent,
      text: textSlice,
    });
  });
  const entitiesContent = entityRows.join("\n") + (entityRows.length > 0 ? "\n" : "");
  fs.writeFileSync(entitiesPath, entitiesContent, { encoding: "utf-8" });

  // 3. claims.jsonl
  const claimsPath = path.join(resolvedOutDir, "claims.jsonl");
  const claimsContent = bundle.claims.map(c => JSON.stringify(c)).join("\n") + (bundle.claims.length > 0 ? "\n" : "");
  fs.writeFileSync(claimsPath, claimsContent, { encoding: "utf-8" });

  // 4. coverage.json
  const coveragePath = path.join(resolvedOutDir, "coverage.json");
  fs.writeFileSync(coveragePath, JSON.stringify(bundle.coverage, null, 2) + "\n", { encoding: "utf-8" });

  // 5. diagnostics.jsonl
  const diagnosticsPath = path.join(resolvedOutDir, "diagnostics.jsonl");
  const diagContent = bundle.diagnostics.map(d => JSON.stringify(d)).join("\n") + (bundle.diagnostics.length > 0 ? "\n" : "");
  fs.writeFileSync(diagnosticsPath, diagContent, { encoding: "utf-8" });

  // 5b. expansion.jsonl (elaboration tier, when the lane ran)
  if (bundle.expansionRows) {
    const expansionPath = path.join(resolvedOutDir, "expansion.jsonl");
    const expansionContent = bundle.expansionRows.map(r => JSON.stringify(r)).join("\n") +
      (bundle.expansionRows.length > 0 ? "\n" : "");
    fs.writeFileSync(expansionPath, expansionContent, { encoding: "utf-8" });
  }

  // 6. summary.json
  let totalUtf16 = 0;
  let claimedUtf16 = 0;
  let residueUtf16 = 0;
  let residueSegments = 0;

  for (const cov of bundle.coverage) {
    totalUtf16 += cov.lengthUtf16;
    claimedUtf16 += cov.claimedUtf16;
    residueUtf16 += cov.residueUtf16;
    residueSegments += cov.residue.length;
  }

  const entityCounts: Record<string, number> = {};
  for (const ent of bundle.entities) {
    entityCounts[ent.kind] = (entityCounts[ent.kind] || 0) + 1;
  }

  const agreementCounts: Record<string, number> = {};
  for (const ent of bundle.entities) {
    agreementCounts[ent.agreement] = (agreementCounts[ent.agreement] || 0) + 1;
  }

  const diagnosticCounts: Record<string, number> = {};
  for (const d of bundle.diagnostics) {
    diagnosticCounts[d.severity] = (diagnosticCounts[d.severity] || 0) + 1;
  }

  const summary: CensusSummary = {
    schema: CENSUS_SCHEMA_VERSION,
    slug: bundle.slug,
    treeSha256: bundle.treeSha256,
    entrypoint: bundle.entrypoint,
    stores: {
      emitted: [
        "sources.jsonl",
        "entities.jsonl",
        "claims.jsonl",
        "coverage.json",
        "diagnostics.jsonl",
        "summary.json",
        ...(bundle.expansionRows ? ["expansion.jsonl"] : []),
      ],
      // Contract tier lands in cuts 2–3; declared so absence is a statement.
      deferred: [
        "walk.jsonl",
        "zones.jsonl",
        "macros.jsonl",
        "references.jsonl",
        "pointers.jsonl",
        "frontmatter.jsonl",
        "graph.jsonl",
      ],
    },
    sourceCount: bundle.sources.length,
    entityCounts,
    agreementCounts,
    diagnosticCounts,
    coverage: {
      totalUtf16,
      claimedUtf16,
      residueUtf16,
      residueSegments,
    },
  };

  const summaryPath = path.join(resolvedOutDir, "summary.json");
  fs.writeFileSync(summaryPath, JSON.stringify(summary, null, 2) + "\n", { encoding: "utf-8" });

  return summary;
}
