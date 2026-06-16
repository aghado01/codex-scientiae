#requires -Version 7.0
. "$PSScriptRoot\..\..\..\src\md-cleanup.ps1"
$bars = Join-Path $PSScriptRoot '..'

Write-Host '=== Invoke-MarkdownCleanup (dry-run) ==='
$results = @(Invoke-MarkdownCleanup -Path $bars)
$results | Sort-Object file | Format-Table file, changed, ligatures, inline_wrapped, math_tightened, written -AutoSize

$changed = @($results | Where-Object { $_.changed })
Write-Host ''
Write-Host "files: $($results.Count)  would_change: $($changed.Count)"
Write-Host "ligatures (lines): $(($results | Measure-Object -Property ligatures -Sum).Sum)"
Write-Host "inline_wrapped (lines): $(($results | Measure-Object -Property inline_wrapped -Sum).Sum)"
Write-Host "math_tightened (spans): $(($results | Measure-Object -Property math_tightened -Sum).Sum)"

if ($changed.Count -gt 0) {
    Write-Host ''
    Write-Host '=== Files that would change ==='
    $changed | Sort-Object file | Format-Table file, ligatures, inline_wrapped, math_tightened -AutoSize
}

Write-Host ''
Write-Host '=== Find-MathClosureIssues ==='
$issues = @(Find-MathClosureIssues -Path $bars)
Write-Host "issues: $($issues.Count)"
if ($issues.Count -gt 0) {
    $issues | Sort-Object file, line | Format-Table file, line, kind, issue, span -AutoSize -Wrap
}
