# Pytest adapter dependency helpers.

function Resolve-PytestBatchFileDependency {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Path,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Role
    )

    $candidate = if ([System.IO.Path]::IsPathFullyQualified($Path)) {
        [System.IO.Path]::GetFullPath($Path)
    }
    else { [System.IO.Path]::GetFullPath($Path, $RepositoryRoot) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "pytest-batch $Role not found: '$Path'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-PytestBatchPythonPath {
    [CmdletBinding()]
    param(
        [string] $PythonPath,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    if (-not [string]::IsNullOrWhiteSpace($PythonPath)) {
        return Resolve-PytestBatchFileDependency -Path $PythonPath `
            -RepositoryRoot $RepositoryRoot -Role 'Python interpreter'
    }

    $venvCandidates = @(
        [System.IO.Path]::Combine($RepositoryRoot, '.venv', 'Scripts', 'python.exe')
        [System.IO.Path]::Combine($RepositoryRoot, '.venv', 'bin', 'python')
    )
    foreach ($candidate in $venvCandidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    throw 'pytest-batch could not locate a Python interpreter; restore .venv or pass -PythonPath'
}

function Resolve-PytestBatchPowerShellPath {
    [CmdletBinding()]
    param([string] $PowerShellPath)

    if ([string]::IsNullOrWhiteSpace($PowerShellPath)) {
        $PowerShellPath = [System.Environment]::ProcessPath
    }
    if ([string]::IsNullOrWhiteSpace($PowerShellPath)) {
        $PowerShellPath = (Get-Command pwsh -CommandType Application -ErrorAction Stop).Source
    }
    elseif (-not [System.IO.Path]::IsPathFullyQualified($PowerShellPath)) {
        $PowerShellPath = (Get-Command $PowerShellPath -CommandType Application -ErrorAction Stop).Source
    }
    $candidate = [System.IO.Path]::GetFullPath($PowerShellPath)
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "pytest-batch child PowerShell not found: '$PowerShellPath'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}
