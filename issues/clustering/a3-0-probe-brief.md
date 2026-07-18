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

*(appended by the executing chip)*
