#requires -Version 7.5

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../../src/batch-executor/batch-executor.psd1') -Force

    function Write-BoundsWorker {
        param([Parameter(Mandatory)] [string] $Path, [Parameter(Mandatory)] [string] $Body)
        Set-Content -LiteralPath $Path -Encoding utf8 -Value $Body
        return (Resolve-Path -LiteralPath $Path).Path
    }

    function Test-ProcessExited {
        param([int] $ProcessId, [int] $TimeoutMilliseconds = 4000)
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        while ($watch.ElapsedMilliseconds -lt $TimeoutMilliseconds) {
            if ($null -eq (Get-Process -Id $ProcessId -ErrorAction SilentlyContinue)) { return $true }
            Start-Sleep -Milliseconds 50
        }
        $survivor = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
        if ($null -ne $survivor) {
            try { $survivor.Kill($true) } catch { try { $survivor.Kill() } catch {} }
            try { $survivor.WaitForExit(2000) } catch {}
        }
        return $false
    }
}

Describe 'batch-executor runtime admission and bounds' {
    It 'rejects PowerShell versions below 7.5 before workload side effects' {
        InModuleScope 'batch-executor' {
            { Test-BatchExecutorPowerShellFloor -Version ([version]'7.4.6') -Source "child 'old'" } |
                Should -Throw "*requires PowerShell 7.5 or newer*child 'old' is 7.4.6*"
            Test-BatchExecutorPowerShellFloor -Version ([version]'7.5.0') -Source host
            Test-BatchExecutorPowerShellFloor -Version ([version]'7.6.4') -Source host
        }
    }

    It 'records host runtime identity on a direct batch' {
        $worker = Write-BoundsWorker (Join-Path $TestDrive 'runtime-host-worker.ps1') `
            'param($Item, $Context, $RunspaceState, $CancellationToken); $Item.Value'
        $run = Invoke-BatchExecutor -InputObject @(@{ Id = 'runtime-host'; Value = 1 }) `
            -ScriptPath $worker -ExecutionMode Runspace -WorkingDirectory $TestDrive -MaxWorkers 1

        $run.Runtime.Floor | Should -Be '7.5'
        $run.Runtime.Host.PSVersion | Should -Match '^7\.(5|6)\.'
        $run.Runtime.Host.FrameworkDescription | Should -Match '^\.NET '
        $run.Runtime.Host.Executable | Should -Not -BeNullOrEmpty
        $run.Runtime.Children.Count | Should -Be 0
        $run.Policy.Timeouts.CleanupTimeoutSeconds | Should -Be 30
        $run.Cleanup.State | Should -Be 'Confirmed'
        $run.Results[0].Observation.Submitted | Should -BeTrue
        $run.Results[0].Observation.Started | Should -BeTrue
        $run.Results[0].Capture.Protocol | Should -Be 'not-applicable'
    }

    It 'probes a 7.5 child executable when one is configured' {
        $candidate = Join-Path $env:USERPROFILE 'PDenv/PowerShell/PowerShell-7.5.5-win-x64/pwsh.exe'
        if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            Set-ItResult -Skipped -Because "PowerShell 7.5 installation not found at $candidate"
            return
        }
        $worker = Write-BoundsWorker (Join-Path $TestDrive 'runtime-child-worker.ps1') @'
param($Item, $Context, $RunspaceState)
$PSVersionTable.PSVersion.ToString()
'@
        $run = Invoke-BatchExecutor -InputObject @(@{ Id = 'runtime-child' }) `
            -ScriptPath $worker -ExecutionMode Process -PowerShellPath $candidate `
            -WorkingDirectory $TestDrive -MaxWorkers 1 -ProcessTimeoutSeconds 30

        $run.Summary.Succeeded | Should -Be 1
        $run.Runtime.Children.Count | Should -Be 1
        $run.Runtime.Children[0].PSVersion | Should -Match '^7\.5\.'
        $run.Results[0].Output[0] | Should -Match '^7\.5\.'
        $run.Results[0].Capture.Protocol | Should -Be 'ok'
    }

    It 'times out a hung sibling under ExecutionTimeoutSeconds and keeps a completed sibling' {
        $worker = Write-BoundsWorker (Join-Path $TestDrive 'execution-timeout-worker.ps1') @'
param($Item, $Context, $RunspaceState, $CancellationToken)
if ($Item.Hang) { Start-Sleep -Seconds 30 }
$Item.Id
'@
        $items = @(
            [pscustomobject]@{ Id = 'fast-sibling'; Hang = $false }
            [pscustomobject]@{ Id = 'hung-sibling'; Hang = $true }
        )
        $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker `
            -ExecutionMode Process -WorkingDirectory $TestDrive -MaxWorkers 2 `
            -ExecutionTimeoutSeconds 8 -ProcessTimeoutSeconds 30 -CleanupTimeoutSeconds 10

        $run.Results.Id | Should -Be @('fast-sibling', 'hung-sibling')
        $run.Results[0].State | Should -Be 'Succeeded'
        $run.Results[1].State | Should -Be 'TimedOut'
        $run.Results[1].Observation.StopReason | Should -Be 'ExecutionTimeout'
        $run.Summary.Succeeded | Should -Be 1
        $run.Summary.TimedOut | Should -Be 1
    }

    It 'does not treat marker-like stdout as control data' {
        $worker = Write-BoundsWorker (Join-Path $TestDrive 'marker-stdout-worker.ps1') @'
param($Item, $Context, $RunspaceState)
[Console]::Out.WriteLine('BATCH-EXECUTOR-RESULT not-a-protocol')
'ok'
'@
        $run = Invoke-BatchExecutor -InputObject @(@{ Id = 'marker-stdout' }) `
            -ScriptPath $worker -ExecutionMode Process -WorkingDirectory $TestDrive `
            -MaxWorkers 1 -ProcessTimeoutSeconds 30

        $run.Results[0].State | Should -Be 'Succeeded'
        $run.Results[0].Output | Should -Be @('ok')
        $run.Results[0].StdOut | Should -Contain 'BATCH-EXECUTOR-RESULT not-a-protocol'
        $run.Results[0].Capture.Protocol | Should -Be 'ok'
    }

    It 'classifies an intentional native exit without a final protocol record' {
        $worker = Write-BoundsWorker (Join-Path $TestDrive 'native-exit-worker.ps1') @'
param($Item, $Context, $RunspaceState)
[Environment]::Exit(7)
'@
        $run = Invoke-BatchExecutor -InputObject @(@{ Id = 'native-exit' }) `
            -ScriptPath $worker -ExecutionMode Process -WorkingDirectory $TestDrive `
            -MaxWorkers 1 -ProcessTimeoutSeconds 30

        $run.Results[0].State | Should -Be 'Failed'
        $run.Results[0].ExitCode | Should -Be 7
        $run.Results[0].Capture.Protocol | Should -Be 'native-exit'
        ($run.Results[0].Errors -join "`n") | Should -Match 'exited with code 7 without a structured result'
    }

    It 'contains descendants when the worker exits first' {
        $worker = Write-BoundsWorker (Join-Path $TestDrive 'worker-exits-first.ps1') @'
param($Item, $Context, $RunspaceState)
$startInfo = [System.Diagnostics.ProcessStartInfo]::new()
$startInfo.FileName = Join-Path $PSHOME $(if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' })
$startInfo.UseShellExecute = $false
$startInfo.CreateNoWindow = $true
[void]$startInfo.ArgumentList.Add('-NoProfile')
[void]$startInfo.ArgumentList.Add('-NonInteractive')
[void]$startInfo.ArgumentList.Add('-Command')
[void]$startInfo.ArgumentList.Add('Start-Sleep -Seconds 30')
$grandchild = [System.Diagnostics.Process]::Start($startInfo)
[System.IO.File]::WriteAllText([string]$Item.GrandchildPidPath, [string]$grandchild.Id)
[System.IO.File]::WriteAllText([string]$Item.ChildPidPath, [string]$PID)
exit 0
'@
        $item = [pscustomobject]@{
            Id = 'worker-exits-first'
            ChildPidPath = Join-Path $TestDrive 'worker-exits-first.pid'
            GrandchildPidPath = Join-Path $TestDrive 'worker-exits-first-grandchild.pid'
        }
        $run = Invoke-BatchExecutor -InputObject @($item) -ScriptPath $worker `
            -ExecutionMode Process -WorkingDirectory $TestDrive -MaxWorkers 1 `
            -ProcessTimeoutSeconds 30

        $item.GrandchildPidPath | Should -Exist
        $grandchildPid = [int](Get-Content -LiteralPath $item.GrandchildPidPath -Raw)
        (Test-ProcessExited -ProcessId $grandchildPid) | Should -BeTrue
        $run.Cleanup.State | Should -Be 'Confirmed'
        $run.Results[0].Capture.Protocol | Should -BeIn @('ok', 'native-exit')
    }

    It 'closes admission so queued work does not start after cancellation' {
        $worker = Write-BoundsWorker (Join-Path $TestDrive 'queued-cancel-worker.ps1') @'
param($Item, $Context, $RunspaceState, $CancellationToken)
Start-Sleep -Seconds 30
$Item.Id
'@
        $cts = [System.Threading.CancellationTokenSource]::new()
        $cts.Cancel()
        try {
            $items = 1..3 | ForEach-Object { @{ Id = "queued-$_" } }
            $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker `
                -ExecutionMode Runspace -CancellationToken $cts.Token -MaxWorkers 1
        }
        finally { $cts.Dispose() }

        $run.Results.State | Should -Be @('Cancelled', 'Cancelled', 'Cancelled')
        $run.Results.Observation.Submitted | Should -Be @($false, $false, $false)
        $run.Results.Observation.Started | Should -Be @($false, $false, $false)
    }
}
