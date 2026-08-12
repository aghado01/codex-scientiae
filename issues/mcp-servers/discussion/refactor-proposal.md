## What should and should not be configuration

The central rule should be:

| Concern                                                                                            | Owner                             |
| -------------------------------------------------------------------------------------------------- | --------------------------------- |
| Enabled providers, provider order, endpoints, request intervals, timeouts, workspace roots, limits | Validated JSON configuration      |
| API keys and contact values                                                                        | Environment-backed secrets        |
| Provider capabilities and roles                                                                    | Class-level provider declarations |
| API field lists, endpoint path fragments, response mapping, page caps, payload recognition         | Provider implementation code      |
| Persisted artifact shape                                                                           | JSON Schema                       |
| Cross-provider fallback and collation policy                                                       | Operations/services               |

The actual “config in code” problems are visible in [composition.py](D:/aghado01/codex-scientiae/src/procurement/composition.py:90):

- It centrally restates every provider’s capabilities and roles.
- It hardcodes which providers must exist.
- It hardcodes which providers count as metadata aggregators.
- MCP repeats overlapping provider lists as `Literal` types in [server.py](D:/aghado01/codex-scientiae/src/mcps/procurement/server.py:48).
- Pydantic supplies defaults for values also explicitly present in JSON, creating two possible authorities.

Each adapter should expose an immutable descriptor:

```python
class OpenAlexProvider:
    name = "openalex"
    capabilities = frozenset({...})
    roles = frozenset({ProviderRole.METADATA_AGGREGATOR})
```

Composition should construct configured provider instances and validate references against their declarations. Configuration should say which providers are enabled and how they are configured; it should not claim that an adapter implements methods it does not possess.

Conversely, Semantic Scholar’s response field list and arXiv’s `/e-print` versus `/src` ladder belong in code. Moving those into JSON would create an undocumented provider DSL, not clean configuration.

## Recommended procurement layout

```text
src/procurement/
  __init__.py                 stable public exports only
  application.py              ProcurementApplication lifecycle
  bootstrap.py                config-to-runtime composition
  errors.py
  identifiers.py

  config/
    models.py
    loader.py
    defaults.json

  domain/
    base.py                    DomainModel and small shared value types
    works.py                   WorkRecord, search and merge contracts
    providers.py               descriptors, roles, capabilities
    metadata.py                evidence, attempts, bundles, projections
    acquisition.py             plans, forms, receipts, results
    source.py                  materialization request/result strategies

  providers/
    base.py                    provider protocols
    catalog.py                 ProviderCatalog and bindings
    openalex.py
    semanticscholar.py
    arxiv.py
    zenodo.py

  operations/
    discovery.py
    metadata.py
    acquisition.py
    local_import.py
    materialize.py
    catalogs.py

  storage/
    acquisitions.py            current staging.py
    source_deposits.py         storage half of source.py

  source/
    archive.py                 safe archive extraction
    latex.py                   entrypoint, closure, embedded metadata
    findings.py

  transport/
    http.py

  schemas/
    acquisition.schema.json
    deposit.metadata.schema.json
```

This avoids reorganizing every provider into a directory merely for symmetry. OpenAlex and Semantic Scholar remain cohesive single files. Split arXiv or Zenodo further only if acquisition planning and metadata adaptation begin evolving independently.

The MCP can similarly become:

```text
src/mcps/procurement/
  server.py                    construction and lifespan only
  tools/
    discovery.py
    metadata.py
    acquisition.py
    source.py
    catalogs.py
  contracts.py                 MCP-only projections, if any
  prompts/
```

The existing 456-line server currently contains lifecycle, protocol types, response models, and thirteen tools. Registration functions per tool family would make it thin without duplicating backend operations.
