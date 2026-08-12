# Procurement Python architecture

Status: discovery, API metadata, synchronous acquisition, source materialization, and catalog rebuild are
functionally implemented. Staging and source-deposit root-identity pinning, background job lifecycle, and
legacy cutover remain deferred.

This document reconciles `procurement-breakdown.md`, `opus-metadata.md`,
`mcp-separation-of-concerns.md`, `claude-procurement-refactor.md`, and
`grok-procurement-python.md` against the repository state on 2026-08-11. The historical documents remain
design evidence. This document records the current target.

## Repository reality

- The legacy PowerShell MCP shells are under `src/mcp-servers/procurement`; their provider libraries now
  coexist temporarily with the Python package under `src/procurement`.
- The legacy procurement data directories are `schemas/` and `store/`, alongside the Python `stores/`
  directory. The legacy files under `schemas/` are layout configuration instances rather than JSON
  Schemas.
- `scholar-server.ps1` owns fan-out, graph routing, DOI resolution, and acquisition routing in its MCP
  dispatch switch.
- `scholar-core.ps1` combines HTTP lifecycle, rate state, retry classification, identifier policy, records,
  merging, and paging.
- arXiv and Zenodo combine discovery, acquisition, staging, and job state. The Zenodo job operation is
  synchronous despite its background-job contract.

The Python target is introduced alongside the PowerShell implementation. `src/mcp-servers` is a legacy
island until explicit parity gates permit deletion. The target MCP package is `src/mcps`.

## Decisions

### One language across the boundary

Both the procurement package and the MCP surface are Python. The earlier TypeScript-MCP proposal is
superseded by the current Python direction. The MCP layer uses the official Python SDK rather than a local
JSON-RPC loop.

### One-way dependency direction

```text
mcps.procurement
    -> procurement.services
        -> provider capability ports and normalized values
            -> provider adapters
                -> shared HTTP and future staging mechanisms
```

`procurement` does not import MCP. Scripts, tests, and orchestrators call the Python application services
directly. The source-materialization and catalog services call the existing `jsonl_engine` article and
inventory adapters rather than duplicating their storage rules. The optional API-metadata path in
`jsonl_engine.deposit` imports the procurement evidence-bundle model so persisted sentinels and MCP output
share one behavioral validator. This feature-level shared-contract bridge is the remaining bidirectional
package seam; the generic JSONL reader, writer, and registry layers do not acquire procurement behavior.

### One agent-facing procurement MCP

The target is one `scientiae-procurement` composition root. Provider selection remains an operation
argument; it does not create duplicated servers or protocol runtimes. Separate legacy arXiv, Zenodo, and
Scholar shells remain only during migration.

### Capabilities instead of a universal provider base class

Search, lookup, citations, references, recommendations, resolution, and acquisition are separate
capabilities. A provider advertises only operations it implements. arXiv and Zenodo do not carry fake graph
methods; OpenAlex does not pretend to implement semantic recommendations.

Provider roles are separate from callable capabilities and are non-exclusive:

| Provider | Artifact origin | Artifact access | Metadata authority | Metadata aggregator |
|---|---:|---:|---:|---:|
| arXiv | yes | yes | yes, for arXiv records | no |
| Zenodo | yes | yes | yes, for Zenodo records | no |
| Sci-Hub | no | yes | no | no |
| OpenAlex | no | no | no | yes |
| Semantic Scholar | no | no | no | yes |

An aggregator can supply identity-checked bibliographic fallback metadata. It never becomes the provenance
of an artifact. Sci-Hub can describe where bytes were accessed without being represented as their origin or
metadata authority.

### Explicit runtime ownership

The application owns one asynchronous HTTP client and one keyed rate limiter. Provider endpoints and timing
policies are data. Credentials and contact information enter from the environment. Clocks, sleepers, HTTP
transports, settings, registries, and services are injectable test dependencies. No provider behavior
depends on script/module globals. Successful bodies are streamed through a 16 MiB HTTP-decoded entity cap
before parsing or evidence encoding; persisted metadata bundles have a separate 32 MiB read boundary.

### Normalization does not erase provenance

`WorkRecord.sources` contains every `{provider, identifier}` pair plus provider dates and cross-walk IDs.
The record retains separate `concepts` and arXiv `categories`; it does not map one taxonomy into the other.
DOI and arXiv fields remain convenience cross-walks, not replacements for source identities.

Deduplication indexes every known identity alias and supports transitive bridges. For example, a DOI-only
record, a DOI-plus-arXiv record, and an arXiv-only record converge even when the bridge arrives last.

`WorkRecord` is a discovery value. It is not `article.json`. Translation into an article manifest belongs
to a later metadata/deposit workflow, where arXiv metadata takes precedence when an arXiv cross-walk exists.

### Article publication is the invariant

`article.json` is the canonical publication result, not a serialization of one acquisition procedure.
Provider download, configured local import, embedded-document inspection, and API identity resolution are
independent producers of evidence consumed by one validated publisher. None owns the sentinel contract, and
a caller may stop after any producer or combine only the inputs required for the selected article profile.

The current `codex-scientiae/article/0.1` profile is LaTeX-backed, so either a provider-acquired or manually
imported source archive can reach the same `article.json` through the same archive, tree, metadata, and
publication validators. A manually imported PDF can already receive a custody receipt and independent API
metadata, but PDF-only publication requires a separately versioned article profile with PDF-specific
integrity evidence. That extension adds another producer path to `article.json`; it does not introduce a
competing `artifact.json` sentinel or relax the existing LaTeX profile.

### API metadata is an independent deposit input

Metadata preparation produces a validated `codex-scientiae/deposit-metadata/0.1` bundle. Artifact-identity
resolution binds the actual artifact provider and identifier to one selected observation. Explicit-DOI
resolution instead records a canonical caller-supplied work-identity anchor while preserving the artifact
reference as independent byte provenance. Both routes record every fallback attempt, retain the normalized
article projection, and embed the exact HTTP-decoded entity payload consumed by the provider normalizer as
canonical base64 with its SHA-256 digest, media type, retrieval time, and credential-redacted URL. It does
not claim to preserve compressed on-wire framing.

Artifact-identity selection starts with an artifact provider's own metadata authority. Metadata aggregators are
consulted only as fallbacks, and their returned DOI or versionless arXiv identity must match the artifact.
Semantic Scholar precedes OpenAlex for arXiv fallback because Semantic Scholar documents singleton lookup by
arXiv identifier; OpenAlex singleton lookup is used for DOI and OpenAlex identities, not assumed for arXiv.
Explicit-DOI selection queries only declared metadata aggregators in caller order and requires an exact
canonical DOI match. The MCP projection resolves the named acquisition receipt first, so this independent
work identity remains bound to the actual custody record rather than to client-supplied provenance. A future authority cross-walk may replace that selected projection only when every
bridge response is retained and DOI/arXiv concordance is proved.

The bundle is stored inside the document deposit as `{slug}.api-metadata.json` and passed to
`New-LatexSourceDeposit -MetadataBundlePath` or `jsonl_engine deposit --metadata-json`. The deposit engine
validates its structural schema and the shared procurement model before projecting bibliographic fields
into `article.json` and fingerprinting the bundle as evidence. The shared model checks artifact identity,
canonical slug/identifier forms, route-specific attempt order, exact response digest, selected-work
identity, an optional independent work-identity anchor, and deterministic article projection.

This route does not replace LaTeX probing. API evidence establishes bibliographic metadata; the source probe
independently establishes archive confinement, readable source, entrypoint selection, resolved literal
inputs, and the document environment. Both evidence classes appear in the same immutable sentinel.

### Partial failure is explicit

Federated search isolates provider failures and returns one report per provider. A direct single-provider
operation raises a tool-visible error. Provider-specific constraints are declared; fan-out does not call a
provider that cannot honor a requested constraint and emits an explicit provider report instead. Bounded
retries cover transport failures and selected transient server responses. Rate-limit handling is provider
policy: the default is fail-fast, while Semantic Scholar uses bounded exponential retry and `Retry-After`
under its published traffic requirements.

### Acquisition remains a transaction

The acquisition and source-materialization guarantees below currently assume each configured staging or
source-catalog pathname continues to name the same physical directory generation for the operation.
Those stores validate physical paths but do not yet pin the initialized root identity. A local process able
to rename or replace a root or ancestor can redirect later operations; production cutover is blocked until
the hierarchical acquisition/source paths are handle-relative or deployment makes them immutable to
untrusted principals. Catalog inventory rebuild is narrower: it pins one catalog generation from sentinel
reads through the main and sidecar publication and never writes a replacement generation reached by a
pathname swap.

Each acquisition-capable provider will produce an immutable `ArtifactPlan`; it will not download or publish
bytes itself. A plan identifies the canonical origin and version, orders artifact candidates, declares the
expected kind and payload signatures, attaches provider integrity evidence or policy, and states allowable
fallback and mismatch behavior. This keeps arXiv's mostly templated candidates and Zenodo's metadata-driven
file selection behind the same capability-specific contract without inventing one universal URL template.

One acquisition service will execute the plan: download into a unique partial path, validate content and
completeness, atomically publish the file, and collate its canonical manifest. Path templates remain data
where they are actually templates, and every resolved target is confined beneath a caller-owned staging
root. Non-loopback artifact routes require HTTPS, redirects cannot downgrade transport or leave the
provider-declared host set, and synchronous lock, validation, and publication work stays off the MCP event
loop. Routing between providers belongs above both discovery and acquisition.

The get-only stage publishes a narrow per-item `acquisition.json` receipt. Provider downloads record provider
identity, origin routes, local SHA-256 values, and provider-native integrity evidence. Configured local imports
record the logical inbox and original leaf as `local-import` custody without inventing an origin URL or
provider checksum. Both routes record validated local forms, but no
bibliographic projection and no source-ready claim. The name `artifact.json` is not introduced: the only
repository occurrence is an older TODO, while `article.json` is now the established source-ready sentinel.
An optional future `acquisitions.jsonl` would be a distinct staging view; it must not overload the article
`inventory.jsonl` contract.

Within an unchanged staging-root generation, the per-item acquisition receipt is the source of truth for
acquired bytes; a JSONL inventory is a rebuildable view.
`jsonl_engine` owns validated storage, atomic update, and index mechanics, while the acquisition service owns
the collation law. Partial acquisitions union with existing artifacts, repeated acquisition is idempotent,
richer provenance and integrity evidence cannot be downgraded, conflicts are visible, and manifest publish
is atomic or recoverable. `acquisition.json` does not carry bibliographic evidence. When selected,
`article.json` links and fingerprints the separately persisted API-metadata bundle rather than flattening a
second bibliographic truth into the acquisition receipt.

Within an unchanged source-catalog generation, source materialization rejects concatenated or
non-canonically terminated tar payloads. The first `article.json` publication also freezes whether a
receipted PDF is part of the deposit; a later acquisition cannot silently enrich or remove that immutable
form. Catalog inventory rebuild additionally pins the catalog generation. With `force=false` it uses atomic
no-replace publication, while `force=true` is the only replacement route within that pinned generation.

The acquisition service will not be implemented as MCP code. MCP tools will submit or call the same service
that Python orchestration calls directly.

### Jobs are not provider globals

Long-running acquisition needs a lifecycle-owned job service with explicit startup, shutdown, terminal
state, retention, and cancellation. Provider concurrency is policy: arXiv may use one worker because its
global request floor is provider-specific. The finite batch executor is not the durable/background job
service. JSONL may retain an append-only job event history, but it is not the scheduler or state machine;
restart semantics must be chosen explicitly when this slice begins.

Sci-Hub, if retained, is an optional explicitly configured acquisition provider. It is not a default DOI
route and does not own DOI identity or general acquisition policy.

## Target packages

```text
src/
  procurement/
    identifiers.py        canonical DOI, arXiv, and Zenodo identities
    models.py             immutable records and operation envelopes
    errors.py             domain/provider failure taxonomy
    http.py               owned async HTTP, rate state, bounded retry
    registry.py           provider/capability registration
    settings.py           validated configuration and environment inputs
    composition.py        application construction and lifecycle
    providers/            provider payload adapters
    services/             cross-provider workflows
    stores/               non-secret configuration data
    schemas/              actual schemas only

  mcps/
    procurement/
      server.py           SDK composition and lifecycle only
      prompts/            agent-facing procedures
```

The implemented acquisition and source lanes use cohesive `payloads.py`, `staging.py`, `archive.py`,
`source.py`, and service modules. `jobs.py` remains an expected seam only after its lifecycle contract is
accepted.

## Migration sequence

1. **Discovery foundation — implemented.** Introduce models, identifiers, HTTP policy, registry, four
   discovery adapters, federated service, Python MCP, and offline/protocol tests.
2. **API metadata bridge — implemented.** Add provider roles, exact decoded-payload witnesses, authority-first
   fallback, a validated deposit-metadata schema, MCP projection, and `article.json` integration alongside
   the independent LaTeX probe.
3. **Acquisition contracts and substrate — functionally implemented; root pinning remains a cutover gate.** Add immutable artifact-plan/candidate models, a capability-specific
   planning port, payload signatures, checksum/completeness policies, path-confined layout resolution,
   partial-file cleanup, atomic publish, and manifest collation invariants.
4. **Provider acquisition — implemented for arXiv and Zenodo.** Port arXiv and Zenodo artifact planning onto that substrate. Evaluate Sci-Hub
   separately as an optional policy-gated access provider.
5. **Job lifecycle.** Add a bounded service-owned queue only after acquisition is callable synchronously and
   tested. Prove shutdown, cancellation, retention, dead-worker diagnosis, and one-worker arXiv policy.
6. **Independent source preparation and catalog materialization — implemented.** Keep three callable operations: acquire
   or locally import one item and publish `acquisition.json`; unpack/validate an existing source and publish `article.json`;
   rebuild `inventory.jsonl` from any explicit population of pre-existing direct-child articles. A caller
   may compose them, but no MCP tool makes acquisition, source preparation, and inventory publication one
   indivisible workflow. Source preparation requires API metadata or explicitly omits it; it never silently
   degrades after provider failure. The LaTeX probe remains independent source-integrity evidence.
7. **Cutover.** First pin configured staging and source-catalog roots to durable directory identities and
   prove rename, recreate, and link-swap rejection across the full acquisition and materialization
   transactions. Add the separately versioned PDF-only article validation profile before treating a lone PDF
   as an article-ready sentinel. Then run behavioral parity probes, update MCP host configuration, remove PowerShell shells
   and libraries, and move or retire their stale tests and configuration instances.

## Current public surface

The implemented MCP exposes discovery, metadata, acquisition, source preparation, and catalog operations:

- `discover_search`
- `discover_related`
- `resolve_reference`
- `get_work`
- `prepare_source_deposit_metadata`
- `prepare_article_metadata_by_doi`
- `plan_artifact_acquisition`
- `acquire_artifact`
- `get_acquisition_receipt`
- `list_local_import_inboxes`
- `import_local_artifact`
- `materialize_source_deposit`
- `list_article_catalogs`
- `inspect_article_catalog`
- `rebuild_article_inventory`
- `list_procurement_providers`
- `discovery_procedure` prompt

Each tool retains its own boundary: metadata preparation does not acquire or unpack; acquisition does not
mint `article.json`; source materialization does not download or rebuild; catalog rebuild consumes only
pre-existing direct-child sentinels. Background job tools remain unadvertised until their lifecycle
contract passes its own gates.
