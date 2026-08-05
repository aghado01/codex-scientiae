#requires -Version 7.0

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../../src/shared/batch-executor/batch-executor.psd1') -Force

    function Write-CollectionTestWorker {
        param([Parameter(Mandatory)] [string] $Path)
        Set-Content -LiteralPath $Path -Encoding utf8 -Value @'
param($Item, $Context, $RunspaceState, $CancellationToken)
$Item.Value
'@
        return (Resolve-Path -LiteralPath $Path).Path
    }
}

Describe 'batch-executor result collection' {
    It 'materializes the exact result contract in stable order with original input identity' {
        $worker = Write-CollectionTestWorker (Join-Path $TestDrive 'collection-worker.ps1')
        $original = [pscustomobject]@{ Id = 'identity'; Value = 42 }

        InModuleScope 'batch-executor' -Parameters @{
            Worker = $worker
            Work = $TestDrive
            Original = $original
        } {
            $preparation = Resolve-BatchExecutorPreparation -InputObject @($Original) `
                -ScriptPath $Worker -ExecutionMode Runspace -WorkingDirectory $Work -MaxWorkers 1
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
            try {
                Start-BatchExecutorInvocations -Lifecycle $lifecycle
                Wait-BatchExecutorInvocations -Lifecycle $lifecycle
                Receive-BatchExecutorResults -Lifecycle $lifecycle

                $lifecycle.Phase | Should -Be 'Collected'
                $lifecycle.CompletedNormally | Should -BeTrue
                $lifecycle.Timing.Contains('CollectMs') | Should -BeTrue
                $result = $lifecycle.Results[0]
                $result.PSObject.Properties.Name | Should -Be @(
                    'Id', 'Index', 'Input', 'State', 'Output', 'Errors', 'Warnings', 'Information',
                    'QueuedUtc', 'StartedUtc', 'EndedUtc', 'DurationMs', 'RunspaceId', 'ThreadId',
                    'ProcessId', 'ExitCode', 'StdOut', 'StdErr')
                $result.Id | Should -Be 'identity'
                $result.Index | Should -Be 0
                $result.State | Should -Be 'Succeeded'
                $result.Output | Should -Be @(42)
                [object]::ReferenceEquals($result.Input, $Original) | Should -BeTrue
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

    It 'contains one collection failure and still materializes its sibling by original index' {
        $worker = Write-CollectionTestWorker (Join-Path $TestDrive 'collection-failure-worker.ps1')

        InModuleScope 'batch-executor' -Parameters @{ Worker = $worker; Work = $TestDrive } {
            $items = @(
                [pscustomobject]@{ Id = 'broken-collection'; Value = 1 }
                [pscustomobject]@{ Id = 'good-collection'; Value = 2 }
            )
            $preparation = Resolve-BatchExecutorPreparation -InputObject $items `
                -ScriptPath $Worker -ExecutionMode Runspace -WorkingDirectory $Work -MaxWorkers 2
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
            try {
                Start-BatchExecutorInvocations -Lifecycle $lifecycle
                Wait-BatchExecutorInvocations -Lifecycle $lifecycle
                # A completed async result from another operation deterministically makes EndInvoke
                # fail for this pipeline without corrupting the sibling invocation.
                $lifecycle.Invocations[0].AsyncResult = [System.Threading.Tasks.Task]::CompletedTask
                Receive-BatchExecutorResults -Lifecycle $lifecycle

                $lifecycle.Results.Id | Should -Be @('broken-collection', 'good-collection')
                $lifecycle.Results.State | Should -Be @('Failed', 'Succeeded')
                $lifecycle.Results[1].Output | Should -Be @(2)
                $lifecycle.InfrastructureErrors.Count | Should -Be 1
                $lifecycle.InfrastructureErrors[0] | Should -Match `
                    "item 'broken-collection' collection failed"
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

    It 'contains a post-EndInvoke normalization failure and continues later siblings' {
        if ($null -eq ('BatchExecutorThrowingInformationText' -as [type])) {
            Add-Type -TypeDefinition @'
public sealed class BatchExecutorThrowingInformationText
{
    public override string ToString()
    {
        throw new System.InvalidOperationException("planned information conversion failure");
    }
}
'@
        }
        $worker = Join-Path $TestDrive 'collection-normalization-worker.ps1'
        Set-Content -LiteralPath $worker -Encoding utf8 -Value @'
param($Item, $Context, $RunspaceState, $CancellationToken)
if ($null -ne $Item.InformationPayload) {
    Write-Information -MessageData $Item.InformationPayload
}
$Item.Value
'@
        $items = @(
            [pscustomobject]@{
                Id = 'broken-normalization'
                Value = 1
                InformationPayload = [BatchExecutorThrowingInformationText]::new()
            }
            [pscustomobject]@{
                Id = 'good-normalization'
                Value = 2
                InformationPayload = $null
            }
        )

        $run = Invoke-BatchExecutor -InputObject $items -ScriptPath $worker `
            -ExecutionMode Runspace -WorkingDirectory $TestDrive -MaxWorkers 2

        $run.Results.Id | Should -Be @('broken-normalization', 'good-normalization')
        $run.Results.State | Should -Be @('Failed', 'Succeeded')
        $run.Results[0].Errors -join "`n" | Should -Match 'planned information conversion failure'
        $run.Results[1].Output | Should -Be @(2)
        $run.Errors.Count | Should -Be 1
        $run.Errors[0] | Should -Match "item 'broken-normalization' collection failed"
    }
}
