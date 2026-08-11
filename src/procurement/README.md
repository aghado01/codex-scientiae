# Procurement

`procurement` is the reusable Python capability layer for scholarly discovery and future acquisition. It
has no MCP dependency in its implementation graph; the MCP SDK is consumed only by `src/mcps`.

The current discovery plane contains OpenAlex, Semantic Scholar, arXiv, and Zenodo adapters behind explicit
capability registration. `DiscoveryService` provides federated search, graph traversal, reference
resolution, and provider lookup. Provider-specific search constraints are declared; federated search emits
an explicit error report instead of silently weakening a constraint. `WorkRecord` preserves every provider
identity participating in a merge.

`MetadataService` independently prepares `codex-scientiae/deposit-metadata/0.1` bundles for unpacked source
deposits. arXiv and Zenodo are artifact origins and metadata authorities; Sci-Hub is an artifact-access
source; OpenAlex and Semantic Scholar are metadata aggregators. Aggregator metadata is accepted only after
identity matching and never replaces artifact provenance. Each bundle carries the exact selected API body,
its digest, and the normalized `article.json` projection. “Exact” means the HTTP-decoded entity payload
consumed by the provider normalizer, not compressed on-wire framing.

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
`stores/discovery.json`. `CODEX_SCHOLAR_MAILTO` supplies a contact address and
`OPENALEX_API_KEY` and `SEMANTIC_SCHOLAR_API_KEY` supply optional provider credentials.

The metadata bridge is part of the current surface; artifact acquisition, staging, and jobs are not.
