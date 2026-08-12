# TeXdig census runner — the PowerShell worker face of the pure TS census worker.
#
# The census CLI (cli/census.ts) stays a pure worker: tree + entrypoint in,
# stores out. This runner owns what the brief assigns the PS side: the
# lightweight validate-json shape check (through the jsonl_engine-client seam;
# the deposit owns real validation), runstamped container addressing, and a
# typed run result. Get-TeXdigBatchJob composes Invoke-TeXdigCensus per job
# when the batch adapter lands; until then this file is also directly runnable:
#
#   pwsh -File src/TeXdig/run-census.ps1 2111.15058v3
#   pwsh -File src/TeXdig/run-census.ps1 ingestion/gauntlet/ph-zigzag/2111.15058v3
#
# Deliberately functions, not a class: the worker is stateless orchestration,
# and PowerShell class definitions are session-cached (edits keep running the
# old type until a new session) — a hazard with no compensating benefit here.
#Requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter(Position = 0)] [string] $Article = '',
    [string] $DepsRoot = '',
    [string] $OutRoot = '',
    [string] $Stamp = '',
    [switch] $SkipValidation
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

$script:TeXdigRoot = $PSScriptRoot
$script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path

# Article roots searched when the caller passes a bare slug, in fixed order.
$script:ArticleSearchRoots = @(
    (Join-Path $script:RepoRoot 'ingestion/gauntlet')
    (Join-Path $script:RepoRoot 'ingestion/inventory')
)

function Resolve-TeXdigArticle {
    <# Resolve a slug or path to its deposited article directory. A bare slug
       is searched one level under each gauntlet collection and directly under
       the inventory; zero or multiple hits fail loud with the evidence. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Article
    )

    $candidates = [System.Collections.Generic.List[string]]::new()

    $asPath = if ([System.IO.Path]::IsPathRooted($Article)) { $Article } else { Join-Path $script:RepoRoot $Article }
    if (Test-Path -LiteralPath $asPath) {
        $item = Get-Item -LiteralPath $asPath
        if ($item.PSIsContainer) {
            $candidates.Add($item.FullName)
        } elseif ($item.Name -eq 'article.json') {
            $candidates.Add($item.Directory.FullName)
        } else {
            throw "TeXdig: '$Article' resolves to a file that is not article.json"
        }
    } elseif ($Article -notmatch '[\\/]') {
        foreach ($root in $script:ArticleSearchRoots) {
            if (-not (Test-Path -LiteralPath $root)) { continue }
            $direct = Join-Path $root $Article
            if (Test-Path -LiteralPath (Join-Path $direct 'article.json')) {
                $candidates.Add((Get-Item -LiteralPath $direct).FullName)
            }
            foreach ($collection in Get-ChildItem -LiteralPath $root -Directory) {
                $nested = Join-Path $collection.FullName $Article
                if (Test-Path -LiteralPath (Join-Path $nested 'article.json')) {
                    $candidates.Add((Get-Item -LiteralPath $nested).FullName)
                }
            }
        }
    }

    if ($candidates.Count -eq 0) {
        throw "TeXdig: no deposited article found for '$Article' (searched: $($script:ArticleSearchRoots -join '; '))"
    }
    if ($candidates.Count -gt 1) {
        throw "TeXdig: '$Article' is ambiguous across deposits:`n  $($candidates -join "`n  ")"
    }

    $articleDir = $candidates[0]
    $articleJson = Join-Path $articleDir 'article.json'
    if (-not (Test-Path -LiteralPath $articleJson)) {
        throw "TeXdig: '$articleDir' has no article.json"
    }

    return [pscustomobject]@{
        PSTypeName  = 'TeXdig.Article'
        Slug        = Split-Path $articleDir -Leaf
        ArticleDir  = $articleDir
        ArticleJson = $articleJson
    }
}

function Test-TeXdigArticleManifest {
    <# The precedented lightweight shape check: read article.json through the
       engine's shipped `article` schema via the jsonl_engine-client seam.
       The deposit owns real validation; this only refuses malformed input
       before the worker runs. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ArticleJson
    )

    if (-not (Get-Module -Name 'jsonl_engine-client')) {
        Import-Module (Join-Path $script:RepoRoot 'src/jsonl_engine-client/jsonl_engine-client.psd1')
    }
    try {
        $null = Invoke-JsonlEngineCommand -Verb 'validate-json' -Argument @($ArticleJson, 'article')
    } catch {
        throw "TeXdig: article.json failed the 'article' schema shape check ($ArticleJson): $($_.Exception.Message)"
    }
}

function Invoke-TeXdigCensus {
    <# Run the stage-1 census worker for ONE deposited article and return a
       typed run record. Emits to {OutRoot}/{Stamp}/{Slug}; every invocation
       is a new run unless the caller pins -Stamp (the batch adapter passes
       one stamp per batch so a batch shares a container). #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Article,
        [string] $DepsRoot = '',
        [string] $OutRoot = '',
        [string] $Stamp = '',
        [switch] $SkipValidation
    )

    $resolved = Resolve-TeXdigArticle -Article $Article

    if ($DepsRoot -eq '') { $DepsRoot = Join-Path $script:RepoRoot 'packages/node/node_modules' }
    if ($OutRoot -eq '') { $OutRoot = Join-Path $script:RepoRoot 'artifacts/texdig-runs' }
    if ($Stamp -eq '') { $Stamp = Get-Date -Format 'yyyyMMdd_HHmmss' }

    if (-not (Test-Path -LiteralPath (Join-Path $DepsRoot '@unified-latex'))) {
        throw "TeXdig: pinned node dependencies not found under '$DepsRoot' (packages/ is untracked; refresh the local pins)"
    }
    $node = Get-Command node -ErrorAction SilentlyContinue
    if ($null -eq $node) {
        throw 'TeXdig: node is not on PATH'
    }

    if (-not $SkipValidation) {
        Test-TeXdigArticleManifest -ArticleJson $resolved.ArticleJson
    }

    $runDir = Join-Path (Join-Path $OutRoot $Stamp) $resolved.Slug
    if (-not (Test-Path -LiteralPath $runDir)) {
        $null = New-Item -ItemType Directory -Path $runDir -Force
    }

    $cli = Join-Path $script:TeXdigRoot 'cli/census.ts'
    # Worker console output goes to the host, NOT the pipeline: the function's
    # only output is the typed run record.
    & $node.Source $cli --article $resolved.ArticleDir --deps $DepsRoot --out $runDir 2>&1 |
        ForEach-Object { Write-Host $_ }
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "TeXdig: census worker failed with exit code $exitCode for '$($resolved.Slug)' (run dir: $runDir)"
    }

    $summaryPath = Join-Path $runDir 'summary.json'
    if (-not (Test-Path -LiteralPath $summaryPath)) {
        throw "TeXdig: worker exited 0 but emitted no summary.json in '$runDir'"
    }
    $summary = Get-Content -LiteralPath $summaryPath -Raw | ConvertFrom-Json

    $agreement = $summary.agreementCounts
    $diagnostics = $summary.diagnosticCounts
    $agreementValue = {
        param($name)
        if ($null -ne $agreement -and $agreement.PSObject.Properties[$name]) { $agreement.$name } else { 0 }
    }
    $diagnosticValue = {
        param($name)
        if ($null -ne $diagnostics -and $diagnostics.PSObject.Properties[$name]) { $diagnostics.$name } else { 0 }
    }

    return [pscustomobject]@{
        PSTypeName      = 'TeXdig.CensusRun'
        Slug            = $summary.slug
        Stamp           = $Stamp
        RunDir          = $runDir
        TreeSha256      = $summary.treeSha256
        Entrypoint      = $summary.entrypoint
        SourceCount     = $summary.sourceCount
        Entities        = ($summary.entityCounts.PSObject.Properties | Measure-Object -Sum Value).Sum
        Agreed          = & $agreementValue 'agreed'
        LexicalOnly     = & $agreementValue 'lexical-only'
        ParserOnly      = & $agreementValue 'parser-only'
        Conflict        = & $agreementValue 'conflict'
        ClaimedUtf16    = $summary.coverage.claimedUtf16
        TotalUtf16      = $summary.coverage.totalUtf16
        ResidueUtf16    = $summary.coverage.residueUtf16
        ResidueSegments = $summary.coverage.residueSegments
        Defects         = & $diagnosticValue 'defect'
        Warnings        = & $diagnosticValue 'warning'
    }
}

# Direct-run mode: pwsh -File src/TeXdig/run-census.ps1 <slug-or-path>
if ($MyInvocation.InvocationName -ne '.') {
    if ($Article -eq '') {
        throw 'usage: run-census.ps1 <slug | article-dir | article.json> [-DepsRoot <dir>] [-OutRoot <dir>] [-Stamp <stamp>] [-SkipValidation]'
    }
    Invoke-TeXdigCensus -Article $Article -DepsRoot $DepsRoot -OutRoot $OutRoot -Stamp $Stamp -SkipValidation:$SkipValidation
}
