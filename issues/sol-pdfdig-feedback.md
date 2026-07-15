## PTAL verdict

The live frontier plan is sound. I’d approve it with four amendments before execution.

### 1. Ship C′ exactly as planned

The sequence is right: knob-on targeted regen → inspect 1608 plus the complete false-positive census → flip default → refresh naturally.

For a clean closing record, preserve:

- Exact knob-on run stamps.
- The complete 11-row review manifest and crop verdicts.
- Before/after crop dimensions for 1608 p8/p9.
- Config flip plus frontier update.
- Correction of the stale 5.4/11.57 baseline comment in `banded-ablation.ps1`.

A full-corpus raster regen should not block default-on; the two-corpus offline gate already established the numerical result.

### 2. Make A3-0 a four-layer probe

The current binary question—“do the words exist?”—collapses several distinct failure locations. Probe each target through:

1. Caption glyphs in `letters.jsonl`.
2. Caption tokens in `words.jsonl`.
3. Corresponding line/block assembly in `blocks.jsonl`.
4. Typed node/cue visibility in `nodes.jsonl` and the figure attachment pass.

That distinguishes:

- extraction failure;
- word assembly failure;
- XYCut/block failure;
- block-text fragmentation;
- attachment failure.

Ground the probe by figure identity and PDF coordinates, not merely by nearby text. Acceptance should explicitly recover the three high-confidence missing floats, with target-number assertions and zero new caption claims/PRIMARY overs across both corpora.

If the letters or words survive, I agree that bounded caption rescue is preferable to DLA surgery—but it should reuse the existing style, geometry, separator, and in-text-reference guards.

### 3. D-0 needs a real alignment oracle

This is the largest defect in the written plan. The `2112` diagrams sidecar has 17 records, but its schema is only:

`n`, `kind`, `status`, `image`, `source`

It has no PDF page or bbox: [2112 diagrams sidecar](D:/aghado01/codex-scientiae/ingestion/compendia/ph-zigzag/2112.02352/.runs/20260706_075458/tex/2112.02352.diagrams.jsonl:1). Therefore it cannot directly label candidate glyph clusters.

Before calibrating arrow/grid features, create object-level truth by either:

- manually labeling the 17 rendered diagrams in PDF page coordinates—probably cheapest for one paper; or
- locating the oracle PNGs in PDF page rasters with scale-tolerant template matching.

D-0 also needs negative controls:

- multiline display equations inside 2112;
- several `oracle_inline=0` voroninski papers;
- arrow-heavy equations, which specifically challenge the arrow-glyph discriminator.

Score object-level precision/recall, not just whether the total improves from −10. Otherwise missing diagrams and false equation crops can cancel exactly as earlier PRIMARY counts did.

### 4. Predeclare the A3-versus-D decision rule

“Let measurements pick” is insufficient because A3 and D optimize different objectives. Measurements determine feasibility; they cannot decide how much a missing captioned float is worth relative to SECONDARY count reduction.

I would use:

- If A3 reveals surviving letters/words and a bounded rescue path, do **A3 first**.
- If A3 requires global DLA work, while D shows clean target/negative separation, do **D first**.
- If D lacks clean alignment or equation separation and A3 is engine-deep, take **F or E1** rather than forcing either implementation.

### E should be split

The proposed “clip-group-id + color-bucket + marked-content-id” increment bundles three signals with very different accessibility.

Start with **E1: path paint color**, because PdfPig exposes fill/stroke colors and the crop payoff is already diagnosed. But the opinion-free IR should emit canonical raw `fill_color` and `stroke_color`; derive page-background/color buckets downstream. A bucket alone would violate the substrate’s measurement-versus-opinion separation. Current path records stop at paint booleans: [pdfdig-ir.ps1](D:/aghado01/codex-scientiae/src/pdf-converter/pdfdig-ir.ps1:568).

Treat clip-group identity and marked-content-to-path association as separate feasibility probes. The existing `is_clipping` boolean does not imply that group identity is directly recoverable.

### F is actually two asymmetric gaps

The current publish lane already discovers and copies raw Docling images, but only surfaces images omitted from the finalized body: [publish.ps1](D:/aghado01/codex-scientiae/src/publish.ps1:187). Meanwhile pig finalize weaves from `{slug}-membrane/`, but publish only recognizes the raw `{slug}/` source form: [finalize.ps1](D:/aghado01/codex-scientiae/src/finalize.ps1:131), [publish.ps1](D:/aghado01/codex-scientiae/src/publish.ps1:163).

So F should be defined as:

- **F1:** Docling image placement/weave into the finalized body.
- **F2:** Publish source abstraction supporting both `{slug}/` and `{slug}-membrane/`, rewriting either to canonical `images/{slug}/`.

Add one docling-only and one pig-only dry-run/publish fixture. The destination contract itself is already correct.

## Recommended order

1. Close and default-enable C′.
2. Run refined A3-0 and aligned D-0.
3. Implement A3 if bounded; otherwise D only if its negative controls are convincing.
4. Use F as the low-risk second-half task.
5. Take E1 color opportunistically; defer E2/E3 until their signals prove reachable.
6. Run the mapper transport gate after its 0/10 pig-run gap is filled.

One housekeeping note: [opus-clustering-next-steps.md](D:/aghado01/codex-scientiae/issues/clustering/opus-clustering-next-steps.md:17) is historical and materially superseded. It deserves an explicit superseded banner so nobody accidentally resurrects its old provenance-first assumptions.

No repository changes made.
