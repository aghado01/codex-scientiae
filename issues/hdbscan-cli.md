# HDBSCAN → a generic standalone clustering CLI

**Status:** AUDIT DONE, reshape + CLI DESIGNED (2026-07-03); implementation NOT started (C#/dotnet —
author/delegate, don't build-iterate here). A generic, context-agnostic HDBSCAN utility (`hdbscan.exe`)
that any workflow can marshal; the pdf-converter is its FIRST consumer (figure-region assembly), not
its owner. Ripped from ThermoMapper's interconnected web and dropped at `src/hdbscan/` to be made
self-contained. Related: `pdfdig-lane/pdfdig-ps-converter.md` (the consumer), Gemini scoping at
`~/.gemini/…/66066885-…/implementation_plan.md`.

## Audit — the migration is COMPLETE and self-contained (no missing deps)

Every `using` in `src/hdbscan/` resolves to a namespace defined **within** `src/hdbscan/` — there are
zero external references to ThermoMapper. Verified each runner-called type has its expected members:

| File | Type(s) | Role | Status |
|---|---|---|---|
| `Hdbscan.cs` | `HdbscanRunner`, `HdbscanResult` | the pipeline + result DTO | ✅ complete |
| `Metric.cs` | `IDistanceMetric`, `EuclideanMetric` | struct-generic metric (JIT-inlined) | ✅ |
| `CoreDistances.cs` | `CoreDistances.Compute` | k-NN core distance per point | ✅ |
| `Prim.cs` | `Prim.ComputeMutualReachabilityMst` | implicit Prim MST over MRD graph | ✅ |
| `MstEdge.cs` | `MstEdge` (IComparable) | N−1 sorted edges | ✅ |
| `DendrogramBuilder.cs` | `DendrogramBuilder` | single-linkage merge tree | ✅ |
| `DendrogramNode.cs` | `DendrogramNode` (record struct) | one merge event | ✅ |
| `Dendrogram.cs` | `Dendrogram` (record) | tree DTO + CostAxis | ✅ |
| `UnionFind.cs` | `UnionFind` | path-compressed UF (union-by-size) | ✅ |

**No glaring gap — nothing needs pulling from ThermoMapper for the algorithm to run correctly.**
`CoreDistances.Compute` is a pure dense all-pairs scan (`for i / for j`, distances via the metric);
`Prim` builds the mutual-reachability MST implicitly (zero edge-list); condensation is inlined in
`HdbscanRunner`. It is the EXACT HDBSCAN* algorithm, self-contained, smoke-verified.

### The CSRGraph question — RESOLVED (it's SPC's, not HDBSCAN's)

Checked against the TM snapshot (`…/ThermoMapper/src_20260701_*`). `CsrGraph` / `GraphCompiler` /
the `graphs/proximity` + `graphs/pipeline` subsystem belong to the **SPC** clustering family
(Potts / Swendsen-Wang graph spin-clustering — see TM `user-repl/GraphHealthCommand.cs`, which builds
a graph via `SpcGraphBuilder` + `GraphCompilerConfig`). **HDBSCAN uses none of it.** TM's own
`user-repl/HdbscanCommand.cs` runs `HdbscanSession.Run(dataset.Features, settings, …)` directly on the
point cloud + a metric — exactly like the codex extraction. So the intuition conflated two clustering
families; HDBSCAN is dense point-cloud in BOTH repos, and the extraction is complete. (A sparse
kNN-graph *approximation* of HDBSCAN for very large n would want CsrGraph — but that's an optional
scale mode nobody built, not the exact algorithm we have.)

### What the closed-form lift DID drop (optional capabilities, not correctness)

TM's HDBSCAN carried scaffolding around the same core that the minimal lift left behind. Graft back
only what a marshalling context needs:
- **Multi-metric dispatch** (`HdbscanMetricDispatch.cs`) — TM's CLI takes `--distance-metric
  euclidean|manhattan|minkowski:p=N|hamming|poincare|cosine` and dispatches the STRING to the right
  struct metric (keeping `Run<TMetric>` JIT-inlined). The codex lift has ONLY `EuclideanMetric`. The
  extra metric structs live in TM `maths/distance/` + `graphs/distance/wrappers/`. **The one real
  content gap** if the generic CLI wants >1 metric (the figure use case needs only Euclidean).
- **External evaluators** (`Clustering.Evaluation.External/`: Purity, NMI, AdjustedRandIndex,
  Homogeneity, Completeness, VMeasure) — score a clustering against ground-truth labels. TM's CLI runs
  them when the dataset carries labels. **Relevant to the benchmark ambition** (`benchmark-harvest.md`):
  these ARE the objective scorers for a labelled clustering trial. Pull them if the CLI should report
  quality, not just partition.
- **Session/settings glue** (`HdbscanSession.cs`, `HdbscanSettings.cs`) — thin orchestration
  (features + settings → result + noise count + evaluator scores). Trivial to reproduce inline in the
  new `HdbscanCli.cs`; no need to port verbatim.

## What "frayed wires" actually means here (cosmetic reshape)

1. **Namespace sprawl** — five inherited namespaces (`Clustering.Graphical.HdbScan`,
   `Clustering.Dendrograms`, `Graphs.Distance`, `Graphs.Primitives`, `Graphs.Primitives.Mst`) reflect
   TM's big-library layout. In isolation, collapse to ONE coherent root, e.g. `Codex.Hdbscan` (or
   `Hdbscan`), keeping types together. Purely mechanical (rename namespaces + `using`s).
2. **Doc-comment artifacts** — comments cite consumers that don't exist here: `UnionFind` → "used in
   GraphBuilder.Validate" / "PottsModel Swendsen-Wang"; `DendrogramNode` → "GMM agglomerative";
   `Metric` → "the closed-form trim of the SPCX metric… the full SPCX interface". Rewrite to the
   standalone framing (a general dendrogram/UF primitive + a struct-generic metric contract).
3. **Dead-vs-generic capability review (don't discard).** `UnionFind` carries methods HDBSCAN never
   calls (`Union`, `Size`, `GetLabels`, `WriteRootSizesTo`, `Reset`) — but they make it a *reusable
   generic primitive*, which is the whole point of a standalone lib. KEEP them (or split a
   `Hdbscan.Internal` from a public `Primitives` namespace if you want the seam explicit). Same for
   `EuclideanMetric` being the only metric today: `IDistanceMetric` is the generic seam — add
   Manhattan/cosine later without touching the pipeline (the metric is a struct type param, so each
   stays JIT-inlined; a CLI `--metric` flag picks one).

The engine is ALREADY generic: `Run<TMetric>` is metric-generic, data is flat row-major `double[]`,
no domain assumptions. "Codify as a generic CLI" = wrap that generic core in a domain-agnostic
points-in / labels-out surface.

## The generic CLI surface (`HdbscanCli.cs`) — the new work

The exact reference is TM's `user-repl/commands/HdbscanCommand.cs` (read from the snapshot). Its core
args/outputs are proven and worth mirroring; the TM-workflow-specific parts (synthetic dataset
generators, run-manifest, GUID run dirs) are OPTIONAL — a lean generic CLI can drop them.

**Args (core — mirror these):**
```
hdbscan --in <points.csv|jsonl> --out-dir <dir>
        [--min-pts 5] [--min-cluster-size N]        # min-cluster-size defaults to min-pts
        [--allow-single-cluster | --no-allow-single-cluster]     # TM default: on
        [--distance-metric euclidean]               # euclidean|manhattan|minkowski:p=N|hamming|cosine|poincare
        [--label-column <name|idx>] [--delimiter <char|tab>] [--no-header]   # CSV ground-truth for evaluators
        [--config <preset.json>]                    # JSON preset; explicit flags override (TM has this)
```
TM-specific, OMIT unless wanted: `--dataset <synthetic-generator>` / `--param k=v` (synthetic data),
`--base-dir` / `--run-name` / `--no-guid` (its run-dir convention), the RunManifest.

**Input (domain-agnostic points):** row-major numeric vectors.
- CSV: one point per row, N feature columns; optional header; optional label column (`--label-column`)
  → ground truth for the evaluators.
- JSONL: `{"id": "...", "v": [x0, x1, …], "label": <opt>}` per line. The pig figure lane emits Lane-4
  bbox centroids this way (no labels).

Core call (metric string → struct via a dispatch, see optional capabilities): `HdbscanRunner.Run(...)`.

**Outputs (to `--out-dir`, TM's exact shapes — they're good, reuse them):**
- `hdbscan_partition.csv` — `feature_0…feature_d, label, membership_probability[, true_label]`
  (label −1 = noise; `true_label` only when input carried labels).
- `hdbscan_dendrogram.json` — `{ leaf_count, cost_axis, merges:[{left_child, right_child, distance,
  size, lambda}] }` (lambda = 1/distance; the DTO consumers persist without recompute).
- `summary.json` — `{ algorithm, dataset<meta>, hdbscan:{min_pts,min_cluster_size,allow_single_cluster,
  metric}, reference_labels, result:{cluster_count, noise_count, evaluator_scores{…}, clusters:[{id,
  size, mean_membership_probability}]}, run:{…paths} }`. The `evaluator_scores` block populates only
  when labels are present (needs the external evaluators — optional capability above).

Determinism: HDBSCAN is deterministic given data + params, BUT `Array.Sort(MstEdge)` is by weight only —
add an index tiebreak to `MstEdge.CompareTo` so tied-weight edges don't reorder the dendrogram across
runs (same discipline as the pig lanes; matters if you want byte-stable `dendrogram.json`). Exit
non-zero + stderr on bad input; stdout stays clean for pipeline use.

## Build & packaging (from the Gemini plan — open items are the user's call)

- `Directory.Build.props` (landed): repo-wide net10 / nullable / unsafe / artifacts→`artifacts/bin/{project}`.
- `src/{project}` (code) ⟂ `projects/{project}` (`.csproj`): MSBuild won't auto-find the split.
  **OPEN — pick one:** (A) per-csproj `<Compile Include="..\..\src\hdbscan\**\*.cs" />`, explicit; or
  (B) auto-route in `Directory.Build.props` via `$(MSBuildProjectName)` for ALL future C# tools. B is
  less boilerplate if the split is the repo convention; A is more obvious per-project.
- Release: `dotnet publish -c Release -o bin/hdbscan` → the `hdbscan.exe` the PS lane invokes.
- Smoke test (`tests/hdbscan/Program.cs`): **OPEN** — add `projects/tests/hdbscan.tests.csproj` so
  `dotnet run --project …` still works after the move.

## First consumer — the pig figure lane (why this exists here)

`pdfdig-ps-converter.md` next-step #4: cluster Lane-4 path bboxes (+ satellite caption text) into
figure regions. The PS lane writes centroids to a temp `points.jsonl`, invokes `hdbscan.exe` as a
SUBPROCESS, reads back `partition.csv` → figure-region groupings, with stray rules/underlines falling
out as HDBSCAN's noise class (−1). No clustering code in PowerShell; the engine stays a black-box CLI.
This is also the reserved "segmentation third-witness" engine (a density alternative to XYCut/Docstrum)
should a specimen ever defeat both.

## Do-order

1. Namespace consolidation (5 → 1) + doc-comment de-TM-ification. Mechanical, no behavior change.
2. MSBuild wiring decision (A/B) + `projects/tests` csproj; confirm the smoke test builds+passes.
3. **Scope decision (metrics + evaluators):** MVP = Euclidean-only, no evaluators (sufficient for the
   figure consumer). Generic/benchmark build = pull `HdbscanMetricDispatch` + the metric structs
   (`--distance-metric` string spec) and/or the `Clustering.Evaluation.External` scorers (Purity/NMI/
   ARI/… → `evaluator_scores` when labelled). These are additive; start MVP, graft when a context needs them.
4. `HdbscanCli.cs` — arg parse, CSV/JSONL loader, the three output writers (TM shapes above). Inline
   the thin session glue (features + settings → result + noise count); no need to port `HdbscanSession`.
5. `dotnet publish` → `bin/hdbscan/hdbscan.exe`; a tiny PS wrapper (`Invoke-Hdbscan`) that shells to it.
6. Wire the pig figure lane as the first caller (its own issue, gated on a raster/vector-figure specimen).
