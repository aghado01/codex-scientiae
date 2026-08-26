I'll start by grounding on the spec. Let me read the authoritative brief first, along with the key source files in parallel.

STEP 0 confirmed — the brief contains the "## The pieces (mechanism spec)" section (line 61). I'm on the correct tree. Now let me read the dispatch surface and the playbook.

The MCP server is now connected. Let me read the remaining key files: the MCP server surface, the latex predicates, and the test structure.

Now let me study the test conventions — particularly the agreement tests (the closest analog: an additive dispatch derivation) and the detector tests.

I have a thorough understanding of the mechanism. Let me skim the companion briefs and standards to align with conventions before designing.

I now have a thorough grounding. Let me set up task tracking, mark this work-phase, and check the corpus differential test (most sensitive to gate behavior) before I touch code.

The corpus test pins the frozen gate via an A/B differential (`typeChange`, `rejectToAccept`, `nonGibberishFlip` all must be 0) — so my refactor of `Get-CorruptionType` must be behavior-identical. Let me confirm the corpus fixtures are present (so I know whether those differentials run live) and set up task tracking.

All three corpus fixtures are present (1,522 chunks) — the frozen-gate differential runs live, my strongest guard. Let me track the work and start implementing.

Task 1 — the shared signature table, refactored frozen gate, and inventory in `fidelity.ps1`:

Codepoint-safety check (per my standing note) — verify the ligature class round-tripped intact after the edit:

I should use the PowerShell tool per project convention. Let me verify the codepoints there:

Ligatures intact (U+FB00..U+FB04). Quick smoke test of the refactored gate + new inventory before moving on:

Verified: the frozen gate returns clean, and the inventory surfaces **both** issues `[ligature_residue, unbalanced_delimiters]` in table order. Now Task 2 — the playbook-as-data map:

Task 2 done. Now Task 3 — the composer, grouping, and delivery in `serving.ps1`. First the dot-source for the playbook:

Now the composer section, inserted after `Group-MathHotspots`:

Now wire the work-order into `Get-Slice` — collect the slice, compose for the anchor, then stream:

Now add the lightweight `issues` profile to the two dispatch pointers (additive — only the `$item` gains a field):

Now a smoke test of the composer + grouping + dispatch on a synthetic multi-issue document:

Dot-source is clean. The earlier failure was in my test string itself — let me run it in smaller, simpler steps:

Group-Deliverables is correct (2 actionable deliverables, faithful excluded; the multi-issue chunk pooled both). Now verify the **structural-before-content reordering** and the **span/merge frame** + **body-light**:

All three checks pass:
- **(a)** composed order flipped to structural-first: `prose_in_formula → ligature_residue`
- **(b)** span deliverable leads with the merge frame: `fragmented_formula(id10) → unbalanced(id11) → ligature(id12) → unbalanced(id12)`
- **(c)** body-light: the real body token `frac` did **not** leak (the `right` hit is recipe vocabulary — "a dangling `\right`", not content).

For an unambiguous body-light test I'll use a sentinel token. Now I need to understand the `.jidx` index build to test `Get-Slice`. Let me read `jsonl.ps1`:

`Write-JsonlStage` builds the `.jidx`. Let me do one end-to-end `Get-Slice` check (chunk deliverable + span deliverable) before writing the formal tests:

Get-Slice works end-to-end: chunk slice carries a body-light `work_order` (issues=`[ligature_residue]`, no body leak, content still on the record); span slice leads with the merge frame. Task 3 complete. Now Task 4 — docs.

Now PROCEDURE.md — note the work-order in the worker loop, keeping the prose playbook as the frame/fallback:

Docs done. Task 5 — the spine tests. Let me write `tests/spine.Tests.ps1` covering all five validation categories from the brief:

Now run the spine tests alone first to catch issues before the full suite:

23/24 pass — including the corpus no-drift differential over all 1,522 chunks (zero drift, zero throws). The one failure is my test fixture: `\left( a` is correctly diagnosed as `lr=1` (the `\left(` is a sizing delimiter, not a bare paren). Let me fix the fixture to actually produce `paren=1`:

Now the full suite — the 73 existing tests must stay green plus my 24 spine tests:

All **97 tests pass (73 existing + 24 new), 0 failures, 0 skipped** — every corpus differential ran live. Let me confirm the final file set and mark the work complete.

Clean change set — `masks.ps1` untouched, four files modified, two added. Let me record one non-obvious design decision for future sessions, then report.

Implementation complete. All five pieces of the MVP spine are in, the full suite is green, and `masks.ps1` was not touched.

## What landed

**1 — Multi-issue inventory + shared signature table** ([src/fidelity.ps1](src/fidelity.ps1))
The seven per-signature checks now live in **one** ordered table, `$script:CorruptionSignatures` (each entry: `type` / `Test($type,$content)` / `Diag`). Both derivations read it:
- `Get-CorruptionType` — first-match → the **frozen** accept/reject gate, behavior-identical (refactored to iterate the table).
- `Get-ChunkIssues($chunk)` — **all-match** → `[{type, diagnostic}]`, the dispatch derivation. Folds in the two `needs_review` kinds (`heading_level_unknown`, `unwrapped_math`) using the same booleans `Invoke-Fidelity` uses. Computed **on demand**, never stored.

No-drift is mechanically proven: a corpus differential asserts `Get-CorruptionType == first inventory corruption-signature` for **all 1,522 corpus chunks** (zero drift, zero throws).

**2 — Deliverable grouping** ([src/serving.ps1](src/serving.ps1)) — `Group-Deliverables($chunks)` reuses `Group-MathHotspots` (the first grouping rule) with the exact same eligibility + span/skip bookkeeping as dispatch: default deliverable = the chunk; a fragmented-formula span = a multi-chunk deliverable pooling its members. Deterministic, lazy, no sidecar.

**3 — Playbook-as-data** ([src/playbook.ps1](src/playbook.ps1), new) — a flat `{type → {structural, fix}}` map mirroring `PROCEDURE.md`, with `Get-RepairRecipe`. One terse fix per type; the `structural` flag drives ordering. Not a rule-engine. The prose playbook stays the frame/fallback (noted in [PROCEDURE.md](src/PROCEDURE.md)).

**4 — Composer + delivery** ([src/serving.ps1](src/serving.ps1)) — `New-WorkOrder` pools issues (`Get-DeliverableIssues`), pairs each with its recipe, and orders **structural-before-content** via a stable sort on `-not structural` (retype/merge/level-placement first, then content; a span leads with its merge frame). **Body-light** by construction — recipes + diagnostics only, no body.
- **Delivery via `get_slice`** (not a new `get_task`): the anchor record carries `work_order`; pooling is over exactly the sliced records (a forward `id..to_id` range = the span deliverable), so no second full-document read — `get_slice` stays seek-light. I chose `get_slice` because it's the worker's natural "see it" step and adds no tool surface (tool count stays 21).
- The dispatch pointer gains an additive `issues:[types]` profile for routing; [mcp-server.ps1](src/mcp-server.ps1) docs both.

**5 — Resolve** — convergence test confirms a two-issue chunk clears in **one** work-order: a partial (gate-only) fix still trips `unbalanced_delimiters`; the combined fix stages clean and `apply` re-grades to faithful.

## Validation (97 tests, 0 failures, 0 skipped)
- **Inventory**: N issues → all N; gate unchanged on the same chunk; needs_review kinds pool with corruption signatures.
- **Grouping**: chunk vs span deliverables; span pools members' issues.
- **Composition**: pooled recipes, structural-before-content flip verified, body-light (sentinel-token + no `content` property), span leads with merge.
- **Differential**: dispatched deliverable **SET == `Group-Deliverables`** (additive, no new work-set); pointers stay body-light; Part A agreement ranking untouched (its suite still green); the corpus A/B gate-freeze test (`typeChange=0`, `rejectToAccept=0`, `nonGibberishFlip=0`) still green.

## Invariants held
Frozen gate · unchanged deliverable set · body-light · Part A ordering/leasing/budget/`Group-MathHotspots` all untouched · codepoint safety (ligature class verified `U+FB00..U+FB04`; UTF-8-no-BOM I/O) · no rule-engine · `masks.ps1` untouched.

## Deferred (as scoped — not built)
Per-issue **localized spans** (the `math_dirt` difference-localization — issues stay chunk-level) · the **full** playbook-as-data · **Part B** the impossibility output-gate · any new sub-chunk work-unit granularity.

**Changed:** `fidelity.ps1`, `serving.ps1`, `mcp-server.ps1`, `PROCEDURE.md`; **new:** `playbook.ps1`, `tests/spine.Tests.ps1`. Left unstaged for your commit. One project memory recorded the on-demand-vs-stored decision and the remaining deferred layers.

One pre-existing note I'll flag rather than touch: the plain dispatch pointer never emitted `corruption_type` (only `get_hotspots` does), though `PROCEDURE.md` lists it on the worker's pointer — the new `issues` profile now covers that gap, but the discrepancy predates this work.