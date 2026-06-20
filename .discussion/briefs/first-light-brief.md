# First Light — mission-revival brief

Companion to [`membrane-upgrade-plan.md`](membrane-upgrade-plan.md). Where that doc is the *feature* ledger
(what landed in the re-layering), this is the *operations* brief: how the membrane gets pointed at a real
balrog and proves it carries one document end-to-end **to satisfaction** before any batch runs.

*Status — 2026-06-18: the re-layering is complete and the suit is idle. The plateau ends here — not by
adding another layer, but by taking a single hard document all the way to a finished artifact you trust.*

> **First light** (telescope sense): the instrument's first real image of the sky, after the mirror is
> ground and the mount is built. The membrane's mirror is ground. This is its first light on a balrog.


## Phases

### Phase 0 — Stop the map from lying (do first; ~minutes)

The deflation is coming from the document, not the code. Reconcile
[`membrane-upgrade-plan.md`](membrane-upgrade-plan.md) so it reports reality back honestly:

- **Governance** in the gap map: `Absent — Layer 2 deferred` → **`working prototype — advisory, uninstalled`**
  (it exists at [`.claude/governance/`](../.claude/governance/): a 4-rule `contract.json` + Claude
  `compile.ps1`/`evaluate.ps1` adapter, every rule `mode: advisory`).
- **OffsetMap** in Deferred substrate: note its substrate primitives `Move-Mask` / `Limit-Mask` **already
  exist** in `masks.ps1` — it is seeded, not greenfield.
- **#5** reframed (see Phase 1): the data table is already complete; the prose is the laggard.

### Phase 1 — Pre-flight: single-source the recipe layer (#5, done correctly)

The do Carmo run will pound the `work_order` recipe path harder than anything has. Single-source it *before*
you trust the output, and aim it at the invariant that actually bites — not the one the plan's wording
implies.

- **Don't** write four more prose bullets in PROCEDURE.md to match the data. The data table
  (`src/playbook.ps1`) already covers all **10** issue types; PROCEDURE.md's per-type list covers only **6**.
  Growing the prose to 10 just enlarges the drift surface.
- **Do** cut PROCEDURE.md's "repair playbook — by `corruption_type`" list to a short pointer + one worked
  example (`intertext`), stating the recipe is delivered inline in the `work_order`, pooled from
  `playbook.ps1`. The work-order now always carries the recipe (localized-spans, #1), so the prose list's
  *fallback* role is already obsolete.
- **Lock the real invariant** with one Pester test: `$script:RepairPlaybook.Keys` must cover **every issue
  type the membrane can emit** — the 7 in `$script:CorruptionSignatures` + the 2 synthetic
  (`heading_level_unknown`, `unwrapped_math`) + `fragmented_formula` (the hotspot span kind) = 10. This makes
  it impossible to add a new corruption signature without a paired recipe, which is the drift that would
  actually hand a worker an issue with no instructions.

### Phase 2 — Wake governance for the run (advisory only)

Governance instruments a *workload*. With the corpus at rest there's nothing to measure; the do Carmo run is
the ideal first workload. Install the **advisory** hooks for the run only:

```
pwsh -NoProfile -File .claude/governance/adapters/claude/compile.ps1
# merge the printed hooks block into .claude/settings.json (project-scoped)
```

- Every rule stays `mode: advisory` — logs the fire and nudges, blocks nothing. Zero risk to the workflow
  (the `no-shell-out` rule would otherwise fire on legit `mcp-server.ps1` self-tests; advisory keeps that
  clear).
- The instrument is `logs/fires.jsonl`. The run fills it with a real per-rule fire-rate.
- **Cost to weigh:** each matched tool call spawns `pwsh -NoProfile` (~150–300 ms). Acceptable for one
  dogfooding run; if it bites, a persistent evaluator is the later move. Uninstall after the run if you don't
  want the latency on subsequent sessions.

### Phase 3 — First light: take `DoCormo2016` to satisfaction (the depth-1 loop)

1. `preprocess paper=DoCormo2016` — runs the seven-stage pipeline, lands the chunk stream in `.scratch/`,
   logs `preprocessed`.
2. `get_summary DoCormo2016` — title, zones, section count, flagged counts, remaining hotspots by type. First
   real look at the balrog's shape. **Do not** read the chunk stream directly (no-slurp).
3. Work the loop, holding nothing between units:
   - `get_hotspots DoCormo2016` (or `dispatch` for ordered pointers, even at depth 1, to get
     most-disputed-first) → the work-list.
   - `get_slice paper id` (or `id=lo to_id=hi` for a fragmented-formula span) → the unit **and** its
     `work_order` (structural-before-content, every issue + recipe).
   - **Restructure first** where the damage is structural — `merge_chunks` a shattered formula,
     `retype_chunk` a formula mistyped as prose, `split_chunk` a fused pair — then re-ground (ids change).
   - `propose_edit paper id find=… replace=…` until the unit reads `clean`. Send only diffs.
   - `apply DoCormo2016` per round — folds clean proposals, holds still-flagged.
4. `finalize DoCormo2016` → `review_document DoCormo2016` (the one sanctioned holistic read). Fix any
   still-flagged chunk it surfaces with `propose_edit`, then review again. Iterate until clean.
5. `mark_unrecoverable` / `request_review` sparingly, only where the export genuinely can't be recovered.

### Phase 4 — Harvest the run (the data-dependent loose ends close themselves)

- **#7 gibberish `MinRun`:** there's now a book-scale chunk stream. Re-run the corpus A/B and confirm or
  retune `Test-IsGibberish MinRun=4` against real textbook density (math-heavy rows are the false-positive
  risk).
- **Governance fire-rate:** read `logs/fires.jsonl` grouped by rule. A rule that stayed quiet (paving holds)
  is a candidate to flip to `mode: enforce` — tighten its `arg` glob first, one rule at a time.
- **New corruption types:** note anything the balrog surfaced that no signature catches. The Phase-1
  coverage test forces any new signature to ship with a paired recipe.

---

## Definition of done ("to my satisfaction")

The slice is finished when **all** of these hold for `DoCormo2016` — not before:

1. `get_summary` / `get_batch_summary`: `actionable == 0`, `handoff == 0`, `review_bytes == 0`, no remaining
   hotspots by type.
2. `finalize`: `pending == 0` — the deliverable is non-provisional, not "finalized but flagged."
3. `review_document`: returns **no still-flagged chunks**, and the assembled `{slug}.md` + references sidecar
   read correctly on spot-check — display math fenced and delimiter-balanced, theorem/lemma/proof blocks
   intact (not promoted to sections), TOC and reference sidecar correct, no figure debris in the body.
4. **Codepoint safety:** SMP math, ligatures, and any `U+FFFD` round-trip through the deliverable
   (UTF-8-no-BOM, surrogate-safe offsets) — verified, every change.
5. **Unrecoverable rate ≈ 0.** A high rate indicts the repair attempt, not the export.

Only when this gate is green do we talk about the batch of 23.

---

## Balrog hazards — what `DoCormo2016` throws that the three papers didn't

These are the reasons it's a *proof*, not just another item. Each is also a thing to watch break:

| Hazard | Why a textbook is worse | What it stresses |
|---|---|---|
| **Scale** | thousands of chunks, many pages | body-blind discipline, `.jidx` seek path, no-slurp at scale |
| **Display-math density** | curves & surfaces is formula-saturated | `fragmented_formula` spans, `unwrapped_math`, `alignment_outside_env` — first real exercise of the math-hotspot + work-order spine |
| **Theorem environments** | theorem/lemma/proof/definition everywhere | `Test-BlockLabel` → `is_block` (must stay blocks, not become sections) across a whole book |
| **Figures** | a geometry text is figure-dense | `figure_debris` discard path (`Test-InsideAny` in `collapse.ps1`) |
| **Heading depth** | chapter ▸ section ▸ subsection (deeper than a paper) | font-size leveler in `sections.ps1`; watch `level_uncertain` / `heading_level_unknown` rate |
| **Front/back-matter** | TOC, preface, index, bibliography | zone + reference detection tuned on paper shapes |

If the leveler or the reference detector behaves oddly at book scale, that's signal — a tuning task the
batch would have hit 23× over. Better to find it once, here.

---

## What this brief deliberately does NOT do

- **No OffsetMap, no enforce-mode teeth, no Track-1 prompt split.** Those are post-first-light. The point is
  to finish *one thing*, not to open new fronts.
- **No batch.** The 23 stay in their caves until the gate above is green.
- **No new ambition layer.** Reviving the mission means *closing* the open loop, not starting another.
