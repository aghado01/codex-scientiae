# Prose-channel probe — field notes

**Status:** probe complete (two passes, one specimen), findings recorded
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
- `\appendix` → **unmodeled structural signal**: the heading after it emits fine, but appendix
  mode (letter renumbering, spine-level attribute) is nowhere in the model. A protograph admission
  question, found by residue.
- `\cite` → **defect specimen**: `**Theorem 3.5 ({\cite[Theorem 3.1).** {pers_lap}}]` — the
  author put `\cite[Theorem 3.1]{pers_lap}` inside a theorem's optional-argument title, and the
  `Convert-CrossRefEnvs` title capture is not bracket-aware, so the nested `]` shreds the head.
  Fix candidate: brace/bracket-aware optional-arg capture. Independent of the reshape.
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

## 6. Open items

- Run the probe across the remaining staged tarballs (~30 in `ingestion/_inbox` + compendia) —
  grow the residue ledger and the spec census across authors.
- Pressure-test the row shape against the KisungYou silhouette
  (`bibliotecha/corpora/KisungYou/2605.20681v1.chunks.jsonl`): forward-captured rows vs the
  reverse-engineered sketch — the "compare against the silhouette" step of the protograph loop.
- `\appendix` → protograph admission question (user's call).
- Theorem-title bracket-aware capture → small production fix, worth doing regardless of reshape.
- Production path also leaks `\FloatBarrier` (never stripped, survives into deliverables as
  residue) — decide whether production strips it as furniture or carries it as evidence.
