Saturday 2:59 AM
So I need to clarify the math AST. It is a not fully formed idea for formally embedding and standardizing the math register in markdown, and it would be a lexical/syntactic over roughly the intersection or perhaps union of latex and mathjax. pdfdig will never be a math AST, it will only help transform documents into it should it ever make it that far. But the math AST proper would be Markpig's domain and it would be a sibling AST with powershell/roselyn visitor nested/interop semantics and api abstractions just like markpig itself. Which brings me to my next question, which is the implied target "je ne sais quoi" standardized math register and the reasons why its important. my goal is to have every drop of math in line and blocks delimited and renderable with unwaivering consistency so that maths can be tokenized consistently and the register self-evident. furthermore, as a hypothetical RAG substrate, i'm imagining a dual RAG application with embedding models separately for math register and prose, somehow cross referenced / addressed, with masking over one or the other to ensure positional alignment

Saturday 10:21 PM
Yes—then I placed the AST one layer too low. pdfdig should produce grounded evidence and candidate math spans; Markpig owns the formal mathematical language, parser, syntax tree, visitors, canonicalization, and renderer projections.

The implied target is something like a canonical embedded mathematical register: a formally specified language island inside a Markdown manuscript.

The missing middle layer
There are really four distinct objects:

Layer Responsibility
pdfdig evidence Glyphs, geometry, typography, reading-order hypotheses, provenance and uncertainty
Manuscript host Markdown structure with explicit, addressable inline/block math spans
Canonical math surface A versioned, deterministic TeX-like serialization
Markpig Math AST Tokens, syntax nodes, visitors/rewriters, diagnostics, renderers and equivalence operations
The canonical surface is not itself the AST. It is the one stable textual representation of an AST—the math equivalent of a formatter’s canonical output.

A host MathSpanSyntax could reference a sibling MathSyntaxTree. A normal Markpig visitor may treat it as an opaque embedded-language node, while a nested visitor explicitly crosses into the math tree. Source maps compose across that boundary:

PDF glyphs → pdfdig span → Markdown MathSpanSyntax
→ Markpig MathSyntaxTree
→ canonical math text
That gives the PowerShell/Roslyn interop model a clean ownership boundary.

Intersection versus union
I would not define the language directly as either the intersection or union of LaTeX and MathJax.

MathJax is primarily an input-processing/rendering ecosystem, while LaTeX is a macro-programming and typesetting language. Their literal intersection is too weak; their union inherits macros, package behavior, renderer extensions, ambiguity, and substantial non-mathematical typesetting machinery.

A better construction is:

a closed canonical core grammar;
versioned extension namespaces for constructs outside the core;
importers for TeX/LaTeX, MathJax-TeX, perhaps MathML;
renderer capability profiles such as katex, mathjax, and latex;
an explicit unsupported or opaque-extension node rather than silent degradation.
Thus Markpig might accept many source dialects, but serialize one canonical dialect:

parse(source dialect) → Math AST
canonicalize(AST) → canonical math surface
lower(AST, renderer) → renderer-specific expression or diagnostic
The desired invariant is approximately:

parse(serialize(AST)) ≡ AST
—not “the same input string works accidentally in several renderers.”

What makes the register a register
Delimiters alone are necessary but insufficient. The profile needs enforceable invariants:

Every mathematical span is explicitly typed as inline or display.
No mathematical material exists outside a registered span.
No ordinary prose is swallowed into math without an explicit textual node.
Every span lexes and parses under a declared grammar version.
Canonical serialization is deterministic.
Required render profiles succeed, or the span carries a precise capability diagnostic.
Author macros are expanded, declared in a scoped environment, or retained as explicit extension nodes.
Equation labels, tags, references, and identities are metadata—not incidental visual characters.
Every canonical token maps back to source evidence.
Original surface text and uncertainty survive canonicalization.
I would distinguish at least four independent statuses:

fenced Is the register boundary known?
parsed Does the grammar accept it?
rendered Can the required renderer lower it?
grounded Is it faithfully supported by source evidence?
A perfectly fenced, parsed, and rendered equation can still be the wrong equation. That final distinction is essential for pdfdig.

The importance of the standard register is that downstream systems no longer have to rediscover modality. Tokenizers, embedders, linters, renderers, diff tools and repair agents can all rely on the same boundary and grammar. It changes “math-looking text” into an addressable language.

The dual-RAG idea
The clean abstraction is one canonical manuscript spine with two projections.

Let the ordered document be:

# D

P
0

 
M
0

 
P
1

 
M
1

 
P
2
⋯
D=P
0
​
M
0
​
P
1
​
M
1
​
P
2
​
⋯
where each $P_i$ is prose and each $M_i$ is an addressable math span.

The prose projection is:

P0 <math:m0:inline> P1 <math:m1:block> P2
The math projection is something like:

m0 → canonical tokens + AST + section/context links
m1 → canonical tokens + AST + section/context links
Both projections are generated from the same span ledger. That ledger—not token masking—is what guarantees positional alignment.

Masking alone cannot do it reliably because prose and math embedding models will tokenize differently, normalize whitespace differently, and produce unrelated vector positions. Instead, every object should carry stable external coordinates:

id: doc:1810.02906v1#math-17
host_ordinal: 231
kind: display
parent_section: doc:1810.02906v1#section-3.1
previous_span: prose-46
next_span: prose-47
label: eq:nld
source:
page: 3
glyph_ids: [...]
canonical_hash: ...
ast_hash: ...
diagnostics: [...]
Then the application has:

a prose vector space indexed by prose chunks containing math sentinels;
a math vector space indexed by canonical expressions, AST-derived features or subtrees;
one address graph connecting both to the manuscript spine.
The vector spaces should remain separate. Their raw similarity scores are not comparable; retrieval results can be joined through addresses and combined through calibrated rank fusion.

This supports several retrieval modes:

Conceptual query → retrieve prose, then expand to linked equations.
Formula query → retrieve structural math matches, then expand to explanatory prose.
Mixed query → retrieve from both and prefer results occupying the same section or neighboring spans.
Symbol query → use an exact AST/token index first, embeddings second.
Definition/use query → follow identifier and equation-reference edges through the address graph.
For example, “Why is $d_{NLD}$ a metric?” naturally decomposes into:

math retrieval for the defining expression and triangle inequality;
prose retrieval for the surrounding argument;
a join on their shared section and neighboring span IDs.
One caution: math cannot be context-free in retrieval
A mathematical embedding of $x$ is nearly worthless by itself. Even substantial expressions often depend on nearby prose for symbol definitions, hypotheses and domain declarations.

So I would use dual vector stores but a unified relational substrate. Each math record should carry:

enclosing section path;
preceding definition-like prose;
following explanatory prose;
referenced equation IDs;
identifier declarations and uses;
theorem/proof context when known.
Markpig can eventually provide multiple identities for the same expression:

canonical surface hash;
exact AST hash;
alpha-renamed structural hash;
operator/signature fingerprint;
renderer-normalized representation.
Those support progressively looser retrieval without conflating lexical and mathematical equivalence.

Why this matters beyond rendering
The real payoff is not merely unwavering $...$ and $$...$$. It is that the manuscript becomes a polyglot, projection-preserving document:

human-readable as Markdown;
formally traversable as two nested syntax languages;
consistently tokenizable;
separately embeddable by modality;
cross-addressable without relying on fragile character offsets;
auditable back to PDF evidence;
repairable without reparsing the whole document;
comparable against a LaTeX oracle at exact syntax-unit granularity.
That is the “je ne sais quoi”: not a better Markdown convention, but a language-service boundary for mathematical manuscripts.

The concise formulation may be:

Markpig manuscripts are ordered, addressable prose and mathematical language islands. The mathematical register has one canonical surface form, a sibling syntax tree, explicit renderer profiles, and composable source mappings. Prose and mathematics may be projected into independent retrieval spaces without losing their shared document coordinates.

That seems both technically coherent and much closer to what you are actually building than “PDF-to-Markdown converter.”

Saturday 10:26 PM
I dont know that spans need to be explicitly typed, part of my design is to keep the register as minimal as possible which means not alot of structural/container/metadata tagging syntax. prose-within-math is one exception i cant avoid. But I think for example inline e.g. embedded math-in-prose is self-evidently unambiguous by virtue of the $..$ delimiter formatting, save for edge cases where dollar signs mean something in the prose, as well as mathbb and other things are unavoidable because notation is essential

Saturday 10:31 PM
Yes—I think you’re right, and I conflated two different layers: the delivered manuscript register and the converter’s internal evidence model.

The manuscript itself does not need explicit type=prose, type=math, or custom span containers. Markdown and LaTeX already form a self-typing grammar:

Prose is the default register.
$...$ changes into inline math.
$$...$$ changes into display math.
\text{...} temporarily returns to prose inside math.
#, blank lines, lists, tables, and image syntax express the limited document structure that actually survives the transfer.
Literal dollar signs are a canonicalization problem, not a fundamental ambiguity: the converter can emit \$5, while reserving unescaped $ exclusively for math.

Likewise, \mathbb, \mathcal, \mathbf, accents, scripts, and operators are not disposable “printing.” They are notation-bearing typography. $\mathbb{R}$ and $R$ may denote different objects; bold may distinguish vectors; roman letters may distinguish operators, units, or differentials. The principled quotient is therefore:

Discard presentation-only typography, but retain typography that changes token identity, mathematical grammar, or referential identity.

That gives a useful dividing line:

Layer Representation
Manuscript Minimal Markdown plus semantic LaTeX; no custom typing syntax
Extraction evidence Optional, sparse, out-of-band record of unresolved boundaries and competing assemblies
The evidence layer need not contaminate the manuscript. It could be a transient JSONL ledger keyed to manuscript offsets or stable anchors, consumed by the MCP and deleted entry-by-entry as ambiguities are resolved.

This also changes how I would describe the gauntlet failures. They are not primarily failures to assign the right span type. They are failures to reconstruct the right boundaries and relations:

A\_{ij} should have been reattached at a particular position in a prose line and enclosed by $...$.
A summation glyph, limits, and baseline expression should have been assembled into one $$...$$ block.
A body sentence should not receive a # boundary merely because it contains a bookmark title.
A superscript is not a separately typed span; it has an attachment relation to a base.
So the lean internal object may be closer to a relation graph than a typed document tree:

glyph/word atoms;
candidate adjacency and ordering;
script, fraction, row, and containment relations;
boundary decisions such as join, space, paragraph break, inline-math transition, display-math transition, or heading break;
competing alternatives only where the evidence does not decide.
Most edges would be ordinary continuation edges and require no annotation. HDBSCAN and persistence then help propose stable components and alternative partitions without forcing those components to become permanent semantic containers.

The benchmark can also remain independent of explicit stored types. Parse both minimal manuscripts using the same Markdown/LaTeX grammar and compare:

boundary placement;
canonical math token sequences or parse trees;
heading sequence and depth;
prose order;
referential identities;
unmatched or duplicated material.
The most important pdfdig metric becomes false boundary confidence: when it inserted $, $$, #, or a paragraph break, how often was that decision contradicted by the oracle? And when it was wrong, did the ambiguity ledger retain enough evidence for repair?

A compact formulation of your register might therefore be:

Prose by default; math by delimiter; prose-in-math by \text; notation-bearing typography preserved; structural syntax only where the manuscript grammar requires it; uncertainty kept outside the manuscript.

That is substantially cleaner than a richly typed manuscript IR. The “envelope” is not extra markup around everything—it is the minimal manuscript plus a sparse residual evidence surface.

Saturday 10:33 PM

, so

Environment

Changes
+1,572
-15

Local

main

Commit or push

Compare branch

Sources
Web search

View all
