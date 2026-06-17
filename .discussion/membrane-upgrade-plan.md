# codex-membrane upgrades — prioritized implementation plan

Companion to [`agentic-membrane-architecture.md`](agentic-membrane-architecture.md) (the design frame) and
[`doccer-membrane-integration.md`](doccer-membrane-integration.md) (the doccer borrowings that already
shipped). Those record the *frame* and *phase-1*; this is the *forward* cut — the sequenced build-list for
what the doccer threads + the MCP-feedback note still point at, reconciled against the **live 21-tool
server**, not the 6-tool prototype the design doc describes.

## Reconciliation — the design docs lag the code

`agentic-membrane-architecture.md` describes a 6-tool server with "leasing as the v2." Reality is well past
that: [`src/mcp-server.ps1`](../src/mcp-server.ps1) exposes **21 tools**; leasing is fully landed
([`serving.ps1`](../src/serving.ps1) `*.leases.json` + the `release` tool); `propose_edit` surgical diffs,
the structural ops (`retype`/`split`/`merge_chunks`), `finalize`/`review_document`, and escalation
(`request_review`/`mark_unrecoverable`) are all live. The doccer threads are therefore a **gap map**, not a
greenfield. What still hasn't landed:

| Upgrade | Source thread | State in code |
|---|---|---|
| **MCP Prompts** (serve `PROCEDURE.md`) | `gemini-mcp-feedback` #1 | **Absent** — `capabilities = @{ tools = @{} }`; PROCEDURE.md still says "until then" |
| **Math-density hotspots** (group fragmented formulae) | `gemini-doccer` #5, `cursor` #3 | **Absent** — dispatch hands arbitrary IR chunks; agent must `merge_chunks` by hand |
| **Agreement-score** dispatch ranking (Tier-2) | `doccer-membrane-integration` Parked #2 | **Predicates consolidated** (`latex.ps1`) but no score; dispatch ranks by bytes, not ambiguity |
| **Impossibility gate** (Tier-3) on structural ops + `apply` | `cursor` #4 | **Partial** — 2 checks live in `fidelity.ps1` as chunk grades, not as a mutation gate |
| **Suppression masks** generalized | `gemini-doccer` #4 | **Narrow** — `normalize.ps1` masks `$…$` only for the `math_dirt` count |
| **Pattern `inventory.jsonl`** (level/language as data) | `cursor` #2 | **Absent** — regex inline in `fidelity`/`zones` |
| **OffsetMap** / byte-exact source coords | `doccer-membrane-integration` Parked #1 | **Absent** — `propose_edit` anchors finalized output, not source |
| **Hooks** (batch governor) + **constitution** prose | architecture "NEXT" | **Absent** — Layer 2 deferred |

Leasing and predicate-consolidation from these threads **already shipped**. What remains splits into one
orthogonal quick win (Prompts) and a **doccer phase-2** — lift the consolidated predicates into a *scored,
density-aware, gated* dispatch surface — with a substrate tail deferred.

## Re-layering: the algebra is the substrate, not a rung

*Status — 2026-06-17: substrate LANDED; pincer Part A (agreement ranking) LANDED; the policy layer re-centred on the **issue-inventory spine** — re-layer #2, below.* The ladder below was conceived linearly
(1→2→3→4→tail); the mask algebra ([`mask-algebra-fidelity-brief.md`](mask-algebra-fidelity-brief.md)) inverts
that into a **stack**:

- **Done** — Track 1 (prompts), Track 2 (math hotspots — a pincer special-case in hindsight).
- **Substrate — LANDED & validated** ([report](../.claude/mask-algebra-fidelity-report.md)). `src/masks.ps1`
  (closed primitive set + `SpanLevel`) + four detectors re-expressed as overlay/complement behind the shared
  `latex.ps1` home + the pincer coincidence law. 52-test Pester suite green; the three compatibility contracts
  (merge-gate decision incl. the `detector∘normalize` fixed point, atomic three-consumer port, frozen
  `math_dirt`/balance) verified *as passing tests*; differential A/B 1518/1522 identical, the 4 deltas all
  genuine gibberish recall fixes. The delicate mechanics held; `masks.ps1` stayed lite (258 lines, pure).
- **Policy — operate on the issue-inventory (re-layer #2; the spine).** The merged Tracks 3+4 are not two
  bolt-on features but **three readouts of one pincer over a per-document issue-inventory**:
  - **difference DISPATCHES — the spine** ([`composite-work-orders-brief.md`](composite-work-orders-brief.md)):
    inventory every flagged problem → group by the **deliverable** that must ship clean (a chunk, or a hotspot
    span) → compose one **work-order** → resolve it whole. **NEXT.**
  - **agreement RANKS** the work-orders — Part A, **LANDED** ([`pincer-policy-brief.md`](pincer-policy-brief.md)).
  - **contradiction GATES** their outputs — Part B, queued (reject impossible edits; an output-guard *on* the
    work-order, so it folds in after the spine).
  Hotspots (Track 2) is re-read as the *first* deliverable-grouping rule; the mask detectors are the issue
  sources. The dispatch model shifts from single-type `Get-CorruptionType`-as-work-spec to the **multi-issue
  inventory** (the gate stays frozen for accept/reject), with a composable **playbook-as-data** map (recipes —
  a different data-fication than the retired validation patterns) feeding the composer. Built on the algebra.
- **Tail, re-sorted** — OffsetMap **promoted** (it is the change-of-basis for masks — shared offset
  arithmetic); `inventory.jsonl` **retired** as a validation matrix (validation is now intrinsic via algebraic
  laws + the pincer; only a low-value "overlay catalogue" survives); hooks + constitution unchanged.

**Carried follow-ups (pre-flagged in the report):**
- `Test-MathRow` (`normalize.ps1`, via `Get-UnbledFormula`) is the last un-consolidated "is-this-math"
  derivation — still the old strip-list, now diverging from the hardened `Test-IsMath`. Fold it in before it
  drifts (it is exactly the drift this effort set out to kill). **Top-priority cleanup.**
- `Test-IsGibberish` `MinRun=4` is calibrated on the 3 preprocessed docs — re-validate when the other 19 get
  a chunk stream.
- Prose-context refinement of `math_dirt` (subtract a prose-context overlay) was deferred because it moves the
  frozen value — it lands **with** the policy layer (update the hotspot consumers in lockstep + re-verify).

**Carried constraint (held):** the substrate stayed lite (258 lines, pure, no engine) and contract-preserving at the seams where rebuilt
detectors plug into the merge-gate, the three cross-derivation consumers, and the freshly-landed hotspot
signals — see the brief's *Compatibility* section. The non-goals fence now protects the whole downstream: if
the algebra sprawls, everything behind it stalls. (Tracks 3–4 below stand as detailed reference, read through
this policy lens.)

## The ladder

### Track 1 — MCP Prompts (serve the procedure) — opener, ~half day
- **Goal.** Deliver the architecture doc's "procedure as MCP prompts" Layer-2 item; close the "until then"
  gap in `PROCEDURE.md` so a connecting client injects the workflow into the agent's context automatically.
- **Mechanism.** Declare the `prompts` capability in `initialize`; add `prompts/list` + `prompts/get`
  handlers serving `PROCEDURE.md` as a `restoration_procedure` prompt (UTF-8, read from `$PSScriptRoot`).
- **Files.** [`src/mcp-server.ps1`](../src/mcp-server.ps1) only; header note in [`src/PROCEDURE.md`](../src/PROCEDURE.md).
- **Invariant.** stdout stays protocol-only; logs to stderr — unchanged.
- **Validation.** `initialize` advertises `prompts`; `prompts/list` returns the entry; `prompts/get` returns
  the procedure text without error; unknown name → `-32602`.
- **Refinement (later).** Split into role-scoped `orchestrator_procedure` / `worker_procedure` prompts;
  add `constitution` once Layer-2 prose lands. MVP serves the whole procedure as one prompt (depth-invariant,
  so one text is defensible).

### Track 2 — math-density hotspots — highest operational value
> Detailed design brief: [`math-hotspots-brief.md`](math-hotspots-brief.md).
- **Goal.** Stop wasting agent budget on Docling's layout seams: a block equation shattered across chunks is
  dispatched today as N arbitrary blind units. Surface the *semantic* repair unit instead.
- **Mechanism.** A derived **hotspot overlay**, not a destructive merge: in preprocess (or a post-pass),
  detect contiguous math-dense runs (doccer's `unicode.math_dense_region` + rolling density over the
  `math_dirt`/`Test-IsMath` signal) and register a hotspot span (id-range + density). `get_hotspots`/`dispatch`
  emit the span as one pointer; `get_slice` can return the whole range. Chunks stay atomic (IR fidelity
  preserved); grouping is advisory, and the agent still has `merge_chunks` to make it permanent.
- **Files.** [`src/preprocess.ps1`](../src/preprocess.ps1) (detect + register), `serving.ps1`
  (`Get-IrHotspots`/`Invoke-Dispatch` emit spans, `Get-Slice` accept a range), `mcp-server.ps1` (schema).
- **Invariant.** Body-blind dispatch — the span pointer carries id-range + density, never content.
- **First step.** Read `preprocess.ps1` + the `dispatch`/`get_slice` paths in `serving.ps1` before designing
  the overlay record shape.

### Track 3 — agreement-score dispatch ranking (Tier-2 cross-derivation)
> Substrate brief: [`mask-algebra-fidelity-brief.md`](mask-algebra-fidelity-brief.md) — the overlay/complement
> calculus that grounds both this score (agreement = pincer convergence) and Track 4 (contradiction = the
> impossibility gate). Do it before/with this track; the regex layer is hardened *by construction* there, not
> by a labeled corpus.
- **Goal.** Turn binary flags into a confidence so dispatch spends budget on genuinely ambiguous regions,
  not single-regex false positives. **Now built as the pincer's _agreement_ readout on `masks.ps1`** (the
  coincidence of two derivations' masks), not bespoke per-predicate scoring — the algebra has landed.
- **Mechanism.** Per chunk, run ≥2 independent derivations of the same property (heading-by-font vs
  heading-by-`#`-atom; math-by-content `Test-IsMath` vs math-by-delimiter; renders via `Get-LatexBalance`
  vs reads-as-prose). Disagreement → an `agreement_score` (0–1) on the chunk. `dispatch` orders low-agreement
  first within budget; `get_hotspots`/`get_batch_summary` expose it.
- **Files.** [`src/fidelity.ps1`](../src/fidelity.ps1) (compute the score from existing predicates),
  `serving.ps1` (dispatch ordering + surface), `mcp-server.ps1` (none, or a doc tweak).
- **Invariant.** The detector stays the merge-gate; the score *ranks*, it does not gate.

### Track 4 — impossibility gate (Tier-3) on the mutation path
- **Goal.** Reject LLM-hallucinated structure before it enters the ledger. The two impossibilities in
  `fidelity.ps1` grade chunks; they don't yet *gate* the tools that mutate structure.
- **Mechanism.** **Now the pincer's _contradiction_ readout — express impossibilities as mask-geometry
  predicates on `masks.ps1`** (complement-must-be-empty, masks-may-not-overlap). Seed: `alignment_outside_env`,
  `prose_in_formula`; add "retype→formula must pass `Get-LatexBalance`", "heading chunk cannot hold a
  blank-line run"). Wire as a rejection gate on `retype_chunk`/`split_chunk`/`merge_chunks` and on `apply`,
  returning a precise diagnostic — exactly as `propose_repair` already rejects on the delimiter detector.
- **Files.** `fidelity.ps1`/[`src/latex.ps1`](../src/latex.ps1) (predicates),
  [`src/restructure.ps1`](../src/restructure.ps1) (gate the structural tools), `serving.ps1` (gate `apply`).
- **Invariant.** Same shape as the existing propose-gate: reject with diagnostic, never silently mutate.

## Deferred substrate (design-in, don't build yet)

*Live status in §Re-layering: `inventory.jsonl` retired as a validation matrix; OffsetMap already seeded by `masks.ps1` `Move-Mask`/`Limit-Mask` (the change-of-basis).*

- **`inventory.jsonl`** — externalize the inline regex (`fidelity`/`zones`) to a `level`+`language`+`priority`
  data table. Auditable and composable, but a wide refactor for marginal near-term gain; Tracks 3–4 give the
  80/20 without it.
- **OffsetMap / byte-exact source coords** — would let `propose_edit` anchor against *source* markdown, not
  finalized output. Real workflow gain, larger coordinate-model change; revisit after the dispatch surface
  sharpens.
- **Hooks (batch governor)** — the non-cage per-agent budget+nudge; the architecture doc's residual
  "linear reach-past" defense. Belongs with the constitution.
- **Constitution prose** — Layer-2; the orchestrator↔worker compact. Pairs with the Track-1 prompt split.

## Sequencing rationale

*Live build order — see §Re-layering: substrate (done) → Part A agreement ranking (done) → the **issue-inventory spine** (NEXT) → Part B output-gate → tail. The original ladder rationale below is retained for the why of each piece.*

1 is orthogonal, safe, and unblocks Layer-2 — it ships first. 2 is where budget bleeds *today*, so it leads
the doccer phase-2. 3 reuses already-shipped predicates and sharpens the same dispatch surface 2 touched. 4
is guardrail wiring of checks that already exist. The substrate tail is bigger surface for lower marginal
value, so it waits.

## Provenance

Seeded by the doccer threads — [`gemini-doccer-discussion.md`](gemini-doccer-discussion.md),
[`cursor-doccer-concepts-interation.md`](cursor-doccer-concepts-interation.md),
[`doccer-membrane-integration.md`](doccer-membrane-integration.md) — and the server-implementation note
[`gemini-mcp-feedback.md`](gemini-mcp-feedback.md). doccer (spcx Phase 0) remains the substrate to keep
mining; this plan lifts its *calculus* (cross-derivation, density, impossibility) into the membrane's
fidelity/dispatch layer and nothing below it.
