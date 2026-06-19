# codex-membrane — implementation plan

Companion to [`agentic-membrane-architecture.md`](agentic-membrane-architecture.md) (design frame) and
[`doccer-membrane-integration.md`](doccer-membrane-integration.md) (doccer phase-1 borrowings). Reconciled
against the **live 21-tool** [`src/mcp-server.ps1`](../src/mcp-server.ps1) server — not the 6-tool prototype
the architecture doc describes.

*Status — 2026-06-17: the **pincer policy layer is complete**. This doc is the single forward plan: what
landed, what's next, and the discipline that carries.*

Per-feature design briefs: [`mask-algebra-fidelity-brief.md`](mask-algebra-fidelity-brief.md),
[`pincer-policy-brief.md`](pincer-policy-brief.md), [`composite-work-orders-brief.md`](composite-work-orders-brief.md),
[`math-hotspots-brief.md`](math-hotspots-brief.md).

---

## Re-layering — the stack (complete)

The mask algebra ([`mask-algebra-fidelity-brief.md`](mask-algebra-fidelity-brief.md)) is the **substrate**;
policy readouts stack on top. All layers below **Forward work** are **LANDED** — do not re-do.

| Layer | What | Where |
|---|---|---|
| **Infrastructure** | 21 tools, leasing, structural ops, `propose_edit`, finalize/review, escalation | `mcp-server.ps1`, `serving.ps1`, `restructure.ps1` |
| **Track 1 — Prompts** | `restoration_procedure` serves `PROCEDURE.md` | `mcp-server.ps1` (`prompts/list`, `prompts/get`) |
| **Substrate** | `masks.ps1` + 4 mask-algebra detectors; shared `latex.ps1` home; pincer coincidence law | [`mask-algebra-fidelity-report.md`](../.claude/mask-algebra-fidelity-report.md) |
| **Track 2 — Hotspots** | `Group-MathHotspots` — fragmented-formula span grouping | `serving.ps1` |
| **Spine — difference DISPATCHES** | `Get-ChunkIssues` → `Group-Deliverables` → `playbook.ps1` → `New-WorkOrder` on `get_slice` | `fidelity.ps1`, `serving.ps1`, `playbook.ps1` |
| **Part A — agreement RANKS** | `Get-AgreementScore` + stable-sort dispatch (ranks, never gates) | `fidelity.ps1`, `serving.ps1` |
| **Part B — contradiction GATES** | Geometry impossibilities + merge/split *worsens* guards (same residual metric as hotspots) | `fidelity.ps1`, `restructure.ps1` |

**Part B gate (as shipped):**

- **All structural ops** — geometry only via `Get-StructuralImpossibility`: `alignment_outside_env`, `prose_in_formula`.
- **Merge** — reject only when `joinRes > sumPartsRes` (partial-balance hotspot merges pass; worker closes seam after).
- **Split** — reject only when the cut **worsens** balance vs the original (clean split of already-unbalanced chunk allowed).
- **Retype** — unbalanced content allowed; content path + `apply` gate fix it after.
- **One table** — `$script:CorruptionSignatures`; no fork. **`apply`'s content gate unchanged.**

**Validation:** 147 Pester tests green (corpus differential A/B live on 1,522 chunks where preprocessed).

**Retired:** `inventory.jsonl` as a validation matrix (validation is intrinsic via algebraic laws + pincer).

---

## Forward work (prioritized)

1. **Localized spans — LANDED.** Work-order issues carry `{type, spans, diagnostic}` —
   half-open `[start,end)` UTF-16 offsets as repair hints (not sub work-units). `Get-IssueSpans` localizes
   every inventory kind via the same geometry as each signature's Test predicate: mask difference for
   `unwrapped_math` / `alignment_outside_env` / `prose_in_formula`; regex/char hits for ligature /
   replacement / intertext; shatter-run for gibberish; seam anchor for unbalanced delimiters; whole-chunk
   for `heading_level_unknown`. Flows through `Get-ChunkIssues` → `New-WorkOrder` → `get_slice`. Pairs
   with #2/#3 on the shared inline-math mask.

2. **Agreement math-pair refinement — LANDED.** Prose branch of `Get-AgreementScore` subtracts
   `Get-InlineMathMask` before the math-pair IoU so legit inline-math prose scores 1; unwrapped math
   outside `$…$` still disputes. Does not touch frozen `math_dirt`.

3. **`math_dirt` prose-context refinement — LANDED.** `Get-MathDirt` =
   `Density(MathLatexRx, Sub(Complement($…$), prose_context))` via `Get-ProseContextMask` (Greek-hyphen
   compounds, numeric unit suffixes, disjunctive `α and β` mentions). `Get-UnwrappedMathSpans` shares
   `Get-MathDirtResidualMask`. Hotspots / fidelity still gate on `math_dirt ≥ 2` (field recomputed at
   normalize). Corpus stored values match legacy until re-normalize.

4. **`Test-MathRow` consolidation — LANDED.** `Test-MathRow` removed; `Get-UnbledFormula` calls
   `Test-IsMath -Level Row` (adds `\text{...}` interior to the prose region for row breaks). Chunk-level
   `Test-IsMath` / fidelity `prose_in_formula` unchanged. One home in `latex.ps1`.

5. **Playbook-as-data: single-source**. The data table (`playbook.ps1`) is **already complete** — all **10**
   issue types have recipes. `PROCEDURE.md`'s prose playbook covers only **6** of 10, making it the laggard
   and the drift surface. Single-source: cut the prose list to a pointer + one worked example, and lock the
   coverage invariant with a Pester test (`RepairPlaybook.Keys ⊇ emittable issue types`). Low risk.

6. **Split-guard regression tests — LANDED.** Clean split of an already-unbalanced chunk passes (imbalance
   falls in one half, doesn't worsen); orphaning split still rejects.

7. **`gibberish` `MinRun` re-calibration**. `Test-IsGibberish MinRun=4` is calibrated on the 3 preprocessed
   docs; re-validate (re-run the corpus A/B) when the other docs get a chunk stream. Data-dependent.

8. **Deferred tail (long-horizon)** — see §Deferred substrate below.

### Sequencing

**#5** playbook de-duplication is the next independent low-risk cleanup. #7 data-dependent; #8 is the tail.

### Discipline (carries to all forward work)

Frozen single-type gate · body-light dispatch · chunk-level deliverable granularity · reuse the shared table
/ `masks.ps1` (no fork, no drift) · codepoint safety (UTF-8-no-BOM, surrogate-safe offsets) · no rule-engine ·
lazy / no sidecars · behavior-preserving-or-better, guarded by the differential A/B + the 147-test suite.

---

## Still narrow / not built (gap map)

| Item | State |
|---|---|
| **Suppression masks** generalized | **Partial** — `$…$` + prose-context overlay on `math_dirt`; not yet generalized beyond un-wrapped-math |
| **OffsetMap** / byte-exact source coords | **Seeded** — substrate primitives `Move-Mask`/`Limit-Mask` already exist in `masks.ps1`; the full coordinate transform is not built, but it is not greenfield |
| **Hooks** (batch governor) + **constitution** prose | **Working prototype — advisory, uninstalled** — 4-rule `contract.json` + Claude adapter (`compile.ps1`/`evaluate.ps1`) at `.claude/governance/`, every rule `mode: advisory`; not yet installed into any harness |

---

## Deferred substrate (long-horizon)

- **OffsetMap** — byte-exact source coords; seeded by `masks.ps1` `Move-Mask`/`Limit-Mask` (the change-of-basis);
  lets `propose_edit` anchor against source, not finalized output. Revisit after localized spans sharpen the
  dispatch surface.
- **Hooks (batch governor) + constitution prose** — Layer-2 governance (reach-past defense + orchestrator↔worker
  compact). Pairs with a future Track-1 split into role-scoped prompts.
- **`inventory.jsonl`** — stays **retired** as a validation matrix; optional low-value overlay catalogue only.

---

## Provenance

Seeded by the doccer threads — [`gemini-doccer-discussion.md`](gemini-doccer-discussion.md),
[`cursor-doccer-concepts-interation.md`](cursor-doccer-concepts-interation.md),
[`doccer-membrane-integration.md`](doccer-membrane-integration.md) — and
[`gemini-mcp-feedback.md`](gemini-mcp-feedback.md). doccer (spcx Phase 0) remains the substrate to keep
mining; this plan lifts its *calculus* (cross-derivation, density, impossibility) into the membrane's
fidelity/dispatch layer and nothing below it.
