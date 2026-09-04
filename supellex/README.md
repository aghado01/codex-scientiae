# Supellex workspace

`supellex/` is transitional: it contains source intake, document deposits, reprocessing queues, generated
lane output, and curated collection material accumulated under several generations of tooling. Do not treat
the whole tree as one homogeneous inventory and do not bulk-rename it into apparent compliance.

The adoption unit is a deliberately selected segment and, within it, one logical document leaf at a time.
The current source-deposit contract is specified in [`staging/CONVENTION.md`](staging/CONVENTION.md).

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
forward-slash paths relative to the document directory. No deposit convention depends on a drive letter,
user profile, checkout location, or current machine.

## Compliant document leaf

```text
{slug}/
  {slug}.tar.gz         # optional acquired LaTeX source archive
  {slug}-tex/           # validated stable extraction
  {slug}.pdf            # optional acquired PDF form
  {slug}.arxiv.json     # optional provider/acquisition evidence
  {slug}-latex.patch.jsonl # optional document-local LaTeX errata
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
   . ./src/procurement/scripts/latex-source.ps1
   New-LatexSourceDeposit -DocumentDir './supellex/<segment>/<slug>'
   ```

6. Inspect the returned status and validate the article when reviewing a migration:

   ```pwsh
   Import-Module ./src/jsonl_engine-client/jsonl_engine-client.psd1
   $articlePath = (Resolve-Path './supellex/<segment>/<slug>/article.json').Path
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

## Inventory and batch migration

The canonical localized inventory model is a deterministic JSONL materialization of direct-child
`article.json` objects. Each flat `codex-scientiae/article/0.1` object is inserted verbatim as one row, with
`/slug` as its declared identity.

On-demand helpers:

```pwsh
# Full unpack/validate/deposit ceremony for arXiv-shaped archives under a catalog parent
pwsh -File ./src/procurement/scripts/catalog.ps1 -DepositBatch -CatalogDir ./supellex/staging

# Sweep direct-child article.json and build inventory.jsonl via jsonl_engine
pwsh -File ./src/procurement/scripts/catalog.ps1 -Build -CatalogDir ./supellex/staging

# Overwrite an existing inventory.jsonl
pwsh -File ./src/procurement/scripts/catalog.ps1 -Build -CatalogDir ./supellex/staging -Force

# Fold child inventories into a parent inventory.jsonl
pwsh -File ./src/procurement/scripts/catalog.ps1 -Fold -CatalogDir ./supellex/gauntlet -Force
```

After procuring into a destination, rebuild that destination's first-order `inventory.jsonl`
(`rebuild_article_inventory`, `force=true`). Fold a parent inventory only when asked
(`fold_article_inventory`).

Do not create new `metadata.json` sentinels. Deposit publication is `New-LatexSourceDeposit` (`article.json`).

## Existing top-level segments

Treat these as present-day routing hints, not a declaration that every child already complies:

| Segment | Current interpretation |
|---|---|
| `staging/` | Sandbox for the source-deposit/article convention. MCP catalog name `inventory`. |
| `gauntlet/` | Curated collection of deposited articles. |
| `imports/` | Configured local-import inbox (`manual`). |
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
- [ ] Any document-local LaTeX patch is reviewed as explicit curation and remains outside `{slug}-tex/`
      and generated output.
- [ ] Generated evidence is found under the run directory, not `{slug}-tex/`.
- [ ] Legacy `metadata.json`, `{slug}-latex/`, and compatibility-only exceptions are recorded for removal.
- [ ] Any localized inventory is deliberately materialized from explicit direct-child articles, or
      folded from child `inventory.jsonl` stores; recursive asset inference does not substitute
      for a missing sentinel.
