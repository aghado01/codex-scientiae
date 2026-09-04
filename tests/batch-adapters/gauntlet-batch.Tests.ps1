#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:AdaptersModuleRoot = Join-Path $script:RepositoryRoot 'src/batch-adapters'
    $script:AdaptersManifest = Join-Path $script:AdaptersModuleRoot 'adapters.psd1'
    $script:BatchExecutorManifest = Join-Path $script:RepositoryRoot `
        'src/batch-executor/batch-executor.psd1'

    function Write-GauntletDeposit {
        <# One deposited article: article.json plus a {slug}-tex tree holding
           TreeBytes of source. Shape follows codex-scientiae/article/0.1 as
           far as the adapter reads it (slug, source_forms latex-source-tree). #>
        param(
            [Parameter(Mandatory)] [string] $Collection,
            [Parameter(Mandatory)] [string] $Slug,
            [int] $TreeBytes = 64,
            [string] $TreeSha256 = ('0' * 64)
        )
        $article = Join-Path $Collection $Slug
        $tree = Join-Path $article "$Slug-tex"
        [void][System.IO.Directory]::CreateDirectory($tree)
        Set-Content -LiteralPath (Join-Path $tree 'main.tex') -Encoding ascii -NoNewline `
            -Value ('%' * $TreeBytes)
        $manifest = [ordered]@{
            schema = 'codex-scientiae/article/0.1'
            state = 'source-ready'
            slug = $Slug
            source_forms = @(
                [ordered]@{
                    role = 'latex-source-tree'
                    path = "$Slug-tex"
                    format = 'application/x-latex-source-tree'
                    entrypoint = 'main.tex'
                    files = 1
                    tex_files = 1
                    sha256 = $TreeSha256
                }
            )
        }
        Set-Content -LiteralPath (Join-Path $article 'article.json') -Encoding utf8 `
            -Value ($manifest | ConvertTo-Json -Depth 6)
        return (Resolve-Path -LiteralPath $article).Path
    }

    function Write-GauntletStubWorker {
        <# The engine-side child entrypoint the adapter freezes. It proves the
           hop: it records what it was handed and what environment it ran in,
           creates only its own job container, and exits 0. #>
        param([Parameter(Mandatory)] [string] $Path)
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path))
        Set-Content -LiteralPath $Path -Encoding utf8 -Value @'
#requires -Version 7.0
param(
    [Parameter(Mandatory)] [string] $Article,
    [Parameter(Mandatory)] [string] $OutDirectory,
    [Parameter(Mandatory)] [string] $EngineRoot,
    [string] $Marker = ''
)
$ErrorActionPreference = 'Stop'
[void][System.IO.Directory]::CreateDirectory($OutDirectory)
$receipt = [ordered]@{
    schema = 'codex-scientiae/gauntlet-receipt/0.1'
    status = 'ok'
    article = $Article
    outDirectory = $OutDirectory
    engineRoot = $EngineRoot
    marker = $Marker
    temp = $env:CDXSCI_TEMP
    osTemp = $env:TEMP
    jobId = $env:CDXSCI_BATCH_JOB_ID
    location = (Get-Location).Path
}
$receipt | ConvertTo-Json -Depth 4 |
    Set-Content -LiteralPath (Join-Path $OutDirectory 'receipt.json') -Encoding utf8
'@
        return (Resolve-Path -LiteralPath $Path).Path
    }

    function New-GauntletBatchFixture {
        <# A codex-scientiae-shaped repository (artifacts run dir + one
           gauntlet collection) beside a separate engine root that owns the
           worker. The two never nest. #>
        param([Parameter(Mandatory)] [string] $Root)

        $repository = Join-Path $Root 'repository'
        $run = Join-Path $repository 'artifacts/gauntlet/20261208_000000/stub'
        $collection = Join-Path $repository 'supellex/gauntlet/alpha'
        $engine = Join-Path $Root 'engine'
        foreach ($directory in @($repository, $run, $collection, $engine)) {
            [void][System.IO.Directory]::CreateDirectory($directory)
        }
        $small = Write-GauntletDeposit -Collection $collection -Slug 'a-small' -TreeBytes 64 `
            -TreeSha256 ('a' * 64)
        $large = Write-GauntletDeposit -Collection $collection -Slug 'b-large' -TreeBytes 4096 `
            -TreeSha256 ('b' * 64)
        # A collection child without article.json is not a deposit and is skipped.
        [void][System.IO.Directory]::CreateDirectory((Join-Path $collection 'not-a-deposit'))
        $worker = Write-GauntletStubWorker -Path (Join-Path $engine 'private/gauntlet/worker.ps1')

        return [pscustomobject]@{
            Root = (Resolve-Path -LiteralPath $repository).Path
            RunDirectory = (Resolve-Path -LiteralPath $run).Path
            Collection = (Resolve-Path -LiteralPath $collection).Path
            Small = $small
            Large = $large
            EngineRoot = (Resolve-Path -LiteralPath $engine).Path
            Worker = $worker
        }
    }

    Import-Module $script:BatchExecutorManifest -Force
    Import-Module $script:AdaptersManifest -Force
}

AfterAll {
    Remove-Module adapters -Force -ErrorAction SilentlyContinue
    Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
}

Describe 'adapters module surface for gauntlet-batch' {
    It 'exports Get-GauntletBatchJob and keeps its helpers private' {
        (Get-Module adapters).ExportedFunctions.Keys | Should -Contain 'Get-GauntletBatchJob'
        Get-Command Get-TeXdigBatchJob -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        foreach ($oldPath in @(
                (Join-Path $script:AdaptersModuleRoot ('private/texdig-' + 'address.ps1'))
                (Join-Path $script:AdaptersModuleRoot ('private/texdig-' + 'discovery.ps1'))
                (Join-Path $script:AdaptersModuleRoot ('private/texdig-' + 'dependency.ps1'))
                (Join-Path $script:AdaptersModuleRoot ('public/Get-' + 'TeXdigBatchJob.ps1'))
            )) {
            Test-Path -LiteralPath $oldPath | Should -BeFalse
        }
        foreach ($helper in @(
                'Resolve-GauntletBatchJobAddress'
                'Find-GauntletBatchArticle'
                'Get-GauntletBatchManifestRecord'
                'Resolve-GauntletBatchEngineRoot'
                'Resolve-GauntletBatchWorker'
                'Resolve-GauntletBatchWorkerParameter'
                'Get-GauntletBatchStableHash'
            )) {
            Get-Command $helper -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }

    It 'keeps all run-relative path composition in one pure private resolver and knows no engine' {
        $sourceFiles = @(
            Get-ChildItem -LiteralPath $script:AdaptersModuleRoot -Recurse -File |
                Where-Object {
                    $_.Extension -in @('.ps1', '.psm1') -and $_.Name -match '(?i)gauntlet'
                }
        )
        $sourceFiles.Count | Should -Be 4
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
                                $node.Value -in @('gauntlet-jobs', 'gauntlet-temp', 'json-scratch')
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
                                $node.GetCommandName() -eq 'Resolve-GauntletBatchJobAddress'
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
            'Resolve-GauntletBatchJobAddress'
            'Resolve-GauntletBatchJobAddress'
            'Resolve-GauntletBatchJobAddress'
        )
        @($resolverCalls) | Should -Be @('Get-GauntletBatchJob')
        $sourceText.ToString() | Should -Not -Match '\bNew-Item\b|CreateDirectory\s*\('
        # The adapter freezes EngineRoot and Worker; it never resolves an engine runtime or
        # store layout, and carries nothing of the evicted in-repository census.
        $sourceText.ToString() | Should -Not -Match `
            'Get-TeXdigBatchJob|texdig-jobs|run-census|unified-latex|packages[\\/]node|Get-Command node|summary\.json'
    }
}

Describe 'Get-GauntletBatchJob planning' {
    It 'plans one stable isolated process job per deposited article without creating run artifacts' {
        $fixture = New-GauntletBatchFixture -Root (Join-Path $TestDrive 'planning')
        $invoke = @{
            Path = @($fixture.Collection, $fixture.Small)
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            Engine = 'stub'
            EngineRoot = $fixture.EngineRoot
            Worker = $fixture.Worker
            WorkerParameter = @{ Marker = 'frozen' }
        }
        $jobs = @(Get-GauntletBatchJob @invoke)
        $again = @(Get-GauntletBatchJob @invoke)

        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -Force).Count | Should -Be 0
        $jobs.Count | Should -Be 2
        @($jobs.Id) | Should -Be @($again.Id)
        @($jobs.Metadata.Slug) | Should -Be @('a-small', 'b-large')
        @($jobs.Metadata.ArticleDirectory) | Should -Be @($fixture.Small, $fixture.Large)
        foreach ($job in $jobs) {
            $job.Kind | Should -Be 'PowerShellProcess'
            $job.EntryPoint | Should -Be $fixture.Worker
            $job.WorkingDirectory | Should -Be $fixture.EngineRoot
            $job.ProcessSpec.WorkingDirectory | Should -Be $fixture.EngineRoot
            $job.RuntimeProfile | Should -Be 'gauntlet-process'
            $job.Id | Should -Match '^gauntlet:stub:supellex/gauntlet/alpha/[ab]-[a-z]+#[0-9a-f]{12}$'
            $job.Writes | Should -Be @($job.Metadata.JobDirectory, $job.Metadata.TempRoot)
            $job.Parameters.Article | Should -Be $job.Metadata.ArticleDirectory
            $job.Parameters.OutDirectory | Should -Be $job.Metadata.JobDirectory
            $job.Parameters.EngineRoot | Should -Be $fixture.EngineRoot
            $job.Parameters.Marker | Should -Be 'frozen'
            $environment = $job.ProcessSpec.Environment
            $environment.CDXSCI_JSON_SCRATCH_ROOT | Should -Be $job.Metadata.JsonScratchRoot
            $environment.CDXSCI_TEMP | Should -Be $job.Metadata.TempRoot
            @($environment.TEMP, $environment.TMP, $environment.TMPDIR) |
                Should -Be @($job.Metadata.TempRoot, $job.Metadata.TempRoot, $job.Metadata.TempRoot)
            foreach ($write in $job.Writes) {
                $relativeWrite = [System.IO.Path]::GetRelativePath($fixture.RunDirectory, $write)
                $relativeWrite | Should -Not -Be '..'
                $relativeWrite | Should -Not -Match '^\.\.[\\/]'
            }
            $job.Metadata.Domain | Should -Be 'gauntlet'
            $job.Metadata.Adapter | Should -Be 'gauntlet-batch'
            $job.Metadata.Engine | Should -Be 'stub'
            $job.Metadata.EngineRoot | Should -Be $fixture.EngineRoot
            $job.Metadata.Worker | Should -Be $fixture.Worker
            $job.Metadata.AddressingContract | Should -Be 'RunDirectory/gauntlet-jobs'
            $job.Metadata.ContainerContract | Should -Be 'JobContainerIsDocumentContainer'
            $job.Metadata.ReceiptContract | Should -Be 'codex-scientiae/gauntlet-receipt/0.1'
            $job.Metadata.ReceiptPath | Should -Be (Join-Path $job.Metadata.JobDirectory 'receipt.json')
            $job.Metadata.TempEnvironment | Should -Be 'CDXSCI_TEMP'
            $job.Metadata.ScratchEnvironment | Should -Be 'CDXSCI_JSON_SCRATCH_ROOT'
            $job.Metadata.TreeDirectory | Should -Be (Join-Path $job.Metadata.ArticleDirectory "$($job.Metadata.Slug)-tex")
            Test-Path -LiteralPath $job.Metadata.JobDirectory | Should -BeFalse
            Test-Path -LiteralPath $job.Metadata.TempRoot | Should -BeFalse
        }
        $jobs[0].Metadata.TreeSha256 | Should -Be ('a' * 64)
        $jobs[1].EstimatedCost | Should -BeGreaterThan $jobs[0].EstimatedCost

        $compiled = New-BatchPlan -Job $jobs -BasePath $fixture.EngineRoot
        $compiled.Errors.Count | Should -Be 0
        $compiled.Plan.Jobs.Count | Should -Be 2
        $compiled.Plan.DispatchJobs[0].Id | Should -Be $jobs[1].Id
    }

    It 'mints distinct identities per engine and per deposited tree' {
        $fixture = New-GauntletBatchFixture -Root (Join-Path $TestDrive 'identity')
        $base = @{
            Path = $fixture.Small
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            EngineRoot = $fixture.EngineRoot
            Worker = $fixture.Worker
        }
        $stub = @(Get-GauntletBatchJob @base -Engine 'stub')[0]
        $other = @(Get-GauntletBatchJob @base -Engine 'other-engine')[0]
        $stub.Id | Should -Not -Be $other.Id
        $stub.Metadata.JobDirectory | Should -Not -Be $other.Metadata.JobDirectory
        $other.Id | Should -Match '^gauntlet:other-engine:'

        # A re-deposit (new tree fingerprint) changes the id; the address stays under the run.
        $redeposited = Write-GauntletDeposit -Collection $fixture.Collection -Slug 'a-small' `
            -TreeBytes 64 -TreeSha256 ('c' * 64)
        $after = @(Get-GauntletBatchJob @base -Engine 'stub')[0]
        $after.Id | Should -Not -Be $stub.Id
        $after.Metadata.ArticleDirectory | Should -Be $redeposited
    }

    It 'rejects run, engine, worker, and selection inputs that break containment' {
        $fixture = New-GauntletBatchFixture -Root (Join-Path $TestDrive 'invalid')
        $valid = @{
            Path = $fixture.Small
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            Engine = 'stub'
            EngineRoot = $fixture.EngineRoot
            Worker = $fixture.Worker
        }
        function Invoke-With([hashtable] $Override) {
            $arguments = $valid.Clone()
            foreach ($key in $Override.Keys) { $arguments[$key] = $Override[$key] }
            return @(Get-GauntletBatchJob @arguments)
        }

        $missingRun = Join-Path $fixture.Root 'artifacts/missing-run'
        $outsideRun = Join-Path (Split-Path -Parent $fixture.Root) 'outside-run'
        [void][System.IO.Directory]::CreateDirectory($outsideRun)
        { Invoke-With @{ RunDirectory = 'relative-run' } } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        { Invoke-With @{ RunDirectory = $missingRun } } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        { Invoke-With @{ RunDirectory = $outsideRun } } |
            Should -Throw '*RunDirectory must be a descendant of RepositoryRoot/artifacts*'
        Test-Path -LiteralPath $missingRun | Should -BeFalse

        $insideEngine = Join-Path $fixture.Root 'engine-inside'
        [void][System.IO.Directory]::CreateDirectory($insideEngine)
        { Invoke-With @{ EngineRoot = 'relative-engine' } } |
            Should -Throw '*EngineRoot must be an existing absolute directory*'
        { Invoke-With @{ EngineRoot = (Join-Path $TestDrive 'no-such-engine') } } |
            Should -Throw '*EngineRoot must be an existing absolute directory*'
        { Invoke-With @{ EngineRoot = $insideEngine } } |
            Should -Throw '*EngineRoot must lie outside RepositoryRoot*'
        { Invoke-With @{ EngineRoot = (Split-Path -Parent $fixture.Root) } } |
            Should -Throw '*EngineRoot must lie outside RepositoryRoot*'

        $strayWorker = Write-GauntletStubWorker -Path (Join-Path $TestDrive 'stray/worker.ps1')
        $notScript = Join-Path $fixture.EngineRoot 'private/gauntlet/worker.txt'
        Set-Content -LiteralPath $notScript -Encoding utf8 -Value 'not a script'
        { Invoke-With @{ Worker = 'private/gauntlet/worker.ps1' } } |
            Should -Throw '*Worker must be an existing absolute .ps1 file below EngineRoot*'
        { Invoke-With @{ Worker = (Join-Path $fixture.EngineRoot 'missing.ps1') } } |
            Should -Throw '*Worker must be an existing absolute .ps1 file below EngineRoot*'
        { Invoke-With @{ Worker = $strayWorker } } |
            Should -Throw '*Worker must be an existing absolute .ps1 file below EngineRoot*'
        { Invoke-With @{ Worker = $notScript } } |
            Should -Throw '*Worker must be an existing absolute .ps1 file below EngineRoot*'

        { Invoke-With @{ Engine = 'Not Valid' } } | Should -Throw '*Engine*'
        { Invoke-With @{ WorkerParameter = @{ OutDirectory = 'x' } } } |
            Should -Throw '*may not shadow the adapter-owned parameter*'
        { Invoke-With @{ WorkerParameter = @{ 'bad key' = 'x' } } } |
            Should -Throw '*is not a parameter name*'

        $outsideCollection = Join-Path (Split-Path -Parent $fixture.Root) 'outside-gauntlet'
        $outsideArticle = Write-GauntletDeposit -Collection $outsideCollection -Slug 'escapee'
        $emptyCollection = Join-Path $fixture.Root 'supellex/gauntlet/empty'
        [void][System.IO.Directory]::CreateDirectory($emptyCollection)
        $broken = Write-GauntletDeposit -Collection $fixture.Collection -Slug 'broken'
        Set-Content -LiteralPath (Join-Path $broken 'article.json') -Encoding utf8 -Value '{ not json'
        { Invoke-With @{ Path = $outsideArticle } } |
            Should -Throw '*article selection escapes RepositoryRoot*'
        { Invoke-With @{ Path = (Join-Path $fixture.Small 'a-small-tex/main.tex') } } |
            Should -Throw '*input file is not article.json*'
        { Invoke-With @{ Path = (Join-Path $fixture.Root 'supellex/gauntlet/nowhere') } } |
            Should -Throw '*input path not found*'
        { Invoke-With @{ Path = $emptyCollection } } |
            Should -Throw '*found no deposited articles under*'
        { Invoke-With @{ Path = $broken } } |
            Should -Throw '*could not read article.json*'
        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -Force).Count | Should -Be 0
    }
}

Describe 'gauntlet worker hop' {
    It 'runs the frozen engine worker in an isolated child that sees only the planned addresses' {
        $fixture = New-GauntletBatchFixture -Root (Join-Path $TestDrive 'hop')
        $jobs = @(Get-GauntletBatchJob -Path $fixture.Collection -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -Engine 'stub' -EngineRoot $fixture.EngineRoot `
                -Worker $fixture.Worker -WorkerParameter @{ Marker = 'hop' })
        $compiled = New-BatchPlan -Job $jobs -BasePath $fixture.EngineRoot
        $compiled.Errors.Count | Should -Be 0

        $execution = Invoke-BatchPlan -Plan $compiled -MaxWorkers 2

        @($execution.Errors).Count | Should -Be 0
        $execution.Summary.Succeeded | Should -Be $jobs.Count
        foreach ($job in $jobs) {
            $result = @($execution.Results | Where-Object Id -EQ $job.Id)[0]
            $result.State | Should -Be 'Succeeded'
            Test-Path -LiteralPath $job.Metadata.ReceiptPath -PathType Leaf | Should -BeTrue
            $receipt = Get-Content -LiteralPath $job.Metadata.ReceiptPath -Raw | ConvertFrom-Json
            $receipt.schema | Should -Be 'codex-scientiae/gauntlet-receipt/0.1'
            $receipt.article | Should -Be $job.Metadata.ArticleDirectory
            $receipt.outDirectory | Should -Be $job.Metadata.JobDirectory
            $receipt.engineRoot | Should -Be $fixture.EngineRoot
            $receipt.marker | Should -Be 'hop'
            $receipt.temp | Should -Be $job.Metadata.TempRoot
            $receipt.osTemp | Should -Be $job.Metadata.TempRoot
            $receipt.jobId | Should -Be $job.Id
            $receipt.location | Should -Be $fixture.EngineRoot
        }
        # Nothing landed outside the two declared write roots.
        $landed = @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Directory | ForEach-Object Name | Sort-Object)
        $landed | Should -Be @('gauntlet-jobs', 'gauntlet-temp')
    }
}
