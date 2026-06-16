#requires -Version 7.0
. "$PSScriptRoot\..\..\..\src\md-cleanup.ps1"
$bars = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$files = @(
    'BD2005.md', 'BM2021.md', 'GRE1995.md', 'HTR2005.md', 'HYK2024.md', 'TN2020.md', 'WLK2008.md',
    'references\MRA2015.appendices.md'
)
$results = foreach ($f in $files) {
    $p = Join-Path $bars $f
    Invoke-MarkdownCleanup -Path $p -Apply
}
$results | Format-Table file, written, ligatures, inline_wrapped, math_tightened -AutoSize
