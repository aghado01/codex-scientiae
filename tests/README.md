# tests/

Pester 5 tests of the `src/` code. This is the home for anything that **asserts** behaviour.
Two sibling folders carry what tests don't: `probes/` holds the standing run-and-eyeball
instruments (calibration probes, ablation harnesses — human-read output, no assertions; their
headers carry the iteration records the config `_doc`s cite), and `scratch/` is the ephemeral,
git-ignored drawer for temp artifacts and one-off throwaway scripts — nothing in it is ever
committed or referenced by durable docs.

## Running

```pwsh
pwsh -File tests/run.ps1                          # whole suite
pwsh -File tests/run.ps1 -Path tests/masks.Tests.ps1   # one file
```

`run.ps1` imports Pester (>=5) by explicit path anchored on `$env:PORTABLE_ROOT`
(`$PORTABLE_ROOT/PowerShell/Modules/Pester`) — needed while the portable-env integration is degraded
and the default module path only surfaces the ancient system Pester 3.4.0. It exits non-zero on any
failure (CI-friendly).

## Conventions

- One `*.Tests.ps1` file per concern; dot-source the module(s) under test in a top-level `BeforeAll`.
- Reproduced bugs and calibration decisions are pinned as named `It` regressions, so they can't
  silently come back.
- Corpus-backed tests (`spine` / `corpus` / `agreement`.Tests.ps1) anchor on the committed fixture
  streams under `tests/fixtures/chunks/` (see that folder's README), so the differential **runs** on a
  fresh checkout. Each keeps a `Set-ItResult -Skipped` guard only as a defensive fallback if a fixture
  goes missing. (These anchors used to point at git-ignored `{paper}/.scratch/*.chunks.jsonl`, which the
  2026-07-01 move to regenerable `.runs/` left dead — silently skipping the whole differential.)
- Paths reach the repo root via `$PSScriptRoot/..`.

| file | covers |
|---|---|
| `masks.Tests.ps1` | `src/masks.ps1` — algebraic laws (over random masks), totality, codepoint safety (SMP/surrogate), the pincer level-lift coincidence. |
| `detectors.Tests.ps1` | `Test-IsMath` / `Test-AlignmentOutsideEnv` / `Test-IsGibberish` / `Get-CorruptionType` on fixed inputs — the reproduced bugs + gibberish calibration. |
| `normalize.Tests.ps1` | `Optimize-MathContent` (idempotency, tag/balance preservation), `math_dirt` mask-algebra value-identity, `Invoke-MarkdownCleanup` idempotency. |
| `corpus.Tests.ps1` | `Group-MathHotspots` (synthetic) + a differential A/B of the rebuilt detectors vs the pre-port versions over the corpus (merge-gate decision, frozen `math_dirt`, detector∘normalize fixed point). |
