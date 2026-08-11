You’re reading it correctly. arXiv doesn’t ship a JATS-style DTD, but the corpus **does** implement a soft, multi-layered schema — enforced by the submission machine, the TeX Live pin, field culture, and (now) LaTeXML. The “fuzz” is real authorial noise on top of a surprisingly stable backbone, and that backbone has drifted in clear eras. [info.arxiv](https://info.arxiv.org/help/submit_tex.html)

## What “implicit formalization” means here

Think of it as a **constraint system + attractor landscape**, not a single grammar:

| Layer                   | What it constrains                           | How hard                                                                                                    |
| ----------------------- | -------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **Pipeline**            | What will compile and announce               | Hard (reject / fail PDF)                                                                                    |
| **TeX Live pin**        | Which macros/packages/engines exist          | Hard per era                                                                                                |
| **Field attractors**    | Dominant classes, section recipes, bib style | Soft (social)                                                                                               |
| **Venue templates**     | NeurIPS/ICML/ACL/IEEE/AMS… as de facto roots | Soft→hard for authors                                                                                       |
| **HTML path (LaTeXML)** | Semantic macros that survive conversion      | Soft now, increasingly normative [info.arxiv](https://info.arxiv.org/help/submit_latex_best_practices.html) |
| **Harvesting**          | Identifiers, bib shape for INSPIRE etc.      | Soft but rewarded [info.arxiv](https://info.arxiv.org/help/submit_tex.html)                                 |

That stack is enough to produce the empirical regularity you see: same rough spine across papers, with local dialect (macros, theorem stacks, figure workflows) as residual variance. [reddit](https://www.reddit.com/r/MachineLearning/comments/4wjozn/latex_template_for_arxiv_papers/)

---

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

- A detectable **toplevel** with `\documentclass` (compilation from submission root). [info.arxiv](https://info.arxiv.org/help/submit_tex.html)
- **Figures** in a format matching the processor (EPS/PS for DVI-era; PDF/PNG/JPEG for PDFLaTeX) — no on-the-fly conversion. [info.arxiv](https://info.arxiv.org/help/submit_tex.html)
- **Bibliography** as something the system can resolve (legacy: ship `.bbl`; modern Submission 1.5: `.bib` + auto bibtex/biber, or matching `.bbl`). [info.arxiv](https://info.arxiv.org/help/submit_tex.html)
- No junk: aux/log/pdf-from-tex stripped; no embedded JS; tidy tree. [info.arxiv](https://info.arxiv.org/help/submit/index.html)
- Prefer **semantic** macros if you care about HTML (`\section`, `\emph`, `graphicx` alt text) — explicit best-practice layer since HTML papers. [info.arxiv](https://info.arxiv.org/help/submit_latex_best_practices.html)

That is closer to a **RELAX NG “required spine + open expansion points”** than to free-form text. The open points (`\usepackage`, custom `\newcommand`, theorem environments, conference `.cls`) are where idiosyncrasy lives.

---

## Generational eras (the trend you notice)

These are **empirical regimes**, not schema version numbers — but they behave like generations of a living standard.

### Era 0 — Hep-th roots (1991–late 1990s)

- Plain TeX / early LaTeX2ε, `revtex`, hep-style macros, PostScript figures.
- Culture: compact source, email-era portability; arXiv exists _because_ TeX was the compact portable format. [en.wikipedia](https://en.wikipedia.org/wiki/ArXiv)
- Visual: single-column, dense math, minimal hyperref-era chrome.

### Era 1 — Classic AutoTeX + LaTeX2ε consolidation (~2000–2011)

- LaTeX2ε + `article`/`amsart` dominance in math; field classes elsewhere.
- **AutoTeX** as the decades-long compiler brain (guess main file, run latex/bibtex/dvips path). [blog.arxiv](https://blog.arxiv.org/2020/11/12/error-detected-a-new-feature-helps-authors-submit-their-work/)
- Figures: EPS-centric workflows still common; `psfig` still in the wild (later broken). [info.arxiv](https://info.arxiv.org/help/submit_tex.html)
- Bib: **prebuilt `.bbl`** as the social norm (system didn’t want to own bibtex edge cases).

### Era 2 — PDFLaTeX becomes default practice (~2011–2020)

- PDF/PNG/JPEG figures displace EPS for most new work. [info.arxiv](https://info.arxiv.org/help/submit_tex.html)
- `hyperref`, `graphicx`, AMS math stack as near-universal substrate.
- TeX Live jumps (e.g. long **TL 2016** baseline, then **TL 2020**) reset the package universe and quietly break old idioms. [tex.stackexchange](https://tex.stackexchange.com/questions/428277/what-happens-to-arxiv-publications-when-their-texlive-is-updated)
- CS/ML explosion: conference classes (`neurips_*.sty`, `icml`, `acl`, `ieee`) flood the corpus — **venue schema as preprint skin**.

### Era 3 — Dual product: PDF + HTML semantics (2020–2025)

- TL **2023** / **2025** dual support; authors pick a processor generation. [docs.overleaf](https://docs.overleaf.com/troubleshooting-and-support/checklist-for-arxiv-submissions)
- **LaTeXML → HTML papers** (ar5iv lineage → arXiv HTML) adds a second consumer of the same source. [arxiv](https://arxiv.org/html/2605.16562v1)
- Best practices document starts to read like a style guide for _meaning_: standard front matter, alt text, `\section` not font hacks. [info.arxiv](https://info.arxiv.org/help/submit_latex_best_practices.html)
- Biblatex/Biber version coupling becomes a sharp edge (`.bbl` format 3.2 vs 3.3 tied to TL year). [info.arxiv](https://info.arxiv.org/help/submit_tex.html)

### Era 4 — Submission 1.5 (April 2025–)

- **AutoTeX retired** after decades; simpler, more explicit TeX→PDF path. [info.arxiv](https://info.arxiv.org/help/submit_tex.html)
- Bib processing modernized (detect biblatex backend, run biber/bibtex; or use provided `.bbl`). [info.arxiv](https://info.arxiv.org/help/submit_tex.html)
- Author-visible processor choice; `00README` still a control surface. [info.arxiv](https://info.arxiv.org/help/submit_tex.html)
- Net effect: less magical “AutoTeX dialect,” more **declared engine + TL year + tidy sources** — i.e. the implicit schema gets slightly more _explicit_.

You can feel those eras in the PDF chrome alone: fonts, hyperlink boxes, theorem styling, whether DOIs/`arXiv:` ids appear in refs, single- vs double-column conference skins, quality of figure pipelines, presence of ORCIDs/affiliations blocks, etc.

---

## Why commonality is so strong (despite no official template)

arXiv **deliberately** has no mandatory house class — and people still converge. [reddit](https://www.reddit.com/r/LaTeX/comments/1ohehmx/arxiv_paper_template/)

1. **Compiler as type-checker** — only a finite subset of “LaTeX programs” type-check on the pinned TL + pipeline rules. Failed submissions never enter the corpus. [info.arxiv](https://info.arxiv.org/help/submit_tex.html)
2. **Copy-paste genealogy** — advisors’ templates, Overleaf galleries, “arxiv-style” GitHub repos, last year’s NeurIPS kit. Cultural transmission ≈ schema inheritance. [overleaf](https://www.overleaf.com/latex/templates/style-and-template-for-preprints-arxiv-bio-arxiv/fxsnsrzpnvwc)
3. **Venue → preprint pipeline** — submit camera-ready class to the conference, then the same tree (or a lightly de-branded one) to arXiv. The conference DTD-of-the-mind becomes the preprint dialect for that subfield.
4. **Shared macro ecology** — `amsmath` + `graphicx` + `hyperref` + (`booktabs`, `algorithm2e`/`algorithmic`, `cleveref`, `biblatex`|`natbib`) is a de facto standard library.
5. **Second interpreter (LaTeXML)** — packages without `.ltxml` bindings degrade HTML; authors who care drift toward the supported set. That’s selection pressure toward a **semantic subset**. [info.arxiv](https://info.arxiv.org/help/submit_latex_best_practices.html)
6. **Harvesting incentives** — clean `arXiv:YYMM.NNNNN` tokens in refs, single bib file, predictable front matter improve INSPIRE/Semantic Scholar-style extraction. [info.arxiv](https://info.arxiv.org/help/submit_tex.html)

So the “schema” is **evolutionary**: fitness = compiles on arXiv + looks like a paper in my field + (optionally) converts to HTML + cites cleanly.

---

## Mapping back to JATS / TEI / DocBook / DITA

| Concept           | Explicit XML standards               | arXiv TeX corpus                                                                                                    |
| ----------------- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| Normative grammar | DTD/RNG/XSD                          | Pipeline + TL + social attractors                                                                                   |
| Versions          | 1.1 / 1.3 / 5.2…                     | TeX Live years + AutoTeX vs 1.5 + HTML era                                                                          |
| Root element      | `article` / `TEI` / `book` / `topic` | `\documentclass{…}` + toplevel file convention                                                                      |
| Specialization    | DITA domains, TEI ODD, JATS tag sets | Field classes + custom macro packages                                                                               |
| Validation        | Schema-aware editor                  | “Did AutoTeX/1.5 produce an acceptable PDF?” (+ now HTML)                                                           |
| Interchange form  | The XML _is_ the artifact            | `.tex` tree is archival; PDF (and HTML) are projections [info.arxiv](https://info.arxiv.org/help/submit/index.html) |

Your intuition is the right theoretical move: **arXiv TeX is a naturally occurring, weakly typed document language** whose types are proven by compilation and whose dialects cluster by year × field × venue. Corpus datasets (e.g. full-source parquet dumps) make that language empirically recoverable — package-frequency time series, class histograms, section-title topic models, bib engine shifts, figure-format transitions. [tex.stackexchange](https://tex.stackexchange.com/questions/740648/estimate-usage-of-latex-package-in-arxiv-publications)

---

## What a “schema archaeology” of arXiv would look like

If you formalized what you’re already seeing:

1. **Core spine** (near-universal): documentclass, title/author/abstract, sectioning, bib anchor, includegraphics-or-equivalent.
2. **Dialect modules** (field-level): theorem stacks (AMS vs ntheorem vs thmtools), proof environments, algorithm packages, physics unit macros, ML experiment tables.
3. **Era flags**: EPS vs PDF figures; `psfig` absence after TL2016; natbib vs biblatex; hyperref defaults; presence of `\includegraphics[alt=…]`; TL2023 vs TL2025 bbl format.
4. **Binding layer**: which constructs LaTeXML maps cleanly → proxy for “semantic conformance” post-2023. [info.arxiv](https://info.arxiv.org/help/submit_latex_best_practices.html)
5. **Idiosyncrasy residual**: author `\newcommand` graphs, local `.sty`, comment/leak noise (a large fraction of sources carry leftover comments/secrets — another empirical signature of real authoring practice). [linkedin](https://www.linkedin.com/posts/logan-shamberger-59319b228_github-loganshambergerarxiv-utils-arxiv-activity-7486799008523399169-Jku8)

That residual is your “fuzz”; the first four layers are the implicit standard.

---

**Bottom line:** There _is_ an arXiv preprint formalization — it’s just **enacted** (by compilers, pins, templates, and converters) rather than **declared** (as RNG). The multi-decade trend you see is that enactment getting stricter and more multi-target: from “any TeX that becomes PS/PDF” toward “TeX that becomes PDF _and_ structured HTML, under an explicit TL generation, with bib and figures in declared contracts.” [arxiv](https://arxiv.org/html/2605.16562v1)

If you want to push this into something research-shaped next, the highest-leverage cut is a **generational feature matrix** (Era 1–4 × structural traits) or a small empirical sketch from public arXiv source dumps — package/class frequencies by year for cs.LG vs hep-th vs math.AG, for example.
