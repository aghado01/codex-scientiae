#requires -Version 7.0
# Content-normalization passes (normalize.ps1 / md-cleanup.ps1). Folds in the ad-hoc dev probes for
# Optimize-MathContent and markdown-cleanup idempotency, plus the math_dirt mask-algebra value-identity.

BeforeAll {
    . "$PSScriptRoot/../src/codex-membrane/normalize.ps1"    # Optimize-MathContent, Convert-MathToLatex, $script:MathLatexRx
    . "$PSScriptRoot/../src/audits/md-cleanup.ps1"   # Invoke-MarkdownCleanup
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

Describe 'Move-CaptionsToAnchors — relocate a shattered caption to its in-text figure anchor' {
    # The emission-order reorder is the OTHER half of the leaked-caption story: normalize CLASSIFIES the
    # stray "Fig. 1 ..." as is_furniture='caption' (above); finalize must then move it beside the paragraph
    # that first references Figure 1, instead of leaving it stranded mid-prose. Functions live in finalize.ps1.
    BeforeAll {
        . "$PSScriptRoot/../src/codex-membrane/finalize.ps1"   # Get-CaptionLabel, Test-FigureReference, Move-CaptionsToAnchors
        function New-BodyChunk($id, $content, $furn) { [pscustomobject]@{ id = $id; type = 'prose'; content = $content; is_furniture = $furn } }
        # the 2207.00510 specimen, trimmed to the local reading order around the leaked Fig. 1 caption
        function New-Specimen {
            @(
                New-BodyChunk 137 'Figure 1 shows the Adjusted Rand Index (ARI) and the Normalized Mutual Information (NMI) for different values.' $null
                New-BodyChunk 138 'Several aspects need to be emphasized. First of all, the effect is complicated (Figure 1 , first column (A)).' $null
                New-BodyChunk 139 '1000-dimensional data ( 2nd row) than in the 100-dimensional data.' $null
                New-BodyChunk 141 'Fig. 1 ARI and NMI as a function of $\varepsilon$ for the synthetic settings (see Table 1 for specifications). For the explored ranges, see Fig. 6 .' 'caption'
                New-BodyChunk 142 'Secondly, finding a suitable value of $\varepsilon$ is very challenging using DBSCAN alone.' $null
                New-BodyChunk 143 'Finally, the crucial point we want to highlight with these examples (see Figure 1 B).' $null
            )
        }
    }

    It 'moves the leaked "Fig. 1 ..." caption to immediately after the first "Figure 1 shows ..." anchor' {
        $out = @(Move-CaptionsToAnchors (New-Specimen))
        $ids = @($out | ForEach-Object { [int]$_.id })
        $ids | Should -Be @(137, 141, 138, 139, 142, 143)   # caption (141) now trails its anchor (137)
    }

    It 'restores the interrupted First/Secondly/Finally argument to a contiguous run' {
        $out = @(Move-CaptionsToAnchors (New-Specimen))
        $prose = @($out | Where-Object { -not $_.is_furniture } | ForEach-Object { [int]$_.id })
        $prose | Should -Be @(137, 138, 139, 142, 143)      # no caption breaks the flow anymore
    }

    It 'is idempotent — a second pass is a no-op' {
        $once  = @(Move-CaptionsToAnchors (New-Specimen))
        $twice = @(Move-CaptionsToAnchors $once)
        (@($twice | ForEach-Object { [int]$_.id })) | Should -Be (@($once | ForEach-Object { [int]$_.id }))
    }

    It 'leaves a caption in place when its figure number is never referenced in the body' {
        $chunks = @(
            New-BodyChunk 10 'Ordinary opening paragraph with no figure reference at all.' $null
            New-BodyChunk 11 'Fig. 9 an orphaned caption whose figure is never cited by number.' 'caption'
            New-BodyChunk 12 'A closing paragraph, also with no figure reference.' $null
        )
        (@(Move-CaptionsToAnchors $chunks | ForEach-Object { [int]$_.id })) | Should -Be @(10, 11, 12)
    }

    It 'preserves reading order untouched when there are no captions to move' {
        $chunks = @(
            New-BodyChunk 1 'First paragraph mentioning Figure 1 in passing.' $null
            New-BodyChunk 2 'Second paragraph of ordinary body prose.' $null
            New-BodyChunk 3 'Third paragraph, still no furniture.' $null
        )
        (@(Move-CaptionsToAnchors $chunks | ForEach-Object { [int]$_.id })) | Should -Be @(1, 2, 3)
    }

    It 'moves a caption DOWN when it precedes its first reference (both directions covered)' {
        $chunks = @(
            New-BodyChunk 20 'Fig. 5 Effect of UMAP on data with connected components.' 'caption'   # caption precedes its ref
            New-BodyChunk 21 'Body prose in between, no figure reference here.' $null
            New-BodyChunk 22 'First of all, consider Figure 5 A, which shows a 2D dataset.' $null     # the anchor, later
        )
        (@(Move-CaptionsToAnchors $chunks | ForEach-Object { [int]$_.id })) | Should -Be @(21, 22, 20)  # caption now trails id 22
    }

    It 'leaves TABLE captions in reading order — figure-only scope (tables are not image-stripped)' {
        $chunks = @(
            New-BodyChunk 20 'Table 3 Maximum ARI and NMI ranges for FCPS data.' 'caption'   # a figure caption here WOULD move
            New-BodyChunk 21 'Body prose in between, no reference here.' $null
            New-BodyChunk 22 'Full numbers are shown in Table 3 for the FCPS data.' $null      # a real Table 3 reference, later
        )
        (@(Move-CaptionsToAnchors $chunks | ForEach-Object { [int]$_.id })) | Should -Be @(20, 21, 22)  # table caption unmoved
    }

    It 'does not drag a Table 2 caption onto a "Tab. 2" bibliographic cross-cite (the specimen false-anchor)' {
        $chunks = @(
            New-BodyChunk 30 'Figure 1 shows the NMI with maximum normalization ( Vinh et al , 2010 , Tab. 2 ) here.' $null
            New-BodyChunk 31 'Body prose in between with no table reference.' $null
            New-BodyChunk 32 'Table 2 Characteristics of the FCPS datasets.' 'caption'
        )
        # the "Tab. 2" above cites ANOTHER work's table; this paper's Table 2 caption must stay put, not jump to id 30
        (@(Move-CaptionsToAnchors $chunks | ForEach-Object { [int]$_.id })) | Should -Be @(30, 31, 32)
    }

    It 'Get-CaptionLabel reads the LEADING label, ignoring cross-refs inside the caption body' {
        $lab = Get-CaptionLabel (New-BodyChunk 0 'Fig. 1 ... (see Table 1 for specifications) ... see Fig. 6 .' 'caption')
        $lab.kind | Should -Be 'figure'
        $lab.num  | Should -Be '1'
        Get-CaptionLabel (New-BodyChunk 0 'Table 3 Maximum ARI and NMI.' 'caption') | ForEach-Object { "$($_.kind)$($_.num)" } | Should -Be 'table3'
        Get-CaptionLabel (New-BodyChunk 0 'An ordinary paragraph, not a caption.' $null) | Should -BeNullOrEmpty
    }

    It 'Test-FigureReference is digit-bounded ("Figure 1" never matches "Figure 10")' {
        $fig1 = [pscustomobject]@{ kind = 'figure'; num = '1' }
        Test-FigureReference (New-BodyChunk 0 'As seen in Figure 1 the trend holds.' $null) $fig1  | Should -BeTrue
        Test-FigureReference (New-BodyChunk 0 '(Figure 1 , first column (A)) shows this.' $null) $fig1 | Should -BeTrue
        Test-FigureReference (New-BodyChunk 0 'As seen in Figure 10 the trend holds.' $null) $fig1 | Should -BeFalse
        Test-FigureReference (New-BodyChunk 0 'Nothing about figures here at all.' $null) $fig1     | Should -BeFalse
    }
    It 'Test-FigureReference is case-sensitive so a lowercase word is never a false anchor' {
        $fig1 = [pscustomobject]@{ kind = 'figure'; num = '1' }
        # real in-text references are capitalized; a lowercase "figure 1" (or a word like "reconfigure 1") must not match
        Test-FigureReference (New-BodyChunk 0 'the figure 1 rows above are illustrative' $null) $fig1 | Should -BeFalse
    }
}
