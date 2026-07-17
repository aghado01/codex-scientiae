# Membrane Architecture — synthesis

> Status: **living overview.** Ties the session's hardening + design threads into one picture. The
> per-topic docs hold the detail; this is the spine, the cross-cutting principles, the recorded
> decisions, and the roadmap. Read this first, then drill.

## Doc map

| Doc | Layer | Status |
|---|---|---|
| [io-root-hardening-report.md](io-root-hardening-report.md) | L0–L2, L5 | **built** — UTF-8 channel, derived root + runtime scope, fail-fast ceremony, discovery handshake, daemon backstop, batch fault isolation |
| [codepoint-followup-report.md](codepoint-followup-report.md) | L0 | **built** (concurrent) — provider→.NET file-I/O, rune-aware length heuristics, encoding |
| [membrane-governance-design.md](membrane-governance-design.md) | L4 | **design** — two planes, paved-paths-before-teeth, hook rule set |
| [membrane-scaling-design.md](membrane-scaling-design.md) | L5 | **design** — a new `src/` runspace manager (colonel patterns, lifted & owned); per-`{slug}` pool, greedy dispatch, two-tier feedback |
| **this doc** | all | the synthesis |
| `../src/PROCEDURE.md` · `STANDARDS.md` · `src/SETUP.md` | — | the workflow law, formatting rules, wiring |

## The layered model

Every thread we've discussed lands cleanly in one of six layers. Reading bottom-up, each layer assumes
the one below is correct.

| L | Layer | What it is | Status |
|---|---|---|---|
| **L0** | **Correctness substrate** | UTF-8/SMP surrogate-safe encoding; artifacts-as-ground-truth; per-unit fault isolation | built |
| **L1** | **Transport / channel** | how frames move: **stdio** (now) ↔ **HTTP** (favored) over a transport-agnostic dispatch core | stdio built; HTTP designed |
| **L2** | **Session / handshake** | the handshake *is* the session object; discovery `instructions` = bearings + priming; airtight / never-hang; fail-fast + daemon backstop | built |
| **L3** | **Capability (hands)** | the tool surface + ergonomics; steering errors; MCP `prompts`/`resources` | tools built; prompts/resources designed |
| **L4** | **Governance (teeth)** | two-planes constraint; per-agent hooks; the rule set; paved-paths-before-teeth | designed |
| **L5** | **Scale / orchestration** | lease/anti-clobber; budgeted `dispatch`; batch fault isolation (built); a **new `src/` runspace manager** (per-`{slug}` pool, greedy, colonel patterns lifted & owned); HTTP-shared-daemon multi-client (designed) | mixed → see [scaling design](membrane-scaling-design.md) |

## Cross-cutting principles

These recur at every layer; they are the design's actual through-lines:

- **Paved paths before teeth.** Make the disciplined path win on merit; the deny is a rare backstop and
  a rising deny-rate is a design smell. (Governance doctrine, but it governs L1–L3 too.)
- **Errors are steering.** Every failure teaches the correct next call — a bad root, a malformed unit,
  a blocked shell-out all return a message that names the right move. Ergonomic errors kill retry loops.
- **Stateless / artifacts are ground truth.** State lives in the run dirs (`.runs/{stamp}/`), not the process. An amnesic
  agent re-grounds from `get_batch_summary`. This is what guarantees no infinite-await / no lost work —
  statefulness is *orthogonal* to the shell-fumbling problem and would cost this resilience.
- **Generic core + thin shim** (the provider-agnostic fractal). Agnostic substrate (server protocol,
  rule contract) + thin per-vendor adapters (registration, hooks). The only per-client code is thin.
- **Airtight / never-hang.** Bounded handshake, no stray stdout, fail-fast — so the client never drops
  the server and the agent's tools never silently vanish (the likely root of the observed fumbling).
- **Body-blind / token economy.** Pointers and metadata by default; content only where content is the
  point. The membrane already embodies the context-mode "summary + artifact, raw stays on disk" pattern.

## L1 — Transport: stdio now, HTTP favored, dual over a shared core

**Lean (recorded):** **HTTP (MCP Streamable HTTP) is the favored *primary* transport**, for the reason
that matters most here — **the client/server boundary is obvious to a human**: "is it up?" becomes "is
the port listening?", the server is a standing, inspectable service rather than an opaque per-client
subprocess, and request/response has clean bounded semantics (reinforcing never-hang). **stdio is
retained** (most universally supported; zero-ops, client-managed lifecycle). So the target is
**dual-transport over a transport-agnostic core, not a replacement.**

**The refactor that makes it cheap:** the core is *already* transport-agnostic — `Invoke-Tool` + the
`$Tools` catalogue + the `initialize`/`tools/list`/`tools/call` dispatch don't know the transport.
Factor per-request handling into one `Handle-Request($req) → $response`; run two thin front-ends over
it (the existing stdio loop; a localhost `HttpListener` loop). One dispatch, two front doors.

**Honest caveats (carried from the discussion):**
- HTTP does **not** by itself stop shelling-out — the transport is invisible to the model; an agent can
  curl an endpoint from a shell and fumble identically. The fix for *that* is L3 ergonomics + L4 teeth.
- HTTP adds **ops** (you start/stop/restart the daemon, pin a port), **security surface** (bind
  `127.0.0.1`, Origin checks, maybe a token; `HttpListener` is BCL/no-deps but non-localhost needs an
  admin URL ACL), and **spec depth** (POST→JSON is minimal; full Streamable HTTP wants SSE + session
  ids for broad client acceptance).
- **Keep transport connections serial** (or behind the explicit worker pool, below) to protect the
  run-dir artifacts from concurrent-write races.

## L4 — Governance: two planes (see governance doc)

The membrane is **hands**; it structurally cannot govern the agent's own Read/Write/Bash (they never
route through MCP). **Teeth ride the agent's native hook surface, per-agent.** Rules are shared data
(a small contract: `no-shell-out`, `no-slurp`, `no-regenerate`, `finish-clean`); thin per-agent
adapters translate them. Detail and rationale in [membrane-governance-design.md](membrane-governance-design.md).

## L5 — Scale: a new `src/` runspace manager (designed — see scaling doc)

Detail in [membrane-scaling-design.md](membrane-scaling-design.md). The headline:

- **A new runspace manager, owned in `src/`** — lifting *patterns* from reposnapshot's `colonel`
  (a donor, **not** a dependency) and PSOneTools' clipboard-listener (the live-feedback tier), adapted
  to the membrane's conventions. The colonel itself does nothing here.
- **Unit = `{slug}`.** The manager assigns **one runspace per paper**; cross-`{slug}` is **write-disjoint
  by file path** (verified — every `src/` write is per-`{slug}`, no global mutable artifact), so it is
  race-free *by construction*. Within-`{slug}` is already disciplined by per-id proposals + leases + `apply`.
- **Greedy, not sliced.** One job per `{slug}` to a bounded `(1, N)` pool; the pool schedules as slots
  free (no straggler bucket). `Resolve-WorkerBudget` (pure) computes N.
- **Two pools, two purposes:** a *deterministic-stage* pool (in-process — `preprocess` is already a
  processor chain; the immediate win) and an *agent-repair fan-out* (the seeing agent + sub-agents as
  clients of the one HTTP membrane — not runspace work).
- **Two orthogonal axes:** runspace pool = the membrane's per-`{slug}` discipline (mechanism); sub-agent
  fan-out = the agent's own work (policy), riding *inside* a `{slug}`. `NO SUB-AGENT DISPATCH` bites only
  the agent axis; the deterministic pool spawns no agents.
- **Hygiene invariants the disjointness rests on:** (1) one runspace per `{slug}` (also keeps the lone
  lease-file read-modify-write serialized); (2) no global mutable artifact (true today — guard it).
- **Two-tier feedback:** colonel's end-of-run envelope + PSOne's live synchronized-hashtable status
  (mid-run progress + cooperative cancel at `{slug}` boundaries).
- **Status: design.** Mechanism/policy split keeps the manager *dumb*; the seeing agent is the brain.

## Decisions recorded

- **HTTP favored as primary transport** for client/server clarity + bounded semantics; **stdio retained**;
  target is **dual-transport over a shared `Handle-Request` core**, not a replacement.
- **Server stays stateless / artifact-grounded.** Statefulness is orthogonal to the shell-fumbling
  problem and would forfeit crash-resilience / never-hang. Not pulling that lever.
- **Governance is two-wire:** capability (MCP) + governance (per-agent hooks). The MCP is not, and will
  not pretend to be, the enforcer of non-MCP calls.
- **Provider-agnostic = agnostic substrate + thin per-vendor adapter.** Server protocol (`instructions`,
  future `prompts`/`resources`, steering errors) and the rule contract are agnostic; only the
  registration snippet and the hook adapter are per-vendor.
- **Concurrency belongs at L5 (lease-governed worker pool), not at L1 (transport).**
- **L5 runspace manager = a new `src/`-owned component**, lifting colonel/PSOne *patterns* (donors, not
  deps). Unit = `{slug}`; greedy dispatch; cross-`{slug}` write-disjoint (verified). Designed, build pending.

## Open / deferred

- **L5 runspace manager — build** (design done in the scaling doc; implementation pending).
- **HTTP compliance depth** — minimal POST-JSON vs full Streamable HTTP (SSE + session ids); pick per
  target-client support.
- **MCP `prompts`/`resources`** (L3) — serve PROCEDURE.md / STANDARDS.md through the protocol.
- **Per-vendor hook adapters** (L4) — Claude `settings.json` first; Antigravity `hooks.json`; Cursor/Copilot.
- **Cross-client registration matrix** in SETUP.md (one command, per-client config location).

## Roadmap (dependency order)

1. **Built (L0–L2, parts of L5):** encoding, root/scope, ceremony + discovery, daemon backstop, batch
   fault isolation, lease + budgeted dispatch. ✔
2. **Finish paving (L3):** strengthen the `instructions` primer (done); add MCP `prompts`/`resources`;
   write the cross-client registration matrix. *(Most-leverage agnostic work; precedes teeth.)*
3. **Transport (L1):** factor `Handle-Request`; add the localhost `HttpListener` front-end alongside
   stdio. *(Independent of L3/L4; do when the standing-service clarity is wanted.)*
4. **First tooth (L4):** `no-shell-out` PreToolUse `command` hook as the Claude adapter + shared rule
   contract. Then `no-slurp` / `no-regenerate`, then `finish-clean` (`agent` type).
5. **Scale (L5):** build the new `src/` runspace manager (design done — [scaling doc](membrane-scaling-design.md)):
   per-`{slug}` greedy pool over the lease protocol, deterministic-stage pool first.

Sequencing rule, from the governance doctrine: **pave (2) before teeth (4)**, and treat any hook that
fires often as a signal to improve the paving, not to add rules.
