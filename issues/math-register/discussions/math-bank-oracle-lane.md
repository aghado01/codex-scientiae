# LaTeX source oracle — an optional lane for math repair AND structure disambiguation

**Status:** DESIGN (2026-07-01) — grounded in a dissection of `src/latex-ingest.ps1`, `src/latex.ps1`,
`src/render-check.ps1`, `src/md-lint.ps1`, `src/playbook.ps1`; nothing implemented yet.
**Scope:** two consumers of one extraction — the **math bank** (repair oracle for equations) and the
**structure skeleton** (heading identity / hierarchy / zoning / frontmatter, consumed at preprocess
time). Both land in `{paper}/.oracle/` from the same converter tap.
**Origin:** user direction — fold the `latex_convert` capability into the membrane repair workflow as a
purely additive assist: *"when latex exists it should make the cases very tractable and high fidelity
nearly guaranteed"*; extended same-day: *"latex could also be helpful in disambiguating the true header
and section identities and help with resolving the front matter — preprocessing both the json and the
latex source, the two resources used in conjunction from the beginning."*
**Related:** the LaTeX-oracle publish lane (memory `latex-oracle-publish-lane` — the *whole-paper* use of
the converter, which stays as-is), `issues/membrane-fixes/gate-blind-spots-valid-but-wrong.md` (the
verification tier below is that brief's missing ground truth), the Voroninski 1611.03935v1 polish
(manual precedent: acquire-source → propose_edit → finalize — this lane systematizes exactly that).

---

## The target register (design north star)

The published deliverable is **semantically faithful markdown, not a typeset carbon copy of the
source**. Conversion (from PDF *or* LaTeX) is inherently lossy; the losses are acceptable exactly when
prose and semantically meaningful formatting survive and typesetting minutiae are left behind. For math
the register is **canonical KaTeX** — the unambiguous, model-readable language (`\mathbb{R}`, never a
unicode ℝ glyph) — which is why macro expansion is a *feature*, not a fidelity loss: the author's
private vocabulary (`\R`) compiles down to the shared language. This is also Docling's stated goal, so
the two lanes share a target language — Docling *guesses* its way there from rendered glyphs, the
source lane *compiles* there from truth, and the verification tier is a diff between two strings in the
same canonical vocabulary. "Tokenization consistency" (Invariant 0) means one CANONICAL token stream per
expression everywhere — not source-verbatim preservation. Corollaries: a unicode→KaTeX canonicalization
pass for PDF-lane math spans is a natural enrichment-tier addition; and the someday diagram-semantics
mapping should run TikZ-source→Mermaid (the source states nodes/edges; the SVG is the diagram's "PDF"),
for which the persisted run-dir tex + the stashed TikZ envs are the preserved inputs.

## The claim

When a paper's arXiv LaTeX source is staged (and for this corpus it often already is — the tarball sits
beside the paper, e.g. `membrane-testing/2112.10906v4/arXiv-2112.10906v4.tar.gz`), the **true form of
every equation the PDF→IR conversion destroyed is sitting on disk**, macro-expanded and KaTeX-ready,
inside machinery the converter already runs. The membrane's repair loop currently asks an agent to
*reconstruct* corrupted math from the corrupted IR; with source present it should instead *transcribe*
from an oracle. The lane must be optional by construction: no source → no bank → byte-identical
behavior.

## Why source-as-data is justified here

The standing rule from the docling-failure-modes thread: use an external view as **data** only when it
carries information the primary view objectively lacks; otherwise it is a QA oracle at most
(opendataloader's `.md` failed this test — its structure was all derivable from the JSON tree). The
LaTeX source **passes** it: the equations the IR lost are not recoverable from the IR at any effort
level. So this is a recovery lane, not a re-derivation lane — consensus-as-data is the right shape,
with one guard (version match, below).

---

## What exists today (the dissection)

### The converter pipeline (`latex-ingest.ps1`, `ConvertFrom-Latex`) — order matters

1. Strip comments; extract macros, title, body; drop never-rendered content (`comment` env, `\iffalse`).
2. Normalize `$$..$$` → `\[..\]`; TikZ → markers; figure-grid tabulars → markers; NiceMatrix → stock
   matrices; assorted KaTeX-compat rewrites.
3. **`Expand-LatexMacros`** — including inside math.
4. **`Build-LabelMaps`** — walks numbered envs (`theorem`-family on one counter;
   `equation|align|gather|multline|eqnarray|alignat` non-`*` on another, **flat count in document
   order**) → label→number maps. **`Resolve-Refs`** rewrites `\eqref{k}` → `(N)`, `\cite` → `[n]`;
   labels stripped after.
5. Theorem envs → `**Lemma N.**` bold heads, numbered to match the rendered paper.
6. **`Protect-LatexMath`** — every math span is lifted into `$script:LtxMathStore` behind `@@LMATHn@@`
   placeholders: alignment envs re-wrapped `\begin{aligned}` (KaTeX-safe), `gather`→`gathered`,
   display vs inline flagged (`Store-Math -Display`). *Store indices are assigned per env-kind pass,
   NOT document order — document order is recoverable from placeholder positions in the body.*
7. Prose conversion (sections, lists, figures, tables, inline commands, accents).
8. **`Restore-LatexMath`** — placeholders replaced (fixed-point, nesting-safe); store discarded.

**Key fact:** at step 6–7 the store holds every equation in exactly the register the corpus standard
wants — macro-expanded, ref-resolved, KaTeX-hardened — and at the end of step 7 the body is *markdown
prose with placeholders still in place*, i.e. per-equation context in the same register as membrane
chunk content. Both are currently thrown away.

### The gates

- `render-check.ps1` / `Test-MathRenders` — KaTeX render validity; **already accepts
  `-Spans @({content, display}, …)`**, so per-entry validation of an equation bank is one batch call.
- `md-lint.ps1` — structural markdown gate (non-math half). Both are the acceptance bar for anything
  the oracle lane emits.

### The repair loop's insertion points

- `playbook.ps1` is **recipes as data** (`{issue type → recipe fragment}`) — an oracle-aware recipe is
  a data addition.
- `get_slice` composes the work-order at read time — an optional `oracle` block on the anchor is
  additive.
- All content lands via `propose_edit`/`propose_repair` → `apply` with its gates — the oracle never
  needs (and never gets) a bypass.

---

## Phase 0 — extraction: the math bank

Tap `ConvertFrom-Latex` at the end of step 7, before `Restore-LatexMath`:

- Walk `@@LMATHn@@` placeholders in **body order** → document sequence.
- Per entry emit: `seq`, `kind` (display|inline), `env` (align|equation|gather|…|dollar — additive
  `-Env` param on `Store-Math`), `numbered` (non-`*` member of the Build-LabelMaps env set), `eq_no`
  (ordinal among numbered display spans in document order — the same counting Build-LabelMaps uses, so
  it matches what `\eqref` resolved to), `latex` (unwrapped store content), `context_before` /
  `context_after` (~120 chars of the converted markdown around the placeholder), `renders`
  (per-entry `Test-MathRenders -Spans` verdict).
- Surface: extend `latex_convert` (arg `emit_math_bank`) or a sibling tool `latex_math_bank paper` that
  resolves a staged tarball beside the paper (or in `_inbox`).
- Landing: `{paper}/.oracle/{slug}.mathbank.jsonl` — per-paper and **run-independent** (derived from
  source, not from any run), regenerable, gitignored (`**/.oracle/`).
- **Version guard:** tarball version tag must match the paper slug (`arXiv-2112.10906v4` ↔
  `2112.10906v4`); mismatch → refuse, or mark the bank `version_mismatch` and cap alignment scores.

## Phase 0b — the structure skeleton (same tap, second consumer)

The source also carries the **true document structure**, and the converter already parses all of it
(verified): `\(sub)*section` → heading with **exact hierarchy depth from the `sub`-count**
(`latex-ingest.ps1:445`), `\begin{abstract}` → `## Abstract`, `\title` → H1, theorem heads numbered to
match the rendered paper, `\newtheorem` custom environments resolved to display names. This passes the
information-asymmetry test even more cleanly than the math: the IR's heading *levels* are scrambled
(Docling `level` refuted in the docling brief), its zoning is regex-on-rendered-text (the Roman-numeral
collapse class), and its frontmatter is inferential — the source states all three.

Emit `{paper}/.oracle/{slug}.skeleton.jsonl`: ordered structural events —
`{seq, kind: title|author|abstract_begin|abstract_end|section|appendix|bibliography, level (2 + sub-count),
text (inline-converted title), starred}` — extracted by walking the pre-protection body with the
converter's own patterns.

**The matching insight that sidesteps the whole numbering problem:** match IR headings to skeleton
entries on **normalized title text** (strip leading numerals/periods of any style, collapse ALL
whitespace, casefold, ligature-normalize) under a monotone-order constraint. `"Introduction"` then
matches `"I. I NTRODUCTION"` directly — Roman vs Arabic numbering AND the drop-cap injected-space
artifact become irrelevant, because the source title never carried a number and the normalization
absorbs the artifacts. No `\thesection` format inference needed.

### Consumption at preprocess time (the "from the beginning" integration)

`preprocess` gains a conditional **stage 0 — source-oracle**: a version-matched tarball beside the
paper → extract/refresh `.oracle/` (skeleton + math bank) before `project-ir`; absent → skip silently.
Then, per stage, skeleton-guided decisions with per-decision fallback to the current heuristics
(partial matching is fine — this constrains, it does not replace):

- **`headings.ps1`** — after recovery, reconcile: IR heading matched to a skeleton entry → confirm +
  assign `section_level` from the source depth (`heading_source='oracle-confirmed'`); IR heading with
  no skeleton match → over-promotion suspect (flag/demote, audited); skeleton entry with no IR match →
  a MISSED heading — search paragraph nodes for the normalized title and promote
  (`heading_source='oracle'`). Kills both over- and under-promotion classes for source-available
  papers, and supplies the principled engine guard the heading-overpromotion thread deferred.
- **`zones.ps1`** — body begins at the chunk matched to the skeleton's first section; backmatter at the
  matched bibliography/appendix event. The `Test-BodyStartHeading` regexes remain the no-source
  fallback. This retires the Roman-numeral acute-collapse class *properly* wherever source exists
  (the three acute docs are arXiv slugs — source is one `acquire` away).
- **`sections.ps1`** — section titles/paths anchored by the matched headings.
- **Frontmatter** — positively bounded (everything before abstract-end/first-section), with title and
  author lines identified as such rather than inferred — e.g. 2408.16741v2's author/affiliation
  promotions classify definitively.
- Every oracle-guided decision lands in the audit log (`zone_source`/`heading_source`), so a run
  remains deterministic and explainable, and a no-source run is byte-identical to today.

The three-views architecture this completes: **JSON IR = geometry** (fonts, bboxes, scripts),
**LaTeX source = logical truth** (structure + math), **converter `.md` = independent QA diff**
(Compare-MarkdownIR) — each view used exactly where it holds information the others lack.

## Phase 1 — alignment, on demand (zero touch to existing flow)

New tool `get_oracle paper id [k]` → top-k bank candidates for one chunk, scored on independent signals:

1. **Equation-number anchor** — normalized `(N)` tokens in the chunk (or its prose neighbors) vs
   `eq_no`. Strong when present. ⚠ Caveat: `Build-LabelMaps` counts **flat**; a paper using
   `\numberwithin{equation}{section}` renders `(3.2)`-style numbers that the flat ordinal will NOT
   match. The anchor is therefore one signal among several, never a sole key (or the counter grows
   `\numberwithin` awareness later).
2. **Math-token overlap** — corruption-tolerant Jaccard over normalized token multisets (identifiers,
   operator names, digits); the mask machinery in `latex.ps1`/`masks.ps1` is reusable here.
3. **Kind agreement** — display ↔ formula chunk; inline ↔ prose-embedded.
4. **Monotone order prior** — document-position percentile (chunk seq/page vs bank seq), soft.
5. **Context similarity** — bank `context_before/after` vs neighboring prose chunks (both are
   markdown-register text).

Returns `{seq, eq_no, latex, renders, score, signals}` — candidates only, never applied. No bank on
disk → the tool says so; nothing else in the membrane changes.

## Phase 2 — workflow enrichment

- `get_slice` anchor gains an optional `oracle` block (top 1–3 candidates) when a bank exists and the
  chunk carries math issues; the work-order gains a playbook recipe: *"compare against the oracle
  candidate; if equivalent modulo the corruption, transcribe it via propose_edit/propose_repair with
  `source='latex-oracle'`."*
- `get_summary` / `list_documents` flag `oracle: true` so orchestrators can route math-heavy flagged
  papers preferentially through the assisted path.

## Phase 3 — auto tier + verification tier

- **Auto (propose-only, mirroring the enrichment lane's Tier 1):** exact-anchor + high-overlap +
  `renders` candidates become *staged proposals* with `source='latex-oracle'`; `apply`'s gate and the
  audit trail are unchanged.
- **Verification (the gate-blind-spot killer):** walk allegedly-`faithful` formula chunks, compare
  against aligned bank entries; disagreement → `needs_review` with reason `oracle_mismatch`. This is
  the missing ground truth for the valid-but-wrong class (destroyed-but-balanced equations, smuggled
  `\text{}` prose) that `gate-blind-spots-valid-but-wrong.md` catalogs — delivered without touching
  the frozen gate (severity-field pattern from that brief).

---

## Invariants

0. **Tokenization consistency + fence-only-if-monospace (FIXED IN THE CONVERTER, 2026-07-01).** One
   expression must produce ONE token stream wherever it appears — the whole ingestion depends on it.
   The converter violated this for algorithm pseudocode: `Convert-Algorithms` ran *before*
   `Protect-LatexMath`, so `Flatten-AlgText` stripped `$` delimiters and collapsed wrapper semantics
   (`\mathbf{x}`→`x`, `\mathcal{G}`→`G`) inside fences — the same `$\mathbf{A} x_i^2$` tokenized two
   different ways in body vs pseudocode, and algorithm-internal math never reached the math store
   (would have silently escaped the bank). Landed fixes (all in `latex-ingest.ps1`, suite
   `tests/latex-ingest.Tests.ps1`):
   - **Ordering:** math protection now precedes algorithm conversion — `Flatten-AlgText` only ever
     sees scaffold prose; algorithm math reaches the store, so the Phase-0 tap captures it
     automatically.
   - **Fence-only-if-monospace (user policy):** a markdown code fence is emitted ONLY for constructs
     the PDF really presents as monospace. `algorithmic`/`algpseudocode` render in the PDF as
     indented lines with bold keywords and LIVE math — so they now emit **nested markdown lists**
     (ordered iff the source asked for line numbers via `\begin{algorithmic}[1]`, bullets otherwise),
     with `**bold**` keywords, `▷ *italic*` comments, and `$`-delimited math that actually renders
     (subscripts included — the fence-can't-render-math limitation dissolved rather than worked
     around). Blocks are stashed and restored after the dedent pass, which would otherwise strip the
     list indentation.
   - **Verbatim lane:** `verbatim`/`Verbatim`/`lstlisting`/`minted`/`alltt` — the genuinely-monospace
     constructs, previously UNHANDLED (raw env leaked) — are stashed from the raw source **before
     comment-stripping and math protection** (in code, `%` is not a comment and `$` is not math;
     a PowerShell listing's `$env:PATH` survives byte-verbatim) and emit language-tagged fences from
     the source's own declaration (`language=` / minted `{lang}`, else `text`). Inline `\verb` /
     `\lstinline` → backtick spans is a noted follow-up.
   - **Float content-loss fix:** non-`algorithmic` content inside `algorithm` floats
     (enumerate-style pseudocode, prose) used to be silently DISCARDED; it now stays inline and flows
     through normal conversion.
   Real-paper check: 2509.20220v2 regenerates **byte-identical** (no algorithms/verbatim — clean
   no-regression on the ordinary path). Any future extraction MUST preserve this invariant — the bank
   exists to carry canonical tokens, never a flattened rendering. (The someday-AST — Markpig visitor
   idiom — handles this class natively; until then these guarantees are the load-bearing substitute.)
1. **Purely additive.** No tarball → no bank → behavior byte-identical. Plenty of papers will never
   have source; the lane must never become a dependency.
2. **Oracle content is KaTeX-hardened by construction** (the converter's own compat layer) and
   render-checked per entry before it is ever offered.
3. **No gate bypass.** Oracle content enters through `propose_*` → `apply` like any agent edit, with
   provenance in the audit log.
4. **Run-independence.** The bank derives from source, lives per-paper, and survives re-preprocessing;
   run immutability is untouched.

## Diagrams and figures (converter fixes LANDED 2026-07-01; weaving = the two-view step)

The "dead `*[diagram]*`" complaint decomposed into two defects with different owners:

- **`\includegraphics` figures died with the temp dir** — the tarball *contains* the pixels, but
  `Invoke-ArxivLatexToMarkdown` deleted its workdir, leaving every `![](…)` link dangling. **Fixed:**
  `Copy-LatexFigures` resolves each link against the extracted tree (leaf-name recursive probe — handles
  extensionless `\includegraphics{figs/arch}` and `\graphicspath` at once, and prefers a raster twin over
  its `.pdf` sibling), copies the file to `{outdir}/{slug}/`, and rewrites the link. Raster → live image
  link; vector-only (pdf/eps) → plain clickable link (an image tag on a .pdf renders broken); unresolved →
  an addressable `*[figure: name — source file not found]*` marker. The tool result now reports
  `figures / figures_missing / diagrams`.
- **TikZ is genuinely unrenderable converter-side** (vector-drawing source, no TeX engine) — but the
  rendered pixels EXIST in the other view: the PDF extraction's `{slug}/imageFileN.png`. Markers are now
  **numbered** (`*[diagram N — TikZ source, not rendered]*`) so a weaving step can target them.
  Real-paper scale: 2509.20220v2 = **26 TikZ diagrams + 1 raster figure** — the figure now carries out
  live; the 26 markers await weaving.
- **The weaving step is the same two-view merge as everything else here** — source gives figure
  identity/order/captions, PDF extraction gives pixels — and it is ALSO the same gap the membrane publish
  lane already has (finalize emits image-less bodies; publish carries files but "can't weave placement",
  per the publish-lane thread). One aligner should serve both: match diagram/figure markers to
  `imageFileN.png` by document order + caption text, emit the splice. Phase-2 scope alongside the
  skeleton.
- **Source-rendered diagrams (LANDED 2026-07-01):** PDF-side image extraction is unreliable
  (opendataloader sometimes misses figures entirely), so the SOURCE is the diagram authority when it
  exists. New `tools/tikz-render` (node-tikzjax: wasm TeX + dvi→SVG, vendored node_modules) +
  `src/tikz-render.ps1` shim (batch-oriented — one wasm init per paper; per-job fault isolation) —
  the converter stashes each `tikzpicture`/`tikzcd` env, macro-expands it, and renders to
  `{slug}/diagram-N.svg`, swapping the numbered marker for a live image link; a failed diagram keeps
  its marker (weaving fallback). Compile-hardening learned on the real paper: filter the
  externalization libraries from `\usetikzlibrary` capture (shell-escape caching, absent from the
  wasm texmf, and ONE bad library in the shared list poisons every job); carry preamble
  `\definecolor`/`\colorlet` into the render preamble (custom node fills); re-apply the
  NiceMatrix→matrix rewrite to stashed sources (stash precedes the body-wide pass). Result on
  2509.20220v2: **26/26 diagrams render** (~57s batch). Residual: `\tikzset` style blocks not yet
  carried (brace-aware capture, follow-up); font CSS in SVGs is a CDN `@import` (may fall back to
  default fonts in strict `<img>` contexts). KaTeX (`tools/render-check`) remains math-only — it can
  bake rendered HTML for math-bank entries but has no TikZ grammar; weaving from PDF-extracted
  pixels is now the fallback for no-source papers only.
- **Unpacking is a run artifact (LANDED):** the tarball unpacks into `{tar-dir}/.runs/{stamp}/tex` —
  persisted, gitignored, non-destructive across passes — instead of a deleted system temp dir. The
  Phase-0 extraction (math bank + skeleton) reads the SAME unpacked tree instead of re-extracting; the
  tool result reports `run`/`tex`. The run-layout helpers were split out of serving.ps1 into
  `src/runs.ps1` so non-membrane lanes share the layout without dragging the serving stack.

## Open questions

- Numbering fidelity beyond the flat counter: `\numberwithin` (per-section `(3.2)`), `\tag{}`,
  `subequations`, appendix resets. Detectable from the preamble; harden later, rely on multi-signal
  scoring now.
- Skeleton matching edge cases: heading titles containing math (`$k$-cores` — normalize via the same
  inline conversion the converter applies), `\section*` unnumbered heads (Acknowledgments — still
  headings, just unnumbered), detecting the `\appendix` switch itself, and multi-title papers
  (v1-source vs revised-PDF section renames — the version guard plus per-decision confidence covers
  the common case; a low match-rate should demote the whole skeleton to advisory).
- Inline math alignment is intrinsically weak (short, ubiquitous) — scope Phase 1–3 display-first.
- Theorem statements as bank entries (the bold `Proposition N.` heads are numbered to match the
  rendered paper already) — natural later extension for prose-adjacent repair, same tap.
- The benchmarking thread (membrane as long-horizon-task workbench) is explicitly out of scope here,
  but the bank doubles as its answer key: per-equation ground truth + `renders` gives a scoreable
  repair-fidelity metric for free.
