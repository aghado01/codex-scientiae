# The benchmark workflow — objective grading of docling repair against a LaTeX oracle

**Status:** design converged, not implemented
**Origin:** producing a LaTeX-derived ground truth for 1611.03935 (2026-06-30); the measurement discussion that followed
**Related:** `src/latex-ingest.ps1` (the oracle converter), `gate-blind-spots-valid-but-wrong.md` (the detectors), STANDARDS.md §1

---

## Goal

Measure, objectively, how well the **docling-repair agent** reconstructs a math PDF as faithful markdown — by
comparing its output to an **algorithmic oracle**: the same paper converted directly from its arXiv LaTeX
source (`src/latex-ingest.ps1`), which is near-lossless because LaTeX is structured. The oracle is the answer
key; the agent is graded on how close it lands. The composite score is an **agent-evaluation benchmark**.

## Two workflows (additive — the production lane is untouched)

- **Production workflow** (existing): docling repair → finalize → publish, with the editorializations the MCP
  was built for (trimming, `## Contents`, references sidecar). Unchanged.
- **Benchmark workflow** (NEW, parallel lane): the agent does *essentially the same repair work*, but guided to
  reproduce the **oracle's form** — render-clean math, inline references, no TOC — so the only differences left
  are conversion fidelity. A new path the MCP can be run on; reuses the production machinery, adds net-new only
  where the lanes must diverge.

## The objectivity firewall (the load-bearing invariant)

The agent runs LaTeX processing **as tools**, to generate a per-document **target rubric** at runtime. It must
**never inspect or use the oracle content** in its repair. So:

- `latex-convert` produces (a) the **oracle markdown** — the hidden answer key, never entered into the agent's
  repair context — and (b) inputs for the rubric.
- `generate-target-schema` emits a **thin structural rubric** (render-clean math; references inline; TOC off;
  `\tag{N}` numbering; section-numbering style). It is *structure, not answers* — the agent reconstructs every
  token from the PDF. Keep the rubric minimal: document-level layout rules + universal benchmark rules, **not**
  per-equation templates, or it starts leaking content and the benchmark loses validity.

## Agent flow (benchmark mode)

1. **Acquire** — PDF (codex-arxiv) + LaTeX source (codex-scholar). *(reused)*
2. **`latex-convert`** → oracle markdown (firewalled) + rubric inputs. *(net-new MCP wiring over existing engine)*
3. **`generate-target-schema`** → the rubric. *(net-new, thin)*
4. **`preprocess`** the docling IR → chunk stream. *(reused)*
5. **Repair loop** — dispatch / get_slice / propose_edit / apply, **guided by the rubric** (flatten math to
   render-clean, target the oracle's form), never reading the oracle. *(reused machinery, benchmark guidance)*
6. **`benchmark-finalize`** → docling candidate in oracle-matched form. *(reused finalize, new schema mode)*
7. **`measure`** → compare candidate vs oracle → scores. *(net-new, vendored measures)*

## Reuse vs net-new

**Reused as-is:** acquisition (arxiv/scholar), `latex-ingest.ps1` (oracle engine), `preprocess`, the
`fidelity` detectors (gate + soft + seam), `serving.ps1` (dispatch/slice/work-order/propose_edit/apply/repair
loop), `playbook.ps1`, most of `finalize.ps1`.

**Net-new (only where the lanes diverge):**
- **N1 · Math render-normalization pass** — flatten nested `$…$` inside `\text{}` to `\text{…} math \text{…}`;
  guarantee render-clean primitives. SHARED by the oracle converter *and* docling finalize (both must render
  clean). Small; lives beside the math predicates in `latex.ps1`.
- **N2 · KaTeX render validator — LANDED 2026-06-30.** `tools/render-check/` (pinned `katex`) + `src/render-check.ps1`
  (`Test-MathRenders`), exposed as the **`render_check`** membrane MCP tool (paper/path-addressed). Parses each
  math span under KaTeX → renders / red-error; a gate both lanes pass AND a benchmark dimension ("render success
  rate"). Tooling question resolved: Node `katex` (both Node + dotnet are in the portable env).
- **N2b · markdown structure lint — LANDED 2026-06-30.** `tools/md-lint/` (pinned `markdownlint`) +
  `src/md-lint.ps1` (`Test-MarkdownLint`), exposed as the **`markdown_lint`** membrane MCP tool. The non-math
  half of the standard (heading hierarchy §5, spacing §4); config disables line-length (§4 removes hard wraps).
  It immediately caught + fixed an MD022 (heading-not-followed-by-blank) bug in latex-ingest's section transform.
  Both gates require a **server reboot** to appear in `tools/list`.
- **N3 · `latex_convert` tool — LANDED 2026-06-30.** Registered on **codex-membrane** (not codex-arxiv, which
  explicitly disclaims conversion: "this server ACQUIRES; the membrane INGESTS"). `mcp-server.ps1` dot-sources
  `latex-ingest.ps1`, adds the `latex_convert {id}` tool + dispatch (resolves `_inbox/<id>/*.tar.gz`, runs
  `Invoke-ArxivLatexToMarkdown`, writes `_inbox/<id>/<id>.latex.md`). No name collisions with the membrane. NB:
  the earlier symptom (another session's agent hunting for pandoc) was this tool being unregistered — the oracle
  existed only as a function. Requires a **server reboot** to appear in `tools/list`.
- **N4 · `generate-target-schema` tool** — the thin rubric (above).
- **N5 · `benchmark-finalize`** — schema-parameterized serializer mode: render-clean, inline refs, no TOC.
- **N6 · `measure` tool** — vendored ThermoMapper `Hashish` + `Maths.Information` DLLs; the multi-measure panel
  (JS/KL-directional, Jaccard/MinHash, Levenshtein, CTPH/TLSH/SimHash, NCD, cosine/TF-IDF) at whole-doc AND
  aligned-unit granularity; localization (omission vs hallucination via directional KL + shingle diff);
  layered composite. See the measurement section below.
- **N7 · Benchmark guidance + STANDARDS** — a benchmark variant of the injected workflow prompts (target the
  rubric, flatten math, no editorializations) + STANDARDS.md render rules (below).
- **N8 · Refactor finalize → publish** — move the editorializations (sidecar, Contents, images path) out of
  `finalize` into `publish`, so production keeps them and `benchmark-finalize` simply omits them. The
  production deliverable is unchanged end-to-end; the split just relocates *where* the layout is applied.

## The math render standard (firm version of STANDARDS §1)

Target renderer bar: **KaTeX-strict** (⇒ renders on GitHub's MathJax; portable to VS Code/Obsidian). Note for
later: a KaTeX ∩ MathJax intersection (or a configurable bar) if we hit a divergence. Rules — embedded math
must **parse clean under KaTeX**:
1. **Zero undefined control sequences** — all `\newcommand` macros expanded to primitives (the latex-ingest
   expander already does this; it is *required for rendering*, not cosmetic — un-expanded `\eps`, `\norm{}`,
   `\PP`, `\A`, `\inner{}` are all KaTeX red boxes, verified). NB: a few single-letter customs coincide with
   KaTeX built-ins (`\R`, `\reals` happen to render as ℝ) — but most don't, and a renderer-coincidence isn't a
   guarantee (MathJax's macro set differs), so expansion is the correct move regardless.
2. **Portable command set only** — `\mathbb \mathcal \mathbf \frac \sum \langle \intercal \substack
   \operatorname aligned` yes; `\intertext \label \nonumber \color \vspace \def`, raw `align`/`eqnarray` with
   bare `&` no.
3. **Nested `$` in `\text{}`** — VERIFIED render-correct: KaTeX renders `\text{ where $z$ is}` with `z` in
   math italic (probe 2026-06-30), so it is NOT a render error. Optional to flatten to `\text{…} math \text{…}`
   for math-span *extraction* robustness / portability to non-KaTeX renderers, but not required for KaTeX/GitHub.
4. Equation numbers via `\tag{N}`. UTF-8 no BOM.

"Renders clean under KaTeX" unifies several existing membrane detectors under one objective — `alignment_outside_env`
(bare `&` → KaTeX error), `unbalanced_delimiters` (parse failure), `glyph_name_leak` (undefined token) are all
special cases of "does KaTeX accept it." **Oracle verified (2026-06-30):** all 126 math spans of
`1611.03935.latex.md` pass KaTeX at the **strict** bar (⇒ render on GitHub MathJax) — including the nested-`$`
spots, which render correctly. The earlier "known defect" note here was falsified by the empirical check; N1's
flatten step is therefore *optional* (extraction robustness), not a render fix. Validator prototype:
`scratchpad/katex-check.js` (npm `katex`) — to be formalized as N2 in a codex `tools/render-check/`.

## Measurement (the N6 design, to explore before composing)

Run the family first as a **panel** — observe how each measure exposes different defects — then weight a
composite. Whole-doc (holistic grade) AND aligned-unit (localized). Per unit: align (heading/number/LSH) →
score per modality (prose JSD, math Levenshtein, structure Jaccard, refs) → classify divergence (directional
KL: omission vs hallucination) → localize (shingle diff). Output a fidelity *vector* + a weighted headline +
a ranked hotspot list. Vendor the compiled `Hashish`/`Maths.Information` assemblies into a codex `lib/`.

## Open decisions

- **KaTeX runner** for N2 — Node KaTeX (dependency) vs a .NET/PS port vs a curated unsupported-command denylist?
- **Rubric thinness** — exactly what N4 encodes; the minimal set that gives parity without leaking content.
- **Composite weighting** — derived empirically from the N6 panel, not guessed.
- **Render bar** — KaTeX-strict now; revisit intersection/configurable later (noted, deferred).
