i just cloned this repo thats another attempt at pdf->markdown / latex for math. Please do a deep dive to help me understand how it works, correspondences with my pdfpig work. D:\aghado01\packages\MinerU

Saturday 12:39 AM

Worked for 18m 53s
MinerU is not really a replacement for your PdfPig/markpig work. It is closer to a learned Docling/OpenDataLoader replacement: a model-heavy semantic parser that starts from rendered pages, while markpig starts from born PDF objects and deliberately preserves provenance and uncertainty.

The best fit is a third optional intake/oracle lane, especially for scanned documents, tables, and the 2-D math that markpig intentionally flags rather than guesses.

I inspected MinerU 3.4.4 at commit 79d6d8d79fb8f3ddba5cc34c07a16f0ec36f56c7 from July 10, 2026.

How MinerU works
PDF bytes
CLI client / temporaryFastAPI service
Backend
pipelinetask-specific models
hybridlayout + VLM + native text
vlmpage-image VLM
middle.json
Document postprocessingparagraphs, formula tags,cross-page tables, captions
Markdown
content_list.json
content_list_v2.json
layout.pdf / span.pdf
Mermaid source codeflowchart LR
A["PDF bytes"] --> B["CLI client / temporary FastAPI service"]
B --> C{"Backend"}

    C --> P["pipeline<br/>task-specific models"]
    C --> H["hybrid<br/>layout + VLM + native text"]
    C --> V["vlm<br/>page-image VLM"]

    P --> M["middle.json"]
    H --> M
    V --> M

    M --> D["Document postprocessing<br/>paragraphs, formula tags,<br/>cross-page tables, captions"]
    D --> O["Markdown"]
    D --> J["content_list.json"]
    D --> J2["content_list_v2.json"]
    D --> Q["layout.pdf / span.pdf"]

1. The CLI is now an orchestration client
   The mineru executable does not simply call a parser. It collects files, plans tasks, starts a temporary local mineru-api service when no remote API is supplied, submits asynchronous jobs, then downloads the output archive. That orchestration begins in client.py (line 910). The real backend dispatch happens in common.py (line 668).

The public CLI defaults to hybrid-engine; pipeline is the CPU-compatible option.

2. The pipeline backend is a collection of specialized models
   The pipeline initializes:

PP-DocLayoutV2 for layout and reading order.
UniMERNet-small for formula recognition by default.
PP-FormulaNet as an optional formula recognizer.
Paddle-style OCR.
Separate classifiers/recognizers for wired and wireless tables.
Table orientation classification.
The model assembly is visible in model_init.py (line 231).

PP-DocLayoutV2 recognizes 25 region types, including doc_title, paragraph_title, text, display_formula, inline_formula, formula_number, image, table, chart, headers, footers, references, and vertical text; see pp_doclayoutv2.py (line 33).

The main page batch then does roughly:

Layout detection.
Formula crop recognition.
Table orientation and wired/wireless classification.
Table OCR and HTML reconstruction.
Text OCR where needed.
Seal/vertical-text handling.
Assembly of all results into page model records.
That sequence is concentrated in batch_analyze.py (line 408).

For born-text PDFs, MinerU does something especially relevant to your work: the layout model supplies text boxes, but the text itself is filled from PDFium/pdftext characters rather than re-recognized from pixels. See pipeline_magic_model.py (line 92) and span_pre_proc.py (line 43).

So even its “model pipeline” is hybrid at the span-filling level:

learned boxes + native character extraction, with OCR fallback.

3. The pure vlm backend parses page images
   The VLM branch renders pages and sends them to MinerU2.5-Pro-2605-1.2B. The model emits normalized blocks containing type, bbox, content, angle, and related fields. MagicModel converts those normalized coordinates back into page coordinates and constructs the common block/span representation in vlm_magic_model.py (line 29).

Unlike the pipeline backend, the VLM supplies the content itself. That makes it more capable on visually difficult documents but also introduces the usual model hallucination and transcription risks.

4. The default hybrid backend combines both approaches
   Hybrid is MinerU’s most interesting branch for your purposes.

At medium effort it:

Runs PP-DocLayoutV2.
Uses those detected boxes as externally supplied VLM layout.
Lets the VLM interpret complex regions.
Extracts text from native PDF characters when the PDF is text-bearing.
Adds OCR-detection and formula-recognition sidecars.
Reconciles the results geometrically.
At high effort it uses the VLM’s two-step layout/extraction path instead. The control flow is in hybrid_analyze.py (line 889). Native text is restored in hybrid_magic_model.py (line 91).

That is conceptually quite close to multi-channel consensus, except MinerU resolves the channels internally and generally emits a single answer rather than preserving disagreement as a first-class artifact.

5. Every backend converges on middle.json
   MinerU’s important internal contract is:

model inference
→ preproc_blocks
→ para_blocks + discarded_blocks
→ Markdown/content lists
middle.json keeps:

Page size and page index.
Ordered layout/preprocessing blocks.
Paragraph blocks.
Lines and spans.
Text, inline-equation and display-equation spans.
Image/table/chart structures.
Discarded page furniture.
Bboxes and some confidence scores.
Backend and MinerU version.
The schema is described in output_files.md (line 55). MinerU itself calls middle.json the secondary-development output, while Markdown and content lists are simplified consumer formats.

The final document pass performs:

Formula-number attachment.
Paragraph merging.
Cross-page table merging.
Visual-caption grouping.
Optional title-level assistance.
See model_json_to_middle_json.py (line 216).

Markdown and content lists are then rendered from the same paragraph blocks by pipeline_middle_json_mkcontent.py (line 968).

Correspondence with markpig
Your current path is:

PDF
→ PdfPig born signals
→ letters / words / blocks / paths / xobjects
→ classifier
→ membrane-compatible nodes
→ collapse / zones / sections / normalize / fidelity / repair
→ final Markdown
The orchestrator is explicit in Invoke-Pdfdig.ps1 (line 12).

Concern MinerU PdfPig/markpig
Atomic text PDFium/pdftext chars or OCR Every PdfPig Letter, with font, baseline, size, rendering mode
Layout PP-DocLayoutV2 learned regions and order indexes RecursiveXYCut plus unsupervised reading order and column claims
Headings doc_title/paragraph_title, normally mapped to levels 1/2 Typography tiers cross-derived with PDF bookmarks, supporting deeper hierarchy
Inline math Detected crop → visual formula recognition Math-font role + baseline/size geometry → $...$ seams
Display math Learned formula bbox and image-to-LaTeX recognition Math-heavy line classification plus 1.5-D recursive script assembly
Formula numbers Explicit formula_number blocks merged as \tag{...} No equivalent dedicated tag-merging stage currently
Figures Learned image/chart/table regions Vector-path/XObject HDBSCAN consensus with caption attachment
Tables Semantic recognition and HTML reconstruction, including cross-page merging Geometry exists, but no equivalent semantic table reconstruction
Scans Full OCR route Little or no usable born-text substrate
Uncertainty Scores remain in model/middle outputs, but many decisions are resolved internally Explicit health metrics and flags[]; abstention is part of the architecture
Provenance Backend and MinerU version PDF SHA-256, PdfPig version, config hash, runstamp, per-lane manifests
Finalization Direct Markdown/content-list renderer Separate membrane repair and standards-enforcement pipeline
Coordinate mismatch
Any correspondence layer must normalize:

MinerU pages are zero-based; markpig pages are one-based.
MinerU bboxes are image-style [x0,y0,x1,y1], with the origin at the top-left.
PdfPig bboxes are PDF-space [left,bottom,right,top], with the origin at the bottom-left.
content_list_v2 additionally normalizes coordinates into 0–1000.
For a page of height H, the basic MinerU-to-PdfPig conversion is:

[x0, y0, x1, y1] → [x0, H - y1, x1, H - y0]
The math comparison
This is where the two systems are most complementary.

MinerU’s formula path is:

formula layout detection
→ crop
→ UniMERNet/PP-FormulaNet/VLM recognition
→ LaTeX
→ optional equation-number \tag{}
→ $...$ or $$...$$
Its equation-number logic is unusually aligned with your standards: it strips surrounding parentheses and appends \tag{...} directly to the formula in formula_number.py (line 53).

Markpig’s path is:

born glyphs
→ font-role classification
→ baseline and size analysis
→ recursive super/subscript assembly
→ flagged residue
→ geometry transcript
→ gated repair + render check
The deterministic assembler in math-assembler.ps1 (line 56) is excellent for exact inline content and nested scripts. It intentionally cannot fully infer fractions, matrices, cases, or other 2-D structures. Those become needs_2d_assembly, with the original glyph geometry projected through math-evidence.ps1 (line 112).

That produces a clean division:

Trust markpig first for native inline math and simple display math.
Ask MinerU for a candidate on markpig’s flagged 2-D residue.
Align the candidate using page and bbox.
Accept it only after your existing render and review gates.
Preserve MinerU’s equation crop as extra visual evidence.
This improves the proposal supplied to the reasoning tier without moving a probabilistic model in front of the deterministic extractor.

Where MinerU is clearly stronger
Scanned/image-only PDFs.
Broken or missing Unicode maps.
Fractions, matrices, roots, cases, and other visual 2-D math.
Semantic table extraction.
Cross-page table continuation.
Separating tables, charts, figures, code, lists, seals, and vertical text.
Automatically choosing native-text versus OCR mode. Its classifier examines text volume, Unicode-map errors, suspicious font/script behavior, and page image coverage in pdf_classify.py (line 94).
That last point is portable as a design idea: markpig’s envelope already has many of the signals needed for an automatic “stay native or escalate to MinerU OCR” gate.

Where markpig is clearly stronger
Exact born glyph and baseline evidence.
PDF font semantics and document-origin signals.
PDF bookmarks as a heading oracle.
Vector paths and XObject geometry.
Reproducibility and source/config hashing.
Auditability: raw evidence, claims, and uncertainty are distinct lanes.
Explicit abstention rather than silent best-effort output.
Integration with the membrane repair loop and corpus-specific standards.
MinerU’s Markdown is therefore the wrong integration surface. In particular, its tables are emitted as HTML, while your corpus requires semantic Markdown pipe tables. Consuming the finished .md would also discard bboxes, scores, discarded furniture, equation crops, and model evidence.

Recommended architecture
I would add MinerU as a sibling intake/oracle lane, not put it inside pdfdig-ir.ps1.

A sensible layout would be:

{paper}/.runs/{stamp}/
├── pig/
│ ├── _.pdfdig.json
│ ├── _.letters.jsonl
│ ├── _.nodes.jsonl
│ └── _.figures.jsonl
└── mineru/
├── _\_model.json
├── _\_middle.json
├── \*\_content_list.json
└── images/
Then add an Invoke-ProjectMineru adapter parallel to pdfdig-adapter.ps1 (line 80).

Priorities I would use:

Formula-oracle bridge first. Match MinerU display equations to markpig formula chunks by page and bbox. Supply MinerU LaTeX and crop only to needs_2d_assembly/unbalanced cases.

Automatic lane selection second. Use markpig health to recognize scanned or corrupt-text pages and invoke MinerU OCR only there.

Full MinerU intake third. Project middle.json into the membrane dialect and reuse collapse, zones, sections, normalize, fidelity, repair, and finalization.

Figure/table consensus later. Let markpig provide exact region geometry and crops, while MinerU provides semantic labels and table structure. Disagreements should become flags.

For a quick adapter prototype, content_list.json is simpler and already contains page_idx and normalized bbox; see pipeline_middle_json_mkcontent.py (line 609). For a real integration, use pinned-version middle.json. Avoid content_list_v2 for now: MinerU explicitly labels it developmental.

Practical cautions
The default hybrid/VLM deployment needs roughly 8 GB VRAM; the pipeline can run on CPU but MinerU documents a roughly 20 GB local footprint.
Capture the MinerU commit, backend, effort, model identifiers/hashes, device, language, and flags in your own manifest. \_version_name alone is weaker than pig-run.json.
MinerU’s committed test surface in this clone is only one end-to-end test file, so your corpus/oracle benchmark should be the acceptance gate.
Its license is Apache 2.0 plus additional terms: online services must attribute MinerU, and very large commercial deployments cross separate-license thresholds; see LICENSE.md (line 3).
Run every imported formula through your existing renderer/linter. Visual recognition can return plausible but wrong LaTeX.
Convert HTML tables into your corpus’s Markdown-table representation before finalization.
No models were installed or downloaded, and neither repository was modified.

Saturday 12:58 AM
Yea I don't want to integrate minerU, i'm only interested in seeing how they tackle the problem. I haven't tested it yet, but given that it's a model salad, I can only imagine that it won't yield the precise math fidelity I am aiming for. The point of pdfdig is to solve the problem as much as possible deterministically, capture ambiguities and gaps, and package those into digestible pieces for LLMs to reason out the rest of it

Saturday 1:01 AM
Exactly—and my integration recommendation overshot your intent. MinerU is useful here as a comparative architecture, not as a prospective pdfdig lane.

The philosophical split is fundamental:

MinerU: render the document, let several learned models decide what the page contains, then reconcile their outputs into Markdown.
pdfdig: preserve everything the PDF actually knows, make only defensible deterministic claims, expose uncertainty explicitly, then give an LLM a small evidence-rich reconstruction problem.
That distinction matters especially for mathematics. MinerU converts precise PDF primitives into pixels and asks a recognizer to regenerate plausible LaTeX. Even when the result looks correct, it has crossed an epistemic boundary: a confidence score cannot tell you which symbol, delimiter, or index was faithfully recovered. Model errors can also compound—layout detection chooses the crop, formula detection classifies it, recognition generates LaTeX, and postprocessing normalizes the result.

Pdfdig instead retains:

Original glyphs and Unicode mappings.
Font identity and math/prose roles.
Baselines, sizes, advances, and orientations.
Vector rules and other path geometry.
Block and reading-order claims.
The exact reason a deterministic reconstruction became uncertain.
That supports the architecture you described:

PDF facts
→ deterministic reconstruction
→ explicit confidence boundary
→ compact ambiguity packet
→ bounded LLM proposal
→ mechanical/render gate
→ audited result
The most valuable MinerU lessons are consequently procedural rather than model-related:

Separate recognition from document assembly. Its model.json → middle.json → Markdown division reinforces pdfdig’s raw lanes → classified nodes → membrane separation.
Keep formula numbers separate until late. Detecting the number independently and only then producing \tag{...} is a concrete gap worth addressing deterministically in pdfdig.
Prevent channel interference. MinerU masks formula regions during OCR so text extraction does not duplicate or corrupt them. Pdfdig has an analogous need when allocating glyphs/rules among prose, formulas, tables, and figures.
Retain visual diagnostics. Its layout/span overlays are useful audit instruments, even though they are not evidence sources.
Process large documents in windows. That is an engineering improvement independent of its recognition strategy.
Route bad native-text documents explicitly. MinerU’s text-versus-OCR classifier illustrates useful health signals. Pdfdig can use similar signals to abstain and package a different problem—not silently switch to a model parser.
The deeper advantage of pdfdig is that the LLM receives a substantially better question. Instead of “transcribe this page image,” it can receive:

Best-effort LaTeX.
The precise failure flags.
Glyph sequence with font, size, baseline, and bbox.
Spatial rows and fraction bars.
Relevant image crop.
Candidate grouping boundaries.
Constraints such as delimiter balance and expected render validity.
That turns the model from a stochastic transcription engine into a bounded structural reasoner. It also makes disagreement inspectable: the model’s proposal can be traced back to supplied evidence and rejected mechanically when it invents structure.

So the useful conclusion from MinerU is almost the inverse of integration: it demonstrates how much machinery is required once raster-first learned recognition becomes the foundation. Pdfdig’s bet is that academic PDFs already contain enough latent structure to deterministically solve most of the problem—and that the unresolved remainder should be made smaller and clearer, not hidden inside another model pass.

Saturday 1:01 AM
i guess i might say pdfdig is also not trying to be a converter, but more of like a transfer from one digitial medium to another, because PDF to markdown is more of a surjection, but my bet is that there is a principled "envelope" or format adaptation that can faithfully retain the semantic content while discarding the "printing". Essentially a generic "manuscript" format in markdown. currently my approach involves building pdfpig IR, using HDBSCAN clustering (WIP), some persistent homology concepts, with a second application of HDBSCAN coming for clustering symbolic content, as well as a method TBD for leveraging typographic information, and then the agentic MCP to round it out based on my previous work on the codex-membrane. But its still kind of nebulous. parts unsupervised ML and MCP. i want to believe its worth doing but i dunno

Saturday 1:08 AM
I think it is worth doing—but the project becomes much clearer when framed as semantic transduction, not PDF conversion.

Your intuition is closer to a quotient or partial inverse than a conventional converter. Typesetting maps a manuscript into a final-form rendering while discarding or obscuring some semantics. Pdfdig is trying to recover a canonical manuscript modulo presentation:

A
(
R
(
m
)
)
≈
q
(
m
)
A(R(m))≈q(m)
where
R
R is typesetting,
q
q deliberately forgets pagination, fonts, line wrapping, float placement, and other printing choices, and
A
A is pdfdig’s adaptation process. Because
R
R is not invertible,
A
A must be allowed to return uncertainty—not fabricate a unique answer.

That last property is the real differentiator.

The semantic envelope
I would define the target as a Manuscript IR with a Markdown serialization, rather than Markdown itself as the working representation.

It should preserve:

Ordered prose and inline content.
Section hierarchy.
Mathematical notation and structure.
Figures, tables, captions, and footnotes.
Equation/figure/table numbering.
Reference and continuation relationships.
Source provenance for every recovered unit.
Unresolved alternatives and the evidence behind them.
It should discard:

Page boundaries, except as provenance.
Columns and float placement.
Headers, footers, and page numbers.
OCR/PDF hard wraps and discretionary hyphenation.
Absolute font sizes, margins, and coordinates.
Other choices whose sole purpose is printing.
The essential fidelity rule becomes:

If the source evidence does not determine a unique semantic structure, preserve the ambiguity rather than silently choosing one.

That is a meaningful form of faithfulness even where perfect inversion is impossible.

A clearer division of labor
PDF substrateglyphs, paths, fonts,metadata
Document-local discovery
Deterministic semantic claims
Manuscript IR
Unresolved hypotheses
MCP evidence packets
LLM proposals
Mechanical and rendergates
Canonical Markdown
Provenance and auditsidecars
Mermaid source codeflowchart TD
P["PDF substrate<br/>glyphs, paths, fonts, metadata"] --> D["Document-local discovery"]
D --> C["Deterministic semantic claims"]
C --> E["Manuscript IR"]

    D --> U["Unresolved hypotheses"]
    C --> U
    U --> M["MCP evidence packets"]
    M --> G["LLM proposals"]
    G --> V["Mechanical and render gates"]
    V --> E

    E --> MD["Canonical Markdown"]
    E --> A["Provenance and audit sidecars"]

The different techniques then have narrow jurisdictions:

Mechanism Proper role
Geometric HDBSCAN Discover candidate visual components and regions
Persistent-homology ideas Measure stability across scale and identify where no reliable clustering regime exists
Symbolic/typographic HDBSCAN Discover document-local font, size, baseline, and role regimes
Deterministic grammar Turn stable evidence into headings, scripts, formulas, captions, and relationships
MCP/LLM Resolve only compact, explicitly underdetermined residuals
Render/lint gates Reject syntactically or structurally invalid proposals
This prevents HDBSCAN or persistence from being asked semantic questions they cannot answer. They discover stable structure; they do not decide that something “means numerator” or “is an H2.”

For symbolic content specifically, a second HDBSCAN can discover regimes—body size, script sizes, display registers, font families, baseline bands—but I would not make it responsible for assembling the math AST. Formula assembly is ultimately a constrained graph/grammar problem. The clusters provide nodes and scale classes; geometry and mathematical layout rules provide edges.

Typography has a similarly bounded role. The promising formulation is document-local and ordinal:

Larger than the body mode.
Bold relative to the local face family.
Repeated at structurally similar positions.
Compatible with the PDF outline.
Followed by body prose.
Not math-heavy, furniture, or a caption.
Typography supplies evidence and vetoes. It need not produce an unconditional heading verdict by itself.

What is currently nebulous
The algorithms are less nebulous than the contract. You already have a coherent sequence:

Faithful PdfPig substrate.
Derived geometric and typographic claims.
Unsupervised document-local discovery.
Explicit uncertainty.
Evidence packets.
Gated model resolution.
Canonical manuscript serialization.
What is missing is a sufficiently explicit definition of:

What the manuscript format promises to preserve.
What counts as printing and may be discarded.
Which stage owns each kind of claim.
When an automated stage must abstain.
How success is measured.
Without that, every new clustering idea can feel equally relevant. With it, an algorithm must earn its place by increasing deterministic coverage or improving abstention quality.

The right success metric
Pdfdig does not need to automatically solve every page to succeed. Its key result should be a coverage–fidelity curve:

At
x
%
x% deterministic coverage, the accepted output has
y
%
y% semantic fidelity, while
z
%
z% of genuine failures are correctly surfaced for resolution.

Useful measurements would include:

Exact or render-equivalent math recovery.
Reading-order accuracy.
Heading-tree edge accuracy.
Caption/object association accuracy.
Prose character fidelity after dehyphenation.
Deterministic coverage.
False-confidence rate: wrong units emitted without flags.
Residual compression: how much of a document the LLM must inspect.
Gate rejection and eventual repair rates.
The false-confidence rate may be the defining metric. A system that is 92% correct and identifies most of the remaining 8% is more valuable for a rigorous corpus than one that looks 97% correct but cannot locate its errors.

Your LaTeX-source papers give you an unusually strong way to test the thesis:

source manuscript → PDF → pdfdig Manuscript IR
↘ canonical oracle ↗
The oracle should judge semantic equivalence, while disagreements remain symmetric investigations rather than automatic pdfdig losses.

Is the project worth it?
As a general-purpose “PDF to Markdown” competitor, probably not. Model-driven tools already occupy that market and are good enough for many users.

As an auditable, high-fidelity transfer mechanism for born-digital scientific manuscripts, there is a real unsolved problem:

Most systems optimize visual plausibility.
Few preserve born signals deeply.
Fewer expose an honest confidence boundary.
Almost none turn the residual into small, evidence-complete reasoning tasks.
That is a substantive research and engineering direction. It also has value beyond Markdown: the same Manuscript IR could support corpus ingestion, mathematical search, RAG, accessibility, proof-oriented tooling, and later reserialization into other semantic formats.

The main danger is not that the idea is pointless. It is allowing the project to become an open-ended tour of clustering techniques. The next conceptual milestone should therefore be a short MANUSCRIPT-IR specification containing:

Preservation and discard contracts.
Canonical node and relationship types.
Provenance and uncertainty representation.
Jurisdiction of every pipeline stage.
Abstention rules.
Benchmark metrics and an MVP domain boundary.
My suggested MVP boundary would be: born-digital, primarily TeX-origin academic PDFs; prose, hierarchy, inline/display math, figures and captions; tables and scans explicitly deferred or allowed to abstain.

With that boundary, pdfdig stops looking like an indefinite PDF solver. It becomes a principled manuscript recovery system whose central product is not merely Markdown—it is a traceable semantic envelope and an honest account of anything the printing process made impossible to recover deterministically.

Saturday 1:10 AM
well why dont you review the ingestion/gauntlet results so far where i have a collection pdf and latex pair-matched source, with my latex converter oracle deterministically rendering the pdf-converter's target

Saturday 1:15 AM

Worked for 1h 44m 15s
I reviewed the stable snapshot after the latest 20260718_024528 calibration run completed. My candid conclusion:

The gauntlet already validates pdfdig as a worthwhile research program, but it does not yet validate faithful PDF→manuscript transfer. It currently proves useful deterministic signal recovery—especially captioned figures—and exposes repeatable failure mechanisms. Math and headings remain substantially pre-semantic.

What is actually tested
Corpus Role Current coverage
ph-zigzag diagram calibration 10 pig + oracle pairs
voroninski figure calibration 23 pig + oracle pairs
kisungyou paired-source transport 23 pig + oracle pairs
mapper untouched transport 9 oracles, 0 pig runs
spc PDF-only stress 8 pig runs, no oracle
So there are 65 LaTeX oracle documents, but only 56 currently pair with pdfdig. There is also no corpus-wide final pdfdig Markdown to compare—the paired experiment presently ends mostly at classified IR.

One major experimental confound: ph-zigzag and voroninski use config 9cdb1eeed4a1, while kisungyou and SPC still use 99c9e1c1acea. Calibration-versus-transport numbers are therefore not from one pinned converter build.

The figure subsystem is genuinely promising
Current primary results—captioned pig regions versus LaTeX figure floats:

Corpus Exact Under Over Mean absolute error
ph-zigzag 9/10 1 0 0.40
voroninski 18/23 5 0 0.35
kisungyou 12/23 10 1 1.00
Only one of 56 papers over-counts captioned figures, and that paper has a low-confidence oracle with missing source assets. Caption cues are therefore acting as a very effective precision filter.

But the primary score hides the uncaptioned population:

Corpus Pig uncaptioned regions Oracle inline diagrams
ph-zigzag 80 78
voroninski 225 0
kisungyou 164 0
In kisungyou, 115 of the 164 uncaptioned regions have no explicit region flag; in voroninski, 197 of 225 are unflagged. caption: null still provides implicit uncertainty, but every kind=figure region is currently rendered to PNG.

The primary metric also conflates detection and caption attachment. For 1810.02906v1, the score says 13 versus 19 figures, delta −6. Yet pig found 17 total figure regions: four appear to be caption-missed floats, leaving closer to two actual region misses. Labeling the whole deficit “raster-blindness” is misleading.

The gate should therefore report separately:

visual-region recall;
float grouping;
caption-link precision/recall;
residual uncaptioned candidates;
inline-diagram fidelity.
The current comparison explicitly defines captioned count as “did we find the real figures,” which is too compressed for this distinction: Compare-FigureCounts.ps1 (line 213).

Math and headings show the real manuscript problem
I ran a conservative structural audit against the oracle Markdown. Heading matches are exact after stripping numbering, punctuation, case, and spacing. Formula groups are important because the adapter normally turns each group into a $$...$$ manuscript block.

Corpus Heading precision / recall Formula groups / oracle display blocks Unflagged formula groups
kisungyou 0.428 / 0.797 7,068 / 1,583 = 4.46× 3,790
ph-zigzag 0.405 / 0.662 2,752 / 275 = 10.01× 1,711
voroninski 0.552 / 0.775 11,634 / 2,050 = 5.68× 5,640
This is not yet the planned aligned fidelity scorer, so it should not be treated as a final grade. But the degree of oversegmentation is unambiguous: across the 56 pairs, pdfdig produces 21,454 formula groups for 3,908 oracle display blocks, and 52% of those formula groups carry no flag.

Two concrete failures explain it:

In 1810.02906v1, inline subscripts such as $A_{ij}$ receive their own PDFPig line IDs because they sit on displaced baselines. The main prose becomes effectively “For a binary network, = 1…,” while A\_{ij} is emitted separately as a display formula. See the detached inline node (line 74).

The display equation
\dot c*i(t)=\sum*{j\sim i}(c_j(t)-c_i(t))
is split among an unflagged standalone ∑, prose fragments, and a different malformed formula group. The flags correctly catch part of the damage, but not the whole broken semantic unit.

This means the critical missing layer is not chiefly symbol recognition. It is 2-D reassociation before deciding inline versus display versus prose.

Headings have an analogous premature-commitment problem. The outline matcher uses containment in both directions and does not enforce a one-to-one monotone assignment: pdfdig-classify.ps1 (line 449). Consequently, ordinary body lines containing “simulation study” are matched to the Simulation Study bookmark and promoted as headings.

A second edge case is even cleaner: all 16 detected heading lines in 2111.15058v3 are marked outline_fragment, largely because bookmarks include section numbers while printed headings do not. The adapter demotes every lone outline fragment, producing zero headings for that paper: pdfdig-adapter.ps1 (line 170).

SPC confirms that typography is a real transport boundary:

BWD1997: 2,293 heading-candidate lines from 4,726 nodes; known font-role fraction 3.58%.
PKWang2020: 407 heading-candidate lines from 1,248 nodes; known font-role fraction 5.77%.
The local nodes do carry unknown_font_role, which is good. What is missing is escalation from pervasive local uncertainty to a document-level verdict such as “semantic role labels are unusable.”

Determinism is partly demonstrated
Across 46 calibration paper/config combinations having at least two completed runs:

classified node JSONL was byte-identical in 46/46;
figure JSONL was byte-identical in only 5/46.
The latter does not necessarily prove stochastic clustering. One same-hash pair differed because a caption changed from truncated to complete—probably code evolution under an unchanged 0.2.0 version and unchanged config hash. So the stronger finding is that the build fingerprint is incomplete: it hashes configuration, not the implementation that produced the artifact.

There is also a live-run race. Run discovery treats a pig run as available as soon as its envelope exists: runs.ps1 (line 68). But the completion manifest is written only after classification, figures, and image export: Invoke-Pdfdig.ps1 (line 81). During this review, the harness briefly selected partially written runs. Additionally, pig_run currently records .runs rather than the runstamp because it climbs one parent too far.

What is not yet being measured
The intended scorer is still explicitly “not yet built”: aligned-fidelity-scoring.md (line 3). The math-bank and structural-skeleton oracle are also still design-only: math-bank-oracle-lane.md (line 3).

Consequently, the gauntlet does not yet measure:

aligned math-token or AST fidelity;
accepted-unit false-confidence rate;
heading hierarchy precision/recall officially;
prose reading order and duplication;
equation identity and cross-reference retention;
how completely flags cover actual oracle disagreements;
how much the ambiguity envelope compresses the eventual LLM workload.
The oracle target itself also needs pinning. The Markdown is written at the paper root while counts are runstamped, and the sidecar does not record source, oracle-output, or converter-build hashes. If equation identity belongs to the manuscript semantics, it also needs enrichment: the 65 oracle Markdown documents contain 4,272 display blocks but only 32 \tag{} occurrences.

My verdict
Your central idea survives this review—perhaps more strongly than before—but with a refinement:

pdfdig should not commit early to a manuscript. It should deterministically construct and rank competing manuscript hypotheses.

HDBSCAN and persistent topology are well suited to producing a hierarchy of candidate components. They should not be forced to choose the final semantic partition. The manuscript IR should preserve:

born atoms and provenance;
geometric and typographic relations;
alternative grouping hypotheses;
accepted high-confidence semantic units;
explicit unresolved competitions;
stable mappings from every manuscript unit back to PDF evidence.
The most useful next benchmark is therefore not a weighted “conversion score.” It is a small aligned Stage-0 evaluator reporting:

oracle-unit coverage;
fidelity among automatically accepted units;
false-confidence rate;
ambiguity recall—how often wrong units were flagged;
residual compression—how much evidence must reach the MCP/LLM;
deterministic canonical hash under a pinned build.
That would test your actual thesis. Right now, further tuning of figure clustering risks polishing the best subsystem while the math/manuscript boundary remains unmeasured. The paired-source gauntlet is absolutely worth keeping; it is already doing its most valuable job—falsifying premature semantic decisions in a precise, localizable way.

Saturday 2:59 AM
So I need to clarify the math AST. It is a not fully formed idea for formally embedding and standardizing the math register in markdown, and it would be a lexical/syntactic over roughly the intersection or perhaps union of latex and mathjax. pdfdig will never be a math AST, it will only help transform documents into it should it ever make it that far. But the math AST proper would be Markpig's domain and it would be a sibling AST with powershell/roselyn visitor nested/interop semantics and api abstractions just like markpig itself. Which brings me to my next question, which is the implied target "je ne sais quoi" standardized math register and the reasons why its important. my goal is to have every drop of math in line and blocks delimited and renderable with unwaivering consistency so that maths can be tokenized consistently and the register self-evident. furthermore, as a hypothetical RAG substrate, i'm imagining a dual RAG application with embedding models separately for math register and prose, somehow cross referenced / addressed, with masking over one or the other to ensure positional alignment

Saturday 10:21 PM
Yes—then I placed the AST one layer too low. pdfdig should produce grounded evidence and candidate math spans; Markpig owns the formal mathematical language, parser, syntax tree, visitors, canonicalization, and renderer projections.

The implied target is something like a canonical embedded mathematical register: a formally specified language island inside a Markdown manuscript.

The missing middle layer
There are really four distinct objects:

Layer Responsibility
pdfdig evidence Glyphs, geometry, typography, reading-order hypotheses, provenance and uncertainty
Manuscript host Markdown structure with explicit, addressable inline/block math spans
Canonical math surface A versioned, deterministic TeX-like serialization
Markpig Math AST Tokens, syntax nodes, visitors/rewriters, diagnostics, renderers and equivalence operations
The canonical surface is not itself the AST. It is the one stable textual representation of an AST—the math equivalent of a formatter’s canonical output.

A host MathSpanSyntax could reference a sibling MathSyntaxTree. A normal Markpig visitor may treat it as an opaque embedded-language node, while a nested visitor explicitly crosses into the math tree. Source maps compose across that boundary:

PDF glyphs → pdfdig span → Markdown MathSpanSyntax
→ Markpig MathSyntaxTree
→ canonical math text
That gives the PowerShell/Roslyn interop model a clean ownership boundary.

Intersection versus union
I would not define the language directly as either the intersection or union of LaTeX and MathJax.

MathJax is primarily an input-processing/rendering ecosystem, while LaTeX is a macro-programming and typesetting language. Their literal intersection is too weak; their union inherits macros, package behavior, renderer extensions, ambiguity, and substantial non-mathematical typesetting machinery.

A better construction is:

a closed canonical core grammar;
versioned extension namespaces for constructs outside the core;
importers for TeX/LaTeX, MathJax-TeX, perhaps MathML;
renderer capability profiles such as katex, mathjax, and latex;
an explicit unsupported or opaque-extension node rather than silent degradation.
Thus Markpig might accept many source dialects, but serialize one canonical dialect:

parse(source dialect) → Math AST
canonicalize(AST) → canonical math surface
lower(AST, renderer) → renderer-specific expression or diagnostic
The desired invariant is approximately:

parse(serialize(AST)) ≡ AST
—not “the same input string works accidentally in several renderers.”

What makes the register a register
Delimiters alone are necessary but insufficient. The profile needs enforceable invariants:

Every mathematical span is explicitly typed as inline or display.
No mathematical material exists outside a registered span.
No ordinary prose is swallowed into math without an explicit textual node.
Every span lexes and parses under a declared grammar version.
Canonical serialization is deterministic.
Required render profiles succeed, or the span carries a precise capability diagnostic.
Author macros are expanded, declared in a scoped environment, or retained as explicit extension nodes.
Equation labels, tags, references, and identities are metadata—not incidental visual characters.
Every canonical token maps back to source evidence.
Original surface text and uncertainty survive canonicalization.
I would distinguish at least four independent statuses:

fenced Is the register boundary known?
parsed Does the grammar accept it?
rendered Can the required renderer lower it?
grounded Is it faithfully supported by source evidence?
A perfectly fenced, parsed, and rendered equation can still be the wrong equation. That final distinction is essential for pdfdig.

The importance of the standard register is that downstream systems no longer have to rediscover modality. Tokenizers, embedders, linters, renderers, diff tools and repair agents can all rely on the same boundary and grammar. It changes “math-looking text” into an addressable language.

The dual-RAG idea
The clean abstraction is one canonical manuscript spine with two projections.

Let the ordered document be:

# D

P
0

 
M
0

 
P
1

 
M
1

 
P
2
⋯
D=P
0
​
M
0
​
P
1
​
M
1
​
P
2
​
⋯
where each $P_i$ is prose and each $M_i$ is an addressable math span.

The prose projection is:

P0 <math:m0:inline> P1 <math:m1:block> P2
The math projection is something like:

m0 → canonical tokens + AST + section/context links
m1 → canonical tokens + AST + section/context links
Both projections are generated from the same span ledger. That ledger—not token masking—is what guarantees positional alignment.

Masking alone cannot do it reliably because prose and math embedding models will tokenize differently, normalize whitespace differently, and produce unrelated vector positions. Instead, every object should carry stable external coordinates:

id: doc:1810.02906v1#math-17
host_ordinal: 231
kind: display
parent_section: doc:1810.02906v1#section-3.1
previous_span: prose-46
next_span: prose-47
label: eq:nld
source:
page: 3
glyph_ids: [...]
canonical_hash: ...
ast_hash: ...
diagnostics: [...]
Then the application has:

a prose vector space indexed by prose chunks containing math sentinels;
a math vector space indexed by canonical expressions, AST-derived features or subtrees;
one address graph connecting both to the manuscript spine.
The vector spaces should remain separate. Their raw similarity scores are not comparable; retrieval results can be joined through addresses and combined through calibrated rank fusion.

This supports several retrieval modes:

Conceptual query → retrieve prose, then expand to linked equations.
Formula query → retrieve structural math matches, then expand to explanatory prose.
Mixed query → retrieve from both and prefer results occupying the same section or neighboring spans.
Symbol query → use an exact AST/token index first, embeddings second.
Definition/use query → follow identifier and equation-reference edges through the address graph.
For example, “Why is $d_{NLD}$ a metric?” naturally decomposes into:

math retrieval for the defining expression and triangle inequality;
prose retrieval for the surrounding argument;
a join on their shared section and neighboring span IDs.
One caution: math cannot be context-free in retrieval
A mathematical embedding of $x$ is nearly worthless by itself. Even substantial expressions often depend on nearby prose for symbol definitions, hypotheses and domain declarations.

So I would use dual vector stores but a unified relational substrate. Each math record should carry:

enclosing section path;
preceding definition-like prose;
following explanatory prose;
referenced equation IDs;
identifier declarations and uses;
theorem/proof context when known.
Markpig can eventually provide multiple identities for the same expression:

canonical surface hash;
exact AST hash;
alpha-renamed structural hash;
operator/signature fingerprint;
renderer-normalized representation.
Those support progressively looser retrieval without conflating lexical and mathematical equivalence.

Why this matters beyond rendering
The real payoff is not merely unwavering $...$ and $$...$$. It is that the manuscript becomes a polyglot, projection-preserving document:

human-readable as Markdown;
formally traversable as two nested syntax languages;
consistently tokenizable;
separately embeddable by modality;
cross-addressable without relying on fragile character offsets;
auditable back to PDF evidence;
repairable without reparsing the whole document;
comparable against a LaTeX oracle at exact syntax-unit granularity.
That is the “je ne sais quoi”: not a better Markdown convention, but a language-service boundary for mathematical manuscripts.

The concise formulation may be:

Markpig manuscripts are ordered, addressable prose and mathematical language islands. The mathematical register has one canonical surface form, a sibling syntax tree, explicit renderer profiles, and composable source mappings. Prose and mathematics may be projected into independent retrieval spaces without losing their shared document coordinates.

That seems both technically coherent and much closer to what you are actually building than “PDF-to-Markdown converter.”

Saturday 10:26 PM
I dont know that spans need to be explicitly typed, part of my design is to keep the register as minimal as possible which means not alot of structural/container/metadata tagging syntax. prose-within-math is one exception i cant avoid. But I think for example inline e.g. embedded math-in-prose is self-evidently unambiguous by virtue of the $..$ delimiter formatting, save for edge cases where dollar signs mean something in the prose, as well as mathbb and other things are unavoidable because notation is essential

Saturday 10:31 PM
Yes—I think you’re right, and I conflated two different layers: the delivered manuscript register and the converter’s internal evidence model.

The manuscript itself does not need explicit type=prose, type=math, or custom span containers. Markdown and LaTeX already form a self-typing grammar:

Prose is the default register.
$...$ changes into inline math.
$$...$$ changes into display math.
\text{...} temporarily returns to prose inside math.
#, blank lines, lists, tables, and image syntax express the limited document structure that actually survives the transfer.
Literal dollar signs are a canonicalization problem, not a fundamental ambiguity: the converter can emit \$5, while reserving unescaped $ exclusively for math.

Likewise, \mathbb, \mathcal, \mathbf, accents, scripts, and operators are not disposable “printing.” They are notation-bearing typography. $\mathbb{R}$ and $R$ may denote different objects; bold may distinguish vectors; roman letters may distinguish operators, units, or differentials. The principled quotient is therefore:

Discard presentation-only typography, but retain typography that changes token identity, mathematical grammar, or referential identity.

That gives a useful dividing line:

Layer Representation
Manuscript Minimal Markdown plus semantic LaTeX; no custom typing syntax
Extraction evidence Optional, sparse, out-of-band record of unresolved boundaries and competing assemblies
The evidence layer need not contaminate the manuscript. It could be a transient JSONL ledger keyed to manuscript offsets or stable anchors, consumed by the MCP and deleted entry-by-entry as ambiguities are resolved.

This also changes how I would describe the gauntlet failures. They are not primarily failures to assign the right span type. They are failures to reconstruct the right boundaries and relations:

A\_{ij} should have been reattached at a particular position in a prose line and enclosed by $...$.
A summation glyph, limits, and baseline expression should have been assembled into one $$...$$ block.
A body sentence should not receive a # boundary merely because it contains a bookmark title.
A superscript is not a separately typed span; it has an attachment relation to a base.
So the lean internal object may be closer to a relation graph than a typed document tree:

glyph/word atoms;
candidate adjacency and ordering;
script, fraction, row, and containment relations;
boundary decisions such as join, space, paragraph break, inline-math transition, display-math transition, or heading break;
competing alternatives only where the evidence does not decide.
Most edges would be ordinary continuation edges and require no annotation. HDBSCAN and persistence then help propose stable components and alternative partitions without forcing those components to become permanent semantic containers.

The benchmark can also remain independent of explicit stored types. Parse both minimal manuscripts using the same Markdown/LaTeX grammar and compare:

boundary placement;
canonical math token sequences or parse trees;
heading sequence and depth;
prose order;
referential identities;
unmatched or duplicated material.
The most important pdfdig metric becomes false boundary confidence: when it inserted $, $$, #, or a paragraph break, how often was that decision contradicted by the oracle? And when it was wrong, did the ambiguity ledger retain enough evidence for repair?

A compact formulation of your register might therefore be:

Prose by default; math by delimiter; prose-in-math by \text; notation-bearing typography preserved; structural syntax only where the manuscript grammar requires it; uncertainty kept outside the manuscript.

That is substantially cleaner than a richly typed manuscript IR. The “envelope” is not extra markup around everything—it is the minimal manuscript plus a sparse residual evidence surface.

Saturday 10:33 PM

, so

Environment

Changes
+1,572
-15

Local

main

Commit or push

Compare branch

Sources
Web search

View all
