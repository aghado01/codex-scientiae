BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:Node = (Get-Command node -ErrorAction Stop).Source
    $script:GraphModule = Join-Path $script:RepositoryRoot 'src/TeXdig/census/source-graph.ts'
    $script:CliModule = Join-Path $script:RepositoryRoot 'src/TeXdig/cli/census.ts'
    $script:StratifyModule = Join-Path $script:RepositoryRoot 'src/TeXdig/census/stratify.ts'
    $script:DirectiveModule = Join-Path $script:RepositoryRoot 'src/TeXdig/census/scan-directives.ts'
    $script:FingerprintModule = Join-Path $script:RepositoryRoot 'src/TeXdig/census/source-fingerprint.ts'

    $script:GraphProbe = @'
import { pathToFileURL } from "node:url";
const { buildSourceGraph } = await import(pathToFileURL(process.argv[1]).href);
const graph = buildSourceGraph(process.argv[2], process.argv[3]);
console.log(JSON.stringify({
  treeSha256: graph.treeSha256,
  treeFileCount: graph.treeFileCount,
  sources: graph.sources,
  bufferedSources: [...graph.rawBuffers.keys()],
  decodedSources: [...graph.rawContents.keys()],
  edges: graph.includeEdges.map((edge) => ({
    from: edge.fromSourceId,
    to: edge.toSourceId,
    directive: edge.directive,
    targetRaw: edge.targetRaw,
    span: edge.span,
    targetSpan: edge.targetSpan,
  })),
  stratifiedSources: [...graph.stratifications.keys()],
  diagnostics: graph.diagnostics,
}));
'@

    $script:StratifyProbe = @'
import { pathToFileURL } from "node:url";
const { stratify } = await import(pathToFileURL(process.argv[1]).href);
const { scanDirectives } = await import(pathToFileURL(process.argv[2]).href);
const raw = Buffer.from(process.argv[3], "base64").toString("utf8");
const result = stratify("probe.tex", raw, { dialect: process.argv[4] });
console.log(JSON.stringify({
  strata: result.strata,
  stratifiedText: result.stratifiedText,
  diagnostics: result.diagnostics,
  directives: scanDirectives("probe.tex", result.stratifiedText),
}));
'@

    $script:WorkerProbe = @'
import { pathToFileURL } from "node:url";
const { runCensus } = await import(pathToFileURL(process.argv[1]).href + "?source-fidelity-probe");
await runCensus({
  articleDir: process.argv[2],
  depsDir: process.argv[3],
  outDir: process.argv[4],
});
'@

    function Invoke-SourceNode {
        param(
            [Parameter(Mandatory)] [string] $Script,
            [Parameter(Mandatory)] [string[]] $ArgumentList,
            [switch] $AllowFailure
        )
        $output = @(& $script:Node --input-type=module -e $Script @ArgumentList 2>&1)
        $exitCode = $LASTEXITCODE
        $global:LASTEXITCODE = 0
        $text = ($output | ForEach-Object { $_.ToString() }) -join "`n"
        if ($exitCode -ne 0 -and -not $AllowFailure) {
            throw "Node probe failed ($exitCode): $text"
        }
        return [pscustomobject]@{ ExitCode = $exitCode; Text = $text }
    }

    function Get-SourceGraphProbe {
        param(
            [Parameter(Mandatory)] [string] $Tree,
            [Parameter(Mandatory)] [string] $Entrypoint
        )
        $probe = Invoke-SourceNode -Script $script:GraphProbe -ArgumentList @(
            $script:GraphModule, $Tree, $Entrypoint
        )
        return $probe.Text | ConvertFrom-Json
    }

    function New-SourceTreeFixture {
        param(
            [Parameter(Mandatory)] [string] $Name,
            [Parameter(Mandatory)] [hashtable] $Files
        )
        $root = Join-Path $TestDrive $Name
        [void][System.IO.Directory]::CreateDirectory($root)
        foreach ($entry in $Files.GetEnumerator()) {
            $full = Join-Path $root $entry.Key
            $parent = [System.IO.Path]::GetDirectoryName($full)
            if ($parent) { [void][System.IO.Directory]::CreateDirectory($parent) }
            if ($entry.Value -is [byte[]]) {
                [System.IO.File]::WriteAllBytes($full, $entry.Value)
            } else {
                [System.IO.File]::WriteAllText(
                    $full,
                    [string]$entry.Value,
                    [System.Text.UTF8Encoding]::new($false, $true)
                )
            }
        }
        return $root
    }

    function Get-StratifyProbe {
        param(
            [Parameter(Mandatory)] [string] $Text,
            [ValidateSet('latex', 'biblatex-bbl')] [string] $Dialect = 'latex'
        )
        $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Text))
        $probe = Invoke-SourceNode -Script $script:StratifyProbe -ArgumentList @(
            $script:StratifyModule, $script:DirectiveModule, $encoded, $Dialect
        )
        return $probe.Text | ConvertFrom-Json
    }
}

Describe 'TeXdig source fidelity boundary' -Tag 'TeXdig', 'SourceFidelity' {
    It 'uses the canonical ordinal tree witness and exposes the buffered fixture identity' {
        $fingerprintScript = @'
import { pathToFileURL } from "node:url";
const { computeSourceTreeSha256 } = await import(pathToFileURL(process.argv[1]).href);
console.log(computeSourceTreeSha256([
  { path: "b", bytes: 2, sha256: "b".repeat(64) },
  { path: "a", bytes: 1, sha256: "a".repeat(64) },
]));
'@
        $fingerprint = Invoke-SourceNode -Script $fingerprintScript -ArgumentList @($script:FingerprintModule)
        $fingerprint.Text | Should -Be 'b228a7aa41046c63d5d8d015450215a94ba261d82d89858089856f99fcba7018'

        $article = Join-Path $script:RepositoryRoot 'tests/fixtures/texdig/mini_article'
        $tree = Join-Path $article 'mini_article-tex'
        $graph = Get-SourceGraphProbe -Tree $tree -Entrypoint 'main.tex'
        $manifest = Get-Content -LiteralPath (Join-Path $article 'article.json') -Raw | ConvertFrom-Json
        $treeForm = $manifest.source_forms | Where-Object role -eq 'latex-source-tree'

        $graph.treeSha256 | Should -Be $treeForm.sha256
        $graph.treeFileCount | Should -Be 7
        (@($graph.sources.id) -join '|') | Should -Be 'defects.tex|extra.bib|intro.tex|main.bbl|main.tex|refs.bib|unreachable.tex'
    }

    It 'resolves literal directives from the compile root and promotes exact reached targets' {
        $tree = New-SourceTreeFixture -Name 'root-resolution' -Files @{
            'main.tex'      = "\input{sub/outer}`n\input {fragment.data}`n\addbibresource[location=local] {refs.data}`n"
            'sub/outer.tex' = "\input{leaf}`n"
            'leaf.tex'      = 'root leaf'
            'sub/leaf.tex'  = 'sibling leaf'
            'fragment.data' = '\section{Extensionless semantics}'
            'refs.data'     = '@article{key,title={A}}'
            'image.bin'     = [byte[]](0x00, 0xff, 0x01)
        }
        $graph = Get-SourceGraphProbe -Tree $tree -Entrypoint 'main.tex'

        $outerEdge = $graph.edges | Where-Object { $_.from -eq 'main.tex' -and $_.targetRaw -eq 'sub/outer' }
        $outerEdge.to | Should -Be 'sub/outer.tex'
        $nestedEdge = $graph.edges | Where-Object { $_.from -eq 'sub/outer.tex' -and $_.targetRaw -eq 'leaf' }
        $nestedEdge.to | Should -Be 'leaf.tex'

        $fragment = $graph.sources | Where-Object id -eq 'fragment.data'
        $fragment.language | Should -Be 'latex'
        $fragment.role | Should -Be 'included'
        $fragment.parsed | Should -BeTrue
        $graph.stratifiedSources | Should -Contain 'fragment.data'

        $bib = $graph.sources | Where-Object id -eq 'refs.data'
        $bib.language | Should -Be 'bibtex'
        $bib.role | Should -Be 'bibliography-resource'
        $bib.parsed | Should -BeTrue

        foreach ($parsed in @($graph.sources | Where-Object parsed)) {
            $parsed.PSObject.Properties['lengthUtf16'] | Should -Not -BeNullOrEmpty
        }
        $asset = $graph.sources | Where-Object id -eq 'image.bin'
        $asset.bytes | Should -Be 3
        $asset.PSObject.Properties['lengthUtf16'] | Should -BeNullOrEmpty
    }

    It 'recognizes whitespace and optional directive syntax while rejecting out-of-root spellings' {
        $tree = New-SourceTreeFixture -Name 'directive-syntax' -Files @{
            'main.tex' = "\input {./safe}`n\include {chapter}`n\addbibresource [datatype=bibtex] {refs.bib}`n\input{../escape}`n\input{C:/drive}`n"
            'safe.tex' = 'safe'
            'chapter.tex' = 'chapter'
            'refs.bib' = '@article{x,title={X}}'
        }
        $graph = Get-SourceGraphProbe -Tree $tree -Entrypoint 'main.tex'

        ($graph.edges | Where-Object targetRaw -eq './safe').to | Should -Be 'safe.tex'
        ($graph.edges | Where-Object targetRaw -eq 'chapter').to | Should -Be 'chapter.tex'
        ($graph.edges | Where-Object targetRaw -eq 'refs.bib').to | Should -Be 'refs.bib'
        ($graph.edges | Where-Object targetRaw -eq '../escape').PSObject.Properties['to'] | Should -BeNullOrEmpty
        ($graph.edges | Where-Object targetRaw -eq 'C:/drive').PSObject.Properties['to'] | Should -BeNullOrEmpty
        @($graph.diagnostics | Where-Object code -eq 'census/unresolved-include').Count | Should -Be 2
    }

    It 'keeps active alltt commands but masks comments and opaque verbatim with exact spans' {
        $raw = @'
% \input{commented}
\verb{\input{inline-hidden}{
\begin {verbatim}\input{block-hidden}\end {verbatim}
\begin{alltt}
percent % literal \input {live}
$literal$ _ ^
\end{alltt}
'@
        $probe = Get-StratifyProbe -Text $raw

        $probe.stratifiedText.Length | Should -Be $raw.Length
        (@($probe.strata.kind) -join '|') | Should -Be 'comment|verbatim-inline|verbatim|alltt'
        @($probe.directives).Count | Should -Be 1
        $probe.directives[0].targets[0].targetRaw | Should -Be 'live'
        $site = $probe.directives[0].span
        $raw.Substring($site.startUtf16, $site.endUtf16 - $site.startUtf16) | Should -Be '\input {live}'

        $alltt = $probe.strata | Where-Object kind -eq 'alltt'
        $maskedAlltt = $probe.stratifiedText.Substring(
            $alltt.span.startUtf16,
            $alltt.span.endUtf16 - $alltt.span.startUtf16
        )
        $maskedAlltt | Should -Not -Match '[%$^_]'
    }

    It 'distinguishes ordinary brace-delimited verb from biblatex bbl field syntax' {
        $raw = '\verb{field} \input{visible} \endverb'
        $latex = Get-StratifyProbe -Text $raw -Dialect latex
        $bbl = Get-StratifyProbe -Text $raw -Dialect biblatex-bbl

        @($latex.strata | Where-Object kind -eq 'verbatim-inline').Count | Should -Be 1
        @($latex.directives).Count | Should -Be 0
        @($bbl.strata).Count | Should -Be 0
        $bbl.directives[0].targets[0].targetRaw | Should -Be 'visible'
    }

    It 'refuses malformed UTF-8 when an extensionless source becomes reachable' {
        $tree = New-SourceTreeFixture -Name 'invalid-reached-utf8' -Files @{
            'main.tex' = '\input{fragment}'
            'fragment' = [byte[]](0xff, 0xfe)
        }
        $failure = Invoke-SourceNode -Script $script:GraphProbe -ArgumentList @(
            $script:GraphModule, $tree, 'main.tex'
        ) -AllowFailure

        $failure.ExitCode | Should -Not -Be 0
        $failure.Text | Should -Match "Source 'fragment' is not valid UTF-8"
    }

    It 'byte-inventories malformed unreached typed files without decoding them' {
        $tree = New-SourceTreeFixture -Name 'invalid-unreached-typed' -Files @{
            'main.tex' = '\documentclass{article}'
            'legacy.sty' = [byte[]](0xff, 0xfe, 0xfd)
            'stale.bib' = [byte[]](0xc3, 0x28)
        }
        $graph = Get-SourceGraphProbe -Tree $tree -Entrypoint 'main.tex'

        (@($graph.bufferedSources) -join '|') | Should -Be 'legacy.sty|main.tex|stale.bib'
        (@($graph.decodedSources) -join '|') | Should -Be 'main.tex'
        foreach ($id in @('legacy.sty', 'stale.bib')) {
            $source = $graph.sources | Where-Object id -eq $id
            $source.parsed | Should -BeFalse
            $source.bytes | Should -BeGreaterThan 0
            $source.PSObject.Properties['lengthUtf16'] | Should -BeNullOrEmpty
        }
    }

    It 'refuses an escaping manifest tree path in the worker without schema validation' {
        $root = Join-Path $TestDrive 'worker-tree-escape'
        $article = Join-Path $root 'article'
        $outside = Join-Path $root 'outside-tree'
        [void][System.IO.Directory]::CreateDirectory($article)
        [void][System.IO.Directory]::CreateDirectory($outside)
        [System.IO.File]::WriteAllText((Join-Path $outside 'main.tex'), 'outside')
        @{
            slug = 'escape'
            source_forms = @(@{
                role = 'latex-source-tree'
                path = '../outside-tree'
                entrypoint = 'main.tex'
                files = 1
                sha256 = '0' * 64
            })
        } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $article 'article.json')

        $out = Join-Path $root 'out'
        $failure = Invoke-SourceNode -Script $script:WorkerProbe -ArgumentList @(
            $script:CliModule, $article, (Join-Path $root 'unused-deps'), $out
        ) -AllowFailure

        $failure.ExitCode | Should -Not -Be 0
        $failure.Text | Should -Match 'source-tree path must be a portable relative descendant'
        Test-Path -LiteralPath $out | Should -BeFalse
    }

    It 'refuses a missing manifest tree path instead of guessing the conventional directory' {
        $root = Join-Path $TestDrive 'worker-tree-path-missing'
        $article = Join-Path $root 'article'
        $tree = Join-Path $article 'missing_path-tex'
        [void][System.IO.Directory]::CreateDirectory($tree)
        [System.IO.File]::WriteAllText((Join-Path $tree 'main.tex'), 'plausible guessed tree')
        @{
            slug = 'missing_path'
            source_forms = @(@{
                role = 'latex-source-tree'
                entrypoint = 'main.tex'
                files = 1
                sha256 = '0' * 64
            })
        } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $article 'article.json')

        $out = Join-Path $root 'out'
        $failure = Invoke-SourceNode -Script $script:WorkerProbe -ArgumentList @(
            $script:CliModule, $article, (Join-Path $root 'unused-deps'), $out
        ) -AllowFailure

        $failure.ExitCode | Should -Not -Be 0
        $failure.Text | Should -Match 'source-tree path must be a portable relative descendant'
        Test-Path -LiteralPath $out | Should -BeFalse
    }

    It 'refuses a manifest source-tree root that is a junction or symbolic link' {
        $root = Join-Path $TestDrive 'worker-tree-reparse'
        $article = Join-Path $root 'article'
        $target = Join-Path $root 'physical-tree'
        $link = Join-Path $article 'linked-tree'
        [void][System.IO.Directory]::CreateDirectory($article)
        [void][System.IO.Directory]::CreateDirectory($target)
        [System.IO.File]::WriteAllText((Join-Path $target 'main.tex'), 'outside')
        try {
            $null = New-Item -ItemType Junction -Path $link -Target $target -ErrorAction Stop
        } catch {
            Set-ItResult -Skipped -Because "This filesystem cannot create a test junction: $($_.Exception.Message)"
            return
        }
        @{
            slug = 'reparse'
            source_forms = @(@{
                role = 'latex-source-tree'
                path = 'linked-tree'
                entrypoint = 'main.tex'
                files = 1
                sha256 = '0' * 64
            })
        } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $article 'article.json')

        $out = Join-Path $root 'out'
        $failure = Invoke-SourceNode -Script $script:WorkerProbe -ArgumentList @(
            $script:CliModule, $article, (Join-Path $root 'unused-deps'), $out
        ) -AllowFailure

        $failure.ExitCode | Should -Not -Be 0
        $failure.Text | Should -Match 'reparse point \(symlink/junction\)'
        Test-Path -LiteralPath $out | Should -BeFalse
    }
}
