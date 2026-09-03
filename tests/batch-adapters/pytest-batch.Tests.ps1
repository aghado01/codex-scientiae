#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:AdaptersManifest = Join-Path $script:RepositoryRoot 'src/batch-adapters/adapters.psd1'
    $script:RepositoryPytestRunner = Join-Path $script:RepositoryRoot 'tests/pytest.ps1'
    $script:RepositoryArtifactBoundary = Join-Path $script:RepositoryRoot `
        'src/logistics/artifact-boundary.ps1'
    $pythonCandidate = Join-Path $script:RepositoryRoot '.venv/Scripts/python.exe'
    $script:PythonPath = if (Test-Path -LiteralPath $pythonCandidate -PathType Leaf) {
        (Resolve-Path -LiteralPath $pythonCandidate).Path
    }
    else { $null }
    $script:PowerShellPath = [System.Environment]::ProcessPath

    function New-PytestBatchFixtureRepository {
        param([Parameter(Mandatory)] [string] $Root)

        $tests = Join-Path $Root 'tests'
        $run = Join-Path $Root 'artifacts/20261208_000000'
        [void][System.IO.Directory]::CreateDirectory($tests)
        [void][System.IO.Directory]::CreateDirectory($run)
        Copy-Item -LiteralPath $script:RepositoryPytestRunner `
            -Destination (Join-Path $tests 'pytest.ps1')
        $logistics = Join-Path $Root 'src/logistics'
        [void][System.IO.Directory]::CreateDirectory($logistics)
        Copy-Item -LiteralPath $script:RepositoryArtifactBoundary `
            -Destination (Join-Path $logistics 'artifact-boundary.ps1')
        Set-Content -LiteralPath (Join-Path $Root 'pyproject.toml') -Encoding utf8 -Value @'
[tool.pytest.ini_options]
python_files = ["test_*.py"]
'@
        return [pscustomobject]@{
            Root = (Resolve-Path $Root).Path
            Tests = (Resolve-Path $tests).Path
            RunDirectory = (Resolve-Path $run).Path
            Config = (Resolve-Path (Join-Path $Root 'pyproject.toml')).Path
            Runner = (Resolve-Path (Join-Path $tests 'pytest.ps1')).Path
        }
    }

    function Write-PytestBatchFixture {
        param(
            [Parameter(Mandatory)] [string] $Path,
            [string] $Content = "def test_pass():`n    assert True`n"
        )

        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path))
        Set-Content -LiteralPath $Path -Encoding utf8 -Value $Content
        return (Resolve-Path $Path).Path
    }

    function Get-PytestBatchObservation {
        param([Parameter(Mandatory)] [string[]] $Output)

        $matches = @($Output | ForEach-Object {
                if ($_ -match '^PytestContainerObservation\s+(.+)$') { $Matches[1] }
            })
        $matches.Count | Should -Be 1
        return ($matches[0] | ConvertFrom-Json)
    }

    Import-Module $script:AdaptersManifest -Force
}

AfterAll {
    Remove-Module adapters -Force -ErrorAction SilentlyContinue
    Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
}

Describe 'Get-PytestBatchJob planning' {
    It 'discovers stable exact-file jobs and creates no run artifacts' {
        $fixture = New-PytestBatchFixtureRepository -Root (Join-Path $TestDrive 'discovery')
        $alpha = Write-PytestBatchFixture (Join-Path $fixture.Tests 'test_alpha.py')
        $beta = Write-PytestBatchFixture (Join-Path $fixture.Tests 'group/test_alpha.py') `
            -Content (("# cost hint`n" * 100) + "def test_beta():`n    assert True`n")
        $fakePython = Join-Path $fixture.Root 'fake-python.exe'
        Set-Content -LiteralPath $fakePython -Encoding utf8 -Value 'planning must not execute this file'

        $invoke = @{
            Path = @($fixture.Tests, $alpha)
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            PythonPath = $fakePython
            PowerShellPath = $script:PowerShellPath
        }
        $jobs = @(Get-PytestBatchJob @invoke)
        $again = @(Get-PytestBatchJob @invoke)

        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -Force).Count | Should -Be 0
        $jobs.Count | Should -Be 2
        @($jobs.Id) | Should -Be @($again.Id)
        @($jobs.Metadata.RepositoryRelativePath) | Should -Be @(
            'tests/group/test_alpha.py'
            'tests/test_alpha.py'
        )
        @($jobs.Metadata.JobDirectory | Sort-Object -Unique).Count | Should -Be 2
        foreach ($job in $jobs) {
            $job.Id | Should -Match '^pytest:.+#[0-9a-f]{12}$'
            $job.Kind | Should -Be 'PowerShellProcess'
            $job.EntryPoint | Should -Be $fixture.Runner
            $job.WorkingDirectory | Should -Be $fixture.Root
            $job.ModulePath.Count | Should -Be 0
            $job.Parameters.Path | Should -Be $job.Metadata.SourcePath
            $job.Parameters.ResultPath | Should -Be $job.Metadata.ResultPath
            $job.Parameters.TempPath | Should -Be $job.Metadata.TempRoot
            $job.Parameters.PythonPath | Should -Be $fakePython
            $job.Parameters.PytestConfig | Should -Be $fixture.Config
            @($job.Writes) | Should -Be @(
                $job.Metadata.ResultPath
                $job.Metadata.ArtifactRoot
                $job.Metadata.TempRoot
            )
            $environment = $job.ProcessSpec.Environment
            $environment.CODEX_TEST_ARTIFACT_ROOT | Should -Be $job.Metadata.ArtifactRoot
            $environment.CODEX_JSON_SCRATCH_ROOT | Should -Be $job.Metadata.JsonScratchRoot
            $environment.CODEX_TEST_POWERSHELL_PATH | Should -Be $script:PowerShellPath
            $environment.CODEX_TEMP | Should -Be $job.Metadata.TempRoot
            @($environment.TEMP, $environment.TMP, $environment.TMPDIR) |
                Should -Be @($job.Metadata.TempRoot, $job.Metadata.TempRoot, $job.Metadata.TempRoot)
            $environment.PYTHONDONTWRITEBYTECODE | Should -Be '1'
            $environment.PYTEST_DISABLE_PLUGIN_AUTOLOAD | Should -Be '1'
            foreach ($removedName in @(
                    'PYTEST_ADDOPTS', 'CODEX_REGEN_FIXTURES', 'PYTHONPATH', 'PYTHONHOME'
                )) {
                $environment.ContainsKey($removedName) | Should -BeTrue
                $environment[$removedName] | Should -BeNullOrEmpty
            }
            foreach ($path in @($job.Metadata.JobDirectory, $job.Metadata.ResultPath,
                    $job.Metadata.ArtifactRoot, $job.Metadata.TempRoot)) {
                Test-Path -LiteralPath $path | Should -BeFalse
            }
        }
        $jobs[0].EstimatedCost | Should -BeGreaterThan $jobs[1].EstimatedCost

        $compiled = InModuleScope adapters -Parameters @{
            Jobs = $jobs; BasePath = $fixture.Root
        } {
            New-BatchPlan -Job $Jobs -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0
        $compiled.Plan.Jobs.Count | Should -Be 2
    }

    It 'makes normalized keyword and marker expressions part of identity and runner selection' {
        $fixture = New-PytestBatchFixtureRepository -Root (Join-Path $TestDrive 'selection')
        $testFile = Write-PytestBatchFixture (Join-Path $fixture.Tests 'test_selection.py')
        $fakePython = Join-Path $fixture.Root 'fake-python.exe'
        Set-Content -LiteralPath $fakePython -Encoding utf8 -Value 'planning only'
        $common = @{
            Path = $testFile
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            PythonPath = $fakePython
            PowerShellPath = $script:PowerShellPath
        }
        $base = @(Get-PytestBatchJob @common)[0]
        $selected = @(Get-PytestBatchJob @common `
                -KeywordExpression ' selected and not slow ' -MarkerExpression 'unit or smoke')[0]
        $again = @(Get-PytestBatchJob @common `
                -KeywordExpression 'selected and not slow' -MarkerExpression 'unit or smoke')[0]
        $changed = @(Get-PytestBatchJob @common `
                -KeywordExpression 'selected' -MarkerExpression 'unit or smoke')[0]

        $selected.Id | Should -Not -Be $base.Id
        $selected.Id | Should -Be $again.Id
        $selected.Id | Should -Not -Be $changed.Id
        $selected.Metadata.ResultPath | Should -Be $again.Metadata.ResultPath
        $selected.Parameters.KeywordExpression | Should -Be 'selected and not slow'
        $selected.Parameters.MarkerExpression | Should -Be 'unit or smoke'
        $selected.Parameters.TestSuiteName | Should -Be $selected.Id
    }

    It 'rejects missing, escaping, empty, and non-pytest selections without creating output' {
        $fixture = New-PytestBatchFixtureRepository -Root (Join-Path $TestDrive 'invalid')
        $valid = Write-PytestBatchFixture (Join-Path $fixture.Tests 'test_valid.py')
        $ordinary = Write-PytestBatchFixture (Join-Path $fixture.Tests 'helper.py')
        $outside = Write-PytestBatchFixture (Join-Path $TestDrive 'test_outside.py')
        $fakePython = Join-Path $fixture.Root 'fake-python.exe'
        Set-Content -LiteralPath $fakePython -Encoding utf8 -Value 'planning only'
        $empty = Join-Path $fixture.Root 'empty'
        [void][System.IO.Directory]::CreateDirectory($empty)
        $missingRun = Join-Path $fixture.Root 'missing-run'
        $outsideRun = Join-Path (Split-Path -Parent $fixture.Root) 'outside-run'
        [void][System.IO.Directory]::CreateDirectory($outsideRun)
        $missingPython = Join-Path $fixture.Root 'missing-python.exe'

        $common = @{
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            PythonPath = $fakePython
            PowerShellPath = $script:PowerShellPath
        }
        { Get-PytestBatchJob @common -Path $outside } |
            Should -Throw '*selection escapes RepositoryRoot*'
        { Get-PytestBatchJob @common -Path $ordinary } |
            Should -Throw '*is not a test_*.py file*'
        { Get-PytestBatchJob @common -Path $empty } |
            Should -Throw '*discovered no test_*.py files*'
        { Get-PytestBatchJob @common -Path $valid -KeywordExpression ' ' } |
            Should -Throw '*keyword expression must not be empty*'
        { Get-PytestBatchJob -Path $valid -RunDirectory $missingRun `
                -RepositoryRoot $fixture.Root -PythonPath $fakePython `
                -PowerShellPath $script:PowerShellPath } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        { Get-PytestBatchJob -Path $valid -RunDirectory $outsideRun `
                -RepositoryRoot $fixture.Root -PythonPath $fakePython `
                -PowerShellPath $script:PowerShellPath } |
            Should -Throw '*RunDirectory must be a descendant of RepositoryRoot/artifacts*'
        { Get-PytestBatchJob @common -Path $valid -PythonPath $missingPython } |
            Should -Throw '*Python interpreter not found*'
        { Get-PytestBatchJob -Path $valid -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PowerShellPath $script:PowerShellPath } |
            Should -Throw '*could not locate a Python interpreter*'
        Test-Path -LiteralPath $missingRun | Should -BeFalse
        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -Force).Count | Should -Be 0
    }
}

Describe 'pytest-batch execution integration' {
    It 'rejects direct result and temp paths outside repository artifacts' {
        $fixture = New-PytestBatchFixtureRepository -Root (Join-Path $TestDrive 'runner-boundary')
        $testPath = Write-PytestBatchFixture (Join-Path $fixture.Tests 'test_boundary.py')
        $fakePython = Join-Path $fixture.Root 'fake-python.exe'
        Set-Content -LiteralPath $fakePython -Encoding utf8 -Value 'must not execute'
        $validResult = Join-Path $fixture.RunDirectory 'direct/pytest.xml'
        $validTemp = Join-Path $fixture.RunDirectory 'direct/temp'
        $outside = Join-Path $fixture.Root 'outside'

        { & $fixture.Runner -Path $testPath -ResultPath (Join-Path $outside 'pytest.xml') `
                -RepositoryRoot $fixture.Root -PythonPath $fakePython `
                -PytestConfig $fixture.Config -TestSuiteName 'result-boundary' `
                -TempPath $validTemp -OutputVerbosity Quiet } |
            Should -Throw '*ResultPath must be a descendant of RepositoryRoot/artifacts*'
        { & $fixture.Runner -Path $testPath -ResultPath $validResult `
                -RepositoryRoot $fixture.Root -PythonPath $fakePython `
                -PytestConfig $fixture.Config -TestSuiteName 'temp-boundary' `
                -TempPath $outside -OutputVerbosity Quiet } |
            Should -Throw '*TempPath must be a descendant of RepositoryRoot/artifacts*'
        Test-Path -LiteralPath $outside | Should -BeFalse
    }

    It 'enforces nested-Python isolation when the runner is called directly' {
        if (-not $script:PythonPath) {
            Set-ItResult -Skipped -Because 'repository Python environment is unavailable'
            return
        }
        $fixture = New-PytestBatchFixtureRepository -Root (Join-Path $TestDrive 'direct-runner')
        $testPath = Write-PytestBatchFixture (Join-Path $fixture.Tests 'test_environment.py') `
            -Content @'
import os
import tempfile
from pathlib import Path

def test_runner_environment():
    assert "PYTEST_ADDOPTS" not in os.environ
    assert "PYTEST_PLUGINS" not in os.environ
    assert "CODEX_REGEN_FIXTURES" not in os.environ
    assert "PYTHONPATH" not in os.environ
    assert "PYTHONHOME" not in os.environ
    assert os.environ["PYTEST_DISABLE_PLUGIN_AUTOLOAD"] == "1"
    assert os.environ["PYTHONDONTWRITEBYTECODE"] == "1"
    assert os.environ["CODEX_TEMP"] == os.environ["TEMP"] == os.environ["TMP"] == os.environ["TMPDIR"]
    assert Path(tempfile.gettempdir()) == Path(os.environ["CODEX_TEMP"])
    assert Path(os.environ["CODEX_JSON_SCRATCH_ROOT"]).is_dir()
    assert Path(os.environ["CODEX_PROCUREMENT_RATE_CLOCK"]).parent == Path(os.environ["CODEX_TEMP"])
'@
        $resultPath = Join-Path $fixture.RunDirectory 'direct/pytest.xml'
        $tempPath = Join-Path $fixture.RunDirectory 'direct/temp'
        $saved = @{}
        foreach ($name in @('PYTEST_ADDOPTS', 'PYTEST_PLUGINS', 'CODEX_REGEN_FIXTURES',
                'PYTHONPATH', 'PYTHONHOME',
                'PYTEST_DISABLE_PLUGIN_AUTOLOAD', 'PYTHONDONTWRITEBYTECODE',
                'TMP', 'TEMP', 'TMPDIR', 'CODEX_TEMP', 'CODEX_JSON_SCRATCH_ROOT',
                'CODEX_PROCUREMENT_RATE_CLOCK')) {
            $saved[$name] = [System.Environment]::GetEnvironmentVariable($name, 'Process')
        }
        try {
            $env:PYTEST_ADDOPTS = '--collect-only'
            $env:PYTEST_PLUGINS = 'ambient_plugin'
            $env:CODEX_REGEN_FIXTURES = '1'
            $env:PYTHONPATH = Join-Path $TestDrive 'ambient-pythonpath'
            $env:PYTHONHOME = Join-Path $TestDrive 'ambient-pythonhome'
            $env:PYTEST_DISABLE_PLUGIN_AUTOLOAD = '0'
            $env:PYTHONDONTWRITEBYTECODE = '0'
            $env:CODEX_JSON_SCRATCH_ROOT = Join-Path $TestDrive 'host-scratch'

            Push-Location $TestDrive
            try {
                & $fixture.Runner -Path $testPath -ResultPath $resultPath `
                    -RepositoryRoot $fixture.Root -PythonPath $script:PythonPath `
                    -PytestConfig $fixture.Config -TestSuiteName 'direct-environment' `
                    -TempPath $tempPath -OutputVerbosity Quiet
            }
            finally { Pop-Location }
        }
        finally {
            foreach ($name in $saved.Keys) {
                [System.Environment]::SetEnvironmentVariable($name, $saved[$name], 'Process')
            }
        }

        [xml]$result = Get-Content -LiteralPath $resultPath -Raw
        [int]$result.testsuites.testsuite.tests | Should -Be 1
        [int]$result.testsuites.testsuite.failures | Should -Be 0
        Test-Path -LiteralPath (Join-Path $tempPath 'json-scratch') -PathType Container |
            Should -BeTrue
    }

    It 'retains pass, failure, and empty-selection evidence while isolating every child' {
        if (-not $script:PythonPath) {
            Set-ItResult -Skipped -Because 'repository Python environment is unavailable'
            return
        }
        $fixture = New-PytestBatchFixtureRepository -Root (Join-Path $TestDrive 'execution')
        $passPath = Write-PytestBatchFixture (Join-Path $fixture.Tests 'test_pass.py') -Content @'
import os
import tempfile
from pathlib import Path

def test_pass(tmp_path):
    artifact = Path(os.environ["CODEX_TEST_ARTIFACT_ROOT"])
    artifact.mkdir(parents=True, exist_ok=True)
    (artifact / "pass.txt").write_text("retained", encoding="utf-8")
    assert Path(os.environ["CODEX_TEMP"]).is_absolute()
    assert os.environ["CODEX_TEMP"] == os.environ["TEMP"] == os.environ["TMP"] == os.environ["TMPDIR"]
    assert Path(tempfile.gettempdir()) == Path(os.environ["CODEX_TEMP"])
    assert Path(os.environ["CODEX_JSON_SCRATCH_ROOT"]).is_dir()
    assert Path(os.environ["CODEX_PROCUREMENT_RATE_CLOCK"]).parent == Path(os.environ["CODEX_TEMP"])
    assert os.environ["PYTHONDONTWRITEBYTECODE"] == "1"
    assert os.environ["PYTEST_DISABLE_PLUGIN_AUTOLOAD"] == "1"
    assert "PYTEST_ADDOPTS" not in os.environ
    assert "CODEX_REGEN_FIXTURES" not in os.environ
    assert "PYTHONPATH" not in os.environ
    assert "PYTHONHOME" not in os.environ
    (tmp_path / "ephemeral.txt").write_text("temporary", encoding="utf-8")
'@
        $failPath = Write-PytestBatchFixture (Join-Path $fixture.Tests 'test_fail.py') -Content @'
import os
from pathlib import Path

def test_fail():
    artifact = Path(os.environ["CODEX_TEST_ARTIFACT_ROOT"])
    artifact.mkdir(parents=True, exist_ok=True)
    (artifact / "failure.txt").write_text("retained", encoding="utf-8")
    assert False, "planned pytest failure"
'@
        $common = @{
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            PythonPath = $script:PythonPath
            PowerShellPath = $script:PowerShellPath
            OutputVerbosity = 'Quiet'
        }
        $passJob = @(Get-PytestBatchJob @common -Path $passPath)[0]
        $failJob = @(Get-PytestBatchJob @common -Path $failPath)[0]
        $emptyJob = @(Get-PytestBatchJob @common -Path $passPath `
                -KeywordExpression '__no_such_test__')[0]

        $compiled = InModuleScope adapters -Parameters @{
            Jobs = @($passJob, $failJob, $emptyJob); BasePath = $fixture.Root
        } {
            New-BatchPlan -Job $Jobs -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0
        $execution = InModuleScope adapters -Parameters @{ Compiled = $compiled } {
            Invoke-BatchPlan -Plan $Compiled -MaxWorkers 3
        }

        @($execution.Results.Id) | Should -Be @($passJob.Id, $failJob.Id, $emptyJob.Id)
        $stateDiagnostics = @($execution.Results | ForEach-Object {
                [ordered]@{
                    id = $_.Id
                    state = $_.State
                    exit_code = $_.ExitCode
                    error = $_.Error
                    stdout = @($_.StdOut)
                    stderr = @($_.StdErr)
                }
            }) | ConvertTo-Json -Depth 8 -Compress
        @($execution.Results.State) | Should -Be @('Succeeded', 'Failed', 'Failed') `
            -Because $stateDiagnostics
        $execution.Summary.Total | Should -Be 3
        $execution.Summary.Succeeded | Should -Be 1
        $execution.Summary.Failed | Should -Be 2
        @($execution.Errors).Count | Should -Be 0

        $observations = foreach ($result in $execution.Results) {
            Test-Path -LiteralPath $result.Input.Metadata.ResultPath -PathType Leaf | Should -BeTrue
            Get-PytestBatchObservation -Output @($result.StdOut)
        }
        @($observations.pytest_exit_code) | Should -Be @(0, 1, 5)
        @($observations.selected) | Should -Be @(1, 1, 0)
        @($observations.passed) | Should -Be @(1, 0, 0)
        @($observations.failed) | Should -Be @(0, 1, 0)
        @($observations.errors) | Should -Be @(0, 0, 0)
        @($observations.skipped) | Should -Be @(0, 0, 0)
        foreach ($observation in $observations) {
            $observation.result_present | Should -BeTrue
            $observation.python_version | Should -Match '^3\.'
            $observation.pytest_version | Should -Not -BeNullOrEmpty
        }

        Test-Path -LiteralPath (Join-Path $passJob.Metadata.ArtifactRoot 'pass.txt') `
            -PathType Leaf | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $failJob.Metadata.ArtifactRoot 'failure.txt') `
            -PathType Leaf | Should -BeTrue
        foreach ($job in @($passJob, $failJob, $emptyJob)) {
            Test-Path -LiteralPath $job.Metadata.TempRoot -PathType Container | Should -BeTrue
            Test-Path -LiteralPath $job.Metadata.JsonScratchRoot -PathType Container | Should -BeTrue
        }
        @(Get-ChildItem -LiteralPath $fixture.Root -Recurse -Directory | Where-Object {
                $_.Name -in @('__pycache__', '.pytest_cache')
            }).Count | Should -Be 0

        $declaredWrites = @($passJob.Writes) + @($failJob.Writes) + @($emptyJob.Writes)
        foreach ($producedFile in @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File)) {
            $covered = $false
            foreach ($declaredWrite in $declaredWrites) {
                $relative = [System.IO.Path]::GetRelativePath($declaredWrite, $producedFile.FullName)
                if ($producedFile.FullName -eq $declaredWrite -or
                        (-not [System.IO.Path]::IsPathFullyQualified($relative) -and
                            $relative -ne '..' -and -not $relative.StartsWith(
                                ('..' + [System.IO.Path]::DirectorySeparatorChar),
                                [System.StringComparison]::Ordinal))) {
                    $covered = $true
                    break
                }
            }
            $covered | Should -BeTrue -Because `
                "produced file '$($producedFile.FullName)' must be covered by a declared write"
        }
    }
}
