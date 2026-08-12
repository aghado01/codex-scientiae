# TeXdig adapter dependency helpers.

function Resolve-TeXdigBatchWorker {
    <# The child entrypoint is the TeXdig PS runner; planning freezes its path
       and fails fast when the pinned node dependencies or node itself are
       absent, so a whole plan refuses before any child spawns. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot,
        [string] $DepsRoot
    )

    $runner = [System.IO.Path]::Combine($RepositoryRoot, 'src', 'TeXdig', 'run-census.ps1')
    if (-not (Test-Path -LiteralPath $runner -PathType Leaf)) {
        throw "texdig-batch runner not found: '$runner'"
    }

    if ([string]::IsNullOrWhiteSpace($DepsRoot)) {
        $DepsRoot = [System.IO.Path]::Combine($RepositoryRoot, 'packages', 'node', 'node_modules')
    }
    elseif (-not [System.IO.Path]::IsPathFullyQualified($DepsRoot)) {
        $DepsRoot = [System.IO.Path]::GetFullPath($DepsRoot, $RepositoryRoot)
    }
    if (-not (Test-Path -LiteralPath ([System.IO.Path]::Combine($DepsRoot, '@unified-latex')) -PathType Container)) {
        throw "texdig-batch pinned node dependencies not found under '$DepsRoot' (packages/ is untracked; refresh the local pins)"
    }

    $node = Get-Command node -CommandType Application -ErrorAction SilentlyContinue
    if ($null -eq $node) {
        throw 'texdig-batch requires node on PATH'
    }

    return [pscustomobject]@{
        Runner = (Resolve-Path -LiteralPath $runner).Path
        DepsRoot = (Resolve-Path -LiteralPath $DepsRoot).Path
        NodePath = $node.Source
    }
}

function Resolve-TeXdigBatchPowerShellPath {
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
        throw "texdig-batch child PowerShell not found: '$PowerShellPath'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}
