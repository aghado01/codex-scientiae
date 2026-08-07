#requires -Version 7.0
<#
  src/logistics/latex-source-deposit.ps1 — source deposit, split at the engine boundary.

  A rewrite of Initialize-LatexSourceDeposit against two changes, not a refactor of it. The
  original stays untouched and operational until this path can regenerate what it produces.

  WHAT CHANGED — 1. WITNESSED CHECKS. The original asserted a hardcoded array of seven check names
  at manifest-assembly time. Three of them are conditional on source shape and two were wrong for
  real inputs:

    archive-members-confined  member confinement lives in the tar path. arXiv's single-TeX gzip
                              shape takes a different branch with no members to confine, and the
                              manifest claimed the check anyway.
    entrypoint-unambiguous    with -MainTex the ambiguity scan never runs; an operator resolved it.
                              The manifest could not distinguish that from no ambiguity existing.
    literal-inputs-resolved   true today only because Resolve-LatexSourceInputs defaults to Stop.
                              Keep/Drop exist in the API and would make the constant lie silently.

  Probes now report through a ledger (see probe-ledger.ps1) with passed / not-applicable / waived,
  and Assert-ProbeCoverage refuses a set that has drifted from the code in either direction.

  WHAT CHANGED — 2. THE MANIFEST IS NOT WRITTEN HERE. Ownership follows the invariant: PowerShell
  owns source truth (extraction, confinement, entrypoint resolution, declaration parsing), the
  engine owns artifact truth (assembly, schema conformance, atomic publish, refuse-overwrite).
  So this file stops at the boundary and hands over paths and scalars.

  Everything the original computed that is a pure file fact — sha256, byte size, format, relative
  path, the whole provider-derived `document` block — is deliberately NOT computed here. Those
  belong to whoever writes the manifest, and PowerShell producing hashes for an artifact it does
  not own is the split in the wrong place.

  TWO ENTRY POINTS. Publish-LatexSourceTree runs the transaction and returns the boundary payload;
  it is complete and testable today. New-LatexSourceDeposit adds the engine call and will fail
  until `python -m jsonl_engine deposit` exists.

  DEPENDENCIES. probe-ledger.ps1 and engine-call.ps1 are generic infrastructure. latex-source.ps1
  supplies the LaTeX primitives, which are lane-specific and unchanged. source-deposit.ps1 is
  dot-sourced only for its lock and resolve helpers (Enter/Exit-SourceDepositLock,
  Resolve-SourceDepositArchive, Resolve-SourceDepositProviderMetadata, Read-SourceDepositJson);
  those are transaction plumbing that moves here when the original retires.
#>

. "$PSScriptRoot/probe-ledger.ps1"
. "$PSScriptRoot/engine-call.ps1"
. "$PSScriptRoot/../latex-ingest/source-deposit.ps1"

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

        Returns paths relative to the document directory and scalars only — no hashes of deposited
        files, no provider projection. Those are the engine's to compute.

        An existing metadata.json short-circuits: the deposit is already source-ready and its tree
        must not be re-extracted. Validating that sentinel is the engine's job, so this reports the
        skip rather than re-implementing schema checks in PowerShell.
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
        [int]$LockTimeoutSeconds = 15
    )

    $documentRoot = (Resolve-Path -LiteralPath $DocumentDir -ErrorAction Stop).Path
    if (-not [System.IO.Directory]::Exists($documentRoot)) {
        throw "document deposit is not a directory: '$documentRoot'"
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

        $manifestPath = Join-Path $documentRoot 'metadata.json'
        if ([System.IO.File]::Exists($manifestPath)) {
            return [pscustomobject]@{
                Skipped      = $true
                Reason       = 'metadata sentinel already present; deposit is source-ready'
                DocumentDir  = $documentRoot
                Slug         = $Slug
                ManifestPath = $manifestPath
            }
        }

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
        $pdfPath = Join-Path $documentRoot "$Slug.pdf"

        return [pscustomobject]@{
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
    } finally {
        if ($candidate -and [System.IO.Directory]::Exists($candidate)) {
            Remove-LatexPrivatePath -Path $candidate -ExpectedParent $documentRoot
        }
        Exit-SourceDepositLock -Lock $lock
    }
}

function New-LatexSourceDeposit {
    <#
    .SYNOPSIS
        Publish the source tree, then have the engine write the manifest.
    .DESCRIPTION
        The structured half of the payload — probe results, parsed declarations, package-control
        records — crosses as a file. Everything else is a scalar or a relative path, which is what
        keeps the argument vector bounded and the invocation reproducible by hand.

        PENDING: `python -m jsonl_engine deposit` does not exist yet. Until it lands this throws at
        the engine call with the exact command it attempted; Publish-LatexSourceTree alone is the
        testable path.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$DocumentDir,
        [string]$Slug = '',
        [string]$ArchivePath = '',
        [string]$ProviderMetadataPath = '',
        [string]$MainTex = '',
        [string]$FindingsPath = '',
        [switch]$KeepFindings
    )

    $facts = Publish-LatexSourceTree -DocumentDir $DocumentDir -Slug $Slug -ArchivePath $ArchivePath `
        -ProviderMetadataPath $ProviderMetadataPath -MainTex $MainTex
    if ($facts.Skipped) { return $facts }

    $findingsFile = Write-EngineFindings -Findings $facts.Findings -Path $FindingsPath
    try {
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
        if ($facts.ProviderJson) { $argument.Add('--provider-json'); $argument.Add($facts.ProviderJson) }
        if ($facts.Pdf) { $argument.Add('--pdf'); $argument.Add($facts.Pdf) }

        $stdout = Invoke-JsonlEngine -Verb 'deposit' -Argument $argument.ToArray()
        return [pscustomobject]@{
            Skipped      = $false
            DocumentDir  = $facts.DocumentDir
            Slug         = $facts.Slug
            Publication  = $facts.Publication
            ManifestPath = (Join-Path $facts.DocumentDir 'metadata.json')
            EngineOutput = $stdout
        }
    } finally {
        if (-not $KeepFindings -and -not $FindingsPath -and [System.IO.File]::Exists($findingsFile)) {
            [System.IO.File]::Delete($findingsFile)
        }
    }
}
