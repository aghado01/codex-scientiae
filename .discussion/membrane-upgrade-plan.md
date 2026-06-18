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

**Validation:** 122 Pester tests green (corpus differential A/B live on 1,522 chunks where preprocessed).

**Retired:** `inventory.jsonl` as a validation matrix (validation is intrinsic via algebraic laws + pincer).

---

## Forward work (prioritized)

1. **Localized spans — LANDED (MVP: `unwrapped_math`).** Work-order issues carry `{type, spans, diagnostic}` —
   half-open `[start,end)` UTF-16 offsets as repair hints (not sub work-units). `Get-UnwrappedMathSpans`
   unions `Sub(math-structure, inline-$…$)` with `MathLatexRx` glyphs outside wrapped spans; flows through
   `Get-ChunkIssues` → `New-WorkOrder` → `get_slice`. Other issue kinds carry empty `@()` spans until
   localized. Pairs with #2/#3 on the shared inline-math mask.

2. **Agreement math-pair refinement** *(safe, quick — do anytime)*. In `Get-AgreementScore`'s prose branch,
   `Sub` the inline-`$…$` mask before the IoU so legit inline-math prose scores 1, not 0 (today the math pair
   pins any prose-with-inline-math to max-dispute). *Scope:* one spot in `fidelity.ps1`; expose
   `Get-InlineMathMask` beside `Get-MathStructureMask` in `latex.ps1` (one home); add a test. Does **not**
   touch the frozen `math_dirt`. Low risk.

3. **`math_dirt` prose-context refinement** *(moves the frozen value — lockstep)*. Subtract a prose-context
   overlay (`α-helix`, unit glyphs, isolated symbols) from the `math_dirt` residual to cut false un-wrapped
   flags. *Scope:* `normalize.ps1`; **moves the frozen `math_dirt` value → MUST update the hotspot consumer
   (`Group-MathHotspots` `math_dirt ≥ 2`) in lockstep + re-verify the frozen-contract test.** Higher risk
   than #2; pairs with #1/#2.

4. **`Test-MathRow` consolidation**. Fold `Test-MathRow` (`normalize.ps1`, via `Get-UnbledFormula`) into the
   hardened `Test-IsMath` — the last un-consolidated "is-this-math" derivation, still on the old strip-list
   (the exact drift the effort set out to kill). Lives in the un-bleed/vocab subsystem; verify that path.

5. **Playbook-as-data: complete + de-duplicate**. Recipes live in **both** `PROCEDURE.md` (prose) and
   `playbook.ps1` (data) — a drift surface. Pick a single source (generate one from the other, or a check
   that they match) and fill any missing entries. Low risk.

6. **Split-guard regression tests** *(quick — do anytime)*. Add: a clean split of an already-unbalanced chunk
   **passes** (imbalance falls in one half, doesn't worsen); an orphaning split still **rejects**. The
   relative worsens guard is wired but the pass case is not yet unit-tested.

7. **`gibberish` `MinRun` re-calibration**. `Test-IsGibberish MinRun=4` is calibrated on the 3 preprocessed
   docs; re-validate (re-run the corpus A/B) when the other docs get a chunk stream. Data-dependent.

8. **Deferred tail (long-horizon)** — see §Deferred substrate below.

### Sequencing

#6 and #2 anytime. **#2 (agreement math-pair)** is the next mask refinement; pairs with localized spans.
#3 needs lockstep-with-hotspots discipline. #4/#5/#7 independent cleanups. #8 is the tail.

### Discipline (carries to all forward work)

Frozen single-type gate · body-light dispatch · chunk-level deliverable granularity · reuse the shared table
/ `masks.ps1` (no fork, no drift) · codepoint safety (UTF-8-no-BOM, surrogate-safe offsets) · no rule-engine ·
lazy / no sidecars · behavior-preserving-or-better, guarded by the differential A/B + the 122-test suite.

---

## Still narrow / not built (gap map)

| Item | State |
|---|---|
| **Suppression masks** generalized | **Narrow** — `normalize.ps1` masks `$…$` only for the `math_dirt` count |
| **OffsetMap** / byte-exact source coords | **Absent** — `propose_edit` anchors finalized output, not source |
| **Hooks** (batch governor) + **constitution** prose | **Absent** — Layer 2 deferred |

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
