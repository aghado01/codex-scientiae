# jsonl_engine — synthesis of the "sol" session and the live loose ends

Runstamp 20260808_141747. Reading of `discussion/sol-jsonl-engine-session.md` against the prior
`briefs/opus-engine-state-and-next-sequence-20260807_141055.md`, the working tree, and the current
code. Purpose: give the next session an accurate board before it picks a lane. Nothing here changes
code; the one verification run is recorded in §2.

## 1. What the sol session actually did

The session (an external agent) ran a review-then-build arc across **six** work items. It did **not**
follow the prior brief's planned sequence (§4 below) — it pursued an adjacent, more foundational
track: make the engine *correct*, *runnable in the canonical harness*, *reachable from PowerShell*,
and *able to publish*, plus a latex-ingest input lane.

| # | Item | Outcome | Landed as |
|---|------|---------|-----------|
| 1 | Read-only review of `src/shared/jsonl_engine` | 8 P1/P2 integrity bugs + 1 process gap found; 119/119 suite was green but missed them | evidence in transcript |
| 2 | Fix the 8 findings + pytest regressions | lease cleanup, index-poisoning, generation-bound reads, safe snapshot, registry symmetry, strict-JSON/encoding parity, canonical locks | **committed** (Aug-7 eve, incl. `8f349da`) |
| 3 | pytest **batch parity** | `Get-PytestBatchJob`, `tests/pytest.ps1`, `parallel.ps1` gains `All\|Pester\|Pytest`; 1 file → 1 isolated job | **committed** |
| 4 | Centralized **PowerShell client** | `src/shared/jsonl-engine-client` manifest module; `engine-call.ps1` retired; `jso-shell.ps1` → compat importer; protocol-v1 framing | **committed** (`311ef1f`) |
| 5 | **`deposit`** verb | `deposit.py`, `ArticleManifest`, `article.schema.json`, migrated `latex-source-deposit.ps1`; 16 CLI verbs | **committed** (`311ef1f`) |
| 6 | Tolerant **patch-JSONL** lane | `latex-patch.ps1`, canonical `{docdir}/{slug}-latex.patch.jsonl`, batch identity + slug pinning, D20 | **UNCOMMITTED** (entire working tree) |

**The committed/uncommitted boundary is the single most important operational fact:** items 1–5 are
in history; **item 6 is the whole current working tree** and has not been committed. `git status`
shows exactly the item-6 file set (patch reader, converter wiring, adapter identity, four doc files,
three test containers) plus the untracked transcript.

## 2. Working-tree state — verified, not trusted

I re-ran the uncommitted deliverable's own containers in the current tree (asserts genuinely ran):

- `tests/latex-ingest/latex-patch.Tests.ps1` — **22 passed / 0 failed / 0 skipped**.
- `tests/adapters/latex-batch.Tests.ps1` — **10 passed / 0 failed / 0 skipped**; one branch (live
  file-symlink swap) skips without Administrator rights — a capability gate, not a failure.

Wiring is coherent: `latex-ingest.ps1:36` dot-sources the module; `Read-LatexPatchSet` (2432),
`Invoke-LatexSourcePatches` (2448), `Invoke-LatexOutputPatches` (2574) are called at the right
stages; the compat entrypoint routes through the same reader. **Item 6 is commit-ready.**

Not re-run this session (committed + verified in-session at 264 shared-suite outcomes): the full
Python engine suite, the client suite, the mixed batch. A belt-and-suspenders `tests/parallel.ps1`
pass before the next feature is cheap insurance, not a correctness doubt.

## 3. Loose ends, by category

### 3a. Explicitly deferred by the session, and recorded

1. **Whole-conversion transactional publication.** A late refusal — notably an `output_replace`
   that goes STALE *after* the source phase already ran and conversion already wrote — can leave
   declared partial run/output artifacts. Recorded in `roadmap.md` (Mid) and disclaimed in D20. This
   is genuine: `Invoke-LatexOutputPatches` throwing is unguarded by any staging/journal of the
   conversion writes. **Post-D20 lifecycle work, not a hole in the patch contract.**
2. **Handle-level no-follow protection.** `Test-LatexPatchPathHasReparsePoint` runs before *and*
   after the bounded read (a check-twice TOCTOU mitigation), but there is no `FILE_FLAG_OPEN_REPARSE_POINT`
   / handle-bound guarantee. Adequate today; the stronger form is deferred.

### 3b. Deferred in conversation, recorded, larger than a fix

3. **Logger integration.** Agreed to defer: the logger stays PowerShell-native (spawning Python per
   log record would be disastrous), but "probably needs some more work now that the engine is
   working" — incorporate logging *after* the logger matures. No code owns this yet.
4. **`inventory-catalog.ps1` migration onto the engine.** Named the best next producer to migrate,
   but its current headerless / no-sidecar format differs from Python `InventoryRegistry`, so it
   needs an explicit **compatibility decision** before migration. Related open question: does the
   PowerShell lane keep schema-validating, or defer to the engine (the endgame)?

### 3c. The big divergence — the prior brief's roadmap was largely not pursued

The `20260807_141055` brief laid out an 8-step sequence centered on the **ref-graph / taxonomy**
lane. The sol session did **step 8 (deposit)** and none of steps 1–7. Current status of that lane:

- **CATEGORY layer + `JsonlStore`/`Catalog`/`Exhibit`/`Ledger` rename (brief §2): NOT done.** What
  *did* land: base class renamed `BaseArtifactRegistry → BaseStore` (neutral "what it is" name),
  which also settles the brief's open-question #4 — `JsonlStore` couldn't be the base name because
  the reader already owns it. But there are no `Exhibit`/`Ledger`/`Catalog` operation-subclasses;
  `ArticleManifest(BaseStore)`, `InventoryRegistry(Registry)`. The category-as-subclassing idea is
  still on paper.
- **Defect #1 — custom-counter overlap** (`$st.rt` never disarmed in `Resolve-CustomCounters`; the
  consume-once fix): **still open.** Blocks `labels` from being canonical.
- **Defect #2 — `edge.site` doesn't join** (`$si` incremented in the inner loop): **still open**,
  now `roadmap.md` "Refgraph site→node anchoring (edges carry `from = null` today; site order only)."
- **Defect #3 — `tex-docgraph.ps1` orphaned**: **still open**, `roadmap.md` "tex-docgraph physical
  retirement (refs-consolidation step 5)."
- **Defect #4 — `DocGraphRegistry` invented stub**: **resolved by deletion** — no docgraph/ref-graph
  exists anywhere in the Python engine now.
- **Defect #5 — `NAME_FORMAT` `{stem}`**: docgraph was its only user; likely moot now — worth a
  30-second confirm that no consumer remains.
- **ref-graph schema + `docgraph.py → ref_graph.py` (brief steps 3–4): not started**; the ref-graph
  is still two flat PowerShell tables (`refs.jsonl`), gated behind defects #1–#2 as the brief warned
  ("writing the schema now would pin identity fields that don't identify anything").

### 3d. Open questions still unresolved (brief §5)

- Is `projection` evidence or configuration (a possible fourth category)?
- Does ref-graph supersede `refs.jsonl`/`refgraph.json` on landing, or is there a transition?
- When does the create-if-absent discipline land — with CATEGORY, or with the verb that needs it?
  (Deposit landed create-if-absent *behaviorally* in `ArticleManifest`; the general discipline layer
  did not.)
- Do the ref-graph's inputs (`labels`, `sites`, `citeMap`, `AllLabels`) persist as atoms, making the
  stage a rebuildable view? (Cross-refs the devops resumable-stages brief.)

### 3e. Current `issues/jsonl-engine/TODO.md` (the sol-updated, narrower list)

- **Deposit corpus coverage** — the two `not-applicable` branches (single-TeX gzip; explicit
  `-MainTex`) are still unexercised by corpus evidence; all staged deposits are tar+gzip
  single-candidate. (= brief defect #7.)
- **Docstring pass** on the remaining `src/logistics` PowerShell (`probe-ledger.ps1`,
  `run-paths.ps1`) — done for Python, open for these.
- **Legacy topology archaeology** — four retired Pester JSONL-v2 containers still reference removed
  `src/shared/jso-ops/jsonl-v2.ps1`; the topology test reports them red by design. A standing,
  documented deferral, not a regression.

## 4. Review notes on the uncommitted item 6

The module is defensively written and its tests are honest. Observations (none block a commit):

- **`define_macro` prepends `\newcommand{...}` to the top of the `.tex`** (`latex-patch.ps1:518,543`),
  ahead of `\documentclass`. This is fine only if the downstream converter's macro machinery reads
  definitions position-independently (it does not compile real LaTeX). Worth a one-line confirmation
  that injection point is correct for the converter, since a real `pdflatex` would reject it.
- **Double validation** — `Assert-LatexPatchRuntimeRecords` re-checks every record (types, closed
  vocabulary, duplicate `define_macro`) at apply time, duplicating `ConvertFrom-LatexPatchJsonLine`.
  Intentional (defends direct `Invoke-Latex*Patches` callers), but the duplication is a maintenance
  cost if the grammar grows.
- **Regex bounds** are good: 250 ms `CultureInvariant` timeout, 1 MiB raw cap enforced *before and
  during* the bounded read.
- The symlink-swap adapter branch cannot self-verify without admin; the reparse-drift guarantee for
  batch identity is therefore partly unproven on this host.

## 5. Recommended next sequence

0. **Commit item 6.** It is green, coherent, and self-documented (D20 + ledger + roadmap). Also
   commit or relocate the untracked `discussion/sol-jsonl-engine-session.md`. Clearing the tree
   removes the ambiguity of a large uncommitted surface before any new work.
1. **Decide the lane** (this is the real fork — see the three candidates below). The session left two
   coherent bodies of work that barely overlap:
   - **A — Finish the patch/deposit lifecycle**: whole-conversion atomic publication + handle-level
     no-follow (3a.1–2). Small, well-scoped, closes the freshest deferrals while context is warm.
   - **B — Resume the brief's ref-graph/taxonomy lane**: consume-once (#1) → `$si` to outer loop
     (#2) → ref-graph schema → `ref_graph.py`/kind → tex-docgraph retirement → CATEGORY layer. This
     is the larger, higher-value arc the prior brief planned; it was paused, not cancelled. The
     brief's dependency ordering still holds (fixes #1–#2 must precede the schema).
   - **C — Consolidate the integration surface**: logger integration (3b.3) and/or
     `inventory-catalog.ps1` migration (3b.4). Unblocks real callers on the new engine but each needs
     a compatibility decision first.
2. **Cheap wins available in any lane:** confirm `NAME_FORMAT {stem}` has no consumer (#5, likely a
   deletion); the `src/logistics` docstring pass; deposit corpus coverage for the two `not-applicable`
   branches (needs a single-TeX gzip + a `-MainTex` fixture).

**Recommendation:** do **step 0** now, then **lane A** (small, closes the newest debts, leaves the
tree clean), *then* **lane B** as the next substantial arc — because B is where the project's stated
direction (canonical evidence structures, the ref-graph as the first real Exhibit) actually lives,
and its blocking defects (#1, #2) are small, well-understood, and already specified in the prior
brief. Lane C waits on a compatibility decision that is itself worth making deliberately, not under
momentum.

## 6. Reconciliation note for the index

This brief supersedes nothing; it sits beside `opus-engine-state-and-next-sequence-20260807_141055.md`
and records how much of that brief's plan was overtaken by the review-driven track. When a
`planning/` tier is created, brief §4/§5 of the prior brief plus §3c/§3d here are the locked-vs-open
ledger for the ref-graph lane.
