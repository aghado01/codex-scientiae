#requires -Version 7.0

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../../src/shared/batch-executor/batch-executor.psd1') -Force

    function Write-PreparationTestScript {
        param([Parameter(Mandatory)] [string] $Path, [Parameter(Mandatory)] [string] $Body)
        Set-Content -LiteralPath $Path -Value $Body -Encoding utf8
        return (Resolve-Path -LiteralPath $Path).Path
    }
}

Describe 'Resolve-BatchExecutorPreparation' {
    It 'materializes independent direct copies before dispatch while retaining original result input' {
        $worker = Write-PreparationTestScript -Path (Join-Path $TestDrive 'direct-worker.ps1') `
            -Body 'param($Item, $Context, $RunspaceState, $CancellationToken) $Item'
        $items = @(
            @{ Id = 'one'; Nested = @{ Value = 'item-one' } }
            @{ Id = 'two'; Nested = @{ Value = 'item-two' } }
        )
        $context = @{ Nested = @{ Value = 'context' } }

        $preparation = InModuleScope 'batch-executor' -Parameters @{
            Worker = $worker; Items = $items; Context = $context; Work = $TestDrive
        } {
            Resolve-BatchExecutorPreparation -InputObject $Items -ScriptPath $Worker `
                -ExecutionMode Runspace -Context $Context -RunspaceDataPolicy PerItemCopy `
                -WorkingDirectory $Work -MaxWorkers 1
        }

        $items[0].Nested.Value = 'caller-mutated'
        $context.Nested.Value = 'caller-mutated'
        $preparation.Items[0].DispatchContext.Nested.Value = 'first-copy-mutated'

        $preparation.PSObject.TypeNames[0] | Should -Be `
            'CodexScientiae.BatchExecutor.Internal.ExecutionPreparation'
        $preparation.Items.Mode | Should -Be @('Runspace', 'Runspace')
        $preparation.Items[0].Input.Nested.Value | Should -Be 'caller-mutated'
        $preparation.Items[0].DispatchItem.Nested.Value | Should -Be 'item-one'
        $preparation.Items[1].DispatchItem.Nested.Value | Should -Be 'item-two'
        $preparation.Items[1].DispatchContext.Nested.Value | Should -Be 'context'
        $preparation.InitialSessionState | Should -Not -BeNullOrEmpty
        $preparation.EncodedChildCommand | Should -BeNullOrEmpty
    }

    It 'freezes complete process payloads and resolved launch policy before the pool opens' {
        $worker = Write-PreparationTestScript -Path (Join-Path $TestDrive 'process-worker.ps1') `
            -Body 'param($Item, $Context, $RunspaceState) $Item'
        $initializer = Write-PreparationTestScript -Path (Join-Path $TestDrive 'process-init.ps1') `
            -Body 'param($Context) $Context'
        $module = Write-PreparationTestScript -Path (Join-Path $TestDrive 'dependency.psm1') `
            -Body 'function Get-PreparationDependency { ''ok'' }'
        $itemEnvironmentValue = [System.Text.StringBuilder]::new('item-original')
        $itemEnvironment = @{ ITEM_ONLY = $itemEnvironmentValue }
        $items = @(@{
                Id = 'process-one'
                Value = 'item-original'
                ProcessSpec = @{ Environment = $itemEnvironment; TimeoutSeconds = 9 }
            })
        $context = @{ Value = 'context-original' }
        $environmentValue = [System.Text.StringBuilder]::new('global-original')
        $environment = @{ GLOBAL_ONLY = $environmentValue }

        $preparation = InModuleScope 'batch-executor' -Parameters @{
            Worker = $worker; Initializer = $initializer; Module = $module
            Items = $items; Context = $context; Environment = $environment; Work = $TestDrive
        } {
            Resolve-BatchExecutorPreparation -InputObject $Items -ScriptPath $Worker `
                -ExecutionMode Process -Context $Context -InitializationScriptPath $Initializer `
                -ModulePath @($Module) -ProcessEnvironment $Environment -WorkingDirectory $Work `
                -MaxWorkers 1
        }

        $items[0].Value = 'caller-mutated'
        $context.Value = 'caller-mutated'
        [void]$environmentValue.Append('-caller-mutated')
        [void]$itemEnvironmentValue.Append('-caller-mutated')
        $payload = [System.Management.Automation.PSSerializer]::Deserialize(
            $preparation.Items[0].ProcessPayloadXml)
        $spec = $preparation.Items[0].ProcessSpec

        $preparation.Items[0].Input.Value | Should -Be 'caller-mutated'
        $preparation.Items[0].DispatchItem | Should -BeNullOrEmpty
        $preparation.Items[0].DispatchContext | Should -BeNullOrEmpty
        $payload.Item.Value | Should -Be 'item-original'
        $payload.Context.Value | Should -Be 'context-original'
        $payload.InitializationScriptPath | Should -Be $initializer
        @($payload.ModulePath) | Should -Be @($module)
        $spec.Environment.GLOBAL_ONLY | Should -Be 'global-original'
        $spec.Environment.ITEM_ONLY | Should -Be 'item-original'
        $spec.TimeoutSeconds | Should -Be 9
        $preparation.EncodedChildCommand | Should -Not -BeNullOrEmpty
    }

    It 'fails the whole preparation before any earlier item starts when later serialization fails' {
        $marker = Join-Path $TestDrive 'unexpected-worker-start.txt'
        $worker = Write-PreparationTestScript -Path (Join-Path $TestDrive 'serialization-worker.ps1') `
            -Body @'
param($Item, $Context, $RunspaceState, $CancellationToken)
[System.IO.File]::AppendAllText([string]$Context, [string]$Item.Id)
'@
        $items = @(
            @{ Id = 'serializable' }
            @{ Id = 'planned-failure' }
        )

        InModuleScope 'batch-executor' -Parameters @{
            Worker = $worker; Items = $items; Marker = $marker; Work = $TestDrive
        } {
            Mock ConvertTo-BatchExecutorCliXml {
                param($Value, $Depth)
                if ($Value -is [System.Collections.IDictionary] -and
                        $Value['Id'] -eq 'planned-failure') {
                    throw 'planned later serialization failure'
                }
                return [System.Management.Automation.PSSerializer]::Serialize($Value, $Depth)
            }

            { Invoke-BatchExecutor -InputObject $Items -ScriptPath $Worker -ExecutionMode Runspace `
                    -Context $Marker -RunspaceDataPolicy PerItemCopy -WorkingDirectory $Work `
                    -MaxWorkers 1 } |
                Should -Throw '*planned later serialization failure*'
        }

        $marker | Should -Not -Exist
    }

    It 'does not broaden all-process initializer and module policy to a mixed process item' {
        $worker = Write-PreparationTestScript -Path (Join-Path $TestDrive 'mixed-worker.ps1') `
            -Body 'param($Item, $Context, $RunspaceState, $CancellationToken) $Item'
        $initializer = Write-PreparationTestScript -Path (Join-Path $TestDrive 'mixed-init.ps1') `
            -Body 'param($Context) $Context'
        $module = Write-PreparationTestScript -Path (Join-Path $TestDrive 'mixed-dependency.psm1') `
            -Body 'function Get-MixedDependency { ''ok'' }'
        $items = @(
            [pscustomobject]@{ Id = 'direct'; ExecutionMode = 'Runspace' }
            [pscustomobject]@{ Id = 'process'; ExecutionMode = 'Process' }
        )

        $preparation = InModuleScope 'batch-executor' -Parameters @{
            Worker = $worker; Initializer = $initializer; Module = $module
            Items = $items; Work = $TestDrive
        } {
            Resolve-BatchExecutorPreparation -InputObject $Items -ScriptPath $Worker `
                -ExecutionMode Mixed -InitializationScriptPath $Initializer -ModulePath @($Module) `
                -WorkingDirectory $Work -MaxWorkers 1
        }
        $payload = [System.Management.Automation.PSSerializer]::Deserialize(
            $preparation.Items[1].ProcessPayloadXml)

        $preparation.Items.Mode | Should -Be @('Runspace', 'Process')
        $payload.InitializationScriptPath | Should -BeNullOrEmpty
        @($payload.ModulePath | Where-Object {
                -not [string]::IsNullOrWhiteSpace([string]$_)
            }).Count | Should -Be 0
    }

    It 'keeps the empty preparation path free of execution configuration and resources' {
        $worker = Write-PreparationTestScript -Path (Join-Path $TestDrive 'empty-worker.ps1') `
            -Body 'param($Item, $Context, $RunspaceState, $CancellationToken) $Item'

        $preparation = InModuleScope 'batch-executor' -Parameters @{
            Worker = $worker; Work = $TestDrive
        } {
            Resolve-BatchExecutorPreparation -InputObject @() -ScriptPath $Worker `
                -ExecutionMode Runspace -WorkingDirectory $Work
        }

        $preparation.ItemCount | Should -Be 0
        $preparation.Items.Count | Should -Be 0
        $preparation.InitialSessionState | Should -BeNullOrEmpty
        $preparation.EncodedChildCommand | Should -BeNullOrEmpty
        @($preparation.PSObject.Properties.Name | Where-Object {
                $_ -in @('Pool', 'Invocations', 'ChildProcessRegistry', 'InfrastructureErrors')
            }).Count | Should -Be 0
    }
}
