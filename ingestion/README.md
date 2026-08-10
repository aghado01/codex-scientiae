# Ingestion workspace

`ingestion/` is transitional: it contains source intake, document deposits, reprocessing queues, generated
lane output, and curated collection material accumulated under several generations of tooling. Do not treat
the whole tree as one homogeneous inventory and do not bulk-rename it into apparent compliance.

The adoption unit is a deliberately selected segment and, within it, one logical document leaf at a time.
The current source-deposit contract is specified in [`inventory/CONVENTION.md`](inventory/CONVENTION.md).

## Separate the four address classes

1. **Source deposits** are stable inputs. A compliant document leaf owns its acquired forms, normalized raw
   extraction, provider evidence, and canonical `article.json`.
2. **Run artifacts** are regenerable evidence from one execution. They belong under
   `artifacts/{module}/runs/{runstamp}/...`, not inside source deposits.
3. **Lane output and deliverables** are rendered projections or published bundles. They are neither acquired
   source nor permission to infer a source deposit.
4. **Document-local application curation** is durable input maintained beside a deposit without becoming
   acquired source truth. The optional LaTeX patch file belongs to this class; it is neither an article field
   nor generated lane output.

Runtimes may resolve absolute paths for confinement and I/O, but persisted article paths are portable,
forward-slash paths relative to the document directory. No ingestion convention depends on a drive letter,
user profile, checkout location, or current machine.

## Compliant document leaf

```text
{slug}/
  {slug}.tar.gz         # optional acquired LaTeX source archive
  {slug}-tex/           # validated stable extraction
  {slug}.pdf            # optional acquired PDF form
  {slug}.arxiv.json     # optional provider/acquisition evidence
  {slug}-latex.patch.jsonl # optional latex-ingest curated errata
  article.json          # source-ready transaction sentinel and flat article manifest
```

The version suffix, when one exists, is part of `{slug}`. One leaf represents one logical document version.
Do not place converter reports, graphs, JSONL work stores, render logs, or runstamped output in `{slug}-tex/`.

## Classify before reorganizing

For a selected segment, identify each candidate as one of:

- a document leaf containing primary acquired material;
- a collection/container whose children may be document leaves;
- intake or procurement staging that is not yet authoritative;
- a reprocessing queue;
- generated lane output or a deliverable shelf; or
- unresolved/mixed material requiring review.

Names alone are not evidence. In particular, do not recursively interpret every PDF, tarball, JSON file,
figure directory, converter output, or old `{slug}-latex/` directory as a document deposit. Record ambiguous
cases for review rather than creating `article.json` speculatively.

## Standardize one source leaf

Run commands from the repository root or supply another explicit/relative document address.

1. Choose the canonical versioned slug and document parent.
2. Place the acquired source archive directly under that parent. The transaction accepts `{slug}.tar.gz` or
   the acquisition alias `arXiv-{slug}.tar.gz`; the alias is normalized only after private extraction passes.
3. Place matching provider evidence such as `{slug}.arxiv.json` beside the archive when available. It is
   optional and does not replace filesystem validation.
4. Do not manually create `article.json` or copy an old extraction into `{slug}-tex/` merely to satisfy the
   shape. Let the transaction establish those assertions.
5. Publish the deposit:

   ```pwsh
   . ./src/logistics/latex-source.ps1
   New-LatexSourceDeposit -DocumentDir './ingestion/<segment>/<slug>'
   ```

6. Inspect the returned status and validate the article when reviewing a migration:

   ```pwsh
   Import-Module ./src/jsonl_engine-client/jsonl_engine-client.psd1
   $articlePath = (Resolve-Path './ingestion/<segment>/<slug>/article.json').Path
   $validated = @(Invoke-JsonlEngineCommand `
       -Verb validate-json -Argument @($articlePath, 'article.schema.json'))
   if ($validated.Count -ne 1) { throw "expected one validated article" }
   $validated[0].value
   ```

`New-LatexSourceDeposit` is one transaction across two runtimes. PowerShell owns extraction, source
confinement, entrypoint selection, LaTeX declarations, the tree fingerprint, and the probe ledger. It holds
the per-document source lock until finalization completes. The document root, extracted descendants, and
explicit or implicitly discovered archive, provider, PDF, and findings inputs may not traverse symbolic links
or reparse points. Python independently rechecks confinement and portable paths, establishes file-generation
witnesses, projects provider evidence, and applies `article.schema.json` plus `ArticleManifest` cross-field
relations before creating `article.json` last. It checks the source witnesses again after publication; drift
rolls back only the exact article this transaction created, while a concurrently replaced sentinel is never
deleted. Existing equivalent evidence is returned idempotently; an existing article or source tree with
different evidence is a conflict, never an overwrite. Failure publishes no partial article.

## Convert a standardized leaf

The production converter accepts a source-ready article or its document directory:

```pwsh
. ./src/latex-ingest/latex-ingest.ps1

Invoke-ArxivLatexToMarkdown `
    -MetadataPath './ingestion/<segment>/<slug>/article.json' `
    -OutDir ./path/to/lane-output
```

`-DocumentDir` remains an alias for the historically named `-MetadataPath`. A directory input resolves
`article.json` first. During bounded migration only, the converter may fall back to `metadata.json` and the
older `codex-scientiae/document-metadata/0.1` shape. New automation must not produce that legacy file.

The production entrypoint revalidates the archive and source fingerprints, reads the article-owned
entrypoint, and writes generated ref/doc/diagram/oracle evidence into the run directory. Before trusting a
canonical article it calls the Python engine's `validate-json <path> article.schema.json` verb; this is the
authoritative consumption-time schema check. Batch-adapter planning intentionally remains a shallow,
process-free address and identity check. The converter never initializes, infers an archive, recognizes
`{slug}-latex/`, or writes into the source tree.

An optional `{slug}-latex.patch.jsonl` is resolved only from the validated article's document directory. It
is a durable latex-ingest curation input, independent of the source-deposit transaction and excluded from the
article's immutable source forms and tree fingerprint. The converter never creates or mutates it, and a file
with the same name in `-OutDir` is ignored. Lookup constructs that one literal leaf from the manifest slug;
it does not scan for alternatives. The slug follows `article.schema.json#/$defs/portableLeaf`: one nonempty
segment; not `.` or `..`; no trailing dot or space, `<>:"/\|?*`, control characters U+0000–U+001F, or
case-insensitive Windows device basename (`CON`, `PRN`, `AUX`, `NUL`, `COM1`–`COM9`, `LPT1`–`LPT9`) before
a dot or end. Absence is a faithful no-op. A present patch must be a physical non-reparse file of at most
1 MiB (1,048,576 raw bytes). Present files deliberately retain a tolerant application grammar: blank lines
and full-line `#` or `//` comments are allowed, while every other line is one JSON patch object with a
supported operation and a required reason. This exception is not parsed or normalized through the strict
shared JSONL engine.

Applied records retain physical-line and curator provenance in file order. Stale or count-mismatched records
fail loudly. The conversion result exposes the raw-byte identity (`absent` or
`sha256:<64-lowercase-hex>`) as `patch_identity` and the ordered records as `patched[]`; the run-local oracle
records the same identity and `patches_applied`. Batch planning pins the identity and the worker refuses a
created, removed, or changed patch rather than executing under a stale job identity.

## Inventory and batch migration

The canonical localized inventory model is a deterministic JSONL materialization of direct-child
`article.json` objects. Each flat `codex-scientiae/article/0.1` object is inserted verbatim as one row, with
`/slug` as its declared identity. A current canonical article materializer has not yet replaced the
metadata-era catalog implementation.

`src/latex-ingest/inventory-catalog.ps1` and its nested metadata row shape remain a legacy specification of
useful admission behavior—direct-child scope, complete failure on an invalid present sentinel, deterministic
ordering, and collision checks. They are not active canonical `article.json` producers or materializers.

The public `Get-LatexBatchJob` adapter can already resolve an explicitly supplied `article.json` or a
document-directory address, preferring `article.json` for a directory. It temporarily accepts legacy
`metadata.json` readers as well. The repository `src/latex-ingest/latex-batch.ps1` shell is still coupled to
the legacy catalog reader; migrating that materialization/read path is separate from article deposit and
converter activation.

## Legacy compatibility is a bounded migration tool

Old archive/slug callers may explicitly import `src/latex-ingest/latex-ingest-compat.ps1`. That compatibility
surface may still read an existing metadata-era `metadata.json`, but deposit publication is only through
`New-LatexSourceDeposit` (`article.json`). Do not create new `metadata.json` sentinels.

Explicit source reuse or work-directory overrides in the compatibility shim may keep an investigation
moving, but the shim warns and labels such results `compat-*`. Such a run does not make a leaf compliant.
Retire the compatibility readers and producer only after their callers and existing deposits have migrated.

## Existing top-level segments

Treat these as present-day routing hints, not a declaration that every child already complies:

| Segment | Current interpretation |
|---|---|
| `inventory/` | Sandbox and proving ground for the source-deposit/article convention. |
| `_inbox/` | Historical intake and partially processed material; survey before moving. |
| `staging/` | Procurement or workflow staging; not authoritative solely because a file is present. |
| `re-ingest/` | Reprocessing queue/workspace; generated intermediates may coexist with inputs. |
| `_markdown/` | Generated LaTeX lane output; not a source-deposit root. |
| `codices/`, `compendia/` | Curated collection/delivery structures; do not infer raw source leaves from them. |
| Other named segments | Classify locally; preserve collection semantics while normalizing genuine document leaves. |

When a segment is adopted, add a small segment-local note defining its scope, expected document depth,
exceptions, and migration state. Do not encode one segment's nesting assumptions into the generic deposit.

## Adoption checklist

- [ ] Segment scope and document depth are stated.
- [ ] Primary source, generated output, and unresolved material are separated conceptually.
- [ ] Each migrated leaf has one intentional slug and no silent name/path collisions.
- [ ] Archive/provider evidence belongs to the same logical document version.
- [ ] `New-LatexSourceDeposit` succeeds and creates or idempotently validates `article.json`.
- [ ] The article validates as flat `codex-scientiae/article/0.1`.
- [ ] A production conversion succeeds through the article or document directory without changing the
      source-tree fingerprint.
- [ ] Any document-local LaTeX patch is reviewed as explicit curation, remains outside `{slug}-tex/` and
      generated output, and has a conversion audit matching its raw-byte identity.
- [ ] Generated evidence is found under the run directory, not `{slug}-tex/`.
- [ ] Legacy `metadata.json`, `{slug}-latex/`, and compatibility-only exceptions are recorded for removal.
- [ ] Any localized inventory is deliberately materialized from explicit direct-child articles; recursive
      asset inference does not substitute for a missing sentinel.
