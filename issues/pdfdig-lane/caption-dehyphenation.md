# Pig block/caption text keeps PDF line-wrap hyphens — de-hyphenation gap (2026-07-08)

**Status:** SCOPED for delegation. Contained converter fix + unit tests. Surfaced by the Jul-7 finalize
weave regressing two voroninski deliverables; the deliverables were hand-fixed (`6eb0e82`), but the next
regen will re-break them until this lands.

## Problem

The pig converter (`src/pdf-converter/pdfdig-ir.ps1`, LANE 3 blocks) assembles each block's `text` from
PdfPig's `$b.Text`, which concatenates the block's `TextLines`. When a word wraps across a line in the
PDF, `$b.Text` yields `illumina-\ntions`, and the whitespace normalization at **`pdfdig-ir.ps1:480`** —
`$blockText = ($b.Text -replace '\s+',' ')` — collapses the newline to a space, producing
**`illumina- tions`** (hyphen + space + lowercase continuation). That block text is what
`figures.jsonl` `caption.text` carries, and the finalize weave threads it verbatim into `{slug}-membrane.md`.

**Evidence** (both are pig `figures.jsonl` caption text, run `20260707_*`):
- `1109.0573v2` id4: `…using oblique illumina- tions. The left image…` (id3/id12 captions clean — those
  papers' captions didn't wrap that word)
- `2008.10579v1` Fig 3: `…100 measurements (left) and 300 measure- ments (right)…`

The membrane body chunker **already** de-hyphenates (`src/collapse.ps1:114-124`: on a line-break join,
`content.EndsWith('-') ∧ next ~ ^[a-z]` → strip the hyphen, join tight, flag `dehyphenated`) — but that
lane never sees pig caption text. This is the same operation, missing in the pig block assembly.

## Fix location + approach

**`pdfdig-ir.ps1` LANE 3, line 480.** Do NOT regex the flattened `$blockText` (a magic-string heuristic on
`"([a-z])- ([a-z])"` — see [[no-magic-string-structural-heuristics]]): after `-replace '\s+',' '` the
line-boundary signal is gone and a real compound that *happens* to have a space can't be told from a wrap.
Instead assemble `$blockText` **from `$b.TextLines`** (line boundaries still intact in that loop, cf. the
per-line `$tl.Text` already read at line 473), de-hyphenating at each line seam exactly as `collapse.ps1`
does at its Δtop line-join:

```
# replaces line 480's flatten. $lineTexts = each $tl.Text with \s+ -> ' ', trimmed.
$sb = [System.Text.StringBuilder]::new(); $dehy = $false
for ($k = 0; $k -lt $lineTexts.Count; $k++) {
    $t = $lineTexts[$k]
    if ($k -eq 0) { [void]$sb.Append($t); continue }
    $cur = $sb.ToString()
    if ($cur -match '[a-z]-$' -and $t -match '^[a-z]') {          # soft word-wrap hyphen -> strip + tight join
        $sb.Length -= 1; [void]$sb.Append($t); $dehy = $true       # (letter before '-', lowercase continuation)
    }
    elseif ($cur.EndsWith('-')) { [void]$sb.Append($t) }          # uppercase/other continuation: keep hyphen, tight
    else { [void]$sb.Append(' '); [void]$sb.Append($t) }          # normal line join: single space
}
$blockText = $sb.ToString()
# on $dehy, set a block field (e.g. dehyphenated = $true) so the enrichment tier can verify best-effort joins
```

Note the `[a-z]-$` guard (letter immediately before the hyphen) — mirrors collapse.ps1 and avoids stripping
a dangling operator/rule that isn't a word wrap. `text_preview` (line 481) derives from `$blockText`, so it
inherits the fix.

## Caveat (inherit collapse.ps1's, documented not solved)

A genuine compound can wrap at its own hyphen (`delta-`/`homology` → `deltahomology`, wrong). Can't
disambiguate without a lexicon, so this is **best-effort + flag** — set `dehyphenated` on the block and let
the enrichment tier verify. `on-axis`/`off-axis`/`1-layer` do NOT wrap in practice (they sit within a line,
no line seam), so they're untouched; the guard only fires at an actual line boundary.

## Tests (`tests/pdfdig-ir.Tests.ps1`)

Feed synthetic `TextLines` (or the block-text assembler if refactored into a testable helper — preferred):
1. `["illumina-", "tions"]` → `illuminations`, `dehyphenated=$true`.
2. `["…direct (on-axis) illumination and", "the right…"]` → space join, hyphen in `on-axis` untouched,
   `dehyphenated=$false`.
3. `["X-", "Ray imaging"]` → `X-Ray imaging` (uppercase continuation keeps the hyphen).
4. `["delta-", "homology"]` → `deltahomology`, `dehyphenated=$true` (accepted false-join, flagged).
5. Single line `["no wrap here"]` → unchanged, no flag.

## Acceptance

1. Unit tests above green; existing `pdfdig-ir` / `pdfdig-figures` tests unaffected (block `bx`/lines/word
   ids/geometry untouched — this is TEXT-only).
2. Regenerate `1109.0573v2` + `2008.10579v1` pig runs (`Invoke-Pdfdig`): their figure captions come out
   clean (`illuminations`, `measurements`); `dehyphenated` flags on exactly the wrapped blocks.
3. Figure-count gate unchanged both corpora (`Compare-FigureCounts`) — de-hyphenation is text-only, does
   not move region geometry/kind/caption-attachment.
4. Spot-check a diagram-heavy ph-zigzag paper for no over-join of legitimate compounds (flag review).

## Why delegated, not landed here

Per the token-economy directive, this converter change + regen + re-finalize is a good copilot hand-off.
The two deliverables are already clean on disk (`6eb0e82`); this removes the regen-churn that would undo
them. Related: `src/collapse.ps1:114` (reference impl), `src/pdf-converter/pdfdig-ir.ps1:480` (fix site),
[[docling-failure-modes-brief]] (membrane-also-destroys-structure sibling class), the finalize weave
([[membrane-publish-lane]]) that surfaced it.
