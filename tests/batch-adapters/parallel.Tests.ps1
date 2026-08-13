#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:ParallelShell = Join-Path $script:RepositoryRoot 'tests/parallel.ps1'
    $script:RepositoryRunner = Join-Path $script:RepositoryRoot 'tests/run.ps1'
    $script:RepositoryPytestRunner = Join-Path $script:RepositoryRoot 'tests/pytest.ps1'
    $script:RepositoryArtifactBoundary = Join-Path $script:RepositoryRoot `
        'tests/artifact-boundary.ps1'
    $script:PythonPath = (Resolve-Path `
        (Join-Path $script:RepositoryRoot '.venv/Scripts/python.exe')).Path
    $livePester = Get-Module Pester | Sort-Object Version -Descending | Select-Object -First 1
    $script:LivePesterManifest = Join-Path $livePester.ModuleBase 'Pester.psd1'

    function New-ParallelFixtureRepository {
        param([Parameter(Mandatory)] [string] $Root)

        $repository = Join-Path $Root 'repository'
        $tests = Join-Path $repository 'tests'
        $runDirectory = Join-Path $repository 'artifacts/20261208_000000'
        foreach ($directory in @($repository, $tests, $runDirectory)) {
            [void][System.IO.Directory]::CreateDirectory($directory)
        }
        Copy-Item -LiteralPath $script:RepositoryRunner -Destination (Join-Path $tests 'run.ps1')
        Copy-Item -LiteralPath $script:RepositoryPytestRunner `
            -Destination (Join-Path $tests 'pytest.ps1')
        Copy-Item -LiteralPath $script:RepositoryArtifactBoundary `
            -Destination (Join-Path $tests 'artifact-boundary.ps1')
        Set-Content -LiteralPath (Join-Path $repository 'pyproject.toml') -Encoding utf8 -Value @'
[tool.pytest.ini_options]
python_files = ["test_*.py"]
'@
        [pscustomobject]@{
            Root = $repository
            Tests = $tests
            RunDirectory = $runDirectory
        }
    }

    function Write-ParallelFixture {
        param(
            [Parameter(Mandatory)] [string] $Path,
            [Parameter(Mandatory)] [string] $Content
        )

        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path))
        Set-Content -LiteralPath $Path -Encoding utf8 -Value $Content
        return $Path
    }
}

AfterAll {
    Remove-Module adapters -Force -ErrorAction SilentlyContinue
    Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
}

Describe 'multilingual test composition shell' {
    It 'owns only public adapter-plan-executor composition and console summary projection' {
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $script:ParallelShell, [ref]$tokens, [ref]$parseErrors)
        $parseErrors.Count | Should -Be 0

        $commands = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.CommandAst]
                }, $true) | ForEach-Object GetCommandName)
        foreach ($compositionCall in @(
                'adapters\Get-PesterBatchJob'
                'adapters\Get-PytestBatchJob'
                'batch-executor\New-BatchPlan'
                'batch-executor\Invoke-BatchPlan'
            )) {
            @($commands | Where-Object { $_ -eq $compositionCall }).Count | Should -Be 1
        }
        @($commands | Where-Object { $_ -eq 'Import-Module' }).Count | Should -Be 2
        @($commands | Where-Object { $_ -eq 'Write-Information' }).Count | Should -Be 1
        @($commands | Where-Object { $_ -eq 'Write-Output' }).Count | Should -Be 0

        $forbiddenCommands = @(
            'New-BatchJob', 'Invoke-BatchExecutor'
            'Start-Job', 'Start-ThreadJob', 'Wait-Job', 'Receive-Job', 'Stop-Job', 'Remove-Job'
            'Start-Process', 'Wait-Process', 'Stop-Process', 'Invoke-Command'
            'ForEach-Object', 'Sort-Object'
            'New-Item', 'New-Guid', 'Get-Date', 'Get-Random'
            'New-ModuleRunDir', 'New-RunDir', 'Start-Sleep'
            'Start-RunLog', 'Write-RunLog', 'Stop-RunLog'
            'Set-Content', 'Add-Content', 'Out-File', 'Tee-Object'
            'Export-Csv', 'Export-Clixml', 'ConvertTo-Json', 'exit'
        )
        @($commands | Where-Object { $_ -in $forbiddenCommands }) | Should -BeNullOrEmpty

        $forbiddenMembers = @(
            'CreateRunspacePool', 'CreateRunspace', 'BeginInvoke', 'EndInvoke'
            'AddScript', 'AddCommand', 'Invoke', 'Start', 'Kill', 'WaitForExit'
            'CreateDirectory', 'WriteAllText', 'AppendAllText', 'NewGuid'
        )
        $members = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -and
                        $node.Member -is `
                            [System.Management.Automation.Language.StringConstantExpressionAst]
                }, $true) | ForEach-Object { $_.Member.Value })
        @($members | Where-Object { $_ -in $forbiddenMembers }) | Should -BeNullOrEmpty

        $forbiddenTypePattern =
            '(?i)(?:^|\.)(?:PowerShell|RunspacePool|RunspaceFactory|CancellationTokenSource|' +
            'ConcurrentDictionary(?:`2)?|SemaphoreSlim|TaskCompletionSource(?:`1)?|Process)$'
        $types = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.TypeExpressionAst] -or
                        $node -is [System.Management.Automation.Language.TypeConstraintAst]
                }, $true) | ForEach-Object { $_.TypeName.FullName })
        @($types | Where-Object { $_ -match $forbiddenTypePattern }) | Should -BeNullOrEmpty

        @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -or
                        $node -is [System.Management.Automation.Language.TypeDefinitionAst] -or
                        $node -is [System.Management.Automation.Language.LoopStatementAst] -or
                        $node -is [System.Management.Automation.Language.ExitStatementAst]
                }, $true)).Count | Should -Be 0
        $source = $ast.Extent.Text
        $source | Should -Not -Match `
            'pester-jobs|pester\.xml|CODEX_TEST_ARTIFACT_ROOT|\bartifacts\b'
        $source | Should -Not -Match `
            '\$(?:env|global):|RunspacePool|ProcessRegistry|Scheduler|Cancellation|Retry|Runstamp'

        $parameterNames = @($ast.ParamBlock.Parameters.Name.VariablePath.UserPath)
        $parameterNames | Should -Contain 'Path'
        $parameterNames | Should -Contain 'PesterPath'
        $parameterNames | Should -Contain 'PytestPath'
        $parameterNames | Should -Contain 'RunDirectory'
        $parameterNames | Should -Contain 'Framework'
        $parameterNames | Should -Contain 'PythonPath'
        $parameterNames | Should -Contain 'MaxWorkers'
        $parameterNames | Should -Contain 'ReservedCores'
        $parameterNames | Should -Contain 'ProcessTimeoutSeconds'
        $parameterNames | Should -Not -Contain 'AllowWriteCollisions'
        $parameterNames | Should -Not -Contain 'WorkloadProfile'
    }

    It 'returns the executor record and preserves isolated native and suite artifacts on success' {
        $fixture = New-ParallelFixtureRepository -Root (Join-Path $TestDrive 'success')
        $alpha = Write-ParallelFixture -Path (Join-Path $fixture.Tests 'alpha.Tests.ps1') `
            -Content @'
Describe 'alpha parallel fixture' {
    It 'writes alpha evidence' {
        [System.IO.Path]::IsPathFullyQualified($env:CODEX_TEST_ARTIFACT_ROOT) | Should -BeTrue
        $caseRoot = Join-Path $env:CODEX_TEST_ARTIFACT_ROOT 'alpha'
        [void][System.IO.Directory]::CreateDirectory($caseRoot)
        Set-Content -LiteralPath (Join-Path $caseRoot 'witness.txt') -Value 'alpha'
    }
}
'@
        $beta = Write-ParallelFixture -Path (Join-Path $fixture.Tests 'beta.Tests.ps1') `
            -Content @'
Describe 'beta parallel fixture' {
    It 'writes beta evidence' {
        [System.IO.Path]::IsPathFullyQualified($env:CODEX_TEST_ARTIFACT_ROOT) | Should -BeTrue
        $caseRoot = Join-Path $env:CODEX_TEST_ARTIFACT_ROOT 'beta'
        [void][System.IO.Directory]::CreateDirectory($caseRoot)
        Set-Content -LiteralPath (Join-Path $caseRoot 'witness.txt') -Value 'beta'
    }
}
'@
        $summaryInformation = @()
        $execution = & $script:ParallelShell -Framework Pester -Path @($beta, $alpha) `
            -RunDirectory $fixture.RunDirectory -RepositoryRoot $fixture.Root `
            -PesterManifest $script:LivePesterManifest `
            -PowerShellPath ([System.Environment]::ProcessPath) -MaxWorkers 2 `
            -InformationVariable +summaryInformation

        $execution.GetType().FullName | Should -Be 'System.Management.Automation.PSCustomObject'
        $execution.PlanId | Should -Not -BeNullOrEmpty
        @($execution.Results.State) | Should -Be @('Succeeded', 'Succeeded')
        $expectedRelativePaths = @('alpha', 'beta') | ForEach-Object {
            "tests/$_.Tests.ps1"
        }
        @($execution.Results.Input.Metadata.RepositoryRelativePath) |
            Should -Be $expectedRelativePaths
        $execution.Summary.Total | Should -Be 2
        $execution.Summary.Succeeded | Should -Be 2
        $execution.Summary.Failed | Should -Be 0
        $execution.Budget.Threads | Should -Be 2
        (@($summaryInformation | ForEach-Object MessageData) -join "`n") |
            Should -Match 'total=2; succeeded=2; failed=0'

        foreach ($result in $execution.Results) {
            $metadata = $result.Input.Metadata
            Test-Path -LiteralPath $metadata.ResultPath -PathType Leaf | Should -BeTrue
            $stem = [System.IO.Path]::GetFileNameWithoutExtension($metadata.SourcePath)
            if ($stem.EndsWith('.Tests')) { $stem = $stem.Substring(0, $stem.Length - 6) }
            Test-Path -LiteralPath (Join-Path $metadata.ArtifactRoot "$stem/witness.txt") `
                -PathType Leaf | Should -BeTrue
            @($result.Input.Writes) | Should -Be @(
                $metadata.ResultPath, $metadata.ArtifactRoot, $metadata.TempRoot)
            Get-Process -Id $result.ProcessId -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File |
                Where-Object Extension -In @('.json', '.jsonl')).Count | Should -Be 0
    }

    It 'builds one plan for Pester and pytest while retaining framework-owned evidence' {
        $fixture = New-ParallelFixtureRepository -Root (Join-Path $TestDrive 'multilingual')
        $pesterPath = Write-ParallelFixture -Path (Join-Path $fixture.Tests 'alpha.Tests.ps1') `
            -Content @'
Describe 'multilingual Pester fixture' {
    It 'retains Pester evidence' {
        [void][System.IO.Directory]::CreateDirectory($env:CODEX_TEST_ARTIFACT_ROOT)
        Set-Content -LiteralPath (Join-Path $env:CODEX_TEST_ARTIFACT_ROOT 'pester.txt') `
            -Value 'pester'
    }
}
'@
        $pytestPath = Write-ParallelFixture -Path (Join-Path $fixture.Tests 'test_beta.py') `
            -Content @'
import os
from pathlib import Path

def test_multilingual_pytest_evidence():
    root = Path(os.environ["CODEX_TEST_ARTIFACT_ROOT"])
    root.mkdir(parents=True, exist_ok=True)
    (root / "pytest.txt").write_text("pytest", encoding="utf-8")
'@
        $summaryInformation = @()

        $execution = & $script:ParallelShell `
            -PesterPath $pesterPath -PytestPath $pytestPath `
            -RunDirectory $fixture.RunDirectory `
            -RepositoryRoot $fixture.Root -PesterManifest $script:LivePesterManifest `
            -PythonPath $script:PythonPath -PowerShellPath ([System.Environment]::ProcessPath) `
            -MaxWorkers 2 -InformationVariable +summaryInformation

        $execution.Summary.Total | Should -Be 2
        $execution.Summary.Succeeded | Should -Be 2
        @($execution.Results.Id) | Should -HaveCount 2
        $execution.Results[0].Id | Should -Match '^pester:'
        $execution.Results[1].Id | Should -Match '^pytest:'
        @($execution.Results.State) | Should -Be @('Succeeded', 'Succeeded')
        Test-Path -LiteralPath (Join-Path `
                $execution.Results[0].Input.Metadata.ArtifactRoot 'pester.txt') `
            -PathType Leaf | Should -BeTrue
        Test-Path -LiteralPath (Join-Path `
                $execution.Results[1].Input.Metadata.ArtifactRoot 'pytest.txt') `
            -PathType Leaf | Should -BeTrue
        @($execution.Results[0].StdOut | Where-Object {
                $_ -match '^PesterContainerObservation '
            }).Count | Should -Be 1
        @($execution.Results[1].StdOut | Where-Object {
                $_ -match '^PytestContainerObservation '
            }).Count | Should -Be 1
        foreach ($result in $execution.Results) {
            Test-Path -LiteralPath $result.Input.Metadata.ResultPath -PathType Leaf | Should -BeTrue
            Get-Process -Id $result.ProcessId -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
        (@($summaryInformation | ForEach-Object MessageData) -join "`n") |
            Should -Match 'framework=All; total=2; succeeded=2; failed=0'
        @(Get-ChildItem -LiteralPath $fixture.Root -Recurse -Directory | Where-Object {
                $_.Name -in @('__pycache__', '.pytest_cache')
            }).Count | Should -Be 0
    }

    It 'retains a successful Pester sibling when pytest fails in the shared plan' {
        $fixture = New-ParallelFixtureRepository -Root (Join-Path $TestDrive 'mixed-failure')
        $pesterPath = Write-ParallelFixture -Path (Join-Path $fixture.Tests 'a-pass.Tests.ps1') `
            -Content @'
Describe 'passing cross-framework sibling' {
    It 'retains evidence' {
        [void][System.IO.Directory]::CreateDirectory($env:CODEX_TEST_ARTIFACT_ROOT)
        Set-Content -LiteralPath (Join-Path $env:CODEX_TEST_ARTIFACT_ROOT 'survived.txt') `
            -Value 'survived'
    }
}
'@
        $pytestPath = Write-ParallelFixture -Path (Join-Path $fixture.Tests 'test_b_fail.py') `
            -Content @'
import os
from pathlib import Path

def test_planned_failure():
    root = Path(os.environ["CODEX_TEST_ARTIFACT_ROOT"])
    root.mkdir(parents=True, exist_ok=True)
    (root / "failure.txt").write_text("retained", encoding="utf-8")
    assert False, "planned mixed-framework failure"
'@
        $outputs = [System.Collections.Generic.List[object]]::new()
        $failure = $null
        try {
            & $script:ParallelShell -Framework All -PesterPath $pesterPath `
                -PytestPath $pytestPath -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $script:LivePesterManifest `
                -PythonPath $script:PythonPath -PowerShellPath ([System.Environment]::ProcessPath) `
                -MaxWorkers 2 | ForEach-Object { $outputs.Add($_) }
        }
        catch { $failure = $_ }

        $failure.Exception.Message | Should -Match 'parallel\.ps1: batch did not succeed'
        $outputs.Count | Should -Be 1
        $execution = $outputs[0]
        @($execution.Results.State) | Should -Be @('Succeeded', 'Failed')
        $execution.Summary.Succeeded | Should -Be 1
        $execution.Summary.Failed | Should -Be 1
        Test-Path -LiteralPath (Join-Path `
                $execution.Results[0].Input.Metadata.ArtifactRoot 'survived.txt') `
            -PathType Leaf | Should -BeTrue
        Test-Path -LiteralPath (Join-Path `
                $execution.Results[1].Input.Metadata.ArtifactRoot 'failure.txt') `
            -PathType Leaf | Should -BeTrue
        foreach ($result in $execution.Results) {
            Test-Path -LiteralPath $result.Input.Metadata.ResultPath -PathType Leaf | Should -BeTrue
            Get-Process -Id $result.ProcessId -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }

    It 'returns all sibling evidence before making a failed batch nonzero' {
        $fixture = New-ParallelFixtureRepository -Root (Join-Path $TestDrive 'failure')
        $passPath = Write-ParallelFixture -Path (Join-Path $fixture.Tests 'a-pass.Tests.ps1') `
            -Content @'
Describe 'passing sibling fixture' {
    It 'survives its failing sibling' {
        $caseRoot = Join-Path $env:CODEX_TEST_ARTIFACT_ROOT 'pass'
        [void][System.IO.Directory]::CreateDirectory($caseRoot)
        Set-Content -LiteralPath (Join-Path $caseRoot 'witness.txt') -Value 'survived'
    }
}
'@
        $failPath = Write-ParallelFixture -Path (Join-Path $fixture.Tests 'b-fail.Tests.ps1') `
            -Content @'
Describe 'failing sibling fixture' {
    It 'fails locally after retaining evidence' {
        $caseRoot = Join-Path $env:CODEX_TEST_ARTIFACT_ROOT 'failure'
        [void][System.IO.Directory]::CreateDirectory($caseRoot)
        Set-Content -LiteralPath (Join-Path $caseRoot 'witness.txt') -Value 'retained'
        throw 'planned parallel-shell failure'
    }
}
'@
        $outputs = [System.Collections.Generic.List[object]]::new()
        $failure = $null
        try {
            & $script:ParallelShell -Framework Pester -Path @($passPath, $failPath) `
                -RunDirectory $fixture.RunDirectory -RepositoryRoot $fixture.Root `
                -PesterManifest $script:LivePesterManifest `
                -PowerShellPath ([System.Environment]::ProcessPath) -MaxWorkers 2 |
                ForEach-Object { $outputs.Add($_) }
        }
        catch { $failure = $_ }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'parallel\.ps1: batch did not succeed'
        $outputs.Count | Should -Be 1
        $execution = $outputs[0]
        @($execution.Results.State) | Should -Be @('Succeeded', 'Failed')
        foreach ($id in @($execution.Results.Id)) { $id | Should -Match '^pester:' }
        $execution.Summary.Total | Should -Be 2
        $execution.Summary.Succeeded | Should -Be 1
        $execution.Summary.Failed | Should -Be 1
        foreach ($result in $execution.Results) {
            Test-Path -LiteralPath $result.Input.Metadata.ResultPath -PathType Leaf | Should -BeTrue
            @($result.StdOut | Where-Object { $_ -match 'PesterContainerObservation' }).Count |
                Should -Be 1
            Get-Process -Id $result.ProcessId -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
        Test-Path -LiteralPath (Join-Path $execution.Results[0].Input.Metadata.ArtifactRoot `
                'pass/witness.txt') -PathType Leaf | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $execution.Results[1].Input.Metadata.ArtifactRoot `
                'failure/witness.txt') -PathType Leaf | Should -BeTrue

        $cliRunDirectory = Join-Path $fixture.Root 'artifacts/20261208_000000_01'
        [void][System.IO.Directory]::CreateDirectory($cliRunDirectory)
        $cliOutput = @(& ([System.Environment]::ProcessPath) -NoProfile -File $script:ParallelShell `
                -Framework Pester -Path $fixture.Tests -RunDirectory $cliRunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $script:LivePesterManifest `
                -PowerShellPath ([System.Environment]::ProcessPath) -MaxWorkers 2 2>&1)
        $cliExitCode = $LASTEXITCODE
        $cliExitCode | Should -Not -Be 0
        $cliText = @($cliOutput | ForEach-Object ToString) -join "`n"
        $cliText = [regex]::Replace($cliText, "`e\[[0-9;]*[A-Za-z]", '')
        $cliText | Should -Match 'total=2; succeeded=1; failed=1'
        @(Get-ChildItem -LiteralPath $cliRunDirectory -Recurse -Filter pester.xml -File).Count |
            Should -Be 2
    }
}
