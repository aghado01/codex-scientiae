#requires -Version 7.0
# Per-paper patch lane (curated errata) — the durable home for repair-tier corrections that survive
# regeneration. The converter stays FAITHFUL by default (no patch file → pure no-op); a per-paper
# {slug}-latex.patch.jsonl supplies human-authored, JUSTIFIED, occurrence-GUARDED corrections that
# re-apply on every latex_convert. A stale patch (matches nothing / a count that no longer holds) must
# fail LOUDLY, not silently no-op. Anchored on the real defect this lane was built for: 2403.08110v4's
# undefined \vect (author uses it in Remark 8.1 but only ever defines \vecsp = \mathbf{vec}_{\mathbb{F}}).

BeforeAll {
    . "$PSScriptRoot/../src/latex-ingest/latex-ingest.ps1"

    function New-PatchFile {
        param([string]$Slug, [string[]]$Lines)
        $p = Join-Path $TestDrive "$Slug-latex.patch.jsonl"
        [System.IO.File]::WriteAllText($p, ($Lines -join "`n") + "`n", [System.Text.UTF8Encoding]::new($false))
        return $TestDrive
    }
}

Describe 'Read-LatexPatchFile' {
    It 'returns empty when there is no patch file (the faithful default)' {
        (Read-LatexPatchFile -Dir $TestDrive -Slug 'no-such-paper') | Should -HaveCount 0
    }
    It 'parses JSONL, skipping comment and blank lines' {
        $dir = New-PatchFile 'p1' @(
            '# a header comment',
            '',
            '{"op":"define_macro","name":"\\vect","body":"\\mathbf{vec}_{\\mathbb{F}}","reason":"undefined in Remark 8.1"}'
        )
        $patches = @(Read-LatexPatchFile -Dir $dir -Slug 'p1')
        $patches | Should -HaveCount 1
        $patches[0].op | Should -Be 'define_macro'
        $patches[0].name | Should -Be '\vect'
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
    }
}

Describe 'no patch file → the converter stays purely faithful' {
    It 'source patches are a no-op with an empty patch set' {
        $r = Invoke-LatexSourcePatches -Tex 'untouched \vect' -Patches @() -Slug 't'
        $r.tex | Should -Be 'untouched \vect'
        $r.applied | Should -HaveCount 0
    }
}
