**Your instinct is right.** Pull the layers apart. The current procurement code mixes three different jobs in PowerShell; the new direction lets you give each job the language that fits it.

### Current state (grounded)

Under `src/procurement/` you have:

- **API / plumbing** — `arxiv.ps1` (~48 KB), `zenodo.ps1`, `scholar-core.ps1`, `openalex.ps1`, `semanticscholar.ps1`, `scihub-get.ps1`
- **Normalization** — adapters that map sources into a shared Work model
- **MCP hosts** — `arxiv-server.ps1`, `scholar-server.ps1`, `zenodo-server.ps1` (stdio JSON-RPC, tool catalogues, prompts)

`src/mcp/reader-mcp/` is already cleaner: self-contained, read-only, no imports from the rest of `src/`. That separation is worth preserving.

TODO already points the same way: consolidate MCP code under something like `src/mcps`, keep algorithmic plumbing separate, one umbrella procurement MCP for agents, and per-item manifests when material lands in the inbox.

### Recommended division of labor

| Layer                     | Language              | Owns                                                                                                                     | Does _not_ own                                              |
| ------------------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------- |
| **MCP surface**           | Node (TypeScript)     | Protocol, tool schemas, arg validation, agent-facing descriptions/prompts, thin dispatch                                 | HTTP clients, rate limits, deposit logic, filesystem policy |
| **Plumbing / automation** | Python                | HTTP clients, retries, rate limits, response parsing, Work normalization, download integrity, source/PDF/html resolution | MCP protocol, agent instructions                            |
| **Deposit transaction**   | Python (jsonl_engine) | Staging → fingerprintable tree → `article.json` / source-ready sentinel (the S0 contract you already have)               | Discovery UX or MCP tool surface                            |
| **Inventory / catalog**   | Python (or thin PS)   | Materialized view over deposits                                                                                          | Authority over source truth                                 |

### How the pieces talk

```text
Agent  ──►  Node MCP (scientiae-procurement)
                 │
                 │  CLI / framed process
                 ▼
            Python plumbing
                 │
                 ├── discovery / resolve / fetch
                 └── deposit transaction (jsonl_engine)
                        │
                        ▼
                   inbox / article.json

Pipeline / orchestrator  ──►  Python plumbing directly
                              (no MCP hop)
```

Two important rules:

1. **Agents go through MCP → plumbing.**
2. **Orchestrated or batch procurement calls the Python plumbing directly.** Never force a pipeline through the MCP protocol just because the agent path uses it.

That keeps the MCP surface thin and agent-oriented while letting the Python orchestration layer (and later batch stages) drive multi-item acquisition without protocol overhead.

### Why this split

- **Node for MCP** — The MCP ecosystem, SDKs, and client tooling are strongest in Node/TS. Tool schemas, capability negotiation, and agent instructions stay in the language clients expect. The servers become thin: validate args, call a Python CLI or long-lived plumbing process, return structured results.
- **Python for plumbing** — Matches the direction you are already taking for jsonl_engine, orchestration, and deposit. HTTP, retries, parsing, and normalization are ordinary Python strengths. You can expose a framed CLI (same pattern as `jsonl_engine`) so both the Node MCP and the Python orchestrator can call it cleanly.
- **Deposit stays a transaction, not an MCP concern** — The source-ready sentinel + fingerprint rules you already designed for latex-ingest belong in the Python deposit path. Procurement should produce the same shape of artifact the rest of the system consumes.
- **Reader MCP stays separate** — Consume plane ≠ procure plane. Keep it self-contained (Node or PS is fine; the important property is that it does not depend on the generating tree or procurement plumbing).

### Taxonomy suggestion (matches your TODO)

- One umbrella **procurement / Scholar MCP** for agents (search, related, resolve, get_work, acquire).
- Underlying Python modules stay source-specific (`arxiv`, `zenodo`, `openalex`, `semanticscholar`, `scihub`, …) behind a small shared Work/normalize + fetch surface.
- Later: latex-ingest MCP and librarian MCP as separate surfaces, possibly under a broader umbrella if you want one entrypoint for agents.

### Practical migration order

1. Extract pure plumbing (HTTP + parse + normalize + download) into Python modules with a framed CLI.
2. Re-point the existing PS MCP servers at that CLI (thin adapters) so behavior stays stable while you move.
3. Rewrite the MCP hosts in Node against the same CLI.
4. Wire deposit through jsonl_engine so every successful acquire leaves a proper source-ready artifact (and, when you want it, an inventory row).
5. Let the Python orchestrator call the same plumbing for batch/multi-item acquisition without going through MCP.

batch-executor remains available as the parallel isolation engine if you later want “acquire these N papers” as a Batch stage under the orchestrator. It does not need to know about MCP at all.

That division keeps agent ergonomics in Node, durable automation and deposits in Python, and isolation where you already built it — without forcing every path through the protocol layer.
