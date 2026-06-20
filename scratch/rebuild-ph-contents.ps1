#requires -Version 7.0
Set-Location "$PSScriptRoot/.."

$phRoot = 'compendia/ph'
$contentsPath = Join-Path $phRoot '_CONTENTS.md'

# arxiv slug superseded by curated compendium slug
$excludeSlugs = @('2406.14677v1')

function Get-PaperBlock {
    param([string]$slug)

    $path = Join-Path $phRoot "$slug.md"
    $lines = [System.IO.File]::ReadAllLines($path, [System.Text.UTF8Encoding]::new($false))

    $title = ($lines | Where-Object { $_ -match '^#\s+' } | Select-Object -First 1) -replace '^#\s+', ''
    if (-not $title) { $title = $slug }

    $inContents = $false
    $toc = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $lines) {
        if ($line -match '^## Contents\s*$') { $inContents = $true; continue }
        if ($inContents -and $line -match '^## ') { break }
        if ($inContents -and $line -match '^\s*-\s+\[') {
            $rewritten = $line -replace '\]\(#', "]($slug.md#"
            $toc.Add($rewritten)
        }
    }

    $block = [System.Collections.Generic.List[string]]::new()
    $block.Add("## [$title]($slug.md)")
    $block.Add('')
    if ($toc.Count -eq 0) {
        $block.Add("- [References]($slug.md#references)")
    }
    else {
        foreach ($t in $toc) { $block.Add($t) }
    }
    $block.Add('')
    $block.Add('---')
    $block.Add('')

    return ($block -join "`n")
}

$slugs = Get-ChildItem -LiteralPath $phRoot -Filter '*.md' |
    Where-Object { $_.Name -ne '_CONTENTS.md' } |
    ForEach-Object { $_.BaseName } |
    Where-Object { $_ -notin $excludeSlugs } |
    Sort-Object

$out = [System.Collections.Generic.List[string]]::new()
$out.Add('# Persistent Homology Compendium')
$out.Add('')

foreach ($slug in $slugs) {
    $out.Add((Get-PaperBlock $slug))
}

$text = ($out -join "`n").TrimEnd() + "`n"
[System.IO.File]::WriteAllText($contentsPath, $text, [System.Text.UTF8Encoding]::new($false))

Write-Host "Rebuilt _CONTENTS.md with $($slugs.Count) papers" -ForegroundColor Green
if ($excludeSlugs) {
    Write-Host "Excluded (duplicate/superseded): $($excludeSlugs -join ', ')" -ForegroundColor Yellow
}
