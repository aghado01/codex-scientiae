# latex-ingest near-term workflow

Spec for what latex-ingest becomes in near-term development: a trustworthy, end-to-end
LaTeX→markdown pipeline with bundled delivery. Not the next-gen system — the stop-gap that
establishes the machinery and methodology the next-gen system will formalize.

## Goal and non-goals

**Goal.** One command takes an arXiv source tarball to a bundled, gated markdown deliverable,
through stages I can name, with every transformation either principled (store-driven) or
confessed (residual ledger). The lane must stand alone: latex→md as the primary objective,
not a side effect of oracle duty for the pdf converter.

**Non-goals (near-term).**

- Generality over all LaTeX. The pipeline must be _correct on the pinned set_ and
  _adaptable by stores/patches_ — not complete. Coverage grows paper-by-paper through the
  adaptation loop, never by speculative branches.
- Patterns that emerge from patches should be adapted into code if a reliable solution to a problem becomes evident
- MarkPig/MathDig. The IR is the stop-gap serialization of the future manuscript DAG;
  every judgment made here (furniture vs notation, composite closure, reading order)
  is a conformance fixture for those parsers, not blocked on them.
- Membrane repair. This lane converts from source truth; it should need none of the
  membrane's abductive repair machinery.

**Trust means:** re-running on the same (source, patches, stores, code, TeX engine version)
is byte-identical — the run manifest records the engine/format version alongside the rest;
gates fail loud, never silently degrade; whatever the pipeline could not handle is in the
residual report, not invisibly dropped.

## Disentanglement rule

latex-ingest may depend on: `src/shared/` (masks), `src/math-register/`,
`src/md-postprocess/`, `src/audits/`. It must not depend on `src/codex-membrane/`.
One external dependency is admissible: the TeX engine via `tex-harness.ps1` as the
evaluation-tier adapter for macro expansion (stage 3) — scoped as an oracle for bounded
questions the static rungs cannot decide, never as the conversion engine. The same
instrument posture as the Lean/R harnesses elsewhere: written once, invoked as needed.
Math machinery currently duplicated between `latex.ps1` and membrane `normalize.ps1`
resolves by promotion into the shared/math-register layer, not by cross-lane import.
The membrane remains a _consumer_ of this lane's output (oracle role), never a dependency.

## Pipeline

Each stage names its primitives (existing unless marked NEW), stores consumed, and gate.

### 1. Unpack & resolve

`Expand-ArxivSourceTarball` → `Find-LatexMain` → `Resolve-LatexInputs` (flatten
`\input`/`\include` to one source) → `Copy-LatexFigures`. Inventory class/packages
into the run manifest.

- Output: flattened `.tex`, figure assets, source manifest.
- Gate: main-file identification unambiguous; unresolved inputs fail loud.

### 2. Source patches

`Read-LatexPatchFile` → `Invoke-LatexSourcePatches` with `Assert-PatchHits`.
Per-paper `{slug}-latex.patch.jsonl` curated errata, re-applied every convert,
fails loud when stale. Patches apply to the _flattened_ source so anchors are stable.

### 3. Macro harvest & expansion

Harvest author preamble macros; expand **to exhaustion** — iterate until fixpoint, so no
author macro survives into any later stage (`Get-TexExpandableMask` substrate; expansion
pass NEW in part). Expansion yields flat, correctly grouped and delimited KaTeX-valid
blocks; reduction into the target math-channel standard happens downstream (stage 6),
operating only on post-expansion material.

Expansion is two-rung: the static (mask/interval) expander handles what it can decide
from the surface; spans it cannot converge (recursive definitions, catcode games,
context-dependent expansion) escalate to a **proper LaTeX parser/expander** — the
evaluation-tier adapter. This is an admissible external dependency: TeX expansion is
the definitional parse-requires-evaluation case, and static analysis alone cannot close it.

- Scope of the dependency: the parser is an _expansion oracle_ answering "what does this
  span expand to" — invoked at the weakest sufficient stage (expand, not compile), never
  handed ownership of segmentation, IR, lexicon, or emission.
- Guard: what neither rung can expand is ledgered residual and carried unexpanded —
  never looped on, never guessed at.
- Engine: **TeX itself, harnessed properly** (NEW: `tex-harness.ps1`) — the definitional
  evaluator, written once and wired in, rather than hopping between third-party parsers
  by convenience. Contract: expand-only invocation, per-span or batched to amortize
  startup, timeboxed, side-effect-free (no shell-escape); harness failure degrades to
  the residual ledger like every other rung.
- Binary home: `packages/tectonic/` — the pinned-external tier (`packages/{package}/`,
  self-contained: binary gitignored, `pin.json` + fetch script + license committed).
  Resolution ladder: `$env:TECTONIC_EXE` → PATH → `packages/tectonic/`; whichever rung
  resolves, observed `--version` is checked against the pin and drift fails loud.
  `tex-render.ps1` consumes the harness and loses its private `Get-TectonicPath`;
  in-process assemblies (PdfPig) join the same tier under `packages/{package}/lib/`.

### 4. Segmentation (masking pass)

Total interval cover of the flattened source via the mask substrate: `Get-TexCommentMask`,
`Get-VerbatimCodeMask`, `Get-MathStructureMask`, `Get-InlineMathMask`,
`Get-TextInteriorMask`, `Get-TexProseMask`, `Get-EnvironmentSpans` over `src/shared/masks.ps1`.
Segmentation is total by construction: what no mask claims is residual, ledgered, and
carried forward — never dropped, never guessed at.

### 5. IR assembly

Compile envelope nodes into the jsonl proto-manuscript IR, in reading order: title,
frontmatter, abstract, section titles, section bodies, figure composites, tables,
references (`Get-LatexReferences`, `ConvertFrom-BiblatexBbl`), supplementary sections.

- Figure composites are **closed**: figure body + caption + label assembled as one node
  with parts, sub-figures nested within the parent (same schema, recursive).
- Node order on the spine is the reading-order contract; downstream consumers may not reorder.
- Stop-gap tag: this IR is the serialization of an envelope instance; MarkPig later
  parses what this stage assembles.

### 6. Math channel: evidence → surjection → strip

Strictly ordered — evidence is consumed before anything is discarded:

1. **Evidence pass**: `New-LatexEvidenceLedger` / `Add-LatexEvidence` — `\operatorname`,
   spacing cues, upright-identifier cues, author-dialect signals (store: `evidence.json`).
2. **Lowering**: `Invoke-LatexMathStoreLowering` — evidence resolves each span toward
   the stable form.
3. **Lexicon surjection**: `ConvertTo-RegisterMath` — alias coalescing (`aliases.json`),
   glyph→control-sequence (`unicode-glyphs.json`), `\operatorname`→`\mathrm`.
4. **Furniture strip**: pure typesetting removed (`furniture.json`). Criterion: if removal
   could change the mathematical parse, it is encoded notation and stays; if only spacing,
   size, or decoration changes, it is furniture and goes.

Output: math channel lexically invariant against the preferred KaTeX-stable lexicon.

### 7. Figure lane

Encode-first doctrine (already litigated): structures expressible as semantic KaTeX
(commutative-style diagrams, arrays) are encoded; empirical/graphical figures
(data plots, photographs) are rasterized and **flagged** as last resort. Both register
through the one figure register both lanes share.

### 8. Emission

Serialize the IR through the shared emission walk (md-hygiene primitive). `$…$`/`$$…$$`
delimiters, house heading and anchor conventions, `Set-MdContentsBlock` contents,
`New-MdTocSidecar` byte-spanned toc for the library plane.

### 9. Output patches

`Invoke-LatexOutputPatches` — curated errata against the emitted markdown, same jsonl
discipline, same fail-loud staleness as stage 2. Output patches are for defects the
engine cannot yet express; each one is a standing TODO for a store or engine fix.

### 10. Gates

| Gate                                                                                                                          | Substrate                                    | Severity                                         |
| ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- | ------------------------------------------------ |
| render_check (KaTeX floor: every math span parses)                                                                            | render harness                               | blocking                                         |
| encoding invariants (UTF-8 no BOM, SMP round-trip, no replacement chars)                                                      | encoding tests                               | blocking                                         |
| balance (delimiters, environments)                                                                                            | `Get-LatexBalance`, `Get-EnvironmentBalance` | blocking                                         |
| defect-span lint (glyph leaks, dangling operators, ligatures, degenerate structures, prose-in-formula, hallucinated subexprs) | `latex.ps1` span detectors                   | [REVIEW] split blocking vs advisory per detector |
| patch staleness                                                                                                               | `Assert-PatchHits`                           | blocking                                         |
| residual report (unmasked spans, unexpanded macros, unencoded figures)                                                        | ledger                                       | advisory — reported, never silently empty        |

### 11. Bundle & deliver

`Copy-MdDeliverable` — standalone bundle (markdown + woven figure assets + toc sidecar),
destination-side verification, lane naming conventions ({slug}-latex infix; promotion
writes bare {slug}.md at destination).

## Adaptation methodology

The generality story. When a new paper fails, triage in this order:

1. **Patch case** — document-local defect (author typo, one-off construct):
   `{slug}-latex.patch.jsonl`, source-side preferred over output-side.
2. **Store gap** — dialect/alias/furniture/glyph not yet known: extend the store.
   This is the expected common case and the intended growth channel.
3. **Engine gap** — a mechanism genuinely missing: only then code.

Every adjudication becomes a committed fixture under `tests/fixtures/` — the challenge
library accretes from real failures, and the same corpus later defines MathDig conformance.
Residual-report mass per paper is the health signal: falling residuals across the pinned
set is what "adapting to a broader test set" measures.

## Pinned set

Start with the calibration papers already in canon (voroninski corpus; ph-zigzag where
LaTeX source exists). End-to-end trust on these before breadth. [REVIEW] exact list —
gauntlet full runs are paused and fresh test materials are incoming.
