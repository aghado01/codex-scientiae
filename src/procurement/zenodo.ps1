#requires -Version 7.0
<#
  src/procurement/zenodo.ps1 — Zenodo acquisition core library.

  Provides record lookup, search, file downloading with MD5 checksum verification,
  layout template resolution, and background fetch job management for Zenodo.
#>

. "$PSScriptRoot/scholar-core.ps1"

$script:ZenodoApiUrl        = 'https://zenodo.org/api/records'
$script:ZenodoMinIntervalMs = 1000   # Polite default 1s interval (60 req/min unauthenticated limit)
$script:ZenodoLibPath       = Join-Path $PSScriptRoot 'zenodo.ps1'

$script:ZenodoDefaultConfig = [pscustomobject]@{
    version      = '0.1.0'
    staging_root = 'ingestion/_inbox'
    slug         = 'zenodo_{id}'
    layout       = [pscustomobject]@{
        dir      = '{slug}'
        pdf      = '{slug}/{slug}.pdf'
        source   = '{slug}/{slug}.tar.gz'
        metadata = '{slug}/{slug}.zenodo.json'
    }
}

# --- ID & Path Helpers -------------------------------------------------------------------------------
function Test-ZenodoId {
    param([string]$Id)
    if ([string]::IsNullOrWhiteSpace($Id)) { return $false }
    $clean = $Id.Trim()
    return ($clean -match '^\d+$') -or ($clean -match '^(10\.5281/zenodo\.|zenodo\.)?\d+$') -or ($clean -match '^10\.5281/zenodo\.\d+$')
}

function Split-ZenodoId {
    param([string]$Id)
    if (-not (Test-ZenodoId $Id)) { throw "invalid Zenodo id or DOI: '$Id'" }
    $clean = $Id.Trim()
    $recId = $null
    if ($clean -match '(\d+)$') { $recId = $Matches[1] }
    $doi = if ($clean -match '^10\.5281/zenodo\.\d+$') { $clean } else { "10.5281/zenodo.$recId" }
    return [pscustomobject]@{
        RecordId = $recId
        Doi      = $doi
        Slug     = "zenodo_$recId"
    }
}

function ConvertTo-ZenodoPathSlug {
    param([string]$Value)
    $s = ($Value -replace '[^A-Za-z0-9._-]', '_').Trim('_', '.')
    if ([string]::IsNullOrWhiteSpace($s)) { throw "id produced an empty path slug: '$Value'" }
    return $s
}

# --- Layout Configuration -----------------------------------------------------------------------------
function Get-ZenodoConfig {
    param([string]$Path)
    if (-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $script:ZenodoDefaultConfig }
    $raw = [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($false))
    $cfg = $raw | ConvertFrom-Json
    if (-not $cfg.staging_root) { $cfg | Add-Member -NotePropertyName staging_root -NotePropertyValue $script:ZenodoDefaultConfig.staging_root -Force }
    if (-not $cfg.slug)         { $cfg | Add-Member -NotePropertyName slug         -NotePropertyValue $script:ZenodoDefaultConfig.slug -Force }
    if (-not $cfg.layout)       { $cfg | Add-Member -NotePropertyName layout       -NotePropertyValue $script:ZenodoDefaultConfig.layout -Force }
    return $cfg
}

function Get-ZenodoPlaceholders {
    param([pscustomobject]$Meta)
    $recId = [string]$Meta.id
    $year  = if ($Meta.metadata.publication_date -match '^(\d{4})') { $Matches[1] } else { (Get-Date).ToString('yyyy') }
    return @{
        '{id}'   = ConvertTo-ZenodoPathSlug $recId
        '{year}' = $year
    }
}

function Expand-ZenodoTemplate {
    param([string]$Template, [hashtable]$Placeholders)
    $out = $Template
    foreach ($k in $Placeholders.Keys) { $out = $out.Replace($k, [string]$Placeholders[$k]) }
    return $out
}

function Resolve-ZenodoStageTarget {
    param(
        [pscustomobject]$Meta,
        [pscustomobject]$Config,
        [string]$StagingRoot
    )
    $ph = Get-ZenodoPlaceholders $Meta
    $ph['{slug}'] = ConvertTo-ZenodoPathSlug (Expand-ZenodoTemplate ([string]$Config.slug) $ph)

    $rootFull = [System.IO.Path]::GetFullPath($StagingRoot)
    $sep      = [System.IO.Path]::DirectorySeparatorChar
    $rootPfx  = $rootFull.TrimEnd($sep) + $sep

    $resolve = {
        param($tpl)
        $rel  = (Expand-ZenodoTemplate ([string]$tpl) $ph).Replace('/', $sep).Replace('\', $sep)
        $full = [System.IO.Path]::GetFullPath((Join-Path $rootFull $rel))
        if (-not ("$full$sep").StartsWith($rootPfx, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "stage target escapes the staging root: '$rel'"
        }
        return $full
    }
    $artifacts = @{}
    foreach ($p in $Config.layout.PSObject.Properties) {
        if ($p.Name -in @('dir', 'metadata')) { continue }
        $artifacts[$p.Name] = & $resolve $p.Value
    }
    return [pscustomobject]@{
        Slug      = $ph['{slug}']
        Dir       = & $resolve $Config.layout.dir
        Metadata  = & $resolve $Config.layout.metadata
        Artifacts = $artifacts
    }
}

# --- Checksum Verification ---------------------------------------------------------------------------
function Test-ZenodoChecksum {
    param([string]$Path, [string]$ExpectedChecksum)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $false }
    if ([string]::IsNullOrWhiteSpace($ExpectedChecksum)) { return $true }

    $targetHash = $ExpectedChecksum
    $algo = 'MD5'
    if ($ExpectedChecksum -match '^(md5|sha1|sha256):(.+)$') {
        $algo = $Matches[1].ToUpperInvariant()
        $targetHash = $Matches[2]
    }
    try {
        $ha = [System.Security.Cryptography.HashAlgorithm]::Create($algo)
        if (-not $ha) { $ha = [System.Security.Cryptography.MD5]::Create() }
        $fs = [System.IO.File]::OpenRead($Path)
        try {
            $bytes = $ha.ComputeHash($fs)
            $actual = (-join ($bytes | ForEach-Object { $_.ToString('x2') }))
            return ($actual -eq $targetHash.ToLowerInvariant())
        } finally { $fs.Dispose(); $ha.Dispose() }
    } catch { return $false }
}

# --- API Methods -------------------------------------------------------------------------------------
function Get-ZenodoMetadata {
    param([string]$Id)
    $split = Split-ZenodoId $Id
    $url = "${script:ZenodoApiUrl}/$($split.RecordId)"
    return Get-ScholarJson -Url $url -MinIntervalMs $script:ZenodoMinIntervalMs -RateKey 'zenodo.org'
}

function Invoke-ZenodoSearch {
    param(
        [string]$Query,
        [string]$Type,
        [string]$Sort = 'bestmatch',
        [int]$Size = 10,
        [int]$Page = 1
    )
    if ([string]::IsNullOrWhiteSpace($Query)) { throw 'search query is required' }
    $q = [uri]::EscapeDataString($Query)
    $url = "${script:ZenodoApiUrl}?q=$q&size=$Size&page=$Page&sort=$Sort"
    if ($Type) { $url += "&type=$([uri]::EscapeDataString($Type))" }
    
    $res = Get-ScholarJson -Url $url -MinIntervalMs $script:ZenodoMinIntervalMs -RateKey 'zenodo.org'
    $hits = @($res.hits.hits)
    $total = if ($res.hits.total -is [int]) { $res.hits.total } elseif ($res.hits.total.value) { [int]$res.hits.total.value } else { $hits.Count }
    
    return [pscustomobject]@{
        total_available = $total
        returned        = $hits.Count
        page            = $Page
        size            = $Size
        hits            = $hits
    }
}

# --- Fetch & Staging Plumbing -----------------------------------------------------------------------
function Invoke-ZenodoFetch {
    param(
        [string]$Id,
        [pscustomobject]$Config,
        [string]$StagingRoot,
        [string]$RepoRoot,
        [string[]]$Artifacts = @('pdf'),
        [switch]$Force
    )
    if (-not (Test-ZenodoId $Id)) { throw "invalid Zenodo id: '$Id'" }
    $want = @($Artifacts | ForEach-Object { ([string]$_).ToLowerInvariant() } | Select-Object -Unique)
    if (-not $want.Count) { $want = @('pdf') }

    $meta = Get-ZenodoMetadata $Id
    $target = Resolve-ZenodoStageTarget -Meta $meta -Config $Config -StagingRoot $StagingRoot
    New-Item -ItemType Directory -Force -Path $target.Dir | Out-Null

    $files = @($meta.files)
    $results = [ordered]@{}

    foreach ($a in $want) {
        if (-not $target.Artifacts.ContainsKey($a)) {
            $results[$a] = @{ available = $false; reason = "no path template for '$a' in layout config" }; continue
        }
        $dest = $target.Artifacts[$a]
        if ((Test-Path -LiteralPath $dest -PathType Leaf) -and -not $Force) {
            $results[$a] = @{ staged = $true; already_present = $true; path = (Get-ZenodoRepoRelative $dest $RepoRoot); bytes = (Get-Item -LiteralPath $dest).Length }
            continue
        }

        # Find matching file in Zenodo's files manifest
        $matchedFile = $null
        if ($a -eq 'pdf') {
            $matchedFile = $files | Where-Object { $_.key -match '\.pdf$' -or $_.filename -match '\.pdf$' } | Select-Object -First 1
        } elseif ($a -eq 'source') {
            $matchedFile = $files | Where-Object { $_.key -match '\.(tar\.gz|tgz|zip)$' -or $_.filename -match '\.(tar\.gz|tgz|zip)$' } | Select-Object -First 1
        } else {
            $matchedFile = $files | Where-Object { $_.key -match [regex]::Escape($a) } | Select-Object -First 1
        }

        if (-not $matchedFile) {
            $results[$a] = @{ available = $false; reason = "no file matching '$a' in Zenodo record files manifest" }
            continue
        }

        $downloadUrl = if ($matchedFile.links.self) { $matchedFile.links.self } elseif ($matchedFile.links.download) { $matchedFile.links.download } else { $null }
        if (-not $downloadUrl) {
            $results[$a] = @{ available = $false; reason = "download link missing for file '$($matchedFile.key)'" }
            continue
        }

        $tmp = "$dest.part"
        $downloaded = $false
        for ($attempt = 1; $attempt -le 3; $attempt++) {
            Wait-ScholarRate -Key 'zenodo.org' -MinIntervalMs $script:ZenodoMinIntervalMs
            try {
                Invoke-WebRequest -Uri $downloadUrl -OutFile $tmp -Headers @{ 'User-Agent' = (Get-ScholarUserAgent) } `
                    -TimeoutSec 120 -MaximumRedirection 5 -ErrorAction Stop | Out-Null
                
                # Verify checksum if provided by Zenodo
                $checksum = if ($matchedFile.checksum) { $matchedFile.checksum } else { $null }
                if ($checksum -and -not (Test-ZenodoChecksum -Path $tmp -ExpectedChecksum $checksum)) {
                    throw "checksum mismatch for downloaded file (expected $checksum)"
                }
                $downloaded = $true; break
            } catch {
                if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }
                if ($attempt -eq 3) {
                    $results[$a] = @{ available = $false; reason = $_.Exception.Message }
                    break
                }
                Start-Sleep -Milliseconds ([int](400 * [Math]::Pow(2, $attempt - 1)))
            }
        }
        if (-not $downloaded) { continue }

        Move-Item -LiteralPath $tmp -Destination $dest -Force
        $results[$a] = @{ staged = $true; already_present = $false; path = (Get-ZenodoRepoRelative $dest $RepoRoot); bytes = (Get-Item -LiteralPath $dest).Length; url = $downloadUrl; fetched_at = (Get-Date).ToString('o') }
    }

    # Write sidecar metadata
    $sidecar = [ordered]@{
        id          = $meta.id
        doi         = $meta.doi
        title       = $meta.metadata.title
        creators    = @($meta.metadata.creators | ForEach-Object { $_.name })
        publication_date = $meta.metadata.publication_date
        resource_type    = $meta.metadata.resource_type.type
        fetched_at  = (Get-Date).ToString('o')
        fetched_by  = 'codex-zenodo/0.1'
        artifacts   = $results
    }
    [System.IO.File]::WriteAllText($target.Metadata, ($sidecar | ConvertTo-Json -Depth 8), [System.Text.UTF8Encoding]::new($false))

    return [pscustomobject]@{
        id            = [string]$meta.id
        slug          = $target.Slug
        title         = $meta.metadata.title
        metadata_path = (Get-ZenodoRepoRelative $target.Metadata $RepoRoot)
        artifacts     = $results
    }
}

function Get-ZenodoRepoRelative {
    param([string]$Full, [string]$RepoRoot)
    try { return [System.IO.Path]::GetRelativePath($RepoRoot, $Full).Replace('\', '/') } catch { return $Full }
}

# --- Background Worker State -------------------------------------------------------------------------
$script:ZenodoJobs = [hashtable]::Synchronized(@{})

function Initialize-ZenodoJobs {
    param([pscustomobject]$Config, [string]$StagingRoot, [string]$RepoRoot, [string]$LibPath)
    $script:ZenodoJobConfig      = $Config
    $script:ZenodoJobStagingRoot = $StagingRoot
    $script:ZenodoJobRepoRoot    = $RepoRoot
    $script:ZenodoJobLibPath     = $LibPath
}

function Start-ZenodoFetchJob {
    param([string]$Id, [string[]]$Artifacts, [bool]$Force = $false)
    $jobId = "zenodo-job-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
    $jobObj = [pscustomobject]@{
        job_id      = $jobId
        id          = $Id
        status      = 'queued'
        artifacts   = $Artifacts
        queued_at   = (Get-Date).ToString('o')
        result      = $null
        error       = $null
    }
    $script:ZenodoJobs[$jobId] = $jobObj

    # Execute fetch synchronously for in-proc simplicity or background thread
    try {
        $jobObj.status = 'running'
        $res = Invoke-ZenodoFetch -Id $Id -Config $script:ZenodoJobConfig -StagingRoot $script:ZenodoJobStagingRoot -RepoRoot $script:ZenodoJobRepoRoot -Artifacts $Artifacts -Force:$Force
        $jobObj.result = $res
        $jobObj.status = 'done'
    } catch {
        $jobObj.error = $_.Exception.Message
        $jobObj.status = 'failed'
    }
    return $jobObj
}

function Get-ZenodoJobStatus {
    param([string]$JobId)
    if (-not $JobId) { return @($script:ZenodoJobs.Values) }
    if ($script:ZenodoJobs.ContainsKey($JobId)) { return $script:ZenodoJobs[$JobId] }
    return $null
}
