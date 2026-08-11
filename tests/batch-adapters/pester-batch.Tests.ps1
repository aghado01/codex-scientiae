#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:AdaptersModuleRoot = Join-Path $script:RepositoryRoot 'src/batch-adapters'
    $script:AdaptersManifest = Join-Path $script:AdaptersModuleRoot 'adapters.psd1'
    $script:BatchExecutorManifest = Join-Path $script:RepositoryRoot `
        'src/batch-executor/batch-executor.psd1'
    $script:RepositoryRunner = Join-Path $script:RepositoryRoot 'tests/run.ps1'
    $livePester = Get-Module Pester | Sort-Object Version -Descending | Select-Object -First 1
    $script:LivePesterManifest = Join-Path $livePester.ModuleBase 'Pester.psd1'

    function New-PesterBatchFixtureRepository {
        param(
            [Parameter(Mandatory)] [string] $Root,
            [version] $PesterVersion = [version]'5.7.1',
            [switch] $UseRepositoryRunner
        )

        $repository = Join-Path $Root 'repository'
        $tests = Join-Path $repository 'tests'
        $run = Join-Path $Root 'caller-run'
        $pesterRoot = Join-Path $Root "dependencies/Pester/$PesterVersion"
        foreach ($directory in @($repository, $tests, $run, $pesterRoot)) {
            [void][System.IO.Directory]::CreateDirectory($directory)
        }
        $runner = Join-Path $tests 'run.ps1'
        if ($UseRepositoryRunner) {
            Copy-Item -LiteralPath $script:RepositoryRunner -Destination $runner
        }
        else {
            Set-Content -LiteralPath $runner -Encoding utf8 -Value 'param()'
        }
        Set-Content -LiteralPath (Join-Path $pesterRoot 'Pester.psm1') `
            -Encoding utf8 -Value '# fixture Pester module'
        $manifest = Join-Path $pesterRoot 'Pester.psd1'
        Set-Content -LiteralPath $manifest -Encoding utf8 -Value @"
@{
    RootModule = 'Pester.psm1'
    ModuleVersion = '$PesterVersion'
    GUID = '592a0fbe-d403-47f8-8c09-9b92f1f8fb44'
    FunctionsToExport = @()
}
"@
        return [pscustomobject]@{
            Root = $repository
            Tests = $tests
            RunDirectory = $run
            Runner = $runner
            PesterManifest = $manifest
        }
    }

    function Write-PesterBatchFixture {
        param(
            [Parameter(Mandatory)] [string] $Path,
            [string] $Content = "Describe 'fixture' { It 'passes' { `$true | Should -BeTrue } }"
        )
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path))
        Set-Content -LiteralPath $Path -Encoding utf8 -Value $Content
        return $Path
    }

    function Write-TestRunnerHost {
        param([Parameter(Mandatory)] [string] $Path)

        Set-Content -LiteralPath $Path -Encoding utf8 -Value @'
#requires -Version 7.0
param(
    [Parameter(Mandatory)] [string] $PesterManifest,
    [Parameter(Mandatory)] [string] $Runner,
    [Parameter(Mandatory)] [string] $TestPath,
    [Parameter(Mandatory)] [string] $ResultPath,
    [Parameter(Mandatory)] [string] $TestSuiteName,
    [string] $FullNameFilter = ''
)
Import-Module -Name $PesterManifest -Force
$invoke = @{
    Path = $TestPath
    ResultPath = $ResultPath
    ResultFormat = 'NUnitXml'
    TestSuiteName = $TestSuiteName
    OutputVerbosity = 'None'
}
if (-not [string]::IsNullOrWhiteSpace($FullNameFilter)) {
    $invoke.FullNameFilter = @($FullNameFilter)
}
& $Runner @invoke
'@
        return $Path
    }

    function Invoke-TestRunnerChild {
        param(
            [Parameter(Mandatory)] [string] $HostPath,
            [Parameter(Mandatory)] [string] $PesterManifest,
            [Parameter(Mandatory)] [string] $Runner,
            [Parameter(Mandatory)] [string] $TestPath,
            [Parameter(Mandatory)] [string] $ResultPath,
            [Parameter(Mandatory)] [string] $TestSuiteName,
            [string] $FullNameFilter = ''
        )

        $arguments = @(
            '-NoProfile', '-File', $HostPath,
            '-PesterManifest', $PesterManifest,
            '-Runner', $Runner,
            '-TestPath', $TestPath,
            '-ResultPath', $ResultPath,
            '-TestSuiteName', $TestSuiteName
        )
        if (-not [string]::IsNullOrWhiteSpace($FullNameFilter)) {
            $arguments += @('-FullNameFilter', $FullNameFilter)
        }
        $output = @(& ([System.Environment]::ProcessPath) @arguments 2>&1)
        return [pscustomobject]@{
            ExitCode = $LASTEXITCODE
            Output = @($output | ForEach-Object { $_.ToString() })
        }
    }

    function Get-TestRunnerObservation {
        param([Parameter(Mandatory)] [string[]] $Output)

        $matches = @($Output | ForEach-Object {
                if ($_ -match 'PesterContainerObservation\s+(\{.+\})') { $Matches[1] }
            })
        $matches.Count | Should -Be 1
        return ($matches[0] | ConvertFrom-Json)
    }

    function Get-TestRunnerParityManifest {
        $pesterRoot = Join-Path $env:PORTABLE_ROOT 'PowerShell/Modules/Pester'
        foreach ($version in @('5.7.1', '6.0.0')) {
            $manifest = Join-Path $pesterRoot "$version/Pester.psd1"
            Test-Path -LiteralPath $manifest -PathType Leaf | Should -BeTrue
            [pscustomobject]@{ Version = $version; Manifest = $manifest }
        }
    }

    Import-Module $script:AdaptersManifest -Force
}

AfterAll {
    Remove-Module adapters -Force -ErrorAction SilentlyContinue
    Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
}

Describe 'adapters module surface for pester-batch' {
    It 'exports the approved adapter commands and keeps its helpers private' {
        $warnings = @()
        Import-Module $script:AdaptersManifest -Force -WarningVariable +warnings
        Import-Module $script:AdaptersManifest -Force -WarningVariable +warnings

        $warnings.Count | Should -Be 0
        @((Get-Module adapters).ExportedFunctions.Keys | Sort-Object) | Should -Be @(
            'Get-PesterBatchJob', 'Get-PytestBatchJob')
        (Get-Module adapters).ExportedAliases.Count | Should -Be 0
        Get-Command Get-TestBatchJob -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        foreach ($oldPath in @(
                (Join-Path $script:AdaptersModuleRoot ('private/test-' + 'address.ps1'))
                (Join-Path $script:AdaptersModuleRoot ('private/test-' + 'discovery.ps1'))
                (Join-Path $script:AdaptersModuleRoot ('public/Get-' + 'TestBatchJob.ps1'))
                (Join-Path $script:RepositoryRoot ('tests/batch-adapters/test-' + 'batch.Tests.ps1'))
            )) {
            Test-Path -LiteralPath $oldPath | Should -BeFalse
        }
        foreach ($helper in @(
                'Resolve-PesterBatchJobAddress'
                'Find-PesterBatchFile'
                'Resolve-PesterBatchDependency'
                'Get-PesterBatchStableHash'
            )) {
            Get-Command $helper -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }

    It 'keeps all run-relative path composition in one pure private resolver' {
        $sourceFiles = @(
            Get-ChildItem -LiteralPath $script:AdaptersModuleRoot -Recurse -File |
                Where-Object {
                    $_.Extension -in @('.ps1', '.psm1') -and $_.Name -match '(?i)pester'
                }
        )
        $addressLiteralOwners = [System.Collections.Generic.List[string]]::new()
        $resolverCalls = [System.Collections.Generic.List[string]]::new()
        $sourceText = [System.Text.StringBuilder]::new()
        foreach ($sourceFile in $sourceFiles) {
            $tokens = $null
            $parseErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile(
                $sourceFile.FullName, [ref]$tokens, [ref]$parseErrors)
            $parseErrors.Count | Should -Be 0
            [void]$sourceText.AppendLine($ast.Extent.Text)

            foreach ($literal in @($ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
                                $node.Value -in @('pester-jobs', 'pester.xml', 'artifacts')
                        }, $true))) {
                $owner = $literal.Parent
                while ($null -ne $owner -and $owner -isnot `
                        [System.Management.Automation.Language.FunctionDefinitionAst]) {
                    $owner = $owner.Parent
                }
                $addressLiteralOwners.Add($owner.Name)
            }
            foreach ($command in @($ast.FindAll({
                            param($node)
                            $node -is [System.Management.Automation.Language.CommandAst] -and
                                $node.GetCommandName() -eq 'Resolve-PesterBatchJobAddress'
                        }, $true))) {
                $owner = $command.Parent
                while ($null -ne $owner -and $owner -isnot `
                        [System.Management.Automation.Language.FunctionDefinitionAst]) {
                    $owner = $owner.Parent
                }
                $resolverCalls.Add($owner.Name)
            }
        }

        @($addressLiteralOwners) | Should -Be @(
            'Resolve-PesterBatchJobAddress'
            'Resolve-PesterBatchJobAddress'
            'Resolve-PesterBatchJobAddress'
        )
        @($resolverCalls) | Should -Be @('Get-PesterBatchJob')
        $sourceText.ToString() | Should -Not -Match '\bNew-Item\b|CreateDirectory\s*\('
        $sourceText.ToString() | Should -Not -Match `
            'Get-TestBatchJob|\bTestBatch\b|test-batch|test-jobs'
    }
}

Describe 'Get-PesterBatchJob planning' {
    It 'discovers one stable isolated process job per unique test file without creating run artifacts' {
        $fixture = New-PesterBatchFixtureRepository -Root (Join-Path $TestDrive 'discovery')
        $alpha = Write-PesterBatchFixture (Join-Path $fixture.Tests 'alpha.Tests.ps1')
        $beta = Write-PesterBatchFixture (Join-Path $fixture.Tests 'group/beta.Tests.ps1') `
            -Content (('x' * 200) + "`nDescribe 'beta' { It 'passes' { `$true | Should -BeTrue } }")

        $invoke = @{
            Path = @($fixture.Tests, $alpha)
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            PesterManifest = $fixture.PesterManifest
        }
        $jobs = @(Get-PesterBatchJob @invoke)
        $again = @(Get-PesterBatchJob @invoke)

        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -Force).Count | Should -Be 0
        $jobs.Count | Should -Be 2
        @($jobs.Id) | Should -Be @($again.Id)
        $expectedRelativePaths = @($alpha, $beta) | ForEach-Object {
            [System.IO.Path]::GetRelativePath($fixture.Root, $_) -replace '\\', '/'
        }
        @($jobs.Metadata.RepositoryRelativePath) | Should -Be $expectedRelativePaths
        foreach ($job in $jobs) {
            $job.Kind | Should -Be 'PowerShellProcess'
            $job.EntryPoint | Should -Be $fixture.Runner
            $job.WorkingDirectory | Should -Be $fixture.Root
            $job.ModulePath | Should -Be @($fixture.PesterManifest)
            $job.Id | Should -Match '^pester:'
            $job.Writes | Should -Be @($job.Metadata.ResultPath, $job.Metadata.ArtifactRoot)
            $job.Parameters.ResultPath | Should -Be $job.Metadata.ResultPath
            $job.ProcessSpec.Environment.CODEX_TEST_ARTIFACT_ROOT |
                Should -Be $job.Metadata.ArtifactRoot
            foreach ($write in @($job.Metadata.ResultPath, $job.Metadata.ArtifactRoot)) {
                $relativeWrite = [System.IO.Path]::GetRelativePath($fixture.RunDirectory, $write)
                $relativeWrite | Should -Not -Be '..'
                $relativeWrite | Should -Not -Match '^\.\.[\\/]'
            }
            $job.Metadata.AddressingContract | Should -Be 'D19/RunDirectory'
            $job.Metadata.ArtifactContract | Should -Be 'D23/ContainerRoot'
            $job.Metadata.ArtifactEnvironment | Should -Be 'CODEX_TEST_ARTIFACT_ROOT'
            $job.Metadata.ResultPersistence | Should -Be 'PesterNative'
            Test-Path -LiteralPath $job.Metadata.JobDirectory | Should -BeFalse
            Test-Path -LiteralPath $job.Metadata.ResultPath | Should -BeFalse
            Test-Path -LiteralPath $job.Metadata.ArtifactRoot | Should -BeFalse
        }
        $jobs[1].EstimatedCost | Should -BeGreaterThan $jobs[0].EstimatedCost

        $compiled = InModuleScope adapters -Parameters @{
            Jobs = $jobs; BasePath = $fixture.Root
        } {
            New-BatchPlan -Job $Jobs -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0
        $compiled.Plan.Jobs.Count | Should -Be 2
        $compiled.Plan.DispatchJobs[0].Id | Should -Be $jobs[1].Id
    }

    It 'normalizes case and tag filters into test identity and runner parameters' {
        $fixture = New-PesterBatchFixtureRepository -Root (Join-Path $TestDrive 'filters')
        $testFile = Write-PesterBatchFixture (Join-Path $fixture.Tests 'filter.Tests.ps1')
        $base = @(Get-PesterBatchJob -Path $testFile -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest)[0]
        $filtered = @(Get-PesterBatchJob -Path $testFile -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest `
                -FullNameFilter zeta,alpha,alpha -Tag slow,fast -ExcludeTag windows)[0]
        $reordered = @(Get-PesterBatchJob -Path $testFile -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest `
                -FullNameFilter alpha,zeta -Tag fast,slow -ExcludeTag windows)[0]

        $filtered.Id | Should -Not -Be $base.Id
        $filtered.Id | Should -Be $reordered.Id
        $filtered.Metadata.ResultPath | Should -Be $reordered.Metadata.ResultPath
        $filtered.Metadata.ArtifactRoot | Should -Be $reordered.Metadata.ArtifactRoot
        @($filtered.Parameters.FullNameFilter) | Should -Be @('alpha', 'zeta')
        @($filtered.Parameters.Tag) | Should -Be @('fast', 'slow')
        @($filtered.Parameters.ExcludeTag) | Should -Be @('windows')
        $filtered.Parameters.TestSuiteName | Should -Be $filtered.Id
    }

    It 'rejects ambiguous ownership inputs before producing jobs or paths' {
        $fixture = New-PesterBatchFixtureRepository -Root (Join-Path $TestDrive 'invalid')
        $testFile = Write-PesterBatchFixture (Join-Path $fixture.Tests 'valid.Tests.ps1')
        $outside = Write-PesterBatchFixture (Join-Path $TestDrive 'outside.Tests.ps1')
        $ordinary = Write-PesterBatchFixture (Join-Path $fixture.Tests 'ordinary.ps1')
        $emptyDirectory = Join-Path $fixture.Root 'empty-tests'
        [void][System.IO.Directory]::CreateDirectory($emptyDirectory)
        $missingRun = Join-Path $fixture.Root 'missing-run'

        { Get-PesterBatchJob -Path $testFile -RunDirectory 'relative-run' `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        { Get-PesterBatchJob -Path $testFile -RunDirectory $missingRun `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        Test-Path -LiteralPath $missingRun | Should -BeFalse
        { Get-PesterBatchJob -Path $outside -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*selection escapes RepositoryRoot*'
        { Get-PesterBatchJob -Path $ordinary -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*is not a *.Tests.ps1 file*'
        { Get-PesterBatchJob -Path $emptyDirectory -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*discovered no *.Tests.ps1 files*'
    }

    It 'prefers the highest portable Pester dependency without importing it during planning' {
        $fixture = New-PesterBatchFixtureRepository -Root (Join-Path $TestDrive 'portable')
        $testFile = Write-PesterBatchFixture (Join-Path $fixture.Tests 'portable.Tests.ps1')
        $portableRoot = Join-Path $TestDrive 'portable-root'
        $pesterRoot = Join-Path $portableRoot 'PowerShell/Modules/Pester'
        foreach ($version in @('5.7.1', '6.0.0')) {
            $versionRoot = Join-Path $pesterRoot $version
            [void][System.IO.Directory]::CreateDirectory($versionRoot)
            Set-Content -LiteralPath (Join-Path $versionRoot 'Pester.psm1') `
                -Encoding utf8 -Value '# portable fixture'
            Set-Content -LiteralPath (Join-Path $versionRoot 'Pester.psd1') -Encoding utf8 -Value @"
@{ RootModule = 'Pester.psm1'; ModuleVersion = '$version'; GUID = 'b4c6f1a2-8353-44bd-b92b-77e82de9bfb7' }
"@
        }
        $savedPortableRoot = $env:PORTABLE_ROOT
        try {
            $env:PORTABLE_ROOT = $portableRoot
            $job = @(Get-PesterBatchJob -Path $testFile -RunDirectory $fixture.RunDirectory `
                    -RepositoryRoot $fixture.Root)[0]
            $job.Metadata.PesterVersion | Should -Be '6.0.0'
            $job.Metadata.PesterManifest | Should -Be `
                (Join-Path $pesterRoot '6.0.0/Pester.psd1')
            @(Get-Module Pester -All | Where-Object Path -EQ `
                    (Join-Path $pesterRoot '6.0.0/Pester.psd1')).Count | Should -Be 0
        }
        finally { $env:PORTABLE_ROOT = $savedPortableRoot }
    }
}

Describe 'repository Pester runner contract' {
    It 'keeps one exact-container invocation boundary and owns no batch infrastructure' {
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $script:RepositoryRunner, [ref]$tokens, [ref]$parseErrors)
        $parseErrors.Count | Should -Be 0

        @($ast.ParamBlock.Parameters.Name.VariablePath.UserPath) | Should -Be @(
            'Path'
            'ResultPath'
            'ResultFormat'
            'TestSuiteName'
            'OutputVerbosity'
            'FullNameFilter'
            'Tag'
            'ExcludeTag'
        )
        $commands = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.CommandAst]
                }, $true) | ForEach-Object GetCommandName)
        @($commands | Where-Object { $_ -eq 'New-PesterContainer' }).Count | Should -Be 1
        @($commands | Where-Object { $_ -eq 'Invoke-Pester' }).Count | Should -Be 1
        @($commands | Where-Object { $_ -in @(
                    'New-BatchJob', 'New-BatchPlan', 'Invoke-BatchPlan', 'Invoke-BatchExecutor',
                    'Start-Job', 'Start-ThreadJob', 'Start-Process',
                    'Start-RunLog', 'Write-RunLog', 'Stop-RunLog',
                    'New-ModuleRunDir', 'Start-Sleep',
                    'Set-Content', 'Add-Content', 'Out-File', 'Export-Clixml'
                ) }).Count | Should -Be 0

        $source = $ast.Extent.Text
        $source | Should -Not -Match '\bRunDirectory\b|\bMaxWorkers\b|\bRetry\b|CODEX_RUNLOG|RunspacePool'
        @([regex]::Matches($source, 'PesterContainerObservation')).Count | Should -Be 1
    }

    It 'preserves exact-path selection and its audit observation across Pester 5 and 6' {
        $fixture = New-PesterBatchFixtureRepository -Root (Join-Path $TestDrive 'runner-exact') `
            -UseRepositoryRunner
        $hostPath = Write-TestRunnerHost (Join-Path $TestDrive 'runner-exact-host.ps1')
        $selected = Write-PesterBatchFixture (Join-Path $fixture.Tests 'selected.Tests.ps1') -Content @'
Describe 'selected container' {
    It 'selected pass' { $true | Should -BeTrue }
    It 'unselected failure' { throw 'full-name filter failed' }
}
'@
        $null = Write-PesterBatchFixture (Join-Path $fixture.Tests 'sibling.Tests.ps1') -Content @'
Describe 'sibling container' {
    It 'must not run' { throw 'exact path expanded to a sibling' }
}
'@

        foreach ($pester in @(Get-TestRunnerParityManifest)) {
            $resultPath = Join-Path $fixture.RunDirectory "exact-$($pester.Version).xml"
            $run = Invoke-TestRunnerChild -HostPath $hostPath -PesterManifest $pester.Manifest `
                -Runner $fixture.Runner -TestPath $selected -ResultPath $resultPath `
                -TestSuiteName "exact-$($pester.Version)" -FullNameFilter '*selected pass*'

            $run.ExitCode | Should -Be 0 -Because "Pester $($pester.Version) must preserve exact selection"
            Test-Path -LiteralPath $resultPath -PathType Leaf | Should -BeTrue
            $xml = [xml](Get-Content -LiteralPath $resultPath -Raw)
            [int]$xml.'test-results'.total | Should -Be 1
            [int]$xml.'test-results'.failures | Should -Be 0
            $observation = Get-TestRunnerObservation -Output $run.Output
            @($observation.psobject.Properties.Name) | Should -Be @(
                'container_path', 'selected', 'passed', 'failed', 'skipped', 'duration_ms', 'result_path')
            $observation.container_path | Should -Be ([System.IO.Path]::GetFullPath($selected))
            $observation.selected | Should -Be 1
            $observation.passed | Should -Be 1
            $observation.failed | Should -Be 0
            $observation.skipped | Should -Be 0
            $observation.duration_ms | Should -BeGreaterOrEqual 0
            $observation.result_path | Should -Be ([System.IO.Path]::GetFullPath($resultPath))
        }
    }

    It 'preserves native failure, skip, empty-run, and exit-status semantics across Pester 5 and 6' {
        $fixture = New-PesterBatchFixtureRepository -Root (Join-Path $TestDrive 'runner-outcomes') `
            -UseRepositoryRunner
        $hostPath = Write-TestRunnerHost (Join-Path $TestDrive 'runner-outcome-host.ps1')
        $mixed = Write-PesterBatchFixture (Join-Path $fixture.Tests 'mixed.Tests.ps1') -Content @'
Describe 'mixed outcomes' {
    It 'passes' { $true | Should -BeTrue }
    It 'skips' -Skip { throw 'skip body ran' }
    It 'fails' { throw 'planned runner failure' }
}
'@

        foreach ($pester in @(Get-TestRunnerParityManifest)) {
            $failureResult = Join-Path $fixture.RunDirectory "failure-$($pester.Version).xml"
            $failedRun = Invoke-TestRunnerChild -HostPath $hostPath -PesterManifest $pester.Manifest `
                -Runner $fixture.Runner -TestPath $mixed -ResultPath $failureResult `
                -TestSuiteName "failure-$($pester.Version)"
            $failedRun.ExitCode | Should -Not -Be 0
            Test-Path -LiteralPath $failureResult -PathType Leaf | Should -BeTrue
            $failureXml = [xml](Get-Content -LiteralPath $failureResult -Raw)
            [int]$failureXml.'test-results'.total | Should -Be 3
            [int]$failureXml.'test-results'.failures | Should -Be 1
            [int]$failureXml.'test-results'.skipped | Should -Be 1
            $failureObservation = Get-TestRunnerObservation -Output $failedRun.Output
            @($failureObservation.selected, $failureObservation.passed,
                $failureObservation.failed, $failureObservation.skipped) | Should -Be @(3, 1, 1, 1)
            $failureObservation.result_path | Should -Be ([System.IO.Path]::GetFullPath($failureResult))

            $emptyResult = Join-Path $fixture.RunDirectory "empty-$($pester.Version).xml"
            $emptyRun = Invoke-TestRunnerChild -HostPath $hostPath -PesterManifest $pester.Manifest `
                -Runner $fixture.Runner -TestPath $mixed -ResultPath $emptyResult `
                -TestSuiteName "empty-$($pester.Version)" -FullNameFilter '*does not exist*'
            $emptyRun.ExitCode | Should -Not -Be 0
            Test-Path -LiteralPath $emptyResult -PathType Leaf | Should -BeTrue
            $emptyXml = [xml](Get-Content -LiteralPath $emptyResult -Raw)
            [int]$emptyXml.'test-results'.total | Should -Be 0
            $emptyObservation = Get-TestRunnerObservation -Output $emptyRun.Output
            @($emptyObservation.selected, $emptyObservation.passed,
                $emptyObservation.failed, $emptyObservation.skipped) | Should -Be @(0, 0, 0, 0)
            $emptyObservation.result_path | Should -Be ([System.IO.Path]::GetFullPath($emptyResult))
        }
    }
}

Describe 'pester-batch execution integration' {
    It 'runs filtered and failing files in isolated children with stable in-memory results and native XML' {
        $fixture = New-PesterBatchFixtureRepository -Root (Join-Path $TestDrive 'execution') `
            -UseRepositoryRunner
        $passPath = Write-PesterBatchFixture (Join-Path $fixture.Tests 'pass.Tests.ps1') -Content @'
Describe 'filtered integration fixture' {
    It 'selected pass' {
        $env:CODEX_BATCH_JOB_ID | Should -Match '^pester:'
        [System.IO.Path]::IsPathFullyQualified($env:CODEX_TEST_ARTIFACT_ROOT) | Should -BeTrue
        $caseRoot = Join-Path $env:CODEX_TEST_ARTIFACT_ROOT 'selected-pass'
        [void][System.IO.Directory]::CreateDirectory($caseRoot)
        Set-Content -LiteralPath (Join-Path $caseRoot 'witness.txt') -Value 'pass artifact'
    }
    It 'unselected failure' {
        throw 'this case must remain filtered out'
    }
}
'@
        $failPath = Write-PesterBatchFixture (Join-Path $fixture.Tests 'fail.Tests.ps1') -Content @'
Describe 'failing integration fixture' {
    It 'fails locally' {
        [System.IO.Path]::IsPathFullyQualified($env:CODEX_TEST_ARTIFACT_ROOT) | Should -BeTrue
        $caseRoot = Join-Path $env:CODEX_TEST_ARTIFACT_ROOT 'fails-locally'
        [void][System.IO.Directory]::CreateDirectory($caseRoot)
        Set-Content -LiteralPath (Join-Path $caseRoot 'witness.txt') -Value 'failure artifact'
        throw 'planned isolated failure'
    }
}
'@
        $passJob = @(Get-PesterBatchJob -Path $passPath -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $script:LivePesterManifest `
                -FullNameFilter '*selected pass*' -OutputVerbosity None)[0]
        $failJob = @(Get-PesterBatchJob -Path $failPath -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $script:LivePesterManifest `
                -OutputVerbosity None)[0]
        $compiled = InModuleScope adapters -Parameters @{
            Jobs = @($passJob, $failJob); BasePath = $fixture.Root
        } {
            New-BatchPlan -Job $Jobs -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0

        $execution = InModuleScope adapters -Parameters @{ Compiled = $compiled } {
            Invoke-BatchPlan -Plan $Compiled -MaxWorkers 2
        }

        @($execution.Results.Id) | Should -Be @($passJob.Id, $failJob.Id)
        @($execution.Results.State) | Should -Be @('Succeeded', 'Failed')
        $execution.Summary.Succeeded | Should -Be 1
        $execution.Summary.Failed | Should -Be 1
        Test-Path -LiteralPath $passJob.Metadata.ResultPath -PathType Leaf | Should -BeTrue
        Test-Path -LiteralPath $failJob.Metadata.ResultPath -PathType Leaf | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $passJob.Metadata.ArtifactRoot `
                'selected-pass/witness.txt') -PathType Leaf | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $failJob.Metadata.ArtifactRoot `
                'fails-locally/witness.txt') -PathType Leaf | Should -BeTrue
        $passXml = [xml](Get-Content -LiteralPath $passJob.Metadata.ResultPath -Raw)
        $failXml = [xml](Get-Content -LiteralPath $failJob.Metadata.ResultPath -Raw)
        [int]$passXml.'test-results'.total | Should -Be 1
        [int]$passXml.'test-results'.failures | Should -Be 0
        [int]$failXml.'test-results'.total | Should -Be 1
        [int]$failXml.'test-results'.failures | Should -Be 1
        $passObservation = Get-TestRunnerObservation -Output @(
            $execution.Results[0].StdOut | ForEach-Object { $_.ToString() })
        @($passObservation.selected, $passObservation.passed,
            $passObservation.failed, $passObservation.skipped) | Should -Be @(1, 1, 0, 0)
        $passObservation.result_path | Should -Be $passJob.Metadata.ResultPath
        $failObservation = Get-TestRunnerObservation -Output @(
            $execution.Results[1].StdOut | ForEach-Object { $_.ToString() })
        @($failObservation.selected, $failObservation.passed,
            $failObservation.failed, $failObservation.skipped) | Should -Be @(1, 0, 1, 0)
        $failObservation.result_path | Should -Be $failJob.Metadata.ResultPath
        $declaredWrites = @($passJob.Writes) + @($failJob.Writes)
        $producedFiles = @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File)
        foreach ($producedFile in $producedFiles) {
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
        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File |
                Where-Object Extension -In @('.json', '.jsonl')).Count | Should -Be 0
    }
}
