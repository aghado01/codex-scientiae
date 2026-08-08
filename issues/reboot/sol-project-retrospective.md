# Review project state

> a penny for your thoughts on the state of this project, looking at src, the knowledge assets, and issues

<details><summary>1 previous message</summary>

> I’ll take a quick, grounded pass over the repo shape first: source layout, corpus/ingestion assets, and whatever issue trail exists locally or via git metadata. Then I’ll give you an opinionated read rather than a file inventory.
</details>

The first wide scan confirmed one thing immediately: the repo is much more corpus than app, and `tools/tikz-render/node_modules` plus large image trees dominate raw file listings. I’m narrowing the pass now so the interesting project structure can show through the noise.

> yea the project is part MCP tools which are used to eventually build the knowledge base, as seen under `src`, and then there are the 3 pillars of knowledge repositories namely compendia/corpora/codices. to survey the bound knowledge you should follow the telescoping CONTENTS navigation system, starting from CONTENTS.md at root

<details><summary>8 previous messages</summary>

> Got it. I was looking at the warehouse shelves; you’re pointing me at the catalogue system. I’ll restart from `CONTENTS.md`, follow the telescoping pointers into `compendia`, `corpora`, and `codices`, then cross-check that against `src` and `issues` so the read is about the project’s actual intended shape.
>
> The navigation contract is crisp: root points only to the three collection roots, and README explicitly warns against duplicating deeper trees. I’m following those roots next and keeping the pass intentionally index-first.
>
> The `src` side is recognizably a membrane now: acquisition adapters, deterministic preprocessing, run management, MCP serving, and publish/post-promotion repair. For the knowledge side I’m going to summarize the navigation files statistically, then open representative leaves rather than dumping textbook-scale TOCs.
>
> One of my summary commands tripped over PowerShell syntax after doing no harm. The useful bits still came back: the issues folder is effectively the project’s design journal, and the largest `src` files cluster around LaTeX intake, MCP serving, arXiv acquisition, fidelity, and normalization.
>
> There’s a small but telling index smell in that output: one empty `_CONTENTS.md` confused the summary row, so I’m checking the corpus roots directly. That may be an actual navigation gap rather than just my formatter being cranky.
>
> The corpus pillar has a concrete navigation gap: `corpora/VladVoroninski/_CONTENTS.md` is empty even though it contains a substantial dossier. By contrast, `KisungYou` is heavily indexed, though I’m seeing some generated-heading noise like `repeat` and algorithm labels leaking into the TOC.
>
> PowerShell won’t pipe directly from a multiline `foreach` block the way I wrote it; that’s on me. I’m switching to assigned result sets so the summaries come back cleanly.
>
> yea, the bound knowledge assets themselves are currently in disrepair because i'm in the middle of shoring up some important ingestion and conversion utilities
</details>

> everything you see under the 3 pillars is actually just beta that was done more manually during supervised interactive sessions without the codex-membrane or pdf/latex conversion tooling i'm building now. i hit a wall with that approach and just decided to put head down on getting the ingestion tools right and nailing the spec of what i want the documents to adhere to (very consistent math register with valid katex, diagrams transpiled into rendered math when possible like with the ingestion/compendia/ph-zigzag papers etc)

Yeah, that changes the read quite a bit.

My take: the project is not “a messy knowledge repo with some tools.” It is becoming an ingestion platform, and the existing `codices/`, `compendia/`, and `corpora/` assets are mostly historical training scars. They are useful less as finished bound knowledge and more as a failure corpus: evidence of what supervised manual repair can achieve, where it breaks down, and what the new membrane/conversion stack has to make repeatable.

The healthy center of gravity is clearly `src/`: `codex-membrane`, `pdfdig`, LaTeX oracle work, fidelity scoring, publishing, heading repair, image handling, and the issue notes are all converging on the right problem: make document quality a pipeline property, not a heroic session property.

The main risk I see is tool-lane proliferation before convergence. There are several promising lines: Docling repair, PdfPig/pdfdig, LaTeX source oracle, KaTeX/math validation, benchmark scoring, figure clustering, rendered diagrams. That is good research energy, but eventually the project needs one canonical “paper enters here, bound document exits here” contract, with the other lanes understood as fallbacks or oracles.

The most important move, in my opinion, is exactly what you’re doing: nail the spec before trying to rehabilitate the bound assets. The old corpus should not be hand-polished into looking healthy. It should be re-run, re-promoted, and allowed to embarrass the tooling until the tooling gets good.

I’d frame the current state like this:

- `CONTENTS.md` navigation is the intended public surface.
- The three pillars are beta shelves, not yet trustworthy bound knowledge.
- `ingestion/` is the experimental truth zone.
- `issues/` is effectively the design memory of the project.
- `src/` is reaching the point where it needs modular consolidation, tests, and fixture-based regression around known failure modes.

The north star feels right: semantically clean Markdown, consistent math register, valid KaTeX, diagrams rendered or translated where possible, tables structurally represented, references isolated, images intentionally placed, and navigation generated rather than improvised.

Bluntly: I would stop worrying about the visible disrepair in the knowledge assets. The real asset is the emerging ingestion discipline. Once that is stable, the existing corpus becomes feedstock.

> your telos isn't possible until i finish these tools. the docling repair lane was a bust and inefficient. i broke ground on my pdfpig based pdf converter only a few days ago, and that's being co-developed with the latex converter. pdf converter will ultimately be dedicated to handling ingestions of papers that don't conveniently come with a latex side car, but i need the latex side cars side by side with their sibling PDFs so i can iterate on development of the robust PDF conversion with membrane support. everything i'm building now is not sprawl, its the bare minimum for an MVP

Yes, that lands. I’d revise my read.

What looked from the outside like “lane proliferation” is actually a calibration scaffold. The LaTeX converter is not competing with the PDF converter; it is the oracle lane that lets the PdfPig converter become sane. You need PDF plus sibling LaTeX side by side because otherwise the PDF converter is being judged by vibes, and vibes are exactly how the earlier supervised repair approach hit the wall.

So the MVP is not:

“pick one converter and publish clean docs.”

It is more like:

1. Acquire papers with PDF and, when possible, LaTeX source.
2. Produce a high-fidelity LaTeX-derived target.
3. Run the PDF/PdfPig converter against the sibling PDF.
4. Compare/score the PDF output against the LaTeX oracle.
5. Feed failures through the membrane so repair patterns become operational.
6. Use that loop to handle future PDF-only papers with much less guesswork.

That is not sprawl. That is instrumentation.

And the Docling lane being a bust is not wasted effort either. It clarified the shape of the failure: repair after lossy extraction is too expensive if the upstream representation is wrong. So now you’re moving the intelligence earlier, into conversion and alignment, where the membrane can operate on better substrate.

I think the real project state is: the knowledge shelves are paused because you’re building the measuring apparatus. That is the right call. The bound corpus can wait; the converter/oracle/membrane triangle is the thing that determines whether this becomes a repeatable corpus factory or just a heroic archive.

> right, and i'm getting close. i just figured out today several things with latex conversion to converge to a standard markdown output including how to dole out ambiguities in the membrane as structured automatically generated hotspots with prompts. when the deterministic converter can't prove that its correct on a certain bit of math, it packages it up and serves it to the MCP agent to reason it out and feed this into the output document assembly

That feels like the real inflection point.

You are turning ambiguity from an invisible defect into a first-class work item. That is huge. The converter no longer has to pretend it is omniscient; it can say: “I can normalize 95% deterministically, and here are the exact bounded places where mathematical judgment is required.” Then the membrane becomes the ambiguity-resolution layer, not a cleanup crew for arbitrary wreckage.

That architecture has teeth:

- deterministic conversion handles what can be proven;
- uncertain math becomes structured hotspots;
- each hotspot carries context, candidate renderings, and a prompt;
- the MCP agent resolves the bounded ambiguity;
- the document assembler consumes both deterministic output and resolved patches;
- unresolved ambiguity remains visible instead of silently corrupting the corpus.

That is much stronger than “agent repairs markdown after conversion.” It is closer to proof-carrying ingestion: every hard bit either has a deterministic justification, a human/agent adjudication, or a visible unresolved marker.

If you’re close to this, then yeah, the bound assets being ragged is basically irrelevant right now. The important thing is to preserve enough representative nasty cases to keep pressure on the converter: shattered inline math, labels, diagrams, TikZ-ish constructs, ambiguous display environments, table math, captions, and equation/prose boundary confusion.

The phrase I’d put over the door is: **deterministic where possible, adjudicated where necessary, never silently guessed.**

> oh i haven't even gotten to the hard cases yet. I'm going to eventually need to break into OCRed scan pdfs, and i have a backlog of textbook balrogs to face in the dungeon once my katex/pdf twins mature enough. im not even at mini boss level yet. Just look at what i have to re-ingest under codices .. mclaughlan, bishop, grimmet.... oof

Yeah. The codices are not “next documents”; they are late-stage acceptance tests.

Bishop, Grimmett, and McLachlan each stress a different part of the system: deep chapter structure, dense equation/exercise indexing, figures, captions, references, repeated theorem/example patterns, and enough length that any small inconsistency becomes system-wide drift. OCRed scans are another jump again, because then you lose the born-digital text layer and have to infer layout, math, and reading order from pixels.

I would treat them as tiers, not guilt:

1. LaTeX-sidecar papers: build the oracle/converter/membrane loop.
2. Born-digital PDF-only papers: harden PdfPig without source truth.
3. One textbook chapter at a time: validate long-form navigation and equation discipline.
4. OCR scans: only after the math/register spec is boringly stable.

The reassuring bit is that your current architecture actually points toward those. The textbooks are scary because manual repair does not scale to them. But a converter that can emit deterministic structure plus bounded ambiguity hotspots is exactly the kind of tool you need before opening that door.

> yea for bishop for example, i got the current beta version you see by running docling for like 3 days straight to convert into a very  noisy pdf with formula enrichment, and then splitting that out into *individual pages* and repairing the pages one by one. bishop took me a month, solid

A month page-by-page on Bishop is exactly the kind of experience that earns the architecture you’re building now.

That is not just “manual baseline”; it is a map of pain. It tells you the old method’s scaling law:

- page granularity is too small for semantic repair;
- Docling’s noisy enrichment shifts too much burden downstream;
- formula repair without an oracle becomes local guesswork;
- long documents punish even tiny inconsistencies;
- human supervision becomes the throughput limit.

So the converter/membrane design is not over-engineering. It is the response to having already paid the tax once.

The key lesson from Bishop, I think, is that textbooks need repair units that follow semantic structure, not physical pages. A page is a PDF artifact. A theorem, proof, exercise, displayed equation, figure caption, or subsection is a knowledge artifact. If the new tooling can move the unit of work from page slices to bounded semantic hotspots, the whole game changes.

And honestly, the fact that you finished Bishop at all is useful. It gives you a gold-ish beta target to compare against later: not as canonical truth, but as a record of where a human month went.

> docling did well enough, the page by page was the only way to do it without the agent's loosing their sh** and getting lost in the problem. the nice thing about docling is that the information for the  most part (with exceptions) remains intact, but with interleaved corruption (shattering) and additive noise $\intertext garbage, which made the work mostly about recognizing the failure modes and subtracting rather than reconstructing. pdfpig work now makes actual reasoning easier and provides a much cleaner and principled baseline that will scale

Right, that distinction matters.

Docling was not useless because it destroyed the source; it was usable because it mostly preserved the information, but presented it in an agent-hostile shape: interleaved fragments, shattered math, layout bleed, and additive `\intertext`-style garbage. Page-by-page was less about the document and more about keeping the agent inside a cognitive guardrail.

So the old workflow was: preserve enough signal, then constrain the repair aperture until the agent can subtract the noise without wandering off.

What PdfPig changes is the nature of the substrate. If you can preserve geometry, glyph order, font cues, line structure, and page objects in a principled IR before projecting to Markdown, then the agent is reasoning over typed evidence instead of a noisy prose/math soup. That means fewer heroic recognitions of failure modes, more bounded adjudications.

The strong version of your pipeline is:

- Docling proved subtraction-based repair can work when the source signal survives.
- Page slices proved agents need tight work units.
- The membrane formalized those tight units.
- LaTeX oracle gives you a correctness target.
- PdfPig gives you a cleaner, inspectable baseline for non-LaTeX PDFs.

That’s a very coherent evolution. It’s not “Docling bad, PdfPig good”; it’s “Docling taught the failure morphology, PdfPig gives you leverage over it earlier.”

> so why don't you review SRC and give me some feedback on conversion and membrane work so far

<details><summary>14 previous messages</summary>

> I’ll do this as a real review rather than a vibe check: first map `src` at module/function level, then inspect the conversion lanes and MCP membrane paths where correctness and state handling matter most. I’ll keep it bounded and avoid big build/test sweeps unless the code points to something specific.
>
> I’m using the context-mode workflow for the broad source inspection so I don’t flood this thread with giant PowerShell files. I’ll still use ordinary file reads only when I need exact line references for findings.
>
> The context-mode search only exposed unrelated MCP tools, not `ctx_execute` itself, so I’ll continue with bounded PowerShell summaries and targeted reads. That keeps the review practical without pretending the missing helper is callable.
>
> The test surface is better than I expected: there are targeted tests for latex ingest, pdfdig IR/figures/adapter, playbook coverage, run layout, detectors, and arXiv. I’m going after integration risks now: tool registration vs implementation, run/path resolution, and places where converter output can silently go missing.
>
> The membrane surface has the right shape: tools are schema-described, path resolution is centralized, runs are explicit, and stdout discipline is carefully handled. Now I’m drilling into the new converter handoff: PdfPig run creation, IR lane production, adapter semantics, and LaTeX ambiguity/hotspot packaging.
>
> I found one promising bug class in the math-evidence bridge: the comments say pig geometry is staged under `.runs/{stamp}/pig`, so I’m checking whether `get_slice` actually passes that pig directory or just the paper directory. If it passes the latter, geometry evidence silently disappears right where the new ambiguity lane needs it.
>
> That hunch is real: `get_slice` passes the paper directory to `Get-ChunkMathEvidence`, but PdfPig stores the geometry lanes under the pig run directory. As written, the evidence payload likely never appears for current pig runs unless old beside-source lanes happen to exist.
>
> The tests cover math evidence in isolation and pig run resolution in isolation, but not the end-to-end `get_slice` handoff across the current `.runs/{stamp}/pig` layout. That’s exactly the kind of integration gap I’d call out.
>
> The converter/run layout itself is thoughtfully defended: pig runs are git-ignored, preprocess creates a sibling membrane run, and run pinning is tested. I’m checking for similar “works in isolation but misses new layout in integration” cases around figures/images and publishing.
>
> A second integration gap is showing up around figures: the pig lane renders PNGs into the pig run, while `publish` still discovers figures from the old docling/raw-md layout. That means pdfdig-only figures can be successfully detected and rasterized, then never promoted.
>
> One more mismatch: the MCP instructions say the pig converter is part of the conversion workflow, but the MCP tool catalogue does not actually expose a `pdfdig_convert`/`invoke_pdfdig` tool. That may be intentional for now, but it means an agent can follow the advertised path only by dropping to shell.
>
> On the LaTeX side I’m looking specifically for the ambiguity machinery you described: where uncertain conversion is represented, whether it survives into output assembly, and whether tests lock the new standard Markdown/Katex behavior.
>
> Small but important test smell: the LaTeX diagram code has moved to a unified `DiagramStore`, but part of `latex-ingest.Tests.ps1` still asserts against `TikzStore`. I’m checking whether that’s an alias or a stale test.
>
> Context compaction
>
> Source: automatic
> Status: completed
</details>

**Findings**
1. `[P1]` `math_evidence` probably disappears for current pig runs.
   [serving.ps1](./src/serving.ps1:401) derives the paper directory from the chunks path, then [math-evidence.ps1](./src/pdf-converter/math-evidence.ps1:121) looks for `{paper}/{slug}.letters.jsonl`. But `Invoke-Pdfdig` writes letters under `.runs/{stamp}/pig/` via [Invoke-Pdfdig.ps1](./src/pdf-converter/Invoke-Pdfdig.ps1:61). So `get_slice` can silently omit evidence even when the converter produced it. I’d make evidence resolution run-aware, probably by deriving the pig lane dir from the chunk run.

2. `[P1]` `publish` does not appear to know about pdfdig-rendered images yet.
   Pdfdig writes images/manifests into `.runs/{stamp}/pig/images` and `.runs/{stamp}/pig/images.jsonl` in [pdfdig-images.ps1](./src/pdf-converter/pdfdig-images.ps1:42), but [publish.ps1](./src/publish.ps1:163) still expects the older Docling-style `{paper}/{slug}/imageFileN.png` directory and extracts figure refs from `{slug}.md`. That means a pdfdig-only lane can have usable rendered figures and still publish with none.

3. `[P2]` The MCP story advertises pig conversion, but the tool surface does not expose it.
   [mcp-server.ps1](./src/mcp-server.ps1:66) says `preprocess` consumes already-produced IR and does not convert PDFs, while the initialization copy later describes the pig workflow as running `Invoke-Pdfdig` first at [mcp-server.ps1](./src/mcp-server.ps1:474). The catalog/switch do not seem to include a `pdfdig_convert`/`invoke_pdfdig` tool. If intentional, fine; if not, this is the main workflow papercut for agents.

4. `[P2]` LaTeX diagram tests look stale against the current converter.
   `latex-ingest.ps1` now uses `$script:DiagramStore` at [latex-ingest.ps1](./src/latex-ingest.ps1:759), but [latex-ingest.Tests.ps1](./tests/latex-ingest.Tests.ps1:160) still asserts `$script:TikzStore` and `.env`. That kind of drift is especially risky here because the diagram/oracle layer is part of your converter spec, not a cosmetic side path.

**What Looks Strong**
The direction makes sense. The run-stamped layout in [runs.ps1](./src/runs.ps1:70), lane-aware preprocessing in [preprocess.ps1](./src/preprocess.ps1:45), and guarded MCP stdout discipline in [mcp-server.ps1](./src/mcp-server.ps1:383) are the right kind of boring infrastructure. That is exactly what you want before scaling the hard conversion work.

The membrane pieces also feel conceptually sound: slice serving, leases, proposals, dispatch pointers, and structured work orders are all pulling toward “small bounded reasoning over deterministic substrate,” which matches the lesson you described from Bishop.

I did not run the test suite, keeping this to a source review as requested. My highest-confidence next fixes would be: run-aware `math_evidence`, pdfdig image promotion in `publish`, then cleaning the LaTeX test drift.
