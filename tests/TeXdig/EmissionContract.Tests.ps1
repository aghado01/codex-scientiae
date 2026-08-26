BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:FixtureDir = Join-Path $script:RepositoryRoot 'tests/fixtures/texdig/mini_article'
    $script:NodePath = (Get-Command node -CommandType Application -ErrorAction Stop).Source
    $script:ResolvedNodePath = (Resolve-Path -LiteralPath $script:NodePath).Path
    $script:ExpectedNodeVersion = ((& $script:ResolvedNodePath --version 2>&1) -join "`n").Trim()
    $script:ExpectedStoreSchemas = [ordered]@{
        'sources.jsonl' = 'codex-scientiae/texdig-sources/0.2'
        'entities.jsonl' = 'codex-scientiae/texdig-entities/0.3'
        'claims.jsonl' = 'codex-scientiae/texdig-claims/0.2'
        'coverage.json' = 'codex-scientiae/texdig-coverage/0.2'
        'diagnostics.jsonl' = 'codex-scientiae/texdig-diagnostics/0.3'
        'occurrences.jsonl' = 'codex-scientiae/texdig-occurrences/0.3'
        'bindings.jsonl' = 'codex-scientiae/texdig-bindings/0.3'
        'invocations.jsonl' = 'codex-scientiae/texdig-invocations/0.3'
        'walk.jsonl' = 'codex-scientiae/texdig-walk/0.4'
        'zones.jsonl' = 'codex-scientiae/texdig-zones/0.4'
        'summary.json' = 'codex-scientiae/texdig-summary/0.4'
    }
    $script:ExpectedEmittedStores = @(
        'sources.jsonl'
        'entities.jsonl'
        'occurrences.jsonl'
        'bindings.jsonl'
        'invocations.jsonl'
        'claims.jsonl'
        'coverage.json'
        'diagnostics.jsonl'
        'walk.jsonl'
        'zones.jsonl'
        'summary.json'
    )
    $script:ExpectedDeferredStores = @(
        'expansion.jsonl'
        'macros.jsonl'
        'references.jsonl'
        'pointers.jsonl'
        'frontmatter.jsonl'
        'graph.jsonl'
    )

    . (Join-Path $script:RepositoryRoot 'src/TeXdig/run-census.ps1')

    $baseRoot = if ($env:CODEX_TEST_ARTIFACT_ROOT) {
        $env:CODEX_TEST_ARTIFACT_ROOT
    } else {
        $TestDrive
    }
    $script:ContractRoot = Join-Path $baseRoot ("emission-contract-{0}" -f ([guid]::NewGuid().ToString('N')))
    New-Item -ItemType Directory -Path $script:ContractRoot -Force | Out-Null
}

Describe 'TeXdig runner emission contract' -Tag 'TeXdig', 'EmissionContract' {
    Context 'Versioned summary schemas' {
        It 'preserves 0.2 and 0.3 history and publishes the exact 0.4 surface' {
            $schemaRoot = Join-Path $script:RepositoryRoot 'src/jsonl_engine/schemas'
            $prior = Get-Content -LiteralPath (Join-Path $schemaRoot 'texdig-summary.schema.json') `
                -Raw | ConvertFrom-Json
            $historic = Get-Content -LiteralPath (Join-Path $schemaRoot `
                'texdig-summary-v03.schema.json') -Raw | ConvertFrom-Json
            $current = Get-Content -LiteralPath (Join-Path $schemaRoot `
                'texdig-summary-v04.schema.json') -Raw | ConvertFrom-Json

            $prior.'$id' | Should -BeExactly 'codex-scientiae/texdig-summary/0.2'
            $prior.properties.schema.const | Should -BeExactly 'texdig-census/0.2'
            $historic.'$id' | Should -BeExactly 'codex-scientiae/texdig-summary/0.3'
            $historic.properties.schema.const | Should -BeExactly 'texdig-census/0.3'
            $current.'$id' | Should -BeExactly 'codex-scientiae/texdig-summary/0.4'
            $current.properties.schema.const | Should -BeExactly 'texdig-census/0.4'
            (@($current.properties.stores.properties.emitted.const) -join '|') |
                Should -BeExactly ($script:ExpectedEmittedStores -join '|')
            (@($current.properties.stores.properties.deferred.const) -join '|') |
                Should -BeExactly ($script:ExpectedDeferredStores -join '|')
            foreach ($countName in @('occurrenceCount', 'bindingRowCount', 'invocationCount')) {
                @($current.required) | Should -Contain $countName
                $current.properties.$countName.type | Should -BeExactly 'integer'
                $current.properties.$countName.minimum | Should -Be 0
            }
            @($current.properties.storeSchemas.properties.PSObject.Properties).Count |
                Should -Be $script:ExpectedStoreSchemas.Count
            foreach ($store in $script:ExpectedStoreSchemas.Keys) {
                $property = @($current.properties.storeSchemas.properties.PSObject.Properties |
                    Where-Object { $_.Name -ceq $store })
                $property.Count | Should -Be 1
                $property[0].Value.const | Should -BeExactly $script:ExpectedStoreSchemas[$store]
            }
        }
    }

    Context 'Frozen Node executable' {
        It 'invokes the explicit NodePath even when PATH cannot resolve node' {
            $outDir = Join-Path $script:ContractRoot 'explicit-node'
            $savedPath = $env:PATH
            try {
                $env:PATH = ''
                $run = Invoke-TeXdigCensus -Article $script:FixtureDir `
                    -NodePath $script:ResolvedNodePath -OutDirectory $outDir -SkipValidation
            } finally {
                $env:PATH = $savedPath
            }

            $run.NodePath | Should -BeExactly $script:ResolvedNodePath
            $run.NodeVersion | Should -BeExactly $script:ExpectedNodeVersion
            $summaryPath = Join-Path $outDir 'summary.json'
            Test-Path -LiteralPath $summaryPath -PathType Leaf | Should -BeTrue

            $summary = Get-Content -LiteralPath $summaryPath -Raw | ConvertFrom-Json
            $summary.schema | Should -BeExactly 'texdig-census/0.4'
            $summary.runtime.node | Should -BeExactly $script:ExpectedNodeVersion
            @($summary.storeSchemas.PSObject.Properties).Count |
                Should -Be $script:ExpectedStoreSchemas.Count
            foreach ($store in $script:ExpectedStoreSchemas.Keys) {
                $property = @($summary.storeSchemas.PSObject.Properties |
                    Where-Object { $_.Name -ceq $store })
                $property.Count | Should -Be 1
                $property[0].Value | Should -BeExactly $script:ExpectedStoreSchemas[$store]
            }
            (@($summary.stores.emitted) -join '|') |
                Should -BeExactly ($script:ExpectedEmittedStores -join '|')
            (@($summary.stores.deferred) -join '|') |
                Should -BeExactly ($script:ExpectedDeferredStores -join '|')
            $summary.occurrenceCount | Should -Be @(
                Get-Content -LiteralPath (Join-Path $outDir 'occurrences.jsonl')).Count
            $summary.bindingRowCount | Should -Be @(
                Get-Content -LiteralPath (Join-Path $outDir 'bindings.jsonl')).Count
            $summary.invocationCount | Should -Be @(
                Get-Content -LiteralPath (Join-Path $outDir 'invocations.jsonl')).Count
            $run.OccurrenceCount | Should -Be $summary.occurrenceCount
            $run.BindingRowCount | Should -Be $summary.bindingRowCount
            $run.InvocationCount | Should -Be $summary.invocationCount
        }

        It 'rejects a relative explicit NodePath instead of resolving it through PATH' {
            { Resolve-TeXdigNodeRuntime -NodePath 'node' } |
                Should -Throw '*NodePath must be an existing absolute application path*'
        }

        It 'rejects an absent explicit Node executable' {
            $missing = Join-Path $script:ContractRoot 'missing-node.exe'
            { Resolve-TeXdigNodeRuntime -NodePath $missing } |
                Should -Throw '*Node executable not found*'
        }
    }

    Context 'Fresh publication boundary' {
        It 'refuses an existing destination rather than accepting stale output' {
            $outDir = Join-Path $script:ContractRoot 'stale-output'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            Set-Content -LiteralPath (Join-Path $outDir 'stale.txt') -Value 'prior run'

            { Invoke-TeXdigCensus -Article $script:FixtureDir `
                    -NodePath $script:ResolvedNodePath -OutDirectory $outDir -SkipValidation } |
                Should -Throw '*refusing existing output path with stale or partial artifacts*'

            Get-Content -LiteralPath (Join-Path $outDir 'stale.txt') -Raw |
                Should -Match 'prior run'
        }

        It 'leaves an absent target for the atomic emitter and creates only its parent' {
            $parent = Join-Path $script:ContractRoot 'new-parent'
            $target = Join-Path $parent 'publication-target'

            Initialize-TeXdigOutputParent -RunDirectory $target

            Test-Path -LiteralPath $parent -PathType Container | Should -BeTrue
            Test-Path -LiteralPath $target | Should -BeFalse
        }

        It 'refuses an empty pre-existing target under the no-clobber contract' {
            $target = Join-Path $script:ContractRoot 'empty-existing-target'
            New-Item -ItemType Directory -Path $target -Force | Out-Null

            { Initialize-TeXdigOutputParent -RunDirectory $target } |
                Should -Throw '*refusing existing output path with stale or partial artifacts*'
        }

        It 'rejects a declared emitted store that is absent after zero exit' {
            $outDir = Join-Path $script:ContractRoot 'missing-declared-store'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            @{
                slug = 'mini_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{ emitted = @('summary.json', 'sources.jsonl') }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw "*declared missing emitted store 'sources.jsonl'*"
        }

        It 'rejects a summary that omits a required evidence store' {
            $outDir = Join-Path $script:ContractRoot 'omitted-required-store'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            @{
                slug = 'mini_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{ emitted = @('summary.json') }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw "*summary omitted required store 'sources.jsonl'*"
        }

        It 'rejects a parseable summary belonging to another article' {
            $outDir = Join-Path $script:ContractRoot 'wrong-slug'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            @{
                slug = 'another_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{ emitted = @('summary.json') }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw "*does not match 'mini_article'*"
        }

        It 'rejects a summary attributed to a different Node runtime' {
            $outDir = Join-Path $script:ContractRoot 'wrong-node-runtime'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            @{
                slug = 'mini_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = 'v0.0.0' }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{ emitted = @('summary.json') }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw '*does not match invoked runtime*'
        }

        It 'rejects a summary published under another census schema' {
            $outDir = Join-Path $script:ContractRoot 'wrong-census-schema'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            @{
                slug = 'mini_article'
                schema = 'texdig-census/0.1'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{ emitted = @('summary.json') }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw "*unsupported schema 'texdig-census/0.1'*"
        }

        It 'rejects a summary without per-store schema identities' {
            $outDir = Join-Path $script:ContractRoot 'missing-store-schemas'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            @{
                slug = 'mini_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = $script:ExpectedNodeVersion }
                stores = @{ emitted = @('summary.json') }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw '*has no storeSchemas contract*'
        }

        It 'rejects an incompatible per-store schema identity' {
            $outDir = Join-Path $script:ContractRoot 'wrong-store-schema'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            $storeSchemas = [ordered]@{}
            foreach ($store in $script:ExpectedStoreSchemas.Keys) {
                $storeSchemas[$store] = $script:ExpectedStoreSchemas[$store]
            }
            $storeSchemas['claims.jsonl'] = 'codex-scientiae/texdig-claims/0.1'
            @{
                slug = 'mini_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $storeSchemas
                stores = @{ emitted = @('summary.json') }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw "*for 'claims.jsonl' does not match 'codex-scientiae/texdig-claims/0.2'*"
        }

        It 'rejects an undeclared extra emitted store' {
            $outDir = Join-Path $script:ContractRoot 'extra-emitted-store'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            foreach ($store in $script:ExpectedStoreSchemas.Keys) {
                Set-Content -LiteralPath (Join-Path $outDir $store) -Value '{}'
            }
            Set-Content -LiteralPath (Join-Path $outDir 'extra.jsonl') -Value '{}'
            @{
                slug = 'mini_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{ emitted = @($script:ExpectedEmittedStores) + @('extra.jsonl') }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw "*declares unknown emitted store 'extra.jsonl'*"
        }

        It 'rejects a summary that falsely claims no deferred stores' {
            $outDir = Join-Path $script:ContractRoot 'missing-deferred-stores'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            foreach ($store in $script:ExpectedStoreSchemas.Keys) {
                Set-Content -LiteralPath (Join-Path $outDir $store) -Value '{}'
            }
            @{
                slug = 'mini_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{
                    emitted = @($script:ExpectedEmittedStores)
                    deferred = @()
                }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw '*incompatible deferred-store contract*'
        }

        It 'rejects a permutation of the exact emitted-store order' {
            $outDir = Join-Path $script:ContractRoot 'wrong-emitted-order'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            foreach ($store in $script:ExpectedStoreSchemas.Keys) {
                Set-Content -LiteralPath (Join-Path $outDir $store) -Value '{}'
            }
            $permuted = @($script:ExpectedEmittedStores)
            $permuted[1], $permuted[2] = $permuted[2], $permuted[1]
            @{
                slug = 'mini_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{
                    emitted = $permuted
                    deferred = $script:ExpectedDeferredStores
                }
                occurrenceCount = 0
                bindingRowCount = 0
                invocationCount = 0
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw '*incompatible emitted-store order*'
        }

        It 'requires nonnegative integral execution-store counts' {
            $outDir = Join-Path $script:ContractRoot 'invalid-execution-counts'
            New-Item -ItemType Directory -Path $outDir -Force | Out-Null
            foreach ($store in $script:ExpectedStoreSchemas.Keys) {
                Set-Content -LiteralPath (Join-Path $outDir $store) -Value '{}'
            }
            $summary = [ordered]@{
                slug = 'mini_article'
                schema = 'texdig-census/0.4'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{
                    emitted = $script:ExpectedEmittedStores
                    deferred = $script:ExpectedDeferredStores
                }
                occurrenceCount = 0
                invocationCount = 0
            }
            $summary | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw '*invalid bindingRowCount contract*'

            $summary['bindingRowCount'] = -1
            $summary | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')
            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw '*invalid bindingRowCount contract*'

            $summary['bindingRowCount'] = 1.5
            $summary | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')
            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw '*invalid bindingRowCount contract*'
        }

        It 'refuses stale source-tree attribution without publishing a target bundle' {
            $articleDir = Join-Path $script:ContractRoot 'stale-attribution-article'
            Copy-Item -LiteralPath $script:FixtureDir -Destination $articleDir -Recurse
            $manifestPath = Join-Path $articleDir 'article.json'
            $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
            $treeForm = @($manifest.source_forms |
                Where-Object { $_.role -ceq 'latex-source-tree' })[0]
            $treeForm.sha256 = '0' * 64
            $manifest | ConvertTo-Json -Depth 20 |
                Set-Content -LiteralPath $manifestPath
            $outDir = Join-Path $script:ContractRoot 'stale-attribution-output'

            $failure = $null
            try {
                $null = Invoke-TeXdigCensus -Article $articleDir `
                    -NodePath $script:ResolvedNodePath -OutDirectory $outDir -SkipValidation
            } catch {
                $failure = $_
            }

            $failure | Should -Not -BeNullOrEmpty
            $failure.Exception.Message |
                Should -Match 'source-tree fingerprint .* does not match .*refusing stale source attribution'
            Test-Path -LiteralPath $outDir | Should -BeFalse
        }

        It 'validates an invalid emitter bundle before creating the target' {
            $outDir = Join-Path $script:ContractRoot 'invalid-emitter-output'
            $emitPath = (Resolve-Path -LiteralPath (Join-Path $script:RepositoryRoot `
                'src/TeXdig/census/emit.ts')).Path
            $emitUri = ([uri] $emitPath).AbsoluteUri
            $probe = @"
import { emitCensusBundle } from "$emitUri";
import crypto from "node:crypto";
const sourceId = "main.tex";
const sourceBuffer = Buffer.from("abc", "utf8");
const sourceSha256 = crypto.createHash("sha256").update(sourceBuffer).digest("hex");
const treeSha256 = crypto.createHash("sha256")
  .update(sourceId + "\0" + sourceBuffer.length + "\0" + sourceSha256 + "\n", "utf8")
  .digest("hex");
const invalidSpan = { sourceId, startUtf16: 0, endUtf16: 4 };
const validSpan = { sourceId, startUtf16: 0, endUtf16: 3 };
const bundle = {
  slug: "invalid-emitter-bundle",
  treeSha256,
  entrypoint: sourceId,
  sources: [{
    id: sourceId,
    sha256: sourceSha256,
    bytes: 3,
    lengthUtf16: 3,
    language: "latex",
    role: "entrypoint",
    parsed: true
  }],
  entities: [{
    id: "ent:comment@main.tex:0-4",
    kind: "comment",
    span: invalidSpan,
    spanProvenance: "lexical",
    witnesses: [{ witness: "lexical", span: validSpan, spanRole: "token" }],
    agreement: "lexical-only",
    agreementBasis: "single-authority"
  }],
  occurrences: [],
  bindings: [],
  invocations: [],
  claims: [],
  coverage: [{
    sourceId,
    lengthUtf16: 3,
    claimedUtf16: 0,
    residueUtf16: 3,
    residue: [{ sourceId, startUtf16: 0, endUtf16: 3 }]
  }],
  diagnostics: [],
  rawBuffers: new Map([[sourceId, sourceBuffer]]),
  rawContents: new Map([[sourceId, "abc"]]),
  runtimeNode: process.version
};
try {
  emitCensusBundle(bundle, process.argv[1]);
  process.exitCode = 2;
} catch (error) {
  console.error(String(error));
  process.exitCode = 1;
}
"@

            $probeOutput = @(& $script:ResolvedNodePath --input-type=module `
                --eval $probe $outDir 2>&1)
            $probeExitCode = $LASTEXITCODE

            $probeExitCode | Should -Be 1
            ($probeOutput -join "`n") | Should -Match 'invalid span \(end-past-source\)'
            Test-Path -LiteralPath $outDir | Should -BeFalse
        }

        It 'rejects corrupt entity evidence and source attestations in memory' {
            $emitPath = (Resolve-Path -LiteralPath (Join-Path $script:RepositoryRoot `
                'src/TeXdig/census/emit.ts')).Path
            $emitUri = ([uri] $emitPath).AbsoluteUri
            $probe = @'
import crypto from "node:crypto";
import { validateCensusBundle } from "__EMIT_URI__";

const digest = (buffer) => crypto.createHash("sha256").update(buffer).digest("hex");
const span = (sourceId, startUtf16, endUtf16) => ({ sourceId, startUtf16, endUtf16 });
const witness = (witness, site, spanRole, detail) => ({ witness, span: site, spanRole, ...(detail ? { detail } : {}) });
const treeDigest = (sources) => digest(Buffer.from(
  [...sources]
    .sort((left, right) => left.id < right.id ? -1 : left.id > right.id ? 1 : 0)
    .map((source) => `${source.id}\0${source.bytes}\0${source.sha256}\n`)
    .join(""),
  "utf8"
));

function bundle(raw = "abcdefghij") {
  const sourceId = "main.tex";
  const buffer = Buffer.from(raw, "utf8");
  const source = {
    id: sourceId,
    sha256: digest(buffer),
    bytes: buffer.length,
    lengthUtf16: raw.length,
    language: "latex",
    role: "entrypoint",
    parsed: true,
  };
  const occurrenceId = "occ:probe-root";
  return {
    slug: "probe",
    treeSha256: treeDigest([source]),
    entrypoint: sourceId,
    sources: [source],
    entities: [],
    occurrences: [{
      id: occurrenceId,
      sourceId,
      includeChain: [sourceId],
      basis: "manifest-entrypoint",
      state: "entered",
      enterSeq: 0,
      exitSeq: 5,
    }],
    bindings: [{
      rowType: "scope-frame",
      id: "scope:probe-global",
      kind: "global",
      enterSeq: 1,
      exitSeq: 4,
      status: "closed",
    }, {
      rowType: "scope-frame",
      id: "scope:probe-document",
      kind: "document",
      parentScopeId: "scope:probe-global",
      occurrenceId,
      enterSeq: 2,
      exitSeq: 3,
      status: "closed",
    }],
    invocations: [],
    claims: [],
    coverage: [{
      sourceId,
      lengthUtf16: raw.length,
      claimedUtf16: 0,
      residueUtf16: raw.length,
      residue: raw.length > 0 ? [span(sourceId, 0, raw.length)] : [],
    }],
    diagnostics: [],
    rawBuffers: new Map([[sourceId, buffer]]),
    rawContents: new Map([[sourceId, raw]]),
    runtimeNode: process.version,
  };
}

function result(name, specimen) {
  try {
    validateCensusBundle(specimen);
    return { name, accepted: true, message: "" };
  } catch (error) {
    return { name, accepted: false, message: String(error) };
  }
}

const cases = [];
{
  const value = bundle("x");
  const site = span("main.tex", 0, 1);
  value.entities.push({
    id: "ent:bogus@main.tex:0-1", kind: "bogus", span: site,
    spanProvenance: "lexical", witnesses: [witness("lexical", site, "construct", "bogus")],
    agreement: "agreed", agreementBasis: "single-authority",
  });
  cases.push(result("unknown-kind", value));
}
{
  const value = bundle("xxxx");
  const site = span("main.tex", 0, 4);
  value.entities.push({
    id: "ent:environment@main.tex:0-4", kind: "environment", name: "proof", span: site,
    spanProvenance: "lexical", witnesses: [witness("lexical", site, "construct", "proof")],
    agreement: "agreed", agreementBasis: "single-authority",
  });
  cases.push(result("missing-kind-field", value));
}
{
  const value = bundle();
  const site = span("main.tex", 0, 10);
  value.entities.push({
    id: "ent:math@main.tex:0-10", kind: "math", mode: "inline", carrier: { form: "dollar" }, span: site,
    spanProvenance: "synthesized-hull",
    witnesses: [
      witness("lexical", span("main.tex", 0, 5), "construct", "dollar"),
      witness("parser", site, "construct", "inlinemath"),
    ],
    agreement: "agreed", agreementBasis: "two-instrument",
  });
  cases.push(result("non-equivalent-agreement", value));
}
{
  const value = bundle("x");
  const site = span("main.tex", 0, 1);
  value.entities.push({
    id: "ent:comment@main.tex:0-1", kind: "comment", span: site,
    spanProvenance: "lexical", witnesses: [witness("lexical", site, "construct", "comment")],
    agreement: "lexical-only", agreementBasis: "single-authority",
  });
  cases.push(result("missing-disagreement-diagnostic", value));
}
{
  const value = bundle("x");
  const main = value.sources[0];
  const blobBuffer = Buffer.from([1, 2, 3]);
  const blob = { id: "blob.bin", sha256: digest(blobBuffer), bytes: 3, language: "asset", role: "asset", parsed: false };
  value.sources = [blob, main];
  value.rawBuffers.set("blob.bin", blobBuffer);
  value.treeSha256 = treeDigest(value.sources);
  const site = span("blob.bin", 0, 999);
  value.entities.push({
    id: "ent:comment@blob.bin:0-999", kind: "comment", span: site,
    spanProvenance: "lexical", witnesses: [witness("lexical", site, "construct", "comment")],
    agreement: "agreed", agreementBasis: "single-authority",
  });
  cases.push(result("asset-coordinate", value));
}
{
  const value = bundle("x");
  value.sources[0].sha256 = "0".repeat(64);
  value.treeSha256 = treeDigest(value.sources);
  cases.push(result("source-sha", value));
}
{
  const value = bundle("x");
  value.treeSha256 = "0".repeat(64);
  cases.push(result("tree-sha", value));
}
{
  const value = bundle(String.raw`\section{Title}`);
  const site = span("main.tex", 0, 8);
  value.entities.push({
    id: "ent:envelope-marker@main.tex:0-8", kind: "envelope-marker", marker: "section", name: "section",
    titleSpan: span("main.tex", 9, 14), span: site, spanProvenance: "lexical",
    witnesses: [witness("lexical", site, "token", "section")], agreement: "agreed",
    agreementBasis: "single-authority",
  });
  cases.push(result("title-span", value));
}
console.log(JSON.stringify(cases));
'@.Replace('__EMIT_URI__', $emitUri)

            $probeOutput = @(& $script:ResolvedNodePath --input-type=module --eval $probe 2>&1)
            $probeExitCode = $LASTEXITCODE
            $global:LASTEXITCODE = 0
            $probeExitCode | Should -Be 0
            $results = ($probeOutput -join "`n") | ConvertFrom-Json

            @($results | Where-Object accepted).Count | Should -Be 0
            (@($results | Where-Object name -eq 'unknown-kind')[0].message) | Should -Match 'unknown kind'
            (@($results | Where-Object name -eq 'missing-kind-field')[0].message) | Should -Match "missing required field 'role'"
            (@($results | Where-Object name -eq 'non-equivalent-agreement')[0].message) | Should -Match 'non-equivalent witnesses'
            (@($results | Where-Object name -eq 'missing-disagreement-diagnostic')[0].message) | Should -Match 'no entity-linked diagnostic'
            (@($results | Where-Object name -eq 'asset-coordinate')[0].message) | Should -Match 'without decoded bounded text'
            (@($results | Where-Object name -eq 'source-sha')[0].message) | Should -Match 'SHA-256 does not match'
            (@($results | Where-Object name -eq 'tree-sha')[0].message) | Should -Match 'canonical source-record aggregate'
            (@($results | Where-Object name -eq 'title-span')[0].message) | Should -Match "unsupported field 'titleSpan'"
        }

        It 'reconstructs closed diagnostics, binding state, restores, and invocation carriers' {
            $emitPath = (Resolve-Path -LiteralPath (Join-Path $script:RepositoryRoot `
                'src/TeXdig/census/emit.ts')).Path
            $emitUri = ([uri] $emitPath).AbsoluteUri
            $probe = @'
import crypto from "node:crypto";
import { validateCensusBundle } from "__EMIT_URI__";

const digest = (buffer) => crypto.createHash("sha256").update(buffer).digest("hex");
const span = (startUtf16, endUtf16) => ({ sourceId: "main.tex", startUtf16, endUtf16 });
const signature = { state: "known", spec: "O{d} m" };
const treeDigest = (source) => digest(Buffer.from(
  `${source.id}\0${source.bytes}\0${source.sha256}\n`, "utf8"
));

function bundle() {
  const raw = String.raw`\foo{A}`;
  const buffer = Buffer.from(raw, "utf8");
  const source = {
    id: "main.tex", sha256: digest(buffer), bytes: buffer.length,
    lengthUtf16: raw.length, language: "latex", role: "entrypoint", parsed: true,
  };
  const occurrenceId = "occ:probe-root";
  const bindingId = "bind:probe-foo";
  const entityId = "ent:macro-invocation@main.tex:0-4";
  return {
    slug: "execution-probe",
    treeSha256: treeDigest(source),
    entrypoint: source.id,
    sources: [source],
    entities: [{
      id: entityId, kind: "macro-invocation", name: "foo", span: span(0, 4),
      spanProvenance: "lexical",
      witnesses: [{ witness: "lexical", span: span(0, 4), spanRole: "token" }],
      agreement: "agreed", agreementBasis: "single-authority",
    }],
    occurrences: [{
      id: occurrenceId, sourceId: source.id, includeChain: [source.id],
      basis: "manifest-entrypoint", state: "entered", enterSeq: 2, exitSeq: 7,
    }],
    bindings: [{
      rowType: "scope-frame", id: "scope:probe-global", kind: "global",
      enterSeq: 0, exitSeq: 6, status: "closed",
    }, {
      rowType: "binding-event", id: bindingId, seq: 1,
      executionScopeId: "scope:probe-global", targetScopeId: "scope:probe-global",
      symbol: { namespace: "control-sequence", name: "foo" },
      cause: { kind: "baseline" }, operation: "baseline-install", effect: "installed",
      installedMeaning: { kind: "primitive", name: "foo", signature },
    }, {
      rowType: "scope-frame", id: "scope:probe-document", kind: "document",
      parentScopeId: "scope:probe-global", occurrenceId, enterSeq: 3, exitSeq: 5,
      status: "closed",
    }],
    invocations: [{
      id: "inv:probe-foo", seq: 4, occurrenceId, entityId, name: "foo",
      siteKind: "control-sequence", siteSpan: span(0, 4),
      binding: { state: "bound", bindingEventId: bindingId, signature },
      span: span(0, 7),
      arguments: [{
        slot: 0, kind: "optional", source: "default", delimiter: "none", defaultText: "d",
      }, {
        slot: 1, kind: "mandatory", source: "explicit", delimiter: "brace",
        span: span(4, 7), contentSpan: span(5, 6),
      }],
      status: "attached", text: raw,
    }],
    claims: [],
    coverage: [{
      sourceId: source.id, lengthUtf16: raw.length, claimedUtf16: 4, residueUtf16: 3,
      residue: [span(4, 7)],
    }],
    diagnostics: [],
    rawBuffers: new Map([[source.id, buffer]]),
    rawContents: new Map([[source.id, raw]]),
    runtimeNode: process.version,
  };
}

function result(name, mutate) {
  const specimen = bundle();
  mutate(specimen);
  try {
    validateCensusBundle(specimen);
    return { name, accepted: true, message: "" };
  } catch (error) {
    return { name, accepted: false, message: String(error) };
  }
}

function includeBundle(command, targetSyntax, directive, targetRaw, invocationArgument) {
  const raw = `\\${command}${targetSyntax}`;
  const specimen = bundle();
  const buffer = Buffer.from(raw, "utf8");
  const source = specimen.sources[0];
  source.sha256 = digest(buffer);
  source.bytes = buffer.length;
  source.lengthUtf16 = raw.length;
  specimen.treeSha256 = treeDigest(source);
  specimen.rawBuffers.set(source.id, buffer);
  specimen.rawContents.set(source.id, raw);
  specimen.coverage[0] = {
    sourceId: source.id, lengthUtf16: raw.length, claimedUtf16: raw.length, residueUtf16: 0, residue: [],
  };
  const site = span(0, command.length + 1);
  const entity = {
    id: `ent:include@main.tex:0-${raw.length}`,
    kind: "include", directive, targetRaw, span: span(0, raw.length),
    spanProvenance: "lexical",
    witnesses: [{ witness: "lexical", span: site, spanRole: "token" }],
    agreement: "agreed", agreementBasis: "single-authority",
  };
  specimen.entities = [entity];
  const event = specimen.bindings[1];
  event.symbol.name = command;
  event.installedMeaning.name = command;
  event.installedMeaning.signature = { state: "known", spec: "m" };
  const invocation = specimen.invocations[0];
  invocation.entityId = entity.id;
  invocation.name = command;
  invocation.siteSpan = site;
  invocation.binding.signature = { state: "known", spec: "m" };
  invocation.span = span(0, raw.length);
  invocation.arguments = [invocationArgument];
  invocation.text = raw;
  return specimen;
}

function validationResult(specimen) {
  try {
    validateCensusBundle(specimen);
    return { accepted: true, message: "" };
  } catch (error) {
    return { accepted: false, message: String(error) };
  }
}

function catcodeArgumentBundle() {
  const raw = String.raw`\foo\a@b`;
  const specimen = bundle();
  const buffer = Buffer.from(raw, "utf8");
  const source = specimen.sources[0];
  source.sha256 = digest(buffer);
  source.bytes = buffer.length;
  source.lengthUtf16 = raw.length;
  specimen.treeSha256 = treeDigest(source);
  specimen.rawBuffers.set(source.id, buffer);
  specimen.rawContents.set(source.id, raw);
  specimen.coverage[0] = {
    sourceId: source.id, lengthUtf16: raw.length, claimedUtf16: raw.length, residueUtf16: 0, residue: [],
  };
  specimen.entities.push({
    id: "ent:macro-invocation@main.tex:4-8", kind: "macro-invocation", name: "a@b", span: span(4, 8),
    spanProvenance: "lexical",
    witnesses: [{ witness: "lexical", span: span(4, 8), spanRole: "token" }],
    agreement: "agreed", agreementBasis: "single-authority",
  });
  const invocation = specimen.invocations[0];
  invocation.span = span(0, 8);
  invocation.arguments[1] = {
    slot: 1, kind: "mandatory", source: "explicit", delimiter: "control-sequence",
    span: span(4, 8), contentSpan: span(4, 8),
  };
  invocation.text = raw;
  return specimen;
}

const cases = [];
cases.push(result("closed-diagnostic", (value) => value.diagnostics.push({
  code: "census/residue", severity: "warning", message: "probe", extra: true,
})));
cases.push(result("missing-diagnostic-message", (value) => value.diagnostics.push({
  code: "census/residue", severity: "warning",
})));
cases.push(result("invalid-diagnostic-severity", (value) => value.diagnostics.push({
  code: "census/residue", severity: "fatal", message: "probe",
})));
cases.push(result("restore-field", (value) => {
  value.bindings[1].restoredBindingEventId = value.bindings[1].id;
}));
cases.push(result("relabeled-baseline", (value) => {
  value.bindings[1].installedMeaning.name = "bar";
}));
cases.push(result("restore-correlation", (value) => {
  const event = value.bindings[1];
  event.operation = "restore";
  event.effect = "restored";
  event.cause = { kind: "scope-exit", scopeId: "scope:probe-document" };
  event.executionScopeId = "scope:probe-document";
  event.targetScopeId = "scope:probe-global";
  event.restoredBindingEventId = event.id;
}));
cases.push(result("carrier-name", (value) => {
  value.invocations[0].name = "bar";
}));
cases.push(result("stale-binding", (value) => {
  const original = value.bindings[1];
  value.bindings.push({
    rowType: "binding-event", id: "bind:probe-later", seq: 4,
    executionScopeId: "scope:probe-document", targetScopeId: "scope:probe-global",
    symbol: { namespace: "control-sequence", name: "foo" },
    cause: { kind: "baseline" }, operation: "baseline-install", effect: "installed",
    priorBindingEventId: original.id,
    installedMeaning: { kind: "primitive", name: "foo", signature },
  });
  value.invocations[0].seq = 5;
  value.bindings[2].exitSeq = 6;
  value.bindings[0].exitSeq = 7;
  value.occurrences[0].exitSeq = 8;
}));
cases.push(result("attachment", (value) => {
  value.invocations[0].span = span(0, 4);
  value.invocations[0].arguments = [];
  value.invocations[0].text = String.raw`\foo`;
}));
cases.push(result("default-vs-omitted", (value) => {
  const argument = value.invocations[0].arguments[0];
  argument.source = "omitted";
  delete argument.defaultText;
}));
cases.push(result("unbound-current", (value) => {
  const invocation = value.invocations[0];
  invocation.binding = { state: "unbound" };
  invocation.status = "unbound";
  invocation.span = span(0, 4);
  invocation.arguments = [];
  invocation.text = String.raw`\foo`;
}));
cases.push(result("indeterminate-current", (value) => {
  const invocation = value.invocations[0];
  invocation.binding = { state: "indeterminate", causeIds: ["bind:bogus"], detail: "bogus" };
  invocation.status = "indeterminate";
  invocation.span = span(0, 4);
  invocation.arguments = [];
  invocation.text = String.raw`\foo`;
}));
cases.push(result("deferred-hull", (value) => {
  value.invocations[0].binding = { state: "deferred", reason: "argument-body" };
  value.invocations[0].status = "deferred";
}));
let valid = { accepted: true, message: "" };
try {
  validateCensusBundle(bundle());
} catch (error) {
  valid = { accepted: false, message: String(error) };
}
const bareInput = validationResult(includeBundle(
  "input", "leaf.tex", "input", "leaf.tex",
  { slot: 0, kind: "until", source: "explicit", delimiter: "none", span: span(6, 14), contentSpan: span(6, 14) }
));
const bracedSubfile = validationResult(includeBundle(
  "subfile", "{leaf}", "include", "leaf",
  { slot: 0, kind: "mandatory", source: "explicit", delimiter: "brace", span: span(8, 14), contentSpan: span(9, 13) }
));
const catcodeArgument = validationResult(catcodeArgumentBundle());
console.log(JSON.stringify({ valid, bareInput, bracedSubfile, catcodeArgument, cases }));
'@.Replace('__EMIT_URI__', $emitUri)

            $probeOutput = @(& $script:ResolvedNodePath --input-type=module --eval $probe 2>&1)
            $probeExitCode = $LASTEXITCODE
            $global:LASTEXITCODE = 0
            $probeExitCode | Should -Be 0
            $payload = ($probeOutput -join "`n") | ConvertFrom-Json
            $payload.valid.accepted | Should -BeTrue -Because $payload.valid.message
            $payload.bareInput.accepted | Should -BeTrue -Because $payload.bareInput.message
            $payload.bracedSubfile.accepted | Should -BeTrue -Because $payload.bracedSubfile.message
            $payload.catcodeArgument.accepted | Should -BeTrue -Because $payload.catcodeArgument.message
            $results = $payload.cases

            @($results | Where-Object accepted).Count | Should -Be 0
            (@($results | Where-Object name -eq 'closed-diagnostic')[0].message) |
                Should -Match "unsupported field 'extra'"
            (@($results | Where-Object name -eq 'missing-diagnostic-message')[0].message) |
                Should -Match "missing required field 'message'"
            (@($results | Where-Object name -eq 'invalid-diagnostic-severity')[0].message) |
                Should -Match "invalid 'severity' value 'fatal'"
            (@($results | Where-Object name -eq 'restore-field')[0].message) |
                Should -Match 'restoredBindingEventId outside a restore operation'
            (@($results | Where-Object name -eq 'relabeled-baseline')[0].message) |
                Should -Match 'baseline meaning contradicts its symbol'
            (@($results | Where-Object name -eq 'restore-correlation')[0].message) |
                Should -Match 'invalid restored binding correlation'
            (@($results | Where-Object name -eq 'carrier-name')[0].message) |
                Should -Match 'contradicts its exact physical carrier'
            (@($results | Where-Object name -eq 'stale-binding')[0].message) |
                Should -Match 'does not name its current governing binding'
            (@($results | Where-Object name -eq 'attachment')[0].message) |
                Should -Match 'attachment contradicts exact source and signature'
            (@($results | Where-Object name -eq 'default-vs-omitted')[0].message) |
                Should -Match 'attachment contradicts exact source and signature'
            (@($results | Where-Object name -eq 'unbound-current')[0].message) |
                Should -Match 'reports unbound despite a current binding'
            (@($results | Where-Object name -eq 'indeterminate-current')[0].message) |
                Should -Match 'indeterminate evidence contradicts current binding state'
            (@($results | Where-Object name -eq 'deferred-hull')[0].message) |
                Should -Match 'non-bound state is not token-only'
        }
    }
}
