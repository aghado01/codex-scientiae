function Get-LatexBatchStableHash {
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

function ConvertTo-LatexBatchAddressLeaf {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Slug,
        [Parameter(Mandatory)] [ValidatePattern('^[0-9a-f]+$')] [string] $Digest
    )

    $stem = [regex]::Replace($Slug.ToLowerInvariant(), '[^a-z0-9._-]+', '-').Trim('-', '.')
    if ([string]::IsNullOrWhiteSpace($stem)) { $stem = 'document' }
    if ($stem.Length -gt 48) { $stem = $stem.Substring(0, 48).TrimEnd('-', '.') }
    return "$stem-$Digest"
}

function Resolve-LatexBatchJobAddress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $AddressLeaf
    )

    if ($AddressLeaf -in @('.', '..') -or [System.IO.Path]::GetFileName($AddressLeaf) -ne $AddressLeaf) {
        throw "latex-batch address leaf is not one safe path segment: '$AddressLeaf'"
    }

    # D19 chokepoint: these are the only adapter-owned run-relative path compositions.
    $jobDirectory = [System.IO.Path]::Combine($RunDirectory, 'latex-jobs', $AddressLeaf)
    return [pscustomobject]@{
        JobDirectory = $jobDirectory
        ApplicationRunDirectory = [System.IO.Path]::Combine($jobDirectory, 'run-artifacts')
        OutputDirectory = [System.IO.Path]::Combine($jobDirectory, 'lane-output')
        DeliverableDirectory = [System.IO.Path]::Combine($jobDirectory, 'deliverable')
    }
}
