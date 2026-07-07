#requires -Version 7.0
<#
  src/pdf-converter/Invoke-Pdfdig.ps1 — the committed pig / pdfdig converter ORCHESTRATOR.

  Runs the whole PdfPig converter chain for one PDF and lands EVERY regenerable artifact under a
  single runstamped, git-ignored staging dir: {paperDir}/.runs/{yyyyMMdd_HHmmss}/pig/. Nothing is
  written beside the source. This mirrors the LaTeX oracle lane (which stages under
  .runs/{stamp}/tex/ and writes only its {slug}-latex.md deliverable beside the source) and closes
  the housekeeping gap where the IR steps used to dump ~19MB/paper of letters/words/blocks/paths +
  envelope + nodes + classify + figures BESIDE the source (not git-ignored).

  Chain (all outputs -> the one pig run dir):
    1. ConvertTo-PdfDigIr     -> {slug}.pdfdig.json + {slug}.{letters,words,blocks,paths,xobjects}.jsonl
    2. ConvertTo-PdfDigNodes  -> {slug}.nodes.jsonl + {slug}.classify.json   (reads the envelope+lanes)
    3. ConvertTo-FigureRegions-> {slug}.figures.jsonl                        (reads paths+xobjects+letters+blocks)
    4. Export-PdfFigureImages -> images/imageFile{N}.png + images.jsonl      (same runstamp -> same dir)
  plus a small pig-run.json manifest. .runs/ is git-ignored, so this structurally prevents recurrence.

    . ./Invoke-Pdfdig.ps1
    Invoke-Pdfdig -PdfPath <in.pdf> [-Pages 1,2] [-Dpi 150] [-SkipImages] [-PassThru]
#>

. "$PSScriptRoot/pdfdig-classify.ps1"   # ConvertTo-PdfDigNodes (+ dot-sources pdfdig-ir.ps1 -> ConvertTo-PdfDigIr)
. "$PSScriptRoot/pdfdig-figures.ps1"    # ConvertTo-FigureRegions
. "$PSScriptRoot/pdfdig-images.ps1"     # Export-PdfFigureImages

# Fresh pig run dir {paperDir}/.runs/{stamp}/pig; a same-second collision bumps a numeric suffix on
# the STAMP (still sorts after its base stamp, newest-wins). Returns the stamp leaf + the pig dir.
# Kept local so the converter lane stays independent of the membrane's runs.ps1.
function New-PigRunDir([string] $PaperDir) {
    $stamp    = Get-Date -Format 'yyyyMMdd_HHmmss'
    $runsRoot = Join-Path $PaperDir '.runs'
    $stampDir = Join-Path $runsRoot $stamp
    $n = 1
    while (Test-Path -LiteralPath $stampDir) { $n++; $stamp = "$(Get-Date -Format 'yyyyMMdd_HHmmss')-$n"; $stampDir = Join-Path $runsRoot $stamp }
    $pig = Join-Path $stampDir 'pig'
    New-Item -ItemType Directory -Force -Path $pig | Out-Null
    return @{ Stamp = $stamp; PigDir = $pig }
}

function Invoke-Pdfdig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $PdfPath,
        [int[]]  $Pages,                 # optional 1-based page subset; default all
        [int]    $Dpi = 150,
        [switch] $SkipImages,            # skip step 4 (MuPDF raster via node) — IR-only staging
        [switch] $PassThru
    )
    if (-not (Test-Path -LiteralPath $PdfPath)) { throw "pdf not found: $PdfPath" }
    $PdfPath  = (Resolve-Path -LiteralPath $PdfPath).Path
    $paperDir = Split-Path -Parent $PdfPath
    $slug     = [System.IO.Path]::GetFileNameWithoutExtension($PdfPath)

    # ONE runstamp for the whole chain; every step reads/writes THIS pig dir.
    $run    = New-PigRunDir $paperDir
    $stamp  = $run.Stamp
    $pigDir = $run.PigDir

    # step 1: generic IR (envelope + letters/words/blocks/paths lanes)
    $irArgs = @{ PdfPath = $PdfPath; OutDir = $pigDir }
    if ($Pages) { $irArgs.Pages = $Pages }
    $ir = ConvertTo-PdfDigIr @irArgs

    # step 2: classified typed nodes (+ classify.json) — envelope+lanes read FROM the pig dir
    $cls = ConvertTo-PdfDigNodes -IrDir $pigDir -Slug $slug -OutDir $pigDir

    # step 3: figure-region clustering — reads {slug}.paths/letters/blocks.jsonl from the pig dir,
    # writes {slug}.figures.jsonl there
    $pathsJsonl   = Join-Path $pigDir "$slug.paths.jsonl"
    $figuresJsonl = Join-Path $pigDir "$slug.figures.jsonl"
    $fig = ConvertTo-FigureRegions -PathsJsonl $pathsJsonl -OutPath $figuresJsonl -PassThru

    # step 4: raster each kind=figure region to PNG (same runstamp -> same pig dir). Opt-out for
    # environments without node / the vendored MuPDF-WASM tool.
    $img = $null
    if (-not $SkipImages) {
        $img = Export-PdfFigureImages -PdfPath $PdfPath -FiguresJsonl $figuresJsonl -RunStamp $stamp -Dpi $Dpi -PassThru
    }

    # run manifest: what this chain produced, for provenance + downstream re-grounding
    $manifest = [ordered]@{
        schema   = 'pig-run/1'
        slug     = $slug
        runstamp = $stamp
        source   = [ordered]@{ pdf = (Split-Path -Leaf $PdfPath) }
        pig_dir  = $pigDir
        pages    = $ir.Pages
        steps    = [ordered]@{
            ir       = [ordered]@{ letters = $ir.Letters; words = $ir.Words; blocks = $ir.Blocks; paths = $ir.Paths; xobjects = $ir.Xobjects; origin = $ir.Origin }
            classify = [ordered]@{ nodes = $cls.Nodes; body_size = $cls.Calibration.body_size }
            figures  = [ordered]@{ regions = $fig.Summary.regions; figures = $fig.Summary.figures; marks = $fig.Summary.marks; sparse = $fig.Summary.sparse; captioned = $fig.Summary.captioned_figures; xobjects = $fig.Summary.xobjects; xobject_regions = $fig.Summary.xobject_regions; stream_blocks = $fig.Summary.stream_blocks; consensus_unions = $fig.Summary.consensus_unions; consensus_changed_pages = $fig.Summary.consensus_changed_pages; caption_splits = $fig.Summary.caption_splits; furniture = $fig.Summary.furniture; letter_blocks = $fig.Summary.letter_blocks; letter_bridges = $fig.Summary.letter_bridges }
            images   = if ($img) { [ordered]@{ rendered = $img.Summary.rendered; failed = $img.Summary.failed } } else { 'skipped' }
        }
        run_utc  = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    }
    $manifestPath = Join-Path $pigDir 'pig-run.json'
    [System.IO.File]::WriteAllText($manifestPath, ($manifest | ConvertTo-Json -Depth 8), [System.Text.UTF8Encoding]::new($false))

    Write-Verbose ("pig run {0}: {1} nodes, {2} figure(s){3} -> {4}" -f `
        $stamp, $cls.Nodes, $fig.Summary.figures, $(if ($img) { " / $($img.Summary.rendered) image(s)" } else { ' (images skipped)' }), $pigDir)

    [pscustomobject]@{
        Slug     = $slug
        RunStamp = $stamp
        PigDir   = $pigDir
        Envelope = (Join-Path $pigDir "$slug.pdfdig.json")
        Nodes    = (Join-Path $pigDir "$slug.nodes.jsonl")
        Figures  = $figuresJsonl
        Manifest = $manifestPath
        Ir       = $ir
        Classify = $cls
        FigureSummary = $fig.Summary
        Images   = $(if ($img) { $img.Summary } else { $null })
    }
}
