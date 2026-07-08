# Crop-bbox inflation by invisible geometry — A2b follow-up scope (2026-07-07)

**Status:** LANDED 2026-07-08 (B1 implemented + gated — see [Landed (B1)](#landed-b1-2026-07-08)). Grew out of the A2b landing (`34346f2`): 6 of 7 members that dragged
1701 Fig 7's region bbox down past its caption were **clipping paths**, which suggested a general rule —
*invisible geometry should not inflate a figure's crop rect*. Probing that idea corpus-wide
(`scratch/clip-inflation-probe.ps1`) **reframed it**, and the reframe is the main deliverable of this note.

## The reframe: "exclude clip paths" is the wrong signal

The region bbox = `Get-FigureUnionBbox` over ALL members (paths + xobjects). It drives the **crop** (the
rasterizer renders the page at that rect), the **kind gates** (area/em²/density), **caption attachment**
(gap), and the veto passes. A member whose bbox is larger than the ink it represents inflates all of these.

The naive fix — drop `is_clipping=true` members from the bbox — is **insufficient**, because *paint status,
not clip status, is the true visibility signal*, and there are three kinds of bbox-inflating member:

1. **Clip paths** (`is_clipping=true`, unpainted) — invisible masks. e.g. 1701 Fig 7's 6 clip rects, and
   Fig 2's (id4) 5 clip rects (ids 4/13/15/17/19) that top the bbox 1.3em past the painted ink.
2. **Unpainted non-clip paths** — constructed-but-not-painted geometry (rare).
3. **Painted background FILLS** (`is_filled=true` but WHITE/page-colored) — visually invisible yet
   "painted". **1701 Fig 7's id49** is exactly this: a whole-region white fill (399→728) that reaches down
   into the caption band. It survives BOTH "exclude clips" AND "exclude unpainted" — it is filled.

So the members that inflate a crop split into **(a)** unpainted geometry (classes 1+2 — detectable now from
`is_stroked ∨ is_filled`) and **(b)** painted background fills (class 3 — needs the path's COLOR, which the
IR does **not** emit: `paths.jsonl` carries `is_clipping/is_stroked/is_filled/line_width/kinds` but no
color/`rule` fill value; roadmap §E "today only a boolean is_clipping").

## Prevalence (measured, both corpora, newest runs)

`scratch/clip-inflation-probe.ps1` over **492 figure regions**:
- **28 regions carry ≥1 invisible (unpainted) member** (945 such members total — 943 clip boundaries +
  2 non-clip unpainted, confirming class 2 is vanishingly rare); **0** all-invisible
  regions (nothing ever collapses). Dropping unpainted members can never remove visible ink *by definition*
  (unpainted = `¬is_stroked ∧ ¬is_filled` = nothing rendered).
- Class **(a)** — bbox inflated **>0.5em past PAINTED ink**: **exactly 1 region** corpus-wide — 1701 id4
  (Fig 2, captioned): 5 clip rects top the bbox **+1.3em** past painted ink (696→708), a text line in the
  band. That is the entire class-(a) fire-set. Small and mild.
- Class **(b)** — the SEVERE case (1701 Fig 7, whole-caption weld) is a white-FILL problem, invisible to the
  paint signal, and is **already handled** by A2b's caption-top trim. Its uncaptioned cousins (a background
  fill with no caption to trim against) are the open tail — but the probe found the severe band is rare.

**Takeaway:** the general idea is real but small, and it is NOT one fix — (a) is a cheap color-agnostic
polish; (b) is an instance of the **IR color-enrichment thrust (§E)**, not a standalone win.

## Landed (B1, 2026-07-08)

Implemented and gated. **Formation lane** (`pdfdig-figures.ps1`): `Get-FigureVisibleBbox` unions the
PAINTED members (`prov=xobject ∨ is_stroked ∨ is_filled`); `New-FigureRegionRecord` and
`Merge-FigureGroup` emit `visible_bbox` **only when it differs from `bbox`** (`Test-BboxEqual`) — so the
field is absent on the 99%+ of regions with no boundary-inflating invisible member. **Crop lane**
(`pdfdig-images.ps1`): `Get-FigureCropBbox` = **`visible_bbox ∩ bbox`**, then the existing letter-grow.

**Why intersection, not `?? ` — the scope's one miss.** `visible_bbox` is computed at formation, BEFORE
A2b trims `bbox` (`pdfdig-figures.ps1:698`, verified the *sole* post-formation bbox mutation). For 1701
Fig 7 (id16) the class-(b) white FILL (id49) is *painted*, so `visible_bbox` includes it down to y398.78 —
BELOW A2b's caption-top trim (y495.26). A naive `visible_bbox ?? bbox` crop would re-expand past A2b and
re-weld the caption (a regression). The intersection clamps paint to the final (trimmed) region: A2b's
crop is preserved **exactly** (id16 rendered delta `[0,0,0,0]`) while genuine class-(a) bands still
tighten. This is the concrete form of the note below that "(b) folds into §E … A2b could revert to
attach-only" — until color exists, A2b owns Fig 7 and B1 is a deliberate no-op there.

**Gate — both corpora** (`scratch/verify-b1-corpus.ps1`, re-run formation vs committed figures.jsonl):
**33 papers, 1480 regions, 0 non-`visible_bbox` field mismatches** → PRIMARY-invariant (bbox/area/density/
kind/caption/ids all byte-identical). **4 regions gain `visible_bbox`** (all voroninski; ph-zigzag none):
1506 id111 (left −1.8pt), 1701 id4/id16/id17. (Only 4, not the 28 invisible-member regions — most
invisible members are interior and don't move the union boundary.)

**Rendered-crop delta** (`scratch/verify-b1-crop-all.ps1`, after letter-grow @150dpi): max **3.8px** (1506
id111 left edge); 1701 id4 ≤1px, id16 **0px** (A2b), id17 0.6px. The probe's lone >0.5em case (id4, +1.3em
top) turned out to hold **node label "P"** (the pinhole point) in that band — a real figure label, not
stray text; letter-grow re-adds it, so the net crop moves ~1px. **No painted ink or node label is clipped
anywhere** — excluded members are unpainted by definition (painted ink ⊆ `visible_bbox`), and letter-grow
re-adds any label that sat in a trimmed band.

**Tests (76 green):** `tests/pdfdig-images.Tests.ps1` (6 — `Get-FigureCropBbox`: no-field passthrough,
class-a tighten, the A2b clamp, per-edge intersection, degenerate-intersection fallback, fresh-array);
`tests/pdfdig-figures.Tests.ps1` (+6 — clip contraction, class-2 bare-unpainted, xobject-kept, all-painted
control, all-unpainted guard, `Merge-FigureGroup` visible union).

Class **(b)** (color-blind white fills) is untouched by this landing and remains an §E consumer.

## Why A2b already covers the case that mattered

A2b trims to the **caption top** — a color-agnostic boundary that sidesteps member classification entirely.
That is precisely why it fixes Fig 7 (whose envelope is a white fill the paint signal cannot catch) where a
"tighten to painted ink" rule would not. A2b and this follow-up are **complementary**: A2b fixes the
captioned weld; (a) tightens residual clip bands (captioned or not); (b) awaits color.

## The clean home already exists

`pdfdig-images.ps1:69` already **decouples the crop rect from the gate-bbox**: it starts at `region.bbox`
and only GROWS it by attached letter-block boxes ("the region record's own bbox stays geometric; only the
render rect grows"). Class (a) is the mirror operation — CONTRACT the base rect to painted ink before the
letter grow. Two placements:

- **B1 (recommended): a formation-computed `visible_bbox`.** In `pdfdig-figures.ps1`, where members and
  their flags are already in hand, compute `visible_bbox` = union of PAINTED members (`is_stroked ∨
  is_filled`) ∪ xobjects, and store it on the record when it differs from `bbox`. `pdfdig-images.ps1` bases
  the render rect on `visible_bbox ∩ bbox` (the intersection, **not** `?? ` — see Landed for why A2b forces
  it), then grows by letters as today. **PRIMARY-invariant by
  construction** — `bbox`/area/density/caption untouched; only the render rect tightens. Member access stays
  in the lane that already has it; crop lane is a one-line base swap.
- **B2: contract inside the crop lane.** `pdfdig-images.ps1` loads `paths.jsonl` and recomputes per figure.
  Duplicates member reconstitution into the crop lane — rejected.

(Option C — recompute `region.bbox` in place — is rejected: it moves the gate bbox and risks PRIMARY via
caption gaps / kind gates for no deliverable benefit over B1.)

## Risk

- Class (a) via B1: **zero PRIMARY risk** (crop-only; gate bbox untouched) and **zero ink-loss risk** —
  excluded members are unpainted, so painted ink is a superset of what we keep *by definition*. Letter-grow
  still re-adds any node label that sat low. Guard: if `visible_bbox` would be empty (all-invisible region —
  probe found 0 of 492), fall back to `bbox`.
- Class (b): needs §E color; do NOT attempt geometrically (a whole-region white fill and a whole-region black
  panel are identical in the current IR).

## Calibration + acceptance (if (a) is taken)

1. `scratch/clip-inflation-probe.ps1` IS the calibration — its paint-based inflated set is the exact fire-set
   to eyeball (currently ~1 region + id4-class).
2. Regenerate the affected papers; **gate BOTH corpora — must be byte-identical** (crop-only change).
3. Eyeball the tightened crops vs current; confirm no painted ink or node label is clipped.
4. Unit test in `tests/pdfdig-images.Tests.ps1` (or figures): a region with an oversized clip rect gets a
   `visible_bbox` excluding it; a region of all-painted members has `visible_bbox == bbox`.

## Recommendation / sequencing

- **(a) is a low-urgency, safe, cheap polish** — worth folding in the next time the crop lane is touched
  (e.g. alongside thrust F docling-lane images), NOT a standalone priority: prevalence is ~1–2 regions with
  ≤1.3em bands, and A2b already took the visible-hole cases.
- **(b) folds into thrust §E** (per-path color-bucket): once color exists, "drop background-colored fills
  from `visible_bbox`" makes B1 catch Fig 7's class too, and A2b's bbox trim could revert to attach-only
  (relying on `visible_bbox` for the crop) — a future simplification, noted not scheduled.
- Net: **no new standalone thrust.** Record (a) as a rider on the crop lane and (b) as an §E consumer.

Probes: `scratch/clip-inflation-probe.ps1` (prevalence + edge cases), `scratch/bottom-band-calib.ps1`,
`scratch/interior-cut-diag.ps1` (A2b). See [[tier3-engineering-plan]] §2-E/F.
