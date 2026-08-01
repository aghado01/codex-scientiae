#requires -Version 7.0
# Format-MdHygiene (src/audits/md-hygiene.ps1) — the shared emission walk, tested DIRECTLY as a
# primitive (previously only exercised through full latex-ingest conversions). Coverage: fence
# verbatim, MD009/MD010/MD012 whitespace, MD026 + heading-level clamp, MD034 autolinks with
# punctuation left outside, `$a$$b$` span-adjacency repair, ordered-list accident escapes and
# nested-list retro-indent, and idempotency.

BeforeAll {
    . "$PSScriptRoot/../../src/md-postprocess/md-hygiene.ps1"
}

Describe 'whitespace lint (MD009/MD010/MD012) — fences byte-verbatim' {
    It 'strips trailing whitespace, spaces tabs, collapses blank runs' {
        Format-MdHygiene "a`t b  `n`n`n`nc`n" | Should -Be "a  b`n`nc`n"
    }
    It 'inside a fence nothing is touched — blanks, tabs, trailing spaces survive' {
        $in = "x`n" + '```' + "`n`n`na`tb  `n" + '```' + "`n"
        Format-MdHygiene $in | Should -Be $in
    }
}

Describe 'headings — MD026 punctuation + one-tier level clamp' {
    It 'strips trailing sentence punctuation and clamps ## -> #### to parent+1' {
        $out = Format-MdHygiene "## Methods:`n`n#### Deep dive.`n"
        $out | Should -Match '(?m)^## Methods$'
        $out | Should -Match '(?m)^### Deep dive$'
    }
}

Describe 'autolinks (MD034) — trailing punctuation stays outside' {
    It 'wraps bare URLs and e-mails; already-wrapped are untouched' {
        Format-MdHygiene "See https://x.test/a, then <https://y.test/b>.`n" |
            Should -Be "See <https://x.test/a>, then <https://y.test/b>.`n"
        Format-MdHygiene "Mail a.b@x.test now`n" | Should -Be "Mail <a.b@x.test> now`n"
    }
}

Describe 'register safety — mid-line $$ is span adjacency, never a display fence' {
    It 'restores the boundary between adjacent inline spans; a lone $$ fence line survives' {
        $in  = 'eq $a$$b$ here' + "`n`n" + '$$' + "`n" + 'x = y' + "`n" + '$$' + "`n"
        $out = 'eq $a$ $b$ here' + "`n`n" + '$$' + "`n" + 'x = y' + "`n" + '$$' + "`n"
        Format-MdHygiene $in | Should -Be $out
    }
}

Describe 'ordered-list repair' {
    It 'escapes a mid-paragraph cross-ref number that would read as a list marker' {
        Format-MdHygiene "as shown in`n14. Alternatively, we may`n" |
            Should -Be "as shown in`n14\. Alternatively, we may`n"
    }
    It 'retro-indents flat bullets that split a numbered list back under their item' {
        $out = Format-MdHygiene "1. first`n- inner a`n- inner b`n2. second`n"
        $out | Should -Be "1. first`n    - inner a`n    - inner b`n2. second`n"
    }
}

Describe 'idempotency — a conforming document passes through byte-identical' {
    It 'Format(Format(x)) == Format(x)' {
        $in = "# T!`n`ntext https://x.test/a.`n`n1. a`n- b`n2. c`n`n" + '```' + "`nraw`t `n" + '```' + "`n"
        $once = Format-MdHygiene $in
        Format-MdHygiene $once | Should -BeExactly $once
    }
}
