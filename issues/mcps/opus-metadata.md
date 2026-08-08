Mapped. The good news for your constraint: the MCP servers are already thin dispatch over a plain library tier.

## Layering

```
arxiv-server.ps1 / zenodo-server.ps1 / scholar-server.ps1   ← MCP only: JSON-RPC + tool switch
        │ dot-sources
        ▼
scholar-core.ps1   Invoke-ScholarApi, Wait-ScholarRate, ConvertTo-NormalizedDoi,
                   New-ScholarWork, Merge-ScholarWork(s), Get-ScholarWorkKey
openalex.ps1       OpenAlex-{Search,GetWork,Related,Resolve}, ConvertFrom-OpenAlexWork
semanticscholar.ps1 SemanticScholar-{Search,GetWork,Related,Resolve}
arxiv.ps1          Get-ArxivMetadata, Invoke-ArxivSearch, ConvertFrom-ArxivAtom, Invoke-ArxivFetch
arxiv-adapter.ps1  ConvertFrom-ArxivToWork, Arxiv-GetWork
scihub-get.ps1     Invoke-ScihubFetch
```

A script dot-sources `scholar-core.ps1`, `openalex.ps1`, `arxiv.ps1`, `arxiv-adapter.ps1` and calls exactly what the server calls. No MCP, no agent.

**The one gap:** `resolve_doi` has no library function. It's a six-line switch inline at [scholar-server.ps1:153](src/procurement/scholar-server.ps1:153) picking between `OpenAlex-Resolve` and `SemanticScholar-Resolve`. Same for `acquire`'s route selection. So the cascade logic lives in the server, where a script can't reach it. Lift it into `scholar-core.ps1` and both callers share one implementation.

## The lossiness that shapes the cascade

`New-ScholarWork` emits `doi, arxiv_id, title, authors[], abstract, year, venue, …, fields[]`. Against `article.schema.json` that's lossy in three places:

- `year` (int) where the schema wants `published`/`updated` as date-times
- `fields[]` are OpenAlex concepts, **not** arXiv categories — different taxonomy, and there's no `primary_category` equivalent at all
- `arxiv_id` isn't reliably versioned, but `identifiers.arxiv_versioned` and `slug` both need the version

So resolving through OpenAlex gives a *worse* record than arXiv's own API. That inverts the obvious cascade:

1. **Extracted arXiv id** (margin-stamp link annotation) → `Get-ArxivMetadata` directly. Full Atom record, versioned, categories and dates intact. No Work involved.
2. **Extracted DOI** → `ConvertTo-NormalizedDoi` → `OpenAlex-GetWork "doi:…"`. If the returned work carries an `arxiv_id`, **cross-walk back to step 1** rather than canonicalizing the Work — that's the same trick `acquire` already uses to pick a route.
3. **No arXiv id** → canonicalize the Work itself, accepting the taxonomy gap (`categories` empty, not fabricated from `fields`).
4. **No DOI** → `OpenAlex-Resolve <title>` → ranked candidates → confidence gate → then re-enter at 2.
5. **Nothing resolves** → extracted values are the artifact.

`ConvertTo-NormalizedDoi` is already the right front door for step 2: it strips `https://doi.org/`, `dx.`, and `doi:` prefixes and lowercases — which is precisely the shape a `UriAction.Uri` hands you.

Want this written into `issues/jsonl-engine/planning/` alongside the decisions from earlier, or a separate procurement/pdf-metadata topic?
