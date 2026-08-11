# Procurement Python architecture

Status: accepted discovery and API-metadata baseline; acquisition-plane design is provisional.

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

`procurement` does not import MCP. Scripts, tests, orchestrators, and future batch adapters call the Python
application services directly. The optional API-metadata path in `jsonl_engine.deposit` imports the
procurement evidence-bundle model so persisted sentinels and MCP output share one behavioral validator;
`procurement` does not depend on `jsonl_engine`.

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

### API metadata is an independent deposit input

`prepare_source_deposit_metadata` produces a validated
`codex-scientiae/deposit-metadata/0.1` bundle. The bundle binds the actual artifact provider and identifier
to one selected metadata observation, records every fallback attempt, retains the normalized article
projection, and embeds the exact HTTP-decoded entity payload consumed by the provider normalizer as
canonical base64 with its SHA-256 digest, media type, retrieval time, and credential-redacted URL. It does
not claim to preserve compressed on-wire framing.

The selection order starts with an artifact provider's own metadata authority. Metadata aggregators are
consulted only as fallbacks, and their returned DOI or versionless arXiv identity must match the artifact.
Semantic Scholar precedes OpenAlex for arXiv fallback because Semantic Scholar documents singleton lookup by
arXiv identifier; OpenAlex singleton lookup is used for DOI and OpenAlex identities, not assumed for arXiv.

The bundle is stored inside the document deposit as `{slug}.api-metadata.json` and passed to
`New-LatexSourceDeposit -MetadataBundlePath` or `jsonl_engine deposit --metadata-json`. The deposit engine
validates its structural schema and the shared procurement model before projecting bibliographic fields
into `article.json` and fingerprinting the bundle as evidence. The shared model checks artifact identity,
canonical slug/identifier forms, authority-first attempt order, exact response digest, selected-work
identity, and deterministic article projection.

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

Each acquisition-capable provider will produce an immutable `ArtifactPlan`; it will not download or publish
bytes itself. A plan identifies the canonical origin and version, orders artifact candidates, declares the
expected kind and payload signatures, attaches provider integrity evidence or policy, and states allowable
fallback and mismatch behavior. This keeps arXiv's mostly templated candidates and Zenodo's metadata-driven
file selection behind the same capability-specific contract without inventing one universal URL template.

One acquisition service will execute the plan: download into a unique partial path, validate content and
completeness, atomically publish the file, and collate its canonical manifest. Path templates remain data
where they are actually templates, and every resolved target is confined beneath a caller-owned staging
root. Routing between providers belongs above both discovery and acquisition.

The per-item acquisition manifest/receipt is the source of truth; a JSONL inventory is a rebuildable view.
`jsonl_engine` owns validated storage, atomic update, and index mechanics, while the acquisition service owns
the collation law. Partial acquisitions union with existing artifacts, repeated acquisition is idempotent,
richer provenance and integrity evidence cannot be downgraded, conflicts are visible, and manifest publish
is atomic or recoverable. The manifest links to the validated API-metadata witness rather than flattening it
into a second bibliographic truth.

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

Acquisition will add cohesive modules only when their contracts exist: `payloads.py`, `staging.py`,
`acquisition.py`, and `jobs.py` are expected seams, not directories created in advance.

## Migration sequence

1. **Discovery foundation — implemented.** Introduce models, identifiers, HTTP policy, registry, four
   discovery adapters, federated service, Python MCP, and offline/protocol tests.
2. **API metadata bridge — implemented.** Add provider roles, exact decoded-payload witnesses, authority-first
   fallback, a validated deposit-metadata schema, MCP projection, and `article.json` integration alongside
   the independent LaTeX probe.
3. **Acquisition contracts and substrate.** Add immutable artifact-plan/candidate models, a capability-specific
   planning port, payload signatures, checksum/completeness policies, path-confined layout resolution,
   partial-file cleanup, atomic publish, and manifest collation invariants.
4. **Provider acquisition.** Port arXiv and Zenodo artifact planning onto that substrate. Evaluate Sci-Hub
   separately as an optional policy-gated access provider.
5. **Job lifecycle.** Add a bounded service-owned queue only after acquisition is callable synchronously and
   tested. Prove shutdown, cancellation, retention, dead-worker diagnosis, and one-worker arXiv policy.
6. **Acquisition/deposit composition.** Drive unpacking, the source probe, metadata bundle persistence, and
   the existing `jsonl_engine` deposit transaction from one path-confined acquisition workflow; retain the
   per-item manifest as truth and materialize JSONL inventory as a rebuildable view.
7. **Cutover.** Run behavioral parity probes, update MCP host configuration, remove PowerShell shells and
   libraries, then move or retire their stale tests and configuration instances.

## Current public surface

The implemented MCP exposes discovery and deposit-metadata preparation:

- `discover_search`
- `discover_related`
- `resolve_reference`
- `get_work`
- `prepare_source_deposit_metadata`
- `list_procurement_providers`
- `discovery_procedure` prompt

The metadata tool returns evidence and does not claim to acquire or unpack an artifact. No Python
acquisition tool is advertised until the acquisition transaction and lifecycle contracts pass their own
gates.
