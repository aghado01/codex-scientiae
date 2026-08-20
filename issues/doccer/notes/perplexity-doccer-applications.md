# @GitHub in codex-scientiae, which is a combination of python, typescript and C\#, there's the C\# `doccer` that's getting close to publishable i think

You just asked this and I read the full `doccer` README. Based on what's actually in the repo:

The engine is **already publishable** in the library sense—D47 closed K7, 2,751 harness checks pass against the delivered assembly, the build pipeline produces a manifest-verified package, and the governing doctrine (47 decisions, a status registry, a roadmap, and a completed-item ledger) is thoroughly documented.

The one honest gap before a public repo release is the **CLI module**, which is explicitly deferred under `sol-doccer-cli-module-deferred-20260809_180623.md`. The README describes current `brewery` commands as developer diagnostics rather than the committed public CLI surface. Everything else—the capability library, the declarative engine, the build/publish/smoke-test pipeline, and the contract documentation—reads as release-quality already.

So the graduation question is really just: does the first public release ship as a **library** (in which case it's essentially ready now), or does it wait for the CLI contract to close? The README's own framing—"a committed separate public CLI module projects those public contracts across a process boundary"—suggests the CLI was always intended to be the graduation artifact rather than a nice-to-have. Is the CLI deferral a temporary hold pending a concrete consumer to settle its contract shapes, or is it blocking you from calling it done?

---

# i suppose nothing is stopping me from moving it to its own repo now, but before publishing i want to flesh out the bitmap lineage and expand the interval engine to incorporate some ideas related to hybrid intervals i found recently, plus some demonstrated applications of the library

That sounds like the correct release boundary: **extract it now for architectural independence, but publish it only after the next coherent capability set closes.** `doccer` already has a separately buildable library/CLI/test layout and a delivery manifest, so extraction does not require pretending the public surface is finished.

## Why those additions fit

The bitmap-lineage work is not scope creep relative to `doccer`; it completes an existing declared seam. The README deliberately separates a geometry `SpanSet`, an occurrence-level `ClaimSelection`, and the newer basisless `BooleanVector` plus master/window-specific `Utf16UnitMask`; it explicitly defers suppression bitmaps as a later vector-backed acceleration whose result must remain exactly equivalent to the reference selection/coverage behavior.

Similarly, extending the interval engine with hybrid-interval ideas is directly native to the project rather than a bolt-on feature. `doccer` already treats carriers as many-sorted—valid master boundaries, located extents including diagonal empties, nonempty Allen intervals, claim occurrences, facts, origins, Boolean vectors, and UTF-16 masks—and refuses to collapse them into one universal span type. Allen-style interval algebra itself supplies thirteen exhaustive qualitative relations and a composition table; its computational boundaries are substantive enough that the tractable fragments have been formally characterized.[^18_1][^18_2]

## A good release shape

I would define the first public `doccer` release around three promises:

1. **Exact interval and span infrastructure** — explicit carrier boundaries, identity-safe coordinate spaces, Unicode/UTF-16 correctness, relation algebra, selections, and deterministic structural operations.
2. **Traceable structural transformation** — origin relations and materialization that retain output-to-source evidence rather than treating text rewriting as an opaque operation.
3. **Reference-first bitmap/vector implementation** — a straightforward correct vector/mask path and lineage model, with performance backends allowed only when they prove equivalence to that semantic reference.

The README already gives this a principled admission rule: new kernel features must be deterministic, remove repeated mechanical work, preserve literal source material, and decide nothing about meaning. Bitmap lineage and a hybrid interval carrier can be admitted or rejected against that test rather than merely because they are interesting.

## Applications matter

Demonstrated applications are the missing public-facing bridge—not because the kernel requires a consumer to be legitimate, but because potential users need to see what its abstractions buy them. The README explicitly says a consumer may prioritize and validate a contract but never authorizes it.

For release, three narrowly scoped examples could make the engine immediately legible:

| Application                                   | What it demonstrates                                                                                        |
| :-------------------------------------------- | :---------------------------------------------------------------------------------------------------------- |
| **Structure-aware Markdown/LaTeX extraction** | Scoped collection, interval relations, nested/laminar structure, and source coordinates                     |
| **Text rewrite with audit trail**             | `RewritePlan`, exact materialization, output-to-source origins, synthetic pieces, and unused-source residue |
| **Unicode classification or masked scanning** | `Utf16UnitMask`, topology-atom harvest, scalar/surrogate edge cases, and bitmap lineage                     |

Those do not redefine `doccer` as a Markdown, TeX, or document-processing framework. They are adapters/examples around the domain-neutral engine—exactly the boundary the README already specifies.

The strongest public release would therefore be “**Doccer 0.1: interval algebra, provenance-preserving transformations, and evidence-bearing text structure**,” accompanied by those examples and an explicit statement of what remains intentionally out of scope.
<span style="display:none">[^18_10][^18_11][^18_12][^18_13][^18_14][^18_15][^18_3][^18_4][^18_5][^18_6][^18_7][^18_8][^18_9]</span>

<div align="center">⁂</div>

[^18_1]: https://qsrlib.readthedocs.io/en/latest/rsts/handwritten/qsrs/allen.html

[^18_2]: https://ora.ox.ac.uk/objects/uuid:5715f250-94b2-451e-b480-68b8997a7b96

[^18_3]: https://www.sciencedirect.com/science/article/pii/S016800722200080X

[^18_4]: https://www.youtube.com/watch?v=UpwK8hhDBJ8

[^18_5]: https://montecarlo.ai/blog-data-provenance-vs-data-lineage-difference

[^18_6]: https://en.wikipedia.org/wiki/Allen's_interval_algebra

[^18_7]: https://www.emergentmind.com/topics/allen-s-interval-algebra

[^18_8]: https://www.nightfall.ai/ai-security-101/data-provenance-and-lineage

[^18_9]: https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.TIME.2017.16

[^18_10]: https://www.ibm.com/think/topics/data-lineage

[^18_11]: https://www.ics.uci.edu/~alspaugh/cls/shr/allen.html

[^18_12]: https://www.snowflake.com/en/data-governance/data-lineage/data-provenance/

[^18_13]: https://en.wikipedia.org/wiki/Data_lineage

[^18_14]: https://scsynth.org/t/interval-algebra-and-event-scheduling/9233

[^18_15]: https://datahub.com/blog/data-lineage-vs-data-provenance/

---

# what, if any, applications of doccer or a more developed doccer, would be high-leverage for research engineer candidacy at a frontier lab?

The highest-leverage use of `doccer` is not “document parsing.” It is an **evidence-preserving substrate for agent evaluation and transformation**: make every region an explicit object, every selection policy named, and every generated or modified output traceable to exact source material.

That aligns closely with the work frontier labs currently advertise: designing evaluations of reasoning, agentic behavior, knowledge, and safety; making results interpretable to researchers; and building reliable evaluation infrastructure at scale. Your experimental-design, latent-state modeling, production-pipeline, and model-audit background is unusually compatible with that evidence-and-measurement layer.[^19_1][^19_2]

## Best flagship: traceable agent evals

Build a **Document-Transformation Agent Evaluation Kit** on `doccer`.

An agent receives structured source material—Markdown/LaTeX specifications, a codebase policy document, scientific protocols, or a corpus of mixed text—and must extract, transform, reconcile, or generate a structured deliverable. The evaluator uses `doccer` to score not merely exact text match, but the relationship between source, claimed support, output, and residue.

`doccer` already supplies most of the right primitives:

- `ClaimSelection` preserves occurrence identity; it is not just a bag of matching spans.
- `OriginRelation` is explicit, partial, and many-to-many.
- `RewritePlan` and materialization distinguish exact copies, origin-mapped literal output, and explained synthetic content.
- Unused-source residue stays visible rather than being silently discarded.

That gives you metrics such as:

| Metric                           | Question answered                                                                       |
| :------------------------------- | :-------------------------------------------------------------------------------------- |
| **Grounded coverage**            | Which required source regions were represented in the output?                           |
| **Unsupported-output rate**      | Which output spans lack a source-origin relation or a declared synthetic rationale?     |
| **Deletion/residue rate**        | What eligible source material was omitted, under a named scope and policy?              |
| **Faithful transformation rate** | Where output claims match exactly mapped source versus altered or synthesized material? |
| **Structural integrity**         | Did the agent preserve required containment, pairing, ordering, and interval relations? |
| **Uncertainty boundary quality** | Does the model preserve unresolved/ambiguous material rather than invent a resolution?  |

This is stronger than string-similarity scoring because it makes the evaluator’s assumptions inspectable. It also lets you test model behavior under controlled perturbations: move a qualifying clause, create nested exceptions, insert distractor text, alter Unicode or formatting boundaries, or create adversarially overlapping evidence. That is a credible agentic-reasoning and reliability evaluation—not a parsing demo.

OpenAI's Codex research-engineering role explicitly emphasizes building evaluations and environments that expose failures, then turning those failures into training data, product fixes, or research directions. This project would demonstrate the whole loop.[^19_3]

## Second: context provenance

A related and possibly cleaner application is an **agent-context provenance ledger** for RAG and tool-using agents.

The question is:

> Given the exact bounded context supplied to an agent, which evidence did it use, what did it omit, and which portions of its answer were actually supported?

Treat retrieved context chunks as source masters, represent their relevant portions as selected intervals, and map answer spans back through `OriginRelation` where a system can establish support. Preserve an explicit “synthetic/unattributed” category rather than pretending all answers are extractive.

This speaks directly to an evaluator’s daily problems:

- Context-window selection and loss
- Citation and attribution faithfulness
- Long-context retrieval failures
- Conflicting sources and exception handling
- Agent state that silently drifts away from its evidence

It connects naturally to your `para-agent` work: `para-agent` already keeps separate console and semantic-transcript evidence systems, records exact ingress text, and relies on receiver-authoritative correlated native events rather than inferring dialogues from console activity. `doccer` could become the region-level structural and provenance calculus underneath a benchmark—or an analysis tool—for those traces.

## Third: adversarial spec-following

Create a **specification-compliance benchmark generator and evaluator** for coding agents.

`doccer` parses a compact natural-language or Markdown spec into explicitly scoped obligations, exceptions, definitions, and dependencies. It then produces controlled variants that preserve intended semantics while changing interval structure:

- Move an exception from local to global scope
- Nest exceptions inside another requirement
- Create cross-references and delayed definitions
- Add mutually compatible vs. contradictory requirements
- Separate lexical proximity from actual containment
- Insert visually similar Unicode or malformed-surrogate cases
- Vary formatting without changing the logical structure

Then evaluate a coding agent’s implementation or critique against the original named obligations. This is potentially high impact because “agent followed most of the prompt” is not an adequate measurement when one exception invalidates a deployment.

The project would use hybrid intervals for something visibly useful: combining exact character geometry, nested document structure, logical scope, and potentially discontiguous obligations without collapsing them into one vague “span” abstraction. `doccer`’s existing distinction between compatible geometry and exact identity makes that especially defensible.

## Fourth: scientific extraction

A more direct AI-for-science application is a **methods-and-evidence extraction evaluation** for research papers: identify experimental entities, procedures, constraints, variables, result statements, and evidence windows; then measure source coverage and unsupported synthesis in a model-generated structured protocol or study card.

This fits your systems-neuroscience training and makes a good demonstrator, but I would rank it below agent evals because it risks being read as a familiar “LLM paper extraction” project. Its differentiator must be the **auditability**: exact source coordinates, named extraction policies, conflict/residue reporting, and output-to-source lineage—not the extraction task alone. Your own research background gives you unusual credibility in defining what counts as a valid method/result extraction.

## What not to lead with

Do not use these as the flagship:

- **A generic interval-algebra library.** It proves rigor, but a recruiter may not connect it to model behavior or research impact.
- **Markdown parsing/navigation alone.** Useful infrastructure, but it undersells `doccer`'s claim/fact/origin machinery.
- **A generic RAG “citation checker.”** Crowded category unless it genuinely handles structural scope, competing evidence, and transformation lineage.
- **Hybrid intervals as the project’s headline.** Make hybrid intervals an enabling technical novelty with a necessary role in the benchmark, not the reason a lab should care.

## A concise portfolio claim

The strongest artifact would let you say:

> Built an evidence-preserving evaluation substrate for tool-using language agents: it represents source structure and scope explicitly, evaluates transformation completeness and support, and traces generated artifacts back to exact input regions while reporting unresolved and synthetic residue.

Then prove it with one benchmark, a baseline scoring scheme, failure cases across at least two frontier models, reproducible fixtures, and an analysis report explaining what the metric detects that exact match, ROUGE-style overlap, or naïve citation presence does not.

That is legible as evaluation infrastructure—precisely the intersection of experimental design, trustworthy data systems, model-behavior analysis, and tool-using agents that current frontier-lab research-engineering roles call for.[^19_1][^19_4][^19_3]
<span style="display:none">[^19_10][^19_11][^19_12][^19_13][^19_14][^19_15][^19_5][^19_6][^19_7][^19_8][^19_9]</span>

<div align="center">⁂</div>

[^19_1]: http://job-boards.greenhouse.io/anthropic/jobs/5198255008

[^19_2]: https://www.linkedin.com/jobs/view/research-engineer-model-evaluations-at-anthropic-4437905316

[^19_3]: https://openai.com/careers/research-engineer-codex-san-francisco/

[^19_4]: https://openai.com/careers/research-engineer-frontier-evals-and-environments-san-francisco/

[^19_5]: https://deepmind.google/careers/

[^19_6]: https://www.anthropic.com/careers/jobs

[^19_7]: https://jobs.generalcatalyst.com/companies/anthropic/jobs/77273572-research-engineer-model-evaluations

[^19_8]: https://www.builtinsf.com/job/research-engineer-frontier-evals-finance/7009777

[^19_9]: https://builtin.com/job/senior-research-engineering-manager-ai-agents-google-deepmind/4424077

[^19_10]: https://jobs.lionheart.vc/companies/anthropic/jobs/36601312-research-engineer-model-evaluations

[^19_11]: https://www.linkedin.com/jobs/view/research-engineer-frontier-evals-environments-at-openai-4417168169

[^19_12]: https://jobs.technyc.org/companies/google-24698/jobs/89985491-research-engineer-conversational-agentic-ai-deepmind

[^19_13]: https://talent.thecolorwave.org/companies/anthropic/jobs/62065801-research-engineer-model-evaluations

[^19_14]: https://openai.com/careers/agent-post-training-frontier-evals-and-environments-research-san-francisco/

[^19_15]: https://www.mediabistro.com/jobs/3541965445-research-engineer-embodied-agents-deepmind

---

# i'm not going to be interacting with recruiters. high-signal work goes straight to the company careers page

Right—the audience is the **hiring team reading an official application**, not a recruiter needing a simplified pitch. That changes the target.

High-signal work should let a research engineer, evaluator, or research scientist immediately inspect your judgment: the problem formulation, the invariants, the experiment, the negative results, and what the artifact makes possible. Anthropic’s model-evaluations role explicitly centers on defining what to measure, running evaluations across checkpoints, interpreting results with researchers, and building infrastructure that runs reliably at scale. OpenAI’s evaluation and Codex-oriented roles similarly emphasize environments that expose model failures and convert them into training data, product fixes, or research directions.[^20_1][^20_2][^20_3]

## Make Doccer research evidence

So the right `doccer` artifact is not a job-market demo or a recruiter-friendly story. It is a small but serious **research-engineering contribution**:

> A provenance-aware structural evaluation substrate for measuring whether an agent preserves scope, evidence, constraints, and source coverage while transforming long structured documents.

That would be valuable even if no one hired you. The application simply makes it easy for the relevant people to find and assess.

Its central claim should be falsifiable:

> Exact-match and citation-presence metrics fail to distinguish structurally unsupported, scope-violating, or incompletely grounded agent outputs; explicit interval structure plus output-to-source lineage detects these failure classes.

Then supply a reproducible benchmark suite, baseline methods, adversarial fixtures, model runs, and an analysis of error modes. `doccer` already has the raw substrate: immutable UTF-16 text masters; separate geometry, occurrence, semantic-fact, origin, and materialization carriers; exact source-origin relations; and explicit unused-source residue.

## Direct applications

Three applications would be genuinely relevant to frontier-lab teams:

| Artifact                                 | Research question                                                                                                     | Why it is signal                                                                                   |
| :--------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------- |
| **Long-context specification following** | Can an agent honor nested constraints, exceptions, and delayed definitions over a document?                           | Tests a real agent failure mode; structure and scope are the target rather than surface similarity |
| **Grounded transformation evaluation**   | Does an agent-produced brief, plan, extraction, or rewrite account for source material without unsupported additions? | Measures completeness, attribution, and synthesis explicitly                                       |
| **Context selection audit**              | Which source regions were made available, used, omitted, or distorted across a tool-using agent trajectory?           | Directly applies to RAG, agent memory, retrieval, and tool-mediated research workflows             |

The third overlaps with OpenAI’s stated retrieval/search research interests in document, enterprise, knowledge, and web-scale search.[^20_4]

## What to submit

In the official application, lead with the specific research artifact—not “my GitHub” and not “I built a C\# library.”

- **Repository:** `doccer`, with one runnable evaluation package and pinned fixtures.
- **Technical note:** 4–8 pages: problem, formal representation, benchmark construction, baselines, results, error taxonomy, limits, and next experiments.
- **One results figure:** e.g., compare exact match / citation presence / `doccer` structural scoring on a compact set of controlled scope-and-exception failures.
- **Reproducibility:** one command to build and run tests, one command to reproduce benchmark tables; the existing delivered-artifact manifest is already a strong foundation.
- **Application link and one sentence:** “I built a provenance-aware structural evaluation framework for identifying scope, evidence-coverage, and transformation-lineage failures in long-context agents; code and experiments: [link].”

That is the kind of material a technically sophisticated reviewer can choose to open. They need not take your broader systems orientation on faith.

## Do not dilute it

You can still publish the full domain-neutral library with bitmap lineage, hybrid intervals, and several examples. But the frontier-lab-facing work should select **one research claim and one evaluation** from that larger capability.

The lab does not need to agree that `doccer` is the final general-purpose text substrate. It only needs to see that you recognized a hard measurement blind spot, constructed an unusually careful apparatus, ran an honest experiment, and created a reusable tool others can extend. That is high-signal research engineering.
<span style="display:none">[^20_10][^20_11][^20_12][^20_13][^20_14][^20_15][^20_16][^20_17][^20_5][^20_6][^20_7][^20_8][^20_9]</span>

<div align="center">⁂</div>

[^20_1]: http://job-boards.greenhouse.io/anthropic/jobs/5198255008

[^20_2]: https://openai.com/careers/research-engineer-codex-san-francisco/

[^20_3]: https://openai.com/careers/research-engineer-frontier-evals-and-environments-san-francisco/

[^20_4]: https://openai.com/careers/research-engineer-retrieval-and-search-applied-engineering-san-francisco/

[^20_5]: https://openai.com/careers/

[^20_6]: https://deepmind.google/careers/

[^20_7]: https://jobs.lionheart.vc/companies/anthropic/jobs/36601312-research-engineer-model-evaluations

[^20_8]: https://jobs.generalcatalyst.com/companies/anthropic/jobs/77273572-research-engineer-model-evaluations

[^20_9]: https://jobs.ashbyhq.com/openai/240d459b-696d-43eb-8497-fab3e56ecd9b

[^20_10]: https://www.linkedin.com/jobs/view/research-scientist-verified-code-generation-deepmind-at-google-deepmind-4429695044

[^20_11]: https://www.linkedin.com/jobs/view/research-engineer-model-evaluations-at-anthropic-4437905316

[^20_12]: https://openai.com/careers/research-engineer-san-francisco/

[^20_13]: http://job-boards.greenhouse.io/deepmind/jobs/7339890

[^20_14]: https://jobs.menlovc.com/companies/anthropic/jobs/62340779-research-engineer-model-evaluations

[^20_15]: https://builtin.com/job/portfolio-lead-google-deepmind-impact-accelerator/6801410

[^20_16]: https://www.sundeepteki.org/advice/anthropic-research-engineer-interview-2026

[^20_17]: https://www.linkedin.com/jobs/view/research-engineer-retrieval-search-applied-engineering-at-openai-4417168182

---

# now look again at codex-scientiae more broadly, because its all about optimizing dense technical knowledge, particularly from papers that are released recently and after model training cut-offs, but more generally as an engine for converting corpora into mathematically faithful highly token optimized markdown transfers. and `science-facility/mdnav_v2` is a "reader" MCP that applies doccer concepts in a more lightweight, focused form to improve comprehension and mitigate things like recency bias, middle amnesia and confabulation on large and/or technically dense documents such as those that would be produced by codex-scientiae tech

Yes—that is a materially different and much more coherent picture than the one I kept reducing to “a doccer-based eval.” I was separating pieces that are designed to form a pipeline.

`codex-scientiae` is the **writer/compiler side**: ingest recent and otherwise model-unavailable technical knowledge, preserve its mathematical/technical content, then transform it into compact Markdown transfer artifacts optimized for a model’s context budget. `mdnav_v2` is the **reader side**: a focused MCP that helps the model navigate, select, order, and re-expose the structural units of those artifacts so that dense material remains usable rather than becoming a large undifferentiated prompt. The cryptocodec/TED work is a prospective **transport optimization layer** within the same broader problem: maximize usable technical knowledge conveyed per model-context token, while retaining a recoverable representation.[^21_1][^21_2]

## The actual system

A better abstract pipeline is:

$$
\text{recent technical corpus}
\;\xrightarrow{\text{ingestion + extraction}}\;
\text{faithful structured representation}
\;\xrightarrow{\text{selection + compilation}}\;
\text{dense Markdown transfer}
\;\xrightarrow{\text{mdnav\_v2}}\;
\text{bounded, ordered reading actions}
\;\xrightarrow{\text{model}}\;
\text{grounded technical reasoning}.
$$

`doccer` supplies the general structural substrate beneath parts of this: identity-safe text coordinate spaces; intervals and relations; occurrence-level claims; selection; structural grouping; facts and support; source-to-output origins; and materialization with explicit source residue. Its design expressly keeps semantic judgment outside the engine while preserving the evidence needed for a caller to make such judgments.

So the intended division is not:

- `doccer` = standalone document tool
- `mdnav_v2` = generic Markdown search
- `codex-scientiae` = unrelated corpus utilities

It is:

| Layer                      | Job                                                                                                                            |
| :------------------------- | :----------------------------------------------------------------------------------------------------------------------------- |
| **`codex-scientiae`**      | Compile heterogeneous technical source material into compact, mathematically faithful, model-usable artifacts                  |
| **`doccer`**               | Provide precise structural/addressing, selection, lineage, and transformation primitives where full rigor is warranted         |
| **`mdnav_v2`**             | Act as the model’s active reader: provide bounded, structure-sensitive access and reading order over large dense artifacts     |
| **cryptocodec / TED work** | Explore whether representation and transport can further reduce context cost without losing recoverability or interpretability |

The codec work’s stated objective is explicitly an LLM-facing representation: collision-free alphabet construction, modular pattern discovery, TED-aware token assignment, and a manifest format intended for in-place, on-the-fly interpretation rather than a separate conventional decode step. That is the same overall concern as the rest of the system—communication to a bounded model—not a separate cryptography hobby.[^21_2]

## Why the reader matters

The reader is not merely a convenience after compression. A dense transfer representation can be technically faithful yet still fail if the receiving model allocates attention poorly.

The relevant failure modes you named are architectural:

- **Recency bias:** late sections disproportionately shape the response.
- **Middle amnesia:** material in the middle of a long context is weakly retrieved or integrated.
- **Confabulation under partial retrieval:** the model bridges omitted premises with plausible but unsupported content.
- **Loss of dependency structure:** a theorem, definition, qualification, or assumption is read without the nearby material that makes it valid.
- **Token-budget misallocation:** low-value prose consumes space that should preserve definitions, equations, boundary conditions, and results.

`mdnav_v2` is therefore a reading-control mechanism: it can present document structure, select locally sufficient neighborhoods, return context with explicit coverage boundaries, and make deferred material retrievable rather than silently absent. That is philosophically aligned with `doccer`’s insistence that queries execute named policies and retain evidence, rather than having the representation pre-resolve what matters.

## The frontier-lab application

The high-leverage artifact is broader than an evaluation kit:

> **A system for compiling post-cutoff scientific and technical corpora into mathematically faithful, context-efficient transfer representations, together with an agentic reader that supports reliable bounded-context comprehension.**

That touches a central frontier-lab problem: models cannot have weights continuously updated for every newly released paper, internal document, experiment log, software artifact, or evolving technical specification. The practical question is how to make new knowledge available at inference time without reducing it to lossy summaries or throwing raw, poorly structured documents into context.

OpenAI currently frames retrieval/search work around document, enterprise, knowledge, and web-scale search, while its research-engineering roles emphasize environments and evaluations that expose failures and improve systems. Your system offers a distinctive research-engineering angle: **the retrieval unit is not just a chunk; it is a structurally located, provenance-bearing piece of a technical argument or artifact.**[^21_3][^21_4]

## A concrete research program

The most compelling first study would test three conditions against a corpus of recent technical papers or technical specifications:

1. **Raw-document baseline** — provide papers in ordinary extracted Markdown/PDF text.
2. **Standard RAG baseline** — chunk, embed, retrieve top-$k$, and answer.
3. **Compiled-transfer + active-reader condition** — use `codex-scientiae` to create mathematically faithful dense transfer artifacts and let `mdnav_v2` control structured retrieval/reading.

The tasks should require dependencies—not simple fact lookup:

- Reconstruct a method with its assumptions and constraints
- Explain an equation and identify the definition it depends on
- Compare two related but nonidentical results
- Identify a limitation, exception, or missing premise
- Propose an experiment or implementation that obeys the source’s stated conditions
- Distinguish what the paper establishes from a plausible extrapolation

Then measure:

$$
\text{task quality},\quad
\text{source-groundedness},\quad
\text{context tokens consumed},\quad
\text{missing-premise errors},\quad
\text{unsupported assertions}.
$$

That turns the whole project into a testable claim about **knowledge transfer under context constraints**, not merely a collection of sophisticated infrastructure.

## Doccer’s role, properly placed

A more developed `doccer` becomes especially valuable where the writer and reader must agree on structural truth:

- Source spans and their transformed compiled representations
- Mathematical expression boundaries and definition-use dependencies
- Nested scope, exceptions, qualifications, and cross-references
- Exact lineage from compressed/normalized Markdown back to paper text
- Coverage and residue: what entered the compiled transfer, what was intentionally deferred, and what did not survive a transformation

Its K6/K7 origin and materialization layers already encode the right intellectual posture: output is related back to exact source slots; origins can be partial and many-to-many; synthetic literals are explicit; and unused source residue remains reported rather than being reclassified as nonexistent.

That is unusually well suited to a system whose core promise is **mathematical faithfulness despite aggressive context optimization**. The hard question is not whether a model can retrieve strings that look relevant. It is whether the compiled artifact and its reading trajectory preserve the conditions required to reason correctly from recently acquired technical knowledge.
<span style="display:none">[^21_5][^21_6][^21_7]</span>

<div align="center">⁂</div>

[^21_1]: isomorphic-encoder-and-TED-2.md

[^21_2]: cryptocodec.psm1

[^21_3]: https://openai.com/careers/research-engineer-retrieval-and-search-applied-engineering-san-francisco/

[^21_4]: https://openai.com/careers/research-engineer-codex-san-francisco/

[^21_5]: perplexity-TED-byte-size-vs-context-window-bandwidth.md

[^21_6]: StructuralSegmentation-2.psm1

[^21_7]: IsomorphicEncoding_20251106_225158-3.json
