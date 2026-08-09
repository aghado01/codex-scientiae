#requires -Version 7.0
<#
  Tolerant reader for human-authored JSONL input. No domain vocabulary.

  Read-AuthoredJsonl: resolve -> reparse-guard -> absent? -> bounded read -> identity (+ optional drift
  assertion) -> UTF-8/no-BOM/no-bare-CR -> skip blank and full-line '#' or '//' comments -> one strict
  JSON object per line, no duplicate/case-colliding keys -> { line, fields }. The caller validates records.
#>

. "$PSScriptRoot/portable-path.ps1"
. "$PSScriptRoot/file-bytes.ps1"

function Assert-AuthoredJsonlIdentity {
    param(
        [AllowNull()] [AllowEmptyString()] [string]$Expected,
        [Parameter(Mandatory)] [string]$Actual,
        [Parameter(Mandatory)] [string]$Path
    )
    if ([string]::IsNullOrEmpty($Expected)) { return }
    if ($Expected -cne 'absent' -and -not (Test-ContentIdentityFormat -Value $Expected)) {
        throw "invalid expected identity '$Expected' (want absent or sha256:<64 lowercase hex>)"
    }
    if ($Expected -cne $Actual) {
        throw "authored JSONL identity drift for '$Path': expected '$Expected', found '$Actual'"
    }
}

function ConvertFrom-AuthoredJsonlObject {
    param(
        [Parameter(Mandatory)] [string]$Json,
        [Parameter(Mandatory)] [string]$FileName,
        [Parameter(Mandatory)] [int]$Line
    )
    $display = "$FileName`:$Line"
    $document = $null
    try {
        $document = [System.Text.Json.JsonDocument]::Parse(
            $Json, [System.Text.Json.JsonDocumentOptions]::new())
    } catch [System.Text.Json.JsonException] {
        throw "$display — invalid JSON: $($_.Exception.Message)"
    }
    try {
        $root = $document.RootElement
        if ($root.ValueKind -ne [System.Text.Json.JsonValueKind]::Object) {
            throw "$display — each JSONL value must be one object"
        }
        $names = [System.Collections.Generic.HashSet[string]]::new(
            [System.StringComparer]::OrdinalIgnoreCase)
        $fields = [System.Collections.Generic.Dictionary[string,System.Text.Json.JsonElement]]::new(
            [System.StringComparer]::Ordinal)
        foreach ($property in $root.EnumerateObject()) {
            if (-not $names.Add($property.Name)) {
                throw "$display — duplicate or case-colliding field '$($property.Name)'"
            }
            $fields.Add($property.Name, $property.Value.Clone())
        }
        return $fields
    } finally {
        if ($null -ne $document) { $document.Dispose() }
    }
}

function Read-AuthoredJsonl {
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$Path,
        [Parameter(Mandatory)] [long]$MaxBytes,
        [Alias('ExpectedIdentity')] [AllowNull()] [AllowEmptyString()] [string]$ExpectedPatchIdentity = ''
    )
    if (Test-PathHasReparsePoint -Path $Path) {
        throw "authored JSONL path must not traverse a symbolic link or reparse point: '$Path'"
    }
    $entry = try { Get-Item -LiteralPath $Path -Force -ErrorAction Stop }
             catch [System.Management.Automation.ItemNotFoundException] { $null }
    if ($null -eq $entry) {
        Assert-AuthoredJsonlIdentity -Expected $ExpectedPatchIdentity -Actual 'absent' -Path $Path
        return [pscustomobject]@{ path = $Path; identity = 'absent'; records = @() }
    }
    if (-not [System.IO.File]::Exists($Path)) { throw "authored JSONL path is not a file: '$Path'" }

    $bytes = Read-BoundedFileBytes -Path $Path -MaxBytes $MaxBytes
    if (Test-PathHasReparsePoint -Path $Path) {
        throw "authored JSONL path must not traverse a symbolic link or reparse point: '$Path'"
    }
    $identity = Get-ContentIdentity -Bytes $bytes
    Assert-AuthoredJsonlIdentity -Expected $ExpectedPatchIdentity -Actual $identity -Path $Path
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        throw "authored JSONL file must be UTF-8 without a BOM: '$Path'"
    }
    try { $text = [System.Text.UTF8Encoding]::new($false, $true).GetString($bytes) }
    catch [System.Text.DecoderFallbackException] { throw "authored JSONL file is not valid UTF-8: '$Path'" }
    if ($text -match "`r(?!`n)") { throw "authored JSONL file contains a bare CR line ending: '$Path'" }

    $records = [System.Collections.Generic.List[object]]::new()
    $fileName = [System.IO.Path]::GetFileName($Path)
    $lines = [System.Text.RegularExpressions.Regex]::Split($text, '\r?\n')
    for ($index = 0; $index -lt $lines.Length; $index++) {
        $trimmed = $lines[$index].Trim()
        if (-not $trimmed -or $trimmed.StartsWith('#') -or $trimmed.StartsWith('//')) { continue }
        $fields = ConvertFrom-AuthoredJsonlObject -Json $lines[$index] -FileName $fileName -Line ($index + 1)
        $records.Add([pscustomobject]@{ line = ($index + 1); fields = $fields })
    }
    return [pscustomobject]@{ path = $Path; identity = $identity; records = $records.ToArray() }
}

function Get-JsonRequiredString {
    param([Parameter(Mandatory)] $Fields, [Parameter(Mandatory)] [string]$Name, [Parameter(Mandatory)] [string]$Display)
    if (-not $Fields.ContainsKey($Name)) { throw "$Display — missing '$Name'" }
    $element = $Fields[$Name]
    if ($element.ValueKind -ne [System.Text.Json.JsonValueKind]::String) { throw "$Display — '$Name' must be a JSON string" }
    return [string]$element.GetString()
}

function Get-JsonOptionalString {
    param([Parameter(Mandatory)] $Fields, [Parameter(Mandatory)] [string]$Name, [Parameter(Mandatory)] [string]$Display)
    if (-not $Fields.ContainsKey($Name)) { return '' }
    $element = $Fields[$Name]
    if ($element.ValueKind -ne [System.Text.Json.JsonValueKind]::String) { throw "$Display — '$Name' must be a JSON string" }
    return [string]$element.GetString()
}

function Get-JsonOptionalPositiveInteger {
    param([Parameter(Mandatory)] $Fields, [Parameter(Mandatory)] [string]$Name, [Parameter(Mandatory)] [string]$Display)
    if (-not $Fields.ContainsKey($Name)) { return $null }
    $element = $Fields[$Name]
    $value = 0
    if ($element.ValueKind -ne [System.Text.Json.JsonValueKind]::Number -or
        -not $element.TryGetInt32([ref]$value) -or $value -le 0) {
        throw "$Display — '$Name' must be a positive JSON integer"
    }
    return $value
}
