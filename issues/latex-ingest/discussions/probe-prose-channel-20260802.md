# Prose-channel probe — field notes

**Status:** probe complete (four passes, one specimen; residue 0; full interleaved stream), findings recorded
**Date:** 2026-08-02
**Touches:** `src/latex-ingest/latex-ingest.ps1` (`-ChannelProbe` seam, gated/inert in production),
`scratch/probe-prose-channel.ps1` (driver, gitignored one-off),
`artifacts/latex-ingest/probe/{slug}/` (outputs, regenerable)
**Companions:** [latent-manuscript-doctrine-20260802.md](latent-manuscript-doctrine-20260802.md)
(the inversion this probes), [guards-and-placeholders-20260731.md](guards-and-placeholders-20260731.md)
(the direction lesson the probe's checks apply), [refs-consolidation-20260731.md](refs-consolidation-20260731.md)

---

## 1. The question and the seam

How hard is it to assemble the prose channel end to end with math/figures/diagrams as unresolved
slots? Answer: **the pipeline already computes that state transiently** — between
`Protect-LatexMath` and `Restore-LatexMath`, every prose operation (sectioning, lists, emphasis,
accents, whitespace, reflow) runs over text whose fragile regions are opaque slots. The
protect→prose-ops→restore sandwich *is* channel separation, implemented as a temporary disguise
inside one string; the restore is where the briefly-separated manuscript gets collapsed back.

The seam (commit `44b2864`): `ConvertFrom-Latex -ChannelProbe` stops at the mid-state and returns
the assembly + stores instead of restoring. A probe-only figure stash captures figure-family floats
**whole** (graphics + caption + `\label`, caption math raw) before the label strip — the same move
as the existing tikz stash. Pass 2 (this commit) adds placement-evidence capture: `@@BARRIER@@`
rows for `\FloatBarrier` / `\clearpage`-family (the flush rider), the float specifier as a field on
each figure, and preamble facts (`placeins`, `placeins_section`).

Emission per slug: `{slug}.prose.md` (prose channel, slots in place), `{slug}.slots.jsonl` (one row
per body slot in reading order: seq, kind, marker, char_offset, content, children; figures carry
`spec` + `label`, barriers carry `via`), `{slug}.probe-report.json`.

## 2. Specimen 1: 2408.16741v2 — closure is total

| measure | value |
|---|---|
| body slots | 1302 — LMATH 1206, LDISP 76, FIGENV 12, ALG 7, BARRIER 1 |
| stores | math 1429, algs 7, verbs 0, figures 12, diagrams 13, barriers 1 |
| leaked (in text, no store) | **0** |
| orphaned (in store, unreachable from text) | **0** |
| nesting edges | 160 |
| prose channel | 61,284 chars net |

- The placeholder check ran in **both directions** — text-driven and store-driven, per the guards
  brief — and both came back clean. The slot algebra is closed on the first specimen.
- The arithmetic closes exactly: 1429 math entries = 1282 in body + 147 nested (algorithm math +
  math-in-math); all 13 diagrams are children of the 12 figure slots.
- **Nesting is document structure, not bookkeeping**: figure→diagram (the diagram *is* the
  figure's graphic), alg→math, math→math. What the 8-pass restore loop iterates away is the
  parent/child relation, available for free.
- The prose reads as finished markdown: refs resolved, theorem run-ins bold, display slots
  standalone on their own lines (the LDISP/LMATH prefix split visibly surviving reflow).

## 3. Residue ledger — the growth mechanism, observed working

Pass 1: **3** residual TeX commands in 61k chars of prose. Pass 2: **2** — the ledger *shrank
because the model grew* (`\FloatBarrier` became an evidence row). That is the
assemble-toward-the-uncertain-spec mechanism doing its job: residue → classify → the protograph
gains a kind, an evidence row, or a defect ticket.

- `\FloatBarrier` → **placement evidence**, now captured (§4).
- `\appendix` → **ADMITTED to the protograph taxonomy** (user, same day): the appendix is a
  section of the paper — not always present, but part of the superset. Captured as an
  `@@APPENDIX@@` structural row in pass 3. The KisungYou silhouette confirms the kind from the
  output side (§6): a thin `appendix:0` boundary node followed by lettered ordinary sections.
  Letter renumbering of what follows remains a realization detail for the spine model.
- `\cite` → **defect specimen, FIXED in pass 3**: the author put `\cite[Theorem 3.1]{pers_lap}`
  inside a theorem's optional-argument title, and the `Convert-CrossRefEnvs` title capture was
  not bracket-aware — the nested `]` shredded the head. Fix: `Get-BracketGroupEnd` (`]` closes
  only at brace depth 0, escapes skipped) + bracket-aware rescan with true-end consumption, and
  a whole-arg `{…}` wrapper unwrapped as TeX grouping. The head now emits the citation intact
  and the body's `Resolve-Refs` pass renders it: `**Theorem 3.5 ([15]).**` on the specimen.
  Nuance logged: the citation's optional qualifier ("Theorem 3.1") is dropped by cite
  resolution — a separate, pre-existing ref-semantics gap.

**Residue after pass 3: 0.** Every TeX command in 61k chars of prose is transformed, slotted, or
admitted — the first fully-classified specimen, reached in three ledger-driven steps.
- Also observed (invisible to the command scan): a **stray brace-group class** — author `{...}`
  around phrases leaks literal braces into prose ("{and the supports ...}").

## 4. Placement evidence (minted this session)

The surjection kernel has **two sorts**, decidable by one rule: marks that speak about the **page**
die in the surjection (markdown has no pages — `\newpage`, `[htbp]`'s page preferences); marks that
speak about **order/adjacency/containment** survive and are *consumed by the walk*. So
"classified, never lost" splits into classified-and-ledgered vs classified-and-consumed.

- `\FloatBarrier` is a **dam for deferred content**, not a break in the main flow (prose streams
  through it; the float queue cannot). Word kin: keep-with-next / object anchoring. Web kin:
  CSS `clear`.
- `\clearpage` is the compound specimen: page-speak (dies) carrying a flush rider (survives) —
  captured as a barrier row with `via` distinguishing.
- Float specifiers are the per-float grain of the same intent: `[H]` = pinned to declaration,
  `[htbp]` = preference order. This paper's census: 7×`[H]`, 3×`[ht]`, 1×`[h]`, 1 unspecified —
  a pin-heavy author.
- Specimen: exactly **one** `\FloatBarrier` in the document, immediately before `\appendix` — the
  author's single document-scale assertion: *the appendix starts with a clean float queue.* In the
  stream it is now an addressable row (seq 1042) rather than furniture.
- `placeins` facts recorded per document (`{placeins: true, placeins_section: false}` here); the
  `[section]` option would make every `\section` an implicit barrier — knowable from one preamble
  line, recorded as a fact rather than synthesized as rows.

The walk's placement policy becomes a named function over source-knowable inputs: **f(declaration
seq, specifier, barrier scope, refgraph first-reference)** — barrier scope as the hard bound,
first reference as the soft anchor. Free audit: a float whose reference sites all lie outside its
own barrier scope is a flag (author oddity or scope-model bug).

## 5. Entanglement specimens (predicted → confirmed)

Each is "an invariant implicitly correct, at the wrong stage" — the thing the probe was built to
surface:

1. **Refs baked in before capture.** `Resolve-Refs` runs before `Protect-LatexMath`, so slot math
   carries resolved reference text; equation `\label`s are stripped before capture. The
   refs-consolidation inversion (resolution attempted inside collection), visible in the math
   channel.
2. **"Unresolved" today means fully-realized.** Stored math is macro-expanded, KaTeX-compat
   substituted, and register-canonicalized *at store time* (`Store-Math` →
   `Invoke-LatexMathStoreLowering`). Realization is smeared across stages rather than being a
   stage.
3. **The store is a flattened tree pretending to be a dictionary.** Nesting was never modeled,
   only iterated away (the bounded 8-pass restore). Under emission it becomes parent/child
   structure for free.

## 6. KisungYou silhouette census (pass 3)

Computed over `bibliotecha/corpora/KisungYou/2605.20681v1.chunks.jsonl` (58 rows, schema
`manuscript-objects.v0`, seq contiguous 0..57):

- **Kind census:** metadata 1, title 1, authors 1, toc 1, abstract 1, section 11, subsection 38,
  assumption 1, appendix 1, backmatter 1, references 1. Fields: `addr, seq, kind, kind_index,
  level, title, anchor, parent, source{path,line_start,line_end}, content, char_count` (+
  occasional `notes`).
- **The appendix kind is realized on the output side exactly as admitted on the source side:**
  a thin `appendix:0` boundary node (12 chars), then `A Proofs` / `B …` / `C …` as *ordinary*
  `section` rows with letter numbering carried in the title text, subsections A.1–A.15 under
  them. Forward capture (`@@APPENDIX@@` row) and reverse sketch agree — the first protograph
  kind confirmed from both directions.
- **Tiling is imperfect in the reverse direction:** the content model claims exclusive
  ownership, but the realized spans carry **2 gaps and 3 overlaps** across 56 spanned rows.
  The probe's forward capture on its specimen: 0 leaked / 0 orphaned. One number per direction —
  reverse-engineering the spine from output cannot quite close; forward assembly closes by
  construction.
- **The embedded math channel is visible and large:** 132 `$$` display blocks (~15.7k chars)
  riding inside prose bodies, per the silhouette's deliberate scope. The probe holds the
  complement: math extracted (1429 spans on its specimen), prose monolithic.
- **A known defect class is fossilized as a kind:** `assumption:0` exists because the original
  converter promoted "(A1) Moments and eigengap." to a heading (the heading over-promotion
  class) — the silhouette modeled the accident rather than repairing it. Schema lesson:
  theorem-like objects (assumptions included) want to be spine-addressable nodes born from
  source environments, not accidents of heading promotion.

**Convergence target, stated by the union:** the silhouette has the spine (addr/parent/level,
anchors, front/backmatter kinds) and no channels; the probe has the channels (math, figures,
diagrams, algs, placement evidence, closure discipline) and no spine — its prose is one
undifferentiated stream. The next probe pass adds **spine rows**: section/subsection nodes from
the ordered walk `Convert-CrossRefEnvs` already performs (the capture point exists in
production), with prose blocks and slots addressed under them — the full interleaved stream both
artifacts are converging on.

## 7. Pass 4 — spine rows: the interleaved stream

The §6 convergence target, landed. `Convert-CrossRefEnvs` — the one ordered walk that already
sees every section marker, theorem env, and label with the counter model in hand — gains
probe-gated spine capture: `@@SPINEn@@` tags each node's start in the flow (the heading / run-in
still renders), `@@SPINEENDn@@` closes a theorem-like env's extent, and labels bind to spine
entries through the same `pending` mechanism that feeds the maps. The driver becomes a
structural walk over one merged grammar, emitting the full stream:

| rows | 1631 total |
|---|---|
| spine | title 1 + section 13 + subsection 15 + subsubsection 1 + **78 theorem-like** across 8 kinds (definition 22, remark 16, proposition 12, lemma 9, theorem 6, example 6, result 4, corollary 3) + appendix 1 |
| prose | 220 blocks, 74.4k chars — inline math rides inside content as markers |
| channels | LMATH 1206 (rows follow their containing prose block, parent = its addr) + LDISP 76 + FIGENV 12 + ALG 7 + BARRIER 1 |
| closure | still **0 leaked / 0 orphaned**, all 107 spine markers reachable; spine store 107 = 29 section-family + 78 objects, exactly the spine rows emitted |

Quality evidence from the stream itself: section rows own their heading line and carry
source labels (`section:1 → sec:non_brch_mtx`); theorem rows carry number + label + stamped
`end_offset` extents; prose inside a theorem parents to the theorem
(`prose → result:0`, the Result 1 statement with 11 inline math children); addressing is
silhouette-parity (`addr = kind:kind_index`, `parent`, `level`, `seq`). Every view is a query:
section tree = group-by parent, math bank = filter kind, reading order = sort seq. `prose.md`
serializes with spine markers stripped — zero structural residue in the readable channel.

**The appendix realization gap is now measurable, not conjectural:** post-appendix sections
emit numeric numbers 8–13 where the paper letters them A–F. The `appendix` row marks exactly
where the numbering mode should switch; the counter model doesn't yet switch it. Numbering
realization is a per-mode policy of the spine — a protograph design item with a concrete
specimen.

Grain note: prose rows are inter-boundary segments and can span multiple paragraphs (the top
fan-out block carries 63 inline spans). Paragraph-grain splitting is a trivial refinement of
`Flush-Prose` when wanted.

## 8. Pass 5 — (mode, ordinal, regime) on the spine; normalization as a serialization flag

The numbering reframe (user, same day), implemented and measured. Not a mode-switch feature but
an **internal alignment and recounting problem**: letters and numbers are both *symbols indexed
from 1*; the spine row's invariant is a **mode-local ordinal + regime** (symbol alphabet), and
every displayed number is a derived projection. Source-faithful, since `\appendix` is literally
`\setcounter{section}{0}` + `\thesection→\Alph` — a recount and a re-alphabet.

Mechanics: the walk's regex gains a `\appendix` alternative (captureless — production behavior
identical, the token passes through verbatim as before); in probe mode it flips probe-local
`(apx, apxSec)` state, and spine entries carry `mode` / `ordinal` / `regime` alongside the baked
`number`. The driver projects both ways from the same invariant — `faithful` (regime symbols)
and `normalized` (the baked arabic continuation) — so the pass-4 "8–13" output is retroactively
explained as a *basis confusion*, not wrong numbers.

Measured on the specimen:

- alignment table: ordinals 1–6 → faithful **A–F** ↔ normalized **8–13**, labels bound
  (`appdx_codes → B`, …); compounds project through the parent chain (`8.1 → A.1`,
  `10.1 → C.1`).
- **`normalized_injective_across_document: true`** — the unambiguity guard for normalization,
  passed: global arabic continuation yields 1–13 with no collisions.
- **`restart_unqualified_collisions: 6`** — per-mode restart without a qualifier would collide
  six ways; the guard quantifies why continuation (or qualified restart) is the safe form.

**Normalization decision (user):** an *optional normalization* of these stylistic indexing
choices — rebase to arabic 1-counting across the board in deliverables, guarded by the
injectivity check per document. The target audience (reasoning readers) likely prefers it; the
faithful `(mode, ordinal, regime)` stays in the model regardless, so faithful and normalized are
both one serialization flag away. Notably, production's baked numerics already *accidentally*
implement the normalized projection — formalizing it is a policy declaration, not new machinery.
Reference rendering must apply the same projection consistently (`\ref{appdx_codes}` → "B" or
"9", never a mix); the refs-model consequence stands: label → (regime, ordinal-path), display
rendered at resolve. Projection mechanics already in-lane: `Format-Counter` / `ConvertTo-Roman`.

## 9. Pass 6 — the tarball sweep (corpus census)

`scratch/probe-sweep.ps1`: every tarball under `ingestion/` (34 staged, ≈32 unique — two papers
are double-staged under versioned/unversioned slugs), dedeuped inbox-first, unpacked into
gitignored staging, probed with failure isolation. **All 34 convert end to end** (~14 min; the
one recorded "failure" was the sweep harness itself — `ConvertFrom-Json` refusing
case-colliding residue keys `\these`/`\These`; fixed with `-AsHashtable`, and that paper's
driver artifacts were fine all along). Aggregates: `artifacts/latex-ingest/probe/_sweep-summary.md`
+ `_sweep-results.json`.

**Closure, corpus-wide:** leaked = **0 on every paper** — the text-driven invariant holds
everywhere. Orphans are NOT zero everywhere: **~67 orphaned store entries across 9 papers, and
every sampled one is a diagram marker** (tikzcd/tikzpicture stored, marker unreachable at
emission). This is a production defect class made visible by the store-driven direction of the
check: those diagrams silently vanish from production deliverables (the render swap no-ops on a
marker that no longer exists). Smallest specimens for the trace: 2205.11338v3 (×1),
2403.08110v4 (×2), 2112.10906v4 (×4); largest: 2403.08308 (×28), 2501.00322v1 (×12).

**Residue ledger (~150 distinct commands), classified:**

1. **Tables are the largest unclassified channel by far** — `\small`/`\setlength`/`\tabcolsep`/
   `\multirow`/`\resizebox`/booktabs rules/`\multicolumn`/`\makecell`/`\rowcolor`… the table
   apparatus dominates the top of the ledger. The protograph wants a table channel.
2. **The brace-nesting render class** — commands the pipeline handles fine on flat arguments
   leak raw when the argument nests braces: `\textbf` (104 hits/9 papers), `\caption` (30/9),
   `\subsection` (10/7), `\section`, `\paragraph`. Same defect family as the pass-3
   theorem-title fix (`[^{}]*` regexes vs brace-aware capture) — one systematic production fix.
3. Font/size kernel furniture (`\small` 283, `\tt` 154, `\large` 71, `\footnotesize`…) —
   inert, classify-and-drop.
4. Front/backmatter apparatus (`\date`/`\and`/`\affiliation`/`\institute`/`\city`/`\country`/
   `\received`/`\pacs`/`\ccsdesc`/`\bmhead`…) — the §8-strip families, incompletely covered.
5. **algorithm2e is an unhandled pseudocode package** (`\tcp`/`\KwIn`/`\KwOut`/`\For`/`\Fn`…)
   — Convert-Algorithms covers algorithmic/algpseudocode only.
6. Inline `\verb` + `\lstinputlisting` (external listing files) — verbatim channel gaps.
7. biblatex tail (`\printbibliography`/`\autocite`/`\textcite`/`\nocite`), TeX conditionals
   leaking (`\ifx`/`\else`/`\fi`), proof markers (`\qed`/`\qedhere`), minitoc apparatus,
   symbol singletons (`\S`/`\ding`/`\checkmark`/`\ldots`).
8. **Unexpanded author macros** — the residue outlier 2410.01294v3 (442 hits, 85 distinct,
   `\these`/`\These`-style case-colliding semantic macros) is a macro-harvest gap specimen.

**Placement-evidence census:** 272 figure envs — 86 unspecified, `h` 38, `t` 38, `htbp` 29,
`H` 27 (hard pins ≈10%), bang-variants 39. Ten papers carry explicit barriers (27 rows;
2511.04703v1 and 2603.03375 with 7 each). Author placement intent is present on ~two-thirds of
floats — the walk policy has real evidence to consume.

**Normalization guard, corpus-green:** 20 papers have appendices, and
`normalized_injective_across_document` is **true on every one** — the user's optional
arabic-1-counting normalization is unambiguous across the entire staged corpus.

## 10. The tackle (2026-08-03): three production fixes, closure now a hard invariant

Both lead items resolved, and the trace found a bigger fish than either:

1. **The orphan trace found corpus-wide math corruption, not diagram loss** (commit `538bde6`).
   Orphaned diagram markers were sitting *mangled* inside math store contents — and the
   mangling (`not` → `no t`, `\coloneqq` → `\co lo neqq`) was present even in orphan-free
   papers. Root cause: **four lexicon store entries had lost their glyphs to ASCII text**
   (`glyph "o"→"o"`, `rfloor`, `lceil`, `rceil` — a codepoint-mangling incident in the store),
   so in any span containing a non-ASCII char (the glyph pass gate — the em-dash of the
   diagram marker, among others) the matcher rewrote every bare `o`-before-letter and doubled
   backslashes on `\rfloor`/`\lceil`/`\rceil`. Fixes: glyphs repaired (ο, ⌋, ⌈, ⌉); the pass
   now **refuses pure-ASCII lexicon keys loudly at load**; the token separator applies only
   after control-word replacements. Plus a Store-Math divert: a span whose content IS a
   stashed diagram marker (± the aligned/gathered shell) returns to the flow as text — stored,
   it shipped inside `$$..$$` as KaTeX-invalid text; mixed spans warn loudly.
2. **Brace-aware renders** (commit `3e4d288`): headings, paragraph family, `\caption` (now
   also accepting `[short]{long}`), textbf/textsc, emph family, texttt, and the textrm unwrap
   family all converted to the brace-aware `Replace-BracedCommand` primitive — ledger class 2
   eliminated.
3. **Discard-then-capture** (commit `0a0d3b8`): the last orphan in the corpus (an affiliation
   `$^*$` protected into the store, then destroyed with its `\author` arg) was an ordering
   defect — the §8 front-matter drop now runs *before* `Protect-LatexMath`, so math inside
   dropped args never reaches the store.

**Re-sweep (42 converted, incl. 8 fresh `ingestion/inventory/` papers): leaked 0 AND orphaned
0 on every paper** — both directions of the placeholder check are now corpus-wide hard
invariants. The residue ledger reorganized as predicted: the brace classes vanished; resolving
outer wrappers surfaced inner residue (e.g. `\arrayrulecolor` from converted captions); tables
dominate harder than ever at corpus scale (`\small` 18 papers/301 hits, `\multirow` 8/66).
New failure specimen: **2405.12350v1** staging yields an empty resolved source ("Cannot bind
argument to parameter 'Latex'") — the corpus's first real staging failure, untraced.

## 11. The batch (2026-08-03b): refs model, normalization flag, proof spine, grain

User decisions folded in: **tables ADMITTED to the protograph** as a new object kind (the census
question answered); the queued items discussed and landed (commits `74336a8`, `bac5bd9`):

- **Ref model / refgraph seed**: `ConvertFrom-Latex` assembles every declared label with *both*
  display projections (normalized + faithful) and every reference site `Resolve-Refs` renders
  (macro, keys, rendered). Production writes `{slug}.refs.jsonl` beside the other sidecars; the
  probe emits it too (2408: 167 labels, 186 sites). This is refs-consolidation's collect side —
  all source-knowable — with the docgraph's capture role folded in as designed.
- **Normalization as a real flag**: `-FaithfulNumbering` on the production driver. Default =
  normalized (the user's deliverable policy, injectivity-guarded); faithful renders the paper's
  own symbols end-to-end — verified `Definition A.1` / "section B" vs `8.1` / "section 9" on the
  specimen. The faithful map is computed in the walk ((mode, ordinal, regime) recount at
  `\appendix`, now production state).
- **Cite qualifiers render**: `\cite[Theorem 3.1]{key}` → `[15, Theorem 3.1]`; natbib
  prenote+postnote → `[see 15, p. 7]`. The pass-3 gap closed.
- **Proof envs into the spine** (probe): tagged with extent, `[Proof of X]` titles
  bracket-aware; 20 proof rows on the specimen — the theorem–proof bond is now addressable.
- **Paragraph-grain prose** (probe): blank-line split, inline math attaches to its containing
  paragraph; 2408 rises to 276 prose blocks, closure untouched.
- **Build-LabelMaps flat theorem map DELETED** (refs-consolidation step 2, the
  wrong-model-adjacent-to-live-code hazard removed); the oracle's theorem *count* kept.
- **2405.12350v1 resolved**: not a staging failure — an author *empty math span* (`$$ $$`)
  crashed the conversion at the lowering binder (`Mandatory` rejects `''` before the
  empty-guard). Fixed (`AllowEmptyString` + whitespace-span drop in Store-Math). The paper
  converts and is a math-saturated stress specimen: 2,792 inline spans, residue 2,716/81
  distinct including inline `\verb` and bare math commands in prose.

## 12. The channel batch (2026-08-03c): verb, algorithm2e, tables, golden pin

Commits `9be693e` + `fc64724`:

- **Inline `\verb`** stashed at the raw-source stage (after the env captures — inside it `%` is
  not a comment and `$` is not math), emitting inline code spans through the VERB store. The
  family now carries two grains, and the driver routes by content: fences interleave as rows,
  spans ride inside their paragraph like inline math. 2207.00510: residue 4 distinct → 1
  (only the `\lq` quote-macro class remains).
- **algorithm2e adapter**: `Format-Algorithm2e` mechanically lowers the braced-argument dialect
  (`\For{cond}{body}` → `for cond: … end`, `\KwIn`/`\KwOut` → `Input:`/`Output:`, `\tcp` →
  `//`, `\eIf` three-arg, `\;` line ends, apparatus dropped) into a fenced pseudocode block —
  same ALG channel, different vocabulary, hooked where the algorithmic-env attempt misses.
  2404.05484: residue 50 → 13 (`\and`, `\qed` remain — other classes).
- **Table channel** (the admitted kind): table-family floats stashed whole as `@@TABENV@@` —
  caption + `\label` + grid as one bundle with the spec field, mirroring figures. Noted
  honestly: the inner tabular is already markdown at stash time (Convert-Tabular runs
  upstream), so the bundle is captured mid-realization — the forward-assembly version will
  capture it raw. Specimens: 2207 ×6, 2404 ×1; closure 0/0 everywhere.
- **Golden pinning landed** (refs-consolidation step 1): `tests/latex-ingest.refs.Tests.ps1`
  pins all 167 labels (class, type, *both* projections) and all 186 reference sites (macro,
  targets, rendered, in order) against a committed fixture; 5/5 passing; skips where the
  source isn't staged. **Consumer repoint resolved by verification, not churn**: the subject
  index is already model-fed (labels built from the objects records; markdown consulted only
  for `byte_start`, a genuine final-text fact) — the a08656ce note-resolution loop *is* the
  resolve phase, correctly ordered, so refs-consolidation step 4's "delete the bridge" is
  reclassified: there is no bridge, there is a resolve stage. Oracle counts verified after the
  flat-thm-map deletion.
- PS trap for the ledger: a dictionary field named `keys` is shadowed by `.Keys` — the site
  rows silently exploded cite keys into row fields at serialization. Renamed `targets`.

## 13. Closing census (2026-08-03, post channel batch)

**43/43 papers convert, zero failures.** The ledger collapse confirms the table channel's reach:
`\small` fell 301 → 20 hits and the entire table-apparatus block (`\setlength`, `\tabcolsep`,
`\multirow`, `\resizebox`, booktabs rules) left the top of the ledger — stashing table floats
whole took their interior furniture with them. The new top is `\begin`/`\end` (31 each,
unhandled envs), then front-matter and symbol singletons. Specimen deltas: 2405.12350v1
residue **2716 → 25** (the `\verb`/table content that dominated it is now channel-captured);
2404.05484 → 13; 2207.00510 → 45 all-`\lq`; 2410.01294v3 unchanged at 442/85 (pure
macro-harvest, as predicted).

One new find, the store-driven check earning its keep again: **2605.01664v1 has 5 orphaned
VERB entries** — inline `\verb` sites inside table floats, stashed at raw source, whose markers
are then destroyed during tabular realization (Convert-Tabular). Same silent-content-loss class
as the diagram trace, fresh seam, specimen in hand.

## 14. Open items

- **Verb-in-table loss trace**: 2605.01664v1 ×5 — where Convert-Tabular drops cell content
  carrying markers; move to loud-fail or preserve.
- `\lq`/`\rq` quote-macro class (2207 ×45); `\and`/`\qed`/`\hline`-outside-floats classes.
- Macro-harvest gap: 2410.01294v3 (442/85) the last big residue holdout; 2405.12350v1 largely
  resolved by the channels.
- Refs ladder remainder: tex-docgraph reduced to a projection of the model (step 5); gauntlet
  before/after compare (step 6) once full runs resume.
- Normalization as a real serialization flag at production realization, refs rendered through
  the same projection (belongs with the refs-stage work).
- Paragraph-grain prose rows (split segments on blank lines) — cheap, when the schema wants it.
- Proof envs are handled outside the model walk (italic run-in at emission) and are not yet
  spine rows — the theorem–proof bond wants them captured.
- Cite resolution drops the optional qualifier (`\cite[Theorem 3.1]{key}` → `[15]`, qualifier
  lost) — small ref-semantics fidelity gap, surfaced by the pass-3 fix.
- Production path also leaks `\FloatBarrier` (never stripped, survives into deliverables as
  residue) — decide whether production strips it as furniture or carries it as evidence.
