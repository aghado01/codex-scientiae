# Doccer V1 portable vector and UTF-16 mask — implementation read-ahead

Runstamp: 20260810_013729

Status: implementation read-ahead and pressure test for D46; not an implementation authorization
or an independent decision record

## Question examined

What is the smallest V1 source tranche that can realize D41/D42's vector, scan, and harvest
obligations without making a UTF-16 text wrapper the generic Boolean carrier, importing a future
material-basis architecture, or silently turning packed `SpanSet` and suppression work into part
of the same chip?

This read-ahead is deliberately written before the V0 contract. Its job is to expose the source
and harness decisions that the contract must settle. Implementation remains forbidden until D46
freezes those decisions.

Inputs:

- the [round-two adjudication](../briefs/sol-doccer-expansion-round2-adjudication-20260806_093159.md);
- D42's assurance split in the
  [decision canon](../planning/decisions.md) and
  [deferred Lean packet](../briefs/sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md);
- the exploratory
  [material-basis and public-composability inquiry](sol-doccer-material-basis-and-public-composability-20260806_105530.md);
- the implemented [`TextMaster`](../../../src/doccer/Core/TextMaster.cs),
  [`TextTopology`](../../../src/doccer/Core/TextTopology.cs),
  [`SpanBatch`](../../../src/doccer/Core/SpanBatch.cs),
  [`ClaimSelection`](../../../src/doccer/Algebra/ClaimSelection.cs), and
  [`SpanSet`](../../../src/doccer/Algebra/SpanSet.cs); and
- the current 2324-check dependency-free contract harness.

## Executive disposition

V1 should be one bounded reference tranche with two public value layers:

~~~text
BooleanVector                     basisless finite Boolean sequence
  ├─ Boolean algebra / shifts / population / set-bit enumeration
  └─ forward inclusive prefix parity / adjacent transitions

Utf16UnitMask                     compatible-master + exact code-unit window + BooleanVector
  ├─ basis-checked mask algebra and typed scan continuity
  ├─ classifier-stamped known/unknown result
  └─ offset exit or scalar-safe span/claim harvest with explicit residue
~~~

The production reference may use a private `ulong[]`, but the public identity is logical length
plus bits. A separately written per-bit harness oracle owns the reference comparison. The first
prefix implementation should remain the obvious ordinal loop; a word cascade, carry-less
multiply, SIMD, fused classifier, or parallel block scan is V2 work even if the carrier already
stores words.

The UTF-16 wrapper should be explicitly named. V1 must not introduce a generically named
`UnitMask` whose only realizable basis is `TextMaster`, because `TextMaster` currently means a
.NET UTF-16 string. A small byte-backed test-local wrapper should exercise the raw vector to prove
that the generic algebra contains no text or UTF-16 assumption; it does not create a public byte
master or settle F3.

V1 should stop after the carrier, portable scan, classifier/residual shape, both exits, and their
executable laws. It should not absorb A1, a packed `SpanSet`, a D3 suppression bitmap, a JSON quote
scanner, a public word-layout API, a wire form, or V2 acceleration.

## As-built constraints

### Existing packed values cannot be reused as the generic carrier

`ClaimSelection` already stores membership in private 64-bit words and performs Boolean
operations wordwise. Its semantic universe is nevertheless one exact frozen `SpanBatch`; its bit
ordinal is occurrence identity. Prefix parity over those ordinals has no general claim meaning.
Reusing it would conflate a representation technique with a carrier.

`SpanSet` is a compatible-master normalized interval-list value. Equal, overlapping, and meeting
regions collapse. It is not a dense unit mask, and conversion from occurrence selections to
coverage does not commute with occurrence symmetric difference. A packed `SpanSet` remains a
future second backend under its own D42 equivalence gate.

### The reference material is concretely UTF-16

`TextMaster.Length`, offsets, regex results, and current topology are UTF-16-code-unit based.
Compatibility is value compatibility over document ID, revision, address unit, length, and raw
UTF-16 fingerprint. The new wrapper can use that compatibility rule honestly, but the raw vector
must not inherit it.

`TextMaster.ValidateSpan` enforces scalar boundaries. A unit mask is lower-level: its exact window
and set bits must be allowed at any in-range UTF-16 code-unit boundary. Scalar validity belongs to
harvest, not mask construction. Otherwise a chunk boundary or direct numerical result that falls
inside a surrogate pair would become unrepresentable before the explicit harvest gate can report
it.

### Claim construction is stricter than unit addressing

`SpanBatchBuilder.Add` accepts only nonempty scalar-bounded spans with explicit kind, level,
source, priority, and optional rule ID. V1 therefore cannot map every set bit directly to a claim.
It needs a pure scalar-safe span harvest first, with incomplete scalar atoms retained as unit
residue, followed by an evidence-bearing claim-emission step.

## Proposed V1 source surface

Names here are recommendations for D46 to adjudicate rather than already-frozen API.

### `BooleanVector`

The raw carrier should expose:

- logical `Length`, `Population`, and `IsEmpty`;
- validated bit lookup and ascending set-ordinal enumeration;
- `None(length)`, `All(length)`, and snapshotting construction from set ordinals;
- equal-length `Or`, `And`, `Xor`, `AndNot`, and `Not`;
- zero-filling shifts explicitly named toward higher or lower ordinals;
- parity reduction;
- forward inclusive prefix parity returning the state vector and carry-out; and
- adjacent-transition extraction given the state entering ordinal zero.

Equality and hashing use only logical length and logical bits. Length-zero is one ordinary value;
an all-zero length-(n) value remains different from every other length. Negative lengths,
negative shifts, invalid ordinals, and unequal-length binary operations fail loudly. A shift at
least the logical length returns the all-zero value of the same length.

The production representation may map ordinal `i` to bit `i & 63` in word `i >> 6`, but no
mutable word array, span over owned storage, or backend type escapes. V1 needs no public word view:
the value operations and set-ordinal exit already make the carrier directly usable. A later
copying or destination-writing word projection must be separately contracted if a consumer needs
it.

### Prefix parity and transitions

For input bits `x[0..n)` and entering state `c`, the canonical scan is forward and inclusive:

\[
y_i=c\oplus\bigoplus_{j=0}^{i}x_j,
\qquad
c_{out}=c\oplus\bigoplus_{j=0}^{n-1}x_j.
\]

The empty result is empty and returns its entering state unchanged. Adjacent transitions recover
the input:

\[
x_0=c\oplus y_0,
\qquad
x_i=y_{i-1}\oplus y_i.
\]

V1 should expose one canonical inclusive scan and derive any later exclusive view. The harness
must own the inverse laws, `P1(x) = P0(x) XOR All`, zero-carry linearity, logical-tail exclusion,
and every split of the chunk law:

\[
P_c(a{+}{+}b)=P_c(a){+}{+}P_{c\oplus Parity(a)}(b).
\]

### `Utf16UnitMask`

The wrapper should retain a `TextMaster`, an exact numeric `TextSpan` window, and one
`BooleanVector` whose length equals the window length. Construction validates numeric containment
in `[0, Master.Length]` but deliberately does not call scalar-boundary `ValidateSpan`.

Local vector ordinal `i` addresses material offset `Window.Start + i`. Equality uses compatible
master values, equal windows, and equal vectors. Binary operations additionally require those
same basis conditions and retain the left operand's master reference, following the current
`SpanSet` value posture. All direct mask algebra, shifts, population, and code-unit offset
enumeration remain valid even when a selected unit or window edge lies inside a surrogate pair.

The wrapper should not be called `BooleanVector`: text-basis validation and material addressing
are additional semantics. It should not be called unqualified `UnitMask`: V1 supplies only the
UTF-16 family member.

### Typed continuity

Raw vector chunks need only a Boolean carry. Chaining material windows needs more protection. A
typed UTF-16 prefix continuation should retain:

- the compatible master basis;
- the next expected code-unit offset; and
- the carry bit.

Its type fixes forward inclusive prefix parity, so an operation/convention string is unnecessary.
A continuation may start at any in-range code-unit offset. Consuming a mask requires a compatible
master and `mask.Window.Start == continuation.NextOffset`; the returned continuation advances to
`mask.Window.End`. A bare Boolean must not serve as an unstamped cross-window continuation.

### Classifier result and residual meaning

The smallest honest classifier integration is an immutable result retaining:

- an exact named classifier-stamp object;
- a `Matches` UTF-16 unit mask containing units known true; and
- an equal-basis `Unknown` mask containing units whose membership is unknown.

`Matches` and `Unknown` are disjoint. A unit in neither mask is known false. Completeness means
only that `Unknown` is empty. “Unsupported but nevertheless known” is different diagnostic
evidence and must not be encoded as unknown membership.

The classifier stamp should be a small exact-reference in-process identity with a required
nonblank name. It is inspectable but is not a registry, serialized ID, callback, or classifier
interface. A configured classifier owns one immutable stamp and attaches it to every result it
produces.

Raw prefix parity remains separate and complete. A lifted classifier scan returns a known-true
state mask, a propagated-unknown mask, and three-state carry evidence. With entering-carry
uncertainty `u` and event uncertainty `r`:

\[
R_i=u\lor\bigvee_{j=0}^{i}r_j,
\qquad
u_{out}=u\lor Any(r).
\]

After the first unknown event, later state remains unknown unless a future explicitly named
resynchronizing producer supplies stronger evidence. V1 does not pretend that two independently
unknown toggles cancel. Boolean combinators over classifier results are not needed in this chip;
adding one later must derive a new producer stamp and state its residual rule.

### Offset and scalar-safe harvest exits

The direct offset exit enumerates `Window.Start + i` for every set bit. It is always defined and
does not inspect topology.

The span harvest should examine the master's topology atoms rather than simply making one
one-code-unit span per bit:

1. a topology atom whose complete code-unit extent lies in the mask window and whose every unit
   is selected is admitted;
2. an atom with no selected unit contributes nothing;
3. every other selected unit belongs to scalar-boundary residue; and
4. adjacent admitted atoms normalize into one `SpanSet` region.

This admits a fully selected surrogate pair and a preserved one-unit unpaired surrogate, rejects
only the selected half of a valid pair, and handles a mask window that itself cuts a pair. The
admitted material and boundary residue are disjoint and together account for every selected unit.

Harvesting a classifier result additionally retains its unknown-membership mask as a separate
field. Unknown units are never emitted as known claims, and classifier uncertainty is never
collapsed into boundary residue.

Claim emission follows the pure span harvest. A required immutable emission stamp supplies the
fields needed by `SpanClaim`—kind, level, source, priority, and optional rule ID. Emission validates
the complete request and compatible unfrozen builder before adding anything, emits only admitted
nonempty spans in ascending order, and returns the created ordinals. It does not reinterpret or
erase either residual.

## Proposed implementation layout

A compact source layout is sufficient:

~~~text
src/doccer/Vectors/BooleanVector.cs
src/doccer/Vectors/Utf16UnitMask.cs
src/doccer/Vectors/UnitMaskClassification.cs
src/doccer/Vectors/UnitMaskHarvest.cs
tests/doccer/VectorContractTests.cs
~~~

The exact file split is not contractual. The public namespace remains `CodexSci.Doccer`.

The production raw value may use private canonical `ulong[]` storage. Construction and every
operation mask the physical tail; equality, hashing, population, carry, and enumeration ignore
physical bits beyond `Length`. Tests may use `InternalsVisibleTo` to inject poisoned final words,
but production callers receive no such constructor.

The independent oracle should use direct Boolean arrays or formulas and must not call production
Boolean, prefix, transition, harvest, or tail helpers. Compact storage is the V1 reference
implementation, not a claimed accelerated peer backend. V2 begins only when another execution
path claims to refine it.

## Harness plan

### Raw-vector census

- exhaust every vector and ordered vector pair through length eight;
- compare all Boolean operations, population, parity, lookup, enumeration, and every legal shift
  with the per-bit oracle;
- cover lengths `0, 1, 2, 63, 64, 65, 127, 128, 129` and randomized longer values;
- prove snapshotting, stable hash/equality, unequal-length refusal, and ascending enumeration; and
- inject poisoned tail words internally and prove that no semantic result observes them.

### Scan census

- exhaust every vector through length ten under both entering carries;
- check prefix and transition inverses, carry-out, complement, linearity, and empty behavior;
- check every binary chunk split and randomized multi-chunk partition, including zero-length
  chunks and word boundaries; and
- compare the production ordinal loop with a formula-only oracle.

### UTF-16 basis adversaries

- compatible clone equality and operation success;
- incompatible document ID, revision, text, length, and window refusal;
- empty and non-scalar-bounded windows as ordinary mask bases;
- selected BMP units, both units of a surrogate pair, each surrogate half alone, and preserved
  unpaired surrogates;
- direct offset enumeration without topology creation; and
- typed-continuation success across adjacent windows and refusal for gaps, overlaps, wrong basis,
  and wrong expected offset.

### Classification and harvest adversaries

- same-basis and disjointness validation for matches/unknown;
- complete, initially unknown, mid-window unknown, and empty lifted scans;
- conservative suffix uncertainty and three-state carry across chunks;
- full scalar admission, partial-pair residue, split-window residue, adjacent-region merge, and
  exact selected-unit accounting;
- unknown membership retained separately from scalar-boundary residue;
- compatible-builder claim emission with complete evidence and ascending returned ordinals; and
- invalid stamp, incompatible/frozen builder, and residual cases without partial mutation.

### Basis-neutrality probe

A test-local immutable byte-window wrapper should stamp a snapshotted byte array, numeric window,
and `BooleanVector`, then run the same raw algebra and chunk laws. It deliberately supplies no text
harvest and no public API. The probe fails if raw-vector code reaches for `TextMaster`, UTF-16,
surrogate logic, or a text window.

## Assurance disposition

V1 does not activate Lean. The raw algebra is finite and representation-independent, the initial
production code is the sole portable reference backend, and exhaustive short cases plus an
independent per-bit oracle can own the source tranche. The harvest law is a direct finite
partition over the already implemented topology atoms, with complete selected-unit accounting in
the harness.

Reapply the D42 gates before:

- any word-cascade, SWAR, carry-less-multiply, SIMD, parallel, or fused scan/classifier path claims
  equivalence;
- a public word layout or zero-copy view becomes contractual;
- harvest fuses classification or bypasses topology while claiming the same scalar-safe result;
- a generalized basis-stamped mask claims common UTF-8/UTF-16 semantics; or
- packed `SpanSet` or suppression work claims equality with existing values or queries.

## Explicit non-goals and stopping line

V1 does not add:

- a generalized material-master protocol, byte-addressed `TextMaster`, transcode map, or F3 wire
  identity;
- public mutable or zero-copy words, serialization, CLI commands, or a runtime operation registry;
- JSON strings, quotes, escapes, comments, tokenization, or another domain interpretation;
- `ClaimSelection` or `SpanSet` symmetric difference;
- A0/A1 selection optimization, packed `SpanSet`, or D3 suppression bitmap work;
- SIMD, architecture dispatch, pooled workspaces, parallel scan, or measured performance claims;
  or
- K6/K7 origins, normalization provenance, or a parallel lineage carrier.

The V1 tranche is complete when the raw value, UTF-16 wrapper, portable inclusive scan and inverse,
typed continuity, classifier uncertainty, direct offsets, scalar-safe harvest, claim-emission
evidence, byte-backed neutrality probe, and the stated differential/exhaustive harness are green.
It then yields the execution lane back to the already frozen K6 implementation before V2 or the
other bitmap-shaped proposals begin.

## Read-ahead conclusion for V0

The source pressure resolves the V0 question in favor of two carriers, not one:

1. a basisless `BooleanVector` owns the reusable algebra; and
2. an explicitly named `Utf16UnitMask` owns compatible-master/window addressing, typed
   continuity, classification, and harvest.

D46 should supersede D41's provisional single `V(M,W)` carrier language, admit arbitrary
in-range code-unit window boundaries, define unknown membership narrowly, keep word storage
private, and freeze the topology-atom accounting law for harvest. It should authorize only the
portable V1 tranche described here and preserve all D42 gates for later backends.
