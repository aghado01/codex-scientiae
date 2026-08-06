#requires -Version 7.0
<#
  Managed JSONL store operations over jsonl-v2.ps1.

  The filename is temporary; public commands intentionally use unversioned names. This layer names
  lifecycle and maintenance transactions. It does not define an ingestion manifest, directory catalog,
  or application schema. Existing canonical indexes are reflexively rebuilt after every mutation.
#>

. "$PSScriptRoot/jsonl-v2.ps1"

function New-JsonlStorePolicy {
    <#
    Describe application-owned store invariants without persisting another store sidecar. A policy is
    deliberately passed by the caller on each policy-aware operation; an application wrapper can bind it.
    SchemaValidator may throw on failure or return exactly $false. It receives the JsonElement, SchemaPath,
    and a context object. KeySelector receives the JsonElement and context and must return one string key.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Kind,
        [AllowEmptyString()][string]$KeyPointer,
        [ValidateSet('None', 'Scalar', 'ScopedRelativePath')][string]$KeyMode = 'None',
        [scriptblock]$KeySelector,
        [switch]$UniqueKey,
        [ValidateSet('Ordinal', 'OrdinalIgnoreCase')][string]$KeyComparison = 'Ordinal',
        [AllowEmptyCollection()][hashtable[]]$CanonicalSort = @(),
        [string]$SchemaPath,
        [scriptblock]$SchemaValidator
    )

    if ($KeySelector -and $PSBoundParameters.ContainsKey('KeyPointer')) {
        throw 'A store policy must use either KeyPointer or KeySelector, not both'
    }
    if ($KeyMode -ne 'None' -and -not $PSBoundParameters.ContainsKey('KeyPointer')) {
        throw "KeyMode '$KeyMode' requires KeyPointer"
    }
    if ($PSBoundParameters.ContainsKey('KeyPointer') -and $KeyMode -eq 'None') { $KeyMode = 'Scalar' }
    if ($KeySelector -and $KeyMode -ne 'None') {
        throw 'KeyMode applies to KeyPointer policies and cannot be combined with KeySelector'
    }
    if ($UniqueKey -and -not $KeySelector -and -not $PSBoundParameters.ContainsKey('KeyPointer')) {
        throw 'UniqueKey requires KeyPointer or KeySelector'
    }
    if ($PSBoundParameters.ContainsKey('KeyPointer')) {
        # Resolve once to validate RFC 6901 syntax without requiring a particular record shape.
        $probe = ConvertFrom-JsonlLine -Line '{}' -AsJsonElement
        $null = script:Resolve-JsonlPointerElement -Element $probe -Pointer $KeyPointer
    }
    if ($SchemaPath -and -not $SchemaValidator) {
        throw 'SchemaPath requires SchemaValidator; schema validation must not be implied but skipped'
    }
    $schemaFull = $null
    if ($SchemaPath) {
        $schemaFull = [System.IO.Path]::GetFullPath($SchemaPath)
        if (-not [System.IO.File]::Exists($schemaFull)) { throw "JSON schema not found: $schemaFull" }
    }

    $sort = [System.Collections.Generic.List[object]]::new()
    foreach ($descriptor in $CanonicalSort) {
        if (-not $descriptor.ContainsKey('Pointer')) {
            throw 'Each CanonicalSort descriptor requires Pointer'
        }
        $pointer = [string]$descriptor.Pointer
        $probe = ConvertFrom-JsonlLine -Line '{}' -AsJsonElement
        $null = script:Resolve-JsonlPointerElement -Element $probe -Pointer $pointer
        $unexpected = @($descriptor.Keys | Where-Object { $_ -notin @('Pointer', 'Descending') })
        if ($unexpected.Count -gt 0) {
            throw "Unsupported CanonicalSort property: $($unexpected -join ', ')"
        }
        $sort.Add([pscustomobject]@{
            Pointer    = $pointer
            Descending = if ($descriptor.ContainsKey('Descending')) { [bool]$descriptor.Descending } else { $false }
        })
    }

    $policy = [pscustomobject]@{
        Kind            = $Kind
        KeyPointer      = if ($PSBoundParameters.ContainsKey('KeyPointer')) { $KeyPointer } else { $null }
        KeyMode         = $KeyMode
        KeySelector     = $KeySelector
        UniqueKey       = [bool]$UniqueKey
        KeyComparison   = $KeyComparison
        CanonicalSort   = $sort.ToArray()
        SchemaPath      = $schemaFull
        SchemaValidator = $SchemaValidator
    }
    $policy.PSObject.TypeNames.Insert(0, 'Jsonl.StorePolicy')
    return $policy
}

function New-JsonlInventoryStorePolicy {
    <#
    Inventory specialization only: the application still chooses the record field and eventual schema.
    The key is a canonical path from the catalog scope to the document's parent directory.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$KeyPointer,
        [string]$SchemaPath,
        [scriptblock]$SchemaValidator
    )

    $parameters = @{
        Kind = 'inventory'; KeyPointer = $KeyPointer; KeyMode = 'ScopedRelativePath'; UniqueKey = $true
        KeyComparison = 'OrdinalIgnoreCase'; CanonicalSort = @(@{ Pointer = $KeyPointer })
    }
    if ($PSBoundParameters.ContainsKey('SchemaPath')) { $parameters.SchemaPath = $SchemaPath }
    if ($PSBoundParameters.ContainsKey('SchemaValidator')) { $parameters.SchemaValidator = $SchemaValidator }
    return New-JsonlStorePolicy @parameters
}

function script:Assert-JsonlStorePolicy {
    param([Parameter(Mandatory)]$Policy)

    if ($Policy.PSObject.TypeNames -notcontains 'Jsonl.StorePolicy') {
        throw 'Policy must be created by New-JsonlStorePolicy or an application policy factory'
    }
}

function script:Assert-JsonlScopedRelativePath {
    param(
        [Parameter(Mandatory)][System.Text.Json.JsonElement]$Element,
        [Parameter(Mandatory)][string]$Pointer
    )

    if ($Element.ValueKind -ne [System.Text.Json.JsonValueKind]::String) {
        throw "Inventory path key '$Pointer' must be a JSON string"
    }
    $value = $Element.GetString()
    if ([string]::IsNullOrEmpty($value)) { throw "Inventory path key '$Pointer' cannot be empty" }
    if (-not $value.IsNormalized([System.Text.NormalizationForm]::FormC)) {
        throw "Inventory path key '$Pointer' must use Unicode NFC"
    }
    if ($value.Contains('\')) { throw "Inventory path key '$Pointer' must use forward slashes" }
    if ($value.StartsWith('/') -or $value -match '^[A-Za-z]:') {
        throw "Inventory path key '$Pointer' must be relative to its store scope"
    }
    if ($value -eq '.') { return $value }
    foreach ($segment in $value.Split('/', [System.StringSplitOptions]::None)) {
        if ($segment.Length -eq 0) { throw "Inventory path key '$Pointer' contains an empty path segment" }
        if ($segment -in @('.', '..')) { throw "Inventory path key '$Pointer' cannot contain '.' or '..' segments" }
        foreach ($character in $segment.ToCharArray()) {
            if ([char]::IsControl($character)) { throw "Inventory path key '$Pointer' cannot contain control characters" }
        }
    }
    return $value
}

function script:Get-JsonlStorePolicyComparer {
    param([Parameter(Mandatory)]$Policy)

    if ($Policy.KeyComparison -eq 'OrdinalIgnoreCase') { return [System.StringComparer]::OrdinalIgnoreCase }
    return [System.StringComparer]::Ordinal
}

function script:Invoke-JsonlStoreRecordPolicy {
    param(
        [Parameter(Mandatory)][System.Text.Json.JsonElement]$Element,
        [Parameter(Mandatory)]$Policy,
        [Parameter(Mandatory)]$Context
    )

    if ($Policy.SchemaValidator) {
        try { $validation = @(& $Policy.SchemaValidator $Element $Policy.SchemaPath $Context) }
        catch { throw "Store kind '$($Policy.Kind)' rejected record $($Context.RecordIndex): $($_.Exception.Message)" }
        if ($validation.Count -eq 1 -and $validation[0] -is [bool] -and -not $validation[0]) {
            throw "Store kind '$($Policy.Kind)' rejected record $($Context.RecordIndex)"
        }
    }

    if ($Policy.KeySelector) {
        try { $selected = @(& $Policy.KeySelector $Element $Context) }
        catch { throw "Store kind '$($Policy.Kind)' could not select key for record $($Context.RecordIndex): $($_.Exception.Message)" }
        if ($selected.Count -ne 1 -or $null -eq $selected[0] -or $selected[0] -isnot [string]) {
            throw "Store kind '$($Policy.Kind)' KeySelector must return exactly one non-null string"
        }
        return [string]$selected[0]
    }
    if ($null -eq $Policy.KeyPointer) { return $null }

    $selection = script:Resolve-JsonlPointerElement -Element $Element -Pointer $Policy.KeyPointer
    if (-not $selection.Found) {
        throw "Store kind '$($Policy.Kind)' requires key '$($Policy.KeyPointer)' at record $($Context.RecordIndex)"
    }
    if ($Policy.KeyMode -eq 'ScopedRelativePath') {
        return script:Assert-JsonlScopedRelativePath -Element $selection.Element -Pointer $Policy.KeyPointer
    }
    return script:Get-JsonlStoreScalarKey -Element $selection.Element -Pointer $Policy.KeyPointer
}

function script:New-JsonlStoreRow {
    param(
        [Parameter(Mandatory)][string]$RawText,
        [Parameter(Mandatory)][long]$RecordIndex,
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$StorePath,
        [AllowNull()]$Policy
    )

    $element = ConvertFrom-JsonlLine -Line $RawText -AsJsonElement
    $context = [pscustomobject]@{
        StorePath = $StorePath
        StoreKind = if ($Policy) { $Policy.Kind } else { $null }
        Source = $Source
        RecordIndex = $RecordIndex
    }
    $key = if ($Policy) { script:Invoke-JsonlStoreRecordPolicy -Element $element -Policy $Policy -Context $context } else { $null }
    return [pscustomobject]@{
        RecordIndex = $RecordIndex
        Order       = $RecordIndex
        RawText     = $RawText
        Element     = $element
        Key         = $key
    }
}

function script:ConvertTo-JsonlStoreRows {
    param(
        [AllowNull()][AllowEmptyCollection()][object[]]$Records,
        [Parameter(Mandatory)][int]$Depth,
        [Parameter(Mandatory)][string]$StorePath,
        [Parameter(Mandatory)][string]$Source,
        [long]$StartIndex = 0,
        [AllowNull()]$Policy
    )

    $recordList = [object[]]::new(1)
    if (-not [object]::ReferenceEquals($null, $Records)) { $recordList = $Records }
    $rows = [System.Collections.Generic.List[object]]::new()
    for ($i = 0; $i -lt $recordList.Count; $i++) {
        $line = ConvertTo-JsonlLine -Record $recordList[$i] -Depth $Depth
        $rows.Add((script:New-JsonlStoreRow -RawText $line -RecordIndex ($StartIndex + $i) `
            -Source $Source -StorePath $StorePath -Policy $Policy))
    }
    return $rows.ToArray()
}

function script:Assert-JsonlStoreUniqueKeys {
    param(
        [Parameter(Mandatory)][object[]]$Rows,
        [Parameter(Mandatory)]$Policy
    )

    if (-not $Policy.UniqueKey) { return }
    $seen = [System.Collections.Generic.Dictionary[string, long]]::new((script:Get-JsonlStorePolicyComparer $Policy))
    foreach ($row in $Rows) {
        if ($null -eq $row.Key) { throw "Store kind '$($Policy.Kind)' produced a null unique key" }
        if ($seen.ContainsKey($row.Key)) {
            throw "Duplicate key '$($row.Key)' for store kind '$($Policy.Kind)' at records $($seen[$row.Key]) and $($row.RecordIndex)"
        }
        $seen.Add($row.Key, [long]$row.RecordIndex)
    }
}

function script:Sort-JsonlStoreRows {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Rows,
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Sort
    )

    if ($Rows.Count -lt 2 -or $Sort.Count -eq 0) { return $Rows }
    $sortable = [System.Collections.Generic.List[object]]::new()
    foreach ($row in $Rows) {
        $keys = [System.Collections.Generic.List[object]]::new()
        foreach ($descriptor in $Sort) {
            $keys.Add((script:Resolve-JsonlPointerElement -Element $row.Element -Pointer $descriptor.Pointer))
        }
        $sortable.Add([pscustomobject]@{ Row = $row; Keys = $keys.ToArray() })
    }
    $array = $sortable.ToArray()
    $comparison = [System.Comparison[object]] {
        param($left, $right)
        for ($i = 0; $i -lt $left.Keys.Count; $i++) {
            if ($left.Keys[$i].Found -ne $right.Keys[$i].Found) {
                return $(if ($left.Keys[$i].Found) { -1 } else { 1 })
            }
            $order = script:Compare-JsonlStoreSelection -Left $left.Keys[$i] -Right $right.Keys[$i]
            if ($order -ne 0) { return $(if ($Sort[$i].Descending) { -$order } else { $order }) }
        }
        return ([long]$left.Row.Order).CompareTo([long]$right.Row.Order)
    }
    [Array]::Sort($array, [System.Collections.Generic.Comparer[object]]::Create($comparison))
    return [object[]]@($array | ForEach-Object Row)
}

function script:Update-JsonlStoreIndex {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$IndexPath,
        [Parameter(Mandatory)][bool]$MaintainIndex
    )

    if (-not $MaintainIndex) { return $null }
    try {
        $policy = if ([System.IO.File]::Exists($IndexPath)) { 'Replace' } else { 'Fail' }
        return New-JsonlIndex -Path $Path -IndexPath $IndexPath -ExistingFile $policy
    } catch {
        throw [System.InvalidOperationException]::new(
            "JSONL store content was committed, but derived index refresh failed for ${Path}: $($_.Exception.Message)",
            $_.Exception
        )
    }
}

function script:New-JsonlStoreMutationResult {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$IndexPath,
        [Parameter(Mandatory)][string]$Operation,
        [Parameter(Mandatory)][bool]$Changed,
        [Parameter(Mandatory)][long]$AffectedRecords,
        [AllowNull()]$Policy
    )

    $info = Get-JsonlStoreInfo -Path $Path -IndexPath $IndexPath
    return [pscustomobject]@{
        Path            = $info.Path
        Operation       = $Operation
        Changed         = $Changed
        AffectedRecords = $AffectedRecords
        RecordCount     = $info.CompleteRecordCount
        Bytes           = $info.Bytes
        IndexPath       = $info.IndexPath
        IndexStatus     = $info.IndexStatus
        StoreKind       = if ($Policy) { $Policy.Kind } else { $null }
    }
}

function script:Get-JsonlStoreRows {
    param(
        [Parameter(Mandatory)][string]$Path,
        [AllowNull()]$Policy
    )

    foreach ($row in Read-Jsonl -Path $Path -AsRawText -IncludeMetadata) {
        $storeRow = script:New-JsonlStoreRow -RawText $row.Value -RecordIndex $row.RecordIndex `
            -Source Existing -StorePath $Path -Policy $Policy
        $storeRow | Add-Member -NotePropertyName ByteOffset -NotePropertyValue $row.ByteOffset
        $storeRow
    }
}

function script:Compare-JsonlStoreSelection {
    param([Parameter(Mandatory)]$Left, [Parameter(Mandatory)]$Right)

    if (-not $Left.Found -and -not $Right.Found) { return 0 }
    if (-not $Left.Found) { return 1 }
    if (-not $Right.Found) { return -1 }
    $a = $Left.Element
    $b = $Right.Element
    $aIsBoolean = $a.ValueKind -in @([System.Text.Json.JsonValueKind]::False, [System.Text.Json.JsonValueKind]::True)
    $bIsBoolean = $b.ValueKind -in @([System.Text.Json.JsonValueKind]::False, [System.Text.Json.JsonValueKind]::True)
    if ($aIsBoolean -and $bIsBoolean) {
        return ([int]($a.ValueKind -eq [System.Text.Json.JsonValueKind]::True)).CompareTo(
            [int]($b.ValueKind -eq [System.Text.Json.JsonValueKind]::True)
        )
    }
    if ($a.ValueKind -ne $b.ValueKind) { return ([int]$a.ValueKind).CompareTo([int]$b.ValueKind) }
    switch ($a.ValueKind) {
        ([System.Text.Json.JsonValueKind]::String) {
            return [System.StringComparer]::Ordinal.Compare($a.GetString(), $b.GetString())
        }
        ([System.Text.Json.JsonValueKind]::Number) {
            [decimal]$da = 0; [decimal]$db = 0
            $style = [System.Globalization.NumberStyles]::Float
            $culture = [System.Globalization.CultureInfo]::InvariantCulture
            if ([decimal]::TryParse($a.GetRawText(), $style, $culture, [ref]$da) -and
                [decimal]::TryParse($b.GetRawText(), $style, $culture, [ref]$db)) {
                return $da.CompareTo($db)
            }
            return ([double]$a.GetDouble()).CompareTo([double]$b.GetDouble())
        }
        ([System.Text.Json.JsonValueKind]::True) { return 0 }
        ([System.Text.Json.JsonValueKind]::False) { return 0 }
        ([System.Text.Json.JsonValueKind]::Null) { return 0 }
        default { return [System.StringComparer]::Ordinal.Compare($a.GetRawText(), $b.GetRawText()) }
    }
}

function script:Get-JsonlStoreScalarKey {
    param(
        [Parameter(Mandatory)][System.Text.Json.JsonElement]$Element,
        [Parameter(Mandatory)][string]$Pointer
    )

    switch ($Element.ValueKind) {
        ([System.Text.Json.JsonValueKind]::String) { return 's:' + $Element.GetString() }
        ([System.Text.Json.JsonValueKind]::True) { return 'b:1' }
        ([System.Text.Json.JsonValueKind]::False) { return 'b:0' }
        ([System.Text.Json.JsonValueKind]::Null) { return 'z:' }
        ([System.Text.Json.JsonValueKind]::Number) {
            $raw = $Element.GetRawText()
            $culture = [System.Globalization.CultureInfo]::InvariantCulture
            [decimal]$decimalValue = 0
            if ([decimal]::TryParse($raw, [System.Globalization.NumberStyles]::Float, $culture, [ref]$decimalValue)) {
                return 'n:' + $decimalValue.ToString('G29', $culture)
            }
            [System.Numerics.BigInteger]$integerValue = 0
            if ([System.Numerics.BigInteger]::TryParse($raw, [System.Globalization.NumberStyles]::Integer, $culture, [ref]$integerValue)) {
                return 'n:' + $integerValue.ToString($culture)
            }
            return 'n:' + $Element.GetDouble().ToString('R', $culture)
        }
        default { throw "Store key '$Pointer' must resolve to a scalar JSON value" }
    }
}

function Create-JsonlStore {
    <# Create or explicitly replace a named store and establish its requested derived index state. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [AllowNull()][AllowEmptyCollection()][object[]]$Records = @(),
        [ValidateSet('Fail', 'Replace')][string]$ExistingFile = 'Fail',
        [switch]$BuildIndex,
        [string]$IndexPath,
        $Policy,
        [ValidateRange(1, 100)][int]$Depth = 32,
        [ValidateSet('Fail', 'Wait')][string]$ContentionAction = 'Fail',
        [ValidateRange(1, 60000)][int]$ContentionTimeoutMilliseconds = 2000
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if ($Policy) { script:Assert-JsonlStorePolicy $Policy }
    $prepared = if ($Policy) {
        $rows = @(script:ConvertTo-JsonlStoreRows -Records $Records -Depth $Depth -StorePath $full -Source Create -Policy $Policy)
        script:Assert-JsonlStoreUniqueKeys -Rows $rows -Policy $Policy
        @(script:Sort-JsonlStoreRows -Rows $rows -Sort @($Policy.CanonicalSort))
    } else { $null }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)
    $mutex = script:Enter-JsonlPathMutex -Path $full -ContentionAction $ContentionAction `
        -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds
    try {
        $hadIndex = [System.IO.File]::Exists($indexFull)
        $write = if ($Policy) {
            Write-JsonlLines -Lines ([string[]]@($prepared | ForEach-Object RawText)) -Path $full -ExistingFile $ExistingFile
        } else { Write-Jsonl -Records $Records -Path $full -ExistingFile $ExistingFile -Depth $Depth }
        $null = script:Update-JsonlStoreIndex -Path $full -IndexPath $indexFull -MaintainIndex ($BuildIndex -or $hadIndex)
        return script:New-JsonlStoreMutationResult -Path $full -IndexPath $indexFull -Operation 'Create' `
            -Changed $true -AffectedRecords $write.Records -Policy $Policy
    } finally { script:Exit-JsonlPathMutex $mutex }
}

function Add-JsonlStoreRecords {
    <# Append an ungoverned store, or transactionally merge/re-sort a policy-governed store. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][AllowNull()][AllowEmptyCollection()][object[]]$Records,
        [switch]$BuildIndex,
        [string]$IndexPath,
        $Policy,
        [ValidateSet('Stop', 'KeepExisting', 'Replace')][string]$DuplicateKeyAction = 'Stop',
        [ValidateRange(1, 100)][int]$Depth = 32,
        [ValidateSet('Fail', 'Wait')][string]$ContentionAction = 'Fail',
        [ValidateRange(1, 60000)][int]$ContentionTimeoutMilliseconds = 2000,
        [ValidateRange(1, 1000)][int]$RetryIntervalMilliseconds = 25,
        [switch]$FlushToDisk
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if ($Policy) {
        script:Assert-JsonlStorePolicy $Policy
        if (-not $Policy.UniqueKey -and $DuplicateKeyAction -ne 'Stop') {
            throw 'DuplicateKeyAction requires a policy with UniqueKey'
        }
    } elseif ($DuplicateKeyAction -ne 'Stop') {
        throw 'DuplicateKeyAction requires Policy'
    }
    $incoming = if ($Policy) {
        @(script:ConvertTo-JsonlStoreRows -Records $Records -Depth $Depth -StorePath $full -Source Incoming -Policy $Policy)
    } else { $null }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)
    $mutex = script:Enter-JsonlPathMutex -Path $full -ContentionAction $ContentionAction `
        -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds
    try {
        $hadIndex = [System.IO.File]::Exists($indexFull)
        $affected = 0
        if ($Policy) {
            if (-not [System.IO.File]::Exists($full)) { throw "JSONL store not found: $full" }
            $existing = @(script:Get-JsonlStoreRows -Path $full -Policy $Policy)
            script:Assert-JsonlStoreUniqueKeys -Rows $existing -Policy $Policy
            $merged = [System.Collections.Generic.List[object]]::new()
            foreach ($row in $existing) { $merged.Add($row) }

            if ($Policy.UniqueKey) {
                $positions = [System.Collections.Generic.Dictionary[string, int]]::new((script:Get-JsonlStorePolicyComparer $Policy))
                for ($i = 0; $i -lt $merged.Count; $i++) { $positions.Add($merged[$i].Key, $i) }
                foreach ($row in $incoming) {
                    if ($positions.ContainsKey($row.Key)) {
                        if ($DuplicateKeyAction -eq 'Stop') {
                            throw "Duplicate key '$($row.Key)' for store kind '$($Policy.Kind)'"
                        }
                        if ($DuplicateKeyAction -eq 'KeepExisting') { continue }
                        $position = $positions[$row.Key]
                        $row.Order = $merged[$position].Order
                        $merged[$position] = $row
                        $affected++
                        continue
                    }
                    $row.Order = $existing.Count + $affected
                    $positions.Add($row.Key, $merged.Count)
                    $merged.Add($row)
                    $affected++
                }
            } else {
                foreach ($row in $incoming) {
                    $row.Order = $existing.Count + $affected
                    $merged.Add($row)
                    $affected++
                }
            }

            if ($affected -gt 0) {
                $sorted = @(script:Sort-JsonlStoreRows -Rows $merged.ToArray() -Sort @($Policy.CanonicalSort))
                Write-JsonlLines -Lines ([string[]]@($sorted | ForEach-Object RawText)) -Path $full `
                    -ExistingFile Replace -FlushToDisk:$FlushToDisk | Out-Null
            }
        } else {
            $append = Add-JsonlRecords -Path $full -Records $Records -Depth $Depth -ContentionAction $ContentionAction `
                -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds -RetryIntervalMilliseconds $RetryIntervalMilliseconds `
                -FlushToDisk:$FlushToDisk
            $affected = $append.RecordsAppended
        }
        if ($affected -gt 0) {
            $null = script:Update-JsonlStoreIndex -Path $full -IndexPath $indexFull -MaintainIndex ($BuildIndex -or $hadIndex)
        }
        return script:New-JsonlStoreMutationResult -Path $full -IndexPath $indexFull -Operation 'Append' `
            -Changed ($affected -gt 0) -AffectedRecords $affected -Policy $Policy
    } finally { script:Exit-JsonlPathMutex $mutex }
}

function Remove-JsonlStoreRecords {
    <# Atomically remove physical indices or rows matching exact JSON Pointer conditions, preserving other row bytes. #>
    [CmdletBinding(DefaultParameterSetName = 'Condition')]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory, ParameterSetName = 'At')][int[]]$At,
        [Parameter(Mandatory, ParameterSetName = 'Condition')][hashtable[]]$Condition,
        [ValidateSet('All', 'Any')][string]$Mode = 'All',
        [switch]$BuildIndex,
        [string]$IndexPath,
        [ValidateSet('Fail', 'Wait')][string]$ContentionAction = 'Fail',
        [ValidateRange(1, 60000)][int]$ContentionTimeoutMilliseconds = 2000
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)
    $mutex = script:Enter-JsonlPathMutex -Path $full -ContentionAction $ContentionAction `
        -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds
    try {
        $hadIndex = [System.IO.File]::Exists($indexFull)
        $rows = @(script:Get-JsonlStoreRows -Path $full)
        $removeIndices = $null
        $plan = $null
        if ($PSCmdlet.ParameterSetName -eq 'At') {
            $removeIndices = [System.Collections.Generic.HashSet[int]]::new()
            foreach ($index in $At) {
                if ($index -lt 0 -or $index -ge $rows.Count) { throw "Record index $index out of range; store has $($rows.Count) records" }
                [void]$removeIndices.Add($index)
            }
        } else { $plan = @(script:New-JsonlConditionPlan -Condition $Condition) }

        $kept = [System.Collections.Generic.List[string]]::new()
        $removed = 0
        foreach ($row in $rows) {
            $drop = if ($removeIndices) { $removeIndices.Contains([int]$row.RecordIndex) }
                else { script:Test-JsonlConditionPlan -Element $row.Element -Plan $plan -Mode $Mode }
            if ($drop) { $removed++ } else { $kept.Add($row.RawText) }
        }
        if ($removed -gt 0) {
            Write-JsonlLines -Lines $kept.ToArray() -Path $full -ExistingFile Replace | Out-Null
            $null = script:Update-JsonlStoreIndex -Path $full -IndexPath $indexFull -MaintainIndex ($BuildIndex -or $hadIndex)
        }
        return script:New-JsonlStoreMutationResult -Path $full -IndexPath $indexFull -Operation 'Remove' `
            -Changed ($removed -gt 0) -AffectedRecords $removed
    } finally { script:Exit-JsonlPathMutex $mutex }
}

function Subtract-JsonlStore {
    <# Remove target rows whose scalar key also occurs in another store. #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$DifferencePath,
        [Parameter(Mandatory)][string]$KeyPointer,
        [switch]$BuildIndex,
        [string]$IndexPath,
        [ValidateSet('Fail', 'Wait')][string]$ContentionAction = 'Fail',
        [ValidateRange(1, 60000)][int]$ContentionTimeoutMilliseconds = 2000
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    $differenceFull = [System.IO.Path]::GetFullPath($DifferencePath)
    if ($full.Equals($differenceFull, [StringComparison]::OrdinalIgnoreCase)) { throw 'A JSONL store cannot be subtracted from itself' }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)
    $mutex = script:Enter-JsonlPathMutex -Path $full -ContentionAction $ContentionAction `
        -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds
    try {
        $hadIndex = [System.IO.File]::Exists($indexFull)
        $differenceKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($row in Read-Jsonl -Path $differenceFull -AsJsonElement -IncludeMetadata) {
            $selection = script:Resolve-JsonlPointerElement -Element $row.Value -Pointer $KeyPointer
            if (-not $selection.Found) { continue }
            [void]$differenceKeys.Add((script:Get-JsonlStoreScalarKey -Element $selection.Element -Pointer $KeyPointer))
        }

        $rows = @(script:Get-JsonlStoreRows -Path $full)
        $kept = [System.Collections.Generic.List[string]]::new()
        $removed = 0
        foreach ($row in $rows) {
            $selection = script:Resolve-JsonlPointerElement -Element $row.Element -Pointer $KeyPointer
            $drop = $false
            if ($selection.Found) {
                $key = script:Get-JsonlStoreScalarKey -Element $selection.Element -Pointer $KeyPointer
                $drop = $differenceKeys.Contains($key)
            }
            if ($drop) { $removed++ } else { $kept.Add($row.RawText) }
        }
        if ($removed -gt 0) {
            Write-JsonlLines -Lines $kept.ToArray() -Path $full -ExistingFile Replace | Out-Null
            $null = script:Update-JsonlStoreIndex -Path $full -IndexPath $indexFull -MaintainIndex ($BuildIndex -or $hadIndex)
        }
        return script:New-JsonlStoreMutationResult -Path $full -IndexPath $indexFull -Operation 'Subtract' `
            -Changed ($removed -gt 0) -AffectedRecords $removed
    } finally { script:Exit-JsonlPathMutex $mutex }
}

function Sort-JsonlStore {
    <# Deterministically resort a store by one or more RFC 6901 pointers and refresh derived indexing. #>
    [CmdletBinding(DefaultParameterSetName = 'By')]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory, ParameterSetName = 'By')][string[]]$By,
        [Parameter(Mandatory, ParameterSetName = 'Policy')]$Policy,
        [Parameter(ParameterSetName = 'By')][switch]$Descending,
        [switch]$BuildIndex,
        [string]$IndexPath,
        [ValidateSet('Fail', 'Wait')][string]$ContentionAction = 'Fail',
        [ValidateRange(1, 60000)][int]$ContentionTimeoutMilliseconds = 2000
    )

    $full = [System.IO.Path]::GetFullPath($Path)
    if ($Policy) {
        script:Assert-JsonlStorePolicy $Policy
        if ($Policy.CanonicalSort.Count -eq 0) { throw "Store kind '$($Policy.Kind)' has no canonical sort policy" }
        $sort = @($Policy.CanonicalSort)
    } else {
        $sort = @($By | ForEach-Object { [pscustomobject]@{ Pointer = $_; Descending = [bool]$Descending } })
    }
    if (-not $IndexPath) { $IndexPath = Resolve-JsonlIndexPath $full }
    $indexFull = [System.IO.Path]::GetFullPath($IndexPath)
    $mutex = script:Enter-JsonlPathMutex -Path $full -ContentionAction $ContentionAction `
        -ContentionTimeoutMilliseconds $ContentionTimeoutMilliseconds
    try {
        $hadIndex = [System.IO.File]::Exists($indexFull)
        $rows = @(script:Get-JsonlStoreRows -Path $full -Policy $Policy)
        if ($Policy) { script:Assert-JsonlStoreUniqueKeys -Rows $rows -Policy $Policy }
        $array = @(script:Sort-JsonlStoreRows -Rows $rows -Sort $sort)
        $changed = $false
        for ($i = 0; $i -lt $array.Count; $i++) { if ($array[$i].RecordIndex -ne $i) { $changed = $true; break } }
        if ($changed) {
            $lines = [string[]]@($array | ForEach-Object RawText)
            Write-JsonlLines -Lines $lines -Path $full -ExistingFile Replace | Out-Null
            $null = script:Update-JsonlStoreIndex -Path $full -IndexPath $indexFull -MaintainIndex ($BuildIndex -or $hadIndex)
        }
        return script:New-JsonlStoreMutationResult -Path $full -IndexPath $indexFull -Operation 'Sort' `
            -Changed $changed -AffectedRecords $(if ($changed) { $array.Count } else { 0 }) -Policy $Policy
    } finally { script:Exit-JsonlPathMutex $mutex }
}
