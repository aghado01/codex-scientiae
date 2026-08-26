# and other thing i'm trying to carve out is MCP server and tool implementation code from the operations and algorithmic code, to seat MCPs under their own subdirectory under src, in order to implement future MCPs based on shared primitives where applicable. similar layering on a new segment of code that's currently interleaved

The procurement tree has strong natural seams, but they are flattened and inconsistently layered. I would dissolve the current “scholar core” rather than preserve it as another umbrella module.

The biggest findings:

- Three MCP servers contain 666 lines altogether, with substantially duplicated protocol framing, catalogues, dispatch, logging, and JSON-RPC loops.
- [scholar-server.ps1](D:/aghado01/graveyard/codex-scientiae/src/mcp-servers/procurement/scholar-server.ps1:107) embeds real operations inside its MCP dispatcher: cross-source fan-out, failure isolation, merging, graph routing, DOI resolution, and acquisition routing.
- [scholar-core.ps1](D:/aghado01/graveyard/codex-scientiae/src/procurement/scholar-core.ps1:33) combines at least four domains: rate-limited HTTP, retry classification, DOI identity, and normalized-work modeling/merging/pagination.
- [arxiv.ps1](D:/aghado01/graveyard/codex-scientiae/src/procurement/arxiv.ps1:45) is an 837-line aggregate containing identifiers, staging templates, payload inspection, API access, Atom parsing, search, downloads, inbox management, and job control.
- [zenodo.ps1](D:/aghado01/graveyard/codex-scientiae/src/procurement/zenodo.ps1:287) repeats the same broad shape.
- Zenodo’s advertised “non-blocking” fetch is currently synchronous: `Start-ZenodoFetchJob` performs the download before returning. That implementation should not become the shared job primitive.
- OpenAlex and Semantic Scholar are already relatively close to provider-shaped operations, though they depend on the overloaded scholar core.

A good target layout would be:

```text
src/
  procurement/
    shared/
      http/
        request.ps1
        retry-policy.ps1
        rate-limit.ps1
      staging/
        layout.ps1
        paths.ps1
      payloads/
        signatures.ps1
        checksums.ps1

    works/
      work.ps1
      identity.ps1
      merge.ps1
      page.ps1

    doi/
      identity.ps1
      resolution.ps1

    arxiv/
      identity.ps1
      discovery.ps1
      acquisition.ps1
      staging.ps1
      adapter.ps1
      jobs.ps1
      stores/
        staging.json

    zenodo/
      identity.ps1
      discovery.ps1
      acquisition.ps1
      staging.ps1
      adapter.ps1
      stores/
        staging.json

    openalex/
      discovery.ps1
      adapter.ps1

    semantic-scholar/
      discovery.ps1
      adapter.ps1

    sci-hub/
      acquisition.ps1
      stores/
        mirrors.json

    discovery/
      search.ps1
      related.ps1
      resolve.ps1

    acquisition/
      route.ps1

  mcps/
    runtime/
      server.ps1
      registry.ps1
      protocol.ps1
      responses.ps1

    arxiv/
      server.ps1
      tools/
      prompts/

    zenodo/
      server.ps1
      tools/

    scholar/
      server.ps1
      tools/
      prompts/
      stores/
        config.json
```

The sibling domains would then have explicit relationships:

- `arxiv`, `zenodo`, `openalex`, `semantic-scholar`, and `sci-hub` own provider-specific behavior.
- `doi` owns normalization, identity, and cross-walk semantics—not Sci-Hub routing.
- `works` owns the shared record contract if that model survives evaluation.
- `discovery` owns multi-provider fan-out and graph traversal.
- `acquisition/route.ps1` owns configurable routing policy such as preferring arXiv source and choosing an allowed DOI acquisition provider.
- `shared/http` supplies mechanisms, while each provider supplies its own interval and retry policy.
- MCP tools translate requests into those operations.

Some present helpers are excellent extraction candidates:

- `ConvertTo-NormalizedDoi` → `procurement/doi/identity.ps1`
- Rate clocks and HTTP retry mechanics → `procurement/shared/http`
- Template expansion and path confinement → `procurement/shared/staging`
- File-head, PDF, gzip, and checksum validation → `procurement/shared/payloads`
- Cross-source search fan-out currently buried in `scholar-server` → `procurement/discovery/search.ps1`
- Acquisition routing currently buried in `scholar-server` → `procurement/acquisition/route.ps1`

Other pieces should be evaluated before extraction:

- The current `Work` merge model concatenates sources while retaining only one `source_id`, which weakens provenance.
- arXiv’s job controller is capable but heavily tied to script-global state and re-dot-sourcing the entire 837-line library in a worker runspace.
- Zenodo’s job layer does not actually provide asynchronous behavior.
- Sci-Hub selection is policy, while its DOI-to-PDF attempt is the provider operation.

Prompts also clearly belong with MCP presentation, not procurement operations:

- `arxiv-discovery.md` → `src/mcps/arxiv/prompts/`
- `scholar-discovery.md` → `src/mcps/scholar/prompts/`
- `scholar-config.json` → MCP composition configuration
- Provider staging and mirror JSON files → their respective provider `stores/`

I would implement this in narrow slices:

1. Extract DOI, work-model, and HTTP concerns from `scholar-core`.
2. Move providers into sibling directories without changing behavior.
3. Extract fan-out, graph traversal, resolution, and acquisition routing from `scholar-server`.
4. Build one shared MCP runtime and migrate the small Zenodo server first.
5. Migrate the arXiv and Scholar servers onto thin tool adapters.
6. Split the arXiv and Zenodo acquisition monoliths, rebuilding job control rather than generalizing the current mismatch.

Tests should mirror the decomposition under `tests/procurement/{doi,works,arxiv,zenodo,openalex,semantic-scholar,sci-hub,shared}` and `tests/mcps/{arxiv,zenodo,scholar}`.

No files were changed during this examination.

# this does touch on some notes i have under issues/procurement D:\aghado01\codex-scientiae\issues\procurement

Yes—these notes materially refine the procurement decomposition. They reveal three cross-provider capabilities that should not be owned by arXiv or by a `codex-browser` MCP:

| Capability                             | Proper ownership                             |
| -------------------------------------- | -------------------------------------------- |
| Provider discovery and policy          | `procurement` provider domains               |
| HTTP/browser acquisition               | A reusable `acquisition` capability          |
| Queues, job status, completion records | A reusable asynchronous-execution capability |
| `fetch`, `fetch_status`, JSON-RPC      | MCP presentation/adaptation                  |

A better provisional shape is:

```text
src/
  procurement/
    works/
    doi/
    discovery/
    routing/
    providers/
      arxiv/
      zenodo/
      openalex/
      semantic-scholar/
      sci-hub/

  acquisition/
    http/
    browser/
    payloads/
    staging/

  jobs/
    queue/
    status/
    completion-records/

  html/
    parsing/
    link-extraction/

  mcps/
    runtime/
    arxiv/
    zenodo/
    scholar/
    browser/
```

The browser MCP would merely expose browser acquisition. It would not own the Playwright bridge, acquisition ladder, payload validation, or job machinery.

Several especially useful corrections follow from the notes:

- The terminal markers proposed in [autowake-background-process.md](D:/aghado01/codex-scientiae/issues/procurement/arxiv-async/autowake-background-process.md) now clearly belong under `artifacts`, not `<staging_root>/.jobs`. Job records, partial downloads, logs, and waiter signals are exactly the transient history you are consolidating.
- The single arXiv worker and three-second clock remain provider policy. Generic job state and completion-record serialization can be shared, but the scheduler itself should not be generalized blindly.
- [sockets-httphandler-fetch-engine.md](D:/aghado01/codex-scientiae/issues/procurement/arxiv-async/sockets-httphandler-fetch-engine.md) should remain evidence-gated and initially arXiv-specific. Its retry classification, raw-gzip behavior, rate clock, and completeness rules are not yet a clean universal HTTP abstraction.
- [playwright-web-acquisition-brief.md](D:/aghado01/codex-scientiae/issues/procurement/browser-fetcher/playwright-web-acquisition-brief.md) contains the right escalation concept but the older ownership model. `FETCH`, browser navigation, HTML parsing, challenge handling, and segmented acquisition should not all become one monolithic `codex-browser`.
- Playwright’s package dependency belongs in the centralized `packages/node` installation. First-party PowerShell/Node bridge code belongs in `src/acquisition/browser`.

There is also some documentation drift worth repairing:

- The browser brief links to `issues/arxiv-async/...`; the files now live under `issues/procurement/arxiv-async/...`.
- Its “HTTP/3 is the headline justification” language conflicts with the sockets brief’s later conclusion: resumability is the evidence-backed reason to build; HTTP/3 is optional.
- The referenced `.discussion/scihub-fetcher-brief.md` and “codex-arxiv memory” are not currently repository-addressable.

So I would treat these as valuable historical design evidence, not current specifications. Their durable contribution is the acquisition ladder; their MCP ownership and artifact-placement assumptions should be rewritten around the newer boundaries before code migration begins. No files were changed during this inspection.
