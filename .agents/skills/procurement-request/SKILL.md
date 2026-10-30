---
name: procurement-request
description: >
  Procure scholarly papers into a Codex Scientiae destination with the scientiae-procurement MCP.
  Use when the user asks to procure, acquire, ingest, fetch, or drop arXiv/Zenodo papers, source
  tarballs, PDFs, or HTML papers into inventory or a workspace-relative folder under git-ignored
  supellex-private/, including a list of related papers to one nested destination. Use when the
  user runs /procurement-request.
---

Use the connected `scientiae-procurement` MCP. Load its `procurement_request` prompt and follow that
document. Do not read `src/procurement`. There is no MCP tool named `procurement-request`; the
lock-step tool is `procure_source`.

The local corpus is git-ignored `supellex-private/`. Configured catalog `inventory` is
`supellex-private/staging`. A workspace-relative catalog is `supellex-private/<collection>/<topic>`.

After a batch, disposition each exception row: triage leaves it, manual repair finishes a
receipted leaf without a second download, and a rubber stamp closes an accepted witness gap.
