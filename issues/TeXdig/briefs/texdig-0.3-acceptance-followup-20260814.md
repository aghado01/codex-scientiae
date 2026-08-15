# TeXdig 0.3 acceptance follow-up

Date: 2026-08-14

Baseline: `main@bef9bcc`

Scope: close `texdig-census/0.3` acceptance gaps before C-wave elaboration or downstream stores.

## Handoff verdict

The B wave is landed, not merely present in a working tree. Commit `573e050` contains the B0
contract lock, B1 occurrence traversal, B2 chronological binding interpreter, B3 site-time
invocation attachment, and atomic nine-store publication. Commits `7816325` and `bef9bcc` then
settled the ISO runstamp convention and minted the current
[decision canon](../planning/decisions.md), [roadmap](../planning/roadmap.md), and
[ledger](../planning/ledger.md).

The implementation is well tested but is not an accepted 0.3 release candidate. Two defects can
still make published evidence semantically false:

1. configured parser-support metadata is treated as an install manifest; and
2. coverage can credit invalid claims and the emitter does not recompute coverage from claims.

The next session should close the 0.3 acceptance list. It should not begin expansion, macros,
pointers, zones, walk, references, frontmatter, or graph work.

## Corrections to the prior thread status

- The B implementation is committed at `573e050`; the earlier description of an uncommitted
  `8aa259a` worktree is historical.
- Runstamps are ruled `YYYYMMDD_HHmmss[_NN]` in T13. Code and documentation now agree. The
  retained `20261308_*` evidence directories are mis-stamped historical artifacts; cleanup is an
  owner task, not part of acceptance remediation.
- The untracked `issues/TeXdig/discussion/sol-texdig-b-wave-report.md` still contains the stale
  uncommitted-worktree and `YYYYDDMM` account. Do not commit it as written. The decision canon
  currently names it as supporting evidence, so the link should be replaced with this brief or the
  report should be corrected deliberately.
- At brief creation the unrelated `.gitignore` change adding `.para-agent` was present. Preserve it
  and use explicit path allowlists for all TeXdig staging.

## Landed B-wave surface

The 0.3 bundle emits exactly:

1. `sources.jsonl`
2. `entities.jsonl`
3. `occurrences.jsonl`
4. `bindings.jsonl`
5. `invocations.jsonl`
6. `claims.jsonl`
7. `coverage.json`
8. `diagnostics.jsonl`
9. `summary.json`

The execution tier supplies route-derived repeated/cyclic occurrences, explicit scope and summon
rows, chronological binding events, conservative dispositions, immutable `\let` capture, and raw
UTF-16 argument attachment. Expansion and the eight downstream contract stores remain explicitly
deferred. T7–T14 are the baseline contracts and should not be reopened incidentally during the
acceptance work.

## Retained verification evidence

- [Final public batch](../../../artifacts/test-runs/20261308_020931_texdig-b-wave-final-broad):
  211/211 tests across 14 Pester/pytest containers.
- [Mini determinism run](../../../artifacts/test-runs/20261308_021108_texdig-b-wave-final-determinism):
  all nine stores byte-identical across two runs; 653 rows schema-valid.
- [Bounded three-document gauntlet](../../../artifacts/test-runs/20261308_021153_texdig-b-wave-final-gauntlet):
  77,572 schema-valid rows and zero defect diagnostics.

These runs prove substantial implementation coverage, not release readiness. All three gauntlet
documents materialized one source occurrence, so they did not exercise real multi-file occurrence
replay or cross-file scope continuation. The determinism directory also contains only the two
bundles, not a deposited digest comparison record.

## Acceptance close-list

### 1. Configured and baseline authority — P1, T15

[configured.ts](../../../src/TeXdig/census/configured.ts) interprets every pinned unified-latex CTAN
parser record as a declaration installed by the summoned package. The configured chronology is
correct, but the evidence source does not establish provider operations.

The retained gauntlet exposes eight false or suspect precondition outcomes:

- four document `\newtheorem` declarations are rejected because `mathtools` parser metadata first
  “installs” `theorem`, `lemma`, `proposition`, and `definition`; and
- renewals of `\top`, `\epsilon`, and two `\arraystretch` sites are rejected because the pinned
  `latex2e` baseline omits their governing names.

Recommended contract:

- CTAN package records remain provider-qualified signature evidence but do not veto physical
  document declaration preconditions unless an authoritative install operation is available.
- Kernel/plain-TeX presence comes from a pinned, provenance-bearing name set, separate from parser
  metadata.
- A configured collision remains indeterminate when authoritative providers genuinely conflict;
  blanket indeterminate activation is not the fallback for every configured name.

Exit evidence: the same gauntlet changes exactly four theorem-like events to document installs and
four renewals to bound renewals, without creating new false bindings or changing unrelated store
rows.

### 2. Coverage honesty — P1

[coverage.ts](../../../src/TeXdig/census/coverage.ts) clamps every claim into source bounds and does
not require `claim.span.sourceId === sourceId`. [emit.ts](../../../src/TeXdig/census/emit.ts) checks
the supplied coverage arithmetic and residue ordering but does not recompute their union from
`claims.jsonl`. A malformed or cross-source claim can therefore receive credit while the bundle
passes publication validation.

Use one shared pure coverage calculation at production and emission validation. Invalid claims
receive no credit and produce `InvalidClaim` defects. A diagnostic must not launder an invalid
coordinate into a valid `SourceSpan`; retain source/entity identity and the rejected coordinates in
the message unless a separate raw-coordinate evidence shape is deliberately added.

Focused cases: negative, reversed, out-of-bounds, cross-source, overlapping-valid, and tampered
coverage totals/residue. Publication must reject any supplied coverage that differs from the
recomputed claim union.

### 3. Diagnostic vocabulary closure

Seven registered codes have no producer:

- `InvalidClaim`
- `UnknownEnvironment`
- `OpaqueRegion`
- `OccurrenceLimitExceeded`
- `SourceDecodeError`
- `OrdinalLabelMismatch`
- `TreeManifestMismatch`

Additionally, occurrence overflow throws instead of emitting `OccurrenceLimitExceeded`, while
`census/configured-gap` bypasses the registry as a raw string.

Perform one fire-or-strike sweep. Do not invent a partial bundle merely to fire a diagnostic:
pre-publication failures such as undecodable sources or manifest mismatch may correctly remain hard
refusals, in which case their bundle-diagnostic codes should be removed. Codes owned by deferred
stores, such as ordinal/reference behavior, should not appear in the active 0.3 vocabulary.

### 4. Math-carrier policy — T18

[reconcile.ts](../../../src/TeXdig/census/reconcile.ts) uses one flat math-environment set for both
top-level display carriers (`equation`, `align`, `gather`, and related forms) and interior structures
(`split`, `aligned`, `gathered`, `cases`, and related forms).

Choose one bounded outcome:

- split carrier and interior vocabularies with a tested persisted distinction; or
- explicitly document that 0.3 `role:"math"` means only “math-syntax environment” and defer
  carrier classification until its consumer lands.

The second option is the smaller acceptance change and avoids introducing an unused 0.3 field.

### 5. Assurance and schema hygiene

- Add `2205.11338v3` or an equivalent multi-file canary. Require more than one entered occurrence
  and a real include-return sequence; record whether brace-group or `\begingroup` scope crosses an
  input boundary.
- Deposit a determinism proof containing each store name and both SHA-256 digests, rather than
  retaining two unannotated output directories.
- Resolve schema stem ambiguity. Bare catalog keys such as `texdig-entities` currently select the
  historical 0.2 validator while 0.3 uses `texdig-entities-v03`. Keep historical `$id` identities
  stable, but make the active filename/stem policy explicit and test it. Do not put an
  application-specific “latest version” rule into the generic schema engine.

## Recommended follow-up sequence

1. **Authority patch:** configured signature-only behavior, pinned baseline evidence, and exact
   4-and-4 regression tests.
2. **Integrity patch:** shared coverage recomputation, invalid-claim diagnostics, emitter mutation
   tests, and the diagnostic fire-or-strike sweep.
3. **Contract hygiene:** rule T18, resolve schema stems, update README/planning links, and leave T16
   (`bound-out-of-scope`) plus T17 (empty-body fingerprint) deferred with their consumers.
4. **Acceptance evidence:** focused tests through `tests/run.ps1`, the complete scoped
   `tests/parallel.ps1` batch, multi-file canary, schema sweep, and two-run digest proof.
5. **Release assessment:** summarize exact row/count/diagnostic deltas. Request separate owner
   authorization before the full 34-document rerun.

## Exit conditions

The 0.3 acceptance close-list is complete only when:

- configured and baseline events no longer assert unsupported provider facts;
- coverage is recomputable from resident claims and invalid claims receive no credit;
- every active diagnostic code has a producer, or is removed with an explicit refusal/defer basis;
- the math-environment decision is implemented or documented;
- a real multi-file occurrence canary and deposited determinism proof pass;
- schema lookup cannot silently validate 0.3 rows against a 0.2 bare-stem validator;
- focused tests, the full TeXdig/public adapter batch, and bounded gauntlet are green; and
- unrelated `.gitignore`, artifact cleanup, and client-owned files remain untouched.

The full corpus, C-wave elaboration, downstream stores, nomenclature pass, T16, and T17 remain
outside this follow-up session unless the owner explicitly widens scope.
