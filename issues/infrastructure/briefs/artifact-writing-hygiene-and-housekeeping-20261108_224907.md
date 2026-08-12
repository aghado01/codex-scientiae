# Infrastructure brief — owned artifact writing and lifecycle housekeeping

Status: repository test-root ownership corrected; allocator and pressure-collection implementation deferred.

Snapshot: 2026-08-11, local runstamp `20261108_224907`.

Scope: active `codex-scientiae` code and current repository-local working trees. The graveyard and
historical material under `issues/` were excluded from the code scan except where linked as prior design
work. This brief does not authorize deletion of any existing path.

## Purpose

The repository has several individually reasonable writing patterns that do not yet compose into one
artifact lifecycle:

- some operations mint UUID or GUID path components to avoid thinking about ownership;
- some tools fall back to the operating-system temporary directory even when the work belongs to this
  repository;
- some writers use a fixed sibling `.tmp`, which is short but unsafe when two operations can target the
  same destination;
- the batch harness allocates isolated result, evidence, and temporary addresses, but does not dispose of
  successful-run residue;
- ignored trees accumulate many nearly empty directories that still cost filesystem traversal, editor
  indexing, antivirus inspection, and backup enumeration; and
- `artifact` is used informally for transaction scratch, test diagnostics, native results, caches,
  regenerable products, and occasionally non-regenerable evidence, even though those things require
  different retention rules.

The corrective principle is:

> Every write has one owner, one declared address class, one publication rule, and one closing action.

Random leaf names are not a substitute for those four decisions. UUID-based filesystem leaves are not an
admissible default and require case-specific review before introduction.

## Current pressure witness

The snapshot is small in bytes but already expensive in namespace entries:

| Root | Files | Directories | Bytes | Observation |
|---|---:|---:|---:|---|
| `artifacts/` | 1,911 | 1,755 | 239,930,382 | Mixed build output, caches, test runs, and run products. |
| `.codex/` | 531 | 233 | 94,928,784 | Client-owned state and historical residue; not an admissible project run destination. |
| `artifacts/test-runs/` | 97 | 315 | 283,809 | All 97 files are XML reports; 102 descendant directories are empty. |

The test-run subtree is the clearest example of the problem. Its directory count is more than three times
its file count, while the entire tree is only about 277 KiB. A byte-only threshold would consider it
irrelevant even though namespace and indexing work dominate its storage cost.

The largest current `artifacts/` populations also have different meanings:

| Subtree | Files | Directories | Bytes | Lifecycle class to establish |
|---|---:|---:|---:|---|
| `artifacts/node/` | 817 | 1,224 | 73,987,559 | Reusable dependency cache; prune by cache policy, not test-result policy. |
| `artifacts/tectonic/` | 456 | 7 | 46,925,947 | Owner not found by the active-code scan; establish the producer and rebuild policy. |
| `artifacts/hdbscan/` | 287 | 32 | 93,031,066 | Build intermediates and publish staging. |
| `artifacts/doccer/` | 154 | 42 | 7,607,790 | Build intermediates and publish staging. |
| `artifacts/test-runs/` | 97 | 315 | 283,809 | Run-scoped results, empty roots, and temporary addresses. |

These counts are a point-in-time lower bound over paths readable by the current process. They are evidence
for the policy problem, not a deletion list.

## Vocabulary and disposition classes

The word `artifact` should remain a broad human term. Filesystem policy needs narrower classes:

| Class | Examples | Address owner | Closing action |
|---|---|---|---|
| Transaction scratch | Adjacent JSON/JSONL staging file, archive expansion payload | The publishing operation | Publish atomically or delete before the operation returns. A later writer may collect a proven orphan while holding the same destination lease. |
| Fixture scratch | `$TestDrive`, pytest `tmp_path`, a job-local `temp/` tree | The test or framework runner | Delete on every normal exit. It is never evidence merely because a test failed. |
| Native result | `pytest.xml`, `pester.xml` | The framework adapter/runner | Keep until the parent has parsed and accepted it. The run owner then applies the selected retention policy. |
| Diagnostic evidence | Files intentionally written below `CODEX_TEST_ARTIFACT_ROOT` | The test container | Delete after success; retain after failure until collected, explicitly released, or pressure-collected. |
| Coordination/recovery state | Locks, acquisition journal, resumable `.part` | The transaction/store | Remove only under the protocol that proves no live owner or after successful recovery. Never delete by filename age alone. |
| Reusable cache | npm cache, compiler cache, restored tool payload | The build/dependency owner | Reuse across runs; prune by version/reachability and namespace pressure. |
| Regenerable run product | Render output, build intermediates, ordinary local run reports | The run owner | Close immediately when no longer useful, otherwise include in run-level pressure collection. |
| Durable evidence or deliverable | Released packages, source sentinels, investigation exhibits | The owning application/store | Do not place under a tree whose contract says wholesale deletion is safe. Publish or promote through its durable contract. |
| Run receipt/ledger | Compact outcome, provenance, pin and collection events | Run infrastructure | Retain after bulky descendants are collected so a referenced run does not become an unexplained missing path. |

This classification preserves the current [`artifacts/` contract](../../../artifacts/README.md): content
under that root is regenerable or disposable working output. If a proceeding or investigation produces
non-regenerable evidence, it must be promoted out of `artifacts/` or represented by an explicit durable
store before wholesale collection can be considered safe. The unresolved evidence distinction is already
identified in the related [generational-GC brief](../../devops/briefs/opus-resumable-stages-run-ledger-generational-gc-20260807_135748.md).

## Proposed framework: owned workspaces

The framework is a lifecycle pattern, not a requirement that every language import one implementation.
The smallest useful concepts are `RunWorkspace`, `JobWorkspace`, and `OperationScratch`.

### Run workspace

One caller allocates the run root before parallel planning. The house runstamp is exactly:

```text
YYYYDDMM_HHmmss
```

The compact repository-local form is:

```text
artifacts/test-runs/20261108_224907/
```

Use `_02`, `_03`, and so on for same-second collisions when one sequential allocator is producing the
runs. Allocation should use an atomic directory create if multiple parent processes are possible. It should
not append a GUID.

The house order is year-day-month, not year-month-day. Consequently a path such as `20263101_...` does not
sort chronologically against `20260102_...`. Any newest-run operation must parse the stamp or consult a run
ledger; it must not rely on lexical directory order.

The caller owns the root's final disposition. Batch adapters continue to consume an existing absolute
`RunDirectory`; they do not mint timestamps, choose `artifacts/`, or delete the caller's root. This preserves
the accepted D19/D24/D27 boundaries in the
[batch decisions](../../batch-executor/planning/decisions.md).

### Job workspace

The planner enumerates jobs once and assigns collision-free descendants in that serial planning pass.
Parallel workers consume those already distinct addresses. They do not need random names to avoid one
another.

The current test shape remains sound:

```text
<run>/pester-jobs/<compact-address>/
    pester.xml
    artifacts/

<run>/pytest-jobs/<compact-address>/
    pytest.xml
    artifacts/
    temp/
```

A compact job address should prefer, in order:

1. a bounded descriptive stem;
2. a run-local ordinal when the parent enumeration already establishes identity; or
3. a short stable digest when the semantic identity can collide across paths or selector sets.

A short stable digest is not a random UUID. It should be used only where it carries stable identity. The
complete address must be checked against a path budget derived from the caller's run root rather than a
fixed 48-character stem cap.

### Operation scratch

An operation uses one of two patterns:

- a stable private leaf such as `.download.part` while holding an item-specific lease, when recovery needs
  a predictable name; or
- an adjacent transaction leaf such as `<target>.<pid>.<process-serial>.tmp`, when concurrent writers can
  legitimately stage distinct generations.

The process serial is compact and collision-free within the process. A cross-process destination lease or
atomic create supplies the remaining exclusivity. The serial is allocated by one shared primitive rather
than separately in every writer.

The existing `jsonl_engine.sidecar.temp_write_path()` and lease-owned stale-scratch sweep are the current
Python exemplar. PowerShell and .NET callers should reuse a shared equivalent instead of assembling UUID or
fixed `.tmp` leaves themselves. An OS allocator such as `mkstemp` is also acceptable for a short-lived,
adjacent, atomically created transaction file when the exact leaf is never made part of a durable address.

### Address roots

Repository work uses a repository-local `.codex/` or `artifacts/` root. A test child uses the address passed
by its adapter. Code must not silently fall back to a long client-session path beneath a user profile or to
an unrelated volume when a repository/job root is available.

A reusable installed library may need an operating-system-temp fallback when no repository or caller root
exists. That is a separate deployment case and must be explicit in its contract. Repository tests and build
scripts do not qualify for that fallback.

## Test closing ceremony

"A passing test cleans itself up" needs two owners rather than one destructive hook:

- the test closes resources and removes fixtures it owns; and
- the run owner disposes of harness-owned results and evidence after the parent has collected them.

A test must not delete `pytest.xml`, `pester.xml`, its whole job directory, or another process's diagnostics.
Those files remain necessary while the framework runner and parent executor are deciding whether the job
actually succeeded.

The closing sequence is:

1. The test body and cleanup hooks stop child processes, close handles, restore process state, and remove
   fixture scratch.
2. The framework runner waits for its nested framework process, writes and validates the native result,
   emits its transient observation, and closes framework-owned handles.
3. The batch executor settles or kills the complete process tree, collects the immutable job result, and
   completes its existing lifecycle teardown. It does not delete domain files.
4. The repository run owner receives the complete execution record and classifies every job as success,
   test failure, timeout/cancellation, or infrastructure failure.
5. The run owner performs the selected disposition and records any cleanup failure as a visible run
   diagnostic rather than changing a failed test into a false pass.
6. Empty container and framework directories are pruned bottom-up. The caller-owned run root is removed only
   if the caller requested disposal and the finalizer can prove that it owns that exact root.

The proposed default local policy is:

| Outcome | `temp/` and JSON scratch | Explicit test artifacts | Native XML | Run root |
|---|---|---|---|---|
| Success | Delete after result validation | Delete | Retain until the parent consumes it; then delete in `DisposeOnSuccess` mode or compact into a run receipt | Remove when empty and caller-owned |
| Test failure | Delete after logs needed for diagnosis are captured, unless `PreserveFailureScratch` was requested | Retain | Retain | Retain as failure evidence |
| Timeout/cancellation | Delete only after executor teardown proves no descendants remain | Retain | Retain if present | Mark incomplete and retain until released or collected |
| Infrastructure failure | Do not guess about ownership while handles or child records remain | Retain | Retain if present | Mark incomplete and retain |

Useful policy names, subject to implementation design, are:

- `DisposeOnSuccess` — the normal local-development default;
- `RetainFailureEvidence` — the default failure behavior;
- `PreserveFailureScratch` — opt-in for a debugging run;
- `PinRun` — exclude a run and its reachable ancestors from collection; and
- `RetainAll` — an explicit forensic or parity witness.

The current shell returns the executor record only in memory. Therefore native XML cannot be deleted by
default until either the direct caller has opted into ephemeral success results or a compact durable run
receipt has accepted the outcome. The cleanup feature belongs in the run owner or a sibling finalizer, not
inside `batch-executor` and not implicitly inside an adapter.

## Housekeeping duty-cycle

There are three different cleanup times.

### 1. Operation close

Transaction and fixture scratch are removed synchronously before the owning operation returns. This is the
normal closing ceremony and should account for most small files.

### 2. Run close

After results are collected and process teardown completes, a run finalizer removes successful-job scratch,
successful diagnostic roots, and empty directories. This is deterministic and outcome-aware. It should not
wait for a later global janitor.

### 3. Pressure collection

Runs deliberately retained after failure, cancellation, investigation, or partial completion are collected
later. Pressure triggers the sweep; reachability and pins decide what it may take. This extends the earlier
generational-GC proposal rather than replacing it.

Pressure is a vector, not a byte count:

```text
{ files, directories, bytes, unpinned_runs }
```

File and directory thresholds protect indexing performance. Byte thresholds protect disk capacity. A lane
may exceed either independently.

Age may help prove that an abandoned lease cannot still be live, but age alone is not the retention rule for
evidence. The collector must exclude active workspaces, pinned runs, referenced resume ancestors, durable
stores, released packages, and configured caches whose owner has not authorized pruning.

An opportunistic pressure check at run start or run close is sufficient; a scheduled background service is
not required. A collector appends a `collected` event to the run ledger before removing a generation so old
briefs and logs can still resolve the run identity.

## Indexing hygiene

`.gitignore` prevents accidental version control; it does not stop every editor watcher, content indexer,
antivirus scanner, backup tool, or recursive diagnostic command.

The repository should therefore:

- concentrate repository test work beneath `artifacts/test-runs/`, not client-owned `.codex/`, scattered
  system temp, or source-tree locations;
- configure editor/indexing exclusions for those known ephemeral roots where the client supports them;
- prune empty directories during run close;
- avoid a single flat global scratch directory with unbounded file enumeration;
- keep cache roots distinct from per-run roots; and
- report namespace pressure as files and directories as well as bytes.

## Active code-path audit

The following tables are the specific follow-up inventory produced by searches for UUID/GUID leaf creation,
system-temp fallbacks, timestamp allocators, transaction suffixes, batch write addresses, and active
`artifacts/` roots. Line numbers describe the snapshot and may move.

### Run and test infrastructure

| Path | Current behavior | Audit or change |
|---|---|---|
| `src/logistics/run-paths.ps1:32-57` | Mints `yyyyMMdd_HHmmss`, appends `-2`, and returns runs newest-first by lexical directory sort. | Adopt `YYYYDDMM_HHmmss` plus `_NN`; parse stamps or use ledger time because house stamps are not lexically chronological. Add explicit lifecycle owner rather than only allocation/enumeration. |
| `src/shared/logger/logger.ps1:80-112` | Independently duplicates artifact-root and `yyyyMMdd_HHmmss` log allocation. | Consume the shared run/address primitive; do not maintain a second timestamp/suffix allocator. Define log disposition. |
| `src/batch-adapters/private/pester-address.ps1:16-51` | Uses a 48-character stem plus 12-hex stable digest under `pester-jobs`. | Preserve deterministic addressing; make the stem cap root/path-budget aware and classify result versus evidence writes. |
| `src/batch-adapters/private/pytest-address.ps1:16-48` | Uses the same pattern under `pytest-jobs` and declares `temp/`. | Same audit; keep job-local temp distinct from retained evidence. |
| `src/batch-adapters/public/Get-PesterBatchJob.ps1:36-89` | Declares native XML and artifact root in `Writes`. | Add disposition metadata or a typed workspace descriptor without making the adapter a cleaner. |
| `src/batch-adapters/public/Get-PytestBatchJob.ps1:41-115` | Declares XML, artifacts, temp, and JSON scratch; redirects `TEMP`, `TMP`, and `TMPDIR`. | This is the strongest current isolation pattern. Add disposition classification and preserve the existing path ownership. |
| `tests/run.ps1:61-100` | Produces Pester-native result and transient observation. | Ensure any child-level close happens only after result completion; never delete the parent-owned result here without an explicit handoff. |
| `tests/pytest.ps1:155-258` | Creates result and temp roots, runs pytest, validates JUnit, and leaves temp. | Add runner-owned temp close on success or leave disposition to the run finalizer; preserve failure diagnostics by policy. |
| `tests/parallel.ps1:1-133` | Composes and returns one in-memory execution record; performs no filesystem finalization. | Keep the shell thin. Add a caller/sibling run finalizer or explicitly revise D24/D27 before assigning lifecycle here. |
| `src/batch-executor/private/executor-teardown.ps1` | Owns child-tree, invocation, and runspace teardown. | Preserve this as process cleanup only. Filesystem disposition starts after this teardown reports completion. |
| `tests/README.md` and `src/batch-adapters/README.md` | Specify retained XML/artifact/temp addresses but no post-success disposal. | Document the closing ceremony, caller ownership, policy modes, and repository-local house run roots. |
| `.gitignore` and `artifacts/README.md` | Hide scratch/run trees from Git and call `artifacts/` disposable. | State that ignore is not collection; reconcile non-regenerable evidence with the disposable-root contract before GC. |

### Runtime and build writers

| Path | Current behavior | Audit or change |
|---|---|---|
| `src/jsonl_engine-client/public/New-JsonlEngineInputFile.ps1:23-75` | Uses system temp or `CODEX_JSON_SCRATCH_ROOT`; mints a GUID transport leaf and a second GUID transaction leaf. Caller owns final cleanup. | Use a caller/job root, compact PID/process serial, and a shared transaction publisher. Consider a disposable input handle whose close action is harder to omit. |
| `src/logistics/latex-source.ps1:300-410` | Uses one GUID for `.expand-*` and `.payload-*` archive work directories. | Replace with lease-owned stable names or the shared compact transaction allocator. Preserve rollback and path-confinement behavior. |
| `src/logistics/latex-source.ps1:1206-1278` | Calls `New-JsonlEngineInputFile` and correctly deletes module-chosen input in `finally` unless retained. | Preserve as a cleanup exemplar while changing the underlying name/root. |
| `src/logistics/latex-source.ps1:1332-1340` | Uses a GUID `.validate-*` candidate inside a document directory. | Use one deposit-lock-owned candidate or PID/serial scratch; collect a proven abandoned candidate on the next locked transaction. |
| `src/logistics/inventory-catalog.ps1:74-96` | Calls `New-JsonlEngineInputFile` and deletes temporary input in `finally`. | Preserve caller cleanup; migrate with the client primitive. |
| `src/node_utils/pdf-raster/pdf-raster.ps1:64-78` | Defaults to system temp and writes `.raster-jobs-<GUID>.json`, then deletes it in `finally`. | Require/infer an owned repository or job work root and use one stable call leaf or compact serial. Keep immediate cleanup. |
| `src/node_utils/math-render/math-render.ps1:75-104` | Writes `spans-<GUID>.json` into a repository-global flat `artifacts/math-render/scratch`, then deletes it. | Accept an owned work root or use job-local scratch; avoid global enumeration and UUID names. |
| `src/md-postprocess/audits/md-cleanup.ps1:165-194` | Uses the fixed sibling `.mdcleanup-idem.tmp`. | Use the shared adjacent transaction primitive or a private operation directory; fixed scratch can collide on concurrent checks of one file. |
| `src/hdbscan/HdbscanCli.cs:312-325` | Both atomic writers use fixed `<path>.tmp` with `FileMode.Create`, then overwrite the destination. | Use create-new PID/serial staging plus cleanup, or serialize each destination explicitly. Preserve atomic publication. |
| `brewery/doccer/build-doccer.ps1:614-622` | Writes `doccer-smoke-<GUID>.ps1` to system temp and removes it in `finally`. | Put the smoke script under module-owned publish/build scratch with a compact stable name; keep cleanup. |
| `src/jsonl_engine/sidecar.py:80-200` | Uses repository-global coordination scratch, with system-temp fallback; lock names are canonical-path digests. | Keep locks distinct from run products. Add a safe stale-lock policy only if the locking primitive can prove abandonment; do not age-delete live coordination. |
| `src/jsonl_engine/sidecar.py:139-200`, `engine.py:120-268`, `writer.py:136-186`, and `publication.py:526-541` | Use PID/process-serial adjacent scratch, destination leases, cleanup, and stale-scratch recovery. | Treat as the current Python transaction reference; consolidate other Python writers on these primitives rather than duplicating helpers. |
| `src/jsonl_engine/inspect.py:184-214` | Uses adjacent `mkstemp`, atomically replaces the destination, and removes failed scratch best-effort. | Review for parity with the common publisher; the OS-created leaf itself is acceptable and is not a durable UUID address. |
| `src/procurement/operations/materialization.py:230-294` | Uses context-managed `.source-*` temporary directories beneath the catalog root. | Preserve normal cleanup; define recovery/collection of crash-abandoned `.source-*` roots under the catalog transaction boundary. |
| `src/procurement/storage/acquisitions.py:22-23,244-332` and `operations/acquisition.py:293-362` | Use stable `.download.part` and `.acquisition-publish.json` under an item transaction, with journaled recovery. | Treat as recovery state, not ordinary scratch. Audit abandoned-item lifecycle and expose deliberate release without weakening recovery. |
| `src/procurement/source/archive.py:931-1035` and `filesystem.py:246-280` | Reuse the JSONL adjacent temp allocator and guarded cleanup. | Preserve as reuse exemplars; avoid procurement-local naming utilities. |
| `Directory.Build.props:3-27` | Routes .NET `bin/` and `obj/` under module artifact roots. | Add module build-retention/clean ownership; do not let generic test cleanup remove shared build inputs. |
| `brewery/doccer/build-doccer.ps1`, `brewery/hdbscan/build-hdbscan.ps1` | Own module publish staging and build output. | Define close-after-release and pressure-prune rules for `bin/`, `obj/`, and `publish/`. |
| `brewery/node/restore-node.ps1:18-31` | Owns `artifacts/node/npm-cache`. | Add cache-version/reachability pruning and file-count pressure; do not treat it as per-test scratch. |
| No active producer found for `artifacts/tectonic/` | 456 files remain in the current tree. | Locate and document the producer or classify this as abandoned residue before any collection. |

### Tests with UUID/GUID filesystem leaves

These tests generally remove their paths already. The audit is about compact ownership and repository-local
placement, not an allegation that every one leaks today.

| Path | Current filesystem leaf | Target pattern |
|---|---|---|
| `tests/logistics/crawl.Tests.ps1:9-27` | Four GUID descendants of `$TestDrive`. | Fixed case names; `$TestDrive` already partitions the container. |
| `tests/logistics/latex-source.Tests.ps1:62-100` | Four GUID descendants of `$TestDrive`. | Fixed case names or a BeforeEach serial. |
| `tests/md-postprocess/md-repair.Tests.ps1:8-12` | GUID Markdown leaves under `$TestDrive`. | Test-local incrementing serial or case name. |
| `tests/jsonl_engine-client/jsonl_engine-client-module.Tests.ps1:151,172` | GUID leaves under `$TestDrive`. | Descriptive fixed leaves; the cases already own distinct directories. |
| `tests/node_utils/math-render.Tests.ps1:5-15` | GUID directory under repository-global `artifacts/tests/math-render`. | `$TestDrive` for ephemeral output; `CODEX_TEST_ARTIFACT_ROOT` only for intentionally retained evidence. |
| `tests/md-postprocess/toc-engine.Tests.ps1:111,201,219,246` | Four GUID directories under system temp, each manually removed. | `$TestDrive` case roots or adapter-assigned temp. |
| `tests/shared/encoding-invariants.Tests.ps1:51-55` | `enc-inv-<GUID>` under system temp, removed in `AfterAll`. | `$TestDrive/encoding-invariants` or a job-temp child. |
| `tests/mcp-servers/reader-mcp/reader-mcp.Tests.ps1:16,111-115` | GUID fixture under system temp, removed in `AfterAll`. | `$TestDrive/reader-mcp` or job-temp child. |
| `tests/hdbscan/hdbscan.Tests.ps1:11-27,114-119` | Retained batch root when configured; otherwise short GUID under system temp and cleanup in `AfterAll`. | Preserve retained-evidence branch; use `$TestDrive` or job temp for direct ephemeral work. |
| `tests/doccer/Program.cs:1480-1506` | GUID JSONL in system temp, removed in `finally`. | Receive a test work root from the parent harness or use a compact process serial under the assigned temp root. |

### Context-managed temporary cohorts

The following active cohorts use context-managed temporary directories/files and normally already implement
the correct close-delete semantics:

- `tests/jsonl_engine/*.py`;
- `tests/jsonl_engine-client/test_shell_surface.py`;
- `tests/procurement/test_acquisition.py`;
- `tests/procurement/test_archive.py`;
- `tests/procurement/test_catalog_service.py`;
- `tests/procurement/test_http.py`; and
- `tests/jsonl_engine/regenerate_jsonl_goldens.py`.

Their audit is limited to ensuring that the batch adapter's `TEMP`/`TMP`/`TMPDIR` redirection is always in
effect during batch execution and that abnormal process termination is handled by run-level cleanup. They
do not need a mechanical rewrite merely because Python's temporary-directory implementation uses an opaque
internal name.

### Reviewed GUID uses that are not filesystem leaves

The filesystem policy does not imply that all logical GUIDs are invalid:

- `src/batch-executor/public/New-BatchPlan.ps1:8` uses a logical plan ID;
- `tests/batch-executor/batch-executor.Tests.ps1:144` uses an in-memory test token;
- `src/md-postprocess/audits/md-cleanup.ps1:94-96` uses a collision-resistant marker inside text;
- `src/doccer/Core/TextMaster.cs:64` supplies a logical document ID; and
- batch-adapter thinness tests mention GUID APIs as forbidden source tokens without invoking them.

These are explicitly excluded from the artifact-leaf migration. Any future change to logical identity is a
separate contract discussion.

## Implementation slices

### Slice A — convention and shared address primitives

1. Freeze `YYYYDDMM_HHmmss` and `_NN` in one parser/allocator.
2. Replace lexical newest-run sorting with parsed time or ledger order.
3. Define a root-aware path budget and compact job-address helper.
4. Provide shared PowerShell/.NET transaction-leaf behavior equivalent to the Python PID/process-serial
   primitive.
5. Add a static audit that distinguishes filesystem GUID creation from approved logical GUID use.

### Slice B — test run finalization

1. Define typed result, evidence, temporary, and coordination writes in adapter metadata or a workspace
   descriptor.
2. Implement a run-owner finalizer that consumes the completed execution record.
3. Delete successful job temp/evidence, preserve failure evidence, and prune empty directories.
4. Add explicit retain/pin switches and make cleanup errors visible without rewriting test outcomes.
5. Update `tests/README.md`, adapter decisions, and direct-run examples to use repository-local house-stamped
   roots.

### Slice C — writer migration

Migrate the active production and test rows above in bounded module groups. Preserve existing atomicity,
rollback, recovery, and test assertions. A shorter filename is not a valid trade for a weaker transaction.

### Slice D — pressure collector and ledger

1. Record run open/close, pins, reachability, and collection.
2. Measure files, directories, bytes, and unpinned runs.
3. Sweep only finalized or proven-abandoned workspaces under configured roots.
4. Give dependency caches owner-specific reachability rules.
5. Reconcile non-regenerable evidence with the disposable `artifacts/` contract before enabling broad GC.

## Acceptance checks

The follow-up is complete only when these behaviors are proved:

- the sole run allocator emits the exact house stamp and compact `_NN` suffixes;
- newest-run selection remains chronological across different days and months;
- concurrent planning assigns distinct deterministic job paths without random UUID leaves;
- path-budget tests cover a long repository root and the longest admitted test filename;
- two processes targeting one artifact cannot share transaction scratch or observe a partial publication;
- successful test runs leave no job temp, JSON scratch, diagnostic artifacts, or empty container roots after
  the parent has accepted results;
- failed, cancelled, and infrastructure-failed jobs retain the declared evidence and never lose it before
  process-tree teardown;
- cleanup is idempotent and refuses paths outside the exact caller-owned run root;
- an active lease, pin, durable reference, or resumable journal prevents collection;
- a pressure sweep responds independently to file count, directory count, and bytes;
- a collected run remains resolvable through a compact ledger event; and
- static search finds no unreviewed UUID/GUID filesystem-leaf construction in active code.

## Open decisions

1. Whether a local successful run deletes native XML immediately after the in-memory result is accepted, or
   first compacts it into a durable run receipt.
2. Whether failure scratch is deleted by default after logs are captured or retained until explicit release.
3. The concrete pressure thresholds for files, directories, bytes, and unpinned runs.
4. The durable location for non-regenerable investigation evidence currently written beneath `artifacts/`.
5. Whether the run workspace implementation begins beside `src/logistics/run-paths.ps1` or as a new
   application-neutral infrastructure module before possible promotion to `science-facility`.
6. How existing non-house run names and unattributed roots are registered or collected without pretending
   they already satisfy the new lifecycle contract.
