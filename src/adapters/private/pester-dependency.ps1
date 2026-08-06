# Pester adapter dependency helpers.

function Get-PesterBatchManifestRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    try {
        $data = Import-PowerShellDataFile -LiteralPath $Path -ErrorAction Stop
        $version = [version]$data.ModuleVersion
        if ($version -lt [version]'5.0') { return $null }
        return [pscustomobject]@{
            Path = (Resolve-Path -LiteralPath $Path).Path
            Version = $version
        }
    }
    catch { return $null }
}

function Resolve-PesterBatchDependency {
    [CmdletBinding()]
    param(
        [string] $PesterManifest,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    if (-not [string]::IsNullOrWhiteSpace($PesterManifest)) {
        $candidate = if ([System.IO.Path]::IsPathFullyQualified($PesterManifest)) {
            [System.IO.Path]::GetFullPath($PesterManifest)
        }
        else { [System.IO.Path]::GetFullPath($PesterManifest, $RepositoryRoot) }
        $record = Get-PesterBatchManifestRecord -Path $candidate
        if ($null -eq $record) {
            throw "pester-batch Pester manifest must identify Pester 5 or newer: '$PesterManifest'"
        }
        return $record
    }

    $records = [System.Collections.Generic.List[object]]::new()
    if (-not [string]::IsNullOrWhiteSpace($env:PORTABLE_ROOT)) {
        $portablePesterRoot = [System.IO.Path]::Combine(
            $env:PORTABLE_ROOT, 'PowerShell', 'Modules', 'Pester')
        if ([System.IO.Directory]::Exists($portablePesterRoot)) {
            foreach ($versionDirectory in [System.IO.Directory]::EnumerateDirectories(
                    $portablePesterRoot)) {
                $record = Get-PesterBatchManifestRecord -Path (
                    [System.IO.Path]::Combine($versionDirectory, 'Pester.psd1'))
                if ($null -ne $record) { $records.Add($record) }
            }
        }
    }
    $selected = $records | Sort-Object -Property `
        @{ Expression = 'Version'; Descending = $true },
        @{ Expression = 'Path'; Ascending = $true } | Select-Object -First 1
    if ($null -ne $selected) { return $selected }

    $records.Clear()
    foreach ($module in @(Get-Module -ListAvailable -Name Pester | Where-Object {
                $_.Version -ge [version]'5.0'
            })) {
        $record = Get-PesterBatchManifestRecord -Path $module.Path
        if ($null -ne $record) { $records.Add($record) }
    }

    $selected = $records | Sort-Object -Property `
        @{ Expression = 'Version'; Descending = $true },
        @{ Expression = 'Path'; Ascending = $true } | Select-Object -First 1
    if ($null -eq $selected) {
        throw 'pester-batch could not locate a Pester 5 or newer manifest'
    }
    return $selected
}

function Resolve-PesterBatchPowerShellPath {
    [CmdletBinding()]
    param([string] $PowerShellPath)

    if ([string]::IsNullOrWhiteSpace($PowerShellPath)) {
        $PowerShellPath = [System.Environment]::ProcessPath
    }
    if ([string]::IsNullOrWhiteSpace($PowerShellPath)) {
        $PowerShellPath = (Get-Command pwsh -CommandType Application -ErrorAction Stop).Source
    }
    elseif (-not [System.IO.Path]::IsPathFullyQualified($PowerShellPath)) {
        $PowerShellPath = (Get-Command $PowerShellPath -CommandType Application -ErrorAction Stop).Source
    }
    $candidate = [System.IO.Path]::GetFullPath($PowerShellPath)
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "pester-batch child PowerShell not found: '$PowerShellPath'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}
