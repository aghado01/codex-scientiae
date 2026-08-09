# well part of my line of questioning here is acknowledging that latex-ingest is already poisoned and im trying to re-imagine the process with an orchestrator behind it. what do i need to add to the things i already did in batch-executor in order to be able to write a pipeline that expresses the latex-ingest workflow?

Thought for 56s

**Short answer:** batch-executor already gives you everything you need for _finite, independent, isolated document jobs_. It deliberately does **not** give you a way to express the _internal multi-stage structure_ of latex-ingest itself. That is the gap an orchestrator must fill.

### What batch-executor already covers for latex-ingest

From the current shape:

- Get-LatexBatchJob turns inventory rows (or article manifests) into one PowerShellProcess job per document.
- Each job freezes identity (manifest + source-tree SHA + patch identity + output switches), declares its writes under a run directory, and invokes the production entrypoint Invoke-ArxivLatexToMarkdown.
- latex-batch.ps1 is just the thin shell: inventory → planner → New-BatchPlan → Invoke-BatchPlan.
- Isolation, timeouts, process-tree teardown, cost-based dispatch, result ordering, and write-collision rejection are all handled.

This is excellent for “run the full conversion over these N source-ready documents.” It is **not** a pipeline description of what happens _inside_ one document.

### What the latex-ingest workflow actually is

latex-ingest.ps1 is a large, largely sequential, in-memory transform with many internal stages. The top-level comment still states the membrane-inspired spine:

- Expand macros
- Resolve numbering / cross-refs
- Protect math spans (env-aware)
- Transform structure
- Restore math

Around that spine sit many more concrete steps that currently live inside the same process and mostly share script-scoped stores:

- Manifest resolution + schema validation (via jsonl_engine)
- Source-tree confinement + entrypoint resolution
- Patch application (source-space then output-space)
- Oracle counts
- Diagram capture / encode-first / render ladder (tectonic → MuPDF / tikzjax)
- Figure asset copy + PDF/EPS raster
- Docstream + refgraph + docgraph construction
- Math-render audit
- Hygiene / TOC / deliverable bundling
- Sidecar emission (oracle-counts, diagrams.jsonl, refs.jsonl, etc.)

Almost all of this is one giant function (ConvertFrom-Latex + the orchestrator around it). Intermediate results are either in-memory hashtables or run-local files written near the end. There is no first-class stage boundary, no declared intermediate asset, and no way for an outer system to say “re-run only the diagram stage” or “this math-protection store is already valid.”

### The precise gap relative to batch-executor

batch-executor’s non-goals are explicit and correct:

- No dependency-DAG scheduling
- No durable queues / resume
- No retries
- No native multi-stage ownership inside a job

So you cannot express, with the current surface alone:

1. **Intra-document stages** with clear inputs/outputs.
2. **Materialized intermediate assets** (expanded source, protected math store, resolved ref model, diagram work-list, hygiene result, …) that can be inspected, cached, or selectively recomputed.
3. **Lineage / upstream-downstream** so a change in the patch file or a new diagram renderer only invalidates the affected stages.
4. **Independent failure domains** inside one document (diagram render can fail without throwing away the already-correct macro expansion).
5. **Selective re-execution** of a later stage against earlier materializations.

Those are exactly the properties a pipeline orchestrator is for.

### What you need to _add_ (not change inside batch-executor)

Do **not** try to turn batch-executor into a DAG engine. Keep it as the finite parallel worker.

You need an outer layer that can:

**1. Decompose the current monolithic transform into named stages with explicit contracts**

Minimum useful cut points (you can refine later):

- Resolve + validate article / apply source patches → resolved TeX + oracle counts
- Macro expansion + numbering / ref resolution → body + ref model
- Math protection + structure transform → protected body + stores
- Diagram encode / render + figure assets → markdown with images + diagrams.jsonl
- Restore + hygiene + output patches + audits + sidecars → final deliverable

Each stage should produce durable, addressable artifacts (preferably under the existing run-directory conventions or as jsonl_engine stores).

**2. An asset-oriented orchestrator that owns the DAG and lineage**

Dagster is a strong fit here because:

- Assets map cleanly onto the intermediate products and the final article/deposit model you already have in jsonl_engine.
- Materializations give you exactly the “skip if upstream unchanged” behavior the current full-job model lacks.
- Ops can still shell out to the existing PowerShell functions (or the batch-executor worker) via the same process boundary you already trust.
- You can keep batch-executor for the parallel “run stage X across these documents” cases.

LangGraph is better reserved for later agentic adjudication stages (the membrane-style repair/swarm work), not for the deterministic spine of latex-ingest.

**3. A thin “stage runner” boundary**

Something that can invoke a single stage for one document (or a small set) with frozen inputs. Then:

- The orchestrator calls the stage runner for the DAG edges.
- batch-executor can still be used when you want to fan a given stage out across many documents in isolation.

**4. Make intermediate products first-class**

Today many of the interesting structures (math store, diagram store, ref model, docstream) exist only inside the process. Lift the ones you care about into explicit files or jsonl*engine stores so the orchestrator can treat them as assets. The existing run-directory + sidecar pattern is already halfway there; it just needs to become the \_contract* rather than an afterthought.

### Practical sequencing recommendation

1. Keep using batch-executor + Get-LatexBatchJob exactly as they are for “full conversion of these documents.” That path is healthy.
2. While cleaning the poisoned code, extract the major stages behind clear function boundaries that take and return paths/artifacts instead of mutating script scope.
3. Introduce the orchestrator (Dagster assets) _on top_ that composes those stages for one document, then optionally fans the leaf stages through batch-executor.
4. Only after the stages are real assets should you invest in selective re-execution, richer lineage, or agentic nodes inside particular stages.

This keeps the good isolation and finite-batch semantics you already built, stops the current “one giant poisoned function” problem from spreading, and gives you a real pipeline language for the multi-stage workflow without having to hand-roll a scheduler or violate batch-executor’s deliberate non-goals.

cursor-latex-ingest-forensics.md

i am in the process of capturing some of the artifacts, but the pipeline itself is immature and incomplete and not every artifact is durable or what i want. i'm not going to salvage latex ingest, i want to establish the means to run the process as a pipeline and rewrite it to run under orchestration, either as an extension of batch-executor or python. i like batch-executor if i can expand the capability because i want to be able to do staged hybrid serial/parallel (batch nodes) where certain stages of the process are parallelizable and batchable , like initial latex parsing and gathering various evidence into artifacts (but new artifacts designed rather than improvised). i just got this report rundown on latex ingest process as it currently exists

Thought for 1m 4s

**You do not need to expand the core of batch-executor into a staged pipeline engine.** That would fight the design you already got right. Keep its non-goals intact (no DAG, no durable queues, no resume, no retries). Use it as the _parallel batch-node_ primitive.

What you need is a thin layer _above_ it that can express exactly the hybrid serial/parallel model you described.

### The model that matches what you want

text

Copy

```
Pipeline = ordered stages (or light DAG)
  Stage.mode = Serial | Batch

  Serial stage  → run once (or sequential units) for the current document/context
  Batch stage   → emit N independent BatchJobs → existing New-BatchPlan / Invoke-BatchPlan
```

Between stages you materialize **designed artifacts** (not script-scoped stores). Stage _N+1_ only proceeds when the required materializations from _N_ exist and match identity.

This gives you:

- Serial structure _between_ stages (S4 before S6 before S8…)
- Parallel fan-out _inside_ a stage across documents (or later across units inside one document)
- batch-executor stays the isolation and process-supervision engine for every Batch node

### How the forensic stages map

Almost every document-level stage is already parallelizable across the inventory. The serial edges are between stages, not across documents inside a stage.

| Stage                       | Parallelizable across docs? | Role in hybrid model                                        |
| --------------------------- | --------------------------- | ----------------------------------------------------------- |
| S0 Source deposit           | Yes                         | Batch node (already a clean transaction)                    |
| S1 Inventory catalog        | No (corpus-level)           | Serial, derived view                                        |
| S2 Address / plan           | Serial planner              | Produces jobs; does not convert                             |
| S3 Manifest resolve         | Yes                         | Cheap Batch node                                            |
| S4 Flatten + source patches | Yes                         | Batch node; last source-space edit                          |
| S5 Oracle + bbl prep        | Yes                         | Batch node                                                  |
| S6 Core convert             | Yes (heavy)                 | Batch node; pure(ish) transform over designed intermediates |
| S7 Persist graph evidence   | Yes                         | Batch node; run-scoped only                                 |
| S8 Figure realization       | Yes                         | Batch node; I/O + external tools                            |
| S9 Diagram render ladder    | Yes                         | Batch node; process isolation valuable                      |
| S10 Emission finalize       | Yes                         | Batch node; manuscript freeze                               |
| S11 Audits + oracle sidecar | Yes                         | Batch node; observational                                   |
| S12 Deliverable shelf       | Yes                         | Batch node; packaging                                       |

Later you can also make _intra-document_ batch nodes (e.g. fan-out individual diagram renders or figure rasters inside S8/S9). The same hybrid mechanism supports that.

### What to add (minimal surface)

1. **Designed stage I/O contracts** Replace every script-scoped store (LtxMathStore, DiagramStore, FigEnvStore, ref model, etc.) with explicit, schema-validated artifacts. Prefer:
   - jsonl_engine stores / kinds where the data is append-only or registry-like
   - or well-addressed files under the existing run-directory conventions, with a clear identity (content hash or stage digest)

   The forensic report already gives you the ownership boundaries. Treat those “Out” columns as the contracts the rewrite must honor.

2. **A thin pipeline / wave layer** Something that can:
   - declare stages with mode = Serial | Batch
   - for Batch stages, compile the work into BatchJob records and call the existing executor
   - gate later stages on the materializations of earlier ones
   - support “run this stage for one document” and “run this stage across these documents”

   This layer does **not** own isolation, process trees, write-set collision, or timeouts. Those stay in batch-executor.

3. **Stage runners** One pure-ish entrypoint per stage (or small module). Path-in / path-out (or store-in / store-out). No shared mutable script scope. This is the unit you rewrite.
4. **Language choice**
   - Pipeline composer + materialization checks: Python is the better long-term home (LLM-friendly, easy to grow into Dagster/Prefect later if needed, clean process boundary to batch-executor).
   - batch-executor itself stays PowerShell.
   - Individual stage implementations can start as thin PS wrappers or move to Python as you rewrite them. The process boundary you already use for jsonl_engine is the right pattern.

You do **not** need Dagster on day one. A small custom runner that understands Serial vs Batch stages and calls New-BatchPlan/Invoke-BatchPlan for the parallel ones is enough to get the hybrid model working. Add a real orchestrator only when the asset lineage or selective re-execution pressure becomes real.

### Rewrite posture (not salvage)

- Freeze the forensic S0–S12 contracts as the _target_ stage graph. They are already better than most green-field designs.
- Design the new intermediate artifacts first (especially the ones that currently live only in script scope inside S6).
- Rewrite vertically: pick one thin slice (e.g. S3 → S4 → S5 → a cleaned S6 transform) with durable I/O, prove the stage runner + batch-node path, then expand.
- Discard the monolithic ConvertFrom-Latex + script-scoped bus. The protect → rewrite → restore discipline is worth keeping as _internal_ structure inside the new S6, but it should no longer be the coordination mechanism across stages.

### Minimal optional extension _inside_ batch-executor (if any)

Only if it stays tiny and does not violate the non-goals:

- Optional Reads declaration on a job (plan-time existence/identity check of inputs). Everything else (stage graph, materialization, hybrid scheduling) stays outside.

That is the cleanest way to get staged hybrid serial/parallel while preserving the isolation model you already built, without salvaging the poisoned monolith, and while giving the new artifacts a designed home under jsonl_engine or explicit run addressing.

# so the orchestration layer would be able to call batch-executor to handle per-stage runspace management and serial/parallel execution

Thought for 10s

**Yes.**

The orchestration layer owns the stage graph, the Serial vs Batch decision, materialization checks, and the overall wave order. For any stage marked Batch it compiles the work into ordinary BatchJob records and hands them to the existing batch-executor surface (New-BatchPlan → Invoke-BatchPlan).

batch-executor then does exactly what it already does well:

- runspace-pool vs PowerShellProcess isolation
- worker budget / cost dispatch
- write-set collision rejection
- timeouts and process-tree teardown
- ordered results back to the caller

It never sees “stages” or the larger pipeline. It just receives a finite set of independent jobs for _this_ stage and runs them.

### Call relationship

text

Copy

```
Orchestration layer
  │
  ├─ Stage N (Serial)  → direct stage-runner call (or single-job plan)
  │
  ├─ Stage N+1 (Batch) → build N BatchJobs for the stage
  │                       └─ New-BatchPlan / Invoke-BatchPlan
  │                            └─ batch-executor handles isolation + parallelism
  │
  ├─ materialization gate
  │
  └─ Stage N+2 …
```

So:

- **Serial ordering of stages** lives in the orchestration layer.
- **Parallelism and isolation inside a parallelizable stage** is delegated to batch-executor.
- The same batch-executor machinery can later be reused for finer-grained units (e.g. individual diagram renders) if a stage decides to fan those out as their own BatchJobs.

That is the hybrid model without expanding batch-executor’s core or violating its non-goals.

should this orchestration layer be done in python, or powershell?

Thought for 11s

**Python.**

That is the clearer long-term choice for the orchestration layer itself.

### Why Python for the orchestrator

- Defining stages, contracts, materialization gates, and the Serial/Batch decision is graph-and-policy code. LLMs are markedly better at writing and iterating this in Python than in PowerShell.
- You already have a deliberate Python lane (jsonl_engine) with a clean process boundary. The orchestrator can import it directly for artifact identity, schema validation, and store operations instead of going through another adapter.
- Future growth is easier in Python: selective re-execution, richer lineage, or dropping in Dagster/Prefect assets later all sit more naturally here. You do not need those frameworks on day one, but the language choice should not close the door.
- The hybrid model does not require the orchestrator and the batch engine to share a process. The same framed/process boundary you already use for the JSONL client works in the opposite direction: Python can invoke pwsh (or a thin entrypoint) to run New-BatchPlan / Invoke-BatchPlan for every Batch-mode stage.

### What stays in PowerShell

- batch-executor itself (do not rewrite it).
- The existing adapters and any stage runners you keep in PS during the transition.
- Windows-native process supervision and the isolation model you already trust.

### Practical shape

text

Copy

```
Python orchestration layer
  - stage graph / Serial vs Batch decision
  - materialization checks (jsonl_engine or explicit paths)
  - for Batch stages → emit jobs → call batch-executor via process boundary
  - for Serial stages → call stage runner (PS or Python)

PowerShell
  - batch-executor (isolation, runspaces/processes, budgets, teardown)
  - initial stage runners (can migrate to Python later)
```

A thin PowerShell orchestration layer is technically possible and would have slightly less interop overhead, but it fights the direction you are already moving and makes the later agentic / asset-oriented work harder. Put the _policy and graph_ in Python; keep the _execution isolation_ in the batch-executor you already built.

what would this look like? a stateful class in python that owns the graph and calls batch-executor at each stage, mediating the transitions and ensuring stage's clear ?

Thought for 25s

**Yes — with one important refinement.**

It should be a _run-scoped_ stateful object (or small set of objects), not a long-lived god-class that owns global state forever. The graph itself is declarative; the runner is stateful only for the lifetime of one pipeline execution.

### Minimal shape

text

Copy

```
StageSpec          # declarative: name, mode, requires, produces, runner
PipelineSpec       # ordered stages (or light deps)
PipelineRun        # run-scoped state: run_dir, docs, materializations, results
BatchBridge        # only place that knows how to talk to batch-executor
PipelineRunner     # mediates transitions, enforces contracts
```

Stage runners stay **outside** the orchestrator. They are ordinary functions or CLI entrypoints with path-in / path-out (or store-in / store-out). The orchestrator only decides _when_ and _how_ (Serial vs Batch) to call them and then checks that the declared outputs appeared.

### Concrete illustration

Python

Copy

```
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Callable, Any
import json, subprocess

class Mode(Enum):
    SERIAL = "serial"
    BATCH  = "batch"

@dataclass(frozen=True)
class StageSpec:
    name: str
    mode: Mode
    requires: tuple[str, ...]          # logical artifact names
    produces: tuple[str, ...]
    # runner: either a Python callable(context, doc) -> dict
    # or a CLI entry that the bridge knows how to invoke
    runner: Callable | str

@dataclass
class PipelineSpec:
    stages: list[StageSpec]
    # later: optional explicit edges if you outgrow pure ordering

@dataclass
class Materialization:
    path: Path
    identity: str                      # content hash, schema+digest, etc.
    stage: str

@dataclass
class PipelineRun:
    run_dir: Path
    docs: list[dict]                   # inventory rows / article addresses
    materializations: dict[str, Materialization] = field(default_factory=dict)
    results: dict[str, Any] = field(default_factory=dict)
    failed: list[str] = field(default_factory=list)

class BatchBridge:
    """Only component that knows how to call batch-executor."""
    def __init__(self, pwsh: str = "pwsh"):
        self.pwsh = pwsh

    def invoke(self, jobs: list[dict], run_dir: Path) -> dict:
        # Write a transient job plan the PS side understands,
        # then call a thin entrypoint that does:
        #   New-BatchPlan → Invoke-BatchPlan → emit structured JSON
        plan_path = run_dir / "_batch_plan.json"
        plan_path.write_text(json.dumps(jobs), encoding="utf-8")
        proc = subprocess.run(
            [self.pwsh, "-File", "path/to/invoke-batch-stage.ps1",
             "-PlanPath", str(plan_path), "-RunDirectory", str(run_dir)],
            capture_output=True, text=True, check=False
        )
        if proc.returncode != 0:
            raise RuntimeError(proc.stderr)
        return json.loads(proc.stdout)

class PipelineRunner:
    def __init__(self, spec: PipelineSpec, bridge: BatchBridge):
        self.spec = spec
        self.bridge = bridge

    def run(self, run: PipelineRun) -> PipelineRun:
        for stage in self.spec.stages:
            self._assert_requires(stage, run)
            if self._already_materialized(stage, run):
                continue

            if stage.mode is Mode.BATCH:
                jobs = self._plan_batch_jobs(stage, run)
                outcome = self.bridge.invoke(jobs, run.run_dir)
            else:
                outcome = self._run_serial(stage, run)

            self._record_materializations(stage, run, outcome)
            if outcome.get("failed"):
                run.failed.append(stage.name)
                # policy choice: abort or continue
                break
        return run

    def _assert_requires(self, stage: StageSpec, run: PipelineRun) -> None:
        missing = [r for r in stage.requires if r not in run.materializations]
        if missing:
            raise RuntimeError(f"{stage.name} missing required: {missing}")

    def _already_materialized(self, stage: StageSpec, run: PipelineRun) -> bool:
        return all(p in run.materializations for p in stage.produces)

    def _plan_batch_jobs(self, stage: StageSpec, run: PipelineRun) -> list[dict]:
        # Turn each document + upstream materializations into a BatchJob
        # descriptor the existing Get-*-BatchJob / New-BatchJob surface understands.
        ...

    def _run_serial(self, stage: StageSpec, run: PipelineRun) -> dict:
        # Call the Python callable or a one-shot subprocess for the single unit.
        ...

    def _record_materializations(self, stage, run, outcome) -> None:
        # Verify each declared produce exists, compute identity, store it.
        ...
```

### What “stage clear” means in practice

Before a stage is allowed to run, every name in requires must already be present in the run’s materialization map with an acceptable identity.

After a stage finishes, every name in produces must exist on disk (or in a jsonl_engine store) and pass a lightweight identity/schema check. Only then is the materialization recorded and the next stage allowed to see it.

Partial or ambiguous writes are treated as failure; the stage is not considered clear.

### Important boundaries

- The PipelineRun object is stateful only for one execution. It is not a long-lived service.
- Stage logic itself does **not** live inside the runner. The runner only mediates.
- BatchBridge is the single place that knows the batch-executor contract. Everything else stays ignorant of runspaces, process trees, and worker budgets.
- You can later replace this thin runner with Dagster assets (or another orchestrator) without changing the StageSpec contracts or the stage runners.

This is enough to give you the hybrid serial/parallel behavior you want, keep batch-executor focused on isolation, and leave a clean path to richer lineage later.

# what about incorporating a session-like concept so i don't have to constantly launch sub-processes above batch executor. like the orchestrator class would be interacting with a batch-executor repl is what im imagining

Thought for 20s

**Yes — a run-scoped session is the right idea.** Do not make every Batch stage cold-start a new pwsh process. Do not turn batch-executor itself into a long-lived daemon either. Put a thin host _around_ it.

### Recommended shape

text

Copy

```
Python                          PowerShell
──────                          ──────────
PipelineRunner
  └─ BatchSession  ──────────►  batch-executor-session.ps1
       (start once)                  │
       (send plan/invoke)            ├─ Import-Module batch-executor  (once)
       (receive results)             ├─ keep runspace pool warm if desired
       (shutdown)                    └─ framed JSON command loop
```

The session lives for the lifetime of one PipelineRun. All Batch stages inside that run talk to the same PowerShell process. When the pipeline finishes (or fails), the session is torn down. This avoids cross-run state leakage while eliminating repeated process launch + module import cost.

### Protocol (mirrors the jsonl_engine pattern you already like)

Simple framed JSON over stdin/stdout:

text

Copy

```
→ {"cmd":"plan",  "jobs":[...], "options":{...}}
← {"ok":true, "plan_id":"...", "errors":[]}

→ {"cmd":"invoke","plan_id":"...", "max_workers":...}
← {"ok":true, "results":[...], "summary":{...}}

→ {"cmd":"shutdown"}
← {"ok":true}
```

The host script is deliberately thin: load the module once, accept commands, call the existing New-BatchPlan / Invoke-BatchPlan, emit structured results, exit cleanly. batch-executor’s public surface and isolation model stay unchanged.

### Why run-scoped rather than a forever REPL

- Runspace pools, process registries, and cancellation tokens are easier to reason about when they die with the pipeline.
- You still get the win you care about: one process launch per _pipeline_, not per _stage_.
- Crash recovery is simple — the next pipeline just starts a fresh session.
- A longer-lived machine daemon can be added later if startup cost is still measurable; it is not required for the hybrid model.

### What this does _not_ change

- Stages still declare Serial vs Batch.
- Batch stages still become ordinary BatchJob records.
- Process-mode jobs inside a stage still get real process isolation when you ask for it.
- The orchestrator still owns materialization gates and stage ordering.

### Practical consequence for the earlier sketch

BatchBridge becomes (or gains) a BatchSession:

Python

Copy

```
class BatchSession:
    def __init__(self, pwsh="pwsh"):
        self._proc = None

    def __enter__(self):
        self._proc = subprocess.Popen(
            [pwsh, "-File", "batch-executor-session.ps1"],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True
        )
        return self

    def plan_and_invoke(self, jobs, options) -> dict:
        self._send({"cmd": "plan", "jobs": jobs, "options": options})
        plan = self._recv()
        self._send({"cmd": "invoke", "plan_id": plan["plan_id"], **options})
        return self._recv()

    def __exit__(self, *exc):
        self._send({"cmd": "shutdown"})
        self._proc.wait()
```

PipelineRunner.run then looks like:

Python

Copy

```
with BatchSession() as session:
    for stage in self.spec.stages:
        ...
        if stage.mode is Mode.BATCH:
            outcome = session.plan_and_invoke(jobs, options)
        else:
            outcome = self._run_serial(stage, run)
        ...
```

That is the clean incorporation of a session-like concept: the orchestrator interacts with a short-lived batch-executor host for the duration of the pipeline, not with a cold process per stage and not with a permanent global REPL.
