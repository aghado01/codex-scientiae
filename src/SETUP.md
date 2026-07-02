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
pwsh -NoProfile -File <repo>/src/mcp-server.ps1
```

- `-NoProfile` keeps the user profile off stdout (stdout carries JSON-RPC frames **only**; all logs go
  to stderr).
- **No `-Root` needed.** It derives to `<repo>/ingestion` (the raw-input boundary) from the script's
  own location, so the config carries only deployment facts. `-Root` remains an optional override if
  you ever want to anchor the server elsewhere. If the resolved root does not exist (or is not a
  directory) the server **fails fast, in the agent's feed**: the connection still mounts (`initialize`
  and `tools/list` succeed, so the agent comes up and can orient), but every `tools/call` returns an
  `isError` result carrying the diagnostic and the fix. The agent sees a brief, actionable
  notification — correct `-Root` / create the directory and reconnect, or escalate to the user — rather
  than silent empty surveys. The same line is logged `FATAL` to stderr for the operator.
- **Which subtree to survey is a per-call choice, not a launch choice.** Every tool is paper-addressed
  and resolves papers by crawling the whole root, so the **same server serves one paper or a whole
  batch unchanged**. To narrow what `list_documents` / `get_batch_summary` / `dispatch` look at, pass
  an optional `scope` argument on the call itself (see below) — there is nothing to bake into the
  registration.

### Runtime `scope` (narrowing a survey per call)

`list_documents`, `get_batch_summary`, and `dispatch` accept an optional `scope` string: a subtree
under the ingestion root to survey. Empty/absent = the whole root. It is full-path-normalized and
confined to the root (a scope that escapes via `..` or an absolute path is rejected). Examples:

- whole compendium: `{ "scope": "compendia" }`
- one topic: `{ "scope": "compendia/ph" }`
- a different ingestion subtree: `{ "scope": "codices" }`

The paper-addressed tools (`get_summary`, `get_slice`, `propose_edit`, …) already resolve papers by
name across the whole root and need no `scope`.

## Register with Claude Code

**Option A — project config (`.mcp.json` at the repo root):**

```json
{
  "mcpServers": {
    "codex-membrane": {
      "command": "pwsh",
      "args": [
        "-NoProfile",
        "-File", "src/mcp-server.ps1"
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
  pwsh -NoProfile -File src/mcp-server.ps1
```

## Verify

A clean wire-up answers `initialize`, lists **21 tools**, and logs one startup banner to stderr:

```powershell
$server = '<repo>/src/mcp-server.ps1'
@(
 '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}'
 '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
) | pwsh -NoProfile -File $server
# expect: id=2 result.tools has 21 entries; stderr: "codex-membrane MCP server up (root=<repo>/ingestion)"
```

The `initialize` reply (id=1) also carries an **`instructions`** field: the server's discovery
handshake. On a healthy mount it reads `serving ingestion root '<root>' -- N document(s) discovered,
M preprocessed ...` — that is the agent's bearings. `mounted but EMPTY -- 0 documents` means the root
exists but holds no corpus (wrong tree or not yet populated); an `error: ...` string means the root is
unmounted. Clients inject this into the agent's context, so a misconfigured root is visible at the
handshake, not inferred from an empty survey.

Or, once registered, just ask the agent to call `list_documents` — a clean survey of the ingestion
root means the membrane is live. To narrow it, pass `{ "scope": "compendia/ph" }`.

## For agents: when the user asks to "wire up the MCP"

1. Confirm `pwsh -v` reports **7+**. If `pwsh` isn't found, locate `pwsh.exe` and use its absolute path.
2. No `-Root` to pick — it derives to `<repo>/ingestion`. Survey scope is a per-call `scope` arg, so
   the registration is the same regardless of which subtree the user means.
3. Write `.mcp.json` at the codex-scientiae repo root (Option A) — or run the `claude mcp add` line
   (Option B). Prefer absolute paths when in doubt.
4. Verify: `initialize` + `tools/list` should report **21 tools**; stderr should show the startup
   banner and nothing else. A non-empty stderr beyond the banner means a load error — report it.
5. Hand off to **[PROCEDURE.md](PROCEDURE.md)** for the workflow (the agent's `list_documents → preprocess
   → … → finalize → review_document` loop).

## Notes

- **stdout is sacred** — protocol frames only. If anything else reaches stdout the client will choke;
  that's what `-NoProfile` and the server's stderr-only logging protect.
- The server is **stateless**; restart it freely. All document state lives in the per-paper run-dir
  artifacts (`.runs/{stamp}/`, legacy `.scratch/`) under the ingestion root, so a fresh process
  resumes exactly where the last left off — always on the paper's latest run.
- `.runs/`, `.scratch/`, `.work/`, `__pycache__/` are gitignored — they're regenerable working output.
