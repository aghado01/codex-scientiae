param($Item, $Context, $RunspaceState, $CancellationToken)

# This is the plan executor's generic adapter. It is intentionally free of #Requires because its
# body is registered as a function in direct runspaces; dependencies belong to the compiled plan.
if ($CancellationToken -and $CancellationToken.IsCancellationRequested) {
    throw [System.OperationCanceledException]::new('batch job cancelled before entrypoint invocation')
}

foreach ($module in @($Item.ModulePath)) {
    if (-not [string]::IsNullOrWhiteSpace([string]$module)) {
        Import-Module -Name ([string]$module) -ErrorAction Stop
    }
}

$jobState = $null
if ($Item.InitializationScriptPath) {
    $initializationOutput = @(& ([string]$Item.InitializationScriptPath) `
        $Item $Context $RunspaceState $CancellationToken)
    $jobState = if ($initializationOutput.Count -eq 0) { $null }
        elseif ($initializationOutput.Count -eq 1) { $initializationOutput[0] }
        else { $initializationOutput }
}

if ($CancellationToken -and $CancellationToken.IsCancellationRequested) {
    throw [System.OperationCanceledException]::new('batch job cancelled after initialization')
}

# These variables intentionally remain in scope for entrypoints that dot-source helpers or inspect
# their caller. Ordinary entrypoints should use their declared named or positional arguments.
$BatchContext = $Context
$BatchRunspaceState = $RunspaceState
$BatchJobState = $jobState
$entryPoint = [string]$Item.EntryPoint
$workingDirectory = [string]$Item.WorkingDirectory
$locationPushed = $false

try {
    if (-not [string]::IsNullOrWhiteSpace($workingDirectory)) {
        Push-Location -LiteralPath $workingDirectory
        $locationPushed = $true
    }

    switch ([string]$Item.ArgumentMode) {
        'Named' {
            $named = @{}
            if ($null -ne $Item.Parameters) {
                foreach ($key in @($Item.Parameters.Keys)) { $named[[string]$key] = $Item.Parameters[$key] }
            }
            & $entryPoint @named
        }
        'Positional' {
            $positional = [object[]]@($Item.ArgumentList)
            & $entryPoint @positional
        }
        default { & $entryPoint }
    }
}
finally {
    if ($locationPushed) { Pop-Location }
}
