# The Gauntlet — dev-loop proving ground

**Established 2026-07-15.** The standing home for the converter dev loop's calibration and
regression corpora. Every figure-lane knob, veto, and metric is calibrated and gated here BEFORE it
touches the wider corpus — the name is the contract: a change survives the gauntlet or it doesn't
land. The gate is `src/pdf-converter/Compare-FigureCounts.ps1` (two-population, pig vs LaTeX
oracle); the offline harness is `scratch/banded-ablation.ps1`; the batch grinder is
`src/ingest-batch.ps1` (a GENERAL ingestion utility, not a gauntlet fixture — location-driven
targets: any pdf/tarball/paper-dir/group-dir, explicit files imperative for hot-example loops;
greedy parallel pool, one child pwsh per job, intake-guarded, pre-deployment tectonic warmup;
slated for librarian-MCP exposure); forward plan lives in the dated frontier briefs
(`issues/clustering/frontier-YYYYMMDD.md`).

## The standard battery

Every converter dev push runs against the gauntlet — all three corpora, by role:

| corpus | role | in the loop |
|---|---|---|
| `gauntlet/ph-zigzag` | **calibration** (diagram-heavy, 10 papers) | every increment — the `Compare-FigureCounts` default group |
| `gauntlet/voroninski` | **calibration** (plot/figure-heavy, 23 papers) | every increment — `Compare-FigureCounts -Group gauntlet/voroninski` |
| `gauntlet/mapper` | **transport** (out-of-sample, 10 papers) | milestone runs, gate UNTOUCHED — no knob may ever be fitted here |
| `gauntlet/kisungyou` | **transport** (out-of-sample, 23 papers, PDF + LaTeX source per paper) | milestone runs once gate-capable, gate UNTOUCHED |
| `gauntlet/spc` | **transport, PDF-only stress** (8 papers, 1995–2020 journal PDFs) | oracle-FREE instruments only — the LaTeX-oracle gate is impossible by construction |

`scratch/banded-ablation.ps1` (offline re-cluster + gate + sentinels) spans the two calibration
corpora and is the harness for any knob decision. mapper is not yet gate-capable (0/10 pig runs;
oracle sidecars pending, 9/10 possible — 2504.09042 is PDF-only): filling that gap is the
battery's first standing task (frontier-20260715 §2.5 item 6), after which the transport run
becomes part of every milestone. kisungyou and spc carry the same gate-capability debt (0 pig
runs; kisungyou additionally 0/23 oracle sidecars). spc's oracle gap is TOTAL and permanent —
PDF-only by construction — so its instruments are the oracle-free ones (`known_role_frac` and the
IR health signals, the render/lint gates downstream); it exists to stress exactly the intake the
LaTeX-oracle corpora can't: old typography, journal-house PDF producers, no ground truth.

**The battery accumulates.** The gauntlet is the standing intake point for new testing and
stressing corpora (user direction, 2026-07-15). A new corpus enters as **transport by default** —
it satisfies the membership contract below and runs at milestones with the gate untouched — and is
promoted to calibration only by an explicit decision recorded in the current frontier brief.
Promotion widens what knobs may be fitted against, so it is a deliberate act, never a drift; the
contract's own words are the reason ("a knob calibrated everywhere is validated nowhere").

## Layout and addressing

`gauntlet/{corpus}/{slug}/` under the ingestion root — a sibling grouping to `corpora/` and
`compendia/`, addressed ingestion-root-relative like any curated group (`gauntlet/voroninski/…`).
Each paper carries its staged source + oracle sidecars beside it; regenerable pig/tex IR stages
under the git-ignored `{slug}/.runs/{stamp}/` (the `**/.runs/` ignore is location-agnostic).
Publish topics are decoupled from source groups, so a corpus living here can still publish to its
usual vertical.

**Dev substrate, not reader shelf (deliberately outside the CONTENTS telescope).** The gauntlet
is ostensibly ingestion but is really the dev substrate for building the librarian's tools. Its
consumers are dev agents, which see the tree directly (membrane MCP document discovery + the
filesystem); telescoping CONTENTS.md navigation is a READER mechanism for drilling into published
corpora for intel, and the gauntlet is not that — so it carries no telescope entry, and none
should be added. The reader plane meets these papers only where publish sends them (their usual
verticals), where the reader navigation picks them up like any other published document.

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

## Accession record (transport-by-default, per the accumulation rule)

- **2026-07-15 — `kisungyou`** (**download COMPLETE — final census 23 papers**): PDF + arXiv
  LaTeX source tarball staged per paper, all 23 pairs sniff-verified (ustar magic via gzip
  stream + `%PDF` headers; no 1404-class gzip-single-file cases). Corpus dir lowercased from
  `KisungYou` at intake for sibling parity. Intake-hygiene note: a premature ingest ran against
  the raw materials mid-download; its residue (nested `{slug}/{slug}/` conversion PNGs under 5
  papers, zero `.runs`) was swept after PNG-only verification — the tree holds exactly the
  source pairs. **Debts RETIRED same day** (first grind: 46/46 jobs ok — 23 pig runs + 23 latex
  conversions with oracle sidecars; one instructive outlier: 2106.06375v1 p5 carries 536,517
  vector paths — a marker-by-marker scatter — and its pig job ground 79 min, naming the
  monster-path-cloud stress class and motivating a per-job timeout). Transport-gate READY.
- **2026-07-15 — `spc`** (8 papers): the SPC lineage (BWD1995/1996/1997, WBD1998, Domany1999,
  Chaure2018, YG2019, PKWang2020) — the battery's **first PDF-only testbed**. `%PDF` headers
  1.1–1.6 verified at intake; PDFs folded into per-slug dirs (`spc/{slug}/{slug}.pdf`) so pig
  runs land in `{slug}/.runs/` beside their source. No LaTeX exists: oracle gap is documented as
  corpus-total; instruments are oracle-free only. **Pig-run debt RETIRED same day** (the batch
  grinder's first grind: 8/8 ok, 2.9 min wall on 4 workers). First stress signals, unscored
  (no oracle): BWD1997 60 regions / 7 captioned (fragmentation pressure on old typography);
  YG2019 + WBD1998 0 captioned of 22 regions each (caption attachment finds nothing on old
  layouts); C′ ejected live on 4/8 papers.

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
