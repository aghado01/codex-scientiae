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

    It 'New-DeliverableTreeModel: extracts headings, byte spans, and char counts' {
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
        $s1.char_count | Should -BeGreaterThan 0
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
            $sidecarContent | Should -Match 'section row metadata: section_link \| level \| byte_start \| byte_end \| byte_width \(B\) \| char_count \(chars\)'
            $sidecarContent | Should -Match '- \[1 Introduction\]\(paper-01\.md#1-introduction\)'

            $jsonlContent = Get-Content -LiteralPath $res.toc_jsonl
            $jsonlContent.Count | Should -Be 2
        }
        finally {
            Remove-Item -LiteralPath $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
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
}
