# Doccer K7 materialization — D47 contract read-ahead

Runstamp: 20260810_171743

Status: contract read-ahead and pressure test for D47; not an implementation authorization or an
independent decision record

> **Adjudicated 2026-08-10:** the
> [D47 contract](../briefs/sol-doccer-k7-materialization-contract-20260810_173159.md) adopts the
> ordered-program, closed-piece, scalar-boundary, unused-source, opaque-`FactReference`, and
> exact-middle recommendations. It additionally makes origin-or-synthetic completeness local to
> one exact result stage: K6 composition flattens origin edges only, while synthetic explanations,
> derivation references, piece partitions, and unused-source residue remain on the retained result
> chain. D47 controls where this read-ahead and the contract differ.

## Question examined

What is the smallest K7 contract that can mechanically realize a caller-supplied rewrite as a new
immutable `TextMaster`, retain an exact K6 output stage for later composition, and make every
output atom and every unused source atom auditable without turning Doccer into an edit-policy,
alignment, normalization, or proof-selection engine?

This read-ahead starts from the landed K6 types rather than the provisional pre-K6 origin sketch.
Its job is to expose the decisions D47 must freeze before source work. Until that contract exists,
the carrier names and signatures below are recommendations rather than public API.

Inputs:

- the implemented [K6 origin contract and report](../briefs/sol-doccer-k6-origin-contract-20260810_001537.md),
  [`OriginBasis`](../../../src/doccer/Origins/OriginBasis.cs), and
  [`OriginRelation`](../../../src/doccer/Origins/OriginRelation.cs);
- D43's exact-table [`FactReference` seam](../briefs/sol-doccer-k5a-contract-20260809_193131.md);
- the [D40 K5–K7 sequencing correction](../briefs/sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md);
- the [decision canon](../planning/decisions.md), especially D7, D10, D12, D19, D40, D43, and
  D45;
- the current [architectural expansion workplan](../planning/architecture-expansion-workplan.md);
- the [post-K4 K5–K7 review](opus-doccer-k3k4-review-k5k7-notes.md);
- the implemented [`TextMaster`](../../../src/doccer/Core/TextMaster.cs),
  [`TextTopology`](../../../src/doccer/Core/TextTopology.cs),
  [`TextSlice`](../../../src/doccer/Core/TextSlice.cs), and
  [`SpanSet`](../../../src/doccer/Algebra/SpanSet.cs); and
- the current dependency-free contract harness at **2639 checks with zero warnings**.

## Executive disposition

K7 should model a rewrite plan as an **ordered output program**, not as a set of source edits and
not as a pre-positioned output layout:

~~~text
MaterializationTarget
  output document ID + revision + singleton output-slot tag

RewritePlan
  exact source OriginBasis
  target
  ordered positive-material OutputPiece declarations

OutputPiece                         exactly one mode
  Copy(source slot + span)          payload and one-to-one origins are derived
  OriginMapped(literal + map)       payload supplied; every local atom has source origin(s)
  Synthetic(literal + explanation) payload supplied; no local atom has a source origin
  optional exact FactReference      independent explanation of why

Materialize(plan)
  new TextMaster
  retained singleton output OriginBasis
  realized positive output-piece partition
  output-to-source OriginRelation
  unused-source SpanSet per source slot
~~~

The input pieces carry no output offsets. Their order determines the output, and materialization
assigns their final spans. This makes output gaps, output overlap, and unused supplied pieces
unrepresentable instead of errors needing a policy.

The three piece modes should be mutually exclusive. A copy instruction obtains its text from the
exact source-basis slot. An origin-mapped literal supplies text plus local-output-atom-to-source-
atom pairs. A synthetic literal supplies text plus a required nonblank explanation and has no K6
origin edges. If adjacent atoms need different postures, the caller splits the piece at a scalar
boundary. This closed shape gives K7 the exact completeness invariant

\[
OutputAtoms = OriginBearingAtoms\;\dot\cup\;SyntheticAtoms.
\]

`FactReference` remains zero-or-one opaque derivation evidence on a piece. It neither supplies an
origin nor substitutes for a synthetic explanation, and `Materialize` never reads a
`SupportHypergraph`.

The result should report **unused source material**, not inferred deletion. It is the exact
per-slot complement of source atoms named by the realized origin relation. A caller that wants a
narrower source universe can first use D12/D19's fragment-local master or `TextSlice`; K7 should
not add a second source-window basis.

The first chip should retain K6's ordinary composition boundary. If a subsequent plan uses the
exact prior result `OutputBasis` as its `SourceBasis`, its origins compose directly. K7 should not
infer slot lifts, retag compatible clones, or automatically combine a prior stage with newly
introduced pass-through sources. A later named helper requires a concrete repeated multi-source
consumer and a separate assurance decision.

## 1. What landed K6 fixes for K7

D45 removes several choices that were still open in the provisional K7 prose:

1. Origins are atom relations, not span hulls or offset functions. K7 produces one ordinary
   `OriginRelation` whose output endpoint is the exact result basis and whose source endpoint is
   the exact plan basis.
2. Source identity is `OriginBasis` object identity. A compatible master, matching tag, or
   separately rebuilt basis is not a substitute.
3. The ordinary output stage is a singleton basis, including for empty output. The empty result
   therefore has one output slot, zero output atoms, zero pieces, and an empty edge set; it does
   not use K6's distinct zero-slot-basis case.
4. K6 permits partial relations. K7, not `OriginRelation.Create`, supplies the stronger
   origin-or-synthetic completeness law.
5. Origins run from output to source. Unused source material is not a converse edge, sentinel
   coordinate, or zero-width output record.
6. `ComposeOrigins` requires the exact middle basis. Retaining the result basis is consequently a
   functional requirement, not incidental bookkeeping.

K7 should consume these facts without widening K6. In particular, no piece carrier should add a
second span-valued origin model beside `OriginRelation`.

## 2. A plan is an output program, not a patch set

The workplan's provisional phrases “conflicting/overlapping source-edit sites” and “unused
pieces” assume a patch-shaped input. That shape is unnecessary at K7 grain and imports policy the
kernel cannot honestly own.

An ordered output program has simpler semantics:

- every declared piece is emitted once in declaration order;
- final output positions are cumulative consequences of preceding payload lengths;
- two pieces may copy or cite overlapping source material, because duplication and contraction
  are legal origin shapes;
- source order need not match output order;
- there are no caller-supplied output gaps or overlaps to reconcile; and
- rejection, ranking, or conflict among *candidate* edits happens before K7, in the adapter or
  named selection result that compiles the final plan.

This does not weaken auditability. The realized result retains each plan piece and its exact
output span, while the origin relation and unused-source residue show what happened to source
material. It simply keeps “choose a rewrite” separate from “perform this rewrite,” as D10
requires.

If a future consumer needs patch coordinates, overlap resolution, or rejected-edit evidence, it
can define a patch-to-`RewritePlan` compiler whose own result retains that policy and residue. It
should not make `Materialize` conditionally discretionary.

## 3. Exact plan and target identity

The recommended input shape is:

~~~text
MaterializationTarget
  required nonblank DocumentId
  nonnegative Revision
  required nonblank OutputTag

RewritePlan
  exact retained SourceBasis
  immutable Target
  snapshotted ordered Pieces
~~~

The target supplies everything needed to create the output `TextMaster` and its singleton
`OriginBasis`. `DocumentId` and `Revision` retain their existing `TextMaster` meanings;
`OutputTag` is the local origin-stage slot name and is not silently derived from document
identity. K7 should not enforce a repository-wide revision policy that `TextMaster` itself does
not possess.

`RewritePlan` should be a sealed reference object with no value-equality promise. The result
retains that exact plan reference. Together with the exact result `OutputBasis`, this is enough
in-process plan/run identity for the first chip. A generated run GUID, persisted stage ID, or
cross-process equality belongs to F2 after the wire contract is designed.

Construction should snapshot caller-owned piece and local-origin sequences. It should validate
all source-basis-relative declarations, local output coverage, target fields, checked total
length, and adjacent payload boundaries before exposing a plan. A well-formed immutable plan then
contains no policy choice for the executor to make.

## 4. Three closed piece modes

One nullable bag containing `Text`, `SourceSpan`, `Origins`, and `SyntheticExplanation` would admit
many meaningless combinations. D47 should instead freeze three mutually exclusive semantic
modes. The exact C# realization may use a closed hierarchy or private construction plus factories,
but callers should not be able to assemble a fourth state accidentally.

### 4.1 Exact copy

~~~text
Copy
  source slot ordinal
  nonempty scalar-bounded source TextSpan
  optional FactReference
~~~

The payload is `SourceBasis[slot].Master.Slice(span)`. It is not separately supplied, so copied
content cannot disagree with the cited source. Each copied output topology atom maps to the
corresponding source topology atom in ordinal order. The local map is total, functional, and
injective; repeating the same copy piece can make the whole result non-injective, which is legal.

A copy span is validated against the exact master in the named source slot and must be nonempty.
Using a compatible clone to resolve the span would erase K6 source identity and is refused.

### 4.2 Origin-mapped literal

~~~text
PieceOrigin
  nonnegative output atom ordinal within this piece
  source OriginAtom relative to the plan SourceBasis

OriginMapped
  nonempty literal string
  snapshotted canonical PieceOrigin set
  optional FactReference
~~~

Local output atom ordinals are necessary because the final output basis does not exist when a plan
is declared. They index the topology of this literal only. Every local output atom must occur in
at least one `PieceOrigin`; exact duplicate pairs collapse and enumeration should be canonical by
local output atom, source slot, then source atom.

This mode admits ordinary performed-transform shapes:

- several source atoms to one output atom (contraction);
- one source atom to several output atoms (expansion or duplication);
- several source atoms to several output atoms; and
- reordering across pieces or within an explicitly supplied local map.

The carrier records a producer's declared actual origins. K7 does not infer them from text
similarity, normalization rules, or a post-hoc alignment. D41's correspondence-to-origin
promotion remains a separately stamped producer obligation.

### 4.3 Synthetic literal

~~~text
Synthetic
  nonempty literal string
  required nonblank synthetic explanation
  optional FactReference
~~~

Every atom of the literal is explicitly synthetic and receives no K6 origin edge. The explanation
is required even when a `FactReference` is present: the string says why this material has no
source-material origin, while the optional fact says why the plan chose it.

A single piece cannot mix synthetic atoms and origin-bearing atoms. Splitting at output-atom
boundaries is lossless because origins themselves are atom-grained. An output atom that combines
or transforms source atoms belongs in `OriginMapped`; “synthetic” is reserved for an atom with no
declared source origin.

## 5. The hidden UTF-16 boundary obligation

Piece-local atom numbering is sound only when every piece boundary is also a scalar boundary in
the concatenated output. This is not guaranteed merely because each piece can be tiled on its own.
For example:

~~~csharp
piece0.Text = "\uD83D"; // locally one preserved unpaired high-surrogate atom
piece1.Text = "\uDE00"; // locally one preserved unpaired low-surrogate atom
~~~

Concatenation produces one U+1F600 surrogate-pair atom. Two local atom ordinals would therefore
collapse into one final output atom, invalidating piece spans, local origins, and the completeness
partition.

D47 should require that no adjacent payload boundary has a high surrogate immediately before a
low surrogate. Equivalently, every cumulative piece end must satisfy
`outputMaster.IsScalarBoundary(offset)`. If the pair is intended, the caller places both code
units in one literal or copies one source span containing the complete scalar.

This rule does not reject unpaired surrogates generally. D1 and `TextTopology` preserve them as
first-class atoms. It rejects only cross-piece fusion that would change the ordinal sum of the
piece topologies after assembly.

## 6. Mechanical realization and result invariants

The reference `Materialize` path should be deliberately direct:

1. resolve each copy payload from the plan's exact source basis and read supplied literal
   payloads unchanged;
2. checked-sum their UTF-16 lengths and concatenate them in plan order;
3. create a new `TextMaster` from the target document ID, revision, and exact concatenation;
4. assign one positive scalar-bounded output `TextSpan` to every piece;
5. create a singleton `OriginBasis` containing the exact output master under `OutputTag`;
6. translate copy mappings and piece-local mappings to global `OriginEdge` values;
7. construct one K6 `OriginRelation` on the exact output and source bases;
8. verify origin-bearing versus synthetic atom coverage; and
9. compute unused source atoms and return the immutable result.

The recommended result shape is:

~~~text
MaterializedPiece
  plan piece ordinal (or exact retained piece)
  positive final OutputSpan

MaterializationResult
  exact Plan
  exact OutputMaster
  exact singleton OutputBasis
  ordered MaterializedPieces
  exact stage Origins
  one UnusedSourceMaterial SpanSet per source-basis slot
~~~

The result invariants are:

- `OutputBasis.Count == 1` and its slot carries the exact `OutputMaster`;
- `Origins.OutputBasis` is that exact result basis;
- `Origins.SourceBasis` is the exact plan source basis;
- realized piece spans are ordered, positive, scalar-bounded, pairwise disjoint, gap-free, and
  cover `OutputMaster.Extent` exactly;
- slicing the output by those spans reproduces the resolved piece payloads, and concatenating
  them reproduces `OutputMaster.Text` under ordinal string equality;
- each output atom occurs either in one synthetic piece or as the output of at least one origin
  edge, never both; and
- unused-source entries retain source slot order and exact compatible masters.

`OriginRelation.IsTotal` is not the K7 completeness predicate: a valid result containing synthetic
material is intentionally not total as an origin relation. K7 completeness is the disjoint union
of origin-bearing and explicitly synthetic atoms.

The source masters are never modified. The output is always a newly constructed master object,
even when its target identity and text make it value-compatible with a source master.

## 7. Empty output and residue

An empty plan has zero pieces and materializes as:

- a new empty `TextMaster` with the declared target identity;
- a singleton output `OriginBasis` carrying that exact master;
- zero output atoms and zero realized pieces;
- an empty `OriginRelation` retaining the exact endpoint bases; and
- every source atom present in `UnusedSourceMaterial`.

A zero-slot source basis is legal for empty or all-synthetic output. Copy and origin-mapped pieces
cannot name source atoms in that case and are refused by ordinary validation.

For each source slot, let `Used_i` be the source atoms named by at least one realized origin edge.
The corresponding result residue is the normalized `SpanSet` union of all atoms in that slot not
in `Used_i`. Meeting unused atoms may merge; disconnected regions remain disconnected.

The property should be called **unused source material**, not deletion:

- a source slot may be context rather than an edited document;
- an unreferenced atom proves only that this output did not declare it as an origin; and
- a semantic delete/replace classification requires a change model that K7 does not have.

The source universe is the whole exact plan basis. D12 already makes fragment-local masters
first-class, and D19 supplies explicit slice lineage. A caller materializing only one fragment can
use the slice child as the K7 source stage instead of adding a second per-slot source-scope carrier.

There is no “unused output piece” residue in this model: every supplied piece is emitted. Rejected
candidate pieces, patch conflicts, and source-edit classifications belong to the producer that
created the final plan.

## 8. Exact intermediate retention and composition

The result must expose and retain its exact singleton `OutputBasis`. A direct next stage uses that
same object as its plan `SourceBasis`:

~~~text
first.Origins  : first.OutputBasis  -> original.SourceBasis
second.Origins : second.OutputBasis -> first.OutputBasis

second.Origins.ComposeOrigins(first.Origins)
  : second.OutputBasis -> original.SourceBasis
~~~

Reconstructing a value-identical basis around `first.OutputMaster` is not equivalent and must fail
under D45. The exact retained basis, not tag or master compatibility, is the middle-stage stamp.

Executing one immutable plan twice may produce two value-compatible output masters, but it creates
two distinct output master objects, two distinct output bases, two distinct origin relations, and
two result objects. A caller that intends to continue one run must retain that run's result basis;
K7 should not intern stages or conflate repeated executions.

One materialization may directly consume several source slots and emit a many-source relation.
What K7 should *not* promise in its first chip is automatic composition when a later source basis
mixes the prior output stage with new or pass-through slots. That operation would have to construct
a new exact combined middle basis, embed the prior relation into it, and add explicit identity
edges for pass-through material. Matching tags or compatible masters cannot determine that lift.

The ordinary K6 constructors are sufficient to declare such a bridge explicitly if a producer
needs it. A named parallel/slot-lift helper should wait for a concrete K8/F7c plan shape and must
reapply the K6 assurance gate before claiming coherent automatic composition.

## 9. The optional K5a seam stays opaque

Each piece may retain zero or one `FactReference`. D43 deliberately chose this exact-table handle
rather than a support-edge or proof-path reference. K7 should therefore:

- snapshot and retain the reference exactly;
- refuse an explicitly supplied uninitialized/default reference;
- expose its exact table and ordinal unchanged;
- never rebase it to a value-equal table or a post-saturation result table;
- never inspect, select, or require a `SupportHypergraph`; and
- never turn it into a source origin or a substitute synthetic explanation.

No implicit master-compatibility rule should connect the fact table to a source slot. Derivation
answers why a piece was selected and may justify synthetic output; origins answer where material
came from. A producer-specific contract may impose a stronger relationship, but the mechanical
materializer should not invent one.

The first carrier should remain singular. If a consumer later needs several facts, an ordered
derivation bundle or another explicitly named evidence carrier can be designed without silently
widening `FactReference` or making K7 depend on K5b.

## 10. Decisions D47 should make explicitly

| Question | Recommended D47 answer |
|---|---|
| Is the input a patch set or an output program? | Ordered output program; no input output offsets. |
| Who chooses among candidate edits? | An upstream adapter/policy result; `Materialize` only validates and realizes. |
| How many piece modes? | Three closed modes: exact copy, origin-mapped literal, synthetic literal. |
| May one piece mix origins and synthesis? | No; split at scalar atom boundaries. |
| Who creates output coordinates? | `Materialize`; the plan carries local atom ordinals only where needed. |
| May adjacent pieces fuse a surrogate pair? | No; every cumulative piece boundary is scalar-safe in the assembled output. |
| May copy text be supplied redundantly? | No; derive it from the exact source slot and span. |
| May literal origins be inferred from equal text? | No; the producer supplies local origin pairs explicitly. |
| What is deletion residue? | None is inferred. Report per-slot unused source material. |
| Are overlapping source reads conflicts? | No; duplication, contraction, and shared origins are valid. |
| What identifies a run in process? | Exact plan/result/output-basis references; no new persisted run ID. |
| How does the K5a seam participate? | Optional exact `FactReference`, retained opaquely and ignored by execution. |
| How do repeated stages compose? | Only through the exact retained middle basis using K6 `ComposeOrigins`. |
| Does K7 add automatic slot lifting? | No; defer until a concrete consumer makes it necessary. |

Two items merit special contract language because ordinary happy-path tests will not reveal them:
the cross-piece surrogate-fusion refusal and the distinction between unused source material and
semantic deletion.

## 11. Bounded executable witness

The implementation chip should include five complementary fixture families.

### 11.1 Construction and immutability

- null, blank target field, negative revision, null piece, and caller-owned sequence mutation;
- invalid source slot/atom ordinals, scalar-splitting or empty copy spans, empty literal payloads,
  blank synthetic explanations, and uninitialized `FactReference` values;
- duplicate local origin collapse and canonical enumeration; and
- checked cumulative length and exact source-basis retention.

### 11.2 Material shapes

- exact copy, reorder, repeated copy, contraction, expansion, and many-to-many mapped literals;
- interleaving at least two source slots, including compatible masters under distinct tags;
- all-synthetic output on a zero-slot basis and mixed copy/synthetic output;
- refusal of a partially mapped literal, origins on a synthetic piece, or a zero-origin mapped
  atom; and
- explicit demonstration that overlapping source reads are legal rather than conflicts.

### 11.3 UTF-16 topology adversary

- BMP atoms, one supplementary scalar, and preserved unpaired surrogates within pieces;
- refusal of a high-surrogate piece followed by a low-surrogate piece;
- acceptance of that surrogate pair when contained in one literal or one exact source copy; and
- agreement between piece-local atom offsets and final output atom ordinals at every admitted
  boundary.

### 11.4 Result, residue, evidence, and composition

- exact output reconstruction and positive gap-free piece partition;
- singleton empty output with zero pieces and all source material unused;
- exact per-slot unused `SpanSet` values, including disconnected residue and empty source slots;
- exact `FactReference` retention with no support graph and no effect on origins;
- a two-stage chain whose exact retained middle basis composes; and
- refusal of a compatible or value-identical reconstructed middle basis.

### 11.5 Independent finite plan oracle

Use two one-atom source slots and a small alphabet of independently modeled archetypes—for example
copy-left, copy-right, mapped-from-left, mapped-from-both, and synthetic. Enumerate every ordered
plan through length three (156 plans including empty) and compare the implementation with a
separately written oracle for:

- exact output text;
- cumulative piece spans;
- canonical output-to-source edge set;
- origin-bearing versus synthetic output-atom partition; and
- used/unused source-atom sets per slot.

This census is deliberately small enough to be complete and inspectable. Targeted fixtures own
UTF-16 width, malformed-surrogate, exact-reference, multi-stage, and `FactReference` cases that the
abstract alphabet does not model. Delivered-payload smoke should pin the final D47 public names
and essential signatures.

## 12. Assurance disposition

The `K7-MATERIALIZE` Lean gate should be reapplied at D47 and, for the direct reference shape
above, can remain deferred. The first implementation's principal guarantees are obtained by
construction:

- ordered concatenation assigns the unique gap-free partition;
- closed piece modes make origin-versus-synthetic coverage locally decidable;
- boundary validation makes piece atom tilings compose into the output tiling;
- direct finite edge construction targets the landed K6 carrier; and
- an independent bounded plan oracle checks reconstruction, coverage, and residue together.

The first chip should make no stage-fusion, intermediate-elision, automatic slot-lift, persistence,
parallel execution, or alternate-backend equivalence claim.

Reapply, and activate if bounded executable evidence cannot own the claim, before:

- a streaming, fused, incremental, parallel, or compressed materializer claims the same complete
  result;
- intermediate masters or piece boundaries are elided while origins are claimed unchanged;
- a general multi-source slot-lift/parallel constructor claims coherent composition;
- a persisted plan/result form claims stable identity across processes; or
- a stronger global reconstruction theorem is used to justify a non-obvious implementation.

The novel K7 multi-source trigger recorded by D45 is therefore not activated by directly building
one relation over the exact plan basis. It remains live for automatic lifting or fusion.

## 13. Proposed D47 and implementation sequence

D47 should freeze, in one contract-only brief:

1. the ordered-output-program interpretation and absence of kernel edit policy;
2. target and exact source-basis identity;
3. the three closed piece modes and piece-local atom coordinate;
4. scalar-safe cross-piece boundaries;
5. exact output reconstruction and origin-or-synthetic completeness;
6. singleton empty-output posture and per-slot unused-source residue;
7. exact result/plan/basis retention and ordinary K6 composition boundary;
8. the opaque optional `FactReference` seam; and
9. the bounded witness and deferred assurance triggers.

The likely public surface is small:

~~~text
MaterializationTarget
PieceOrigin
OutputPiece
RewritePlan
MaterializedPiece
MaterializationResult
RewriteMaterialization.Materialize
~~~

Exact owner/factory spellings should be frozen by D47, not by this discussion. The subsequent
implementation chip can live under `src/doccer/Materialization/` with a focused
`tests/doccer/K7MaterializationTests.cs`, delivered-surface smoke, and an appended implementation
report in the D47 brief.

Only after the K7 source chip closes should the plan advance to K8's bounded macro-substitution
witness or schedule F1/F7c consumers that rely on materialization. K7 itself should not absorb
`OffsetMap`, alignment/correspondence promotion, normalization policy, patch compilation,
selection, support-path choice, persistence, byte coordinates, or domain-specific rewrite
semantics.

## Conclusion

The landed K6 relation makes K7 smaller than the provisional plan suggested. The kernel needs an
ordered positive-piece output program, three explicit material postures, one exact output stage,
and deterministic unused-source residue. It does not need edit-site conflict resolution, output
offset reconciliation, a second origin carrier, or a support graph.

The decisive D47 correction is to assign output coordinates only after concatenation while making
piece-local atom coordinates stable through a scalar-safe boundary law. With that rule and the
closed copy/origin-mapped/synthetic modes, exact reconstruction, auditable synthesis, and K6
composition can all be owned by a direct reference implementation and a bounded independent
oracle.
