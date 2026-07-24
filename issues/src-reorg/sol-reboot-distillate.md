# Sol reboot corpus — adjudicated distillate

**Status:** distillate · **Produced:** 2026-07-23 by Claude (Fable 5), full end-to-end read
**Sources:** [sol-reboot-brainstorming.md](./sol-reboot-brainstorming.md) (25.6k lines; dialogue read in full via tool-transcript-stripped copy),
[sol-inverse-framing.md](../sol-inverse-framing.md) (full), [sol-opendataloader-vs-minerU.md](../sol-opendataloader-vs-minerU.md) (consulted via its thread summary + turn-19 code-receipt discussion; stands as the mechanism-level reference, not renoised here).
**Anchor convention:** user turns numbered in thread order; quotes are verbatim fragments grep-able in the source thread. Epistemic status marked per claim: **[observed]** (in the text), **[inferred]** (my adjudication), **[open]** (not settled by the corpus).

---

## 1. The trajectory — your line of thinking, in order

Your 20 turns decompose into three phases. The replies were mixed-bag throughout; the
course was set by your corrections and generative moves.

### Phase A — identity-finding (turns 1–6)

1. **T1** — commission: deep-dive ODL-pdf, cross-examine vs MinerU ("they break the problem down differently").
2. **T2** — "shares aspects of both… leaning much more heavily into clustering and potentially some decision-tree methods."
3. **T3 (corrective)** — rejected Sol's architecture-charter framing: "I'm not satisfied with this architecture, its still too nebulous. I want to focus on identifying my breakdown of the problem." → pivoted the whole thread from system-shape to problem-catalog. **[observed]**
4. **T4 (corrective, generative)** — "No the idea i had for isolation forest was to actually apply it to cluster labeled data in order to refine discovery along some given set of axes" → the **cluster-conditioned refinement operator** (Refine). Sol had misread IF as an upstream anomaly filter; your version is the one that survived. **[observed]**
5. **T5** — sanity check ("i thought isolation forest was unsupervised?") → confirmed: labels select the fit population, never targets.
6. **T6 (generative)** — outlier-**modes** within clusters, "across clusters, and even different clusterings… some kind of consensus or reconciliation" → multi-view evidence accumulation, co-association graph, agent receives genuine conflicts. **[observed]**

### Phase B — the contract and the flow (turns 7–15)

7. **T7 (generative, pivotal)** — the synthesis turn: borrow evidence-gathering/deterministic parsing/IR assembly from both systems; target a **JSONL IR schema-identical to the LaTeX converter's output** for fidelity measurement; the whole challenge framed as **inverse manuscript recovery** (PDF as surjection onto a canonical manuscript envelope); reading order as part of the inverse's definition, "opinionated at times"; and **rejection of page-by-page decomposition** — "I want to start from whole-document clustering… roles of fonts and style cues… should generally be internally consistent." **[observed]**
8. **T8** — IR staging confirmed: preliminary IRs vs **final IR one step from markdown**; final IR exists *because* the LaTeX twin makes the same inverse problem "much more tractable and well defined, not even really needing a reasoning model"; "the crux of my new gauntlet development loop"; markdown = implementation detail. **[observed]**
9. **T9 (generative)** — coarse **anchor-and-interval** granularity: headings + contiguous body spans + figure interruptions; "makes the alignment easier because I can get this more reliably in PDF and its easy in latex." Removes paragraph-segmentation as an alignment prerequisite. **[observed]**
10. **T10** — math register as a second, orthogonal problem: contrastive prose-vs-math, inline math, reasoning support for genuine ambiguity; whole-document clustering re-justified by cross-page section bodies with embedded math. **[observed]**
11. **T11 (generative)** — **masking + hotspots**: "masking the math register and using a model to adjudicate the ambiguous runs by reviewing the masked regions and surrounding contiguous context e.g. hotspots." **[observed]**
12. **T12 (generative)** — **flow-first ordering**: recover manuscript flow / latent linear document graph first, then mask from geometry evidence; "part of my challenge here is not only posing the intermediate challenges but also the order of operations." **[observed]**
13. **T13 (generative)** — features have **roles**, not just values: "page number should definitely be part of the discovery as well as assembly… Posing the feature vectors and exposing the right axes is crucial." **[observed]**

### Phase C — the inference frame (turns 16–20)

14. **T16 (generative)** — **counterfactual projections**: remove feature groups (e.g. page signals) and observe cluster merges — "flexibly examine different constrained views on a more complete dataset." **[observed]**
15. **T17 (generative)** — dendrograms/multiresolution + PH + "a conditioned backbone similar in spirit to SIFTS but with more principled anchors." **[observed]**
16. **T18 (generative, the keystone)** — "identifying the anchors kind of smells like inference on hidden states… latent directed graph with unknown anchors… infer it with high confidence by how surprisingly well certain proposals are. almost like solving a linear system of equations… assuming i have enough evidence to constrain the problem adequately." → reframed the entire system as **abductive/posterior inference over a latent manuscript graph**, with anchors as *outputs*. Sol: "the conceptual shift that makes the architecture snap into focus." **[observed]**
17. **T19 (redirect to empirics)** — both reference systems get reading order largely from *automation*; "maybe I should study their deconstruction and assembly procedures more closely." **[observed]**
18. **T20 (synthesis + question)** — your own end-to-end statement: "initial global discovery phase → recursive process that zooms global to local and merges/reconciles evidence → ordering → then math/prose contrastive analysis"; plus: can beta be auto-tuned from within-document data? **[observed]**

**Adjudication of the arc [inferred]:** Phase A found the mechanism vocabulary, Phase B
found the contract and granularity, Phase C found the organizing theory. The through-line
is yours; Sol's principal contributions were formalization (quotient framing, three-IR
separation, anchor taxonomy, posterior-invariant definition) and empirics (code receipts
in T19's reply). Nothing in Phase C contradicts Phase B — the phases stack.

---

## 2. Verdict ledger

### Survived (the design rests on these)

| # | Commitment | Origin |
|---|---|---|
| S1 | Inverse manuscript recovery: PDF = surjection onto canonical envelope; recovery returns a canonical selection + preserved ambiguity, never a fabricated unique answer | user (T7; also inverse-framing note) |
| S2 | **Final IR = semantic ABI and measurement boundary**; schema shared verbatim with LaTeX frontend; markdown a pure projection | user (T7/T8), Sol formalized |
| S3 | Anchor-and-interval granularity (`heading / body_span / math_display / figure / table / residual_block`); pages are provenance, not semantics | user (T9) |
| S4 | Whole-document discovery precedes page interpretation; global regimes condition local analysis | user (T7/T10) |
| S5 | Cluster-conditioned refinement: `Refine(parent_cluster, secondary_axes, isolation_model, coherence_test)`; outlier **modes**, not scores | user (T4/T6) |
| S6 | Multi-view consensus as evidence accumulation (co-association), never majority voting; conflicts are preserved and routed | user (T6), Sol elaborated |
| S7 | Typed geometry-preserving masks + hotspot adjudication; hotspot priority = uncertainty × structural impact × alignment impact | user (T11), Sol mechanized |
| S8 | Flow-first order of operations: global regimes → provisional flow (opaque interruptions) → register masking → localized repair | user (T12), Sol formalized |
| S9 | Features have typed roles: entity / relational-edge / conditioning / constraint; a feature registry governs admission per analysis | user (T13), Sol typed it |
| S10 | Counterfactual projections over feature groups; merge/split behavior is itself evidence; declarative versioned view specs | user (T16), Sol systematized |
| S11 | Conditioned backbone: hard anchors / certified anchors / soft anchors; SIFTS analogue with the skeleton *partial and earned*, not given | user (T17), Sol formalized |
| S12 | **Anchors are posterior invariants** — decisions stable across the plausible-configuration ensemble (k-best, perturbations, view ablations); the unresolved remainder is the precise uncertainty frontier | user (T18), Sol formalized |
| S13 | Reference systems as independent proposal mechanisms; instrument their decisions into ledgers; earliest-divergence debugging against the LaTeX graph | user (T19), Sol supplied receipts |
| S14 | Free parameters (beta) become document-conditioned evidence: sweep→stable plateau, per-regime estimation, or soft bridge inference; marginalize, don't guess | user (T20), Sol gave 3 strategies |
| S15 | Five reusable operators — **Cluster / Refine / Assemble / Reconcile / Mask** — instantiated per problem; no per-problem bespoke algorithms | Sol (T12 reply), consistent with your problem-catalog stance |
| S16 | False-confidence rate as a defining metric; multidimensional fidelity report; every algorithm earns its place by reducing specific final-IR discrepancies | Sol (inverse-framing + T8 reply), user-aligned |

### Corrected or superseded (do not build on these)

| # | Item | Fate |
|---|---|---|
| C1 | Sol's "architecture charter" push (T2 reply) | Rejected by T3 as system-shaped/nebulous; superseded by problem catalog, then by final-IR-first ordering |
| C2 | IF as upstream anomaly pre-filter (T3 reply) | Corrected twice (T4, T6); the surviving form is S5 |
| C3 | The 4-phase header *pipeline* (T3 reply) | Not wrong, but superseded in form by S5 + S15 (operators over views, not a fixed cascade) |
| C4 | "Clustering-heavy" as the system's identity | Refined by T18: clustering discovers evidence geometry; identity = posterior recovery of a latent manuscript graph |
| C5 | "Their reading order comes from automation rather than models" (T19, yours) | Partially corrected: MinerU's PP-DocLayoutV2 contains a learned pairwise reading-order head; deterministic assembly does the rest. **Verified in source 2026-07-23** ([models-removed-trace.md](./models-removed-trace.md) §0) |
| C6 | Fine-grained paragraph alignment as a prerequisite | Dissolved by S3 (coarse anchors, fine payload) |
| C7 | XY-Cut++ as advertised in ODL | Audit finding: default `beta = 2.0` effectively disables cross-layout detection; computed density preference unused. Its ordering quality comes mostly from upstream object normalization/consolidation. **Verified and sharpened 2026-07-23: the cross-layout branch is mathematically unreachable at default beta, and the density "tiebreaker" javadoc is false** ([models-removed-trace.md](./models-removed-trace.md) §0) |

### Warnings that should persist **[observed]**

- "The main danger is… allowing the project to become an open-ended tour of clustering techniques" (inverse-framing). The final-IR-first discipline is the antidote — an experiment earns its place via gauntlet discrepancies.
- Evidence-provenance double-counting: heading and body-span detectors reusing the same font-size/whitespace features are *not* independent witnesses; the global scorer must track evidence provenance (T18 reply).
- Feature ablation does not produce nested filtrations — compute persistence per view and match across views; don't call cross-experiment recurrence "persistence" (T17 reply).
- Nonlinear embeddings (UMAP et al.) for inspection only; never infer merges from overlapping 2-D clouds (T16 reply).

---

## 3. The stitched end-to-end **[inferred, assembled entirely from surviving commitments]**

```text
0. CONTRACT   manuscript-ir/0.1 (S2,S3) + versioned canonicalization profile
              LaTeX frontend emits the reference stream; aligner + multidimensional
              fidelity scorer (S16) exist BEFORE pdf discovery work begins
1. ATOMS      immutable PdfPig evidence; ODL-grade deterministic gathering (S13)
2. GLOBAL     whole-document discovery (S4): typography/page-template/recurrence
              regimes via Cluster + Refine (S5) over typed feature views (S9,S10)
3. DECOMPOSE  recursive global→local: candidate cuts conditioned on regimes;
              counterfactual bridge analysis replaces beta (S14); obvious figures/
              tables/display-math enter early as geometry-preserving opaque obstacles
4. RECONCILE  bottom-up: child orderings → parent hypotheses, second-bests retained;
              co-association across views (S6); persistence as stability evidence (S11)
5. INFER      posterior recovery of the latent manuscript graph (S12): factor-style
              scoring (local evidence + relational fit + coherence − violations);
              k-best ensemble → posterior backbone; high-entropy frontier explicit
6. ADJUDICATE agent resolves the frontier: hotspots, H1 cycle representatives,
              competing segmentations — with visual crops + contiguous manuscript
              context + document-global analogues (S7); constrained output; abstention
7. REGISTER   math/prose contrastive analysis AFTER ordering (S8): math atlas from
              display seeds; typed masks; local flow repair via dependency tracking
8. EMIT       canonical linearization per profile → final manuscript JSONL →
              markdown as a boring projection
LOOP          gauntlet: earliest-divergence tracing (7 levels, T19 reply); ordering-
              of-operations itself ablatable (S8 alternatives are testable configs)
```

The order-of-operations that you converged on in T20 is exactly stages 2→5→7, and Sol's
one adjustment (opaque obstacles participate early) is folded into stage 3.

---

## 4. Your two named open threads, against the corpus

### Clustering's broader role — largely answered **[inferred]**

The corpus's arc *is* the answer: clustering is not a component but an **instrument
family for generating typed evidence** — regimes (Cluster), hidden heterogeneity
(Refine), stability (persistence/dendrograms as partition families), dependence
structure (counterfactual projections), and co-association currency for consensus. Its
jurisdiction ends where semantics begin: it supplies *factors* to the posterior
inference layer (S12), never verdicts. Anything broader you want clustering to do can
be posed as: which typed evidence does stage 5 lack, and which operator/view emits it?

### Agent-in-MCP becoming first-class — genuinely open, but the corpus constrains it **[open]**

The thread never articulates a first-class agent; its agent is a bounded adjudicator.
But the corpus *did* quietly expand the agent's interface across the discussion — each
new mechanism ended with "…and this is excellent input to a reasoning agent":

- evidence packets with structural consequences (T11 reply)
- feature-dependence signatures (T16 reply)
- multiresolution anomaly trajectories (T17 reply)
- H1 cycle representatives as principled hotspots (T17 reply)
- decision ledgers from reference pipelines (T19 reply)
- membership in the iterative loop: adjudicate → add evidence → re-solve (T18 reply, steps 7–8)

**The dependency you stated (can't define agent roles until the ML elements are fleshed
out) is confirmed and made precise by the corpus [inferred]:** the agent's roles are
jobs over the *typed evidence artifacts* the unsupervised layer emits. Define the
artifact catalog (packets, signatures, trajectories, ledgers, cycles, posterior
frontiers) and the agent surface falls out of it — likely as MCP tools that expose
exactly those artifacts plus the loop verbs (inspect frontier / adjudicate / commit
evidence / trigger local repair). What "first-class" adds beyond adjudication —
e.g. the agent directing discovery (choosing views, ordering experiments, deciding
where to spend refinement) rather than only consuming its residue — is the part the
corpus does not yet contain. That is the next design conversation. **[open]**

---

## 5. Borrowings ledger (ODL-pdf / MinerU)

| Borrow | From | Note |
|---|---|---|
| Deterministic born-PDF evidence gathering; object normalization + semantic consolidation *before* ordering | ODL | Audit suggests this—not XY-Cut++—is where its ordering quality lives (C7) |
| Cross-page recurrence for furniture; stable IDs; caption linking; reconciliation passes | ODL | Maps onto S4/S6 directly |
| Tagged-PDF evidence lane; common JSON serialization shape | ODL | Evidence source + serialization prior for the final IR |
| Staged developmental IR (`middle.json` pattern) | MinerU | But preserve hypothesis ensembles where MinerU stores one interpretation |
| Document-level paragraph pass; cross-page continuation logic (`para_split`) | MinerU | Closest existing code to S8's flow assembly |
| Learned pairwise ordering as *one proposal source* among several | MinerU | Never the semantic owner (T7 reply's departures) |
| `discarded_blocks` pattern — furniture removed but retained | MinerU | Matches evidence/discard-ledger stance |
| Instrument both as decision ledgers; earliest-divergence debugging | both | The T19-reply experiment is a strong early gauntlet exercise |

Departures that define the third way **[observed]**: whole-document-first; hypothesis
preservation over single interpretation; posterior/abductive selection over cascade or
learned head; false-confidence as a first-class metric; LaTeX-paired measurement.

---

## 6. Open holes (not settled anywhere in the corpus)

1. **manuscript-ir/0.1 as a written spec** — the corpus contains everything needed
   (kinds, boundary rules, placement policy, provenance unions, versioning) but no
   committed document. This is the first artifact; everything else measures against it.
2. **Hypothesis-IR representation** — evidence graph, competing partitions, and
   posterior ensemble need a concrete schema; discussed structurally, never specified.
3. **Inference machinery choice** — factor graph vs weighted-constraint vs k-best
   structured search; Sol deliberately left implementation open.
4. **Agent surface** — the first-class question (§4); blocked on the artifact catalog,
   which is blocked on 1–2. Your stated dependency order is right.
5. **Beta strategy selection** — three calibration strategies proposed; which one the
   gauntlet tests first is unchosen.
6. **MVP domain boundary confirmation** — inverse-framing proposed born-digital
   TeX-origin academic PDFs, tables/scans deferred; never explicitly ratified in the
   thread.
7. **Naming** — per brand practice, unresolved and deliberately so.

---

## 7. Addendum — post-distillate commitments and frames (2026-07-23, same day)

Recorded from the follow-on discussion; kept separate from the corpus adjudication above.

- **Agent role decided (user):** the agent and its swarm perform **semantic
  interpretation and reconciliation** — not just residual adjudication. §4's open
  question is now directional; what remains is the tool surface over the typed
  evidence artifacts. Swarm dispatch respects the dispatch boundary (parallelize
  across chains / full-context replicas / mechanical grains — never within a chain;
  see thread-corpus-container.md, Dispatch boundary).
- **Phase skeleton confirmed (user):** distinct phases; middle IR(s); joint proximal
  target = the final pre-markdown JSONL ABI with manuscript order/flow mostly
  determined.
- **Taxonomy generator (proposed, [inferred]):** derive the envelope ontology from
  the **LaTeX frontend's reachable output set** over the MVP corpus (sectioning
  commands + environments → kinds; front matter from \maketitle/abstract), rather
  than from PDF-side speculation — the corpus already holds that "the LaTeX path
  defines and continuously tests the canonicalization contract." Design point: keep
  semantic **kind** orthogonal to **render-class** (`native` / `asset` / `hybrid`) —
  render-class is a per-instance backend commitment recorded with its evidence, not
  a proliferation of kinds. Hard middle to watch: vector figures with embedded text,
  complex-span tables, algorithm/code environments.
- **Pipeline mission statement (user, later same day):** mechanical processing +
  clustering assemble the backbone **with holes indexed and masked**, packaging unit
  work items with evidence and context so agents perform **well-posed resolution**.
  The pipeline is a localizer/well-poser, not an interpreter: it factors one
  ill-posed inverse problem into a deterministic bulk plus many locally well-posed
  decision problems; what cannot be well-posed stays explicitly ambiguous in the IR.
  Corollary metric [inferred]: **adjudication stability across replicas** measures
  packaging quality separately from verdict accuracy — verdict flips on identical
  packets indicate an under-specified work item (a pipeline bug), not an agent
  failure. Agent-task taxonomy deliberately deferred until the floor/hole map
  (chip: models-removed-trace) and early gauntlet runs show what preliminary work
  accomplishes; expected primary axis [inferred, falsifiable]: decision-type
  (register/boundary · identity/role · ordering · attachment · assembly ·
  reconciliation) over content-type.
- **Formulation vs orchestration (user question, later same day; [inferred] analysis):**
  can work-item assignments be distilled mechanically, or does a primary agent
  formulate/orchestrate for its swarm? Decompose the "orchestrator" into three
  functions: **formulation** (mechanical for the anticipated decision-type schema —
  this is exactly what typed hole interfaces provide), **scheduling** (mechanical:
  priority score + dependency topology), and **quality control** (irreducibly
  agentic, but bounded). Mechanical formulation has two structural leak channels it
  cannot close by definition: (1) **false-confident regions generate no work items**
  — the pipeline only packages holes it noticed; (2) **mis-posed packets** — the
  truth is C when the packet asks A-or-B, or the hole boundary itself is wrong.
  Therefore: keep the inference loop fully mechanical (agents **commit evidence,
  never control flow** — preserves determinism, replayability, gauntlet credit
  assignment), and place bounded supervisory passes *outside/between* loop
  iterations: (a) confident-span audit (full-context replica pattern — legitimate
  per the dispatch boundary), (b) packet veto with a typed reformulation protocol
  (reject-framing → mechanical widening/escalation rules), (c) novel-residual
  characterization. Feasibility of pure-mechanical is then an **empirical question
  the gauntlet answers**: replica-stability rate (mis-posed packets), false-
  confidence rate (unpackaged-error tail), earliest-divergence attribution
  (formulation vs resolution failures). Design the supervisory sockets now; fill
  them minimally; let measured leak rates set the supervisor's scope. (If it earns
  a name, rector-codices already has one waiting.)
- **Agents generate, not only select (user, later same day):** the assembly
  decision-type is *generative* — only an agent can translate a packet of
  typography/glyph evidence into lexically and syntactically correct target-register
  KaTeX. The control-flow rule survives with sharpened wording: **agents author
  payloads (verdicts, translations, characterizations); mechanism owns validation,
  incorporation, and flow.** Generated math enters through the existing mechanical
  gates (parse/render/lint; cf. the latex-math-oracle lane) as a hypothesis with
  provenance, like any other evidence commit.
- **Cross-piece register consistency (user, later same day; [inferred] mechanism):**
  correctness of individual translations is not enough — the math register must be
  consistently *registered* across pieces (same source configuration → same target
  rendering; ℝ is \mathbb{R} everywhere; script/bold conventions stable). Consistency
  is a **global observable** — independent local decisions cannot guarantee it. The
  architecture that preserves parallelism: promote the discovery-side math atlas to a
  **document register lexicon** (first-class IR artifact): glyph-configuration
  equivalence classes discovered mechanically; **the unit of translation becomes the
  class, not the occurrence** — one agent work item per lexicon entry, with all its
  occurrence contexts packaged as mutually disambiguating evidence; mechanical
  propagation to every occurrence; consistency linting mechanical; class-assignment
  failures become occurrence-level residual holes. SW correspondence: the lexicon is
  the bond placement — once bonds are placed, cluster flips are conditionally
  independent; once classes are bound, per-class translations are conditionally
  independent and parallelize within the dispatch boundary. Generalizes beyond math:
  terminology, numbering, cross-references — a document **convention ledger** with
  the same class/propagate/reconcile machinery. Adjacent artifact:
  issues/latex-math-oracle/sol-math-register.md (not re-adjudicated here).
- **Agent layering (user, later same day):** three tiers now explicit. **Workers**
  solve isolated, well-posed units (KaTeX authoring, hotspot repair); replica
  adjudication with systematic consensus checking is **instrumentation, not
  insurance** — per-decision-type agreement rates are the packaging metric, and
  once a work-item type demonstrates reliable agreement it drops to single-shot
  with sampled spot-checks. Docling-repair precedent (pre-codex-scientiae): with
  well-isolated localized context (prose above/below a garbled region), a local
  GGUF repaired reliably without replicas — so **required model capacity is itself
  a diagnostic of well-posedness**; the mechanical layer's well-posing converts
  frontier-tier problems into small-model-tier problems. (No contradiction with the
  GGUF judgment-tier exclusion in the thread-corpus work: capacity demand is a
  function of posed-ness, and trajectory adjudication cannot be posed locally.)
  **Parent** resolves the minority consensus disagreements — each one doubling as a
  packaging bug report — and performs the **end-to-end semantic read** of the
  assembled manuscript: the confident-span-audit socket, now filled by precedent
  (docling final check; the sol-thread distillate read). Sequential gait, carried
  state, unshardable; the only reader who has read the document *as a document*.
  Provenance discipline binds the parent too: final-read fixes enter as evidence
  commits / auto-accepted work items, never unaudited edits.
- **Reliability doctrine (user, closing):** the end-to-end process must get the job
  done reliably, and the system — MCP artifacts, successive IR stages, runtime
  documents (the rolling-notes discipline) — exists so "the Leonard at the end has
  the paper trail to reconstruct context and make informed decisions." **If the
  output isn't up to spec, the architecture and process design hasn't matured
  enough** — defects indict the process, never the operator. Every escaped defect
  has a process address (packaging, gate, lexicon, audit), and earliest-divergence
  attribution names the stage to mature. The stance is actionable, not aspirational,
  because "up to spec" is measurable (ABI + multidimensional fidelity +
  false-confidence) — the gauntlet gives the architecture a gradient to descend.
  Corollary: the paper trail serves not only the final reader but any
  resumed/replacement reader at any stage — crash recovery and final audit are the
  same affordance.
- **Decision authority (user, closing clarification):** the agent **does make
  decisions** — this is an agentic MCP pipeline forging high-quality markdown from
  PDF via a principled evidentiary process, not a recommendation engine awaiting a
  human's final call. Evidence-commit discipline governs *how* decisions enter the
  record (with provenance, through mechanical gates), never *who* decides: the
  agent's decision IS the decision; gates validate form, mechanism incorporates,
  and the trail exists for diagnosis and process maturation — not real-time human
  ratification. The human's seat is the **development loop, not the execution
  loop**: author the constitution (spec, gates, conventions), read the gauntlet,
  mature the architecture between runs. The infrastructure compensates for agent
  weaknesses (accumulated artifacts and runtime documentation are the memory and
  continuity Leonard didn't have) so agents reliably and robustly get the job done.
  **Thesis (user):** such a system can solve the problem with near-deterministic
  reliability. The system's form of that claim: output is
  **deterministic-or-declared** — variance is resolved (gates, consensus,
  escalation), absorbed (canonicalization conventions), or explicitly carried
  (preserved ambiguity); "wrong with confidence" is the one failure mode designed
  out, and the false-confidence metric is the thesis's own falsifier.
- **Models-removed trace (user frame, still percolating):** take both reference
  systems minus their trained models. ODL retains nearly its entire deterministic
  path; MinerU retains span binding, geometric line recovery, para_split
  continuation, discarded_blocks, cross-page merging. The composite yields
  (a) the **deterministic floor** — what automation alone achieves — and (b) a
  **map of the holes**: MinerU's model inventory is an empirical census of the
  subproblems where determinism was insufficient (layout roles, reading order,
  formulas, tables, OCR), and ODL's magic constants mark where document-conditioned
  regimes should replace universal thresholds. Remaining design = fill each hole
  with {document-conditioned discovery, posterior inference, agent} instead of
  {trained net, fixed constant}. Empirical form: the staged decision-ledger /
  earliest-divergence experiment (§5).

## 8. Method note

Produced by full sequential read of the tool-stripped dialogue (25,648 → 4,277 lines;
stripped copy at `.claude/temp/sol-reboot-brainstorming.stripped.md`, regenerable),
with the user's turns treated as the low-noise trajectory backbone and replies
adjudicated against subsequent turns. Live exercise of the thread-corpus consumption
method (ad libitum gulps, interleaved notes, verdict-not-summary) from
`utils/reposnapshot/issues/thread-corpus-container.md`.
