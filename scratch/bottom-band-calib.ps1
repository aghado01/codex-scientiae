#requires -Version 7.0
# Bottom-band-caption calibration (A2b). Replicates Split-CaptionInteriorRegions' EXACT candidate
# selection (styles/bootstrap, styleRe, height caps, style-match, strict interiority, overlap) over the
# newest pig run of EVERY paper in both corpora, then reports each place a proposed DEGENERATE-ATTACH
# guard would fire: an interior cue-then-SEP caption whose midline cut is degenerate with BELOW EMPTY
# (all member centers above it) — i.e. a bottom-band below-caption the region bbox merely overshoots.
#
# For each firing it reports (1) the caption text — eyeball for FALSE ATTACHMENT (in-text ref / furniture)
# and (2) a TRIM-SAFETY read: capTop = caption top; among members intersecting the trimmed band
# [region-bottom .. capTop], how many are clip paths (invisible) vs VISIBLE ink, and the kept-floor (the
# lowest bottom of members entirely above capTop). A firing is TRIM-SAFE when the band holds only clip
# paths / a single oversized xobject; a VISIBLE non-clip path with real ink in the band is a TRIM-HAZARD.
# Read-only; touches no engine state. Force-add: scratch/ is gitignored.
$ErrorActionPreference = 'Stop'
$root = 'D:\aghado01\codex-scientiae\ingestion'
$groups = @('corpora/voroninski', 'compendia/ph-zigzag')
$styleRe = '^[^\p{L}]{0,4}(Figure|Fig)\.?\s*\d+\s*([:.])?'

$fireCount = 0; $hazardCount = 0; $paperCount = 0
foreach ($group in $groups) {
    $paperDirs = Get-ChildItem (Join-Path $root $group) -Directory -EA 0
    foreach ($pd in $paperDirs) {
        $slug = $pd.Name
        $pig = Get-ChildItem (Join-Path $pd.FullName ".runs/*/pig/$slug.figures.jsonl") -EA 0 |
            Sort-Object { $_.Directory.Parent.Name } -Desc | Select-Object -First 1
        if (-not $pig) { continue }
        $paperCount++
        $dir = $pig.Directory.FullName
        $figs   = @(Get-Content (Join-Path $dir "$slug.figures.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json })
        $blocks = @(Get-Content (Join-Path $dir "$slug.blocks.jsonl")  | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bx })
        $letters= @(Get-Content (Join-Path $dir "$slug.letters.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.size })
        $bp = if ($letters) { [double]($letters | Group-Object { [math]::Round($_.size,1) } | Sort-Object Count -Desc | Select-Object -First 1).Name } else { 10.0 }

        # paths/xobjects are LARGE — load lazily only if a paper reaches the member-reconstitution step
        # (i.e. has an interior candidate on a figure region). Most papers don't. $pathRec stays $null
        # until first use (assignments happen inline in THIS scope so they stick).
        $pathRec = $null; $xRec = $null

        # learned styles + claimed set (exact split logic)
        $styles = @{}; $claimed = @{}
        foreach ($f in $figs) {
            if ($f.caption) {
                $claimed[[int]$f.caption.block_id] = $true
                $m = [regex]::Match([string]$f.caption.text, $styleRe)
                if ($m.Success) { $styles[$m.Groups[1].Value + '|' + [string]($m.Groups[2].Value -ne '')] = $true }
            }
        }
        $bootstrap = ($styles.Count -eq 0)
        $maxBlockPt = 3.5 * $bp; $maxBlockSepPt = 9.0 * $bp; $marginPt = 1.0 * $bp; $minOvl = 0.25

        # candidate blocks per page
        $byPage = @{}
        foreach ($blk in $blocks) {
            if ($claimed[[int]$blk.id]) { continue }
            $t = [string]($blk.text ?? $blk.text_preview ?? '')
            $m = [regex]::Match($t, $styleRe)
            if (-not $m.Success) { continue }
            $sep = ([string]$m.Groups[2].Value -ne '')
            $hPt = [double]$blk.bx[3] - [double]$blk.bx[1]
            if ($hPt -gt $(if ($sep) { $maxBlockSepPt } else { $maxBlockPt })) { continue }
            if ($bootstrap) { if (-not $sep) { continue } }
            elseif (-not $styles.ContainsKey($m.Groups[1].Value + '|' + [string]$sep)) { continue }
            $p = [int]$blk.page
            if (-not $byPage.ContainsKey($p)) { $byPage[$p] = @() }
            $byPage[$p] += $blk
        }

        foreach ($fig in ($figs | Where-Object { $_.kind -eq 'figure' })) {
            $cand = $byPage[[int]$fig.page]
            if (-not $cand) { continue }
            $figL=$fig.bbox[0];$figB=$fig.bbox[1];$figR=$fig.bbox[2];$figT=$fig.bbox[3]
            # interior candidates FIRST (cheap; no members) — only load paths if any survive
            $interior = @($cand | Where-Object {
                -not ([double]$_.bx[3] -gt $figT - $marginPt -or [double]$_.bx[1] -lt $figB + $marginPt) -and
                ([math]::Min($figR-$figL, [double]$_.bx[2]-[double]$_.bx[0]) -gt 0) -and
                ((([math]::Min($figR,[double]$_.bx[2]) - [math]::Max($figL,[double]$_.bx[0])) / [math]::Min($figR-$figL, [double]$_.bx[2]-[double]$_.bx[0])) -ge $minOvl)
            })
            if ($interior.Count -eq 0) { continue }
            if ($null -eq $pathRec) {
                $pathRec = @{}; $xRec = @{}
                foreach ($p in (Get-Content (Join-Path $dir "$slug.paths.jsonl") | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox })) { $pathRec[[int]$p.id] = $p }
                $xp = Join-Path $dir "$slug.xobjects.jsonl"
                if (Test-Path $xp) { foreach ($x in (Get-Content $xp | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json } | Where-Object { $_.bbox })) { $xRec[[int]$x.id] = $x } }
            }
            $mem = @()
            foreach ($pid0 in @($fig.path_ids))   { if ($pathRec.ContainsKey([int]$pid0)) { $r=$pathRec[[int]$pid0]; $mem += ,([pscustomobject]@{ id=$r.id; bbox=$r.bbox; prov='path'; is_clipping=[bool]$r.is_clipping }) } }
            foreach ($xid0 in @($fig.xobject_ids)) { if ($xRec.ContainsKey([int]$xid0))    { $r=$xRec[[int]$xid0];  $mem += ,([pscustomobject]@{ id=$r.id; bbox=$r.bbox; prov='xobject'; is_clipping=$false }) } }
            if ($mem.Count -eq 0) { continue }
            foreach ($blk in $interior) {
                # degeneracy: below empty by center-vs-midline over the WHOLE member set (whole-region case)
                $mid = ([double]$blk.bx[1] + [double]$blk.bx[3]) / 2.0
                $above = @($mem | Where-Object { (([double]$_.bbox[1]+[double]$_.bbox[3])/2.0) -gt $mid })
                $below = @($mem | Where-Object { (([double]$_.bbox[1]+[double]$_.bbox[3])/2.0) -le $mid })
                if ($below.Count -ne 0 -or $above.Count -eq 0) { continue }   # not a bottom-band degenerate case
                $fireCount++
                # TRIM analysis: band = members whose bottom < capTop
                $capTop = [double]$blk.bx[3]
                $band = @($mem | Where-Object { [double]$_.bbox[1] -lt $capTop })
                $clip = @($band | Where-Object { $_.prov -ne 'xobject' -and $_.is_clipping })
                $visPath = @($band | Where-Object { $_.prov -ne 'xobject' -and -not $_.is_clipping })
                $bandX = @($band | Where-Object { $_.prov -eq 'xobject' })
                $kept = @($mem | Where-Object { [double]$_.bbox[1] -ge $capTop })
                $keptFloor = if ($kept) { ($kept | ForEach-Object { [double]$_.bbox[1] } | Measure-Object -Minimum).Minimum } else { $null }
                # visible non-clip PATH with real ink low in the band (top below the kept floor) = a genuine
                # low visible element the trim would cut. A single oversized xobject is padding, not hazard.
                $visLow = @($visPath | Where-Object { $null -ne $keptFloor -and [double]$_.bbox[3] -lt $keptFloor })
                $hazard = ($visLow.Count -gt 0)
                if ($hazard) { $hazardCount++ }
                $capTxt = ([string]($blk.text ?? $blk.text_preview ?? '')); $capTxt = $capTxt.Substring(0, [math]::Min(48, $capTxt.Length))
                Write-Host ("[{0}] {1} figId{2} pg{3}  cap='{4}'" -f $group.Split('/')[-1], $slug, $fig.id, $blk.page, $capTxt)
                Write-Host ("    region=({0:N0},{1:N0})-({2:N0},{3:N0}) capTop={4:N0}  members={5}  band(<capTop)={6}: clip={7} visPath={8} xobj={9}  keptFloor={10}  {11}" -f `
                    $figL,$figB,$figR,$figT, $capTop, $mem.Count, $band.Count, $clip.Count, $visPath.Count, $bandX.Count, $(if($null -ne $keptFloor){[int]$keptFloor}else{'--'}), $(if($hazard){"*** TRIM-HAZARD (visLow=$($visLow.Count)) ***"}else{'trim-safe'}))
            }
        }
    }
}
Write-Host ("`n=== papers-scanned={0}  degenerate-attach FIRINGS={1}  trim-hazards={2}" -f $paperCount, $fireCount, $hazardCount)
