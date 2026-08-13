/**
 * TeXdig census CLI worker.
 *
 * Entrypoint: node src/TeXdig/cli/census.ts --article <dir> --deps <dir> --out <container>
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import fs from "node:fs";
import type { Stats } from "node:fs";
import path from "node:path";
import { loadDependencies } from "../core/loader.ts";
import { buildSourceGraph } from "../census/source-graph.ts";
import { scanLatex } from "../census/scan-latex.ts";
import { scanBib } from "../census/scan-bib.ts";
import {
  discoverDefinitions,
  parseLatexWitness,
  type DiscoveryResult,
  type ConfiguredSummonSite,
} from "../census/parse-latex.ts";
import { parseBib } from "../census/parse-bib.ts";
import { reconcileLatex, reconcileBib } from "../census/reconcile.ts";
import { buildConfiguredChannel, mintConfiguredEntities } from "../census/configured.ts";
import { buildUtensilsIndex, backfillLexicalOnly } from "../census/backfill-utensils.ts";
import { generatePillarClaims, type SpineRun } from "../census/claims.ts";
import { computeSourceCoverage } from "../census/coverage.ts";
import { emitCensusBundle } from "../census/emit.ts";
import { compileExecution } from "../compile/execution.ts";
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

function isStrictPathDescendant(root: string, candidate: string): boolean {
  const relative = path.relative(root, candidate);
  return (
    relative.length > 0 &&
    relative !== ".." &&
    !relative.startsWith(`..${path.sep}`) &&
    !path.isAbsolute(relative)
  );
}

/**
 * Resolve the manifest's source-tree address without trusting prior schema
 * validation. This guard is worker-owned and therefore remains active for
 * direct CLI calls and the PowerShell runner's -SkipValidation path.
 */
export function resolveManifestSourceTree(
  documentDirectory: string,
  treeRelativePath: unknown
): string {
  if (
    typeof treeRelativePath !== "string" ||
    treeRelativePath.length === 0 ||
    treeRelativePath.includes("\0") ||
    treeRelativePath.includes("\\") ||
    /[<>:"|?*\u0000-\u001F]/.test(treeRelativePath) ||
    path.posix.isAbsolute(treeRelativePath) ||
    path.win32.isAbsolute(treeRelativePath)
  ) {
    throw new Error("Manifest source-tree path must be a portable relative descendant");
  }

  const parts = treeRelativePath.split("/");
  if (parts.some((part) => !part || part === "." || part === ".." || /[ .]$/.test(part))) {
    throw new Error("Manifest source-tree path must be a portable relative descendant");
  }

  const resolvedDocumentDirectory = path.resolve(documentDirectory);
  const lexicalTreeDirectory = path.resolve(resolvedDocumentDirectory, ...parts);
  if (!isStrictPathDescendant(resolvedDocumentDirectory, lexicalTreeDirectory)) {
    throw new Error("Manifest source-tree path must remain within the article directory");
  }

  let cursor = resolvedDocumentDirectory;
  for (const part of parts) {
    cursor = path.join(cursor, part);
    let status: Stats;
    try {
      status = fs.lstatSync(cursor);
    } catch {
      throw new Error(`Source tree directory not found at '${lexicalTreeDirectory}'`);
    }
    // Node reports Windows directory junctions through the symbolic-link bit
    // as well as ordinary POSIX/Windows symlinks.
    if (status.isSymbolicLink()) {
      throw new Error(`Manifest source-tree path contains a reparse point (symlink/junction) at '${cursor}'`);
    }
    if (!status.isDirectory() && cursor !== lexicalTreeDirectory) {
      throw new Error(`Manifest source-tree path crosses a non-directory at '${cursor}'`);
    }
  }

  if (!fs.lstatSync(lexicalTreeDirectory).isDirectory()) {
    throw new Error(`Source tree path is not a directory: '${lexicalTreeDirectory}'`);
  }

  const canonicalDocumentDirectory = fs.realpathSync.native(resolvedDocumentDirectory);
  const canonicalTreeDirectory = fs.realpathSync.native(lexicalTreeDirectory);
  if (!isStrictPathDescendant(canonicalDocumentDirectory, canonicalTreeDirectory)) {
    throw new Error("Manifest source-tree path resolves outside the article directory");
  }
  return canonicalTreeDirectory;
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
  let treeRelPath: unknown;
  let treeSha256 = "";
  let entrypoint = "";
  let manifestFileCount: number | undefined;

  let treeForm: any;
  if (article.source_forms && Array.isArray(article.source_forms)) {
    treeForm = article.source_forms.find(
      (f: any) => f.role === "latex-source-tree"
    );
    if (treeForm) {
      // Preserve the manifest value verbatim. A missing/falsey path is invalid
      // provenance and must reach the worker-owned path guard, never trigger a
      // conventional `${slug}-tex` guess under -SkipValidation.
      treeRelPath = treeForm.path;
      treeSha256 = treeForm.sha256 || "";
      entrypoint = treeForm.entrypoint || "";
      if (typeof treeForm.files === "number") manifestFileCount = treeForm.files;
    }
  }
  if (!treeForm) {
    throw new Error(
      `article.json for '${slug}' carries no latex-source-tree source form; refusing to guess`
    );
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

  const treeDir = resolveManifestSourceTree(docDir, treeRelPath);

  // Load dependencies
  const deps = loadDependencies(options.depsDir);

  // Build source graph (stratification happens inside, before include scanning)
  const graph = buildSourceGraph(treeDir, entrypoint);

  // Attribution is a hard precondition. The graph fingerprint is computed from
  // the exact buffers used below; a stale or absent manifest identity must not
  // yield an apparently attested census plus a diagnostic nobody reads.
  if (!/^[0-9a-f]{64}$/.test(treeSha256)) {
    throw new Error(
      `Manifest for '${slug}' has no valid lowercase SHA-256 source-tree fingerprint`
    );
  }
  if (!Number.isSafeInteger(manifestFileCount) || manifestFileCount < 1) {
    throw new Error(
      `Manifest for '${slug}' has no valid positive source-tree file count`
    );
  }
  if (manifestFileCount !== graph.sources.length) {
    throw new Error(
      `Manifest declares ${manifestFileCount} files but the deposited tree holds ${graph.sources.length}; refusing stale source attribution`
    );
  }
  if (treeSha256 !== graph.treeSha256) {
    throw new Error(
      `Manifest source-tree fingerprint ${treeSha256} does not match the censused buffers ${graph.treeSha256}; refusing stale source attribution`
    );
  }

  const allEntities: CensusEntity[] = [];
  const allClaims: PillarClaim[] = [];
  const allCoverage: SourceCoverage[] = [];
  const allDiagnostics: Diagnostic[] = [...graph.diagnostics];

  // ---------------------------------------------------------------------
  // Pass 1 — physical definition discovery across parsed LaTeX sources.
  // Signatures remain facts on definition sites. They are not merged into a
  // document-final parser registry: doing so lets a later redefinition rewrite
  // the physical shape of an earlier control-sequence occurrence.
  // ---------------------------------------------------------------------
  const discoveries = new Map<string, DiscoveryResult>();
  const configuredSummons: ConfiguredSummonSite[] = [];
  for (const record of graph.sources) {
    if (!record.parsed || record.language !== "latex") continue;
    const strat = graph.stratifications.get(record.id);
    const text = strat ? strat.stratifiedText : graph.rawContents.get(record.id) || "";
    const discovery = discoverDefinitions(record.id, text, deps);
    discoveries.set(record.id, discovery);
    configuredSummons.push(...discovery.configuredSummons);
  }

  const configured = buildConfiguredChannel(configuredSummons, deps);
  if (configured.unresolvedPackages.length > 0) {
    allDiagnostics.push({
      code: "census/configured-gap",
      severity: "info",
      message: `Summoned packages with no configured signature record: ${configured.unresolvedPackages.join(", ")}`,
    });
  }
  const physicalParseRegistry = { macros: {}, environments: {} };

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
        configuredSummons: [],
        deferredContexts: [],
      };

      const scan = scanLatex(record.id, strat.stratifiedText);
      const witnessResult = parseLatexWitness(
        record.id,
        strat.stratifiedText,
        deps,
        physicalParseRegistry
      );
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

      if (record.lengthUtf16 === undefined) {
        throw new Error(`Parsed source '${record.id}' has no decoded UTF-16 length`);
      }
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

      if (record.lengthUtf16 === undefined) {
        throw new Error(`Parsed source '${record.id}' has no decoded UTF-16 length`);
      }
      const cov = computeSourceCoverage(record.id, record.lengthUtf16, claims);

      allEntities.push(...reconcileResult.entities);
      allClaims.push(...claims);
      allCoverage.push(cov.coverage);
      allDiagnostics.push(...reconcileResult.diagnostics, ...cov.diagnostics);
    }
  }

  // ---------------------------------------------------------------------
  // Configured-dialect minting: declared signatures the document actually
  // uses. Same-name document declarations remain separate physical evidence;
  // the occurrence-aware binding cut decides shadowing. Declaration entities
  // are coverage-neutral because their summon anchors are already claimed.
  // ---------------------------------------------------------------------
  const usedMacroNames = new Set<string>();
  const usedEnvNames = new Set<string>();
  for (const ent of allEntities) {
    if (ent.kind === "macro-invocation") usedMacroNames.add(ent.name);
    else if (ent.kind === "environment") usedEnvNames.add(ent.name);
  }
  allEntities.push(
    ...mintConfiguredEntities(
      configured,
      usedMacroNames,
      usedEnvNames
    )
  );

  const deferredContexts = [...discoveries.values()].flatMap(
    (discovery) => discovery.deferredContexts
  );
  const execution = compileExecution({
    slug,
    treeSha256: graph.treeSha256,
    entrypoint: graph.entrypointResolved ?? entrypoint,
    entities: allEntities,
    claims: allClaims,
    includeEdges: graph.includeEdges,
    configured,
    rawContents: graph.rawContents,
    deps,
    deferredContexts,
  });
  allDiagnostics.push(...execution.diagnostics);

  // Emit bundle (entrypoint reported with on-disk casing when it resolved)
  const summary = emitCensusBundle(
    {
      slug,
      treeSha256: graph.treeSha256,
      entrypoint: graph.entrypointResolved ?? entrypoint,
      sources: graph.sources,
      entities: allEntities,
      occurrences: execution.occurrences,
      bindings: execution.bindings,
      invocations: execution.invocations,
      claims: allClaims,
      coverage: allCoverage,
      diagnostics: allDiagnostics,
      rawBuffers: graph.rawBuffers,
      rawContents: graph.rawContents,
      runtimeNode: process.version,
    },
    options.outDir
  );

  console.log(`Census complete for ${slug}`);
  console.log(`Sources: ${summary.sourceCount} (parsed: ${allCoverage.length})`);
  console.log(`Entities: ${allEntities.length}`);
  console.log(`Occurrences: ${execution.occurrences.length}`);
  console.log(`Binding rows: ${execution.bindings.length}`);
  console.log(`Invocations: ${execution.invocations.length}`);
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
