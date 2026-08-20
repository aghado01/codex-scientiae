# pdf-prose

PdfPig letter substrate plus DocumentLayoutAnalysis for page prose.

Pipeline per page: `Page.Letters` → drop empty / optional Invisible → `NearestNeighbourWordExtractor` (baseline endpoints) → `RecursiveXYCut` → `UnsupervisedReadingOrderDetector` (column-wise) → line join.

The prose channel is the concatenation of `Letter.Value` in reading order. That string is UTF-16, same as PdfPig. Presentation-form ligatures stay as those scalars. `Specials` are `Start`/`End` UTF-16 offsets into `Text`. Isolated surrogates are counted, not repaired.

`TextEscaped` is a lossless ASCII projection of `Text`: `\` → `\\`, every non-ASCII UTF-16 code unit → `\uXXXX` (including unpaired surrogates). Tab/LF/CR and other ASCII stay literal. `ConvertFrom-PdfProseUtf16Escape` is the inverse. `-OutFile` writes `TextEscaped`. Offsets in `Specials` address `Text`, not `TextEscaped`.

`New-PdfProseIr` builds the assembly IR as an ordered list of `PSCustomObject` records (`PdfProse.Document`, `PdfProse.Section`, `PdfProse.Block`). JSONL is that list serialized, one object per line — `Export-PdfProseJsonl` does not invent a second shape. Sections come from the PDF outline when present, otherwise one implicit section. Each block keeps `textEscaped` (lossless) and `textRender` (non-ASCII decisions from `non-ascii.json`: ligatures expand, soft hyphens elide, other letters keep, everything else escape). Markdown is a later consumer of `textRender`.

`-RemoveNewLineHyphens` (default `$true`) deletes a hyphen that exists only because the word was broken across a line (`infor-` + `mation` → `information`). Required: last scalar on the line, next line starts lowercase, and the next glyph’s baseline is strictly below the hyphen (`Test-PdfProseNewlineAfterHyphen`). Same-baseline text after a hyphen is not a newline hyphen. A column wrap (next baseline above) is not either. `U+2011` is never removed. Lexical compounds in `newline-hyphens.json` (`well-known`, `motor-kinesthetic`, `twenty-six`) keep the hyphen. Prefixes in that file (`over-come`) still join. Pass `-RemoveNewLineHyphens:$false` to leave every hyphen. Removals are recorded on `RemovedNewLineHyphens`.

XY-cut is a claim: Manhattan two-column academic pages are the intended case. Spanning floats and non-rectangular gutters can mis-cut.

Block `role` is assigned after XY-cut: `page-marker` (`[n]`), `folio` (digits in the top 8% of the page), `running-header` (other short text in that band), `float-caption` (`Figure N` / `Fig. N`), `float-label` (text whose box intersects an image), else `body`. Images from `Page.GetImages()` become `kind=float` records (`type=image`) with geometry and a bound caption when a caption sits just below the image. A float is inserted before the first `body` / `float-caption` / `float-label` block whose top is at or below the image; decorations do not move it. Body channel is `role=body`. Captions, headers, folios, and page markers stay in the IR. Tables, footnotes, speaker turns, and vector drawings are not classified.
