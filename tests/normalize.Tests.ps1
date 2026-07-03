#requires -Version 7.0
# Content-normalization passes (normalize.ps1 / md-cleanup.ps1). Folds in the ad-hoc dev probes for
# Optimize-MathContent and markdown-cleanup idempotency, plus the math_dirt mask-algebra value-identity.

BeforeAll {
    . "$PSScriptRoot/../src/normalize.ps1"    # Optimize-MathContent, Convert-MathToLatex, $script:MathLatexRx
    . "$PSScriptRoot/../src/md-cleanup.ps1"   # Invoke-MarkdownCleanup
    # legacy blank-and-count (pre prose-context refinement); refined count via Get-MathDirt
    function Legacy-MathDirt([string]$w) { return ($script:MathLatexRx.Matches([regex]::Replace($w, '\$[^$\n]+\$', ' ')).Count) }
    function Mask-MathDirt([string]$w) { return (Get-MaskDensity -Text $w -Within (Complement-Mask (New-Mask $w '\$[^$\n]+\$')) -Register $script:MathLatexRx) }
    $casesBlock = @'
\begin{cases}
  \frac{1}{\hat{K}} \exp\!\left(-\frac{d_{ij}^2}{2a^2}\right) & \text{if } v_i \text{ and } v_j \text{ are neighbors} \\
  0 & \text{otherwise}
\end{cases} \tag{4.1}
'@
}

Describe 'Optimize-MathContent' {
    It 'is idempotent (a second pass is a no-op)' {
        $once = Optimize-MathContent $casesBlock @('mathbb')
        Optimize-MathContent $once @('mathbb') | Should -BeExactly $once
    }
    It 'preserves the equation tag and the environment' {
        $out = Optimize-MathContent $casesBlock @('mathbb')
        $out | Should -BeLike '*\tag{4.1}*'
        $out | Should -BeLike '*\begin{cases}*'
    }
    It 'preserves brace balance' {
        (Get-LatexBalance (Optimize-MathContent $casesBlock @('mathbb'))).braceBalanced | Should -BeTrue
    }
    It 'does not lose an escaped-star superscript' {
        Optimize-MathContent 'T^\*' @('mathbb') | Should -BeLike '*\**'
    }
}

Describe 'math_dirt — mask algebra + prose-context refinement' {
    It 'mask-algebra matches legacy blank-and-count (pre prose-context layer)' {
        $blackboardE = [char]::ConvertFromUtf32(0x1D53C)   # SMP 𝔼 (two UTF-16 units)
        $alpha = [char]0x03B1; $in = [char]0x2208; $sum = [char]0x2211; $int = [char]0x222B
        $samples = @(
            "rate $blackboardE and $alpha outside, `$\alpha`$ inside, then $in more"
            'plain prose with no math at all'
            "`$\alpha \beta`$ everything wrapped"
            "$sum $int bare operators outside any span"
        )
        foreach ($s in $samples) { (Mask-MathDirt $s) | Should -Be (Legacy-MathDirt $s) }
    }
    It 'Get-MathDirt subtracts hyphenated Greek prose compounds (α-helix)' {
        $a = [char]0x03B1
        Get-MathDirt ("The " + $a + "-helix motif appears often.") | Should -Be 0
        (Legacy-MathDirt ("The " + $a + "-helix motif appears often.")) | Should -BeGreaterThan 0
    }
    It 'Get-MathDirt subtracts disjunctive Greek mentions (α and β)' {
        $a = [char]0x03B1; $b = [char]0x03B2
        Get-MathDirt ("Types " + $a + " and " + $b + " are common.") | Should -Be 0
    }
    It 'Get-MathDirt subtracts numeric unit suffixes' {
        Get-MathDirt 'Accuracy was 95% on the holdout.' | Should -Be 0
    }
    It 'Get-MathDirt still counts genuine un-wrapped math runs' {
        $a = [char]0x03B1
        $content = 'The value ' + $a + ' is positive and ' + $a + ' again'
        Get-MathDirt $content | Should -BeGreaterOrEqual 2
    }
    It 'refined count is never greater than the legacy residual' {
        $a = [char]0x03B1; $b = [char]0x03B2; $in = [char]0x2208
        foreach ($s in @(
            'The value ' + $a + ' is positive and ' + $a + ' again'
            $a + '-helix and ' + $b + ' sheet'
            'rate $\alpha$ and ' + $a + ' outside'
            "$in $a bare operators"
        )) {
            (Get-MathDirt $s) | Should -BeLessOrEqual (Mask-MathDirt $s)
        }
    }
}

Describe 'Get-UnbledFormula — trim bled prose rows via Test-IsMath -Level Row' {
    It 'drops a trailing \text row when the prose is duplicated in a nearby chunk' {
        $dup = 'This duplicated paragraph appears in both places.'
        $chunks = @(
            [pscustomobject]@{ type = 'prose'; content = "Intro. $dup More intro." }
            [pscustomobject]@{ type = 'formula'; content = "x = 1 \\ \text{$dup}" }
        )
        Get-UnbledFormula $chunks 1 | Should -Be 'x = 1'
    }
    It 'keeps trailing prose when it is NOT confirmed duplicated nearby' {
        $unique = 'This unique trailing sentence is not duplicated elsewhere.'
        $chunks = @(
            [pscustomobject]@{ type = 'prose'; content = 'Unrelated paragraph without the probe word.' }
            [pscustomobject]@{ type = 'formula'; content = "x = 1 \\ \text{$unique}" }
        )
        Get-UnbledFormula $chunks 1 | Should -Be "x = 1 \\ \text{$unique}"
    }
    It 'returns single-row content unchanged' {
        $chunks = @([pscustomobject]@{ type = 'formula'; content = 'E = mc^2' })
        Get-UnbledFormula $chunks 0 | Should -Be 'E = mc^2'
    }
}

Describe 'Invoke-MarkdownCleanup — idempotency after -Apply' {
    It 'a dry-run after one apply reports no further change' {
        $f = Join-Path $TestDrive 'idem.md'
        [System.IO.File]::WriteAllText($f, "The e$([char]0xFB03)cient $([char]0x03B1) $([char]0x03B2) $([char]0x03B3) value is $([char]0xFB01)nite.", [System.Text.UTF8Encoding]::new($false))
        $null = Invoke-MarkdownCleanup -Path $f -Apply
        (Invoke-MarkdownCleanup -Path $f).changed | Should -BeFalse
    }
}

Describe 'Get-FurnitureKind — furniture classification + small-font gate' {
    BeforeAll {
        $median = 9.963   # body CMR10 baseline, the median over the specimen's prose nodes
        function New-Chunk($content, $font, $size) { [pscustomobject]@{ type = 'prose'; content = $content; font = $font; font_size = $size } }
    }
    It 'flags a colon-less caption typeset below the body median (the leaked "Fig. 1 ..." case)' {
        Get-FurnitureKind (New-Chunk 'Fig. 1 ARI and NMI as a function of e for the synthetic settings' 'CMR8' 7.97) $median | Should -Be 'caption'
    }
    It 'does NOT flag body prose that opens with a figure mention at body font ("Figure 6 shows ...")' {
        Get-FurnitureKind (New-Chunk 'Figure 6 shows ARI and NMI as a function of e for the datasets.' 'CMR10' 9.963) $median | Should -BeNullOrEmpty
    }
    It 'still flags a colon-delimited caption regardless of font (legacy path preserved)' {
        Get-FurnitureKind (New-Chunk 'Figure 2: A schematic overview of the pipeline.' 'CMR10' 9.963) $median | Should -Be 'caption'
    }
    It 'does not treat a ghost-layer node (font=null) as small-font furniture' {
        Get-FurnitureKind (New-Chunk 'Fig. 3 in the ghost layer with a null font' $null 12.0) $median | Should -BeNullOrEmpty
    }
    It 'no-ops the small-font gate when no median is available (non-docling input)' {
        Get-FurnitureKind (New-Chunk 'Fig. 4 caption without any font metadata here' $null $null) 0 | Should -BeNullOrEmpty
    }
    It 'leaves ordinary body prose unflagged' {
        Get-FurnitureKind (New-Chunk 'The manifold hypothesis states data lies on a low-dimensional manifold.' 'CMR10' 9.963) $median | Should -BeNullOrEmpty
    }
}
