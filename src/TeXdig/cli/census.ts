/**
 * TeXdig census CLI worker.
 *
 * Entrypoint: node src/TeXdig/cli/census.ts --article <dir> --deps <dir> --out <container>
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import fs from "node:fs";
import path from "node:path";
import { loadDependencies } from "../core/loader.ts";
import { buildSourceGraph } from "../census/source-graph.ts";
import { scanLatex } from "../census/scan-latex.ts";
import { scanBib } from "../census/scan-bib.ts";
import { parseLatex } from "../census/parse-latex.ts";
import { parseBib } from "../census/parse-bib.ts";
import { reconcileLatex, reconcileBib } from "../census/reconcile.ts";
import { generatePillarClaims } from "../census/claims.ts";
import { computeSourceCoverage } from "../census/coverage.ts";
import { emitCensusBundle } from "../census/emit.ts";
import type {
  CensusEntity,
  PillarClaim,
  SourceCoverage,
  Diagnostic,
} from "../core/types.ts";

interface CliArgs {
  articleDir: string;
  depsDir: string;
  outDir: string;
}

function parseArgs(): CliArgs {
  const args = process.argv.slice(2);
  let articleDir = "";
  let depsDir = "";
  let outDir = "";

  for (let i = 0; i < args.length; i++) {
    if (args[i] === "--article" && i + 1 < args.length) {
      articleDir = args[++i];
    } else if (args[i] === "--deps" && i + 1 < args.length) {
      depsDir = args[++i];
    } else if (args[i] === "--out" && i + 1 < args.length) {
      outDir = args[++i];
    }
  }

  if (!articleDir) {
    console.error("Error: --article <directory> is required");
    process.exit(1);
  }
  if (!depsDir) {
    console.error("Error: --deps <directory> is required");
    process.exit(1);
  }
  if (!outDir) {
    console.error("Error: --out <directory> is required");
    process.exit(1);
  }

  return { articleDir, depsDir, outDir };
}

export async function runCensus(options: CliArgs) {
  const resolvedArticleDir = path.resolve(options.articleDir);
  const articleJsonPath = fs.statSync(resolvedArticleDir).isDirectory()
    ? path.join(resolvedArticleDir, "article.json")
    : resolvedArticleDir;

  if (!fs.existsSync(articleJsonPath)) {
    throw new Error(`article.json not found at '${articleJsonPath}'`);
  }

  const articleRaw = fs.readFileSync(articleJsonPath, "utf-8");
  const article = JSON.parse(articleRaw);

  const slug = article.slug || path.basename(resolvedArticleDir);
  const docDir = path.dirname(articleJsonPath);

  // Locate source tree
  let treeRelPath = `${slug}-tex`;
  let treeSha256 = "";
  let entrypoint = "";

  if (article.source_forms && Array.isArray(article.source_forms)) {
    const treeForm = article.source_forms.find(
      (f: any) => f.role === "latex-source-tree"
    );
    if (treeForm) {
      treeRelPath = treeForm.path || treeRelPath;
      treeSha256 = treeForm.sha256 || "";
      entrypoint = treeForm.entrypoint || "";
    }
  }

  if (!entrypoint && article.evidence?.latex_source?.entrypoint) {
    entrypoint = article.evidence.latex_source.entrypoint;
  }

  if (!entrypoint) {
    entrypoint = "main.tex";
  }

  const treeDir = path.join(docDir, treeRelPath);
  if (!fs.existsSync(treeDir)) {
    throw new Error(`Source tree directory not found at '${treeDir}'`);
  }

  // Load dependencies
  const deps = loadDependencies(options.depsDir);

  // Build source graph
  const graph = buildSourceGraph(treeDir, entrypoint);

  const allEntities: CensusEntity[] = [];
  const allClaims: PillarClaim[] = [];
  const allCoverage: SourceCoverage[] = [];
  const allDiagnostics: Diagnostic[] = [...graph.diagnostics];

  // Process all files
  for (const record of graph.sources) {
    if (!record.parsed) continue;

    const rawText = graph.rawContents.get(record.id) || "";
    if (record.language === "latex") {
      const strat = graph.stratifications.get(record.id) || {
        sourceId: record.id,
        strata: [],
        stratifiedText: rawText,
      };

      const lexSightings = scanLatex(record.id, rawText);
      const parseResult = parseLatex(record.id, rawText, deps);
      const reconcileResult = reconcileLatex(
        record.id,
        rawText,
        strat,
        lexSightings,
        parseResult
      );

      const claims = generatePillarClaims(
        record.id,
        reconcileResult.entities,
        parseResult.textRuns
      );

      const cov = computeSourceCoverage(record.id, record.lengthUtf16, claims);

      allEntities.push(...reconcileResult.entities);
      allClaims.push(...claims);
      allCoverage.push(cov.coverage);
      allDiagnostics.push(...reconcileResult.diagnostics, ...cov.diagnostics);
    } else if (record.language === "bibtex") {
      const lexSightings = scanBib(record.id, rawText);
      const parseResult = parseBib(record.id, rawText, deps);
      const reconcileResult = reconcileBib(
        record.id,
        rawText,
        lexSightings,
        parseResult
      );

      const claims = generatePillarClaims(
        record.id,
        reconcileResult.entities,
        []
      );

      const cov = computeSourceCoverage(record.id, record.lengthUtf16, claims);

      allEntities.push(...reconcileResult.entities);
      allClaims.push(...claims);
      allCoverage.push(cov.coverage);
      allDiagnostics.push(...reconcileResult.diagnostics, ...cov.diagnostics);
    }
  }

  // Emit bundle
  const summary = emitCensusBundle(
    {
      slug,
      treeSha256,
      entrypoint,
      sources: graph.sources,
      entities: allEntities,
      claims: allClaims,
      coverage: allCoverage,
      diagnostics: allDiagnostics,
      rawContents: graph.rawContents,
    },
    options.outDir
  );

  console.log(`Census complete for ${slug}`);
  console.log(`Sources: ${summary.sourceCount} (parsed: ${allCoverage.length})`);
  console.log(`Entities: ${allEntities.length}`);
  console.log(`Claims: ${allClaims.length}`);
  console.log(`Coverage: claimed ${summary.coverage.claimedUtf16} / ${summary.coverage.totalUtf16} UTF-16 units (${summary.coverage.residueSegments} residue segments)`);
  console.log(`Diagnostics: ${allDiagnostics.length} total (${summary.diagnosticCounts.defect || 0} defects, ${summary.diagnosticCounts.warning || 0} warnings, ${summary.diagnosticCounts.info || 0} info)`);

  return summary;
}

// Execute if run directly from CLI
if (import.meta.url === `file:///${process.argv[1].replace(/\\/g, "/")}`) {
  const options = parseArgs();
  runCensus(options).catch((err) => {
    console.error("Census fatal error:", err);
    process.exit(1);
  });
}
