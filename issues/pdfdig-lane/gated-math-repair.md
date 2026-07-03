# Gated math repair — doling the converter's hard math to the reasoning tier

**Status:** LANDED end-to-end (2026-07-03). The pig lane isolates the display-math it can't
deterministically assemble and hands it to the membrane's model-in-the-loop, gated by render_check.
A `get_slice` on a flagged formula returns the chunk + work-order recipes + a `math_evidence`
transcript in ~1.7s (page-prefiltered geometry load).

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

## The membrane wiring (LANDED)

The pig side emits flagged formula chunks (`flags`, `page`, `bbox`, best-effort `content`) + the
geometry beside the PDF. Four additions complete the loop, all reusing the existing dispatch →
propose → gate → apply machinery:

1. **fidelity issue `needs_2d_assembly`** (`fidelity.ps1` `Get-ChunkIssues`) — a flag-based
   needs-review kind (the CONTENT of a flattened fraction — `a/b` — is valid LaTeX and renders, so
   the content signatures are blind; only the converter's self-report reveals it). Folded in exactly
   like `heading_level_unknown`/`unwrapped_math`. The `unbalanced_delimiters` cases are ALSO caught
   independently by the existing hard content signature (`Get-LatexBalance`), so a fragmented span
   surfaces both issues — one composed work-order.
2. **get_slice enrichment** (`serving.ps1` `Get-Slice`) — when the anchor is a formula with a
   work-order and pig geometry is staged, attach `Get-ChunkMathEvidence` as a `math_evidence` field.
   Page-prefiltered (`"page":N,` string-match before parse) so the geometry load is ~1.7s, not the
   20s full-file parse. Docling-lane / geometry-absent chunks return null and are skipped; wrapped in
   try/catch so evidence never breaks a slice.
3. **playbook recipe** (`playbook.ps1`) — the `needs_2d_assembly` recipe: read `math_evidence`,
   reconstruct KaTeX from the glyph tier table + spatial layout (`\frac` from `─`, nested scripts by
   tier, paired delimiters), `split_chunk` any trailing prose, invent nothing. Registered in the
   playbook-coverage invariant (19 emittable types).
4. **gate** — `render_check` (already the apply-time math gate): a proposal that doesn't render under
   KaTeX is rejected, keeping the model *behind* the gate (brief §"gated model proposals").

Verified: `get_slice` on 2508.11646 chunk 68 (`needs_2d_assembly`) returns work-order recipes
[`unbalanced_delimiters`, `needs_2d_assembly`] + the full `math_evidence` transcript in 1.7s.
Full suite 495+ green.

## Discipline

- **Distillation, not delegation** — the model reasons over pig-intrinsic geometry; it is never
  handed a sidecar answer across the modality wall.
- **Honest residue** — flags are the converter's self-report, not detected corruption; the transcript
  shows the model exactly what geometry was ambiguous. Nothing is silently guessed.
- **The C# AST tier still owns true 2-D** — this loop is the *interim* path to correct display math
  now (reasoning over evidence), while the deterministic 2-D assembler matures.

## Promotion discipline — a repair is a data point, not a rule (guard against n=1 overfit)

A reasoning-model fix to ONE example is evidence of exactly one case. It may generalize; it may be a
one-off the model pattern-matched. Promoting it into the deterministic tier (a store entry, an
assembler rule, a threshold) on that single observation is fitting a rule to n=1 — the failure mode
this discipline exists to prevent. Promotion is a **gated inference**, not an automatic reflex.
A repair is RECORDED (raw material); it is PROMOTED only when it clears every gate below.

1. **Recurrence, not repetition** — the same *pattern* (expressed geometrically), independently
   observed across ≥K distinct examples/specimens. One example is a hypothesis; a pattern is a
   candidate. The math-repair audit + specimen registry accumulate the evidence; a lone repair never
   trips promotion.
2. **Principled expressibility (no-magic-string, applied to promotion)** — the rule must be statable
   in PDF-intrinsic terms (geometry / typography / font register / symbol map), NOT a content regex
   that matches the motivating string. If the only way to reproduce the fix is to pattern-match the
   specific text, it has NOT generalized — it stays in the reasoning tier by construction. This is the
   sharpest overfit filter: a rule that can't be stated without naming the example is the example.
3. **Corpus verification = the falsification gate** — the accepted repairs are not just "the spec,"
   they are the **experiment set a deterministic hypothesis must survive**. A candidate rule, run over
   the accumulated repair corpus, must (a) REPRODUCE the gate-accepted repairs of its claimed class
   (it actually does what the model did) AND (b) REGRESS NOTHING — every prior specimen and every
   other accepted repair stays green (monotone-corpus-green). A rule that breaks any prior case is
   overfit or wrong → rejected. The audit-log-as-spec clause means exactly this: the log is the
   regression corpus, not an answer key to copy.
4. **Held-out honesty** — a rule derived from examples A…B and tested only on A…B has proven nothing
   (circular). It must correctly predict *confirming* examples C…D it was NOT fit to. Split the
   recurrence set into motivating vs confirming; a rule that only passes what it was tuned on is not
   promoted.
5. **Provenance + reversibility** — a promoted rule records which examples motivated and which
   confirmed it. A later falsifying specimen NARROWS its domain or ROLLS IT BACK — promotion is a
   standing conjecture, not enshrinement (givens are conjectures, all the way up).

**Same caution turned inward:** the assembler's own knobs (`size_ratio`, `baseline_tol_frac`) were
tuned on 2508.11646 — themselves an n=1 calibration. They inherit the identical obligation: validate
across the specimen registry before trusting, degrade unknown cues to flags, and treat every constant
as a conjecture awaiting its falsifying specimen (the brief's "beware calibration-set overfit").

### The enabling mechanism (build WHEN repairs start flowing, not before)

To make gate 3 executable, each gate-accepted math repair is captured as a **promotion-regression
fixture**: `{ geometry-evidence, accepted-LaTeX, class, specimen }`. The membrane's apply already
writes a before/after audit; the math-repair path additionally stashes the `math_evidence` + accepted
content so the (geometry → correct-LaTeX) pair is preserved in a replayable form. A `vet-promotion`
harness then replays a candidate deterministic change against that fixture corpus and reports
reproduce/regress counts — promotion is a green run, nothing else. NOT built yet: there are zero
accumulated repairs (the loop just landed), so building the harness now would itself be speculative.
The hook to wire first, when the loop goes live, is the fixture capture — everything downstream is a
replay over data that doesn't exist yet.
