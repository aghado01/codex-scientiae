#requires -Version 7.0
# Localized spans — difference-localization on the issue inventory + work-order delivery.

BeforeAll {
    . "$PSScriptRoot/../src/serving.ps1"
    . "$PSScriptRoot/../src/normalize.ps1"   # Get-UnwrappedMathSpans + MathLatexRx for fixtures

    $alpha = [char]0x03B1

    $script:Roots = [System.Collections.Generic.List[string]]::new()
    function New-SpanFixture([object[]]$Chunks, [string]$Paper = 'p') {
        $root    = Join-Path ([System.IO.Path]::GetTempPath()) ("codex-span-" + [guid]::NewGuid().ToString('N'))
        $scratch = Join-Path $root "$Paper/.scratch"
        New-Item -ItemType Directory -Force -Path $scratch | Out-Null
        $cp = Join-Path $scratch "$Paper.chunks.jsonl"
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

Describe 'Get-ChunkIssues — spans on unwrapped_math; empty on other kinds' {
    It 'attaches localized spans to unwrapped_math when math_dirt fires' {
        $content = 'The value ' + $alpha + ' is positive and ' + $alpha + ' again'
        $dirt = (Get-MaskDensity -Text $content -Within (Complement-Mask (Get-InlineMathMask $content)) -Register $script:MathLatexRx)
        if ($dirt -lt 2) { Set-ItResult -Skipped -Because 'fixture did not reach math_dirt threshold' }
        $c = [pscustomobject]@{ type = 'prose'; content = $content; math_dirt = $dirt }
        $u = @(Get-ChunkIssues $c | Where-Object { $_.type -eq 'unwrapped_math' })[0]
        $u.spans.Count | Should -BeGreaterThan 0
        $u.diagnostic | Should -Match 'math_dirt='
    }
    It 'corruption signatures carry empty spans (not yet localized)' {
        $c = [pscustomobject]@{ type = 'formula'; content = '\left( x' }
        $u = @(Get-ChunkIssues $c | Where-Object { $_.type -eq 'unbalanced_delimiters' })[0]
        @($u.spans).Count | Should -Be 0
    }
    It 'the frozen single-type gate is unchanged on a multi-signal chunk' {
        $c = [pscustomobject]@{ type = 'formula'; content = '\left( x'; math_dirt = 0 }
        Get-CorruptionType $c | Should -Be 'unbalanced_delimiters'
    }
}

Describe 'work-order delivery — spans propagate body-light through compose + get_slice' {
    It 'New-WorkOrder carries spans on the unwrapped_math recipe' {
        $content = 'rate $\alpha$ and ' + $alpha + ' outside, then ' + $alpha + ' more'
        $dirt = (Get-MaskDensity -Text $content -Within (Complement-Mask (Get-InlineMathMask $content)) -Register $script:MathLatexRx)
        if ($dirt -lt 2) { Set-ItResult -Skipped -Because 'fixture did not reach math_dirt threshold' }
        $c = [pscustomobject]@{ id = 0; type = 'prose'; page = 1; content = $content; math_dirt = $dirt; fidelity = 'needs_review'; review_reason = 'unwrapped_math' }
        $wo = New-WorkOrder -Kind 'chunk' -Id 0 -Members @($c)
        $rec = @($wo.recipes | Where-Object { $_.type -eq 'unwrapped_math' })[0]
        $rec.spans.Count | Should -BeGreaterThan 0
        ($wo | ConvertTo-Json -Depth 12 -Compress).Contains($content) | Should -BeFalse
    }
    It 'get_slice returns work_order recipes with spans on the anchor' {
        $content = 'rate $\alpha$ and ' + $alpha + ' outside, then ' + $alpha + ' more'
        $dirt = (Get-MaskDensity -Text $content -Within (Complement-Mask (Get-InlineMathMask $content)) -Register $script:MathLatexRx)
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
