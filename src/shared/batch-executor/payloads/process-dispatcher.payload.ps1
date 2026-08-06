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
    [System.Collections.Concurrent.ConcurrentDictionary[string, System.Diagnostics.Process]] $ProcessRegistry,
    [System.Threading.CancellationToken] $CancellationToken
)

$started = [datetime]::UtcNow
$process = $null
$failure = $null
$state = 'Failed'
$output = @()
$childErrors = @()
$childWarnings = @()
$stdoutLines = @()
$stderrLines = @()
$exitCode = $null
$childProcessId = $null
$prefix = 'BATCH-EXECUTOR-RESULT '
$registered = $false

if ($CancellationToken.IsCancellationRequested) {
    $state = 'Cancelled'
    $childWarnings = @('cancellation requested before child process start')
}
else { try {
    $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $PowerShellPath
    $startInfo.WorkingDirectory = $WorkingDirectory
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $CreateNoWindow
    $startInfo.WindowStyle = [System.Enum]::Parse([System.Diagnostics.ProcessWindowStyle], $WindowStyle, $true)
    $startInfo.RedirectStandardInput = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    foreach ($key in @($ProcessEnvironment.Keys)) {
        $name = [string]$key
        $value = $ProcessEnvironment[$key]
        if ($null -eq $value) { [void]$startInfo.Environment.Remove($name) }
        else { $startInfo.Environment[$name] = [string]$value }
    }
    $startInfo.Environment['CODEX_BATCH_JOB_ID'] = $JobId
    $startInfo.Environment['CODEX_BATCH_EXECUTION_MODE'] = 'Process'
    [void] $startInfo.ArgumentList.Add('-NoLogo')
    if (-not $LoadProfile) { [void] $startInfo.ArgumentList.Add('-NoProfile') }
    [void] $startInfo.ArgumentList.Add('-NonInteractive')
    [void] $startInfo.ArgumentList.Add('-EncodedCommand')
    [void] $startInfo.ArgumentList.Add($EncodedChildCommand)

    $process = [System.Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    if (-not $process.Start()) { throw "failed to start child PowerShell: $PowerShellPath" }
    $childProcessId = $process.Id
    $registered = $ProcessRegistry.TryAdd($JobId, $process)
    if (-not $registered) {
        try { $process.Kill($true) } catch {}
        throw "live child registry already contains job id '$JobId'"
    }

    if ($PriorityClass -ne 'Normal') {
        try {
            $process.PriorityClass = [System.Enum]::Parse(
                [System.Diagnostics.ProcessPriorityClass], $PriorityClass, $true)
        }
        catch { $childWarnings += "could not set child priority '$PriorityClass': $($_.Exception.Message)" }
    }

    # Cancellation can race process start. Registration precedes the second check so either this
    # dispatcher or the parent registry sweep owns an immediately killable process reference.
    if ($CancellationToken.IsCancellationRequested) {
        try { $process.Kill($true) } catch {}
    }

    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()
    $process.StandardInput.Write($payloadXml)
    $process.StandardInput.Close()

    # Keep PowerShell stop/unwind interruptible. A single long CLR WaitForExit call can hide a child
    # that registers after the parent's final registry sweep until the child exits naturally.
    $processWait = [System.Diagnostics.Stopwatch]::StartNew()
    $completed = $process.HasExited
    while (-not $completed -and -not $CancellationToken.IsCancellationRequested) {
        $remaining = if ($ProcessTimeoutSeconds -gt 0) {
            ([int64]$ProcessTimeoutSeconds * 1000) - $processWait.ElapsedMilliseconds
        }
        else { [int64]-1 }
        if ($ProcessTimeoutSeconds -gt 0 -and $remaining -le 0) { break }

        $waitSlice = if ($remaining -ge 0) {
            [int][math]::Min(200, [math]::Max(1, $remaining))
        }
        else { 200 }
        $completed = $process.WaitForExit($waitSlice)
    }

    if ($CancellationToken.IsCancellationRequested) {
        if (-not $process.HasExited) { try { $process.Kill($true) } catch {} }
        try { $process.WaitForExit() } catch {}
        $state = 'Cancelled'
        $childWarnings += 'cancellation requested; child process tree terminated'
    }
    elseif (-not $completed) {
        try { $process.Kill($true) } catch {}
        try { $process.WaitForExit() } catch {}
        $state = 'TimedOut'
        $failure = "child process exceeded timeout of $ProcessTimeoutSeconds second(s)"
    }

    $stdout = $stdoutTask.GetAwaiter().GetResult()
    $stderr = $stderrTask.GetAwaiter().GetResult()
    $exitCode = if ($process.HasExited) { $process.ExitCode } else { $null }

    $stdoutList = [System.Collections.Generic.List[string]]::new()
    $stderrList = [System.Collections.Generic.List[string]]::new()
    $marker = $null
    foreach ($line in @($stdout -split '\r?\n')) {
        if ($line.Length -eq 0) { continue }
        if ($line.StartsWith($prefix, [System.StringComparison]::Ordinal)) { $marker = $line }
        else { $stdoutList.Add($line) }
    }
    foreach ($line in @($stderr -split '\r?\n')) {
        if ($line.Length -gt 0) { $stderrList.Add($line) }
    }
    $stdoutLines = $stdoutList.ToArray()
    $stderrLines = $stderrList.ToArray()

    if ($state -notin @('Cancelled', 'TimedOut') -and $null -ne $marker) {
        $wireBytes = [System.Convert]::FromBase64String($marker.Substring($prefix.Length))
        $wireXml = [System.Text.Encoding]::UTF8.GetString($wireBytes)
        $wire = [System.Management.Automation.PSSerializer]::Deserialize($wireXml)
        $output = @($wire.Output)
        $childErrors = @($wire.Errors)
        $childWarnings = @($wire.Warnings)
        $failure = if ($wire.Failure) { [string]$wire.Failure } else { $null }
        $state = if ([bool]$wire.Succeeded -and $exitCode -eq 0) { 'Succeeded' } else { 'Failed' }
    }
    elseif ($state -notin @('Cancelled', 'TimedOut')) {
        # A worker may intentionally call exit (command-line runners commonly do). In that case the
        # wrapper cannot emit its structured marker, so the native exit code remains authoritative.
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
}
catch {
    if ($CancellationToken.IsCancellationRequested) {
        $state = 'Cancelled'
        $childWarnings += 'cancellation requested during child process setup'
    }
    else { $failure = $_.ToString(); $state = 'Failed' }
}
finally {
    # The dispatcher is the final owner of any process it started. Parent teardown can race the
    # Start/TryAdd handoff or sweep the registry just before a late registration, so unwind must
    # terminate the tree before the dispatcher removes and disposes its process record.
    if ($null -ne $process) {
        try {
            if (-not $process.HasExited) {
                try { $process.Kill($true) } catch { try { $process.Kill() } catch {} }
                try { [void] $process.WaitForExit(5000) } catch {}
            }
        }
        catch {}
    }
    if ($registered) {
        [System.Diagnostics.Process] $removedProcess = $null
        [void] $ProcessRegistry.TryRemove($JobId, [ref]$removedProcess)
    }
    if ($null -ne $process) { $process.Dispose() }
} }

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
}
