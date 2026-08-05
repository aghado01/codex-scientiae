#requires -Version 7.0

BeforeAll {
    . (Join-Path $PSScriptRoot '../../src/shared/batch-executor.ps1')

    function Write-TestWorker {
        param([string] $Path, [string] $Body)
        Set-Content -LiteralPath $Path -Value $Body -Encoding utf8
        return $Path
    }

    function Write-ProcessTreeWorker {
        param([string] $Path)
        Write-TestWorker -Path $Path -Body @'
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
try {
    [System.IO.File]::WriteAllText([string]$Item.GrandchildPidPath, [string]$grandchild.Id)
    # This is the full-start marker. Its presence guarantees that the descendant PID was published first.
    [System.IO.File]::WriteAllText([string]$Item.ChildPidPath, [string]$PID)
    Start-Sleep -Seconds 30
}
finally {
    try { if (-not $grandchild.HasExited) { $grandchild.Kill($true) } } catch {}
    $grandchild.Dispose()
}
'@
    }

    function Wait-TestFile {
        param([string] $Path, [int] $TimeoutMilliseconds = 8000)
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        while ($watch.ElapsedMilliseconds -lt $TimeoutMilliseconds) {
            if (Test-Path -LiteralPath $Path -PathType Leaf) { return $true }
            Start-Sleep -Milliseconds 50
        }
        return $false
    }

    function Test-ProcessExited {
        param([int] $ProcessId, [int] $TimeoutMilliseconds = 4000)
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        while ($watch.ElapsedMilliseconds -lt $TimeoutMilliseconds) {
            if ($null -eq (Get-Process -Id $ProcessId -ErrorAction SilentlyContinue)) { return $true }
            Start-Sleep -Milliseconds 50
        }

        # A failing teardown test must not leave its witness running on the workstation.
        $survivor = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
        if ($null -ne $survivor) {
            try { $survivor.Kill($true) } catch { try { $survivor.Kill() } catch {} }
            try { $survivor.WaitForExit(2000) } catch {}
        }
        return $false
    }
}

Describe 'Resolve-BatchWorkerBudget' {
    It 'returns no workers for an empty batch' {
        $budget = Resolve-BatchWorkerBudget -ItemCount 0
        $budget.Threads | Should -Be 0
    }

    It 'honors an explicit I/O-oriented worker count without CPU clamping' {
        $requested = [Environment]::ProcessorCount + 3
        $budget = Resolve-BatchWorkerBudget -ItemCount ($requested + 2) -MaxWorkers $requested
        $budget.Threads | Should -Be $requested
        $budget.Warnings.Count | Should -Be 1
    }

    It 'grades worker count by minimum items per worker' {
        $budget = Resolve-BatchWorkerBudget -ItemCount 9 -MaxWorkers 8 -MinItemsPerWorker 4
        $budget.Threads | Should -Be 3
    }
}

Describe 'Invoke-BatchExecutor - Runspace' {
    It 'returns empty, structured output for an empty batch' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'empty-worker.ps1') 'param($Item, $Context, $RunspaceState)'
        $run = Invoke-BatchExecutor -InputObject @() -ScriptPath $worker

        $run.Results.Count | Should -Be 0
        $run.Summary.Total | Should -Be 0
        $run.Budget.Threads | Should -Be 0
        $run.Policy.FailureAction | Should -Be 'Continue'
    }

    It 'dispatches greedily while preserving input result order' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'greedy-worker.ps1') @'
param($Item, $Context, $RunspaceState)
Start-Sleep -Milliseconds $Item.DelayMs
[pscustomobject]@{ Value = $Item.Value }
'@
        $items = @(
            [pscustomobject]@{ Id = 'slow-1'; Value = 1; DelayMs = 450 }
            [pscustomobject]@{ Id = 'fast-1'; Value = 2; DelayMs = 40 }
            [pscustomobject]@{ Id = 'slow-2'; Value = 3; DelayMs = 300 }
            [pscustomobject]@{ Id = 'fast-2'; Value = 4; DelayMs = 40 }
        )

        $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker -MaxWorkers 2

        $run.Results.Id | Should -Be @('slow-1', 'fast-1', 'slow-2', 'fast-2')
        @($run.Results | ForEach-Object { $_.Output[0].Value }) | Should -Be @(1, 2, 3, 4)
        # fast-1 frees a pool slot; slow-2 must begin before slow-1 ends. Static slicing cannot do this.
        $run.Results[2].StartedUtc | Should -BeLessThan $run.Results[0].EndedUtc
        $run.Summary.Succeeded | Should -Be 4
    }

    It 'does not lose, duplicate, or reorder records under concurrent completion pressure' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'concurrency-worker.ps1') @'
param($Item, $Context, $RunspaceState, $CancellationToken)
Start-Sleep -Milliseconds (($Item.Ordinal % 9) * 3)
$Item.Ordinal
'@
        $items = 1..120 | ForEach-Object { [pscustomobject]@{ Id = "stress-$_"; Ordinal = $_ } }

        $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker -MaxWorkers 8

        $run.Results.Count | Should -Be 120
        $run.Summary.Succeeded | Should -Be 120
        $run.Errors.Count | Should -Be 0
        @($run.Results.Output | ForEach-Object { $_[0] }) | Should -Be (1..120)
        @($run.Results.RunspaceId | Sort-Object -Unique).Count | Should -BeGreaterThan 1
    }

    It 'initializes once per pooled runspace and reuses that state' {
        $initializer = Write-TestWorker (Join-Path $TestDrive 'initializer.ps1') @'
param($Context)
[pscustomobject]@{ Token = [guid]::NewGuid().ToString('N'); Seed = $Context.Seed }
'@
        $worker = Write-TestWorker (Join-Path $TestDrive 'initialized-worker.ps1') @'
param($Item, $Context, $RunspaceState)
Start-Sleep -Milliseconds 80
[pscustomobject]@{ Token = $RunspaceState.Token; Seed = $RunspaceState.Seed; Value = $Item.Value }
'@
        $items = 1..6 | ForEach-Object { [pscustomobject]@{ Id = "item-$_"; Value = $_ } }

        $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker `
            -InitializationScriptPath $initializer -Context @{ Seed = 17 } -MaxWorkers 2

        $tokens = @($run.Results | ForEach-Object { $_.Output[0].Token } | Sort-Object -Unique)
        $tokens.Count | Should -Be 2
        @($run.Results | ForEach-Object { $_.Output[0].Seed } | Sort-Object -Unique) | Should -Be 17
    }

    It 'captures warnings and item-local failures without losing other results' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'failure-worker.ps1') @'
param($Item, $Context, $RunspaceState)
if ($Item.Warn) { Write-Warning "warning-$($Item.Id)" }
if ($Item.Fail) { throw "failure-$($Item.Id)" }
$Item.Id
'@
        $items = @(
            [pscustomobject]@{ Id = 'good'; Warn = $true; Fail = $false }
            [pscustomobject]@{ Id = 'bad'; Warn = $false; Fail = $true }
            [pscustomobject]@{ Id = 'also-good'; Warn = $false; Fail = $false }
        )

        $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker -MaxWorkers 2

        $run.Results[0].State | Should -Be 'Succeeded'
        $run.Results[0].Warnings | Should -Contain 'warning-good'
        $run.Results[1].State | Should -Be 'Failed'
        $run.Results[1].Errors[0] | Should -Match 'failure-bad'
        $run.Results[2].State | Should -Be 'Succeeded'
        $run.Summary.Failed | Should -Be 1
    }

    It 'preloads requested modules into every worker session' {
        $module = Write-TestWorker (Join-Path $TestDrive 'BatchFixture.psm1') @'
function Get-BatchFixtureValue { 'module-ok' }
Export-ModuleMember -Function Get-BatchFixtureValue
'@
        $worker = Write-TestWorker (Join-Path $TestDrive 'module-worker.ps1') @'
param($Item, $Context, $RunspaceState)
Get-BatchFixtureValue
'@

        $run = Invoke-BatchExecutor -InputObject @('a', 'b') -ScriptPath $worker `
            -ModulePath $module -MaxWorkers 2

        $run.Summary.Succeeded | Should -Be 2
        @($run.Results | ForEach-Object { $_.Output[0] }) | Should -Be @('module-ok', 'module-ok')
    }

    It 'supports a bare initial session state for self-contained workers' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'bare-worker.ps1') @'
param($Item, $Context, $RunspaceState)
[System.Math]::Sqrt([double]$Item)
'@

        $run = Invoke-BatchExecutor -InputObject @(4, 9) -ScriptPath $worker -IssPreset Bare -MaxWorkers 2

        $run.Summary.Succeeded | Should -Be 2
        @($run.Results | ForEach-Object { $_.Output[0] }) | Should -Be @(2, 3)
    }

    It 'stops cooperative runspace work at the total batch timeout' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'runspace-timeout-worker.ps1') @'
param($Item, $Context, $RunspaceState)
Start-Sleep -Seconds 10
'done'
'@

        $run = Invoke-BatchExecutor -InputObject @('slow') -ScriptPath $worker `
            -WaitTimeoutSeconds 1 -MaxWorkers 1

        $run.Results[0].State | Should -Be 'TimedOut'
        $run.Results[0].Errors[0] | Should -Match 'total timeout'
        $run.Errors.Count | Should -Be 0
    }

    It 'can isolate mutable inputs and context with per-item serialized copies' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'copy-policy-worker.ps1') @'
param($Item, $Context, $RunspaceState, $CancellationToken)
$Item.Value++
$Context.Counter++
[pscustomobject]@{ ItemValue = $Item.Value; ContextCounter = $Context.Counter }
'@
        $context = [pscustomobject]@{ Counter = 0 }
        $items = 1..12 | ForEach-Object { [pscustomobject]@{ Id = "copy-$_"; Value = 0 } }

        $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker -MaxWorkers 4 `
            -Context $context -RunspaceDataPolicy PerItemCopy

        $run.Summary.Succeeded | Should -Be 12
        @($run.Results | ForEach-Object { $_.Output[0].ItemValue } | Sort-Object -Unique) | Should -Be 1
        @($run.Results | ForEach-Object { $_.Output[0].ContextCounter } | Sort-Object -Unique) | Should -Be 1
        $context.Counter | Should -Be 0
        @($items.Value | Sort-Object -Unique) | Should -Be 0
        $run.Policy.RunspaceData | Should -Be 'PerItemCopy'
    }

    It 'honors caller cancellation without converting completed siblings to failures' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'runspace-cancel-worker.ps1') @'
param($Item, $Context, $RunspaceState, $CancellationToken)
if ($Item.Fast) { Start-Sleep -Milliseconds 50; return $Item.Id }
while ($true) {
    $CancellationToken.ThrowIfCancellationRequested()
    Start-Sleep -Milliseconds 50
}
'@
        $items = @(
            [pscustomobject]@{ Id = 'completed'; Fast = $true }
            [pscustomobject]@{ Id = 'cancelled'; Fast = $false }
        )
        $cts = [System.Threading.CancellationTokenSource]::new()
        try {
            $cts.CancelAfter(400)
            $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker -MaxWorkers 2 `
                -CancellationToken $cts.Token
        }
        finally { $cts.Dispose() }

        $run.Results[0].State | Should -Be 'Succeeded'
        $run.Results[1].State | Should -Be 'Cancelled'
        $run.Summary.Succeeded | Should -Be 1
        $run.Summary.Cancelled | Should -Be 1
        $run.Summary.Failed | Should -Be 0
        $run.Errors.Count | Should -Be 0
    }

    It 'rejects duplicate caller-provided ids before dispatch' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'duplicate-worker.ps1') 'param($Item, $Context, $RunspaceState) $Item'
        $items = @([pscustomobject]@{ Id = 'same' }, [pscustomobject]@{ Id = 'same' })

        { Invoke-BatchExecutor -InputObject $items -ScriptPath $worker } |
            Should -Throw "*duplicate item id*"
    }
}

Describe 'Invoke-BatchExecutor - Process' {
    It 'runs every item in a clean child PowerShell and preserves CLIXML inputs' {
        $initializer = Write-TestWorker (Join-Path $TestDrive 'process-initializer.ps1') @'
param($Context)
[pscustomobject]@{ Initialized = "initialized-$($Context.Value)" }
'@
        $worker = Write-TestWorker (Join-Path $TestDrive 'process-worker.ps1') @'
param($Item, $Context, $RunspaceState)
[pscustomobject]@{
    Value = $Item.Value; ContextValue = $Context.Value
    Initialized = $RunspaceState.Initialized; Pid = $PID
    BatchJobId = $env:CODEX_BATCH_JOB_ID; EnvironmentValue = $env:BATCH_EXECUTOR_TEST
}

'@
        $items = 1..3 | ForEach-Object { [pscustomobject]@{ Id = "process-$_"; Value = $_ } }

        $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker -ExecutionMode Process `
            -InitializationScriptPath $initializer -Context ([pscustomobject]@{ Value = 'context-ok' }) `
            -ProcessEnvironment @{ BATCH_EXECUTOR_TEST = 'environment-ok' } `
            -CreateNoWindow:$true -WindowStyle Hidden -PriorityClass BelowNormal -IssPreset Bare -MaxWorkers 2

        $run.Summary.Succeeded | Should -Be 3
        @($run.Results | ForEach-Object { $_.Output[0].ContextValue } | Sort-Object -Unique) |
            Should -Be 'context-ok'
        @($run.Results | ForEach-Object { $_.Output[0].Initialized } | Sort-Object -Unique) |
            Should -Be 'initialized-context-ok'
        @($run.Results | ForEach-Object { $_.Output[0].Pid } | Sort-Object -Unique).Count | Should -Be 3
        $run.Results.ProcessId | Should -Not -Contain $PID
        $run.Results.ExitCode | Should -Be @(0, 0, 0)
        $run.Results.Output.BatchJobId | Should -Be @('process-1', 'process-2', 'process-3')
        @($run.Results.Output.EnvironmentValue | Sort-Object -Unique) | Should -Be 'environment-ok'
        $run.Policy.FailureAction | Should -Be 'Continue'
        $run.Policy.ChildProcess.CreateNoWindow | Should -BeTrue
        $run.Policy.ChildProcess.PriorityClass | Should -Be 'BelowNormal'
        $run.Policy.ChildProcess.EnvironmentKeys | Should -Contain 'BATCH_EXECUTOR_TEST'
    }

    It 'contains a failed child, captures its diagnostics and log, and completes siblings' {
        $worker = Write-TestWorker (Join-Path $TestDrive 'logged-failure-worker.ps1') @'
param($Item, $Context, $RunspaceState)
. $Context.LogLibrary
$null = Start-RunLog -Module batch-fixture -RunDir $Item.LogDir -ConsoleLevel off
try {
    Write-RunLog -Level info -Message "worker $($Item.Id) started"
    if ($Item.Fail) {
        Write-RunLog -Level error -Message "worker $($Item.Id) planned failure"
        throw "planned failure $($Item.Id)"
    }
    $Item.Id
}
finally { $null = Stop-RunLog }
'@
        $logRoot = Join-Path $TestDrive 'worker-logs'
        $items = @(
            [pscustomobject]@{ Id = 'good-1'; Fail = $false; LogDir = (Join-Path $logRoot 'good-1') }
            [pscustomobject]@{ Id = 'bad'; Fail = $true; LogDir = (Join-Path $logRoot 'bad') }
            [pscustomobject]@{ Id = 'good-2'; Fail = $false; LogDir = (Join-Path $logRoot 'good-2') }
        )

        $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker -ExecutionMode Process `
            -Context @{ LogLibrary = (Join-Path $PSScriptRoot '../../src/shared/log.ps1') } -MaxWorkers 2

        $run.Results.State | Should -Be @('Succeeded', 'Failed', 'Succeeded')
        ($run.Results[1].Errors -join "`n") | Should -Match 'planned failure bad'
        $run.Summary.Succeeded | Should -Be 2
        $run.Summary.Failed | Should -Be 1
        $run.Errors.Count | Should -Be 0
        $badLog = Join-Path $items[1].LogDir 'trace.jsonl'
        $badLog | Should -Exist
        (Get-Content -LiteralPath $badLog -Raw) | Should -Match 'planned failure'
    }

    It 'kills registered process trees and prevents queued children from starting on cancellation' {
        $worker = Write-ProcessTreeWorker (Join-Path $TestDrive 'cancelled-process-tree-worker.ps1')
        $items = 1..4 | ForEach-Object {
            [pscustomobject]@{
                Id = "cancel-child-$_"
                ChildPidPath = Join-Path $TestDrive "cancelled-child-$_.pid"
                GrandchildPidPath = Join-Path $TestDrive "cancelled-grandchild-$_.pid"
            }
        }
        $cts = [System.Threading.CancellationTokenSource]::new()
        $clock = [System.Diagnostics.Stopwatch]::StartNew()
        try {
            $cts.CancelAfter(2500)
            $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker -ExecutionMode Process `
                -CancellationToken $cts.Token -ProcessTimeoutSeconds 30 -MaxWorkers 2
        }
        finally { $clock.Stop(); $cts.Dispose() }

        $run.Results.State | Should -Be @('Cancelled', 'Cancelled', 'Cancelled', 'Cancelled')
        $run.Summary.Cancelled | Should -Be 4
        $run.Summary.Failed | Should -Be 0
        $run.Errors.Count | Should -Be 0
        $clock.Elapsed.TotalSeconds | Should -BeLessThan 8
        $startedPidFiles = @($items.ChildPidPath | Where-Object { Test-Path -LiteralPath $_ })
        $startedPidFiles.Count | Should -BeGreaterOrEqual 1
        $startedPidFiles.Count | Should -BeLessOrEqual 2
        foreach ($item in @($items | Where-Object { Test-Path -LiteralPath $_.ChildPidPath })) {
            $item.GrandchildPidPath | Should -Exist
            $childPid = [int](Get-Content -LiteralPath $item.ChildPidPath -Raw)
            $grandchildPid = [int](Get-Content -LiteralPath $item.GrandchildPidPath -Raw)
            (Test-ProcessExited -ProcessId $childPid) | Should -BeTrue
            (Test-ProcessExited -ProcessId $grandchildPid) | Should -BeTrue
        }
    }

    It 'kills a timed-out child process tree and reports the item timeout' {
        $worker = Write-ProcessTreeWorker (Join-Path $TestDrive 'child-timeout-tree-worker.ps1')
        $item = [pscustomobject]@{
            Id = 'child-timeout'
            ChildPidPath = Join-Path $TestDrive 'child-timeout.pid'
            GrandchildPidPath = Join-Path $TestDrive 'child-timeout-grandchild.pid'
        }

        $run = Invoke-BatchExecutor -InputObject @($item) -ScriptPath $worker -ExecutionMode Process `
            -ProcessTimeoutSeconds 2 -MaxWorkers 1

        $run.Results[0].State | Should -Be 'TimedOut'
        $run.Results[0].Errors[0] | Should -Match 'exceeded timeout'
        $run.Summary.TimedOut | Should -Be 1
        $item.ChildPidPath | Should -Exist
        $item.GrandchildPidPath | Should -Exist
        $childPid = [int](Get-Content -LiteralPath $item.ChildPidPath -Raw)
        $grandchildPid = [int](Get-Content -LiteralPath $item.GrandchildPidPath -Raw)
        (Test-ProcessExited -ProcessId $childPid) | Should -BeTrue
        (Test-ProcessExited -ProcessId $grandchildPid) | Should -BeTrue
    }

    It 'kills a process tree at the total batch wait timeout' {
        $worker = Write-ProcessTreeWorker (Join-Path $TestDrive 'batch-timeout-tree-worker.ps1')
        $item = [pscustomobject]@{
            Id = 'batch-timeout'
            ChildPidPath = Join-Path $TestDrive 'batch-timeout.pid'
            GrandchildPidPath = Join-Path $TestDrive 'batch-timeout-grandchild.pid'
        }

        $run = Invoke-BatchExecutor -InputObject @($item) -ScriptPath $worker -ExecutionMode Process `
            -WaitTimeoutSeconds 3 -ProcessTimeoutSeconds 30 -MaxWorkers 1

        $run.Results[0].State | Should -Be 'TimedOut'
        $run.Results[0].Errors -join "`n" | Should -Match 'batch wait exceeded'
        $run.Summary.TimedOut | Should -Be 1
        $item.ChildPidPath | Should -Exist
        $item.GrandchildPidPath | Should -Exist
        $childPid = [int](Get-Content -LiteralPath $item.ChildPidPath -Raw)
        $grandchildPid = [int](Get-Content -LiteralPath $item.GrandchildPidPath -Raw)
        (Test-ProcessExited -ProcessId $childPid) | Should -BeTrue
        (Test-ProcessExited -ProcessId $grandchildPid) | Should -BeTrue
    }

    It 'kills a process tree when the hosting PowerShell pipeline is stopped' {
        $worker = Write-ProcessTreeWorker (Join-Path $TestDrive 'pipeline-stop-tree-worker.ps1')
        $item = [pscustomobject]@{
            Id = 'pipeline-stop'
            ChildPidPath = Join-Path $TestDrive 'pipeline-stop.pid'
            GrandchildPidPath = Join-Path $TestDrive 'pipeline-stop-grandchild.pid'
        }
        $executorPath = (Resolve-Path (Join-Path $PSScriptRoot '../../src/shared/batch-executor.ps1')).Path
        $hostingPowerShell = [System.Management.Automation.PowerShell]::Create()
        $command = $hostingPowerShell.AddScript(@'
param($ExecutorPath, $WorkerPath, $Item)
. $ExecutorPath
Invoke-BatchExecutor -InputObject @($Item) -ScriptPath $WorkerPath -ExecutionMode Process `
    -ProcessTimeoutSeconds 30 -MaxWorkers 1 | Out-Null
'@)
        [void]$command.AddArgument($executorPath)
        [void]$command.AddArgument($worker)
        [void]$command.AddArgument($item)
        $async = $hostingPowerShell.BeginInvoke()
        $started = $false
        $stopwatch = [System.Diagnostics.Stopwatch]::new()
        try {
            $started = Wait-TestFile -Path $item.ChildPidPath
            $stopwatch.Start()
        }
        finally {
            try { $hostingPowerShell.Stop() } catch {}
            $stopwatch.Stop()
            if ($async.IsCompleted) { try { [void]$hostingPowerShell.EndInvoke($async) } catch {} }
            $hostingPowerShell.Dispose()
        }

        $started | Should -BeTrue
        $stopwatch.Elapsed.TotalSeconds | Should -BeLessThan 8
        $item.GrandchildPidPath | Should -Exist
        $childPid = [int](Get-Content -LiteralPath $item.ChildPidPath -Raw)
        $grandchildPid = [int](Get-Content -LiteralPath $item.GrandchildPidPath -Raw)
        (Test-ProcessExited -ProcessId $childPid) | Should -BeTrue
        (Test-ProcessExited -ProcessId $grandchildPid) | Should -BeTrue
    }
}
