## Review: `enrichment-tier-brief.md`

This is a strong design sketch. It names the right problem, draws a hard line most pipelines blur, and backs the architecture with probe data instead of wishful regex. Below is a structured read — what holds, what to tighten, and what to decide next.

---

### What works well

**1. The diagnosis is correct and load-bearing**

The fidelity gate answers *corruption*, not *house style*. That matches the engine: `math_dirt` keys on Unicode math glyphs outside `$…$`; plain `O(s log n)` stays `faithful` because nothing was damaged. Treating this as an enrichment question rather than a gate recall hole is the right architectural move — and it avoids the brittle-rule trap the brief documents clearly.

**2. Wrap vs reconstruct is the moral center**

The strongest section. Wrapping ambiguous spans (`n s`) launders uncertainty into false authority; the `$ns$` vs `$n/s$` example is exactly the failure mode a high-recall auto-wrapper would introduce. Blocking reconstruction on OffsetMap is honest, not deferral for convenience.

**3. Precision/recall inversion is the key safety insight**

| Tier | Blocks? | Recall/precision trade |
|---|---|---|
| Fidelity | Yes — gates deliverables | High precision |
| Enrichment | No — only offers candidates | High recall, adjudicated |

That is why ASCII math belongs here and not in `CorruptionSignature`. Surfacer noise costs review time; it does not corrupt text.

**4. The probe grounds the sketch**

The 79% / 21% safe-wrap / lossy split is not pedantic — it means ~1 in 5 candidates would be *actively harmed* by naive wrapping. The subscript-loss finding (`F i+1` → `F_{i+1}`) is especially important: models would reconstruct confidently and wrong. Running on chunk substrate vs rendered `.md` is also a real implementation constraint, not an afterthought.

**5. Membrane-native shape**

Surface → adjudicate → `propose_edit` → `apply` reuses the existing dispatch/work pattern. Orthogonality to `flagged`/`pending`, idempotency via prose-region search, and explicit "Explicitly NOT" list all read as mature membrane thinking.

---

### Tensions to resolve (not flaws — open design work)

**1. Relationship to existing `unwrapped_math` / `needs_review`**

The membrane already routes Unicode-dense unwrapped math through `needs_review` + `unwrapped_math` when `math_dirt ≥ 2`. Enrichment targets the *complement*: ASCII that passed `faithful`.

The brief states orthogonality clearly, but a short explicit mapping would help implementers:

```
faithful + math_dirt < 2 + ASCII math position  →  enrichment candidate
needs_review + unwrapped_math                   →  repair path (existing)
suspect + corruption signature                  →  repair path (existing)
lossy adjacency                                 →  escalate (neither tier wraps)
```

Without that table, someone may try to fold enrichment into the fidelity playbook.

**2. Playbook overlap**

`playbook.ps1` already says for `unwrapped_math`: *"wrap each span in `$...$`"*. Enrichment is philosophically different (optional polish post-`finalize`), but the *action* is identical for safe-wrap cases. Worth one sentence: enrichment does not add a new issue type; it is a post-fidelity surfacing mode whose proposals still go through `propose_edit`.

**3. Adjudicator authority — human or auto-apply?**

The brief says proposals go through `propose_edit → apply` (audited diff). It does not say whether adjudicated safe-wraps are:

- auto-applied at high confidence, or
- always held for human review.

Given the 10–15% junk still in the safe-wrap bucket, I'd lean **human review for v1**, with precision metrics driving surfacer tightening before any auto-apply. Worth stating explicitly in guardrails.

**4. Stop condition is underspecified**

"No natural `flagged == 0`" is true. Candidates:

- per-paper opt-in ("enrich this run"),
- surfacer returns zero candidates,
- sampled precision threshold on adjudication.

The brief lists these as open questions; the stop condition is the one that will bite in batch runs. I'd pick **opt-in per run** for v1 and defer threshold-based termination.

**5. Normalization scope**

`R^n → \mathbb{R}^n` is called enrichment (good — conventional reading, no destroyed glyph). But `\log` vs `log`, `poly(n)` vs `\mathrm{poly}(n)`, etc. are judgment calls the adjudicator must bound. A one-line scope cap — *symbol upgrades only where the ASCII token has a single standard LaTeX form* — would prevent enrichment from becoming a mini-typesetter.

---

### Minor gaps (fine for a sketch; note before implementation)

| Gap | Suggestion |
|---|---|
| No API sketch | `get_enrichables`, `enrich` dispatch mode, `enrichable` count in `get_summary` |
| No test hook | One Pester: surfacer idempotent on already-wrapped math; lossy bucket never emits `propose_edit` |
| Track-1 agent split | Good pairing with repair agent; could name the hard constraint prompt line: *classify + wrap only; never emit reconstructed glyphs* |
| Citation noise | Probe found this on `.md`; chunk substrate fixes it — worth elevating to a **requirement**, not a probe observation |

---

### Verdict

**Ready as a design sketch.** The core thesis is sound:

> Under-markup is not corruption. Wrap the unambiguous; escalate the lossy; never reconstruct from the chunk alone.

The probe validates that the wrap/reconstruct split is load-bearing (21% lossy), not academic. The membrane-upgrade-plan gap entry (*"Designed, not built"*) is accurately characterized.

**Recommended next steps** (if you want to move from sketch → spec):

1. Add the fidelity/enrichment/repair routing table (three lines).
2. Decide v1 review policy: all safe-wraps human-reviewed vs auto-apply above threshold.
3. Draft minimal API: `get_enrichables` on chunk stream post-`finalize`, separate from `dispatch`.
4. Port the probe surfacer from `.md` to per-chunk `content_raw` and re-run — confirm the 79/21 ratio holds on substrate.

---

What would you like to do with this — tighten the brief in place, draft the API section, or run the chunk-substrate probe first?