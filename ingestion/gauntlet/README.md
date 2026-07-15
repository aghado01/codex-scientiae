# The Gauntlet — dev-loop proving ground

**Established 2026-07-15.** The standing home for the converter dev loop's calibration and
regression corpora. Every figure-lane knob, veto, and metric is calibrated and gated here BEFORE it
touches the wider corpus — the name is the contract: a change survives the gauntlet or it doesn't
land. The gate is `src/pdf-converter/Compare-FigureCounts.ps1` (two-population, pig vs LaTeX
oracle); the offline harness is `scratch/banded-ablation.ps1`; forward plan lives in the dated
frontier briefs (`issues/clustering/frontier-YYYYMMDD.md`).

## Layout and addressing

`gauntlet/{corpus}/{slug}/` under the ingestion root — a sibling grouping to `corpora/` and
`compendia/`, addressed ingestion-root-relative like any curated group (`gauntlet/voroninski/…`).
Each paper carries its staged source + oracle sidecars beside it; regenerable pig/tex IR stages
under the git-ignored `{slug}/.runs/{stamp}/` (the `**/.runs/` ignore is location-agnostic).
Publish topics are decoupled from source groups, so a corpus living here can still publish to its
usual vertical.

## Membership contract

A gauntlet corpus declares:

- **Oracle coverage** — `{slug}.oracle-counts.json` (schema/2, two-population) for the figure gate;
  `{slug}-latex.md` oracle where LaTeX source exists. Gaps documented (e.g. PDF-only submissions).
- **Fresh pig runs** — the gate and the ablation harness re-cluster from lanes on disk.
- **A role: calibration vs transport.** Calibration corpora may have knobs fitted against them;
  transport corpora are out-of-sample and run the gate UNTOUCHED. The distinction is the whole
  point — a knob calibrated everywhere is validated nowhere.
- **Sentinel pages**, where the corpus carries them (see the banded-ablation sentinel set:
  targets 1608 p8/p9, 2112 p8; guards 2006 p11, 2008 p8/p12, 2204 p12, 2501 p12, 2603 p8/p11).

## Migration record (all three corpora IN, 2026-07-15)

1. `gauntlet/voroninski` (from `corpora/voroninski`) — 23 papers, **calibration** (PRIMARY 0.35,
   18/23 exact, 0 over).
2. `gauntlet/ph-zigzag` (from `compendia/ph-zigzag`) — 10 papers, **calibration**, diagram-heavy
   (PRIMARY 0.7, 7/10 exact, 0 over).
3. `gauntlet/mapper` (from `compendia/mapper`) — 10 papers, **transport** (out-of-sample; gate not
   yet run — needs pig runs + oracle sidecars, 9/10 capable, 2504.09042 is PDF-only). The
   out-of-sample test the em-normalized knob philosophy predicts we pass.

Post-move verification: `Compare-FigureCounts` reproduced PRIMARY row-exact on both calibration
corpora at the new paths (0.7 / 0.35, 0 over). Live-gate SECONDARY read 5.4/11.57 vs the recorded
5.6/11.74 — NOT a migration artifact: the recorded baselines are the offline harness's re-cluster
with current code, the live gate scores frozen on-disk runs that mostly predate recent landings;
the two converge on full-corpus regen.

## Migration blast radius (sweep APPLIED 2026-07-15 — 37 replacements across 23 script files;
kept as the template for future migrations; line refs drift)

Functional — update when migrating:
- `src/pdf-converter/Compare-FigureCounts.ps1` — `$Group` defaults at :36 and :178
  (`compendia/ph-zigzag`).
- `scratch/banded-ablation.ps1` — `$Groups` default `@('corpora/voroninski', 'compendia/ph-zigzag')`.
- The scratch calibration probes (~16 files, one group ref each — some functional defaults, some
  header doc): band-weld / bottom-band / caption-bootstrap / caption-diag / clip-inflation /
  consensus-ablation / furniture / inflow / interior-cut / letters / persistence-band / prefix-tail /
  stray-eject / stream / verify-b1 / harvest-2403.
- Test fixtures on the legacy `.scratch/` layout: `tests/agreement.Tests.ps1:45`,
  `tests/corpus.Tests.ps1:48,53`, `tests/spine.Tests.ps1:36` (chunks.jsonl under
  `corpora/voroninski/{slug}/.scratch/`).

Cosmetic — fix opportunistically, never rewrite history:
- `src/mcp-server.ps1` tool-description examples (5 refs, e.g. `compendia/ph-zigzag/2403.08110v4`);
  paper resolution itself is generic ingestion-root-relative and does not care.
- `issues/` briefs are the historical log — leave their paths as written.

Unaffected by construction:
- Membrane lanes (curated-group addressing is generic), `runs.ps1` newest-run-wins (per-paper),
  oracle sidecars (move with their papers), publish destinations (topic ≠ source group),
  `.gitignore`.

Mechanics: `git mv` renames the directory wholesale, so ignored `.runs/` ride along; **restart the
live membrane MCP server after moving** (document discovery happens at server start).
