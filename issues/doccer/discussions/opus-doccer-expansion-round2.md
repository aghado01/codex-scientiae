# Lets examine some additional plans i have for doccer after the k-arc is finished. D:\aghado01\codex-scientiae\issues\doccer\discussions\grok-doccer-expansion-round2-ideation-20260804.md

## Placement

This isn't a census find. The census bins (latent path / missing example / missing mechanism / adapter policy) all sort _capabilities over the claim carrier_. A bit-vector substrate is a **new carrier sort** — code-unit vectors, with their own identity, empties, compatibility, and residual — which makes it K0-grade business: a registry mint alongside the six sorts D25 named. That's a cleaner entry than "front-end for the collectors," and it's the framing your own "expose it low-level, not private to one scanner" position implies.

It's also the one arc in the whole plan with **no dependency on the open register/value/metadata question**. Classification → mask algebra → harvest → candidate spans into `SpanBatchBuilder` touches no fact and no origin type. That makes it the natural parallel lane to K5, not a successor to K7.

## Where it converges with work already scheduled

**The normalization stage is K6 seen from below.** You describe it as a relaxation of fidelity strictness, but D11 already decided normalization is explicit, and [README:55–58](src/doccer/README.md:55) already specifies "new master plus an offset map, with NFKC/NFKD as lossy transforms whose loss the map records." What's missing isn't the policy — it's the _type_. There is no origin carrier yet; that's exactly K6, with `TextSlice` rebase as its injective-functional special case. So "derived carriers" isn't a new post-K-arc feature; it's K6 arriving with a second producer. Worth deciding deliberately rather than building a parallel normalization path that K6 then has to absorb.

**Residual is a convergence too, with one genuine new thing.** Doccer's residual vocabulary is already deep — pairing faults, `SegmentationResidual`, `PathSelectionResidual`, crossing residue. Bad-zone handling transfers as a _missing example_, not a missing mechanism. Except at one point: a bit-level residual is a mask **over code units**, where every existing residual is a selection **over occurrences**. That gap is real and is the substrate's first genuine mint — and shaping it to project into the occurrence-level residual vocabulary (rather than run parallel to it) is the design decision I'd want made early.

## Where the transfer is thinner than the doc suggests

- **The entire surveyed literature is byte-oriented.** SWAR letter masks (`|0x20`, `−0x61`), 64-byte batches, prefix-XOR over quote bits — all defined over bytes. Your carrier is UTF-16 code units whose topology is identity-bearing (D1: lone surrogates are first-class atoms, and the fingerprint distinguishes them). SWAR over u16 lanes is fine, but the arithmetic predicates don't port unmodified, batches are half as wide per cache line, and surrogate straddle becomes a first-class residual case rather than an edge note. The bad-zone contract carries _more_ weight here than in simdjson precisely because exactness is the identity floor.

## The consequence nobody flagged

A bitmap-backed `SpanSet` or suppression query is **the strongest Lean activation trigger in the entire plan** — stronger than K5. The deferred-Lean brief reactivates on "license an optimization or stage fusion" and on a second backend claiming equivalence, and D3 already promises the bitmap is an acceleration of the algebraic query and _never a second source of truth_. That promise is a genuine equivalence theorem between two backends over the same carrier. K4b and K4c both dodged activation because a bounded differential oracle covered a closed finite form; a bit-parallel `SpanSet` over arbitrary masters doesn't obviously admit the same dodge.

The question I'd put back to you: does the substrate produce _claims_ (candidates into a batch, one sort feeding another) or does it produce a **peer carrier** that the algebra can consume directly without ever becoming claims? The doc slides between those two, and they imply different registry entries.

# i think both should be feasible

agreed, and it doesn't complicate the registry entry much: it means the substrate mints one carrier with two exits, a SpanBatchBuilder emission and a direct peer-carrier consumption path. The only thing the second exit needs that the first doesn't is a basis story — how a mask value states its master and window so SpanSet and the located algebra can consume it without a claim round-trip. Your existing compatible-master/exact-window pattern from K3 is already the shape for that.

# can we please refer to project-level concerns here by full name codex-scientiae to disambiguate between `codex` the openAI application and my project? im literally working in `codex` on `codex-scientiae` `doccer` related work right now, and its confusing to read. not to mention, i dont want `codex` getting confused by ambiguous references when it reads communications or briefs that i share. anyway, looking back on the past 2 or 3 turns, i need help laying out various threads that have come up. the bitmap and vector integrations starting at k0 level, residuals, and the rest of it + gates flipping and all the different things you just brought up. my head is spining

Noted on the naming — **codex-scientiae** in full from here on, in chat and in anything I'd write into the repo. Saved to memory as a standing rule, with the reason: `codex` is the OpenAI application you run _on_ codex-scientiae, so the collision costs you legibility twice — once when you read mixed references, once when that model ingests a brief and can't tell whether a reference is about itself.

Here's the layout. The spin is coming from four different _kinds_ of act being interleaved. Sorted by kind, they're mostly small.

## A. Canon corrections — documents only, no code

| # | Thread
| A2 | **Graph equality stamp.** `CandidateRegionGraph` publishes value equality; every result type stamps by reference. Internally consistent, deliberate per D34 — but undocumented, and the public operator invites the substitution the doctrine forbids. | one decision line |
| A3 | **"The engine never normalizes Unicode."** Over-stated relative to the sentence directly below it granting the explicit producer. | [README:55](src/doccer/README.md:55) |

A1 is the only one that changes anything downstream. A2 and A3 are hygiene you can do whenever.

## B. Gates that flip

- **B2 — the K5→K6 edge can narrow.** K6's exit gate never mentions facts; K7's `OutputPiece` carries an _optional_ support reference. Reduce the edge to a named obligation (reserve the support/derivation type, keep it distinct from origin) and K6/K7 run beside K5 instead of behind it. Same move D34 made on the false K4b→K4c edge.
- **B4 — K5 has no named bounded witness.** The cross-cutting gate requires one per tranche; K2/K3/K4 each named theirs in-tranche, K5 names none, and no K8 item is a saturation demo. Unsatisfied by the plan, not by the code.
- **B3 — the substrate arc is available now.** Classification → mask algebra → harvest → candidates touches no fact and no origin type. -

## C. Contract decisions to make before any code

1. **K6 strictness at the tagged middle** — "identical master/basis" now has two precedents in the landed tree (reference for occurrence-bearing, value-compatible for geometry). K6 is cross-master, so this gets picked, not inherited.
2. **Substrate: one carrier, two exits** — you've said both are feasible, so the peer-carrier exit needs a basis story (how a mask value states master + window so the existing algebra consumes it without a claim round-trip). The K3 compatible-master/exact-window pattern is the shape.
3. **Residual over units vs over occurrences** — the bit-level residual is the substrate's one genuine mint. Decide early that it _projects into_ the occurrence residual vocabulary rather than running parallel to it.
4. **Derived carriers are origin producers** — normalization isn't a new feature, it's K6 with a second producer. The decision is whether to build it there or risk a parallel path K6 later has to absorb.

## E. Tripwires — no action, just don't get surprised

- **Empty-span assumption.** `NearestContainers` is correct _because_ batches refuse empty claims. If K6/K7 synthetic or zero-length material ever becomes representable, that loop silently degrades from "nearest" to "first in iteration order."

## What this means concretely

**Three lanes can run at once**, and none of them waits on the others: K5 identity (once A1 settles what it's actually asking), K6 origins (if B2 narrows), and the substrate mint (unconditionally).

## D. Lean trigger register

The deferred lane now has two live candidates, and they're not equal:

- **Bit/vector backend equivalence is the strongest trigger in the entire plan.** D3 already promises the suppression bitmap is an acceleration and _never a second source of truth_ — that promise is an equivalence theorem between two backends over one carrier. K4b and K4c dodged activation because a bounded differential oracle covered a closed finite form; a bit-parallel `SpanSet` over arbitrary masters doesn't obviously admit the same dodge.
- **K5 rule-order independence** — listed in the theorem table, should be explicitly reapplied-and-decided at contract time per the D37/D39 pattern rather than inherited.

# I think a missed opportunity in doccer is vectorization

Agreed, and the evidence is sharper than the SIMD framing suggests — the layout is already paid for and never spent.

`SpanBatch` is a genuine SoA store: `int[] Starts`, `int[] Ends`, `SpanLevel[] Levels`, `int[] Priorities`, plus the interned ID columns ([SpanBatch.cs:229](src/doccer/Core/SpanBatch.cs:229)). But `Starts`/`Ends` are `internal`, and `SpanRecord` is a row cursor that rebuilds `new TextSpan(Starts[i], Ends[i])` per access. So every consumer in K2–K4 reads the columnar store one row at a time through `Basis[ordinal].Span`: `LocatedRelation.Seq` is a nested loop, `PackingView` and `LaminarView` are O(n²) pairwise predicates, `Laminarizer.Admit` runs `.Any()` per candidate, `PathSelection` rescans all admissible candidates per boundary. Tranche 2 bought the columnar layout and the algebra above it has never once looked at a column.

There's a pattern in where vectorization _did_ arrive. `ClaimSelection` is a word-parallel bitset. `AllenRelationSet` is 13-bit bit-parallel. Both are vectorized — and both are cases where the carrier's _value was already a set of bits_. Everywhere the value is a set of intervals, it's scalar. So it's not that the engine is uniformly scalar; it's that vectorization showed up wherever the representation handed it over for free, and never got reached for where it would have taken a representation choice. Which is exactly the seam the bit-vector substrate sits on — that would be the first time geometry gets a mask representation rather than an interval-list one.

And there's a reason this never surfaced from inside the K-arc. The cross-cutting gate's Reference-semantics row says "a simple implementation exists before acceleration" — which is right, and which makes scalar-first correct policy. But none of the nine rows asks whether a contract is _shaped_ so a set-at-a-time backend could exist later. Carrier, Operator, Residual, Policy, Reference, Harness, Lean, Witness, Documentation — nothing about representation-independence. So the blind spot isn't an oversight in K3 or K4c specifically; the gate table can't see it.

Which sense do you mean, though? They imply different verdicts on what's landed:

- **Execution** — the contracts are fine, the backends are scalar, and this is a later acceleration story (with the equivalence-theorem consequence we already flagged).
- **Design** — operations should be set-at-a-time _by shape_, the way the MATLAB/scikit-learn posture you described actually works, in which case some landed signatures are shaped wrong and it's not purely additive.

The `Starts`/`Ends` being `internal` reads to me like a decision that only makes sense under the first reading, and it forecloses the second.

# and i would add zero-alloc patterns to that later. thermomapper actually has quite a bit of perf patterns in c# that are probably transferrable `D:\aghado01\project-snapshots\ThermoMapper\src_20260701_122622_tree.md`, see clustering, graphs, maths, tda in particular

Rich source — and it's more directly relevant than I expected, because **zero-alloc and vectorization turn out to be the same thread at two altitudes**, with one shared root cause in doccer.

## What's actually in there

**`UndirectedEdgeWalk` is the find.** A `readonly ref struct` wrapping CSR arrays, with a nested `ref struct Enumerator` and `AggressiveInlining` on `GetEnumerator`/`MoveNext`. Duck-typed `foreach` — no interface, no boxing, no allocation, and the `j <= _i` skip does canonical-orientation filtering inside the walk instead of materializing an edge list.

That maps onto doccer's hottest structural wart. Every enumerable in the K2–K4 algebra returns a _boxed_ enumerator: `PartitionView.GetEnumerator()` is `((IEnumerable<int>)_ordinals).GetEnumerator()`, `LocatedRelation` the same over `TextSpan[]`, `CandidateRegionGraph` delegates to `ClaimSelection`. So every `foreach (var ordinal in selection)` in the tranche — and there are dozens, several inside O(n²) loops — allocates an enumerator and pays interface dispatch to read an `int` out of an array or a bitset word. That's fixable with **zero contract change**.

**`TensorPrimitives` is already in use.** `Minkowski` dispatches p=2 to `System.Numerics.Tensors.TensorPrimitives.Distance<double>` and keeps `ReadOnlySpan<double>` as the primary signature with array overloads delegating to it. That's the portable BCL SIMD surface — no intrinsics, no runtime feature detection, no `#if`. Directly relevant to last turn's question: there's a supported vectorization path that isn't hand-written AVX/NEON. Caveat worth stating up front — it's float/double-oriented, and doccer's columns are `int[]`, so the analogue is `Vector<int>` for comparisons/min-max/index-of rather than TensorPrimitives proper.

**Two-pass count-then-fill.** `CsrGraph.FromEdges` and `InducedSubgraph` both count degrees → prefix-sum into row pointers → fill with a cursor array. No `List<List<int>>`, no growth, exact allocation. That's the same harvest-then-emit shape the GigaToken survey named, arrived at independently — which is decent evidence it's a real invariant rather than a tokenizer trick.

**Precomputed mirror index.** `BuildReverseSlotMap` pays once so later slot lookups are O(1) instead of `FindSlot` scanning a row. This one has a concrete target in landed doccer code: `PathSelection.Select` rescans _all_ admissible candidates at every boundary, filtering on `edge.Start != boundary`. A CSR-by-start-boundary makes that O(E) instead of O(B×E), and it's a pure backend change under an already-frozen contract.

## What not to copy

ThermoMapper is **not** uniformly zero-alloc, and that's the useful part. `BoundedMinHeap.GetSorted()` allocates a result array and hands `Array.Sort` a `Comparison<Neighbor>` lambda — delegate allocation and no inlining, inside a k-NN path. `PersistenceClearing.ComputeH0` allocates two `HashSet<int>`, a `List<int>`, a `Dictionary<int,int>`, sorts with a comparison lambda, and uses a capturing local function for `Find`. So the discipline lives in the **primitives** and relaxes in the **orchestration**. That layering is correct and worth importing deliberately rather than discovering by accident.

One structural mismatch: `CsrGraph` is a _mutable_ struct with public array fields. Defensive-copy hazards, and flatly against doccer's immutability floor. The transferable content is the layout and the walk, not the struct's mutability.

## The synthesis

Both threads have the same root. A SIMD backend needs the columns; a non-allocating enumerator needs the columns. `Starts` and `Ends` are `internal`, and `SpanRecord` — a row cursor that rebuilds `new TextSpan(Starts[i], Ends[i])` per access — is the only way through. One representation decision gates both.

But they split cleanly on risk, and shouldn't be one chip:

- **Contract-preserving** — `ref struct` enumerators, CSR-shaped boundary adjacency in `PathSelection`, sweep-based replacements for the O(n²) `Crosses`/`Intersects` loops. No signature changes, no doctrine question, no Lean trigger. Available today, independent of everything in the K-arc.
- **Contract-touching** — exposing columns, adding span-shaped operations, any set-at-a-time signature. This is where the representation-independence question lives, and where the equivalence-theorem Lean trigger fires.

For the thread layout: the first bullet is a new **Bucket B lane** (available now, unblocked, parallel to K5/K6/substrate). The second folds into **C2** — the substrate's basis story — because "should a contract be shaped so a set-at-a-time backend can exist" is the same question for masks and for columns.

Worth pulling the `hashish` shards too when you get to it — memory says the conversion-metric atomic layer already lives there, and `minhash`/`simhash`/`ctph` are exactly where bit-packing discipline would show.

# lets pull the hashish shards. i won't be vendoring that directly but will like pull in what fits

Pulled 7 of the 22 hashish files — the bit/DP-oriented ones. Skipped the IR/statistics cluster (`bm25`, `idf`, `tfidf*`, `cooc*`, `cos`, `jaccard`, `ncd`, `histogram`, `measure`) and, notably, `minhash` and `ctph`, which are the two most likely to hold more of what we're after (permutation bit-packing, rolling hash).

## Lift wholesale

**`Levenshtein.Distance` is the best specimen in the module.** It stacks five techniques in ~60 lines: common prefix/suffix trim before the DP, swap so the shorter side is the inner dimension, `stackalloc` under a 256 threshold, `ArrayPool<int>.Shared.Rent`/`Return` in `try/finally` above it, and two-row DP that **swaps span references instead of copying** (`var tmp = prev; prev = curr; curr = tmp;`).

That stackalloc-under-threshold / pooled-above pattern is the canonical C# answer to "bounded scratch, no GC pressure, no fixed cap," and doccer has an exact target. `PathSelection.Select` allocates a fresh `int[]` **inside the DP inner loop** — `var ordinals = new int[suffix.Ordinals.Length + 1]` followed by an `Array.Copy` of the whole suffix, once per (boundary × candidate). Switching to predecessor links — store `(ordinal, nextBoundary)` per boundary and reconstruct the path once at the end — removes essentially all of it, and it's a pure backend change under a frozen D37 contract.

## Lift the technique, not the code

- **Bitset iteration via `BitOperations`.** `BloomFilter` uses exactly doccer's `ClaimSelection` representation (`ulong[]`, `bit >> 6`, `1UL << (bit & 63)`) — independent convergence, so nothing new there. What doccer _doesn't_ use is the `BitOperations` family: `PopCount` for cardinality, and `TrailingZeroCount` + clear-lowest-bit for set-bit iteration. That last one matters more than it sounds — see below.
- **`CollectionsMarshal.GetValueRefOrAddDefault`** (in `SimHash`) returns a `ref int` so an increment is one hashtable probe instead of TryGetValue-then-assign. Underused, and doccer's `InternedColumn` build path is the natural target.
- **`SeededHash`'s span overloads.** `Mix64` (splitmix64 finalizer) plus seeded FNV-1a over `ReadOnlySpan<char>` / `<byte>` / `<uint>`, with `AggressiveOptimization` on the loops. The `char` overload hashes UTF-16 code units directly, which lines up exactly with D1's carrier. **Caveat:** doccer's master fingerprint is an identity commitment and SHA-256 is the right call there — FNV-1a is for internal hashing (interning, bucketing), never identity.

## One find that touches a landed decision

`SimHash` compiles its regex with `RegexOptions.Compiled | CultureInvariant | NonBacktracking`. Doccer already mandates `CultureInvariant` as an engine invariant and rejects `ECMAScript` (D18) — but `NonBacktracking` isn't in the baseline. For an engine that accepts _caller-supplied_ patterns, a linear-time guarantee is a contract-shaped property, not a perf tweak. Worth a look as a D18 amendment rather than an implementation detail.

## Don't pull

- **`WordShingler`** is the module's own counter-example — `string.Join` per shingle allocates n strings, then `BuildSet` allocates a HashSet over them. It ignores the discipline the rest of the module follows.
- **`CountMin`'s `long[,]`** — multidimensional arrays don't get the bounds-check elision a flat `long[]` with `row * width + col` does. Wrong thing to copy into a hot path.
- **`SimHash`'s `m.Value.ToLowerInvariant()`** allocates a string per token, inside the loop it otherwise optimizes carefully.

## Where the threads meet

The convergence is sharper than I expected. A `ref struct` enumerator over `ClaimSelection`'s bitset, walking words with `TrailingZeroCount` and clear-lowest-bit, is **simultaneously** the zero-alloc fix (no boxed `IEnumerator<int>`) and the vectorization fix (word-at-a-time instead of bit-at-a-time) for the single most-executed loop in K2–K4. One change, both threads, no contract touched.

That makes it the natural first chip of the contract-preserving lane — ahead of the `PathSelection` allocation fix, because every structural view depends on that enumerator and nothing depends on it changing shape.

One small thing worth noting only so it doesn't join the pile: `HyperLogLog` calls its cells "registers." Third unrelated sense of the word now in circulation.

# so why dont you pull the rest of the pertinent hashish

Got the pertinent set — 14 of 22 now read. Remaining is the IR-scoring cluster (`tfidf`, `tfidf_search`, `idf`, `bm25`, `cooc`, `cooc_stats`, `ncd`, `histogram`), which is where the conversion-metric atomic layer would live but holds nothing for the bit/vector/zero-alloc threads.

## The best new find

**`MemoryMarshal.Cast`.** `CTPH.HashSequence` does `CollectionsMarshal.AsSpan(chunks)` then `MemoryMarshal.Cast<ulong, byte>(chunkSpan)` — reinterprets a `List<ulong>` as bytes with zero copy, straight into Base64.

That's the answer to a question the substrate thread had left open. `MemoryMarshal.Cast<char, ulong>` over a `ReadOnlySpan<char>` is how you do SWAR over UTF-16 in **safe C#** — no `unsafe`, no pinning, no intrinsics. Four code units per `ulong` lane, and the classification arithmetic from the GigaToken survey ports with the constants widened. It also gives `SpanBatch` a free way to expose `ReadOnlySpan<int>` views over `Starts`/`Ends` without changing their storage.

## Structural transfer worth more than any single trick

`measure.cs` declares `IMeasure<T>` and implements it with `readonly struct LevenshteinMeasure`, `CosineVectorMeasure`, `JaccardMeasure<T>`. Consumed through `where TMeasure : struct, IMeasure<T>`, the JIT monomorphizes and devirtualizes — zero-alloc, zero-dispatch strategy objects.

That's the shape of doccer's entire policy layer. `AdditivePathPolicy`, `LaminarAdmissionPolicy`, `PackingPolicy`, `HierarchyPolicy`, `ResolutionLayerPolicy` are all `sealed class` today, allocated per call and dispatched virtually. The struct-policy pattern is the zero-alloc version of a doctrine doccer already holds — mechanism in the engine, judgment named by the caller.

**Caveat that matters:** the benefit only materializes at a generic constraint. If a method takes `IMeasure<T>` as an interface parameter, the struct boxes on every call and you're strictly worse off than a class. `measure.cs` doesn't show its consumption sites, so I can't tell which way hashish went.

## Confirmations and better answers

- **The stackalloc-under-threshold / ArrayPool-above idiom is house-standard**, not a one-off — it appears in `Levenshtein` (256), `CTPH` (512), `MinHash.HashWithSeed` (256), `TLSH.ComputeChecksum` (1024). But it's **copy-pasted, not shared**, and `CTPH.LevenshteinCore` is a strictly worse fork of `Levenshtein.TwoRowDp`: no prefix/suffix trim, no shorter-side swap. If doccer adopts the idiom it should be one scratch-buffer helper, not four sites.
- **`MemoryExtensions.Sort(Span<int>)`** in `TLSH` sorts a `stackalloc` span in place with no allocation and no comparer delegate — the answer to `BoundedMinHeap.GetSorted()`'s `Array.Sort` lambda I flagged last turn. Same codebase, better version.
- **`TensorPrimitives` is used broadly** — `cos.cs` reaches for `CosineSimilarity`, `Dot`, and in-place `Multiply`. `BuildDistanceMatrix` rents one flat `n*d` buffer and writes a flat `double[n*n]` with manual `i*n+j`. That's the correct counter to `CountMin`'s `long[,]`; the module contains both versions of the same choice.
- **`NonBacktracking` is house-standard**, in both `simhash.cs` and `tokenizer.cs` — reinforcing last turn's D18 amendment candidate.

## The instructive near-miss

`TokenizerPreprocessing.Normalize` does `FormKC` + `ToLowerInvariant` and returns a `string`. That is precisely the derived-carrier stage you said you want in doccer — implemented here with **no provenance map at all**, because similarity scoring doesn't need the correspondence back.

Doccer can't take that shape. D11 and K6 require the offset map, and NFKC is explicitly a lossy transform whose loss the map records. So the _stage boundary_ transfers cleanly and the _lossiness_ doesn't — which is a compact statement of why normalization has to land as a K6 origin producer rather than as a utility function.

## Don't pull

The module is disciplined at the leaf-arithmetic tier and careless at the set/string tier, and here that crosses into actual hot paths:

- **`MinHash` is the least optimized file despite being the most bit-oriented.** `BuildShingles` allocates a `new string(...)` per shingle; `Compute` then re-hashes each shingle from scratch 128 times. The standard fix — hash once, apply k cheap affine permutations — isn't there.
- **`JaccardContainment` allocates two fresh `HashSet<T>` per call**, and `ToSet` clones even when handed an existing set.
- `TLSH.Compare` allocates strings via `s1[..2].ToString()` just to parse hex.

## Where this lands

Nothing here changes the thread layout's shape — it sharpens the contract-preserving lane. That lane now has four concrete items in dependency order: the `ref struct` bitset enumerator, the `PathSelection` inner-loop allocation, span views over the columns via `MemoryMarshal.Cast`, and struct policies behind generic constraints. All four are backend-only under frozen contracts.

The struct-policy one is the exception worth flagging: it's contract-preserving in _behavior_ but it changes public signatures from `Foo(IPolicy p)` to `Foo<TPolicy>(TPolicy p) where TPolicy : struct, IPolicy`. That's a source-compatible-ish change with real API surface consequences, so it belongs at the boundary with the contract-touching lane rather than inside the safe one.

# well there's pulling code, pulling patterns, and pulling concepts. not all of hashish is perfect, but conceptually what do we want in terms of hashing algorithms and other things, like in terms of a wish-list

Good frame — and the concept tier is where the most useful thing happens, because the first conceptual act is **refusing to have one `Hash()`**. Doccer's own non-goals already say "no untyped `Compose`"; the same discipline applied to hashing splits it into four jobs with genuinely different requirement profiles.

## The taxonomy first

| Job           | What it must guarantee                                                                              | Cost model               | Status                                       |
| ------------- | --------------------------------------------------------------------------------------------------- | ------------------------ | -------------------------------------------- |
| **Identity**  | Commits. Distinguishes everything the topology distinguishes. Collision-resistance is load-bearing. | Once, lazily, per master | Exists — SHA-256 over raw UTF-16             |
| **Digest**    | Exact-equality proxy for _material_. Cheap. No commitment beyond the process.                       | Linear prep, O(1) query  | **Missing — the big want**                   |
| **Signature** | Similarity-preserving, lossy _by design_. Comparison is the whole point.                            | Per object               | Belongs above the engine, or as its own sort |
| **Sketch**    | Approximate aggregate over unbounded input.                                                         | Streaming                | Probably not doccer's business               |

Conflating digest with identity is the failure mode that would actually hurt — it's how a fast non-cryptographic hash ends up load-bearing for the compatibility floor.

## The wish-list

**1. A prefix-hash column on `TextMaster`.** Lazily built exactly like `_fingerprint` and `_topology` already are, giving **O(1) content digest for any span**. That single primitive unlocks: dedupe claims by material rather than geometry, ask "is this the same text?" across masters in constant time, and give K6 origins and conversion-metric alignment a cheap equality oracle. It fits the existing lazy-derived-facts pattern with no new doctrine.

**2. A seeded hash _family_, not a blessed hash.** `SeededHash.Seed(i)` is the right shape — one primitive indexed by seed, so k-independent uses (bit-index probes, k permutations, LSH bands) all come from one place instead of four ad-hoc constants. Span overloads over `char`/`byte`/`uint` so the UTF-16 carrier is native.

**3. A _windowed_ rolling hash — and the distinction that goes with it.** CTPH's `ComputeChunks` advances FNV over the whole prefix and never evicts, so its boundaries are content-defined but **not shift-resistant**: insert a character at the front and every boundary moves. A true windowed hash (Rabin-Karp, buzhash) keeps boundaries stable under insertion. That property is the entire value for doccer, because it's what makes version-to-version alignment tractable. Conceptually this is a **new kind of collector** — one whose boundaries come from content rather than from a pattern — and it's domain-agnostic, which is what the engine wants.

**4. Alignment that yields a _trace_, not a distance.** This is the sharpest thing to come out of reading hashish. `Levenshtein.TwoRowDp` is beautiful zero-alloc work and it computes a **number**, discarding the correspondence. Doccer needs the opposite: the trace _is_ the origin relation. `O ⊆ Atoms(N) × TaggedAtoms(M)` is literally what an alignment path is. So a computed alignment isn't a new mechanism — it's a **K6 origin producer**, sitting beside the declared-plan producer.

That reframes the conversion metric too: the engine supplies alignment plus its residual; the _score_ stays with the consumer, exactly per the residuals-stay-visible rule. And it means the right algorithm family is Myers/Hirschberg (linear space, recoverable trace), not two-row DP.

**5. Hash-partitioned candidate generation.** LSH banding's real concept is: bucket so you never do the O(n²) comparison. The named consumer already exists — the benchmark harvest's uniqueness-gated challenge library needs "is this problem novel?" without comparing against everything.

**6. A portability commitment on any hash that leaves the process.** `TextMaster`'s own docstring flags it: the fingerprint bytes are host-endian, and "if fingerprints ever persist cross-platform, endianness must be fixed explicitly." That's unresolved and it becomes a live bug the moment F2 persistence or a cross-machine package manifest lands.

## What not to want

- **Cryptographic hashing anywhere but identity.** It's the right call for the fingerprint and the wrong call for everything downstream.
- **A similarity _score_ inside the engine.** Similarity is judgment. The engine should be able to hand a consumer everything needed to compute one — digests, alignment, residual — and compute none itself.

## The fork that would change this list

Does doccer own alignment, or only the exact primitives beneath it?

I lean toward in — an alignment is deterministic mechanism with a visible residual, which is exactly the profile of everything else that passed the K-arc gates.

If alignment is in, items 4 and 5 are engine work and K6 gains a second producer type — which is a real expansion of what "origin" means, from _declared_ to _computed_.

You're right on both counts, and the terminology one is the bigger error. Let me finish the module first — this completes all 22 files.

Both land. Taking them in order.

## The terminology error

"Document" in IR is not a file, a paper, or a master — it's **the unit of the collection**, an arbitrary granularity choice. I imported the word, silently bound it to `TextMaster`, and concluded doccer has no collection to compute over.

Doccer's own README says the opposite in as many words: _"master is a coordinate space, not 'the document' — minting one over an isolated math span or a macro-expansion site is first-class."_ And doccer is full of collections: a `SpanBatch` is a population of claims, so are `ClaimSelection`, `PerLine` runs, `LaminarGroup`s, `PartitionView` cells, `ResolutionView` layers, graph candidates. **IDF over the claims of one batch is a within-master statistic.** No corpus, nothing external, fully document-local in doccer's sense.

## The method error, and the guard that already exists

You caught this twice now — first judging minhash/TLSH/Jaccard by their implementations, then judging the IR cluster by a structural argument while praising its code. Same conflation, opposite sign.

The discipline that prevents it is already in doccer's canon and I read it three turns ago: census process rule #1, **catalog before naming** — "promotion is always a later, separate act of evaluation over the catalog, never simultaneous with capture." I was evaluating at capture time. The naturalist pins the specimen before deciding whether it's a species; I kept deciding while pinning.

## The concepts, properly

**IDF — surprisal.** `log(N/df)` is an information weight: a feature present in every member of a population discriminates nothing, a rare one discriminates a lot. Doccer's D8 density family measures _counts_; IDF is the information-weighted refinement of a count. "How many claims of kind K in this region" versus "how surprising is K here." That is directly the question behind the figure-hood veto, role-boundary detection in the truffle lane, and the census's own "is this pattern real or coincidence."

**BM25 — two separable ideas, both general.**

- _Saturation._ `(k₁+1)·tf / (K + tf)` — the 20th occurrence adds far less than the 2nd. Diminishing returns on repeated evidence. `AdditivePathPolicy` is strictly linear, and D37 explicitly reserved room for "signed/vector objectives, maximum weight, and other tie rules... as separately named future contracts." A saturating objective is exactly such a contract, and a chunker that shouldn't pay linearly for its tenth breakpoint is the concrete want.
- _Length normalization._ `b·(len/avgLen)` — comparing objects of different size fairly. This is a real gap: doccer compares spans of wildly varying extent constantly, and any unnormalized per-span score is biased toward long spans.

**Contextual entropy — the strongest concept in the module, and I nearly skipped its file.**

`CooccurrenceStats.ContextualEntropy` computes the entropy of a token's context distribution, normalized by `log₂(V)`. The question it answers is **how predictable is this thing's neighborhood** — low entropy means stereotyped contexts (delimiters, furniture, boilerplate), high entropy means it appears anywhere (content).

That is a principled, domain-free, document-local answer to "is this structural or content-bearing" — which is the question underneath heading over-promotion, figure-hood, and role boundaries. And it satisfies the no-magic-string-heuristics doctrine exactly: the signal comes from the document's own structure, with no string constants anywhere.

**PMI/PPMI — association above chance.** Raw co-occurrence is confounded by marginal frequency; PMI corrects for it. The doccer connection is strong: **`ClaimPairView` is already a co-occurrence structure.** It computes Allen-labeled occurrence edges between claims. Indexing counts by `(kindA, kindB, AllenRelation)` gives not "A and B co-occur" but "A `during` B occurred 40 times, six times chance" — turning the Allen layer from qualitative to measured, composed entirely from landed primitives. Census bin: **unnamed latent path**, not a missing mechanism.

**TF-IDF vector space.** Object → weighted sparse vector over a vocabulary, similarity → dot product. This is the _embedding_ concept in your own framing — an (coordinates, metric) pair. A claim population projected to a vector over kinds or materials is the natural join between doccer's carriers and the SPC/Mapper/HDBSCAN ladder. Not doccer engine work, but it's the seam.

## Two patterns that keep recurring

Worth naming because they cut across everything, not just this module:

**Self-calibration.** BM25's `avgDocLength` and TLSH's quartiles are the same idea — grade against the population's _own_ distribution, never a global constant. That's the document-local doctrine expressed as a statistical technique, and it appears independently in two unrelated algorithms.

**Asymmetry.** Containment, conditional probability, coverage-versus-fidelity, origin direction — the doccer-relevant measures keep turning out to be directional. Symmetric similarity is the special case; _which way_ is usually the actual question.

## One implementation note, kept separate

`tfidf_search.TopK` is the correct bounded heap — parallel `int[]`/`double[]` arrays, no comparison delegate, in-place sift, drained in reverse. It's the fix for `BoundedMinHeap.GetSorted()`'s `Array.Sort` lambda that I flagged four turns ago, sitting in the same module. Filed under patterns, not concepts.

All 22 files are now read.
