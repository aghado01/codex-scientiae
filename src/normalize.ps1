#requires -Version 7.0
<#
  src/normalize.ps1 — deterministic content cleanup before grading.

  Two model-free passes the pipeline can do on its own, so the agent only ever sees genuine
  judgment calls — never mechanical toil:

  * Math de-spacing — Docling space-tokenizes LaTeX (`\frac { d + 1 } { 2 }`); tighten braces
    and sub/superscripts back to compact form, and strip blackboard-bold and other font-only
    macros (`\mathbb { E }` -> `E`) that carry no meaning in a linearized, centre-justified
    transfer. The pre-image is kept in content_raw — every tightening is reversible.

  * Figure furniture — subfigure labels (`(a) ...`), figure/table captions, and OCR crumbs
    (`=2`) leak into the body as untyped prose; tag them is_furniture so finalize can drop the
    noise and set captions apart. Nothing is deleted; the tag is reversible and audited.

    . ./normalize.ps1
    Invoke-Normalize -ChunksPath <chunks.jsonl> [-NodesPath <nodes.jsonl>] [-StripMacros mathbb,...]
#>

. "$PSScriptRoot/jsonl.ps1"

# Compact a span of space-tokenized LaTeX: drop font-only macros, then tighten the delimiters
# the tokenizer loosened. Conservative — only braces and sub/superscripts are closed up; spaces
# that separate a \command from its argument are left alone, so nothing is silently fused.
function Optimize-MathContent([string]$Latex, [string[]]$StripMacros) {
    $s = $Latex
    foreach ($m in $StripMacros) {
        $s = [regex]::Replace($s, "\\$m\s*\{\s*([^{}]*?)\s*\}", '$1')   # \mathbb { E } -> E
        $s = [regex]::Replace($s, "\\$m\s+(\w)", '$1')                  # \mathbb E     -> E
    }
    $s = $s -replace '\{\s+', '{'           # tighten inside opening brace
    $s = $s -replace '\s+\}', '}'           # tighten inside closing brace
    $s = $s -replace '\s+\{', '{'           # close \command { up to its group
    $s = $s -replace '\s*([_^])\s*', '$1'   # tighten sub/superscript
    $s = $s -replace '[ \t]{2,}', ' '       # collapse space runs
    return $s.Trim()
}

# Body prose that is really figure apparatus, by leading shape: a figure/table caption, a
# subfigure label, or a short non-linguistic OCR crumb. null = leave it as body content.
function Get-FurnitureKind([object]$Chunk) {
    if ([string]$Chunk.type -ne 'prose') { return $null }
    $t = ([string]$Chunk.content).Trim()
    if ($t -match '^(Figure|Fig\.?|Table|Tab\.?)\s*\d+\s*[:.]') { return 'caption' }
    if ($t -match '^\([a-z]\)\s')                                { return 'figure_label' }
    if ($t.Length -le 4 -and $t -notmatch '[A-Za-z]{2,}')        { return 'crumb' }
    return $null
}

function Invoke-Normalize {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ChunksPath,
        [string] $NodesPath,
        [string[]] $StripMacros = @('mathbb')
    )
    $chunks = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadLines($ChunksPath)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) { $chunks.Add(($line | ConvertFrom-Json)) }
    }

    $mathFixed = 0
    $furn = [ordered]@{ caption = 0; figure_label = 0; crumb = 0 }
    foreach ($c in $chunks) {
        if ([string]$c.type -eq 'formula' -and $c.content) {
            $orig = [string]$c.content
            $norm = Optimize-MathContent $orig $StripMacros
            if ($norm -ne $orig) {
                $c | Add-Member -NotePropertyName content_raw -NotePropertyValue $orig -Force
                $c.content = $norm
                $mathFixed++
            }
            continue
        }
        $kind = Get-FurnitureKind $c
        if ($kind -and -not $c.is_furniture) {
            $c | Add-Member -NotePropertyName is_furniture -NotePropertyValue $kind -Force
            $furn[$kind]++
        }
    }

    $manifest = Write-JsonlStage -Records $chunks.ToArray() -OutputPath $ChunksPath -SourcePath $NodesPath -Stage 'normalize'
    "normalize: math tightened on $mathFixed formula(s); furniture tagged — caption $($furn.caption), figure_label $($furn.figure_label), crumb $($furn.crumb) -> $ChunksPath"
    return $manifest
}
