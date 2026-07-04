#requires -Version 7
<#
.SYNOPSIS
  Thin PowerShell wrapper over hdbscan.exe — points in, partition/dendrogram/summary out.

.DESCRIPTION
  The clustering engine stays a black-box CLI; no clustering logic lives in PowerShell.
  Resolves the published exe at bin/hdbscan/hdbscan.exe (built by ../../scripts/build-hdbscan.ps1) and
  falls back to `dotnet run --project projects/hdbscan` for an unpublished dev tree.
  Emits a PSCustomObject with the three output paths so a lane can read partition.csv back.

  First consumer: the pig figure lane writes Lane-4 bbox centroids to a temp points.jsonl,
  calls this, and reads hdbscan_partition.csv → figure-region groupings (stray rules fall
  out as noise, label -1).

.EXAMPLE
  Invoke-Hdbscan -In centroids.jsonl -OutDir out/ -MinClusterSize 3
#>
function Invoke-Hdbscan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $In,
        [Parameter(Mandatory)] [string] $OutDir,
        [int]    $MinPts,
        [int]    $MinClusterSize,
        [string] $DistanceMetric,
        [string] $LabelColumn,
        [string] $Delimiter,
        [ValidateSet('csv', 'jsonl')] [string] $Format,
        [switch] $NoHeader,
        [switch] $NoAllowSingleCluster,
        [string] $ConfigPath,
        [string] $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    )

    $cliArgs = @('--in', $In, '--out-dir', $OutDir)
    if ($PSBoundParameters.ContainsKey('MinPts'))         { $cliArgs += @('--min-pts', $MinPts) }
    if ($PSBoundParameters.ContainsKey('MinClusterSize')) { $cliArgs += @('--min-cluster-size', $MinClusterSize) }
    if ($DistanceMetric) { $cliArgs += @('--distance-metric', $DistanceMetric) }
    if ($LabelColumn)    { $cliArgs += @('--label-column', $LabelColumn) }
    if ($Delimiter)      { $cliArgs += @('--delimiter', $Delimiter) }
    if ($Format)         { $cliArgs += @('--format', $Format) }
    if ($NoHeader)       { $cliArgs += '--no-header' }
    if ($NoAllowSingleCluster) { $cliArgs += '--no-allow-single-cluster' }
    if ($ConfigPath)     { $cliArgs += @('--config', $ConfigPath) }

    $exe = Join-Path $RepoRoot 'bin/hdbscan/hdbscan.exe'
    if (Test-Path $exe) {
        & $exe @cliArgs
    } else {
        Write-Verbose "published exe not found at $exe — falling back to dotnet run"
        $proj = Join-Path $RepoRoot 'projects/hdbscan'
        & dotnet run --project $proj -- @cliArgs
    }
    if ($LASTEXITCODE -ne 0) { throw "hdbscan exited $LASTEXITCODE" }

    [pscustomobject]@{
        Partition  = Join-Path $OutDir 'hdbscan_partition.csv'
        Dendrogram = Join-Path $OutDir 'hdbscan_dendrogram.json'
        Summary    = Join-Path $OutDir 'summary.json'
    }
}
