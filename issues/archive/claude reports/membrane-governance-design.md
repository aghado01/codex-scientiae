# Membrane Governance — design

> Status: **design**. The *paving* (capability-plane hardening) is implemented and verified
> (see [io-root-hardening-report.md](io-root-hardening-report.md)); the *teeth* (governance-plane
> hooks) are specified here, not yet built. This doc is the spec a continuing session — or the
> CyberneticCodePilot `governator/` effort — builds the hooks from.

## The problem

The restoration membrane (`src/mcp-server.ps1` + `serving.ps1` …) exposes a clean tool surface, yet
agents are still observed **fumbling with PowerShell** — launching `pwsh -File mcp-server.ps1`,
piping JSON-RPC by hand, dot-sourcing the libraries, reading whole `.chunks.jsonl` files — instead of
calling the tools. Each Bash/PowerShell tool call is a *fresh* shell (state does not persist between
calls) and the server is stateless (dies at EOF), so hand-driving it forces long-form, cold-start,
syntax-fragile one-shots. The goal: make agents stay on the tool path and on the PROCEDURE.md
workflow, across providers (Claude, Antigravity/Gemini, Cursor, Copilot).

## The core constraint — two wires, not one

A restoration agent acts through **two separate planes**, and only one is the membrane's:

| Plane | Wire | What it governs |
|---|---|---|
| **Capability** | the MCP server | only the tools it offers (opt-in) |
| **Governance** | the agent's **native hook surface**, per-agent | everything the agent does (its own Read/Write/Bash) |

**The membrane structurally cannot stop an agent shelling out or slurping a whole file** — those calls
are the agent's *own* Read/Write/Bash and never route through MCP, so the server never sees them.
Behaviour-governance therefore has to ride the agent's own hook surface (Claude `settings.json`,
Antigravity `hooks.json`, the equivalent in Cursor/Copilot) — *not* the MCP. **MCP offers hands;
hooks hold teeth.** Designing the membrane's "make the agent comply" story means designing *both*
planes together, and being honest that the enforcement half is per-agent, off the MCP wire.

(Architecture adapted from the sibling project `D:\pdenv\CyberneticCodePilot` — `SHAPE.md` "Two planes
+ a membrane", `contracts/README.md` hook contract. CCP is the general C# governator; the membrane is
a concrete first instance of the same pattern.)

## The doctrine — paved paths before teeth

Enforcement is **teeth-last**. The disciplined path must *win on merit* before any gate is added; the
deny is the rare backstop for tail risk, and a rising deny-rate is a design smell (the paved path
wasn't paved well enough), never a reason to add more rules.

The exemplar is **context-mode** (the MCP running in our own sessions): its PreToolUse hook does not
*block* a `Glob`/`Bash` call — it injects a tip suggesting `ctx_execute`, which is *also the better
tool* (raw output stays in a sandbox; the context window is spared). Compliance rides the gradient,
not the gate.

**What this means for "lean harder into hooks":** lean into the *paved path* plus a *few sharp
backstops* — not a thicket of denies.

### What is already paved (capability plane — implemented this session)

These are the merit wins that make the tool path the path of least resistance; they are the bulk of the
solution and they work for **every** MCP client (the agnostic base):

- **Bulletproof handshake** — UTF-8-pinned stdio, "stdout is sacred", fail-fast on a bad root, a
  daemon backstop so no single request crashes the loop. A clean, fast handshake is what keeps the
  tools *surfaced*; a flaky one gets the server dropped by the client → tools vanish → the agent
  shells out. (See [io-root-hardening-report.md](io-root-hardening-report.md); rule: STANDARDS.md §7.)
- **Discovery handshake** — `initialize.instructions` greets the agent with its bearings (resolved
  root, document count) *and* the explicit primer: *"this connection is your live session; never shell
  out to pwsh / mcp-server.ps1 to reach the membrane."* The one push-channel every MCP client honours.
- **Steering errors** — every failure teaches the correct next call (bad root → "correct -Root or
  escalate"; a malformed unit → `stage='unreadable'` flagged row, not a wholesale abort). An error is
  a prompt; ergonomic errors kill retry loops before they spend.
- **Batch fault isolation** — one corrupt unit no longer blinds the whole-batch survey, so the agent
  never has a reason to drop to a shell to "go check the file manually."

### Still to pave (capability plane — designed, not built)

- **MCP `prompts`** — serve PROCEDURE.md as an invokable workflow prompt (the code already intends
  this: *"Intended to be served to agents as MCP prompts"*). Cross-client, standards-based.
- **MCP `resources`** — PROCEDURE.md / STANDARDS.md as pullable resources.
- **Cross-client registration matrix** in SETUP.md (one command, per-client config location).

## The hook contract (governance plane — the spine)

Rules are **data**, not hardcoded regex (shape per CCP `contracts/README.md`, donored from didactico):

- **events** — `PreToolUse | PostToolUse | Stop | SubagentStop | TaskCompleted`.
- **matcher** — permission-rule syntax scoping a rule to specific *calls* (not output): `Bash(git *)`,
  `Read(**/*.chunks.jsonl)`, `Write`.
- **type** — `command` (cheap, deterministic shell), `prompt` (LLM evaluation), `agent` (agentic
  verifier — semantic supervision), `http` (POST hook input to an endpoint).
- **outcome** — `blockingError` / `preventContinuation` / `stopReason`: typed results that halt or
  steer the loop and **inject the reason back to the agent as a message** (the steering channel).

## The membrane's rule set — a small, sharp backstop

Each rule enforces one of PROCEDURE.md's three laws ("navigate not scan; slice not slurp; edit not
regenerate") or workflow completion. The first three are cheap deterministic `command` hooks; the
fourth is the semantic upgrade (`agent`/`prompt`) that no regex can do.

| # | name | event | matcher (the call) | type | outcome → steering text |
|---|---|---|---|---|---|
| 1 | **no-shell-out** | PreToolUse | `Bash`/`PowerShell` invoking `mcp-server.ps1`, `. */serving.ps1`, or JSON-RPC piped into pwsh | `command` | deny → *"the membrane is live as registered tools — call list_documents / get_slice / propose_edit; never launch the server from a shell."* |
| 2 | **no-slurp** | PreToolUse | `Read(**/.scratch/**)`, `Read(**/*.chunks.jsonl)`, `Read` of a raw `{slug}/{slug}.json` body | `command` | deny → *"don't load whole documents; use get_summary then get_slice. Content comes only where content is the point."* |
| 3 | **no-regenerate** | PreToolUse | `Write/Edit(**/.scratch/**)`, `Edit(**/*.chunks.jsonl)` | `command` | deny → *"artifacts are ground truth, mutated only via propose_edit → apply. Don't hand-edit the chunk stream."* |
| 4 | **finish-clean** | Stop / TaskCompleted | — | `agent` | verify finalize + review_document ran and `pending == 0`; else `preventContinuation` with the unresolved count. |

Rules 1–3 are *paved-path enforcement* — they should almost never fire once the capability-plane
paving lands; their deny-rate is a health metric. Rule 4 is genuine semantic supervision.

Sketch of the rules as a portable contract (the agnostic data; adapters translate it):

```jsonc
[
  { "name": "no-shell-out", "event": "PreToolUse",
    "matcher": "Bash|PowerShell(*mcp-server.ps1*|*serving.ps1*)",
    "type": "command", "outcome": "blockingError",
    "message": "The membrane is live as registered tools — call list_documents/get_slice/etc.; never launch the server from a shell." },
  { "name": "no-slurp", "event": "PreToolUse",
    "matcher": "Read(**/.scratch/**|**/*.chunks.jsonl)",
    "type": "command", "outcome": "blockingError",
    "message": "Don't load whole documents; use get_summary then get_slice." },
  { "name": "no-regenerate", "event": "PreToolUse",
    "matcher": "Write(**/.scratch/**)|Edit(**/*.chunks.jsonl)",
    "type": "command", "outcome": "blockingError",
    "message": "Artifacts are ground truth — mutate only via propose_edit -> apply." },
  { "name": "finish-clean", "event": "Stop", "type": "agent",
    "outcome": "preventContinuation",
    "check": "finalize + review_document ran and pending == 0" }
]
```

## Provider-agnostic shape

CCP's fractal — *generic core + thin per-agent shim* — applies exactly, and it resolves the
"don't make this Claude-only" tension:

- **Paving = server protocol** (`instructions`, future `prompts`/`resources`, steering errors). One
  surface, every MCP client. **Agnostic.** ← most of the work.
- **Rules = one declarative contract** (the JSON above). **Agnostic.**
- **Teeth = thin per-agent adapters** translating that contract to each harness's hook surface
  (`.claude/settings.json` for Claude; `hooks.json` for Antigravity; the Cursor/Copilot equivalent).
  Per-vendor, but driven by the shared rules — the *only* per-vendor part, and it's thin.

A client with no hook surface still gets the paved path; it just doesn't get teeth. The membrane never
depends on any one vendor's hooks for correctness — only for the optional backstop.

## Boundaries & non-goals

- **The MCP server is not the enforcer.** It cannot see, and must not pretend to govern, the agent's
  non-MCP calls. Statefulness would not change this (it is orthogonal — see the io-root report's
  reasoning); keep the server stateless / artifact-grounded.
- **No thicket of denies.** If a rule fires often, fix the paved path (ergonomics, instructions,
  prompts), don't add rules. Deny-rate trends down or the design is wrong.
- **Hooks are optional hardening, not the foundation.** The foundation is the capability-plane paving,
  which is already in place and is what makes a well-behaved agent reach for the tools on any client.

## Relationship to CyberneticCodePilot

CCP (`D:\pdenv\CyberneticCodePilot`, a separate C# project — *not edited from here*) is the general
form: a declarative `governator/` over a shared hook `contracts/`, with per-agent `adapters/`. The
membrane is a **concrete first instance** of that pattern, small enough to validate the contract before
the C# governator is built. Worth feeding the worked rule set above back into CCP's `governator/`
sketch as evidence; CCP's stated plan is to *assimilate context-mode's rules* into the governator, and
these four are a clean test case.

## Status / next steps

1. **This doc** — design captured. ✔
2. Implement **rule 1 (no-shell-out)** as a repo-local `.claude/settings.json` PreToolUse `command`
   hook (small PowerShell matcher emitting the steering deny) — the exact pain observed, and the
   reference adapter the CCP governator can later generalize.
3. Add the still-to-pave capability-plane items (`prompts`, `resources`, registration matrix).
4. Rules 2–4 follow once 1 is proven; rule 4 needs the `agent`-type hook surface.
