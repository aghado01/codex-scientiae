---
format: Structural
exported_at: 2026-08-04T09:54:22.1710943Z
exchanges: 34
user_label: Aipithicus
sessions:
  - 0dfbe3e7
models:
  - claude-fable-5
  - claude-opus-5
exclude:
  - thinking
  - synthetic
  - timestamps
  - session-markers
  - exchange-markers
  - tool-calls
  - tool-results
  - subagents
---

# so looking at latex-ingest in its current form, and some notes i have on how i want to approach refactoring it to correct layers of design mistakes that have accreted in my initial development efforts, i have for example an outline of how it works (or at least, how it worked a few days ago) `D:\aghado01\codex-scientiae\issues\latex-ingest\discussions\latex-ingest-workflow-20260730.md` , some critiques and meta analysis of problems i've identified and how to approach code analysis and subsequent redesign of the process `D:\aghado01\codex-scientiae\issues\latex-ingest\discussions\claude-working-backwards.md` + `D:\aghado01\codex-scientiae\issues\latex-ingest\discussions\operations-oriented-extraction.md`, i also have some proximal work on a specific item relating to reframing how a relationship graph yielded by parsing latex can be captured in a docgraph or "refgraph" `D:\aghado01\codex-scientiae\issues\latex-ingest\discussions\refs-consolidation-20260731.md`, and im trying to scope out a plan for refactoring. and i'm intentionally doing this in parallel with doccer development, and taking a moment to focus on diagnosing problems and identifying how some things can be reframed in the pipeline

Here's my read of where the scoping problem actually sits.

## The diagnosis is done; the scoping problem is chronology

The docs aren't five parallel notes — they're an instrument kit plus one specimen, written in order of discovery: working-backwards gives the **method** (knowability binary, guards as evidence about their upstream), operations-oriented-extraction gives the **carving rule** (contract stateable independently of the product), the latent-manuscript doctrine names the **disease** (premature serialization) and the target representation, and refs-consolidation is the one **worked specimen** where all three instruments have already been applied to real code.

The consequence of that chronology is the thing a plan has to deal with: the 7/31 briefs propose fixes to machinery the 8/2 doctrine condemns. The guards brief's restore-boundary assertions harden the five placeholder families; the doctrine says those families die entirely under the inversion ("the piece boundary *is* the protection"). Neither doc is wrong — but the fix lists' *status* changed after they were written, and sorting the proposed work by whether it survives the inversion is, I think, the spine of the plan. Three piles fall out:

**Survives everything** — worth doing now, feeds both futures: the golden pinning (refs §4 step 1 — the resolved label→number table and rendered ref text for a fixture, the one invariant no path may move), the pure subtraction (the discarded `thm` numbering in `Build-LabelMaps`), and the refs *model schema itself* — more on that below. The stores survive too; cues-as-data is already the doctrine's discipline.

**Interim hardening of condemned machinery** — the ×5 restore assertions and the §4 guard candidates. Still worth doing: they're a few lines each and they convert silent corpus defects into loud converter failures for however long the string pipeline remains production. But the plan should label them as triage on a building slated for demolition, so they're never mistaken for reshape progress.

**The inversion itself** — not step-plannable yet, and I don't think the plan should pretend otherwise. What it *can* do is state entry criteria: node/channel schema stabilized through the toy specimens (the KisungYou chunks file being explicitly schema-research, never production path), the DLL-reach adapters far enough along that assembly-side capture has a real substrate, and a refreshed fixture battery — which is currently gated on the fresh test materials you're supplying while gauntlet runs are paused.

## One reconciliation the plan has to make explicit

Refs-consolidation step 5 says `tex-docgraph` becomes a **projection of** the model. The doctrine's level-separation says the docgraph is the source-encoded relational overlay — **evidence the surjection consumes**. Those point in opposite directions: derived-from vs. input-to. But I think the brief's own collect→resolve split already resolves it — collect *is* the source-sort capture (the docgraph's rightful home, pointer sites as this source encodes them), resolve *is* the realization under the counter model. What retires isn't the docgraph's capture role; it's the docgraph as an independent second scan built beside the tangle. Read that way, the refs brief's two-stage ordering anticipated the two-sorted surjection at reference grain — which means the refs schema work is doctrine-aligned as-is and can proceed as the first channel of the manuscript graph to get a real schema.

## A candidate admission rule for pre-inversion work

Where the refs stage gets *built* is the genuine fork: bolted into the current string pipeline now (steps 3–5) versus born later in forward assembly. My tentative read is that building it in place isn't wasted, because the artifact contract is identical either way — consumers read the model, and the inversion later swaps the *producer* under a stable artifact, the same move as one-tap-two-consumers. What makes refs safe to build now, when the node stream isn't, is that **its collect pass reads the source side** — exactly where the facts are knowable. That generalizes into a rule the plan could adopt: pre-inversion construction is admissible iff the stage reads source, never emitted text. Refs qualifies. The subject index qualifies only for byte offsets (a final-text fact, as the brief already concedes). A node/spine emitter from the current pipeline does *not* qualify — it would be mining output, the no-retrospective-dignity trap. Offered as a candidate, since it's my extension of your binary, not something in the docs.

## On the doccer parallelism

The sorting above keeps the coupling honest: piles one and two touch doccer not at all; the schema/specimen work is where the provisional DLL-reach adapters live and where census questions get asked per-item, in the moment; only the inversion pile leans on doccer maturation (D19 weave, F2 persistence), and it's the pile with entry criteria rather than dates. Traffic runs both ways — the reshape is doccer's witness generator (the queued macro-expansion demo being the whole vision in miniature), so the parallelism isn't just tolerable, it's load-bearing.

The decisions that are actually yours to make, whenever you're ready: which fixture(s) anchor the golden pinning given the fresh materials situation; whether the interim-hardening pile is a go at all; and whether/when to mint `issues/latex-ingest/planning/` — the doctrine doc already says it graduates there, and the pile-sorted roadmap above is shaped like that tier's first content. Happy to draft any of that, or to start with the two moves every path agrees on (pin, then delete the dead numbering), when you say so.

---

# well, what are the "survives everything" options

Enumerated, with what each one unblocks and why it can't be stranded by the inversion:

**1. Pin the semantic invariants — the falsifiability layer.** Golden tests asserting *facts of the manuscript*, not bytes of output: the full label→number table and the rendered text of every reference site (the refs brief's step 1), extendable to the other fact families — heading tree (titles, levels, order), math span inventory, figure/caption inventory. Two properties make this the anchor. Every later rung in any pile is unfalsifiable without it, per the brief's own words. And each pinned fact family is proto-schema: a golden test asserts facts, the schema names the shape of those facts — so pinning is Track C's schema work approached from the test end. The only gate is fixture choice, which is genuinely open given the gauntlet pause and your incoming materials.

**2. Pure subtractions.** The discarded `thm` numbering in `Build-LabelMaps` (removes the wrong-model-adjacent-to-live-code hazard), [md-cleanup.ps1](src/audits/md-cleanup.ps1) with its zero callers, and whatever else falls dead once invariants are pinned — the guards brief's own conclusion was that pinned invariants make dead derivations fall out without having to spot them by eye. Deletions are the one category that can't be wrong under either future. Minutes each.

**3. The refs stage, all the way through — not just steps 1–2.** Extract collect→resolve, repoint consumers (subject index reads the model; the `a08656ce` bridge resolution gets deleted), fold the docgraph's capture role into collect per the reconciliation from before. It's admissible under the source-side rule, and the artifact — `{slug}.refs.jsonl` — is the stable membrane: the inversion later re-homes where the model is *built* while every consumer keeps reading the same shape. This is the substantial one, with item 1's golden table gating each rung of the ladder.

**4. Operation carve-outs where the contract outlives the product.** From the extraction doc's own specimen list, the ones forward assembly still needs: *compile a TeX fragment* (tex-render — assembly still stashes non-encodable diagrams), *bundle markdown with assets* (md-bundle — a serializer still hands off to a bundler, whose sentinel finally becomes the backstop it always should have been), *resolve a run address*, and *read/write indexed JSONL* — which gets more central under the inversion, since the currency becomes JSONL. That last one carries a census question (should it read doccer's D13 wire?) to be asked in the moment, not pre-answered. Each of these is contract-capture and clean rebuild per the doctrine's caveat — the monolith serves as reference implementation, not source material to transplant.

**5. Schema and specimen research.** The chunks.jsonl refinement the doctrine already names — teasing math/prose/figure out of the prose bodies as first-class interleaved nodes, structural identity stamped on every row — plus the kernel taxonomy for classified typesetting spans. Zero pipeline risk, design-tier, and it's where the provisional DLL-reach adapters live. Item 3's refs schema doubles as the first channel of the manuscript graph to get fully real.

**6. Source-side loud-fail.** Malformed-source detection at parse time — your own correction in the working-backwards thread, and parse is exactly where that detection stays under the inversion — plus render validation coupled to register lowering, since math-register is shared infrastructure across lanes. These differ from the ×5 restore assertions in that they attach to *surviving* machinery.

What's deliberately not on the list despite looking attractive: the restore-boundary assertions and the subject-index skip guard (interim pile — real triage value, but they harden condemned machinery); toc-engine investment beyond pinning its artifact contract (the heading re-scan *is* the disease, and under the inversion byte offsets become a free byproduct — the serializer knows every piece's position as it writes); and any node-stream emitter bolted onto the current pipeline (inadmissible — that's mining output).

Dependencies: 2, 5, and 6 need nothing; 1 gates 3's later rungs; 4 is independent per operation. If you want a starting bias, 1+2 are the refs brief's own "safe even if the rest is deferred," and 5 is the one that feeds doccer while costing the pipeline nothing.

---

# The schema specimen example was didactic, pointing to a final JSONL IR from which markdown is easily assembled, and which contains the desired schema that has yet to be determined. we don't need to tease math out of prose, we need to extract math and prose from latex source , because once again, this isn't a markdown processing problem. markdown is the target. the JSONL IR i pointed to in that reverse engineering example was a way to inductively sketch the idea of what i'm trying to get to from latex, before markdown, in the pipeline

So item 5, restated in the right direction: the toy's role was inductive and it's complete — it gave the destination a concrete silhouette (ordered rows, `seq`/`addr`/`parent`, provenance spans) worked backwards from an output you happened to have. Nothing further gets extracted *from* it; the moment "refine the specimen" becomes a task, it's markdown processing wearing a research badge, and markdown is the target, not the material.

The schema gets determined from the LaTeX side: forward probes that walk source, capture prose and math (and captions, labels) as candidate IR rows at the moment each is knowable, and compare what comes out against the sketch. Which collapses a distinction I was holding artificially — the "schema research" item and the inversion's seed aren't two things. A disposable source-side probe emitting candidate rows *is* the inversion in miniature; the queued macro-expansion demo is the first such probe, and the DLL-reach adapters are the stated vehicle for running them. The admission rule survives unchanged, and this is actually its cleanest instance: probes read source; the toy sits beside them as a reference silhouette until the real IR, determined by what LaTeX extraction actually yields, supersedes it.

---

# the target schema is actually the latent manuscript graph in disguise, if you were to traverse it. we know that the target manuscript format can be projected to a linear reading of the paper, based on parsing and in some cases being opinionated or relying on convention to determine where to put something like figures (the ref graph should be helpful for this case). the manuscript's canonical protograph, the superset of all possible node kinds and relations is what i have to design, so that all pipeline runs map source onto it in order to realize an instantiation of it for a particular source document. the pipeline is kind of shooting blind before i have this nailed, but sorting it out also benefits from solving for things in latex parsing. the toy gave me a silhouette like you say. we know already that there are latent math and prose channels, and to some extent those can be parsed out separately in latex, for the most part. so i can assemble towards this uncertain spec without fully specifying it up front, and what i want to do is figure out how the pipeline can most directly get from source to this IR and the canonical manuscript envelope that i'm chasing

Memory's updated — protograph coinage, the IR-as-traversal identity, and the refgraph-feeds-placement connection are all recorded. Here's how the strategy question looks to me with the envelope named.

The circularity you're describing — pipeline shooting blind without the protograph, protograph design needing what parsing turns up — doesn't need to be broken; it needs an instrument that makes each side feed the other on every run. Your surjectivity audit is that instrument, taken seriously from the first probe rather than as an eventual completeness check. Each run partitions the source three ways: bytes that landed in some node's provenance, bytes classified into the kernel, and honest residue. The residue *is* the protograph design queue — every specimen in it demands either a new kind, a new relation, or a kernel classification, and admission stays your call: mint-from-witness, the same ritual doccer already runs. That's what "assemble toward an uncertain spec" becomes operationally: the superset gets designed as the closure of what source actually demands, grown by admission rather than speculated up front. The envelope is then never *wrong*, only incomplete — and its incompleteness is measured and exemplified on every run instead of discovered later.

On "most directly from source to IR": the encouraging fact is that the pipeline's source side already traverses everything the IR needs. Masks, macro expansion, environment walking — they compute the boundaries as byproducts, which the doctrine already noted for math. So the shortest path, as far as I can see, isn't new parsing; it's the same source walk with the emission discipline flipped — append rows as pieces are born, instead of mutating one string toward markdown. The parse machinery survives *as walk*; what dies is its output mode.

That makes the first probes exactly the channels you named as already-knowable: prose spine and math from the source walk, refs from the collect pass the brief already designed. And the refgraph point places refs somewhere I hadn't: it has a *second* consumer — the walk itself, consuming first-reference sites to place floats — not just reference resolution. So refs isn't merely the first channel to get fully real; it's evidence the linearization policy runs on, which moves it even further upstream than the pile-sort had it.

One discipline I'd flag as load-bearing from the very first probe: carry the remainder ledger even when it's embarrassing. A probe covering 60% of a paper with 40% honestly sorted residue does more envelope design than one covering 95% with silent gaps — the ledger is the design instrument, not a hygiene stat.

Happy to scribe this refinement into the doctrine doc alongside the earlier ones whenever you want it captured there.

---

# yea i just feel like the way the pipeline is written is that it's veering of course somewhere and i have this uncomfortable feeling that i can't shake, which is why i'm kind of thinking about it from the ground up while also trying to hold in mind the series of operations that have already been implemented trying to identify the invariants that may be implicitly correct on some level, but happening at the wrong stage or in the wrong order. This is a hard thing to untangle given how badly the first implementation was bungled. But for example, how hard would it be to assemble the prose body end to end with place holders for math spans, figures and diagrams? e.g. how hard would it be to extract and assemble the prose channel with the math spans unresolved

Short answer: **not hard at all — the pipeline already builds exactly that state, then destroys it.** Reading `ConvertFrom-Latex` closely, the thing you're describing exists transiently between [latex-ingest.ps1:1624](src/latex-ingest/latex-ingest.ps1:1624) (`Protect-LatexMath`) and [latex-ingest.ps1:1725](src/latex-ingest/latex-ingest.ps1:1725) (`Restore-LatexMath`). In that window the body *is* the prose channel with math unresolved: every prose operation — sectioning to headings, lists, emphasis, links, accents, whitespace, and the hard-wrap reflow — runs over text where math, algorithms, and verbatim are opaque slots and diagrams are already numbered markers. The code even states the invariant in its own comment: reflow "runs while math is @@LMATH/@@LDISP/@@ALG/@@VERB placeholders, so a join can never split a formula."

So your discomfort has a precise address. The protect→prose-ops→restore sandwich is channel separation, *discovered and load-bearing* — but implemented as a temporary disguise inside one string rather than as a representation. Line 1725 is where the briefly-separated manuscript gets collapsed back so that everything downstream can re-mine it. The invariant is correct; the stage structure around it is what's wrong — which is your "implicitly correct at the wrong stage or order" hypothesis, confirmed in the concrete.

What the probe would actually take, honestly scaled:

- **Math slots: nearly free.** Stop before the restore and emit what's in hand — the body, plus the math store joined against one ordered walk of the emitted text for marker occurrences (positions are only final at emission, since the prose keeps mutating after slot creation; that whole problem evaporates later under row-native assembly, but a single post-emission walk is fine for a probe).
- **Diagrams: already done, right-shaped.** The tikz/xy stash + numbered marker + the `{slug}.diagrams.jsonl` worklist the driver already writes is the one channel that *already* has slot form — skip the render ladder and rung 3's flagged markers just stay, which the ladder explicitly supports.
- **Figures: the one real gap.** They currently dissolve — `\includegraphics` becomes an inline image link at [latex-ingest.ps1:1670](src/latex-ingest/latex-ingest.ps1:1670), captions become italic lines, and the figure env wrappers are stripped at 1679 — so the figure-as-bundle (graphics + caption + label) is never captured as a unit. The fix is to stash figure envs exactly the way tikz envs are stashed at [latex-ingest.ps1:1525](src/latex-ingest/latex-ingest.ps1:1525); the pattern is sitting in the same file. Modest.

Scratch-probe total: a day-ish, mostly the figure stash and the emission driver, since `ConvertFrom-Latex` needs only a way to return the pre-restore state and its stores.

The diagnostic payoff is what the probe would *surface*, because the mid-state isn't as clean as "prose + unresolved math," and each impurity is a specimen of the thing you're hunting:

- **Refs are baked in before math capture.** `Resolve-Refs` (1606) runs before `Protect-LatexMath` (1624), deliberately, so `\eqref` inside math gets rewritten — and equation `\label`s are stripped at 1617 before capture. So slot contents would carry resolved English and no labels: resolution happening before capture, the exact inversion the refs brief diagnosed, visible in the math channel too.
- **"Unresolved" today means half-resolved.** Stored math is post-macro-expansion and post-KaTeX-compat (all of that runs 1543–1587, before protection), while register lowering happens downstream. The slots hold partially realized math, not author math — realization is smeared across stages instead of being a stage.
- **The store is a flattened tree pretending to be a dictionary.** The 8-pass restore loop exists because store entries reference other markers. Under emission that stops being a bug and becomes parent/child structure — but it shows nesting was never modeled, only iterated away.

None of that blocks the probe; it's what the probe is *for*. It would convert the feeling you can't shake into a finite specimen list, and simultaneously be the first forward test of the prose channel's assemblability. If you want, I can spike it as a scratch probe against one of the fixture papers — say when you've picked which paper you want as the test material.

---

# ok lets try the probe then

The probe is built, run, and the seam is committed (`44b2864`). Here's what came back.

## The answer to "how hard": an afternoon, and it holds together

`ConvertFrom-Latex -ChannelProbe` now stops at the pipeline's own mid-state and hands back the assembly instead of collapsing it — 28 gated lines, production path inert. The driver ([probe-prose-channel.ps1](scratch/probe-prose-channel.ps1), gitignored per scratch convention) emitted three artifacts under `artifacts/latex-ingest/probe/2408.16741v2/`: the prose channel (`.prose.md`), the slot inventory in reading order (`.slots.jsonl`), and the report (`.probe-report.json`).

**The prose channel assembles end to end, and the slot algebra is closed.** 1301 slots in the body (1206 inline math, 76 display, 12 figures, 7 algorithms), and running the placeholder check in *both* directions — text-driven and store-driven, the direction lesson applied — found **zero leaked markers and zero orphaned store entries**. The arithmetic closes exactly: 1429 math store entries = 1282 in the body + 147 reachable through nesting; all 13 diagrams are children of the 12 figure slots. The prose itself reads as finished markdown — resolved citations, bold theorem run-ins, display slots standalone on their own lines (the LDISP/LMATH prefix split visibly doing its job through reflow).

**The nesting edges are document structure, not bookkeeping.** Figure→diagram (the diagram *is* the figure's graphic), algorithm→math, math→math. `@@FIGENV0@@` captures exactly what the doctrine wants a figure node to be: the whole float with `\label{fig_example}` intact, caption with its math still raw, diagram as a child. What the 8-pass restore loop treats as a nuisance is, under emission, the parent/child relation for free.

**The remainder ledger, on its very first outing: 3 residual TeX commands in 61k chars, each one informative.**
- `\FloatBarrier` — pure layout; kernel, classify-and-drop.
- `\appendix` — an *unmodeled structural signal*: the appendix heading emitted fine but appendix-mode renumbering is nowhere in the model. A protograph design item found by residue, exactly the growth mechanism we discussed.
- `\cite` — a genuine defect specimen: `**Theorem 3.5 ({\cite[Theorem 3.1).** {pers_lap}}]` — the author put a citation with nested brackets in the theorem's optional-argument title, and the cross-ref walk's title capture isn't bracket-aware, so it shredded mid-`]`. Also sighted: a stray-brace-group residue class (`{and the supports ...}` leaking author braces into prose) that the backslash scan doesn't count.

For the reshape, this settles the feasibility question empirically: the string pipeline's front half already computes the channel decomposition — what's missing is only that it *emits* rather than collapses. The predicted entanglements showed up on schedule (refs baked in pre-capture, math slots holding fully register-canonicalized markdown rather than author math), and they're now visible artifacts you can read rather than an uncomfortable feeling. Natural next probes when you want them: run it across the other staged tarballs to grow the residue ledger, or eyeball `.slots.jsonl` against the KisungYou silhouette to start pressure-testing the row schema.

---

# Floatbarrier might actually be some useful furniture evidence, like a little text blurb or something. if we can bound things inside of a float barrier and cross ref against the doc ref graph, it might be helpful

Captured. In stream terms your "little text blurb" is exactly what it would be — a content-free evidence row (`kind: float_barrier`, `seq`, `char_offset`) interleaved in the slot inventory, so the walk and the audit can both consume it. The probe could emit those rows for pennies — the residue scan is already tripping over the command — say the word and I'll add barrier rows (and pull the float specifier out of each FIGENV stash as a field) on the next probe pass.

---

# so in this case author is using float barrier like an invisible page break in a word document

So in this paper the author's one gesture reads cleanly under the rule: they drew a single order-assertion across the whole document — "the appendix starts with a clean float queue" — and that's the entire placement-evidence yield of the source, which is exactly why it should land in the stream as one small evidence row rather than vanish as furniture.

---

# and also yes, lets `add barrier rows (and pull the float specifier out of each FIGENV stash as a field) on the next probe pass` , as well as capture field notes and insights from the probe

Pass 2 is landed and committed (`8d7848b`), with the field notes at [probe-prose-channel-20260802.md](issues/latex-ingest/discussions/probe-prose-channel-20260802.md).

What changed and what it showed:

- **Barrier rows**: `\FloatBarrier` and the `\clearpage`-family flush rider now emit as content-free evidence rows. The specimen's single barrier is addressable at seq 1042, sitting exactly where the author meant it — between the last body paragraph and the appendix.
- **Float specifiers as fields**: every `FIGENV` row carries `spec` and `label`. The census on this paper: 7×`[H]`, 3×`[ht]`, 1×`[h]`, 1 unspecified — a pin-heavy author, which is itself useful placement evidence for the walk.
- **Preamble facts**: `{placeins: true, placeins_section: false}` recorded per document — so when a paper *does* load the `[section]` mode, implicit barriers at every section become a known fact rather than something synthesized.
- **Closure still total**: 1302 slots, zero leaked, zero orphaned in both directions.
- **The residue ledger went 3 → 2 between passes** — it shrank because the model grew. That's the assemble-toward-the-uncertain-spec mechanism observed working on its very first iteration, and it's written up as such in the field notes.

The notes also pin the two residues still standing as classified work items (`\appendix` = protograph admission question for you; the bracket-unaware theorem-title capture = small production fix worth doing regardless), plus the open sweep: ~30 staged tarballs to grow the residue ledger and spec census, and the pressure-test of the row shape against the KisungYou silhouette whenever you want to close that loop.

---

# if the appendix is a section of the paper then its included. won't always be there but its part of the protograph taxonomy. lets fix the brack-unaware theorem-title capture and collect more data on the kisung you silhouette

All three items landed, committed as `b38617d`.

**The appendix admission closed a loop I didn't expect to close today.** It's captured as an `@@APPENDIX@@` structural row in the probe (residue on the specimen is now **0** — first fully-classified paper, three ledger-driven steps: 3 → 2 → 0). And the silhouette census then showed the same kind already realized from the *output* direction: KisungYou's chunks carry a thin `appendix:0` boundary node followed by `A Proofs` / `B` / `C` as ordinary `section` rows with letter numbering in their titles, A.1–A.15 as subsections beneath. Forward capture and reverse sketch agree on the shape — the first protograph kind confirmed from both ends.

**The bracket-aware fix is in production**, not just the probe: new `Get-BracketGroupEnd` primitive (a `]` closes only at brace depth 0), the walk consumes to the true end of the optional arg, and a whole-arg `{…}` wrapper unwraps as TeX grouping. The mangled head now emits `**Theorem 3.5 ([15]).**` — resolved by the normal body pass. One nuance surfaced: cite resolution drops the optional qualifier ("Theorem 3.1" is lost), a separate pre-existing ref-semantics gap, logged as an open item.

**The silhouette census** (computed, not hand-read — 58 rows): kinds are metadata/title/authors/toc/abstract/section×11/subsection×38/assumption/appendix/backmatter/references, seq contiguous, triple addressing throughout. Two findings stand out. The content model claims exclusive ownership but the realized spans have **2 gaps and 3 overlaps** — against the probe's 0 leaked / 0 orphaned. That's the forward-vs-reverse argument compressed into one number pair: reverse-mining the spine from output can't quite close; forward assembly closes by construction. And `assumption:0` turns out to be a fossilized specimen of the heading over-promotion defect — the silhouette modeled the accident as a kind, which is itself a schema lesson: theorem-like objects want to be born from source environments, not from heading typography.

The census also states the convergence target precisely: silhouette has the spine without channels; probe has the channels without a spine. The next probe pass is **spine rows** — and the capture point already exists, because `Convert-CrossRefEnvs` already performs the ordered section/theorem walk. All of it is in the [field notes](issues/latex-ingest/discussions/probe-prose-channel-20260802.md) (§3, §6, §7).

---

# ok lets do the spine rows pass

Pass 4 is landed and committed (`33ede29`). The probe now emits the thing this whole arc was pointed at: **the full interleaved stream** — one flat JSONL where every view is a query.

**What the walk gained**: `Convert-CrossRefEnvs` (probe-gated, production-inert) tags every spine node's start with `@@SPINEn@@` and every theorem-like env's extent with `@@SPINEENDn@@`, and binds labels to spine entries through the same `pending` mechanism that already feeds the ref maps — the capture point existed exactly where the field notes predicted.

**What the stream looks like** on the specimen — 1631 rows, closure still 0 leaked / 0 orphaned with all 107 spine markers reachable:

- **Spine**: title + 13 sections + 15 subsections + 1 subsubsection + appendix + **78 theorem-like objects across 8 kinds** (22 definitions, 16 remarks, 12 propositions, 9 lemmas, 6 theorems, 6 examples, 4 results, 3 corollaries). Section rows own their heading line and carry their source labels; theorem rows carry number, label, and a stamped extent.
- **Prose**: 220 blocks (74.4k chars), each parented to its enclosing spine node — including prose *inside* theorems parenting to the theorem (Result 1's statement carries 11 inline math children).
- **Channels**: 1206 inline math rows following their containing prose block, 76 display blocks, 12 figures, 7 algorithms, the barrier — interleaved at their reading-order positions.

Section tree = group-by parent; math bank = filter kind; reading order = sort seq; `prose.md` serializes clean with zero structural residue.

**Bonus finding**: the appendix numbering gap went from conjecture to specimen. Post-appendix sections emit numbers 8–13 where the paper letters them A–F, and the admitted `appendix` row sits at exactly the position where the counter mode should switch — so "numbering realization is a per-mode policy of the spine" now has a concrete test case, queued in §8 of the [field notes](issues/latex-ingest/discussions/probe-prose-channel-20260802.md) along with paragraph-grain prose splitting, proof envs (still outside the model walk, so the theorem–proof bond isn't captured yet), the ~30-tarball sweep, and the cite-qualifier gap.

One confession for the record: a local `$slug` variable clobbered the `$Slug` param (PowerShell variables are case-insensitive), which misnamed one run's outputs before I caught it — fixed, commented in the driver, and noted in memory.

---

# maybe appendex letter indexing vs numbers becomes an internal alignment and recounting problem. the reference correspondences will be unique, so every letter should map to a specific number in these cases, and we can treat letters and numbers both as symbols that get indexed starting from 1 in alphanumeric order

Captured and committed (`6b052f2`). The natural next probe increment, whenever you want it: spine rows gain `ordinal` + `regime` fields with the recount firing at the appendix row, `number` becomes the derived projection — and the alignment check comes free, since the paper's own `\ref` renderings of `appdx_codes` and friends give the ground-truth displayed forms to verify the projection against. That last part would also surface whether the current `secMap` (which baked numeric strings for those labels) disagrees with the oracle — which, under the reframe, it should.

---

# i might actually opt for at least an optional normalization on these stylistic choices regarding letter->number indexing and just rebase the indices to canonicalize to 1-counting across the board, so long as its unambiguous. I don't think the author's feelings will be hurt and i think the target audience would probably appreciate this if it can be done cleanly and reliably. lets add some field notes and run the next probe increment

Pass 5 is landed and committed (`459fa66`), with the normalization decision recorded in the [field notes §8](issues/latex-ingest/discussions/probe-prose-channel-20260802.md) and memory.

What the increment delivered:

- **The invariant is on the spine now.** Every spine entry carries `(mode, ordinal, regime)` beside the baked display number. The walk sees `\appendix` directly (a captureless regex alternative — production behavior is byte-identical), and the recount fires exactly there: appendix sections are ordinals 1–6 under regime `Alph`.
- **Both projections derive from the one invariant**: faithful `A–F` (with compounds through the parent chain — `8.1 → A.1`, `10.1 → C.1`, labels bound like `appdx_codes → B`) and your normalized arabic continuation `8–13`. The pass-4 output is retroactively explained rather than fixed: it was a basis confusion, and now the basis is explicit.
- **The unambiguity guard is a measurement, not a promise.** `normalized_injective_across_document: true` on this specimen — 1-counting across the board yields 1–13 with zero collisions, so your normalization is safe here and checkable per document. The counterfactual is quantified too: an unqualified per-mode restart would collide 6 ways.
- **The decision as recorded**: optional normalization of stylistic indexing to arabic 1-counting in deliverables, injectivity-guarded; the faithful invariant stays in the model, so faithful vs normalized is one serialization flag; references must render through the same projection — which slots it naturally into the refs-stage work, where `label → (regime, ordinal-path)` with display rendered at resolve was already the direction. One pleasing detail: production's baked numerics already accidentally implement the normalized projection, so formalizing your preference is a policy declaration, not new machinery.

The probe arc now stands at five passes on one specimen: channels → placement evidence → residue zero → the interleaved stream → numbering as projection. The remaining open items (§9) are the tarball sweep, paragraph-grain prose, proof envs into the spine, the cite-qualifier gap, and productionizing the normalization flag with refs — all queued with specimens in hand.

---

# ok, tarball sweep it is

The sweep is running in the background (task `blrmx7kma`) — it enumerates every tarball under `ingestion/`, dedupes to unique versioned papers with `_inbox` copies preferred, unpacks fresh sources only into gitignored staging, and runs the pass-5 probe per paper with failure isolation. Each paper gets its full artifact set under `artifacts/latex-ingest/probe/{slug}/`, and the aggregation lands as `_sweep-summary.md` (per-paper table, failure census, the corpus-wide residue ledger, and the float-specifier census) plus `_sweep-results.json` for machine use.

I'll report the census when it completes — the interesting outputs being which commands dominate the aggregated residue ledger (each one a protograph admission question with paper counts attached), how spec conventions vary across authors, how many papers carry appendices and whether the normalization injectivity guard holds corpus-wide, and which papers fail to stage at all.

---

# <task-notification>
<task-id>blrmx7kma</task-id>
<tool-use-id>toolu_017bQ2qfhTSPHw6URKuRAR82</tool-use-id>
<output-file>C:\Users\azrie\AppData\Local\Temp\claude\D--aghado01-codex-scientiae\89fe8e0e-20c8-4e72-a876-461ededc8207\tasks\blrmx7kma.output</output-file>
<status>completed</status>
<summary>Background command "Run prose-channel probe sweep across all staged tarballs" completed (exit code 0)</summary>
</task-notification>

The sweep is done, written up in [field notes §9](issues/latex-ingest/discussions/probe-prose-channel-20260802.md), and committed (`c4c3004`). The full tables live at `artifacts/latex-ingest/probe/_sweep-summary.md`. The headlines:

**All 34 staged papers convert end to end** (~14 minutes total). The one recorded "failure" was my sweep harness, not a paper — `ConvertFrom-Json` refuses case-colliding keys, and that paper's residue legitimately contains both `\these` and `\These`. Fixed with `-AsHashtable`; the paper's artifacts were fine all along.

**Closure splits by direction, and the split is a discovery.** Leaked markers: **zero on every single paper** — the text-driven invariant holds corpus-wide. But orphans are not zero: **~67 orphaned store entries across 9 papers, and every sampled one is a diagram marker**. Stored tikzcd/tikzpicture whose marker is unreachable at emission means those diagrams *silently vanish from production deliverables today* — the store-driven render swap just no-ops. This defect class was structurally invisible until the probe ran the check in the store-driven direction; specimens are queued from smallest (2205.11338v3, ×1) to largest (2403.08308, ×28), with two candidate culprits named for the trace.

**The residue ledger (~150 distinct commands) classifies cleanly, and the top of it is unambiguous: tables.** The table apparatus (`\small`, `\setlength`, `\tabcolsep`, `\multirow`, `\resizebox`, booktabs rules…) dominates — the largest unclassified channel the protograph census has produced. Second is a systematic **brace-nesting render class**: commands the pipeline handles fine on flat arguments leak raw on nested braces — `\textbf` (104 hits across 9 papers), `\caption` (30), heading renders — which is the pass-3 theorem-title defect family again, now quantified as one generalizable production fix. Then: algorithm2e as an entirely unhandled pseudocode package, inline `\verb`, front/backmatter apparatus gaps, and the macro-harvest outlier 2410.01294v3 (442 hits, 85 distinct commands — one paper supplying a third of the corpus's residue variety).

**Your normalization decision is corpus-green.** Twenty papers carry appendices, and `normalized_injective_across_document` is true on *every one* — arabic 1-counting is unambiguous across the entire staged corpus, so the guard you asked for has passed its first full census.

**Placement evidence is abundant**: 272 figure envs, about two-thirds carrying explicit specs (`h`/`t`/`htbp` dominant, 27 hard `[H]` pins, 39 bang-overrides), and 10 papers using explicit barriers — the walk's placement policy will have real author intent to consume on most floats.

The open-items list (§10) now leads with the two items the census earned: the diagram-orphan trace and the brace-nesting fix — both production defects with specimens in hand, both independent of the reshape.

---

# ok lets tackle those

Both fixes are landed and committed, and the full re-sweep is running in the background to quantify the corpus-wide effect. Status while it runs:

**Fix 1 — the o-corruption (`538bde6`), which the orphan trace turned out to be.** The trail went: orphaned diagram markers → markers found *mangled* inside math store contents (`not` → `no t`) → mangling present even in the "clean" specimen's math → minimal repro isolating the em-dash as trigger → the glyph pass's gate (`contains non-ASCII`) activating a lexicon whose store data was corrupted: four entries had lost their glyphs to ASCII text, including `glyph: "o" → "o"`, which made the matcher rewrite every `o`-before-letter in any non-ASCII span. Repaired the four glyphs (omicron `ο`, and `⌋ ⌈ ⌉` whose corruption was also doubling backslashes on `\rfloor`/`\lceil`/`\rceil`), hardened the pass to refuse pure-ASCII lexicon keys loudly at load, tightened the token-separator rule to control-words only, and added the Store-Math divert so a span that *is* a diagram marker returns to the flow as text instead of shipping inside `$$…$$`. Specimens: 2501 orphans 12→0 with its 11 diagrams now first-class stream rows, 2112 4→0, 2408 unchanged and its 8 corrupted spans clean.

**Fix 2 — the brace-nesting render class (`3e4d288`).** All the body render sites the ledger implicated (`\textbf`, `\caption` — which now also accepts the `[short]{long}` form — headings, paragraph, emphasis, texttt, the textrm unwrap family) converted to the existing brace-aware `Replace-BracedCommand` primitive with per-site semantics preserved. Verified on the two residue-heaviest papers: the brace-class portion vanishes, other classes untouched, closure intact.

When the sweep returns I'll diff the census — expected: orphans ≈ 0 corpus-wide, the residue ledger's `\textbf`/`\caption`/heading rows collapsed, and the remaining ledger cleanly dominated by the classes that are genuine admission questions (tables above all). Field notes and memory get the final numbers then.

---

# <task-notification>
<task-id>b7wr2r1b6</task-id>
<tool-use-id>toolu_015St6MY98f9us7mGANsDH6x</tool-use-id>
<output-file>C:\Users\azrie\AppData\Local\Temp\claude\D--aghado01-codex-scientiae\89fe8e0e-20c8-4e72-a876-461ededc8207\tasks\b7wr2r1b6.output</output-file>
<status>completed</status>
<summary>Background command "Re-run full probe sweep after both fixes" completed (exit code 0)</summary>
</task-notification>

Final re-sweep is running in the background (commit executes first in the chain, then the sweep — which now also covers the nine new papers in `ingestion/inventory/`). When it returns I'll close out the arc: field notes updated with the full before/after (orphans 67 → 0, the residue ledger's brace classes gone, the fresh papers' first census), memory synced, and a summary of the three production fixes this "tackle those" turned into — the lexicon corruption repair with its load-time guard, the brace-aware render generalization, and the discard-then-capture ordering that made "every stored span is reachable" a corpus-wide hard invariant.

---

# <task-notification>
<task-id>bd7q07lb8</task-id>
<tool-use-id>toolu_01CbWmwWufQtXg7jpwFV8STT</tool-use-id>
<output-file>C:\Users\azrie\AppData\Local\Temp\claude\D--aghado01-codex-scientiae\89fe8e0e-20c8-4e72-a876-461ededc8207\tasks\bd7q07lb8.output</output-file>
<status>completed</status>
<summary>Background command "Commit ordering fix and launch final re-sweep" completed (exit code 0)</summary>
</task-notification>

The tackle is complete — field notes closed out in [§10](issues/latex-ingest/discussions/probe-prose-channel-20260802.md) (`a5eb40e`), memory synced. The headline:

**Both directions of the placeholder check are now corpus-wide hard invariants: 42 papers, leaked 0 and orphaned 0 on every single one** — including the eight fresh `inventory/` papers from your commit, which converted clean on first contact.

What "tackle those two items" actually turned into:

1. **The diagram-orphan trace found a bigger fish** (`538bde6`). The orphans weren't lost markers — they were markers sitting *corrupted* inside math store contents, and the corruption was corpus-wide: four lexicon store entries had lost their glyphs to ASCII text in some past codepoint-mangling incident (`glyph "o" → "o"` being the killer). Any span containing a non-ASCII character — the gate that activates the glyph pass — got every bare `o`-before-letter split (`\coloneqq` → `\co lo neqq`) and doubled backslashes on the floor/ceil commands. Repaired the glyphs, made the pass refuse pure-ASCII lexicon keys loudly at load, tightened the token separator to control-words only, and added the Store-Math divert so math-wrapped diagrams return to the flow as text instead of shipping as KaTeX-invalid `$$…$$` content.
2. **The brace-nesting render class is eliminated** (`3e4d288`) — all the ledger-implicated sites now use the brace-aware primitive, and `\textbf`/`\caption`/heading rows vanished from the aggregated ledger.
3. **A third fix the trace earned**: the corpus's last orphan was an affiliation `$^*$` captured into the math store and then destroyed with its `\author` argument — capture-then-discard. The front-matter drop now runs before math protection (`0a0d3b8`), so "every stored span is reachable from the text" holds by construction.

The residue ledger behaved exactly as the mechanism predicts: the resolved classes vanished, resolving outer wrappers surfaced inner residue, and **tables now dominate unambiguously** (`\small` in 18 papers, `\multirow` at 66 hits) — the table channel is the standing top admission question for the protograph, with algorithm2e, inline `\verb`, the macro-harvest outlier, and one new specimen (2405.12350v1, the corpus's first genuine staging failure — empty resolved source) queued behind it.

---

# i'm surprised you need to ask about tables. yes that goes in the protograph as a new object. what is "algorithm2e", what do you mean inline \verb, and `D:\aghado01\codex-scientiae\ingestion\inventory\2405.12350v1\arXiv-2405.12350v1.tar.gz` should be fine now. i downloaded that and was moving the tarballs into their directories, another process may have locked it or something, but i can see the file and it has bib.tex and main.tex that are non-zero bytes. also, can we discuss these briefly and then do them paragraph-grain prose, proof envs into the spine, the cite-qualifier gap, and productionizing the normalization flag with refs, and the ref graph while we're there

All discussed, all landed — committed as `74336a8`, `bac5bd9`, and the field notes in `b463995`. The positions each item settled on, and what came back:

**Paragraph-grain prose** — the block boundary is the blank line, and inline math attaches to the paragraph whose span contains its marker. Implemented in the driver's flush (which also fixed a latent offset drift in the heading absorption). 2408 goes from 220 inter-boundary segments to **276 true paragraph rows**, closure untouched.

**Proof envs into the spine** — position: the walk only *tags*; emission stays with the existing italic run-in conversion, so production output is unchanged while the probe gains the node. Proof titles (`[Proof of Theorem 2.1]`) arrive bracket-aware through the same rescan the theorem fix built. **20 proof rows** on the specimen, each with a stamped extent — the theorem–proof bond is now addressable in the stream (the `proves` edge itself stays a derived relation for the refgraph to formalize later, since proof titles literally cite their theorems).

**Cite-qualifier gap** — contract: one optional arg is a postnote (`[15, Theorem 3.1]`), two are natbib prenote+postnote (`[see 15, p. 7]`). The author pointing at a specific result inside a citation is reference *semantics*, not decoration — it renders now.

**Normalization flag + refs** — position: both projections are always *computed* (the walk carries the `(mode, ordinal, regime)` recount as production state now, not probe-gated), and the flag only selects at *render*. `-FaithfulNumbering` on the production driver; default stays normalized per your decision. Verified end-to-end on 2408: faithful emits `**Definition A.1**` run-ins and "section B" references where normalized emits `8.1` / "section 9" — one invariant, one switch.

**The ref graph** — the collect side of the refs-consolidation brief, landed as a production sidecar: `{slug}.refs.jsonl` carries every declared label (class, type, both projections) and every reference site as rendered (macro, keys, text) — 167 labels + 186 sites on the specimen. The docgraph's capture role is folded in exactly as the brief's reconciliation said it should be, and the brief's step 2 came along free: `Build-LabelMaps`' flat theorem map — the wrong-model-adjacent-to-live-code hazard — is deleted, with only the oracle's count kept. What remains of the ladder is consumer repointing behind golden pinning (steps 1 and 4), queued.

**Bonus diagnosis**: 2405.12350v1 was never a staging failure — it contains an author's *empty math span* (`$$ $$`), which crashed the lowering because `[Parameter(Mandatory)]` rejects empty strings before the function's own guard runs. Fixed with `AllowEmptyString` plus dropping whitespace-only spans as furniture. The paper now converts and turns out to be a math-saturated stress specimen — 2,792 inline spans and a 2,716-hit residue ledger including inline `\verb` — making it the second macro-harvest specimen alongside 2410.

Open queue, per the [field notes §12](issues/latex-ingest/discussions/probe-prose-channel-20260802.md): the **table channel build** (admitted — the design follows the figure pattern: env stashed whole as the caption/label/body bundle, plus the structural grid), the algorithm2e adapter, `\verb` capture at the raw-source stage, and the consumer repoint.

---

# ok lets implement the algorithm2e and inline \verb at raw source as well as table channel, and consumer repoint

All four items are landed and committed, with the closing re-sweep running in the background to quantify the corpus-wide effect. The summary:

**Inline `\verb`** (`9be693e`) — stashed at the raw-source stage right after the block-env captures, where its `%`-is-not-a-comment / `$`-is-not-math semantics demand it live. It emits inline code spans through the existing VERB store, which now carries two grains — the driver routes by content: fences interleave as stream rows, spans ride inside their paragraph like inline math. 2207.00510's residue drops from 4 distinct commands to 1 (only the `\lq` quote-macro class survives).

**algorithm2e** (`9be693e`) — `Format-Algorithm2e` mechanically lowers the braced-argument dialect (`\For{cond}{body}` → `for cond: … end`, `\KwIn`/`\KwOut` → `Input:`/`Output:`, `\tcp` → `//` comments, three-arg `\eIf`, `\;` line ends, apparatus dropped) into a fenced pseudocode block, hooked exactly where the algorithmic-env attempt comes up empty. Same ALG channel, different vocabulary — 2404.05484's residue falls 50 → 13, the entire algorithm2e family consumed.

**Table channel** (`9be693e`) — the admitted kind, built on the figure pattern: table-family floats stash whole as `@@TABENV@@` (caption + `\label` + grid as one bundle, spec field, driver enrichment, orphan coverage). One honest caveat recorded: the inner tabular is already markdown at stash time since `Convert-Tabular` runs upstream, so the bundle is captured mid-realization — the forward-assembly version will capture it raw. Specimens: 6 tables on 2207, 1 on 2404, closure 0/0 everywhere.

**Consumer repoint** (`fc64724`) — the golden pin is the headline: [latex-ingest.refs.Tests.ps1](tests/latex-ingest.refs.Tests.ps1) asserts all 167 labels (class, type, and *both* display projections) plus all 186 reference-site renderings in order against a committed fixture — 5/5 passing, and any future change that moves one number or one rendered phrase fails there first. The repoint itself resolved by *verification rather than churn*: the subject index is already model-fed (labels built from records, markdown consulted only for `byte_start` — a legitimate final-text fact), so the refs brief's "delete the a08656ce bridge" is formally reclassified — there is no bridge; that loop *is* the resolve stage, correctly ordered. Oracle counts verified intact after the thm-map deletion.

Two more PowerShell traps joined the ledger along the way: a dictionary field named `keys` is shadowed by the `.Keys` property (it silently exploded cite keys into row fields at serialization — renamed `targets`), and Pester v6 discovery-phase variables don't survive into the run phase.

Field notes [§12–13](issues/latex-ingest/discussions/probe-prose-channel-20260802.md) and memory are synced. When the re-sweep notification lands I'll report the final ledger — expected: the algorithm2e/verb rows gone, TABENV counts appearing across the corpus, and the remaining residue dominated by exactly the classes still queued (`\lq`, the two macro-harvest specimens, and the long-tail furniture).

---

# <task-notification>
<task-id>br3183t35</task-id>
<tool-use-id>toolu_019mzUQQMWv4rywXTJn3NSuu</tool-use-id>
<output-file>C:\Users\azrie\AppData\Local\Temp\claude\D--aghado01-codex-scientiae\89fe8e0e-20c8-4e72-a876-461ededc8207\tasks\br3183t35.output</output-file>
<status>completed</status>
<summary>Background command "Commit field notes and launch closing re-sweep" completed (exit code 0)</summary>
</task-notification>

The closing census is in, written up in [field notes §13](issues/latex-ingest/discussions/probe-prose-channel-20260802.md) (`2dd4724`), and it's the strongest single result of the whole arc:

**All 43 papers convert with zero failures, and the residue ledger collapsed.** The table channel's reach shows exactly where the census said it would: `\small` fell from 301 hits to 20, and the entire table-apparatus block — `\setlength`, `\tabcolsep`, `\multirow`, `\resizebox`, the booktabs rules — vanished from the top of the ledger, because stashing table floats whole took their interior furniture with them. The most dramatic single delta: 2405.12350v1's residue went **2,716 → 25** — its overwhelming mass was verb and table content that the new channels now capture. What remains at the top is `\begin`/`\end` (31 hits of genuinely unhandled environments), front-matter singletons, and 2410.01294v3 standing alone at 442/85 as the pure macro-harvest holdout.

And the store-driven direction of the closure check earned its keep one more time: 2605.01664v1 surfaced **5 orphaned VERB entries** — inline `\verb` sites inside table floats, stashed at raw source, whose markers are then destroyed during `Convert-Tabular` realization. That's the silent-content-loss class (the diagram trace's sibling) appearing in a fresh seam, with a small specimen attached and queued as the top open item.

Where the lane stands after today: the interleaved stream carries eleven channel families plus a full spine with extents, closure is a hard invariant in both directions across the corpus, the ref model ships as a production sidecar with both numbering projections behind a verified flag, the golden pin guards it all with 5/5 passing tests, and the open list (§14) is down to one loss trace, two residue classes, one macro-harvest specimen, and the tail of the refs ladder. The uncomfortable feeling you started this session with now has a measured, specimen-backed shape — and a pipeline that's substantially closer to the latent manuscript than it was this morning.

---

# so what are the next steps in the latex-ingest saga?

Here's the map as I see it, three altitudes out.

**Near — finish the census tail.** The ledger is down to a handful of named classes, each with a specimen: the **verb-in-table loss trace** (2605.01664v1, ×5 — same backward-trace method as the diagram one, find where `Convert-Tabular` eats marker-bearing cells, loud-fail or preserve); a quick **census of the `\begin`/`\end` survivors** (31 hits — one grep names which environments are genuinely unhandled, each becoming an admission question or a drop rule); the **`\lq`/`\rq` quote-macro class** (trivial rule addition); and then the one real converter defect left: the **2410.01294v3 macro-harvest trace** — 442 residue hits and a suspiciously channel-empty stream mean its macro definitions aren't being harvested or expanded at all, which starves the math channel for that whole paper. That last one is the meatiest of the small items and the last big holdout between the corpus and a near-empty ledger.

**Mid — two graduations.** First, I think the **planning tier wants minting**. The discussions doc is now 14 sections carrying canon-weight content — admitted kinds (appendix, proof, tables), standing policy decisions (normalization default, placement evidence, the page-speak/order-speak rule), and a ledger's worth of landed work. Per your own convention that's `issues/latex-ingest/planning/{decisions,roadmap,ledger}.md`, with the doctrine doc's own note that it graduates when the tier exists. That's your call to mint; the material is ready. Second, **promote the stream to a production artifact**: the probe's emission becomes `{slug}.stream.jsonl` written by the production driver beside `refs.jsonl` — the pre-markdown IR shipping per conversion. That's the artifact-first migration move you've already used twice (stabilize the contract, swap the producer later), it's admissible under the source-side rule, and it makes every downstream consumer able to start reading the stream *before* the inversion happens. Extending the golden pin to the stream (heading tree, channel inventories) rides along naturally.

**Far — the inversion and the convergence.** With the stream as a real artifact, the presentation-last inversion becomes concrete: a serializer that walks rows and renders by kind, at which point markdown is genuinely the foreach the doctrine promised, the restore machinery dies, and the mid-realization caveats (tables captured as markdown, refs baked pre-capture) get unwound by re-homing where rows are *born*. The entry criteria we set are mostly met now — the row schema has survived six passes and 43 papers, and your fresh inventory materials can seed the refreshed battery for the gauntlet before/after (refs step 6). What still gates it is the doccer side: the DLL-reach adapters and the macro-expansion witness demo, which are paced by that lane's minting decisions. The remaining refs-ladder step (tex-docgraph reduced to a projection, step 5) is small now that the model exists and can go whenever.

My recommendation for the next working session: knock out the near tier — verb-in-table trace, env census, quote macros, then the 2410 macro-harvest trace — because it drives the residue story to essentially zero across the corpus and each is specimen-backed. Then, if you're ready to mint planning/, I'd fold the six-pass arc into decisions/roadmap/ledger form as its first content, and take the stream-to-production promotion as the roadmap's first "ahead" item.

---

# ok, i've created planning+briefs for the latex-ingest issues, but we can populate that a little later. regarding the doc ref-graph, what is the state of that? i'm imagining that's should made complete and be emitted after the refs are resolved and stored as a rich object containing nodes/edges/labels etc, which can then be used to clean up the silly "missing Theorem 3.1" problem correctly

The state, precisely: **the graph exists as two flat tables, not yet as a graph** — and your instinct about what it should become is exactly where the data wants to go. Here's the inventory:

**What exists today.** `{slug}.refs.jsonl` carries label rows (label, class, type, both projections) and site rows (macro, targets, rendered text, in order) — recorded post-resolve, so every edge's realization is known. But the graph is only *implicit*: no assembled edge objects, no `resolved` flag, no node identities joined to the stream's spine addresses (the spine entries carry their labels, so the join is sitting there), no bib-entry nodes, and the cite qualifier lives inside rendered text rather than as a structured attribute. Meanwhile `tex-docgraph.ps1` is still the *old* separate upstream scan (refs-consolidation step 5, pending) — though its class taxonomy in `stores/docgraph.json` already feeds `Get-LatexResultClass` for the subject index, so the store's semantic content is live even where the scan is redundant.

**The measured size of the "missing" problem**: I just counted **1,169 dangling reference sites across 24 of 43 papers** — sites whose rendered text contains `?`. 2603.03375 alone has 219, 2409 has 165. And this is exactly where your "clean it up *correctly*" point bites, because those danglers are not one problem — they're at least three, and only a graph can tell them apart:

- **bib-danglers** — cite sites whose key has no bibliography entry (often papers with no `.bbl` at all; probably the bulk of the big counts);
- **never-declared** — the target label doesn't exist in the source (author typo, genuine);
- **declared-but-unmapped** — the *converter's* class, the fixable one: labels the walk sees but no map claims. The known specimen family: **algorithm labels** (`\label{alg:x}` — no map has an algorithm counter, so every `\ref{alg:x}` renders `?` today), plus tcb auto-counters (currently `?` by explicit design) and whatever else the classification surfaces.

**The design you're describing, sharpened to fit what's recorded:** emit `{slug}.refgraph.json` after resolve as a rich object —

- **Nodes**: every label target (class, type, normalized + faithful, joined to its spine `addr` so a node knows *where it lives* in the stream), every bib entry (key + number), and explicit *dangler nodes* for referenced-but-absent targets;
- **Edges**: one per site→target pair (multi-target sites fan out), typed by macro family, carrying rendered text, `resolved: bool`, style, and — the correct home for the once-lost "Theorem 3.1" — the **qualifier as a structured edge attribute**: a cite edge that points at `bib:pers_lap` *and* records the pointer into that external work as data, not just prose;
- **Danglers ledger**: every unresolved edge classified by cause, which converts the blanket `?` into a per-class policy — fix the converter classes (add the algorithm counter to the model), render honest markers for author errors, and flag missing-bib as a staging fact.

This also closes two loops at once: it *subsumes* `tex-docgraph` (step 5 lands as "the docgraph is a projection of this graph"; the taxonomy store joins as node classes), and it's the artifact the placement policy was already promised — figure/table first-reference sites are just an edge query.

It's cheap to build, because it's pure assembly over data already recorded in one conversion — labels + sites + citeMap + spine — plus the classification pass. The corpus-wide danglers report then hands us the fix list ranked by class. Say the word and I'll build the refgraph emission, run the classification across the 43 papers, and take the algorithm-label counter as the first "correctly cleaned up" class.

---

# ok lets implement that as well as the docstream object; i feel like these two are close kin

---

# [Request interrupted by user]

---

# you keep confusing document graph with the latex refgraph. the stream + refgraph -> doc graph if my semantics aren't wrong

Both objects are landed with your layer semantics enforced, commits are in flight, and the closing sweep is running in the background. The shape of what shipped:

**The docstream is now a production artifact** — `Build-LatexDocstream` graduated from the scratch driver into [docstream.ps1](src/latex-ingest/docstream.ps1), channel capture and spine tagging are unconditional, and every conversion writes `{slug}.docstream.jsonl` beside the refs sidecar. The production tail realizes float bundles back into the markdown through `Render-FloatBundle` (same math store via `-KeepStore`, shared text-format realization, reflow applied) with both check directions on the splice — and stripping the structural punctuation closed the `\FloatBarrier` and `\appendix` deliverable leaks as a side effect. The markdown transition is fully accountable against the pre-change baseline: leaks closed, float-interior furniture gone, only reflow-boundary shifts otherwise.

**The latex refgraph stays LaTeX-flavored** — labels, sites, per-target edges with resolution status, danglers classified by cause (`bib-missing` / `declared-unmapped` / `undeclared`, powered by the walk's new declared-labels set), and cite pre/postnotes as structured edge attributes: "Theorem 3.1" is now data on the edge pointing into the cited work.

**The doc graph is derived, never scanned** — stream nodes plus bib entries, referential edges resolved onto stream addresses (183/193 anchored on 2408; the 10 unanchored are equation targets, whose labels strip before math capture — the known entanglement, now measurable). `stream + refgraph → doc graph`, exactly as you stated it.

And the first cleaned dangler class delivered a better story than promised: 2408's algorithm references weren't dangling — they were **silently wrong**, resolving through the custom-counter shadow map as bare `3` where the paper means `algorithm 4`. The new algorithm counter fixes them typed and correct, the golden pin caught the change and was regenerated deliberately (5/5 passing), and the probe holds exact parity through the shared builder.

When the sweep notification lands I'll report the corpus-wide dangler classification — how the 1,169 danglers split across the three causes now that the alg class is cleaned — and fold the close-out into field notes and memory.

---

# aside, but i really need to get your token usage under control again. i'm feeling the burn after snipping context mode, so much wasted tokens on tool results is my bet. ill have to circle back on a new rollout of context mode this week. but lets take this opportunity to mint the new planning docs and a brief for the "near tier" `knock out the near tier — verb-in-table trace, env census, quote macros, then the 2410 macro-harvest trace — because it drives the residue story to essentially zero across the corpus and each is specimen-backed`

Minted and committed (`819ae98`):

- **[decisions.md](issues/latex-ingest/planning/decisions.md)** — D1–D11: doctrine, protograph, knowability + both-directions checks, the admission rule, kernel two-sort, numbering-as-projection with normalized default, the stream + refgraph → doc graph layers, the running admitted-kinds census, golden discipline, artifact contracts.
- **[roadmap.md](issues/latex-ingest/planning/roadmap.md)** — ahead-only: near (the residue close-out), mid (site anchoring, eq-label anchoring, tex-docgraph retirement, consumer migration, gauntlet compare), far (serializer-from-stream, protograph doc, doccer convergence).
- **[ledger.md](issues/latex-ingest/planning/ledger.md)** — the landed arc indexed with commits.
- **[near-tier-residue-20260803.md](issues/latex-ingest/briefs/near-tier-residue-20260803.md)** — the brief: T1 verb-in-table trace (2605 specimen), T2 env census, T3 quote macros (2207), T4 the 2410 macro-harvest trace, each with verification method and the golden-pin constraint, report section ready for appending.

Memory synced (planning-minted status + your token note recorded as standing guidance). The closing sweep from earlier is still running in the background; when it notifies I'll fold its dangler-classification numbers into the ledger in one small touch rather than a fresh write-up.

---

# <task-notification>
<task-id>bq6kq8cg0</task-id>
<tool-use-id>toolu_01Nwm4ucLVKLoRieAQp3rvmR</tool-use-id>
<output-file>C:\Users\azrie\AppData\Local\Temp\claude\D--aghado01-codex-scientiae\89fe8e0e-20c8-4e72-a876-461ededc8207\tasks\bq6kq8cg0.output</output-file>
<status>completed</status>
<summary>Background command "Commit docstream/refgraph/docgraph batch and launch closing sweep" completed (exit code 0)</summary>
</task-notification>

Closing sweep is in and the ledger carries it (`6a0d2ac`). The corpus refgraph classification, final numbers: **43/43 papers, 7,301 reference edges, 1,494 dangling** — split into **1,226 bib-missing** (a staging fact: sources shipped without `.bbl`, not a converter defect), **121 declared-unmapped** (the true remaining converter class — where the next map fixes live, now that algorithms are cleaned), and **147 undeclared** (author errors, rendered honestly). Exactly the per-class policy split the refgraph was built to enable.

The lane is now fully canonized: decisions D1–D11, ahead-only roadmap, ledger current through tonight, and the near-tier brief staged for the next session. I'll stop here — lean close per your token note.

---

# incidentally, i independently converged on the stream idea while doing some very preliminary ideation for the rebirth of `pdfpig` by taking a more careful look at pdfpig's capabilities and architecture `D:\aghado01\codex-scientiae\issues\pdfdig\discussions\sol-pdfpig-ideation-20260804.md` . im definitely trying to get latex-ingest in a shape that `pdfdig` can rhyme with down the line

Also worth noting: Sol's "braided stream" image already has a home in the house lexicon — unbraiding rides the mask layer on the doccer side — so the vocabulary is converging along with the architecture.

Practical upshot, parked in the roadmap's spirit rather than acted on now: the next time we touch the docstream schema (likely when the near-tier brief closes and the mid-tier anchoring work starts), the three rhyme accommodations — epistemic field, partial-order tolerance, lane-shaped provenance — are small, additive edits to make *then*, so pdfdig's first stream has a shape waiting for it rather than a LaTeX-shaped mold to fight.

---

# and ultimately a hard design constraint is that both pdfdig and latex-ingest will build the same target pre-markdown jsonl IR, aligned as much as possible, which would be where the gauntlet dev harness comparisons happen on discrete canonical chunks of latent manuscript derived from each source.

D12 is locked (`a5b0b1c`), memory synced. The constraint's three consequences are now explicit in canon: the docstream schema is a *shared contract* with pdfdig (differences expressed inside it — epistemic status, spine order, provenance shape — never as forks), the gauntlet is re-scoped as the two-lane IR comparator over canonical latent-manuscript chunks, and the D12 conformance pass (epistemic field, partial-order tolerance, provenance slot) is queued on the roadmap to ride the next schema touch. When pdfdig's first stage starts emitting marks, the target it assembles toward is already written down — and the harness that will judge it already knows its unit.

---

# and this is the reason why i'm taking the time to really nail it in latex-ingest before beginning work on pdfdig in earnest, so that i have things like the JSONL ABI IR, latent manuscript / protograph schema worked out, math register conventions and spec in shape, because the pdf problem is wild and the less unknowns that i have control over the better

Recorded. The strategy is fully legible in canon now: latex-ingest is the controlled environment where the instruments get calibrated, and pdfdig enters only when the only unknowns left are the ones no amount of preparation could remove. When you're ready to resume, the near-tier brief is staged, the conformance pass is queued, and the wild problem will be waiting with considerably fewer places to hide.

---

# <command-name>/model</command-name>
            <command-message>model</command-message>
            <command-args>claude-opus-5</command-args>

---

# <local-command-stdout>Set model to claude-opus-5</local-command-stdout>

---

# ok lets export this thread to `issues/latex-ingest/discussions`
