# Doccer K7 contract — exact-plan materialization

Runstamp 20260810_173159. **Status: D47 contract and reference implementation closed; harness
2639→2751 with zero warnings; K8 cross-carrier integration is the default next K lane.**

This brief adjudicates the
[K7 materialization read-ahead](../discussions/sol-doccer-k7-materialization-read-ahead-20260810_171743.md)
against the landed K6 carrier. It supersedes the provisional K7 plan/piece/residue language in the
[D40 correction](sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md), the
[K6 handoff](sol-doccer-k6-origin-contract-20260810_001537.md), and the architectural workplan
without reopening their sequencing decisions. K6 remains K7's sole required predecessor. D43's
`FactReference` remains an optional evidence seam; K5b saturation is not a dependency.

Inputs:

- the implemented [`OriginBasis`](../../../src/doccer/Origins/OriginBasis.cs) and
  [`OriginRelation`](../../../src/doccer/Origins/OriginRelation.cs) under D45;
- the implemented [`TextMaster`](../../../src/doccer/Core/TextMaster.cs),
  [`TextTopology`](../../../src/doccer/Core/TextTopology.cs), and
  [`SpanSet`](../../../src/doccer/Algebra/SpanSet.cs);
- D43's implemented [`FactReference`](../../../src/doccer/Facts/CanonicalFactTable.cs);
- the [decision canon](../planning/decisions.md), especially D7, D10, D12, D19, D40, D43, D45,
  and D46;
- the [architectural expansion workplan](../planning/architecture-expansion-workplan.md); and
- the [deferred Lean packet](sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md).

## 1. Disposition

K7 realizes a supplied **ordered output program**. It does not accept a patch set, choose among
candidate edits, or reconcile caller-supplied output coordinates:

~~~text
MaterializationTarget       output TextMaster identity + singleton output-slot tag
PieceOrigin                 piece-local output atom -> plan-source OriginAtom
OutputPiece                 Copy | OriginMapped | Synthetic
RewritePlan                 exact source OriginBasis + target + ordered positive pieces
MaterializedPiece           exact plan/output-master-stamped realized piece span
MaterializationResult       output master/basis + pieces + origins + unused sources
RewriteMaterialization      Materialize(plan)
~~~

Piece declaration order determines the complete output. Final output spans are consequences of
concatenation and exist only in the result. The engine can therefore validate and realize the plan
without owning conflict, ranking, or recovery policy.

Each positive output atom has exactly one material posture:

\[
OutputAtoms = OriginBearingAtoms\;\dot\cup\;SyntheticAtoms.
\]

Copy pieces derive their literal payload and one-to-one local origins from an exact source slice.
Origin-mapped pieces supply literal payload plus at least one source origin for every local output
atom. Synthetic pieces supply literal payload plus a required explanation and carry no origin
edge. Mixed posture is expressed by adjacent pieces at scalar boundaries, not nullable per-atom
state inside one piece.

The result always retains a new output `TextMaster`, its exact singleton output `OriginBasis`, the
exact plan, the realized positive piece partition, one K6 `OriginRelation`, and one unused-source
`SpanSet` per source slot. Unused source material is evidence of non-use by this output, not an
inferred semantic deletion.

## 2. Frozen public surface

The implementation chip owns these public names and essential signatures.

### 2.1 Piece kind and target

~~~csharp
public enum OutputPieceKind
{
    Copy = 0,
    OriginMapped = 1,
    Synthetic = 2,
}

public sealed class MaterializationTarget
{
    public MaterializationTarget(string documentId, long revision, string outputTag);

    public string DocumentId { get; }
    public long Revision { get; }
    public string OutputTag { get; }
}
~~~

`DocumentId` and `OutputTag` are required and nonblank under ordinal string semantics. `Revision`
is nonnegative. The target fields supply the output `TextMaster` constructor values and the tag of
the result's singleton `OriginSlot`. The slot tag is not silently derived from document identity.

`MaterializationTarget` is an immutable reference object with no value-equality, interning, or
persisted-identity promise. Equal field values can produce compatible output master values, but
the exact `RewritePlan` and result `OriginBasis` remain the in-process stamps.

### 2.2 Piece-local origins

~~~csharp
public readonly record struct PieceOrigin
{
    public PieceOrigin(int outputAtomOrdinal, OriginAtom source);

    public int OutputAtomOrdinal { get; }
    public OriginAtom Source { get; }
}
~~~

`OutputAtomOrdinal` is nonnegative and indexes the topology atoms of one literal piece before the
final output basis exists. `Source` is interpreted only against the exact `RewritePlan.SourceBasis`,
following the basis-relative `OriginAtom`/`OriginEdge` precedent. `PieceOrigin` has ordinary value
equality. The plan validates its source coordinate.

### 2.3 Closed output pieces

~~~csharp
public sealed class OutputPiece
{
    public OutputPieceKind Kind { get; }
    public int? SourceSlotOrdinal { get; }
    public TextSpan? SourceSpan { get; }
    public string? Literal { get; }
    public IReadOnlyList<PieceOrigin> Origins { get; }
    public string? SyntheticExplanation { get; }
    public FactReference? Derivation { get; }

    public static OutputPiece Copy(
        int sourceSlotOrdinal,
        TextSpan sourceSpan,
        FactReference? derivation = null);

    public static OutputPiece OriginMapped(
        string literal,
        IEnumerable<PieceOrigin> origins,
        FactReference? derivation = null);

    public static OutputPiece Synthetic(
        string literal,
        string syntheticExplanation,
        FactReference? derivation = null);
}
~~~

Construction is factory-only and freezes these states:

| Kind | Source slot/span | Literal | Origins | Synthetic explanation |
|---|---|---|---|---|
| `Copy` | nonnull | null | empty; derived during realization | null |
| `OriginMapped` | null | nonempty | canonical and locally total | null |
| `Synthetic` | null | nonempty | empty | required nonblank |

Non-applicable nullable properties return null; non-applicable collections are empty. Undefined
`OutputPieceKind` values cannot be constructed. An `OutputPiece` is an immutable reference object
with no value equality. Reusing the same exact piece at two plan positions emits it twice; ordered
multiplicity never collapses.

Literal means exact ordinal UTF-16 content. Whitespace is material and is allowed; only the empty
string is refused. An optional `FactReference` must be initialized and is retained exactly.

### 2.4 Plan, realized piece, and result

~~~csharp
public sealed class RewritePlan : IReadOnlyList<OutputPiece>
{
    public OriginBasis SourceBasis { get; }
    public MaterializationTarget Target { get; }
    public IReadOnlyList<OutputPiece> Pieces { get; }
    public int Count { get; }
    public OutputPiece this[int index] { get; }

    public static RewritePlan Create(
        OriginBasis sourceBasis,
        MaterializationTarget target,
        IEnumerable<OutputPiece> pieces);
}

public sealed class MaterializedPiece
{
    public RewritePlan Plan { get; }
    public int PieceOrdinal { get; }
    public OutputPiece Piece { get; }
    public TextMaster OutputMaster { get; }
    public TextSpan OutputSpan { get; }
}

public sealed class MaterializationResult
{
    public RewritePlan Plan { get; }
    public TextMaster OutputMaster { get; }
    public OriginBasis OutputBasis { get; }
    public IReadOnlyList<MaterializedPiece> Pieces { get; }
    public OriginRelation Origins { get; }
    public IReadOnlyList<SpanSet> UnusedSources { get; }
}

public static class RewriteMaterialization
{
    public static MaterializationResult Materialize(RewritePlan plan);
}
~~~

`RewritePlan.Create` snapshots the ordered piece sequence without deduplicating it and retains the
exact source basis and target references. `RewritePlan`, `MaterializedPiece`, and
`MaterializationResult` have reference identity. Result and realized-piece constructors remain
nonpublic so only the validated executor can mint them.

Every `MaterializedPiece` retains the exact plan and exact output master, making its span
self-stamped rather than meaningful only through list position. `PieceOrdinal` is validated and
`Piece` is the exact object at that plan position.

`UnusedSources` has exactly `Plan.SourceBasis.Count` entries in slot order. Entry `i` is a
`SpanSet` created on the exact master in source slot `i`; compatible duplicate slots remain
separate entries.

## 3. Copy semantics

`OutputPiece.Copy(slot, span, derivation)` names one plan-relative source slot and one nonempty
`TextSpan`. `RewritePlan.Create` validates the slot and calls the exact source master's
`ValidateSpan(span, allowEmpty: false)`.

The payload is always:

~~~csharp
plan.SourceBasis[slot].Master.Slice(span)
~~~

The caller does not supply a duplicate text value. Materialization relates each output topology
atom in that payload to the corresponding source topology atom tiled by the source span. The local
mapping is total, functional, injective, and order-preserving. At whole-result grain:

- repeating a copy legitimately makes origins non-injective;
- copying pieces out of source order legitimately reorders output;
- overlapping copy spans are legitimate shared/repeated source use; and
- compatible source slots remain distinct because edges retain slot ordinals.

Text equality never manufactures a copy origin. The exact instruction is required.

## 4. Origin-mapped literal semantics

`OutputPiece.OriginMapped` snapshots and canonicalizes `PieceOrigin` values by local output atom,
source slot, then source atom, collapsing exact duplicates. Its literal must be nonempty. Its local
topology is the ordinary `TextTopology` tiling of that string: Unicode scalars and preserved
unpaired UTF-16 surrogates.

Every local atom ordinal must occur in at least one `PieceOrigin`; no ordinal may fall outside the
local atom count. `RewritePlan.Create` separately validates every source `OriginAtom` against its
exact `SourceBasis`. Thus the mode can express contraction, expansion, duplication, reordering,
and general finite many-to-many performed-transform origins without introducing another relation
carrier.

The producer is responsible for the historical assertion. `OriginMapped` does not infer origins
from equal text, normalization behavior, edit distance, or correspondence. A post-hoc aligner must
retain D41/F7 promotion evidence before supplying these actual-origin declarations.

## 5. Synthetic literal semantics

`OutputPiece.Synthetic` snapshots one nonempty literal and one nonblank explanation. It produces no
K6 edge. The explanation is mandatory even when the piece carries a `FactReference`: synthesis
explains why an output atom has no source-material origin, while derivation evidence explains why
the plan chose the piece.

A piece cannot mix synthetic and origin-bearing local atoms. The caller splits mixed material at
scalar-atom boundaries. An atom created by contracting or transforming source atoms is
origin-mapped, not synthetic, because it has declared origins.

All-synthetic output is valid on a zero-slot source basis. A zero-slot basis cannot validate a copy
or origin-mapped source coordinate.

## 6. Scalar-safe piece concatenation

Every piece is positive material, but independent local topology is not sufficient. If one piece
ends with an unpaired high surrogate and the next begins with an unpaired low surrogate,
concatenation turns two local atoms into one supplementary scalar:

~~~csharp
"\uD83D" + "\uDE00" // one U+1F600 output atom
~~~

That would invalidate local output atom ordinals and the piece coverage partition. Therefore
`RewritePlan.Create` resolves each payload and refuses every adjacent boundary at which the prior
last code unit is high-surrogate and the next first code unit is low-surrogate. Equivalently, every
cumulative piece end must be a scalar boundary in the assembled output.

Unpaired surrogates remain legal inside a piece or at an output edge. D1 preserves them as
first-class atoms. If a surrogate pair is intended, both units occur in one literal or one
scalar-bounded copy span.

The plan also uses checked arithmetic for cumulative UTF-16 length. It exposes no final output
span; those coordinates do not exist until `Materialize` creates the output master.

## 7. `Materialize` and exact reconstruction

`RewriteMaterialization.Materialize(plan)` performs one direct deterministic pass:

1. resolve copy payloads from the exact source basis and use supplied literals unchanged;
2. concatenate payloads in declaration order under checked length;
3. create a new `TextMaster` from `plan.Target.DocumentId`, `Revision`, and the exact text;
4. assign each piece its cumulative positive scalar-bounded output span;
5. create one singleton `OriginBasis` containing the exact output master under `OutputTag`;
6. translate copy and piece-local origins into global `OriginEdge` values on output slot zero;
7. create one K6 `OriginRelation` from that exact output basis to the exact plan source basis;
8. verify the origin-bearing/synthetic atom partition; and
9. compute unused source material and return the immutable result.

The result invariants are:

- `OutputBasis.Count == 1`;
- `ReferenceEquals(OutputBasis[0].Master, OutputMaster)`;
- `ReferenceEquals(Origins.OutputBasis, OutputBasis)`;
- `ReferenceEquals(Origins.SourceBasis, Plan.SourceBasis)`;
- realized piece spans are positive, ordered, pairwise disjoint, meeting, gap-free, scalar-bounded,
  and cover `OutputMaster.Extent` exactly;
- each output slice equals its resolved piece payload, and their exact concatenation equals
  `OutputMaster.Text` under ordinal string equality;
- every origin-mapped/copy output atom has one or more edges;
- every synthetic output atom has no edge and one exact piece explanation; and
- no output atom is outside those two populations.

`OriginRelation.IsTotal` is not the K7 completeness predicate: a nonempty valid result containing
synthetic material is intentionally partial as an origin relation. K7 completeness is the union of
origin-bearing and explicitly synthetic output atoms.

The output is a new `TextMaster` object even when the target fields and text make it compatible
with a source. No source master, basis, piece, or fact table is mutated.

## 8. Empty output and unused source material

An empty plan has zero pieces and produces:

- a new empty `TextMaster` under the declared target;
- one singleton output basis carrying that exact empty master;
- zero output atoms and zero `MaterializedPiece` values;
- an empty relation retaining its exact output and source basis stamps; and
- every source atom in the corresponding unused-source entry.

This is distinct from K6's legal zero-slot basis: materialization always creates one output master
and therefore one output slot.

For source slot `i`, let `Used_i` contain exactly the source atoms named by at least one result
edge. `UnusedSources[i]` is the normalized union of every topology atom in that exact source master
not in `Used_i`. Meeting residue may merge; disconnected residue remains disconnected. The list is
deterministic and needs no caller policy.

The property is deliberately **unused source material**, not deletion. A source slot may be
context, and lack of an origin edge proves only non-use in this result. Semantic delete/replace
classification belongs to a separately named change model. Callers needing a narrower source
universe use D12 fragment-local masters or a D19 `TextSlice` child as the plan stage rather than
adding a K7 source-window carrier.

There is no unused-output-piece residue. Every supplied piece is emitted exactly once. Candidate
pieces rejected by conflict, ranking, or edit policy remain evidence of the upstream compiler or
selection result that produced the final `RewritePlan`.

## 9. Exact run identity and repeated composition

The exact `RewritePlan` reference is the input stamp. The exact result object, output master, and
output basis distinguish one in-process execution. Executing the same plan twice may produce
compatible output master values but creates distinct master objects, bases, relations, pieces, and
results. K7 performs no stage interning.

A subsequent plan composes directly only by retaining the prior exact output basis as its source
basis:

~~~text
first.Origins  : first.OutputBasis  -> original.SourceBasis
second.Origins : second.OutputBasis -> first.OutputBasis

second.Origins.ComposeOrigins(first.Origins)
  : second.OutputBasis -> original.SourceBasis
~~~

A reconstructed value-identical basis fails, as D45 requires. Matching tags, exact master
references inside a new basis, and compatible master clones do not substitute the middle object.

This operation composes **origin edges only**. It does not flatten synthetic explanations,
`FactReference` values, realized piece partitions, or unused-source residue. If the second stage
copies an atom that the first stage synthesized, that atom is origin-bearing relative to the first
output basis, while composition to the original basis yields no edge because the first-stage atom
had none. D47 makes no inference that the downstream atom is newly synthetic and does not copy the
first explanation onto it. Auditing that history requires retaining the exact ordered
`MaterializationResult` chain.

Consequently, origin-or-synthetic completeness is local to one result and its immediate exact
source basis. D47 adds no flattened stage-chain result, composed-synthesis carrier, or automatic
residue recomputation across stages.

One K7 plan may consume an ordinary multi-slot source basis and emit direct many-source origins.
D47 does **not** add automatic slot lifting when a later stage combines a prior output with new or
pass-through sources. Such a bridge requires a newly declared exact combined stage plus explicit
identity edges; tags and compatibility cannot infer it. A future named parallel/direct-sum helper
must be justified by a concrete K8/F7c consumer and reapply the K6 assurance gate.

## 10. Optional exact `FactReference`

Each output piece carries zero or one `FactReference? Derivation`. A supplied nullable value whose
contained struct is uninitialized/default is refused. A valid reference is retained as the exact
table object plus ordinal and is never rebound to a value-equal table or a post-saturation result
table.

`Materialize` does not inspect a `SupportHypergraph`, select a proof path, or require K5b. It does
not require the fact table's master to match a source slot: derivation and origin are independent
evidence sorts, and a fact may justify synthetic output. A producer-specific adapter may impose a
stronger relationship before constructing the piece.

`FactReference` does not count as a source origin and does not replace a synthetic explanation. A
future plural fact bundle or exact support path requires a separately named evidence carrier; K7
does not silently widen the D43 seam.

## 11. Refusal boundary

Construction refuses:

- null plan components, null pieces, null literal/origin sequences, and caller-sequence mutation
  after snapshot;
- blank target document IDs/tags, negative revisions, undefined piece kinds, and invalid nullable
  `FactReference` values;
- negative/out-of-range source slots or atoms and empty, out-of-range, or scalar-splitting copy
  spans;
- empty literal payloads, out-of-range local output atoms, or origin-mapped literals without at
  least one origin per local atom;
- synthetic pieces with origins, origin-mapped pieces with synthetic explanations, and blank
  synthetic explanations;
- adjacent payloads that fuse a high/low surrogate pair; and
- checked cumulative output-length overflow.

The contract does not refuse overlapping/repeated source use, source/output reordering,
many-to-many origins, compatible source masters in distinct tagged slots, empty plans, zero-slot
all-synthetic plans, whitespace payloads, or preserved unpaired surrogates.

Because the input is an ordered output program, K7 has no gap/overlap conflict policy and no
partial-success result. A valid immutable plan materializes completely; invalid construction fails
before a result exists.

## 12. Bounded executable witness

The implementation includes five fixture families.

1. **Construction and snapshot.** Cover target, factory, nullable-mode, source-coordinate,
   copy-span, local-origin, duplicate-collapse/canonical-order, caller-sequence mutation, checked
   length, and exact-reference validation.
2. **Material shapes.** Exercise copy, reorder, repeated/overlapping copy, contraction, expansion,
   many-to-many mapping, two compatible but separately tagged source slots, all-synthetic output,
   mixed origin/synthetic pieces, zero-slot input, and every mode-confusion refusal.
3. **UTF-16 boundary adversary.** Cover BMP, a supplementary scalar, preserved unpaired
   surrogates, refusal of cross-piece high/low fusion, acceptance of the same pair within one
   piece, and local-to-global atom-ordinal agreement.
4. **Result/evidence/composition.** Verify exact reconstruction, the stamped positive partition,
   disconnected per-slot unused material, empty output, exact optional `FactReference` retention,
   a two-stage exact-middle composition, compatible/value-identical clone refusal, and a copied
   first-stage synthetic atom whose composed relation remains empty without falsely inheriting a
   new local synthesis explanation.
5. **Independent finite plan census.** Over two one-atom source slots and five abstract archetypes
   (copy-left, copy-right, mapped-left, mapped-both, synthetic), enumerate every ordered plan
   through length three: (1+5+25+125=156). A separately written oracle must agree on output text,
   piece spans, canonical origin edges, origin/synthetic coverage, and used/unused source atoms.

Delivered-payload smoke must require all eight public names—`OutputPieceKind`,
`MaterializationTarget`, `PieceOrigin`, `OutputPiece`, `RewritePlan`, `MaterializedPiece`,
`MaterializationResult`, and `RewriteMaterialization`—and pin the constructors, factories,
properties, and `Materialize` entry point above.

## 13. Assurance disposition

The `K7-MATERIALIZE` gate was reapplied and remains deferred after the first direct implementation.
The critical properties are structural under the frozen signature:

- ordered concatenation constructs the unique gap-free partition;
- closed piece modes make local origin-or-synthetic coverage decidable;
- the cross-piece scalar-boundary check makes local topology ordinals additive;
- direct edge translation targets the already tested K6 relation; and
- the 156-plan independent census checks reconstruction, origins, synthesis, and residue together.

D47 claims no stage fusion, intermediate elision, automatic slot lifting, alternate backend,
streaming, parallelism, persistence, or non-obvious global reconstruction theorem. Directly
building one relation over a supplied exact multi-slot basis does not activate D45's novel
multi-source trigger.

Reapply, and activate if bounded executable evidence cannot own the claim, before:

- a streaming, fused, incremental, parallel, compressed, or independently implemented
  materializer claims the same complete result;
- intermediate masters or piece boundaries are elided while origins are claimed unchanged;
- an automatic multi-source slot-lift/direct-sum operation claims coherent composition;
- a persisted plan/result form claims cross-process identity; or
- a stronger global reconstruction theorem justifies a non-direct implementation.

## 14. Explicit non-goals

D47 does not add:

- patch coordinates, edit conflict detection, candidate ranking, rejection residue, recovery, or a
  partial materialization result;
- zero-width output pieces, deletion markers, sentinel origin coordinates, or empty `SpanBatch`
  claims;
- a second span/offset origin carrier, reverse-origin API, origin inference, `OffsetMap`, edit
  distance, alignment, correspondence, or promotion policy;
- normalization, transliteration, grapheme clustering, byte coordinates, or encoding maps;
- `SupportHypergraph`, support/path selection, plural fact evidence, or a K5b dependency;
- automatic basis retagging, compatible-master substitution, slot lifting, pass-through identity,
  DAG flattening, composed synthesis/residue, or materialization-stage composition beyond K6
  `ComposeOrigins`;
- persisted plan/run/stage IDs, wire forms, serialization, or cross-process equality;
- streaming/incremental/parallel/fused execution, a compressed backend, or performance promises;
  or
- domain-specific rewrite, macro, document, parser, or normalization semantics.

`OffsetMap` remains a future restricted single-source monotone projection. F7a correspondence is
independent; F7b performed-transform producers may already target K6; the K6/K7 carriers now leave
F7c promotion/materialization integration independently available. K8 next reuses K7 in bounded macro-substitution and
dynamic-expansion demonstrations without donating those domain policies to the kernel.

## 15. Landing gate and implementation handoff

The D47 contract-only chip closed when this brief, D47 in the decision canon, the
`K7-MATERIALIZE` assurance row, architectural workplan, roadmap, ledger, engine README, D40/D45
supersession notes, and deferred Lean packet agreed. That historical chip added no source type or
test, so the contract harness remained **2639**.

The following implementation chip owned:

- the exact public surface above under `src/doccer/Materialization/`;
- direct plan validation and `RewriteMaterialization.Materialize`;
- `tests/doccer/K7MaterializationTests.cs` with all five witness families;
- registration in the dependency-free harness;
- delivered-package inclusion and reflection smoke in `brewery/doccer/build-doccer.ps1`; and
- an implementation report appended below without reopening D47.

That source chip closed D7's final lift. K8 materialization witnesses are now the default
K-sequence work; F1/F7c integrations are independently available when prioritized.

## 16. Implementation report

Completed 2026-08-10. `src/doccer/Materialization/OutputPiece.cs` lands all three closed
factory-only piece postures together with exact target identity and canonical piece-local origin
values. Construction snapshots ordered inputs, preserves repeated piece-object multiplicity,
rejects uninitialized derivation references, and retains a valid `FactReference` opaquely even
when its table master is unrelated to every source slot. Origin-mapped literals are locally total;
copy geometry and every declared source atom are validated against the exact plan basis.

`src/doccer/Materialization/RewritePlan.cs` resolves and snapshots every immutable payload, uses
checked cumulative UTF-16 length arithmetic, and refuses a high-surrogate/low-surrogate fusion
across adjacent piece boundaries. `src/doccer/Materialization/RewriteMaterialization.cs` directly
concatenates those payloads into a new `TextMaster`, creates the exact singleton output basis,
freezes the positive gap-free plan/output-master-stamped piece partition, and translates copied or
declared origins into one K6 `OriginRelation`. Copy translation checks the full rebased atom span,
not only width. Every output atom is verified to be exactly origin-bearing or synthetic, and one
normalized unused-source `SpanSet` is returned for every exact input slot. Empty plans still mint
a new empty master and singleton basis while reporting all source atoms unused.

`tests/doccer/K7MaterializationTests.cs` supplies the five required witness families. Targeted
fixtures cover snapshots and refusals; copy, reorder, repetition, overlap, contraction, expansion,
many-to-many, mixed-source, synthetic, empty, and zero-slot shapes; BMP, supplementary, and lone-
surrogate material; local/global atom agreement; exact optional evidence; new-run identity; and
two-stage exact-middle composition including the copied-synthetic non-flattening case. The
independent census evaluates all **156** ordered plans through length three over five archetypes,
covering **430** realized piece positions, and agrees on output text, piece spans, canonical edges,
material posture, and used/unused source atoms.

The release harness is green at **2751 checks** (**2639→2751**) with zero compiler warnings. The
brewery publishes and smoke-tests the delivered payload, requires all eight K7 public names, and
pins enum values, carrier construction boundaries, factory signatures and optional derivation
defaults, properties, exact list/indexer shape, and `Materialize`. The implementation introduces no
patch/conflict policy, automatic slot lifting, stage fusion, persistence, alternate backend, or
support-graph execution. The first-backend `K7-MATERIALIZE` burden is discharged without activating
Lean; all reactivation triggers in section 13 remain intact. **K7 and D7's five-operation lift are
closed; K8 is the default next K lane.**
