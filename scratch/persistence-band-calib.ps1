#requires -Version 7
<#
  scratch/persistence-band-calib.ps1 — thrust C (T2 persistence-band selection) C-0 calibration
  (tier3-engineering-plan §2-C; calibrate-before-implement, sixth application).

  THE RULE UNDER CALIBRATION: replace EOM-stability + fragmentation_flag_min_clusters + defrag-elbow
  with one selection — a dendrogram node QUALIFIES as a figure region iff
      assembly(node) <= a   (its last internal merge: fully assembled by dilation a)
      death(node)    >  b   (its first outward merge: stays separate past b),  a <= b, em units.
  Qualifying nodes form an antichain by construction (a nested node dies at its parent's assembly
  <= a < b). Strays that only attach at extreme distance never sit inside a qualifying node -> noise.
  This is EXACTLY the eject B-4 proved EOM cannot perform (allow_single root-selection absorbs
  lone-blob strays at ANY lambda; 1608 p8 stays 1 cluster / 0 noise even at lambda=20).

  WHAT THIS PROBE MEASURES (both corpora, newest runs, every page carrying a kind=figure region):
  re-clusters the page exactly as the lane does (paths-then-xobjects point order), captures
  hdbscan_dendrogram.json, maps each CURRENT figure region to its best dendrogram node (lowest node
  containing all member rows; jacc = |members| / node.size), and reports assembly_em / death_em
  under BOTH metrics:
      plain  — rectangle-gap (today's geometry)
      banded — rectangle-gap-banded:lambda=2 over prose-node bands (B's conditioning)
  The paired read is the point: B's value proposition after B-4 is that it widens C's band —
  cross-text deaths inflate while intra-figure assembly stays put. Feasibility of a corpus-wide
  [a,b] (captioned regions: max assembly vs min death) under each metric IS the (lambda, a, b)
  re-sweep foundation. Captioned regions anchor the calibration (oracle-aligned); subfigure_merged
  multi-panel regions are the assembly-side risk class; the 1608/2112 monsters are the death-side
  targets (their blob node's death = the stray attach distance the band must exclude... from the
  STRAY side: the strays' containing nodes must FAIL the band). Read-only.
#>
[CmdletBinding()]
param(
    [double] $Lambda = 2.0,
    [string[]] $Groups = @('corpora/voroninski', 'compendia/ph-zigzag')
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$root = Join-Path $repo 'ingestion'
$exe  = Join-Path $repo 'bin/hdbscan/hdbscan.exe'
$cfg  = (Get-Content (Join-Path $repo 'src/pdf-converter/stores/classify-config.json') -Raw | ConvertFrom-Json).figure_regions
$minPts = [int]$cfg.min_pts; $minCs = [int]$cfg.min_cluster_size
$bandWEm = [double]$cfg.banded_metric.band_min_width_em

$work = Join-Path ([IO.Path]::GetTempPath()) ('pband-calib-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force -Path $work | Out-Null

# region rows -> (assembly, death, size, jacc) via the dendrogram. Merges are emitted in ascending
# Kruskal order; merge i creates node (leafCount + i) whose children are leaves (< leafCount) or
# earlier merge nodes. Bottom-up member counts find the LOWEST node holding the whole member set.
function Get-NodeStats($Dendro, [int[]] $Rows) {
    $n = [int]$Dendro.leaf_count
    $merges = @($Dendro.merges)
    $m = $Rows.Count
    if ($m -lt 1) { return $null }
    $cnt  = [int[]]::new($n + $merges.Count)
    foreach ($r in $Rows) { $cnt[$r] = 1 }
    $sizeOf = [int[]]::new($n + $merges.Count)
    for ($i = 0; $i -lt $n; $i++) { $sizeOf[$i] = 1 }
    $distOf = [double[]]::new($n + $merges.Count)
    $best = -1
    for ($i = 0; $i -lt $merges.Count; $i++) {
        $node = $n + $i
        $l = [int]$merges[$i].left_child; $r = [int]$merges[$i].right_child
        if ($l -ge $node -or $r -ge $node) { throw "dendrogram child ordering violated at merge $i" }
        $cnt[$node]    = $cnt[$l] + $cnt[$r]
        $sizeOf[$node] = $sizeOf[$l] + $sizeOf[$r]
        $distOf[$node] = [double]$merges[$i].distance
        if ($best -lt 0 -and $cnt[$node] -eq $m) { $best = $node }
    }
    if ($best -lt 0) { return $null }   # members never co-reside (shouldn't happen: root holds all)
    # death = distance of the first LATER merge that absorbs $best (children are strictly earlier,
    # so scan forward for the merge that references a node containing best's leaves — cheap version:
    # first later merge whose count strictly exceeds at the node containing best). Walk via parent:
    $death = [double]::PositiveInfinity
    for ($i = ($best - $n) + 1; $i -lt $merges.Count; $i++) {
        $node = $n + $i
        $l = [int]$merges[$i].left_child; $r = [int]$merges[$i].right_child
        if ($l -eq $best -or $r -eq $best) { $death = [double]$merges[$i].distance; break }
    }
    [pscustomobject]@{ assembly = $distOf[$best]; death = $death; size = $sizeOf[$best]; jacc = [math]::Round($m / [double]$sizeOf[$best], 2) }
}

$rows = [System.Collections.Generic.List[object]]::new()
try {
    foreach ($group in $Groups) {
        foreach ($pd in (Get-ChildItem (Join-Path $root $group) -Directory -EA 0)) {
            $slug = $pd.Name
            $pig = Get-ChildItem (Join-Path $pd.FullName ".runs/*/pig/$slug.figures.jsonl") -EA 0 |
                Sort-Object { $_.Directory.Parent.Name } -Desc | Select-Object -First 1
            if (-not $pig) { continue }
            $dir = $pig.Directory.FullName
            $bodyPt = [double](Get-Content (Join-Path $dir "$slug.classify.json") -Raw | ConvertFrom-Json).calibration.body_size
            if (-not $bodyPt) { $bodyPt = 10.0 }

            # lane-order point cloud per page: paths (file order, bbox only) then xobjects
            $ptRows = @{}   # page -> List[string] json lines
            $rowOf  = @{}   # page -> @{ 'p<id>' / 'x<id>' -> row }
            foreach ($line in [IO.File]::ReadLines((Join-Path $dir "$slug.paths.jsonl"))) {
                if (-not $line.Trim()) { continue }
                $p = $line | ConvertFrom-Json
                if (-not $p.bbox) { continue }
                $pg = [int]$p.page
                if (-not $ptRows.ContainsKey($pg)) { $ptRows[$pg] = [System.Collections.Generic.List[string]]::new(); $rowOf[$pg] = @{} }
                $rowOf[$pg]['p' + [int]$p.id] = $ptRows[$pg].Count
                $ptRows[$pg].Add(('{{"v":[{0},{1},{2},{3}]}}' -f $p.bbox[0], $p.bbox[1], $p.bbox[2], $p.bbox[3]))
            }
            $xp = Join-Path $dir "$slug.xobjects.jsonl"
            if (Test-Path $xp) {
                foreach ($line in [IO.File]::ReadLines($xp)) {
                    if (-not $line.Trim()) { continue }
                    $x = $line | ConvertFrom-Json
                    if (-not $x.bbox) { continue }
                    $pg = [int]$x.page
                    if (-not $ptRows.ContainsKey($pg)) { $ptRows[$pg] = [System.Collections.Generic.List[string]]::new(); $rowOf[$pg] = @{} }
                    $rowOf[$pg]['x' + [int]$x.id] = $ptRows[$pg].Count
                    $ptRows[$pg].Add(('{{"v":[{0},{1},{2},{3}]}}' -f $x.bbox[0], $x.bbox[1], $x.bbox[2], $x.bbox[3]))
                }
            }

            # prose-node bands per page (the lane's banded_metric filter)
            $bandLines = @{}
            $bandMinPt = $bandWEm * $bodyPt
            foreach ($line in [IO.File]::ReadLines((Join-Path $dir "$slug.nodes.jsonl"))) {
                if (-not ($line.Contains('"type":"prose"') -or $line.Contains('"type":"heading-candidate"'))) { continue }
                $nd = $line | ConvertFrom-Json
                $bb = $nd.'bounding box'
                if (-not $bb -or @($bb).Count -ne 4) { continue }
                if (([double]$bb[2] - [double]$bb[0]) -lt $bandMinPt) { continue }
                if (([double]$bb[3] - [double]$bb[1]) -le 0) { continue }
                $pg = [int]$nd.page
                if (-not $bandLines.ContainsKey($pg)) { $bandLines[$pg] = [System.Collections.Generic.List[string]]::new() }
                $bandLines[$pg].Add(('{{"v":[{0},{1},{2},{3}]}}' -f $bb[0], $bb[1], $bb[2], $bb[3]))
            }

            # regions by page (kind=figure only)
            $regsByPage = @{}
            foreach ($line in [IO.File]::ReadLines($pig.FullName)) {
                if (-not $line.Trim()) { continue }
                $f = $line | ConvertFrom-Json
                if ($f.kind -ne 'figure') { continue }
                $pg = [int]$f.page
                if (-not $regsByPage.ContainsKey($pg)) { $regsByPage[$pg] = [System.Collections.Generic.List[object]]::new() }
                $regsByPage[$pg].Add($f)
            }

            foreach ($pg in ($regsByPage.Keys | Sort-Object)) {
                $pts = $ptRows[$pg]
                if ($null -eq $pts -or $pts.Count -le $minPts) { continue }   # lane's too-few path: no clustering
                $ptsFile = Join-Path $work "$slug-p$pg.jsonl"
                [IO.File]::WriteAllLines($ptsFile, $pts)
                $bandsFile = Join-Path $work "$slug-p$pg.bands.jsonl"
                [IO.File]::WriteAllLines($bandsFile, [string[]]@($(if ($bandLines[$pg]) { $bandLines[$pg] } else { @() })))

                $dendro = @{}
                foreach ($mode in @('plain', 'banded')) {
                    $o = Join-Path $work "$slug-p$pg.$mode"
                    $cliArgs = @('--in', $ptsFile, '--out-dir', $o, '--min-pts', $minPts, '--min-cluster-size', $minCs, '--distance-metric',
                                 $(if ($mode -eq 'banded') { "rectangle-gap-banded:lambda=$Lambda" } else { 'rectangle-gap' }))
                    if ($mode -eq 'banded') { $cliArgs += @('--bands', $bandsFile) }
                    & $exe @cliArgs 2>$null | Out-Null
                    if ($LASTEXITCODE -ne 0) { throw "hdbscan failed: $slug p$pg $mode" }
                    $dendro[$mode] = Get-Content (Join-Path $o 'hdbscan_dendrogram.json') -Raw | ConvertFrom-Json
                }

                foreach ($f in $regsByPage[$pg]) {
                    $rowsIdx = [System.Collections.Generic.List[int]]::new()
                    foreach ($mid in @($f.path_ids))    { $k = 'p' + [int]$mid; if ($rowOf[$pg].ContainsKey($k)) { $rowsIdx.Add($rowOf[$pg][$k]) } }
                    foreach ($mid in @($f.xobject_ids)) { $k = 'x' + [int]$mid; if ($rowOf[$pg].ContainsKey($k)) { $rowsIdx.Add($rowOf[$pg][$k]) } }
                    if ($rowsIdx.Count -lt 2) { continue }
                    $sp = Get-NodeStats $dendro.plain  $rowsIdx.ToArray()
                    $sb = Get-NodeStats $dendro.banded $rowsIdx.ToArray()
                    if ($null -eq $sp -or $null -eq $sb) { continue }
                    $rows.Add([pscustomobject]@{
                        grp = $group.Split('/')[-1]; slug = $slug; page = $pg; id = $f.id
                        cap = [bool]$f.caption; flag = "$($f.flag)"; m = $rowsIdx.Count
                        jacc = $sp.jacc
                        asmP = [math]::Round($sp.assembly / $bodyPt, 1); dieP = if ([double]::IsInfinity($sp.death)) { 999 } else { [math]::Round($sp.death / $bodyPt, 1) }
                        asmB = [math]::Round($sb.assembly / $bodyPt, 1); dieB = if ([double]::IsInfinity($sb.death)) { 999 } else { [math]::Round($sb.death / $bodyPt, 1) }
                    })
                }
                Remove-Item $ptsFile, $bandsFile -EA 0
                Remove-Item (Join-Path $work "$slug-p$pg.plain"), (Join-Path $work "$slug-p$pg.banded") -Recurse -Force -EA 0
            }
        }
    }
}
finally { Remove-Item -Recurse -Force $work -EA 0 }

# ── report ──────────────────────────────────────────────────────────────────────────────────────
function Show-Feasibility([object[]] $Set, [string] $Title) {
    if (-not $Set.Count) { return }
    foreach ($mode in @(@('asmP','dieP','plain'), @('asmB','dieB',"banded λ=$Lambda"))) {
        $asm = @($Set | ForEach-Object { $_.($mode[0]) } | Sort-Object)
        $die = @($Set | ForEach-Object { $_.($mode[1]) } | Sort-Object)
        $q = { param($v, $p) $v[[math]::Min($v.Count - 1, [math]::Floor($p * $v.Count))] }
        Write-Host ("  {0,-14} [{1}]  assembly em: p50={2} p90={3} p99={4} max={5}   death em: min={6} p1={7} p10={8} p50={9}" -f `
            $mode[2], $Title, (& $q $asm 0.5), (& $q $asm 0.9), (& $q $asm 0.99), $asm[-1], $die[0], (& $q $die 0.01), (& $q $die 0.10), (& $q $die 0.5))
    }
}
$capSet = @($rows | Where-Object cap)
$subf   = @($rows | Where-Object { $_.flag -match 'subfigure' })
Write-Host ("`n=== persistence-band calibration: {0} figure regions measured ({1} captioned, {2} subfigure-merged) ===" -f $rows.Count, $capSet.Count, $subf.Count)
Show-Feasibility $capSet 'CAPTIONED'
Show-Feasibility $subf   'subfig-merged'
Show-Feasibility @($rows | Where-Object { -not $_.cap }) 'uncaptioned'
Write-Host "`n--- monsters / sentinels ---"
foreach ($r in ($rows | Where-Object { ($_.slug -eq '1608.02165v1' -and $_.page -in 7, 8, 9) -or ($_.slug -eq '2112.02352' -and $_.page -eq 8) })) {
    Write-Host ("  [{0}] {1} p{2} id{3} cap={4} m={5} jacc={6}  plain asm={7} die={8}   banded asm={9} die={10}" -f `
        $r.grp, $r.slug, $r.page, $r.id, $r.cap, $r.m, $r.jacc, $r.asmP, $r.dieP, $r.asmB, $r.dieB)
}
Write-Host "`n--- captioned regions with the 10 LARGEST plain assemblies (the band's a-side pressure) ---"
foreach ($r in ($capSet | Sort-Object asmP -Descending | Select-Object -First 10)) {
    Write-Host ("  [{0}] {1} p{2} id{3} flag={4} m={5} jacc={6}  plain asm={7} die={8}   banded asm={9} die={10}" -f `
        $r.grp, $r.slug, $r.page, $r.id, $r.flag, $r.m, $r.jacc, $r.asmP, $r.dieP, $r.asmB, $r.dieB)
}
Write-Host "`n--- captioned regions with the 10 SMALLEST plain deaths (the band's b-side pressure) ---"
foreach ($r in ($capSet | Sort-Object dieP | Select-Object -First 10)) {
    Write-Host ("  [{0}] {1} p{2} id{3} flag={4} m={5} jacc={6}  plain asm={7} die={8}   banded asm={9} die={10}" -f `
        $r.grp, $r.slug, $r.page, $r.id, $r.flag, $r.m, $r.jacc, $r.asmP, $r.dieP, $r.asmB, $r.dieB)
}
