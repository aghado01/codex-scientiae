#requires -Version 7.0
# B1 cross-corpus PRIMARY-invariance gate (crop-bbox-inflation class a). For every paper in both
# corpora, re-run the formation lane (ConvertTo-FigureRegions) over its EXISTING pig paths.jsonl into a
# temp file and diff vs the committed figures.jsonl: EVERY region must be byte-identical on EVERY field
# EXCEPT the newly added visible_bbox. Reports total field-mismatches (must be 0) and every region that
# gained visible_bbox. Read-only w.r.t. the pig runs; no node / no raster. This is the acceptance gate.
$ErrorActionPreference = 'Stop'
. 'D:\aghado01\codex-scientiae\src\pdf-converter\pdfdig-figures.ps1'

$root = 'D:\aghado01\codex-scientiae\ingestion'
$groups = @('corpora/voroninski', 'compendia/ph-zigzag')
$tmp = Join-Path ([IO.Path]::GetTempPath()) ('b1gate-' + [Guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$strip = { param($r) $h=[ordered]@{}; foreach($p in $r.PSObject.Properties){ if($p.Name -ne 'visible_bbox'){ $h[$p.Name]=$p.Value } }; ($h | ConvertTo-Json -Depth 8 -Compress) }

$papers=0; $regions=0; $mismatch=0; $gained=[System.Collections.Generic.List[object]]::new()
foreach ($group in $groups) {
    foreach ($pd in (Get-ChildItem (Join-Path $root $group) -Directory -EA 0)) {
        $slug = $pd.Name
        $fig = Get-ChildItem (Join-Path $pd.FullName ".runs/*/pig/$slug.figures.jsonl") -EA 0 |
            Sort-Object { $_.Directory.Parent.Name } -Desc | Select-Object -First 1
        if (-not $fig) { continue }
        $pigDir = $fig.Directory.FullName
        $paths = Join-Path $pigDir "$slug.paths.jsonl"
        if (-not (Test-Path $paths)) { continue }
        $papers++
        $out = Join-Path $tmp "$slug.figures.jsonl"
        ConvertTo-FigureRegions -PathsJsonl $paths -OutPath $out 2>$null | Out-Null
        $old = @(Get-Content $fig.FullName | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json })
        $new = @(Get-Content $out | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json })
        if ($old.Count -ne $new.Count) { Write-Host ("  COUNT CHANGED {0}: {1}->{2}" -f $slug,$old.Count,$new.Count); $mismatch += 999; continue }
        for ($i=0;$i -lt $old.Count;$i++) {
            $regions++
            if ((& $strip $old[$i]) -ne (& $strip $new[$i])) { $mismatch++; Write-Host ("  MISMATCH {0} idx{1} id{2}" -f $slug,$i,$new[$i].id) }
            if ($new[$i].PSObject.Properties.Name -contains 'visible_bbox') {
                $gained.Add([pscustomobject]@{ grp=$group.Split('/')[-1]; slug=$slug; id=$new[$i].id; kind=$new[$i].kind; cap=[bool]$new[$i].caption
                    bbox=($new[$i].bbox -join ','); visible=($new[$i].visible_bbox -join ',') })
            }
        }
    }
}
Remove-Item -Recurse -Force $tmp -EA 0
Write-Host ("=== papers={0} regions={1}  non-visible_bbox field mismatches={2} (0 == PRIMARY-invariant, gate PASS)" -f $papers,$regions,$mismatch)
Write-Host ("=== regions that gained visible_bbox: {0}" -f $gained.Count)
foreach ($g in ($gained | Sort-Object grp,slug,id)) {
    Write-Host ("  [{0}] {1} id{2} {3} cap={4}  bbox=[{5}] visible=[{6}]" -f $g.grp,$g.slug,$g.id,$g.kind,$g.cap,$g.bbox,$g.visible)
}
