# Agentic Restoration — Membrane Architecture (design notes)

Working notes for the agentic layer that sits on top of the deterministic restoration
pipeline (`src/`). Captures a converged design discussion; open forks flagged as such.
Supersedes the procedural `WORKFLOW-2*.md` swarm — those are the process this replaces;
their *spirit* (smart procedure, token economy, internal validation) is the inheritance.

## The stack — three layers

```
Layer 2  Prose          procedure (primary — the simplifying sequence) + constitution (governing frame) — LATER
Layer 1  Membrane       the tools = an MCP server; discipline by construction
Layer 0  Pipeline       deterministic prep -> graded work-list (BUILT: project-ir..repair)
```

The pipeline does the maximal deterministic work and ends in a **graded work-list**
(`repaired` / `needs_review` / `needs_reextraction`) — which is also the **dispatch plan**.
Triage happens before any model is invoked.

## Layer 1 — the membrane is an MCP server

"Write the tools for the agent" and "this is an MCP" are the same statement. The MCP
server *is* the membrane; the discipline lives in the tool definitions, not in a prompt
an agent might ignore. `src/serving.ps1` is the read-side prototype already in tool shape.

Tool surface (thin adapter over existing PowerShell functions — nothing new invented,
the membrane is *exposed* not built):

- **Read (emit pointers / digests / metadata — never bodies):**
  - `get_summary` — title, zones, proto-TOC, counts (body-blind; a 50-pg doc ≈ a few hundred tokens)
  - `get_hotspots` — the graded work-list (id, page, grade, corruption_type, `seam` diagnostic, section)
  - `get_slice(id, context)` — exactly one work-unit via the `.jidx` seek
  - `get_batch_summary` — per-paper work-list + cost estimate (the depth-up analog of `get_summary`)
  - `get_render_region(id)` / `get_audit(id)` — the PDF region and the excised tail, for re-extraction
- **Write (chunk-bounded, validated):**
  - `propose_repair(id, content)` — touches exactly one chunk; gated by `Get-LatexBalance`
  - `commit` — deterministic merge of validated repairs (conflict-free; each worker owns its id)
- **Dispatch:**
  - `dispatch(...)` — budgeted spawn; enforces slice-bounds + a per-batch token ceiling

**Within-tool discipline is sealed by construction:** `get_slice` *can't* return a body,
`propose_repair` *can't* touch two chunks, `dispatch` *can't* exceed budget — regardless of
which agent connects or how eager it is. The detector/grader/validator is one primitive
(`Get-LatexBalance`): it flags corruption, grades the repair, and gates the merge.

## Token economy — two channels, asymmetric

The whole point ("don't blow a day's quota in minutes") is bounding context leakage. There
are two channels and they need different defenses:

1. **Worker leakage** (a sub-agent over-reads) — **sealed by construction.** Its only read
   affordance is `get_slice`; it physically cannot pull more than its slice + bounded context.
2. **Orchestrator leakage** (an over-eager *sighted* agent — Gemini/Antigravity, Copilot —
   over-reads). Two sub-cases:
   - **Multiplicative blow-up** (N workers × whole bodies) — the bank-breaker — **sealed by
     construction** at the `dispatch` budget + slice-bounds.
   - **Linear reach-past** (the orchestrator uses its *own* filesystem tools, past the membrane).
     MCP can't remove the agent's general tools without a cage, which is off the table
     ("not heavy-handed"). So this is **minimized** (the membrane emits only pointers/digests/
     metadata, so an agent that greedily consumes everything the membrane offers still stays
     cheap; over-reading raw files adds ~zero because the work-list is already complete) and
     otherwise **deferred to Layer 2** (the constitution), handled as a contract, not a cage.

Unifying invariant: **the membrane emits pointers, digests, and metadata at every seam,
never bodies.** Orchestrator plans from a body-blind manifest, dispatches *pointers* (id range
+ `seam` diagnostics) to workers, workers return *digests* (`repaired N, flagged M`). No body
ever enters the orchestrator's context.

## Layer 2 — the prose: procedure + constitution (later; the workflow is incomplete without it)

**Procedure is the most important prose here.** A clear, simple, sequential procedure is what
makes the workflow tractable — and cheap: the less an agent has to reason about *what to do*,
the less it leaks. Procedure simplifies. The `WORKFLOW-2*` phase sequence (prep → dispatch →
converge → validate → assemble) is good procedure and the inheritance is direct.

Construction does NOT replace procedure — it strips the *defensive policing* out of it. The old
directives ("NEVER edit the slice", "NEVER regenerate") were the procedure guarding a foot-gun;
once `propose_repair` makes that foot-gun non-existent, the procedure stops nagging and reads
clean and forward ("fill the repair, commit"). The sequence stays; only the policing leaves.

**Constitution** is the governing frame above the procedure — the norms and contracts (the
orchestrator↔worker compact, what a repair owes, when to defer to re-extraction) the procedure
operates within. Important, but it frames the procedure rather than outranking it.

"Not heavy-handed" is NOT "less procedure" — procedure is primary. Heavy-handedness is the
*failure mode* where constraint tips into brittle over-control or strangles the reasoning a step
genuinely needs. Different axis: procedure simplifies; heavy-handedness over-restricts.

The reach-past residual from the token section is this layer's business — the procedure says
"work the list, dispatch; you don't need bodies", the constitution is the contract behind it.
Also the seam where a light governor (cf. CyberneticCodePilot: per-agent hook governance —
budget and nudge, not cage) plugs in if prose isn't enough.

**Deferred** — the actual procedure + constitution content is not written here. Flagged so the
architecture is understood to be *incomplete* until this layer lands.

## Fractilitude — one membrane, depth-invariant

The membrane's contract (*emit pointers/digests/metadata, never bodies*) is identical at
chunk, paper, and batch level. So the two real-world workflows are not two machines:

- **Single** ("point Copilot at one paper, run post-ingestion") = **depth-1**: the agent *is*
  the orchestrator, working the list with the same tools, no swarm.
- **Batch** ("point a sighted agent at a pile, let it run subagents without breaking the bank")
  = **depth-n**: the same tools recursed; `get_batch_summary` is `get_summary` one level up.

There is no "batch mode" vs "single mode" — one server, a depth parameter. This is why the
shape couldn't be specified dry: the contract is depth-invariant, so the swarm is the single
agent with the recursion turned on, and that only became visible once the substrate existed.

## Carry-forward from WORKFLOW-2B (the spirit survives, the substrate is wiped)

| old (WORKFLOW-2B swarm) | new | status |
|---|---|---|
| Manager / Worker agents | orchestrator (body-blind) / sub-agent (slice-bounded) | carries |
| manifest `RAW→FIX` + idempotent `apply_manifest.py` (conflict-free parallel) | `propose_repair` + deterministic `commit` | carries — the crown jewel |
| dispatch only pages with a manifest | the graded work-list (cost-aware) | carries, sharpened |
| `read_span.py` byte ranges | `get_slice` via `.jidx` | carries |
| `clean_mechanical` first | collapse **+ repair** before any agent | carries, deeper |
| `validate_pages.py` until 0 errors | `Get-LatexBalance` merge-gate + graded fidelity | carries as chokepoint |
| split_pages / math_enrichment / reconstruct_tables / assemble / generate_toc | chunk-JSONL + formula chunks + sections + serialization | wiped (markdown-repair → JSON-IR-primary) |

The genuinely elegant core to preserve: **deterministic-apply → conflict-free parallelism**
(2B: *"multiple subagents can operate concurrently without merge conflicts"*) — cleaner now
with per-chunk `.jidx` addressing than with page-manifests.

## Open forks (undecided)

- **Output layout** — flat `.work/<name>.*` vs the matryoshka `{family}/{stamp}` recursive scope.
- **Config shape** — declarative DTO (`Build(config)`, strict-core/fluent-shell) vs positional.
- **Run provenance** — where the nested `{requested, resolved}` param trace lands (orchestrator-emitted?).
- **Dispatch granularity** — per-chunk vs grouping contiguous ambiguous chunks into a block.
- **Chokepoint depth** — deterministic validator only (`Get-LatexBalance`) vs + a model judge.
- **Constitution content** — Layer 2, deferred.

## Next build (smallest closed loop)

Stand up the MCP server as a thin wrapper over the existing membrane functions + the write-side
(`propose_repair` gated by `Get-LatexBalance`, `commit`). The pipeline stays PowerShell. That is
the smallest thing that turns this conversation into a running loop a sighted agent can drive —
without committing to any open fork above.
