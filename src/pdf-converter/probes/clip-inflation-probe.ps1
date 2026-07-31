#requires -Version 7.0
# Clip-path bbox-inflation prevalence probe (A2b follow-up scoping). A clipping path (is_clipping=true)
# is invisible — it masks subsequent drawing — yet it clusters into figure regions and its bbox EXTENDS
# the region's union bbox (Get-FigureUnionBbox), so a clip larger than the ink it masks inflates the crop
# past the visible figure (1701 Fig 7: clips span to y399, visible plot floors at y518). This measures,
# across both corpora, how often that happens and whether it causes harm (a caption/text block sitting in
# the inflated band) — grounds the scope + surfaces the PRIMARY-invariance risk (captioned regions whose
# bbox would move if recomputed from visible-only members). Read-only.
$ErrorActionPreference = 'Stop'
$root = 'D:\aghado01\codex-scientiae\ingestion'
$groups = @('gauntlet/voroninski', 'gauntlet/ph-zigzag')
$INFLATE_EM = 0.5   # report a region whose clip members extend the bbox by > this many text-heights on any edge

$totFig=0; $withClip=0; $inflated=0; $inflatedCap=0; $weldHarm=0; $invisTot=0; $invisClip=0; $soleClip=0
$rows = [System.Collections.Generic.List[object]]::new()
foreach ($group in $groups) {
    foreach ($pd in (Get-ChildItem (Join-Path $root $group) -Directory -EA 0)) {
        $slug = $pd.Name
        $pig = Get-ChildItem (Join-Path $pd.FullName ".runs/*/pig/$slug.figures.jsonl") -EA 0 |
            Sort-Object { $_.Directory.Parent.Name } -Desc | Select-Object -First 1
        if (-not $pig) { continue }
        $dir = $pig.Directory.FullName
        $figs = @(Get-Content (Join-Path $dir "$slug.figures.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.kind -eq 'figure' })
        if (-not $figs) { continue }
        $letters = @(Get-Content (Join-Path $dir "$slug.letters.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.size })
        $bp = if ($letters) { [double]($letters | Group-Object { [math]::Round($_.size,1) } | Sort-Object Count -Desc | Select-Object -First 1).Name } else { 10.0 }
        $paths = @{}; foreach ($p in (Get-Content (Join-Path $dir "$slug.paths.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox })) { $paths[[int]$p.id] = $p }
        $xr = @{}
        $xp = Join-Path $dir "$slug.xobjects.jsonl"
        if (Test-Path $xp) { foreach ($x in (Get-Content $xp | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox })) { $xr[[int]$x.id] = $x } }
        $blocks = @(Get-Content (Join-Path $dir "$slug.blocks.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bx })
        $blkByPage = @{}; foreach ($b in $blocks) { $p=[int]$b.page; if(-not $blkByPage.ContainsKey($p)){$blkByPage[$p]=@()}; $blkByPage[$p]+=$b }

        foreach ($f in $figs) {
            $totFig++
            # VISIBLE = painted ink (is_stroked OR is_filled) for paths, plus every xobject. INVISIBLE =
            # unpainted paths — clip boundaries (is_clipping; e.g. 1701 Fig 7's 6 clip rects 47/48/50/54/
            # 100/115) AND bare unpainted non-clip paths. Paint, not is_clipping, is the visibility signal
            # here — but its LIMIT is a painted-yet-invisible background FILL (1701 Fig 7's id49: is_filled
            # =true, spans down to y399); this test keeps that VISIBLE, and only IR COLOR (§E) can drop it.
            $invisMem=@(); $visMem=@()
            foreach ($pid0 in @($f.path_ids)) { if ($paths.ContainsKey([int]$pid0)) { $r=$paths[[int]$pid0]
                if ($r.is_stroked -or $r.is_filled) { $visMem+=,$r } else { $invisMem+=,$r; $invisTot++; if ($r.is_clipping){$invisClip++} } } }
            foreach ($xid0 in @($f.xobject_ids)) { if ($xr.ContainsKey([int]$xid0)) { $visMem+=,($xr[[int]$xid0]) } }
            if ($invisMem.Count -eq 0) { continue }
            $withClip++
            if ($visMem.Count -eq 0) { $soleClip++; continue }   # excluding invisible members would collapse the region
            # visible-only bbox
            $vl=($visMem|%{[double]$_.bbox[0]}|Measure-Object -Min).Minimum; $vb=($visMem|%{[double]$_.bbox[1]}|Measure-Object -Min).Minimum
            $vr=($visMem|%{[double]$_.bbox[2]}|Measure-Object -Max).Maximum; $vt=($visMem|%{[double]$_.bbox[3]}|Measure-Object -Max).Maximum
            $fl=[double]$f.bbox[0];$fb=[double]$f.bbox[1];$fr=[double]$f.bbox[2];$ft=[double]$f.bbox[3]
            # per-edge inflation (all-bbox extends beyond visible), em
            $infL=($vl-$fl)/$bp; $infB=($vb-$fb)/$bp; $infR=($fr-$vr)/$bp; $infT=($ft-$vt)/$bp
            $maxInf=[math]::Max([math]::Max($infL,$infB),[math]::Max($infR,$infT))
            if ($maxInf -le $INFLATE_EM) { continue }
            $inflated++
            $isCap = [bool]$f.caption
            if ($isCap) { $inflatedCap++ }
            # weld harm: a text block sitting in an inflated band (outside visible bbox but inside all bbox)
            $harm=$false
            foreach ($b in @($blkByPage[[int]$f.page])) {
                $bl=[double]$b.bx[0];$bb=[double]$b.bx[1];$br=[double]$b.bx[2];$bt=[double]$b.bx[3]
                $inAll = ($bt -le $ft -and $bb -ge $fb -and $br -ge $fl -and $bl -le $fr)
                $inVis = ($bt -le $vt -and $bb -ge $vb -and $br -ge $vl -and $bl -le $vr)
                if ($inAll -and -not $inVis) { $harm=$true; break }
            }
            if ($harm) { $weldHarm++ }
            $rows.Add([pscustomobject]@{ grp=$group.Split('/')[-1]; slug=$slug; id=$f.id; cap=$isCap; harm=$harm; maxInfEm=[math]::Round($maxInf,1); edges=("L{0:N1} B{1:N1} R{2:N1} T{3:N1}" -f $infL,$infB,$infR,$infT) })
        }
    }
}
Write-Host ("=== figure regions={0}  with-INVISIBLE-members={1}  bbox-inflated>{2}em past painted ink={3} (captioned={4}, weld-harm={5})" -f $totFig,$withClip,$INFLATE_EM,$inflated,$inflatedCap,$weldHarm)
Write-Host ("=== EDGE CASES: invisible (unpainted) members across regions={0} (is_clipping={1}, non-clip unpainted={2})  all-invisible regions={3} (would collapse if dropped)" -f $invisTot,$invisClip,($invisTot-$invisClip),$soleClip)
Write-Host "`n--- inflated regions (bbox extends >$($INFLATE_EM)em past PAINTED ink) ---"
foreach ($r in ($rows | Sort-Object maxInfEm -Descending)) {
    Write-Host ("  [{0}] {1} id{2} cap={3} harm={4} maxInf={5}em  edges: {6}" -f $r.grp,$r.slug,$r.id,$r.cap,$r.harm,$r.maxInfEm,$r.edges)
}
