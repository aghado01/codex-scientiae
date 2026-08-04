# Review PdfDig design discussion

> So i'm in the early stages of my design work for the new pdf lane, proper `PdfDig` work down the line. I've surmised that the approach will have clear stages of deterministic/algorithmic, inference and reasoning stages, and developed in that order because the outcome at the end of each determines what remains for the next. `D:\aghado01\codex-scientiae\issues\pdfdig\discussions\grok-print-to-markdown.md`, please review this discussion segment about the first stage and my thought experiment

<details><summary>4 previous messages</summary>

> I’ll read the discussion in full, then assess the proposed first-stage boundary: what is genuinely deterministic, where hidden inference enters, and whether the outputs leave the later inference/reasoning stages with a clean problem.
>
> The core idea is promising, but the discussion currently blurs three different artifacts—paint order, inferred reading order, and a “full relational graph.” I’m checking the surrounding PdfDig notes and the actual PdfPig surface so I can separate the durable insight from API or architectural overclaims.
>
> A second, more project-specific issue has emerged: this segment’s fixed order—stream-derived prose first, XY-Cut second—cuts against your later whole-document-first commitments. I’m now validating exactly what the vendored PdfPig execution trace contains, especially form XObjects, marked content, and whether the public API actually exposes the claimed graph.
>
> The source check confirms the main API correction: `Page.Operations` is not a flattened execution trace. Form XObjects are parsed and executed recursively inside PdfPig, while the page object retains the original page-level operation list. So the proposed simple `foreach (op)` walk cannot reproduce all emitted marks or their live state by itself.

</details>

The thought experiment is strong, but the discussion overstates what renderer order can buy you. Its durable contribution is a renderer-aligned evidence substrate—not a deterministic route to an already-ordered prose spine.

## What survives

The early rendering analysis is largely sound. Walking the graphics machine gives PdfDig unusually rich born-PDF evidence:

- decoded glyphs plus original font/glyph provenance;
- baselines, matrices, advances, clipping, paint state, and emission locality;
- paths and images tied to the operation that produced them;
- resource and Form XObject relationships;
- marked-content nesting and `/ActualText` when present.

That would be a principled foundation for the first stage. It is much better than beginning with an undifferentiated bag of bounding boxes.

Your “backbone with holes” remains exactly right. The important correction is that the renderer walk supplies evidence from which the backbone is assembled; it does not ordinarily supply the backbone itself.

## Where the discussion crosses the line

### 1. Paint order is not a strong reading-order prior

The critical leap occurs around [line 61](./issues/pdfdig/discussions/grok-print-to-markdown.md:61) and becomes an architectural assumption at [lines 102–118](./issues/pdfdig/discussions/grok-print-to-markdown.md:102).

A PDF content stream is sequential, but that sequence is principally a **paint/compositing order**. Producers may emit:

- all text of one font or layer together;
- reusable Form XObjects at arbitrary points;
- headers, footers, floats, and annotations before or after body text;
- columns in unexpected order;
- duplicate visible/invisible text layers;
- glyphs individually or in producer-specific batches.

PdfPig’s own documentation is unusually blunt: internal content order is “rarely ever the text in the order you want,” and PDF text may be painted in any order [README](D:/aghado01/packages/PdfPig/README.md:44).

Consequently, `TextSequence` is valuable as:

- a within-run grouping cue;
- producer-locality evidence;
- a tie-breaker inside geometrically coherent regions;
- one independent ordering proposal.

It should not own the initial spine.

Your existing capability map had the calibration right: `TextSequence` was a **tie-break/locality signal**, and every segmenter or order detector remained a “witness, not gospel” [pdfpig-capability-map.md](./issues/archive/pdf-converter/pdfpig-capability-map.md:64).

### 2. “Redirecting the renderer to Markdown” is slightly the wrong abstraction

A renderer can deterministically answer:

> What marks result from executing these instructions under this state?

Markdown generation asks:

> What latent manuscript structure best explains these marks?

Changing the side effect from pixels to Markdown does not remove the inverse problem. Body identification, heading roles, reading order, attachment, and math assembly are not alternate drawing operations encoded in the stream.

I would rename the experiment:

- **render-to-evidence**
- **execute-to-mark-IR**
- **renderer-aligned trace extraction**

The eventual Markdown serializer should remain downstream of the manuscript IR, consistent with your later decision that Markdown is merely a projection of the semantic ABI.

### 3. Repeatable does not mean factual

This suggests an important internal split inside your “deterministic/algorithmic” stage:

| Sublayer            | Output                                                     | Epistemic status               |
| ------------------- | ---------------------------------------------------------- | ------------------------------ |
| Execution           | glyphs, paths, images, matrices, resources, paint sequence | Deterministic observations     |
| Normalization       | words, lines, geometric relations, recurrence statistics   | Deterministic derivations      |
| Proposal generation | XY-Cut blocks, heading candidates, order candidates        | Repeatable but fallible claims |
| Inference           | reconciled partial manuscript graph                        | Inferred structure             |
| Reasoning           | semantic repair, math authoring, residual decisions        | Agent-authored resolution      |

XY-Cut is deterministic given fixed inputs and parameters, but its segmentation remains a conjecture about document structure. The same applies to font-based heading classification.

This fact/claim separation prevents the first stage from silently smuggling inference into supposedly immutable evidence.

### 4. `q/Q` and `BT/ET` are not semantic nesting

The suggestion at [line 91](./issues/pdfdig/discussions/grok-print-to-markdown.md:91) should be weakened substantially.

Those constructs delimit graphics state and text-object legality. Their boundaries usually reflect authoring-library implementation choices, not paragraphs, headings, or logical containment. They may be retained as producer-local grouping evidence, but treating them as structural boundaries would manufacture false structure.

### 5. XY-Cut should be a parallel proposal, not merely a later correction

The proposed order at [line 126](./issues/pdfdig/discussions/grok-print-to-markdown.md:126) is too serial:

```text
stream prose → role channels → XY-Cut correction
```

A safer shape is:

```text
normalized marks
  ├─ paint-order proposal
  ├─ XY-Cut/layout proposal
  ├─ typography-regime proposal
  ├─ marked-content/tag proposal
  ├─ recurrence/furniture proposal
  └─ bookmarks and other document-level evidence
             ↓
       reconciliation
             ↓
partial-order backbone + typed holes
```

XY-Cut should generally see figures, rules, display math, and other opaque obstacles. Removing “non-prose” first can create artificial whitespace and damage precisely the column/float decomposition it is meant to discover.

The discussion’s sequence also conflicts with your later settled commitment that whole-document typography and recurrence regimes condition page-local decomposition [sol-reboot-distillate.md](./issues/archaeology/sol-reboot-distillate.md:59).

### 6. Unicode math and diagrams are overpromised

PdfPig can recover excellent Unicode when font mappings cooperate, but:

- missing or erroneous `ToUnicode` maps remain common;
- math meaning is often distributed across glyph identity, font, baseline, and geometry;
- composed symbols may involve multiple glyphs or vector paths;
- Type 3 fonts complicate character identity;
- a diagram’s labels may be text, but the diagram itself is normally paths or an image.

The trace should preserve raw character code, font/glyph identity, decoded Unicode, mapping source, geometry, and confidence separately. Unicode is one observation—not the canonical math result.

## The PdfPig API corrections

The implementation section is the weakest part of the discussion.

`page.Operations` is **not a complete flattened execution trace**. It contains the page-level parsed operations. When a `Do` invokes a Form XObject, PdfPig parses and executes that nested stream recursively [BaseStreamProcessor.cs](D:/aghado01/packages/PdfPig/src/UglyToad.PdfPig/Graphics/BaseStreamProcessor.cs:519), while `PageContent` retains the original page operation list [ContentStreamProcessor.cs](D:/aghado01/packages/PdfPig/src/UglyToad.PdfPig/Graphics/ContentStreamProcessor.cs:85). This behavior is also present in the exact vendored `0.1.14` tag.

Therefore, the suggested `foreach (op)` switch is useful for inspection, but it cannot reproduce all letters, paths, state transitions, or nested provenance.

Likewise:

- PdfPig’s concrete `ContentStreamProcessor` is internal.
- `Page.Letters` gives excellent post-execution atoms, but not the full state trajectory or exact originating operation path.
- `document.Structure` is access to the PDF catalog, xref table, trailer, and raw objects—not a manuscript or layout graph [Structure.cs](D:/aghado01/packages/PdfPig/src/UglyToad.PdfPig/Structure.cs:11).
- `GetMarkedContents()` exposes content-stream marked-content sequences; it is not equivalent to a fully traversed logical structure tree.
- PdfPig exposes components from which several graphs can be constructed, not one “full relational graph.”

For a genuine trace, the clean seam would be a small PdfPig extension or fork adding a trace sink around glyph emission, path painting, image emission, Form entry/exit, and marked-content entry/exit. Each event should carry an execution path such as:

```text
page → content-stream object → operation index
     → form object → nested operation index → emitted mark
```

That is much more useful than implementing a second `IOperationContext` whose terminal effect is prematurely serialized Markdown.

## Overall verdict

Keep the thought experiment, but treat the file as exploratory rather than an implementation brief.

The corrected thesis is:

> Execute the PDF like a renderer to obtain a provenance-complete mark graph. Run independent deterministic layout and ordering proposal mechanisms over that graph. Reconcile them into a partial manuscript order whose disagreements and missing content become typed holes.

That formulation strengthens your three-stage design. Runtime stages can absolutely residualize the problem in order. Development should still use thin end-to-end gauntlet runs, because inference and reasoning failures will reveal which evidence the deterministic trace failed to retain.

> well i think a thing that struck me conceptually was the realization that in the pdf-to-markdown process, i'm going from an input stream to an output stream. naturally the reading order does not immediately fall out from walking from simply reading the input stream, and all sorts of object might inject fragmented text like text boxes rendered on the page, figure captions, all sorts of things are interleaved in the raw stream. the raw stream result however feels like an important beachhead, and it can be refined based on PdfPig's enriched IR outputs to resolve contiguous bodies of text and start to assemble them into semantic chunks with relations helping resolve disjoint but spatially adjacent chunks, after which point, i'm much closer to the spine with holes that sets up for the next stages of inference and reasoning

Yes—that is the stronger formulation, and it resolves the concern I raised. The raw stream is not the spine, but it is a uniquely valuable beachhead because it gives every extracted mark an ordered origin and provenance before spatial and structural reconstruction begins.

The PDF content stream is something like a braided stream: body prose, headings, captions, furniture, figure labels, math, and decorative marks may all be interleaved. PdfDig’s deterministic stage progressively unbraids it.

There are really three notions of contiguity:

1. **Execution contiguity** — characters emitted by the same `Tj`/`TJ`, text object, or nearby operations.
2. **Visual contiguity** — fragments sharing a baseline, spacing pattern, region, column, or typographic regime.
3. **Manuscript contiguity** — fragments belonging consecutively in the latent prose or section flow.

The first is directly observed. The second is algorithmically derived from PdfPig’s enriched geometric and typographic evidence. The third is what the system ultimately needs to infer. The first-stage task is to carry as much of the first two forward as possible so that much of the third becomes highly constrained.

That gives a more precise transformation:

```text
PDF execution stream
→ provenance-bearing marks
→ locally coherent runs
→ candidate lines and chunks
→ relational/partial-order chunk graph
→ high-confidence manuscript backbone + typed holes
→ inference and reasoning
→ canonical output stream
```

The crucial intermediate is therefore not immediately another flat stream. It is a graph whose nodes are increasingly coherent chunks and whose edges record different relations:

- emitted together or nearby in the content stream;
- same baseline or text trajectory;
- spatial adjacency, containment, or overlap;
- same column or layout region;
- same typography/document-wide role regime;
- likely continuation across an interruption;
- competing precedence or attachment proposals.

From that graph, the deterministic stage can recover stretches where several independent relations agree. A sequence of body-like lines in one column, with stable typography, regular leading, compatible emission locality, and no intervening obstacle can become a highly certified contiguous span. A caption or text box can be separated into another channel without losing its position relative to that span. Where evidence disagrees, the graph preserves the fork rather than forcing a false linear order.

So the beachhead is not merely “raw extracted text.” It is more like:

> raw extracted marks with permanent addresses in the PDF’s execution, geometry, resource, and containment systems.

That permanence is important. Later stages reorder and assemble stable identities; they do not reconstruct provenance after flattening everything into strings.

I would only retain one terminological caution: “semantic chunks” in the deterministic stage should mean **role-bearing candidates or mechanically certified chunks**, depending on the evidence. Some chunks may be nearly indisputable—regular body lines, repeated page furniture, a coherent heading-sized run—while others remain hypotheses. That distinction lets the first stage advance very close to the spine without pretending that repeatable algorithms have made semantic truth certain.

Conceptually, then, your input-stream/output-stream realization is sound. The middle graph is the machinery that makes the transformation possible:

```text
input stream → unbraided relational graph → output stream
```

And the quality of that middle representation determines exactly how small, localized, and well-posed the remaining inference and reasoning problems become.
