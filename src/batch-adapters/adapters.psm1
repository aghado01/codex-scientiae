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

    $artifactCandidate = [System.IO.Path]::Combine($RepositoryRoot, 'artifacts')
    if (-not (Test-Path -LiteralPath $artifactCandidate -PathType Container)) {
        throw "$Adapter repository artifacts root not found: '$artifactCandidate'"
    }
    $artifactRoot = (Resolve-Path -LiteralPath $artifactCandidate).Path
    $run = (Resolve-Path -LiteralPath $candidate).Path
    $relative = [System.IO.Path]::GetRelativePath($artifactRoot, $run)
    $parentPrefix = '..' + [System.IO.Path]::DirectorySeparatorChar
    if ($relative -eq '.' -or $relative -eq '..' -or
            [System.IO.Path]::IsPathFullyQualified($relative) -or
            $relative.StartsWith($parentPrefix, [System.StringComparison]::Ordinal)) {
        throw "$Adapter RunDirectory must be a descendant of RepositoryRoot/artifacts: '$RunDirectory'"
    }
    return $run
}

$hostFiles = @(
    'private/pester-address.ps1'
    'private/pester-discovery.ps1'
    'private/pester-dependency.ps1'
    'private/pytest-address.ps1'
    'private/pytest-discovery.ps1'
    'private/pytest-dependency.ps1'
    'private/texdig-address.ps1'
    'private/texdig-discovery.ps1'
    'private/texdig-dependency.ps1'
    'public/Get-PesterBatchJob.ps1'
    'public/Get-PytestBatchJob.ps1'
    'public/Get-TeXdigBatchJob.ps1'
)
foreach ($relativePath in $hostFiles) {
    $path = Join-Path $script:AdaptersModuleRoot $relativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "adapters implementation file not found: '$path'"
    }
    . $path
}

Export-ModuleMember -Function 'Get-PesterBatchJob', 'Get-PytestBatchJob', 'Get-TeXdigBatchJob'
