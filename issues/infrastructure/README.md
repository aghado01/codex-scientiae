# Infrastructure issue canon

This issue is the planning umbrella for shared runtime infrastructure and repository-wide conventions that
grew out of the Fable logger review. Logging remains one workstream, but the active design now also covers
run/artifact addressing, strict JSON/JSONL I/O, indexes, managed stores, compatibility and migration, and the
boundary between file-local primitives and application lifecycle automation.

The umbrella does not make every design witness a shared module. Ingestion deposits, LaTeX conversion stores,
inventory catalogs, rector-codicis ledgers, and batch execution contribute requirements while retaining their
own application policy and focused issues.

## Canon map

| Document area | Authority and purpose |
|---|---|
| [`planning/architecture.md`](planning/architecture.md) | Current system shape, layer boundaries, implementation map, and dependency direction. |
| [`planning/decisions.md`](planning/decisions.md) | Normative accepted/provisional decisions. Superseded decisions remain named and point to replacements. |
| [`planning/open-questions.md`](planning/open-questions.md) | Undecided choices, known residue, risks, and the evidence needed to close them. |
| [`planning/roadmap.md`](planning/roadmap.md) | Ahead-only work with stable item IDs and exit gates. |
| `planning/ledger.md` | Completed roadmap work. Create it when the first item actually closes. |
| [`discussions/`](discussions/) | Historical conversations, surveys, and design witnesses. Evidence, not current authority. |
| [`briefs/`](briefs/) | Bounded session handoffs and implementation briefs derived from the canon. |

When documents disagree, decisions govern architecture, architecture governs briefs, and the roadmap governs
sequencing. Discussions explain why but do not override the current canon.

## Current workstreams

1. **Run and artifact topology** — caller-owned run identity, runstamped placement, stable source versus
   regenerable run evidence, joining child processes, and cross-file generation coherence.
2. **Structured logging** — one logical end-to-end run log, application-bound defaults, clean stdout,
   observable non-fatal degradation, and concurrency through the shared JSONL boundary.
3. **JSONL primitives** — Unicode-scalar-safe serialization/parsing, strict UTF-8/LF files, explicit mutation,
   cooperating concurrency, atomic whole-file publication, structural `.jidx` indexes, queries, slices, and
   snapshots.
4. **Managed stores** — caller-bound identity/schema/order/mutation policy and lifecycle automation that keeps
   required derivatives current or explicitly stale.
5. **Compatibility and migration** — isolated shims, caller/artifact censuses, bounded integration tranches,
   and explicit sunset conditions.
6. **Application pressure tests** — source deposits and hierarchical inventories, run ledgers, federated
   agent exchanges, and LaTeX artifact families used to test generality without canonizing their schemas.

## Scope boundary

This canon owns shared contracts and the seams between layers. It does not own:

- LaTeX-to-Markdown transformation semantics or individual artifact schemas;
- the final document-manifest or inventory-row schema merely because those use JSON/JSONL;
- procurement/provider policy;
- agent governance or dispatch protocol records;
- batch scheduling semantics tracked by a separate focused issue; or
- every historical helper currently co-located in `src/shared`.

Code location is evidence, not authority. A helper is shared only after its contract is intentionally
generalized and its application assumptions are removed.

## Current state

- `src/shared/log.ps1` is a tested prototype whose direct JSON conversion, append behavior, fallback path
  minting, and per-process sidecar behavior do not yet satisfy the accepted logger contract.
- `src/shared/jsonl-v2.ps1`, `jsonl-store-v2.ps1`, and `jsonl-v2-compat.ps1` are unintegrated replacement
  drafts with unversioned public symbols. Production still uses older or local machinery.
- `src/shared/jsonl.ps1` combines reusable JSONL operations with staging, ledger, inventory, and retired
  workflow assumptions. Its former publication caller has been removed; the stage writer now has only
  test consumers, and the ledger/inventory helpers have no production consumers.
- `src/shared/runs.ps1` contains the current `artifacts/{module}/runs/{runstamp}/{slug}` convention beside
  older paper-local `.runs` discovery and addressing machinery. It is a migration surface, not a finished
  run-context abstraction.
- Commit `05419f3` provides a validated, manifest-backed LaTeX source-deposit consumer and an explicit legacy
  compatibility boundary. The schema and corpus migration remain provisional.

## Editing discipline

- Put decisions in `decisions.md`, not in a brief or transcript.
- Put unresolved choices and their closure evidence in `open-questions.md`.
- Keep completed work out of the ahead-only roadmap; move it to the future ledger.
- Give compatibility behavior an owner, observed caller/artifact population, and removal condition.
- Prefer relative repository links. Historical discussions may retain old `issues/loggers` path text as part
  of the record of the rename.
- Avoid volatile status claims without a date, commit, test witness, or explicit provisional label.
