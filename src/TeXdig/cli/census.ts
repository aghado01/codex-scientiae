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
import {
  discoverDefinitions,
  parseLatexWitness,
  type DiscoveryResult,
  type SignatureRegistry,
} from "../census/parse-latex.ts";
import { parseBib } from "../census/parse-bib.ts";
import { reconcileLatex, reconcileBib } from "../census/reconcile.ts";
import { buildConfiguredChannel, mintConfiguredEntities } from "../census/configured.ts";
import { buildUtensilsIndex, backfillLexicalOnly } from "../census/backfill-utensils.ts";
import { expandDocument, type ExpandDocumentInput } from "../elaborate/expand.ts";
import { generatePillarClaims, type SpineRun } from "../census/claims.ts";
import { computeSourceCoverage } from "../census/coverage.ts";
import { emitCensusBundle } from "../census/emit.ts";
import type {
  CensusEntity,
  PillarClaim,
  SourceCoverage,
  SourceSpan,
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
  let manifestFileCount: number | undefined;

  if (article.source_forms && Array.isArray(article.source_forms)) {
    const treeForm = article.source_forms.find(
      (f: any) => f.role === "latex-source-tree"
    );
    if (treeForm) {
      treeRelPath = treeForm.path || treeRelPath;
      treeSha256 = treeForm.sha256 || "";
      entrypoint = treeForm.entrypoint || "";
      if (typeof treeForm.files === "number") manifestFileCount = treeForm.files;
    }
  }

  if (!entrypoint && article.evidence?.latex_source?.entrypoint) {
    entrypoint = article.evidence.latex_source.entrypoint;
  }

  // No entrypoint in the manifest is a refusal, never a guess: the deposit
  // owns entrypoint selection, and a census attributed to a guessed
  // entrypoint would assert without provenance.
  if (!entrypoint) {
    throw new Error(
      `article.json for '${slug}' carries no entrypoint (source_forms or evidence.latex_source); refusing to guess`
    );
  }

  const treeDir = path.join(docDir, treeRelPath);
  if (!fs.existsSync(treeDir)) {
    throw new Error(`Source tree directory not found at '${treeDir}'`);
  }

  // Load dependencies
  const deps = loadDependencies(options.depsDir);

  // Build source graph (stratification happens inside, before include scanning)
  const graph = buildSourceGraph(treeDir, entrypoint);

  const allEntities: CensusEntity[] = [];
  const allClaims: PillarClaim[] = [];
  const allCoverage: SourceCoverage[] = [];
  const allDiagnostics: Diagnostic[] = [...graph.diagnostics];

  // Attribution guard: the deposit is supposed to be FROZEN. If the manifest's
  // file count no longer matches the walked tree, the tree was modified after
  // deposit and the recorded sha256 does not describe what we are censusing.
  if (manifestFileCount !== undefined && manifestFileCount !== graph.sources.length) {
    allDiagnostics.push({
      code: "census/tree-manifest-mismatch",
      severity: "defect",
      message: `Manifest declares ${manifestFileCount} files but the deposited tree holds ${graph.sources.length}; the tree was modified after deposit and treeSha256 attribution is stale`,
    });
  }

  // ---------------------------------------------------------------------
  // Pass 1 — definition discovery across ALL parsed LaTeX sources, merged
  // into one document-global signature registry: a preamble \newcommand must
  // inform argument attachment in every included file. The configured layer
  // (ctan records for the packages the document summons) merges FIRST;
  // document-discovered definitions overwrite it — the paper always wins.
  // Cross-file name collisions resolve last-wins; true shadowing is a cut-2
  // join.
  // ---------------------------------------------------------------------
  const discoveries = new Map<string, DiscoveryResult>();
  const requestedPackages = new Map<string, SourceSpan>();
  for (const record of graph.sources) {
    if (!record.parsed || record.language !== "latex") continue;
    const strat = graph.stratifications.get(record.id);
    const text = strat ? strat.stratifiedText : graph.rawContents.get(record.id) || "";
    const discovery = discoverDefinitions(record.id, text, deps);
    discoveries.set(record.id, discovery);
    for (const [pkg, site] of discovery.requestedPackages) {
      if (!requestedPackages.has(pkg)) requestedPackages.set(pkg, site);
    }
  }

  const configured = buildConfiguredChannel(requestedPackages, deps);
  if (configured.unresolvedPackages.length > 0) {
    allDiagnostics.push({
      code: "census/configured-gap",
      severity: "info",
      message: `Summoned packages with no configured signature record: ${configured.unresolvedPackages.join(", ")}`,
    });
  }
  const registry: SignatureRegistry = {
    macros: { ...configured.registry.macros },
    environments: { ...configured.registry.environments },
  };
  for (const discovery of discoveries.values()) {
    Object.assign(registry.macros, discovery.registry.macros);
    Object.assign(registry.environments, discovery.registry.environments);
  }

  // ---------------------------------------------------------------------
  // Pass 2 — witness parse + fusion per file. Both witnesses consume the
  // STRATIFIED text: stratification precedes everything, and verbatim
  // interiors must never be censused as LaTeX.
  // ---------------------------------------------------------------------
  for (const record of graph.sources) {
    if (!record.parsed) continue;

    const rawText = graph.rawContents.get(record.id) || "";
    if (record.language === "latex") {
      const strat = graph.stratifications.get(record.id) || {
        sourceId: record.id,
        strata: [],
        stratifiedText: rawText,
        diagnostics: [],
      };
      const discovery = discoveries.get(record.id) || {
        sourceId: record.id,
        macroDefs: [],
        envDefs: [],
        registry: { macros: {}, environments: {} },
        definitionTokenStarts: new Set<number>(),
        requestedPackages: new Map<string, SourceSpan>(),
      };

      const scan = scanLatex(record.id, strat.stratifiedText);
      const witnessResult = parseLatexWitness(record.id, strat.stratifiedText, deps, registry);
      const edges = graph.includeEdges.filter((e) => e.fromSourceId === record.id);
      const reconcileResult = reconcileLatex(
        record.id,
        rawText,
        strat,
        scan.sightings,
        discovery,
        witnessResult,
        edges
      );
      allDiagnostics.push(...scan.diagnostics);

      // Third-instrument backfill: sites only the lexical scanner saw
      // (alignment-environment interiors where unified-latex positions are
      // untrusted) get typed confirmation from latex-utensils where its
      // global positions independently agree.
      if (reconcileResult.entities.some((e) => e.agreement === "lexical-only")) {
        const { index, diagnostic } = buildUtensilsIndex(record.id, strat.stratifiedText, deps);
        if (diagnostic) reconcileResult.diagnostics.push(diagnostic);
        const backfilled = backfillLexicalOnly(
          reconcileResult.entities,
          reconcileResult.diagnostics,
          index
        );
        reconcileResult.diagnostics = backfilled.diagnostics;
      }

      const spineRuns: SpineRun[] = witnessResult.textRuns.map((span) => ({
        span,
        role: rawText.slice(span.startUtf16, span.endUtf16).trim().length > 0
          ? "text-run"
          : "blank-run",
      }));
      // Whitespace is positively knowable from the raw stream itself; claiming
      // it keeps residue meaning "unexplained CONTENT" (the parser trims
      // leading/parbreak whitespace runs, which would otherwise litter residue
      // with newlines). This is a positive claim, not a complement.
      const wsRegex = /\s+/g;
      let wsMatch: RegExpExecArray | null;
      while ((wsMatch = wsRegex.exec(rawText)) !== null) {
        spineRuns.push({
          span: {
            sourceId: record.id,
            startUtf16: wsMatch.index,
            endUtf16: wsMatch.index + wsMatch[0].length,
          },
          role: "blank-run",
        });
      }

      const extraClaims: PillarClaim[] = [...reconcileResult.extraClaims];
      for (const g of witnessResult.groupSpans) {
        extraClaims.push({ pillar: "fence", span: g, role: "group" });
      }

      const claims = generatePillarClaims(
        record.id,
        reconcileResult.entities,
        spineRuns,
        extraClaims
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
        [],
        reconcileResult.extraClaims
      );

      const cov = computeSourceCoverage(record.id, record.lengthUtf16, claims);

      allEntities.push(...reconcileResult.entities);
      allClaims.push(...claims);
      allCoverage.push(cov.coverage);
      allDiagnostics.push(...reconcileResult.diagnostics, ...cov.diagnostics);
    }
  }

  // ---------------------------------------------------------------------
  // Configured-dialect minting: declared signatures the document actually
  // used, minus names the paper defined itself. Declaration entities are
  // coverage-neutral (their anchor sites are already claimed).
  // ---------------------------------------------------------------------
  const usedMacroNames = new Set<string>();
  const usedEnvNames = new Set<string>();
  const documentDefinedMacros = new Set<string>();
  const documentDefinedEnvs = new Set<string>();
  for (const ent of allEntities) {
    if (ent.kind === "macro-invocation") usedMacroNames.add(ent.name);
    else if (ent.kind === "environment") usedEnvNames.add(ent.name);
    else if (ent.kind === "macro-definition") documentDefinedMacros.add(ent.definedName);
    else if (ent.kind === "environment-definition") documentDefinedEnvs.add(ent.definedName);
  }
  allEntities.push(
    ...mintConfiguredEntities(
      configured,
      usedMacroNames,
      usedEnvNames,
      documentDefinedMacros,
      documentDefinedEnvs
    )
  );

  // ---------------------------------------------------------------------
  // Elaboration: per-site macro expansion over the censused document. The
  // census stays mechanical; this tier interprets, origin-chained to it.
  // ---------------------------------------------------------------------
  const expansionInputs: ExpandDocumentInput[] = [];
  for (const record of graph.sources) {
    if (!record.parsed || record.language !== "latex") continue;
    const strat = graph.stratifications.get(record.id);
    expansionInputs.push({
      sourceId: record.id,
      stratifiedText: strat ? strat.stratifiedText : graph.rawContents.get(record.id) || "",
      rawText: graph.rawContents.get(record.id) || "",
    });
  }
  const expansion = expandDocument(expansionInputs, deps, registry, allEntities);
  allDiagnostics.push(...expansion.diagnostics);

  // Emit bundle (entrypoint reported with on-disk casing when it resolved)
  const summary = emitCensusBundle(
    {
      slug,
      treeSha256,
      entrypoint: graph.entrypointResolved ?? entrypoint,
      sources: graph.sources,
      entities: allEntities,
      claims: allClaims,
      coverage: allCoverage,
      diagnostics: allDiagnostics,
      rawContents: graph.rawContents,
      expansionRows: expansion.rows,
    },
    options.outDir
  );

  console.log(`Census complete for ${slug}`);
  console.log(`Sources: ${summary.sourceCount} (parsed: ${allCoverage.length})`);
  console.log(`Entities: ${allEntities.length}`);
  console.log(`Claims: ${allClaims.length}`);
  console.log(`Expansion sites: ${expansion.rows.length}`);
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
