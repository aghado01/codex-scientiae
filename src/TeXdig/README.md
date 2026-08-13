# TeXdig — stage 1: census and assembly

TeXdig is the clean-reboot LaTeX extraction lane (unified-latex + latex-utensils, TypeScript core,
PowerShell orchestration). Stage 1 produces a **closed, span-addressed inventory** of every knowable
carrier on the source surface of a deposited LaTeX tree. It is mechanical: no macro expansion, no
interpretation, no surjection. Downstream stages elaborate this inventory and never rediscover
structure from the stream.

## Upstream contract

Input is a deposited article per [`ingestion/inventory/CONVENTION.md`](../../ingestion/inventory/CONVENTION.md):
a frozen `{slug}-tex/` tree plus the `article.json` sentinel carrying the resolved entrypoint and the
tree `sha256`. The worker validates the manifest shape, reads one buffered byte snapshot, recomputes
the canonical tree fingerprint from that snapshot, and refuses a mismatch before analysis. Census
results are attributed to the verified fingerprint; a manifest value alone is not provenance.

## Stage-1 exit gates

1. **Coverage** — every UTF-16 unit of every **parsed** source file is claimed by an entity or
   reported as residue. Zero silent bytes; residue is a defect signal with an address, not an
   absence. Binary assets and unsupported source dialects sit outside this gate and remain byte-inventoried.
2. **Agreement** — every inventoried entity carries a named evidence basis. Two-instrument agreement
   uses a construct-specific equivalence policy; configured and single-authority evidence are not
   reported as two-witness corroboration. Every conflict or one-sided sighting carries an attributed diagnostic.
3. **Closure** — every entity minted after stage 1 must carry an origin chain that terminates in this
   inventory (or declared configuration). Downstream discovery that cannot cite an inventoried site
   is a stage-1 bug. Applies to frontmatter too: declared metadata is span-anchored rows, not flat
   strings.
4. **Traversal completeness** — every content-bearing claim is reachable from `walk.jsonl`; anything
   claimed but unreachable is an orphan diagnostic. This catches "censused correctly but lost during
   assembly," which coverage alone cannot see.

## Model

- **Complete source**: the census byte-inventories every deposited file. The entrypoint, every
   statically include-reachable text target regardless of suffix, bibliography resources (`.bib`),
   and the `.bbl` sidecar are parsed and coverage-audited. Unreached classes/styles remain byte-inventoried;
   an explicitly included in-tree class/style is treated as an effective LaTeX input. Bibliography material is a
  first-class census subject, not a later lane: `@string` is the bib language's macro-definition,
  `crossref` its inheritance, and field values re-enter unified-latex as LaTeX fragments in cut 2.
- **Three pillars as overlays**: document envelope (structural markers, floats), prose spine
  (positive text-run claims — never defined as the complement), and fenced spans (environments, math
  carriers, verbatim, comments; in `.bib`, entries/@string/@preamble). Claims may overlap (a float is
  both fence and envelope); the union must cover. Exclusivity violations are not errors; unclaimed
  residue is.
- **Witness policies**: a dumb lexical scanner (complete positions, shallow typing)
  against the parser witness — unified-latex for LaTeX and `.bbl`, latex-utensils for `.bib` (both
  rich typing, known position gaps). Reconciliation fills parser gaps from the raw stream and
  surfaces disagreement as findings. Configured declarations and explicitly single-authority rows
  retain their distinct evidence basis. Original source is always a slice, never `printRaw`.
- **Physical evidence versus execution occurrences**: census entities describe physical source
  tokens and declarations. `occurrences.jsonl` describes executions of physical sources,
  `bindings.jsonl` describes chronological binding effects, and `invocations.jsonl` describes
  binding-dependent invocation hulls and arguments. Repeated inclusion never duplicates or mutates
  the physical census entity.
- **Ordering**: comment/verbatim stratification precedes **everything** — including include-graph
  construction (a commented-out `\input` of a nonexistent file exists in the corpus and must not
  produce a diagnostic). Then fence census, then control-sequence census. This supersedes the
  parse-after-graph ordering in the early notes.

## Emitted stores

One runstamped container per document — one document per batch-executor job, the job container is
the document container (`Writes` root). UTF-8 without BOM, LF rows. Three tiers:

**Planned contract tier** — downstream will consume only this; every row downstream interprets carries its exact
source slice inline (self-contained; the deposit tree is evidence substrate, not part of the
contract):

| Store | Content |
| --- | --- |
| `walk.jsonl` | Traversal-serialized structure: sections, paragraphs, anchors in reading order; content as text-run/ref arrays; `includeChain` context |
| `zones.jsonl` | Compiled closure-sealed units (math, diagrams, verbatim, floats, theorem-like): slice, closure, per-name binding verdicts, isolability, validation |
| `macros.jsonl` | Physical declaration/specimen store: exact signature, normalized argument spec, body evidence, lexical `nameRefs`, body fingerprint |
| `occurrences.jsonl` | Execution occurrences of physical sources, including repeated includes and explicit cycle cuts |
| `bindings.jsonl` | Chronological definition operations, outcomes, scopes, and captured meanings |
| `invocations.jsonl` | Per-occurrence binding resolution, exact invocation hull, and typed argument attachments |
| `references.jsonl` | Canonical reference items: appearance-normalized ordinal + basis, source label register, per-field provenance |
| `pointers.jsonl` | Label declarations and pointer sites (pointer-hood derived transitively from definition bodies, never a fixed vocabulary), resolution edges |
| `frontmatter.jsonl` | Span-anchored declared metadata (title, author blob, date, abstract) |
| `graph.jsonl` | Relational projection of all stores; graph-primitive/0.1-aligned node/edge rows, both ends anchored, address-valued ids; to be registered |

**Evidence tier (emitted in 0.2)**: `sources.jsonl` (with language/role/parsed classification),
`entities.jsonl` (physical census with an explicit evidence basis), `claims.jsonl` (pillar claims).

**Audit tier (emitted in 0.2)**: `coverage.json`, `diagnostics.jsonl`, `summary.json` (gate outcomes, counts,
verified `treeSha256`, runtime identity, per-store schema identities).

The six emitted stores have normative 0.2 schemas in the jsonl_engine registry. `core/types.ts` is
their in-language DTO layer; schema and fixture validation keep the two in agreement. Planned
contract-tier DTOs live in `core/contracts.ts`; they do not become runtime contract merely by having
a TypeScript interface, and remain listed under `summary.stores.deferred` until their schemas and
occurrence-aware producers land.

## Linking conventions

- One id grammar: `{class}:{locator}`, classes registered in `core/contracts.ts` `ID_CLASSES` with
  store residency. The id string is the verbatim join key everywhere; all joins are string equality.
- Content references use the array form (text runs alternating with refs) as the ONLY stored form.
  Masked text is a debug rendering, never an artifact — sentinel-token leakage was a shipped-defect
  class in the previous lane and the mechanism is not carried forward.
- One bundle-local `seq` order space covers occurrence-bearing runtime rows. Physical declarations
  do not acquire one universally meaningful execution position; repeated occurrences receive their
  own binding events.

## Versioning

`texdig-census/0.2` is a source-regenerated contract. `0.1` bundles remain immutable historical
evidence. No JSONL-only conversion can recover omitted empty arguments, exact raw signatures,
occurrence identity, binding history, or rejected local-frame coordinates.

## Reference canon

`references.jsonl` reconciles all bibliography witnesses — `.bbl` / inline `thebibliography`
(compiled list: order, labels, formatted text), `.bib` (structured fields), `\bibliographystyle`
(ordering policy), citation sites (appearance order), provider metadata — into one canonical item
per resolved identity, per-field provenance under a registered merge policy, disagreements as
findings. The canonical **ordinal is always normalized**: 1-based, order of first citation
appearance; uncited items append in list order (`ordinalBasis` records the basis per item). The
paper's own register (alpha labels, list position) is preserved beside the ordinal, never as it;
1:1 ordinal/label correspondence is audited and deviations are findings. Structuring formatted
`.bbl` text into fields when no `.bib` exists is interpretation and stays downstream.

## Later cuts

Cut 2: occurrence-aware binding and invocation attachment, followed by relation joins, support
closure, and purity verdicts. Cut 3: isolated evaluation and render + differential-alignment validation.
Orchestration joins `batch-adapters` as `Get-TeXdigBatchJob` under the standard job-emission
contract; the census CLI stays a pure worker (tree + entrypoint in, stores out). PDF-only deposits
are refused at planning, not failed at the worker.

## Runtime

Erasable-syntax TypeScript executed directly by an explicitly resolved Node (v26, native type stripping): no
enums or namespaces, explicit `.ts` import extensions. Dependencies are injected by explicit
directory (`--deps <repo>/packages/node/node_modules`, the dependency-neutral house pattern); the
core never relies on ambient resolution. `typescript` joins the brewery pins later as a dev-time
checker only.
