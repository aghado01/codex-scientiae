#requires -Version 7.0

BeforeAll {
    $script:BatchExecutorModuleRoot = (Resolve-Path `
        (Join-Path $PSScriptRoot '../../src/shared/batch-executor')).Path
    $script:BatchExecutorManifest = Join-Path $script:BatchExecutorModuleRoot 'batch-executor.psd1'
    $script:BatchExecutorFacade = (Resolve-Path `
        (Join-Path $PSScriptRoot '../../src/shared/batch-executor.ps1')).Path

    function Copy-TestBatchExecutorModule {
        param([Parameter(Mandatory)] [string] $Destination)
        Copy-Item -LiteralPath $script:BatchExecutorModuleRoot -Destination $Destination -Recurse
        return Join-Path $Destination 'batch-executor.psd1'
    }
}

Describe 'batch-executor module surface' {
    BeforeEach {
        Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
        Remove-Item Alias:Compile-BatchPlan -Force -ErrorAction SilentlyContinue
        Remove-Variable BatchExecutorPayloadImportSentinel -Scope Global `
            -Force -ErrorAction SilentlyContinue
    }

    AfterEach {
        Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
        Remove-Item Alias:Compile-BatchPlan -Force -ErrorAction SilentlyContinue
        Remove-Variable BatchExecutorPayloadImportSentinel -Scope Global `
            -Force -ErrorAction SilentlyContinue
    }

    It 'imports the canonical manifest without warnings and exports exactly four commands' {
        $warnings = @()
        Import-Module $script:BatchExecutorManifest -Force -WarningVariable warnings

        $warnings.Count | Should -Be 0
        @((Get-Module batch-executor).ExportedFunctions.Keys | Sort-Object) | Should -Be @(
            'Invoke-BatchExecutor'
            'Invoke-BatchPlan'
            'New-BatchJob'
            'New-BatchPlan'
        )
        (Get-Module batch-executor).ExportedAliases.Count | Should -Be 0
        Get-Alias Compile-BatchPlan -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
    }

    It 'keeps implementation helpers private' {
        Import-Module $script:BatchExecutorManifest -Force

        foreach ($name in @(
            'Get-BatchExecutorScriptDefinition'
            'Resolve-BatchWorkerBudget'
            'Get-BatchExecutorPropertyValue'
            'New-BatchExecutorResolvedProcessSpec'
            'New-BatchExecutorPreparedItem'
            'New-BatchExecutorPreparation'
            'New-BatchExecutorLifecycleState'
            'Set-BatchExecutorLifecyclePhase'
            'New-BatchExecutorInvocationState'
            'Set-BatchExecutorInvocationTerminalOverride'
            'New-BatchExecutorWaitOutcome'
            'New-BatchExecutorSessionState'
            'ConvertTo-BatchExecutorCliXml'
            'Resolve-BatchExecutorPreparation'
            'New-BatchExecutorRunspacePool'
            'New-BatchExecutorPipeline'
            'Start-BatchExecutorInvocations'
            'Stop-BatchExecutorChildProcesses'
            'Stop-BatchExecutorPendingPipeline'
            'Wait-BatchExecutorInvocations'
            'Receive-BatchExecutorResults'
            'Stop-BatchExecutorLifecycle'
            'New-BatchExecutorExecutionRecord'
            'Resolve-BatchPlanPath'
            'Resolve-BatchPlanModuleReference'
        )) {
            Get-Command $name -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }

    It 'uses approved verbs for every canonical command' {
        Import-Module $script:BatchExecutorManifest -Force
        $approvedVerbs = @((Get-Verb).Verb)

        foreach ($command in @(Get-Command -Module batch-executor)) {
            $approvedVerbs | Should -Contain ($command.Name -split '-', 2)[0]
        }
    }

    It 'supports warning-free repeated imports' {
        $warnings = @()
        Import-Module $script:BatchExecutorManifest -Force -WarningVariable +warnings
        Import-Module $script:BatchExecutorManifest -Force -WarningVariable +warnings

        $warnings.Count | Should -Be 0
        @(Get-Module batch-executor -All).Count | Should -Be 1
        @(Get-Command -Module batch-executor).Count | Should -Be 4
    }

    It 'reads payload source without executing it in host module scope' {
        $copyRoot = Join-Path $TestDrive 'source-data-module'
        $manifest = Copy-TestBatchExecutorModule $copyRoot
        $bootstrap = Join-Path $copyRoot 'payloads/child-bootstrap.payload.ps1'
        $source = [System.IO.File]::ReadAllText($bootstrap)
        [System.IO.File]::WriteAllText(
            $bootstrap,
            '$global:BatchExecutorPayloadImportSentinel = $true' + [Environment]::NewLine + $source)

        Import-Module $manifest -Force

        Get-Variable BatchExecutorPayloadImportSentinel -Scope Global -ErrorAction SilentlyContinue |
            Should -BeNullOrEmpty
    }

    It 'reports a missing payload with its precise path' {
        $copyRoot = Join-Path $TestDrive 'missing-payload-module'
        $manifest = Copy-TestBatchExecutorModule $copyRoot
        $missing = Join-Path $copyRoot 'payloads/direct-dispatcher.payload.ps1'
        Remove-Item -LiteralPath $missing -Force

        { Import-Module $manifest -Force -ErrorAction Stop } |
            Should -Throw "*direct dispatcher payload not found: '$missing'*"
    }

    It 'reports malformed payload source with its precise path' {
        $copyRoot = Join-Path $TestDrive 'malformed-payload-module'
        $manifest = Copy-TestBatchExecutorModule $copyRoot
        $malformed = Join-Path $copyRoot 'payloads/process-dispatcher.payload.ps1'
        [System.IO.File]::WriteAllText($malformed, 'param(')

        { Import-Module $manifest -Force -ErrorAction Stop } |
            Should -Throw "*process dispatcher payload does not parse at '$malformed'*"
    }

    It 'keeps the facade behaviorally equivalent while making New-BatchPlan canonical' {
        . $script:BatchExecutorFacade
        $entry = Join-Path $TestDrive 'facade-entry.ps1'
        [System.IO.File]::WriteAllText($entry, 'param() ''ok''')
        $job = New-BatchJob -Id facade -Kind RunspaceScript -EntryPoint $entry

        $canonical = New-BatchPlan -Job $job
        $compatibility = Compile-BatchPlan -Job $job

        (Get-Alias Compile-BatchPlan).Definition | Should -Be 'New-BatchPlan'
        Get-Variable manifestPath -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        $compatibility.Errors | Should -Be $canonical.Errors
        $compatibility.Plan.Jobs.Id | Should -Be $canonical.Plan.Jobs.Id
        $compatibility.Plan.WorkerScriptPath | Should -Be $canonical.Plan.WorkerScriptPath
        $compatibility.Plan.WorkerScriptPath | Should -Be `
            (Join-Path $script:BatchExecutorModuleRoot 'payloads/batch-job-worker.ps1')
    }
}
