#requires -Version 7
<#
  scratch/consensus-ablation.ps1 — consensus-m1 ablation scorer (issues/clustering/consensus-milestone1-design.md).

  Re-runs ConvertTo-FigureRegions OFFLINE on the NEWEST pig run's lanes (paths/letters/blocks/xobjects
  already on disk — no PdfPig, no image rendering) under a VARIANT config, writes figures.jsonl to a temp
  dir (the run itself is never touched), and scores both gate populations against the oracle. Lets the
  gate table isolate one knob at a time:

    consensus-off   figure_regions.consensus.enabled = false   (attribution: reproduce the pre-m1 table)
    defrag-off      figure_regions.defrag_enabled    = false   (is the epsilon de-frag loop vestigial
                                                                 now that consensus merges draw-runs?)

    pwsh -File scratch/consensus-ablation.ps1 -Variant consensus-off
    pwsh -File scratch/consensus-ablation.ps1 -Variant defrag-off
#>
[CmdletBinding()]
param(
    [string] $Group = 'gauntlet/ph-zigzag',
    [ValidateSet('consensus-off', 'defrag-off')] [string] $Variant = 'consensus-off'
)

$repo = Split-Path $PSScriptRoot -Parent
. (Join-Path $repo 'src/pdf-converter/pdfdig-figures.ps1')       # ConvertTo-FigureRegions
. (Join-Path $repo 'src/pdf-converter/Compare-FigureCounts.ps1') # Resolve-OracleCount / Get-PigFigureCounts (+ runs.ps1)

# variant config: clone the repo config, flip ONE knob
$cfgPath = Join-Path $repo 'src/pdf-converter/stores/classify-config.json'
$cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json
switch ($Variant) {
    'consensus-off' { $cfg.figure_regions.consensus.enabled = $false }
    'defrag-off'    { $cfg.figure_regions.defrag_enabled = $false }
}
$work = Join-Path ([IO.Path]::GetTempPath()) ("consensus-ablation-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force -Path $work | Out-Null
$varCfg = Join-Path $work 'variant-config.json'
[IO.File]::WriteAllText($varCfg, ($cfg | ConvertTo-Json -Depth 12), [System.Text.UTF8Encoding]::new($false))

$root = (Resolve-Path (Join-Path $repo 'ingestion')).Path
$groupDir = Join-Path $root $Group
$rows = [System.Collections.Generic.List[object]]::new()
try {
    foreach ($paperDir in (Get-ChildItem -LiteralPath $groupDir -Directory | Sort-Object Name)) {
        $slug = $paperDir.Name
        $pigDirs = @(Get-PigRunDirs $paperDir.FullName $slug)
        if (-not $pigDirs.Count) { Write-Warning "no pig run: $slug"; continue }
        $out = Join-Path $work "$slug.figures.jsonl"
        ConvertTo-FigureRegions -PathsJsonl (Join-Path $pigDirs[0] "$slug.paths.jsonl") -OutPath $out -ConfigPath $varCfg | Out-Null
        $pc = Get-PigFigureCounts $out
        $oracle = Resolve-OracleCount $paperDir.FullName $slug
        $rows.Add([ordered]@{
            slug = $slug; cap = $pc.captioned; fig = $oracle.figures
            dFig = if ($null -ne $oracle.figures) { $pc.captioned - $oracle.figures } else { $null }
            uncap = $pc.all - $pc.captioned; inline = $oracle.inline
            dInl = if ($null -ne $oracle.inline) { ($pc.all - $pc.captioned) - $oracle.inline } else { $null }
        })
    }
}
finally { Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue }

Write-Host ("`n== ablation: {0} ==" -f $Variant)
Write-Host ("{0,-16} {1,4} {2,4} {3,5}  {4,5} {5,6} {6,5}" -f 'paper', 'cap', 'fig', 'dFig', 'uncap', 'inline', 'dInl')
foreach ($r in $rows) {
    Write-Host ("{0,-16} {1,4} {2,4} {3,5}  {4,5} {5,6} {6,5}" -f $r.slug, $r.cap, $r.fig, $r.dFig, $r.uncap, $r.inline, $r.dInl)
}
$fs = @($rows | Where-Object { $null -ne $_.dFig })
$is = @($rows | Where-Object { $null -ne $_.dInl })
$mf = if ($fs.Count) { [math]::Round((($fs | ForEach-Object { [math]::Abs($_.dFig) } | Measure-Object -Sum).Sum / $fs.Count), 2) } else { $null }
$mi = if ($is.Count) { [math]::Round((($is | ForEach-Object { [math]::Abs($_.dInl) } | Measure-Object -Sum).Sum / $is.Count), 2) } else { $null }
Write-Host ("mean |dFig| = {0}   mean |dInl| = {1}`n" -f $mf, $mi)
