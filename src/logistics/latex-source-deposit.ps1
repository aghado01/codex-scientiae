#requires -Version 7.0
<#
  Source-deposit orchestration across the PowerShell/Python boundary.

  PowerShell owns archive extraction, source confinement, entrypoint resolution, LaTeX declaration
  parsing, tree fingerprinting, and the witnessed probe ledger. The JSONL engine owns file facts,
  provider projection, article-schema validation, and immutable publication of article.json.

  Publish-LatexSourceTree returns the scalar/path boundary payload. New-LatexSourceDeposit supplies
  a finalizer so the document lock remains held through the Python publication step. The older
  source-deposit.ps1 currently supplies shared extraction-address and lock primitives.
#>

. "$PSScriptRoot/probe-ledger.ps1"
. "$PSScriptRoot/../latex-ingest/source-deposit.ps1"
Import-Module (Join-Path $PSScriptRoot '../jsonl_engine-client/jsonl_engine-client.psd1') `
    -ErrorAction Stop

# The probe set this transaction is accountable for. Adding a probe to the code without adding it
# here fails Assert-ProbeCoverage, and so does the reverse — an entry no code path backs.
$script:DepositProbes = @(
    'gzip-readable',
    'archive-members-confined',
    'no-links-or-reparse-points',
    'tex-valid-utf8',
    'entrypoint-unambiguous',
    'literal-inputs-resolved',
    'document-environment-present'
)

function New-DepositProbeLedger {
    <#
    .SYNOPSIS
        Record what the transaction actually established about this deposit.
    .DESCRIPTION
        Built once, from the authoritative validation — Test-LatexSourceTree runs twice in the
        recovery path (candidate and existing tree) and the ledger describes the tree that was
        published, not both attempts.

        Every entry here corresponds to a guard that already threw on failure. Recording happens on
        the success side; this never converts a throw into a result.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]$Expansion,
        [Parameter(Mandatory)]$Validation
    )

    $ledger = [ProbeLedger]::new()
    $kind = [string]$Expansion.archive_kind

    # Both branches decompress before anything else; a non-gzip stream throws in Expand-LatexSourceArchive.
    $ledger.Record('gzip-readable', 'passed', @{ archive_kind = $kind })

    # Member confinement is a property of the tar path only. The single-TeX gzip shape expands one
    # payload — there are no members, so there is nothing to confine and nothing to claim.
    if ($kind -eq 'tar+gzip') {
        $ledger.Record('archive-members-confined', 'passed', @{ entries = $Expansion.archive_entries })
    } else {
        $ledger.Record('archive-members-confined', 'not-applicable', @{
            reason       = 'single-payload gzip archive has no members to confine'
            archive_kind = $kind
        })
    }

    # Scanned on the extraction destination and again across the published tree.
    $ledger.Record('no-links-or-reparse-points', 'passed', @{ files = $Validation.file_count })

    # Read-LatexSourceText decodes every .tex under the root with a throwing UTF-8 decoder.
    $ledger.Record('tex-valid-utf8', 'passed', @{ tex_files = $Validation.tex_file_count })

    # 'explicit' means -MainTex named the entrypoint and Get-LatexSourceEntrypoint returned before
    # the candidate scan. Nothing established that the tree was unambiguous — an operator decided.
    $selection = [string]$Validation.entrypoint_selection
    if ($selection -eq 'explicit') {
        $ledger.Record('entrypoint-unambiguous', 'not-applicable', @{
            reason     = 'entrypoint named explicitly; the ambiguity scan did not run'
            selection  = $selection
            entrypoint = [string]$Validation.entrypoint
        })
    } else {
        $ledger.Record('entrypoint-unambiguous', 'passed', @{
            selection  = $selection
            entrypoint = [string]$Validation.entrypoint
        })
    }

    # Test-LatexSourceTree calls Resolve-LatexSourceInputs without -UnresolvedInputAction, so the
    # Stop default applies and an unresolved \input aborts. Recorded with the mode that was in force
    # so a future tolerant caller cannot inherit this claim.
    $ledger.Record('literal-inputs-resolved', 'passed', @{ unresolved_input_action = 'Stop' })

    # \begin{document} in the fully resolved text, not in the entrypoint file alone.
    $ledger.Record('document-environment-present', 'passed', @{ basis = 'resolved-input-text' })

    $ledger.AssertCoverage($script:DepositProbes)
    return $ledger
}

function Publish-LatexSourceTree {
    <#
    .SYNOPSIS
        Run the source-deposit transaction and return the engine boundary payload.
    .DESCRIPTION
        Lock, resolve the archive and optional provider metadata, extract privately, validate, then
        either publish the validated tree or recover an existing one whose fingerprint matches.
        The private extraction is removed on every exit path.

        Returns paths relative to the document directory and scalars only. When the internal
        FinalizePublication callback is supplied, it runs after source publication and before the
        document lock is released; New-LatexSourceDeposit uses that point to publish article.json.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$DocumentDir,
        [string]$Slug = '',
        [string]$ArchivePath = '',
        [string]$ProviderMetadataPath = '',
        [string]$MainTex = '',
        [long]$MaxExpandedBytes = 4GB,
        [int]$MaxEntries = 100000,
        [int]$LockTimeoutSeconds = 15,
        [Parameter(DontShow)][scriptblock]$FinalizePublication
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
        (Split-Path -Leaf $Slug) -ne $Slug -or
        $Slug.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
        throw "slug must be one safe directory-leaf name: '$Slug'"
    }

    $relative = {
        param([string]$Path)
        if (-not $Path) { return $null }
        return [System.IO.Path]::GetRelativePath($documentRoot, $Path).Replace('\', '/')
    }

    $lock = $null
    $candidate = $null
    try {
        $lock = Enter-SourceDepositLock -DocumentDir $documentRoot -TimeoutSeconds $LockTimeoutSeconds

        $archive = Resolve-SourceDepositArchive -DocumentDir $documentRoot -Slug $Slug -ArchivePath $ArchivePath
        $providerPath = Resolve-SourceDepositProviderMetadata -DocumentDir $documentRoot -Slug $Slug `
            -ProviderMetadataPath $ProviderMetadataPath
        if ($providerPath) {
            # The one provider fact PowerShell must check: a metadata file for a different version
            # would otherwise be projected into this deposit's manifest by the engine.
            $provider = Read-SourceDepositJson -Path $providerPath
            if ($provider.idv -and [string]$provider.idv -ne $Slug) {
                throw "provider metadata idv '$($provider.idv)' does not match deposit slug '$Slug'"
            }
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

        $ledger = New-DepositProbeLedger -Expansion $expansion -Validation $validation

        $facts = [pscustomobject]@{
            Skipped             = $false
            DocumentDir         = $documentRoot
            Slug                = $Slug
            Archive             = (& $relative $archive)
            ArchiveKind         = [string]$expansion.archive_kind
            Tree                = (& $relative $sourcePath)
            TreeSha256          = [string]$validation.tree_sha256
            Files               = [int]$validation.file_count
            TexFiles            = [int]$validation.tex_file_count
            Entrypoint          = [string]$validation.entrypoint
            EntrypointSelection = [string]$validation.entrypoint_selection
            ProviderJson        = (& $relative $providerPath)
            Pdf                 = $(if ([System.IO.File]::Exists($pdfPath)) { (& $relative $pdfPath) } else { $null })
            Publication         = $publication
            Findings            = [pscustomobject]@{
                checks                = $ledger.Results()
                declarations          = $validation.embedded_metadata
                package_control_files = @($validation.package_control_files)
            }
        }
        if ($FinalizePublication) {
            return & $FinalizePublication $facts
        }
        return $facts
    } finally {
        try {
            if ($candidate -and [System.IO.Directory]::Exists($candidate)) {
                Remove-LatexPrivatePath -Path $candidate -ExpectedParent $documentRoot
            }
        }
        finally {
            Exit-SourceDepositLock -Lock $lock
        }
    }
}

function New-LatexSourceDeposit {
    <#
    .SYNOPSIS
        Publish the source tree, then have the engine write the manifest.
    .DESCRIPTION
        The probe results, parsed declarations, and package-control records cross in one staged JSON
        document. Scalar facts and document-relative artifact paths cross as arguments. The source
        transaction lock remains held until the engine has created or validated article.json.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$DocumentDir,
        [string]$Slug = '',
        [string]$ArchivePath = '',
        [string]$ProviderMetadataPath = '',
        [string]$MainTex = '',
        [string]$FindingsPath = '',
        [switch]$KeepFindings,
        [string]$PythonPath = '',
        [ValidateRange(1, 3600)][int]$EngineTimeoutSeconds = 300,
        [long]$MaxExpandedBytes = 4GB,
        [int]$MaxEntries = 100000,
        [int]$LockTimeoutSeconds = 15
    )

    $documentRootForFindings = (Resolve-Path -LiteralPath $DocumentDir -ErrorAction Stop).Path
    $testReparsePath = ${function:Test-PathHasReparsePoint}
    $assertSafeFindingsPath = {
        param([Parameter(Mandatory)] [string]$Path)

        $findingsFull = [System.IO.Path]::GetFullPath($Path)
        $pathComparison = if ([System.OperatingSystem]::IsWindows()) {
            [System.StringComparison]::OrdinalIgnoreCase
        }
        else { [System.StringComparison]::Ordinal }
        $documentPrefix = $documentRootForFindings.TrimEnd(
            [System.IO.Path]::DirectorySeparatorChar,
            [System.IO.Path]::AltDirectorySeparatorChar
        ) + [System.IO.Path]::DirectorySeparatorChar
        if ([string]::Equals($findingsFull, $documentRootForFindings, $pathComparison) -or
            $findingsFull.StartsWith($documentPrefix, $pathComparison)) {
            throw "FindingsPath must be outside the document deposit: '$findingsFull'"
        }
        if (& $testReparsePath -Path $findingsFull) {
            throw "FindingsPath must not traverse a symbolic link or reparse point: '$findingsFull'"
        }
        return $findingsFull
    }.GetNewClosure()

    if ($FindingsPath) {
        $findingsFull = if ([System.IO.Path]::IsPathFullyQualified($FindingsPath)) {
            [System.IO.Path]::GetFullPath($FindingsPath)
        }
        else {
            [System.IO.Path]::GetFullPath($FindingsPath, (Get-Location).Path)
        }
        # Freeze caller-relative resolution before the transaction enters its callback.
        $FindingsPath = & $assertSafeFindingsPath $findingsFull
    }

    $finalize = {
        param($facts)

        $inputFileArguments = @{ InputObject = $facts.Findings }
        if ($FindingsPath) {
            $inputFileArguments.Path = $FindingsPath
        }
        $findingsInput = jsonl_engine-client\New-JsonlEngineInputFile @inputFileArguments
        $findingsFile = $findingsInput.Path
        try {
            try { [void](& $assertSafeFindingsPath $findingsFile) }
            catch {
                # Staging used create-only publication, so an unsafe file present here was created
                # by this call even when the caller supplied its name.
                if ([System.IO.File]::Exists($findingsFile)) {
                    [System.IO.File]::Delete($findingsFile)
                }
                throw
            }
            $argument = [System.Collections.Generic.List[string]]::new()
            $argument.Add('--document-dir');         $argument.Add($facts.DocumentDir)
            $argument.Add('--slug');                 $argument.Add($facts.Slug)
            $argument.Add('--archive');              $argument.Add($facts.Archive)
            $argument.Add('--archive-kind');         $argument.Add($facts.ArchiveKind)
            $argument.Add('--tree');                 $argument.Add($facts.Tree)
            $argument.Add('--tree-sha256');          $argument.Add($facts.TreeSha256)
            $argument.Add('--files');                $argument.Add([string]$facts.Files)
            $argument.Add('--tex-files');            $argument.Add([string]$facts.TexFiles)
            $argument.Add('--entrypoint');           $argument.Add($facts.Entrypoint)
            $argument.Add('--entrypoint-selection'); $argument.Add($facts.EntrypointSelection)
            $argument.Add('--publication');          $argument.Add($facts.Publication)
            $argument.Add('--findings-json');        $argument.Add($findingsFile)
            if ($facts.ProviderJson) {
                $argument.Add('--provider-json'); $argument.Add($facts.ProviderJson)
            }
            if ($facts.Pdf) { $argument.Add('--pdf'); $argument.Add($facts.Pdf) }

            $frames = @(jsonl-engine-client\Invoke-JsonlEngineCommand -Verb 'deposit' `
                    -Argument $argument.ToArray() -PythonPath $PythonPath `
                    -TimeoutSeconds $EngineTimeoutSeconds)
            if ($frames.Count -ne 1) {
                throw "jsonl engine verb 'deposit' returned $($frames.Count) values; expected exactly one"
            }
            $engineOutput = $frames[0].value
            $expectedArticle = [System.IO.Path]::GetFullPath((Join-Path $facts.DocumentDir 'article.json'))
            $returnedArticle = [System.IO.Path]::GetFullPath([string]$engineOutput.article_path)
            $pathComparison = if ([System.OperatingSystem]::IsWindows()) {
                [System.StringComparison]::OrdinalIgnoreCase
            }
            else { [System.StringComparison]::Ordinal }
            if (-not $engineOutput -or -not $engineOutput.article -or
                [string]$engineOutput.article.slug -ne [string]$facts.Slug -or
                -not [string]::Equals($returnedArticle, $expectedArticle, $pathComparison)) {
                throw "jsonl engine verb 'deposit' returned an article outside the requested deposit"
            }
            return [pscustomobject]@{
                Skipped      = -not [bool]$engineOutput.created
                Status       = [string]$engineOutput.status
                DocumentDir  = $facts.DocumentDir
                Slug         = $facts.Slug
                Publication  = [string]$engineOutput.article.validation.publication
                ManifestPath = [string]$engineOutput.article_path
                EngineOutput = $engineOutput
            }
        } finally {
            if (-not $KeepFindings -and $findingsInput.IsTemporary -and
                [System.IO.File]::Exists($findingsFile)) {
                [System.IO.File]::Delete($findingsFile)
            }
        }
    }.GetNewClosure()

    return Publish-LatexSourceTree -DocumentDir $DocumentDir -Slug $Slug `
        -ArchivePath $ArchivePath -ProviderMetadataPath $ProviderMetadataPath -MainTex $MainTex `
        -MaxExpandedBytes $MaxExpandedBytes -MaxEntries $MaxEntries `
        -LockTimeoutSeconds $LockTimeoutSeconds -FinalizePublication $finalize
}
