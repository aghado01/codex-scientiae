#requires -Version 7.0
# src/masks.ps1 — the closed mask-algebra primitive set. Intrinsic validation: algebraic laws (hold by
# the math over ANY input), totality, codepoint safety, and the pincer level-lift coincidence. No corpus.

BeforeAll {
    . "$PSScriptRoot/../../src/shared/masks.ps1"
    function New-RandMask([int]$L) {
        $spans = [System.Collections.Generic.List[object]]::new()
        $k = Get-Random -Minimum 0 -Maximum 5
        for ($i = 0; $i -lt $k; $i++) { $spans.Add([pscustomobject]@{ Start = (Get-Random -Maximum $L); End = (Get-Random -Maximum $L) }) }
        return New-Mask -Spans $spans.ToArray() -Length $L
    }
    function New-FullMask([int]$L) { New-Mask -Spans @([pscustomobject]@{ Start = 0; End = $L }) -Length $L }
    function New-EmptyMask([int]$L) { New-Mask -Spans @() -Length $L }
    $L = 40
}

Describe 'mask algebra — laws hold over 100 random masks' {
    It 'Complement∘Complement = id' {
        foreach ($t in 1..100) { $A = New-RandMask $L; Test-MaskEqual (Complement-Mask (Complement-Mask $A $L) $L) $A | Should -BeTrue }
    }
    It 'Sub A A = ∅' { foreach ($t in 1..100) { $A = New-RandMask $L; Test-MaskEmpty (Sub-Mask $A $A) | Should -BeTrue } }
    It 'Union A (Complement A) = full' { foreach ($t in 1..100) { $A = New-RandMask $L; Test-MaskEqual (Union-Mask $A (Complement-Mask $A $L)) (New-FullMask $L) | Should -BeTrue } }
    It 'Intersect A (Complement A) = ∅' { foreach ($t in 1..100) { $A = New-RandMask $L; Test-MaskEmpty (Intersect-Mask $A (Complement-Mask $A $L)) | Should -BeTrue } }
    It 'De Morgan: ¬(A∪B) = ¬A ∩ ¬B' { foreach ($t in 1..100) { $A = New-RandMask $L; $B = New-RandMask $L; Test-MaskEqual (Complement-Mask (Union-Mask $A $B) $L) (Intersect-Mask (Complement-Mask $A $L) (Complement-Mask $B $L)) | Should -BeTrue } }
    It 'De Morgan: ¬(A∩B) = ¬A ∪ ¬B' { foreach ($t in 1..100) { $A = New-RandMask $L; $B = New-RandMask $L; Test-MaskEqual (Complement-Mask (Intersect-Mask $A $B) $L) (Union-Mask (Complement-Mask $A $L) (Complement-Mask $B $L)) | Should -BeTrue } }
    It 'normalize idempotent (rebuild from own spans = self)' { foreach ($t in 1..100) { $A = New-RandMask $L; Test-MaskEqual (New-Mask -Spans $A.Spans -Length $L) $A | Should -BeTrue } }
    It 'Intersect/Union idempotent and Sub identities' {
        foreach ($t in 1..50) {
            $A = New-RandMask $L; $e = New-EmptyMask $L
            Test-MaskEqual (Intersect-Mask $A $A) $A | Should -BeTrue
            Test-MaskEqual (Union-Mask $A $A) $A | Should -BeTrue
            Test-MaskEmpty (Sub-Mask $e $A) | Should -BeTrue
            Test-MaskEqual (Sub-Mask $A $e) $A | Should -BeTrue
        }
    }
}

Describe 'mask algebra — totality (never throws; normal form enforced)' {
    It 'complement of empty-over-0 is empty' { Test-MaskEmpty (Complement-Mask (New-EmptyMask 0) 0) | Should -BeTrue }
    It 'complement of full is empty' { Test-MaskEmpty (Complement-Mask (New-FullMask 10) 10) | Should -BeTrue }
    It 'reversed span tolerated' { (New-Mask -Spans @([pscustomobject]@{ Start = 8; End = 3 }) -Length 10).Spans[0].Start | Should -Be 3 }
    It 'out-of-range clamped' { (New-Mask -Spans @([pscustomobject]@{ Start = -5; End = 99 }) -Length 10).Spans[0].End | Should -Be 10 }
    It 'overlapping spans merge to one' { @((New-Mask -Spans @([pscustomobject]@{ Start = 0; End = 5 }, [pscustomobject]@{ Start = 3; End = 8 }) -Length 10).Spans).Count | Should -Be 1 }
    It 'adjacent spans merge to one' { @((New-Mask -Spans @([pscustomobject]@{ Start = 0; End = 3 }, [pscustomobject]@{ Start = 3; End = 6 }) -Length 10).Spans).Count | Should -Be 1 }
}

Describe 'mask algebra — codepoint safety (SMP math, surrogate pairs)' {
    BeforeAll { $smp = "x = 𝔼[𝕊] + ﬁ ﬂ ﬃ then $([char]0xFFFD) end" }   # 𝔼/𝕊 are SMP (2 UTF-16 units each)
    It 'no mask edge splits a surrogate pair' {
        $m = New-Mask $smp '𝔼\[𝕊\]'
        $bad = $false
        foreach ($sp in $m.Spans) {
            if ([char]::IsLowSurrogate($smp[$sp.Start])) { $bad = $true }
            if ($sp.End -lt $smp.Length -and [char]::IsLowSurrogate($smp[$sp.End]) -and [char]::IsHighSurrogate($smp[$sp.End - 1])) { $bad = $true }
        }
        $bad | Should -BeFalse
    }
    It 'an edge forced inside a surrogate pair snaps outward' {
        $eIdx = $smp.IndexOf([char]0xD835)   # high surrogate of 𝔼
        (New-Mask -Spans @([pscustomobject]@{ Start = $eIdx + 1; End = $smp.Length }) -Over $smp).Spans[0].Start | Should -Be $eIdx
    }
    It 'density still counts prose words outside the SMP region' {
        (Get-MaskDensity -Text $smp -Within (Complement-Mask (New-Mask $smp '𝔼\[𝕊\]')) -Register '[A-Za-z]{2,}') | Should -BeGreaterOrEqual 2
    }
}

Describe 'mask algebra — pincer (top-down == bottom-up)' {
    It 'Line-level masks lifted back equal the whole-string mask' {
        $multi = "a & b = c`n\begin{x} q & r `nfoo bar baz line three"
        $reg = '[A-Za-z]+'
        $top = Get-MaskDensity -Text $multi -Within (New-Mask -Spans @([pscustomobject]@{ Start = 0; End = $multi.Length }) -Length $multi.Length) -Register $reg -AsSpans
        $acc = New-Mask -Spans @() -Length $multi.Length
        foreach ($u in (Split-AtLevel -Text $multi -Level Line)) { $acc = Union-Mask $acc (Move-Mask (New-Mask $u.Text $reg) $u.Start $multi.Length) }
        Test-MaskEqual $top $acc | Should -BeTrue
    }
}
