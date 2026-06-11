param(
    [Parameter(Mandatory)][string]$InputJson,
    [string]$OutputPath,
    [string]$ProviderConfig,
    [string]$ProviderName,
    [string]$Model,
    [string]$PromptLibrary,
    [string]$PromptId = 'ir_repair_math',
    [double]$Temperature = 0.0,
    [int]$MaxTokens = 1024,
    [int]$ContextWindow = 1,
    [string]$PageSeparator,
    [string]$InventoryRefresh = 'always',
    [switch]$InventoryIncludeSha256,
    [string]$InventoryRoot,
    [switch]$UseEcho
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path "$scriptRoot\.."
$pythonExe = Join-Path $repoRoot '.venv\Scripts\python.exe'
$repairScript = Join-Path $repoRoot 'src\repair_math.py'
$defaultProviderConfig = Join-Path $repoRoot 'src\config\providers.yaml'
$defaultPromptLibrary = Join-Path $repoRoot 'src\config\prompt_library.jsonl'

if (-not (Test-Path $pythonExe)) {
    throw "Python executable not found: $pythonExe"
}
if (-not (Test-Path $repairScript)) {
    throw "Repair entrypoint not found: $repairScript"
}
if (-not $ProviderConfig) { $ProviderConfig = $defaultProviderConfig }
if (-not $PromptLibrary) { $PromptLibrary = $defaultPromptLibrary }
if (-not $OutputPath) {
    $baseName = [IO.Path]::GetFileNameWithoutExtension($InputJson)
    $OutputPath = Join-Path (Split-Path $InputJson -Parent) "$baseName-repaired.json"
}
if ($UseEcho) {
    $ProviderName = 'echo'
}

$cmd = @(
    $pythonExe,
    $repairScript,
    '--input-json', $InputJson,
    '--output-path', $OutputPath,
    '--provider-config', $ProviderConfig,
    '--prompt-library', $PromptLibrary,
    '--prompt-id', $PromptId,
    '--temperature', $Temperature,
    '--max-tokens', $MaxTokens,
    '--context-window', $ContextWindow
)

if ($ProviderName) {
    $cmd += @('--provider-name', $ProviderName)
}
if ($Model) {
    $cmd += @('--model', $Model)
}
if ($PageSeparator) {
    $cmd += @('--page-separator', $PageSeparator)
}
if ($InventoryRefresh) {
    $cmd += @('--inventory-refresh', $InventoryRefresh)
}
if ($InventoryIncludeSha256) {
    $cmd += '--inventory-include-sha256'
}
if ($InventoryRoot) {
    $cmd += @('--inventory-root', $InventoryRoot)
}

Write-Host "Running PDFDig math repair:" -ForegroundColor Cyan
Write-Host "  input:         $InputJson"
Write-Host "  output:        $OutputPath"
Write-Host "  provider config: $ProviderConfig"
Write-Host "  prompt library:  $PromptLibrary"
Write-Host "  prompt id:      $PromptId"
Write-Host "  provider name:  $ProviderName"
Write-Host "  model override: $Model"

& $cmd
