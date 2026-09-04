# Gauntlet adapter dependency helpers.
#
# The engine under test lives in its own repository. Planning freezes only
# where it is (EngineRoot) and which child entrypoint it offers (Worker); it
# never resolves node, perl, or any other engine runtime. Runtime preflight is
# the engine-side launcher's job, before it asks codex-scientiae for a plan.

function Resolve-GauntletBatchEngineRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $EngineRoot,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    if (-not [System.IO.Path]::IsPathFullyQualified($EngineRoot)) {
        throw "gauntlet-batch EngineRoot must be an existing absolute directory: '$EngineRoot'"
    }
    $candidate = [System.IO.Path]::GetFullPath($EngineRoot)
    if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
        throw "gauntlet-batch EngineRoot must be an existing absolute directory: '$EngineRoot'"
    }
    $resolved = (Resolve-Path -LiteralPath $candidate).Path
    $repository = (Resolve-Path -LiteralPath $RepositoryRoot).Path
    if ($resolved -eq $repository -or
            (Test-PathIsDescendant -Root $repository -Path $resolved) -or
            (Test-PathIsDescendant -Root $resolved -Path $repository)) {
        throw "gauntlet-batch EngineRoot must lie outside RepositoryRoot: '$EngineRoot'"
    }
    return $resolved
}

function Resolve-GauntletBatchWorker {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Worker,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $EngineRoot
    )

    if (-not [System.IO.Path]::IsPathFullyQualified($Worker)) {
        throw "gauntlet-batch Worker must be an existing absolute .ps1 file below EngineRoot: '$Worker'"
    }
    $candidate = [System.IO.Path]::GetFullPath($Worker)
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf) -or
            [System.IO.Path]::GetExtension($candidate) -ne '.ps1') {
        throw "gauntlet-batch Worker must be an existing absolute .ps1 file below EngineRoot: '$Worker'"
    }
    $resolved = (Resolve-Path -LiteralPath $candidate).Path
    if (-not (Test-PathIsDescendant -Root $EngineRoot -Path $resolved)) {
        throw "gauntlet-batch Worker must be an existing absolute .ps1 file below EngineRoot: '$Worker'"
    }
    return $resolved
}

function Resolve-GauntletBatchPowerShellPath {
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
        throw "gauntlet-batch child PowerShell not found: '$PowerShellPath'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}

function Resolve-GauntletBatchWorkerParameter {
    <# Extra parameters the caller wants frozen into every child invocation.
       The adapter owns Article, OutDirectory, and EngineRoot; a caller may
       not shadow them. Keys must be plain PowerShell parameter names. #>
    [CmdletBinding()]
    param(
        [AllowNull()] [System.Collections.IDictionary] $WorkerParameter
    )

    $frozen = @{}
    if ($null -eq $WorkerParameter) { return $frozen }
    foreach ($key in @($WorkerParameter.Keys)) {
        $name = [string]$key
        if ($name -notmatch '^[A-Za-z_][A-Za-z0-9_]*$') {
            throw "gauntlet-batch WorkerParameter key is not a parameter name: '$name'"
        }
        if ($name -in @('Article', 'OutDirectory', 'EngineRoot')) {
            throw "gauntlet-batch WorkerParameter may not shadow the adapter-owned parameter '$name'"
        }
        $frozen[$name] = $WorkerParameter[$key]
    }
    return $frozen
}
