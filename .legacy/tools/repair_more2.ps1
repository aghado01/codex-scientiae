param(
    [string]$Path = 'd:\aghado01\codex-scientiae\corpora\V.Voroninski\1506.01437v2.md'
)
if (-not (Test-Path $Path)) { Write-Error "File not found: $Path"; exit 2 }
$orig = Get-Content -Raw -Encoding UTF8 -Path $Path
$bak = "$Path.bak5"
Set-Content -Path $bak -Value $orig -Encoding UTF8

# Collapse multiple backslashes before 'intertext' to a single backslash
$orig = [regex]::Replace($orig, '(?:\\\\)+intertext', '\\intertext')
$orig = [regex]::Replace($orig, '(?:\\)+intertext', '\\intertext')

# Fix 'ubstack' -> '\substack'
$orig = $orig -replace 'ubstack','\\substack'

# Fix common broken 'sum' patterns: '\sum*{t\inT}' -> '\sum_{t\in T}' (conservative)
$orig = $orig -replace '\\sum\*\{','\\sum_{'

# Normalize multiple backslashes sequences to double backslash where appropriate inside math blocks is risky; skip.

Set-Content -Path $Path -Value $orig -Encoding UTF8
Write-Output "more2-applied"
