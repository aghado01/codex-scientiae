# Brief — math-density hotspots (membrane upgrade Track 2)

Implementer's brief for Track 2 of [`membrane-upgrade-plan.md`](membrane-upgrade-plan.md). Grounded in the
live code; names the signal, the functions, the files, the edge cases, and the validation. Designed to be
handed off cold.

## Problem

Docling shatters a block equation across multiple chunks at *visual* layout seams (line/column/page breaks).
The chunk stream then carries, say, ids 41–44 that are one derivation. Two failures follow:

1. **Dispatch hands each fragment as an independent, blind work-unit.** A worker pulling id 42 sees
   `\big( \nabla f(x) ,` — its closing `\big)` lives in id 43. `Get-LatexBalance` reports `paren=1` forever;
   the worker cannot close a seam whose partner it was never shown, so it loops or escalates spuriously.
2. **Per-chunk balance lies against the joined truth.** Each fragment flags `unbalanced_delimiters`; the
   *concatenation* is `full`-balanced. The damage is the fragmentation, not the content.

This is exactly the "arbitrary IR chunk seam vs semantic repair unit" gap the doccer threads name
([`gemini-doccer-discussion.md`](gemini-doccer-discussion.md) #5,
[`cursor-doccer-concepts-interation.md`](cursor-doccer-concepts-interation.md) #3) — "the most critical
operational improvement." Budget bleeds N× on units that can only be fixed together.

## The principled signal (no magic strings)

The detector must key on structure, not content patterns — the standing rule (`sections.ps1:205`,
[[no-magic-string-structural-heuristics]]). Three structural facts, already available:

- **Adjacency.** Fragments are contiguous in id (== adjacent lines == reading order). A run is `[lo..hi]`.
- **Math register.** A member is math-dense if `type == 'formula'`, or its math-register density is high —
  reuse `$script:MathLatexRx` (normalize.ps1:78), the same regex behind `math_dirt`.
- **The discriminator — join-balances-better-than-parts.** Concatenate the run and test
  `(Get-LatexBalance $join).full`. If the join is balanced (or strictly closer to balanced than the parts —
  `Σ|residual_i| > |residual_join|`), the fragmentation hypothesis is *structurally confirmed*. This is
  complement/residual thinking (the same insight `repair.ps1` uses for intertext tails), expressed as a
  balance test — principled, low-false-positive, venue-agnostic.

Density is the cheap pre-filter; **the join-balance test is the confirmer.** Density alone would be a soft
heuristic; gating it on the balance test is what makes it a derivation, not a guess.

## Detection — `Group-MathHotspots` (pure, lazy)

A pure function over an in-memory chunk list. **Computed lazily at dispatch/hotspot time, not persisted** —
a sidecar would go stale on every `split_chunk`/`merge_chunks` renumber (like `.jidx` must rebuild); lazy
recompute is one body-light pass and sidesteps that whole staleness class. (Persistence is a parked
optimization if profiling ever demands it.)

```
Group-MathHotspots($chunks) -> spans[]   # each: { ids:[lo..hi], pages[], density, joined_seam, joined_full }
```

Algorithm:
1. Walk chunks in id order. Seed a run at each math-dense chunk; extend while the next chunk is adjacent
   AND math-dense. Membership is by adjacency + register, **not** by grade: a middle fragment that happens
   to balance individually is `faithful` yet still belongs to the span (it carries part of the equation).
2. Discard runs of length 1 (nothing to group).
3. For each run, compute `$join` = concat of member content (in id order, newline-joined), then
   `Get-LatexBalance $join`. Promote to a span **iff**:
   - `joined.full` (or `Σ|residual_member| > |residual_join|`), **AND**
   - **at least one member is individually unbalanced** — i.e. the fragmentation actually broke a delimiter.
     (Two *already-balanced* adjacent display equations are NOT a hotspot; this guard prevents merging
     legitimately separate formulae.)
4. Emit the span with `joined_seam` (the residual fmt from `Get-LatexBalance`, as `repair.ps1:104` writes it)
   and the member page set.

Reuses `Get-LatexBalance` (latex.ps1) and `$script:MathLatexRx` (normalize.ps1) — both already dot-sourced
by `serving.ps1`. No new dependency.

## Surfacing — overlay, non-destructive (the chunk stream is untouched)

The span changes *what dispatch hands out*; it never mutates `chunks.jsonl` (ids stable, IR fidelity kept).

- **`Invoke-Dispatch`** (serving.ps1:320): run `Group-MathHotspots` once over each doc's chunks. The loop
  emits work on **flagged** chunks only, so trigger the span on its **first flagged member**, anchor the
  pointer at `lo` (even when `lo` is itself `faithful`), and mark **every** member consumed — including any
  `faithful` middle fragments, which must still be leased and merged though they were never dispatched:
  ```
  { paper, id: lo, span: [lo, hi], kind: 'fragmented_formula', grade: <worst member fidelity>,
    bytes: <joined length>, section, seam: <joined_seam> }
  ```
  Lease **all** member ids atomically — faithful ones included — so a later dispatch can't re-hand a sibling
  and `merge_chunks` won't miss one; `release`/`apply` already clear by id-set, so this composes. Budget counts
  the joined bytes **once**; a span that overflows the byte budget defers **atomically** (never half a span),
  subject to the existing "always make progress if the batch is empty" escape.
- **`Get-IrHotspots`** (serving.ps1:100): collapse a span's members into one row (`span`, joined preview).
- **`Get-Slice`** (serving.ps1:118): `-Context` is **symmetric** (`id ± n`), so it cannot express the forward
  range `[lo..hi]` precisely — `get_slice id=lo context=(hi-lo)` reaches the whole equation but over-reads
  `(hi-lo)` chunks *backward* into unrelated context. Harmless for v1 (extra context only), and correctness
  never depends on it: the pointer's explicit `span:[lo,hi]` is the exact id-list the worker feeds to
  `merge_chunks`. If a precise window is wanted, give `Get-Slice` an optional forward upper-bound (`to`) rather
  than abusing `context`. (A dedicated `get_hotspot` tool is also optional sugar, deferred.)

`grade`/`corruption_type` stay per-chunk and unchanged; `kind` + `span` are **additive** pointer fields, so
single-chunk dispatch is byte-identical to today (no `span` ⇒ ordinary unit).

## Repair path (procedure)

The worker handed a `fragmented_formula` span follows the existing structural-first step — the hotspot only
*targets* it instead of the agent discovering fragmentation by hand:

1. `get_slice id=lo context=span` — see all members as one view.
2. `merge_chunks ids=[lo..hi]` — collapse the fragmentation (exists; renumbers + rebuilds the index).
3. Re-ground (ids shifted), then `propose_edit` to close the now-visible seam on the single, whole equation.

Add a playbook entry to [`PROCEDURE.md`](../src/PROCEDURE.md):
> **fragmented_formula** (a `span` pointer) — one equation Docling split across chunks. `get_slice id=lo
> context=span` to see it whole, `merge_chunks` the range, re-ground, then close the `seam` with
> `propose_edit`. Do not repair the fragments individually — the partner delimiter is in a sibling chunk.

## Files touched

| File | Change |
|---|---|
| `serving.ps1` (new `Group-MathHotspots`) | the detector; small enough to live here, or split to `hotspots.ps1` |
| `serving.ps1` `Invoke-Dispatch` / `Get-IrHotspots` | collapse members → one span pointer; lease the span atomically |
| `mcp-server.ps1` | `dispatch` / `get_hotspots` descriptions note `span`/`kind`; (optional `get_hotspot` deferred) |
| `src/PROCEDURE.md` | the `fragmented_formula` playbook entry + worker-pointer note (`span` is additive) |

## Edge cases / guards

- **Two balanced adjacent equations** → not a hotspot (guard: ≥1 member individually unbalanced).
- **Cross-page runs** → allowed (column/page breaks split equations); record the page set, don't gate on it.
- **Interleaved prose** ("where", "and so") between formula fragments → v1 requires contiguous
  formula/high-dirt members; mixed runs are a **parked refinement** (would need prose-tolerance in the walk).
- **Never auto-merge in preprocess** — destructive vs the IR and irreversible; the overlay only *advises*,
  the agent merges explicitly. (An opt-in `auto_merge` is a later option, not v1.)
- **Structural renumber** — lazy recompute means no stale sidecar to rebuild; this is the main reason to keep
  detection lazy.

## Codepoint safety (do not regress)

The pipeline's hard-won invariant: all content I/O is explicit UTF-8-no-BOM (`Write-JsonlStage` →
`StreamWriter(…, [UTF8Encoding]::new($false))`, jsonl.ps1:87; the seek reader, jsonl.ps1:135; the MCP channel
pinned at mcp-server.ps1:196). SMP math (𝔼, 𝕊, surrogate pairs) and accented glyphs must survive every
round-trip — a bare `Get-Content`/`Out-File` or a locale-default stream would collapse them to `?`/U+FFFD.

This overlay is safe **because it does no new content I/O**, and must stay that way:

- **Operate in memory.** `Group-MathHotspots` consumes already-parsed chunk objects; build `$join` with
  in-memory string concat (`($members.content) -join "`n"`) — never round-trip content through a byte array,
  `Encoding.GetBytes`, or a locale-default writer.
- **`Get-LatexBalance` is SMP-transparent.** It indexes UTF-16 code units but only matches ASCII
  `{}[]()\` — surrogate halves never match, so SMP math is skipped, not corrupted. Don't "fix" it to be
  rune-aware; the existing behavior is correct and load-bearing.
- **Pointers carry only numeric/ASCII metadata** (`span`, `bytes`, `kind`, the `brace=N…` seam) — no content.
- **If the parked sidecar is ever built**, write it with `[System.Text.UTF8Encoding]::new($false)` like the
  rest of the backbone — not `Out-File`/`Set-Content`.
- **Previews stay display-only.** The `.Substring(0,54)` preview may halve a surrogate at the boundary; that
  is pre-existing and harmless (the worker always pulls full content via `get_slice`). Do not let a preview
  become a repair input.

## Validation

1. **Unit (detector).** Hand-build 3 formula chunks that individually fail balance but join `full` → one span
   returned. Two already-balanced adjacent formulae → no span. A length-1 math run → no span.
2. **Wire (dispatch).** On a doc with a known fragmented equation: `dispatch` returns **one** pointer (not N)
   carrying `span` + joined `seam`, and leases all members; `get_slice id=lo context=span` shows the joined
   view; `merge_chunks` + `propose_edit` closes it; re-`dispatch` no longer surfaces it.
3. **Real corpus.** The Voroninski `1109.4499v1` (PhaseLift) doc the integration thread cites as the
   gap-naming run is the natural first live target.

## Sequencing within Track 2

Detector (pure, testable) → dispatch/hotspot surfacing → PROCEDURE entry → wire test. Track 3
(agreement-score) can later *rank* spans alongside single-chunk hotspots; the `span` pointer is forward-
compatible with that.
