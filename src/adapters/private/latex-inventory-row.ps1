function Get-LatexBatchPropertyValue {
    param(
        [Parameter(Mandatory)] [object] $InputObject,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Name
    )

    if ($InputObject -is [System.Collections.IDictionary]) {
        foreach ($key in @($InputObject.Keys)) {
            if ([string]$key -ieq $Name) { return $InputObject[$key] }
        }
        return $null
    }
    foreach ($property in @($InputObject.PSObject.Properties)) {
        if ($property.Name -ieq $Name) { return $property.Value }
    }
    return $null
}

function Test-LatexBatchPathHasReparsePoint {
    param([Parameter(Mandatory)] [string] $Path)

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $pathRoot = [System.IO.Path]::GetPathRoot($fullPath)
    $relative = [System.IO.Path]::GetRelativePath($pathRoot, $fullPath)
    $current = $pathRoot
    foreach ($segment in @($relative -split '[\\/]' | Where-Object { $_ -and $_ -ne '.' })) {
        $current = [System.IO.Path]::Combine($current, $segment)
        $item = Get-Item -LiteralPath $current -Force -ErrorAction SilentlyContinue
        if ($null -eq $item) { break }
        if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
            return $true
        }
    }
    return $false
}

function Resolve-LatexBatchRepositoryRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($RepositoryRoot)) {
        [System.IO.Path]::GetFullPath($RepositoryRoot)
    }
    else { [System.IO.Path]::GetFullPath($RepositoryRoot, (Get-Location).Path) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "latex-batch repository root not found: '$RepositoryRoot'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-LatexBatchInventoryRoot {
    [CmdletBinding()]
    param(
        [string] $InventoryRoot,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $candidate = if ([string]::IsNullOrWhiteSpace($InventoryRoot)) {
        $RepositoryRoot
    }
    elseif ([System.IO.Path]::IsPathFullyQualified($InventoryRoot)) {
        [System.IO.Path]::GetFullPath($InventoryRoot)
    }
    else { [System.IO.Path]::GetFullPath($InventoryRoot, $RepositoryRoot) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "latex-batch inventory root not found: '$InventoryRoot'"
    }
    $resolved = (Resolve-Path -LiteralPath $candidate).Path
    if (Test-LatexBatchPathHasReparsePoint -Path $resolved) {
        throw "latex-batch InventoryRoot must not traverse a symbolic link or reparse point: '$resolved'"
    }
    return $resolved
}

function Resolve-LatexBatchRunDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory
    )

    if (-not [System.IO.Path]::IsPathFullyQualified($RunDirectory)) {
        throw "latex-batch RunDirectory must be an existing absolute path: '$RunDirectory'"
    }
    $candidate = [System.IO.Path]::GetFullPath($RunDirectory)
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "latex-batch RunDirectory must be an existing absolute path: '$RunDirectory'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Test-LatexBatchPathWithinRoot {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $Root
    )

    $relative = [System.IO.Path]::GetRelativePath($Root, $Path)
    if ([System.IO.Path]::IsPathFullyQualified($relative) -or $relative -eq '..') { return $false }
    foreach ($separator in @(
            [System.IO.Path]::DirectorySeparatorChar,
            [System.IO.Path]::AltDirectorySeparatorChar)) {
        if ($relative.StartsWith("..$separator", [System.StringComparison]::Ordinal)) { return $false }
    }
    return $true
}

function Resolve-LatexBatchManifestPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [object] $InventoryRow,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $MetadataPathProperty,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $InventoryRoot
    )

    $value = if ($InventoryRow -is [string]) {
        $InventoryRow
    }
    else { Get-LatexBatchPropertyValue -InputObject $InventoryRow -Name $MetadataPathProperty }
    if ([string]::IsNullOrWhiteSpace([string]$value)) {
        throw "latex-batch inventory row has no '$MetadataPathProperty' metadata address"
    }

    $candidate = if ([System.IO.Path]::IsPathFullyQualified([string]$value)) {
        [System.IO.Path]::GetFullPath([string]$value)
    }
    else { [System.IO.Path]::GetFullPath([string]$value, $InventoryRoot) }
    if ([System.IO.Directory]::Exists($candidate)) {
        $articleCandidate = [System.IO.Path]::Combine($candidate, 'article.json')
        $articleEntry = Get-Item -LiteralPath $articleCandidate -Force -ErrorAction SilentlyContinue
        $candidate = if ([System.IO.File]::Exists($articleCandidate)) {
            $articleCandidate
        }
        elseif ($null -ne $articleEntry) {
            throw "latex-batch canonical article path is occupied by a non-file: '$articleCandidate'"
        }
        else { [System.IO.Path]::Combine($candidate, 'metadata.json') }
    }
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "latex-batch metadata.json not found: '$value'"
    }
    $resolved = (Resolve-Path -LiteralPath $candidate).Path
    if ((Test-LatexBatchPathHasReparsePoint -Path $resolved) -or
        -not (Test-LatexBatchPathWithinRoot -Path $resolved -Root $InventoryRoot)) {
        throw "latex-batch metadata address escapes InventoryRoot: '$value'"
    }
    return $resolved
}

function Read-LatexBatchManifestRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [object] $InventoryRow,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $MetadataPathProperty,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $InventoryRoot
    )

    $manifestPath = Resolve-LatexBatchManifestPath -InventoryRow $InventoryRow `
        -MetadataPathProperty $MetadataPathProperty -InventoryRoot $InventoryRoot
    try {
        $utf8 = [System.Text.UTF8Encoding]::new($false, $true)
        $manifest = [System.IO.File]::ReadAllText($manifestPath, $utf8) |
            ConvertFrom-Json -AsHashtable -Depth 100 -ErrorAction Stop
    }
    catch { throw "latex-batch metadata.json is invalid: '$manifestPath': $($_.Exception.Message)" }
    if ($manifest -isnot [System.Collections.IDictionary] -or
        [string]$manifest['schema'] -notin @(
            'codex-scientiae/article/0.1',
            'codex-scientiae/document-metadata/0.1'
        ) -or
        [string]$manifest['state'] -ne 'source-ready') {
        throw "latex-batch requires a source-ready article manifest: '$manifestPath'"
    }

    $slug = [string]$manifest['slug']
    if ([string]::IsNullOrWhiteSpace($slug) -or $slug -in @('.', '..') -or
        $slug.Contains('/') -or $slug.Contains('\') -or
        (Split-Path -Leaf $slug) -ne $slug -or
        $slug.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
        throw "latex-batch manifest slug must be one safe path leaf: '$slug'"
    }

    $isArticle = [string]$manifest['schema'] -eq 'codex-scientiae/article/0.1'
    if ($isArticle) {
        if (-not [string]::Equals(
                [System.IO.Path]::GetFileName($manifestPath),
                'article.json',
                [System.StringComparison]::Ordinal) -or
            -not [string]::Equals(
                (Split-Path -Leaf (Split-Path -Parent $manifestPath)),
                $slug,
                [System.StringComparison]::Ordinal)) {
            throw "latex-batch canonical article location does not match slug '$slug': '$manifestPath'"
        }
        foreach ($required in @(
                'initialized_utc', 'title', 'authors', 'abstract', 'identifiers', 'categories',
                'evidence', 'source_forms', 'validation')) {
            if (-not $manifest.Contains($required)) {
                throw "latex-batch canonical article is missing required field '$required': '$manifestPath'"
            }
        }
    }
    elseif ([string]::Equals(
            [System.IO.Path]::GetFileName($manifestPath),
            'article.json',
            [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "latex-batch canonical article path does not contain an article/0.1 record: '$manifestPath'"
    }

    $sourceForms = @($manifest['source_forms'])
    $archiveForms = @($sourceForms | Where-Object { [string]$_['role'] -eq 'latex-source-archive' })
    $treeForms = @($sourceForms | Where-Object { [string]$_['role'] -eq 'latex-source-tree' })
    if ($archiveForms.Count -ne 1 -or $treeForms.Count -ne 1) {
        throw "latex-batch manifest must declare exactly one LaTeX archive and source tree: '$manifestPath'"
    }
    $treeHash = [string]$treeForms[0]['sha256']
    $archiveHash = [string]$archiveForms[0]['sha256']
    if ($treeHash -notmatch '^[0-9a-f]{64}$' -or $archiveHash -notmatch '^[0-9a-f]{64}$' -or
        [string]::IsNullOrWhiteSpace([string]$treeForms[0]['entrypoint'])) {
        throw "latex-batch manifest has an invalid LaTeX source identity: '$manifestPath'"
    }

    $cost = [double](Get-Item -LiteralPath $manifestPath).Length
    if ($archiveForms[0].Contains('bytes')) {
        try { $cost = [double]$archiveForms[0]['bytes'] }
        catch { throw "latex-batch manifest archive byte count is invalid: '$manifestPath'" }
    }
    elseif ($treeForms[0].Contains('files')) {
        try { $cost = [double]$treeForms[0]['files'] }
        catch { throw "latex-batch manifest source file count is invalid: '$manifestPath'" }
    }
    if ([double]::IsNaN($cost) -or [double]::IsInfinity($cost) -or $cost -lt 0) {
        throw "latex-batch manifest cost hint is invalid: '$manifestPath'"
    }

    return [pscustomobject]@{
        InventoryRow = $InventoryRow
        Manifest = $manifest
        ManifestPath = $manifestPath
        RelativeManifestPath = [System.IO.Path]::GetRelativePath(
            $InventoryRoot, $manifestPath).Replace('\', '/')
        Slug = $slug
        SourceTreeSha256 = $treeHash
        SourceArchiveSha256 = $archiveHash
        EstimatedCost = [math]::Max(1, $cost)
    }
}
