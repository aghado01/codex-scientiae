#requires -Version 7.0
<#
  src/latex-ingest/tex-docgraph.ps1 — the document's typed reference graph, captured upstream of surjection.

  Cross-reference machinery is typesetting furniture: cleveref's \cref generates its type name
  ("theorem 2.17") from the TARGET LABEL'S ENVIRONMENT at typeset time, so the type lives in the
  source structure, not in the reference site. Lowering the manuscript toward the math register
  destroys that binding. This pass captures it FIRST — before anything is surjected — and persists it
  out-of-band, the same discipline latex-math-store.ps1 applies to math-lowering evidence.

  Nothing from this pass renders into the manuscript. It emits {slug}.docgraph.jsonl into the run dir:
  one record per labeled object (kind=node), one per reference site (kind=edge).

  Numbering ("2.17") is deliberately NOT computed here — that requires simulating LaTeX counters. The
  graph binds label -> type -> location; numbers are a rendering concern and can be joined later from
  either the converter's own counter or the emitted markdown's result headers.
#>

$script:DocGraphUtf8 = [System.Text.UTF8Encoding]::new($false)
$script:DocGraphStoreCache = $null

<#
  Which environments name an equation, which sectioning commands exist, and which environments are
  transparent to label resolution are all CUES, not logic — they vary with the source's package set and
  a paper's own conventions. They live in stores/docgraph.json (rules-as-data, same discipline as
  latex-math-store.ps1) so widening coverage is a data edit, not a code edit.

  A missing or malformed store THROWS: silently defaulting would classify every label under
  \begin{document} and produce a graph that looks populated while being uniformly wrong.
#>
function Get-DocGraphStore {
    if ($null -ne $script:DocGraphStoreCache) { return $script:DocGraphStoreCache }
    $storePath = Join-Path $PSScriptRoot 'stores/docgraph.json'
    if (-not (Test-Path -LiteralPath $storePath -PathType Leaf)) { throw "docgraph store not found: $storePath" }
    $records = [System.IO.File]::ReadAllText($storePath, $script:DocGraphUtf8) | ConvertFrom-Json

    $byId = @{}
    foreach ($r in $records) {
        if ([string]::IsNullOrWhiteSpace($r.id)) { throw "docgraph store: a record is missing its 'id' ($storePath)" }
        if ($null -eq $r.names) { throw "docgraph store: record '$($r.id)' is missing 'names' ($storePath)" }
        $byId[$r.id] = @($r.names)
    }
    foreach ($required in 'math_environments', 'sectioning_commands', 'transparent_environments') {
        if (-not $byId.ContainsKey($required)) { throw "docgraph store: missing required record '$required' ($storePath)" }
    }

    $script:DocGraphStoreCache = [pscustomobject]@{
        math_environments        = $byId['math_environments']
        sectioning_commands      = $byId['sectioning_commands']
        transparent_environments = $byId['transparent_environments']
    }
    return $script:DocGraphStoreCache
}

# Index of the '}' matching the '{' at $Open, or -1 when unbalanced. Brace-aware so nested arguments
# (a \cref inside a \subsection title) do not truncate the scan the way [^}]* would.
function Get-TexBraceEnd([string]$Text, [int]$Open) {
    if ($Open -lt 0 -or $Open -ge $Text.Length -or $Text[$Open] -ne '{') { return -1 }
    $depth = 0
    for ($i = $Open; $i -lt $Text.Length; $i++) {
        $c = $Text[$i]
        if ($c -eq '\') { $i++; continue }   # skip escaped char, incl. \{ \}
        if ($c -eq '{') { $depth++ }
        elseif ($c -eq '}') {
            $depth--
            if ($depth -eq 0) { return $i }
        }
    }
    return -1
}

# Stack-matched \begin{env}...\end{env} spans, innermost-resolvable. Unbalanced \end is ignored;
# unclosed \begin is dropped at EOF rather than swallowing the remainder of the file.
function Get-TexEnvIntervals([string]$Text) {
    $out = [System.Collections.Generic.List[object]]::new()
    $stack = [System.Collections.Generic.List[object]]::new()
    foreach ($m in [regex]::Matches($Text, '\\(begin|end)\s*\{([^}]+)\}')) {
        $kind = $m.Groups[1].Value
        $name = $m.Groups[2].Value.Trim().TrimEnd('*')
        if ($kind -eq 'begin') {
            $stack.Add([pscustomobject]@{ name = $name; start = $m.Index })
            continue
        }
        for ($i = $stack.Count - 1; $i -ge 0; $i--) {
            if ($stack[$i].name -eq $name) {
                $out.Add([pscustomobject]@{
                    name  = $name
                    start = $stack[$i].start
                    end   = $m.Index + $m.Length
                })
                $stack.RemoveRange($i, $stack.Count - $i)
                break
            }
        }
    }
    return $out
}

# Sectioning commands with brace-matched titles, so titles containing macros survive intact.
function Get-TexSections([string]$Text) {
    $out = [System.Collections.Generic.List[object]]::new()
    $pattern = '\\(' + ((Get-DocGraphStore).sectioning_commands -join '|') + ')\*?\s*\{'
    foreach ($m in [regex]::Matches($Text, $pattern)) {
        $open = $Text.IndexOf('{', $m.Index)
        $close = Get-TexBraceEnd $Text $open
        if ($close -lt 0) { continue }
        $out.Add([pscustomobject]@{
            level      = $m.Groups[1].Value
            start      = $m.Index
            title_end  = $close
            title      = $Text.Substring($open + 1, $close - $open - 1).Trim()
        })
    }
    return $out
}

# Innermost MEANINGFUL environment span containing $Offset, or $null. Transparent wrappers are skipped
# so a label resolves to the object it names, not to the container that happens to bracket it tightest.
function Get-TexInnermostEnv($Intervals, [int]$Offset) {
    $transparent = (Get-DocGraphStore).transparent_environments
    $best = $null
    foreach ($iv in $Intervals) {
        if ($transparent -contains $iv.name) { continue }
        if ($Offset -ge $iv.start -and $Offset -lt $iv.end) {
            if ($null -eq $best -or ($iv.end - $iv.start) -lt ($best.end - $best.start)) { $best = $iv }
        }
    }
    return $best
}

# Last sectioning command starting before $Offset, or $null.
function Get-TexOwningSection($Sections, [int]$Offset) {
    $best = $null
    foreach ($s in $Sections) {
        if ($s.start -le $Offset -and ($null -eq $best -or $s.start -gt $best.start)) { $best = $s }
    }
    return $best
}

# A label is a SECTION label when it sits inside the sectioning title's braces or follows the closing
# brace across whitespace only — the standard \subsection{...}\label{...} idiom. A label further into
# the body belongs to the section but does not name it.
function Test-TexSectionLabel([string]$Text, $Section, [int]$LabelOffset) {
    if ($null -eq $Section) { return $false }
    if ($LabelOffset -gt $Section.start -and $LabelOffset -lt $Section.title_end) { return $true }
    if ($LabelOffset -lt $Section.title_end) { return $false }
    $gap = $Text.Substring($Section.title_end + 1, [Math]::Max(0, $LabelOffset - $Section.title_end - 1))
    return ($gap.Trim().Length -eq 0)
}

<#
  Build the typed graph over a directory of .tex sources.

  Returns { nodes; edges; stats }. Nodes are keyed by label; edges carry the reference macro verbatim
  so the downstream surjection can decide per-macro what to do, rather than this pass pre-judging it.
#>
function Get-TexDocGraph {
    param(
        [Parameter(Mandatory)][string]$TexDir,
        [string]$Slug = ''
    )
    if (-not (Test-Path -LiteralPath $TexDir -PathType Container)) { throw "tex dir not found: $TexDir" }

    $mathEnvs = (Get-DocGraphStore).math_environments
    $nodes = [System.Collections.Generic.List[object]]::new()
    $edges = [System.Collections.Generic.List[object]]::new()
    $seenLabels = [System.Collections.Generic.HashSet[string]]::new()

    $files = @(Get-ChildItem -LiteralPath $TexDir -Filter '*.tex' -File | Sort-Object Name)
    foreach ($f in $files) {
        $text = [System.IO.File]::ReadAllText($f.FullName, $script:DocGraphUtf8)
        $envs = Get-TexEnvIntervals $text
        $secs = Get-TexSections $text

        # --- nodes: every \label{} bound to whatever declares it ---
        foreach ($m in [regex]::Matches($text, '\\label\s*\{([^}]+)\}')) {
            $key = $m.Groups[1].Value.Trim()
            if (-not $seenLabels.Add($key)) { continue }   # first definition wins; duplicates reported in stats

            $env = Get-TexInnermostEnv $envs $m.Index
            $sec = Get-TexOwningSection $secs $m.Index

            $type = $null
            $class = $null
            if ($null -ne $env) {
                $type = $env.name
                $class = if ($mathEnvs -contains $env.name) { 'equation' } else { 'environment' }
            }
            elseif (Test-TexSectionLabel $text $sec $m.Index) {
                $type = $sec.level
                $class = 'section'
            }
            else {
                $type = 'unclassified'
                $class = 'unclassified'
            }

            $nodes.Add([pscustomobject]@{
                kind        = 'node'
                label       = $key
                type        = $type
                class       = $class
                source_file = $f.Name
                char_offset = $m.Index
                in_section  = if ($null -ne $sec) { $sec.title } else { '' }
            })
        }

        # --- edges: every reference site, macro preserved ---
        $refRx = '(?<![A-Za-z])\\(cref|Cref|cpageref|autoref|nameref|eqref|pageref|ref)\s*\{([^}]+)\}'
        foreach ($m in [regex]::Matches($text, $refRx)) {
            $macro = $m.Groups[1].Value
            $env = Get-TexInnermostEnv $envs $m.Index
            $sec = Get-TexOwningSection $secs $m.Index
            $fromCtx = if ($null -ne $env) { $env.name } elseif ($null -ne $sec) { $sec.level } else { '' }
            $inTitle = ($null -ne $sec -and $m.Index -gt $sec.start -and $m.Index -lt $sec.title_end)

            foreach ($raw in $m.Groups[2].Value.Split(',')) {
                $target = $raw.Trim()
                if ($target.Length -eq 0) { continue }
                $edges.Add([pscustomobject]@{
                    kind         = 'edge'
                    macro        = $macro
                    target       = $target
                    from_context = $fromCtx
                    in_heading   = $inTitle
                    source_file  = $f.Name
                    char_offset  = $m.Index
                })
            }
        }
    }

    # --- resolution + tallies ---
    $byLabel = @{}
    foreach ($n in $nodes) { $byLabel[$n.label] = $n }

    $nodeTypes = @{}
    foreach ($n in $nodes) {
        if ($nodeTypes.ContainsKey($n.type)) { $nodeTypes[$n.type]++ } else { $nodeTypes[$n.type] = 1 }
    }

    $macroTally = @{}
    $dangling = [System.Collections.Generic.List[string]]::new()
    $inHeading = 0
    foreach ($e in $edges) {
        if ($macroTally.ContainsKey($e.macro)) { $macroTally[$e.macro]++ } else { $macroTally[$e.macro] = 1 }
        if (-not $byLabel.ContainsKey($e.target)) { $dangling.Add($e.target) }
        if ($e.in_heading) { $inHeading++ }
    }

    # resolved type per edge, once nodes are known — this is the evidence the surjection needs
    foreach ($e in $edges) {
        $t = if ($byLabel.ContainsKey($e.target)) { $byLabel[$e.target].type } else { '<dangling>' }
        $c = if ($byLabel.ContainsKey($e.target)) { $byLabel[$e.target].class } else { '<dangling>' }
        $e | Add-Member -NotePropertyName 'target_type' -NotePropertyValue $t
        $e | Add-Member -NotePropertyName 'target_class' -NotePropertyValue $c
    }

    $stats = [pscustomobject]@{
        slug             = $Slug
        tex_files        = $files.Count
        node_count       = $nodes.Count
        edge_count       = $edges.Count
        node_types       = $nodeTypes
        ref_macros       = $macroTally
        edges_in_heading = $inHeading
        dangling_targets = @($dangling | Sort-Object -Unique)
        generated_at     = [System.DateTime]::UtcNow.ToString('o')
    }

    return [pscustomobject]@{ nodes = $nodes; edges = $edges; stats = $stats }
}

<#
  Persist the graph as a build artifact in the run dir. JSONL with a `kind` discriminator so the
  jso-jackson tooling can stream it; a sibling .stats.json holds the tallies for quick inspection.
#>
function Export-TexDocGraph {
    param(
        [Parameter(Mandatory)][string]$TexDir,
        [Parameter(Mandatory)][string]$OutDir,
        [string]$Slug = ''
    )
    if ([string]::IsNullOrWhiteSpace($Slug)) { $Slug = Split-Path -Leaf (Split-Path -Parent $TexDir) }
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

    $graph = Get-TexDocGraph -TexDir $TexDir -Slug $Slug

    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($n in $graph.nodes) { $lines.Add(($n | ConvertTo-Json -Compress -Depth 6)) }
    foreach ($e in $graph.edges) { $lines.Add(($e | ConvertTo-Json -Compress -Depth 6)) }

    $graphPath = Join-Path $OutDir "$Slug.docgraph.jsonl"
    [System.IO.File]::WriteAllText($graphPath, (($lines -join "`n") + "`n"), $script:DocGraphUtf8)

    $statsPath = Join-Path $OutDir "$Slug.docgraph.stats.json"
    [System.IO.File]::WriteAllText($statsPath, ($graph.stats | ConvertTo-Json -Depth 6), $script:DocGraphUtf8)

    return [pscustomobject]@{
        docgraph = $graphPath
        stats    = $statsPath
        nodes    = $graph.nodes.Count
        edges    = $graph.edges.Count
    }
}
