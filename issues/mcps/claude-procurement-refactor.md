Here's the shape I'd argue for. Every placement below is decided by the same test — can the contract be stated without naming a provider or a product — and where an operation appeared N times wearing N names, it collapses to one operation plus a descriptor.

```text
src/
  mcps/
    runtime/
      protocol.ps1        # frames, UTF-8 channel, initialize/ping/not-initialized, list handlers
      dispatch.ps1        # schema-driven coercion → handler → content envelope → isError
    arxiv/
      server.ps1          # composition only: server info, tool table, prompt table, shutdown hook
      tools.ps1           # name + inputSchema + handler; each handler is one operation call
      prompts/discovery.md
    zenodo/
    scholar/

  procurement/
    record.ps1            # the normalized record + provenance
    doi.ps1               # DOI identity, normalization, cross-walk
    discovery.ps1         # search fan-out, graph traversal, reference resolution
    acquisition.ps1       # artifact ladder → validate → stage → manifest
    routing.ps1           # identifier → which provider acquires it
    inventory.ps1         # staged-item survey, inspect, remove
    providers/
      arxiv/     provider.ps1  atom.ps1  provider.json
      zenodo/    provider.ps1  provider.json
      openalex/  provider.ps1  provider.json
      semantic-scholar/
      sci-hub/   provider.ps1  mirrors.json

  shared/
    http.ps1              # rate-floored request + transient classification
    payload.ps1           # format signature + integrity
    pathspec.ps1          # template expansion + root confinement
    recordset.ps1         # paging envelope + key-based dedup/merge
    jobs.ps1              # queue + worker; bootstrap and work supplied by caller
    jsonl.ps1  runs.ps1  crawl.ps1  masks.ps1  …
```

**The provider split is the load-bearing decision.** `provider.json` carries everything that is data: rate interval, endpoint patterns, the staging layout template, and per artifact kind a URL ladder with its expected payload kind and target filename. `provider.ps1` carries only what can't be data — the id grammar, the response→record adapter, and anything genuinely algorithmic (arXiv's Atom parse, Sci-Hub's mirror health check and scrape). That's the doc's `adapter.ps1` kept and its `staging.ps1` dissolved, which is the inconsistency we found: staging is one operation with a template as data, so `pathspec.ps1` serves all providers and `arxiv-staging.json`/`zenodo-staging.json` become fields inside their descriptors.

**State becomes a value you pass, not a module global.** `Invoke-RateLimitedRequest -Url -RateState -MinIntervalMs -RetryPolicy` takes the clock as a synchronized dictionary you create. That's not a style preference — it's what lets the job worker share the clock without re-dot-sourcing an 837-line library into a runspace, since the whole reason for that dot-source was to reconstitute ambient state. Same for the contact string and the staging root: parameters, so every operation stays callable from a test or a batch script without starting a server.

**One acquisition implementation.** `Invoke-Acquisition -Provider -Id -Kinds -StagingRoot` walks the ladder, validates the payload kind, stages through pathspec, writes or merges the manifest. The arXiv MCP's `fetch` calls it; `routing.ps1` calls it; scholar's `acquire` calls routing. That removes the second implementation at [scholar-server.ps1:186](src/procurement/scholar-server.ps1:186) and with it the asymmetry where one blocks the protocol loop and the other doesn't.

**Schema-driven dispatch kills a bug class.** The runtime reads each tool's own `inputSchema`, coerces and validates before the handler runs, and takes defaults from the schema. That's the end of ten hand-written coercion sites with two idioms, and `size: 0` stops meaning `size: 10`.

**Provenance stops being lossy.** The record carries `sources: [{provider, id}]` and merge unions the list rather than joining strings and dropping one id. `recordset.ps1` does the dedup given a key function — the DOI-then-version-stripped-arXiv-id preference is procurement's policy, passed in, not baked into the merge.

Two things I'd flag rather than decide.

`shared/jobs.ps1` has one real witness. I'd still put it in shared, but for a specific reason rather than on principle: making it take `-Bootstrap` and `-Work` explicitly is what removes the re-dot-source, so the generalization pays immediately instead of speculatively. If that argument doesn't hold up when you write it, it belongs in `procurement/` until the browser lane arrives.

And I'd hold the record contract's _shape_ until discovery is rebuilt. `page` and `merge` clearly leave `works/` as generic operations, but what fields the record actually carries is determined by what the adapters can fill, and that's not knowable until the adapters exist.

On prose, this layout gives every sentence a destination: tool descriptions shrink to contracts because workflow text has `prompts/discovery.md`, and the provider descriptors are data, so they carry no prose at all.
