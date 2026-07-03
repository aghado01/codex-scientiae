#requires -Version 7.0
<#
  src/pdf-converter/math-evidence.ps1 — the modality bridge for gated math repair.

  When the deterministic assembler (math-assembler.ps1) cannot resolve a display equation — it flags
  unbalanced_delimiters / would-be-2D — the case is doled to the membrane's reasoning tier. But a
  language model reasons over TEXT, not geometry (the brief's modality wall: pig is the blind father,
  the model the deaf son). This module PROJECTS the glyph geometry into a text transcript the model
  can reason over — the same evidence the converter had, rendered readable:

    1. best-effort LaTeX  — what the deterministic assembler produced (+ why it's suspect)
    2. glyph table        — every glyph with x / baseline / size / tier (script depth) / role
    3. spatial sketch     — glyphs placed on a 2-D character grid by position, rule-bars drawn;
                            a fraction shows numerator / ――― / denominator, so the model can see
                            structure the 1-D assembler couldn't (and pair delimiters the
                            line-based split fractured)

  Deterministic, geometry-only, no rasterization (PdfPig truncates at the display list). The payload
  rides on the flagged formula chunk into get_slice; the model proposes corrected LaTeX; render_check
  gates it. Distillation-not-delegation holds: the model reasons over the SAME geometry, it is not
  handed an answer from a sidecar.

    . ./math-evidence.ps1
    Get-MathEvidence -Letters <glyph[]> [-Rules <path[]>] [-Latex <best-effort>] [-Note <why>]
#>

# cluster baselines into rows (distinct vertical bands), top-first. Tol scales with the modal size.
function Get-BaselineRows([object[]] $Letters, [double] $TolFrac = 0.35) {
    $sizes = @($Letters | ForEach-Object { [double]$_.size })
    $modal = ($sizes | Group-Object | Sort-Object Count -Descending | Select-Object -First 1).Name
    $tol = [math]::Max(1.0, $TolFrac * [double]$modal)
    $bys = @($Letters | ForEach-Object { [double]$_.base[1] } | Sort-Object -Descending)
    $rows = [System.Collections.Generic.List[double]]::new()
    foreach ($y in $bys) {
        $placed = $false
        foreach ($r in $rows) { if ([math]::Abs($r - $y) -le $tol) { $placed = $true; break } }
        if (-not $placed) { $rows.Add($y) }
    }
    return @($rows | Sort-Object -Descending)   # top of page first
}

# the compact glyph table: one row per glyph, with computed size-tier (0=base .. deeper=nested script)
function Get-GlyphTable([object[]] $Letters) {
    $ord = @($Letters | Sort-Object @{Expression={[double]$_.base[1]}; Descending=$true}, @{Expression={[double]$_.bx[0]}; Descending=$false})
    $sizes = @($Letters | ForEach-Object { [double]$_.size } | Sort-Object -Descending -Unique)
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine('  glyph |    x    |  baseline |  size | tier')
    [void]$sb.AppendLine('  ------+---------+-----------+-------+-----')
    foreach ($g in $ord) {
        $tier = [array]::IndexOf($sizes, [double]$g.size)   # 0 = largest (base), 1,2 = script depth
        [void]$sb.AppendLine(('  {0,-5} | {1,7:F1} | {2,9:F1} | {3,5:F1} | {4}' -f `
            ([string]$g.text), [double]$g.bx[0], [double]$g.base[1], [double]$g.size, $tier))
    }
    return $sb.ToString().TrimEnd()
}

# 2-D character grid: glyphs at (row=baseline band, col=x/pitch); rule bars drawn as '─' runs.
function Get-SpatialSketch([object[]] $Letters, [object[]] $Rules = @(), [int] $MaxCols = 100) {
    if ($Letters.Count -eq 0) { return '' }
    $minX = ($Letters | ForEach-Object { [double]$_.bx[0] } | Measure-Object -Minimum).Minimum
    $maxX = ($Letters | ForEach-Object { [double]$_.bx[2] } | Measure-Object -Maximum).Maximum
    $widths = @($Letters | ForEach-Object { [double]$_.bx[2] - [double]$_.bx[0] } | Where-Object { $_ -gt 0 } | Sort-Object)
    $pitch = if ($widths.Count) { [math]::Max(1.2, $widths[[int]($widths.Count/2)] * 0.6) } else { 3.0 }
    $ncols = [math]::Min($MaxCols, [int](($maxX - $minX) / $pitch) + 3)

    $rows = Get-BaselineRows $Letters
    # include rule bars as their own rows (positioned by their y-center among the baselines)
    $rowY = [System.Collections.Generic.List[object]]::new()
    foreach ($r in $rows) { $rowY.Add(@{ y=$r; kind='text' }) }
    foreach ($p in $Rules) {
        if ($null -eq $p.bbox) { continue }
        $ry = ([double]$p.bbox[1] + [double]$p.bbox[3]) / 2.0
        $rowY.Add(@{ y=$ry; kind='rule'; rule=$p })
    }
    $sorted = @($rowY | Sort-Object { -[double]$_.y })   # top first

    $grid = New-Object 'char[][]' $sorted.Count
    for ($i = 0; $i -lt $sorted.Count; $i++) {
        $grid[$i] = [char[]]::new($ncols)
        for ($j = 0; $j -lt $ncols; $j++) { $grid[$i][$j] = ' ' }
    }
    # map a y to its nearest row index
    $rowIndexOf = {
        param($y)
        $best = 0; $bd = [double]::MaxValue
        for ($i = 0; $i -lt $sorted.Count; $i++) { $d = [math]::Abs([double]$sorted[$i].y - $y); if ($d -lt $bd) { $bd = $d; $best = $i } }
        return $best
    }
    foreach ($g in $Letters) {
        $ri = & $rowIndexOf ([double]$g.base[1])
        $col = [int]((([double]$g.bx[0]) - $minX) / $pitch)
        foreach ($ch in ([string]$g.text).ToCharArray()) {
            if ($col -ge 0 -and $col -lt $ncols) { $grid[$ri][$col] = $ch }
            $col++
        }
    }
    for ($i = 0; $i -lt $sorted.Count; $i++) {
        if ($sorted[$i].kind -ne 'rule') { continue }
        $p = $sorted[$i].rule
        $c0 = [math]::Max(0, [int](([double]$p.bbox[0] - $minX) / $pitch))
        $c1 = [math]::Min($ncols-1, [int](([double]$p.bbox[2] - $minX) / $pitch))
        for ($c = $c0; $c -le $c1; $c++) { $grid[$i][$c] = [char]0x2500 }   # ─
    }
    $lines = for ($i = 0; $i -lt $sorted.Count; $i++) { -join $grid[$i] }
    return (($lines | ForEach-Object { $_.TrimEnd() }) -join "`n")
}

# THE MEMBRANE SEAM: recover a flagged formula chunk's geometry from the pig lanes beside the PDF and
# project the evidence. get_slice calls this for a math_assembly work-unit so the reasoning tier reads
# the SAME geometry the deterministic assembler had. Returns $null when the pig lanes are absent (a
# docling-lane chunk, or geometry not staged) — the caller degrades to content-only, never fails.
function Get-ChunkMathEvidence {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Chunk,         # a formula chunk: page, bbox [x0,y0,x1,y1], content, flags
        [Parameter(Mandatory)] [string] $PaperDir,
        [string] $Slug,
        [double] $Margin = 2.0
    )
    if (-not $Slug) { $Slug = Split-Path -Leaf $PaperDir }
    $lettersPath = Join-Path $PaperDir "$Slug.letters.jsonl"
    if (-not (Test-Path $lettersPath)) { return $null }   # not a pig-lane paper / geometry not staged
    $bb = $Chunk.bbox
    if (-not $bb -or $bb.Count -ne 4) { return $null }
    $pg = [int]$Chunk.page
    $x0=[double]$bb[0]-$Margin; $y0=[double]$bb[1]-$Margin; $x1=[double]$bb[2]+$Margin; $y1=[double]$bb[3]+$Margin

    $inRegion = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadAllLines($lettersPath)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $g = $line | ConvertFrom-Json
        if ([int]$g.page -ne $pg) { continue }
        # glyph center inside the (margined) chunk bbox
        $cx = ([double]$g.bx[0] + [double]$g.bx[2]) / 2.0
        $cy = ([double]$g.bx[1] + [double]$g.bx[3]) / 2.0
        if ($cx -ge $x0 -and $cx -le $x1 -and $cy -ge $y0 -and $cy -le $y1) { $inRegion.Add($g) }
    }
    if ($inRegion.Count -eq 0) { return $null }

    $rules = @()
    $pathsPath = Join-Path $PaperDir "$Slug.paths.jsonl"
    if (Test-Path $pathsPath) {
        $rules = @(foreach ($line in [System.IO.File]::ReadAllLines($pathsPath)) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            $p = $line | ConvertFrom-Json
            if ([int]$p.page -eq $pg -and $p.rule -eq 'hrule' -and $null -ne $p.bbox) {
                $ry = ([double]$p.bbox[1] + [double]$p.bbox[3]) / 2.0
                if ($ry -ge $y0 -and $ry -le $y1) { $p }
            }
        })
    }
    $note = if ($Chunk.flags) { "converter flags: $(@($Chunk.flags) -join ', ')" } else { 'flagged by fidelity re-derivation' }
    return Get-MathEvidence -Letters $inRegion.ToArray() -Rules $rules -Latex ([string]$Chunk.content) -Note $note
}

function Get-MathEvidence {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [object[]] $Letters,
        [object[]] $Rules = @(),
        [string] $Latex = '',
        [string] $Note = ''
    )
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine('=== MATH ASSEMBLY EVIDENCE (geometry the deterministic converter could not resolve) ===')
    if ($Latex) { [void]$sb.AppendLine("best-effort LaTeX : $Latex") }
    if ($Note)  { [void]$sb.AppendLine("why flagged       : $Note") }
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('glyphs (reading order, tier = script depth by size):')
    [void]$sb.AppendLine((Get-GlyphTable $Letters))
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('spatial layout (glyphs placed by position; ─ = drawn rule/fraction bar):')
    [void]$sb.AppendLine((Get-SpatialSketch $Letters $Rules))
    return $sb.ToString().TrimEnd()
}
