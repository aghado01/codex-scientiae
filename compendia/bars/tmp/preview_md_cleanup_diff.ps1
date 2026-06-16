#requires -Version 7.0
# Preview md-cleanup transforms and write unified diffs (no corpus writes).
. "$PSScriptRoot\..\..\..\src\md-cleanup.ps1"

function Get-CleanupPreviewText([string]$Path) {
    $raw  = [System.IO.File]::ReadAllText($Path)
    $orig = $raw -replace "`r`n", "`n"
    $nonce  = [System.Guid]::NewGuid().ToString('N')
    $marker = "RMASK_${nonce}_"
    while ($orig.Contains($marker)) { $nonce = [System.Guid]::NewGuid().ToString('N'); $marker = "RMASK_${nonce}_" }
    $script:mdStore = [System.Collections.Generic.List[string]]::new()
    $script:mdTight = 0
    $protect = { param($m) $script:mdStore.Add($m.Value); "$marker$($script:mdStore.Count - 1)$marker" }
    $work = $orig
    $work = [regex]::Replace($work, '(?ms)^```.*?^```', $protect)
    $work = [regex]::Replace($work, '(?s)\$\$.+?\$\$', $protect)
    $work = [regex]::Replace($work, '`[^`\n]+`', $protect)
    $work = [regex]::Replace($work, '!?\[[^\]]*\]\([^)]*\)', $protect)
    $work = [regex]::Replace($work, '\$[^$\n]+\$', {
        param($m)
        $inner = $m.Value.Substring(1, $m.Value.Length - 2)
        $clean = '$' + (Convert-MathToLatex (Optimize-MathContent $inner @('mathbb'))) + '$'
        if ($clean -ne $m.Value) { $script:mdTight++ }
        $script:mdStore.Add($clean); "$marker$($script:mdStore.Count - 1)$marker"
    })
    $lines = $work -split "`n", -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $l = Repair-Ligatures $lines[$i]
        if (([regex]::Matches($l, '\|')).Count -lt 2) { $l = Wrap-InlineMathMd $l }
        $lines[$i] = $l
    }
    $work = $lines -join "`n"
    $guard = 0
    $restoreRx = [regex]::Escape($marker) + '(\d+)' + [regex]::Escape($marker)
    while ($guard -lt 12 -and $work.IndexOf($marker) -ge 0) {
        $work = [regex]::Replace($work, $restoreRx, { param($m) $script:mdStore[[int]$m.Groups[1].Value] })
        $guard++
    }
    return @{ orig = $orig; cleaned = $work; tightened = $script:mdTight }
}

function Get-LineDiffHunks($origLines, $cleanLines, [int]$context = 2) {
    $hunks = [System.Collections.Generic.List[string]]::new()
    $max = [Math]::Max($origLines.Count, $cleanLines.Count)
    for ($i = 0; $i -lt $max; $i++) {
        $o = if ($i -lt $origLines.Count) { $origLines[$i] } else { $null }
        $c = if ($i -lt $cleanLines.Count) { $cleanLines[$i] } else { $null }
        if ($o -ceq $c) { continue }
        $ln = $i + 1
        $hunks.Add("--- line $ln ---")
        $start = [Math]::Max(0, $i - $context)
        $end = [Math]::Min($max - 1, $i + $context)
        for ($j = $start; $j -le $end; $j++) {
            $tag = if ($j -eq $i) { '*' } else { ' ' }
            $ol = if ($j -lt $origLines.Count) { $origLines[$j] } else { '' }
            $cl = if ($j -lt $cleanLines.Count) { $cleanLines[$j] } else { '' }
            if ($ol -ceq $cl) {
                $hunks.Add(("{0,5} | {1}" -f ($j + 1), $ol))
            } else {
                if ($ol) { $hunks.Add(("{0,5} -| {1}" -f ($j + 1), $ol)) }
                if ($cl) { $hunks.Add(("{0,5} +| {1}" -f ($j + 1), $cl)) }
            }
        }
        $hunks.Add('')
    }
    return $hunks
}

$bars = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$outDir = Join-Path $PSScriptRoot 'cleanup-diffs'
if (Test-Path $outDir) { Remove-Item -LiteralPath $outDir -Recurse -Force }
New-Item -ItemType Directory -Path $outDir | Out-Null

$mainPapers = @(
    'BD2005.md', 'BM2021.md', 'GRE1995.md', 'HTR2005.md', 'HYK2024.md',
    'TN2020.md', 'WLK2008.md', 'MRA2015.appendices.md'
)

$summary = [System.Collections.Generic.List[object]]::new()
foreach ($name in $mainPapers) {
    $path = if ($name -eq 'MRA2015.appendices.md') {
        Join-Path $bars 'references\MRA2015.appendices.md'
    } else { Join-Path $bars $name }
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $meta = Invoke-MarkdownCleanup -Path $path
    if (-not $meta.changed) { continue }
    $prev = Get-CleanupPreviewText $path
    $origLines = @($prev.orig -split "`n", -1)
    $cleanLines = @($prev.cleaned -split "`n", -1)
    $changedLines = 0
    $max = [Math]::Max($origLines.Count, $cleanLines.Count)
    for ($i = 0; $i -lt $max; $i++) {
        $o = if ($i -lt $origLines.Count) { $origLines[$i] } else { $null }
        $c = if ($i -lt $cleanLines.Count) { $cleanLines[$i] } else { $null }
        if ($o -cne $c) { $changedLines++ }
    }
    $hunks = Get-LineDiffHunks $origLines $cleanLines
    $diffPath = Join-Path $outDir ($name -replace '\.md$', '.diff.txt')
    [System.IO.File]::WriteAllText($diffPath, ($hunks -join "`n"), [System.Text.UTF8Encoding]::new($false))
    $summary.Add([pscustomobject]@{
        file = $name
        changed_lines = $changedLines
        math_tightened = $meta.math_tightened
        inline_wrapped = $meta.inline_wrapped
        diff_file = $diffPath
        diff_bytes = (Get-Item $diffPath).Length
    })
}

Write-Host '=== md-cleanup dry-run diff summary ==='
$summary | Format-Table file, changed_lines, math_tightened, inline_wrapped, diff_bytes -AutoSize
Write-Host "diffs written under: $outDir"
