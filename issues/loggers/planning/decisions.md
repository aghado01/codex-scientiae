# Shared logging and JSONL — architecture decisions

Living architecture canon for the shared logger, JSONL substrate, managed JSONL stores, and the
application boundaries around them. Correct this document when the current design changes; preserve a
superseded decision by naming its replacement rather than leaving two apparently active rules.

The originating evidence is the
[Fable logger implementation discussion](../discussions/fable-logger-initial-implementation-20260803.md).
The [rector-codicis conceptual witness](../discussions/rector-codicis-jsonl-conceptual-witness-20260804.md)
pressure-tests the shared design with a federal, multi-writer primary/para-agent exchange ledger; the current
implementation authority remains `D:\aghado01\utils\jso-jackson`. Work still ahead lives in
[roadmap.md](roadmap.md). A completion ledger will be added when roadmap items begin closing.

Status vocabulary: **accepted** is the working contract; **provisional** is implemented or strongly shaped
but remains subject to vetting before production integration.

## Logger boundary

### D1 — JSONL is the durable run-log representation — accepted

The shared logger writes structured JSONL records rather than an unstructured transcript. The minimal
prototype record is `{ts, el, lvl, comp, msg, data?}`: wall-clock time, elapsed run time, level, component,
message, and optional structured data. Future additions must remain additive or explicitly schema-versioned.

### D2 — Applications own logger defaults — accepted

The generic logger does not decide a universal artifact layout. Each application or tool wraps/configures
the logger with defaults appropriate to its workflow. Those defaults may be bound from the application's
own parameters so ordinary call sites inherit the run directory, module/component, filename, and levels
without restating them.

### D3 — Run identity and artifact placement come from the caller — accepted

The repository convention is a runstamped directory under an application-specific `artifacts/...` path.
The caller that defines the run also defines the runstamp and run directory. The logger consumes that
identity; it must not mint a competing run convention behind the application's back.

### D4 — One logical log per selected run scope — accepted

The default is one append-only log for the intended end-to-end run scope. Per-process log proliferation is
not the normal concurrency strategy. If an application genuinely defines several run scopes or logs, that
cardinality is explicit application policy rather than a fallback side effect.

### D5 — Logging observes a run and must not defeat it — accepted

Logging failures are non-fatal by default. A fallback or degraded sink must be visible through stderr and/or
returned status; it may not silently discard records or silently switch paths. Applications may opt into a
stricter policy when audit guarantees are part of their own contract.

### D6 — Stdout is not a logging sink — accepted

Stdout is reserved for pipeline values and protocols such as MCP transport. Console mirroring uses stderr,
with an application-bound threshold, so logging cannot corrupt a caller's data channel.

### D7 — Timed scopes preserve program semantics — accepted

Instrumentation may measure and report success or failure, but it passes successful values through and
rethrows failures. The logger does not swallow, translate, or otherwise take ownership of application
exceptions.

## JSONL primitive boundary

### D8 — All JSONL parsing and serialization crosses one Unicode-scalar gate — accepted

Callers should not invoke `JsonDocument.Parse` or `ConvertFrom-Json` directly for JSONL records. Shared
conversion validates every JSON string and property name first, including escaped surrogate sequences, so
the .NET and PowerShell parsers cannot disagree by accepting or replacing a lone surrogate differently.

### D9 — Canonical files are UTF-8 without BOM and LF terminated — accepted

Every complete physical record ends in LF. Literal CR/LF inside serialized record text is refused. Strict
UTF-8 decoding, no BOM, and the terminal-LF invariant make byte offsets, snapshots, appends, and recovery
semantics deterministic across the supported environment.

### D10 — Concurrency uses a cooperating mutation lease, not lock sidecars — provisional

Mutations coordinate with a path-derived cross-process named mutex and restrictive file sharing. Stable
readers refuse an active writer. The design avoids persistent lock files and allows a logical transaction to
span replacement of the destination file. This mechanism must pass broader contention, abandonment, and
fault-injection testing before production adoption.

### D11 — Mutation modes are explicit; silent overwrite is forbidden — accepted

Whole-file creation fails when the destination exists unless replacement is requested explicitly. Append,
replace, truncate/initialize, snapshot, and resume behaviors are distinct named operations. A batch is
serialized and validated before the first byte of an append transaction is exposed.

### D12 — Atomic publication is the whole-file rewrite primitive — accepted

Maintenance operations write and validate a sibling temporary file, then publish it by replacement while
holding the mutation lease. Unchanged rows may retain their exact serialized text. This is the correctness
baseline for subtracting, removing, replacing, and canonically resorting a store.

### D13 — A `.jidx` is a structural seek index — accepted

The indexer records byte offsets of complete LF-terminated physical rows. It does not validate JSON or
UTF-8; those are codec/validation responsibilities. An incomplete final row is outside the index. Source
length and last-write identity make stale indexes detectable.

### D14 — Canonical index naming removes the intermediate extension — accepted

`{name}.jsonl` is indexed by `{name}.jidx`, not `{name}.jsonl.jidx`. An index is a rebuildable derivative,
not another authoritative store.

### D15 — Content and index publication cannot masquerade as one atomic commit — accepted

After a content mutation, an existing index is rebuilt reflexively, or `-BuildIndex` establishes one. If
content publication succeeds and index publication fails, the operation reports a committed-content/
failed-derived-refresh error; the old index remains detectably stale. The implementation must never report
that situation as a clean rollback.

### D16 — Query semantics precede query acceleration — accepted

Ranges, indexed record fetch, JSON Pointer projection, exact key/value lookup, condition sets, and head/tail
operations have stable semantic APIs independent of their execution strategy. Exact lookup may scan today;
a future secondary index can accelerate it without changing callers.

## Layering and compatibility

### D17 — JSONL codec, managed stores, and application schemas are separate layers — accepted

The generic JSONL file/record/index primitives belong in `jsonl-v2.ps1`. Named store lifecycle and
maintenance transactions belong in `jsonl-store-v2.ps1`. Logger policy, run ledgers, staging logistics,
source manifests, and hierarchical catalogs remain application or domain layers over those primitives.
Inspection, comparison, profiling, sampling, and bounded-preview workflows form a toolbelt layer over the
core; their convenience does not justify bypassing the shared codec.

### D18 — Temporary versioning belongs to filenames, not public symbols — accepted

The `-v2` suffix quarantines an unintegrated replacement while it is vetted. Public functions and classes
are unversioned because the file is intended to replace the old implementation. Production must not import
both generations into the same session.

### D19 — Compatibility code is isolated and sunsettable — accepted

Legacy discovery and format shims live in `jsonl-v2-compat.ps1`, not in the core implementation. The core
does not learn legacy names such as `{name}.jsonl.jidx`. Compatibility remains removable once callers and
artifacts have migrated.

### D20 — Existing operational units are evidence, not automatic boundaries — accepted

`jsonl-stage.ps1`, `run-ledger.ps1`, and `runs.ps1` participate in overlapping operational flows and must be
audited together. Reusable primitives and organization should be extracted; defunct membrane use-case logic
and application-specific logistics should not be reproduced in the shared substrate merely because they
currently coexist in a file.

## Managed stores and inventory

### D21 — Store-kind policy is caller-bound, not another sidecar — provisional

A managed store policy names its kind, key selection, key comparison and uniqueness, canonical ordering,
and optional schema validator. Applications bind the appropriate policy on create, add, and maintenance
operations. The policy is not persisted as another per-run or per-store metadata sidecar.

### D22 — Store mutations maintain declared derivatives reflexively — provisional

Policy-aware create validates, rejects duplicate keys, canonically sorts, publishes once, and refreshes the
index once. Policy-aware add validates existing and incoming rows, applies an explicit duplicate action
(`Stop`, `KeepExisting`, or `Replace`), sorts and publishes once, and refreshes once. Correctness currently
takes priority over an append-only optimization.

### D23 — Every store kind defines identity, schema, and canonical order — accepted

JSONL syntax alone does not make a managed store. Each kind must state its key and comparison semantics,
row schema, uniqueness requirements, canonical order, and which attributes or indexes are derived. Generic
operations must not guess those invariants. “Canonical order” may be physical append/arrival order for a
journal, causal order expressed in record fields, or a deterministic key sort for a materialized catalog.

### D24 — Inventory identity is a scoped document-parent path — provisional

For the proposed inventory store, the key is the forward-slash relative path from the catalog scope root to
the logical document's parent directory. `.` denotes the scope root. Rooted paths, backslashes, empty or
embedded `.`/`..` segments, control characters, and non-NFC strings are refused. Uniqueness is
case-insensitive to expose Windows/path-portability collisions; preserved path spelling sorts ordinally.

This implies one logical document per parent directory. Two unwrapped documents under one parent collide
and require layout normalization or a deliberately different identity rule.

### D25 — Catalogs are materialized views of explicit leaf manifests — provisional

Hierarchical catalog automation should consume authoritative document manifests and produce deterministic
stores for a declared directory scope/depth. It must not recursively infer documents from arbitrary PDFs,
archives, or extracted-source trees: those trees contain figures and converter outputs that resemble source
assets. Filesystem inference belongs in a reviewable bootstrap/migration tool.

### D26 — Logs, ledgers, journals, snapshots, and materialized views are distinct store kinds — accepted

Sharing JSONL primitives does not give these units one mutation or failure policy. An observational run log
is normally append-only and best-effort with visible degradation; an operational run ledger or federated
agent exchange journal may be authoritative and preserve append history; an inventory catalog is a
canonically sorted materialized view that permits validated rewrite. Application policy names the difference.

## Open architecture questions

- Final logger record schema, run-correlation fields, and cross-process ordering expectations.
- Exact application fallback ladders and the returned status/diagnostic contract for degraded logging.
- JSON Schema dialect and PowerShell/.NET validation runtime.
- Inventory key field name and the split between location identity and stable logical-document identity.
- Leaf source-manifest schema, filename, provenance, artifact, checksum, and derivation representation.
- Direct versus recursive catalog scope/depth semantics and byte-for-byte top-down/bottom-up convergence.
- Store-level derived counts/digests and how they join the same maintenance transaction.
- Whether mutation model becomes an explicit store-policy field (`AppendOnly`, `Materialized`, `Snapshot`,
  or append history plus derived current-state projection), and how physical versus causal order is exposed.
- Scaling thresholds for streaming merge, external sort, and secondary indexes.
