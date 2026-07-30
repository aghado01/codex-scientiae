#requires -Version 7.0
# The shared TOC primitives (src/audits/md-toc.ps1): the ONE slug engine (Get-MdAnchor), the
# fence-aware heading scan, the hierarchical Contents-block builder, and in-text insert/refresh.
# Coverage: slug edge cases, indentation-per-level, fence awareness, insert-before-first-H2,
# in-place refresh of a stale block, no-op guarantees, and idempotency.

BeforeAll {
    . "$PSScriptRoot/../src/audits/md-toc.ps1"

    $script:doc = @'
# A Paper

Authors, affiliation.

## Abstract

Prose here with $x \geq 0$.

## Introduction

Text.

```powershell
## not a heading — fenced
```

### Prior work

More text.

## Methods

Body.
'@ -replace "`r`n", "`n"
}

Describe 'Get-MdAnchor — the one slug engine' {
    It 'lowercases, strips punctuation, hyphenates spaces, trims edge dashes' {
        Get-MdAnchor 'Methods' | Should -Be 'methods'
        Get-MdAnchor '2.1 Local Fields, revisited' | Should -Be '21-local-fields-revisited'
        Get-MdAnchor '  Edge -- case!  ' | Should -Be 'edge----case'
    }
    It 'an all-punctuation heading degrades to a stable fallback, never an empty anchor' {
        Get-MdAnchor '???' | Should -Match '^section-[0-9a-f]{8}$'
    }
}

Describe 'Get-MdContentsEntries — fence-aware H2+ scan' {
    It 'collects headings in reading order with levels, skipping fences and Contents itself' {
        $e = Get-MdContentsEntries ($doc -replace '## Abstract', "## Contents`n`n- stale`n`n## Abstract")
        @($e).text | Should -Be @('Abstract', 'Introduction', 'Prior work', 'Methods')
        @($e).level | Should -Be @(2, 2, 3, 2)
    }
}

Describe 'New-MdContentsBlock — hierarchical block' {
    It 'indents 2 spaces per level below H2 and links through Get-MdAnchor' {
        $block = New-MdContentsBlock (Get-MdContentsEntries $doc)
        $block | Should -Match '(?m)^## Contents$'
        $block | Should -Match '(?m)^- \[Introduction\]\(#introduction\)$'
        $block | Should -Match '(?m)^  - \[Prior work\]\(#prior-work\)$'
    }
    It 'returns $null over nothing — a TOC over no headings is noise' {
        New-MdContentsBlock @() | Should -BeNullOrEmpty
    }
}

Describe 'Set-MdContentsBlock — insert or refresh in text' {
    It 'inserts before the FIRST H2 when no block exists' {
        $out = Set-MdContentsBlock $doc
        $out | Should -Match '(?s)affiliation\.\n\n## Contents\n\n- \[Abstract\]\(#abstract\)\n- \[Introduction\].*\n\n## Abstract'
    }
    It 'refreshes an existing block in place — stale entries gone, position kept' {
        $stale = $doc -replace '## Abstract', "## Contents`n`n- [Deleted Section](#deleted-section)`n`n## Abstract"
        $out = Set-MdContentsBlock $stale
        $out | Should -Not -Match 'Deleted Section'
        $out | Should -Match '(?s)## Contents\n\n- \[Abstract\].*- \[Methods\]\(#methods\)\n\n## Abstract'
        ([regex]::Matches($out, '(?m)^## Contents$')).Count | Should -Be 1
    }
    It 'is idempotent: Set(Set(x)) == Set(x)' {
        $once = Set-MdContentsBlock $doc
        Set-MdContentsBlock $once | Should -BeExactly $once
    }
    It 'no H2 headings -> text unchanged' {
        $plain = "# Only a Title`n`nProse only.`n"
        Set-MdContentsBlock $plain | Should -BeExactly $plain
    }
    It 'a fenced ## line is never an insertion point or an entry' {
        $fenced = "# T`n`n" + '```' + "`n## fake`n" + '```' + "`nProse.`n"
        Set-MdContentsBlock $fenced | Should -BeExactly $fenced
    }
}
