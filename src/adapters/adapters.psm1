#requires -Version 7.0

$script:AdaptersModuleRoot = $PSScriptRoot
$script:AdaptersDefaultRepositoryRoot = [System.IO.Path]::GetFullPath(
    (Join-Path $script:AdaptersModuleRoot '../..'))
$script:AdaptersExecutorManifest = [System.IO.Path]::GetFullPath(
    (Join-Path $script:AdaptersModuleRoot '../shared/batch-executor/batch-executor.psd1'))
$script:LatexBatchWorkerPath = [System.IO.Path]::GetFullPath(
    (Join-Path $script:AdaptersModuleRoot 'workers/invoke-latex-ingest.ps1'))

foreach ($dependency in @($script:AdaptersExecutorManifest, $script:LatexBatchWorkerPath)) {
    if (-not (Test-Path -LiteralPath $dependency -PathType Leaf)) {
        throw "adapters dependency not found: '$dependency'"
    }
}
Import-Module $script:AdaptersExecutorManifest -Scope Local -ErrorAction Stop

$hostFiles = @(
    'private/pester-address.ps1'
    'private/pester-discovery.ps1'
    'private/pester-dependency.ps1'
    'private/latex-address.ps1'
    'private/latex-inventory-row.ps1'
    'private/latex-dependency.ps1'
    'public/Get-LatexBatchJob.ps1'
    'public/Get-PesterBatchJob.ps1'
)
foreach ($relativePath in $hostFiles) {
    $path = Join-Path $script:AdaptersModuleRoot $relativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "adapters implementation file not found: '$path'"
    }
    . $path
}

Export-ModuleMember -Function 'Get-LatexBatchJob', 'Get-PesterBatchJob'
