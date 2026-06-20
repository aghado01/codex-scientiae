#requires -Version 7.0
Set-Location "$PSScriptRoot/.."

$papers = @(
    '1809.10945v1', '2204.11080v2', '2406.14677v1', '2412.02591v2',
    'DBK2023', 'VSMJ2011', 'WRD2025'
)

$contentsPath = 'compendia/ph/_CONTENTS.md'
$existing = [System.IO.File]::ReadAllText($contentsPath, [System.Text.UTF8Encoding]::new($false))

$blocks = [System.Collections.Generic.List[string]]::new()

foreach ($slug in $papers) {
    if ($existing -match [regex]::Escape("]($slug.md)")) {
        Write-Host "skip $slug — already in _CONTENTS.md"
        continue
    }

    $path = "compendia/ph/$slug.md"
    if (-not (Test-Path -LiteralPath $path)) {
        Write-Warning "skip $slug — no promoted body"
        continue
    }

    $lines = [System.IO.File]::ReadAllLines($path, [System.Text.UTF8Encoding]::new($false))
    $title = ($lines | Where-Object { $_ -match '^#\s+' } | Select-Object -First 1) -replace '^#\s+', ''

    $inContents = $false
    $toc = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $lines) {
        if ($line -match '^## Contents\s*$') { $inContents = $true; continue }
        if ($inContents -and $line -match '^## ') { break }
        if ($inContents -and $line -match '^\s*-\s+\[') {
            $rewritten = $line -replace '\]\(#', "]($slug.md#"
            $rewritten = $rewritten -replace '\]\(references/', "](references/"
            $toc.Add($rewritten)
        }
    }

    $blocks.Add("---`n")
    $blocks.Add("## [$title]($slug.md)`n")
    if ($toc.Count -eq 0) {
        $blocks.Add("- [References]($slug.md#references)`n")
    }
    else {
        foreach ($t in $toc) { $blocks.Add($t) }
        $blocks.Add('')
    }
}

if ($blocks.Count -eq 0) {
    Write-Host "Nothing to append."
    exit 0
}

$append = ($blocks -join "`n").TrimEnd() + "`n"
Add-Content -Path $contentsPath -Value $append -Encoding utf8NoBOM
Write-Host "Appended $($papers.Count) entries to _CONTENTS.md" -ForegroundColor Green
