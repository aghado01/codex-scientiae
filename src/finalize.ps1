#requires -Version 7.0
<#
  src/finalize.ps1 — serialize the repaired chunk stream into the corpus deliverable.

  Walks the enriched chunks in reading order and emits codex-scientiae markdown per
  STANDARDS.md: an H1 title, a `## Contents` block, body sections at H2/H3/H4 by depth, prose
  paragraphs, block math fenced in $$, and running-head furniture dropped. The back-matter
  (References) is split into a sidecar references/{slug}.md, linked from Contents. First pass
  writes into the document's own .scratch/ — get the SHAPE right; the move to compendia/{topic}/
  is a later concern. Logs the 'finalized' milestone.

    . ./finalize.ps1
    Invoke-Finalize -ChunksPath <chunks.jsonl> [-OutputDir <dir>]
#>

. "$PSScriptRoot/serving.ps1"

function ConvertTo-Anchor([string]$h) {
    (($h.ToLowerInvariant() -replace '[^\w\s-]', '') -replace '\s+', '-')
}

# caption furniture -> italic, heading -> #*(level+1), block formula -> $$ fence, else content as-is
function Format-Chunk($c) {
    if ([string]$c.is_furniture -eq 'caption') { return '*' + ([string]$c.content) + '*' }
    switch ([string]$c.type) {
        'heading' { $lvl = if ($c.section_level) { [Math]::Min(6, [int]$c.section_level + 1) } else { 2 }; ('#' * $lvl) + ' ' + ([string]$c.content) }
        'formula' { '$$' + "`n" + ([string]$c.content) + "`n" + '$$' }
        default   { [string]$c.content }
    }
}

function Invoke-Finalize {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$ChunksPath,
        [string]$OutputDir
    )
    $chunks = @(Read-Chunks $ChunksPath)
    $slug = (Split-Path -Leaf $ChunksPath) -replace '\.chunks\.jsonl$', ''
    if (-not $OutputDir) { $OutputDir = Split-Path -Parent $ChunksPath }   # .scratch, first pass
    $live  = @($chunks | Where-Object { $_.is_furniture -notin 'running_head', 'figure_label', 'crumb' })
    $title = ($live | Where-Object { $_.title_candidate } | Select-Object -First 1).content

    # ── single ordered pass: split front-matter / body / bibliography ─────
    # The sidecar is the bibliography REGION only (References heading → next heading),
    # not the whole back-matter zone — appendices are part of the paper and stay in the body.
    $front = [System.Collections.Generic.List[object]]::new()
    $bodyC = [System.Collections.Generic.List[object]]::new()
    $bibC  = [System.Collections.Generic.List[object]]::new()
    $toc   = [System.Collections.Generic.List[string]]::new()
    $inBib = $false
    foreach ($c in $live) {
        $isHeading = ([string]$c.type -eq 'heading')
        if ($isHeading) {
            if ($c.section_role -eq 'references' -or ([string]$c.content -match '^\s*references\s*$')) {
                $inBib = $true
                $toc.Add("- [References](references/$slug.md)")   # link at its natural position
                continue                                          # heading becomes the sidecar's own title
            }
            $inBib = $false                                       # any other heading closes the bibliography
        }
        if ($c.zone -eq 'frontmatter') { if (-not $c.title_candidate) { $front.Add($c) }; continue }
        if ($inBib) { $bibC.Add($c); continue }
        $bodyC.Add($c)
        if ($isHeading -and $c.section_level) {
            $indent = '  ' * ([Math]::Max(0, [int]$c.section_level - 1))
            $toc.Add("$indent- [$([string]$c.content)](#$(ConvertTo-Anchor ([string]$c.content)))")
        }
    }

    # ── body ──────────────────────────────────────────────────────────────
    $body = [System.Collections.Generic.List[string]]::new()
    if ($title) { $body.Add("# $title"); $body.Add('') }
    foreach ($c in $front) { $body.Add([string]$c.content); $body.Add('') }   # authors / affiliation / abstract, plain
    $body.Add('## Contents'); $body.Add('')
    foreach ($line in $toc) { $body.Add($line) }
    $body.Add('')
    foreach ($c in $bodyC) { $body.Add((Format-Chunk $c)); $body.Add('') }

    # ── references sidecar ────────────────────────────────────────────────
    $refs = [System.Collections.Generic.List[string]]::new()
    $refs.Add("# References — $slug"); $refs.Add('')
    foreach ($c in $bibC) { $refs.Add((Format-Chunk $c)); $refs.Add('') }

    # ── write ─────────────────────────────────────────────────────────────
    $bodyPath = Join-Path $OutputDir "$slug.md"
    $refDir   = Join-Path $OutputDir 'references'
    if (-not (Test-Path -LiteralPath $refDir)) { New-Item -ItemType Directory -Force -Path $refDir | Out-Null }
    $refPath  = Join-Path $refDir "$slug.md"
    ($body -join "`n") | Set-Content -LiteralPath $bodyPath -Encoding utf8
    ($refs -join "`n") | Set-Content -LiteralPath $refPath  -Encoding utf8

    $sections = @($bodyC | Where-Object { [string]$_.type -eq 'heading' -and $_.section_level }).Count
    $pending  = @($live | Where-Object { $_.fidelity -in 'needs_review', 'needs_repair', 'suspect' }).Count
    Add-LedgerEntry $ChunksPath 'finalized' @{ body = "$slug.md"; references = "references/$slug.md"; sections = $sections; bib = $bibC.Count; pending = $pending }
    [pscustomobject]@{ ok = $true; paper = $slug; body = $bodyPath; references = $refPath; sections = $sections; bib = $bibC.Count; pending = $pending }
}

# The one sanctioned holistic read. The membrane is body-blind by construction — the per-unit
# loop works through scoped slices so the agent never re-reads the whole paper. At the very end,
# a single full pass over the ASSEMBLED deliverable catches what per-chunk review can't: flow
# across sections, a heading that reads wrong in context, a caption cut loose from its figure.
# Assembles fresh, then returns the body + references in full (content IS the point here) plus the
# still-flagged chunks with ids and reasons, so the spot-check is targeted rather than a blind reread.
function Get-FinalReview([string]$ChunksPath) {
    $fin    = Invoke-Finalize -ChunksPath $ChunksPath
    $chunks = @(Read-Chunks $ChunksPath)
    $flagged = @($chunks |
        Where-Object { $_.fidelity -in 'needs_review', 'needs_repair', 'suspect' } |
        ForEach-Object {
            $t = [string]$_.content
            [pscustomobject]@{
                id       = $_.id
                fidelity = $_.fidelity
                reason   = if ($_.review_reason) { $_.review_reason } elseif ($_.corruption_type) { $_.corruption_type } else { $null }
                preview  = $t.Substring(0, [Math]::Min(80, $t.Length))
            }
        })
    [pscustomobject]@{
        paper      = $fin.paper
        sections   = $fin.sections
        bib        = $fin.bib
        pending    = $fin.pending
        flagged    = $flagged
        body       = (Get-Content -LiteralPath $fin.body       -Raw)
        references = (Get-Content -LiteralPath $fin.references -Raw)
    }
}
