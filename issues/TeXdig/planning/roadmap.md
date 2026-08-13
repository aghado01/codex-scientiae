# TeXdig roadmap — ahead only

Completed items move to [ledger.md](ledger.md); rulings land in [decisions.md](decisions.md).
Ordering within a phase is the current recommendation, not a contract.

## Phase: 0.3 acceptance close-list (before C-waves)

1. **Configured/baseline authority (T15) — two fixes, top blocker.**
   (i) Configured evidence stops vetoing document-level preconditions in the binding machine;
   (ii) pinned kernel/plain-TeX baseline name-set so kernel renewals bind. Re-run the 3-doc
   gauntlet: the 8 invalid-precondition outcomes should resolve 4→installs (document `\newtheorem`)
   and 4→bound renewals.
2. **Dead diagnostic codes — one fire-or-strike sweep.** Seven registered codes with no producer
   (`InvalidClaim`, `UnknownEnvironment`, `OpaqueRegion`, `OccurrenceLimitExceeded`,
   `SourceDecodeError`, `OrdinalLabelMismatch`, `TreeManifestMismatch`), plus
   `occurrences.ts` throwing where `OccurrenceLimitExceeded` should emit, plus
   `census/configured-gap` minted as a raw string bypassing the registry (`cli/census.ts:262`).
3. **Coverage honesty.** Remove the clamp in `census/coverage.ts`; same-source filter; emission
   recomputes `claimedUtf16` from claims rows; invalid claims emit `InvalidClaim` defects.
   (~10 lines; closes the only publishable-distortion path found.)
4. **Math-carrier classification (T18).** Rule defer-or-fix; if deferred, say so in README.
5. **Gauntlet shape.** Add at least one multi-file deposit (the `2205.11338v3` canary class) —
   currently occurrence traversal and brace-group/begingroup scopes have zero corpus witness.
6. **Determinism gate deposits its own proof** (digest pair per store), not bare run-a/run-b.
7. **Schema registry hygiene.** Retire or rename the 0.2 `texdig-{entities,diagnostics,summary}`
   registrations; bare-stem lookups currently resolve to 0.2 validators.

## Phase: owner passes (parallel, cheap, re-grounding)

- **Naming pass over the compile tier** — house vocabulary over Sol's compiler idiom, before the
  C-waves bake current names into more code.
- Mis-stamped `artifacts/test-runs/` directory cleanup (owner; T13).
- Keep `src/TeXdig/README.md` agreeing with this canon as waves land.

## Phase: C-waves — elaboration

- C1: rewrite expansion to consume `bindings.jsonl` + `invocations.jsonl` exclusively
  (`elaborate/expand.ts` is a rewrite input, not a base).
- C2: versioned resource budgets (substitution steps, depth, AST nodes, derived UTF-16 length,
  include depth, occurrence count); outcome vocabulary
  `expanded/partial/unbound/bound-out-of-scope/unsupported/non-converging/budget-exceeded/toolkit-error`;
  ceilings calibrated on canaries before freezing.
- C3: dialect coverage growth (xparse defaults/delimiters, paired delimiters, starred operators)
  under truthful unsupported outcomes.

## Phase: Cut 2 — downstream contract stores

Order: `macros` → `pointers` → `zones` → `walk` → `references`/`frontmatter` → `graph`
projection. Each lands with registered schema, closed joins, deterministic rerun, and the same
atomic publication. Open decisions riding this phase: T16 (bound-out-of-scope basis), T17
(empty-body fingerprint), D5–D8/D10 (theorem-like source, diagram vocabulary, pointer seeds,
`\refstepcounter`, unresolved-citation shape).

## Phase: Wave-7 release gates (unchanged from the 0.2 plan — restated so they cannot fall out)

1. Focused tests through both public paths (`tests/run.ps1` exact files, then `tests/parallel.ps1`).
2. Complete `tests/TeXdig` battery + JSON-schema conformance.
3. Two-run bytewise determinism (with deposited digests).
4. Four canaries: `2205.11338v3` (includes + style/class), `2210.00916v2` (addbibresource,
   bib+bbl), `2111.15058v3` (heavy bib), `1810.02906v1` (float specimen).
5. The full 34-document rerun as a separate owner authorization gate, audited with jso-jackson
   invariant/delta queries. Acceptance: manifest↔recomputed fingerprints agree; zero invalid or
   non-contained spans; zero agreed rows violating evidence policy; parsed↔coverage bijection;
   summaries recompute; all stores schema-valid; bundles complete, atomic, deterministic;
   expansion failures explicit; ID/count deltas classified as migration effects or defects.

## Deferred beyond Cut 2

Zone validation instruments (KaTeX/TikZ render — D16, Cut 3); full TeX execution (arbitrary
conditionals, dynamic `\csname`, catcode mutation, constructed include paths, complete xparse);
math-register wiring of expansions into the math channel.
