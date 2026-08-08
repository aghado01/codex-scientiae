# Review Python JSONL engine

> So after some careful consideration, i decided to write the codex-scientiae json/jsonl engine in python instead of powershell. ptal src/shared/jsonl_engine

<details><summary>4 previous messages</summary>

> I’ll review `src/shared/jsonl_engine` as a code-review pass: architecture and API shape, correctness/edge cases, tests, and fit with the project’s separation-of-code-and-config direction. I’ll keep this read-only unless you ask me to implement fixes.
>
> The package is substantial (roughly 2,900 source lines plus schemas), with a CLI and thin PowerShell front end already in place. I’m narrowing the review around the engine’s durability contract—bounded reads, atomic replacement, sidecar consistency, and schema/kind boundaries—then I’ll run the project’s prescribed focused tests.
>
> The existing tests cover many of the intended invariants, but I’ve already found a few contracts they do not exercise—especially failure recovery after a rejected append, reading headered kinds through `open_store()`, and strict JSON/RFC behavior. I’m running the full Python JSONL test cluster now, then I’ll reproduce the highest-risk gaps independently so the review is evidence-backed.
>
> The core suite is green: 119/119 tests passed, including the PowerShell shell round-trip. The main concern is that several “stable/transactional” guarantees fail just outside the tested paths: a failed `__enter__` can retain the write lease, a caught append error can publish a self-contradictory index, and a bounded view follows a later replacement instead of staying on the generation it was created from. I’m consolidating those into a prioritized handoff rather than treating green tests as readiness.

</details>

Python is the right choice here. The layering is coherent, the PowerShell surface is genuinely thin, and deterministic-byte, sidecar, concurrency, and interop coverage is unusually thoughtful. However, I would not make it the authoritative replacement yet: the green suite misses several reproducible integrity failures.

## Findings

1. **[P1] Failed entry can retain the write lease.** The lease is acquired before adoption, but the unterminated-tail check can raise before cleanup begins ([engine.py:124](./src/shared/jsonl_engine/engine.py:124), [engine.py:225](./src/shared/jsonl_engine/engine.py:225)). Holding the failed engine object caused the next writer to time out. Wrap everything after lease acquisition in one cleanup guard.

2. **[P1] A caught append failure corrupts the index.** The offset is recorded before serialization ([engine.py:280](./src/shared/jsonl_engine/engine.py:280)). After catching one unserializable record and appending a valid one, I got one physical row, indexed length `2`, offsets `[0, 0]`, duplicate random-access results—and `verify()` still returned true.

3. **[P1] “Stable views” are not tied to a file generation.** `at_length()` and `at_signature()` retain only a byte count, while reads reopen the pathname later ([reader.py:299](./src/shared/jsonl_engine/reader.py:299), [reader.py:390](./src/shared/jsonl_engine/reader.py:390)). I created both views over `{"x":1}`, replaced the store with `{"x":2}`, and both returned `{"x":2}`; the old signed view verified the new generation. Cache/check generation identity and the exact signature, or rename these as extent-only views.

4. **[P1] Snapshot can destroy its source.** `snapshot(path, path)` opens the destination for writing after opening the source, truncating both to zero bytes ([inspect.py:133](./src/shared/jsonl_engine/inspect.py:133)). It should reject equivalent paths and publish through a unique adjacent temporary file.

5. **[P1] Registry invariants are bypassable, while the corresponding reader is broken.**
   - `Registry` blocks `add()`/`write()` but inherits public `open_writer()` ([base.py:176](./src/shared/jsonl_engine/kinds/base.py:176)). I used it to publish an unsorted registry whose header claimed zero members while containing six.
   - `open_store()` applies the payload validator to every row ([base.py:197](./src/shared/jsonl_engine/kinds/base.py:197)), so `SchemaRegistry.open_store()` rejects its own header.

6. **[P1] The writer can emit stores its reader refuses—or JSON that is not JSON.** `json.dumps()` permits `NaN` by default ([writer.py:47](./src/shared/jsonl_engine/writer.py:47)); I obtained `{"x":NaN}`. `JsonlEngine` also writes UTF-16LE stores that `JsonlStore` categorically refuses, while `write_json(..., encoding="utf-16")` cannot round-trip because the newline is separately encoded with another BOM. Writer acceptance should imply reader acceptance, and non-finite numbers should be rejected.

7. **[P2] The CLI does not cover the engine’s declared value domain.** ASCII-codec records containing an unpaired surrogate fail at `_emit()` because it switches back to `ensure_ascii=False` ([cli.py:33](./src/shared/jsonl_engine/cli.py:33)). Also, `find /n gt 1` crashes on a row missing `/n`, and default `verify` reports true with an extra unterminated tail because it silently verifies only the last complete prefix.

8. **[P2] Windows path aliases receive different locks.** Hashing the spelling of `abspath` means case variants of the same Windows file receive different leases ([sidecar.py:115](./src/shared/jsonl_engine/sidecar.py:115)). Use at least `realpath` plus `normcase`; also escape the artifact portion before using it in `glob`.

9. **[Process] The 119 Python tests are outside the canonical test lane.** `tests/run.ps1` and the batch executor discover Pester containers only; no repository workflow invokes pytest. Unless an external job exists, these tests are invisible to the normal gate. This deserves a pytest batch adapter or an explicitly documented second canonical runner.

Recommended repair order: transaction state/lease cleanup → generation-bound reads and safe snapshots → registry API symmetry → strict JSON/text policy and CLI boundary → pytest batch integration.

Verification: **119/119 tests passed** in 7.70s. Pytest also warned that `.pytest_cache` is inaccessible. No source files were changed.

> ok, lets do all of the above. except for the python test consolidation, which was my next question, because i just built the batch-executor pester batch adapter and the python tests so far haven't been written in a batch harness friendly manner. im not sure what that even looks like in this multilingual repo or python in particular, but im sure it can be done and i do want parity. lets address bugs elsewhere first

I’ll fix the eight code-level findings and add focused pytest regressions in the existing Python test layout, without touching runner/batch integration. I’ll start with transaction integrity, then stable views/snapshots, registry boundaries, and finally CLI/path-policy issues before running the full 119-test cluster plus the new cases.

> you can deploy subagents for this. just deploy them with care

<details><summary>18 previous messages</summary>

> I’ll use three carefully separated lanes: one for write transactions/text policy, one for generation-stable reads and snapshots, and one for registry semantics. I’ll keep the CLI/integration work here so shared-file overlap stays minimal, then reconcile and run everything together.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./src/shared/jsonl_engine/cli.py` (+96 -30)
> - Wrote `./src/shared/jsonl_engine/cli.py` (+10 -4)
> - Wrote `./src/shared/jsonl_engine/cli.py` (+4 -4)
>
> </details>
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./tests/shared/test_shell_surface.py` (+63 -0)
> - Wrote `./src/shared/jsonl_engine/kinds/base.py` (+15 -8)
> - Wrote `./tests/shared/test_commit.py` (+38 -12)
>
> </details>
>
> The registry lane is complete and its focused suite is green. It now refuses public streaming, reads its own headered artifacts correctly, and releases an already-open engine if header construction fails. The remaining two lanes are working through the trickier state guarantees: distinguishing in-place growth from replacement, and making write failures either fully recoverable or explicitly transaction-fatal.
>
> Context compaction
>
> Source: automatic
> Status: completed
>
> The three delegated slices are back and individually green. I’m doing the integration pass now: checking their combined diff for semantic collisions, tightening any remaining edge cases, then running the complete shared-engine suite.
>
> The combined behavior is coherent so far. I found two stale doc claims left over from the old in-place/UTF-8-only model, plus one snapshot-cleanup path that could mask the original failure; I’m correcting those before the final run.
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./src/shared/jsonl_engine/engine.py` (+9 -9)
> - Wrote `./src/shared/jsonl_engine/inspect.py` (+6 -4)
> - Wrote `./src/shared/jsonl_engine/reader.py` (+6 -6)
>
> </details>
>
> The integrated shared suite is clean: 147/147 Python tests pass, including the PowerShell shell-boundary tests. I’m checking the repository-wide test surface and the independent review now so I can distinguish engine regressions from unrelated renovation breakage.
>
> The Python/PowerShell process boundary itself is covered and green under pytest. The older Pester JSONL container can load Pester 6, but its setup still points at the retired `src/shared/jso-ops/jsonl-v2.ps1`; that is the expected renovation-era stale pointer, not a failure in the new Python engine. I’m leaving that migration for the deferred harness-parity work.
>
> One integration edge surfaced during the CLI review: policy inference made ordinary reads depend on a structurally valid optional signature, even though the reader contract says malformed optional sidecars must only fail signature-requiring operations. I’m restoring that separation and pinning it with a subprocess regression.
>
> <details><summary>Edited 2 files</summary>
>
> - Wrote `./src/shared/jsonl_engine/cli.py` (+13 -11)
> - Wrote `./tests/shared/test_shell_surface.py` (+16 -0)
>
> </details>
>
> The independent integration review found three real invariants the first pass didn’t cover: APPEND could re-sign invalid or differently encoded legacy bytes, explicitly requested UTF-8-with-BOM documents didn’t round-trip, and stale-scratch discovery could overmatch a different artifact sharing the same prefix. I’m splitting those into three non-overlapping fixes and will rerun the whole matrix afterward.
>
> I also found one last predicate corner in my own CLI patch: ordered comparisons were guarded, but `contains` could still raise when a string field was compared with a non-string JSON literal. I’m making every heterogeneous-row predicate total, so “not comparable” consistently means “not a match.”
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./src/shared/jsonl_engine/cli.py` (+12 -3)
> - Wrote `./tests/shared/test_shell_surface.py` (+19 -2)
> - Wrote `./src/shared/jsonl_engine/__init__.py` (+5 -6)
>
> </details>
>
> All three follow-up fixes are in and their focused suites pass. I’m reviewing the APPEND signature-currentness logic now—the highest-risk piece—then I’ll run the final full suite once, from the combined tree.
>
> <details><summary>Edited 2 files</summary>
>
> - Wrote `./src/shared/jsonl_engine/engine.py` (+3 -2)
> - Wrote `./src/shared/jsonl_engine/inspect.py` (+1 -1)
>
> </details>
>
> The final combined suite is green: 155/155. I’m at the handoff check now—compile, whitespace, changed-file inventory, and confirmation that the pre-existing `masks.ps1` edit remains untouched.

</details>

Implemented all requested code-level fixes; Python batch-harness consolidation remains deferred.

Key outcomes:

- Transaction cleanup, poisoning, short-write detection, and strict APPEND adoption.
- Generation-stable bounded reads and atomic snapshots.
- Strict JSON numbers, encoding/BOM parity, and terminator enforcement.
- Registry validation and streaming-bypass closure.
- Robust CLI surrogate output, heterogeneous predicates, policy inference, and torn-tail verification.
- Canonical locks and exact scratch-file discovery.

Validation:

- `155 passed` across the complete shared Python suite.
- Package compilation and `git diff --check` pass.
- Legacy `jsonl-v2.Tests.ps1` cannot start because it still imports the removed `src/shared/jso-ops/jsonl-v2.ps1`; migration was intentionally left for the later harness-parity work.

Changes are in [jsonl_engine](./src/shared/jsonl_engine) with regressions in [tests/shared](./tests/shared). I left unrelated `src/shared/masks.ps1` and `issues/infrastructure/discussions/opus-minutiae.md` untouched.

> ok so what does the testing update look like

<details><summary>3 previous messages</summary>

> I’ll map the existing Python suite onto the batch-executor’s actual job contract, then give you a concrete parity design—adapter shape, job granularity, result protocol, file changes, and migration order. I’m keeping this read-only for now.
>
> Context compaction
>
> Source: automatic
> Status: completed
>
> The first inventory result is encouraging: all 10 current Python files pass as simultaneous, isolated exact-file runs. So parity can preserve meaningful test containers; it doesn’t require turning 155 tests into 155 jobs or merging everything into one Python batch. I’m reconciling that result with the adapter and documentation contracts now.

</details>

The Python suite is much closer to batch-ready than feared: all 10 current `test_*.py` files passed when run simultaneously as independent exact-file pytest processes. We do not need to rewrite the `unittest.TestCase` tests or schedule 155 individual methods.

The recommended architecture is:

```text
Get-PesterBatchJob ─┐
                    ├─ New-BatchPlan once → Invoke-BatchPlan once
Get-PytestBatchJob ─┘

Each pytest job:
PowerShellProcess → tests/pytest.ps1 → pinned python -m pytest <exact-file>
```

This keeps the batch-executor core unchanged. The PowerShell wrapper is intentional: it preserves the executor’s existing supervision, timeout, and process-tree behavior while launching Python underneath it. No `xdist` and no second scheduler.

### Job boundary

One physical `test_*.py` file becomes one isolated job. Classes, parametrization, and `subTest` outcomes remain inside that container.

Each job would receive:

- A stable `pytest:<relative-path>#<selector-digest>` identity.
- Its own `pytest.xml`, artifact directory, and temporary directory.
- An exact Python executable and repository root.
- `PYTHONDONTWRITEBYTECODE=1`.
- Job-local `TMP`, `TEMP`, `TMPDIR`, and JSON engine scratch storage.
- `-p no:cacheprovider` and protection from ambient pytest options/plugins.
- JUnit XML as the durable result authority.
- A compact `PytestContainerObservation` before propagating failure or empty collection.

### Small test cleanups first

This is not a wholesale consolidation. Four seams should be repaired before freezing job identities:

1. [test_byte_equality.py](./tests/shared/test_byte_equality.py) must never regenerate committed goldens during an ordinary test run. Regeneration should move to an explicit maintenance utility; missing fixtures should fail.

2. The engine’s repository-global `artifacts/json-scratch` needs a process-scoped override so every job receives its own scratch root.

3. The shared `_article` factory should move out of `test_jsonl_engine.py`; tests should not import helpers from another collected test module.

4. [test_shell_surface.py](./tests/shared/test_shell_surface.py) should split into Python CLI and PowerShell integration containers. The latter is capability-gated, with bounded descendant-process cleanup.

That produces 11 pytest jobs, none requiring `SerialOnly`.

### Repository surfaces

The implementation would add:

- `Get-PytestBatchJob` beside `Get-PesterBatchJob`.
- `tests/pytest.ps1`, the authoritative exact-path pytest runner.
- Pester tests covering pytest discovery, addressing, dependency preflight, JUnit results, empty collection, failures, and sibling containment.
- A pytest-specific batchability inventory and workplan.
- Updates to adapter, executor, and test documentation.

Once that adapter is proven, [tests/parallel.ps1](./tests/parallel.ps1) should become the single multilingual composer: obtain Pester and pytest jobs independently, concatenate them, build one plan, and invoke it once. A framework selector can preserve Pester-only and pytest-only workflows.

So “consolidation” here means one orchestration surface and one aggregate execution record—not combining Python files into a monolithic suite. The behavior-oriented file boundaries are already useful parallel containers.

> alright lets do that

<details><summary>30 previous messages</summary>

> I’m implementing this as a staged pytest admission, not a test rewrite: first isolate the four unsafe seams, then add the pytest runner/adapter, integrate both frameworks into one plan, and finish with parity and undeclared-write checks. I’ll keep the existing Pester contracts operational throughout.
>
> The implementation is now partitioned cleanly: one worker owns Python isolation/refactors, one owns the pytest adapter and exact-file runner, and one owns only documentation/decision records. I’m retaining the multilingual composition shell and end-to-end parity checks here so the integration point has a single owner.
>
> The evidence supports the simpler boundary: file-level jobs are sufficient, and the current suite already survives true concurrent exact-file execution. The main implementation risk is therefore write isolation—not pytest collection—so I’m treating fixture regeneration and the engine scratch root as admission blockers before the unified shell goes live.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/parallel.ps1` (+47 -6)
>
> </details>
>
> The isolation tranche is taking shape without collapsing the suite: shared data factories and golden-generation logic are being separated from collected tests, while the adapter remains a sibling of the Pester planner. I’m also preserving a single `tests/parallel.ps1` owner so “all tests” still means one plan and one executor invocation.
>
> <details><summary>Edited 5 files</summary>
>
> - Wrote `./tests/adapters/adapter-thinness.Tests.ps1` (+2 -1)
> - Wrote `./tests/adapters/latex-batch.Tests.ps1` (+1 -1)
> - Wrote `./tests/adapters/pester-batch.Tests.ps1` (+1 -1)
> - Wrote `./tests/infrastructure/path-topology.Tests.ps1` (+4 -2)
> - Wrote `./tests/adapters/parallel.Tests.ps1` (+7 -4)
>
> </details>
>
> The core executor remains untouched as intended. The new planner is being wired into the existing adapters module, and the Python cleanup has now separated CLI tests and reusable test data; next I’ll audit those edits for exact-file behavior before enabling `-Framework All` in the integration tests.
>
> The suite refactor is now concrete: ordinary tests can no longer mutate committed goldens, direct pytest runs get an isolated scratch domain, and the PowerShell boundary has its own capability-gated container with bounded process cleanup. I’m moving into verification now while the adapter’s own Pester contract tests finish.
>
> <details><summary>Edited 2 files</summary>
>
> - Wrote `./tests/adapters/parallel.Tests.ps1` (+68 -0)
> - Wrote `./tests/adapters/parallel.Tests.ps1` (+4 -1)
> - Wrote `./tests/parallel.ps1` (+4 -2)
> - Wrote `./tests/adapters/parallel.Tests.ps1` (+52 -0)
>
> </details>
>
> The adapter’s own gate is green, including native pytest exit codes 0/1/5 and direct-runner isolation against hostile inherited pytest settings. I’ve now added the two repository-level witnesses that matter for parity: mixed-framework success in one plan, and a failing pytest job that does not suppress its successful Pester sibling or either framework’s native evidence.
>
> <details><summary>Edited 2 files</summary>
>
> - Wrote `./tests/adapters/parallel.Tests.ps1` (+0 -112)
> - Wrote `./tests/adapters/parallel.Tests.ps1` (+112 -0)
> - Wrote `./tests/infrastructure/path-topology.Tests.ps1` (+11 -1)
>
> </details>
>
> The first repository-level topology run exposed an existing blind spot: batch-topology assertions were placed after a source-reference assertion that already fails on the four retired JSONL PowerShell paths (plus `runs-depr.ps1`), so the batch checks never executed. I’m separating those assertions so the new adapter/runner topology can be verified independently while leaving the unrelated stale-path failures explicit.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/infrastructure/path-topology.Tests.ps1` (+2 -0)
>
> </details>
>
> The focused topology probe is unexpectedly hanging during repository enumeration rather than failing an assertion. I’m stopping that probe and narrowing the scan; the new mixed-framework execution tests themselves are already green, so this is now a test-infrastructure diagnosis rather than an adapter failure.
>
> The ownership probe completed green once its buffered output was retrieved. I’m now running the real repository Python lane through `tests/parallel.ps1`—11 file jobs, one shared executor budget—so the final gate is the actual harness, not a fixture approximation.
>
> The real parity gate is green: both one-worker and four-worker runs produced 11/11 successful jobs and identical JUnit totals—193 outcomes, zero failures/errors/skips—with only the 11 declared XML files retained in each run directory. The batch did not touch the repository scratch root or create new cache/bytecode files.
>
> <details><summary>Edited 2 files</summary>
>
> - Wrote `./tests/adapters/pester-batch.Tests.ps1` (+3 -1)
> - Wrote `./tests/adapters/pytest-batch.Tests.ps1` (+8 -4)
>
> </details>
>
> <details><summary>Edited 2 files</summary>
>
> - Wrote `./src/adapters/private/pytest-dependency.ps1` (+0 -5)
> - Wrote `./tests/adapters/pytest-batch.Tests.ps1` (+3 -0)
>
> </details>
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./tests/adapters/pytest-batch.Tests.ps1` (+1 -1)
> - Wrote `./tests/pytest.ps1` (+0 -1)
> - Wrote `./src/adapters/public/Get-PytestBatchJob.ps1` (+2 -0)
> - Wrote `./tests/adapters/pytest-batch.Tests.ps1` (+7 -0)
> - Wrote `./tests/pytest.ps1` (+4 -1)
> - Wrote `./tests/adapters/pytest-batch.Tests.ps1` (+6 -2)
> - Wrote `./tests/adapters/pytest-batch.Tests.ps1` (+3 -2)
> - Wrote `./tests/adapters/pytest-batch.Tests.ps1` (+1 -1)
>
> </details>
>
> One parity detail remained from the original design: the PowerShell integration container was still rediscovering `pwsh` from `PATH` even though the adapter already had an exact child executable. I’m closing that seam by transporting the resolved path into the Python job, so nested shell tests use the same pinned PowerShell rather than ambient discovery.
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./src/adapters/public/Get-PytestBatchJob.ps1` (+2 -0)
> - Wrote `./tests/adapters/pytest-batch.Tests.ps1` (+1 -0)
> - Wrote `./tests/shared/test_shell_surface.py` (+3 -0)
>
> </details>
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/pytest.ps1` (+1 -1)
>
> </details>
>
> The exact PowerShell seam is green as well: the batch injected `C:\Program Files\PowerShell\7\pwsh.exe`, and all eight PowerShell-surface tests ran—zero skips and zero failures. The complete adapter regression is in its final pass now.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/adapters/parallel.Tests.ps1` (+1 -1)
>
> </details>
>
> The suite now also clears ambient `PYTHONPATH`/`PYTHONHOME` and preflights the repository’s pytest/jsonschema/filelock dependencies inside the pinned interpreter. I’m repeating the one-worker/four-worker repository gate against that final runner state; after this, only documentation reconciliation and diff review remain.
>
> <details><summary>Edited 4 files</summary>
>
> - Wrote `./issues/batch-executor/planning/ledger.md` (+1 -1)
> - Wrote `./issues/batch-executor/planning/pytest-batchability-inventory.md` (+2 -2)
> - Wrote `./issues/batch-executor/planning/pytest-testing-workplan.md` (+1 -1)
> - Wrote `./tests/README.md` (+1 -1)
>
> </details>
>
> Context compaction
>
> Source: automatic
> Status: completed
>
> The implementation is in place. I’m finishing the exact-state verification now—one final mixed-shell regression and consistency checks against the recorded parity evidence.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./issues/batch-executor/planning/ledger.md` (+1 -1)
>
> </details>
>
> The final mixed-shell regression is green: 5/5, including default multilingual composition and cross-framework sibling-failure preservation. I’m checking the delivered diff and documentation for drift before handing it back.

</details>

Implemented pytest batch parity without changing the core batch executor.

- Added the authoritative [pytest runner](./tests/pytest.ps1) and [pytest adapter](./src/adapters/public/Get-PytestBatchJob.ps1), with one `test_*.py` file per isolated job.
- Extended [parallel.ps1](./tests/parallel.ps1) to support `All`, `Pester`, and `Pytest` in one plan.
- Added JUnit reporting, stable job addresses, environment isolation, job-local temp/JSON scratch, and failure observations.
- Refactored Python tests for batch safety: explicit golden regeneration, shared helpers, CLI/shell separation, bounded joins, and descendant cleanup.
- Updated the [testing guide](./tests/README.md), adapter/executor documentation, decisions, inventory, and [pytest workplan](./issues/batch-executor/planning/pytest-testing-workplan.md).

Verification:

- Direct suite: 157 tests plus 36 subtests — 193 passing outcomes.
- Batch parity: 11/11 jobs at one worker and four workers.
- Four workers: 20.163 s; one worker: 54.473 s.
- 11 JUnit reports per run; zero failures, skips, cache/bytecode residue, repository scratch, or surviving processes.
- Adapter suite: 30/30 green.
- Final multilingual-shell regression: 5/5 green, including sibling-failure preservation.

The full legacy topology test still reports five pre-existing stale references: four retired PowerShell JSONL containers and `src/logistics/run-paths.ps1`. The new batch-topology assertion itself passes, and that archaeology remains explicitly deferred. No commit was created.

> ok and last but not least. i earlier added the "thin" powershell front-end but was wondering if i would be worthwhile to build on that and make it into more of a centralized powershell interface for jsonl_engine to make the python interop easy and mostly contained by centralizing it in a powershell CLI adapter kind of thing. one stop shop for other callers who are also going to be powershell for the time being, which is the project glue

<details><summary>2 previous messages</summary>

> Yes—this is likely worthwhile if the PowerShell layer stays an adapter rather than becoming a second JSONL implementation. I’m going to inspect the existing thin front-end, the Python CLI contract, and current PowerShell call sites so I can recommend the exact boundary and whether it is ready to consolidate now.
>
> The inspection found a strong reason to consolidate: there are already two different PowerShell→Python launchers with conflicting runtime, stream, timeout, and error behavior. The existing thin façade is the right seed, but it should become a real module with one transport contract before more callers adopt it.

</details>

Yes—this is worth doing. The repository already has two divergent PowerShell→Python bridges: [jso-shell.ps1](./src/shared/jsonl_engine/jso-shell.ps1:77) and [engine-call.ps1](./src/logistics/engine-call.ps1:109). Centralizing them now prevents every PowerShell caller from inventing its own interpreter, encoding, timeout, and error behavior.

I’d make it a manifest-backed `JsonlEngine.Client` module under `src/shared`, not add it to `src/adapters`; that module specifically owns batch planning.

The target boundary should be:

- One private process launcher based on the stronger `engine-call.ps1` implementation: explicit/repository Python, separate stdout/stderr, UTF-8, argument-vector safety, timeout, descendant cleanup, deterministic working directory, and structured errors.
- Existing ergonomic cmdlets from `jso-shell.ps1` for reads, queries, verification, signatures, snapshots, schemas, and JSON documents.
- One advanced `Invoke-JsonlEngineCommand` escape hatch for domain verbs such as the planned `deposit`.
- One common view parameter: `-View Complete|Signed|Physical`, with the existing switches retained temporarily as compatibility aliases.
- Explicit raw, single-JSON, and JSONL output modes.

There are important bugs to resolve while promoting it:

- `jso-shell.ps1` currently merges stderr into stdout.
- It buffers all results and has no timeout or child cleanup.
- PowerShell pipeline conversion unrolls top-level JSON arrays and drops explicit JSON `null`, so record cardinality is not currently faithful.
- Bad CLI arguments bypass the advertised JSON error contract because `argparse` writes ordinary text.
- Its ambient `python` fallback can select an interpreter without the installed package.

The Python [CLI](./src/shared/jsonl_engine/cli.py:277) should therefore gain a protocol/capabilities version, machine-readable argument errors, and a framed output option that preserves scalar, array, and null values.

I would stage it this way:

1. Create the central client module and comprehensive Pester transport tests.
2. Turn `jso-shell.ps1` into a temporary compatibility importer.
3. Retire the process implementation in `logistics/engine-call.ps1` and migrate the deposit caller.
4. Add whole-artifact write/append/publish verbs to the Python CLI.
5. Migrate selected PowerShell producers.

The best later migration candidate is [inventory-catalog.ps1](./src/latex-ingest/inventory-catalog.ps1:1), but its current headerless/no-sidecar format differs from Python `InventoryRegistry`, so that needs an explicit compatibility decision.

I would not route everything through Python:

- The logger must remain PowerShell-native; spawning Python per log record would be disastrous.
- The reader MCP currently benefits from being self-contained and intentionally tolerant.
- Human-authored patch JSONL permits comments and blanks, so it is not strict engine JSONL.

So the useful rule is: one centralized interface for engine-owned operations, crossing once per artifact—not a mandatory Python tollbooth for every `.jsonl` line. No files were changed during this assessment.

> agreed on logger, though that probably needs some more work now that the engine is working, so maybe we can handle that later and incorporate logging after logger matures. agreed about reader mcp and the patch jsonl being admissible. so lets first fix the existing bugs to setup for the update and then execute

<details><summary>19 previous messages</summary>

> I’ll execute this as two coordinated layers: first harden/version the Python CLI protocol, then build the manifest-backed PowerShell client on that protocol and migrate the existing logistics caller. The logger, reader MCP, tolerant patch reader, and other specialized JSONL producers stay out of scope.
>
> The Python side is now hardened and green: protocol-v1 framing, capability discovery, lossless array/scalar/null frames, and JSON argument errors with the correct exit codes. The PowerShell module is being built against that exact wire contract; after it lands I’ll migrate the duplicate logistics launcher and run the cross-runtime gates.
>
> The client contract is now fixed around a manifest-backed shared module, with the old thin script retained only as a compatibility importer. I’m implementing the transport as a streaming framed client—so the promotion does not inherit the current buffering, mixed-stream, or null/cardinality defects.
>
> <details><summary>Created 9 files, edited 3 files</summary>
>
> - Wrote `./src/shared/jsonl-engine-client/jsonl-engine-client.psd1` (+31 -0)
> - Wrote `./src/shared/jsonl-engine-client/jsonl-engine-client.psm1` (+48 -0)
> - Wrote `./src/shared/jsonl-engine-client/private/protocol.ps1` (+115 -0)
> - Wrote `./src/shared/jsonl-engine-client/private/runtime.ps1` (+56 -0)
> - Wrote `./src/shared/jsonl-engine-client/private/process.ps1` (+130 -0)
> - Wrote `./src/shared/jsonl-engine-client/public/Invoke-JsonlEngineCommand.ps1` (+21 -0)
> - Wrote `./src/shared/jsonl-engine-client/public/New-JsonlEngineInputFile.ps1` (+67 -0)
> - Wrote `./src/shared/jsonl-engine-client/public/store-commands.ps1` (+336 -0)
> - Wrote `./src/shared/jsonl-engine-client/private/process.ps1` (+1 -1)
> - Wrote `./src/shared/jsonl-engine-client/private/protocol.ps1` (+6 -3)
> - Wrote `./src/shared/jsonl-engine-client/private/protocol.ps1` (+5 -3)
> - Wrote `./src/shared/jsonl_engine/jso-shell.ps1` (+15 -0)
> - Wrote `./tests/shared/test_shell_surface.py` (+8 -3)
>
> </details>
>
> <details><summary>Created a file, edited 7 files, deleted a file</summary>
>
> - Deleted `./src/logistics/engine-call.ps1` (+0 -171)
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+22 -7)
> - Wrote `./src/shared/jsonl_engine/__init__.py` (+1 -1)
> - Wrote `./src/shared/jsonl_engine/__main__.py` (+1 -1)
> - Wrote `./src/shared/jsonl_engine/cli.py` (+4 -3)
> - Wrote `./src/shared/logger/logger.ps1` (+1 -1)
> - Wrote `./src/shared/jsonl-engine-client/README.md` (+72 -0)
> - Wrote `./issues/jsonl-engine/TODO.md` (+9 -2)
> - Wrote `./tests/infrastructure/path-topology.Tests.ps1` (+57 -0)
> - Wrote `./tests/infrastructure/path-topology.Tests.ps1` (+1 -1)
> - Wrote `./tests/infrastructure/path-topology.Tests.ps1` (+2 -1)
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+4 -1)
>
> </details>
>
> <details><summary>Created a file, edited 4 files</summary>
>
> - Wrote `./src/shared/jsonl-engine-client/private/protocol.ps1` (+37 -21)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+181 -0)
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+4 -3)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+1 -0)
> - Wrote `./src/shared/jsonl-engine-client/public/New-JsonlEngineInputFile.ps1` (+10 -4)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+1 -0)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+3 -0)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+15 -0)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+21 -0)
>
> </details>
>
> The central client is now operational: exact module surface, deterministic interpreter selection, framed streaming, UTF-8 request staging, typed/raw predicates, view validation, timeout/tree termination, and the logistics caller migrated off its duplicate launcher. Its focused Pester suite is 10/10 green; I’m now running the full Python and integration gates and doing an adversarial review.
>
> <details><summary>Edited 12 files</summary>
>
> - Wrote `./issues/batch-executor/planning/ledger.md` (+1 -0)
> - Wrote `./issues/batch-executor/planning/pytest-batchability-inventory.md` (+6 -6)
> - Wrote `./issues/batch-executor/planning/pytest-testing-workplan.md` (+8 -0)
> - Wrote `./tests/README.md` (+5 -5)
> - Wrote `./issues/batch-executor/planning/ledger.md` (+1 -0)
> - Wrote `./issues/batch-executor/planning/testing-batchability-inventory.md` (+25 -0)
> - Wrote `./src/shared/jsonl-engine-client/private/runtime.ps1` (+3 -7)
> - Wrote `./src/shared/jsonl-engine-client/private/protocol.ps1` (+55 -0)
> - Wrote `./src/shared/jsonl-engine-client/public/New-JsonlEngineInputFile.ps1` (+1 -0)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+3 -0)
> - Wrote `./src/shared/jsonl-engine-client/public/store-commands.ps1` (+1 -0)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+2 -0)
> - Wrote `./src/shared/jsonl-engine-client/private/process.ps1` (+7 -1)
> - Wrote `./src/shared/jsonl-engine-client/README.md` (+2 -0)
> - Wrote `./issues/batch-executor/planning/testing-batchability-inventory.md` (+6 -4)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+25 -8)
>
> </details>
>
> Context compaction
>
> Source: automatic
> Status: completed
>
> The centralized client is now implemented and the duplicate logistics boundary has been removed. I’m at the last verification pass: rerunning the capability-gated PowerShell suite, checking the module’s process/cardinality edge cases, and reconciling the final inventory wording.
>
> The adversarial pass found several real boundary defects, especially caller-relative paths, permissive UTF-8 decoding, and values escaping before a late CLI failure. I’m tightening those contracts now and adding regressions before treating the adapter as ready.
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./src/shared/jsonl-engine-client/private/process.ps1` (+7 -3)
> - Wrote `./src/shared/jsonl-engine-client/private/protocol.ps1` (+37 -31)
> - Wrote `./src/shared/jsonl-engine-client/private/runtime.ps1` (+15 -0)
>
> </details>
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./src/shared/jsonl-engine-client/public/store-commands.ps1` (+37 -21)
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+3 -6)
> - Wrote `./src/shared/jsonl-engine-client/public/New-JsonlEngineInputFile.ps1` (+20 -10)
>
> </details>
>
> The core fixes are in place: wrapper paths now resolve from the caller’s location, protocol decoding is strict UTF-8, all frames are withheld until a clean exit, and the legacy `Find-JsonlRecord -Value` meaning is restored with `-InputObject` for typed values. I’m validating the live Python/PowerShell seam while the new adversarial cases are being added.
>
> <details><summary>Edited 2 files</summary>
>
> - Wrote `./src/shared/jsonl-engine-client/private/process.ps1` (+36 -1)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+26 -13)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+3 -1)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+13 -28)
>
> </details>
>
> The strengthened PowerShell suite is now 17/17 green, including a real grandchild-process cleanup witness. I’m running that same container through the batch adapter/executor—not just directly—then I’ll lock the final inventory counts and perform repository hygiene checks.
>
> <details><summary>Edited 4 files</summary>
>
> - Wrote `./issues/batch-executor/planning/testing-batchability-inventory.md` (+7 -8)
> - Wrote `./tests/README.md` (+5 -0)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+19 -2)
> - Wrote `./src/shared/jsonl-engine-client/private/process.ps1` (+4 -1)
> - Wrote `./issues/batch-executor/planning/testing-batchability-inventory.md` (+2 -2)
>
> </details>
>
> Both final execution lanes are green: the client’s batch container passed 17/17 with one declared XML output, and the complete shared Python suite passed 163 tests plus 38 subtests. I’m doing the last static/hygiene audit now, including stale boundary references and undeclared cache/scratch writes.
>
> <details><summary>Edited 2 files</summary>
>
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+1 -1)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+2 -0)
> - Wrote `./issues/batch-executor/planning/testing-batchability-inventory.md` (+1 -1)
>
> </details>

</details>

Implemented the centralized PowerShell interface and hardened the interop boundary.

- Canonical module: [jsonl-engine-client.psd1](./src/shared/jsonl-engine-client/jsonl-engine-client.psd1)
- Runtime/process ownership: [process.ps1](./src/shared/jsonl-engine-client/private/process.ps1)
- Public commands and compatibility behavior: [store-commands.ps1](./src/shared/jsonl-engine-client/public/store-commands.ps1)
- Protocol-v1 framing and capabilities: [cli.py](./src/shared/jsonl_engine/cli.py)
- Usage and contracts: [README.md](./src/shared/jsonl-engine-client/README.md)

The client now provides deterministic interpreter resolution, caller-relative paths, strict UTF-8, separate streams, typed error frames, all-or-nothing buffered results, timeout/process-tree cleanup, scalar/array/null cardinality preservation, and strict JSON input staging. Legacy `Find-JsonlRecord -Value` remains raw JSON; typed values use `-InputObject`.

The old `jso-shell.ps1` is now only a compatibility importer. The duplicate `src/logistics/engine-call.ps1` was removed, and [latex-source-deposit.ps1](./src/logistics/latex-source-deposit.ps1) uses the shared client with exact single-frame enforcement.

Validation:

- Python shared suite: 163 passed + 38 subtests.
- PowerShell client: 17/17 passed.
- Batch adapter/executor: 1/1 job, 17/17 XML outcomes, one declared output.
- Central-ownership topology assertion: passed.
- PowerShell and Python AST checks: passed.
- Diff/whitespace checks: passed.
- Repository JSON scratch: empty.

The logger, reader MCP, and tolerant patch-JSONL path remain intentionally independent. `deposit` is still the only missing domain verb, so the logistics caller now reaches the correct centralized boundary but cannot publish until that Python CLI operation exists. No commit was created.

> lets deposit the `deposit` verb

<details><summary>45 previous messages</summary>

> I’ll add `deposit` as a real engine-owned transaction, not merely expose a CLI spelling. First I’m tracing the current manifest schema, logistics payload, and archived implementation so the verb preserves the established deposit bytes and refusal semantics; then I’ll implement it with focused Python and PowerShell end-to-end coverage.
>
> Context compaction
>
> Source: automatic
> Status: completed
>
> I’m treating `deposit` as the missing article transaction—not reviving the retired `metadata.json` model. I’m freezing the exact Python/PowerShell contract now, then I’ll add the API, CLI verb, idempotence/conflict handling, and run it through the real logistics caller.
>
> The contract is now pinned: PowerShell keeps extraction and witnessed LaTeX facts; Python owns path confinement, file fingerprints, provider projection, schema validation, and immutable publication. I also confirmed two activation bugs that must be fixed with the verb: the source lock currently ends too early, and the generic JSON writer can replace an existing article sentinel.
>
> <details><summary>Created a file, edited 6 files</summary>
>
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+495 -0)
> - Wrote `./src/shared/jsonl_engine/kinds/article.py` (+11 -2)
> - Wrote `./src/shared/jsonl_engine/schemas/article.schema.json` (+26 -7)
> - Wrote `./src/shared/jsonl_engine/writer.py` (+24 -4)
> - Wrote `./src/shared/jsonl_engine/__init__.py` (+8 -2)
> - Wrote `./src/shared/jsonl_engine/cli.py` (+47 -1)
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+8 -0)
> - Wrote `./src/shared/jsonl_engine/writer.py` (+8 -2)
>
> </details>
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+85 -110)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+2 -2)
> - Wrote `./tests/shared/test_cli_surface.py` (+1 -1)
>
> </details>
>
> <details><summary>Edited 4 files</summary>
>
> - Wrote `./src/adapters/private/latex-inventory-row.ps1` (+10 -3)
> - Wrote `./src/latex-ingest/latex-ingest.ps1` (+11 -8)
> - Wrote `./src/latex-ingest/source-deposit.ps1` (+5 -2)
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+6 -1)
>
> </details>
>
> The Python regression slice is green. The first Pester invocation picked the system shell and hit an inaccessible Pester installation, so I’m switching to the repository’s portable PowerShell lane before judging any PowerShell result; that was an environment-selection failure, not a product failure.
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./src/shared/jsonl_engine/__init__.py` (+2 -1)
> - Wrote `./src/shared/jsonl_engine/writer.py` (+2 -2)
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+6 -2)
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+1 -1)
>
> </details>
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/adapters/latex-batch.Tests.ps1` (+13 -5)
>
> </details>
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./src/shared/jsonl_engine/writer.py` (+4 -0)
> - Wrote `./src/shared/jsonl_engine/writer.py` (+3 -3)
>
> </details>
>
> The real PowerShell deposit path is now green in its new focused container: it creates the flat article, preserves it on idempotent retry, records both conditional probe outcomes honestly, and rejects provider drift without replacement. I’m widening verification now to the updated batch consumer and the Python service/CLI race cases.
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./tests/adapters/latex-batch.Tests.ps1` (+22 -4)
> - Wrote `./tests/shared/test_deposit.py` (+32 -0)
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+35 -21)
>
> </details>
>
> Direct gates now stand at 179 passed / 1 environment skip for all shared Python tests, plus green PowerShell client, deposit, and live LaTeX batch containers. I’m running the new Python and Pester deposit containers together through the multilingual batch shell now—the parity gate that matters for this repo.
>
> Context compaction
>
> Source: automatic
> Status: completed
>
> The `deposit` path is now implemented end to end around the canonical `article.json` contract. I’m in the closure pass now: reconciling test-inventory counts, rerunning the Python suite after the last strictness tweak, and checking the live PowerShell caller plus mixed batch execution.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./src/shared/jsonl_engine/writer.py` (+3 -2)
>
> </details>
>
> The transaction boundary is behaving as intended: `article.json` is immutable, concurrent creators cannot clobber one another, and retries validate then return the existing bytes. I also tightened the low-level writer so an invalid non-atomic/no-overwrite request fails before serialization or directory creation.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/adapters/pytest-batch.Tests.ps1` (+20 -5)
>
> </details>
>
> One harness issue surfaced in the count audit: the pytest-adapter Pester container claimed to be capability-gated but failed during setup when `.venv` was absent. I’ve corrected that seam—planning remains runnable with a fake interpreter, while only the two live execution cases skip explicitly when repository Python is unavailable.
>
> The PowerShell audit caught a real refusal bug: a caller-supplied findings path could overwrite—or preempt—the immutable article and other deposit inputs. I’m closing that by requiring caller-owned findings to live outside the document deposit and by using create-only staging.
>
> <details><summary>Edited 5 files</summary>
>
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+24 -1)
> - Wrote `./tests/latex-ingest/latex-source-deposit.Tests.ps1` (+6 -0)
> - Wrote `./issues/infrastructure/planning/decisions.md` (+3 -1)
> - Wrote `./issues/jsonl-engine/TODO.md` (+5 -5)
> - Wrote `./src/shared/jsonl-engine-client/README.md` (+3 -1)
> - Wrote `./issues/infrastructure/planning/decisions.md` (+3 -1)
> - Wrote `./issues/jsonl-engine/TODO.md` (+5 -5)
>
> </details>
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+7 -3)
>
> </details>
>
> The final adversarial pass exposed three integrity gaps in the new Python transaction—source replacement between measurement and publish, unenforced JSON Schema date-time formats, and acceptance of noncanonical incumbent bytes. I’ve added failing witnesses for all three and am repairing the transaction before calling the verb complete.
>
> <details><summary>Edited 11 files</summary>
>
> - Wrote `./src/shared/jsonl_engine/schemas/catalog.py` (+8 -2)
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+80 -13)
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+62 -24)
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+24 -3)
> - Wrote `./src/shared/jsonl_engine/schemas/catalog.py` (+22 -5)
> - Wrote `./src/shared/jsonl_engine/cli.py` (+15 -0)
> - Wrote `./tests/shared/jsonl-engine-client-module.Tests.ps1` (+2 -1)
> - Wrote `./tests/shared/test_cli_surface.py` (+27 -1)
> - Wrote `./src/latex-ingest/latex-source.ps1` (+19 -0)
> - Wrote `./src/latex-ingest/source-deposit.ps1` (+45 -23)
> - Wrote `./src/latex-ingest/source-deposit.ps1` (+25 -0)
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+29 -9)
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+2 -1)
> - Wrote `./src/logistics/latex-source-deposit.ps1` (+3 -1)
> - Wrote `./src/adapters/private/latex-inventory-row.ps1` (+56 -2)
> - Wrote `./tests/adapters/latex-batch.Tests.ps1` (+44 -7)
> - Wrote `./src/latex-ingest/latex-ingest.ps1` (+35 -0)
> - Wrote `./tests/adapters/latex-batch.Tests.ps1` (+43 -0)
> - Wrote `./tests/adapters/latex-batch.Tests.ps1` (+5 -3)
>
> </details>
>
> The PowerShell side is now being hardened at the same boundary: findings staging is physically isolated from the deposit, document/source paths reject junction and symlink aliases, canonical `article.json` wins over legacy fallback even when its address is obstructed, and the source lock no longer relies on unlinking a lockfile. I’m running the three affected Pester containers together now.
>
> <details><summary>Edited 6 files</summary>
>
> - Wrote `./tests/latex-ingest/latex-source-deposit.Tests.ps1` (+32 -0)
> - Wrote `./tests/latex-ingest/latex-source-deposit.Tests.ps1` (+3 -0)
> - Wrote `./tests/adapters/latex-batch.Tests.ps1` (+22 -0)
> - Wrote `./tests/shared/test_cli_surface.py` (+2 -2)
> - Wrote `./tests/latex-ingest/source-deposit.Tests.ps1` (+2 -0)
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+12 -9)
> - Wrote `./src/latex-ingest/source-deposit.ps1` (+3 -2)
>
> </details>
>
> Context compaction
>
> Source: automatic
> Status: completed
>
> The `deposit` path is implemented end to end. I’m at the closure pass now: rerunning the full shared Python suite, the mixed Pester/pytest batch, and reconciling the final test inventory and one stale legacy test reference.
>
> The full shared Python suite is green: 184 passed, 2 capability skips, plus 47 subtests. One remaining red is purely archaeological—a legacy `metadata.json` test still points at a schema file removed during the `article.json` cutover—so I’m replacing that dead-file assertion with the legacy reader’s live validation boundary.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/latex-ingest/source-deposit.Tests.ps1` (+2 -2)
>
> </details>
>
> The canonical deposit, adapter, and client gates are all green. The legacy compatibility suite still has one failure after removing its dead schema lookup, so I’m pulling the exact assertion now rather than treating it as unrelated.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/latex-ingest/source-deposit.Tests.ps1` (+3 -1)
>
> </details>
>
> All four focused Pester containers are now green, including the legacy compatibility suite at 12/12. I’m running the actual multilingual batch contract next—one Pester deposit job and one pytest deposit job under the same scheduler—to verify report separation, isolation, and parity rather than only direct invocation.
>
> The implementation tests remain green, but the topology guard exposed two repository-structure mismatches, and my AST-check command itself had a PowerShell interpolation typo. I’m resolving the topology failures and rerunning the corrected parser check before calling this closed.
>
> <details><summary>Edited 2 files</summary>
>
> - Wrote `./src/logistics/run-paths.ps1` (+1 -1)
> - Wrote `./tests/README.md` (+1 -1)
>
> </details>
>
> The multilingual batch is green: both jobs succeeded under two workers in 9.589 seconds, with separate reports—5 Pester outcomes and 31 pytest outcomes—and an empty job-local JSON scratch directory. Documentation is now aligned to 16 CLI verbs and 233 shared-suite outcomes.
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./issues/batch-executor/planning/pytest-batchability-inventory.md` (+2 -2)
> - Wrote `./issues/batch-executor/planning/testing-batchability-inventory.md` (+2 -2)
> - Wrote `./tests/README.md` (+3 -3)
> - Wrote `./issues/batch-executor/planning/testing-batchability-inventory.md` (+2 -2)
>
> </details>
>
> The final adversarial pass found four real gaps: one unavoidable multi-file race still needed a post-publication rollback guard, fixed-name manifests could escape their directory, the schema could certify states the deposit service would never mint, and portable paths still admitted NTFS alternate streams. I’m closing those now, along with a PowerShell source-tree reparse asymmetry.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+58 -8)
>
> </details>
>
> <details><summary>Edited 3 files</summary>
>
> - Wrote `./src/shared/jsonl_engine/deposit.py` (+5 -2)
> - Wrote `./src/shared/jsonl-engine-client/README.md` (+3 -1)
> - Wrote `./issues/infrastructure/planning/decisions.md` (+4 -2)
>
> </details>
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/shared/test_deposit.py` (+31 -0)
>
> </details>
>
> The hardening patches are in. The schema and semantic validator now reject nonportable paths and impossible article relationships; the service has a closing witness check that removes its just-created sentinel if inputs drift during publication; and both PowerShell deposit paths reject reparse roots, descendants, and implicit file aliases before mutation. I’m rerunning the focused and full suites with those final changes.
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./tests/shared/test_deposit.py` (+4 -1)
>
> </details>
>
> <details><summary>Edited a file</summary>
>
> - Wrote `./src/shared/jsonl_engine/cli.py` (+8 -1)
>
> </details>

</details>

The `deposit` verb is landed end to end.

- Python now transactionally creates or idempotently validates canonical `{slug}/article.json`: [deposit.py](./src/shared/jsonl_engine/deposit.py:568).
- The framed CLI exposes both `deposit` and authoritative `validate-json`: [cli.py](./src/shared/jsonl_engine/cli.py:325).
- `ArticleManifest` enforces fixed naming, portable paths, canonical archive/tree relationships, counts, and evidence linkage: [article.py](./src/shared/jsonl_engine/kinds/article.py:22).
- PowerShell retains the source lock through Python publication and uses the centralized client: [latex-source-deposit.ps1](./src/logistics/latex-source-deposit.ps1:239).
- Converter consumption revalidates canonical articles through Python before use: [latex-ingest.ps1](./src/latex-ingest/latex-ingest.ps1:2211).
- No-clobber publication, reparse confinement, file-generation checks, post-publication rollback, and strict source-stability requirements are covered.

Validation:

- Python shared suite: 190 passed, 2 capability skips, 72 subtests passed—264 outcomes.
- Pester: deposit 5/5, legacy deposit 12/12, adapter 8/8, client 17/17.
- Mixed two-worker batch: 2/2 jobs succeeded in 9.641s; 5 Pester + 53 pytest outcomes; empty job-local scratch.
- `git diff --check` clean aside from existing line-ending notices.

The only observed unrelated red remains the documented topology archaeology: four historical Pester JSONL containers still reference retired PowerShell implementations. Changes are uncommitted.

> ok, tolerant patch-JSONL path. lets make a plan, and deploy sub-agents

<details><summary>6 previous messages</summary>

> Yes—plan first. I’ve split the work into three bounded reviews: tolerant parser/application semantics, batch-adapter identity and drift handling, and artifact-address/documentation ownership. I’ll reconcile those into one implementation sequence before touching code.
>
> <details><summary>Ran 6 commands</summary>
>
> - Ran `rg -n "function Get-LatexBatchJob|function ConvertTo-Latex|Metadata =|Identity|Parameters|Writes|lane-output|Invoke-ArxivLatexToMarkdown" src/adapters src/latex-ingest tests/adapters/latex-batch.Tests.ps1 -g '*.ps1' | Select-Object -First 260
$files=@('src/adapters/public/Get-LatexBatchJob.ps1','src/adapters/private/latex-address.ps1','src/adapters/private/latex-worker.ps1')
foreach($f in $files){ if(Test-Path $f){ Write-Output "FILE $f"; $n=0; Get-Content $f | ForEach-Object { $n++; '{0,4}: {1}' -f $n,$_ } }}`
> - Ran `$n=0; Get-Content src/adapters/workers/invoke-latex-ingest.ps1 | ForEach-Object { $n++; '{0,4}: {1}' -f $n,$_ }
rg -n "class BatchJob|New-BatchJob|Writes|Reads" src/shared/batch-executor src/adapters -g '*.ps1' | Select-Object -First 200`
> - Ran `rg -n "^## D|D19|latex.*decision|Patch" issues/latex-ingest ingestion/README.md src/adapters/README.md tests/README.md -g '*.md' | Select-Object -First 240
rg --files issues/latex-ingest | Sort-Object`
> - Ran `$lines=Get-Content src/latex-ingest/latex-ingest.ps1
for($i=2266;$i -le 2305;$i++){'{0,5}: {1}' -f $i,$lines[$i-1]}
rg -n "Read-LatexBatchManifestRecord|ManifestPath|DocumentDir" src/adapters/private/latex-inventory-row.ps1`
> - Ran `$lines=Get-Content src/adapters/private/latex-inventory-row.ps1
for($i=90;$i -le 255;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}
rg -n "Sha256|FileHash|ComputeHash|ReadAllBytes" src/adapters/private -g '*.ps1'`
> - Ran `$n=0; Get-Content src/latex-ingest/source-deposit.ps1 | Select-Object -First 25 | ForEach-Object { $n++; '{0,4}: {1}' -f $n,$_ }
$n=0; Get-Content src/latex-ingest/latex-source.ps1 | Select-Object -First 20 | ForEach-Object { $n++; '{0,4}: {1}' -f $n,$_ }`
>
> </details>
>
> <details><summary>Ran 4 commands</summary>
>
> - Ran `$n=0; Get-Content src/adapters/adapters.psm1 | ForEach-Object {$n++;'{0,4}: {1}' -f $n,$_}
$n=0; Get-Content src/adapters/adapters.psd1 | ForEach-Object {$n++;'{0,4}: {1}' -f $n,$_}
rg -n "latex-.*\.ps1" tests/infrastructure/path-topology.Tests.ps1 src/adapters -g '*.ps1' -g '*.psm1'`
> - Ran `$lines=Get-Content src/adapters/private/latex-inventory-row.ps1
for($i=1;$i -le 95;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}`
> - Ran `$lines=Get-Content issues/latex-ingest/planning/decisions.md
for($i=105;$i -le $lines.Count;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}
Write-Output 'LEDGER TAIL'
$lines=Get-Content issues/latex-ingest/planning/ledger.md
$start=[Math]::Max(1,$lines.Count-60)
for($i=$start;$i -le $lines.Count;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}
Write-Output 'ROADMAP'
Get-Content issues/latex-ingest/planning/roadmap.md`
> - Ran `rg -n "49|510|521|Pester|CapabilityGated|Batchable|latex-patch|latex-batch.Tests" tests/README.md issues/batch-executor/planning/testing-batchability-inventory.md | Select-Object -First 220`
>
> </details>
>
> The central bug is now clear: production currently looks in generated `OutDir`; batch jobs assign that to an empty job-local lane, so a durable patch is never seen. The plan will move authority to `{documentDir}/{slug}-latex.patch.jsonl` and make its exact presence/digest part of batch identity, while retaining only the intended tolerance—blank and full-line comments.
>
> <details><summary>Ran 2 commands</summary>
>
> - Ran `rg -n "function Remove-TexComments|function Protect-LatexVerbatim|Verbatim|verb" src/latex-ingest/latex-ingest.ps1 | Select-Object -First 100`
> - Ran `$lines=Get-Content src/latex-ingest/latex-ingest.ps1
for($i=1640;$i -le 1668;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}`
>
> </details>
>
> <details><summary>Plan</summary>
>
> Read-only investigation is complete. The parser, batch, test, and documentation lanes agree on a domain-owned tolerant reader at the canonical document address, with raw-byte identity pinned through batch execution.
>
> - [x] Freeze the tolerant patch artifact contract: canonical address, lifecycle owner, accepted line grammar, operation schemas, and audit semantics
> - [x] Design the domain-local PowerShell reader and patch applier hardening, including strict bytes, exact field types, bounded regexes, and fail-loud errors
> - [x] Design batch-executor integration so patch presence/digest participates in job identity, declared inputs, transport, and runtime drift refusal
> - [x] Map focused Pester regressions for parser, canonical discovery, phase behavior, confinement, timeout, batch identity, and drift
> - [x] Identify live documentation and decision updates while leaving strict jsonl_engine, logger, Reader MCP, and historical records untouched
> - [x] Present the reconciled implementation plan and tranche boundaries for approval
>
> </details>

</details>

Plan is ready. No files were changed during this planning pass.

The central contract will be:

`{documentDir}/{slug}-latex.patch.jsonl`

It is a mutable, human-authored latex-ingest input beside `article.json`—not generated output, not part of `{slug}-tex`, and not a managed `jsonl_engine` store. No file means a faithful no-op.

### Implementation sequence

1. Extract the cohesive patch logic from [latex-ingest.ps1](./src/latex-ingest/latex-ingest.ps1) into `src/latex-ingest/latex-patch.ps1`.

2. Fix addressing.
   - Derive the path from the validated manifest’s parent.
   - Remove the current `$OutDir` lookup; batch `OutDir` is an empty job-local output directory.
   - Give the legacy compatibility entrypoint the same document-root behavior.
   - Reject directories, reparse traversal, and unsafe slug/path composition.
   - Never fall back to `OutDir`.

3. Freeze the tolerant grammar.
   - Accept blank lines and full-line `#` or `//` comments.
   - Accept LF or CRLF and an optional final newline.
   - Require strict UTF-8 without BOM.
   - Every remaining line must be exactly one strict JSON object.
   - Reject trailing/inline comments, trailing commas, non-finite numbers, scalars, arrays, duplicate keys, case-colliding keys, and unknown fields.

4. Validate exact operation shapes.
   - `define_macro`: `name`, `body`, `reason`; optional positive integer `expect_uses`.
   - `source_replace` / `output_replace`: `find`, `replace`, `reason`; optional positive integer `expect`.
   - Optional common provenance: `class`, `source_ref`, `authored_by`, `authored_utc`.
   - Missing `replace` must fail rather than silently becoming deletion; an explicitly empty replacement remains valid.
   - Reject duplicate `define_macro` declarations.

5. Bound application behavior.
   - Compile regexes when reading the patch file.
   - Apply an explicit timeout to matching and replacement.
   - Preserve normal .NET replacement-template semantics such as `$1` and `${name}`.
   - Keep file order authoritative and stale/zero/count mismatches fatal.
   - Include source line and all authored provenance in `patched[]`.
   - Return and persist the raw-file SHA-256 with `patches_applied`.

6. Make batching reproducible.
   - During `Get-LatexBatchJob`, record either `absent` or the raw patch SHA-256.
   - Include that identity in the job ID, address, parameters, and metadata.
   - At execution, refuse if a planned-absent patch appears or a planned-present patch changes/disappears.
   - Keep it out of `Writes`; no generic `Reads` expansion to batch-executor in this tranche.
   - Keep adapter planning shallow and process-free—the domain reader remains the validation authority.

7. Add focused regressions.
   - Expand [latex-patch.Tests.ps1](./tests/latex-ingest/latex-patch.Tests.ps1) for framing, strict JSON, operation schemas, duplicate macros, regex timeout, confinement, ordering, and audit preservation.
   - Add one capability-gated end-to-end case proving a document-root patch is applied when `OutDir` is elsewhere—and an `OutDir` patch is ignored.
   - Extend [latex-batch.Tests.ps1](./tests/adapters/latex-batch.Tests.ps1) for present/absent identity, transport, drift refusal, and write declarations.
   - Pester file counts and classifications should remain unchanged; only observed test totals grow. Python tests are unaffected.

8. Record the contract.
   - Add latex-ingest D20: “Patch JSONL is a document-local authored-rule input, not a managed store.”
   - Update current ingestion, adapter, testing, and ledger documentation.
   - Leave archived/reboot discussions unchanged.

No real `*-latex.patch.jsonl` artifacts currently exist in the repository, so this has no data-migration burden. Logger, Reader MCP, strict `jsonl_engine`, and the centralized PowerShell engine client remain untouched.

> ok, lets execute with scoped sub-agents

<details><summary>45 previous messages</summary>

> I’m executing this in three non-overlapping slices: the domain reader/applier and unit contract, batch identity/drift transport, and the end-to-end/doc decision surface. I’ll keep the strict engine and PowerShell client untouched, then reconcile and run the focused and mixed gates centrally.
>
> <details><summary>Ran a command</summary>
>
> - Ran `git status --short
rg -n "latex-patch|patch.jsonl|ExpectedPatch" src tests ingestion issues/latex-ingest/planning -g '*.ps1' -g '*.md' | Select-Object -First 200`
>
> </details>
>
> <details><summary>Ran a command</summary>
>
> - Ran `git status --short
git diff --stat
git diff -- src/latex-ingest/latex-patch.ps1 src/latex-ingest/latex-ingest.ps1 src/adapters/private/latex-inventory-row.ps1 | Select-Object -First 400`
>
> </details>
>
> The cross-slice wire contract is now frozen: `ExpectedPatchIdentity` carries either `absent` or `sha256:<64 lowercase hex>` over the exact authored bytes. Conversion evidence will expose the same `patch_identity`, and each applied record will retain its source line and authorship fields.
>
> <details><summary>Ran 3 commands</summary>
>
> - Ran `git status --short
git diff --stat`
> - Ran `git diff -- src/adapters/private/latex-inventory-row.ps1 src/adapters/public/Get-LatexBatchJob.ps1 src/adapters/workers/invoke-latex-ingest.ps1 tests/adapters/latex-batch.Tests.ps1`
> - Ran `git status --short
git diff --stat`
>
> </details>
>
> The batch slice is now wiring the raw-byte identity into job addressing and worker parameters without declaring the patch as a write. The remaining core work is deliberately taking longer because the parser is being made strict at the JSON-record layer while preserving only the authored comment/blank-line tolerance.
>
> <details><summary>Ran a command</summary>
>
> - Ran `git status --short
git diff --stat`
>
> </details>
>
> <details><summary>Ran a command</summary>
>
> - Ran `git status --short
git diff --stat`
>
> </details>
>
> <details><summary>Ran a command</summary>
>
> - Ran `Get-Date -Format o
git status --short`
>
> </details>
>
> The standalone domain reader has now landed. I’m letting that slice finish the monolith extraction and canonical wiring before running anything, so the first test pass exercises the real document-root path rather than a half-integrated parser.
>
> <details><summary>Ran 4 commands</summary>
>
> - Ran `git status --short
git diff --stat`
> - Ran `$n=0; Get-Content src/latex-ingest/latex-patch.ps1 | ForEach-Object { $n++; '{0,4}: {1}' -f $n,$_ }`
> - Ran `git status --short
git diff --stat
rg -n "latex-patch|ExpectedPatchIdentity|patch_identity|Read-LatexPatch" src/latex-ingest/latex-ingest.ps1 src/latex-ingest/latex-ingest-compat.ps1 | Select-Object -First 160`
> - Ran `$lines=Get-Content src/latex-ingest/latex-ingest.ps1
for($i=2370;$i -le 2450;$i++){'{0,5}: {1}' -f $i,$lines[$i-1]}
for($i=2615;$i -le 2692;$i++){'{0,5}: {1}' -f $i,$lines[$i-1]}
$lines=Get-Content src/latex-ingest/latex-ingest-compat.ps1
for($i=78;$i -le 195;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}`
>
> </details>
>
> <details><summary>Ran a command</summary>
>
> - Ran `git status --short
git diff --stat`
>
> </details>
>
> <details><summary>Ran 2 commands</summary>
>
> - Ran `git diff -- tests/latex-ingest/latex-ingest-integration.Tests.ps1 ingestion/README.md ingestion/inventory/CONVENTION.md issues/latex-ingest/planning/decisions.md`
> - Ran `git status --short
git diff --stat | Select-Object -Last 25`
>
> </details>
>
> <details><summary>Ran 6 commands</summary>
>
> - Ran `git diff -- issues/latex-ingest/planning/roadmap.md`
> - Ran `git status --short | Select-String 'latex-patch|latex-ingest.ps1|latex-ingest-integration'`
> - Ran `git diff --stat -- tests/latex-ingest/latex-patch.Tests.ps1 src/latex-ingest/latex-ingest.ps1
git diff -- tests/latex-ingest/latex-patch.Tests.ps1 | Select-Object -First 500`
> - Ran `git diff -- tests/latex-ingest/latex-patch.Tests.ps1 | Select-Object -Skip 100 -First 500`
> - Ran `rg -n -C 3 "patchesApplied" src/latex-ingest/latex-ingest.ps1
rg -n "source_replace|output_replace" tests/latex-ingest/latex-ingest-integration.Tests.ps1 | Select-Object -Last 15
git status --short`
> - Ran `rg -n -C 8 "pathological|RegexTimeout" tests/latex-ingest/latex-patch.Tests.ps1`
>
> </details>
>
> <details><summary>Ran 2 commands</summary>
>
> - Ran `rg -n "reparse|symbolic|junction|PathHasReparse" src/latex-ingest/latex-patch.ps1 tests/latex-ingest/latex-patch.Tests.ps1 | Select-Object -First 100`
> - Ran `$lines=Get-Content src/latex-ingest/latex-patch.ps1
for($i=10;$i -le 60;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}
for($i=185;$i -le 225;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}`
>
> </details>
>
> <details><summary>Ran 3 commands</summary>
>
> - Ran `rg -n "reparse|Junction|SymbolicLink|link" tests/latex-ingest/latex-patch.Tests.ps1 | Select-Object -First 100
rg -n "It '" tests/latex-ingest/latex-patch.Tests.ps1 | Measure-Object | ForEach-Object Count`
> - Ran `$lines=Get-Content tests/latex-ingest/latex-patch.Tests.ps1
for($i=105;$i -le 145;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}`
> - Ran `rg -n -C 8 "Get-LatexPatchRegexMatchCount|NextMatch|Matches\(" src/latex-ingest/latex-patch.ps1`
>
> </details>
>
> All three implementation slices are green independently: 22 patch-contract tests, 10 adapter tests, 7 real conversion tests, plus 4 legacy-compat tests. I’m in the final integration review now—checking cross-file contracts, documentation counts, path topology, and any edge case the focused suites may have missed.
>
> <details><summary>Ran 11 commands</summary>
>
> - Ran `git status --short
git diff --stat
git diff --check`
> - Ran `git diff -- src/latex-ingest/latex-ingest.ps1 src/latex-ingest/latex-ingest-compat.ps1 src/adapters/private/latex-inventory-row.ps1 src/adapters/public/Get-LatexBatchJob.ps1 src/adapters/workers/invoke-latex-ingest.ps1`
> - Ran `$n=0; Get-Content src/latex-ingest/latex-patch.ps1 | ForEach-Object { $n++; '{0,4}: {1}' -f $n,$_ }`
> - Ran `rg -n '"slug"|portableLeaf|portable' src/shared/jsonl_engine/schemas/article.schema.json | Select-Object -First 80
$lines=Get-Content src/shared/jsonl_engine/schemas/article.schema.json
for($i=20;$i -le 50;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}`
> - Ran `$lines=Get-Content src/shared/jsonl_engine/schemas/article.schema.json
for($i=310;$i -le 345;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}`
> - Ran `rg -n "patch.*UTF|UTF.*patch|strict bytes|without a BOM|bare CR|trailing" ingestion issues/latex-ingest/planning tests/README.md issues/batch-executor/planning/testing-batchability-inventory.md -g '*.md' | Select-Object -First 200`
> - Ran `git diff -- tests/README.md issues/batch-executor/planning/testing-batchability-inventory.md issues/latex-ingest/planning/ledger.md issues/latex-ingest/planning/roadmap.md`
> - Ran `rg -n -C 6 "LaTeX|latex-batch|Get-LatexBatchJob|identity|Writes" src/adapters/README.md | Select-Object -First 260`
> - Ran `$paths = @(
 'src/latex-ingest/latex-patch.ps1',
 'src/latex-ingest/latex-ingest.ps1',
 'src/latex-ingest/latex-ingest-compat.ps1',
 'src/adapters/private/latex-inventory-row.ps1',
 'src/adapters/public/Get-LatexBatchJob.ps1',
 'src/adapters/workers/invoke-latex-ingest.ps1',
 'tests/latex-ingest/latex-patch.Tests.ps1',
 'tests/latex-ingest/latex-ingest-integration.Tests.ps1',
 'tests/adapters/latex-batch.Tests.ps1'
)
$failures = @()
foreach ($path in $paths) {
  $tokens = $null; $errors = $null
  [void][System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path $path), [ref]$tokens, [ref]$errors)
  if ($errors.Count) { $failures += $errors | ForEach-Object { "$path:$($_.Extent.StartLineNumber): $($_.Message)" } }
}
if ($failures.Count) { $failures; exit 1 }
"AST parse clean: $($paths.Count) files"`
> - Ran `$paths = @(
 'src/latex-ingest/latex-patch.ps1',
 'src/latex-ingest/latex-ingest.ps1',
 'src/latex-ingest/latex-ingest-compat.ps1',
 'src/adapters/private/latex-inventory-row.ps1',
 'src/adapters/public/Get-LatexBatchJob.ps1',
 'src/adapters/workers/invoke-latex-ingest.ps1',
 'tests/latex-ingest/latex-patch.Tests.ps1',
 'tests/latex-ingest/latex-ingest-integration.Tests.ps1',
 'tests/adapters/latex-batch.Tests.ps1'
)
$failures = @()
foreach ($path in $paths) {
  $tokens = $null; $errors = $null
  [void][System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path $path), [ref]$tokens, [ref]$errors)
  if ($errors.Count) { $failures += $errors | ForEach-Object { "${path}:$($_.Extent.StartLineNumber): $($_.Message)" } }
}
if ($failures.Count) { $failures; exit 1 }
"AST parse clean: $($paths.Count) files"`
> - Ran `rg -n "atomic|transaction|partial|failed run|publication" issues/latex-ingest/planning/roadmap.md issues/latex-ingest/planning/decisions.md ingestion/README.md | Select-Object -First 120`
>
> </details>
>
> The adversarial pass found several boundary issues worth closing before handoff: whitespace could disable a pin, unreadable paths could masquerade as “absent,” patch size was unbounded, and direct calls could bypass record validation. I’m doing one final scoped hardening pass; the larger whole-conversion atomicity question is separate from this input lane and will be recorded rather than smuggled into this tranche.
>
> <details><summary>Ran 2 commands</summary>
>
> - Ran `git diff -- tests/adapters/latex-batch.Tests.ps1`
> - Ran `$n=0; Get-Content src/latex-ingest/latex-ingest-compat.ps1 | Select-Object -First 22 | ForEach-Object {$n++;'{0,3}: {1}' -f $n,$_}`
>
> </details>
>
> <details><summary>Ran 2 commands</summary>
>
> - Ran `rg -n "MaxPatch|PatchMax|1048576|1MB|portable|CON\||ExpectedPatchIdentity|ItemNotFound|ReadAllBytes|FileStream|Assert-LatexPatchRuntime" src/latex-ingest/latex-patch.ps1 src/adapters/private/latex-inventory-row.ps1 tests/latex-ingest/latex-patch.Tests.ps1 tests/adapters/latex-batch.Tests.ps1 | Select-Object -First 300`
> - Ran `$lines=Get-Content src/adapters/private/latex-inventory-row.ps1
for($i=1;$i -le 45;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}
for($i=118;$i -le 180;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}
for($i=245;$i -le 275;$i++){'{0,4}: {1}' -f $i,$lines[$i-1]}`
>
> </details>
>
> Context compaction
>
> Source: automatic
> Status: completed
>
> The core path, batch pinning, and end-to-end wiring are in place. I’m closing the last bounded hardening pass now—size limits, portable leaf validation, strict missing/error distinctions—then I’ll run the combined regression gates and report the one deliberately deferred atomicity issue.
>
> <details><summary>Ran 4 commands</summary>
>
> - Ran `git status --short; git diff --stat; git diff --name-only -- src/shared/jsonl_engine src/shared/jsonl-engine-client`
> - Ran `rg -n "PatchMax|ReadAllBytes|IsNullOrWhiteSpace|portable|Get-Item|ExpectedPatchIdentity|function Invoke-Latex(Source|Output)Patches|Test-LatexPatch" src/latex-ingest/latex-patch.ps1 src/adapters/private/latex-inventory-row.ps1`
> - Ran `Get-Content -LiteralPath src/latex-ingest/latex-patch.ps1`
> - Ran `rg -n "empty|blank|Read-LatexPatch|Invoke-LatexSourcePatches|unknown op|missing 'replace'|1 MiB|whitespace|portable" tests/latex-ingest/latex-patch.Tests.ps1`
>
> </details>
>
> <details><summary>Ran a command</summary>
>
> - Ran `git diff -- src/latex-ingest/latex-ingest.ps1 src/latex-ingest/latex-ingest-compat.ps1 src/adapters/private/latex-inventory-row.ps1 src/adapters/public/Get-LatexBatchJob.ps1 src/adapters/workers/invoke-latex-ingest.ps1`
>
> </details>
>
> <details><summary>Ran 2 commands</summary>
>
> - Ran `git status --short src/adapters/README.md; rg -n "patch|1 MiB|atomic|transaction" src/adapters/README.md issues/latex-ingest/planning/roadmap.md ingestion/README.md ingestion/inventory/CONVENTION.md tests/README.md issues/latex-ingest/planning/decisions.md`
> - Ran `Get-Content issues/latex-ingest/planning/decisions.md | Select-Object -Skip 140 -First 40; Get-Content ingestion/README.md | Select-Object -Skip 112 -First 32; Get-Content ingestion/inventory/CONVENTION.md | Select-Object -Skip 28 -First 28`
>
> </details>
>
> <details><summary>Ran 3 commands</summary>
>
> - Ran `rg -n "Assert-LatexPatchApplicationRecord|ConvertTo|unknown op|AllowEmptyCollection|Read-LatexPatchBoundedBytes|ReadAllBytes" src/latex-ingest/latex-patch.ps1 tests/latex-ingest/latex-patch.Tests.ps1; Get-Content src/latex-ingest/latex-patch.ps1 | Select-Object -Skip 300 -First 210`
> - Ran `Get-Content src/latex-ingest/latex-patch.ps1 | Select-Object -First 125; Get-Content tests/latex-ingest/latex-patch.Tests.ps1 | Select-Object -Skip 90 -First 75; Get-Content tests/latex-ingest/latex-patch.Tests.ps1 | Select-Object -Skip 235 -First 45`
> - Ran `Get-Content tests/latex-ingest/latex-patch.Tests.ps1 | Select-Object -First 115; rg -n "New-PatchFile|source_replace|output_replace|define_macro" tests/latex-ingest/latex-patch.Tests.ps1`
>
> </details>
>
> <details><summary>Ran a command</summary>
>
> - Ran `rg -n "expect_uses|record\['expect'\]" src/latex-ingest/latex-patch.ps1 | Select-Object -First 20`
>
> </details>
>
> The hardening review caught one subtle PowerShell edge around zero-byte files and another around optional guard fields. Both are now covered explicitly, so the tolerant format still permits an empty patch file and records that omit `expect`/`expect_uses` without weakening strict type checks when those fields are present.
>
> <details><summary>Ran 3 commands</summary>
>
> - Ran `$env:PORTABLE_ROOT; Get-Command pwsh | Select-Object -ExpandProperty Source; Get-ChildItem -LiteralPath (Join-Path $env:PORTABLE_ROOT 'Powershell') -Directory -ErrorAction SilentlyContinue | Select-Object -First 5 -ExpandProperty FullName`
> - Ran `Get-ChildItem -LiteralPath 'C:\Users\azrie\PDenv' -Force | Select-Object Name,FullName,Mode`
> - Ran `Get-ChildItem -LiteralPath 'C:\Users\azrie\PDenv\PowerShell' -Force | Select-Object -First 20 Name,FullName,Mode`
>
> </details>
>
> The implementation is stable across the scoped agents. I’m running the authoritative containers independently now—including compatibility and topology, not just the new happy-path tests—then I’ll do a final syntax/scope/diff audit.
>
> <details><summary>Ran 6 commands</summary>
>
> - Ran `& 'C:\Program Files\PowerShell\7\pwsh.exe' -NoProfile -File tests/run.ps1 -Path 'tests/latex-ingest/latex-ingest-integration.Tests.ps1' -OutputVerbosity Normal`
> - Ran `& 'C:\Program Files\PowerShell\7\pwsh.exe' -NoProfile -File tests/run.ps1 -Path 'tests/latex-ingest/latex-ingest-compat.Tests.ps1' -OutputVerbosity Normal`
> - Ran `& 'C:\Program Files\PowerShell\7\pwsh.exe' -NoProfile -File tests/run.ps1 -Path 'tests/latex-ingest/latex-patch.Tests.ps1' -OutputVerbosity Normal`
> - Ran `& 'C:\Program Files\PowerShell\7\pwsh.exe' -NoProfile -File tests/run.ps1 -Path 'tests/adapters/latex-batch.Tests.ps1' -OutputVerbosity Normal`
> - Ran `& 'C:\Program Files\PowerShell\7\pwsh.exe' -NoProfile -File tests/run.ps1 -Path 'tests/infrastructure/path-topology.Tests.ps1' -OutputVerbosity Normal`
> - Ran `$testPaths = @('tests/latex-ingest/latex-patch.Tests.ps1','tests/adapters/latex-batch.Tests.ps1','tests/latex-ingest/latex-ingest-integration.Tests.ps1','tests/latex-ingest/latex-ingest-compat.Tests.ps1','tests/infrastructure/path-topology.Tests.ps1'); $failed = [System.Collections.Generic.List[string]]::new(); foreach ($testPath in $testPaths) { Write-Host "RUNNING $testPath"; try { & ./tests/run.ps1 -Path $testPath -OutputVerbosity Normal } catch { $failed.Add($testPath); Write-Error $_ } }; if ($failed.Count -gt 0) { throw "Failed containers: $($failed -join ', ')" }`
>
> </details>
>
> The four relevant containers are green: 43/43 tests. The broader topology gate still has its four pre-existing dead JSONL-v2 references (the already-documented archaeology); the new `latex-patch.ps1` reference itself resolves cleanly. I’m checking the wider LaTeX suite and mechanical repository invariants next.
>
> <details><summary>Ran 2 commands</summary>
>
> - Ran `rg --files tests/latex-ingest | Sort-Object`
> - Ran `& ./tests/run.ps1 -Path tests/latex-ingest/latex-ingest.Tests.ps1 -OutputVerbosity Normal`
>
> </details>
>
> <details><summary>Ran 12 commands</summary>
>
> - Ran `$changed = @((git diff --name-only -- '*.ps1'), (git ls-files --others --exclude-standard -- '*.ps1')) | Where-Object { $_ } | Sort-Object -Unique; $parseFailures = [System.Collections.Generic.List[string]]::new(); foreach ($file in $changed) { $tokens = $null; $errors = $null; [void][System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path -LiteralPath $file).Path, [ref]$tokens, [ref]$errors); foreach ($error in @($errors)) { $parseFailures.Add("$file:$($error.Extent.StartLineNumber): $($error.Message)") } }; "PS1_CHANGED=$($changed.Count)"; "AST_ERRORS=$($parseFailures.Count)"; $parseFailures; $physical = @(rg --files tests -g '*.Tests.ps1').Count; $textual = @(rg -n '^\s*It\s+' tests -g '*.Tests.ps1').Count; "PESTER_FILES=$physical"; "TEXTUAL_IT=$textual"; $scope = @(git diff --name-only -- src/shared/jsonl_engine src/shared/jsonl-engine-client); "STRICT_ENGINE_OR_CLIENT_DIFFS=$($scope.Count)"; git diff --check; "DIFF_CHECK_EXIT=$LASTEXITCODE"; $newFiles = @(git ls-files --others --exclude-standard); $trailing = [System.Collections.Generic.List[string]]::new(); foreach ($file in $newFiles) { $lineNo = 0; foreach ($line in [System.IO.File]::ReadLines((Resolve-Path -LiteralPath $file).Path)) { $lineNo++; if ($line -match '[ \t]+$') { $trailing.Add("$file:$lineNo") } } }; "UNTRACKED_TRAILING_WS=$($trailing.Count)"; $trailing`
> - Ran `$changed = @((git diff --name-only -- '*.ps1'), (git ls-files --others --exclude-standard -- '*.ps1')) | Where-Object { $_ } | Sort-Object -Unique; $parseFailures = [System.Collections.Generic.List[string]]::new(); foreach ($file in $changed) { $tokens = $null; $errors = $null; [void][System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path -LiteralPath $file).Path, [ref]$tokens, [ref]$errors); foreach ($error in @($errors)) { $parseFailures.Add("${file}:$($error.Extent.StartLineNumber): $($error.Message)") } }; "PS1_CHANGED=$($changed.Count)"; "AST_ERRORS=$($parseFailures.Count)"; $parseFailures; $physical = @(rg --files tests -g '*.Tests.ps1').Count; $textual = @(rg -n '^\s*It\s+' tests -g '*.Tests.ps1').Count; "PESTER_FILES=$physical"; "TEXTUAL_IT=$textual"; $scope = @(git diff --name-only -- src/shared/jsonl_engine src/shared/jsonl-engine-client); "STRICT_ENGINE_OR_CLIENT_DIFFS=$($scope.Count)"; git diff --check; "DIFF_CHECK_EXIT=$LASTEXITCODE"; $newFiles = @(git ls-files --others --exclude-standard); $trailing = [System.Collections.Generic.List[string]]::new(); foreach ($file in $newFiles) { $lineNo = 0; foreach ($line in [System.IO.File]::ReadLines((Resolve-Path -LiteralPath $file).Path)) { $lineNo++; if ($line -match '[ \t]+$') { $trailing.Add("${file}:$lineNo") } } }; "UNTRACKED_TRAILING_WS=$($trailing.Count)"; $trailing`
> - Ran `$trackedChanged = @(git diff --name-only) | Where-Object { [System.IO.Path]::GetExtension($_) -ieq '.ps1' }; $untrackedChanged = @(git ls-files --others --exclude-standard) | Where-Object { [System.IO.Path]::GetExtension($_) -ieq '.ps1' }; $changed = @($trackedChanged + $untrackedChanged) | Where-Object { $_ } | Sort-Object -Unique; $parseFailures = [System.Collections.Generic.List[string]]::new(); foreach ($file in $changed) { $tokens = $null; $parseErrors = $null; [void][System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path -LiteralPath $file).Path, [ref]$tokens, [ref]$parseErrors); foreach ($parseError in @($parseErrors)) { $parseFailures.Add("${file}:$($parseError.Extent.StartLineNumber): $($parseError.Message)") } }; "PS1_CHANGED=$($changed.Count)"; $changed; "AST_ERRORS=$($parseFailures.Count)"; $parseFailures`
> - Ran `git status --short; git diff --stat; git diff --check; git diff --name-only -- src/shared/jsonl_engine src/shared/jsonl-engine-client`
> - Ran `git diff -- src/adapters/README.md tests/README.md issues/batch-executor/planning/testing-batchability-inventory.md issues/latex-ingest/planning/ledger.md issues/latex-ingest/planning/roadmap.md`
> - Ran `Get-Content src/latex-ingest/latex-ingest-compat.ps1 | Select-Object -First 22; rg -n "Read-LatexPatchSet|Invoke-LatexIngestResolvedSource|patchSet|patchesApplied|patch_identity" src/latex-ingest/latex-ingest.ps1 src/latex-ingest/latex-ingest-compat.ps1`
> - Ran `Get-Content tests/run.ps1 | Select-Object -First 130; Get-Content tests/infrastructure/path-topology.Tests.ps1 | Select-Object -Skip 240 -First 65`
> - Ran `Get-Content src/latex-ingest/latex-ingest.ps1 | Select-Object -First 48; Get-Content src/adapters/adapters.psm1 | Select-Object -First 80`
> - Ran `rg -n "invoke-latex-ingest\.ps1|ExpectedPatchIdentity|Invoke-LatexIngestResolvedSource" --glob '!issues/archive/**' --glob '!graveyard/**'`
> - Ran `rg -n "ExpectedPatchIdentity" src tests`
> - Ran `rg -n "Invoke-LatexIngestResolvedSource" src tests`
> - Ran `rg -n "^function (Get-LatexPatchPath|Read-LatexPatchSet|Assert-LatexPatchRuntimeRecords|Invoke-LatexSourcePatches|Invoke-LatexOutputPatches)|patch_identity|Resolve-LatexBatchPatchRecord|PatchIdentity|D20|Whole-conversion" src/latex-ingest/latex-patch.ps1 src/latex-ingest/latex-ingest.ps1 src/adapters/private/latex-inventory-row.ps1 src/adapters/public/Get-LatexBatchJob.ps1 issues/latex-ingest/planning/decisions.md issues/latex-ingest/planning/roadmap.md`
>
> </details>
>
> All scoped behavior gates are green, including the wider 60-test LaTeX container. Mechanical checks also match the documented inventory: 49 Pester files, 519 textual cases, nine changed PowerShell files with zero parse errors, and no changes to the strict Python engine/client. A fresh read-only reviewer is doing the last adversarial pass.
>
> The fresh review found a real planner-side resource race: the adapter checked 1 MiB before hashing but then handed the stream to an unbounded hash routine. I’ve sent that back for a bounded incremental read, along with a subtle terminal-newline slug-anchor mismatch. The core reader itself was already correctly bounded.
>
> <details><summary>Ran 6 commands</summary>
>
> - Ran `Get-Content src/adapters/private/latex-inventory-row.ps1 | Select-Object -Skip 18 -First 18; Get-Content src/adapters/private/latex-inventory-row.ps1 | Select-Object -Skip 148 -First 48; rg -n "bad.*name|trailing|COM0" tests/adapters/latex-batch.Tests.ps1`
> - Ran `rg -n 'portableLeaf|pattern' src/shared/jsonl_engine/schemas/article.schema.json | Select-Object -Last 15; Get-Content src/shared/jsonl_engine/schemas/article.schema.json | Select-Object -Skip 375 -First 28`
> - Ran `rg -n "portable|relative|slug" src/shared/jsonl_engine/kinds/article.py | Select-Object -First 40; Get-Content src/shared/jsonl_engine/kinds/article.py | Select-Object -First 180`
> - Ran ``Get-Content src/adapters/private/latex-inventory-row.ps1 | Select-Object -Skip 20 -First 15; Get-Content src/adapters/private/latex-inventory-row.ps1 | Select-Object -Skip 155 -First 55; rg -n "terminal|bad.*`n|unsafe-newline|IncrementalHash" tests/adapters/latex-batch.Tests.ps1 src/adapters/private/latex-inventory-row.ps1``
> - Ran `Get-Content tests/adapters/latex-batch.Tests.ps1 | Select-Object -Skip 565 -First 28`
> - Ran `& ./tests/run.ps1 -Path tests/adapters/latex-batch.Tests.ps1 -OutputVerbosity Normal`
>
> </details>
>
> <details><summary>Ran 3 commands</summary>
>
> - Ran `Get-Content src/adapters/public/Get-LatexBatchJob.ps1 | Select-Object -Skip 35 -First 72; Get-Content src/adapters/private/latex-address.ps1 | Select-Object -First 100`
> - Ran `rg -n "ExpectedSlug|ConvertFrom-LatexPatchJsonLine -Json" src/latex-ingest/latex-ingest.ps1 src/latex-ingest/latex-patch.ps1 src/adapters/public/Get-LatexBatchJob.ps1 src/adapters/workers/invoke-latex-ingest.ps1 tests/adapters/latex-batch.Tests.ps1 tests/latex-ingest/latex-patch.Tests.ps1`
> - Ran `Get-Content src/latex-ingest/latex-ingest.ps1 | Select-Object -Skip 2660 -First 38; Get-Content src/latex-ingest/latex-patch.ps1 | Select-Object -Skip 294 -First 20; rg -n "NBSP|00A0|non-JSON whitespace" tests/latex-ingest/latex-patch.Tests.ps1`
>
> </details>
>
> <details><summary>Ran a command</summary>
>
> - Ran `rg -n "ExpectedSlug" src/adapters tests/adapters/latex-batch.Tests.ps1 | Select-Object -First 30`
>
> </details>
>
> The planner cap is now truly enforced during hashing, and the strict end-anchor mismatch is fixed. I also chose to close the reviewer’s legacy-only address gap: batch execution now pins the planned slug as well as patch bytes, so a changed legacy manifest cannot redirect the worker to a different patch/output address under the old job. Tests and docs are being reconciled around that final pin.
>
> <details><summary>Ran 3 commands</summary>
>
> - Ran `rg -n "ExpectedSlug|slug drift|different slug" tests/adapters/latex-batch.Tests.ps1 src/adapters/public/Get-LatexBatchJob.ps1 src/adapters/workers/invoke-latex-ingest.ps1`
> - Ran `Get-Content tests/adapters/latex-batch.Tests.ps1 | Select-Object -Skip 920 -First 75`
> - Ran `Get-Content tests/adapters/latex-batch.Tests.ps1 | Select-Object -Skip 995 -First 30`
>
> </details>
>
> The independent reviewer is clear: no remaining blocker after the bounded-hash, strict parsing, and slug-pin fixes. I’m doing one clean final rerun over the four feature containers plus the 60-test wider LaTeX suite, then I’ll hand back the exact result and the two intentionally deferred lifecycle hardenings.
>
> <details><summary>Ran 3 commands</summary>
>
> - Ran `$testPaths = @('tests/latex-ingest/latex-patch.Tests.ps1','tests/adapters/latex-batch.Tests.ps1','tests/latex-ingest/latex-ingest-integration.Tests.ps1','tests/latex-ingest/latex-ingest-compat.Tests.ps1','tests/latex-ingest/latex-ingest.Tests.ps1'); $failed = [System.Collections.Generic.List[string]]::new(); foreach ($testPath in $testPaths) { Write-Host "RUNNING $testPath"; try { & ./tests/run.ps1 -Path $testPath -OutputVerbosity Normal } catch { $failed.Add($testPath); Write-Error $_ } }; if ($failed.Count -gt 0) { throw "Failed containers: $($failed -join ', ')" }`
> - Ran `$trackedChanged = @(git diff --name-only); $untrackedChanged = @(git ls-files --others --exclude-standard); $psChanged = @($trackedChanged + $untrackedChanged) | Where-Object { [System.IO.Path]::GetExtension($_) -ieq '.ps1' } | Sort-Object -Unique; $parseFailures = [System.Collections.Generic.List[string]]::new(); foreach ($file in $psChanged) { $tokens = $null; $parseErrors = $null; [void][System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path -LiteralPath $file).Path, [ref]$tokens, [ref]$parseErrors); foreach ($parseError in @($parseErrors)) { $parseFailures.Add("${file}:$($parseError.Extent.StartLineNumber): $($parseError.Message)") } }; $physical = @(rg --files tests -g '*.Tests.ps1').Count; $textual = @(rg -n '^\s*It\s+' tests -g '*.Tests.ps1').Count; $scope = @(git diff --name-only -- src/shared/jsonl_engine src/shared/jsonl-engine-client); git diff --check; $diffExit = $LASTEXITCODE; $trailing = [System.Collections.Generic.List[string]]::new(); foreach ($file in $untrackedChanged) { $resolved = Resolve-Path -LiteralPath $file; if ((Get-Item -LiteralPath $resolved).PSIsContainer) { continue }; $lineNo = 0; foreach ($line in [System.IO.File]::ReadLines($resolved.Path)) { $lineNo++; if ($line -match '[ \t]+$') { $trailing.Add("${file}:$lineNo") } } }; "CHANGED_FILES=$(@($trackedChanged + $untrackedChanged | Sort-Object -Unique).Count)"; "CHANGED_PS1=$($psChanged.Count)"; "AST_ERRORS=$($parseFailures.Count)"; $parseFailures; "PESTER_FILES=$physical"; "TEXTUAL_IT=$textual"; "STRICT_ENGINE_OR_CLIENT_DIFFS=$($scope.Count)"; "DIFF_CHECK_EXIT=$diffExit"; "UNTRACKED_TRAILING_WS=$($trailing.Count)"; $trailing; git status --short`
> - Ran `rg -n "ExpectedSlug|incremental|one-byte|manifest immut" src/adapters/README.md issues/latex-ingest/planning/decisions.md issues/latex-ingest/planning/ledger.md; git diff --check`
>
> </details>
>
> <details><summary>Plan</summary>
>
> The tolerant patch lane, batch identity/address pinning, regressions, and live documentation are complete. Final centralized gates passed; the independent adversarial review found no remaining blocker.
>
> - [x] Implement canonical tolerant patch reader, validation, identity pinning, and converter wiring
> - [x] Integrate patch identity into batch planning and worker transport
> - [x] Add unit, adapter, compatibility, and real end-to-end regressions
> - [x] Harden size, portability, lookup, and direct-applier boundaries
> - [x] Reconcile live decisions, layout docs, inventory, and roadmap
> - [x] Run centralized regression, syntax, diff, and scope gates
>
> </details>

</details>

Implemented the tolerant patch-JSONL lane end to end.

- Canonical path: `{documentDir}/{slug}-latex.patch.jsonl`; `OutDir` copies are ignored.
- Blank lines and full-line `#`/`//` comments remain tolerant; JSON objects, UTF-8, fields, types, and operations are strict.
- Added 1 MiB limits, bounded regexes, reparse checks, raw-byte identities, provenance, and authored-order audits.
- Batch planning pins both patch identity and expected slug, refusing content/address drift before writes.
- Documented as domain-local curation—not a strict Python JSONL-engine store—in [D20](/D:/aghado01/codex-scientiae/issues/latex-ingest/planning/decisions.md:145).
- Main implementation: [latex-patch.ps1](/D:/aghado01/codex-scientiae/src/latex-ingest/latex-patch.ps1:1).

Final Pester gate: **103/103 passed** across patch, adapter, integration, compatibility, and wider LaTeX tests. PowerShell parsing and `git diff --check` are clean. No strict Python engine/client files changed.

Known follow-ups are recorded: whole-conversion atomic publication after late output-patch refusal, and stronger handle-level no-follow protection. The unrelated topology test still reports its four pre-existing retired JSONL-v2 references. Changes remain uncommitted.
