# `tex-export` architecture

**Status:** accepted direction; details will be validated during initialization

**Established:** 2026-07-24

## 1. Architectural objective

`tex-export` is a conventional compiler exposed as a PowerShell SDK.

```text
LaTeX project
    │
    ▼
Project loading and source closure
    │
    ▼
Lexer → lossless syntax tree
    │
    ▼
Argument binding and semantic resolution
    │
    ▼
Manuscript model
    │
    ▼
Markdown emitter and asset pipeline
    │
    ▼
Validation and atomic bundle promotion
```

The implementation is split by responsibility:

- PowerShell owns the public SDK, orchestration, filesystem behavior, capability discovery, and
  process adapters.
- C# owns lexical analysis, parsing, syntax, semantic compilation, diagnostics, and Markdown
  generation.

This division retains a PowerShell-native product while using the .NET platform for compiler work
that benefits from strong types, immutable syntax structures, efficient character access, and
explicit visitor APIs.

## 2. Proposed source layout

```text
src/tex-export/
├── TexExport.psd1
├── TexExport.psm1
├── README.md
├── build.ps1
├── Public/
│   ├── Export-TexDocument.ps1
│   └── ConvertFrom-TexSource.ps1
├── Private/
│   ├── Resolve-TexExportCapability.ps1
│   ├── Invoke-TexCompiler.ps1
│   ├── Invoke-TexBuildAssist.ps1
│   └── Write-TexExportBundle.ps1
├── Compiler/
│   ├── TexExport.Compiler.csproj
│   ├── Source/
│   ├── Lexing/
│   ├── Syntax/
│   ├── Parsing/
│   ├── Binding/
│   ├── Manuscript/
│   ├── Markdown/
│   ├── Assets/
│   └── Diagnostics/
└── fixtures/
```

Names are provisional until the initial module skeleton is compiled.

Build products should be placed in a predictable ignored directory during development and in a
module `lib/` directory for a packaged installation. The module manifest should load the compiler
assembly explicitly rather than compile C# source during module import.

## 3. PowerShell SDK rules

The public module must follow normal PowerShell SDK conventions:

- use a module manifest with an explicit `FunctionsToExport` list;
- expose a small command surface with approved verbs;
- implement public commands as advanced functions with `[CmdletBinding()]`;
- use typed parameters, `Validate*` attributes, and `-LiteralPath` semantics;
- use parameter sets where input modes are mutually exclusive;
- support `ShouldProcess` for operations that replace or promote filesystem output;
- write objects to the success stream, not presentation text;
- use verbose, warning, information, and error streams for their intended purposes;
- produce terminating `ErrorRecord` instances for command failure;
- avoid `Write-Host` in SDK behavior;
- never change the caller's working directory;
- never use mutable script-global stores as compiler state;
- keep each invocation reentrant and isolated;
- pass cancellation and invocation context explicitly;
- make filesystem and process boundaries injectable for tests;
- use UTF-8 without BOM for textual outputs.

The root module must import a fixed, reviewable set of implementation files. Wildcard dot-sourcing
must not determine module behavior implicitly.

Public result objects must be stable and PowerShell-friendly. At minimum:

```text
TexExportResult
├── Status
├── Source
├── MainFile
├── Slug
├── BundlePath
├── MarkdownPath
├── Assets
├── Diagnostics
└── Statistics
```

The SDK must not require callers to parse console output.

## 4. Native compiler boundary

The compiler core uses only the .NET base class libraries at runtime. It does not depend on a
third-party LaTeX parser.

The core is not intended to reproduce the full TeX execution model. It implements a bounded,
lossless parser for conventional academic LaTeX and reports constructs outside its supported
language.

### 4.1 Source model

`SourceText` owns immutable source content and file identity. All tokens and nodes carry a
`TextSpan` into that source. Line and column positions are derived rather than stored redundantly.

Project composition retains source-file boundaries; `\input` is not implemented by concatenating
unattributed strings.

### 4.2 Lexer

The lexer is a deterministic state machine, not a set of global substitutions. It recognizes:

- text and whitespace trivia;
- control words and control symbols;
- opening and closing groups;
- optional-argument delimiters;
- comments;
- parameter markers;
- alignment and row-separator tokens;
- inline and display math shifts;
- environment boundaries;
- verbatim regions through explicit lexer modes;
- end of file and malformed-token diagnostics.

Tokenization must retain original text and trivia so that unknown syntax remains inspectable.

Regular expressions may be used for bounded leaf validation or normalization after syntax has been
identified. They must not define nesting, source inclusion, environment structure, mathematical
boundaries, or manuscript semantics.

### 4.3 Syntax parser

The parser constructs a lossless concrete syntax tree containing generic constructs before any
manuscript interpretation:

```text
CompilationUnit
├── Text
├── Group
├── Command
├── Environment
├── InlineMath
├── DisplayMath
├── Comment
└── Verbatim
```

The parser must:

- use explicit cursor and token lookahead;
- parse balanced nesting recursively;
- recover after malformed input where a stable boundary exists;
- attach skipped or unexpected tokens to diagnostics rather than delete them;
- represent unknown commands and environments generically;
- preserve source spans through recovery.

### 4.4 Argument binding

TeX tokenization does not by itself determine LaTeX command arguments. Argument binding is a
separate pass driven by a versioned command/environment signature registry.

A signature describes such properties as:

- starred variants;
- optional and required arguments;
- argument modes such as text, math, verbatim, key-value, or file path;
- whether an environment body is prose, math, tabular, code, or opaque;
- whether a command introduces a label, citation, asset, or source dependency.

Package support is extended by adding signatures and semantic handlers, not by changing the lexer.

### 4.5 Semantic compilation

Semantic passes resolve syntax into manuscript concepts:

- preamble and front matter;
- section hierarchy and appendices;
- prose and formatting;
- mathematical spans;
- declarations and macro use within the supported subset;
- labels, counters, and references;
- citations and bibliography;
- figures, diagrams, tables, and captions;
- lists, theorems, proofs, algorithms, and code;
- project and asset dependencies.

Unknown syntax remains addressable through its source node and produces a diagnostic when it
affects manuscript content.

### 4.6 Manuscript model

The compiler requires a typed internal manuscript model to separate source interpretation from
Markdown emission. This model is an implementation boundary, not a frozen cross-converter ABI.

It should contain only concepts needed to compile the current export faithfully. It may evolve as
fixtures expose new requirements.

The model is an ordered tree, not a line or chunk stream. Block containers own ordered block
children; prose-bearing blocks own ordered inline children. Inline mathematics is therefore an
`InlineMath` child among `Text`, `Citation`, `CrossReference`, `Link`, and related nodes rather than
a role flag attached to an entire string. Display mathematics is a block node. Both mathematical
node kinds retain parsed mathematical structure behind their canonical surface.

Relationships that are not simple containment remain explicit: labels target semantic nodes,
citations target reference entries, note anchors target note bodies, figures own ordered panels and
captions, and counters have scopes. Source spans, provenance, and diagnostics accompany compiler
objects but are not emitted as manuscript prose.

A provisional shape is:

```text
Manuscript
├── FrontMatter
├── Blocks
│   ├── Section
│   ├── Paragraph
│   │   └── Text | InlineMath | Citation | CrossReference | ...
│   ├── DisplayMath
│   ├── TheoremLike | Proof
│   ├── List | Table | Figure
│   ├── Algorithm | CodeBlock
│   └── Bibliography | ReferenceEntry
└── Relations
    ├── Labels and references
    ├── Citations
    ├── Notes
    └── Numbering scopes
```

This vocabulary is deliberately provisional. New kinds require a semantic distinction
demonstrated by a fixture, not merely a new LaTeX command or Markdown rendering strategy.

The default product does not serialize this model. Optional development inspection can be added
without making IR files part of the bundle.

### 4.7 Markdown emission

The emitter walks manuscript nodes and writes canonical Markdown. It must not parse its own output
with cleanup substitutions to recover structure that was available in the syntax tree.

Formatting decisions belong in named emitters and policy objects. Output construction should use
structured writers and explicit whitespace rules rather than concatenated global rewrite passes.

## 5. Compile-assistance adapters

Some facts are best obtained from a real TeX toolchain:

- bibliography products and ordering;
- resolved labels and counters;
- actual project dependencies;
- rendered TikZ, xy-pic, EPS, or other graphics.

These are capability adapters, not parser dependencies. The SDK discovers them explicitly and
reports their absence when a requested capability requires them.

Candidate products include:

- `.aux` for citations, labels, and counters;
- `.bbl` for resolved reference content;
- `.bcf` for Biber workflows;
- `.fls` for actual input and asset closure;
- logs for missing files and undefined references.

Adapters must:

- avoid shell escape by default;
- use bounded execution and isolated working directories;
- capture exit codes and diagnostics;
- never make compiler semantics depend on console-text scraping when a structured product exists;
- expose a test seam so fixtures do not require external executables.

Archive extraction and rasterization follow the same adapter pattern.

## 6. Dependency policy

### Runtime compiler core

The lexer, parser, semantic compiler, and Markdown emitter depend only on the .NET platform shipped
with the supported PowerShell runtime.

Third-party NuGet packages are not introduced into the core without a recorded architecture
decision.

### PowerShell module

The module depends on the compiler assembly and PowerShell itself. It should not require Node,
Python, or a globally installed module merely to parse an unpacked LaTeX project.

### Optional capabilities

TeX engines, bibliography processors, archive tools, and image rasterizers may be required for
specific source features. They remain explicit adapters with capability diagnostics.

### Unified LaTeX

[Unified LaTeX](https://siefkenj.github.io/unified-latex/index.html) is permitted only as
development and differential-test tooling.

It may:

- generate comparison syntax fixtures;
- provide a second parse for selected source specimens;
- reveal disagreements requiring investigation;
- help assess coverage of package signatures.

It must not:

- be imported by the production SDK;
- define the public AST or manuscript model;
- be required to run ordinary compiler tests;
- make its own Markdown conventions normative.

Generated neutral fixtures should be checked in so routine tests remain dependency-free.

## 7. Testing architecture

Testing is layered:

1. **Lexer fixtures** assert exact token kinds, text, trivia, and spans.
2. **Parser fixtures** assert tree shape, nesting, recovery, and diagnostics.
3. **Binding fixtures** assert command signatures and argument modes.
4. **Semantic fixtures** assert manuscript nodes and relationships.
5. **Emitter fixtures** assert canonical Markdown for small constructs.
6. **Project fixtures** assert includes, bibliography, assets, and complete bundles.
7. **Differential fixtures** compare selected parses with Unified LaTeX without treating either
   output as automatically correct.
8. **Reference exports** exercise real manuscripts such as `2607.16621`.

The existing repository Pester runner may drive SDK and integration tests. Native compiler tests
should be callable without requiring a third-party .NET test framework; this can be revisited if
the value of one outweighs the dependency cost.

The historical gauntlet is not the initial development harness. Selected cases may be promoted into
small, focused fixtures as specific language coverage is implemented.

## 8. Reuse boundary

The following may be adapted from `latex-ingest` after isolated review:

- TeX snippet compilation knowledge;
- PDF/EPS-to-image conversion adapters;
- TikZ and xy-pic rendering experience;
- KaTeX render validation;
- curated examples and expected outputs;
- well-defined archive handling that survives independent tests.

The following are not reused as architecture:

- sequential document-wide regular-expression rewrites;
- mutable global placeholder stores;
- output-string patching as ordinary compiler behavior;
- arbitrary include-depth limits;
- first-match main-file, bibliography, or asset selection;
- run-directory layout in the public deliverable;
- gauntlet-specific patch and repair orchestration.
