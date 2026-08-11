# Procurement MCP

`scientiae-procurement` is the Python MCP projection of `procurement.services.DiscoveryService`. It owns SDK
registration, tool schemas, prompts, and application lifespan. It does not own provider algorithms or
cross-provider workflows.

Run the stdio server from the repository environment:

```pwsh
.venv/Scripts/python.exe -m mcps.procurement
```

The installed script name is `scientiae-procurement`. The current tools are `discover_search`,
`discover_related`, `resolve_reference`, and `get_work`. Acquisition tools are intentionally absent until
the Python acquisition transaction and job lifecycle are implemented.
