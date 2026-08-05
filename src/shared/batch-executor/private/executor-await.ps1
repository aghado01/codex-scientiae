function Wait-BatchExecutorInvocations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNull()] [object] $Lifecycle
    )

    if ($Lifecycle.PSObject.TypeNames -notcontains `
            'CodexScientiae.BatchExecutor.Internal.LifecycleState') {
        throw 'batch executor await requires a lifecycle state record'
    }

    Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Awaiting
    $preparation = $Lifecycle.Preparation
    $invocations = $Lifecycle.Invocations
    $cancellationToken = $preparation.CancellationToken
    $waitTimeoutSeconds = $preparation.WaitTimeoutSeconds
    $waitSliceMilliseconds = $preparation.WaitSliceMilliseconds

    $swWait = [System.Diagnostics.Stopwatch]::StartNew()
    $cancellationObserved = $cancellationToken.IsCancellationRequested
    $timeoutObserved = $false
    if (-not $cancellationObserved) {
        foreach ($invocation in $invocations) {
            if ($invocation.AsyncResult.IsCompleted) { continue }

            # Never park the hosting PowerShell pipeline in an indefinite CLR wait. Short slices give
            # Ctrl+C / PowerShell.Stop() regular interpreter checkpoints so the exported outer finally
            # block can kill registered process trees instead of waiting for child completion.
            while (-not $invocation.AsyncResult.IsCompleted) {
                if ($cancellationToken.IsCancellationRequested) {
                    $cancellationObserved = $true
                    break
                }
                $remaining = if ($waitTimeoutSeconds -gt 0) {
                    ([int64]$waitTimeoutSeconds * 1000) - $swWait.ElapsedMilliseconds
                }
                else { [int64]-1 }
                if ($waitTimeoutSeconds -gt 0 -and $remaining -le 0) {
                    $timeoutObserved = $true
                    break
                }
                $waitSlice = if ($remaining -ge 0) {
                    [int][math]::Min(
                        $waitSliceMilliseconds, [math]::Max(1, $remaining))
                }
                else { $waitSliceMilliseconds }

                if ($cancellationToken.CanBeCanceled) {
                    $handles = [System.Threading.WaitHandle[]]@(
                        $invocation.AsyncResult.AsyncWaitHandle,
                        $cancellationToken.WaitHandle)
                    $waitResult = [System.Threading.WaitHandle]::WaitAny($handles, $waitSlice)
                    if ($waitResult -eq 0) { break }
                    if ($waitResult -eq 1) { $cancellationObserved = $true; break }
                }
                elseif ($invocation.AsyncResult.AsyncWaitHandle.WaitOne($waitSlice)) { break }
            }
            if ($cancellationObserved -or $timeoutObserved) { break }
        }
    }

    if ($cancellationObserved -or $timeoutObserved) {
        $terminalOverride = if ($cancellationObserved) { 'Cancelled' } else { 'TimedOut' }
        foreach ($invocation in $invocations) {
            if (-not $invocation.AsyncResult.IsCompleted) {
                Set-BatchExecutorInvocationTerminalOverride -Invocation $invocation `
                    -State $terminalOverride
            }
        }

        $reason = if ($cancellationObserved) { 'caller cancellation' } else { 'batch wait timeout' }
        Stop-BatchExecutorChildProcesses -Registry $Lifecycle.ChildProcessRegistry -Reason $reason `
            -Diagnostics $Lifecycle.InfrastructureErrors

        # Direct pipelines have no diagnostic transport to drain once cancellation is observed.
        # Stop them immediately; process supervisors get a short opportunity to publish the child
        # envelope produced after their registered process tree was terminated.
        Stop-BatchExecutorPipelines -Invocations @(
            $invocations | Where-Object { $_.PreparedItem.Mode -eq 'Runspace' }
        )
        if ($preparation.HasProcessItems) {
            $drain = [System.Diagnostics.Stopwatch]::StartNew()
            foreach ($invocation in $invocations) {
                if ($invocation.PreparedItem.Mode -ne 'Process' -or
                        $invocation.AsyncResult.IsCompleted) { continue }
                while (-not $invocation.AsyncResult.IsCompleted) {
                    $remainingDrain = [math]::Max(
                        0, $preparation.ProcessDrainMilliseconds - $drain.ElapsedMilliseconds)
                    if ($remainingDrain -le 0) { break }
                    $drainSlice = [int][math]::Min(
                        $waitSliceMilliseconds, [math]::Max(1, $remainingDrain))
                    if ($invocation.AsyncResult.AsyncWaitHandle.WaitOne($drainSlice)) { break }
                }
            }
        }

        Stop-BatchExecutorPipelines -Invocations $invocations
    }

    $Lifecycle.Timing['WaitMs'] = $swWait.ElapsedMilliseconds
    $Lifecycle.WaitOutcome = if ($cancellationObserved) {
        New-BatchExecutorWaitOutcome -Kind CallerCancellation
    }
    elseif ($timeoutObserved) { New-BatchExecutorWaitOutcome -Kind BatchTimeout }
    else { New-BatchExecutorWaitOutcome -Kind Completed }
    Set-BatchExecutorLifecyclePhase -Lifecycle $Lifecycle -Phase Awaited
}
