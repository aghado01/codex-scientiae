# TeXdig Cut 1: Census Engine Implementation Plan

Implementation plan for **Cut 1 of the TeXdig census engine** per [`issues/TeXdig/briefs/engine-cut1-census-20260811_021819.md`](file:///D:/aghado01/codex-scientiae/issues/TeXdig/briefs/engine-cut1-census-20260811_021819.md), [`src/TeXdig/README.md`](file:///D:/aghado01/codex-scientiae/src/TeXdig/README.md), and [`src/TeXdig/core/types.ts`](file:///D:/aghado01/codex-scientiae/src/TeXdig/core/types.ts).

This cut builds the closed, span-addressed two-witness census substrate over deposited LaTeX source trees, emitting the **evidence tier** (`sources.jsonl`, `entities.jsonl`, `claims.jsonl`) and **audit tier** (`coverage.json`, `diagnostics.jsonl`, `summary.json`).

---

## User Review Required

> [!IMPORTANT]
> **First Light Target**: As specified in the brief, the initial run will execute on one specific slug (`ingestion/gauntlet/ph-zigzag/2111.15058v3`). This slug exercises multiple directories with spaces, both `.bbl` and `.bib` witnesses, and complex mathematical macro environments.
>
> **Gate 1 & 2 Reporting**: The engine computes Gate 1 (Coverage: total claimed + residue equals source length) and Gate 2 (Witness Agreement: fusion states). Residue and disagreements are recorded as honest diagnostic evidence in `coverage.json` and `diagnostics.jsonl` rather than failing the run.

---

## Proposed Changes

### Core & Dependencies Layer (`src/TeXdig/core/`)

The core type declarations and contracts have landed in `src/TeXdig/core/types.ts` and `src/TeXdig/core/contracts.ts`. We will add a dependency loader helper to dynamically resolve `@unified-latex` and `latex-utensils` from the caller-supplied `--deps` path (`packages/node/node_modules`) without ambient package resolution.

#### [NEW] [loader.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/core/loader.ts)

- Dynamically loads `@unified-latex/*` and `latex-utensils` packages from `--deps` path using `createRequire`.
- Exports typed interfaces for parser functions.

---

### Pipeline Modules (`src/TeXdig/census/`)

Each module executes in strict feed-forward pipeline order:

#### [NEW] [stratify.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/stratify.ts)

- Stratifies comments and verbatims before any include-graph traversal or parsing.
- Handles `%` comments, inline `\verb|...|`, and verbatim environments (`verbatim`, `lstlisting`, `minted`, `alltt`).
- Returns:
  1. `comment` and `verbatim-inline` / `verbatim` entity candidate records.
  2. Masked string representation for comment-free include graph resolution and lexical scanning.

#### [NEW] [source-graph.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/source-graph.ts)

- Scans deposited `{slug}-tex/` directory.
- Calculates UTF-16 lengths and SHA-256 digests for all files.
- Reads `article.json` to identify `entrypoint`.
- Recursively traverses `\input`, `\include`, `\subfile`, `\bibliography`, `\addbibresource`, `\bibliographystyle` in stratified text to construct the project include graph.
- Handles case-insensitive on-disk matching (canonical on-disk casing wins + emits `census/include-case-mismatch`).
- Classifies roles (`entrypoint`, `included`, `bbl-sidecar`, `bibliography-resource`, `bibliography-style`, `class-or-style`, `asset`, `unreachable-tex`).
- Identifies `parsed: true` files (`entrypoint`, `included`, `bbl-sidecar`, `bibliography-resource`).

#### [NEW] [scan-latex.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/scan-latex.ts)

- Lexical scanner witness for LaTeX and `.bbl` files.
- High-fidelity tokenization extracting exact UTF-16 spans for:
  - Control sequences (including non-alpha like `\1`, `\%`, `\\`, `@`-names under `\makeatletter`).
  - Environment fences (`\begin{...}`, `\end{...}`).
  - Math delimiters (`$...$`, `$$...$$`, `\(...\)`, `\[...\]`).
  - Envelope markers (`\documentclass`, `\section`, `\title`, `\author`, etc.).

#### [NEW] [scan-bib.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/scan-bib.ts)

- Lexical scanner witness for `.bib` files.
- Extracts lexical spans for `@entry_type{...}`, `@string`, `@preamble`, `@comment`, and inter-entry text.

#### [NEW] [parse-latex.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/parse-latex.ts)

- Parser witness for LaTeX using `unified-latex`.
- Two-pass parsing:
  - _Pass 1_: Parse with standard context; discover macro definitions (`\newcommand`, `\renewcommand`, `\DeclareMathOperator`, `\NewDocumentCommand`, `\def`, `\let`) and custom environment definitions (`\newtheorem`, `\newenvironment`, `\newfloat`).
  - _Pass 2_: Reparse with registered signatures for accurate argument attachment.
- Traverses AST to produce parser witness records with node types, math-mode flags, and argument spans.

#### [NEW] [parse-bib.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/parse-bib.ts)

- Parser witness for BibTeX using `latex-utensils.bibtex.parse()`.
- Extracts structured entries, `@string` definitions, `@preamble`, `@comment`, and typed field values (`text`, `number`, `abbreviation`, `concat`).

#### [NEW] [reconcile.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/reconcile.ts)

- Reconciles lexical witness sightings and parser AST nodes.
- Computes agreement states (`agreed`, `lexical-only`, `parser-only`, `conflict`).
- Synthesizes hulls for parser nodes with positionless arguments (`spanProvenance: "synthesized-hull"` + `census/span-synthesized` diagnostic).
- Mints deterministic IDs (`ent:{kind}@{sourceId}:{startUtf16}-{endUtf16}`).

#### [NEW] [claims.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/claims.ts)

- Computes three-pillar overlays:
  - `envelope`: structural markers (`\documentclass`, `\section`, `\title`, `\author`).
  - `spine`: positive text runs (all non-empty whitespace and text runs from raw source that are not markup syntax).
  - `fence`: environments, math carriers, verbatim, comments, bib entries/@string/@preamble.

#### [NEW] [coverage.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/coverage.ts)

- For every parsed file (`parsed: true`):
  - Calculates union of claimed UTF-16 intervals.
  - Computes residue spans (unclaimed code units).
  - Evaluates Gate 1 (Coverage accounting) and Gate 2 (Witness agreement).
  - Returns `SourceCoverage` and summary statistics.

#### [NEW] [emit.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/census/emit.ts)

- Formats and writes the 6 emitted stores:
  - `sources.jsonl`
  - `entities.jsonl`
  - `claims.jsonl`
  - `coverage.json`
  - `diagnostics.jsonl`
  - `summary.json`
- Slices raw UTF-16 source text directly from buffer (`text = rawSource.slice(startUtf16, endUtf16)`), never calling `printRaw`.
- Strict UTF-8 without BOM, LF row termination.

---

### CLI Entrypoint (`src/TeXdig/cli/`)

#### [NEW] [census.ts](file:///D:/aghado01/codex-scientiae/src/TeXdig/cli/census.ts)

- CLI entrypoint:
  `node src/TeXdig/cli/census.ts --article <dir> --deps <dir> --out <container-dir>`
- Validates `article.json` exists and parses valid JSON.
- Coordinates the pipeline and writes output stores into `--out`.

---

### Tests & Mini-Fixtures (`tests/fixtures/texdig/`, `tests/TeXdig/`)

#### [NEW] [tests/fixtures/texdig/mini_article/](file:///D:/aghado01/codex-scientiae/tests/fixtures/texdig/mini_article)

- Mini fixture testing:
  - Stratification (commented-out `\input` of non-existent file).
  - Casing mismatch resolution (`\input{Intro}` -> `intro.tex`).
  - Synthesized hulls on macro arguments (`\newcommand{\pair}[2]{...}`).
  - BibTeX `@string` and entry parsing.

#### [NEW] [tests/TeXdig/Census.Tests.ps1](file:///D:/aghado01/codex-scientiae/tests/TeXdig/Census.Tests.ps1)

- Pester container asserting store shapes, schema compliance, gate reporting, and mini-fixture invariants.

---

## Verification Plan

### Automated Tests

1. Run Pester test suite on TeXdig:
   ```pwsh
   pwsh -File tests/run.ps1 -Path tests/TeXdig/Census.Tests.ps1
   ```
2. Verify with multilingual batch runner:
   ```pwsh
   pwsh -File tests/parallel.ps1 -Framework Pester -PesterPath tests/TeXdig/Census.Tests.ps1 -RunDirectory D:/runs/codex-scientiae-tests/texdig-test -MaxWorkers 1
   ```

### Manual Verification (First Light on Gauntlet)

1. Run `census.ts` against `2111.15058v3`:
   ```pwsh
   node src/TeXdig/cli/census.ts `
     --article ingestion/gauntlet/ph-zigzag/2111.15058v3 `
     --deps packages/node/node_modules `
     --out artifacts/texdig-runs/first-light/2111.15058v3
   ```
2. Verify all 6 stores emitted:
   - Check `sources.jsonl` contains 14 files, correct role classification.
   - Check `entities.jsonl` contains reconciled macro, math, fence, bib entities with valid IDs.
   - Check `claims.jsonl` contains positive spine text runs and fence/envelope claims.
   - Check `coverage.json` reports UTF-16 code units for all parsed files.
   - Check `diagnostics.jsonl` contains cleanly registered diagnostic codes.
   - Check `summary.json` reports treeSha256 matching `article.json` and gate accounting.
