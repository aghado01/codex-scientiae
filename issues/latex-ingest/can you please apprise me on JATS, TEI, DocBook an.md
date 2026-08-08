<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# can you please apprise me on JATS, TEI, DocBook and DITA. I want to get a feel for their schemas

**JATS, TEI, DocBook, and DITA** are all mature XML vocabularies for structured documents, but they optimize for different domains and extension styles. Below is a concise schema-oriented feel for each, plus a side-by-side comparison.

## JATS (Journal Article Tag Suite)

**Purpose:** Scholarly journal articles (STM publishing, archiving, interchange). NISO/ANSI standard (Z39.96); current version 1.4 (2024). Descended from NLM DTDs used by PubMed Central.[^1_1]

**Schema shape:** Three nested tag sets (same root, different strictness):

- **Archiving (Green)** — most permissive (legacy capture)
- **Publishing (Blue)** — production default (subset of Archiving)
- **Authoring (Orange)** — tightest, for new content (subset of Publishing)

Schemas ship as DTD, RELAX NG, and XSD; incorporate MathML and XHTML-style tables.[^1_1]

**Document model (content expression):**

```text
(front, body?, back?, floats-group?, (sub-article* | response*))
```

**Root and major sections:**


| Layer | Role | Typical children |
| :-- | :-- | :-- |
| `article` | Root | `front`, optional `body`/`back` |
| `front` | Required metadata | `journal-meta`, `article-meta` (title, contribs, abstract, pub-date, permissions…) |
| `body` | Narrative | `sec`, `p`, `fig`, `table-wrap`, `disp-formula`… |
| `back` | Ancillary | `ref-list`, `app-group`, `glossary`, `ack` |
| `floats-group` | Optional out-of-flow | figures/tables pulled aside |

**Schema feel:** Hierarchical article container with rich bibliographic/metadata front matter. Very element-dense around citations, affiliations, funding, and display objects; relatively free-form body sections. Related: **BITS** (Book Interchange Tag Suite) reuses the same module suite for books/chapters.[^1_2][^1_3][^1_1]

Minimal skeleton:

```xml
<article dtd-version="1.4" xmlns:mml="http://www.w3.org/1998/Math/MathML">
  <front>
    <journal-meta>...</journal-meta>
    <article-meta>
      <title-group><article-title>...</article-title></title-group>
      <contrib-group>...</contrib-group>
      <abstract>...</abstract>
    </article-meta>
  </front>
  <body><sec><title>...</title><p>...</p></sec></body>
  <back><ref-list>...</ref-list></back>
</article>
```


***

## TEI (Text Encoding Initiative)

**Purpose:** Machine-actionable representation of cultural-heritage and literary texts (digital humanities). Maintained by the TEI Consortium; Guidelines P5 (ongoing).[^1_4]

**Schema shape:** Not a single fixed DTD. The full Guidelines define **500+ elements**. Real projects use **ODD** (“One Document Does it all”) — a literate-programming customization that generates DTD / RELAX NG / XSD plus documentation. Common starter: **TEI Lite**.

**Core document skeleton:**

```xml
<TEI xmlns="http://www.tei-c.org/ns/1.0">
  <teiHeader><!-- required bibliographic + encodingDesc --></teiHeader>
  <text>
    <front>...</front>
    <body>...</body>
    <back>...</back>
  </text>
</TEI>
```

**Schema feel:** Extremely modular and interpretive. You pick modules (core, textstructure, linking, analysis, verse, drama, namesdates, msdescription, genetic editing, etc.) and constrain them via ODD. Markup can go to arbitrary depth (clause, word, glyph, person, damage with agent/degree). Overlapping hierarchies are a known hard problem; the Guidelines offer several workarounds.

Illustrative depth (prose + choice):

```xml
<p>
  <s>
    <cl>It was about the beginning of September, 1664...</cl>
  </s>
</p>
<choice>
  <sic>1724</sic><corr>1728</corr>
</choice>
```

**Customization style:** ODD = documentation + content models + Schematron in one source; tools (Roma, etc.) emit the concrete schema you validate against.

***

## DocBook

**Purpose:** Semantic technical documentation (books, manuals, articles) — originally hardware/software, now general. OASIS standard; current **5.2** (2024). Normative schema is **RELAX NG + Schematron** (DTD/XSD derived).[^1_5][^1_6]

**Schema shape:** Single large vocabulary with three layers:

1. **Structural** — only legal roots: `set`, `book`, `part`, `article`, `chapter`, `appendix`…
2. **Block** — `para`, lists, `table`, `figure`, `programlisting`, `equation`…
3. **Inline** — `emphasis`, `link`, `code`, `guibutton`, `filename`…

Namespace: `http://docbook.org/ns/docbook`. Root must carry `version`.[^1_6]

**Hierarchy feel:**

```text
set → book → part → chapter → section* → (block | section)*
```

Sample:

```xml
<book xmlns="http://docbook.org/ns/docbook" version="5.2" xml:id="simple_book">
  <title>Very simple book</title>
  <chapter xml:id="chapter_1">
    <title>Chapter 1</title>
    <para>Hello world!</para>
    <para>I hope your day is proceeding <emphasis>splendidly</emphasis>!</para>
  </chapter>
</book>
```

**Schema feel:** Book-centric, presentation-neutral, “narrative assembly.” Large but relatively flat element set; customization is possible but heavier than DITA specialization (historically via subsetting / profiling). Processing ecosystem centers on DocBook XSL (HTML, PDF/FO, man, WebHelp, EPUB). Simplified DocBook exists for single articles.[^1_5][^1_6]

***

## DITA (Darwin Information Typing Architecture)

**Purpose:** Topic-oriented technical information for reuse, multi-channel delivery, and specialization. OASIS standard (1.3 widely deployed; later versions exist). Born at IBM.[^1_7][^1_8]

**Schema shape:** Architecture of **modules** assembled into document-type shells, not one monolithic DTD.

- Base: `topic`
- Core specializations: `concept`, `task`, `reference`, `glossary entry`, troubleshooting…
- Maps: `map` / `bookmap` assemble topics into deliverables
- Domains: UI, programming, software, highlighting, indexing… mixed into topics
- Extensibility: **specialization** (inheritance of processing) + **constraints** + **conref** (content reference) + keys/indirect linking[^1_9][^1_8][^1_10]

**Topic anatomy (generic):**

```xml
<topic id="install" xml:lang="en">
  <title>Installing the widget</title>
  <shortdesc>...</shortdesc>
  <prolog><!-- metadata, resourceids --></prolog>
  <body>
    <p>...</p>
    <section><title>...</title>...</section>
  </body>
  <related-links>...</related-links>
</topic>
```

Task specialization tightens body to something like:

```text
(prereq?, context?, steps, result?, postreq?)
```

**Schema feel:** Discrete, typed, reusable topics + assembly maps. Complexity lives in the content model and architecture (specialization hierarchy, keys, conref, relationship tables) rather than in a single giant book tree. Shells recombine modules; new types inherit base processing.[^1_8][^1_7][^1_9]

***

## Side-by-side schema comparison

| Dimension | JATS | TEI | DocBook | DITA |
| :-- | :-- | :-- | :-- | :-- |
| **Primary unit** | Journal `article` | Encoded `text` (any genre) | `book` / `article` | Typed `topic` + `map` |
| **Domain** | STM publishing/archiving | Digital humanities / literary texts | Technical books \& manuals | Reusable tech info products |
| **Normative schema** | DTD + RNG + XSD (3 tag sets) | ODD → RNG/DTD/XSD | RNG + Schematron (5.x) | Modular DTD/RNG/XSD shells |
| **Extensibility** | Tag-set subsets; related BITS | ODD customization (first-class) | Subsetting / profiling | Specialization + constraints (core design) |
| **Hierarchy style** | front/body/back article | teiHeader + text (deep analytic markup) | Nested structural containers | Flat topics composed by maps |
| **Reuse model** | Sub-articles, XInclude-ish practice | Pointers, stand-off, shared header | XInclude, profiling | conref, keys, maps, relationship tables |
| **Metadata weight** | Very high (journal/article-meta) | Very high (`teiHeader`) | Moderate (`info`) | Moderate–high (`prolog`, map metadata) |
| **Element count feel** | Large, domain-specific | Huge optional inventory | Large fixed vocabulary | Moderate base; grows via domains |
| **Typical root** | `article` | `TEI` | `book` / `article` | `topic` / `concept` / `task` / `map` |


***

## How the schemas “feel” in practice

- **JATS** — “I am a scholarly article with a mandatory metadata head.” Validation is about bibliographic completeness and float/section structure; body prose is comparatively loose. Ideal when the interchange unit is the published paper.[^1_3][^1_1]
- **TEI** — “I am a scholarly encoding of a text, possibly with multiple interpretive layers.” You almost never use the full vocabulary; ODD defines *your* TEI. Best when analysis (verse, manuscript description, linguistic annotation) matters as much as delivery.
- **DocBook** — “I am writing a book/manual as a coherent hierarchical document.” One big semantic tree; transforms decide presentation. Familiar if you think in chapters and sections.[^1_6]
- **DITA** — “I am writing typed, reusable topics that maps will assemble.” The schema actively steers information types (task steps vs. concept explanation) and pushes reuse into the architecture.[^1_7][^1_8]

***

## Quick orientation for a CS/ML researcher

- **Paper archive / journal pipeline** → JATS (and BITS if books).
- **Corpus, edition, or annotated primary source** → TEI (+ ODD).
- **Long-form manual or API book as one narrative** → DocBook.
- **Componentized product docs with heavy reuse / multi-product variants** → DITA.

If you want to go deeper next, the highest-leverage artifacts are: JATS Publishing Tag Library, TEI P5 Guidelines + a sample ODD, DocBook TDG 5.2 element reference, and the DITA 1.3 architectural spec (specialization and map sections). I can also walk a minimal valid instance side-by-side for a single technical paper or a short manual chapter if that would help lock in the differences.
<span style="display:none">[^1_11][^1_12][^1_13][^1_14][^1_15][^1_16][^1_17][^1_18][^1_19][^1_20][^1_21][^1_22][^1_23][^1_24][^1_25][^1_26][^1_27][^1_28][^1_29][^1_30]</span>

<div align="center">⁂</div>

[^1_1]: https://en.wikipedia.org/wiki/Journal_Article_Tag_Suite

[^1_2]: https://jats.nlm.nih.gov/extensions/bits/

[^1_3]: https://mystmd.org/guide/creating-jats-xml

[^1_4]: https://tei-c.org/

[^1_5]: https://tdg.docbook.org/tdg/5.2/ch02.html

[^1_6]: https://en.wikipedia.org/wiki/DocBook

[^1_7]: https://www.oxygenxml.com/doc/ug-editor/topics/author-dita-doc-type.html

[^1_8]: https://www.oasis-open.org/committees/dita/faq.php

[^1_9]: https://docs.oasis-open.org/dita/v1.2/cd03/spec/archSpec/schemaorganization.html

[^1_10]: https://www.oxygenxml.com/dita/1.3/specs/

[^1_11]: http://drmacros-xml-rants.blogspot.com/2016/01/some-dita-and-docbook-history-common.html

[^1_12]: https://www.oxygenxml.com/forum/xml-schemas/topic17199.html

[^1_13]: http://drmacros-xml-rants.blogspot.com/2008/04/choosing-xml-schema-docbook-or-dita.html

[^1_14]: https://www.linkedin.com/pulse/dita-vs-docbook-xml-based-documentation

[^1_15]: https://www.madcapsoftware.com/blog/embracing-dita-superior-choice-for-structured-authoring/

[^1_16]: https://norman.walsh.name/2005/10/21/dita

[^1_17]: https://idratherbewriting.com/trends/trends-to-follow-or-forget-dita.html

[^1_18]: https://paligo.net/blog/technical-writing/docbook-vs-dita/

[^1_19]: https://www.reddit.com/r/technicalwriting/comments/1ntwiy3/anybody_using_a_ditacentric_writingauthoring_tool/

[^1_20]: https://www.youtube.com/watch?v=0BBhiAkBVUA

[^1_21]: https://dita-users.groups.io/g/main/topic/docbook_vs_dita_course_101/48658900?dir=desc

[^1_22]: https://demo.oberontech.com/oxygen18.1/viewer/58123c90b3fbe80001821122/58126439b3fbe800018387b5/r/author-jats-doc-type

[^1_23]: https://lib.guides.umd.edu/DH/textencoding

[^1_24]: https://guides.library.illinois.edu/xml/tei

[^1_25]: https://schemas.liquid-technologies.com/DocBooks/5.0/task.html

[^1_26]: https://people.cs.vt.edu/~kafura/CS6604/Papers/Darwin-Information-Typing-Architecture.pdf

[^1_27]: http://www.niso.org/standards-committees/jats

[^1_28]: https://jats.taylorandfrancis.com/

[^1_29]: https://infoguides.pepperdine.edu/c.php?g=379213\&p=2568007

[^1_30]: https://www.oxygenxml.com/forum/xml-schemas/topic6319.html


---

# is there equivalent formalizations for different latex standards in XML for comparison? arvix by different generations for example

**Short answer:** There is **no** family of official XML schemas that stand in a 1:1 relationship to “LaTeX standards by generation” the way JATS/TEI/DocBook/DITA do for their domains. What exists instead is a **conversion stack** whose intermediate model is LaTeX-shaped XML, plus a few **semantic overlays**. arXiv’s “generations” are **TeX Live runtimes**, not schema versions.[^2_1][^2_2][^2_3]

## Why LaTeX doesn’t have JATS-style generations

LaTeX is defined by a **macro language + engine behavior** (pdfTeX/XeTeX/LuaTeX + a huge package ecosystem), not by a closed content model. There is no normative element inventory for “LaTeX 2ε 2015” vs “LaTeX 2ε 2025” comparable to JATS 1.1 vs 1.4.[^2_4][^2_5]

What people *do* version:

- **Format/kernel** — LaTeX2ε (ongoing); ancient LaTeX 2.09
- **Engines** — pdfTeX, XeTeX, LuaTeX
- **Distributions** — TeX Live year snapshots (what arXiv pins)
- **Document classes / publisher styles** — `article`, `amsart`, `revtex4-2`, `IEEEtran`, `acmart`, etc.
- **Package contracts** — `hyperref`, `amsmath`, `biblatex`, …

None of those ship as a stable, generationed XML schema suite.

***

## Closest XML formalizations

### 1. LaTeXML intermediate XML (the real “LaTeX-as-XML”)

**LaTeXML** (NIST) is the practical formalization: it emulates TeX/LaTeX and emits an XML tree modelled on LaTeX’s document structure (inspired by HTML, MathML, OpenMath). That intermediate XML is then XSLT’d to HTML5+MathML, JATS, TEI, EPUB, etc.[^2_2][^2_1]

```text
.tex  →  LaTeXML core  →  LaTeXML XML (schema-constrained)
                      →  post-process → HTML | JATS | TEI | EPUB | …
```

- Schema is **RELAX NG**-based; bindings/customization can declare `RelaxNGSchema(...)`.[^2_6]
- Element feel is LaTeX-native: document, sectioning, `para`, `equation`, `toc`, theorem-like environments, floats, bibliography — closer to a **semantic parse of LaTeX** than to DocBook’s book model or JATS’s journal front matter.[^2_1]
- Math becomes MathML (and related); structure aims to preserve author intent, not just visual layout.[^2_7]

This is the best single answer to “what does LaTeX look like as XML?” — but it is **one evolving converter model**, not a multi-generation standard family like JATS Green/Blue/Orange.

### 2. Target schemas after conversion (not LaTeX itself)

| Target | Role vs LaTeX | Notes |
| :-- | :-- | :-- |
| **HTML5 + MathML** | arXiv “HTML papers” / ar5iv | What readers see; LaTeXML post-process [^2_8][^2_9] |
| **JATS** | Journal production/archive | Common publisher path from LaTeX [^2_2][^2_10] |
| **TEI** | DH / alternate scholarly XML | Supported LaTeXML output [^2_2] |
| **EPUB** | Ebook packaging | LaTeXML post-process [^2_2] |

So for comparison tables against JATS/TEI/DocBook/DITA, the usual move is: **LaTeX → LaTeXML XML → JATS/TEI**, not “LaTeX schema vN.”

### 3. Semantic LaTeX → OMDoc (formal math layer)

**sTeX** (semantic TeX) extends LaTeX with explicit markup for definitions, notations, theories, etc., and LaTeXML can produce **OMDoc** (Open Mathematical Documents) XML — a real formal content model for mathematical knowledge, not just typesetting.[^2_11][^2_12]

That pair is the closest thing to a **rigorous** dual of “LaTeX for PDF + XML for semantics,” but it is a research/toolchain choice, not arXiv’s default authoring dialect.

### 4. Other tools (less “standard”)

- **Pandoc**, **tex4ht/make4ht**, **Tralics**, **plasTeX** — each has its own internal or HTML-ish model; none is a multi-decade, generationed LaTeX schema standard.[^2_13][^2_14]
- Publisher pipelines often go LaTeX → proprietary XML → JATS.[^2_10]

***

## arXiv “generations” — runtimes, not schemas

arXiv does **not** maintain separate XML DTDs per era. It pins **TeX Live** (plus local add-ons) and, for HTML, runs **LaTeXML** on successful TeX sources.[^2_3][^2_8]

### TeX Live lineage at arXiv (approximate eras)

| Era | Stack (high level) | Notes |
| :-- | :-- | :-- |
| Pre-~2010 | teTeX-based | Aging; replaced [^2_3] |
| ~2010 | TeX Live **2009** | Major modernization [^2_3] |
| ~2011+ | TL **2011** (and later bumps) | Documented in arXiv TeX FAQ lineage [^2_3] |
| ~2016–2020 | TL **2016** | Long-lived baseline before TL2020 [^2_15] |
| 2020-10 | TL **2020** | Major upgrade from TL2016 [^2_15] |
| 2023-05 | TL **2023** | Default for a period; still offered [^2_16][^2_3] |
| 2025+ | TL **2025** (default) + TL **2023** selectable | Current dual support [^2_3][^2_17] |

“Generation” differences that matter in practice:

- Package/kernel behavior changes (breaking sources that compiled last era)
- Engine/feature availability
- Font and Unicode handling
- Which local arXiv add-ons ship

They do **not** map to distinct XML schemas. A 2011 paper and a 2026 paper both become “LaTeXML XML → HTML/JATS-shaped output” if conversion succeeds; failures are package-binding / TeX-emulation gaps, not schema-version mismatches.[^2_18][^2_19][^2_8]

### arXiv HTML path (2023–)

- Experimental → production **HTML papers** via LaTeXML on new TeX submissions.[^2_8]
- **ar5iv** popularized the same idea earlier as a lab/service.[^2_9]
- Author guidance is “use LaTeXML-supported packages / best practices,” not “conform to arXiv-XML-v2.”[^2_19]

***

## Conceptual mapping (for comparison with JATS/TEI/DocBook/DITA)

| Layer | JATS / TEI / DocBook / DITA | LaTeX world |
| :-- | :-- | :-- |
| Normative content model | Yes (DTD/RNG/XSD, versioned) | No single model |
| “Generations” | Schema versions (e.g. JATS 1.x tag sets) | TeX Live years, kernel updates, class/package versions |
| Canonical XML | The standard *is* the XML | **LaTeXML XML** is a *derived* model |
| Interchange unit | `article` / `TEI` / `book` / `topic` | `.tex` + assets; PDF is still primary archival deliverable on arXiv |
| Semantic extension | Built into schema (TEI ODD, DITA specialization) | Optional: sTeX→OMDoc, theorem packages, etc. |
| Publisher handoff | Native XML | Usually convert → **JATS** (or house XML) [^2_10] |


***

## Practical takeaway

- **For schema comparison with JATS/TEI/DocBook/DITA:** treat **LaTeXML’s RELAX NG document model** as “LaTeX-in-XML,” and treat **JATS/TEI** as the *interchange* forms you get after post-processing — not as generational LaTeX standards.[^2_2][^2_6]
- **For arXiv-by-generation:** compare **TeX Live snapshots + LaTeXML binding coverage**, not XML schema revisions.[^2_3][^2_8]
- **For a true dual formalization (typeset + semantics):** look at **sTeX + OMDoc**, not arXiv defaults.[^2_12]

If useful next step: I can sketch a side-by-side of the same mini-article as (1) plain `article.cls` LaTeX, (2) LaTeXML intermediate XML shape, and (3) JATS `front`/`body`, or pull the current LaTeXML RNG element list for sectioning/math/floats so it sits next to the JATS/DocBook tables from before.
<span style="display:none">[^2_20][^2_21][^2_22][^2_23][^2_24][^2_25][^2_26][^2_27][^2_28]</span>

<div align="center">⁂</div>

[^2_1]: https://math.nist.gov/~BMiller/LaTeXML/

[^2_2]: https://en.wikipedia.org/wiki/LaTeXML

[^2_3]: https://info.arxiv.org/help/faq/texlive.html

[^2_4]: https://www.arxiv-vanity.com/

[^2_5]: https://groups.google.com/g/comp.text.tex/c/OT4yftgabJM

[^2_6]: https://math.nist.gov/~BMiller/LaTeXML/manual/customization/latexml/schema.html

[^2_7]: http://sites.science.oregonstate.edu/~mpesz/latex/accessible/latexml-workflow.html

[^2_8]: https://arxiv.org/html/2605.16562v1

[^2_9]: https://github.com/dginev/ar5iv

[^2_10]: https://www.siliconchips-services.com/podcast/automated-latex-to-xml-conversion-workflow-latex-workflow/

[^2_11]: https://kwarc.info/people/mkohlhase/papers/mcs08-stex.pdf

[^2_12]: https://www.dfki.de/fileadmin/user_upload/import/4962_paper.pdf

[^2_13]: https://tex.stackexchange.com/questions/550849/latex-in-an-xml-production-environment

[^2_14]: https://news.ycombinator.com/item?id=40029279

[^2_15]: https://blog.arxiv.org/2020/09/24/tex-live-2020-release-oct-1-2020/

[^2_16]: https://blog.arxiv.org/2023/05/12/tex-live-2023-upgrade-to-occur-may-22nd-2023/

[^2_17]: https://docs.overleaf.com/troubleshooting-and-support/checklist-for-arxiv-submissions

[^2_18]: https://tex.stackexchange.com/questions/707715/making-the-most-of-latexml-on-the-arxiv

[^2_19]: https://info.arxiv.org/help/submit_latex_best_practices.html

[^2_20]: https://latex-ninja.com/2019/02/18/xml-to-latex-simple/

[^2_21]: https://info.arxiv.org/help/submit_tex.html

[^2_22]: https://tug.org/tug2014/slides/shikano.pdf

[^2_23]: https://huggingface.co/datasets/scholarweave/arxiv-latex

[^2_24]: https://www.latex-project.org/publications/2025-FMi-DPC-UFi-JAW-DocEng2025-MathML-and-other-XML.pdf

[^2_25]: https://www.reddit.com/r/LaTeX/comments/1lc9chw/which_latex_packages_should_be_avoided_in_a_latex/

[^2_26]: https://toolxml.com/xml-to-latex-converter

[^2_27]: https://www.math.purdue.edu/~yipn/TPC/latexml_overview.html

[^2_28]: https://github.com/brucemiller/LaTeXML/blob/master/doc/manual/manual.tex


---

# and yet, there must be some degree of this implicit in arvix preprint submissions. i can see it empirically in the commonalities across papers with the fuzz of author-idiosynchracies, and there's a clear trend over the years of things changing from the early days to today

You’re reading it correctly. arXiv doesn’t ship a JATS-style DTD, but the corpus **does** implement a soft, multi-layered schema — enforced by the submission machine, the TeX Live pin, field culture, and (now) LaTeXML. The “fuzz” is real authorial noise on top of a surprisingly stable backbone, and that backbone has drifted in clear eras.[^3_1][^3_2][^3_3]

## What “implicit formalization” means here

Think of it as a **constraint system + attractor landscape**, not a single grammar:


| Layer | What it constrains | How hard |
| :-- | :-- | :-- |
| **Pipeline** | What will compile and announce | Hard (reject / fail PDF) |
| **TeX Live pin** | Which macros/packages/engines exist | Hard per era |
| **Field attractors** | Dominant classes, section recipes, bib style | Soft (social) |
| **Venue templates** | NeurIPS/ICML/ACL/IEEE/AMS… as de facto roots | Soft→hard for authors |
| **HTML path (LaTeXML)** | Semantic macros that survive conversion | Soft now, increasingly normative [^3_4] |
| **Harvesting** | Identifiers, bib shape for INSPIRE etc. | Soft but rewarded [^3_1] |

That stack is enough to produce the empirical regularity you see: same rough spine across papers, with local dialect (macros, theorem stacks, figure workflows) as residual variance.[^3_5][^3_6]

***

## The de facto document model (corpus-level)

Across successful TeX submissions, the **modal skeleton** is remarkably stable even when classes differ:

```text
\documentclass{…}          % article | amsart | revtex | acmart | conf cls …
\usepackage{…}             % graphicx, amsmath, hyperref, …
\title{…}
\author{…}                 % often + \affiliation / \institute
\date{…}                   % arXiv warns against \today [web:55]
\begin{abstract}…\end{abstract}
\begin{document}
\maketitle
\section{Introduction}
…
\section{…} / \appendix / acknowledgments
\bibliography or thebibliography   % .bbl historically critical
\end{document}
```

**Structural invariants the pipeline actually cares about:**

- A detectable **toplevel** with `\documentclass` (compilation from submission root).[^3_1]
- **Figures** in a format matching the processor (EPS/PS for DVI-era; PDF/PNG/JPEG for PDFLaTeX) — no on-the-fly conversion.[^3_1]
- **Bibliography** as something the system can resolve (legacy: ship `.bbl`; modern Submission 1.5: `.bib` + auto bibtex/biber, or matching `.bbl`).[^3_1]
- No junk: aux/log/pdf-from-tex stripped; no embedded JS; tidy tree.[^3_2][^3_1]
- Prefer **semantic** macros if you care about HTML (`\section`, `\emph`, `graphicx` alt text) — explicit best-practice layer since HTML papers.[^3_4]

That is closer to a **RELAX NG “required spine + open expansion points”** than to free-form text. The open points (`\usepackage`, custom `\newcommand`, theorem environments, conference `.cls`) are where idiosyncrasy lives.

***

## Generational eras (the trend you notice)

These are **empirical regimes**, not schema version numbers — but they behave like generations of a living standard.

### Era 0 — Hep-th roots (1991–late 1990s)

- Plain TeX / early LaTeX2ε, `revtex`, hep-style macros, PostScript figures.
- Culture: compact source, email-era portability; arXiv exists *because* TeX was the compact portable format.[^3_3]
- Visual: single-column, dense math, minimal hyperref-era chrome.


### Era 1 — Classic AutoTeX + LaTeX2ε consolidation (~2000–2011)

- LaTeX2ε + `article`/`amsart` dominance in math; field classes elsewhere.
- **AutoTeX** as the decades-long compiler brain (guess main file, run latex/bibtex/dvips path).[^3_7][^3_1]
- Figures: EPS-centric workflows still common; `psfig` still in the wild (later broken).[^3_1]
- Bib: **prebuilt `.bbl`** as the social norm (system didn’t want to own bibtex edge cases).


### Era 2 — PDFLaTeX becomes default practice (~2011–2020)

- PDF/PNG/JPEG figures displace EPS for most new work.[^3_1]
- `hyperref`, `graphicx`, AMS math stack as near-universal substrate.
- TeX Live jumps (e.g. long **TL 2016** baseline, then **TL 2020**) reset the package universe and quietly break old idioms.[^3_8][^3_9][^3_10]
- CS/ML explosion: conference classes (`neurips_*.sty`, `icml`, `acl`, `ieee`) flood the corpus — **venue schema as preprint skin**.


### Era 3 — Dual product: PDF + HTML semantics (2020–2025)

- TL **2023** / **2025** dual support; authors pick a processor generation.[^3_11][^3_9]
- **LaTeXML → HTML papers** (ar5iv lineage → arXiv HTML) adds a second consumer of the same source.[^3_12][^3_4]
- Best practices document starts to read like a style guide for *meaning*: standard front matter, alt text, `\section` not font hacks.[^3_4]
- Biblatex/Biber version coupling becomes a sharp edge (`.bbl` format 3.2 vs 3.3 tied to TL year).[^3_1]


### Era 4 — Submission 1.5 (April 2025–)

- **AutoTeX retired** after decades; simpler, more explicit TeX→PDF path.[^3_1]
- Bib processing modernized (detect biblatex backend, run biber/bibtex; or use provided `.bbl`).[^3_1]
- Author-visible processor choice; `00README` still a control surface.[^3_1]
- Net effect: less magical “AutoTeX dialect,” more **declared engine + TL year + tidy sources** — i.e. the implicit schema gets slightly more *explicit*.

You can feel those eras in the PDF chrome alone: fonts, hyperlink boxes, theorem styling, whether DOIs/`arXiv:` ids appear in refs, single- vs double-column conference skins, quality of figure pipelines, presence of ORCIDs/affiliations blocks, etc.

***

## Why commonality is so strong (despite no official template)

arXiv **deliberately** has no mandatory house class — and people still converge.[^3_6][^3_5]

1. **Compiler as type-checker** — only a finite subset of “LaTeX programs” type-check on the pinned TL + pipeline rules. Failed submissions never enter the corpus.[^3_1]
2. **Copy-paste genealogy** — advisors’ templates, Overleaf galleries, “arxiv-style” GitHub repos, last year’s NeurIPS kit. Cultural transmission ≈ schema inheritance.[^3_13][^3_14][^3_15]
3. **Venue → preprint pipeline** — submit camera-ready class to the conference, then the same tree (or a lightly de-branded one) to arXiv. The conference DTD-of-the-mind becomes the preprint dialect for that subfield.
4. **Shared macro ecology** — `amsmath` + `graphicx` + `hyperref` + (`booktabs`, `algorithm2e`/`algorithmic`, `cleveref`, `biblatex`|`natbib`) is a de facto standard library.
5. **Second interpreter (LaTeXML)** — packages without `.ltxml` bindings degrade HTML; authors who care drift toward the supported set. That’s selection pressure toward a **semantic subset**.[^3_4]
6. **Harvesting incentives** — clean `arXiv:YYMM.NNNNN` tokens in refs, single bib file, predictable front matter improve INSPIRE/Semantic Scholar-style extraction.[^3_1]

So the “schema” is **evolutionary**: fitness = compiles on arXiv + looks like a paper in my field + (optionally) converts to HTML + cites cleanly.

***

## Mapping back to JATS / TEI / DocBook / DITA

| Concept | Explicit XML standards | arXiv TeX corpus |
| :-- | :-- | :-- |
| Normative grammar | DTD/RNG/XSD | Pipeline + TL + social attractors |
| Versions | 1.1 / 1.3 / 5.2… | TeX Live years + AutoTeX vs 1.5 + HTML era |
| Root element | `article` / `TEI` / `book` / `topic` | `\documentclass{…}` + toplevel file convention |
| Specialization | DITA domains, TEI ODD, JATS tag sets | Field classes + custom macro packages |
| Validation | Schema-aware editor | “Did AutoTeX/1.5 produce an acceptable PDF?” (+ now HTML) |
| Interchange form | The XML *is* the artifact | `.tex` tree is archival; PDF (and HTML) are projections [^3_2] |

Your intuition is the right theoretical move: **arXiv TeX is a naturally occurring, weakly typed document language** whose types are proven by compilation and whose dialects cluster by year × field × venue. Corpus datasets (e.g. full-source parquet dumps) make that language empirically recoverable — package-frequency time series, class histograms, section-title topic models, bib engine shifts, figure-format transitions.[^3_16][^3_17]

***

## What a “schema archaeology” of arXiv would look like

If you formalized what you’re already seeing:

1. **Core spine** (near-universal): documentclass, title/author/abstract, sectioning, bib anchor, includegraphics-or-equivalent.
2. **Dialect modules** (field-level): theorem stacks (AMS vs ntheorem vs thmtools), proof environments, algorithm packages, physics unit macros, ML experiment tables.
3. **Era flags**: EPS vs PDF figures; `psfig` absence after TL2016; natbib vs biblatex; hyperref defaults; presence of `\includegraphics[alt=…]`; TL2023 vs TL2025 bbl format.
4. **Binding layer**: which constructs LaTeXML maps cleanly → proxy for “semantic conformance” post-2023.[^3_4]
5. **Idiosyncrasy residual**: author `\newcommand` graphs, local `.sty`, comment/leak noise (a large fraction of sources carry leftover comments/secrets — another empirical signature of real authoring practice).[^3_18]

That residual is your “fuzz”; the first four layers are the implicit standard.

***

**Bottom line:** There *is* an arXiv preprint formalization — it’s just **enacted** (by compilers, pins, templates, and converters) rather than **declared** (as RNG). The multi-decade trend you see is that enactment getting stricter and more multi-target: from “any TeX that becomes PS/PDF” toward “TeX that becomes PDF *and* structured HTML, under an explicit TL generation, with bib and figures in declared contracts.”[^3_12][^3_4][^3_1]

If you want to push this into something research-shaped next, the highest-leverage cut is a **generational feature matrix** (Era 1–4 × structural traits) or a small empirical sketch from public arXiv source dumps — package/class frequencies by year for cs.LG vs hep-th vs math.AG, for example.
<span style="display:none">[^3_19][^3_20][^3_21][^3_22][^3_23][^3_24][^3_25][^3_26][^3_27][^3_28][^3_29][^3_30][^3_31]</span>

<div align="center">⁂</div>

[^3_1]: https://info.arxiv.org/help/submit_tex.html

[^3_2]: https://info.arxiv.org/help/submit/index.html

[^3_3]: https://en.wikipedia.org/wiki/ArXiv

[^3_4]: https://info.arxiv.org/help/submit_latex_best_practices.html

[^3_5]: https://www.reddit.com/r/MachineLearning/comments/4wjozn/latex_template_for_arxiv_papers/

[^3_6]: https://www.reddit.com/r/LaTeX/comments/1ohehmx/arxiv_paper_template/

[^3_7]: https://blog.arxiv.org/2020/11/12/error-detected-a-new-feature-helps-authors-submit-their-work/

[^3_8]: https://tex.stackexchange.com/questions/428277/what-happens-to-arxiv-publications-when-their-texlive-is-updated

[^3_9]: https://info.arxiv.org/help/faq/texlive.html

[^3_10]: https://blog.arxiv.org/2020/09/24/tex-live-2020-release-oct-1-2020/

[^3_11]: https://docs.overleaf.com/troubleshooting-and-support/checklist-for-arxiv-submissions

[^3_12]: https://arxiv.org/html/2605.16562v1

[^3_13]: https://www.overleaf.com/latex/templates/style-and-template-for-preprints-arxiv-bio-arxiv/fxsnsrzpnvwc

[^3_14]: https://github.com/kourgeorge/arxiv-style

[^3_15]: https://www.overleaf.com/gallery/tagged/arxiv

[^3_16]: https://tex.stackexchange.com/questions/740648/estimate-usage-of-latex-package-in-arxiv-publications

[^3_17]: https://huggingface.co/datasets/scholarweave/arxiv-latex

[^3_18]: https://www.linkedin.com/posts/logan-shamberger-59319b228_github-loganshambergerarxiv-utils-arxiv-activity-7486799008523399169-Jku8

[^3_19]: https://ieeevis.org/year/2019/info/open-practices/open-practices-arxiv

[^3_20]: https://www.reddit.com/r/AskAcademia/comments/16jv30h/after_uploading_a_paper_to_arxiv_how_much_time/

[^3_21]: https://trybibby.com/blog/arxiv-latex-submission-guide

[^3_22]: https://thelatexlab.com/arxiv-latex-formatting/

[^3_23]: https://info.arxiv.org/help/versions.html

[^3_24]: https://arxiv.org/html/2603.02873v3

[^3_25]: https://tex.stackexchange.com/questions/643330/caught-error-in-autotex-process-error-no-postscript-to-move

[^3_26]: https://arxiv.org/html/2510.03761v2

[^3_27]: https://www.reddit.com/r/LaTeX/comments/1m1azvk/i_made_an_arxiv_compatible_minimal_template_for/

[^3_28]: https://arxiv.org/html/2605.19723v1

[^3_29]: http://ieeevis.org/year/2022/info/open-practices/arxiv-first-time-user

[^3_30]: https://www.bodunhu.com/blog/posts/how-to-put-papers-on-arxiv/

[^3_31]: https://arxiv.org/html/2509.06503v3


---

# yea, and the parallels with PDFs is also informative as i work on this project, not only because of the latex->pdf relationship implemented by arvix but also because both latex and pdf point to a common latent abstract manuscript format that the standards I was asking about also gesture at with their domain-specific sensibilities and applications, and my goal is to convert pdf and latex, later HTML potentially, into a markdown incarnation of said latent manuscript

Yes — that is the right compression of the whole stack. JATS, TEI, DocBook, DITA, LaTeX, PDF, and HTML are not competing “true formats”; they are **domain-tuned projections** of one latent manuscript object. Your Markdown incarnation is another projection, chosen for human/model readability and AST addressability rather than publishing interchange or print fidelity.

## The latent object

What you have been calling the **latent canonical manuscript envelope** is exactly the thing those standards gesture at under different pressures:


| Pressure | What gets privileged in the projection |
| :-- | :-- |
| STM archive / journal | JATS front-matter, floats, refs |
| Literary / analytic text | TEI header + deep interpretive markup |
| Book-length tech narrative | DocBook structural hierarchy |
| Reusable topic products | DITA topics + maps |
| Authoring + math typesetting | LaTeX macros + class/package dialect |
| Fixed layout / print-digital delivery | PDF geometry, fonts, content streams |
| Browser delivery | HTML/CSS (+ MathML) boxes |
| **Your target** | Lean MarkPig Markdown + math channel + graph/AST |

Surjection, not bijection: many concrete sources map onto one envelope instance; recovery is abductive.

A concrete instance remains what you already locked in: a **DAG** (containment, sequence, reference) linearized by a reading-order traversal into an addressable spine $(\text{pos}, \text{kind})$, with prose/math as interleaved channels and ref edges serialized as links/footnotes/cites — not a tag soup pretending to be the ontology.[^4_1]

## Why PDF + LaTeX are the informative pair

arXiv makes the duality operational: **LaTeX is closer to authorial intent**; **PDF is a rendered witness** of one layout under one engine/class/era. Same latent manuscript; different information loss:[^4_2][^4_3]


|  | LaTeX source | PDF |
| :-- | :-- | :-- |
| Structure | Often explicit (`\section`, envs, labels) | Implicit in geometry / tagged PDF if lucky |
| Math | Macro semantics (recoverable → KaTeX channel) | Glyphs + positions (furniture-heavy) |
| Reading order | Mostly declaration order + floats rules | Must be inferred from layout |
| Idiosyncrasy | Packages, macros, era/TL dialect | Font subsetting, encoding, line breaks |
| Role in your pipeline | **Oracle lane** (deterministic L→MD) | **Hard lane** (PdfPig geometry → MD) [^4_4] |

That is why the dual-lane setup is not a convenience — it is the experimental design: LaTeX→Markdown defines the envelope target; PDF→Markdown is scored against it when pair-mates exist (arXiv).[^4_4]

PDF is especially clarifying because it forces the **substance vs furniture** cut you already treat as central: kerning, line breaks, header chrome, and glyph salad are projection artifacts; theorem identity, formula semantics, section role, and cite edges belong to the envelope.

## Where the XML standards sit relative to your envelope

They are not competitors to the latent form; they are **prior art for slot vocabularies** you can borrow when naming node kinds and composite closures:

- **JATS** → article spine: front/meta, body sections, floats-group, back/ref-list — good prior for preprint/journal-shaped envelopes.
- **TEI** → header vs text, analytical depth, ODD-style customization — closest philosophical cousin to “one latent model, many constrained projections.”
- **DocBook** → bookish structural kinds (chapter/section/informalfigure) — clean block/inline stratification.
- **DITA** → typed topics + map assembly + conref — closest to your “graph first, traversal second” and to reuse/ref edges; specialization ≈ dialect modules without collapsing the envelope.

None of them should become your surface. Your surface stays **low-overhead Markdown**; structure lives post-parse in MarkPig (and the math channel AST), so humans and models read the same bytes the visitors walk.[^4_5]

## Converter lanes → one convergent envelope

```text
LaTeX  ──(deterministic)──┐
PDF    ──(geometry+abduction)──┼──►  envelope graph M
HTML   ──(later; DOM≈weak tree)──┘         │
                                           ▼
                              reading-order spine + channels
                                           │
                                           ▼
                              MarkPig Markdown incarnation
                              (math channel = KaTeX-normalized)
```

Shared requirements across lanes (what “faithful” means for you):

1. **Strip furniture** — layout/typography that is not semantics.
2. **Normalize math into the math channel** — flat, bounded, KaTeX-valid; macros expanded; confusables handled as evidence, not blind rewrites.
3. **Recover graph edges** — section dominance, float ownership, cite/ref, footnote targets.
4. **Emit one spine** — traversal order + kinds; composites (figure+caption, thm+proof) as closed subgraphs.[^4_1][^4_5]
5. **Era/dialect robustness** — arXiv TL generations and author macro fuzz are noise on the fiber of $\pi: \mathcal{S} \twoheadrightarrow M$, not alternate latent targets.

HTML later is the easy-ish third lane only if you treat it as another projection (DOM order ≈ weak reading order; MathML/HTML math as a third math witness), not as the schema authority.

## Design rule this conversation adds

The standards discussion pays rent as a **coverage checklist** for envelope node kinds and slots, not as interchange targets:


| Envelope concern | Borrow sensibility from |
| :-- | :-- |
| Mandatory meta head | JATS `front` / TEI `teiHeader` |
| Hierarchical exposition | DocBook / LaTeX sectioning |
| Typed reusable blocks | DITA topic types |
| Deep math + theorems | LaTeX/sTeX practice → your math channel |
| Layout witness / gauntlet | PDF (+ arXiv pair-mates as oracle) |
| Lean readable surface | Markdown flavor MarkPig owns |

So the project thesis stays sharp: **one latent manuscript graph**; LaTeX/PDF/(HTML) are sensors; JATS/TEI/DocBook/DITA are historical, domain-specific coordinate charts on the same manifold; MarkPig Markdown is the **working incarnation** optimized for LLM fluency, token economy, and visitor-level sub-addressing — with LaTeX-pair PDFs as the gauntlet that keeps the hard lane honest.

If you want to push the next concrete step inside Codex-Scientiae, the highest leverage is a **minimal envelope kind catalog** (node kinds + composite closures + ref edge types) explicitly crosswalked to JATS/DocBook/DITA names — a Rosetta table for implementers, not a commitment to emit those XMLs.

<div align="center">⁂</div>

[^4_1]: https://www.perplexity.ai/search/3477c7f4-58a9-48c9-ac31-34aa92c86db7

[^4_2]: https://info.arxiv.org/help/submit_tex.html

[^4_3]: https://info.arxiv.org/help/submit/index.html

[^4_4]: https://www.perplexity.ai/search/414673e2-74b0-4e1c-896c-ce2c7bd6ff9f

[^4_5]: https://www.perplexity.ai/search/1b186228-92b1-456b-9bc7-e54c81d6ccc8


---

# latex + pdf pairing is also critical for PDF to markdown development because latex to markdown can actually be handled to satisfaction deterministically, whereas PDF only aspirationally so and not guaranteed at present. latex-to-markdown is a first class product and deliverable in its own right, but once working, also serves as an oracle for scoring PDF without a judge

Yes. That split is load-bearing, not a temporary scaffold.

## Two products, one coupling

| Lane | Status | Role |
| :-- | :-- | :-- |
| **LaTeX → Markdown** | Deterministic, shippable | First-class deliverable **and** oracle |
| **PDF → Markdown** | Aspirational / partial | Scored against the oracle when pair-mates exist |

LaTeX→MD earns its keep on its own: arXiv-scale sources, clean math channel, envelope spine, LLM-ready library. The PDF lane does not get to redefine the target; it tries to hit the same convergent envelope. Pairing is how you know whether it did.

## Oracle without a judge

A judge is a model or human saying “looks good.” An **oracle** is a reference artifact produced by a trusted, repeatable procedure:

```text
arXiv pair-mate
    ├─ paper.tex  ──(L→MD, deterministic)──►  M_oracle   ← ground truth envelope
    └─ paper.pdf  ──(P→MD, under test)    ──►  M_pdf
                                              │
                                              ▼
                                    δ(M_pdf, M_oracle)   ← score, no judge
```

Because both lanes target the **same** latent manuscript incarnation (MarkPig Markdown + math channel + spine), disagreement is measurable: structure, math channel normalization, reading order, ref edges, composites — not “vibes” and not PDF-vs-LaTeX string equality.

That is the gauntlet: PDF success is **agreement with the LaTeX-derived envelope**, not independent aesthetic success.

## Why this only works if L→MD is truly first-class

If LaTeX→MD is a hacky side path, the oracle is biased and PDF training/eval chases noise. If it is a real product — stable normalization, era/dialect handling, furniture stripped, math channel KaTeX-flat — then:

1. **Corpus value** — every TeX-submittable arXiv paper becomes high-quality MD without waiting on PDF.
2. **Eval value** — every TeX+PDF pair becomes a labeled example for free.
3. **Dev value** — regressions in PdfDig are diffs against $M_\text{oracle}$, not new annotation campaigns.
4. **Ceiling honesty** — where PDF systematically cannot recover what LaTeX states (unmapped macros, vertical-only cues, destroyed encoding), $\delta$ stays high; you record **structural non-identifiability** instead of pretending a judge can paper over it.

## What “scoring without a judge” implies

Prefer **envelope-level** metrics over raw text:

- Spine alignment (section/float/theorem kinds and order)
- Math-channel equivalence (normalized KaTeX, not glyph strings)
- Ref-graph edge recovery (cites, labels, footnotes)
- Composite closure (figure+caption, proof blocks)
- Residual prose diff after furniture strip

A judge LLM can still help for triage or unpaired PDFs later; it must not define success while pairs exist. The pair **is** the label.

## Project ordering (consistent with holding PDF)

Your stated hold on PDF until L→MD and devops mature is exactly right under this logic:

1. Harden **LaTeX → envelope MD** to satisfaction (product).
2. Freeze oracle contract (normalization + kind catalog + $\delta$).
3. Build **PDF → envelope MD** against arXiv pair-mates (gauntlet).
4. Only then treat unpaired PDF as a generalization problem (maybe judge-assisted).

So: LaTeX+PDF pairing is not just convenient data — it is the **only** way to develop PDF→MD as science rather than demos, while LaTeX→MD remains the deliverable that makes the oracle legitimate.

<div align="center">⁂</div>

---

# right, and one of the goals of the current latex ingest is not only to ship reliable latex-to-markdown but also establish a JSONL representation of the latent manuscript hypergraph (a sufficient description and schema on which all inputs can surjectively converge) with internal references and canonical node ordering achieved for any given example. the jsonl "ABI" which pdf to markdown will later also build, and which will be the substrate for systematic scoring and measurement in consistent semantically coherent chunks that can be aligned between the two lanes an measured piece wise to isolate failures as well as generate composite scoring

Yes. That JSONL layer is the real ABI — Markdown is a projection; the hypergraph serialization is what both lanes must satisfy and what scoring actually runs on.

## Role split

| Artifact | Role |
| :-- | :-- |
| **JSONL hypergraph** | Canonical IR / ABI — sufficient description of the envelope instance |
| **Markdown incarnation** | Human/model-readable projection of the same graph (spine walk + channels) |
| **LaTeX → JSONL** | Deterministic producer + oracle |
| **PDF → JSONL** | Under-test producer; must emit the same ABI |
| **δ on JSONL** | Piecewise + composite measurement; no judge required when pairs exist |

Shipping L→MD without freezing the JSONL contract would leave the oracle as prose. Freezing JSONL first makes MD a view and PDF a second writer to the same interface.

## What “sufficient” means for the ABI

The JSONL schema has to be rich enough that **any** successful ingest (TeX, later PDF/HTML) can surject onto it, and thin enough that two writers can be compared node-wise:

1. **Nodes** — stable `kind` + payload (prose, math-channel, figure, table, theorem, meta, …)
2. **Canonical order** — total reading-order index on the spine (the traversal linearization)
3. **Hyperedges** — refs that are not tree edges: cite → bib item, `\ref` → label, footnote ↔ anchor, figure ↔ caption, multi-parent shares
4. **Composite closures** — figure+caption, thm+proof as explicit group nodes or typed hyperedges
5. **Provenance hooks** (optional per lane) — source offsets / PDF bbox; not part of equality, useful for debug

Tree containment alone is not enough; that is why you want a **hypergraph** (or DAG + hyperedges), not a pure AST dump. Markdown links/footnotes are one serialization of those edges; JSONL is the one built for alignment and measurement.

## Canonical ordering = alignment key

For any example manuscript $M$:

$$
\text{spine}:\quad n_0 \prec n_1 \prec \cdots \prec n_{N-1}
$$

with each record carrying at least:

```text
{ "id", "ord", "kind", "channel", "payload", "edges": [...], "parent" | "closure" }
```

Piecewise scoring becomes join-on-`(ord, kind)` or join-on-stable-`id` when both lanes assign ids from the same rules — then fall back to edit distance on the spine when PDF drops/merges nodes.

That is how you **isolate failures**:


| Failure class | What diverges |
| :-- | :-- |
| Segmentation | `ord` / span boundaries |
| Typing | `kind` mismatch (para vs thm vs list) |
| Math channel | normalized KaTeX payload δ |
| Reading order | spine permutation |
| Structure | parent/closure membership |
| Reference graph | missing/wrong hyperedges |
| Hallucinated furniture | extra nodes with no oracle counterpart |

Composite scores are then principled aggregates (weighted micro-F1 on kinds, edge F1, math equivalence rate, spine Kendall/LCS) — not a single BLEU over full MD.

## Surjective convergence

```text
LaTeX dialectᵢ  ─┐
PDF layoutⱼ     ─┼──►  JSONL(M)  ──►  MD(M)   [view]
HTMLₖ           ─┘         ▲
                           │
                    same schema (ABI)
```

Many inputs → one envelope instance. The ABI is the **codomain** of that surjection. L→JSONL defines the oracle point $M^\star$; P→JSONL yields $\hat{M}$; measurement is $\delta(\hat{M}, M^\star)$ in JSONL space, with MD available for inspection and library use.

## Why JSONL specifically

- **One record per node** (or per node + edge list) — natural chunk granularity for eval and for later RAG/sector retrieval
- **Streamable** — large papers, parallel workers
- **Diff-friendly** — line-oriented, stable `ord` sort
- **Lane-agnostic** — PDF lane never has to emit MD to be scorable; it must emit ABI
- **MarkPig bridge** — JSONL → walk spine → MD; MD → parse AST → JSONL (round-trip tests on the oracle lane)


## Ingest goals (current phase), restated

1. **Reliable LaTeX → Markdown** (product).
2. **LaTeX → JSONL hypergraph** with internal refs + canonical order (ABI).
3. Treat (2) as the contract PDF will implement later.
4. Build **piecewise + composite δ** on JSONL pairs now, while only the oracle lane is green — so the gauntlet exists before PdfDig is unblocked.

Markdown remains first-class for humans and models; **JSONL is first-class for convergence, scoring, and lane alignment**. Once that ABI is stable, “PDF success” means “emits JSONL that matches the LaTeX oracle under δ,” and failure isolation stays semantically coherent instead of dissolving into full-document text diffs.
<span style="display:none">[^6_1][^6_10][^6_2][^6_3][^6_4][^6_5][^6_6][^6_7][^6_8][^6_9]</span>

<div align="center">⁂</div>

[^6_1]: https://www.latex-project.org/publications/2020-tagged-pdf-feasibility.pdf

[^6_2]: https://arxiv.org/html/2605.22923v1

[^6_3]: https://arxiv.org/html/2512.18115v1

[^6_4]: https://journal.r-project.org/articles/RJ-2025-022/

[^6_5]: https://aclanthology.org/2025.emnlp-demos.56.pdf

[^6_6]: https://dl.acm.org/doi/abs/10.1007/s00799-023-00370-5

[^6_7]: https://www.lri.fr/~gobert/papers/chi2022-ilatex.pdf

[^6_8]: https://www.latex-project.org/publications/2023-UFi-FMi-TUG-tb137fischer-tagging23.pdf

[^6_9]: https://dev.to/aairom/docling-speaks-latex-unlocking-academic-and-scientific-documents-2hm5

[^6_10]: https://www.ijset.in/wp-content/uploads/IJSET_V12_issue3_521.pdf


---

# i can't build the piecewise composite deltas for PDF-Latex scoring now, because internal validation of latex can't use its own output as its oracle. i have to validate internally a different way by running isolated rendering and rasterization. thats the dev loop right now, which gets me to building the ABI JSONL to use later.

Correct — and that distinction keeps the epistemology clean.

## Two validation regimes (do not collapse them)

| Phase | What is under test | Reference | Method |
| :-- | :-- | :-- | :-- |
| **Now** | LaTeX → MD / JSONL | *Not* its own emit | Isolated render + raster (and related external checks) |
| **Later** | PDF → JSONL | LaTeX-lane JSONL | Piecewise / composite $\delta$ on the ABI |

Using $M_\text{LaTeX}$ as oracle for the LaTeX writer would only prove idempotence or bit-stability, not fidelity. The render/raster loop is the non-circular check: **does the recovered math-channel (and related slices) typeset like the source intended?**

## What the current dev loop is doing

```text
source TeX slice
    │
    ├─► engine render ──► raster A   (authority: author macros + TL)
    │
    └─► ingest ──► math channel / node payload
                        │
                        └─► KaTeX (or controlled) render ──► raster B

compare(A, B)  →  local pass/fail  (no self-oracle)
```

That loop:

1. **Validates transformation** — furniture strip, macro expand, normalization — against a visual/semantic witness outside the pipeline.
2. **Builds trust in payloads** that will live in JSONL nodes (especially math-channel records).
3. **Does not yet** require pairwise PDF scoring, ABI alignment machinery, or a judge.

Structural pieces (section spine, ref edges, closures) need their own non-circular checks in this phase — round-trip where meaningful, fixture graphs, invariant assertions — but they still must not treat “we emitted it” as “it’s true.” Render/raster is the hard core for math; structure gets fixtures and invariants until the ABI is frozen.

## How this yields the ABI without cheating

Order of authority:

1. **External witness** (render/raster, fixtures) → confidence in node payloads and kind assignment.
2. **Freeze JSONL ABI** — schema, kinds, `ord`, hyperedges, channel rules — as the sufficient hypergraph description.
3. **Ship L → JSONL (+ MD view)** as the deterministic product.
4. **Only then** open P → JSONL and turn on piecewise/composite $\delta(M_P, M_L)$.

So JSONL is being built **under** render-loop discipline now; it becomes an oracle **for the other lane** later. Same artifact, two roles at two times — not circular.

## What to avoid in this phase

- Scoring LaTeX ingest against its own Markdown/JSONL
- Building PDF $\delta$ infrastructure before ABI + L-lane trust are real
- Letting raster match become the *definition* of the envelope (it’s a **test**, not the IR)

Raster says: “this math-channel record is faithful enough.”
JSONL says: “this is the manuscript hypergraph we claim.”
PDF $\delta$ will say: “did the other sensor recover that graph?”

**Dev loop now:** isolated render/raster (+ structure fixtures) → trustworthy L→JSONL ABI.
**Dev loop later:** ABI-aligned pairwise measurement.
Holding PDF scoring until then is the right constraint, not a gap.

<div align="center">⁂</div>

---

# how might i modify this karpathy claude file to merge my wants and needs with karpathy's complementary guidance

Karpathy’s file is a **process constitution** (how to change code). Yours is a **domain constitution** (what must stay true). Merge by keeping his four sections almost intact, then adding a thin project layer that encodes envelope/ABI/oracle rules without turning CLAUDE.md into MarkBrain.

## Merge strategy

| Keep from Karpathy | Add from you | Do not put in CLAUDE.md |
| :-- | :-- | :-- |
| Think / Simplicity / Surgical / Goal-driven | Lane authority, ABI, validation epistemology | Full kind catalog, RNG crosswalks |
| Caution > speed tradeoff | Math-channel + furniture rules | Long architecture essays |
| Verifiable success criteria | Render/raster vs pairwise δ (when each applies) | Implementation tutorials |

**Rule of thumb:** CLAUDE.md answers “how should an agent behave in this repo?” Specs and ADRs answer “what is the envelope?”

***

## Suggested merged `CLAUDE.md`

```markdown
# CLAUDE.md

Behavioral guidelines for agents in this repo. Karpathy-style process rules
plus Codex-Scientiae domain constraints. Merge conflicts: domain invariants
win over convenience; process rules win over drive-by refactors.

**Tradeoff:** Bias toward caution over speed. For trivial tasks, use judgment.

---

## 0. Project north star (read first)

**Codex-Scientiae** ingests scientific manuscripts into a latent envelope and
emits projections. Agents must not invent a second architecture.

| Concern | Authority |
|---------|-----------|
| Latent object | Manuscript hypergraph (nodes, spine order, hyperedges, closures) |
| ABI / IR | JSONL serialization of that hypergraph — lane-agnostic contract |
| Human/model view | MarkPig Markdown + math channel (projection of JSONL) |
| L→MD / L→JSONL | First-class product; deterministic; builds the ABI |
| P→MD / P→JSONL | Later; must emit the same ABI; scored against LaTeX-lane JSONL |
| Pairwise PDF↔LaTeX δ | Only after ABI is stable and L-lane is trusted — not this phase’s scorer |

**Surjection:** many sources (LaTeX dialects, later PDF/HTML) → one envelope
instance. Do not treat any source format as the ontology.

**Current phase:** harden LaTeX ingest + JSONL ABI. PDF pipeline is on hold
for product work unless explicitly tasked. Do not build PDF scoring harnesses
“while here.”

---

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

**Domain checks before coding:**
- Which lane is this? (`latex` | `pdf` | `html` | shared ABI | MarkPig view)
- Does this change the JSONL ABI, only a projection, or only a converter?
- ABI changes need explicit user intent — they are contract changes.
- Is success defined by render/raster, fixtures/invariants, or (later) pairwise δ?
- Never use LaTeX-lane output as the oracle for LaTeX-lane fidelity.

---

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No “flexibility” or multi-lane scaffolding not requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- No premature PDF↔LaTeX alignment metrics, judge LLMs, or schema
  compatibility shims “for later” unless the task is exactly that.

Ask: “Would a senior engineer say this is overcomplicated?” If yes, simplify.

**Envelope simplicity:** prefer a smaller sufficient JSONL kind set over
mirroring JATS/TEI/DocBook/DITA element inventories. Borrow names when useful;
do not import those standards as runtime dependencies.

---

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't “improve” adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.
- Don't “tidy” math normalization, ABI field names, or golden fixtures
  unless the task targets them — silent norm drift breaks the oracle later.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: every changed line should trace directly to the user's request.

---

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- “Add validation” → “Write tests for invalid inputs, then make them pass”
- “Fix the bug” → “Write a test that reproduces it, then make it pass”
- “Refactor X” → “Ensure tests pass before and after”

For multi-step tasks, state a brief plan:
```

1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

### Phase-correct verification (this repo)

**LaTeX lane (now) — non-circular:**
- Math/payload fidelity: isolated render + raster (or agreed visual/semantic
  witness) against source-derived truth — NOT diff to our own MD/JSONL alone.
- Structure: fixtures, invariants, explicit graph checks — not self-oracle.
- Golden ABI/MD files: regression locks after human/render acceptance; they
  detect drift, they do not define ground truth by themselves.

**PDF lane (later) — oracle is LaTeX JSONL:**
- Piecewise δ on JSONL (`ord`/`kind`/payload/edges), then composite aggregates.
- No judge model as primary success when pair-mates exist.

**Shared:**
- Strong criteria beat “make it work.”
- Prefer tests that isolate failure class: segment | kind | math | order | edges.

---

## 5. Domain invariants (do not violate)

1. **Substance vs furniture** — strip typesetting-only artifacts; keep
   semantic structure and math meaning.
2. **Math channel** — emit normalized, bounded, KaTeX-valid math; expand
   macros; treat author commands as evidence toward canonical forms, not as
   the permanent surface when a standard form is justified.
3. **JSONL is the ABI** — Markdown is a view. Both lanes eventually write
   JSONL; scoring aligns on JSONL chunks/nodes, not raw MD strings.
4. **Canonical spine** — every envelope instance has deterministic reading
   order (`ord`) + node `kind`; hyperedges carry refs (cite, label, footnote,
   caption ownership, closures).
5. **Terminology** — prefer *math channel* over overloaded “register”; prefer
   *envelope* / *hypergraph* / *spine* as in project docs. Don't rename the
   architecture in passing.
6. **Stack sensibilities** — MarkPig/PdfDig are C#/PowerShell-facing where
   applicable; don't casually replatform shared IR to a parallel Python-only
   schema without intent.

---

## 6. What “done” looks like for common task types

| Task type | Done means |
|-----------|------------|
| LaTeX math normalize | Render/raster (or fixture) pass; channel string stable; no ABI field rename |
| New node kind | Schema + emitter + MD projection + fixture; document surjection from LaTeX |
| Ref/hyperedge | Round-trip or fixture on edges; spine `ord` unchanged unless intended |
| MD-only prettify | No JSONL semantic change; golden ABI unchanged |
| PDF work | Explicitly in scope; emits ABI; δ plan named — else out of scope |

---

**These guidelines are working if:** diffs stay small; ABI doesn't drift
silently; LaTeX validation stays non-circular (render/raster + fixtures);
agents ask before contract changes; PDF scoring work doesn't leak into the
LaTeX hardening phase; clarifying questions come before implementation.
```


***

## Why this shape works

- **§0–§5 domain** is short enough that agents actually load it; Karpathy **§1–§4** stay recognizable so the “complementary guidance” isn’t rewritten into a different personality.
- **Epistemology is explicit** (self-oracle ban vs later pairwise δ) — that was the sharpest process bug to prevent.
- **ABI vs MD** is stated once so agents don’t optimize Markdown string equality.
- **Phase gate** on PDF matches your hold without needing a separate novel.


## Optional splits (if CLAUDE.md grows)

| File | Contents |
| :-- | :-- |
| `CLAUDE.md` | Process + invariants (above) |
| `docs/ABI_JSONL.md` | Record schema, kinds, edge types |
| `docs/VALIDATION.md` | Render/raster harness, golden policy |
| MarkBrain | Design rationale, standards crosswalk |

Keep CLAUDE.md under ~150–200 lines so it remains a steering surface.

## Light edits you might want

- Name the actual repos/paths (`aghado01/codex-scientiae`, MarkPig entrypoints) in §0 if agents land in a monorepo.
- Add one line under §4 with the **real** render/raster command once it is stable (`dotnet test …`, `pwsh ./scripts/…`).
- If you want Karpathy’s voice even tighter, delete §6 and fold the table into §4 as bullets.

I can turn this into a repo-ready patch against your real paths/commands if you point at where `CLAUDE.md` will live (codex-scientiae root vs MarkBrain).
<span style="display:none">[^8_1]</span>

<div align="center">⁂</div>

[^8_1]: CLAUDE.md

