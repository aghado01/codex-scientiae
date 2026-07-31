#requires -Version 7.0
<#
  src/shared/md-sentinels.ps1 — defect sentinels: the marks that say a document was DAMAGED in
  conversion, counted the same way everywhere.

  Two implementations existed and each had half the answer. publish.ps1 was table-driven and scanned
  several texts (body AND references — either can carry a dropped table), but knew only two sentinels
  and matched them literally. md-bundle.ps1 knew three, including the leaked-placeholder pattern that
  has to be a REGEX, but hardcoded them inline against a single text. Merged here: the union of the
  sentinels, the table-driven shape, and per-text counts.

  These are hard failures, not style. A U+FFFD means a codepoint was destroyed; a leaked @@LMATH0@@ means
  a protection marker outlived the pass that placed it; FILL_ME_IN means a human placeholder shipped.
  Any of them in a finished document is a conversion bug, so the count belongs in every gate.
#>

# Pattern is a REGEX when IsRegex, else matched literally. Order is report order.
$script:MdDefectSentinels = @(
    [pscustomobject]@{ Label = 'U+FFFD'; Pattern = ([string][char]0xFFFD); IsRegex = $false }   # destroyed codepoint
    [pscustomobject]@{ Label = 'placeholder'; Pattern = '@@[A-Z]+\d+@@'; IsRegex = $true }      # leaked LMATH/LDISP/ALG/VERB marker
    [pscustomobject]@{ Label = 'FILL_ME_IN'; Pattern = 'FILL_ME_IN'; IsRegex = $false }         # human placeholder
)

function Get-MdSentinelCatalogue { return $script:MdDefectSentinels }

<#
  Count every sentinel across one or more NAMED texts.

  $Texts is an ordered map of name -> text ('body', 'references', …). Emits one record per sentinel
  that FIRED: { label; counts = @{name -> n}; total }. Sentinels that did not fire are omitted, so an
  empty result means clean — a gate can test @(Get-MdDefectCounts …).Count rather than summing.

  Emitted UNWRAPPED (no unary-comma). Wrapping keeps the List intact through assignment but leaves it as
  a single object when the call is inlined, so @(f()).Count answered 1 for a clean document while
  $r = f(); @($r).Count answered 0 — the same question, two answers, at the exact call site a gate uses.
#>
function Get-MdDefectCounts {
    param([Parameter(Mandatory)][System.Collections.IDictionary]$Texts)
    $found = [System.Collections.Generic.List[object]]::new()
    foreach ($s in $script:MdDefectSentinels) {
        $pattern = if ($s.IsRegex) { [string]$s.Pattern } else { [regex]::Escape([string]$s.Pattern) }
        $counts = [ordered]@{}
        $total = 0
        foreach ($name in $Texts.Keys) {
            $t = [string]$Texts[$name]
            $n = if ($t) { ([regex]::Matches($t, $pattern)).Count } else { 0 }
            $counts[$name] = $n
            $total += $n
        }
        if ($total -gt 0) { $found.Add([pscustomobject]@{ label = $s.Label; counts = $counts; total = $total }) }
    }
    return $found
}

# Total for ONE sentinel label over a single text — the flat form a bundle report wants per field.
function Get-MdSentinelCount([string]$Text, [string]$Label) {
    $s = @($script:MdDefectSentinels | Where-Object { $_.Label -eq $Label })[0]
    if (-not $s -or -not $Text) { return 0 }
    $pattern = if ($s.IsRegex) { [string]$s.Pattern } else { [regex]::Escape([string]$s.Pattern) }
    return ([regex]::Matches($Text, $pattern)).Count
}
