I'll do a fresh read of doccer — starting with the planning canon to see what K5b–K7 and the v1 initiatives added, then reading the implementation itself.

Core substrate is clean and well-documented. Continuing with SpanBatch and the K5 Facts lane.

Harness verified: **2751 checks passed**, matching the claims in roadmap, ledger, and README exactly. Continuing the read — the support hypergraph and K5b saturation.

Final batch — the collectors, grouping, and validation tiers.

The harness project is a thin csproj — the 2751 checks must be compiled from elsewhere. Let me check.

The read is complete — full engine source (43 files, ~8,300 lines), the planning canon, the README contract surface, and a live harness run. I also updated the stale doccer memory to current truth (it was one lane behind, still showing K5b/K6 as "next"). Here's the fresh look.

## Verified state

The claims all check out and agree with each other. I ran the contract harness live: **2751 checks passed**, exactly matching the roadmap, ledger, and README. The ledger's chain of harness counts (1976 → 2091 → 2324 → 2536 → 2639 → 2751) is internally consistent, and every carrier the docs name exists in source where they say it does. The kernel is genuinely complete through K7: [Facts](src/doccer/Facts) (K5a/K5b), [Vectors](src/doccer/Vectors) (V1), [Origins](src/doccer/Origins) (K6), and [Materialization](src/doccer/Materialization) (K7) all landed on top of the K1–K4 substrate. Test source (~9,600 lines in [tests/doccer](tests/doccer)) now slightly outweighs engine source — a healthy ratio for a contract-gated engine.

## What holds the engine together

Reading it end-to-end in one sitting, the striking thing is that one discipline — _identity strength chosen per carrier, stated in the doc comment, enforced in code_ — is applied without exception across all eight lanes:

- **Compatible-master value identity** (fingerprint-based) for geometry carriers: `SpanSet`, `LocatedRelation`, `Utf16UnitMask`, `CanonicalFactTable` value equality.
- **Exact reference identity** for occurrence and evidence carriers: `ClaimSelection`'s frozen batch, `ClaimPairView`'s bases, `FactReference`, `OriginBasis`. The sharpest instance is [OriginRelation.ComposeOrigins](src/doccer/Origins/OriginRelation.cs:197), which demands `ReferenceEquals` on the shared middle basis — the "exact retained middle stage" law is enforced structurally, so a value-equal clone _cannot_ satisfy it even by accident. K7 repeats the move: `MaterializedPiece` requires the exact `OutputPiece` object at its plan position.
- **Derived deterministic identity** for slices (`{parent}#{start}-{end}`), which is what makes recreated slices interoperable.

Two other patterns are equally uniform. First, the **evidence/residue posture is actually implemented, not just stated**: pairing emits unclosed/dangling/mismatched with mismatch pairs correlated; segmentation keeps coverage gaps distinct from connectivity dead-ends; path selection accounts selected/rejected/excluded disjointly; laminar admission proves accepted + residue partition the candidates; harvest separates boundary residue from classifier unknowns; K7 reports per-slot unused source without inferring deletion. Second, **result objects re-verify their own invariants in internal constructors** — `PathSelectionResult.Complete` recomputes the score from policy costs; `Materialize` re-checks payload reproduction, atom embedding, copy tiling, and the exact origin-or-synthetic partition even though plan construction already validated everything. That's defense-in-depth against engine bugs, and it's cheap at reference scale.

## Craftsmanship worth naming

- **The V1 poisoned-tail seam**: `BooleanVector` masks the physical tail word on _every read_ (`LogicalWord`), and a test-only constructor deliberately injects garbage tail bits so the harness can prove packed storage never leaks into public semantics. That's a genuinely elegant way to keep "private representation" honest.
- **The V0/K7 surrogate story is coherent end-to-end**: unit masks may legally split surrogate pairs (scalar safety deferred to harvest), while `RewritePlan` refuses high/low surrogate fusion at piece boundaries — which is exactly the one hazard at scalar-level atomization, so piece-local topologies embed into the concatenated output topology provably.
- **K5b saturation** is a deliberately naive fixed-point loop (each agenda step rescans all rules), and that's correct posture: the roadmap routes optimized backends through the Lean reactivation gates, and the 256-program powerset oracle owns correctness meanwhile.
- The vocabulary discipline claimed in the README holds in source: there is no unqualified `Compose` or `Select` anywhere — `AllenCompose`, `ComposePairs`, `ComposeOrigins`, `Seq`, `Saturate`, `Materialize`, and the one reserved policy-bearing `PathSelection.Select`.

## Watch items (observations, not defects)

- **Style drift marks the strata.** [Validation.cs](src/doccer/Validation/Validation.cs) (Tranche-2 era) uses LINQ `Where/Count` chains, and `LaminarView` has some LINQ, while everything from K3 onward is strict explicit-loop/typed-collection style. Harmless, but visible as archaeology; a K8-era pass could normalize it if you care.
- **Linear-scan query methods** — `SupportsOf`, `ParentsOf`/`ChildrenOf`, `CoarseTargets`/`FineMembers` — are O(edges) per call. Fine now; these will be the first hot spots when K8 composes at scale, and they're squarely A-lane/F4 territory.
- **Minor hash-basis inconsistency**: `Utf16UnitMask.GetHashCode` folds in `Master.Length` and `AddressUnit`, while `SpanSet`/`LocatedRelation`/`CanonicalFactTable` hash DocumentId/Revision/Fingerprint. All are consistent with compatible-master equality (compatible ⇒ all those fields equal), so it's cosmetic — just two idioms for the same thing.
- `Segmentation.FirstOrdinalCompletePath` does a full `foreach` over all graph ordinals at every boundary (O(V·E)); same reference-posture note as above.

## What I didn't read

The harness internals themselves — 9,600 lines including the independent oracles (endpoint-predicate Allen table, the 5,461 Dyck words, 16,384 K4b problems, the K6 Boolean-matrix census, the 156-plan K7 census). I verified it runs green and read the engine it exercises; auditing the oracles' independence for real would be its own pass, and it's the natural follow-up if you want a skeptical second layer on the "2751 green" claim. The other observation for K8 planning: the roadmap's first queue item (re-run pairing, ambiguous token paths, budgeted chunks, macro substitution with composed origins) now has every carrier it needs — nothing I read suggests a missing seam.

Overall: this is the most internally consistent stretch of the codebase I've read — canon, README, source, and harness are in lock-step, the doctrine documents describe what the code actually does, and the K5–K7 finish reads like the same hand that wrote K1, only more practiced.
