# HDBSCAN → a generic standalone clustering CLI

**Status:** IMPLEMENTED + verified (2026-07-03). Namespace consolidation (5→1 `CodexSci.Hdbscan`), metric
family, `HdbscanCli`, MSBuild wiring, and the release convention all landed and smoke-tested — smoke test:
3 clusters/96 pts; CLI: CSV+JSONL end-to-end (labelled + unlabelled), degenerate coincident-points path
emits `"lambda":"Infinity"` without throwing. A generic, context-agnostic HDBSCAN utility (`hdbscan.exe`)
that any workflow can marshal; the pdf-converter is its FIRST consumer (figure-region assembly), not
its owner. Ripped from ThermoMapper's interconnected web and dropped at `src/hdbscan/` to be made
self-contained. Related: `pdfdig-lane/pdfdig-ps-converter.md` (the consumer), Gemini scoping at
`~/.gemini/…/66066885-…/implementation_plan.md`.

**What landed:** `src/hdbscan/` = library (no entry point) — algorithm files renamed to `CodexSci.Hdbscan`,
doc-comments de-TM'd, `Metric.cs` now carries 5 metrics (euclidean/manhattan/chebyshev/minkowski/cosine)
behind a fully-abstract `IDistanceMetric` (the `ref`-overload is abstract not a DIM, so no struct boxing on
the constrained generic call), `MstEdge.CompareTo` gained the (U,V) tiebreak, and `HdbscanCli.Run` holds
the CLI (arg/preset parse, CSV+JSONL loaders, metric dispatch, 3 writers with inlined archivory conventions).
Entry points are project-local: `projects/hdbscan/Program.cs` → `hdbscan.exe`; `tests/hdbscan/Program.cs` =
a dependency-free C# trust harness via `projects/tests/hdbscan.tests.csproj`. Build/release:
`scripts/build-hdbscan.ps1` + PS wrapper `src/hdbscan/Invoke-Hdbscan.ps1`.

**External evaluators LANDED (`src/hdbscan/Evaluators.cs`).** sklearn-compatible Purity / NMI (arithmetic) /
Adjusted-Rand / Homogeneity / Completeness / V-measure auto-populate `evaluator_scores` whenever the input
carries labels; noise (−1) is treated as its own cluster (sklearn convention, `noise_count` reported
separately). Definitions are pinned to `sklearn.metrics` so scores are cross-checkable, and ARI uses the exact
pair-counting form (perfect-agreement short-circuit included). **Correctness + regression are pinned by two
test layers:** (1) the C# unit harness (`tests/hdbscan/Program.cs`, `dotnet run --project projects/tests`) —
hand-derived / sklearn-verified evaluator values on tiny inputs (the ruler), ARI=1.0 on cleanly-separated
blobs (absolute clustering correctness, no sklearn needed), and run-to-run determinism; (2) the Pester e2e
gate (`tests/hdbscan.Tests.ps1`, `pwsh -File tests/run.ps1`) — drives the real CLI and asserts summary.json's
`evaluator_scores`, unlabelled→null, byte-identical partitions, non-euclidean dispatch, and the unknown-metric
error.

**Nine distance metrics wired** (`Metric.cs`): euclidean / manhattan / chebyshev / minkowski:p=N / cosine /
hamming / poincaré / **hyperboloid** / **rectangle-gap**. hamming = scipy-proportion (discrete features);
poincaré + hyperboloid = the two hyperbolic models — Poincaré-ball (floored at the boundary, no NaN) and the
Lorentz/hyperboloid model (x0 = time component, numerically steadier far from origin) — cross-validated in the
harness to agree point-for-point via the isometry. **rectangle-gap** is the layout-segmentation dissimilarity:
`v=[x0,y0,x1,y1]` boxes, distance = nearest-point gap between axis-aligned rectangles (0 if overlapping), so
HDBSCAN reads density over white-space gaps and stray rules fall out as noise — the reserved density
"third witness" for the pig figure lane, verified (2 figures + 3 strays→noise, in both the C# harness and Pester
e2e). All unit-tested against hand-derived values; unknown metric fails loudly. **Nothing deferred on the metric axis.**

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
   TM's big-library layout. In isolation, collapse to ONE coherent root, e.g. `CodexSci.Hdbscan` (or
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

## Serialization — honor archivory's conventions, INLINE them (don't vendor the engine)

The TM output shapes above are produced by ThermoMapper's `archivory` module — and HDBSCAN's output
already vendors to it: `HdbscanCommand` writes summary/dendrogram via `UserReplJson.Writer.WriteDocumentToFile(...)`
(and `WriteDocumentToFile<T>` is a signature UNIQUE to archivory's `JsonArtifactWriter`), passing
`UserReplJsonContext.Default` as the source-gen `IJsonTypeInfoResolver`; `partition.csv` goes through
archivory's `TabularProjection`. So in TM the serialization is NOT hand-rolled — it flows through
archivory. (User's caveat: archivory↔HDBSCAN integration is itself a WIP in TM, so don't treat that
seam as frozen.)

**The reframe: archivory's JSON path is a THIN convention layer over `System.Text.Json`, not a heavy
engine.** The whole thing is a few small files (read from the TM snapshot `src/archivory/`):
- `ArtifactFile.WriteAtomic(path, write)` — crash-safe write via `.tmp` + `File.Move(overwrite)`.
- `JsonArtifactConventions.Create(...)` — a `JsonSerializerOptions` factory encoding four choices:
  `WriteIndented`, `PropertyNamingPolicy = SnakeCaseLower`, **`NumberHandling = AllowNamedFloatingPointLiterals`**,
  and an optional source-gen `TypeInfoResolver`.
- `JsonArtifactWriter` — a wrapper: `WriteDocumentToFile<T>` (indented, atomic) + `WriteRecords<T>` (compact JSONL).
- `tabular/TabularProjection` + `TabularData.WriteCsv` — CSV with proper quoting (fields containing
  `" , \r \n` get quoted/escaped) and an atomic `WriteToFile`.
- `ArtifactScope` / `RunIdentity` / `RunStamp` — the run-dir naming convention (already marked OPTIONAL/OMIT above).

**Only these conventions are the actual contract — and ONE is a correctness requirement, not a style match:**
- **`AllowNamedFloatingPointLiterals` — REQUIRED, non-negotiable.** Degenerate clusterings (single point,
  zero-variance column, all-noise) can produce `NaN`/`Infinity` in `membership_probability`, edge
  `distance`, or `cost_axis`. Default `System.Text.Json` **throws** on NaN/Inf. The CLI MUST set
  `NumberHandling = JsonNumberHandling.AllowNamedFloatingPointLiterals` no matter which path it takes.
- **snake_case naming policy** — so PascalCase C# records emit `left_child` / `membership_probability` /
  `cost_axis` without per-property `[JsonPropertyName]`. (Attributes are the alternative; the policy is leaner.)
- **atomic `.tmp`+Move writes** — robustness against a half-written artifact; ~6 lines to inline.
- **CSV field escaping** — `partition.csv` correctness the moment an `id`/`label` can contain a comma.

**Recommendation: the MVP CLI INLINES these (~40 lines: a local options factory + an atomic-write helper
+ a tiny CSV writer), documented as "archivory-convention-compatible" — it does NOT vendor archivory.**
Rationale: (a) the stated telos is a *lean, marshallable, self-contained* utility — archivory carries
plenty the CLI never needs (`BinarySerialization`, `TabularBuilder`, `RunIdentity`/`RunStamp`); (b)
vendoring now imports the WIP archivory↔HDBSCAN seam the user flagged; (c) honoring the same four
conventions already makes a codex `partition.csv`/`dendrogram.json` field-for-field byte-comparable to a
TM one — which is exactly what the benchmark/oracle-comparison ambition (`benchmark-harvest.md`) wants,
and that comparability comes from the *conventions*, not from sharing the *code*.

**Promotion path (mirrors "seam now, shared lib later"):** if/when a SECOND codex C# tool needs the same
serialization, promote the inlined helpers into a shared `src/archivory/` — vendoring a real SUBSET
(`ArtifactFile` + `JsonArtifactConventions` + `JsonArtifactWriter` + `tabular/`), matching TM's layering,
rather than pulling the whole module in for one consumer today. Until then: one lean CLI, conventions honored.

## Build & packaging — DECIDED + landed

- `Directory.Build.props`: repo-wide net10 / nullable / unsafe / artifacts→`artifacts/bin|obj/{project}`.
- **src⟂projects split → RESOLVED as Option B (repo convention).** The routing *mechanism* lives in
  `Directory.Build.props`: a `SharedSource` property (defaulting to `$(MSBuildProjectName)`) drives a
  `<Compile Include="$(RepositoryRoot)src\$(SharedSource)\**\*.cs" />`. A project named `foo` auto-picks-up
  `src\foo`; a project that compiles a *different* library (the test project) sets `<SharedSource>hdbscan</SharedSource>`
  explicitly; `EnableSharedSourceRouting=false` opts out. Chosen over pure `$(MSBuildProjectName)` because
  the test project (`hdbscan.tests`) needs to compile `src\hdbscan`, which a name-only route can't express.
  Key invariant that makes it work: **the shared library sources carry NO entry point** (`HdbscanCli.Run`,
  not `Main`), so both the CLI project and the test project can compile them without a double-`Main` clash;
  each supplies its own project-local top-level `Program.cs`.
- **Release convention → DECIDED.** Dev builds land in `artifacts/` (git-ignored); RELEASE binaries land in
  `bin/{project}/` (also git-ignored — clean split: `artifacts/`=intermediates, `bin/`=invocable exes). The
  `scripts/build-hdbscan.ps1` publishes: **framework-dependent single-file by default** (PDenv carries the
  .NET 10.0.201 runtime, confirmed — keeps it lean), with `-SelfContained` for a runtime-bundled exe that
  travels outside PDenv. NOT trimmed (reflection-based STJ; graft a `JsonSerializerContext` before trimming/AOT).
  `src/hdbscan/Invoke-Hdbscan.ps1` resolves `bin/hdbscan/hdbscan.exe`, falling back to `dotnet run` for a dev tree.
- Smoke test: `projects/tests/hdbscan.tests.csproj` (landed) — `dotnet run --project projects/tests` builds
  the library + `tests/hdbscan/Program.cs` and prints `N=96 clusters=3`.

## First consumer — the pig figure lane (why this exists here)

`pdfdig-ps-converter.md` next-step #4: cluster Lane-4 path bboxes (+ satellite caption text) into
figure regions. The PS lane writes centroids to a temp `points.jsonl`, invokes `hdbscan.exe` as a
SUBPROCESS, reads back `partition.csv` → figure-region groupings, with stray rules/underlines falling
out as HDBSCAN's noise class (−1). No clustering code in PowerShell; the engine stays a black-box CLI.
This is also the reserved "segmentation third-witness" engine (a density alternative to XYCut/Docstrum)
should a specimen ever defeat both.

**Embedding ladder (2026-07-03 design).** Centroid+Euclidean is the weakest embedding of the geometry — it
discards extent and is isotropic, both wrong for anisotropic page layout. The lane can instead pair richer
embeddings with matching metrics (the engine is metric-generic, so the creativity lives PS-side + a domain
metric or two): Rung 1 = weighted bbox vector (per-axis scaling = the anisotropy knob, done by scaling coords
PS-side); **Rung 2 (LANDED) = the `rectangle-gap` metric on `[x0,y0,x1,y1]`** — HDBSCAN as a density layout
segmenter, verified (figures cluster, stray rules → noise); Rung 3 = a spectral / diffusion-map embedding over
an element-affinity graph (this FUSES the figure lane into the SPC diffusion-coupling engine — the affinities +
diffusion-time t are exactly those knobs); Rung 4 = a hyperbolic (poincaré / hyperboloid) embedding of the
containment hierarchy for nested subfigures/panels (the two hyperbolic metrics exist precisely for this).

## Do-order

1. ✅ Namespace consolidation (5 → 1 `CodexSci.Hdbscan`) + doc-comment de-TM-ification. No behavior change.
2. ✅ MSBuild wiring (Option B, `SharedSource`) + `projects/tests` csproj; smoke test builds+passes (N=96, 3 clusters).
3. ✅ **Scope decision (metrics + evaluators):** shipped — ALL NINE metrics
   (euclidean/manhattan/chebyshev/minkowski/cosine/hamming/poincaré/hyperboloid/rectangle-gap, inline structs,
   no TM port; keeps `Run<TMetric>` inlined) AND the six external evaluators (`Evaluators.cs`, sklearn-compatible,
   auto-run when labelled). Unknown metric → loud error. Nothing deferred on this axis.
3b. ✅ **Trust layer (correctness + regression):** C# unit harness (`tests/hdbscan/Program.cs`, 27 checks —
   evaluator values vs hand/sklearn, ARI=1.0 on clean blobs, determinism) + Pester e2e (`tests/hdbscan.Tests.ps1`,
   4 tests driving the CLI). Both green. Run: `dotnet run --project projects/tests` and `pwsh -File tests/run.ps1`.
4. ✅ `HdbscanCli.cs` — arg/preset parse, CSV+JSONL loaders, three writers (TM shapes). Session glue inlined.
   Archivory conventions inlined, engine NOT vendored: `AllowNamedFloatingPointLiterals` (verified: degenerate
   input emits `"lambda":"Infinity"` not a throw), snake_case policy, atomic `.tmp`+Move, CSV escaping, UTF-8-no-BOM.
5. ✅ `scripts/build-hdbscan.ps1` (framework-dependent single-file default, `-SelfContained` opt-in) → `bin/hdbscan/hdbscan.exe`;
   PS wrapper `src/hdbscan/Invoke-Hdbscan.ps1` shells to it (falls back to `dotnet run`).
6. ⏳ Wire the pig figure lane as the first caller (its own issue, gated on a raster/vector-figure specimen).
