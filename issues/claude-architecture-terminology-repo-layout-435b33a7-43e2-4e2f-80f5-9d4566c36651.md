---
format: Structural
exported_at: 2026-07-31T03:26:30.1491532Z
exchanges: 41
user_label: Aipithicus
sessions:
  - 435b33a7
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

# i'm doing some work on trying to articulate codex-scientiae document processing architecture concepts succinctly, how they relate to the separate downstream work on Markpig's ASTs, as well as the concepts of the math/prose registers connect together with the latent manuscript target `D:\aghado01\codex-scientiae\issues\reboot\latex-ingest\guidance-draft.md`

---

# [Request interrupted by user]

---

# dont read surrounding reboot material all at once, because there's a mix of evolving concepts and diverse documents, thinking that has changed over time

Understood — I'll stay with just the draft itself. I've read [guidance-draft.md](issues/reboot/latex-ingest/guidance-draft.md), and nothing else beyond the file listing.

Here's the conceptual skeleton I see in it, reflected back:

1. **The latent manuscript envelope** is the center of gravity. Everything else is defined relative to it: heterogeneous sources are *surjected onto* it (canonicalization is abduction, not transcription), and downstream consumers are *projections of* it.

2. **Two orthogonal channels inside the envelope** — math and prose — interleaved along reading order. The demux is what makes dual-sector embedding and cross-linked RAG fall out naturally rather than being bolted on.

3. **The DAG-not-tree move.** The envelope is a typed DAG (dominance + reading-order + reference edges). Classic ASTs are demoted to spanning-tree projections for hierarchical visitation; reading order is a further linear projection. This is the load-bearing claim that separates MarkPig from "yet another Markdown AST": the tree is a *view*, not the ontology.

4. **MarkPig as concrete syntax for the DAG.** Markdown links/footnotes/citations are the surface form of reference edges; figure composites are closed subgraphs that nest recursively. Structure lives in the latent graph, not in container tags — which is what keeps the document simultaneously human- and model-readable.

5. **The furniture/notation criterion** — the sharpest thing in the draft. It's an operational test, not a taxonomy: *if removing it changes the MathDig parse, it's encoded notation; if only spacing/size/decoration changes, it's furniture.* And furniture isn't just discarded — it's **evidence first, discard second** (`\operatorname` spacing testifies to Op-class intent, then vanishes from output). The math register is exactly the encoded-notation projection, lexically KaTeX-stable.

A few observations on succinctness, offered as conversation not edits:

- Lines 5 and 8 both open "the envelope instance is a typed DAG" — they read like two drafts of the same paragraph that haven't merged yet. Line 8's version (naming the three edge classes) subsumes line 5's, except line 5 uniquely carries the sub-addressing idea (position×kind over the spine).
- The "evidence-then-strip" pattern appears three separate times (lines 14, 21–23, 26–28) at slightly different altitudes. It might *be* one principle stated once: **furniture is consumed as parse-time evidence and never survives into the register.** The `\operatorname` case is then an example, not a separate rule.
- The nomenclature TBD on line 3 (registers/streams/channels/modes) actually matters for succinctness downstream — "register" is doing double duty right now, meaning both the *channel* (math register vs prose register) and the *lexicon standard* (the math-register spec). Worth deciding whether that overload is a feature or a bug.

Where do you want to push — the envelope/DAG articulation, the register/furniture side, or the connective tissue between them and MarkPig?

---

# the mathdig parse move is sharp but its also useless without a mathdig parser, which i dont have yet, hence my need to articulate prose for these things in order to do the work and later develop mathdig itself

That's a real circularity, but I think it dissolves when you notice which direction the definition runs: the criterion isn't something MathDig *provides* — it's the spec MathDig will eventually be *built to satisfy*. The draft currently phrases it operationally ("changes the MathDig tree"), which makes it sound like you need the parser to apply the test. But the underlying test is denotational and available to you right now: **does removing it change the math a competent reader recovers?** MathDig is just the name for the future decision procedure for that equivalence. Language specs work this way routinely — the semantics is prose plus adjudicated cases long before a reference implementation exists, and the implementation is later judged against them, not vice versa.

That reframe gives you a working method in the interim, and it's a ladder where every rung already partially exists:

1. **Lexical invariance** — exists. `ConvertTo-RegisterMath` already canonicalizes the lexicon (alias surjection, glyph→control-sequence, furniture stripping). Two spans that normalize to the same string are equivalent. This catches most furniture without any structural parse at all.

2. **KaTeX-parse quotient** — a cheap proxy you could stand up any time. KaTeX *does* produce a parse tree today; "same KaTeX tree modulo spacing/size/style nodes" is a mechanical approximation of "same MathDig tree." You don't need to build it now, but it's worth knowing the criterion has an executable stand-in that isn't MathDig.

3. **Adjudication** — for cases the first two rungs can't decide, you judge by hand, and *each judgment is an asset*: it's a conformance fixture for the parser you haven't written. The corpus of "this is furniture / this is notation" calls, accumulated during conversion work, is literally how MathDig gets developed later — it's built to reproduce those calls.

So the prose articulation you're after might be: state the invariant first (*the math is what survives every presentational variation — the encoded-notation projection*), define furniture as the quotient (*anything whose removal preserves that invariant*), and then introduce MathDig as *the formalization of this equivalence, not its precondition*. The current draft has the dependency arrow pointing from criterion to parser; flipping it makes the criterion usable today and turns your daily conversion work into MathDig's future test suite instead of work that's blocked on it.

One phrasing consequence: lines 16–17's "different MathDig tree" could become something like "changes the notation — the structure a reader must recover to know what's being asserted — as MathDig will eventually formalize." Same sharpness, no dependency on unbuilt software.

---

# i'm moving away from "register" for exactly the reason you highlight, among others.  a largely powershell project, which loves its verbs, having functions alluding to the 'register' noun in the sense of the math "channel" or whatever, as well as literal registries in the code data stores, as well as the concept of 'registration' and logistics around bibliotecha library management or updating said stores, ... its too semantically overloaded, especially in this project with powershell. but i haven't settled on the new name

The overload diagnosis is solid — in PowerShell it's even worse than you listed, because `Register-` is an *approved verb* (`Register-ObjectEvent`, `Register-EngineEvent`), so any `*-Register*` function name reads as verb-noun soup to a PowerShell eye before it reads as your concept.

Here's something worth noticing: your draft has already voted, through its verbs. "Demux" appears twice — "demux for dual-sector embedding," "demuxing prose/math… at every depth" — and demultiplexing is native vocabulary for exactly one of your candidate nouns: **channel**. And the metaphor is exact rather than decorative. Time-division multiplexing is: multiple channels interleaved into one serial stream along a shared time axis, recoverable by demux. Your envelope is: math and prose interleaved into one serial document along reading order, recoverable by demux. Reading order *is* the time axis. That's not an analogy you'd have to defend; it's the same structure.

It also lands close to home for you specifically — multichannel recording is the substrate your whole spike-sorting lineage sits on, and source-separation-from-interleaved-channels is arguably the founding move of that work. The nomenclature would rhyme with your instruments.

Practical checks: no PowerShell verb collision, no .NET collision you'd ever hit (`System.Threading.Channels` is obscure), no existing overload in this project — "lane" is your pipeline word, "mode" is claimed by typographic-modes, "stream" is fatally taken by PowerShell's own output streams (a `math stream` in a PS codebase invites genuine confusion with stream redirection). `Split-` and `Select-` are approved verbs, so `Split-Channels`, `Select-MathChannel` come out clean.

The other thing your draft already half-decided: the *second* meaning that was overloaded onto "register" — the canonical KaTeX-stable standard — already has a name in your own prose. Lines 23–28 call it the **lexicon**. So the split falls out naturally:

- **Channel** — the demuxed stream (math channel, prose channel); a structural fact about the envelope.
- **Lexicon** — the normalized vocabulary the math channel's content must satisfy; a conformance fact about its contents.

A span lives *in* the math channel and is written *in* the lexicon. Two orthogonal concepts, two names, neither colliding with PowerShell or your stores.

On the runners-up, briefly: *track* is workable but its verb family (mixdown, bounce) is weaker; *voice* is lovely for the manuscript/counterpoint register of this project's naming but too vague inside code; *sector* has a nice physics echo (superselection) but overstates the orthogonality — your channels do couple through reference edges, which channels-with-crosslinks accommodates and sealed sectors don't.

Held lightly, since you haven't settled — but I'd put it as: the draft's own verbs chose "channel," and "lexicon" was already yours.

---

# i was actually litigating this in a perplexity chat, this might be a good candidate for test-driving `doc-dive` and its `mdnav` tools  `D:\aghado01\utils\skills-dev\doc-dive` . you can use it systematically read through this meandering thread `D:\aghado01\codex-scientiae\issues\reboot\perplexity-terminology-architecture-asts.md` and help me unpack

Read 46% of the thread by plan rather than exhaustion: the terminology arc (turns 1–7) and the envelope-geometry arc (turns 8–11) in full, because those are what your guidance draft *doesn't* distill. The eleven unread units (H0057–H0130) correspond line-for-line to draft content I've already seen — tree-eschewing → line 5, ref edges → line 8, figures/HTML/sub-figures → lines 10–12, furniture/notation → lines 14–28 — so I left them in the ledger as verified-covered rather than re-reading them.

## What the thread actually settled on naming

Your own gut called it in turn 2: *"Channel feels stronger. But I still wonder if there's a more precise and distinctive term yet."* Everything after that was Perplexity trying to sell you upgrades — **sector** (Hilbert-space projection flavor), **component** (mixture-model flavor), **stratum**, **fiber** — while the TDM arc kept drifting back to channel-family vocabulary because the *mechanism* is channel-shaped. "Dual-sector embedding" in your draft is residue of that sales pitch, not a decision you made.

But the thread implicitly reached a settlement worth making explicit, because three different concepts were fighting over one word:

| Concept | Thread's answer | Where it lives |
|---|---|---|
| The interleaved symbolic regime along the spine | **channel** (or stream) | on the envelope, pre-demux |
| The embedding subspace after demux | **sector** | RAG side, post-demux |
| The normalized vocabulary math must satisfy | **lexicon** | conformance standard |

Perplexity's one genuinely good line on this: sector is for "when you want the embedding-geometry story," channel/stream for the multiplex. They're not competitors — they name opposite sides of the demux. That's compatible with what we converged on earlier today, and it rescues "dual-sector embedding" as correct usage rather than a naming leak.

Two rejections worth preserving as *reasoned* rejections: **mode** lost to run-modes/TeX-mode overload but survives demoted (local typesetting state: inline vs display); **multimodal** is reserved for the modality axis (raster vs text), which you'll need clean when rasterized figures join the pipeline — turn 3 explicitly protects that.

## What the thread produced that the draft dropped

This is the unpack payload — turns 8–11 contain a whole layer the draft starts *below*:

1. **The scheme/instance distinction.** Turn 9's stack: universal graph $G$ (the combinatorial scheme of all admissible manuscript structure) → configuration space over it → envelope as the locus of valid configurations → an envelope *instance* as one point. Your draft opens at "the envelope instance is a typed DAG" — the instance level — and never names $G$. But $G$ is load-bearing for MarkPig: it's the thing MarkPig's node-kind schema *implements*, while any parsed document is a configuration on it. That's the crispest statement of how codex-scientiae architecture connects to MarkPig's ASTs, and it's not in the draft.

2. **Demux after abduction, never on raw sources.** Turn 8's ordering constraint: streams are defined *on the envelope*; sources are too noisy and layout-variant to demux. One sentence, architecturally decisive — it's why channel separation is downstream of canonicalization, not a preprocessing trick.

3. **Fibers.** $\pi^{-1}(e)$ = the equivalence class of source realizations abducing to one envelope point — "the geometric home for variant PDFs of the same paper." Absent from the draft, and it's the concept your v1/v2/publisher-variant problem has been missing a name for.

4. **The TDM working vocabulary.** *Slot* (maximal contiguous run of one channel), *framing/sync tokens* (`$…$` delimiters as what keeps the demuxer locked), statistical-TDM (variable-length slots), and the sharpest line in the whole thread: **the demux key is codebook membership, not surface orthography** — `sin`, `log`, `ln` belong to the math channel by lexicon membership even though they look like prose. That last one is your masking criterion stated in one clause.

5. **The dual-projection paragraph.** Turn 11 resolves the sub-addressing counterintuition better than draft lines 5–6 do: one graph, two coordinate systems — *path address* (hierarchical) and *spine address* (position × kind) — same visitors; "flattening doesn't destroy the tree, it exposes the order the tree already determined." There's a ready-to-reuse paragraph in that turn ("MarkPig is not 'a tree instead of a list'…") that is frankly better prose than the draft's current lines 5–6.

6. **The visitor hinge, operationally.** "Demux is a kind-filter on the walk; the spine position is the cross-stream anchor; MathDig hangs off math-kind nodes at those addresses." Draft line 10 gestures at visitors; these three clauses are the mechanism.

One caution flag: turn 9's manifold/simplex framing is mostly Perplexity enthusiasm amplifying your "I'd probably conjure the notion of the simplex or manifolds" — the parts that earn their keep are the scheme/configuration/locus ladder and fibers; the simplicial-cells table is decoration you never picked up again.

## mdnav test-drive verdict

It did its job well. The grain signature `22/130/137~6.09K` plus `breaks≈h1` identified the transcript shape before a byte was read; the 5.4% spine meant the depth-1 outline delivered your entire intent trajectory — all 21 questions verbatim — for one cheap call, which is what made a 46%-coverage reading *plan* possible instead of a linear slog. `--from/--to` merges and the coverage ledger behaved exactly as documented. Two frictions: (1) a 33 KB read got persisted to a sidecar file by the harness's output limit, costing an extra hop — for transcript units this size, piping through a footnote-stripping filter (as I did on the second read) keeps it inline and cuts ~15% citation ballast mdnav rightly won't strip itself; a `--strip-match` preset for Perplexity footnote blocks would do it natively. (2) Nothing else — the tool never guessed at meaning, which is precisely what left the reading judgments where they belonged.

If you want, next pass I can fold items 1–6 into the guidance draft as new condensed-concept paragraphs — but that's your call, since the draft's voice is deliberately yours.

---

# Good analysis, but i might push back on a few things. When i say sub-addressing, i'm talking about an instance of the latent universal manuscript graph object, and the semantic addressing afforded by a flat, reading-order sequential traversal over that instance. Its a *sub* address because its an extension of a system filepath address that extends into the document itself naturally, and only means anything if we have such an object to walk in the first place. The counter intuitive aspect is that ASTs are not usually walked to derive internal addresses within a document because they are usually about enumerating a tree. Sure it is a dual projection where you get a tree projection from the graph via the usual application of an AST, but so far i haven't seen anywhere else the idea of deriving an internal semantic address space from walking an AST tree in reading order and enumerating the sequential indices and nodes to compose such an address

That pushback lands, and it sharpens the claim in a way my "boring dual-projection story" (which I'd inherited from Perplexity's turn-11 framing) actually undersold. The dual projection is the *mechanism*; it isn't the *point*. The point is that you're treating the sequential projection as an **address space that composes with the filesystem** — `D:\corpus\paper.md` resolves to the document, and the address just keeps going: `paper.md : DisplayMath#3`. The file boundary stops being where addressability ends. That's why "sub-address" — it's subordinate to and continuous with the path address, not a separate indexing scheme bolted onto the side.

And I think your novelty claim survives an honest prior-art scan. The near-misses are instructive because each one is missing a different leg:

- **EPUB CFI** is the closest in *intent* — explicitly designed to extend a book's address past the file boundary into the interior (`book.epub#epubcfi(/6/4!/4/10/2)`). But it's a path address (child indices down the tree), and it's minted against a *realization* — reflow the publisher's XHTML and every CFI breaks. No canonical object underneath.
- **DOM document order** exists as an *ordering* but was never promoted to an *address space* — nobody cites "node 47 in document order" as a stable name, because in the DOM the walk is an implementation detail, not a contract.
- **XPath/mdast/Roslyn** all address by hierarchy or by source offset — line/col and byte spans are coordinates on the realization, exactly the thing that dies under layout variance.
- The one tradition that genuinely does kind-scoped ordinal addressing over a canonical object is **scholarly citation** — Bekker numbers, verse numbering, Stephanus pagination. "Chapter 3, verse 16" is `(kind, ordinal)` on a canonical text, and it stays valid across every edition and translation precisely because everyone quotients their realization back to the canonical object — your fiber structure, avant la lettre. But those address spaces were minted *by hand, once*, not derived mechanically from a walk.

Your concept is the intersection nobody occupies: **mechanically derived** (from the walk) × **canonical** (minted on the envelope instance, so it resolves identically across the whole fiber of source variants) × **path-composable** × full AST grain. The scholars had the semantics without the mechanism; the compiler world has the mechanism without the semantics.

Which also exposes *why* it's counterintuitive to explain, and it's not that people think trees can't be ordered. It's that in every AST people have met, **traversal order is ephemeral** — an implementation detail of the visitor, changeable without breaking anything. An address space needs a canonical enumeration, so nobody reads a walk as coordinates. Your envelope is different for one specific reason: **reading order is normative there** — part of the object's contract, because manuscripts *have* a reading order as a semantic fact, not a serialization accident. That's the load-bearing property. The explanation might land better ordered that way: *first* "in this object, the linearization is part of the spec, not the visitor," *then* "therefore the walk mints stable names," rather than leading with the tree/sequence duality.

It also gives you the cleanest one-line justification for the whole abduction architecture I've seen yet: a sub-address into a raw PDF is meaningless — which realization? whose text extraction? — so **canonicalization is what mints the address space**. Stable interior addresses aren't a bonus feature of the envelope; they're one of the reasons it must exist.

One small observation from your own toolshed: mdnav is a coarse-grain working prototype of exactly this. `D001:H0042` is `(document, kind-scoped ordinal)` derived from a structural walk, path-composable, with the `@digest` guard confessing the one thing it lacks — a canonical object underneath, so ordinals shift when the realization is edited. MarkPig sub-addressing is that same address shape pushed down to full grain and placed on the envelope, where the fiber-invariance mdnav can't have comes for free. You've already been navigating by spine addresses all session; the guidance draft's version is the one that doesn't break.

---

# i actually originally came up with this concept thinking about reposnapshot and powershell AST parsing as a way to chunk and sub-address my ingested powershell into semantic segments of shard file rows, flattened within the larger data structure of multiple code files from a repo, where the filesystem and sub-addresses would need flow naturally in order to retain my flat data structure with addressing in general encoding hierarchical information, both between files and within files, using the AST to granularly break down the code, coalesce related nodes into coherent chunks (a span of a function signature, its code body, taken together, like one might take a section header and body and put them together into a semantically chunked markdown document). The more i think about it there isn't that much of a difference between the two ideas, both code and my emerging markdown graph have sub-graphs and reference edges between non-adjacent nodes, sometimes with references of node at one level of granularity to a group of nested nodes (a citation pointer to a composite subfigure in the same document). I still intend to pursue this in reposnapshot for code when i can parse a given type of code file mechanically via AST or an interval-algebra/masking based pseudo-AST

The convergence is real, and I think it's tighter than "not that much difference" — the two projects are the same architecture instantiated twice, and the correspondences go further down than the addressing layer.

**The address algebra is literally shared.** `(filesystem path) × (kind-scoped ordinal within file)` — hierarchy between files carried by the path component, hierarchy within files carried by the address structure, flat storage underneath. The only asymmetry is that a manuscript has one spine while a repo is a *forest* of spines indexed by path — and that's fine, because between-file order was never normative anyway; the path already carries it. Spine normativity is only needed where you claim it: within a file, where source order is a semantic fact for code exactly as reading order is for manuscripts.

**Your chunking rule is the figure-composite rule.** "Signature + body taken together" and "header + section body" and "figure + caption" are one criterion: **a chunk is a span on the spine that is also a closed subgraph.** Contiguous in the walk *and* structurally complete — both conditions, not either. That dual condition is exactly what makes a chunk coherent rather than arbitrary, and it means a chunk's address doesn't need to be a raw span: it's the address of the dominating composite node (`FunctionDefinition#7`), with the span derivable. Your cross-granularity references — citation pointer → composite subfigure — are then just ref edges whose target is a composite kind, which is the same thing a call site does when it references a function rather than a line. Both domains need composite-addressable targets, and both get them from the same (kind, ordinal) scheme the moment kinds include composites.

**The furniture criterion transfers verbatim, which surprised me when I saw it.** *If removing it changes the parse, it's substance; if only formatting changes, it's furniture.* Apply that to code: whitespace and layout are furniture, the AST is the invariant — and two differently-formatted versions of the same code parse to the same AST, which means code has a fiber structure too. Formatting variants quotient onto one canonical object. Code's envelope already exists and already has parsers; it's called the AST. That's *why* your RepoSnapshot instinct worked: PowerShell handed you mechanically what the whole codex-scientiae abduction apparatus exists to recover for PDFs — a canonical object whose realization variance has been quotiented out. The manuscript project is the hard-mode version of the same move, where the parser has to be abduced instead of imported.

**Even the channel structure transfers.** Comments and doc-strings are a prose channel interleaved with the code channel in source order — a two-channel multiplex, demuxable, cross-linkable, dual-embeddable. This isn't a stretch I'm adding: the dual-channel source-code literature (Casalnuovo/Devanbu — formal channel vs. natural-language channel sharing surface tokens) was already sitting in your Perplexity thread's citations as the precedent for *the manuscript* split. The citation chain runs code → manuscript; your two projects close the loop back.

On the mechanical-parse ladder: the interval-algebra/masking pseudo-AST rung is worth designing *to the same address contract* rather than as a fallback with its own semantics. Any backend that yields (kinds, extents, normative order) can mint addresses; a stronger parser refines grain and kind fidelity but never changes the address algebra. PowerShell's AST is the top rung (every node already carries an `Extent` — the interval algebra comes for free); interval-algebra masking is the doccer-shaped rung below it — and doccer is prior art in your own ecosystem for exactly that calculus; mdnav is the existence proof that even the crudest rung (headings-only masking over raw markdown) yields a usable address space. Define the algebra once, let backends slot in per file type at whatever rung exists.

The one place code is genuinely harder, worth having eyes open about: **address stability across snapshots.** The manuscript envelope gets fiber-invariance from canonicalization — every variant PDF resolves to the same addresses. RepoSnapshot's corpus *changes over time*, and kind-scoped ordinals shift when a function is added above another. Formatting-quotienting helps (reformatting doesn't move AST ordinals), but insertion does — so the code side needs the mdnav move (digest guards that make a stale address fail loud) or name-qualified addresses (`function:Get-Thing` as primary key, ordinal as tiebreaker) in a way the manuscript side, addressing frozen published objects, never does. Different stability regimes, same algebra.

---

# well interval algebra as i see, is how I'm proposing a robust alternative alternative approach to a formal AST parser, indeed a mechanism for parsing differently and based highly agnostic primitives that can serve both code analysis and document processing needs, because interval algebra can do its job whether or not the code or document syntax is valid, and chalk up the residuals rather than failing loudly, which in reposnapshot's case and other cases, is a virtue, where one wants to package up code warts and all and share it with an assistant, or an assistant wants to generate a snapshot on code that's potentially broken in order to deep dive that code to find and fix a parsing error.

Yes — and this corrects my "ladder rungs" framing from earlier, which had the relationship wrong. A ladder implies the AST dominates when available and interval algebra is the thing you settle for. What you're describing is a different *contract*, not a lower fidelity: the formal parser is **precise but partial** — it's validity-gated, so it fails exactly when the artifact most needs inspection — while interval algebra is **total by construction**. An interval cover of a byte range always exists (trivially: one interval); every delimiter or mask you recognize refines the partition monotonically; failure to recognize just leaves a coarser cell. The output type is always "a labeled cover, some labels UNKNOWN" — never bottom. It's an anytime algorithm: stop refining wherever you like and you still hold a valid, addressable segmentation.

One honesty note, because it's the strongest counterargument to "ASTs fail loudly": the modern parser generation is *also* error-tolerant. PowerShell's own `Parser.ParseFile` returns an AST plus an error list rather than throwing; Roslyn and tree-sitter produce trees for broken code with error/missing nodes. But I think your position survives that, for three reasons that are actually sharper than the totality claim alone:

1. **Residuals, not guesses.** An error-recovering parser's tree in the damaged region is a *fabrication* — recovery heuristics you don't control, version-dependent, presented with the same confidence as parsed structure. Interval algebra refuses to interpret what it can't classify; it segments, labels the cell residual, and moves on. That's the same epistemic stance as your no-magic-string doctrine and the confidence-bounded converter throughline: principled signal or explicit deferral, never confident fabrication. For the deep-dive-broken-code use case this matters concretely — you want to *address* the damaged region ("the residual at cells 14–17"), not receive a parser's guess about what it might have been.

2. **One calculus, every file type.** Error recovery is per-grammar and uneven; interval algebra needs no grammar at all. The same primitives segment PowerShell, markdown, LaTeX, a config format nobody wrote a parser for, and a file whose type you haven't identified yet. That's what makes it servable to both RepoSnapshot and document processing rather than being a code tool with a document port.

3. **The snapshot is a witness.** "Warts and all" is a faithfulness requirement — the snapshot must testify to the actual state, including brokenness. A parser that repairs-while-reading corrupts the witness. Interval algebra is non-interpretive: it never rewrites, only segments and annotates, so byte fidelity survives and structure rides on top as labels. Same principle as your LaTeX-faithful-not-filtered doctrine, and same design as mdnav's elisions being "addressed, not hidden."

So the composition isn't ladder but **scaffold + refinement**: interval algebra provides the total, always-valid cover; the formal AST, where it exists and where the content parses, refines cells *inside* that cover with fine kind structure. Regions that don't parse remain as labeled residual intervals — still addressable, still chunkable, still shippable to an assistant. The address algebra stays uniform throughout because interval cells have extents and coarse kinds; AST refinement just deepens the kind vocabulary within cells. And the residual fraction falls out as the oracle-free health signal — the same genus as pdfdig's `known_role_frac`: how much of this artifact did the scaffold fail to refine is a number you get for free, per file, no ground truth required.

Worth noticing how consistent your stack already is with this: mdnav's core invariant — units concatenate byte-for-byte, headingless documents become one BODY cell, unrefinable stretches get flagged UNBROKEN rather than sliced — *is* total interval parsing with residual accounting. And inside the manuscript pipeline the same pair already exists in embryo: math masking (now landing as a shared primitive in `src/shared/masks.ps1`) is an interval labeling over the byte stream — total, agnostic, never fails — while MathDig is the future formal refinement of exactly those intervals. The furniture criterion had this shape too: lexical rung total, parser rung precise. So the RepoSnapshot proposal isn't importing a foreign technique; it's the same two-layer parse discipline your document side has been converging on, which is about as strong a validation of "highly agnostic primitives serving both" as you could ask for.

---

# another advantage of an interval algebra engine, if its built to sufficient generality, it could power pseudo-AST parsing of any language or document type using a relatively small amount of generic code + adapters as needed, instead of importing ASTs for each language and managing and increasing nightmare of growing number of languages in a project that's specifically concerned with cross-language coverage

That's the economics argument, and for a cross-language project it's probably the decisive one. Importing per-language ASTs doesn't scale linearly — each parser is a dependency with its own version churn, build surface, grammar quality, and platform quirks, and the project's floor drops to the weakest vendored grammar. The interval engine inverts the shape of the cost: **one calculus, testable once, plus adapters that are mostly data rather than code.**

Worth being precise about what an adapter actually has to supply, because it's smaller than "a parser for language X":

- **A masking profile** — string literals, comment syntax, here-docs, fences: the regions where delimiters *don't count*. This is the only genuinely tricky part (quote-inside-comment, comment-marker-inside-string), but it's one generic algorithm parameterized by the profile, written once. mdnav's fence-awareness — tracking backtick/tilde fences so `# comment` inside a code block isn't a heading — is already this, in miniature, for one document type.
- **A segmentation profile** — delimiter pairs, statement separators, indentation semantics, section markers. Nearly declarative.
- **Kind-assignment patterns** — optional, per-language, incremental: the signature-shape that says *this* brace block is a function body. Crucially this tier is pure refinement — omitting it coarsens labels, never breaks the cover. So an adapter can start at twenty lines and grow monotonically, and your coalescence rules (signature+body chunking) live here without being load-bearing for totality.

There's encouraging prior art for both the pattern and the economics. The academic name for the pattern is **island grammars** (Moonen, ~2001): parse the islands you care about, treat the rest as water — your engine generalizes it by making the water first-class, addressed, residual-accounted rather than discarded. And the production proof of adapter economics is forty years old: Emacs syntax tables are exactly a generic delimiter/masking engine parameterized by tiny per-language declarative profiles, and they've covered essentially every language that's ever existed with a page of configuration each. Tree-sitter is the opposite bet — N precise grammars, heavy infrastructure — and it's the right bet for IDEs, where depth per language beats breadth. A project *specifically about* cross-language coverage flips that trade exactly as you say.

Two additions to the case:

**The adapter registry gets a built-in quality gate for free.** Because residual fraction is a first-class output, an adapter's worth is measurable without any oracle: run the engine over a corpus in language X, watch residual mass and refinement depth. A new language earns graded, observable coverage — profile in, residuals drop, numbers say how far you got — versus the binary and unverifiable "we imported a parser." That's `known_role_frac` again, now doing double duty as the acquisition loop for language support. For RepoSnapshot that means language coverage becomes an empirical curve you can publish, not a checklist.

**Native ASTs slot in as opportunistic refiners without compromising the thesis.** PowerShell's parser is in the box; Roslyn is nearly free in a .NET house. The two-layer composition from before lets you use them where they cost nothing — as refinement backends inside interval cells for the languages that happen to have them — while the generic engine remains the *contract* and the guaranteed floor everywhere else. The registry decides per file type which refiners exist; nothing downstream can tell the difference except finer kinds.

And note you're already running this architecture in the manuscript stack: the math-register canonicalizer is a small generic engine driven by declarative stores — `aliases.json`, `furniture.json`, `unicode-glyphs.json` sitting in `src/latex-ingest/stores/` right now — which is precisely "generic core + data adapters" applied to LaTeX dialects instead of programming languages. The house style already is the thing you're proposing; RepoSnapshot's interval engine would be its third instantiation, after the lexicon stores and the masking primitives.

---

# i would extend my bet further: any given AST parser relies on the same general mechanisms of recursions and evaluation etc. what's to stop the interval algebra engine from achieving perhaps more compactly and definitely less idiosyncratically, the same completeness of any given language's native AST? sounds like emacs is already pretty close

There's a crisp theoretical answer to "what's to stop it," and it's smaller than the parsing establishment's instincts would suggest — but it's not nothing, and locating it precisely actually strengthens your bet.

Decompose what a native AST parser knows. Almost all of it is three things: **masked lexical structure** (strings, comments — regular languages), **visible nesting** (delimiters — formally, Dyck languages / visibly-pushdown languages, where the stack discipline is readable off the surface: push on open, pop on close), and **operator precedence** (the invisible tree shape in `a + b * c`). The first two are your interval engine already. The third sounds like where "real parsing" lives — but precedence parsing is itself a tiny generic engine parameterized by a table (Pratt parsing, rediscovered every decade because it's ~a hundred lines and eats any expression grammar you feed it as data). Emacs is evidence for exactly this layering: syntax tables (masking + delimiters) → `forward-sexp` (intervals) → SMIE, which is literally a generic operator-precedence engine each mode configures with a small grammar table. Three generic engines, declarative data each. That's most of every language.

The genuine ceiling — the part no declarative adapter can capture — is where **parsing requires evaluation**: C's `T * x;` needs a symbol table to know if `T` is a type (the "lexer hack"); C++ template parsing is Turing-complete; Perl's parse can depend on running `BEGIN` blocks; and the deepest case you already know intimately — TeX, where macro expansion mutates catcodes, so the grammar is dynamic and "parsing TeX" means running TeX. Native parsers handle these by embedding an evaluator, which is precisely the idiosyncrasy you're trying to escape. The interval engine's honest answer is the one it always gives: residual, confidence-bounded, no guessing.

Here's the reframe that makes the bet close: **that ceiling barely intersects your completeness bar.** "Complete" for a compiler means every token resolved to semantics. Complete for segmentation, chunking, and sub-addressing means correct extents, nesting, and kinds at composite granularity — and the evaluation-dependent ambiguities are almost always *interior to cells* at that granularity. Whether `T * x` is a declaration or a multiplication moves nothing: the statement's extent, its enclosing function, its chunk membership, its spine address are all identical either way. Even precedence is skippable for v1 — statement-level structure suffices for the address algebra; expression trees are refinement you can add per-language when something downstream actually wants them. The hard 2% of parsing is concentrated at exactly the structural depths sub-addressing doesn't consume.

On compactness, you're also right, and it's worth knowing *why* grammars are bloated: real grammar files encode precedence as cascaded rule levels (the expr/term/factor tower repeated for a dozen precedence tiers), plus error-recovery productions, plus — in modern infrastructure like Roslyn's red-green trees and tree-sitter's incrementality — enormous machinery for *editing*: incremental reparse, full-fidelity round-tripping, IDE latency budgets. RepoSnapshot reads frozen snapshots. You get to drop the entire editing apparatus, which is where most of the engineering weight in those codebases actually lives. A masking profile + delimiter set + optional precedence table against three shared engines is plausibly a hundred lines per language versus tree-sitter's thousands, *because* you're not paying for concerns you don't have.

So the corrected form of the bet, which I'd endorse: the interval engine can reach **native-AST parity for every structural fact the address algebra consumes**, across languages, with generic engines + data adapters — and the gap to *compiler* parity consists of evaluation-dependent cases whose correct handling in your architecture is residual accounting anyway, not because the engine is weak but because guessing there is wrong on principle. Emacs isn't "pretty close" by accident; it's forty years of proof that navigation-and-structure completeness — your completeness class — never needed the grammar tower. The one place I'd hold a caveat: kind *richness* (distinguishing a method from a property accessor from a lambda body) is where per-language pattern investment accumulates, and that curve is real even if it's monotone and optional. That's the tax you pay gradually, per need — not the wall the native-parser world would predict.

---

# right, and so here's where my interval algebra engine gets its completeness. fill in everything you can without needing to run the code, then add a language specific adapter layer for running a given language's kernel or interpreter in order to do the same thing, but in this case, as one extension of the more general engine. rhymes with the layer below with operator precedence tables and table parameterization

That closes the ladder, and it closes it *by construction*: the top adapter is the language's own definitional evaluator, so the engine's ceiling becomes identical to the language's own ceiling — there is no higher authority to be short of. Parity stops being a benchmark you chase and becomes a property of the architecture: static rungs cover everything decidable without evaluation, and the evaluation rung covers the rest by delegating to the only thing that *can* decide it. The full ladder reads: masking profile → delimiter intervals → precedence tables → kind patterns → kernel adapters, each a parameterization of the same engine, each refining cells the rung below left coarse.

The rhyme with the table layer is real but has one disanalogy worth keeping visible: **tables are data; kernels are processes.** Pure, total, auditable versus effectful, partial, needing sandboxing and timeouts. What saves the rhyme is that your residual discipline already absorbs the difference — a kernel that times out, crashes, or chokes on broken code just leaves the cell residual with a note, exactly like an unrecognized delimiter. The evaluation rung inherits the anytime property instead of breaking it. And the witness property survives because evaluation only ever adds *labels*: the snapshot stays byte-faithful; running the code refines the annotation, never the bytes. Notably, for RepoSnapshot's broken-code use case the top rung will often fail — and that's the designed behavior, since the lower rungs carry the file regardless.

One refinement that makes the tier much cheaper in practice: evaluation isn't binary. There's a stage spectrum — **parse-with-errors → expand → bind → execute** — and most parse-requires-evaluation cases resolve well short of full execution. C's typedef ambiguity needs binding (a symbol table), not execution. TeX macro questions often need expansion only. PowerShell's `Parser.ParseFile` gives you AST-plus-errors without running anything, so its evaluation rung is nearly free. If adapters declare which stages they can supply and the engine requests the *weakest stage that resolves the residual*, most kernel invocations stay side-effect-free, and full execution becomes the rare, explicitly-consented top of the top rung.

External validation exists for both halves of this tier. PPI — the Perl static parser — is the heroic proof of the static rungs: a deliberate pseudo-AST that refuses to run code and *documents* the undecidable residue, which is your residual ledger avant la lettre for the one language everyone agrees can't be parsed statically. And Jupyter kernels are proof that "run a language's evaluator behind a uniform protocol, one adapter per language" is a sustainable registry pattern rather than a maintenance fantasy — someone already industrialized the evaluation-adapter layer; your engine could speak something kernel-shaped and inherit that ecosystem's shape, possibly some of its actual kernels.

But the strongest precedent is in your own stack, and it's worth savoring: **this is the latex-oracle architecture, generalized.** TeX was the paradigm case of the evaluation ceiling, and codex-scientiae's answer was never "write a better static TeX parser" — it was to run a lane through the language's own machinery and treat it as the per-document oracle, with pdfdig's whole charter being *parity with that oracle* from static evidence. Static extraction aspiring to oracle parity, evaluation as the ground-truth adjudicator, residuals confessed where neither reaches — that's the manuscript stack today, and it's rung-for-rung the code-side design you just described. The interval engine isn't borrowing a pattern from the document work or vice versa; both are instances of one parsing doctrine you've now stated in full: **fill in everything decidable from the surface; delegate to the definitional evaluator at exactly the margins where surface evidence runs out; account for whatever remains.** That sentence might belong in the guidance draft — it's the code-and-manuscript-unifying form of the abduction story.

---

# well what i'm trying to get at is a sort of nested graph of conceptual flow going from source -> markdown <-> markpig/mathdig, trying to elucidate the architectural and structural concepts (terminology, like channel, fibers) as well as design concepts (abduction, surjection, etc) , putting the markdown deliverable target in context of the invisible ASTs to highlight where i'm going but also the boundary, and trying to articulate working guidance for understand what is being built and why, the problems that it solves, and so much more. another thing i was trying to iron out is a more procedural outline of what i want latex-ingest to look like near-term as a stop-gap until i get back to developing the next-gen version in earnest `D:\aghado01\codex-scientiae\issues\reboot\latex-ingest\latex-ingest-workflow.md` which i started but barely

Now the two documents come into focus as a pair: the guidance draft is the *conceptual graph*, the workflow file is its *procedural projection* — same concepts, execution order, tools named. Looking at what's settled this session versus what the skeleton has, here's the shape I'd propose for each.

## The guidance draft: two planes plus a boundary

The material that's accumulated wants to separate into an **object plane** and a **process plane**, because the terminology confusion you've been fighting (register!) came precisely from letting nouns and verbs share words:

**Object plane** (structural nouns, the "nested graph"): universal graph *G* (the scheme MarkPig implements) → manuscript DAG (an instance) → spine (the normative linearization — normative is the load-bearing word) → channels (math/prose interleaved along it) → slots (maximal single-channel runs) → composites (closed subgraphs: figure+caption, signature+body) → sub-addresses (filepath extended by kind-scoped ordinal over the walk) → fibers (the equivalence class of source realizations over one envelope point) → sectors (post-demux embedding subspaces) → lexicon (the conformance standard for math-channel content).

**Process plane** (design verbs): abduction (inference to the canonical object), surjective canonicalization (the many-to-one quotient), demux (channel projection *on the envelope, never on raw sources*), evidence-then-strip (furniture consumed as parse-time evidence, never surviving into output), coalescence (chunking at closed-subgraph boundaries), residual accounting (confess what you couldn't refine; residual mass is the health signal).

**The boundary section** — the part you flagged as hardest — I think has a one-sentence spine: *the markdown deliverable is the serialization of an envelope instance whose parsers don't exist yet.* Today's lanes behave *as if* the graph existed (spec-is-intent); MarkPig/MathDig are the future parsers that make the latent object mechanically manipulable; and the dependency arrows run the way we established early in this session — the criteria are denotational now, the ASTs formalize them later, and **every adjudication made in today's stop-gap lanes is a conformance fixture for tomorrow's parsers**. That last clause is what makes the stop-gap work *count toward* the next-gen system instead of being throwaway, and it deserves to be stated as doctrine. The unifying parsing sentence from the interval-algebra thread — *fill in everything decidable from the surface; delegate to the definitional evaluator exactly where surface evidence runs out; account for the remainder* — belongs here too, since it's the form of the doctrine that covers both this project and RepoSnapshot's code side.

## The workflow file: what the skeleton hasn't decided yet

The bullet list has the right verbs but hasn't committed to an order or named the seams. The decisions I'd surface for ironing:

1. **What "unpack" covers, and in what order** — tarball → main-file identification → `\input`/`\include` flattening → author macro-preamble harvesting → per-paper patch application (your patch lane, fail-loud on staleness). Macro expansion *before* evidence processing is implied by the draft's "macros expand fully into flat KaTeX-valid blocks," but the skeleton doesn't yet say where the macro table comes from or when patches apply.
2. **Where the stores plug in.** Each surjection bullet is engine + declarative store — `aliases.json`, `furniture.json`, `unicode-glyphs.json`, `evidence.json` just landed in `src/latex-ingest/stores/`. The workflow should name which step consumes which store, because that's also the maintenance story (fixing a conversion bug = usually editing a store, not code).
3. **The two-consumer tap.** Your one-tap-two-consumers design (math bank + structure skeleton) needs a marked split point in the flow — presumably after the IR assembles but before emission.
4. **Where the evidence pass ends and the strip begins.** The skeleton lists "processing notational evidence" and "stripping furniture" as siblings; the doctrine says they're sequenced (evidence extracted → used to build the stable form → then stripped). Worth making the ordering explicit since it's the whole `\operatorname` story.
5. **Gates and their severities** — render_check (the KaTeX floor), lint, encoding invariants: which are blocking versus advisory, and where they sit (per-step or terminal).
6. **The rasterization decision point** — already litigated (encode-first, PNG last resort, flagged), so the workflow just needs to say *where* the decision is made and where the flag lands.
7. **Stop-gap vs placeholder marking.** For each step, whether it's the enduring shape or a stand-in — e.g., "jsonl proto-manuscript IR" is the stop-gap serialization of what becomes the MarkPig DAG; "envelope nodes compiled into linear reading-ordered chunks" is the spine, pre-formalization. Tagging each workflow step with the guidance-draft concept it instantiates would bind the two documents and make the workflow double as a worked example of the conceptual graph.

That last point is the pair's real value: the guidance draft says *what the objects are and why*; the workflow says *the order in which the verbs run over them, with today's tools*; and the tags make it checkable that the stop-gap is walking the same graph the next-gen system will formalize.

When you want either of these actually drafted into the files — the two-plane reorganization of guidance-draft.md or the fleshed workflow outline — say the word and I'll write them in your current voice rather than spec-speak.

---

# lets try workflow outline. but what i'm trying to do there is write the spec for what i want latex-ingest to become in the near-term development, which is an end-to-end latex-to-markdown pipeline with a bundled delivery, and i'm currently working on entangling primitives relevant to doing this with all of the mixed concerns code that was originally written when this objective was secondary and an afterthought to writing my first attempt at pdf converter and wielding the latex oracle. i've taken several steps back and i just want a reasonable working latex ingest end to end that i can trust. it doesn't even need to be complete in the sense of being general for every possible example of latex source, it just has to establish the machinery and methodology for adapting to a broader test set later

Written to [latex-ingest-workflow.md](issues/reboot/latex-ingest/latex-ingest-workflow.md). The skeleton's three steps and bullets are absorbed into an 11-stage pipeline, each stage naming the primitives that already exist (`Expand-ArxivSourceTarball` → `Find-LatexMain` → `Resolve-LatexInputs`, both patch seams with `Assert-PatchHits`, the mask substrate, `New-LatexEvidenceLedger` → `Invoke-LatexMathStoreLowering` → `ConvertTo-RegisterMath`, the md-toc/md-bundle delivery tail) so the spec describes a reorganization of real machinery, not an invention.

The load-bearing decisions I committed to, which you should sanity-check:

- **The disentanglement rule** is stated as a hard dependency boundary: latex-ingest may depend on `shared/`, `math-register/`, `md-postprocess/`, `audits/` — never on `codex-membrane/`. Math machinery duplicated between `latex.ps1` and membrane `normalize.ps1` resolves by *promotion into the shared layer*, not cross-lane import, and the membrane becomes a consumer of this lane's output rather than a host for its guts. This is the crux of your "several steps back," so it's the first thing to veto if I've drawn the line wrong.
- **Trust is defined operationally** up top: byte-identical reruns from (source, patches, stores, code); gates fail loud; everything unhandled lands in the residual report. Stage 4's segmentation is written as total-by-construction with residuals ledgered — the interval doctrine from our conversation, now normative for the lane.
- **Evidence → lowering → surjection → strip is strictly ordered** in stage 6, with the furniture criterion stated denotationally (no MathDig dependency).
- **The adaptation methodology** encodes your "machinery and methodology, not completeness": failure triage runs patch case → store gap → engine gap, with store growth named as the *intended* generality channel and every adjudication committed as a fixture — the same corpus that later defines MathDig conformance.

Three `[REVIEW]` flags mark what I genuinely couldn't decide for you: macro expansion depth policy (fixpoint vs one-level-plus-residual), the blocking/advisory split across the `latex.ps1` defect-span detectors, and the exact pinned set given that gauntlet runs are paused. One more decision worth your eye that I didn't flag inline: I placed macro harvest/expansion as a global stage 3 (before segmentation), but per-span expansion inside the math-channel stage is a defensible alternative — the file currently implies global, and if `Invoke-LatexMathStoreLowering` already does per-span lowering, stage 3 may reduce to harvest-only.

---

# i think macro expansion should happen to exhaustion and then be reduced into the target math channel standard

Settled and edited in. Stage 3 now reads: expand to exhaustion — fixpoint iteration, so no author macro survives past that stage — with reduction into the lexicon explicitly deferred to stage 6, which now operates only on post-expansion material. The one guard I kept from the old flag: the fixpoint loop is capped, and a span that won't converge (recursive or pathological definition) goes to the residual ledger unexpanded rather than being looped on or guessed at — same totality discipline as everywhere else.

This gives the two stages a clean division of labor: stage 3 eliminates the author's dialect (expansion), stage 6 imposes the house standard (reduction). Expansion never reduces; reduction never sees a macro. It also resolves the placement question I'd raised — expansion is global at stage 3, not per-span inside the math channel.

Two `[REVIEW]` flags remain in the spec: the blocking-vs-advisory split across the defect-span detectors, and the pinned set pending your fresh test materials.

---

# well, as we discussed earlier, their's a limit to static interval algebra analysis, and this is where i need to rope in proper latex parser to reliably expand the macros where the interval algebra can't handle it alone. this is admissible dependency for getting the job done

Done, in both places. Stage 3 now encodes the three-step escalation — static interval expansion → LaTeX-parser oracle → residual ledger — and the disentanglement rule carries the matching clause: one external dependency admitted, scoped as an *expansion oracle for bounded questions*, never as the conversion engine. That scoping line is the part protecting you from the failure mode where "we use LaTeXML for macros" quietly becomes "we're a LaTeXML wrapper" — the lane keeps ownership of segmentation, IR, lexicon, and emission; the parser only ever answers "what does this span expand to."

That adds a third `[REVIEW]`: engine choice (LaTeXML, pandoc's LaTeX reader, pylatexenc, or TeX itself in expand-only mode). Worth noting the weakest-stage principle cuts differently per candidate — LaTeXML and pandoc are parsers that happen to expand, while TeX-in-expand-mode is the definitional evaluator itself; the former are easier to invoke per-span, the latter is the ground truth when dialects get weird. The pinned set is probably what decides it: whichever engine closes the actual residuals in the voroninski corpus with the least ceremony wins, and that's an empirical question the residual ledger will answer for you.

---

# i kind of favor just harnessing tex properly so i can use it as needed and not hop around different dependencies based on level of convenince. write the tex harness once and wire it into the process properly. this isn't that different from me importing lean or R in thermomapper so i use them as needed for test fixtures or testing lemma formulations derived from the work

Two consistency fixes applied:

1. **Disentanglement rule** now names the decided dependency — the TeX engine via `tex-harness.ps1` — instead of the generic "a LaTeX parser/expander," with the Lean/R instrument posture stated: written once, invoked as needed, never the conversion engine.
2. **The trust definition** gains a member: the reproducibility tuple is now (source, patches, stores, code, **TeX engine version**), with the run manifest recording the engine/format version. Once a definitional evaluator joins the pipeline, its version is part of what "byte-identical rerun" is conditioned on — same reason your patch lane fails loud on staleness.

The spec is now decision-complete except for the two remaining `[REVIEW]`s that genuinely wait on you: the blocking-vs-advisory split across the defect-span detectors, and the pinned set pending your fresh test materials. And the harness itself is a nicely self-contained build item when you're ready — `tex-harness.ps1` has a crisp contract (macro table + span in, expansion + convergence status out, deterministic given the tuple) that can be Pester-tested against known expansions before it's ever wired into stage 3.

---

# what does installing the tex dependency look like? right now i've got all these `tools` involved in pdf and latex conversion, including tectonic somewhere on my system that gets roped in even in the latex ingest process, which ive never really liked, but which is involved in processing extracted images, and which always felt kind of round-about

Short answer: **nothing new to install — you already vendor a full TeX engine.** Tectonic *is* XeTeX plus a pinned TeX bundle in a single self-contained binary. What's missing isn't a dependency; it's the formalization of the one you have. And I think that re-scoping also dissolves the thing you've never liked about it.

Looking at how it's wired now: `tex-render.ps1` owns `Get-TectonicPath` (PATH or vendored under `tools/tex-render`), anchors `TECTONIC_CACHE_DIR`, and uses the engine for one purpose — snippet → PDF → PNG — which `latex-ingest.ps1` dot-sources for the diagram ladder and the EPS/PS wrap. So the current relationship is: *the image path incidentally drags a TeX engine in*. That's the round-about feeling, and it's a correct instinct about the **ownership**, not the tool: a figure-rasterization helper shouldn't be the thing that owns the TeX engine.

The harness decision inverts that. `tex-harness.ps1` owns the engine as a first-class instrument (your Lean/R posture), and the duties become bounded questions asked of it:

- **Expand** — "what does this span expand to under this macro table" (the new stage-3 oracle)
- **Render-snippet** — "what does this TeX-native diagram look like" (what `tex-render.ps1` does today; it becomes a consumer of the harness instead of the engine's landlord)

The EPS wrap deserves an honest word: compiling a `standalone` document to convert an image format genuinely *is* round-about. The direct alternative is Ghostscript, which is what everyone else uses for EPS→PDF. But that's a whole new dependency for one rare asset class, and your wrap reuses an instrument you already own — under the harness framing it stops being "tectonic gets roped in" and becomes one more bounded question through the standing instrument. Defensible; keep it, now with clean ownership.

On why tectonic is actually the *right* engine for the harness, by your own doctrine, versus the alternatives you'd install:

- **Tectonic**: one binary, hermetic, bundle version pinned to the binary release, cached (you already anchor the cache dir) — deterministic and offline after first fetch, no shell-escape, portable-env shaped. The trust tuple's "TeX engine version" is just the binary version recorded in the run manifest.
- **MiKTeX**: Windows-friendly but installs packages on the fly over the network — nondeterminism baked in, which violates your trust definition unless you fight its defaults.
- **TeX Live / TinyTeX**: respectable, but a multi-GB tree or an on-demand fetcher, a second cache discipline, and a yearly freeze cycle to manage — all to get an engine you already have in vendored-binary form.

Expand-only mechanics with tectonic are straightforward: the harness writes a driver `.tex` that loads the harvested macro table, `\expanded`/`\edef`s each span, `\write`s the results to a sidecar file, and typesets nothing meaningful — you discard the trivial PDF and read the sidecar. Batch spans per invocation to amortize startup, same as `tex-render` already batches compile jobs. One caveat for the ledger rather than for worry: tectonic is XeTeX-based while arXiv papers target pdfTeX — for pure macro expansion the semantics are essentially identical, and the rare dialect edge lands in the residual report like everything else.

So "installing the TeX dependency" comes down to three small acts: promote the vendored tectonic binary from `tools/tex-render` to the harness's engine (one canonical location, `Get-TectonicPath` moves into `tex-harness.ps1`), record its version in the run manifest, and make `tex-render.ps1` consume the harness. When you want it, the spec's stage-3 engine bullet can take one added line — "engine binary = the already-vendored tectonic" — to close the loop.

---

# well where should the promoted tectonic binary live? its not source code. its an external dependency, resembles the result of a compiled C# build that is internally vendored (hdbscan). but its not built internally. its not a python dependency in a venv. what would be the idiomatic place to put it in a multi-language project like this?

The taxonomy you're groping at has a real answer, and it's a third tier your repo already half-has. The distinction that decides placement isn't "binary vs source" — it's **what the repo can reproduce it from**:

- `bin/` — artifacts **we build**: reproducible from `src/` via `scripts/build-*.ps1` (the hdbscan pattern). The repo owns the recipe *and* the ingredients.
- language d

---

# [Request interrupted by user]

---

# sorry please continue

No problem — picking up the taxonomy from the top:

- `bin/` — artifacts **we build**: reproducible from `src/` via `scripts/build-*.ps1` (the hdbscan pattern). The repo owns the recipe and the ingredients.
- Language dependency trees (venv, `node_modules`, NuGet) — reproducible from a **committed manifest** by the language's own package manager. The repo owns the pin; the ecosystem owns the fetch.
- **Pinned external instruments** — prebuilt binaries the repo neither builds nor has a package manager for. Tectonic is this, and the idiom for it in multi-language projects is: **commit the pin and the fetcher, never the binary.** A `tools/<instrument>/` home containing a small manifest (version + download URL + SHA-256) and an acquisition script (`scripts/get-tectonic.ps1`) that materializes exactly the pinned binary into that directory; the binary itself is gitignored. This is the gradle-wrapper / protoc / terraform pattern — the repo can always reproduce the instrument from what's committed, but git never carries 40 MB of executable.

Two specific points for your layout:

**Name the home after the instrument, not the consumer.** `tools/tectonic/`, not `tools/tex-render/`. The current location is the ownership bug expressed at the filesystem level — the engine lives under one consumer's name, which is exactly the "roped in by the image path" arrangement we just dismantled in the code. `tools/` organized by instrument means `tex-harness.ps1` and `tex-render.ps1` are both just consumers of `tools/tectonic/`, and MuPDF (the other half of the render pair) gets the same treatment whenever you touch it next.

**The pin lives in the repo; the binary may live in either tier.** Your Lean/R analogy actually points at the machine level — those live in the portable environment, registered user-level, shared across projects — and tectonic will plausibly be wanted by scriba-scientiae too. The resolution that serves both without ambiguity is the ladder your `Get-TectonicPath` already gestures at, made explicit in the harness:

1. `$env:TECTONIC_EXE` — portable-env override, for the machine where it's centrally installed
2. `PATH`
3. `tools/tectonic/` — the repo-local materialization from the fetch script

with one addition that makes it trust-tuple-compliant: whichever rung resolves, the harness checks the *observed* `tectonic --version` against the committed pin and **fails loud on drift** — same discipline as `Assert-PatchHits`. Then it genuinely doesn't matter where the bytes live; the repo's committed pin is the authority, the run manifest records what actually ran, and a machine-level install that's newer than the pin gets caught instead of silently changing expansion behavior. The bundle cache you already anchor via `TECTONIC_CACHE_DIR` stays as-is — that's the instrument's data, correctly parked under a cache anchor rather than in the repo.

So concretely: `tools/tectonic/pin.json` (version, URL, sha256) + `scripts/get-tectonic.ps1` + a gitignore line, `Get-TectonicPath` moves into `tex-harness.ps1` and grows the version gate, and the portable env can adopt the engine later without the repo changing anything but nothing requiring it to. Near-term you run entirely off rung 3; the day scriba-scientiae wants the same engine, you register it user-level and both repos pin independently against one binary — exactly how Lean and R already work for you.

---

# how about lib/tectonic

`lib/tectonic` works, with one semantic caveat worth weighing before you commit the name: in most multi-language conventions `lib/` signals *code the program links or loads* — DLLs, assemblies, jars, things consumed in-process — while tectonic is an *executable invoked as a subprocess*, which is what `tools/` (or `vendor/bin`) conventionally holds. A reader seeing `lib/tectonic` will half-expect an assembly Add-Type'd somewhere; seeing `tools/tectonic` they'll expect an exe that gets shelled. Your repo's existing probe path (`tools/tex-render`) already leans the second way.

That said, the deeper question is what class of thing the directory is *for*, and there your instinct might be pointing at something real: if the tier you're creating is "external prebuilt dependencies we pin but don't build" — regardless of whether they're invoked (tectonic), loaded (MuPDF, if you ever vendor its DLL rather than shelling mutool), or data-shaped — then the established names for that unified tier are `vendor/` or `third_party/`. Those carry exactly the semantics you articulated two messages ago: not ours, not built here, pinned by manifest. `lib/` can be *defined* to mean that in your house style, but you'd be spending a small amount of every future reader's intuition on a nonstandard reading.

My honest ranking for this repo: `tools/tectonic` (matches the existing convention and the invoked-not-linked reality) > `vendor/tectonic` (if you want one home for the whole pinned-external tier and expect it to grow) > `lib/tectonic` (fine, but mildly off-register). It's a house-convention call, though, not a correctness one — the pin manifest, fetch script, and resolution ladder are what carry the trust, and the ladder makes the physical location a one-line change forever. If `lib/` reads better to *you* as the owner, define it once in CONVENTIONS and it's legitimate.

---

# well yea, the distinctions you make are true. but also true is that pdfpig is a dependency just the same as tectonic, only that pdfpig is assembly loaded in process vs tectonic executed in sub-process. perhaps what i'm reaching for is something like vendor/lib and vendor/bin , even if i dont care for 'vendor'

That reframe is right, and it's exactly the distinction the old Unix FHS split encodes: `bin/` = things the OS executes, `lib/` = things a process loads. PdfPig and tectonic are the same *tier* (external, prebuilt, pinned, not ours) consumed through different *modes* — so `<tier>/lib` and `<tier>/bin` is a genuinely idiomatic structure, not an invention. Your instinct is reaching for a two-axis classification: tier by provenance, subdivision by consumption mode.

For the tier name, if "vendor" grates, the candidates with real precedent: **`external/`** (Android AOSP, many C++ projects; reads plainly), **`third_party/`** (Google/Chromium; the most unambiguous, slightly bureaucratic), **`deps/`** (Erlang/C world; short, honest), `extern/` (Blender). Any of them says "not ours, not built here" without vendor's commercial flavor. `external/` is probably the best fit for your repos — self-describing, no underscore, no jargon.

One design wrinkle to settle before committing to mode-major (`external/bin/tectonic/`, `external/lib/pdfpig/`): some packages ship *both* modes. MuPDF is the live case in your own stack — `mutool.exe` is shelled today, but it's a library with an executable veneer, and a mixed package forces you to split one dependency's files across two homes, which fragments its identity and its pin. The alternative is package-major with mode inside: `external/tectonic/bin/`, `external/pdfpig/lib/`, `external/mupdf/{bin,lib}/`. Each package stays self-contained — its binary or assemblies, its `pin.json`, its license file, all in one directory you can delete and re-materialize atomically from the fetch script. That atomicity is worth a lot: the pin manifest governs a directory, not a scatter.

So my recommendation lands: `external/{package}/` with `bin/`/`lib/` inside only where a package needs the distinction (single-file packages can skip the subdivision entirely — `external/tectonic/tectonic.exe` next to its `pin.json` is fine). The resolution ladder in the harness is unchanged — env override → PATH → `external/tectonic/` — and PdfPig's `Add-Type` path just points into `external/pdfpig/`. If the Latin house register ever wants a word for this tier, it has one waiting — *aliena*, "things belonging to others" — but `external/` is the version every future reader parses at sight.

---

# what about `packages/{package}/...`

`packages/` is defensible, and it has one virtue the other candidates lack: it names the *mechanism* rather than the provenance. Your tier is defined by "materialized from a committed manifest by a fetch step" — pin.json is a lockfile, the acquisition script is a restore — and that mechanism is precisely what "package management" means. It also reads natively in your primary ecosystem: classic .NET solutions used `packages/` for exactly this (NuGet-restored external dependencies), and R and Python both use the word for installed externals. PdfPig arriving into `packages/pdfpig/` is practically self-documenting in a PowerShell/.NET house.

The one real cost: in the JS-monorepo world (pnpm/lerna workspaces), `packages/` now strongly means the *opposite* — first-party workspace modules, the repo's own code. Two collision scenarios follow: an agent or reader from that world momentarily inverts the meaning, and — nearer to home — if you ever modularize your own first-party PowerShell into proper modules, `packages/` would have been the natural modern name for *those*, and it'll be taken.

So the trade is: `packages/` = truest to the mechanism, at-sight legible in your stack, with a known aliasing risk against first-party modules; `external/` = truest to provenance, collision-proof forever, slightly less evocative of the restore discipline. Both are sound; neither needs more than a one-line definition in CONVENTIONS to be unambiguous in-house. If your gut says `packages/`, take it — the structure underneath (`packages/{package}/` self-contained with pin + license + bin|lib subdivision only where mixed, resolution ladder unchanged) carries all the load either way, and renaming the parent later is a mechanical find-replace precisely because everything resolves through the ladder rather than hard-coded paths.

---

# well, luckily i'm not building a pure JS monorepo which is quite self-evident

Convention memorized and indexed. Where the workflow spec now stands: decision-complete except the two `[REVIEW]`s waiting on you — the blocking-vs-advisory split for the defect-span lint detectors, and the pinned paper set once your fresh test materials land. The concrete build items it implies, in rough dependency order: the `packages/tectonic/` pin + fetch script, `tex-harness.ps1` with the expand contract and version gate, the stage-3 static expander, then rewiring `tex-render.ps1` as a harness consumer.

---

# arguably, the obvious "this is not a pure JS monorepo" is also probably evident to any other third party onlookers

Fair hit. The collision scenario required a reader who forms expectations from a directory name before noticing they're standing in a repository that's wall-to-wall PowerShell, C#, and TeX — a reader who does not exist. Anyone capable of being confused by `packages/` here would first have to survive `codex-membrane/`, at which point they've either acclimated or left.

Duly noted for calibration: name-collision caveats should be weighted by the actual audience, not by the union of all ecosystems where the word appears. `packages/` it is, unqualified.

---

# what about other packages hiding under `tools`?

Good instinct to check — `tools/` turns out to contain two different species, and two genuine hygiene findings surfaced along the way.

**The inventory.** Four of the five are *node micro-harnesses*: a first-party driver script of yours plus npm-managed externals —

| Directory | Your code | External (via npm) |
|---|---|---|
| `tools/md-lint/` | `md-lint.js`, `probe.js`, config | markdownlint |
| `tools/render-check/` | `katex-check.js` | KaTeX (the render_check gate) |
| `tools/pdf-raster/` | `render.mjs` | MuPDF (the npm package — so MuPDF is already lockfile-managed, not a naked binary; my earlier mixed-package hypothetical about `mutool.exe` was wrong in the specifics) |
| `tools/tikz-render/` | `tikz-svg.js` | tikzjax |

The fifth, `tools/tex-render/`, is nothing but `tectonic.exe` — no driver, no manifest.

**The rule that falls out** is crisp and settles the whole directory: **`tools/` = directories containing your code** (instrument harnesses whose externals are managed by a language package manager with committed lockfiles); **`packages/` = directories containing only someone else's artifact** (pin + fetch script committed, payload gitignored). By that rule the four node harnesses are correctly placed and correctly *named* — they stay. Tectonic is the lone migrant, exactly the one we already adjudicated. `tools/tex-render/` simply dissolves when it leaves (the actual `tex-render.ps1` code already lives in `src/latex-ingest/`).

**The two hygiene findings:**

1. **2,530 `node_modules` files are tracked in git** under `tools/`. The lockfiles are committed (good — that's the pin), but the restored trees are committed *too*, which is the one thing the lockfile exists to make unnecessary. The fix is the same discipline as `packages/`: gitignore `tools/*/node_modules/`, `git rm -r --cached` them, restore via `npm ci`. History keeps the bloat, but tracking stops growing and the working contract becomes manifest-in, payload-materialized.
2. **`tectonic.exe` itself is committed** — a multi-megabyte binary in history with no pin manifest, which is both the git-bloat problem and, more to the point, the trust gap: nothing committed says which tectonic that is or how to get it again. The `packages/tectonic/` migration (pin.json + fetch + gitignore + `git rm --cached` the exe) fixes both at once.

So the answer to your question: only one package was hiding under `tools/` — tectonic — but the search flushed out a real cleanup: the node harness trees need their payloads untracked, and once that's done, `tools/` vs `packages/` is a two-line convention any onlooker (even the JS-monorepo ones) parses correctly: *our harnesses* versus *their artifacts*. Want me to execute the cleanup — gitignore rules, untracking, and the `packages/tectonic/` scaffold with pin and fetch script?

---

# so the underlying package for these other 4 would be a pinned npm under packages

Exactly — and the pleasing part is that for npm-sourced packages, the `packages/` discipline doesn't need to be *built*, only *relocated*: a lockfile **is** `pin.json` and `npm ci` **is** the fetch script. The npm ecosystem natively implements your tier contract — manifest committed, payload gitignored, deterministic materialization. So the four become first-class residents with zero invented machinery:

```
packages/
  tectonic/     pin.json + fetch script        tectonic.exe (ignored)
  pdfpig/       pin.json + fetch script        lib/*.dll (ignored)
  katex/        package.json + package-lock    node_modules/ (ignored)
  mupdf/        package.json + package-lock    node_modules/ (ignored)
  markdownlint/ package.json + package-lock    node_modules/ (ignored)
  tikzjax/      package.json + package-lock    node_modules/ (ignored)
```

Each npm cell is a minimal project declaring exactly one underlying dependency — package-major, per-package pin, independently upgradeable. That last property matters for your trust doctrine: bumping KaTeX for render-check touches one lockfile and one gate, not a shared tree where four instruments' versions travel together.

The one mechanical seam is Node module resolution: `require('katex')` walks up from the *script's* location, and the drivers now live in `tools/` while the trees live in `packages/`. Cleanest fix given your architecture: all four drivers are only ever invoked *through PowerShell harnesses*, so the PS side sets `NODE_PATH` to the needed cell(s) before invoking node — one small shared helper (`Invoke-NodeTool -Package katex -Script ...`), which is precisely the resolution-ladder pattern tectonic already gets. The version gate comes along for free too: observed `require('katex/package.json').version` against the lockfile, drift fails loud, same as `Assert-PatchHits`, same as tectonic.

End state is then fully orthogonal:

- **`tools/`** — purely your code: four thin driver scripts plus their configs. Nothing restored, nothing ignored, every file tracked and readable.
- **`packages/`** — purely their artifacts: six cells, each self-contained, each reproducible from its committed manifest by its native fetcher (npm, or your script for the non-npm two).
- **`src/`** — the engines that consume both through owned resolution seams.

One pragmatic alternative to keep in your pocket: if four one-dependency npm cells ever feel like ceremony, they collapse into a single `packages/node/` project with one lockfile and one `npm ci` — you trade per-package version independence for one-command restore. I'd start package-major (it matches the rule you've already coined and the independence is real), and collapse later only if the ceremony actually bites.

Happy to execute the whole reorganization when you give the word — gitignore rules, untracking the 2,530 files plus the exe, the six cells, the `Invoke-NodeTool` helper, and rewiring the four PS invokers.

---

# well it seems to me that the items under `tools` other than tectonic are actually source code, that a project dependency is `npm`, which i have available as part of my ambient portable env, but which would need to be pinned locally as a dependency if this was a public project, and that the npm tools are structurally similar to my C# projects, except without the dotnet connotations e.g. are built or executed via their interpreter or whatever and in a different language than most of the project code (Powershell at the moment)

That taxonomy is sharper than the one I built the six-cell layout on, and it simplifies things considerably — I'll take the correction. The load-bearing recognition: **`node_modules` is a restore cache, not a vendored tier.** It's the analogue of NuGet's package cache and `obj/` intermediates, and nobody relocates those to satisfy directory purity — they gitignore them and let the toolchain own its layout. My `packages/katex/` cells plus `NODE_PATH` plumbing were fighting npm's native resolution to achieve something the lockfile already achieves in place. Under your frame the four node dirs need exactly one change: untrack the caches. Source, manifest, lockfile stay tracked where they are — they're **foreign-language source projects**, structurally identical to your C# convention (source + thin manifest tracked; restore cache and build output ignored; toolchain ambient), just interpreted instead of compiled.

That leaves each remaining piece with a cleaner identity:

**The toolchains** — node/npm, dotnet — are ambient portable-env citizens, as you say. The public-project version of pinning them has native forms (`engines` in package.json, `global.json` for dotnet) you can adopt the day it matters; the personal-project version is what you already accepted for TeX: record observed toolchain versions in the run manifest, so the trust tuple is honest even though the env is ambient.

**Tectonic reclassifies under your own taxonomy** — and this settles what it *is*. It's not a package; it's a **toolchain**: a TeX engine that carries its own package manager (it self-restores the TeX bundle into its cache — node and npm in one binary). Its natural long-term home is the portable env beside node and dotnet, registered user-level, shared with scriba-scientiae. Nothing in the spec changes, because the resolution ladder already expresses exactly this: env override = the toolchain posture, `packages/tectonic/` = the repo-local materialization rung for a machine where the ambient env doesn't have it yet, version gate = the trust discipline either way.

**PdfPig has a fork in it.** If it's consumed the C#-convention way — a thin csproj under `projects/` that declares it, `dotnet` restores it — then NuGet is its native manifest system and `packages/pdfpig/` dissolves just like the npm cells did. If it stays a loose DLL that PowerShell `Add-Type`s directly with no csproj in the loop, then it genuinely has no ecosystem manifest and `packages/pdfpig/lib/` remains right. That's decided by how `pdfdig-adapter.ps1` actually loads it today and how you want it loaded — worth settling when you touch that seam.

Which means `packages/` converges to its honest definition: **the tier for artifacts outside any ecosystem's manifest system** — population possibly just tectonic, and possibly zero once tectonic graduates to the portable env. A tier with one resident is not a failed abstraction; it's a fence around the one thing that would otherwise be a naked binary in git — which is precisely the state you're digging it out of.

One residual naming question, low stakes: with the caches untracked, `tools/` contains pure first-party source — so it could fold into `src/` per the C# convention (`src/render-check/` beside `src/latex-ingest/`), leaving the repo with no `tools/` at all; or `tools/` survives as "first-party harnesses in foreign languages." Either is coherent; the fold-in has the virtue that "where is our code" has exactly one answer.

The immediate mechanical cleanup is now smaller than my earlier offer: gitignore + untrack the 2,530 cache files and the exe, scaffold `packages/tectonic/` with pin and fetch, and leave the four node projects otherwise untouched. Say the word.

---

# i would probably move all node modules to either `packages/node/node_modules` or root-level `node_modules` or something like `node/node_modules` and then move my npm code into the appropriate location under src, having them refactored to reach for their node modules as appropriate

Consolidation plus source-into-`src/` is coherent, and of your three candidate locations I'd argue for **`packages/node/`** — it's the one that keeps the taxonomy you just built intact. With the drivers moved out to `src/`, what remains in the cell is purely *their* artifacts under an ecosystem manifest — which is exactly the `packages/` reading: `packages/node/{package.json, package-lock.json}` committed, `node_modules/` ignored, `npm ci` as the fetch. Root-level `node_modules` works mechanically (Node's upward walk finds it from anywhere with zero refactoring) but it plants a manifest at the root that declares the repo npm-flavored, and its resolution is ambient — *any* script anywhere silently resolves against it, which is the roped-in-by-convenience shape you've been systematically evicting. Bare `node/` introduces a third top-level dependency concept with no taxonomy home. One cell under `packages/`, explicit seams, root stays polyglot-neutral.

The refactor you anticipated has one technical wrinkle worth knowing before writing it: **`NODE_PATH` doesn't work for ES modules** — it's a CommonJS-era mechanism, and `render.mjs` is ESM. So the PS-invoker-sets-an-env-var approach I floated earlier is the wrong seam. The reliable pattern is in-driver, one line of preamble aimed at the cell:

```js
import { createRequire } from 'node:module';
const require = createRequire(new URL('../../packages/node/', import.meta.url));
const katex = require('katex');
```

Works uniformly from CJS and ESM drivers, resolves against the cell regardless of cwd or who invoked it, and your Node version handles `require()` of ESM-only packages (relevant for mupdf). Since every driver takes the identical two lines with only the relative hop differing, the refactor is mechanical.

Two honest notes on the consolidation trade: a single lockfile couples the four dependencies' pin churn into one file — harmless here since katex/mupdf/markdownlint/tikzjax are disjoint (no shared transitive constraints to fight), but it does mean "upgrade KaTeX" touches the same lockfile as everything else. And per-dependency version gates survive consolidation fine — `require('katex/package.json').version` against an expected value works the same whether the tree is shared or celled.

Destinations for the source, per your C# convention: `src/render-check/`, `src/md-lint/`, `src/pdf-raster/`, `src/tikz-render/` — foreign-language source projects beside the PowerShell lanes, configs traveling with them (`codex.markdownlint.json` stays with `md-lint`). `tools/` then ceases to exist, `packages/` holds exactly two things (`node/`, `tectonic/`), and every directory answers one question: `src/` = ours, `packages/` = theirs, toolchains = ambient env recorded in the run manifest.

If that matches your intent, I'll execute the full move: relocate the four projects into `src/`, add the createRequire preamble, merge the four manifests into `packages/node/`, regenerate the lockfile, rewire the PS invoker paths, gitignore + untrack the caches and the exe, scaffold `packages/tectonic/`, and true up the workflow spec and the memory file to match.

---

# well, why can't i have separate lockfile for each independent dependency, one for katex, etc

You can — nothing prevents it, and it's actually the layout most consistent with the package-major rule you already coined. My single-cell recommendation was buying "one `npm ci`" at the cost of coupling the pins, and that trade isn't necessary: a three-line restore loop recovers the convenience while keeping the independence.

```
packages/
  katex/         package.json (katex only)        + package-lock.json   node_modules/ (ignored)
  mupdf/         package.json (mupdf only)        + package-lock.json   node_modules/ (ignored)
  markdownlint/  package.json (markdownlint only) + package-lock.json   node_modules/ (ignored)
  tikzjax/       package.json (node-tikzjax only) + package-lock.json   node_modules/ (ignored)
  tectonic/      pin.json + fetch script                                tectonic.exe (ignored)
```

Each cell is one underlying dependency, one manifest, one lockfile — upgrade KaTeX and exactly one lockfile churns, exactly one gate re-verifies. The cell name is the *package*, flat under `packages/`, with the manifest type inside recording how it's sourced (npm lockfile vs pin.json) — tectonic and katex are peers in the tier, differing only in fetcher. Each driver's `createRequire` preamble aims at its specific cell (`'../../packages/katex/'`), which also makes every dependency edge *explicit and readable in the driver source* — you can grep which src tool consumes which cell, something the consolidated tree obscured. Restore is `scripts/restore-packages.ps1`: loop `npm ci` over every cell with a `package-lock.json`, run the fetch script for every cell with a `pin.json`. One command, N independent pins.

The one genuine trade to know you're making: if two cells ever need the *same* dependency, they pin it independently and can drift apart — which is the feature you're asking for when it's deliberate, and a subtle inconsistency when it's not. With your four disjoint deps it's moot today, and the restore script can trivially warn when two lockfiles pin different versions of one package if you ever want the guard. And if a future driver needs two deps at once, it either holds two `createRequire`s against two cells or earns a cell of its own with both — both coherent under the rule.

So the final shape: `src/` gains the four driver projects, `packages/` holds five independent cells, `tools/` dissolves, every pin is separate, every seam explicit. Confirm and I'll execute the whole move — relocations, preambles, per-cell manifests and lockfiles, PS invoker rewiring, gitignore + untracking (the 2,530 cache files and the exe), the tectonic scaffold, restore script, and truing up the workflow spec and memory.

---

# we're getting closer but how does this coordinate with the C# pdfpig dependency, and should the tectonic driver live under packages or somewhere else? i'm trying to imagine what the layout should be for this multi-language repo such that someone else could clone the repo and understand run a setup script to use it in theory. this means guaranteeing that system dependencies are met (dotnet sdk, npm), packages are pinned, fetchers fetch what they need to rehydrate things that are ignored, drivers get built or compiled. and what is katex? is it not a npm thing? and are there tools for handling this kind of problem that i dont know about, like `bun`?

Good forcing question — the C# coordination is exactly what settles the remaining design wobble, and it settles it *against* the per-dependency cells I just endorsed. Let me take the questions in order, because they converge on one layout.

**How C# coordinates.** NuGet's unit of pinning is the *project*: a csproj declares dependencies, `packages.lock.json` (opt-in via `RestorePackagesWithLockFile`) pins them, `dotnet restore` fetches into the global cache, build materializes into `bin/`. There is no natural "per-dependency cell" in .NET — and that asymmetry is the tell. The rule that works identically across both ecosystems is: **each foreign-language tool is a project carrying its own manifest, restored by its native toolchain.** For PdfPig, the clean form is a thin assembly-host csproj (your existing C# convention: code in `src/{tool}`, csproj in `projects/`, output → `bin/`) that references PdfPig; `dotnet publish` materializes the DLLs; PowerShell `Add-Type`s from `bin/`. NuGet is the manifest system *and* the fetcher — no `packages/pdfpig/`, no custom fetch script. And note what this gives you on the npm side: per-tool manifests (`src/render-check/package.json` pinning katex) produce **separate lockfiles anyway** — since each tool has one dependency, per-tool lockfiles ≡ the per-dependency independence you asked for, with zero `createRequire` plumbing because `node_modules` sits adjacent to the driver where Node natively finds it. The cells were solving a problem the project model dissolves.

**What katex is.** Yes — an ordinary npm library, nothing more: the JS renderer whose parser `render-check` invokes to validate math spans. It's consumed in-process by a node script, same species as mupdf and markdownlint. Nothing about it is toolchain-like or binary-shaped; it never needed a `packages/` cell, and under the project model it's just a line in `render-check`'s manifest.

**Where the tectonic driver lives.** Split by role, consistent with everything else: `tex-harness.ps1` is first-party engine code → `src/` (beside or under `latex-ingest`). The *fetcher* → `scripts/` (sibling of your `build-{tool}.ps1` family). `packages/tectonic/` holds only the pin and the ignored payload. So `packages/` converges to holding exactly the artifacts **no ecosystem manifest system covers** — current population: one. That's its honest final form.

**The clone-and-setup layout**, assembled:

```
src/                       all first-party source, any language
  latex-ingest/ …            PowerShell lanes
  render-check/              katex-check.js + package.json + lock      [npm]
  md-lint/ pdf-raster/ tikz-render/                                    [npm]
  pdfdig-host/               .cs source                                 [nuget]
projects/pdfdig-host/        thin csproj + packages.lock.json
packages/tectonic/           pin.json  (+ tectonic.exe, ignored)       [custom]
scripts/setup.ps1            the one entry point
scripts/get-tectonic.ps1
bin/                         built/published outputs (ignored)
```

`setup.ps1` is then a boring sequencer, which is the virtue: **(0) verify toolchains** — dotnet SDK, node/npm versions against declared minimums (`global.json` for dotnet, `engines` in each package.json for node; ambient from your portable env, checked-not-installed for a stranger, with clear failure messages); **(1) fetch** — loop `packages/*/pin.json` through fetchers, checksum-verified; **(2) restore** — `npm ci` in every src dir with a lockfile, `dotnet restore` over `projects/`; **(3) build** — `dotnet publish` → `bin/`; **(4) gate** — version-drift checks and a smoke test. Discovery by convention (glob for manifests) rather than a hardcoded list, so adding a tool never touches setup.

**Tools you might not know about.** The category exists:

- **mise** (ex-rtx, the modern asdf) is the one genuinely aimed at your problem: a repo-level `mise.toml` pins *toolchain* versions (node, and more) and `mise install` materializes them — it's the declarative form of your portable env, with Windows support that's recent but real. Worth a look if the "stranger clones the repo" scenario ever becomes actual rather than theoretical; until then your ambient env + a verifying setup.ps1 is the same guarantee with less machinery.
- **bun** solves a *different* problem: it's a faster node+npm replacement, JS-only. It doesn't touch polyglot coordination, and swapping runtimes buys you compatibility risk (mupdf's WASM loading, tikzjax) for speed you don't need in gate scripts. Skip.
- **devcontainers** and **Nix** are the heavyweight guarantees (environment-as-code); the first is plausible on Windows but heavy for a personal repo, the second is effectively WSL-only. Both are answers to "guarantee it runs on a machine you don't control," which isn't your current constraint.
- Windows-native: **winget configuration** files can declare system deps (dotnet SDK, node) for one-shot machine provisioning — the closest thing to a Windows-idiomatic "meet my system dependencies" manifest if you ever want setup to *install* rather than *verify*.

My recommendation: PowerShell-orchestrated setup with per-project native manifests, `packages/` for the manifest-less remainder, toolchains ambient-but-verified — and adopt mise only when a second human actually clones the repo. If this layout is the one, I'll execute it: the four npm projects move to `src/` with their own manifests and fresh lockfiles, caches and the exe get untracked, `packages/tectonic/` + fetcher + `setup.ps1` scaffolded, spec and memory trued up — the PdfPig host csproj can land as a stub now or wait until you next touch the pdfdig seam.

---

# yea but i'm more interested in the principles espoused by these management solutions than actually solving the 'other person clones repo' problem per se, which is really just me gesturing at wanting a more transparent and organized repo that doesn't require entire chat threads for me to untangle and surmise the project organization of my own work

That reframe cuts the design cleanly: you don't need a setup script that *guarantees* rehydration for a stranger — you need a repo whose structure states its own facts, so the answer to "what depends on what" is readable in thirty seconds instead of reconstructed by grep. The setup script becomes a *byproduct* of that organization (if every dependency edge is declared in a conventional place, the sequencer writes itself), not the goal.

So the principles worth stealing, stripped of their machinery:

**1. Every dependency edge is declared, never ambient.** The real cost of the current layout isn't the untracked bloat — it's that `tools/tex-render/tectonic.exe` is *discovered by a function in a script* rather than *declared anywhere*. A manifest beside the thing that needs it turns tribal knowledge into a readable fact.

**2. Provenance determines location.** Ours / theirs / ambient. One directory per answer, applied without exception — that's what makes location itself informative rather than historical.

**3. Manifest committed, payload ignored, fetcher committed.** The triple that makes any ignored directory self-explaining: you always know what should be there and how to get it back. It's the same discipline as your patch lane (curated errata + fail-loud staleness), applied to dependencies.

**4. Native manifest per ecosystem.** Don't invent pinning where npm/NuGet already pin. Only the manifest-less remainder needs your own form — which is why `packages/` ends up with one resident, and that's the correct outcome rather than a failed abstraction.

**5. Discovery by convention.** Anything that enumerates (setup, restore, CI) globs for manifests rather than hardcoding a list — so adding a tool never requires updating a registry you'll forget exists.

**6. One document states the conventions**, and it's short enough to stay true. `CONVENTIONS.md` at root — the thing whose absence is why untangling took a chat thread.

The layout from my last message satisfies all six, and its real payoff under this framing is that **the repo answers questions structurally**: *what's ours?* `src/`. *what's theirs?* `packages/` + the manifests inside src projects. *what must my machine have?* toolchain declarations + `setup.ps1`'s verify step. *what's ignored and how do I get it back?* every ignored path has a manifest and fetcher beside it. *who uses tectonic?* the harness that declares it, not five scripts that guess.

Worth naming the thing that made this hard, since it's the actual answer to "why did untangling take a thread": nothing was *wrong* in the old layout — it was that `tools/` held four different species (first-party JS, npm caches, a naked binary, and a directory named after a consumer rather than its contents), so location carried no information. Sorting by provenance is what restores it.

I think we've converged: same layout, different justification — legibility rather than reproducibility, with reproducibility falling out for free. Ready to execute whenever you are, or to write `CONVENTIONS.md` first if you'd rather have the rules on paper before the files move.

---

# but in addition, i *do* hope to publish my project some day, so two birds with one stone by adopting some standard open-source project development practices, for now and for later

Then the layout doesn't change — but two things get promoted from "nice" to "load-bearing," and one gets added.

**Promoted: the fetchers must actually work from a cold clone.** Today's `packages/tectonic/pin.json` + fetch script is legible either way, but if publication is real, the fetcher has to be *tested* from a clean state, not just written. Cheapest insurance is periodic rather than continuous: clone to a temp dir, run setup, run the gates — a `scripts/verify-clean-clone.ps1` you invoke occasionally, which later becomes the body of your CI job verbatim.

**Promoted: toolchain minimums get declared, not just verified.** `global.json` for the dotnet SDK, `engines` in each package.json for node, the pin for tectonic — because on your machine "ambient portable env" is a fact, and on anyone else's it's a question. Declaring them costs three lines and turns setup's failure messages from "it broke" into "you need node ≥ X."

**Added: the publication surface.** These are the pieces whose absence is conspicuous in a public repo and which are much cheaper to add now than to retrofit:

- **LICENSE** — the one genuinely irreversible-ish choice, since relicensing means chasing contributors. Worth deciding early even if the repo stays private for a year.
- **README** with a working quickstart (clone → setup → convert a paper), plus `CONVENTIONS.md` as the structure doc — the pair does double duty: your untangling problem today, onboarding later.
- **Third-party notices** — tectonic (MIT), PdfPig (Apache-2.0), KaTeX (MIT), MuPDF (**AGPL** — the one to look at closely: it's fine as a separate subprocess/npm dep for a permissive project, but worth knowing where the line sits before you publish), markdownlint, tikzjax. Each `packages/`-tier and npm-tier entry noting its license is a ten-minute job now, an audit later.
- **CI** as the enforcement of everything above: a workflow that does clean clone → setup → gates on Windows. It's what converts your conventions from prose into something that stays true.

The genuinely relevant open-source practice for *your* structure, though, is narrower than the general checklist: **the repo should be understandable by reading it, and every claim it makes should be executable.** That's the same principle as your residual ledger — confess what's unhandled rather than let it be invisible — applied to project organization. A README quickstart that actually runs, a setup script that actually rehydrates, a conventions doc that matches the directories: all three are testable assertions, and CI is what keeps them honest.

One thing I'd deliberately *not* do yet: contribution scaffolding (CONTRIBUTING, issue templates, code of conduct, semantic-release). Those serve inbound collaborators, which is a later problem, and they'd clutter the repo you're trying to make legible now.

Order of operations I'd suggest: do the reorganization first (it's the substrate), write `CONVENTIONS.md` from what the layout now *is* rather than from intentions, then add LICENSE/README/notices, then the clean-clone verifier, and CI last — each step making the next one cheap. Say the word and I'll start with the file moves.

---

# in my opinion, binary code vendored or built internally does not belong under `src` under any circumstances. the first-party code harnesses for drivers, like my code living under tools, get moved to their associated modules under src,  because first party harness code , distinct from custom build scripts for building drivers (which is the kind of thing i put under `projects` for dotnet internal builds. drivers under SRC just feels like very poor project development practice and i feel like i dont ever see things organized that way.

You're right, and I conflated two things when I said "move the drivers to `src/`." Let me separate them, because the distinction you're drawing is real and my phrasing blurred it.

What's under `tools/` today is genuinely two kinds of file. `katex-check.js` and `render.mjs` are **first-party harness code** — your logic, in JS, invoked by your PowerShell lanes. Those belong with the module they serve: the KaTeX render-check harness beside the lane that gates on it, the rasterizer beside the figure lane. That's what "moves under src to its associated module" means, and it's the same principle as your C# convention — the *source* lives with its subject.

What I should never have implied is that anything **built or vendored** lands there. `node_modules` is a restore cache, `bin/` holds build output, `packages/` holds vendored payloads — none of that goes near `src/`, and putting a driver's *dependency tree* adjacent to first-party source is exactly the "poor practice" instinct you're registering. Node's convention of `node_modules` next to `package.json` is what pushed me toward per-directory manifests, and I let a runtime resolution detail dictate source layout. That's backwards: layout should follow provenance, and resolution should be plumbed to fit — `createRequire` aimed at a cell, or `NODE_PATH`, or a symlink, whichever is cleanest for a given driver.

Which restores the clean three-way split you've been converging on all along:

- **`src/{module}/`** — first-party source, whatever the language. PowerShell lanes, the JS harnesses that serve them, C# engine source. Nothing restored, nothing ignored, everything readable.
- **`projects/{tool}/`** — build definitions for first-party compiled tools (the existing dotnet convention; the npm equivalent, if a driver needs a build step rather than direct interpretation, is a manifest that belongs here rather than in `src/`).
- **`packages/{package}/`** — external payloads: vendored binaries, restored dependency trees, whatever the ecosystem's fetcher materializes. Ignored, with pin + fetcher committed.
- **`bin/`** — build outputs. Ignored.

So the npm dependency trees consolidate under `packages/` (per-dependency cells, as you asked — each with its own manifest and lockfile), and the four JS harnesses move to their associated `src/` modules with an explicit resolution seam pointing at the cell they need. That also happens to be the arrangement that makes dependency edges *readable in the driver source*, which is the legibility property you're after.

One follow-on to decide when we get there: whether the npm manifests (`package.json` + lockfile) live in `packages/{dep}/` as the pin for that cell, or in `projects/` alongside the dotnet csprojs on the theory that manifests-are-build-definitions. My read is the former — an npm manifest that declares exactly one external dependency *is* the pin, and keeping it with the payload it governs matches `pin.json` beside tectonic — but the latter is coherent if you want `projects/` to be the single home for every "how this gets provisioned" file.

---

# i actually favor the latter and maybe renaming what is currently `projects` to something more transparent and accomodating of heterogenous c# and npm contents. because earlier we talked about packages being payloads, having `packages/{package}` with `lib` and or `bin` or neither under `{package}` depending on the package. the `projects` (or whatever name shakes out) is where the code is for building some of those packages. Its not apparent in this repo, but the pdgpig build in this repo is a custom signed build from my local system clone of pdfpig's source, and in a fully self-sufficient repo, i'd need to be able to recapitulate that for the project to be cold deployed

That's the missing fact, and it reshapes the tier for the better: PdfPig isn't a NuGet package in this repo at all — it's an artifact you **build from external source**, which no ecosystem manifest can express. So the second tier isn't "build definitions for our tools that happens to also hold npm manifests"; it's **recipes for how every artifact gets made**, whatever its provenance and whatever the mechanism.

That pattern has strong precedent, which is reassuring about the shape you've landed on: vcpkg is `ports/{package}/portfile.cmake` → `installed/{triplet}/{lib,bin,include}`; BSD ports, Homebrew formulas, Arch PKGBUILDs, Yocto recipes are all the same split — a **recipe tree** (committed, small, textual) and a **payload tree** (generated, ignored, structured `lib/`/`bin/`). You've independently arrived at a ports tree plus an installed tree, which is why it feels right.

On the name: `recipes/` is my pick — transparent without insider knowledge, language-neutral, covers fetch-only as naturally as build-from-source, and doesn't visually collide with `packages/` the way `packaging/` would. `ports/` is the strongest alternative if you like the vcpkg lineage; `provisioning/` if you want maximum plainness.

The rule that then makes the two tiers self-explaining:

- **`recipes/{name}/`** — how an artifact is obtained or built. Heterogeneous by design: a csproj + upstream pin for PdfPig, a `package.json` + lockfile for katex, a `pin.json` + fetch script for tectonic, a thin csproj for your own C# tools. Everything committed, everything textual, one directory per artifact.
- **Destination by provenance** — first-party source (`src/`) builds to `bin/`; external source builds or fetches to `packages/{package}/{lib,bin}` or nothing. Same recipe tier, different output tier, and the reader can tell which by asking whose source it consumes.

For PdfPig specifically, cold-deploy reproducibility needs the recipe to carry more than a build command, and this is where the requirement bites: a clone of *your* clone isn't reproducible, so the recipe needs **upstream repo + pinned commit/tag**, **your local modifications as a committed patch set** (re-applied every build, fail loud when stale — the same discipline as your latex patch lane), the **build invocation**, and the **signing step**. Signing is the one part that can't be fully self-contained in a public repo: the key is a secret, so the recipe should sign when a key is available (env var / cert store reference) and produce an unsigned build otherwise, recording which happened in the manifest. Worth knowing *why* it's signed before you formalize — if it's for assembly identity, delay-signing with a committed public key is reproducible; if it's Authenticode for local trust policy, unsigned-with-a-warning is the honest fallback for a third party.

Two things fall out that are worth the small effort: the recipe tier makes `setup.ps1` a glob over `recipes/*` rather than a hardcoded list, and it means the PdfPig provenance — currently pure tribal knowledge living on your machine — becomes a committed, readable fact. That's exactly the untangling problem you're solving, applied to the one dependency that would otherwise be unreproducible.

Want me to write `CONVENTIONS.md` capturing this three-tier layout (src / recipes / packages+bin) now, before any files move? It'd give us the rules on paper to execute against, and it's the document whose absence started this thread.

---

# what about "buildings"

Honest read: "buildings" gets preempted by the concrete-noun sense — every reader parses edifices first, and English resists pluralizing that particular gerund (we have *findings*, *writings*, but *buildings* is taken). The functional risk is worse than the aesthetic one: `buildings/` sits one letter from "build outputs," so a reader could reasonably expect artifacts there rather than beside `bin/` and `packages/`. It also implies compilation, which under-covers the tier — tectonic is fetched, katex is restored, neither is built.

But if the architecture metaphor is what appeals, there's a version that lands exactly: **`blueprints/`**. A blueprint is the committed, textual *plan*; the building is the artifact it produces. That maps precisely onto your recipe→payload split, keeps the metaphor you're reaching for, covers fetch-and-restore as naturally as compile (a blueprint can specify "source this prefabricated part"), and no one mistakes it for output. `plans/` is the plainer sibling.

So: `recipes/` (cooking metaphor, strongest precedent), `blueprints/` (architecture metaphor, does what "buildings" was reaching for), `ports/` (vcpkg lineage). Any of the three carries the load — pick the one you'll enjoy typing.

---

# yea. well with regard to the pdfpig source, what i can do is pin my custom csproj with the specs for a correct built and write a fetcher that clones the repo and injects the custom build, does the build, delivers it locally

That's the vcpkg portfile pattern exactly, and injecting *your own* csproj is better than patching theirs — a patch goes stale on every upstream bump, whereas a csproj you own has no merge surface at all. Its globs over their source tree are the staleness detector: if upstream reorganizes files, the build fails loud instead of silently compiling something different.

Recipe contents that make it cold-deployable:

```
recipes/pdfpig/
  pin.json          upstream URL + commit SHA (not a tag — tags move) + expected outputs
  PdfPig.build.csproj   your custom csproj (TFM, signing, deterministic flags)
  fetch.ps1         clone→inject→build→deliver
  NOTICE            Apache-2.0 + attribution
```

Mechanics worth building in from the start:

- **Clone to an ignored scratch location**, not into the repo — either a cache anchor like tectonic's, or `packages/pdfpig/.src/` gitignored. Shallow fetch of the exact SHA (`git init` + `fetch --depth 1 <sha>`) keeps it fast.
- **Deliver to `packages/pdfpig/lib/`**, and write a stamp file recording the SHA that produced the current payload — so re-running is a no-op when nothing changed, and drift between pin and payload is detectable rather than assumed.
- **Deterministic build flags** (`ContinuousIntegrationBuild=true`, `Deterministic=true`) so the same SHA yields byte-identical DLLs; then hash the outputs into the stamp and you have real verification, not just presence checks.
- **Signing degrades cleanly**: sign when the key is resolvable (env var / cert store), otherwise build unsigned and record which happened. The key never enters the repo, and a third party still gets a working artifact.

One question that decides whether this is fully sufficient: is the "custom" part entirely expressible in the csproj — target framework, strong-name/Authenticode signing, trimming — or does it involve edits to PdfPig's own source? If it's csproj-only, the recipe above is complete and there's no patch lane at all, which is the clean outcome. If there are source edits, they need to ride along as a committed patch set with fail-loud staleness, same discipline as your latex errata.

---

# so in this emerging in-house framework, i have `recipes` or equivalent with the build-time specs and code for c#, npm and anything else of the sort; `packages` with node_modules as well as pdfpig and tectonic/ with the tectonic executable that can be built or fetched via recipe

That's the framework, yes. Concretely:

```
recipes/{name}/     committed specs — csproj + pin (pdfpig), package.json + lock (katex,
                    mupdf, markdownlint, tikzjax), pin.json + fetch (tectonic)
packages/{name}/    materialized payloads — node_modules/, lib/*.dll, tectonic.exe — ignored
src/{module}/       first-party source, all languages, incl. the JS harnesses
bin/                first-party build outputs — ignored
```

with a **1:1 name correspondence between `recipes/` and `packages/`** — that's the legibility property that makes the whole thing readable: every ignored payload has an identically-named recipe explaining it, and `setup.ps1` is a glob over `recipes/*` with no registry to maintain.

One mechanical wrinkle for the npm cells, since you're putting manifests in `recipes/`: `npm ci` reads `package.json` from the directory it installs into, so the fetcher's first step is to copy the manifest + lockfile from `recipes/{name}/` into `packages/{name}/`, then `npm ci` there. The copies are generated and gitignored; the recipe stays the single committed source of truth. That's the same shape as the pdfpig recipe (spec in `recipes/`, materialization in `packages/`), so npm doesn't get a special case — it just has a copy step where pdfpig has a clone step.

Everything else follows: drivers in `src/` reach their cell explicitly (`createRequire` at `packages/katex/`), tectonic's recipe can fetch-a-release or build-from-source behind the same interface, and `bin/` stays reserved for artifacts built from your own `src/`.

---

# there's still a wrinkle. right now i have hdbscan first party source that gets dotnet built to an executable, i think that can goto bin as an equivalent asset as tectonic, it also routes through recipes but the source is first party

`bin/` is right, and the sharpest justification is what staleness *means* in each tier: if `bin/` is stale you rebuild your own source; if `packages/` is stale you re-provision from upstream. Two different remedies, so two different directories — and `packages/` keeps its clean "someone else's artifact" reading, which putting first-party output there would muddy.

That does require truing up the 1:1 claim I made last message. It's not recipes↔packages; it's:

> Every recipe has exactly one materialization target, and every ignored artifact directory has exactly one recipe. Recipes consuming `src/` land in `bin/`; recipes consuming upstream land in `packages/`.

So `recipes/hdbscan/` (csproj over `src/hdbscan/`) → `bin/hdbscan/`, alongside `recipes/tectonic/` → `packages/tectonic/`. Same tier, same `setup.ps1` glob, destination readable from which source the recipe names.

The asymmetry you're noticing at runtime — two executables, two roots — is real but costs nothing, because tools were never going to be resolved by hardcoded path anyway. Each harness already owns its resolution ladder (env override → PATH → repo-local rung), and the repo-local rung is just `bin/hdbscan/` for one and `packages/tectonic/` for the other. One line each, declared where the consumer lives, which is the legibility property rather than a violation of it.

---

# ok lets export this chat to codex-scientiae/issues root because i have to chop it up into distinct segments before landing each segment where they belong
