#requires -Version 7.0
# Band-weld calibration probe (thrust B scoping, tier3-engineering-plan §2-B). rectangle-gap is
# geometry-blind: 2em of whitespace and 2em of body-text band weld identically, so a formation can
# CROSS the page's text BACKBONE (T3-lite's wide Lane-3 blocks, width >= wide_block_em text-heights).
# T3-lite vetoes the damage post-hoc; full T3 (a band-conditioned metric) would prevent it. Before any
# C# is written this measures, across both corpora (newest pig runs):
#   (1) the ACCEPTANCE BASELINE — per-paper inflow demotion counts (pig-run.json steps.figures.inflow),
#       which full T3 should DROP (the veto inverts from fix to audit);
#   (2) the FIRE-SET — kind=figure regions with >= 1 member strictly ABOVE and >= 1 strictly BELOW an
#       interior backbone band (the welds a conditioned metric would keep apart at formation), with the
#       band height and the ink-to-ink span the metric bridged (sizes the gap-inflation weight);
#   (3) the BACKBONE FORK — the same fire-set under two band definitions: ALL wide blocks (T3-lite's
#       veto backbone, includes display-math lines) vs PROSE NODE-LINES (below). All-blocks
#       conditioning would also split multi-line equation stacks at their own inter-line bands — the
#       units T3-lite wants WHOLE so coverage can demote them; the prose backbone splits
#       figure-from-prose without splitting equation-from-equation.
# BACKBONE ITERATION RECORD (2026-07-10), why bands are NODE-level: (i) all-blocks fired 217/492 —
# real but shatter-hazardous. (ii) binary block filter (exclude any formula-node owner) fired 107,
# removed 110 hazards, but LOST captioned control 1608 p9 id8 — its welded band is a majority-prose
# paragraph carrying one embedded display line; one formula node poisoned the whole block. (ii')
# majority-by-node-count fired 209 (removed only 8) — consecutive formula lines merge into ONE
# formula-block GROUP node (classify display_math stack_gap_factor), so node-count majority
# systematically undercounts math. (iii) CURRENT: no block composition at all — bands are the bboxes
# of individual PROSE/heading-candidate NODES that pass the same width test. A mixed paragraph's
# prose lines band while its display line doesn't; an equation stack never bands. No threshold.
# Known positive controls that must fire in BOTH modes: 2112.02352 id6 (the text-welded formation
# defect at 56% backbone cover, below T3-lite's 0.7 cut) and the two CAPTIONED paragraph-welds
# 1608.02165v1 p8 id7 / p9 id8 (a stray member welded across a full prose paragraph into a real
# figure — the render-visible tier). Read-only.
$ErrorActionPreference = 'Stop'
$root = 'D:\aghado01\codex-scientiae\ingestion'
$groups = @('corpora/voroninski', 'compendia/ph-zigzag')
$cfg = Get-Content 'D:\aghado01\codex-scientiae\src\pdf-converter\stores\classify-config.json' -Raw | ConvertFrom-Json
$wideEm = [double]$cfg.figure_regions.inflow_demotion.wide_block_em   # backbone def mirrors pdfdig-figures.ps1:1161
$MARGIN_EM = 0.2    # a band must sit strictly interior to the region's y-extent by this margin (em)
$MODES = @('all', 'prose')

$totFig = 0; $inflowTotal = 0
$susp    = @{ all = 0; prose = 0 }
$suspCap = @{ all = 0; prose = 0 }
$rows = [System.Collections.Generic.List[object]]::new()          # prose-mode suspects (the proposed backbone)
$controls = [System.Collections.Generic.List[string]]::new()      # positive-control audit lines
$inflowRows = [System.Collections.Generic.List[object]]::new()
foreach ($group in $groups) {
    foreach ($pd in (Get-ChildItem (Join-Path $root $group) -Directory -EA 0)) {
        $slug = $pd.Name
        $pig = Get-ChildItem (Join-Path $pd.FullName ".runs/*/pig/$slug.figures.jsonl") -EA 0 |
            Sort-Object { $_.Directory.Parent.Name } -Desc | Select-Object -First 1
        if (-not $pig) { continue }
        $dir = $pig.Directory.FullName

        # (1) acceptance baseline straight off the run record
        $runJson = Get-Content (Join-Path $dir 'pig-run.json') -Raw | ConvertFrom-Json
        $inflow = [int]$runJson.steps.figures.inflow
        $inflowTotal += $inflow
        if ($inflow -gt 0) { $inflowRows.Add([pscustomobject]@{ grp=$group.Split('/')[-1]; slug=$slug; inflow=$inflow }) }

        # bodyPt from the engine's own calibration (classify.json) — no need to load 30MB letters lanes
        $bodyPt = [double](Get-Content (Join-Path $dir "$slug.classify.json") -Raw | ConvertFrom-Json).calibration.body_size
        if (-not $bodyPt) { $bodyPt = 10.0 }
        $widePt = $wideEm * $bodyPt

        $figs = @(Get-Content (Join-Path $dir "$slug.figures.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.kind -eq 'figure' })
        if (-not $figs) { continue }
        $paths = @{}; foreach ($p in (Get-Content (Join-Path $dir "$slug.paths.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox })) { $paths[[int]$p.id] = $p.bbox }
        $xr = @{}
        $xp = Join-Path $dir "$slug.xobjects.jsonl"
        if (Test-Path $xp) { foreach ($x in (Get-Content $xp | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox })) { $xr[[int]$x.id] = $x.bbox } }

        # backbone bands per page, two definitions:
        # 'all'   = RAW wide-block boxes, exactly the lane's $wideByPage (T3-lite veto backbone).
        # 'prose' = individual PROSE / heading-candidate NODE bboxes passing the SAME width test —
        #           the backbone is the prose lines themselves, no block composition (see header).
        $wideByPage = @{ all = @{}; prose = @{} }
        foreach ($line in (Get-Content (Join-Path $dir "$slug.blocks.jsonl") | Where-Object { $_.Trim() })) {
            $bk = $line | ConvertFrom-Json
            if (-not $bk.bx -or ($bk.bx[2] - $bk.bx[0]) -lt $widePt) { continue }
            $pgk = [int]$bk.page
            if (-not $wideByPage.all.ContainsKey($pgk)) { $wideByPage.all[$pgk] = [System.Collections.Generic.List[object]]::new() }
            $wideByPage.all[$pgk].Add([double[]]@($bk.bx))
        }
        foreach ($line in (Get-Content (Join-Path $dir "$slug.nodes.jsonl"))) {
            # ordinal fast-path: only prose/heading lines are band candidates; skip the rest unparsed
            if (-not ($line.Contains('"type":"prose"') -or $line.Contains('"type":"heading-candidate"'))) { continue }
            $n = $line | ConvertFrom-Json
            $bb = $n.'bounding box'
            if (-not $bb -or ($bb[2] - $bb[0]) -lt $widePt) { continue }
            $pgk = [int]$n.page
            if (-not $wideByPage.prose.ContainsKey($pgk)) { $wideByPage.prose[$pgk] = [System.Collections.Generic.List[object]]::new() }
            $wideByPage.prose[$pgk].Add([double[]]@($bb))
        }

        foreach ($f in $figs) {
            $totFig++
            $mem = [System.Collections.Generic.List[object]]::new()
            foreach ($pid0 in @($f.path_ids))    { if ($paths.ContainsKey([int]$pid0)) { $mem.Add($paths[[int]$pid0]) } }
            foreach ($xid0 in @($f.xobject_ids)) { if ($xr.ContainsKey([int]$xid0))    { $mem.Add($xr[[int]$xid0]) } }
            if ($mem.Count -lt 2) { continue }
            $fx0=[double]$f.bbox[0];$fy0=[double]$f.bbox[1];$fx1=[double]$f.bbox[2];$fy1=[double]$f.bbox[3]
            $m = $MARGIN_EM * $bodyPt
            $isControl = ($slug -eq '2112.02352' -and [int]$f.id -eq 6) -or
                         ($slug -eq '1608.02165v1' -and ([int]$f.id -eq 7 -or [int]$f.id -eq 8))
            foreach ($mode in $MODES) {
                $wide = $wideByPage[$mode][[int]$f.page]
                $worst = $null; $nBands = 0
                if ($null -ne $wide -and $wide.Count -gt 0) {
                    foreach ($wb in $wide) {
                        $ix = [math]::Min($fx1, $wb[2]) - [math]::Max($fx0, $wb[0])
                        if ($ix -le 0) { continue }
                        if (-not ($wb[1] -gt ($fy0 + $m) -and $wb[3] -lt ($fy1 - $m))) { continue }   # strictly interior
                        # members straddling the band: center above its top vs below its bottom
                        $above=0; $below=0; $aBot=[double]::MaxValue; $bTop=[double]::MinValue
                        foreach ($mb in $mem) {
                            $cy = ([double]$mb[1] + [double]$mb[3]) / 2.0
                            if ($cy -gt $wb[3])     { $above++; if ([double]$mb[1] -lt $aBot) { $aBot = [double]$mb[1] } }
                            elseif ($cy -lt $wb[1]) { $below++; if ([double]$mb[3] -gt $bTop) { $bTop = [double]$mb[3] } }
                        }
                        if ($above -eq 0 -or $below -eq 0) { continue }
                        $nBands++
                        $bandEm = ([double]$wb[3] - [double]$wb[1]) / $bodyPt
                        $spanEm = ($aBot - $bTop) / $bodyPt   # nearest ink-to-ink vertical span the metric bridged
                        if ($null -eq $worst -or $bandEm -gt $worst.bandEm) {
                            $worst = @{ bandEm=[math]::Round($bandEm,1); above=$above; below=$below; spanEm=[math]::Round($spanEm,1) }
                        }
                    }
                }
                if ($isControl) {
                    $controls.Add(("  control [{0}] {1} p{2} id{3}: {4,-5} fires={5}" -f `
                        $group.Split('/')[-1], $slug, $f.page, $f.id, $mode, ($nBands -gt 0)))
                }
                if ($nBands -eq 0) { continue }
                $susp[$mode]++
                if ($f.caption) { $suspCap[$mode]++ }
                if ($mode -eq 'prose') {
                    $rows.Add([pscustomobject]@{ grp=$group.Split('/')[-1]; slug=$slug; page=$f.page; id=$f.id
                        cap=[bool]$f.caption; flag=$f.flag; bands=$nBands
                        bandEm=$worst.bandEm; spanEm=$worst.spanEm; above=$worst.above; below=$worst.below })
                }
            }
        }
    }
}
Write-Host ("=== (1) ACCEPTANCE BASELINE: total inflow demotions={0} across both corpora (papers with >0 below)" -f $inflowTotal)
foreach ($r in ($inflowRows | Sort-Object inflow -Descending)) {
    Write-Host ("  [{0}] {1}  inflow={2}" -f $r.grp, $r.slug, $r.inflow)
}
Write-Host ("`n=== (2+3) FIRE-SET of {0} figure regions, by backbone mode:" -f $totFig)
Write-Host ("  ALL wide blocks (T3-lite veto backbone): suspects={0} (captioned={1})" -f $susp.all, $suspCap.all)
Write-Host ("  PROSE NODE-LINES (prose/heading node bboxes): suspects={0} (captioned={1})   shatter-hazard removed={2}" -f `
    $susp.prose, $suspCap.prose, ($susp.all - $susp.prose))
Write-Host "`n--- positive controls (must fire in BOTH modes) ---"
foreach ($c in $controls) { Write-Host $c }
Write-Host "`n--- PROSE-mode suspects (worst interior band per region; spanEm = ink-to-ink gap the metric bridged) ---"
foreach ($r in ($rows | Sort-Object bandEm -Descending)) {
    Write-Host ("  [{0}] {1} p{2} id{3} cap={4} flag={5} bands={6}  bandEm={7}  spanEm={8}  above={9} below={10}" -f `
        $r.grp,$r.slug,$r.page,$r.id,$r.cap,$r.flag,$r.bands,$r.bandEm,$r.spanEm,$r.above,$r.below)
}
