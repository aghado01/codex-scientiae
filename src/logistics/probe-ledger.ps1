#requires -Version 7.0
<#
  src/logistics/probe-ledger.ps1 — witnessed checks.

  A claim recorded in an artifact must have a witness. The pattern this replaces asserted a
  hardcoded list of check names at assembly time:

      checks = @('gzip-readable', 'archive-members-confined', ...)

  which says only "nothing threw on the way here". It cannot distinguish a probe that ran and
  held from one that never applied to this input, and it keeps asserting the same names after a
  probe is added, removed, or run in a tolerant mode. With heterogeneous source material that
  difference is the whole signal.

  A ledger records one entry per probe, with three outcomes, because a boolean cannot carry them:

    passed          the probe ran and its condition held
    not-applicable  the input shape did not call for it (no members to confine in a single-file
                    archive; no ambiguity to resolve when an entrypoint was named explicitly)
    waived          the probe ran in a tolerant mode and accepted what a strict run would refuse

  ABSENT is not PASSED and TOLERATED is neither. Collapsing them is how an artifact comes to
  attest something no one checked.

  Recording happens on the SUCCESS side of an existing guard — a probe that fails still throws and
  aborts its transaction. This layer never converts a throw into a result; it only makes the
  throws that did not fire enumerable.

  WHY A CLASS AND NOT A FUNCTION SET
  ----------------------------------
  PowerShell enumerates collections on function output, so a ledger built out of functions has a
  return type that changes with its own length:

      function New-Ledger { return [List[object]]::new() }   ->  $null        (empty, unrolled away)
      function Get-Rows   { return $oneItemList }            ->  [String]     (the item, not a list)

  The `,$x` unary-array idiom suppresses that, but it is a patch applied per return site and
  forgetting one produces a bug that only appears at length 0 or 1 — it works in development with
  several entries and breaks on the document that had one. METHOD calls and property access do not
  cross the pipeline at all, so a class removes the failure mode by construction instead of by
  discipline. `[ProbeLedger]::new().Results()` is an empty `object[]`, not `$null`.

  This is the general rule the rest of this repository's PowerShell should follow: a collection is
  a property or a method result, never a bare function return value.

  The methods here touch only .NET types and their own members — deliberately, because a class
  method resolves commands in the CALLER's session state, not its defining module's. A class that
  calls module functions works until it is used from somewhere else, then either fails or silently
  binds to whatever the caller happens to have defined under that name.

  Generic infrastructure: no lane knowledge, no LaTeX, no filesystem, no I/O. Callers supply the
  probe names and the detail that makes each entry evidence rather than a label.
#>

class ProbeLedger {
    # The closed outcome set. Widening it is a schema change wherever entries are persisted, so it
    # lives in one place. A method parameter cannot carry [ValidateSet] — that attribute is legal
    # on properties and fields only — so the check is explicit in Record().
    static [string[]] $Outcomes = @('passed', 'not-applicable', 'waived')

    hidden [System.Collections.Generic.List[object]] $Entries
    hidden [System.Collections.Generic.HashSet[string]] $Names

    ProbeLedger() {
        $this.Entries = [System.Collections.Generic.List[object]]::new()
        $this.Names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    }

    # Class methods discard parameter defaults at compile time — `[hashtable]$d = @{}` parses and
    # then vanishes from the overload table. Overloads are the only real defaults a class has.
    [void] Record([string]$Name, [string]$Outcome) {
        $this.Record($Name, $Outcome, @{})
    }

    [void] Record([string]$Name, [string]$Outcome, [hashtable]$Detail) {
        # Validate and build completely before mutating anything. A rejected record must leave the
        # ledger exactly as it found it — registering the name up front (via HashSet.Add's return
        # value, which is the tempting shortcut) desynchronizes Names from Entries the moment a
        # later check throws, and then a retry reports a spurious duplicate and AssertCoverage sees
        # a name with no entry behind it.
        if ([string]::IsNullOrWhiteSpace($Name)) { throw 'probe name is required' }
        if ([ProbeLedger]::Outcomes -notcontains $Outcome) {
            throw "unknown probe outcome '$Outcome' for '$Name'; expected one of: $([ProbeLedger]::Outcomes -join ', ')"
        }
        if ($this.Names.Contains($Name)) {
            throw "probe '$Name' already recorded; a probe reports once per transaction"
        }

        # not-applicable and waived are the two outcomes a reader will interrogate. An entry saying
        # a probe did not apply without saying why is no better than the constant array it replaced.
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

    # Record order, ready to serialize. Empty is an empty array, not $null.
    [object[]] Results() {
        return $this.Entries.ToArray()
    }

    [int] Count() {
        return $this.Entries.Count
    }

    [bool] Has([string]$Name) {
        return $this.Names.Contains($Name)
    }

    # What stops the ledger drifting the way the hardcoded array did. The caller declares the probe
    # set it is accountable for; a probe that gained a code path but no record fails here, and so
    # does a record for a probe the caller never declared. Both directions matter — the first is an
    # unwitnessed claim, the second is a claim no code backs.
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

# A class instance is not enumerable, so this is safe as a plain function return — no `,$x` needed.
# Kept as the public door because PowerShell classes do not export from a module: a consumer that
# imports rather than dot-sources can call this even when the type name is out of reach.
function New-ProbeLedger {
    [CmdletBinding()]
    [OutputType([ProbeLedger])]
    param()
    return [ProbeLedger]::new()
}
