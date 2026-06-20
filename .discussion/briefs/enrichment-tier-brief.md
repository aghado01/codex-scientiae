# Enrichment tier — design sketch (tiered plan)

The principled home for the problem first light surfaced and the user refused to solve with rules:
plain-ASCII mathematics like `O(s log n)`, `m = O(s \log(n/s))`, `s`-sparse, `R^n` that reads as math but
carries no LaTeX structure, so the fidelity gate leaves it `faithful` — yet house style (STANDARDS) wants it
in `$…$`. Companion to [`membrane-upgrade-plan.md`](membrane-upgrade-plan.md) (gap map: *Enrichment tier —
designed, not built*) and [`first-light-brief.md`](first-light-brief.md). Reviewed cold by Cursor
([`cursor/cursor-enrichment-feedback.md`](cursor/cursor-enrichment-feedback.md)); this refresh folds its
accepted points in.

---

## The diagnosis — under-markup is not corruption

The fidelity gate answers one question: **was this content damaged in export?** `O(s log n)` was not
damaged — it is valid, faithful plain text. Wanting it wrapped is a *typesetting* preference, not a repair.
So the gate is **right** to leave it `faithful`; `math_dirt` keys on Unicode math glyphs outside `$…$`, and
ASCII asymptotics have none. This is not a recall hole to patch — it is a **different question the gate was
never meant to answer.**

Conflating the two is the brittle-rule trap. A `\bO\s*\(` signature, or cue-words ("sample complexity",
"measurements"), would not transfer across papers, would accrete one special case at a time
([[no-magic-string-structural-heuristics]]), and would risk silently mangling valid text if it ever
auto-wrapped on a false positive.

## Wrap is not reconstruct — the hard line

A surfaced candidate splits into two operations that are **not the same tier**:

- **Wrap** — put `$…$` around a span that already reads unambiguously (`O(s \log n)`, `\mathbb{R}^n`,
  `s`-sparse). Meaning-preserving markup.
- **Reconstruct** — recover a glyph the export destroyed. `O ( s log n s )`'s trailing `n s` could be `n/s`
  (lost slash), `n_s` (lost subscript), `n^s` (lost caret), `ns = n·s` (juxtaposition — *nothing lost*), or
  `n, s` (two quantities). The disambiguating character is **gone**; this is lossy inference, not markup.

The danger: **wrapping an ambiguous span does not preserve the ambiguity — it launders it into false
authority.** Raw `n s` visibly signals unresolved OCR; `$ns$` *asserts* product, `$n/s$` *asserts* division.
A confident `$…$` that is wrong is worse than the honest mess, because the reader stops doubting it. An
adjudicator that "reconstructs" `$O(s\log(n/s))$` from the chunk alone is **fabricating** — the exact
silent-false-precision failure the fidelity gate exists to prevent.

So the line is hard:

- **Enrichment only ever wraps the unambiguous** — a single conventional reading, no destroyed glyph.
- **Lossy adjacencies are fidelity loss, not enrichment** — escalate via `request_review` /
  `mark_unrecoverable`. The adjudicator **refuses to invent**.
- **The lost glyph lives in the source, not the chunk** — only re-consulting source coordinates recovers it
  honestly, which is exactly what **OffsetMap** (Deferred substrate) enables. The reconstruct half is
  *blocked on* OffsetMap; until then, reconstruction is a guess and the membrane does not guess.

---

## Where enrichment sits — the routing table

Two reasons it lives here and not in the fidelity gate. First, the precision/recall inversion:

| Tier | Blocks? | Trade-off |
|---|---|---|
| **Fidelity** | yes — gates the deliverable | high **precision** (a false flag stalls work) |
| **Enrichment** | no — only *offers* candidates | high **recall**, adjudicated (a false offer costs review time, never corrupts) |

That inversion is the whole safety argument: surfacer noise is cheap; only the apply step touches text, and
it is bounded. Second, the routing — so no one folds enrichment into the fidelity playbook:

```
faithful + math_dirt<2 + ASCII-math-position  →  ENRICHMENT candidate   (this tier)
needs_review + unwrapped_math (math_dirt≥2)    →  repair path (existing, Unicode-dense)
suspect + corruption signature                →  repair path (existing)
lossy adjacency (destroyed glyph)             →  ESCALATE (neither tier wraps)
```

Enrichment is the **ASCII complement** of the existing `unwrapped_math` issue (which is Unicode-glyph
density). It adds **no new corruption signature** and does not move `flagged`/`pending`; it is a
post-fidelity surfacing mode whose proposals still flow through `propose_edit → apply`.

## Three buckets — auto, review, escalate

Every candidate sorts into one of three, governed by **error-cost asymmetry**: a wrong wrap is silent,
authoritative corruption; an unnecessary escalation or review is just labor. So both cut-points bias hard
toward caution — this is not a balanced calibration like gibberish `MinRun`.

**Threshold A — safe-wrap vs lossy (the escalate boundary)** is *structural*, a typology of the bare
atom-atom adjacency the probe keys on:

| Adjacency | Example | Reading | Default |
|---|---|---|---|
| letter–digit | `s 2` | almost always `s^2` / `s_2` (lost super/subscript) | **lossy** |
| letter–letter | `n s` | `n_s` (lost subscript) *or* `n·s` (product) — ambiguous | **lossy** |
| digit–letter | `2 d` | often "2D" / coefficient — weaker signal | **lossy (conservative)** |

Conservative default: any adjacency → lossy → escalate. Over-escalating an innocent product costs review;
auto-wrapping a lost subscript corrupts. The probe confirms the dominant case is the letter-with-index
lost-subscript (`F i+1`, `e i`), so the default is well-aimed.

**Threshold B — auto-apply vs propose-for-review (the apply boundary)** is the high-stakes one, and the v1
answer is **propose-only** (below). The eventual auto-tier is *narrow*: only structurally unambiguous shapes —

- function-application of a known operator, balanced parens, math-only args: `O(s log n)`, `f(x)`;
- a complete relation, both sides present: `n = 25`, `d = 2`, `σ = 0`;
- a clean superscript with `^` intact: `R^n → \mathbb{R}^n`.

Honest decomposition of the probe's 79/21: roughly **auto ~40% / review ~40% / escalate ~20%** — *not* 79%
auto. Safe-wrap means "not lossy," never "safe to apply unattended."

---

## Tiered build plan

**Tier 1 — surface + bucket, propose-only (v1).** Ship the candidate net and measure precision; apply
nothing unattended.

- **Surfacer on the chunk substrate — a requirement, not a preference.** Scan the post-normalize `content`
  of **prose-type, non-`is_reference` chunks** (NOT the rendered `.md`, NOT `content_raw`). Chunk typing
  removes the citation / markdown-link / author-name noise *by construction* — the noise the probe had to
  fight with three hand-tuned filters. Reuse the live tokenizer (`Test-MathGlyphToken`, `$script:MathFunc`);
  require an operator / function / function-application (the filter the probe converged on).
- **Bucket** each candidate safe-wrap vs lossy via Threshold-A typology.
- **Adjudication = the worker role** — the seeing agent inline at depth-1, or a dispatched worker at scale.
  Every safe-wrap is *proposed* via `propose_edit` and confirmed; **lossy → `request_review`, never wrapped.**
  Enrichment needs **no judge of its own**: classifying a candidate is ordinary worker work. The worker
  *backend* — a Claude agent vs a local gguf model standing in for the subagent tier — is a membrane-wide
  substrate question (repair and enrichment alike), out of scope here.
- **Surface:** `get_enrichables` (post-`finalize`, chunk substrate, separate lane from `dispatch`); an
  `enrichable` count in `get_summary`, orthogonal to `flagged`/`pending`.
- **Stop condition:** opt-in per run ("enrich this paper"); defer threshold-based termination.
- **Goal:** accumulate auto-precision data on the three bulletproof shapes.

**Tier 2 — narrow auto-apply, earned.** Once Tier-1 data shows the bulletproof shapes hit ~99%+ precision,
let *those* auto-wrap — every wrap logged to the apply-audit, reversible. Everything else stays
propose-for-review. Add **canonical normalization** (next section) as a separate, even-more-conservative
sub-mode.

**Tier 3 — reconstruction, gated on OffsetMap.** The lossy ~20% (lost subscripts) stays out until OffsetMap
lets the adjudicator consult the *source glyph* instead of guessing. Reconstruction from the chunk alone is a
subscript-recovery problem — exactly what any worker, human or model, does confidently and wrong — so this
tier waits on the **substrate**, not on a cleverer judge. Nothing here needs a new component; it needs source
coordinates.

---

## What the probe measured (2026-06-19)

`scratch/enrichment-surfacer-probe.ps1` over the four finalized deliverables, reusing the live tokenizer +
mask algebra, with the safe-wrap/lossy bucketing above:

- **Ratio ≈ 79% safe-wrap / 21% lossy** of 233 surfaced candidates (~10–15% residual junk still in
  safe-wrap). The wrap-vs-reconstruct split is **load-bearing** — a fifth would be *actively corrupted* by
  naive wrapping.
- **The lossy mode is lost SUBSCRIPTS, not lost slashes** (`F i+1`→`F_{i+1}`, `e i`→`e_i`, `p m+1`→`p_{m+1}`)
  — the recovery a model does confidently and wrong. (`n_s` over `n/s` was right.)
- **The surfacer needs real structure signals.** Tokenizing the `.md` drowned in citations, markdown links,
  and accented author names; three tightenings (mask markdown · drop "any single letter" · require
  operator/function/function-application) took 1009 noise candidates → 233 real ones. **→ Tier 1 runs on
  prose-chunk `content`, which removes that noise structurally.**
- **Volume is the post-manual-repair residual** — tens per paper (2008 had 22 left, already hand-wrapped).
  Value is what enrichment adds atop careful manual work, plus batch-scale consistency.

## Scope — wrap, plus canonical normalization as data (not judgment)

Wrapping is primary. *Symbol normalization* (`log → \log`, `R → \mathbb{R}`, `R^n → \mathbb{R}^n`) is a
separate, tighter sub-mode — and it is **a small explicit data map, the same shape `normalize.ps1` already
uses** for `$script:MathLatex` (Unicode→LaTeX) and `$script:MathFunc`. The adjudicator *applies* the map; it
never invents an upgrade. That caps scope **structurally** — enrichment cannot drift into an opinionated
mini-typesetter (`poly(n) → \mathrm{poly}(n)` and friends are out unless the map says so), with the same
data-not-rules discipline as playbook-as-data.

## Surface — API + tests (Tier-1 stubs)

- **API:** `get_enrichables paper` (chunk-substrate surfacer + bucketing, post-`finalize`, separate from
  `dispatch`); `enrichable` count in `get_summary`; proposals via the existing `propose_edit → apply`.
- **Tests (Pester):** surfacer is **idempotent on already-wrapped math** (no candidate inside `$…$`); the
  **lossy bucket never emits a wrap `propose_edit`**; the three bulletproof shapes classify `auto`; a
  prose-chunk citation/year never surfaces.

## Guardrails

- **Idempotent · never touches wrapped math** — the search space is the prose region (complement of `$…$`),
  so it cannot double-wrap.
- **Optional, orthogonal to fidelity** — no effect on `flagged`/`pending`; a faithful deliverable is
  complete without it.
- **Surfacer noise is cheap; the applier is bounded** — over-surfacing costs review; only adjudicated
  candidates are acted on, and v1 applies nothing unattended.
- **Measure auto-precision, not a global hit-count** — the metric that gates Tier 2.

## Explicitly NOT

- a new `CorruptionSignature` (not corruption; the gate stays high-precision and frozen);
- cue-words or a `\bO\(` regex that auto-wraps (the brittle-rule trap);
- a bulk regex sweep over the finalized `.md` (bypasses ground-truth + audit; and the wrong substrate);
- **reconstructing a destroyed glyph from the chunk** (`n s → n/s` is a guess — re-extraction / OffsetMap
  territory);
- anything that moves `flagged`/`pending` (fidelity and enrichment stay orthogonal).

## Open (genuinely)

- **Track-1 role split** — an enrichment agent vs the repair agent, sharing the membrane; the enrichment
  prompt's hard line is *classify + wrap only; never emit a reconstructed glyph.*
- **Normalization map contents** — which canonical upgrades are house style (the data, decided once).
- **Tier-2 precision bar** — the exact auto-precision threshold (~99%?) and sample size that earns auto-apply.

## Provenance

Surfaced by the `2008.10579v1` first-light run (the `O(s log n)` exchange) and the `n s` ambiguity question:
cue-words don't scale; "the engine needs improvement" → the improvement is *architectural separation* plus a
disciplined surfacer, not another detector. Cold-reviewed by Cursor; its routing table, normalization-scope
flag, and chunk-substrate-as-requirement are folded in above.
