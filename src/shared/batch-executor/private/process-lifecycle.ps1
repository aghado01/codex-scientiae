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
        if ($null -eq $invocation -or $null -eq $invocation.PS -or $null -eq $invocation.Async) {
            continue
        }
        if ($invocation.Async.IsCompleted) { continue }

        try {
            $stopAsync = $invocation.PS.BeginStop($null, $null)
            $stopRequests.Add([pscustomobject]@{ PS = $invocation.PS; Async = $stopAsync })
        }
        catch {}
    }

    foreach ($request in $stopRequests) {
        try { $request.PS.EndStop($request.Async) } catch {}
    }
}
