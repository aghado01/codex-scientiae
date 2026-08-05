# Next session brief — infrastructure contract closure

## Objective

Turn the current implementation and discussion evidence into a disposition map and freeze the smallest
contracts required before any `jsonl-v2` production integration. This is a planning/contract session first;
implementation changes should be limited to probes or tests needed to answer a specific decision.

## Read first

1. [`../README.md`](../README.md) for scope and document authority.
2. [`../planning/architecture.md`](../planning/architecture.md) for the intended layers and implementation map.
3. [`../planning/decisions.md`](../planning/decisions.md) for settled constraints.
4. [`../planning/open-questions.md`](../planning/open-questions.md), especially Q1–Q5.
5. [`../planning/roadmap.md`](../planning/roadmap.md), Phase 1.

Use the compact structural chat export for design history. Consult the 1.7 MB verbose export only when tool
trace or exact omitted context is necessary; loading it by default is needless context cost.

## Proposed session scope

### 1. Produce the operational disposition map

Trace these surfaces and their live callers:

- `src/shared/jsonl.ps1`;
- `src/shared/jsonl-v2.ps1`;
- `src/shared/jsonl-store-v2.ps1`;
- `src/shared/jsonl-v2-compat.ps1`;
- `src/shared/runs.ps1`;
- `src/shared/log.ps1`; and
- current jso-jackson plus only the relevant export-child primitives.

For each function or responsibility, classify it as: shared primitive, shared service, application policy,
compatibility shim, toolbelt function, or dead/retired logic. Record live callers and persistent artifact
shapes rather than inferring use from file location.

### 2. Freeze three contract documents

Draft focused issue documents under `planning/contracts/` only after the disposition map exists:

1. `run-context.md` — allocation/join semantics, identity fields, address projections, child correlation,
   concurrency, and latest/pinned read behavior.
2. `jsonl-contract.md` — public command surface, error/result vocabulary, durability boundary, index contract,
   and file-versus-store lifecycle split.
3. `logger-contract.md` — application wrapper/decorator recipe, record/correlation fields, one-log concurrency,
   fallback ladder, returned degradation status, stderr/stdout behavior, and strict-policy override.

Do not create versioned public symbols or import the draft into production during this session.

### 3. Refresh roadmap and questions

- Amend or accept decisions only where evidence closes a question.
- Split any newly discovered concrete defect into a roadmap item with an exit gate.
- Leave genuinely open choices in `open-questions.md`; do not hide them in prose inside a contract.
- Create `ledger.md` only if a complete roadmap item, not merely a subtask, is actually closed.

## Required evidence

- Caller/import census for old and draft implementations.
- Capability matrix against current jso-jackson, with “reuse”, “adapt”, and “do not lift” dispositions.
- Multi-process observations or planned tests for run allocation and JSONL mutation.
- One application wrapper sketch using an existing runstamped workflow.
- Explicit list of production files that would change in the first migration tranche and a rollback boundary.

## Non-goals

- Broad call-site migration.
- Renaming `jsonl-v2.ps1` into production.
- Finalizing the ingestion manifest or inventory row schema.
- Designing a universal artifact-set protocol from the LaTeX specimens alone.
- Absorbing the separate batch-executor issue into this umbrella.

## Exit gate

The next implementation session should be able to answer, without rediscovery:

- which file owns each primitive and policy;
- what a run context contains and who creates it;
- what every JSONL mutation outcome means;
- how an application binds logger defaults and observes degradation;
- which compatibility behaviors have real consumers; and
- what the first bounded production migration changes and how it rolls back.
