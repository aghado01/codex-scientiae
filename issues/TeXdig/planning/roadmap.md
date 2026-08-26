# TeXdig roadmap — ahead only

Completed items move to [ledger.md](ledger.md); rulings land in [decisions.md](decisions.md).
Ordering within a phase is the current recommendation, not a contract.

## Phase: 0.3 acceptance close-list (before C-waves; item 3 also gates the walk projection)

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

## Phase: walk follow-ons (W1–W3 landed `081034f1`; see [ledger](ledger.md))

The spine emits. What remains is what landing it exposed:

1. **Unbound invocations leak their arguments into the spine.** The walk consumes an invocation's
   binding-dependent hull, so an unbound name has a token-only hull and its argument text reads as
   prose (`\title{...}`, `\begin{lemma}[Key Lemma]`, `\begin{flushright}` in `mini_article`).
   This is not fixable in the walk: whether argument text is prose is exactly what binding decides.
   It resolves as binding coverage improves, which makes it **direct evidence for T15's priority**
   rather than a separate defect. Until then, hole fraction *understates* what is unknown.
2. **Reading test on a real paper**, not just `mini_article`. Run the bounded gauntlet and read the
   spine of a Voroninski or kisungyou deposit end to end.
3. **Batch deployment.** `Get-TeXdigBatchJob` already carries the 0.4 store surface and its tests
   pass; the walk needs no adapter change. Deploy the gauntlet through batch-executor and record
   hole fraction per document as the first corpus-wide baseline — it is the series that must
   fall monotonically as the C-waves land.
4. **Walk-level diagnostics.** The walk currently emits no diagnostic codes of its own. Whether a
   leaked-argument or unentered-source condition should fire one is open, and rides the close-list's
   fire-or-strike sweep rather than preceding it.

Close-list item 3 (coverage honesty) remains worth landing before the walk ledger is trusted as a
baseline: the walk ledger is computed independently of `census/coverage.ts`, so it is not distorted
by the clamp, but cross-checking the two is not meaningful until the clamp is gone.

## Phase: C-waves — elaboration (hole-filling, post-walk)

Reframed 2026-08-26: with the walk landed, expansion's job is to **fill walk holes**, and hole
fraction is its acceptance measure — it must fall monotonically and never rise. A rise is a
regression in binding coverage, not a change in the corpus.

- C1: rewrite expansion to consume `bindings.jsonl` + `invocations.jsonl` exclusively
  (`elaborate/expand.ts` is a rewrite input, not a base). Each resolved invocation retires an
  `unbound`/`indeterminate` anchor; unresolvable ones stay holes and are never guessed.
- C2: versioned resource budgets (substitution steps, depth, AST nodes, derived UTF-16 length,
  include depth, occurrence count); outcome vocabulary
  `expanded/partial/unbound/bound-out-of-scope/unsupported/non-converging/budget-exceeded/toolkit-error`;
  ceilings calibrated on canaries before freezing.
- C3: dialect coverage growth (xparse defaults/delimiters, paired delimiters, starred operators)
  under truthful unsupported outcomes.

## Phase: Cut 2 — downstream contract stores

Order: `macros` → `pointers` → **grow** `zones` → `references`/`frontmatter` → `graph` projection.
`walk` has left this phase (see above); `zones` no longer *creates* records but grows the minimal
ones W2 minted — adding `closure`, `names`, `isolable`, `validation` to existing `zone:` ids.
Each lands with registered schema, closed joins, deterministic rerun, and the same atomic
publication. Open decisions riding this phase: T16 (bound-out-of-scope basis), T17 (empty-body
fingerprint), D5–D8/D10 (theorem-like source, diagram vocabulary, pointer seeds,
`\refstepcounter`, unresolved-citation shape).

**`graph` carries an unsettled arity question.** T1 names the IR a typed attributed *hypergraph*,
but `GraphRow` in `core/contracts.ts` is a binary `{source, target, relation}` conforming to
`codex-scientiae/graph-primitive/0.1` — which self-describes as a **DORMANT REFERENCE** with no
producer, minted to record the notion while the concrete graphs settle. The words `hypergraph` and
`hyperedge` appear nowhere in `src/TeXdig`. Relations that appear to want n-ary members (a float
with its caption, label and references; a theorem with its proof and invoked lemmas) are not
expressible in the drafted row. Settle the arity before `graph` is implemented, not after — and
note that going n-ary *increases* what JSON Schema can validate (per-relation member arity, role
enums, per-role id-class `pattern`s against the `{class}:{locator}` grammar), where the current
binary row leaves it with two opaque strings. Nothing is emitted yet, so no data exists in the
wrong shape.

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
