param(
    [string]$Path = 'c:\Users\azrie\PDenv\UserGithub\codex-scientiae\corpora\V.Voroninski\1506.01437v2.md'
)
if (-not (Test-Path $Path)) { Write-Error "File not found: $Path"; exit 2 }
$orig = Get-Content -Raw -Encoding UTF8 -Path $Path
$bak = "$Path.bak4"
Set-Content -Path $bak -Value $orig -Encoding UTF8

# Replace escaped underscores with proper subscripts
$orig = $orig -replace '\\_','_'

# Fix double-escaped intertext
$orig = $orig -replace '\\\\intertext','\\intertext'

# Remove leftover sequences like '\hat{}' with empty braces left (keep as-is)
# Normalize sequences like '\\_' if any
$orig = $orig -replace '\\\\_','_'

Set-Content -Path $Path -Value $orig -Encoding UTF8
Write-Output "more-fixes-applied"
