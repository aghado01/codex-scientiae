#requires -Version 7.5
BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../../src/batch-executor/batch-executor.psd1') -Force
    function Invoke-RegressionWorker {
        param([string] $Body, [string] $Root, [int] $Timeout = 20)
        $worker = Join-Path $Root 'worker.ps1'
        [IO.File]::WriteAllText($worker, ('param($Item, $Context, $RunspaceState)' + "`n" + $Body), [Text.UTF8Encoding]::new($false))
        Invoke-BatchExecutor -InputObject @(@{ Id = 'probe' }) -ScriptPath $worker `
            -ExecutionMode Process -WorkingDirectory $Root -MaxWorkers 1 `
            -ProcessTimeoutSeconds $Timeout -ExecutionTimeoutSeconds 30 -CleanupTimeoutSeconds 5
    }
}

Describe 'batch executor review regressions' {
    It 'retains aggregate structured output larger than one frame' {
        $run = Invoke-RegressionWorker -Root $TestDrive -Body "1..6 | ForEach-Object { 'x' * 300000 }"
        $run.Results[0].State | Should -Be 'Succeeded'
        $run.Results[0].Output.Count | Should -Be 6
        foreach ($item in $run.Results[0].Output) { $item.Length | Should -Be 300000 }
        $run.Results[0].Capture.Truncated | Should -BeFalse
        $run.Cleanup.State | Should -Be 'Confirmed'
    }
    It 'reports an oversized object as loss and retains earlier output' {
        $run = Invoke-RegressionWorker -Root $TestDrive -Body "'before'; 'x' * 1200000"
        $run.Results[0].State | Should -Be 'Failed'
        $run.Results[0].Output | Should -Contain 'before'
        $run.Results[0].Capture.Truncated | Should -BeTrue
        $run.Results[0].Capture.Protocol | Should -Be 'truncated'
    }
    It 'retains structured and native output produced before timeout' {
        $run = Invoke-RegressionWorker -Root $TestDrive -Timeout 3 -Body @'
'object-partial'
[Console]::Out.WriteLine('raw-partial')
Start-Sleep -Seconds 30
'@
        $run.Results[0].State | Should -Be 'TimedOut'
        $run.Results[0].Output | Should -Contain 'object-partial'
        $run.Results[0].StdOut | Should -Contain 'raw-partial'
        $run.Cleanup.State | Should -Be 'Confirmed'
    }
    It 'submits more than 64 stops without a platform wait-handle limit' {
        InModuleScope 'batch-executor' {
            $invocations = @(
                1..70 | ForEach-Object {
                    $pipeline = [pscustomobject]@{ Stops = 0 }
                    $pipeline | Add-Member ScriptMethod BeginStop { param($callback, $state) $this.Stops++ }
                    [pscustomobject]@{ Pipeline = $pipeline; AsyncResult = [pscustomobject]@{
                        IsCompleted = $false; AsyncWaitHandle = [Threading.ManualResetEvent]::new($false) } }
                }
            )
            $deadline = [CodexScientiae.BatchExecutor.Native.DeadlineClock]::new(
                $null, $null, $null, [TimeSpan]::FromMilliseconds(100))
            $deadline.StartCleanup()
            try {
                { Stop-BatchExecutorPipelines -Invocations $invocations -Deadline $deadline } | Should -Not -Throw
                @($invocations | Where-Object { $_.Pipeline.Stops -ne 1 }).Count | Should -Be 0
            }
            finally { foreach ($entry in $invocations) { $entry.AsyncResult.AsyncWaitHandle.Dispose() } }
        }
    }
    It 'returns incomplete cleanup within budget for uncooperative managed work' {
        $worker = Join-Path $TestDrive 'managed-sleep.ps1'
        [IO.File]::WriteAllText($worker, 'param($Item, $Context, $RunspaceState, $CancellationToken); [Threading.Thread]::Sleep(8000)', [Text.UTF8Encoding]::new($false))
        $watch = [Diagnostics.Stopwatch]::StartNew()
        $run = Invoke-BatchExecutor -InputObject @(@{ Id = 'managed' }) -ScriptPath $worker `
            -ExecutionMode Runspace -WorkingDirectory $TestDrive -MaxWorkers 1 `
            -ExecutionTimeoutSeconds 1 -CleanupTimeoutSeconds 1
        $watch.Elapsed.TotalSeconds | Should -BeLessThan 5
        $run.Results[0].State | Should -Be 'TimedOut'
        $run.Cleanup.State | Should -Be 'Incomplete'
        ($run.Errors -join ' ') | Should -Match 'resources remain owned'
        # Let the fixture finish naturally before its containing test worker exits.
        [Threading.Thread]::Sleep(6500)
    }
}
