function Wait-BatchExecutorInvocations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Lifecycle
    )

    if ($Lifecycle.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.LifecycleState') {
        throw 'batch executor await requires a lifecycle state record'
    }

    Import-BatchExecutorNative
    Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Awaiting
    $preparation = $Lifecycle.Preparation
    $invocations = $Lifecycle.Invocations
    $cancellationToken = $preparation.CancellationToken
    $waitSliceMilliseconds = $preparation.WaitSliceMilliseconds
    $deadline = $Lifecycle.Deadline
    if ($null -ne $deadline) { $deadline.StartWait() }

    $swWait = [System.Diagnostics.Stopwatch]::StartNew()
    $cancellationObserved = $cancellationToken.IsCancellationRequested
    $timeoutObserved = $false
    $timeoutScope = $null
    if (-not $cancellationObserved -and $invocations.Count -gt 0) {
        while ($true) {
            $incomplete = [System.Collections.Generic.List[object]]::new()
            foreach ($invocation in $invocations) {
                if ($null -ne $invocation.AsyncResult -and
                        -not $invocation.AsyncResult.IsCompleted) {
                    $incomplete.Add($invocation)
                }
            }
            if ($incomplete.Count -eq 0) { break }
            if ($cancellationToken.IsCancellationRequested) {
                $cancellationObserved = $true
                break
            }
            if ($null -ne $deadline -and $deadline.ExecutionExpired) {
                $timeoutObserved = $true
                $timeoutScope = 'Execution'
                break
            }
            if ($null -ne $deadline -and $deadline.WaitExpired) {
                $timeoutObserved = $true
                $timeoutScope = 'Wait'
                break
            }

            $slice = if ($null -ne $deadline) {
                $deadline.Slice([TimeSpan]::FromMilliseconds($waitSliceMilliseconds))
            }
            else { [TimeSpan]::FromMilliseconds($waitSliceMilliseconds) }
            $waitMs = [CodexScientiae.BatchExecutor.Native.HostAwareWait]::ToWaitMilliseconds($slice)
            # Sleep is the host checkpoint. Do not Wait() InvokeAsync tasks on this thread;
            # that can deadlock the caller with the pooled pipeline.
            if ($cancellationToken.CanBeCanceled) {
                if ($cancellationToken.WaitHandle.WaitOne($waitMs)) {
                    $cancellationObserved = $true
                    break
                }
            }
            elseif ($waitMs -gt 0) {
                Start-Sleep -Milliseconds $waitMs
            }
        }
    }

    if ($cancellationObserved -or $timeoutObserved) {
        if ($null -ne $deadline) { $deadline.StartCleanup() }
        $terminalOverride = if ($cancellationObserved) { 'Cancelled' } else { 'TimedOut' }
        foreach ($invocation in $invocations) {
            if ($null -ne $invocation.AsyncResult -and
                    -not $invocation.AsyncResult.IsCompleted) {
                Set-BatchExecutorInvocationTerminalOverride -Invocation $invocation `
                    -State $terminalOverride
            }
        }

        $reason = if ($cancellationObserved) { 'caller cancellation' }
            elseif ($timeoutScope -eq 'Execution') { 'executor execution timeout' }
            else { 'batch wait timeout' }
        Stop-BatchExecutorChildProcesses -Registry $Lifecycle.ChildProcessRegistry -Reason $reason `
            -Diagnostics $Lifecycle.InfrastructureErrors -Deadline $deadline

        Stop-BatchExecutorPipelines -Invocations @(
            $invocations | Where-Object { $_.PreparedItem.Mode -eq 'Runspace' }
        ) -Deadline $deadline
        if ($preparation.HasProcessItems) {
            $drain = [System.Diagnostics.Stopwatch]::StartNew()
            foreach ($invocation in $invocations) {
                if ($invocation.PreparedItem.Mode -ne 'Process' -or
                        $null -eq $invocation.AsyncResult -or
                        $invocation.AsyncResult.IsCompleted) { continue }
                while (-not $invocation.AsyncResult.IsCompleted) {
                    $remainingDrain = if ($null -ne $deadline) {
                        $deadline.CleanupSlice([TimeSpan]::FromMilliseconds(
                            $preparation.ProcessDrainMilliseconds))
                    }
                    else {
                        $left = $preparation.ProcessDrainMilliseconds - $drain.ElapsedMilliseconds
                        if ($left -le 0) { [TimeSpan]::Zero }
                        else { [TimeSpan]::FromMilliseconds($left) }
                    }
                    if ($remainingDrain -le [TimeSpan]::Zero) { break }
                    $drainSlice = if ($remainingDrain.TotalMilliseconds -gt $waitSliceMilliseconds) {
                        [TimeSpan]::FromMilliseconds($waitSliceMilliseconds)
                    }
                    else { $remainingDrain }
                    $drainMs = [CodexScientiae.BatchExecutor.Native.HostAwareWait]::ToWaitMilliseconds($drainSlice)
                    if ($invocation.AsyncResult.AsyncWaitHandle.WaitOne($drainMs)) { break }
                }
            }
        }

        Stop-BatchExecutorPipelines -Invocations $invocations -Deadline $deadline
    }

    $Lifecycle.Timing['WaitMs'] = $swWait.ElapsedMilliseconds
    $Lifecycle.WaitOutcome = if ($cancellationObserved) {
        New-BatchExecutorWaitOutcome -Kind CallerCancellation
    }
    elseif ($timeoutObserved -and $timeoutScope -eq 'Execution') {
        New-BatchExecutorWaitOutcome -Kind ExecutionTimeout
    }
    elseif ($timeoutObserved) { New-BatchExecutorWaitOutcome -Kind BatchTimeout }
    else { New-BatchExecutorWaitOutcome -Kind Completed }
    Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Awaited
}
