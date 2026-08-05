function Invoke-BatchExecutor {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [AllowEmptyCollection()] [object[]] $InputObject,
        [Parameter(Mandatory)] [string] $ScriptPath,
        [ValidateSet('Runspace', 'Process', 'Mixed')] [string] $ExecutionMode = 'Runspace',
        [string] $ExecutionModeProperty = 'ExecutionMode',
        [string] $ProcessSpecProperty = 'ProcessSpec',
        [object] $Context = $null,
        [string] $InitializationScriptPath,
        [string[]] $ModulePath = @(),
        [ValidateSet('Bare', 'Core', 'Full')] [string] $IssPreset = 'Core',
        [nullable[int]] $MaxWorkers = $null,
        [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
        [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1,
        [string] $IdProperty = 'Id',
        [ValidateRange(1, 100)] [int] $SerializationDepth = 12,
        [ValidateRange(0, [int]::MaxValue)] [int] $ProcessTimeoutSeconds = 0,
        [ValidateRange(0, [int]::MaxValue)] [int] $WaitTimeoutSeconds = 0,
        [System.Threading.CancellationToken] $CancellationToken = [System.Threading.CancellationToken]::None,
        [ValidateSet('SharedReadOnly', 'PerItemCopy')] [string] $RunspaceDataPolicy = 'SharedReadOnly',
        [string] $PowerShellPath,
        [string] $WorkingDirectory = (Get-Location).Path,
        [System.Collections.IDictionary] $ProcessEnvironment = @{},
        [bool] $CreateNoWindow = $true,
        [ValidateSet('Hidden', 'Normal', 'Minimized', 'Maximized')] [string] $WindowStyle = 'Hidden',
        [switch] $LoadProfile,
        [ValidateSet('Idle', 'BelowNormal', 'Normal', 'AboveNormal', 'High')] [string] $PriorityClass = 'Normal'
    )

    $swTotal = [System.Diagnostics.Stopwatch]::StartNew()
    $preparation = Resolve-BatchExecutorPreparation -InputObject $InputObject `
        -ScriptPath $ScriptPath -ExecutionMode $ExecutionMode `
        -ExecutionModeProperty $ExecutionModeProperty -ProcessSpecProperty $ProcessSpecProperty `
        -Context $Context -InitializationScriptPath $InitializationScriptPath `
        -ModulePath $ModulePath -IssPreset $IssPreset -MaxWorkers $MaxWorkers `
        -ReservedCores $ReservedCores -MinItemsPerWorker $MinItemsPerWorker `
        -IdProperty $IdProperty -SerializationDepth $SerializationDepth `
        -ProcessTimeoutSeconds $ProcessTimeoutSeconds -WaitTimeoutSeconds $WaitTimeoutSeconds `
        -CancellationToken $CancellationToken -RunspaceDataPolicy $RunspaceDataPolicy `
        -PowerShellPath $PowerShellPath -WorkingDirectory $WorkingDirectory `
        -ProcessEnvironment $ProcessEnvironment -CreateNoWindow $CreateNoWindow `
        -WindowStyle $WindowStyle -LoadProfile:$LoadProfile -PriorityClass $PriorityClass

    $count = $preparation.ItemCount
    $hasProcessJobs = $preparation.HasProcessItems
    $budget = $preparation.Budget
    $policy = $preparation.Policy

    if ($count -eq 0) {
        return [pscustomobject]@{
            Results = [object[]]::new(0); Errors = @(); Warnings = @($budget.Warnings)
            Budget = $budget; Timing = [pscustomobject]@{ TotalMs = $swTotal.ElapsedMilliseconds }
            Policy = $policy
            Summary = [pscustomobject]@{ Total = 0; Succeeded = 0; Failed = 0; TimedOut = 0; Cancelled = 0 }
        }
    }

    $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
    # These are borrowed references for the still-inline phases. LifecycleState remains their sole owner.
    $invocations = $lifecycle.Invocations
    $ordered = $lifecycle.Results
    $infrastructureErrors = $lifecycle.InfrastructureErrors
    $processRegistry = $lifecycle.ChildProcessRegistry
    $timing = $lifecycle.Timing

    try {
        Start-BatchExecutorInvocations -Lifecycle $lifecycle
        Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Awaiting

        $swWait = [System.Diagnostics.Stopwatch]::StartNew()
        $cancellationObserved = $CancellationToken.IsCancellationRequested
        $timeoutObserved = $false
        if (-not $cancellationObserved) { foreach ($invocation in $invocations) {
            if ($invocation.AsyncResult.IsCompleted) { continue }
            # Never park the hosting PowerShell pipeline in an indefinite CLR wait. Short slices give
            # Ctrl+C / PowerShell.Stop() regular interpreter checkpoints so the outer finally block can
            # kill registered process trees immediately instead of waiting for child completion.
            while (-not $invocation.AsyncResult.IsCompleted) {
                if ($CancellationToken.IsCancellationRequested) {
                    $cancellationObserved = $true
                    break
                }
                $remaining = if ($WaitTimeoutSeconds -gt 0) {
                    ([int64]$WaitTimeoutSeconds * 1000) - $swWait.ElapsedMilliseconds
                }
                else { [int64]-1 }
                if ($WaitTimeoutSeconds -gt 0 -and $remaining -le 0) {
                    $timeoutObserved = $true
                    break
                }
                $waitSlice = if ($remaining -ge 0) {
                    [int][math]::Min(200, [math]::Max(1, $remaining))
                }
                else { 200 }

                if ($CancellationToken.CanBeCanceled) {
                    $handles = [System.Threading.WaitHandle[]]@(
                        $invocation.AsyncResult.AsyncWaitHandle,
                        $CancellationToken.WaitHandle)
                    $waitResult = [System.Threading.WaitHandle]::WaitAny($handles, $waitSlice)
                    if ($waitResult -eq 0) { break }
                    if ($waitResult -eq 1) { $cancellationObserved = $true; break }
                }
                elseif ($invocation.AsyncResult.AsyncWaitHandle.WaitOne($waitSlice)) { break }
            }
            if ($cancellationObserved -or $timeoutObserved) { break }
        } }

        if ($cancellationObserved -or $timeoutObserved) {
            foreach ($invocation in $invocations) {
                if (-not $invocation.AsyncResult.IsCompleted) {
                    $terminalOverride = if ($cancellationObserved) { 'Cancelled' } else { 'TimedOut' }
                    Set-BatchExecutorInvocationTerminalOverride -Invocation $invocation `
                        -State $terminalOverride
                }
            }

            $reason = if ($cancellationObserved) { 'caller cancellation' } else { 'batch wait timeout' }
            Stop-BatchExecutorChildProcesses -Registry $processRegistry -Reason $reason `
                -Diagnostics $infrastructureErrors

            # Direct pipelines have no diagnostic transport to drain once cancellation is observed.
            # Stop them immediately; process supervisors get a short opportunity to publish the
            # child envelope produced after their registered process tree was terminated.
            Stop-BatchExecutorPipelines -Invocations @(
                $invocations | Where-Object { $_.PreparedItem.Mode -eq 'Runspace' }
            )
            if ($hasProcessJobs) {
                # Killed children and token-aware queued dispatchers normally unwind with useful
                # envelopes. Give the outer runspaces one bounded grace period to publish them.
                $drain = [System.Diagnostics.Stopwatch]::StartNew()
                foreach ($invocation in $invocations) {
                    if ($invocation.PreparedItem.Mode -ne 'Process' -or
                            $invocation.AsyncResult.IsCompleted) { continue }
                    $remainingDrain = [math]::Max(
                        0, $preparation.ProcessDrainMilliseconds - $drain.ElapsedMilliseconds)
                    if ($remainingDrain -gt 0) {
                        [void]$invocation.AsyncResult.AsyncWaitHandle.WaitOne([int]$remainingDrain)
                    }
                }
            }

            Stop-BatchExecutorPipelines -Invocations $invocations
        }
        $timing.WaitMs = $swWait.ElapsedMilliseconds
        $lifecycle.WaitOutcome = if ($cancellationObserved) {
            New-BatchExecutorWaitOutcome -Kind CallerCancellation
        }
        elseif ($timeoutObserved) { New-BatchExecutorWaitOutcome -Kind BatchTimeout }
        else { New-BatchExecutorWaitOutcome -Kind Completed }
        Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Awaited

        Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Collecting
        $swCollect = [System.Diagnostics.Stopwatch]::StartNew()
        foreach ($invocation in $invocations) {
            $preparedItem = $invocation.PreparedItem
            $ps = $invocation.Pipeline
            $pipelineOutput = @()
            try {
                if ($invocation.TerminalOverride -eq 'TimedOut' -and
                        -not $invocation.AsyncResult.IsCompleted) {
                    try { $ps.Stop() } catch {}
                }
                if ($invocation.AsyncResult.IsCompleted) {
                    $pipelineOutput = @($ps.EndInvoke($invocation.AsyncResult))
                }
            }
            catch {
                if ($null -eq $invocation.TerminalOverride) {
                    $infrastructureErrors.Add(
                        "item '$($preparedItem.Id)' collection failed: $($_.Exception.Message)")
                }
            }

            # EndInvoke output is already adapted/unwrapped when materialized through @(...).
            $envelope = if ($pipelineOutput.Count -gt 0) { $pipelineOutput[-1] } else { $null }
            $errors = [System.Collections.Generic.List[string]]::new()
            $warnings = [System.Collections.Generic.List[string]]::new()
            $information = [System.Collections.Generic.List[string]]::new()
            foreach ($record in @($ps.Streams.Error)) { $errors.Add($record.ToString()) }
            foreach ($record in @($ps.Streams.Warning)) { $warnings.Add($record.Message) }
            foreach ($record in @($ps.Streams.Information)) {
                $information.Add($(if ($null -ne $record.MessageData) { $record.MessageData.ToString() } else { $record.ToString() }))
            }
            if ($envelope -and $envelope.Failure) { $errors.Add([string]$envelope.Failure) }
            if ($envelope -and $envelope.PSObject.Properties['Errors']) {
                foreach ($record in @($envelope.Errors)) { if ($record) { $errors.Add([string]$record) } }
            }
            if ($envelope -and $envelope.PSObject.Properties['Warnings']) {
                foreach ($record in @($envelope.Warnings)) { if ($record) { $warnings.Add([string]$record) } }
            }
            if ($invocation.TerminalOverride -eq 'TimedOut') {
                $errors.Add("batch wait exceeded the total timeout of $WaitTimeoutSeconds second(s)")
            }
            if ($invocation.TerminalOverride -eq 'Cancelled') {
                $warnings.Add('caller cancellation requested')
            }

            $state = if ($invocation.TerminalOverride) { $invocation.TerminalOverride }
                     elseif ($envelope -and $envelope.PSObject.Properties['State']) { [string]$envelope.State }
                     elseif ($null -eq $envelope -or $errors.Count -gt 0) { 'Failed' }
                     else { 'Succeeded' }
            if ($state -eq 'Succeeded' -and $errors.Count -gt 0) { $state = 'Failed' }

            $startedUtc = if ($envelope) { $envelope.StartedUtc } else { $null }
            $endedUtc = if ($envelope) { $envelope.EndedUtc } else { [datetime]::UtcNow }
            $durationMs = if ($startedUtc -and $endedUtc) {
                [math]::Round((([datetime]$endedUtc) - ([datetime]$startedUtc)).TotalMilliseconds, 2)
            }
            else { $null }
            [object[]] $jobOutput = @()
            [string[]] $jobStdOut = @()
            [string[]] $jobStdErr = @()
            if ($envelope) { $jobOutput = [object[]]@($envelope.Output) }
            if ($envelope -and $envelope.PSObject.Properties['StdOut']) {
                $jobStdOut = [string[]]@($envelope.StdOut)
            }
            if ($envelope -and $envelope.PSObject.Properties['StdErr']) {
                $jobStdErr = [string[]]@($envelope.StdErr)
            }

            $ordered[$preparedItem.Index] = [pscustomobject]@{
                Id = $preparedItem.Id; Index = $preparedItem.Index; Input = $preparedItem.Input; State = $state
                Output = $jobOutput
                Errors = $errors.ToArray(); Warnings = $warnings.ToArray(); Information = $information.ToArray()
                QueuedUtc = $invocation.QueuedUtc; StartedUtc = $startedUtc; EndedUtc = $endedUtc; DurationMs = $durationMs
                RunspaceId = if ($envelope) { $envelope.RunspaceId } else { $null }
                ThreadId = if ($envelope) { $envelope.ThreadId } else { $null }
                ProcessId = if ($envelope) { $envelope.ProcessId } else { $null }
                ExitCode = if ($envelope -and $envelope.PSObject.Properties['ExitCode']) { $envelope.ExitCode } else { $null }
                StdOut = $jobStdOut
                StdErr = $jobStdErr
            }
            $ps.Dispose()
        }
        $timing.CollectMs = $swCollect.ElapsedMilliseconds
        Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Collected
        $lifecycle.CompletedNormally = $true
    }
    finally {
        # This path also runs when Ctrl+C or an infrastructure exception unwinds the function.
        # Kill children first, then stop their supervising pipelines; no child is left orphaned.
        try {
            if ($lifecycle.Phase -notin @('TearingDown', 'Closed')) {
                Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase TearingDown
            }
        }
        catch { $infrastructureErrors.Add("could not enter teardown phase: $($_.Exception.Message)") }
        Stop-BatchExecutorChildProcesses -Registry $processRegistry `
            -Reason $(if ($lifecycle.CompletedNormally) { 'final registry cleanup' } else { 'exceptional batch teardown' }) `
            -Diagnostics $infrastructureErrors
        Stop-BatchExecutorPipelines -Invocations $invocations
        $pendingPipeline = $lifecycle.PendingPipeline
        Stop-BatchExecutorPendingPipeline -Pipeline $pendingPipeline
        foreach ($invocation in $invocations) {
            if ($null -ne $invocation.Pipeline -and
                    -not [object]::ReferenceEquals($invocation.Pipeline, $pendingPipeline)) {
                try { $invocation.Pipeline.Dispose() } catch {}
            }
        }
        if ($null -ne $pendingPipeline) {
            try { $pendingPipeline.Dispose() } catch {}
            $lifecycle.PendingPipeline = $null
        }
        if ($null -ne $lifecycle.Pool) {
            try { $lifecycle.Pool.Close() } catch {}
            try { $lifecycle.Pool.Dispose() } catch {}
        }
        $lifecycle.TeardownCompleted = $true
        try {
            if ($lifecycle.Phase -eq 'TearingDown') {
                Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Closed
            }
        }
        catch { $infrastructureErrors.Add("could not close teardown phase: $($_.Exception.Message)") }
    }

    $swTotal.Stop()
    $timing.TotalMs = $swTotal.ElapsedMilliseconds
    $succeeded = @($ordered | Where-Object State -EQ 'Succeeded').Count
    $failed = @($ordered | Where-Object State -EQ 'Failed').Count
    $timedOut = @($ordered | Where-Object State -EQ 'TimedOut').Count
    $cancelled = @($ordered | Where-Object State -EQ 'Cancelled').Count

    [pscustomobject]@{
        Results = $ordered
        Errors = $infrastructureErrors.ToArray()
        Warnings = @($budget.Warnings)
        Budget = $budget
        Policy = $policy
        Timing = [pscustomobject]$timing
        Summary = [pscustomobject]@{
            Total = $count; Succeeded = $succeeded; Failed = $failed; TimedOut = $timedOut; Cancelled = $cancelled
        }
    }
}
