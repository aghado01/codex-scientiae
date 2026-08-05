#requires -Version 7.0

$script:BatchExecutorModuleRoot = $PSScriptRoot
$script:BatchExecutorPayloadRoot = Join-Path $script:BatchExecutorModuleRoot 'payloads'

$payloadDefinitions = @(
    [pscustomobject]@{
        Role = 'direct dispatcher'
        PathVariable = 'BatchExecutorDirectDispatcherPath'
        SourceVariable = 'BatchExecutorDirectDispatcher'
        Leaf = 'direct-dispatcher.payload.ps1'
        RequiresParamBlock = $true
    }
    [pscustomobject]@{
        Role = 'process dispatcher'
        PathVariable = 'BatchExecutorProcessDispatcherPath'
        SourceVariable = 'BatchExecutorProcessDispatcher'
        Leaf = 'process-dispatcher.payload.ps1'
        RequiresParamBlock = $true
    }
    [pscustomobject]@{
        Role = 'child bootstrap'
        PathVariable = 'BatchExecutorChildBootstrapPath'
        SourceVariable = 'BatchExecutorChildCommand'
        Leaf = 'child-bootstrap.payload.ps1'
        RequiresParamBlock = $false
    }
    [pscustomobject]@{
        Role = 'generic job worker'
        PathVariable = 'BatchExecutorJobWorkerPath'
        SourceVariable = 'BatchExecutorJobWorker'
        Leaf = 'batch-job-worker.ps1'
        RequiresParamBlock = $true
    }
)

foreach ($payload in $payloadDefinitions) {
    $path = Join-Path $script:BatchExecutorPayloadRoot $payload.Leaf
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "batch executor $($payload.Role) payload not found: '$path'"
    }
    $resolvedPath = (Resolve-Path -LiteralPath $path).Path
    $tokens = $null
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $resolvedPath, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors.Count -gt 0) {
        throw "batch executor $($payload.Role) payload does not parse at '$resolvedPath': $($parseErrors[0].Message)"
    }
    if ($payload.RequiresParamBlock -and $null -eq $ast.ParamBlock) {
        throw "batch executor $($payload.Role) payload must begin with a top-level param(...) block: '$resolvedPath'"
    }
    Set-Variable -Scope Script -Name $payload.PathVariable -Value $resolvedPath
    Set-Variable -Scope Script -Name $payload.SourceVariable `
        -Value ([System.IO.File]::ReadAllText($resolvedPath))
}

$hostFiles = @(
    'private/script-definition.ps1'
    'private/worker-budget.ps1'
    'private/property-access.ps1'
    'private/execution-state.ps1'
    'private/session-state.ps1'
    'private/executor-preparation.ps1'
    'private/executor-dispatch.ps1'
    'private/process-lifecycle.ps1'
    'private/plan-resolution.ps1'
    'public/New-BatchJob.ps1'
    'public/New-BatchPlan.ps1'
    'public/Invoke-BatchExecutor.ps1'
    'public/Invoke-BatchPlan.ps1'
)
foreach ($relativePath in $hostFiles) {
    $path = Join-Path $script:BatchExecutorModuleRoot $relativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "batch executor host implementation file not found: '$path'"
    }
    . $path
}

Export-ModuleMember -Function @(
    'New-BatchJob'
    'New-BatchPlan'
    'Invoke-BatchPlan'
    'Invoke-BatchExecutor'
)
