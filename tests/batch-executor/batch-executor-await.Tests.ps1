#requires -Version 7.0

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../../src/batch-executor/batch-executor.psd1') -Force

    function Write-AwaitTestWorker {
        param([Parameter(Mandatory)] [string] $Path, [Parameter(Mandatory)] [string] $Body)
        Set-Content -LiteralPath $Path -Encoding utf8 -Value $Body
        return (Resolve-Path -LiteralPath $Path).Path
    }
}

Describe 'batch-executor interruptible await and cancellation' {
    It 'records one typed completed outcome before entering the awaited phase' {
        $worker = Write-AwaitTestWorker -Path (Join-Path $TestDrive 'await-completed-worker.ps1') `
            -Body 'param($Item, $Context, $RunspaceState, $CancellationToken); $Item.Value'

        InModuleScope 'batch-executor' -Parameters @{ Worker = $worker; Work = $TestDrive } {
            $preparation = Resolve-BatchExecutorPreparation `
                -InputObject @(@{ Id = 'completed'; Value = 42 }) -ScriptPath $Worker `
                -ExecutionMode Runspace -WorkingDirectory $Work -MaxWorkers 1
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
            try {
                Start-BatchExecutorInvocations -Lifecycle $lifecycle
                Wait-BatchExecutorInvocations -Lifecycle $lifecycle

                $lifecycle.Phase | Should -Be 'Awaited'
                $lifecycle.WaitOutcome.PSObject.TypeNames[0] | Should -Be `
                    'CodexScientiae.BatchExecutor.Internal.WaitOutcome'
                $lifecycle.WaitOutcome.Kind | Should -Be 'Completed'
                $lifecycle.Timing.Contains('WaitMs') | Should -BeTrue
                $lifecycle.Invocations[0].TerminalOverride | Should -BeNullOrEmpty
            }
            finally {
                Stop-BatchExecutorPipelines -Invocations $lifecycle.Invocations
                foreach ($invocation in $lifecycle.Invocations) {
                    try { $invocation.Pipeline.Dispose() } catch {}
                }
                if ($null -ne $lifecycle.Pool) {
                    try { $lifecycle.Pool.Close() } catch {}
                    try { $lifecycle.Pool.Dispose() } catch {}
                }
            }
        }
    }

    It 'starts no child process when the caller token is already cancelled' {
        $worker = Write-AwaitTestWorker -Path (Join-Path $TestDrive 'already-cancelled-worker.ps1') `
            -Body @'
param($Item, $Context, $RunspaceState, $CancellationToken)
[System.IO.File]::WriteAllText([string]$Item.ProcessMarkerPath, [string]$PID)
$Item.Id
'@
        $items = 1..4 | ForEach-Object {
            [pscustomobject]@{
                Id = "already-cancelled-$_"
                ProcessMarkerPath = Join-Path $TestDrive "already-cancelled-$_.pid"
            }
        }
        $cts = [System.Threading.CancellationTokenSource]::new()
        try {
            $cts.Cancel()
            $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker `
                -ExecutionMode Process -CancellationToken $cts.Token `
                -ProcessTimeoutSeconds 30 -MaxWorkers 2
        }
        finally { $cts.Dispose() }

        $run.Results.State | Should -Be @('Cancelled', 'Cancelled', 'Cancelled', 'Cancelled')
        $run.Summary.Cancelled | Should -Be 4
        $run.Summary.Failed | Should -Be 0
        $run.Errors.Count | Should -Be 0
        @($items.ProcessMarkerPath | Where-Object { Test-Path -LiteralPath $_ }).Count |
            Should -Be 0
    }
}
