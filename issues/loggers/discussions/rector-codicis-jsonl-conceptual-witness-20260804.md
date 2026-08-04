# rector-codicis as a JSONL design witness — 2026-08-04

## Scope

`D:\aghado01\utils\jso-jackson` is the implementation authority and current state of the art for the
jso-jackson family. The older copy under `D:\aghado01\rector-codicis` adds no implementation-discovery
work to the JSONL audit and should not be compared or lifted as if it were an independent engine.

rector-codicis matters here as a **conceptual consumer**: it demonstrates why a generalized JSONL substrate
became useful inside a primary/para-agent system and what kinds of operational semantics that substrate may
eventually need to support.

## Central idea: transport becomes telemetry

The project couples two otherwise sovereign agent runtimes at only named points. The primary/driver owns the
human conversation and delegates work; the para-agent is a whole, talk-back-capable agent with a separate
model family and token economy. Their inner loop is brief → work → artifact report → steer or escalate.

The exchange ledger is shared **federal ground**:

- it belongs to neither agent;
- both seats contribute to it;
- the human can inspect it;
- it preserves disagreement, escalation, cost, and provenance;
- it turns what was formerly a human-mediated transport ritual into persistent, queryable telemetry.

JSONL is therefore not merely a convenient file encoding in this design. It is the appendable event/history
substrate through which an inter-agent protocol becomes auditable and researchable.

## What sits above the generic engine

The dominant/subordinate or driver/para relationship is not a JSONL-core concern. It belongs in typed records,
store policy, and orchestration:

- role and authority: driver, para-agent, human tiebreaker;
- dispatch state: request, acceptance, progress, finding, objection, question, response, completion;
- adjudication: steer, escalate, defer, or request another bounded round;
- provenance: who asserted what, from which brief/artifact/test, under which model/runtime;
- token economy: allocation, spend, provider reconciliation, and declared degradation;
- governance: allowed coupling points, intervention records, and decisions reserved to the human;
- memory promotion: private episodic streams remain sovereign until explicitly promoted through the shared
  membrane.

The generic JSONL layer should make those records safe to store, append, read, seek, validate, query, and
snapshot. It should not know what a para-agent is or decide how dissent is resolved.

## Four distinct JSONL-backed operational units

rector-codicis sharpens an important distinction already emerging in codex-scientiae:

| unit | authority | natural mutation model | failure posture | likely identity/order |
|---|---|---|---|---|
| run log | observational | append events | normally best-effort with visible degradation | run + event/process identity; physical/causal time |
| run ledger | operational state/history | append transitions, possibly compact/project later | application-defined and often stricter than logging | run + transition id; state-machine/causal order |
| inter-agent exchange ledger | federal protocol history | concurrent append of typed events | authoritative protocol record; loss may block or degrade explicitly | job/exchange/event ids; per-writer and causal order |
| inventory catalog | deterministic materialized view | merge/remove/resort and atomic rewrite | reject invalid mutation | scoped path key; canonical ordinal order |

They may share codec, index, query, snapshot, and validation primitives without sharing defaults. In
particular, a sorted catalog rewrite and an append-only exchange journal are different store policies, not
two modes that every caller should have to reconstruct manually.

The RPC job quartet proposed in rector-codicis—`request.json`, `result.jsonl`, `summary.json`, and
`errors.jsonl`—does not violate the preference against proliferating log sidecars. These are distinct
authoritative/projection artifacts with different semantics, not several accidental log files. Whether all
four remain necessary is an application design question for the dispatch protocol.

## Pressure placed on the new shared design

### Store policy needs a mutation model

The current managed-store policy captures key, uniqueness, schema, and canonical sort. A general policy may
also need to declare whether the store is:

- append-only journal;
- canonically materialized view;
- append history with a derived compact/current-state projection;
- immutable snapshot.

That decision affects whether physical row order is evidence, whether replacement is legal, and whether a
mutation may rewrite prior rows.

### Concurrent append needs explicit ordering semantics

A mutex can serialize cooperating writes safely, but it does not by itself define causal order across two
agents. A federated exchange ledger may require event id, writer id, local sequence, exchange/round id,
timestamp, and causal parent/reference fields. Physical order can remain the durable arrival order without
pretending it is the only semantic order.

### Logger failure and ledger failure are different

The shared logger should normally avoid defeating an application run and make fallback visible. An
operational exchange ledger may be part of the protocol's correctness boundary: continuing without recording
a dispatch, objection, or escalation could be invalid. Failure posture therefore belongs to the
application/store policy, not to JSONL append itself.

### Lifecycle spans more than a file

The JSONL engine owns file-level correctness. A job protocol owns transitions across request, event stream,
summary, errors, artifacts, and completion markers. It needs named create/open/append/complete/inspect/repair
operations over a runstamped job root, but those operations should compose the generic primitives rather than
move protocol concepts into `jsonl-v2.ps1`.

### Queryability is part of the protocol payoff

The ledger is valuable because it can answer questions after the fact: where dissent arose, what the driver
steered without escalation, how many rounds occurred, which evidence resolved an objection, whether token
rollups reconcile, and where context mass grows. Range, exact lookup, projections, schema-aware validation,
and eventually witnessed secondary indexes make the protocol researchable without reinjecting whole streams
into an agent context.

### Bounded returns are a consumer contract

rector-codicis uses summary + artifact pointer as a token-discipline pattern. This belongs in MCP/toolbelt and
application result envelopes above the JSONL engine. The engine supplies bounded slice/sample/query
operations; the application decides what summary is sufficient and which artifact path is returned.

## Architectural conclusion

No rector-codicis code needs to be lifted for this work. Its contribution is a non-inventory, multi-writer,
operational pressure test:

1. keep the JSONL engine schema- and agent-agnostic;
2. distinguish logs, operational ledgers, journals, snapshots, and materialized stores;
3. let each store kind bind mutation, ordering, schema, derivative, and failure policy;
4. preserve physical append history when it is evidence;
5. make cross-file job lifecycle an orchestration layer;
6. build query/inspection paths that return bounded evidence rather than whole context-heavy streams.

