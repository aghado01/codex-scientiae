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
