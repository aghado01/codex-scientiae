# Brief — pincer policy (agreement ranking + impossibility gate)

Implementer's brief for the **policy layer** — the merged Tracks 3+4 of
[`membrane-upgrade-plan.md`](membrane-upgrade-plan.md), now **unblocked** by the landed mask-algebra substrate
([`mask-algebra-fidelity-brief.md`](mask-algebra-fidelity-brief.md),
[report](../.claude/mask-algebra-fidelity-report.md)). Cold-handoff-ready.

**STEP 0 — ground in the substrate.** Read `src/masks.ps1` for the exact primitive surface (`New-Mask`,
`Complement-Mask`, `Sub-Mask`/`Intersect-Mask`/`Union-Mask`, `Get-MaskDensity`/`Get-MaskedText`,
`Split-AtLevel`, `Move-Mask`/`Limit-Mask`) and `tests/masks.Tests.ps1` for the laws they obey. This layer
**consumes** the algebra; it does not extend it. If you think you need a new primitive, escalate.

## Why — one pincer, two readouts

The algebra is the *mechanism*; this is *policy*. The pincer — two independent derivations rendered as masks,
compared for coincidence — has two readouts, and Tracks 3 and 4 are exactly those:

- **Agreement** (continuous) → **ranks** dispatch. Spend the agent's most expensive resource, budget, on the
  most-disputed work first — not on single-regex false positives.
- **Contradiction** (boolean) → **gates** mutation. Reject structurally-impossible edits before the ledger.

Both are thin wiring over `masks.ps1`; the substance already lives in the algebra. **Agreement ranks,
contradiction gates** — never the reverse (a low score must not gate; an impossibility must not merely
deprioritise). Build the shared **derivation→mask + coincidence** helper once; A and B are its two uses.

## Part A — agreement-score dispatch ranking (was Track 3)

**Goal.** Order the dispatch work-list by structural ambiguity (lowest agreement first) so budget targets
genuinely uncertain regions.

**Mechanism.** For each chunk, take ≥2 independent derivations of the same property, each rendered as a
`Mask`, and compute `agreement` ∈ [0,1] as the **mask IoU (Jaccard)** —
`Get-MaskDensity(Intersect(A,B)) / Get-MaskDensity(Union(A,B))`, defined as `1` when the union is empty (both
derivations agree there is nothing). Compose existing set-ops; add no primitive. Derivation pairs (each → a
mask), used where the chunk type makes them apply:
- **heading** — typography-derived (font/size in `nodes`) vs markup-derived (`section_level` / `#` atom).
- **math** — math-by-content (`Test-IsMath`'s math-structure overlay) vs math-by-label (`type == 'formula'`).
- **closure** — per-chunk `Get-LatexBalance` vs the pincer top-down/bottom-up coincidence (the substrate's
  tested law).
`agreement_score` = `min` over the applicable pairs (the most-disputed derivation dominates).

**Where it's computed.** At **fidelity time** (in preprocess, where `nodes` typography is in hand), stored as
a per-chunk field exactly like `math_dirt` — and **recomputed on every re-grade**, so it cannot go stale under
`split`/`merge` renumbering (it is a chunk field, not a persisted sidecar).

**Surfacing.** `Invoke-Dispatch` orders candidates by ascending `agreement` within the byte budget — a
**stable** sort, so dispatch/lease/re-ground stay reproducible. `get_hotspots`/`get_batch_summary` expose it;
additive pointer field `agreement: 0–1`.

**Invariant.** It **ranks, never gates** — the work-SET and the merge-gate are unchanged; only the ORDER
moves.

**Files.** `fidelity.ps1` (derive the masks + compute/store `agreement`), `serving.ps1` (`Invoke-Dispatch`
ordering + surface in `Get-IrHotspots`/`Get-BatchSummary`), `mcp-server.ps1` (doc note). Reuses `masks.ps1`.

## Part B — impossibility gate (was Track 4)

**Goal.** Reject LLM-hallucinated structure at the mutation path before it enters the ledger.

**Mechanism.** A small **declared** set of impossibility predicates — each a mask-geometry query over the
would-be post-mutation content, reusing the ported detectors:
- `alignment_outside_env` — bare-`&` mask ∩ `Complement(env overlay)` non-empty (the ported detector, now a
  gate).
- `prose_in_formula` — a chunk retyped to `formula` whose prose-density-in-complement exceeds threshold.
- `unbalanced_after_op` — a `retype→formula` or `merge` result that fails `Get-LatexBalance.full`.
- (extensible a line or two each — e.g. a heading chunk cannot hold a blank-line run.)

**Wiring.** Gate `retype_chunk` / `split_chunk` / `merge_chunks` (in `restructure.ps1`) and `apply` (in
`serving.ps1`): evaluate the predicates on the would-be result; if any fires, **reject with a precise
diagnostic** — the exact shape `propose_repair` already returns on the delimiter detector — and do not mutate.

**Invariant.** Reject-with-diagnostic, never silently mutate or fix. The impossibility checks are
**additional** rejections layered on the existing `Get-CorruptionType` gate, not a replacement.

**Files.** `latex.ps1`/`fidelity.ps1` (impossibility predicates as mask-geometry, reusing the ported
detectors), `restructure.ps1` (gate the structural tools), `serving.ps1` (extend the `apply` gate),
`mcp-server.ps1` (error-shape doc only).

## Compatibility — the delicate mechanics still apply

Part A is additive/non-gating, so it cannot move accept/reject — but it MUST be **deterministic** (stable
sort; same input → same order) and a **recomputed chunk field** (never a stale sidecar). Part B touches the
**highest-risk seam** (the mutation path); it must:
- **Reject, never silently fix or drop** (like `propose_repair`); the agent retries.
- **Not reject anything valid the current flow accepts** — especially the **fragmented-formula `merge_chunks`**
  that Track 2's hotspot repair depends on (a legitimate join balances, so it passes — verify explicitly).
- **Compose with the existing `apply` gate** — a chunk that passes content-corruption but creates a structural
  impossibility must still be caught; one that passes both still merges.
- **Reuse the already-ported detectors** as the predicates — do not fork a second definition (the
  cross-derivation-consistency rule the substrate just enforced; don't reopen the drift).

## Validation (intrinsic + differential, the house standard)

- **Agreement** — synthetic: a unit whose two derivations disagree ranks above one where they agree; ordering
  is deterministic (same input → same order); the dispatch work-SET is unchanged by ranking (order only).
- **Impossibility** — synthetic mutations that create each impossibility are rejected with the right
  diagnostic; legitimate mutations (incl. a fragmented-formula `merge_chunks`) pass; the `apply` gate still
  catches content corruption (no regression).
- **Differential** over the corpus — dispatch order shifts toward known-ambiguous regions while the SET is
  identical; `apply` accept/reject = old + the new impossibility rejections only (zero spurious rejections).
- Pin each as Pester `It`s under `tests/` (extend the suite the substrate added).

## Non-goals (carry the fence)

- **No general declarative rule-table runner** — the impossibility set is a handful of hard-coded
  mask-geometry predicates.
- **No new detection heuristics** — combine existing derivations/signals; don't invent more.
- **No persisted scores or sidecars** (`agreement` is a recomputed chunk field, like `math_dirt`).
- The score **ranks**; gating is **only** the declared impossibilities.
- **Don't touch `masks.ps1`** — consume the substrate.

## Lands here too (from the substrate's deferred list)

- **Prose-context refinement of `math_dirt`** — the deferred `Sub` of a prose-context overlay (`α-helix`, unit
  glyphs, isolated symbols). It moves the frozen `math_dirt` value, so it belongs in a layer that updates the
  hotspot consumers in lockstep + re-verifies — *this* one. Bundle with Part A (both touch the dispatch
  surface).
- **`Test-MathRow`** consolidation is *related* (another "is-this-math" derivation the agreement layer wants
  consistent), but it lives in the un-bleed subsystem — keep it a separate cleanup unless it's cheap to fold
  while you're already in `Test-IsMath`.

## Sequencing within the layer

Build the shared **derivation→mask + coincidence** helper first (the common substrate of both readouts). Then
**Part A** (additive, non-gating, immediate budget value, lowest risk), then **Part B** (mutation-path gating,
with the compatibility checks above). The `math_dirt` prose-context refinement rides with Part A.
