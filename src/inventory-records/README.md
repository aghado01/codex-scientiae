# Inventory records

`inventory-records.psm1` owns the JSON boundary between inventory workers and the
batch caller. It does not schedule processes or interpret engine output.

| File | Writer | Schema |
| :--- | :--- | :--- |
| `experiment.json` | Caller, before dispatch | `codex-scientiae/inventory-experiment/1` |
| `jobs/<attempt>/run.json` | Assigned worker | `codex-scientiae/paper-run/1` |
| `batch.json` | Caller, after execution | `codex-scientiae/inventory-batch/1` |

The [schema](inventory-records.schema.json) is applied on publication and readback.
[Examples](examples/) illustrate serialization; their zero hashes and example
paths are placeholders, not executable evidence. Engine payloads have their own
schema and validator. The generic envelope carries article/attempt identity,
producer, timing, terminal state, numeric summary, artifact references and
qualification.

## Lifecycle

The inventory adapter remains a pure planner. Its initial jobs supply the article
assignments. `Write-InventoryExperiment` freezes those assignments, worker inputs,
worker/module hashes, engine specification and execution policy. The caller then
plans the same jobs with the experiment SHA-256. `RunContext` passes the exact
assignment and plan reference to each worker; an unpinned planning preview is not
an executable assignment.

The job id remains stable across runs. The attempt id is a full SHA-256 of the run
address and job id. A retry therefore needs a new run directory. Planning creates
no directories and does not read engine runtimes.

The worker loads the module named in `RunContext.recordsModule`, calls
`Get-PaperRunAssignment`, checks its engine-specific parameters, and publishes
through `Write-PaperRun`. Writes use a per-record exclusive lock and an atomic
same-directory rename. A `running` checkpoint may be replaced by the same
attempt; terminal `complete` or `failed` records cannot be overwritten. The
coordinator never writes a worker record. Absent and nonterminal records remain
such after aggregation. Lock files are publication machinery, not evidence.

Artifacts use attempt-relative paths, byte lengths and SHA-256. Absolute paths,
parent traversal, reparse redirects, duplicate artifacts and self-hashing records
are rejected. Workers alone publish terminal artifact hashes; the aggregate pins
the terminal worker record, avoiding a self-hash cycle.

## Aggregation and qualification

`Write-InventoryBatch` joins results by job identity, retains every planned attempt,
and accounts for complete, failed, missing, nonterminal, invalid and unexpected
records. It verifies identities and artifact hashes, preserves numeric fractions,
and records executor disagreement or incomplete cleanup. It does not parse XML or
reconstruct missing worker findings. The raw executor result remains in
`executor-execution.json`.

Execution completion and comparison qualification are separate. An acquisition
without a requested comparison has `not-requested` qualification. With
`requireQualification: true`, every required worker verdict must pass. Missing,
failed or invalid execution cannot qualify. A successful process exit alone does
not establish either record validity or semantic equivalence.

`Read-InventoryBatch` validates the immutable plan and worker/artifact references
before returning a `Papers` collection. It exposes incomplete coverage in the batch
record; consumers must apply their own coverage policy and cannot treat available
papers as the whole population.

Historical `inventory-run/0.1` and receipt files are not rewritten or auto-detected.
Engine-owned historical readers must be selected explicitly and pin their original
inputs. New acquisitions emit neither an authoritative root `run.json` nor
`receipt.json` or `inventory-summary.jsonl`.

## Verification

Run through `tests/batch.ps1`:

```powershell
./tests/batch.ps1 -Framework Pester -PesterPath tests/inventory-records/records.Tests.ps1 -MaxWorkers 1
./tests/batch.ps1 -Framework Pester -PesterPath tests/batch-adapters/inventory-batch.Tests.ps1 -MaxWorkers 1
```

`tests/inventory-records/latexai.Tests.ps1` is an optional real-engine integration
test. Set `LATEXAI_ROOT` to a prepared checkout and supply its normal `PERL_ROOT`.
It exercises single-condition acquisition and record readers, not G1's complete
off/on worker experiment or real-paper failure checkpoint.
