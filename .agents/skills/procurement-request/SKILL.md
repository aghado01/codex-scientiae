---
name: procurement-request
description: >
  Procure scholarly papers into a Codex Scientiae destination with the scientiae-procurement MCP.
  Use when the user asks to procure, acquire, ingest, fetch, or drop arXiv/Zenodo papers, source
  tarballs, PDFs, or HTML papers into inventory or a workspace-relative folder, including a list
  of related papers to one nested destination. Use when the user runs /procurement-request.
---

Follow `src/mcp-servers/procurement_mcp/prompts/procurement-request.md`. That file is also the MCP prompt `procurement_request` on `scientiae-procurement`.

Do not read `src/procurement` to learn the workflow. Do not look for an MCP tool named `procurement-request`; the lock-step tool is `procure_source`.

## arXiv penalty box

Fastly fronts `arxiv.org` and `export.arxiv.org`. Atom metadata (`/api/query`) and artifacts (`/pdf`, `/src`, `/html` plus same-prefix figures) share one client-IP quota. One `procure_source` already spends several of those requests (source, PDF, HTML landing and figures, then metadata).

HTML is a default `procure_source` form. Do not pass a reduced `artifacts` list to skip it unless asked. Do not GET `/html/…` yourself, wget, or treat Atom `type="text/html"` as the paper (that link is the abs page). Missing HTML (`unavailable`: 404 or not a LaTeXML paper) is a skip, not a failed paper. A 429 on the HTML landing or a figure is still a rate-limit halt.

A 429 opens a cooldown (typically 30–120s). Any further arXiv request during that window **resets** the timer. Do not probe to see if it has cleared.

The server serializes arXiv HTTP on a jittered ~3s floor, applies a 429 cooldown, and shares that floor across MCP/CLI processes through a file-locked clock (`artifacts/procurement-mcp/rate-clock.json` in the workspace, overridable by `CDXSCI_PROCUREMENT_RATE_CLOCK`). Overlapping tool calls still queue and can trip client timeouts. Parallel subagents do not finish sooner.

- One in-flight arXiv-touching call at a time: `procure_source`, `acquire_artifact` with provider `arxiv`, `plan_artifact_acquisition` with provider `arxiv`, `prepare_source_deposit_metadata` with artifact provider `arxiv`, and discovery (`get_work`, `discover_search`, `resolve_reference`) with source `arxiv` or `all`.
- A versioned arXiv id is already the slug. Skip `get_work` and skip a pre-pass of `plan_artifact_acquisition`; `procure_source` replans internally.
- A valid file already at the planned destination leaf (`{slug}.pdf`, source archive) or a valid `{slug}-html/` tree is adopted in place. Do not move it to staging or an inbox so it can be written back. Invalid occupants still conflict.
- After any successful source-ready deposit, rebuild the destination's first-order inventory (`rebuild_article_inventory`, `force=true`). Do not wait to be asked. Fold a second-order inventory only when asked. Inventory tools do not contact arXiv.
- If `article.json` is missing a form the receipt now has, call `materialize_source_deposit` with `rebuild=true`, then rebuild that first-order inventory. Do not expect `procure_source` to rewrite the sentinel.
- Continue a batch after an ordinary per-item failure. On HTTP 429, a rate-limit error, or an arXiv transport timeout from a call that already contacted arXiv: **halt**. Report destination, slug, and error. Do not retry, do not start the next item, do not call discovery “while waiting”.
- Resume only when asked, and only after the cooldown from the last arXiv attempt (at least 60s; 120s if anything was sent during the box). Then the failed item, sequentially.
- A Semantic Scholar 429 is a different bucket; do not retry-storm it either. Do not immediately re-invoke `procure_source` for the same item — that hits arXiv again.
