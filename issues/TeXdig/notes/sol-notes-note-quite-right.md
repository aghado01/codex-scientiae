# im going to stop you right there. i'm rebooting because i think i can do it more cleanly starting from unified and utensils. i believe alot of things im doing now are messy because i am not doing it right and indeed the approach has been rather blind and adhoc

Right—that changes the framing completely. This should be a clean compiler-style reboot, not a refactor of `latex-ingest.ps1`.

The old implementation should serve as:

- A behavioral oracle: tests, recovered documents, expected Markdown, math audits.
- A corpus of discovered edge cases.
- A source of domain rules: reference semantics, math aliases, evidence/patch conventions.
- Occasionally, an algorithm worth reimplementing.

It should not determine the new internal architecture. In particular, I would not carry forward the masks, placeholder stores, regex brace parsing, global script state, or the ordering constraints created by successive string rewrites.

## The clean architecture

Because unified-latex and latex-utensils are Node libraries, make the new parsing and IR core TypeScript. PowerShell can remain the batch/orchestration boundary.

```text
Source project
    ↓
Source graph
    ↓
Parser ASTs
    ↓
Elaborated syntax
    ↓
Semantic IR
    ↓
Resolution graph
    ↓
Markdown and sidecars
```

### 1. Source graph

Start with the entire LaTeX project rather than a single flattened string:

```typescript
interface SourceProject {
  id: string;
  entrypoint: SourceId;
  sources: Map<SourceId, SourceFile>;
  includes: IncludeEdge[];
  bibliographyResources: BibliographyResource[];
  diagnostics: Diagnostic[];
}

interface SourceFile {
  id: SourceId;
  path: string;
  text: string;
  sha256: string;
}
```

Preserve `\input` and `\include` boundaries even if you offer an assembled traversal view. Flattening too early destroys scope and provenance.

Explicitly define positions as UTF-16 offsets if you use JavaScript parser positions:

```typescript
interface SourceSpan {
  sourceId: SourceId;
  startUtf16: number;
  endUtf16: number;
}
```

Then original LaTeX is always a source slice—not reconstructed output.

### 2. Keep the parser ASTs external

Use:

- unified-latex for `.tex`, `.bbl`, and LaTeX fragments inside bibliography fields.
- latex-utensils for `.bib`.
- Small adapters to present both through common source IDs, spans, diagnostics, and node IDs.

Do not translate every unified-latex node into an identical home-grown AST. That would just create a second parser model you must maintain.

```typescript
interface ParsedSource {
  sourceId: SourceId;
  language: "latex" | "bibtex";
  parser: "unified-latex" | "latex-utensils";
  root: unknown;
  nodeIndex: Map<NodeId, unknown>;
}
```

Your IR begins where parser syntax stops being sufficient.

## The central addition: elaboration

The source AST remains unexpanded. Elaboration records what an invocation means under a particular macro environment:

```typescript
interface MacroDefinition {
  id: MacroDefinitionId;
  name: string;
  signature: ArgumentSignature;
  body: SyntaxNodeRef[];
  origin: SourceSpan;
  scope: ScopeId;
  declarationOrder: number;
  dialect:
    | "newcommand"
    | "xparse"
    | "math-operator"
    | "paired-delimiter"
    | "let"
    | "def"
    | "configured";
}

interface MacroInvocation {
  id: MacroInvocationId;
  name: string;
  arguments: SyntaxNodeRef[][];
  origin: SourceSpan;
  scope: ScopeId;
}

interface Expansion {
  id: ExpansionId;
  invocation: MacroInvocationId;
  definition: MacroDefinitionId;
  environmentFingerprint: string;
  result: DerivedSyntaxNode[];
  diagnostics: Diagnostic[];
}
```

The expansion is an overlay, not a replacement. That lets a consumer choose between:

```text
author surface:  \norm{x}
expanded syntax: \left\lVert x\right\rVert
semantic form:   Norm(x)
```

All three are valuable.

Unified-latex can perform the mechanical substitution, while your layer records:

- Which invocation was expanded.
- Which definition governed it.
- Which result nodes came from the definition body.
- Which result nodes came from each invocation argument.
- Nested expansion ancestry.
- Cycles, unsupported forms, and budget exhaustion.

## A deliberately small semantic IR

I would avoid designing a universal document ontology initially. Begin with the entities your pipeline demonstrably consumes:

```typescript
interface DocumentIR {
  project: ProjectId;
  blocks: BlockId[];

  sections: Map<SectionId, Section>;
  paragraphs: Map<ParagraphId, Paragraph>;
  math: Map<MathId, MathNode>;
  environments: Map<EnvironmentId, EnvironmentNode>;
  floats: Map<FloatId, FloatNode>;

  labels: Map<LabelId, LabelDeclaration>;
  references: Map<ReferenceId, ReferenceSite>;
  citations: Map<CitationId, CitationSite>;
  bibliography: Map<BibKey, BibliographyEntry>;

  macroDefinitions: Map<MacroDefinitionId, MacroDefinition>;
  macroInvocations: Map<MacroInvocationId, MacroInvocation>;
  expansions: Map<ExpansionId, Expansion>;

  diagnostics: Diagnostic[];
}
```
