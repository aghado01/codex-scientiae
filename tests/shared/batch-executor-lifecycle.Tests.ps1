#requires -Version 7.0

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../../src/shared/batch-executor/batch-executor.psd1') -Force

    function Write-LifecycleTestWorker {
        param([Parameter(Mandatory)] [string] $Path)
        Set-Content -LiteralPath $Path -Encoding utf8 -Value @'
param($Item, $Context, $RunspaceState, $CancellationToken)
$Item.Value
'@
        return (Resolve-Path -LiteralPath $Path).Path
    }
}

Describe 'batch-executor lifecycle owner and dispatch' {
    It 'publishes successful submissions as typed invocation records on the one lifecycle owner' {
        $worker = Write-LifecycleTestWorker (Join-Path $TestDrive 'dispatch-worker.ps1')

        InModuleScope 'batch-executor' -Parameters @{ Worker = $worker; Work = $TestDrive } {
            $preparation = Resolve-BatchExecutorPreparation `
                -InputObject @(@{ Id = 'dispatch'; Value = 42 }) -ScriptPath $Worker `
                -ExecutionMode Runspace -WorkingDirectory $Work -MaxWorkers 1
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
            try {
                Start-BatchExecutorInvocations -Lifecycle $lifecycle
                $lifecycle.Phase | Should -Be 'Dispatched'
                $lifecycle.Pool | Should -Not -BeNullOrEmpty
                $lifecycle.Invocations.Count | Should -Be 1
                $invocation = $lifecycle.Invocations[0]
                $invocation.PSObject.TypeNames[0] | Should -Be `
                    'CodexScientiae.BatchExecutor.Internal.InvocationState'
                $invocation.PreparedItem.Id | Should -Be 'dispatch'
                $invocation.Pipeline | Should -Not -BeNullOrEmpty
                $invocation.AsyncResult | Should -Not -BeNullOrEmpty
                $invocation.TerminalOverride | Should -BeNullOrEmpty
                [void]$invocation.AsyncResult.AsyncWaitHandle.WaitOne(5000)
                @($invocation.Pipeline.EndInvoke($invocation.AsyncResult))[-1].Output | Should -Be 42
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

    It 'keeps a partially opened pool visible so the exported owner closes and disposes it' {
        $worker = Write-LifecycleTestWorker (Join-Path $TestDrive 'pool-open-failure-worker.ps1')

        InModuleScope 'batch-executor' -Parameters @{ Worker = $worker; Work = $TestDrive } {
            $fakePool = [pscustomobject]@{
                ThreadOptions = $null
                ApartmentState = $null
                CloseCalled = $false
                DisposeCalled = $false
            }
            $fakePool | Add-Member -MemberType ScriptMethod -Name SetMinRunspaces `
                -Value { param($Count) return $true }
            $fakePool | Add-Member -MemberType ScriptMethod -Name SetMaxRunspaces `
                -Value { param($Count) return $true }
            $fakePool | Add-Member -MemberType ScriptMethod -Name Open `
                -Value { throw 'planned pool open failure' }
            $fakePool | Add-Member -MemberType ScriptMethod -Name Close `
                -Value { $this.CloseCalled = $true }
            $fakePool | Add-Member -MemberType ScriptMethod -Name Dispose `
                -Value { $this.DisposeCalled = $true }
            $script:BatchExecutorLifecycleTestPool = $fakePool
            try {
                Mock New-BatchExecutorRunspacePool {
                    param($Lifecycle)
                    $Lifecycle.Pool = $script:BatchExecutorLifecycleTestPool
                    return $Lifecycle.Pool
                }

                { Invoke-BatchExecutor -InputObject @(@{ Id = 'pool-failure'; Value = 1 }) `
                        -ScriptPath $Worker -ExecutionMode Runspace -WorkingDirectory $Work `
                        -MaxWorkers 1 } |
                    Should -Throw '*planned pool open failure*'
                Should -Invoke New-BatchExecutorRunspacePool -Times 1 -Exactly
                $fakePool.CloseCalled | Should -BeTrue
                $fakePool.DisposeCalled | Should -BeTrue
            }
            finally { Remove-Variable BatchExecutorLifecycleTestPool -Scope Script -ErrorAction SilentlyContinue }
        }
    }

    It 'keeps a pool visible when construction exits after publication' {
        $worker = Write-LifecycleTestWorker (Join-Path $TestDrive 'pool-construction-failure-worker.ps1')

        InModuleScope 'batch-executor' -Parameters @{ Worker = $worker; Work = $TestDrive } {
            $fakePool = [pscustomobject]@{
                CloseCalled = $false
                DisposeCalled = $false
            }
            $fakePool | Add-Member -MemberType ScriptMethod -Name Close `
                -Value { $this.CloseCalled = $true }
            $fakePool | Add-Member -MemberType ScriptMethod -Name Dispose `
                -Value { $this.DisposeCalled = $true }
            $script:BatchExecutorLifecycleTestPool = $fakePool
            try {
                Mock New-BatchExecutorRunspacePool {
                    param($Lifecycle)
                    $Lifecycle.Pool = $script:BatchExecutorLifecycleTestPool
                    throw 'planned pool construction failure'
                }

                { Invoke-BatchExecutor -InputObject @(@{ Id = 'pool-construction'; Value = 1 }) `
                        -ScriptPath $Worker -ExecutionMode Runspace -WorkingDirectory $Work `
                        -MaxWorkers 1 } |
                    Should -Throw '*planned pool construction failure*'
                Should -Invoke New-BatchExecutorRunspacePool -Times 1 -Exactly
                $fakePool.CloseCalled | Should -BeTrue
                $fakePool.DisposeCalled | Should -BeTrue
            }
            finally { Remove-Variable BatchExecutorLifecycleTestPool -Scope Script -ErrorAction SilentlyContinue }
        }
    }

    It 'disposes a pending pipeline when construction exits after publication' {
        $worker = Write-LifecycleTestWorker (Join-Path $TestDrive 'pipeline-bind-failure-worker.ps1')

        InModuleScope 'batch-executor' -Parameters @{ Worker = $worker; Work = $TestDrive } {
            $probeName = 'BatchExecutorLifecyclePipelineDisposed'
            [System.AppDomain]::CurrentDomain.SetData($probeName, $false)
            $fakePipeline = [pscustomobject]@{}
            $fakePipeline | Add-Member -MemberType ScriptMethod -Name Dispose -Value {
                [System.AppDomain]::CurrentDomain.SetData(
                    'BatchExecutorLifecyclePipelineDisposed', $true)
            }
            $global:BatchExecutorLifecycleTestPipeline = $fakePipeline
            try {
                Mock New-BatchExecutorPipeline {
                    param($Lifecycle)
                    $Lifecycle.PendingPipeline = $global:BatchExecutorLifecycleTestPipeline
                    throw 'planned pipeline construction failure'
                }

                $run = Invoke-BatchExecutor -InputObject @(@{ Id = 'bind-failure'; Value = 1 }) `
                    -ScriptPath $Worker -ExecutionMode Runspace -WorkingDirectory $Work `
                    -MaxWorkers 1

                Should -Invoke New-BatchExecutorPipeline -Times 1 -Exactly
                $run.Summary.Failed | Should -Be 1
                $run.Results[0].Errors[0] | Should -Match 'planned pipeline construction failure'
                [System.AppDomain]::CurrentDomain.GetData($probeName) | Should -BeTrue
            }
            finally {
                Remove-Variable BatchExecutorLifecycleTestPipeline -Scope Global `
                    -ErrorAction SilentlyContinue
                [System.AppDomain]::CurrentDomain.SetData($probeName, $null)
            }
        }
    }

    It 'retains a pending pipeline when dispatch cannot confirm its disposal' {
        $worker = Write-LifecycleTestWorker (Join-Path $TestDrive 'pipeline-disposal-failure-worker.ps1')

        InModuleScope 'batch-executor' -Parameters @{ Worker = $worker; Work = $TestDrive } {
            $fakePipeline = [pscustomobject]@{}
            $fakePipeline | Add-Member -MemberType ScriptMethod -Name Dispose `
                -Value { throw 'planned pipeline disposal failure' }
            $global:BatchExecutorLifecycleTestPipeline = $fakePipeline
            $lifecycle = $null
            try {
                $preparation = Resolve-BatchExecutorPreparation `
                    -InputObject @(@{ Id = 'disposal-failure'; Value = 1 }) -ScriptPath $Worker `
                    -ExecutionMode Runspace -WorkingDirectory $Work -MaxWorkers 1
                $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation
                Mock New-BatchExecutorPipeline {
                    param($Lifecycle)
                    $Lifecycle.PendingPipeline = $global:BatchExecutorLifecycleTestPipeline
                    throw 'planned pipeline construction failure'
                }

                { Start-BatchExecutorInvocations -Lifecycle $lifecycle } |
                    Should -Throw '*cannot enter Dispatched*pending pipeline*'
                [object]::ReferenceEquals(
                    $lifecycle.PendingPipeline, $fakePipeline) | Should -BeTrue
                $lifecycle.InfrastructureErrors | Should -Match `
                    'pipeline disposal failed:.*planned pipeline disposal failure'

                @(Stop-BatchExecutorLifecycle -Lifecycle $lifecycle).Count | Should -Be 0
                $lifecycle.Phase | Should -Be 'TearingDown'
                $lifecycle.TeardownCompleted | Should -BeFalse
                [object]::ReferenceEquals(
                    $lifecycle.PendingPipeline, $fakePipeline) | Should -BeTrue
            }
            finally {
                Remove-Variable BatchExecutorLifecycleTestPipeline -Scope Global `
                    -ErrorAction SilentlyContinue
                if ($null -ne $lifecycle -and $null -ne $lifecycle.Pool) {
                    try { $lifecycle.Pool.Close() } catch {}
                    try { $lifecycle.Pool.Dispose() } catch {}
                }
            }
        }
    }

    It 'projects the exact public execution shape without lifecycle resources' {
        $worker = Write-LifecycleTestWorker (Join-Path $TestDrive 'projection-worker.ps1')
        $item = @{ Id = 'projection'; Value = 7 }

        $run = Invoke-BatchExecutor -InputObject @($item) -ScriptPath $worker `
            -ExecutionMode Runspace -WorkingDirectory $TestDrive -MaxWorkers 1

        $run.PSObject.Properties.Name | Should -Be @(
            'Results', 'Errors', 'Warnings', 'Budget', 'Policy', 'Timing', 'Summary')
        $run.Timing.PSObject.Properties.Name | Should -Be @(
            'PoolOpenMs', 'DispatchMs', 'WaitMs', 'CollectMs', 'TotalMs')
        $run.Summary.PSObject.Properties.Name | Should -Be @(
            'Total', 'Succeeded', 'Failed', 'TimedOut', 'Cancelled')
        $run.Results[0].PSObject.Properties.Name | Should -Be @(
            'Id', 'Index', 'Input', 'State', 'Output', 'Errors', 'Warnings', 'Information',
            'QueuedUtc', 'StartedUtc', 'EndedUtc', 'DurationMs', 'RunspaceId', 'ThreadId',
            'ProcessId', 'ExitCode', 'StdOut', 'StdErr')
        @($run.PSObject.Properties.Name | Where-Object {
                $_ -in @('Preparation', 'Phase', 'Pool', 'Invocations', 'ChildProcessRegistry',
                    'PendingPipeline', 'WaitOutcome', 'CompletedNormally', 'TeardownCompleted')
            }).Count | Should -Be 0
        $run.Results[0].Input.Value = 8
        $item.Value | Should -Be 8
    }
}
