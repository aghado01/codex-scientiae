#requires -Version 7.5

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../../src/batch-executor/batch-executor.psd1') -Force

    function Write-TeardownTestWorker {
        param([Parameter(Mandatory)] [string] $Path)
        Set-Content -LiteralPath $Path -Encoding utf8 -Value @'
param($Item, $Context, $RunspaceState, $CancellationToken)
$Item.Value
'@
        return (Resolve-Path -LiteralPath $Path).Path
    }
}

Describe 'batch-executor teardown and final assembly' {
    It 'keeps the exported owner as one lexical try/finally phase orchestrator' {
        $publicPath = Join-Path $PSScriptRoot `
            '../../src/batch-executor/public/Invoke-BatchExecutor.ps1'
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            (Resolve-Path -LiteralPath $publicPath).Path, [ref]$tokens, [ref]$parseErrors)
        $parseErrors.Count | Should -Be 0
        $functionAst = $ast.Find({
                param($node)
                $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
                    $node.Name -eq 'Invoke-BatchExecutor'
            }, $true)
        $tryStatements = @($functionAst.Body.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.TryStatementAst]
                }, $true))

        $tryStatements.Count | Should -Be 1
        $tryStatements[0].Finally | Should -Not -BeNullOrEmpty
        $body = $functionAst.Body.Extent.Text
        $body | Should -Match 'Start-BatchExecutorInvocations'
        $body | Should -Match 'Wait-BatchExecutorInvocations'
        $body | Should -Match 'Receive-BatchExecutorResults'
        $body | Should -Match 'Stop-BatchExecutorLifecycle'
        $body | Should -Not -Match '\b(?:BeginInvoke|EndInvoke|WaitAny|CreateRunspacePool)\b'
    }

    It 'releases and clears execution handles before entering Closed' {
        $worker = Write-TeardownTestWorker (Join-Path $TestDrive 'teardown-worker.ps1')

        InModuleScope 'batch-executor' -Parameters @{ Worker = $worker; Work = $TestDrive } {
            $preparation = Resolve-BatchExecutorPreparation `
                -InputObject @(@{ Id = 'teardown'; Value = 42 }) -ScriptPath $Worker `
                -ExecutionMode Runspace -WorkingDirectory $Work -MaxWorkers 1
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
            Start-BatchExecutorInvocations -Lifecycle $lifecycle
            Wait-BatchExecutorInvocations -Lifecycle $lifecycle
            Receive-BatchExecutorResults -Lifecycle $lifecycle

            @(Stop-BatchExecutorLifecycle -Lifecycle $lifecycle).Count | Should -Be 0
            $lifecycle.Phase | Should -Be 'Closed'
            $lifecycle.TeardownCompleted | Should -BeTrue
            $lifecycle.Pool | Should -BeNullOrEmpty
            $lifecycle.PendingPipeline | Should -BeNullOrEmpty
            $lifecycle.Invocations[0].Pipeline | Should -BeNullOrEmpty
            $lifecycle.Invocations[0].AsyncResult | Should -BeNullOrEmpty
            $lifecycle.Invocations[0].InvocationTask | Should -BeNullOrEmpty
            $lifecycle.ChildProcessRegistry.Count | Should -Be 0

            # Closed teardown is idempotent and remains silent.
            @(Stop-BatchExecutorLifecycle -Lifecycle $lifecycle).Count | Should -Be 0
        }
    }

    It 'projects a final record only after teardown without exposing lifecycle state' {
        $worker = Write-TeardownTestWorker (Join-Path $TestDrive 'assembly-worker.ps1')

        InModuleScope 'batch-executor' -Parameters @{ Worker = $worker; Work = $TestDrive } {
            $preparation = Resolve-BatchExecutorPreparation `
                -InputObject @(@{ Id = 'assembly'; Value = 7 }) -ScriptPath $Worker `
                -ExecutionMode Runspace -WorkingDirectory $Work -MaxWorkers 1
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
            { New-BatchExecutorExecutionRecord -Lifecycle $lifecycle } |
                Should -Throw '*requires a closed lifecycle*'

            Start-BatchExecutorInvocations -Lifecycle $lifecycle
            Wait-BatchExecutorInvocations -Lifecycle $lifecycle
            Receive-BatchExecutorResults -Lifecycle $lifecycle
            Stop-BatchExecutorLifecycle -Lifecycle $lifecycle
            $lifecycle.Timing['TotalMs'] = 123
            $record = New-BatchExecutorExecutionRecord -Lifecycle $lifecycle

            $record.PSObject.Properties.Name | Should -Be @(
                'Results', 'Errors', 'Warnings', 'Budget', 'Policy', 'Timing', 'Summary',
                'Cleanup', 'Runtime')
            $record.Timing.PSObject.Properties.Name | Should -Be @(
                'PrepareMs', 'PoolOpenMs', 'DispatchMs', 'WaitMs', 'CollectMs', 'CleanupMs', 'TotalMs')
            $record.Summary.PSObject.Properties.Name | Should -Be @(
                'Total', 'Succeeded', 'Failed', 'TimedOut', 'Cancelled')
            $record.Summary.Total | Should -Be 1
            $record.Summary.Succeeded | Should -Be 1
            @($record.PSObject.Properties.Name | Where-Object {
                    $_ -in @('Preparation', 'Phase', 'Pool', 'PendingPipeline', 'Invocations',
                        'ChildProcessRegistry', 'WaitOutcome', 'CompletedNormally', 'TeardownCompleted')
                }).Count | Should -Be 0
        }
    }

    It 'retains and diagnoses a handle whose disposal cannot be confirmed' {
        if (-not ('TeardownFailureFixture' -as [type])) {
            Add-Type 'public sealed class TeardownFailureFixture : System.IDisposable { public void Dispose() { throw new System.Exception("planned pool disposal failure"); } }'
        }
        InModuleScope 'batch-executor' {
            $preparation = New-BatchExecutorPreparation -Item @() -ExecutionMode Runspace `
                -WorkerDefinition ([pscustomobject]@{ Path = 'worker'; Body = 'body' }) -IssPreset Core `
                -Budget ([pscustomobject]@{ Threads = 0; Warnings = @() }) `
                -Policy ([pscustomobject]@{ FailureAction = 'Continue' })
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
            $fakePool = [TeardownFailureFixture]::new()
            $lifecycle.Pool = $fakePool
            $lifecycle.CompletedNormally = $true

            @(Stop-BatchExecutorLifecycle -Lifecycle $lifecycle).Count | Should -Be 0
            $lifecycle.Phase | Should -Be 'TearingDown'
            $lifecycle.TeardownCompleted | Should -BeFalse
            $lifecycle.Cleanup.State | Should -Be 'Incomplete'
            [object]::ReferenceEquals($lifecycle.Pool, $fakePool) | Should -BeTrue
            $lifecycle.InfrastructureErrors -join "`n" | Should -Match `
                'managed disposal failed:.*planned pool disposal failure'
            $record = New-BatchExecutorExecutionRecord -Lifecycle $lifecycle
            $record.Cleanup.State | Should -Be 'Incomplete'
            $record.Results.Count | Should -Be 0
        }
    }
}
