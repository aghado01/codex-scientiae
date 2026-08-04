#requires -Version 7.0
<#
  src/latex-ingest/docstream.ps1 — the docstream, the latex refgraph, and their composition.

  Three layers, deliberately separate (user semantics: STREAM + REFGRAPH -> DOC GRAPH):

    DOCSTREAM   the NODE set: the latent manuscript linearized — spine rows (title/section/
                subsection/theorem-kinds/proof/appendix), prose rows at paragraph grain, and
                channel rows (math/verb/alg/figure/table/diagram/barrier) in reading order,
                each with seq / addr (kind:kind_index) / parent. Structural edges (containment,
                reading order) ride implicitly in the addressing.
    REFGRAPH    the source-side reference MACHINERY, kept LaTeX-flavored: label declarations,
                reference sites as rendered, per-site/target resolution, and the danglers
                classified by cause (bib-missing / declared-unmapped / undeclared). This is the
                relationship-sort evidence of the surjection — no stream joins baked in, and it
                is the layer where dangler cleanup happens (e.g. the algorithm-label counter).
    DOC GRAPH   the DERIVED composition: stream nodes (+ bib entries as auxiliary nodes) with
                referential edges obtained by resolving refgraph sites onto stream addresses.
                The realized instantiation of the protograph for this document — assembled,
                never independently scanned. tex-docgraph's name retires into this meaning.

  Consumed by ConvertFrom-Latex (production tail + probe return) and the probe driver.
#>

# --- slot grammar: one regex for every marker family; em-dash built explicitly (codepoint-safe) -----
$script:DocstreamEmDash = [string][char]0x2014
$script:DocstreamRx = [regex]('@@(LMATH|LDISP|ALG|VERB|FIGENV|TABENV|BARRIER|APPENDIX|SPINEEND|SPINE)(\d+)@@|\*\[diagram (\d+) ' + $script:DocstreamEmDash + ' ([^,\]]+), not rendered\]\*')

# content lookup for any marker, across every store family. $S is the store bag:
# @{ math; algs; verbs; figures; tables; diagrams; barriers; appendix; spine }
function Get-DocstreamSlotContent {
    param($S, [System.Text.RegularExpressions.Match]$M)
    if ($M.Groups[1].Success) {
        $kind = $M.Groups[1].Value
        $content = $null
        switch ($kind) {
            'LMATH' { if ($S.math.ContainsKey($M.Value)) { $content = [string]$S.math[$M.Value] } }
            'LDISP' { if ($S.math.ContainsKey($M.Value)) { $content = [string]$S.math[$M.Value] } }
            'ALG' { if ($S.algs.ContainsKey($M.Value)) { $content = [string]$S.algs[$M.Value] } }
            'VERB' { if ($S.verbs.ContainsKey($M.Value)) { $content = [string]$S.verbs[$M.Value] } }
            'FIGENV' { $i = [int]$M.Groups[2].Value; if ($i -lt $S.figures.Count) { $content = [string]$S.figures[$i].source } }
            'TABENV' { $i = [int]$M.Groups[2].Value; if ($i -lt $S.tables.Count) { $content = [string]$S.tables[$i].source } }
            'BARRIER' { $i = [int]$M.Groups[2].Value; if ($i -lt $S.barriers.Count) { $content = '\' + [string]$S.barriers[$i].via } }
            'APPENDIX' { $i = [int]$M.Groups[2].Value; if ($i -lt $S.appendix.Count) { $content = '\appendix' } }
            'SPINE' { $i = [int]$M.Groups[2].Value; if ($i -lt $S.spine.Count) { $content = [string]$S.spine[$i].title } }
            'SPINEEND' { $content = '' }
        }
        return @{ kind = $kind; marker = $M.Value; content = $content }
    }
    $dn = [int]$M.Groups[3].Value
    $content = $null
    foreach ($d in $S.diagrams) { if ($d.n -eq $dn) { $content = [string]$d.source; break } }
    return @{ kind = 'DIAGRAM'; marker = $M.Value; content = $content }
}

# --- the docstream builder: one structural walk over the assembled (marker-laden) body --------------
function Build-LatexDocstream {
    param([string]$Body, $S)
    $rows = [System.Collections.Generic.List[object]]::new()
    # mutable walk state in one bag (inner mutation through the bag survives PS dynamic scoping)
    $w = @{
        kindIdx = [System.Collections.Generic.Dictionary[string, int]]::new([System.StringComparer]::Ordinal)
        seq = 0; prev = 0; sec2 = $null; sec3 = $null; sec4 = $null
        curSecSym = $null; absorbInto = $null
        thmStack = [System.Collections.Generic.List[object]]::new()
        inlineBuf = [System.Collections.Generic.List[System.Text.RegularExpressions.Match]]::new()
    }
    function New-DsAddr([string]$Kind) {
        if (-not $w.kindIdx.ContainsKey($Kind)) { $w.kindIdx[$Kind] = 0 }
        $a = "${Kind}:$($w.kindIdx[$Kind])"; $w.kindIdx[$Kind]++
        return $a
    }
    function Add-DsRow($row) {
        $row.seq = $w.seq; $w.seq++
        $rows.Add($row)
    }
    function Get-DsContainer {
        if ($w.thmStack.Count -gt 0) { return $w.thmStack[$w.thmStack.Count - 1].addr }
        if ($null -ne $w.sec4) { return $w.sec4 }
        if ($null -ne $w.sec3) { return $w.sec3 }
        if ($null -ne $w.sec2) { return $w.sec2 }
        return 'title:0'
    }
    function Get-DsSectionLevel { if ($null -ne $w.sec4) { 4 } elseif ($null -ne $w.sec3) { 3 } elseif ($null -ne $w.sec2) { 2 } else { 1 } }
    function Get-DsRegimeSymbol([string]$Regime, $Ordinal) {
        if ($null -eq $Ordinal) { return $null }
        if ($Regime -eq 'Alph' -and $Ordinal -ge 1 -and $Ordinal -le 26) { return [string][char](64 + [int]$Ordinal) }
        return "$Ordinal"
    }
    function Get-DsFaithful($Sp) {
        $n = [string]$Sp.number
        if ($Sp.mode -ne 'appendix' -or -not $n) { return $n }
        if ($Sp.kind -eq 'section') { return (Get-DsRegimeSymbol $Sp.regime $Sp.ordinal) }
        if ($null -ne $w.curSecSym -and $n -match '^\d+\.') { return ($n -replace '^\d+', $w.curSecSym) }
        return $n
    }
    function Add-DsProse([int]$UpTo) {
        $segStart = $w.prev
        $seg = $Body.Substring($segStart, $UpTo - $segStart)
        $lead = $seg.Length - $seg.TrimStart("`r", "`n", ' ').Length
        $seg = $seg.Trim("`r", "`n", ' ')
        $segStart += $lead
        if ($seg.Length -gt 0 -and $null -ne $w.absorbInto) {
            # the heading line our own emission renders for this section belongs to its spine row
            $hm = [regex]::Match($seg, '^(#{2,6}[^\r\n]*)(\r?\n+|$)')
            if ($hm.Success) {
                $w.absorbInto.content = $hm.Groups[1].Value
                $seg = $seg.Substring($hm.Length); $segStart += $hm.Length
                $lead2 = $seg.Length - $seg.TrimStart("`r", "`n").Length
                $seg = $seg.TrimStart("`r", "`n"); $segStart += $lead2
            }
        }
        if ($seg.Length -gt 0) {
            # paragraph grain: one prose row per blank-line-separated block; inline slots attach
            # to the paragraph whose span contains their marker
            $cuts = @([regex]::Matches($seg, '(?:\r?\n){2,}'))
            $pPos = 0
            for ($ci = 0; $ci -le $cuts.Count; $ci++) {
                $pEnd = if ($ci -lt $cuts.Count) { $cuts[$ci].Index } else { $seg.Length }
                if ($pEnd -gt $pPos) {
                    $pText = $seg.Substring($pPos, $pEnd - $pPos)
                    $pStart = $segStart + $pPos
                    if ($pText.Trim().Length -gt 0) {
                        $pAddr = New-DsAddr 'prose'
                        $kids = [System.Collections.Generic.List[string]]::new()
                        foreach ($im in $script:DocstreamRx.Matches($pText)) { $kids.Add($im.Value) }
                        Add-DsRow ([ordered]@{
                                seq = 0; addr = $pAddr; kind = 'prose'; parent = (Get-DsContainer)
                                char_offset = $pStart; char_count = $pText.Length; content = $pText; children = @($kids) })
                        foreach ($im in $w.inlineBuf) {
                            if ($im.Index -ge $pStart -and $im.Index -lt ($pStart + $pText.Length)) {
                                $rec = Get-DocstreamSlotContent $S $im
                                Add-DsRow ([ordered]@{
                                        seq = 0; addr = (New-DsAddr $rec.kind.ToLowerInvariant()); kind = $rec.kind; parent = $pAddr
                                        char_offset = $im.Index; marker = $rec.marker; content = $rec.content })
                            }
                        }
                    }
                }
                if ($ci -lt $cuts.Count) { $pPos = $cuts[$ci].Index + $cuts[$ci].Length }
            }
        }
        $w.inlineBuf.Clear()
        $w.absorbInto = $null
        $w.prev = $UpTo
    }

    # title row owns the H1 line
    $nl = $Body.IndexOf("`n"); if ($nl -lt 0) { $nl = $Body.Length }
    $null = New-DsAddr 'title'
    Add-DsRow ([ordered]@{
            seq = 0; addr = 'title:0'; kind = 'title'; level = 1; parent = $null
            char_offset = 0; content = $Body.Substring(0, $nl); marker = $null })
    $w.prev = [Math]::Min($nl + 1, $Body.Length)

    $bodyMatches = $script:DocstreamRx.Matches($Body)
    foreach ($m in $bodyMatches) {
        if ($m.Index -lt $w.prev) { continue }
        $fam = if ($m.Groups[1].Success) { $m.Groups[1].Value } else { 'DIAGRAM' }
        if ($fam -eq 'LMATH') { [void]$w.inlineBuf.Add($m); continue }
        if ($fam -eq 'VERB') {
            # VERB carries two grains: block fences interleave as rows; inline \verb spans ride
            # inside their paragraph like inline math
            $vrec = Get-DocstreamSlotContent $S $m
            if ($null -ne $vrec.content -and -not $vrec.content.StartsWith('``' + '`')) { [void]$w.inlineBuf.Add($m); continue }
        }
        Add-DsProse $m.Index
        switch ($fam) {
            'SPINEEND' {
                if ($w.thmStack.Count -gt 0) {
                    $top = $w.thmStack[$w.thmStack.Count - 1]
                    $w.thmStack.RemoveAt($w.thmStack.Count - 1)
                    $top.row.end_offset = $m.Index
                }
            }
            'SPINE' {
                $n = [int]$m.Groups[2].Value
                $sp = $S.spine[$n]
                $spKind = ([string]$sp.kind).ToLowerInvariant()
                if ($spKind -in 'section', 'subsection', 'subsubsection') {
                    foreach ($t in $w.thmStack) { $t.row.end_offset = $m.Index }   # unclosed envs end at the next section
                    $w.thmStack.Clear()
                    $level = switch ($spKind) { 'section' { 2 } 'subsection' { 3 } default { 4 } }
                    $parent = switch ($level) { 2 { 'title:0' } 3 { $w.sec2 ?? 'title:0' } default { $w.sec3 ?? $w.sec2 ?? 'title:0' } }
                    $addr = New-DsAddr $spKind
                    $faithful = Get-DsFaithful $sp
                    if ($level -eq 2) { $w.curSecSym = $faithful }
                    $row = [ordered]@{
                        seq = 0; addr = $addr; kind = $spKind; level = $level; parent = $parent
                        number = [string]$sp.number; mode = [string]$sp.mode; ordinal = $sp.ordinal; regime = [string]$sp.regime
                        faithful = $faithful
                        title = [string]$sp.title; label = $sp.label; star = [bool]$sp.star
                        char_offset = $m.Index; marker = $m.Value; content = $null }
                    Add-DsRow $row
                    if ($level -eq 2) { $w.sec2 = $addr; $w.sec3 = $null; $w.sec4 = $null }
                    elseif ($level -eq 3) { $w.sec3 = $addr; $w.sec4 = $null }
                    else { $w.sec4 = $addr }
                    $w.absorbInto = $row
                }
                else {
                    $parent = Get-DsContainer
                    $level = (Get-DsSectionLevel) + 1
                    $addr = New-DsAddr $spKind
                    $row = [ordered]@{
                        seq = 0; addr = $addr; kind = $spKind; level = $level; parent = $parent
                        number = [string]$sp.number; mode = [string]$sp.mode; ordinal = $sp.ordinal; regime = [string]$sp.regime
                        faithful = (Get-DsFaithful $sp)
                        title = [string]$sp.title; label = $sp.label; star = [bool]$sp.star
                        char_offset = $m.Index; marker = $m.Value; content = $null; end_offset = $null }
                    Add-DsRow $row
                    $w.thmStack.Add(@{ n = $n; addr = $addr; row = $row })
                }
            }
            'APPENDIX' {
                Add-DsRow ([ordered]@{
                        seq = 0; addr = (New-DsAddr 'appendix'); kind = 'appendix'; level = 2; parent = 'title:0'
                        char_offset = $m.Index; marker = $m.Value; content = '\appendix' })
            }
            default {
                $rec = Get-DocstreamSlotContent $S $m
                $kids = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
                if ($null -ne $rec.content) {
                    foreach ($cm in $script:DocstreamRx.Matches($rec.content)) { [void]$kids.Add($cm.Value) }
                }
                $row = [ordered]@{
                    seq = 0; addr = (New-DsAddr $fam.ToLowerInvariant()); kind = $rec.kind; parent = (Get-DsContainer)
                    char_offset = $m.Index; marker = $rec.marker; content = $rec.content; children = @($kids) }
                if ($rec.kind -in 'FIGENV', 'TABENV') {
                    $fi = [int]$m.Groups[2].Value
                    $fstore = if ($rec.kind -eq 'FIGENV') { $S.figures } else { $S.tables }
                    $row.spec = if ($fi -lt $fstore.Count) { $fstore[$fi].spec } else { $null }
                    $lm = if ($null -ne $rec.content) { [regex]::Match($rec.content, '\\label\{([^{}]*)\}') } else { $null }
                    $row.label = if ($null -ne $lm -and $lm.Success) { $lm.Groups[1].Value } else { $null }
                }
                elseif ($rec.kind -eq 'BARRIER') {
                    $bi = [int]$m.Groups[2].Value
                    $row.via = if ($bi -lt $S.barriers.Count) { $S.barriers[$bi].via } else { $null }
                }
                Add-DsRow $row
            }
        }
        $w.prev = $m.Index + $m.Length
    }
    Add-DsProse $Body.Length
    return , $rows
}

# --- the latex refgraph: reference machinery + resolution + classified danglers ---------------------
function Build-LatexRefGraph {
    param($RefModel, $CiteMap, $AllLabels)
    $mapped = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($l in $RefModel.labels) { [void]$mapped.Add([string]$l.label) }
    $edges = [System.Collections.Generic.List[object]]::new()
    $danglers = [System.Collections.Generic.List[object]]::new()
    $classCount = [ordered]@{ 'bib-missing' = 0; 'declared-unmapped' = 0; 'undeclared' = 0 }
    $si = 0
    foreach ($s in $RefModel.sites) {
        foreach ($t in @($s.targets)) {
            $t = ([string]$t).Trim()
            if (-not $t) { continue }
            $isCite = ([string]$s.macro -eq 'cite')
            $resolved = if ($isCite) { $CiteMap.ContainsKey($t) } else { $mapped.Contains($t) }
            $edge = [ordered]@{
                site = $si; macro = [string]$s.macro; target = $t
                target_kind = $(if ($isCite) { 'bib' } else { 'label' })
                resolved = [bool]$resolved; rendered = [string]$s.rendered
            }
            if ($isCite) {
                if ($s.prenote) { $edge.prenote = [string]$s.prenote }
                if ($s.postnote) { $edge.postnote = [string]$s.postnote }   # the pointer INTO the cited work ("Theorem 3.1") — data, not lost prose
            }
            if (-not $resolved) {
                $cls = if ($isCite) { 'bib-missing' }
                elseif ($AllLabels -and $AllLabels.Contains($t)) { 'declared-unmapped' }   # the CONVERTER class — fix by teaching a map
                else { 'undeclared' }                                                     # author error / typo
                $edge.dangler_class = $cls
                $classCount[$cls] = [int]$classCount[$cls] + 1
                $danglers.Add($edge)
            }
            $edges.Add($edge)
            $si++
        }
    }
    return @{
        labels = $RefModel.labels
        sites = $RefModel.sites
        edges = $edges
        danglers = $danglers
        stats = [ordered]@{
            labels = $RefModel.labels.Count; sites = $RefModel.sites.Count; edges = $edges.Count
            resolved = ($edges.Count - $danglers.Count); dangling = $danglers.Count
            dangler_classes = $classCount
        }
    }
}

# --- the doc graph: stream nodes + refgraph edges resolved onto addresses ---------------------------
function Build-LatexDocGraph {
    param($Rows, $RefGraph, $CiteMap)
    # label -> node addr (spine rows and float bundles carry labels; equation labels are stripped
    # before math capture — a known entanglement — so eq targets stay unanchored for now)
    $addrByLabel = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $nodes = [System.Collections.Generic.List[object]]::new()
    foreach ($r in $Rows) {
        $lbl = $null
        if ($r.Contains('label') -and $r.label) { $lbl = [string]$r.label; if (-not $addrByLabel.ContainsKey($lbl)) { $addrByLabel[$lbl] = [string]$r.addr } }
        $n = [ordered]@{ addr = [string]$r.addr; kind = [string]$r.kind; parent = $r.parent; seq = [int]$r.seq }
        if ($lbl) { $n.label = $lbl }
        foreach ($f in 'number', 'faithful', 'title', 'level') { if ($r.Contains($f) -and $null -ne $r[$f] -and '' -ne $r[$f]) { $n[$f] = $r[$f] } }
        $nodes.Add($n)
    }
    foreach ($k in $CiteMap.Keys) {
        $nodes.Add([ordered]@{ addr = "bib:$k"; kind = 'bib'; parent = $null; seq = -1; number = [string]$CiteMap[$k] })
    }
    $edges = [System.Collections.Generic.List[object]]::new()
    foreach ($e in $RefGraph.edges) {
        $to = if ($e.target_kind -eq 'bib') { "bib:$($e.target)" }
        elseif ($addrByLabel.ContainsKey($e.target)) { $addrByLabel[$e.target] }
        else { "label:$($e.target)" }   # mapped-but-unanchored (equations) or dangling
        $edge = [ordered]@{
            site = $e.site; macro = $e.macro
            from = $null   # site anchoring onto its containing node = a later increment; site order preserves reading position
            to = $to; anchored = ($e.target_kind -eq 'bib' -or $addrByLabel.ContainsKey($e.target))
            resolved = $e.resolved; rendered = $e.rendered
        }
        if ($e.Contains('postnote')) { $edge.postnote = $e.postnote }
        if ($e.Contains('prenote')) { $edge.prenote = $e.prenote }
        if ($e.Contains('dangler_class')) { $edge.dangler_class = $e.dangler_class }
        $edges.Add($edge)
    }
    return @{
        nodes = $nodes; edges = $edges
        stats = [ordered]@{
            nodes = $nodes.Count; edges = $edges.Count
            anchored = @($edges | Where-Object { $_.anchored }).Count
            resolved = @($edges | Where-Object { $_.resolved }).Count
        }
    }
}
