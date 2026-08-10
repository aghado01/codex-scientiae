# Doccer K6 contract — exact-stage relation-valued origins

Runstamp 20260810_001537. **Status: contract frozen as D45; implementation is the active default
lane after V1 closure; current harness 2536.**

This brief supersedes the provisional K6 carrier language in the
[D40 correction](sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md) without
reopening its sequencing decision. K6 remains independent of K5a/K5b and is the sole prerequisite
for K7 materialization. The read-ahead covers the implemented atom/slice substrate, exact-basis
precedents through K5, the K7 handoff, the F7 producer boundary, and the deferred assurance gate.

Inputs:

- implemented [`TextMaster`](../../../src/doccer/Core/TextMaster.cs),
  [`TextTopology`](../../../src/doccer/Core/TextTopology.cs), and
  [`TextSlice`](../../../src/doccer/Core/TextSlice.cs);
- the [decision canon](../planning/decisions.md), especially D19, D25, D40, D41, D43, and D44;
- the [architectural expansion workplan](../planning/architecture-expansion-workplan.md);
- the [post-K4 K5–K7 review](../discussions/opus-doccer-k3k4-review-k5k7-notes.md);
- the [compositional-kernel and formalism synthesis](../discussions/sol-doccer-compositional-kernel-and-formalisms-20260804.md);
- the [round-2 adjudication](sol-doccer-expansion-round2-adjudication-20260806_093159.md); and
- the [deferred Lean packet](sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md).

## 1. Disposition

K6 is a small finite relation algebra over exact tagged material stages:

~~~text
OriginBasis       exact ordered namespace of tagged TextMaster slots
OriginAtom        basis-relative (slot ordinal, atom ordinal) coordinate
OriginEdge        output OriginAtom -> source OriginAtom
OriginRelation    exact output basis + exact source basis + canonical finite edge set
OriginProjection  exact-relation-stamped output-span image as one SpanSet per source slot
~~~

The direction is always **output material to source material**. Relations may be partial,
one-to-one, one-to-many, many-to-one, or many-to-many. K6 records declared material lineage; it
does not infer history from text equality or alignment.

D45 makes one read-ahead correction to the provisional formula. `OriginBasis` is the endpoint sort
on both sides of a relation, not only a source-side wrapper:

\[
O_{A,B}\subseteq TaggedAtoms(A)\times TaggedAtoms(B).
\]

An ordinary materialization has a singleton output basis and an ordered multi-source input basis.
Permitting either endpoint to contain several slots makes the carrier closed under ordinary
relational composition and lets a later K7 stage retain pass-through sources without inventing a
special multi-source composition law. It does not require every materialization to expose a
multi-slot output.

## 2. Exact tagged origin basis

An `OriginBasis` is a sealed reference object containing an immutable ordered tuple of slots:

~~~text
OriginSlot
  required nonblank ordinal tag
  exact TextMaster reference
~~~

Tags are unique within one basis under ordinal string equality. Slot ordinal is the compact
coordinate used by edges; the tag is the stable in-basis name that keeps roles inspectable. The
same exact master or two value-compatible masters may occur in different slots under different
tags. Those slots remain different provenance identities.

The basis object itself is the in-process stage identity. It deliberately has reference identity:

- separately created bases do not substitute for one another even when their slot tags, order,
  master references, or compatible master values agree;
- reordering slots changes every basis-relative coordinate;
- tags do not become global or persisted IDs; F2 must define any future wire identity; and
- `TextMaster.IsCompatibleWith` remains available for explicitly identity-forgetting geometry
  validation or projection, never for relation composition or slot substitution.

A zero-slot basis is legal and has no atoms. It is distinct from a singleton basis whose master is
empty. K7's empty materialization still creates an empty `TextMaster` and therefore uses the latter:
one output slot, zero output atoms, and zero output pieces.

For basis `B`, its finite carrier is:

\[
TaggedAtoms(B)=\{(i,a)\mid i<|B|\land a<AtomCount(B_i.Master)\}.
\]

Atom ordinals index `TextTopology.Atoms`, whose units are Unicode scalars or preserved unpaired
UTF-16 surrogates. Origins therefore cannot split a scalar atom. UTF-16 code-unit vectors and byte
coordinates remain different carriers.

## 3. Relation value and identity

`OriginAtom` contains a non-negative slot ordinal and atom ordinal. It is meaningful only against
the explicit basis that resolves it. `OriginEdge` contains one output and one source atom.

`OriginRelation.Create(outputBasis, sourceBasis, edges)`:

- retains the exact supplied basis references;
- validates every slot and atom ordinal against those bases;
- snapshots caller-owned input;
- collapses exact duplicate edges; and
- enumerates edges canonically by output slot, output atom, source slot, then source atom.

Relation equality and hashing use the exact output-basis reference, exact source-basis reference,
and canonical edge sequence. A relation on compatible clone bases is not equal to, composable with,
or a substitute for one on the original bases.

`None(A,B)` is the empty relation on two exact bases. `Identity(B)` is the full tagged-atom diagonal
on that one exact basis:

\[
\Delta_B=\{(x,x)\mid x\in TaggedAtoms(B)\}.
\]

Identity on a zero-atom basis is the empty edge set while still retaining `B` as both endpoint
stamps. Origin identity is not text equality, equal geometry, or a diagonal of UTF-16 boundaries.

The reference surface may expose `IsFunctional`, `IsTotal`, and `IsInjective` as derived finite
queries:

- functional: every output atom has at most one source atom;
- total: every output atom has at least one source atom; and
- injective: every source atom has at most one output atom.

Functional origins are ordinary members of the relation carrier rather than a second public map
type. Identity is functional, total, and injective; composition preserves functionality and
totality when both inputs have those properties.

## 4. `ComposeOrigins`

For `R : A -> B` and `S : B -> C`:

\[
R.ComposeOrigins(S)
=\{(a,c)\mid\exists b.\ (a,b)\in R\land(b,c)\in S\}.
\]

Composition requires `ReferenceEquals(R.SourceBasis, S.OutputBasis)`. A newly constructed basis
with the same tags and exact masters, or one containing merely compatible masters, is refused.
The result retains `R.OutputBasis` and `S.SourceBasis`, canonicalizes duplicate outer edges, and
retains no scheduler or first-middle-witness trace.

On composable exact stages:

- left and right identity hold;
- composition is associative;
- an output atom with no first-stage origin has no composed origin; and
- functional relations compose to a functional relation, with the analogous totality law.

This is ordinary finite relation composition. It does not merge tags, infer a slot correspondence,
or flatten a stage DAG. A mixed-source K7 pipeline must present a complete relation over the exact
middle stage, including explicit identity edges for any pass-through slots. Whether K7 later needs
a separately named parallel/slot-lift constructor is a K7 contract question; `ComposeOrigins` does
not guess one from compatible masters or matching tag strings.

## 5. Material projection without hull substitution

`ProjectSources(outputSlotOrdinal, outputSpan)` is the explicit material-image query. It validates
the span on the selected output slot's master, selects the atoms tiled by that scalar-bounded span,
and follows every relation edge into the source basis.

The result is an `OriginProjection` retaining:

- the exact `OriginRelation` reference;
- the selected output slot ordinal and span; and
- one `SpanSet` for every source-basis slot, in slot order.

Each source `SpanSet` is the exact normalized union of related source-atom spans for that slot.
Meeting atoms may merge because they denote one continuous material region; disconnected atoms
remain disconnected. The operation never returns a convex hull in place of a disconnected image
and never collapses two source slots merely because their masters are value-compatible.

An empty output span selects no material atoms and projects to empty source regions. This follows
D17's set-theoretic material convention, not `TextTopology.Project`'s deliberately different
insertion-point-to-line convention. K6 adds no reverse projection: unused source material does not
become a fictitious deletion edge.

## 6. Partial origins, synthesis, and deletion

K6 intentionally allows an output atom to have zero origins. In this carrier, zero edges mean only
“no source atom is declared.” They do not by themselves prove that the atom was synthesized,
inserted, lost, or unexplained.

K7 owns the completeness rule: every materialized output atom must have one or more declared K6
origins or belong to a positive-material output piece carrying an explicit synthetic explanation.
Similarly, deleted or unused source material belongs to named plan/change residue or explicit
absence in K7/F7 producer results. K6 does not encode deletion through converse edges, zero-width
spans, or sentinel atom ordinals.

Consequently:

- copy origin, transformation origin, correspondence, causal derivation, and K5 support remain
  different evidence sorts;
- a performed transformation may declare actual origins because it observed material birth;
- a post-hoc aligner produces correspondence under its model/policy evidence and requires the D41
  explicit promotion step before its pairs may be asserted as origins; and
- `FactReference` never enters `OriginRelation`; K7 may retain it independently on a piece.

## 7. `TextSlice` functional embedding

K6 supplies a named `TextSlice` adapter into the relation carrier. Given exact singleton child and
parent bases whose master references are respectively the slice's exact `Child` and `Parent`, it
relates each child atom to the unique parent atom occupying the rebased span.

The exact-master requirement is historical rather than geometric: a compatible clone is a valid
coordinate space for explicit geometry operations, but it is not the parent or child object named
by this lineage record. The resulting relation is total, functional, injective, order-preserving,
and agrees with `TextSlice.ToParent` on every atom span. An empty slice produces an empty relation
between singleton zero-atom bases.

For a chain of slices, callers reuse the first relation's exact child/output basis as the next
relation's exact parent/source basis. `ComposeOrigins` then agrees extensionally with the direct
child-to-ancestor atom translation. No origin pointers are added to either `TextMaster`; lineage
remains opt-in on the relation object, as D19 requires.

## 8. Bounded executable witness

The implementation chip must include four complementary fixtures:

1. **Finite relation census.** On exact two-atom bases, enumerate all 16 relations, all 256
   composable pairs, and all 4,096 triples. Compare `ComposeOrigins` with an independently written
   Boolean-matrix oracle and check identity and associativity.
2. **Exact-middle adversary.** Rebuild a value-identical middle basis and separately use
   value-compatible master clones; both compositions fail. A basis with two compatible one-atom
   source slots under distinct tags retains two distinct edges and projection entries.
3. **Material-shape adversary.** Cover zero-origin output, contraction, duplication, disconnected
   source regions, zero-slot bases, and singleton empty-master bases. Projection returns exact
   `SpanSet` unions and never a hull.
4. **Slice chain.** Use scalar-width variation, including a surrogate pair or preserved unpaired
   surrogate, to check the injective functional relation, empty slice, and composed
   child-to-ancestor agreement with `TextSlice` rebasing.

Construction tests additionally cover nulls, blank/duplicate tags, invalid slot/atom ordinals,
immutable snapshots, duplicate-edge collapse, canonical enumeration, exact-basis equality, and
projection refusal for invalid spans.

## 9. Assurance disposition

The `K6-COMPOSE-ORIGINS` Lean gate is reapplied and discharged without activation for the reference
implementation. D45's semantic core is an exact finite relation in `Rel`; ordinary identity and
associativity are standard, and the direct implementation plus exhaustive two-atom Boolean-matrix
oracle can own the first source chip without choosing a different public signature.

Reapply before:

- a compressed, indexed, parallel, or functional fast path claims extensional equivalence;
- stage fusion or intermediate-master elision claims to preserve origins;
- an automatic parallel/slot-substitution operator claims coherent tag and composition laws; or
- K7 makes a novel multi-source reconstruction/composition guarantee that the direct reference
  relation and construction-time validation cannot own.

The existing deferred harness remains the right posture. Formalization is not activated merely to
restate ordinary finite relation composition.

## 10. Explicit non-goals

K6 does not add:

- `OutputPiece`, `RewritePlan`, `MaterializationResult`, or `Materialize`;
- synthetic explanations, deletion/change residue, conflict policy, or reconstruction checks;
- `OffsetMap`, normalization, edit distance, alignment, correspondence, or promotion policy;
- a converse/reverse-origin API or an inference that unused source atoms were deleted;
- span hull substitution, point-bias policy, or zero-width origin claims;
- implicit composition through compatible masters, matching tags, or value-equal basis objects;
- automatic basis retagging, slot substitution, parallel/direct-sum composition, or DAG flattening;
- K5 fact/support references, proof paths, semiring weights, probabilities, or causal labels;
- persisted tags, stage IDs, wire forms, byte coordinates, or cross-process identity; or
- a compressed or performance-promised storage backend.

F7b performed-transform producers may target the K6 carrier only after this implementation lands;
F7a remains correspondence-only and independent. K7 decides plan/piece/residue identity against the
landed relation rather than widening it during implementation.

## 11. Landing gate and handoff

The contract-only chip closes when D45, the `K6-COMPOSE-ORIGINS` registry row, workplan, roadmap,
ledger, engine README, D40 supersession note, and deferred Lean packet agree. No K6 source type or
test lands in this chip, so the harness remains **2324**.

The following implementation chip owns the exact public names and constructors described above,
the reference composition/projection path under `src/doccer/Origins/`, the `TextSlice` adapter, the
four bounded witnesses, delivered-payload smoke coverage, and an implementation report appended to
this brief. K7 contract work follows the landed K6 relation and must retain the exact output basis
needed by subsequent stages.
