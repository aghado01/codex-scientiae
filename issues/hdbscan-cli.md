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

**No glaring gap — nothing needs pulling from ThermoMapper.** The contingency ("if a dependency is
missing, map it from TM source") does not fire.

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

Mirrors ThermoMapper's `user-repl` shape: args → load → cluster → emit to `--out-dir`.

```
hdbscan --in <points.jsonl|csv> --out-dir <dir>
        [--min-pts N] [--min-cluster-size N] [--metric euclidean]
        [--allow-single-cluster] [--dim N]        # dim inferred from input if omitted
```

**Input (domain-agnostic points):** row-major numeric vectors.
- CSV: one point per row, N columns = dims (optional header ignored); or an `id` first column.
- JSONL: `{"id": "...", "v": [x0, x1, …]}` per line (id optional → row index). The pig figure lane
  emits Lane-4 bbox centroids this way.

Load → flat `double[n*dim]` → `new HdbscanRunner(n).Run(data, dim, minPts, metricStruct, minClusterSize, allowSingleCluster)`.

**Outputs (to `--out-dir`, mirroring user-repl):**
- `partition.csv` — `id,label,membership_prob` (label −1 = noise). The consumable result.
- `summary.json` — `{ n, dim, params:{min_pts,min_cluster_size,metric,allow_single_cluster},
   cluster_count, noise_count, cluster_sizes:[…] }`. Body-light run metadata.
- `dendrogram.json` — the `Dendrogram` DTO (merges + leaf_count + cost_axis) for persistence /
   inspection without recomputation.

Determinism: HDBSCAN here is deterministic given the data + params (Array.Sort of MstEdge is by weight;
add an index tiebreak if tied weights ever reorder — the same determinism discipline as the pig lanes).
Exit non-zero + stderr on bad input; stdout stays clean for pipeline use.

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
3. `HdbscanCli.cs` — arg parse, CSV/JSONL loader, the three output writers.
4. `dotnet publish` → `bin/hdbscan/hdbscan.exe`; a tiny PS wrapper (`Invoke-Hdbscan`) that shells to it.
5. Wire the pig figure lane as the first caller (its own issue, gated on a raster/vector-figure specimen).
