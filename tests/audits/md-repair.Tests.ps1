#requires -Version 7.0
# md-repair.ps1 — byte-offset surgical repair for promoted markdown. Pins offset correctness (incl.
# multi-byte / SMP glyphs), the Set-MdSpan splice + stale-anchor guard, the heading classifier across
# every corruption category surveyed in bibliotecha/compendia/ph, and the back-to-front auto-fix + escalation.

BeforeAll {
    . "$PSScriptRoot/../../src/audits/md-repair.ps1"
    $script:U8 = [System.Text.UTF8Encoding]::new($false)
    function New-Md([string]$content) {
        $p = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '.md')
        [System.IO.File]::WriteAllText($p, $content, $script:U8)
        return $p
    }
    function Get-RawSpan([string]$path, [int]$offset, [int]$len) {
        $b = [System.IO.File]::ReadAllBytes($path)
        return $script:U8.GetString($b, $offset, $len)
    }
}

Describe 'Get-MdHeadings — byte offsets index on-disk bytes (multi-byte / SMP safe)' {
    It 'every heading offset+length slices back to the exact heading line, even past SMP math' {
        $smp = [char]::ConvertFromUtf32(0x1D54F)   # mathematical double-struck X (4 UTF-8 bytes)
        $d = [char]0x2202; $s = [char]0x03C3       # partial, sigma (multi-byte)
        $md = "# Title $smp`n`nbody $d$s here`n`n## Algorithm 1 Core algorithm`n`n### 2.3 Real subsection`n`nmore`n"
        $p = New-Md $md
        $heads = Get-MdHeadings -Path $p
        $heads.Count | Should -Be 3
        foreach ($h in $heads) { (Get-RawSpan $p $h.offset $h.length) | Should -BeExactly $h.raw }
    }
    It 'ignores headings inside fenced code blocks' {
        $p = New-Md "# T`n`n``````text`n## not a heading`n``````n`n## Real heading`n"
        (Get-MdHeadings -Path $p | Where-Object level -eq 2).text | Should -Be 'Real heading'
    }
}

Describe 'Get-MdHeadingVerdict — classification across the ph corruption categories' {
    It 'keeps real section headings: <t>' -ForEach @(
        @{ t = '1 Introduction' }, @{ t = '2.3 Bottleneck distance' }, @{ t = 'Abstract' }
        @{ t = '3.1. The algorithm.' }, @{ t = 'B Pairwise noise distances in high-dimensional spaces' }
        @{ t = '4 The curse of dimensionality for persistence homology' }
        @{ t = 'Acknowledgement' }, @{ t = 'Preliminaries' }, @{ t = 'Reproducibility statement' }
        @{ t = 'A Matrix Inversion in Matrix Multiplication Time' }
        @{ t = 'Appendix A. Background on Topology' }                       # appendix letter, not a fused sentence
        @{ t = 'Mapping Network to Metric Space' }, @{ t = 'Consequences' } # unnumbered section titles
        @{ t = '5. Proof-of-principle experimentation' }                    # "Proof-" is not a proof environment
        @{ t = '3.2 The First Mayer Path Homology Group H N,q 1' }          # numbered + math is still a heading
    ) { (Get-MdHeadingVerdict $t).verdict | Should -Be 'keep' }

    It 'demotes float captions (A): <t>' -ForEach @(
        @{ t = 'Algorithm 1 Core algorithm' }, @{ t = 'Algorithm 3.1 Pseudocode for converting input filtration' }
        @{ t = 'Algorithm 5 Row Algorithm( A = [ i,j ])' }
    ) { (Get-MdHeadingVerdict $t).verdict | Should -Be 'demote-caption' }

    It 'demotes theorem labels incl. number-prefixed/suffixed (B): <t>' -ForEach @(
        @{ t = '1. Proposition' }, @{ t = '6. Lemma' }
        @{ t = 'Proposition 13. Each interval produced by Algorithm 1 admits a set of 0-representatives.' }
        @{ t = 'Theorem 5.3. Algorithm 5 computes the lazy reduction.' }
    ) { (Get-MdHeadingVerdict $t).verdict | Should -Be 'demote-label' }

    It 'escalates furniture / table-fragments / fused body (C/D/E): <t>' -ForEach @(
        @{ t = 'XX :2' }, @{ t = 'April 1, 2025' }, @{ t = 'Dio2' }, @{ t = 'T Gudhi' }
        @{ t = 'The main part :' }                                                       # trailing-colon fragment
        @{ t = 'We observe that since w = 2, n is a power of 2, for L = 2 k' }           # formula operators -> prose
        @{ t = '3.1. The algorithm. Input : Start with a finite metric space X .' }      # body fused after the title
        @{ t = '1 Lawrence Berkeley National Laboratory 2 School of Mathematical Sciences' }
    ) { (Get-MdHeadingVerdict $t).verdict | Should -Be 'escalate' }
}

Describe 'Set-MdSpan — surgical splice + stale-anchor guard' {
    It 'replaces exactly the addressed span and leaves the rest byte-identical' {
        $p = New-Md "# Title`n`n## Algorithm 1 Core algorithm`n`ntail`n"
        $h = Get-MdHeadings -Path $p | Where-Object { $_.verdict -eq 'demote-caption' }
        Set-MdSpan -Path $p -Offset $h.offset -Length $h.length -Replacement $h.fix -Expect $h.raw
        $txt = [System.IO.File]::ReadAllText($p, $script:U8)
        $txt | Should -BeExactly "# Title`n`n**Algorithm 1 Core algorithm**`n`ntail`n"
    }
    It 'throws on a stale -Expect rather than corrupting the file' {
        $p = New-Md "# Title`n`n## Real heading`n"
        $h = Get-MdHeadings -Path $p | Where-Object level -eq 2
        { Set-MdSpan -Path $p -Offset $h.offset -Length $h.length -Replacement 'x' -Expect 'WRONG BYTES' } | Should -Throw
        [System.IO.File]::ReadAllText($p, $script:U8) | Should -Match '## Real heading'
    }
}

Describe 'Repair-MdHeadings — auto-fix the confident, isolate the rest' {
    It 'demotes captions/labels back-to-front, escalates furniture, keeps real sections' {
        $md = "# T`n`n## Algorithm 1 Core`n`n## XX :2`n`n## Proposition 7. A claim about cycles`n`n## 2 Preliminaries`n"
        $p = New-Md $md
        $r = Repair-MdHeadings -Path $p -Apply
        $r.applied  | Should -Be 2                         # caption + label demoted
        $r.escalate | Should -Be 1                         # XX :2 isolated
        $r.escalations.text | Should -Contain 'XX :2'
        $txt = [System.IO.File]::ReadAllText($p, $script:U8)
        $txt | Should -Match '\*\*Algorithm 1 Core\*\*'
        $txt | Should -Match '\*\*Proposition 7\. A claim about cycles\*\*'
        ($txt -split "`n" | Where-Object { $_ -match '^## ' }).Count | Should -Be 2   # XX:2 (escalated) + Preliminaries
    }
}
