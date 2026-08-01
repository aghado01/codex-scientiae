Your instinct is correct, and the existing design anchors already point the same way.

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
