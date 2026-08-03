#requires -Version 7.0
<#
  src/latex-ingest/latex-math-store.ps1 — Store-driven LaTeX math register lowering & out-of-band evidence tracking.

  Loads store files from `src/latex-ingest/stores/`:
  - `evidence.json`: Source evidence rules for TeX input parsing (\operatorname, \parbox, etc.)
  - `aliases.json`: TeX command alias surjection mappings
  - `unicode-glyphs.json`: Unicode codepoint to LaTeX command mappings
  - `furniture.json`: Presentation furniture stripping patterns

  Interprets TeX typesetting constructs as upstream source evidence before lowering them into the canonical
  target math register. Out-of-band evidence is recorded into an evidence ledger without cluttering the target manuscript.
#>

$script:LatexStoreUtf8 = [System.Text.UTF8Encoding]::new($false)
$script:LatexStoreDataCache = $null

function Get-LatexMathStore {
    if ($null -ne $script:LatexStoreDataCache) { return $script:LatexStoreDataCache }
    $storesDir = Join-Path $PSScriptRoot 'stores'
    $evidenceFile  = Join-Path $storesDir 'evidence.json'
    $aliasesFile   = Join-Path $storesDir 'aliases.json'
    $glyphsFile    = Join-Path $storesDir 'unicode-glyphs.json'
    $furnitureFile = Join-Path $storesDir 'furniture.json'

    $evidence  = if (Test-Path -LiteralPath $evidenceFile -PathType Leaf)  { [System.IO.File]::ReadAllText($evidenceFile, $script:LatexStoreUtf8)  | ConvertFrom-Json } else { @() }
    $aliases   = if (Test-Path -LiteralPath $aliasesFile -PathType Leaf)   { [System.IO.File]::ReadAllText($aliasesFile, $script:LatexStoreUtf8)   | ConvertFrom-Json } else { @() }
    $glyphs    = if (Test-Path -LiteralPath $glyphsFile -PathType Leaf)    { [System.IO.File]::ReadAllText($glyphsFile, $script:LatexStoreUtf8)    | ConvertFrom-Json } else { @() }
    $furniture = if (Test-Path -LiteralPath $furnitureFile -PathType Leaf) { [System.IO.File]::ReadAllText($furnitureFile, $script:LatexStoreUtf8) | ConvertFrom-Json } else { @() }

    $script:LatexStoreDataCache = [pscustomobject]@{
        source_evidence    = $evidence
        aliases            = $aliases
        unicode_glyphs     = $glyphs
        furniture_patterns = $furniture
    }
    return $script:LatexStoreDataCache
}

function New-LatexEvidenceLedger {
    return ,([System.Collections.Generic.List[object]]::new())
}

function Add-LatexEvidence {
    param(
        [Parameter(Mandatory)] $Ledger,
        [Parameter(Mandatory)] [string]$SpanId,
        [Parameter(Mandatory)] [string]$EvidenceKind,
        [Parameter(Mandatory)] [string]$Original,
        [Parameter(Mandatory)] [string]$Lowered,
        [string]$Description = ''
    )
    if ($null -ne [object]$Ledger) {
        $Ledger.Add([pscustomobject]@{
            span_id       = $SpanId
            evidence_kind = $EvidenceKind
            original      = $Original
            lowered       = $Lowered
            description   = $Description
            timestamp     = [System.DateTime]::UtcNow.ToString('o')
        })
    }
}

function Invoke-LatexMathStoreLowering {
    param(
        # AllowEmptyString: Mandatory alone REJECTS '' at bind time, before the body's own
        # empty-guard can run — an author's empty math span ($$ $$) crashed the whole conversion
        # (2405.12350v1). Empty in, empty out is this function's declared behavior.
        [Parameter(Mandatory)] [AllowEmptyString()] [string]$Latex,
        [string]$SpanId = 'span-0',
        $EvidenceLedger = $null,
        [switch]$Inline
    )
    if ([string]::IsNullOrWhiteSpace($Latex)) { return $Latex }
    $store = Get-LatexMathStore
    $s = $Latex

    # 1. Upstream Source Evidence Lowering (from stores/evidence.json)
    if ($store -and $store.source_evidence) {
        foreach ($evRule in $store.source_evidence) {
            $rx = [regex]$evRule.pattern
            $s = $rx.Replace($s, {
                param($m)
                $orig = $m.Value
                $groupVal = if ($m.Groups.Count -gt 1) { $m.Groups[1].Value } else { '' }
                $lowered = if ($evRule.id -eq 'operatorname') { "\mathrm{$groupVal}" } else { $m.Result($evRule.replacement) }
                if ($orig -ne $lowered -and $null -ne [object]$EvidenceLedger) {
                    Add-LatexEvidence -Ledger $EvidenceLedger -SpanId $SpanId -EvidenceKind $evRule.evidence_kind -Original $orig -Lowered $lowered -Description $evRule.description
                }
                return $lowered
            })
        }
    }

    # 2. Furniture Removal (from stores/furniture.json)
    if ($store -and $store.furniture_patterns) {
        foreach ($fPattern in $store.furniture_patterns) {
            $s = [regex]::Replace($s, $fPattern.pattern, $fPattern.replacement)
        }
    }

    # Redundant double-bracing cleanup
    do { $prev = $s; $s = [regex]::Replace($s, '\{\s*\{([^{}]*)\}\s*\}', '{$1}') } while ($s -ne $prev)
    $s = $s -replace '[ \t]{2,}', ' '

    # 3. Canonicalize math register (aliases + unicode mapping via math-register.ps1 ConvertTo-RegisterMath)
    if (Get-Command ConvertTo-RegisterMath -ErrorAction SilentlyContinue) {
        $s = ConvertTo-RegisterMath -Latex $s -Inline:$Inline
    }

    return $s
}
