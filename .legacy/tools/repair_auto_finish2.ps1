param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_auto_finish2.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.bak3.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$txt = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
$txt = [regex]::Replace($txt,'\\+intertext','\\intertext')
$txt = [regex]::Replace($txt,'\\+substack','\\substack')
$txt = [regex]::Replace($txt,'\\{3,}','\\\\') # replace 3+ backslashes with two
Set-Content -LiteralPath $Path -Value $txt -Encoding UTF8
Write-Output "auto-pass3-applied; backup: $backup"
