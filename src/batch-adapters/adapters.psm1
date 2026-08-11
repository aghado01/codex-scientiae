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

$hostFiles = @(
    'private/pester-address.ps1'
    'private/pester-discovery.ps1'
    'private/pester-dependency.ps1'
    'private/pytest-address.ps1'
    'private/pytest-discovery.ps1'
    'private/pytest-dependency.ps1'
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

Export-ModuleMember -Function 'Get-PesterBatchJob', 'Get-PytestBatchJob'
