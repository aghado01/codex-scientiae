# Cursor wiring — codex-membrane

## MCP (required)

Project config: **`.mcp.json`** at repo root.

```json
{
  "mcpServers": {
    "codex-membrane": {
      "command": "<absolute pwsh.exe>",
      "args": ["-NoProfile", "-File", "<absolute>/src/mcp-server.ps1"]
    }
  }
}
```

- **Do not** pass `-Root` — default is `ingestion/` (includes `corpora/Voroninski/`).
- After editing: **Cursor Settings → MCP → reload** (or restart Cursor).
- Smoke test: ask the agent to call `get_batch_summary` with `{ "scope": "corpora/Voroninski" }`.
  - Expect **21 tools** and 8 Voroninski papers.
  - `initialize.instructions` should mention the ingestion root, not `compendia`.

## Hooks (optional, advisory)

Project hooks: **`.cursor/hooks.json`** → `.cursor/hooks/membrane-governance.ps1`

Implements the same four PROCEDURE.md laws as `.claude/governance/contract.json`:

| rule | Cursor event | effect |
|------|--------------|--------|
| no-shell-out | `beforeShellExecution` | nudge: use MCP tools, not `pwsh -File mcp-server.ps1` |
| no-slurp | `beforeReadFile` | nudge: use `get_slice`, not raw `.runs/` reads |
| no-regenerate | `preToolUse` (Write/StrReplace) | nudge: use `propose_edit` → `apply` |
| finish-clean | `stop` | reminder: `finalize` + `review_document`, `pending == 0` |

All rules default to **advisory** (log + `agent_message`, never block). Fire log:
`.claude/governance/logs/fires.jsonl`.

Hooks reload on save; restart Cursor if they don't appear under **Hooks** in settings.

## What is NOT wired yet

- **Colonel / batch runspace manager** — design only (`.claude/membrane-scaling-design.md`).
- **Enforce mode** — flip individual rules in `contract.json` after fire-rate is quiet.
- **MCP `preprocess` resolver** — Voroninski `full/` nesting still needs direct `Invoke-Preprocess` (see brief).

## Voroninski workflow

See `.cursor/voroninski-ingestion-brief.md` and `src/PROCEDURE.md`.

Brief update (2026-06): re-preprocess remaining 6 papers **before** MCP repairs to pick up
bracket-balance + front-matter fixes (`1611.05985v3` and `2008.10579v1` already re-run).
