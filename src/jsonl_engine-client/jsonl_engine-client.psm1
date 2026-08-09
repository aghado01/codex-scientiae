#requires -Version 7.0

Set-StrictMode -Version Latest

$script:JsonlEngineProtocol = 'codex-scientiae/jsonl-engine-cli'
$script:JsonlEngineProtocolVersion = 1
$script:JsonlEngineClientRoot = $PSScriptRoot
$script:JsonlEngineRepositoryRoot = [System.IO.Path]::GetFullPath(
    (Join-Path $PSScriptRoot '../..'))
$script:JsonlEngineUtf8 = [System.Text.UTF8Encoding]::new($false, $true)

$privateFiles = @(
    'private/runtime.ps1'
    'private/protocol.ps1'
    'private/process.ps1'
)
$publicFiles = @(
    'public/Invoke-JsonlEngineCommand.ps1'
    'public/New-JsonlEngineInputFile.ps1'
    'public/store-commands.ps1'
)

foreach ($relativePath in @($privateFiles + $publicFiles)) {
    $sourcePath = Join-Path $PSScriptRoot $relativePath
    if (-not [System.IO.File]::Exists($sourcePath)) {
        throw "jsonl_engine-client source file not found: '$sourcePath'"
    }
    . $sourcePath
}

Export-ModuleMember -Function @(
    'Invoke-JsonlEngineCommand'
    'New-JsonlEngineInputFile'
    'Get-JsonlEngineCapability'
    'Get-JsonlInfo'
    'Get-JsonlCount'
    'Get-JsonlHead'
    'Get-JsonlTail'
    'Get-JsonlRange'
    'Get-JsonlRecord'
    'Select-JsonlPath'
    'Find-JsonlRecord'
    'Test-JsonlStore'
    'Get-JsonlSignature'
    'New-JsonlSnapshot'
    'Get-JsonlSchema'
    'Read-JsonDocument'
)
