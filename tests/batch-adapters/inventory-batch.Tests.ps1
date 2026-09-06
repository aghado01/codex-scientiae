#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:AdaptersModuleRoot = Join-Path $script:RepositoryRoot 'src/batch-adapters'
    $script:AdaptersManifest = Join-Path $script:AdaptersModuleRoot 'adapters.psd1'
    $script:BatchExecutorManifest = Join-Path $script:RepositoryRoot `
        'src/batch-executor/batch-executor.psd1'
    $script:BatchRunner = Join-Path $script:RepositoryRoot 'src/batch-runner.ps1'
    $script:Utf8 = [System.Text.UTF8Encoding]::new($false)

    function Write-InventoryDeposit {
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
        $json = ($manifest | ConvertTo-Json -Depth 6 -Compress) + "`n"
        [System.IO.File]::WriteAllText((Join-Path $article 'article.json'), $json, $script:Utf8)
        return (Resolve-Path -LiteralPath $article).Path
    }

    function Write-FirstOrderInventory {
        param([Parameter(Mandatory)] [string] $CatalogDir)
        $rows = [System.Collections.Generic.List[string]]::new()
        $children = @(Get-ChildItem -LiteralPath $CatalogDir -Directory |
                Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'article.json') -PathType Leaf } |
                Sort-Object Name)
        $rows.Add(('{{"__type__":"header","kind":"inventory","version":"0.1","identity":["/slug"],"count":{0},"key_comparison":"ordinal-ignore-case"}}' -f $children.Count))
        foreach ($child in $children) {
            $rows.Add((Get-Content -LiteralPath (Join-Path $child.FullName 'article.json') -Raw).Trim())
        }
        $text = ($rows.ToArray() -join "`n") + "`n"
        [System.IO.File]::WriteAllText((Join-Path $CatalogDir 'inventory.jsonl'), $text, $script:Utf8)
    }

    function Write-FoldedInventory {
        param(
            [Parameter(Mandatory)] [string] $CatalogDir,
            [Parameter(Mandatory)] [string[]] $ChildName
        )
        $rows = [System.Collections.Generic.List[string]]::new()
        $articles = [System.Collections.Generic.List[object]]::new()
        foreach ($name in $ChildName) {
            $child = Join-Path $CatalogDir $name
            foreach ($articleDir in @(Get-ChildItem -LiteralPath $child -Directory |
                    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'article.json') })) {
                $record = Get-Content -LiteralPath (Join-Path $articleDir.FullName 'article.json') -Raw |
                    ConvertFrom-Json
                foreach ($form in @($record.source_forms)) {
                    if ($form.PSObject.Properties['path'] -and $form.path) {
                        $relative = ([string]$form.path) -replace '\\', '/'
                        $form.path = if ($relative.Contains('/')) {
                            "$name/$relative"
                        }
                        else { "$name/$($record.slug)/$relative" }
                    }
                }
                $articles.Add($record)
            }
        }
        $rows.Add(('{{"__type__":"header","kind":"inventory","version":"0.1","identity":["/slug"],"count":{0},"key_comparison":"ordinal-ignore-case"}}' -f $articles.Count))
        foreach ($record in $articles) {
            $rows.Add(($record | ConvertTo-Json -Depth 8 -Compress))
        }
        $text = ($rows.ToArray() -join "`n") + "`n"
        [System.IO.File]::WriteAllText((Join-Path $CatalogDir 'inventory.jsonl'), $text, $script:Utf8)
    }

    function Write-InventoryStubWorker {
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
    schema = 'codex-scientiae/inventory-receipt/0.1'
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

    function New-InventoryBatchFixture {
        param([Parameter(Mandatory)] [string] $Root)

        $repository = Join-Path $Root 'repository'
        $run = Join-Path $repository 'artifacts/20261208_000000'
        $alpha = Join-Path $repository 'catalog/alpha'
        $beta = Join-Path $repository 'catalog/beta'
        $gauntlet = Join-Path $repository 'supellex/gauntlet/topic'
        $engine = Join-Path $Root 'engine'
        foreach ($directory in @($repository, $run, $alpha, $beta, $gauntlet, $engine)) {
            [void][System.IO.Directory]::CreateDirectory($directory)
        }
        $small = Write-InventoryDeposit -Collection $alpha -Slug 'a-small' -TreeBytes 64 `
            -TreeSha256 ('a' * 64)
        $large = Write-InventoryDeposit -Collection $alpha -Slug 'b-large' -TreeBytes 4096 `
            -TreeSha256 ('b' * 64)
        $other = Write-InventoryDeposit -Collection $beta -Slug 'c-other' -TreeBytes 128 `
            -TreeSha256 ('c' * 64)
        $topic = Write-InventoryDeposit -Collection $gauntlet -Slug 'd-topic' -TreeBytes 32 `
            -TreeSha256 ('d' * 64)
        [void][System.IO.Directory]::CreateDirectory((Join-Path $alpha 'not-a-deposit'))
        Write-FirstOrderInventory -CatalogDir $alpha
        Write-FirstOrderInventory -CatalogDir $beta
        Write-FirstOrderInventory -CatalogDir $gauntlet
        Write-FoldedInventory -CatalogDir (Join-Path $repository 'catalog') -ChildName @('alpha', 'beta')
        Write-FoldedInventory -CatalogDir (Join-Path $repository 'supellex/gauntlet') -ChildName @('topic')
        $worker = Write-InventoryStubWorker -Path (Join-Path $engine 'private/inventory/worker.ps1')

        return [pscustomobject]@{
            Root = (Resolve-Path -LiteralPath $repository).Path
            RunDirectory = (Resolve-Path -LiteralPath $run).Path
            Catalog = (Resolve-Path -LiteralPath (Join-Path $repository 'catalog')).Path
            Alpha = (Resolve-Path -LiteralPath $alpha).Path
            Beta = (Resolve-Path -LiteralPath $beta).Path
            Gauntlet = (Resolve-Path -LiteralPath (Join-Path $repository 'supellex/gauntlet')).Path
            Small = $small
            Large = $large
            Other = $other
            Topic = $topic
            EngineRoot = (Resolve-Path -LiteralPath $engine).Path
            Worker = $worker
        }
    }

    . (Join-Path $script:RepositoryRoot 'src/infrastructure/containment.ps1')
    $pythonCandidate = Join-Path $script:RepositoryRoot '.venv/Scripts/python.exe'
    if (-not (Test-Path -LiteralPath $pythonCandidate -PathType Leaf)) {
        throw "inventory-batch tests require the repository .venv Python at '$pythonCandidate'"
    }

    Import-Module $script:BatchExecutorManifest -Force
    Import-Module $script:AdaptersManifest -Force
}

AfterAll {
    Remove-Module adapters -Force -ErrorAction SilentlyContinue
    Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
}

Describe 'adapters module surface for inventory-batch' {
    It 'exports Get-InventoryBatchJob and keeps its helpers private' {
        (Get-Module adapters).ExportedFunctions.Keys | Should -Contain 'Get-InventoryBatchJob'
        Get-Command Get-GauntletBatchJob -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        Get-Command Get-TeXdigBatchJob -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        foreach ($oldPath in @(
                (Join-Path $script:AdaptersModuleRoot 'private/gauntlet-address.ps1')
                (Join-Path $script:AdaptersModuleRoot 'private/gauntlet-discovery.ps1')
                (Join-Path $script:AdaptersModuleRoot 'private/gauntlet-dependency.ps1')
                (Join-Path $script:AdaptersModuleRoot 'public/Get-GauntletBatchJob.ps1')
                (Join-Path $script:AdaptersModuleRoot ('private/texdig-' + 'address.ps1'))
                (Join-Path $script:AdaptersModuleRoot ('public/Get-' + 'TeXdigBatchJob.ps1'))
            )) {
            Test-Path -LiteralPath $oldPath | Should -BeFalse
        }
        foreach ($helper in @(
                'Resolve-InventoryBatchJobAddress'
                'Find-InventoryBatchArticle'
                'Get-InventoryBatchManifestRecord'
                'Resolve-InventoryBatchEngineRoot'
                'Resolve-InventoryBatchWorker'
                'Resolve-InventoryBatchWorkerParameter'
                'Get-InventoryBatchStableHash'
            )) {
            Get-Command $helper -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }

    It 'keeps all run-relative path composition in one pure private resolver and knows no engine' {
        $sourceFiles = @(
            Get-ChildItem -LiteralPath $script:AdaptersModuleRoot -Recurse -File |
                Where-Object {
                    $_.Extension -in @('.ps1', '.psm1') -and $_.Name -match '(?i)inventory'
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
                                $node.Value -in @('jobs', 'job-temp', 'json-scratch')
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
                                $node.GetCommandName() -eq 'Resolve-InventoryBatchJobAddress'
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
            'Resolve-InventoryBatchJobAddress'
            'Resolve-InventoryBatchJobAddress'
            'Resolve-InventoryBatchJobAddress'
        )
        @($resolverCalls) | Should -Be @('Get-InventoryBatchJob')
        $sourceText.ToString() | Should -Not -Match '\bNew-Item\b|CreateDirectory\s*\('
        $sourceText.ToString() | Should -Not -Match `
            'Get-GauntletBatchJob|gauntlet-jobs|Get-TeXdigBatchJob|texdig-jobs|run-census|Get-Command node'
    }
}

Describe 'Get-InventoryBatchJob planning' {
    It 'plans one stable isolated process job per first-order inventory row without creating run artifacts' {
        $fixture = New-InventoryBatchFixture -Root (Join-Path $TestDrive 'planning')
        $invoke = @{
            Path = @($fixture.Alpha, $fixture.Small)
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            Engine = 'stub'
            EngineRoot = $fixture.EngineRoot
            Worker = $fixture.Worker
            WorkerParameter = @{ Marker = 'frozen' }
        }
        $jobs = @(Get-InventoryBatchJob @invoke)
        $again = @(Get-InventoryBatchJob @invoke)

        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -Force).Count | Should -Be 0
        $jobs.Count | Should -Be 2
        @($jobs.Id) | Should -Be @($again.Id)
        @($jobs.Metadata.Slug) | Should -Be @('a-small', 'b-large')
        @($jobs.Metadata.ArticleDirectory) | Should -Be @($fixture.Small, $fixture.Large)
        foreach ($job in $jobs) {
            $job.Kind | Should -Be 'PowerShellProcess'
            $job.EntryPoint | Should -Be $fixture.Worker
            $job.WorkingDirectory | Should -Be $fixture.EngineRoot
            $job.RuntimeProfile | Should -Be 'inventory-process'
            $job.Id | Should -Match '^inventory:stub:catalog/alpha/[ab]-[a-z]+#[0-9a-f]{12}$'
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
            $job.Metadata.Domain | Should -Be 'inventory'
            $job.Metadata.Adapter | Should -Be 'inventory-batch'
            $job.Metadata.Engine | Should -Be 'stub'
            $job.Metadata.AddressingContract | Should -Be 'RunDirectory/jobs'
            $job.Metadata.ReceiptContract | Should -Be 'codex-scientiae/inventory-receipt/0.1'
            $job.Metadata.ReceiptPath | Should -Be (Join-Path $job.Metadata.JobDirectory 'receipt.json')
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

    It 'expands a folded parent inventory.jsonl to every nested article' {
        $fixture = New-InventoryBatchFixture -Root (Join-Path $TestDrive 'folded')
        $jobs = @(Get-InventoryBatchJob -Path $fixture.Catalog -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -Engine 'stub' -EngineRoot $fixture.EngineRoot `
                -Worker $fixture.Worker)
        $jobs.Count | Should -Be 3
        @($jobs.Metadata.Slug | Sort-Object) | Should -Be @('a-small', 'b-large', 'c-other')
        @($jobs.Metadata.RepositoryRelativePath | Sort-Object) | Should -Be @(
            'catalog/alpha/a-small'
            'catalog/alpha/b-large'
            'catalog/beta/c-other'
        )
    }

    It 'expands an inventory.jsonl file path the same way as its catalog directory' {
        $fixture = New-InventoryBatchFixture -Root (Join-Path $TestDrive 'file-path')
        $fromDir = @(Get-InventoryBatchJob -Path $fixture.Alpha -RunDirectory $fixture.RunDirectory `
                -RepositoryRoot $fixture.Root -Engine 'stub' -EngineRoot $fixture.EngineRoot `
                -Worker $fixture.Worker)
        $fromFile = @(Get-InventoryBatchJob -Path (Join-Path $fixture.Alpha 'inventory.jsonl') `
                -RunDirectory $fixture.RunDirectory -RepositoryRoot $fixture.Root `
                -Engine 'stub' -EngineRoot $fixture.EngineRoot -Worker $fixture.Worker)
        @($fromFile.Id) | Should -Be @($fromDir.Id)
    }

    It 'mints distinct identities per engine and per deposited tree' {
        $fixture = New-InventoryBatchFixture -Root (Join-Path $TestDrive 'identity')
        $base = @{
            Path = $fixture.Small
            RunDirectory = $fixture.RunDirectory
            RepositoryRoot = $fixture.Root
            EngineRoot = $fixture.EngineRoot
            Worker = $fixture.Worker
        }
        $stub = @(Get-InventoryBatchJob @base -Engine 'stub')[0]
        $other = @(Get-InventoryBatchJob @base -Engine 'other-engine')[0]
        $stub.Id | Should -Not -Be $other.Id
        $stub.Metadata.JobDirectory | Should -Not -Be $other.Metadata.JobDirectory
        $other.Id | Should -Match '^inventory:other-engine:'

        $redeposited = Write-InventoryDeposit -Collection $fixture.Alpha -Slug 'a-small' `
            -TreeBytes 64 -TreeSha256 ('e' * 64)
        Write-FirstOrderInventory -CatalogDir $fixture.Alpha
        $after = @(Get-InventoryBatchJob @base -Engine 'stub')[0]
        $after.Id | Should -Not -Be $stub.Id
        $after.Metadata.ArticleDirectory | Should -Be $redeposited
    }

    It 'rejects run, engine, worker, catalog, and selection inputs that break containment' {
        $fixture = New-InventoryBatchFixture -Root (Join-Path $TestDrive 'invalid')
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
            return @(Get-InventoryBatchJob @arguments)
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

        $insideEngine = Join-Path $fixture.Root 'engine-inside'
        [void][System.IO.Directory]::CreateDirectory($insideEngine)
        { Invoke-With @{ EngineRoot = 'relative-engine' } } |
            Should -Throw '*EngineRoot must be an existing absolute directory*'
        { Invoke-With @{ EngineRoot = $insideEngine } } |
            Should -Throw '*EngineRoot must lie outside RepositoryRoot*'

        $strayWorker = Write-InventoryStubWorker -Path (Join-Path $TestDrive 'stray/worker.ps1')
        { Invoke-With @{ Worker = 'private/inventory/worker.ps1' } } |
            Should -Throw '*Worker must be an existing absolute .ps1 file below EngineRoot*'
        { Invoke-With @{ Worker = $strayWorker } } |
            Should -Throw '*Worker must be an existing absolute .ps1 file below EngineRoot*'

        { Invoke-With @{ Engine = 'Not Valid' } } | Should -Throw '*Engine*'
        { Invoke-With @{ WorkerParameter = @{ OutDirectory = 'x' } } } |
            Should -Throw '*may not shadow the adapter-owned parameter*'

        $outsideCollection = Join-Path (Split-Path -Parent $fixture.Root) 'outside-catalog'
        $outsideArticle = Write-InventoryDeposit -Collection $outsideCollection -Slug 'escapee'
        $emptyCatalog = Join-Path $fixture.Root 'catalog/empty'
        [void][System.IO.Directory]::CreateDirectory($emptyCatalog)
        $broken = Write-InventoryDeposit -Collection $fixture.Alpha -Slug 'broken'
        Set-Content -LiteralPath (Join-Path $broken 'article.json') -Encoding utf8 -Value '{ not json'
        { Invoke-With @{ Path = $outsideArticle } } |
            Should -Throw '*article selection escapes RepositoryRoot*'
        { Invoke-With @{ Path = (Join-Path $fixture.Small 'a-small-tex/main.tex') } } |
            Should -Throw '*input file is not article.json or inventory.jsonl*'
        { Invoke-With @{ Path = (Join-Path $fixture.Root 'catalog/nowhere') } } |
            Should -Throw '*input path not found*'
        { Invoke-With @{ Path = $emptyCatalog } } |
            Should -Throw '*catalog has no inventory.jsonl*'
        { Invoke-With @{ Path = $broken } } |
            Should -Throw '*could not read article.json*'

        $noTree = Write-InventoryDeposit -Collection $fixture.Alpha -Slug 'no-tree'
        $noTreeJson = Get-Content -LiteralPath (Join-Path $noTree 'article.json') -Raw | ConvertFrom-Json
        $noTreeJson.source_forms = @()
        [System.IO.File]::WriteAllText(
            (Join-Path $noTree 'article.json'),
            (($noTreeJson | ConvertTo-Json -Depth 6 -Compress) + "`n"),
            $script:Utf8)
        { Invoke-With @{ Path = $noTree } } |
            Should -Throw '*has no latex-source-tree sha256*'
        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -Force).Count | Should -Be 0
    }
}

Describe 'inventory worker hop' {
    It 'runs the frozen engine worker in an isolated child that sees only the planned addresses' {
        $fixture = New-InventoryBatchFixture -Root (Join-Path $TestDrive 'hop')
        $jobs = @(Get-InventoryBatchJob -Path $fixture.Alpha -RunDirectory $fixture.RunDirectory `
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
            $receipt.schema | Should -Be 'codex-scientiae/inventory-receipt/0.1'
            $receipt.article | Should -Be $job.Metadata.ArticleDirectory
            $receipt.outDirectory | Should -Be $job.Metadata.JobDirectory
            $receipt.engineRoot | Should -Be $fixture.EngineRoot
            $receipt.marker | Should -Be 'hop'
            $receipt.temp | Should -Be $job.Metadata.TempRoot
            $receipt.osTemp | Should -Be $job.Metadata.TempRoot
            $receipt.jobId | Should -Be $job.Id
            $receipt.location | Should -Be $fixture.EngineRoot
        }
        $landed = @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Directory | ForEach-Object Name | Sort-Object)
        $landed | Should -Be @('job-temp', 'jobs')
    }
}

Describe 'batch-runner house caller' {
    It 'refuses to resolve a Codex root from a hardcoded or missing path' {
        $fixture = New-InventoryBatchFixture -Root (Join-Path $TestDrive 'no-root')
        $previous = [System.Environment]::GetEnvironmentVariable('CDXSCI_ROOT', 'Process')
        try {
            [System.Environment]::SetEnvironmentVariable('CDXSCI_ROOT', $null, 'Process')
            { & $script:BatchRunner -Engine 'stub' -EngineRoot $fixture.EngineRoot `
                    -Worker $fixture.Worker } |
                Should -Throw '*CDXSCI_ROOT must name an existing absolute directory*'
        }
        finally {
            [System.Environment]::SetEnvironmentVariable('CDXSCI_ROOT', $previous, 'Process')
        }
    }

    It 'mints artifacts/{engine}/{stamp} and folds receipts from CDXSCI_ROOT' {
        $fixture = New-InventoryBatchFixture -Root (Join-Path $TestDrive 'runner')
        $previous = [System.Environment]::GetEnvironmentVariable('CDXSCI_ROOT', 'Process')
        try {
            [System.Environment]::SetEnvironmentVariable('CDXSCI_ROOT', $fixture.Root, 'Process')
            $output = & $script:BatchRunner -Engine 'stub' -EngineRoot $fixture.EngineRoot `
                -Worker $fixture.Worker -Path $fixture.Alpha `
                -WorkerParameter @{ Marker = 'runner' }
        }
        finally {
            [System.Environment]::SetEnvironmentVariable('CDXSCI_ROOT', $previous, 'Process')
        }

        $runs = @(Get-ModuleRunDirs -Module 'stub' -RepositoryRoot $fixture.Root)
        $runs.Count | Should -Be 1
        $run = $runs[0]
        $output | Should -Match 'Inventory batch: engine=stub; articles=2; ok=2'
        $output | Should -Match ([regex]::Escape($run))
        Test-Path -LiteralPath (Join-Path $run 'run.json') -PathType Leaf | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $run 'inventory-summary.jsonl') -PathType Leaf | Should -BeTrue
        $record = Get-Content -LiteralPath (Join-Path $run 'run.json') -Raw | ConvertFrom-Json
        $record.schema | Should -Be 'codex-scientiae/inventory-run/0.1'
        $record.engine | Should -Be 'stub'
        $record.jobs | Should -Be 2
        $record.receipts.ok | Should -Be 2
        $record.selectedPaths | Should -Be @($fixture.Alpha)
        (Split-Path $run -Parent) | Should -Be (Join-Path $fixture.Root 'artifacts/stub')
        (Split-Path $run -Leaf) | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
    }

    It 'defaults Path to supellex/gauntlet under the resolved Codex root' {
        $fixture = New-InventoryBatchFixture -Root (Join-Path $TestDrive 'default-path')
        $output = & $script:BatchRunner -RepositoryRoot $fixture.Root -Engine 'stub' `
            -EngineRoot $fixture.EngineRoot -Worker $fixture.Worker
        $runs = @(Get-ModuleRunDirs -Module 'stub' -RepositoryRoot $fixture.Root)
        $runs.Count | Should -Be 1
        $output | Should -Match 'articles=1; ok=1'
        $record = Get-Content -LiteralPath (Join-Path $runs[0] 'run.json') -Raw | ConvertFrom-Json
        $record.selectedPaths | Should -Be @($fixture.Gauntlet)
        (Split-Path $runs[0] -Leaf) | Should -Match '^\d{8}_\d{6}(_\d{2})?$'
    }
}
