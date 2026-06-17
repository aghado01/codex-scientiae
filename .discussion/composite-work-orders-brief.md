# Brief — composite work-orders: inventory → group by deliverable → resolve

The third pincer readout (**difference dispatches**), generalized past the worked example into a dispatch
spine. Companion to [`pincer-policy-brief.md`](pincer-policy-brief.md) (agreement/impossibility — the other
two readouts), [`mask-algebra-fidelity-brief.md`](mask-algebra-fidelity-brief.md) (the substrate), and
[`membrane-upgrade-plan.md`](membrane-upgrade-plan.md) (which this re-scopes — see §Trajectory).

## The general shape (the mechanism is issue-agnostic)

Not "fix ligatures and un-wrapped math together." The mechanism:

1. **Inventory** — collect *every* flagged problem in a document as a localized record `{type, spans,
   diagnostic, confidence}`. All issues, not the first that fires; located by mask, not just named.
2. **Group by deliverable** — bucket the issues by the unit that actually ships clean: a chunk (default), a
   hotspot **span** (a multi-chunk deliverable), later a section. The deliverable is the grouping key.
3. **Compose** — assemble one **work-order** per deliverable: the pooled issues + their spans + the relevant
   repair-recipe fragments, ordered and written into a single prompt.
4. **Resolve / reconcile** — the worker addresses the whole order in one pass; `apply` re-grades; the
   deliverable converges when its issues clear and it ships.

It is a *work-order assembly engine keyed on the deliverable, fed by whatever detectors fire.* The ligature +
un-wrapped-math paragraph is one instance. So are: `unbalanced_delimiters` + a gibberish tail; un-wrapped math
+ a `U+FFFD`; `heading_level_unknown` + ligature residue; a fragmented-formula **span** whose member chunks
each carry their own corruption. The engine doesn't know or care which issues — it inventories, groups,
composes, resolves.

## Trajectory & re-scoping (why this re-centers the plan — recursively)

This is the **third** time the roadmap has re-layered, and the pattern is worth naming: each layer became
visible only once the one beneath it existed.
1. Linear ladder (Tracks 1→4).
2. The **mask algebra** surfaced as the *substrate* the policy tracks sit on (re-layer #1).
3. Now the **issue-inventory work-order** surfaces as the *spine* the policy tracks are facets of (re-layer
   #2) — and it reveals that what we built as discrete features are its components:

| Prior piece | Re-read as |
|---|---|
| **Hotspots** (Track 2) | the *first* deliverable-grouping rule — fragmented chunks → one span work-order. A special case of "group issues by deliverable." |
| **Mask-algebra detectors** | the *issue sources* feeding the inventory; the mask difference *localizes* each issue's spans. |
| **Agreement** (Part A) | *ranks the work-orders* — which deliverable first. |
| **Impossibility gate** (Part B) | *gates the worker's output* — orthogonal, still coexists, checks edits the work-order produced. |

So the pincer has three readouts and they are not peers: **agreement ranks, contradiction gates, difference
dispatches** — and *difference-dispatch is the spine the other two hang on.* The plan's "Policy (merged
Tracks 3+4)" should be re-read as **"operate on the issue-inventory"**, with rank / gate / dispatch its three
operations.

**Concrete re-plan consequences** (to fold into the plan once agreed):
- **The dispatch model changes**, not just gains a feature: single-type `Get-CorruptionType`-as-the-work-spec
  → a **multi-issue inventory** for dispatch. (The single-type gate stays frozen for accept/reject — the
  inventory is the *dispatch* derivation, additive, like `agreement`/`math_dirt`.)
- **Playbook-as-data re-appears.** The plan *retired* `inventory.jsonl` as a *validation matrix* — that stands.
  But the composer needs the **repair recipes** as composable fragments (a different data-fication: recipes,
  not detection patterns). `PROCEDURE.md`'s prose playbook stays the frame/fallback; a `{type → fragment}`
  map is its machine-readable sibling.
- **OffsetMap relevance rises again** — localized issue spans want stable coordinates across the
  source/finalized basis; `Move-Mask`/`Limit-Mask` already seed it.
- **Hotspots is no longer a track, it's a rule** — one entry in the deliverable-grouping logic, optionally
  re-expressed on the inventory later (not urgent).

## The pieces (mechanism spec)

1. **Issue inventory** — `Get-ChunkIssues($chunk) → [{type, spans, diagnostic, confidence}]`: run *all* the
   ported detectors, each returning its localized spans (the mask difference), not a first-match single type.
   **Separate from** the frozen single-type `Get-CorruptionType` gate — additive, computed at fidelity time
   and recomputed on re-grade, like `agreement`. The gate's accept/reject is untouched.
2. **Deliverable grouping** — bucket issues by deliverable. Default = the chunk; a hotspot span (reuse
   `Group-MathHotspots`) is a multi-chunk deliverable that pools its members' issues. Deterministic, lazy.
3. **Playbook-as-data** — a `{corruption_type → recipe fragment}` map, mirroring `PROCEDURE.md`'s playbook
   entries incrementally. The composer pulls only the fragments for the issues present.
4. **Composition** — server-side (in `dispatch`, or a `get_task` that returns slice + work-order),
   **ordered** (structural issues — retype/split/merge — before content, per the existing "restructure first"
   rule), **body-light** (recipes + spans + diagnostics, never the chunk body), pooled into one prompt per
   deliverable. Lean on `apply`'s re-grade for issue *interactions* rather than over-sequencing one prompt.
5. **Resolve / reconcile** — the worker `get_slice`s and works the whole order; `apply` re-grades; converged
   when the deliverable's issues are cleared.

## Discipline / non-goals (this is big — keep it fenced)

- **Frozen single-type gate.** `Get-CorruptionType` stays the merge-gate; the inventory is a separate,
  additive *dispatch* derivation. Never let the multi-issue profile move an accept/reject.
- **Deliverable-granularity.** Pool *within* a deliverable; do **not** fragment into per-span sub-units — the
  chunk-level work-unit, leasing, and `apply` model stay intact (the granularity discipline already agreed).
- **Body-light.** Work-orders carry diagnostics + recipes + spans, never content; the worker still slices its
  own body. The body-blind contract holds.
- **Incremental playbook-as-data.** Mirror `PROCEDURE.md`; do not rewrite the workflow. The prose procedure
  remains the frame and the fallback for anything not in the map.
- **No rule-engine.** The composer is a small ordered pool over a fixed recipe map — *not* a declarative
  rule-table runner (the standing fence; the same one that retired the validation-matrix).
- **Precision-gated.** Pool *confirmed* issues only — this is exactly what the mask-algebra hardening bought;
  a composite of low-confidence noise is worse than a single high-confidence flag.
- **Lazy, no work-order sidecars** — deliverables and ids renumber under split/merge; assemble at dispatch
  time.

## Worked examples (deliberately several, to resist over-fitting)

- **ligature + un-wrapped math** (paragraph) — substitute `ﬁ→fi` at [Y]; wrap math at [X]. One pass.
- **unbalanced_delimiters + gibberish tail** — close the seam (the `seam` diagnostic) *and* excise/repair the
  shattered tail; structural-aware ordering matters.
- **heading_level_unknown + ligature** — a structural *judgement* (place the level) pooled with a mechanical
  substitution; different recipe registers in one order.
- **fragmented-formula span** (deliverable = the span) — the work-order spans member chunks, pooling each
  member's own issues with the merge instruction. Hotspots-as-a-grouping, made general.

## Validation (house standard)

- **Inventory**: a chunk with N issues yields all N localized records; the gate still returns its single type,
  unchanged (frozen contract).
- **Grouping**: issues bucket to the right deliverable; a span deliverable pools its members' issues.
- **Composition**: the order pools the right recipes, structural-before-content, body-light (no content
  leaks).
- **Resolve**: a multi-issue chunk converges in one work-order vs N re-dispatches; `apply` re-grades clean.
- **Differential**: the dispatched deliverable SET is unchanged; the composite is additive enrichment, not a
  new work-set. Pin as Pester `It`s extending `tests/`.

## Sequencing / relationship to A and B

Build the **spine** first: the issue-inventory + a minimal recipe map + the composer + the work-order in the
dispatch/`get_task` surface — proven on a genuinely multi-issue chunk. The **difference-localization**
(un-wrapped-math spans, the deferred `math_dirt` work) becomes the first issue-source that emits *spans*, and
slots into the inventory. **Part A** ranks the resulting work-orders; **Part B** gates their outputs. So the
order is: inventory/compose spine → localized issue-sources feed it → A orders → B guards. The prose playbook
and the single-type gate stay standing throughout as frame and fallback.
