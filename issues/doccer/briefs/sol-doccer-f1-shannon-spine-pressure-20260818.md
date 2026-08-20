# Doccer F1 pressure — Shannon admitted spine

Runstamp 20260818. **Status: draft pressure brief. Does not mint a D-number. Does not implement
`OffsetMap`. Does not promote a durable adapter.**

This brief records what the first real rewrite job did to the drafted F1 surface, so the
forthcoming contract chip adjudicates against a specimen instead of NFC-first folklore.

Companion narrative and census: [admitted-spine Rocky training](../discussions/grok-doccer-admitted-spine-rocky-training-20260818.md).
Witness report: [doccer-spine-witness.json](../../../ingestion/staging/macy-cybernetics-1946-1953/1950/doccer-spine-witness.json).
Recipe (not a verb): `src/pdf-prose/witness-doccer-spine.ps1` + `src/pdf-prose/inventories/macy-spine.jsonl`.

Inputs: drafted F1 row in [decisions.md](../planning/decisions.md); Thread 3 F1 gate in
[status-registry.md](../planning/status-registry.md); [grok-offsetmap-unicode](../discussions/grok-offsetmap-unicode.md);
closed K6/K7; pdf-prose lossless `Text` / `textRender` via `non-ascii.json`.

## 1. Disposition

The shaping consumer for F1 is **a performed K7 rewrite**, not Unicode NFC and not a markdown
file. pdf-prose admits a linear spine; Doccer collects/pairs/suppresses on that master; a
`RewritePlan` (Copy / OriginMapped) realizes `textRender`. The OffsetMap-shaped object in the
witness is a **compressed monotone alignment** derived from that plan’s pieces.

K6 `OriginRelation` already records atom-to-atom lineage. F1 is the **offset query** over the
same performed transform (point and, later, span). It must not become a second origin truth.

## 2. Specimen (measured)

Admitted Shannon (PDF 249–273, roles `body` | `page-marker` | `float-caption` + one `U+FFFC` hole;
headers/folios dropped):

| Quantity | Value |
|---|---|
| Spine UTF-16 units | 86 859 |
| Output (`textRender` + `\uFFFC` escape) | 88 052 |
| K7 pieces | 1141 |
| Segment ops | Identity 776, Expand 365, Contract 0, Delete 0, Insert 0 |
| Unused source coverage | 0 |
| `renderMatch` vs joined IR `textRender` | true |

Expands observed: ligature `FB01`/`FB02` → `fi`/`fl` (1→2); default `\uXXXX` (1→6), including the
float hole. Letters (`é` etc.) stayed Identity copies. No soft hyphen, so Delete is still
unwitnessed. No Synthetic-only Insert.

## 3. Lessons that should enter the F1 contract chip

These are proposed adjudications for the open F1 questions. They are not yet decisions.

### 3.1 Consumer and direction

- **First witness is lossless → render**, both masters UTF-16. NFC/NFD remains a later producer
  of the same map type, never the default and never implicit in `TextMaster`.
- **Both directions** are required. This run only queried **forward**. The first interesting
  backward case is dest-interior of an Expand (`fl` dest `[269, 271)`: offset 270 has no unique
  source point).
- Half-open segments. A point on a shared `srcEnd`/`srcStart` belongs to the later segment.

### 3.2 Point results: Exact | Range | Unmapped is enough for this job

Forward probes (5/5):

| Probe | src | Result |
|---|---:|---|
| Identity interior | 17 | Exact → 17 |
| Ligature `fl` | 269 | Range `[269, 271)` |
| Float hole `U+FFFC` | 1739 | Range `[1742, 1748)` |
| Default `\uXXXX` | 4768 | Range `[4781, 4787)` |
| Letter keep | 10176 | Exact → 10231 (dst shifted by prior expands) |

Draft discussion also names **Boundary**. On this specimen a BMP ligature is **one source unit**:
there is no source-interior offset inside `U+FB02`. Boundary vs Range is not forced **forward**.
It is forced **backward** on dest interiors, or on NFD→NFC later. Recommendation: keep the
three-way point result; treat “span endpoint aligned with an Expand unit” as a **span-projection**
policy (exact if the span covers the whole source unit), not a fourth point status, until a
backward/NFC witness needs Boundary as a point.

A single `int` return is insufficient. Confirmed.

### 3.3 Segment invariants (witnessed)

Derive segments from K7 pieces:

| Piece | Segment kind | Length law |
|---|---|---|
| `Copy` | Identity | `\|src\| = \|dst\| > 0` |
| `OriginMapped` longer | Expand | `\|dst\| > \|src\|` |
| `OriginMapped` shorter | Contract | `\|dst\| < \|src\|` (unseen) |
| elided atom, no piece | Delete | `\|dst\| = 0`, `\|src\| > 0` (unseen) |
| `Synthetic` with no source | Insert | `\|src\| = 0`, `\|dst\| > 0` (unseen) |

Proposed coverage laws for a complete performed plan:

- source `[0, srcMaster.Length)` is partitioned by Identity ∪ Expand ∪ Contract ∪ Delete
- dest `[0, dstMaster.Length)` is partitioned by Identity ∪ Expand ∪ Contract ∪ Insert
- `sum(dst lengths) = dstMaster.Length` (held: 88 052)
- Delete/Insert never appear as empty-empty

F1 storage can merge adjacent same-kind Identity runs; the witness did not (1141 pieces). Merging
is representation, not semantics.

### 3.4 Construction, not a second workflow

Do not trust ingest order to “converge” offsets. Build the map from the **same** `RewritePlan`
that produced the output master (or from an explicit Normalize producer). Canonicity of the
alignment is a property of that construction.

F7b: this producer already emits K6 origins. F1 queries coordinates; it does not license
provenance. Post-hoc diff of two strings is F7a, not F1.

### 3.5 What this job does not settle

- Contract, Delete, Insert segments
- Unpaired-surrogate Expand (policy exists; Shannon had none)
- Map **composition** (one hop only)
- Span projection policies (`Clip` / `Expand` / `Drop` / `Residual` / `Refuse`)
- NFC/NFD/NFKC interiors and combining-mark holes
- Grapheme clusters (still out of scope; atoms stay scalars)
- F3 byte maps

Residual remains the right default for unbuilt span projection.

## 4. Adapter / recipe lessons (not F1, do not mint)

Recorded so the F1 chip does not accidentally absorb them.

- **IR assembly, not markdown.** Doccer sees the admitted spine. Markdown stays a later consumer.
- **Recipes, not verbs.** Consecutive-start turns; convention choice for quotes; F1-shaped
  queries in PowerShell. Promote only after composition-refusal.
- **Quote facing is document-local.** Unicode LEFT `«` / RIGHT `»` are inventory labels, not
  open/close. Diaphanes Macy is German `»…«`. Running both conventions through unchanged
  `Pairing.Pair` and keeping the lower-fault residue: French 50/2, German **51/0**. A
  word-local `»word«` pre-pass over-fit (`» next «` between adjacent marks; `»language.«`
  with a period). Do not widen reference `Pair`.
- **Float holes are spans.** `U+FFFC` on the spine; render escapes to `\uFFFC` (Range 1→6).
- **Markers stay on the spine** and leave the body channel via `Suppression.Admitted`.
- **Do not walk 10⁴ atoms in PowerShell.** Build the plan from per-block IR specials + joiners.

## 5. Proposed F1 chip scope (when opened)

1. Freeze point query `Exact | Range | Unmapped` on one pair of compatible-master windows, both
   directions, half-open segments, coverage laws in §3.3.
2. Constructor: **from an ordered segment list** and/or **from a materialized K7 plan** (Shannon
   as the first in-harness fixture: ligature Expand, `\u` Expand, Identity keep, no Delete).
3. Leave span projection and compose as the immediately following chip unless they fall out of
   the same finite oracle cheaply.
4. One harness fixture may be a **tiny** NFC pair later; it is not the authorizing specimen.

## 6. Non-goals

Page geometry in F1. E-graphs / math-register saturation. Widening `Pair`. A durable
`src/doccer` PDF adapter. Treating the witness script as public API.
