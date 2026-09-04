#requires -Version 7.0

$script:AdaptersModuleRoot = $PSScriptRoot
$script:AdaptersDefaultRepositoryRoot = [System.IO.Path]::GetFullPath(
    (Join-Path $script:AdaptersModuleRoot '../..'))
$script:AdaptersExecutorManifest = [System.IO.Path]::GetFullPath(
    (Join-Path $script:AdaptersModuleRoot '../batch-executor/batch-executor.psd1'))
if (-not (Test-Path -LiteralPath $script:AdaptersExecutorManifest -PathType Leaf)) {
    throw "adapters dependency not found: '$script:AdaptersExecutorManifest'"
}
Import-Module $script:AdaptersExecutorManifest -Scope Local -ErrorAction Stop

$script:AdaptersContainment = [System.IO.Path]::GetFullPath(
    (Join-Path $script:AdaptersModuleRoot '../infrastructure/containment.ps1'))
if (-not (Test-Path -LiteralPath $script:AdaptersContainment -PathType Leaf)) {
    throw "adapters dependency not found: '$script:AdaptersContainment'"
}
. $script:AdaptersContainment

function Resolve-BatchAdapterRunDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Adapter,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    if (-not [System.IO.Path]::IsPathFullyQualified($RunDirectory)) {
        throw "$Adapter RunDirectory must be an existing absolute path: '$RunDirectory'"
    }
    $candidate = [System.IO.Path]::GetFullPath($RunDirectory)
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "$Adapter RunDirectory must be an existing absolute path: '$RunDirectory'"
    }

    try {
        return Resolve-ArtifactRunDirectory -RunDirectory $candidate `
            -RepositoryRoot $RepositoryRoot
    }
    catch {
        throw "$Adapter $($_.Exception.Message)"
    }
}

$hostFiles = @(
    'private/pester-address.ps1'
    'private/pester-discovery.ps1'
    'private/pester-dependency.ps1'
    'private/pytest-address.ps1'
    'private/pytest-discovery.ps1'
    'private/pytest-dependency.ps1'
    'private/gauntlet-address.ps1'
    'private/gauntlet-discovery.ps1'
    'private/gauntlet-dependency.ps1'
    'public/Get-GauntletBatchJob.ps1'
    'public/Get-PesterBatchJob.ps1'
    'public/Get-PytestBatchJob.ps1'
)
foreach ($relativePath in $hostFiles) {
    $path = Join-Path $script:AdaptersModuleRoot $relativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "adapters implementation file not found: '$path'"
    }
    . $path
}

Export-ModuleMember -Function 'Get-GauntletBatchJob', 'Get-PesterBatchJob', 'Get-PytestBatchJob'
