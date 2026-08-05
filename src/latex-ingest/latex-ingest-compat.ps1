#requires -Version 7.0
<#
  Compatibility surface for pre-metadata latex-ingest callers.

  Production code imports latex-ingest.ps1 and calls Invoke-ArxivLatexToMarkdown with metadata.json.
  This file alone owns archive/slug inference, `{slug}-latex`, `-ReuseSource`, arbitrary source-work
  overrides, and the retired helper names. Default archive-backed use standardizes the leaf through
  Initialize-LatexSourceDeposit before handing control to the production entrypoint.
#>

. "$PSScriptRoot/latex-ingest.ps1"

function Expand-ArxivSourceTarball {
    param([string]$TarGz, [string]$WorkDir)
    return (Expand-LatexSourceArchive -ArchivePath $TarGz -DestinationPath $WorkDir).destination_path
}

function Find-LatexMain {
    param([string]$Dir, [string]$Slug = '', [string]$MainTex = '')
    return (Get-LatexSourceEntrypoint -RootPath $Dir -Slug $Slug -MainTex $MainTex).path
}

function Resolve-LatexInputs {
    param([string]$MainPath, [int]$Depth = 0)
    $remainingDepth = [Math]::Max(1, 32 - $Depth)
    return Resolve-LatexSourceInputs -MainPath $MainPath -MaxDepth $remainingDepth -UnresolvedInputAction Keep
}

function Get-LegacyLatexSourceWorkDir {
    param([Parameter(Mandatory)] [string]$ArchivePath, [Parameter(Mandatory)] [string]$Slug)
    return Join-Path (Split-Path -Parent $ArchivePath) "$Slug-latex"
}

function Test-LegacyLatexSourceAvailable {
    param([Parameter(Mandatory)] [string]$Path)
    return [System.IO.Directory]::Exists($Path) -and
        @(Get-ChildItem -LiteralPath $Path -Recurse -File -Filter '*.tex' -ErrorAction SilentlyContinue).Count -gt 0
}

function Resolve-LegacyLatexSource {
    param(
        [Parameter(Mandatory)] [string]$RequestedArchivePath,
        [Parameter(Mandatory)] [string]$Slug,
        [string]$SourceWorkDir = ''
    )
    if ($SourceWorkDir) {
        $path = [System.IO.Path]::GetFullPath($SourceWorkDir)
        if (Test-Path -LiteralPath $path) {
            if (-not (Test-LegacyLatexSourceAvailable -Path $path)) {
                throw "legacy source override exists but contains no LaTeX source: '$path'"
            }
            return [pscustomobject]@{ path = $path; available = $true; mode = 'compat-explicit-reused' }
        }
        return [pscustomobject]@{ path = $path; available = $false; mode = 'compat-explicit-new' }
    }

    $current = Get-SourceWorkDir -ArchivePath $RequestedArchivePath -Slug $Slug
    $legacy = Get-LegacyLatexSourceWorkDir -ArchivePath $RequestedArchivePath -Slug $Slug
    $currentReady = Test-LegacyLatexSourceAvailable -Path $current
    $legacyReady = Test-LegacyLatexSourceAvailable -Path $legacy
    if ($currentReady) {
        if (Test-Path -LiteralPath $legacy) {
            Write-Warning "compat: both '$Slug-tex' and '$Slug-latex' exist; using '$current'"
        }
        return [pscustomobject]@{ path = $current; available = $true; mode = 'compat-current-reused' }
    }
    if ($legacyReady) {
        Write-Warning "compat: using unmanifested legacy source '$legacy'"
        return [pscustomobject]@{ path = $legacy; available = $true; mode = 'compat-legacy-reused' }
    }
    return [pscustomobject]@{ path = $current; available = $false; mode = 'compat-current-new' }
}

function Invoke-LegacyLatexResolvedSource {
    param(
        [Parameter(Mandatory)] [string]$Slug,
        [Parameter(Mandatory)] [string]$SourcePath,
        [string]$MainTex = '',
        [Parameter(Mandatory)] [string]$OutDir,
        [string]$DeliverableDir,
        [string]$RunDir = '',
        [string]$ArtifactsRoot = '',
        [string]$SourceMode = 'compat-unverified',
        [switch]$EnableEmbeddedToc,
        [switch]$DisableTreeToc,
        [switch]$DisableJsonlToc,
        [switch]$FaithfulNumbering
    )
    $entrypoint = Get-LatexSourceEntrypoint -RootPath $SourcePath -Slug $Slug -MainTex $MainTex
    return Invoke-LatexIngestResolvedSource `
        -Slug $Slug `
        -SourcePath $SourcePath `
        -MainPath $entrypoint.path `
        -UnresolvedInputAction Keep `
        -SourceMode $SourceMode `
        -OutDir $OutDir `
        -DeliverableDir $DeliverableDir `
        -RunDir $RunDir `
        -ArtifactsRoot $ArtifactsRoot `
        -EnableEmbeddedToc:$EnableEmbeddedToc `
        -DisableTreeToc:$DisableTreeToc `
        -DisableJsonlToc:$DisableJsonlToc `
        -FaithfulNumbering:$FaithfulNumbering
}

function Invoke-ArxivLatexToMarkdownLegacy {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$TarGz,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$Slug,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$OutDir,
        [string]$DeliverableDir,
        [switch]$ReuseSource,
        [string]$SourceWorkDir = '',
        [string]$MainTex = '',
        [string]$RunDir = '',
        [string]$ArtifactsRoot = '',
        [switch]$EnableEmbeddedToc,
        [switch]$DisableTreeToc,
        [switch]$DisableJsonlToc,
        [switch]$FaithfulNumbering
    )
    $requestedArchive = [System.IO.Path]::GetFullPath($TarGz)
    $documentDir = Split-Path -Parent $requestedArchive
    $manifestPath = Join-Path $documentDir 'metadata.json'

    # Once a deposit is initialized, metadata.json is authoritative even if an old alias supplied by a
    # caller was normalized away. Explicit source-work overrides remain a compatibility escape hatch.
    if ([System.IO.File]::Exists($manifestPath) -and -not $SourceWorkDir) {
        $manifest = Read-SourceDepositJson -Path $manifestPath
        if ([string]$manifest.slug -ne $Slug) {
            throw "compat: requested slug '$Slug' disagrees with metadata.json slug '$($manifest.slug)'"
        }
        if ($MainTex) { Write-Warning 'compat: -MainTex is ignored because metadata.json owns the validated entrypoint' }
        return Invoke-ArxivLatexToMarkdown `
            -MetadataPath $manifestPath -OutDir $OutDir -DeliverableDir $DeliverableDir `
            -RunDir $RunDir -ArtifactsRoot $ArtifactsRoot `
            -EnableEmbeddedToc:$EnableEmbeddedToc -DisableTreeToc:$DisableTreeToc `
            -DisableJsonlToc:$DisableJsonlToc -FaithfulNumbering:$FaithfulNumbering
    }

    $legacySource = Resolve-LegacyLatexSource -RequestedArchivePath $requestedArchive `
        -Slug $Slug -SourceWorkDir $SourceWorkDir
    if ($legacySource.available -and ($ReuseSource -or $SourceWorkDir)) {
        Write-Warning "compat: bypassing metadata initialization for '$($legacySource.path)'"
        return Invoke-LegacyLatexResolvedSource `
            -Slug $Slug -SourcePath $legacySource.path -MainTex $MainTex -SourceMode $legacySource.mode `
            -OutDir $OutDir -DeliverableDir $DeliverableDir -RunDir $RunDir -ArtifactsRoot $ArtifactsRoot `
            -EnableEmbeddedToc:$EnableEmbeddedToc -DisableTreeToc:$DisableTreeToc `
            -DisableJsonlToc:$DisableJsonlToc -FaithfulNumbering:$FaithfulNumbering
    }

    if ($SourceWorkDir) {
        if (-not [System.IO.File]::Exists($requestedArchive)) {
            throw "compat: LaTeX source archive not found: '$requestedArchive'"
        }
        Write-Warning "compat: extracting to explicit unmanifested source override '$($legacySource.path)'"
        Expand-LatexSourceArchive -ArchivePath $requestedArchive -DestinationPath $legacySource.path | Out-Null
        return Invoke-LegacyLatexResolvedSource `
            -Slug $Slug -SourcePath $legacySource.path -MainTex $MainTex -SourceMode 'compat-explicit-extracted' `
            -OutDir $OutDir -DeliverableDir $DeliverableDir -RunDir $RunDir -ArtifactsRoot $ArtifactsRoot `
            -EnableEmbeddedToc:$EnableEmbeddedToc -DisableTreeToc:$DisableTreeToc `
            -DisableJsonlToc:$DisableJsonlToc -FaithfulNumbering:$FaithfulNumbering
    }

    if (-not [System.IO.File]::Exists($requestedArchive)) {
        throw "compat: LaTeX source archive not found and no initialized metadata.json exists: '$requestedArchive'"
    }
    if (Test-LegacyLatexSourceAvailable (Get-LegacyLatexSourceWorkDir $requestedArchive $Slug)) {
        Write-Warning "compat: legacy '$Slug-latex' remains untouched; initialization will publish '$Slug-tex' from the archive"
    }
    $initialized = Initialize-LatexSourceDeposit -DocumentDir $documentDir -Slug $Slug `
        -ArchivePath $requestedArchive -MainTex $MainTex
    return Invoke-ArxivLatexToMarkdown `
        -MetadataPath $initialized.metadata_path -OutDir $OutDir -DeliverableDir $DeliverableDir `
        -RunDir $RunDir -ArtifactsRoot $ArtifactsRoot `
        -EnableEmbeddedToc:$EnableEmbeddedToc -DisableTreeToc:$DisableTreeToc `
        -DisableJsonlToc:$DisableJsonlToc -FaithfulNumbering:$FaithfulNumbering
}
