# codex-arxiv — true auto-wake for background fetch (option 3)

**Status:** brief / not built. Prereqs LANDED in codex-arxiv **v0.4.0**: `fetch` is non-blocking (returns a
`job_id`, single in-server worker runspace drains the queue behind the shared 3s floor), `fetch_status`
polls, and `fetch_status wait=N` long-polls (server-capped ~55s) — see `src/arxiv.ps1` / `src/arxiv-server.ps1`.

This brief captures the remaining ergonomic gap and a design to close it **without spawning a subagent**.

## The gap

The async fetch lets an agent fire a download and move on — but the agent must *poll* (`fetch_status`) or
*choose to block* (`wait=N`) to collect the result. What it can't get today is the unit-test experience:
**fire, walk away, and be re-invoked automatically when it's done.**

That auto-wake exists in Claude Code, but only for **harness-tracked** work: a background process launched via
`Bash`/`PowerShell` with `run_in_background: true` "re-invokes you when it exits." The in-server MCP worker is
a *thread inside the MCP server process* — invisible to the harness — so it can't trigger a re-invocation.

## The distinction that makes this safe (background process ≠ subagent)

| mechanism | new LLM context? | quota | context-mode hooks | who tracks done | auto-wakes agent | rate-limit safety |
|---|---|---|---|---|---|---|
| in-server worker runspace (built, v0.4.0) | no | none | n/a | the MCP server | no — agent polls | central: one 3s clock |
| **harness background process** (`run_in_background`) | **no** | **none** | preserved | the harness | **yes** | each process has its own clock |
| subagent (Agent tool) | yes, full LLM | heavy | **bypassed** | harness | yes | n/a — **banned in this env** |

The auto-wake we want is a property of the **middle row** — a plain detached OS process, no second LLM, no
quota beyond the primary agent, context-mode hooks intact. It is categorically different from subagent
dispatch (which is banned here) and must not be conflated with it.

## Why NOT just run the whole fetch as a background process

The 3s arXiv floor is global; only a **single long-lived serializer** can honor it across all fetches. If each
fetch became its own harness background process, each would carry its own throttle and they could fire <3s
apart → IP ban. So the download must stay in the one in-server worker. The background process should be a
**thin waiter**, not a second fetcher.

## Proposed design — in-server worker + completion marker + thin harness waiter

1. **Worker writes a terminal marker.** When a job goes `done`/`failed`, the worker writes the full job view
   to a marker file, e.g. `<staging_root>/.jobs/<job_id>.json` (path-confined under the staging root, like
   every other arxiv path). A marker (vs. watching the staged artifact directly) is preferred because it also
   captures **failure** and carries the result/reason — an artifact-watch can't tell "still running" from
   "failed and nothing landed."
2. **`fetch` returns `marker_path`** in its enqueue response so the agent knows exactly what to watch.
3. **Agent fires a thin waiter** as a harness background process (NOT a subagent), e.g.:
   ```powershell
   # run_in_background: true
   $m = '<marker_path>'
   while (-not (Test-Path -LiteralPath $m)) { Start-Sleep -Seconds 2 }
   ```
   It exits when the marker appears → the harness re-invokes the agent.
4. **Agent collects.** On wake, it calls `fetch_status(job_id)` (now terminal) or reads the marker directly.

The waiter must use the **filesystem** as the signal: a separate process cannot reach the MCP server's
in-memory job registry (that lives only behind the agent's live stdio session). The marker file is that
cross-process signal.

## Server-side work required

- Worker: write `<staging_root>/.jobs/<job_id>.json` on terminal transition (confined; UTF-8 no-BOM per repo
  I/O convention).
- `Add-ArxivFetchJob` result: add `marker_path` (repo-relative).
- Cleanup: evict markers alongside the 30-min in-memory TTL (`Clear-ArxivStaleJobs`) or when a job is evicted.
- Decide marker location so it can't trip membrane discovery — the membrane discovers by `*.arxiv.json`
  sidecars, so a dotdir (`.jobs/`) inside the inbox should be inert, but verify; alternatively place markers
  outside the inbox entirely.
- Optional: `fetch_status` falls back to **reading the marker** when the in-memory job is gone (post-restart),
  making status restart-durable (the marker on disk survives a server restart; the in-memory registry does not).

No new MCP tool is needed. The waiter is agent-side (documented pattern), not server code.

## Caveats / constraints

- **Client-specific.** The auto-wake-on-process-exit is a Claude Code harness feature. If codex-arxiv is ever
  driven from a different client, wire the MCP completion notification into a re-prompt instead.
- **stdio is 1:1.** Each client spawns its own `arxiv-server.ps1` over stdio, so there's a single client per
  server process — no cross-client contention on the worker or the long-poll.
- **Restart.** In-flight jobs are lost from the in-memory registry on server restart; the marker (and the
  `.part`/sidecar on disk) survive, which is why the marker should carry the full job view.

## Open questions (decide before building)

1. Always write markers (cheap, also gives restart-durable status) vs. opt-in `fetch` arg?
2. Marker directory: `<staging_root>/.jobs/` vs. outside the inbox? (Confirm no membrane-discovery collision.)
3. Should `fetch_status` read-through to the marker when the in-memory job is absent (restart durability)?
4. Cleanup policy: tie marker eviction to the existing 30-min job TTL, or a separate sweep?

## Scope

Small: a marker write on terminal transition, `marker_path` in the enqueue result, marker cleanup, and a
short doc/prompt note describing the agent-side waiter. The rate-safe download and the poll/long-poll surface
already exist (v0.4.0).
