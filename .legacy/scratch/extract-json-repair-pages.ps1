param(
    [Parameter(Mandatory=$true)]
    [string]$JsonFile,

    [string]$Keyword = "",

    [string[]]$Types = @("paragraph","formula","image"),

    [switch]$IgnoreCase
)

function Get-PageRanges {
    param([int[]]$Pages)
    if ($Pages.Count -eq 0) { return @() }

    $Pages = $Pages | Sort-Object
    $ranges = @()
    $start = $Pages[0]
    $end = $start

    for ($i = 1; $i -lt $Pages.Count; $i++) {
        if ($Pages[$i] -eq $end + 1) {
            $end = $Pages[$i]
            continue
        }
        if ($start -eq $end) { $ranges += "$start" }
        else { $ranges += "$start-$end" }
        $start = $Pages[$i]
        $end = $start
    }

    if ($start -eq $end) { $ranges += "$start" }
    else { $ranges += "$start-$end" }

    return $ranges
}

function Normalize-Type {
    param([string]$type)
    if (-not $type) { return "" }
    return $type.Trim().ToLowerInvariant()
}

$raw = Get-Content -Path $JsonFile -Raw
$doc = $raw | ConvertFrom-Json

if (-not $doc.kids) {
    Write-Error "JSON file does not contain a top-level 'kids' array."
    exit 1
}

$needle = $null
if ($Keyword) {
    $options = [System.Text.RegularExpressions.RegexOptions]::None
    if ($IgnoreCase.IsPresent) {
        $options = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    }
    $needle = [regex]::new([regex]::Escape($Keyword), $options)
}

$selectedTypes = $Types | ForEach-Object { Normalize-Type $_ } | Where-Object { $_ }

$pages = [System.Collections.Generic.SortedSet[int]]::new()

foreach ($kid in $doc.kids) {
    $page = $kid.'page number'
    if (-not $page) { continue }

    $type = Normalize-Type $kid.type
    $typeMatch = $false
    if ($selectedTypes.Count -eq 0) {
        $typeMatch = $true
    } elseif ($selectedTypes -contains $type) {
        $typeMatch = $true
    }

    $keywordMatch = $false
    if ($needle -and $kid.content) {
        $keywordMatch = $needle.IsMatch($kid.content)
    }

    if ($typeMatch -or $keywordMatch) {
        $pages.Add([int]$page) | Out-Null
    }
}

if ($pages.Count -eq 0) {
    Write-Host "No matching pages found."
    exit 0
}

$matchedPages = $pages | Sort-Object
$ranges = Get-PageRanges -Pages $matchedPages

Write-Host "Matched pages: $($matchedPages -join ', ')"
Write-Host "Matched page ranges: $($ranges -join ', ')"
