# Test adapter addressing helpers.

function Get-TestBatchStableHash {
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

function ConvertTo-TestBatchAddressLeaf {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $TestPath,
        [Parameter(Mandatory)] [ValidatePattern('^[0-9a-f]+$')] [string] $Digest
    )

    $stem = [System.IO.Path]::GetFileNameWithoutExtension($TestPath)
    if ($stem.EndsWith('.Tests', [System.StringComparison]::OrdinalIgnoreCase)) {
        $stem = $stem.Substring(0, $stem.Length - 6)
    }
    $stem = [regex]::Replace($stem.ToLowerInvariant(), '[^a-z0-9._-]+', '-').Trim('-', '.')
    if ([string]::IsNullOrWhiteSpace($stem)) { $stem = 'test' }
    if ($stem.Length -gt 48) { $stem = $stem.Substring(0, 48).TrimEnd('-', '.') }
    return "$stem-$Digest"
}

function Resolve-TestBatchJobAddress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $AddressLeaf
    )

    # D19 chokepoint: these are the only adapter-owned run-relative path compositions.
    $jobDirectory = [System.IO.Path]::Combine($RunDirectory, 'test-jobs', $AddressLeaf)
    $resultPath = [System.IO.Path]::Combine($jobDirectory, 'pester.xml')
    return [pscustomobject]@{
        JobDirectory = $jobDirectory
        ResultPath = $resultPath
    }
}
