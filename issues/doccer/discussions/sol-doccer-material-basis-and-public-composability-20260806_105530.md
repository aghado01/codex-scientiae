# Doccer material basis, fidelity, and public composability — design inquiry

Runstamp: 20260806_105530

Status: exploratory report; not a decision record, roadmap amendment, or implementation contract

## Question examined

Doccer currently treats an immutable .NET UTF-16 string as the reference material and coordinate
space. That posture has protected exact source identity, scalar-safe spans, malformed-surrogate
evidence, and deterministic algebra. It has also begun to harden an implementation choice into an
architectural assertion:

> Is UTF-16 exactness a mandatory property of every Doccer computation, or one selectable material
> profile among several honest profiles?

The related design question is about the product shape of Doccer. The MATLAB/scikit-learn analogy
is not a request to copy either API. It describes a capability stack: low-level numerical values
and operations remain directly usable, higher capabilities compose them, and neither the core
library nor the CLI makes one end application the price of entry. Under that philosophy, masks,
bitmaps, columnar views, classifiers, and harvest operations are eventual public capabilities, not
private implementation details that only higher Doccer features may use.

This report examines the consequences without freezing an API or changing the decision canon.

## Executive conclusion

The design instinct is sound, but “precision” should not become one ordered setting with UTF-16 at
the top and UTF-8 below it. At least five independent choices are being compressed into that word:

1. which source material, including original bytes, is retained;
2. how decoded material is stored;
3. which units its coordinates address;
4. which boundaries operations may emit; and
5. which explicit transformations have changed the material.

UTF-8 and UTF-16 are both exact encodings of the same well-formed Unicode scalar sequence. They
have different code-unit coordinates and different malformed-input domains. Normalization is a
different operation: it can change the scalar sequence, move boundaries, and—especially for
compatibility forms—discard distinctions. Original-file fidelity is different again: once a file
has been decoded to a .NET string, its original byte spelling, BOM, and malformed byte sequences
may already be gone even though the resulting UTF-16 string is preserved exactly.

The useful architectural direction is therefore:

- keep UTF-16 as the current reference implementation and one high-fidelity material profile, not
  as the only legitimate carrier basis;
- make exactness relative to a declared material basis and transformation history;
- let a caller choose a basis/profile per material carrier or operation, not through an ambient
  process-wide switch;
- keep transcoding, normalization, replacement, and other changes explicit, with maps and loss or
  residual evidence proportional to the guarantee requested;
- shape the span algebra so it consumes any admitted finite ordered material basis while text-
  specific capabilities declare the bases they can actually read; and
- expose admitted low-level values and operations in the core and through a composable CLI
  surface, while keeping unsafe backend layouts private unless their layout itself is contracted.

A compact statement is: **UTF-16 should be Doccer's reference profile, not its sovereign
ontology; fidelity should be declared, not assumed; and foundational capabilities should be
publicly stackable.**

## What the current implementation actually commits to

The present source is clearer than the surrounding prose in several useful ways.

| Current fact | Evidence | Consequence |
|---|---|---|
| A `TextMaster` owns a .NET `string`. | [`TextMaster`](../../../src/doccer/Core/TextMaster.cs) | Storage, slicing, regex input, length, and coordinate units are concretely UTF-16 today. |
| `AddressUnit` has only `Utf16CodeUnit`. | [`TextTopology`](../../../src/doccer/Core/TextTopology.cs) | The enum anticipates a distinction, but no implementation is representation-plural yet. |
| Fingerprints hash the raw, host-endian UTF-16 code units. | [`TextMaster`](../../../src/doccer/Core/TextMaster.cs) | Identity preserves lone-surrogate distinctions, but it is neither a portable artifact identity nor original-file byte identity. |
| Topology decodes UTF-16 scalars and preserves an unpaired surrogate as an invalid scalar atom. | [`TextTopology`](../../../src/doccer/Core/TextTopology.cs) | The current “total topology” guarantee includes malformed UTF-16 strings, a guarantee a UTF-8 profile must replace with its own malformed-unit policy. |
| `TextSpan` is only an integer half-open interval; the master supplies the coordinate meaning and valid-boundary test. | [`TextSpan`](../../../src/doccer/Core/TextSpan.cs), [`TextMaster`](../../../src/doccer/Core/TextMaster.cs) | Most interval laws are not inherently UTF-16 laws. They can survive another basis if master compatibility and boundary validity stay explicit. |
| `IsScalarBoundary` and one reachability diagnostic speak specifically in UTF-16 surrogate terms. | [`TextMaster`](../../../src/doccer/Core/TextMaster.cs), [`ReachabilityView`](../../../src/doccer/Algebra/ReachabilityView.cs) | A plural master needs a representation-neutral material/atom-boundary operation; scalar validity remains a separate fact. |
| Regex collection reads `master.Text` and uses .NET regex indices. | [`RegexCollector`](../../../src/doccer/Collector/RegexCollector.cs) | The existing regex capability is properly UTF-16-specific unless it explicitly transcodes or a different collector is supplied. It should not force every other capability to share that basis. |
| The CLI uses `File.ReadAllText`, then reports a UTF-16 length and fingerprint. | [`Program.cs`](../../../brewery/doccer/Program.cs) | The current CLI has already decoded the input before Doccer sees it; it cannot claim original-byte fidelity or offer a byte-native execution choice. |
| Most K1–K4 algebra reads spans, ordinals, master length, compatibility, and scalar-valid boundaries rather than string contents. | [`src/doccer/Algebra`](../../../src/doccer/Algebra/) | A substantial part of the kernel is already close to basis-parametric in behavior even though its concrete master is not. |
| `GapCadenceResult` carries `AddressUnit`. | [`GapCadence`](../../../src/doccer/Algebra/GapCadence.cs) | The existing basis-stamp discipline is an architectural foothold rather than a new idea. |
| `SpanBatch` is columnar, but numeric columns and selection words remain private. | [`SpanBatch`](../../../src/doccer/Core/SpanBatch.cs), [`ClaimSelection`](../../../src/doccer/Algebra/ClaimSelection.cs) | The storage already supports set-at-a-time work, while the public surface currently forces row-wise or higher-level access. |

The tests intentionally enforce raw UTF-16 fingerprint distinction, preservation of both lone
surrogate kinds, rejection of surrogate-splitting span boundaries, total atom tiling, and lazy
construction. Those are valuable reference-profile guarantees. They do not by themselves prove
that every Doccer master must use that profile.

## The real conceptual split

### Encoding is not normalization

For well-formed Unicode text:

```text
UTF-8 bytes  <── exact scalar-preserving transcode ──>  UTF-16 code units
```

The coordinate spaces differ, but the scalar sequence need not. At scalar boundaries, a transcode
map can be exact in both directions. Interior code-unit boundaries do not correspond one-for-one,
which is why the bases must not be treated as compatible merely because their decoded text agrees.

Normalization is different:

```text
source scalar sequence  ── NFC/NFD/NFKC/NFKD ──>  transformed scalar sequence
```

Composition, decomposition, canonical reordering, contraction, expansion, and compatibility
folding can move or erase boundaries. This needs the richer mapping and residual posture already
explored in [`grok-offsetmap-unicode.md`](grok-offsetmap-unicode.md). Encoding conversion should
not automatically inherit normalization's ambiguity, and normalization should not be disguised as
choosing a cheaper encoding.

### UTF-16 exactness is not original-source exactness

The present fingerprint answers:

> Are these two in-memory .NET strings identical as UTF-16 code-unit sequences, including lone
> surrogates?

It does not answer:

> Were these strings decoded from the same source bytes under the same encoding and error policy?

Two byte files can decode to the same string while differing in BOM, encoding, or malformed-byte
handling. Conversely, byte-addressed UTF-8 and code-unit-addressed UTF-16 masters can carry the
same scalar content while being intentionally different coordinate spaces. If byte-level fidelity
matters, the raw asset or a byte master must exist; declaring a decoded UTF-16 string “gold” cannot
recover it.

### Precision is a profile, not a scalar rank

A useful design vocabulary would keep the axes independent. The names below are descriptive, not
proposed API names.

| Axis | Example choices | What it controls |
|---|---|---|
| Source retention | no parent; raw bytes retained; source master retained; full lineage retained | what can be reconstructed or cross-examined later |
| Storage representation | UTF-8 bytes; UTF-16 code units; possibly scalar-value storage | memory layout and available fast paths |
| Address unit | byte; UTF-16 code unit; scalar ordinal; another explicitly indexed grain | what `Start`, `End`, length, masks, and persisted coordinates mean |
| Boundary rule | any storage-unit boundary; scalar-safe boundary; later grapheme-safe view | where spans and harvested claims may begin or end |
| Malformed-input policy | preserve malformed units as atoms; refuse; replace with recorded loss | whether invalid encodings remain distinguishable |
| Transform history | identity; transcode; NFC/NFD; NFKC/NFKD; case fold; custom transform | whether material content or only representation changed |
| Evidence posture | no lineage requested; exact map; ambiguous map; residual/loss summary | which provenance or round-trip claims remain available |

The umbrella profile should not become the coordinate-compatibility key. Three groups should stay
separate:

- **compatibility fields:** logical addressed-unit sequence, address unit, logical length,
  boundary/invalid-segmentation contract, document/revision identity, and a canonical material
  commitment;
- **storage/execution fields:** UTF-8/UTF-16/scalar backing, indexes, caches, vector tier, pooling,
  and other choices that need not change coordinates when they implement the same logical basis;
  and
- **lineage/evidence fields:** retained source assets, transform identity, coordinate/origin maps,
  and loss or residual records.

For example, a scalar-addressed master backed by UTF-8 plus an index can potentially be compatible
with an identical scalar-addressed master backed by UTF-16. A byte-addressed UTF-8 master and a
UTF-16-code-unit-addressed master cannot be coordinate-compatible even when their scalar content
agrees. Likewise, two target masters may be compatible despite having different optional lineage,
just as current `TextSlice` lineage is external to the child master's value compatibility.

There is no useful total ordering across these profiles. A UTF-8 master can be source-byte exact
and scalar exact. A UTF-16 master can preserve unpaired surrogates that Unicode-scalar UTF-8 cannot
represent. A normalized master can be the most appropriate exact basis for a search computation
while being intentionally non-identical to the source. A scalar-indexed view can make codepoint
operations simpler while costing more memory than either encoded form.

If the CLI eventually offers named presets such as a fast UTF-8 working profile or a maximal-
retention profile, the preset should expand into explicit fields in the result/artifact stamp. The
preset name alone must not become the contract.

## Material carriers and transformation evidence

A representation-plural stack can still retain Doccer's strongest existing rule: every span is
meaningful only on one declared coordinate space.

~~~mermaid
flowchart LR
    R["Optional raw source asset"] --> D["Decode or transcode producer"]
    D --> M0["Material master: basis + validity policy"]
    M0 --> N["Explicit normalization or transform"]
    N --> M1["Derived material master"]
    M0 --> C0["Classifier"]
    M1 --> C1["Classifier"]
    C0 --> U0["Basis-stamped unit mask"]
    C1 --> U1["Basis-stamped unit mask"]
    U0 --> A["Public bit/mask algebra"]
    U1 --> A
    A --> X["Direct numerical consumers"]
    A --> H["Harvest under boundary policy"]
    H --> B["SpanBatch / selections / higher algebra"]
    D -.-> E0["Coordinate and loss evidence"]
    N -.-> E1["Origin/map and loss evidence"]
~~~

Several consequences follow.

1. **Basis selection belongs to the master or operation input.** A process may retain a raw source,
   use a UTF-8 working master for byte-oriented classification, materialize a normalized master for
   search, and use a UTF-16 view for .NET regex in the same job. One ambient “Doccer encoding”
   setting would make that composition impossible or implicit.
2. **Same content is not automatically same coordinate identity.** Differently addressed UTF-8
   and UTF-16 masters over equivalent text need an explicit scalar-preserving map or
   correspondence. They must not pass `IsCompatibleWith` merely because decoding gives the same
   scalar sequence. Storage-only differences need not break compatibility when the logical
   addressed basis and canonical material are identical.
3. **Exactness is operation-relative.** Boolean mask algebra can be exact over UTF-8 bytes while a
   Unicode property classifier reports residual for malformed or undecoded regions. An exact
   Jaccard result over those masks says nothing about source-normalization equivalence unless that
   basis is part of the contract.
4. **Capabilities can be basis-selective.** Interval union and Allen classification need an ordered
   boundary carrier. Regex currently needs UTF-16 strings. An ASCII structural classifier may
   prefer UTF-8 bytes. A capability should either accept the supplied profile, request an explicit
   adapter, or refuse; it should not silently change the basis.
5. **Source retention can be optional without dishonesty.** A caller who does not need reverse
   projection may discard a source or map to save memory. The resulting master remains a valid
   coordinate space; it simply cannot claim provenance or round-trip guarantees it chose not to
   retain.

### Mapping cases should remain distinguishable

| Relationship | Typical mapping guarantee |
|---|---|
| Slice/rebase in one basis | total affine translation over the admitted window |
| Well-formed UTF-8 ↔ UTF-16 transcode | scalar sequence preserved; scalar boundaries map exactly; interior code-unit boundaries differ |
| Decode with malformed input | depends on preserve/refuse/replace policy; replacement must report loss if identity matters |
| NFC/NFD | scalar sequence may expand, contract, or reorder; interior mappings can be ambiguous |
| NFKC/NFKD | compatibility distinctions may be irrecoverably lost |
| Case fold/transliteration/custom rewrite | separately named transform and loss contract |

This argues against one untyped `OffsetMap` being asked to make every relationship look alike.
The mappings may share a query algebra, but their construction kind and guarantees should remain
visible.

## How much of Doccer would actually have to change

The likely refactor boundary is narrower than “rewrite Doccer for UTF-8.”

### Largely representation-independent

- `TextSpan` interval predicates and Allen relations;
- normalized `SpanSet` Boolean operations;
- occurrence selections and pair relations;
- candidate graphs, reachability, partitions, and path selection;
- packing, cover, laminar, hierarchy, and resolution validation; and
- most basis-stamped measures once their address unit is not assumed.

These components operate on integer geometry and master/batch identity. Their laws can be stated
over any finite ordered address carrier with a declared set of valid boundaries.

### Representation-sensitive seams

- master storage, slicing, length, fingerprinting, and compatibility;
- scalar/invalid-unit decoding and line topology;
- `IsScalarBoundary` and complete-boundary enumeration;
- regex collection and any other API whose native indices are UTF-16;
- fingerprint persistence and byte order;
- text materialization and output encoding;
- CLI input decoding and output artifact stamps; and
- the proposed vector substrate's unit basis, chunk carry, and harvest boundary rules.

This suggests avoiding generic type parameters throughout the algebra merely to express storage
encoding. A master can carry a runtime basis value and provide the small set of material/boundary
operations the geometry requires. Text-reading kernels can then have explicit UTF-8, UTF-16, or
scalar-capable entry points. Whether that is implemented through one discriminated master, sibling
master types, or a small internal protocol remains an open engineering choice.

## Architectural options

### Option A — UTF-16 master, UTF-8 only as an internal execution buffer

Keep `TextMaster` and all public coordinates UTF-16. Individual classifiers may encode a window to
UTF-8, run a byte kernel, then map results back before returning.

Advantages:

- minimal disruption to the current source and tests;
- direct reuse of .NET string and regex APIs; and
- only one public coordinate space.

Costs:

- UTF-8 remains an optimization, not a caller-selected material basis;
- transcoding and dual buffering can erase the memory/performance gain;
- direct UTF-8 masks cannot be retained or composed publicly without an immediate round-trip; and
- original UTF-8 byte coordinates still disappear at ingestion.

This is a useful compatibility bridge, but it does not satisfy the full capability-stack goal.

### Option B — one basis-bearing material master

Generalize the master concept so it declares a logical address basis, boundary/validity policy,
and canonical material fingerprint while a tagged storage backend supplies the bytes/code units
and indexes. Storage representation participates in compatibility only when it defines the
addressed units. Existing `TextMaster` becomes the UTF-16 construction path or reference profile.

Advantages:

- one span/algebra vocabulary across admitted bases;
- caller-selected in-memory representation is first-class;
- masks, batches, maps, and CLI artifacts can carry one uniform basis stamp; and
- the existing `AddressUnit` foothold becomes meaningful.

Costs:

- `Text`, `Slice`, topology, fingerprinting, regex, and materialization contracts must be split or
  generalized;
- runtime branching or adapter dispatch can leak into hot paths if the boundary is poorly placed;
- invalid UTF-8 and invalid UTF-16 need parallel honest policies; preserved invalid UTF-8 must
  specify deterministic subsequence segmentation and a tagged raw payload rather than pretending
  an invalid byte is a Unicode scalar; and
- a large breaking refactor is possible if implemented before the common protocol is proven small.

### Option C — distinct concrete masters with shared geometry capabilities

Keep a concrete UTF-16 `TextMaster`, add a UTF-8/byte material carrier, and let geometry operate
through a shared basis identity or duplicate thin typed entry points.

Advantages:

- representation-specific operations stay statically explicit;
- each master can expose efficient native memory without a discriminated union; and
- current UTF-16 behavior need not be weakened.

Costs:

- generic proliferation, adapters, or duplicated carrier families can spread through the API;
- cross-basis composition becomes more verbose; and
- public discoverability may suffer if every operation has parallel type families.

### Option D — raw source asset plus derived material masters

Retain input bytes and decoding metadata as an optional source asset, then mint one or more decoded
material masters. This is complementary to B or C rather than a complete replacement.

Advantages:

- makes original-byte fidelity truthful;
- permits re-decoding under another policy without rereading external state; and
- gives F2 persistence and K6/K7 origins a clean source anchor.

Costs:

- additional memory and lifecycle management;
- byte assets are not automatically text coordinate spaces; and
- many callers correctly will not need or want to retain them.

### Working preference, not a decision

Option A is an insufficient endpoint but a viable experiment. The most coherent long-term family
looks like B or C with optional D: basis-bearing material carriers, optional raw-source retention,
and explicit transforms between them. The choice between one generalized master and sibling
concrete masters should be settled by a small prototype, not by vocabulary alone.

The lowest-sprawl prototype is likely one sealed master surface with a tagged internal material
backend. It would test whether the basis-specific protocol can remain small without sending
generic parameters through every algebra type. That is a prototype preference, not yet a reason
to reject sibling concrete masters.

Any byte-backed immutable master also needs an ownership rule. `ReadOnlyMemory<byte>` prevents
writes through that particular view but does not make its backing array immutable. Construction
should snapshot/copy by default or use a separately named trusted-ownership contract whose caller
cannot mutate storage after identity is minted.

## Normalization under this model

The existing D11 intent is valuable but its sentence “the engine never normalizes Unicode” is too
absolute. The stronger formulation is:

> Doccer never normalizes implicitly. Normalization is an explicit, selectable capability that
> produces a declared target master and, when requested, mapping/loss evidence.

That permits all of the following honest uses:

- analyze the exact source representation and never normalize;
- normalize to NFC, retain the source and map, and project selected results back;
- normalize or fold for a disposable search/index master with no reverse-projection promise;
- use UTF-8 or UTF-16 storage before or after normalization; and
- compare results across profiles without claiming coordinate compatibility.

Fidelity remains paramount as an honesty rule: Doccer must not silently discard distinctions and
then report exact-source semantics. It need not force every caller to pay the storage and mapping
cost of guarantees the caller explicitly declines.

## Public composability is the other half of the issue

The MATLAB/scikit-learn analogy is about portfolio architecture:

- foundational numerical values are usable directly;
- transforms return reusable fitted or derived artifacts;
- operations compose without requiring a single prescribed pipeline;
- higher-level conveniences do not hide the lower layer; and
- applications choose combinations after the capability library exists.

This intent already agrees with D12's “library of primitives, never a pipeline” and much of D13's
à-la-carte DLL/CLI posture in the [decision canon](../planning/decisions.md). The tension is with
decisions and [roadmap language](../planning/roadmap.md) that treat low-level public exposure as
unnecessary until one existing higher-level consumer asks for it. D20 keeps numeric `SpanBatch`
columns internal, D26 keeps the Allen raw mask private, `ClaimSelection` keeps its words private,
and D41 currently describes a future vector carrier while still leaving its public shape open.

The owner's stated capability-stack goal is itself evidence for publicness: a coherent semantic
primitive may be public when its own contract closes even if no higher-level application has yet
requested it. This changes what can justify public admission; it does not relax Doccer's contract,
reference, residual, assurance, and documentation gates. Concrete consumers can still prioritize
work and validate ergonomics without becoming the authority that permits a primitive to exist.

Those choices are not all equally problematic:

- Keeping Allen's 13-bit layout private protects a semantic value from becoming a wire/layout
  contract; callers already have the full Boolean algebra they need.
- Keeping `SpanBatch` numeric columns private prevents caller-defined columnar kernels without a
  row projection. `ClaimSelection` already exposes ordinary Boolean composition; its private words
  specifically prevent caller-defined packed kernels, zero-copy interop, and custom set-at-a-time
  algorithms rather than preventing union/intersection/subtraction themselves.
- A future unit mask that can only be consumed by internal classifiers would directly contradict
  the “one carrier, two exits” and numerical-stack goals.

The existing public mask-like values also must not be collapsed merely because they can all have
packed implementations:

| Value | Basis and meaning |
|---|---|
| `SpanSet` | normalized material regions on one master |
| `ClaimSelection` | occurrence ordinals on one exact frozen batch |
| future text-unit vector | Boolean membership over units in one exact material window |

A basisless numerical bit vector may usefully sit below them, but crossing from it into any of
these semantic values must supply the appropriate universe/basis stamp and validation.

The appropriate distinction is not public versus low-level. It is **semantic primitive versus
accidental backend representation**.

### A three-tier exposure model

1. **Public numerical and semantic values.** A raw immutable bit vector can supply word-level
   Boolean operations, shifts, population/count scans, rank/select or set-bit walking, and
   destination-writing kernels. Basis-stamped wrappers then provide unit masks,
   completeness/residual operations, classifier outputs, harvest, selections, and regions.
2. **Public performance views where needed.** Read-only spans/memory, destination-writing kernels,
   word enumeration, and column views can permit zero-copy composition. Their lifetime, ordering,
   tail-bit, and mutability rules must be explicit. A copying export can coexist with a borrowed
   view. A deliberate `SpanBatchColumns`-like value could expose starts, ends, priorities, levels,
   and interned IDs without returning mutable ownership of the backing arrays.
3. **Private backends.** AVX/NEON tiers, pool ownership, padding, unsafe casts, cache block sizes,
   and alternative internal layouts remain implementation details unless a genuine interop format
   deliberately freezes them.

This permits a low-level public core without publishing every internal array or locking the engine
to one packed representation.

Public accessibility is necessary but not sufficient for stacking. Result values intended to feed
later capabilities should retain their basis/policy or be accepted directly by a named next
operation. Existing terminal or weakly stamped projections—including some list-returning run,
group, join, and record views—deserve a compositional-closure audit. The answer need not be to wrap
every list; it is to identify which outputs are evidence-bearing carriers and ensure those do not
lose the identity another capability needs.

### What public CLI composability requires

A CLI cannot stack in-process values merely by printing human-readable summaries. Low-level
capabilities need an artifact or stream contract. A public mask artifact would minimally stamp:

- carrier sort, source/material identity, and exact window;
- logical address unit, boundary rule, and validity/invalid-segmentation policy;
- storage representation/encoding when it defines the addressed material;
- logical vector length;
- bit/word order and tail-bit convention if packed words cross the process boundary;
- classifier or producer identity and parameters;
- completeness/residual basis; and
- transformation-profile identity or a reference to its material descriptor; and
- format version plus canonical fingerprint algorithm/version and commitment value.

The CLI need not mirror every C# method as an unrelated top-level verb. It can expose a coherent
`material`, `mask`, or `vector` command family, or accept a declarative operation recipe whose
nodes are public Doccer capabilities. Either way, a caller must eventually be able to:

1. create or read a basis-stamped mask;
2. apply primitive mask operations;
3. inspect or serialize the result;
4. feed it directly to another low-level capability; and
5. harvest spans/claims only when that conversion is actually wanted.

That is the CLI analogue of the direct peer-carrier exit. It is not a demand to expose MATLAB or
scikit-learn syntax.

A closed vector/mask carrier can receive its own wire form and CLI family without waiting for a
universal `SpanBatch` format, K5/K6 identities, or a future document-node schema. Its artifact must
be honestly local to that carrier rather than pretending to settle those unrelated formats.

For exploratory or highly iterative use, a long-lived JSON-RPC/REPL session with in-memory carrier
handles is another viable surface. A hybrid can keep ordinary one-shot task commands while a plan
evaluator or session avoids serializing every intermediate Boolean operation. All three modes
should share the same typed contracts and implementations rather than acquire separate semantics.
A runtime operation registry is optional; if one is later useful for recipes or sessions, it must
preserve the many-sorted carrier types instead of becoming an untyped dispatch bag.

## Performance consequences

UTF-8 should be an available basis, not presumed faster in every workload.

- ASCII-heavy material usually occupies half the memory of UTF-16 and aligns naturally with many
  byte-oriented classification/SWAR/SIMD techniques.
- Non-ASCII UTF-8 is variable-width and may need more decoding and boundary tracking; CJK-heavy
  UTF-8 material can be larger than UTF-16.
- UTF-16 integrates directly with .NET strings and regex, while supplementary scalars still span
  two units.
- Holding UTF-8 and UTF-16 copies simultaneously can cost more than either design alone.
- Scalar-ordinal indexing can simplify codepoint operations but requires an index or expanded
  storage.
- A fully materialized atom topology may dominate the retained text size in either encoding, so
  lazy topology and profile-specific caching matter as much as the raw text buffer.
- Byte-oriented SIMD classifiers can examine twice as many source units per fixed-width register
  as `ushort` classifiers for ASCII work. Packed Boolean mask words still carry the same number of
  bits; UTF-8 harvest simply needs continuation-byte awareness before emitting scalar-safe spans.
- Normalization may improve downstream matching or feature sparsity while adding a transform,
  allocation, and map cost.

The correct benchmark question is therefore per capability and profile: material size,
allocation, decode/classify throughput, mask density, harvest cost, random versus sequential
access, and any transcode/cache cost. UTF-16 remains a valuable reference for differential
semantics even when a UTF-8 path wins a workload.

## Consequences for existing planning, if this direction is later adopted

This report does not make the amendments below. It identifies where a later decision would land.

| Existing item | Consequence to examine |
|---|---|
| D1 | Recast raw UTF-16 fingerprinting as the current UTF-16 reference-profile identity, not the universal fidelity definition. Portable identities must name logical address basis, validity/invalid-segmentation policy, algorithm/version, and canonical unit serialization; storage encoding belongs in identity only when it defines the addressed material. |
| D10 | “Preserves literal source material” should mean no silent destruction or false provenance claim. An explicitly selected lossy transform can still be a core capability if its target and loss are honest. |
| D11 | Change “never normalizes” to “never normalizes implicitly”; normalization can be a native explicit producer. |
| D12 | Strengthen the primitive-library doctrine with representation/basis independence where the mathematics permits it. |
| D13 | Treat material profile as execution/material policy rather than domain knowledge; make low-level artifacts stackable through the CLI. |
| D20 | Revisit consumer-gated numeric-column visibility. The capability-stack posture may itself justify a stable read-only column surface without exposing mutable arrays. |
| D25/K0 | Register material bases/address units and their compatibility separately from the existing span/occurrence/fact/origin sorts. |
| D33–D39 | Preserve their geometry laws over a basis-bearing master; avoid rewriting the algebras unless a hidden UTF-16 assumption is found. |
| D41 V0–V2 | Do not let the first UTF-16 unit vector take the generic name if basis plurality is intended. Either make UTF-16 one explicit family member or prove a basis-stamped common carrier first. |
| F2/F3 | Persistence and coordinate maps must stamp basis. Byte addressing is not merely an adapter concern if a byte-addressed master becomes first-class. |
| K6/K7/F7 | Transcoding, normalization, and materialization produce different mapping/origin guarantees but should compose through the same explicit evidence discipline. |
| F8/F9 | Hashes, measures, feature projections, and fitted artifacts must name their input basis and preprocessing profile; no default UTF-16 identity may leak into an ostensibly general artifact. |

The time-sensitive item is V0: a concrete implementation should not freeze a generically named
vector carrier as UTF-16-only before this basis question is settled. The current UTF-16 plan can
still be implemented as an explicitly named reference member without foreclosing the family.

## Failure modes to avoid

1. **A global `Precision` enum.** It suggests a total order and encourages capabilities to infer
   unrelated choices from one value.
2. **Calling UTF-8 lossy.** It is lossless for well-formed scalar content; loss comes from decoding
   policy, discarded source bytes, or transforms—not from the encoding name alone.
3. **Calling decoded UTF-16 the original source.** It may be exact to the in-memory string while
   already differing from the input bytes.
4. **Silent transcoding or normalization.** Convenience orchestration may perform an opted-in
   conversion, but the produced basis and evidence must be visible.
5. **Cross-basis compatibility by decoded equality.** Equal scalar content does not make
   differently addressed offsets interchangeable. Conversely, storage-only differences should
   not force incompatibility when the logical address basis and canonical material are identical.
6. **Genericizing the entire algebra prematurely.** Most geometry can remain non-generic if the
   master protocol owns basis and boundary behavior.
7. **Exposing mutable arrays as “public composability.”** Public zero-copy access must not let a
   caller invalidate frozen basis identity.
8. **Keeping semantic primitives private to protect implementation freedom.** A stable immutable
   mask algebra can be public while its word packing and SIMD backend remain private.
9. **A CLI that only emits reports.** Without reusable artifacts or streams, low-level commands
   cannot actually stack.
10. **Forcing provenance storage on every fast path.** Honest opt-out is compatible with Doccer;
    false or silent provenance is not.

## Small probes that would answer the open design questions

No production refactor is needed to learn the important facts.

1. **Basis protocol spike.** Implement a throwaway UTF-16 and UTF-8 master adapter exposing length,
   fingerprint identity, scalar-safe boundary validation, slicing/copying, and atom enumeration.
   Count how many existing geometry signatures truly need to change, and verify that byte-backed
   construction snapshots storage or enforces a trusted immutable-owner contract.
2. **Cross-basis oracle.** On ASCII, BMP, supplementary, combining, CRLF, empty, malformed UTF-8,
   and unpaired-UTF-16 fixtures, enumerate scalar boundaries and verify transcode mappings and
   explicitly expected residuals.
3. **Mask family spike.** Run the same Boolean/classify/harvest laws over UTF-8-byte and UTF-16-unit
   masks, then map harvested scalar-safe spans and compare scalar material.
4. **Regex seam measurement.** Compare keeping a UTF-16 reference, lazily transcoding one window,
   and caching one derived UTF-16 master for regex-heavy jobs. This identifies whether regex should
   be an adapter or a first-class basis-specific capability.
5. **Memory and throughput matrix.** Measure single-basis and dual-basis residency, sequential
   classify, sparse/dense mask algebra, harvest, and topology construction on representative
   corpora. Record allocated bytes as well as time.
6. **Public view prototype.** Try immutable `SpanBatch` numeric columns and unit-mask words through
   read-only/copying/destination-writing surfaces. Verify that a caller can build an external
   operation without receiving mutable ownership or depending on a backend class.
7. **CLI round trip.** Serialize a small basis-stamped mask, compose it in a second process, and
   harvest it. If the artifact cannot state its identity and tail conventions unambiguously, the
   public carrier contract is not closed.

## Open questions

- Is original byte retention a first-class optional Doccer asset, or always supplied by an outer
  ingestion layer?
- Must a UTF-8 profile preserve malformed byte subsequences as first-class invalid atoms, or are
  refuse and replacement-with-residual sufficient? If preserved, are invalid atoms single bytes
  or deterministically segmented maximal invalid subsequences, and what tagged payload/category
  do they carry?
- Which coordinate bases are genuinely first class: storage units only, or also scalar ordinals?
- May a direct unit mask contain unsafe interior units while harvest enforces scalar boundaries,
  or must every public mask already be scalar-safe by construction?
- Should cross-basis transcodes and content-changing transforms share one map carrier with a
  guarantee tag, or use distinct types that compose through a common query surface?
- Does the generalized master own material bytes directly, or can it be a coordinate/fingerprint
  identity paired with capability-specific memory views?
- Which public zero-copy views can remain stable if internal column packing changes?
- Should CLI stacking use explicit subcommands, a small algebra expression, a declarative recipe,
  a long-lived handle/session protocol, or a hybrid over one set of typed contracts?
- Once a coherent primitive closes its own contract and assurance gates, is public exposure the
  default while application witnesses affect priority, or is there a separate public-stability
  gate still to define?
- Does modular deployment remain one `CodexSci.Doccer` assembly with namespaces, or should mature
  capability families be independently referenceable adjacent assemblies/packages?
- How much source/map retention should named convenience profiles request by default?
- Does “UTF-16 reference profile” need to preserve the current host-endian fingerprint internally,
  or should even in-process identity move to a basis-stamped canonical hash before other profiles
  appear?

## Bottom line

The current UTF-16 implementation is a strong reference because it is explicit, total over .NET
strings, scalar-safe, and tested against malformed surrogates. Its strength comes from those
declared guarantees, not from UTF-16 being universally more faithful than UTF-8.

Doccer can preserve its core commitments while allowing callers to choose lighter or transformed
material:

- the chosen master remains immutable;
- its basis and boundary rules remain part of identity;
- conversions and normalizations remain explicit;
- loss and missing provenance remain visible when the caller asks for those guarantees;
- cross-basis coordinates never mix silently; and
- the algebra continues to operate over declared carriers.

The public-capability point is equally important. If Doccer is a specialized numerical computing
stack for text geometry, low-level masks, bit algebra, columnar views, transforms, and harvest are
products of the engine in their own right. Higher-level collectors and analyzers should compose
them, not own access to them. The core can expose stable semantic primitives and carefully scoped
performance views without exposing every backend decision, and the CLI can make those primitives
stackable through basis-stamped artifacts rather than by imitating another library's API.
