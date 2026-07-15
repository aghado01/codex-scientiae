#requires -Version 7.0
# A1 CALIBRATION PROBE (issues/clustering/tier3-engineering-plan.md thrust A1 — caption-prefix alignment).
# Question: is there a REAL "cue-matched but rejected-by-prefix" tail, or is the attachment cue already
# lenient enough that leading-glyph captions ("~ Figure 10:", "1 Figure 16:") are all caught?
#
# Per corpus, over the NEWEST pig run of each paper, enumerate caption-SHAPED Lane-3 blocks (the lane's
# unanchored 14-char cue scan) and split them by PREFIX form:
#   plain    — text starts exactly with the cue word (^(Figure|Fig|Table|...))
#   glyph    — up to 4 NON-LETTER junk glyphs (incl. digits) precede the cue  ([^\p{L}]{0,4} — splitter's proven form)
#   far      — cue lands past a >4-glyph / non-conforming prefix (would need a wider window)
# For each non-plain block report whether a figure region CLAIMED it (caption.block_id) — the recoverable
# tail is non-plain AND unclaimed AND figure-cued.
param([string[]]$Groups = @('gauntlet/ph-zigzag', 'gauntlet/voroninski'))
$ErrorActionPreference = 'Stop'
$root = 'D:\aghado01\codex-scientiae\ingestion'

$cueScan  = [regex]'(Figure|Fig|Table|Tab|Algorithm|Listing)\.?\s*\d'   # unanchored, as the lane scans first 14
$plainRe  = [regex]'^(Figure|Fig|Table|Tab|Algorithm|Listing)'
$glyphRe  = [regex]'^[^\p{L}]{0,4}(Figure|Fig|Table|Tab|Algorithm|Listing)\.?\s*\d'   # proven-safe canonical
$figCue   = [regex]'^[^\p{L}]{0,4}(Figure|Fig)\b'

foreach ($group in $Groups) {
    Write-Host ("`n================ {0} ================" -f $group)
    $papers = Get-ChildItem (Join-Path $root $group) -Directory -EA 0 | Sort-Object Name
    $totPlain = 0; $totGlyph = 0; $totFar = 0; $recoverable = @()
    foreach ($pd in $papers) {
        $slug = $pd.Name
        $fj = Get-ChildItem (Join-Path $pd.FullName ".runs/*/pig/$slug.figures.jsonl") -EA 0 |
            Sort-Object { $_.Directory.Parent.Name } -Desc | Select-Object -First 1
        if (-not $fj) { continue }
        $dir = $fj.Directory.FullName
        $bj = Join-Path $dir "$slug.blocks.jsonl"
        if (-not (Test-Path $bj)) { continue }
        $figs = @(Get-Content $fj.FullName | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json })
        $claimed = @{}
        foreach ($f in $figs) { if ($f.caption -and $null -ne $f.caption.block_id) { $claimed[[int]$f.caption.block_id] = $true } }
        foreach ($line in [System.IO.File]::ReadLines($bj)) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            $b = $line | ConvertFrom-Json
            if (-not $b.bx) { continue }
            $txt = if ($b.text) { [string]$b.text } elseif ($b.text_preview) { [string]$b.text_preview } else { '' }
            if ($txt.Length -eq 0) { continue }
            $head = $txt.Substring(0, [math]::Min(14, $txt.Length))
            if (-not $cueScan.IsMatch($head)) { continue }         # caption-shaped by the lane's scan
            if ($plainRe.IsMatch($txt)) { $totPlain++; continue }  # plain prefix — no A1 concern
            $isClaimed = [bool]$claimed[[int]$b.id]
            if ($glyphRe.IsMatch($txt)) {
                $totGlyph++
                if (-not $isClaimed -and $figCue.IsMatch($txt)) {
                    $recoverable += [pscustomobject]@{ slug=$slug; page=$b.page; id=$b.id; claimed=$isClaimed; head=$head }
                }
            } else {
                $totFar++
                if (-not $isClaimed) {
                    $recoverable += [pscustomobject]@{ slug=$slug; page=$b.page; id=$b.id; claimed=$isClaimed; head=('FAR:'+$head) }
                }
            }
        }
    }
    Write-Host ("plain-prefix cue blocks: {0}   glyph-prefix (<=4 junk): {1}   far/nonconforming: {2}" -f $totPlain, $totGlyph, $totFar)
    Write-Host ("--- non-plain figure-cued blocks NOT claimed by any region (the A1 recoverable tail) ---")
    if ($recoverable.Count -eq 0) { Write-Host "  (none)" }
    else { $recoverable | ForEach-Object { Write-Host ("  {0,-14} pg{1,-3} blk{2,-5} '{3}'" -f $_.slug, $_.page, $_.id, $_.head) } }
}
