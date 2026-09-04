# Procurement MCP

`scientiae-procurement` is the Python MCP projection of the procurement discovery and metadata services. It
owns SDK registration, tool schemas, prompts, and application lifespan. It does not own provider algorithms
or cross-provider workflows. Provider arguments are names validated by the backend catalog; protocol
schemas do not duplicate a fixed provider enum. `list_procurement_providers` reports the current category,
roles, capabilities, and honored search constraints.

`server.py` is the composition and lifespan owner. Protocol-only request aliases and response projections
live in `contracts.py`, shared request context and cancellation handling live in `runtime.py`, and concrete
handlers are registered in protocol order from the modules under `tools/`. Tool modules resolve application
services only through the active MCP request context.

Restore the pinned repository environment and generate the local registration:

```pwsh
./brewery/uv/restore-uv.ps1
```

The generated registration invokes `./packages/uv/uv.exe` with a project-local root and
`--locked --no-sync --no-dev --offline`; activation and ambient Python or uv discovery are not
required. The installed script name is `scientiae-procurement`. Discovery uses `discover_search`,
`discover_related`, `resolve_reference`, and `get_work`. `list_procurement_providers` exposes the distinct
artifact and metadata roles. `prepare_source_deposit_metadata` returns a validated, self-contained metadata
bundle with the exact HTTP-decoded entity payload consumed by its provider normalizer, a digest, and
identity-checked fallback history. It does not claim to preserve compressed on-wire framing.
`prepare_article_metadata_by_doi` is the independent route for a caller-selected DOI. It reads an existing
acquisition receipt so its identity anchor stays separate from, but correctly bound to, byte provenance; it
does not claim that the bytes came from the selected metadata provider.

Artifact retrieval is deliberately separate. `plan_artifact_acquisition` returns a URL-free summary from a
fresh server-side provider plan; `acquire_artifact` replans internally, downloads requested source/PDF/HTML
forms, and publishes or validates `acquisition.json`. Pass `catalog` to write the receipt into a configured catalog name or a workspace-relative
destination such as `ingestion/gauntlet/topic`; omit it to use staging. Missing destination
folders are created. `get_acquisition_receipt` revalidates a receipt and
every form it names (files and the HTML tree). None of these tools accepts a client-selected URL, serialized plan, absolute
destination, or arbitrary storage root.
`list_local_import_inboxes` exposes configured logical inbox names, and `import_local_artifact` validates a
portable direct-child PDF or gzip source before publishing the same acquisition receipt with explicit
`local-import` custody. It accepts neither a host path nor a URL.

The application retains the physical identities of every configured storage root. Acquisition and local
import use the retained staging, item, and inbox generations for byte transfer, validation, recovery, and
receipt publication. Replacement is either blocked or makes the operation fail without writing to or
reporting success against the replacement. Source materialization retains the acquisition item, catalog,
document, private extraction tree, and final tree through archive expansion, form and metadata publication,
and article publication. Inventory rebuild pins its selected catalog generation through publication.

`list_article_catalogs` exposes only the configured names accepted by the filesystem operations; catalog
inspection and rebuild responses likewise omit physical host paths. Clients cannot submit a root path.
`materialize_source_deposit` consumes one existing acquisition receipt in the named catalog leaf, unpacks
and validates its source in place, and publishes `article.json` last. The receipted archive leaf is kept;
the extracted tree is `{slug}-tex/`. Its typed
metadata strategy is `artifact-identity`, `explicit-doi`, or `omit`; the first two reuse or persist
`{slug}.api-metadata.json`, while omit never calls a metadata provider. An explicit DOI is cross-checked
against any DOI declared by the validated LaTeX closure. Default publication freezes PDF and HTML
inclusion; `rebuild=true` replaces a stale sentinel from current receipt evidence. It does not acquire
bytes or rebuild an inventory. HTML, when receipted, is `{slug}-html/` with entrypoint `{slug}.html`.
Absence at the provider is `unavailable` and does not fail a source-ready procure.

`procure_source` is acquire then materialize in lock-step at one destination. It requires a catalog
destination and a source artifact (default forms are source, PDF, and HTML). Independent acquire, import,
and materialize tools remain for bytes-only work and retries. `acquire_artifact` still defaults to source
only.

`inspect_article_catalog` reports the current direct-child source-ready population and whether
`inventory.jsonl` is present, without writing. `rebuild_article_inventory` rebuilds `inventory.jsonl`
from direct-child `article.json` and requires `force=true` to replace an existing inventory.
`fold_article_inventory` publishes a parent `inventory.jsonl` from direct-child `inventory.jsonl`
stores; it does not walk `article.json`. `prepare_source_deposit_metadata` remains useful as the
independent metadata-only route. API metadata supplies bibliographic evidence; source materialization
separately supplies the seven source-integrity findings.

The intended compositions are:

- Procure one source-ready leaf: `procure_source` into a catalog name or workspace-relative destination.
- Get bytes only: plan and acquire, or import a configured local file, then stop at `acquisition.json`.
- Materialize an existing receipt: `materialize_source_deposit` on that same destination leaf.
- After any successful deposit into destination `C`: `rebuild_article_inventory` on `C` with
  `force=true`. First-order inventories are compulsory. Fold a second-order inventory with
  `fold_article_inventory` only when asked.
- Rebuild a stale sentinel after later forms land: `materialize_source_deposit` with `rebuild=true`,
  then rebuild the first-order inventory.
- Refresh a first-order catalog: rebuild `inventory.jsonl` from current direct-child articles,
  without reacquiring or unpacking them.

The first source-ready publication freezes metadata mode and PDF and HTML inclusion. Later acquisition
can add staged forms. Default materialization refuses a form-set change; `materialize_source_deposit` with
`rebuild=true` rewrites `article.json` from the current receipt. Interrupted pre-sentinel components are
validated and adopted on retry; private tree scratch is swept under the source lease. Inventory
replacement is generation-pinned and requires an explicit `force` request.

A PDF-only acquisition can be receipted and can motivate an explicit DOI lookup, but the current
materializer does not mint `article.json` from a lone PDF. That route requires a separately versioned PDF
validation profile rather than an exception to the LaTeX source-ready contract.

## Tests

Python containers under `tests/procurement` and `tests/mcp-servers/procurement_mcp`, and Pester
files for the PowerShell catalog/deposit scripts, run through `tests/batch.ps1`. It mints
`artifacts/tests/{suite}/YYYYMMDD_HHmmss[_NN]`. Do not invoke pytest directly and do not create a
`test-runs` directory.
