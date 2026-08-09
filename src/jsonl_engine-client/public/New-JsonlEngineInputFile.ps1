function New-JsonlEngineInputFile {
    <#
    .SYNOPSIS
        Stage one structured PowerShell value as a strict JSON input file for an engine command.
    .DESCRIPTION
        The file is UTF-8 without a BOM and carries one LF-terminated JSON value. It is transport
        input, not an engine-owned artifact; the caller retains cleanup and retention policy.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [AllowNull()] $InputObject,
        [string] $Path = '',
        [ValidateRange(2, 100)] [int] $Depth = 100,
        [ValidateSet('Fail', 'Replace')] [string] $ExistingFile = 'Fail'
    )

    Assert-JsonlEngineJsonValue -Value $InputObject -MaximumDepth $Depth
    $json = ConvertTo-Json -InputObject $InputObject -Compress -Depth $Depth `
        -WarningAction Stop -ErrorAction Stop
    $bytes = $script:JsonlEngineUtf8.GetBytes($json + "`n")

    $isTemporary = [string]::IsNullOrWhiteSpace($Path)
    $fullPath = if ($isTemporary) {
        $configuredScratch = [System.Environment]::GetEnvironmentVariable(
            'CODEX_JSON_SCRATCH_ROOT')
        $temporaryRoot = if ($null -eq $configuredScratch) {
            [System.IO.Path]::GetTempPath()
        }
        else {
            if ([string]::IsNullOrWhiteSpace($configuredScratch) -or
                -not [System.IO.Path]::IsPathFullyQualified($configuredScratch)) {
                throw 'CODEX_JSON_SCRATCH_ROOT must name a non-empty absolute directory'
            }
            [System.IO.Path]::GetFullPath($configuredScratch)
        }
        [System.IO.Path]::Combine(
            $temporaryRoot,
            "codex-jsonl_engine-input-$([guid]::NewGuid().ToString('N')).json")
    }
    else {
        Resolve-JsonlEnginePathArgument -Path $Path
    }

    $directory = [System.IO.Path]::GetDirectoryName($fullPath)
    if ([string]::IsNullOrWhiteSpace($directory)) {
        throw "jsonl engine input path has no parent directory: '$fullPath'"
    }
    if ($ExistingFile -eq 'Fail' -and [System.IO.File]::Exists($fullPath)) {
        throw "jsonl engine input file already exists: '$fullPath'"
    }
    [void][System.IO.Directory]::CreateDirectory($directory)

    $scratchPath = [System.IO.Path]::Combine(
        $directory,
        ".$(Split-Path -Leaf $fullPath).$PID.$([guid]::NewGuid().ToString('N')).tmp")
    try {
        $stream = [System.IO.FileStream]::new(
            $scratchPath,
            [System.IO.FileMode]::CreateNew,
            [System.IO.FileAccess]::Write,
            [System.IO.FileShare]::None)
        try {
            $stream.Write($bytes, 0, $bytes.Length)
            $stream.Flush($true)
        }
        finally {
            $stream.Dispose()
        }
        [System.IO.File]::Move($scratchPath, $fullPath, ($ExistingFile -eq 'Replace'))
    }
    finally {
        if ([System.IO.File]::Exists($scratchPath)) {
            [System.IO.File]::Delete($scratchPath)
        }
    }

    $result = [pscustomobject]@{
        Path        = $fullPath
        IsTemporary = $isTemporary
        Bytes       = $bytes.Length
    }
    $result.PSObject.TypeNames.Insert(0, 'JsonlEngine.InputFile')
    return $result
}
