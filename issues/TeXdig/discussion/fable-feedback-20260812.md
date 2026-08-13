# plan

Yes. Proceed with B0–B3 as one cohesive campaign culminating in a `texdig-census/0.3` contract release.

“Wholesale” should mean one authorization and one integrated release—not parallel implementation or a monolithic commit:

1. **B0:** Lock occurrence IDs, scope representation, declaration operations, configured precedence, `\let` capture, and compile-root path semantics.
2. **B1:** Implement deterministic repeated/cyclic include occurrences.
3. **B2:** Implement the sole chronological binding interpreter.
4. **B3:** Attach invocations using the governing occurrence-specific binding.
5. **Publish together:** Move `occurrences.jsonl`, `bindings.jsonl`, and `invocations.jsonl` from deferred to emitted, updating schemas, summary, emitter, and runner atomically.

Use bounded green commits and gates after each step, but avoid publishing partial B stores. B1–B3 validate one another, so stopping between them would leave a technically valid but not meaningfully consumable contract.

I’d keep C-wave elaboration and downstream D stores out of scope, then reassess after:

- deterministic double-run output;
- repeated, diamond, and cyclic include fixtures;
- complete scope/binding semantics tests;
- exact empty/default/star/bare-token attachment tests;
- the public TeXdig batch and a bounded multi-document gauntlet.

So: **yes to the whole B program, sequentially executed and atomically released.**

# feedback

**The read: direction is sound. Waves 0–2 are real, the 0.2 architecture is right, and I'd green-light B0 — with a short punch-list of things the doc books as done (or silently drops) that should be folded into B0 before dispatch.**

I verified the doc's claims against HEAD myself, then drove the standing agy pane through a full verification/cross-examination pass (report at `scratchpad/agy-texdig-verify-report.md`, ~7.5 min) and spot-checked its load-bearing claims before relaying — all held.

**What checked out.** All 10 P1s are either landed with file-level evidence or honestly deferred: the legacy `compile/traversal.ts`, `compile/macros.ts`, and `elaborate/expand.ts` have zero importers repo-wide, and the deferral is declared in `summary.stores`. The 103/103 is real (95 Pester across the six TeXdig containers + 8 pytest schema tests; artifact mtimes align with the committed tree). Doctrinally, the contract tier is well aligned: physical census carries only what's knowable from bytes (macro-invocation = csname token only, argument hulls pushed to the binding-dependent `inv:` tier), chronology becomes first-class data with conservative outcomes (`opaque`/`deferred`/`unsupported` — the knowability binary applied to TeX's imperative semantics), and [contracts.ts](src/TeXdig/core/contracts.ts:390) explicitly marks the relation vocabulary as canon-in-formation, your design surface. Schemas registered in jsonl_engine — the right convergence point. The no-`0.1`-converter call is also right: corrupt coordinates aren't reconstructible, and nothing downstream is consuming 0.1 while gauntlet full runs are paused.

**Punch-list for B0:**

1. **Coverage honesty was silently downgraded.** Wave 2 promised invalid claims "receive no credit and produce defects"; what landed is emission-time refusal — [coverage.ts:57](src/TeXdig/census/coverage.ts:57) still clamps, has no same-source filter, and emission's coverage identity is tautological (`residue ≔ length − claimed`, never recomputed from claims). ~10 lines closes the only publishable-distortion path found.
2. **Three registered diagnostic codes with zero emitters** (`InvalidClaim`, `UnknownEnvironment`, `OpaqueRegion`) — fire or strike; same lie-class D15 objected to.
3. **`context`/`activation` emit `"unknown"` at every ordinary declaration site** — populate in B2 or declare derived-later before consumers trust the discriminator.
4. **Wave 7 fell out of the reassessed enumeration** — canaries, two-run determinism, both public test paths, and the 34-doc authorization gate need restating as the exit gate after C, or they'll be forgotten.
5. **`KNOWN_MATH_ENVS` is still one flat set** (top-level vs interior unsplit) — original Wave-3 item with no bucket.
6. **Runstamps:** the plan codified `YYYYDDMM` against `yyyyMMdd` in all three stamping code paths; the interleave is already on disk in `artifacts/test-runs/` (`20261308_*` isn't even a valid date under the house scheme) and breaks the newest-by-string-sort idiom. Fix the doc line and rename before B0 spawns more.
7. **Contract wrinkles for B0's decision list:** `BindingEvent` requires an `occurrenceId` that configured declarations don't have (summon-site activation isn't encodable yet); `MacroRecord` has a single `bodySpan` while the census tier already carries two-body begin/end evidence; D2's three-state shape is already frozen (only the `bound-out-of-scope` _basis_ is open — don't let B0 reopen the shape); D14's empty-hash policy exists only in prose.

One watch-item on the design itself: B2's supported-semantics cutline is where scope-model creep will pressure — the outcome vocabulary is the pressure valve; hold the conservative line rather than simulating TeX grouping when in doubt.
