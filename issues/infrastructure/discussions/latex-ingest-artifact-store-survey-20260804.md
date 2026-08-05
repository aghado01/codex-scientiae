# latex-ingest artifact and store survey — 2026-08-04

This is a read-only survey of the recent material under
[`artifacts/latex-ingest`](../../../artifacts/latex-ingest/). Its purpose is to identify the distinct
operational roles already present in a real workflow, pressure-test the shared JSONL/store design against
them, and avoid treating every structured artifact as either a log or the same kind of store.

The specimens are **development evidence, not a registry of committed store kinds**. Several were emitted
while the latex-ingest representation was being iterated, compared, and investigated. Their coexistence and
variability are useful because they pressure-test whether the JSONL engine can create, replace, append,
subtract, resort, validate, compare, query, slice, and index arbitrary caller-defined stores. They do not
authorize the shared engine to choose which representation latex-ingest should keep.

The classification uses four independent questions:

1. **Scope:** source package, document conversion, corpus sweep, or run.
2. **Authority:** imported source fact, source-side evidence, canonical working representation, derived
   materialization, validation evidence, or presentation projection.
3. **Mutation model:** immutable at a runstamped address, rebuilt at a stable address, transient/reusable
   staging, or append history.
4. **Representation:** JSONL row store, JSON object snapshot, rendered document, or directory tree.

That separation is essential. A JSONL file can be a rebuilt canonical IR rather than an append journal; a
JSON file can be authoritative run evidence or a disposable materialized report; a runstamp says something
about lifecycle, not schema.

## Shelf census

The tree currently has two generated-artifact scopes and one source-staging scope:

- `probe/{slug}/` contains 43 complete document bundles, each with seven top-level artifacts.
- `probe/_staging/{slug}-latex/` contains reusable unpacked source trees for papers that were not already
  staged beside their acquisition archive.
- `runs/{runstamp}/{slug}/` contains 42 run-scoped result directories. The retained sample is dominated by
  smoke/test slug `p` (40 runs); two older runs use `2408.16741v2`.

The 43 current probe bundles contain:

| artifact | files | records or structural size | observed byte range | operational role |
|---|---:|---:|---:|---|
| `{slug}.docstream.jsonl` | 43 | 44,109 rows total | 38,224–864,364 | Canonical pre-Markdown IR candidate for the conversion |
| `{slug}.slots.jsonl` | 43 | 44,109 rows total | 38,224–864,364 | Experimental row-store snapshot from an earlier development pass |
| `{slug}.refs.jsonl` | 43 | 9,231 rows total | 3,933–83,578 | Flat source-side label/site evidence and golden-pin seam |
| `{slug}.refgraph.json` | 43 | 34–531 edges; 0–208 danglers | 11,750–273,308 | LaTeX-flavored reference evidence assembled from the ref model |
| `{slug}.docgraph.json` | 43 | 94–4,038 nodes; 34–531 edges | 24,166–559,539 | Derived materialized composition of docstream and refgraph |
| `{slug}.probe-report.json` | 43 | one report per document | 1,697–15,614 | Derived closure, residue, numbering, mass, and graph audit snapshot |
| `{slug}.prose.md` | 43 | rendered text | 9,109–159,521 | Human-readable projection, not a structured store |

One additional production artifact is not on the artifact shelf. The current converter writes
`{slug}.diagrams.jsonl` into its stable source work directory. The retained specimen under `ingestion/`
contains 13 keyed work items (`n`, `kind`, `status`, `image`, `source`): five reached SVG and eight remain
flagged markers. This is a conversion-generated work queue/current-state projection, not source material.

The corpus sweep also emits `_sweep-results.json` (257,939 bytes), which embeds all 43 per-paper reports and
adds a 215-command residue ledger and 19-entry float-spec census. `_sweep-summary.md` is its human-readable
projection. These are corpus-level materialized rollups, not an append ledger despite the field name
`residue_ledger`.

The run shelf contains 42 `oracle-counts/2` JSON reports and 16 `math-render-audit/1` JSON reports. Twenty-six
run directories contain only oracle counts; sixteen contain both oracle counts and
`audits/math-render.json`. These are immutable-by-address run evidence in intent. They are not accumulated
row stores and do not need to become JSONL merely to share lifecycle conventions.

### Production-placement caveat

The probe shelf is not the production converter's complete address map. The current
[`latex-ingest.ps1`](../../../src/latex-ingest/latex-ingest.ps1) deliberately separates `SourceWorkDir`,
`RunDir`, `OutDir`, and optional `DeliverableDir`, but then writes `refs.jsonl`, `docstream.jsonl`,
`refgraph.json`, `docgraph.json`, and `diagrams.jsonl` into the stable `SourceWorkDir`. Only oracle counts and
the math-render audit go to the runstamped `RunDir`.

The repository currently retains just one such generated source-work sidecar (`diagrams.jsonl`); the other
current specimens are probe emissions. The next production conversion would put all five generated
structures beside unpacked source unless the placement policy changes.

This split needs an explicit decision. A stable per-document current materialization can be legitimate, but
it should not silently contaminate a directory treated as extracted source, and it needs replacement,
lineage, and recovery semantics. Alternatively, each generation can live under the runstamp and a separately
managed current view can select/materialize one generation. Generic JSONL code cannot choose between those
application policies.

## Observed shapes and engine pressure

The existing latex-ingest canon already states
[`STREAM + REFGRAPH -> DOC GRAPH`](../../latex-ingest/planning/decisions.md): docstream is the node set,
refgraph is source-side reference machinery, and docgraph is their derived composition. That is the current
latex-ingest design context, not a type system the generic JSONL engine should embed.

### Docstream: ordered-row specimen

Every docstream row is an object with `seq`, `addr`, `kind`, `parent`, `char_offset`, and `content`, plus
kind-specific fields. The 44,109-row corpus includes 30,423 inline-math rows, 8,991 prose rows, 1,568 display
math rows, 2,417 numbered/spine-kind rows, and smaller figure, table, diagram, algorithm, verb, barrier, and
appendix populations.

The observed producer builds the whole file, and its physical order, addresses, and parents are mutually
dependent. That makes atomic whole-file replacement an important engine primitive for this experiment. It
does not make replacement the universal JSONL policy or commit latex-ingest to this row model. General
range, key, kind, address, parent, label, and semantic-diff operations are useful for developing and testing
variants; a `.jidx` remains optional acceleration at the current 38 KB–864 KB file sizes.

### Refs: heterogeneous-row specimen

The refs stores contain 2,823 `row=label` records and 6,408 `row=site` records. Label rows carry label class,
type, faithful and normalized projections. Site rows carry sequence, macro, targets, rendered form, and
optional citation qualifiers.

This is a discriminated row store with two apparent identity conventions, not a homogeneous inventory
table. It pressures the engine to preserve heterogeneous rows, query by discriminator and nested values,
and accept a caller-supplied schema/key policy when one exists. The shared layer need not decide whether
label identity, site sequence, physical order, or some later representation becomes canonical.

### Refgraph: source-side relational evidence snapshot

Each refgraph is one JSON object with `labels`, `sites`, `edges`, `danglers`, and `stats`. The structure is
assembled from the same reference model as `refs.jsonl`, but it makes resolution, edge identity, and dangler
classification explicit. It is derived from collected source facts yet remains evidence upstream of the
docgraph composition.

The graph is a whole-object snapshot rather than JSONL. It demonstrates why JSONL primitives must compose
cleanly with application automation and ordinary JSON artifacts; the generic engine does not own this graph
or decide when the application refreshes it.

### Docgraph: explicitly derived materialized view

Every docgraph has exactly `nodes`, `edges`, and `stats`. It is assembled from docstream plus refgraph and is
never independently scanned. That makes it the clearest example of reflexive derivative maintenance: a
changed stream or refgraph makes the existing docgraph stale even when the JSON remains syntactically valid.

If latex-ingest retains this composition, its lifecycle transaction is larger than one JSONL file and its
`.jidx`. That would be application orchestration over generic primitives; the JSONL layer should support the
inputs without learning docgraph semantics or requiring that this experiment survive.

### Probe report and sweep results: validation and rollup materializations

The probe report records closure invariants, store sizes, row counts, residue, numbering, graph statistics,
and a generation timestamp. If a future application artifact set needs generation identity or dependency
facts, an existing report may be a useful carrier and avoids metadata proliferation. The probe itself does
not impose that design on the engine.

The sweep result then duplicates every report inside a corpus-level snapshot. That is useful for bounded
analysis but requires complete rebuild after any per-document report changes. It should be treated as a
materialized rollup with declared inputs, not an authoritative history ledger.

### Prose: projection

`{slug}.prose.md` is the probe's human-readable serialization. It participates in the artifact dependency
graph and validation workflow, but calling it a store would erase the useful distinction between canonical
IR and rendered projection.

### Diagrams: possible work-queue specimen

The converter describes `diagrams.jsonl` as the reasoning-agent seam for diagrams that did not land as
semantic math. Each record preserves source and current disposition (`marker`, `svg`, or `png`) under numeric
identity `n`. The current producer rebuilds the file from the conversion's diagram store.

If a later reasoning pass changes dispositions in place, this would pressure keyed update, subtraction,
reordering, transition validation, and reconciliation primitives. If a caller instead wants transition
history, append and query primitives should support that different design too. The specimen teaches the
engine to enable either application model; it does not settle which one diagrams should use.

## `slots.jsonl` and `docstream.jsonl` are iteration evidence

The probe driver now describes `docstream.jsonl` as “formerly slots.jsonl,” but these files were emitted
during an active development session in which the representation and conversion behavior were being
iterated. Of the 43 retained pairs:

- 35 are byte-identical;
- eight differ semantically, not merely in property order or whitespace;
- all pairs have the same row counts and aggregate schema/kind census;
- the differing pairs change one to 1,259 rows, mainly `content` and sometimes `char_count`;
- every `slots.jsonl` was last written on 2026-08-03, while every current `docstream.jsonl` was regenerated
  on 2026-08-04.

The variability is a learning signal, not evidence that the engine needs a `slots` compatibility rule or
that either filename must become permanent. It demonstrates useful general capabilities:

- compare two JSONL stores record-by-record, both textually and semantically;
- summarize schema, discriminators, counts, offsets, and changed fields without loading an unbounded diff;
- snapshot or explicitly replace experimental generations without silent overwrite;
- query and slice both variants through the same codec despite caller-defined row meaning; and
- let the application decide whether two files are alternatives, successive generations, independent
  stores, or disposable probes.

## Encoding and publication findings

All 129 JSONL files on the artifact shelf (`docstream`, `slots`, and `refs`) have these positive properties:

- valid strict UTF-8;
- no BOM;
- a final LF byte;
- 97,449 total records that parse as JSON objects;
- no invalid Unicode scalar sequences when every string value and property name is materialized through
  the shared gate.

However, all 129 use **CRLF** physical record terminators. The additional production `diagrams.jsonl`
specimen does too, making the observed writer result 130 of 130. Consequently the artifact-shelf files fail the draft
[`Test-Jsonl`](../../../src/shared/jsonl-v2.ps1) LF-only contract. This is systemic in both the production
emission and the probe: each constructs a `StringBuilder` and calls the platform-dependent `AppendLine`
before `WriteAllText`. The shared writer must use explicit LF bytes/text; moving these callers onto the
central codec will remove the platform dependency.

Publication has a second, more important lifecycle weakness. The
[`probe-prose-channel.ps1`](../../../scratch/probe-prose-channel.ps1) driver creates/reuses a stable
`probe/{slug}` directory and independently calls `WriteAllText` for each output. Existing files are silently
overwritten. There is no artifact-set generation id, input digest, dependency declaration, or commit marker,
and experimental files from other passes can remain beside the new generation. A process failure can therefore
leave a syntactically valid but incoherent mixture of generations.

The runstamped `runs/{runstamp}/{slug}` shelf avoids most overwrite ambiguity for its oracle/audit evidence,
but it does not currently correlate the stable probe bundle—or production structures written into
`SourceWorkDir`—to the originating run. Only the probe report contains a generated timestamp; the JSONL rows
and graph objects do not carry a schema or generation id. Filesystem time is presently the only evidence
that the seven probe files belong together.

## Staging is a workspace lifecycle, not a document store

`probe/_staging` contains 42 reusable unpacked LaTeX source trees. The sweep reuses a tree when it contains
TeX and otherwise unpacks the archive into that address. This is a cache/staging lifecycle with provenance,
freshness, cleanup, and collision questions; it should not be modeled as JSONL append or catalog mutation.

Twenty-five staged packages contain `00README.json`. Inspection of three corresponding `.tar.gz` listings
shows that `00README.json` is already a root member of each acquired archive; `Expand-ArxivSourceTarball`
only extracts it and does not create or rename it. From this repository's perspective it is therefore an
upstream package-control file copied verbatim into the extracted tree, even if it was generated as an
intermediate by an upstream source-preparation system. All 25 parse cleanly. Across them:

- 59 source entries have `filename` and `usage`;
- 24 specify `pdflatex` and one specifies `xelatex`;
- newer variants include `spec_version` and `texlive_version`; older variants use `version` or `stamp`.

The `00README.json` name is an upstream convention and is a poor local convention: it communicates display
ordering rather than ownership, schema, or lifecycle. The local convention is `{slug}/metadata.json`, while
the upstream member remains untouched under `{slug}-tex/`. The local manifest is not based on its contents.
Durable document metadata comes from provider/acquisition records, deposited-file inspection, supplemental
document declarations, and curated corrections. `00README.json` is not an acquisition record: it does not say
when or from where the archive was downloaded, identify the PDF sibling, record checksums, or describe later
local extraction/derivation.

## Non-binding specimen matrix

The labels below describe how the retained files behaved in this survey. They are workload shapes for the
engine, not names the engine should expose and not commitments that latex-ingest will retain them.

| kind | specimen | scope | authority | mutation model | generic JSONL overlap |
|---|---|---|---|---|---|
| ordered IR experiment | `docstream.jsonl` | document generation | current working representation derived from source | observed whole-generation rebuild | codec, atomic replace, validation, range/key/diff queries; optional index |
| discriminated evidence table | `refs.jsonl` | document generation | source-side evidence | whole-generation rebuild | codec, schema, composite identity, bounded queries |
| relational evidence snapshot | `refgraph.json` | document generation | derived source evidence | whole-object rebuild | shared JSON scalar safety; application lifecycle |
| materialized graph | `docgraph.json` | document generation | derivative of stream + refgraph | reflexive rebuild | application dependency orchestration, not JSONL mutation |
| validation snapshot | `probe-report.json` | document generation | derived evidence | replace by generation | schema and explicit replace; possible bundle manifest role |
| corpus rollup | `_sweep-results.json` | corpus sweep | derivative of reports | deterministic complete rebuild | materialized-view policy; no append history implied |
| workflow queue/current view | `diagrams.jsonl` | document conversion | generated work items and disposition | rebuild now; controlled keyed transition later | schema, unique `n`, state queries, explicit replace/update |
| run evidence | `oracle-counts.json`, `math-render.json` | run | authoritative result of that audit/run | immutable at runstamped address | shared run lifecycle and JSON safety; JSONL unnecessary |
| presentation projection | `prose.md`, `_sweep-summary.md` | document/corpus | derived presentation | rebuild | dependency/freshness only |
| upstream package-control file | `00README.json` | source package | archive-member metadata | preserve with source package | optional input to local manifest normalization |
| staging workspace | `_staging/{slug}-latex/` | source package | copied/extracted working material | create/reuse/refresh/clean | application workspace lifecycle, not row-store lifecycle |
| experimental row-store snapshot | `slots.jsonl` | development probe | earlier iteration output | observed whole-generation build | same codec, queries, slices, comparison, and explicit replacement |

No append journal happens to appear in this retained artifact family. That absence is not a limit on the
engine. Together with the append-oriented logger and rector exchange-ledger witnesses, these rebuild-oriented
specimens show why the shared substrate must support multiple caller-selected mutation models.

## Architectural consequences

1. **The specimens are capability witnesses, not engine taxonomy.** The engine supplies neutral primitives;
   callers choose store names, schemas, identities, ordering, mutation, and lifecycle.
2. **Scope, authority, and mutation model must remain separate policy axes.** File extension and directory
   shape cannot infer them.
3. **The generic JSONL transaction remains file-local.** It may publish one JSONL file and refresh its
   index; it cannot claim to atomically commit docstream, refs, graphs, reports, and projections.
4. **Artifact-set coherence, when required, belongs to application orchestration.** Build into a private
   generation, validate all members and dependency joins, then publish across the selected source-work, run,
   output, and delivery addresses with explicit replacement/recovery semantics.
5. **Use an existing report or run manifest for bundle membership.** Record generation id, schemas, inputs,
   outputs, roles, dependencies, hashes, and completion state once rather than proliferating sidecars.
6. **The shared codec must be schema-agnostic.** Optional caller-supplied schemas can validate a store, but
   the engine must still create, inspect, compare, and query experimental stores without canonizing them.
7. **Indexes should be workload-driven.** Current per-document stores are small. An index is justified when
   random row/address access is a real consumer need, not merely because the file is JSONL.
8. **Comparative inspection is a first-class development need.** Bounded semantic diff, schema census,
   changed-field summaries, and record alignment belong in the general toolbelt over the core codec.
9. **Foreign package-control files are evidence inputs.** Normalize useful facts into a clearly named local
   manifest without adopting the opaque `00README.json` convention.

## Scoped next steps

1. Route latex-ingest JSONL emission through the strict shared codec during its eventual migration; add a
   regression proving LF-only, strict UTF-8, no BOM, terminal LF, and Unicode-scalar safety on real rows.
2. Turn `slots`, `docstream`, `refs`, and `diagrams` into a non-binding engine test corpus covering
   heterogeneous schemas, whole-file replacement, keyed lookup, nested query, slicing, and bounded semantic
   comparison. Do not make their filenames or row contracts engine API.
3. Add general comparison/inspection primitives or toolbelt commands: record alignment, semantic equality,
   schema/discriminator census, changed-field summaries, and bounded output.
4. Specify an application-level artifact-set generation record and publication state machine only where the
   application retains a multi-file dependency. Reuse the probe report or a run manifest instead of minting
   metadata beside every file.
5. Decide whether retained per-document conversion structures live inside the run, in a stable generated
   materialization directory, or in both with an explicit selection rule. Do not leave them mixed into
   extracted source by accident.
6. If docgraph remains, validate its freshness from declared docstream/refgraph generation or hashes; do not
   infer it from parse success or timestamps.
7. If `diagrams.jsonl` becomes an agent-mutated work queue, let that application specify identity and
   transition policy over the generic store primitives.
8. Preserve upstream `00README.json` without using it as a `{slug}/metadata.json` input; derive the local
   manifest systematically from provider/acquisition, deposited-file, LaTeX-declaration, and curated evidence.
9. Re-run this survey after one genuine end-to-end production conversion; the retained `runs/` sample is
   mostly test executions and cannot establish the final production bundle shape by itself.
