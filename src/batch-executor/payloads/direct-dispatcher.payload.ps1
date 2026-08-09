param($Item, $Context, [System.Threading.CancellationToken] $CancellationToken)

$started = [datetime]::UtcNow
$failure = $null
$output = @()
$state = 'Succeeded'

if ($CancellationToken.IsCancellationRequested) {
    $state = 'Cancelled'
}
else { try {
    if ($script:BatchExecutorRunspaceInitialized -ne $true) {
        $initializerOutput = @(Invoke-BatchRunspaceInitializer $Context)
        $script:BatchExecutorRunspaceState = if ($initializerOutput.Count -eq 0) { $null }
            elseif ($initializerOutput.Count -eq 1) { $initializerOutput[0] }
            else { $initializerOutput }
        $script:BatchExecutorRunspaceInitialized = $true
    }

    $output = @(Invoke-BatchWorkItem $Item $Context $script:BatchExecutorRunspaceState $CancellationToken)
    if ($CancellationToken.IsCancellationRequested) { $state = 'Cancelled' }
}
catch {
    if ($CancellationToken.IsCancellationRequested) { $state = 'Cancelled' }
    else { $failure = $_.ToString(); $state = 'Failed' }
} }

$ended = [datetime]::UtcNow
[pscustomobject]@{
    Output      = $output
    Failure     = $failure
    State       = $state
    StartedUtc  = $started
    EndedUtc    = $ended
    RunspaceId  = [System.Management.Automation.Runspaces.Runspace]::DefaultRunspace.InstanceId.ToString()
    ThreadId    = [System.Environment]::CurrentManagedThreadId
    ProcessId   = $PID
}
