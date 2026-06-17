#requires -Version 7.0
# Content-normalization passes (normalize.ps1 / md-cleanup.ps1). Folds in the ad-hoc dev probes for
# Optimize-MathContent and markdown-cleanup idempotency, plus the math_dirt mask-algebra value-identity.

BeforeAll {
    . "$PSScriptRoot/../src/normalize.ps1"    # Optimize-MathContent, Convert-MathToLatex, $script:MathLatexRx
    . "$PSScriptRoot/../src/md-cleanup.ps1"   # Invoke-MarkdownCleanup
    # the legacy (pre-port) math_dirt formula, kept here to pin the value-identity of the new one
    function Old-MathDirt([string]$w) { return ($script:MathLatexRx.Matches([regex]::Replace($w, '\$[^$\n]+\$', ' ')).Count) }
    function New-MathDirt([string]$w) { return (Get-MaskDensity -Text $w -Within (Complement-Mask (New-Mask $w '\$[^$\n]+\$')) -Register $script:MathLatexRx) }
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

Describe 'math_dirt — mask-algebra value-identical to the legacy blank-and-count (frozen contract)' {
    It 'matches on fixed inputs including SMP and bare symbols' {
        $blackboardE = [char]::ConvertFromUtf32(0x1D53C)   # SMP 𝔼 (two UTF-16 units)
        $alpha = [char]0x03B1; $in = [char]0x2208; $sum = [char]0x2211; $int = [char]0x222B
        $samples = @(
            "rate $blackboardE and $alpha outside, `$\alpha`$ inside, then $in more"
            'plain prose with no math at all'
            "`$\alpha \beta`$ everything wrapped"
            "$sum $int bare operators outside any span"
        )
        foreach ($s in $samples) { (New-MathDirt $s) | Should -Be (Old-MathDirt $s) }
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
