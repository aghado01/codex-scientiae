#requires -Version 7.0
<#
  src/toc-engine/toc-engine.ps1 — Single-document and multi-document TOC & Tree Manifest Engine.

  Features:
  - Micro Template Engine (Expand-MdTemplate): zero-dependency 3-pass renderer ({{#each}}, {{#if}}, {{Property}})
  - Model Builder (New-DeliverableTreeModel): SMP surrogate-pair safe interval byte spans [byte_start, byte_end)
  - In-doc contents renderer (Set-MdContentsBlock) & sidecar exporter (Export-MdTreeSidecar)
  - Extensible architecture for future Bibliotheca navigation (compendia, corpora, codices)
#>

if (Test-Path -LiteralPath (Join-Path $PSScriptRoot '../shared/masks.ps1') -PathType Leaf) {
    . (Join-Path $PSScriptRoot '../shared/masks.ps1')
}
if (Test-Path -LiteralPath (Join-Path $PSScriptRoot '../md-postprocess/md-toc.ps1') -PathType Leaf) {
    . (Join-Path $PSScriptRoot '../md-postprocess/md-toc.ps1')
}

$script:TocEngineUtf8 = [System.Text.UTF8Encoding]::new($false)

# Helper: Resolve property path over object scope
function Resolve-TemplateValue($Scope, [string]$Path) {
    if ($null -eq $Scope -or [string]::IsNullOrWhiteSpace($Path)) { return $null }
    $parts = $Path.Split('.')
    $curr = $Scope
    foreach ($p in $parts) {
        if ($null -eq $curr) { return $null }
        if ($curr -is [hashtable] -or $curr -is [System.Collections.IDictionary]) {
            $curr = $curr[$p]
        }
        elseif ($curr.PSObject.Properties[$p]) {
            $curr = $curr.PSObject.Properties[$p].Value
        }
        else {
            return $null
        }
    }
    return $curr
}

# Template scope expansion helper (if & scalar substitution)
function Expand-MdTemplateScope([string]$Text, [object]$Scope, [object]$RootModel) {
    if ([string]::IsNullOrWhiteSpace($Text)) { return $Text }

    # 1. Conditionals: {{#if Property}} ... {{/if}}
    $rxIf = [regex]::new('(?s)\{\{#if\s+([A-Za-z0-9_.]+)\}\}(.*?)(?:\{\{#else\}\}(.*?))?\{\{/if\}\}')
    $Text = $rxIf.Replace($Text, {
        param($match)
        $propPath = $match.Groups[1].Value
        $trueBody = $match.Groups[2].Value
        $falseBody = if ($match.Groups.Count -gt 3) { $match.Groups[3].Value } else { '' }
        $val = Resolve-TemplateValue $Scope $propPath
        if ($null -eq $val) { $val = Resolve-TemplateValue $RootModel $propPath }
        $isTrue = if ($val -is [bool]) { $val } else { -not [string]::IsNullOrWhiteSpace([string]$val) -and $val -ne 0 }
        if ($isTrue) { return Expand-MdTemplateScope $trueBody $Scope $RootModel }
        else { return Expand-MdTemplateScope $falseBody $Scope $RootModel }
    })

    # 2. Scalars: {{Property}}
    $rxVal = [regex]::new('\{\{([A-Za-z0-9_.]+)\}\}')
    $Text = $rxVal.Replace($Text, {
        param($match)
        $propPath = $match.Groups[1].Value
        $val = Resolve-TemplateValue $Scope $propPath
        if ($null -eq $val) { $val = Resolve-TemplateValue $RootModel $propPath }
        if ($null -ne $val) { return [string]$val }
        return ''
    })

    return $Text
}

# Zero-dependency Handlebars-lite micro template expander
function Expand-MdTemplate {
    param(
        [Parameter(Mandatory)][string]$TemplateText,
        [Parameter(Mandatory)][object]$Model
    )
    if ([string]::IsNullOrWhiteSpace($TemplateText)) { return $TemplateText }

    # Pass 1: {{#each Collection}} ... {{/each}}
    $rxEach = [regex]::new('(?s)\{\{#each\s+([A-Za-z0-9_.]+)\}\}(.*?)\{\{/each\}\}')
    $expanded = $rxEach.Replace($TemplateText, {
        param($match)
        $propPath = $match.Groups[1].Value
        $body = $match.Groups[2].Value
        # A standalone {{#each}} tag line contributes no output of its own, so the newline that ENDS
        # that tag line is not part of the row body. Without this the body carries a leading newline
        # into every iteration and the rendered list comes out loose — a blank line between each row.
        $body = [regex]::Replace($body, '^\r?\n', '')
        $items = Resolve-TemplateValue $Model $propPath
        if (-not $items) { return '' }
        $sb = [System.Text.StringBuilder]::new()
        foreach ($item in @($items)) {
            $itemExpanded = Expand-MdTemplateScope $body $item $Model
            [void]$sb.Append($itemExpanded)
        }
        return $sb.ToString()
    })

    # Pass 2: {{#if}} and {{Scalar}} at root model level
    return (Expand-MdTemplateScope $expanded $Model $Model)
}

# Assembles the deliverable tree model from Markdown text + metadata
function New-DeliverableTreeModel {
    param(
        [Parameter(Mandatory)][string]$MarkdownText,
        [Parameter(Mandatory)][string]$Slug,
        [hashtable]$Metadata = @{},
        [string]$SourcePath = ''
    )
    $bytes = $script:TocEngineUtf8.GetBytes($MarkdownText)
    $totalBytes = $bytes.Length

    # Extract H1 title if not provided
    $title = if ($Metadata.ContainsKey('title') -and $Metadata['title']) { [string]$Metadata['title'] }
             elseif ($MarkdownText -match '(?m)^#\s+(.*\S)') { $matches[1].Trim() }
             else { $Slug }

    $authors = if ($Metadata.ContainsKey('authors')) { [string]$Metadata['authors'] } else { '' }
    $doi = if ($Metadata.ContainsKey('doi')) { [string]$Metadata['doi'] } else { '' }

    # Line-by-line scanning while skipping code fences
    $lines = $MarkdownText -split "`n"
    $inFence = $false
    $rawHeadings = [System.Collections.Generic.List[object]]::new()
    $byteOffset = 0

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $ln = $lines[$i]
        $lineByteLen = $script:TocEngineUtf8.GetByteCount($ln) + 1  # +1 for \n

        if ($ln -match '^```') {
            $inFence = -not $inFence
            $byteOffset += $lineByteLen
            continue
        }
        if ($inFence) {
            $byteOffset += $lineByteLen
            continue
        }

        if ($ln -match '^(#{2,6})\s+(.*\S)\s*$') {
            $level = $matches[1].Length
            $text = $matches[2].Trim()

            # Self-referential TOC heading exclusion rule
            if ($text -notmatch '^(?i)(contents|table of contents)$') {
                $anchor = if (Get-Command Get-MdAnchor -ErrorAction SilentlyContinue) { Get-MdAnchor $text } else { ($text.ToLowerInvariant() -replace '[^\w\s-]', '' -replace '\s+', '-').Trim('-') }
                $rawHeadings.Add([pscustomobject]@{
                    level      = $level
                    title      = $text
                    anchor     = $anchor
                    byte_start = $byteOffset
                })
            }
        }
        $byteOffset += $lineByteLen
    }

    # Compute section intervals [byte_start, byte_end) and character counts
    $sections = [System.Collections.Generic.List[object]]::new()
    for ($i = 0; $i -lt $rawHeadings.Count; $i++) {
        $curr = $rawHeadings[$i]
        $nextStart = if ($i + 1 -lt $rawHeadings.Count) { $rawHeadings[$i + 1].byte_start } else { $totalBytes }
        
        # Enforce SMP surrogate-pair safe boundary alignment if masks module available
        $bStart = $curr.byte_start
        $bEnd = $nextStart
        if (Get-Command Move-OffsetToCodepointStart -ErrorAction SilentlyContinue) {
            $bStart = Move-OffsetToCodepointStart $MarkdownText $bStart
            $bEnd = Move-OffsetToCodepointEnd $MarkdownText $bEnd
        }

        $bWidth = [Math]::Max(0, $bEnd - $bStart)
        $secText = if ($bWidth -gt 0 -and $bStart -lt $totalBytes) {
            $sliceLen = [Math]::Min($bWidth, $totalBytes - $bStart)
            $script:TocEngineUtf8.GetString($bytes, $bStart, $sliceLen)
        } else { '' }

        $charCount = $secText.Length
        $indentSpaces = '  ' * ([Math]::Max(0, [int]$curr.level - 2))

        $sections.Add([pscustomobject]@{
            level         = $curr.level
            level_tag     = "H$($curr.level)"
            title         = $curr.title
            anchor        = $curr.anchor
            byte_start    = $bStart
            byte_end      = $bEnd
            byte_width    = $bWidth
            char_count    = $charCount
            indent        = $indentSpaces
            relative_link = "$Slug.md#$($curr.anchor)"
        })
    }

    $header = [pscustomobject]@{
        slug          = $Slug
        title         = $title
        authors       = $authors
        doi           = $doi
        total_bytes   = $totalBytes
        section_count = $sections.Count
        source_file   = "$Slug.md"
        source_path   = if ($SourcePath) { $SourcePath.Replace('\', '/') } else { "$Slug.md" }
        generated_at  = [System.DateTime]::UtcNow.ToString('o')
    }

    return [pscustomobject]@{
        Header   = $header
        Sections = $sections
    }
}

# Refresh or insert in-doc ## Contents block in Markdown text
function Set-MdContentsBlock {
    param(
        [Parameter(Mandatory)][string]$MarkdownText,
        [string]$Slug = 'doc',
        [string]$TemplatePath = (Join-Path $PSScriptRoot 'templates/in-doc-contents.template.md')
    )
    if ([string]::IsNullOrWhiteSpace($MarkdownText)) { return $MarkdownText }
    $model = New-DeliverableTreeModel -MarkdownText $MarkdownText -Slug $Slug
    if ($model.Sections.Count -eq 0) { return $MarkdownText }

    $templateText = [System.IO.File]::ReadAllText($TemplatePath, $script:TocEngineUtf8)
    # ONE trailing newline, not two: the block is spliced in as LINES, so each trailing empty element
    # becomes another newline when the document is rejoined. "`n`n" here yields a triple break before
    # the first body heading.
    $blockText = (Expand-MdTemplate -TemplateText $templateText -Model $model).TrimEnd() + "`n"

    # Replace existing ## Contents block or insert before first H2
    $lines = [System.Collections.Generic.List[string]]::new([string[]]($MarkdownText -split "`n"))
    $inFence = $false; $start = -1; $end = -1; $firstH2 = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $ln = $lines[$i]
        if ($ln -match '^```') { $inFence = -not $inFence; continue }
        if ($inFence) { continue }
        if ($ln -match '^##\s+Contents\s*$') { if ($start -lt 0) { $start = $i }; continue }
        if ($ln -match '^##\s') {
            if ($start -ge 0 -and $end -lt 0) { $end = $i }
            if ($firstH2 -lt 0) { $firstH2 = $i }
        }
    }

    $blockLines = $blockText -split "`n"
    if ($start -ge 0) {
        $stop = if ($end -ge 0) { $end } else { $lines.Count }
        $lines.RemoveRange($start, $stop - $start)
        $lines.InsertRange($start, $blockLines)
    }
    elseif ($firstH2 -ge 0) {
        $lines.InsertRange($firstH2, $blockLines)
    }
    else { return $MarkdownText }

    return ($lines -join "`n")
}

# Export standalone Tree Manifest sidecar files ({slug}-tree.md and {slug}.toc.jsonl)
function Export-MdTreeSidecar {
    param(
        [Parameter(Mandatory)][string]$MarkdownPath,
        [Parameter(Mandatory)][string]$OutDir,
        [string]$TemplatePath = (Join-Path $PSScriptRoot 'templates/single-doc-tree.template.md'),
        [string]$Slug = '',
        [hashtable]$Metadata = @{},
        [switch]$DisableTreeToc,
        [switch]$DisableJsonlToc
    )
    if (-not (Test-Path -LiteralPath $MarkdownPath -PathType Leaf)) { return $null }
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    $srcPath = (Resolve-Path -LiteralPath $MarkdownPath).Path
    $fileName = Split-Path -Leaf $srcPath

    if ([string]::IsNullOrWhiteSpace($Slug)) {
        $Slug = $fileName -replace '(-latex)?\.md$', ''
    }

    $text = [System.IO.File]::ReadAllText($srcPath, $script:TocEngineUtf8)
    $model = New-DeliverableTreeModel -MarkdownText $text -Slug $Slug -Metadata $Metadata -SourcePath $srcPath

    $tocMdPath = $null
    if (-not $DisableTreeToc) {
        $templateText = [System.IO.File]::ReadAllText($TemplatePath, $script:TocEngineUtf8)
        $sidecarText = Expand-MdTemplate -TemplateText $templateText -Model $model
        $tocMdPath = Join-Path $OutDir "$Slug-tree.md"
        [System.IO.File]::WriteAllText($tocMdPath, $sidecarText, $script:TocEngineUtf8)
    }

    $tocJsonlPath = $null
    if (-not $DisableJsonlToc) {
        $jsonlLines = foreach ($s in $model.Sections) {
            [pscustomobject]@{
                level         = $s.level
                heading       = $s.title
                anchor        = $s.anchor
                byte_start    = $s.byte_start
                byte_end      = $s.byte_end
                byte_width    = $s.byte_width
                char_count    = $s.char_count
                relative_link = $s.relative_link
            } | ConvertTo-Json -Compress
        }
        $tocJsonlPath = Join-Path $OutDir "$Slug.toc.jsonl"
        [System.IO.File]::WriteAllText($tocJsonlPath, ($jsonlLines -join "`n") + "`n", $script:TocEngineUtf8)
    }

    return [pscustomobject]@{
        toc_md    = $tocMdPath
        toc_jsonl = $tocJsonlPath
        entries   = $model.Sections.Count
    }
}
