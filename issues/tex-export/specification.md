# `tex-export` emerging specification

**Status:** provisional and executable

**Established:** 2026-07-24

This document records the current product contract. It is intentionally narrower than a universal
latent-manuscript specification. Conventions will be hardened through implementation and concrete
exports.

The terms **must**, **should**, and **may** express current design strength:

- **must** is required for the first useful exporter;
- **should** is the preferred convention unless implementation evidence argues otherwise;
- **may** is optional or deferred.

## 1. Product contract

`tex-export` must compile a LaTeX project into a Markdown manuscript bundle.

The intended public shape is:

```powershell
Export-TexDocument `
    -LiteralPath <project-or-archive> `
    -TargetRoot <directory> `
    [-Slug <slug>] `
    [-MainFile <relative-path>]
```

The exact parameter sets remain provisional until the SDK is initialized. The contract must
eventually support at least:

- an unpacked project directory;
- an explicitly selected main `.tex` file;
- a supported source archive.

Automatic main-file discovery may be provided, but ambiguity must produce a diagnostic rather than
an arbitrary first-file choice.

## 2. Deliverable layout

Given target root `T` and slug `S`, a successful export produces:

```text
T/S/
├── S-latex.md
└── images/
```

All links in `S-latex.md` must be relative to the bundle root. The bundle must remain valid after
being moved as a directory.

The default bundle must not contain:

- compiler syntax trees or manuscript IR;
- source maps or transformation logs;
- unpacked source;
- `.aux`, `.bbl`, `.bcf`, `.fls`, or TeX logs;
- run stamps, patches, counters, or gauntlet state;
- temporary or renderer-intermediate assets.

Diagnostics are returned through the SDK. An explicit diagnostic-report option may be added later,
but it is not part of the canonical manuscript.

## 3. Meaning of fidelity

The exporter preserves manuscript content, not printing.

It must preserve, when present:

- title and knowledge-bearing front matter;
- abstract and acknowledgements;
- ordered prose and inline content;
- section hierarchy and appendix identity;
- mathematical notation and the distinction between inline and display mathematics;
- definitions, theorems, propositions, proofs, examples, and related semantic blocks;
- ordered and unordered lists;
- tables and their data relationships;
- algorithms, source listings, and other code;
- figures, diagrams, captions, and panel associations;
- footnotes and other manuscript notes;
- citations, bibliography order, and reference content;
- numbering and cross-reference relationships where they contribute to comprehension.

It may normalize or discard:

- pagination, columns, line wrapping, and page breaks;
- float placement;
- font selection, spacing, and decorative rules;
- journal-specific visual styling;
- TeX package and build machinery that has no manuscript meaning;
- redundant authoring constructs whose meaning is represented canonically elsewhere.

The compiler must not silently discard a construct merely because Markdown lacks a literal
equivalent. It must choose a documented convention, externalize an asset, or emit a diagnostic.

## 4. Canonical Markdown surface

The Markdown dialect will borrow deliberately from compatible Markdown flavors rather than inherit
one flavor wholesale. The concrete profile remains under development.

Current fixed conventions are:

- ATX headings are used for manuscript hierarchy.
- Inline mathematics uses `$...$`.
- Display mathematics uses `$$...$$` as a contained block.
- Code is emitted in fenced code blocks with a language identifier when known.
- Images use relative Markdown image links into `images/`.
- The bibliography is a numbered Markdown list under a references heading.

Raw LaTeX is not a general fallback convention for a successful deliverable. During development it
may be retained inside compiler syntax nodes and diagnostics, but leakage of an uncompiled
knowledge-bearing command into final Markdown is an incomplete compilation.

## 5. Mathematical register

Mathematical register is a non-negotiable correctness boundary.

The compiler must:

- parse inline and display mathematics as syntax nodes rather than opaque string matches;
- preserve the inline/display distinction;
- emit deterministic delimiters;
- preserve grouping, scripts, environments, and command boundaries;
- prevent prose transformations from operating inside mathematical nodes;
- prevent mathematical transformations from consuming prose;
- diagnose malformed or unclosed mathematical input;
- support validation of the emitted mathematical surface.

The emerging canonical math language is TeX-like and approximately KaTeX-level, with selected
MathJax-derived capabilities likely to be adopted later. The exporter must not wait for the future
native Markdown math AST before becoming useful.

The desired long-term encoding contains mathematical syntax rather than rendered mathematical
Unicode. For example, `\alpha`, `\in`, and `\leq` are preferred over `α`, `∈`, and `≤` in the
encoded math register. The exact canonical lexicon belongs to a later math specification, but the
exporter architecture must preserve the parsed structure needed to enforce it.

Prose, math, and code masks are derived inspection views over parsed nodes and source spans. They
must not be reconstructed by regular expressions over the emitted document or stored as a second
mutable account of register boundaries. Text-mode islands inside a mathematical node remain nested
within the outer mathematical register.

## 6. Bibliography and citations

The initial bibliography target is intentionally modest:

```markdown
The result follows from [7].

## References

1. A. Author. “First title.” Journal, 2022.
2. B. Author. “Second title.” Publisher, 2023.
```

The compiler must:

- preserve bibliography order and numbering;
- resolve every supported in-document citation to its number;
- preserve citation groups and citation notes when they affect meaning;
- emit enough bibliographic content to identify the cited work;
- place the reference section at the manuscript bibliography location;
- diagnose unresolved keys and bibliography-generation failures.

Citation keys may be retained internally for resolution but need not appear in the Markdown.
Anchored links such as `[7](#ref-7)` are a likely extension, not a first-milestone requirement.

Existing `.bbl` content, inline `thebibliography`, BibTeX, and Biber are source mechanisms rather
than output formats. Compile assistance may be used to produce resolved bibliography input.

## 7. Figures, diagrams, and assets

Assets that carry manuscript content must be represented in document order and stored beneath
`images/`.

The emerging policy is:

1. A mathematical diagram that can be encoded faithfully in the canonical math register should be
   emitted as mathematics.
2. An empirical plot, photograph, or other inherently visual object should be exported as an image.
3. A source diagram that cannot yet be encoded faithfully may be rendered as an image.
4. Composite figures must retain their panels, ordering, captions, and relationship to the main
   caption.
5. A missing or failed asset must produce a diagnostic and must never collapse into an unmarked
   omission.

The terminal image formats, naming convention, raster policy, and handling of original vector
assets remain open. Earlier corpus-specific image rules are evidence, not inherited requirements.

## 8. Project and source closure

The project loader must:

- identify one main document deterministically;
- resolve `\input` and `\include` relative to the including file;
- distinguish active commands from comments and verbatim content;
- detect include cycles;
- report missing files;
- preserve the origin and span of parsed content;
- resolve graphics relative to their source file and declared graphics paths;
- avoid arbitrary recursion-depth truncation.

External listings and other source inclusions are manuscript dependencies and must be compiled or
diagnosed.

## 9. Compilation result and failures

The SDK result must distinguish:

- successful compilation;
- compilation completed with warnings;
- incomplete compilation caused by unsupported or unresolved knowledge-bearing content;
- fatal failure before a manuscript could be compiled.

Diagnostics must have stable codes, severity, message, source file, and source span where
available. They may also carry the syntax node or asset involved.

Validation results should identify the level they establish: source syntax, semantic resolution,
renderer compatibility, structural plausibility, or export completeness. A successful renderer
check must not be reported as proof that a formula is semantically faithful.

The exporter should stage its bundle and promote it only after required validation succeeds.
Overwrite and partial-output behavior remain open decisions.

## 10. First-reference acceptance

For `2607.16621`, the first useful milestone requires:

- a nonempty title and abstract;
- complete authorship/front-matter content under the chosen Markdown convention;
- all body sections and appendices in order;
- all external listings represented as fenced code;
- all supported inline and display mathematics retained and valid;
- all citations resolved;
- the complete numbered bibliography emitted;
- all applicable figures and diagrams represented;
- no raw structural LaTeX commands in the deliverable;
- no unresolved construct hidden from the SDK result;
- only the Markdown file and referenced image assets in the target bundle.
