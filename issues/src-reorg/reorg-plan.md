# src/ re-organization + modularization plan

**Status:** PLAN (rev. 2026-07-04). Reference layout: `D:\aghado01\opuscula\codex-membrane\mcp`
(the portfolio extraction — **layout template only**; its code is a stale *subset*). Live `src` is a
*superset*: 3 MCP servers (membrane + arxiv + scholar) + the pig converter + the hdbscan engine.
Two intertwined goals: (A) reorganize the flat `src/` root by lane, mirroring membrane's functional
taxonomy; (B) make all of it a proper **PowerShell module**.

## Decisions locked

1. Membrane pipeline nests under `src/membrane/` (peer to `acquire/`, `convert/`, `cluster/`).
2. Engine dirs rename in place, constant depth: `pdf-converter → convert`, `hdbscan → cluster`.
3. Repo-wide shared primitives → `src/core/` (distinct from repo-root `lib/` = vendored PdfPig DLLs).
4. `latex-ingest.ps1` (+ its dependency `tikz-render.ps1`) → **`convert/`** — it's a LaTeX→md converter.
5. `oracle/` folder → **`latex/`**; the "oracle business" (`latex.ps1` math predicates) stays in the
   membrane lane. "Oracle" survives only in doc-strings / prose.
6. `docs/` → **`src/docs/`** as the canonical MCP-user doc home; repo-root `STANDARDS`/`WORKFLOW`/
   `CHECKLIST` + `SETUP` fold in. Served-prompt markdowns (`PROCEDURE`, `*-discovery`) move in too,
   with the 3 servers' read-paths updated. **`CLAUDE.md` stays at repo root** (harness contract);
   root `CONTENTS.md`/`README.md` stay as telescope-root/landing with pointers into `src/docs/`.
7. **Single module** `CodexScientiae` (one `.psd1` + one root `.psm1`), NOT per-lane modules.
8. **Manifest + root loader; sources stay dot-sourced `.ps1`** (single module scope) — NOT nested
   `.psm1` per file (which would isolate the cross-file `$script:` state the code relies on).

## Module architecture

- **`src/CodexScientiae.psd1`** — manifest. `ModuleVersion`, `GUID`, `Author`, `PowerShellVersion='7.0'`,
  `RootModule='CodexScientiae.psm1'`, `FunctionsToExport` = the server-facing surface (see below).
  PdfPig assemblies: **keep lazy** (`Add-Type -Path` in the convert loader, as today) rather than eager
  `RequiredAssemblies` — a single module is imported by all 3 servers, and the light arxiv/scholar
  servers should not eager-load PdfPig. Document the DLL dependency in `PrivateData`/a comment.
- **`src/CodexScientiae.psm1`** — root loader. Dot-sources **every** source file, in **dependency order**
  (`core → latex predicates → convert/cluster → membrane preprocess/repair/deliver/gates/server →
  acquire`), into ONE module scope. This is the single point of truth for file locations and load order.
  Ordering constraint = top-level `$script:` initializers only (function bodies resolve lazily).
- **The ~60 scattered inter-file dot-sources are DELETED** — the loader supersedes them; all functions
  and `$script:` state share the module scope, so cross-file references resolve without paths.
- **Servers stay `.ps1` launch scripts, now thin:** `Import-Module (Join-Path $PSScriptRoot <rel> 'CodexScientiae.psd1')`
  then the existing JSON-RPC loop + UTF-8 channel setup (`$script:Rpc`/`$script:In`/`[Console]::SetOut`
  stay in the server script). `.mcp.json` still points at the server scripts.
- **`FunctionsToExport`** = union of what the 3 servers call (~28 membrane fns: `Invoke-Preprocess`,
  `Invoke-Finalize`, `Get-IrSummary`, `Get-Slice`, `Add-RepairEdit`, `Invoke-RepairApply`,
  `Invoke-Publish`, `Invoke-Dispatch`, `Repair-MdHeadings`, `Set-MdSpan`, … + `Get-IngestionScan`,
  `Invoke-Crawl`; plus the acquire/convert entrypoints). Internal helpers stay unexported (reachable in
  tests via `InModuleScope`). Curating this list is a side-benefit: it defines the public API.
- **Runtime `$PSScriptRoot` file-reads survive as paths** (not dissolved by the loader): `PROCEDURE.md`,
  `*-discovery.md`, `*-config.json`, `arxiv-staging.json`, `scihub-mirrors.json`, `stores/*`, the PdfPig
  DLL dir. These are read from within functions and get their paths updated when files move.

## Target tree

```
src/
  CodexScientiae.psd1        # manifest
  CodexScientiae.psm1        # root loader (dependency-ordered dot-source list)
  docs/                      # canonical MCP docs: PROCEDURE · SETUP · STANDARDS · WORKFLOW · CHECKLIST · *-discovery
  core/                      jsonl · crawl · runs
  membrane/
    mcp-server.ps1           # thin: Import-Module ../CodexScientiae.psd1 + loop
    server/       serving
    preprocess/   preprocess · project-ir · pdfdig-adapter · headings · collapse ·
                  zones · sections · normalize · fidelity · enrichment · repair · masks
    repair/       restructure · playbook · md-repair · md-cleanup
    deliver/      finalize · publish
    latex/        latex                              # renamed from oracle/ (predicates stay)
    gates/        render-check · md-lint
    benchmark.ps1
  acquire/
    arxiv/        arxiv-server.ps1 (thin) · arxiv · arxiv-adapter · arxiv-staging.json
    scholar/      scholar-server.ps1 (thin) · scholar-core · openalex · semanticscholar · scholar-config.json
    scihub/       scihub-get · scihub-mirrors.json
  convert/                                            # renamed pdf-converter, constant depth
    latex-ingest · tikz-render                        # moved here (LaTeX→md conversion)
    pdfdig-ir · pdfdig-classify · pdfdig-figures · pdfdig-images · math-assembler · math-evidence · specimens.jsonl · stores/
  cluster/        *.cs · Invoke-Hdbscan               # renamed hdbscan, constant depth
  corpus-audit.ps1
```

Preserved subtleties: `repair.ps1` is a **preprocess stage** (not the interactive `repair/` folder).
`masks.ps1` follows membrane into `preprocess/` (imported by `latex/latex.ps1`). C# identity is
**unchanged** — `hdbscan.exe`, `projects/hdbscan/`, `CodexSci.Hdbscan`, `bin/hdbscan/` stay; only the
source dir renames and the csproj SharedSource glob repoints.

## Move map (git mv — preserve history)

| Current | New |
|---|---|
| `src/{jsonl,crawl,runs}.ps1` | `src/core/` |
| `src/mcp-server.ps1` | `src/membrane/` (thin server) |
| `src/serving.ps1` | `src/membrane/server/` |
| `src/{preprocess,project-ir,pdfdig-adapter,headings,collapse,zones,sections,normalize,fidelity,enrichment,repair,masks}.ps1` | `src/membrane/preprocess/` |
| `src/{restructure,playbook,md-repair,md-cleanup}.ps1` | `src/membrane/repair/` |
| `src/{finalize,publish}.ps1` | `src/membrane/deliver/` |
| `src/latex.ps1` | `src/membrane/latex/` |
| `src/{render-check,md-lint}.ps1` | `src/membrane/gates/` |
| `src/benchmark.ps1` | `src/membrane/` |
| `src/{latex-ingest,tikz-render}.ps1` | `src/convert/` |
| `src/{arxiv-server,arxiv,arxiv-adapter}.ps1` `arxiv-staging.json` | `src/acquire/arxiv/` |
| `src/{scholar-server,scholar-core,openalex,semanticscholar}.ps1` `scholar-config.json` | `src/acquire/scholar/` |
| `src/{scihub-get}.ps1` `scihub-mirrors.json` | `src/acquire/scihub/` |
| `src/pdf-converter/*` | `src/convert/*` (rename dir) |
| `src/hdbscan/*` | `src/cluster/*` (rename dir) |
| `src/{PROCEDURE,SETUP}.md` + repo-root `{STANDARDS,WORKFLOW,CHECKLIST}.md` + `{arxiv,scholar}-discovery.md` | `src/docs/` |
| `src/corpus-audit.ps1` `README.md` `.gitignore` | stay at `src/` root |

## Runtime `$PSScriptRoot` reads to repoint (survive modularization)

- `mcp-server.ps1`: `PROCEDURE.md` → `../docs/PROCEDURE.md`.
- `arxiv-server.ps1`: `arxiv-staging.json` → co-located; `arxiv-discovery.md` → `../../docs/arxiv-discovery.md`.
- `scholar-server.ps1`: `scholar-config.json` → co-located; `scholar-discovery.md` → `../../docs/scholar-discovery.md`;
  `arxiv-staging.json` → `../arxiv/arxiv-staging.json`; `scihub-mirrors.json` → `../scihub/scihub-mirrors.json`.
- `convert/pdfdig-ir.ps1`: PdfPig `../../lib/pdfpig` UNCHANGED (constant depth); `stores/*` co-located.
- `convert/pdfdig-figures.ps1`: `../hdbscan/Invoke-Hdbscan → ../cluster/Invoke-Hdbscan` (constant depth otherwise).
- `convert/pdfdig-images.ps1`: `../../tools/pdf-raster` UNCHANGED. `cluster/Invoke-Hdbscan.ps1`: RepoRoot `../..` UNCHANGED.

## External references (repo-root → src)

- **`.mcp.json`** — `src/mcp-server.ps1 → src/membrane/mcp-server.ps1`;
  `src/arxiv-server.ps1 → src/acquire/arxiv/arxiv-server.ps1`;
  `src/scholar-server.ps1 → src/acquire/scholar/scholar-server.ps1`.
- **`.agents/codex-membrane.cmd`** — `SERVER=…/src/mcp-server.ps1 → …/src/membrane/mcp-server.ps1`.
- **`projects/hdbscan/Hdbscan.csproj`** — SharedSource `..\..\src\hdbscan → ..\..\src\cluster`.
- **`projects/tests/hdbscan.tests.csproj`** — `src\hdbscan → src\cluster`. `projects/hdbscan/Program.cs` — comment.
- **`CLAUDE.md`** — repoint "See STANDARDS.md / WORKFLOW.md / CHECKLIST.md" into `src/docs/`. Root
  `CONTENTS.md`/`README.md` — add pointer to `src/docs/`.
- **Server readiness strings** — `src/arxiv-staging.json`, `src/pdf-converter` mentions → new paths.

## Test migration (one-time, in Stage 0)

Each `tests/*.Tests.ps1` switches from `. "$PSScriptRoot/../src/<file>.ps1"` (individual dot-source) to
`Import-Module "$PSScriptRoot/../src/CodexScientiae.psd1" -Force` in `BeforeAll`, and wraps internal-function
assertions in `InModuleScope CodexScientiae { … }`. Because the manifest path is stable, **tests do not
change again when files move in later stages.** `tests/run.ps1` remains the green-gate.

## Sequencing — modularize first, then move (each stage independently green)

0. **Modularize in place.** Add `CodexScientiae.psd1` + `.psm1` (loader dot-sources the *current flat*
   files in dependency order); delete the ~60 inter-file dot-sources; convert the 3 servers to thin
   `Import-Module` scripts; set `FunctionsToExport`; migrate all tests to `Import-Module`+`InModuleScope`.
   → full `tests/run.ps1` + cold-launch all 3 servers. *(Largest stage; delivers the module.)*
1. **`core/`** — move jsonl/crawl/runs → update 3 loader lines. → tests.
2. **`acquire/{arxiv,scholar,scihub}/`** — move; fix scholar's cross-lane config reads + `.mcp.json` (2) →
   smoke-launch arxiv + scholar, run their tests.
3. **`convert/` + `cluster/` rename** (+ latex-ingest/tikz-render into convert) — loader lines + csproj (2) +
   pig→cluster ref → `scripts/build-hdbscan.ps1` + pig/hdbscan tests.
4. **`membrane/`** (+ `oracle→latex`) — loader lines + `mcp-server` PROCEDURE read + `.mcp.json` (membrane) +
   `.agents` cmd → smoke-launch membrane, full `tests/run.ps1`.
5. **`docs/`** — move docs + fold root docs; update 3 server read-paths + `CLAUDE.md`/`CONTENTS` pointers.
   Doc sweep of `issues/*`, `.claude/*`, `MEMBRANE.md` (non-load-bearing). `.cursor/scratch/*` is throwaway.

## Verification gate

- `tests/run.ps1` fully green after each stage (Pester, `Import-Module … -Force` picks up moves).
- Cold-launch each server via its `.mcp.json` command form; confirm the `initialize` readiness line.
- `scripts/build-hdbscan.ps1 → bin/hdbscan/hdbscan.exe` builds; `Invoke-Hdbscan` resolves it.

## Operational note

The **live MCP servers run from these paths** (this session is connected). After the `.mcp.json` edits,
the servers must be **restarted / re-registered** — no hot-swap; current connections keep the old paths
until then. Restart is also needed to pick up the thin-server rewrite in Stage 0.

## Open items (recommended defaults)

- **PdfPig loading**: keep lazy `Add-Type` in convert (recommended) vs eager `RequiredAssemblies` in the
  manifest. Lazy keeps the light servers from loading PdfPig; declare the dep in `PrivateData` for neatness.
- **`corpus-audit.ps1` / `benchmark.ps1`**: left at `src/` root and `membrane/` root. A `src/ops/`
  (maintenance) or `membrane/lab/` (experimental) folder is trivial to add if wanted.
- **`MEMBRANE.md`** (repo-root architecture doc): fold into `src/docs/` or leave at root — borderline.
