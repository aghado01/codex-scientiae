# TeXdig — stage 1: census and assembly

TeXdig is the clean-reboot LaTeX extraction lane (unified-latex + latex-utensils, TypeScript core,
PowerShell orchestration). Stage 1 produces a **closed, span-addressed inventory** of every knowable
carrier on the source surface of a deposited LaTeX tree. It is mechanical: no macro expansion, no
interpretation, no surjection. Downstream stages elaborate this inventory and never rediscover
structure from the stream.

## Upstream contract

Input is a deposited article per [`ingestion/inventory/CONVENTION.md`](../../ingestion/inventory/CONVENTION.md):
a frozen `{slug}-tex/` tree plus the `article.json` sentinel carrying the resolved entrypoint and the
tree `sha256`. The deposit owns validation; the stage-1 worker performs only the precedented
lightweight `validate-json` shape check before consuming the manifest. Census results are permanently
attributed to the tree fingerprint via the job identity digest.

## Stage-1 exit gates

1. **Coverage** — every UTF-16 unit of every source file is claimed by an entity or reported as
   residue. Zero silent bytes; residue is a defect signal with an address, not an absence.
2. **Agreement** — every inventoried entity is witness-reconciled (lexical scanner and parser agree)
   or carries a named, attributed defect.
3. **Closure** — every entity minted after stage 1 must carry an origin chain that terminates in this
   inventory (or declared configuration). Downstream discovery that cannot cite an inventoried site
   is a stage-1 bug.

## Model

- **Complete source**: the census covers every file of the deposited tree — the entrypoint and
  include-reachable `.tex`, bibliography resources (`.bib`), and the `.bbl` sidecar are parsed and
  coverage-audited; class/style/asset files are inventoried unparsed. Bibliography material is a
  first-class census subject, not a later lane: `@string` is the bib language's macro-definition,
  `crossref` its inheritance, and field values re-enter unified-latex as LaTeX fragments in cut 2.
- **Three pillars as overlays**: document envelope (structural markers, floats), prose spine
  (positive text-run claims — never defined as the complement), and fenced spans (environments, math
  carriers, verbatim, comments; in `.bib`, entries/@string/@preamble). Claims may overlap (a float is
  both fence and envelope); the union must cover. Exclusivity violations are not errors; unclaimed
  residue is.
- **Two witnesses, two instruments**: a dumb lexical scanner (complete positions, shallow typing)
  against the parser witness — unified-latex for LaTeX and `.bbl`, latex-utensils for `.bib` (both
  rich typing, known position gaps). Reconciliation fills parser gaps from the raw stream and
  surfaces disagreement as findings. Original source is always a slice, never `printRaw`.
- **Ordering**: comment/verbatim stratification precedes fence census precedes control-sequence
  census — the small vocabulary of things that change what everything else means is swept first.

## Emitted stores

One runstamped container per document (batch-executor `Writes` root), UTF-8 without BOM, LF rows:

| Store | Content |
| --- | --- |
| `sources.jsonl` | One row per source file: id, sha256, UTF-16 length, entrypoint flag |
| `entities.jsonl` | The census: one row per `CensusEntity` |
| `claims.jsonl` | Pillar claims cross-indexing entities to overlay membership |
| `coverage.json` | Per-source coverage accounting and residue spans |
| `diagnostics.jsonl` | Registered-code diagnostics (the defect queue) |
| `summary.json` | Run summary: counts, gate outcomes, schema version, tree fingerprint |

## Later cuts

Cut 2: relation joins (binding, attachment, support closure, purity verdicts). Cut 3: closed-term
assembly, isolated evaluation, render + differential-alignment validation. Orchestration joins
`batch-adapters` as `Get-TeXdigBatchJob` under the standard job-emission contract; the census CLI
stays a pure worker (tree + entrypoint in, stores out).

## Runtime

Erasable-syntax TypeScript executed directly by the ambient Node (v26, native type stripping): no
enums or namespaces, explicit `.ts` import extensions. Dependencies are injected by explicit
directory (`--deps <repo>/packages/node/node_modules`, the dependency-neutral house pattern); the
core never relies on ambient resolution. `typescript` joins the brewery pins later as a dev-time
checker only.
