#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:AdaptersModuleRoot = Join-Path $script:RepositoryRoot 'src/batch-adapters'
    $script:AdaptersManifest = Join-Path $script:AdaptersModuleRoot 'adapters.psd1'
    $script:LiveLatexIngest = Join-Path $script:RepositoryRoot 'src/latex-ingest/latex-ingest.ps1'
    $script:PythonPath = Join-Path $script:RepositoryRoot '.venv/Scripts/python.exe'
    if (-not [System.IO.File]::Exists($script:PythonPath)) {
        $script:PythonPath = Join-Path $script:RepositoryRoot '.venv/bin/python'
    }

    function Get-LatexBatchMathRenderCapability {
        $node = Get-Command node -CommandType Application -ErrorAction SilentlyContinue |
            Select-Object -First 1
        $auditEngine = Join-Path $script:RepositoryRoot 'src/node_utils/math-render/katex-check.js'
        $katexPackage = Join-Path $script:RepositoryRoot 'packages/node/node_modules/katex/package.json'
        if (-not $node) {
            return [pscustomobject]@{
                Available = $false
                Reason = 'Node required by the shared KaTeX math-render audit is absent from PATH'
                NodePath = $null
            }
        }
        if (-not [System.IO.File]::Exists($auditEngine)) {
            return [pscustomobject]@{
                Available = $false
                Reason = "the shared math-render audit engine is absent: '$auditEngine'"
                NodePath = $node.Source
            }
        }
        if (-not [System.IO.File]::Exists($katexPackage)) {
            return [pscustomobject]@{
                Available = $false
                Reason = "the shared KaTeX payload is absent: '$katexPackage'"
                NodePath = $node.Source
            }
        }
        return [pscustomobject]@{
            Available = $true
            Reason = $null
            NodePath = [System.IO.Path]::GetFullPath($node.Source)
        }
    }

    function New-LatexBatchFixture {
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

    function Test-LatexBatchPathCoveredByWrite {
        param(
            [Parameter(Mandatory)] [string] $Path,
            [Parameter(Mandatory)] [string[]] $Write
        )

        $target = [System.IO.Path]::GetFullPath($Path)
        foreach ($declaredRoot in $Write) {
            $relative = [System.IO.Path]::GetRelativePath(
                [System.IO.Path]::GetFullPath($declaredRoot), $target)
            if ($relative -eq '.' -or (
                    -not [System.IO.Path]::IsPathFullyQualified($relative) -and
                    $relative -notmatch '^\.\.(?:[\\/]|$)')) {
                return $true
            }
        }
        return $false
    }

    function Write-LatexBatchManifest {
        param(
            [Parameter(Mandatory)] [string] $InventoryRoot,
            [Parameter(Mandatory)] [string] $Slug,
            [string] $DirectoryName = $Slug,
            [string] $State = 'source-ready',
            [string] $TreeHash = ('a' * 64),
            [string] $ArchiveHash = ('b' * 64),
            [long] $ArchiveBytes = 100,
            [switch] $OmitTree,
            [switch] $Article
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
                    derived_from = "$DirectoryName.tar.gz"
                    entrypoint = 'main.tex'
                    entrypoint_selection = 'single-candidate'
                    files = 2
                    tex_files = 1
                    sha256 = $TreeHash
                })
        }
        $manifest = if ($Article) {
            [ordered]@{
                schema = 'codex-scientiae/article/0.1'
                state = $State
                slug = $Slug
                initialized_utc = '2026-01-01T00:00:00Z'
                title = $null
                authors = @()
                abstract = $null
                identifiers = [ordered]@{
                    arxiv = $null; arxiv_versioned = $null; doi = $null
                }
                categories = @()
                primary_category = $null
                published = $null
                updated = $null
                evidence = [ordered]@{
                    provider_metadata = @()
                    latex_source = [ordered]@{
                        entrypoint = 'main.tex'
                        selection = 'single-candidate'
                        declarations = [ordered]@{
                            title_tex = $null; authors_tex = @(); doi = $null
                        }
                    }
                    package_control_files = @()
                }
                source_forms = $forms.ToArray()
                validation = [ordered]@{
                    status = 'valid'
                    validated_utc = '2026-01-01T00:00:00Z'
                    publication = 'published-new-tree'
                    checks = @([ordered]@{ name = 'fixture'; outcome = 'passed' })
                }
            }
        }
        else {
            [ordered]@{
                schema = 'codex-scientiae/document-metadata/0.1'
                state = $State
                slug = $Slug
                source_forms = $forms.ToArray()
            }
        }
        $path = Join-Path $documentDirectory $(if ($Article) { 'article.json' } else { 'metadata.json' })
        Set-Content -LiteralPath $path -Encoding utf8 `
            -Value ($manifest | ConvertTo-Json -Depth 8)
        return $path
    }

    function Write-LatexBatchFixtureDependency {
        param([Parameter(Mandatory)] [string] $Path)

        Set-Content -LiteralPath $Path -Encoding utf8 -Value @'
function Invoke-ArxivLatexToMarkdown {
        [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $MetadataPath,
        [Parameter(Mandatory)] [string] $ExpectedSlug,
        [Parameter(Mandatory)] [string] $OutDir,
        [string] $DeliverableDir,
        [Parameter(Mandatory)] [string] $RunDir,
        [Parameter(Mandatory)] [string] $ExpectedPatchIdentity,
        [switch] $EnableEmbeddedToc,
        [switch] $DisableTreeToc,
        [switch] $DisableJsonlToc,
        [switch] $FaithfulNumbering
    )

    $manifest = Get-Content -LiteralPath $MetadataPath -Raw | ConvertFrom-Json
    $slug = [string]$manifest.slug
    if ($slug -cne $ExpectedSlug) {
        throw "fixture resolved slug '$slug' does not match expected slug '$ExpectedSlug'"
    }
    $patchPath = Join-Path (Split-Path -Parent $MetadataPath) "$slug-latex.patch.jsonl"
    $patchEntry = Get-Item -LiteralPath $patchPath -Force -ErrorAction SilentlyContinue
    $actualPatchIdentity = if ($null -eq $patchEntry) {
        'absent'
    }
    elseif (-not [System.IO.File]::Exists($patchPath) -or
        ($patchEntry.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "fixture patch path is not a physical file: '$patchPath'"
    }
    else {
        'sha256:' + (Get-FileHash -LiteralPath $patchPath -Algorithm SHA256).Hash.ToLowerInvariant()
    }
    if ($actualPatchIdentity -cne $ExpectedPatchIdentity) {
        throw "fixture patch identity drift: expected '$ExpectedPatchIdentity', found '$actualPatchIdentity'"
    }
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
        patch_identity = $actualPatchIdentity
        embedded_toc = [bool]$EnableEmbeddedToc
        faithful_numbering = [bool]$FaithfulNumbering
    }
}
'@
        return $Path
    }

    function New-LatexBatchTestArchive {
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

    . (Join-Path $script:RepositoryRoot 'src/logistics/latex-source.ps1')

    function New-LegacyMetadataSourceDeposit {
        param(
            [Parameter(Mandatory)] [string] $DocumentDir,
            [Parameter(Mandatory)] [string] $Slug
        )

        $archive = Join-Path $DocumentDir "$Slug.tar.gz"
        $tree = Join-Path $DocumentDir "$Slug-tex"
        Expand-LatexSourceArchive -ArchivePath $archive -DestinationPath $tree | Out-Null
        $validation = Test-LatexSourceTree -RootPath $tree -Slug $Slug
        $archiveHash = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
        $manifestPath = Join-Path $DocumentDir 'metadata.json'
        $manifest = [ordered]@{
            schema     = 'codex-scientiae/document-metadata/0.1'
            state      = 'source-ready'
            slug       = $Slug
            source_forms = @(
                [ordered]@{
                    role   = 'latex-source-archive'
                    path   = "$Slug.tar.gz"
                    format = 'application/gzip'
                    sha256 = $archiveHash
                }
                [ordered]@{
                    role         = 'latex-source-tree'
                    path         = "$Slug-tex"
                    format       = 'application/x-latex-source-tree'
                    derived_from = "$Slug.tar.gz"
                    entrypoint   = [string]$validation.entrypoint
                    sha256       = [string]$validation.tree_sha256
                }
            )
        }
        [System.IO.File]::WriteAllText(
            $manifestPath,
            (ConvertTo-Json -InputObject $manifest -Depth 20) + "`n",
            [System.Text.UTF8Encoding]::new($false))
        return [pscustomobject]@{
            metadata_path = $manifestPath
            archive_path  = $archive
            source_path   = $tree
        }
    }

    Import-Module $script:AdaptersManifest -Force
    $script:MathRenderCapability = Get-LatexBatchMathRenderCapability
}

AfterAll {
    Remove-Module adapters -Force -ErrorAction SilentlyContinue
    Remove-Module batch-executor -Force -ErrorAction SilentlyContinue
}

Describe 'adapters module surface for latex-batch' {
    It 'exports the approved adapter commands and keeps helpers private' {
        $warnings = @()
        Import-Module $script:AdaptersManifest -Force -WarningVariable +warnings
        Import-Module $script:AdaptersManifest -Force -WarningVariable +warnings

        $warnings.Count | Should -Be 0
        @((Get-Module adapters).ExportedFunctions.Keys | Sort-Object) | Should -Be @(
            'Get-LatexBatchJob', 'Get-PesterBatchJob', 'Get-PytestBatchJob')
        (Get-Module adapters).ExportedAliases.Count | Should -Be 0
        foreach ($helper in @(
                'Resolve-LatexBatchJobAddress'
                'Resolve-LatexBatchPatchRecord'
                'Read-LatexBatchManifestRecord'
                'Resolve-LatexBatchDependency'
                'Get-LatexBatchStableHash'
            )) {
            Get-Command $helper -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }

    It 'keeps every run-relative address in one pure private resolver' {
        $sourceFiles = @(Get-ChildItem -LiteralPath $script:AdaptersModuleRoot -Recurse -File |
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
                                    'latex-jobs', 'run-artifacts', 'lane-output', 'deliverable')
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
                                $node.GetCommandName() -eq 'Resolve-LatexBatchJobAddress'
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
            'Resolve-LatexBatchJobAddress'
            'Resolve-LatexBatchJobAddress'
            'Resolve-LatexBatchJobAddress'
            'Resolve-LatexBatchJobAddress'
        )
        @($resolverCalls) | Should -Be @('Get-LatexBatchJob')
        $sourceText.ToString() | Should -Not -Match `
            '\bNew-ModuleRunDir\b|\bNew-RunDir\b|\bNew-Item\b|CreateDirectory\s*\('
    }
}

Describe 'Get-LatexBatchJob planning' {
    It 'maps rows to stable isolated process jobs without creating run artifacts' {
        $fixture = New-LatexBatchFixture -Root (Join-Path $TestDrive 'planning')
        $dependency = Write-LatexBatchFixtureDependency (Join-Path $fixture.Root 'fixture-ingest.ps1')
        $alpha = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug alpha -ArchiveBytes 100 -TreeHash ('a' * 64) -Article
        $beta = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug beta -ArchiveBytes 900 -TreeHash ('c' * 64)
        $rows = @(
            [pscustomobject]@{
                # A directory address resolves the canonical article.json before the temporary
                # compatibility fallback to metadata.json.
                metadata_path = [System.IO.Path]::GetRelativePath(
                    $fixture.InventoryRoot, (Split-Path -Parent $alpha))
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
        $jobs = @(Get-LatexBatchJob @invoke)
        $again = @(Get-LatexBatchJob @invoke)

        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -Force).Count | Should -Be 0
        $jobs.Count | Should -Be 2
        @($jobs.Id) | Should -Be @($again.Id)
        @($jobs.Metadata.Slug) | Should -Be @('alpha', 'beta')
        $jobs[0].Metadata.MetadataPath | Should -Be $alpha
        [object]::ReferenceEquals($jobs[0].Metadata.InventoryRow, $rows[0]) |
            Should -BeTrue
        foreach ($job in $jobs) {
            $job.Id | Should -Match '^latex:'
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
            $job.Parameters.ExpectedSlug | Should -Be $job.Metadata.Slug
            $job.Parameters.ExpectedPatchIdentity | Should -Be $job.Metadata.PatchIdentity
            $job.Parameters.RunDir | Should -Be $job.Metadata.ApplicationRunDirectory
            $job.Parameters.OutDir | Should -Be $job.Metadata.OutputDirectory
            $job.Parameters.ContainsKey('DeliverableDir') | Should -BeFalse
            $job.Metadata.AddressingContract | Should -Be 'D19/RunDirectory'
            $job.Metadata.Adapter | Should -Be 'latex-batch'
            $job.Metadata.Domain | Should -Be 'latex-ingest'
            $job.Metadata.ResultPersistence | Should -Be 'InMemory'
            $job.Metadata.LatexIngestSha256 | Should -Match '^[0-9a-f]{64}$'
            $job.Metadata.PatchPath | Should -Be (Join-Path `
                (Split-Path -Parent $job.Metadata.MetadataPath) `
                "$($job.Metadata.Slug)-latex.patch.jsonl")
            $job.Metadata.InventoryRelativePatchPath | Should -Be `
                "$($job.Metadata.Slug)/$($job.Metadata.Slug)-latex.patch.jsonl"
            $job.Metadata.PatchIdentity | Should -Be 'absent'
            Test-Path -LiteralPath $job.Metadata.PatchPath | Should -BeFalse
            @($job.Writes).Count | Should -Be 2
            @($job.Writes) | Should -Be @(
                $job.Metadata.ApplicationRunDirectory, $job.Metadata.OutputDirectory)
            foreach ($write in $job.Writes) {
                $relativeWrite = [System.IO.Path]::GetRelativePath(
                    $fixture.RunDirectory, $write)
                $relativeWrite | Should -Not -Be '..'
                $relativeWrite | Should -Not -Match '^\.\.[\\/]'
            }
            Test-LatexBatchPathCoveredByWrite -Path $job.Metadata.PatchPath `
                -Write $job.Writes | Should -BeFalse
            Test-Path -LiteralPath $job.Metadata.JobDirectory | Should -BeFalse
        }
        $jobs[1].EstimatedCost | Should -BeGreaterThan $jobs[0].EstimatedCost
        [object]::ReferenceEquals(
            $jobs[0].ProcessSpec.Environment, $jobs[1].ProcessSpec.Environment) |
            Should -BeFalse

        $compiled = InModuleScope adapters -Parameters @{
            Jobs = $jobs; BasePath = $script:RepositoryRoot
        } {
            New-BatchPlan -Job $Jobs -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0
        $compiled.Plan.Jobs.Count | Should -Be 2
        $compiled.Plan.DispatchJobs[0].Id | Should -Be $jobs[1].Id
    }

    It 'freezes absent and present patch identity into stable metadata, parameters, and addresses' {
        $fixture = New-LatexBatchFixture -Root (Join-Path $TestDrive 'patch-identity')
        $dependency = Write-LatexBatchFixtureDependency `
            (Join-Path $fixture.Root 'patch-identity-ingest.ps1')
        $manifest = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug patched
        $row = [pscustomobject]@{ metadata_path = $manifest }
        $invoke = @{
            InventoryRow = $row
            RunDirectory = $fixture.RunDirectory
            InventoryRoot = $fixture.InventoryRoot
            LatexIngestPath = $dependency
        }

        $absent = @(Get-LatexBatchJob @invoke)[0]
        $absentAgain = @(Get-LatexBatchJob @invoke)[0]
        $absent.Id | Should -Be $absentAgain.Id
        $absent.Metadata.PatchIdentity | Should -Be 'absent'
        $absent.Parameters.ExpectedPatchIdentity | Should -Be 'absent'

        $patchPath = Join-Path (Split-Path -Parent $manifest) 'patched-latex.patch.jsonl'
        [System.IO.File]::WriteAllText(
            $patchPath,
            "{`"op`":`"output_replace`",`"find`":`"x`",`"replace`":`"y`",`"expect`":1,`"reason`":`"fixture`"}`n",
            [System.Text.UTF8Encoding]::new($false))
        $firstHash = (Get-FileHash -LiteralPath $patchPath -Algorithm SHA256).Hash.ToLowerInvariant()
        $present = @(Get-LatexBatchJob @invoke)[0]
        $presentAgain = @(Get-LatexBatchJob @invoke)[0]

        $present.Id | Should -Be $presentAgain.Id
        $present.Id | Should -Not -Be $absent.Id
        $present.Metadata.JobDirectory | Should -Not -Be $absent.Metadata.JobDirectory
        $present.Metadata.PatchPath | Should -Be $patchPath
        $present.Metadata.PatchIdentity | Should -Be "sha256:$firstHash"
        $present.Parameters.ExpectedPatchIdentity | Should -Be "sha256:$firstHash"
        Test-LatexBatchPathCoveredByWrite -Path $patchPath -Write $present.Writes |
            Should -BeFalse

        [System.IO.File]::WriteAllText(
            $patchPath,
            "{`"op`":`"output_replace`",`"find`":`"x`",`"replace`":`"z`",`"expect`":1,`"reason`":`"changed`"}`n",
            [System.Text.UTF8Encoding]::new($false))
        $secondHash = (Get-FileHash -LiteralPath $patchPath -Algorithm SHA256).Hash.ToLowerInvariant()
        $changed = @(Get-LatexBatchJob @invoke)[0]
        $changed.Metadata.PatchIdentity | Should -Be "sha256:$secondHash"
        $changed.Id | Should -Not -Be $present.Id
        $changed.Metadata.JobDirectory | Should -Not -Be $present.Metadata.JobDirectory

        [System.IO.File]::WriteAllBytes($patchPath, [byte[]]::new((1MB) + 1))
        { Get-LatexBatchJob @invoke } |
            Should -Throw '*exceeds the 1048576-byte limit*'
        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -Force).Count | Should -Be 0
    }

    It 'supports a caller-selected row projection and freezes output options and child policy' {
        $fixture = New-LatexBatchFixture -Root (Join-Path $TestDrive 'projection')
        $dependency = Write-LatexBatchFixtureDependency (Join-Path $fixture.Root 'projection-ingest.ps1')
        $manifest = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot -Slug projected
        $row = [pscustomobject]@{ manifest_ref = $manifest; external_correlation = 'caller-owned' }
        $base = @(Get-LatexBatchJob -InventoryRow $row -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot -MetadataPathProperty manifest_ref `
                -LatexIngestPath $dependency)[0]
        $configured = @(Get-LatexBatchJob -InventoryRow $row -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot -MetadataPathProperty manifest_ref `
                -LatexIngestPath $dependency -BundleDeliverable -EnableEmbeddedToc `
                -DisableTreeToc -DisableJsonlToc -FaithfulNumbering -TimeoutSeconds 90 `
                -PriorityClass BelowNormal)[0]

        $configured.Id | Should -Not -Be $base.Id
        $configured.Metadata.MetadataPathProperty | Should -Be 'manifest_ref'
        [object]::ReferenceEquals($configured.Metadata.InventoryRow, $row) |
            Should -BeTrue
        $configured.Parameters.RunDir | Should -Be `
            $configured.Metadata.ApplicationRunDirectory
        $configured.Parameters.OutDir | Should -Be $configured.Metadata.OutputDirectory
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
        $fixture = New-LatexBatchFixture -Root (Join-Path $TestDrive 'dependency')
        $manifest = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot -Slug dependency
        $row = [pscustomobject]@{ metadata_path = $manifest }

        $job = @(Get-LatexBatchJob -InventoryRow $row -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot)[0]
        $job.Metadata.LatexIngestPath | Should -Be $script:LiveLatexIngest
        $job.Metadata.LatexIngestSha256 | Should -Match '^[0-9a-f]{64}$'

        $impostor = Join-Path $fixture.Root 'impostor.ps1'
        Set-Content -LiteralPath $impostor -Encoding utf8 -Value 'function Invoke-SomethingElse { }'
        { Get-LatexBatchJob -InventoryRow $row -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot -LatexIngestPath $impostor } |
            Should -Throw '*must define Invoke-ArxivLatexToMarkdown exactly once*'
    }

    It 'rejects ambiguous ownership and invalid source-ready inputs before addressing work' {
        $fixture = New-LatexBatchFixture -Root (Join-Path $TestDrive 'invalid')
        $dependency = Write-LatexBatchFixtureDependency (Join-Path $fixture.Root 'invalid-ingest.ps1')
        $valid = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot -Slug valid
        $row = [pscustomobject]@{ metadata_path = $valid }
        $missingRun = Join-Path $fixture.Root 'missing-run'
        { Get-LatexBatchJob -InventoryRow $row -RunDirectory 'relative-run' `
                -InventoryRoot $fixture.InventoryRoot -LatexIngestPath $dependency } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        { Get-LatexBatchJob -InventoryRow $row -RunDirectory $missingRun `
                -InventoryRoot $fixture.InventoryRoot -LatexIngestPath $dependency } |
            Should -Throw '*RunDirectory must be an existing absolute path*'
        Test-Path -LiteralPath $missingRun | Should -BeFalse

        { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{ wrong = $valid }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw "*has no 'metadata_path' metadata address*"
        $outside = Write-LatexBatchManifest -InventoryRoot $fixture.Root `
            -DirectoryName outside -Slug outside
        { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $outside }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*escapes InventoryRoot*'
        $notReady = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -DirectoryName not-ready -Slug not-ready -State initializing
        { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $notReady }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*requires a source-ready*'
        $unsafe = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -DirectoryName unsafe -Slug '../unsafe'
        { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $unsafe }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*slug must be one safe path leaf*'
        $portableUnsafe = @(
            @{ Directory = 'unsafe-colon'; Slug = 'bad:name' },
            @{ Directory = 'unsafe-device'; Slug = 'CON.txt' },
            @{ Directory = 'unsafe-trailing'; Slug = 'trailing.' },
            @{ Directory = 'unsafe-control'; Slug = "control$([char]0x1F)" },
            @{ Directory = 'unsafe-terminal-lf'; Slug = "terminal-lf`n" }
        )
        foreach ($case in $portableUnsafe) {
            $unsafePortable = Write-LatexBatchManifest `
                -InventoryRoot $fixture.InventoryRoot -DirectoryName $case.Directory `
                -Slug $case.Slug
            { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{
                        metadata_path = $unsafePortable
                    }) -RunDirectory $fixture.RunDirectory `
                    -InventoryRoot $fixture.InventoryRoot -LatexIngestPath $dependency } |
                Should -Throw '*slug must be one safe path leaf*'
        }
        $noTree = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -DirectoryName no-tree -Slug no-tree -OmitTree
        { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $noTree }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*exactly one LaTeX archive and source tree*'

        $incompleteArticle = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug incomplete -Article
        $incomplete = Get-Content -LiteralPath $incompleteArticle -Raw |
            ConvertFrom-Json -AsHashtable -Depth 100
        [void]$incomplete.Remove('validation')
        Set-Content -LiteralPath $incompleteArticle -Encoding utf8 `
            -Value ($incomplete | ConvertTo-Json -Depth 100)
        { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $incompleteArticle }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw "*missing required field 'validation'*"

        $misplacedArticle = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -DirectoryName wrong-location -Slug declared-slug -Article
        { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $misplacedArticle }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*canonical article location does not match slug*'

        $occupied = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug occupied
        $occupiedDirectory = Split-Path -Parent $occupied
        [void][System.IO.Directory]::CreateDirectory((Join-Path $occupiedDirectory 'article.json'))
        { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $occupiedDirectory }) `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*canonical article path is occupied by a non-file*'

        $patchOccupiedManifest = Write-LatexBatchManifest `
            -InventoryRoot $fixture.InventoryRoot -Slug patch-occupied
        $patchOccupiedPath = Join-Path (Split-Path -Parent $patchOccupiedManifest) `
            'patch-occupied-latex.patch.jsonl'
        [void][System.IO.Directory]::CreateDirectory($patchOccupiedPath)
        { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{
                    metadata_path = $patchOccupiedManifest
                }) -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency } |
            Should -Throw '*canonical patch path is occupied by a non-file*'

        $patchReparseManifest = Write-LatexBatchManifest `
            -InventoryRoot $fixture.InventoryRoot -Slug patch-reparse
        $patchReparsePath = Join-Path (Split-Path -Parent $patchReparseManifest) `
            'patch-reparse-latex.patch.jsonl'
        $patchTarget = Join-Path $fixture.Root 'patch-reparse-target'
        [void][System.IO.Directory]::CreateDirectory($patchTarget)
        $linkType = if ([System.OperatingSystem]::IsWindows()) { 'Junction' } else { 'SymbolicLink' }
        [void](New-Item -ItemType $linkType -Path $patchReparsePath `
                -Target $patchTarget -ErrorAction Stop)
        try {
            { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{
                        metadata_path = $patchReparseManifest
                    }) -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                    -LatexIngestPath $dependency } |
                Should -Throw '*canonical patch must not traverse a symbolic link or reparse point*'
        }
        finally { Remove-Item -LiteralPath $patchReparsePath -Force }

        $externalArticle = Write-LatexBatchManifest -InventoryRoot $fixture.Root `
            -DirectoryName external-article -Slug external-article -Article
        $junction = Join-Path $fixture.InventoryRoot 'junction-escape'
        $junctionCreated = $false
        try {
            [void](New-Item -ItemType Junction -Path $junction `
                    -Target (Split-Path -Parent $externalArticle) -ErrorAction Stop)
            $junctionCreated = $true
        }
        catch { $junctionCreated = $false }
        if ($junctionCreated) {
            { Get-LatexBatchJob -InventoryRow ([pscustomobject]@{ metadata_path = $junction }) `
                    -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                    -LatexIngestPath $dependency } |
                Should -Throw '*escapes InventoryRoot*'
        }

        InModuleScope adapters -Parameters @{
            ManifestPath = $valid
            InventoryRoot = $fixture.InventoryRoot
        } {
            Mock Test-PathHasReparsePoint { $false }
            Mock Get-Item {
                throw [System.UnauthorizedAccessException]::new('planned patch lookup denial')
            }
            { Resolve-LatexBatchPatchRecord -ManifestPath $ManifestPath -Slug valid `
                    -InventoryRoot $InventoryRoot } |
                Should -Throw '*planned patch lookup denial*'
        }
    }
}

Describe 'latex-batch execution integration' {
    It 'contains one document failure while preserving child correlation and declared application writes' {
        $fixture = New-LatexBatchFixture -Root (Join-Path $TestDrive 'execution')
        $dependency = Write-LatexBatchFixtureDependency (Join-Path $fixture.Root 'execution-ingest.ps1')
        $good = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug good -ArchiveBytes 100
        $broken = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug broken -ArchiveBytes 500 -TreeHash ('d' * 64)
        $rows = @(
            [pscustomobject]@{ metadata_path = $good; caller = 'good-row' }
            [pscustomobject]@{ metadata_path = $broken; caller = 'broken-row' }
        )
        $jobs = @(Get-LatexBatchJob -InventoryRow $rows -RunDirectory $fixture.RunDirectory `
                -InventoryRoot $fixture.InventoryRoot -LatexIngestPath $dependency `
                -BundleDeliverable -EnableEmbeddedToc -FaithfulNumbering `
                -ProcessEnvironment @{ CALLER_CORRELATION = 'caller-trace' } -TimeoutSeconds 30)
        foreach ($job in $jobs) {
            Test-Path -LiteralPath $job.Metadata.JobDirectory | Should -BeFalse
        }
        $compiled = InModuleScope adapters -Parameters @{
            Jobs = $jobs; BasePath = $script:RepositoryRoot
        } {
            New-BatchPlan -Job $Jobs -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0

        $execution = InModuleScope adapters -Parameters @{ Compiled = $compiled } {
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
        $output.patch_identity | Should -Be 'absent'
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
        $declaredWrites = @(foreach ($job in $jobs) { $job.Writes })
        foreach ($producedFile in @(
                Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File)) {
            Test-LatexBatchPathCoveredByWrite -Path $producedFile.FullName `
                -Write $declaredWrites | Should -BeTrue
        }
        @(Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File |
                Where-Object Name -Match '^batch-(?:job-)?results?\.(?:json|jsonl)$').Count |
            Should -Be 0
    }

    It 'contains patch appearance, content change, and deletion after planning without writes' {
        $fixture = New-LatexBatchFixture -Root (Join-Path $TestDrive 'patch-drift')
        $dependency = Write-LatexBatchFixtureDependency `
            (Join-Path $fixture.Root 'patch-drift-ingest.ps1')
        $appearance = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug patch-appeared
        $changed = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug patch-changed
        $deleted = Write-LatexBatchManifest -InventoryRoot $fixture.InventoryRoot `
            -Slug patch-deleted
        $changedPatch = Join-Path (Split-Path -Parent $changed) `
            'patch-changed-latex.patch.jsonl'
        $deletedPatch = Join-Path (Split-Path -Parent $deleted) `
            'patch-deleted-latex.patch.jsonl'
        foreach ($path in @($changedPatch, $deletedPatch)) {
            [System.IO.File]::WriteAllText(
                $path,
                "{`"op`":`"output_replace`",`"find`":`"x`",`"replace`":`"y`",`"expect`":1,`"reason`":`"planned`"}`n",
                [System.Text.UTF8Encoding]::new($false))
        }
        $rows = @(foreach ($manifestPath in @($appearance, $changed, $deleted)) {
                [pscustomobject]@{ metadata_path = $manifestPath }
            })
        $jobs = @(Get-LatexBatchJob -InventoryRow $rows `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -LatexIngestPath $dependency -TimeoutSeconds 30)

        [System.IO.File]::WriteAllText(
            (Join-Path (Split-Path -Parent $appearance) `
                'patch-appeared-latex.patch.jsonl'),
            "{`"op`":`"output_replace`",`"find`":`"x`",`"replace`":`"y`",`"expect`":1,`"reason`":`"appeared`"}`n",
            [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::WriteAllText(
            $changedPatch,
            "{`"op`":`"output_replace`",`"find`":`"x`",`"replace`":`"z`",`"expect`":1,`"reason`":`"changed`"}`n",
            [System.Text.UTF8Encoding]::new($false))
        Remove-Item -LiteralPath $deletedPatch -Force

        $compiled = InModuleScope adapters -Parameters @{
            Jobs = $jobs; BasePath = $script:RepositoryRoot
        } {
            New-BatchPlan -Job $Jobs -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0
        $execution = InModuleScope adapters -Parameters @{ Compiled = $compiled } {
            Invoke-BatchPlan -Plan $Compiled -MaxWorkers 3
        }

        @($execution.Results.State) | Should -Be @('Failed', 'Failed', 'Failed')
        foreach ($result in $execution.Results) {
            $result.Errors -join "`n" | Should -Match 'patch identity drift'
            Test-Path -LiteralPath $result.Input.Metadata.ApplicationRunDirectory |
                Should -BeFalse
            Test-Path -LiteralPath $result.Input.Metadata.OutputDirectory |
                Should -BeFalse
        }
        $execution.Summary.Failed | Should -Be 3
    }

    It 'runs the live manifest-only latex-ingest entrypoint at its declared addresses' {
        if (-not $script:MathRenderCapability.Available) {
            Set-ItResult -Skipped -Because $script:MathRenderCapability.Reason
            return
        }
        if (-not [System.IO.File]::Exists($script:PythonPath)) {
            Set-ItResult -Skipped -Because 'the repository Python environment is absent'
            return
        }
        $fixture = New-LatexBatchFixture -Root (Join-Path $TestDrive 'live-execution')
        $documentDirectory = Join-Path $fixture.InventoryRoot 'live-document'
        [void][System.IO.Directory]::CreateDirectory($documentDirectory)
        $archive = Join-Path $documentDirectory 'live-document.tar.gz'
        New-LatexBatchTestArchive -Path $archive -Files ([ordered]@{
                'main.tex' = '\documentclass{article}\begin{document}\section{Live}Adapter body.\end{document}'
            })
        $priorScratch = [System.Environment]::GetEnvironmentVariable('CODEX_JSON_SCRATCH_ROOT')
        try {
            $env:CODEX_JSON_SCRATCH_ROOT = Join-Path $TestDrive 'live-json-scratch'
            $initialized = New-LatexSourceDeposit -DocumentDir $documentDirectory `
                -Slug live-document -PythonPath $script:PythonPath
        }
        finally {
            if ($null -eq $priorScratch) {
                Remove-Item Env:CODEX_JSON_SCRATCH_ROOT -ErrorAction SilentlyContinue
            }
            else { $env:CODEX_JSON_SCRATCH_ROOT = $priorScratch }
        }
        $row = [pscustomobject]@{ metadata_path = $initialized.ManifestPath }
        $nodeDirectory = Split-Path -Parent $script:MathRenderCapability.NodePath
        $childPath = "$nodeDirectory$([System.IO.Path]::PathSeparator)$env:PATH"
        $job = @(Get-LatexBatchJob -InventoryRow $row `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -ProcessEnvironment @{ PATH = $childPath } -TimeoutSeconds 60)[0]
        $compiled = InModuleScope adapters -Parameters @{
            Job = $job; BasePath = $script:RepositoryRoot
        } {
            New-BatchPlan -Job @($Job) -BasePath $BasePath
        }
        $compiled.Errors.Count | Should -Be 0

        $execution = InModuleScope adapters -Parameters @{ Compiled = $compiled } {
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
        $declaredWrites = @($job.Writes)
        foreach ($producedFile in @(
                Get-ChildItem -LiteralPath $fixture.RunDirectory -Recurse -File)) {
            Test-LatexBatchPathCoveredByWrite -Path $producedFile.FullName `
                -Write $declaredWrites | Should -BeTrue
        }

        # Exercise the real worker/core runtime guard, not the fixture dependency used by the
        # broader appearance/change/deletion matrix above.  The target deliberately retains the
        # planned raw bytes: identity pinning alone must not make reparse traversal admissible.
        $patchPath = Join-Path $documentDirectory 'live-document-latex.patch.jsonl'
        $outsidePatchPath = Join-Path $fixture.Root 'outside-live-document-latex.patch.jsonl'
        $patchText = "{`"op`":`"source_replace`",`"find`":`"Adapter body`",`"replace`":`"Adapter body`",`"expect`":1,`"reason`":`"reparse guard probe`"}`n"
        [System.IO.File]::WriteAllText(
            $patchPath, $patchText, [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::Copy($patchPath, $outsidePatchPath)
        $reparseJob = @(Get-LatexBatchJob -InventoryRow $row `
                -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                -ProcessEnvironment @{ PATH = $childPath } -TimeoutSeconds 60)[0]
        $reparseCompiled = InModuleScope adapters -Parameters @{
            Job = $reparseJob; BasePath = $script:RepositoryRoot
        } {
            New-BatchPlan -Job @($Job) -BasePath $BasePath
        }
        $reparseCompiled.Errors.Count | Should -Be 0
        Remove-Item -LiteralPath $patchPath -Force
        $patchLinkCreated = $false
        try {
            [void](New-Item -ItemType SymbolicLink -Path $patchPath `
                    -Target $outsidePatchPath -ErrorAction Stop)
            $patchLinkCreated = $true
        }
        catch {
            Write-Warning "Skipping live file-symlink swap branch because this host cannot create a file symbolic link: $($_.Exception.Message)"
        }
        if ($patchLinkCreated) {
            try {
                $reparseExecution = InModuleScope adapters -Parameters @{
                    Compiled = $reparseCompiled
                } {
                    Invoke-BatchPlan -Plan $Compiled -MaxWorkers 1
                }
                $reparseExecution.Results[0].State | Should -Be 'Failed'
                $reparseExecution.Results[0].Errors -join "`n" |
                    Should -Match 'symbolic link or reparse point'
                Test-Path -LiteralPath $reparseJob.Metadata.ApplicationRunDirectory |
                    Should -BeFalse
                Test-Path -LiteralPath $reparseJob.Metadata.OutputDirectory |
                    Should -BeFalse
            }
            finally {
                Remove-Item -LiteralPath $patchPath -Force -ErrorAction SilentlyContinue
            }
        }

        # A legacy metadata record can remain fully valid after its slug and slug-derived source
        # addresses change.  Patch identity alone cannot detect that drift when both patch leaves
        # are absent or carry the same bytes, so exercise the independent planned-slug pin through
        # the real private worker and production resolver.
        foreach ($legacyCase in @(
                @{ Name = 'absent'; IdenticalPatches = $false },
                @{ Name = 'byte-identical'; IdenticalPatches = $true })) {
            $legacyDocumentDir = Join-Path $fixture.InventoryRoot "legacy-$($legacyCase.Name)"
            [void][System.IO.Directory]::CreateDirectory($legacyDocumentDir)
            $plannedSlug = "legacy-a-$($legacyCase.Name)"
            $runtimeSlug = "legacy-b-$($legacyCase.Name)"
            $legacyArchive = Join-Path $legacyDocumentDir "$plannedSlug.tar.gz"
            New-LatexBatchTestArchive -Path $legacyArchive -Files ([ordered]@{
                    'main.tex' = '\documentclass{article}\begin{document}Legacy body.\end{document}'
                })
            $legacyDeposit = New-LegacyMetadataSourceDeposit `
                -DocumentDir $legacyDocumentDir -Slug $plannedSlug
            if ($legacyCase.IdenticalPatches) {
                $legacyPatchBytes = [System.Text.UTF8Encoding]::new($false).GetBytes(
                    "{`"op`":`"source_replace`",`"find`":`"Legacy body`",`"replace`":`"Legacy body`",`"expect`":1,`"reason`":`"slug pin probe`"}`n")
                foreach ($slug in @($plannedSlug, $runtimeSlug)) {
                    [System.IO.File]::WriteAllBytes(
                        (Join-Path $legacyDocumentDir "$slug-latex.patch.jsonl"),
                        $legacyPatchBytes)
                }
            }

            $legacyRow = [pscustomobject]@{ metadata_path = $legacyDeposit.metadata_path }
            $legacyJob = @(Get-LatexBatchJob -InventoryRow $legacyRow `
                    -RunDirectory $fixture.RunDirectory -InventoryRoot $fixture.InventoryRoot `
                    -ProcessEnvironment @{ PATH = $childPath } -TimeoutSeconds 60)[0]
            $legacyJob.Parameters.ExpectedSlug | Should -Be $plannedSlug
            $legacyCompiled = InModuleScope adapters -Parameters @{
                Job = $legacyJob; BasePath = $script:RepositoryRoot
            } {
                New-BatchPlan -Job @($Job) -BasePath $BasePath
            }
            $legacyCompiled.Errors.Count | Should -Be 0

            $legacyManifest = Get-Content -LiteralPath $legacyDeposit.metadata_path -Raw |
                ConvertFrom-Json -AsHashtable -Depth 100
            $archiveForm = @($legacyManifest['source_forms'] |
                    Where-Object { [string]$_['role'] -eq 'latex-source-archive' })[0]
            $treeForm = @($legacyManifest['source_forms'] |
                    Where-Object { [string]$_['role'] -eq 'latex-source-tree' })[0]
            [System.IO.File]::Move(
                (Join-Path $legacyDocumentDir ([string]$archiveForm['path'])),
                (Join-Path $legacyDocumentDir "$runtimeSlug.tar.gz"))
            [System.IO.Directory]::Move(
                (Join-Path $legacyDocumentDir ([string]$treeForm['path'])),
                (Join-Path $legacyDocumentDir "$runtimeSlug-tex"))
            $legacyManifest['slug'] = $runtimeSlug
            $archiveForm['path'] = "$runtimeSlug.tar.gz"
            $treeForm['path'] = "$runtimeSlug-tex"
            $treeForm['derived_from'] = "$runtimeSlug.tar.gz"
            [System.IO.File]::WriteAllText(
                $legacyDeposit.metadata_path,
                ($legacyManifest | ConvertTo-Json -Depth 100) + "`n",
                [System.Text.UTF8Encoding]::new($false))

            $legacyExecution = InModuleScope adapters -Parameters @{
                Compiled = $legacyCompiled
            } {
                Invoke-BatchPlan -Plan $Compiled -MaxWorkers 1
            }
            $legacyExecution.Results[0].State | Should -Be 'Failed'
            $legacyExecution.Results[0].Errors -join "`n" |
                Should -Match "resolved slug '$runtimeSlug' does not match expected slug '$plannedSlug'"
            Test-Path -LiteralPath $legacyJob.Metadata.ApplicationRunDirectory |
                Should -BeFalse
            Test-Path -LiteralPath $legacyJob.Metadata.OutputDirectory |
                Should -BeFalse
        }

        $invalidArticle = Get-Content -LiteralPath $initialized.ManifestPath -Raw |
            ConvertFrom-Json -AsHashtable -Depth 100
        $invalidArticle['initialized_utc'] = 'not-a-date-time'
        Set-Content -LiteralPath $initialized.ManifestPath -Encoding utf8 `
            -Value ($invalidArticle | ConvertTo-Json -Depth 100)
        $invalidRun = Join-Path $fixture.Root 'caller-run-invalid-article'
        [void][System.IO.Directory]::CreateDirectory($invalidRun)
        $invalidJob = @(Get-LatexBatchJob -InventoryRow $row `
                -RunDirectory $invalidRun -InventoryRoot $fixture.InventoryRoot `
                -ProcessEnvironment @{ PATH = $childPath } -TimeoutSeconds 60)[0]
        $invalidCompiled = InModuleScope adapters -Parameters @{
            Job = $invalidJob; BasePath = $script:RepositoryRoot
        } {
            New-BatchPlan -Job @($Job) -BasePath $BasePath
        }
        $invalidExecution = InModuleScope adapters -Parameters @{ Compiled = $invalidCompiled } {
            Invoke-BatchPlan -Plan $Compiled -MaxWorkers 1
        }
        $invalidExecution.Results[0].State | Should -Be 'Failed'
        $invalidExecution.Results[0].Errors -join "`n" | Should -Match 'date-time'
        Test-Path -LiteralPath $invalidJob.Metadata.OutputDirectory | Should -BeFalse
    }
}
