# Doccer V0 contract — basisless Boolean vectors and UTF-16 unit masks

Runstamp 20260810_013731. **Status: V1 portable source implemented; D46's first-backend gates
closed; harness 2324→2536 with zero warnings.**

This brief supersedes D41's provisional single-carrier V0 language without reopening the other
round-two lanes. D42's carrier, scan, harvest, packed-region, and suppression-query assurance
obligations remain separate. D46 freezes only the first three obligations and authorizes their
portable V1 reference implementation; it does not authorize V2 or either packed semantic backend.

The contract follows the
[V1 implementation read-ahead](../discussions/sol-doccer-v1-portable-vector-read-ahead-20260810_013729.md),
which pressure-tested the source shape before this decision. The read-ahead remains explanatory;
this brief is authoritative where wording differs.

Inputs:

- the [D41 round-two adjudication](sol-doccer-expansion-round2-adjudication-20260806_093159.md);
- the D42 split in the [decision canon](../planning/decisions.md) and
  [deferred Lean packet](sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md);
- the exploratory
  [material-basis inquiry](../discussions/sol-doccer-material-basis-and-public-composability-20260806_105530.md);
- the implemented `TextMaster`, `TextTopology`, `SpanSet`, `SpanBatchBuilder`, and existing
  many-sorted algebra; and
- the 2324-check dependency-free contract harness at the implementation baseline.

## 1. Disposition and carrier split

D46 replaces the provisional basis-stamped vector `V(M,W)` with two values:

\[
B_n = \{0,1\}^n
\]

is the basisless finite Boolean vector, and

\[
U_{M,W}=(M,W,B_{|W|})
\]

is an explicitly UTF-16-code-unit-addressed mask on one `TextMaster` value and exact numeric
window. `BooleanVector` owns numerical algebra. `Utf16UnitMask` owns material addressing,
compatible-window refusal, typed scan continuity, classification stamps, and harvest.

The names are intentional. The raw carrier is generic because its contract contains no material
basis. The wrapper says `Utf16` because current `TextMaster` storage and coordinates are UTF-16.
D46 does not create an unqualified `UnitMask`, generalized master protocol, byte master, or claim
that UTF-16 is Doccer's only future material basis.

V1 landed ahead of the already frozen K6 source chip. This was an execution-order detour, not a
type dependency: V1 and K6 remain independent, K6's D45 contract is unchanged, and K6 resumed when
V1 closed. The following D45 implementation chip has since closed K6 at 2639 checks. V2 and all
other bitmap-shaped proposals remain later.

## 2. `BooleanVector`

`BooleanVector` is a sealed deeply immutable logical bit sequence with a non-negative `Length`.
Its public value consists only of that length and the bit at each ordinal.

The reference surface provides:

- `None(length)`, `All(length)`, and construction from validated set ordinals;
- validated bit lookup, `Population`, `IsEmpty`, and ascending set-ordinal enumeration;
- equal-length `Or`, `And`, `Xor`, `AndNot`, and `Not`;
- zero-filling `ShiftTowardHigherOrdinals(distance)` and
  `ShiftTowardLowerOrdinals(distance)`;
- `Parity` reduction;
- forward inclusive `PrefixParity(carryIn)` returning a vector plus carry-out; and
- `AdjacentTransitions(precedingState)` returning the inverse event vector.

Construction snapshots all caller-owned input and coalesces duplicate set ordinals. Negative
lengths or distances and out-of-range ordinals fail. Binary operations require equal logical
lengths; there is no implicit padding. A shift by at least `Length` produces `None(Length)`.

Value equality and hashing use logical length and logical bits. The unique length-zero vector is
ordinary. All-zero vectors of different lengths are unequal. An all-zero vector does not denote an
empty interval, empty claim selection, incomplete result, or missing value.

The V1 reference may store canonical private 64-bit words with ordinal `i` at bit `i & 63` of word
`i >> 6`. Physical tail bits beyond `Length` are always written as zero and never participate in
equality, hashing, population, parity, scans, shifts, or enumeration. Representation is not public
identity. V1 exposes no mutable words, owned-memory span, public backend type, wire layout, or
zero-copy promise.

## 3. Prefix parity, transitions, and raw chunk law

For input `x` of length `n` and Boolean entering state `c`, `PrefixParity` is forward and
inclusive:

\[
y_i=c\oplus\bigoplus_{j=0}^{i}x_j,
\qquad
c_{out}=c\oplus\bigoplus_{j=0}^{n-1}x_j.
\]

For `n = 0`, the output vector is length zero and `c_out = c`. Carry-out is a state, not an error.
Delimiter inclusion, unmatched-delimiter diagnosis, or another structural meaning belongs to a
higher producer.

`AdjacentTransitions(precedingState)` is the Boolean first difference:

\[
x_0=c\oplus y_0,
\qquad
x_i=y_{i-1}\oplus y_i\quad(i>0).
\]

The following are contract laws:

\[
D_c(P_c(x))=x,
\qquad
P_c(D_c(y))=y,
\]

\[
P_1(x)=P_0(x)\oplus All(n),
\qquad
P_0(a\oplus b)=P_0(a)\oplus P_0(b),
\]

and, for concatenated vectors `a ++ b`,

\[
P_c(a{+}{+}b)=P_c(a){+}{+}P_{c\oplus Parity(a)}(b).
\]

Only the inclusive form is primitive in V1. Any exclusive scan is derived and separately named if
later admitted. The raw chunk carry is one Boolean because `BooleanVector` has no material basis.

## 4. `Utf16UnitMask` basis and equality

`Utf16UnitMask` contains:

- a non-null `TextMaster`;
- an exact half-open numeric window `W = [start,end)` with
  `0 <= start <= end <= Master.Length`; and
- a `BooleanVector` of length `end - start`.

The mask constructor validates numeric code-unit bounds directly. It deliberately does not call
`TextMaster.ValidateSpan`: a code-unit window may begin or end inside a valid surrogate pair, and
individual interior units may be selected. This is safe for direct numerical/address use.
Scalar-bounded spans are a later harvest result.

Local bit ordinal `i` addresses UTF-16 code-unit offset `W.Start + i`. Ascending bit enumeration
therefore gives ascending material offsets after that translation. The empty-window and all-zero
mask are ordinary values.

Two masks are equal exactly when their masters are value-compatible under
`TextMaster.IsCompatibleWith`, their numeric windows are equal, and their Boolean vectors are
equal. Hashing uses the same compatible-master value fields, window, and vector value. Binary mask
operations require compatible masters and equal windows and retain the left operand's master
reference. They are named as mask/set operations—`Union`, `Intersect`, `SymmetricDifference`,
`Subtract`, and `Complement`—and delegate only after basis validation. Shifts preserve the exact
window and zero-fill inside it.

Compatibility never crosses address units. A future byte-backed mask over scalar-equal material
is not compatible with this UTF-16 mask and must not reuse its offsets.

## 5. Material scan continuity

One-shot mask prefix parity returns a `Utf16UnitMask` state value and a typed
`Utf16PrefixParityContinuation`. The continuation's type fixes forward inclusive parity and it
retains:

- the compatible `TextMaster` basis;
- `NextOffset`, the exact code-unit offset expected by the next mask window; and
- the Boolean carry state.

A seed continuation may be created at any numeric offset in `[0, Master.Length]`. Continuing a
scan requires a compatible master and `mask.Window.Start == NextOffset`. The result advances
`NextOffset` to `mask.Window.End`. Gaps, overlaps, reverse order, a merely scalar-equal different
address basis, or an incompatible master fail loudly.

A bare Boolean remains sufficient for raw `BooleanVector.PrefixParity` and for an explicitly
one-shot mask scan. It is not accepted as cross-window material continuity. Adjacent compatible
windows obey the raw chunk-concatenation law after local vectors are concatenated.

## 6. Classification and uncertainty

`UnitClassifierStamp` is a sealed exact-reference in-process identity with a required nonblank
name. It is an inspectable producer stamp, not a callback, registry entry, persisted identifier,
or claim source by itself. A configured classifier reuses one immutable stamp for its results.

`Utf16UnitClassification` retains:

- the exact `UnitClassifierStamp` reference;
- a `Matches` `Utf16UnitMask` containing units whose membership is known true; and
- an equal-basis `Unknown` mask containing units whose membership is unknown.

The masks must be disjoint. Units in neither are known false. `IsComplete` means `Unknown` is
empty. “The producer did not support some operation, but membership is nevertheless known” is
different producer evidence and must not be placed in `Unknown`.

The raw vector scan has no residual. The lifted classifier scan is a separately named result
retaining the source classification and classifier stamp, a known-true state mask, a propagated
unknown-state mask, and three-state carry evidence (`KnownFalse`, `KnownTrue`, or `Unknown`). If
entering carry uncertainty is `u` and event uncertainty is mask `r`, its inclusive uncertainty is:

\[
R_i=u\lor\bigvee_{j=0}^{i}r_j,
\qquad
u_{out}=u\lor Any(r).
\]

Known states before the first unknown event are computed normally. Every later state is unknown
unless a future named producer supplies explicit resynchronization evidence. Unknown events are
not assumed to cancel. D46 adds no generic Boolean algebra over classification results; a future
lifted operation must define its derived producer identity and residual propagation separately.

## 7. Direct exit and harvest bridge

The direct material exit enumerates `Window.Start + i` for each set bit. It is defined for every
mask, including interior surrogate units, and does not construct topology or validate scalar
boundaries. Direct callers may retain and compose the mask without harvesting it.

The pure scalar-safe span harvest partitions selected units using `TextTopology.Atoms`. For each
topology atom:

1. if its complete code-unit extent lies within the mask window and every unit is selected, its
   span is admitted;
2. if no unit in its intersection with the window is selected, it contributes nothing; and
3. otherwise every selected unit in that intersection is scalar-boundary residue.

Admitted atom spans are normalized into one compatible-master `SpanSet`, so meeting atoms may
merge while disconnected regions remain disconnected. A fully selected surrogate pair is
admitted. One selected half of a valid pair, or selected material in a window that cuts the pair,
remains residue. A preserved unpaired surrogate is a one-unit topology atom and may be admitted.

For a plain mask, admitted coverage translated back to unit bits and boundary residue are disjoint
and their union is exactly the selected bit population. For a classification result, unknown
membership remains a second, separately named residual and is never emitted as known material.
The harvest result retains its exact source mask or classification, admitted `SpanSet`, boundary
residual mask, and classification-unknown mask where applicable.

Claim emission consumes a completed harvest plus an immutable evidence stamp containing the
`SpanClaim` fields: required kind, defined level, required source, priority, and optional rule ID.
It emits only admitted nonempty spans in ascending order to a compatible unfrozen
`SpanBatchBuilder`, returns their created ordinals, and retains the harvest result for inspection.
All evidence, builder, compatibility, and frozen-state validation occurs before the first add, so
an invalid request does not partially mutate the builder. Emission neither clears nor converts
either residual.

## 8. V1 implementation and harness contract

V1 lands the compact portable reference value and both exits. Its direct per-bit oracle lives only
in the harness and shares no Boolean, scan, transition, tail, or harvest helper with production.
The initial production prefix scan may iterate logical ordinals even though ordinary Boolean
operations use private words. Calling private word storage a portable representation does not
turn it into a V2 accelerated backend.

The raw-vector harness must:

- exhaust all vectors and ordered pairs through length eight for construction, Boolean algebra,
  population, parity, lookup, enumeration, and shifts;
- exhaust prefix/transition laws through length ten under both carries and every binary chunk
  split;
- cover empty and `63/64/65`, `127/128/129` logical lengths plus randomized longer values and
  multi-chunk partitions;
- inject poisoned physical tails internally and prove semantic exclusion; and
- check snapshotting, equality/hash, deterministic ascending enumeration, and refusal cases.

The wrapper/bridge harness must cover:

- compatible clones; incompatible document, revision, text, length, and window bases;
- adjacent typed continuations plus gap, overlap, offset, and basis refusal;
- empty, BMP, surrogate-pair, half-pair, split-window, and unpaired-surrogate cases;
- topology laziness for direct operations and deliberate topology use only at harvest;
- complete and uncertain classification, initial/midstream uncertainty, conservative suffix
  propagation, and three-state carry;
- exact selected-unit accounting, separate residuals, normalized ordered span output, and
  transactional evidence-bearing claim emission; and
- a test-local snapshotted byte-window wrapper running the raw algebra and chunk laws without
  creating a public byte-master surface.

The delivered-payload smoke must include the public D46 carrier/result names and their essential
constructor/property/operation shape. The exact harness-count delta is recorded only when the V1
implementation report is appended to this brief.

## 9. Assurance disposition

The `V0-BOOLEAN-VECTOR`, `V0-UTF16-UNIT-MASK`, `V-PREFIX-SCAN`, and
`V-HARVEST-BRIDGE` gates are reapplied and discharged without Lean activation for V1. D46's raw
algebra is finite and direct, V1 supplies only one portable production backend, and the classifier
and harvest laws have complete finite reference decompositions over logical bits and existing
topology atoms.

Reapply signature pressure if a proof could change vector length/equality, mask compatibility,
window validity, continuity, classifier uncertainty, or harvest result shape. Reapply refinement
pressure before every V2 word-cascade, SWAR, carry-less-multiply, SIMD, parallel, architecture-
specific, or fused backend. A complete fixed-width certificate may discharge a kernel more
cheaply than Lean; bounded differential tests alone do not prove arbitrary-input equivalence.

The future `SPANSET-PACKED-EQUIV` and `D3-SUPPRESSION-BITMAP` gates are untouched. They remain
presumptive optimization-pressure activations when an alternate backend claims equality with the
existing arbitrary-input value or query.

## 10. Explicit non-goals

D46/V1 does not add:

- a generalized material basis, byte `TextMaster`, scalar-addressed master, transcode map, or
  portable material fingerprint;
- public word storage, serialization, CLI vector commands, or persisted mask identity;
- JSON quote/escape/comment semantics, tokenizer meaning, or another domain classifier;
- packed `SpanSet`, suppression bitmap, A0/A1 optimization, or `ClaimSelection` storage changes;
- `ClaimSelection` or `SpanSet` symmetric difference;
- V2 acceleration, performance claims, pooling, SIMD dispatch, or parallel scan; or
- K6/K7 origin or materialization types.

## 11. V1 exit gate and sequencing

V1 is closed only when:

1. the two public value layers and their refusal/equality rules are implemented;
2. Boolean, shift, parity, inclusive-prefix, transition, inverse, and chunk laws agree with the
   independent oracle;
3. typed material continuity refuses discontinuous or incompatible windows;
4. classifier unknown membership propagates conservatively and remains distinct from known false
   and producer-specific unsupported evidence;
5. direct offsets work for every unit mask without topology;
6. scalar-safe harvest accounts for every selected unit and keeps boundary and classification
   residuals separate;
7. claim emission carries explicit evidence and cannot partially mutate on invalid input;
8. the byte-backed test-local probe demonstrates raw basis neutrality; and
9. the source build, full contract harness, and delivered-payload smoke are green with zero
   warnings.

With the report below, V1 closes and the default execution lane returns to D45's K6 source
implementation. That returned lane subsequently closed at 2639 checks. V2, packed regions,
suppression acceleration, and A1 remain separate evidence-gated continuations.

## 12. V1 implementation report — 2026-08-10

The portable reference is implemented under `src/doccer/Vectors/`:

- `BooleanVector.cs` lands the sealed basisless logical value, private `ulong[]` storage,
  ascending set-ordinal enumeration, Boolean algebra, ordinal shifts, parity, forward inclusive
  prefix scan, and adjacent-transition inverse. An internal assurance constructor can preserve a
  poisoned final physical word; every public semantic path masks it out.
- `Utf16UnitMask.cs` lands the compatible-master/exact-numeric-window wrapper, absolute-offset
  enumeration, left-master-preserving algebra, scan results, and exact-offset typed
  `Utf16PrefixParityContinuation`. Construction and direct operations accept surrogate-interior
  boundaries without forcing `TextTopology`.
- `UnitMaskClassification.cs` lands exact-reference `UnitClassifierStamp`, disjoint known-match
  and unknown masks, `KnownFalse | KnownTrue | Unknown` carry evidence, and conservative unknown
  suffix propagation in a separately stamped result.
- `UnitMaskHarvest.cs` lands topology-atom harvest, normalized admitted `SpanSet`, distinct
  boundary and classifier-unknown masks, immutable `UnitMaskClaimStamp`, and claim emission that
  validates the compatible unfrozen builder and every claim before the first add.

The public result carriers are `BooleanPrefixParityResult`, `Utf16PrefixParityResult`,
`Utf16ClassificationPrefixParityResult`, `Utf16UnitHarvestResult`, and
`Utf16ClaimEmissionResult`. Their constructors remain nonpublic; results retain the exact source,
continuation, harvest, builder, or evidence references required by their contract.

The independent harness adds 212 checks and closes at **2536**. Aggregate census checks cover all
511 vectors and 87,381 ordered pairs through length eight; 4,094 vector/carry scans, all 40,962
binary splits through length ten, and 87,381 P0 linearity pairs; deterministic longer cases at
0, 63/64/65, 127/128/129, and twelve additional multiword lengths; and injected poisoned tails.
The UTF-16 suite covers compatible clones, basis/window/continuity refusal, direct topology
laziness, empty/BMP/pair/half-pair/split-window/unpaired atoms, exact selected-unit accounting,
classifier uncertainty, separate residue, and transactional evidence-bearing emission. A
test-local snapshotted byte-window wrapper exercises the raw scan without adding an engine byte
carrier.

`dotnet run --project brewery/doccer/Doccer.Tests.csproj -c Release` is green at 2536 checks.
`brewery/doccer/build-doccer.ps1` is also green: it republishes the delivered payload, records the
same count, runs the CLI smoke, and reflects the essential construction/property/operation shape
of every public V1 carrier and result. Both builds report zero warnings.

V1 is closed. No public word layout, V2 backend, packed `SpanSet`, suppression bitmap, generalized
material basis, byte master, A1 change, K6 type, or CLI vector command landed. The active default
execution lane returned to D45's K6 source implementation; D45's appended report now records its
subsequent closure and the K7 handoff.
