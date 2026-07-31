#requires -Version 7.0
# Tests for src/toc-engine/toc-engine.ps1 — TOC & Tree Manifest Engine

Describe 'toc-engine — template expansion, model assembly, sidecar export' {
    BeforeAll {
        . "$PSScriptRoot/../src/toc-engine/toc-engine.ps1"
    }

    It 'Expand-MdTemplate: performs scalar substitution, {{#each}} loops, and {{#if}} conditionals' {
        $model = [pscustomobject]@{
            Header = [pscustomobject]@{ title = 'Test Doc'; slug = 'test-doc' }
            Sections = @(
                [pscustomobject]@{ title = 'Intro'; level = 1; char_count = 100 }
                [pscustomobject]@{ title = 'Methods'; level = 2; char_count = 200 }
            )
        }
        $tpl = 'Title: {{Header.title}} ({{Header.slug}})' + "`n" + '{{#each Sections}}- {{title}} H{{level}} ({{char_count}} chars)' + "`n" + '{{/each}}'
        $out = Expand-MdTemplate -TemplateText $tpl -Model $model
        $out | Should -Match 'Title: Test Doc \(test-doc\)'
        $out | Should -Match '- Intro H1 \(100 chars\)'
        $out | Should -Match '- Methods H2 \(200 chars\)'
    }

    It 'New-DeliverableTreeModel: extracts headings, contiguous byte spans, and no char_count' {
        $md = @"
# Main Document Title

Some introduction prose.

## 1. Introduction

Introductory content goes here.

### 1.1 Background

Background text.

## 2. Methods

Methodology explanation.
"@
        $model = New-DeliverableTreeModel -MarkdownText $md -Slug 'test-doc'
        $model.Header.slug | Should -Be 'test-doc'
        $model.Header.title | Should -Be 'Main Document Title'
        $model.Sections.Count | Should -Be 3

        $s1 = $model.Sections[0]
        $s1.title | Should -Be '1. Introduction'
        $s1.level | Should -Be 2
        $s1.level_tag | Should -Be 'H2'
        $s1.anchor | Should -Be '1-introduction'
        $s1.byte_width | Should -BeGreaterThan 0
        # char_count is gone: post-register canonicalization drives math to ASCII, so it tracked
        # byte_width to a fraction of a percent and decided nothing byte_width does not
        $s1.PSObject.Properties.Name | Should -Not -Contain 'char_count'
        # spans are contiguous and reach the end of the document — they are ADDRESSES, so a gap between
        # two sections is text no reader can address
        for ($i = 1; $i -lt $model.Sections.Count; $i++) {
            $model.Sections[$i].byte_start | Should -Be $model.Sections[$i - 1].byte_end
        }
        $model.Sections[-1].byte_end | Should -Be $model.Header.total_bytes
        $model.Sections[0].byte_width | Should -Be ($model.Sections[0].byte_end - $model.Sections[0].byte_start)
    }

    It 'New-DeliverableTreeModel: excludes self-referential Contents heading' {
        $md = @"
# Main Title

## Contents

- [1. Intro](#1-intro)

## 1. Intro

Intro text.
"@
        $model = New-DeliverableTreeModel -MarkdownText $md -Slug 'test-doc'
        $model.Sections.Count | Should -Be 1
        $model.Sections[0].title | Should -Be '1. Intro'
    }

    It 'Set-MdContentsBlock: inserts a plain-link in-doc ## Contents block, carrying NO byte spans' {
        $md = @"
# Main Title

## Section 1

First section text.

## Section 2

Second section text.
"@
        $out = Set-MdContentsBlock -MarkdownText $md -Slug 'test-doc'
        $out | Should -Match '## Contents'
        $out | Should -Match '- \[Section 1\]\(#section-1\)'
        $out | Should -Match '- \[Section 2\]\(#section-2\)'
        # Byte spans belong to the SIDECAR only. An in-doc block cannot carry correct offsets: the model
        # is built before the block is spliced, so every span drifts by exactly the block's own length,
        # and compensating is a fixpoint (widening a number changes the length that shifted it). The
        # sidecar has no such problem — a separate file's bytes do not move the document it describes.
        $out | Should -Not -Match 'byte_start'
        $out | Should -Not -Match 'section row metadata'
        # the block never lists ITSELF (toc-engine's self-referential heading exclusion)
        ([regex]::Matches($out, '(?m)^\s*- \[')).Count | Should -Be 2
        # tight list: no blank line between rows
        $out | Should -Match '(?m)^- \[Section 1\]\(#section-1\)\r?\n- \[Section 2\]\(#section-2\)'
    }

    It 'Export-MdTreeSidecar: emits {slug}-tree.md and {slug}.toc.jsonl sidecars' {
        $tmpDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
        try {
            $mdFile = Join-Path $tmpDir 'paper-01.md'
            @'
# Paper 01

## 1 Introduction

Text for introduction.

## 2 Methods

Text for methods.
'@ | Out-File -FilePath $mdFile -Encoding utf8

            $res = Export-MdTreeSidecar -MarkdownPath $mdFile -OutDir $tmpDir -Slug 'paper-01'
            Test-Path -LiteralPath $res.toc_md | Should -BeTrue
            Test-Path -LiteralPath $res.toc_jsonl | Should -BeTrue

            $sidecarContent = [System.IO.File]::ReadAllText($res.toc_md)
            $sidecarContent | Should -Match 'Document Tree Manifest: paper-01'
            $sidecarContent | Should -Match 'section row metadata: section_link \| level \| byte_start \| byte_end \| byte_width \(B\)'
            $sidecarContent | Should -Not -Match 'char_count'
            $sidecarContent | Should -Match '- \[1 Introduction\]\(paper-01\.md#1-introduction\)'

            # the source link is RELATIVE — an absolute file:/// path is a dead link for every reader
            # but the generating machine, and leaks its directory layout into a shipped artifact
            $sidecarContent | Should -Not -Match 'file:///'
            $sidecarContent | Should -Match '\[`paper-01\.md`\]\(paper-01\.md\)'

            # payload inventory: the manifest names what it is an entrypoint TO, including the sidecars
            # it is about to write beside itself
            $sidecarContent | Should -Match '## Payload'
            $sidecarContent | Should -Match '- `\./paper-01\.md \(\d+ B\)`'
            $sidecarContent | Should -Match '- `\./paper-01-tree\.md`'
            $sidecarContent | Should -Match '- `\./paper-01\.toc\.jsonl`'

            $jsonlContent = Get-Content -LiteralPath $res.toc_jsonl
            $jsonlContent.Count | Should -Be 2
            ($jsonlContent[0] | ConvertFrom-Json).PSObject.Properties.Name | Should -Not -Contain 'char_count'
        }
        finally {
            Remove-Item -LiteralPath $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'subject index: the engine DISCOVERS nothing — bold run-in headers alone produce no index' {
        # what counts as a numbered object is domain knowledge. Pattern-matching '**Theorem 1.1.**' out of
        # rendered markdown is a typographic guess: across the corpus a third of line-start bold is
        # paragraph headings ('Step I.', 'Contributions.', 'Keywords:'), and a PDF lane may not emit the
        # convention at all. The engine renders evidence; it does not invent it.
        $md = "# Paper`n`n## First Part`n`n**Theorem 1.1.** A statement.`n`n**Step I.** Not an object.`n"
        $model = New-DeliverableTreeModel -MarkdownText $md -Slug 'paper'
        $model.Index.Count | Should -Be 0
        $model.Header.index_count | Should -Be 0
    }

    It 'subject index: a SUPPLIED index is attributed to the section whose span contains it' {
        $md = "# Paper`n`n## First Part`n`nAlpha text.`n`n## Second Part`n`nBeta text.`n"
        $u8 = [System.Text.UTF8Encoding]::new($false)
        $inFirst = $u8.GetByteCount("# Paper`n`n## First Part`n`n")
        $inSecond = $u8.GetByteCount("# Paper`n`n## First Part`n`nAlpha text.`n`n## Second Part`n`n")

        $supplied = @(
            [pscustomobject]@{ kind = 'Theorem'; class = 'assertion'; number = '1.1'; label = 'Theorem 1.1'; identity = 'thm:a'; byte_start = $inFirst }
            [pscustomobject]@{ kind = 'Remark'; class = 'commentary'; number = '2.1'; label = 'Remark 2.1'; identity = ''; byte_start = $inSecond }
        )
        $model = New-DeliverableTreeModel -MarkdownText $md -Slug 'paper' -Index $supplied

        $model.Index.Count | Should -Be 2
        $model.Header.index_count | Should -Be 2
        # the lane's typing survives untouched — kind and class are fields, not words inside a label
        $model.Index[0].kind | Should -Be 'Theorem'
        $model.Index[0].class | Should -Be 'assertion'
        $model.Index[0].identity | Should -Be 'thm:a'
        $model.Index[1].class | Should -Be 'commentary'
        # …and the engine adds exactly one thing: which section contains it
        $model.Index[0].section | Should -Be 'First Part'
        $model.Index[1].section | Should -Be 'Second Part'
        # entries link into the MANUSCRIPT — a bare '#anchor' would resolve against the manifest itself
        $model.Index[1].relative_link | Should -Be 'paper.md#second-part'
        foreach ($e in $model.Index) {
            $owner = @($model.Sections | Where-Object { $_.anchor -eq $e.anchor })[0]
            $e.byte_start | Should -BeGreaterOrEqual $owner.byte_start
            $e.byte_start | Should -BeLessThan $owner.byte_end
        }
    }

    It 'Export-MdTreeSidecar: respects -DisableTreeToc and -DisableJsonlToc switches' {
        $tmpDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
        try {
            $mdFile = Join-Path $tmpDir 'paper-02.md'
            "# Title`n`n## Sec`n`nText`n" | Out-File -FilePath $mdFile -Encoding utf8

            $res = Export-MdTreeSidecar -MarkdownPath $mdFile -OutDir $tmpDir -Slug 'paper-02' -DisableTreeToc -DisableJsonlToc
            $res.toc_md | Should -BeNullOrEmpty
            $res.toc_jsonl | Should -BeNullOrEmpty
            Test-Path (Join-Path $tmpDir 'paper-02-tree.md') | Should -BeFalse
            Test-Path (Join-Path $tmpDir 'paper-02.toc.jsonl') | Should -BeFalse
        }
        finally {
            Remove-Item -LiteralPath $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'Export-MdTreeSidecar: -Metadata reaches the manifest frontmatter (authors/doi are not dead fields)' {
        $tmpDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
        try {
            $mdFile = Join-Path $tmpDir 'paper-03.md'
            "# Title`n`n## Sec`n`nText`n" | Out-File -FilePath $mdFile -Encoding utf8

            $res = Export-MdTreeSidecar -MarkdownPath $mdFile -OutDir $tmpDir -Slug 'paper-03' `
                -Metadata @{ authors = 'Ada Lovelace; Alan Turing'; doi = '10.1234/abc.567' }
            $content = [System.IO.File]::ReadAllText($res.toc_md)
            $content | Should -Match 'authors: "Ada Lovelace; Alan Turing"'
            $content | Should -Match 'doi: "10\.1234/abc\.567"'

            # and absent metadata stays EMPTY rather than being invented
            $res2 = Export-MdTreeSidecar -MarkdownPath $mdFile -OutDir $tmpDir -Slug 'paper-03'
            $bare = [System.IO.File]::ReadAllText($res2.toc_md)
            $bare | Should -Match 'authors: ""'
            $bare | Should -Match 'doi: ""'
        }
        finally {
            Remove-Item -LiteralPath $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'toc-engine stands alone: dot-sourced WITHOUT md-postprocess/md-toc.ps1 it still slugs and exports' {
        # the engine used to borrow Get-MdAnchor from the module it supersedes, so load order decided
        # which of two same-named functions won. Run in a CHILD process so nothing this suite already
        # loaded can mask a missing dependency.
        $tmpDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
        try {
            $mdFile = Join-Path $tmpDir 'solo.md'
            "# T`n`n## A Section, Punctuated!`n`nText`n" | Out-File -FilePath $mdFile -Encoding utf8
            $engine = (Resolve-Path "$PSScriptRoot/../src/toc-engine/toc-engine.ps1").Path

            $script = @"
. '$engine'
if (Get-Command Set-MdContentsBlock -ErrorAction SilentlyContinue) {
    if ((Get-Command Get-MdAnchor -ErrorAction SilentlyContinue).ScriptBlock.File -notlike '*toc-engine.ps1') { throw 'anchor came from elsewhere' }
}
`$r = Export-MdTreeSidecar -MarkdownPath '$mdFile' -OutDir '$tmpDir' -Slug 'solo'
Write-Output ([System.IO.File]::ReadAllText(`$r.toc_md))
"@
            $out = & pwsh -NoProfile -NonInteractive -Command $script 2>&1 | Out-String
            $LASTEXITCODE | Should -Be 0
            $out | Should -Match '- \[A Section, Punctuated!\]\(solo\.md#a-section-punctuated\)'
        }
        finally {
            Remove-Item -LiteralPath $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
