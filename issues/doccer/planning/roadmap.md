# Doccer roadmap — state of work and next steps

Living document — current truth, corrected in place. Decisions and the question ledger live in
[decisions.md](decisions.md); arguments in the runstamped briefs under [../briefs/](../briefs/);
evidence in [../discussions/](../discussions/).

## Where the work stands (2026-08-02)

Engine at `src/doccer` (`CodexSci.Doccer`), delivered via `brewery/doccer` recipes into
`packages/doccer` (HDBSCAN pattern). Contract harness: `tests/doccer/Program.cs`, **1340 checks
green** (`dotnet run --project brewery/doccer/Doccer.Tests.csproj`).

T2-2 closed as **D18** (2026-08-02, user-confirmed with the boundary refinement): regex options
union `CultureInvariant` in the `PatternRule` constructor itself, so inventory rules and direct
DLL callers are one collector contract and matching never inherits ambient culture (Turkish-I
witness in the harness). Options augment that baseline, never replace execution policy —
`ECMAScript` is rejected as a different matching profile (a contract choice: net10 itself
permits the combination), and the guarantee is ambient-culture independence, not immunity to
runtime/Unicode case-table changes. `packages/` is untracked as of `50988b03`, so payload refreshes are
local-only: run `build-doccer.ps1` after engine changes and let `doccer.manifest.json` state
what revision the on-disk payload represents.

The sol review
([sol-doccer-review-20260802](../discussions/sol-doccer-review-20260802.md)) was answered the
same day: collection is now transactional (D16), capture-group identity and undefined enum casts
fail loudly (D9), empty-span intersection is set-theoretic with `FindContaining` as the named
point query (D17), the previously advertised-but-untested surfaces (`IntervalJoins.Join`,
`TextTopology.Project`, `EmitRuns` custom comparer) have direct checks, and the stale
`packages/doccer` payload was refreshed — `build-doccer.ps1` now smoke-tests the delivered
DLL/CLI and writes `doccer.manifest.json` (source commit, timestamp, TFM/runtime, harness
result).

Implemented: identified immutable masters (raw-code-unit fingerprints; lazy fingerprint +
topology; fragment-local masters first-class); total scalar tiling with explicit
malformed-surrogate atoms; derived run views under explicit break-keys; overlap-preserving
columnar `SpanBatch` with interned string columns; master-bound `SpanSet` algebra; the 13 Allen
relations + reference join; deterministic laminar extraction with equal-geometry grouping and
crossing residue; suppression as `Admitted`/`Excluded` queries; scoped regex collection with
load-time validation and `WholeMaster`/`PerLine` execution scopes (PerLine = content extent,
terminator excluded); JSONL inventory loader with per-line provenance and a source-generated
JSON context (the future CLI wire format's seed); intrinsic + declarative validation and Tier-1
invariants. Precision on "Tier-1": the callable runtime runner (`ValidateIntrinsic`) checks atom
coverage and claim bounds only; reconstruction, line consistency, suppression laws, resolution
determinism, and interning round-trip are protected as harness **test laws**, not as callable
runtime checks. Exposing them through a runtime Tier-1 runner is a named candidate contract,
unscheduled.

Tranches 0 (correctness), 1 (decision canon + README), 2 (substrate completion) are **done**.
D15 landed post-Tranche-2. The founding run's brief carries the full history.

## Sequencing doctrine

Engines first; **codex-scientiae adapters last**. scriba-scientiae was aborted — codex is
renovated from the inside, so its converter/LaTeX lanes are the living lanes, and they become
thin consumers of doccer only after the doccer-native surface exists. Contracts gate work;
consumers witness (D14). Per-topic containment: `planning/` = living truth; `briefs/` = one
small runstamped brief per chip iteration, guidance + that chip's report appended on completion;
`discussions/` = captured evidence.

## Queue

Two sequencing corrections from the sol review are folded in below: Tranche 3 was too broad for
one chip (its pieces have different law surfaces and failure modes), and the harvest survey must
precede the first durable CLI contract — the survey feeds the verb list, so building wire
records first risked freezing the wrong task grain.

1. **Tranche 3, split into four chips** (sequence within: a → b, c/d independent):
   - **3a — slice/rebase:** `TextSlice` + rebase (total bijective case, no OffsetMap
     dependency). Parked riders: positional-order compat note (T2-5), columnar visibility
     (T2-1).
   - **3b — group + project:** `Group` and `Project` with basis stamping (D7). Parked rider:
     selector-shape note (T2-4).
   - **3c — gap cadence:** the first named density measure (D8, mdnav template) — declares
     numerator, denominator, window basis, boundary policy, exclusions.
   - **3d — priority-aware lookup:** priority-aware sorted lookup over the frozen batch.
2. **Harvest survey** (before any durable CLI contract): sweep codex-scientiae and other sources
   — masks.ps1 operations, latex.ps1 span producers, membrane density/mask calculus, md-repair
   byte offsets, mdnav constructs — mapping each to the doccer primitive or verb it implies.
   Anticipate-the-consumer: capabilities resurface as domain-agnostic utilities first. The
   survey's output freezes the verb list and task grain the CLI then commits to.
3. **First CLI verbs (D13):** `doccer collect` (inventory + scope in, claims JSONL out) and a
   span-algebra verb — the macro-expansion witness as a working demo. user-repl anatomy:
   hand-rolled router, per-verb files with no hot path, wire format extending the loader's JSON
   context with span/claim payloads, run manifests where verbs produce artifacts. The current
   `inspect`/`relate` commands are **disposable developer diagnostics** predating D13 (`relate`
   is operation-grain; `inspect` serializes an anonymous object outside the source-generated
   wire context) — reconcile or delete them when `collect` lands; they are not contracts.
4. **Adapters (last):** masks.ps1 reborn as a thin PS veneer over the DLL; LaTeX consumers
   migrated as thin consumers, old behavior as witness. This work generates F1's honest
   edit-plan requirements as a byproduct.
5. **Proactive contract closures, at discretion (D14):** F-UCD data-provenance record →
   block/script facts; OffsetMap pressure-test (segment granularity, ambiguity encoding) if
   judged ripe; register columns only once the math-register design stabilizes; a callable
   runtime Tier-1 runner exposing the harness-law checks, if a consumer wants them at run time.

Maturity-gated beyond that: F2 persisted batches → F4 indexed joins → F5 Tier-2/3 agreement
scoring → F6 markdown adapter and the mdnav succession (oracle harness on the doc-dive
fixtures; exceed mdnav precisely at its collapse points; conserve its instrument virtues).

## Open questions in play

- Full open list with context: see [decisions.md § Open](decisions.md). (T2-2 closed as D18;
  T2-1/T2-4/T2-5 ride the Tranche-3 chips.)

## Standing context for future sessions

- Decision canon and this roadmap are the entry points; `src/doccer/README.md` is the in-repo
  contract surface and must stay in agreement.
- MarkPig legwork = historical evidence, never amended. mdnav relation = succession + spec
  witness, no cross-talk (its three strata: pseudo-parsing → supplanted eventually; instrument
  verbs → spec witness; doc-dive skill semantics → permanently above the engine).
- Doccer is expected to graduate cross-project; anything a graduated doccer would need must live
  in the C# surface, not PowerShell (D13 boundary test).
