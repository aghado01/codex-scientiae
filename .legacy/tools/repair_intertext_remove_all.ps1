param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_intertext_remove_all.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.intertext.removeall.bak.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$txt = Get-Content -LiteralPath $Path -Encoding UTF8 -Raw
# remove any \intertext{...} or \\intertext{...} or intertext{...} occurrences
$txt = [regex]::Replace($txt, '\s*\\*intertext\{.*?\}\s*', " `n ")
# collapse repeated blank lines
$txt = [regex]::Replace($txt, '(`n\s*){3,}', "`n`n")
Set-Content -LiteralPath $Path -Value $txt -Encoding UTF8
Write-Output "intertext-removeall-applied; backup: $backup"
