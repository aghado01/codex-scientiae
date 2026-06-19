# Enrichment tier — sketch

A design sketch (not an implementation spec) for the problem first light surfaced and the user correctly
refused to solve with rules: plain-ASCII mathematics like `O(s log n)`, `m = O(s \log(n/s))`, `s`-sparse,
`R^n` that reads as math but carries no LaTeX structure, so the fidelity gate leaves it `faithful` — yet
house style (STANDARDS) wants it in `$…$`. Companion to [`membrane-upgrade-plan.md`](membrane-upgrade-plan.md)
(gap map: *Enrichment tier — designed, not built*) and [`first-light-brief.md`](first-light-brief.md).

---

## The diagnosis — under-markup is not corruption

The membrane's fidelity gate answers exactly one question: **was this content damaged in export?**
`O(s log n)` was not damaged — it is valid, faithful plain text. Wanting it wrapped is a *typesetting*
preference, not a repair. So the gate is **right** to leave it `faithful`; `math_dirt` keys on Unicode math
glyphs outside `$…$`, and ASCII asymptotics have none. This is not a recall hole to patch — it is a
**different question the gate was never meant to answer.**

Conflating the two is what produces the brittle-rule trap. A `\bO\s*\(` signature, or cue-words
("sample complexity", "measurements"), would:

- not transfer across papers (the same token means different things in different documents);
- accrete one special case at a time — exactly the rule-pile that defeats the membrane's principled-detection
  ethos ([[no-magic-string-structural-heuristics]]: principled signals, or defer the semantic part to the
  membrane tier — "do it right or don't");
- risk silently mangling valid text if it ever auto-wraps on a false positive.

## The architectural move — separate the tiers

Two questions, two tiers, run in sequence:

| Tier | Question | Bar | Output |
|---|---|---|---|
| **Fidelity** (exists) | Was it corrupted? | high-**precision** (it gates / flags) | `faithful` ↔ `suspect` |
| **Enrichment** (new) | Is it marked up to house style? | high-**recall** surfacing + per-instance adjudication | `enrichable` candidates |

The key insight that makes this *safe* where a gate signature would not be: **fidelity must be
high-precision because it blocks; enrichment can be high-recall/low-precision because nothing it surfaces is
applied without adjudication.** A noisy enrichment surfacer just over-*offers* — it never silently rewrites.
Brittleness is contained to "too many candidates to review," not "valid text quietly broken." That is the
whole reason ASCII-math belongs here and not in the gate.

`faithful` stays the deliverable bar. **Enrichment is optional and orthogonal** — a document is done at
`pending == 0`; "enriched" is a *higher* bar a run may or may not pursue. Enrichment never moves
`flagged`/`pending`.

## Shape — surface, then adjudicate (the membrane's own pattern)

Enrichment is the dispatch→work loop again, one tier up:

1. **Surface (cheap, structural, high-recall — no decisions).** Mark *candidate* spans where ASCII sits in
   mathematical position. Principled, structural signals — not a keyword list:
   - function-application of a known asymptotic/operator symbol: `O(`, `\Omega(`, `\Theta(`, `o(`, `poly(`;
   - a bare relation chain in prose (`m < n`, `x = 0`) where one side is already `$…$`;
   - `<sym>`-sparse / `<sym>`-dimensional compounds; bare `R^{…}` / `Z^{…}` set symbols;
   - single-letter variables adjacent to math operators outside `$…$`.
   Recall over precision **by design** — this is a candidate net, not a verdict. It may reuse
   `Get-MathStructureMask`'s complement (the prose region) as the search space, but it is a *separate*
   register from the fidelity masks and never feeds the gate.

2. **Adjudicate (semantic, per-instance — the agent's call).** Each candidate is genuinely ambiguous in a
   way no regex resolves (`O` the variable vs `O(·)` the bound; `n s` that is really `n/s` the OCR ate). So
   the adjudicator is an **agent with the surrounding context**, not a rule — exactly the semantic part the
   no-magic-string principle says to defer to the membrane tier. It decides wrap / don't-wrap / reconstruct,
   and emits a `propose_edit`.

3. **Apply under the same discipline.** Proposals go through `propose_edit → apply`, so every enrichment is
   a reviewable, audited diff in the chunk stream — never a bulk regex sweep over the finalized `.md`. Same
   ground-truth, edit-not-regenerate law as repair.

## Guardrails

- **Idempotent · never touches wrapped math.** A second pass over `$O(s \log n)$` is a no-op; the surfacer's
  search space is the prose region (complement of existing `$…$`/structure), so it cannot double-wrap.
- **Optional, orthogonal to fidelity.** No effect on `flagged`/`pending`; a faithful deliverable is complete
  without it. A separate readout (`enrichable` count) measures the higher bar.
- **Surfacer noise is cheap; applier silence is not.** Over-surfacing costs review time; it never corrupts.
  Conversely the applier only ever acts on an adjudicated candidate.
- **Measure it.** Track wrap-proposal precision (adjudicated-yes / surfaced) per run, not a global rule's
  hit-count — the metric is "how good are the candidates," which improves the surfacer without hard-coding.

## Where it lives (open questions)

- **A post-`finalize` tool, or a fidelity-adjacent grade?** Leaning post-fidelity: a distinct
  `enrich`/`get_enrichables` surface beside `dispatch`, run when a paper is already `pending == 0`. Keeps the
  gate frozen and the tier truly separate.
- **Track-1 role split.** Pairs naturally with the deferred role-scoped prompts: an **enrichment agent**
  (markup-to-house-style) distinct from the **repair agent** (corruption) — same membrane, different lens.
- **Scope boundary — what is enrichment vs fidelity?** ASCII-math wrap and `R^n → \mathbb{R}^n` are
  enrichment (valid → house-style). The OCR-shattered subset (`O ( s log n s )` where `/` became a space)
  straddles the line: the *spacing* is a corruption artifact, but recovering the intended `O(s log(n/s))` is
  semantic reconstruction — best handled by the enrichment adjudicator with context, not a gate signature.
- **Stop condition.** Enrichment has no natural `flagged == 0`; it needs an explicit "good enough" bar
  (e.g. surfacer dry, or a sampled-precision threshold) so a run terminates.

## Explicitly NOT

- a new `CorruptionSignature` (it is not corruption; the gate must stay high-precision and frozen);
- cue-word heuristics or a `\bO\(` regex that auto-wraps (the brittle-rule trap);
- a bulk regex sweep over the finalized `.md` (bypasses ground-truth + audit);
- anything that moves `flagged`/`pending` (fidelity and enrichment stay orthogonal).

## Provenance

Surfaced by the `2008.10579v1` first-light run (the `O(s log n)` exchange): cue-words don't scale across
papers; "the engine needs improvement" → the improvement is *architectural separation*, not another detector.
