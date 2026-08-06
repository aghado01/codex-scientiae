#requires -Version 7.0
<#
  Localized source-deposit inventory materialization for the latex-ingest development workflow.

  A catalog is a deterministic materialized view, not another source of truth. Version 0.1 indexes only
  direct child document deposits of the selected root. A missing metadata.json is not a document; an
  invalid sentinel aborts the whole materialization. This script never initializes or repairs a deposit.

  The private whole-file codec is deliberately bounded while the replacement shared JSONL substrate is
  still unintegrated: strict UTF-8 without BOM, LF-only records, atomic sibling publication, and explicit
  replacement. Incremental mutation, persistent indexes, multi-writer coordination, and recursive catalog
  reconciliation remain infrastructure work.
#>

$script:LatexInventoryCatalogRepositoryRoot = [System.IO.Path]::GetFullPath(
    (Join-Path $PSScriptRoot '../..'))
$script:LatexInventoryManifestSchemaPath = [System.IO.Path]::Combine(
    $script:LatexInventoryCatalogRepositoryRoot, 'ingestion', 'inventory', 'metadata.schema.json')
$script:LatexInventoryRowSchemaPath = [System.IO.Path]::Combine(
    $script:LatexInventoryCatalogRepositoryRoot, 'ingestion', 'inventory', 'inventory-row.schema.json')
$script:LatexInventoryUtf8 = [System.Text.UTF8Encoding]::new($false, $true)

foreach ($schemaPath in @(
        $script:LatexInventoryManifestSchemaPath,
        $script:LatexInventoryRowSchemaPath)) {
    if (-not [System.IO.File]::Exists($schemaPath)) {
        throw "latex inventory schema not found: '$schemaPath'"
    }
}

function Test-LatexInventoryPathWithinRoot {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $Root
    )

    $relative = [System.IO.Path]::GetRelativePath($Root, $Path)
    if ([System.IO.Path]::IsPathFullyQualified($relative) -or $relative -eq '..') { return $false }
    return $relative -notmatch '^\.\.(?:[\\/]|$)'
}

function Assert-LatexInventoryScopedPath {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $Field,
        [switch] $DirectChild
    )

    if ([string]::IsNullOrWhiteSpace($Path) -or
        [System.IO.Path]::IsPathFullyQualified($Path) -or
        $Path.StartsWith('/') -or $Path.Contains('\')) {
        throw "latex inventory '$Field' must be a forward-slash relative path: '$Path'"
    }
    if (-not $Path.IsNormalized([System.Text.NormalizationForm]::FormC)) {
        throw "latex inventory '$Field' must use Unicode NFC: '$Path'"
    }
    $segments = $Path.Split('/', [System.StringSplitOptions]::None)
    if ($DirectChild -and $segments.Count -ne 1) {
        throw "latex inventory '$Field' must name one direct child of the catalog root: '$Path'"
    }
    foreach ($segment in $segments) {
        if ([string]::IsNullOrEmpty($segment) -or $segment -in @('.', '..')) {
            throw "latex inventory '$Field' contains an empty or traversal segment: '$Path'"
        }
        foreach ($character in $segment.ToCharArray()) {
            if ([char]::IsControl($character)) {
                throw "latex inventory '$Field' contains a control character: '$Path'"
            }
        }
    }
    return $Path
}

function Resolve-LatexInventoryRoot {
    param([Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $InventoryRoot)

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($InventoryRoot)) {
        [System.IO.Path]::GetFullPath($InventoryRoot)
    }
    else { [System.IO.Path]::GetFullPath($InventoryRoot, (Get-Location).Path) }
    if (-not [System.IO.Directory]::Exists($candidate)) {
        throw "latex inventory root not found: '$InventoryRoot'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-LatexInventoryCatalogPath {
    param([Parameter(Mandatory)] [string] $InventoryRoot)

    return [System.IO.Path]::Combine($InventoryRoot, 'inventory.jsonl')
}

function Get-LatexInventoryFileSha256 {
    param([Parameter(Mandatory)] [string] $Path)

    $stream = [System.IO.File]::OpenRead($Path)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { return [System.Convert]::ToHexString($sha.ComputeHash($stream)).ToLowerInvariant() }
    finally { $sha.Dispose(); $stream.Dispose() }
}

function Read-LatexInventoryJsonObject {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $SchemaPath,
        [Parameter(Mandatory)] [string] $Role
    )

    try { $text = [System.IO.File]::ReadAllText($Path, $script:LatexInventoryUtf8) }
    catch { throw "latex inventory $Role is not strict UTF-8: '$Path': $($_.Exception.Message)" }
    try { $valid = $text | Test-Json -SchemaFile $SchemaPath -ErrorAction Stop }
    catch { throw "latex inventory $Role failed schema validation: '$Path': $($_.Exception.Message)" }
    if (-not $valid) { throw "latex inventory $Role failed schema validation: '$Path'" }
    try { $record = $text | ConvertFrom-Json -AsHashtable -Depth 100 -ErrorAction Stop }
    catch { throw "latex inventory $Role is invalid JSON: '$Path': $($_.Exception.Message)" }
    if ($record -isnot [System.Collections.IDictionary]) {
        throw "latex inventory $Role must be one JSON object: '$Path'"
    }
    return $record
}

function ConvertTo-LatexInventoryRow {
    param(
        [Parameter(Mandatory)] [string] $InventoryRoot,
        [Parameter(Mandatory)] [string] $DocumentDirectory
    )

    $documentParent = [System.IO.Path]::GetRelativePath(
        $InventoryRoot, $DocumentDirectory).Replace('\', '/')
    $documentParent = Assert-LatexInventoryScopedPath -Path $documentParent `
        -Field document_parent -DirectChild
    $manifestPath = [System.IO.Path]::Combine($DocumentDirectory, 'metadata.json')
    $manifest = Read-LatexInventoryJsonObject -Path $manifestPath `
        -SchemaPath $script:LatexInventoryManifestSchemaPath -Role 'metadata sentinel'
    $slug = [string]$manifest['slug']
    if (-not $slug.Equals($documentParent, [System.StringComparison]::Ordinal)) {
        throw "latex inventory metadata slug '$slug' does not match its direct parent '$documentParent': '$manifestPath'"
    }

    return [ordered]@{
        schema          = 'codex-scientiae/document-inventory-row/0.1'
        document_parent = $documentParent
        metadata_path   = "$documentParent/metadata.json"
        metadata_sha256 = Get-LatexInventoryFileSha256 -Path $manifestPath
        manifest_schema = [string]$manifest['schema']
        state           = [string]$manifest['state']
        slug            = $slug
        document        = $manifest['document']
    }
}

function ConvertTo-LatexInventoryJsonLine {
    param([Parameter(Mandatory)] [System.Collections.IDictionary] $Record)

    $line = ConvertTo-Json -InputObject $Record -Compress -Depth 32 -WarningAction Stop
    [void]$script:LatexInventoryUtf8.GetByteCount($line)
    try { $valid = $line | Test-Json -SchemaFile $script:LatexInventoryRowSchemaPath -ErrorAction Stop }
    catch { throw "latex inventory row failed schema validation: $($_.Exception.Message)" }
    if (-not $valid) { throw 'latex inventory row failed schema validation' }
    return $line
}

function Write-LatexInventoryCatalogFile {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [AllowEmptyCollection()] [string[]] $Line,
        [Parameter(Mandatory)] [ValidateSet('Fail', 'Replace')] [string] $ExistingFile
    )

    if ($ExistingFile -eq 'Fail' -and [System.IO.File]::Exists($Path)) {
        throw "latex inventory catalog already exists: '$Path'"
    }
    $directory = [System.IO.Path]::GetDirectoryName($Path)
    $leaf = [System.IO.Path]::GetFileName($Path)
    $temp = [System.IO.Path]::Combine(
        $directory, ".$leaf.$([guid]::NewGuid().ToString('N')).tmp")
    try {
        $stream = [System.IO.FileStream]::new(
            $temp,
            [System.IO.FileMode]::CreateNew,
            [System.IO.FileAccess]::Write,
            [System.IO.FileShare]::None)
        $writer = [System.IO.StreamWriter]::new($stream, $script:LatexInventoryUtf8)
        try {
            foreach ($recordLine in $Line) {
                $writer.Write($recordLine)
                $writer.Write("`n")
            }
            $writer.Flush()
            $stream.Flush($true)
        }
        finally { $writer.Dispose() }
        [System.IO.File]::Move($temp, $Path, ($ExistingFile -eq 'Replace'))
    }
    finally {
        if ([System.IO.File]::Exists($temp)) { [System.IO.File]::Delete($temp) }
    }
}

function Write-LatexInventoryCatalog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()] [string] $InventoryRoot,
        [ValidateSet('Fail', 'Replace')] [string] $ExistingFile = 'Fail'
    )

    $root = Resolve-LatexInventoryRoot -InventoryRoot $InventoryRoot
    $catalogPath = Resolve-LatexInventoryCatalogPath -InventoryRoot $root
    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($documentDirectory in [System.IO.Directory]::EnumerateDirectories($root)) {
        $manifestPath = [System.IO.Path]::Combine($documentDirectory, 'metadata.json')
        if (-not [System.IO.File]::Exists($manifestPath)) { continue }
        $rows.Add((ConvertTo-LatexInventoryRow -InventoryRoot $root `
                -DocumentDirectory $documentDirectory))
    }

    $rowArray = [object[]]$rows.ToArray()
    $comparison = [System.Comparison[object]] {
        param($left, $right)
        [System.StringComparer]::Ordinal.Compare(
            [string]$left['document_parent'], [string]$right['document_parent'])
    }
    [Array]::Sort($rowArray, [System.Collections.Generic.Comparer[object]]::Create($comparison))
    $seen = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase)
    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($row in $rowArray) {
        if (-not $seen.Add([string]$row['document_parent'])) {
            throw "latex inventory contains a portable path collision at '$($row['document_parent'])'"
        }
        $lines.Add((ConvertTo-LatexInventoryJsonLine -Record $row))
    }

    Write-LatexInventoryCatalogFile -Path $catalogPath -Line $lines.ToArray() `
        -ExistingFile $ExistingFile
    return [pscustomobject]@{
        InventoryRoot = $root
        Path          = $catalogPath
        Schema        = 'codex-scientiae/document-inventory-row/0.1'
        Records       = $lines.Count
        Bytes         = ([System.IO.FileInfo]::new($catalogPath)).Length
    }
}

function Read-LatexInventoryCatalog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()] [string] $InventoryPath
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($InventoryPath)) {
        [System.IO.Path]::GetFullPath($InventoryPath)
    }
    else { [System.IO.Path]::GetFullPath($InventoryPath, (Get-Location).Path) }
    if (-not [System.IO.File]::Exists($candidate)) {
        throw "latex inventory catalog not found: '$InventoryPath'"
    }
    $catalogPath = (Resolve-Path -LiteralPath $candidate).Path
    if ([System.IO.Path]::GetFileName($catalogPath) -cne 'inventory.jsonl') {
        throw "latex inventory catalog must be named inventory.jsonl: '$catalogPath'"
    }
    $root = [System.IO.Path]::GetDirectoryName($catalogPath)
    $bytes = [System.IO.File]::ReadAllBytes($catalogPath)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and
        $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        throw "latex inventory catalog must not contain a UTF-8 BOM: '$catalogPath'"
    }
    try { $text = $script:LatexInventoryUtf8.GetString($bytes) }
    catch { throw "latex inventory catalog is not strict UTF-8: '$catalogPath': $($_.Exception.Message)" }
    if ($text.Length -gt 0 -and -not $text.EndsWith("`n", [System.StringComparison]::Ordinal)) {
        throw "latex inventory catalog has an incomplete final record: '$catalogPath'"
    }

    $records = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase)
    $prior = $null
    $lines = [string[]]::new(0)
    if ($text.Length -gt 0) {
        $physicalLines = $text.Split("`n")
        $lines = [string[]]::new($physicalLines.Count - 1)
        [Array]::Copy($physicalLines, $lines, $lines.Count)
    }
    for ($index = 0; $index -lt $lines.Count; $index++) {
        $line = [string]$lines[$index]
        if ([string]::IsNullOrWhiteSpace($line) -or $line.Contains("`r")) {
            throw "latex inventory catalog has a blank or CRLF record at line $($index + 1): '$catalogPath'"
        }
        try { $valid = $line | Test-Json -SchemaFile $script:LatexInventoryRowSchemaPath -ErrorAction Stop }
        catch { throw "latex inventory row $($index + 1) failed schema validation: $($_.Exception.Message)" }
        if (-not $valid) { throw "latex inventory row $($index + 1) failed schema validation" }
        $row = $line | ConvertFrom-Json -AsHashtable -Depth 100 -ErrorAction Stop
        $parent = Assert-LatexInventoryScopedPath -Path ([string]$row['document_parent']) `
            -Field document_parent -DirectChild
        if ($null -ne $prior -and
            [System.StringComparer]::Ordinal.Compare($prior, $parent) -ge 0) {
            throw "latex inventory rows are not in canonical ordinal document_parent order at '$parent'"
        }
        if (-not $seen.Add($parent)) {
            throw "latex inventory contains a portable path collision at '$parent'"
        }
        $metadataRelative = Assert-LatexInventoryScopedPath -Path ([string]$row['metadata_path']) `
            -Field metadata_path
        $expectedRelative = "$parent/metadata.json"
        if (-not $metadataRelative.Equals($expectedRelative, [System.StringComparison]::Ordinal)) {
            throw "latex inventory metadata_path must equal '$expectedRelative': '$metadataRelative'"
        }
        $metadataPath = [System.IO.Path]::GetFullPath(
            $metadataRelative.Replace('/', [System.IO.Path]::DirectorySeparatorChar), $root)
        if (-not (Test-LatexInventoryPathWithinRoot -Path $metadataPath -Root $root) -or
            -not [System.IO.File]::Exists($metadataPath)) {
            throw "latex inventory metadata_path is missing or escapes its catalog root: '$metadataRelative'"
        }
        $actualHash = Get-LatexInventoryFileSha256 -Path $metadataPath
        if ($actualHash -cne [string]$row['metadata_sha256']) {
            throw "latex inventory catalog is stale for '$metadataRelative'; rebuild inventory.jsonl"
        }
        $manifest = Read-LatexInventoryJsonObject -Path $metadataPath `
            -SchemaPath $script:LatexInventoryManifestSchemaPath -Role 'metadata sentinel'
        if ([string]$manifest['slug'] -cne $parent -or
            [string]$row['slug'] -cne $parent -or
            [string]$row['manifest_schema'] -cne [string]$manifest['schema'] -or
            [string]$row['state'] -cne [string]$manifest['state']) {
            throw "latex inventory row identity disagrees with '$metadataRelative'"
        }
        $records.Add($row)
        $prior = $parent
    }
    return $records.ToArray()
}
