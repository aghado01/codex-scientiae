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
  Params are config-as-data (classify-config.json "figure_regions"). CONSENSUS m1 (Join-FigureViews,
  "figure_regions.consensus") OR-combines the geometry partition with content-stream draw-run
  evidence before region assembly — policy lives in the lane, the engine stays a black box.

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

# Rectangle-gap between two [x0,y0,x1,y1] boxes: Euclidean norm over the per-axis white-space gaps,
# sqrt(max(0,gx)^2 + max(0,gy)^2) — the same form as the engine's RectangleGapMetric, so the PS-side
# consensus reasons in the SAME distance the geometry view clustered with. 0 when boxes touch/overlap.
function Get-RectangleGap([double[]] $A, [double[]] $B) {
    $gx = [math]::Max($B[0] - $A[2], $A[0] - $B[2]); if ($gx -lt 0) { $gx = 0.0 }
    $gy = [math]::Max($B[1] - $A[3], $A[1] - $B[3]); if ($gy -lt 0) { $gy = 0.0 }
    [math]::Sqrt($gx * $gx + $gy * $gy)
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

# CONSENSUS m1 (issues/clustering/consensus-milestone1-design.md): OR-combine two per-page
# co-membership VIEWS over the clustering items in one union-find pass.
#   V_geom   — the HDBSCAN partition (labels), taken as-is.
#   V_stream — contiguous content-stream draw-runs. Per-page path ids are CONTIGUOUS by construction
#              (document-sequential emission order), so id-GAP splitting cannot work: two figures drawn
#              back-to-back are id-adjacent. The splitter is the SPATIAL JUMP between consecutive ids —
#              a TikZ/xy diagram is one draw-run that stays spatially coherent; between two figures the
#              pen "teleports". Blocks = id-sorted paths split where the consecutive rectangle-gap
#              exceeds stream_jump_em.
# Combine rule 'inclusive': union(i,j) iff same-V_geom-cluster OR stream evidence, where stream
# evidence = same block AND spatially co-located under t_far_em — consecutive paths within t_far_em
# chain-union, then the resulting sub-chains re-glue to fixpoint while their union bboxes stay within
# t_far_em of each other (block-scoped). The bbox-level re-glue stands in for the design's literal
# all-pairs test, which is O(n^2) on thousand-path draw-runs (2603's dense figures); same granularity
# where it matters — near sub-runs re-glue, distant sub-runs (a run that wandered) stay apart, so
# t_far carries the separation load when the jump splitter misses a close float boundary.
# XObjects carry NO stream evidence at m1 (their ids are a separate lane's sequence); they still
# union via V_geom, and noise xobjects keep their singleton rescue downstream.
# Returns @{ Labels = int[] dense component labels aligned to $PageItems (-1 = singleton noise);
#            Changed = @{label -> $true} for components a stream union actually reshaped }.
# Counters: stream_blocks (multi-path blocks), consensus_unions (stream joins that merged distinct
# components), consensus_changed_pages. V_geom-noise paths welded into a component by stream evidence
# are RESCUED (no longer noise); a component of former-noise fragments is a real region by evidence.
function Join-FigureViews([object[]] $PageItems, [int[]] $Labels, [double] $BodyPt, $Cons, $Summary) {
    $n = $PageItems.Count
    $parent = [int[]]::new($n)
    for ($i = 0; $i -lt $n; $i++) { $parent[$i] = $i }
    $touched = [bool[]]::new($n)   # root-indexed: component was reshaped by stream evidence
    $find = {                      # path-halving find (mirrors src/hdbscan UnionFind.cs)
        param([int] $x)
        while ($parent[$x] -ne $x) { $parent[$x] = $parent[$parent[$x]]; $x = $parent[$x] }
        $x
    }
    $unions = 0

    # V_geom evidence: union items sharing a cluster label (-1 noise stays apart)
    $firstOf = @{}
    for ($i = 0; $i -lt $n; $i++) {
        $lab = $Labels[$i]
        if ($lab -lt 0) { continue }
        if ($firstOf.ContainsKey($lab)) {
            $ra = & $find $firstOf[$lab]; $rb = & $find $i
            if ($ra -ne $rb) { $parent[$rb] = $ra; if ($touched[$rb]) { $touched[$ra] = $true } }
        }
        else { $firstOf[$lab] = $i }
    }

    # V_stream evidence over id-sorted path items (xobjects excluded)
    $bp     = if ($BodyPt) { [double]$BodyPt } else { 10.0 }
    $jumpPt = [double]$Cons.stream_jump_em * $bp
    $tfarPt = [double]$Cons.t_far_em * $bp
    $idL  = [System.Collections.Generic.List[int]]::new()
    $idxL = [System.Collections.Generic.List[int]]::new()
    for ($i = 0; $i -lt $n; $i++) {
        if ($PageItems[$i].prov -ne 'xobject') { $idL.Add([int]$PageItems[$i].id); $idxL.Add($i) }
    }
    $m = $idL.Count
    if ($m -gt 1) {
        $idArr = $idL.ToArray(); $ordArr = $idxL.ToArray()
        [Array]::Sort($idArr, $ordArr)                       # emission IS id order; sort defensively
        $bx = [object[]]::new($m)                            # double[4] cache — no PSObject walks in the hot loop
        for ($k = 0; $k -lt $m; $k++) { $bx[$k] = [double[]]@($PageItems[$ordArr[$k]].bbox) }

        # split into stream blocks at consecutive-gap > jump; chain-union consecutive pairs <= t_far
        $blockStart = [System.Collections.Generic.List[int]]::new()
        $blockEnd   = [System.Collections.Generic.List[int]]::new()
        $bs = 0
        for ($k = 1; $k -lt $m; $k++) {
            $a = $bx[$k - 1]; $b = $bx[$k]
            $gx = [math]::Max($b[0] - $a[2], $a[0] - $b[2]); if ($gx -lt 0) { $gx = 0.0 }
            $gy = [math]::Max($b[1] - $a[3], $a[1] - $b[3]); if ($gy -lt 0) { $gy = 0.0 }
            $gap = [math]::Sqrt($gx * $gx + $gy * $gy)
            if ($gap -gt $jumpPt) {
                if ($k - 1 -gt $bs) { $blockStart.Add($bs); $blockEnd.Add($k - 1) }
                $bs = $k
                continue
            }
            if ($gap -le $tfarPt) {
                $ra = & $find $ordArr[$k - 1]; $rb = & $find $ordArr[$k]
                if ($ra -ne $rb) { $parent[$rb] = $ra; $touched[$ra] = $true; $unions++ }
            }
        }
        if ($m - 1 -gt $bs) { $blockStart.Add($bs); $blockEnd.Add($m - 1) }
        $Summary.stream_blocks += $blockStart.Count

        # sub-chain re-glue, per block, to fixpoint: components whose union bboxes (over THIS block's
        # members) sit within t_far re-join — heals raster-scan draw orders where consecutive steps
        # exceed t_far but the sub-runs interleave in space.
        for ($bi = 0; $bi -lt $blockStart.Count; $bi++) {
            $s0 = $blockStart[$bi]; $e0 = $blockEnd[$bi]
            do {
                $rootBox = @{}
                for ($k = $s0; $k -le $e0; $k++) {
                    $r = & $find $ordArr[$k]
                    $b = $bx[$k]
                    $cur = $rootBox[$r]
                    if ($null -eq $cur) { $rootBox[$r] = [double[]]@($b[0], $b[1], $b[2], $b[3]) }
                    else {
                        if ($b[0] -lt $cur[0]) { $cur[0] = $b[0] }
                        if ($b[1] -lt $cur[1]) { $cur[1] = $b[1] }
                        if ($b[2] -gt $cur[2]) { $cur[2] = $b[2] }
                        if ($b[3] -gt $cur[3]) { $cur[3] = $b[3] }
                    }
                }
                $joinedAny = $false
                if ($rootBox.Count -ge 2) {
                    $roots = [int[]]@($rootBox.Keys)
                    for ($x = 0; $x -lt $roots.Length -and -not $joinedAny; $x++) {
                        for ($y = $x + 1; $y -lt $roots.Length; $y++) {
                            if ((Get-RectangleGap $rootBox[$roots[$x]] $rootBox[$roots[$y]]) -le $tfarPt) {
                                $parent[$roots[$y]] = $roots[$x]
                                $touched[$roots[$x]] = $true
                                $unions++; $joinedAny = $true
                                break
                            }
                        }
                    }
                }
            } while ($joinedAny)
        }
    }

    # dense component labels; singleton components stay noise (-1)
    $size = [int[]]::new($n); $rootArr = [int[]]::new($n)
    for ($i = 0; $i -lt $n; $i++) { $r = & $find $i; $rootArr[$i] = $r; $size[$r]++ }
    $labelOf = @{}; $next = 0
    $out = [int[]]::new($n); $changed = @{}
    for ($i = 0; $i -lt $n; $i++) {
        $r = $rootArr[$i]
        if ($size[$r] -lt 2) { $out[$i] = -1; continue }
        if (-not $labelOf.ContainsKey($r)) {
            $labelOf[$r] = $next
            if ($touched[$r]) { $changed[$next] = $true }
            $next++
        }
        $out[$i] = $labelOf[$r]
    }
    $Summary.consensus_unions += $unions
    if ($unions -gt 0) { $Summary.consensus_changed_pages++ }
    @{ Labels = $out; Changed = $changed }
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

        $best = $null; $bestGap = [double]::MaxValue; $bestPos = $null; $bestTxt = ''; $bestCue = $null
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
                $mCue = [regex]::Match($txt.Substring(0, [math]::Min(14, $txt.Length)), $cueRe)
                if ($mCue.Success) {
                    $best = $blk; $bestGap = $gap; $bestPos = $pos; $bestTxt = $txt
                    $bestCue = $mCue.Groups[1].Value
                }
            }
            if ($best) { break }
        }
        if ($best) {
            # cue_word = WHICH cue matched (Figure/Fig vs Table/Tab vs Algorithm/Listing) — the gate's
            # cue-TYPE split scores figure-cued regions against figure floats and keeps table-cued
            # regions out of both populations (ledger item A2).
            $fig['caption'] = [ordered]@{
                block_id = $best.id; bbox = $best.bx; text = $bestTxt
                cue = $true; cue_word = $bestCue; position = $bestPos; gap = [math]::Round($bestGap, 1)
            }
            $Summary.captioned_figures++
        }
    }
}

# Build ONE region record from raw members ({id, bbox, prov}) — the single record shape every
# producer shares ($addRegion at assembly, Split-CaptionInteriorRegions). area is measured; area_em2
# is the text-normalized measurement; density = members / area_em2 is the ink-coverage measurement.
# kind is the tunable opinion (degenerate|mark|sparse|figure); a region carrying ANY xobject BYPASSES
# the density gate (a placed bitmap is 1 point over a large area — vector-ink density is meaningless
# for it) while the size floors still apply. $Gates carries the config scalars so callers stay
# config-driven; id is left at -1 for the caller to assign (id = list index invariant).
function New-FigureRegionRecord($Page, $Members, $Flag, $BodyArea, $Gates) {
    $bbox = Get-FigureUnionBbox $Members
    if (-not $bbox) { return $null }
    $w = $bbox[2] - $bbox[0]; $h = $bbox[3] - $bbox[1]
    $area = [math]::Round($w * $h, 1)
    $pc = @($Members).Count
    $pathMembers = [System.Collections.Generic.List[object]]::new()
    $xobjMembers = [System.Collections.Generic.List[object]]::new()
    foreach ($m in $Members) { if ($m.prov -eq 'xobject') { $xobjMembers.Add($m) } else { $pathMembers.Add($m) } }
    $hasXobj = $xobjMembers.Count -gt 0
    $areaEm  = if ($BodyArea) { [math]::Round($area / $BodyArea, 3) } else { $null }
    $density = if ($areaEm -and $areaEm -gt 0) { [math]::Round($pc / $areaEm, 4) } else { $null }
    $kind =
        if ($w -lt $Gates.degenEps -or $h -lt $Gates.degenEps) { 'degenerate' }
        elseif ($null -ne $BodyArea) {
            if     ($areaEm -lt $Gates.floorEm)                                 { 'mark' }
            elseif ($hasXobj)                                                   { 'figure' }   # raster: density gate N/A
            elseif ($null -ne $density -and $density -lt $Gates.minDensity)     { 'sparse' }
            else                                                                { 'figure' }
        }
        else { if ($area -lt $Gates.fallbackPt2) { 'mark' } else { 'figure' } }
    [ordered]@{
        id = -1; page = $Page; bbox = $bbox; area = $area; area_em2 = $areaEm; density = $density
        # explicit foreach (NOT @($list.id)) — member-access enumeration on an EMPTY List yields a lone
        # $null, which would serialize as [null] on a pure-path or pure-xobject region; foreach gives []
        path_ids = @(foreach ($m in $pathMembers) { $m.id }); path_count = $pathMembers.Count
        xobject_ids = @(foreach ($m in $xobjMembers) { $m.id }); xobject_count = $xobjMembers.Count
        provenance = if ($hasXobj -and $pathMembers.Count) { 'mixed' } elseif ($hasXobj) { 'xobject' } else { 'path' }
        kind = $kind; flag = $Flag; caption = $null
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

# V_caption m2 increment (a) — INTERIOR SPLIT (tier2-handoff.md ledger item C, re-diagnosed
# 2026-07-05). A caption is definitionally a float BOUNDARY, so a caption-shaped cue block strictly
# INSIDE a kind=figure region is NEGATIVE co-membership evidence: the region welded (at least) two
# floats (2205 pg8 = Fig 7 + Fig 8 in one 399pt region; 2210 pg32 = Fig 14's caption at 46% height
# of a 1283 em² region). Split the region's members at the caption band — members whose bbox center
# sits above the block mid-line form the float that caption labels (captions sit BELOW their figure);
# the remainder recurses for multi-caption monsters. The splitting caption attaches to its upper
# sub-region when that part re-gates to kind=figure; the parent's ORIGINAL pass-1 caption (attached
# below the parent's bottom edge) follows the BOTTOM-most remainder.
# GUARDS — all must pass; the cue regex alone matches in-text references:
#   shape — cue word at block start (≤2 leading glyphs) AND block height ≤ max_block_em;
#   style — the block's (cue-word form, separator) must equal a style LEARNED from THIS paper's
#           pass-1 claimed captions ("Fig. 7" = Fig+none vs "Figure 14:" = Figure+colon). A paper
#           with no claimed captions is never split (no typography evidence → stay conservative).
#           Verified discriminative on the known hazards: 2205's interior body line "Figure 12
#           shows…" fails style (Figure+none vs learned Fig+none), 2403's "Figure 2 illustrates…"
#           paragraph fails height (150pt).
#   place — strictly interior (≥ margin_em inside BOTH top and bottom edges — a caption within the
#           bottom band is overhang, not a weld) with caption_min_overlap_frac horizontal overlap.
# Returns the rebuilt list (ids renumbered); counters: caption_splits + per-kind/caption surgery.
function Split-CaptionInteriorRegions([System.Collections.Generic.List[object]] $Figures,
    [string] $BlocksJsonl, $PathBbox, $XobjBbox, [double] $BodyPt, $BodyArea, $Cfg, $Gates, $Summary) {
    if (-not (Test-Path $BlocksJsonl)) { return , $Figures }
    $split      = $Cfg.caption_split
    $bp         = if ($BodyPt) { [double]$BodyPt } else { 10.0 }
    $marginPt   = [double]$split.margin_em * $bp
    $maxBlockPt = [double]$split.max_block_em * $bp
    $minOvl     = [double]$Cfg.caption_min_overlap_frac
    $styleRe    = '^[^\p{L}\d]{0,2}(Figure|Fig)\.?\s*\d+\s*([:.])?'

    # learned caption style(s): (figure-family cue word, separator?) over this paper's claimed captions
    $styles = @{}; $claimed = @{}
    foreach ($fig in $Figures) {
        if ($fig.caption) {
            $claimed[[int]$fig.caption.block_id] = $true
            $m = [regex]::Match([string]$fig.caption.text, $styleRe)
            if ($m.Success) { $styles[$m.Groups[1].Value + '|' + [string]($m.Groups[2].Value -ne '')] = $true }
        }
    }
    if ($styles.Count -eq 0) { return , $Figures }

    # shape+style-guarded unclaimed cue blocks, per page
    $byPage = @{}
    foreach ($line in (Get-Content $BlocksJsonl | Where-Object { $_.Trim() })) {
        $blk = $line | ConvertFrom-Json
        if (-not $blk.bx -or $claimed.ContainsKey([int]$blk.id)) { continue }
        if (($blk.bx[3] - $blk.bx[1]) -gt $maxBlockPt) { continue }
        $m = [regex]::Match(($blk.text_preview ?? ''), $styleRe)
        if (-not $m.Success) { continue }
        if (-not $styles.ContainsKey($m.Groups[1].Value + '|' + [string]($m.Groups[2].Value -ne ''))) { continue }
        $p = [int]$blk.page
        if (-not $byPage.ContainsKey($p)) { $byPage[$p] = [System.Collections.Generic.List[object]]::new() }
        $byPage[$p].Add($blk)
    }
    if ($byPage.Count -eq 0) { return , $Figures }

    $result = [System.Collections.Generic.List[object]]::new()
    foreach ($fig in $Figures) {
        $cand = if ($fig.kind -eq 'figure') { $byPage[[int]$fig.page] } else { $null }
        if (-not $cand) { $result.Add($fig); continue }
        $figL = $fig.bbox[0]; $figB = $fig.bbox[1]; $figR = $fig.bbox[2]; $figT = $fig.bbox[3]
        $interior = [System.Collections.Generic.List[object]]::new()
        foreach ($blk in $cand) {
            if ($blk.bx[3] -gt $figT - $marginPt -or $blk.bx[1] -lt $figB + $marginPt) { continue }
            $ovl = [math]::Min($figR, [double]$blk.bx[2]) - [math]::Max($figL, [double]$blk.bx[0])
            $den = [math]::Min($figR - $figL, [double]$blk.bx[2] - [double]$blk.bx[0])
            if ($den -le 0 -or ($ovl / $den) -lt $minOvl) { continue }
            $interior.Add($blk)
        }
        if ($interior.Count -eq 0) { $result.Add($fig); continue }

        # raw members back from the id→bbox maps (path and xobject id sequences are separate)
        $members = [System.Collections.Generic.List[object]]::new()
        foreach ($pid0 in @($fig.path_ids))    { $members.Add(@{ id = [int]$pid0; bbox = $PathBbox[[int]$pid0]; prov = 'path' }) }
        foreach ($xid0 in @($fig.xobject_ids)) { $members.Add(@{ id = [int]$xid0; bbox = $XobjBbox[[int]$xid0]; prov = 'xobject' }) }

        # split at each interior caption, topmost first: the part above a caption is the float it labels
        $subs = [System.Collections.Generic.List[object]]::new()
        $remaining = $members
        foreach ($blk in @($interior | Sort-Object { -[double]$_.bx[3] })) {
            $mid = ([double]$blk.bx[1] + [double]$blk.bx[3]) / 2.0
            $above = [System.Collections.Generic.List[object]]::new()
            $below = [System.Collections.Generic.List[object]]::new()
            foreach ($mm in $remaining) {
                if ((($mm.bbox[1] + $mm.bbox[3]) / 2.0) -gt $mid) { $above.Add($mm) } else { $below.Add($mm) }
            }
            if ($above.Count -eq 0 -or $below.Count -eq 0) { continue }   # degenerate cut — this block splits nothing
            $rec = New-FigureRegionRecord $fig.page $above 'caption_split' $BodyArea $Gates
            if (-not $rec) { continue }
            if ($rec.kind -eq 'figure') {
                $txt0 = [string]($blk.text_preview ?? '')
                $rec.caption = [ordered]@{
                    block_id = $blk.id; bbox = $blk.bx; text = $txt0
                    cue = $true; cue_word = [regex]::Match($txt0, $styleRe).Groups[1].Value
                    position = 'below'; gap = [math]::Round($rec.bbox[1] - [double]$blk.bx[3], 1)
                }
                $Summary.captioned_figures++
            }
            $subs.Add($rec)
            $remaining = $below
        }
        if ($subs.Count -eq 0) { $result.Add($fig); continue }   # every candidate cut was degenerate

        $tail = New-FigureRegionRecord $fig.page $remaining 'caption_split' $BodyArea $Gates
        if ($tail) {
            if ($fig.caption -and $tail.kind -eq 'figure') { $tail.caption = $fig.caption }
            elseif ($fig.caption) { $Summary.captioned_figures-- }   # parent caption lost to a non-figure tail
            $subs.Add($tail)
        }
        elseif ($fig.caption) { $Summary.captioned_figures-- }

        # counter surgery: parent (kind=figure by candidacy) leaves, sub-kinds enter
        $Summary.caption_splits++
        $Summary.regions += $subs.Count - 1
        $Summary.figures--
        if ($fig.xobject_count -gt 0) { $Summary.xobject_regions-- }
        foreach ($r in $subs) {
            switch ($r.kind) {
                'figure' { $Summary.figures++ } 'mark' { $Summary.marks++ }
                'sparse' { $Summary.sparse++ } 'degenerate' { $Summary.degenerate++ }
            }
            if ($r.xobject_count -gt 0) { $Summary.xobject_regions++ }
            $result.Add($r)
        }
    }
    for ($i = 0; $i -lt $result.Count; $i++) { $result[$i].id = $i }   # keep id = index
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
    # consensus m1 (absent block = disabled, so pre-consensus configs/fixtures behave exactly as before)
    $cons = $cfg.consensus
    $consensusEnabled = ($null -ne $cons -and [bool]$cons.enabled)
    if ($consensusEnabled -and [string]$cons.rule -ne 'inclusive') {
        throw "figure_regions.consensus.rule '$($cons.rule)' not supported at m1 (only 'inclusive')"
    }
    # V_caption interior split (m2 increment a; absent block = disabled)
    $capSplit = $cfg.caption_split
    $capSplitEnabled = ($null -ne $capSplit -and [bool]$capSplit.enabled)

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
        stream_blocks = 0; consensus_unions = 0; consensus_changed_pages = 0   # consensus m1 drift visibility
        caption_splits = 0   # V_caption interior split: welded regions cut at an interior caption
    }
    # kind-gate scalars, bundled once for every record producer (New-FigureRegionRecord callers)
    $gates = @{ degenEps = $degenEps; floorEm = $floorEm; fallbackPt2 = $fallbackPt2; minDensity = $minDensity }

    # Build + record one region (New-FigureRegionRecord carries the shared record shape + kind gates;
    # see its doc). id = list count before append; $figures/$summary/$gates resolve through the
    # enclosing scope.
    $addRegion = {
        param($page, $members, $flag)
        $rec = New-FigureRegionRecord $page $members $flag $bodyArea $gates
        if (-not $rec) { return }
        $rec.id = $figures.Count
        $figures.Add($rec)
        $summary.regions++
        if ($rec.xobject_count -gt 0) { $summary.xobject_regions++ }
        switch ($rec.kind) {
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

    # id → bbox maps (path and xobject id sequences are SEPARATE) — the caption splitter reconstitutes
    # a region's raw members from its persisted id lists
    $pathBbox = [System.Collections.Generic.Dictionary[int, object]]::new()
    foreach ($p in $paths) { $pathBbox[[int]$p.id] = $p.bbox }
    $xobjBbox = [System.Collections.Generic.Dictionary[int, object]]::new()
    foreach ($x in $xobjs) { $xobjBbox[[int]$x.id] = $x.bbox }

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

            # CONSENSUS m1: OR-combine the geometry partition with content-stream draw-run evidence
            # (Join-FigureViews) — a distinct view-join step between clustering and region assembly.
            # The combined component labels replace the raw ones (-1 stays noise); components the stream
            # view reshaped are flagged consensus_merged on their regions for drift visibility.
            $changedLabels = $null
            if ($consensusEnabled) {
                $joined = Join-FigureViews $pageItems $labels $bodyPt $cons $summary
                $labels = $joined.Labels
                $changedLabels = $joined.Changed
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
                $regFlag = if ($null -ne $changedLabels -and $changedLabels.ContainsKey($lab)) { 'consensus_merged' } else { $null }
                & $addRegion $page $byLabel[$lab] $regFlag
            }
            foreach ($nx in $noiseXobjs) { & $addRegion $page @($nx) 'xobject_singleton' }
        }
    }
    finally {
        Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
    }

    # Reattach captions from the Lane-3 blocks lane (if present beside the paths lane); then V_caption
    # interior split (a style-matched caption INSIDE a region = welded floats — cut there; needs the
    # pass-1 claims for the style census, so it runs after reattachment); then group subfigures: N
    # regions reattached to one float caption collapse to one figure (the shared caption is the
    # grouping signal). Split before grouping — a split's sub-regions carry distinct captions.
    if ($captionEnabled) {
        $blocksJsonl = $PathsJsonl -replace '\.paths\.jsonl$', '.blocks.jsonl'
        Add-FigureCaptions $figures $blocksJsonl $bodyPt $cfg $summary
        if ($capSplitEnabled) {
            $figures = Split-CaptionInteriorRegions $figures $blocksJsonl $pathBbox $xobjBbox $bodyPt $bodyArea $cfg $gates $summary
        }
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
