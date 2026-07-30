### Markdown should be a compilation target

Canonical Markdown is excellent for model context, diffs, search, versioning, and human review. But Markdown alone cannot safely carry the entire evidence model.

I would expect each compiled paper to have something conceptually like:

```text
paper/
  source/
    original.pdf
    source.tar.gz
  manuscript.md
  document.ir.jsonl
  notation.json
  provenance.jsonl
  diagnostics.json
  assets/
    figures/
    equation-crops/
```

`manuscript.md` is the high-signal reasoning substrate. The sidecars preserve information that would otherwise pollute the manuscript: page coordinates, extraction lineage, alternative parses, confidence, original expressions, source hashes, and validation results.

### Math must pass through an AST

Canonicalizing math with regexes or Unicode replacement would be too dangerous. The pipeline should be:

```text
source expression
    → parser
    → typed math AST
    → normalization rules
    → deterministic KaTeX-compatible serializer
```

For every expression, retain at least:

- Original serialized expression, if available
- Original visible glyph sequence
- Parsed AST
- Canonical expression
- Source page and bounding box
- Parser/version identity
- Diagnostics and unresolved ambiguities
- Round-trip rendering result

This is where you standardize choices such as:

- `ℝ` versus `\mathbb{R}`
- `φ` versus `\phi` or `\varphi`
- Unicode minus versus `-`
- `\operatorname{rank}` versus italicized `rank`
- Delimiter sizing
- Matrix and cases syntax
- Spacing commands
- Subscript and superscript grouping
- Vector, tensor, scalar, and set typography

But normalization must preserve meaningful distinctions. Blind Unicode NFKC normalization, for example, can collapse distinctions you may care about. Bold versus italic, prime versus apostrophe, minus versus hyphen, and Greek glyph variants can all be semantically relevant.

Also, KaTeX syntax provides stable presentation syntax, not full mathematical semantics. Expressions such as juxtaposition, overloaded operators, and `f(x)` remain context-dependent. A semantic layer may therefore need annotations beyond the KaTeX serialization.

### Byte stability and token stability are different

A deterministic serializer can guarantee that the same AST produces exactly the same Markdown bytes. That is a strong and useful guarantee.

It cannot guarantee identical model tokens across different model families or tokenizer revisions. Exact token stability requires pinning the tokenizer. Nevertheless, canonical byte sequences should greatly reduce incidental token variation and make evaluations reproducible against a pinned model/tokenizer combination.

### Verification should be adversarial

A trustworthy pipeline should verify several independent properties:

- **Visual round trip:** render canonical math and compare it with the source equation crop.
- **Structural agreement:** compare outputs from independent extraction routes.
- **Reference integrity:** equation, theorem, figure, citation, and section references resolve.
- **Notation integrity:** every symbol use is compatible with its local definition and typography.
- **Source alignment:** every canonical block points back to page regions or source spans.
- **Uncertainty accounting:** disagreements become diagnostics, not silently selected output.
- **Reproducibility:** tool versions, configuration, hashes, and normalization rules are recorded.

For high-value equations, consensus between TeX, PDF text extraction, and visual rendering would be substantially stronger than any single route.

### The context substrate should be layered

For synthesis across persistent homology, graph theory, and statistical mechanics papers, merely retrieving paragraphs is inadequate. The compiled corpus should expose typed scientific units:

- Definitions
- Notation declarations
- Assumptions
- Theorems and propositions
- Proofs and proof sketches
- Algorithms and complexity
- Equations
- Experimental claims
- Limitations
- Citations and dependencies

Each paper should preserve its local notation while mapping concepts to corpus-level identities. For example, multiple papers may describe closely related filtration, boundary, Laplacian, persistence, or energy concepts with incompatible symbols. The system should create explicit crosswalks—not rewrite every paper into one notation and erase the differences.

A context compiler could then assemble a reasoning packet containing:

- Relevant definitions and assumptions
- Exact canonical equations
- Dependency-linked theorems
- Cross-paper notation maps
- Contradictions or convention differences
- Provenance pointers
- Source crops only where visual adjudication remains necessary

That is much closer to the substrate needed to design a mathematically defensible `thermomapper` feature. The frontier model becomes the reasoning engine over a verified scientific IR, rather than also being asked to improvise document recovery every time.

The real product of `codex-scientiae`, in that framing, is not PDF-to-Markdown conversion. It is a reproducible compiler from heterogeneous scientific publication artifacts into an auditable, token-efficient mathematical knowledge substrate.

# i dont care about cross-model consistent tokenization, i care about within-model tokenization being as rock-solid consistent as possible. every model tokenizes differently, but whats important for my standard is that each model can read multiple documents written with consistent cross-document tokenization. i just worked on my first draft of my math register spec for the target markdown manuscript `D:\aghado01\codex-scientiae\issues\math-register\math-register-spec.md`

<details><summary>2 previous messages</summary>

> That distinction is clear: you want a canonical byte-level math register so any one model encounters the same notation serialized the same way across every document in the corpus. The tokenizer may differ by model; the corpus must not inject avoidable variation within a model’s own token stream. I’ll read just that draft spec and respond to its treatment of this invariant, without expanding into the rest of the project.
>
> <details><summary>Ran 3 commands</summary>
>
> - Ran `Get-Content -Raw -LiteralPath 'D:\aghado01\codex-scientiae\issues\math-register\math-register-spec.md'`
> - Ran `$p='D:\aghado01\codex-scientiae\issues\math-register\math-register-spec.md'; $lines=Get-Content -LiteralPath $p; foreach($range in @(@(120,260),@(261,420))){ "RANGE=$($range[0])-$($range[1])"; for($i=$range[0];$i -le $range[1] -and $i -le $lines.Count;$i++){ '{0}:{1}' -f $i,$lines[$i-1] } }`
> - Ran `rg -n 'same expression acquires|nuisance variance|register defines|P4|operatorname|Mathematical glyph|surjection|fixed points|tokenization economy|consistent tokenization|semantic equivalence implies lexical identity|The quotient|The register specifies' 'D:\aghado01\codex-scientiae\issues\math-register\math-register-spec.md'`
>
> </details>

</details>

You’re right; I had framed the objective too broadly. Your requirement is corpus-level lexical invariance:

> Within any fixed model/tokenizer, equivalent register forms across all manuscripts should arrive as the same canonical byte sequence—and therefore produce the same token sequence, subject only to surrounding boundary context.

That is independent of whether another model segments those bytes differently.

I read the draft. Its architecture already captures this well, especially:

- The register governs the destination, not conversion heuristics ([§0.1](/D:/aghado01/codex-scientiae/issues/math-register/math-register-spec.md:138)).
- Canonicalization is an idempotent surjection with fixed points and disjoint equivalence classes ([§4.4](/D:/aghado01/codex-scientiae/issues/math-register/math-register-spec.md:263)).
- Ambiguous forms are structurally excluded from the simple mapping store rather than silently resolved.
- Glyph resolution and lexical canonicalization have separate owners ([line 287](/D:/aghado01/codex-scientiae/issues/math-register/math-register-spec.md:287)).
- Conformance and source grounding are correctly separated.

The central invariant could perhaps be stated formally:

```text
For expressions x and y:

x ≡R y  ⇒  serialize(normalize(x)) = serialize(normalize(y))
```

where `≡R` means equivalence under the register’s explicitly declared quotient—not unrestricted mathematical equivalence.

For a fixed tokenizer `T` and canonical framing function `F`:

```text
x ≡R y  ⇒  T(F(normalize(x))) = T(F(normalize(y)))
```

That second formulation also exposes why delimiter, whitespace, and punctuation framing matter: some tokenizers can merge across expression boundaries even when the internal expression bytes are identical.

A few pressure points stood out.

1. **“Semantic equivalence implies lexical identity” is too broad.**
   Algebraically equivalent expressions such as `a+b` and `b+a` should not necessarily serialize identically. I would use “register equivalence” or “equivalence modulo the declared presentation quotient” throughout [line 42](/D:/aghado01/codex-scientiae/issues/math-register/math-register-spec.md:42).

2. **Consistency does not depend on choosing the most token-efficient spelling.**
   Any single deterministic spelling provides within-model consistency. Frequency, familiarity, and token count are secondary criteria for choosing _which_ fixed point wins. Put differently:

   > Consistency is an equivalence-class property; token economy is a canonical-representative optimization.

   This makes the core guarantee independent of speculative claims about model training distributions.

3. **The `\operatorname` → `\mathrm` precedent needs special scrutiny.**
   `\operatorname` creates a math-operator atom and affects spacing and limit behavior; `\mathrm` ordinarily does not. The spec acknowledges this but classifies the difference as furniture ([line 253](/D:/aghado01/codex-scientiae/issues/math-register/math-register-spec.md:253)). That potentially conflicts with P1’s promise to preserve mathematical grammar. It may still be the desired quotient, but it deserves AST- and render-level tests rather than being settled primarily by brevity or paradigm regularity.

4. **Several model-mechanism claims are stronger than necessary.**
   Claims that arXiv frequency and training frequency “agree by construction,” or that shared command prefixes create a shared embedding neighborhood, are plausible intuitions but not guaranteed. The register does not need them. Corpus frequency can simply be described as an empirical proxy, with actual tokenizer measurements used when available.

5. **“Mathematical glyphs must never be raw codepoints” needs a precise domain.**
   Literally, variables, digits, `+`, and `=` are also glyph codepoints. The intended rule appears to be that non-ASCII mathematical symbols—or symbols having a canonical LaTeX control sequence—must use that sequence. Tightening [rule 4](/D:/aghado01/codex-scientiae/issues/math-register/math-register-spec.md:22) would make conformance mechanically decidable.

Overall, though, this is already much closer to the correct abstraction than my initial “semantic IR plus Markdown” framing suggested. The manuscript register is intentionally a narrow lexical contract. The richer evidence and ambiguity model belongs upstream, while the delivered substrate stays small, regular, byte-stable, and predictable for every model consuming the corpus.

# `a+b and b+a` would never be compiled identically because the original source material would only read in one direction. my compiler would be a catastrophic failure if it committed the error of conflating the two readings. consistency was never meant to depend on choosing the most token-efficient spelling. token efficient spelling however, may still be helpful in improving the information signal of the token stream. token efficient spelling is more like one of the underlying rationale for canonicalization

Agreed. I conflated two very different notions of equivalence.

Your compiler’s canonicalization relation is not mathematical equivalence. It is source-faithful representational equivalence:

```text
same reading + same ordered mathematical structure
+ differences only in declared aliases/furniture
→ same canonical serialization
```

Thus:

```text
a + b ≢R b + a
```

Their ordered syntax trees differ, regardless of commutativity. Reordering them would violate grounding and constitute source corruption.

By contrast:

```text
a \ge b
a \geq b
a ≥ b
```

can belong to one register-equivalence class because canonicalization changes the spelling, not the source reading or mathematical structure.

The architecture is therefore:

1. **Grounding preserves the source reading and ordered structure.**
2. **The register removes only declared representational variance.**
3. **Canonical serialization makes that structure lexically regular across documents.**
4. **Token-efficient spelling improves signal density but does not define correctness.**

Your characterization of token efficiency is better: it is one rationale and optimization criterion for canonicalization. Canonicalization provides consistency regardless of which representative is selected; choosing a common, compact, well-trained representative may additionally reduce sequence inflation and improve the mathematical signal-to-token ratio.

A more faithful rendering of your central statement would be:

> Equivalence under the register’s declared representational quotient implies lexical identity, while differences in source reading, ordered syntax, notation-bearing structure, or referential identity must remain distinct.

That preserves the compiler’s primary obligation: normalization may remove nuisance variance, but it must never perform mathematics on the author’s behalf.

> also, your point about `\operatorname → \mathrm precedent needs special scrutiny` is exactly getting at what i'm trying to filter out in my transformation. operatorname injects unnecessary ambiguity that isn't all about math semantics and is more about latex typesetting or formatting. i'm not trying to replicate typesetting, i'm trying to transfer mathematical content accurately, and its the pipeline's job to sort that out

Yes—that clarifies the quotient. I was treating TeX’s internal math-atom classification as though it were necessarily mathematical structure. In your register, it is extraction evidence and typesetting machinery, not automatically manuscript content.

For example:

```latex
\operatorname{Hom}(V,W)
\mathrm{Hom}(V,W)
```

can both be interpreted upstream as the same mathematical reading:

```text
named operator “Hom” applied to V and W
```

and compiled to the single register form:

```latex
\mathrm{Hom}(V,W)
```

The pipeline must preserve:

- The operator’s name
- Its arguments and their order
- Subscripts, superscripts, and binding structure
- Grouping and referential identity

It need not preserve:

- TeX’s `\mathop` atom classification
- Automatic operator spacing
- Display-style limit placement
- The author’s chosen typesetting command

That makes `\operatorname` valuable on input—it is strong evidence that a run is an operator—but inadmissible as an output alternative because it adds another lexical representation and exposes renderer-oriented distinctions that your manuscript intentionally quotients away.

Even a construct such as:

```latex
\operatorname*{arg\,max}_{x \in X} f(x)
```

should be interpreted structurally first: named operator, bound domain, operand. The canonical serializer then chooses the register’s representation while retaining those mathematical relationships and discarding `\operatorname*`’s placement instructions.

So the sharper distinction is:

> TeX grammar is evidence used by the compiler; mathematical grammar is content preserved by the manuscript.

My earlier scrutiny placed too much weight on reproducing TeX behavior. Your target is explicitly not a typesetting-preserving transcription. It is a mathematically grounded normalization in which the pipeline absorbs representational ambiguity so downstream models never have to.

> Exactly, but your clarification is helpful because i was failing to appreciate the value of something like `operatorname` in parsing the source into the target even if it has no place in the deliverable

That suggests an important compiler principle:

> An input construct can be inadmissible in the target while still being valuable evidence during lowering.

`\operatorname` should therefore not be stripped during early cleanup. It should first inform parsing:

```text
\operatorname*{arg\,max}_{x} f(x)
        ↓ source parsing
NamedOperator {
  name: "arg max",
  subscript: x,
  operand: f(x),
  limit_like: true,
  source_form: "\operatorname*"
}
        ↓ register lowering
\mathrm{arg\,max}_{x} f(x)
```

The `source_form` and `limit_like` evidence may remain in provenance or the internal IR even though neither belongs in the delivered manuscript.

This argues for a strict stage order:

1. Preserve raw source tokens.
2. Parse the richest available source dialect.
3. Use typesetting constructs as semantic evidence.
4. Resolve mathematical structure and ambiguity.
5. Lower into the narrower register AST.
6. Canonically serialize and validate.

The dangerous operation is not removing `\operatorname`; it is removing it before extracting what it tells you.

The same principle likely applies to several other constructs:

- `\left`/`\right` can reveal intended delimiter pairing or nesting.
- `\,` can help distinguish a differential or unit boundary.
- `\operatorname*` can reveal limit-like binding.
- Alignment environments can reveal equation structure.
- Font changes can distinguish notation classes.
- Author macros can encode domain concepts before expansion.
- Visual spacing may help recover segmentation even when excluded from the target.

So the source language should be treated as a richer evidentiary dialect, while the register is a deliberately narrower delivery language. Information can be useful to the compiler without deserving representation in the compiled manuscript.

# yes, and notation is critical to accurately encoding and reading math, and this is an emerging tenet of the system i'm trying to build. superscripts, subscripts need to be correctly parsed, mathbb and related family denote notation grounded in proper math semantics, not typesetting

Yes. A strong formulation of that tenet would be:

> In mathematics, typography is sometimes syntax, and notation-bearing typography is semantic content.

The system needs at least three categories:

1. **Notation-bearing structure — preserve**
   - Superscripts and subscripts
   - `\mathbb`, `\mathcal`, `\mathfrak`
   - `\mathbf`, where it identifies vectors or tensors
   - Hats, bars, tildes, primes, stars
   - Delimiter pairing and nesting
   - Operator arguments and binding structure

2. **Source evidence — interpret before lowering**
   - `\operatorname`
   - `\left` and `\right`
   - Alignment environments
   - Semantically suggestive spacing
   - Author-defined macros

3. **Presentation furniture — discard after interpretation**
   - Color
   - Page and line controls
   - Redundant sizing
   - Pure kerning
   - Renderer injection

Scripts particularly require an actual tree. These are not interchangeable strings:

```latex
x_i^2
{x_i}^2
x_{i^2}
x^{i_2}
```

Their attachment and nesting encode different structures. A PDF converter that merely recovers the glyph sequence but attaches a script to the wrong base has produced valid-looking, renderable, mathematically incorrect output.

Similarly, the internal representation of a symbol should resemble:

```text
Symbol {
  base: "F",
  alphabet: "mathcal",
  weight: null,
  accents: [],
  subscript: ...,
  superscript: ...
}
```

rather than treating `\mathcal{F}` as a styled `F`. The decorated symbol is the identifier. Stripping `\mathcal` can collapse two distinct objects and destroy conventional information that helps a reader infer whether something is a family, filtration, sheaf, sigma-algebra, or another structured object.

The converter should not overinterpret that convention—`\mathcal{F}` does not universally mean one particular kind of object—but it must preserve the notation so the surrounding definitions can ground its actual referent.

That yields another useful principle:

> Preserve every distinction that affects how a mathematical reader identifies, binds, or relates objects; discard only distinctions that affect how the renderer paints an already-determined reading.

This makes notation recovery part of semantic fidelity, not a downstream formatting pass.

# macro expansion is also a critical foundation of the transfer process

Absolutely. Macro expansion is the bridge from an author’s private mathematical dialect into the shared register.

An author macro often carries three things simultaneously:

- A surface abbreviation
- Structural mathematics
- Semantic evidence in its name and definition

For example:

```latex
\newcommand{\R}{\mathbb{R}}
\newcommand{\norm}[1]{\left\lVert #1 \right\rVert}
\DeclareMathOperator{\rank}{rank}
```

should lower approximately as:

```text
\R
  → decorated symbol {base: R, alphabet: mathbb}
  → \mathbb{R}

\norm{x}
  → paired norm delimiters around x
  → \lVert x \rVert

\rank A
  → named operator “rank” applied to A
  → \mathrm{rank}\,A
```

The crucial point is that expansion must happen before information-destroying canonicalization. The pipeline should retain both the invocation and its expansion long enough to use all available evidence:

```text
macro invocation
+ resolved definition
+ expanded token structure
+ source location
        ↓
semantic/source AST
        ↓
register lowering
        ↓
canonical manuscript form
```

The deliverable contains no author macros, but the internal evidence ledger should preserve:

- Original macro name
- Definition used at that source position
- Arguments
- Expanded tokens or AST
- Definition provenance—preamble, package, included file, local scope
- Expansion diagnostics
- Canonical output span

A macro name such as `\Hom`, `\Ker`, `\coker`, `\vect`, or `\boundary` can help adjudicate the meaning of an otherwise ambiguous expansion. Like `\operatorname`, it may be excluded from the target while still being valuable source evidence.

This cannot safely be implemented as string replacement. Correct expansion requires handling:

- Nested and balanced arguments
- Optional arguments and defaults
- Definition order
- Local scopes and redefinitions
- `\newcommand`, `\renewcommand`, `\def`, and `\DeclareMathOperator`
- Recursive expansion and cycle detection
- Package-provided macros
- Expansion inside superscripts, subscripts, and environments
- Whitespace and control-word termination
- Macros whose expansion changes token grouping

Expansion must also be hygienic and bounded. TeX is programmable enough that unconstrained expansion can involve conditionals, category-code changes, file access, recursion, and shell escape. A scientific transfer compiler therefore needs either a deliberately supported macro language or a sandboxed, pinned TeX expansion engine with limits and source tracing.

The important ordering is:

1. Construct the source-position-sensitive macro environment.
2. Expand author and package macros into structured tokens.
3. Preserve the expansion trace.
4. Parse notation and mathematical relationships.
5. Lower source-only constructs.
6. Canonicalize register aliases and furniture.
7. Serialize and validate.

That makes macro expansion more than preprocessing. It is semantic de-aliasing: eliminating document-local vocabulary while retaining the mathematics that vocabulary was created to express.
