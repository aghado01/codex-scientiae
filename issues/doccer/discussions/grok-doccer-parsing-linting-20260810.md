# yea, with doccer finally approaching something like an MVP, i might actually split it off into its own repository/project so that i can vendor it out to other projects of mine. like i hope that doccer will be able to implement my markpig markdown and its most esteemed visitor, mathdig's katex math-channel parsing needs without much conventional parsing. one of my challenges to doccer will be to implement markdig's parsers from scratch using doccer-native capabilities

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

# well part of the bitmap V lineage of doccer will be to implement XOR-based segmentation of parametric delimiter patterns, and an application of this capability will be to recursively unpack nested delimitated zones given some set known delimiter tokens e.g. #'s and --- and and whatever else a document might present

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

# something related that i want to explore is effectively leaning into doccer's parsing capabilities in the face of adversity-- the engine presents theorical means to parse documents in a fault tolerant way naturally, and could also be used for repairing syntax errors in any given file, like a linter that fixes things, given the right internal routines for resolving missing delimiter positions like a stray '{' in powershell. combine this with an outside-in then inside-out sweep over a document and itmight be possible to localize such failures and repair

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

# i was only suggesting that doccer's engine would drive the backend of my ASTs, from the beginning

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
