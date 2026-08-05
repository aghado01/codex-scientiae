# Doccer joint K2a–K2c contract brief — exact occurrence query algebra

Runstamp 20260804_214547. Canon at entry: D1–D28; K1 closed; contract harness 1577 checks
green. This is a planning contract freeze, not an engine chip. It executes the sequencing
requirement in the
[D27 adjudication](sol-doccer-k1b-k4-resequencing-20260804_184200.md) before K2a, K2b, and K2c
land as consecutive reviewable implementations.

Inputs:

- [architecture expansion workplan](../planning/architecture-expansion-workplan.md);
- [decision and assurance registry](../planning/decisions.md);
- [deferred Lean rigor gate](sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md);
- [peer progress checkpoint](../discussions/opus-doccer-progress-checkpoint.md).

## 1. Disposition

K2 closes the occurrence-level query algebra in three chips:

~~~text
K2a  ClaimSelection
     exact-batch ordinal membership + stable population integrations

K2b  ClaimPairView
     exact pair relation + reference ComposePairs + terminal-join transition

K2c  PairingResult
     policy-stamped match edges + complete identity-bearing residue
~~~

All three carriers use in-process occurrence identity: ordinals on exact frozen `SpanBatch`
references. Compatible masters are not sufficient to mix selections or pair endpoints. Persistence
and durable claim IDs remain F2 work.

K2b also owns the bridge from exact occurrence relations to K1's qualitative interval algebra.
That bridge is a one-way sound abstraction, never a substitute implementation for exact pair
composition.

## 2. Shared basis, identity, and order rules

- A selection basis is one exact frozen batch.
- A pair-view basis is an ordered pair of exact frozen batches: `(LeftBasis, RightBasis)`.
- Compatibility for set operations and pair composition uses reference identity of those frozen
  batches, not merely compatible `TextMaster` values.
- Claim identity is an ordinal on its basis. Equal geometry does not merge occurrences.
- Set equality is basis plus extensional membership. Result order is not part of identity.
- Canonical enumeration is ascending ordinal for selections and lexicographic
  `(LeftOrdinal, RightOrdinal)` for pair edges.
- Geometry- or priority-ordered record projections are explicit `ClaimOrder` queries and do not
  alter the underlying set.
- Undefined ordinals, mutable builders, and cross-basis operations fail before producing partial
  results.

## 3. K2a — `ClaimSelection`

Required surface:

- basis-stamped `None`, `All`, predicate selection, count, emptiness, and membership;
- union, intersection, difference, and relative complement with exact-basis refusal;
- value equality/hash over basis and membership;
- ascending-ordinal enumeration;
- explicit record projection under `ClaimOrder`;
- identity-forgetting `Coverage()` to normalized `SpanSet`;
- stable integrations for grouping, gap cadence, and suppression.

The integrations share one reference selection path. Predicate conveniences may construct a
selection and delegate; they do not retain parallel population semantics. `Coverage()` may collapse
equal or overlapping geometry because it explicitly forgets occurrence identity.

K2a does not change `IntervalJoins.Join`, add durable IDs, or make priority/geometry order part of
selection equality.

## 4. K2b — `ClaimPairView` and reference composition

`ClaimPairView` is an exact finite relation between its left and right occurrence bases.
`ComposePairs` is the occurrence-level realization of K0's `ConcreteCompose` family; K2b does
not add an untyped or generic `ConcreteCompose` method. Required surface:

- construction by relating every exact left/right claim pair and applying an
  `AllenRelationSet` filter;
- exact edge membership, count, emptiness, value equality/hash, and lexicographic enumeration;
- ordinal-diagonal `Identity(batch)`, distinct from filtering for geometric Allen `Equal`;
- converse with bases and ordinals swapped;
- left and right projections to `ClaimSelection`;
- left and right semijoins by compatible `ClaimSelection`;
- exact `ComposePairs`;
- a separate transparent middle-witness query for one composition.

For

\[
R \subseteq A\times B,\qquad S\subseteq B\times C,
\]

the reference definition is ordinary finite relational composition:

\[
\operatorname{ComposePairs}(R,S)
=
\{(a,c)\mid \exists b\in B.\ (a,b)\in R\land(b,c)\in S\}.
\]

The right basis of `R` must be the identical frozen batch as the left basis of `S`. The result is
bound to `(R.LeftBasis, S.RightBasis)`, deduplicates outer pairs, and enumerates them
lexicographically. The reference implementation is a direct exact middle-ordinal relation join.
It does not call `AllenCompose`, infer edges from a qualitative table cell, or require a middle
witness representation to define extensional equality.

`GroupMiddleWitnesses(R,S)` is a separate query:

~~~text
(outer left ordinal, outer right ordinal)
    -> every qualifying middle ordinal, ascending
~~~

It is sound and complete for that one composition. It is not a normalized support carrier and
receives no associativity, bracket-independence, persistence, or proof-identity contract.

## 5. Exact-to-qualitative bridge

For contract and test purposes, define

\[
\alpha(R)
=
\{\operatorname{Relate}(A_a.\mathrm{Span},B_b.\mathrm{Span})\mid(a,b)\in R\}.
\]

`AllenImage` or \(\alpha\) means this image of the actual edges. It is not the construction filter:
a requested filter may contain atoms that no edge realizes. This notation is required for the law
and harness oracle; the K2b implementation brief may expose it publicly only if a concrete
diagnostic or consumer warrants the additional surface.

The load-bearing bridge law is

\[
\alpha(\operatorname{ComposePairs}(R,S))
\subseteq
\alpha(R)\mathbin{\operatorname{AllenCompose}}\alpha(S).
\]

Pointwise proof: every output edge `(a,c)` has an exact middle witness `b`; K1 relates
`(a,b)`, `(b,c)`, and `(a,c)` to one atomic triad; D28's canonical table contains the outer atom
for that triad. Taking unions yields the inclusion.

This is deliberately not equality for two reasons. First, `AllenImage` forgets which middle
occurrence realizes each input atom, so the right side may combine relations observed at
incompatible middle identities. Second, the retained adjacent-gap witness supplies the finite
geometry boundary: canonical `Before AllenCompose Before` contains `Before`, while a finite
carrier can contain an outer `Before` pair with no exact middle interval. Consequently:

- qualitative composition may reject an impossible outer relation without false negatives once
  the bridge is established;
- qualitative membership never creates an exact outer pair;
- every output of `ComposePairs` still requires an actual middle ordinal;
- an optimized pair backend must remain differential-equivalent to the reference relation join.

The K2b harness checks both the inclusion and its non-converse. It also checks the stronger
per-witness atomic form before unioning relation images.

## 6. Reference K2b assurance

The dependency-free reference suite must cover:

- exact middle-basis acceptance and all cross-basis refusals;
- extensional equality with an independently written nested relation oracle;
- ordinal-diagonal left and right identity;
- associativity of extensional `ComposePairs`;
- converse and composition reversal;
- projection and semijoin laws;
- duplicate outer-pair collapse under several middle witnesses;
- soundness and completeness of `GroupMiddleWitnesses`;
- the `AllenImage` inclusion and the adjacent-gap non-converse;
- one semantic replacement path for `IntervalJoins.Join`.

Any retained `IntervalJoins.Join` becomes a compatibility projection from `ClaimPairView`; it may
not retain an independent nested-loop meaning. D31 completes that transition: the filter is now
`AllenRelationSet?` (`null` means `All`), and the old `IReadOnlySet<AllenRelation>` surface and
independent geometry loop are gone. Provisional census adapters should still avoid taking a
durable dependency on that terminal compatibility method.

## 7. K2c — pairing witness

`PairingResult` is basis- and policy-stamped:

~~~text
PairingResult
  Input selection(s)
  Role/key compatibility policy
  MatchEdges          ClaimPairView(open basis, close basis)
  PairedRegions       optional identity-forgetting geometry projection
  Faults              selection-backed unary residue + mismatch pair evidence
~~~

The reference stack policy must be witnessed over at least two delimiter families. Its accepted
edges are forward, partial one-to-one, and noncrossing. Caller-supplied role and key compatibility
owns delimiter meaning. Every considered occurrence is either matched or present in named residue;
faults retain occurrence identity and evidence.

Pairing performs no repair and infers neither containment nor parenthood. `MatchEdges` exercises
the K2b carrier; fault populations exercise K2a; mismatch pair evidence remains identity-bearing.

## 8. Chip gates and landing order

### K2a gate

- basis and membership laws are exhaustive over bounded batches;
- ordered projections remain explicit;
- coverage and population integrations share the reference selection path;
- no K2b or pairing placeholder surface is required.

### K2b gate

- reference exact relation semantics and all laws in §6 are green;
- the one-way Allen bridge is checked and its converse is refuted;
- the terminal join has one semantic implementation path;
- no qualitative cell is used as evidence that an exact edge exists.

### K2c gate

- match/fault partition is complete over the considered inputs;
- accepted edges satisfy the declared pairing policy;
- at least two delimiter families and adversarial mismatch residue are witnessed;
- matching, repair, containment, and parenthood remain distinct.

The chips land K2a → K2b → K2c without an unrelated tranche between them. Each receives its own
implementation brief/report and verified payload refresh.

## 9. Lean gate disposition

The bridge law is a genuine proof obligation but does not activate the deferred Lean harness now:

- its direction is fixed by the adjacent-gap counterexample;
- the proof is a direct witness chase over ordinary finite relation composition;
- D28 already owns atomic-triad soundness through the independent \(D_6\) oracle;
- the reference K2b implementation and C# property/differential tests can check the Doccer-specific
  carrier plumbing.

Reassess the Lean gate before an indexed, compressed, incremental, or independently implemented
pair backend uses qualitative summaries to omit exact work and claims universal no-false-negative
equivalence with the reference model. The gate also reopens if equality replaces inclusion, the
middle-basis condition changes, or `AllenImage` becomes part of a generalized public
qualitative-calculus abstraction.

The reference `ClaimSelection` and `ComposePairs` implementations are now landed; the first
pairing witness remains unblocked.

## 10. Non-goals

This contract does not add persistence, a public pair wire format, packed support, normalized proof
identity, path consistency, generic QSTR descriptors, repair, inferred hierarchy, or an
`AllenCompose`-driven pair generator. It does not activate Lean or implement any K2 source type.

---

## Report

Completed 2026-08-04 as the D29 joint K2 contract freeze. The decision canon, assurance registry,
architecture workplan, roadmap, ledger, deferred Lean brief, and formalization notes now agree on
the exact-to-qualitative bridge and its burden gate. No engine source or package payload changed;
the contract harness baseline remains 1577 checks green.

The next implementation chip is K2a. K2b remains responsible for the reference exact pair carrier,
the terminal-join transition, the executable bridge law, and differential protection for every
later optimized backend.

Follow-on: [K2a](sol-doccer-k2a-claim-selection-20260804_221441.md) subsequently landed the exact
selection algebra and population integrations as D30. Its bounded oracle closes all 64 selections
and 4,096 ordered pairs on a six-claim basis, with a separate 70-claim word-boundary witness;
harness 1577→1651. At that boundary K2b became the active next chip and retained every
pair/bridge/join obligation specified here.

Follow-on: [K2b](sol-doccer-k2b-claim-pair-view-20260805_022512.md) subsequently landed the exact
pair carrier, direct reference composition, complete middle witnesses, executable one-way Allen
bridge, and sole terminal-join path as D31. The bounded suite covers all 256 two-by-two relation
compositions, all 4,096 relation triples, and all 3,375 six-boundary middle paths; harness
1651→1733. `AllenImage` remains nonpublic, Lean remains deferred under the same gate, and K2c is
the active next chip.
