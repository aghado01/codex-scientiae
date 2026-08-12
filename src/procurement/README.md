# Procurement

`procurement` is the reusable Python capability layer for scholarly discovery, acquisition, and source
preparation. It has no MCP dependency in its implementation graph; the MCP SDK is consumed only by
`src/mcps`.

The current discovery plane contains OpenAlex, Semantic Scholar, arXiv, and Zenodo adapters behind explicit
capability registration. `DiscoveryService` provides federated search, graph traversal, reference
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
from procurement.models import SearchRequest


async def main() -> None:
    async with build_application() as application:
        result = await application.discovery.search(
            SearchRequest(query="persistent homology", limit=10),
            source="all",
        )
        print(result.model_dump(mode="json"))


asyncio.run(main())
```

Provider endpoints, request floors, timeouts, attempts, and default sources live in
`configs/defaults.json`. That data also names the confined staging root, logical local-import inboxes, source catalogs, and payload and
archive limits. `CODEX_SCIENTIAE_ROOT` can select the workspace explicitly. `CODEX_SCHOLAR_MAILTO` supplies a contact address and
`OPENALEX_API_KEY` and `SEMANTIC_SCHOLAR_API_KEY` supply optional provider credentials.
Provider groups distinguish metadata aggregators, scholarly repositories, and access-only sources.
Sci-Hub is classified as access-only rather than as a repository or metadata authority.

Filesystem trust boundary: acquisition and source-materialization roots are pathname-confined but not yet
pinned to their initialized directory identities. Their mutation and immutability guarantees assume those
roots and ancestors are not renamed or replaced while an operation runs. This remains a production-cutover
blocker. Inventory rebuild separately pins its catalog generation across sentinel reads and publication.

`AcquisitionService` asks an artifact-capable provider for an immutable internal plan, then streams each
requested form through one shared transaction. Plans never cross the MCP execution boundary. Downloads are
bounded, redirect-confined, content-checked, locally SHA-256 measured, and checked against provider-native
integrity evidence when present. Non-loopback routes require HTTPS and cannot redirect to plaintext HTTP.
Within an unchanged staging-root generation, successful forms are monotonically collated into
`acquisition.json`. Lock, validation, hashing, and publication work runs outside the MCP event loop. That
receipt makes no unpacked or source-ready claim; `article.json` remains the canonical sentinel, currently
published by the validated LaTeX-source profile.
Background jobs remain deferred until the synchronous operations have a separate lifecycle contract.

`LocalImportService` is the parallel custody route for files already downloaded by a human or another tool.
Clients name a configured inbox, a portable direct-child leaf, and a deposit slug; they cannot submit a host
path or URL. The service sniffs and validates gzip source or PDF bytes, makes an independent staged copy, and
publishes the same `acquisition.json` contract with `local-import` custody. It does not claim that a DOI or
arXiv identity proves the origin of those bytes.

Within an unchanged source-catalog generation, `SourceMaterializationService` consumes an existing
`acquisition.json`; it never downloads an artifact.
It requires exactly one receipted source form, copies staged bytes into an independent inode, safely expands
gzip-wrapped tar or single-TeX source, validates the complete LaTeX closure, publishes the canonical
`{slug}.tar.gz` and `{slug}-tex/` forms without replacement, and calls `jsonl_engine` to publish
`article.json` last. Bibliography is selected by one typed strategy: acquisition artifact identity,
caller-supplied DOI, or deliberate omission. Explicit DOI resolution is identity-checked against API results
and any DOI declared by the validated LaTeX closure. There is no best-effort mode
that could permanently mint an accidentally metadata-free sentinel. Tar input requires a canonical
terminator and zero-only padding. The first sentinel freezes PDF inclusion, so a later receipt cannot mutate
an existing article or leave an orphan PDF. The fixed seven-probe ledger remains independent evidence of
source integrity.

`ArticleCatalogService` resolves configured catalog names, inspects safe direct-child `article.json`
sentinels, and independently rebuilds `inventory.jsonl`. Rebuild pins one physical catalog generation from
sentinel reads through main and sidecar publication. Default rebuilds publish with atomic no-replace; only
`force=True` replaces an existing inventory in that pinned generation. It does not acquire or prepare
sources. The three operations therefore compose without becoming one transaction:

```text
acquire one item         -> acquisition.json
or import one local item -> acquisition.json
materialize one source  -> article.json
rebuild one catalog     -> inventory.jsonl
```

A PDF can currently be imported, receipted, and used as the human basis for an explicit DOI lookup. A lone
PDF does not yet mint `article.json`: the current article contract requires a validated LaTeX archive and
tree. PDF-only publication requires its own versioned source-form validation profile so it cannot weaken the
existing sentinel by exception.
