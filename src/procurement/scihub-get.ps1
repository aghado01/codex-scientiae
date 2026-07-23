#requires -Version 7.0
<#
  src/scihub-get.ps1 — the Sci-Hub DOI->PDF fetcher (the DOI fetcher the discovery framework's
  acquire/route=doi seam feeds). Requires scholar-core.ps1 dot-sourced first (ConvertTo-NormalizedDoi /
  Wait-ScholarRate / Get-ScholarUserAgent).

  Substrate confirmed by the §5 recon (.discussion/scihub-fetcher-brief.md): the happy path is plain HTTP,
  NO browser. Per DOI: health-check a configurable mirror list (mirrors rotate/die), GET {mirror}/{doi}
  (server-rendered HTML, no Cloudflare), scrape the .pdf URL from the markup, download it (often from a
  separate storage domain), %PDF-guard, and stage into the shared inbox by sanitized-DOI key. A mirror
  that returns 403 / no-PDF / a captcha page is skipped; if none serve a PDF, the reason is reported (a
  'captcha' result flags the human-in-loop contingency, which is NOT built for v1).

  Classic no-account Sci-Hub only (frozen corpus). Legal posture is the user's to weigh (see brief §7).
#>

$script:ScihubDefaultMirrors = @('https://sci-hub.ru', 'https://sci-hub.st', 'https://sci-hub.se', 'https://sci-hub.wf', 'https://sci-hub.ee')
$script:ScihubDefaultUA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0'
$script:ScihubLastGood = $null   # try the last mirror that worked first (cheap optimization)

function Get-ScihubConfig {
    param([string]$Path)
    if ($Path -and (Test-Path -LiteralPath $Path -PathType Leaf)) {
        $c = [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json
        if (-not $c.mirrors) { $c | Add-Member -NotePropertyName mirrors -NotePropertyValue $script:ScihubDefaultMirrors -Force }
        return $c
    }
    return [pscustomobject]@{ mirrors = $script:ScihubDefaultMirrors; request_interval_ms = 2000; pdf_min_bytes = 1024; timeout_sec = 20; user_agent = $script:ScihubDefaultUA }
}

# Filesystem-safe slug from a DOI (canonicalized, slashes/specials -> _) for the inbox folder + filenames.
function ConvertTo-ScihubSlug {
    param([string]$Doi)
    $d = ConvertTo-NormalizedDoi $Doi
    if (-not $d) { throw "invalid/empty DOI: '$Doi'" }
    return ($d -replace '[^A-Za-z0-9._-]', '_').Trim('_')
}

# Scrape the PDF URL out of a Sci-Hub DOI page. Prefers a storage/download URL; resolves protocol-relative
# (//host/x.pdf), mirror-relative (/downloads/x.pdf), and absolute forms. $null when none (captcha/absent).
function Resolve-ScihubPdfUrl {
    param([string]$Html, [string]$MirrorBase)
    $hits = @([regex]::Matches($Html, '(?i)(?:(?:https?:)?//|/)[^"''<>\s)]+?\.pdf(?:[?#][^"''<>\s)]*)?') | ForEach-Object { $_.Value })
    if (-not $hits.Count) { return $null }
    $u = ($hits | Where-Object { $_ -match '(?i)storage|download' } | Select-Object -First 1)
    if (-not $u) { $u = $hits[0] }
    if ($u -match '^//') { return 'https:' + $u }
    if ($u -match '^/')  { return ($MirrorBase.TrimEnd('/') + $u) }
    return $u
}

# A captcha GATE = no scrapeable PDF + an active captcha widget/input (NOT the latent 'var captcha={}' JS
# that coexists with a served PDF). Used only for the failure reason / contingency flag.
function Test-ScihubCaptchaGate {
    param([string]$Html, [string]$MirrorBase)
    if (Resolve-ScihubPdfUrl -Html $Html -MirrorBase $MirrorBase) { return $false }
    return [bool]($Html -match '(?i)g-recaptcha|h-captcha|hcaptcha|recaptcha/api|name=["'']?captcha|<img[^>]*captcha')
}

function Get-ScihubHeadBytes {
    param([string]$Path, [int]$Count = 5)
    $fs = [System.IO.File]::OpenRead($Path)
    try { $b = [byte[]]::new($Count); $n = $fs.Read($b, 0, $Count); if ($n -lt $Count) { return $b[0..([Math]::Max($n - 1, 0))] }; return $b }
    finally { $fs.Dispose() }
}
function Get-ScihubRepoRel {
    param([string]$Full, [string]$RepoRoot)
    try { return [System.IO.Path]::GetRelativePath($RepoRoot, $Full).Replace('\', '/') } catch { return $Full }
}

# Fetch a DOI's PDF via Sci-Hub and stage it into the shared inbox. Returns a staged manifest, or
# { available = $false; reason } when no mirror served a usable PDF.
function Invoke-ScihubFetch {
    param([string]$Doi, [pscustomobject]$Config, [string]$StagingRoot, [string]$RepoRoot, [switch]$Force)
    $doiNorm = ConvertTo-NormalizedDoi $Doi
    if (-not $doiNorm) { throw "invalid DOI: '$Doi'" }
    $slug = ConvertTo-ScihubSlug $doiNorm
    $dir = Join-Path $StagingRoot $slug
    $pdfPath  = Join-Path $dir "$slug.pdf"
    $metaPath = Join-Path $dir "$slug.scihub.json"
    if ((Test-Path -LiteralPath $pdfPath -PathType Leaf) -and -not $Force) {
        return [pscustomobject]@{ route = 'scihub'; doi = $doiNorm; slug = $slug; already_present = $true
            pdf_path = (Get-ScihubRepoRel $pdfPath $RepoRoot); pdf_bytes = (Get-Item -LiteralPath $pdfPath).Length }
    }

    $mirrors = @($Config.mirrors)
    if ($script:ScihubLastGood) { $mirrors = @($script:ScihubLastGood) + @($mirrors | Where-Object { $_ -ne $script:ScihubLastGood }) }
    $interval = if ($Config.request_interval_ms) { [int]$Config.request_interval_ms } else { 2000 }
    $timeout  = if ($Config.timeout_sec) { [int]$Config.timeout_sec } else { 20 }
    $minBytes = if ($Config.pdf_min_bytes) { [int]$Config.pdf_min_bytes } else { 1024 }
    $ua = if ($Config.user_agent) { [string]$Config.user_agent } else { $script:ScihubDefaultUA }
    $headers = @{ 'User-Agent' = $ua }
    $tried = @()

    foreach ($mirror in $mirrors) {
        $rateKey = ([uri]$mirror).Host
        # 1. DOI landing page (tolerate HTTP errors so we can fall through mirrors).
        Wait-ScholarRate -Key $rateKey -MinIntervalMs $interval
        try {
            $resp = Invoke-WebRequest -Uri "$($mirror.TrimEnd('/'))/$doiNorm" -Headers $headers -TimeoutSec $timeout -MaximumRedirection 3 -SkipHttpErrorCheck -ErrorAction Stop
        } catch { $tried += "$rateKey`:neterr"; continue }
        if ([int]$resp.StatusCode -ne 200) { $tried += "$rateKey`:$($resp.StatusCode)"; continue }

        $body = [string]$resp.Content
        $pdfUrl = Resolve-ScihubPdfUrl -Html $body -MirrorBase $mirror
        if (-not $pdfUrl) {
            $tried += if (Test-ScihubCaptchaGate -Html $body -MirrorBase $mirror) { "$rateKey`:captcha" } else { "$rateKey`:nopdf" }
            continue
        }

        # 2. Download the PDF (often a separate storage domain) and guard it.
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        $tmp = "$pdfPath.part"
        try {
            Wait-ScholarRate -Key (([uri]$pdfUrl).Host) -MinIntervalMs $interval
            Invoke-WebRequest -Uri $pdfUrl -OutFile $tmp -Headers $headers -TimeoutSec ([Math]::Max($timeout, 60)) -MaximumRedirection 5 -ErrorAction Stop
        } catch { if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }; $tried += "$rateKey`:dlerr"; continue }
        $sig = -join ((Get-ScihubHeadBytes $tmp 5) | ForEach-Object { [char]$_ })
        if ($sig -notmatch '^%PDF' -or (Get-Item -LiteralPath $tmp).Length -lt $minBytes) {
            Remove-Item -LiteralPath $tmp -Force; $tried += "$rateKey`:notpdf"; continue
        }
        Move-Item -LiteralPath $tmp -Destination $pdfPath -Force
        $bytes = (Get-Item -LiteralPath $pdfPath).Length
        $script:ScihubLastGood = $mirror

        $sidecar = [ordered]@{ doi = $doiNorm; slug = $slug; source = 'scihub'; mirror = $mirror
            pdf_url = $pdfUrl; pdf_bytes = $bytes; fetched_at = (Get-Date).ToString('o'); fetched_by = 'codex-scihub/0.1' }
        [System.IO.File]::WriteAllText($metaPath, ($sidecar | ConvertTo-Json -Depth 6), [System.Text.UTF8Encoding]::new($false))

        return [pscustomobject]@{ route = 'scihub'; doi = $doiNorm; slug = $slug; already_present = $false
            mirror = $mirror; pdf_url = $pdfUrl; pdf_path = (Get-ScihubRepoRel $pdfPath $RepoRoot)
            metadata_path = (Get-ScihubRepoRel $metaPath $RepoRoot); pdf_bytes = $bytes }
    }

    return [pscustomobject]@{ route = 'scihub'; doi = $doiNorm; available = $false
        reason = "no mirror served a PDF (tried: $($tried -join ', ')). A 'captcha' result flags the human-in-loop contingency; otherwise the DOI may be outside Sci-Hub's frozen corpus." }
}
