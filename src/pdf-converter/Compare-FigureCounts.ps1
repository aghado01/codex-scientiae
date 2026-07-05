#requires -Version 7.0
<#
  src/pdf-converter/Compare-FigureCounts.ps1 — the STANDING figure-count oracle benchmark.

  For a paper GROUP (default the 10-paper compendia/ph-zigzag compendium) emit a per-paper Δ table
  comparing the pig figure-region count against the LaTeX-oracle figure(+diagram) count, with
  mechanism attribution and an oracle-confidence flag. This is the gate every subsequent Tier-2
  figure-clustering step re-runs: land a step, re-score the batch, watch the +over / −under tails
  collapse. (Replaces the deleted ad-hoc one-off whose numbers were never committed as tooling.)

  Per paper:
    pig_figures       count of kind=='figure' records in the NEWEST {slug}/.runs/{stamp}/pig/{slug}.figures.jsonl
    pig_images        sum of the per-page `images` field (GetImages() count) in {slug}.pdfdig.json
    oracle_figures    LaTeX oracle figure floats + TikZ diagrams (sidecar → staged source → md, in that order)
    delta             pig_figures − oracle_figures
    ratio             pig_figures / oracle_figures
    mechanism         over → 'fragmentation'; under ∧ pig_images>0 → 'raster-blindness';
                      delta==0 → 'exact'; else → 'other/oracle-noise'
    oracle_confidence 'figures_missing:N' when the oracle references images the source never provided
                      (low-confidence rows are ANNOTATED, not chased); else 'ok'

  Summary: mean |Δ|, ratio range, counts {over, under, exact}.

  Newest-run-wins mirrors the membrane's Resolve-PaperSource (runs.ps1 Get-PigRunDirs). UTF-8-no-BOM.

    pwsh -File src/pdf-converter/Compare-FigureCounts.ps1 [-Group compendia/ph-zigzag] [-Json]
    . ./Compare-FigureCounts.ps1 ; Compare-FigureCounts -Root <ingestion> -Papers 2205.11338v3
#>

[CmdletBinding()]
param(
    [string]   $Group  = 'compendia/ph-zigzag',
    [string]   $Root,
    [string[]] $Papers,
    [switch]   $Json
)

# latex-ingest.ps1 transitively dot-sources runs.ps1 (Get-PigRunDirs / newest-wins) + crawl.ps1, and
# exposes Get-LatexOracleCounts / Find-LatexMain / Resolve-LatexInputs — the ONE oracle counter model.
. "$PSScriptRoot/../latex-ingest.ps1"

# Newest-first tex run dirs ({paper}/.runs/{stamp}/tex holding the unpacked source and, once the latex
# lane has re-run, the {slug}.oracle-counts.json sidecar). Mirrors runs.ps1 Get-PigRunDirs for the tex lane.
function Get-TexRunDirs([string] $PaperDir) {
    $out = [System.Collections.Generic.List[string]]::new()
    $runsRoot = Join-Path $PaperDir '.runs'
    if ([System.IO.Directory]::Exists($runsRoot)) {
        foreach ($d in ([System.IO.Directory]::EnumerateDirectories($runsRoot) | Sort-Object -Descending)) {
            $tex = Join-Path $d 'tex'
            if ([System.IO.Directory]::Exists($tex)) { $out.Add($tex) }
        }
    }
    return $out
}

# Count \includegraphics targets that resolve to NO file anywhere under the staged tex tree — the same
# referenced-but-absent signal the latex lane persists as figures_missing (Copy-LatexFigures). Lets the
# source-fallback path still flag low-confidence oracles (e.g. 2307's 5 missing) with no sidecar present.
function Get-MissingIncludegraphics([string] $Body, [string] $TexWorkDir) {
    $missing = 0
    foreach ($m in ([regex]'\\includegraphics(?:\[[^\]]*\])?\{([^{}]+)\}').Matches($Body)) {
        $leaf = Split-Path -Leaf ($m.Groups[1].Value.Trim())
        $base = [System.IO.Path]::GetFileNameWithoutExtension($leaf)
        if ([string]::IsNullOrWhiteSpace($base)) { continue }
        $hit = @(Get-ChildItem -Path $TexWorkDir -Recurse -File -Filter "$base.*" -ErrorAction SilentlyContinue |
                 Select-Object -First 1)
        if (-not $hit) { $missing++ }
    }
    return $missing
}

# Last-resort md scan: image embeds (![](…), incl. rendered TikZ SVGs) + unrendered-TikZ markers +
# not-found figure markers ≈ the oracle object count when neither sidecar nor staged source survives.
function Get-OracleCountFromMd([string] $MdPath) {
    if (-not (Test-Path -LiteralPath $MdPath)) { return $null }
    $md = [System.IO.File]::ReadAllText($MdPath, [System.Text.UTF8Encoding]::new($false))
    $imgs   = ([regex]'!\[[^\]]*\]\([^)]+\)').Matches($md).Count
    $unrend = ([regex]'\*\[diagram \d+ — TikZ source, not rendered\]\*').Matches($md).Count
    $notfnd = ([regex]'\*\[figure:[^\]]*not found\]\*').Matches($md).Count
    return ($imgs + $unrend + $notfnd)
}

# Oracle figure(+diagram) count for one paper, newest-run-wins across the resolution ladder:
#   1. {slug}.oracle-counts.json sidecar in the newest tex run  (authoritative, carries figures_missing)
#   2. re-derive from that run's staged \input-flattened source  (Get-LatexOracleCounts + missing scan)
#   3. count image/diagram markers in the {slug}-latex.md deliverable beside the source
# Returns @{ count; missing; source; run } (count/missing null when nothing resolves).
function Resolve-OracleCount([string] $PaperDir, [string] $Slug) {
    $texRuns = Get-TexRunDirs $PaperDir

    foreach ($tex in $texRuns) {                          # (1) sidecar — first newest run that has one
        $sidecar = Join-Path $tex "$Slug.oracle-counts.json"
        if (Test-Path -LiteralPath $sidecar) {
            $o = [System.IO.File]::ReadAllText($sidecar, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
            return @{ count = [int]$o.oracle_figures; missing = [int]$o.figures_missing
                      source = 'sidecar'; run = (Split-Path -Leaf (Split-Path -Parent $tex)) }
        }
    }
    foreach ($tex in $texRuns) {                          # (2) staged source fallback (reuse the counter model)
        $main = try { Find-LatexMain $tex } catch { $null }
        if (-not $main) { continue }
        $body = Resolve-LatexInputs -MainPath $main
        $oc   = Get-LatexOracleCounts $body
        $miss = Get-MissingIncludegraphics $body $tex
        return @{ count = [int]$oc.oracle_figures; missing = [int]$miss
                  source = 'source'; run = (Split-Path -Leaf (Split-Path -Parent $tex)) }
    }
    $mdCount = Get-OracleCountFromMd (Join-Path $PaperDir "$Slug-latex.md")   # (3) md last resort
    if ($null -ne $mdCount) { return @{ count = [int]$mdCount; missing = $null; source = 'md'; run = $null } }
    return @{ count = $null; missing = $null; source = 'none'; run = $null }
}

# pig figure-region count (kind=='figure') from a figures.jsonl lane.
function Get-PigFigureCount([string] $FiguresJsonl) {
    if (-not (Test-Path -LiteralPath $FiguresJsonl)) { return $null }
    $n = 0
    foreach ($line in [System.IO.File]::ReadLines($FiguresJsonl)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if (($line | ConvertFrom-Json).kind -eq 'figure') { $n++ }
    }
    return $n
}

# per-page GetImages() count summed over the envelope's pages array (read the key back, don't assume nesting).
function Get-PigImageCount([string] $EnvelopePath) {
    if (-not (Test-Path -LiteralPath $EnvelopePath)) { return $null }
    $env = [System.IO.File]::ReadAllText($EnvelopePath, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
    $sum = 0
    foreach ($p in @($env.pages)) {
        $prop = $p.PSObject.Properties['images']
        if ($prop -and $null -ne $prop.Value) { $sum += [int]$prop.Value }
    }
    return $sum
}

function Compare-FigureCounts {
    [CmdletBinding()]
    param(
        [string]   $Group  = 'compendia/ph-zigzag',
        [string]   $Root,
        [string[]] $Papers
    )
    if (-not $Root) { $Root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../ingestion')).Path }

    # paper dirs: an explicit -Papers list, else every subdir of the group (each named by its slug).
    $groupDir = Join-Path $Root $Group
    if (-not (Test-Path -LiteralPath $groupDir)) { throw "group not found: $groupDir" }
    $paperDirs =
        if ($Papers) { $Papers | ForEach-Object { Join-Path $groupDir $_ } }
        else         { Get-ChildItem -LiteralPath $groupDir -Directory | Sort-Object Name | ForEach-Object FullName }

    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($paperDir in $paperDirs) {
        if (-not (Test-Path -LiteralPath $paperDir)) { Write-Warning "paper dir not found: $paperDir"; continue }
        $slug = Split-Path -Leaf $paperDir

        $pigDirs   = @(Get-PigRunDirs $paperDir $slug)
        $pigFigures = $null; $pigImages = $null; $pigRun = $null
        if ($pigDirs.Count) {
            $pigDir     = $pigDirs[0]
            $pigRun     = Split-Path -Leaf (Split-Path -Parent (Split-Path -Parent $pigDir))
            $pigFigures = Get-PigFigureCount (Join-Path $pigDir "$slug.figures.jsonl")
            $pigImages  = Get-PigImageCount  (Join-Path $pigDir "$slug.pdfdig.json")
        }

        $oracle = Resolve-OracleCount $paperDir $slug
        $oracleFigures = $oracle.count

        $delta = $null; $ratio = $null; $mechanism = 'no-data'
        if ($null -ne $pigFigures -and $null -ne $oracleFigures) {
            $delta = $pigFigures - $oracleFigures
            $ratio = if ($oracleFigures -gt 0) { [math]::Round($pigFigures / $oracleFigures, 2) } else { $null }
            $mechanism =
                if     ($delta -gt 0)                              { 'fragmentation' }
                elseif ($delta -lt 0 -and $pigImages -gt 0)        { 'raster-blindness' }
                elseif ($delta -eq 0)                              { 'exact' }
                else                                               { 'other/oracle-noise' }
        } elseif ($null -eq $pigFigures) { $mechanism = 'no-pig-run' }
          elseif ($null -eq $oracleFigures) { $mechanism = 'no-oracle' }

        $confidence = if ($oracle.missing) { "figures_missing:$($oracle.missing)" } else { 'ok' }

        $rows.Add([ordered]@{
            slug              = $slug
            pig_figures       = $pigFigures
            pig_images        = $pigImages
            oracle_figures    = $oracleFigures
            delta             = $delta
            ratio             = $ratio
            mechanism         = $mechanism
            oracle_confidence = $confidence
            oracle_src        = $oracle.source
            pig_run           = $pigRun
        })
    }

    # summary over rows that carry BOTH counts (a real Δ).
    $scored = @($rows | Where-Object { $null -ne $_.delta })
    $over  = @($scored | Where-Object { $_.delta -gt 0 }).Count
    $under = @($scored | Where-Object { $_.delta -lt 0 }).Count
    $exact = @($scored | Where-Object { $_.delta -eq 0 }).Count
    $meanAbs = if ($scored.Count) { [math]::Round((($scored | ForEach-Object { [math]::Abs($_.delta) } | Measure-Object -Sum).Sum / $scored.Count), 2) } else { $null }
    $ratios  = @($scored | Where-Object { $null -ne $_.ratio } | ForEach-Object { $_.ratio })
    $summary = [ordered]@{
        papers      = $rows.Count
        scored      = $scored.Count
        over        = $over
        under       = $under
        exact       = $exact
        mean_abs_delta = $meanAbs
        ratio_min   = if ($ratios.Count) { ($ratios | Measure-Object -Minimum).Minimum } else { $null }
        ratio_max   = if ($ratios.Count) { ($ratios | Measure-Object -Maximum).Maximum } else { $null }
    }

    return [pscustomobject]@{ Group = $Group; Rows = $rows.ToArray(); Summary = [pscustomobject]$summary }
}

# Pretty console rendering of a report (fixed-width table + summary line). Built by hand rather than
# Format-Table|Out-Host so the table survives stream redirection/capture (Format-Table renders blank
# cells when its host is piped) — this is a "run one command, read the table" benchmark tool.
function Show-FigureCountReport($Report) {
    $cols = @(
        @{ h='paper';      w=16; a='l'; e={ $_.slug } },
        @{ h='pig_fig';    w=7;  a='r'; e={ $_.pig_figures } },
        @{ h='pig_img';    w=7;  a='r'; e={ $_.pig_images } },
        @{ h='oracle';     w=6;  a='r'; e={ $_.oracle_figures } },
        @{ h='delta';      w=5;  a='r'; e={ $_.delta } },
        @{ h='ratio';      w=5;  a='r'; e={ $_.ratio } },
        @{ h='mechanism';  w=18; a='l'; e={ $_.mechanism } },
        @{ h='confidence'; w=18; a='l'; e={ $_.oracle_confidence } },
        @{ h='src';        w=7;  a='l'; e={ $_.oracle_src } }
    )
    $fmt = {
        param($vals)
        $parts = for ($i = 0; $i -lt $cols.Count; $i++) {
            $s = [string]$vals[$i]
            if ($s.Length -gt $cols[$i].w) { $s = $s.Substring(0, $cols[$i].w) }
            if ($cols[$i].a -eq 'r') { $s.PadLeft($cols[$i].w) } else { $s.PadRight($cols[$i].w) }
        }
        ($parts -join '  ')
    }
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('')
    $lines.Add("Figure-count oracle batch — $($Report.Group)")
    $lines.Add((& $fmt ($cols | ForEach-Object { $_.h })))
    $lines.Add((& $fmt ($cols | ForEach-Object { '-' * $_.w })))
    foreach ($row in $Report.Rows) {
        # $c (not $_) for the column loop, and pipe $row so $_ inside the column evaluator is the ROW
        $vals = foreach ($c in $cols) { $v = $row | ForEach-Object $c.e; if ($null -eq $v) { '·' } else { $v } }
        $lines.Add((& $fmt $vals))
    }
    $s = $Report.Summary
    $lines.Add('')
    $lines.Add(("summary: {0} papers ({1} scored) — {2} over / {3} under / {4} exact; mean |Δ| = {5}; ratio {6}–{7}×" -f `
        $s.papers, $s.scored, $s.over, $s.under, $s.exact, $s.mean_abs_delta, $s.ratio_min, $s.ratio_max))
    $lines.Add('')
    ($lines -join [Environment]::NewLine)
}

# --- CLI shim: self-run only when executed directly (pwsh -File … / ./…), never when dot-sourced ------
if ($MyInvocation.InvocationName -ne '.') {
    $report = Compare-FigureCounts -Group $Group -Root $Root -Papers $Papers
    if ($Json) { $report | ConvertTo-Json -Depth 6 } else { Show-FigureCountReport $report }
}
