function Resolve-BatchWorkerBudget {
    <# Pure worker-count policy. Explicit MaxWorkers is not CPU-clamped: subprocess and I/O jobs may
       legitimately use more workers than logical cores. Auto mode reserves cores. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [ValidateRange(0, [int]::MaxValue)] [int] $ItemCount,
        [nullable[int]] $MaxWorkers = $null,
        [ValidateRange(0, [int]::MaxValue)] [int] $ReservedCores = 2,
        [ValidateRange(1, [int]::MaxValue)] [int] $MinItemsPerWorker = 1
    )

    if ($null -ne $MaxWorkers -and $MaxWorkers -lt 1) { throw 'MaxWorkers must be at least 1 when specified' }

    $logical = [math]::Max(1, [Environment]::ProcessorCount)
    $warnings = [System.Collections.Generic.List[string]]::new()

    if ($ItemCount -eq 0) {
        return [pscustomobject]@{
            Threads = 0; Policy = if ($null -eq $MaxWorkers) { 'Auto' } else { 'Explicit' }
            Warnings = @(); Inputs = [pscustomobject]@{
                ItemCount = 0; MaxWorkers = $MaxWorkers; ReservedCores = $ReservedCores
                MinItemsPerWorker = $MinItemsPerWorker; LogicalCores = $logical
            }
        }
    }

    if ($null -ne $MaxWorkers) {
        $policy = 'Explicit'
        # PowerShell unwraps Nullable[int] parameters to Int32 when a value is supplied.
        $ceiling = [int]$MaxWorkers
        if ($ceiling -gt $logical) {
            $warnings.Add("MaxWorkers ($ceiling) exceeds logical core count ($logical); retaining the explicit value for I/O or subprocess workloads.")
        }
    }
    else {
        $policy = 'Auto'
        $reserved = [math]::Min($ReservedCores, $logical - 1)
        $ceiling = [math]::Max(1, $logical - $reserved)
    }

    $graded = [math]::Max(1, [int][math]::Ceiling($ItemCount / $MinItemsPerWorker))
    $threads = [math]::Min($ItemCount, [math]::Min($ceiling, $graded))

    [pscustomobject]@{
        Threads = $threads
        Policy = $policy
        Warnings = $warnings.ToArray()
        Inputs = [pscustomobject]@{
            ItemCount = $ItemCount; MaxWorkers = $MaxWorkers; ReservedCores = $ReservedCores
            MinItemsPerWorker = $MinItemsPerWorker; LogicalCores = $logical
        }
    }
}
