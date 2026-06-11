param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_auto_finish5.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.bak6.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$txt = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
# Reduce repeated backslashes before macro names to a single backslash
$txt = [regex]::Replace($txt,'\\+([A-Za-z]+)\{','\\$1{')
# Remove empty macro braces like \hat{} followed immediately by a name (handled earlier), collapse to \hat
$txt = [regex]::Replace($txt,'\\(hat|tilde)\{\}','\\$1')
Set-Content -LiteralPath $Path -Value $txt -Encoding UTF8
Write-Output "auto-pass6-applied; backup: $backup"
