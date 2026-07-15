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
6. **`docs/` → `src/docs/` = the MCP's operational documentation** — the agent's *role instructions*
   (workflow, standards, procedure), treated as **part of the source code** and served by the MCP.
   Everything workflow-specific folds in: `STANDARDS`/`WORKFLOW`/`CHECKLIST`/`SETUP` + served prompts
   (`PROCEDURE`, `*-discovery`, read-paths updated) + a merged `ARCHITECTURE.md`. **Root docs stay
   canonical & orientation-only** — *what the repo is and how to enter it*: `CLAUDE.md` (harness
   contract), `README.md` (landing), `CONTENTS.md` (telescope root), and a **rewritten `AGENTS.md`**
   (agent orientation that hands off to the MCP for the operational role). Root doc links repoint into
   `src/docs/`.
7. **Single module** `CodexScientiae` (one `.psd1` + one root `.psm1`), NOT per-lane modules.
8. **Manifest + root loader; sources stay dot-sourced `.ps1`** (single module scope) — NOT nested
   `.psm1` per file (which would isolate the cross-file `$script:` state the code relies on).

## Module architecture

- **`src/CodexScientiae.psd1`** — manifest. `ModuleVersion`, `GUID`, `Author`, `PowerShellVersion='7.0'`,
  `RootModule='CodexScientiae.psm1'`, `FunctionsToExport` = the server-facing surface (see below).
  PdfPig assemblies: **declared in `RequiredAssemblies`** (locked) — the manifest lists the vendored DLLs
  (`UglyToad.PdfPig.dll` + `.Core`/`.Fonts`/`.DocumentLayoutAnalysis`) by module-base-relative path,
  canonically `../lib/pdfpig/`. This is the neat declarative home. Accepted tradeoff: a single module
  means every `Import-Module` eager-loads PdfPig, including the light arxiv/scholar servers (harmless —
  a few DLLs into memory, just not lazy). This **replaces** the runtime probe + `Add-Type` in
  `convert/pdfdig-ir.ps1` — drop the `$script:PdfPigLib` fallback logic; keep only a presence check that
  errors clearly if the DLLs are missing. (Note: `RequiredAssemblies` loads .NET DLLs, not the shelled-out
  `hdbscan.exe`, which stays a `Start-Process`/CLI call.)
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
- `convert/pdfdig-ir.ps1`: PdfPig loading moves OUT to the manifest `RequiredAssemblies` (drop the
  `$script:PdfPigLib` probe + `Add-Type`; keep a presence check). `stores/*` co-located.
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

## Doc consolidation (detail for §6)

Root docs split into three eras: **pre-membrane (obsolete)**, **membrane-era canonical**, and
**repo/corpus-level**. Consolidation moves the MCP-operational docs into `src/docs/`, deletes the dead
pipeline docs, and leaves the corpus/harness docs at root — reconciling the collisions on the way.

**Guiding split (per the user):** `src/docs/` holds the agent's *role instructions* (how the work is done
— workflow, standards, procedure), treated as source the MCP serves; **root** holds *orientation* (what
the repo is, how to enter). The pre-membrane root docs were hand-written work-instructions from before any
MCP existed — that role now belongs to the MCP, so the workflow content migrates in and the dead manual
pipelines retire.

| Doc | Lines | Disposition |
|---|---|---|
| `STANDARDS.md` | 47 | → `src/docs/` (canonical; newer than opuscula's 41-line copy) |
| `WORKFLOW.md` | 38 | → `src/docs/` (membrane-era failure-mode taxonomy — the "what") |
| `CHECKLIST.md` | 39 | → `src/docs/` **after** delimiter reconcile (C) |
| `src/PROCEDURE.md` | 146 | → `src/docs/` (served prompt; read-path updated) |
| `src/SETUP.md` | 94 | → `src/docs/` (refresh tool count 21→~32, server path) |
| `MEMBRANE.md` | 96 | → `src/docs/ARCHITECTURE.md`, merging `src/README.md` (D); refresh |
| `src/README.md` | 61 | folds into `ARCHITECTURE.md`; src entry becomes a thin pointer |
| `SCHEMA.md` | 14 | split: Contents template → `STANDARDS.md` §6; removal guidance → promotion contract §8, contextualized (E) |
| `src/{arxiv,scholar}-discovery.md` | 32/34 | → `src/docs/` (served prompts; read-paths updated) |
| `AGENTS.md` | 33 | **rewrite AT ROOT** as agent *orientation* (hands off to the MCP); current one is stale (B) |
| `HOUSEKEEPING.md` | 72 | corpus-health register — DECISION: `src/docs/` vs stay-root vs `issues/` |
| `WORKFLOW-2.md` | 178 | **DELETE / archive** — dead pre-membrane Python-script pipeline (A) |
| `WORKFLOW-2B.md` | 89 | **DELETE / archive** — dead subagent-swarm pipeline (A) |
| `CLAUDE.md` | 9 | STAYS root (harness contract); repoint its doc links into `src/docs/` |
| `CONTENTS.md` | 4 | STAYS root (telescope root); add pointer to `src/docs/` |
| `README.md` | 22 | STAYS root (repo landing); update doc links → `src/docs/` |
| `CHANGELOG.md` | 5 | STAYS root (repo changelog) |

**Collision / redundancy ledger:**
- **A — three workflow docs, two eras.** `WORKFLOW.md` is the membrane-era rewrite (points at the membrane,
  keeps the failure taxonomy, §5 explicitly deprecates swarms). `WORKFLOW-2.md`/`-2B.md` document the
  pre-membrane Python `scripts/*.py` + manifest + page-slice + `invoke_subagent` swarm — the scripts are
  **gone** (`scripts/` = `build-hdbscan.ps1` only) and the model is superseded. Delete or move to `.legacy/`.
- **B — `AGENTS.md` is stale.** Routes to the three docs but describes the dead swarm model ("Closing
  Ceremonies", "zombie subagents") and carries LLM citation artifacts (`[file:4/5/6]`). **Rewrite AT ROOT
  as agent orientation**: what the repo is, the three collections, and that the operational role
  (conversion / repair / acquisition) is delivered by the MCP servers + `src/docs/`. It stops being a
  workflow router — the workflow lives in the MCP.
- **C — STANDARDS ↔ CHECKLIST delimiter contradiction.** STANDARDS §1 mandates `$…$`/`$$` (what `finalize`
  emits); CHECKLIST §3 still says `\(…\)`/`\[…\]`. Reconcile CHECKLIST to `$`-delimiters.
- **D — `MEMBRANE.md` ↔ `src/README.md` overlap.** Both are architecture overviews carrying stale
  "21 tools" tables. Merge into one `ARCHITECTURE.md` — single source of truth for the tool catalogue.
- **E — `SCHEMA.md` splits two ways (resolved).** Its Contents template overlaps STANDARDS §6 → fold there.
  Its "Remove: Acknowledgments / affiliations / COI" is **kept, relocated, and contextualized as a
  PROMOTION-phase editorial trim** — token-economy "fat" cut from the reader-facing published corpus, and
  explicitly NOT applied in the faithful dev loop or in dev/conversion benchmarking (oracle↔converter,
  which needs the complete text; the separate future LLM-task benchmark is out of scope). Not a
  contradiction with the faithful doctrine — phase-separated. Home: the publish/promotion contract
  (STANDARDS §8) as an editorial-trim subsection. Consistent with the faithful-not-filtered doctrine.
- **F — tool-count drift.** "21"/"26"/"29+3" appear across SETUP/README/MEMBRANE/server. The merged
  `ARCHITECTURE.md` becomes the one place the catalogue lives, ending the drift.

**Design upgrade (optional, realizes the "MCP exposes them" intent):** since these are source the MCP
serves, expose `src/docs/` *through* the MCP, not just as files on disk. The server already serves
`PROCEDURE.md` / `*-discovery.md` as **prompts**; extend that to serve `STANDARDS` / `WORKFLOW` /
`CHECKLIST` / `ARCHITECTURE` as MCP **resources** (`resources/list` + `resources/read`) so an agent
consults the standard in-band instead of reading the tree. Ties into the capability lifecycle — a loaded
capability can advertise its own doc resource.

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

- **`corpus-audit.ps1` / `benchmark.ps1`**: left at `src/` root and `membrane/` root. A `src/ops/`
  (maintenance) or `membrane/lab/` (experimental) folder is trivial to add if wanted.
- **`MEMBRANE.md`** (repo-root architecture doc): fold into `src/docs/` or leave at root — borderline.
