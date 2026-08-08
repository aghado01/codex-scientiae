#requires -Version 7.0
<#
  Per-document LaTeX patch records.

  The canonical file is `{document-dir}/{slug}-latex.patch.jsonl`. Records are authored input:
  UTF-8 without a BOM, one JSON object per non-comment line, and a closed field vocabulary.
  Raw-byte identities allow batch callers to pin the input consumed by a conversion.
#>

$script:LatexPatchRegexTimeout = [System.TimeSpan]::FromMilliseconds(250)
$script:LatexPatchMaximumBytes = 1MB

function Test-LatexPatchPortableLeaf {
    param([AllowNull()] [AllowEmptyString()] [string]$Value)
    if ([string]::IsNullOrEmpty($Value) -or $Value -in '.', '..' -or
        $Value.EndsWith(' ') -or $Value.EndsWith('.')) { return $false }
    $invalid = '<>:"/\|?*'
    foreach ($character in $Value.ToCharArray()) {
        if ([int]$character -lt 32 -or $invalid.Contains([string]$character)) { return $false }
    }
    $stem = $Value.Split('.', 2)[0].ToUpperInvariant()
    if ($stem -in @('CON', 'PRN', 'AUX', 'NUL') -or
        $stem -match '^(?:COM|LPT)[1-9]$') { return $false }
    return $true
}

function Get-LatexPatchPath {
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$DocumentDir,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$Slug
    )
    $root = [System.IO.Path]::GetFullPath($DocumentDir)
    if (-not [System.IO.Directory]::Exists($root)) {
        throw "LaTeX patch document directory does not exist: '$root'"
    }
    if (-not (Test-LatexPatchPortableLeaf -Value $Slug)) {
        throw "LaTeX patch slug is not a portable file name: '$Slug'"
    }
    return [System.IO.Path]::Combine($root, "$Slug-latex.patch.jsonl")
}

function Get-LatexPatchRawIdentity {
    param([Parameter(Mandatory)] [AllowEmptyCollection()] [byte[]]$Bytes)
    $hash = [System.Security.Cryptography.SHA256]::HashData($Bytes)
    return 'sha256:' + [System.BitConverter]::ToString($hash).Replace('-', '').ToLowerInvariant()
}

function Test-LatexPatchPathHasReparsePoint {
    param([Parameter(Mandatory)] [string]$Path)
    $central = Get-Command Test-LatexPathHasReparsePoint -CommandType Function -ErrorAction SilentlyContinue
    if ($null -ne $central) { return [bool](Test-LatexPathHasReparsePoint -Path $Path) }

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $pathRoot = [System.IO.Path]::GetPathRoot($fullPath)
    $relative = [System.IO.Path]::GetRelativePath($pathRoot, $fullPath)
    $current = $pathRoot
    foreach ($segment in @($relative -split '[\\/]' | Where-Object { $_ -and $_ -ne '.' })) {
        $current = [System.IO.Path]::Combine($current, $segment)
        $item = Get-Item -LiteralPath $current -Force -ErrorAction SilentlyContinue
        if ($null -eq $item) { break }
        if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) { return $true }
    }
    return $false
}

function Get-LatexPatchItemOrNull {
    param([Parameter(Mandatory)] [string]$Path)
    try {
        return Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    } catch [System.Management.Automation.ItemNotFoundException] {
        return $null
    }
}

function Read-LatexPatchBoundedBytes {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [System.IO.FileInfo]$Entry
    )
    $observedLength = [long]$Entry.Length
    if ($observedLength -gt $script:LatexPatchMaximumBytes) {
        throw "LaTeX patch file exceeds the 1 MiB limit: '$Path'"
    }

    $stream = [System.IO.FileStream]::new(
        $Path,
        [System.IO.FileMode]::Open,
        [System.IO.FileAccess]::Read,
        [System.IO.FileShare]::Read,
        4096,
        [System.IO.FileOptions]::SequentialScan)
    try {
        $length = [long]$stream.Length
        if ($length -ne $observedLength) {
            throw "LaTeX patch file changed length before its bounded read: '$Path'"
        }
        if ($length -gt $script:LatexPatchMaximumBytes) {
            throw "LaTeX patch file exceeds the 1 MiB limit: '$Path'"
        }
        $bytes = [byte[]]::new([int]$length)
        $offset = 0
        while ($offset -lt $bytes.Length) {
            $read = $stream.Read($bytes, $offset, $bytes.Length - $offset)
            if ($read -eq 0) {
                throw "LaTeX patch file shrank during its bounded read: '$Path'"
            }
            $offset += $read
        }
        if ($stream.ReadByte() -ne -1 -or [long]$stream.Length -ne $length) {
            throw "LaTeX patch file grew during its bounded read: '$Path'"
        }
        return ,$bytes
    } finally {
        $stream.Dispose()
    }
}

function Assert-LatexPatchIdentity {
    param(
        [AllowNull()] [AllowEmptyString()] [string]$ExpectedPatchIdentity,
        [Parameter(Mandatory)] [string]$ActualIdentity,
        [Parameter(Mandatory)] [string]$Path
    )
    if ($null -eq $ExpectedPatchIdentity -or $ExpectedPatchIdentity.Length -eq 0) { return }
    if ($ExpectedPatchIdentity -cne 'absent' -and
        $ExpectedPatchIdentity -cnotmatch '^sha256:[0-9a-f]{64}$') {
        throw "invalid expected LaTeX patch identity '$ExpectedPatchIdentity' (want absent or sha256:<64 lowercase hex>)"
    }
    if ($ExpectedPatchIdentity -cne $ActualIdentity) {
        throw "LaTeX patch identity drift for '$Path': expected '$ExpectedPatchIdentity', found '$ActualIdentity'"
    }
}

function Get-LatexPatchRequiredString {
    param(
        [Parameter(Mandatory)] $Fields,
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [string]$Display
    )
    if (-not $Fields.ContainsKey($Name)) { throw "$Display — missing '$Name'" }
    $element = $Fields[$Name]
    if ($element.ValueKind -ne [System.Text.Json.JsonValueKind]::String) {
        throw "$Display — '$Name' must be a JSON string"
    }
    return [string]$element.GetString()
}

function Get-LatexPatchOptionalString {
    param(
        [Parameter(Mandatory)] $Fields,
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [string]$Display
    )
    if (-not $Fields.ContainsKey($Name)) { return '' }
    $element = $Fields[$Name]
    if ($element.ValueKind -ne [System.Text.Json.JsonValueKind]::String) {
        throw "$Display — '$Name' must be a JSON string"
    }
    return [string]$element.GetString()
}

function Get-LatexPatchOptionalGuard {
    param(
        [Parameter(Mandatory)] $Fields,
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [string]$Display
    )
    if (-not $Fields.ContainsKey($Name)) { return $null }
    $element = $Fields[$Name]
    $value = 0
    if ($element.ValueKind -ne [System.Text.Json.JsonValueKind]::Number -or
        -not $element.TryGetInt32([ref]$value) -or $value -le 0) {
        throw "$Display — '$Name' must be a positive JSON integer"
    }
    return $value
}

function ConvertFrom-LatexPatchJsonLine {
    param(
        [Parameter(Mandatory)] [string]$Json,
        [Parameter(Mandatory)] [string]$FileName,
        [Parameter(Mandatory)] [int]$Line
    )
    $display = "patch $FileName`:$Line"
    $document = $null
    try {
        $options = [System.Text.Json.JsonDocumentOptions]::new()
        $document = [System.Text.Json.JsonDocument]::Parse($Json, $options)
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

        $op = Get-LatexPatchRequiredString -Fields $fields -Name 'op' -Display $display
        if ($op -cnotin 'define_macro', 'source_replace', 'output_replace') {
            throw "$display — unknown op '$op' (want define_macro | source_replace | output_replace)"
        }
        $reason = Get-LatexPatchRequiredString -Fields $fields -Name 'reason' -Display $display
        if ([string]::IsNullOrWhiteSpace($reason)) {
            throw "$display — missing 'reason' (every erratum must be justified)"
        }

        $allowed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($name in @('op', 'reason', 'class', 'source_ref', 'authored_by', 'authored_utc')) {
            [void]$allowed.Add($name)
        }
        if ($op -ceq 'define_macro') {
            foreach ($name in @('name', 'body', 'expect_uses')) { [void]$allowed.Add($name) }
        } else {
            foreach ($name in @('find', 'replace', 'expect')) { [void]$allowed.Add($name) }
        }
        foreach ($name in $fields.Keys) {
            if (-not $allowed.Contains($name)) { throw "$display — unknown field '$name' for op '$op'" }
        }

        $record = [ordered]@{
            op           = $op
            reason       = $reason
            class        = Get-LatexPatchOptionalString -Fields $fields -Name 'class' -Display $display
            source_ref   = Get-LatexPatchOptionalString -Fields $fields -Name 'source_ref' -Display $display
            authored_by  = Get-LatexPatchOptionalString -Fields $fields -Name 'authored_by' -Display $display
            authored_utc = Get-LatexPatchOptionalString -Fields $fields -Name 'authored_utc' -Display $display
        }
        if ($op -ceq 'define_macro') {
            $name = Get-LatexPatchRequiredString -Fields $fields -Name 'name' -Display $display
            if ($name -cnotmatch '^\\[A-Za-z]+$') {
                throw "$display — 'name' must be one TeX control word such as \vect"
            }
            $record['name'] = $name
            $record['body'] = Get-LatexPatchRequiredString -Fields $fields -Name 'body' -Display $display
            if ($fields.ContainsKey('expect_uses')) {
                $record['expect_uses'] = Get-LatexPatchOptionalGuard -Fields $fields -Name 'expect_uses' -Display $display
            }
        } else {
            $find = Get-LatexPatchRequiredString -Fields $fields -Name 'find' -Display $display
            if ($find.Length -eq 0) { throw "$display — 'find' must not be empty" }
            $record['find'] = $find
            $record['replace'] = Get-LatexPatchRequiredString -Fields $fields -Name 'replace' -Display $display
            if ($fields.ContainsKey('expect')) {
                $record['expect'] = Get-LatexPatchOptionalGuard -Fields $fields -Name 'expect' -Display $display
            }
        }
        $record['line'] = $Line
        return [pscustomobject]$record
    } finally {
        if ($null -ne $document) { $document.Dispose() }
    }
}

function Read-LatexPatchSet {
    param(
        [Parameter(Mandatory)] [Alias('Dir')] [ValidateNotNullOrEmpty()] [string]$DocumentDir,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$Slug,
        [Alias('ExpectedIdentity')] [AllowNull()] [AllowEmptyString()] [string]$ExpectedPatchIdentity = ''
    )
    $path = Get-LatexPatchPath -DocumentDir $DocumentDir -Slug $Slug
    if (Test-LatexPatchPathHasReparsePoint -Path $path) {
        throw "LaTeX patch path must not traverse a symbolic link or reparse point: '$path'"
    }
    $entry = Get-LatexPatchItemOrNull -Path $path
    if ($null -eq $entry) {
        Assert-LatexPatchIdentity -ExpectedPatchIdentity $ExpectedPatchIdentity `
            -ActualIdentity 'absent' -Path $path
        return [pscustomobject]@{ path = $path; identity = 'absent'; patches = @() }
    }
    if (-not [System.IO.File]::Exists($path)) { throw "LaTeX patch path is not a file: '$path'" }

    $bytes = Read-LatexPatchBoundedBytes -Path $path -Entry $entry
    if (Test-LatexPatchPathHasReparsePoint -Path $path) {
        throw "LaTeX patch path must not traverse a symbolic link or reparse point: '$path'"
    }
    $identity = Get-LatexPatchRawIdentity -Bytes $bytes
    Assert-LatexPatchIdentity -ExpectedPatchIdentity $ExpectedPatchIdentity `
        -ActualIdentity $identity -Path $path
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        throw "LaTeX patch file must be UTF-8 without a BOM: '$path'"
    }
    try {
        $text = [System.Text.UTF8Encoding]::new($false, $true).GetString($bytes)
    } catch [System.Text.DecoderFallbackException] {
        throw "LaTeX patch file is not valid UTF-8: '$path'"
    }
    if ($text -match "`r(?!`n)") { throw "LaTeX patch file contains a bare CR line ending: '$path'" }

    $patches = [System.Collections.Generic.List[object]]::new()
    $defined = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $lines = [System.Text.RegularExpressions.Regex]::Split($text, '\r?\n')
    for ($index = 0; $index -lt $lines.Length; $index++) {
        $trimmed = $lines[$index].Trim()
        if (-not $trimmed -or $trimmed.StartsWith('#') -or $trimmed.StartsWith('//')) { continue }
        $patch = ConvertFrom-LatexPatchJsonLine -Json $lines[$index] `
            -FileName ([System.IO.Path]::GetFileName($path)) -Line ($index + 1)
        if ($patch.op -ceq 'define_macro' -and -not $defined.Add([string]$patch.name)) {
            throw "patch $([System.IO.Path]::GetFileName($path)):$($index + 1) — duplicate define_macro '$($patch.name)'"
        }
        $patches.Add($patch)
    }
    return [pscustomobject]@{ path = $path; identity = $identity; patches = $patches.ToArray() }
}

function Read-LatexPatchFile {
    param(
        [Parameter(Mandatory)] [Alias('Dir')] [ValidateNotNullOrEmpty()] [string]$DocumentDir,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$Slug,
        [Alias('ExpectedIdentity')] [AllowNull()] [AllowEmptyString()] [string]$ExpectedPatchIdentity = ''
    )
    $set = Read-LatexPatchSet -DocumentDir $DocumentDir -Slug $Slug `
        -ExpectedPatchIdentity $ExpectedPatchIdentity
    return @($set.patches)
}

function Get-LatexPatchDisplay {
    param([Parameter(Mandatory)] $Patch, [Parameter(Mandatory)] [string]$Slug)
    $lineProperty = $Patch.PSObject.Properties['line']
    if ($null -ne $lineProperty -and [int]$lineProperty.Value -gt 0) {
        return "patch[$Slug] line $([int]$lineProperty.Value)"
    }
    return "patch[$Slug]"
}

function Assert-PatchHits {
    param([int]$Hits, $Expect, [string]$What, [string]$Slug, $Patch)
    $display = if ($null -ne $Patch) { Get-LatexPatchDisplay -Patch $Patch -Slug $Slug } else { "patch[$Slug]" }
    if ($Hits -eq 0) {
        throw "$display $What is STALE — matched nothing in the source (upstream fixed it, or the converter drifted); review/remove the patch"
    }
    if ($null -ne $Expect -and [int]$Expect -ne $Hits) {
        throw "$display $What — expected $([int]$Expect) occurrence(s), found $Hits; review the patch"
    }
}

function New-LatexPatchRegex {
    param([Parameter(Mandatory)] [string]$Pattern, [Parameter(Mandatory)] $Patch,
        [Parameter(Mandatory)] [string]$Slug, [Parameter(Mandatory)] [string]$Operation)
    try {
        return [System.Text.RegularExpressions.Regex]::new(
            $Pattern,
            [System.Text.RegularExpressions.RegexOptions]::CultureInvariant,
            $script:LatexPatchRegexTimeout)
    } catch [System.ArgumentException] {
        $display = Get-LatexPatchDisplay -Patch $Patch -Slug $Slug
        throw "$display $Operation has an invalid regex: $($_.Exception.Message)"
    }
}

function Get-LatexPatchRegexMatchCount {
    param(
        [Parameter(Mandatory)] [System.Text.RegularExpressions.Regex]$Regex,
        [AllowEmptyString()] [string]$Text
    )
    $count = 0
    $match = $Regex.Match($Text)
    while ($match.Success) {
        $count++
        $match = $match.NextMatch()
    }
    return $count
}

function New-LatexPatchAudit {
    param([Parameter(Mandatory)] $Patch, [Parameter(Mandatory)] [System.Collections.IDictionary]$Operation)
    $audit = [ordered]@{}
    foreach ($key in $Operation.Keys) { $audit[$key] = $Operation[$key] }
    foreach ($key in @('class', 'reason', 'source_ref', 'authored_by', 'authored_utc')) {
        $audit[$key] = [string]$Patch.$key
    }
    $lineProperty = $Patch.PSObject.Properties['line']
    $audit['line'] = if ($null -ne $lineProperty) { [int]$lineProperty.Value } else { $null }
    return $audit
}

function Assert-LatexPatchRuntimeRecords {
    param([AllowNull()] [object[]]$Patches, [Parameter(Mandatory)] [string]$Slug)
    $defined = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($patch in @($Patches)) {
        if ($null -eq $patch) { throw "patch[$Slug] runtime record must not be null" }

        $names = [System.Collections.Generic.HashSet[string]]::new(
            [System.StringComparer]::OrdinalIgnoreCase)
        $fields = [System.Collections.Generic.Dictionary[string,object]]::new(
            [System.StringComparer]::Ordinal)
        if ($patch -is [System.Collections.IDictionary]) {
            foreach ($keyValue in $patch.Keys) {
                if ($keyValue -isnot [string]) { throw "patch[$Slug] runtime field names must be strings" }
                $name = [string]$keyValue
                if (-not $names.Add($name)) {
                    throw "patch[$Slug] runtime record has duplicate or case-colliding field '$name'"
                }
                $fields.Add($name, $patch[$keyValue])
            }
        } else {
            foreach ($property in $patch.PSObject.Properties) {
                if ($property.MemberType -notin @(
                        [System.Management.Automation.PSMemberTypes]::NoteProperty,
                        [System.Management.Automation.PSMemberTypes]::Property)) { continue }
                $name = [string]$property.Name
                if (-not $names.Add($name)) {
                    throw "patch[$Slug] runtime record has duplicate or case-colliding field '$name'"
                }
                $fields.Add($name, $property.Value)
            }
        }

        if (-not $fields.ContainsKey('op')) { throw "patch[$Slug] runtime record is missing 'op'" }
        if ($fields['op'] -isnot [string]) { throw "patch[$Slug] runtime 'op' must be a string" }
        $op = [string]$fields['op']
        if ($op -cnotin 'define_macro', 'source_replace', 'output_replace') {
            throw "patch[$Slug] runtime record has unknown op '$op'"
        }

        $display = "patch[$Slug]"
        if ($fields.ContainsKey('line')) {
            if ($fields['line'] -isnot [int] -or [int]$fields['line'] -le 0) {
                throw "$display runtime 'line' must be a positive integer"
            }
            $display += " line $([int]$fields['line'])"
        }

        $allowed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($name in @('op', 'reason', 'class', 'source_ref', 'authored_by', 'authored_utc', 'line')) {
            [void]$allowed.Add($name)
        }
        if ($op -ceq 'define_macro') {
            foreach ($name in @('name', 'body', 'expect_uses')) { [void]$allowed.Add($name) }
        } else {
            foreach ($name in @('find', 'replace', 'expect')) { [void]$allowed.Add($name) }
        }
        foreach ($name in $fields.Keys) {
            if (-not $allowed.Contains($name)) { throw "$display runtime record has unknown field '$name'" }
        }

        if (-not $fields.ContainsKey('reason')) { throw "$display runtime record is missing 'reason'" }
        if ($fields['reason'] -isnot [string] -or
            [string]::IsNullOrWhiteSpace([string]$fields['reason'])) {
            throw "$display runtime 'reason' must be a non-blank string"
        }
        foreach ($name in @('class', 'source_ref', 'authored_by', 'authored_utc')) {
            if ($fields.ContainsKey($name) -and $fields[$name] -isnot [string]) {
                throw "$display runtime '$name' must be a string"
            }
        }

        if ($op -ceq 'define_macro') {
            foreach ($name in @('name', 'body')) {
                if (-not $fields.ContainsKey($name)) { throw "$display define_macro is missing '$name'" }
                if ($fields[$name] -isnot [string]) { throw "$display define_macro '$name' must be a string" }
            }
            if ([string]$fields['name'] -cnotmatch '^\\[A-Za-z]+$') {
                throw "$display define_macro has an unsafe 'name'"
            }
            if (-not $defined.Add([string]$fields['name'])) {
                throw "$display duplicate define_macro '$([string]$fields['name'])'"
            }
            if ($fields.ContainsKey('expect_uses') -and
                ($fields['expect_uses'] -isnot [int] -or [int]$fields['expect_uses'] -le 0)) {
                throw "$display define_macro 'expect_uses' must be a positive integer"
            }
        } else {
            foreach ($name in @('find', 'replace')) {
                if (-not $fields.ContainsKey($name)) { throw "$display $op is missing '$name'" }
                if ($fields[$name] -isnot [string]) { throw "$display $op '$name' must be a string" }
            }
            if ([string]$fields['find'] -ceq '') { throw "$display $op 'find' must not be empty" }
            if ($fields.ContainsKey('expect') -and
                ($fields['expect'] -isnot [int] -or [int]$fields['expect'] -le 0)) {
                throw "$display $op 'expect' must be a positive integer"
            }
        }
    }
}

function Invoke-LatexSourcePatches {
    param([string]$Tex, [object[]]$Patches, [string]$Slug)
    Assert-LatexPatchRuntimeRecords -Patches $Patches -Slug $Slug
    $applied = [System.Collections.Generic.List[object]]::new()
    $defined = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $prefix = ''
    foreach ($patch in $Patches) {
        switch ([string]$patch.op) {
            'define_macro' {
                $name = [string]$patch.name
                $display = Get-LatexPatchDisplay -Patch $patch -Slug $Slug
                if ($name -cnotmatch '^\\[A-Za-z]+$') { throw "$display define_macro has an unsafe or missing 'name'" }
                if (-not $defined.Add($name)) { throw "$display duplicate define_macro '$name'" }
                $bare = $name.Substring(1)
                $escaped = [regex]::Escape($bare)
                $useRegex = New-LatexPatchRegex -Pattern ('\\' + $escaped + '(?![A-Za-z])') `
                    -Patch $patch -Slug $Slug -Operation 'define_macro use guard'
                $definitionRegex = New-LatexPatchRegex `
                    -Pattern ('\\(?:(?:(?:new|renew|provide)command)\*?\s*\{?\s*|def\s*|let\s*)\\' + $escaped + '(?![A-Za-z])') `
                    -Patch $patch -Slug $Slug -Operation 'define_macro definition guard'
                try {
                    $uses = Get-LatexPatchRegexMatchCount -Regex $useRegex -Text $Tex
                    $alreadyDefined = $definitionRegex.IsMatch($Tex)
                } catch [System.Text.RegularExpressions.RegexMatchTimeoutException] {
                    throw "$display define_macro regex timed out"
                }
                if ($alreadyDefined) {
                    throw "$display define_macro \$bare is STALE — the source ALREADY defines it (erratum redundant); review/remove the patch"
                }
                Assert-PatchHits -Hits $uses -Expect $patch.expect_uses `
                    -What "define_macro \$bare" -Slug $Slug -Patch $patch
                $prefix += "% codex-patch define_macro: $name`n\newcommand{$name}{$([string]$patch.body)}`n"
                $audit = New-LatexPatchAudit -Patch $patch -Operation ([ordered]@{
                        op = 'define_macro'; name = $name; body = [string]$patch.body; uses = $uses })
                $applied.Add($audit)
            }
            'source_replace' {
                $find = [string]$patch.find
                $display = Get-LatexPatchDisplay -Patch $patch -Slug $Slug
                if ($find.Length -eq 0) { throw "$display source_replace missing 'find'" }
                $regex = New-LatexPatchRegex -Pattern $find -Patch $patch -Slug $Slug -Operation 'source_replace'
                try {
                    $hits = Get-LatexPatchRegexMatchCount -Regex $regex -Text $Tex
                    Assert-PatchHits -Hits $hits -Expect $patch.expect `
                        -What "source_replace /$find/" -Slug $Slug -Patch $patch
                    $Tex = $regex.Replace($Tex, [string]$patch.replace)
                } catch [System.Text.RegularExpressions.RegexMatchTimeoutException] {
                    throw "$display source_replace regex timed out"
                }
                $audit = New-LatexPatchAudit -Patch $patch -Operation ([ordered]@{
                        op = 'source_replace'; find = $find; replace = [string]$patch.replace; hits = $hits })
                $applied.Add($audit)
            }
            'output_replace' { }
        }
    }
    if ($prefix) { $Tex = $prefix + $Tex }
    return @{ tex = $Tex; applied = $applied.ToArray() }
}

function Invoke-LatexOutputPatches {
    param([string]$Markdown, [object[]]$Patches, [string]$Slug)
    Assert-LatexPatchRuntimeRecords -Patches $Patches -Slug $Slug
    $applied = [System.Collections.Generic.List[object]]::new()
    foreach ($patch in $Patches) {
        if ([string]$patch.op -cne 'output_replace') { continue }
        $find = [string]$patch.find
        $display = Get-LatexPatchDisplay -Patch $patch -Slug $Slug
        if ($find.Length -eq 0) { throw "$display output_replace missing 'find'" }
        $regex = New-LatexPatchRegex -Pattern $find -Patch $patch -Slug $Slug -Operation 'output_replace'
        try {
            $hits = Get-LatexPatchRegexMatchCount -Regex $regex -Text $Markdown
            Assert-PatchHits -Hits $hits -Expect $patch.expect `
                -What "output_replace /$find/" -Slug $Slug -Patch $patch
            $Markdown = $regex.Replace($Markdown, [string]$patch.replace)
        } catch [System.Text.RegularExpressions.RegexMatchTimeoutException] {
            throw "$display output_replace regex timed out"
        }
        $audit = New-LatexPatchAudit -Patch $patch -Operation ([ordered]@{
                op = 'output_replace'; find = $find; replace = [string]$patch.replace; hits = $hits })
        $applied.Add($audit)
    }
    return @{ markdown = $Markdown; applied = $applied.ToArray() }
}
