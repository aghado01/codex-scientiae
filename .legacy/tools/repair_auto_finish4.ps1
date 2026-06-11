param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_auto_finish4.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.bak5.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$txt = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
# Replace t*{ij} -> t_{ij}
$txt = [regex]::Replace($txt,'t\*\{([^}]+)\}','t_{$1}')
# Replace \hat{} t_{ij} -> \hat{t}_{ij}
$txt = [regex]::Replace($txt,'\\hat\{\}\s*t_\{([^}]+)\}','\\hat{t}_{$1}')
# Replace \tilde{} δ ij -> \tilde{\delta}_{ij}
$txt = [regex]::Replace($txt,'\\tilde\{\}\s*δ\s*([0-9a-zA-Z_]+)','\\tilde{\\delta}_{$1}')
# Collapse sequences like "\ \intertext{}" -> "\\intertext{}" (ensure single backslash before intertext)
$txt = [regex]::Replace($txt,'\\\\intertext','\\intertext')
Set-Content -LiteralPath $Path -Value $txt -Encoding UTF8
Write-Output "auto-pass5-applied; backup: $backup"
