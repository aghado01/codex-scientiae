# Batch executor — Pester batchability inventory

This is the BEX-501 semantic inventory and single-container timing baseline. It applies the
[testing-overhaul brief](../briefs/sol-pester-batch-testing-overhaul-20260805.md) to every physical
`*.Tests.ps1` file present on 2026-08-06. It is an admission record, not a workload manifest or a promise
that individual `It` blocks are independently schedulable.

## Measurement method

- Each physical file was invoked by exact path through `tests/run.ps1` in a fresh child PowerShell process.
- The eight `tests/batch-executor/batch-executor*.Tests.ps1` positive-control files ran first, followed by the
  `tests/latex-ingest/latex-ingest.Tests.ps1` restructuring control and then every remaining file in stable
  path order.
- Every invocation requested its own native NUnit XML result. All 43 processes exited successfully: 476
  tests were selected, 474 passed, 2 were skipped, and none failed.
- `Wall` is a single approximate elapsed measurement and includes child-PowerShell, module, Pester, and
  container startup. It is useful for topology and scheduling review, not a performance guarantee.
- The 43 isolated wall measurements total 320.387 s (mean 7.451 s, median 5.656 s, p90 10.889 s, p95
  18.276 s). The enclosing serialized harness took approximately 321.5 s.
- `Obs/It` means observed Pester tests versus textual `It` lines. Parameter rows expand `md-repair`; embedded
  fixture source inflates the textual count in the then-named `test-batch` container (renamed
  `pester-batch` by BEX-505).

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
| `tests/batch-adapters/adapter-thinness.Tests.ps1` | 2/2 | BA builds a script-local AST cache; no process or mutable host state. | Read-only adapter source; no skip. | 4.742 s | `Batchable` | Repeatable exact-path structural gate; retain the container-local cache. |
| `tests/batch-adapters/latex-batch.Tests.ps1` | 8/8 | BA/AA manage modules; synthetic planner cases plus child PowerShell and one live LaTeX/Node/KaTeX integration. | TD-only fixtures/results; live toolchain is not gated. | 10.889 s | `NeedsRefactor` | Split the live integration at its capability/cost seam and gate it; the synthetic planner portion is otherwise batchable. |
| `tests/batch-adapters/test-batch.Tests.ps1` (then named; now `pester-batch.Tests.ps1`) | 7/10 | BA/AA manage modules; nested child PowerShell/Pester; saved `PORTABLE_ROOT` is restored in `finally`. | Generated repositories, manifests, tests, and XML are TD-only; no skip. | 10.133 s | `Batchable` | Exact fixture paths and child results are isolated. The planning/integration boundary is an optional cost split. |
| `tests/infrastructure/node-dependencies.Tests.ps1` | 3/3 | BA fixes repository root; invokes ambient Git and changes only process-local `$LASTEXITCODE`. | Read-only working tree and Git index; missing Git is an ungated failure. | 3.828 s | `NeedsRefactor` | Split the Git-index assertion from filesystem checks or add an explicit Git capability outcome. |
| `tests/infrastructure/path-topology.Tests.ps1` | 3/3 | BA builds scan helpers; `Get-Command` probes host-local MCP commands. | Read-only repository/config scan; missing configured commands fail without a gate. | 4.112 s | `NeedsRefactor` | Split portable source topology from a deterministically capability-gated host-command check. |
| `tests/batch-executor/batch-executor-await.Tests.ps1` | 2/2 | BA imports module; local cancellation/runspace resources are stopped and disposed. | TD-only scripts/PID markers; selected process case launches no child; no skip. | 4.682 s | `Batchable` | Resource ownership and cleanup are container-local. |
| `tests/batch-executor/batch-executor-collection.Tests.ps1` | 3/3 | BA imports module; runspaces are disposed; a guarded `Add-Type` is fresh-process-local. | TD-only worker scripts; no fixed resource or skip. | 5.513 s | `Batchable` | Directly proves sibling collection-failure containment. |
| `tests/batch-executor/batch-executor-lifecycle.Tests.ps1` | 6/6 | BA imports module; mocked globals/AppDomain probes and injected handles are reset or disposed. | TD-only workers and process-local fake resources; no skip. | 5.656 s | `Batchable` | Mutable lifecycle probes are explicitly restored. |
| `tests/batch-executor/batch-executor-module.Tests.ps1` | 8/8 | BA plus BE/AE remove modules and a global sentinel around each test. | Canonical module is read-only; copied/mutated module fixtures are TD-only; no skip. | 7.100 s | `Batchable` | Module/global cleanup and write isolation are explicit. |
| `tests/batch-executor/batch-executor-preparation.Tests.ps1` | 5/5 | BA imports module; in-memory copy/serialization cases launch no process. | TD-only scripts and marker; no skip. | 4.927 s | `Batchable` | Deterministic preparation state is container-local. |
| `tests/batch-executor/batch-executor-state.Tests.ps1` | 8/8 | BA imports module; one pipeline is disposed in `finally`; no child process. | In-memory contract tests; no writes, fixed resources, or skip. | 4.125 s | `Batchable` | Pure lifecycle-state boundary. |
| `tests/batch-executor/batch-executor-teardown.Tests.ps1` | 4/4 | BA imports module; exercises runspace/pool teardown and in-memory disposal-failure probes. | TD-only workers plus read-only source AST; no skip. | 4.765 s | `Batchable` | Successful paths close handles before assertion; no shared resource. |
| `tests/batch-executor/batch-executor.Tests.ps1` | 21/21 | BA imports module; many runspaces and exact-PID `$PSHOME` child/grandchild processes; cleanup is in `finally`/survivor helpers. | TD-only scripts, logs, and PID markers; no ports, services, or skip. | 22.360 s | `Batchable` | High cost/resource pressure, but isolated identities and explicit process-tree cleanup satisfy the contract. Runspace, ordinary-process, and termination Describes are natural future cost seams. |
| `tests/batch-executor/batch-plan.Tests.ps1` | 8/8 | BA imports module; mixed runspace/`$PSHOME` child execution and local cancellation disposed in `finally`. | TD-only scripts/modules; no fixed resource or skip. | 8.979 s | `Batchable` | Declared writes and runtime state remain inside the container boundary. |

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
independence baseline; BEX-504 parity evidence is recorded below.

The restructuring control selected and passed all 66 tests in 18.276 s. It is `NeedsRefactor`: shared
default artifact addressing, mixed fixtures, and inconsistent external-tool gates make current concurrent
admission unsafe. This is the pre-BEX-504 topology and timing baseline.

Measured files at or above 10 s are:

| File | Wall | Class / significance |
|---|---:|---|
| `tests/latex-ingest.refs.Tests.ps1` | 27.542 s | `CapabilityGated`; immutable full-paper/golden fixture. |
| `tests/batch-executor/batch-executor.Tests.ps1` | 22.360 s | `Batchable`; process/lifecycle resource pressure. |
| `tests/latex-ingest/latex-ingest.Tests.ps1` | 18.276 s | `NeedsRefactor`; restructuring pilot and shared-write collision. |
| `tests/audits/corpus-health.Tests.ps1` | 12.118 s | `Batchable`; corpus-wide read scan. |
| `tests/batch-adapters/latex-batch.Tests.ps1` | 10.889 s | `NeedsRefactor`; live Node/KaTeX seam. |
| `tests/batch-adapters/test-batch.Tests.ps1` (then named; now `pester-batch.Tests.ps1`) | 10.133 s | `Batchable`; nested process/Pester setup. |
| `tests/shared/masks.Tests.ps1` | 10.019 s | `Batchable`; randomized property workload. |

The write-isolation findings are bounded and visible:

- the pre-BEX-504 `latex-ingest.Tests.ps1` used shared default repository artifact roots in two end-to-end
  calls; BEX-504 repaired that exposure as recorded below;
- `hdbscan.Tests.ps1` was collision-free with the provisioned packaged executable, but its missing-package
  `dotnet run` fallback can target shared `artifacts/hdbscan/{bin,obj}` paths and therefore needs an explicit
  capability or isolated build path before admission.

The remaining `NeedsRefactor` files have capability or fixture-topology defects rather than demonstrated
concurrent write collisions. BEX-504 closes the LaTeX restructuring control below. BEX-507 owns migration
of the other eight files. There are no `SerialOnly` records and therefore no temporary exception debt to
carry forward.

## Post-baseline deltas

BEX-503 did not add a physical container or change any classification. It added three outer runner-contract
tests and six embedded fixture `It` lines to the then-named `tests/batch-adapters/test-batch.Tests.ps1`, moving the
current mechanical count from 453 to 462 textual lines and the current observed repository count from 476
to 479.
That container now selects 10 tests and took 29.710 s in its focused closure run; its original 7/10.133 s row
above remains the BEX-501 measurement. The added cost is the deliberate Pester 5.7.1/6.0.0 and nested-child
parity battery, not a newly discovered isolation defect, so its `Batchable` classification remains valid.
The authoritative post-change repository run passed 477 tests, skipped 2 dependency-gated tests, and failed
none in 122.241 s.

BEX-504 adds one physical file but no `It`: `latex-ingest.Tests.ps1` retains 60 pure/converter tests and is
now `Batchable`; `latex-ingest-integration.Tests.ps1` owns the 6 external-process/run-artifact tests and is
`CapabilityGated`. Direct exact-path measurements were 7.190 s and 9.701 s respectively. The integration
container uses explicit reasoned Node/KaTeX and node-tikzjax skips, writes beneath `$TestDrive` or six
suite-owned case roots below an absolute `CODEX_TEST_ARTIFACT_ROOT`, and compares repository LaTeX-run state
at teardown. A supplied-root probe passed all 6 tests and placed 62 files below those six roots.
The same integration container passed 6/6 by exact path under Pester 5.7.1.

The positive control required no split. Its 8 containers/57 tests produced identical observations and 8
native XML files at one and four workers, with no missing/undeclared file or surviving runner; wall time was
46.724 s versus 21.394 s (2.184x). The LaTeX control produced identical 66/66 outcomes and 2 native XML files
at one and two workers, with no missing/undeclared file, repository-run residue, or surviving descendant;
wall time was 19.545 s versus 10.275 s (1.902x). The selected topology is therefore supported by both
semantic and timing evidence without a new scheduler, lock, workload manifest, or permanent nested
benchmark test. Post-refactor closure selected 479 repository tests in 93.244 s: 477 passed, 2 skipped, and
none failed.

BEX-505 renamed that adapter container to `tests/batch-adapters/pester-batch.Tests.ps1` without changing its
classification, the physical-file job boundary, or the inventory totals. Its current contract now witnesses
stable `pester:<repository-relative-path>#<digest>` identity, one `pester-jobs` address resolver, sibling
`pester.xml` and `artifacts/` declared writes, `CODEX_TEST_ARTIFACT_ROOT` child transport, and planning that
creates neither address. The former generic adapter names remain above only as explicit BEX-501/BEX-503
measurement provenance.

BEX-506 adds one `Batchable` physical container, `tests/batch-adapters/parallel.Tests.ps1`. Its three outer tests
pass by exact path; four additional textual `It` lines are fixture source executed only in nested child
repositories, so the mechanical count increases from 462 to 469 without creating seven repository tests.
The container's structural witness rejects duplicated scheduler/lifecycle/run/log/store/address ownership;
its two runtime witnesses prove two-file success and sibling failure/real-CLI behavior with native XML,
container artifacts, complete execution-record evidence, and no surviving child. The complete sequential
repository gate selected 482 tests: 480 passed, 2 were dependency-gated skips, and none failed.

Current inventory after BEX-506:

| Class | Files |
|---|---:|
| `Batchable` | 33 |
| `CapabilityGated` | 4 |
| `NeedsRefactor` | 8 |
| `SerialOnly` | 0 |
| **Total** | **45 files / 482 observed tests / 469 textual `It` lines** |

### BEX-507 final migration

BEX-507 preserves all historical measurements and re-audits the eight remaining `NeedsRefactor` files:

| File | Final class | Migration evidence |
|---|---|---|
| `tests/batch-adapters/latex-batch.Tests.ps1` | `CapabilityGated` | The live Node/KaTeX assertion has an exact preflight and reasoned skip; the child receives only the pinned capability path. |
| `tests/infrastructure/node-dependencies.Tests.ps1` | `CapabilityGated` | Filesystem checks remain portable; only the Git-index assertion is gated by an exact Git probe and reasoned skip. |
| `tests/infrastructure/path-topology.Tests.ps1` | `CapabilityGated` | Portable repository topology is separate from the explicitly gated host-MCP executable check; the same container now freezes the one-adapters-module/one-runner/one-parallel-composition/no-sidecar topology. |
| `tests/latex-ingest/latex-ingest-compat.Tests.ps1` | `CapabilityGated` | Namespace isolation remains portable; the three legacy conversions use explicit rendering-capability gates and `$TestDrive` scratch. |
| `tests/md-postprocess/md-bundle.Tests.ps1` | `CapabilityGated` | Portable bundling is independent of a separately gated exact Python/CairoSVG rasterization assertion; all scratch uses `$TestDrive`. |
| `tests/hdbscan/hdbscan.Tests.ps1` | `CapabilityGated` | The packaged executable is preflighted and no ambient `dotnet` build fallback remains; every case builds its own fixture and all retained CLI work uses the assigned container artifact root. |
| `tests/procurement/zenodo.Tests.ps1` | `Batchable` | Repository config is derived from `$PSScriptRoot` and asserted present; staging is `$TestDrive`-local. |
| `tests/reader-mcp/reader-mcp.Tests.ps1` | `Batchable` | JSON-RPC children use the absolute current PowerShell host, bounded redirected UTF-8 I/O, timeout, tree kill, and `finally` disposal. |

The HDBSCAN batch symptom did not reveal a LaTeX/HDBSCAN shared-path collision. All nine Pester assertions
passed, but native stderr was written directly and the last deliberately nonzero CLI probe left exit status
1, contaminating the worker protocol after Pester completed. A local captured-process helper now owns
stdout, stderr, and status; resets `$LASTEXITCODE`; and confines retained work to
`pester-jobs/<container>/artifacts/hdbscan-cli`. The repaired file is 9/9 by exact-path sequential execution,
and its singleton executor job succeeds with exit status zero, no executor error, and 36 artifacts below
that root. No LaTeX/HDBSCAN shared-path collision remains.

The final repaired-tree Pester 6 sequential gate selected 484 tests in 111.988 seconds: 482 passed, none
failed, and 2 were explicitly skipped. Its only warnings were the two existing unresolved/out-of-root LaTeX
inputs. The complete four-worker repository gate then admitted every physical file through ordinary path
selection. All 45 jobs succeeded in 108.007 seconds with the same observed outcomes. The run retained 45
`pester.xml` reports and 143 produced files, with zero file outside declared `Writes`, zero missing result,
and zero surviving worker; repository status was stable. The one additional
topology assertion and one separate SVG-rasterization assertion move the current mechanical count from 469
to 471 textual `It` blocks and the observed count from 482 to 484.

Final inventory after BEX-507:

| Class | Files |
|---|---:|
| `Batchable` | 35 |
| `CapabilityGated` | 10 |
| `NeedsRefactor` | 0 |
| `SerialOnly` | 0 |
| **Total** | **45 files / 484 observed tests / 471 textual `It` blocks** |

### Post-BEX-507 additions

`tests/latex-ingest/inventory-batch-dev.Tests.ps1` adds one `Batchable` container with 6 observed/textual
tests. Its exact-path fresh-process run passed 6/6 in 3.930 s. Fixtures, catalogs, run roots, fake converter,
and child outputs are `$TestDrive`-local; child PowerShell uses the current absolute host and every process is
collected. The container proves deterministic/atomic catalog behavior plus the application shell's selected
success and sibling-failure paths without a fixed port, external dependency, repository-global write, or
capability skip.

The resulting four-worker repository gate admitted all 46 physical files in 100.255 s. All 46 jobs
succeeded; the native reports selected 490 tests (488 passed, 2 existing dependency-gated skips), with no
failure, timeout, cancellation, or infrastructure error. The caller run retained 46 `pester.xml` files and
144 total files, all beneath the declared `pester-jobs/<container>/{pester.xml,artifacts/...}` shape, with no
surviving process.

Current inventory after that addition:

| Class | Files |
|---|---:|
| `Batchable` | 36 |
| `CapabilityGated` | 10 |
| `NeedsRefactor` | 0 |
| `SerialOnly` | 0 |
| **Total** | **46 files / 490 observed tests / 477 textual `It` blocks** |

### JSONL engine PowerShell client addition

`tests/jsonl_engine-client/jsonl_engine-client-module.Tests.ps1` adds one `CapabilityGated` container with 17
observed/textual tests. The final focused exact-path direct run passed 17/17 in 10.65 seconds, and an ordinary
one-worker adapter/executor run succeeded as one job in 11.997 seconds with one native XML report selecting
the same 17 outcomes. Module imports are read-only; fixtures and input files use `$TestDrive`; the explicit
temporary input is removed in `finally`; the slow-process fixture is bounded by the client's process-tree
timeout; and every live Python invocation uses the repository or explicitly supplied interpreter. The
structural import/surface case remains runnable without the repository Python environment; live process
and engine-integration cases are deterministically skipped when neither repository interpreter exists.

The existing `tests/infrastructure/path-topology.Tests.ps1` gains one assertion freezing a single
PowerShell owner for `python -m jsonl_engine`, so its physical classification is unchanged while its
observed/textual count grows by one. Focused execution of that assertion passed 1/1. The four retired
PowerShell JSONL containers and the unrelated logistics source reference remain separate known topology
archaeology, so no new whole-repository Pester closure is claimed here.

`tests/batch-adapters/pytest-batch.Tests.ps1` adds one `CapabilityGated` container with five observed/textual
tests. Its three planning cases remain runnable with a fake interpreter; only the two live runner/executor
cases require the explicitly detected repository Python capability. The multilingual
`tests/batch-adapters/parallel.Tests.ps1` container gains two observed tests plus two additional textual `It` lines
inside nested fixture source, and `tests/infrastructure/path-topology.Tests.ps1` gains one further observed
and textual composition assertion. Those existing containers retain their classifications.

`tests/latex-ingest/latex-source-deposit.Tests.ps1` adds one `CapabilityGated` container with five
observed/textual tests. Its focused exact-path run passed 5/5. The cases publish and idempotently validate the
flat article through the Python engine, exercise both not-applicable probe outcomes, and prove conflict
refusal without overwrite; repository-Python availability is an explicit container capability. A mixed
two-worker gate paired it with `tests/shared/test_deposit.py`: both jobs succeeded in 9.641 seconds with five
Pester outcomes and 53 pytest outcomes retained separately under
`artifacts/test-runs/deposit-parity-hardened-20260808`; the pytest job-local `json-scratch` was empty.

Current semantic inventory after this addition:

| Class | Files |
|---|---:|
| `Batchable` | 36 |
| `CapabilityGated` | 13 |
| `NeedsRefactor` | 0 |
| `SerialOnly` | 0 |
| **Total** | **49 files / 521 observed tests / 510 textual `It` blocks** |

### Canonical LaTeX patch activation

D20 extends three existing containers without adding a physical file or changing a classification.
`tests/latex-ingest/latex-patch.Tests.ps1` grows from 16 to 22 observed/textual tests and remains
`Batchable`; its exact-file Pester 6 gate passed 22/22. The new cases freeze tolerant physical-line parsing,
strict bytes and closed record fields, exact portable-leaf lookup, the 1 MiB raw-byte ceiling, raw identity
and drift, confinement, macro/regex guards, and audit provenance.

`tests/latex-ingest/latex-ingest-integration.Tests.ps1` grows from six to seven observed/textual tests and
remains `CapabilityGated`. Its exact-file gate passed 7/7 with the repository Python, Node, and KaTeX
capabilities. The new real-article case proves that a canonical document-root patch wins over a conflicting
same-named `OutDir` file, preserves the source fingerprint, carries identity and authored-line provenance in
order, agrees with the oracle count, and produces the same audit and markdown on rerun.

`tests/batch-adapters/latex-batch.Tests.ps1` grows from eight to ten observed/textual tests and remains
`CapabilityGated`; its exact-file gate passed 10/10. Planning freezes present/absent patch identity without
creating run artifacts or declaring the patch as a write; it rejects non-file occupancy, reparse traversal,
and patch input larger than 1 MiB. Execution refuses patch appearance, content change, or deletion after
planning while preserving sibling containment.

Current semantic inventory after this activation:

| Class | Files |
|---|---:|
| `Batchable` | 36 |
| `CapabilityGated` | 13 |
| `NeedsRefactor` | 0 |
| `SerialOnly` | 0 |
| **Total** | **49 files / 530 observed tests / 519 textual `It` blocks** |

## BEX-501 exit gate

- All 43 BEX-501 physical files have an exact-path isolation result, observed count, approximate wall time,
  semantic resource/state audit, and one of the four required classifications.
- High-cost files, the LaTeX shared-write exposure, and the conditional HDBSCAN build-path hazard are explicit.
- Admission decisions use hooks, state, writes, external resources, capability behavior, and failure
  containment; no file was admitted from discovery names alone.
- BEX-501 is closed. BEX-502 froze D23, BEX-503 hardened the runner, BEX-504 validated and reclassified both
  pilots, BEX-505 implemented Pester artifact transport, BEX-506 added the thin product shell, and BEX-507
  migrated the full repository and closed Phase 5 with no refactor or serial residue.
