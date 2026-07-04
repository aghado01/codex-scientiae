#requires -Version 7.0
Set-Location "$PSScriptRoot/.."

$phRoot = 'compendia/ph'
$contentsPath = Join-Path $phRoot '_CONTENTS.md'

$onDisk = Get-ChildItem -LiteralPath $phRoot -Filter '*.md' |
    Where-Object { $_.Name -ne '_CONTENTS.md' } |
    ForEach-Object { $_.BaseName } |
    Sort-Object

$contentsRaw = [System.IO.File]::ReadAllText($contentsPath, [System.Text.UTF8Encoding]::new($false))
$linked = [regex]::Matches($contentsRaw, '\]\(([^)]+\.md)\)') |
    ForEach-Object {
        ($_.Groups[1].Value -replace '.*/', '') -replace '\.md$', ''
    } |
    Sort-Object -Unique

Write-Host "`n=== AUDIT: compendia/ph/_CONTENTS.md ===" -ForegroundColor Cyan
Write-Host "Papers on disk: $($onDisk.Count)"
Write-Host "Slugs linked in _CONTENTS: $($linked.Count)"

$missingFromContents = $onDisk | Where-Object { $_ -notin $linked }
$staleInContents = $linked | Where-Object { $_ -notin $onDisk }

if ($missingFromContents) {
    Write-Host "`nMISSING from _CONTENTS ($($missingFromContents.Count)):" -ForegroundColor Yellow
    $missingFromContents | ForEach-Object { Write-Host "  + $_" }
}
if ($staleInContents) {
    Write-Host "`nSTALE in _CONTENTS (file gone, $($staleInContents.Count)):" -ForegroundColor Red
    $staleInContents | ForEach-Object { Write-Host "  - $_" }
}

# duplicate H1 titles
Write-Host "`nDUPLICATE TITLES:" -ForegroundColor Yellow
$titleMap = @{}
foreach ($slug in $onDisk) {
    $path = Join-Path $phRoot "$slug.md"
    $lines = [System.IO.File]::ReadAllLines($path, [System.Text.UTF8Encoding]::new($false))
    $title = ($lines | Where-Object { $_ -match '^#\s+' } | Select-Object -First 1) -replace '^#\s+', ''
    if (-not $title) { $title = $slug }
    if (-not $titleMap.ContainsKey($title)) { $titleMap[$title] = @() }
    $titleMap[$title] += $slug
}
foreach ($kv in $titleMap.GetEnumerator() | Where-Object { $_.Value.Count -gt 1 }) {
    Write-Host "  '$($kv.Key)' -> $($kv.Value -join ', ')"
}

# empty TOC sections in _CONTENTS
Write-Host "`nEMPTY TOC BLOCKS in _CONTENTS:" -ForegroundColor Yellow
$blocks = ($contentsRaw -split '(?=^## \[)', 'Multiline') | Where-Object { $_ -match '^## \[' }
foreach ($block in $blocks) {
    if ($block -match '^## \[([^\]]+)\]\(([^)]+)\)') {
        $slug = ($Matches[2] -replace '.*/', '') -replace '\.md$', ''
        $body = ($block -split "`n" | Select-Object -Skip 1) -join "`n"
        $hasBullets = $body -match '(?m)^\s*-\s+\['
        if (-not $hasBullets) {
            Write-Host "  $slug"
        }
    }
}
