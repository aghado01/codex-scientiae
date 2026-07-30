#requires -Version 7.0
<#
  src/latex-ingest/latex-math-store.ps1 — Store-driven LaTeX math register lowering & out-of-band evidence tracking.

  Loads `src/latex-ingest/stores/latex-math-store.json`. Interprets TeX typesetting constructs as upstream
  source evidence before lowering them into the canonical target math register. Out-of-band evidence is recorded
  into an evidence ledger without cluttering the target Markdown manuscript.
#>

$script:LatexStoreUtf8 = [System.Text.UTF8Encoding]::new($false)
$script:LatexMathStoreData = $null

function Get-LatexMathStore {
    param([string]$Path = (Join-Path $PSScriptRoot 'stores/latex-math-store.json'))
    if ($null -ne $script:LatexMathStoreData) { return $script:LatexMathStoreData }
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        $json = [System.IO.File]::ReadAllText($Path, $script:LatexStoreUtf8)
        $script:LatexMathStoreData = $json | ConvertFrom-Json
    }
    return $script:LatexMathStoreData
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
        [Parameter(Mandatory)] [string]$Latex,
        [string]$SpanId = 'span-0',
        $EvidenceLedger = $null,
        [switch]$Inline
    )
    if ([string]::IsNullOrWhiteSpace($Latex)) { return $Latex }
    $store = Get-LatexMathStore
    $s = $Latex

    # 1. Upstream Source Evidence Lowering (from store.source_evidence)
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

    # 2. Furniture Removal (from store.furniture_patterns)
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
