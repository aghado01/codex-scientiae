The C# sketch is a coherent kernel, but it is not yet Phase 1-complete Doccer, much less the closed Phase 2 engine described by the relocated [`SHAPE.md`](/D:/aghado01/MarkBrain/MarkPig/doccer/legwork/SHAPE.md:48).

The omissions divide into two categories: work whose contract is already substantially specified, and operations whose semantics still need refinement before implementation.

## 1. Specified work that the sketch simply did not implement

| Capability         | Current sketch                                      | What remains                                                                    |
| ------------------ | --------------------------------------------------- | ------------------------------------------------------------------------------- |
| Universal sweep    | Scalar tiling, category, validity, line topology    | Atom type, Unicode block/script, run emission, diagnostics, source encoding     |
| `SpanBatch` schema | Starts/ends/kind/level/source/priority/rule columns | Interned type/language/pass IDs, register columns, values, metadata             |
| Pattern inventory  | In-memory regex `PatternRule`                       | JSONL loader, all five synthesis modes, schema validation, provenance           |
| Suppression        | Absent                                              | Bitmap construction, query-aware suppression, idempotence laws                  |
| Sorted lookup      | Start/end/ordinal ordering                          | Priority-aware ordering and stronger indexed queries                            |
| Tier 1             | Coverage and bounds                                 | Reconstruction, registers, line consistency, suppression, resolution invariants |
| Tier 2             | Basic relation/cardinality runner                   | Direct-versus-derived matching, tolerances, agreement scoring                   |
| Tier 3             | Basic forbidden relations                           | Suppression exceptions and inventory-driven declarations                        |
| Tree view          | Roots and children                                  | Parent and ancestor queries, full-coverage/residual treatment                   |
| Property laws      | Boolean laws and examples                           | Projection, suppression, laminarity, offsets, randomized SMP combinations       |

In particular, the current `TextTopology` is not yet the `UniversalAtoms` batch defined in [`UNIFIED-SWEEP.md`](/D:/aghado01/MarkBrain/MarkPig/doccer/legwork/UNIFIED-SWEEP.md:16). It keeps scalar records separately and lacks block, script, and atom-type classification.

Likewise, the current [`SpanBatch`](/D:/aghado01/codex-scientiae/src/doccer/Core/SpanBatch.cs:125) demonstrates the SoA/AoS contract but is much narrower than the columns in [`SCHEMA.md`](/D:/aghado01/MarkBrain/MarkPig/doccer/legwork/SCHEMA.md).

These were omitted to keep the first code pass architectural. They do not need new use-case justification; they belong in Doccer proper.

## 2. Operations deferred because their contracts are not yet safe

### `OffsetMap`

Normalization, insertion, and deletion are generally not bijective. A deleted source region maps to no target text; inserted text has no unique source; a replacement of unequal length has ambiguous interior boundaries.

Therefore “composition/inversion” and “round-trip exactness” cannot be implemented honestly as a simple `int → int` map. The specification needs:

- Boundary bias or ambiguity ranges.
- Representation of unmapped source and target regions.
- Span projection rules.
- Exactness laws limited to preserved coordinates.
- A distinction between same-master rebasing and cross-master transformation.

### Level projection

`Character`, `Line`, and `MultiLine` currently mix coordinate systems, execution scopes, and structural classifications.

The contract must distinguish:

- Projecting a character span to the lines it intersects.
- Grouping character claims into a line-level derived claim.
- Running a recognizer independently within each line.
- Rebasing a slice-local result into its parent master.
- Creating a new child master from a slice.

Those are separate operations, despite all being called “lift” or “at-level” in earlier code.

### Density

“Density” currently conflates at least three measurements:

- Covered code units per window.
- Number of claims per window.
- Number of register/token recognitions within an admitted region.

Each needs a named numerator, denominator, window type, boundary policy, and overlap policy. Until those are explicit, one `Density` verb would reproduce the current ambiguity.

### Byte addressing

Recording `Encoding SourceEncoding` beside an already-decoded .NET string is insufficient for exact byte addressing. Exact byte pointers require original bytes or a decoding map, especially around BOMs, invalid sequences, and normalization.

This should be reconciled with `OffsetMap`, not bolted onto `TextMaster` later.

### Persisted batches

A persisted format would freeze decisions about:

- Master identity.
- Unicode database version.
- Encoding and address units.
- Interned ID tables.
- Metadata typing.
- Offset-map representation.
- Schema evolution.

The in-memory model should settle first.

## 3. Design-anchor issues worth resolving

The legwork itself contains several tensions that explain why immediate implementation would be risky.

- The four atom types—word, punctuation, whitespace, newline—do not classify symbols, combining marks, controls, formatting characters, or surrogates cleanly.
- Run emission says a run breaks when atom type, block, or script changes, but each run also carries one category. `Lu` followed by `Ll` would either require a category break or produce an incoherent category value.
- `sum(span.Length) == Text.Length` does not prove exact coverage; an overlap and a gap can cancel. The cursor-based invariant in the C# sketch is stronger.
- Unicode block and script classifications need a pinned Unicode-data version. .NET provides categories but not the complete block/script tables proposed by the design.
- `is_mask` probably should not be an intrinsic pattern property. A code block suppresses Markdown-heading recognition, but its contents remain relevant to a code-language collector. Suppression should be a named query policy.
- The proposed regex loader rules are too syntactic. A line-level pattern need not contain `^...$` if the collector executes it separately within each line; a multiline pattern can cross lines without `Singleline`.
- Global pattern priority may be a useful default, but resolution priority should remain query-policy-dependent.

The 64 KB LUT also needs reframing. Semantic classification and complete coverage are engine contracts; a LUT is an implementation strategy. That matters because the same documents call performance optimization deferred while also treating the LUT as load-bearing.

## 4. What should be recovered from `masks.ps1`

[`masks.ps1`](/D:/aghado01/codex-scientiae/src/shared/masks.ps1:56) contains several capabilities that belong in or immediately above Doccer.

| Existing operation              | Appropriate future home                          |
| ------------------------------- | ------------------------------------------------ |
| Span normalization/coalescing   | `SpanSet` core—already substantially implemented |
| Union/intersection/subtraction  | `SpanSet` core—already implemented               |
| Complement                      | Core; master or explicit `SpanSet` universe      |
| Empty/coverage/equality         | Core properties and equality                     |
| Code-point boundary checking    | `TextMaster` coordinate validation               |
| Suppression coverage            | Doccer structural algebra                        |
| Rendering blanked/retained text | Mask/view helper above Doccer                    |
| Scoped regex recognition        | Collector, not mask algebra                      |
| Line splitting                  | `TextTopology`                                   |
| Same-master translation         | Explicit coordinate algebra                      |
| Slice restriction and rebasing  | `TextSlice`/slice-map operations                 |
| Random algebra laws             | Doccer property-test suite                       |
| “Pincer” coincidence            | Level-projection law, once its domain is stated  |

Some current behavior should not survive unchanged.

### `Get-MaskedText`

The comment says blanking excluded regions prevents later matches from fusing across them. It does not. I verified that retaining `foo` and `bar` around an excluded region produces:

```text
foo        bar
```

and `foo\s+bar` still matches across the excluded gap.

Doccer should run recognition independently within each admitted interval, as the new `RegexCollector` already does. Blanked text remains useful for display, offset-preserving diagnostics, or compatibility—but not as a safe scoped-recognition mechanism.

### `Get-MaskDensity`

This should be decomposed into:

```text
collect register claims within admitted regions
                    ↓
select their interval set
                    ↓
count or measure those claims over explicit windows
```

Its `-AsSpans` form is really scoped collection, while its scalar return is aggregation. Neither requires text blanking.

### `Move-Mask`

This is not a general `OffsetMap`; it is local-to-parent translation. It also cannot uphold its stated Unicode safety because it lacks the target text. I verified that it can move a one-unit span to `[2,3)` over `a😀b`, splitting the surrogate pair.

The replacement needs an explicit parent/slice relationship and must validate against the destination master.

### `Limit-Mask`

This conflates two operations:

- Restrict a set to a region while retaining the same master coordinates.
- Rebase that result to a new slice-local coordinate system.

The first is ordinary intersection. The second creates a child master and needs a slice map.

### Permissive repair

The legacy normalizer reverses spans, clamps out-of-range coordinates, and silently discards invalid extents. That may be useful when importing dirty legacy data, but it should not be core behavior.

Doccer must accept broken text. It should not silently accept broken coordinates produced by an engine bug. A compatibility importer can offer explicit `Clamp` or `Repair` policies.

## 5. Shape of the replacement `masks.ps1`

The replacement should contain no interval algorithms. It should be a PowerShell convenience surface over `CodexSci.Doccer.dll`.

Conceptually:

```text
src/doccer C# engine
    TextMaster
    SpanBatch
    SpanSet
    TextTopology
    suppression/query/projection operations
                    ↓
PowerShell mask helpers
    ergonomic construction and selection
    blanked/retained text rendering
    legacy shape conversion
                    ↓
LaTeX and other domain adapters
    pattern inventories
    scanners
    workflow decisions
```

A prospective API might look like:

```powershell
$master = New-DoccerMaster -Text $text -DocumentId $path -Revision 0

$claims = Find-DoccerPattern `
    -Master $master `
    -Rules $rules `
    -Within $allowedRegion

$comments = Select-DoccerMask -Batch $claims -Kind tex.comment
$prose    = Get-DoccerMaskComplement -Mask $protected
$coverage = Measure-DoccerMask -Mask $prose -Measure Coverage

Get-DoccerMaskedText -Mask $comments -Mode BlankIncluded
```

The helper layer should:

- Return typed `SpanSet` objects.
- Require or preserve a `TextMaster`.
- Delegate every set operation to C#.
- Never use maximum lengths to reconcile incompatible masks.
- Never recreate Unicode-boundary logic.
- Keep text rendering separate from scoped matching.
- Expose explicit legacy conversion where necessary.

The LaTeX functions should then become claim producers and query composers:

```text
raw comment claims − verbatim claims = TeX comment mask
whole master − comments − verbatim = expandable mask
whole master − comments − verbatim − math = prose mask
bare ampersand claims − environment coverage = alignment defects
```

Macro expansion should collect macro invocations directly within the expandable `SpanSet`, rather than searching blanked text. Comment removal remains an external transformation operation consuming comment spans; it does not belong in Doccer’s read/analyze/localize engine.

## Recommended order

1. Reconcile the atom taxonomy, run-emission key, source bytes, suppression policy, and priority policy in the legwork.
2. Finish the Phase 1 substrate: full columns, universal atoms, inventory loader, suppression, and Tier‑1 invariants.
3. Promote the sound mask-derived operations: explicit coalesce/runs, suppression, restriction, slice/lift, and their laws.
4. Specify the distinct density measures and `OffsetMap`.
5. Create the typed PowerShell mask layer.
6. Re-express the existing mask tests against the DLL.
7. Migrate LaTeX consumers, using behavioral equivalence as a witness rather than allowing them to define the engine.

No files were changed during this audit.
