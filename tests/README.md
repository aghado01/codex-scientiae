# tests/

Pester 5 tests of the `src/` code. This is the home for anything that **asserts** behaviour;
`scratch/` is for one-off run-and-eyeball probes (load a corpus file, dump JSON) that assert nothing.

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
- Corpus-backed tests (`corpus.Tests.ps1`) `Set-ItResult -Skipped` when no document is preprocessed to
  the `.scratch/*.chunks.jsonl` stage, so the suite is green on a fresh checkout.
- Paths reach the repo root via `$PSScriptRoot/..`.

| file | covers |
|---|---|
| `masks.Tests.ps1` | `src/masks.ps1` — algebraic laws (over random masks), totality, codepoint safety (SMP/surrogate), the pincer level-lift coincidence. |
| `detectors.Tests.ps1` | `Test-IsMath` / `Test-AlignmentOutsideEnv` / `Test-IsGibberish` / `Get-CorruptionType` on fixed inputs — the reproduced bugs + gibberish calibration. |
| `normalize.Tests.ps1` | `Optimize-MathContent` (idempotency, tag/balance preservation), `math_dirt` mask-algebra value-identity, `Invoke-MarkdownCleanup` idempotency. |
| `corpus.Tests.ps1` | `Group-MathHotspots` (synthetic) + a differential A/B of the rebuilt detectors vs the pre-port versions over the corpus (merge-gate decision, frozen `math_dirt`, detector∘normalize fixed point). |
