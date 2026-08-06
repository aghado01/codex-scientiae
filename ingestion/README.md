# Ingestion workspace

`ingestion/` is transitional: it contains source intake, document deposits, reprocessing queues, generated
lane output, and curated collection material accumulated under several generations of tooling. Do not treat
the whole tree as one homogeneous inventory and do not bulk-rename it into apparent compliance.

The adoption unit is a deliberately selected segment and, within it, one logical document leaf at a time.
The current source-deposit contract is specified in [`inventory/CONVENTION.md`](inventory/CONVENTION.md).

## Separate the three address classes

1. **Source deposits** are stable inputs. A compliant document leaf owns its acquired forms, normalized raw
   extraction, provider evidence, and `metadata.json`.
2. **Run artifacts** are regenerable evidence from one execution. They belong under
   `artifacts/{module}/runs/{runstamp}/...`, not inside source deposits.
3. **Lane output and deliverables** are rendered projections or published bundles. They are neither acquired
   source nor permission to infer a source deposit.

Runtimes may resolve absolute paths for confinement and I/O, but persisted manifest paths are portable,
forward-slash paths relative to the document directory. No ingestion convention depends on a drive letter,
user profile, checkout location, or current machine.

## Compliant document leaf

```text
{slug}/
  {slug}.tar.gz         # optional acquired LaTeX source archive
  {slug}-tex/           # validated stable extraction
  {slug}.pdf            # optional acquired PDF form
  {slug}.arxiv.json     # optional provider/acquisition evidence
  metadata.json         # source-ready transaction sentinel and document manifest
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
cases for review rather than creating `metadata.json` speculatively.

## Standardize one source leaf

Run commands from the repository root or supply another explicit/relative document address.

1. Choose the canonical versioned slug and document parent.
2. Place the acquired source archive directly under that parent. The initializer accepts `{slug}.tar.gz` or
   the acquisition alias `arXiv-{slug}.tar.gz`; the alias is normalized only after private extraction passes.
3. Place matching provider evidence such as `{slug}.arxiv.json` beside the archive when available. It is
   optional and does not replace filesystem validation.
4. Do not manually create `metadata.json` or copy an old extraction into `{slug}-tex/` merely to satisfy the
   shape. Let the transaction establish that assertion.
5. Initialize the deposit:

   ```pwsh
   . ./src/latex-ingest/source-deposit.ps1
   Initialize-LatexSourceDeposit -DocumentDir './ingestion/<segment>/<slug>'
   ```

6. Inspect the returned status and validate the manifest when reviewing a migration:

   ```pwsh
   Get-Content './ingestion/<segment>/<slug>/metadata.json' -Raw |
       Test-Json -SchemaFile ./ingestion/inventory/metadata.schema.json
   ```

The initializer extracts privately, validates confinement/encoding/entrypoint/input structure, publishes
`{slug}-tex/`, and writes `metadata.json` last. Failure leaves no sentinel. An existing different tree or
manifest is a conflict, not an overwrite. A matching tree left before a crashed sentinel commit is recovered
by re-extraction and fingerprint comparison.

## Convert a standardized leaf

The production converter accepts the initialized deposit only. Passing either the manifest or its document
directory is equivalent:

```pwsh
. ./src/latex-ingest/latex-ingest.ps1

Invoke-ArxivLatexToMarkdown `
    -MetadataPath './ingestion/<segment>/<slug>/metadata.json' `
    -OutDir ./path/to/lane-output
```

`-DocumentDir` is an alias for `-MetadataPath`. The production entrypoint revalidates the archive and source
fingerprints, reads the manifest-owned entrypoint, and writes generated ref/doc/diagram/oracle evidence into
the run directory. It never initializes, infers an archive, recognizes `{slug}-latex/`, or writes into the
source tree.

## Materialize and batch a standardized segment

Once selected child deposits have source-ready sentinels, materialize the segment-local catalog explicitly:

```pwsh
. ./src/latex-ingest/inventory-catalog.ps1
Write-LatexInventoryCatalog ./ingestion/inventory -ExistingFile Replace
```

The current catalog covers direct child deposits only. It ignores children without `metadata.json` and
aborts rather than omitting a present invalid sentinel. `Read-LatexInventoryCatalog` also rejects stale
manifest hashes, noncanonical row order, portable path collisions, and paths outside the catalog root.

The latex-ingest development shell consumes that catalog, allocates a run under
`artifacts/latex-batch/runs/`, and composes the public adapter and executor:

```pwsh
pwsh -File ./src/latex-ingest/latex-batch.ps1
pwsh -File ./src/latex-ingest/latex-batch.ps1 -Slug 2405.12350v1 -MaxWorkers 1
```

`-InventoryPath`, `-RunDirectory`, and `-ArtifactsRoot` override the defaults. An explicit run directory must
already exist; otherwise the shell allocates one. The shell does not initialize source deposits. It returns
the executor record and throws after emitting it when any job or executor infrastructure fails, preserving
successful sibling evidence.

## Legacy compatibility is a bounded migration tool

Old archive/slug callers must explicitly import the compatibility surface:

```pwsh
. ./src/latex-ingest/latex-ingest-compat.ps1

Invoke-ArxivLatexToMarkdownLegacy `
    -TarGz './ingestion/<segment>/<slug>/<slug>.tar.gz' `
    -Slug '<slug>' `
    -OutDir ./path/to/lane-output
```

For a conventional archive-backed leaf, the shim initializes/normalizes the deposit and then delegates to
the production entrypoint. Retired helper names, `{slug}-latex/`, `-ReuseSource`, and arbitrary
`-SourceWorkDir` behavior exist only in this file.

Explicit reuse or source-work overrides may bypass manifest initialization to keep an investigation moving;
the shim emits a warning and labels the result `compat-*`. Such a run does **not** make the leaf compliant and
must not be used as evidence that `metadata.json` may be hand-authored. The compatibility file is a temporary
migration boundary, not the API to use in new automation.

## Existing top-level segments

Treat these as present-day routing hints, not a declaration that every child already complies:

| Segment | Current interpretation |
|---|---|
| `inventory/` | Sandbox and proving ground for the source-deposit/manifest convention. |
| `_inbox/` | Historical intake and partially processed material; survey before moving. |
| `staging/` | Procurement or workflow staging; not authoritative solely because a file is present. |
| `re-ingest/` | Reprocessing queue/workspace; generated intermediates may coexist with inputs. |
| `_markdown/` | Generated LaTeX lane output; not a source-deposit root. |
| `codices/`, `compendia/` | Curated collection/delivery structures; do not infer raw source leaves from them. |
| Other named segments | Classify locally; preserve collection semantics while normalizing genuine document leaves. |

When a segment is adopted, add a small segment-local note defining its scope, expected document depth,
exceptions, and migration state. Do not encode one segment's nesting assumptions into the generic initializer.

## Adoption checklist

- [ ] Segment scope and document depth are stated.
- [ ] Primary source, generated output, and unresolved material are separated conceptually.
- [ ] Each migrated leaf has one intentional slug and no silent name/path collisions.
- [ ] Archive/provider evidence belongs to the same logical document version.
- [ ] Initialization succeeds and creates `metadata.json` last.
- [ ] Manifest validates against the provisional schema.
- [ ] A production conversion succeeds through `-MetadataPath` without changing the source-tree fingerprint.
- [ ] Generated evidence is found under the run directory, not `{slug}-tex/`.
- [ ] Legacy `{slug}-latex/` or compatibility-only exceptions are recorded for later removal.
- [ ] A segment-local `inventory.jsonl` is deliberately materialized from direct child sentinels; no
      recursive asset inference substitutes for missing manifests.
