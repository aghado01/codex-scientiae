function Get-IngestBatchPropertyValue {
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

function Resolve-IngestBatchRepositoryRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($RepositoryRoot)) {
        [System.IO.Path]::GetFullPath($RepositoryRoot)
    }
    else { [System.IO.Path]::GetFullPath($RepositoryRoot, (Get-Location).Path) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "ingest-batch repository root not found: '$RepositoryRoot'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-IngestBatchInventoryRoot {
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
        throw "ingest-batch inventory root not found: '$InventoryRoot'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-IngestBatchRunDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory
    )

    if (-not [System.IO.Path]::IsPathFullyQualified($RunDirectory)) {
        throw "ingest-batch RunDirectory must be an existing absolute path: '$RunDirectory'"
    }
    $candidate = [System.IO.Path]::GetFullPath($RunDirectory)
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "ingest-batch RunDirectory must be an existing absolute path: '$RunDirectory'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Test-IngestBatchPathWithinRoot {
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

function Resolve-IngestBatchManifestPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [object] $InventoryRow,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $MetadataPathProperty,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $InventoryRoot
    )

    $value = if ($InventoryRow -is [string]) {
        $InventoryRow
    }
    else { Get-IngestBatchPropertyValue -InputObject $InventoryRow -Name $MetadataPathProperty }
    if ([string]::IsNullOrWhiteSpace([string]$value)) {
        throw "ingest-batch inventory row has no '$MetadataPathProperty' metadata address"
    }

    $candidate = if ([System.IO.Path]::IsPathFullyQualified([string]$value)) {
        [System.IO.Path]::GetFullPath([string]$value)
    }
    else { [System.IO.Path]::GetFullPath([string]$value, $InventoryRoot) }
    if ([System.IO.Directory]::Exists($candidate)) {
        $candidate = [System.IO.Path]::Combine($candidate, 'metadata.json')
    }
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "ingest-batch metadata.json not found: '$value'"
    }
    $resolved = (Resolve-Path -LiteralPath $candidate).Path
    if (-not (Test-IngestBatchPathWithinRoot -Path $resolved -Root $InventoryRoot)) {
        throw "ingest-batch metadata address escapes InventoryRoot: '$value'"
    }
    return $resolved
}

function Read-IngestBatchManifestRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [object] $InventoryRow,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $MetadataPathProperty,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $InventoryRoot
    )

    $manifestPath = Resolve-IngestBatchManifestPath -InventoryRow $InventoryRow `
        -MetadataPathProperty $MetadataPathProperty -InventoryRoot $InventoryRoot
    try {
        $utf8 = [System.Text.UTF8Encoding]::new($false, $true)
        $manifest = [System.IO.File]::ReadAllText($manifestPath, $utf8) |
            ConvertFrom-Json -AsHashtable -Depth 100 -ErrorAction Stop
    }
    catch { throw "ingest-batch metadata.json is invalid: '$manifestPath': $($_.Exception.Message)" }
    if ($manifest -isnot [System.Collections.IDictionary] -or
        [string]$manifest['schema'] -ne 'codex-scientiae/document-metadata/0.1' -or
        [string]$manifest['state'] -ne 'source-ready') {
        throw "ingest-batch requires a source-ready document-metadata/0.1 manifest: '$manifestPath'"
    }

    $slug = [string]$manifest['slug']
    if ([string]::IsNullOrWhiteSpace($slug) -or $slug -in @('.', '..') -or
        $slug.Contains('/') -or $slug.Contains('\') -or
        (Split-Path -Leaf $slug) -ne $slug -or
        $slug.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
        throw "ingest-batch manifest slug must be one safe path leaf: '$slug'"
    }

    $sourceForms = @($manifest['source_forms'])
    $archiveForms = @($sourceForms | Where-Object { [string]$_['role'] -eq 'latex-source-archive' })
    $treeForms = @($sourceForms | Where-Object { [string]$_['role'] -eq 'latex-source-tree' })
    if ($archiveForms.Count -ne 1 -or $treeForms.Count -ne 1) {
        throw "ingest-batch manifest must declare exactly one LaTeX archive and source tree: '$manifestPath'"
    }
    $treeHash = [string]$treeForms[0]['sha256']
    $archiveHash = [string]$archiveForms[0]['sha256']
    if ($treeHash -notmatch '^[0-9a-f]{64}$' -or $archiveHash -notmatch '^[0-9a-f]{64}$' -or
        [string]::IsNullOrWhiteSpace([string]$treeForms[0]['entrypoint'])) {
        throw "ingest-batch manifest has an invalid LaTeX source identity: '$manifestPath'"
    }

    $cost = [double](Get-Item -LiteralPath $manifestPath).Length
    if ($archiveForms[0].Contains('bytes')) {
        try { $cost = [double]$archiveForms[0]['bytes'] }
        catch { throw "ingest-batch manifest archive byte count is invalid: '$manifestPath'" }
    }
    elseif ($treeForms[0].Contains('files')) {
        try { $cost = [double]$treeForms[0]['files'] }
        catch { throw "ingest-batch manifest source file count is invalid: '$manifestPath'" }
    }
    if ([double]::IsNaN($cost) -or [double]::IsInfinity($cost) -or $cost -lt 0) {
        throw "ingest-batch manifest cost hint is invalid: '$manifestPath'"
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
