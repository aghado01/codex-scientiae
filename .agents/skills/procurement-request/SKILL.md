---
name: procurement-request
description: >
  Procure scholarly papers into a Codex Scientiae destination with the scientiae-procurement MCP.
  Use when the user asks to procure, acquire, ingest, fetch, or drop arXiv/Zenodo papers, source
  tarballs, or PDFs into inventory or a workspace-relative folder, including a list of related
  papers to one nested destination. Use when the user runs /procurement-request.
---

Follow `src/mcp-servers/procurement_mcp/prompts/procurement-request.md`. That file is also the MCP prompt `procurement_request` on `scientiae-procurement`.

Do not read `src/procurement` to learn the workflow. Do not look for an MCP tool named `procurement-request`; the lock-step tool is `procure_source`.
