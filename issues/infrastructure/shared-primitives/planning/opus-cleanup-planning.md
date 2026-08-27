Good — and thanks for the correction; I'm now properly in `codex-scientiae`. Let me read the project's `AGENTS.md` first (the CLAUDE.md defers to it), since I haven't been operating under it.

Your reframe is the more interesting question, and it connects directly to threads from the synthesis brief. Before I propose how to fold it in, let me ground it: what `inventory-catalog.ps1` actually hand-rolls (is it redundant with the engine's `InventoryRegistry`/catalogue now?), and where the "ledger" concept actually recurs.

`AGENTS.md` reframes my operating context: the project is under "drastic renovations... disentangling concerns," with an explicit charter to "help identify systemic issues, repair bad patterns... remain open to fluid changes," plus "separation of code and config." Your consolidation instinct isn't a tangent — it's the project's stated mission, and the code agrees. Three grounding findings:

- **`inventory-catalog.ps1` literally declares itself a placeholder.** Its own docstring: the "private whole-file codec is deliberately bounded **while the replacement shared JSONL substrate is still unintegrated**... Incremental mutation, persistent indexes, multi-writer coordination... remain infrastructure work." It hand-rolls exactly what the jsonl*engine + PS client now do. It's \_waiting* to be replaced.
- **"Ledger" recurs on two levels.** As a _planning-doc convention_ (`ledger.md` = completed-work index, in latex-ingest / batch-executor / doccer / devops), and as an _unbuilt engine archetype_ — the brief's `Ledger` (append-only, outlives its sources) that never landed, with `probe-ledger.ps1` and the devops "run-ledger" both hand-rolled and waiting for it.
- **A third path primitive is also triplicated** beyond what my spec covers: `Test-*PathWithinRoot` lives in `latex-source.ps1:50`, `inventory-catalog.ps1:31`, and `latex-inventory-row.ps1:106`.

So what you've surfaced is that my extraction spec is really **thread 1 of a three-thread consolidation program**:

| Thread                                                      | What                                                                       | Nature                                                                                                                        | Depends on      |
| ----------------------------------------------------------- | -------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | --------------- |
| **1. PS-native primitives**                                 | portable-path, file-bytes, authored-jsonl (+ maybe `Test-PathWithinRoot`)  | Small, ready (spec done). Genuinely PS-native — hot-path safety + tolerant authored-JSONL the engine deliberately won't touch | nothing         |
| **2. Retire the inventory/catalogue codec onto the engine** | `inventory-catalog.ps1` → engine `InventoryRegistry`/catalogue via the CLI | Medium; uses _existing_ engine capability. Needs a format-compat decision (headerless vs `InventoryRegistry`)                 | engine (exists) |
| **3. Promote the Ledger archetype into the engine**         | Define `Ledger` store archetype; migrate `probe-ledger` + run-ledger       | Largest; new engine/CATEGORY-layer design; intersects the devops run-ledger brief                                             | engine design   |

**The key interaction:** the threads share a boundary question — _what belongs as a PS-native primitive vs. what should be replaced-by / promoted-into the engine._ Thread 1 stands independent (its three primitives are all correctly PS-side), but its _unify scope_ is coupled to Thread 2: if `inventory-catalog.ps1` is about to be retired onto the engine, I shouldn't bother folding its path-safety copies into the shared primitive.

Given that, my recommendation is to **map the program before executing** — a short brief fixing the three threads, their boundaries, and the sequence — so Thread 1 is scoped with 2 and 3 in view, rather than extracting something that should have been promoted to the engine instead. How do you want to proceed?

**Map the program first** it is. To make the map accurate rather than hand-wavy, I need to resolve the one fact that decides everything: **is the engine actually ready to absorb the inventory/catalogue codec (Thread 2)?** The brief's open-question #4 warned the engine's `InventoryRegistry` may still lack the unique-key/canonical-sort slots that `inventory-catalog.ps1` hand-rolls. Let me check what the engine + CLI actually expose, and characterize a ledger instance for Thread 3.

Decisive finding for the program — I checked the engine, and it reshapes Thread 2:

**The engine already _has_ the catalogue machinery; it just isn't reachable from PowerShell.** `Registry` (the base of `InventoryRegistry`) is "keyed, unique, canonically ordered, wholly rebuilt": `collate()` validates → keys by schema `x-identity` → refuses duplicates → returns canonical order, and `rebuild(entries)` writes a byte-reproducible `inventory.jsonl` + `.sig`. `KeyComparison` even carries the ordinal-sort/caseless-dedupe distinction the brief worried was missing. So brief open-Q #4 is effectively **resolved in Python** — but the **CLI exposes no registry-rebuild verb** (only `capabilities`, `schemas`, `json`, `validate-json`, `deposit`, and the readers).

That means Thread 2 isn't a from-scratch engine build — it's **"expose the existing `rebuild()` as a CLI verb, then migrate `inventory-catalog.ps1` onto it via the PS client,"** exactly the shape the `deposit` verb followed. Much lower risk than the brief implied.

Here's the refined map I'll write up:

## The consolidation program — three threads

**Thread 1 — PS-native primitive extraction** _(spec done; sub-project one)_
`portable-path` (+ now `Test-PathWithinRoot`, also triplicated across `latex-source`/`latex-inventory-row`), `file-bytes`, `authored-jsonl`. Boundary call: **thread 1 leaves `inventory-catalog.ps1` untouched** — Thread 2 retires that file, and unifying primitives into code bound for the graveyard is waste. It unifies only the three consumers that stay PS-native.

**Thread 2 — Retire the inventory/catalogue codec onto the engine** _(medium)_
Add a registry-rebuild CLI verb (reads N article objects → `InventoryRegistry.rebuild()`), then migrate `inventory-catalog.ps1` — which self-declares as a placeholder for exactly this — onto it via the PS client. One real decision: the format shift (today's headerless/no-sidecar `inventory.jsonl` → the engine's headered + `.sig` form). The corpus is due for a wipe, so supersession strands nothing.

**Thread 3 — Promote the Ledger archetype into the engine** _(largest; design-heavy)_
The engine has `Registry` (rebuilt) and `ArticleManifest` (sentinel) but **no append-only, outlives-its-sources store** — that's the Ledger. The low-level `APPEND` discipline exists; the _archetype_ (kind class + invariants + the CATEGORY layer from brief §2) does not. Instances waiting: `probe-ledger.ps1` and the devops "run-ledger" brief. This is where the brief's taxonomy work actually lands.

**Recommended sequence: 1 → 2 → 3.** One clears underbrush and is ready. Two uses machinery that already exists (just needs a CLI surface) and kills a self-declared placeholder. Three is the deepest design and benefits from 1 and 2 being settled first. Each thread gets its own spec → plan → implementation cycle; Thread 1's is already written.

## Phase 1 complete

Proceeding with inline execution. Let me load the executing-plans skill for the checkpoint discipline, then start Task 1.

**I'm using the executing-plans skill to implement this plan.**

One critical-review check before I touch code: the plan removes/renames internal functions (`ConvertFrom-LatexPatchJsonLine`, `Test-LatexPatch*`, `Test-LatexBatch*`). If any test calls those _directly_ (not end-to-end), the rename breaks them. Let me verify the tests are end-to-end. I'll also confirm I'm right to stay on `main` (your standing preference; you said proceed).

Critical-review finding: only **one** direct test reference exists — `latex-batch.Tests.ps1:683` does `Mock Test-LatexBatchPathHasReparsePoint`. So Task 6 must also update that mock to `Mock Test-PathHasReparsePoint`; everything else is end-to-end. Noted. And staying on `main` matches your standing preference. Starting Task 1 with a full TDD cycle to establish the pattern and confirm the harness.

Fail confirmed (10 selected, 10 failed — impl absent, discovery works). Now the implementation.

Task 1 green (10/10). Committing, then Task 2.

Task 1 committed (`ad2062c`). Task 2 — writing test + impl together (both new files), then verifying.

Task 2 green (5/5). Committing, then Task 3.

Task 3 — the composed reader. Writing test + impl.

Task 3 green (6/6). **Checkpoint — the three shared primitives are landed and independently tested** (10 + 5 + 6 = 21 new tests, three commits). Now the repointing phase begins (production code, each guarded by its existing regression suite). Committing T3 and proceeding to T4.

Task 3 committed (`9c0f289`). Now T4 — the most involved edit (restructuring `latex-patch.ps1`). Let me re-read the current file to make precise, exact-match edits against production code.

Exact text confirmed. Applying the three small edits (dot-sources, remove the portable-leaf copy, repoint `Get-LatexPatchPath`).

Now the deletion block and the two rewrites. Let me re-read the current file region (line numbers shifted) to get exact text.

I have the exact current text. But before the big rewrite, I must check one risk: the shared reader's file-level error messages say "authored JSONL…" where the originals said "LaTeX patch file…". If the tests pin the old wording, the rewrite breaks them. Let me read the test's `Should -Throw` assertions.

Now I can see the exact assertions. Three of them pin latex-patch-specific wording that the generic reader legitimately changed (behavior identical, wording generalized): line 86 (`1 MiB` → generic byte-limit), line 126 (`LaTeX patch identity` → generic), line 143 (`patch path` → generic). Everything else matches by wildcard. Let me read the test tail to be sure I've caught all pinned messages before the rewrite.

The tail is clean — all remaining assertions come from retained functions (`Invoke-Latex*Patches`, `Assert-PatchHits`, etc.), unchanged. So the only wording mismatches are lines 86/126/143.

Decision on those: rather than change the sol session's pinned test wording, I'll make the shared reader **subject-labeled** — a small `-Subject` param (default `'authored JSONL'`) so latex-patch passes `-Subject 'LaTeX patch'` and gets its _exact_ original messages back. This is more behavior-preserving and makes the primitive more reusable. It reduces the unavoidable test change to just one (the oversize `1 MiB` → generic byte-limit, which a byte-parameterized primitive genuinely can't reproduce). Let me amend `authored-jsonl.ps1` accordingly.

Still 6/6. Committing the `-Subject` amendment, then the latex-patch rewrite.

`3507b25` committed. Now the two rewrites in `latex-patch.ps1` — `ConvertFrom-LatexPatchJsonLine` becomes `ConvertFrom-LatexPatchRecord` (consumes pre-parsed fields), and `Read-LatexPatchSet` delegates to the shared reader with `-Subject 'LaTeX patch'`.

Both rewrites applied. Now update the one unavoidable test assertion (the oversize `1 MiB` wording, which a byte-parameterized primitive can't reproduce), then run — the dead helper functions are still present but harmless, so this confirms the rewrite before I delete them.

22/22 with the rewrite in place — `-Subject` preserved every message. Now removing the 8 dead helper functions (three contiguous deletions).

All three deletions applied. Verifying the file parses cleanly and still passes 22/22.

T4 done — `latex-patch.ps1` restructured, AST clean, 22/22. Committing.

**Checkpoint: T1–T4 complete** (6 commits, all green — the three shared primitives plus the full `latex-patch` repoint onto them, with exact error messages preserved via `-Subject`). Continuing with T5 (the `Test-PathHasReparsePoint` rename across the deposit lane). This one has the tricky `${function:}` transport capture, so let me read the relevant regions and load structure first.

Now I understand the structure clearly:

- `source-deposit.ps1` gets the function via `. latex-source.ps1` (line 10); `logistics/latex-source-deposit.ps1` gets it transitively via `. source-deposit.ps1` (line 15).
- The `${function:}` capture at :265 is an **in-process closure capture** (`& $testReparsePath` at :282), not a cross-process transport — so renaming the reference suffices as long as the function is in scope, which the dot-source chain guarantees.

Before deleting the definition, let me get a comprehensive list of every caller so I don't strand one.

Six files reference it — including `latex-ingest.ps1` and two **test files** (which may `Mock` it, requiring updates). Let me see exactly how each uses it.

Complete map (2 production callers in `latex-ingest.ps1`, plus 2 test `Mock`s to update). Let me handle `latex-source.ps1` first — add the dot-source, delete its definition, and rename its one internal caller.

`latex-source.ps1` done. Now the token rename across the remaining callers and the two test mocks.

All renames applied. Verifying: no stragglers, files parse, and the deposit tests (which mock the renamed function) pass.

T5 green — no code stragglers (only the planning docs mention the old name, as expected), 4 files AST-clean, deposit tests 12/12 and 5/5. The §6a child-path concern is covered: the capture is an in-process closure, and both deposit suites already mock `Test-PathHasReparsePoint` and exercise the FindingsPath safety path. Committing.

T6 — the adapter. Before I swap its incremental-hash read for the shared primitive, I need to check what `latex-batch.Tests.ps1` asserts about the adapter's messages (and confirm the `Mock` line), since the shared reader's wording differs.

Only one message mismatch (line 483, the oversize wording) and the `Mock` at :683 to rename — line 658's reparse message lives in the _caller_ (`Resolve-LatexBatchPatchRecord`), so it's preserved. Let me check the worker file's header before editing it, then do all T6 edits.

The worker's identity check at :17-20 runs _before_ it dot-sources anything (line 26), on its fast-fail path in a batch child process. Adding a shared-file dependency there is higher blast-radius than a one-line dedup warrants, so I'll **skip the `invoke-latex-ingest.ps1` change** (documented deviation) and leave its inline regex. Now the adapter edits — dot-sources, delete the two local copies, swap the incremental hash for the shared primitives.

All four applied. Now the caller renames and the test updates.

T6 edits complete. Verifying — no stragglers, AST-clean, and the adapter suite passes.

T6 green — 0 stragglers, AST-clean, adapter 10/10 (same Administrator-gated symlink skip as baseline). Committing, then the final regression + ledger.

T6 committed (`ed43348`). Now T7 — the final gate. Re-running the affected containers not yet verified this session (the `latex-ingest` converter changed, plus structural topology), and confirming the already-green ones stay green isn't needed since they were verified post-change. Running the converter + compat + topology now.

Path-topology shows **2 failures** — I need to determine whether these are the 4 pre-existing JSONL-v2 reds the sol session documented, or a real regression from my changes. Stopping to diagnose before anything else.

Confirmed — the 2 topology failures are the **pre-existing documented archaeology**: all 4 dangling references are retired `jsonl.ps1` / `jso-ops/jsonl-v2*.ps1` refs from unrelated test files (`encoding-invariants`, `jsonl-store-v2`, `jsonl-v2-compat`, `jsonl-v2`). **None** implicate my new `portable-path`/`file-bytes`/`authored-jsonl` files — my extraction introduced zero new topology violations, exactly as the plan required. All functional suites pass (integration 7/7, compat 4/4, wider latex-ingest 60/60).

Final static checks — AST parse every changed file, whitespace, and straggler grep.

AST clean across all 17 changed files; `git diff --check` clean (the AGENTS.md CRLF note is pre-existing, unrelated). The `rg` straggler check misfired (not on PATH in pwsh) — let me confirm no stragglers with the proper tool, scoped to code.

Zero stragglers in any `.ps1`. The extraction is complete and clean. Writing the ledger — recording what landed, the two deferrals, and the test-wording changes.

**Thread 1 is complete** — all 7 tasks landed and committed on `main` (your direct-on-main workflow, so there's no branch to finish; the work is already integrated and verified).

## What landed

The generic primitives are out of the application layer and into `src/shared`, with every duplicate retired onto them — a behavior-preserving lift:

- **`portable-path.ps1`** (`Test-PortableLeaf`, `Test-PathHasReparsePoint`) — retired 2 portable-leaf + 3 reparse copies
- **`file-bytes.ps1`** (`Read-BoundedFileBytes`, `Get-ContentIdentity`, `Test-ContentIdentityFormat`) — retired latex-patch's bounded read/identity + the adapter's incremental hash
- **`authored-jsonl.ps1`** (`Read-AuthoredJsonl` + 3 field extractors) — the tolerant reader, with a `-Subject` param so callers keep their exact error wording

`latex-patch.ps1` shrank to pure domain logic (9 helpers removed); `latex-source`, both deposit files (incl. the `${function:}` closure capture), `latex-ingest.ps1`, and the batch adapter all consume the shared primitives.

## Evidence

|                     |                                                                                                                                                   |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| New primitive tests | portable-path 10/10 · file-bytes 5/5 · authored-jsonl 6/6                                                                                         |
| No-regression net   | latex-patch 22/22 · latex-batch 10/10 · source-deposit 12/12 · latex-source-deposit 5/5 · integration 7/7 · compat 4/4 · wider latex-ingest 60/60 |
| Static              | 17 changed `.ps1` AST-clean · `git diff --check` clean · **0** straggling references to retired names                                             |

## Two things I flagged (in the [ledger](issues/shared-primitives/planning/ledger.md))

1. **`Test-PathWithinRoot` deferred** — its copies genuinely diverge (case-folding `StartsWith` vs ordinal `..`-relative), so unifying it is a behavior _decision_, not a lift. Left for its own scoped pass rather than smuggling a semantics change into Thread 1.
2. **`invoke-latex-ingest.ps1` identity-regex left in place** (deviation from the plan) — that check runs on the worker's fast-fail path _before_ it loads anything, in a batch child process; adding a shared-file dependency there wasn't worth retiring one inline regex.

The only red anywhere is the **pre-existing** `path-topology` archaeology (4 retired-JSONL refs from unrelated test files) — my changes added zero new violations.

## Where this sits

Per the [consolidation program map](issues/infrastructure/planning/2026-08-08-consolidation-program.md), Thread 1 (underbrush) is done. Next when you want them: **Thread 2** (retire `inventory-catalog.ps1` onto the engine via a new registry-rebuild CLI verb — the machinery already exists), then **Thread 3** (promote the Ledger archetype into the engine). Each gets its own spec→plan→execute cycle when you're ready.
