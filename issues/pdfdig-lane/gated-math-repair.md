# Gated math repair — doling the converter's hard math to the reasoning tier

**Status:** modality bridge LANDED, membrane wiring DESIGNED (2026-07-03). How the pig lane isolates
the display-math it can't deterministically assemble and hands it to the membrane's model-in-the-loop.

## The insight

The converter and a reasoning model look at the **same geometric evidence**. The deterministic
assembler (`math-assembler.ps1`) fails to *linearize* a tricky equation (nested scripts it can do;
fractions, matrices, and delimiter-fragmented spans it flags). A reasoning model can *reason* it out —
but it is language-modality (the brief's "deaf son": reasons in LaTeX/symbols, cannot see a glyph).
The missing link is a **deterministic projection of the glyph geometry into a text transcript the
model can read** — the same evidence the converter had, made legible. This is the alignment channel
across the modality wall: not delegation (the model isn't handed a sidecar answer), but the model
reasoning over the identical geometry, which the converter proved insufficient to assemble alone.

## What's built (the bridge) — `src/pdf-converter/math-evidence.ps1`

- **`Get-MathEvidence`** — from a formula's glyphs (+ nearby rule-bars) produces a transcript:
  1. best-effort LaTeX (what the assembler produced) + why it's flagged
  2. a glyph table: each glyph's `text · x · baseline · size · tier` (tier = script depth by size)
  3. a **spatial ASCII sketch** — glyphs placed on a 2-D grid by position, `─` for drawn rule bars.
     A fraction shows numerator / ─── / denominator; a norm shows its paired bars — structure the
     1-D assembler couldn't express, and delimiter partners the line-based split fractured.
- **`Get-ChunkMathEvidence`** — THE MEMBRANE SEAM: given a flagged formula chunk (page + bbox) and the
  paper dir, recovers the glyphs from `{slug}.letters.jsonl` in that region (+ hrules from
  `{slug}.paths.jsonl`) and projects the transcript. Returns `$null` when pig geometry is absent
  (docling-lane chunk) — caller degrades to content-only, never fails.
- **isolation signal wired**: `collapse.ps1` now carries the converter's `flags[]` onto the chunk, so
  `unbalanced_delimiters` / `needs_2d_assembly` reach the membrane as dispatchable work-units.

Proven end-to-end on 2508.11646 chunk 655: the assembler fragmented
`‖t_{u_1} − (t_{v_k} + τ_{v_k u_1})‖ < δ` into three unbalanced lines; the full-region spatial
evidence shows the complete pairable structure (norm bars matched, parens matched) plus trailing
prose the chunk over-captured — everything the model needs to reconstruct it and split the prose.

## The membrane wiring (the remaining plumbing)

The pig side now emits: flagged formula chunks (`flags`, `page`, `bbox`, best-effort `content`) +
the geometry beside the PDF. Four small membrane additions complete the loop, all reusing the
existing dispatch → propose → gate → apply machinery:

1. **fidelity issue `math_assembly`** (`fidelity.ps1`) — fires on a formula chunk when
   `Measure-DelimiterBalance(content) ≠ 0` (lane-agnostic re-derivation) OR the chunk carries a pig
   `unbalanced_delimiters`/`needs_2d_assembly` flag. Severity: `needs_repair`. Reuses the multi-issue
   inventory so it flows into dispatch like every other class.
2. **get_slice enrichment** — when the sliced chunk is a `math_assembly` unit and pig geometry is
   staged, call `Get-ChunkMathEvidence` and include the transcript in the slice payload (a new
   `math_evidence` field). The agent reads the geometry, not just the broken LaTeX.
3. **playbook recipe** (`playbook.ps1`) — the `math_assembly` recipe: "read `math_evidence`;
   reconstruct the display equation as KaTeX-valid LaTeX honoring the tier structure (nested scripts)
   and the spatial layout (fractions from `─`, paired delimiters); split any trailing prose into a
   separate chunk via `split_chunk`. Do NOT invent symbols the geometry doesn't show."
4. **gate** — `render_check` (already the math gate): a proposal that doesn't render under KaTeX is
   rejected. Balance is a cheap pre-check. This keeps the model *behind* the gate (brief §"gated model
   proposals"): models allowed on the residue, never in front of the deterministic extraction.

## Discipline (from the brief)

- **Distillation, not delegation** — the model reasons over pig-intrinsic geometry; when it exposes a
  *systematic* class the assembler should have handled (e.g. a recurring fraction pattern), the fix
  lands in `math-assembler.ps1` / a store, not as a per-document model patch. The evidence corpus of
  what the model repaired = the spec for growing the deterministic tier (the audit-log-as-spec clause).
- **Honest residue** — flags are the converter's self-report, not detected corruption; the transcript
  shows the model exactly what geometry was ambiguous. Nothing is silently guessed.
- **The C# AST tier still owns true 2-D** — this loop is the *interim* path to correct display math
  now (reasoning over evidence), while the deterministic 2-D assembler matures. Cases the model
  repairs teach both tiers.
