#requires -Version 7.0
# pdf-prose: codepoint audit, descender retention, two-column reading order.

BeforeAll {
    $repo = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    . (Join-Path $repo 'src/pdf-prose/pdf-prose.ps1')
    Import-PdfPigAssemblies

    function New-ProsePdf {
        param(
            [Parameter(Mandatory)] [scriptblock] $Draw,
            [double] $Width = 612,
            [double] $Height = 792
        )
        $builder = [UglyToad.PdfPig.Writer.PdfDocumentBuilder]::new()
        try {
            $font = $builder.AddStandard14Font(
                [UglyToad.PdfPig.Fonts.Standard14Fonts.Standard14Font]::TimesRoman)
            $page = $builder.AddPage($Width, $Height)
            & $Draw $page $font
            $builder.Build()
        }
        finally {
            $builder.Dispose()
        }
    }

    function Open-ProseExtract {
        param([byte[]] $Bytes, [string] $Name = 'page.pdf')
        $path = Join-Path $TestDrive $Name
        [IO.File]::WriteAllBytes($path, $Bytes)
        Invoke-PdfProseExtract -Path $path
    }
}

Describe 'Get-PdfProseCodepointAudit' {
    It 'counts scalars not UTF-16 units for a supplementary-plane pair' {
        $text = [string]::new([char[]]@([char]0xD83D, [char]0xDE00))  # U+1F600
        $a = Get-PdfProseCodepointAudit $text
        $a.Length | Should -Be 2
        $a.ScalarCount | Should -Be 1
        $a.IsolatedSurrogate | Should -Be 0
    }

    It 'flags an isolated high surrogate and does not invent a scalar' {
        $a = Get-PdfProseCodepointAudit ([string][char]0xD800)
        $a.IsolatedSurrogate | Should -Be 1
        $a.ScalarCount | Should -Be 0
    }

    It 'counts U+FFFD as a replacement scalar, not a drop' {
        $a = Get-PdfProseCodepointAudit ([string][char]0xFFFD)
        $a.Replacement | Should -Be 1
        $a.ScalarCount | Should -Be 1
    }
}

Describe 'Resolve-PdfProseNewLineHyphen' {
    It 'joins a mid-word line-break hyphen' {
        $d = Resolve-PdfProseNewLineHyphen 'infor-' 'mation'
        $d.Join | Should -BeTrue
        $d.Reason | Should -Be 'line-break'
    }

    It 'keeps a listed lexical compound' {
        $d = Resolve-PdfProseNewLineHyphen 'motor-' 'kinesthetic'
        $d.Join | Should -BeFalse
        $d.Reason | Should -Be 'lexical-compound'
        (Resolve-PdfProseNewLineHyphen 'well-' 'known').Join | Should -BeFalse
    }

    It 'keeps a number-word pair' {
        (Resolve-PdfProseNewLineHyphen 'twenty-' 'six').Join | Should -BeFalse
    }

    It 'joins a prefix even when both sides look like words' {
        $d = Resolve-PdfProseNewLineHyphen 'over-' 'come'
        $d.Join | Should -BeTrue
        $d.Reason | Should -Be 'prefix'
    }

    It 'does not join before uppercase or a non-letter' {
        (Resolve-PdfProseNewLineHyphen 'Mc-' 'Culloch').Join | Should -BeFalse
        (Resolve-PdfProseNewLineHyphen 'end-' '123').Join | Should -BeFalse
    }

    It 'always joins U+00AD and never joins U+2011' {
        (Resolve-PdfProseNewLineHyphen ("infor" + [char]0x00AD) 'mation').Join | Should -BeTrue
        (Resolve-PdfProseNewLineHyphen ("well" + [char]0x2011) 'known').Join | Should -BeFalse
    }

    It 'refuses a join when there is no newline after the hyphen' {
        $d = Resolve-PdfProseNewLineHyphen 'infor-' 'mation' -NewlineAfter $false
        $d.Join | Should -BeFalse
        $d.Reason | Should -Be 'no-newline-after-hyphen'
    }
}

Describe 'Test-PdfProseNewlineAfterHyphen' {
    It 'requires a downward baseline step, not a same-line or upward neighbor' {
        $hy = [pscustomobject]@{ PointSize = 10; StartBaseLine = [pscustomobject]@{ Y = 500.0 } }
        $below = [pscustomobject]@{ PointSize = 10; StartBaseLine = [pscustomobject]@{ Y = 486.0 } }
        $same = [pscustomobject]@{ PointSize = 10; StartBaseLine = [pscustomobject]@{ Y = 499.2 } }
        $above = [pscustomobject]@{ PointSize = 10; StartBaseLine = [pscustomobject]@{ Y = 640.0 } }
        Test-PdfProseNewlineAfterHyphen $hy $below | Should -BeTrue
        Test-PdfProseNewlineAfterHyphen $hy $same | Should -BeFalse
        Test-PdfProseNewlineAfterHyphen $hy $above | Should -BeFalse
    }
}

Describe 'Join-PdfProseLines' {
    It 'joins line-break hyphens and keeps lexical ones' {
        $j = Join-PdfProseLines @('infor-', 'mation about motor-', 'kinesthetic patterns')
        $j.Text | Should -Be "information about motor-`nkinesthetic patterns"
        $j.Edits.Count | Should -Be 1
        $j.Edits[0].Left | Should -Be 'infor'
        $j.Edits[0].Right | Should -Be 'mation'
    }

    It 'leaves hyphens in place when -RemoveNewLineHyphens is false' {
        (Join-PdfProseLines @('infor-', 'mation') -RemoveNewLineHyphens:$false).Text |
            Should -Be "infor-`nmation"
    }
}

Describe 'ConvertTo-PdfProseUtf16Escape' {
    It 'round-trips ligatures, unpaired surrogates, and supplementary pairs' {
        $emoji = [string]::new([char[]]@([char]0xD83D, [char]0xDE00))
        $src = 'brie' + [char]0xFB02 + 'y ' + [char]0xD800 + ' ' + $emoji + ' ' + [char]0x5C + 'uFB02'
        $enc = ConvertTo-PdfProseUtf16Escape $src
        $enc | Should -Be ('brie\uFB02y \uD800 \uD83D\uDE00 ' + [char]0x5C + [char]0x5C + 'uFB02')
        $enc.ToCharArray() | Where-Object { [int]$_ -gt 0x7E } | Should -BeNullOrEmpty
        (ConvertFrom-PdfProseUtf16Escape $enc) | Should -BeExactly $src
    }

    It 'keeps newline bytes as themselves' {
        (ConvertTo-PdfProseUtf16Escape "a`nb") | Should -Be "a`nb"
    }
}

Describe 'Get-PdfProseSpecials' {
    It 'indexes presentation-form ligatures by UTF-16 span, without rewriting them' {
        $fl = [char]0xFB02
        $text = "brie${fl}y"
        $s = @(Get-PdfProseSpecials $text)
        $s.Count | Should -Be 1
        $s[0].Kind | Should -Be 'ligature'
        $s[0].Scalar | Should -Be 0xFB02
        $s[0].Start | Should -Be 4
        $s[0].End | Should -Be 5
        $text.Substring($s[0].Start, $s[0].End - $s[0].Start) | Should -Be ([string]$fl)
    }
}

Describe 'Invoke-PdfProseExtract' {
    It 'keeps descenders that sit below the baseline' {
        $bytes = New-ProsePdf {
            param($page, $font)
            $null = $page.AddText('packing a pygmy guppy', 12,
                [UglyToad.PdfPig.Core.PdfPoint]::new(72, 700), $font)
        }
        $got = Open-ProseExtract $bytes 'descenders.pdf'
        $got.Text | Should -Match 'packing a pygmy guppy'
        $got.Diagnostics.IsolatedSurrogate | Should -Be 0
        $got.Diagnostics.Replacement | Should -Be 0
    }

    It 'reads the left column before the right column' {
        $bytes = New-ProsePdf {
            param($page, $font)
            $left = 56
            $right = 340
            $y = 720
            foreach ($n in 1..8) {
                $null = $page.AddText(("left column line {0} extra words" -f $n), 11,
                    [UglyToad.PdfPig.Core.PdfPoint]::new($left, $y), $font)
                $null = $page.AddText(("right column line {0} extra words" -f $n), 11,
                    [UglyToad.PdfPig.Core.PdfPoint]::new($right, $y), $font)
                $y -= 18
            }
        }
        $got = Open-ProseExtract $bytes 'two-col.pdf'
        $got.Pages[0].Blocks.Count | Should -BeGreaterOrEqual 2
        $text = $got.Text
        $left8 = $text.IndexOf('left column line 8')
        $right1 = $text.IndexOf('right column line 1')
        $left8 | Should -BeGreaterThan -1
        $right1 | Should -BeGreaterThan -1
        $left8 | Should -BeLessThan $right1
        $text | Should -Not -Match 'left column line 1 extra words\s+right column line 1'
    }

    It 'round-trips U+00E9 from an embedded Times TrueType' {
        $ttf = 'C:\Windows\Fonts\times.ttf'
        if (-not (Test-Path -LiteralPath $ttf)) {
            Set-ItResult -Skipped -Because "Times TrueType not at $ttf"
            return
        }
        $builder = [UglyToad.PdfPig.Writer.PdfDocumentBuilder]::new()
        try {
            $font = $builder.AddTrueTypeFont([IO.File]::ReadAllBytes($ttf))
            $page = $builder.AddPage(612, 792)
            $null = $page.AddText(("caf{0} naive" -f [char]0xE9), 12,
                [UglyToad.PdfPig.Core.PdfPoint]::new(72, 700), $font)
            $bytes = $builder.Build()
        }
        finally { $builder.Dispose() }
        $got = Open-ProseExtract $bytes 'latin1.pdf'
        $got.Diagnostics.IsolatedSurrogate | Should -Be 0
        $got.Text.ToCharArray() | Should -Contain ([char]0xE9)
    }

    It 'writes UTF-8 without a BOM' {
        $bytes = New-ProsePdf {
            param($page, $font)
            $null = $page.AddText('hello', 12,
                [UglyToad.PdfPig.Core.PdfPoint]::new(72, 700), $font)
        }
        $pdf = Join-Path $TestDrive 'bom.pdf'
        $out = Join-Path $TestDrive 'out.txt'
        [IO.File]::WriteAllBytes($pdf, $bytes)
        $null = Invoke-PdfProseExtract -Path $pdf -OutFile $out
        $raw = [IO.File]::ReadAllBytes($out)
        $raw.Length | Should -BeGreaterThan 0
        if ($raw.Length -ge 3) {
            -not ($raw[0] -eq 0xEF -and $raw[1] -eq 0xBB -and $raw[2] -eq 0xBF) | Should -BeTrue
        }
    }
}

Describe 'ConvertTo-PdfProseRender' {
    It 'expands presentation ligatures and escapes non-letters, leaving Latin letters' {
        $src = 'brie' + [char]0xFB02 + 'y ' + [char]0x00E9 + ' ' + [char]0x2014
        $r = ConvertTo-PdfProseRender $src
        $r.Text | Should -Be "briefly $([char]0x00E9) \u2014"
        ($r.Specials | Where-Object Kind -eq 'ligature').Decision | Should -Be 'expand'
        ($r.Specials | Where-Object Kind -eq 'letter').Decision | Should -Be 'keep'
    }
}

Describe 'Export-PdfProseJsonl' {
    It 'emits document then one implicit section then blocks' {
        $bytes = New-ProsePdf {
            param($page, $font)
            $null = $page.AddText('only body', 12,
                [UglyToad.PdfPig.Core.PdfPoint]::new(72, 700), $font)
        }
        $pdf = Join-Path $TestDrive 'one.pdf'
        $jsonl = Join-Path $TestDrive 'one.jsonl'
        [IO.File]::WriteAllBytes($pdf, $bytes)
        $null = Export-PdfProseJsonl -Path $pdf -JsonlPath $jsonl
        $rows = Get-Content -LiteralPath $jsonl | ForEach-Object { $_ | ConvertFrom-Json }
        $rows[0].kind | Should -Be 'document'
        $rows[1].kind | Should -Be 'section'
        $rows[1].source | Should -Be 'implicit'
        $rows[2].kind | Should -Be 'block'
        $rows[2].role | Should -Be 'body'
        $rows[2].textEscaped | Should -Match 'only body'
        $rows[2].seq | Should -Be 0
    }

    It 'builds the IR as PSCustomObject records before writing JSONL' {
        $bytes = New-ProsePdf {
            param($page, $font)
            $null = $page.AddText('body', 12,
                [UglyToad.PdfPig.Core.PdfPoint]::new(72, 700), $font)
        }
        $pdf = Join-Path $TestDrive 'ir.pdf'
        $jsonl = Join-Path $TestDrive 'ir.jsonl'
        [IO.File]::WriteAllBytes($pdf, $bytes)
        $got = Export-PdfProseJsonl -Path $pdf -JsonlPath $jsonl
        $got.Ir.PSTypeNames | Should -Contain 'PdfProse.Ir'
        $got.Ir.Records[0] | Should -BeOfType pscustomobject
        $got.Ir.Records[0].PSTypeNames | Should -Contain 'PdfProse.Document'
        $got.Ir.Records[1].PSTypeNames | Should -Contain 'PdfProse.Section'
        $got.Ir.Records[2].PSTypeNames | Should -Contain 'PdfProse.Block'
        $got.Ir.Records[2].kind | Should -Be 'block'
    }

    It 'cuts blocks by outline destinations in outline order' {
        $builder = [UglyToad.PdfPig.Writer.PdfDocumentBuilder]::new()
        try {
            $font = $builder.AddStandard14Font(
                [UglyToad.PdfPig.Fonts.Standard14Fonts.Standard14Font]::TimesRoman)
            $p1 = $builder.AddPage(612, 792)
            $null = $p1.AddText('alpha body text', 12,
                [UglyToad.PdfPig.Core.PdfPoint]::new(72, 700), $font)
            $p2 = $builder.AddPage(612, 792)
            $null = $p2.AddText('beta body text', 12,
                [UglyToad.PdfPig.Core.PdfPoint]::new(72, 700), $font)
            $fit = [UglyToad.PdfPig.Outline.Destinations.ExplicitDestinationType]::FitPage
            $empty = [UglyToad.PdfPig.Outline.Destinations.ExplicitDestinationCoordinates]::Empty
            $none = [UglyToad.PdfPig.Outline.BookmarkNode[]]@()
            $a = [UglyToad.PdfPig.Outline.DocumentBookmarkNode]::new(
                'Alpha', 0,
                [UglyToad.PdfPig.Outline.Destinations.ExplicitDestination]::new(1, $fit, $empty),
                $none)
            $b = [UglyToad.PdfPig.Outline.DocumentBookmarkNode]::new(
                'Beta', 0,
                [UglyToad.PdfPig.Outline.Destinations.ExplicitDestination]::new(2, $fit, $empty),
                $none)
            $builder.Bookmarks = [UglyToad.PdfPig.Outline.Bookmarks]::new(
                [UglyToad.PdfPig.Outline.BookmarkNode[]]@($a, $b))
            $bytes = $builder.Build()
        }
        finally { $builder.Dispose() }
        $pdf = Join-Path $TestDrive 'two.pdf'
        $jsonl = Join-Path $TestDrive 'two.jsonl'
        [IO.File]::WriteAllBytes($pdf, $bytes)
        $null = Export-PdfProseJsonl -Path $pdf -JsonlPath $jsonl
        $rows = Get-Content -LiteralPath $jsonl | ForEach-Object { $_ | ConvertFrom-Json }
        $kinds = $rows | ForEach-Object { $_.kind }
        $kinds | Should -Be @('document', 'section', 'block', 'section', 'block')
        $secs = $rows | Where-Object kind -eq 'section'
        $secs[0].titleEscaped | Should -Be 'Alpha'
        $secs[1].titleEscaped | Should -Be 'Beta'
        $secs[0].source | Should -Be 'outline'
        $blocks = $rows | Where-Object kind -eq 'block'
        $blocks[0].section | Should -Be $secs[0].id
        $blocks[1].section | Should -Be $secs[1].id
        $blocks[0].textEscaped | Should -Match 'alpha'
        $blocks[1].textEscaped | Should -Match 'beta'
        $blocks[0].seq | Should -BeLessThan $blocks[1].seq
    }
}

Describe 'Resolve-PdfProseBlockRole' {
    It 'tags page markers, top-band folio and header, captions, and image overlap' {
        $pageH = 680.4
        $img = [pscustomobject]@{ Left = 60; Bottom = 275; Right = 392; Top = 323 }
        $marker = [pscustomobject]@{ Text = '[123]'; Top = 619; Bottom = 614; Left = 34; Right = 48 }
        $folio = [pscustomobject]@{ Text = '249'; Top = 643.7; Bottom = 639; Left = 397; Right = 410 }
        $head = [pscustomobject]@{ Text = 'THE REDUNDANCY OF ENGLISH'; Top = 643.7; Bottom = 639; Left = 177; Right = 303 }
        $cap = [pscustomobject]@{ Text = 'Figure 22'; Top = 268; Bottom = 263; Left = 210; Right = 242 }
        $label = [pscustomobject]@{ Text = 'encoder'; Top = 310; Bottom = 300; Left = 80; Right = 140 }
        $body = [pscustomobject]@{ Text = 'The chief subject I should like to discuss'; Top = 549; Bottom = 332; Left = 56; Right = 396 }
        Resolve-PdfProseBlockRole -Block $marker -PageWidth 467 -PageHeight $pageH -Floats @($img) | Should -Be 'page-marker'
        Resolve-PdfProseBlockRole -Block $folio -PageWidth 467 -PageHeight $pageH -Floats @($img) | Should -Be 'folio'
        Resolve-PdfProseBlockRole -Block $head -PageWidth 467 -PageHeight $pageH -Floats @($img) | Should -Be 'running-header'
        Resolve-PdfProseBlockRole -Block $cap -PageWidth 467 -PageHeight $pageH -Floats @($img) | Should -Be 'float-caption'
        Resolve-PdfProseBlockRole -Block $label -PageWidth 467 -PageHeight $pageH -Floats @($img) | Should -Be 'float-label'
        Resolve-PdfProseBlockRole -Block $body -PageWidth 467 -PageHeight $pageH -Floats @($img) | Should -Be 'body'
    }
}

Describe 'Test-PdfProseFloatBeforeBlock' {
    It 'inserts on body or caption below the image, not on a page-marker' {
        $f = [pscustomobject]@{ Top = 323.2 }
        $marker = [pscustomobject]@{ Role = 'page-marker'; Top = 242.2 }
        $title = [pscustomobject]@{ Role = 'body'; Top = 623.3 }
        $cap = [pscustomobject]@{ Role = 'float-caption'; Top = 268.2 }
        Test-PdfProseFloatBeforeBlock $f $marker | Should -BeFalse
        Test-PdfProseFloatBeforeBlock $f $title | Should -BeFalse
        Test-PdfProseFloatBeforeBlock $f $cap | Should -BeTrue
    }
}

Describe 'Bind-PdfProseFloatCaptions' {
    It 'attaches a just-below Figure caption to the image float' {
        $float = [pscustomobject]@{ Index = 0; Type = 'image'; Caption = $null; Left = 60; Bottom = 275; Right = 392; Top = 323 }
        $cap = [pscustomobject]@{ Text = 'Figure 22'; Role = 'float-caption'; FloatIndex = $null; Top = 268; Bottom = 263; Left = 210; Right = 242 }
        $body = [pscustomobject]@{ Text = 'The second box'; Role = 'body'; FloatIndex = $null; Top = 244; Bottom = 60; Left = 56; Right = 396 }
        Bind-PdfProseFloatCaptions -Blocks @($cap, $body) -Floats @($float)
        $float.Caption | Should -Be 'Figure 22'
        $cap.FloatIndex | Should -Be 0
        $body.FloatIndex | Should -BeNullOrEmpty
    }
}

Describe 'Export-PdfProseJsonl floats' {
    It 'emits an image float and tags the caption, header, and folio' {
        $png = [byte[]]@(
            0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A,0x00,0x00,0x00,0x0D,0x49,0x48,0x44,0x52,
            0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x01,0x08,0x02,0x00,0x00,0x00,0x90,0x77,0x53,
            0xDE,0x00,0x00,0x00,0x0C,0x49,0x44,0x41,0x54,0x08,0xD7,0x63,0xF8,0xCF,0xC0,0x00,
            0x00,0x03,0x01,0x01,0x00,0x18,0xDD,0x8D,0xB0,0x00,0x00,0x00,0x00,0x49,0x45,0x4E,
            0x44,0xAE,0x42,0x60,0x82
        )
        $builder = [UglyToad.PdfPig.Writer.PdfDocumentBuilder]::new()
        try {
            $font = $builder.AddStandard14Font(
                [UglyToad.PdfPig.Fonts.Standard14Fonts.Standard14Font]::TimesRoman)
            $page = $builder.AddPage(612, 792)
            $null = $page.AddText('THE RUNNING HEADER', 9,
                [UglyToad.PdfPig.Core.PdfPoint]::new(200, 770), $font)
            $null = $page.AddText('12', 9,
                [UglyToad.PdfPig.Core.PdfPoint]::new(550, 770), $font)
            $null = $page.AddPng($png,
                [UglyToad.PdfPig.Core.PdfRectangle]::new(100, 400, 300, 460))
            $null = $page.AddText('Figure 1', 10,
                [UglyToad.PdfPig.Core.PdfPoint]::new(160, 380), $font)
            $null = $page.AddText('Body paragraph after the figure continues here with extra words.', 12,
                [UglyToad.PdfPig.Core.PdfPoint]::new(72, 300), $font)
            $bytes = $builder.Build()
        }
        finally { $builder.Dispose() }
        $pdf = Join-Path $TestDrive 'float.pdf'
        $jsonl = Join-Path $TestDrive 'float.jsonl'
        [IO.File]::WriteAllBytes($pdf, $bytes)
        $got = Export-PdfProseJsonl -Path $pdf -JsonlPath $jsonl
        $got.Ir.Records | Where-Object { $_.PSTypeNames -contains 'PdfProse.Float' } | Should -Not -BeNullOrEmpty
        $rows = Get-Content -LiteralPath $jsonl | ForEach-Object { $_ | ConvertFrom-Json }
        $float = @($rows | Where-Object kind -eq 'float')
        $float.Count | Should -Be 1
        $float[0].type | Should -Be 'image'
        $float[0].captionRender | Should -Match 'Figure 1'
        $roles = @($rows | Where-Object kind -eq 'block' | ForEach-Object { $_.role })
        $roles | Should -Contain 'float-caption'
        $roles | Should -Contain 'running-header'
        $roles | Should -Contain 'folio'
        $roles | Should -Contain 'body'
        $body = @($rows | Where-Object { $_.kind -eq 'block' -and $_.role -eq 'body' })
        $body.Count | Should -BeGreaterThan 0
        ($body | ForEach-Object { $_.textRender }) -join ' ' | Should -Match 'Body paragraph'
        ($body | ForEach-Object { $_.textRender }) -join ' ' | Should -Not -Match 'Figure 1'
        ($body | ForEach-Object { $_.textRender }) -join ' ' | Should -Not -Match 'RUNNING HEADER'
    }
}
