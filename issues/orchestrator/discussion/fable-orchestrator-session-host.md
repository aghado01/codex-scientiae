## Three phases, three artifacts

The core structural decision, following compile-then-execute to its conclusion:

- **Compile** → `plan.json` — population resolved, layout patterns rendered to concrete paths, identities pinned, stage digests precomputed. The plan is the run's complete address space and fact set.
- **Execute** → materializations — stages run against plan-resolved paths only. Nothing is discovered at execution time; things are only _verified_.
- **Record** → `ledger.jsonl` — append-only events: stage started, (doc, artifact) materialized with identity and digest, failures, gates. The ledger is the _only_ run state; process memory is a cache of it. Resume = replay ledger against plan.

One facade class gives you the singular handle:

```python
orch = Orchestrator(layouts, pipelines)
plan = orch.compile(pipeline="latex-ingest", population=docs, params={...})
result = orch.execute(plan)      # or orch.resume(run_root)
```

## The constellation behind it

| Component                | Responsibility (one line)                                                                  |
| ------------------------ | ------------------------------------------------------------------------------------------ |
| `LayoutRegistry`         | Named path patterns as declared data; consulted at **compile time only**                   |
| `PlanCompiler`           | Population + layout + pinning → emits `RunPlan`; the only allocator                        |
| `RunPlan`                | The compiled artifact; durable; the resume token                                           |
| `RunLedger`              | Append-only event log; durable; later an engine Ledger kind                                |
| `MaterializationIndex`   | In-memory view rebuilt from ledger; answers "is (doc, artifact) cleared at digest X?"      |
| `Executor`               | Walks stages, gates, narrows waves, dispatches Serial vs Batch                             |
| `BatchSession`           | Run-scoped framed-protocol host to batch-executor; the only component that knows PS exists |
| `StageRunner` (protocol) | The contract a stage implementation satisfies — not part of the orchestrator               |

And the declarative layer:

```python
@dataclass(frozen=True)
class StageSpec:
    name: str
    version: str                 # participates in the digest
    mode: Mode                   # SERIAL | BATCH
    scope: Scope                 # RUN | DOC
    requires: tuple[str, ...]    # artifact kinds
    produces: tuple[str, ...]
    runner: RunnerRef            # "python:pkg.mod:fn" | "pwsh:path/stage.ps1"
    params_schema: str | None = None
    budget: Budget | None = None # envelope for external/agentic stages
    gated: bool = False          # outputs are candidates until approved
```

`Scope` is the quiet load-bearing field: it's how you get joins without a DAG. A `RUN`-scope stage that `requires` a `DOC`-scope artifact implicitly joins over the surviving population (inventory rebuild is exactly this). Ordered stages + scope gives you sequence, fan-out, and fan-in — the three topologies the forensics actually needs — with no general graph machinery. A DAG can be earned later if a real consumer demands it.

## Contracts — the doctrine sentences

**Orchestrator:**

- The orchestrator schedules, verifies, and records; it never transforms. Domain logic appearing in the orchestrator is a defect by definition.
- Layout is read at compile time; the executor addresses the world only through the plan. Compile resolves, execute verifies.
- Every fact a stage depends on is pinned in the plan or recorded in the ledger. Execution-time discovery is a defect.
- The ledger is append-only and is the run's only memory. A run that cannot be reconstructed from plan + ledger is corrupt, not merely unlucky.
- A materialization clears only when every declared output exists with recorded identity. Partial writes are failure, never progress.
- Population is decided at compile time. A wave narrows, never widens — no mid-run adoption.
- The orchestrator never promotes. Deliverable placement is a distinct act outside the run, or an explicitly `gated` stage a human clears.

**Stages:**

- A stage knows its resolved inputs, its output slots, its params, and its budget — nothing else. No layout knowledge, no ledger access, no population awareness, no registry reads.
- A stage writes only inside its declared output slots and its scratch.
- Stage identity is `digest = hash(name, version, input identities, params)`. Same digest, existing outputs → skippable; that equation is the whole staleness model (your `Get-LatexBatchJob` discipline, generalized).
- A stage is mode-agnostic: the same runner serves Serial and Batch; Batch is just many invocations.

**Layout registry:**

- Patterns are declared data, schema-validated, versioned. Never sniffed, never hardcoded — the encoding-knob doctrine applied to paths.
- Every plan records the identity of the layout it was compiled under. Changing a pattern never retro-affects an existing run.

## Conventions

**Layout registry entries** — the configurable run-pattern shape you asked for:

```json
{"name": "doc-stage-artifact", "version": "0.1",
 "pattern": "{artifacts_root}/{pipeline}/runs/{run_id}/{doc}/{stage}/{artifact}"}
{"name": "run-control", "version": "0.1",
 "pattern": "{artifacts_root}/{pipeline}/runs/{run_id}/{file}"}
```

A `PipelineSpec` binds each artifact kind to a pattern _name_; the compiler renders. Rendering is a seam, not an implementation: v0 is strict substitution (unknown placeholder = error, silent passthrough forbidden), and **template_engine slots in behind that same `render(pattern, context)` signature** when patterns need real logic. The registry itself is shaped to become an engine Registry kind (keyed by name, unique, canonically ordered — it already fits the archetype); v0 is one schema-validated document.

**Run file layout:** `{run_root}/plan.json`, `{run_root}/ledger.jsonl`, everything else pattern-resolved. Plan pins roots once and stores paths root-relative, so a run directory is relocatable as a unit.

**Ledger records** (strict engine JSONL discipline from day one, so Thread 3 can adopt it without migration):

```json
{"event":"materialized","stage":"s4-flatten","doc":"2403.08110v4",
 "artifact":"resolved-tex","identity":"sha256:…","digest":"sha256:…","utc":"…"}
{"event":"failed","stage":"s6-convert","doc":"1611.03935v1","error_ref":"…"}
{"event":"awaiting-approval","stage":"s9-diagrams","doc":"…"}
```

**The invocation envelope** — one shape regardless of runner language or mode: the executor hands every stage invocation a JSON document (resolved input paths + identities, output slots, params, budget, scratch dir); the runner emits a result document. A Python callable gets it as a dict; a PS stage runner gets a file path; a Batch job is just (runner, envelope-path) pairs handed to `BatchSession`. This is what keeps the bridge thin and lets stage implementations migrate PS→Python without the orchestrator noticing.

**What this subsumes from `infrastructure`:** `run-paths.ps1`'s allocation logic (`Get-ArtifactsRoot`, `New-ModuleRunDir`) moves into `PlanCompiler` + `LayoutRegistry`, built on `paths.py`'s sentinel root. One-run-one-allocator: pipeline runs allocate _only_ through the compiler. The PS helper survives the transition as the nursery allocator for interactive/dev runs — a legitimate tier, not a leftover — and PS lane code inside pipeline runs needs no layout logic at all, because paths arrive in the envelope.

## Integration seams

- **jsonl_engine (import, in-process):** content identity for pinning, schema validation for plan/ledger/registry/artifacts (`validate-json` catalog path), strict JSONL write discipline for the ledger. Maturity ladder: v0 uses engine _schemas_; plan/ledger/registry become engine _kinds_ only when they've earned canon.
- **template_engine (later):** behind `render()`, as above.
- **batch-executor (unchanged):** behind `BatchSession`, which inherits the client's protocol _discipline_ — sequence numbers, buffer-until-clean-exit, structured error frames, no partial results — as `protocol.ps1`'s sibling, not its looser cousin.

## v0 cut and non-goals

V0 is: ordered stages, `SERIAL|BATCH` × `RUN|DOC`, compile/execute/resume, digest-gated skipping, per-(doc, artifact) ledger, narrowing waves, the session host. Explicit non-goals, batch-executor style: no general DAG, no retry policy (re-execute the plan; digests skip what's clean), no daemon, no cross-run scheduling, no domain logic, no promotion. Each exclusion has a named future consumer that would justify revisiting it — that's the earn-its-way-in rule applied to the orchestrator itself.

## The open questions that are genuinely yours

1. **Where the layout store lives** — orchestrator-owned directory vs. the repo's config tier. It's the code-vs-config charter applied to the registry itself; both defensible.
2. **The package's name** — your coinage to make; I've written "orchestrator" as a placeholder throughout.
3. **Plan pinning depth** — pin only input identities (cheap, per-doc verification at stage time) or also precompute full expected digests at compile (dearer, but makes `resume` a pure ledger-diff). I lean input-identities-only for v0.
4. **Ledger v0 form** — plain strict JSONL shaped for later Ledger-kind adoption (my recommendation, per the maturity axis) vs. waiting on Thread 3 to design the archetype first. The shape above deliberately makes either order workable.

## configs vs schemas

**the engine owns the type plane — schemas and the registry of kinds; instances live at their point of use.** It's the fact-gathering symmetry one more time: shape is engine knowledge, location is application knowledge.

- **Layout patterns** — schema (`run-layout.schema.json` or similar) registers in the engine catalog; the layout _document_ lives in the orchestrator's home. The orchestrator owns its config's location, not its config's shape.
- **Plan** — schema in the catalog; `plan.json` instances in run dirs.
- **Ledger** — the archetype/kind declaration is engine-side when Thread 3 lands it; ledger instances in run dirs. Unchanged.
- **Pipeline specs** — this is the consequence worth pausing on: a pipeline definition is _config too_, so by your rule its schema goes to the catalog and the instance lives **near its product** — latex-ingest's pipeline spec belongs to latex-ingest, not to the orchestrator. The orchestrator becomes fully generic: it holds the semantics (what `StageSpec` fields mean, how execution works) and its own layout document, but hoards nothing. Each lane declares its own pipeline the way each deposit declares its own article.

The compile phase is where the rule gets enforced mechanically: the compiler validates every consumed config instance against its engine schema (in-process, since the engine is an import) and pins each instance's content identity into the plan — layout doc, pipeline spec, params. So a run's provenance names not just _which_ configs it ran under but _exactly which bytes_ of them, and the "changing a pattern never retro-affects a run" contract falls out of pinning rather than needing policy.

Two pleasant side effects:

**The catalog becomes the census referent for shapes.** If config schemas join the kind/schema catalog, then "what declared shapes exist in this repo" has one answer surface — which gives your abductive census a canonical place to check a suspect artifact against, the same way the engine's doctrine sentences became the disposition criteria.

**Promotion gets a crisp mechanical form for configs:** promotion moves the _schema_, never the _thing_. A nursery config starts schema-less (or locally-schema'd) beside its application; battle-testing earns its schema a place in the catalog; the instance never moves. That's the maturity axis with zero migration cost at promotion time — the file that works keeps working, and what changes is only that its shape is now canon.

# one wrinkle though, in practice even with an orchestrator, i want to be able to "just run" a WIP pipeline, not have to update and maintain config between every dev iteration. how would that work mechanically here?

Good wrinkle — and the answer falls out of a distinction the design already implies but I should make explicit: **the plan is derived, never maintained.** Config fatigue comes from artifacts you must keep in sync with churning code. So dev mode's job is to make every synchronizable artifact either _derived_ (recomputed per invocation) or _absent until promotion_. Mechanically:

**1. The spec is a Python object; the document form is the promotion form.** `PipelineSpec` is a dataclass. A WIP pipeline is a single `.py` file next to the lane that constructs it inline — stages, runners, params, done. The compiler doesn't care whether the spec was parsed from a schema-validated document or built in twelve lines of code; downstream is identical. So during dev there _is_ no pipeline config file to maintain — there's the code you were already editing. Serializing to the document form (and sending its schema to the catalog) is what promotion means, and it can be mechanical: `orch export-spec` dumps the object you've been iterating.

**2. Layout is default-first; the registry is an override, not a prerequisite.** The orchestrator ships a built-in dev pattern — say `{artifacts_root}/{pipeline}/runs/_dev/{doc}/{stage}/{artifact}` — and any artifact kind not bound to a named pattern falls back to it. Zero layout entries needed to run. Named patterns enter when placement starts mattering (promotion, again).

**3. `run` is one fused verb, and recompiling is how your edits take effect.**

```bash
python -m orchestrator run pipelines/latex_ingest_dev.py --docs 1611.03935v1
```

compiles and executes in one call. The plan is regenerated _every invocation_ — cheap, and it's precisely why nothing needs maintaining: edit the spec object, run, the new plan reflects it. Compile-then-execute stays real internally (you still get `plan.json` and `ledger.jsonl` in the run dir, so every dev run is inspectable and resumable); it just stops being two UX steps.

**4. The dev run root is stable, and digests do the work stamps used to do.** Membrane doctrine says every run is a new stamp — right for canon, wrong for dev, where you want warm upstreams. Dev default: reuse `runs/_dev` per pipeline; `--fresh` when you want a clean room. Each invocation recompiles the plan, diffs digests against the ledger, and re-executes only what's invalid. Which brings up the one place the strict design would actively _hurt_ dev if left alone:

**5. In dev, stage `version` is the runner's source hash.** The digest is `hash(name, version, inputs, params)` — but nobody bumps `version` on every edit, so canonical digesting would happily skip a stage whose code you just changed (the classic Make footgun). Dev mode substitutes automatically: version = content hash of the runner file (the module for `python:` runners, the script for `pwsh:`). Now the loop is exactly what you want and _better than "just run" today_: touch S6's code → only S6 (and its downstream) re-executes; S3–S5 materializations reuse untouched. The monolith re-does everything on every iteration; this re-does only what you edited. Incremental re-execution is dev mode's payoff, not its tax.

**6. Validation and pinning degrade instead of blocking.** Nursery configs are legitimately schema-less under your promotion rule, so the dev compiler validates what has a schema, warns on what doesn't, pins what it can, and records `unpinned` for the rest in the plan. The provenance trail stays honest about its own gaps rather than demanding completeness you haven't earned yet.

**What does _not_ relax — deliberately:** the envelope (stages still receive resolved paths and touch nothing else), write confinement to slots, ledger appends, per-(doc, artifact) materialization accounting. Two reasons. Those are what make a dev run debuggable — "what did stage X actually read and produce" answers from the run dir, not from print statements. And more importantly, they keep dev and canon on **one execution model**, differing only in compiler strictness, digest source, and run-root policy. The moment dev mode becomes a second, looser execution path, you've rebuilt the promotion cliff — WIP pipelines that can't graduate because they grew habits canon forbids.

So the dev loop, end to end: edit the spec `.py` or a stage runner → `run` → recompile (instant), digest-diff, re-execute the touched stage against warm upstream materializations → inspect the run dir if surprised. Config appears in your life exactly once per pipeline: the day it stops being WIP.
