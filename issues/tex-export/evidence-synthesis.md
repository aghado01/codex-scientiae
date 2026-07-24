# `tex-export` prior-art evidence synthesis

**Status:** provisional research note

**Established:** 2026-07-24

## 1. Purpose

This note mines the earlier LaTeX, PDF, and membrane implementations for evidence about two
questions:

1. What must a mathematical register preserve?
2. What belongs in the latent manuscript envelope?

The prior code is evidence about recurring structures and failure modes. It is not an inherited
contract. In particular, PDF-recovery heuristics, corpus rules, gauntlet artifacts, and the old
exporter's implementation techniques do not become `tex-export` requirements merely because they
already exist.

The new exporter has a stronger source than the PDF lane: explicit LaTeX syntax. It should compile
that syntax directly and use prior inverse-recovery work mainly to identify distinctions that must
remain representable.

## 2. Main conclusions

The archaeology supports the following provisional model:

```text
LaTeX source and build products
            │
            ▼
lossless source syntax ───────► diagnostics and provenance
            │
            ▼
ordered semantic manuscript tree
            │
            ├──► derived register views and inspection projections
            │
            ▼
canonical Markdown + canonical math surface + assets
```

The durable conclusions are:

- The canonical manuscript is an ordered, typed tree with explicit relationships. It is not a
  flattened stream of PDF lines, Markdown fragments, or development JSONL records.
- Prose containers require mixed inline children. An inline formula is an `InlineMath` child among
  text, citations, links, and other inline nodes; it is not a role flag applied to an entire line.
- Mathematical content has at least three distinct representations: source syntax, a normalized
  mathematical structure, and an emitted canonical math surface. The surface serialization is not
  itself the future math AST.
- Prose/math masks are useful projections of parsed nodes and their spans. They should be derived
  from the syntax or manuscript tree, not rediscovered by regular expressions over emitted
  Markdown.
- Source evidence, inference evidence, diagnostics, and provenance must remain distinguishable
  from canonical manuscript content.
- Validation is layered. Syntactic validity, renderer acceptance, structural plausibility, and
  semantic correctness are different claims.
- Figures, tables, equations, citations, references, footnotes, labels, and captions are entities
  connected by relationships. Flattening those relationships into prose loses manuscript
  structure even when all visible words remain.
- A table of contents, byte-span index, register mask, and reader-oriented random-access map are
  derived views over the manuscript and its serialization. They are not competing manuscript
  structures.

These conclusions constrain the compiler without freezing the eventual cross-converter JSONL ABI.

## 3. Mathematical-register findings

### 3.1 Math is an embedded language

The earlier classifier could only infer math at line and glyph-run level. Its records distinguish
`role=math` from prose and attach script classifications to smaller, baseline-shifted runs. That
was appropriate evidence for a PDF, but it exposes why the canonical model cannot use the same
shape: one paragraph routinely alternates between prose and inline mathematics.

The manuscript model therefore needs inline containers with ordered children such as:

```text
Paragraph
├── Text
├── Citation
├── Text
├── InlineMath
└── Text
```

`InlineMath` and `DisplayMath` are host-language nodes whose payload is parsed mathematical
syntax. A visitor may treat that payload as opaque, or cross into the math tree deliberately. This
matches the source/host/math separation developed in
[the math-register note](../latex-math-oracle/sol-math-register.md).

Text-mode content inside mathematics, such as `\text{for all }`, does not erase the outer
mathematical register. Register identity is structural and nestable; it is not a binary
per-character guess.

### 3.2 Nested structure cannot be represented as flat roles

[The PDF math assembler](../../src/pdf-converter/math-assembler.ps1) recursively rebuilds
subscripts and superscripts from size tiers and baseline displacement. Its own boundary is
instructive: nested scripts are tractable in a horizontal “1.5-D” pass, whereas fractions,
matrices, aligned layouts, and rule-bar structures require explicitly two-dimensional structure.

LaTeX source removes the need to infer most of this geometry, but it does not remove the structural
requirement. The compiler's mathematical representation must be able to retain:

- nested groups;
- subscript and superscript attachment;
- fractions, roots, accents, and delimiters;
- arrays, matrices, cases, and aligned rows;
- operators and their limits;
- text-mode islands inside math;
- labels, tags, and numbering relationships;
- unknown commands as addressable syntax with diagnostics.

A flat `{text, role, script}` run sequence is useful evidence but is not a sufficient math tree.

### 3.3 Source syntax, normalized structure, and surface syntax differ

The old LaTeX lane often protected math and restored it verbatim. That avoided prose corruption,
but it also treated source spelling as if it were already canonical. The broader math-oracle work
instead distinguishes:

1. the author's source syntax, including macros and package vocabulary;
2. a resolved or normalized mathematical structure;
3. the canonical TeX-like string emitted inside Markdown delimiters;
4. a future native math AST that may be serialized independently.

The canonical math string is a projection of structure, not the structure itself. This permits the
compiler to preserve source spans and macro provenance while emitting a stable vocabulary.

The historical documents record an instructive evolution here. The earlier retrospective calls
math a verbatim pass-through; the later math-register and Scriba notes call for a written,
validator-backed canonical register shared by every producer. `tex-export` should retain the
former rule's safety property—prose passes cannot corrupt math—without mistaking source-verbatim
spelling for canonical output.

The desired encoding uses mathematical commands rather than rendered Unicode glyphs. The earlier
PDF assembler's policy of retaining Unicode whenever KaTeX could render it is therefore legacy
behavior, not a convention to inherit. Exact command vocabulary remains open and should be learned
through fixtures rather than hard-coded globally at the lexer.

### 3.4 Register masks should be derived

[The old LaTeX helpers](../../src/latex-ingest/latex.ps1),
[normalization pass](../../src/codex-membrane/normalize.ps1), and
[Markdown audit helpers](../../src/audits/md-cleanup.ps1) contain a useful algebra:

- a mathematical-structure mask;
- inline and display math spans;
- the complementary prose mask;
- environment and text-interior spans;
- set-difference checks for unwrapped math.

Those implementations relied heavily on scanning and regular expressions because they operated on
strings. The durable idea is the projection, not the mechanism. With a syntax tree and source
spans, `tex-export` can expose:

```text
MathProjection(document)
ProseProjection(document)
CodeProjection(document)
RegisterAt(sourcePosition)
```

These views can preserve positional alignment for analysis without duplicating another mutable
truth. The emitted Markdown can be masked later from its node-to-output source map if an
output-coordinate projection is required.

### 3.5 Numbering is a relationship system

The old math-bank proposal recorded document order, environment, numbered status, equation
number, canonical math, and neighboring context. The useful lesson is not the sidecar schema; it
is that a displayed equation participates in document order and in a numbering/reference system.

The compiler must eventually account for more than a monotonically increasing equation counter:

- explicit `\tag`;
- `\label`, `\ref`, and `\eqref`;
- section-scoped counters and `\numberwithin`;
- subequations;
- appendix counter changes;
- unnumbered environments;
- theorem and equation counter sharing.

Neighboring prose is already available from the manuscript tree and should not be copied into each
math node merely to make it inspectable.

### 3.6 Validation must say what it established

Existing gates and tests expose four different validation levels:

| Level | Example claim |
|---|---|
| Lexical and syntactic | Delimiters, groups, environments, and alignment structure are well formed. |
| Renderer | The emitted surface is accepted by the selected KaTeX/MathJax profile. |
| Structural plausibility | A formula is not flattened, split, or contaminated by a long prose sentence. |
| Semantic | The expression states the mathematics intended by the manuscript. |

Renderer acceptance is necessary for the chosen surface but cannot prove structural or semantic
fidelity. Conversely, a source construct may be semantically recoverable while still unsupported
by the current renderer profile.

The conversion-metric notes add a useful completeness invariant: pairwise fidelity scores omit
whatever never made it into an aligned pair. A source compiler can do better by accounting for
every active, knowledge-bearing source construct. Each one must map to a manuscript node, an
externalized asset, or an explicit diagnostic. Per-kind coverage and fidelity should be reported
separately so dropping hard content cannot improve an aggregate score.

The previous fidelity inventory already points toward a useful diagnostic design: retain all
issues, distinguish hard failures from warnings, attach source spans, and use specific categories
such as malformed environment, unsupported command, unresolved label, render failure, suspicious
structure, and incomplete compilation. A first-match error or a silent cleanup is insufficient.

## 4. Manuscript-envelope findings

### 4.1 The envelope is an ordered semantic tree

[The zone pass](../../src/codex-membrane/zones.ps1) and
[section pass](../../src/codex-membrane/sections.ps1) reconstruct front matter, body, back matter,
section hierarchy, and semantic section roles from flattened converter output. Their recovery work
reveals structures that LaTeX already supplies directly.

The canonical envelope should preserve:

- document order;
- front-matter properties and blocks;
- a hierarchical section tree;
- ordered block and inline children;
- theorem-like blocks distinct from section headings;
- appendices and their numbering context;
- back-matter content, including acknowledgements and references.

Semantic roles such as `introduction`, `methods`, or `references` may be helpful annotations, but
they must not replace the author's actual title or structural position.

Pages, columns, typography, coordinates, and float placement are source evidence or printing
choices. They are not semantic parent nodes in the manuscript.

### 4.2 Provisional entity vocabulary

The following vocabulary is a working inventory, not an ABI:

| Layer | Candidate entities |
|---|---|
| Document | `Manuscript`, front matter, ordered root blocks, relation tables |
| Block | `Section`, `Paragraph`, `DisplayMath`, `TheoremLike`, `Proof`, `List`, `Table`, `Figure`, `Algorithm`, `CodeBlock`, `Bibliography`, `ReferenceEntry`, `NoteBody` |
| Inline | `Text`, `InlineMath`, `Emphasis`, `Strong`, `CodeSpan`, `Link`, `Citation`, `CrossReference`, `NoteReference`, semantic line break |
| Asset/visual | `Asset`, `FigurePanel`, semantic diagram payload, caption and subcaption |
| Relations | containment/order, label-to-target, citation-to-reference, note anchor-to-body, figure-to-panel, owner-to-caption, counter scope |

This inventory should grow only when a fixture demonstrates a distinct semantic behavior. Source
commands and environments map onto these concepts through binding and semantic handlers; they do
not each require a manuscript-node kind.

### 4.3 Figures retain composition, not print placement

[The earlier figure IR](../../src/pdf-converter/pdfdig-figures.ps1) records bounding boxes,
density, path membership, page, provenance, and attached captions. It also groups regions that
share a caption. That geometry is valuable for PDF recovery but does not belong in a LaTeX-derived
manuscript node.

More importantly, merging regions into one figure can erase panel identity. A canonical figure
should retain, when present:

- figure identity and document position;
- ordered panel children;
- each panel's asset or semantic-diagram representation;
- subcaptions and the main caption;
- label, number, and cross-references;
- alternative text or other semantic annotations when available.

The render class—native math, external asset, or a hybrid—is a per-instance compilation decision,
not a new semantic kind for every backend choice.

### 4.4 Bibliography, citations, notes, and references are relations

A numbered Markdown bibliography is a surface convention. Internally, the compiler still needs to
retain:

- ordered reference entries;
- source citation keys;
- citation groups and notes;
- resolved numeric presentation;
- citation-to-entry relationships;
- label-to-target relationships for equations, sections, figures, tables, and theorem-like blocks;
- note anchors and note bodies.

This allows a first emitter to produce plain numbers while leaving navigable links and alternative
Markdown profiles possible later. It also makes unresolved targets diagnosable without scanning
the emitted Markdown.

### 4.5 Evidence and manuscript content are separate models

[The PDF IR schema](../pdfdig-lane/ir-schema.md) deliberately separates atomic measurements,
derived words, reading-order claims, paths, and envelope metadata. The
[project IR adapter](../../src/codex-membrane/project-ir.ps1) then normalizes several converter
dialects into flatter records. Both are operationally useful, but neither should be mistaken for
the canonical manuscript.

For `tex-export`:

- source text, tokens, syntax nodes, and build products are compiler evidence;
- binding and semantic-resolution results are compiler claims;
- source spans and provenance explain those claims;
- diagnostics record unsupported, ambiguous, or invalid cases;
- the manuscript tree contains the resolved knowledge-bearing document;
- Markdown and assets are projections of the manuscript.

This separation is also the cleanest preparation for a shared PDF/LaTeX ABI. The future PDF
frontend can carry much richer evidence and uncertainty while still targeting the same semantic
node and relationship vocabulary.

### 4.6 Navigation and addressability are derived products

[The LaTeX user notes](../latex/user-notes.md) propose byte spans, a hierarchical table of
contents, and a reader surface for random access. These are valuable requirements, but they should
not force a second document hierarchy.

- The section tree is the semantic hierarchy.
- A table of contents is a projection of that tree.
- Source spans locate compiler input.
- Emission spans locate the serialized Markdown.
- A reader index can map stable semantic identities to source and output spans.

Whether a table of contents or byte index belongs in front matter, an optional sidecar, or only the
SDK result remains an output-profile decision. The clean manuscript bundle should not acquire a
sidecar by default before that contract is settled.

## 5. What should and should not be reused

### Durable ideas worth carrying forward

- lossless tokens and half-open source spans;
- deterministic ordering and stable tie-breaking;
- a full diagnostic inventory rather than one terminal defect;
- explicit unknown syntax and recovery nodes;
- source-file identity across `\input` and `\include`;
- separate binding, counter, label, citation, and asset resolution;
- nested mathematical structure;
- independent parse/render/structural validation;
- source-authoritative figure and caption relationships;
- small fixtures extracted from real failure cases;
- optional compile assistance behind explicit capability adapters.

### Legacy mechanisms or policies not to inherit

- document-wide regular-expression transformations as a parser;
- mutable placeholder stores used to protect regions from later substitutions;
- line-level `role` and `script` records as a manuscript model;
- PDF coordinates, font metrics, clusters, confidence scores, and geometry sketches in the
  canonical manuscript;
- run-stamped repair state, oracle counts, or gauntlet coupling in the export bundle;
- output-string patching as normal compilation;
- renderer acceptance as proof of semantic fidelity;
- silently preserving rendered Unicode in canonical math merely because the renderer accepts it;
- flat counter logic that ignores scope, tags, or subequations;
- collapsing multi-panel figures into one undifferentiated asset;
- corpus publication rules treated as universal Markdown requirements.

## 6. Consequences for `tex-export`

This evidence sharpens the planned compiler stages:

1. **Lossless parse:** retain source files, tokens, trivia, groups, commands, environments,
   verbatim regions, and math boundaries.
2. **Binding:** apply package-aware signatures and argument modes without changing source
   identity.
3. **Resolution:** build project closure, macros within the supported subset, counters, labels,
   citations, bibliography, assets, and declarations.
4. **Semantic compilation:** construct an ordered manuscript tree with mixed-register inline
   children and explicit relations.
5. **Math compilation:** lower source math into a normalized structure, then serialize a
   deterministic canonical surface.
6. **Asset compilation:** choose native, asset, or hybrid representation while preserving figure
   and panel relationships.
7. **Emission:** project the manuscript into Markdown without reparsing or globally cleaning the
   output.
8. **Validation:** report syntax, resolution, render, structure, completeness, and bundle
   integrity separately.
9. **Indexing:** derive optional table-of-contents, register, and byte-span views from stable
   semantic identities and emitter spans.

The internal tree may later inspire `manuscript-ir`, but the first implementation should optimize
for clear compiler semantics and inspectability rather than premature JSONL stability.

## 7. Fixtures that can harden the model

The first model-discovery suite should include:

- a paragraph alternating prose, citations, links, and several inline formulas;
- nested scripts, `\text{...}` islands, fractions, roots, matrices, cases, and aligned equations;
- equation labels, explicit tags, section-scoped numbering, subequations, and appendix resets;
- theorem/proof blocks with shared or independent counters;
- inline `thebibliography`, BibTeX `.bbl`, citation groups, and citation notes;
- a multi-panel figure with main caption, subcaptions, labels, and mixed asset types;
- a semantic diagram that can be emitted as math and one that requires an image;
- complex and spanning tables;
- footnotes and cross-references across included files;
- unknown active commands, malformed nesting, missing assets, and unsupported dynamic TeX.

For each fixture, tests should independently assert syntax shape, manuscript shape, diagnostics,
and Markdown. This prevents an emitter snapshot from hiding a structurally wrong compiler model.

## 8. Evidence map

### Code

- [LaTeX ingest](../../src/latex-ingest/latex-ingest.ps1)
- [LaTeX span and mask helpers](../../src/latex-ingest/latex.ps1)
- [PDF math assembler](../../src/pdf-converter/math-assembler.ps1)
- [PDF math evidence packets](../../src/pdf-converter/math-evidence.ps1)
- [PDF line and run classifier](../../src/pdf-converter/pdfdig-classify.ps1)
- [PDF figure records and grouping](../../src/pdf-converter/pdfdig-figures.ps1)
- [Membrane normalization](../../src/codex-membrane/normalize.ps1)
- [Zone recovery](../../src/codex-membrane/zones.ps1)
- [Section recovery](../../src/codex-membrane/sections.ps1)
- [Project IR normalization](../../src/codex-membrane/project-ir.ps1)
- [Fidelity inventory](../../src/codex-membrane/fidelity.ps1)
- [Markdown cleanup and mask helpers](../../src/audits/md-cleanup.ps1)

### Tests

- [Math assembler tests](../../tests/math-assembler.Tests.ps1)
- [Math evidence tests](../../tests/math-evidence.Tests.ps1)
- [Mask tests](../../tests/masks.Tests.ps1)
- [Render-check tests](../../tests/render-check.Tests.ps1)
- [PDF IR tests](../../tests/pdfdig-ir.Tests.ps1)
- [Figure tests](../../tests/pdfdig-figures.Tests.ps1)
- [Section tests](../../tests/sections.Tests.ps1)
- [Document-spine tests](../../tests/spine.Tests.ps1)

### Design and issue notes

- [Inverse framing](../sol-inverse-framing.md)
- [Math-register design](../latex-math-oracle/sol-math-register.md)
- [Math-bank oracle lane](../latex-math-oracle/math-bank-oracle-lane.md)
- [KaTeX translation notes](../latex-math-oracle/gemini-katex-translation.md)
- [Gated math repair](../pdfdig-lane/gated-math-repair.md)
- [PDF IR schema](../pdfdig-lane/ir-schema.md)
- [Valid-but-wrong gate blind spots](../membrane-fixes/gate-blind-spots-valid-but-wrong.md)
- [Architecture retrospective](../retrospective/architecture-retrospective-20260720.md)
- [Reboot distillate](../src-reorg/sol-reboot-distillate.md)
- [Scriba design charter](../scriba-charter/DESIGN.md)
- [Aligned fidelity scoring](../conversion-metric/aligned-fidelity-scoring.md)
- [LaTeX user notes](../latex/user-notes.md)
