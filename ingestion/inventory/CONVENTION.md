# Ingestion inventory convention

Status: work in progress. `ingestion/inventory` is the sandbox for developing source-deposit, article, and
localized inventory-store conventions before broader ingestion integration.

Schema ownership is in the Python JSONL engine. The canonical leaf and inventory-row schema is
[`article.schema.json`](../../src/jsonl_engine/schemas/article.schema.json), with identifier
`codex-scientiae/article/0.1`. The same flat article object is the document sentinel and, when materialized,
the verbatim inventory row. This document describes the domain layout and transaction; it does not duplicate
engine validation rules.

## Document deposit layout

Each versioned source document has one `{slug}/` parent directory. A version suffix such as `v1` is part of
the slug and identifies an immutable provider version.

```text
{slug}/
  {slug}.tar.gz or arXiv-{slug}.tar.gz  # acquired LaTeX source archive
  {slug}-tex/         # stable raw extraction of that archive
  {slug}.pdf          # optional acquired PDF form of the same document
  {slug}-html/        # optional acquired HTML site (entrypoint `{slug}.html`)
  {slug}.arxiv.json   # optional provider/acquisition evidence
  {slug}-latex.patch.jsonl # optional latex-ingest curated errata
  article.json        # authoritative flat article and source-ready sentinel
```

An acquired LaTeX archive is `{slug}.tar.gz` or the arXiv provider leaf `arXiv-{slug}.tar.gz`. The
extracted tree is always `{slug}-tex/`. The archive and extracted tree are source material, not run
output. Generated artifacts after raw extraction belong under the applicable runstamped
`artifacts/...` directory.

### Document-local LaTeX curation

`{slug}-latex.patch.jsonl` is an optional durable input owned by latex-ingest. Its canonical address is the
document directory beside `article.json`; it is not allowed inside `{slug}-tex/`, a conversion run, lane
output, or a deliverable shelf. It is not acquired source evidence, does not enter `article.json`, and does
not contribute to the immutable source-tree fingerprint. Source publication and conversion never create,
rewrite, move, or delete it. Its lifecycle is explicit curation: absence means faithful conversion, a present
file is reapplied on every conversion, and a stale or count-mismatched record requires review or removal.

Lookup uses the validated manifest slug to construct that one literal sibling and performs no scan, inferred
basename, or output-directory fallback. The slug satisfies `article.schema.json#/$defs/portableLeaf`: one
nonempty segment; not `.` or `..`; no trailing dot or space, `<>:"/\|?*`, or U+0000–U+001F; and no
case-insensitive Windows device basename (`CON`, `PRN`, `AUX`, `NUL`, `COM1`–`COM9`, `LPT1`–`LPT9`) before a
dot or end. A present patch must be a physical non-reparse file no larger than 1 MiB (1,048,576 raw bytes).
Non-file occupancy, reparse traversal, and larger inputs fail; a missing exact leaf alone means `absent`.

The patch suffix does not opt this domain format into strict shared-engine semantics. Its application parser
accepts blank lines and full-line `#` or `//` comments; each remaining physical line is one JSON object with a
supported operation and required reason. Files use valid UTF-8 without a BOM; LF or CRLF and a missing final
newline are accepted, while a bare CR is rejected. Applied records preserve physical-line and curator
provenance in file order. Conversion and run-local oracle evidence carry the same raw-byte identity—`absent`
or `sha256:<64-lowercase-hex>`—and batch execution refuses drift from the identity frozen during planning.
A same-named file in generated `OutDir` is ignored.

## Source-ready publication

The canonical entrypoint is `New-LatexSourceDeposit` in `src/logistics/latex-source.ps1`:

```pwsh
. ./src/logistics/latex-source.ps1
New-LatexSourceDeposit -DocumentDir ./ingestion/inventory/1105.4224v1
```

PowerShell owns the source truth: archive selection and extraction, source confinement, entrypoint
resolution, LaTeX declarations, deterministic tree fingerprinting, and the witnessed probe ledger. It
resolves a relative `-DocumentDir` against the caller's current filesystem location; archive/provider paths
are then scoped to that document directory and `-MainTex` to the source tree. Persisted paths are normalized
forward-slash paths relative to the document directory.

The transaction holds the per-document source lock across tree publication and the final Python call. Its
Python-owned boundary establishes local file facts, rechecks path confinement and portability, projects
optional provider evidence, validates the article schema and semantic relations, and publishes
`article.json` without clobbering an existing file. It witnesses every measured file generation immediately
before and after publication. If the closing witness detects drift, it removes only the exact new article it
published while holding the article lease and refuses to delete a sentinel that another actor replaced. That
call is the framed JSONL-engine `deposit` verb and returns exactly one result object. The PowerShell
orchestrator rejects any other result cardinality before releasing the source lock; direct engine callers
must supply equivalent source stability for the duration of the call.

The transaction accepts tar+gzip and arXiv's single-TeX gzip shape. It refuses a reparse-point document root,
escaping or reparse-point descendants, reparse traversal through explicit inputs, and symlinked implicit
archive/provider/PDF candidates. It also refuses duplicate or case-colliding paths, invalid UTF-8 LaTeX, and missing or
ambiguous entrypoints; `-MainTex` records an explicit resolution of a genuine ambiguity. A
literal `\input`/`\include`/`\subfile` whose target is absent from the tree does not abort
deposit: the command stays in the resolved text and `literal-inputs-resolved` is `waived`
with the holes named. Escape, cycle, and depth still abort.

`article.json` is created last. Its `state: "source-ready"` says that source validation and article
publication completed, not that bibliographic normalization or conversion completed. If a crash leaves a
published `{slug}-tex/` without an article, a retry re-extracts privately and accepts the tree only when its
fingerprint matches. An existing equivalent article is validated and returned idempotently without rewrite.
Any changed archive, tree, provider projection, PDF fact, or other immutable evidence is a conflict.

Default materialize refuses a form-set change that would mutate the existing sentinel. An explicit
`materialize_source_deposit` with `rebuild=true` rebuilds `article.json` from the current acquisition
evidence (preserving `initialized_utc`) and is the path for a later PDF or other missing form. Rebuild
the catalog inventory afterwards with `force=true`.

## Upstream package-control metadata

Some arXiv source archives contain a root member named `00README.json`. Extraction preserves that filename
and content unchanged under `{slug}-tex/`; it is part of the raw archive tree and is not a local naming
convention.

Do not rename that raw member to `article.json`. Its fields describe only part of the submitted source
package, such as source-file usage, compiler, TeX Live version, or package specification. The source-deposit
transaction fingerprints its presence as package-control evidence but does not treat it as the document
article or depend on its contents.

## Flat article manifest

`{slug}/article.json` is one bounded, flat `codex-scientiae/article/0.1` object for one logical document
version. Its schema declares `/slug` as identity. It is assembled from distinct evidence:

1. **Provider/acquisition evidence** may supply external identity and bibliographic fields. For arXiv this
   includes the versioned id, title, authors, abstract, categories, dates, DOI, and canonical URLs available
   in `{slug}.arxiv.json`.
2. **Deposited files** establish local truth: normalized relative paths, formats, byte sizes, checksums, and
   the relationship between the archive and extracted tree.
3. **Document declarations** are supplemental evidence. The resolved LaTeX entrypoint contributes raw title,
   author, and DOI declarations without silently overriding provider facts.
4. **Validation evidence** records the publication mode and the complete probe ledger.

The top level contains schema/state/slug/time and article fields such as `title`, `authors`, `abstract`,
`identifiers`, and `categories`, alongside `evidence`, `source_forms`, and `validation`. There is no nested
`document` projection and no separate inventory-row envelope. Machine-local absolute paths and temporary
addresses never enter the object. Schema rules reject nonportable slug/path components, including reserved
device names, dot segments, platform-invalid characters, and trailing dots or spaces. `ArticleManifest`
adds semantic relations that JSON Schema shape alone cannot express: the sole archive and tree lead
`source_forms` in that order, use the slug-derived canonical paths, agree through `derived_from`, satisfy
`tex_files <= files`, and match the evidence entrypoint and selection.

## Localized inventory stores

A selected parent may own one `inventory.jsonl` materialized from canonical direct-child `article.json`
sentinels. Each physical row is the validated flat article object inserted verbatim under the same
`codex-scientiae/article/0.1` schema. `/slug` is therefore the row identity; a wrapper containing
`document_parent`, `metadata_path`, a manifest hash, or a nested `document` object is not the canonical 0.1
shape.

Materialization is immediate-scope and explicit. A direct child without `article.json` is not inferred to be
a document. A present but malformed, schema-invalid, wrongly located, or slug-disagreeing article fails the
whole build. Ordering and collision rules are owned by the engine inventory registry. Publication writes
strict UTF-8 without a BOM, LF-terminated rows, and the complete `inventory.jsonl` (+ sidecar) as one
transaction. The materializer does not initialize, repair, or recursively infer deposits.

A parent may also own one inventory folded from direct-child `inventory.jsonl` stores. That
fold does not walk `article.json`. Children without an inventory are omitted. Rows stay
`codex-scientiae/article/0.1`; leaf-relative `source_forms` and provider-metadata paths are
rewritten one hop up (`{child}/{slug}/…`). Inner inventories remain the source of truth.
Publish with `fold-inventory` / `Invoke-InventoryFold`; replacing an existing parent
inventory requires `force`.

Canonical on-demand build:

```pwsh
# Enumerate direct-child article.json and publish inventory.jsonl
pwsh -File ./scripts/inventory-build.ps1 -CatalogDir ./ingestion/inventory

# Overwrite an existing inventory.jsonl
pwsh -File ./scripts/inventory-build.ps1 -CatalogDir ./ingestion/inventory -Force

# Fold child inventories into a parent inventory.jsonl
pwsh -File ./scripts/inventory-fold.ps1 -CatalogDir ./ingestion/gauntlet -Force
```

PowerShell helper: `Invoke-InventoryBuild` in `src/logistics/inventory-catalog.ps1`. Engine verb:
`build-inventory` (`--catalog-dir`, `--article-paths-json`, optional `--force`). Enumeration stays in
PowerShell; the engine validates each `{catalog}/{slug}/article.json` path against the article slug and
publishes the registry. An existing `inventory.jsonl` is refused unless `-Force` / `--force` is set.

Precursor unpack/deposit over the same parent (arXiv-shaped archives only today):

```pwsh
pwsh -File ./scripts/latex-source-deposit-batch.ps1 -CatalogDir ./ingestion/inventory
```

`ConvertFrom-ArxivSourceArchiveLeaf` extracts `\d{4}\.\d{4,5}(?:v\d+)?` from tarball filenames so prefixes
such as `arXiv-{slug}` are accepted before `New-LatexSourceDeposit` runs. Non-arXiv archive naming is out
of scope for this batch helper.

`src/latex-ingest/inventory-catalog.ps1` predates this article contract. Its direct-child admission checks
and collision rules remain design evidence, but its `metadata.json`/`document-inventory-row/0.1` projection
is a legacy specification rather than the active materializer.

The public LaTeX batch adapter and production converter already read `article.json`; a directory address
prefers it. Planning performs only confined address resolution and the shallow fields needed for job
identity; it does not start Python or claim schema authority. The conversion worker invokes
`validate-json <path> article.schema.json` through the shared client before consuming a canonical article,
so the Python engine and shipped schema remain authoritative at both publication and use. Temporary
`metadata.json` and `codex-scientiae/document-metadata/0.1` readers support migration only. No new producer
may create the legacy manifest or nested inventory-row shape.
