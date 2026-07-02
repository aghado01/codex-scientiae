#requires -Version 7.0
<#
  src/pdf-converter/pdfdig-ir.ps1 — pdfdig generic IR emitter.

  Faithful, opinion-free projection of everything PdfPig can see into the multi-lane JSONL
  substrate described in issues/pdfdig-lane/ir-schema.md. NO classification: roles/scripts/columns
  are measured or recorded-as-claims, never decided here. See issues/pdfdig-lane/pdfpig-capability-map.md
  for the empirical basis of every choice below.

  This increment emits build-order step 1: the document ENVELOPE + LANE 1 (letters). Lanes 2-4
  (words / blocks+reading-order / paths) follow.

    . ./pdfdig-ir.ps1
    ConvertTo-PdfDigIr -PdfPath <in.pdf> [-OutDir <dir>] [-Pages 1,2] [-Verbose]

  Emits beside the PDF (or in -OutDir):
    {slug}.pdfdig.json     document envelope
    {slug}.letters.jsonl   atomic lane (+ .jidx, .sig via jsonl.ps1)
#>

# NB: no session-scope Set-StrictMode — this is a dot-sourceable library; forcing strict mode on
# callers pollutes their session (and trips the host's exit-code epilogue). Code below is strict-safe.
. "$PSScriptRoot/../jsonl.ps1"   # Write-JsonlStage: UTF-8-no-BOM, SMP-safe, .jidx + .sig

$script:PdfPigLib = Join-Path $PSScriptRoot 'lib'   # vendored dlls; falls back to repo lib/pdfpig
if (-not (Test-Path (Join-Path $script:PdfPigLib 'UglyToad.PdfPig.dll'))) {
    $script:PdfPigLib = Join-Path $PSScriptRoot '../../lib/pdfpig'
}

# ── Interop: dependency-ordered load; nullable-struct + out-param traps live here once ──────────
function Import-PdfPig {
    [CmdletBinding()] param([string] $LibDir = $script:PdfPigLib)
    if ('UglyToad.PdfPig.PdfDocument' -as [type]) { return }   # idempotent
    $order = 'UglyToad.PdfPig.Tokens','UglyToad.PdfPig.Core','UglyToad.PdfPig.Tokenization',
             'UglyToad.PdfPig.Fonts','UglyToad.PdfPig','UglyToad.PdfPig.DocumentLayoutAnalysis'
    foreach ($n in $order) {
        $dll = Join-Path $LibDir "$n.dll"
        if (Test-Path $dll) { Add-Type -Path $dll }
        elseif ($n -notlike '*DocumentLayoutAnalysis') { throw "PdfPig assembly not found: $dll" }
    }
}

# ── Font-role store (rules-as-data). Loaded from stores/font-roles.jsonl, sorted longest-pattern-
#    first so the most specific claim wins. A font matching no entry ⇒ family/role 'unknown' ⇒ flagged
#    (never guessed). See stores/README.md + the growth loop. ──────────────────────────────────────
$script:FontRoles = $null
function Import-FontRoles {
    [CmdletBinding()] param([string] $Path = (Join-Path $PSScriptRoot 'stores/font-roles.jsonl'))
    if (-not (Test-Path $Path)) { throw "font-roles store not found: $Path" }
    $rows = [System.Collections.Generic.List[object]]::new()
    $ln = 0
    # ReadAllLines (eager) not ReadLines (lazy): a validation throw mid-file must not leave the handle open
    foreach ($line in [System.IO.File]::ReadAllLines($Path)) {
        $ln++
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $o = $null
        try { $o = $line | ConvertFrom-Json } catch { throw "font-roles.jsonl line ${ln}: bad JSON — $($_.Exception.Message)" }
        foreach ($req in 'pattern','role','family') {
            if (-not $o.PSObject.Properties[$req] -or [string]::IsNullOrEmpty($o.$req)) {
                throw "font-roles.jsonl line ${ln}: missing required field '$req'"   # bad entry = failure, not silent skip
            }
        }
        $match = if ($o.PSObject.Properties['match']) { $o.match } else { 'prefix' }
        $rows.Add([pscustomobject]@{ pattern=$o.pattern; match=$match; role=$o.role; family=$o.family
                                     domain=($o.PSObject.Properties['domain'] ? $o.domain : $null) })
    }
    # longest pattern first ⇒ most specific claim wins (CMMIB before CMMI, LMRomanCaps before LMRoman)
    $script:FontRoles = @($rows | Sort-Object { $_.pattern.Length } -Descending)
    $script:FontRoles.Count
}

function Get-FontSubsetStripped([string] $name) {
    if (-not $name) { return '' }
    # subset tag is 6 chars + '+' (e.g. ASYHPE+NimbusRomNo9L-Regu)
    if ($name.Length -gt 7 -and $name[6] -eq '+') { return $name.Substring(7) }
    return $name
}

function Resolve-Family([string] $strippedName) {
    if (-not $strippedName) { return @{ family='unknown'; role='unknown'; domain=$null } }
    if ($null -eq $script:FontRoles) { Import-FontRoles | Out-Null }
    foreach ($e in $script:FontRoles) {   # already sorted longest-first ⇒ first hit is most specific
        $hit = if ($e.match -eq 'prefix') {
            $strippedName.StartsWith($e.pattern, [StringComparison]::OrdinalIgnoreCase)
        } else {
            $strippedName.IndexOf($e.pattern, [StringComparison]::OrdinalIgnoreCase) -ge 0
        }
        if ($hit) { return @{ family=$e.family; role=$e.role; domain=$e.domain } }
    }
    return @{ family='unknown'; role='unknown'; domain=$null }
}

# name-derived bold: TeX bold is name-encoded (-Medi/-Bold/-Bx/CMBX), NOT FontDetails.IsBold (capability map §1a)
function Test-BoldByName([string] $strippedName) {
    if (-not $strippedName) { return $false }
    return ($strippedName -match '(?i)bold|-Bx|CMBX|-Medi|-Semib|Black|Heavy')
}

function ConvertTo-HexColor($color) {
    try {
        if ($null -eq $color) { return $null }
        $rgb = $color.ToRGBValues()
        $r = [int][math]::Round($rgb.Item1 * 255); $g = [int][math]::Round($rgb.Item2 * 255); $b = [int][math]::Round($rgb.Item3 * 255)
        if ($r -eq 0 -and $g -eq 0 -and $b -eq 0) { return $null }   # default black ⇒ omit
        return '#{0:x2}{1:x2}{2:x2}' -f $r, $g, $b
    } catch { return $null }
}

function Get-OriginVerdict([string] $producer, [string] $creator, [hashtable] $familiesSeen) {
    $texPat = '(?i)pdfTeX|XeTeX|LuaTeX|dvips|tex2pdf|TeX Live|MiKTeX|\bTeX\b|LaTeX'
    # ladder of cues, strongest metadata first, then font evidence (capability map §3):
    #   producer string > creator string (survives arXiv/pikepdf rewrite as "arXiv GenPDF (tex2pdf:)")
    #   > CM/AMS font presence. Records WHICH cue fired so downstream knows the sense used.
    if ($producer -match $texPat) { return @{ tag='tex'; cue='producer'; producer_verdict=$true } }
    if ($creator  -match $texPat) { return @{ tag='tex'; cue='creator';  producer_verdict=$false } }
    $hasCmAms = $familiesSeen.ContainsKey('cm') -or $familiesSeen.ContainsKey('ams') -or
                $familiesSeen.ContainsKey('rsfs') -or $familiesSeen.ContainsKey('eu')
    if ($hasCmAms) { return @{ tag='tex'; cue='fonts'; producer_verdict=$null } }
    return @{ tag='unknown'; cue='none'; producer_verdict=$null }
}

function Get-Bookmarks($doc) {
    $bm = $null
    if (-not $doc.TryGetBookmarks([ref]$bm)) { return @() }
    $out = [System.Collections.Generic.List[object]]::new()
    $walk = {
        param($node)
        $page = $null
        $pn = $node.PSObject.Properties['PageNumber']
        if ($pn) { $page = $pn.Value }
        $out.Add([ordered]@{ title = $node.Title; level = $node.Level; page = $page })
        foreach ($c in $node.Children) { & $walk $c }
    }
    foreach ($r in $bm.Roots) { & $walk $r }
    return $out.ToArray()
}

function ConvertTo-PdfDigIr {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $PdfPath,
        [string] $OutDir,
        [int[]]  $Pages,                 # optional page subset (1-based); default all
        [string] $EngineVersion = '0.1.0'
    )
    Import-PdfPig
    Import-FontRoles | Out-Null

    $PdfPath = (Resolve-Path -LiteralPath $PdfPath).Path
    $slug    = [System.IO.Path]::GetFileNameWithoutExtension($PdfPath)
    if (-not $OutDir) { $OutDir = [System.IO.Path]::GetDirectoryName($PdfPath) }
    if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Force -Path $OutDir | Out-Null }

    $bytes  = (Get-Item -LiteralPath $PdfPath).Length
    $sha    = (Get-FileHash -LiteralPath $PdfPath -Algorithm SHA256).Hash.ToLowerInvariant()

    $doc = [UglyToad.PdfPig.PdfDocument]::Open($PdfPath)
    try {
        $producer = ''; $creator = $null; $title = $null; $author = $null
        try { $producer = $doc.Information.Producer } catch {}
        try { $creator  = $doc.Information.Creator }  catch {}
        try { $title    = $doc.Information.Title }    catch {}
        try { $author   = $doc.Information.Author }   catch {}
        $version = 0.0; try { $version = $doc.Version } catch {}
        $hasXmp = $false; $x = $null; try { $hasXmp = $doc.TryGetXmpMetadata([ref]$x) } catch {}

        $pageList = if ($Pages) { $Pages } else { 1..$doc.NumberOfPages }

        # ── LANE 1 letters + rolling census/health accumulators ─────────────────────────────
        $letters   = [System.Collections.Generic.List[object]]::new()
        $fontCensus = @{}    # stripped name -> @{ family; role; sizes(HashSet); count }
        $famSeen    = @{}    # family -> $true (for origin evidence)
        $pageStats  = [System.Collections.Generic.List[object]]::new()
        $lettersTotal = 0; $unknownRole = 0; $unmapped = 0; $invisible = 0
        $lid = 0

        foreach ($pn in $pageList) {
            $page = $doc.GetPage($pn)
            $pl = $page.Letters
            $orient = @{}; $modes = @{}
            foreach ($lt in $pl) {
                $stripped = Get-FontSubsetStripped $lt.FontName
                $fam = Resolve-Family $stripped

                # census
                if (-not $fontCensus.ContainsKey($stripped)) {
                    $fontCensus[$stripped] = @{ family=$fam.family; role=$fam.role;
                                                sizes=[System.Collections.Generic.HashSet[double]]::new(); count=0 }
                }
                $c = $fontCensus[$stripped]
                [void]$c.sizes.Add([math]::Round($lt.PointSize,1)); $c.count++
                $famSeen[$fam.family] = $true

                # health
                $lettersTotal++
                if ($fam.family -eq 'unknown') { $unknownRole++ }
                if ($lt.Value -and $lt.Value.Contains([char]0xFFFD)) { $unmapped++ }
                $rm = [string]$lt.RenderingMode
                if ($rm -eq 'NeitherClip' -or $rm -eq 'Neither') { $invisible++ }

                $orient[[string]$lt.TextOrientation] = 1 + ($orient[[string]$lt.TextOrientation] ?? 0)
                $modes[$rm] = 1 + ($modes[$rm] ?? 0)

                $bb = $lt.BoundingBox
                $rec = [ordered]@{
                    id     = $lid
                    page   = $pn
                    seq    = $lt.TextSequence
                    text   = $lt.Value
                    bx     = @([math]::Round($bb.Left,2),[math]::Round($bb.Bottom,2),[math]::Round($bb.Right,2),[math]::Round($bb.Top,2))
                    base   = @([math]::Round($lt.StartBaseLine.X,2),[math]::Round($lt.StartBaseLine.Y,2))
                    ebase  = @([math]::Round($lt.EndBaseLine.X,2),[math]::Round($lt.EndBaseLine.Y,2))
                    size   = [math]::Round($lt.PointSize,1)
                    font   = $stripped
                    family = $fam.family
                    italic = [bool]$lt.FontDetails.IsItalic
                    bold_name = (Test-BoldByName $stripped)
                    wadv   = [math]::Round($lt.Width,2)
                    render = $rm
                    orient = [string]$lt.TextOrientation
                    color  = (ConvertTo-HexColor $lt.Color)
                    block  = $null; line = $null; word = $null   # back-refs filled by lanes 2/3
                }
                $letters.Add([pscustomobject]$rec)
                $lid++
            }
            $pageStats.Add([ordered]@{
                n=$pn; w=[math]::Round($page.Width,1); h=[math]::Round($page.Height,1)
                rotation=$page.Rotation.Value; letters=$pl.Count
                paths=$page.Paths.Count; images=@($page.GetImages()).Count
                orientations=$orient; render_modes=$modes
            })
        }

        $origin = Get-OriginVerdict $producer $creator $famSeen

        $fonts = foreach ($k in ($fontCensus.Keys | Sort-Object)) {
            $c = $fontCensus[$k]
            [ordered]@{ name=$k; family=$c.family; role_hint=$c.role
                        sizes=@($c.sizes | Sort-Object -Descending); letters=$c.count }
        }

        $flags = [System.Collections.Generic.List[object]]::new()
        if ($origin.cue -eq 'fonts') {
            $flags.Add([ordered]@{ code='producer_rewritten'; detail="producer '$producer' is not a TeX engine; origin inferred from fonts" })
        }
        if ($unmapped -gt 0) { $flags.Add([ordered]@{ code='unmapped_symbol'; detail="$unmapped letter(s) carry U+FFFD" }) }
        if ($unknownRole -gt 0) { $flags.Add([ordered]@{ code='unknown_font_role'; detail="$unknownRole letter(s) in fonts with no family match" }) }

        $health = [ordered]@{
            letters_total        = $lettersTotal
            known_font_role_frac = if ($lettersTotal) { [math]::Round(1 - $unknownRole/$lettersTotal, 4) } else { $null }
            unmapped_symbol_count= $unmapped
            invisible_letter_frac= if ($lettersTotal) { [math]::Round($invisible/$lettersTotal, 4) } else { 0 }
            columns_confident_frac = $null     # requires LANE 3 (segmentation) — not computed yet
            flags_per_page       = if ($pageList.Count) { [math]::Round($flags.Count/$pageList.Count, 3) } else { 0 }
            domain               = if ($origin.tag -eq 'tex') { 'tex-origin' } else { 'unknown' }
        }

        $envelope = [ordered]@{
            schema = 'pdfdig-ir/1'
            source = [ordered]@{ pdf=[System.IO.Path]::GetFileName($PdfPath); slug=$slug; bytes=$bytes; sha256=$sha }
            engine = [ordered]@{ name='pdfdig-ps'; version=$EngineVersion; pdfpig='0.1.14'; config_hash=$null
                                 run_utc=(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
            document = [ordered]@{
                pages=$doc.NumberOfPages; version=$version; encrypted=$doc.IsEncrypted
                producer=$producer; creator=$creator; title=$title; author=$author
                origin=$origin
                has_struct_tree = ($doc.GetPage($pageList[0]).GetMarkedContents().Count -gt 0)
                has_xmp=$hasXmp; has_bookmarks=$false
            }
            bookmarks = (Get-Bookmarks $doc)
            fonts     = @($fonts)
            pages     = @($pageStats)
            health    = $health
            flags     = @($flags)
        }
        $envelope.document.has_bookmarks = ($envelope.bookmarks.Count -gt 0)

        # ── write ────────────────────────────────────────────────────────────────────────────
        $lettersPath = Join-Path $OutDir "$slug.letters.jsonl"
        $manifest = Write-JsonlStage -Records $letters.ToArray() -OutputPath $lettersPath -SourcePath $PdfPath -Stage 'pdfdig-ir/letters'

        $envPath = Join-Path $OutDir "$slug.pdfdig.json"
        $envJson = $envelope | ConvertTo-Json -Depth 12
        [System.IO.File]::WriteAllText($envPath, $envJson, [System.Text.UTF8Encoding]::new($false))

        [pscustomobject]@{
            Slug = $slug; Envelope = $envPath; Letters = $lettersPath
            LettersCount = $letters.Count; Pages = $pageList.Count
            Origin = "$($origin.tag) (cue=$($origin.cue))"; Fonts = $fonts.Count
            Health = $health; Flags = $flags.Count
        }
    } finally {
        $doc.Dispose()
    }
}
