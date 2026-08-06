I'll start by finding the doccer planning canon and briefs.

Let me read the planning canon first.

Harness finished. Let me check its result and read the K4c structural views.

Reviewed the canon, the four K3/K4 commits, and the K5–K7 plan. Harness re-run clean: **1976 checks passed**, and [decisions.md](issues/doccer/planning/decisions.md), [roadmap.md](issues/doccer/planning/roadmap.md), [ledger.md](issues/doccer/planning/ledger.md), the [workplan](issues/doccer/planning/architecture-expansion-workplan.md), and [README](src/doccer/README.md) all agree on the landed state (D39 / K4c closed / `Extract`+`LaminarNode` gone).

## K3/K4 code — soundness

The load-bearing algorithms hold up under direct reading:

- **[PathSelection.cs:394](src/doccer/Algebra/PathSelection.cs:394) DP** is correct for _minimum-cost-then-lexicographic_. Keeping exactly one plan per boundary is sufficient because the prefix is fixed at the comparison point, so the lex-minimum among min-score suffixes composes. Descending-boundary order is a valid topological order because edges are guaranteed nonempty. Score is independently re-verified against the retained cost table in `Complete`, and the `checked` sum can't trip given the construction-time bound.
- **[Segmentation.cs:151](src/doccer/Algebra/Segmentation.cs:151) greedy** maintains the right invariant — the cursor always satisfies `CanReachWindowEnd`, established by `HasCompletePath` and preserved by each chosen edge. The `chosen < 0` throw is a genuine assertion, not a live path.
- **[LaminarHierarchy.NearestContainers](src/doccer/Algebra/HierarchyView.cs:464)** is well-defined _because_ claim spans are nonempty: containers of a nonempty child in a no-crossing family are totally ordered by containment, so the running-minimum loop terminates on the true nearest. That guarantee comes from `SpanBatch` ([SpanBatch.cs:160](src/doccer/Core/SpanBatch.cs:160), `allowEmpty: false`), not from anything local — see the forward risk below.
- `Laminarizer.Admit` genuinely delivers inclusion-maximality (every rejected group crosses an accepted one); `EnsureAcyclic` is a correct Kahn pass over the node selection; `ResolutionMap`'s three contracts are properly separated.

Three coherence items, none breaking:

1. **Equality asymmetry at the graph stamp.** `CandidateRegionGraph.Equals` is _value_ equality (source ref + window + candidates), but every downstream result — `PartitionView`, `SegmentationResult`, `PathSelectionProblem` — stamps with `ReferenceEquals`. So `graphA.Equals(graphB)` can be true while a partition from A is rejected against B. Each type is internally consistent (hash matches equals), and the strictness is exactly D34's anti-substitution rule — but the public value-equality operator invites the substitution the doctrine forbids. Worth one decision line: document graph equality as diagnostic-only, or make result stamps use it.
2. **`CandidateRegionGraph.Create`'s empty-span refusal is unreachable** today, since batches refuse empty claims upstream. Fine as defense-in-depth — but it means "graph edges consume text" is an _upstream_ law, which matters when K6/K7 introduce synthetic and deletion material. If zero-length claims ever become representable, `NearestContainers` silently degrades from "nearest" to "first in iteration order" (two meeting siblings can both properly contain an empty child, and they don't cross). That's a K6/K7 tripwire, not a bug now.
3. **[LaminarView.cs](src/doccer/Algebra/LaminarView.cs) is the only Algebra file using LINQ** (`GroupBy`/`OrderBy`/`Any`/`First`); the rest of the tranche uses explicit loops and typed collections. Cosmetic — complexity is the same — but it's the one file that reads differently from its neighbors.

## K5–K7 — sequencing

The macro-order is sound, and the two structural corrections in the canon (D34 killing the false K4b→K4c edge; K4c closing with no common selector) held up in the code — no premature universal selector appeared. Five things to settle before the K5 contract chip:

1. **K5's blocker points at a design that is now code.** The Open entry says register/value/metadata is "entangled with the math-register design — don't close from the doccer side alone." That register spec and canonicalizer have landed ([issues/math-register/math-register-spec.md](issues/math-register/math-register-spec.md), [src/math-register/math-register.ps1](src/math-register/math-register.ps1) — note the path moved into its own directory). So the first K5 move is a read, not a wait: decide whether `Register` joins `Kinds`/`Sources`/`RuleIds` as a fourth interned column or lives at fact grain. The second Open item — "the meaning of _register_ in sol's Tier-1 list" — is likely answerable from §3 of that spec.

2. **K5 has no named bounded witness.** The cross-cutting gate requires a Witness row per tranche, and K2/K3/K4 each named theirs in-tranche. K5 names none, and none of K8's five integration items is a saturation demo — the only mention anywhere is the F6 reconciliation row. Cheapest fix: witness saturation over evidence that already exists (K2c pairing residue or K4c nearest-container edges), so no new domain gets donated to the kernel.

3. **K5→K6 is the real serialization risk.** `Materialize` closes D7's last lift and is what F1/`OffsetMap` and the latex-ingest reshape lane are waiting on — and it now sits two tranches behind an open identity question. But K6's actual dependency on K5 is narrow: K6's exit gate never mentions facts, K7's `OutputPiece` carries an _optional_ support reference, and the "design against real selected output pieces" evidence the workplan wanted for K6 already exists post-K4b. Reducing that edge to a named obligation — reserve the support/derivation type, keep it distinct from origin — would let K6 start beside K5's identity work. That's structurally the same move D34 already made on the false K4b→K4c edge.

4. **K6 must freeze its strictness up front.** Its exit gate says composition requires "the identical tagged middle master/basis," but _identical_ is now a loaded word: the landed code uses reference identity for occurrence-bearing carriers and value compatibility for geometry. K6 is cross-master, so this is the first thing its contract should pin, citing the D34/D35 seam precedent rather than re-deriving it.

5. **Reapply the Lean trigger at K5 contract time, per D37/D39 precedent.** The theorem table already lists K5's obligation (finite fixed-point termination + rule-order independence). Unlike K4b/K4c, where a bounded differential oracle carried the guarantee, confluence under fair evaluation order is a global claim over a rule set the kernel doesn't bound — it's the strongest activation candidate left in the queue. A finite rule universe may still let a certificate carry it, but that judgment should be made explicitly, not inherited.
