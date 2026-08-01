# Membrane Governance — contract + reference adapter

USER NOTE: MOVED FROM PRIVATE `.claude` directory, which is NOT WHERE SOURCE CODE BELONGS

> Status: **working prototype, advisory-first.** The L4 governance plane from
> [`../membrane-governance-design.md`](../membrane-governance-design.md), made concrete. Built to dogfeed
> the CyberneticCodePilot `governator/`: validate the contract shape against a real workload before any
> C# is committed.

## What this is

Two separate things, deliberately:

- **`contract.json`** — the **agnostic** rule data. Four rules, one per PROCEDURE.md law. Validated by
  `contract.schema.json`. This file is the transferable artifact — it lifts straight into CCP's
  `contracts/`.
- **`adapters/claude/`** — a **per-vendor** shim that compiles the contract onto Claude Code's hook
  surface. The only Claude-specific code; the reference implementation a C# adapter later mirrors.

```
contract.json          the rules (agnostic)         ─┐
contract.schema.json   draft-2020-12 schema          │  lift → CCP contracts/
adapters/claude/
  compile.ps1          contract → .claude hooks block │  reference → CCP adapters/
  evaluate.ps1         runtime: match · log · steer  ─┘
logs/fires.jsonl       fire-rate telemetry (gitignored)
```

## The contract

| field                      | meaning                                                                                                           |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `event`                    | `PreToolUse` \| `PostToolUse` \| `Stop` \| `SubagentStop` \| `TaskCompleted`                                      |
| `match.tool` / `match.arg` | `\|`-alternated tool names / globs (or `*`). Arg = the command for Bash/PowerShell, the path for Read/Write/Edit. |
| `type`                     | `command` (deterministic) \| `prompt` \| `agent` (semantic) \| `http`                                             |
| `mode`                     | `advisory` (log + nudge, never block) \| `enforce` (apply `outcome`)                                              |
| `outcome`                  | `blockingError` \| `preventContinuation` \| `stopReason` — used only when `mode=enforce`                          |
| `message`                  | steering text injected back to the agent — names the correct next move                                            |

The four rules:

| rule            | law                 | fires on                                                                            | steers to                                              |
| --------------- | ------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `no-shell-out`  | navigate-not-scan   | Bash/PowerShell touching `mcp-server.ps1` / `serving.ps1` / dot-sourced `src/*.ps1` | call the registered MCP tools                          |
| `no-slurp`      | slice-not-slurp     | `Read` of `.runs/**` / `*.chunks.jsonl`                                             | `get_summary` → `get_slice`                            |
| `no-regenerate` | edit-not-regenerate | `Write`/`Edit` of the chunk stream                                                  | `propose_edit` → `apply`                               |
| `finish-clean`  | finish-clean        | `Stop`                                                                              | confirm `finalize` + `review_document`, `pending == 0` |

## Advisory-first (why the default is no teeth)

Every rule defaults to `mode: advisory`: the adapter **logs the fire and injects the steering message,
but does not block.** This reconciles two things —

- **Paved-paths-before-teeth** (the design doctrine): make the tool path win on merit first; a deny is a
  tail-risk backstop, and a rising fire-rate is a _paving_ smell, not a reason to add denies.
- **The self-test footgun**: a hard `no-shell-out` deny would block _you_ running
  `pwsh -File mcp-server.ps1` to test the server. Advisory mode keeps your own workflow clear.

`logs/fires.jsonl` is the instrument: it accumulates the real fire-rate per rule. **Flip a single rule to
`mode: enforce` only once the log shows that rule has gone quiet** (the paving holds) — tighten its `arg`
glob first. One field, one rule at a time.

## Install (Claude reference adapter)

1. Generate the hooks block:
   ```
   pwsh -NoProfile -File .claude/governance/adapters/claude/compile.ps1
   ```
2. Merge the printed `hooks` object into `.claude/settings.json` (or `settings.local.json`). It wires the
   relevant events to `evaluate.ps1`; all rule logic stays contract-driven.
3. Drive the membrane normally. Watch `logs/fires.jsonl` fill. Read the deny-rate, e.g.:
   ```
   Get-Content .claude/governance/logs/fires.jsonl | ConvertFrom-Json | Group-Object rule | Sort-Object Count -Descending
   ```

## Mapping to CyberneticCodePilot

- `contract.json` → CCP `contracts/` (the agnostic rule data; same `event/matcher/type/outcome` spine).
- `evaluate.ps1` → the reference behaviour a CCP per-agent `adapters/` implementation reproduces
  (match → log → steer; advisory/enforce split).
- `logs/fires.jsonl` → the evidence base for CCP's "paving reduces shell-out" thesis — and the four rules
  here are a clean first test case to assimilate (as the design doc notes, alongside context-mode's rules).
- **Next adapter:** the same contract → an Antigravity `hooks.json` adapter closes the loop on Gemini, the
  agent whose shell-out started this, and proves the agnostic-core / thin-shim fractal on two harnesses.

## Caveats

- **Hook output keys track a Claude Code version.** `permissionDecision` / `additionalContext` /
  `systemMessage` are the current contract; if yours differs, the _one_ place to adjust is the emission
  boundary at the bottom of `evaluate.ps1`. (For deny, the universal fallback is exit code 2 with the
  message on stderr.)
- **Latency.** A `command` hook spawns `pwsh -NoProfile` on every matched call (~150–300 ms). Fine for
  dogfooding/measurement; a persistent evaluator is the move if it ever bites a hot loop.
- **`finish-clean` is an advisory reminder here**, not a real check — `type: agent` semantic verification
  (resolve the papers touched, query each `pending`) is future work, ideally an `agent`-type hook.
- **`pwsh` vs routed `powershell`.** `compile.ps1` emits `pwsh`; if your Claude instance must use the
  dedicated portable instance via agent-bin, swap the command there.
