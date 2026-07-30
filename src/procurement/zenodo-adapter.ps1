#requires -Version 7.0
<#
  src/procurement/zenodo-adapter.ps1 — Zenodo source adapter for the scholar discovery framework.
  Requires scholar-core.ps1 AND zenodo.ps1 dot-sourced first.
#>

function ConvertFrom-ZenodoToWork {
    param($Z)
    if (-not $Z) { return $null }
    
    $recId = [string]$Z.id
    $doi   = [string]$Z.doi
    $meta  = $Z.metadata
    
    $title    = if ($meta.title) { [string]$meta.title } else { '' }
    $abstract = if ($meta.description) { [string]($meta.description -replace '<[^>]+>', '') } else { '' }
    
    $authors = @()
    if ($meta.creators) {
        foreach ($c in $meta.creators) { if ($c.name) { $authors += [string]$c.name } }
    }

    $pubDate = [string]$meta.publication_date
    $year    = if ($pubDate -match '^(\d{4})') { [int]$Matches[1] } else { 0 }
    
    $pdfUrl = $null
    if ($Z.files) {
        $pdfFile = @($Z.files) | Where-Object { $_.key -match '\.pdf$' -or $_.filename -match '\.pdf$' } | Select-Object -First 1
        if ($pdfFile) {
            $pdfUrl = if ($pdfFile.links.self) { [string]$pdfFile.links.self } else { [string]$pdfFile.links.download }
        }
    }
    
    $oaUrl = if ($Z.links.html) { [string]$Z.links.html } else { "https://zenodo.org/record/$recId" }
    $ext = @{ zenodo = $recId }
    if ($doi) { $ext['doi'] = $doi }

    return New-ScholarWork -Source 'zenodo' -SourceId $recId -Doi $doi -ArxivId $null `
        -Title $title -Authors $authors -Abstract $abstract -Year $year `
        -Venue "Zenodo ($([string]$meta.resource_type.type))" -PdfUrl $pdfUrl -OaUrl $oaUrl `
        -Fields @($meta.keywords) -ExternalIds $ext
}

function Zenodo-Search {
    param([string]$Query, [int]$Start = 0, [int]$Limit = 25)
    $page = [Math]::Max([Math]::Floor($Start / $Limit) + 1, 1)
    $res = Invoke-ZenodoSearch -Query $Query -Size $Limit -Page $page
    $works = @($res.hits | ForEach-Object { ConvertFrom-ZenodoToWork $_ })
    return New-ScholarPage -Source 'zenodo' -Total ([int]$res.total_available) -Start ([Math]::Max($Start, 0)) -Works $works
}

function Zenodo-GetWork {
    param([string]$Id)
    $m = Get-ZenodoMetadata $Id
    return ConvertFrom-ZenodoToWork $m
}
