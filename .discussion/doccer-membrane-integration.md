# doccer → codex-membrane: which patterns we pulled in

A record of what the membrane borrowed from **doccer**, what it deliberately did not, and why.
Companion to [`cursor-doccer-concepts-interation.md`](cursor-doccer-concepts-interation.md) (the prior
survey); this note is the implementer's cut — grounded in the code, narrowed to what shipped.

## The two systems

- **doccer** (spcx: `.discussion/issues/doccer/` + `src_dev/doccer/{README,SCHEMA,VALIDATION-MATRIX,UNIFIED-SWEEP,inventory}`)
  — an interval-algebra document-preprocessing *engine*, Phase 0 (schema + seed, no code yet). Three
  strictly-separated layers: **Collector** (pattern-library sweeps → columnar `SpanIndex`), **Interval
  Algebra** (pure geometry: containment, complement, density, lifts), **Orchestration** (declarative rule
  tables; all domain knowledge). Built for far more than document repair.
- **codex-membrane** — the functional PDF/Docling → corpus-markdown restoration pipeline + MCP. Body-blind
  membrane over a `.scratch/*.chunks.jsonl` standoff stream; deterministic preprocess → grade → dispatch →
  agent `propose_edit` → finalize.

They solve adjacent problems at different altitudes. **doccer is substrate — *why the geometry looks the
way it does*. The membrane is orchestration + agent surface — *the workflow that ships*.** The borrowing is
one-directional and conceptual: lift doccer's *calculus*, import none of its *engine*.

## What motivated this: a session that named the gaps

A no-struct-reingest run (Voroninski `1109.4499v1`, PhaseLift) surfaced three failures that turned out to be
doccer concepts we'd hand-built without the name. That's both the proof the frame fits and the map of what
was worth taking:

| Session symptom | doccer concept |
|---|---|
| The closure scanner reported "balanced, clean" on a file with **8 KaTeX parse errors** | a missing **cross-derivation** (Tier 2) — a check is only trustworthy when an independent derivation agrees |
| The two inline-math wrappers (`ConvertTo-InlineMath` vs `Wrap-InlineMathMd`) **diverge**, emitting an unbalanced span | a cross-derivation *failure*, concretely |
| No-struct "faithful but dirty" prose (`$x \in C n$`, `\| x , z_i \| 2`) the corruption detector can't see | the **math-density hotspot**, specifically `density ∧ ¬mask` |
| The alignment check we hardcoded into the scanner | a **Tier-3 impossibility** wanting to be declared data |

## What we pulled in (landed, validated)

**1 — Cross-derivation agreement → fidelity.** `Get-CorruptionType` ([fidelity.ps1](../src/fidelity.ps1))
now runs the same two structural impossibilities the assembled scanner does — `alignment_outside_env`
(an `&` alignment tab in a formula with no `\begin{...}`) and `prose_in_formula` (a formula chunk that reads
as natural language). Chunk-grading and the post-assembly scanner now *converge*: a formula that won't render
or is actually prose is caught at the chunk level and dispatched, not discovered after assembly. This is the
"lying scanner" closed at the source.

**2 — `density ∧ ¬mask` dirt signal → normalize + fidelity.** After wrapping, `Invoke-Normalize`
([normalize.ps1](../src/normalize.ps1)) masks the `$…$` spans and counts the math-register characters
surviving *outside* them — the complement-within-density *is* the un-wrapped math. The count rides along as
`math_dirt`; fidelity lifts `≥ 2` to `needs_review: unwrapped_math`. The no-struct dirt the corruption
detector was blind to now reaches the work-list. (Three doccer primitives — density, suppression mask,
complement — composed into exactly the signal the no-struct corpus needed. The "lift" from atoms to a dense
region is the membrane's reduction vocabulary in a span-algebra hat.)

**3 — Predicate consolidation → `latex.ps1`.** `Test-IsMath` and `Test-AlignmentOutsideEnv` now live in one
shared home ([latex.ps1](../src/latex.ps1)), consumed by normalize (the *fixer*, `Repair-MathAlignment`),
fidelity (the chunk checks), and md-cleanup (the assembled scanner). One source of truth, so the independent
derivations of "is this math / will it render" *can't* drift apart — the lightweight, in-place version of
doccer's "validation declared as data alongside the pattern."

## What we deliberately did NOT pull in

- **The substrate** — SoA columns, the 64 KB classification LUT, the O(N) unified sweep, `DocPlane`, hex
  addressing, BPE export. That is GB-scale C# engineering; our inputs are KB–MB papers and
  `.scratch/*.chunks.jsonl` is already a coarse span index. The *calculus* ports (complement, density, lift,
  level-dispatch, the three validation tiers); importing the *data structures* is a category error.
- **A forced "masking unification."** It looked like one duplicated operation across three functions; it is
  actually three distinct ones — *protect-and-restore* (md-cleanup transforms, `Optimize-MathContent`,
  via a sentinel store) vs *mask-to-spaces* (the closure scanner, to isolate the inline scan while
  preserving offsets). Collapsing them would couple a transform-protection mechanism to a scan-isolation
  one. The only genuine shared seam is the protect-restore *sentinel* pattern — and that carries the
  `$marker`-collision bug history, so it was left rather than refactored for marginal DRY.

## Parked — live, not closed

- **Byte-exact source coordinates / offset map** (doccer's immutable-master + `OffsetMap`). Initially
  under-rated here; corrected — byte-exact coordinates would let `propose_edit` anchor precisely against the
  *source* markdown, not just the finalized output. A real workflow gain worth designing in, not a non-need.
- **Checks-as-a-declared-data-table** (doccer's validation-matrix-as-data, Tiers 2–3). We did the predicate
  consolidation (the 80/20); the full table-driven runner + a document-level `agreement_score` diagnostic is
  the next increment *if it earns its keep*. The current per-chunk binary flag already folds into the
  dispatch work-list.
- **Lower-ranked for now:** entropy / divergence as boundary evidence (`opus-divergence-interface.md`) —
  secondary to core repair; the full `DocPlane` SoA sweep.

## Bottom line

The integration is doccer's **Tier-2/Tier-3 validation calculus + the density signal lifted into the
membrane's fidelity/dispatch layer — and nothing below it.** doccer remains the substrate to keep mining;
the membrane gives back what doccer's Phase 0 doesn't yet specify — agent-orchestration discipline, the
repair playbook keyed by `corruption_type`, and the ledger/audit as operational memory.

---
*Seed: the doccer threads + `src_dev/doccer/` design anchor (spcx), and the prior survey in
`cursor-doccer-concepts-interation.md`. Landed changes staged across `src/{latex,normalize,fidelity,md-cleanup,serving}.ps1`.*
