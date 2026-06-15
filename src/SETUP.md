# Wiring up the Restoration Membrane MCP

> Draft. How to register `mcp-server.ps1` with an MCP client (Claude Code) so an agent can drive the
> restoration workflow over the wire. See [README.md](README.md) for what the system is.

## Prerequisites

- **PowerShell 7+** (`pwsh`). Nothing else — the server is pure PowerShell + .NET regex, self-contained
  via `$PSScriptRoot`.
- If `pwsh` is not on the client's `PATH` (e.g. a portable install), use the **absolute path** to
  `pwsh.exe` as the command instead of the bare name.

## The launch line

```
pwsh -NoProfile -File <repo>/src/mcp-server.ps1 -Root <ingestion-subtree>
```

- `-NoProfile` keeps the user profile off stdout (stdout carries JSON-RPC frames **only**; all logs go
  to stderr).
- `-Root` is the ingestion subtree to serve. Every tool is paper-addressed and resolves papers by
  crawling under `-Root`, so the **same server serves one paper or a whole batch unchanged**:
  - a whole compendium: `<repo>/ingestion/compendia`
  - one topic: `<repo>/ingestion/compendia/ph`
  - the choice only narrows what `list_documents` / `get_batch_summary` survey.

## Register with Claude Code

**Option A — project config (`.mcp.json` at the repo root):**

```json
{
  "mcpServers": {
    "codex-membrane": {
      "command": "pwsh",
      "args": [
        "-NoProfile",
        "-File", "src/mcp-server.ps1",
        "-Root", "ingestion/compendia"
      ]
    }
  }
}
```

Relative paths resolve from the project root. Use absolute paths if the client launches the server
from a different working directory, or if `pwsh` isn't on `PATH` (swap `"command"` for the full
`pwsh.exe` path).

**Option B — CLI:**

```
claude mcp add codex-membrane --scope project -- \
  pwsh -NoProfile -File src/mcp-server.ps1 -Root ingestion/compendia
```

## Verify

A clean wire-up answers `initialize`, lists **21 tools**, and logs one startup banner to stderr:

```powershell
$server = '<repo>/src/mcp-server.ps1'
$root   = '<repo>/ingestion/compendia'
@(
 '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}'
 '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
) | pwsh -NoProfile -File $server -Root $root
# expect: id=2 result.tools has 21 entries; stderr: "codex-membrane MCP server up (root=...)"
```

Or, once registered, just ask the agent to call `list_documents` — a clean survey of the ingestion
root means the membrane is live.

## For agents: when the user asks to "wire up the MCP"

1. Confirm `pwsh -v` reports **7+**. If `pwsh` isn't found, locate `pwsh.exe` and use its absolute path.
2. Pick `-Root`: default to the broadest ingestion subtree the user means (e.g. `ingestion/compendia`),
   or a single topic if they named one.
3. Write `.mcp.json` at the codex-scientiae repo root (Option A) — or run the `claude mcp add` line
   (Option B). Prefer absolute paths when in doubt.
4. Verify: `initialize` + `tools/list` should report **21 tools**; stderr should show the startup
   banner and nothing else. A non-empty stderr beyond the banner means a load error — report it.
5. Hand off to **[PROCEDURE.md](PROCEDURE.md)** for the workflow (the agent's `list_documents → preprocess
   → … → finalize → review_document` loop).

## Notes

- **stdout is sacred** — protocol frames only. If anything else reaches stdout the client will choke;
  that's what `-NoProfile` and the server's stderr-only logging protect.
- The server is **stateless**; restart it freely. All document state lives in the `.scratch/`
  artifacts under `-Root`, so a fresh process resumes exactly where the last left off.
- `.scratch/`, `.work/`, `__pycache__/` are gitignored — they're regenerable working output.
