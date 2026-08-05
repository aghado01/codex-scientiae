# Doccer K2b chip brief — exact occurrence-pair relation and composition

Runstamp 20260805_022512. Canon at entry: D1–D30; K1 and K2a closed; contract harness 1651
checks green. This is the second implementation chip in the consecutive K2a–K2c tranche frozen by
the [joint K2 contract](sol-doccer-k2-joint-contract-20260804_214547.md).

## Contract

Land `ClaimPairView` as an immutable exact finite relation between occurrence ordinals on an
ordered pair of explicit frozen `SpanBatch` references:

- `None`, validated ordinal-pair `Create`, geometry-filtered `Relate`, and ordinal-diagonal
  `Identity`;
- exact edge membership, count, emptiness, value equality/hash, and canonical lexicographic
  `(LeftOrdinal, RightOrdinal)` enumeration;
- each returned `ClaimPair` carries the exact `AllenRelation` derived from its retained basis rows;
- `Converse`, `ProjectLeft`, `ProjectRight`, `SemiJoinLeft`, and `SemiJoinRight`;
- direct exact `ComposePairs` over an identical middle frozen batch;
- separate, basis-stamped `GroupMiddleWitnesses` evidence for one composition.

Pair endpoints may use distinct but compatible masters, while all pair/selection operations use
exact frozen-batch reference identity. Equal rows in separately frozen batches are not
interchangeable. `Identity(batch)` contains `(i,i)` only; it is deliberately narrower than
`Relate(batch,batch,AllenRelationSet.Equal)` when distinct claims share one span.

Arbitrary pair construction accepts ordinal tuples rather than caller-supplied Allen labels. The
view derives every label itself, preventing inconsistent geometry evidence from entering the
carrier. Input order and duplicate edges are not identity.

## Exact composition and transparent witnesses

For (R\subseteq A\times B) and (S\subseteq B\times C), `ComposePairs` is the direct finite
relation join:

\[
R;S=\{(a,c)\mid\exists b.\ (a,b)\in R\land(b,c)\in S\}.
\]

`R.RightBasis` must be the identical object as `S.LeftBasis`. The implementation loops over exact
edges, equates middle ordinals, deduplicates outer pairs, and derives the outer Allen label from
the outer bases. It never calls `AllenCompose` to create an occurrence edge.

`GroupMiddleWitnesses` returns a `ClaimPairWitnessView` stamped with the left, middle, and right
bases. Each lexicographic outer group carries every qualifying middle ordinal in ascending order.
This is inspectable evidence for one composition only—not normalized support, persistent proof
identity, or a bracket-independent witness algebra.

## Exact-to-qualitative bridge

`AllenImage` remains contract/test notation for the Allen relations actually realized by a view's
edges. It is not exposed as public production API and is never the construction filter. The K2b
harness executes D29's one-way law:

\[
\alpha(R;S)\subseteq\alpha(R)\mathbin{\mathrm{AllenCompose}}\alpha(S).
\]

Every exact middle path is checked pointwise before images are unioned. The converse remains
false for two separately executable reasons:

- image abstraction forgets which middle ordinal realized each input atom;
- on the complete four-boundary finite carrier, adjacent outer `Before` intervals have no
  nonempty middle interval realizing `Before` then `Before`, although canonical composition
  permits the outer atom.

This closes the reference C# burden without activating Lean. The D29 gate remains: reassess before
qualitative summaries license omitted exact work in an indexed, compressed, incremental, or
independent backend, or if inclusion/basis/public-abstraction semantics change.

## Terminal join transition

`IntervalJoins.Join` remains as a compatibility result projection, not a second join:

- its filter is now the closed `AllenRelationSet?` value (`null` means `All`);
- it calls `ClaimPairView.Relate` once;
- it resolves each exact edge back to the existing `SpanJoin` row shape;
- it contains no independent nested geometry loop.

The transient `IReadOnlySet<AllenRelation>` filter surface is removed at the planned K2b
transition. Existing in-repo callers migrate in the same chip.

## Assurance surface

- all 16 relations on each two-by-two basis are exercised as exact values;
- all 256 ordered compositions are differential-checked against an independently written nested
  ordinal oracle;
- all 4,096 bounded relation triples satisfy extensional associativity;
- ordinal-diagonal left/right identity, converse involution/reversal, projections, semijoins, and
  exact-basis refusals are executable;
- duplicate outer paths collapse while `ClaimPairWitnessView` remains sound and complete;
- all 3,375 middle witnesses among the fifteen nonempty six-boundary intervals satisfy the atomic
  Allen bridge before the union-level inclusion is checked;
- actual-image-versus-requested-filter, middle-correlation loss, and adjacent-gap non-converse
  cases remain explicit;
- the terminal compatibility join is edge-for-edge equal to the `ClaimPairView` projection.

## Boundaries

K2b adds no pairing policy, match/fault result, repair, hierarchy, persisted pair wire format,
packed support, public qualitative abstraction, path consistency, generic `ConcreteCompose`, or
join index. K2c remains the pairing witness and uses this carrier plus K2a selections.

## Done criteria

- the public surface and XML documentation compile with no warnings and format cleanly;
- all reference, bounded, bridge, and terminal-transition tests pass;
- D31, README, workplan, roadmap, ledger, joint K2/Lean briefs, and this report agree that K2b is
  closed and K2c is active next;
- the delivered payload requires `ClaimPairView` and its composition/witness methods in smoke.

---

## Report

Completed 2026-08-05. Harness **1651 → 1733 checks green**; the verified local payload was
refreshed through `build-doccer.ps1`. Its delivered-assembly smoke now requires
`ClaimPairView`, `ClaimPairWitnessView`, `ComposePairs`, and `GroupMiddleWitnesses`; the manifest
records base commit `c975e8f` with a dirty source stamp for this K2b worktree.

`src/doccer/Algebra/ClaimPairView.cs` supplies the exact carrier, derived edge rows, projections,
semijoins, converse, direct composition, and separately stamped witness query. Basis equality is
reference identity; value equality is bases plus canonical edge membership. Compatible coordinate
spaces permit geometric relation construction, but separately frozen occurrence universes never
substitute for one another in composition or semijoin.

`IntervalJoins.Join` now delegates completely to `ClaimPairView.Relate` and projects its rows. Its
filter migrated from the transient general set to `AllenRelationSet?`, so no parallel K1-era filter
or nested join meaning remains.

The harness checks construction, ordering, relation derivation, exact identity versus duplicate
geometry, equality/hash, cross-basis failures, converse, projections, semijoins, composition,
witness completeness, and the terminal projection directly. The bounded relation model covers all
16 values, 256 composition pairs, and 4,096 associative triples. The six-boundary bridge checks all
3,375 exact middle paths, then retains both the middle-correlation and adjacent-gap counterexamples
to equality/converse.

No qualitative table cell generates an occurrence edge, `AllenImage` remains nonpublic, and no
K2c placeholder or packed-support promise landed. D31 closes K2b at 1,733 checks; K2c pairing and
complete identity-bearing residue are the active next implementation.

Follow-on: [K2c](sol-doccer-k2c-pairing-result-20260805_093203.md) subsequently exercised this
carrier as `PairingResult.MatchEdges` and correlated mismatch evidence, while K2a selections carry
the exact role inputs and unary residue. Strict top-only stack execution, two delimiter-family
witnesses, combined adversarial residue, and all 5,461 bounded two-key words are green; harness
1733→1779. D32 closes K2 without changing pair composition or exposing `AllenImage`.

Follow-on: the [joint K3/K4a contract](sol-doccer-k3-k4a-joint-contract-20260805_105443.md) then
closed as D33. Located shared-boundary composition remains geometry-only and distinct from
`ComposePairs`; the minimal graph projection lands beside it in the next joint core chip. Harness
remains 1779.
