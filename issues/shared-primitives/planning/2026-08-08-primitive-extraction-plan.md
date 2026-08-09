# Shared PS Primitive Extraction — Implementation Plan (Thread 1)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Lift the behavior-identical generic primitives out of `latex-patch.ps1` (and its duplicates in `latex-source.ps1` / `latex-inventory-row.ps1`) into three themed `src/shared` files, then repoint every consumer — with zero behavior change, pinned by tests.

**Architecture:** Three loose dot-sourced `.ps1` files, each a pure set of function definitions (no side effects, idempotent to source): `portable-path.ps1` (name/path safety), `file-bytes.ps1` (bounded read + content identity), `authored-jsonl.ps1` (tolerant reader + typed field extractors, built on the first two). Consumers dot-source what they need and call the generic names. Tests pin each primitive independently *before* any call site is repointed; the existing latex suites are the no-regression net.

**Tech Stack:** PowerShell 7, `System.Text.Json`, Pester 6, `tests/run.ps1` runner.

**Scope note — deferred:** `Test-PathWithinRoot` is intentionally NOT in this thread. Its two implementations diverge (`latex-source.ps1:50` case-folding `StartsWith` vs. the ordinal relative-path form in `latex-inventory-row.ps1:106` / `inventory-catalog.ps1:31`), so unifying it is a reconciliation with a real behavior decision, not a lift. Recorded as a follow-up in the ledger task.

**Canonical forms chosen (verified equivalent to what they replace):**
- `Test-PortableLeaf` = the regex form from `latex-inventory-row.ps1:25` (equivalent to `latex-patch.ps1:13` imperative char-walk).
- `Test-PathHasReparsePoint` = the segment-walk shared verbatim by all three copies.
- `Read-BoundedFileBytes` = `latex-patch.ps1:75` discipline, made self-contained (fetches its own `FileInfo`; `MaxBytes` a parameter).
- `Get-ContentIdentity` = `latex-patch.ps1:42`. `Test-ContentIdentityFormat` = the `^sha256:[0-9a-f]{64}$` check.

---

## File Structure

**Create:**
- `src/shared/portable-path.ps1` — `Test-PortableLeaf`, `Test-PathHasReparsePoint`
- `src/shared/file-bytes.ps1` — `Read-BoundedFileBytes`, `Get-ContentIdentity`, `Test-ContentIdentityFormat`
- `src/shared/authored-jsonl.ps1` — `Read-AuthoredJsonl`, `Assert-AuthoredJsonlIdentity`, `ConvertFrom-AuthoredJsonlObject`, `Get-JsonRequiredString`, `Get-JsonOptionalString`, `Get-JsonOptionalPositiveInteger`
- `tests/shared/portable-path.Tests.ps1`, `tests/shared/file-bytes.Tests.ps1`, `tests/shared/authored-jsonl.Tests.ps1`

**Modify (repoint, remove lifted functions):**
- `src/latex-ingest/latex-patch.ps1` — dot-source the three shared files; delete the lifted functions; `Read-LatexPatchSet` calls `Read-AuthoredJsonl`; `ConvertFrom-LatexPatchJsonLine` consumes pre-parsed `fields`.
- `src/latex-ingest/latex-source.ps1` — delete `Test-LatexPathHasReparsePoint`; dot-source `portable-path.ps1`; internal callers use `Test-PathHasReparsePoint`.
- `src/adapters/private/latex-inventory-row.ps1` — delete `Test-LatexBatchPortableLeaf`, `Test-LatexBatchPathHasReparsePoint`; dot-source `portable-path.ps1` + `file-bytes.ps1`; `Resolve-LatexBatchPatchRecord` uses `Read-BoundedFileBytes` + `Get-ContentIdentity`.
- `src/latex-ingest/source-deposit.ps1`, `src/logistics/latex-source-deposit.ps1` — rename `Test-LatexPathHasReparsePoint` → `Test-PathHasReparsePoint` at every call, **including the `${function:...}` transport capture at `latex-source-deposit.ps1:265`.**
- `src/adapters/workers/invoke-latex-ingest.ps1:18` — use `Test-ContentIdentityFormat` in place of the inline regex.

**Test run command (all tasks):** `& ./tests/run.ps1 -Path <container> -OutputVerbosity None` → expect a `PesterContainerObservation {…"failed":0…}` line.

---

## Task 1: `portable-path.ps1`

**Files:** Create `src/shared/portable-path.ps1`; Test `tests/shared/portable-path.Tests.ps1`

- [ ] **Step 1: Write the failing test.**

```powershell
#requires -Version 7.0
BeforeAll { . "$PSScriptRoot/../../src/shared/portable-path.ps1" }

Describe 'Test-PortableLeaf' {
    It 'accepts a plain leaf' { Test-PortableLeaf '2403.08110v4' | Should -BeTrue }
    It 'accepts a dotted leaf that only starts like a reserved name' { Test-PortableLeaf 'CONsole.tex' | Should -BeTrue }
    It 'rejects empty' { Test-PortableLeaf '' | Should -BeFalse }
    It 'rejects dot and dotdot' { Test-PortableLeaf '.' | Should -BeFalse; Test-PortableLeaf '..' | Should -BeFalse }
    It 'rejects trailing dot or space' { Test-PortableLeaf 'a.' | Should -BeFalse; Test-PortableLeaf 'a ' | Should -BeFalse }
    It 'rejects invalid characters' { Test-PortableLeaf 'a/b' | Should -BeFalse; Test-PortableLeaf 'a:b' | Should -BeFalse; Test-PortableLeaf 'a*b' | Should -BeFalse }
    It 'rejects reserved device names case-insensitively' { Test-PortableLeaf 'CON' | Should -BeFalse; Test-PortableLeaf 'com1' | Should -BeFalse; Test-PortableLeaf 'LPT9.txt' | Should -BeFalse }
    It 'accepts a non-reserved lookalike' { Test-PortableLeaf 'COM10' | Should -BeTrue }
}

Describe 'Test-PathHasReparsePoint' {
    It 'is false for a real directory tree' {
        $d = Join-Path $TestDrive 'plain/child'; New-Item -ItemType Directory -Force -Path $d | Out-Null
        Test-PathHasReparsePoint -Path $d | Should -BeFalse
    }
    It 'is false for a path whose tail does not exist yet' {
        Test-PathHasReparsePoint -Path (Join-Path $TestDrive 'nope/notyet') | Should -BeFalse
    }
}
```

- [ ] **Step 2: Run test, verify it fails.** Run `& ./tests/run.ps1 -Path tests/shared/portable-path.Tests.ps1 -OutputVerbosity None`. Expected: FAIL (`Test-PortableLeaf` not recognized).

- [ ] **Step 3: Create `src/shared/portable-path.ps1`.**

```powershell
#requires -Version 7.0
<#
  Portable path and name safety. No domain knowledge.

  Test-PortableLeaf         one path segment safe on Windows and POSIX.
  Test-PathHasReparsePoint  true when any existing component of a path is a symlink/junction/reparse point.
#>

function Test-PortableLeaf {
    param([Parameter(Mandatory)] [AllowEmptyString()] [string]$Value)
    $pattern = '^(?!(?i:(?:CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9]))(?:\.|\z))(?!\.{1,2}\z)(?!.*[ .]\z)[^<>:"/\\|?*\x00-\x1F]+\z'
    return [System.Text.RegularExpressions.Regex]::IsMatch(
        $Value, $pattern, [System.Text.RegularExpressions.RegexOptions]::CultureInvariant)
}

function Test-PathHasReparsePoint {
    param([Parameter(Mandatory)] [string]$Path)
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
```

- [ ] **Step 4: Run test, verify it passes.** Run the same command. Expected: `…"failed":0…`.

- [ ] **Step 5: Commit.** `git add src/shared/portable-path.ps1 tests/shared/portable-path.Tests.ps1 && git commit -m "shared-primitives: portable-path (Test-PortableLeaf, Test-PathHasReparsePoint)"`

---

## Task 2: `file-bytes.ps1`

**Files:** Create `src/shared/file-bytes.ps1`; Test `tests/shared/file-bytes.Tests.ps1`

- [ ] **Step 1: Write the failing test.**

```powershell
#requires -Version 7.0
BeforeAll { . "$PSScriptRoot/../../src/shared/file-bytes.ps1" }

Describe 'Get-ContentIdentity / Test-ContentIdentityFormat' {
    It 'hashes bytes to a lowercase sha256 identity' {
        Get-ContentIdentity -Bytes ([byte[]]@()) | Should -Be 'sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
    }
    It 'accepts a well-formed identity and rejects malformed' {
        Test-ContentIdentityFormat 'sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' | Should -BeTrue
        Test-ContentIdentityFormat 'absent' | Should -BeFalse
        Test-ContentIdentityFormat 'sha256:ABCD' | Should -BeFalse
    }
}

Describe 'Read-BoundedFileBytes' {
    It 'reads a small file whole' {
        $p = Join-Path $TestDrive 'a.txt'; [System.IO.File]::WriteAllText($p, 'hello', [System.Text.UTF8Encoding]::new($false))
        (Read-BoundedFileBytes -Path $p -MaxBytes 1MB).Length | Should -Be 5
    }
    It 'throws when the file exceeds MaxBytes' {
        $p = Join-Path $TestDrive 'big.bin'; [System.IO.File]::WriteAllBytes($p, [byte[]]::new(11))
        { Read-BoundedFileBytes -Path $p -MaxBytes 10 } | Should -Throw '*exceeds*'
    }
    It 'throws on a missing file' {
        { Read-BoundedFileBytes -Path (Join-Path $TestDrive 'no.txt') -MaxBytes 1MB } | Should -Throw
    }
}
```

- [ ] **Step 2: Run test, verify it fails.** `& ./tests/run.ps1 -Path tests/shared/file-bytes.Tests.ps1 -OutputVerbosity None`. Expected: FAIL.

- [ ] **Step 3: Create `src/shared/file-bytes.ps1`.**

```powershell
#requires -Version 7.0
<#
  Bounded file reads and content identity over raw bytes. No domain knowledge.
#>

function Read-BoundedFileBytes {
    param(
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$Path,
        [Parameter(Mandatory)] [long]$MaxBytes
    )
    $entry = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    if ($entry -isnot [System.IO.FileInfo]) { throw "Not a file: '$Path'" }
    $observedLength = [long]$entry.Length
    if ($observedLength -gt $MaxBytes) { throw "File exceeds the $MaxBytes-byte limit: '$Path'" }

    $stream = [System.IO.FileStream]::new(
        $Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read,
        [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
    try {
        $length = [long]$stream.Length
        if ($length -ne $observedLength) { throw "File changed length before its bounded read: '$Path'" }
        if ($length -gt $MaxBytes) { throw "File exceeds the $MaxBytes-byte limit: '$Path'" }
        $bytes = [byte[]]::new([int]$length)
        $offset = 0
        while ($offset -lt $bytes.Length) {
            $read = $stream.Read($bytes, $offset, $bytes.Length - $offset)
            if ($read -eq 0) { throw "File shrank during its bounded read: '$Path'" }
            $offset += $read
        }
        if ($stream.ReadByte() -ne -1 -or [long]$stream.Length -ne $length) {
            throw "File grew during its bounded read: '$Path'"
        }
        return ,$bytes
    } finally { $stream.Dispose() }
}

function Get-ContentIdentity {
    param([Parameter(Mandatory)] [AllowEmptyCollection()] [byte[]]$Bytes)
    $hash = [System.Security.Cryptography.SHA256]::HashData($Bytes)
    return 'sha256:' + [System.BitConverter]::ToString($hash).Replace('-', '').ToLowerInvariant()
}

function Test-ContentIdentityFormat {
    param([AllowNull()] [AllowEmptyString()] [string]$Value)
    return $Value -cmatch '^sha256:[0-9a-f]{64}$'
}
```

- [ ] **Step 4: Run test, verify it passes.** Expected: `…"failed":0…`.

- [ ] **Step 5: Commit.** `git add src/shared/file-bytes.ps1 tests/shared/file-bytes.Tests.ps1 && git commit -m "shared-primitives: file-bytes (bounded read, content identity)"`

---

## Task 3: `authored-jsonl.ps1`

**Files:** Create `src/shared/authored-jsonl.ps1`; Test `tests/shared/authored-jsonl.Tests.ps1`

- [ ] **Step 1: Write the failing test.**

```powershell
#requires -Version 7.0
BeforeAll {
    . "$PSScriptRoot/../../src/shared/authored-jsonl.ps1"
    function Write-Jsonl([string]$Name, [string]$Text) {
        $p = Join-Path $TestDrive $Name
        [System.IO.File]::WriteAllText($p, $Text, [System.Text.UTF8Encoding]::new($false)); return $p
    }
}

Describe 'Read-AuthoredJsonl' {
    It 'returns absent + no records when the file is missing' {
        $r = Read-AuthoredJsonl -Path (Join-Path $TestDrive 'nope.jsonl') -MaxBytes 1MB
        $r.identity | Should -Be 'absent'; $r.records | Should -HaveCount 0
    }
    It 'tolerates blanks, # and // comments, LF/CRLF, no final newline; keeps 1-based lines' {
        $p = Write-Jsonl 'a.jsonl' "  # c`r`n`n  // c2`n{`"op`":`"x`",`"n`":1}"
        $r = Read-AuthoredJsonl -Path $p -MaxBytes 1MB
        $r.records | Should -HaveCount 1
        $r.records[0].line | Should -Be 4
        (Get-JsonRequiredString -Fields $r.records[0].fields -Name 'op' -Display 'd') | Should -Be 'x'
    }
    It 'rejects a BOM, a bare CR, a non-object line, and duplicate keys' {
        $bom = Join-Path $TestDrive 'bom.jsonl'
        [System.IO.File]::WriteAllBytes($bom, ([byte[]]@(0xEF,0xBB,0xBF) + [System.Text.Encoding]::UTF8.GetBytes('{"a":1}')))
        { Read-AuthoredJsonl -Path $bom -MaxBytes 1MB } | Should -Throw '*without a BOM*'
        { Read-AuthoredJsonl -Path (Write-Jsonl 'cr.jsonl' "a`rb") -MaxBytes 1MB } | Should -Throw '*bare CR*'
        { Read-AuthoredJsonl -Path (Write-Jsonl 'arr.jsonl' '[1,2]') -MaxBytes 1MB } | Should -Throw '*must be one object*'
        { Read-AuthoredJsonl -Path (Write-Jsonl 'dup.jsonl' '{"A":1,"a":2}') -MaxBytes 1MB } | Should -Throw '*duplicate or case-colliding*'
    }
    It 'asserts an expected identity and reports drift' {
        $p = Write-Jsonl 'id.jsonl' '{"a":1}'
        $good = (Read-AuthoredJsonl -Path $p -MaxBytes 1MB).identity
        { Read-AuthoredJsonl -Path $p -MaxBytes 1MB -ExpectedIdentity $good } | Should -Not -Throw
        { Read-AuthoredJsonl -Path $p -MaxBytes 1MB -ExpectedIdentity 'sha256:0000000000000000000000000000000000000000000000000000000000000000' } | Should -Throw '*drift*'
    }
}

Describe 'field extractors' {
    It 'required string present / typed / missing' {
        $p = Write-Jsonl 'f.jsonl' '{"s":"v","n":3}'
        $f = (Read-AuthoredJsonl -Path $p -MaxBytes 1MB).records[0].fields
        Get-JsonRequiredString -Fields $f -Name 's' -Display 'd' | Should -Be 'v'
        { Get-JsonRequiredString -Fields $f -Name 'n' -Display 'd' } | Should -Throw '*must be a JSON string*'
        { Get-JsonRequiredString -Fields $f -Name 'x' -Display 'd' } | Should -Throw "*missing 'x'*"
        Get-JsonOptionalString -Fields $f -Name 'x' -Display 'd' | Should -Be ''
        Get-JsonOptionalPositiveInteger -Fields $f -Name 'n' -Display 'd' | Should -Be 3
    }
}
```

- [ ] **Step 2: Run test, verify it fails.** `& ./tests/run.ps1 -Path tests/shared/authored-jsonl.Tests.ps1 -OutputVerbosity None`. Expected: FAIL.

- [ ] **Step 3: Create `src/shared/authored-jsonl.ps1`.**

```powershell
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
        $names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $fields = [System.Collections.Generic.Dictionary[string,System.Text.Json.JsonElement]]::new([System.StringComparer]::Ordinal)
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
```

- [ ] **Step 4: Run test, verify it passes.** Expected: `…"failed":0…`.

- [ ] **Step 5: Commit.** `git add src/shared/authored-jsonl.ps1 tests/shared/authored-jsonl.Tests.ps1 && git commit -m "shared-primitives: authored-jsonl (tolerant reader + field extractors)"`

---

## Task 4: Repoint `latex-patch.ps1` onto the shared primitives

**Files:** Modify `src/latex-ingest/latex-patch.ps1`; regression `tests/latex-ingest/latex-patch.Tests.ps1` (unchanged — the net).

- [ ] **Step 1: Confirm the baseline is green.** `& ./tests/run.ps1 -Path tests/latex-ingest/latex-patch.Tests.ps1 -OutputVerbosity None`. Expected: `…"passed":22,"failed":0…`.

- [ ] **Step 2: Add the dot-sources** at the top of `latex-patch.ps1` (after the `#requires` header comment, before `$script:LatexPatchRegexTimeout`):

```powershell
. "$PSScriptRoot/../shared/portable-path.ps1"
. "$PSScriptRoot/../shared/file-bytes.ps1"
. "$PSScriptRoot/../shared/authored-jsonl.ps1"
```

- [ ] **Step 3: Delete the now-shared functions** from `latex-patch.ps1`: `Test-LatexPatchPortableLeaf`, `Test-LatexPatchPathHasReparsePoint`, `Get-LatexPatchRawIdentity`, `Get-LatexPatchItemOrNull`, `Read-LatexPatchBoundedBytes`, `Assert-LatexPatchIdentity`, `Get-LatexPatchRequiredString`, `Get-LatexPatchOptionalString`, `Get-LatexPatchOptionalGuard`.

- [ ] **Step 4: Repoint `Get-LatexPatchPath`** — change `Test-LatexPatchPortableLeaf -Value $Slug` to `Test-PortableLeaf -Value $Slug`.

- [ ] **Step 5: Rewrite `ConvertFrom-LatexPatchJsonLine`** to consume pre-parsed `fields` instead of parsing JSON. New signature and body:

```powershell
function ConvertFrom-LatexPatchRecord {
    param(
        [Parameter(Mandatory)] $Fields,
        [Parameter(Mandatory)] [string]$Display,
        [Parameter(Mandatory)] [int]$Line
    )
    $op = Get-JsonRequiredString -Fields $Fields -Name 'op' -Display $Display
    if ($op -cnotin 'define_macro', 'source_replace', 'output_replace') {
        throw "$Display — unknown op '$op' (want define_macro | source_replace | output_replace)"
    }
    $reason = Get-JsonRequiredString -Fields $Fields -Name 'reason' -Display $Display
    if ([string]::IsNullOrWhiteSpace($reason)) { throw "$Display — missing 'reason' (every erratum must be justified)" }

    $allowed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($name in @('op', 'reason', 'class', 'source_ref', 'authored_by', 'authored_utc')) { [void]$allowed.Add($name) }
    if ($op -ceq 'define_macro') { foreach ($name in @('name', 'body', 'expect_uses')) { [void]$allowed.Add($name) } }
    else { foreach ($name in @('find', 'replace', 'expect')) { [void]$allowed.Add($name) } }
    foreach ($name in $Fields.Keys) { if (-not $allowed.Contains($name)) { throw "$Display — unknown field '$name' for op '$op'" } }

    $record = [ordered]@{
        op           = $op
        reason       = $reason
        class        = Get-JsonOptionalString -Fields $Fields -Name 'class' -Display $Display
        source_ref   = Get-JsonOptionalString -Fields $Fields -Name 'source_ref' -Display $Display
        authored_by  = Get-JsonOptionalString -Fields $Fields -Name 'authored_by' -Display $Display
        authored_utc = Get-JsonOptionalString -Fields $Fields -Name 'authored_utc' -Display $Display
    }
    if ($op -ceq 'define_macro') {
        $name = Get-JsonRequiredString -Fields $Fields -Name 'name' -Display $Display
        if ($name -cnotmatch '^\\[A-Za-z]+$') { throw "$Display — 'name' must be one TeX control word such as \vect" }
        $record['name'] = $name
        $record['body'] = Get-JsonRequiredString -Fields $Fields -Name 'body' -Display $Display
        if ($Fields.ContainsKey('expect_uses')) { $record['expect_uses'] = Get-JsonOptionalPositiveInteger -Fields $Fields -Name 'expect_uses' -Display $Display }
    } else {
        $find = Get-JsonRequiredString -Fields $Fields -Name 'find' -Display $Display
        if ($find.Length -eq 0) { throw "$Display — 'find' must not be empty" }
        $record['find'] = $find
        $record['replace'] = Get-JsonRequiredString -Fields $Fields -Name 'replace' -Display $Display
        if ($Fields.ContainsKey('expect')) { $record['expect'] = Get-JsonOptionalPositiveInteger -Fields $Fields -Name 'expect' -Display $Display }
    }
    $record['line'] = $Line
    return [pscustomobject]$record
}
```

- [ ] **Step 6: Rewrite `Read-LatexPatchSet`** to build the path then delegate reading to the shared reader, mapping records through the op vocabulary:

```powershell
function Read-LatexPatchSet {
    param(
        [Parameter(Mandatory)] [Alias('Dir')] [ValidateNotNullOrEmpty()] [string]$DocumentDir,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()] [string]$Slug,
        [Alias('ExpectedIdentity')] [AllowNull()] [AllowEmptyString()] [string]$ExpectedPatchIdentity = ''
    )
    $path = Get-LatexPatchPath -DocumentDir $DocumentDir -Slug $Slug
    $authored = Read-AuthoredJsonl -Path $path -MaxBytes $script:LatexPatchMaximumBytes -ExpectedIdentity $ExpectedPatchIdentity
    $patches = [System.Collections.Generic.List[object]]::new()
    $defined = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $fileName = [System.IO.Path]::GetFileName($path)
    foreach ($rec in $authored.records) {
        $patch = ConvertFrom-LatexPatchRecord -Fields $rec.fields -Display "patch $fileName`:$($rec.line)" -Line $rec.line
        if ($patch.op -ceq 'define_macro' -and -not $defined.Add([string]$patch.name)) {
            throw "patch $fileName`:$($rec.line) — duplicate define_macro '$($patch.name)'"
        }
        $patches.Add($patch)
    }
    return [pscustomobject]@{ path = $path; identity = $authored.identity; patches = $patches.ToArray() }
}
```

- [ ] **Step 7: Run the regression.** `& ./tests/run.ps1 -Path tests/latex-ingest/latex-patch.Tests.ps1 -OutputVerbosity None`. Expected: `…"passed":22,"failed":0…`. If a message-text assertion fails because the generic reader dropped a `patch ` prefix, restore the exact expected substring by adjusting the `-Display` value passed from `Read-LatexPatchSet` (the domain layer owns the display prefix).

- [ ] **Step 8: Commit.** `git add src/latex-ingest/latex-patch.ps1 && git commit -m "latex-patch: consume shared portable-path/file-bytes/authored-jsonl primitives"`

---

## Task 5: Repoint `latex-source.ps1` and its deposit callers

**Files:** Modify `src/latex-ingest/latex-source.ps1`, `src/latex-ingest/source-deposit.ps1`, `src/logistics/latex-source-deposit.ps1`. Regression: the latex-source + deposit containers.

- [ ] **Step 1: Baseline green.** Run `& ./tests/run.ps1 -Path tests/latex-ingest/source-deposit.Tests.ps1 -OutputVerbosity None` and `& ./tests/run.ps1 -Path tests/latex-ingest/latex-source-deposit.Tests.ps1 -OutputVerbosity None`. Record the passing counts.

- [ ] **Step 2:** In `latex-source.ps1`, add `. "$PSScriptRoot/../shared/portable-path.ps1"` after the header block (line 8), and delete `Test-LatexPathHasReparsePoint` (lines 31-48).

- [ ] **Step 3:** Repoint the internal caller `Assert-LatexSourceTreeHasNoReparsePoint` (and any other `Test-LatexPathHasReparsePoint` call in `latex-source.ps1`) to `Test-PathHasReparsePoint`. Leave the tree-recursive `Get-ChildItem -Attributes ReparsePoint` scans unchanged.

- [ ] **Step 4:** In `source-deposit.ps1`, rename every `Test-LatexPathHasReparsePoint` call to `Test-PathHasReparsePoint` (grep: lines 73, 91, 106, 113, 248, 249, 287, 325). Add the dot-source `. "$PSScriptRoot/../shared/portable-path.ps1"` at the top if `source-deposit.ps1` does not already load `latex-source.ps1`.

- [ ] **Step 5:** In `logistics/latex-source-deposit.ps1`, rename every `Test-LatexPathHasReparsePoint` call (lines 130, 164, 287, 325) **and the transport capture at line 265** `$testReparsePath = ${function:Test-LatexPathHasReparsePoint}` → `${function:Test-PathHasReparsePoint}`. Ensure `portable-path.ps1` is dot-sourced in whatever context that captured function is re-injected (child bootstrap): verify the child receives `Test-PathHasReparsePoint`.

- [ ] **Step 6: Run the deposit regressions** (both containers from Step 1) plus `& ./tests/run.ps1 -Path tests/latex-ingest/latex-source.Tests.ps1 -OutputVerbosity None` if it exists. Expected: same passing counts as baseline, 0 failed.

- [ ] **Step 7: Add the child-path reparse witness** to the deposit test container that exercises the transported function — an `It` proving the batch/child deposit path still refuses a reparse-point document root (the §6a risk). Run it; expect PASS (Administrator-gated symlink branch may skip).

- [ ] **Step 8: Commit.** `git add src/latex-ingest/latex-source.ps1 src/latex-ingest/source-deposit.ps1 src/logistics/latex-source-deposit.ps1 tests/latex-ingest/*deposit*.Tests.ps1 && git commit -m "latex-source/deposit: consume shared Test-PathHasReparsePoint (incl. transported capture)"`

---

## Task 6: Repoint the adapter `latex-inventory-row.ps1`

**Files:** Modify `src/adapters/private/latex-inventory-row.ps1`, `src/adapters/workers/invoke-latex-ingest.ps1`. Regression: `tests/adapters/latex-batch.Tests.ps1`.

- [ ] **Step 1: Baseline green.** `& ./tests/run.ps1 -Path tests/adapters/latex-batch.Tests.ps1 -OutputVerbosity None`. Expected: `…"passed":10,"failed":0…`.

- [ ] **Step 2:** Add at the top of `latex-inventory-row.ps1` (before `$script:LatexBatchPatchMaxBytes`): `. "$PSScriptRoot/../../shared/portable-path.ps1"` and `. "$PSScriptRoot/../../shared/file-bytes.ps1"`. Delete `Test-LatexBatchPortableLeaf` (21-30) and `Test-LatexBatchPathHasReparsePoint` (32-48). Keep `Test-LatexBatchPathWithinRoot` (the deferred primitive).

- [ ] **Step 3:** Repoint callers: `Test-LatexBatchPortableLeaf` → `Test-PortableLeaf` (line 266); `Test-LatexBatchPathHasReparsePoint` → `Test-PathHasReparsePoint` (lines 138, 233).

- [ ] **Step 4: Replace the bounded incremental hash** in `Resolve-LatexBatchPatchRecord` (lines 159-189) with the shared primitives, preserving the `absent`/`sha256:` contract:

```powershell
    $bytes = Read-BoundedFileBytes -Path $patchPath -MaxBytes $script:LatexBatchPatchMaxBytes
    $identity = Get-ContentIdentity -Bytes $bytes
```
Then set `Identity = $identity` in the returned object (drop the manual `"sha256:$hash"` assembly and the `IncrementalHash` block). Keep the `absent` early return and the reparse/within-root guards above it.

- [ ] **Step 5:** In `invoke-latex-ingest.ps1`, replace the inline `$ExpectedPatchIdentity -cnotmatch '^sha256:[0-9a-f]{64}$'` (line 18) with `-not (Test-ContentIdentityFormat -Value $ExpectedPatchIdentity)` and add `. "$PSScriptRoot/../../shared/file-bytes.ps1"` at the top of that file.

- [ ] **Step 6: Run the regression.** `& ./tests/run.ps1 -Path tests/adapters/latex-batch.Tests.ps1 -OutputVerbosity None`. Expected: `…"passed":10,"failed":0…` (the Administrator-gated symlink branch may still skip).

- [ ] **Step 7: Commit.** `git add src/adapters/private/latex-inventory-row.ps1 src/adapters/workers/invoke-latex-ingest.ps1 && git commit -m "latex-batch adapter: consume shared portable-path/file-bytes primitives"`

---

## Task 7: Full regression + topology + ledger

**Files:** Run-only, plus create `issues/shared-primitives/planning/ledger.md`.

- [ ] **Step 1: Run the whole affected set.**

```powershell
$c = @(
  'tests/shared/portable-path.Tests.ps1','tests/shared/file-bytes.Tests.ps1','tests/shared/authored-jsonl.Tests.ps1',
  'tests/latex-ingest/latex-patch.Tests.ps1','tests/adapters/latex-batch.Tests.ps1',
  'tests/latex-ingest/latex-ingest-integration.Tests.ps1','tests/infrastructure/path-topology.Tests.ps1')
foreach ($p in $c) { & ./tests/run.ps1 -Path $p -OutputVerbosity None }
```
Expected: every `PesterContainerObservation` line shows `"failed":0`. The topology test's four pre-existing retired-JSONL-v2 references remain the only documented reds; the new `src/shared/*.ps1` files must introduce no new topology violation.

- [ ] **Step 2: AST parse + diff hygiene.** Run the repo's standard changed-`.ps1` AST parse and `git diff --check`; expect zero parse errors and no whitespace errors.

- [ ] **Step 3: Grep for stragglers.** `rg -n 'Test-LatexPatchPortableLeaf|Test-LatexPatchPathHasReparsePoint|Get-LatexPatchRawIdentity|Read-LatexPatchBoundedBytes|Test-LatexBatchPortableLeaf|Test-LatexBatchPathHasReparsePoint|Assert-LatexPatchIdentity' src tests` → expect no matches outside comments/graveyard.

- [ ] **Step 4: Create `issues/shared-primitives/planning/ledger.md`** recording what landed (the three shared files, the consumers repointed) and the **deferred follow-up**: unify `Test-PathWithinRoot` (divergent case-fold vs ordinal-relative semantics; needs a reconciliation decision before lifting).

- [ ] **Step 5: Commit.** `git add issues/shared-primitives/planning/ledger.md && git commit -m "shared-primitives: ledger — thread 1 landed; Test-PathWithinRoot deferred"`

---

## Self-review notes

- **Spec coverage:** portable-leaf ✓ (T1), reparse ✓ (T1), bounded read ✓ (T2), content identity + format ✓ (T2), authored-jsonl reader + extractors ✓ (T3), latex-patch rewire ✓ (T4), latex-source/deposit rewire incl. transport capture ✓ (T5, §6a), adapter rewire ✓ (T6), full regression/topology ✓ (T7). Spec's `Test-PathWithinRoot` intentionally deferred (documented, T7 ledger).
- **Type consistency:** `Read-AuthoredJsonl` returns `{ path; identity; records=[{line, fields}] }`; `Read-LatexPatchSet` returns `{ path; identity; patches }` (unchanged external shape) — its callers see no difference. `ConvertFrom-LatexPatchRecord` replaces `ConvertFrom-LatexPatchJsonLine` (JSON parsing moved into the shared reader).
- **Behavior preservation:** every new shared function is a verbatim/equivalent lift of code proven identical in the spec's §5; the only surface change is error-message prefixes, absorbed by the `-Display` argument the domain layer supplies.
