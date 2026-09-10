param(
    [string] $JobId,
    [string] $PayloadXml,
    [string] $PowerShellPath,
    [string] $WorkingDirectory,
    [string] $EncodedChildCommand,
    [int] $ProcessTimeoutSeconds,
    [bool] $CreateNoWindow,
    [string] $WindowStyle,
    [bool] $LoadProfile,
    [System.Collections.IDictionary] $ProcessEnvironment,
    [string] $PriorityClass,
    [System.Collections.Concurrent.ConcurrentDictionary[string, object]] $ProcessRegistry,
    [System.Threading.CancellationToken] $CancellationToken,
    [object] $Deadline,
    [object] $CaptureLimits
)

$started = [datetime]::UtcNow
$contained = $null
$control = $null
$failure = $null
$state = 'Failed'
$output = @()
$childErrors = @()
$childWarnings = @()
$stdoutLines = @()
$stderrLines = @()
$exitCode = $null
$childProcessId = $null
$registered = $false
$startedChild = $false
$stopReason = ''
$stopPhase = ''
$capture = $null
$processWatch = [System.Diagnostics.Stopwatch]::StartNew()

function Get-BatchProcessSlice {
    param($Deadline, [int] $ProcessTimeoutSeconds, $ProcessWatch, [TimeSpan] $Checkpoint)
    $processRemaining = if ($ProcessTimeoutSeconds -gt 0) {
        $left = [TimeSpan]::FromSeconds($ProcessTimeoutSeconds) - $ProcessWatch.Elapsed
        if ($left -lt [TimeSpan]::Zero) { [TimeSpan]::Zero } else { $left }
    }
    else { [System.Threading.Timeout]::InfiniteTimeSpan }
    if ($null -eq $Deadline) { return $processRemaining }
    return $Deadline.ProcessSlice($processRemaining, $Checkpoint)
}

if ($CancellationToken.IsCancellationRequested) {
    $state = 'Cancelled'
    $stopReason = 'CallerCancellation'
    $stopPhase = 'Dispatch'
    $childWarnings = @('cancellation requested before child process start')
}
elseif ($null -ne $Deadline -and $Deadline.ExecutionExpired) {
    $state = 'TimedOut'
    $stopReason = 'ExecutionTimeout'
    $stopPhase = 'Dispatch'
    $failure = 'executor execution timeout before child process start'
}
else { try {
    if ($CaptureLimits -isnot [CodexScientiae.BatchExecutor.Native.CaptureLimits]) {
        $CaptureLimits = [CodexScientiae.BatchExecutor.Native.CaptureLimits]::new()
    }

    $pipeName = 'cdxsci-be-' + [guid]::NewGuid().ToString('N')
    $control = [CodexScientiae.BatchExecutor.Native.ControlServer]::Create($pipeName, $CaptureLimits)

    $info = [CodexScientiae.BatchExecutor.Native.ContainedProcessStartInfo]::new()
    $info.FileName = $PowerShellPath
    $info.WorkingDirectory = $WorkingDirectory
    $info.CreateNoWindow = $CreateNoWindow
    $info.WindowStyle = $WindowStyle
    [void]$info.Arguments.Add('-NoLogo')
    if (-not $LoadProfile) { [void]$info.Arguments.Add('-NoProfile') }
    [void]$info.Arguments.Add('-NonInteractive')
    [void]$info.Arguments.Add('-EncodedCommand')
    [void]$info.Arguments.Add($EncodedChildCommand)
    foreach ($key in @($ProcessEnvironment.Keys)) {
        $info.Environment[[string]$key] = $(if ($null -eq $ProcessEnvironment[$key]) { $null }
            else { [string]$ProcessEnvironment[$key] })
    }
    $info.Environment['CDXSCI_BATCH_JOB_ID'] = $JobId
    $info.Environment['CDXSCI_BATCH_EXECUTION_MODE'] = 'Process'
    $info.Environment['CDXSCI_BATCH_CONTROL_PIPE'] = $pipeName
    $info.Environment['CDXSCI_BATCH_CONTROL_MAX_FRAME'] = [string]$CaptureLimits.MaxFrameBytes

    $contained = [CodexScientiae.BatchExecutor.Native.ContainedProcess]::Start($info)
    $startedChild = $true
    $childProcessId = $contained.Id
    $registered = $ProcessRegistry.TryAdd($JobId, $contained)
    if (-not $registered) {
        [void]$contained.Terminate([TimeSpan]::FromSeconds(2))
        throw "live child registry already contains job id '$JobId'"
    }

    if ($PriorityClass -ne 'Normal') {
        try { $contained.SetPriorityClass($PriorityClass) }
        catch { $childWarnings += "could not set child priority '$PriorityClass': $($_.Exception.Message)" }
    }

    if ($CancellationToken.IsCancellationRequested -or
            ($null -ne $Deadline -and $Deadline.ExecutionExpired)) {
        [void]$contained.Terminate($(if ($null -ne $Deadline) {
                    $Deadline.CleanupSlice([TimeSpan]::FromSeconds(2))
                }
                else { [TimeSpan]::FromSeconds(2) }))
        if ($CancellationToken.IsCancellationRequested) {
            $state = 'Cancelled'
            $stopReason = 'CallerCancellation'
            $stopPhase = 'ChildWait'
            $childWarnings += 'cancellation requested; child process tree terminated'
        }
        else {
            $state = 'TimedOut'
            $stopReason = 'ExecutionTimeout'
            $stopPhase = 'ChildWait'
            $failure = 'executor execution timeout after child process start'
        }
    }
    else {
        $connectCts = [System.Threading.CancellationTokenSource]::CreateLinkedTokenSource($CancellationToken)
        try {
            $connectSlice = Get-BatchProcessSlice -Deadline $Deadline `
                -ProcessTimeoutSeconds $ProcessTimeoutSeconds -ProcessWatch $processWatch `
                -Checkpoint ([TimeSpan]::FromSeconds(15))
            if ($connectSlice -eq [TimeSpan]::Zero) { throw 'no remaining budget to connect the control pipe' }
            if ($connectSlice -ne [System.Threading.Timeout]::InfiniteTimeSpan) {
                $connectCts.CancelAfter($connectSlice)
            }
            $connectTask = $control.WaitForConnectionAsync($connectCts.Token)
            $connectStatus = [CodexScientiae.BatchExecutor.Native.HostAwareWait]::Wait(
                [System.Threading.Tasks.Task[]]@($connectTask),
                $(if ($connectSlice -eq [System.Threading.Timeout]::InfiniteTimeSpan) {
                        [TimeSpan]::FromMilliseconds(200)
                    }
                    else { $connectSlice }),
                $connectCts.Token)
            if ($connectStatus.ToString() -ne 'AllCompleted') {
                throw 'control pipe connection did not complete within the remaining budget'
            }
            $null = $connectTask.GetAwaiter().GetResult()
        }
        finally { $connectCts.Dispose() }

        $payloadBytes = [System.Text.Encoding]::UTF8.GetBytes($PayloadXml)
        $stdinCts = [System.Threading.CancellationTokenSource]::CreateLinkedTokenSource($CancellationToken)
        try {
            $stdinSlice = Get-BatchProcessSlice -Deadline $Deadline `
                -ProcessTimeoutSeconds $ProcessTimeoutSeconds -ProcessWatch $processWatch `
                -Checkpoint ([TimeSpan]::FromSeconds(30))
            if ($stdinSlice -eq [TimeSpan]::Zero) { throw 'no remaining budget for child stdin transfer' }
            if ($stdinSlice -ne [System.Threading.Timeout]::InfiniteTimeSpan) {
                $stdinCts.CancelAfter($stdinSlice)
            }
            $writeTask = $contained.StandardInput.WriteAsync(
                $payloadBytes, 0, $payloadBytes.Length, $stdinCts.Token)
            $writeStatus = [CodexScientiae.BatchExecutor.Native.HostAwareWait]::Wait(
                [System.Threading.Tasks.Task[]]@($writeTask),
                $(if ($stdinSlice -eq [System.Threading.Timeout]::InfiniteTimeSpan) {
                        [TimeSpan]::FromMilliseconds(200)
                    }
                    else { $stdinSlice }),
                $stdinCts.Token)
            if ($writeStatus.ToString() -ne 'AllCompleted') {
                throw 'child stdin transfer did not complete within the remaining budget'
            }
            $null = $writeTask.GetAwaiter().GetResult()
            $contained.StandardInput.Close()
        }
        finally { $stdinCts.Dispose() }

        $stdoutCapture = [CodexScientiae.BatchExecutor.Native.BoundedCapture]::new($CaptureLimits.MaxStdOutBytes)
        $stderrCapture = [CodexScientiae.BatchExecutor.Native.BoundedCapture]::new($CaptureLimits.MaxStdErrBytes)
        $ioCts = [System.Threading.CancellationTokenSource]::CreateLinkedTokenSource($CancellationToken)
        try {
            $joinSlice = Get-BatchProcessSlice -Deadline $Deadline `
                -ProcessTimeoutSeconds $ProcessTimeoutSeconds -ProcessWatch $processWatch `
                -Checkpoint ([TimeSpan]::FromHours(24))
            if ($joinSlice -eq [TimeSpan]::Zero) {
                [void]$contained.Terminate([TimeSpan]::FromSeconds(2))
            }
            else {
                if ($joinSlice -ne [System.Threading.Timeout]::InfiniteTimeSpan) {
                    $ioCts.CancelAfter($joinSlice)
                }
                $stdoutTask = [CodexScientiae.BatchExecutor.Native.StreamPump]::PumpAsync(
                    $contained.StandardOutput, $stdoutCapture, $ioCts.Token)
                $stderrTask = [CodexScientiae.BatchExecutor.Native.StreamPump]::PumpAsync(
                    $contained.StandardError, $stderrCapture, $ioCts.Token)
                $protocolTask = $control.ReadToEndAsync($ioCts.Token)
                $waitTask = $contained.WaitForExitAsync($ioCts.Token)
                $checkpoint = [TimeSpan]::FromMilliseconds(200)
                while (-not $waitTask.IsCompleted) {
                    if ($CancellationToken.IsCancellationRequested) { break }
                    if ($null -ne $Deadline -and $Deadline.ExecutionExpired) { break }
                    if ($ProcessTimeoutSeconds -gt 0 -and
                            $processWatch.Elapsed.TotalSeconds -ge $ProcessTimeoutSeconds) { break }
                    $slice = Get-BatchProcessSlice -Deadline $Deadline `
                        -ProcessTimeoutSeconds $ProcessTimeoutSeconds -ProcessWatch $processWatch `
                        -Checkpoint $checkpoint
                    $status = [CodexScientiae.BatchExecutor.Native.HostAwareWait]::Wait(
                        [System.Threading.Tasks.Task[]]@($waitTask), $slice, $CancellationToken)
                    if ($status.ToString() -eq 'AllCompleted') { break }
                    if ($status.ToString() -eq 'Cancelled') { break }
                }
            }

            $timeoutObserved = $ProcessTimeoutSeconds -gt 0 -and
                $processWatch.Elapsed.TotalSeconds -ge $ProcessTimeoutSeconds -and
                -not $contained.HasExited
            $executionExpired = $null -ne $Deadline -and $Deadline.ExecutionExpired -and
                -not $contained.HasExited
            if ($CancellationToken.IsCancellationRequested -and -not $contained.HasExited) {
                $stopWait = if ($null -ne $Deadline) {
                    $Deadline.CleanupSlice([TimeSpan]::FromSeconds(5))
                }
                else { [TimeSpan]::FromSeconds(5) }
                [void]$contained.Terminate($stopWait)
                $state = 'Cancelled'
                $stopReason = 'CallerCancellation'
                $stopPhase = 'ChildWait'
                $childWarnings += 'cancellation requested; child process tree terminated'
            }
            elseif ($executionExpired) {
                $stopWait = if ($null -ne $Deadline) {
                    $Deadline.CleanupSlice([TimeSpan]::FromSeconds(5))
                }
                else { [TimeSpan]::FromSeconds(5) }
                [void]$contained.Terminate($stopWait)
                $state = 'TimedOut'
                $stopReason = 'ExecutionTimeout'
                $stopPhase = 'ChildWait'
                $failure = 'child process exceeded the executor execution timeout'
            }
            elseif ($timeoutObserved) {
                $stopWait = if ($null -ne $Deadline) {
                    $Deadline.CleanupSlice([TimeSpan]::FromSeconds(5))
                }
                else { [TimeSpan]::FromSeconds(5) }
                [void]$contained.Terminate($stopWait)
                $state = 'TimedOut'
                $stopReason = 'ProcessTimeout'
                $stopPhase = 'ChildWait'
                $failure = "child process exceeded timeout of $ProcessTimeoutSeconds second(s)"
            }

            $drainToken = [System.Threading.CancellationToken]::None
            $drainCts = $null
            try {
                if ($null -ne $Deadline) {
                    $drainSlice = $Deadline.CleanupSlice([TimeSpan]::FromSeconds(5))
                    if ($drainSlice -ne [System.Threading.Timeout]::InfiniteTimeSpan) {
                        $drainCts = [System.Threading.CancellationTokenSource]::new()
                        if ($drainSlice -gt [TimeSpan]::Zero) { $drainCts.CancelAfter($drainSlice) }
                        $drainToken = $drainCts.Token
                    }
                }
                $drainTasks = [System.Collections.Generic.List[System.Threading.Tasks.Task]]::new()
                if ($null -ne $stdoutTask) { $drainTasks.Add($stdoutTask) }
                if ($null -ne $stderrTask) { $drainTasks.Add($stderrTask) }
                if ($null -ne $protocolTask) { $drainTasks.Add($protocolTask) }
                if ($drainTasks.Count -gt 0) {
                    [void][CodexScientiae.BatchExecutor.Native.HostAwareWait]::Wait(
                        $drainTasks.ToArray(),
                        $(if ($null -ne $Deadline) {
                                $Deadline.CleanupSlice([TimeSpan]::FromSeconds(5))
                            }
                            else { [TimeSpan]::FromSeconds(5) }),
                        $drainToken)
                }
            }
            finally { if ($null -ne $drainCts) { $drainCts.Dispose() } }

            $protocol = $null
            if ($null -ne $protocolTask -and $protocolTask.IsCompleted) {
                try { $protocol = $protocolTask.GetAwaiter().GetResult() }
                catch { $protocol = $null; $failure = $(if ($failure) { $failure } else { $_.Exception.Message }) }
            }

            $stdoutLossy = $false
            $stderrLossy = $false
            $stdoutLines = [CodexScientiae.BatchExecutor.Native.BoundedCapture]::DecodeLines(
                $stdoutCapture.ToArray(), [ref]$stdoutLossy)
            $stderrLines = [CodexScientiae.BatchExecutor.Native.BoundedCapture]::DecodeLines(
                $stderrCapture.ToArray(), [ref]$stderrLossy)
            $exitCode = if ($contained.HasExited) { $contained.ExitCode } else { $null }

            $protocolKind = 'missing'
            if ($null -ne $protocol -and $protocol.Malformed) {
                $protocolKind = 'malformed'
                if ($state -notin @('Cancelled', 'TimedOut')) {
                    $state = 'Failed'
                    $failure = $(if ($protocol.Failure) { [string]$protocol.Failure }
                        else { 'malformed control-channel protocol' })
                }
            }
            elseif ($null -ne $protocol -and $protocol.Truncated) {
                $protocolKind = 'truncated'
            }
            elseif ($null -ne $protocol -and $null -ne $protocol.Final) {
                $protocolKind = 'ok'
                $wire = [System.Management.Automation.PSSerializer]::Deserialize($protocol.Final.PayloadText)
                $output = @($wire.Output)
                $childErrors = @($wire.Errors)
                $childWarnings = @($childWarnings) + @($wire.Warnings)
                $failure = if ($wire.Failure) { [string]$wire.Failure } else { $failure }
                if ($state -notin @('Cancelled', 'TimedOut')) {
                    $state = if ([bool]$wire.Succeeded -and $exitCode -eq 0) { 'Succeeded' } else { 'Failed' }
                }
            }
            elseif ($state -notin @('Cancelled', 'TimedOut')) {
                $protocolKind = 'native-exit'
                $output = $stdoutLines
                $state = if ($exitCode -eq 0) { 'Succeeded' } else { 'Failed' }
                if ($state -eq 'Failed') {
                    $failure = "child PowerShell exited with code $exitCode without a structured result"
                }
            }

            if ($stderrLines.Count -gt 0) {
                if ($state -in @('Succeeded', 'Cancelled')) { $childWarnings += $stderrLines }
                else { $childErrors += $stderrLines }
            }

            $capture = [pscustomobject]@{
                StdOutComplete = [bool]$stdoutCapture.EndOfStream
                StdErrComplete = [bool]$stderrCapture.EndOfStream
                Protocol = $protocolKind
                Truncated = [bool]($stdoutCapture.Truncated -or $stderrCapture.Truncated -or
                    ($null -ne $protocol -and $protocol.Truncated))
                StdOutLossy = [bool]$stdoutLossy
                StdErrLossy = [bool]$stderrLossy
                StdOutBytes = [long]$stdoutCapture.Bytes
                StdErrBytes = [long]$stderrCapture.Bytes
                ProtocolBytes = [long]$(if ($null -ne $protocol) { $protocol.Bytes } else { 0 })
            }
        }
        finally { $ioCts.Dispose() }
    }
}
catch {
    if ($CancellationToken.IsCancellationRequested) {
        $state = 'Cancelled'
        $stopReason = 'CallerCancellation'
        $stopPhase = $(if ($startedChild) { 'ChildWait' } else { 'Dispatch' })
        $childWarnings += 'cancellation requested during child process setup'
    }
    else {
        $failure = $_.ToString()
        $state = 'Failed'
        if (-not $stopPhase) { $stopPhase = $(if ($startedChild) { 'ChildWait' } else { 'Dispatch' }) }
    }
}
finally {
    if ($null -ne $contained) {
        try {
            $wait = if ($null -ne $Deadline) {
                $Deadline.CleanupSlice([TimeSpan]::FromSeconds(5))
            }
            else { [TimeSpan]::FromSeconds(5) }
            [void]$contained.Terminate($wait)
        }
        catch {}
        if ($registered) {
            if ($contained.ConfirmedRelease) {
                [object] $removed = $null
                [void]$ProcessRegistry.TryRemove($JobId, [ref]$removed)
                try { $contained.Dispose() } catch {}
            }
        }
        elseif ($contained.ConfirmedRelease) {
            try { $contained.Dispose() } catch {}
        }
    }
    if ($null -ne $control) { try { $control.Dispose() } catch {} }
} }

if ($null -eq $capture) {
    $capture = [pscustomobject]@{
        StdOutComplete = $false
        StdErrComplete = $false
        Protocol = 'missing'
        Truncated = $false
        StdOutLossy = $false
        StdErrLossy = $false
        StdOutBytes = 0L
        StdErrBytes = 0L
        ProtocolBytes = 0L
    }
}

$ended = [datetime]::UtcNow
[pscustomobject]@{
    Output      = @($output)
    Failure     = $failure
    State       = $state
    Errors      = @($childErrors)
    Warnings    = @($childWarnings)
    StdOut      = @($stdoutLines)
    StdErr      = @($stderrLines)
    ExitCode    = $exitCode
    StartedUtc  = $started
    EndedUtc    = $ended
    RunspaceId  = [System.Management.Automation.Runspaces.Runspace]::DefaultRunspace.InstanceId.ToString()
    ThreadId    = [System.Environment]::CurrentManagedThreadId
    ProcessId   = $childProcessId
    Observation = [pscustomobject]@{
        Submitted = $true
        Started = $startedChild
        StopReason = $stopReason
        StopPhase = $stopPhase
    }
    Capture     = $capture
}
