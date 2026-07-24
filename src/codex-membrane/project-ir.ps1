#requires -Version 7.0
<#
  src/codex-membrane/project-ir.ps1 — project a Docling / opendataloader JSON IR into ordered node-JSONL.

  Walks the nested struct tree, lifts every typed node into a flat record in
  document order, and emits node-JSONL + .jidx + .sig through the jsonl substrate.

  Schema-aware: canonical fields are resolved through an alias map (discover the
  source key, don't assume it), and the distinct raw keys seen are reported — so an
  opendataloader schema change surfaces as a missing alias rather than a silent null.

    . ./project-ir.ps1
    Invoke-ProjectIr -JsonPath <docling.json> -OutputPath <nodes.jsonl>
#>

. "$PSScriptRoot/../jsonl.ps1"

# canonical field  <-  candidate source keys (first present wins)
$script:CanonicalKeys = [ordered]@{
    page          = @('page number', 'page', 'pageNumber')
    level         = @('level')
    heading_level = @('heading level', 'heading_level')
    font          = @('font')
    font_size     = @('font size', 'font_size')
    bbox          = @('bounding box', 'bbox')
    content       = @('content', 'text')
}

function Resolve-CanonicalField($Node, $Candidates) {
    foreach ($c in $Candidates) {
        $p = $Node.PSObject.Properties[$c]
        if ($null -ne $p) { return $p.Value }
    }
    return $null
}

function Add-IrNodes {
    param(
        $Node,
        [System.Collections.Generic.List[object]]   $Nodes,
        [System.Collections.Generic.HashSet[string]] $RawKeys
    )
    if ($Node -is [string]) { return }
    if ($Node -is [System.Collections.IEnumerable]) {
        foreach ($i in $Node) { Add-IrNodes -Node $i -Nodes $Nodes -RawKeys $RawKeys }
        return
    }
    if ($Node -is [System.Management.Automation.PSCustomObject]) {
        if ($null -ne $Node.PSObject.Properties['type']) {
            foreach ($p in $Node.PSObject.Properties) { [void]$RawKeys.Add($p.Name) }
            $rec = [ordered]@{ id = $Nodes.Count; type = [string]$Node.type }
            foreach ($ck in $script:CanonicalKeys.Keys) {
                $rec[$ck] = Resolve-CanonicalField $Node $script:CanonicalKeys[$ck]
            }
            $Nodes.Add([pscustomobject]$rec)
        }
        foreach ($p in $Node.PSObject.Properties) {
            Add-IrNodes -Node $p.Value -Nodes $Nodes -RawKeys $RawKeys
        }
    }
}

function Invoke-ProjectIr {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $JsonPath,
        [Parameter(Mandatory)] [string] $OutputPath
    )

    $doc     = [System.IO.File]::ReadAllText($JsonPath, [System.Text.UTF8Encoding]::new($false)) | ConvertFrom-Json   # .NET read: BOM-tolerant decode, no provider encoding ambiguity on external IR
    $nodes   = [System.Collections.Generic.List[object]]::new()
    $rawKeys = [System.Collections.Generic.HashSet[string]]::new()

    Add-IrNodes -Node $doc -Nodes $nodes -RawKeys $rawKeys

    $manifest = Write-JsonlStage -Records $nodes.ToArray() -OutputPath $OutputPath `
                                 -SourcePath $JsonPath -Stage 'project-ir'

    "$($nodes.Count) nodes -> $OutputPath  (+ .jidx, .sig)"
    "raw keys seen: $(($rawKeys | Sort-Object) -join ', ')"
    "--- canonical schema (coverage) ---"
    Get-JsonlSchema -Path $OutputPath | Format-Table -AutoSize
    return $manifest
}
