#requires -Version 7
<#
.SYNOPSIS
  Figure-region detection — cluster Lane-4 vector paths into figure regions via hdbscan.exe.

.DESCRIPTION
  A CONSUMER of the generic IR (like pdfdig-classify.ps1), not part of the substrate emitter.
  Reads {slug}.paths.jsonl (the vector lane), clusters each page's path bboxes with the
  rectangle-gap metric (HDBSCAN density over white-space gaps between axis-aligned boxes), and
  emits {slug}.figures.jsonl — one record per detected region (union bbox + member path ids).
  Stray rules/underlines fall out as HDBSCAN's noise class (-1) and are reported, never forced
  into a region.

  Per-page: figures never span pages and page coordinate systems are independent. The clustering
  engine stays a black-box CLI (Invoke-Hdbscan -> hdbscan.exe); no clustering logic lives here.
  Params are config-as-data (classify-config.json "figure_regions").

  Each region records raw union-bbox `area` and, when the letters lane gives a body font size,
  a TEXT-NORMALIZED `area_em2` (area / body_font^2 = "how many glyphs big"). `kind` is tagged
  (nothing dropped): degenerate (thinner than degenerate_min_extent_pt on either axis = a
  rule/line cluster) | mark (below the glyph-scale floor) | figure. The corpus is NOT universally
  bimodal in region area, so the floor is a conservative glyph-scale FLOOR, not a valley estimate.
#>

. (Join-Path $PSScriptRoot '../hdbscan/Invoke-Hdbscan.ps1')

# Smallest enclosing [x0,y0,x1,y1] over a set of path records (skips null bboxes).
function Get-FigureUnionBbox($items) {
    $minX = [double]::MaxValue; $minY = [double]::MaxValue
    $maxX = [double]::MinValue; $maxY = [double]::MinValue
    $any = $false
    foreach ($it in $items) {
        $b = $it.bbox
        if (-not $b) { continue }
        if ($b[0] -lt $minX) { $minX = $b[0] }; if ($b[1] -lt $minY) { $minY = $b[1] }
        if ($b[2] -gt $maxX) { $maxX = $b[2] }; if ($b[3] -gt $maxY) { $maxY = $b[3] }
        $any = $true
    }
    if (-not $any) { return $null }
    @([math]::Round($minX, 2), [math]::Round($minY, 2), [math]::Round($maxX, 2), [math]::Round($maxY, 2))
}

# Reads the 'label' column (input-row order) out of hdbscan_partition.csv. The CLI preserves
# input order, so row i maps to the i-th point we wrote — that index is the id back-reference.
function Read-PartitionLabels([string] $Csv) {
    if (-not (Test-Path $Csv)) { throw "partition not found: $Csv" }
    $lines = Get-Content $Csv
    if ($lines.Count -lt 2) { return , @() }
    $labelIdx = [array]::IndexOf($lines[0].Split(','), 'label')
    if ($labelIdx -lt 0) { throw "no 'label' column in $Csv" }
    $out = [System.Collections.Generic.List[int]]::new()
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if (-not $lines[$i].Trim()) { continue }
        $out.Add([int]$lines[$i].Split(',')[$labelIdx])
    }
    , $out.ToArray()
}

# Body font size = the modal letter size in {slug}.letters.jsonl (body text dominates the letter
# count). Streamed regex read of just the `size` field — fast on large lanes; null if absent.
function Get-BodyFontSize([string] $LettersJsonl) {
    if (-not (Test-Path $LettersJsonl)) { return $null }
    $counts = @{}
    foreach ($line in [System.IO.File]::ReadLines($LettersJsonl)) {
        $m = [regex]::Match($line, '"size":\s*([0-9.]+)')
        if ($m.Success) {
            $s = [math]::Round([double]$m.Groups[1].Value, 1)
            $counts[$s] = (($counts[$s]) ?? 0) + 1
        }
    }
    if ($counts.Count -eq 0) { return $null }
    ($counts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key
}

# Walk the per-page single-linkage dendrogram for the fragment-adjacency elbow: the largest
# log-gap in the distances at which DISTINCT sub-clusters first merge. Below it = intra-figure
# fragment joins; above = inter-figure/column separation. Returns that distance (to feed
# --cluster-selection-epsilon), or null when there's no clear elbow (< MinLogGap) so a size
# continuum is left alone. Noise-robust: only merges between non-noise fragments count.
function Find-FragmentElbow([string] $DendrogramJson, [int[]] $Labels, [double] $MinLogGap) {
    if (-not (Test-Path $DendrogramJson)) { return $null }
    $merges = (Get-Content $DendrogramJson -Raw | ConvertFrom-Json).merges
    if (-not $merges) { return $null }
    $N = $Labels.Count
    $repFrag = New-Object 'int[]' (2 * $N - 1)          # a representative fragment in each node's subtree (-1 = all noise)
    for ($i = 0; $i -lt $N; $i++) { $repFrag[$i] = $Labels[$i] }
    $uf = @{}                                            # fragment union-find (parent map)
    $inter = [System.Collections.Generic.List[double]]::new()
    for ($i = 0; $i -lt $merges.Count; $i++) {
        $m = $merges[$i]; $node = $N + $i
        $fL = $repFrag[$m.left_child]; $fR = $repFrag[$m.right_child]
        $repFrag[$node] = if ($fL -ge 0) { $fL } else { $fR }
        if ($fL -ge 0 -and $fR -ge 0) {
            $rl = $fL; while ($uf.ContainsKey($rl) -and $uf[$rl] -ne $rl) { $rl = $uf[$rl] }
            $rr = $fR; while ($uf.ContainsKey($rr) -and $uf[$rr] -ne $rr) { $rr = $uf[$rr] }
            if ($rl -ne $rr) { $inter.Add([double]$m.distance); $uf[$rl] = $rl; $uf[$rr] = $rl }
        }
    }
    $d = @($inter | Sort-Object)
    if ($d.Count -lt 2) { return $null }
    $best = 0.0; $elbow = $null
    for ($i = 1; $i -lt $d.Count; $i++) {
        if ($d[$i - 1] -le 0) { continue }
        $g = [math]::Log($d[$i]) - [math]::Log($d[$i - 1])
        if ($g -gt $best) { $best = $g; $elbow = [math]::Sqrt($d[$i - 1] * $d[$i]) }
    }
    if ($best -lt $MinLogGap) { return $null }
    $elbow
}

function ConvertTo-FigureRegions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $PathsJsonl,     # {slug}.paths.jsonl
        [string] $OutPath,                               # default {slug}.figures.jsonl beside input
        [string] $ConfigPath = (Join-Path $PSScriptRoot 'stores/classify-config.json'),
        [switch] $PassThru
    )

    if (-not (Test-Path $PathsJsonl)) { throw "paths lane not found: $PathsJsonl" }

    $cfg            = (Get-Content $ConfigPath -Raw | ConvertFrom-Json).figure_regions
    $metric         = [string]$cfg.metric
    $minPts         = [int]$cfg.min_pts
    $minClusterSize = [int]$cfg.min_cluster_size
    $allowSingle    = [bool]$cfg.allow_single_cluster
    $floorEm        = [double]$cfg.min_region_area_em2
    $fallbackPt2    = [double]$cfg.min_region_area_pt2
    $degenEps       = [double]$cfg.degenerate_min_extent_pt
    $fragMin        = [int]$cfg.fragmentation_flag_min_clusters
    $defragEnabled  = [bool]$cfg.defrag_enabled
    $defragMinLogGap = [double]$cfg.defrag_min_elbow_log_gap

    if (-not $OutPath) {
        $dir  = Split-Path $PathsJsonl -Parent
        $slug = (Split-Path $PathsJsonl -Leaf) -replace '\.paths\.jsonl$', ''
        $OutPath = Join-Path $dir "$slug.figures.jsonl"
    }

    # Text-scale reference: normalize region area to em^2 so the mark floor transports across
    # page AND font size. Falls back to a raw-pt^2 floor when the letters lane isn't beside us.
    $bodyPt   = Get-BodyFontSize ($PathsJsonl -replace '\.paths\.jsonl$', '.letters.jsonl')
    $bodyArea = if ($bodyPt) { [double]$bodyPt * [double]$bodyPt } else { $null }

    $figures = [System.Collections.Generic.List[object]]::new()
    $summary = [ordered]@{
        pages = 0; regions = 0; figures = 0; marks = 0; degenerate = 0
        noise_paths = 0; too_few_pages = 0; fragmentation_suspect_pages = 0; defragged_pages = 0; body_font_pt = $bodyPt
    }

    # Build + record one region. area is measured; area_em2 is the text-normalized measurement;
    # kind is the tunable opinion (degenerate|mark|figure). Nothing is dropped. id = list count
    # before append; $figures/$summary and the config scalars resolve through the enclosing scope.
    $addRegion = {
        param($page, $members, $flag)
        $bbox = Get-FigureUnionBbox $members
        if (-not $bbox) { return }
        $w = $bbox[2] - $bbox[0]; $h = $bbox[3] - $bbox[1]
        $area = [math]::Round($w * $h, 1)
        $areaEm = if ($bodyArea) { [math]::Round($area / $bodyArea, 3) } else { $null }
        $kind =
            if ($w -lt $degenEps -or $h -lt $degenEps) { 'degenerate' }
            elseif ($null -ne $bodyArea) { if ($areaEm -lt $floorEm) { 'mark' } else { 'figure' } }
            else { if ($area -lt $fallbackPt2) { 'mark' } else { 'figure' } }
        $figures.Add([ordered]@{
            id = $figures.Count; page = $page; bbox = $bbox; area = $area; area_em2 = $areaEm
            path_ids = @($members.id); path_count = @($members).Count
            kind = $kind; flag = $flag
        })
        $summary.regions++
        switch ($kind) {
            'figure'     { $summary.figures++ }
            'mark'       { $summary.marks++ }
            'degenerate' { $summary.degenerate++ }
        }
    }

    # Load paths with a usable bbox (a genuine-null bbox path can't be placed).
    $paths = Get-Content $PathsJsonl | Where-Object { $_.Trim() } |
        ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox }

    $work = Join-Path ([IO.Path]::GetTempPath()) ("pdfdig-figures-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    try {
        foreach ($grp in ($paths | Group-Object page | Sort-Object { [int]$_.Name })) {
            $page      = [int]$grp.Name
            $pagePaths = @($grp.Group)
            $summary.pages++

            # Too few paths for density clustering: group as one tentative region, flagged honestly.
            if ($pagePaths.Count -le $minPts) {
                $summary.too_few_pages++
                & $addRegion $page $pagePaths 'too_few_to_cluster'
                continue
            }

            # Emit points (v = [x0,y0,x1,y1]); the write order is the id-index mapping.
            $pts = [System.Collections.Generic.List[string]]::new()
            foreach ($p in $pagePaths) {
                $b = $p.bbox
                $pts.Add(('{{"id":{0},"v":[{1},{2},{3},{4}]}}' -f $p.id, $b[0], $b[1], $b[2], $b[3]))
            }
            $ptsFile = Join-Path $work "p$page.jsonl"
            [IO.File]::WriteAllLines($ptsFile, $pts)
            $outDir = Join-Path $work "p$page.out"

            $hdbArgs = @{
                In = $ptsFile; OutDir = $outDir; DistanceMetric = $metric
                MinPts = $minPts; MinClusterSize = $minClusterSize
            }
            if (-not $allowSingle) { $hdbArgs.NoAllowSingleCluster = $true }
            Invoke-Hdbscan @hdbArgs | Out-Null

            $labels = Read-PartitionLabels (Join-Path $outDir 'hdbscan_partition.csv')
            if ($labels.Count -ne $pagePaths.Count) {
                throw "page ${page}: partition rows $($labels.Count) != paths $($pagePaths.Count)"
            }

            # De-fragmentation: an over-split page (a complex figure shattered into many density
            # sub-clusters) is repaired by walking its dendrogram for the fragment-adjacency elbow,
            # then re-running with that distance as cluster_selection_epsilon so intra-figure
            # fragments merge while figures / columns stay separate.
            $distinct = @($labels | Where-Object { $_ -ge 0 } | Select-Object -Unique).Count
            if ($distinct -gt $fragMin) {
                $summary.fragmentation_suspect_pages++
                if ($defragEnabled) {
                    $elbow = Find-FragmentElbow (Join-Path $outDir 'hdbscan_dendrogram.json') $labels $defragMinLogGap
                    if ($elbow) {
                        $outDir2 = "$outDir.defrag"
                        $hdbArgs2 = @{} + $hdbArgs
                        $hdbArgs2.OutDir = $outDir2
                        $hdbArgs2.ClusterSelectionEpsilon = $elbow
                        Invoke-Hdbscan @hdbArgs2 | Out-Null
                        $labels = Read-PartitionLabels (Join-Path $outDir2 'hdbscan_partition.csv')
                        $summary.defragged_pages++
                    }
                }
            }

            # Group members by cluster label; label -1 = noise (stray path).
            $byLabel = @{}
            for ($i = 0; $i -lt $pagePaths.Count; $i++) {
                $lab = $labels[$i]
                if ($lab -lt 0) { $summary.noise_paths++; continue }
                if (-not $byLabel.ContainsKey($lab)) { $byLabel[$lab] = [System.Collections.Generic.List[object]]::new() }
                $byLabel[$lab].Add($pagePaths[$i])
            }
            foreach ($lab in ($byLabel.Keys | Sort-Object)) {
                & $addRegion $page $byLabel[$lab] $null
            }
        }
    }
    finally {
        Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
    }

    # [string[]]@(...) so an empty page-set writes an empty file instead of throwing on null.
    $lines = [string[]]@($figures | ForEach-Object { $_ | ConvertTo-Json -Compress -Depth 5 })
    [System.IO.File]::WriteAllLines($OutPath, $lines, [System.Text.UTF8Encoding]::new($false))

    Write-Verbose ("regions: {0} ({1} figure / {2} mark / {3} degenerate) over {4} page(s); {5} stray path(s), body {6}pt -> {7}" -f `
        $summary.regions, $summary.figures, $summary.marks, $summary.degenerate, $summary.pages, $summary.noise_paths, $summary.body_font_pt, $OutPath)

    if ($PassThru) {
        [pscustomobject]@{ OutPath = $OutPath; Figures = $figures; Summary = [pscustomobject]$summary }
    }
}
