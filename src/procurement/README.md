# Procurement

`procurement` is the reusable Python capability layer for scholarly discovery and future acquisition. It
has no MCP dependency in its implementation graph; the MCP SDK is consumed only by `src/mcps`.

The current discovery plane contains OpenAlex, Semantic Scholar, arXiv, and Zenodo adapters behind explicit
capability registration. `DiscoveryService` provides federated search, graph traversal, reference
resolution, and provider lookup. `WorkRecord` preserves every provider identity participating in a merge.

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
`SEMANTIC_SCHOLAR_API_KEY` supplies the optional Semantic Scholar credential.

Acquisition, staging, jobs, and `article.json` deposit are not part of the current Python surface.
