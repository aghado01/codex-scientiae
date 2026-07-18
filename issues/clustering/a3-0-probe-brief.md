# A3-0 — the four-layer caption-localization probe (chip brief)

**Status: DEPOSITED 2026-07-17 for chip pickup. Scope: PROBE + REPORT ONLY — no implementation.**
The executing agent appends its report to this brief under `## Probe report` (see Deliverables).
Parent context: [frontier-20260715.md](frontier-20260715.md) §2 (A3-0 spec + the predeclared
A3-vs-D decision rule) and §3 (protocol); historical log
[tier3-engineering-plan.md](tier3-engineering-plan.md) §A.

## Why this probe

The last non-oracle-noise PRIMARY unders on the calibration battery are three missing captioned
floats. The old binary question ("do the caption's words exist?") collapses several failure
locations with different fixes — the probe must LOCALIZE each miss along the lane pipeline
(protocol clause: probes localize, never merely detect).

## Targets (three floats, two papers, both `gauntlet/ph-zigzag`)

| paper | gate row | floats | prior diagnosis (re-verify — premises go stale; region ids renumber per run) |
|---|---|---|---|
| 2210.00916 | −2 missed-figure | Fig 1, Fig 4 | Fig 1 = caption never became a Lane-3 block; Fig 4 = in-text-ref-only visibility (A1/A2 landing record) |
| 2302.12796v2 | −1 missed-figure | 1 float | the A2-exposed miss (a Table-1 exact-count coincidence masked it pre-cue-split) |

Ground every check by **figure identity + PDF coordinates** (the oracle sidecar/`-latex.md` gives
the caption text; locate its glyphs by content + position) — never "some nearby text".

## The four layers (run each miss through ALL four; the answer is a per-float verdict vector)

| layer | lane artifact (newest pig run) | failure it isolates |
|---|---|---|
| 1 | caption glyphs in `{slug}.letters.jsonl` | extraction failure |
| 2 | caption tokens in `{slug}.words.jsonl` | word-assembly failure |
| 3 | line/block assembly in `{slug}.blocks.jsonl` | XYCut/block failure vs block-text fragmentation |
| 4 | typed nodes in `{slug}.nodes.jsonl` + the attachment pass (`{slug}.figures.jsonl` caption field) | attachment failure |

Newest runs resolve via the standard newest-wins convention under
`ingestion/gauntlet/ph-zigzag/{slug}/.runs/{stamp}/pig/`. If the newest run predates current
code in a way that matters, regenerate with `. src/ingest-batch.ps1; Invoke-IngestBatch -Path
gauntlet/ph-zigzag/{slug} -JobTypes pig -Force` (or target the PDF file directly — explicit file
= imperative).

## Acceptance frame (predeclared — do not reinterpret)

- The probe SUCCEEDS by producing, for each of the three floats, a localization verdict:
  which layer the caption dies at, with the evidence (glyph/token/block/node ids + coords).
- **If letters/words survive (layers 1–2 pass)** → the indicated fix is a **bounded caption
  rescue** (the lenient-cue idiom the attachment scan already uses, reusing the existing
  style/geometry/separator/in-text-reference guards) — record that verdict; do NOT build it.
- **If nothing survives layer 2** → the fix is IR-engine work — record it as such with a rough
  cost estimate; do NOT build it.
- The eventual implementation (NOT this chip) must recover the three floats with target-number
  assertions, zero new caption claims, zero PRIMARY overs, both calibration corpora.

## Protocol (frontier §3, binding)

- Probe scripts live under `scratch/` (force-add past the ignore: `git add -f scratch/a3-*.ps1`);
  carry an iteration record in the header if the statistic evolves.
- Re-diagnose from CURRENT-run geometry — the prior per-float diagnoses above are hypotheses,
  not facts (the A1/A2 lesson: named ids and defect classes go stale across refreshes).
- Read-only with respect to the lanes: the probe inspects runs; it does not modify converter
  code or config.
- PowerShell engine style: explicit loops/typed collections; ordinal string comparisons
  (culture traps are recorded in memory); UTF-8-no-BOM for anything written.

## Coordination (multi-chip discipline)

This chip touches ONLY `scratch/a3-*.ps1` and this brief. The D-0 sibling probe (2112 glyph
clusters) and all implementation work stay with the parent thread. Commit cadence: commit the
probe script + the report append together when the census is complete; message prefix `A3-0:`.

## Deliverables

1. `scratch/a3-probe.ps1` — the four-layer walker (per-float, per-layer, evidence-bearing).
2. `## Probe report` appended below: per-float verdict vectors, the layer-of-death census,
   the indicated-fix classification (bounded rescue vs IR-engine + cost), and any premise
   corrections against the prior diagnoses.
3. One commit containing both.

---

## Probe report

**Executed 2026-07-18 · probe `scratch/a3-probe.ps1` (v2) · runs: 2210.00916@20260715_063739,
2302.12796v2@20260707_025336 (its figures.jsonl = the 2026-07-15 convergence regen on those
lanes) · config: caption_max_gap_em=4.5, caption_min_overlap_frac=0.25, body_pt=10.9 both papers.**

### Layer-of-death census — one sentence

**All three captions fully survive layers 1–2 (glyphs and tokens intact, zero unworded letters)
and die at the SAME boundary: the attachment scan's cue test over the Lane-3 block's first 14
characters — with every OTHER attachment guard (overlap, gap, kind=figure) passing.** Two distinct
Lane-3 shapes produce the one cue failure.

### Per-float verdict vectors

**2210.00916 Figure 1 — "General pipeline illustration." (p4)**

| layer | verdict | evidence |
|---|---|---|
| 1 letters | **PASS** | cue+caption glyphs contiguous: letters 5579–5613 p4; phrase bbox [251.53,418.2,383.7,427.99]; stream reads `Figure1:Generalpipelineillustration.` |
| 2 words | **PASS** | words 1363–1365 tokens `General pipeline illustration.`; 0 unworded letters |
| 3 blocks | **FRAGMENTED (per-word)** | caption row y=[420.3,428.0] shattered into 5 single-line blocks: b663 `Figure` [203.48,420.3,234.06,427.73] · b664 `1:` · b665 `General` · b666 `pipeline` · b667 `illustration.` — inter-block x-gaps ≈3.6–4.8 pt (ordinary word spaces); the same-row scan shows the row contains exactly these five |
| 4 nodes+attach | **FAIL — cue only** | nodes 758–760 typed prose; mirror vs region 0 (kind=figure, [132.51,461.68,326.03,693.32]): overlap PASS, below-gap 33.7 pt = **3.1 em** PASS, kind PASS, `cue_in_14` **FAIL** on every fragment (no single block carries cue word + digit: b663 = `Figure` digit-less, b664 = `1:` cue-less) |

**2210.00916 Figure 4 — "Pyramid for the case n=3, …" (p16)**

| layer | verdict | evidence |
|---|---|---|
| 1 letters | **PASS** | letters 20342–20366 p16; stream reads `Figure4:Pyramidforthecasen=3,withjiX:=Xi…` |
| 2 words | **PASS** | words 5043–5046 tokens `Pyramid for the case` |
| 3 blocks | **FRAGMENTED (per-word)** | same class as Fig 1, deeper: the same-row scan finds 13 per-word/per-symbol blocks across row y=[490.14,497.8] — b1015 `Figure` [158.08,490.14,188.67,497.57] · b1016 `4:` · b1017 `Pyramid` · b1018 `for` · b1019 `the` · b1020 `case` · b1021 `n` · b1022 `=` · b1023 `3,` · b1024 `with` · b1025 `j X i` · b1026 `:=` · b1027 `i n X ∪ X . 0 j` (the math tail shatters too) |
| 4 nodes+attach | **FAIL — cue only** | mirror vs region 24 (kind=figure, [108.09,526.11,480.25,735.16], the only region on p16): overlap PASS, below-gap 28.4 pt = **2.6 em** PASS, kind PASS, `cue_in_14` FAIL on every fragment |

**2302.12796v2 Figure 5 — "Parts of the sub-forests MF^{i+1}(F), MF^{i+1}(F′). Node level
increases from left to right." (p11)**

| layer | verdict | evidence |
|---|---|---|
| 1 letters | **PASS** | both phrases found: letters 23501–23581 p11; stream reads `Figure5:PartsofthesubforestsMFi+1(F),MFi…` |
| 2 words | **PASS** | words 5516–5519 + 5528–5534, all in one block |
| 3 blocks | **ASSEMBLED-BUT-POLLUTED** | block 295 [77.26,528.09,534.74,537.81] holds the FULL caption intact as line 816 (`Figure 5: Parts of the sub-forests …`, modal_size 10.9, cue at char 0 of the line) — but two superscript mini-lines prepend in block text order: line 814 `i+1 i+1` (size 8, the MF^{i+1} exponents) + line 815 `′` (the F′ prime) → block head = `i+1 i+1 ′ Figu` (cue word starts at char 10; the digit falls outside the 14-char window) |
| 4 nodes+attach | **FAIL — cue only** | the pollution even reaches node typing (node 2450 `′` = formula-block, nodes 2446–2449 role=math) while the caption itself is prose (node 2451 `Figure 5: Parts of the sub-forests`); mirror vs regions 14 [190.08,544.49,269.39,670.17] and 15 [337.42,544.49,416.73,670.17] (both kind=figure, the two side-by-side forests): overlap PASS, below-gap 6.7 pt = **0.6 em** PASS, kind PASS, `cue_in_14` FAIL |

Consistency bonus: had the cue passed, regions 14+15 attach to the same caption block →
`Group-SubfiguresByCaption` merges them into ONE captioned float — exactly the oracle's single
Figure 5. The rescue closes −1 → 0 with no over from this page (regions 16/17 are kind=mark,
22–41 em away, and fail the kind gate regardless).

### Cue census (the A1/A2 in-text-reference guard, re-verified per float)

Each target number occurs exactly twice in its letters lane: once as the caption head, once as an
in-text reference — and every in-text reference is MID-block (block heads `Finally, the a…` p36 /
`Example 3.5 (P…` p15 / `i+1 e is negat…` p10), so any block-start/line-start-anchored cue keeps
them unattachable. All three captions carry the cue-then-SEPARATOR signature (`1:` `4:`
`Figure 5:`) — the discriminator the caption_split style machinery already trusts; the in-text
forms (`Figure 4 reports…`, `Figure 1's pipeline`, cross-page `Figure 5. Since…`) fail block-start
anchoring and (for the first two) the separator.

### Premise corrections (prior diagnoses → current-run truth)

1. **Fig 4 "in-text-ref-only visibility" is WRONG on the current run** — the p16 caption is fully
   present in letters/words/blocks; the p15 in-text ref is a separate, mid-block occurrence. (The
   A1/A2 lesson re-confirmed: defect classes go stale across refreshes.)
2. **Fig 1 "caption never became a Lane-3 block" is imprecise** — it became FIVE blocks
   (per-word), none cue-bearing.
3. **2302 float identity pinned**: the miss is PDF **Figure 5** (v-e-sw, p11). The paper's
   "Figure 1" is a `\parpic` + `\captionof{figure}{}` with EMPTY caption text — outside the
   PRIMARY oracle (oracle figures=5 = Figs 2–6), so the pig not claiming it is correct, not a
   fourth miss.

### Indicated fix — classification per the predeclared acceptance frame

**Letters/words survive on 3/3 → bounded caption rescue; NOT IR-engine work.** Predeclared
decision rule outcome: **clause 1 fires — A3 first.**

The one dying guard is cue VISIBILITY (block-head-14-chars); geometry needs zero relaxation (gaps
3.1/2.6/0.6 em against the 4.5 em ceiling, overlaps and kinds all pass). Two bounded moves, both
inside `Add-FigureCaptions` candidate generation, both under the existing
style/geometry/separator/in-text-ref guards:

- **(a) per-LINE cue test** (closes the 2302 class): run the cue regex against each candidate
  block's line heads, not only the concatenated block head — line 816 passes at char 0.
  Superscript pollution is invisible to it.
- **(b) same-row cue stitch** (closes the 2210 class): when a digit-less cue-word block
  (`Figure`/`Fig`) has a same-row adjacent block completing `N:`/`N.` within ordinary word
  spacing (observed 3.6 pt ≈ 0.33 em), evaluate the stitched row as the caption candidate. The
  cue-then-separator signature gates it — the style idiom `Split-CaptionInteriorRegions` already
  learns per paper.

Estimated size: lane-side only (`pdfdig-figures.ps1`), no engine or IR change; both moves reuse
existing guard code paths. Acceptance as predeclared: the three target-number assertions
(2210 −2→0, 2302 −1→0), zero new caption claims (the cue census above shows the in-text refs stay
out), zero PRIMARY overs, both calibration corpora gated.
