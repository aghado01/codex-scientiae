Every semantic entity carries an origin:

```typescript
type Origin =
  | { kind: "source"; span: SourceSpan; syntaxNode?: NodeId }
  | {
      kind: "expansion";
      expansion: ExpansionId;
      invocation: MacroInvocationId;
      definition: MacroDefinitionId;
      argument?: number;
    }
  | { kind: "synthetic"; rule: string; inputs: EntityId[] };
```

That common origin system is more important than making every entity descend from one elaborate base-node class.

## Math becomes straightforward

Math is discovered by unified-latex before any placeholder machinery is needed:

```typescript
interface MathNode {
  id: MathId;
  mode: "inline" | "display";
  origin: Origin;

  sourceSyntax: NodeId;
  rawContentTex: string;

  expandedSyntax?: ExpansionViewId;
  expandedTex?: string;

  semanticExpression?: MathExpression;
  normalizedTex?: string;

  diagnostics: Diagnostic[];
}
```

Your existing math-store rules and KaTeX audit can become downstream passes over these nodes. They no longer need to rediscover math boundaries from a transformed Markdown-like string.

## BibTeX joins the same graph

BibTeX parsing should not become a competing document parser:

```text
latex-utensils BibTeX AST
    ↓
BibTeX value resolution
    ↓
unified-latex field-fragment parsing
    ↓
shared macro elaboration
    ↓
BibliographyEntry IR
```

A field can retain every meaningful stage:

```typescript
interface BibliographyField {
  name: string;
  origin: SourceSpan;

  bibtexExpression: BibValueNodeRef;
  bibtexResolvedText?: string;

  latexSyntax?: NodeId;
  expandedLatex?: ExpansionViewId;

  semanticValue?: unknown;
}
```

Citation sites, bibliography entries, and rendered references should remain separate entities.

## Pass structure

Make passes explicit and mostly immutable:

```typescript
interface IrPass<Input, Output> {
  name: string;
  run(input: Input, context: PassContext): Output;
}
```

---

# yea im not going to lock in the end to end right now. i want to install the new node dependencies, which means updating brewery and pinning, deploying to `packages`. then i want to see what they give me

### What the live probes revealed

Unified-latex gives you:

- Explicit `inlinemath`, `displaymath`, `mathenv`, `environment`, `macro`, `group`, comment, whitespace, and string nodes.
- Offsets plus line/column positions on parsed source nodes.
- Macro/environment argument attachment from configurable xparse signatures.
- Visitor ancestry, containing-array information, and math-mode context.
- Matchers for macros, environments, groups, and inline/display math.
- Raw-like serialization through `printRaw`.

A custom environment worked directly:

```javascript
getParser({
  environments: {
    lemma: { signature: "o" },
  },
});
```

This attached `[Named]` as the lemma’s optional argument.

One subtlety: `match.math()` covers inline and display delimiters, but not `type: "mathenv"`. Equation/align-style environments need the environment predicate or a `mathenv` test. Their descendants correctly receive `inMathMode: true`.

### Macro behavior

The two-pass experiment worked:

```text
discover definitions
→ construct signature registry
→ reparse with signatures
→ collect expansion-ready definitions
→ expand
```

It discovered both:

```latex
\newcommand{\pair}[2][d]{(#1,#2)}
\NewDocumentCommand{\wrap}{m}{[#1]}
```

and expanded:

```latex
\pair{x}       → (d,x)
\pair[y]{z}    → (y,z)
\wrap{q}       → [q]
```

It did not discover `\def`, as expected.

A particularly useful finding: nested macros expand one level per call.

```latex
\aaa{x} → \bbb{x} → [x]
```

So the old workflow’s bounded fixed-point beat remains necessary, but it can now operate over AST expansion rather than global string replacement.

Also, expansion mutates the AST. A source tree must be cloned or retained separately.

### Source fidelity caveat

Unified-latex is source-aware but not a fully lossless CST:

- A macro node’s position covered the control sequence itself, not all attached arguments.
- Generated `Argument` wrappers sometimes had no position, although their content nodes retained source positions.
- `printRaw` normalized newlines and emitted forms such as `x_{1}` for source `x_1`.
- Expanded nodes carried mixed positions: definition-body nodes pointed into the definition, while substituted nodes pointed into the invocation argument.

That mixed provenance is actually useful, but original LaTeX should still come from source slices. `printRaw` is an AST serialization, not exact source recovery.

### BibTeX behavior

Latex-utensils produced typed, located nodes for:

- Ordinary entries.
- `@string`.
- `@preamble`.
- Text, numeric, abbreviation, and `#` concatenation values.
- Entry keys and ordinary `crossref` fields.

For example:

```bibtex
journal = jmlr # " Supplement"
```

became a `concat` containing an `abbreviation` and a `text_string`, each with its own offsets.

It parses these expressions but does not resolve `@string`, concatenation, or `crossref`; those remain small semantic passes for us.

Passing a parsed title value such as:

```latex
A {Macro-Rich} $E=mc^2$ Result
```

into unified-latex immediately exposed the brace group and inline-math subtree. So the intended BibTeX → LaTeX-fragment composition works in practice.

### Verification

- Canonical and deployed lock hashes are identical.
- `npm ls --depth=0` reports every exact pin.
- Focused infrastructure test passed 3/3: [Pester result](D:/aghado01/codex-scientiae/artifacts/test-runs/node-dependencies-20260809/pester-jobs/node-dependencies-42237150f14a/pester.xml)
- No probe code was committed; the experiments were in-memory.
- The install’s `whatwg-encoding` warning comes from the pre-existing `node-tikzjax → jsdom` chain, not these new dependencies.

---
