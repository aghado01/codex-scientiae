#requires -Version 7.0
Set-Location "$PSScriptRoot/.."

$papers = @(
    '1809.10945v1', '2204.11080v2', '2406.14677v1', '2412.02591v2',
    'DBK2023', 'VSMJ2011', 'WRD2025'
)

function Get-RawMdPath([string]$slug) {
    $candidates = @(
        "ingestion/compendia/ph/$slug/$slug.md",
        "ingestion/compendia/ph/$slug/.scratch/$slug.md"
    )
    foreach ($p in $candidates) {
        if (Test-Path -LiteralPath $p) { return $p }
    }
    return $null
}

function Get-ImageSourceDir([string]$slug) {
    $nested = "ingestion/compendia/ph/$slug/$slug"
    if (Test-Path -LiteralPath $nested) { return $nested }
    return $null
}

function Inject-Images([string]$body, [string]$rawPath, [string]$slug) {
    if (-not $rawPath -or -not (Test-Path -LiteralPath $rawPath)) { return $body }
    $rawLines = [System.IO.File]::ReadAllLines($rawPath, [System.Text.UTF8Encoding]::new($false))
    $out = $body
    for ($i = 0; $i -lt $rawLines.Count; $i++) {
        $line = $rawLines[$i]
        if ($line -notmatch '!\[.*\]\(.*imageFile\d+\.png.*\)') { continue }
        if ($line -match 'imageFile(\d+)\.png') {
            $n = $Matches[1]
            if ($out -match "imageFile$n\.png") { continue }
        } else { continue }
        # normalize path to compendia convention: <slug/imageFileN.png>
        $imgLine = $line -replace [regex]::Escape("$slug/"), "$slug/"
        if ($imgLine -notmatch "<$slug/") {
            $imgLine = $imgLine -replace "\(<$slug/", "(<$slug/" -replace "\($slug/", "(<$slug/"
        }
        $anchor = ''
        for ($j = $i - 1; $j -ge 0; $j--) {
            $prev = $rawLines[$j].Trim()
            if ($prev -and $prev -notmatch '!\[' -and $prev.Length -gt 20) {
                $anchor = $prev.Substring(0, [Math]::Min(80, $prev.Length))
                break
            }
        }
        if ($anchor -and $out.Contains($anchor)) {
            $idx = $out.IndexOf($anchor)
            $insertAt = $out.IndexOf("`n", $idx + $anchor.Length)
            if ($insertAt -lt 0) { $insertAt = $out.Length }
            $out = $out.Insert($insertAt, "`n`n$imgLine")
        } else {
            $out = $out.TrimEnd() + "`n`n$imgLine"
        }
    }
    return $out
}

$promoted = [System.Collections.Generic.List[object]]::new()

foreach ($slug in $papers) {
    $scratchBody = "ingestion/compendia/ph/$slug/.scratch/$slug.md"
    $scratchRefs = "ingestion/compendia/ph/$slug/.scratch/references/$slug.md"
    if (-not (Test-Path -LiteralPath $scratchBody)) {
        Write-Warning "skip $slug — no scratch body"
        continue
    }

    $destBody = "compendia/ph/$slug.md"
    $destRefs = "compendia/ph/references/$slug.md"
    $destImg  = "compendia/ph/$slug"

    $body = [System.IO.File]::ReadAllText($scratchBody, [System.Text.UTF8Encoding]::new($false))
    $raw  = Get-RawMdPath $slug
    $body = Inject-Images $body $raw $slug

    [System.IO.Directory]::CreateDirectory((Split-Path -Parent $destBody)) | Out-Null
    [System.IO.Directory]::CreateDirectory('compendia/ph/references') | Out-Null
    [System.IO.File]::WriteAllText($destBody, $body, [System.Text.UTF8Encoding]::new($false))

    if (Test-Path -LiteralPath $scratchRefs) {
        Copy-Item -LiteralPath $scratchRefs -Destination $destRefs -Force
    }

    $imgSrc = Get-ImageSourceDir $slug
    $imgCount = 0
    if ($imgSrc) {
        New-Item -ItemType Directory -Force -Path $destImg | Out-Null
        Get-ChildItem -LiteralPath $imgSrc -File -Include *.png,*.jpg,*.jpeg,*.gif,*.webp | ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $destImg $_.Name) -Force
            $imgCount++
        }
    }

    $title = ($body -split "`n" | Where-Object { $_ -match '^#\s+' } | Select-Object -First 1) -replace '^#\s+', ''
    $promoted.Add([pscustomobject]@{ slug = $slug; title = $title; images = $imgCount; body = $destBody })
    Write-Host "promoted $slug -> $destBody (refs + $imgCount images)" -ForegroundColor Green
}

Write-Host "`nPromoted $($promoted.Count) papers:" -ForegroundColor Cyan
$promoted | Format-Table slug, images -AutoSize
