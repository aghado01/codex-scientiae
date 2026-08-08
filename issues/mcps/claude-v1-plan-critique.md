Grouping by kind. (Credit where due first, briefly: its line counts were exact, the fake-async catch was real, and the domain seams — `doi` out from under sci-hub, discovery/acquisition/routing separated out of the server dispatcher — are the part that most needed doing and it did them well.)

**Internal inconsistencies**

Its extraction-candidates list assigns "template expansion and path confinement → `procurement/shared/staging`," but the layout still gives every provider its own `staging.ps1`. It names the shared operation and then hands each provider a copy.

It states the parameterization principle correctly for HTTP — _"shared/http supplies mechanisms, while each provider supplies its own interval and retry policy"_ — and then doesn't apply it to staging or acquisition. The pattern in where it slips is consistent: applied wherever a shared mechanism was obvious, skipped wherever a per-provider file already existed to inherit.

In the second layout it warns against generalizing the arXiv scheduler blindly, then hoists `jobs/` to a top-level tree on the strength of one real witness (Zenodo's is a stub).

**Structural calls I'd dispute**

`acquisition.ps1` per provider is split at the wrong joint — validation goes to `shared/payloads` while the rest stays per-provider, when "walk a URL ladder, validate the payload kind, write to the staged target, record a manifest" is one operation and the genuinely per-provider parts are data.

`works/` is over-grouped. `page.ps1` is generic pagination coupled to Works only because Works is what it pages; `merge.ps1` is dedup-by-key with field-wise resolution, generic given a key function and policy. The doc hedged on whether the Work _model_ survives, but the questionable thing is the _grouping_.

The second layout hoists `acquisition/`, `jobs/`, `html/` to top-level without noticing `src/shared/` already exists as the repo's answer to where agnostic operations live.

**Coverage gaps**

It counted three MCP servers. There are five — [reader-mcp.ps1](src/reader-mcp/reader-mcp.ps1) and [codex-membrane/mcp-server.ps1](src/codex-membrane/mcp-server.ps1) run the same spine. Designing `mcps/runtime` against three near-identical procurement servers overfits; the two it missed are the ones that would stress it.

None of the five implements `resources/*`. The reader and librarian MCPs the companion doc names as future consumers are exactly the ones that would want it, so a tools-only runtime gets chosen by default rather than deliberately.

Its slice ordering puts the shared runtime at step 4, behind three behavior-bearing extractions. Every existing procurement test is library-level — zero touch the servers — so the runtime is the only slice with no test debt, and doing it first produces the conformance harness that makes the others checkable.

It's a layout analysis, so it doesn't reach the implementation patterns that actually cost time: ambient `$script:` state as the module interface, the optional-argument coercion divergence (ten sites, two idioms, [scholar-server.ps1:112](src/procurement/scholar-server.ps1:112) and [:113](src/procurement/scholar-server.ps1:113) three lines apart), `Invoke-ToolGuarded` copied five times encoding "the last IDictionary on the pipeline wins," and `Initialize-ArxivJobs`'s guard silently discarding a new staging root. It also caught dangling `.discussion/` references in the issues docs but not the same dangling citations sitting in source at [scholar-core.ps1:4](src/procurement/scholar-core.ps1:4) and [scihub-get.ps1:7](src/procurement/scihub-get.ps1:7).

**Missed defects and understatements**

The strongest in-repo evidence for its own operations doctrine went unmentioned: scholar's `acquire` calls `Invoke-ArxivFetch` directly, never `Add-ArxivFetchJob`, never `Initialize-ArxivJobs` — so one capability has two implementations with different blocking semantics, and a discovery-only server dot-sources the whole 837-line acquisition stack to reach it.

It called the merge provenance issue a weakening. It's loss: `source` becomes `"openalex+arxiv"` while `source_id` keeps one value, so which id belongs to which graph is unrecoverable, and `external_ids` is first-wins.
