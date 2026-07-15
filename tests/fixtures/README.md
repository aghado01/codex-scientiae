# tests/fixtures

Durable, committed test fixtures. Small on-disk artifacts the suites read directly, so a test never
depends on regenerable working output.

## chunks/ — corpus-anchor chunk streams

`spine.Tests.ps1`, `corpus.Tests.ps1`, and `agreement.Tests.ps1` each carry a **corpus differential**:
a read-only pass that replays the fidelity detectors over real preprocessed chunk-JSONL and asserts
share-table / totality / determinism / non-gating invariants. Those Its used to anchor on
`{paper}/.scratch/{slug}.chunks.jsonl`. The `.scratch` layout was retired 2026-07-01 for runstamped
`{paper}/.runs/{stamp}/` — which is **git-ignored and regenerable** — so the anchors went dead and the
`Test-Path` guards silently skipped the entire differential (`HasCorpus = $false`). These two committed
streams are the durable anchor instead.

| file | pool | provenance |
|------|------|------------|
| `chunks/legacy.chunks.jsonl` | LEGACY (44 chunks) | curated real chunks from `voroninski/2008.10579v1`, each **stamped** `math_dirt = Legacy-MathDirt(content)` (the pre-refinement residual) |
| `chunks/current.chunks.jsonl` | CURRENT (30 chunks) | curated real chunks from `voroninski/1109.4499v1` (PhaseLift), left exactly as the current engine emits them (refined; no stored `math_dirt`) |

`corpus.Tests.ps1` needs **both** provenances: the legacy pool defines the old-vs-new detector
differential and the "stored `math_dirt` == legacy residual" pin (both would be vacuous on current
data, which no longer stores `math_dirt`); the current pool exercises the whole-corpus engine-internal
invariants on refined output. `spine.Tests.ps1` and `agreement.Tests.ps1` are provenance-agnostic and
read both files together.

The legacy source is `2008.10579v1` specifically because it still carries genuine `MathLatexRx` residue
(so the stamped-residual pin bites: 15/44 chunks have `math_dirt >= 1`, 8 trip the `unwrapped_math`
inventory branch) plus clean / gibberish / unbalanced gate kinds and 4 sanctioned gibberish-recall flips
(so the differential is a real regression guard). `1109.4499v1` was normalized to zero residue by the
engine, making it authentic current-engine output.

### Invariants (machine-verified before each chunk is written)

Every chunk in both files provably satisfies, at generation time:

- old-vs-new differential within the sanctioned band — `typeChange = rejectToAccept = nonGibberishFlip = 0`
  (the only permitted flip is the gibberish-recall `accept -> reject`);
- refined `math_dirt` ≤ legacy residual (`refinedExceeds = 0`);
- clean formula chunks survive `normalize` (the detector-∘-normalize fixed point; `cleanBroke = 0`);
- gate == first inventory corruption-signature, and never throws (the spine share-table);
- agreement total / in `[0,1]` / deterministic / non-gating.

Files are UTF-8 **without BOM** (the house backbone).

### Regenerating

The committed `.jsonl` is the source of truth. To re-mint both from the newest preprocessed run of each
source paper (and re-verify every invariant, failing loud on any violation):

```
pwsh -File tests/fixtures/regenerate-chunks.ps1
```

`regenerate-chunks.ps1` resolves the newest `.runs/{stamp}/` for each source paper dynamically, so it
stays runnable as the papers are re-preprocessed. It is a maintenance tool, not a test — Pester discovers
only `*.Tests.ps1`, so `run.ps1` never picks it up. Its `Old-*` detectors are copied verbatim from
`corpus.Tests.ps1`; keep them in lockstep if that file's baseline changes.
