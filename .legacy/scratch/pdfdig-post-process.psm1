# opendocloader-post-process.psm1
#
# Strips figure-OCR / chart-text pollution from opendataloader-pdf hybrid markdown
# output. Anchors on `![image N](...)` links and removes adjacent runs of short,
# non-prose blocks while preserving figure captions, panel labels, headings,
# citations, and clean LaTeX math blocks.
#
# Strip rule (all three must hold):
#   1. Block kind is POLLUTION_CANDIDATE or AMBIGUOUS
#   2. Block sits in a pollution zone (rolling-window burstiness > 0.6)
#   3. Block is part of a consecutive run from an anchor (>=3 forward, >=2 back)
#
# Public:
#   Invoke-OpenDataLoaderPostProcess  -- run the cleaner over a markdown file
#   Get-MarkdownBlockReport           -- per-block kind/length/burstiness dump

# ---- Tunables --------------------------------------------------------------

$script:POLLUTION_LENGTH_THRESHOLD = 40    # block length below this is "short"
$script:LEGITIMATE_PROSE_LENGTH    = 80    # min length for sentence-shaped prose
$script:BURSTINESS_WINDOW          = 7     # blocks per rolling window
$script:POLLUTION_ZONE_THRESHOLD   = 0.6   # burstiness above this => pollution
$script:CLEAN_ZONE_THRESHOLD       = 0.3   # burstiness below this => zone exit
$script:FORWARD_RUN_MIN            = 3     # min forward candidates to commit strip
$script:BACKWARD_RUN_MIN           = 2     # min backward candidates to commit strip

# ---- Block tokenization ----------------------------------------------------

function Split-MarkdownIntoBlocks {
    param([Parameter(Mandatory)][string]$Path)

    $raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrEmpty($raw)) { return @() }

    $lines = $raw -split '\r?\n'
    $blocks = New-Object System.Collections.Generic.List[object]
    $i = 0
    while ($i -lt $lines.Count) {
        while ($i -lt $lines.Count -and $lines[$i] -match '^\s*$') { $i++ }
        if ($i -ge $lines.Count) { break }

        $startLine = $i + 1
        $buf = New-Object System.Collections.Generic.List[string]
        while ($i -lt $lines.Count -and $lines[$i] -notmatch '^\s*$') {
            $buf.Add($lines[$i])
            $i++
        }
        $endLine = $i  # 1-indexed last consumed (we incremented past it)
        $text = $buf -join "`n"

        $blocks.Add([PSCustomObject]@{
            Index     = $blocks.Count
            StartLine = $startLine
            EndLine   = $endLine
            Text      = $text
            Length    = $text.Trim().Length
            Kind      = $null
        })
    }
    return ,$blocks.ToArray()
}

# ---- Block kind resolution -------------------------------------------------

function Resolve-BlockKind {
    param([Parameter(Mandatory)][object]$Block)

    $trimmed = $Block.Text.Trim()
    $len = $trimmed.Length
    if ($len -eq 0) { return 'EMPTY' }

    # Order matters; first match wins.
    if ($trimmed -match '^!\[[^\]]*\]\(.+\)')                                                 { return 'ANCHOR' }
    if ($trimmed -match '^(Figure|Table)\s+\d+[:.\s]')                                        { return 'FIGURE_CAPTION' }
    if ($trimmed -match '^#+\s')                                                              { return 'HEADING' }
    if ($trimmed -match '^[-*+]\s' -or $trimmed -match '^\d+\.\s')                            { return 'LIST_ITEM' }
    if ($trimmed.StartsWith('$$'))                                                            { return 'CLEAN_LATEX' }
    if ($trimmed -match '^\(?[A-Z]\)$')                                                       { return 'PANEL_LABEL' }
    if ($trimmed -match '\(\d{4}[a-z]?\)' -or
        $trimmed -match '\([A-Z][a-zA-Z\-\.]+(?:\s+(?:and|&)\s+[A-Z][a-zA-Z\-\.]+)?(?:\s+et\s+al\.?)?,?\s+\d{4}[a-z]?\)' -or
        $trimmed -match '\bet\s+al\.')                                                        { return 'CITATION_BLOCK' }
    if ($len -ge $script:LEGITIMATE_PROSE_LENGTH -and
        $trimmed -match '[.!?]\s+[A-Z]' -and
        $trimmed -match '[.!?][\s"'')\]]*$')                                                  { return 'LEGITIMATE_PROSE' }
    if ($len -lt $script:POLLUTION_LENGTH_THRESHOLD -and
        $trimmed -notmatch '[.!?][\s"'')\]]*$')                                               { return 'POLLUTION_CANDIDATE' }
    return 'AMBIGUOUS'
}

# ---- Burstiness ------------------------------------------------------------

function Get-Burstiness {
    param(
        [Parameter(Mandatory)][object[]]$Blocks,
        [Parameter(Mandatory)][int]$CenterIndex,
        [int]$WindowSize = $script:BURSTINESS_WINDOW
    )
    if ($Blocks.Count -eq 0) { return 0.0 }
    $half = [Math]::Floor($WindowSize / 2)
    $start = [Math]::Max(0, $CenterIndex - $half)
    $end   = [Math]::Min($Blocks.Count - 1, $CenterIndex + $half)
    $window = $Blocks[$start..$end]
    $shortCount = 0
    foreach ($b in $window) {
        if ($b.Length -lt $script:POLLUTION_LENGTH_THRESHOLD) { $shortCount++ }
    }
    return [double]$shortCount / $window.Count
}

# ---- Pollution cluster detection -------------------------------------------

function Find-PollutionClusters {
    param([Parameter(Mandatory)][object[]]$Blocks)

    $stripIndices = @{}
    $decisions = New-Object System.Collections.Generic.List[object]

    $hardBoundary = @('HEADING', 'FIGURE_CAPTION', 'ANCHOR', 'CITATION_BLOCK', 'LEGITIMATE_PROSE')
    $preserveButContinue = @('PANEL_LABEL', 'LIST_ITEM', 'CLEAN_LATEX', 'EMPTY')

    for ($i = 0; $i -lt $Blocks.Count; $i++) {
        if ($Blocks[$i].Kind -ne 'ANCHOR') { continue }

        $anchorBurstiness = Get-Burstiness -Blocks $Blocks -CenterIndex $i

        if ($anchorBurstiness -lt $script:CLEAN_ZONE_THRESHOLD) {
            $decisions.Add([PSCustomObject]@{
                AnchorIndex      = $i
                AnchorLine       = $Blocks[$i].StartLine
                AnchorText       = $Blocks[$i].Text
                AnchorBurstiness = [Math]::Round($anchorBurstiness, 3)
                Skipped          = $true
                SkipReason       = 'low_burstiness_clean_figure'
                Stripped         = @()
            })
            continue
        }

        # Walk forward
        $forwardCandidates = New-Object System.Collections.Generic.List[int]
        for ($j = $i + 1; $j -lt $Blocks.Count; $j++) {
            $kind = $Blocks[$j].Kind
            if ($hardBoundary -contains $kind) { break }
            $localBurstiness = Get-Burstiness -Blocks $Blocks -CenterIndex $j
            if ($localBurstiness -lt $script:CLEAN_ZONE_THRESHOLD) { break }
            if ($preserveButContinue -contains $kind) { continue }
            if ($kind -in @('POLLUTION_CANDIDATE', 'AMBIGUOUS')) {
                $forwardCandidates.Add($j)
            }
        }

        # Walk backward
        $backwardCandidates = New-Object System.Collections.Generic.List[int]
        for ($j = $i - 1; $j -ge 0; $j--) {
            $kind = $Blocks[$j].Kind
            if ($hardBoundary -contains $kind) { break }
            $localBurstiness = Get-Burstiness -Blocks $Blocks -CenterIndex $j
            if ($localBurstiness -lt $script:CLEAN_ZONE_THRESHOLD) { break }
            if ($preserveButContinue -contains $kind) { continue }
            if ($kind -in @('POLLUTION_CANDIDATE', 'AMBIGUOUS')) {
                $backwardCandidates.Add($j)
            }
        }

        # Run-length gates
        $committed = New-Object System.Collections.Generic.List[int]
        if ($forwardCandidates.Count -ge $script:FORWARD_RUN_MIN) {
            foreach ($idx in $forwardCandidates) { $committed.Add($idx) }
        }
        if ($backwardCandidates.Count -ge $script:BACKWARD_RUN_MIN) {
            foreach ($idx in $backwardCandidates) { $committed.Add($idx) }
        }
        foreach ($idx in $committed) { $stripIndices[$idx] = $true }

        $strippedDetail = @()
        foreach ($idx in ($committed | Sort-Object)) {
            $strippedDetail += [PSCustomObject]@{
                Index      = $idx
                StartLine  = $Blocks[$idx].StartLine
                EndLine    = $Blocks[$idx].EndLine
                Kind       = $Blocks[$idx].Kind
                Length     = $Blocks[$idx].Length
                Burstiness = [Math]::Round((Get-Burstiness -Blocks $Blocks -CenterIndex $idx), 3)
                Text       = $Blocks[$idx].Text
            }
        }

        $decisions.Add([PSCustomObject]@{
            AnchorIndex             = $i
            AnchorLine              = $Blocks[$i].StartLine
            AnchorText              = $Blocks[$i].Text
            AnchorBurstiness        = [Math]::Round($anchorBurstiness, 3)
            Skipped                 = $false
            ForwardCandidatesFound  = $forwardCandidates.Count
            BackwardCandidatesFound = $backwardCandidates.Count
            ForwardCommitted        = ($forwardCandidates.Count -ge $script:FORWARD_RUN_MIN)
            BackwardCommitted       = ($backwardCandidates.Count -ge $script:BACKWARD_RUN_MIN)
            Stripped                = $strippedDetail
        })
    }

    return [PSCustomObject]@{
        StripIndices = $stripIndices
        Decisions    = [object[]]$decisions.ToArray()
    }
}

# ---- Public: run the cleaner ----------------------------------------------

function Invoke-OpenDataLoaderPostProcess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$InputPath,
        [string]$OutputPath,
        [string]$SidecarPath,
        [switch]$DryRun
    )

    if (-not (Test-Path -LiteralPath $InputPath)) {
        throw "Input file not found: $InputPath"
    }

    if (-not $OutputPath) {
        $stem = [System.IO.Path]::GetFileNameWithoutExtension($InputPath)
        $dir  = [System.IO.Path]::GetDirectoryName($InputPath)
        $OutputPath = Join-Path $dir "$stem.cleaned.md"
    }
    if (-not $SidecarPath) {
        $stem = [System.IO.Path]::GetFileNameWithoutExtension($InputPath)
        $dir  = [System.IO.Path]::GetDirectoryName($InputPath)
        $SidecarPath = Join-Path $dir "$stem.cleaned.json"
    }

    $blocks = Split-MarkdownIntoBlocks -Path $InputPath
    if ($blocks.Count -eq 0) {
        Write-Verbose "Input contains no content blocks; nothing to do."
        return [PSCustomObject]@{
            InputPath        = $InputPath
            OutputPath       = $OutputPath
            SidecarPath      = $SidecarPath
            TotalBlocks      = 0
            StrippedBlocks   = 0
            AnchorsProcessed = 0
            AnchorsSkipped   = 0
            DryRun           = $DryRun.IsPresent
        }
    }

    foreach ($b in $blocks) { $b.Kind = Resolve-BlockKind -Block $b }
    $cluster = Find-PollutionClusters -Blocks $blocks

    $kept = New-Object System.Collections.Generic.List[string]
    foreach ($b in $blocks) {
        if (-not $cluster.StripIndices.ContainsKey($b.Index)) { $kept.Add($b.Text) }
    }
    $cleaned = ($kept -join "`n`n") + "`n"

    $summary = [PSCustomObject]@{
        InputPath        = $InputPath
        OutputPath       = $OutputPath
        SidecarPath      = $SidecarPath
        TotalBlocks      = $blocks.Count
        StrippedBlocks   = $cluster.StripIndices.Count
        AnchorsProcessed = ($cluster.Decisions | Where-Object { -not $_.Skipped }).Count
        AnchorsSkipped   = ($cluster.Decisions | Where-Object { $_.Skipped }).Count
        DryRun           = $DryRun.IsPresent
    }

    if (-not $DryRun) {
        Set-Content -LiteralPath $OutputPath -Value $cleaned -Encoding utf8NoBOM -NoNewline
        $sidecar = [PSCustomObject]@{
            input_path        = $InputPath
            output_path       = $OutputPath
            total_blocks      = $blocks.Count
            stripped_blocks   = $cluster.StripIndices.Count
            anchors_processed = $summary.AnchorsProcessed
            anchors_skipped   = $summary.AnchorsSkipped
            tunables          = [PSCustomObject]@{
                pollution_length_threshold = $script:POLLUTION_LENGTH_THRESHOLD
                legitimate_prose_length    = $script:LEGITIMATE_PROSE_LENGTH
                burstiness_window          = $script:BURSTINESS_WINDOW
                pollution_zone_threshold   = $script:POLLUTION_ZONE_THRESHOLD
                clean_zone_threshold       = $script:CLEAN_ZONE_THRESHOLD
                forward_run_min            = $script:FORWARD_RUN_MIN
                backward_run_min           = $script:BACKWARD_RUN_MIN
            }
            decisions         = $cluster.Decisions
        }
        $sidecar | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $SidecarPath -Encoding utf8NoBOM
    }

    return $summary
}

# ---- Public: per-block diagnostic dump -------------------------------------

function Get-MarkdownBlockReport {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$InputPath)

    if (-not (Test-Path -LiteralPath $InputPath)) {
        throw "Input file not found: $InputPath"
    }

    $blocks = Split-MarkdownIntoBlocks -Path $InputPath
    foreach ($b in $blocks) { $b.Kind = Resolve-BlockKind -Block $b }

    foreach ($b in $blocks) {
        $burstiness = Get-Burstiness -Blocks $blocks -CenterIndex $b.Index
        $preview = if ($b.Text.Length -gt 60) { $b.Text.Substring(0, 60) + '...' } else { $b.Text }
        $preview = $preview -replace "[`r`n]+", ' / '
        [PSCustomObject]@{
            Index      = $b.Index
            StartLine  = $b.StartLine
            EndLine    = $b.EndLine
            Length     = $b.Length
            Kind       = $b.Kind
            Burstiness = [Math]::Round($burstiness, 2)
            Preview    = $preview
        }
    }
}

Export-ModuleMember -Function Invoke-OpenDataLoaderPostProcess, Get-MarkdownBlockReport
