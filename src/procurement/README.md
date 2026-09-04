# Procurement

`procurement` is the reusable Python capability layer for scholarly discovery, acquisition, and source
preparation. It has no MCP dependency in its implementation graph; the MCP SDK is consumed only by
`src/mcp-servers/procurement_mcp`.

The package is divided by responsibility:

```text
application.py       owned runtime dependencies and lifecycle
composition.py       configuration-to-application assembly
configuration/       validated configuration models and data loading
domain/              immutable work, discovery, provider, metadata, deposit, and operation contracts
operations/          discovery, metadata, acquisition, materialization, and catalog use cases
providers/           provider declarations and adapters
source/              source contracts, extraction, tree identity, LaTeX inspection, and findings
storage/             acquisition/deposit transactions, catalog roots, and schema-backed persistence
transport/           HTTP policy and transport primitives
scripts/             PowerShell catalog inventory, LaTeX source deposit, and CLI wrappers
```

The former flat `archive`, `http`, `models`, `payloads`, `settings`, `source`, `staging`, and `services`
modules have no compatibility aliases. Shared model infrastructure, portable deposit validation,
scholarly works, discovery envelopes, provider descriptors, metadata evidence, and acquisition contracts
live in focused `domain` modules. Acquisition planning and safe-route policy are separate from durable
receipt and operation-result contracts.

The current discovery plane contains OpenAlex, Semantic Scholar, arXiv, and Zenodo adapters behind an
explicit provider catalog. Each adapter owns one immutable descriptor containing its category, roles,
capabilities, and honored search constraints. `DiscoveryService` provides federated search, graph traversal, reference
resolution, and provider lookup. Provider-specific search constraints are declared; federated search emits
an explicit error report instead of silently weakening a constraint. `WorkRecord` preserves every provider
identity participating in a merge.

`MetadataService` independently prepares `codex-scientiae/deposit-metadata/0.1` bundles for article
publication. It can resolve from the acquisition artifact identity or from a caller-selected DOI that is
recorded separately from byte provenance. arXiv and Zenodo are artifact origins and metadata authorities; Sci-Hub is an artifact-access
source; OpenAlex and Semantic Scholar are metadata aggregators. Aggregator metadata is accepted only after
identity matching and never replaces artifact provenance. Each bundle carries the exact selected API body,
its digest, and the normalized `article.json` projection. “Exact” means the HTTP-decoded entity payload
consumed by the provider normalizer, not compressed on-wire framing.

`article.json` is the invariant output rather than the definition of one workflow. Provider acquisition,
configured local import, LaTeX inspection, and API metadata resolution are separable evidence producers;
the article publisher validates their combination against a versioned article profile. The current profile
is LaTeX-backed. A future PDF profile will provide a second path into the same sentinel contract.

```python
import asyncio

from procurement.composition import build_application
from procurement.domain.discovery import SearchRequest


async def main() -> None:
    async with build_application() as application:
        result = await application.discovery.search(
            SearchRequest(query="persistent homology", limit=10),
            source="all",
        )
        print(result.model_dump(mode="json"))


asyncio.run(main())
```

Provider endpoints, request floors, timeouts, attempts, and default sources live in the version 2
`configs/defaults.json`. That data also names the confined staging root, logical local-import inboxes, source catalogs, and payload and
archive limits. `CDXSCI_ROOT` can select the workspace explicitly. `CDXSCI_SCHOLAR_MAILTO` supplies a contact address and
`OPENALEX_API_KEY` and `SEMANTIC_SCHOLAR_API_KEY` supply optional provider credentials.
Provider categories and capabilities are adapter declarations rather than configuration data.
`providers/builtin.py` is the built-in construction catalog; each entry binds an adapter descriptor,
constructor shape, and any provider-specific config validation. Composition accepts an extended immutable
factory catalog, so adding another adapter does not require a provider switch in `composition.py`.
The runtime catalog distinguishes metadata aggregators, scholarly repositories, and access-only sources;
Sci-Hub is classified as access-only rather than as a repository or metadata authority.

Filesystem trust boundary: composition captures and retains the physical identities of the staging root,
local-import inboxes, and article catalogs for the application lifetime. Acquisition transactions pin each
item below the retained staging root; HTTP and local-import byte transfer, hashing, recovery, receipt access,
and publication are relative to those retained generations. Local import also reads through the retained
inbox descriptor. A replacement route is either blocked or causes the operation to fail without writing to
or reporting success against the replacement. Source materialization retains the acquisition item, catalog,
document, private extraction tree, and final source tree for their complete transaction intervals. Archive
expansion, source inspection, archive/PDF copies, metadata publication, tree installation, and
`article.json` publication use those retained generations. Inventory rebuild separately pins its catalog
generation across sentinel reads and publication.

`HttpClient` uses HTTP/2. arXiv Atom and artifact routes send a rotating desktop browser profile
(`User-Agent` plus `Sec-Fetch-*`) per request. Provider floors share a file-locked clock at
`<workspace>/artifacts/procurement-mcp/rate-clock.json` (`CDXSCI_PROCUREMENT_RATE_CLOCK` overrides the path).

`AcquisitionService` asks an artifact-capable provider for an immutable internal plan, then streams each
requested form through one shared transaction. Plans never cross the MCP execution boundary. Downloads are
bounded, redirect-confined, content-checked, locally SHA-256 measured, and checked against provider-native
integrity evidence when present. Artifact responses with content encoding are refused so declared and stored
lengths remain directly comparable. Non-loopback artifact routes require HTTPS and cannot redirect to
plaintext HTTP. Metadata requests likewise require HTTPS or loopback HTTP and may follow only bounded
same-host redirects.
Successful forms are monotonically collated into schema-validated `acquisition.json` within the pinned item
generation. A valid unreceipted file already at the planned destination leaf is adopted in place (`custody: adopted`) instead of treated as an occupant. Local import of matching destination bytes is receipted without overwrite. Lock, validation, hashing, and publication work runs outside the MCP event loop. That
receipt makes no unpacked or source-ready claim; `article.json` remains the canonical sentinel, currently
published by the validated LaTeX-source profile. Default materialize refuses a later form-set change;
`rebuild=true` replaces that sentinel from current acquisition evidence and preserves `initialized_utc`.
HTML is a staged acquisition form reserved for a future source-profile consumer; current materialization
consumes gzip source and optional PDF forms only.
Background jobs remain deferred until the synchronous operations have a separate lifecycle contract.

`LocalImportService` is the parallel custody route for files already downloaded by a human or another tool.
Clients name a configured inbox, a portable direct-child leaf, and a deposit slug; they cannot submit a host
path or URL. The service sniffs and validates gzip source or PDF bytes, makes an independent staged copy, and
publishes the same `acquisition.json` contract with `local-import` custody. It does not claim that a DOI or
arXiv identity proves the origin of those bytes.

`SourceMaterializationService` consumes an existing `acquisition.json` in the destination catalog leaf; it
never downloads an artifact and does not copy receipted bytes. It requires exactly one receipted source
form, safely expands gzip-wrapped tar or single-TeX source in place, validates the complete LaTeX
closure, keeps the receipted archive leaf (`{slug}.tar.gz` or `arXiv-{slug}.tar.gz`) and the trimmed
`{slug}-tex/` tree without replacement, and calls `jsonl_engine` to publish `article.json` last. Bibliography is selected by one typed strategy: acquisition artifact identity,
caller-supplied DOI, or deliberate omission. Explicit DOI resolution is identity-checked against API results
and any DOI declared by the validated LaTeX closure. There is no best-effort mode
that could permanently mint an accidentally metadata-free sentinel. Tar input requires a canonical
terminator and zero-only padding. The first sentinel freezes PDF inclusion, so a later receipt cannot mutate
an existing article or leave an orphan PDF. The fixed seven-probe ledger remains independent evidence of
source integrity.

The materialization transaction publishes `article.json` last. It uses no separate source journal because
every persistent pre-sentinel component is immutable and independently validated: exact archive, PDF,
metadata, and source-tree state is adopted on retry, while a conflict fails without replacement. Exact
PID-plus-process-serial private tree scratch is the only mutable intermediate and is swept recursively under
the generation-keyed source lease. An interrupted retry therefore preserves established bytes and mtimes
and does not repeat a metadata request whose validated bundle already exists.

`ArticleCatalogService` resolves configured catalog names, inspects safe direct-child `article.json`
sentinels, and independently rebuilds `inventory.jsonl`. Rebuild pins one physical catalog generation from
sentinel reads through main and sidecar publication. Default rebuilds publish with atomic no-replace; only
`force=True` replaces an existing inventory in that pinned generation. It does not acquire or prepare
sources. The three operations therefore compose without becoming one transaction:

```text
acquire into a catalog name or workspace path  -> {destination}/{slug}/acquisition.json
or import one local item there                 -> {destination}/{slug}/acquisition.json
materialize that same leaf                     -> article.json
rebuild one catalog                            -> inventory.jsonl
```
The destination may be a configured name such as `inventory` or a confined relative folder such as
`supellex/gauntlet/topic`. Missing destination folders are created.
`ProcureService` runs acquire then materialize at that destination as one operation.

A PDF can currently be imported, receipted, and used as the human basis for an explicit DOI lookup. A lone
PDF does not yet mint `article.json`: the current article contract requires a validated LaTeX archive and
tree. PDF-only publication requires its own versioned source-form validation profile so it cannot weaken the
existing sentinel by exception.
