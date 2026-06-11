param(
    [string]$Path
)
if (-not $Path) { Write-Error "Usage: repair_auto_finish.ps1 -Path <file>"; exit 2 }
$Path = (Resolve-Path $Path).Path
$backup = "$Path.bak.$((Get-Date).ToString('yyyyMMddHHmmss'))"
Copy-Item -LiteralPath $Path -Destination $backup -Force
$txt = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
# Safe replacements
$txt = $txt -replace '\\\\ \{','\\{'    # collapse literal "\\ {" -> "\\{"
$txt = $txt -replace '\\\\intertext','\\intertext' # reduce double-backslash intertext
$txt = $txt -replace '\\\\substack','\\substack'   # reduce double-backslash substack
$txt = $txt -replace '\{\$_','_{'                      # {$_ -> _{
# collapse repeated double-backslash+space sequences into single \\
$txt = $txt -replace '\\\\[ \t]+','\\'
# normalize sequences like "\\ \\intertext" -> "\\intertext"
$txt = $txt -replace '\\\\ \\\\intertext','\\intertext'
$txt = $txt -replace '\\\\ \\\\substack','\\substack'
# remove stray 'ethat'/'similaryaply' tokens only when adjacent to \intertext or obvious math sentence fragments
$txt = $txt -replace '\\intertext\{\s*ethat\s*\}','\\intertext{}'
$txt = $txt -replace '\\intertext\{\s*similaryaply\s*\}','\\intertext{}'
# Write back
Set-Content -LiteralPath $Path -Value $txt -Encoding UTF8
Write-Output "auto-fixes-applied; backup: $backup"
