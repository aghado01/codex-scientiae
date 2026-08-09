#requires -Version 7.0
<#
  Standalone source-deposit initialization.

  The transaction is intentionally separate from Invoke-ArxivLatexToMarkdown. It normalizes and validates
  deposited source material, publishes the stable {slug}-tex tree, and writes metadata.json last. The
  manifest is therefore a success sentinel: its presence means the source deposit reached source-ready.
#>

. "$PSScriptRoot/latex-source.ps1"

function Resolve-SourceDepositScopedPath {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string]$DocumentDir
    )
    $candidate = if ([System.IO.Path]::IsPathRooted($Path)) {
        $Path
    } else {
        Join-Path $DocumentDir $Path
    }
    return (Resolve-Path -LiteralPath $candidate -ErrorAction Stop).Path
}

function Read-SourceDepositJson {
    param([Parameter(Mandatory)] [string]$Path)
    $strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
    try {
        $json = [System.IO.File]::ReadAllText($Path, $strictUtf8)
    } catch [System.Text.DecoderFallbackException] {
        throw "JSON file is not valid UTF-8: '$Path'"
    }
    try {
        $document = [System.Text.Json.JsonDocument]::Parse($json)
        $document.Dispose()
        return ($json | ConvertFrom-Json -AsHashtable -Depth 100)
    } catch {
        throw "invalid JSON file '$Path': $($_.Exception.Message)"
    }
}

function Get-SourceDepositFileRecord {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string]$Root,
        [Parameter(Mandatory)] [string]$Role,
        [Parameter(Mandatory)] [string]$Format
    )
    $item = Get-Item -LiteralPath $Path -ErrorAction Stop
    if (-not (Test-LatexPathWithinRoot -Path $item.FullName -Root $Root)) {
        throw "file record path is outside its declared root: '$($item.FullName)'"
    }
    return [ordered]@{
        role   = $Role
        path   = [System.IO.Path]::GetRelativePath($Root, $item.FullName).Replace('\', '/')
        format = $Format
        bytes  = [long]$item.Length
        sha256 = (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    }
}

function Resolve-SourceDepositArchive {
    param(
        [Parameter(Mandatory)] [string]$DocumentDir,
        [Parameter(Mandatory)] [string]$Slug,
        [string]$ArchivePath = ''
    )
    $canonical = Join-Path $DocumentDir "$Slug.tar.gz"
    $alias = Join-Path $DocumentDir "arXiv-$Slug.tar.gz"
    if ($ArchivePath) {
        $selected = Resolve-SourceDepositScopedPath -Path $ArchivePath -DocumentDir $DocumentDir
        if (-not (Test-LatexPathWithinRoot -Path $selected -Root $DocumentDir) -or
            (Test-PathHasReparsePoint -Path $selected) -or
            -not [System.IO.File]::Exists($selected)) {
            throw "source archive must be a file inside the document directory: '$ArchivePath'"
        }
        $leaf = Split-Path -Leaf $selected
        if ($leaf -cnotin @("$Slug.tar.gz", "arXiv-$Slug.tar.gz")) {
            throw "source archive must be named '$Slug.tar.gz' or 'arXiv-$Slug.tar.gz', not '$leaf'"
        }
        return $selected
    }
    $found = @(@($canonical, $alias) | Where-Object { [System.IO.File]::Exists($_) })
    if ($found.Count -eq 0) {
        throw "no source archive found; expected '$Slug.tar.gz' or 'arXiv-$Slug.tar.gz' in '$DocumentDir'"
    }
    if ($found.Count -gt 1) {
        throw "both canonical and alias source archives exist; refusing to choose between '$canonical' and '$alias'"
    }
    $selected = [System.IO.Path]::GetFullPath($found[0])
    if (Test-PathHasReparsePoint -Path $selected) {
        throw "source archive must not traverse a symbolic link or reparse point: '$selected'"
    }
    return $selected
}

function Resolve-SourceDepositProviderMetadata {
    param(
        [Parameter(Mandatory)] [string]$DocumentDir,
        [Parameter(Mandatory)] [string]$Slug,
        [string]$ProviderMetadataPath = ''
    )
    if ($ProviderMetadataPath) {
        $selected = Resolve-SourceDepositScopedPath -Path $ProviderMetadataPath -DocumentDir $DocumentDir
        if (-not (Test-LatexPathWithinRoot -Path $selected -Root $DocumentDir) -or
            (Test-PathHasReparsePoint -Path $selected) -or
            -not [System.IO.File]::Exists($selected)) {
            throw "provider metadata must be a file inside the document directory: '$ProviderMetadataPath'"
        }
        return $selected
    }
    $candidate = Join-Path $DocumentDir "$Slug.arxiv.json"
    if (Test-PathHasReparsePoint -Path $candidate) {
        throw "provider metadata must not traverse a symbolic link or reparse point: '$candidate'"
    }
    if ([System.IO.File]::Exists($candidate)) { return [System.IO.Path]::GetFullPath($candidate) }
    return $null
}

if ($null -eq $script:SourceDepositHeldLocks) {
    $script:SourceDepositHeldLocks =
        [System.Collections.Concurrent.ConcurrentDictionary[string, byte]]::new(
            [System.StringComparer]::Ordinal)
}

function Enter-SourceDepositLock {
    param([Parameter(Mandatory)] [string]$DocumentDir, [int]$TimeoutSeconds = 15)
    $canonical = [System.IO.Path]::GetFullPath($DocumentDir)
    if ([System.OperatingSystem]::IsWindows()) { $canonical = $canonical.ToUpperInvariant() }
    $digest = [System.Convert]::ToHexString(
        [System.Security.Cryptography.SHA256]::HashData(
            [System.Text.UTF8Encoding]::new($false).GetBytes($canonical)
        )
    ).ToLowerInvariant()
    $name = "codex-scientiae-source-deposit-$($digest.Substring(0, 32))"
    if (-not $script:SourceDepositHeldLocks.TryAdd($name, [byte]0)) {
        throw "timed out waiting for the source-deposit lock: '$canonical'"
    }

    $mutex = $null
    $acquired = $false
    try {
        $mutex = [System.Threading.Mutex]::new($false, $name)
        try {
            $acquired = $mutex.WaitOne([TimeSpan]::FromSeconds([math]::Max(0, $TimeoutSeconds)))
        }
        catch [System.Threading.AbandonedMutexException] {
            # The prior owner died while holding the mutex; this caller now owns it.
            $acquired = $true
        }
        if (-not $acquired) {
            throw "timed out waiting for the source-deposit lock: '$canonical'"
        }
        return [pscustomobject]@{ name = $name; mutex = $mutex }
    }
    catch {
        if ($mutex) { $mutex.Dispose() }
        [byte]$removed = 0
        [void]$script:SourceDepositHeldLocks.TryRemove($name, [ref]$removed)
        throw
    }
}

function Exit-SourceDepositLock {
    param([object]$Lock)
    if (-not $Lock) { return }
    try { $Lock.mutex.ReleaseMutex() }
    finally {
        $Lock.mutex.Dispose()
        [byte]$removed = 0
        [void]$script:SourceDepositHeldLocks.TryRemove([string]$Lock.name, [ref]$removed)
    }
}

function Write-SourceDepositManifest {
    param(
        [Parameter(Mandatory)] [System.Collections.IDictionary]$Manifest,
        [Parameter(Mandatory)] [string]$Path
    )
    if (Test-Path -LiteralPath $Path) { throw "metadata sentinel already exists; refusing to overwrite: '$Path'" }
    $parent = Split-Path -Parent $Path
    $temp = Join-Path $parent ".metadata.$([guid]::NewGuid().ToString('N')).tmp"
    try {
        $json = (ConvertTo-Json -InputObject $Manifest -Depth 20) + "`n"
        $bytes = [System.Text.UTF8Encoding]::new($false, $true).GetBytes($json)
        $stream = [System.IO.FileStream]::new(
            $temp,
            [System.IO.FileMode]::CreateNew,
            [System.IO.FileAccess]::Write,
            [System.IO.FileShare]::None
        )
        try {
            $stream.Write($bytes, 0, $bytes.Length)
            $stream.Flush($true)
        } finally {
            $stream.Dispose()
        }
        [System.IO.File]::Move($temp, $Path, $false)
    } finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Force }
    }
}

function Test-ExistingSourceDeposit {
    param(
        [Parameter(Mandatory)] [System.Collections.IDictionary]$Manifest,
        [Parameter(Mandatory)] [string]$ManifestPath,
        [Parameter(Mandatory)] [string]$DocumentDir,
        [Parameter(Mandatory)] [string]$Slug
    )
    $isArticle = [string]$Manifest.schema -eq 'codex-scientiae/article/0.1'
    if ([string]$Manifest.schema -notin @(
            'codex-scientiae/article/0.1',
            'codex-scientiae/document-metadata/0.1'
        ) -or
        [string]$Manifest.state -ne 'source-ready' -or
        [string]$Manifest.slug -ne $Slug) {
        throw "existing deposit manifest is not source-ready for '$Slug': '$ManifestPath'"
    }
    if ($isArticle) {
        if (-not [string]::Equals(
                [System.IO.Path]::GetFileName($ManifestPath),
                'article.json',
                [System.StringComparison]::Ordinal) -or
            -not [string]::Equals(
                (Split-Path -Leaf (Split-Path -Parent $ManifestPath)),
                $Slug,
                [System.StringComparison]::Ordinal)) {
            throw "canonical article location does not match slug '$Slug': '$ManifestPath'"
        }
        foreach ($required in @(
                'initialized_utc', 'title', 'authors', 'abstract', 'identifiers', 'categories',
                'evidence', 'source_forms', 'validation')) {
            if (-not $Manifest.Contains($required)) {
                throw "canonical article is missing required field '$required': '$ManifestPath'"
            }
        }
    }
    $archiveForm = @($Manifest.source_forms | Where-Object { $_.role -eq 'latex-source-archive' })
    $treeForm = @($Manifest.source_forms | Where-Object { $_.role -eq 'latex-source-tree' })
    if ($archiveForm.Count -ne 1 -or $treeForm.Count -ne 1) {
        throw "existing metadata.json does not declare exactly one LaTeX archive and source tree: '$ManifestPath'"
    }
    $archivePath = [System.IO.Path]::GetFullPath((Join-Path $DocumentDir ([string]$archiveForm[0].path)))
    $treePath = [System.IO.Path]::GetFullPath((Join-Path $DocumentDir ([string]$treeForm[0].path)))
    if (-not (Test-LatexPathWithinRoot -Path $archivePath -Root $DocumentDir) -or
        -not (Test-LatexPathWithinRoot -Path $treePath -Root $DocumentDir) -or
        (Test-PathHasReparsePoint -Path $archivePath) -or
        (Test-PathHasReparsePoint -Path $treePath) -or
        -not [System.IO.File]::Exists($archivePath) -or
        -not [System.IO.Directory]::Exists($treePath)) {
        throw "existing metadata.json points to missing or out-of-root source material: '$ManifestPath'"
    }
    $archiveHash = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($archiveHash -ne [string]$archiveForm[0].sha256) {
        throw "source archive no longer matches metadata.json: '$archivePath'"
    }
    $treeHash = (Get-LatexSourceTreeFingerprint -RootPath $treePath).sha256
    if ($treeHash -ne [string]$treeForm[0].sha256) {
        throw "source tree no longer matches metadata.json: '$treePath'"
    }
    return [pscustomobject]@{
        status        = 'already-initialized'
        metadata_path = $ManifestPath
        archive_path  = $archivePath
        source_path   = $treePath
        manifest      = $Manifest
    }
}

function Initialize-LatexSourceDeposit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$DocumentDir,
        [string]$Slug = '',
        [string]$ArchivePath = '',
        [string]$ProviderMetadataPath = '',
        [string]$MainTex = '',
        [long]$MaxExpandedBytes = 4GB,
        [int]$MaxEntries = 100000,
        [int]$LockTimeoutSeconds = 15
    )
    $documentRoot = (Resolve-Path -LiteralPath $DocumentDir -ErrorAction Stop).Path
    if (-not [System.IO.Directory]::Exists($documentRoot)) {
        throw "document deposit is not a directory: '$documentRoot'"
    }
    if (Test-PathHasReparsePoint -Path $documentRoot) {
        throw "document deposit must not traverse a symbolic link or reparse point: '$documentRoot'"
    }
    if (-not $Slug) { $Slug = Split-Path -Leaf $documentRoot }
    if ([string]::IsNullOrWhiteSpace($Slug) -or $Slug -in @('.', '..') -or
        (Split-Path -Leaf $Slug) -ne $Slug -or $Slug.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
        throw "slug must be one safe directory-leaf name: '$Slug'"
    }

    $lock = $null
    $candidate = $null
    try {
        $lock = Enter-SourceDepositLock -DocumentDir $documentRoot -TimeoutSeconds $LockTimeoutSeconds
        $manifestPath = Join-Path $documentRoot 'metadata.json'
        if ([System.IO.File]::Exists($manifestPath)) {
            $existing = Read-SourceDepositJson -Path $manifestPath
            return Test-ExistingSourceDeposit -Manifest $existing -ManifestPath $manifestPath `
                -DocumentDir $documentRoot -Slug $Slug
        }

        $archive = Resolve-SourceDepositArchive -DocumentDir $documentRoot -Slug $Slug -ArchivePath $ArchivePath
        $providerPath = Resolve-SourceDepositProviderMetadata -DocumentDir $documentRoot -Slug $Slug `
            -ProviderMetadataPath $ProviderMetadataPath
        $provider = $null
        $providerRecord = $null
        if ($providerPath) {
            $provider = Read-SourceDepositJson -Path $providerPath
            if ($provider.idv -and [string]$provider.idv -ne $Slug) {
                throw "provider metadata idv '$($provider.idv)' does not match deposit slug '$Slug'"
            }
            $providerRecord = Get-SourceDepositFileRecord -Path $providerPath -Root $documentRoot `
                -Role 'provider-metadata' -Format 'application/json'
            $providerRecord.provider = 'arxiv'
            $providerRecord.fetched_at = $provider.fetched_at
            $providerRecord.fetched_by = $provider.fetched_by
        }

        $pdfPath = Join-Path $documentRoot "$Slug.pdf"
        if (Test-PathHasReparsePoint -Path $pdfPath) {
            throw "PDF source must not traverse a symbolic link or reparse point: '$pdfPath'"
        }

        $nonce = [guid]::NewGuid().ToString('N')
        $candidate = Join-Path $documentRoot ".$Slug-tex.validate-$nonce"
        $expansion = Expand-LatexSourceArchive -ArchivePath $archive -DestinationPath $candidate `
            -MaxExpandedBytes $MaxExpandedBytes -MaxEntries $MaxEntries
        $candidateValidation = Test-LatexSourceTree -RootPath $candidate -Slug $Slug -MainTex $MainTex

        $canonicalArchive = Join-Path $documentRoot "$Slug.tar.gz"
        if (-not (Test-LatexPathsEqual -Left $archive -Right $canonicalArchive)) {
            if ([System.IO.File]::Exists($canonicalArchive)) {
                throw "canonical archive appeared during initialization; refusing to overwrite: '$canonicalArchive'"
            }
            [System.IO.File]::Move($archive, $canonicalArchive, $false)
            $archive = $canonicalArchive
        }

        $sourcePath = Join-Path $documentRoot "$Slug-tex"
        if ([System.IO.Directory]::Exists($sourcePath)) {
            $existingValidation = Test-LatexSourceTree -RootPath $sourcePath -Slug $Slug -MainTex $MainTex
            if ($existingValidation.tree_sha256 -ne $candidateValidation.tree_sha256) {
                throw "existing source tree differs from the validated archive; refusing to overwrite: '$sourcePath'"
            }
            Remove-LatexPrivatePath -Path $candidate -ExpectedParent $documentRoot
            $candidate = $null
            $validation = $existingValidation
            $publication = 'recovered-existing-tree'
        } else {
            [System.IO.Directory]::Move($candidate, $sourcePath)
            $candidate = $null
            $validation = $candidateValidation
            $publication = 'published-new-tree'
        }

        $archiveRecord = Get-SourceDepositFileRecord -Path $archive -Root $documentRoot `
            -Role 'latex-source-archive' -Format 'application/gzip'
        $archiveRecord.archive_kind = $expansion.archive_kind
        $treeRecord = [ordered]@{
            role                 = 'latex-source-tree'
            path                 = [System.IO.Path]::GetRelativePath($documentRoot, $sourcePath).Replace('\', '/')
            format               = 'application/x-latex-source-tree'
            derived_from         = $archiveRecord.path
            entrypoint           = $validation.entrypoint
            entrypoint_selection = $validation.entrypoint_selection
            files                = $validation.file_count
            tex_files            = $validation.tex_file_count
            sha256               = $validation.tree_sha256
        }

        $sourceForms = [System.Collections.Generic.List[object]]::new()
        $sourceForms.Add($archiveRecord)
        $sourceForms.Add($treeRecord)
        if ([System.IO.File]::Exists($pdfPath)) {
            $sourceForms.Add((Get-SourceDepositFileRecord -Path $pdfPath -Root $documentRoot `
                        -Role 'pdf-source' -Format 'application/pdf'))
        }

        $providerEvidence = @()
        if ($providerRecord) { $providerEvidence = @($providerRecord) }
        $document = [ordered]@{
            title            = $null
            authors          = @()
            abstract         = $null
            identifiers      = [ordered]@{
                arxiv           = $null
                arxiv_versioned = $null
                doi             = $null
            }
            categories       = @()
            primary_category = $null
            published        = $null
            updated          = $null
        }
        if ($provider) {
            $document.title = $provider.title
            $document.authors = @($provider.authors)
            $document.abstract = $provider.abstract
            $document.identifiers.arxiv = $provider.id
            $document.identifiers.arxiv_versioned = $provider.idv
            $document.identifiers.doi = $provider.doi
            $document.categories = @($provider.categories)
            $document.primary_category = $provider.primary_category
            $document.published = $provider.published
            $document.updated = $provider.updated
        }
        $manifest = [ordered]@{
            schema          = 'codex-scientiae/document-metadata/0.1'
            state           = 'source-ready'
            slug            = $Slug
            initialized_utc = [DateTime]::UtcNow.ToString('o')
            document        = $document
            evidence        = [ordered]@{
                provider_metadata    = $providerEvidence
                latex_source         = [ordered]@{
                    entrypoint = $treeRecord.entrypoint
                    selection  = $treeRecord.entrypoint_selection
                    declarations = $validation.embedded_metadata
                }
                package_control_files = @($validation.package_control_files)
            }
            source_forms    = $sourceForms.ToArray()
            validation      = [ordered]@{
                status          = 'valid'
                validated_utc   = [DateTime]::UtcNow.ToString('o')
                publication     = $publication
                checks          = @(
                    'gzip-readable',
                    'archive-members-confined',
                    'no-links-or-reparse-points',
                    'tex-valid-utf8',
                    'entrypoint-unambiguous',
                    'literal-inputs-resolved',
                    'document-environment-present'
                )
            }
        }
        Write-SourceDepositManifest -Manifest $manifest -Path $manifestPath
        return [pscustomobject]@{
            status        = 'initialized'
            metadata_path = $manifestPath
            archive_path  = $archive
            source_path   = $sourcePath
            manifest      = $manifest
        }
    } finally {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            Remove-LatexPrivatePath -Path $candidate -ExpectedParent $documentRoot
        }
        Exit-SourceDepositLock -Lock $lock
    }
}
