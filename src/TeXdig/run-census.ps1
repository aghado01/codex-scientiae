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
    [string] $NodePath = '',
    [string] $OutRoot = '',
    [string] $Stamp = '',
    [string] $OutDirectory = '',
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

# Exact publication surface for texdig-census/0.2. The PowerShell runner is a
# process boundary, so it validates the worker's declared store identities
# instead of treating an umbrella schema match as sufficient.
$script:TeXdigCensusStoreSchemas = [ordered]@{
    'sources.jsonl' = 'codex-scientiae/texdig-sources/0.2'
    'entities.jsonl' = 'codex-scientiae/texdig-entities/0.2'
    'claims.jsonl' = 'codex-scientiae/texdig-claims/0.2'
    'coverage.json' = 'codex-scientiae/texdig-coverage/0.2'
    'diagnostics.jsonl' = 'codex-scientiae/texdig-diagnostics/0.2'
    'summary.json' = 'codex-scientiae/texdig-summary/0.2'
}
$script:TeXdigCensusDeferredStores = @(
    'occurrences.jsonl'
    'bindings.jsonl'
    'invocations.jsonl'
    'expansion.jsonl'
    'walk.jsonl'
    'zones.jsonl'
    'macros.jsonl'
    'references.jsonl'
    'pointers.jsonl'
    'frontmatter.jsonl'
    'graph.jsonl'
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

function Resolve-TeXdigNodeRuntime {
    <# Resolves one Node application path and records the version reported by
       that exact executable. Explicit paths are absolute and existing. #>
    [CmdletBinding()]
    param(
        [string] $NodePath = ''
    )

    $candidate = if ([string]::IsNullOrWhiteSpace($NodePath)) {
        $command = Get-Command node -CommandType Application -ErrorAction SilentlyContinue
        if ($null -eq $command) {
            throw 'TeXdig: node is not on PATH and -NodePath was not provided'
        }
        $command.Source
    } else {
        if (-not [System.IO.Path]::IsPathFullyQualified($NodePath)) {
            throw "TeXdig: NodePath must be an existing absolute application path: '$NodePath'"
        }
        [System.IO.Path]::GetFullPath($NodePath)
    }

    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "TeXdig: Node executable not found: '$candidate'"
    }
    $resolvedPath = (Resolve-Path -LiteralPath $candidate).Path
    $application = Get-Command $resolvedPath -CommandType Application -ErrorAction SilentlyContinue
    if ($null -eq $application) {
        throw "TeXdig: NodePath is not an executable application: '$resolvedPath'"
    }

    $versionOutput = @(& $resolvedPath --version 2>&1)
    $versionExitCode = $LASTEXITCODE
    $version = (($versionOutput | ForEach-Object { [string] $_ }) -join "`n").Trim()
    if ($versionExitCode -ne 0 -or [string]::IsNullOrWhiteSpace($version)) {
        throw "TeXdig: Node executable failed version validation (exit $versionExitCode): '$resolvedPath'"
    }

    return [pscustomobject]@{
        Path = $resolvedPath
        Version = $version
    }
}

function Initialize-TeXdigOutputParent {
    <# Requires an absent publication target and creates only its parent. The
       emitter owns atomic creation of the target directory. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $RunDirectory
    )

    if (Test-Path -LiteralPath $RunDirectory) {
        throw "TeXdig: refusing existing output path with stale or partial artifacts: '$RunDirectory'"
    }

    $fullTarget = [System.IO.Path]::GetFullPath($RunDirectory)
    $parent = [System.IO.Path]::GetDirectoryName($fullTarget)
    if ([string]::IsNullOrWhiteSpace($parent)) {
        throw "TeXdig: output path has no parent directory: '$RunDirectory'"
    }
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }
}

function Find-TeXdigExactJsonProperty {
    <# Returns one case-sensitive property from a ConvertFrom-Json object. #>
    [CmdletBinding()]
    param(
        [AllowNull()] [object] $InputObject,
        [Parameter(Mandatory)] [string] $Name
    )

    if ($null -eq $InputObject) { return $null }
    foreach ($property in $InputObject.PSObject.Properties) {
        if ($property.Name -ceq $Name) { return $property }
    }
    return $null
}

function Read-TeXdigPublishedSummary {
    <# Validates the post-exit publication surface. Atomic staging and commit
       remain emitter responsibilities; this check only prevents false success. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $RunDirectory,
        [Parameter(Mandatory)] [string] $ExpectedSlug,
        [Parameter(Mandatory)] [string] $ExpectedNodeVersion
    )

    $summaryPath = Join-Path $RunDirectory 'summary.json'
    if (-not (Test-Path -LiteralPath $summaryPath -PathType Leaf)) {
        throw "TeXdig: worker exited 0 but emitted no summary.json in '$RunDirectory'"
    }
    try {
        $summary = Get-Content -LiteralPath $summaryPath -Raw | ConvertFrom-Json
    } catch {
        throw "TeXdig: worker exited 0 but emitted invalid summary.json in '$RunDirectory': $($_.Exception.Message)"
    }

    if ([string] $summary.slug -cne $ExpectedSlug) {
        throw "TeXdig: published summary slug '$($summary.slug)' does not match '$ExpectedSlug' in '$RunDirectory'"
    }
    if ([string] $summary.schema -cne 'texdig-census/0.2') {
        throw "TeXdig: published summary has unsupported schema '$($summary.schema)' in '$RunDirectory'"
    }
    $runtimeProperty = Find-TeXdigExactJsonProperty -InputObject $summary -Name 'runtime'
    $runtimeNodeProperty = if ($null -ne $runtimeProperty) {
        Find-TeXdigExactJsonProperty -InputObject $runtimeProperty.Value -Name 'node'
    }
    $publishedNodeVersion = if ($null -ne $runtimeNodeProperty) {
        [string] $runtimeNodeProperty.Value
    } else {
        ''
    }
    if ($publishedNodeVersion -cne $ExpectedNodeVersion) {
        throw "TeXdig: published Node runtime '$publishedNodeVersion' does not match invoked runtime '$ExpectedNodeVersion' in '$RunDirectory'"
    }
    $storeSchemasProperty = Find-TeXdigExactJsonProperty -InputObject $summary -Name 'storeSchemas'
    if ($null -eq $storeSchemasProperty -or $null -eq $storeSchemasProperty.Value) {
        throw "TeXdig: published summary has no storeSchemas contract in '$RunDirectory'"
    }

    $storeSchemaProperties = @($storeSchemasProperty.Value.PSObject.Properties)
    if (($storeSchemaProperties | Measure-Object).Count -ne $script:TeXdigCensusStoreSchemas.Count) {
        throw "TeXdig: published summary has an incompatible storeSchemas contract in '$RunDirectory'"
    }
    foreach ($store in $script:TeXdigCensusStoreSchemas.Keys) {
        $schemaProperty = Find-TeXdigExactJsonProperty -InputObject $storeSchemasProperty.Value -Name $store
        $expectedSchema = [string] $script:TeXdigCensusStoreSchemas[$store]
        if ($null -eq $schemaProperty -or [string] $schemaProperty.Value -cne $expectedSchema) {
            $publishedSchema = if ($null -ne $schemaProperty) { [string] $schemaProperty.Value } else { '' }
            throw "TeXdig: published store schema '$publishedSchema' for '$store' does not match '$expectedSchema' in '$RunDirectory'"
        }
    }
    if ($null -eq $summary.stores -or $null -eq $summary.stores.emitted) {
        throw "TeXdig: published summary has no stores.emitted contract in '$RunDirectory'"
    }

    $emitted = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::Ordinal)
    foreach ($storeValue in @($summary.stores.emitted)) {
        $store = [string] $storeValue
        if ([string]::IsNullOrWhiteSpace($store) -or
                [System.IO.Path]::IsPathFullyQualified($store) -or
                [System.IO.Path]::GetFileName($store) -cne $store) {
            throw "TeXdig: published summary contains an invalid store name '$store' in '$RunDirectory'"
        }
        if (-not $script:TeXdigCensusStoreSchemas.Contains($store)) {
            throw "TeXdig: published summary declares unknown emitted store '$store' in '$RunDirectory'"
        }
        if (-not $emitted.Add($store)) {
            throw "TeXdig: published summary declares duplicate emitted store '$store' in '$RunDirectory'"
        }
        if (-not (Test-Path -LiteralPath (Join-Path $RunDirectory $store) -PathType Leaf)) {
            throw "TeXdig: worker exited 0 but declared missing emitted store '$store' in '$RunDirectory'"
        }
    }

    foreach ($store in $script:TeXdigCensusStoreSchemas.Keys) {
        if (-not $emitted.Contains($store)) {
            throw "TeXdig: worker exited 0 but summary omitted required store '$store' in '$RunDirectory'"
        }
    }
    if ($emitted.Count -ne $script:TeXdigCensusStoreSchemas.Count) {
        throw "TeXdig: published summary has an incompatible emitted-store count in '$RunDirectory'"
    }

    if ($null -eq $summary.stores.deferred) {
        throw "TeXdig: published summary has no stores.deferred contract in '$RunDirectory'"
    }
    $deferred = @($summary.stores.deferred)
    if ($deferred.Count -ne $script:TeXdigCensusDeferredStores.Count) {
        throw "TeXdig: published summary has an incompatible deferred-store contract in '$RunDirectory'"
    }
    for ($index = 0; $index -lt $script:TeXdigCensusDeferredStores.Count; $index++) {
        if ([string] $deferred[$index] -cne $script:TeXdigCensusDeferredStores[$index]) {
            throw "TeXdig: published summary has an incompatible deferred-store contract in '$RunDirectory'"
        }
    }

    return $summary
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
        [string] $NodePath = '',
        [string] $OutRoot = '',
        [string] $Stamp = '',
        # Exact container override: the batch adapter passes the job container,
        # which IS the document container. Wins over OutRoot/Stamp composition.
        [string] $OutDirectory = '',
        [switch] $SkipValidation
    )

    $resolved = Resolve-TeXdigArticle -Article $Article

    if ($DepsRoot -eq '') { $DepsRoot = Join-Path $script:RepoRoot 'packages/node/node_modules' }
    if ($OutRoot -eq '') { $OutRoot = Join-Path $script:RepoRoot 'artifacts/texdig-runs' }
    if ($Stamp -eq '' -and $OutDirectory -eq '') { $Stamp = Get-Date -Format 'yyyyMMdd_HHmmss' }

    if (-not (Test-Path -LiteralPath (Join-Path $DepsRoot '@unified-latex'))) {
        throw "TeXdig: pinned node dependencies not found under '$DepsRoot' (packages/ is untracked; refresh the local pins)"
    }
    $nodeRuntime = Resolve-TeXdigNodeRuntime -NodePath $NodePath
    Write-Verbose "TeXdig Node runtime: $($nodeRuntime.Path) ($($nodeRuntime.Version))"

    if (-not $SkipValidation) {
        Test-TeXdigArticleManifest -ArticleJson $resolved.ArticleJson
    }

    $runDir = if ($OutDirectory -ne '') {
        if ([System.IO.Path]::IsPathRooted($OutDirectory)) { $OutDirectory } else { Join-Path $script:RepoRoot $OutDirectory }
    } else {
        Join-Path (Join-Path $OutRoot $Stamp) $resolved.Slug
    }
    Initialize-TeXdigOutputParent -RunDirectory $runDir

    $cli = Join-Path $script:TeXdigRoot 'cli/census.ts'
    # Worker console output goes to the host, NOT the pipeline: the function's
    # only output is the typed run record.
    $workerOutput = [System.Collections.Generic.List[string]]::new()
    & $nodeRuntime.Path $cli --article $resolved.ArticleDir --deps $DepsRoot --out $runDir 2>&1 |
        ForEach-Object {
            $line = [string] $_
            $workerOutput.Add($line)
            Write-Host $_
        }
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        $failureEvidence = ($workerOutput -join "`n").Trim()
        $failureSuffix = if ([string]::IsNullOrWhiteSpace($failureEvidence)) {
            ''
        } else {
            "`nWorker output:`n$failureEvidence"
        }
        throw "TeXdig: census worker failed with exit code $exitCode for '$($resolved.Slug)' (run dir: $runDir)$failureSuffix"
    }

    $summary = Read-TeXdigPublishedSummary -RunDirectory $runDir `
        -ExpectedSlug $resolved.Slug -ExpectedNodeVersion $nodeRuntime.Version

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
        NodePath        = $nodeRuntime.Path
        NodeVersion     = $nodeRuntime.Version
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
        throw 'usage: run-census.ps1 <slug | article-dir | article.json> [-DepsRoot <dir>] [-NodePath <file>] [-OutRoot <dir>] [-Stamp <stamp>] [-OutDirectory <dir>] [-SkipValidation]'
    }
    Invoke-TeXdigCensus -Article $Article -DepsRoot $DepsRoot -NodePath $NodePath `
        -OutRoot $OutRoot -Stamp $Stamp `
        -OutDirectory $OutDirectory -SkipValidation:$SkipValidation
}
