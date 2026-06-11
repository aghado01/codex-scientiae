param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_auto_finish3.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.bak4.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$txt = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
# Replace common Unicode glyphs with LaTeX commands (simple/global replacements)
$txt = $txt -replace '˜','\\tilde{}'
$txt = $txt -replace 'ˆ','\\hat{}'
# Remove unnecessary escaped underscores
$txt = $txt -replace '\\_','_'
Set-Content -LiteralPath $Path -Value $txt -Encoding UTF8
Write-Output "auto-pass4-applied; backup: $backup"
