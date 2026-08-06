#requires -Version 7.0

$script:IngestBatchModuleRoot = $PSScriptRoot
$script:IngestBatchDefaultRepositoryRoot = [System.IO.Path]::GetFullPath(
    (Join-Path $script:IngestBatchModuleRoot '../..'))
$script:IngestBatchExecutorManifest = [System.IO.Path]::GetFullPath(
    (Join-Path $script:IngestBatchModuleRoot '../shared/batch-executor/batch-executor.psd1'))
$script:IngestBatchWorkerPath = [System.IO.Path]::GetFullPath(
    (Join-Path $script:IngestBatchModuleRoot 'workers/invoke-latex-ingest.ps1'))

foreach ($dependency in @($script:IngestBatchExecutorManifest, $script:IngestBatchWorkerPath)) {
    if (-not (Test-Path -LiteralPath $dependency -PathType Leaf)) {
        throw "ingest-batch dependency not found: '$dependency'"
    }
}
Import-Module $script:IngestBatchExecutorManifest -Scope Local -ErrorAction Stop

$hostFiles = @(
    'private/ingest-address.ps1'
    'private/inventory-row.ps1'
    'private/ingest-dependency.ps1'
    'public/Get-IngestBatchJob.ps1'
)
foreach ($relativePath in $hostFiles) {
    $path = Join-Path $script:IngestBatchModuleRoot $relativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "ingest-batch implementation file not found: '$path'"
    }
    . $path
}

Export-ModuleMember -Function 'Get-IngestBatchJob'
