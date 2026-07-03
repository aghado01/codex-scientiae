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

## Promotion discipline — surface on evidence, HUMAN decides (guard against n=1 overfit)

**The machine never promotes. It gathers evidence and SURFACES candidates; a human examines and
decides.** Human-in-the-loop is the final, non-negotiable gate — no reasoning-tier repair becomes a
deterministic rule (store entry, assembler change, threshold) without human sign-off. This is the
real overfit guard: not a machine-chosen recurrence threshold (which is itself an n=1 guess about
what "enough evidence" means), but a person judging whether a pattern generalizes.

The **surfacing bar is low, deliberately.** Evidence raising a candidate — even a single repair that
*looks* like it might generalize — is reason enough to surface it for examination/discussion.
Surfacing is cheap and good; suppressing a real generalization is the costlier error. A lone repair
does not auto-promote, but it absolutely earns a place in the discussion queue.

The evidence dimensions below are **decision-support the machine attaches to a surfaced candidate**,
NOT autonomous filters that block surfacing. They sharpen the human's judgment; they don't replace it:

- **Recurrence** — how many distinct examples/specimens show this pattern so far (1 is fine to
  surface; the count informs confidence). Accumulated from the math-repair audit + specimen registry.
- **Principled expressibility (the sharpest signal)** — can the fix be stated in PDF-intrinsic terms
  (geometry / typography / font register / symbol map), or only as a content regex matching the
  example string? A rule that can't be stated without naming the example IS the example — the machine
  flags this so the human sees the overfit risk plainly. (This is `no-magic-string` as a *tell*, not
  a gate.)
- **Trial reproduce/regress** — when a candidate deterministic rule is drafted, replay it over the
  accepted-repair corpus and report: does it reproduce its class's repairs, and does it regress any
  prior specimen (monotone-corpus-green)? Numbers for the human, run on request — not an autonomous
  verdict. The audit log is the experiment set, offered to the person, never a self-approving oracle.
- **Held-out** — of the recurrence examples, which did the draft rule predict that it was NOT fit to?
  A confirming-vs-motivating split, surfaced so the human can see whether it's circular.

A promoted rule (once the human approves) carries provenance — which examples motivated it, the trial
numbers, who signed off — and stays a **standing conjecture**: a later falsifying specimen re-surfaces
it for the human to narrow or roll back. Givens are conjectures, all the way up.

**Same caution turned inward:** the assembler's own knobs (`size_ratio`, `baseline_tol_frac`) were
tuned on 2508.11646 — themselves an n=1 calibration that no human vetted across specimens. They owe
the identical treatment: surface them as standing conjectures, validate across the registry, degrade
unknown cues to flags (the brief's "beware calibration-set overfit").

### The enabling mechanism (build WHEN repairs start flowing, not before)

Each gate-accepted math repair is captured as a **candidate fixture**:
`{ geometry-evidence, accepted-LaTeX, class, specimen }` (the membrane's apply already writes a
before/after audit; the math-repair path additionally stashes the `math_evidence` + accepted content
so the geometry → correct-LaTeX pair is replayable). When a repair looks generalizable, it is
**surfaced for human examination** — the natural channels already exist: a candidate entry under
`issues/` for discussion, or a `spawn_task` chip flagging it (the repo's "chip off a follow-up,
consult the user" pattern). A `vet-promotion` replay harness then reports reproduce/regress numbers
*to the human on request* — decision-support, not an autopilot. NOT built yet: there are zero
accumulated repairs (the loop just landed), so building the harness now would itself be speculative.
The hook to wire first, when the loop goes live, is the fixture capture — everything downstream is a
replay over data that doesn't exist yet.
