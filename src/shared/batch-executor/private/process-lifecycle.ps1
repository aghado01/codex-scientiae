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
