#requires -Version 7.0
<#
  tests/pdf-converter/math-evidence.Tests.ps1 — the modality-bridge projection (src/pdf-converter/math-evidence.ps1):
  glyph geometry -> a text transcript a reasoning model can repair math from.
#>

BeforeAll {
    . "$PSScriptRoot/../../src/pdf-converter/math-evidence.ps1"
    function G([string]$t, [double]$x, [double]$y, [double]$sz) {
        [pscustomobject]@{ text=$t; page=1; bx=@($x, ($y-1), ($x+3), ($y+$sz)); base=@($x, $y); size=$sz; font='CMMI10' }
    }
}

Describe 'spatial sketch' {
    It 'places numerator above and denominator below a rule bar (fraction gestalt)' {
        $num = @( (G 'a' 10 108 10), (G '+' 13 108 10), (G 'b' 17 108 10) )
        $den = @( (G 'c' 10 92 10),  (G '+' 13 92 10),  (G 'd' 17 92 10) )
        $rule = [pscustomobject]@{ page=1; rule='hrule'; bbox=@(10.0, 100.0, 20.0, 100.0) }
        $sketch = Get-SpatialSketch -Letters ($num + $den) -Rules @($rule)
        $rows = $sketch -split "`n"
        $rows.Count | Should -BeGreaterOrEqual 3
        $rows[0] | Should -Match 'a.*b'            # numerator on top
        ($rows -join '') | Should -Match "$([char]0x2500)"   # the ─ rule bar is drawn
        $rows[-1] | Should -Match 'c.*d'           # denominator on the bottom
    }
}

Describe 'evidence payload' {
    It 'assembles a labeled block with the glyph table and layout' {
        $g = @( (G 't' 0 100 10), (G 'v' 4 98.5 7), (G 'i' 7 97.5 5) )
        $ev = Get-MathEvidence -Letters $g -Latex 't_{v_{i}}' -Note 'demo'
        $ev | Should -Match 'MATH ASSEMBLY EVIDENCE'
        $ev | Should -Match 'best-effort LaTeX : t_\{v_\{i\}\}'
        $ev | Should -Match 'tier'          # the glyph table header
        $ev | Should -Match 'spatial layout'
    }

    It 'reports the size tier (script depth) per glyph' {
        $g = @( (G 't' 0 100 10), (G 'v' 4 98.5 7), (G 'i' 7 97.5 5) )
        $tbl = Get-GlyphTable $g
        # base=tier 0, first script=tier 1, nested=tier 2
        ($tbl -split "`n" | Where-Object { $_ -match '\bt\b' }) -join '' | Should -Match '\| 0\s*$'
        ($tbl -split "`n" | Where-Object { $_ -match '\bi\b' }) -join '' | Should -Match '\| 2\s*$'
    }
}

Describe 'the membrane seam (Get-ChunkMathEvidence)' {
    It 'degrades to null when the pig geometry is absent (docling-lane chunk)' {
        $chunk = [pscustomobject]@{ type='formula'; page=1; bbox=@(0.0,0.0,10.0,10.0); content='x'; flags=@() }
        Get-ChunkMathEvidence -Chunk $chunk -PaperDir ([System.IO.Path]::GetTempPath()) -Slug 'no-such-paper' | Should -BeNullOrEmpty
    }

    It 'recovers a region and projects evidence when letters.jsonl exists' {
        $tmp = Join-Path ([System.IO.Path]::GetTempPath()) "mev-$([guid]::NewGuid())"
        New-Item -ItemType Directory -Path $tmp | Out-Null
        try {
            $recs = @(
                @{ page=1; text='t'; bx=@(50.0,138,54,148); base=@(50.0,141.8); size=10.0; font='CMMI10' }
                @{ page=1; text='v'; bx=@(55.0,137,58,144); base=@(55.0,140.3); size=7.0;  font='CMMI7'  }
            )
            $sw = [System.IO.StreamWriter]::new((Join-Path $tmp 'p.letters.jsonl'), $false, [System.Text.UTF8Encoding]::new($false))
            foreach ($r in $recs) { $sw.WriteLine(($r | ConvertTo-Json -Compress)) }
            $sw.Dispose()
            $chunk = [pscustomobject]@{ type='formula'; page=1; bbox=@(48.0,135.0,60.0,150.0); content='t_{v}'; flags=@('unbalanced_delimiters') }
            $ev = Get-ChunkMathEvidence -Chunk $chunk -PaperDir $tmp -Slug 'p'
            $ev | Should -Match 'converter flags: unbalanced_delimiters'
            $ev | Should -Match '\bt\b'
            $ev | Should -Match '\bv\b'
        } finally { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
    }
}
