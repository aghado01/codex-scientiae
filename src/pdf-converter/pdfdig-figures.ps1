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

# Reattach caption text to each kind=figure region. Geometry finds the CANDIDATES — Lane-3 text
# blocks directly BELOW (figures) or, failing that, ABOVE (tables), horizontally overlapping by
# >= caption_min_overlap_frac of the NARROWER of figure/block width, within caption_max_gap_em
# text-heights (a short "Fig. N" caption fully under a wide figure must not be rejected because
# the figure's width is the denominator — the dominant miss class in the 2026-07-05 diagnostic,
# 2205 Figs 6/8/12/13 + 2111 Fig 3; see issues/clustering/tier2-handoff.md ledger). The caption
# CUE (Figure/Fig/Table N in the block's first ~14 chars) SELECTS the caption among them, so an
# adjacent section heading or body paragraph (no cue) is not attached, and a caption-less region
# stays null rather than grabbing the wrong block. Prefix-scanned (not ^-anchored) so a leading
# glyph ("δ Fig. 3") still matches; length-capped so a mid-sentence "see Figure 3" reference does
# not. Cue words are config-as-data. Sets the caption field in place; returns nothing.
function Add-FigureCaptions([System.Collections.Generic.List[object]] $Figures, [string] $BlocksJsonl,
    [double] $BodyPt, $Cfg, $Summary) {
    if (-not (Test-Path $BlocksJsonl)) { return }
    $blocks = Get-Content $BlocksJsonl | Where-Object { $_.Trim() } |
        ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bx }
    if (-not $blocks) { return }
    $byPage = @{}
    foreach ($blk in $blocks) {
        $p = [int]$blk.page
        if (-not $byPage.ContainsKey($p)) { $byPage[$p] = [System.Collections.Generic.List[object]]::new() }
        $byPage[$p].Add($blk)
    }

    $bp     = if ($BodyPt) { [double]$BodyPt } else { 10.0 }
    $maxGap = [double]$Cfg.caption_max_gap_em * $bp
    $minOvl = [double]$Cfg.caption_min_overlap_frac
    $cueRe  = '(' + (($Cfg.caption_cue_words | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')\.?\s*\d'

    foreach ($fig in $Figures) {
        if ($fig.kind -ne 'figure') { continue }
        $pageBlocks = $byPage[[int]$fig.page]
        if (-not $pageBlocks) { continue }
        $figL = $fig.bbox[0]; $figB = $fig.bbox[1]; $figR = $fig.bbox[2]; $figT = $fig.bbox[3]
        $figW = $figR - $figL
        if ($figW -le 0) { continue }

        $best = $null; $bestGap = [double]::MaxValue; $bestPos = $null; $bestTxt = ''
        foreach ($pos in @('below', 'above')) {   # prefer below (figures); only look above (tables) if nothing below
            foreach ($blk in $pageBlocks) {
                $bl = $blk.bx[0]; $bb = $blk.bx[1]; $br = $blk.bx[2]; $bt = $blk.bx[3]
                $ovl = [math]::Min($figR, $br) - [math]::Max($figL, $bl)
                # denominator = the NARROWER of the two widths: min() only changes behavior for blocks
                # narrower than the figure (the short-caption miss class); wide blocks keep the old
                # figure-width behavior, and the cue + gap gates still apply, so in-text references
                # ("see Figure 3") don't start attaching.
                $den = [math]::Min($figW, $br - $bl)
                if ($den -le 0 -or ($ovl / $den) -lt $minOvl) { continue }
                $gap = if ($pos -eq 'below') { $figB - $bt } else { $bb - $figT }
                if ($gap -lt -2 -or $gap -gt $maxGap -or $gap -ge $bestGap) { continue }
                $txt = if ($blk.text_preview) { [string]$blk.text_preview } else { '' }
                if ($txt.Substring(0, [math]::Min(14, $txt.Length)) -match $cueRe) {
                    $best = $blk; $bestGap = $gap; $bestPos = $pos; $bestTxt = $txt
                }
            }
            if ($best) { break }
        }
        if ($best) {
            $fig['caption'] = [ordered]@{
                block_id = $best.id; bbox = $best.bx; text = $bestTxt
                cue = $true; position = $bestPos; gap = [math]::Round($bestGap, 1)
            }
            $Summary.captioned_figures++
        }
    }
}

# Merge a set of subfigure regions (all sharing one float caption) into one figure region. Union bbox,
# concatenated members, recomputed area/em^2/density; kind stays figure, caption kept from the first
# member, flag records the merge. Emits the SAME record shape as $addRegion (key order matched) so the
# lane's schema stays uniform. $BodyArea = body_font_pt^2 for the em^2 normalization (may be $null).
function Merge-FigureGroup([System.Collections.Generic.List[object]] $Members, $BodyArea) {
    $bbox = Get-FigureUnionBbox $Members
    $w = $bbox[2] - $bbox[0]; $h = $bbox[3] - $bbox[1]
    $area = [math]::Round($w * $h, 1)
    $pathIds = [System.Collections.Generic.List[object]]::new()
    $xobjIds = [System.Collections.Generic.List[object]]::new()
    $pathCount = 0; $xobjCount = 0
    foreach ($m in $Members) {
        foreach ($pmid in @($m.path_ids)) { $pathIds.Add($pmid) }
        foreach ($xmid in @($m.xobject_ids)) { $xobjIds.Add($xmid) }
        $pathCount += [int]$m.path_count; $xobjCount += [int]$m.xobject_count
    }
    $hasXobj = $xobjCount -gt 0
    $areaEm  = if ($BodyArea) { [math]::Round($area / $BodyArea, 3) } else { $null }
    $density = if ($areaEm -and $areaEm -gt 0) { [math]::Round($pathCount / $areaEm, 4) } else { $null }
    $first = $Members[0]
    [ordered]@{
        id = $first.id; page = $first.page; bbox = $bbox; area = $area; area_em2 = $areaEm; density = $density
        path_ids = @(foreach ($p in $pathIds) { $p }); path_count = $pathCount
        xobject_ids = @(foreach ($x in $xobjIds) { $x }); xobject_count = $xobjCount
        provenance = if ($hasXobj -and $pathCount) { 'mixed' } elseif ($hasXobj) { 'xobject' } else { 'path' }
        kind = 'figure'; flag = 'subfigure_merged'; caption = $first.caption
    }
}

# Subfigure grouping: a \begin{figure} float with N subfigures currently yields N separate kind=figure
# regions that each reattach to the float's SINGLE caption (side-by-side subfigures all overlap the one
# caption block below them). Merge captioned figures sharing (page, caption.block_id) into ONE region —
# the shared caption is the ground-truth grouping signal (each float has exactly one caption), so this is
# principled, not a spatial threshold. Non-figure and uncaptioned-figure regions pass through untouched.
# Ids are renumbered to preserve the id = list-index invariant. Adjusts the figure/region/caption counters
# and records subfigure_groups / subfigures_merged. Returns the rebuilt list.
function Group-SubfiguresByCaption([System.Collections.Generic.List[object]] $Figures, $BodyArea, $Summary) {
    $groups = @{}   # (page:block_id) -> members, in first-seen order
    foreach ($fig in $Figures) {
        if ($fig.kind -eq 'figure' -and $fig.caption) {
            $key = '{0}:{1}' -f $fig.page, $fig.caption.block_id
            if (-not $groups.ContainsKey($key)) { $groups[$key] = [System.Collections.Generic.List[object]]::new() }
            $groups[$key].Add($fig)
        }
    }
    $result  = [System.Collections.Generic.List[object]]::new()
    $emitted = @{}; $mergedAway = 0; $multiGroups = 0
    foreach ($fig in $Figures) {
        $key = if ($fig.kind -eq 'figure' -and $fig.caption) { '{0}:{1}' -f $fig.page, $fig.caption.block_id } else { $null }
        if ($key -and $groups[$key].Count -gt 1) {
            if ($emitted.ContainsKey($key)) { continue }   # a later subfigure of an already-merged group
            $emitted[$key] = $true; $multiGroups++
            $mergedAway += $groups[$key].Count - 1
            $result.Add((Merge-FigureGroup $groups[$key] $BodyArea))
        }
        else { $result.Add($fig) }
    }
    for ($i = 0; $i -lt $result.Count; $i++) { $result[$i].id = $i }   # keep id = index
    $Summary.figures           -= $mergedAway
    $Summary.regions           -= $mergedAway
    $Summary.captioned_figures -= $mergedAway
    $Summary.subfigure_groups   = $multiGroups
    $Summary.subfigures_merged  = $mergedAway
    return , $result
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
    $minDensity     = [double]$cfg.min_region_density
    $captionEnabled = [bool]$cfg.caption_enabled
    $subfigGrouping = [bool]$cfg.subfigure_grouping_enabled

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
        noise_paths = 0; sparse = 0; too_few_pages = 0; fragmentation_suspect_pages = 0; defragged_pages = 0
        captioned_figures = 0; body_font_pt = $bodyPt
        xobjects = 0; xobject_regions = 0   # LANE 5: bitmap points loaded / regions carrying a bitmap
        subfigure_groups = 0; subfigures_merged = 0   # subfigure grouping: multi-caption groups / regions merged away
    }

    # Build + record one region. area is measured; area_em2 is the text-normalized measurement;
    # density = paths / area_em2 is the ink-coverage measurement. kind is the tunable opinion
    # (degenerate|mark|sparse|figure): a big-but-SPARSE region (a few furniture/QED strokes whose
    # union bbox spans a text column) is a phantom, NOT a figure — the density gate separates it
    # from a big-DENSE diagram, which area alone cannot. Nothing is dropped. id = list count before
    # append; $figures/$summary and the config scalars resolve through the enclosing scope.
    $addRegion = {
        param($page, $members, $flag)
        $bbox = Get-FigureUnionBbox $members
        if (-not $bbox) { return }
        $w = $bbox[2] - $bbox[0]; $h = $bbox[3] - $bbox[1]
        $area = [math]::Round($w * $h, 1)
        $pc = @($members).Count
        # split members by provenance (Lane-4 vector vs Lane-5 raster). A region carrying ANY xobject is
        # a placed bitmap → it BYPASSES the density gate: density = paths/area is a vector-INK-coverage
        # proxy, meaningless for a raster whose entire "ink" is one placed object (a big bitmap is 1 point
        # over a large area ⇒ near-zero density ⇒ would be wrongly demoted to 'sparse'). Size floors
        # (degenerate/mark) still apply, so a tiny icon bitmap is still a mark.
        $pathMembers = [System.Collections.Generic.List[object]]::new()
        $xobjMembers = [System.Collections.Generic.List[object]]::new()
        foreach ($m in $members) { if ($m.prov -eq 'xobject') { $xobjMembers.Add($m) } else { $pathMembers.Add($m) } }
        $hasXobj = $xobjMembers.Count -gt 0
        $areaEm  = if ($bodyArea) { [math]::Round($area / $bodyArea, 3) } else { $null }
        $density = if ($areaEm -and $areaEm -gt 0) { [math]::Round($pc / $areaEm, 4) } else { $null }
        $kind =
            if ($w -lt $degenEps -or $h -lt $degenEps) { 'degenerate' }
            elseif ($null -ne $bodyArea) {
                if     ($areaEm -lt $floorEm)                             { 'mark' }
                elseif ($hasXobj)                                         { 'figure' }   # raster: density gate N/A
                elseif ($null -ne $density -and $density -lt $minDensity) { 'sparse' }
                else                                                      { 'figure' }
            }
            else { if ($area -lt $fallbackPt2) { 'mark' } else { 'figure' } }
        $figures.Add([ordered]@{
            id = $figures.Count; page = $page; bbox = $bbox; area = $area; area_em2 = $areaEm; density = $density
            # explicit foreach (NOT @($list.id)) — member-access enumeration on an EMPTY List yields a lone
            # $null, which would serialize as [null] on a pure-path or pure-xobject region; foreach gives []
            path_ids = @(foreach ($m in $pathMembers) { $m.id }); path_count = $pathMembers.Count
            xobject_ids = @(foreach ($m in $xobjMembers) { $m.id }); xobject_count = $xobjMembers.Count
            provenance = if ($hasXobj -and $pathMembers.Count) { 'mixed' } elseif ($hasXobj) { 'xobject' } else { 'path' }
            kind = $kind; flag = $flag; caption = $null
        })
        $summary.regions++
        if ($hasXobj) { $summary.xobject_regions++ }
        switch ($kind) {
            'figure'     { $summary.figures++ }
            'mark'       { $summary.marks++ }
            'sparse'     { $summary.sparse++ }
            'degenerate' { $summary.degenerate++ }
        }
    }

    # Load paths with a usable bbox (a genuine-null bbox path can't be placed). ALL paths cluster,
    # rule-tagged strokes INCLUDED: in this corpus figures ARE largely axis-aligned rules (interval
    # bars, diagram arrows/axes) — excluding them shatters real figures. Furniture-only regions are
    # rejected downstream by the density gate, not by dropping their strokes here.
    $paths = @(Get-Content $PathsJsonl | Where-Object { $_.Trim() } |
        ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox })
    foreach ($p in $paths) { $p.PSObject.Properties.Add([psnoteproperty]::new('prov', 'path')) }

    # LANE 5: union the placed bitmap rectangles ({slug}.xobjects.jsonl, beside the paths lane) into the
    # per-page point cloud, so a figure that IS one big bitmap becomes a first-class CLUSTERED point
    # instead of being invisible to the vector-only lanes (the raster-blindness under-count). Absent/empty
    # lane ⇒ behaves exactly as before. Each xobject is provenance-tagged so a region can report path vs
    # xobject membership; ids come from the IR's own per-document xobject sequence.
    $xobjPath = $PathsJsonl -replace '\.paths\.jsonl$', '.xobjects.jsonl'
    $xobjs = @()
    if (Test-Path $xobjPath) {
        $xobjs = @(Get-Content $xobjPath | Where-Object { $_.Trim() } |
            ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox })
        foreach ($x in $xobjs) { $x.PSObject.Properties.Add([psnoteproperty]::new('prov', 'xobject')) }
    }
    $summary.xobjects = $xobjs.Count
    $items = @($paths) + @($xobjs)

    $work = Join-Path ([IO.Path]::GetTempPath()) ("pdfdig-figures-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    try {
        foreach ($grp in ($items | Group-Object page | Sort-Object { [int]$_.Name })) {
            $page      = [int]$grp.Name
            $pageItems = @($grp.Group)
            $summary.pages++

            # Too few points for density clustering: group stray VECTOR paths as one tentative region,
            # but emit each bitmap as its OWN figure (a placed raster is self-evidently a figure — it
            # needs no cluster support), so a bitmap-only / bitmap-plus-a-few-strokes page still yields
            # figures instead of being lost.
            if ($pageItems.Count -le $minPts) {
                $summary.too_few_pages++
                $pathItems = @($pageItems | Where-Object { $_.prov -ne 'xobject' })
                if ($pathItems.Count) { & $addRegion $page $pathItems 'too_few_to_cluster' }
                foreach ($x in @($pageItems | Where-Object { $_.prov -eq 'xobject' })) { & $addRegion $page @($x) 'xobject_singleton' }
                continue
            }

            # Emit points (v = [x0,y0,x1,y1]); the write order is the id-index mapping.
            $pts = [System.Collections.Generic.List[string]]::new()
            foreach ($p in $pageItems) {
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
            if ($labels.Count -ne $pageItems.Count) {
                throw "page ${page}: partition rows $($labels.Count) != points $($pageItems.Count)"
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

            # Group members by cluster label; label -1 = noise. A noise VECTOR path is a stray stroke
            # (dropped, as before); a noise BITMAP is RESCUED as its own singleton figure — an isolated
            # placed raster is a real figure that simply had no neighbours to cluster with, and must never
            # be silently lost to the noise class (that would re-introduce the raster-blindness gap).
            $byLabel = @{}
            $noiseXobjs = [System.Collections.Generic.List[object]]::new()
            for ($i = 0; $i -lt $pageItems.Count; $i++) {
                $lab = $labels[$i]
                if ($lab -lt 0) {
                    if ($pageItems[$i].prov -eq 'xobject') { $noiseXobjs.Add($pageItems[$i]) } else { $summary.noise_paths++ }
                    continue
                }
                if (-not $byLabel.ContainsKey($lab)) { $byLabel[$lab] = [System.Collections.Generic.List[object]]::new() }
                $byLabel[$lab].Add($pageItems[$i])
            }
            foreach ($lab in ($byLabel.Keys | Sort-Object)) {
                & $addRegion $page $byLabel[$lab] $null
            }
            foreach ($nx in $noiseXobjs) { & $addRegion $page @($nx) 'xobject_singleton' }
        }
    }
    finally {
        Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
    }

    # Reattach captions from the Lane-3 blocks lane (if present beside the paths lane), then group
    # subfigures: N regions reattached to one float caption collapse to one figure (the shared caption
    # is the grouping signal). Grouping needs the caption links, so it runs after reattachment.
    if ($captionEnabled) {
        Add-FigureCaptions $figures ($PathsJsonl -replace '\.paths\.jsonl$', '.blocks.jsonl') $bodyPt $cfg $summary
        if ($subfigGrouping) {
            $figures = Group-SubfiguresByCaption $figures $bodyArea $summary
        }
    }

    # [string[]]@(...) so an empty page-set writes an empty file instead of throwing on null.
    $lines = [string[]]@($figures | ForEach-Object { $_ | ConvertTo-Json -Compress -Depth 6 })
    [System.IO.File]::WriteAllLines($OutPath, $lines, [System.Text.UTF8Encoding]::new($false))

    Write-Verbose ("regions: {0} ({1} figure / {2} mark / {3} sparse / {4} degenerate) over {5} page(s); {6} stray path(s), {7} xobject(s) in {8} region(s), body {9}pt -> {10}" -f `
        $summary.regions, $summary.figures, $summary.marks, $summary.sparse, $summary.degenerate, $summary.pages, $summary.noise_paths, $summary.xobjects, $summary.xobject_regions, $summary.body_font_pt, $OutPath)

    if ($PassThru) {
        [pscustomobject]@{ OutPath = $OutPath; Figures = $figures; Summary = [pscustomobject]$summary }
    }
}
