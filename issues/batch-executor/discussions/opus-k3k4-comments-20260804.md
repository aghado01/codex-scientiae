Good question — and the answer is shaped by a decision you already have. Let me verify the correlation seam that's already built.

Yes — and the shape is already fixed by a decision you have. Infrastructure **D3** (accepted) says _run identity and artifact placement come from the caller_. Combined with batch-executor D8 and sequencing rule 3, that means the adapter should **accept** run context, never construct it. So the placeholder is a **parameter**, not a stub implementation — and parameters don't get deleted later, they just start receiving a richer object.

The two halves are at very different maturity, which is easy to miss.

## Correlation isn't a placeholder — it's already built

`CODEX_BATCH_JOB_ID` and `CODEX_BATCH_EXECUTION_MODE=Process` are injected per child, and `CODEX_RUNLOG_*` is inherited unless overridden. The adapter's entire obligation here is **don't invent a second correlation scheme**. When run-context lands, it becomes the thing that _sets_ `CODEX_RUNLOG_*` in the parent — executor and adapter code don't change at all.

Worth promoting that from a README implementation note to a stated contract, because it's the seam, and right now it reads as a convenience feature rather than the thing infrastructure will plug into.

## Addressing is the real placeholder

Four moves make it safe:

**1. `-RunContext` as a required parameter, duck-typed on the minimum the adapter reads** — an id and a root. Today the caller passes `[pscustomobject]@{ Id = …; Root = … }`; later infrastructure passes the real record carrying those members plus more. Adapter code is byte-identical across that transition.

**2. Exactly one resolver.** The risk was never the placeholder — it's the placeholder's assumptions leaking into forty call sites. One private function computes every per-job result/log path; everything else calls it. When run-context lands you replace that one body with a delegation. This is the same shape as D13's payload boundary and the legacy jsonl single-write-chokepoint, so it's already the house pattern.

**3. Guard it with a structural witness.** Assert that path composition for result/log locations appears nowhere in the adapter outside the resolver — the same trick as the AST test that just landed on the orchestrator, which is the cheapest enforcement available and you've already proven it works here.

**4. Make it loud.** The resolver stamps a marker so runs made under placeholder addressing are identifiable afterward. Precedent: `latex-ingest-compat.ps1` warns on bypass and labels it `compat-*`, "never represented as a compliant deposit." A provisional address should never look like a settled one.

## What not to placeholder

This is the boundary that matters:

- **Don't placeholder run allocation.** D3 says the caller supplies it. If the adapter mints a runstamp, it has made an infrastructure decision — and that one _is_ expensive to unwind.
- **Don't placeholder result persistence.** If BEX-401 writes results as JSONL with an invented schema, it collides head-on with the store-kind work (infrastructure D23: every store kind defines identity, schema, and canonical order). Results stay in the returned execution record; durable writing stays inside the already-deferred "persistent job/result stores" candidate.

So: **placeholder the addressing input, never the persistence output.** Inputs converge for free when the real type arrives; output formats become compatibility problems with migration costs.

## The part that makes this the exhibit

Give each placeholder a row in a small table in the batch-executor canon — what the adapter needs, what supplies it provisionally, what's expected from infrastructure. That table _is_ the requirements list infrastructure inherits when it unblocks, and it's the difference between a placeholder and debt: this one is generating the specification rather than deferring it.

It also answers the deferred-candidates annotation I raised — "persistent job/result stores" would be the first row.

Want me to draft that decision row and the requirements table? It's small, and it'd give BEX-401 a stated contract to build against rather than one to infer.
