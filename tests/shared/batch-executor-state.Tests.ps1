#requires -Version 7.0

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../../src/shared/batch-executor/batch-executor.psd1') -Force
}

Describe 'batch-executor private phase-state contracts' {
    It 'separates direct dispatch data from process dispatch material' {
        InModuleScope 'batch-executor' {
            $input = @{ Id = 'direct'; Value = 1 }
            $context = [pscustomobject]@{ Name = 'context' }
            $direct = New-BatchExecutorPreparedItem -Index 0 -Id direct -Mode Runspace `
                -OriginalInput $input -DispatchItem $input -DispatchContext $context
            $spec = New-BatchExecutorResolvedProcessSpec -PowerShellPath 'pwsh' `
                -WorkingDirectory 'work'
            $process = New-BatchExecutorPreparedItem -Index 1 -Id process -Mode Process `
                -OriginalInput ([pscustomobject]@{ Id = 'process' }) -ProcessPayloadXml '<Objs />' `
                -ProcessSpec $spec

            $direct.PSObject.TypeNames[0] | Should -Be `
                'CodexScientiae.BatchExecutor.Internal.PreparedItem'
            $direct.PSObject.Properties.Name | Should -Be @(
                'Index', 'Id', 'Mode', 'Input', 'DispatchItem', 'DispatchContext',
                'ProcessPayloadXml', 'ProcessSpec')
            $direct.Input.Value = 2
            $input.Value | Should -Be 2
            $direct.DispatchItem.Value | Should -Be 2
            $direct.ProcessPayloadXml | Should -BeNullOrEmpty
            $direct.ProcessSpec | Should -BeNullOrEmpty

            $process.DispatchItem | Should -BeNullOrEmpty
            $process.DispatchContext | Should -BeNullOrEmpty
            $process.ProcessPayloadXml | Should -Be '<Objs />'
            $process.ProcessSpec.PSObject.TypeNames[0] | Should -Be `
                'CodexScientiae.BatchExecutor.Internal.ResolvedProcessSpec'
        }
    }

    It 'rejects mode-crossing prepared-item fields' {
        InModuleScope 'batch-executor' {
            $spec = New-BatchExecutorResolvedProcessSpec -PowerShellPath 'pwsh' `
                -WorkingDirectory 'work'

            { New-BatchExecutorPreparedItem -Index 0 -Id direct -Mode Runspace -OriginalInput 1 `
                    -ProcessPayloadXml '<Objs />' -ProcessSpec $spec } |
                Should -Throw '*must not contain process dispatch material*'
            { New-BatchExecutorPreparedItem -Index 0 -Id process -Mode Process -OriginalInput 1 } |
                Should -Throw '*requires payload XML and a resolved process specification*'
            { New-BatchExecutorPreparedItem -Index 0 -Id process -Mode Process -OriginalInput 1 `
                    -DispatchItem 1 -ProcessPayloadXml '<Objs />' -ProcessSpec $spec } |
                Should -Throw '*must not retain direct dispatch data*'
        }
    }

    It 'freezes one dispatch-ready preparation without runtime ownership' {
        InModuleScope 'batch-executor' {
            $direct = New-BatchExecutorPreparedItem -Index 0 -Id direct -Mode Runspace `
                -OriginalInput 1 -DispatchItem 1 -DispatchContext $null
            $environment = @{ B = 'two'; A = 'one' }
            $modules = [string[]]@('one', 'two')
            $spec = New-BatchExecutorResolvedProcessSpec -PowerShellPath 'pwsh' `
                -WorkingDirectory 'work' -Environment $environment
            $process = New-BatchExecutorPreparedItem -Index 1 -Id process -Mode Process `
                -OriginalInput 2 -ProcessPayloadXml '<Objs />' -ProcessSpec $spec
            $iss = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault2()
            $preparation = New-BatchExecutorPreparation -Item @($direct, $process) `
                -ExecutionMode Mixed -WorkerDefinition ([pscustomobject]@{ Path = 'worker'; Body = 'body' }) `
                -IssPreset Core -ModulePath $modules -Budget ([pscustomobject]@{ Threads = 2 }) `
                -Policy ([pscustomobject]@{ FailureAction = 'Continue' }) -InitialSessionState $iss `
                -EncodedChildCommand 'encoded'
            $environment.A = 'changed'
            $modules[0] = 'changed'

            $preparation.PSObject.TypeNames[0] | Should -Be `
                'CodexScientiae.BatchExecutor.Internal.ExecutionPreparation'
            $preparation.PSObject.Properties.Name | Should -Be @(
                'ItemCount', 'Items', 'ExecutionMode', 'HasRunspaceItems', 'HasProcessItems',
                'WorkerDefinition', 'InitializerDefinition', 'IssPreset', 'ModulePath', 'Budget',
                'Policy', 'CancellationToken', 'WaitTimeoutSeconds', 'WaitSliceMilliseconds',
                'ProcessDrainMilliseconds', 'InitialSessionState', 'EncodedChildCommand')
            $preparation.ItemCount | Should -Be 2
            $preparation.HasRunspaceItems | Should -BeTrue
            $preparation.HasProcessItems | Should -BeTrue
            $preparation.WaitSliceMilliseconds | Should -Be 200
            $preparation.ProcessDrainMilliseconds | Should -Be 5000
            $preparation.ModulePath | Should -Be @('one', 'two')
            $preparation.Items[1].ProcessSpec.Environment.A | Should -Be 'one'
            @($preparation.PSObject.Properties.Name | Where-Object {
                    $_ -in @('Pool', 'Invocations', 'Results', 'ChildProcessRegistry',
                        'InfrastructureErrors', 'Timing') }).Count | Should -Be 0
        }
    }

    It 'makes one lifecycle record the only mutable execution-resource owner' {
        InModuleScope 'batch-executor' {
            $item = New-BatchExecutorPreparedItem -Index 0 -Id direct -Mode Runspace `
                -OriginalInput 1 -DispatchItem 1 -DispatchContext $null
            $preparation = New-BatchExecutorPreparation -Item @($item) -ExecutionMode Runspace `
                -WorkerDefinition ([pscustomobject]@{ Path = 'worker'; Body = 'body' }) -IssPreset Core `
                -Budget ([pscustomobject]@{ Threads = 1 }) `
                -Policy ([pscustomobject]@{ FailureAction = 'Continue' }) `
                -InitialSessionState ([System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault2())
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation

            $lifecycle.PSObject.TypeNames[0] | Should -Be `
                'CodexScientiae.BatchExecutor.Internal.LifecycleState'
            $lifecycle.PSObject.Properties.Name | Should -Be @(
                'Preparation', 'Phase', 'Pool', 'PendingPipeline', 'Invocations', 'Results',
                'ChildProcessRegistry', 'InfrastructureErrors', 'Timing', 'WaitOutcome', 'CompletedNormally',
                'TeardownCompleted')
            $lifecycle.Phase | Should -Be 'Prepared'
            $lifecycle.PendingPipeline | Should -BeNullOrEmpty
            $lifecycle.Invocations.GetType().GetGenericTypeDefinition() | Should -Be `
                ([System.Collections.Generic.List``1])
            $lifecycle.Results.Count | Should -Be 1
            $lifecycle.ChildProcessRegistry.Count | Should -Be 0
            $lifecycle.CompletedNormally | Should -BeFalse
            $lifecycle.TeardownCompleted | Should -BeFalse
        }
    }

    It 'rejects preparation records whose items contradict the invocation mode' {
        InModuleScope 'batch-executor' {
            $spec = New-BatchExecutorResolvedProcessSpec -PowerShellPath 'pwsh' `
                -WorkingDirectory 'work'
            $item = New-BatchExecutorPreparedItem -Index 0 -Id process -Mode Process `
                -OriginalInput 1 -ProcessPayloadXml '<Objs />' -ProcessSpec $spec

            { New-BatchExecutorPreparation -Item @($item) -ExecutionMode Runspace `
                    -WorkerDefinition ([pscustomobject]@{ Path = 'worker'; Body = 'body' }) `
                    -IssPreset Core -Budget ([pscustomobject]@{ Threads = 1 }) `
                    -Policy ([pscustomobject]@{ FailureAction = 'Continue' }) `
                    -InitialSessionState ([System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault2()) `
                    -EncodedChildCommand encoded } |
                Should -Throw "*do not match execution mode 'Runspace'*"
        }
    }

    It 'allows only the frozen lifecycle transition graph' {
        InModuleScope 'batch-executor' {
            $preparation = New-BatchExecutorPreparation -Item @() -ExecutionMode Runspace `
                -WorkerDefinition ([pscustomobject]@{ Path = 'worker'; Body = 'body' }) -IssPreset Core `
                -Budget ([pscustomobject]@{ Threads = 0 }) `
                -Policy ([pscustomobject]@{ FailureAction = 'Continue' })
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation

            { Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Awaiting } |
                Should -Throw '*Prepared -> Awaiting*'
            foreach ($phase in @(
                    'Dispatching', 'Dispatched', 'Awaiting')) {
                Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase $phase
                $lifecycle.Phase | Should -Be $phase
            }
            $lifecycle.WaitOutcome = New-BatchExecutorWaitOutcome -Kind Completed
            foreach ($phase in @('Awaited', 'Collecting', 'Collected', 'TearingDown')) {
                Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase $phase
                $lifecycle.Phase | Should -Be $phase
            }
            $lifecycle.TeardownCompleted = $true
            Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Closed
            $lifecycle.Phase | Should -Be 'Closed'
            { Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase TearingDown } |
                Should -Throw '*Closed -> TearingDown*'
        }
    }

    It 'rejects phase exits whose required lifecycle artifacts are missing' {
        InModuleScope 'batch-executor' {
            $item = New-BatchExecutorPreparedItem -Index 0 -Id direct -Mode Runspace `
                -OriginalInput 1 -DispatchItem 1 -DispatchContext $null
            $preparation = New-BatchExecutorPreparation -Item @($item) -ExecutionMode Runspace `
                -WorkerDefinition ([pscustomobject]@{ Path = 'worker'; Body = 'body' }) -IssPreset Core `
                -Budget ([pscustomobject]@{ Threads = 1 }) `
                -Policy ([pscustomobject]@{ FailureAction = 'Continue' }) `
                -InitialSessionState ([System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault2())
            $lifecycle = New-BatchExecutorLifecycleState -Preparation $preparation

            Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Dispatching
            { Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Dispatched } |
                Should -Throw '*unaccounted prepared items*'

            $lifecycle.Results[0] = [pscustomobject]@{ State = 'Failed' }
            Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Dispatched
            Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Awaiting
            { Set-BatchExecutorLifecyclePhase -Lifecycle $lifecycle -Phase Awaited } |
                Should -Throw '*typed wait outcome*'

            $closedPreparation = New-BatchExecutorPreparation -Item @() -ExecutionMode Runspace `
                -WorkerDefinition ([pscustomobject]@{ Path = 'worker'; Body = 'body' }) -IssPreset Core `
                -Budget ([pscustomobject]@{ Threads = 0 }) `
                -Policy ([pscustomobject]@{ FailureAction = 'Continue' })
            $closedLifecycle = New-BatchExecutorLifecycleState -Preparation $closedPreparation
            $closedLifecycle.Phase = 'TearingDown'
            $closedLifecycle.TeardownCompleted = $true
            $closedLifecycle.Pool = [pscustomobject]@{ Name = 'retained-pool' }
            { Set-BatchExecutorLifecyclePhase -Lifecycle $closedLifecycle -Phase Closed } |
                Should -Throw '*retains the runspace pool*'
        }
    }

    It 'uses one terminal override and one explicit wait outcome' {
        InModuleScope 'batch-executor' {
            $item = New-BatchExecutorPreparedItem -Index 0 -Id direct -Mode Runspace `
                -OriginalInput 1 -DispatchItem 1 -DispatchContext $null
            $pipeline = [System.Management.Automation.PowerShell]::Create()
            try {
                $invocation = New-BatchExecutorInvocationState -PreparedItem $item -Pipeline $pipeline `
                    -AsyncResult ([System.Threading.Tasks.Task]::CompletedTask) -QueuedUtc ([datetime]::UtcNow)
                Set-BatchExecutorInvocationTerminalOverride -Invocation $invocation -State Cancelled
                Set-BatchExecutorInvocationTerminalOverride -Invocation $invocation -State Cancelled

                $invocation.PSObject.Properties.Name | Should -Be @(
                    'PreparedItem', 'Pipeline', 'AsyncResult', 'QueuedUtc', 'TerminalOverride')
                $invocation.TerminalOverride | Should -Be 'Cancelled'
                { Set-BatchExecutorInvocationTerminalOverride -Invocation $invocation -State TimedOut } |
                    Should -Throw "*already 'Cancelled'*"
                $outcome = New-BatchExecutorWaitOutcome -Kind CallerCancellation
                $outcome.PSObject.TypeNames[0] | Should -Be `
                    'CodexScientiae.BatchExecutor.Internal.WaitOutcome'
                $outcome.PSObject.Properties.Name | Should -Be @('Kind', 'Reason')
                $outcome.Reason | Should -Be 'caller cancellation'
            }
            finally { $pipeline.Dispose() }
        }
    }
}
