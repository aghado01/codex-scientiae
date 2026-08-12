# TeXdig adapter addressing helpers.

function Get-TeXdigBatchStableHash {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [AllowEmptyString()] [string] $Value,
        [ValidateRange(8, 64)] [int] $Length = 12
    )

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
        $hex = [System.Convert]::ToHexString($sha.ComputeHash($bytes)).ToLowerInvariant()
        return $hex.Substring(0, $Length)
    }
    finally { $sha.Dispose() }
}

function ConvertTo-TeXdigBatchAddressLeaf {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Slug,
        [Parameter(Mandatory)] [ValidatePattern('^[0-9a-f]+$')] [string] $Digest
    )

    $stem = [regex]::Replace($Slug.ToLowerInvariant(), '[^a-z0-9._-]+', '-').Trim('-', '.')
    if ([string]::IsNullOrWhiteSpace($stem)) { $stem = 'article' }
    if ($stem.Length -gt 48) { $stem = $stem.Substring(0, 48).TrimEnd('-', '.') }
    return "$stem-$Digest"
}

function Resolve-TeXdigBatchJobAddress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $AddressLeaf
    )

    # The only adapter-owned run-relative composition. One document per job;
    # the job container IS the document container: the census worker emits its
    # six stores directly at this root (Writes root).
    return [pscustomobject]@{
        JobDirectory = [System.IO.Path]::Combine($RunDirectory, 'texdig-jobs', $AddressLeaf)
    }
}
