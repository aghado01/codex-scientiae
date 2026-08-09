#requires -Version 7.0

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../../src/batch-executor/batch-executor.psd1') -Force

    function Write-PlanTestScript {
        param([string] $Path, [string] $Body)
        Set-Content -LiteralPath $Path -Value $Body -Encoding utf8
        return $Path
    }
}

Describe 'Batch job and plan model' {
    It 'constructs explicit named and positional invocation contracts' {
        $named = New-BatchJob -Id named -Kind RunspaceScript -EntryPoint 'named.ps1' `
            -Parameters @{ Value = 7 }
        $positional = New-BatchJob -Id positional -Kind PowerShellProcess -EntryPoint 'positional.ps1' `
            -ArgumentList @('a', 2)

        $named.ArgumentMode | Should -Be 'Named'
        $named.Parameters.Value | Should -Be 7
        $positional.ArgumentMode | Should -Be 'Positional'
        $positional.ArgumentList.Count | Should -Be 2
        { New-BatchJob -Id invalid -Kind RunspaceScript -EntryPoint 'x.ps1' `
                -Parameters @{} -ArgumentList @() } | Should -Throw '*both Parameters and ArgumentList*'
    }

    It 'rejects duplicate ids and overlapping declared write sets before execution' {
        $entry = Write-PlanTestScript (Join-Path $TestDrive 'collision-entry.ps1') 'param() "ok"'
        $outputRoot = Join-Path $TestDrive 'artifacts'
        $jobs = @(
            New-BatchJob -Id repeated -Kind RunspaceScript -EntryPoint $entry -Writes $outputRoot
            New-BatchJob -Id repeated -Kind PowerShellProcess -EntryPoint $entry `
                -Writes (Join-Path $outputRoot 'child.md')
        )

        $compiled = New-BatchPlan -Job $jobs

        $compiled.Plan | Should -BeNullOrEmpty
        ($compiled.Errors -join "`n") | Should -Match 'duplicate job id'
        $jobs[1].Id = 'other'
        $collision = New-BatchPlan -Job $jobs
        ($collision.Errors -join "`n") | Should -Match 'write-set collision'
    }

    It 'validates entrypoints and declared module dependencies at compile time' {
        $entry = Write-PlanTestScript (Join-Path $TestDrive 'module-entry.ps1') 'param() "ok"'
        $jobs = @(
            New-BatchJob -Id missing-entry -Kind RunspaceScript -EntryPoint (Join-Path $TestDrive 'missing.ps1')
            New-BatchJob -Id missing-module -Kind PowerShellProcess -EntryPoint $entry `
                -ModulePath (Join-Path $TestDrive 'missing.psm1')
            New-BatchJob -Id invalid-policy -Kind PowerShellProcess -EntryPoint $entry `
                -ProcessSpec @{ Environment = 'not-a-dictionary'; TimeoutSeconds = -1; WindowStyle = 'Invisible' }
        )

        $compiled = New-BatchPlan -Job $jobs

        $compiled.Plan | Should -BeNullOrEmpty
        ($compiled.Errors -join "`n") | Should -Match 'entrypoint not found'
        ($compiled.Errors -join "`n") | Should -Match 'module is unavailable'
        ($compiled.Errors -join "`n") | Should -Match 'process environment must be a dictionary'
        ($compiled.Errors -join "`n") | Should -Match 'process timeout must be a non-negative integer'
        ($compiled.Errors -join "`n") | Should -Match 'invalid process window style'
    }

    It 'rejects incompatible direct runtime profiles for one shared pool' {
        $entry = Write-PlanTestScript (Join-Path $TestDrive 'profile-entry.ps1') 'param() "ok"'
        $jobs = @(
            New-BatchJob -Id core-job -Kind RunspaceScript -EntryPoint $entry -RuntimeProfile core
            New-BatchJob -Id full-job -Kind RunspaceScript -EntryPoint $entry -RuntimeProfile full
        )

        $compiled = New-BatchPlan -Job $jobs -RunspaceProfile @{ Name = 'core'; IssPreset = 'Core' }

        $compiled.Plan | Should -BeNullOrEmpty
        ($compiled.Errors -join "`n") | Should -Match 'cannot host multiple direct runtime profiles'
    }

    It 'cost-orders one greedy queue while returning results in original plan order' {
        $entry = Write-PlanTestScript (Join-Path $TestDrive 'cost-entry.ps1') @'
param([string] $Name)
Start-Sleep -Milliseconds 80
$Name
'@
        $jobs = @(
            New-BatchJob -Id low -Kind RunspaceScript -EntryPoint $entry `
                -Parameters @{ Name = 'low' } -EstimatedCost 1
            New-BatchJob -Id high -Kind RunspaceScript -EntryPoint $entry `
                -ArgumentList @('high') -EstimatedCost 100
        )
        $compiled = New-BatchPlan -Job $jobs

        $run = Invoke-BatchPlan -Plan $compiled -MaxWorkers 1

        $compiled.Errors.Count | Should -Be 0
        @($run.Results.Id) | Should -Be @('low', 'high')
        $run.Results[1].DispatchIndex | Should -Be 0
        $run.Results[0].DispatchIndex | Should -Be 1
        ([datetime]$run.Results[1].StartedUtc) | Should -BeLessThan ([datetime]$run.Results[0].StartedUtc)
        $run.Results[1].Output[0] | Should -Be 'high'
        $run.Summary.Succeeded | Should -Be 2
    }

    It 'runs heterogeneous jobs with per-job process policy and contains failures' {
        $direct = Write-PlanTestScript (Join-Path $TestDrive 'direct-entry.ps1') @'
param([string] $Name)
[pscustomobject]@{ Name = $Name; Mode = 'Runspace'; Pid = $PID }
'@
        $process = Write-PlanTestScript (Join-Path $TestDrive 'process-entry.ps1') @'
param([string] $Name)
[pscustomobject]@{ Name = $Name; Mode = 'Process'; Environment = $env:BATCH_PLAN_TEST; Directory = (Get-Location).Path; Pid = $PID }
'@
        $failing = Write-PlanTestScript (Join-Path $TestDrive 'failing-entry.ps1') 'param() throw "planned failure"'
        $jobs = @(
            New-BatchJob -Id direct -Kind RunspaceScript -EntryPoint $direct -Parameters @{ Name = 'alpha' }
            New-BatchJob -Id child -Kind PowerShellProcess -EntryPoint $process -Parameters @{ Name = 'beta' } `
                -ProcessSpec @{ Environment = @{ BATCH_PLAN_TEST = 'isolated' }; WorkingDirectory = $TestDrive }
            New-BatchJob -Id broken -Kind RunspaceScript -EntryPoint $failing
        )
        $compiled = New-BatchPlan -Job $jobs

        $run = Invoke-BatchPlan -Plan $compiled -MaxWorkers 3

        $compiled.Errors.Count | Should -Be 0
        @($run.Results.Id) | Should -Be @('direct', 'child', 'broken')
        $run.Results[0].State | Should -Be 'Succeeded'
        $run.Results[1].State | Should -Be 'Succeeded'
        $run.Results[2].State | Should -Be 'Failed'
        $run.Results[2].Errors -join "`n" | Should -Match 'planned failure'
        $run.Results[1].Output[0].Environment | Should -Be 'isolated'
        $run.Results[1].Output[0].Directory | Should -Be (Resolve-Path $TestDrive).Path
        $run.Results[0].ProcessId | Should -Be $PID
        $run.Results[1].ProcessId | Should -Not -Be $PID
        $run.Summary.Succeeded | Should -Be 2
        $run.Summary.Failed | Should -Be 1
    }

    It 'makes profile and job-local modules available in their respective runtimes' {
        $module = Write-PlanTestScript (Join-Path $TestDrive 'PlanDependency.psm1') @'
function Get-PlanDependencyValue { 'dependency-ready' }
Export-ModuleMember -Function Get-PlanDependencyValue
'@
        $entry = Write-PlanTestScript (Join-Path $TestDrive 'dependency-entry.ps1') 'param() Get-PlanDependencyValue'
        $jobs = @(
            New-BatchJob -Id direct-dependency -Kind RunspaceScript -EntryPoint $entry
            New-BatchJob -Id process-dependency -Kind PowerShellProcess -EntryPoint $entry -ModulePath $module
        )
        $compiled = New-BatchPlan -Job $jobs `
            -RunspaceProfile @{ Name = 'default'; IssPreset = 'Core'; ModulePath = @($module) }

        $run = Invoke-BatchPlan -Plan $compiled -MaxWorkers 2

        $compiled.Errors.Count | Should -Be 0
        @($run.Results.State | Select-Object -Unique) | Should -Be @('Succeeded')
        $run.Results[0].Output[0] | Should -Be 'dependency-ready'
        $run.Results[1].Output[0] | Should -Be 'dependency-ready'
    }

    It 'cancels direct work and kills child process work without aborting the parent' {
        $slow = Write-PlanTestScript (Join-Path $TestDrive 'slow-plan-entry.ps1') @'
param()
Start-Sleep -Seconds 10
'@
        $jobs = @(
            New-BatchJob -Id direct-slow -Kind RunspaceScript -EntryPoint $slow
            New-BatchJob -Id process-slow -Kind PowerShellProcess -EntryPoint $slow
        )
        $compiled = New-BatchPlan -Job $jobs
        $cts = [System.Threading.CancellationTokenSource]::new()
        try {
            $cts.CancelAfter(700)
            $watch = [System.Diagnostics.Stopwatch]::StartNew()
            $run = Invoke-BatchPlan -Plan $compiled -MaxWorkers 2 -CancellationToken $cts.Token
            $watch.Stop()
        }
        finally { $cts.Dispose() }

        $watch.Elapsed.TotalSeconds | Should -BeLessThan 7
        $run.Summary.Cancelled | Should -Be 2
        @($run.Results.State | Select-Object -Unique) | Should -Be @('Cancelled')
    }
}
