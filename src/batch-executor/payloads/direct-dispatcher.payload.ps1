param($Item, $Context, [System.Threading.CancellationToken] $CancellationToken)

$started = [datetime]::UtcNow
$failure = $null
$output = @()
$state = 'Succeeded'
$startedWork = $false
$stopReason = ''
$stopPhase = ''

if ($CancellationToken.IsCancellationRequested) {
    $state = 'Cancelled'
    $stopReason = 'CallerCancellation'
    $stopPhase = 'Dispatch'
}
else { try {
    $startedWork = $true
    if ($script:BatchExecutorRunspaceInitialized -ne $true) {
        $initializerOutput = @(Invoke-BatchRunspaceInitializer $Context)
        $script:BatchExecutorRunspaceState = if ($initializerOutput.Count -eq 0) { $null }
            elseif ($initializerOutput.Count -eq 1) { $initializerOutput[0] }
            else { $initializerOutput }
        $script:BatchExecutorRunspaceInitialized = $true
    }

    $output = @(Invoke-BatchWorkItem $Item $Context $script:BatchExecutorRunspaceState $CancellationToken)
    if ($CancellationToken.IsCancellationRequested) {
        $state = 'Cancelled'
        $stopReason = 'CallerCancellation'
        $stopPhase = 'ChildWait'
    }
}
catch {
    if ($CancellationToken.IsCancellationRequested) {
        $state = 'Cancelled'
        $stopReason = 'CallerCancellation'
        $stopPhase = 'ChildWait'
    }
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
    Observation = [pscustomobject]@{
        Submitted = $true
        Started = $startedWork
        StopReason = $stopReason
        StopPhase = $stopPhase
    }
    Capture = [pscustomobject]@{
        StdOutComplete = $true
        StdErrComplete = $true
        Protocol = 'not-applicable'
        Truncated = $false
        StdOutLossy = $false
        StdErrLossy = $false
        StdOutBytes = 0L
        StdErrBytes = 0L
        ProtocolBytes = 0L
    }
}
