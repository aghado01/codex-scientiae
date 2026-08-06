#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:AdaptersModuleRoot = Join-Path $script:RepositoryRoot 'src/adapters'
    $script:AdaptersManifest = Join-Path $script:AdaptersModuleRoot 'adapters.psd1'
    $script:BatchExecutorManifest = Join-Path $script:RepositoryRoot `
        'src/shared/batch-executor/batch-executor.psd1'
    $script:RepositoryRunner = Join-Path $script:RepositoryRoot 'tests/run.ps1'
    $livePester = Get-Module Pester | Sort-Object Version -Descending | Select-Object -First 1
    $script:LivePesterManifest = Join-Path $livePester.ModuleBase 'Pester.psd1'

    function New-TestBatchFixtureRepository {
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

    function Write-TestBatchFixture {
        param(
            [Parameter(Mandatory)] [string] $Path,
            [string] $Content = "Describe 'fixture' { It 'passes' { `$true | Should -BeTrue } }"
        )
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path))
        Set-Content -LiteralPath $Path -Encoding utf8 -Value $Content
        return $Path
    }

    Import-Module $script:AdaptersManifest -Force
}

AfterAll {
    Remove-Module adapters -Force -ErrorAction SilentlyContinue
    Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
}

Describe 'adapters module surface for test-batch' {
    It 'exports the approved adapter commands and keeps its helpers private' {
        $warnings = @()
        Import-Module $script:AdaptersManifest -Force -WarningVariable +warnings
        Import-Module $script:AdaptersManifest -Force -WarningVariable +warnings

        $warnings.Count | Should -Be 0
        @((Get-Module adapters).ExportedFunctions.Keys | Sort-Object) | Should -Be @(
            'Get-LatexBatchJob', 'Get-TestBatchJob')
        (Get-Module adapters).ExportedAliases.Count | Should -Be 0
        foreach ($helper in @(
                'Resolve-TestBatchJobAddress'
                'Find-TestBatchFile'
                'Resolve-TestBatchPesterDependency'
                'Get-TestBatchStableHash'
            )) {
            Get-Command $helper -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }

    It 'keeps all run-relative path composition in one pure private resolver' {
        $sourceFiles = @(
            Get-ChildItem -LiteralPath $script:AdaptersModuleRoot -Recurse -File |
                Where-Object Extension -In @('.ps1', '.psm1')
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
                                $node.Value -in @('test-jobs', 'pester.xml')
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
                                $node.GetCommandName() -eq 'Resolve-TestBatchJobAddress'
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
            'Resolve-TestBatchJobAddress', 'Resolve-TestBatchJobAddress')
        @($resolverCalls) | Should -Be @('Get-TestBatchJob')
        $sourceText.ToString() | Should -Not -Match '\bNew-Item\b|CreateDirectory\s*\('
    }
}

Describe 'Get-TestBatchJob planning' {
    It 'discovers one stable isolated process job per unique test file without creating run artifacts' {
        $fixture = New-TestBatchFixtureRepository -Root (Join-Path $TestDrive 'discovery')
        $alpha = Write-TestBatchFixture (Join-Path $fixture.Tests 'alpha.Tests.ps1')
        $beta = Write-TestBatchFixture (Join-Path $fixture.Tests 'group/beta.Tests.ps1') `
            -Content (('x' * 200) + "`nDescribe 'beta' { It 'passes' { `$true | Should -BeTrue } }")

        $invoke = @{
            Path = @($fixture.Tests, $alpha)
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            PesterManifest = $fixture.PesterManifest
        }
        $jobs = @(Get-TestBatchJob @invoke)
        $again = @(Get-TestBatchJob @invoke)

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
            $job.Writes | Should -Be @($job.Metadata.ResultPath)
            $job.Parameters.ResultPath | Should -Be $job.Metadata.ResultPath
            $relativeWrite = [System.IO.Path]::GetRelativePath(
                $fixture.RunDirectory, $job.Metadata.ResultPath)
            $relativeWrite | Should -Not -Be '..'
            $relativeWrite | Should -Not -Match '^\.\.[\\/]'
            $job.Metadata.AddressingContract | Should -Be 'D19/RunDirectory'
            $job.Metadata.ResultPersistence | Should -Be 'PesterNative'
            Test-Path -LiteralPath $job.Metadata.JobDirectory | Should -BeFalse
            Test-Path -LiteralPath $job.Metadata.ResultPath | Should -BeFalse
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
        $fixture = New-TestBatchFixtureRepository -Root (Join-Path $TestDrive 'filters')
        $testFile = Write-TestBatchFixture (Join-Path $fixture.Tests 'filter.Tests.ps1')
        $base = @(Get-TestBatchJob -Path $testFile -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest)[0]
        $filtered = @(Get-TestBatchJob -Path $testFile -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest `
                -FullNameFilter zeta,alpha,alpha -Tag slow,fast -ExcludeTag windows)[0]
        $reordered = @(Get-TestBatchJob -Path $testFile -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest `
                -FullNameFilter alpha,zeta -Tag fast,slow -ExcludeTag windows)[0]

        $filtered.Id | Should -Not -Be $base.Id
        $filtered.Id | Should -Be $reordered.Id
        $filtered.Metadata.ResultPath | Should -Be $reordered.Metadata.ResultPath
        @($filtered.Parameters.FullNameFilter) | Should -Be @('alpha', 'zeta')
        @($filtered.Parameters.Tag) | Should -Be @('fast', 'slow')
        @($filtered.Parameters.ExcludeTag) | Should -Be @('windows')
        $filtered.Parameters.TestSuiteName | Should -Be $filtered.Id
    }

    It 'rejects ambiguous ownership inputs before producing jobs or paths' {
        $fixture = New-TestBatchFixtureRepository -Root (Join-Path $TestDrive 'invalid')
        $testFile = Write-TestBatchFixture (Join-Path $fixture.Tests 'valid.Tests.ps1')
        $outside = Write-TestBatchFixture (Join-Path $TestDrive 'outside.Tests.ps1')
        $ordinary = Write-TestBatchFixture (Join-Path $fixture.Tests 'ordinary.ps1')
        $emptyDirectory = Join-Path $fixture.Root 'empty-tests'
        [void][System.IO.Directory]::CreateDirectory($emptyDirectory)
        $missingRun = Join-Path $fixture.Root 'missing-run'

        { Get-TestBatchJob -Path $testFile -RunDirectory 'relative-run' `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        { Get-TestBatchJob -Path $testFile -RunDirectory $missingRun `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        Test-Path -LiteralPath $missingRun | Should -BeFalse
        { Get-TestBatchJob -Path $outside -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*selection escapes RepositoryRoot*'
        { Get-TestBatchJob -Path $ordinary -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*is not a *.Tests.ps1 file*'
        { Get-TestBatchJob -Path $emptyDirectory -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $fixture.PesterManifest } |
            Should -Throw '*discovered no *.Tests.ps1 files*'
    }

    It 'prefers the highest portable Pester dependency without importing it during planning' {
        $fixture = New-TestBatchFixtureRepository -Root (Join-Path $TestDrive 'portable')
        $testFile = Write-TestBatchFixture (Join-Path $fixture.Tests 'portable.Tests.ps1')
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
            $job = @(Get-TestBatchJob -Path $testFile -RunDirectory $fixture.RunDirectory `
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

Describe 'test-batch execution integration' {
    It 'runs filtered and failing files in isolated children with stable in-memory results and native XML' {
        $fixture = New-TestBatchFixtureRepository -Root (Join-Path $TestDrive 'execution') `
            -UseRepositoryRunner
        $passPath = Write-TestBatchFixture (Join-Path $fixture.Tests 'pass.Tests.ps1') -Content @'
Describe 'filtered integration fixture' {
    It 'selected pass' {
        $env:CODEX_BATCH_JOB_ID | Should -Match '^test:'
    }
    It 'unselected failure' {
        throw 'this case must remain filtered out'
    }
}
'@
        $failPath = Write-TestBatchFixture (Join-Path $fixture.Tests 'fail.Tests.ps1') -Content @'
Describe 'failing integration fixture' {
    It 'fails locally' {
        throw 'planned isolated failure'
    }
}
'@
        $passJob = @(Get-TestBatchJob -Path $passPath -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -PesterManifest $script:LivePesterManifest `
                -FullNameFilter '*selected pass*' -OutputVerbosity None)[0]
        $failJob = @(Get-TestBatchJob -Path $failPath -RunDirectory $fixture.RunDirectory `
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
        $passXml = [xml](Get-Content -LiteralPath $passJob.Metadata.ResultPath -Raw)
        $failXml = [xml](Get-Content -LiteralPath $failJob.Metadata.ResultPath -Raw)
        [int]$passXml.'test-results'.total | Should -Be 1
        [int]$passXml.'test-results'.failures | Should -Be 0
        [int]$failXml.'test-results'.total | Should -Be 1
        [int]$failXml.'test-results'.failures | Should -Be 1
        $declaredWrites = @($passJob.Writes) + @($failJob.Writes)
        $producedFiles = @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File)
        @($producedFiles.FullName | Sort-Object) | Should -Be `
            @($declaredWrites | Sort-Object)
        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File |
                Where-Object Extension -In @('.json', '.jsonl')).Count | Should -Be 0
    }
}
