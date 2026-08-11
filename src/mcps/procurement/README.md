# Procurement MCP

`scientiae-procurement` is the Python MCP projection of the procurement discovery and metadata services. It
owns SDK registration, tool schemas, prompts, and application lifespan. It does not own provider algorithms
or cross-provider workflows.

Run the stdio server from the repository environment:

```pwsh
.venv/Scripts/python.exe -m mcps.procurement
```

The installed script name is `scientiae-procurement`. Discovery uses `discover_search`,
`discover_related`, `resolve_reference`, and `get_work`. `list_procurement_providers` exposes the distinct
artifact and metadata roles. `prepare_source_deposit_metadata` returns a validated, self-contained metadata
bundle with the exact HTTP-decoded entity payload consumed by its provider normalizer, a digest, and
identity-checked fallback history. It does not claim to preserve compressed on-wire framing.

For an unpacked deposit, preserve that response as `{slug}.api-metadata.json` inside the document directory
and pass it to `New-LatexSourceDeposit -MetadataBundlePath` or to `jsonl_engine deposit --metadata-json`.
The API bundle supplies bibliographic metadata; the LaTeX transaction separately supplies source-integrity
findings. Acquisition tools remain absent until the Python acquisition transaction and job lifecycle are
implemented.
