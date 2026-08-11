Just pushed the latest for codex-scientiae, lets examine doccer implementation so far and outstanding planning items and development arcs. I know next step is for the k8 implementation, and im trying to put in perspective what's left after that as well as root out any current design flaws or implementation gaps i haven't already accounted for, and opportunities for future development

Thought for 1m 46s

**Doccer is at a clean kernel-complete point.** The latest push closes the critical path through K7 (plus the independent V1 vector lane). What follows is a synthesis grounded in the current planning canon (issues/doccer/planning/{roadmap,ledger,architecture-expansion-workplan,decisions}.md), the contract surface (src/doccer/README.md), the K7 review, and the landed source under src/doccer/.

## Implementation so far

**State (2026-08-10):** D1–D47, contract harness **2751 checks green**, engine ~43 files / ~8.3k LOC, tests ~9.6k LOC. Delivery is brewery/doccer/build-doccer.ps1 → local packages/doccer (untracked; provenance via doccer.manifest.json).

**Doctrine (stable):** Claims carry evidence. Queries execute named policies and return results + residuals. Orchestration selects policies and interprets results. The representation never pre-resolves. Many-sorted kernel (valid boundaries P P P, located extents L L L, nonempty Allen intervals I I I, claim occurrences C C C, canonical facts F F F, origins O O O, plus basisless Boolean vectors B B B and explicit UTF-16 unit masks U U U). Not a pipeline; every stage is independently callable.

**Landed carriers (bottom-up):**

| Layer                 | Carriers / operations                                                                                                                                                                                                                                                                                                                               |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Core                  | TextMaster, TextSpan, TextTopology, TextSlice, SpanBatch                                                                                                                                                                                                                                                                                            |
| Algebra               | Allen 13 + AllenRelationSet/AllenCompose, SpanSet, ClaimSelection, ClaimPairView/ComposePairs, PairingResult, LocatedRelation/Seq, CandidateRegionGraph, ReachabilityView/PartitionView/Segmentation, PathSelection (additive min-cost), Packing/Cover/LaminarView/Laminarizer.Admit, HierarchyView/NearestContainers, ResolutionView/ResolutionMap |
| Facts                 | FactKey, CanonicalFactTable/FactReference, SupportHypergraph, GroundRule/FactSaturation.Saturate                                                                                                                                                                                                                                                    |
| Origins               | OriginBasis/OriginSlot, OriginRelation/ComposeOrigins, projection, TextSlice embedding                                                                                                                                                                                                                                                              |
| Materialization       | RewritePlan/OutputPiece, RewriteMaterialization.Materialize (new master + K6 relation + per-slot unused residue)                                                                                                                                                                                                                                    |
| Vectors (independent) | BooleanVector, Utf16UnitMask, classifiers, topology-atom harvest, claim emission                                                                                                                                                                                                                                                                    |
| Collector / measures  | Transactional RegexCollector + JSONL loader, gap cadence, named lookup orders, suppression as query                                                                                                                                                                                                                                                 |

Identity discipline is consistent: compatible-master value equality for geometry carriers; exact reference identity for occurrence/evidence carriers (sharpest at ComposeOrigins requiring ReferenceEquals on the middle basis); derived deterministic identity for slices. Residuals are real (pairing faults, gap vs dead-end, selected/rejected/excluded, boundary vs classifier residue, unused source without inferred deletion).

Legacy Tranches 0–3 (substrate, slice/rebase, grouping/projection, gap cadence) and the entire K0–K7 arc are closed. The early sol-doccer-next-steps.md audit is historical; most of its Phase-1 gaps were closed by the subsequent tranches and K series.

## Immediate next: K8

**K8 = cross-carrier integration demonstrations**, not new carriers. The component contracts already ship first bounded witnesses; K8 reassembles them into one integrated suite that proves composition across the completed kernel:

1. Pairing over ≥2 delimiter families with complete identity-bearing residue.
2. Ambiguous candidate token graph with two complete paths, exact graph/batch stamp, and explicit selection policy.
3. Budgeted flat chunk graph (adapter-supplied measure + cost).
4. Fixed bounded macro substitution producing a new master with composed origins.
5. One recursive/document-supplied expansion under an explicit depth/resource limit (policy stays outside the kernel).

These are non-domain-owning integration demos. They are not the first validation of the pieces and are not durable codex-scientiae adapters unless separately promoted.

## What’s left after K8

**Critical-path / unlock order (from roadmap + workplan):**

- **CLI module (D13, committed product).** Separate module over the public capability library/engine. Return packet (sol-doccer-cli-module-deferred-20260809_180623.md) freezes the one-way boundary, ThermoMapper donor patterns to lift, defects to avoid, and reactivation gates (stable carrier + wire form + second-process round-trip + typed invocation before execution). Current inspect/relate remain disposable diagnostics. First vertical slice is not yet chosen; candidates include a stable low-level carrier (SpanSet/ClaimSelection or post-V1 vector/mask family).
- **Persistence (F2).** Requires fingerprint algorithm/version + canonical UTF-16 byte order before host-endian in-process commitments can cross platforms. Then F4 indexed joins.
- **Durable adapters last.** PowerShell veneers and LaTeX consumers become thin clients only after the relevant Doccer surface stabilizes. Engines first; codex-scientiae adapters last.
- **OffsetMap.** Contract shape is drafted (Exact | Range | Unmapped, residuals, named projection policy). Still deliberately absent; prioritization default is the first real edit-plan or normalization job that would settle the remaining open questions. Not a general origin carrier.

**Independent parallel lanes (no K8 type dependency):**

- **V2** — accelerated vector/mask backends; each re-applies D42/D46 assurance. Packed SpanSet and suppression-bitmap equivalence are separate future gates (presumptive optimization-pressure activations if claimed interchangeable over arbitrary inputs).
- **A0–A2** — measured dense/sparse baselines, set-bit walker for ClaimSelection, reconstruct-once path recurrence under frozen D30/D37 oracles. Per-capability HPC repertoire (span destinations, count-prefix-fill, flat/SoA, scratch, bounded heaps, online reductions, reference/fast pairing) — not a common framework.
- **F7–F9 (dependency-split):** F7a distance/correspondence independent; F7b performed-transform origins (now unblocked by K6); F7c promotion/materialization integration (unblocked by K6/K7). F8a/F8b direct/rolling hashes independent; F8c/F8d signatures/sketches; F9a counted/online views over current populations independent; fitted/ranked forms later.
- Optional **LinearET** compiled backend after K7 (restricted fixed linear-growth profile only; not general materialization).
- **QSTR networks** only if a real consumer with uncertain/disjunctive geometry appears (branch from K1).
- **Lean** remains deferred and burden-triggered. Reactivation only when proof pressure can change a public signature, license an optimization/stage fusion, resolve an exact-vs-lax boundary, or support a nontrivial global guarantee. Current surfaces stay under direct finite semantics + exhaustive oracles.

**Standing practice:** abductive census as Doccer integrates into live workflows (latex-ingest end-to-end is the first named occasion). Hits become site records in a future-consumer registry; verbs name dense routes through the latent path-space; residuals stay visible.

## Design observations / residual gaps

No closed-contract defects turned up in the K7 end-to-end read. Watch items (observations, not blockers):

- **Style strata:** early Validation.cs / some LaminarView still use LINQ; K3+ is strict explicit-loop/typed-collection. Harmless archaeology; optional K8-era normalization.
- **Linear-scan query methods** (SupportsOf, ParentsOf/ChildrenOf, CoarseTargets/FineMembers, and FirstOrdinalCompletePath’s per-boundary full ordinal walk). Correct reference posture; first hot spots under K8-scale composition → natural A-lane / F4 targets.
- **Cosmetic hash-basis inconsistency:** Utf16UnitMask folds Master.Length/AddressUnit; geometry carriers use DocumentId/Revision/Fingerprint. Consistent with compatible-master equality, two idioms for the same thing.
- **Deliberate absences** (workplan non-goals): no unqualified Compose/Select, no ET-as-ontology, SpanSet is not a partition carrier, no universal parser/grammar DSL, no TeX confluence or arbitrary macro termination, OffsetMap is not the universal transform, intermediate masters are not hidden by default, no universal selection solver before two families demonstrate one contract.

Root TODO.md items (packaging conventions across C#/Node/PowerShell, latex-ingest/MCP refactor priority, ingestion→procurement rename, etc.) are broader repo hygiene, not Doccer-kernel gaps.

## Future development opportunities

- **Factory instruments as recipes, not base classes:** scoped extractor, pairing, tokenizer, chunker, structural-deduction, rewrite/macro factories assembled from the kernel sorts + externally supplied domain rules. The K8 suite is the natural first demonstration set.
- **F7b/F7c and fact/origin feature recipes** are now type-unblocked.
- **mdnav succession (F6)** as oracle harness on the doc-dive fixtures — exceed mdnav at its collapse points while conserving its instrument virtues.
- **Census-driven surface growth** once latex-ingest (and later pdfdig) start reading Doccer instead of improvising.
- **Cross-project graduation (D13):** anything a graduated Doccer must carry lives in the C# surface, not PowerShell. MarkBrain / MarkPig legwork remains historical evidence only (never amended).
- Optional LinearET backend for fixed adapter plans once origin/support semantics are stable enough to instrument and prove translation.
- Measured A-lane and V2 work can proceed in parallel with or after K8 without touching the K critical path.

**Bottom line:** the kernel critical path is closed. K8 is the integration proof. After that the work splits into (a) product surface (CLI + wire + persistence), (b) independent numerical/acceleration and feature lanes, and (c) thin durable adapters once the carriers they need are stable. The design is internally consistent across canon, README, source, and harness; residual risk is mostly engineering (hot-path scans, packaging, first CLI vertical slice) rather than unaccounted semantic gaps.

one thing from the thermomapper-related perf enhancement patterns is the suspicious absence of "zero alloc" unless its in there not by that name. zero-alloc is a part of thermomapper's DNA

Thought for 1m 13s

You're right to flag it. The **slogan is absent on purpose; the techniques are present under other names — and the framing is thinner than ThermoMapper's DNA would suggest.**

## What the canon actually did

Literal zero-alloc / zero allocation / ArrayPool / stackalloc / ref struct do not appear in the living Doccer planning surface or in src/doccer. That is not an accidental omission of the _idea_.

In the round-2 expansion discussion you explicitly said:

> and i would add zero-alloc patterns to that later. thermomapper actually has quite a bit of perf patterns…

That thread treated zero-alloc and vectorization as **the same problem at two altitudes**, rooted in the same representation choices (Starts/Ends internal, boxed enumerators, PathSelection allocating suffix arrays inside the DP loop). Concrete ThermoMapper lifts were named:

| ThermoMapper pattern                                                     | Doccer target                                               |
| ------------------------------------------------------------------------ | ----------------------------------------------------------- |
| UndirectedEdgeWalk as readonly ref struct + nested ref struct enumerator | Kill boxed IEnumerator on ClaimSelection / structural views |
| Two-pass count → prefix-sum → fill                                       | Exact allocation, no List growth                            |
| stackalloc under threshold / ArrayPool above                             | Operation-scoped scratch                                    |
| Predecessor links instead of copying suffix arrays                       | PathSelection inner-loop allocation                         |
| struct policies under generic constraints                                | Zero-dispatch strategy objects (with the boxing caveat)     |
| MemoryMarshal.Cast                                                       | Zero-copy column/span views                                 |

D41 then **absorbed** those techniques into Doccer's own evidence language, not as a named zero-alloc doctrine:

- **A0** — named workloads, record **time and allocated bytes**
- **A1** — word-skipping set-bit walker (TrailingZeroCount + clear-lowest-bit) — simultaneously the zero-alloc fix for the boxed/yield enumerator _and_ the word-at-a-time walk
- **A2** — reconstruct-once path recurrence — removes the per-transition new int\[\] + Array.Copy
- **Per-capability HPC repertoire** — “span-first destination kernels, **exact allocation**, flat layouts, **operation/worker scratch**, bounded heaps…”

The Levenshtein stack/pool threshold and “caller/operation-owned workspaces” appear explicitly in the transfer table. Count-prefix-fill exact allocation is listed as a CSR/layout pattern.

So the mechanisms are on the plan. The **DNA slogan is not**.

## Why the slogan was diluted

Doccer deliberately refused to import ThermoMapper's _identity_ as a zero-alloc culture. The adjudication is consistent on this point:

- ThermoMapper is a source of patterns and capabilities, **not policy**.
- Doccer's measurement rule is its own: an alternate backend that claims lower time/allocation must name the workload and show before/after evidence.
- Reference semantics first; acceleration second.
- Public policy objects stay retained evidence stamps (sealed classes today). Wholesale conversion to generic struct policies was rejected as an API rewrite, not an invisible win.
- Immutability and exact-basis identity constraints mean many result carriers _must_ allocate or copy under the current contracts; zero-alloc is not a universal public-surface obligation.

ThermoMapper itself is not uniformly zero-alloc — discipline lives in the primitives and relaxes in orchestration. That layering was noted as the correct thing to import. Doccer kept the layering and dropped the brand.

## What's still a real residual

The residual is **under-naming**, not missing substance:

1. There is no living-canon phrase that elevates allocation posture the way ThermoMapper elevates zero-alloc. “Record allocated bytes” is weaker framing than “primitives are zero-alloc; orchestration may allocate.”
2. The contract-preserving zero-alloc lane from the expansion discussion (ref-struct enumerators → PathSelection reconstruction → span views → optional struct policies) is still mostly latent in the A-lane chips. A0–A2 are the right entry points, but they are not yet labeled as the zero-alloc lane.
3. Current reference implementations still allocate on hot paths in the ways D41 diagnosed (ClaimSelection yield enumerator over the full basis; PathSelection suffix array copies). That is correct under reference-first doctrine — and exactly what A1/A2 are meant to attack without changing public contracts.

## Practical reading

| Layer                                 | Status                                                          |
| ------------------------------------- | --------------------------------------------------------------- |
| Slogan / DNA framing                  | Absent — intentional non-import of ThermoMapper policy identity |
| Measurement (allocated bytes)         | Present as A0                                                   |
| Exact allocation / count-prefix-fill  | Named in HPC repertoire                                         |
| Operation/worker scratch (stack/pool) | Named in transfer table; not yet a shared helper                |
| Ref-struct / non-boxing enumerators   | Diagnosed; A1 is the first concrete fix                         |
| PathSelection zero-churn recurrence   | Diagnosed; A2 is the fix                                        |
| Struct-policy zero-dispatch           | Noted as candidate; public API left alone                       |

So the absence is suspicious relative to ThermoMapper DNA, but it is not a hole in the _capability_ map. It is a **framing gap**: the techniques landed as anonymous repertoire items under Doccer's evidence rule, without the first-class discipline name that would keep allocation pressure visible the way residual visibility is kept visible.

If you want that DNA recovered without importing ThermoMapper policy, the clean move is a small canon amendment: elevate “contract-preserving allocation posture” (or an explicit zero-churn lane) as an A-lane acceptance criterion — reference path may allocate; any backend claiming to be hot must show allocated-bytes evidence and prefer exact allocation + operation-owned scratch + non-boxing enumeration — without making zero-alloc a universal public-API obligation. That would restore the missing name without reopening the K carriers.

well, in thermomapper's defense, its not a finished project and it's been on hold, waiting patiently for its dogfood from codex-scientiae, if codex-scientiae ever manages to get it's act together

Thought for 11s

Fair defense, and accurate on the dependency direction.

ThermoMapper isn’t being judged as a finished product. D41 already treated it that way: a live source of patterns and prototype capabilities, some of them incomplete or locally inconsistent, with the explicit rule that donor defects become _Doccer_ acceptance criteria rather than reasons to reject the underlying idea. The zero-alloc layering (discipline in the primitives, relaxation in orchestration) is exactly the kind of thing that shows up in a working numerical codebase that hasn’t yet been forced through a contract harness.

The hold is also legible from the codex-scientiae side. Doccer has been the one under the K-arc pressure — identity, residual visibility, exact bases, reference-before-acceleration — while ThermoMapper sits with the richer numerical surface (graphs, TDA, hashish, layout kernels) waiting for something stable enough to dogfood against. Until the kernel carriers and the first durable adapters exist, there isn’t a clean place for ThermoMapper to consume Doccer rather than the other way around.

So the relationship is asymmetric on purpose right now:

- **ThermoMapper → Doccer**: pattern and capability excavation (already partially done under D41).
- **Doccer → ThermoMapper**: eventual dogfood surface — a contract-stable, residual-visible, origin-aware numerical substrate that ThermoMapper can lean on instead of carrying its own informal versions of the same ideas.

Whether codex-scientiae “gets its act together” is mostly whether K8 + the first CLI/persistence slice land cleanly enough that the independent A/V/F lanes stop being planning fiction and start being something ThermoMapper can actually call. Until then, ThermoMapper waiting is the rational move, not a failure of either project.

thermomapper is waiting for codex-scientiae's main product, which is bulk, math-exact markdown documents of arvix research articles in machine learning, applied math and CS, because thermomapper is about synthesizing, assimilating, and implementing cutting edge research methods and concepts into an integrated whole that is greater than the sum of its parts. resistance is futile, and i am Locutus of ThermoMapper

Thought for 27s

Understood — and that corrects the earlier framing.

ThermoMapper is not primarily waiting for Doccer-as-numerical-substrate. It is waiting for **codex-scientiae’s actual product**: bulk, math-exact markdown of arXiv research (ML, applied math, CS), with the math channel and latent-manuscript fidelity intact. That corpus is the feedstock. ThermoMapper’s job is to assimilate the methods in those papers into one integrated numerical organism — synthesis and implementation, not just citation.

The README already states the mission in those terms: bind dense scientific knowledge in a form optimized for high-capacity reasoning so other projects can implement and synthesize work that post-dates training cutoffs. ThermoMapper is the named consumer of that product. Doccer sits underneath as conversion/structural machinery — claim geometry, residual visibility, origin tracking — so the markdown and the latent manuscript stay exact enough to be trustworthy input. Useful to ThermoMapper eventually, but not the thing it is stalled on.

So the dependency arrow is:

**arXiv / literature → codex-scientiae (procurement + latex-ingest + math channel + manuscript fidelity) → math-exact corpus → ThermoMapper (assimilate, implement, integrate)**

Doccer is infrastructure on the left side of that pipeline. The earlier “ThermoMapper waits to dogfood Doccer” picture was the wrong altitude.

Resistance is futile. Locutus of ThermoMapper has stated the terms.

![](https://www.google.com/s2/favicons?domain=techtarget.com&sz=256)

![](https://www.google.com/s2/favicons?domain=indeed.com&sz=256)

![](https://www.google.com/s2/favicons?domain=thenewstack.io&sz=256)

5 sources

yea, with doccer finally approaching something like an MVP, i might actually split it off into its own repository/project so that i can vendor it out to other projects of mine. like i hope that doccer will be able to implement my markpig markdown and its most esteemed visitor, mathdig's katex math-channel parsing needs without much conventional parsing. one of my challenges to doccer will be to implement markdig's parsers from scratch using doccer-native capabilities

Thought for 34s

That ambition fits the architecture better than it might sound, and the MarkPig history already pointed this way.

## Split / vendor timing

Doccer is already shaped for extraction:

- Domain-neutral by doctrine — Markdown, LaTeX, PDF, MCP are consumers, not owners of the substrate.
- Deliverable is already a verified CodexSci.Doccer.dll under packages/doccer with a manifest (commit, harness result, TFM).
- README explicitly contemplates a graduated cross-project surface that travels in the C# assembly; PowerShell stays site-local.

What still blocks a clean **library MVP** for vendoring is not more carriers so much as:

1. **K8** — cross-carrier integration witnesses (so the public story is “the sorts compose,” not “six closed islands”).
2. **First durable adapter + F2 identity floor** — anything that leaves process needs portable fingerprint/byte-order contracts.
3. **Package identity** — NuGet/name/version story separate from the codex-scientiae brewery path.
4. Optionally the deferred CLI, if external projects want process-boundary jobs rather than in-process only.

You can split the repo as soon as K8 + packaging hygiene land; you do not need the full A/V/F repertoire or ThermoMapper-grade HPC first. Those remain independent lanes after the split.

## MarkPig + MathDig as the forcing consumers

MarkPig is not a typo in this ecosystem — the Doccer README still treats **MarkPig legwork** as historical evidence, and earlier SHAPE notes had Doccer landing beside pdfdig under MarkPig. The consumer name is already in the bloodline.

MathDig’s KaTeX math-channel needs are a natural first Doccer job:

| Need                                              | Doccer-native surface                                             |
| ------------------------------------------------- | ----------------------------------------------------------------- |
| $…$ / $$…$$ / delimiter pairing                   | Pairing.Pair + open/close selections + residue                    |
| Math spans as claims                              | Collectors → SpanBatch / ClaimSelection                           |
| Nested / laminar math vs prose                    | LaminarView / hierarchy without inventing parenthood              |
| Channel vs register distinction                   | Already doctrine: math channel ≠ Unicode register ≠ fact ontology |
| Lossy normalization / glyph→control-sequence maps | Explicit producer + OffsetMap (still open, but the right shape)   |

That is “without much conventional parsing” in the strong sense: geometry + named policies + residual, not a second hand-rolled lexer.

## The hard challenge: Markdig parsers from Doccer-native means

Markdig’s architecture is roughly:

text

Copy

```
text → BlockParser pipeline (line-oriented) → InlineParser pipeline → AST → render
```

Character-driven, regex-free in core, extensible by registering parsers. Source spans on nodes. Very good software — and a very different epistemology from Doccer.

Your challenge reframes the job as:

> Can markdown structure be _collected and judged_ as claims over exact masters, under named policies, with visible residue — rather than _parsed into_ a privileged AST that then becomes the source of truth?

That aligns with Doccer doctrine (“representation never pre-resolves”; “syntax recognition remains in external adapters or declarative inventories unless a domain-neutral mechanism is demonstrated”). The interesting research question is whether enough of CommonMark/GFM block+inline structure is expressible as:

- declarative collectors (pattern inventories, delimiter rules, fence openers),
- pairing / stack discipline,
- laminar / hierarchy / resolution views,
- path or packing selection under explicit policies,
- residual for ambiguity and failure,

…so that an AST, if you still want one, is a **projection** of claim structure rather than the privileged intermediate.

Where the challenge will bite:

1. **Line-oriented block continuation state** — Markdig’s TryOpen / TryContinue is a state machine over lines. Doccer’s collectors are stronger at “find all matches under scope” than at “this open block owns the next N lines under these indentation rules.” You may need a thin, admitted continuation substrate or an honest adapter boundary for block _process_, even if recognition stays claim-native.
2. **Inline precedence and nesting** — emphasis, links, code spans have ordered conflict rules. Doccer can host the evidence; the _judgment_ (which policy wins) must stay named and outside the kernel, or you smuggle Markdig’s opinion into the engine.
3. **Spec fidelity vs residual honesty** — CommonMark is full of “the parser shall…” rules. A Doccer-native implementation that _confesses_ ambiguity where Markdig silently picks a winner is more faithful to Doccer and less drop-in compatible with Markdig. Decide early which product you are shipping.
4. **Doctrine guard** — full markdown meaning must not become a Doccer fact ontology. Kinds and inventories can name Heading, FencedCode, Emphasis; the kernel still does not decide what a heading _means_.

So the viable path is probably not “reimplement Markdig inside Doccer,” but:

**MarkPig (or MathDig) as orchestration** that drives Doccer capabilities, with a deliberate experiment: how much of Markdig’s parser suite can be replaced by Doccer-native collect → pair → laminarize → select loops before a conventional continuation/AST layer is required.

That experiment is exactly the right pressure test for whether Doccer is a general interval/claim engine or still a document-shaped toolkit.

## Practical sequencing

| Step                                | Role                                                                                |
| ----------------------------------- | ----------------------------------------------------------------------------------- |
| Finish K8                           | Kernel MVP story closes                                                             |
| Package/split Doccer                | Vendoring becomes real                                                              |
| MathDig math-channel pilot          | Smallest high-value consumer; pairing + collectors + channel stamps                 |
| MarkPig block/inline experiment     | Challenge Markdig parity under Doccer-native means; keep AST as optional projection |
| OffsetMap + normalization producers | Math channel and markdown both need honest loss maps                                |

Doccer approaching MVP is the right moment to plan the split. Making Markdig’s parsers a _challenge_ rather than a rewrite target is also the right posture — it keeps the kernel honest and forces the interesting question: how far claim geometry can go before conventional parsing is not a failure, but a residual you still have to name.

![](https://www.google.com/s2/favicons?domain=github.com&sz=256)

![](https://www.google.com/s2/favicons?domain=xoofx.github.io&sz=256)

![](https://www.google.com/s2/favicons?domain=github.com&sz=256)

23 sources

well part of the bitmap V lineage of doccer will be to implement XOR-based segmentation of parametric delimiter patterns, and an application of this capability will be to recursively unpack nested delimitated zones given some set known delimiter tokens e.g. #'s and --- and and whatever else a document might present

Thought for 31s

Yes — and most of the substrate for that is already frozen under V0/V1. The interesting work is the _producer layer_ above it.

## What already exists

D46 closed exactly the numerical primitives this story needs:

| Primitive                                         | Role in delimiter segmentation                       |
| ------------------------------------------------- | ---------------------------------------------------- |
| BooleanVector.Xor                                 | pointwise disagreement / toggle algebra              |
| PrefixParity(carryIn)                             | sparse delimiter events → dense inside/outside state |
| AdjacentTransitions                               | inverse: state → events                              |
| Chunk carry + typed Utf16PrefixParityContinuation | stream / window continuity                           |
| Utf16UnitMask + classifiers                       | material addressing of those bits                    |
| Harvest → SpanSet / claim emission                | regions become geometry or claims                    |

The material-basis inquiry already stated the doctrine in one line: **pointwise XOR, parity, prefix parity, and transitions are public numerical primitives; quote/escape/comment (and by extension any delimiter) meanings stay in named higher producers.**

So “XOR-based segmentation” is not a future invention. It is the intended first structural _consumer_ of the V lane.

## What “parametric delimiter patterns” adds

Raw prefix parity only sees a Boolean event stream. A document delimiter inventory is richer:

| Token class                       | Event shape                                     | State model                                    |
| --------------------------------- | ----------------------------------------------- | ---------------------------------------------- |
| $$…$$, \`…\`, quotes              | same-token toggle                               | 1-bit prefix parity                            |
| {…}, \[…\], $(…)$ style pairs     | distinct open/close                             | stack / Pairing (already landed)               |
| ATX # headings, --- rules, fences | line-anchored openers (sometimes paired fences) | classification + line topology + policy        |
| Nested heterogeneous zones        | outer region restricts inner inventory          | **recursive restriction**, not one global mask |

“Parametric” is the right word: the token set is data (inventory), not hard-coded kernel opinion. That matches Doccer’s collector doctrine — recognition rules arrive as inventories; the engine supplies mechanisms.

## Recursive unpack as composition, not one op

The pipeline you are pointing at is roughly:

text

Copy

```
delimiter inventory
  → classify token starts/ends (multi-unit patterns → event masks)
  → valid-toggle derivation (escapes, line anchors, left-flanking rules as named policy)
  → prefix parity / pairing (per family)
  → region masks or paired claim edges
  → restrict next inventory to interior (or exterior) of selected regions
  → recurse
```

Two important limits already written into the V contracts:

1. **Prefix parity does not do nesting depth.** One bit only gives alternate inside/outside for a toggle family. Nested brackets need integer depth or the existing Pairing.Pair stack. Mixing those quietly would be a design flaw.
2. **Delimiter legality and pairing are not part of the scan.** Unmatched $$, fence mismatches, and “this # is not a heading” are residual / policy outcomes of the _producer_, not failures of PrefixParity.

So recursive unpack is orchestration over:

- V masks + prefix parity (toggle families, interior suppression),
- Pairing (true open/close nesting),
- collectors / classifiers (parametric token recognition),
- region restriction (next pass only sees admitted interiors),

with every stage keeping basis, policy stamp, and residual visible.

## Why this matters for MarkPig / MathDig

This is the concrete bridge from the “implement Markdig without conventional parsing” challenge:

- Math channel: $$ / $ zones via toggle masks → harvest math claims → residual for unmatched delimiters.
- Markdown structure: fence/heading/hr inventories as parametric classifiers; nested code-vs-prose as recursive region restriction; emphasis/links as tighter inline inventories inside leaf regions.
- Structural characters _inside_ a delimited zone are suppressed by mask algebra before the next collector runs — the simdjson move, generalized to document delimiter families.

You do **not** need a Markdig-style BlockProcessor state machine as the kernel’s model of the document. You need honest inventories + V segmentation + pairing + recursion at the orchestration layer (MarkPig/MathDig), with Doccer supplying the exact, residual-bearing mechanisms.

## Placement on the arc

| Layer                                      | Status                                                        |
| ------------------------------------------ | ------------------------------------------------------------- |
| Raw XOR / prefix parity / transitions      | **Landed (V1)**                                               |
| UTF-16 unit masks, classify, harvest       | **Landed (V1)**                                               |
| Named delimiter-toggle producers           | Not yet — first structural V consumer                         |
| Parametric multi-unit token classification | Inventory + classifier work (can start as portable reference) |
| Recursive zone unpack orchestration        | Consumer/adapter (MarkPig/MathDig), not a new kernel sort     |
| V2 accelerated scan (word cascade / CLMUL) | Evidence-gated later                                          |
| True nested open/close                     | Already Pairing; compose with masks, don’t replace            |

K8 remains the kernel integration close. This V-lineage application does **not** wait on K8; it waits on a named delimiter-segmentation producer contract above V1, then on consumer recursion. That is exactly the kind of independent lane D41 carved out — and it is one of the strongest justifications for splitting Doccer as a vendored capability library once packaging is clean.

im obviously not going to introduce domain knowledge into doccer's agnosticism, but i can introduce a delimiter concept generically in it, for accepting domain-specific delimiter tokens or syntax

Thought for 26s

Yes. That boundary is the right one, and it already matches how Doccer admits recognition.

## What D32 already forbade vs what you are proposing

D32 closed pairing with an explicit non-goal:

> no repair, recovery search, containment, parenthood, **delimiter vocabulary**, or Lean activation

“Delimiter vocabulary” means kernel-owned names and meanings (Heading, MathFence, HrRule, built-in #/$$ tables). Pairing only sees **roles on selections** plus a caller PairingPolicy. It never decides what a token _is_.

A **generic delimiter mechanism** is different:

| Layer                | Who owns it        | Example                                                              |
| -------------------- | ------------------ | -------------------------------------------------------------------- |
| Token / pattern data | Caller inventory   | opaque specs: string $$, regex for ATX openers, open/close key pairs |
| Mechanism            | Doccer             | locate events → masks → toggle regions or stack pairs → residual     |
| Meaning              | Adapter / consumer | “this region is math,” “this is a heading”                           |

That is the same shape as PatternRule inventories and UnitClassifierStamp: recognition arrives as data; the engine supplies deterministic geometry and residue.

## What can honestly live in the kernel

**In bounds (domain-neutral mechanism):**

1. **Parametric token specs as data** — literal multi-unit sequences, optional open/close pairing keys, toggle vs paired family, scope (whole master / lines / region set). No kernel enum of document constructs.
2. **Event production** — classify positions of those tokens into Utf16UnitMask / claim selections under a named classifier stamp.
3. **Toggle segmentation** — valid event mask → PrefixParity → inside/outside state → harvest regions. Unmatched final state is residual/evidence, not a fixed “error meaning.”
4. **Paired segmentation** — open/close selections → existing Pairing.Pair under a caller policy.
5. **Geometry-only constraints as named policy** — line-anchored, alone-on-line, min/max run length, must not straddle exclusions. These evaluate span facts; they do not know Markdown.
6. **Recursive restriction** — next inventory runs only inside (or outside) a prior SpanSet / selection. Composition, not a new sort.

**Out of bounds (domain knowledge):**

- Built-in tables that # means heading or $$ means math
- CommonMark left-flanking / emphasis priority as engine defaults
- Kernel kinds for Heading / FencedCode / MathBlock
- Silent repair of mismatched fences

Kinds on _emitted claims_ can still be strings supplied by the inventory ("math-delim", "fence-open"). That is evidence labeling from data, not ontology.

## How this sits on the existing surface

You mostly do **not** need a new carrier sort. You need a named producer that composes what is already closed:

text

Copy

```
inventory (data)
  → classify / collect events
  → [optional] escape or validity filter (named policy)
  → PrefixParity  (toggle family)
     or Pairing.Pair  (open/close family)
  → regions / match edges + residue
  → restrict scope → recurse
```

Whether that producer is public as something like DelimiterSegmentation / ToggleRegions, or stays a documented recipe over V + Pairing until MarkPig/MathDig force a stable call path, is a packaging question. Doctrine-wise, either is fine **as long as tokens remain data and meaning stays outside**.

## Admission test (D10)

| Criterion                     | Holds if…                                                     |
| ----------------------------- | ------------------------------------------------------------- |
| Deterministic                 | inventory + policy + master fix the result                    |
| Eliminates repeated work      | every adapter stops reimplementing toggle/pair/restrict loops |
| Preserves literal material    | only reports geometry; does not rewrite text                  |
| Decides nothing about meaning | no built-in document semantics; residual is visible           |

That passes. Smuggling a Markdown or KaTeX vocabulary into the kernel would fail the last test.

So: **generic delimiter concept in Doccer, domain tokens as parameters — yes.** That is an inventory-driven structural producer on top of V and Pairing, not a retreat from agnosticism and not a reopening of D32’s ban on delimiter _vocabulary_.

![](https://www.google.com/s2/favicons?domain=raw.githubusercontent.com&sz=256)

![](https://www.google.com/s2/favicons?domain=raw.githubusercontent.com&sz=256)

![](https://www.google.com/s2/favicons?domain=raw.githubusercontent.com&sz=256)

4 sources

something related that i want to explore is effectively leaning into doccer's parsing capabilities in the face of adversity-- the engine presents theorical means to parse documents in a fault tolerant way naturally, and could also be used for repairing syntax errors in any given file, like a linter that fixes things, given the right internal routines for resolving missing delimiter positions like a stray '{' in powershell. combine this with an outside-in then inside-out sweep over a document and itmight be possible to localize such failures and repair

Thought for 13s

This is a strong fit for Doccer’s _epistemology_, and a careful non-fit for silent kernel behavior. The useful split is **localize vs repair**.

## What Doccer already gives you for free

Fault-tolerant _recognition_ is already native:

| Mechanism                         | What adversity looks like                                                                               |
| --------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Pairing residue                   | unclosed opens, dangling closes, top-only mismatches — complete partitions of the input, no silent drop |
| Prefix-parity final state         | unmatched toggle family (odd $$, unclosed quote stream) as carry/residual, not a crash                  |
| Laminar / packing / cover         | crossing residue, gaps, overlap — structure fails _locally_ with named evidence                         |
| Collectors + transactional commit | bad rules don’t partially corrupt the batch                                                             |
| Region restriction                | re-run inventories only inside surviving regions after an outer failure                                 |

Nothing in that list “fixes” the file. It **confesses** where the structure failed and keeps every category of failure addressable. That is the theoretical base for adversity-tolerant parsing: the engine does not require a globally well-formed document to return useful structure plus residual.

D32 was explicit that pairing itself does **not** search for recovery, repair, or containment. That was the right kernel choice: the reference operation stays strict and residual-complete so repair policies have a clean substrate to judge against.

## Localize vs repair

text

Copy

```
outside-in / inside-out sweeps
        ↓
  localization  (Doccer-native)
        ↓
  repair proposals  (orchestration / named policy)
        ↓
  optional materialization  (K7 plan, not silent rewrite)
```

**Localization** — domain-neutral, high confidence:

- Outside-in: parse coarsest delimiter families first (e.g. fences, balanced top-level regions); suppress or quarantine interiors that fail; continue on siblings.
- Inside-out: within a failed region, run finer inventories; shrink the residual to the smallest spans that explain the failure (stray {, missing closer, crossed pair).
- Multi-hypothesis only as _evidence_: alternate open/close role assignments or alternate toggle inventories can be run as separate stamped queries; the engine does not pick a winner.

**Repair** — judgment, must stay outside the kernel’s silent path:

- “Insert } at offset _k_” is a chosen edit, not a fact about the source.
- Ranking candidate insertion points (end of line, before next sibling, matching indentation depth) is policy.
- Accepting a repair changes material → that is a **producer** (new master + map), ideally through K6/K7-shaped evidence, not an in-place mutate of the input master.

So Doccer can power a linter-fixer **architecture** without becoming a linter-fixer **by default**.

## PowerShell stray { as a worked shape

1. **Inventory (data):** open {, close }, plus string/quote toggles so braces inside strings are suppressed (V masks + prefix parity).
2. **Strict pair** on the non-string brace stream → UnclosedOpens / DanglingCloses / mismatches.
3. **Localize:** for each unclosed open, compute candidate close sites from geometry policy alone — e.g. before next top-level sibling, at line end, at EOF, at nearest cover gap. Each candidate is a _hypothesis span_, not a decision.
4. **Score in orchestration:** indentation depth, nearest matching construct, minimal edit distance, “does re-pair go green?” — consumer policy.
5. **Repair as explicit plan:** chosen insertions/deletions become a RewritePlan (or adapter-level edit list) → new master + origin/unused residue. The original master stays intact for audit.

The engine never decides that the stray { “should” close at line 40. It can tell you every structural failure and every geometrically plausible repair locus; the fixer policy picks and materializes.

## Outside-in then inside-out

That sweep pattern is orchestration over existing stages:

text

Copy

```
coarse delimiter inventory
  → pair / toggle / restrict
  → well-formed regions (accepted) vs residual regions (failed)
  → on residual only: finer inventory or alternate policy
  → shrink residual / emit repair candidates
  → optional second outside pass after provisional repairs
```

Useful properties:

- Failures quarantine; siblings still parse.
- Recursion depth is data-driven (inventory stack), not a hidden document schema.
- Re-pair after a provisional edit is an ordinary second query — differential evidence for “this repair closed the residual.”

## Doctrine guardrails

| Do                                         | Don’t                                            |
| ------------------------------------------ | ------------------------------------------------ |
| Keep strict pairing as the reference       | Add recovery search inside Pairing.Pair          |
| Name repair policies and stamp them        | Silent auto-fix in the kernel                    |
| Emit candidates + residual as evidence     | Infer “the” missing delimiter position as fact   |
| Materialize repairs as new masters / plans | Mutate the source master in place                |
| Let domain inventories supply tokens       | Encode PowerShell/Markdown repair lore in Doccer |

This is the same residual-visibility rule that keeps claims honest: adversity is first-class data; resolution is explicit policy.

## What would need to be added (still generic)

Not a repair engine — a few **mechanisms** that make localization/repair producers less ad hoc:

1. **Candidate locus generator** — given unclosed opens + a named geometry policy, emit ordered candidate close (or open) offsets/spans without ranking meaning.
2. **Re-query differential** — run the same pairing/toggle problem after a provisional edit plan; report residual delta (closed vs remaining).
3. **Scoped residual algebra** — intersect/subtract residual selections with regions so outside-in sweeps stay exact-basis clean.

Those still decide nothing about PowerShell. A PowerShell fixer adapter would own brace–keyword association, here-strings, and “what a good fix looks like.”

**Bottom line:** Doccer’s natural posture under adversity is **fault-localizing structure with complete residue**, not fault-hiding parse trees. Combine that with outside-in/inside-out orchestration and explicit edit materialization, and you get a serious substrate for syntax repair tools — while the kernel stays a witness, not an opinionated fixer.

and i wonder about how doccer might abstractly handle the hard part of visitor mechanics in a powershell-like AST implemented by markpig and mathdig

Thought for 13s

The hard part of visitors is rarely “walk every node.” It is **context, control, partial structure, and rewrite identity** while the tree is incomplete or adversarial. Doccer does not replace MarkPig/MathDig’s AST types; it can absorb several of the failure modes those visitors usually paper over.

## What is actually hard about visitors

| Hard problem            | Classic visitor pain                                             |
| ----------------------- | ---------------------------------------------------------------- |
| Traversal control       | skip subtree, stop, revisit, multi-pass                          |
| Context threading       | scopes, binders, “am I inside math?”                             |
| Partial / error trees   | missing closers, recovery nodes, null children                   |
| Parent/ancestor queries | parent pointers vs pure functional trees                         |
| Cross-cutting structure | every reference, every delimiter pair, not only the spine        |
| Rewrite                 | mutate in place vs return new tree; identity of nodes after edit |
| Order sensitivity       | pre vs post; children before attributes; pipeline stages         |

A PowerShell-like AST (script blocks, nested scopes, pipelines, soft errors) amplifies all of these: blocks are both structure and scope, and real input is often not well-formed.

## Doccer-shaped reframe

Treat the AST as **one projection** of richer, many-sorted evidence—not the sole source of truth.

text

Copy

```
source master
  → claims / pairs / hierarchy / residuals   (Doccer)
  → AST nodes as views over ordinals         (MarkPig / MathDig)
  → “visitor” = named queries + policies over those carriers
  → rewrite = explicit plan → new master / new claims (K7-shaped)
```

Then several visitor hard parts become ordinary Doccer operations:

### 1. Traversal control → selections and restriction

Instead of Visit returning a control enum:

- **Subtree** = ClaimSelection or region SpanSet for a node’s extent
- **Skip** = subtract that selection from the worklist
- **Only errors** = residual selections from pairing / laminar / cover
- **Outside-in** = coarse inventory first; restrict next pass to failed regions

The walker is a worklist over ordinals, not a recursive call stack that must encode every policy in return values.

### 2. Context → stamped derived views, not ambient visitor fields

Visitor fields (currentScope, inString, mathDepth) are opportunistic global state. Doccer-native analogues:

| Visitor context                | Doccer-side                                                   |
| ------------------------------ | ------------------------------------------------------------- |
| “Inside which block?”          | HierarchyView / nearest-container projection (explicit edges) |
| “Inside math / string?”        | unit-mask / toggle region membership at this span             |
| “Which scope binds this name?” | resolution map or fact/support over a named population        |
| “What policy is active?”       | retained policy object on the query result                    |

Context becomes **queryable structure** computed under named policies, not mutable bags on a visitor instance. Multi-pass is re-query, not deeper field mutation.

### 3. Partial trees → residual as first-class children

PowerShell-like and markdown/math pipelines both need error nodes. Doccer’s bias is stronger: failures are **complete residual partitions**, not optional ErrorStatement leaves you might forget to handle.

A MarkPig AST can still expose ErrorNode, but its payload should be residual evidence (unclosed open, mismatch pair, crossing span), not a string message alone. Visitors that only implement happy-path node types are then visibly incomplete against the residual selection—the harness can require that every residual ordinal is either attached to an error node or explicitly ignored under a named policy.

### 4. Parent / ancestor → explicit hierarchy, not pointer chasing

The classic AST hard choice: store parent pointers (mutation, aliasing) vs pure trees (expensive ancestor queries).

Doccer’s K4c posture: **parenthood is explicit evidence**, not inferred from geometry. HierarchyView carries edges; NearestContainers is one policy-gated projection. MarkPig can:

- build AST children from laminar/pairing structure, and
- keep parent/ancestor as queries over the same hierarchy carrier,

so visitors ask NearestContainers / path-to-root instead of depending on mutable Parent fields. Geometry validates containment; it does not silently invent edges.

### 5. Rewrite → materialization, not visit-and-mutate

In-visitor mutation is where PowerShell-like rewriters get brittle (identity, enumeration invalidation, half-edited trees).

Doccer path:

1. Visitor (orchestrator) **collects** intended edits as data.
2. Edits become an ordered plan (K7-style pieces, or an adapter edit list).
3. Materialize (or MarkPig’s analogue) yields a **new** master / claim basis.
4. Origins / unused residue record what changed; old AST remains auditable.

“Visit” stays read-only analysis. “Rewrite” is a separate producer with residual. That matches the fault-tolerant repair story: propose loci, then materialize under policy.

### 6. Double dispatch → kind inventories + policy objects

C# visitors fight the expression problem (new node type vs new operation). Doccer does not solve OOP design, but it pushes **behavior into named policies and inventories**:

- node kinds as claim Kind / fact domain strings from data
- operations as queries: Pair, Select, Admit, mask restrict, saturate
- MarkPig registers _adapters_ from kind → Doccer query, rather than one giant VisitX hierarchy per feature

New analysis = new policy or new inventory consumer, not necessarily a new visitor class hierarchy.

## What MarkPig / MathDig still own

Doccer should not grow a DoccerVisitor<T> or a PowerShell AST library.

| MarkPig / MathDig                                 | Doccer                                                    |
| ------------------------------------------------- | --------------------------------------------------------- |
| AST node types, pretty-printers, language surface | masters, claims, pairs, hierarchy, masks, residual        |
| Language-specific scope rules                     | mechanism for resolution maps / facts once rules are data |
| Choosing a repair                                 | candidate loci + re-pair differential                     |
| Surface syntax inventories                        | generic delimiter / collector execution                   |

MathDig’s KaTeX channel is the smaller case: math zones as paired/toggle regions, inner math tokens as restricted inventories, “visitor” over math = queries inside those masks. MarkPig’s full markdown/PowerShell-like tree is the larger case: same pattern at several strata (document → block → inline → math).

## Abstract pattern (the useful one)

text

Copy

```
for stratum in outside_in(inventories):
    events  = classify(stratum.tokens)          # data
    structure = pair_or_toggle(events, policy) # mechanism
    ast_layer = project(structure)             # MarkPig nodes over ordinals
    residual  = structure.residue
    if residual:
        localize(residual)                     # inside-out refine
        # optional: repair candidates → plan → materialize → re-enter
```

The “visitor” is the **loop and the policy choice**, not a recursive double-dispatch spine. The hard mechanics—partiality, control, context, rewrite identity—sit on carriers that already treat adversity as data.

## Bottom line

Doccer abstracts the hard part of visitor mechanics by refusing to make the AST the only carrier:

- **Control** → selections / region restriction
- **Context** → hierarchy, masks, resolution, stamped policies
- **Adversity** → residual partitions as mandatory structure
- **Rewrite** → explicit plans and new bases, not in-order mutation

MarkPig and MathDig still implement the language AST and the judgments. They lean on Doccer so visitors do not have to simultaneously be parsers, error-recoverers, scope managers, and rewriters. That is the same doctrine as the rest of the kernel: mechanisms and evidence inside; meaning and repair policy outside.

i was only suggesting that doccer's engine would drive the backend of my ASTs, from the beginning

Thought for 6s

Understood — simpler than I made it.

Doccer is the structural backend from the start. MarkPig and MathDig ASTs are projections over Doccer carriers (masters, claims, pairs, hierarchy, masks, residual), not parallel trees that Doccer later “supports.”

So:

- **Parse / structure / adversity** → Doccer engine
- **AST nodes** → thin views over ordinals, extents, and evidence stamps
- **Visitors / rewrites / language meaning** → MarkPig and MathDig, consuming those views

No second structural source of truth, and no need for Doccer to know it is backing an AST. The engine just runs its mechanisms; the AST layer is one consumer shape among others.

Refine the structural separation clarity

Thought for 7s

## Structural separation

| Layer                  | Owns                                                                                                                          | Does not own                                                                                          |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| **Doccer**             | Masters, claims, selections, pairs, hierarchy, masks, residual, named policies-as-parameters, materialization plans           | Document kinds, language meaning, AST node types, repair choices, markdown/math/PowerShell vocabulary |
| **MarkPig / MathDig**  | AST node types, inventories of tokens/kinds, visitor/orchestration policy, pretty-print, language judgment, repair acceptance | A second structural geometry; silent re-parse that disagrees with Doccer evidence                     |
| **Inventories (data)** | Delimiter tokens, pattern packs, kind labels, open/close keys                                                                 | Engine behavior                                                                                       |

### One structural source of truth

text

Copy

```
TextMaster
  └─ Doccer carriers (claims, pairs, masks, hierarchy, residual)
        └─ AST nodes = views over ordinals / extents / stamps
              └─ visitors & rewrites consume views; rewrites re-enter via plans
```

- Doccer never builds or stores AST nodes.
- The AST never holds geometry that is not recoverable from Doccer carriers (or an explicit residual for what failed).
- If the AST and Doccer disagree, the AST is wrong or incomplete—not a peer model.

### Mechanism vs meaning

| Concern                                            | Home                                                                    |
| -------------------------------------------------- | ----------------------------------------------------------------------- |
| Locate, pair, toggle, restrict, residual partition | Doccer                                                                  |
| “This region is math / a heading / a script block” | Inventory kind + consumer                                               |
| “Insert a closer here”                             | Consumer policy → explicit plan → new master                            |
| Parent links, scope, traversal order               | Queries over Doccer hierarchy/selections, projected into AST ergonomics |

### Boundary tests

1. **Graduation** — If MarkPig were deleted, Doccer still runs the same jobs with inventories and policies as data.
2. **Rewrite** — Site adapters collapse to capability calls + store entries + domain policy; refusal means a missing Doccer surface or permanent adapter logic.
3. **Adversity** — Failures appear as Doccer residual first; AST error nodes are projections of that residual, not a parallel error channel.
4. **Agnosticism** — No kernel delimiter vocabulary; tokens enter only as parameters.

That is the separation: **Doccer is the structural backend; MarkPig/MathDig are domain projections and judges over it—not co-equal structure engines.**
