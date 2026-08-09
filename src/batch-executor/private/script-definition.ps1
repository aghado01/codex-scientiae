function Get-BatchExecutorScriptDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $Role,
        [switch] $RejectRequires
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "batch executor $Role script not found: '$Path'"
    }

    $resolved = (Resolve-Path -LiteralPath $Path).Path
    $tokens = $null
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $resolved, [ref]$tokens, [ref]$parseErrors)

    if ($parseErrors.Count -gt 0) {
        throw "batch executor $Role script does not parse: $($parseErrors[0].Message)"
    }
    if ($null -eq $ast.ParamBlock) {
        throw "batch executor $Role script must begin with a top-level param(...) block"
    }
    if ($RejectRequires -and $null -ne $ast.ScriptRequirements) {
        throw "batch executor $Role script must not declare #Requires in Runspace mode; the executor owns its InitialSessionState"
    }

    [pscustomobject]@{
        Path = $resolved
        Body = [System.IO.File]::ReadAllText($resolved)
    }
}
