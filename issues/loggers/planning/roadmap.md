# Shared logging and JSONL — roadmap (ahead only)

Living plan for work not yet complete. The current architecture contract is
[decisions.md](decisions.md); evidence and design history live under
[../discussions/](../discussions/). When the first roadmap item closes, create `ledger.md` and move the
completed item there with its closure date, decisions affected, tests, migration evidence, and links. Do not
leave completed work in this file.

## Current baseline — 2026-08-04

The initial Fable logger exists at `src/shared/log.ps1`. Unintegrated replacement drafts exist at
`src/shared/jsonl-v2.ps1`, `src/shared/jsonl-v2-compat.ps1`, and `src/shared/jsonl-store-v2.ps1`; their
public commands are intentionally unversioned. The complete shared Pester suite currently passes 106 tests.

This is a vetting baseline, not a production-integration claim. Existing callers still use the old shared
JSONL implementation or local logic, and the logger still reflects parts of its prototype behavior. No
production module should import a `-v2` draft until the audit and integration gates below close.

## Sequencing rules

1. Freeze semantics before optimizing them.
2. Audit related operational flows together; extract primitives without preserving accidental file
   boundaries.
3. Pilot one application wrapper before migrating broad call sites.
4. Keep compatibility imports explicit and measure their remaining callers/artifacts.
5. Integrate the replacement and remove the temporary filename suffix only after production callers and
   rollback boundaries are known.

## Phase 1 — Operational audit and contract closure

- **LOGJ-101 — Audit the four related operational units.** Trace `jsonl-stage.ps1`, `run-ledger.ps1`,
  `runs.ps1`, and `log.ps1` as one flow: callers, state ownership, artifact paths, append/rewrite behavior,
  duplicated parsing, hidden compatibility assumptions, and recovery behavior. Produce a disposition map:
  primitive to extract, domain policy to retain, compatibility shim, or dead use-case logic to retire.
- **LOGJ-102 — Diff against current jso-jackson and its export children.** Inventory reusable read, write,
  seek, slice, query, repair, and diagnostic capabilities in `D:/aghado01/utils/jso-jackson`,
  `claude-export`, and `codex-export`. That tree is the implementation authority; do not spend audit effort
  rediscovering its older vendored snapshots. Lift only missing primitives whose semantics agree with the
  new codec; do not duplicate a toolbelt or RPC/CLI surface inside the shared PowerShell core.
- **LOGJ-103 — Close the error and result vocabulary.** Name malformed record, invalid UTF-8, incomplete
  tail, contention, stale/invalid index, duplicate key, schema rejection, committed-content/index-refresh
  failure, and degraded logger sink outcomes. Decide which commands throw, which return diagnostics, and
  which application wrappers may downgrade failures.
- **LOGJ-104 — Review the public command surface.** Check naming, parameter sets, pipeline behavior,
  null/array preservation, metadata envelopes, help, and composability before any caller starts depending on
  the draft signatures.
- **LOGJ-105 — Use rector-codicis as a conceptual pressure test.** Model its federal, multi-writer
  primary/para exchange ledger as a prospective store kind without importing its older jso-jackson copy.
  Identify requirements for append-only history, causal/per-writer order, typed protocol records, strict
  ledger failure posture, bounded query returns, and runstamped cross-file job lifecycle. Evidence:
  [rector-codicis conceptual witness](../discussions/rector-codicis-jsonl-conceptual-witness-20260804.md).

Exit gate: the disposition map and command/error contracts are recorded in planning; no unresolved overlap
requires production callers to know which generation owns a primitive.

## Phase 2 — Harden and vet the JSONL substrate

- **LOGJ-201 — Expand concurrency and fault-injection coverage.** Exercise multiple processes, long-held raw
  handles, abandoned mutexes, timeout/retry behavior, reader/writer overlap, replacement races, and index
  creation concurrent with mutation. Verify that a failed operation never reports silent success.
- **LOGJ-202 — Establish crash and durability expectations.** Test incomplete append tails, temporary-file
  cleanup, durable flush behavior, process termination at mutation boundaries, and restart inspection. State
  what is guaranteed for content and what is only detectable/rebuildable for indexes.
- **LOGJ-203 — Establish scale thresholds.** Benchmark append, complete rewrite, index construction, random
  fetch, scans, policy merge, and sort across representative log and catalog sizes. Use the results to choose
  when streaming merge or external sort becomes required.
- **LOGJ-204 — Complete lifecycle inspection and repair APIs.** Specify non-mutating validation versus
  explicit repair/rebuild operations for incomplete tails, stale/invalid indexes, canonical ordering,
  duplicate keys, and schema failures. Repair never hides discarded or rewritten data.
- **LOGJ-205 — Decide secondary-index scope.** Preserve the current exact-query semantics. Add secondary key
  indexes, record-hash vectors, or Bloom filters only for witnessed workloads, with explicit source identity,
  freshness, and rebuild rules; avoid a sidecar per casual query.

Exit gate: stress/fault tests and benchmarks support the concurrency and durability claims in decisions;
the core/store drafts have stable help and failure contracts.

## Phase 3 — Rework the logger over the hardened primitives

- **LOGJ-301 — Define the application-wrapper/decorator pattern.** Provide a PowerShell-appropriate wrapper
  recipe that binds module name, run directory/path, component defaults, levels, and fallback policy from the
  application's own parameters while leaving per-event calls small.
- **LOGJ-302 — Reconcile run identity and logger lifecycle.** Make `runs.ps1` or its successor the source of
  runstamp/run-directory truth. Starting or joining logging must consume an existing run identity when one is
  present and must not mint a parallel artifact tree.
- **LOGJ-303 — Replace prototype append mechanics.** Route log records through the central JSONL codec and
  cooperating concurrency boundary. Preserve UTF-8/LF/codepoint guarantees and one logical append-only log
  per selected run scope.
- **LOGJ-304 — Make degradation observable and non-fatal.** Define the ordered fallback behavior, stderr
  message, returned status, and summary fields for a failed primary sink. Test unwritable paths, contention,
  serialization failure, and fallback failure without corrupting stdout or defeating the application run.
- **LOGJ-305 — Finalize log schema and correlation.** Decide run id, process id, task/worker id, event id,
  sequence/ordering semantics, exception representation, and schema versioning without making every record
  carry redundant run metadata.
- **LOGJ-306 — Pilot one real application.** Select a workflow that already creates runstamped artifacts,
  bind its defaults in a thin wrapper, and verify end-to-end path choice, child/cooperating writers, fallback,
  and run summary before migrating other modules.

Exit gate: the pilot produces one correctly placed run log, logger failure is visibly non-fatal, stdout stays
clean, and no caller needs to reconstruct generic path or level policy.

## Phase 4 — Complete managed-store policy and schema support

- **LOGJ-401 — Select and pin JSON Schema validation.** Choose the dialect and runtime, record dependency
  provenance, and make schema validation cross the same Unicode-safe parse boundary. A configured schema
  may never be silently skipped.
- **LOGJ-402 — Add policy-aware inspection/completion.** Validate an existing store's record schema, key
  uniqueness, canonical order, and index state without mutation; provide separately named repair operations.
- **LOGJ-403 — Carry policy through destructive maintenance.** Decide how remove, subtract, replace, and
  resort bind store policy, recompute derived row/store attributes, and refresh indexes in one visible
  transaction.
- **LOGJ-404 — Define store-level derived metadata.** Identify which counts, digests, summaries, or internal
  attributes are authoritative versus derived. Prefer data in the store or a necessary existing index over a
  new metadata sidecar; if another derivative is justified, give it explicit freshness semantics.
- **LOGJ-405 — Add streaming merge/external sort when benchmarks demand it.** Retain the current atomic
  rewrite as the reference behavior. An ordered append fast path is valid only when incoming keys are unique,
  canonically sorted, and strictly after the current final key.
- **LOGJ-406 — Generalize policy beyond materialized catalogs.** Pressure-test the policy contract against
  four different kinds: best-effort run log, operational run ledger, federated append-only agent exchange
  ledger, and canonically sorted inventory catalog. Decide how policy declares mutation model, physical versus
  semantic order, replacement legality, failure posture, and derived compact/current-state projections.

Exit gate: a store kind can bind a real schema and policy across create, inspect, add, remove, sort, complete,
and repair, with every derivative current or explicitly reported stale.

## Phase 5 — Source manifests and hierarchical inventory catalogs

- **LOGJ-501 — Specify the authoritative leaf source manifest.** Set filename, schema version, logical
  document identity, title/provider identifiers, acquisition history, and artifact entries for PDF, archive,
  extracted source tree, supplements, checksums, timestamps, origin, and derivation.
- **LOGJ-502 — Reconcile provider sidecars.** Define how existing `*.arxiv.json` acquisition data migrates or
  contributes to the source manifest. Malformed prior data must surface as a repair item rather than being
  silently ignored.
- **LOGJ-503 — Specify the inventory catalog row.** Freeze the scoped-parent key field, logical-versus-location
  identity, manifest reference/snapshot fields, recursive scope/depth representation, and canonical order in
  a JSON Schema.
- **LOGJ-504 — Build a reviewable manifest bootstrapper.** Discover likely existing document leaves, separate
  primary assets from figures/extracted/converter outputs, and emit a plan or diagnostics before writing any
  manifest. Ambiguity requires review.
- **LOGJ-505 — Build deterministic catalog materialization.** Generate stores for declared directory scopes
  bottom-up or top-down, with the same inputs yielding byte-identical rows and indexes. Incremental updates
  must add, replace, remove, and resort through managed-store transactions.
- **LOGJ-506 — Add reconciliation and move handling.** Detect missing manifests/assets, checksum changes,
  moved parent paths, duplicate logical identities, case collisions, and stale higher-level catalogs without
  silently rewriting identity history.

Exit gate: a representative ingestion subtree has valid leaf manifests and deterministic catalogs at more
than one hierarchy level; top-down and bottom-up builds converge.

## Phase 6 — Integrate, migrate, and sunset

- **LOGJ-601 — Build the compatibility census.** Enumerate production imports, commands, legacy index names,
  and stored artifacts that require `jsonl-v2-compat.ps1`. Every shim gets an owner, migration path, and
  removal condition.
- **LOGJ-602 — Migrate operational consumers in bounded tranches.** Move logger/run plumbing, run ledger,
  staging, and store/catalog consumers separately, with a focused rollback point and tests for each tranche.
- **LOGJ-603 — Replace the shared implementation.** Once the public surface and migrations are vetted, retire
  the old `jsonl.ps1`, rename the draft file into its production name, and update imports atomically. Do not
  expose versioned function names during or after the transition.
- **LOGJ-604 — Sunset compatibility.** Remove legacy index discovery and other shims only after the census is
  empty and retained artifacts are migrated or deliberately archived.
- **LOGJ-605 — Migrate remaining logger call sites.** Replace duplicated MCP/application stderr helpers only
  through application wrappers with appropriate defaults; verify that every migrated workflow preserves its
  protocol/data output and run-artifact convention.

Exit gate: production imports one canonical JSONL implementation, compatibility has a zero-caller witness or
an explicit retained-artifact exception, and logger/store consumers use application-bound policies.

## Future ledger contract

When `ledger.md` is introduced, each closure entry should carry:

- the stable `LOGJ-nnn` roadmap id and closure date;
- the decision records added, amended, or superseded;
- implementation and test witnesses;
- production integrations or artifact migrations performed;
- known residue intentionally returned to this roadmap.
