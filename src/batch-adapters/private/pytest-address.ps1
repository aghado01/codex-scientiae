# Pytest adapter addressing helpers.

function Get-PytestBatchStableHash {
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

function ConvertTo-PytestBatchAddressLeaf {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $TestPath,
        [Parameter(Mandatory)] [ValidatePattern('^[0-9a-f]+$')] [string] $Digest
    )

    $stem = [System.IO.Path]::GetFileNameWithoutExtension($TestPath)
    $stem = [regex]::Replace($stem.ToLowerInvariant(), '[^a-z0-9._-]+', '-').Trim('-', '.')
    if ([string]::IsNullOrWhiteSpace($stem)) { $stem = 'test' }
    if ($stem.Length -gt 48) { $stem = $stem.Substring(0, 48).TrimEnd('-', '.') }
    return "$stem-$Digest"
}

function Resolve-PytestBatchJobAddress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDirectory,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $AddressLeaf
    )

    # D19 chokepoint: these are the only pytest-adapter-owned run-relative compositions.
    $jobDirectory = [System.IO.Path]::Combine($RunDirectory, 'pytest-jobs', $AddressLeaf)
    return [pscustomobject]@{
        JobDirectory = $jobDirectory
        ResultPath = [System.IO.Path]::Combine($jobDirectory, 'pytest.xml')
        ArtifactRoot = [System.IO.Path]::Combine($jobDirectory, 'artifacts')
        TempRoot = [System.IO.Path]::Combine($jobDirectory, 'temp')
    }
}
