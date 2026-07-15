#requires -Version 7
<#
  scratch/stray-eject-calib.ps1 — thrust C′ (per-cluster relative STRAY EJECT) C′-0 calibration
  (tier3-engineering-plan §2-C rescope; calibrate-before-implement, seventh application).

  STATISTIC ITERATION RECORD (why the rule is a SPINE ELBOW, not a near-child ratio):
  v1 tested ratio = merge_dist / near_child_assembly at each thin step. MEASURED 2026-07-10: the
  sentinels DON'T fire (1608 p8 ratio1=2.2, p9 1.1, 2112 1.0) while 25+ trivial junk clusters fire
  at 6–64×. Mechanism: on lone-blob pages strays attach as a LADDER (blob ~1em, junk ~11em, stray
  24.7em) — the near-child reference is inflated by the PREVIOUS rung, so every step looks locally
  modest. v2 (CURRENT): the reference is the spine's BULK via the defrag-elbow idiom — natural-log
  gap over the spine's distance sequence (Find-FragmentElbow convention, [math]::Log = ln,
  min_log_gap 1.0 ≈ 2.72×).

  THE v2 RULE: walk a selected cluster's dendrogram from its LCA down into the larger-member child.
  Steps whose far side holds 1..tail_max cluster members are LADDER rungs (candidate strays); the
  first step whose far side is FAT (> tail_max) marks the CORE TOP (multi-panel joins land here —
  panels are never thin, so they are structurally unejectable); a pure chain bottoms out at its
  2-leaf merge (its distance = core top). Sequence = [core_top, rung distances…] ascending; find the
  largest ln-gap between consecutive entries; if it is ≥ min_log_gap, EJECT the members of every
  rung above the gap. Uniform chains (sparse real diagrams, 2112) never show a decade gap → stay;
  a ~2.5× colorbar/legend satellite sits below 1.0 → stays; 1608's ladder (rungs ≥ ~10× the 1em
  core) fires. Noise-only spine steps contribute their DISTANCE to the sequence (geometry) but
  nothing to eject. B-4 context: EOM allow_single absorbs these strays at ANY metric inflation —
  this post-selection trim is the eject EOM cannot perform. Read-only.

  v2→v3 (MEASURED 2026-07-10): v2's raw sequence FAILED both ways — single-linkage assembles dense
  blobs by CHAINING (every spine step thin: 1608 p8 = 166 rungs of 169, fat-split core top almost
  never exists), so the scan covered the whole accretion sequence and ln-gaps between NEAR-ZERO
  distances (0.001→0.01em) read as huge while meaning nothing: subfig clusters "ejected" 62/38/24
  members from cuts landing in sub-glyph noise (2403 p7 reg12: entire cluster below 1.1em, "lnGap
  4.72"), while 1608 p8's true gap scored only 0.77 (its bulk's micro-gaps out-competed it). The
  defrag elbow never faced this: it scans only inter-FRAGMENT merges. v3 (CURRENT): CLAMP the
  sequence at contact scale (floor_em, default 1.0 — sub-glyph distances are all "touching") before
  the gap scan. Phantom cuts collapse (clamped-flat sequences have no gaps); 1608 p8's real
  boundary survives as ln(11/1)+ ≈ 2.4.
#>
[CmdletBinding()]
param(
    [double[]] $MinLogGaps = @(0.7, 1.0, 1.5),
    [double] $FloorEm = 1.0,   # contact scale: distances below this are "touching" — clamped pre-scan (v3)
    [string[]] $Groups = @('gauntlet/voroninski', 'gauntlet/ph-zigzag')
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
. (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')   # Find-FragmentElbow, Read-PartitionLabels
$root = Join-Path $repo 'ingestion'
$exe  = Join-Path $repo 'bin/hdbscan/hdbscan.exe'
$cfg  = (Get-Content (Join-Path $repo 'src/pdf-converter/stores/classify-config.json') -Raw | ConvertFrom-Json).figure_regions
$minPts = [int]$cfg.min_pts; $minCs = [int]$cfg.min_cluster_size
$fragMin = [int]$cfg.fragmentation_flag_min_clusters
$defragEnabled = [bool]$cfg.defrag_enabled
$defragMinLogGap = [double]$cfg.defrag_min_elbow_log_gap
$tailMax = $minCs - 1

$work = Join-Path ([IO.Path]::GetTempPath()) ('stray-eject-calib-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force -Path $work | Out-Null

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

            # lane-order point cloud per page (paths file-order then xobjects) + row maps
            $ptRows = @{}; $rowOf = @{}
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

            # row -> owning kind=figure region per page
            $regOf = @{}; $pagesWithFig = [System.Collections.Generic.HashSet[int]]::new()
            foreach ($line in [IO.File]::ReadLines($pig.FullName)) {
                if (-not $line.Trim()) { continue }
                $f = $line | ConvertFrom-Json
                if ($f.kind -ne 'figure') { continue }
                $pg = [int]$f.page
                [void]$pagesWithFig.Add($pg)
                if (-not $regOf.ContainsKey($pg)) { $regOf[$pg] = @{} }
                foreach ($mid in @($f.path_ids))    { $k = 'p' + [int]$mid; if ($rowOf[$pg].ContainsKey($k)) { $regOf[$pg][$rowOf[$pg][$k]] = $f } }
                foreach ($mid in @($f.xobject_ids)) { $k = 'x' + [int]$mid; if ($rowOf[$pg].ContainsKey($k)) { $regOf[$pg][$rowOf[$pg][$k]] = $f } }
            }

            foreach ($pg in ($pagesWithFig | Sort-Object)) {
                $pts = $ptRows[$pg]
                if ($null -eq $pts -or $pts.Count -le $minPts) { continue }
                $ptsFile = Join-Path $work "pts.jsonl"
                [IO.File]::WriteAllLines($ptsFile, $pts)
                $o = Join-Path $work 'out'
                & $exe --in $ptsFile --out-dir $o --min-pts $minPts --min-cluster-size $minCs --distance-metric rectangle-gap 2>$null | Out-Null
                if ($LASTEXITCODE -ne 0) { throw "hdbscan failed: $slug p$pg" }
                $labels = Read-PartitionLabels (Join-Path $o 'hdbscan_partition.csv')
                # lane-faithful defrag: epsilon re-run changes LABELS only (dendrogram is metric-determined)
                $distinct = @($labels | Where-Object { $_ -ge 0 } | Select-Object -Unique).Count
                if ($distinct -gt $fragMin -and $defragEnabled) {
                    $elbow = Find-FragmentElbow (Join-Path $o 'hdbscan_dendrogram.json') $labels $defragMinLogGap
                    if ($elbow) {
                        $o2 = Join-Path $work 'out2'
                        & $exe --in $ptsFile --out-dir $o2 --min-pts $minPts --min-cluster-size $minCs --distance-metric rectangle-gap --cluster-selection-epsilon $elbow 2>$null | Out-Null
                        $labels = Read-PartitionLabels (Join-Path $o2 'hdbscan_partition.csv')
                    }
                }
                $dendro = Get-Content (Join-Path $o 'hdbscan_dendrogram.json') -Raw | ConvertFrom-Json
                $n = [int]$dendro.leaf_count
                $merges = @($dendro.merges)
                $L = [int[]]::new($merges.Count); $R = [int[]]::new($merges.Count)
                $distOf = [double[]]::new($n + $merges.Count)
                $sizeOf = [int[]]::new($n + $merges.Count)
                for ($i = 0; $i -lt $n; $i++) { $sizeOf[$i] = 1 }
                for ($i = 0; $i -lt $merges.Count; $i++) {
                    $L[$i] = [int]$merges[$i].left_child; $R[$i] = [int]$merges[$i].right_child
                    $distOf[$n + $i] = [double]$merges[$i].distance
                    $sizeOf[$n + $i] = $sizeOf[$L[$i]] + $sizeOf[$R[$i]]
                }

                foreach ($lbl in (@($labels | Where-Object { $_ -ge 0 } | Select-Object -Unique))) {
                    $cRows = [System.Collections.Generic.List[int]]::new()
                    for ($ri = 0; $ri -lt $labels.Count; $ri++) { if ($labels[$ri] -eq $lbl) { $cRows.Add($ri) } }
                    if ($cRows.Count -lt 2) { continue }
                    $regHits = @{}
                    foreach ($ri in $cRows) { $f = $regOf[$pg][$ri]; if ($f) { $regHits[[int]$f.id] = 1 + ($regHits[[int]$f.id] ?? 0) } }
                    if (-not $regHits.Count) { continue }
                    $regId = ($regHits.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key
                    $reg = $null
                    foreach ($ri in $cRows) { $f = $regOf[$pg][$ri]; if ($f -and [int]$f.id -eq $regId) { $reg = $f; break } }

                    $cnt = [int[]]::new($n + $merges.Count)
                    foreach ($ri in $cRows) { $cnt[$ri] = 1 }
                    $lca = -1
                    for ($i = 0; $i -lt $merges.Count; $i++) {
                        $node = $n + $i
                        $cnt[$node] = $cnt[$L[$i]] + $cnt[$R[$i]]
                        if ($lca -lt 0 -and $cnt[$node] -eq $cRows.Count) { $lca = $node; break }
                    }
                    if ($lca -lt $n) { continue }

                    # SPINE WALK: rungs (thin member steps), noise steps (distance-only), core top
                    $rungs = [System.Collections.Generic.List[object]]::new()   # {dist, members}
                    $spineDists = [System.Collections.Generic.List[double]]::new()
                    $coreTop = 0.0
                    $node = $lca
                    while ($node -ge $n) {
                        $i = $node - $n
                        $cl = $cnt[$L[$i]]; $cr = $cnt[$R[$i]]
                        if ($cl -eq 0 -or $cr -eq 0) {   # noise-only far side: geometry, nothing to eject
                            $spineDists.Add($distOf[$node])
                            $node = if ($cl -eq 0) { $R[$i] } else { $L[$i] }
                            continue
                        }
                        $far  = if ($cl -le $cr) { $L[$i] } else { $R[$i] }
                        $near = if ($cl -le $cr) { $R[$i] } else { $L[$i] }
                        if ($cnt[$far] -gt $tailMax) { $coreTop = $distOf[$node]; break }   # FAT split = core top
                        $rungs.Add(@{ dist = $distOf[$node]; members = $cnt[$far] })
                        $spineDists.Add($distOf[$node])
                        $node = $near
                        if ($node -lt $n) { $coreTop = 0.0; break }                          # spine hit a leaf
                        if ($cnt[$node] -le $tailMax + 1) { $coreTop = $distOf[$node]; break } # chain bottom
                    }
                    if (-not $rungs.Count) { continue }

                    # elbow over [coreTop, spine dists ascending], CLAMPED at contact scale (v3):
                    # sub-glyph distances are all "touching" — relative gaps between them are noise.
                    $floorPt = $FloorEm * $bodyPt
                    $seq = [System.Collections.Generic.List[double]]::new()
                    if ($coreTop -gt 0) { $seq.Add([math]::Max($coreTop, $floorPt)) }
                    foreach ($d in ($spineDists | Sort-Object)) { $seq.Add([math]::Max($d, $floorPt)) }
                    $best = 0.0; $cut = $null
                    for ($i = 1; $i -lt $seq.Count; $i++) {
                        if ($seq[$i - 1] -le 0) { continue }
                        $g = [math]::Log($seq[$i]) - [math]::Log($seq[$i - 1])
                        if ($g -gt $best) { $best = $g; $cut = [math]::Sqrt($seq[$i - 1] * $seq[$i]) }
                    }
                    $eject = @{}
                    foreach ($mg in $MinLogGaps) {
                        $eject[$mg] = 0
                        if ($best -ge $mg -and $null -ne $cut) {
                            foreach ($rg in $rungs) { if ($rg.dist -gt $cut) { $eject[$mg] += [int]$rg.members } }
                        }
                    }
                    $rows.Add([pscustomobject]@{
                        grp = $group.Split('/')[-1]; slug = $slug; page = $pg
                        regId = $regId; cap = [bool]$reg.caption; flag = "$($reg.flag)"
                        size = $cRows.Count; rungs = $rungs.Count
                        coreEm = [math]::Round($coreTop / $bodyPt, 1)
                        topEm = [math]::Round(($spineDists | Measure-Object -Maximum).Maximum / $bodyPt, 1)
                        lnGap = [math]::Round($best, 2)
                        e07 = $eject[0.7]; e10 = $eject[1.0]; e15 = $eject[1.5]
                        dissolve10 = (($cRows.Count - $eject[1.0]) -lt $minCs -and $eject[1.0] -gt 0)
                    })
                }
            }
        }
    }
}
finally { Remove-Item -Recurse -Force $work -EA 0 }

Write-Host ("`n=== stray-eject calibration v2 (spine elbow, ln-gap; tail_max={0}) — {1} figure-owning clusters ===" -f $tailMax, $rows.Count)
foreach ($mg in $MinLogGaps) {
    $col = switch ($mg) { 0.7 { 'e07' } 1.0 { 'e10' } 1.5 { 'e15' } }
    $fired = @($rows | Where-Object { $_.$col -gt 0 })
    $capFired = @($fired | Where-Object cap)
    $capNonMonster = @($capFired | Where-Object { -not ($_.slug -eq '1608.02165v1' -and $_.page -in 8, 9) })
    Write-Host ("  min_log_gap={0}: fired={1} clusters  members ejected={2}  captioned fired={3} (non-monster FP census={4})" -f `
        $mg, $fired.Count, (($fired | Measure-Object $col -Sum).Sum), $capFired.Count, $capNonMonster.Count)
}
Write-Host "`n--- sentinels ---"
foreach ($r in ($rows | Where-Object { ($_.slug -eq '1608.02165v1' -and $_.page -in 7, 8, 9) -or ($_.slug -eq '2112.02352' -and $_.page -eq 8) })) {
    Write-Host ("  [{0}] {1} p{2} reg{3} cap={4} size={5} rungs={6} core={7}em top={8}em lnGap={9} eject@.7/1/1.5={10}/{11}/{12}" -f `
        $r.grp, $r.slug, $r.page, $r.regId, $r.cap, $r.size, $r.rungs, $r.coreEm, $r.topEm, $r.lnGap, $r.e07, $r.e10, $r.e15)
}
Write-Host "`n--- top 25 by ln-gap (the eject pressure list) ---"
foreach ($r in ($rows | Sort-Object lnGap -Descending | Select-Object -First 25)) {
    Write-Host ("  [{0}] {1} p{2} reg{3} cap={4} flag={5} size={6} rungs={7} core={8}em top={9}em lnGap={10} eject@1.0={11}{12}" -f `
        $r.grp, $r.slug, $r.page, $r.regId, $r.cap, $r.flag, $r.size, $r.rungs, $r.coreEm, $r.topEm, $r.lnGap, $r.e10,
        $(if ($r.dissolve10) { '  DISSOLVES' } else { '' }))
}
Write-Host "`n--- CAPTIONED non-monster clusters ejecting at min_log_gap=1.0 (the false-positive eyeball list) ---"
foreach ($r in ($rows | Where-Object { $_.cap -and $_.e10 -gt 0 -and -not ($_.slug -eq '1608.02165v1' -and $_.page -in 8, 9) } | Sort-Object e10 -Descending)) {
    Write-Host ("  [{0}] {1} p{2} reg{3} flag={4} size={5} core={6}em top={7}em lnGap={8} eject={9}" -f `
        $r.grp, $r.slug, $r.page, $r.regId, $r.flag, $r.size, $r.coreEm, $r.topEm, $r.lnGap, $r.e10)
}
Write-Host "`n--- clusters that DISSOLVE at min_log_gap=1.0 ---"
foreach ($r in ($rows | Where-Object dissolve10)) {
    Write-Host ("  [{0}] {1} p{2} reg{3} cap={4} size={5} lnGap={6} eject={7}" -f `
        $r.grp, $r.slug, $r.page, $r.regId, $r.cap, $r.size, $r.lnGap, $r.e10)
}
