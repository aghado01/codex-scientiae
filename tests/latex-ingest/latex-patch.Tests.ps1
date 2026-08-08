#requires -Version 7.0
# Per-paper patch lane (curated errata) — the durable home for repair-tier corrections that survive
# regeneration. The converter stays FAITHFUL by default (no patch file → pure no-op); a per-paper
# {slug}-latex.patch.jsonl supplies human-authored, JUSTIFIED, occurrence-GUARDED corrections that
# re-apply on every latex_convert. A stale patch (matches nothing / a count that no longer holds) must
# fail LOUDLY, not silently no-op. Anchored on the real defect this lane was built for: 2403.08110v4's
# undefined \vect (author uses it in Remark 8.1 but only ever defines \vecsp = \mathbf{vec}_{\mathbb{F}}).

BeforeAll {
    . "$PSScriptRoot/../../src/latex-ingest/latex-ingest.ps1"

    function New-PatchFile {
        param([string]$Slug, [string[]]$Lines)
        $p = Join-Path $TestDrive "$Slug-latex.patch.jsonl"
        [System.IO.File]::WriteAllText($p, ($Lines -join "`n") + "`n", [System.Text.UTF8Encoding]::new($false))
        return $TestDrive
    }

    function Get-TestPatchPath([string]$Slug) {
        return Join-Path $TestDrive "$Slug-latex.patch.jsonl"
    }
}

Describe 'Read-LatexPatchFile' {
    It 'returns empty when there is no patch file (the faithful default)' {
        (Read-LatexPatchFile -Dir $TestDrive -Slug 'no-such-paper') | Should -HaveCount 0
    }
    It 'accepts LF, CRLF, no final newline, blanks, and full-line comments' {
        $json = '{"op":"define_macro","name":"\\vect","body":"\\mathbf{vec}_{\\mathbb{F}}","reason":"undefined in Remark 8.1"}'
        $text = "  # a header comment`r`n`r`n  // another comment`n$json"
        [System.IO.File]::WriteAllText(
            (Get-TestPatchPath 'p1'), $text, [System.Text.UTF8Encoding]::new($false))
        $patches = @(Read-LatexPatchFile -DocumentDir $TestDrive -Slug 'p1')
        $patches | Should -HaveCount 1
        $patches[0].op | Should -Be 'define_macro'
        $patches[0].name | Should -Be '\vect'
        $patches[0].line | Should -Be 4
        $applied = Invoke-LatexSourcePatches -Tex '\vect' -Patches $patches -Slug 'p1'
        $applied.applied | Should -HaveCount 1
    }
    It 'throws on a patch missing its reason (every erratum must be justified)' {
        $dir = New-PatchFile 'p2' @('{"op":"define_macro","name":"\\vect","body":"\\x"}')
        { Read-LatexPatchFile -Dir $dir -Slug 'p2' } | Should -Throw '*missing ''reason''*'
    }
    It 'throws on an unknown op' {
        $dir = New-PatchFile 'p3' @('{"op":"delete_everything","reason":"nope"}')
        { Read-LatexPatchFile -Dir $dir -Slug 'p3' } | Should -Throw '*unknown op*'
    }
    It 'throws on malformed JSON' {
        $dir = New-PatchFile 'p4' @('{"op":"define_macro", not json}')
        { Read-LatexPatchFile -Dir $dir -Slug 'p4' } | Should -Throw '*invalid JSON*'
    }

    It 'rejects BOM, invalid UTF-8, and non-object JSONL values' {
        $valid = [System.Text.UTF8Encoding]::new($false).GetBytes(
            '{"op":"define_macro","name":"\\x","body":"x","reason":"r"}')
        [System.IO.File]::WriteAllBytes(
            (Get-TestPatchPath 'bom'), [byte[]]@(0xEF, 0xBB, 0xBF) + $valid)
        { Read-LatexPatchFile -DocumentDir $TestDrive -Slug 'bom' } |
            Should -Throw '*UTF-8 without a BOM*'

        $invalid = [System.Collections.Generic.List[byte]]::new()
        $invalid.AddRange([System.Text.Encoding]::ASCII.GetBytes(
                '{"op":"define_macro","name":"\\x","body":"x","reason":"'))
        $invalid.Add(0xFF)
        $invalid.AddRange([System.Text.Encoding]::ASCII.GetBytes('"}'))
        [System.IO.File]::WriteAllBytes((Get-TestPatchPath 'invalid-u8'), $invalid.ToArray())
        { Read-LatexPatchFile -DocumentDir $TestDrive -Slug 'invalid-u8' } |
            Should -Throw '*not valid UTF-8*'

        New-PatchFile 'array' @('[{"op":"define_macro","name":"\\x","body":"x","reason":"r"}]') | Out-Null
        { Read-LatexPatchFile -DocumentDir $TestDrive -Slug 'array' } |
            Should -Throw '*must be one object*'

        $nbsp = [string][char]0x00A0
        [System.IO.File]::WriteAllText(
            (Get-TestPatchPath 'unicode-whitespace'),
            $nbsp + '{"op":"define_macro","name":"\\x","body":"x","reason":"r"}' + $nbsp,
            [System.Text.UTF8Encoding]::new($false))
        { Read-LatexPatchFile -DocumentDir $TestDrive -Slug 'unicode-whitespace' } |
            Should -Throw '*invalid JSON*'

        [System.IO.File]::WriteAllBytes(
            (Get-TestPatchPath 'oversize'), [byte[]]::new(1MB + 1))
        { Read-LatexPatchFile -DocumentDir $TestDrive -Slug 'oversize' } |
            Should -Throw '*exceeds the 1 MiB limit*'
    }

    It 'enforces the closed operation schemas and exact field types' {
        $cases = @(
            @{ slug = 'duplicate'; json = '{"op":"define_macro","op":"source_replace","name":"\\x","body":"x","reason":"r"}'; error = '*duplicate or case-colliding*' },
            @{ slug = 'case'; json = '{"op":"define_macro","Op":"define_macro","name":"\\x","body":"x","reason":"r"}'; error = '*duplicate or case-colliding*' },
            @{ slug = 'unknown'; json = '{"op":"source_replace","find":"x","replace":"y","expects":1,"reason":"r"}'; error = "*unknown field 'expects'*" },
            @{ slug = 'op-type'; json = '{"op":1,"reason":"r"}'; error = "*'op' must be a JSON string*" },
            @{ slug = 'reason-type'; json = '{"op":"define_macro","name":"\\x","body":"x","reason":true}'; error = "*'reason' must be a JSON string*" },
            @{ slug = 'body'; json = '{"op":"define_macro","name":"\\x","reason":"r"}'; error = "*missing 'body'*" },
            @{ slug = 'replace'; json = '{"op":"source_replace","find":"x","reason":"r"}'; error = "*missing 'replace'*" },
            @{ slug = 'expect-string'; json = '{"op":"source_replace","find":"x","replace":"y","expect":"1","reason":"r"}'; error = '*positive JSON integer*' },
            @{ slug = 'expect-zero'; json = '{"op":"source_replace","find":"x","replace":"y","expect":0,"reason":"r"}'; error = '*positive JSON integer*' },
            @{ slug = 'unsafe-name'; json = '{"op":"define_macro","name":"x}{\\input{evil}","body":"x","reason":"r"}'; error = '*one TeX control word*' }
        )
        foreach ($case in $cases) {
            New-PatchFile $case.slug @($case.json) | Out-Null
            { Read-LatexPatchFile -DocumentDir $TestDrive -Slug $case.slug } |
                Should -Throw $case.error
        }

        New-PatchFile 'delete' @('{"op":"output_replace","find":"remove","replace":"","expect":1,"reason":"intentional deletion"}') | Out-Null
        $delete = @(Read-LatexPatchFile -DocumentDir $TestDrive -Slug 'delete')
        $delete[0].replace | Should -Be ''
        $delete[0].expect | Should -Be 1

        foreach ($badSlug in @(
                'CON', 'con.txt', 'PRN', 'AUX.data', 'NUL', 'COM1', 'com9.log', 'LPT1', 'lpt9.txt',
                'bad:name', 'bad<name', 'bad>name', 'bad"name', 'bad/name', 'bad\name', 'bad|name',
                'bad?name', 'bad*name', "bad`nname", 'trailing.', 'trailing ')) {
            { Get-LatexPatchPath -DocumentDir $TestDrive -Slug $badSlug } |
                Should -Throw '*not a portable file name*'
        }
        (Split-Path -Leaf (Get-LatexPatchPath -DocumentDir $TestDrive -Slug 'COM0')) |
            Should -Be 'COM0-latex.patch.jsonl'
    }

    It 'computes raw identities and refuses absent or changed pinned input' {
        { Read-LatexPatchSet -DocumentDir $TestDrive -Slug 'identity' `
                -ExpectedPatchIdentity '   ' } | Should -Throw '*invalid expected LaTeX patch identity*'
        { Read-LatexPatchSet -DocumentDir $TestDrive -Slug 'identity' `
                -ExpectedPatchIdentity ('sha256:' + ('0' * 64)) } | Should -Throw '*identity drift*'

        $absent = Read-LatexPatchSet -DocumentDir $TestDrive -Slug 'identity' `
            -ExpectedPatchIdentity absent
        $absent.identity | Should -Be 'absent'
        $absent.path | Should -Be (Get-TestPatchPath 'identity')

        [System.IO.File]::WriteAllBytes((Get-TestPatchPath 'empty'), [byte[]]::new(0))
        $empty = Read-LatexPatchSet -DocumentDir $TestDrive -Slug 'empty'
        $empty.identity | Should -Be `
            'sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
        @($empty.patches) | Should -HaveCount 0

        [void][System.IO.Directory]::CreateDirectory((Get-TestPatchPath 'occupied'))
        { Read-LatexPatchSet -DocumentDir $TestDrive -Slug 'occupied' } |
            Should -Throw '*patch path is not a file*'

        New-PatchFile 'identity' @('{"op":"source_replace","find":"x","replace":"y","reason":"r"}') | Out-Null
        $set = Read-LatexPatchSet -DocumentDir $TestDrive -Slug 'identity'
        $rawHash = (Get-FileHash -LiteralPath (Get-TestPatchPath 'identity') -Algorithm SHA256).Hash.ToLowerInvariant()
        $set.identity | Should -Be "sha256:$rawHash"
        (Read-LatexPatchSet -DocumentDir $TestDrive -Slug 'identity' `
                -ExpectedPatchIdentity $set.identity).identity | Should -Be $set.identity
        { Read-LatexPatchSet -DocumentDir $TestDrive -Slug 'identity' -ExpectedPatchIdentity absent } |
            Should -Throw '*identity drift*'

        [System.IO.File]::AppendAllText(
            (Get-TestPatchPath 'identity'), '# byte drift', [System.Text.UTF8Encoding]::new($false))
        { Read-LatexPatchSet -DocumentDir $TestDrive -Slug 'identity' `
                -ExpectedPatchIdentity $set.identity } | Should -Throw '*identity drift*'

        $target = Join-Path $TestDrive 'patch-target'
        $alias = Join-Path $TestDrive 'patch-alias'
        [void][System.IO.Directory]::CreateDirectory($target)
        [System.IO.File]::WriteAllText(
            (Join-Path $target 'linked-latex.patch.jsonl'),
            '{"op":"source_replace","find":"x","replace":"y","reason":"r"}',
            [System.Text.UTF8Encoding]::new($false))
        $linkType = if ([System.OperatingSystem]::IsWindows()) { 'Junction' } else { 'SymbolicLink' }
        [void](New-Item -ItemType $linkType -Path $alias -Target $target -ErrorAction Stop)
        try {
            { Read-LatexPatchSet -DocumentDir $alias -Slug 'linked' } |
                Should -Throw '*must not traverse a symbolic link or reparse point*'
        } finally {
            Remove-Item -LiteralPath $alias -Force
        }
    }
}

Describe 'define_macro — supply an omitted definition, resolved by the converter''s own expander' {
    BeforeAll {
        # \vect is USED but never defined (the 2403 defect, minimized); \vecsp IS defined.
        $script:defectTex = @'
\newcommand{\vecsp}{\mathbf{vec}_{\mathbb{F}}}
\begin{document}
Fix $F:P \rightarrow \vect$ and its restriction $F\vert_Q:Q\rightarrow \vect$. A vector field $\vectorfield$ is untouched.
\end{document}
'@
        $script:patch = @([pscustomobject]@{ op = 'define_macro'; name = '\vect'; body = '\mathbf{vec}_{\mathbb{F}}'; expect_uses = 2; reason = 'undefined author macro' })
    }
    It 'prepends a \newcommand and records the audit (uses counted, boundary-safe)' {
        $r = Invoke-LatexSourcePatches -Tex $defectTex -Patches $patch -Slug 't'
        $r.tex | Should -BeLike '*\newcommand{\vect}{\mathbf{vec}_{\mathbb{F}}}*'
        $r.applied | Should -HaveCount 1
        $r.applied[0].uses | Should -Be 2   # the two \vect uses; \vectorfield must NOT be counted
    }
    It 'makes the converter''s expander resolve \vect exactly as \vecsp (no output surgery)' {
        $r = Invoke-LatexSourcePatches -Tex $defectTex -Patches $patch -Slug 't'
        $macros = Get-LatexMacros $r.tex
        $macros.Contains('vect') | Should -BeTrue
        $expanded = Expand-LatexMacros 'F:P \rightarrow \vect' $macros
        $expanded | Should -Be 'F:P \rightarrow \mathbf{vec}_{\mathbb{F}}'
        # boundary safety: \vectorfield is left intact
        (Expand-LatexMacros '\vectorfield' $macros) | Should -Be '\vectorfield'
    }
    It 'throws (stale) when the macro is never used in the source' {
        $tex = '\begin{document}no such macro here\end{document}'
        { Invoke-LatexSourcePatches -Tex $tex -Patches $patch -Slug 't' } | Should -Throw '*STALE*matched nothing*'
    }
    It 'throws (stale) when the source already defines the macro' {
        $tex = '\newcommand{\vect}{\mathbf{V}}' + "`n" + $defectTex
        { Invoke-LatexSourcePatches -Tex $tex -Patches $patch -Slug 't' } | Should -Throw '*ALREADY defines*'
    }
    It 'throws on an expect_uses mismatch' {
        $bad = @([pscustomobject]@{ op = 'define_macro'; name = '\vect'; body = '\x'; expect_uses = 5; reason = 'r' })
        { Invoke-LatexSourcePatches -Tex $defectTex -Patches $bad -Slug 't' } | Should -Throw '*expected 5*'
    }

    It 'rejects duplicate definitions and unsafe direct-call macro names' {
        New-PatchFile 'duplicate-macro' @(
            '{"op":"define_macro","name":"\\x","body":"a","reason":"first"}',
            '{"op":"define_macro","name":"\\x","body":"b","reason":"second"}'
        ) | Out-Null
        { Read-LatexPatchFile -DocumentDir $TestDrive -Slug 'duplicate-macro' } |
            Should -Throw '*:2*duplicate define_macro*'

        $unsafe = @([pscustomobject]@{
                op = 'define_macro'; name = 'x}{\input{evil}'; body = 'x'; reason = 'r'; line = 7 })
        { Invoke-LatexSourcePatches -Tex 'x' -Patches $unsafe -Slug 't' } |
            Should -Throw '*line 7*unsafe*'
    }
}

Describe 'source_replace / output_replace — guarded regex substitution' {
    It 'source_replace applies and records hits' {
        # replace carries a single backslash — exactly what ConvertFrom-Json yields from JSON "\\bar"
        $patch = @([pscustomobject]@{ op = 'source_replace'; find = '\\foo'; replace = '\bar'; expect = 2; reason = 'r' })
        $r = Invoke-LatexSourcePatches -Tex 'a \foo b \foo c' -Patches $patch -Slug 't'
        $r.tex | Should -Be 'a \bar b \bar c'
        $r.applied[0].hits | Should -Be 2
    }
    It 'source_replace throws on a count that no longer holds' {
        $patch = @([pscustomobject]@{ op = 'source_replace'; find = '\\foo'; replace = '\\bar'; expect = 3; reason = 'r' })
        { Invoke-LatexSourcePatches -Tex 'a \foo b' -Patches $patch -Slug 't' } | Should -Throw '*expected 3*'
    }
    It 'output_replace applies to the emitted markdown' {
        $patch = @([pscustomobject]@{ op = 'output_replace'; find = 'teh'; replace = 'the'; reason = 'r' })
        $r = Invoke-LatexOutputPatches -Markdown 'teh cat' -Patches $patch -Slug 't'
        $r.markdown | Should -Be 'the cat'
    }
    It 'output_replace throws (stale) when it matches nothing' {
        $patch = @([pscustomobject]@{ op = 'output_replace'; find = 'zzz'; replace = 'q'; reason = 'r' })
        { Invoke-LatexOutputPatches -Markdown 'the cat' -Patches $patch -Slug 't' } | Should -Throw '*STALE*'
    }
    It 'output phase ignores source-phase ops (and vice versa)' {
        $patch = @([pscustomobject]@{ op = 'define_macro'; name = '\x'; body = '\y'; reason = 'r' })
        $r = Invoke-LatexOutputPatches -Markdown 'unchanged' -Patches $patch -Slug 't'
        $r.markdown | Should -Be 'unchanged'
        $r.applied | Should -HaveCount 0

        $outputPatch = @([pscustomobject]@{ op = 'output_replace'; find = 'x'; replace = 'y'; reason = 'r' })
        $sourceResult = Invoke-LatexSourcePatches -Tex 'unchanged' -Patches $outputPatch -Slug 't'
        $sourceResult.tex | Should -Be 'unchanged'
        $sourceResult.applied | Should -HaveCount 0

        $unknown = @([pscustomobject]@{ op = 'delete_everything'; reason = 'r' })
        { Invoke-LatexSourcePatches -Tex 'x' -Patches $unknown -Slug 't' } |
            Should -Throw '*unknown op*'
        $missingReplace = @([pscustomobject]@{ op = 'source_replace'; find = 'x'; reason = 'r' })
        { Invoke-LatexSourcePatches -Tex 'x' -Patches $missingReplace -Slug 't' } |
            Should -Throw "*missing 'replace'*"
        $missingReason = @([pscustomobject]@{ op = 'source_replace'; find = 'x'; replace = 'y' })
        { Invoke-LatexSourcePatches -Tex 'x' -Patches $missingReason -Slug 't' } |
            Should -Throw "*missing 'reason'*"
        $coercedGuard = @([pscustomobject]@{
                op = 'output_replace'; find = 'x'; replace = 'y'; expect = '1'; reason = 'r' })
        { Invoke-LatexOutputPatches -Markdown 'x' -Patches $coercedGuard -Slug 't' } |
            Should -Throw "*'expect' must be a positive integer*"
        $booleanGuard = @([pscustomobject]@{
                op = 'output_replace'; find = 'x'; replace = 'y'; expect = $true; reason = 'r' })
        { Invoke-LatexOutputPatches -Markdown 'x' -Patches $booleanGuard -Slug 't' } |
            Should -Throw "*'expect' must be a positive integer*"
    }

    It 'bounds invalid and pathological regular expressions with line-aware errors' {
        $invalid = @([pscustomobject]@{
                op = 'source_replace'; find = '['; replace = 'x'; reason = 'r'; line = 7 })
        { Invoke-LatexSourcePatches -Tex 'text' -Patches $invalid -Slug 't' } |
            Should -Throw '*line 7*invalid regex*'

        $pathological = @([pscustomobject]@{
                op = 'output_replace'; find = '^(a+)+\1$'; replace = 'x'; reason = 'r'; line = 8 })
        $pathologicalText = (('a' * 100000) -join '') + '!'
        $savedTimeout = $script:LatexPatchRegexTimeout
        try {
            $script:LatexPatchRegexTimeout = [System.TimeSpan]::FromMilliseconds(1)
            $timer = [System.Diagnostics.Stopwatch]::StartNew()
            { Invoke-LatexOutputPatches -Markdown $pathologicalText -Patches $pathological -Slug 't' } |
                Should -Throw '*line 8*regex timed out*'
            $timer.Stop()
            $timer.ElapsedMilliseconds | Should -BeLessThan 5000
        } finally {
            $script:LatexPatchRegexTimeout = $savedTimeout
        }
    }

    It 'retains provenance and physical source lines in applied audits' {
        New-PatchFile 'audit' @(
            '# curated sequence',
            '{"op":"define_macro","name":"\\vect","body":"\\mathbf{v}","expect_uses":1,"class":"author-defect","reason":"undefined","source_ref":"main.tex:4","authored_by":"Ada","authored_utc":"2026-08-08T00:00:00Z"}',
            '{"op":"source_replace","find":"foo","replace":"bar","expect":1,"class":"typo","reason":"source typo","source_ref":"main.tex:5","authored_by":"Ada","authored_utc":"2026-08-08T00:01:00Z"}',
            '{"op":"output_replace","find":"teh","replace":"the","expect":1,"class":"emission","reason":"output typo","source_ref":"output","authored_by":"Ada","authored_utc":"2026-08-08T00:02:00Z"}'
        ) | Out-Null
        $patches = @(Read-LatexPatchFile -DocumentDir $TestDrive -Slug 'audit')
        $source = Invoke-LatexSourcePatches -Tex '\vect foo' -Patches $patches -Slug 'audit'
        $output = Invoke-LatexOutputPatches -Markdown 'teh' -Patches $patches -Slug 'audit'
        $audits = @($source.applied) + @($output.applied)

        @($audits.line) | Should -Be @(2, 3, 4)
        $audits[0].class | Should -Be 'author-defect'
        $audits[0].source_ref | Should -Be 'main.tex:4'
        $audits[0].authored_by | Should -Be 'Ada'
        $audits[0].authored_utc | Should -Be '2026-08-08T00:00:00Z'
        $audits[1].reason | Should -Be 'source typo'
        $audits[2].hits | Should -Be 1
    }
}

Describe 'no patch file → the converter stays purely faithful' {
    It 'source patches are a no-op with an empty patch set' {
        $r = Invoke-LatexSourcePatches -Tex 'untouched \vect' -Patches @() -Slug 't'
        $r.tex | Should -Be 'untouched \vect'
        $r.applied | Should -HaveCount 0
    }
}
