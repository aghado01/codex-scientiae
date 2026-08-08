#requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $LatexIngestPath,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $MetadataPath,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $ExpectedSlug,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $ExpectedPatchIdentity,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $RunDir,
    [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string] $OutDir,
    [string] $DeliverableDir,
    [switch] $EnableEmbeddedToc,
    [switch] $DisableTreeToc,
    [switch] $DisableJsonlToc,
    [switch] $FaithfulNumbering
)

if ($ExpectedPatchIdentity -cne 'absent' -and
    $ExpectedPatchIdentity -cnotmatch '^sha256:[0-9a-f]{64}$') {
    throw "latex-batch worker received an invalid patch identity: '$ExpectedPatchIdentity'"
}

$dependency = [System.IO.Path]::GetFullPath($LatexIngestPath)
if (-not (Test-Path -LiteralPath $dependency -PathType Leaf)) {
    throw "latex-batch worker dependency not found: '$dependency'"
}
. $dependency
if ($null -eq (Get-Command Invoke-ArxivLatexToMarkdown -CommandType Function `
        -ErrorAction SilentlyContinue)) {
    throw "latex-batch worker dependency did not define Invoke-ArxivLatexToMarkdown: '$dependency'"
}

$invoke = @{
    MetadataPath = $MetadataPath
    ExpectedSlug = $ExpectedSlug
    ExpectedPatchIdentity = $ExpectedPatchIdentity
    RunDir = $RunDir
    OutDir = $OutDir
}
if (-not [string]::IsNullOrWhiteSpace($DeliverableDir)) {
    $invoke['DeliverableDir'] = $DeliverableDir
}
if ($EnableEmbeddedToc) { $invoke['EnableEmbeddedToc'] = $true }
if ($DisableTreeToc) { $invoke['DisableTreeToc'] = $true }
if ($DisableJsonlToc) { $invoke['DisableJsonlToc'] = $true }
if ($FaithfulNumbering) { $invoke['FaithfulNumbering'] = $true }

Invoke-ArxivLatexToMarkdown @invoke
