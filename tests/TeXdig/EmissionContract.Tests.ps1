BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:FixtureDir = Join-Path $script:RepositoryRoot 'tests/fixtures/texdig/mini_article'
    $script:NodePath = (Get-Command node -CommandType Application -ErrorAction Stop).Source
    $script:ResolvedNodePath = (Resolve-Path -LiteralPath $script:NodePath).Path
    $script:ExpectedNodeVersion = ((& $script:ResolvedNodePath --version 2>&1) -join "`n").Trim()
    $script:ExpectedStoreSchemas = [ordered]@{
        'sources.jsonl' = 'codex-scientiae/texdig-sources/0.2'
        'entities.jsonl' = 'codex-scientiae/texdig-entities/0.2'
        'claims.jsonl' = 'codex-scientiae/texdig-claims/0.2'
        'coverage.json' = 'codex-scientiae/texdig-coverage/0.2'
        'diagnostics.jsonl' = 'codex-scientiae/texdig-diagnostics/0.2'
        'summary.json' = 'codex-scientiae/texdig-summary/0.2'
    }
    $script:ExpectedDeferredStores = @(
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
            $summary.schema | Should -BeExactly 'texdig-census/0.2'
            $summary.runtime.node | Should -BeExactly $script:ExpectedNodeVersion
            @($summary.storeSchemas.PSObject.Properties).Count |
                Should -Be $script:ExpectedStoreSchemas.Count
            foreach ($store in $script:ExpectedStoreSchemas.Keys) {
                $property = @($summary.storeSchemas.PSObject.Properties |
                    Where-Object { $_.Name -ceq $store })
                $property.Count | Should -Be 1
                $property[0].Value | Should -BeExactly $script:ExpectedStoreSchemas[$store]
            }
            (@($summary.stores.deferred) -join '|') |
                Should -BeExactly ($script:ExpectedDeferredStores -join '|')
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
                schema = 'texdig-census/0.2'
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
                schema = 'texdig-census/0.2'
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
                schema = 'texdig-census/0.2'
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
                schema = 'texdig-census/0.2'
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
                schema = 'texdig-census/0.2'
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
                schema = 'texdig-census/0.2'
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
                schema = 'texdig-census/0.2'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{ emitted = @($script:ExpectedStoreSchemas.Keys) + @('extra.jsonl') }
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
                schema = 'texdig-census/0.2'
                runtime = @{ node = $script:ExpectedNodeVersion }
                storeSchemas = $script:ExpectedStoreSchemas
                stores = @{
                    emitted = @($script:ExpectedStoreSchemas.Keys)
                    deferred = @()
                }
            } | ConvertTo-Json -Depth 4 |
                Set-Content -LiteralPath (Join-Path $outDir 'summary.json')

            { Read-TeXdigPublishedSummary -RunDirectory $outDir -ExpectedSlug 'mini_article' `
                    -ExpectedNodeVersion $script:ExpectedNodeVersion } |
                Should -Throw '*incompatible deferred-store contract*'
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
  return {
    slug: "probe",
    treeSha256: treeDigest([source]),
    entrypoint: sourceId,
    sources: [source],
    entities: [],
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
    }
}
