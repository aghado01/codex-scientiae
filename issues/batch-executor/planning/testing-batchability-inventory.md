# Batch executor — Pester batchability inventory

This is the BEX-501 semantic inventory and single-container timing baseline. It applies the
[testing-overhaul brief](../briefs/sol-pester-batch-testing-overhaul-20260805.md) to every physical
`*.Tests.ps1` file present on 2026-08-06. It is an admission record, not a workload manifest or a promise
that individual `It` blocks are independently schedulable.

## Measurement method

- Each physical file was invoked by exact path through `tests/run.ps1` in a fresh child PowerShell process.
- The eight `tests/shared/batch-executor*.Tests.ps1` positive-control files ran first, followed by the
  `tests/latex-ingest/latex-ingest.Tests.ps1` restructuring control and then every remaining file in stable
  path order.
- Every invocation requested its own native NUnit XML result. All 43 processes exited successfully: 476
  tests were selected, 474 passed, 2 were skipped, and none failed.
- `Wall` is a single approximate elapsed measurement and includes child-PowerShell, module, Pester, and
  container startup. It is useful for topology and scheduling review, not a performance guarantee.
- The 43 isolated wall measurements total 320.387 s (mean 7.451 s, median 5.656 s, p90 10.889 s, p95
  18.276 s). The enclosing serialized harness took approximately 321.5 s.
- `Obs/It` means observed Pester tests versus textual `It` lines. Parameter rows expand `md-repair`; embedded
  fixture source inflates the textual count in `test-batch`.

Classification applies to the current physical file as a whole:

| Class | Files | Disposition |
|---|---:|---|
| `Batchable` | 31 | Safe to admit as one exact-path, fresh-process container. |
| `CapabilityGated` | 3 | Safe when its explicit, deterministic fixture/tool capability is available. |
| `NeedsRefactor` | 9 | Do not admit until the recorded state, collision, topology, or capability seam is repaired. |
| `SerialOnly` | 0 | No exception owner, reason, or removal condition is required. |
| **Total** | **43** | **476 observed tests / 453 textual `It` lines.** |

Abbreviations below: `BA` = `BeforeAll`, `BD` = `BeforeDiscovery`, `BE` = `BeforeEach`, `AE` =
`AfterEach`, `AA` = `AfterAll`, `TD` = `$TestDrive`, and `GT` = a GUID-named temporary root. Unless a row
says otherwise, mutable functions, variables, module state, current location, and environment changes are
fresh-process-local; the file has no dependency on another test file running first.

## Adapters, infrastructure, and executor

| File | Obs/It | Hooks, state, process/capability | Writes, resources, skips | Wall | Class | Evidence and action |
|---|---:|---|---|---:|---|---|
| `tests/adapters/adapter-thinness.Tests.ps1` | 2/2 | BA builds a script-local AST cache; no process or mutable host state. | Read-only adapter source; no skip. | 4.742 s | `Batchable` | Repeatable exact-path structural gate; retain the container-local cache. |
| `tests/adapters/latex-batch.Tests.ps1` | 8/8 | BA/AA manage modules; synthetic planner cases plus child PowerShell and one live LaTeX/Node/KaTeX integration. | TD-only fixtures/results; live toolchain is not gated. | 10.889 s | `NeedsRefactor` | Split the live integration at its capability/cost seam and gate it; the synthetic planner portion is otherwise batchable. |
| `tests/adapters/test-batch.Tests.ps1` | 7/10 | BA/AA manage modules; nested child PowerShell/Pester; saved `PORTABLE_ROOT` is restored in `finally`. | Generated repositories, manifests, tests, and XML are TD-only; no skip. | 10.133 s | `Batchable` | Exact fixture paths and child results are isolated. The planning/integration boundary is an optional cost split. |
| `tests/infrastructure/node-dependencies.Tests.ps1` | 3/3 | BA fixes repository root; invokes ambient Git and changes only process-local `$LASTEXITCODE`. | Read-only working tree and Git index; missing Git is an ungated failure. | 3.828 s | `NeedsRefactor` | Split the Git-index assertion from filesystem checks or add an explicit Git capability outcome. |
| `tests/infrastructure/path-topology.Tests.ps1` | 3/3 | BA builds scan helpers; `Get-Command` probes host-local MCP commands. | Read-only repository/config scan; missing configured commands fail without a gate. | 4.112 s | `NeedsRefactor` | Split portable source topology from a deterministically capability-gated host-command check. |
| `tests/shared/batch-executor-await.Tests.ps1` | 2/2 | BA imports module; local cancellation/runspace resources are stopped and disposed. | TD-only scripts/PID markers; selected process case launches no child; no skip. | 4.682 s | `Batchable` | Resource ownership and cleanup are container-local. |
| `tests/shared/batch-executor-collection.Tests.ps1` | 3/3 | BA imports module; runspaces are disposed; a guarded `Add-Type` is fresh-process-local. | TD-only worker scripts; no fixed resource or skip. | 5.513 s | `Batchable` | Directly proves sibling collection-failure containment. |
| `tests/shared/batch-executor-lifecycle.Tests.ps1` | 6/6 | BA imports module; mocked globals/AppDomain probes and injected handles are reset or disposed. | TD-only workers and process-local fake resources; no skip. | 5.656 s | `Batchable` | Mutable lifecycle probes are explicitly restored. |
| `tests/shared/batch-executor-module.Tests.ps1` | 8/8 | BA plus BE/AE remove modules and a global sentinel around each test. | Canonical module is read-only; copied/mutated module fixtures are TD-only; no skip. | 7.100 s | `Batchable` | Module/global cleanup and write isolation are explicit. |
| `tests/shared/batch-executor-preparation.Tests.ps1` | 5/5 | BA imports module; in-memory copy/serialization cases launch no process. | TD-only scripts and marker; no skip. | 4.927 s | `Batchable` | Deterministic preparation state is container-local. |
| `tests/shared/batch-executor-state.Tests.ps1` | 8/8 | BA imports module; one pipeline is disposed in `finally`; no child process. | In-memory contract tests; no writes, fixed resources, or skip. | 4.125 s | `Batchable` | Pure lifecycle-state boundary. |
| `tests/shared/batch-executor-teardown.Tests.ps1` | 4/4 | BA imports module; exercises runspace/pool teardown and in-memory disposal-failure probes. | TD-only workers plus read-only source AST; no skip. | 4.765 s | `Batchable` | Successful paths close handles before assertion; no shared resource. |
| `tests/shared/batch-executor.Tests.ps1` | 21/21 | BA imports module; many runspaces and exact-PID `$PSHOME` child/grandchild processes; cleanup is in `finally`/survivor helpers. | TD-only scripts, logs, and PID markers; no ports, services, or skip. | 22.360 s | `Batchable` | High cost/resource pressure, but isolated identities and explicit process-tree cleanup satisfy the contract. Runspace, ordinary-process, and termination Describes are natural future cost seams. |
| `tests/shared/batch-plan.Tests.ps1` | 8/8 | BA imports module; mixed runspace/`$PSHOME` child execution and local cancellation disposed in `finally`. | TD-only scripts/modules; no fixed resource or skip. | 8.979 s | `Batchable` | Declared writes and runtime state remain inside the container boundary. |

## LaTeX ingest, audits, postprocess, and document primitives

| File | Obs/It | Hooks, state, process/capability | Writes, resources, skips | Wall | Class | Evidence and action |
|---|---:|---|---|---:|---|---|
| `tests/latex-ingest.refs.Tests.ps1` | 5/5 | BD/BA load the staged `2408.16741v2` golden model into script-local state. | Fixed staged source and committed golden JSONL are read-only; whole Describe skips when source is absent. | 27.542 s | `CapabilityGated` | Explicit corpus-fixture gate; keep this high-cost full-paper/golden container separate and declare the fixture immutable. |
| `tests/latex-ingest/latex-ingest-compat.Tests.ps1` | 4/4 | BA plus BE/AE; legacy conversions indirectly invoke Node/KaTeX. | Each archive/output/run uses a GT and is removed; required math-render capability is ungated. | 7.723 s | `NeedsRefactor` | Split cheap namespace isolation from conversion integration; explicitly gate Node/KaTeX and retain unique run roots. |
| `tests/latex-ingest/latex-ingest.Tests.ps1` | 66/66 | Three BA fixtures plus BE/AE combine pure rules, figure I/O, deposits, end-to-end conversion, TikZ, and Node/KaTeX audit. | Most writes use GT paths, but default end-to-end runs write shared `artifacts/latex-ingest/runs`; capability checks are inconsistent; no skip observed. | 18.276 s | `NeedsRefactor` | High-cost/high-collision restructuring pilot. Split pure conversion, filesystem/figure, deposit, TikZ, and KaTeX seams; route every output through TD/GT caller-owned roots and use hook/`finally` cleanup. |
| `tests/latex-ingest/latex-math-store.Tests.ps1` | 4/4 | BA loads store/lowering functions and process-local JSON caches; no subprocess. | Fixed store JSON is read-only; no writes or skip. | 4.928 s | `Batchable` | Deterministic in-memory store/canonicalization work. |
| `tests/latex-ingest/latex-patch.Tests.ps1` | 16/16 | Two BA fixtures load curated patch functions and script-local source/patch state. | Patch files are TD-only; no subprocess, fixed mutable resource, or skip. | 6.517 s | `Batchable` | Pester-owned writes and fresh-process state are isolated. |
| `tests/latex-ingest/source-deposit.Tests.ps1` | 12/12 | BA plus BE/AE; .NET Tar/Gzip; one `Push-Location` is restored in `finally`. | Each archive/deposit/transaction/lock uses a GT and is cleaned; no skip. | 7.434 s | `Batchable` | Unique roots isolate writes and the deliberate lock-contention fixture. |
| `tests/audits/corpus-health.Tests.ps1` | 6/6 | BA performs one repository corpus scan into script-local state; no subprocess. | Read-only `bibliotecha` trees; no skip. | 12.118 s | `Batchable` | High cost scales with corpus size, but the shared read-only scan is collision-free; retain one container to avoid repeating it. |
| `tests/audits/math-render.Tests.ps1` | 8/8 | BA/AA; Node/KaTeX probes and a standing-oracle scan; process-local `$LASTEXITCODE`. | GUID outputs/scratch below fixed artifact parents; 1 oracle test skipped in this run; dependency and oracle gates are explicit. | 5.463 s | `CapabilityGated` | Unique addresses avoid collision. Consider separating small probes from the high-cost oracle and standardize hard-gate versus skip behavior. |
| `tests/audits/md-lint.Tests.ps1` | 5/5 | BA probes Node/markdownlint and runs local/oracle checks. | TD-only Markdown fixtures; 1 oracle test skipped in this run; dependency/file gates are explicit. | 5.647 s | `CapabilityGated` | Writes are isolated; standardize hard-gate versus skip behavior and split the corpus oracle only if independently useful. |
| `tests/audits/md-repair.Tests.ps1` | 35/9 | BA defines UTF-8/index helpers; parameter rows expand the observed cases. | GUID files are mutated only within TD; no subprocess or skip. | 5.645 s | `Batchable` | Deterministic local repair primitives. |
| `tests/md-postprocess/md-bundle.Tests.ps1` | 4/4 | BA/AA; bundling indirectly invokes ambient Python/CairoSVG. | One GT contains all source/bundle writes and is removed; rasterization capability is ungated. | 5.543 s | `NeedsRefactor` | Split pure copy/link/sentinel behavior from SVG-to-PNG rasterization and gate or pin the converter. |
| `tests/md-postprocess/md-hygiene.Tests.ps1` | 8/8 | BA loads pure formatting functions; no mutable fixture or subprocess. | No filesystem writes, fixed resource, or skip. | 4.528 s | `Batchable` | Repeatable string transformations. |
| `tests/math-register/math-register.Tests.ps1` | 18/18 | BA loads store-driven canonicalization and process-local caches/maps. | Fixed JSON stores are read-only; no subprocess, write, or skip. | 4.656 s | `Batchable` | Deterministic in-memory invariants. |
| `tests/toc-engine/toc-engine.Tests.ps1` | 10/10 | BA loads functions; one standalone child `pwsh`; per-test cleanup uses `finally`. | Each export uses and removes a GT; no shared write or skip. | 7.426 s | `Batchable` | Explicitly proves no load-order dependency. Pinning the child from `$PSHOME` would improve host reproducibility but is not an admission blocker. |

## Procurement, reader, HDBSCAN, and generic shared utilities

| File | Obs/It | Hooks, state, process/capability | Writes, resources, skips | Wall | Class | Evidence and action |
|---|---:|---|---|---:|---|---|
| `tests/hdbscan/hdbscan.Tests.ps1` | 9/9 | BA/AA; eleven CLI calls use the packaged executable when present or ambient `dotnet run`; one test consumes an earlier test's output. | Input/output uses one GT. The packaged executable was present in the measured run, so no shared build occurred; only the ungated fallback can write shared `artifacts/hdbscan/{bin,obj}` paths. | 6.704 s | `NeedsRefactor` | Conditional build-path hazard, not an observed collision. Require/gate the packaged executable or isolate fallback build output; make the consumed baseline fixture-local. |
| `tests/procurement/arxiv.Tests.ps1` | 42/42 | BA plus nested BA and BE/AE; offline Atom fixtures and process-local registry/queue/worker state. | Config, gzip, and inbox fixtures are TD-only; no child/network or skip. | 4.831 s | `Batchable` | Fresh process contains job state. Move the relative absence sentinel into TD for stronger hermeticity. |
| `tests/procurement/scholar-adapters.Tests.ps1` | 11/11 | BA plus nested BA cache offline OpenAlex/S2/arXiv mappings. | No writes, process, network, fixed mutable resource, or skip. | 5.077 s | `Batchable` | Pure adapter cross-walk fixtures. |
| `tests/procurement/scholar-core.Tests.ps1` | 11/11 | BA; pure model/retry cases plus process-local rate-clock state. | No writes, process, or skip. | 5.921 s | `Batchable` | Mutable clock state is fresh-process-local; optional teardown would improve same-runspace reuse. |
| `tests/procurement/scihub.Tests.ps1` | 7/7 | BA loads parsing functions and offline HTML fixtures. | No writes, network, process, mutable host state, or skip. | 4.483 s | `Batchable` | Mirror URLs are inert fixture data. |
| `tests/procurement/zenodo.Tests.ps1` | 5/5 | BA plus nested cached mapping; no subprocess or writes in the tests. | Reads hard-coded repository config/staging paths and silently falls back when config is absent; no skip. | 3.904 s | `NeedsRefactor` | Derive config from `$PSScriptRoot`, use a TD staging root, and assert the intended fixture exists so exact path identifies the container inputs. |
| `tests/reader-mcp/reader-mcp.Tests.ps1` | 9/9 | BA/AA build a GT bundle; seven JSON-RPC tests launch bare `pwsh`, two scan source. | Unique temp writes; no ports/network; child engine is unpinned and ungated; no skip. | 9.751 s | `NeedsRefactor` | Pin the current host or explicitly gate it. Protocol-process and static-source tests form a real cost/capability seam. |
| `tests/shared/encoding-invariants.Tests.ps1` | 12/12 | BA/AA plus nested setup; process-local `JsonlIndex`/Newtonsoft state and 21 publications. | JSONL/index/signature writes use a GT and are removed; no skip. | 6.163 s | `Batchable` | Fresh process isolates type/state; unique temp boundary is collision-free. |
| `tests/shared/jsonl-store-v2.Tests.ps1` | 15/15 | BA loads v2 store/type; deliberate writer lease is disposed in `finally`. | All store/index mutation and lock probing is TD-only; no skip. | 7.772 s | `Batchable` | Fresh process isolates `JsonlIndex`; retain file-level atomicity. |
| `tests/shared/jsonl-v2-compat.Tests.ps1` | 3/3 | BA loads compatibility/v2 code; streams are disposed in `finally`. | JSONL and canonical/legacy indexes are TD-only; no skip. | 7.238 s | `Batchable` | Fully local compatibility fixture. |
| `tests/shared/jsonl-v2.Tests.ps1` | 21/21 | BA loads v2 code; deliberate writer lease is disposed in `finally`. | JSONL/index/snapshot mutation is TD-only; no Pester skip. | 6.778 s | `Batchable` | Fresh process isolates `JsonlIndex`; lock probes have explicit disposal. |
| `tests/shared/log.Tests.ps1` | 16/16 | BA/AA save and restore three environment variables; BE/AE clear state/stop logger; console replacement is restored in `finally`. | TD-only logs; no subprocess or skip. | 5.511 s | `Batchable` | Environment, console, and logger globals are explicitly restored and process-local. |
| `tests/shared/masks.Tests.ps1` | 18/18 | BA; pure mask algebra plus 750 unseeded randomized iterations. | No writes, subprocess, fixed resource, or skip. | 10.019 s | `Batchable` | Cost/reproducibility watch only. Prefer a local recorded seed so a random failure can replay. |
| `tests/shared/md-anchor.Tests.ps1` | 4/4 | BA loads anchor function; final test recursively scans source for a unique definition. | Read-only `src/**/*.ps1`; no write, process, or skip. | 5.184 s | `Batchable` | Repository-wide read is collision-free; a structural seam is optional if scan cost grows. |
| `tests/shared/md-sentinels.Tests.ps1` | 4/4 | BA loads catalogue; final test recursively scans source for private copies. | Read-only `src/**/*.ps1`; no write, process, or skip. | 5.794 s | `Batchable` | Repository-wide read is collision-free; a structural seam is optional if scan cost grows. |

## Pilots and risk register

The positive control selected 57 tests across eight `batch-executor*.Tests.ps1` containers. All 57 passed,
none skipped, and their isolated wall measurements totalled 59.128 s. Every file is `Batchable`; the main
process/lifecycle container is the only material cost outlier at 22.360 s. This closes the BEX-501
independence baseline only—sequential/parallel parity remains BEX-504 work.

The restructuring control selected and passed all 66 tests in 18.276 s. It is `NeedsRefactor`: shared
default artifact addressing, mixed fixtures, and inconsistent external-tool gates make current concurrent
admission unsafe. BEX-504 owns the pilot split and benchmark evidence.

Measured files at or above 10 s are:

| File | Wall | Class / significance |
|---|---:|---|
| `tests/latex-ingest.refs.Tests.ps1` | 27.542 s | `CapabilityGated`; immutable full-paper/golden fixture. |
| `tests/shared/batch-executor.Tests.ps1` | 22.360 s | `Batchable`; process/lifecycle resource pressure. |
| `tests/latex-ingest/latex-ingest.Tests.ps1` | 18.276 s | `NeedsRefactor`; restructuring pilot and shared-write collision. |
| `tests/audits/corpus-health.Tests.ps1` | 12.118 s | `Batchable`; corpus-wide read scan. |
| `tests/adapters/latex-batch.Tests.ps1` | 10.889 s | `NeedsRefactor`; live Node/KaTeX seam. |
| `tests/adapters/test-batch.Tests.ps1` | 10.133 s | `Batchable`; nested process/Pester setup. |
| `tests/shared/masks.Tests.ps1` | 10.019 s | `Batchable`; randomized property workload. |

The write-isolation findings are bounded and visible:

- `latex-ingest.Tests.ps1` demonstrably uses shared default repository artifact roots in two end-to-end
  calls; BEX-504 must give them the container's run-scoped artifact root;
- `hdbscan.Tests.ps1` was collision-free with the provisioned packaged executable, but its missing-package
  `dotnet run` fallback can target shared `artifacts/hdbscan/{bin,obj}` paths and therefore needs an explicit
  capability or isolated build path before admission.

The remaining `NeedsRefactor` files have capability or fixture-topology defects rather than demonstrated
concurrent write collisions. BEX-504 owns the LaTeX restructuring control. BEX-507 owns migration of the
other eight files after BEX-502 freezes the authoring contract and BEX-503 audits the runner. There are no
`SerialOnly` records and therefore no temporary exception debt to carry forward.

## BEX-501 exit gate

- All 43 current physical files have an exact-path isolation result, observed count, approximate wall time,
  semantic resource/state audit, and one of the four required classifications.
- High-cost files, the LaTeX shared-write exposure, and the conditional HDBSCAN build-path hazard are explicit.
- Admission decisions use hooks, state, writes, external resources, capability behavior, and failure
  containment; no file was admitted from discovery names alone.
- BEX-501 is closed. BEX-502 is the next and only unblocked ticket; this inventory does not pre-empt its
  authoring-contract decisions.
