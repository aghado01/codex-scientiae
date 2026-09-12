function Stop-BatchExecutorChildProcesses {
    <# Parent-owned teardown primitive. Dispatchers remove and dispose their own entries only after
       confirmed exit. Remaining registry records are live ownership, not successful cleanup. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.Concurrent.ConcurrentDictionary[string, object]] $Registry,
        [string] $Reason = 'batch teardown',
        [System.Collections.Generic.List[string]] $Diagnostics,
        [AllowNull()] [object] $Deadline
    )

    Import-BatchExecutorNative
    foreach ($entry in $Registry.ToArray()) {
        try {
            $owned = $entry.Value
            $wait = if ($null -ne $Deadline) {
                $Deadline.CleanupSlice([TimeSpan]::FromSeconds(5))
            }
            else { [TimeSpan]::FromSeconds(5) }
            if ($owned -is [CodexScientiae.BatchExecutor.Native.ContainedProcess]) {
                if (-not $owned.ConfirmedRelease) { [void]$owned.Terminate($wait) }
            }
            elseif ($owned -is [System.Diagnostics.Process]) {
                if (-not $owned.HasExited) { $owned.Kill($true) }
                $waitMs = if ($wait -eq [System.Threading.Timeout]::InfiniteTimeSpan) { 5000 }
                    else { [int][math]::Max(1, $wait.TotalMilliseconds) }
                try { [void]$owned.WaitForExit($waitMs) } catch {}
            }
        }
        catch {
            [object] $current = $null
            $sameOwner = $Registry.TryGetValue($entry.Key, [ref]$current) -and
                [object]::ReferenceEquals($current, $entry.Value)
            if (-not $sameOwner) { continue }
            if ($null -ne $Diagnostics) {
                $Diagnostics.Add("could not terminate child for item '$($entry.Key)' during ${Reason}: $($_.Exception.Message)")
            }
        }
    }
}

function Stop-BatchExecutorPipelines {
    <# Submit every stop request before waiting for any one pipeline. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable] $Invocations,
        [AllowNull()] [object] $Deadline
    )

    Import-BatchExecutorNative
    $pending = [System.Collections.Generic.List[object]]::new()
    foreach ($invocation in $Invocations) {
        if ($null -eq $invocation -or $null -eq $invocation.Pipeline) { continue }
        if ($null -ne $invocation.AsyncResult -and $invocation.AsyncResult.IsCompleted) {
            continue
        }

        try { $invocation.Pipeline.BeginStop($null, $null) | Out-Null } catch {}
        if ($null -ne $invocation.AsyncResult -and $null -ne $invocation.AsyncResult.AsyncWaitHandle) {
            $pending.Add($invocation.AsyncResult)
        }
    }

    if ($pending.Count -eq 0) { return }
    $watch = [System.Diagnostics.Stopwatch]::StartNew()
    while ($true) {
        $incomplete = [System.Collections.Generic.List[object]]::new()
        foreach ($task in $pending) {
            if (-not $task.IsCompleted) { $incomplete.Add($task) }
        }
        if ($incomplete.Count -eq 0) { break }
        $slice = if ($null -ne $Deadline) {
            $Deadline.CleanupSlice([TimeSpan]::FromMilliseconds(200))
        }
        else {
            $left = 5000 - $watch.ElapsedMilliseconds
            if ($left -le 0) { [TimeSpan]::Zero }
            else { [TimeSpan]::FromMilliseconds([math]::Min(200, [math]::Max(1, $left))) }
        }
        if ($slice -le [TimeSpan]::Zero) { break }
        if ($null -ne $Deadline -and $Deadline.CleanupExpired) { break }
        if ($null -eq $Deadline -and $watch.ElapsedMilliseconds -ge 5000) { break }
        $waitMs = [CodexScientiae.BatchExecutor.Native.HostAwareWait]::ToWaitMilliseconds($slice)
        # Every stop is already submitted. Recheck all completions after one bounded wait;
        # WaitAny over the whole set fails above the platform's 64-handle limit.
        [void]$incomplete[0].AsyncWaitHandle.WaitOne($waitMs)
    }
}

function Stop-BatchExecutorPendingPipeline {
    [CmdletBinding()]
    param(
        [AllowNull()] [object] $Pipeline,
        [AllowNull()] [object] $Deadline
    )

    if ($null -eq $Pipeline) { return }
    try {
        $null = $Pipeline.StopAsync($null, [System.Threading.CancellationToken]::None)
    }
    catch {}
}
