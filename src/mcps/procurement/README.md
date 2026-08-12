# Procurement MCP

`scientiae-procurement` is the Python MCP projection of the procurement discovery and metadata services. It
owns SDK registration, tool schemas, prompts, and application lifespan. It does not own provider algorithms
or cross-provider workflows.

Run the stdio server from the repository environment:

```pwsh
.venv/Scripts/python.exe -m mcps.procurement
```

The installed script name is `scientiae-procurement`. Discovery uses `discover_search`,
`discover_related`, `resolve_reference`, and `get_work`. `list_procurement_providers` exposes the distinct
artifact and metadata roles. `prepare_source_deposit_metadata` returns a validated, self-contained metadata
bundle with the exact HTTP-decoded entity payload consumed by its provider normalizer, a digest, and
identity-checked fallback history. It does not claim to preserve compressed on-wire framing.
`prepare_article_metadata_by_doi` is the independent route for a caller-selected DOI. It reads an existing
acquisition receipt so its identity anchor stays separate from, but correctly bound to, byte provenance; it
does not claim that the bytes came from the selected metadata provider.

Artifact retrieval is deliberately separate. `plan_artifact_acquisition` returns a URL-free summary from a
fresh server-side provider plan; `acquire_artifact` replans internally, downloads requested source/PDF/HTML
forms to configured staging, and publishes or validates `acquisition.json`.
`get_acquisition_receipt` revalidates a staged receipt and every file it names. None of these tools accepts
a client-selected URL, serialized plan, absolute destination, or arbitrary storage root.
`list_local_import_inboxes` exposes configured logical inbox names, and `import_local_artifact` validates a
portable direct-child PDF or gzip source before publishing the same acquisition receipt with explicit
`local-import` custody. It accepts neither a host path nor a URL.

Server-selected storage names do not by themselves pin filesystem identity. A local actor able to replace
a configured staging or source-catalog root or ancestor can redirect a mutating operation. Do not cut the
mutating tools over from the legacy deployment until those hierarchical roots are pinned, or deployment
protects them from replacement. Inventory rebuild already pins its selected catalog generation.

`list_article_catalogs` exposes the configured names accepted by the filesystem operations; clients cannot
submit a root path. `materialize_source_deposit` consumes one existing acquisition receipt, safely unpacks
and validates its source, optionally copies its receipted PDF, and publishes `article.json` last. Its typed
metadata strategy is `artifact-identity`, `explicit-doi`, or `omit`; the first two reuse or persist
`{slug}.api-metadata.json`, while omit never calls a metadata provider. An explicit DOI is cross-checked
against any DOI declared by the validated LaTeX closure. It does not acquire bytes or
rebuild an inventory.

`inspect_article_catalog` reports the current direct-child source-ready population without writing.
`rebuild_article_inventory` independently rebuilds `inventory.jsonl` from that population and requires
`force=true` to replace an existing inventory. `prepare_source_deposit_metadata` remains useful as the
independent metadata-only route. API metadata supplies bibliographic evidence; source materialization
separately supplies the seven source-integrity findings.

The intended compositions are deliberately non-unitary:

- Get one paper: plan and acquire, or import a configured local file, then stop at `acquisition.json`.
- Prepare one source: acquire/import if needed, select artifact or DOI metadata, then materialize the same
  `article.json` contract.
- Refresh a catalog: rebuild `inventory.jsonl` across any pre-existing direct-child articles, without
  reacquiring or unpacking them.

Within an unchanged source-catalog generation, the first source-ready publication freezes both metadata
mode and PDF inclusion. Later acquisition can add staged forms, but materialization refuses any form-set
change that would mutate the immutable article. Inventory replacement is generation-pinned and requires an
explicit `force` request.

A PDF-only acquisition can be receipted and can motivate an explicit DOI lookup, but the current
materializer does not mint `article.json` from a lone PDF. That route requires a separately versioned PDF
validation profile rather than an exception to the LaTeX source-ready contract.
