#requires -Version 7.0
<#
  src/gauntlet-batch-worker.ps1 — child-process executor for gauntlet-batch.ps1: ONE job per
  process (isolation is the point — $script:-scoped IR caches and PdfPig heap die with the job;
  a crash here is a FAIL row in the batch table, never a pool casualty). Dot-sources only what
  the job type needs; the final stdout line is a compact `BATCH-RESULT {json}` the dispatcher
  parses back into its result row. Exit code carries success/failure.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [ValidateSet('pig', 'latex')] [string] $Type,
    [Parameter(Mandatory)] [string] $Src,
    [Parameter(Mandatory)] [string] $Slug,
    [Parameter(Mandatory)] [string] $PaperDir,
    [Parameter(Mandatory)] [string] $Repo
)
$ErrorActionPreference = 'Stop'

switch ($Type) {
    'pig' {
        . (Join-Path $Repo 'src/pdf-converter/Invoke-Pdfdig.ps1')
        $r = Invoke-Pdfdig -PdfPath $Src -PassThru
        $rendered = if ($r.Images) { $r.Images.rendered } else { 'skip' }
        $note = 'figs={0} cap={1} ejects={2} png={3}' -f `
            $r.FigureSummary.figures, $r.FigureSummary.captioned_figures, $r.FigureSummary.stray_ejects, $rendered
        'BATCH-RESULT ' + ([pscustomobject]@{ run = $r.RunStamp; note = $note } | ConvertTo-Json -Compress)
    }
    'latex' {
        . (Join-Path $Repo 'src/latex-ingest.ps1')   # self-sources runs.ps1 (New-RunDir)
        $r = Invoke-ArxivLatexToMarkdown -TarGz $Src -Slug $Slug -OutDir $PaperDir
        $note = 'md={0}kb oracle_figs={1} diagrams={2} missing={3}' -f `
            [math]::Round($r.bytes / 1kb), $r.oracle_figures, $r.diagrams, $r.figures_missing
        'BATCH-RESULT ' + ([pscustomobject]@{ run = $r.run; note = $note } | ConvertTo-Json -Compress)
    }
}
