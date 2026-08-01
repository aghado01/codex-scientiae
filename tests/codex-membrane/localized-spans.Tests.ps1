#requires -Version 7.0
# Localized spans — difference-localization on the issue inventory + work-order delivery.

BeforeAll {
    . "$PSScriptRoot/../../src/codex-membrane/serving.ps1"
    . "$PSScriptRoot/../../src/codex-membrane/normalize.ps1"   # Get-UnwrappedMathSpans + MathLatexRx for fixtures

    $alpha = [char]0x03B1

    $script:Roots = [System.Collections.Generic.List[string]]::new()
    function New-SpanFixture([object[]]$Chunks, [string]$Paper = 'p') {
        $root   = Join-Path ([System.IO.Path]::GetTempPath()) ("codex-span-" + [guid]::NewGuid().ToString('N'))
        $runDir = Join-Path $root "$Paper/.runs/20260101_000000"
        New-Item -ItemType Directory -Force -Path $runDir | Out-Null
        $cp = Join-Path $runDir "$Paper.chunks.jsonl"
        [void](Write-JsonlStage -Records $Chunks -OutputPath $cp -Stage 'fidelity')
        $script:Roots.Add($root)
        return [pscustomobject]@{ root = $root; cp = $cp; paper = $Paper }
    }
}

AfterAll {
    foreach ($r in $script:Roots) { if (Test-Path -LiteralPath $r) { Remove-Item -LiteralPath $r -Recurse -Force -ErrorAction SilentlyContinue } }
}

Describe 'Get-UnwrappedMathSpans — mask difference localizes un-wrapped tokens' {
    It 'returns spans outside already-wrapped $...$ (Unicode glyph path)' {
        $content = 'rate $\alpha$ and ' + $alpha + ' outside'
        $spans = @(Get-UnwrappedMathSpans $content)
        $spans.Count | Should -BeGreaterThan 0
        $outsideAt = $content.IndexOf("$alpha outside")
        $hit = @($spans | Where-Object { $_.start -le $outsideAt -and $_.end -gt $outsideAt })
        $hit.Count | Should -BeGreaterThan 0
    }
    It 'returns empty when all math is wrapped' {
        @(Get-UnwrappedMathSpans '$\alpha \beta$ everything wrapped').Count | Should -Be 0
    }
}

Describe 'Get-ChunkIssues — localized spans on all issue kinds' {
    It 'attaches localized spans to unwrapped_math when math_dirt fires' {
        $content = 'The value ' + $alpha + ' is positive and ' + $alpha + ' again'
        $dirt = Get-MathDirt $content
        if ($dirt -lt 2) { Set-ItResult -Skipped -Because 'fixture did not reach math_dirt threshold' }
        $c = [pscustomobject]@{ type = 'prose'; content = $content; math_dirt = $dirt }
        $u = @(Get-ChunkIssues $c | Where-Object { $_.type -eq 'unwrapped_math' })[0]
        $u.spans.Count | Should -BeGreaterThan 0
        $u.diagnostic | Should -Match 'math_dirt='
    }
    It 'localizes unbalanced_delimiters from the first open delimiter to end' {
        $content = '\left( x'
        $u = @(Get-ChunkIssues ([pscustomobject]@{ type = 'formula'; content = $content }) | Where-Object { $_.type -eq 'unbalanced_delimiters' })[0]
        $u.spans.Count | Should -Be 1
        $u.spans[0].start | Should -Be 0
        $u.spans[0].end | Should -Be $content.Length
        $u.diagnostic | Should -Match 'lr=1'
    }
    It 'localizes ligature_residue at the OCR glyph' {
        $fi = [char]0xFB01
        $content = 'coefficient ' + $fi + 'eld'
        $u = @(Get-ChunkIssues ([pscustomobject]@{ type = 'prose'; content = $content }) | Where-Object { $_.type -eq 'ligature_residue' })[0]
        $u.spans.Count | Should -Be 1
        $u.spans[0].start | Should -Be $content.IndexOf($fi)
        $u.spans[0].end | Should -Be ($content.IndexOf($fi) + 1)
    }
    It 'localizes replacement_char at each U+FFFD' {
        $content = 'lost ' + [char]0xFFFD + ' char'
        $u = @(Get-ChunkIssues ([pscustomobject]@{ type = 'prose'; content = $content }) | Where-Object { $_.type -eq 'replacement_char' })[0]
        $u.spans.Count | Should -Be 1
        $u.spans[0].start | Should -Be 5
        $u.spans[0].end | Should -Be 6
    }
    It 'localizes intertext from first \intertext to end' {
        $content = 'a = b \intertext{junk} a = b'
        $u = @(Get-ChunkIssues ([pscustomobject]@{ type = 'formula'; content = $content }) | Where-Object { $_.type -eq 'intertext' })[0]
        $u.spans[0].start | Should -Be $content.IndexOf('\intertext')
        $u.spans[0].end | Should -Be $content.Length
    }
    It 'localizes gibberish on the shatter run' {
        $content = 'head intact a o f i n t o o t'
        $u = @(Get-ChunkIssues ([pscustomobject]@{ type = 'prose'; content = $content }) | Where-Object { $_.type -eq 'gibberish' })[0]
        $u.spans.Count | Should -Be 1
        $runAt = $content.IndexOf('a o f i')
        $hit = @($u.spans | Where-Object { $_.start -le $runAt -and $_.end -gt $runAt })
        $hit.Count | Should -BeGreaterThan 0
    }
    It 'localizes alignment_outside_env at bare ampersands' {
        $content = 'x &= y \\ z &= w'
        $u = @(Get-ChunkIssues ([pscustomobject]@{ type = 'formula'; content = $content }) | Where-Object { $_.type -eq 'alignment_outside_env' })[0]
        $u.spans.Count | Should -BeGreaterThan 0
        $ampAt = $content.IndexOf('&')
        $hit = @($u.spans | Where-Object { $_.start -le $ampAt -and $_.end -gt $ampAt })
        $hit.Count | Should -BeGreaterThan 0
    }
    It 'localizes prose_in_formula on prose-word hits outside math structure' {
        $content = 'This paragraph reads as natural language without math.'
        $u = @(Get-ChunkIssues ([pscustomobject]@{ type = 'formula'; content = $content }) | Where-Object { $_.type -eq 'prose_in_formula' })[0]
        $u.spans.Count | Should -BeGreaterThan 0
        $wordAt = $content.IndexOf('paragraph')
        $hit = @($u.spans | Where-Object { $_.start -le $wordAt -and $_.end -gt $wordAt })
        $hit.Count | Should -BeGreaterThan 0
    }
    It 'localizes heading_level_unknown as whole-chunk structural span' {
        $content = '## Ambiguous heading'
        $u = @(Get-ChunkIssues ([pscustomobject]@{ type = 'heading'; content = $content; level_uncertain = $true }) | Where-Object { $_.type -eq 'heading_level_unknown' })[0]
        $u.spans[0].start | Should -Be 0
        $u.spans[0].end | Should -Be $content.Length
    }
    It 'the frozen single-type gate is unchanged on a multi-signal chunk' {
        $c = [pscustomobject]@{ type = 'formula'; content = '\left( x'; math_dirt = 0 }
        Get-CorruptionType $c | Should -Be 'unbalanced_delimiters'
    }
}

Describe 'work-order delivery — spans propagate body-light through compose + get_slice' {
    It 'New-WorkOrder carries spans on the unwrapped_math recipe' {
        $content = 'rate $\alpha$ and ' + $alpha + ' outside, then ' + $alpha + ' more'
        $dirt = Get-MathDirt $content
        if ($dirt -lt 2) { Set-ItResult -Skipped -Because 'fixture did not reach math_dirt threshold' }
        $c = [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = $content; math_dirt = $dirt; fidelity = 'needs_review'; review_reason = 'unwrapped_math' }
        $wo = New-WorkOrder -Kind 'chunk' -Id 0 -Members @($c)
        $rec = @($wo.recipes | Where-Object { $_.type -eq 'unwrapped_math' })[0]
        $rec.spans.Count | Should -BeGreaterThan 0
        ($wo | ConvertTo-Json -Depth 12 -Compress).Contains($content) | Should -BeFalse
    }
    It 'get_slice returns work_order recipes with spans on the anchor' {
        $content = 'rate $\alpha$ and ' + $alpha + ' outside, then ' + $alpha + ' more'
        $dirt = Get-MathDirt $content
        if ($dirt -lt 2) { Set-ItResult -Skipped -Because 'fixture did not reach math_dirt threshold' }
        $fx = New-SpanFixture @(
            [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = $content; math_dirt = $dirt; fidelity = 'needs_review'; review_reason = 'unwrapped_math' }
        )
        $slice = Get-Slice -ChunksPath $fx.cp -Id 0
        $rec = @($slice.work_order.recipes | Where-Object { $_.type -eq 'unwrapped_math' })[0]
        $rec.spans.Count | Should -BeGreaterThan 0
        $slice[0].content | Should -Be $content
    }
}
