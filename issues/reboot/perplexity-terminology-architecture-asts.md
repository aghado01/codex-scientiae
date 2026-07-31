<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# im trying to work out some terminology for my document processing workflows and frameworks. one key concept is the idea of "math" vs "prose" "registers", where "math register" is really a standardized katex-compliant embedding of math symbols, notations, formulas, diagrams, etc, expressed in katex lexical tokens/control sequences/syntax. The idea is that math-register should be unambiguously legible against the background of prose and manuscript format within a document. I think of it in terms of the ability to straight-forwardly mask all "math" or all prose, including mathematical content embedded in prose and including prose like tokens that are actually math (e.g. trigonometric functions, log, ln, things like that). These registers are sort of like orthogonal channels that if i were to implement RAG over such a substrate, I would have separate embedding channels for math and prose and cross link them. The word "polyglot" has come up, but i dont know if i like that because it conjures polyglot notebooks in an IDE. What would be an idiomatic word for these registers as i'm pointing them out? I dont care for the word 'register' because its kind of close to 'registry' and easy for that to become conflated by a naive reader looking at code that also includes things like jsonl "registries" when in this case, 'register' and 'registries' are very different concepts, and "register" as a verb versus a noun are two very different things as well, and powershell code in particular is very "verby"

**Mode** and **channel** are the two strongest idiomatic replacements. Both avoid the registry/verb collisions of “register,” map cleanly onto KaTeX masking and dual-embedding RAG, and already have established technical usage that matches what you described.

## Primary recommendation: mode

TeX/LaTeX has used this for decades exactly as you mean it: *math mode* versus *text mode* (or paragraph mode). Inline math (`$...$`, `\(...\)`) and display math (`\[...\]`, environments) are simply different entry points into the same mode. KaTeX inherits the same lexical contract—control sequences, atoms, and syntax that are unambiguously tokenizable against surrounding prose.

- Masking becomes mode projection or mode isolation: strip every token whose mode is math (including “prose-looking” math atoms such as `\sin`, `\log`, `\ln`, function names treated as operators) or, conversely, mask the text-mode substrate.
- The noun is stable; the verb form (“enter mode,” “switch mode”) does not collide with JSONL registries or PowerShell verb-noun cmdlets.
- In code you can write `MathMode`, `ProseMode`, `mode_mask`, `ModeTaggedSpan` without the register/registry ambiguity.

This is the most native term for any KaTeX-centric pipeline.

## Strong alternative: channel

The dual-channel literature on source code (formal/algorithmic channel vs. natural-language channel) is an almost exact parallel: two orthogonal, cross-linked streams that share surface tokens yet remain separable for analysis and embedding. You already reached for “orthogonal channels” when describing RAG; leaning into that vocabulary is therefore low-friction.

- Math channel = the KaTeX-normalized symbolic stream (formulas, diagrams-as-math, operator atoms).
- Prose channel = the manuscript/narrative stream.
- Cross-links become explicit channel alignments or dual-channel constraints—exactly the retrieval pattern you want.
- No registry collision; “channel” is also familiar in signal-processing and multimodal embedding contexts.


## Other viable candidates

| Term | Fit | Main drawback |
| :-- | :-- | :-- |
| **Modality** | Multimodal RAG / embedding literature already treats text, tables, images as modalities; math is a natural additional modality. | Slightly heavier; can blur with sensory modalities. |
| **Stratum** | Clean, academic, no verb/registry collision; evokes layered substrates. | Less immediately legible to engineers. |
| **Lane** / **track** | Evokes parallel, maskable streams (audio lanes, multi-track). | More metaphorical; less precedent in math-document work. |
| Semiotic register (Duval) | Historically precise for math vs. natural-language representation systems. | Still contains “register.” |

“Polyglot” is best avoided for the notebook association you noted; it also implies language switching rather than orthogonal, simultaneously present streams.

## Suggested working vocabulary

- **Modes** (or **channels**) as the top-level concept.
- Concrete pair: `math-mode` / `prose-mode` (or `math-channel` / `prose-channel`).
- Operations: mode-tagging, mode-masking, mode-projection, cross-mode (or cross-channel) linking.
- Embedding view: separate mode-specific encoders whose outputs are later fused or cross-attended.
- Token-level rule: any KaTeX-legal atom or control sequence is math-mode even when it looks like English (`sin`, `log`, `max`, etc.); everything else defaults to prose-mode unless explicitly promoted.

If you want a single short noun for the abstract type, **mode** is the most idiomatic and least overloaded for a KaTeX-first document substrate. **Channel** is the better choice if the dual-embedding RAG story is the dominant architectural metaphor.
<span style="display:none">[^1_1][^1_10][^1_11][^1_12][^1_13][^1_14][^1_15][^1_16][^1_17][^1_18][^1_19][^1_2][^1_20][^1_21][^1_22][^1_23][^1_24][^1_25][^1_26][^1_27][^1_28][^1_29][^1_3][^1_30][^1_31][^1_32][^1_33][^1_34][^1_35][^1_36][^1_37][^1_38][^1_39][^1_4][^1_40][^1_41][^1_42][^1_43][^1_5][^1_6][^1_7][^1_8][^1_9]</span>

<div align="center">⁂</div>

[^1_1]: https://talk.commonmark.org/t/math-rendering-re-visited/4086

[^1_2]: https://www.unicode.org/notes/tn28/UTN28-PlainTextMath-v3.2.pdf

[^1_3]: https://www.w3.org/TR/MathML2/chapter4.html

[^1_4]: https://devblogs.microsoft.com/math-in-office/officemath/

[^1_5]: https://www.ijstr.org/final-print/mar2020/Mathematical-Symbol-Extraction-From-Document-Images-A-Comprehensive-Review.pdf

[^1_6]: https://www.cambridgemaths.org/research/key-terms-in-framework-documentation/

[^1_7]: https://www.ncbi.nlm.nih.gov/books/NBK350572/

[^1_8]: https://pubmed.ncbi.nlm.nih.gov/18315408/

[^1_9]: https://people.eecs.berkeley.edu/~fateman/papers/parsing_tex.pdf

[^1_10]: https://www.w3.org/TR/mathml4/

[^1_11]: https://direct.mit.edu/tacl/article/doi/10.1162/tacl_a_00594/117587/Introduction-to-Mathematical-Language-Processing

[^1_12]: https://aclanthology.org/2025.findings-acl.429.pdf

[^1_13]: https://andrewhead.info/assets/pdf/augmenting-scientific-papers.pdf

[^1_14]: https://pure.mpg.de/rest/items/item_68668_7/component/file_68669/content

[^1_15]: https://arxiv.org/html/2508.11828v1

[^1_16]: https://pmc.ncbi.nlm.nih.gov/articles/PMC9846624/

[^1_17]: https://www.youtube.com/watch?v=CjuYkcA35dw

[^1_18]: https://tidsskrift.dk/NOMAD/article/download/147121/190305/323120

[^1_19]: https://www.youtube.com/watch?v=jDFpEnJeSVg

[^1_20]: https://en.wikipedia.org/wiki/Register_(sociolinguistics)

[^1_21]: https://en.wikipedia.org/wiki/Document_processing

[^1_22]: https://www.scribd.com/document/378729575/Raymond-Duval-auth-Understanding-the-Mathematical-Way-of-Thinking-The-Registers-of-Semiotic-Representations-Springer-International-Publishing-20

[^1_23]: https://weaviate.io/blog/multimodal-guide

[^1_24]: https://www.nature.com/articles/s41599-024-03134-x

[^1_25]: https://pmc.ncbi.nlm.nih.gov/articles/PMC10036973/

[^1_26]: https://www.iier.org.au/iier3/chapman.html

[^1_27]: https://www.meilisearch.com/blog/multimodal-rag

[^1_28]: https://pressbooks.openedmb.ca/wordandsentencestructures/chapter/language-modality/

[^1_29]: https://dl.acm.org/doi/10.1145/3377816.3381720

[^1_30]: http://jeesusjalutasallveelaeval.blogspot.com/2012/11/semiotics-and-language.html

[^1_31]: https://tex.stackexchange.com/questions/3415/what-is-the-correct-way-of-embedding-text-into-math-mode

[^1_32]: https://ieeexplore.ieee.org/document/9397517/

[^1_33]: https://link.springer.com/book/10.1007/978-3-319-56910-9

[^1_34]: https://www.youtube.com/watch?v=1hbIroI41bg

[^1_35]: https://www1.cmc.edu/pages/faculty/aaksoy/latex/latexthree.html

[^1_36]: https://www.cs.ucdavis.edu/~devanbu/dualchannel-nier.pdf

[^1_37]: https://www.tandfonline.com/doi/full/10.1080/00313831.2024.2434820

[^1_38]: https://www.math.union.edu/~niefiels/old/sem96.html

[^1_39]: https://www.microsoft.com/en-us/research/publication/natgen-generative-pre-training-by-naturalizing-source-code/

[^1_40]: https://ccat.sas.upenn.edu/~haroldfs/messeas/regrep/node2.html

[^1_41]: https://www.overleaf.com/learn/latex/Mathematical_expressions

[^1_42]: https://www.youtube.com/watch?v=CyGue3k-858

[^1_43]: https://files.eric.ed.gov/fulltext/EJ1309765.pdf


---

# i can appreciate the semantics of "mode" in the distinctive usage of that word in scientific discourse, but "mode" also conjures different ideas like "run modes". The usage here is kind of loosely connected to the idea of statistical modes, where prose and math occupy distinct peaks in a bimodal distribution of tokens over a document. Channel feels stronger. But I still wonder if there's a more precise and distinctive term yet

**Channel** remains the strongest everyday engineering term, but several sharper options fit the bimodal + orthogonal-embedding picture more tightly—especially given a statistical-physics / geometric reading of the substrate.

## Why channel still works

The dual-channel literature already names exactly this split: a formal/symbolic channel versus a natural-language channel that share surface tokens yet remain separable and cross-constrained. Information-theoretically it is clean (independent coding, separate mutual information, cross-channel linking for RAG). It does not collide with registries or PowerShell verbs. Its only weakness is mild overload (“channel” also means I/O, Slack, marketing).

## More precise candidates

| Term | Why it fits | Distinctiveness | Risk |
| :-- | :-- | :-- | :-- |
| **Sector** | Orthogonal decomposition of a space (Hilbert / representation). Math-sector ⊥ prose-sector; masking = projection onto a sector; dual embeddings = sector-specific encoders. | High; almost unused in doc-processing | Slightly physics-flavored |
| **Component** | Mixture-model language: tokens drawn from a bimodal mixture; math and prose are the two components. Matches the “distinct peaks” intuition you just named. | High in stats/ML; low collision | Can sound like “UI component” or React |
| **Stratum** | Semiotic / glossematic layer (Hjelmslev, SFL). Math-stratum and prose-stratum as co-present layers of the same document. | Very high; academic but legible | Less immediately “maskable” sounding |
| **Plane** | Hjelmslev’s expression/content planes; also geometric “plane of representation.” Orthogonal planes of the manuscript. | Very high | Can collide with geometry “plane” in diagrams |
| **Fiber** | Base = linear document order; fiber over each locus = math or prose (or a pair). Cross-links = sections of a bundle. Extremely natural if you later want sheaf/TDA structure on the document. | Highest for your background | May feel heavy for non-geometric readers |
| **Track** / **Lane** | Parallel, independently muteable streams (audio tracks, multi-track). Masking is literal. | Medium | Slightly media-metaphorical |

## Ranking for your use-case

1. **Sector** — best single-word upgrade from channel if you want orthogonality and embedding geometry foregrounded.
    - `MathSector` / `ProseSector`
    - sector-mask, sector-projection, cross-sector link, sector-embedding
2. **Component** — best if the generative / mixture story (tokens ~ mixture of two distributions) is primary.
    - `MathComponent` / `ProseComponent`
    - component-mask, mixture weight, component-conditional embedding
3. **Stratum** — best if you want maximum distance from engineering overloaded words and a clean semiotic pedigree.
    - `MathStratum` / `ProseStratum`
4. Keep **channel** if you prefer immediate readability for collaborators who already think in dual-channel or multimodal-RAG terms.

## Suggested minimal lexicon (sector variant)

- **Sectors**: the two orthogonal representational subspaces of a document.
- **Math sector**: KaTeX-normalized symbolic stream (control sequences, operators, atoms—including “prose-looking” math such as `\sin`, `\log`).
- **Prose sector**: manuscript / narrative stream.
- **Sector tagging**: every token (or span) carries a sector label; ambiguous surface forms are disambiguated by lexical membership in the KaTeX alphabet.
- **Sector mask**: hard or soft projection that zeros one sector.
- **Cross-sector link**: explicit alignment used by dual-encoder RAG.
- **Sector embedding**: separate encoders (or separate heads) whose outputs live in sector-specific spaces and are later fused or cross-attended.

Fiber is worth holding in reserve if the architecture later grows a topological layer (document as base space, local math/prose as stalks). For the present “mask one, embed both, cross-link” design, **sector** is the most precise and distinctive noun that still reads as native technical English and avoids the collisions you listed.
<span style="display:none">[^2_1][^2_10][^2_11][^2_12][^2_13][^2_14][^2_15][^2_16][^2_17][^2_18][^2_19][^2_2][^2_20][^2_21][^2_22][^2_23][^2_24][^2_25][^2_26][^2_27][^2_28][^2_29][^2_3][^2_30][^2_31][^2_32][^2_33][^2_34][^2_35][^2_36][^2_37][^2_38][^2_39][^2_4][^2_40][^2_41][^2_42][^2_43][^2_44][^2_5][^2_6][^2_7][^2_8][^2_9]</span>

<div align="center">⁂</div>

[^2_1]: https://www.tandfonline.com/doi/full/10.1080/0952813X.2026.2633150

[^2_2]: https://victorlimfei.files.wordpress.com/2007/08/the-visual-semantics-stratum-making-meaning-in-sequential-images.pdf

[^2_3]: https://openreview.net/forum?id=e58oGe3trd

[^2_4]: https://wiki.c2.com/?DefinitionOfOrthogonal

[^2_5]: https://pmc.ncbi.nlm.nih.gov/articles/PMC5206517/

[^2_6]: https://flm-journal.org/Articles/150A7C0F2126E8199BF41808B55017.pdf

[^2_7]: https://arxiv.org/abs/2104.04991

[^2_8]: https://mathworld.wolfram.com/Orthogonal.html

[^2_9]: https://arxiv.org/html/2411.05036v1

[^2_10]: https://tiniacoleyba.com/blog/natural-language-vs-formal-language-why-they-matter-in-the-era-of-ai-and-llm-prompts/

[^2_11]: https://www.ugr.es/~jgodino/eos/onto-semiotic configurations.pdf

[^2_12]: https://pmc.ncbi.nlm.nih.gov/articles/PMC2709861/

[^2_13]: https://www.linkedin.com/pulse/math-metaphor-does-orthogonal-really-mean-what-you-michael-g-

[^2_14]: https://www.mdpi.com/2227-7390/10/24/4704

[^2_15]: https://www.youtube.com/watch?v=OQQ-W_63UgQ

[^2_16]: https://publish.iupress.indiana.edu/read/a-semiotic-theory-of-language/section/af2f45b5-b08a-441b-9e80-bf6e3dce8117

[^2_17]: https://ieeexplore.ieee.org/document/9008811/

[^2_18]: https://media-studies.com/content-and-expression/

[^2_19]: https://arxiv.org/html/2505.14827v3

[^2_20]: https://en.wikipedia.org/wiki/Stratum_(linguistics)

[^2_21]: http://hanj.cs.illinois.edu/pdf/cikm16_tsiddiqui.pdf

[^2_22]: https://www.scribd.com/document/831631593/2-Hjelmslev-s-semiotic-model-of-language-An-exegesis-Taverniers-2008-Miriam-Taverniers-Academia-edu

[^2_23]: https://mc-stan.org/docs/stan-users-guide/finite-mixtures.html

[^2_24]: https://www.cms.gov/medicare-coverage-database/view/lcd.aspx?LCDId=38841

[^2_25]: https://literariness.org/2018/03/19/key-theories-of-louis-hjelmslev/

[^2_26]: https://pmc.ncbi.nlm.nih.gov/articles/PMC7805717/

[^2_27]: https://philarchive.org/archive/WAYOAA-2

[^2_28]: https://docs.v-nova.com/technologies/mpeg-5.lcevc/carriage/overview-of-lcevc-carriages

[^2_29]: https://www.facebook.com/groups/deleuzeandguattari/posts/3098759563543981/

[^2_30]: https://arxiv.org/html/2510.06824v2

[^2_31]: http://math.stanford.edu/~ralph/fiber.pdf

[^2_32]: https://en.wikipedia.org/wiki/Hilbert_space

[^2_33]: https://www.tigergraph.com/glossary/multimodal-embeddings/

[^2_34]: https://h2o.ai/wiki/separate-token/

[^2_35]: https://www.math.fau.de/wp-content/uploads/2024/01/bundle-lect.pdf

[^2_36]: https://mathweb.ucsd.edu/~bdriver/231-02-03/Lecture_Notes/Hilbert-Spaces.pdf

[^2_37]: https://www.youtube.com/watch?v=snfpg5kGgNA

[^2_38]: https://scholarphi.org/assets/pdf/math-emnlp-2021.pdf

[^2_39]: https://math.stackexchange.com/questions/4468236/dual-vector-bundle-in-differential-geometry

[^2_40]: https://e.math.cornell.edu/people/belk/measuretheory/HilbertSpaces.pdf

[^2_41]: https://www.daft.ai/blog/multimodal-embeddings

[^2_42]: https://huggingface.co/blog/codelion/scaling-pedagogical-pretraining-10-billion-tokens

[^2_43]: https://www.mathematik.hu-berlin.de/~wendl/pub/connections_chapter2.pdf

[^2_44]: https://mathworld.wolfram.com/HilbertSpace.html


---

# well, "multimodal" rag would probably speak to embedding over rasterized image data versus text, no?

Yes. In current practice, **multimodal RAG** almost always means retrieval over *different sensory or media types*—chiefly text versus images (often full-page rasters, charts, diagrams, tables-as-pixels)—mapped into a shared embedding space, then fed to a vision-language model at generation time.[^3_1][^3_2][^3_3]

## What “multimodal” usually denotes

Typical pipeline:

- Pages or figures are kept (or rendered) as images.
- A multimodal encoder (CLIP-style, Cohere Embed v4, Jina v4, etc.) embeds those rasters *natively*, not via OCR/caption intermediaries.
- Text chunks get their own embeddings (sometimes from the same dual-encoder).
- Query embedding retrieves across both; a VLM consumes the retrieved image patches plus text.[^3_4][^3_5][^3_1]

Extensions to audio/video exist, but the dominant industrial meaning is **vision + language**, not two different *symbolic* regimes inside the same character stream.

## Why that does not fit your math/prose split

Your math sector is still discrete, tokenizable, KaTeX-lexical material—not pixels. Prose is ordinary text. Both live in the linear manuscript; the distinction is *which formal system* each span belongs to, not which sensor modality produced it. Calling that “multimodal RAG” would:

- Mislead readers who expect image encoders and page screenshots.
- Collapse the very orthogonality you care about (maskable, dual-embedding, cross-linked symbolic streams) into a coarser media split.
- Force awkward disambiguation later if you *also* add true vision (rasterized diagrams, handwriting, layout) as a third axis.

So multimodal is the right word for **text ↔ image (↔ audio…)** retrieval. It is the wrong word for **math-sector ↔ prose-sector** inside a symbolic document substrate.

## Cleaner layering

A precise stack would keep the terms distinct:


| Axis | Term | What it separates |
| :-- | :-- | :-- |
| Media / sensor type | **modality** | text vs raster image vs audio… |
| Symbolic regime inside text | **sector** (or channel) | KaTeX-math vs prose |
| Layout / structural role | block / region | paragraph, display equation, caption, table cell… |

You can then say, without collision:

- multimodal RAG over page images + extracted text
- *within* the text modality, dual-sector (or dual-channel) embeddings for math vs prose, with cross-sector links

That keeps “multimodal” in its established meaning and reserves the more geometric/orthogonal vocabulary (sector, channel, component) for the bimodal token distribution you actually want to mask and embed separately.
<span style="display:none">[^3_6][^3_7][^3_8]</span>

<div align="center">⁂</div>

[^3_1]: https://arxiv.org/html/2511.16654v2

[^3_2]: https://huggingface.co/blog/Omartificial-Intelligence-Space/building-multimodal-rag-systems

[^3_3]: https://bhavishyapandit9.substack.com/p/multimodal-retrieval-augmented-generation

[^3_4]: https://www.reddit.com/r/LocalLLaMA/comments/1q1w2tg/88_vs_76_multimodal_outperforms_text_embeddings/

[^3_5]: https://www.youtube.com/watch?v=V1VOdoEFaDw

[^3_6]: https://weaviate.io/blog/multimodal-guide

[^3_7]: https://www.meilisearch.com/blog/multimodal-rag

[^3_8]: https://cohere.com/blog/multimodal-embeddings


---

# right, and so multimodal here is really referring to modalities rather than "modes" per se. and i appreciate that distinct because parallels the same idea of different sensory modalities like auditory vs visual etc

Yes. **Modality** is the right superordinate here: distinct input kinds that are handled by different encoders or sensory pathways—vision, audition, text-as-media, and so on—exactly as in psychology and neuroscience.[^4_1]

**Mode** is a thinner, more operational word (TeX math mode, run mode, editor mode). It does not carry the “different kind of signal” force that modality does, which is why multimodal RAG reads as cross-sensory/cross-media rather than as “two modes of the same text stream.”

That gives you a clean three-level vocabulary:


| Level | Term | Role |
| :-- | :-- | :-- |
| Sensory / media kind | **modality** | text vs image vs audio… (multimodal RAG) |
| Symbolic regime inside text | **sector** (or channel) | math vs prose |
| Local typesetting state | **mode** | inline vs display, etc. (optional, TeX-local) |

So: modalities are to documents what sensory modalities are to perception; sectors are orthogonal symbolic subspaces *within* the text modality. That keeps multimodal in its established meaning and leaves sector/channel free for the KaTeX-vs-prose split you actually want to mask and dual-embed.

<div align="center">⁂</div>

[^4_1]: https://bhavishyapandit9.substack.com/p/multimodal-retrieval-augmented-generation


---

# what about concepts from communications engineering, like in the context of multiplexing

Yes — multiplexing is an excellent source of vocabulary for exactly what you are describing. In communications engineering, multiple independent signals share one physical medium and are later separated cleanly; that is almost isomorphic to math and prose sharing one document continuum.[^5_1][^5_2]

## Core mapping

| Comms concept | Document analogue |
| :-- | :-- |
| Physical medium / composite signal | The linear manuscript (token stream, PDF, markdown…) |
| Logical channel / subchannel | Math vs prose as independently addressable streams |
| Multiplexing (mux) | Interleaving both into one document |
| Demultiplexing (demux) | Masking / projecting one stream out |
| Orthogonal signaling | KaTeX-legible separation so the two do not “crosstalk” |
| Receiver / decoder per channel | Sector-specific embedder or parser |
| Cross-channel correlation | Explicit cross-links for dual-encoder RAG |

Multiplexing literally “divides the capacity of the communication channel into several logical channels”; demux extracts them again.  That is your mask-all-math / mask-all-prose operation.[^5_1]

## Most useful terms

**Subchannel**
Finer and more distinctive than bare “channel.” The document is one channel; math and prose are subchannels of it. Reads naturally in APIs: `MathSubchannel`, `ProseSubchannel`, `subchannel_mask`.

**Logical channel**
Emphasizes that the split is not physical layout but a recoverable addressing scheme—exactly KaTeX-token membership vs residual prose.

**Orthogonal subchannels** (OFDM-style)
OFDM packs subcarriers so their inner product is zero and guard bands are unnecessary.  That matches “unambiguously legible against the prose background” and “mask one without residue.” Strong if you want the geometric/orthogonal story foregrounded.[^5_3][^5_4]

**Multiplex / demultiplex** (as verbs and nouns)

- Document = multiplexed signal
- Math-demux, prose-demux
- Muxed span, demuxed embedding streams
Avoids register/registry and mode/run-mode collisions; “mux” is already idiomatic in engineering code.

**Carrier / subcarrier**
Slightly more metaphorical: prose as baseband, math as a modulated subcarrier (or vice versa). Useful if you later treat display-math vs inline-math as further subcarriers.

**Band** (as in frequency band)
`math-band` / `prose-band` — short, maskable, parallel to FDM. Less common in NLP, so low collision.

## What maps less cleanly

| Term | Issue |
| :-- | :-- |
| **TDM** (time-division) | Suggests strict alternation in time; your streams are interleaved by syntax, not by a clock. |
| **FDM** (frequency-division) | Good metaphor for orthogonality, but “frequency” has no literal token analogue. |
| **CDM / CDMA** | Code-division is powerful (each stream has its own signature) but may over-imply cryptographic or spreading-code machinery. |
| **Stream** alone | Already overloaded (PowerShell streams, byte streams, NATS, etc.). |

## Practical lexicon (comms-flavored)

- The document is a **multiplex** of two **orthogonal subchannels**: math and prose.
- **Demux** = sector mask (hard projection onto one subchannel).
- **Subchannel embedding** = independent encoder per logical channel.
- **Cross-subchannel links** = explicit alignments for retrieval (analogous to pilot symbols or joint decoding).
- Tokens that look like English but are KaTeX atoms (`sin`, `log`, `\ln`) belong to the math subchannel by **codebook / alphabet membership**, not by surface orthography—similar to how a CDMA receiver keys on the spreading code, not on the raw waveform appearance.


## Relative to earlier options

- **Channel** — still correct; multiplexing is literally about channels.
- **Subchannel** — more precise once you treat the document itself as the parent channel.
- **Sector** — better when you want Hilbert-space / projection geometry.
- **Component** — better when you want mixture-model statistics.

If the architectural story is “one medium, two cleanly separable signals, independent decode, optional joint readout,” then **subchannel** + **mux/demux** is the most idiomatic communications-engineering framing—and it stays cleanly distinct from multimodal (sensory modalities) and from TeX mode.
<span style="display:none">[^5_10][^5_11][^5_12][^5_13][^5_14][^5_15][^5_5][^5_6][^5_7][^5_8][^5_9]</span>

<div align="center">⁂</div>

[^5_1]: https://en.wikipedia.org/wiki/Multiplexing

[^5_2]: https://eureka.patsnap.com/blog/telecommunications/multiplexing-in-telecommunications/

[^5_3]: https://www.testandmeasurementtips.com/what-is-orthogonal-part-2-signal-space-faq/

[^5_4]: https://web.njit.edu/~akansu/PAPERS/AKANSU-ORTHOGONAL-MUX-1998.pdf

[^5_5]: https://www.csusm.edu/communication/major_differences.html

[^5_6]: http://ieeexplore.ieee.org/document/5560468/

[^5_7]: https://www.wecommunications.com/

[^5_8]: https://en.wikipedia.org/wiki/Communication

[^5_9]: https://patents.google.com/patent/US20030103445A1/en

[^5_10]: https://www.apu.apus.edu/area-of-study/arts-and-humanities/resources/what-is-a-communications-degree/

[^5_11]: https://www.samimgroup.com/blog/digital-multiplexing-broadcast-workflows/

[^5_12]: https://bigfuture.collegeboard.org/majors/communications

[^5_13]: https://www.geeksforgeeks.org/computer-networks/types-of-multiplexing-in-data-communications/

[^5_14]: https://probablygood.org/career-profiles/communications/

[^5_15]: https://www.youtube.com/watch?v=4afpCjYqOj4


---

# well, i would say my "streams" are interleaved in reading order, which is analogous to time

Yes — that tightens the analogy considerably. In TDM the medium is shared by **interleaving** segments of each logical channel in sequential order; the receiver demuxes by knowing which time slot belongs to which channel.  Reading order is exactly that sequential axis: the document is one composite frame stream, and math vs prose occupy alternating (or irregular) slots along it.[^6_1][^6_2]

## TDM mapping

| TDM concept | Document analogue |
| :-- | :-- |
| Time axis | Reading order (linear token/span order) |
| Physical channel / medium | The manuscript continuum |
| Time slot | A contiguous span of one sector (a math run or a prose run) |
| Frame | A larger unit (paragraph, section, page, whole doc) containing a cycle of slots |
| Logical channel / tributary | Math subchannel vs prose subchannel |
| Interleaving | How math and prose alternate in reading order |
| Mux | Authoring / serialization into one document |
| Demux | Masking / projecting by sector label |
| Framing / sync | Explicit delimiters (`$...$`, `\[...\]`, KaTeX boundaries) that let the demuxer stay locked |
| Statistical TDM | Variable-length slots (normal case: equation lengths vary; not fixed bit-width) [^6_3] |

Classic TDM often uses fixed slot widths; documents are closer to **statistical (async) TDM**, where a slot is granted for as long as that stream has content, then the other stream takes the next run.  The demux key is not “every N-th bit” but **alphabet / codebook membership** (KaTeX-legal atoms vs residual prose)—still a clean demux rule.[^6_3]

## Why this is stronger than FDM-style “band”

FDM separates by frequency while all signals are simultaneous. Your separation is sequential along reading order: at each locus the reader (or parser) is in one stream or the other, then switches. That is TDM’s core move—“all signals operate with same frequency at different times” —with “time” = reading position.[^6_4]

Orthogonality still matters, but it is **demux orthogonality** (no slot ambiguity), not simultaneous spectral orthogonality. KaTeX compliance is what keeps slots from bleeding into each other—the analogue of clean slot boundaries and framing bits.

## Lexicon that falls out naturally

- **Streams** or **subchannels** — the two logical channels (math, prose).
- **Slots** — maximal contiguous runs of one stream in reading order.
- **Interleaved multiplex** — the document as TDM composite.
- **Demux / slot projection** — mask all math slots or all prose slots.
- **Frame** (optional) — section or page as a TDM frame containing many slots.
- **Sync / framing tokens** — math delimiters and mode-switch markers.

API-shaped names stay unambiguous:

- `MathStream` / `ProseStream`
- `StreamSlot`, `slot_mask`, `demux(stream)`
- `interleaved_document`, `cross_stream_link`

“Stream” here is the TDM logical channel, not PowerShell’s success/error streams; in a document-processing codebase the compound forms (`MathStream`, `ProseStream`) keep that clear.

## Relation to the earlier options

- **Channel / subchannel** — still correct; TDM is defined in terms of them.
- **Stream** — now well-motivated, because interleaving-in-reading-order *is* the time axis.
- **Sector** — still available if you want the embedding-geometry story (orthogonal subspaces after demux).
- **Component** — still available for the mixture-model view of token generation.

A precise full stack could be:

1. **Modality** — text vs raster (multimodal RAG).
2. **Within text: TDM streams** — math vs prose, interleaved in reading order.
3. **After demux: sector embeddings** — independent encoders + cross-stream links.

So your instinct is right: once reading order is the time axis, **time-division multiplexed streams** (with statistical/variable-length slots) is a more accurate communications-engineering description than frequency bands or pure simultaneous channels.
<span style="display:none">[^6_10][^6_11][^6_12][^6_13][^6_14][^6_15][^6_5][^6_6][^6_7][^6_8][^6_9]</span>

<div align="center">⁂</div>

[^6_1]: https://www.mobius-software.com/documentation/Mobius+TAS/Time+Division+Multiplexing+%28TDM%29+

[^6_2]: https://en.wikipedia.org/wiki/Time-division_multiplexing

[^6_3]: https://www.scribd.com/document/474663917/Data-Communication-Note-10-pdf

[^6_4]: https://www.srsvidyamahapitha.org/study_mat/Sem-III_1601143841_Multiplexing-FDM-TDM.pdf

[^6_5]: https://www.sciencedirect.com/topics/engineering/time-division-multiplexing

[^6_6]: https://www.nxp.com/docs/en/application-note/AN2946.pdf

[^6_7]: https://www.youtube.com/watch?v=NnTrHiBAOP4

[^6_8]: https://darajat.ly/wp-content/uploads/2024/06/9-Time-Division-Multiplexing.pdf

[^6_9]: https://www.britannica.com/technology/time-division-multiplexing

[^6_10]: https://www.reddit.com/r/networking/comments/16x50d/time_division_multiplexing_oh_my_head/

[^6_11]: https://www.youtube.com/watch?v=qCOLTYVhNXs

[^6_12]: https://wraycastle.com/blogs/knowledge-base/multiplexing-tdm

[^6_13]: https://www.slideshare.net/slideshow/time-division-multiplexing-77643125/77643125

[^6_14]: https://iopscience.iop.org/article/10.1088/1742-6596/1529/3/032093/pdf

[^6_15]: http://www.sce.carleton.ca/faculty/lambadaris/courses/521/supplementary/tdm.pdf


---

# yea, i think the NLP analogue of what im getting at is closer to TDM than FDM, because the notion of a time-frequency or phase encoding is not really applicable

Yes. The NLP analogue is TDM, not FDM.

In FDM (and OFDM), separation lives in a simultaneous spectral domain: subcarriers, phase, frequency bins, guard bands.  Documents do not have that. There is no natural frequency or phase axis over tokens—only linear order. What you have is sequential occupancy of the same medium: at each reading position the signal belongs to one logical stream or the other, then the next span may switch. That is exactly TDM’s interleaving of time slots on one channel.[^7_1][^7_2][^7_3][^7_4]

So the accurate communications picture is:

- **Medium** = manuscript token stream
- **Time** = reading order
- **Slots** = contiguous runs (math run, prose run)
- **Logical channels** = math stream vs prose stream
- **Demux key** = KaTeX alphabet / lexical membership, not a carrier frequency
- **Variable-length / statistical TDM** = slot widths follow content, not a fixed bit clock[^7_5]

Phase/frequency encoding would only become relevant if you later imposed an artificial second axis (e.g. layout band, font channel, or a learned spectral embedding). For maskable, dual-embeddable math vs prose inside text, those are unnecessary. TDM streams (or TDM subchannels) stay the tight term; FDM-style “bands” would overclaim structure the substrate does not have.

<div align="center">⁂</div>

[^7_1]: https://www.testandmeasurementtips.com/what-is-orthogonal-part-2-signal-space-faq/

[^7_2]: https://web.njit.edu/~akansu/PAPERS/AKANSU-ORTHOGONAL-MUX-1998.pdf

[^7_3]: https://www.mobius-software.com/documentation/Mobius+TAS/Time+Division+Multiplexing+%28TDM%29+

[^7_4]: https://en.wikipedia.org/wiki/Time-division_multiplexing

[^7_5]: https://www.scribd.com/document/474663917/Data-Communication-Note-10-pdf


---

# well there is actually an implicit dimension of the latent canonical manuscript "envelope" that I'm mapping surjectively the set of possible source publications "onto" (many to one) in an "abductive" kind of process

Yes. That adds a layer *above* the TDM streams: a latent canonical object that many concrete sources collapse onto.

## The geometry

You have something like:

$$
\pi: \mathcal{S} \twoheadrightarrow \mathcal{E}
$$

- $\mathcal{S}$ — set of source publications (PDF, HTML, LaTeX, OCR’d scans, publisher variants…)
- $\mathcal{E}$ — latent **canonical manuscript envelope**
- $\pi$ — surjective (many-to-one): every source maps to some envelope point; many sources share the same image
- recovery of $\pi^{-1}$ directionally is ill-posed; you **abduce** the most plausible $e \in \mathcal{E}$ given observations $s \in \mathcal{S}$[^8_1][^8_2]

Canonicalization in the CS sense is exactly “map every equivalent representation to one distinguished form”; normalization is the weaker “map into a standard class.”  Your envelope is the stronger thing: a unique (or unique-up-to-policy) latent manuscript that sources are quotiented onto.[^8_3][^8_4]

Abduction fits because you are not deductively unpacking a known encoding; you are inferring the best explanation—the canonical manuscript—that would have given rise to the observed source under layout, typesetting, and channel noise.[^8_5][^8_1]

## Where “envelope” sits in comms terms

In signal processing the **envelope** is the slow outer contour that modulates the fast carrier—the shape you recover after stripping instantaneous oscillation. That metaphor works well here:

- Sources = different modulated realizations (fonts, columns, math renderers, OCR errors)
- Envelope = invariant manuscript shape (reading-order structure, sector-tagged content, cross-links)
- Demodulation / envelope detection ≈ abductive canonicalization

So the envelope is not another TDM stream; it is the **medium’s canonical identity** on which streams are defined.

## Full stack (refined)

| Layer | Term | Role |
| :-- | :-- | :-- |
| Sensory / media | **modality** | text vs raster vs audio (multimodal RAG) |
| Source instances | **realizations** / **emissions** | concrete publications in $\mathcal{S}$ |
| Many-to-one map | **canonicalization** $\pi$ | surjective quotient onto the latent form |
| Latent canonical object | **envelope** $\mathcal{E}$ | abductively recovered manuscript |
| Within envelope, along reading order | **TDM streams** (subchannels) | math vs prose, interleaved in time = reading order |
| After demux | **sector embeddings** | dual encoders + cross-stream links |

Fibers of $\pi$ are natural too: for each envelope point $e$, the fiber $\pi^{-1}(e)$ is the equivalence class of sources that abduce to the same canonical manuscript. That is the geometric home for “variant PDFs of the same paper.”

## Lexicon that stays precise

- **Envelope** — latent canonical manuscript (your term; keep it).
- **Canonicalization** / **envelope recovery** — the abductive surjection $\mathcal{S}\twoheadrightarrow\mathcal{E}$.
- **Realization** — a particular source sitting in some fiber.
- **Streams** — math/prose TDM logical channels *on* the envelope (not on raw sources).
- **Demux** — stream projection after you are on the envelope.
- **Cross-stream link** — alignment internal to $\mathcal{E}$.

Important ordering: demux math vs prose **on the envelope**, not on raw sources. Sources are too noisy and layout-variant; the TDM slot structure is a property of the canonical reading-order object you abduced.

## One-sentence architecture

Heterogeneous sources are abduced, via a surjective canonicalization map, onto a latent manuscript envelope; that envelope is a statistical-TDM multiplex of orthogonal math and prose streams in reading order, which you demux for dual-sector embedding and cross-link for RAG—while true multimodal RAG remains a separate modality axis (e.g. raster page images vs symbolic text).

That keeps envelope, abduction, surjection, and TDM each doing one job without colliding with modality, mode, or register.
<span style="display:none">[^8_10][^8_11][^8_12][^8_13][^8_14][^8_15][^8_6][^8_7][^8_8][^8_9]</span>

<div align="center">⁂</div>

[^8_1]: https://en.wikipedia.org/wiki/Abductive_reasoning

[^8_2]: https://www.youtube.com/watch?v=YxAd6-F9-Js

[^8_3]: https://english.stackexchange.com/questions/35860/normalization-vs-canonicalization

[^8_4]: https://stackoverflow.com/questions/55286086/is-there-a-well-defined-difference-between-normalizing-and-canonicalizing-da

[^8_5]: https://web-archive.southampton.ac.uk/cogprints.org/671/1/FAbductive.html

[^8_6]: https://arxiv.org/abs/2002.11829

[^8_7]: https://www.w3.org/TR/xml-c14n11/

[^8_8]: https://www.ibm.com/think/topics/latent-space

[^8_9]: https://naomi.com/canonical-everything-c85441a84e70

[^8_10]: https://www.reddit.com/r/MachineLearning/comments/ofivs2/d_difference_between_representation_vs_latent_vs/

[^8_11]: https://www.ibm.com/docs/en/webmethods-integration/wm-integration-server/11.1.0?topic=model-canonical-documents

[^8_12]: https://www.xml.com/pub/a/ws/2002/10/09/canonicalization.html

[^8_13]: https://www.sciencedirect.com/topics/computer-science/abductive-reasoning

[^8_14]: https://sebastianraschka.com/faq/docs/representation-embedding-latent.html

[^8_15]: https://openaccess.thecvf.com/content/WACV2021/papers/Litany_Representation_Learning_Through_Latent_Canonicalizations_WACV_2021_paper.pdf


---

# i'd probably conjure the notion of the simplex or manifolds here, where my Envelope is actually a manifold  with source documents mapping on to some configuration of a universal graph. downstream of this work i am working also on implementing an expanded Markdown AST that would implement document level envelopes such as this target manuscript concept and associated Math AST that would actually implement and parse the math "channel"'s lexicon and syntax, project codenamed MarkPig, with markpig and mathdig AST implementations. architecturally, both would be designed like powershell/roselyn with visitor semantics so markpig markdown AST can have its math visitors

Yes. That geometry and the dual-AST design lock together cleanly. Here is a coherent stack that keeps manifold language, TDM streams, and Roslyn-style visitors in one vocabulary.

## Geometric layer

Treat the latent object as a **manuscript manifold** $M$ (your Envelope), not a flat string:


| Object | Role |
| :-- | :-- |
| **Universal graph** $G$ | Discrete skeleton of all admissible manuscript structure (block types, incidence, reading-order adjacency, cross-refs) |
| **Configuration space** $\operatorname{Conf}(G)$ | Assignments of content into $G$—points on the envelope [^9_1][^9_2] |
| **Envelope** $M \subset \operatorname{Conf}(G)$ (or a manifold modeled on it) | Canonical manuscript locus; sources map surjectively onto it |
| **Simplex / simplicial structure** | Local cells of $G$: 0-simplices = atoms/spans, 1-simplices = reading-order or dominance edges, higher simplices = nested blocks, table cells, multi-line aligns, etc. [^9_3][^9_4] |
| **Abductive chart** $\pi: \mathcal{S} \twoheadrightarrow M$ | Many source publications → one configuration on $M$ |

So: sources are observations; abduction picks a point (configuration) on the envelope manifold; that point is what MarkPig materializes as a concrete AST.

“Simplex” is useful when you care about higher-order incidence (paragraph ⊃ sentence ⊃ math span ⊃ tokens). “Configuration on a universal graph” is useful when you care about the global discrete layout. Both can coexist: $G$ is the combinatorial scheme; $M$ is the geometric/canonical locus of valid filled configurations.

## Stream layer (on the envelope)

Once you are on $M$, reading order is the time axis:

- **Math stream** / **prose stream** — TDM logical channels interleaved along that axis
- **Slots** — maximal runs of one stream
- Demux = stream projection on the MarkPig tree (not on raw PDF bytes)

The MathDig tree is the parsed form of the math stream after demux (or, equivalently, the math subtrees hanging off MarkPig math nodes).

## Dual-AST architecture (MarkPig / MathDig)

Roslyn’s split is the right precedent: immutable syntax trees + visitor/walker/rewriter separation.[^9_5][^9_6][^9_7]

```
Source realizations  --abduce π-->  Envelope point m ∈ M
                                        │
                                        ▼
                              MarkPig AST  (document envelope)
                                 │    │
                    prose nodes  │    │  math-valued nodes (opaque or handle)
                                 │    │
                                 │    └──parse / attach──►  MathDig AST
                                 │                              │
                                 ▼                              ▼
                         MarkPig visitors              MathDig visitors
                         (incl. math visitors          (lexicon, KaTeX
                          that open MathDig)            syntax, rewrites)
```


### MarkPig (document envelope AST)

- Expanded Markdown AST: document-level envelope = one concrete chart of $M$.
- Owns reading-order spine, block structure, prose, and **math slots** as first-class nodes (inline/display), not raw strings only.
- Math nodes may hold: source lexeme, link to MathDig root, sector tag, cross-stream anchors.
- Existing mdast-style math nodes are the shallow precursor; you are making them envelope-native and visitor-first.[^9_8][^9_9][^9_10]


### MathDig (math-stream AST)

- Implements the math channel’s lexicon and syntax (KaTeX-compliant tokens, control sequences, atoms, fractions, scripts, …).
- Produced by parsing the contents of MarkPig math nodes (or by a joint parse that fills both).
- Sector-pure: after demux, a MathDig forest *is* the math stream.


### Visitor semantics (PowerShell / Roslyn-shaped)

| Piece | MarkPig | MathDig |
| :-- | :-- | :-- |
| Tree | `MarkPigSyntaxNode` | `MathDigSyntaxNode` |
| Walk | `MarkPigSyntaxWalker` | `MathDigSyntaxWalker` |
| Visit | `MarkPigSyntaxVisitor<T>` | `MathDigSyntaxVisitor<T>` |
| Rewrite | `MarkPigSyntaxRewriter` | `MathDigSyntaxRewriter` |

**Math visitors on MarkPig** are the hinge:

- `VisitInlineMath` / `VisitDisplayMath` open or accept a MathDig subtree.
- Default walker: recurse prose children in MarkPig; for math nodes, either skip, demux-only, or dispatch into a `MathDigSyntaxWalker`.
- Same pattern as Roslyn walkers that only override the node kinds they care about.[^9_11][^9_5]

That gives you stream operations as visitors:

- **Prose demux** — walker that emits/keeps non-math nodes, elides or redacts math slots
- **Math demux** — walker that collects math nodes and runs MathDig visitors on them
- **Cross-stream link** — visitor that writes anchors between prose identifiers and MathDig symbols
- **Sector embedding** — separate walkers producing dual encoder inputs


## Naming that stays consistent

| Concept | Suggested term |
| :-- | :-- |
| Latent canonical locus | **Envelope** $M$ (manuscript manifold) |
| Discrete scheme | **Universal graph** $G$ (or manuscript scheme) |
| Point of $M$ | **Configuration** / envelope instance |
| MarkPig root | **Envelope AST** / `MarkPigDocument` |
| Math channel tree | **MathDig AST** / math-stream syntax tree |
| Math vs prose | **Streams** (TDM subchannels on the envelope) |
| Contiguous run | **Slot** |
| Many-to-one recovery | **Abductive canonicalization** $\pi$ |
| Tree traversal API | **Visitor / Walker / Rewriter** (Roslyn parity) |
| MarkPig → MathDig handoff | **Math visitor** (or math dispatcher) |

Project codenames fit naturally:

- **MarkPig** — envelope manifold made concrete as an extensible Markdown AST
- **MathDig** — digester/parser of the math stream’s lexicon into its own AST
- Together: envelope multiplex + demuxable math channel, both visitor-addressable


## Architectural one-liner

Sources abduce onto configurations of a universal manuscript graph (points on the envelope manifold $M$); MarkPig is the envelope AST for those configurations; along reading order it is a TDM multiplex of prose and math streams; MathDig is the AST of the math stream; both trees expose Roslyn-style visitors so MarkPig math visitors can project into MathDig—and dual-sector RAG runs on demuxed streams, not on raw source bytes.

That keeps simplex/manifold language for the latent geometry, TDM for interleaving, and PowerShell/Roslyn visitor semantics for the implementation surface—without collapsing back into “mode,” “register,” or multimodal-as-pixels.
<span style="display:none">[^9_12][^9_13][^9_14][^9_15]</span>

<div align="center">⁂</div>

[^9_1]: https://scholar.rose-hulman.edu/cgi/viewcontent.cgi?article=1430\&context=rhumj

[^9_2]: https://en.wikipedia.org/wiki/Configuration_space_(mathematics)

[^9_3]: https://pmc.ncbi.nlm.nih.gov/articles/PMC10742477/

[^9_4]: https://patricknicolas.substack.com/p/exploring-simplicial-complexes-for

[^9_5]: https://learn.microsoft.com/en-us/dotnet/csharp/roslyn-sdk/get-started/syntax-analysis

[^9_6]: https://studfile.net/preview/17177362/page:57/

[^9_7]: https://blog.wiseowls.co.nz/index.php/2020/05/12/walking-code-with-roslyn/

[^9_8]: https://github.com/syntax-tree/mdast

[^9_9]: https://www.npmjs.com/package/mdast-util-math

[^9_10]: https://markdownast.juliadocs.org/stable/elements/

[^9_11]: https://www.youtube.com/watch?v=z3n_PChuWHA

[^9_12]: https://inria.hal.science/hal-00707901/document

[^9_13]: https://www.math.univ-toulouse.fr/~rcampos/Papers/ConfigBoundary.pdf

[^9_14]: https://cims.nyu.edu/gcl/papers/IMR10-DeFloHuiPanCan.pdf

[^9_15]: https://www.youtube.com/watch?v=VQbgJNSgrXg


---

# and, perhaps counterintuitively, a specific instance of the manuscript envelope turns out to be a traversal of a DAG, flattened out into reading order, and semantically sub-addressable (within document) via a combination of sequential node positions and node kinds

Yes — that is only counterintuitive if you assume “document = tree.” Once cross-references, shared footnotes, multi-cited equations, and repeated structural roles are allowed, the honest combinatorial object is a **DAG**; a concrete envelope instance is one **reading-order linearization** (a topological traversal) of that DAG.[^10_1][^10_2]

## Envelope instance as linearized DAG

| Layer | Object | Role |
| :-- | :-- | :-- |
| Combinatorial scheme | **DAG** $D$ | Nodes = semantic units; edges = dominance, sequence, and reference (acyclic) |
| Envelope instance | **Traversal** $\tau$ of $D$ | A topological order compatible with reading constraints |
| Surface manuscript | **Flattening** of $\tau$ | The linear token/slot sequence (TDM time axis) |
| Address space | **(position, kind)** | Sub-document semantic coordinates |

So:

$$
\text{source} \xrightarrow{\text{abduce}} D \xrightarrow{\tau\ \text{(topo/reading order)}} \text{flat spine} \supset \text{math/prose slots}
$$

The manifold/envelope $M$ is the space of admissible filled configurations; a **point** of $M$ is realized as a particular DAG plus a chosen linearization $\tau$. MarkPig is that realization as an AST-shaped view of the traversal (tree-shaped *encoding* of a DAG, with non-tree edges reified as reference/link nodes or back-edges recorded out of band).

## Why DAG, not tree

Trees cannot share a node with two parents without duplication. Manuscripts routinely need:

- one equation node cited from many prose sites
- one footnote target referenced twice
- shared section headers / anchors
- forward/backward cross-refs that are structural, not just stringly links

Those are DAG edges. Acyclicity is the manuscript invariant (no cyclic “contains” or “must-precede” constraints). Reading order is then exactly a **topological linearization** of $D$.  Layout-aware reading-order work is the same idea under another name: induce an acyclic order relation, then flatten.[^10_3][^10_4][^10_2][^10_1]

## Sub-addressability: position × kind

Within-document addresses are a product key, not a single path string:


| Coordinate | Meaning |
| :-- | :-- |
| **Sequential position** | Index (or span) along the linearized traversal $\tau$ — the TDM time coordinate |
| **Node kind** | MarkPig / MathDig syntax kind (`Paragraph`, `InlineMath`, `DisplayMath`, `Heading`, …) |

Together:
$\text{addr} = (\text{pos}, \text{kind})$
or, richer, $(\text{pos}, \text{kind}, \text{stream})$ with $\text{stream} \in \{\text{math}, \text{prose}\}$.

That matches how unist/mdast already carry positional ranges *and* typed nodes: geometry of the source plus semantic kind.  You are lifting “source offset” to **envelope sequential position** after abduction—stable under source realization noise, defined on the canonical spine.[^10_5][^10_6]

Practical forms:

- **Ordinal address** — `pos = 47` on the flat spine (nth node in $\tau$)
- **Span address** — `[pos_start, pos_end)`
- **Kind-filtered address** — “3rd `DisplayMath`” ≡ kind-scoped ordinal (sequential among nodes of that kind)
- **Composite** — `(kind-ordinal, kind)` or `(global-pos, kind)` for disambiguation

Visitors then become addressable queries: walk $\tau$, match kind, emit positions—Roslyn/PowerShell style, but the walk order *is* the envelope’s reading-order linearization.[^10_7]

## How this locks to the rest of the stack

```
Universal graph G  (scheme)
        │
        ▼
DAG D  (instance structure: incidence + refs)
        │  topological / reading-order traversal τ
        ▼
Flat spine  (envelope linearization = TDM time axis)
        │
        ├─ prose slots ──► MarkPig prose nodes
        └─ math slots  ──► MarkPig math nodes ──► MathDig AST
```

- **TDM streams** — coloring of nodes (or slots) along $\tau$; demux = kind/stream filter on the walk.
- **MarkPig** — AST view of $\tau$ (children = tree projection; DAG extras = ref edges / shared ids).
- **MathDig** — expansion of math-kind nodes’ payloads.
- **Math visitors on MarkPig** — when kind ∈ math, dispatch into MathDig; position on spine is the cross-stream anchor.
- **Sub-address** — `(position_in_τ, kind)` is the stable within-envelope pointer for RAG chunks, cross-links, and dual-sector embeddings.


## Naming (tight)

| Concept | Term |
| :-- | :-- |
| Structural instance | **Manuscript DAG** |
| Reading-order flattening | **Traversal** / **linearization** $\tau$ |
| Linear axis | **Spine** (envelope reading order) |
| Within-doc pointer | **Spine address** $(\mathrm{pos}, \mathrm{kind})$ |
| Kind-scoped pointer | **Kind ordinal** (e.g. `DisplayMath#3`) |
| Non-tree edge | **Ref edge** / **cross-link** (still in the DAG, visible from the spine) |

## One-line refinement

A manuscript envelope instance is a DAG of typed nodes; its concrete form is a reading-order topological traversal flattened to a spine; math and prose are TDM streams along that spine; and every semantic locus is sub-addressable by sequential spine position plus node kind—exactly what MarkPig visitors walk and what MathDig hangs off at math-kind addresses.

That is a standard move (DAG → topo order → addressable sequence); the novelty is treating that spine as the canonical envelope and hanging dual-AST, dual-sector RAG off `(pos, kind)` rather than off raw source offsets.
<span style="display:none">[^10_10][^10_11][^10_12][^10_13][^10_14][^10_15][^10_16][^10_8][^10_9]</span>

<div align="center">⁂</div>

[^10_1]: https://arxiv.org/html/2409.19672v1

[^10_2]: https://en.wikipedia.org/wiki/Directed_acyclic_graph

[^10_3]: https://stackoverflow.com/questions/25982748/linearizing-a-dag-with-multiple-sources

[^10_4]: https://www.lettria.com/lettria-lab/reconstructing-logical-reading-order-a-deep-dive-into-advanced-parsing-techniques-with-lettrias-docparsing-api

[^10_5]: https://github.com/syntax-tree/unist-util-position

[^10_6]: https://unifiedjs.com/learn/guide/syntax-trees-typescript/

[^10_7]: https://learn.microsoft.com/en-us/dotnet/csharp/roslyn-sdk/get-started/syntax-analysis

[^10_8]: https://docs.python.org/3/library/ast.html

[^10_9]: https://support.microsoft.com/en-us/word/create-a-cross-reference

[^10_10]: https://www.reddit.com/r/ProgrammingLanguages/comments/13rnxrk/ast_design_patterns/

[^10_11]: https://support.litera.com/article/DocXtools-Cross-Referencing-Documents-493820

[^10_12]: https://zenn.dev/phinesze/scraps/c597bdf71540b7

[^10_13]: https://stackoverflow.com/questions/56323675/how-to-get-the-full-path-to-a-node-using-the-ast-abstract-syntax-trees-modul

[^10_14]: https://www.facebook.com/groups/indesignsecrets/posts/3620177598216710/

[^10_15]: https://www.actiprosoftware.com/docs/controls/wpf/syntaxeditor/text-parsing/parsing/ast-nodes

[^10_16]: https://helpdesk-docs.iso.org/article/617-in-document-cross-references


---

# the sub-addressing concept really does seem counter-intuitive, when i try to explain how the AST not only gives me a tree but also simultaneously affords a semantic address space by virtue of traversing the graph and assembling in reading order.

The counter-intuition comes from treating “AST” as only a containment hierarchy. It is also, for free, a **total order** once you fix a traversal. Those are two coordinates on the same object—not two different structures.

## The dual affordance

Any rooted tree (or DAG with a chosen linearization) induces **two** geometries at once:


| View | What it is | Address looks like |
| :-- | :-- | :-- |
| **Hierarchical** | Parent/child incidence | Path: `/doc/sec[^11_2]/para[^11_1]/math[^11_0]` |
| **Sequential** | Nodes in traversal order | Spine index: `pos = 47`, or kind-scoped `DisplayMath#3` |

You do not build a second data structure for the second column. **Document order is the walk.** The DOM already works this way: one tree, plus “document order” as the order a depth-first walk emits nodes.  Hierarchical distance (edges up to LCA) and sequential distance (how many terminals between two leaves in reading order) are different metrics on the same graph.[^11_1][^11_2][^11_3]

So the pitch is not “the AST is a tree *and also somehow* an address space.” It is:

> The envelope is a typed DAG. A reading-order traversal is a total order on its nodes. Every node therefore has a hierarchical locus *and* a sequential locus. Sub-addressing is just naming nodes by that sequential locus plus kind.

## Why it feels backwards

People map:

- tree → hierarchy only
- array/list → positions only

and assume you must pick one. Manuscripts need both:

- hierarchy — nesting, scope, block structure (MarkPig shape)
- sequence — reading order, TDM slots, “the 3rd display equation,” chunk windows for RAG

Flattening does not destroy the tree; it **exposes** the order the tree already determined (for a fixed visit policy: e.g. preorder, or block-major reading order). The AST is the generative object; the spine is a **view**.

```
DAG / tree  ──traversal τ──►  spine ⟨n₀, n₁, n₂, …⟩
    │                              │
    │ hierarchical edges           │ sequential indices
    ▼                              ▼
 path addresses              (pos, kind) addresses
```

Same nodes. Two projection maps.

## Analogies that land

**1. DOM / browser**
“The DOM is a tree, but `querySelectorAll` and accessibility trees also depend on document order.” Nobody finds it strange that the same nodes are both nested and ordered.[^11_1]

**2. Book**
Chapters contain sections contain paragraphs (tree). Page numbers and “paragraph 4 of chapter 2” (sequence + kind) address the same text. The TOC is hierarchy; the page stream is traversal.

**3. Source map / compiler**
Roslyn and friends: syntax tree *and* full-span positions in the file. Position is not a rival representation; it is coordinates of nodes under the parse order.[^11_4]

**4. Hierarchical sequence**
Cognitive/structural work literally defines sequences and hierarchies as special rooted DAGs; branching adds a hierarchical axis, and any chosen enumeration of terminals adds a sequential axis.[^11_3]

## One paragraph you can reuse

> MarkPig is not “a tree instead of a list.” It is a typed manuscript DAG whose reading-order traversal defines a spine. Hierarchy gives containment and scope; the traversal gives every node a stable sequential position. Sub-addresses are pairs `(position on that spine, node kind)`—so “the third display-math node” or “spine offset 47” are not extra indexes we maintain by hand; they are names for nodes under the same walk that visitors already perform. MathDig hangs off math-kind nodes at those addresses; demux is a kind-filter on the walk; dual-sector RAG chunks by spine spans.

## What to emphasize when it still feels hand-wavy

1. **Address space ≠ storage layout** — You store a graph; you *name* nodes by walk order + kind.
2. **Traversal is normative** — Reading order is part of the envelope contract, not an accident of serialization.
3. **Kind is the semantic filter** — Position alone is bare sequence; position×kind is *semantic* sub-addressing (only math, only headings, …).
4. **DAG linearization** — Shared targets (one equation, many cites) live once in the DAG; the spine may mention them once as definitions and elsewhere as ref edges—addresses still point at the canonical node.

## Optional term to reduce friction

Call the sequential view the **spine** or **document order**, and the pair $(\mathrm{pos}, \mathrm{kind})$ a **spine address**. Say explicitly:

- **Path address** — hierarchical
- **Spine address** — sequential × kind

That makes the “counter-intuitive” part a boring dual-projection story: one graph, two coordinate systems, same visitors.
<span style="display:none">[^11_10][^11_11][^11_12][^11_13][^11_14][^11_15][^11_16][^11_5][^11_6][^11_7][^11_8][^11_9]</span>

<div align="center">⁂</div>

[^11_1]: https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model

[^11_2]: https://en.wikipedia.org/wiki/Document_Object_Model

[^11_3]: https://pmc.ncbi.nlm.nih.gov/articles/PMC7496673/

[^11_4]: https://learn.microsoft.com/en-us/dotnet/csharp/roslyn-sdk/get-started/syntax-analysis

[^11_5]: https://www.youtube.com/watch?v=kBOlhHrj7zc

[^11_6]: https://www.biorxiv.org/content/10.1101/2024.10.30.620612.full.pdf

[^11_7]: https://keyholesoftware.com/?p=160296

[^11_8]: https://www.sciencedirect.com/topics/engineering/address-offset

[^11_9]: https://dev.to/jackmarchant/offset-and-cursor-pagination-explained-b89

[^11_10]: https://assets.digitalocean.com/books/understanding-the-dom.pdf

[^11_11]: https://www.emergentmind.com/topics/hierarchical-code-sequences

[^11_12]: https://www.techsmith.com/learn/tutorials/camtasia/customize-your-cursor-path/

[^11_13]: http://web.stanford.edu/class/cs98si/slides/the-document-object-model.html

[^11_14]: https://math.hws.edu/eck/cs424/graphicsbook-1.0/c2/s4.html

[^11_15]: https://www.youtube.com/watch?v=HdwTIDF8_KU

[^11_16]: https://javascript.info/dom-nodes


---

# right, so i kind of lean towards eschewing the notion of a tree because its secondary to the more general graph concept behind it. the tree is a dimensionality reducing projection on the graph topology

Yes. Primacy belongs to the **graph**; the tree is a derived, lossy view.

## Primacy order

| Rank | Object | Role |
| :-- | :-- | :-- |
| 1 | **Manuscript graph** $D$ (DAG) | Full topology: containment, sequence constraints, shared targets, cross-refs |
| 2 | **Spanning arborescence / tree projection** $T \prec D$ | Dimensionality reduction: drop multi-parent and pure-ref edges until each node has ≤1 parent [^12_1][^12_2] |
| 3 | **Spine** $\tau$ | Further reduction: total order via traversal of $T$ (or directly of $D$) |

A tree is a restricted graph: connected, acyclic, unique path between nodes—equivalently a DAG in which every node has at most one parent.  Going graph → tree **throws away** edges (shared equation cited from three places, footnote with two referents, bidirectional structural links recorded as DAG edges). That is exactly a dimensionality-reducing projection on the edge set, not a different kind of object.[^12_3][^12_2]

So:

$$
D \xrightarrow{\pi_{\mathrm{tree}}} T \xrightarrow{\pi_{\mathrm{spine}}} \tau
$$

- $\pi_{\mathrm{tree}}$ — forget non-tree edges (or reify them as payload on remaining nodes)
- $\pi_{\mathrm{spine}}$ — forget branching; keep only visit order

MarkPig-as-AST is an **encoding** of $T$ (or of $D$ with ref edges out of band). It is not the ontological manuscript.

## What the tree projection loses

| Kept in $D$ | Lost or duplicated under $T$ |
| :-- | :-- |
| One node, many incoming ref edges | Must clone node or turn refs into string pointers |
| Multiple valid parent-like relations | Single parent only |
| Cross-stream anchors as edges | Ad-hoc attributes |
| True sharing (one MathDig root, many cite sites) | Copy or indirection hacks |

If your envelope must support shared math, multi-cite figures, and structural cross-links without duplication, **$D$ is the source of truth**. The tree is a convenience projection for:

- recursive visitors that assume one parent
- serialization formats that are naturally hierarchical (Markdown, XML)
- mental models borrowed from “the AST”


## How to talk about it without confusion

**Prefer:**

- manuscript **graph** / **DAG**
- **tree projection** / **spanning tree view** / **arborescent projection**
- **spine** = linearization of the graph (optionally via a chosen spanning tree)
- MarkPig **tree view** or **hierarchical projection** of the envelope graph

**Avoid implying:**

- “the document *is* a tree”
- “the AST *is* the envelope”

Better one-liner:

> The envelope instance is a typed DAG. Classic ASTs are spanning-tree projections of that DAG for hierarchical visitation; reading order is a further linear projection. Sub-addresses $(\mathrm{pos}, \mathrm{kind})$ live on the spine of the graph, not on the tree-as-ontology.

## Implementation consequence for MarkPig

Architect the store as a **graph**, expose projections:

```
ManuscriptGraph D
    │
    ├─ TreeView / Arborescence   → Roslyn-style parent/child visitors
    ├─ SpineView (τ)             → (pos, kind) addresses, TDM slots
    ├─ StreamView (math|prose)   → demux
    └─ RefEdge index             → cross-links, shared MathDig targets
```

Visitors can still *look* like Roslyn walkers on the tree projection; math visitors resolve shared MathDig nodes through the graph’s identity, not through cloned subtrees. PowerShell-style pipelines fit naturally:
`Get-EnvelopeNode | Where Kind -eq DisplayMath | Get-MathDigRoot`.

## Stack (graph-first)

1. **Modality** — text vs raster (multimodal RAG)
2. **Sources** $\xrightarrow{\text{abduce}}$ **envelope point** on manifold $M$
3. **Envelope instance** = typed **DAG** $D$ over universal scheme $G$
4. **Tree** = optional hierarchical **projection** of $D$ (MarkPig AST shape)
5. **Spine** $\tau$ = reading-order **linearization** of $D$ (TDM time axis)
6. **Streams** — math/prose coloring along $\tau$; MathDig parses math-stream payloads
7. **Addresses** — $(\mathrm{pos}, \mathrm{kind})$ on the spine; hierarchy is path-in-projection, secondary

Eschewing tree-as-primary is not pedantry; it keeps sharing, cross-refs, and dual-stream identity honest. The tree remains a useful **reduced coordinate chart** on the graph—not the manifold itself.
<span style="display:none">[^12_10][^12_11][^12_12][^12_13][^12_14][^12_15][^12_4][^12_5][^12_6][^12_7][^12_8][^12_9]</span>

<div align="center">⁂</div>

[^12_1]: https://en.wikipedia.org/wiki/Spanning_tree

[^12_2]: https://gist.github.com/lirenlin/013bc9fae7acfc48cc92cf40993cc772

[^12_3]: https://en.wikipedia.org/wiki/Tree_(graph_theory)

[^12_4]: https://cs.stackexchange.com/questions/897/does-spanning-tree-make-sense-for-dag

[^12_5]: https://ieeexplore.ieee.org/document/715916/

[^12_6]: https://pmc.ncbi.nlm.nih.gov/articles/PMC4566856/

[^12_7]: https://stackoverflow.com/questions/624778/how-to-convert-directed-acyclic-graph-dag-to-tree

[^12_8]: https://dvia.samizdat.co/2019/tree-and-graph/index.html

[^12_9]: https://pdxscholar.library.pdx.edu/cgi/viewcontent.cgi?article=3953\&context=open_access_etds

[^12_10]: https://www.geeksforgeeks.org/dsa/difference-between-graph-and-tree/

[^12_11]: https://www.scribd.com/presentation/825858694/26a-Data-Structure-Algorithms-Spanning-Tree

[^12_12]: https://www.youtube.com/watch?v=qD6taefu3-Q

[^12_13]: https://www.scribd.com/document/910434430/Review-of-Tree-and-Graph-Structures-1

[^12_14]: https://www.contrib.andrew.cmu.edu/~ravi/leafy.pdf

[^12_15]: https://www.philadelphia.edu.jo/academics/eabusamra/uploads/Ch6-Part1.pdf


---

# references between different components in a given instance of the graph (a manuscript) are also part of the spec via inline markdown links, citation pointers to numbered bibliography or references sections in the form of markdown footnote lists, for example

Yes. Those surface forms are not decoration on a tree—they are the **serialization of ref edges** in the manuscript DAG. Treating them as first-class graph structure is what makes “graph primary, tree secondary” pay off.

## References as edges

In an envelope instance $D$, nodes are semantic components; **references are directed edges** (or edge bundles) between them:


| Surface (Markdown / MarkPig) | Graph meaning |
| :-- | :-- |
| Inline link `[text](#eq-energy)` | Ref edge → target node (equation, section, figure…) |
| Footnote ref `[^smith2020]` | Ref edge → footnote/bibliography definition node |
| Footnote definition `[^smith2020]: …` | Target node (often in a references region) |
| Citation pointer to numbered refs | Ref edge → bibliography item node |
| Cross-ref to figure/table/section | Ref edge → labeled block node |

mdast-style models already split **reference** vs **definition** (e.g. `footnoteReference` / `footnoteDefinition`, link + destination).  On the graph, that split is: **source endpoint** (inline site on the spine) vs **target node** (shared, addressable, possibly many-in).[^13_1][^13_2]

So the spec is not “Markdown plus optional links.” It is:

> The manuscript graph’s edge vocabulary includes reference relations; Markdown links, footnotes, and citation lists are the concrete syntax for those edges.

## Edge kinds (typed)

Keep a small, explicit edge taxonomy on $D$:


| Edge kind | Role | Typical surface |
| :-- | :-- | :-- |
| **dominates** / contains | Hierarchical incidence (what the tree projection keeps) | Block nesting |
| **precedes** | Reading-order / TDM constraint | Implicit in spine; sometimes explicit |
| **refers-to** | General internal reference | `[…](#id)`, `{ref}` |
| **cites** | Bibliographic reference | `[^key]`, cite syntax → bib item |
| **annotates** | Footnote body attached to a locus | footnote def tied to ref sites |
| **same-as** / alias | Optional identity for shared anchors | duplicate labels policy |

Tree projection $\pi_{\mathrm{tree}}$ keeps **dominates** (and maybe a single parent spine). It **drops or reifies** `refers-to` / `cites` / `annotates` as payloads. Graph-primary MarkPig **retains them as edges**, so one bibliography node can have in-degree > 1 without cloning.[^13_3][^13_4]

## How this sits on the spine

References do **not** break reading-order TDM; they add a second relation beside it:

```
Spine τ (reading order):  n0 → n1 → n2 → … → bib_item_k → …
                              ↘ cites ↗
```

- **Sequential address** $(\mathrm{pos}, \mathrm{kind})$ — where the *cite site* and the *target* sit on $\tau$
- **Graph address** — edge $e: \mathrm{citeSite} \xrightarrow{\mathrm{cites}} \mathrm{bibItem}$
- Demux still works: cite sites may live in prose stream; targets in prose (bib list) or math (equation labels)

A visitor can walk the spine for order-sensitive work (embeddings, slot masks) and walk **ref edges** for link-sensitive work (resolve citations, build backrefs, graph RAG).

## Spec obligations for MarkPig

1. **Parse** inline links, footnote refs/defs, and citation lists into nodes **and** into `refers-to` / `cites` / `annotates` edges—not only into string hrefs.
2. **Identity** of targets: one definition node per key; many ref sites point at it (DAG sharing).
3. **Spine placement**: definition regions (footnote lists, bibliography sections) are ordinary spine spans with kinds like `FootnoteDefinition`, `BibliographyItem`.
4. **Addressing**:
    - site: `(pos_site, Link|FootnoteReference|Cite)`
    - target: `(pos_target, FootnoteDefinition|BibItem|…)` or stable `id`
    - edge: first-class, queryable (`Get-RefEdge -Kind Cites`)
5. **Tree view**: hierarchical children only; ref edges available via graph API / visitor hooks (`VisitRefEdge`), not faked as extra parents.
6. **Math channel**: equation labels and `\ref`-style targets are MathDig- or MarkPig-level anchors with the same `refers-to` edge kind—cross-stream refs are normal edges that happen to touch a math-kind node.

## Bibliography / footnote lists

A “references section as markdown footnote list” is not a footer hack; it is a **region of target nodes** on the DAG:

- List structure → dominates edges among region, items
- Each item → node with stable key
- Every `[^key]` in the body → `cites` or `annotates` edge into that node
- Numbering is a **rendering** of in-spine order or of a dedicated ordering edge—not the identity of the node

That keeps abduction honest: different sources may number refs differently; the envelope identity is keys + edges, not the printed “$$
3
$$”.

## One-line addition to the architecture

> An envelope instance is a typed DAG whose edge set includes dominance, reading-order constraints, and reference relations; Markdown inline links, footnote lists, and citation pointers are the concrete syntax for those reference edges, so cross-component structure is part of the graph spec—not an afterthought on a tree projection.

That closes the loop: graph primary, tree = hierarchical projection, spine = linear projection, streams = TDM coloring on the spine, **refs = explicit edges** serialized by the Markdown link/footnote/cite surface you already want in the spec.
<span style="display:none">[^13_10][^13_11][^13_12][^13_13][^13_14][^13_15][^13_16][^13_17][^13_5][^13_6][^13_7][^13_8][^13_9]</span>

<div align="center">⁂</div>

[^13_1]: https://mystmd.org/spec/references

[^13_2]: https://mystmd.org/spec/footnotes

[^13_3]: https://stackoverflow.com/questions/624778/how-to-convert-directed-acyclic-graph-dag-to-tree

[^13_4]: https://gist.github.com/lirenlin/013bc9fae7acfc48cc92cf40993cc772

[^13_5]: https://stackoverflow.com/questions/15110479/markdown-and-footnotes-most-natural-format-missing

[^13_6]: https://www.sciencedirect.com/topics/computer-science/citation-network

[^13_7]: https://unifiedjs.com/explore/package/mdast-util-to-hast/

[^13_8]: https://meta.stackexchange.com/questions/5017/markdown-footnotes

[^13_9]: https://publications.scss.tcd.ie/theses/diss/2021/TCD-SCSS-DISSERTATION-2021-035.pdf

[^13_10]: https://github.com/syntax-tree/mdast-util-gfm-footnote

[^13_11]: https://python-markdown.github.io/extensions/footnotes/

[^13_12]: https://github.com/minhtran241/arxiv-citation-network

[^13_13]: https://github.blog/changelog/2021-09-30-footnotes-now-supported-in-markdown-fields/

[^13_14]: https://www.chatacademia.com/agents/paper-graph

[^13_15]: https://devupdate.io/explore/syntax-tree/mdast-util-gfm-footnote

[^13_16]: https://github.com/syntax-tree/mdast

[^13_17]: https://www.linkedin.com/posts/consensus-nlp_today-were-launching-citation-graph-activity-7432866620458455040-QxIk


---

# another feature of the envelope is linking between figures and captions, including both rasterized external image assets and their captions, as well as things like commutative diagrams that can be rendered natively in the math channel and by extension via the eventual mathdig AST. figures and captions are both elementary nodes in the latent manuscript's namespace, but a composite object would be a figure with its caption, just as a section header and its associated body. and then the visitor semantics immediately pay off in the interleaved prose and math within a section body for example

Yes. That is the same graph pattern again: **elementary nodes** plus **composite aggregates**, with **typed edges** binding figure bodies to captions—and the body may sit in either the raster modality or the math stream.

## Elementary vs composite

| Level | Examples | Graph role |
| :-- | :-- | :-- |
| **Elementary nodes** | `FigureBody`, `Caption`, `SectionHeader`, `SectionBody`, image asset ref, MathDig diagram root | First-class identities in the envelope namespace; spine-addressable $(\mathrm{pos}, \mathrm{kind})$ |
| **Composite units** | Figure = body + caption; Section = header + body | Subgraphs (or reified aggregate nodes) with structured dominance/ref edges—not a different ontology |

```
HTML’s own model is the same idea: `<figure>` is a unit that groups content with an optional `<figcaption>`, referenced as one unit while caption and body remain distinct elements.  You lift that from markup convention to **envelope graph spec**.[^14_1][^14_2]
```

```
FigureComposite
├── dominates → FigureBody     (raster asset | math-native diagram)
└── dominates → Caption      (usually prose stream; may embed inline math)
        └── caption-of → FigureBody   (explicit bidirectional or inverse edge)
```

Section is parallel:

```
SectionComposite
├── dominates → SectionHeader
└── dominates → SectionBody
        └── spine: interleaved prose slots + math slots (TDM)
```

Composites are how visitors get a **unit of work** (“visit this figure,” “visit this section”) without erasing elementary addresses.

## Figure body: two realizations, one role

Same elementary kind `FigureBody` (or a small sum type), two payloads:


| Realization | Channel / modality | Parsing |
| :-- | :-- | :-- |
| External raster (PNG/SVG/JPEG…) | **Image modality** (true multimodal asset) | Asset ref + optional layout hints; not MathDig |
| Native diagram (commutative diagram, tikz-cd-like, KaTeX/MathDig drawable) | **Math stream** | MarkPig math node → **MathDig AST** |

Both are figure bodies in the manuscript namespace; both can carry the same `caption-of` edge to a `Caption` node. Downstream RAG can dual-route:

- raster body → image encoder (multimodal)
- math body → MathDig → math-sector embedding
- caption → prose-sector (with possible inline math demux)

That keeps **modality** (pixels vs text) orthogonal to **stream** (math vs prose) orthogonal to **composite structure** (figure unit).

## Edges for figures and captions

| Edge | Meaning |
| :-- | :-- |
| `dominates` | Composite → elementary parts (tree projection keeps these) |
| `caption-of` / `has-caption` | Body ↔ caption (ref-class edge; survives as sharing-friendly link) |
| `refers-to` | Prose “see Fig. 3” → FigureComposite (or body) |
| `asset-ref` | Body → external raster URI / content hash (not a manuscript node, an outward pointer) |

Caption and body stay **separately addressable** (`Caption#2`, spine pos of body) while the composite gives a single target for “Figure 3” citations—same pattern as bib items with many cite sites.

## Where visitors pay off

Section body is the clearest win: one composite, spine-linearized, TDM-interleaved.

```
SectionBody (composite region on spine)
  pos 10  Paragraph          prose
  pos 11  InlineMath         math → MathDig
  pos 12  Paragraph          prose
  pos 13  DisplayMath        math → MathDig   (e.g. commutative diagram)
  pos 14  FigureComposite
            Body (raster)    image modality
            Caption          prose (+ optional inline math)
  pos 15  Paragraph          prose
```

Visitor profiles (Roslyn/PowerShell-shaped):

- **`SectionBodyWalker`** — default recursive walk in spine order
- **`ProseStreamVisitor`** — kind/stream filter; skip or redact math slots
- **`MathStreamVisitor`** — collect math slots; dispatch **MathDig** walkers (diagrams, inline)
- **`FigureVisitor`** — enter `FigureComposite`; visit body vs caption with different handlers
- **`CaptionVisitor`** — prose (+ nested math visitors for inline $…$ in captions)
- **`CrossRefVisitor`** — follow `refers-to` / `caption-of` without caring about tree depth

Interleaved prose/math in a section body is then not a special case: it is **spine order + stream tags + dispatch**. Composites only change the granularity of “enter/exit” callbacks (`VisitFigure`, `VisitSection`), which is exactly why visitor semantics pay off over ad-hoc recursion.

## MathDig and commutative diagrams

Native diagrams are math-channel content:

1. MarkPig: `DisplayMath` / `FigureBody(kind=MathDiagram)` on the spine
2. Parse payload → **MathDig AST** (objects, arrows, 2-cells, layout atoms—whatever your lexicon allows)
3. MathDig visitors: validate, rewrite, embed, or emit render IR
4. Optional: same diagram node also plays the role of figure body under a `FigureComposite` with a prose caption

Raster figures never enter MathDig; they stay asset refs on the image-modality side. One composite type, two body backends.

## Namespace sketch (elementary kinds)

- `SectionHeader`, `SectionBody`
- `FigureBody`, `Caption`
- `Paragraph`, `InlineMath`, `DisplayMath`
- `FootnoteReference`, `FootnoteDefinition`, `BibItem`
- `Link` / cross-ref sites

Composites (aggregates or first-class nodes with mandated child structure):

- `SectionComposite` ⊃ header + body
- `FigureComposite` ⊃ body + caption

Both elementary and composite nodes live in the same envelope namespace and the same spine address space; composites additionally define a **small required subgraph** schema.

## Stack delta

| Piece | Addition |
| :-- | :-- |
| Graph | `caption-of`, figure/section composite structure |
| Elementary nodes | body and caption as separate identities |
| Math stream | commutative diagrams etc. via MathDig under figure body *or* bare display math |
| Image modality | raster bodies as assets, still caption-linked in-graph |
| Visitors | composite enter/exit + stream dispatch inside section bodies |
| Addresses | elementary $(\mathrm{pos},\mathrm{kind})$; composites addressable as units for “Fig. n” |

## One-liner

> Figures and captions are elementary envelope nodes joined by caption edges into figure composites (parallel to section header+body); the body is either a raster asset or a math-channel diagram expanded by MathDig; visitors walk section bodies in spine order, demuxing interleaved prose and math and handling figure composites as structured units without collapsing the graph to a tree.

That is the same architecture throughout: graph primary, composites as typed subgraphs, spine for order, streams for math/prose, modality for pixels, visitors for every projection.
<span style="display:none">[^14_10][^14_11][^14_12][^14_13][^14_14][^14_15][^14_3][^14_4][^14_5][^14_6][^14_7][^14_8][^14_9]</span>

<div align="center">⁂</div>

[^14_1]: http://www.w3schools.com/TAgs/tag_figcaption.asp

[^14_2]: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/figure

[^14_3]: https://pmc.ncbi.nlm.nih.gov/articles/PMC6821181/

[^14_4]: https://tex.stackexchange.com/questions/284785/drawing-non-trivial-commutative-diagrams

[^14_5]: https://github.com/ueberdosis/tiptap/issues/573

[^14_6]: https://chec.engineering.cornell.edu/visuals/captions-for-figures-in-documents/

[^14_7]: https://docs.cx-reports.com/components/figure-caption/

[^14_8]: https://matheducators.stackexchange.com/questions/27678/an-algebra-student-wants-to-learn-to-type-commutative-diagrams-in-latex

[^14_9]: https://github.com/syntax-tree/mdast

[^14_10]: https://lisavangsnessphd.substack.com/p/easy-figure-and-table-captions-in

[^14_11]: https://www.reddit.com/r/math/comments/523uix/commutative_diagrams_in_latex/

[^14_12]: https://www.internationalscienceediting.com/how-to-write-a-figure-caption/

[^14_13]: https://mathworld.wolfram.com/CommutativeDiagram.html

[^14_14]: https://www.youtube.com/watch?v=Z8pyaXGbIuw

[^14_15]: https://www.jmilne.org/not/CDGuide.html


---

# the difference between what i'm building and HTML though is that HTML format like XML is based on a bunch of tags and container overhead associated with that. I'm trying to create a more robust markdown flavor with low-level AST parsing to achieve similar structured documentation without alot of overt metadata tags and container format. because the intended audience is models, a document in a form that's immediately readable by human or model with the benefits of AST structure and the parsing/validation that comes with the formalizations. i suppose the "figure" + "caption" or any other composite objects could be seen as subgraphs with closure

Yes. That is the right split: **structure lives in the latent graph/AST; the surface stays a lean Markdown flavor.** HTML/XML put the structure *in the character stream* as tags and containers. You put the structure in MarkPig/MathDig after parse, so the source stays immediately readable by humans and models while still getting formal validation, visitors, and dual-stream demux.[^15_1][^15_2][^15_3]

## Two layers, one contract

| Layer | What it is | Overhead |
| :-- | :-- | :-- |
| **Surface** | MarkPig Markdown flavor — headings, lists, links, footnotes, math fences/delimiters, figure conventions | Minimal, prose-first; little or no container tag soup |
| **Latent** | Manuscript DAG + spine + streams + MathDig | Full structure, kinds, edges, addresses, validation |

HTML is a **publishing format** with explicit open/close containers. Markdown is a **writing format** whose syntax only marks what plain text can carry.  You are pushing that further: the *audience* of the surface is models as much as humans, so token budget and legibility matter; the *consumer* of structure is the AST toolchain (parse, validate, visit, demux, embed).[^15_4]

```
Models already ingest Markdown well; they choke on or waste context on nested `<figure><figcaption>…` scaffolding. Your design keeps the training-/inference-friendly surface and still offers DOM-class structure **after** a real parser—not via tags in the prompt.
```


## Composites as closed subgraphs

“Figure + caption” (and “section header + body”) as **subgraphs with closure** is exact:

- Pick a vertex set $S$ (e.g. body node, caption node, optional label/anchor).
- **Induced subgraph** $D[S]$: all envelope edges with both ends in $S$ — including `dominates`, `caption-of`, internal links.[^15_5][^15_6]
- **Closure**: $S$ is closed under the composite’s schema — required parts present, edge kinds satisfied, invariants hold (one primary body, one caption slot, stable id for “Fig. n”, etc.).
- The composite is either
    - that closed induced subgraph, or
    - a lightweight aggregate node whose only job is to name $S$ for visitors and refs.

Nothing on the surface needs `<figure>…</figure>`. A MarkPig convention might be as thin as:

```markdown
![alt](assets/plot.png)

Figure 3. Loss curves for the ablation. Note the $\ell_2$ term.
```

or a lightly marked block your parser recognizes. Abduction + parse **builds** the closed subgraph; the source never pays XML container tax.

Same for sections: `#` / `##` plus following body until the next peer heading is enough surface for a section composite; the graph gets header node, body region, dominates edges, spine span.

## What “robust Markdown flavor” means here

Not “Markdown with more sigils.” Rather:

1. **Low-level AST parse** — deterministic MarkPig grammar → DAG + spine (not regex soup).
2. **Validation** — schema on nodes/edges/composites (closed figure, well-typed refs, KaTeX-legal math slots).
3. **Default readability** — if you never look at the AST, the file still reads as a paper.
4. **Model-facing** — structure is recoverable by parse, not by stuffing tags into the context window.
5. **Escape hatches** — only when the lean surface cannot express an edge; prefer convention + parse over new bracket languages.

Math stays in-stream (`$…$`, `$…$`, or your delimiters) so MathDig expands it; commutative diagrams never require an HTML mini-document.

## Visitors without tag trees

Because composites are closed subgraphs, visitors key off **graph identity and kind**, not off matching close tags:

- `VisitFigureComposite` — enter closure $S$; dispatch body (raster vs MathDig) vs caption
- `VisitSectionBody` — walk spine span of the body; interleaved prose/math falls out of stream tags
- Demux / embed / ref-resolve — same walkers, no container stack required at the surface

The tree projection is still available for hierarchical UIs; it is not what authors or models have to write.

## Contrast in one table

|  | HTML/XML | MarkPig envelope |
| :-- | :-- | :-- |
| Structure carrier | Tags in the byte stream | Latent DAG after parse |
| Composite | Nested elements | Closed induced subgraph (schema) |
| Human/model read of source | Noisy | High |
| Formal validation | Schema on tagged tree | Schema on graph + MathDig |
| Figure+caption | `<figure>` + `<figcaption>` | Convention → `FigureBody`+`Caption`+`caption-of` |
| Math diagram | Often foreign object / image | Math stream → MathDig |
| Primary audience of source | Browsers / layout engines | Humans + models + tooling |

## Architecture line

> MarkPig is a low-overhead Markdown flavor whose parse yields a typed manuscript DAG (spine, streams, ref edges, closed composite subgraphs). Structure and validation live in that latent graph and in MathDig—not in overt container tags—so the same document stays model- and human-readable while supporting figure–caption units, section composites, interleaved prose/math visitors, and dual-sector RAG.

“Subgraph with closure” is the right name for composites: elementary nodes stay in the namespace; the composite is the closed bundle the schema and visitors treat as one unit.
<span style="display:none">[^15_10][^15_11][^15_12][^15_13][^15_14][^15_15][^15_7][^15_8][^15_9]</span>

<div align="center">⁂</div>

[^15_1]: https://leadmagic.io/blog/markdown-vs-html

[^15_2]: https://markdown.co.in/blog/02-markdown-vs-html.html

[^15_3]: https://webcrawlerapi.com/blog/html-vs-markdown-choosing-the-right-output-format

[^15_4]: https://dri.es/switching-to-markdown-after-20-years-of-html

[^15_5]: https://mathworld.wolfram.com/Vertex-InducedSubgraph.html

[^15_6]: https://en.wikipedia.org/wiki/Induced_subgraph

[^15_7]: https://github.com/syntax-tree/mdast

[^15_8]: https://academiccommons.columbia.edu/doi/10.7916/D8WW7GK4

[^15_9]: https://developers.google.com/style/markdown

[^15_10]: https://www.npmjs.com/package/mdast-util-to-markdown

[^15_11]: https://www.labri.fr/perso/courcell/CoursMaster/Giakou1997.pdf

[^15_12]: https://unifiedjs.com/learn/guide/introduction-to-syntax-trees/

[^15_13]: https://gocardless.com/blog/fun-with-markdown-and-remark

[^15_14]: https://stackoverflow.com/questions/55555417/if-markdown-is-a-superset-of-html-then-why-cant-it-do-everything-html-can

[^15_15]: https://www.telerik.com/blogs/asts-markdown-and-mdx


---

# and recursively, figures can in theory be further sub-divided into sub-figures with captions structurally segmented accordingly, sort of like internal visitors or sub-sub-graphs

Yes. Recursion is free once composites are **closed subgraphs**: a figure composite’s body slot can hold not only a raster or MathDig diagram, but **another figure composite** (or a panel of them). Sub-figures are the same schema one level down—not a new concept.[^16_1][^16_2]

## Recursive composite schema

Same elementary parts, nested closures:

```
FigureComposite₀                    ← outer closed subgraph S₀
├── Caption₀                        ← global caption
└── Body₀
      ├── FigureComposite₁           ← S₁ ⊂ interior of S₀
      │     ├── Caption₁            ← subcaption (a)
      │     └── Body₁  (raster | MathDig | …)
      ├── FigureComposite₂           ← S₂
      │     ├── Caption₂            ← (b)
      │     └── Body₂
      └── …
```

Each $S_i$ is an **induced closed subgraph**: required vertices present, `caption-of` / `dominates` edges satisfied, stable id for refs (`Fig. 3`, `Fig. 3a`).[^16_3][^16_4]
**Nesting** = $S_{\mathrm{child}}$ lives in the body region of $S_{\mathrm{parent}}$ (dominance + spine span containment).

LaTeX `subfigure` / multi-panel practice is exactly this: outer figure + caption, inner panels each with subcaption and label, independently and jointly referenceable.  You get that from graph closure depth, not from `\begin{subfigure}` tags on the surface.[^16_2][^16_5]

## Sub-sub-graphs, not a second ontology

| Term | Meaning |
| :-- | :-- |
| **Elementary** | `FigureBody`, `Caption`, … (leaves of the composite grammar) |
| **Composite** | Closed subgraph matching the figure schema |
| **Sub-figure** | Composite whose parent in the dominance DAG is another figure’s body |
| **Panel set** | Ordered children of one body (spine order inside the parent closure) |

Depth is unbounded in the data model (practically small: figure → panels → rarely deeper). Validation is recursive: `ValidateFigureClosure(S)` calls itself on child composites.

## Internal visitors = visitors on a closure

“Internal visitors” are ordinary visitors with a **restricted root** (or a filtered spine span):

```text
VisitFigureComposite(S):
  VisitCaption(S.caption)           # prose stream (+ inline math)
  for child in SpineOrder(S.body):
    if child is FigureComposite:    # sub-figure
      VisitFigureComposite(child)   # recurse — sub-sub-graph
    elif child is MathDig body:
      Dispatch MathDigWalker
    elif child is Raster body:
      Dispatch asset / image-modality handler
    else:
      VisitProseOrMath slot…
```

Same pattern as section bodies: enter composite → walk interior spine → demux streams → recurse into nested closures. No special “sub-visitor” type is required; **scope** is the closure $S$ (or its spine interval $[\mathrm{pos}_{\min}, \mathrm{pos}_{\max})$).

PowerShell-shaped:

```powershell
Get-FigureComposite -Id fig3 |
  Get-ChildComposite |          # sub-figures only
  Invoke-MarkPigVisitor $v
```


## Addressing at every depth

Spine addresses remain global; kind-scoped and composite-relative addresses nest:


| Address form | Example |
| :-- | :-- |
| Global spine | `(pos=120, FigureComposite)` |
| Kind ordinal | `FigureComposite#3` |
| Hierarchical (projection) | `fig3 / panel[b]` |
| Closure-relative | `(S₃, Caption)` or `Fig.3b` via label edge |
| Ref edge | prose cite → `S₃` or → outer `S₀` |

Outer and inner closures both remain cite targets (“Figure 3” vs “Figure 3b”), which is why the DAG (sharing + ref edges) stays primary: the tree projection would either clone or drop multi-level labels.[^16_6][^16_5]

## Surface stays lean

Still no HTML-like nested tag tax. A MarkPig convention can stay readable, e.g. multi-image blocks + caption lines + light panel markers your parser turns into nested closures—or even layout cues abduced from “Figure 3. … (a) … (b) …” patterns in scholarly Markdown. Structure is **recovered into** nested closed subgraphs; authors/models don’t write container trees.

## Math channel at any depth

Any body slot, any level:

- raster asset → image modality
- commutative diagram / native draw → MathDig
- nested composite → recurse

A panel can be a MathDig diagram with its own subcaption while a sibling panel is a PNG—same visitor spine, different dispatch.

## Stack delta (one line each)

- **Composite** = closed induced subgraph under figure (or section) schema
- **Sub-figure** = composite nested in another figure’s body
- **Segmentation** = child closures + their captions along the parent’s interior spine
- **Internal visitor** = visitor rooted at a closure (recursive by default)
- **Surface** = still low-overhead MarkPig; nesting depth is latent


## One-liner

> Figure composites are closed subgraphs that nest: sub-figures are the same schema inside a parent body, with captions segmented per closure; visitors recurse on those sub-sub-graphs along the interior spine, demuxing prose/math and raster/MathDig bodies at every depth—without turning the author-facing document into nested HTML containers.

That is structural recursion on closures, not a new layer in the architecture.
<span style="display:none">[^16_10][^16_11][^16_12][^16_13][^16_14][^16_15][^16_16][^16_17][^16_7][^16_8][^16_9]</span>

<div align="center">⁂</div>

[^16_1]: https://clauswilke.com/dataviz/multi-panel-figures.html

[^16_2]: https://www.overleaf.com/learn/latex/How_to_Write_a_Thesis_in_LaTeX_(Part_3):_Figures,_Subfigures_and_Tables

[^16_3]: https://mathworld.wolfram.com/Vertex-InducedSubgraph.html

[^16_4]: https://en.wikipedia.org/wiki/Induced_subgraph

[^16_5]: https://comdyn.hy.tsinghua.edu.cn/from-web/latex/303-formatting-captions-and-subcaptions-in-latex

[^16_6]: https://tex.stackexchange.com/questions/130505/referencing-to-subfigures-in-main-caption

[^16_7]: https://tex.stackexchange.com/questions/222117/multiple-panel-figure-with-caption-in-one-of-the-panels

[^16_8]: https://www.reddit.com/r/LaTeX/comments/1qhb293/how_to_handle_subfigures_caption_properly/

[^16_9]: https://lhncbc.nlm.nih.gov/LHC-publications/PDF/published_asi22810_0.pdf

[^16_10]: https://theplosblog.plos.org/2019/12/multi-panel-figures-using-gimp-to-combine-individual-images-for-use-in-plos-articles/

[^16_11]: https://ctan.org/pkg/subfigure?lang=en

[^16_12]: https://bioinformatics.ccr.cancer.gov/docs/data-visualization-with-r/Lesson6_V2/

[^16_13]: https://webaim.org/discussion/mail_thread?thread=9273

[^16_14]: https://arxiv.org/html/2601.08026v4

[^16_15]: https://latex.org/forum/viewtopic.php?t=35375

[^16_16]: https://vizcept.com/blog/how-to-make-multi-panel-figures-nature-science

[^16_17]: https://www.youtube.com/watch?v=zgh96zNJp34


---

# right so this circles back on the challenge of the document format conversion from latex (and later pdf and others) to the graph-enriched markdown format/flavor. For latex conversion i need to be able to deterministically parse latex language into various forms of evidence for the surjection of math channel content into the lexically invariant math "register", as well as parsing evidence from things like typesetting/formatting furniture in order to correctly render the math to standard and then stripping the furniture, which is a current focus of the work

Yes. Conversion is the **abductive front-end** of the surjection $\pi: \mathcal{S} \twoheadrightarrow M$: LaTeX (later PDF, …) is a noisy realization; MarkPig+MathDig is the envelope point. The hard part is not “string replace environments with Markdown”—it is **separating math-channel substance from typesetting furniture**, then mapping substance into a **lexically invariant math stream** (KaTeX-stable lexicon) while furniture only supplies evidence for that map and is then discarded.[^17_1][^17_2]

## What “furniture” is

In this pipeline, **furniture** = presentation/layout apparatus that is not part of the canonical math or prose streams:


| Furniture (examples) | Role in source | Fate under $\pi$ |
| :-- | :-- | :-- |
| `\displaystyle`, `\textstyle`, `\scriptstyle` | Size/style hints | Evidence → strip |
| `\quad`, `\qquad`, `\,`, `\;`, `\!`, manual `~` | Spacing | Evidence / normalize → strip or canonical spacing |
| `\left`/`\right` vs fixed delimiters | Stretch policy | Evidence for delimiter atoms → canonical MathDig |
| `\phantom`, `\hphantom`, `\vphantom` | Layout hacks | Evidence → strip |
| `\label`/`\tag`/`\nonumber` placement quirks | Numbering furniture | Label → ref edge; visual tag policy → strip |
| `\begin{align}` column markers `&`, `\\` | Alignment furniture | Structure → MathDig align graph; raw markers normalized |
| `\mathcal` vs `\mathscr` when semantically equivalent under your lexicon | Font furniture | Map to invariant atom or keep if semantically load-bearing |
| Vertical space, `\medskip`, minipage wrappers around math | Page furniture | Strip after structure recovered |
| Color, `\bf` in math, decorative rules | Style furniture | Strip unless semantic |

**Substance** = what must survive in the math stream: operators, atoms, relations, scripts, fractions, boundaries of subexpressions, diagram objects/arrows, citation/label *identity* (not its visual tag).

So the math “register” you care about is really: **lexically invariant MathDig IR** (KaTeX-compliant control sequences / atoms), not “whatever tokens LaTeX happened to use.”

## Conversion as staged evidence → envelope

```
LaTeX source s ∈ S
        │
        ▼
[^17_1] LaTeX parse  →  concrete syntax / token stream
        │
        ▼
[^17_2] Mode/region partition  →  prose spans | math spans | float structure | bib/footnotes
        │
        ▼
[^17_3] Math-span analysis
        ├─ furniture features  (spacing, style, align tabs, stretch, phantoms…)
        └─ substance candidates (atoms, ops, structure)
        │
        ▼
[^17_4] Normalize substance  →  KaTeX-stable lexicon  →  MathDig AST
        │     (furniture used as constraints/priors, then dropped)
        ▼
[^17_5] Prose + structure  →  MarkPig DAG (sections, figures, captions, refs…)
        │
        ▼
[^17_6] Wire edges  (caption-of, cites, refers-to, dominates)
        │
        ▼
[^17_7] Spine τ + stream tags  →  envelope instance m ∈ M
        │
        ▼
MarkPig Markdown surface (low overhead)  +  latent graph
```

Steps 3–4 are your current focus: **deterministic parse → evidence bundles → invariant math stream → strip furniture**.

## Evidence, not one-shot rewrite

Treat each math span as producing an **evidence record**, not a single string:

```text
MathSpanEvidence {
  source_span,
  env: equation|align|inline|…,
  tokens: [...],
  furniture: { spacing[], style[], align_tabs[], stretch[], phantoms[] },
  substance_seed: partial atoms/ops,
  labels/tags,
  confidence / ambiguity flags
}
```

Deterministic parse gives you the token backbone. Furniture features **condition** normalization (e.g. `&` columns → align structure; `\left(` → scalable paren atom). After MathDig accepts a canonical form, furniture fields are **not** serialized into MarkPig math slots—only the invariant lexicon is.

That is the surjection on the math channel:

$$
\text{LaTeX math realizations} \twoheadrightarrow \text{MathDig IR / KaTeX-stable stream}
$$

Many surface forms (with different furniture) land on one MathDig tree.

## Lexical invariance (math stream target)

Target properties for the math channel after strip:

- KaTeX-legal (or your declared) control sequences and atoms
- Stable choice among equivalent writings (`\leq` vs `\le`, `\mathrm{d}` policy, etc.)
- Structure in MathDig (frac, scripts, tables/align as graph), not as raw `\\`/`&` furniture
- Semantic operators retained (`\sin`, `\log`, …) as math-stream members even when they look like prose
- Labels promoted to **graph identity + ref edges**, not left as typesetting tags only

MarkPig surface then embeds that IR with lean delimiters (`$…$` / `$…$` or your flavor), readable by models/humans; MathDig remains the authoritative parse.[^17_3][^17_1]

## Furniture: use, then strip

A clean policy:

1. **Detect** furniture classes during LaTeX math parse.
2. **Interpret** them as constraints when building MathDig (alignment arity, delimiter extent, intentional grouping).
3. **Render-to-standard** = emit canonical MathDig (and optionally a normalized KaTeX string).
4. **Strip** = drop furniture from IR and from MarkPig serialization.
5. **Retain only** if your envelope schema marks it semantic (rare: e.g. a color that encodes case distinction—you’d promote that to an explicit annotation edge, not keep raw `\color`).

“Render the math to standard” here means **canonical IR**, not PDF pixels. Pixel rendering is a later check (optional round-trip oracle), not the identity of the stream.

## Prose-side furniture (same idea)

LaTeX conversion also produces prose furniture: `\noindent`, manual `\hspace`, `~` before cites, `\emph` vs `\textit`, theorem environment chrome, etc. Same pattern:

- evidence for section/figure/theorem composites and emphasis
- strip chrome
- keep substance in MarkPig kinds + edges

Floats → figure composites (body + caption closure); `\includegraphics` → raster body + asset-ref; `tikz-cd`/diagram envs → math body → MathDig; `\caption` → caption node + `caption-of`. Nested `subfigure` → nested closed subgraphs.

## Determinism vs abduction

| Piece | Character |
| :-- | :-- |
| LaTeX lex/parse of a span | Prefer **deterministic** (grammar/PEG/LaTeX-aware tokenizer) [^17_1] |
| Macro expansion / package-defined commands | Deterministic where expandable; else evidence + residual |
| Furniture → structure | Deterministic rules first (align tabs, left/right, labels) |
| Ambiguous semantics (same glyphs, different meaning) | **Abductive** choice into envelope; record alternatives |
| Full document $\pi$ | Abductive surjection; math channel is the most rule-heavy fiber |

So: deterministic **parsers and normalizers** inside an abductive **document-level** map. That matches “evidence for the surjection” rather than claiming the whole paper conversion is a pure function with no ambiguity.

## Pipeline modules (implementation-shaped)

1. **`LatexLexer` / `LatexParser`** — full source or chunked
2. **`RegionPartitioner`** — prose / math / float / bib (mode-aware, not regex-only)
3. **`MathFurnitureExtractor`** — classify spacing, style, align, stretch, phantom, tag
4. **`MathSubstanceNormalizer`** — → KaTeX-stable token IR
5. **`MathDigBuilder`** — IR → MathDig AST (validate)
6. **`FurnitureStripper`** — drop non-semantic presentation from IR/surface
7. **`MarkPigBuilder`** — regions + composites + ref edges + spine
8. **`EnvelopeValidator`** — closed figures, ref integrity, stream tags
9. **`MarkPigSerializer`** — low-overhead Markdown flavor for humans/models

Later: PDF layer becomes another evidence source (layout boxes, fonts, glyph runs) feeding the same normalizer/stripper—not a separate truth.

## Relation to the stack (short)

- **Source** LaTeX ∈ $\mathcal{S}$
- **Furniture** = presentation dimensions of the realization
- **Math stream** = lexically invariant channel after strip
- **MathDig** = AST of that channel
- **MarkPig** = envelope DAG surface without XML container tax
- **Surjection** $\pi$ = abduce $m \in M$ using parse evidence; math fiber is rule-heavy and should be as deterministic as possible


## Focus statement for the current work

> Deterministically parse LaTeX math into substance vs typesetting furniture; use furniture as evidence to build a KaTeX-stable MathDig form; strip furniture; lift document structure (including figures/captions/refs) into the MarkPig DAG so conversion is a surjection onto the envelope—not a lossy text dump and not an HTML-tag expansion.

That is the right circle-back: conversion quality is gated on **math-channel invariance + furniture strip**, with everything else (composites, visitors, dual-sector RAG) consuming the envelope you recover after that strip.
<span style="display:none">[^17_10][^17_11][^17_12][^17_13][^17_14][^17_15][^17_8][^17_9]</span>

<div align="center">⁂</div>

[^17_1]: https://github.com/andstor/latex-math-parser

[^17_2]: https://www.glukhov.org/documentation-tools/markdown/converting-latex-to-markdown-tools-and-workflows/

[^17_3]: https://myst-parser.readthedocs.io/en/latest/syntax/math.html

[^17_4]: https://www.underleaf.ai/tools/latex-to-markdown

[^17_5]: https://stackoverflow.com/questions/4818133/latex-math-parsing-for-c-c

[^17_6]: https://www.youtube.com/watch?v=8eM6jMKBLqY

[^17_7]: https://tex.stackexchange.com/questions/341899/latex-to-markdown-converter

[^17_8]: https://teachbooks.io/manual/helper_code/converter.html

[^17_9]: https://www.youtube.com/watch?v=-0hi3zFH4iM

[^17_10]: https://md-to.com/latex-to-markdown/

[^17_11]: https://www.youtube.com/watch?v=P10nK-AUX-8

[^17_12]: https://www.youtube.com/watch?v=bCumVPGR4ts

[^17_13]: https://www.hometalk.com/diy/paint/furniture/q-what-is-the-best-way-to-remove-latex-paint-from-wooden-furniture-1651581

[^17_14]: https://willhoffer.com/2020-03-01/converting-latex-into-markdown/

[^17_15]: https://mathlive.io/compute-engine/guides/latex-syntax/


---

# yea a key distinction is pure typesetting vs encoded notation. superscripts and subscripts aren't just typography, they encode mathematical semantics

Yes. That cut is the spine of the substance/furniture split.

## Typesetting vs encoded notation

|  | Pure typesetting (furniture) | Encoded notation (substance) |
| :-- | :-- | :-- |
| Role | How it looks on the page | What mathematical structure is meant |
| Examples | `\quad`, `\displaystyle`, stretchy `\left`, phantom, color-for-style, manual kerning | Superscripts/subscripts, fractions, radicals, fences-as-grouping, operators, scripts on tensors |
| Fate under $\pi$ | Evidence → then **strip** | **Keep** as MathDig structure |
| If you drop it | Layout changes; meaning intact | Meaning is destroyed or ambiguous |

Superscripts and subscripts are the textbook case: they are not “smaller glyphs shoved up.” In the math channel they are **script attachment**—a base plus script children—the same idea MathML encodes with `msub` / `msup` / `msubsup` / `mmultiscripts` as layout *schemata* that still carry expression structure, not mere font tweaks.[^18_1][^18_2][^18_3]

So in TeX source:

- `x^2` / `x_i` / `x_i^j` → **substance** → MathDig `Superscript` / `Subscript` / `SubSup` nodes
- `x^{\displaystyle 2}` → substance = script of `2`; `\displaystyle` = **furniture** on that script
- `x^2\quad` → substance = `x^2`; `\quad` = furniture

The visual consequence (raised, smaller) is how notation is *rendered*; the IR identity is the **script relation**.

## Why this matters for your normalizer

A furniture stripper that naïvely “flattens typography” must **not** flatten scripts into linear text or into generic “style spans.” That would smash:

- exponents vs indices vs contravariant/covariant slots
- $a_{ij}$ vs $a_{i}j$ (grouping is semantic)
- primes and parenthesized exponents
- tensor multi-scripts (`\mmultiscripts`-class structure)[^18_1]

Conversely, script *shift amounts* (`subscriptshift`-like tweaks), forced `\scriptstyle`, and decorative spacing around scripts are furniture: use them if needed to recover grouping, then drop them from the invariant stream.[^18_4]

**Rule of thumb for the math channel:**

> If removing it can change the mathematical parse (different MathDig tree or different KaTeX-stable atom graph), it is encoded notation.
> If removing it only changes spacing, size level, or decoration while the same MathDig tree remains, it is typesetting furniture.

Scripts fail the second test: remove the script relation and you no longer have the same object.

## Boundary cases (encode explicitly)

| Construct | Lean | Notes |
| :-- | :-- | :-- |
| `x^2`, `x_i`, `R^\mu{}_\nu` | **Notation** | Always MathDig script nodes |
| `\prime`, `f'` | **Notation** | Prime-as-script or prime atom—pick a canonical IR |
| `\overline{x}`, `\hat{x}` | **Notation** (accents) | Accents are semantic diacritics in math, not prose bold |
| `\mathrm{d}x` vs $dx$ | **Notation** + policy | Upright d may be semantic (operator); normalize per lexicon |
| `\mathbf{v}` vs bold face for emphasis only | Often **notation** (type) | Alphabet/type is usually substance in math |
| `\text{if}` inside math | Borderline | Prose island in math span—stream tag or MathDig text atom |
| `\quad`, `\hspace`, `\phantom` | **Furniture** | Strip after structure fixed |
| `\displaystyle` in display | **Furniture** | Default of environment; strip |
| Align `&`, `\\` | **Mixed** | Column/row structure = notation; extra spacing columns = furniture |

## MathDig consequence

MathDig should treat scripts as **first-class constructors**, parallel to presentation MathML schemata—not as CSS-like properties on tokens:[^18_5][^18_1]

```text
ScriptNode
  base: MathDig
  sub:  Option[MathDig]
  sup:  Option[MathDig]
  // or multiscripts: pre/post sub-sup pairs
```

Normalization:

1. Parse LaTeX `_` / `^` / `\sb` / `\sp` / `\sideset` / … into these nodes.
2. Apply furniture only to resolve ambiguity (e.g. what the base of the script is).
3. Emit KaTeX-stable form (`x_{i}^{j}` policy, brace normalization).
4. Strip pure typesetting; **never** strip the script spine.

## One-line distinction for the pipeline

> **Furniture** = pure typesetting (discardable presentation).
> **Encoded notation** = structure that *is* the math (including superscripts, subscripts, and other script schemata).
> The invariant math stream is exactly the encoded-notation projection—lexically KaTeX-stable, structurally MathDig—after furniture has been used as evidence and removed.

That is the key filter for “render to standard, then strip furniture” without murdering meaning.
<span style="display:none">[^18_10][^18_11][^18_12][^18_13][^18_14][^18_15][^18_6][^18_7][^18_8][^18_9]</span>

<div align="center">⁂</div>

[^18_1]: https://www.w3.org/TR/MathML3/chapter3.html

[^18_2]: https://www.data2type.de/en/xml-xslt-xslfo/math-ml/presentation-markup/scripts-and-limits/subscripts-superscripts

[^18_3]: https://www.xmlmind.com/tutorials/MathML/

[^18_4]: https://w3c.github.io/mathml-core/

[^18_5]: https://mdn2.netlify.app/en-us/docs/web/mathml/element/

[^18_6]: https://tex.stackexchange.com/questions/58098/what-are-all-the-font-styles-i-can-use-in-math-mode

[^18_7]: https://lwn.net/Articles/662053/

[^18_8]: https://www.overleaf.com/learn/latex/Mathematical_fonts

[^18_9]: https://developer.mozilla.org/en-US/docs/Web/MathML/Reference/Element/msubsup

[^18_10]: https://www.tug.org/TUGboat/tb31-1/tb97dhawan.pdf

[^18_11]: https://typedrawers.com/discussion/4767/design-differences-between-text-font-and-math-font

[^18_12]: https://ctan.math.utah.edu/ctan/tex-archive/macros/latex/contrib/mathastext/mathastext.pdf

[^18_13]: https://www.uark.edu/ua/pirelli/testing/MathML/mathml-tutorial.pdf

[^18_14]: https://www.reddit.com/r/LaTeX/comments/mqc211/latex_for_not_mathrelated_writing/

[^18_15]: https://www.daisy.org/z3986/structure/SG-DAISY3/part2-math.html


---

# and one of the most fun parts is needing to do this over different iterations of latex standards, author-specific idiosyncracies, mapping glyphs to lexical control sequences, coalescing alternatives to the preferred standard in the output after extracting and using evidence where needed like operatorname -> mathrm

Yes. That layer is a **many-to-one lexical coalescer** on top of parse-and-strip: heterogeneous LaTeX eras, packages, engines, and author macros all land on one **preferred KaTeX-stable lexicon**, using evidence when the map is not purely syntactic.

## The coalescing problem

$$
\{\text{legacy TeX},\ \text{LaTeX2e},\ \text{AMS},\ \text{unicode-math},\ \text{author macros},\ \text{raw glyphs}\}
\ \twoheadrightarrow\
\text{preferred control-sequence IR}
$$

Inputs that must collapse include:[^19_1][^19_2][^19_3]


| Input variety | Examples |
| :-- | :-- |
| **Standard generations** | Plain TeX `{\rm ...}` vs `\mathrm{}` vs Unicode math |
| **Package dialects** | amsmath `\operatorname` / `\DeclareMathOperator`, mathtools, physics, unicode-math |
| **Engine/glyph paths** | `\alpha` vs `α` (U+03B1) vs engine-specific mathcodes [^19_4][^19_3] |
| **Author macros** | `\newcommand{\R}{\mathbb{R}}`, `\eps` → `\varepsilon` vs `\epsilon` |
| **Alias sprawl** | `\le`/`\leq`, `\to`/`\rightarrow`, `\coloneqq`/`\mathrel{:=}` |
| **Operator encoding** | `\sin` vs `\operatorname{sin}` vs `\mathrm{sin}` vs `\text{sin}` |

Glyph → command is the dual of command → glyph: Detexify/Comprehensive Symbol List style inventories become a **lookup + disambiguation** table in your pipeline.[^19_5][^19_1]

## Preferred standard = policy, not aesthetics

Pick an explicit **canonical lexicon** (e.g. KaTeX-accepted amsmath-ish set + your MathDig constructors). Every coalesce rule is:

```text
evidence  +  source_form  →  preferred_form  |  residual_ambiguity
```

Your `\operatorname` → `\mathrm` example is a real policy choice, not a free identity: they are **not** equivalent. `\operatorname{xyz}` is Op-class (function-name spacing); `\mathrm{xyz}` is upright Ord (like a multi-letter variable).  So coalescing must be **evidence-directed**:[^19_6][^19_7]


| Evidence | Prefer |
| :-- | :-- |
| Known operator name, thin space before `(`, `\sin`-like use | keep/normalize to `\operatorname{...}` or built-in `\sin` |
| Multi-letter upright identifier, no Op spacing | `\mathrm{...}` |
| Author always wraps operators in `\mathrm` but spacing was faked with `\,` | furniture `\,` + `\mathrm` → evidence for `\operatorname` |
| Unit-like upright (e.g. $\mathrm{kg}$) | `\mathrm` or a units atom—not Op |

Same pattern for `\varepsilon` vs `\epsilon`, `\phi` vs `\varphi`: **do not** blindly merge; merge only under document-level or span-level evidence, or keep both if both appear contrastively.

## Pipeline stage: LexicalCoalescer

Sit it between furniture extraction and MathDig build:

```
LaTeX math tokens
    → expand author macros (deterministic where possible)
    → glyph → candidate CS (unicode-math / symbol tables)
    → alias normalize (le→leq policy, etc.)
    → operator/identity classify (sin/operatorname/mathrm/text)
    → script/frac/fence structure (substance)
    → furniture strip
    → preferred CS string + MathDig AST
```


### 1. Macro expansion (author idiosyncrasy)

- Expand `\newcommand` / `\def` when safe (non-fragile, non-conditional).
- Residual macros → evidence nodes (`UnresolvedMacro`) or a per-document **macro dialect table** learned from preamble.
- `\DeclareMathOperator{\Tr}{Tr}` → preferred `\operatorname{Tr}` or `\operatorname{Tr}`→built-in policy.


### 2. Glyph → control sequence

| Source | Map |
| :-- | :-- |
| Unicode math char | CS via unicode-math / KaTeX alias tables [^19_4][^19_3] |
| Engine slot / `\mathchar` | name if known; else private codepoint + flag |
| Multi-codepoint sequences | NFKC-ish math normalize, then lookup |

Output should prefer **named CS** in the IR (`\alpha` not raw `α`) so MarkPig math stays lexically stable and greppable for models—unless your surface policy is Unicode-math Markdown (then reverse the preferred pole, but keep one pole).

### 3. Alias coalesce (safe equivalences)

Hard equivalences (same MathDig atom):

- `\leq` / `\le`, `\geq` / `\ge`
- `\rightarrow` / `\to` (if you declare them identical)
- `\dots` / `\ldots` / `\cdots` — **careful**: these differ (baseline vs center); coalesce only with context evidence

Soft equivalences (need evidence):

- `\operatorname{log}` vs `\log`
- `\mathrm{d}` vs `\operatorname{d}` vs `d` for differentials
- `\mathbf` vs `\boldsymbol` vs `\bm`


### 4. Operator family (your fun case)

```text
forms:  \sin | \operatorname{sin} | \mathrm{sin} | \text{sin} | \rm sin
evidence:
  - atom spacing class (Op vs Ord vs Text)
  - following token (functorial `(` vs product)
  - preamble DeclareMathOperator
  - document-wide frequency of each encoding for same stem
decision:
  built-in Op  →  \sin
  unknown Op   →  \operatorname{stem}   (preferred modern form)
  upright Ord  →  \mathrm{stem}
  prose island →  \text{stem}  or demux to prose if outside math substance
```

Default **preferred standard** for true operators: `\operatorname` / built-ins, not `\mathrm`.  Use `\mathrm` when evidence says “upright identifier,” not “operator.” If your KaTeX/MathDig house style flips that, document it as policy—the machinery is the same.[^19_6]

## Multi-standard matrix (keep explicit)

| Era / stack | Typical noise | Coalesce toward |
| :-- | :-- | :-- |
| Plain / early LaTeX | `{\rm }`, `$$`, `\eqno` | `\mathrm`, `\[\]` / display math nodes, label edges |
| amsmath | `align`, `\operatorname`, `\text` | MathDig align + preferred Op/text |
| mathtools / physics | extra aliases, `\qty` | expand or map to core lexicon |
| unicode-math (Xe/Lua) | literal glyphs, `\symbf` | glyph→CS, then preferred CS [^19_2] |
| Author preamble | private ops, `\eps`, blackboard shortcuts | dialect table → preferred |

Version the coalescer: `coalesce_profile = amsmath+katex-2024` so outputs are reproducible.

## Evidence objects (again, but lexical)

```text
LexicalEvidence {
  raw: "\\mathrm{Tr}",
  glyph_form: null,
  spacing_class_observed: Ord,    // from parse
  contextual_use: "Tr(A)",        // Op-like application
  preamble_hint: DeclareMathOperator? false,
  doc_freq: { mathrm_Tr: 12, operatorname_Tr: 0 },
  decision: operatorname("Tr"),   // or keep mathrm + flag
  confidence: 0.82
}
```

Low confidence → keep residual + flag for human/model review; still emit *a* preferred form so the surjection stays total.

## MathDig / MarkPig output contract

After coalesce + strip:

- Math slots contain **only** preferred lexicon (one writing per atom family, per policy).
- MathDig nodes store structure (`Apply`, `Script`, `OperatorName("Tr")`) independent of source spelling.
- Optional `provenance` channel (side graph): source CS, package era, coalesce rule id—for debugging, not for model-facing MarkPig surface.
- Models read stable `$\\operatorname{Tr}$` (or your chosen pole), not a soup of `\rm`/`\mathrm`/`\operatorname`/Unicode lookalikes.


## Fun = systematic

The enjoyable hardness is that this is **compilation with a dialect lattice**:

1. Parse all eras into a common token/substance IR.
2. Attach furniture + lexical evidence.
3. Quotient by declared equivalences and evidence-backed rewrites.
4. Emit one preferred standard.
5. Strip pure typesetting.
6. Build MathDig + MarkPig envelope.

Scripts stay substance; `\quad` stays furniture; `\operatorname` vs `\mathrm` stays a **classified** coalesce with spacing evidence—not a blind string replace.[^19_6]

## One-liner for this layer

> Across LaTeX standards, glyphs, and author dialects, map every math span into a preferred KaTeX-stable lexicon by expanding macros, resolving glyphs to control sequences, and coalescing aliases under evidence (e.g. operator-spacing → `\operatorname` / built-ins, upright identifiers → `\mathrm`), then strip typesetting furniture so the math channel is lexically invariant before MathDig and MarkPig see it.

That is the right “fun part”: a versioned, evidence-aware **lexical quotient** onto your house standard, not a single regex pilgrimage through history.
<span style="display:none">[^19_10][^19_11][^19_12][^19_13][^19_14][^19_15][^19_8][^19_9]</span>

<div align="center">⁂</div>

[^19_1]: https://www.math.toronto.edu/mathit/symbols-letter.pdf

[^19_2]: https://texdoc.org/serve/unicode-math/0

[^19_3]: https://ftp.math.utah.edu/pub/texlive/Contents/live/texmf-dist/doc/latex/unicode-math/unicode-math.pdf

[^19_4]: https://ctan.math.washington.edu/tex-archive/macros/unicodetex/latex/unicode-math/unicode-math-code.pdf

[^19_5]: https://codesignal.com/learn/courses/writing-math-in-latex/lessons/common-mathematical-symbols

[^19_6]: https://tex.stackexchange.com/questions/48459/whats-the-difference-between-mathrm-and-operatorname

[^19_7]: https://legacy-www.math.harvard.edu/texman/node20.html

[^19_8]: https://tex.stackexchange.com/questions/208988/prime-gives-undefined-control-sequence-in-xelatex-with-unicode-math

[^19_9]: https://tex.stackexchange.com/questions/146950/making-aliases-for-variables

[^19_10]: https://docutils.sourceforge.io/docs/ref/rst/mathematics.html

[^19_11]: https://pascalmichaillat.org/e/

[^19_12]: https://mathlive.io/compute-engine/guides/latex-syntax/

[^19_13]: https://en.wikibooks.org/wiki/LaTeX/Mathematics

[^19_14]: https://www.math.uci.edu/~xiangwen/pdf/LaTeX-Math-Symbols.pdf

[^19_15]: http://ftp.cvut.cz/tex-archive/macros/latex/contrib/unicode-math-input/unicode-math-input.pdf


---

# operatorname is evidence but not math register output, it gets mapped to mathrm after any context from it is parsed as evidence and used to correctly formulate the output

Got it — that locks the house standard cleanly.

## Policy

| Form | Role in your pipeline |
| :-- | :-- |
| `\operatorname{...}` / `\DeclareMathOperator` / Op-class builtins used as evidence | **Evidence only** — not emitted in the math stream |
| `\mathrm{...}` | **Preferred math-register output** for upright multi-letter names |
| Built-ins like `\sin`, `\log` | Still coalesce per your lexicon (typically stay as named CS, or also fold to `\mathrm{sin}` if you want a single pole—your call) |

So:

```text
\operatorname{Tr}  +  spacing/use evidence  →  (parse Op intent)  →  emit  \mathrm{Tr}
\mathrm{Tr}        +  optional evidence     →  emit  \mathrm{Tr}
```

`\operatorname` never appears in MarkPig math slots or in the lexically invariant register. It is consumed and discarded like other furniture once its context has been used.[^20_1]

## What evidence you still take from it

Before mapping to `\mathrm`, record what `\operatorname` told you:

- **Upright stem** — the name string (`Tr`, `Spec`, `sinc`, …)
- **Op-class use** — function-name behavior in the source (application spacing, limits via `\operatorname*`, etc.)[^20_2][^20_1]
- **Structure** — this span is an operator-like atom, not a product of italic letters

That evidence feeds MathDig (e.g. node kind `UprightName` / `OperatorApply` vs plain `Ord`), even though the **lexical surface** is `\mathrm{...}`.

Critical point: source Op spacing must not be forgotten when the CS becomes `\mathrm`. Either:

1. **MathDig carries atom class** (`Op` vs `Ord`) independently of the emitted CS, and KaTeX/render path uses that, or
2. You **re-encode spacing in the stream** only when needed (usually MathDig is enough and the surface stays pure `\mathrm`).

If you only rewrite strings `\operatorname{Tr}` → `\mathrm{Tr}` with no atom-class side channel, you drop the spacing semantics that made `\operatorname` meaningful.  Evidence → MathDig structural class; lexicon → `\mathrm`.[^20_2][^20_1]

## Coalesce rule (revised)

```text
on Operatorname(stem) | DeclareMathOperator(stem) | op-like \mathrm(stem):
  evidence.atom_class = Op          # or Ord if context says identifier
  evidence.stem = stem
  evidence.limits = * or not

  math_register_emit = "\\mathrm{" + stem + "}"
  mathdig = UprightName(stem, class=evidence.atom_class, ...)

  # \operatorname itself is not in math_register_emit
```

Same for author macros that expand to `\operatorname`.

## Register vs evidence (one line)

> **Math register (output):** KaTeX-stable lexicon with `\mathrm` as the upright-name pole.
> **`\operatorname`:** parse-time evidence for stem + Op-class intent; stripped from output after MathDig is formulated.

That matches “furniture/evidence vs encoded notation”: Op-ness can stay as **encoded structure in MathDig**; `\operatorname` as a control sequence does not stay as **encoded lexicon in the stream**.
<span style="display:none">[^20_10][^20_11][^20_12][^20_13][^20_14][^20_15][^20_16][^20_3][^20_4][^20_5][^20_6][^20_7][^20_8][^20_9]</span>

<div align="center">⁂</div>

[^20_1]: https://tex.stackexchange.com/questions/48459/whats-the-difference-between-mathrm-and-operatorname

[^20_2]: https://planetmath.org/planetmathcontentandstyleguide1

[^20_3]: https://tex.stackexchange.com/questions/461537/further-questions-about-mathrm-and-operatorname-spacing-after-colon

[^20_4]: https://katex.org/docs/supported.html

[^20_5]: https://github.com/sympy/sympy/issues/15934

[^20_6]: https://katex.org/docs/support_table

[^20_7]: https://www.overleaf.com/learn/latex/Spacing_in_math_mode

[^20_8]: https://github.com/Khan/KaTeX/wiki/Function-Support-in-KaTeX/bcecb26cc89adc85046e2114f815a92f4c976574

[^20_9]: https://www.reddit.com/r/LaTeX/comments/puq2bu/spacing_in_math_mode/

[^20_10]: https://katex.org/docs/options

[^20_11]: https://tex.stackexchange.com/questions/671/define-additional-math-operators-to-be-typeset-in-roman

[^20_12]: https://freshrimpsushi.github.io/en/posts/3175/

[^20_13]: https://courses.dwf.dev/docs/reference/docusaurus/katex

[^20_14]: https://tex.stackexchange.com/questions/linked/22350?lq=1

[^20_15]: https://www.netpad.net.cn/helpBook/latex/Supported Functions · KaTeX.htm

[^20_16]: https://legacy-www.math.harvard.edu/texman/node20.html


---

# macros get expanded and converted into flat correctly bounded and delimited blocks of valid katex and faithful expression of the math

Yes. That is the **emission contract** for the math stream: macros are not preserved as dialect; they are **expanded away** into flat, well-bounded, KaTeX-valid blocks that faithfully express the same mathematics.[^21_1][^21_2]

## Emission contract

After evidence extraction and coalesce:


| Requirement | Meaning |
| :-- | :-- |
| **Expanded** | `\newcommand` / `\def` / `\DeclareMathOperator` / author shorthands inlined; no private macro dependence in output [^21_1][^21_3] |
| **Flat** | No nested custom wrappers; only KaTeX-legal control sequences and structure (`\frac`, scripts, `\mathrm`, …) |
| **Correctly bounded** | Grouping braces match; script bases explicit; delimiter pairs balanced; align/body extents well-formed |
| **Correctly delimited** | Each math slot is a clean inline or display unit (`$…$` / `$…$` or your MarkPig delimiters)—no leaked mode, no half-expanded tokens |
| **Valid KaTeX** | Parses under your KaTeX profile with no undefined CS [^21_4][^21_2] |
| **Faithful** | Same MathDig meaning as the source substance (scripts, ops, structure)—not a cosmetic lookalike |

Macros are a **source-era encoding**. The math register is **post-expansion IR**.

## Pipeline slice

```
source math span
  → lex/parse (LaTeX-aware)
  → expand macros (preamble + local; bounded expansion depth)  [web:343]
  → furniture evidence + strip
  → lexical coalesce (\operatorname → evidence → \mathrm, aliases, glyphs→CS)
  → re-bound & re-delimit
  → validate KaTeX
  → emit flat block into MarkPig math slot
  → MathDig parse of that block (authoritative structure)
```

Expansion must be **argument-correct** (TeX-style token arguments, not naive string splice), or faithfulness breaks on `\frac\foo\foo`-class cases.[^21_5]

## Flat + bounded (what “flat” does *not* mean)

**Flat** ≠ destroy fractions/scripts. It means:

- no `\MyOp{...}` left behind
- no package-only CS
- structure expressed with **core KaTeX constructors** only

Still nested as math requires:

```tex
\mathrm{Tr}\left(\frac{A_{i}^{j}}{2}\right)
```

Not flattened to a linear token salad. **Lexically flat** (no macro layer); **structurally faithful** (MathDig tree intact).

**Bounded** = every subexpression’s extent is explicit after expansion:

- script bases braced when needed (`x^{2}` not ambiguous residue)
- `\mathrm{Tr}` applied to a clear stem group
- delimiters paired; empty scripts normalized
- display vs inline slot boundaries fixed before serialize


## Faithfulness checklist

Expansion + coalesce is faithful when:

1. MathDig(before conceptual substance) ≅ MathDig(after KaTeX emit)
2. No residual undefined CS under KaTeX
3. Op/Ord intent preserved in MathDig even when lexicon is `\mathrm`
4. Labels/refs lifted to graph edges, not left as macro side effects
5. Furniture gone; encoded notation (scripts, fracs, …) kept

## MarkPig surface

Each math node’s payload is exactly one such block:

- inline slot → one valid KaTeX string, delimited by MarkPig inline math
- display slot → one valid KaTeX string, delimited by MarkPig display math
- multi-line align → either one KaTeX-valid aligned block or MathDig-first with a defined serialize ruleset—but still **no unexpanded macros**

Models and humans see portable KaTeX; MathDig sees the same bytes (or the AST built from them).

## One-liner

> Macros are expanded fully into flat, correctly grouped and delimited KaTeX-valid blocks that faithfully express the math; the math register contains only that post-expansion lexicon (e.g. upright names as `\mathrm`), never source macros or evidence-only forms like `\operatorname`.
<span style="display:none">[^21_10][^21_11][^21_12][^21_13][^21_14][^21_15][^21_6][^21_7][^21_8][^21_9]</span>

<div align="center">⁂</div>

[^21_1]: https://tex.stackexchange.com/questions/152651/flatten-macros-prior-to-sharing-latex-file

[^21_2]: https://katex.org/docs/cli

[^21_3]: https://www.math.uh.edu/~torok/math_6298/latex/macros.html

[^21_4]: https://katex.org/docs/supported.html

[^21_5]: https://katex.org/docs/migration

[^21_6]: https://github.com/KaTeX/KaTeX/issues/250

[^21_7]: https://www.overleaf.com/learn/latex/How_TeX_macros_actually_work:_Part_6

[^21_8]: https://docs.adaptavist.com/cfm4cs/current/mosaic-macros/latex-formatting

[^21_9]: https://katex.org/docs/options

[^21_10]: https://www.alibabacloud.com/help/en/pai/user-guide/llm-extended-latex-macro

[^21_11]: https://courses.dwf.dev/docs/reference/docusaurus/katex

[^21_12]: https://haroldpboas.gitlab.io/courses/math696/LaTeX-introduction-to-macros.html

[^21_13]: https://tex.stackexchange.com/questions/3174/latex-macro-expander

[^21_14]: https://appfire.atlassian.net/wiki/spaces/LM/pages/77038704/How+to+convert+third-party+LaTeX+Math+macros+Data+center+to+LaTeX+Math+macros+cloud

[^21_15]: https://vincenttam.gitlab.io/post/2018-09-27-custom-katex-macros/

