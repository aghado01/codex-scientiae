function Resolve-JsonlEngineRuntime {
    [CmdletBinding()]
    param([string] $PythonPath = '')

    $candidate = $PythonPath
    if ([string]::IsNullOrWhiteSpace($candidate)) {
        $candidate = [System.Environment]::GetEnvironmentVariable('CODEX_JSONL_ENGINE_PYTHON')
    }

    if (-not [string]::IsNullOrWhiteSpace($candidate)) {
        $full = if ([System.IO.Path]::IsPathFullyQualified($candidate)) {
            [System.IO.Path]::GetFullPath($candidate)
        }
        else {
            [System.IO.Path]::GetFullPath($candidate, (Get-Location).Path)
        }
        if (-not [System.IO.File]::Exists($full)) {
            throw "jsonl engine Python interpreter not found: '$candidate'"
        }
        return (Resolve-Path -LiteralPath $full).Path
    }

    foreach ($relativePath in @('.venv/Scripts/python.exe', '.venv/bin/python')) {
        $full = [System.IO.Path]::GetFullPath(
            (Join-Path $script:JsonlEngineRepositoryRoot $relativePath))
        if ([System.IO.File]::Exists($full)) {
            return (Resolve-Path -LiteralPath $full).Path
        }
    }

    throw @"
No repository Python environment was found under '$script:JsonlEngineRepositoryRoot'.
Set CODEX_JSONL_ENGINE_PYTHON or pass -PythonPath, or restore the repository environment:
  brewery/uv/restore-uv.ps1
"@
}

function ConvertTo-JsonlEngineCommandDisplay {
    param(
        [Parameter(Mandatory)] [string] $Executable,
        [Parameter(Mandatory)] [string[]] $ArgumentList
    )

    $parts = [System.Collections.Generic.List[string]]::new()
    $parts.Add('&')
    $parts.Add("'" + $Executable.Replace("'", "''") + "'")
    foreach ($argument in $ArgumentList) {
        $parts.Add("'" + $argument.Replace("'", "''") + "'")
    }
    return ($parts -join ' ')
}

function Resolve-JsonlEnginePathArgument {
    [CmdletBinding()]
    param([Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Path)

    if ([System.IO.Path]::IsPathFullyQualified($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }

    $location = Get-Location
    if ($location.Provider.Name -ne 'FileSystem') {
        throw "relative jsonl engine paths require a FileSystem working location: '$Path'"
    }
    return [System.IO.Path]::GetFullPath($Path, $location.Path)
}
