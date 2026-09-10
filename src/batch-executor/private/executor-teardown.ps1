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

    Import-BatchExecutorNative
    $deadline = $Lifecycle.Deadline
    if ($null -ne $deadline) { $deadline.StartCleanup() }
    $swCleanup = [System.Diagnostics.Stopwatch]::StartNew()
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

    Stop-BatchExecutorChildProcesses -Registry $Lifecycle.ChildProcessRegistry `
        -Reason $(if ($Lifecycle.CompletedNormally) {
                'final registry cleanup'
            }
            else { 'exceptional batch teardown' }) `
        -Diagnostics $Lifecycle.InfrastructureErrors `
        -Deadline $deadline
    Stop-BatchExecutorPipelines -Invocations $Lifecycle.Invocations -Deadline $deadline

    $pendingPipeline = $Lifecycle.PendingPipeline
    Stop-BatchExecutorPendingPipeline -Pipeline $pendingPipeline -Deadline $deadline
    foreach ($invocation in $Lifecycle.Invocations) {
        $pipeline = $invocation.Pipeline
        if ($null -ne $invocation.InputCollection) {
            try { $invocation.InputCollection.Dispose() } catch {}
            $invocation.InputCollection = $null
        }
        if ($null -ne $invocation.OutputCollection) {
            try { $invocation.OutputCollection.Dispose() } catch {}
            $invocation.OutputCollection = $null
        }
        if ($null -eq $pipeline) {
            $invocation.InvocationTask = $null
            $invocation.AsyncResult = $null
            continue
        }
        if ([object]::ReferenceEquals($pipeline, $pendingPipeline)) { continue }

        try {
            [void]$pipeline.Dispose()
            $invocation.Pipeline = $null
            $invocation.InvocationTask = $null
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
                    $invocation.InvocationTask = $null
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

    foreach ($entry in $Lifecycle.ChildProcessRegistry.ToArray()) {
        $owned = $entry.Value
        $exited = $false
        try {
            if ($owned -is [CodexScientiae.BatchExecutor.Native.ContainedProcess]) {
                $exited = $owned.ConfirmedRelease
            }
            elseif ($owned -is [System.Diagnostics.Process]) {
                $exited = $owned.HasExited
            }
        }
        catch { $exited = $false }
        if ($exited) {
            [object] $removed = $null
            [void]$Lifecycle.ChildProcessRegistry.TryRemove($entry.Key, [ref]$removed)
            try { $owned.Dispose() } catch {}
        }
    }
    if ($Lifecycle.ChildProcessRegistry.Count -gt 0) {
        $cleanupSucceeded = $false
        $Lifecycle.InfrastructureErrors.Add(
            "batch executor teardown retained $($Lifecycle.ChildProcessRegistry.Count) child process record(s)")
    }

    $Lifecycle.Timing['CleanupMs'] = $swCleanup.ElapsedMilliseconds
    $Lifecycle.TeardownCompleted = $cleanupSucceeded
    if ($cleanupSucceeded) {
        $Lifecycle.Cleanup = New-BatchExecutorCleanupRecord -State Confirmed
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
            $Lifecycle.Cleanup = New-BatchExecutorCleanupRecord -State Incomplete `
                -Reason $Lifecycle.InfrastructureErrors[-1]
        }
    }
    else {
        $reason = if ($Lifecycle.InfrastructureErrors.Count -gt 0) {
            $Lifecycle.InfrastructureErrors[-1]
        }
        else { 'cleanup was not confirmed' }
        $Lifecycle.Cleanup = New-BatchExecutorCleanupRecord -State Incomplete -Reason $reason
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

    $closed = $Lifecycle.Phase -eq 'Closed' -and $Lifecycle.TeardownCompleted
    $incomplete = $Lifecycle.Phase -eq 'TearingDown' -and $Lifecycle.CompletedNormally
    if (-not $closed -and -not $incomplete) {
        throw 'batch executor execution record requires a closed lifecycle'
    }

    $results = $Lifecycle.Results
    $succeeded = @($results | Where-Object State -EQ 'Succeeded').Count
    $failed = @($results | Where-Object State -EQ 'Failed').Count
    $timedOut = @($results | Where-Object State -EQ 'TimedOut').Count
    $cancelled = @($results | Where-Object State -EQ 'Cancelled').Count
    $preparation = $Lifecycle.Preparation
    $cleanup = if ($null -ne $Lifecycle.Cleanup) { $Lifecycle.Cleanup }
        else { New-BatchExecutorCleanupRecord -State Confirmed }
    $runtime = if ($null -ne $preparation.Runtime) { $preparation.Runtime }
        else { $null }
    $errorList = [System.Collections.Generic.List[string]]::new()
    $warningList = [System.Collections.Generic.List[string]]::new()
    Add-BatchExecutorString -List $errorList -Value $Lifecycle.InfrastructureErrors
    Add-BatchExecutorString -List $warningList -Value $preparation.Budget.Warnings
    $errorArray = [string[]]$errorList.ToArray()
    $warningArray = [string[]]$warningList.ToArray()

    $properties = [ordered]@{
        Results = $results
        Errors = $errorArray
        Warnings = $warningArray
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
        Cleanup = $cleanup
        Runtime = $runtime
    }
    return (New-BatchExecutorPropertyRecord -Property $properties)
}
