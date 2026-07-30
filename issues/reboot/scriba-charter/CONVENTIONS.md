# Conventions — naming, organization, enforcement

**Status:** normative (2026-07-20). Codifies the conventions that emerged organically in
codex-scientiae — the best of what worked, made mandatory at the start this time instead of
regretted at the end. The enforcement loop (§6) is what makes this a standard rather than a wish.

## §1 Directory layout

```
docs/          canonical role documents (UPPERCASE.md: DESIGN, CONVENTIONS, later STANDARDS)
src/{lane}/    one directory per lane; no loose files at src/ root (see migration map §5)
stores/        world registers (rules-as-data) — ONE copy, at root; shared by PS and C# tiers
gauntlet/      CHARTER.md + battery/{corpus}/ + runs/
tests/         mirrors src/: tests/{lane}/{unit}.Tests.ps1 + tests/fixtures/
issues/        briefs: issues/{topic}/{kebab-name}.md, dated when superseding
scripts/       build/setup entry points
lib/           vendored binaries (pdfpig, tools)
```

Lane names are short nouns, lowercase, no suffix: `core`, `pdfdig`, `texdig`, `membrane`,
`sourcing`, `gates`, `mcp`, `hdbscan`, `probes`. Directories never mixed-case (the KisungYou
lesson). One concept, one home: a file that two lanes need lives in `core`, not in copies —
the current root `stores/` vs `src/pdfdig/stores/` duplication is resolved in favor of **root**
(stores are a cross-tier contract, not a pdfdig implementation detail).

## §2 File naming

- **Dot-source libraries:** `{lane}-{stage}.ps1`, lowercase-kebab (`pdfdig-classify.ps1`).
  The lane prefix is kept even inside the lane dir: basenames stay repo-unique (editor tabs,
  grep, dot-source lines read unambiguously).
- **Executable entry points:** PascalCase Verb-Noun matching the exported function
  (`Invoke-Pdfdig.ps1`, `Compare-FigureCounts.ps1`). The case difference IS the signal:
  kebab = library, PascalCase = you can run this.
- **Probes:** `{subject}-{kind}.ps1` where kind ∈ `calib` (iteration record in header),
  `probe` (one question), `diag` (inspection), `ablation` (harness).
- **Tests:** `{unit}.Tests.ps1` under `tests/{lane}/`, mirroring the src path. Committed
  fixtures under `tests/fixtures/` — never live `.runs/`.
- **C#:** PascalCase files, one public type per file, namespace `Scriba.{Lane}` (decision §8.4
  of DESIGN.md pending — this is the default).
- **Docs:** canonical role docs UPPERCASE (`README.md`, `DESIGN.md`, `CHARTER.md`); everything
  else lowercase-kebab. Briefs that supersede carry dates: `frontier-YYYYMMDD.md`. External
  feedback transcripts: `{source}-{topic}.md` (`sol-experimental-design-and-measurement.md`).

## §3 Artifact naming (the data contract)

- Per-paper sidecars beside the source: `{slug}.{role}.{ext}` — `{slug}.oracle-counts.json`,
  `{slug}-latex.patch.jsonl`. Deliverables: `{slug}-latex.md`, `{slug}-membrane.md`; promotion
  writes bare `{slug}.md` at the destination.
- Regenerable IR NEVER beside the source: `.runs/{yyyyMMdd_HHmmss}/{lane}/` (git-ignored,
  location-agnostic ignore pattern), newest-wins, pinnable as `{slug}@{stamp}`.
- Lane files inside a run: `{slug}.{lane-artifact}.jsonl` (`{slug}.letters.jsonl`,
  `{slug}.figures.jsonl`) + a run manifest (`pig-run.json` idiom: per-mechanism counters).
- All content I/O UTF-8-no-BOM; JSONL stages carry `.jidx` + `.sig`.

## §4 Config and stores (epistemic homes — DESIGN.md §2.5)

- `stores/*.jsonl` — world registers only; every entry provenance-tagged with examples; loader
  throws on malformed lines. Admission test in `stores/README.md`.
- Config blocks — every section's `_doc` declares its class: `structural` (reason geometrically)
  | `fitted` (names its probe + gate commit) | `flag` (lifecycle: default-OFF → gate → ON).
  Absent block = disabled, always.
- Never: semantic judgments laundered into config as special cases; content regexes as rules.

## §5 Migration map (the flat pile → lanes; do under version control)

| current (src/ root) | destination |
|---|---|
| jsonl.ps1, runs.ps1, md-register.ps1, crawl.ps1, pdf-raster.ps1 | `core/` (cross-lane substrate) |
| latex-ingest.ps1, latex.ps1, tex-render.ps1, tikz-render.ps1 | `texdig/` |
| project-ir.ps1, headings.ps1, collapse.ps1, zones.ps1, sections.ps1, normalize.ps1, fidelity.ps1, repair.ps1, preprocess.ps1, finalize.ps1, serving.ps1, restructure.ps1, md-repair.ps1, md-cleanup.ps1, masks.ps1, enrichment.ps1, playbook.ps1, publish.ps1, pdfdig-adapter.ps1 | `membrane/` (adapter = the intake boundary, lives with its consumer) |
| render-check.ps1, md-lint.ps1 | `gates/` |
| arxiv*.ps1/json/md, scholar*.ps1/json/md, openalex.ps1, semanticscholar.ps1, scihub-get.ps1, scihub-mirrors.json | `sourcing/` |
| mcp-server.ps1, arxiv-server.ps1, scholar-server.ps1 | `mcp/` (thin protocol shells; logic stays in lanes) |
| ingest-batch.ps1, ingest-batch-worker.ps1, benchmark.ps1, corpus-audit.ps1 | `ops/` (or `core/` — decide once) |
| PROCEDURE.md, SETUP.md, src/README.md | `docs/` (roles: procedure, setup) |

Tests migrate in the same move to their mirrored dirs. `src/pdfdig/stores/` merges into root
`stores/` (§1). Empty placeholder dirs get their files in the same commit that creates them —
no standing empty skeletons.

## §6 Enforcement — discipline as a test, not a virtue

`tests/conventions.Tests.ps1` asserts, and fails loud:

1. No loose `.ps1`/`.cs` at `src/` root (post-migration).
2. Basename uniqueness repo-wide for `.ps1`.
3. Case rules: kebab for libraries, Verb-Noun PascalCase only for files exporting that function;
   no mixed-case directories.
4. Every `src/{lane}/{x}.ps1` has `tests/{lane}/` present (lane-level mirroring).
5. Every store line validates against its schema; every config section carries `_doc` with an
   epistemic class.
6. No `.runs/` content tracked by git; no BOM in any tracked text file.

The audit runs in CI (`.github`) and locally via `tests/run.ps1`. Conventions change by editing
THIS file and the test in the same commit — the pair is the standard.

## §7 The regret, answered

The codex mess was discovery exhaust — unavoidable while the shapes were unknown. What was
actually missing was not foresight but an *enforcement loop*: conventions written down anywhere
+ a test that fails when violated. That loop costs an afternoon now and nothing later. The rule
of thumb going forward: **any convention worth stating is worth a failing test; anything not
worth a test is style, not convention.**
