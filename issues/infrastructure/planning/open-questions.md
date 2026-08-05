# Shared infrastructure — open questions and residue

This document holds matters that are not yet architecture decisions. A question closes only when its answer
is recorded in [decisions.md](decisions.md) and any implementation consequence is represented in the
[roadmap](roadmap.md). Concrete defects stay here until assigned to a roadmap item or proven absent.

## Priority decision queue

### Q1 — What is the canonical run context?

Decide the minimum identity and address object shared by run allocation, logger wrappers, child processes,
artifact-set publication, and newest/pinned readers. Candidate fields include workflow/module, run id or
runstamp, scope key/slug, run root, resolved run directory, parent run, correlation id, and creation time.

Closure evidence: two unlike applications can allocate or join a run without reconstructing each other's
path convention, and same-second/multi-process allocation is race-safe.

### Q2 — How are physical and semantic order represented?

A mutex supplies arrival serialization, not causal order. Decide which store kinds preserve physical append
order as evidence and which records require writer sequence, event id, parent/reference, round, or logical
clock fields. Do not impose the exchange-ledger schema on ordinary logs.

Closure evidence: logger, operational ledger, federated journal, and sorted catalog policies can each state
their order without special cases in the codec.

### Q3 — What is the JSONL error and result vocabulary?

Close named outcomes for invalid Unicode scalar, malformed JSON, invalid UTF-8, BOM, embedded newline,
incomplete tail, contention/timeout, stale or corrupt index, duplicate key, schema rejection, committed
content with failed derivative refresh, and degraded logger sink. Decide which primitives throw and which
orchestrators return a structured status.

Closure evidence: public commands and tests use one vocabulary and callers never parse exception prose to
distinguish committed from uncommitted state.

### Q4 — What durability is promised?

Choose flush-to-OS versus flush-to-disk defaults for append and whole-file publication, temporary-file cleanup
expectations, incomplete-tail recovery, abandoned mutex behavior, and the supported semantics on local,
network, or unusual filesystems.

Closure evidence: fault-injection tests state exactly what survives termination and what remains merely
detectable or rebuildable.

### Q5 — What completes a managed-store policy?

Decide whether mutation model and failure posture are explicit policy properties alongside key, uniqueness,
schema, and sort. Define append-only journal, materialized view, immutable snapshot, and append-history plus
projection behaviors without creating a universal mega-policy every caller must populate.

Closure evidence: the four witness store kinds bind policies without bypassing shared lifecycle operations.

### Q6 — Which JSON Schema runtime is authoritative?

Select dialect and implementation for PowerShell/.NET, pin dependency provenance, and define how schema
validation crosses the Unicode-safe parse boundary. A configured schema must never be silently skipped.

Closure evidence: a schema-valid and schema-invalid record behave identically across direct validation,
create, append/add, inspect, and repair paths.

### Q7 — How is a cross-file generation represented and published?

Define generation identity, dependency hashes, member roles, private build, validation, publication states,
partial failure, recovery, and stable-current selection for application bundles. Decide when an existing run
manifest/report is enough and when a stable materialization pointer is required.

Closure evidence: one real artifact DAG can detect a stale derived member without relying on timestamps or a
sidecar beside every file.

### Q8 — What is the finalized document/inventory identity model?

Set the `metadata.json` schema beyond `document-metadata/0.1`, field-level provenance/conflict rules,
logical identity versus location identity, scoped path key name, move/alias history, recursive depth, and
byte-identical top-down/bottom-up catalog behavior.

Closure evidence: representative deposits with archive, extracted source, PDF, provider evidence, and moves
produce validated deterministic leaf manifests and parent catalogs.

### Q9 — When are scale-oriented features justified?

Measure thresholds for complete rewrite, streaming merge, external sort, random fetch, secondary indexes,
record-hash vectors, and Bloom filters. Avoid persistent derivatives for small stores without a witnessed
consumer.

Closure evidence: benchmark results select a threshold and preserve the reference semantics below and above
it.

## Known engineering residue

| Residue | Current evidence | Roadmap owner |
|---|---|---|
| Logger writes with `ConvertTo-Json`, reads with `ConvertFrom-Json`, and bypasses the scalar-safe codec | `src/shared/log.ps1` | LOGJ-303 |
| Logger may mint its own artifact convention and proliferate per-process trace files | `Start-RunLog` sink ladder | LOGJ-301, LOGJ-302 |
| Logger sink failures can defeat a run and lack a structured degraded result | direct append in `Write-RunLog` | LOGJ-304 |
| Module run allocation uses check-then-create and can race | `New-ModuleRunDir`/`New-RunDir` | LOGJ-101, LOGJ-302 |
| `runs.ps1` mixes current artifact-tier allocation with retired paper-local discovery and compatibility | `src/shared/runs.ps1` | LOGJ-101, LOGJ-601 |
| Legacy JSONL combines stage publication, indexing, ledger, inventory, and workflow assumptions | `src/shared/jsonl.ps1` | LOGJ-101, LOGJ-102 |
| At least one production caller still consumes the legacy ledger helper | `src/bibliotecha/publish.ps1` | LOGJ-601, LOGJ-602 |
| The `-v2` drafts have no production consumers and their public contract is not frozen | caller census and focused tests | LOGJ-103, LOGJ-104 |
| Named-mutex concurrency and index refresh need multi-process/fault testing | provisional D10, D15 | LOGJ-201, LOGJ-202 |
| Retained LaTeX JSONL artifacts use CRLF and production emission still bypasses the strict codec | artifact survey | LOGJ-204, LOGJ-601 |
| Multi-file artifact generations lack one coherence record/state machine | latex-ingest survey | LOGJ-407 |
| Source manifest/schema and hierarchical catalog contracts remain provisional | `document-metadata/0.1` and convention | LOGJ-501–LOGJ-509 |

## Compatibility questions

- Which retained `{name}.jsonl.jidx` artifacts actually need temporary discovery, rather than explicit
  rebuild into `{name}.jidx`?
- Which old paper-local `.runs` readers are live, archival, or dead?
- Should a legacy caller receive a wrapper with the old signature, or be migrated at its import boundary?
- Which CRLF JSONL artifacts are authoritative history, regenerable output, or disposable experiments?
- What objective zero-caller/zero-artifact witness permits each shim to be removed?

## Deferred, not forgotten

- General semantic comparison and schema/discriminator census in the JSONL toolbelt.
- Workload-backed secondary indexes and bounded query planners.
- Stable-current projections over append history.
- Cross-repository packaging of shared infrastructure after local contracts stop moving.
- Whether PowerShell script files remain the final packaging boundary or become modules after namespace and
  import behavior are deliberately designed.
