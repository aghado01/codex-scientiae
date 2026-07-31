#requires -Version 7.0
# Tests for src/reader-mcp/reader-mcp.ps1 — the consumer-side read-only MCP server.
# Driven as a CHILD PROCESS over real JSON-RPC frames: the protocol surface is what consumers see, and
# dot-sourcing the script would both start its stdin loop and hide the self-containment guarantee.

Describe 'reader-mcp — bundle discovery, byte-span reads, read-only surface' {
    BeforeAll {
        $script:Server = (Resolve-Path "$PSScriptRoot/../src/reader-mcp/reader-mcp.ps1").Path
        $script:Fixture = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString('N'))
        $u8 = [System.Text.UTF8Encoding]::new($false)

        # a standard single-doc bundle, built the way the toc-engine emits one
        $bundle = Join-Path $script:Fixture 'demo-01'
        New-Item -ItemType Directory -Force -Path (Join-Path $bundle 'images') | Out-Null
        # deliberately non-ASCII: the en-dash is 3 UTF-8 bytes, so a naive slice can split it
        $md = "# Demo Paper`n`n## Abstract`n`nThe Moore–Penrose inverse.`n`n## Methods`n`nMethod prose here.`n"
        [System.IO.File]::WriteAllText((Join-Path $bundle 'demo-01.md'), $md, $u8)
        [System.IO.File]::WriteAllBytes((Join-Path $bundle 'images/fig.png'), [byte[]](137, 80, 78, 71))

        # spans computed from the real bytes so the fixture cannot drift from its own index
        $bytes = $u8.GetBytes($md)
        $offAbstract = $u8.GetByteCount("# Demo Paper`n`n")
        $offMethods = $u8.GetByteCount("# Demo Paper`n`n## Abstract`n`nThe Moore–Penrose inverse.`n`n")
        $rows = @(
            @{ level = 2; heading = 'Abstract'; anchor = 'abstract'; byte_start = $offAbstract; byte_end = $offMethods; byte_width = ($offMethods - $offAbstract); relative_link = 'demo-01.md#abstract' }
            @{ level = 2; heading = 'Methods'; anchor = 'methods'; byte_start = $offMethods; byte_end = $bytes.Length; byte_width = ($bytes.Length - $offMethods); relative_link = 'demo-01.md#methods' }
        ) | ForEach-Object { $_ | ConvertTo-Json -Compress }
        [System.IO.File]::WriteAllText((Join-Path $bundle 'demo-01.toc.jsonl'), (($rows -join "`n") + "`n"), $u8)
        [System.IO.File]::WriteAllText((Join-Path $bundle 'demo-01-tree.md'),
            "---`ntitle: `"Demo Paper`"`nauthors: `"Ada Lovelace`"`ndoi: `"10.1234/demo`"`ntotal_bytes: $($bytes.Length)`nsection_count: 2`n---`n`n# Document Tree Manifest: demo-01`n", $u8)

        # a directory holding a bare .md is NOT a bundle — no sidecar, nothing to address by span
        $loose = Join-Path $script:Fixture 'not-a-bundle'
        New-Item -ItemType Directory -Force -Path $loose | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $loose 'stray.md'), "# Stray`n", $u8)

        $script:MethodsOffset = $offMethods

        function script:Invoke-Reader([string[]]$Calls) {
            $frames = @('{"jsonrpc":"2.0","id":0,"method":"initialize","params":{}}') + $Calls
            $out = ($frames -join "`n") | pwsh -NoProfile -File $script:Server -Root $script:Fixture 2>$null
            $parsed = @()
            foreach ($l in @($out)) { if ($l -is [string] -and $l.StartsWith('{')) { $parsed += ($l | ConvertFrom-Json) } }
            return $parsed
        }
        function script:Payload($frame) { return ($frame.result.content[0].text | ConvertFrom-Json) }
    }
    AfterAll {
        Remove-Item -LiteralPath $script:Fixture -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'discovers bundles by their .toc.jsonl and ignores directories that only hold markdown' {
        $r = Invoke-Reader @('{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"list_documents","arguments":{}}}')
        $docs = Payload $r[1]
        $docs.count | Should -Be 1
        $docs.documents[0].slug | Should -Be 'demo-01'
        # frontmatter is surfaced, so a consumer can triage without opening the manuscript
        $docs.documents[0].title | Should -Be 'Demo Paper'
        $docs.documents[0].authors | Should -Be 'Ada Lovelace'
        $docs.documents[0].doi | Should -Be '10.1234/demo'
    }

    It 'get_manifest returns the section index with spans and the asset list' {
        $r = Invoke-Reader @('{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"get_manifest","arguments":{"slug":"demo-01"}}}')
        $m = Payload $r[1]
        $m.section_count | Should -Be 2
        $m.sections[0].anchor | Should -Be 'abstract'
        $m.sections[1].byte_start | Should -Be $m.sections[0].byte_end   # contiguous: no unaddressable text
        $m.assets | Should -Contain 'images/fig.png'
    }

    It 'read_section resolves an anchor to its span and returns a self-describing slice' {
        $r = Invoke-Reader @('{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"read_section","arguments":{"slug":"demo-01","anchor":"abstract"}}}')
        $s = Payload $r[1]
        $s.heading | Should -Be 'Abstract'
        $s.sections_read | Should -Be 1
        $s.text | Should -Match '^## Abstract'      # the slice carries its own heading
        $s.text | Should -Match 'Moore–Penrose'
        $s.text | Should -Not -Match 'Method prose' # and stops at the next section
    }

    It 'read_section -following extends through subsequent sections in document order' {
        $r = Invoke-Reader @('{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"read_section","arguments":{"slug":"demo-01","anchor":"abstract","following":1}}}')
        $s = Payload $r[1]
        $s.sections_read | Should -Be 2
        $s.text | Should -Match 'Method prose'
    }

    It 'read_span snaps a mid-codepoint boundary outward instead of emitting replacement characters' {
        # the en-dash in "Moore–Penrose" is 3 bytes; aim the start one byte into it
        $u8 = [System.Text.UTF8Encoding]::new($false)
        $prefix = "# Demo Paper`n`n## Abstract`n`nThe Moore"
        $inside = $u8.GetByteCount($prefix) + 1                            # 1 byte into the en-dash
        $call = '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"read_span","arguments":{"slug":"demo-01","byte_start":' + $inside + ',"byte_end":' + ($inside + 20) + '}}}'
        $r = Invoke-Reader @($call)
        $p = Payload $r[1]
        $p.snapped | Should -BeTrue
        $p.byte_start | Should -BeLessThan $inside                          # walked BACK to the lead byte
        $p.text | Should -Not -Match ([char]0xFFFD)                         # no U+FFFD anywhere
        $p.text | Should -Match '^–'                                        # the whole en-dash survived
    }

    It 'search_headings returns matches with spans so a hit can be read immediately' {
        $r = Invoke-Reader @('{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"search_headings","arguments":{"query":"method"}}}')
        $h = Payload $r[1]
        $h.count | Should -Be 1
        $h.matches[0].anchor | Should -Be 'methods'
        $h.matches[0].byte_width | Should -BeGreaterThan 0
    }

    It 'unknown slug and unknown anchor fail with actionable errors, not silence' {
        $r = Invoke-Reader @(
            '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"get_manifest","arguments":{"slug":"ghost"}}}'
            '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"read_section","arguments":{"slug":"demo-01","anchor":"ghost"}}}'
        )
        $r[1].result.isError | Should -BeTrue
        $r[1].result.content[0].text | Should -Match "no bundle 'ghost'"
        $r[1].result.content[0].text | Should -Match 'known: demo-01'      # names what IS available
        $r[2].result.isError | Should -BeTrue
        $r[2].result.content[0].text | Should -Match 'call get_manifest'   # says how to recover
    }

    It 'is READ-ONLY: the server carries no write path at all' {
        # the consumer plane must not be able to mutate the corpus even by accident — codex-membrane is
        # the only writer. Guarding the source directly, because a missing write is invisible in behaviour.
        $src = [System.IO.File]::ReadAllText($script:Server, [System.Text.UTF8Encoding]::new($false))
        foreach ($writer in 'Set-Content', 'Out-File', 'Add-Content', 'New-Item', 'Remove-Item', 'Move-Item', 'Copy-Item', 'WriteAllText', 'WriteAllBytes', 'WriteAllLines') {
            $src | Should -Not -Match ([regex]::Escape($writer))
        }
    }

    It 'is SELF-CONTAINED: it dot-sources nothing, so it can be installed outside the repo' {
        $src = [System.IO.File]::ReadAllText($script:Server, [System.Text.UTF8Encoding]::new($false))
        $src | Should -Not -Match '(?m)^\s*\.\s+"?\$PSScriptRoot'
        $src | Should -Not -Match 'Import-Module'
    }
}
