# Ingestion inventory convention

Status: work in progress. `ingestion/inventory` is the sandbox for developing source-deposit,
manifest, and localized inventory-store conventions before broader ingestion integration.

Schema ownership has moved. `metadata.schema.json` and `inventory-row.schema.json` now live with the JSONL
engine at [`src/shared/jsonl_engine/schemas/`](../../src/shared/jsonl_engine/schemas/), which owns schema
validation and will take over reading and writing these artifacts. This document describes the layout and the
deposit transaction; it no longer describes where validation is implemented.

## Document deposit layout

Each versioned source document has one `{slug}/` parent directory. A version suffix such as `v1` is part of
the slug and identifies an immutable provider version.

```text
{slug}/
  {slug}.tar.gz       # optional acquired LaTeX source archive
  {slug}-tex/         # stable raw extraction of that archive
  {slug}.pdf          # optional acquired PDF form of the same document
  metadata.json       # local authoritative single-document manifest
```

An acquired LaTeX archive named either `{slug}.tar.gz` or `arXiv-{slug}.tar.gz` is normalized to
`{slug}.tar.gz` when deposited. It is unpacked once to `{slug}-tex/`.

The archive and extracted tree are source material, not run output. If the immutable archive is unchanged,
conversion reuses the existing extraction rather than unpacking another copy per run. Refresh or replacement
of an extraction must be explicit and tied to the archive's identity; ordinary conversion runs do not
overwrite source material.

Every generated artifact after raw extraction belongs under the applicable runstamped `artifacts/...`
directory. Final bundling and deposit conventions for destinations such as `bibliotecha` remain forthcoming.

## Source-ready initialization

Source initialization is prerequisite housekeeping, not a latex-ingest conversion run. The draft standalone
entrypoint is `Initialize-LatexSourceDeposit` in `src/latex-ingest/source-deposit.ps1`:

```pwsh
. ./src/latex-ingest/source-deposit.ps1
Initialize-LatexSourceDeposit -DocumentDir ./ingestion/inventory/1105.4224v1
```

The initializer accepts either `{slug}.tar.gz` or the acquisition alias `arXiv-{slug}.tar.gz`, validates the
archive in a private sibling directory, and only then normalizes the alias and publishes `{slug}-tex/`. It
supports both gzipped tar archives and arXiv's single-TeX gzip shape. Archive members must remain under the
extraction root; links, reparse points, duplicate/case-colliding paths, invalid UTF-8 LaTeX, unresolved literal
inputs, and missing or ambiguous document entrypoints are refused. `-MainTex` resolves a genuine multi-document
ambiguity explicitly.

Path locality is explicit. A relative `-DocumentDir` is resolved once against the caller's current directory;
after that, relative `-ArchivePath` and `-ProviderMetadataPath` values are scoped to the resolved document
directory, while `-MainTex` is scoped to the private/existing source tree. Script imports are anchored to
`$PSScriptRoot`. Manifests persist portable forward-slash paths relative to the document directory, never a
drive letter, user profile, repository checkout, or temporary absolute path. Absolute paths exist only as
resolved in-process addresses used for confinement and filesystem operations.

`metadata.json` is written atomically and last. Its `state: "source-ready"` is therefore the success sentinel
for the source-deposit transaction, not a claim that bibliographic normalization or a conversion run is
complete. Provider metadata is optional. A manual deposit can become source-ready with empty bibliographic
fields; a matching `{slug}.arxiv.json` adds attributed provider evidence and provider-selected document fields.
Conservative raw `title`, `author`, and `doi` declarations from the resolved LaTeX entrypoint are retained as
supplemental evidence and do not silently override provider facts.

No operation silently replaces a pre-existing archive, source tree, or manifest. If a crash leaves a published
`{slug}-tex/` without its sentinel, a retry re-extracts privately and writes `metadata.json` only when the two
tree fingerprints match. A different existing tree is a visible conflict. An existing sentinel is validated
against the archive and source-tree fingerprints and returned idempotently without being rewritten. The
per-document lock and private extraction names are transactional and are removed after success or failure.

The production converter consumes an initialized leaf through `-MetadataPath` (or its `-DocumentDir` alias),
revalidates the manifest-owned source, and never initializes implicitly. Retired archive/slug discovery,
`{slug}-latex/`, `-ReuseSource`, and arbitrary source-work overrides are isolated in
`src/latex-ingest/latex-ingest-compat.ps1`. Default compatibility use initializes a conventional leaf before
delegating; explicit bypasses remain visibly unmanifested and do not make a deposit compliant.

## Upstream package-control metadata

Some arXiv source archives contain a root member named `00README.json`. Extraction preserves that filename
and content unchanged under `{slug}-tex/`; it is part of the raw archive tree and is not a local naming
convention.

Do not rename that raw member to `metadata.json`. Its fields describe only part of the submitted source
package, such as source-file usage, compiler, TeX Live version, or package specification. The local document
manifest is not based on this optional file. Initial automation preserves it as an archive member and may
record its path/checksum, but otherwise ignores its contents. A future build-diagnostics feature may consume
its package-control facts separately.

## Document manifest

`{slug}/metadata.json` is the local authoritative metadata manifest for one logical source document. JSON is
used because the manifest is one bounded object that automation can validate, update when another source
form arrives, and project directly into a row of a parent JSONL inventory store.

The manifest is assembled from durable evidence rather than extracted from one convenient file:

1. **Provider/acquisition metadata** supplies external identity and bibliographic facts. For arXiv this is
   the versioned id, title, authors, abstract, categories, publication/update dates, DOI, canonical URLs,
   acquisition time/tool, and requested artifact results currently captured in `{slug}.arxiv.json`.
2. **Deposited files** supply local truth: which forms are present, their normalized relative paths, detected
   formats, byte sizes, checksums, and archive-to-extraction relationship.
3. **Document-embedded declarations** are supplemental evidence. For LaTeX, automation discovers the actual
   entrypoint rather than assuming it is named `main.tex`, resolves included source, and parses declarations
   such as title, authors, and DOI through the LaTeX-aware layer. These facts retain source provenance and do
   not silently overwrite conflicting provider metadata.
4. **Curated corrections** remain explicit, attributed updates rather than being lost when automation
   refreshes machine-derived fields.

No single source is complete. Provider metadata does not prove which local files survived; filesystem facts
do not supply bibliographic identity; and LaTeX declarations are often absent, class-specific, split across
inputs, or intended for typesetting rather than normalized catalog use.

The emitted `codex-scientiae/document-metadata/0.1` shape and its
[`metadata.schema.json`](../../src/shared/jsonl_engine/schemas/metadata.schema.json) are provisional. The
final schema is still to be finalized and is expected to cover:

- schema/version and logical document identity;
- provider identifiers and versioned slug;
- field/source provenance and explicit conflict handling;
- available source forms, including archive, extracted LaTeX, PDF, and supplements;
- acquisition provenance and timestamps;
- relative paths, formats, byte sizes, and checksums;
- relationships between an archive and its extraction;
- the preserved presence of upstream package-control files without depending on their contents; and
- later local derivations without confusing them with acquired source forms.

When a new form of the same document is acquired, such as a PDF after LaTeX source, automation updates the
same manifest through an explicit, validated operation. It does not create a competing document manifest.

## Localized inventory stores

A selected parent directory may own one `inventory.jsonl` materialized from authoritative child
`metadata.json` manifests. The provisional `codex-scientiae/document-inventory-row/0.1` shape is specified
by [`inventory-row.schema.json`](../../src/shared/jsonl_engine/schemas/inventory-row.schema.json). Each row
carries:

- `document_parent`, the direct-child path relative to the catalog root and the catalog's portable,
  case-insensitively unique identity key;
- `metadata_path`, exactly `{document_parent}/metadata.json`;
- `metadata_sha256`, which makes a changed sentinel visibly stale rather than silently following it;
- the manifest schema/state and slug; and
- the manifest's bounded `document` projection for inexpensive inventory inspection.

Version 0.1 deliberately materializes one directory level only. A directory without `metadata.json` is not
inferred to be a document and is ignored. A present but malformed, schema-invalid, wrongly located, or
slug-disagreeing sentinel aborts the complete build. Rows sort by preserved `document_parent` spelling using
ordinal comparison, while case-insensitive uniqueness exposes portable path collisions. There is no build
timestamp, so identical sentinels produce byte-identical UTF-8-no-BOM, LF-only catalog bytes.

The PowerShell materializer below predates the schema move and no longer dot-sources: its schema paths still
resolve into this directory. It stands as the specification for the Python replacement — admission rules,
ordinal sort with case-insensitive uniqueness, and the cross-artifact identity checks on read — rather than
as a runnable tool.

The application-local materializer is explicit and whole-file transactional:

```pwsh
. ./src/latex-ingest/inventory-catalog.ps1

# First publication refuses an existing inventory.jsonl.
Write-LatexInventoryCatalog -InventoryRoot ./ingestion/inventory

# Deliberate rebuild atomically replaces it.
Write-LatexInventoryCatalog -InventoryRoot ./ingestion/inventory -ExistingFile Replace

# Read validates row shape/order, paths, current sentinel hashes, and manifest identity.
$rows = @(Read-LatexInventoryCatalog ./ingestion/inventory/inventory.jsonl)
```

Materialization never initializes, repairs, or recursively infers a source deposit. It does not yet create an
index or provide incremental mutation, multi-writer coordination, recursive rollups, move/alias history, or
top-down/bottom-up reconciliation. Those remain in the managed-store and hierarchical-catalog roadmap; the
current private whole-file codec is replaced by the canonical shared substrate when that substrate is
integrated.
