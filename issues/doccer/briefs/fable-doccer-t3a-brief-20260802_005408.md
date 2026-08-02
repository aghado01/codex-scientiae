# Doccer Tranche 3a chip brief — slice/rebase (+ riders T2-1, T2-5)

Runstamp 20260802_005408. Minted by the piloting session that answered the sol review and landed
D16–D18. Canon: [planning/decisions.md](../planning/decisions.md) (D1–D18) and
[planning/roadmap.md](../planning/roadmap.md) — read both before starting; they are current
truth. In-repo contract surface: `src/doccer/README.md` (must stay in agreement). Harness:
`tests/doccer/Program.cs`, 1340 checks green via
`dotnet run --project brewery/doccer/Doccer.Tests.csproj`.

## Objective

Land the slice/rebase pair of the lift vocabulary (D7): mint a fragment-local child master over
a window of a parent master, and rebase child-coordinate geometry back into parent coordinates.
This is the **total bijective case only** — no OffsetMap (F1), no edits, no normalization, no
lossy projection policies. It is also the D12 witness made real: fragment-local masters are
first-class, lineage is opt-in, and forgotten-base-offset bugs fail loud instead of corrupting.

## Contract sketch (close before implementing — D10/D14 discipline)

Proposed shape, open to correction at contract-closure time:

- `TextSlice.Create(TextMaster parent, TextSpan window)` → validates the window against the
  parent (existing `ValidateSpan` already refuses surrogate-splitting boundaries), mints `Child`
  (a new `TextMaster` over `parent.Slice(window)`), and carries `Parent`, `Window`, `Child`.
  Lineage lives in the `TextSlice` object, never inside `TextMaster` (D12: lineage is opt-in).
- Rebase, child → parent (total, bijective on the child's domain): offset and span forms.
- Rebase, parent → child (partial: requires containment in the window; out-of-window input fails
  loud, it does not clamp — clamping is a policy and policies are F1's business).
- Batch/set rebase: re-address a child-bound `SpanBatch` (and `SpanSet`) into parent
  coordinates. Claims keep kind/level/source/priority/ruleId untouched — rebase is coordinate
  arithmetic, not interpretation. Decide the receiving form (new batch vs staging into a
  caller's parent-bound builder à la D16) at closure time.

Questions the chip must close and record (new D-rows or amendments, your judgment):

1. **Child identity derivation** — caller-supplied `documentId` vs derived
   (`{parent}#{start}-{end}`) vs GUID default. Identity floor already guarantees child/parent
   spans cannot mix; the question is only what the child calls itself and what, if anything, the
   name promises.
2. **Rebase surface grain** — spans/sets only, or batch rebase included. Default expectation:
   include batch rebase; the macro-expansion witness (collect on a fragment, rebase claims to
   the parent) is the whole point.
3. **Slice-of-slice composition** — support directly (rebase composition = offset addition,
   associative) or document as compose-by-hand. Either is fine if recorded.

## Law surface (harness additions)

- Round-trip identity: `ToChild(ToParent(x)) = x` on the child domain; `ToParent(ToChild(y)) =
  y` on the window domain. Offset and span forms.
- Length and Allen preservation: rebased spans keep their lengths; the Allen relation of any two
  child spans equals the relation of their rebased images.
- Scalar-boundary preservation over SMP content (windows through text containing surrogate
  pairs; boundary math must not create a split the parent refuses).
- Out-of-window `ToChild` fails loud; empty-window and whole-extent-window degenerate cases.
- The D12 witness as an integration law: per-line/whole-master collection on the child, rebased,
  equals collection on the parent scoped to the window (for rules whose matches lie inside it) —
  note PerLine caveat: a window that cuts mid-line changes line topology; pick the fixture so
  the law is honest, or state the topology caveat in the contract.
- Cross-master refusal: rebased output validates against the parent, refuses the child, and vice
  versa.

## Riders

- **T2-1 (close + record):** columnar surface visibility — proposed: interned string columns
  stay public, numeric columns stay internal. Verify the batch-rebase implementation doesn't
  force a different answer (in-assembly access to `Starts`/`Ends` is fine), then record.
- **T2-5 (document only):** `PatternRule` positional order (`scope` before `priority`) — add the
  compat note to the canon/README; change nothing.

## Boundaries

- No OffsetMap, no edit plans, no normalization, no projection policies (all F1).
- No caching or registry of slices; no parent pointers inside `TextMaster`.
- Engine additions must pass the D10 admission test; anything interpretive goes to a consumer.
- Keep `src/doccer/README.md`, `planning/decisions.md`, `planning/roadmap.md` in agreement;
  correct canon in place.
- Work on main; targeted commits citing this brief. After engine changes, run
  `brewery/doccer/build-doccer.ps1` (payload refresh is local-only; `packages/` is untracked).

## Done criteria

Contracts recorded; laws green in the harness (state the new check count); README/planning
updated; payload refreshed; report appended below.

---

## Report

Completed 2026-08-02, in-session by the minting agent itself (Fable 5, user-directed inline
"chip"; no subagent dispatch per standing config). Harness **1340 → 1407 checks green**;
payload refreshed via `build-doccer.ps1`.

**Contract closures (recorded as D19; riders as D20 + documentation):**

1. **Child identity — derived and deterministic**: `{parent.DocumentId}#{start}-{end}` at the
   parent's revision, no caller override. Rationale: a GUID default would make `Create`
   nondeterministic, which the doctrine forbids; determinism also buys interop — a recreated
   slice mints a *compatible* master, so batches rebase through either lineage object
   (harness-witnessed). A caller wanting a custom identity mints its own master from
   `parent.Slice(window)`; `TextSlice` is the canonical-lineage path.
2. **Rebase surface grain — asymmetric by principle**: child→parent total (offsets, spans,
   sets, batches, `ToParentInto` weaving — the macro-expansion witness shape); parent→child
   partial and loud for offsets/spans/sets (refuse, never clamp; recipe = intersect with the
   window first). **No parent→child batch projection**: clipping claims to a window requires a
   residual policy, and policies of that kind are F1's business. Sets are exempt from that
   objection because the caller can make containment true via `Intersect` — geometry loses
   nothing; claims would.
3. **Composition — chain, no combinator**: nested slices work through plain chained
   `ToParent`/`ToChild`; nested identity encodes the chain (`doc#2-9#1-5`). A combinator waits
   for a witnessed need (D14).

**Law surface landed** (`SliceMintsAFragmentLocalChild`, `RebaseIsATotalBijection`,
`RebaseCarriesSetsAndBatches`, `CollectionCommutesWithRebase`, `SlicesCompose`): exhaustive
offset/span round-trips over an SMP-bearing window; length + Allen invariance across every
valid span pair; loud refusal of out-of-window and surrogate-splitting geometry; set/batch
carriage with claims untouched except coordinates; two-fragment weaving; frozen-builder and
cross-master refusals; laziness (slicing forces neither topology nor fingerprint).

**Finding worth recording** (now stated in D19 and the README): the brief anticipated a
PerLine caveat for mid-line windows. Testing showed the commutation law holds for per-line
scope too, even with windows cutting mid-line at both edges — the child's line topology is the
parent's clipped at the window edges, exactly as the scoped intersection clips, and both routes
ultimately run `Regex.Matches` over identical sliced region strings. The caveat dissolved into
a stronger theorem than the brief dared claim.

**Riders**: T2-1 recorded as **D20** (interned string columns public, numeric columns internal
via `SpanRecord` views; verified sufficient for batch rebase; F2 revisits). T2-5 documented in
the `PatternRule` remarks and README (bind `scope`/`priority` by name pre-graduation).

**Files**: `src/doccer/Core/TextSlice.cs` (new); harness +5 methods; README contracts/absent
lists + D-range; decisions.md D7 status, D19, D20, Open-list cleanup; roadmap state + queue.
