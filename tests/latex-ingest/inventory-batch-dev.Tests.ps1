#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:InventoryCatalogScript = Join-Path `
        $script:RepositoryRoot 'src/latex-ingest/inventory-catalog.ps1'
    $script:LatexBatchShell = Join-Path `
        $script:RepositoryRoot 'src/latex-ingest/latex-batch.ps1'
    $script:Utf8 = [System.Text.UTF8Encoding]::new($false, $true)
    . $script:InventoryCatalogScript

    function Write-InventoryBatchManifest {
        param(
            [Parameter(Mandatory)] [string] $InventoryRoot,
            [Parameter(Mandatory)] [string] $Slug,
            [string] $State = 'source-ready'
        )

        $documentRoot = Join-Path $InventoryRoot $Slug
        $sourceRoot = Join-Path $documentRoot "$Slug-tex"
        [void][System.IO.Directory]::CreateDirectory($sourceRoot)
        $archivePath = Join-Path $documentRoot "$Slug.tar.gz"
        [System.IO.File]::WriteAllBytes($archivePath, [byte[]]@(0x1F, 0x8B, 0x08, 0x00))
        [System.IO.File]::WriteAllText(
            (Join-Path $sourceRoot 'main.tex'),
            '\documentclass{article}\begin{document}fixture\end{document}',
            $script:Utf8)
        $archiveHash = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
        $manifest = [ordered]@{
            schema          = 'codex-scientiae/document-metadata/0.1'
            state           = $State
            slug            = $Slug
            initialized_utc = '2026-08-06T00:00:00Z'
            document        = [ordered]@{
                title = "Title $Slug"
                authors = @('Fixture Author')
                abstract = $null
                identifiers = [ordered]@{
                    arxiv = $null; arxiv_versioned = $Slug; doi = $null
                }
                categories = @('cs.TEST')
                primary_category = 'cs.TEST'
                published = $null
                updated = $null
            }
            evidence        = [ordered]@{
                provider_metadata = @()
                latex_source = [ordered]@{
                    entrypoint = "$Slug-tex/main.tex"
                    selection = 'single-document-candidate'
                    declarations = [ordered]@{
                        title_tex = $null; authors_tex = @(); doi = $null
                    }
                }
                package_control_files = @()
            }
            source_forms    = @(
                [ordered]@{
                    role = 'latex-source-archive'
                    path = "$Slug.tar.gz"
                    format = 'application/gzip'
                    bytes = 4
                    sha256 = $archiveHash
                }
                [ordered]@{
                    role = 'latex-source-tree'
                    path = "$Slug-tex"
                    format = 'application/x-latex-source-tree'
                    bytes = 61
                    sha256 = ('c' * 64)
                    derived_from = "$Slug.tar.gz"
                    entrypoint = 'main.tex'
                    files = 1
                    tex_files = 1
                }
            )
            validation      = [ordered]@{
                status = 'valid'
                validated_utc = '2026-08-06T00:00:00Z'
                publication = 'published-new-tree'
                checks = @('fixture-check')
            }
        }
        $metadataPath = Join-Path $documentRoot 'metadata.json'
        [System.IO.File]::WriteAllText(
            $metadataPath,
            ($manifest | ConvertTo-Json -Depth 20),
            $script:Utf8)
        return $metadataPath
    }

    function Write-InventoryBatchDependency {
        param([Parameter(Mandatory)] [string] $Path)

        [System.IO.File]::WriteAllText($Path, @'
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
    if ($manifest.slug -eq 'broken') { throw 'planned latex-batch dev failure' }
    [void][System.IO.Directory]::CreateDirectory($RunDir)
    [void][System.IO.Directory]::CreateDirectory($OutDir)
    [System.IO.File]::WriteAllText((Join-Path $RunDir "$($manifest.slug).evidence.json"), '{}')
    [System.IO.File]::WriteAllText((Join-Path $OutDir "$($manifest.slug)-latex.md"), "# $($manifest.slug)")
    [pscustomobject]@{ slug = $manifest.slug; job_id = $env:CODEX_BATCH_JOB_ID }
}
'@, $script:Utf8)
        return $Path
    }
}

AfterAll {
    Remove-Module adapters -Force -ErrorAction SilentlyContinue
    Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
}

Describe 'localized latex inventory catalog' {
    It 'materializes direct source-ready sentinels in deterministic canonical JSONL' {
        $root = Join-Path $TestDrive 'deterministic-inventory'
        [void][System.IO.Directory]::CreateDirectory($root)
        $null = Write-InventoryBatchManifest -InventoryRoot $root -Slug zeta
        $null = Write-InventoryBatchManifest -InventoryRoot $root -Slug alpha
        [void][System.IO.Directory]::CreateDirectory((Join-Path $root 'not-a-document'))

        $created = Write-LatexInventoryCatalog -InventoryRoot $root
        $created.Records | Should -Be 2
        $created.Schema | Should -Be 'codex-scientiae/document-inventory-row/0.1'
        Split-Path -Leaf $created.Path | Should -Be 'inventory.jsonl'
        $bytes = [System.IO.File]::ReadAllBytes($created.Path)
        @($bytes[0..2]) | Should -Not -Be @(0xEF, 0xBB, 0xBF)
        $text = $script:Utf8.GetString($bytes)
        $text | Should -Not -Match "`r"
        $text.EndsWith("`n", [System.StringComparison]::Ordinal) | Should -BeTrue
        $rows = @(Read-LatexInventoryCatalog -InventoryPath $created.Path)
        @($rows.document_parent) | Should -Be @('alpha', 'zeta')
        @($rows.metadata_path) | Should -Be @(
            'alpha/metadata.json', 'zeta/metadata.json')
        @($rows.schema | Select-Object -Unique) | Should -Be @(
            'codex-scientiae/document-inventory-row/0.1')
        @(Get-ChildItem -LiteralPath $root -File | Where-Object Extension -eq '.jidx').Count |
            Should -Be 0

        $before = [Convert]::ToBase64String($bytes)
        $null = Write-LatexInventoryCatalog -InventoryRoot $root -ExistingFile Replace
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($created.Path)) |
            Should -BeExactly $before
    }

    It 'rejects an invalid sentinel before replacing an existing catalog' {
        $root = Join-Path $TestDrive 'invalid-inventory'
        [void][System.IO.Directory]::CreateDirectory($root)
        $null = Write-InventoryBatchManifest -InventoryRoot $root -Slug alpha
        $created = Write-LatexInventoryCatalog -InventoryRoot $root
        $before = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($created.Path))
        $null = Write-InventoryBatchManifest -InventoryRoot $root -Slug invalid `
            -State initializing

        { Write-LatexInventoryCatalog -InventoryRoot $root -ExistingFile Replace } |
            Should -Throw '*metadata sentinel failed schema validation*'
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($created.Path)) |
            Should -BeExactly $before
        @(Get-ChildItem -LiteralPath $root -File -Filter '*.tmp').Count | Should -Be 0
    }

    It 'detects a manifest change as a stale catalog instead of silently following it' {
        $root = Join-Path $TestDrive 'stale-inventory'
        [void][System.IO.Directory]::CreateDirectory($root)
        $metadataPath = Write-InventoryBatchManifest -InventoryRoot $root -Slug alpha
        $created = Write-LatexInventoryCatalog -InventoryRoot $root
        [System.IO.File]::AppendAllText($metadataPath, ' ', $script:Utf8)

        { Read-LatexInventoryCatalog -InventoryPath $created.Path } |
            Should -Throw '*catalog is stale*rebuild inventory.jsonl*'
    }
}

Describe 'latex-batch development shell' {
    It 'composes catalog, adapter, plan, and executor while keeping initialization out of the run' {
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $script:LatexBatchShell, [ref]$tokens, [ref]$parseErrors)
        $parseErrors.Count | Should -Be 0
        $commands = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.CommandAst]
                }, $true) | ForEach-Object GetCommandName)
        foreach ($name in @(
                'Read-LatexInventoryCatalog'
                'adapters\Get-LatexBatchJob'
                'batch-executor\New-BatchPlan'
                'batch-executor\Invoke-BatchPlan'
            )) {
            @($commands | Where-Object { $_ -eq $name }).Count | Should -Be 1
        }
        @($commands | Where-Object { $_ -eq 'Initialize-LatexSourceDeposit' }).Count |
            Should -Be 0
        $source = $ast.Extent.Text
        $source | Should -Not -Match 'Get-ChildItem|metadata\.json|source-ready|tar\.gz'
    }

    It 'selects catalog rows, allocates one latex-batch run, and returns executor evidence' {
        $repository = Join-Path $TestDrive 'shell-repository'
        $inventory = Join-Path $repository 'ingestion/inventory'
        [void][System.IO.Directory]::CreateDirectory($inventory)
        $null = Write-InventoryBatchManifest -InventoryRoot $inventory -Slug beta
        $null = Write-InventoryBatchManifest -InventoryRoot $inventory -Slug alpha
        $catalog = Write-LatexInventoryCatalog -InventoryRoot $inventory
        $dependency = Write-InventoryBatchDependency -Path `
            (Join-Path $repository 'fixture-latex-ingest.ps1')
        $artifacts = Join-Path $TestDrive 'shell-artifacts'
        $information = @()

        $execution = & $script:LatexBatchShell -InventoryPath $catalog.Path `
            -RepositoryRoot $repository -ArtifactsRoot $artifacts `
            -LatexIngestPath $dependency -PowerShellPath ([System.Environment]::ProcessPath) `
            -Slug alpha -MaxWorkers 2 -TimeoutSeconds 30 `
            -InformationVariable +information

        $execution.Summary.Total | Should -Be 1
        $execution.Summary.Succeeded | Should -Be 1
        $execution.Budget.Threads | Should -Be 1
        $execution.SelectedSlugs | Should -Be @('alpha')
        $execution.InventoryPath | Should -Be $catalog.Path
        $execution.RunDirectory | Should -Match `
            ([regex]::Escape((Join-Path $artifacts 'latex-batch/runs')))
        $metadata = $execution.Results[0].Input.Metadata
        Test-Path -LiteralPath (Join-Path `
                $metadata.OutputDirectory 'alpha-latex.md') -PathType Leaf | Should -BeTrue
        Test-Path -LiteralPath (Join-Path `
                $metadata.ApplicationRunDirectory 'alpha.evidence.json') -PathType Leaf |
            Should -BeTrue
        Test-Path -LiteralPath (Join-Path $execution.RunDirectory `
                'latex-jobs') -PathType Container | Should -BeTrue
        (@($information | ForEach-Object MessageData) -join "`n") |
            Should -Match 'total=1; succeeded=1; failed=0'
        Get-Process -Id $execution.Results[0].ProcessId -ErrorAction SilentlyContinue |
            Should -BeNullOrEmpty
    }

    It 'emits the complete sibling result before making a failed batch nonzero' {
        $repository = Join-Path $TestDrive 'failure-repository'
        $inventory = Join-Path $repository 'ingestion/inventory'
        $run = Join-Path $TestDrive 'failure-run'
        foreach ($directory in @($inventory, $run)) {
            [void][System.IO.Directory]::CreateDirectory($directory)
        }
        $null = Write-InventoryBatchManifest -InventoryRoot $inventory -Slug good
        $null = Write-InventoryBatchManifest -InventoryRoot $inventory -Slug broken
        $catalog = Write-LatexInventoryCatalog -InventoryRoot $inventory
        $dependency = Write-InventoryBatchDependency -Path `
            (Join-Path $repository 'fixture-latex-ingest.ps1')
        $outputs = [System.Collections.Generic.List[object]]::new()
        $failure = $null
        try {
            & $script:LatexBatchShell -InventoryPath $catalog.Path `
                -RepositoryRoot $repository -RunDirectory $run `
                -LatexIngestPath $dependency -PowerShellPath ([System.Environment]::ProcessPath) `
                -MaxWorkers 2 -TimeoutSeconds 30 |
                ForEach-Object { $outputs.Add($_) }
        }
        catch { $failure = $_ }

        $failure.Exception.Message | Should -Match 'latex-batch did not succeed'
        $outputs.Count | Should -Be 1
        @($outputs[0].Results.State) | Should -Be @('Failed', 'Succeeded')
        $outputs[0].Summary.Total | Should -Be 2
        $outputs[0].Summary.Succeeded | Should -Be 1
        $outputs[0].Summary.Failed | Should -Be 1
        foreach ($result in $outputs[0].Results) {
            Get-Process -Id $result.ProcessId -ErrorAction SilentlyContinue |
                Should -BeNullOrEmpty
        }
    }
}
