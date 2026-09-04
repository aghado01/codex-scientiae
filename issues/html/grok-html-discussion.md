Yes. For this corpus that is the remaining job — with one important shape correction so you do not flatten the MathML and accidentally rebuild the PDF problem.

HTML has already done the manuscript linearization you care about: section order, paragraphs, lists, theorem blocks, figure/caption adjacency, citation links. That is why it feels like MarkPig. What it has not done is emit the math channel. It has demuxed math into <math> islands and then encoded those islands as Presentation MathML whose leaves are Unicode glyphs.

<math display="inline" alttext="\Omega_{i}^{2}">
  <semantics>
    <msubsup><mi>Ω</mi><mi>i</mi><mn>2</mn></msubsup>
    <annotation encoding="application/x-tex">\Omega_{i}^{2}</annotation>
  </semantics>
</math>

The Ω is a register-illegal glyph. The msubsup is not a glyph — it is the script schema. innerText of that node is Ωi2. That is PDF soup. Do not do that.

Two hops, already owned separately in your stack

The spec already splits this, and HTML lands almost entirely on the first hop plus a thin serializer:

┌─────────────────────┬───────────────────────────────────────────────────────┬─────────────────────────────────────────────────┐
│ Hop                 │ What                                                  │ Owner today                                     │
├─────────────────────┼───────────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
│ Glyph → lexical     │ Ω → \Omega, ∑ → \sum, ≤ → \leq                        │ lexicon.json + Convert-MathToLatex              │
│ token               │                                                       │                                                 │
├─────────────────────┼───────────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
│ Lexical → register  │ \ge → \geq, \operatorname → \mathrm, furniture strip, │ ConvertTo-RegisterMath                          │
│                     │ $/$$                                                  │                                                 │
├─────────────────────┼───────────────────────────────────────────────────────┼─────────────────────────────────────────────────┤
│ Schema → TeX        │ mfrac/msup/mrow/mtable → \frac, ^, \begin{array}      │ not a string replace; MathML serializer, or     │
│                     │                                                       │ skip it                                         │
└─────────────────────┴───────────────────────────────────────────────────────┴─────────────────────────────────────────────────┘

md-math.ps1 is explicit: Unicode→LaTeX is not its job. math-channel.ps1 already does glyph spelling and register canonicalization on a span of LaTeX. HTML just has to hand it a span.

That is why this is easier than PDF. PDF glyph repair is identity recovery under broken ToUnicode (CMSY k → ‖). LaTeXML usually emitted the right Unicode from the TeX. You are doing register-spelling, not artifact-correction. Homoglyphs still exist (− vs -, ∥ vs ‖), but they are ordinary Unicode, not font-subset damage. The registry’s PDF-lane flags mostly do not apply.

It is also easier than TeX source: <math> already answers “is this math?” You do not need Test-MathGlyphToken / run classification. Display vs inline is an attribute. Equation numbers are sibling tags waiting for \tag{N}.

The actual easy path

Prefer the TeX annotation / alttext when it is present. That is already a lexical span, author macros already expanded by LaTeXML. Pipe it through ConvertTo-RegisterMath and wrap $/$$. That is the glyph problem plus the register you already have.

Fall back to walking the MathML tree only when the annotation is missing or junk:

1. Serialize schemata (mfrac → \frac{…}{…}, msup → {…}^{…}, …).
2. At leaves, apply lexicon.json (same store, now scoped to mi/mo/mn text).
3. Then ConvertTo-RegisterMath.

Step 1 is small, closed, and testable. It is not “the envelope.” It is the adapter that lets the existing span canonicalizer see HTML math.

What is not the glyph job

• Chrome, ltx_* section tags, figure files — manuscript packaging, not math.
• Prose punctuation (—, NBSP, ellipsis). Do not run the math lexicon on the body; that is how α-in-biology becomes a span.
• TikZ-as-<img> — flag, do not lexically encode a raster.
• MathML 4 Intent :literal — speech, ignore it.

So the case study is: HTML is a linearized manuscript with math already islanded; the producer is “island → register span.” If annotation-first + existing ConvertTo-RegisterMath yields KaTeX-stable $…$ / $$…$$ on a handful of clean LaTeXML papers, you have shown the third lane is mostly a new input adapter to a channel you already built. If it fails, the failures will be missing annotations, unserialized schemata, or detached tags — not reading order, and not TeX execution.