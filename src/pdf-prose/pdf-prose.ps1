#requires -Version 7.0
# PdfPig prose extract: letters → nearest-neighbour words → RecursiveXYCut → column-wise order.

function Import-PdfPigAssemblies {
    [CmdletBinding()]
    param(
        [string] $PdfPigRoot
    )
    if (-not $PdfPigRoot) {
        $repo = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
        $PdfPigRoot = Join-Path $repo 'packages/pdfpig'
    }
    $names = @(
        'UglyToad.PdfPig.Tokens',
        'UglyToad.PdfPig.Core',
        'UglyToad.PdfPig.Tokenization',
        'UglyToad.PdfPig.Fonts',
        'UglyToad.PdfPig',
        'UglyToad.PdfPig.DocumentLayoutAnalysis'
    )
    foreach ($n in $names) {
        $dll = Join-Path $PdfPigRoot "$n.dll"
        if (-not [IO.File]::Exists($dll)) {
            throw "Import-PdfPigAssemblies: missing '$dll'"
        }
        if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq $n })) {
            Add-Type -Path $dll
        }
    }
}

function Get-PdfProseCodepointAudit {
    [CmdletBinding()]
    param(
        [AllowEmptyString()] [string] $Text
    )
    $replacement = 0
    $isolatedSurrogate = 0
    $noncharacter = 0
    $privateUse = 0
    $scalarCount = 0
    if ($Text) {
        $i = 0
        $len = $Text.Length
        $rune = [System.Text.Rune]::new(0)
        while ($i -lt $len) {
            if (-not [System.Text.Rune]::TryGetRuneAt($Text, $i, [ref]$rune)) {
                $isolatedSurrogate++
                $i++
                continue
            }
            $cp = $rune.Value
            $scalarCount++
            if ($cp -eq 0xFFFD) { $replacement++ }
            if (($cp -ge 0xFDD0 -and $cp -le 0xFDEF) -or (($cp -band 0xFFFE) -eq 0xFFFE)) {
                $noncharacter++
            }
            if (($cp -ge 0xE000 -and $cp -le 0xF8FF) -or
                ($cp -ge 0xF0000 -and $cp -le 0xFFFFD) -or
                ($cp -ge 0x100000 -and $cp -le 0x10FFFD)) {
                $privateUse++
            }
            $i += $rune.Utf16SequenceLength
        }
    }
    [pscustomobject]@{
        Length             = if ($null -eq $Text) { 0 } else { $Text.Length }
        ScalarCount        = $scalarCount
        Replacement        = $replacement
        IsolatedSurrogate  = $isolatedSurrogate
        Noncharacter       = $noncharacter
        PrivateUse         = $privateUse
    }
}

function Merge-PdfProseCodepointAudit {
    param($Acc, $Next)
    if ($null -eq $Acc) { return $Next }
    $Acc.Length            += $Next.Length
    $Acc.ScalarCount       += $Next.ScalarCount
    $Acc.Replacement       += $Next.Replacement
    $Acc.IsolatedSurrogate += $Next.IsolatedSurrogate
    $Acc.Noncharacter      += $Next.Noncharacter
    $Acc.PrivateUse        += $Next.PrivateUse
    $Acc
}

function ConvertTo-PdfProseUtf16Escape {
    [CmdletBinding()]
    param(
        [AllowEmptyString()] [AllowNull()] [string] $Text
    )
    if ([string]::IsNullOrEmpty($Text)) { return '' }
    $sb = [System.Text.StringBuilder]::new($Text.Length * 2)
    foreach ($ch in $Text.ToCharArray()) {
        $u = [int]$ch
        if ($ch -eq [char]0x5C) {
            [void]$sb.Append('\\')
        }
        elseif ($u -eq 0x09 -or $u -eq 0x0A -or $u -eq 0x0D -or ($u -ge 0x20 -and $u -le 0x7E)) {
            [void]$sb.Append($ch)
        }
        else {
            [void]$sb.AppendFormat('\u{0:X4}', $u)
        }
    }
    $sb.ToString()
}

function ConvertFrom-PdfProseUtf16Escape {
    [CmdletBinding()]
    param(
        [AllowEmptyString()] [AllowNull()] [string] $Text
    )
    if ([string]::IsNullOrEmpty($Text)) { return '' }
    $sb = [System.Text.StringBuilder]::new($Text.Length)
    $i = 0
    $len = $Text.Length
    while ($i -lt $len) {
        $c = $Text[$i]
        if ($c -ne [char]0x5C) {
            [void]$sb.Append($c)
            $i++
            continue
        }
        if ($i + 1 -ge $len) {
            throw 'ConvertFrom-PdfProseUtf16Escape: trailing backslash'
        }
        $n = $Text[$i + 1]
        if ($n -eq [char]0x5C) {
            [void]$sb.Append([char]0x5C)
            $i += 2
            continue
        }
        if ($n -eq [char]'u' -and $i + 5 -lt $len) {
            $hex = $Text.Substring($i + 2, 4)
            $unit = 0
            if (-not [int]::TryParse($hex,
                    [Globalization.NumberStyles]::AllowHexSpecifier,
                    [Globalization.CultureInfo]::InvariantCulture,
                    [ref]$unit)) {
                throw "ConvertFrom-PdfProseUtf16Escape: bad \\u escape at $i"
            }
            [void]$sb.Append([char]$unit)
            $i += 6
            continue
        }
        throw "ConvertFrom-PdfProseUtf16Escape: unknown escape at $i"
    }
    $sb.ToString()
}

$script:PdfProseNewLineHyphen = $null

function Get-PdfProseNewLineHyphenConfig {
    if ($null -ne $script:PdfProseNewLineHyphen) { return $script:PdfProseNewLineHyphen }
    $path = Join-Path $PSScriptRoot 'newline-hyphens.json'
    $raw = Get-Content -LiteralPath $path -Raw -Encoding utf8
    $cfg = $raw | ConvertFrom-Json
    $set = {
        param($items)
        $h = [System.Collections.Generic.HashSet[string]]::new(
            [StringComparer]::OrdinalIgnoreCase)
        foreach ($x in $items) { [void]$h.Add([string]$x) }
        $h
    }
    $script:PdfProseNewLineHyphen = [pscustomobject]@{
        Prefixes     = & $set $cfg.prefixes
        KeepLeft     = & $set $cfg.keepLeft
        NumberWords  = & $set $cfg.numberWords
    }
    $script:PdfProseNewLineHyphen
}

function Get-PdfProseLetterRun {
    param([string] $Text, [int] $Start, [int] $Direction)
    if ([string]::IsNullOrEmpty($Text)) { return '' }
    $sb = [System.Text.StringBuilder]::new()
    $rune = [System.Text.Rune]::new(0)
    if ($Direction -ge 0) {
        $i = $Start
        while ($i -lt $Text.Length) {
            if (-not [System.Text.Rune]::TryGetRuneAt($Text, $i, [ref]$rune)) { break }
            $cat = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($rune.Value)
            if ($cat -notin @(
                    [System.Globalization.UnicodeCategory]::LowercaseLetter,
                    [System.Globalization.UnicodeCategory]::UppercaseLetter,
                    [System.Globalization.UnicodeCategory]::TitlecaseLetter,
                    [System.Globalization.UnicodeCategory]::ModifierLetter,
                    [System.Globalization.UnicodeCategory]::OtherLetter)) {
                break
            }
            [void]$sb.Append($rune.ToString())
            $i += $rune.Utf16SequenceLength
        }
    }
    else {
        $i = $Start
        $stack = [System.Collections.Generic.List[string]]::new()
        while ($i -gt 0) {
            $prev = $i - 1
            if ([char]::IsLowSurrogate($Text[$prev]) -and $prev -gt 0 -and
                [char]::IsHighSurrogate($Text[$prev - 1])) {
                $prev = $prev - 1
            }
            if (-not [System.Text.Rune]::TryGetRuneAt($Text, $prev, [ref]$rune)) { break }
            $cat = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($rune.Value)
            if ($cat -notin @(
                    [System.Globalization.UnicodeCategory]::LowercaseLetter,
                    [System.Globalization.UnicodeCategory]::UppercaseLetter,
                    [System.Globalization.UnicodeCategory]::TitlecaseLetter,
                    [System.Globalization.UnicodeCategory]::ModifierLetter,
                    [System.Globalization.UnicodeCategory]::OtherLetter)) {
                break
            }
            $stack.Add($rune.ToString())
            $i = $prev
        }
        for ($k = $stack.Count - 1; $k -ge 0; $k--) { [void]$sb.Append($stack[$k]) }
    }
    $sb.ToString()
}

function Test-PdfProseWordLike {
    param([string] $Token, $NumberWords)
    if ([string]::IsNullOrEmpty($Token)) { return $false }
    if ($NumberWords.Contains($Token)) { return $true }
    $hasVowel = $Token -match '[AEIOUYaeiouy\u00C0-\u00F6\u00F8-\u00FF]'
    return ($Token.Length -ge 4 -and $hasVowel)
}

function Test-PdfProseNewlineAfterHyphen {
    param(
        $HyphenLetter,
        $NextLetter,
        [double] $MinDrop = 0.45
    )
    if ($null -eq $HyphenLetter -or $null -eq $NextLetter) { return $false }
    $hyY = $HyphenLetter.StartBaseLine.Y
    $nxY = $NextLetter.StartBaseLine.Y
    $pt = [Math]::Max(
        [Math]::Min([double]$HyphenLetter.PointSize, [double]$NextLetter.PointSize),
        1.0)
    # PDF y-up: a following line sits strictly below the hyphen baseline.
    return ($hyY - $nxY) -gt ($MinDrop * $pt)
}

function Resolve-PdfProseNewLineHyphen {
    [CmdletBinding()]
    param(
        [string] $Line,
        [string] $Next,
        [bool] $NewlineAfter = $true
    )
    if ([string]::IsNullOrEmpty($Line) -or [string]::IsNullOrEmpty($Next)) {
        return [pscustomobject]@{ Join = $false; Reason = 'empty' }
    }
    $hyphen = [System.Text.Rune]::GetRuneAt($Line, $Line.Length - 1)
    $h = $hyphen.Value
    if ($h -eq 0x2011) {
        return [pscustomobject]@{ Join = $false; Reason = 'nonbreaking-hyphen' }
    }
    $nextRune = [System.Text.Rune]::new(0)
    if (-not [System.Text.Rune]::TryGetRuneAt($Next, 0, [ref]$nextRune)) {
        return [pscustomobject]@{ Join = $false; Reason = 'bad-next' }
    }
    $nextCat = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($nextRune.Value)
    if ($nextCat -eq [System.Globalization.UnicodeCategory]::UppercaseLetter -or
        $nextCat -eq [System.Globalization.UnicodeCategory]::TitlecaseLetter) {
        return [pscustomobject]@{ Join = $false; Reason = 'uppercase-next' }
    }
    if ($nextCat -ne [System.Globalization.UnicodeCategory]::LowercaseLetter -and
        $nextCat -ne [System.Globalization.UnicodeCategory]::OtherLetter) {
        return [pscustomobject]@{ Join = $false; Reason = 'nonletter-next' }
    }
    if ($h -eq 0x00AD) {
        if (-not $NewlineAfter) {
            return [pscustomobject]@{ Join = $false; Reason = 'no-newline-after-hyphen' }
        }
        return [pscustomobject]@{ Join = $true; Reason = 'soft-hyphen' }
    }
    if ($h -ne 0x002D -and $h -ne 0x2010) {
        return [pscustomobject]@{ Join = $false; Reason = 'not-hyphen' }
    }
    if (-not $NewlineAfter) {
        return [pscustomobject]@{ Join = $false; Reason = 'no-newline-after-hyphen' }
    }
    $left = Get-PdfProseLetterRun -Text $Line -Start ($Line.Length - $hyphen.Utf16SequenceLength) -Direction -1
    $right = Get-PdfProseLetterRun -Text $Next -Start 0 -Direction 1
    if (-not $left -or -not $right) {
        return [pscustomobject]@{ Join = $false; Reason = 'nonletter-flank' }
    }
    $cfg = Get-PdfProseNewLineHyphenConfig
    if ($cfg.Prefixes.Contains($left)) {
        return [pscustomobject]@{ Join = $true; Reason = 'prefix' }
    }
    $rightWord = Test-PdfProseWordLike $right $cfg.NumberWords
    $numberPair = $cfg.NumberWords.Contains($left) -and $cfg.NumberWords.Contains($right)
    if ($numberPair -or ($cfg.KeepLeft.Contains($left) -and $rightWord)) {
        return [pscustomobject]@{ Join = $false; Reason = 'lexical-compound' }
    }
    [pscustomobject]@{ Join = $true; Reason = 'line-break' }
}

function Get-PdfProseSpecialKind {
    param([int] $Scalar, [int] $ScalarCountInValue)
    if ($ScalarCountInValue -gt 1) { return 'multi-scalar' }
    if ($Scalar -eq 0x00AD) { return 'soft-hyphen' }
    if ($Scalar -ge 0xFB00 -and $Scalar -le 0xFB06) { return 'ligature' }
    return $null
}

function Get-PdfProseSpecials {
    [CmdletBinding()]
    param(
        [AllowEmptyString()] [string] $Text
    )
    $out = [System.Collections.Generic.List[object]]::new()
    if (-not $Text) { return , $out.ToArray() }
    $i = 0
    $len = $Text.Length
    $rune = [System.Text.Rune]::new(0)
    while ($i -lt $len) {
        if (-not [System.Text.Rune]::TryGetRuneAt($Text, $i, [ref]$rune)) {
            $i++
            continue
        }
        $kind = Get-PdfProseSpecialKind -Scalar $rune.Value -ScalarCountInValue 1
        if ($kind) {
            $out.Add([pscustomobject]@{
                Kind   = $kind
                Scalar = $rune.Value
                Start  = $i
                End    = $i + $rune.Utf16SequenceLength
                Value  = $rune.ToString()
            })
        }
        $i += $rune.Utf16SequenceLength
    }
    , $out.ToArray()
}

function Join-PdfProseLines {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()] [object[]] $Lines,
        [bool] $RemoveNewLineHyphens = $true
    )
    if (-not $Lines -or $Lines.Count -eq 0) {
        return [pscustomobject]@{ Text = ''; Edits = @() }
    }
    $sb = [System.Text.StringBuilder]::new()
    $edits = [System.Collections.Generic.List[object]]::new()
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $rawLine = $Lines[$i]
        $rawNext = if ($i + 1 -lt $Lines.Count) { $Lines[$i + 1] } else { $null }
        $line = if ($rawLine -is [string]) { $rawLine } else { $rawLine.Text }
        $next = if ($null -eq $rawNext) { $null } elseif ($rawNext -is [string]) { $rawNext } else { $rawNext.Text }
        $newlineAfter = $true
        if ($null -ne $rawNext -and $rawLine -isnot [string]) {
            $hyLet = $rawLine.Words[-1].Letters[-1]
            $nxLet = $rawNext.Words[0].Letters[0]
            $newlineAfter = Test-PdfProseNewlineAfterHyphen $hyLet $nxLet
        }
        $decision = if ($RemoveNewLineHyphens -and $null -ne $next) {
            Resolve-PdfProseNewLineHyphen -Line $line -Next $next -NewlineAfter $newlineAfter
        } else {
            $null
        }
        if ($decision -and $decision.Join) {
            $hyphen = [System.Text.Rune]::GetRuneAt($line, $line.Length - 1)
            $trim = $line.Substring(0, $line.Length - $hyphen.Utf16SequenceLength)
            $left = Get-PdfProseLetterRun -Text $line -Start ($line.Length - $hyphen.Utf16SequenceLength) -Direction -1
            $right = Get-PdfProseLetterRun -Text $next -Start 0 -Direction 1
            $edits.Add([pscustomobject]@{
                Kind   = 'remove-newline-hyphen'
                Reason = $decision.Reason
                Left   = $left
                Right  = $right
            })
            [void]$sb.Append($trim)
            continue
        }
        [void]$sb.Append($line)
        if ($i -lt $Lines.Count - 1) { [void]$sb.Append("`n") }
    }
    [pscustomobject]@{
        Text  = $sb.ToString()
        Edits = $edits.ToArray()
    }
}

function Test-PdfProseRectsOverlap {
    param($A, $B)
    if ($null -eq $A -or $null -eq $B) { return $false }
    ($A.Right -gt $B.Left) -and ($A.Left -lt $B.Right) -and
    ($A.Top -gt $B.Bottom) -and ($A.Bottom -lt $B.Top)
}

function Test-PdfProseCaptionBesideFloat {
    param($Block, $Float)
    if ($null -eq $Block -or $null -eq $Float) { return $false }
    $justBelow = ($Block.Top -le ($Float.Bottom + 8)) -and ($Block.Top -ge ($Float.Bottom - 48))
    $xOverlap = ($Block.Right -gt $Float.Left) -and ($Block.Left -lt $Float.Right)
    $justBelow -and $xOverlap
}

function Resolve-PdfProseBlockRole {
    param(
        $Block,
        [double] $PageWidth,
        [double] $PageHeight,
        [object[]] $Floats
    )
    $text = if ($Block.Text) { ($Block.Text -replace '\s+', ' ').Trim() } else { '' }
    if ($text -match '^\[\d+\]$') { return 'page-marker' }
    if ($PageHeight -gt 0 -and $Block.Top -gt ($PageHeight * 0.92)) {
        if ($text -match '^\d+$') { return 'folio' }
        if ($text.Length -gt 0 -and $text.Length -lt 80) { return 'running-header' }
    }
    if ($text -match '^(Figure|Fig\.|FIGURE)\s+\d+') { return 'float-caption' }
    foreach ($f in $Floats) {
        if (Test-PdfProseRectsOverlap $Block $f) { return 'float-label' }
    }
    'body'
}

function Test-PdfProseFloatBeforeBlock {
    param($Float, $Block)
    if ($null -eq $Float -or $null -eq $Block) { return $false }
    if ($Block.Role -notin @('body', 'float-caption', 'float-label')) { return $false }
    $Float.Top -ge $Block.Top
}

function Bind-PdfProseFloatCaptions {
    param($Blocks, $Floats)
    if (-not $Floats) { return }
    $caps = @(foreach ($b in $Blocks) { if ($b.Role -eq 'float-caption') { $b } })
    foreach ($f in $Floats) {
        $hit = $null
        foreach ($c in $caps) {
            if (Test-PdfProseCaptionBesideFloat $c $f) { $hit = $c; break }
        }
        if (-not $hit -and $caps.Count -eq 1) { $hit = $caps[0] }
        if ($hit) {
            $f.Caption = $hit.Text
            $hit.FloatIndex = $f.Index
        }
    }
}

function Get-PdfProsePage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Page,
        [ValidateSet('ColumnWise', 'RowWise', 'Basic')]
        [string] $ReadingRule = 'ColumnWise',
        [double] $OrderTolerance = 5,
        [switch] $IncludeInvisible,
        [bool] $RemoveNewLineHyphens = $true,
        [switch] $UseRenderingOrder
    )
    if (-not $PSBoundParameters.ContainsKey('UseRenderingOrder')) { $UseRenderingOrder = $true }

    $kept = [System.Collections.Generic.List[UglyToad.PdfPig.Content.Letter]]::new()
    $audit = Get-PdfProseCodepointAudit ''
    $emptyValue = 0
    $invisibleSkipped = 0
    $invisibleMode = [UglyToad.PdfPig.Core.TextRenderingMode]::Invisible

    foreach ($letter in $Page.Letters) {
        if ([string]::IsNullOrEmpty($letter.Value)) {
            $emptyValue++
            continue
        }
        if (-not $IncludeInvisible -and $letter.RenderingMode -eq $invisibleMode) {
            $invisibleSkipped++
            continue
        }
        $audit = Merge-PdfProseCodepointAudit $audit (Get-PdfProseCodepointAudit $letter.Value)
        $kept.Add($letter)
    }

    $words = [System.Collections.Generic.List[UglyToad.PdfPig.Content.Word]]::new()
    if ($kept.Count -gt 0) {
        foreach ($w in [UglyToad.PdfPig.DocumentLayoutAnalysis.WordExtractor.NearestNeighbourWordExtractor]::Instance.GetWords($kept)) {
            if (-not [string]::IsNullOrWhiteSpace($w.Text)) { $words.Add($w) }
        }
    }

    $blocks = [UglyToad.PdfPig.DocumentLayoutAnalysis.TextBlock[]]@()
    if ($words.Count -gt 0) {
        $raw = [UglyToad.PdfPig.DocumentLayoutAnalysis.PageSegmenter.RecursiveXYCut]::Instance.GetBlocks($words)
        $rule = [UglyToad.PdfPig.DocumentLayoutAnalysis.ReadingOrderDetector.UnsupervisedReadingOrderDetector+SpatialReasoningRules]$ReadingRule
        $detector = [UglyToad.PdfPig.DocumentLayoutAnalysis.ReadingOrderDetector.UnsupervisedReadingOrderDetector]::new(
            $OrderTolerance, $rule, [bool]$UseRenderingOrder)
        $blocks = @($detector.Get($raw))
    }

    $floats = [System.Collections.Generic.List[object]]::new()
    $fi = 0
    foreach ($im in $Page.GetImages()) {
        $ib = $im.Bounds
        $floats.Add([pscustomobject]@{
            Index   = $fi
            Type    = 'image'
            Caption = $null
            Left    = $ib.Left
            Bottom  = $ib.Bottom
            Right   = $ib.Right
            Top     = $ib.Top
        })
        $fi++
    }

    $pageParts = [System.Collections.Generic.List[string]]::new()
    $blockViews = [System.Collections.Generic.List[object]]::new()
    $dehyphenations = [System.Collections.Generic.List[object]]::new()
    foreach ($block in $blocks) {
        $lineTexts = @(foreach ($ln in $block.TextLines) { $ln.Text })
        $joined = Join-PdfProseLines -Lines @($block.TextLines) -RemoveNewLineHyphens:$RemoveNewLineHyphens
        $blockText = $joined.Text
        foreach ($edit in $joined.Edits) { $dehyphenations.Add($edit) }
        $box = $block.BoundingBox
        $view = [pscustomobject]@{
            ReadingOrder = $block.ReadingOrder
            Text         = $blockText
            Left         = $box.Left
            Bottom       = $box.Bottom
            Right        = $box.Right
            Top          = $box.Top
            LineCount    = $lineTexts.Count
            Role         = 'body'
            FloatIndex   = $null
        }
        $view.Role = Resolve-PdfProseBlockRole -Block $view -PageWidth $Page.Width -PageHeight $Page.Height -Floats @($floats)
        $blockViews.Add($view)
        if (-not [string]::IsNullOrWhiteSpace($blockText)) {
            $pageParts.Add($blockText)
        }
    }
    Bind-PdfProseFloatCaptions -Blocks $blockViews -Floats $floats

    $text = [string]::Join("`n`n", $pageParts)
    $specials = @(Get-PdfProseSpecials -Text $text)
    [pscustomobject]@{
        Number   = $Page.Number
        Width    = $Page.Width
        Height   = $Page.Height
        Text         = $text
        TextEscaped  = ConvertTo-PdfProseUtf16Escape $text
        Blocks   = $blockViews.ToArray()
        Floats   = $floats.ToArray()
        Specials        = $specials
        RemovedNewLineHyphens = $dehyphenations.ToArray()
        Diagnostics = [pscustomobject]@{
            LetterKept         = $kept.Count
            EmptyValue         = $emptyValue
            InvisibleSkipped   = $invisibleSkipped
            WordCount          = $words.Count
            BlockCount         = $blocks.Count
            SpecialCount       = $specials.Count
            Length             = $audit.Length
            ScalarCount        = $audit.ScalarCount
            Replacement        = $audit.Replacement
            IsolatedSurrogate  = $audit.IsolatedSurrogate
            Noncharacter       = $audit.Noncharacter
            PrivateUse         = $audit.PrivateUse
        }
    }
}

function Invoke-PdfProseExtract {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Path,
        [int] $First = 1,
        [int] $Last = 0,
        [string] $OutFile,
        [ValidateSet('ColumnWise', 'RowWise', 'Basic')]
        [string] $ReadingRule = 'ColumnWise',
        [double] $OrderTolerance = 5,
        [switch] $IncludeInvisible,
        [bool] $RemoveNewLineHyphens = $true,
        [switch] $UseRenderingOrder
    )
    if (-not $PSBoundParameters.ContainsKey('UseRenderingOrder')) { $UseRenderingOrder = $true }
    Import-PdfPigAssemblies
    $full = [IO.Path]::GetFullPath($Path)
    if (-not [IO.File]::Exists($full)) { throw "Invoke-PdfProseExtract: missing '$full'" }

    $doc = [UglyToad.PdfPig.PdfDocument]::Open($full)
    try {
        $end = if ($Last -gt 0) { [Math]::Min($Last, $doc.NumberOfPages) } else { $doc.NumberOfPages }
        if ($First -lt 1 -or $First -gt $doc.NumberOfPages) {
            throw "Invoke-PdfProseExtract: -First $First is outside 1..$($doc.NumberOfPages)"
        }
        $pages = [System.Collections.Generic.List[object]]::new()
        $parts = [System.Collections.Generic.List[string]]::new()
        $totals = Get-PdfProseCodepointAudit ''
        $totals | Add-Member -NotePropertyName LetterKept -NotePropertyValue 0
        $totals | Add-Member -NotePropertyName EmptyValue -NotePropertyValue 0
        $totals | Add-Member -NotePropertyName InvisibleSkipped -NotePropertyValue 0
        $totals | Add-Member -NotePropertyName WordCount -NotePropertyValue 0
        $totals | Add-Member -NotePropertyName BlockCount -NotePropertyValue 0
        for ($n = $First; $n -le $end; $n++) {
            $page = Get-PdfProsePage -Page $doc.GetPage($n) -ReadingRule $ReadingRule `
                -OrderTolerance $OrderTolerance -IncludeInvisible:$IncludeInvisible `
                -RemoveNewLineHyphens:$RemoveNewLineHyphens -UseRenderingOrder:$UseRenderingOrder
            $pages.Add($page)
            if ($page.Text) { $parts.Add($page.Text) }
            $d = $page.Diagnostics
            $totals.LetterKept        += $d.LetterKept
            $totals.EmptyValue        += $d.EmptyValue
            $totals.InvisibleSkipped  += $d.InvisibleSkipped
            $totals.WordCount         += $d.WordCount
            $totals.BlockCount        += $d.BlockCount
            $totals.Length            += $d.Length
            $totals.ScalarCount       += $d.ScalarCount
            $totals.Replacement       += $d.Replacement
            $totals.IsolatedSurrogate += $d.IsolatedSurrogate
            $totals.Noncharacter      += $d.Noncharacter
            $totals.PrivateUse        += $d.PrivateUse
        }
        $text = [string]::Join("`n`n", $parts)
        $escaped = ConvertTo-PdfProseUtf16Escape $text
        if ($OutFile) {
            $outFull = [IO.Path]::GetFullPath($OutFile)
            $dir = [IO.Path]::GetDirectoryName($outFull)
            if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
            $ascii = [Text.UTF8Encoding]::new($false)
            [IO.File]::WriteAllText($outFull, $escaped, $ascii)
        }
        [pscustomobject]@{
            Path          = $full
            PageCount     = $doc.NumberOfPages
            First         = $First
            Last          = $end
            Text          = $text
            TextEscaped   = $escaped
            Pages         = $pages.ToArray()
            Diagnostics   = $totals
            OutFile       = $(if ($OutFile) { [IO.Path]::GetFullPath($OutFile) } else { $null })
        }
    }
    finally {
        $doc.Dispose()
    }
}

$script:PdfProseNonAscii = $null

function Get-PdfProseNonAsciiPolicy {
    if ($null -ne $script:PdfProseNonAscii) { return $script:PdfProseNonAscii }
    $path = Join-Path $PSScriptRoot 'non-ascii.json'
    $raw = Get-Content -LiteralPath $path -Raw -Encoding utf8
    $cfg = $raw | ConvertFrom-Json
    $expand = @{}
    if ($cfg.expand) {
        foreach ($p in $cfg.expand.PSObject.Properties) {
            $expand[[int]("0x$($p.Name)")] = [string]$p.Value
        }
    }
    $script:PdfProseNonAscii = [pscustomobject]@{
        Ligature   = [string]$cfg.ligature
        SoftHyphen = [string]$cfg.'soft-hyphen'
        Letter     = [string]$cfg.letter
        Default    = [string]$cfg.default
        Expand     = $expand
    }
    $script:PdfProseNonAscii
}

function Get-PdfProseNonAsciiClass {
    param([int] $Scalar)
    if ($Scalar -eq 0x00AD) { return 'soft-hyphen' }
    if ($Scalar -ge 0xFB00 -and $Scalar -le 0xFB06) { return 'ligature' }
    $cat = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($Scalar)
    if ($cat -in @(
            [System.Globalization.UnicodeCategory]::LowercaseLetter,
            [System.Globalization.UnicodeCategory]::UppercaseLetter,
            [System.Globalization.UnicodeCategory]::TitlecaseLetter,
            [System.Globalization.UnicodeCategory]::ModifierLetter,
            [System.Globalization.UnicodeCategory]::OtherLetter)) {
        return 'letter'
    }
    return 'default'
}

function ConvertTo-PdfProseRender {
    [CmdletBinding()]
    param(
        [AllowEmptyString()] [AllowNull()] [string] $Text
    )
    if ([string]::IsNullOrEmpty($Text)) {
        return [pscustomobject]@{ Text = ''; Specials = @() }
    }
    $policy = Get-PdfProseNonAsciiPolicy
    $sb = [System.Text.StringBuilder]::new($Text.Length)
    $specials = [System.Collections.Generic.List[object]]::new()
    $i = 0
    $len = $Text.Length
    $rune = [System.Text.Rune]::new(0)
    while ($i -lt $len) {
        if (-not [System.Text.Rune]::TryGetRuneAt($Text, $i, [ref]$rune)) {
            $unit = [int]$Text[$i]
            $piece = '\u{0:X4}' -f $unit
            [void]$sb.Append($piece)
            $specials.Add([pscustomobject]@{
                PSTypeName = 'PdfProse.Special'
                Kind      = 'isolated-surrogate'
                Scalar    = $unit
                Start     = $i
                End       = $i + 1
                Decision  = 'escape'
                Render    = $piece
            })
            $i++
            continue
        }
        $cp = $rune.Value
        $class = Get-PdfProseNonAsciiClass $cp
        $decision = switch ($class) {
            'ligature' { $policy.Ligature }
            'soft-hyphen' { $policy.SoftHyphen }
            'letter' { $policy.Letter }
            default { $policy.Default }
        }
        if ($cp -le 0x7E -and $cp -ne 0x5C) {
            [void]$sb.Append($rune.ToString())
            $i += $rune.Utf16SequenceLength
            continue
        }
        $render = switch ($decision) {
            'expand' {
                if ($policy.Expand.ContainsKey($cp)) { $policy.Expand[$cp] }
                else { ConvertTo-PdfProseUtf16Escape $rune.ToString() }
            }
            'elide' { '' }
            'keep' { $rune.ToString() }
            default { ConvertTo-PdfProseUtf16Escape $rune.ToString() }
        }
        [void]$sb.Append($render)
        if ($cp -gt 0x7E -or $cp -eq 0x5C) {
            $specials.Add([pscustomobject]@{
                PSTypeName = 'PdfProse.Special'
                Kind     = $class
                Scalar   = $cp
                Start    = $i
                End      = $i + $rune.Utf16SequenceLength
                Decision = $decision
                Render   = $render
            })
        }
        $i += $rune.Utf16SequenceLength
    }
    [pscustomobject]@{
        Text     = $sb.ToString()
        Specials = $specials.ToArray()
    }
}

function Get-PdfProseSections {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Document,
        [int] $First = 1,
        [int] $Last = 0
    )
    if ($Last -lt 1) { $Last = $Document.NumberOfPages }
    $bookmarks = $null
    $has = $Document.TryGetBookmarks([ref]$bookmarks, $true)
    $nodes = [System.Collections.Generic.List[object]]::new()
    if ($has -and $null -ne $bookmarks) {
        $docNodeType = [UglyToad.PdfPig.Outline.DocumentBookmarkNode]
        foreach ($n in $bookmarks.GetNodes()) {
            if ($n -is $docNodeType -and $n.PageNumber -ge 1) { $nodes.Add($n) }
        }
    }
    $sections = [System.Collections.Generic.List[object]]::new()
    if ($nodes.Count -eq 0) {
        $sections.Add([pscustomobject]@{
            Id          = 's-0000'
            Level       = 0
            Title       = ''
            TitleEscaped = ''
            PageStart   = $First
            PageEnd     = $Last
            Source      = 'implicit'
        })
        return $sections
    }
    for ($i = 0; $i -lt $nodes.Count; $i++) {
        $n = $nodes[$i]
        $start = $n.PageNumber
        $end = $Last
        for ($j = $i + 1; $j -lt $nodes.Count; $j++) {
            if ($nodes[$j].PageNumber -gt $start) {
                $end = $nodes[$j].PageNumber - 1
                break
            }
        }
        $sections.Add([pscustomobject]@{
            Id           = 's-{0:D4}' -f $i
            Level        = $n.Level
            Title        = $n.Title
            TitleEscaped = ConvertTo-PdfProseUtf16Escape $n.Title
            PageStart    = $start
            PageEnd      = $end
            Source       = 'outline'
        })
    }
    if ($sections[0].PageStart -gt $First) {
        $lead = [pscustomobject]@{
            Id           = 's-front'
            Level        = 0
            Title        = ''
            TitleEscaped = ''
            PageStart    = $First
            PageEnd      = $sections[0].PageStart - 1
            Source       = 'implicit'
        }
        $sections.Insert(0, $lead)
    }
    return $sections
}

function Select-PdfProseSectionForPage {
    param([object[]] $Sections, [int] $Page)
    $hit = $null
    foreach ($s in $Sections) {
        if ($Page -ge $s.PageStart -and $Page -le $s.PageEnd) {
            if ($null -eq $hit -or $s.Level -ge $hit.Level) { $hit = $s }
        }
    }
    $hit
}

function New-PdfProseIrDocument {
    param(
        [string] $Source,
        [int] $PageCount,
        [int] $First,
        [int] $Last,
        [int] $SectionCount,
        [string[]] $SectionSource
    )
    [pscustomobject]@{
        PSTypeName    = 'PdfProse.Document'
        kind          = 'document'
        source        = $Source
        pageCount     = $PageCount
        first         = $First
        last          = $Last
        sectionCount  = $SectionCount
        sectionSource = @($SectionSource)
    }
}

function New-PdfProseIrSection {
    param(
        [string] $Id,
        [int] $Level,
        [string] $TitleEscaped,
        [int] $PageStart,
        [int] $PageEnd,
        [string] $Source
    )
    [pscustomobject]@{
        PSTypeName   = 'PdfProse.Section'
        kind         = 'section'
        id           = $Id
        level        = $Level
        titleEscaped = $TitleEscaped
        pageStart    = $PageStart
        pageEnd      = $PageEnd
        source       = $Source
    }
}

function New-PdfProseIrFloat {
    param(
        [int] $Seq,
        [string] $Section,
        [int] $Page,
        [int] $Index,
        [string] $Type = 'image',
        [string] $CaptionEscaped = '',
        [string] $CaptionRender = '',
        [double] $Left,
        [double] $Bottom,
        [double] $Right,
        [double] $Top
    )
    [pscustomobject]@{
        PSTypeName     = 'PdfProse.Float'
        kind           = 'float'
        seq            = $Seq
        section        = $Section
        page           = $Page
        index          = $Index
        type           = $Type
        captionEscaped = $CaptionEscaped
        captionRender  = $CaptionRender
        left           = $Left
        bottom         = $Bottom
        right          = $Right
        top            = $Top
    }
}

function New-PdfProseIrFloatFromView {
    param(
        [int] $Seq,
        [string] $Section,
        [int] $Page,
        $Float
    )
    $cap = if ($Float.Caption) { ConvertTo-PdfProseRender -Text $Float.Caption } else { $null }
    New-PdfProseIrFloat -Seq $Seq -Section $Section -Page $Page -Index $Float.Index `
        -Type $(if ($Float.Type) { [string]$Float.Type } else { 'image' }) `
        -CaptionEscaped (ConvertTo-PdfProseUtf16Escape $(if ($null -eq $Float.Caption) { '' } else { [string]$Float.Caption })) `
        -CaptionRender $(if ($cap) { $cap.Text } else { '' }) `
        -Left $Float.Left -Bottom $Float.Bottom -Right $Float.Right -Top $Float.Top
}

function New-PdfProseIrBlock {
    param(
        [int] $Seq,
        [string] $Section,
        [int] $Page,
        [int] $Order,
        [string] $TextEscaped,
        [string] $TextRender,
        [object[]] $Specials,
        [string] $Role = 'body',
        $FloatIndex = $null,
        [double] $Left,
        [double] $Bottom,
        [double] $Right,
        [double] $Top
    )
    [pscustomobject]@{
        PSTypeName  = 'PdfProse.Block'
        kind        = 'block'
        seq         = $Seq
        section     = $Section
        page        = $Page
        order       = $Order
        role        = $Role
        floatIndex  = $FloatIndex
        textEscaped = $TextEscaped
        textRender  = $TextRender
        specials    = @($Specials)
        left        = $Left
        bottom      = $Bottom
        right       = $Right
        top         = $Top
    }
}

function ConvertTo-PdfProseJsonlLine {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [pscustomobject] $Record
    )
    $Record | ConvertTo-Json -Compress -Depth 8 -EnumsAsStrings
}

function New-PdfProseIr {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] $Document,
        [string] $Source = '',
        [int] $First = 1,
        [int] $Last = 0,
        [ValidateSet('ColumnWise', 'RowWise', 'Basic')]
        [string] $ReadingRule = 'ColumnWise',
        [double] $OrderTolerance = 5,
        [switch] $IncludeInvisible,
        [bool] $RemoveNewLineHyphens = $true,
        [switch] $UseRenderingOrder
    )
    if (-not $PSBoundParameters.ContainsKey('UseRenderingOrder')) { $UseRenderingOrder = $true }
    $end = if ($Last -gt 0) { [Math]::Min([int]$Last, [int]$Document.NumberOfPages) } else { [int]$Document.NumberOfPages }
    $from = [int]$First
    $sections = @(Get-PdfProseSections -Document $Document -First $from -Last $end |
        Where-Object { [int]$_.PageEnd -ge $from -and [int]$_.PageStart -le $end })
    $records = [System.Collections.Generic.List[pscustomobject]]::new()
    $sources = [System.Collections.Generic.List[string]]::new()
    foreach ($s in $sections) {
        if ($s.Source -and -not $sources.Contains([string]$s.Source)) { $sources.Add([string]$s.Source) }
    }
    $records.Add((New-PdfProseIrDocument -Source $Source `
        -PageCount $Document.NumberOfPages -First $from -Last $end `
        -SectionCount @($sections).Count -SectionSource @($sources)))
    $pageCache = @{}
    $seq = 0
    foreach ($sec in $sections) {
        $records.Add((New-PdfProseIrSection -Id $sec.Id -Level $sec.Level `
            -TitleEscaped $sec.TitleEscaped -PageStart $sec.PageStart `
            -PageEnd $sec.PageEnd -Source $sec.Source))
        $lo = [Math]::Max([int]$sec.PageStart, $from)
        $hi = [Math]::Min([int]$sec.PageEnd, $end)
        if ($lo -gt $hi) { continue }
        for ($n = $lo; $n -le $hi; $n++) {
            $owner = Select-PdfProseSectionForPage -Sections $sections -Page $n
            if ($null -eq $owner -or $owner.Id -ne $sec.Id) { continue }
            if (-not $pageCache.ContainsKey($n)) {
                $pageCache[$n] = Get-PdfProsePage -Page $Document.GetPage($n) -ReadingRule $ReadingRule `
                    -OrderTolerance $OrderTolerance -IncludeInvisible:$IncludeInvisible `
                    -RemoveNewLineHyphens:$RemoveNewLineHyphens -UseRenderingOrder:$UseRenderingOrder
            }
            $page = $pageCache[$n]
            $pending = [System.Collections.Generic.List[object]]::new()
            foreach ($f in $page.Floats) { $pending.Add($f) }
            $order = 0
            foreach ($block in $page.Blocks) {
                $still = [System.Collections.Generic.List[object]]::new()
                foreach ($f in $pending) {
                    if (Test-PdfProseFloatBeforeBlock $f $block) {
                        $records.Add((New-PdfProseIrFloatFromView -Seq $seq -Section $sec.Id -Page $n -Float $f))
                        $seq++
                    }
                    else { $still.Add($f) }
                }
                $pending = $still
                $render = ConvertTo-PdfProseRender -Text $block.Text
                $records.Add((New-PdfProseIrBlock -Seq $seq -Section $sec.Id -Page $n -Order $order `
                    -TextEscaped (ConvertTo-PdfProseUtf16Escape $block.Text) `
                    -TextRender $render.Text -Specials @($render.Specials) `
                    -Role $block.Role -FloatIndex $block.FloatIndex `
                    -Left $block.Left -Bottom $block.Bottom -Right $block.Right -Top $block.Top))
                $seq++
                $order++
            }
            foreach ($f in $pending) {
                $records.Add((New-PdfProseIrFloatFromView -Seq $seq -Section $sec.Id -Page $n -Float $f))
                $seq++
            }
        }
    }
    [pscustomobject]@{
        PSTypeName = 'PdfProse.Ir'
        Sections   = @($sections)
        Records    = $records
    }
}

function Export-PdfProseJsonl {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $JsonlPath,
        [int] $First = 1,
        [int] $Last = 0,
        [ValidateSet('ColumnWise', 'RowWise', 'Basic')]
        [string] $ReadingRule = 'ColumnWise',
        [double] $OrderTolerance = 5,
        [switch] $IncludeInvisible,
        [bool] $RemoveNewLineHyphens = $true,
        [switch] $UseRenderingOrder
    )
    if (-not $PSBoundParameters.ContainsKey('UseRenderingOrder')) { $UseRenderingOrder = $true }
    Import-PdfPigAssemblies
    $full = [IO.Path]::GetFullPath($Path)
    if (-not [IO.File]::Exists($full)) { throw "Export-PdfProseJsonl: missing '$full'" }
    $outFull = [IO.Path]::GetFullPath($JsonlPath)
    $outDir = [IO.Path]::GetDirectoryName($outFull)
    if ($outDir) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

    $doc = [UglyToad.PdfPig.PdfDocument]::Open($full)
    $utf8 = [Text.UTF8Encoding]::new($false)
    $writer = [IO.StreamWriter]::new($outFull, $false, $utf8)
    try {
        $ir = New-PdfProseIr -Document $doc -Source $full -First $First -Last $Last `
            -ReadingRule $ReadingRule -OrderTolerance $OrderTolerance `
            -IncludeInvisible:$IncludeInvisible -RemoveNewLineHyphens:$RemoveNewLineHyphens `
            -UseRenderingOrder:$UseRenderingOrder
        foreach ($record in $ir.Records) {
            $writer.WriteLine((ConvertTo-PdfProseJsonlLine -Record $record))
        }
        [pscustomobject]@{
            Path      = $full
            JsonlPath = $outFull
            Ir        = $ir
            Sections  = $ir.Sections
            Records   = $ir.Records.Count
        }
    }
    finally {
        $writer.Dispose()
        $doc.Dispose()
    }
}
