# The Math Register — Forward Specification (sketch)

**Status:** draft sketch, 2026-07-26. **This is a forward spec for the post-reboot register, not documentation of the current build.** Everything in `src/` is a tentative first attempt and is treated here as *evidence* — useful where it converged on something right, and explicitly overridden where it didn't. Where this spec and the current code disagree, **this spec is the intent** and the code is a migration delta (Appendix A).

Mined from the conversational record rather than from the implementation: `issues/latex-math-oracle/sol-math-register.md`, `MarkBrain/MarkPig/enhancements/math-ast-keystone.md`, `MarkBrain/codex-scientiae/gemini-standards-discussion.md`, `issues/math-register/discussions/gemini-katex-translation.md`, `issues/math-register/discussions/sol-math-register-20260726.md` (register equivalence, the source-evidence tier, the glyph-rule domain), `.legacy/docs/STANDARDS.md` §1–§4.

---

## Conformance language

**MUST** / **MUST NOT** are absolute requirements of a conforming manuscript. **SHOULD** indicates a strong default that may be overridden with a stated reason. **MAY** is optional. (RFC 2119 sense.)

Sections are marked **normative** (binding rules) or **non-normative** (rationale, method, history). *Why this exists*, §9, and both appendices are **non-normative** — read them for context, never cite them as a rule. §0–§8 are **normative**, except where an item is explicitly marked open.

## The contract in brief

Normative summary for an agent or converter that needs the rules without the argument. Each line links to its section for the reasoning and edge cases.

1. Inline math **MUST** be `$…$` on a single line; display math **MUST** be `$$` alone on its own lines (§3).
2. No mathematical material **MUST** appear outside a span; no prose **MUST** appear inside one without `\text{…}` (§3).
3. A literal dollar in prose **MUST** be `\$`; unescaped `$` is reserved exclusively for delimiters (§3).
4. Non-ASCII mathematical symbols **MUST** be written as their LaTeX control sequences — `\Omega`, not `Ω`; ASCII letters, digits, and ASCII operators remain literal (§5).
5. Notation-class alphabet macros — `\mathbb`, `\mathcal`, `\mathfrak` — **MUST NOT** be stripped (§4.1, §8.1).
6. Upright/weight macros **MUST** use one form per meaning: `\mathrm{…}` operator names (`\operatorname` canonicalizes to it, P4), `\mathrm{d}` differentials, `\mathbf{v}` vectors, `\text{…}` prose (§4.1).
7. Presentation-only typography — color, manual spacing, sizing, redundant grouping — **MUST** be removed (§4.2).
8. Equivalent spellings **MUST** be canonicalized to one form: `\geq`, `\to`, `\frac`, `\mathbb{R}` (§4.3).
9. Author macros **MUST** be fully expanded; none survive into the manuscript (§3).
10. `\text{…}` **MUST NOT** contain nested `$` (§3).
11. Detached equation numbers **MUST** be reattached as `\tag{N}` (§8-numbering).
12. Diagrams **MUST** be encoded semantically — 1-D as inline arrows, 2-D as `\begin{array}`; `\begin{CD}`, `tikzpicture`, `tikzcd`, `xymatrix` **MUST NOT** appear (§6).
13. Every span **MUST** parse and render under KaTeX (§7).
14. All content I/O **MUST** be UTF-8 without BOM (§7).

Conformance is checkable on a manuscript alone — provenance is irrelevant (§0.1).

## Why this exists

*(non-normative)*

A mathematical manuscript in this corpus is not prose that happens to contain symbols. It is a **polyglot document**: two languages interleaved at sentence granularity, one of which — mathematics — is normally handled as opaque text by every tool in the chain. The register is the **data contract** for that second language: a canonical form specifying what a conforming document looks like, so that every producer emits the same target and every consumer can rely on it.

The technical term for the central property is **canonicalization**: mapping many equivalent surface forms onto one normal form. The equivalence in play is **register equivalence** — sameness under the register's *declared representational quotient* — never mathematical equivalence. `\ge`, `\geq`, `\geqslant` and `≥` are one concept differing only in spelling and must serialize one way; `a+b` and `b+a` differ in source reading and ordered structure, and collapsing them would be source corruption, not normalization. The register removes declared spelling variance only — **it never performs mathematics on the author's behalf.** Nearly everything below follows from that single property.

The reasons fall into four groups: what it does for a model reading the document, for retrieval, for the engineering pipeline, and for downstream tooling. The fifth section covers the hard problem the register has to solve to deliver any of it.

### A. Raw glyphs are inadmissible

Not a matter of taste. Glyphs are ambiguous along at least four independent axes:

1. **Homoglyphs** — U+2212 MINUS, U+002D HYPHEN and U+2010 HYPHEN are visually identical and semantically distinct; likewise U+00D7 `×` against the letter `x`, U+03BF omicron against Latin `o` against digit `0`, U+2223 DIVIDES against U+007C PIPE. Identical appearance, different identity.
2. **Semantic overloading** — one glyph, many meanings, resolvable only by context. `·` is multiplication, composition, or a placeholder; `|` is absolute value, conditional probability, set-builder separation, or divisibility.
3. **Provenance corruption** — the codepoint that arrives is not necessarily what was authored. A broken `ToUnicode` map delivers `k` where `‖` was written (§5). The glyph is ambiguous about *its own identity*, and no amount of downstream reasoning recovers what the font table destroyed.
4. **Normalization instability** — Unicode has multiple normal forms, and NFC/NFD/NFKC can alter or collapse mathematical characters. A glyph is not guaranteed to survive a round trip unchanged.

A control sequence has none of these properties. `\Omega` is unambiguous, self-identifying, normalization-stable, and cannot be silently corrupted into a different symbol.

**The decisive argument, however, is about tokenization, and it holds even when the model reads the glyphs correctly.**

Language models do not consume characters; they consume tokens produced by a fixed segmentation algorithm (typically byte-level BPE) that was fitted once to a training corpus and is never adapted afterward. Three consequences follow for raw mathematical glyphs:

- **Tokenization instability.** Rare Unicode codepoints fragment into multiple byte-level tokens, and the segmentation can shift with surrounding context. `\Omega` is a stable, high-frequency sequence appearing in millions of arXiv documents; `Ω` in mathematical position is comparatively rare and segments less predictably.
- **Undertrained tokens.** A token can exist in the vocabulary while being nearly absent from training data, carrying a poorly-conditioned embedding and producing anomalous behavior — the "glitch token" phenomenon. *Weight this modestly:* common Unicode math symbols do appear in training data (Wikipedia, plain-text mathematics), so they are not undertrained in the acute sense, and this is unlikely to be the dominant mechanism here. It is a real effect at the exotic end of the glyph range, not a general indictment. The two bullets above carry the argument; this one supports it.
- **Sequence inflation and attention dilution.** One symbol fragmenting into several tokens lengthens the sequence and spreads attention mass across fragments that individually mean nothing. This consumes context budget and degrades exactly the long-range reasoning that mathematical documents demand.

The consequence compounds into the central problem: **the same expression acquires different token representations depending on how it was encoded.** Those representations share neither attention patterns nor embedding neighborhoods, so the model has no structural basis for treating them as the same object. It must infer the equivalence, which is expensive and unreliable.

A document that *mixes* glyphs and control sequences is worse than one consistently using either, because no stable convention is ever established. Every span imposes a **format-inference burden** before any mathematical reasoning can begin — capacity spent recovering what the encoding should have made explicit. In machine-learning terms this is **nuisance variance**: variation in the input that is irrelevant to the task, that the model must learn to marginalize out, and that therefore costs sample efficiency at training time and reliability at inference time. Canonicalization removes it at the source rather than asking every consumer to absorb it.

**The invariant, stated precisely.** What the register guarantees is *corpus-level lexical invariance within a model*: for register-equivalent expressions `x ≡R y`,

```text
serialize(normalize(x)) = serialize(normalize(y))        byte identity, unconditional
T(F(normalize(x)))      = T(F(normalize(y)))             token identity, for any FIXED tokenizer T and framing F
```

Byte stability and token stability are different guarantees. The serializer delivers identical bytes outright; identical tokens follow *per model* — every model segments the corpus differently, but each one sees the same expression spelled the same way in every document it reads. Cross-model token agreement is a non-goal. The framing function `F` matters because some tokenizers merge across expression boundaries even when interior bytes are identical — the delimiter and whitespace discipline of §3 is what stabilizes those boundaries.

### B. What canonicalization buys retrieval

The corpus is not only read end-to-end; it is *searched*. Retrieval systems are acutely sensitive to surface variation, and the standard mitigation is **index-time normalization** — canonicalize once when ingesting, rather than applying heuristics at every query.

- **Exact-match search works.** A query for `\|x\|_2` finds documents that would otherwise have written `||x||_2`, `∥x∥₂`, or a font-corrupted variant. Without ingest-time canonicalization, every one of those becomes a separate query-time special case.
- **Hashing and deduplication become meaningful.** Canonical form lets an expression be hashed, so near-duplicate detection, cross-paper theorem matching, and equivalence classes over expressions are all tractable. `\ge` versus `\geq` defeats exact hashing entirely.
- **The dual-space embedding is coherent.** The design projects a manuscript into two vector spaces — prose and mathematics — joined through a shared address graph. That only means anything if one expression has one representation; otherwise two encodings of the same formula occupy unrelated positions in the math space, and the retrieval scores are noise.

### C. What canonicalization buys the pipeline

These are ordinary software-engineering properties, and they are what make the rest of the system testable.

- **Determinism and idempotence.** A canonical target means conversion is idempotent: `normalize(normalize(x)) = normalize(x)`, and the same input always yields byte-identical output. Without this you cannot tell whether an output change came from an input change or from converter nondeterminism.
- **Diffability, and a well-defined benchmark.** This is the strongest engineering argument. Grading a converter against a reference requires knowing whether a difference is an *error* or merely a *different-but-equivalent encoding*. With a canonical target that distinction is decidable and the metric is well-defined; without one, the benchmark silently measures formatting noise alongside extraction quality. **A canonical target is a precondition for measuring conversion fidelity at all.**
- **Failure localization.** Explicit, addressable spans mean a render failure names the span that failed. Mathematics dissolved into prose fails diffusely — you learn the document is broken, not where — and diffuse failures cannot be repaired incrementally.
- **A narrow waist.** With *N* producers (PDF geometry, LaTeX source, HTML, future lanes) and *M* consumers (renderers, embedders, linters, benchmarks, agents), every consumer would otherwise need to handle every producer's idiosyncrasies: an *N×M* integration surface that grows quadratically. A canonical intermediate form collapses this to *N+M* — producers target the register, consumers assume it. This is the hourglass architecture that IP occupies in networking and that an IR occupies in a compiler, and it is the structural reason the register is worth specifying independently of any one tool.

### D. What canonicalization buys downstream tooling

Every markdown parser in existence treats `$…$` as opaque leaf text. Math structure therefore gets re-derived downstream, repeatedly, by regex and heuristic — which is most of what the current repair machinery *is*.

A specified register is the precondition for stopping that. Once the language is pinned down, math can be parsed once into a structured tree and then **operated on** rather than pattern-matched: linted against a grammar with real error locations, rewritten programmatically, compared by tree-edit distance instead of string diff, lowered to different render targets, and traced back to source evidence token by token. That is the `mathdig` programme (§9), and this document is its language definition.

The general principle is standard: **structured data enables tooling; unstructured data forces every consumer to re-parse.** The register is what converts mathematics from the second category into the first.

### E. Secondary benefits

- **Token economy.** LaTeX is dense. The same matrix costs a fraction of the tokens it would as an HTML table, ASCII art, or MathML — leaving more context budget for content.
- **Human auditability.** A consistent form makes anomalies visually obvious when eyeballing the corpus. Heterogeneous formatting hides defects in noise.
- **Accessibility.** Properly delimited, semantically encoded math can be converted to MathML, speech, or braille. Glyph salad cannot.
- **Provenance.** Addressable spans with stable coordinates let every claim be traced back to the page and glyphs it came from — the basis for auditability and reproducibility.

### F. The hard problem — boundaries in interleaved prose

Everything above assumes we can say where the mathematics *is*. Delivering that is the register's genuinely difficult obligation, and it is a distinct problem from encoding.

Mathematics in papers is not confined to display blocks — it is interleaved with prose at sentence granularity, and the boundary is where the difficulty concentrates.

The hard class is **operator-words**: tokens that are legitimate mathematics in one position and ordinary English in another. `log`, `max`, `min`, `sin`, `det`, `ker`, `arg`, `gcd`, `mod`, `exp`, `dim`, `lim`, `sup`, `inf`, `Re`, `Im` — every one of them is both. Single letters are worse: `a`, `I`, `e`, `d` are variables, constants, differentials, articles, and pronouns depending on the sentence.

Failure runs in both directions and both are defects:

- **Under-fencing** — `log n` left bare in prose when it should be `$\log n$`.
- **Over-fencing** — the word "log" in "log file" swallowed into a math span.

What makes this class genuinely hard is that it is **not resolvable from local geometry or typography**. In a PDF, `log` in a formula and `log` in a sentence can carry identical font, size, and baseline evidence. The distinguishing information lives in the surrounding sentence, which is precisely the signal geometric and clustering methods discard.

### G. Where adjudication enters

This is the principled home for reasoning-agent adjudication in the next-gen MCP, and it slots into the existing resolution ladder rather than adding a mechanism: deterministic rules first, clustering and arbiter evidence next, **agent adjudication only for the residue that is provably not decidable from geometry**, then safe degradation.

The operator-word class is the canonical member of that residue. A well-calibrated, contextually primed reasoning model is the right instrument for it for one specific reason: **it has access to the sentence, which is the only place the answer lives.** That is not a general license for model judgment — it is a narrow assignment to the cases where the deterministic layers are structurally blind, and every adjudication should be recorded as evidence that feeds the tier-0 rule set (§9.1), so the residue shrinks over time rather than becoming a permanent dependency.

Stated in general terms: the escalation ladder is an application of **least-privilege** to inference. Each tier is given only the cases the tier below it provably cannot decide, so the expensive, non-deterministic, hardest-to-audit component handles the smallest possible share of the work — and its outputs are captured as training signal for the cheap deterministic layers rather than consumed and discarded.

### Summary

The register is worth specifying because it converts mathematics from a formatting concern into an **addressable, canonical, machine-checkable language** embedded in the manuscript. That single change is what makes the corpus reliably readable by a model, coherently searchable, mechanically gradable, incrementally repairable, and open to tooling that does not yet exist — and it is why the specification is worth pinning down independently of any particular converter that targets it.

## 0. What this governs

The **delivered manuscript** — the markdown a reader or a model consumes. Not:

- the converter's internal evidence model (geometry, candidate spans, competing assemblies) — out-of-band, must never contaminate the manuscript;
- the math AST and its canonical surface form — downstream, MarkPig's domain, specified by this register rather than specifying it;
- cross-paper notation harmonization — the register canonicalizes the *spelling* of each author's notation, never the notation itself; mapping related concepts across papers is a library-plane crosswalk concern, and rewriting papers into one shared notation is explicitly not a goal;
- publication logistics.

**Minimal by design.** No custom span typing, no container metadata, no structural markup beyond what the host grammar already requires. Markdown plus semantic LaTeX is already self-typing; a typing layer on top would be redundant.

### 0.1 This is a target standard, not a conversion procedure

The register defines **what a conforming manuscript is** — a property of the destination format, invariant across every source document, lane, and converter. It is never document-local, and it never says "depending on the source, do X or Y."

That draws a hard line:

| The register specifies | The converter decides |
|---|---|
| the admissible target vocabulary — one canonical form per concept | which target form a given source construct maps to |
| that operator names are written `\mathrm{…}` | that this particular upright run *is* an operator name |
| that prose inside math is written `\text{…}` | that this particular italic run *is* prose |
| that a glyph is written as its control sequence | which glyph a given PDF codepoint actually was |

Every rule below is stated as a property of the target. Conformance is therefore checkable on a manuscript alone, with no reference to its provenance — which is what makes the register a standard rather than a pipeline convention, and what lets independent lanes (pdfdig, texdig, membrane) be graded against one target instead of three.

## 1. The language is standard LaTeX. KaTeX is a gate, not a target.

This distinction is load-bearing and was blurred in earlier drafts:

> **KaTeX is a rendering engine, not a syntax standard.**

The register's language is **arXiv-native standard LaTeX**, chosen because that is the distribution every consuming model was trained on and because it is token-dense and structurally unambiguous. KaTeX's role is to be the **conformance gate**: a span that KaTeX cannot render is rejected. That is a *constraint on which LaTeX is admissible*, never a license to emit KaTeX-specific constructs.

Consequences, both directions:

- KaTeX-only extensions (`\htmlClass`, `\color`, HTML injection) are **inadmissible** — they are renderer artifacts, not mathematics.
- Constructs KaTeX cannot render are **excluded from the manuscript** even when they are legitimate mathematics (see §6 on diagrams and tiers) — but they are excluded *explicitly*, with a flag, never by silent degradation.

## 2. Governing principles

> **P1 — The quotient.** Discard presentation-only typography. Retain typography that changes token identity, mathematical grammar, or referential identity.

> **P2 — Boundaries.** Prose by default; math by delimiter; prose-in-math by `\text{}`; uncertainty kept outside the manuscript.

> **P3 — Canonicalization by meaning, not by string.** One concept, one spelling. Accept many surface forms on input; emit exactly one. The quotient is representational, never mathematical: normalization removes declared spelling variance only — it never reorders, simplifies, or evaluates, and must not perform mathematics on the author's behalf.

> **P4 — Among interchangeable forms, the more common one is canonical.** Where competing forms are semantically interchangeable under P1, the spec pins the form that dominates in the wild. Frequency in LaTeX source at large is the working proxy for frequency in model training data (arXiv is a major component of math training corpora); the two tend to agree, and the premise is checkable by direct tokenizer measurement rather than taken on faith. The guarantee never rests on it: **consistency is an equivalence-class property — any fixed representative delivers it — while the choice of representative only optimizes signal density.** Because the criterion is mechanical, these choices need no litigation; the only judgment call is the prior P1 question of whether the residual difference between the forms is notation or furniture. Where dominance is not obvious at face value, the tie-break cascade of §4.3 applies — paradigm regularity, vocabulary minimality, tokenization economy, then empirical measurement — so litigation, when needed at all, proceeds by counting rather than by argument. Worked precedent: `\operatorname{…}` → `\mathrm{…}` (§4.3).

> **P5 — The register must be reachable by every lane.** A rule that only one converter can structurally satisfy is not a target standard, it is a lane-specific convention. Where a distinction is recoverable from LaTeX source but not from PDF geometry, the canonical form is the one **both** can reach — even at the cost of discarding information the source lane had. Otherwise conformance stops being lane-agnostic (§0.1) and the lanes cease to be comparable.

When a case is unclear the question is never "does this look better" but **"would two different objects collapse into one if this were removed?"**

## 3. Register boundaries

| Construct | Form |
|---|---|
| Inline math | `$…$`, single line, never split across a line break |
| Display math | `$$` alone on its own line, body, `$$` alone on its own line |
| Prose inside math | `\text{…}` — the only sanctioned re-entry to prose register |
| Literal dollar in prose | `\$` — unescaped `$` is **reserved exclusively** for math delimiters |

Invariants:

1. No mathematical material exists outside a registered span. A bare `π(Z) ≥ c₀` in prose is a defect.
2. No prose is swallowed into math without an explicit `\text{}`.
3. **No nested `$` inside `\text{}`.**
4. Macros are **fully expanded** — no author macros survive into the manuscript. (Expansion is semantic de-aliasing and precedes any information-destroying canonicalization; order and evidence handling in §4.5.)
5. Math in table cells is delimited like any other inline math.

Span kind is **not** tagged. The delimiter is self-evident; `type=` metadata would violate §0.

## 4. Notation versus furniture

### 4.1 Retained — notation-bearing

Stripping these is semantically destructive.

- **Alphabet-selecting macros, notation class** — `\mathbb`, `\mathcal`, `\mathfrak`. **Retained unconditionally.** These are read as notation, not as styling: $\mathbb{R}$ is the reals, $\mathcal{F}$ is a filtration/sheaf/σ-algebra, $\mathfrak{g}$ is a Lie algebra. The convention holds whether or not the same document also uses the bare letter. **See §8.1–§8.2 — this reverses current code.**
- **Upright and weight macros** — `\mathrm`, `\mathbf`, `\mathsf`. These are notation in the target, but the target assigns **one form per meaning** so the macro is never ambiguous in a conforming manuscript:

  | Meaning | Target form |
  |---|---|
  | operator / function name | `\mathrm{Hom}` (see §4.3 — `\operatorname` maps *to* this) |
  | differential | `\mathrm{d}x` |
  | vector / tensor | `\mathbf{v}` |
  | unit | `\,\mathrm{m}` |
  | prose | `\text{…}` (§3) — not a math alphabet at all |

  A conforming manuscript therefore contains no `\operatorname` (it canonicalizes to `\mathrm`, P4/§4.3) and no `\mathrm` standing in for prose (prose is `\text{…}`); both are non-conforming regardless of what the source did.
- **Accents naming a distinct object** — `\hat{x}`, `\bar{x}`, `\tilde{x}`, `\dot{x}`, `\vec{x}`, `x^*`, `x'`
- **Scripts** — `A_{ij}`, `x^2`, `\partial_t`
- **Operators and named functions** — predefined commands `\sum`, `\int`, `\lim`, `\sup`, `\ker`, `\dim`, `\log` are canonical as-is; operator names lacking a predefined command are written `\mathrm{…}` (P4 — `\operatorname` canonicalizes to `\mathrm`, §4.3)
- **Relations, arrows, delimiters** — `\leq`, `\to`, `\mapsto`, `\|`, `\langle`, `\lVert`
- **Grammar-bearing grouping** — `\frac{}{}`, `\sqrt{}`, `\binom{}{}`
- **Structural environments** — `aligned`, `array`, `cases`, `pmatrix`, `bmatrix`

### 4.2 Removed — furniture

| Class | Examples |
|---|---|
| Renderer injection | `\color`, `\textcolor`, `\htmlClass`, `\style` |
| Manual spacing | `\vspace`, `\hspace`, `\quad` as layout, `\!` and `\,` as visual kerning |
| Sizing | `\displaystyle` inline, `\large`, `\big`/`\Big` when not disambiguating nesting |
| Line/page control | `\newline`, `\noindent`, `\smallskip` |
| Redundant grouping | `{{x}}`, `\left(`/`\right)` where sizes already match |
| OCR spacing artifacts | `\frac { d + 1 } { 2 }` |

**Test:** if two spans differ only by §4.2 members and render identically, they must serialize identically. This is what makes the register consistently tokenizable — the entire point of the exercise.

### 4.3 Alias canonicalization (P3)

Many surface spellings, one concept, one emitted form:

| Accepted on input | Canonical output |
|---|---|
| `\ge`, `\geq`, `\geqslant` | `\geq` |
| `\to`, `\rightarrow` | `\to` |
| `\frac`, `\dfrac`, `\over` | `\frac` |
| `\R`, `\mathbb{R}` | `\mathbb{R}` |
| `\operatorname{Hom}`, `\mathrm{Hom}` | `\mathrm{Hom}` |

Note the last row: **the canonical target is the decorated form.** A pass that strips `\mathbb` runs the canonicalizer backwards.

**Selection rule for the canonical form.** Where several spellings are semantically identical, the canonical target **SHOULD** be the one most frequent in arXiv LaTeX. This is not an aesthetic preference — it aligns canonicalization with token health by construction. Undertrained tokens are a property of *rare* vocabulary entries, so canonicalizing toward the dominant spelling moves the corpus toward the well-conditioned region of any tokenizer's vocabulary rather than away from it. The two criteria do not compete, provided the selection rule is applied deliberately. The division of labor is exact: **consistency is an equivalence-class property; token economy is a canonical-representative optimization.** The core guarantee holds whichever representative wins; frequency and tokenization only decide *which* fixed point to crown.

**The worked precedent: `\operatorname{…}` → `\mathrm{…}`.** The two forms differ only in typesetting-level operator classification (`\operatorname` sets the atom as `\mathop` and adjusts spacing). Under P1 that residue is furniture, so the forms are interchangeable — and P4 then pins the commoner one: `\mathrm`. The register maps `\operatorname{Hom}` **to** `\mathrm{Hom}`, not the reverse. This is canonicalization in practice, and it is the template for every future dilemma of the same shape: first ask which side of the P1 quotient the residual difference falls on; if furniture, frequency decides, the mapping is recorded in the alias table, and the matter is closed. Note also that the frequency premise is not taken on faith — it is checkable against the accumulating corpus with the same instrument that grows the rule set (§9.2), so even the tiebreaker stays empirical.

The residue quotiented away is precisely **TeX's typesetting machinery** — `\mathop` atom classification, automatic operator spacing, display-limit placement. The register does not replicate typesetting; it transfers mathematical content: the operator's *name*, its *arguments and their order*, its *binding structure*. Due diligence when the alias row lands: render-level checks confirming no reading-relevant distinction survives in KaTeX output. And `\operatorname` remains **valuable on input even though inadmissible in output** — it is strong evidence that a run is an operator name, which is exactly what licenses the `\mathrm` lowering. See §4.5.

**When frequency is not obvious at face value, the tie-break is still not rhetorical.** Three secondary criteria decide before any argument does — and in this precedent all three point the same way as frequency, which is why the case never needed a sample:

- **Paradigm regularity.** `\mathrm` belongs to the closed `\math⟨style⟩` family — `\mathbb`, `\mathcal`, `\mathfrak`, `\mathbf`, `\mathsf`, `\mathrm` — one morphological pattern, one grammar production for mathdig, one shared token prefix (and plausibly neighboring representations) for a model. `\operatorname` is a lexical isolate; no amount of usage would make it internally consistent with the family. A register built from regular paradigms has lower description length, and every consumer — parser, tokenizer, model, human — pays less to learn it.
- **Vocabulary minimality.** The register already requires `\mathrm` for differentials and units (§4.1). Canonicalizing operator names to it lets one existing macro absorb a third meaning instead of admitting a new command that exists for a single job.
- **Tokenization economy.** `\mathrm` is roughly half the length of `\operatorname` and shares its `\math` prefix fragment with the rest of the family, so the whole class clusters under any BPE segmentation; `\operatorname` is longer and segment-isolated.

**And when the criteria genuinely leave the answer unclear, litigation proceeds empirically.** The corpus is the sample, the question is answerable by counting (§9.2), and the verdict is recorded in the alias table like any other rule. Face-value frequency, paradigm consistency, tokenization, then measurement — in that order, and no step in the cascade is an argument.

### 4.4 The operational store: surjection entries

The production datastore literally encodes the canonicalization map as a **surjection**: one entry per concept, carrying the full set of equivalent surface forms and the single canonical target.

```json
{
  "concept": "greater-or-equal",
  "canonical": "\\geq",
  "members": ["\\ge", "\\geq", "\\geqslant", "≥"],
  "scope": "math",
  "kind": "register-spelling",
  "status": "active",
  "provenance": "…"
}
```

**Load-time invariants — violations fail loud, per store discipline:**

1. **Fixed point:** `canonical ∈ members`. Applying the store twice equals applying it once (the map is an idempotent surjection — canonical forms are exactly the fixed points).
2. **Disjointness:** member sets are pairwise disjoint across all entries. A surface form belongs to at most one concept.
3. **Renderability:** every `canonical` parses under KaTeX (§7); glyph members are covered by identity resolution below.

Invariant 2 is the policy, enforced by the data structure itself: **a form that would need membership in two classes cannot be encoded.** `∥` U+2225 is both a norm delimiter (`\|`) and a relation (`\parallel`) — so it is *ineligible* for this store, and the architecture forces it to the adjudication tier where position evidence lives. The store can only express unambiguous mappings; ambiguity is structurally inexpressible rather than policed by convention.

**Two-stage pipeline, two owners.** Glyph resolution (font-conditional artifact corrections like CMSY `k` → `‖`, plus glyph→lexical spelling) runs *before* class projection and belongs to the **PDF lane** — it turns extracted glyphs into lexical tokens. The surjection store is the **register's own production artifact**, and its domain is *lexical tokens as they vary in LaTeX source*: `\ge`/`\geq`/`\geqslant`, `\operatorname`/`\mathrm`, `\R`/`\mathbb{R}`. Both lanes' token streams pass through the same surjection — one target, per §0.1 — but only the PDF lane runs the glyph stage in earnest; the LaTeX lane needs it solely for Unicode characters authored directly in source. Ligature entries in the legacy store join neither stage (§5, registry FLAG-7).

**The safety valve for wrongly-built classes.** The residual risk is not in applying the surjection but in constructing a class that merges two forms an author somewhere uses distinctively. The audit instrument is a **co-occurrence census**: multiple members of one class appearing in a single *document* is weak evidence (authors mix `\ge`/`\geq` meaninglessly — canonicalization exists to fix exactly that); multiple members inside a single *expression* is strong evidence of intended distinction. A confirmed distinctive pair is a class-split event — unexpected uncertainty in the §9.3 sense, feeding the same learning loop as every other spec revision.

**The rule's boundary.** Eligibility is judged per concept, not per macro. A case where the competing forms differ in parse-relevant grammar — e.g. paired `\lVert…\rVert` versus `\|…\|`, where the open/close role of the delimiter is real structure to a parser — arguably falls on the notation side of the quotient and is then outside P4's jurisdiction. Deciding which side a case falls on is the only part that takes judgment; everything after is mechanical.

### 4.5 Source evidence: inadmissible in output, indispensable on input *(non-normative — compiler-facing)*

The notation/furniture split hides a third tier. Some constructs must never appear in a conforming manuscript yet carry information the compiler needs:

> **An input construct can be inadmissible in the target while still being decisive evidence during lowering. The dangerous operation is not removing it — it is removing it before extracting what it tells you.**

| Construct | Evidence it carries | Fate |
|---|---|---|
| `\operatorname{…}` / `\DeclareMathOperator` | the run *is* an operator name (licenses the `\mathrm` lowering, §4.3) | lower; record `source_form` in provenance |
| `\operatorname*` | limit-like binding of the subscript | lower; keep `limit_like` in the IR |
| `\left` / `\right` | intended delimiter pairing and nesting | resolve pairing, then drop where sizes match |
| `\,` in integrands | differential / unit boundary | inform segmentation, then apply §8.3's ruling |
| alignment environments | equation structure across lines | preserve structure, normalize the environment |
| author macro *names* (`\Hom`, `\rank`, `\vect`) | domain-semantic hints for ambiguous expansions | expand (§3, invariant 4); keep name + trace in provenance |

Macro expansion deserves its own statement, because it is the bridge from an author's private dialect into the shared register — **semantic de-aliasing**, not preprocessing. It must run *before* any information-destroying canonicalization, must be structural (never string replacement — nesting, scoping, redefinition, recursion), and must be bounded and sandboxed, since TeX is programmable enough to make unconstrained expansion dangerous. The invocation, resolved definition, and expansion trace survive in the out-of-band ledger (§0) even though none of them survive in the manuscript.

The compiler's stage order follows from the table: preserve raw tokens → expand macros → parse the rich source dialect *using typesetting constructs as evidence* → resolve structure → lower to the register → canonically serialize → validate.

In one line: **TeX grammar is evidence used by the compiler; mathematical grammar is content preserved by the manuscript.**

## 5. Glyph → lexical mapping

> **Non-ASCII mathematical symbols are always written as their LaTeX control sequences, never as raw codepoints** — `‖`→`\|`, `Ω`→`\Omega`, `◦`→`\circ` — while ASCII letters, digits, and ASCII operators remain literal. The domain is exact, which makes conformance a mechanical byte-scan: no raw non-ASCII codepoint inside math material (text inside `\text{…}` is prose and out of this rule's scope).

Two independent reasons: strict KaTeX has no character metrics for many raw glyphs and hard-fails them; and a single lexical form is a precondition for consistent tokenization.

The mapping is **data, not code** — one JSON object per line, carrying `char`, the replacement, `scope`, an optional `font_pattern` to narrow a rule to a font subset when the glyph is a ToUnicode artifact rather than a real character (the `CMSY`/`k`→`\|` class behind the `‖u‖`→`kuk` bug), and a mandatory `provenance` naming the paper or run that motivated it.

**Jurisdiction.** The rule itself — glyphs are spelled as control sequences — is a **target property** of the register (§0.1): checkable on any conforming manuscript. The *machinery* that resolves PDF glyphs into lexical tokens is the **PDF conversion lane's** (pdfdig), applied before those tokens reach the register's canonicalization; the LaTeX lane encounters glyph resolution only for Unicode characters authored directly in source. The store's `prose`-scope ligature entries (`ﬁ`→`fi`) belong to *neither*: they are residue of the early codex-membrane mandate, which bundled several concerns in one pass — repairing predictable encoding failures (ligature hallucinations), mapping glyphs to lexical tokens, canonicalizing lexical tokens, and possibly others not yet teased apart. Ligature repair has no analogue in LaTeX source and is not future work; it stays in the legacy store only while the membrane lane runs (registry FLAG-7). Expect further mixed concerns to fall out of membrane-era artifacts as they are audited — the decomposition is not assumed complete.

Deliberately **not** a general Unicode→LaTeX table. Entries earn their place by having broken a real document.

The curated, human-readable view over the store — entries typed by rule kind, classed by symbol family, audited against this spec with inconsistencies flagged — is the **symbol registry**: `issues/math-register/symbol-registry.md`. The store remains the machine artifact; at maturity the registry becomes the source of truth and the store is generated from it.

## 6. Diagrams, tiers, and explicit degradation

Diagrams are **encoded as semantic math**, never rasterized by default.

1. **1-D sequences** → inline arrows: `A \xrightarrow{f} B \to C`. Never a grid for a linear chain.
2. **2-D routing** (squares, triangles, pullbacks) → `\begin{array}{ccc}` with `\xrightarrow{f}`, `\downarrow`, `\nearrow`, empty cells for spacing.
3. **Raster** → flagged last resort, recorded on a work-list.

On `\begin{CD}` — the earlier flat rejection needs refining. Commutative diagrams and `\xrightarrow` are **material mathematical content, not furniture**; the vocabulary must be wide enough to hold them. What disqualifies `amscd`/`CD` from the *manuscript* is that KaTeX cannot render it, and the manuscript targets the portable tier:

| Tier | Capability | Use |
|---|---|---|
| **portable** | `katex ∧ mathjax` | the manuscript register — this spec |
| **rich** | `mathjax ∧ ¬katex` | GitHub-only; out of register, flag explicitly |

`tikzpicture`, `tikzcd`, `xymatrix` are **source dialects to be translated**, never output. When a construct cannot be lowered into the portable tier, it degrades **explicitly** — flag or image — and never breaks silently.

## 7. Well-formedness and conformance

### 7.1 Grammar rules (currently PowerShell predicates; eventually AST assertions)

These already exist as detectors in `src/codex-membrane/fidelity.ps1`, tested in `tests/detectors.Tests.ps1`. They are not incidental lint — **they are the well-formedness grammar of the math node**, written as heuristics only because there is no subtree to ask:

- `alignment_outside_env` — a bare `&` outside an alignment environment
- `unbalanced_delimiters` — unmatched `$`, braces, `\left`/`\right`
- `prose_in_formula` — prose swallowed into math without `\text{}`
- `dangling_operator` — an expression terminating on a binary operator
- `glyph_name_leak` — a glyph *name* emitted where the glyph belonged
- seam pass — boundary defects at span edges

**Today's heuristic detector is tomorrow's grammar rule.** The detector corpus is the conformance suite for the eventual math AST; nothing here is throwaway.

### 7.2 Four independent statuses

| Status | Question |
|---|---|
| **fenced** | Is the register boundary correct? |
| **parsed** | Does the grammar accept it? |
| **rendered** | Can the required renderer lower it? |
| **grounded** | Is it the *right* mathematics? |

> **A perfectly fenced, parsed, and rendered equation can still be the wrong equation.** Render-check is the **floor**, never the ceiling.

Under §0.1 these split cleanly into two kinds, and the split matters:

- **Register properties — checkable on the manuscript alone.** *Fenced* (no math outside a span, no prose inside one without `\text{}`), *parsed* (§7.1's grammar), *rendered* (KaTeX). A document either conforms or it doesn't; its provenance is irrelevant. Only *rendered* is fully automated today; *parsed* is approximated by the detectors; *fenced* is partially instrumented.

**One qualification on *fenced*, and it is not merely an instrumentation gap.** Most boundary conformance is mechanical — an unwrapped `\frac` in prose, a `\text{}`-less prose run inside math. But the operator-word class (Why-B) is *not* mechanically decidable even in principle from the manuscript alone: whether `log` in a given sentence is `\log` or the English word depends on the sentence's meaning, not on any surface property a checker can test. This is the one place where a register property requires adjudication rather than validation, and it is the residue §C assigns to the agent tier.
- **Conversion properties — require the source.** *Grounded* is **not a register property at all.** "Is this the right mathematics" is a question about fidelity to an original, answerable only against the LaTeX oracle or a human. It belongs to the gauntlet, not to this standard. For high-value spans, grounding is strongest as *consensus across independent routes* — TeX source, PDF extraction, rendered-crop comparison — gauntlet machinery, cited here only to mark the boundary.

Keeping these apart is what lets the register grade independent lanes against one target: a manuscript's conformance is lane-agnostic, while its grounding is inherently lane-and-source-specific.

## 8. Decisions

### 8.1 RESOLVED — alphabet macros are retained

The current build strips `\mathbb` by default and its comments call these "font-only macros." **That is wrong and this spec reverses it.** Three independent sources converge:

1. **P1** — ℝ and R, 𝔼 and E are routinely distinct objects in the same paper. Alphabet selection changes token identity.
2. **The doctrine** — *"`\mathbb`, `\mathcal`, `\mathbf`, accents, scripts, and operators are not disposable 'printing.' They are notation-bearing typography."*
3. **The canonicalization layer** — `\R` → `\mathbb{R}` names the decorated form as the *canonical target* (§4.3). Stripping runs it backwards.

The current behavior is destructive precisely on the class of symbol that matters most in this corpus.

### 8.2 RESOLVED — the criterion is notation versus typesetting, not document-local contrast

`\mathcal{S}` was cited earlier as possible "uninformative variation." Resolved in favor of retention, on this criterion:

> **If the syntax is pure typesetting, it does not belong. If it connotes notation — if it is part of how mathematics is *read* — it is content and must be preserved.**

`\mathbb` and `\mathcal` connote notation. They are retained (§4.1).

**A document-local collision test was considered and rejected**: *strip a decoration only if the undecorated form never appears as a distinct symbol in that same document.* It fails for two reasons.

1. **Document-local losslessness does not survive a corpus.** If paper A writes `\mathcal{F}` for a sheaf and paper B writes `F` for a function, stripping A collapses them in the shared retrieval space — and cross-document retrieval is the point of the spine.
2. **Notation carries convention without needing local contrast.** `\mathbb{R}`, `\mathcal{F}`, `\mathfrak{g}` mean what they mean regardless of whether the same paper also uses the bare letter. The test would destroy the convention signal precisely in documents where no collision happened to occur.

The deeper reason the semantic criterion beats the empirical one: **notation is a shared reading system, not a per-document convention.** Testing for local ambiguity treats it as though each document invents its own alphabet.

### 8.3 Still unspecified

- **`\left`/`\right`** — furniture when sizes match, notation when nesting requires growth. Needs a concrete rule.
- **`\,` in `\int f(x)\,dx`** — kerning by classification, conventional (arguably grammatical) in practice.
- **The alias table (§4.3) is a stub.** Four rows written from memory of the keystone brief; the real table needs enumerating against KaTeX's support table and a measured GitHub-MathJax set.
- **`.legacy/docs/STANDARDS.md` §5–§10** — heading conventions, Contents blocks, publish layout, lane naming, the patch lane. Non-math, currently homeless post-reorg, out of scope here but needs a destination.

## 9. Maturation — this register is mathdig's grammar, discovered by brute force

The register's mature form is intended to become the language definition that MarkPig's `mathdig` AST walks: math promoted from opaque leaf text to a **first-class parseable embedded language inside markdown**. That is the destination. One AST commitment is already fixed by §4.1: a decorated symbol is a single identifier node — `{base, alphabet, accents, scripts}` — never a styled letter; `\mathcal{F}` parses as the identifier ℱ, not as `F` wearing a font. The method for getting there is deliberate and is the opposite of how such a language is usually designed:

> **Discover the substrate empirically, by grinding a corpus, rather than nailing it theoretically upfront.**

This is not a concession to time pressure; it is the design stance. A grammar declared a priori encodes its author's guesses about which distinctions matter. A grammar accreted from documents that actually broke encodes which distinctions *the corpus enforces*.

### 9.1 How a rule matures: semantic criterion → enumerated vocabulary

Rules enter this spec as human judgments and must exit as machine-decidable enumerations. §8.2 is the worked example: *"anything that connotes notation is content"* is the correct criterion and is **not mechanizable** — no parser can evaluate "connotes." Its mature form is a closed list: `\mathbb`, `\mathcal`, `\mathfrak` are the notation class, enumerated, decidable, no judgment at parse time.

So the register matures by converting criteria into vocabularies, and the corpus is what does the converting. Every rule in this document should be read as sitting somewhere on that path.

### 9.2 The method already has a working prototype

`symbol-map.jsonl` (§5) *is* this method, running at small scale: entries "earn their place by having broken a real document," each stamped with the paper or run that motivated it. Eleven entries, zero theory, complete provenance. It is deliberately not a general Unicode→LaTeX table — a table designed upfront would be mostly dead weight and would still miss the `CMSY`/`k`→`\|` class, which no amount of a priori reasoning would have predicted because it is an artifact of broken `ToUnicode` maps, not of mathematics.

Scale that pattern across every rule class and mathdig's grammar arrives by accretion, with a provenance trail explaining why each production exists.

### 9.3 This is sequential sampling, not overfitting — and the real risk is false convergence

Overfitting requires a **fixed** sample. This one grows: every newly ingested document is out-of-sample at the moment of contact and only afterwards becomes part of the accreted rule set. A rule that had overfit would fail on the next paper, and that failure is precisely the event that triggers a spec update. Under this regime overfitting is **self-detecting**, so it is not the thing to guard against.

The governing analogy is a Monte Carlo estimate: run the stochastic experiment until the uncertainty on the observable falls below threshold, then stop with something admittedly unfinished but broadly covered — and, more valuably, with a framework for saying *what* is missing and *why*. The process is not linear; a newly discovered class can retroactively reorganize earlier ones (the `\mathrm` split in §4.1 arrived exactly that way).

**The observable to track is the arrival rate of novel rule classes per document ingested**, not the rule count. Rules accumulate forever; what decays is surprise. A trace of new-class arrivals per ten papers running 8 → 3 → 1 → 1 → 0 → 1 is in the tail; a trace still returning 5 is nowhere near it.

Two quantities must be kept apart, and the distinction is the standard one between **expected** and **unexpected uncertainty**:

- **Expected** — a document yields another instance of an already-characterized class (one more `ToUnicode` artifact, one more ligature). Log the entry; the grammar does not move. This is variability the model already accounts for.
- **Unexpected** — a document yields a construct with no existing class. This is model violation, the only event that should raise the learning rate and change the spec.

Only the second belongs in the arrival-rate trace. Conflating them makes the rate never decay and convergence look false when it isn't.

**The heavy tail must also be excluded, for the same reason.** Notation is Zipfian: a small core vocabulary covers the overwhelming majority of usage, followed by an unbounded tail of author-invented macros, one-off constructions, and house conventions. That tail will never close, and the register does not need it to — the **per-paper patch lane** already exists precisely to quarantine it as curated, out-of-grammar errata. Counting a one-off author macro as a novel rule class would corrupt the diagnostic with material the architecture has already decided is not grammar.

But the core/tail boundary **cannot be an input to this process** — it is one of its outputs. On first contact a construct seen once is indistinguishable from one that will recur in two hundred papers; nothing about the instance itself says which. So the classification is a **recurrence statistic, computed retrospectively**, never a judgment made at ingestion.

Two consequences follow. The trace must be **re-derivable** over the accumulated corpus rather than accumulated online as a running counter — which means keeping a per-document ledger of constructs observed, so a class logged as novel at document 40 can be demoted to tail at document 200 when it never recurred, or promoted to core when it did, and the whole trace recomputed. And the patch lane is a **stopgap held in reserve, not a routing decision made early**: invoking it on first contact would freeze the boundary before the data has drawn it, converting an empirical question into an assumption. The boundary between irreducible idiosyncrasy and spec-able structure emerges from the same process that produces the rules, and on the same schedule.

**So: measure convergence over the core vocabulary, not the union.** The gambit — that this converges — is reasonable at that scoping, because the target is not mathematics but *the encoding of mathematics in papers*, which is bounded by what the TeX/MathJax/KaTeX toolchains can express and by what authors actually use. That set is finite, closed at any given time, and considerably smaller than the mathematics it carries.

The real hazard is the MCMC one: **critical slowing down masquerading as convergence.** A poorly mixing chain looks converged because it is stuck in a metastable region, not because it has sampled the space. The corpus analogue is exact — if the intake is dominated by one TeX toolchain, one subfield, or one era, novel-class arrivals decay to zero because the sampler is trapped, not because mathematics has been covered. Monitoring the arrival rate alone **cannot distinguish these two cases.**

The standard fix is multiple chains from dispersed starting points, compared against each other. The corpus already has this instrument: **transport corpora are the dispersed chains.** Their function here is not a control against overfitting (they aren't one) but the between-chain diagnostic — if the arrival rate has flattened on the calibration corpora while first contact with a transport corpus still yields new classes, the flattening was false convergence and the register is not near closure.

The expected end state is that sampling gives way to enumeration: once enough classes are named, the vocabulary becomes finite enough to reason about its *complement* — seeing gaps structurally rather than by stumbling into them. That transition is the actual stopping criterion, and it is stronger than any threshold on the arrival rate.

### 9.4 Consequence for reading this document

§8.3 and Appendix B are **not deficiencies** — they are the work queue, and the corpus is the instrument that will close them. An item stays open until enough documents have broken against it to enumerate the answer. Closing one prematurely by argument would defeat the method.

## Appendix A — migration deltas from the current build

What the tentative implementation does today, and how it relates to this spec.

| Behavior | Where | Relation to spec |
|---|---|---|
| KaTeX render gate | `src/render-check.ps1` + `tools/render-check/katex-check.js` | **keep** — §7.2 *rendered* |
| Well-formedness detectors | `src/codex-membrane/fidelity.ps1` | **keep, promote** — these are §7.1's grammar |
| Glyph→lexical map (11 entries) | `src/pdf-converter/stores/symbol-map.jsonl` | **keep, grow** — §5 |
| De-spacing, script reconstruction, `&` repair | `src/codex-membrane/normalize.ps1` | **keep** — §4.2 OCR artifacts |
| `\mathbb` stripping (default on, inline + display) | `src/codex-membrane/normalize.ps1` (`$StripMacros`) | **REVERSE** — §8.1 |
| Markdown lint | `tools/md-lint/codex.markdownlint.json` | keep, non-math |
| UTF-8 no BOM everywhere | stream discipline | **keep** — SMP math must round-trip |
| Furniture removal beyond `\mathbb` | — | **absent** — §4.2 is essentially unenforced |

The gap that stands out: **§4.2 furniture removal is almost entirely unimplemented**, so the register's central promise — two expressions differing only by furniture serialize identically — does not hold today. A §4.2 linter is the highest-value missing instrument and, unlike the semantic questions, is purely mechanical.

## Appendix C — glossary

*(non-normative — shared vocabulary for development sessions)*

**Math register** — the specified language of mathematics inside a manuscript: the delimiters, admissible vocabulary, and canonical spellings. A *register* in the linguistic sense: a distinct variety used in a distinct context, here embedded in a prose host.

**Canonicalization / canonical form (normal form)** — mapping many equivalent surface forms onto exactly one, so that *register equivalence* implies lexical identity. The property from which most of this spec follows.

**Register equivalence (≡R)** — sameness under the register's declared representational quotient: same source reading and same ordered structure, differing only in declared aliases or furniture. NOT mathematical equivalence — `a+b ≢R b+a`, and conflating them would be source corruption. The relation whose classes the surjection store (§4.4) encodes.

**Source-evidence tier** — constructs inadmissible in the manuscript but decisive during lowering (`\operatorname`, `\left`/`\right`, `\,`, author macro names): interpret before discarding (§4.5). "TeX grammar is evidence used by the compiler; mathematical grammar is content preserved by the manuscript."

**Data contract** — an agreed format between producers and consumers that neither side may unilaterally change. The register is the data contract for the math language; §0.1 is its statement.

**Notation vs furniture** — the governing quotient (§2, P1). *Notation* changes token identity, grammar, or reference and is content. *Furniture* changes only appearance and is removed.

**Notation class** — `\mathbb`, `\mathcal`, `\mathfrak`; retained unconditionally. **Upright/weight class** — `\mathrm`, `\mathbf`, `\mathsf`; retained but with one target form per meaning.

**Span** — an addressable region of math, *inline* (`$…$`) or *display* (`$$…$$`). The unit of conformance, addressing, and repair.

**Fenced / parsed / rendered / grounded** — the four conformance statuses (§7.2). The first three are *register properties*, checkable on the manuscript alone; *grounded* is a *conversion property* requiring the source, and belongs to the gauntlet, not to this spec.

**Register property vs conversion property** — the central distinction of §0.1. The register specifies the target vocabulary; the converter decides which target form a source construct maps to.

**Operator-word class** — tokens that are legitimate mathematics in one position and English in another (`log`, `max`, `det`, `arg`, `Re`, and single letters `a`, `I`, `e`, `d`). The canonical hard case, not decidable from geometry or typography.

**Adjudication residue** — the cases provably undecidable by the deterministic tiers, escalated to a reasoning model. Least-privilege applied to inference: the expensive non-deterministic component gets the smallest possible share.

**Tokenization instability** — the same expression segmenting into different token sequences depending on encoding or context. **Sequence inflation** — one symbol fragmenting into several tokens. **Attention dilution** — attention mass spread across fragments that individually mean nothing.

**Nuisance variance** — input variation irrelevant to the task that a model must learn to marginalize out; costs sample efficiency and inference reliability. Encoding heterogeneity is nuisance variance.

**Paradigm regularity** — the property that a vocabulary's members follow one morphological pattern (the `\math⟨style⟩` family) rather than admitting lexical isolates (`\operatorname`). A tie-break criterion in P4's cascade: regular paradigms cost every consumer less — one grammar production, shared tokenization prefix, plausibly neighboring representations. The technical content of "it looks right alongside `\mathbb` and `\mathcal`."

**Narrow waist (hourglass architecture)** — a canonical intermediate form that collapses an *N×M* producer-consumer integration surface to *N+M*. What IP is to networking and an IR is to a compiler.

**Index-time normalization** — canonicalizing once at ingestion rather than applying heuristics at every query. The standard information-retrieval discipline, and why §5 belongs in the pipeline rather than in the search layer.

**Portable tier / rich tier** — `katex ∧ mathjax` versus `mathjax ∧ ¬katex` (§6). The manuscript targets *portable*; anything richer degrades explicitly, never silently.

**Patch lane** — per-paper curated errata carrying irreducible idiosyncrasy that the grammar should not absorb. A reserve mechanism; invoking it early would freeze the core/tail boundary before the corpus has drawn it (§9.3).

**Core vs tail** — notation is Zipfian: a small core vocabulary covers most usage, followed by an unbounded tail of one-off author macros. Convergence is measured over the core; the boundary between them is a recurrence statistic computed retrospectively, never a judgment at ingestion.

**Novel-class arrival rate** — the convergence diagnostic (§9.3): new rule *classes* per document ingested. Distinguished from **expected uncertainty** (another instance of a characterized class — log it, the grammar does not move) versus **unexpected uncertainty** (a construct with no class — the only event that changes the spec).

**mathdig** — the prospective MarkPig AST that would parse this register as a first-class embedded language, replacing regex-and-heuristic re-derivation with a real syntax tree. This document is its language definition (§9).

## Appendix B — open to the corpus

Not gaps to be argued closed, but the work queue of §9.4 — each item stays open until enough documents have broken against it to enumerate an answer:

- Whether the register should carry **stable span addresses** in-manuscript (for the dual-RAG spine) or keep them fully out-of-band. The minimality principle says out-of-band; the addressing requirement pulls the other way. Unresolved.
- Whether **equation labels/tags** are metadata-in-manuscript (`\tag{N}`) or ledger entries. Current answer is `\tag{N}`; the AST design implies ledger.
- The **granularity** of canonicalization: LaTeX-faithful tree plus an alias layer (cheap, ~80%) versus full concept modeling (expensive). The keystone brief recommends starting at the alias layer.
- How much of *fenced* is instrumentable as a pure target check. Boundary **conformance** (nothing mathematical loose in prose, nothing prosaic loose in math) is a register property and is mechanizable *except* for the operator-word residue (§7.2); boundary **correctness against a source** is a conversion property and belongs to the gauntlet. Both lines are clear in principle and neither is yet drawn in code. Open question: what fraction of real boundary defects fall in the mechanical part — if it is most of them, the agent tier stays cheap.
