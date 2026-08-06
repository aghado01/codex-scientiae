#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:IngestBatchModuleRoot = Join-Path $script:RepositoryRoot 'src/ingest-batch'
    $script:IngestBatchManifest = Join-Path $script:IngestBatchModuleRoot 'ingest-batch.psd1'
    $script:LiveLatexIngest = Join-Path $script:RepositoryRoot 'src/latex-ingest/latex-ingest.ps1'

    function New-IngestBatchFixture {
        param([Parameter(Mandatory)] [string] $Root)

        $inventory = Join-Path $Root 'inventory'
        $run = Join-Path $Root 'caller-run'
        foreach ($directory in @($inventory, $run)) {
            [void][System.IO.Directory]::CreateDirectory($directory)
        }
        return [pscustomobject]@{
            Root = $Root
            InventoryRoot = $inventory
            RunDirectory = $run
        }
    }

    function Write-IngestBatchManifest {
        param(
            [Parameter(Mandatory)] [string] $InventoryRoot,
            [Parameter(Mandatory)] [string] $Slug,
            [string] $DirectoryName = $Slug,
            [string] $State = 'source-ready',
            [string] $TreeHash = ('a' * 64),
            [string] $ArchiveHash = ('b' * 64),
            [long] $ArchiveBytes = 100,
            [switch] $OmitTree
        )

        $documentDirectory = Join-Path $InventoryRoot $DirectoryName
        [void][System.IO.Directory]::CreateDirectory($documentDirectory)
        $forms = [System.Collections.Generic.List[object]]::new()
        $forms.Add([ordered]@{
                role = 'latex-source-archive'
                path = "$DirectoryName.tar.gz"
                format = 'application/gzip'
                bytes = $ArchiveBytes
                sha256 = $ArchiveHash
            })
        if (-not $OmitTree) {
            $forms.Add([ordered]@{
                    role = 'latex-source-tree'
                    path = "$DirectoryName-tex"
                    format = 'application/x-latex-source-tree'
                    entrypoint = 'main.tex'
                    files = 2
                    tex_files = 1
                    sha256 = $TreeHash
                })
        }
        $manifest = [ordered]@{
            schema = 'codex-scientiae/document-metadata/0.1'
            state = $State
            slug = $Slug
            source_forms = $forms.ToArray()
        }
        $path = Join-Path $documentDirectory 'metadata.json'
        Set-Content -LiteralPath $path -Encoding utf8 `
            -Value ($manifest | ConvertTo-Json -Depth 8)
        return $path
    }

    function Write-IngestBatchFixtureDependency {
        param([Parameter(Mandatory)] [string] $Path)

        Set-Content -LiteralPath $Path -Encoding utf8 -Value @'
function Invoke-ArxivLatexToMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $MetadataPath,
        [Parameter(Mandatory)] [string] $OutDir,
        [string] $DeliverableDir,
        [Parameter(Mandatory)] [string] $RunDir,
        [switch] $EnableEmbeddedToc,
        [switch] $DisableTreeToc,
        [switch] $DisableJsonlToc,
        [switch] $FaithfulNumbering
    )

    $manifest = Get-Content -LiteralPath $MetadataPath -Raw | ConvertFrom-Json
    $slug = [string]$manifest.slug
    if ($slug -eq 'broken') { throw 'fixture document failure' }
    [void][System.IO.Directory]::CreateDirectory($RunDir)
    [void][System.IO.Directory]::CreateDirectory($OutDir)
    [void][System.IO.Directory]::CreateDirectory((Join-Path $OutDir $slug))
    Set-Content -LiteralPath (Join-Path $RunDir "$slug.evidence.json") -Encoding utf8 -Value '{}'
    Set-Content -LiteralPath (Join-Path $OutDir "$slug-latex.md") -Encoding utf8 -Value "# $slug"
    Set-Content -LiteralPath (Join-Path $OutDir "$slug/asset.txt") -Encoding utf8 -Value 'asset'
    if ($DeliverableDir) {
        [void][System.IO.Directory]::CreateDirectory((Join-Path $DeliverableDir $slug))
        Set-Content -LiteralPath (Join-Path $DeliverableDir "$slug/$slug.md") -Encoding utf8 -Value "# $slug"
    }
    [pscustomobject]@{
        slug = $slug
        job_id = $env:CODEX_BATCH_JOB_ID
        execution_mode = $env:CODEX_BATCH_EXECUTION_MODE
        caller_correlation = $env:CALLER_CORRELATION
        embedded_toc = [bool]$EnableEmbeddedToc
        faithful_numbering = [bool]$FaithfulNumbering
    }
}
'@
        return $Path
    }

    function New-IngestBatchTestArchive {
        param(
            [Parameter(Mandatory)] [string] $Path,
            [Parameter(Mandatory)] [System.Collections.IDictionary] $Files
        )

        $fileStream = [System.IO.File]::Create($Path)
        $gzip = [System.IO.Compression.GzipStream]::new(
            $fileStream, [System.IO.Compression.CompressionLevel]::Optimal, $true)
        $writer = [System.Formats.Tar.TarWriter]::new(
            $gzip, [System.Formats.Tar.TarEntryFormat]::Pax, $true)
        try {
            foreach ($pair in $Files.GetEnumerator()) {
                $bytes = [System.Text.UTF8Encoding]::new($false).GetBytes([string]$pair.Value)
                $entry = [System.Formats.Tar.PaxTarEntry]::new(
                    [System.Formats.Tar.TarEntryType]::RegularFile, [string]$pair.Key)
                $data = [System.IO.MemoryStream]::new($bytes)
                try { $entry.DataStream = $data; $writer.WriteEntry($entry) }
                finally { $data.Dispose() }
            }
        }
        finally { $writer.Dispose(); $gzip.Dispose(); $fileStream.Dispose() }
    }

    . (Join-Path $script:RepositoryRoot 'src/latex-ingest/source-deposit.ps1')
    Import-Module $script:IngestBatchManifest -Force
}

AfterAll {
    Remove-Module ingest-batch -Force -ErrorAction SilentlyContinue
    Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
}

Describe 'ingest-batch module surface' {
    It 'exports only the approved inventory adapter command and keeps helpers private' {
        $warnings = @()
        Import-Module $script:IngestBatchManifest -Force -WarningVariable +warnings
        Import-Module $script:IngestBatchManifest -Force -WarningVariable +warnings

        $warnings.Count | Should -Be 0
        @((Get-Module ingest-batch).ExportedFunctions.Keys) | Should -Be @('Get-IngestBatchJob')
        (Get-Module ingest-batch).ExportedAliases.Count | Should -Be 0
        foreach ($helper in @(
                'Resolve-IngestBatchJobAddress'
                'Read-IngestBatchManifestRecord'
                'Resolve-IngestBatchLatexDependency'
                'Get-IngestBatchStableHash'
            )) {
            Get-Command $helper -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }

    It 'keeps every run-relative address in one pure private resolver' {
        $sourceFiles = @(Get-ChildItem -LiteralPath $script:IngestBatchModuleRoot -Recurse -File |
                Where-Object Extension -In @('.ps1', '.psm1'))
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
                                $node.Value -in @(
                                    'ingest-jobs', 'run-artifacts', 'lane-output', 'deliverable')
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
                                $node.GetCommandName() -eq 'Resolve-IngestBatchJobAddress'
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
            'Resolve-IngestBatchJobAddress'
            'Resolve-IngestBatchJobAddress'
            'Resolve-IngestBatchJobAddress'
            'Resolve-IngestBatchJobAddress'
        )
        @($resolverCalls) | Should -Be @('Get-IngestBatchJob')
        $sourceText.ToString() | Should -Not -Match `
            '\bNew-ModuleRunDir\b|\bNew-RunDir\b|\bNew-Item\b|CreateDirectory\s*\('
    }
}

Describe 'Get-IngestBatchJob planning' {
    It 'maps rows to stable isolated process jobs without creating run artifacts' {
        $fixture = New-IngestBatchFixture -Root (Join-Path $TestDrive 'planning')
        $dependency = Write-IngestBatchFixtureDependency (Join-Path $fixture.Root 'fixture-ingest.ps1')
        $alpha = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug alpha -ArchiveBytes 100 -TreeHash ('a' * 64)
        $beta = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug beta -ArchiveBytes 900 -TreeHash ('c' * 64)
        $rows = @(
            [pscustomobject]@{
                metadata_path = [System.IO.Path]::GetRelativePath($fixture.InventoryRoot, $alpha)
                caller_key = 'alpha-correlation'
            }
            [pscustomobject]@{
                metadata_path = [System.IO.Path]::GetRelativePath($fixture.InventoryRoot, $beta)
                caller_key = 'beta-correlation'
            }
        )
        $invoke = @{
            InventoryRow = $rows
            RunDirectory = $fixture.RunDirectory
            InventoryRoot = $fixture.InventoryRoot
            LatexIngestPath = $dependency
            ProcessEnvironment = @{ CALLER_CORRELATION = 'parent-value' }
        }
        $jobs = @(Get-IngestBatchJob @invoke)
        $again = @(Get-IngestBatchJob @invoke)

        $jobs.Count | Should -Be 2
        @($jobs.Id) | Should -Be @($again.Id)
        @($jobs.Metadata.Slug) | Should -Be @('alpha', 'beta')
        [object]::ReferenceEquals($jobs[0].Metadata.InventoryRow, $rows[0]) |
            Should -BeTrue
        foreach ($job in $jobs) {
            $job.Kind | Should -Be 'PowerShellProcess'
            $job.RuntimeProfile | Should -Be 'latex-ingest-process'
            $job.WorkingDirectory | Should -Be $script:RepositoryRoot
            $pwshLeaf = if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' }
            $job.ProcessSpec.PowerShellPath | Should -Be (Join-Path $PSHOME $pwshLeaf)
            $job.ProcessSpec.CreateNoWindow | Should -BeTrue
            $job.ProcessSpec.WindowStyle | Should -Be 'Hidden'
            $job.ProcessSpec.LoadProfile | Should -BeFalse
            $job.ProcessSpec.Environment.CALLER_CORRELATION | Should -Be 'parent-value'
            $job.Parameters.LatexIngestPath | Should -Be $dependency
            $job.Metadata.AddressingContract | Should -Be 'D19/RunDirectory'
            $job.Metadata.ResultPersistence | Should -Be 'InMemory'
            $job.Metadata.LatexIngestSha256 | Should -Match '^[0-9a-f]{64}$'
            @($job.Writes).Count | Should -Be 2
            @($job.Writes) | Should -Be @(
                $job.Metadata.ApplicationRunDirectory, $job.Metadata.OutputDirectory)
            Test-Path -LiteralPath $job.Metadata.JobDirectory | Should -BeFalse
        }
        $jobs[1].EstimatedCost | Should -BeGreaterThan $jobs[0].EstimatedCost
        [object]::ReferenceEquals(
            $jobs[0].ProcessSpec.Environment, $jobs[1].ProcessSpec.Environment) |
            Should -BeFalse

        $compiled = InModuleScope ingest-batch -Parameters @{
            Jobs = $jobs; BasePath = $script:RepositoryRoot
        } {
            New-BatchPlan -Job $Jobs -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0
        $compiled.Plan.Jobs.Count | Should -Be 2
        $compiled.Plan.DispatchJobs[0].Id | Should -Be $jobs[1].Id
    }

    It 'supports a caller-selected row projection and freezes output options and child policy' {
        $fixture = New-IngestBatchFixture -Root (Join-Path $TestDrive 'projection')
        $dependency = Write-IngestBatchFixtureDependency (Join-Path $fixture.Root 'projection-ingest.ps1')
        $manifest = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot -Slug projected
        $row = [pscustomobject]@{ manifest_ref = $manifest; external_correlation = 'caller-owned' }
        $base = @(Get-IngestBatchJob -InventoryRow $row -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot -MetadataPathProperty manifest_ref `
                -LatexIngestPath $dependency)[0]
        $configured = @(Get-IngestBatchJob -InventoryRow $row -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot -MetadataPathProperty manifest_ref `
                -LatexIngestPath $dependency -BundleDeliverable -EnableEmbeddedToc `
                -DisableTreeToc -DisableJsonlToc -FaithfulNumbering -TimeoutSeconds 90 `
                -PriorityClass BelowNormal)[0]

        $configured.Id | Should -Not -Be $base.Id
        $configured.Metadata.MetadataPathProperty | Should -Be 'manifest_ref'
        [object]::ReferenceEquals($configured.Metadata.InventoryRow, $row) |
            Should -BeTrue
        $configured.Parameters.DeliverableDir | Should -Be `
            $configured.Metadata.DeliverableDirectory
        $configured.Parameters.EnableEmbeddedToc | Should -BeTrue
        $configured.Parameters.DisableTreeToc | Should -BeTrue
        $configured.Parameters.DisableJsonlToc | Should -BeTrue
        $configured.Parameters.FaithfulNumbering | Should -BeTrue
        $configured.ProcessSpec.TimeoutSeconds | Should -Be 90
        $configured.ProcessSpec.PriorityClass | Should -Be 'BelowNormal'
        @($configured.Writes) | Should -Be @(
            $configured.Metadata.ApplicationRunDirectory
            $configured.Metadata.OutputDirectory
            $configured.Metadata.DeliverableDirectory
        )
        foreach ($write in $configured.Writes) {
            $relative = [System.IO.Path]::GetRelativePath($fixture.RunDirectory, $write)
            $relative | Should -Not -Be '..'
            $relative | Should -Not -Match '^\.\.[\\/]'
        }
    }

    It 'pins a parseable latex-ingest dependency and rejects an impostor before emitting jobs' {
        $fixture = New-IngestBatchFixture -Root (Join-Path $TestDrive 'dependency')
        $manifest = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot -Slug dependency
        $row = [pscustomobject]@{ metadata_path = $manifest }

        $job = @(Get-IngestBatchJob -InventoryRow $row -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot)[0]
        $job.Metadata.LatexIngestPath | Should -Be $script:LiveLatexIngest
        $job.Metadata.LatexIngestSha256 | Should -Match '^[0-9a-f]{64}$'

        $impostor = Join-Path $fixture.Root 'impostor.ps1'
        Set-Content -LiteralPath $impostor -Encoding utf8 -Value 'function Invoke-SomethingElse { }'
        { Get-IngestBatchJob -InventoryRow $row -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot -LatexIngestPath $impostor } |
            Should -Throw '*must define Invoke-ArxivLatexToMarkdown exactly once*'
    }

    It 'rejects ambiguous ownership and invalid source-ready inputs before addressing work' {
        $fixture = New-IngestBatchFixture -Root (Join-Path $TestDrive 'invalid')
        $dependency = Write-IngestBatchFixtureDependency (Join-Path $fixture.Root 'invalid-ingest.ps1')
        $valid = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot -Slug valid
        $row = [pscustomobject]@{ metadata_path = $valid }
        $missingRun = Join-Path $fixture.Root 'missing-run'
        { Get-IngestBatchJob -InventoryRow $row -RunDirectory 'relative-run' `
                -InventoryRoot $fixture.InventoryRoot -LatexIngestPath $dependency } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        { Get-IngestBatchJob -InventoryRow $row -RunDirectory $missingRun `
                -InventoryRoot $fixture.InventoryRoot -LatexIngestPath $dependency } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        Test-Path -LiteralPath $missingRun | Should -BeFalse

        { Get-IngestBatchJob -InventoryRow ([pscustomobject]@{ wrong = $valid }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw "*has no 'metadata_path' metadata address*"
        $outside = Write-IngestBatchManifest -InventoryRoot $fixture.Root `
            -DirectoryName outside -Slug outside
        { Get-IngestBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $outside }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*escapes InventoryRoot*'
        $notReady = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -DirectoryName not-ready -Slug not-ready -State initializing
        { Get-IngestBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $notReady }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*requires a source-ready*'
        $unsafe = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -DirectoryName unsafe -Slug '../unsafe'
        { Get-IngestBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $unsafe }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*slug must be one safe path leaf*'
        $noTree = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -DirectoryName no-tree -Slug no-tree -OmitTree
        { Get-IngestBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $noTree }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*exactly one LaTeX archive and source tree*'
    }
}

Describe 'ingest-batch execution integration' {
    It 'contains one document failure while preserving child correlation and declared application writes' {
        $fixture = New-IngestBatchFixture -Root (Join-Path $TestDrive 'execution')
        $dependency = Write-IngestBatchFixtureDependency (Join-Path $fixture.Root 'execution-ingest.ps1')
        $good = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug good -ArchiveBytes 100
        $broken = Write-IngestBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug broken -ArchiveBytes 500 -TreeHash ('d' * 64)
        $rows = @(
            [pscustomobject]@{ metadata_path = $good; caller = 'good-row' }
            [pscustomobject]@{ metadata_path = $broken; caller = 'broken-row' }
        )
        $jobs = @(Get-IngestBatchJob -InventoryRow $rows -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot -LatexIngestPath $dependency `
                -BundleDeliverable -EnableEmbeddedToc -FaithfulNumbering `
                -ProcessEnvironment @{ CALLER_CORRELATION = 'caller-trace' } -TimeoutSeconds 30)
        foreach ($job in $jobs) {
            Test-Path -LiteralPath $job.Metadata.JobDirectory | Should -BeFalse
        }
        $compiled = InModuleScope ingest-batch -Parameters @{
            Jobs = $jobs; BasePath = $script:RepositoryRoot
        } {
            New-BatchPlan -Job $Jobs -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0

        $execution = InModuleScope ingest-batch -Parameters @{ Compiled = $compiled } {
            Invoke-BatchPlan -Plan $Compiled -MaxWorkers 2
        }

        @($execution.Results.Id) | Should -Be @($jobs.Id)
        @($execution.Results.State) | Should -Be @('Succeeded', 'Failed')
        [object]::ReferenceEquals(
            $execution.Results[0].Input.Metadata.InventoryRow, $rows[0]) |
            Should -BeTrue
        $execution.Summary.Succeeded | Should -Be 1
        $execution.Summary.Failed | Should -Be 1
        $execution.Results[1].Errors -join "`n" | Should -Match 'fixture document failure'
        $output = @($execution.Results[0].Output)[0]
        $output.slug | Should -Be 'good'
        $output.job_id | Should -Be $jobs[0].Id
        $output.execution_mode | Should -Be 'Process'
        $output.caller_correlation | Should -Be 'caller-trace'
        $output.embedded_toc | Should -BeTrue
        $output.faithful_numbering | Should -BeTrue

        Test-Path -LiteralPath (Join-Path `
                $jobs[0].Metadata.ApplicationRunDirectory 'good.evidence.json') | Should -BeTrue
        Test-Path -LiteralPath (Join-Path `
                $jobs[0].Metadata.OutputDirectory 'good-latex.md') | Should -BeTrue
        Test-Path -LiteralPath (Join-Path `
                $jobs[0].Metadata.OutputDirectory 'good/asset.txt') | Should -BeTrue
        Test-Path -LiteralPath (Join-Path `
                $jobs[0].Metadata.DeliverableDirectory 'good/good.md') | Should -BeTrue
        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File |
                Where-Object Name -Match '^batch-(?:job-)?results?\.(?:json|jsonl)$').Count |
            Should -Be 0
    }

    It 'runs the live manifest-only latex-ingest entrypoint at its declared addresses' {
        $fixture = New-IngestBatchFixture -Root (Join-Path $TestDrive 'live-execution')
        $documentDirectory = Join-Path $fixture.InventoryRoot 'live-document'
        [void][System.IO.Directory]::CreateDirectory($documentDirectory)
        $archive = Join-Path $documentDirectory 'live-document.tar.gz'
        New-IngestBatchTestArchive -Path $archive -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}\section{Live}Adapter body.\end{document}'
            })
        $initialized = Initialize-LatexSourceDeposit -DocumentDir $documentDirectory `
            -Slug live-document
        $row = [pscustomobject]@{ metadata_path = $initialized.metadata_path }
        $job = @(Get-IngestBatchJob -InventoryRow $row `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -TimeoutSeconds 60)[0]
        $compiled = InModuleScope ingest-batch -Parameters @{
            Job = $job; BasePath = $script:RepositoryRoot
        } {
            New-BatchPlan -Job @($Job) -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0

        $execution = InModuleScope ingest-batch -Parameters @{ Compiled = $compiled } {
            Invoke-BatchPlan -Plan $Compiled -MaxWorkers 1
        }

        $execution.Results[0].State | Should -Be 'Succeeded'
        $execution.Results[0].Output[0].slug | Should -Be 'live-document'
        Test-Path -LiteralPath (Join-Path `
                $job.Metadata.OutputDirectory 'live-document-latex.md') | Should -BeTrue
        Test-Path -LiteralPath (Join-Path `
                $job.Metadata.ApplicationRunDirectory 'live-document.oracle-counts.json') |
            Should -BeTrue
        Test-Path -LiteralPath (Join-Path `
                $job.Metadata.ApplicationRunDirectory 'audits/math-render.json') | Should -BeTrue
    }
}
