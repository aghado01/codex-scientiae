#requires -Version 7.0
<#
  Bounded file reads and content identity over raw bytes. No domain knowledge.

  Read-BoundedFileBytes     read a file whole under a byte ceiling, with TOCTOU length guards.
  Get-ContentIdentity       sha256:<64 lowercase hex> over the given bytes.
  Test-ContentIdentityFormat true when a string is a well-formed sha256 identity.
#>

function Read-BoundedFileBytes {
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$Path,
        [Parameter(Mandatory)] [long]$MaxBytes
    )
    $entry = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    if ($entry -isnot [System.IO.FileInfo]) { throw "Not a file: '$Path'" }
    $observedLength = [long]$entry.Length
    if ($observedLength -gt $MaxBytes) { throw "File exceeds the $MaxBytes-byte limit: '$Path'" }

    $stream = [System.IO.FileStream]::new(
        $Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read,
        [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
    try {
        $length = [long]$stream.Length
        if ($length -ne $observedLength) { throw "File changed length before its bounded read: '$Path'" }
        if ($length -gt $MaxBytes) { throw "File exceeds the $MaxBytes-byte limit: '$Path'" }
        $bytes = [byte[]]::new([int]$length)
        $offset = 0
        while ($offset -lt $bytes.Length) {
            $read = $stream.Read($bytes, $offset, $bytes.Length - $offset)
            if ($read -eq 0) { throw "File shrank during its bounded read: '$Path'" }
            $offset += $read
        }
        if ($stream.ReadByte() -ne -1 -or [long]$stream.Length -ne $length) {
            throw "File grew during its bounded read: '$Path'"
        }
        return ,$bytes
    } finally { $stream.Dispose() }
}

function Get-ContentIdentity {
    param([Parameter(Mandatory)] [AllowEmptyCollection()] [byte[]]$Bytes)
    $hash = [System.Security.Cryptography.SHA256]::HashData($Bytes)
    return 'sha256:' + [System.BitConverter]::ToString($hash).Replace('-', '').ToLowerInvariant()
}

function Test-ContentIdentityFormat {
    param([AllowNull()] [AllowEmptyString()] [string]$Value)
    return $Value -cmatch '^sha256:[0-9a-f]{64}$'
}
