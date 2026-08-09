function Get-LatexBatchScriptSha256 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $Path
    )

    $stream = [System.IO.File]::OpenRead($Path)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { return [System.Convert]::ToHexString($sha.ComputeHash($stream)).ToLowerInvariant() }
    finally { $sha.Dispose(); $stream.Dispose() }
}

function Resolve-LatexBatchDependency {
    [CmdletBinding()]
    param(
        [string] $LatexIngestPath,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RepositoryRoot
    )

    $candidate = if ([string]::IsNullOrWhiteSpace($LatexIngestPath)) {
        [System.IO.Path]::Combine(
            $RepositoryRoot, 'src', 'latex-ingest', 'latex-ingest.ps1')
    }
    elseif ([System.IO.Path]::IsPathFullyQualified($LatexIngestPath)) {
        [System.IO.Path]::GetFullPath($LatexIngestPath)
    }
    else { [System.IO.Path]::GetFullPath($LatexIngestPath, $RepositoryRoot) }
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "latex-batch latex-ingest dependency not found: '$LatexIngestPath'"
    }
    $candidate = (Resolve-Path -LiteralPath $candidate).Path

    $tokens = $null
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $candidate, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors.Count -gt 0) {
        throw "latex-batch latex-ingest dependency does not parse: $($parseErrors[0].Message)"
    }
    $entrypoint = @($ast.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
                    $node.Name -ieq 'Invoke-ArxivLatexToMarkdown'
            }, $true))
    if ($entrypoint.Count -ne 1) {
        throw "latex-batch dependency must define Invoke-ArxivLatexToMarkdown exactly once: '$candidate'"
    }

    return [pscustomobject]@{
        Path = $candidate
        Sha256 = Get-LatexBatchScriptSha256 -Path $candidate
    }
}

function Resolve-LatexBatchPowerShellPath {
    [CmdletBinding()]
    param([string] $PowerShellPath)

    if ([string]::IsNullOrWhiteSpace($PowerShellPath)) {
        $leaf = if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' }
        $PowerShellPath = [System.IO.Path]::Combine($PSHOME, $leaf)
    }
    elseif (-not [System.IO.Path]::IsPathFullyQualified($PowerShellPath)) {
        $PowerShellPath = (Get-Command $PowerShellPath -CommandType Application -ErrorAction Stop).Source
    }
    $candidate = [System.IO.Path]::GetFullPath($PowerShellPath)
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "latex-batch child PowerShell not found: '$PowerShellPath'"
    }
    return (Resolve-Path -LiteralPath $candidate).Path
}
