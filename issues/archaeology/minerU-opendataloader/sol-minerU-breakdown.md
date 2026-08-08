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
