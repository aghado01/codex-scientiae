function Stop-JsonlEngineProcess {
    param([Parameter(Mandatory)] [System.Diagnostics.Process] $Process)

    try {
        if (-not $Process.HasExited -and $IsWindows) {
            # Process.Kill(true) can lose grandchildren launched through a .cmd trampoline on
            # Windows. taskkill snapshots and terminates the tree while the owned root still
            # exists; the exact integer PID is passed without a command shell.
            $taskkillPath = [System.IO.Path]::Combine(
                [System.Environment]::SystemDirectory,
                'taskkill.exe')
            if ([System.IO.File]::Exists($taskkillPath)) {
                $killInfo = [System.Diagnostics.ProcessStartInfo]::new()
                $killInfo.FileName = $taskkillPath
                foreach ($argument in @('/PID', [string]$Process.Id, '/T', '/F')) {
                    $killInfo.ArgumentList.Add($argument)
                }
                $killInfo.UseShellExecute = $false
                $killInfo.CreateNoWindow = $true
                $killInfo.RedirectStandardOutput = $true
                $killInfo.RedirectStandardError = $true
                $killer = [System.Diagnostics.Process]::new()
                $killer.StartInfo = $killInfo
                try {
                    if ($killer.Start()) {
                        $stdoutTask = $killer.StandardOutput.ReadToEndAsync()
                        $stderrTask = $killer.StandardError.ReadToEndAsync()
                        if (-not $killer.WaitForExit(10000)) {
                            $killer.Kill($true)
                            [void]$killer.WaitForExit(5000)
                        }
                        if ($killer.HasExited) {
                            [void]$stdoutTask.GetAwaiter().GetResult()
                            [void]$stderrTask.GetAwaiter().GetResult()
                        }
                    }
                }
                finally {
                    $killer.Dispose()
                }
            }
        }
        if (-not $Process.HasExited) {
            $Process.Kill($true)
        }
        [void]$Process.WaitForExit(10000)
    }
    catch {
        # Cleanup is best effort. The original protocol/timeout failure remains authoritative.
    }
}

function Invoke-JsonlEngineProcess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Verb,
        [string[]] $Argument = @(),
        [string] $PythonPath = '',
        [ValidateRange(1, 3600)] [int] $TimeoutSeconds = 300
    )

    $python = Resolve-JsonlEngineRuntime -PythonPath $PythonPath
    $argv = [System.Collections.Generic.List[string]]::new()
    $argv.Add('-m')
    $argv.Add('jsonl_engine')
    $argv.Add('--framed')
    $argv.Add($Verb)
    foreach ($item in $Argument) { $argv.Add([string]$item) }

    $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $python
    foreach ($item in $argv) { $startInfo.ArgumentList.Add($item) }
    $startInfo.WorkingDirectory = $script:JsonlEngineRepositoryRoot
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.StandardOutputEncoding = $script:JsonlEngineUtf8
    $startInfo.StandardErrorEncoding = $script:JsonlEngineUtf8
    foreach ($name in @(
            'PYTHONPATH', 'PYTHONHOME', 'PYTHONWARNINGS', 'PYTHONINSPECT',
            'PYTHONSTARTUP', 'PYTHONBREAKPOINT', 'PYTHONUSERBASE'
        )) {
        [void]$startInfo.Environment.Remove($name)
    }
    $startInfo.Environment['PYTHONIOENCODING'] = 'utf-8'
    $startInfo.Environment['PYTHONUTF8'] = '1'
    $startInfo.Environment['PYTHONUNBUFFERED'] = '1'
    $startInfo.Environment['PYTHONDONTWRITEBYTECODE'] = '1'
    $startInfo.Environment['PYTHONNOUSERSITE'] = '1'

    $display = ConvertTo-JsonlEngineCommandDisplay -Executable $python `
        -ArgumentList $argv.ToArray()
    $process = [System.Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    $started = $false
    $stderrTask = $null
    $clock = [System.Diagnostics.Stopwatch]::StartNew()
    $timeoutMilliseconds = [long]$TimeoutSeconds * 1000
    try {
        try {
            $started = $process.Start()
        }
        catch {
            throw "failed to start jsonl engine command $display`: $($_.Exception.Message)"
        }
        if (-not $started) { throw "failed to start jsonl engine command: $display" }

        $stderrTask = $process.StandardError.ReadToEndAsync()
        $frames = [System.Collections.Generic.List[object]]::new()
        $sequence = 0
        while ($true) {
            $remaining = $timeoutMilliseconds - $clock.ElapsedMilliseconds
            if ($remaining -le 0) {
                throw [System.TimeoutException]::new(
                    "jsonl engine verb '$Verb' timed out after $TimeoutSeconds s")
            }
            $readTask = $process.StandardOutput.ReadLineAsync()
            if (-not $readTask.Wait([int][Math]::Min([int]::MaxValue, $remaining))) {
                throw [System.TimeoutException]::new(
                    "jsonl engine verb '$Verb' timed out after $TimeoutSeconds s")
            }
            $line = $readTask.GetAwaiter().GetResult()
            if ($null -eq $line) { break }
            if ([string]::IsNullOrWhiteSpace($line)) {
                throw 'jsonl engine emitted a blank protocol line'
            }
            $frame = ConvertFrom-JsonlEngineFrame -Json $line -ExpectedSequence $sequence
            $sequence++
            $frames.Add($frame)
        }

        $remaining = $timeoutMilliseconds - $clock.ElapsedMilliseconds
        if ($remaining -le 0 -or
            -not $process.WaitForExit([int][Math]::Min([int]::MaxValue, $remaining))) {
            throw [System.TimeoutException]::new(
                "jsonl engine verb '$Verb' timed out after $TimeoutSeconds s")
        }
        $stderr = $stderrTask.GetAwaiter().GetResult()
        if ($process.ExitCode -ne 0) {
            $errorFrame = ConvertFrom-JsonlEngineError -Text $stderr
            $detail = if ($null -ne $errorFrame) {
                "$($errorFrame.error): $($errorFrame.message)"
            }
            elseif ([string]::IsNullOrWhiteSpace($stderr)) {
                'no error detail'
            }
            else {
                $stderr.Trim()
            }
            $exception = [System.InvalidOperationException]::new(
                "jsonl engine verb '$Verb' failed with exit code $($process.ExitCode): $detail`n  command: $display")
            $exception.Data['Verb'] = $Verb
            $exception.Data['ExitCode'] = $process.ExitCode
            $exception.Data['Command'] = $display
            if ($null -ne $errorFrame) {
                $exception.Data['ProtocolError'] = [string]$errorFrame.error
                $exception.Data['ProtocolMessage'] = [string]$errorFrame.message
            }
            throw $exception
        }
        if (-not [string]::IsNullOrWhiteSpace($stderr)) {
            throw "jsonl engine wrote stderr on a successful invocation:`n$($stderr.Trim())`n  command: $display"
        }
        foreach ($frame in $frames) {
            Write-Output $frame
        }
    }
    catch [System.TimeoutException] {
        if ($started) { Stop-JsonlEngineProcess -Process $process }
        throw "$($_.Exception.Message)`n  command: $display"
    }
    finally {
        $clock.Stop()
        if ($started) { Stop-JsonlEngineProcess -Process $process }
        $process.Dispose()
    }
}
