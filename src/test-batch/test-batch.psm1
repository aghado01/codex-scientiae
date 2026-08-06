#requires -Version 7.0

$script:TestBatchModuleRoot = $PSScriptRoot
$script:TestBatchDefaultRepositoryRoot = [System.IO.Path]::GetFullPath(
    (Join-Path $script:TestBatchModuleRoot '../..'))
$script:TestBatchExecutorManifest = [System.IO.Path]::GetFullPath(
    (Join-Path $script:TestBatchModuleRoot '../shared/batch-executor/batch-executor.psd1'))

if (-not (Test-Path -LiteralPath $script:TestBatchExecutorManifest -PathType Leaf)) {
    throw "test-batch dependency not found: '$script:TestBatchExecutorManifest'"
}
Import-Module $script:TestBatchExecutorManifest -Scope Local -ErrorAction Stop

$hostFiles = @(
    'private/test-address.ps1'
    'private/test-discovery.ps1'
    'private/pester-dependency.ps1'
    'public/Get-TestBatchJob.ps1'
)
foreach ($relativePath in $hostFiles) {
    $path = Join-Path $script:TestBatchModuleRoot $relativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "test-batch implementation file not found: '$path'"
    }
    . $path
}

Export-ModuleMember -Function 'Get-TestBatchJob'
