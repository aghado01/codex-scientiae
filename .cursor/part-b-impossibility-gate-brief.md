# Handoff — Part B: the impossibility gate (codex-membrane)

For Cursor. Self-contained implementation brief. The pincer's **contradiction readout** — reject
LLM-hallucinated structure at the mutation path before it enters the ledger. Folds in on top of the
just-landed composite work-order spine; reuses the spine's shared signature table.

## STEP 0 — ground (PowerShell repo; code in `src/`; use the PowerShell tool)

Read, in order:
- `.discussion/pincer-policy-brief.md` — §"Part B — impossibility gate" (the spec this implements) and
  §Compatibility. (If that file or section is absent, you are on a stale checkout — STOP and report.)
- `.discussion/membrane-upgrade-plan.md` §Re-layering — Part B is the "contradiction GATES" readout; the
  substrate, Part A, and the spine have all LANDED.
- `.claude/mcp-spine-followup.md` — what the spine added; in particular `$script:CorruptionSignatures` in
  `fidelity.ps1`, which you **reuse** (do not fork it).
- Source: `src/restructure.ps1` (the structural ops `Set-ChunkType` / `Split-Chunk` / `Merge-Chunks` +
  `Save-Structure` — where you wire the gate), `src/fidelity.ps1` (the shared table + `Get-CorruptionType` +
  `Get-ChunkIssues`), `src/serving.ps1` (`Invoke-RepairApply` — the existing content gate + the
  `Add-RepairProposal` rejection shape to mirror), `src/latex.ps1` (`Get-LatexBalance`, math predicates),
  `src/masks.ps1` (primitives — do **NOT** modify).
- `CLAUDE.md`, `STANDARDS.md`, `src/PROCEDURE.md`, `tests/run.ps1` + `tests/README.md` (Pester 5 imported by
  `run.ps1` from the portable tree).

## Goal

The structural mutation tools (`retype_chunk` / `split_chunk` / `merge_chunks`) currently execute and
renumber **unconditionally** — only `apply` gates content (`Get-CorruptionType`, clean-only merges). So an
agent can retype a chunk to `formula` that doesn't balance, or merge chunks into an impossible result, and it
lands in the ledger. Part B adds a **structural impossibility gate**: evaluate a small *declared* set of
impossibility predicates on the **would-be post-mutation result**; if any fires, **reject with a precise
diagnostic** (the exact shape `Add-RepairProposal` already returns on the delimiter detector) and do **not**
mutate.

## Mechanism — reuse the spine's table; impossibilities are signature/mask predicates on the result

- The core impossibilities ARE the structural corruption signatures the spine already put in
  `$script:CorruptionSignatures`: `alignment_outside_env`, `prose_in_formula`, `unbalanced_delimiters`.
  Evaluate them (via `Get-ChunkIssues`, or the relevant signatures) on the chunk the mutation **would
  produce**, not the input.
- Op-specific predicates: a `retype_chunk` to `formula` must satisfy `Get-LatexBalance(content).full`; a
  `merge_chunks` result (the joined content) must balance; a `split_chunk` must not orphan a delimiter
  partner across the cut (each side balanced, or the seam surfaced).
- **Reuse the ported detectors / the shared table — ONE definition.** Do not fork a second copy of these
  checks; that reopens exactly the drift the substrate and the spine just closed.

## Wiring

- In `src/restructure.ps1`: before `Save-Structure` commits a `retype` / `split` / `merge`, run the
  impossibility check on the would-be result. If it fires, return the rejection object
  (`{ ok = $false; id|ids; reason = <impossibility type>; diagnostic = <seam/...> }`, mirroring
  `Add-RepairProposal`'s `accepted=$false; reason; diagnostic` shape) and do **not** write or renumber.
- `apply`'s content gate (`Invoke-RepairApply` → `Get-CorruptionType`) already exists and **stays** — Part B
  does not replace it; it adds the structural-op gate that is currently missing.
- `src/mcp-server.ps1`: the structural tools' descriptions note they now reject impossibilities (doc only;
  the tools already return objects — no schema change, tool count stays the same).

## Invariant

Reject-with-diagnostic, never silently mutate or fix. The impossibility checks are **additional** rejections
on the mutation path, layered on (not replacing) the existing `Get-CorruptionType` apply gate. A mutation that
produces a clean, possible result still succeeds exactly as today.

## Compatibility (the membrane is young — preserve the delicate mechanics)

- **Do NOT reject a legitimate `merge_chunks`** — especially the **fragmented-formula merge** the
  hotspots/work-order path depends on: a real fragmented formula's JOIN balances, so it must pass. Verify this
  explicitly (a fragmented-formula span merge succeeds).
- **Reuse `$script:CorruptionSignatures` / the ported detectors** — no second definition, no drift.
- **Don't change the structural ops on VALID input** — only ADD rejection on impossible results; the
  id-renumber + `.jidx`-rebuild path is unchanged for accepted mutations.
- The frozen single-type gate and the `apply` content-gate are unchanged.
- Codepoint safety stands (UTF-8-no-BOM I/O; masks already surrogate-safe). **No `masks.ps1` changes.**
- A small **declared** set — **NOT** a rule-engine (the standing non-goals fence).

## Validation (intrinsic + differential, the house standard)

- **Reject cases** (synthetic): a `retype→formula` that doesn't balance is rejected with the delimiter
  diagnostic; a `merge` producing an unbalanced result is rejected; a mutation producing
  `alignment_outside_env` is rejected.
- **Legitimate mutations PASS**: a fragmented-formula `merge_chunks` (the join balances) succeeds; a valid
  `retype` / `split` succeeds and renumbers as before.
- **No regression**: run `pwsh -File tests/run.ps1` — the existing **97** tests MUST stay green. Add Part B
  `It`s under `tests/` (the reject cases + the legitimate-merge pass + a check that the `apply` content-gate
  still catches content corruption).

## Non-goals / defer

The full playbook-as-data; the localized-span / `math_dirt` difference-localization; any new sub-chunk
granularity; a general rule-table runner. Don't touch `masks.ps1`. Do **NOT** `git commit` (stage only; the
commit is the user's, at a milestone).

## Report when done

The impossibility predicate set + how it reuses the shared table; the wiring into each structural op; the
rejection shape; the validation results (reject cases, the legitimate-merge pass, the 97 existing tests still
green); and anything deferred.
