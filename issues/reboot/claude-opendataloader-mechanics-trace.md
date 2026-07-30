# opendataloader-pdf Deterministic Mechanics Trace

## A. IR record granularity & metadata

The smallest unit serialized into the JSON IR for paragraph-shaped content is the **paragraph itself** (`SemanticParagraph`); its constituent `TextLine` and `TextChunk` instances exist only in the in-memory `verapdf` model and are **flattened into one `content` string**. There is no per-line bbox in the JSON for a paragraph, no per-chunk bbox, no glyph info, no PUA annotation.

`ParagraphSerializer` (`json/serializers/ParagraphSerializer.java:32-40`) writes only:

```java
SerializerUtil.writeEssentialInfo(jsonGenerator, textParagraph, JsonName.PARAGRAPH_TYPE);
SerializerUtil.writeTextInfo(jsonGenerator, textParagraph);
SerializerUtil.writeMetadataIfPresent(jsonGenerator, textParagraph);
```

`writeEssentialInfo` (`SerializerUtil.java:122-138`) emits: `type`, optional `id`, optional `level`, `page number` (1-based), `bounding box` as `[leftX, bottomY, rightX, topY]`. `writeTextInfo` (`SerializerUtil.java:140-151`) emits: `font` (font name from the paragraph's dominant chunk), `font size`, optional `text color` (RGB triple, only if non-null), the flattened `content` string, and optional `hidden text` boolean. `writeMetadataIfPresent` only emits anything when `ElementMetadata` (a hybrid-pipeline concept) is attached — `confidence`, `source label`, `text source`, `stream ocr similarity`, etc. **In local mode this map is empty**, so a paragraph is just `{type, id, page number, bounding box, font, font size, content}` plus optional color.

`TextChunkSerializer.java:33-39` and `TextLineSerializer.java:33-39` exist but are **never reached for paragraph-bearing content** — once `ParagraphProcessor` runs, the `TextLine` instances are rolled inside `SemanticParagraph.columns[].blocks[].lines[]` and the only JSON output is the merged paragraph. `TextChunkSerializer` produces `{type:"text chunk", page number, bounding box, content}` and `TextLineSerializer` produces the same shape with type `"text chunk"` (note: line emits as `TEXT_CHUNK_TYPE`, `TextLineSerializer.java:36`) — these are emitted only when raw text chunks/lines survive past paragraph detection (rare).

Implication for the user: the JSON IR's bbox for a math-shattered paragraph is the **bbox of one short fragment**, not a per-line array. Glyph/font info is the dominant value for the whole record. To do spatial clustering you cluster _paragraphs_ by bbox proximity.

## B. Reading order details

`XYCutPlusPlusSorter.sort` (`processors/readingorder/XYCutPlusPlusSorter.java:82-129`) is invoked **per page** by `DocumentProcessor.sortContents` (`DocumentProcessor.java:711-734`) on the post-paragraph-detection `List<IObject>`. So XY-Cut sorts paragraphs (and headings, lists, tables, images), not individual lines or chunks. The pipeline order:

1. Phase 1 (`identifyCrossLayoutElements`, line 146): mark elements wider than `beta * maxWidth` (default `beta = 2.0`, line 50, **effectively disabled**) that overlap >=2 others as cross-layout; pull them aside.
2. Phase 2 (`computeDensityRatio`, line 260): contentArea / regionArea; > `DEFAULT_DENSITY_THRESHOLD = 0.9` prefers horizontal-first.
3. Phase 3 (`recursiveSegment`, line 331): find largest horizontal gap (`findBestHorizontalCutWithProjection`, line 484) and largest vertical gap (`findBestVerticalCutWithProjection`, line 406), each via projection on the chosen axis. **Pick whichever has the larger gap** (line 348: `useHorizontalCut = horizontalCut.gap > verticalCut.gap`), provided the gap is >= `MIN_GAP_THRESHOLD = 5.0` points (line 63). Vertical-cut detection retries after dropping elements <10% of region width (`NARROW_ELEMENT_WIDTH_RATIO`, line 68) so page numbers can't bridge column gaps.
4. Recursion uses center-Y / center-X to assign each element to above/below or left/right (`splitByHorizontalCut` line 524, `splitByVerticalCut` line 556). Base case: `sortByYThenX` (line 644) — sort by descending topY then ascending leftX.
5. Phase 4 (`mergeCrossLayoutElements`, line 590): cross-layout elements re-inserted in a Y-order merge.

**Contiguity guarantee**: paragraphs in the same column-band region get sorted top-down within that band. _Equation paragraphs that are visually inside the same column will end up contiguous in reading order_ — but only because of pure geometric Y-sorting at the leaf. There is **no semantic guarantee** that fragments of one equation stay together: if one fragment is left-aligned and another centered with bigger leftX, both inside the same column, they sort by Y purely. That's actually good news for the user — within a column the ordering is deterministic top-down.

## C. Math classification in local mode

**Confirmed: no local classifier produces `SemanticFormula`.** A grep across the entire codebase shows the only constructor calls are:

- `hybrid/DoclingSchemaTransformer.java:351`
- `hybrid/HancomSchemaTransformer.java:321`
- `hybrid/HancomAISchemaTransformer.java:1110`

All three are inside the `hybrid` package, populated only when `config.isHybridEnabled()` returns true (`DocumentProcessor.java:174`). `processDocument` (the local-only path, line 238) goes through `ContentFilterProcessor` → `TableBorderProcessor` → `TextLineProcessor` → `ParagraphProcessor` → `HeadingProcessor` → `CaptionProcessor`. **None of those ever instantiate `SemanticFormula`.** So in local mode every math run is wrapped as `SemanticParagraph` (or even `SemanticHeading` if it happens to be the size of a heading).

The cause of fragmentation is `ParagraphProcessor`'s merge predicates (`ParagraphProcessor.java:36-54`). Each `TextBlock` starts as a single `TextLine`. Merges happen only if `getDifferentLinesProbability >= DIFFERENT_LINES_PROBABILITY = 0.75` (line 34) AND `areTextBlocksHaveSameTextSize` (line 532, fontsize within `1e-1`) AND alignment matches one of {JUSTIFY, LEFT, CENTER, RIGHT, two-line, generic}. Equation lines fail because:

- Mixed font sizes (sub/superscripts, `\sum` and `\int` glyphs at different bbox heights) trip `areTextBlocksHaveSameTextSize`.
- Centered display equations of different visual widths get inconsistent `getAlignment` results.
- Equation labels `(12)` flush to the right column trip `BulletedParagraphUtils.isLabeledLine` (line 79: `(\d+)` matches `BULLET_REGEXES` at line 127 `^\(\d+\).*`), which **kills any merge** — see line 214, 277, 325, 346, 435: nextBlock is excluded from merging the moment `isLabeledLine(nextBlock.getFirstLine())` is true. **This is the single biggest reason equation labels appear as their own paragraph.**

## D. Markdown writer formula handling

There **is** a `$$...$$` branch (`MarkdownGenerator.writeFormula`, line 254-260):

```java
markdownWriter.write(MarkdownSyntax.MATH_BLOCK_START);  // "$$"
markdownWriter.write(MarkdownSyntax.LINE_BREAK);
markdownWriter.write(formula.getLatex());
markdownWriter.write(MarkdownSyntax.LINE_BREAK);
markdownWriter.write(MarkdownSyntax.MATH_BLOCK_END);    // "$$"
```

But it only fires for `SemanticFormula` instances (dispatch at `MarkdownGenerator.write`, line 138). Since local mode never creates `SemanticFormula` (see C), `writeFormula` is **dead code in local mode**. There is **no text-content-based fallback** — no scan for math characters anywhere in `MarkdownGenerator` or `MarkdownSyntax`. All math goes through `writeParagraph` → `writeSemanticTextNode` (line 354 → 288).

## E. Line-break behavior

Hard line breaks inside a paragraph come from `GeneratorUtils.getTextFromLines` (`utils/GeneratorUtils.java:29-52`):

```java
for (int i = 0; i < textLines.size() - 1; i++) {
    TextLine line = textLines.get(i);
    ... MarkdownGenerator.getTextFromLineForMarkdown(line, stringBuilder);
    TextChunkUtils.formatLineEnd(stringBuilder);  // appends "\n" or " "
}
```

`TextChunkUtils.formatLineEnd` (in the external `verapdf-wcag` lib) appends `"\n"` if `StaticContainers.isKeepLineBreaks()` is true, else a space — this is gated by the CLI flag `--keep-line-breaks` (`Config.java:229`, default `false`). When `keepLineBreaks` is false, paragraphs containing many lines are joined with single spaces. **So all the visible per-line markdown breakage in math is really paragraph boundaries**, i.e. `ParagraphProcessor` failed to merge two TextLines into one paragraph and emitted each as its own `SemanticParagraph`. The two paragraphs are then separated by `writeContentsSeparator` (`MarkdownGenerator.java:126-129`) which writes two `\n`. Each blank-line gap in the math-shattered markdown maps to a paragraph boundary in the IR.

There is one exception: `SemanticTextNode` writing (`MarkdownGenerator.java:288-302`) replaces line breaks with spaces inside table cells, and inside headings if `keepLineBreaks` is on.

## F. Lift-able utilities

- **`BulletedParagraphUtils.isLabeledLine`** (`utils/BulletedParagraphUtils.java:79`): boolean predicate; checks first char against a giant `POSSIBLE_LABELS` Unicode set, then a list of regex patterns including `^\(\d+\).*`, `^\d+[\.\)]\s+.*`, Roman numerals, circled numbers. **Directly liftable** as a "is this a bullet/label/equation-number marker" predicate. Equation labels like `(12)` will return true.
- **`ContentSanitizer`** (`utils/ContentSanitizer.java`): regex-driven find-and-replace over a `List<TextChunk>` with bbox-preserving sub-chunking. Useful pattern for splicing repaired LaTeX back into text while keeping bboxes valid.
- **`TextNodeStatistics` / `TextNodeStatisticsConfig`** (`utils/TextNodeStatistics*.java`): a mode-weight scorer for font sizes (default dominant range 10–13 pt, heading range 10–32 pt) and font weights (dominant 395–405 = "regular"). Gives a rarity boost score; this is the heading detector's input. **Useful as a "this paragraph's font size is unusual" predicate** which correlates with display-math being set in slightly larger or italicized text.
- `TextNodeUtils` is shallow — only `getTextColorOrDefault` / `getTextColorOrNull`.
- **`XYCutPlusPlusSorter.sortByYThenX`** (line 644): use this directly to sort an arbitrary set of paragraph bboxes into reading order once you've grouped them.
- **`ParagraphProcessor.areTextBlocksHaveSameTextSize`** (line 532) and `getDifferentLinesProbability` (line 506) capture the merging logic — replicating "two paragraphs share a font size and have small vertical gap" gives you a cheap math-fragment merger.

There is **no** "is this run mostly math" predicate anywhere — the codebase has zero math-content awareness in local mode.

## G. PUA / unusual glyph handling

PUA stripping happens in **two places, neither of which affects markdown text output**:

1. `AutoTaggingProcessor.stripPuaCodePoints` (line 653-665): strips `cp >= 0xE000 && cp <= 0xF8FF` plus supplementary PUA. Used **only for `/Alt` text** when writing tagged PDFs (line 701, applied to `altText`), per PDF/UA-2 clause 8.4.3.3.
2. `EnrichedImageChunk.java:70-73`: same regex `[\\uE000-\\uF8FF]|[\\uDB80-\\uDBFF][\\uDC00-\\uDFFF]` applied to image alt-text descriptions.

Markdown / JSON / HTML output paths **do not call any PUA filter**. `MarkdownGenerator.getCorrectMarkdownString` (line 400-405) only replaces ` ` with a space. The `BulletedParagraphUtils.POSSIBLE_LABELS` set even lists PUA bullet code points (``–``) so they survive to markdown intact. **Confirmed: PUA glyphs (CMEX large delimiter halves, etc.) pass through untouched into the JSON `content` and the markdown.**

## H. What's already deterministic and worth lifting

1. **`XYCutPlusPlusSorter` core algorithm** (`processors/readingorder/XYCutPlusPlusSorter.java:331-578`). The whole thing is pure-geometric and reproducible: project bboxes onto X then Y, find the largest gap >= 5pt, recurse, base-case sort by descending topY then ascending leftX. Constants: `MIN_GAP_THRESHOLD=5.0`, `NARROW_ELEMENT_WIDTH_RATIO=0.1`, `OVERLAP_THRESHOLD=0.1`, density threshold `0.9`. **This is the entire reading-order spec — replicate it in PowerShell on the JSON `bounding box` arrays and you get the same paragraph order opendataloader produces.** No external state required.
2. **Vertical-gap projection with narrow-element filter** (`findBestVerticalCutWithProjection`, line 406-444). Useful for column detection when you want to know "are these math paragraphs all in the same column band, or do they straddle a real column gap?" Reuse this exact logic on candidate paragraph bboxes.
3. **Merge-or-split predicates from `ParagraphProcessor`**: probability `>= 0.75`, `areTextBlocksHaveSameTextSize` (font sizes within `1e-1`), `areCloseStyle` (font size and weight within `1e-1`). For a math-fragment cluster merger you want a **looser** version: drop the alignment constraint and `isLabeledLine` exclusion, but keep "vertical gap < ~1.2 \* line height" and "horizontal centroids within column band". The 5pt and 1e-1 tolerances are the real numbers used by the production code.
4. **`BulletedParagraphUtils.isLabeledLine`** (line 79-97). Lift the regex set verbatim — particularly `^\(\d+\).*` — to detect equation labels (`(12)`) in your PowerShell pipeline so you can attach them back to the equation rather than treating them as prose.
5. **JSON top-level shape** (`JsonWriter.java:68-91`): the document is `{file name, number of pages, author, title, creation date, modification date, kids:[...]}` where each `kid` is a flat per-page sequence of records (no per-page wrapper, just record-by-record with each carrying `page number`). To group by page in PowerShell, group on the `page number` field.
6. **Bounding box order**: `[leftX, bottomY, rightX, topY]` (`SerializerUtil.java:132-137`) — note **bottomY before topY** and **PDF coordinate space (Y increases up)**. Don't assume image-style (Y down).

The deterministic leverage points are clear: opendataloader's reading order is fully reproducible from bboxes alone, paragraph fragmentation is predictable from `ParagraphProcessor`'s alignment+font-size+label rules, and there is no math-aware code in local mode at all. The user's pipeline can rerun XY-Cut on the JSON paragraphs, detect math hotspots by mathy-character density (since opendataloader provides none), then use vertical-gap clustering with the same `5pt / 1e-1 fontsize / 0.75 probability` constants to re-merge equation fragments into envelopes.
