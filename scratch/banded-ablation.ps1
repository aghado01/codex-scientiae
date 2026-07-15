#requires -Version 7
<#
  scratch/banded-ablation.ps1 — thrust-B (full T3) B-4 gate: banded-metric ablation scorer
  (tier3-engineering-plan §2-B; sibling of consensus-ablation.ps1, same offline method).

  Re-runs ConvertTo-FigureRegions OFFLINE on each paper's NEWEST pig run lanes (paths/letters/
  blocks/nodes/xobjects already on disk — no PdfPig, no raster) under a VARIANT config, writes
  figures.jsonl to a temp dir, and scores BOTH corpora's gate populations against the oracle,
  PLUS the B-specific acceptance surfaces:
    - summary.inflow total (baseline 201 — full T3 should DROP it: the veto inverts fix→audit)
    - summary.banded_pages (drift visibility: pages actually clustered banded)
    - SENTINEL pages from the B-0 calibration (scratch/band-weld-calib.ps1):
        targets — welds that SHOULD change:  1608 p8/p9 (captioned paragraph-welds), 2112 p8 (id6)
        guards  — correct regions that MUST NOT split: subfigure/consensus-merged rows with a ~1em
                  interior subcaption line (2204 p12, 2501 p12, 2008 p8/p12, 2603 p8/p11, 2006 p11)
      reported as per-page figure/captioned counts + tallest captioned-region height (a split
      target shows up as a height DROP even when the stray member falls to noise, not +1 count).

    pwsh -File scratch/banded-ablation.ps1                    # banded-on, lambda from config default
    pwsh -File scratch/banded-ablation.ps1 -Lambda 3.0        # lambda sweep point
    pwsh -File scratch/banded-ablation.ps1 -Variant baseline  # self-check: COUNTS must equal the
                                                              # recorded gate (0.7/5.6, 0.35/11.74);
                                                              # bytes may differ (de-hyphenated text)
#>
[CmdletBinding()]
param(
    [ValidateSet('banded-on', 'baseline', 'eject-on', 'banded-eject-on')] [string] $Variant = 'banded-on',
    [double] $Lambda = 2.0,
    [string[]] $Groups = @('gauntlet/voroninski', 'gauntlet/ph-zigzag')
)

$repo = Split-Path $PSScriptRoot -Parent
. (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')       # ConvertTo-FigureRegions
. (Join-Path $repo 'src/pdf-converter/Compare-FigureCounts.ps1') # Resolve-OracleCount / Get-PigFigureCounts (+ runs.ps1)

$groups = $Groups
$sentinels = @(
    @{ slug = '1608.02165v1'; page = 8;  role = 'TARGET weld (id7: 1 stray above 11.5em paragraph)' }
    @{ slug = '1608.02165v1'; page = 9;  role = 'TARGET weld (id8: 2 strays above paragraph)' }
    @{ slug = '2112.02352';   page = 8;  role = 'TARGET control (id6 text-welded formation)' }
    @{ slug = '2204.11080v2'; page = 12; role = 'GUARD subfigure_merged (~1em subcaption row)' }
    @{ slug = '2501.00322v1'; page = 12; role = 'GUARD subfigure/consensus-merged' }
    @{ slug = '2008.10579v1'; page = 8;  role = 'GUARD subfigure_merged (dense scatter)' }
    @{ slug = '2008.10579v1'; page = 12; role = 'GUARD consensus_merged' }
    @{ slug = '2603.03037v1'; page = 8;  role = 'GUARD consensus_merged' }
    @{ slug = '2603.03037v1'; page = 11; role = 'GUARD consensus_merged' }
    @{ slug = '2006.07953v2'; page = 11; role = 'GUARD subfigure_merged' }
)

# variant config: clone the repo config, PIN both structural knobs OFF, then flip the ONE under
# test — 'baseline' means knob-off regardless of the store defaults (stray_eject defaults ON since
# the C′ close-out 2026-07-15; the recorded baseline numbers in the header are knob-off numbers)
$cfgPath = Join-Path $repo 'src/pdf-converter/stores/classify-config.json'
$cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json
$cfg.figure_regions.banded_metric.enabled = $false
$cfg.figure_regions.stray_eject.enabled = $false
if ($Variant -in 'banded-on', 'banded-eject-on') {
    $cfg.figure_regions.banded_metric.enabled = $true
    $cfg.figure_regions.banded_metric.lambda = $Lambda
}
if ($Variant -in 'eject-on', 'banded-eject-on') {
    $cfg.figure_regions.stray_eject.enabled = $true
}
$work = Join-Path ([IO.Path]::GetTempPath()) ("banded-ablation-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force -Path $work | Out-Null
$varCfg = Join-Path $work 'variant-config.json'
[IO.File]::WriteAllText($varCfg, ($cfg | ConvertTo-Json -Depth 12), [System.Text.UTF8Encoding]::new($false))

# per-page stats for the sentinel table: figure count / captioned count / tallest captioned height (pt)
function Get-PageStats([string] $FiguresJsonl, [int] $Page) {
    $figs = 0; $cap = 0; $capH = 0.0
    foreach ($line in [IO.File]::ReadLines($FiguresJsonl)) {
        if (-not $line.Trim()) { continue }
        $f = $line | ConvertFrom-Json
        if ([int]$f.page -ne $Page -or $f.kind -ne 'figure') { continue }
        $figs++
        if ($f.caption) {
            $cap++
            $h = [double]$f.bbox[3] - [double]$f.bbox[1]
            if ($h -gt $capH) { $capH = $h }
        }
    }
    [pscustomobject]@{ figs = $figs; cap = $cap; capH = [math]::Round($capH, 0) }
}

$root = (Resolve-Path (Join-Path $repo 'ingestion')).Path
$inflowVar = 0; $bandedPages = 0; $ejects = 0; $ejectClusters = 0
$gate = [ordered]@{}
$sentinelRows = [System.Collections.Generic.List[object]]::new()
try {
    foreach ($group in $groups) {
        $rows = [System.Collections.Generic.List[object]]::new()
        foreach ($paperDir in (Get-ChildItem -LiteralPath (Join-Path $root $group) -Directory | Sort-Object Name)) {
            $slug = $paperDir.Name
            $pigDirs = @(Get-PigRunDirs $paperDir.FullName $slug)
            if (-not $pigDirs.Count) { Write-Warning "no pig run: $slug"; continue }
            $out = Join-Path $work "$slug.figures.jsonl"
            $res = ConvertTo-FigureRegions -PathsJsonl (Join-Path $pigDirs[0] "$slug.paths.jsonl") -OutPath $out -ConfigPath $varCfg -PassThru
            $inflowVar   += [int]$res.Summary.inflow
            $bandedPages += [int]$res.Summary.banded_pages
            $ejects        += [int]($res.Summary.stray_ejects ?? 0)
            $ejectClusters += [int]($res.Summary.stray_eject_clusters ?? 0)
            $pc = Get-PigFigureCounts $out
            $oracle = Resolve-OracleCount $paperDir.FullName $slug
            $rows.Add([ordered]@{
                slug = $slug; cap = $pc.captioned; fig = $oracle.figures
                dFig = if ($null -ne $oracle.figures) { $pc.captioned - $oracle.figures } else { $null }
                uncap = $pc.all - $pc.captioned; inline = $oracle.inline
                dInl = if ($null -ne $oracle.inline) { ($pc.all - $pc.captioned) - $oracle.inline } else { $null }
            })
            foreach ($s in ($sentinels | Where-Object { $_.slug -eq $slug })) {
                $base = Get-PageStats (Join-Path $pigDirs[0] "$slug.figures.jsonl") $s.page
                $vari = Get-PageStats $out $s.page
                $sentinelRows.Add([pscustomobject]@{
                    slug = $slug; page = $s.page; role = $s.role
                    figs = ('{0}→{1}' -f $base.figs, $vari.figs)
                    cap  = ('{0}→{1}' -f $base.cap,  $vari.cap)
                    capH = ('{0}→{1}' -f $base.capH, $vari.capH)
                })
            }
        }
        $gate[$group] = $rows
    }
}
finally { Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue }

Write-Host ("`n== banded ablation: {0}{1} ==" -f $Variant, $(if ($Variant -eq 'banded-on') { " lambda=$Lambda" } else { '' }))
foreach ($group in $groups) {
    $rows = $gate[$group]
    Write-Host ("`n--- {0} ---" -f $group)
    Write-Host ("{0,-16} {1,4} {2,4} {3,5}  {4,5} {5,6} {6,5}" -f 'paper', 'cap', 'fig', 'dFig', 'uncap', 'inline', 'dInl')
    foreach ($r in $rows) {
        Write-Host ("{0,-16} {1,4} {2,4} {3,5}  {4,5} {5,6} {6,5}" -f $r.slug, $r.cap, $r.fig, $r.dFig, $r.uncap, $r.inline, $r.dInl)
    }
    $fs = @($rows | Where-Object { $null -ne $_.dFig })
    $is = @($rows | Where-Object { $null -ne $_.dInl })
    $over = @($fs | Where-Object { $_.dFig -gt 0 }).Count
    $exact = @($fs | Where-Object { $_.dFig -eq 0 }).Count
    $mf = if ($fs.Count) { [math]::Round((($fs | ForEach-Object { [math]::Abs($_.dFig) } | Measure-Object -Sum).Sum / $fs.Count), 2) } else { $null }
    $mi = if ($is.Count) { [math]::Round((($is | ForEach-Object { [math]::Abs($_.dInl) } | Measure-Object -Sum).Sum / $is.Count), 2) } else { $null }
    Write-Host ("PRIMARY mean|dFig| = {0} ({1}/{2} exact, {3} over)   SECONDARY mean|dInl| = {4}" -f $mf, $exact, $fs.Count, $over, $mi)
}
Write-Host ("`ninflow demotions (variant) = {0}   banded pages = {1}   stray ejects = {2} ({3} clusters)" -f $inflowVar, $bandedPages, $ejects, $ejectClusters)
Write-Host "`n--- sentinels (baseline→variant: figure count / captioned / tallest captioned height pt) ---"
foreach ($s in $sentinelRows) {
    Write-Host ("  {0,-14} p{1,-3} figs {2,-6} cap {3,-6} capH {4,-10} {5}" -f $s.slug, $s.page, $s.figs, $s.cap, $s.capH, $s.role)
}
