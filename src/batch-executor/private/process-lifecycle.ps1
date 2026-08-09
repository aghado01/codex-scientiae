function Stop-BatchExecutorChildProcesses {
    <# Parent-owned teardown primitive. Never disposes Process objects while dispatcher runspaces may
       still be reading them; dispatchers remove and dispose their own entries in finally blocks. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.Concurrent.ConcurrentDictionary[string, System.Diagnostics.Process]] $Registry,
        [string] $Reason = 'batch teardown',
        [System.Collections.Generic.List[string]] $Diagnostics
    )

    foreach ($entry in $Registry.ToArray()) {
        try {
            if (-not $entry.Value.HasExited) { $entry.Value.Kill($true) }
        }
        catch {
            [System.Diagnostics.Process] $currentProcess = $null
            $sameOwner = $Registry.TryGetValue($entry.Key, [ref]$currentProcess) -and
                [object]::ReferenceEquals($currentProcess, $entry.Value)
            # The dispatcher removes its registry entry before disposing the Process object. A
            # snapshot reader can therefore observe ObjectDisposedException after successful
            # dispatcher cleanup; only diagnose failures for records that are still registry-owned.
            if (-not $sameOwner) { continue }
            if ($null -ne $Diagnostics) {
                $Diagnostics.Add("could not terminate child for item '$($entry.Key)' during ${Reason}: $($_.Exception.Message)")
            }
        }
    }
}

function Stop-BatchExecutorPipelines {
    <# Submit every stop request before waiting for any one pipeline. A sequential PowerShell.Stop()
       loop can let queued pool work run in waves while the first stop call blocks. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable] $Invocations
    )

    $stopRequests = [System.Collections.Generic.List[object]]::new()
    foreach ($invocation in $Invocations) {
        if ($null -eq $invocation -or $null -eq $invocation.Pipeline -or
                $null -eq $invocation.AsyncResult) {
            continue
        }
        if ($invocation.AsyncResult.IsCompleted) { continue }

        try {
            $stopAsync = $invocation.Pipeline.BeginStop($null, $null)
            $stopRequests.Add([pscustomobject]@{
                    Pipeline = $invocation.Pipeline
                    AsyncResult = $stopAsync
                })
        }
        catch {}
    }

    foreach ($request in $stopRequests) {
        try { $request.Pipeline.EndStop($request.AsyncResult) } catch {}
    }
}

function Stop-BatchExecutorPendingPipeline {
    [CmdletBinding()]
    param(
        [AllowNull()] [object] $Pipeline
    )

    if ($null -eq $Pipeline) { return }
    try {
        $stopAsync = $Pipeline.BeginStop($null, $null)
        $Pipeline.EndStop($stopAsync)
    }
    catch {}
}
