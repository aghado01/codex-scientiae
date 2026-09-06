#requires -Version 7.0
<#
.SYNOPSIS
  src/procurement/scripts/probe-ledger.ps1 — witnessed probe outcome ledger.

.DESCRIPTION
  Maintains an ordered record of verified probe outcomes (passed, not-applicable, waived)
  and validates bidirectional probe coverage against declared expectations.
#>

class ProbeLedger {
    static [string[]] $Outcomes = @('passed', 'not-applicable', 'waived')

    hidden [System.Collections.Generic.List[object]] $Entries
    hidden [System.Collections.Generic.HashSet[string]] $Names

    ProbeLedger() {
        $this.Entries = [System.Collections.Generic.List[object]]::new()
        $this.Names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    }

    [void] Record([string]$Name, [string]$Outcome) {
        $this.Record($Name, $Outcome, @{})
    }

    [void] Record([string]$Name, [string]$Outcome, [hashtable]$Detail) {
        if ([string]::IsNullOrWhiteSpace($Name)) { throw 'probe name is required' }
        if ([ProbeLedger]::Outcomes -notcontains $Outcome) {
            throw "unknown probe outcome '$Outcome' for '$Name'; expected one of: $([ProbeLedger]::Outcomes -join ', ')"
        }
        if ($this.Names.Contains($Name)) {
            throw "probe '$Name' already recorded; a probe reports once per transaction"
        }

        if ($Outcome -ne 'passed' -and -not $Detail.ContainsKey('reason')) {
            throw "probe '$Name' recorded as '$Outcome' without a 'reason'; a non-passing outcome must say why"
        }

        $record = [ordered]@{ name = $Name; outcome = $Outcome }
        $keys = [System.Collections.Generic.List[string]]::new()
        foreach ($key in $Detail.Keys) { $keys.Add([string]$key) }
        $keys.Sort([System.StringComparer]::Ordinal)
        foreach ($key in $keys) {
            if ($key -eq 'name' -or $key -eq 'outcome') {
                throw "probe '$Name' detail cannot redefine reserved key '$key'"
            }
            $record[$key] = $Detail[$key]
        }

        [void]$this.Names.Add($Name)
        $this.Entries.Add([pscustomobject]$record)
    }

    [object[]] Results() {
        return $this.Entries.ToArray()
    }

    [int] Count() {
        return $this.Entries.Count
    }

    [bool] Has([string]$Name) {
        return $this.Names.Contains($Name)
    }

    [void] AssertCoverage([string[]]$Expected) {
        $declared = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($name in $Expected) { [void]$declared.Add($name) }

        $missing = [System.Collections.Generic.List[string]]::new()
        foreach ($name in $Expected) { if (-not $this.Names.Contains($name)) { $missing.Add($name) } }
        if ($missing.Count -gt 0) {
            throw "probe ledger is missing a declared probe: $($missing -join ', ')"
        }

        $unexpected = [System.Collections.Generic.List[string]]::new()
        foreach ($entry in $this.Entries) {
            $name = [string]$entry.name
            if (-not $declared.Contains($name)) { $unexpected.Add($name) }
        }
        if ($unexpected.Count -gt 0) {
            throw "probe ledger recorded an undeclared probe: $($unexpected -join ', ')"
        }
    }
}

function New-ProbeLedger {
    [CmdletBinding()]
    [OutputType([ProbeLedger])]
    param()
    return [ProbeLedger]::new()
}

