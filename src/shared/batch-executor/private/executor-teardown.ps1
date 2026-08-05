function Stop-BatchExecutorLifecycle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Lifecycle
    )

    if ($Lifecycle.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.LifecycleState') {
        throw 'batch executor teardown requires a lifecycle state record'
    }
    if ($Lifecycle.Phase -eq 'Closed') { return }

    $cleanupSucceeded = $true
    try {
        if ($Lifecycle.Phase -ne 'TearingDown') {
            Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase TearingDown
        }
    }
    catch {
        $cleanupSucceeded = $false
        $Lifecycle.InfrastructureErrors.Add(
            "could not enter teardown phase: $($_.Exception.Message)")
    }

    # This path also runs when Ctrl+C or an infrastructure exception unwinds the exported function.
    # Kill children first, then stop their supervising pipelines, then close the shared pool.
    Stop-BatchExecutorChildProcesses -Registry $Lifecycle.ChildProcessRegistry `
        -Reason $(if ($Lifecycle.CompletedNormally) {
                'final registry cleanup'
            }
            else { 'exceptional batch teardown' }) `
        -Diagnostics $Lifecycle.InfrastructureErrors
    Stop-BatchExecutorPipelines -Invocations $Lifecycle.Invocations

    $pendingPipeline = $Lifecycle.PendingPipeline
    Stop-BatchExecutorPendingPipeline -Pipeline $pendingPipeline
    foreach ($invocation in $Lifecycle.Invocations) {
        $pipeline = $invocation.Pipeline
        if ($null -eq $pipeline) {
            $invocation.AsyncResult = $null
            continue
        }
        if ([object]::ReferenceEquals($pipeline, $pendingPipeline)) { continue }

        try {
            [void]$pipeline.Dispose()
            $invocation.Pipeline = $null
            $invocation.AsyncResult = $null
        }
        catch {
            $cleanupSucceeded = $false
            $Lifecycle.InfrastructureErrors.Add(
                "could not dispose pipeline for item '$($invocation.PreparedItem.Id)': $($_.Exception.Message)")
        }
    }
    if ($null -ne $pendingPipeline) {
        try {
            [void]$pendingPipeline.Dispose()
            $Lifecycle.PendingPipeline = $null
            foreach ($invocation in $Lifecycle.Invocations) {
                if ([object]::ReferenceEquals($invocation.Pipeline, $pendingPipeline)) {
                    $invocation.Pipeline = $null
                    $invocation.AsyncResult = $null
                }
            }
        }
        catch {
            $cleanupSucceeded = $false
            $Lifecycle.InfrastructureErrors.Add(
                "could not dispose pending pipeline: $($_.Exception.Message)")
        }
    }
    else { $Lifecycle.PendingPipeline = $null }

    if ($null -ne $Lifecycle.Pool) {
        $pool = $Lifecycle.Pool
        try { [void]$pool.Close() }
        catch {
            $Lifecycle.InfrastructureErrors.Add(
                "could not close runspace pool: $($_.Exception.Message)")
        }
        try {
            [void]$pool.Dispose()
            $Lifecycle.Pool = $null
        }
        catch {
            $cleanupSucceeded = $false
            $Lifecycle.InfrastructureErrors.Add(
                "could not dispose runspace pool: $($_.Exception.Message)")
        }
    }
    else { $Lifecycle.Pool = $null }

    if ($Lifecycle.ChildProcessRegistry.Count -gt 0) {
        $cleanupSucceeded = $false
        $Lifecycle.InfrastructureErrors.Add(
            "batch executor teardown retained $($Lifecycle.ChildProcessRegistry.Count) child process record(s)")
    }

    $Lifecycle.TeardownCompleted = $cleanupSucceeded
    if ($cleanupSucceeded) {
        try {
            if ($Lifecycle.Phase -eq 'TearingDown') {
                Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Closed
            }
        }
        catch {
            $cleanupSucceeded = $false
            $Lifecycle.TeardownCompleted = $false
            $Lifecycle.InfrastructureErrors.Add(
                "could not close teardown phase: $($_.Exception.Message)")
        }
    }

    # On a normal execution there is no earlier exception to preserve, so incomplete release is fatal.
    # During exceptional/host-stop unwind, retain the original failure and its teardown diagnostics.
    if (-not $cleanupSucceeded -and $Lifecycle.CompletedNormally) {
        throw "batch executor teardown incomplete: $($Lifecycle.InfrastructureErrors[-1])"
    }
}

function New-BatchExecutorExecutionRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Lifecycle
    )

    if ($Lifecycle.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.LifecycleState') {
        throw 'batch executor execution-record projection requires a lifecycle state record'
    }
    if ($Lifecycle.Phase -ne 'Closed' -or -not $Lifecycle.TeardownCompleted) {
        throw 'batch executor execution record requires a closed lifecycle'
    }

    $results = $Lifecycle.Results
    $succeeded = @($results | Where-Object State -EQ 'Succeeded').Count
    $failed = @($results | Where-Object State -EQ 'Failed').Count
    $timedOut = @($results | Where-Object State -EQ 'TimedOut').Count
    $cancelled = @($results | Where-Object State -EQ 'Cancelled').Count
    $preparation = $Lifecycle.Preparation

    return [pscustomobject]@{
        Results = $results
        Errors = $Lifecycle.InfrastructureErrors.ToArray()
        Warnings = @($preparation.Budget.Warnings)
        Budget = $preparation.Budget
        Policy = $preparation.Policy
        Timing = [pscustomobject]$Lifecycle.Timing
        Summary = [pscustomobject]@{
            Total = $preparation.ItemCount
            Succeeded = $succeeded
            Failed = $failed
            TimedOut = $timedOut
            Cancelled = $cancelled
        }
    }
}
