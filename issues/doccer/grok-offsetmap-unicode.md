# lets discuss offsetmap and unicode normalization, unicode normalization in particular sounds like something that should be optional since i don't necessarily want to discard that information silently by default

### What the legwork already says

From `MarkPig/doccer/legwork/UNIFIED-SWEEP.md`:

> **No normalization.** If normalization is desired, it runs _before_ the sweep on the original text, producing a new master string. The sweep operates on whichever master string is the active immutable source.

> **Normalization form (NFC / NFD)**: assume NFC at input; document that NFD input will produce different (but still valid) atom spans.

From `SCHEMA.md`:

> The original document text is **immutable** after ingestion. No normalization mutates it in place; if normalization is required, the normalized text becomes a new master string with a forward offset map back to the original.

So the architecture already treats normalization as an **explicit, optional transform that produces a new master**, not as a silent preprocessing step that rewrites the text the engine is analyzing.

That is exactly the right posture for Doccer.

---

### Why silent / default normalization is a problem

Unicode normalization (especially NFKC / NFKD) is information-destroying in ways that matter for structural work:

| Transform                        | What is lost or changed                                                                                                                                           |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| NFC / NFD                        | Composition vs decomposition of combining sequences. Length can change. Boundaries move.                                                                          |
| NFKC / NFKD                      | Compatibility characters collapse: ligatures (`ﬁ` → `fi`), fullwidth → halfwidth, superscripts, circled numbers, etc. This is irreversible loss of original form. |
| Case folding (sometimes bundled) | Further irreversible change.                                                                                                                                      |

For a document engine that retains claims, provenance, and later wants to support accurate edit plans or round-trips, silently applying any of these by default is a form of data corruption. The original code units, original boundaries, and original visual/compatibility distinctions disappear.

Your preference — _optional, never silent discard by default_ — is therefore not a convenience preference; it is required for the claims-first model to remain honest.

---

### How OffsetMap fits

`OffsetMap` is the mechanism that makes optional normalization (and any other non-bijective transform) safe.

A clean model looks like this:

```text
Original master  ──(explicit Normalize request)──►  Normalized master
       │                                                  │
       └──────────── OffsetMap (original ↔ normalized) ───┘
```

Key properties the map must support:

1. **Point mapping that can be partial / ambiguous**
   - Exact mapping where the transform is 1:1
   - Unmapped regions (characters that disappeared under compatibility decomposition, or pure insertions)
   - Ambiguous ranges (especially around composition/decomposition boundaries and unequal-length replacements)

2. **Span projection under an explicit policy**
   When a claim on the original is projected onto the normalized master (or vice-versa), the policy decides what happens on partial overlap with an unmapped or ambiguous zone: clip, drop, mark residual, or refuse.

3. **Exactness laws only on the preserved set**
   Round-trip guarantees can only be stated for coordinates that survive the transform. The map must be able to report which regions are exact, which are approximate, and which are lost.

4. **Same-master rebase vs cross-master transform**
   Slice → parent (same text, different coordinate origin) is a total bijective special case. Normalization, edit plans, and encoding changes are cross-master and generally not bijective. The API should keep these distinct so callers do not accidentally treat one as the other.

This is why a naïve `int → int` (or even `int → int?`) is insufficient. The map has to be able to answer richer questions.

---

### Recommended contract shape for Doccer

**TextMaster stays the source of truth.**
Whatever text you hand it is the immutable coordinate space. No hidden normalization inside `TextMaster.Create` or the topology builder.

**Normalization is an explicit producer of a new master + map:**

```text
(originalMaster, OffsetMap, normalizedMaster) = Normalize(originalMaster, form, options)
```

- `form`: NFC | NFD | NFKC | NFKD (and possibly “identity” / “none”)
- The original master is never mutated.
- All subsequent collection, algebra, and validation run against whichever master the caller chooses.
- Claims collected on the normalized master can be projected back through the map when the caller needs original coordinates (or the reverse).

**Default = identity.**
If no normalization step is requested, the engine works on the original bytes/code units as given. That preserves malformed surrogates, compatibility characters, unusual combining sequences, etc., exactly as the current `TextTopology` already does.

**Compatibility with the unified sweep**
The sweep document already says the right thing: the sweep operates on the active master. If you want NFC atoms, you normalize first and then sweep the new master. If you want to preserve original form, you skip normalization. Both are valid; neither is silent.

---

### Interaction with other deferred pieces

- **Byte addressing / source encoding**
  Normalization usually happens on already-decoded Unicode text. Exact byte offsets into the original file require either keeping the original bytes or a separate encoding map. That is related to, but distinct from, the Unicode-form OffsetMap. Keep them separate objects so the contracts stay clear.

- **Edit plans / mutation**
  The same OffsetMap machinery is useful for any non-bijective rewrite (comment stripping, macro expansion results, etc.). Normalization is just one important instance of “produce a new master + map.”

- **Laminar / validation**
  Because claims stay bound to a specific master, a laminar view computed on the normalized master is not automatically valid on the original. Projection through the map (with policy) is required. That is a feature, not a bug: it forces the information loss to be explicit.

---

### Practical recommendation for Phase 1

1. Do **not** add any default normalization inside `TextMaster` or the topology builder. Keep the current “accept whatever text you are given” behavior.
2. Document that NFC is a common _recommended_ input form for many consumers, but it is not required and is never applied silently.
3. When `OffsetMap` is designed, treat Unicode normalization as one of the primary motivating use cases (alongside slice rebasing and general edit plans). Design the point/span query surface so that normalization can be expressed honestly.
4. Keep the ASCII-transliteration tool (the older Markdig `UnicodeNormalizer`) as a completely separate, higher-level concern. It is a lossy transliteration for anchors/search, not a Unicode normalization form, and should not be mixed into the master/OffsetMap substrate.

This keeps the engine’s core invariant intact: **the master you analyze is exactly the text you intended to analyze; any change of form is an explicit, mappable, optional step.**

Would you like to go deeper next on the concrete shape of the OffsetMap query surface (point vs span, ambiguity representation, composition), or on how normalization should interact with the atom tiling and surrogate handling?

# lets investigate offsetmap ambiguity representation and unicode composition edge cases

This is the right level to dig into. The hard part of `OffsetMap` is not the happy path of 1:1 stretches; it is the places where composition/decomposition makes a single source offset correspond to a _range_ (or to nothing) in the other master.

Below is a concrete investigation of those cases, followed by candidate representations that stay honest about them.

---

### 1. Where ambiguity actually comes from

Unicode normalization is not a uniform length-preserving rewrite. It is a sequence of:

1. full decomposition (canonical or compatibility)
2. canonical reordering by combining class
3. (for NFC/NFKC) pairwise composition back to primary composites

That process creates several distinct kinds of non-bijective regions.

#### A. Precomposed ↔ base + combining mark(s)

Classic example:

| Form | Code points                 | UTF-16 length |
| ---- | --------------------------- | ------------- |
| NFC  | `U+00E9` (é)                | 1             |
| NFD  | `U+0065 U+0301` (e + acute) | 2             |

Offset picture (half-open):

```
NFC:  [0| 1]
       é

NFD:  [0| 1| 2]
       e  ́
```

Canonical-equivalent _offsets_ (UAX #15 style):

- `0_NFC ≈ 0_NFD`
- `1_NFC ≈ 2_NFD`
- `1_NFD` has **no** canonically equivalent offset in NFC

Any claim that starts or ends at the interior of the NFD sequence cannot be mapped to a unique NFC offset. The same problem appears in reverse when you have a span that covers only part of a precomposed character (impossible in NFC, but possible if the claim was made on NFD and you try to project).

#### B. Multiple combining marks + reordering

```
Source (already NFD order):  e + circumflex (230) + acute (230)
```

Both marks have the same combining class, so order is significant and they do **not** reorder past each other. But:

```
e + acute + circumflex   ≉   e + circumflex + acute
```

when the classes are equal and the marks interact. Composition may produce different primary composites or leave a residual mark:

```
U+1EBF (ế)  →  e + circumflex + acute
U+00E9 + circumflex      →  remains two units after NFC attempt
```

Interior offsets inside a multi-mark sequence are almost never uniquely recoverable after composition.

#### C. Hangul (algorithmic, not table-driven)

```
가  (U+AC00)  ↔  ᄀ + ᅡ     (L+V)
각  (U+AC01)  ↔  ᄀ + ᅡ + ᆨ  (L+V+T)
```

Length 1 ↔ 2 or 3. The jamo boundaries have no counterpart inside the syllable. Hangul is a pure illustration of “one scalar on one side, several on the other,” with a completely regular algorithm.

#### D. Compatibility decompositions (NFKC/NFKD) — information loss

| Source                | NFKC result  | Notes                           |
| --------------------- | ------------ | ------------------------------- |
| `ﬁ` (U+FB01)          | `f i`        | ligature destroyed              |
| `２` (fullwidth)      | `2`          | width distinction lost          |
| `²` (superscript)     | `2`          | semantic distinction lost       |
| `Å` (U+212B angstrom) | `Å` (U+00C5) | singleton → different character |

These are not merely length changes; they are **lossy**. A reverse map can only say “this region came from _something_ that normalized to this,” not recover the original code point. That is why the earlier decision that normalization must be optional matters: once you apply NFKC you have permanently discarded information that Doccer’s claim model might have wanted to keep.

#### E. Characters that disappear

Under some forms (especially NFKC_Casefold or custom tables) Default_Ignorable characters map to the empty string. The source offset then has **no image** at all — a pure unmapped region.

#### F. Interaction with Doccer’s current scalar tiling

`TextTopology` currently emits one atom per Unicode _scalar_ (or unpaired surrogate). It does **not** emit grapheme clusters. That is deliberate and still correct for the substrate, but it means:

- A claim can legally start or end between a base and its combining mark.
- After NFC, that claim boundary may land _inside_ a single scalar.
- The OffsetMap must therefore be able to say “this source offset has no exact target offset; the nearest safe boundaries are …”.

If the engine later adds an optional grapheme-cluster view, that view would be a _derived_ tiling on top of the scalar atoms, not a replacement for them. The map still has to handle the scalar-level ambiguities.

---

### 2. What “ambiguity” must mean in the map

Borrowing the useful distinction from systems that already solve this (ICU `Edits`, Android Compose `OffsetMappingCalculator`, UAX #15’s definition of canonically equivalent offsets):

A point query should be able to return one of:

| Status              | Meaning                                                                                                                                                 |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Exact**           | Unique corresponding offset; the prefix and suffix on both sides are equivalent.                                                                        |
| **Boundary**        | The offset sits at the edge of a composition unit; mapping is exact for _span_ endpoints that align with the unit, but the interior is not addressable. |
| **Ambiguous range** | The source offset corresponds to a non-empty interval of possible target offsets (typical for interiors of multi-code-point units).                     |
| **Unmapped**        | No image exists (deleted / ignorable / pure insertion on the other side).                                                                               |

Important consequence: **a single integer is not a sufficient return type**. Returning only an `int` forces you to invent a bias (always map to start, always map to end, etc.) and silently loses the fact that the mapping was not unique.

Compose’s approach is instructive: when the mapping is not unique it returns a `TextRange` instead of a point. That is honest.

---

### 3. Candidate representation for OffsetMap

Two complementary views are useful.

#### A. Segment list (storage / composition)

The map is a sequence of non-overlapping segments:

```text
Segment {
  SourceStart, SourceEnd   // half-open on original master
  TargetStart, TargetEnd   // half-open on normalized master
  Kind: Identity | Expand | Contract | Delete | Insert
}
```

- `Identity` — 1:1 run (most of the text)
- `Expand` — one source unit → several target units (decomposition)
- `Contract` — several source units → one target unit (composition)
- `Delete` / `Insert` — pure loss or pure gain (compatibility, ignorables, edits)

Adjacent identity segments can be coalesced. Change segments should keep full granularity if you want fine reverse mapping; they can be coarsened for bulk projection.

This is essentially the ICU `Edits` model, specialized to two masters that Doccer already treats as immutable.

#### B. Point / span query surface (API)

```text
MapResult =
  | Exact(offset)
  | Range(start, end)          // ambiguous or boundary-expanded
  | Unmapped

MapPoint(direction, offset) → MapResult

ProjectSpan(span, policy) → ProjectedSpan | Residual
```

Projection policies (explicit, never defaulted silently):

| Policy       | Behavior when a span partially overlaps an Expand/Contract/Delete region                                     |
| ------------ | ------------------------------------------------------------------------------------------------------------ |
| **Clip**     | Intersect with the mappable portion; drop the overhang.                                                      |
| **Expand**   | Grow to the full composition unit on the target side.                                                        |
| **Drop**     | Discard the whole span if any part is ambiguous/unmapped.                                                    |
| **Residual** | Return the successfully mapped pieces _plus_ an explicit residual claim describing what could not be mapped. |
| **Refuse**   | Error if the span is not wholly exact.                                                                       |

For Doccer, **Residual** is the most consistent with the claims-first philosophy: you never pretend a partial projection was total, and the unmappable evidence stays visible.

---

### 4. Concrete edge-case table for design tests

These should become acceptance tests the moment an OffsetMap implementation appears:

| Source                                   | Target form | Source offset | Expected map result                                  | Why                            |
| ---------------------------------------- | ----------- | ------------- | ---------------------------------------------------- | ------------------------------ |
| `é` (NFC)                                | NFD         | 0             | Exact(0)                                             | start of unit                  |
| `é`                                      | NFD         | 1             | Exact(2)                                             | end of unit                    |
| `é` (NFD)                                | NFC         | 1             | Range(0,1) or Unmapped interior                      | interior of combining sequence |
| `가`                                     | jamo        | 0             | Exact(0)                                             |                                |
| `가`                                     | jamo        | 1             | Exact(2)                                             |                                |
| `가`                                    | syllable    | 1             | Range or boundary                                    | interior of L+V                |
| `ﬁ`                                      | NFKC        | 0             | Exact(0)                                             |                                |
| `ﬁ`                                      | NFKC        | 1             | Exact(2)                                             |                                |
| span `[0,1)` on NFD `é` projected to NFC | —           | —             | under Residual: residual + empty or unit-level claim | partial unit                   |

Also test composition of maps: normalize then apply an edit plan; the merged map must still report the same statuses.

---

### 5. Interaction with the rest of Doccer

- **TextMaster** stays pure. Normalization is always `original → (map, normalizedMaster)`.
- **Claims** remain bound to one master. Projection is an explicit step that can produce residuals.
- **Scalar tiling** continues to be the substrate. Grapheme-cluster or “normalization unit” views can be derived later; they do not replace the scalar atoms.
- **Same-master rebase** (slice → parent) stays a separate, total, bijective operation. Do not overload OffsetMap for it; the failure modes are completely different.
- **Default policy** for any automatic projection should be the most conservative one that still lets the caller see residuals (or Refuse). Never “pick a bias and hope.”

---

### 6. Design posture that stays consistent with the earlier decisions

1. Normalization remains optional and explicit.
2. OffsetMap is allowed to say “I don’t know a unique point” — that is a feature.
3. Ambiguity is concentrated at composition-unit boundaries and interiors; identity runs dominate real text and stay cheap.
4. Span projection always carries a policy; residual is the claims-compatible default.
5. Compatibility forms (NFKC/NFKD) are treated as _lossy transforms_. The map records the loss; it does not pretend the original is recoverable.

This gives you a map that can support:

- optional NFC for consumers that want it
- accurate round-tripping of claims that stay on exact regions
- visible residuals for claims that crossed composition boundaries
- later composition with edit plans without inventing a second ad-hoc mapping system

---

If you want to go one level deeper next, the two most useful follow-ups are:

1. **Exact segment encoding** — how compactly to store the segment list (run-length of identity + change records) and whether to keep fine vs coarse change granularity by default.
2. **Grapheme vs scalar** — whether an optional grapheme-cluster tiling should be introduced as a derived view that makes “exact unit” projection the common case for prose claims, while leaving the scalar tiling as the ground truth for the engine.

Which of those do you want to pressure-test first?
