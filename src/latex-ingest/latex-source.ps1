#requires -Version 7.0
<#
  Source-only LaTeX deposit primitives.

  This file deliberately has no dependency on the latex-ingest converter or its render/audit stack.
  It can therefore be used by prerequisite source housekeeping, procurement, and later ingestion
  orchestration without starting a conversion run.
#>

. "$PSScriptRoot/../shared/portable-path.ps1"

function Get-LatexPathComparison {
    if ($IsWindows) { return [System.StringComparison]::OrdinalIgnoreCase }
    return [System.StringComparison]::Ordinal
}

function Get-LatexPathComparer {
    if ($IsWindows) { return [System.StringComparer]::OrdinalIgnoreCase }
    return [System.StringComparer]::Ordinal
}

function Test-LatexPathsEqual {
    param(
        [Parameter(Mandatory)] [string]$Left,
        [Parameter(Mandatory)] [string]$Right
    )
    return [System.IO.Path]::GetFullPath($Left).Equals(
        [System.IO.Path]::GetFullPath($Right),
        (Get-LatexPathComparison)
    )
}

function Test-LatexPathWithinRoot {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string]$Root
    )
    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $fullRoot = [System.IO.Path]::GetFullPath($Root)
    $comparison = Get-LatexPathComparison
    if ($fullPath.Equals($fullRoot, $comparison)) { return $true }
    $rootPrefix = if ($fullRoot.EndsWith([System.IO.Path]::DirectorySeparatorChar) -or
        $fullRoot.EndsWith([System.IO.Path]::AltDirectorySeparatorChar)) {
        $fullRoot
    } else {
        $fullRoot + [System.IO.Path]::DirectorySeparatorChar
    }
    return $fullPath.StartsWith($rootPrefix, $comparison)
}

function Remove-LatexPrivatePath {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string]$ExpectedParent
    )
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $parent = [System.IO.Path]::GetFullPath($ExpectedParent)
    if (-not (Test-LatexPathWithinRoot -Path $fullPath -Root $parent) -or
        (Test-LatexPathsEqual -Left $fullPath -Right $parent)) {
        throw "refusing to remove private source path outside its expected parent: '$fullPath'"
    }
    Remove-Item -LiteralPath $fullPath -Recurse -Force
}

function Read-LatexSourceText {
    param([Parameter(Mandatory)] [string]$Path)
    $strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
    try {
        return [System.IO.File]::ReadAllText($Path, $strictUtf8)
    } catch [System.Text.DecoderFallbackException] {
        throw "LaTeX source is not valid UTF-8: '$Path'"
    }
}

function Remove-LatexLineComments {
    param([AllowEmptyString()] [string]$Text)
    if ([string]::IsNullOrEmpty($Text)) { return $Text }
    $lines = $Text -split '\r?\n'
    for ($lineIndex = 0; $lineIndex -lt $lines.Count; $lineIndex++) {
        $line = $lines[$lineIndex]
        for ($i = 0; $i -lt $line.Length; $i++) {
            if ($line[$i] -ne '%') { continue }
            $slashes = 0
            for ($j = $i - 1; $j -ge 0 -and $line[$j] -eq '\'; $j--) { $slashes++ }
            if (($slashes % 2) -eq 0) {
                $lines[$lineIndex] = $line.Substring(0, $i)
                break
            }
        }
    }
    return ($lines -join "`n")
}

function ConvertTo-LatexArchiveRelativePath {
    param(
        [Parameter(Mandatory)] [string]$EntryName,
        [Parameter(Mandatory)] [string]$DestinationRoot
    )
    if ([string]::IsNullOrWhiteSpace($EntryName) -or $EntryName.IndexOf([char]0) -ge 0) {
        throw 'source archive contains an empty or NUL-bearing member name'
    }
    if ($EntryName -match '^[\\/]' -or $EntryName -match '^[A-Za-z]:' -or
        [System.IO.Path]::IsPathRooted($EntryName)) {
        throw "source archive contains a rooted member path: '$EntryName'"
    }

    $segments = @($EntryName -split '[\\/]+')
    $clean = [System.Collections.Generic.List[string]]::new()
    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
    foreach ($segment in $segments) {
        if ([string]::IsNullOrEmpty($segment) -or $segment -eq '.') { continue }
        if ($segment -eq '..') { throw "source archive member escapes its root: '$EntryName'" }
        for ($characterIndex = 0; $characterIndex -lt $segment.Length; $characterIndex++) {
            $character = $segment[$characterIndex]
            if ([char]::IsHighSurrogate($character)) {
                if ($characterIndex + 1 -ge $segment.Length -or
                    -not [char]::IsLowSurrogate($segment[$characterIndex + 1])) {
                    throw "source archive member contains an unpaired Unicode surrogate: '$EntryName'"
                }
                $characterIndex++
            } elseif ([char]::IsLowSurrogate($character)) {
                throw "source archive member contains an unpaired Unicode surrogate: '$EntryName'"
            }
        }
        if ($segment.IndexOfAny($invalidChars) -ge 0) {
            throw "source archive member is not portable to this filesystem: '$EntryName'"
        }
        if ($IsWindows -and $segment.TrimEnd(' ', '.') -ne $segment) {
            throw "source archive member has a Windows-ambiguous name: '$EntryName'"
        }
        if ($IsWindows) {
            $deviceStem = ($segment -split '\.', 2)[0]
            if ($deviceStem -match '^(?i:CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])$') {
                throw "source archive member uses a reserved Windows device name: '$EntryName'"
            }
        }
        $clean.Add($segment)
    }
    if ($clean.Count -eq 0) { return '' }

    $relative = [string]::Join([System.IO.Path]::DirectorySeparatorChar, $clean)
    $candidate = [System.IO.Path]::GetFullPath((Join-Path $DestinationRoot $relative))
    if (-not (Test-LatexPathWithinRoot -Path $candidate -Root $DestinationRoot)) {
        throw "source archive member escapes its root after normalization: '$EntryName'"
    }
    return $relative
}

function Get-LatexTarInventory {
    param(
        [Parameter(Mandatory)] [string]$PayloadPath,
        [Parameter(Mandatory)] [string]$DestinationRoot,
        [long]$MaxExpandedBytes = 4GB,
        [int]$MaxEntries = 100000
    )
    $items = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $stream = [System.IO.File]::OpenRead($PayloadPath)
    $reader = $null
    $sawEntry = $false
    $entryCount = 0
    $expandedBytes = 0L
    try {
        $reader = [System.Formats.Tar.TarReader]::new($stream, $true)
        while ($null -ne ($entry = $reader.GetNextEntry())) {
            $sawEntry = $true
            $entryCount++
            if ($entryCount -gt $MaxEntries) { throw "source archive exceeds the $MaxEntries member limit" }

            $type = [System.Formats.Tar.TarEntryType]$entry.EntryType
            if ($type -in @(
                    [System.Formats.Tar.TarEntryType]::GlobalExtendedAttributes,
                    [System.Formats.Tar.TarEntryType]::ExtendedAttributes,
                    [System.Formats.Tar.TarEntryType]::LongLink,
                    [System.Formats.Tar.TarEntryType]::LongPath
                )) {
                continue
            }
            if ($type -notin @(
                    [System.Formats.Tar.TarEntryType]::Directory,
                    [System.Formats.Tar.TarEntryType]::V7RegularFile,
                    [System.Formats.Tar.TarEntryType]::RegularFile,
                    [System.Formats.Tar.TarEntryType]::ContiguousFile
                )) {
                throw "source archive contains unsupported or unsafe member type '$type': '$($entry.Name)'"
            }

            $relative = ConvertTo-LatexArchiveRelativePath -EntryName $entry.Name -DestinationRoot $DestinationRoot
            if (-not $relative) { continue }
            if (-not $seen.Add($relative)) {
                throw "source archive contains duplicate or case-colliding member path: '$($entry.Name)'"
            }
            if ($type -ne [System.Formats.Tar.TarEntryType]::Directory) {
                $expandedBytes += [long]$entry.Length
                if ($expandedBytes -gt $MaxExpandedBytes) {
                    throw "source archive exceeds the $MaxExpandedBytes byte expansion limit"
                }
            }
            $items.Add([pscustomobject]@{
                    relative_path = $relative
                    entry_type   = $type.ToString()
                    length       = [long]$entry.Length
                })
        }
    } finally {
        if ($reader) { $reader.Dispose() }
        $stream.Dispose()
    }
    return [pscustomobject]@{
        is_tar         = $sawEntry
        entries        = $items.ToArray()
        expanded_bytes = $expandedBytes
    }
}

function Test-LatexTarPayload {
    param([Parameter(Mandatory)] [string]$PayloadPath)
    $stream = [System.IO.File]::OpenRead($PayloadPath)
    try {
        if ($stream.Length -lt 512) { return $false }
        $header = [byte[]]::new(512)
        if ($stream.Read($header, 0, $header.Length) -ne $header.Length) { return $false }
    } finally {
        $stream.Dispose()
    }
    $nonzero = $false
    for ($i = 0; $i -lt $header.Length; $i++) {
        if ($header[$i] -ne 0) { $nonzero = $true; break }
    }
    if (-not $nonzero) { return $false }

    $checksumText = [System.Text.Encoding]::ASCII.GetString($header, 148, 8).Trim([char]0, ' ')
    if ($checksumText -notmatch '^[0-7]+$') { return $false }
    try { $expected = [Convert]::ToInt64($checksumText, 8) } catch { return $false }
    $actual = 0L
    for ($i = 0; $i -lt $header.Length; $i++) {
        $actual += if ($i -ge 148 -and $i -lt 156) { 0x20 } else { $header[$i] }
    }
    return $actual -eq $expected
}

function Expand-LatexTarPayload {
    param(
        [Parameter(Mandatory)] [string]$PayloadPath,
        [Parameter(Mandatory)] [string]$DestinationRoot
    )
    $stream = [System.IO.File]::OpenRead($PayloadPath)
    $reader = [System.Formats.Tar.TarReader]::new($stream, $true)
    try {
        while ($null -ne ($entry = $reader.GetNextEntry())) {
            $type = [System.Formats.Tar.TarEntryType]$entry.EntryType
            if ($type -in @(
                    [System.Formats.Tar.TarEntryType]::GlobalExtendedAttributes,
                    [System.Formats.Tar.TarEntryType]::ExtendedAttributes,
                    [System.Formats.Tar.TarEntryType]::LongLink,
                    [System.Formats.Tar.TarEntryType]::LongPath
                )) {
                continue
            }
            $relative = ConvertTo-LatexArchiveRelativePath -EntryName $entry.Name -DestinationRoot $DestinationRoot
            if (-not $relative) { continue }
            $target = Join-Path $DestinationRoot $relative
            if ($type -eq [System.Formats.Tar.TarEntryType]::Directory) {
                [System.IO.Directory]::CreateDirectory($target) | Out-Null
                continue
            }
            $parent = Split-Path -Parent $target
            [System.IO.Directory]::CreateDirectory($parent) | Out-Null
            $output = [System.IO.FileStream]::new(
                $target,
                [System.IO.FileMode]::CreateNew,
                [System.IO.FileAccess]::Write,
                [System.IO.FileShare]::None
            )
            try {
                if ($entry.DataStream) { $entry.DataStream.CopyTo($output) }
                $output.Flush($true)
            } finally {
                $output.Dispose()
            }
        }
    } finally {
        $reader.Dispose()
        $stream.Dispose()
    }
}

function Expand-LatexSourceArchive {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$ArchivePath,
        [Parameter(Mandatory)] [string]$DestinationPath,
        [long]$MaxExpandedBytes = 4GB,
        [int]$MaxEntries = 100000
    )
    $archive = (Resolve-Path -LiteralPath $ArchivePath -ErrorAction Stop).Path
    if (-not [System.IO.File]::Exists($archive)) { throw "source archive is not a file: '$archive'" }
    $destination = [System.IO.Path]::GetFullPath($DestinationPath)
    if (Test-Path -LiteralPath $destination) {
        throw "source extraction destination already exists; refusing to overwrite: '$destination'"
    }
    $parent = Split-Path -Parent $destination
    [System.IO.Directory]::CreateDirectory($parent) | Out-Null
    $leaf = Split-Path -Leaf $destination
    $nonce = [guid]::NewGuid().ToString('N')
    $stage = Join-Path $parent ".$leaf.expand-$nonce"
    $payload = Join-Path $parent ".$leaf.payload-$nonce"
    [System.IO.Directory]::CreateDirectory($stage) | Out-Null

    try {
        $input = [System.IO.File]::OpenRead($archive)
        try {
            $magic = [byte[]]::new(2)
            if ($input.Read($magic, 0, 2) -ne 2 -or $magic[0] -ne 0x1F -or $magic[1] -ne 0x8B) {
                throw "source archive is not a gzip stream: '$archive'"
            }
            $input.Position = 0
            $gzip = [System.IO.Compression.GzipStream]::new(
                $input,
                [System.IO.Compression.CompressionMode]::Decompress,
                $true
            )
            $output = [System.IO.FileStream]::new(
                $payload,
                [System.IO.FileMode]::CreateNew,
                [System.IO.FileAccess]::Write,
                [System.IO.FileShare]::None
            )
            try {
                $buffer = [byte[]]::new(1MB)
                $total = 0L
                while (($read = $gzip.Read($buffer, 0, $buffer.Length)) -gt 0) {
                    $total += $read
                    if ($total -gt $MaxExpandedBytes) {
                        throw "source gzip exceeds the $MaxExpandedBytes byte expansion limit"
                    }
                    $output.Write($buffer, 0, $read)
                }
                $output.Flush($true)
            } finally {
                $output.Dispose()
                $gzip.Dispose()
            }
        } finally {
            $input.Dispose()
        }

        $inventory = if (Test-LatexTarPayload -PayloadPath $payload) {
            Get-LatexTarInventory -PayloadPath $payload -DestinationRoot $stage `
                -MaxExpandedBytes $MaxExpandedBytes -MaxEntries $MaxEntries
        } else {
            [pscustomobject]@{ is_tar = $false; entries = @(); expanded_bytes = 0L }
        }

        if ($inventory.is_tar) {
            Expand-LatexTarPayload -PayloadPath $payload -DestinationRoot $stage
            $kind = 'tar+gzip'
            $entryCount = @($inventory.entries).Count
        } else {
            if ((Get-Item -LiteralPath $payload).Length -eq 0) { throw 'source gzip expands to an empty payload' }
            [System.IO.File]::Copy($payload, (Join-Path $stage 'main.tex'), $false)
            $kind = 'single-tex+gzip'
            $entryCount = 1
        }

        $reparse = @(Get-ChildItem -LiteralPath $stage -Force -Recurse -Attributes ReparsePoint -ErrorAction SilentlyContinue)
        if ($reparse.Count) {
            throw "source extraction contains a reparse point: '$($reparse[0].FullName)'"
        }
        [System.IO.Directory]::Move($stage, $destination)
        return [pscustomobject]@{
            archive_path     = $archive
            destination_path = $destination
            archive_kind     = $kind
            archive_entries  = $entryCount
        }
    } finally {
        if (Test-Path -LiteralPath $stage) { Remove-LatexPrivatePath -Path $stage -ExpectedParent $parent }
        if (Test-Path -LiteralPath $payload) { Remove-LatexPrivatePath -Path $payload -ExpectedParent $parent }
    }
}

function Get-LatexSourceEntrypoint {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$RootPath,
        [string]$Slug = '',
        [string]$MainTex = ''
    )
    $root = (Resolve-Path -LiteralPath $RootPath -ErrorAction Stop).Path
    if (-not [System.IO.Directory]::Exists($root)) { throw "LaTeX source root is not a directory: '$root'" }

    if ($MainTex) {
        if ([System.IO.Path]::IsPathRooted($MainTex)) { $explicit = [System.IO.Path]::GetFullPath($MainTex) }
        else { $explicit = [System.IO.Path]::GetFullPath((Join-Path $root $MainTex)) }
        if (-not (Test-LatexPathWithinRoot -Path $explicit -Root $root) -or
            -not [System.IO.File]::Exists($explicit)) {
            throw "explicit LaTeX entrypoint is missing or outside the source root: '$MainTex'"
        }
        $text = Remove-LatexLineComments (Read-LatexSourceText $explicit)
        if ($text -notmatch '\\documentclass(?:\s*\[[^\]]*\])?\s*\{') {
            throw "explicit LaTeX entrypoint has no document class declaration: '$MainTex'"
        }
        return [pscustomobject]@{ path = $explicit; selection = 'explicit' }
    }

    $texFiles = @(Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.tex' | Sort-Object FullName)
    if (-not $texFiles.Count) { throw "no .tex source found under '$root'" }
    $candidates = [System.Collections.Generic.List[object]]::new()
    foreach ($file in $texFiles) {
        $text = Remove-LatexLineComments (Read-LatexSourceText $file.FullName)
        if ($text -match '\\documentclass(?:\s*\[[^\]]*\])?\s*\{') { $candidates.Add($file) }
    }
    if ($candidates.Count -eq 0) { throw "no LaTeX entrypoint with a document class declaration found under '$root'" }
    if ($candidates.Count -eq 1) { return [pscustomobject]@{ path = $candidates[0].FullName; selection = 'single-candidate' } }

    $preferredNames = [System.Collections.Generic.List[string]]::new()
    if ($Slug) { $preferredNames.Add("$Slug.tex") }
    $preferredNames.Add('main.tex')
    foreach ($preferred in $preferredNames) {
        $hits = @($candidates | Where-Object { $_.Name.Equals($preferred, [System.StringComparison]::OrdinalIgnoreCase) })
        if ($hits.Count -eq 1) {
            return [pscustomobject]@{ path = $hits[0].FullName; selection = "preferred-name:$preferred" }
        }
    }
    $relativeCandidates = @($candidates | ForEach-Object { [System.IO.Path]::GetRelativePath($root, $_.FullName) })
    throw "ambiguous LaTeX entrypoint; specify -MainTex. Candidates: $($relativeCandidates -join ', ')"
}

function Resolve-LatexSourceInputs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$MainPath,
        [string]$RootPath = '',
        [int]$MaxDepth = 32,
        [ValidateSet('Stop', 'Keep', 'Drop')] [string]$UnresolvedInputAction = 'Stop'
    )
    $main = (Resolve-Path -LiteralPath $MainPath -ErrorAction Stop).Path
    $root = if ($RootPath) { (Resolve-Path -LiteralPath $RootPath -ErrorAction Stop).Path } else { Split-Path -Parent $main }
    if (-not (Test-LatexPathWithinRoot -Path $main -Root $root)) {
        throw "LaTeX entrypoint is outside the source root: '$main'"
    }
    $active = [System.Collections.Generic.HashSet[string]]::new((Get-LatexPathComparer))

    function Resolve-LatexSourceInputFile {
        param([string]$Path, [int]$Depth)
        if ($Depth -gt $MaxDepth) { throw "LaTeX input nesting exceeds the depth limit of $MaxDepth at '$Path'" }
        $full = [System.IO.Path]::GetFullPath($Path)
        if (-not $active.Add($full)) { throw "cyclic LaTeX input detected at '$full'" }
        try {
            $text = Remove-LatexLineComments (Read-LatexSourceText $full)
            $dir = Split-Path -Parent $full
            return [regex]::Replace($text, '\\(?:input|include)\s*\{([^{}]+)\}', {
                    param($match)
                    $name = $match.Groups[1].Value.Trim()
                    if (-not $name -or $name.IndexOf([char]0) -ge 0) {
                        throw "empty or invalid LaTeX input in '$full'"
                    }
                    $candidates = @($name, "$name.tex") | Select-Object -Unique | ForEach-Object {
                        [System.IO.Path]::GetFullPath((Join-Path $dir $_))
                    }
                    $inputPath = $candidates | Where-Object {
                        (Test-LatexPathWithinRoot -Path $_ -Root $root) -and [System.IO.File]::Exists($_)
                    } | Select-Object -First 1
                    if (-not $inputPath) {
                        $message = "unresolved or out-of-root LaTeX input '$name' referenced by '$full'"
                        if ($UnresolvedInputAction -eq 'Stop') { throw $message }
                        Write-Warning $message
                        if ($UnresolvedInputAction -eq 'Keep') { return $match.Value }
                        return ''
                    }
                    Resolve-LatexSourceInputFile -Path $inputPath -Depth ($Depth + 1)
                })
        } finally {
            $null = $active.Remove($full)
        }
    }

    return Resolve-LatexSourceInputFile -Path $main -Depth 0
}

function Get-LatexBracedContent {
    param(
        [Parameter(Mandatory)] [string]$Text,
        [Parameter(Mandatory)] [int]$OpenBraceIndex
    )
    $depth = 0
    for ($i = $OpenBraceIndex; $i -lt $Text.Length; $i++) {
        $character = $Text[$i]
        $slashes = 0
        for ($j = $i - 1; $j -ge 0 -and $Text[$j] -eq '\'; $j--) { $slashes++ }
        $escaped = ($slashes % 2) -eq 1
        if (-not $escaped -and $character -eq '{') { $depth++ }
        elseif (-not $escaped -and $character -eq '}') {
            $depth--
            if ($depth -eq 0) { return $Text.Substring($OpenBraceIndex + 1, $i - $OpenBraceIndex - 1) }
        }
    }
    return $null
}

function Get-LatexCommandBracedValues {
    param(
        [Parameter(Mandatory)] [string]$Text,
        [Parameter(Mandatory)] [string]$Command
    )
    $values = [System.Collections.Generic.List[string]]::new()
    $pattern = [regex]::Escape("\$Command") + '\s*(?:\[[^\]]*\]\s*)?\{'
    foreach ($match in [regex]::Matches($Text, $pattern)) {
        $value = Get-LatexBracedContent -Text $Text -OpenBraceIndex ($match.Index + $match.Length - 1)
        if (-not [string]::IsNullOrWhiteSpace($value)) { $values.Add($value.Trim()) }
    }
    return $values.ToArray()
}

function Get-LatexEmbeddedMetadata {
    param([Parameter(Mandatory)] [string]$ResolvedText)
    $title = @(Get-LatexCommandBracedValues -Text $ResolvedText -Command 'title') | Select-Object -First 1
    $authors = @(Get-LatexCommandBracedValues -Text $ResolvedText -Command 'author')
    $doi = @(Get-LatexCommandBracedValues -Text $ResolvedText -Command 'doi') | Select-Object -First 1
    return [ordered]@{
        title_tex   = if ($title) { [string]$title } else { $null }
        authors_tex = @($authors)
        doi         = if ($doi) { [string]$doi } else { $null }
    }
}

function Assert-LatexSourceTreeHasNoReparsePoint {
    <# Resolve a source-tree root and reject reparse points at the root or below it. #>
    param([Parameter(Mandatory)] [string]$RootPath)

    $root = (Resolve-Path -LiteralPath $RootPath -ErrorAction Stop).Path
    if (Test-PathHasReparsePoint -Path $root) {
        throw "source tree contains a reparse point: '$root'"
    }
    $reparse = @(Get-ChildItem -LiteralPath $root -Force -Recurse `
            -Attributes ReparsePoint -ErrorAction SilentlyContinue)
    if ($reparse.Count) {
        throw "source tree contains a reparse point: '$($reparse[0].FullName)'"
    }
    return $root
}

function Get-LatexSourceTreeFingerprint {
    param([Parameter(Mandatory)] [string]$RootPath)
    $root = Assert-LatexSourceTreeHasNoReparsePoint -RootPath $RootPath
    $filesByRelativePath = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $portablePaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($file in @(Get-ChildItem -LiteralPath $root -Force -Recurse -File)) {
        $nativeRelative = [System.IO.Path]::GetRelativePath($root, $file.FullName)
        if (-not $IsWindows -and $nativeRelative.Contains('\')) {
            throw "source tree contains a non-portable backslash in a filename: '$nativeRelative'"
        }
        $relative = $nativeRelative.Replace([System.IO.Path]::DirectorySeparatorChar, '/')
        if (-not $portablePaths.Add($relative)) {
            throw "source tree contains duplicate or case-colliding portable paths: '$relative'"
        }
        $filesByRelativePath.Add($relative, $file.FullName)
    }
    if (-not $filesByRelativePath.Count) { throw "source tree is empty: '$root'" }
    $relativePaths = [string[]]@($filesByRelativePath.Keys)
    [Array]::Sort($relativePaths, [System.StringComparer]::Ordinal)
    $records = [System.Collections.Generic.List[object]]::new()
    $builder = [System.Text.StringBuilder]::new()
    foreach ($relative in $relativePaths) {
        $file = Get-Item -LiteralPath $filesByRelativePath[$relative]
        $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        $record = [pscustomobject]@{ path = $relative; bytes = [long]$file.Length; sha256 = $hash }
        $records.Add($record)
        [void]$builder.Append($relative).Append([char]0).Append($file.Length).Append([char]0).Append($hash).Append("`n")
    }
    $bytes = [System.Text.UTF8Encoding]::new($false, $true).GetBytes($builder.ToString())
    $treeHash = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($bytes)).ToLowerInvariant()
    return [pscustomobject]@{
        sha256 = $treeHash
        files  = $records.ToArray()
        count  = $records.Count
    }
}

function Test-LatexSourceTree {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$RootPath,
        [string]$Slug = '',
        [string]$MainTex = ''
    )
    $root = Assert-LatexSourceTreeHasNoReparsePoint -RootPath $RootPath

    $texFiles = @(Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.tex')
    foreach ($texFile in $texFiles) { $null = Read-LatexSourceText $texFile.FullName }
    $entrypoint = Get-LatexSourceEntrypoint -RootPath $root -Slug $Slug -MainTex $MainTex
    $resolved = Resolve-LatexSourceInputs -MainPath $entrypoint.path -RootPath $root
    if ($resolved -notmatch '\\begin\s*\{document\}') {
        throw "resolved LaTeX entrypoint has no document environment: '$($entrypoint.path)'"
    }

    $fingerprint = Get-LatexSourceTreeFingerprint -RootPath $root
    $packageControl = @($fingerprint.files | Where-Object { $_.path -ieq '00README.json' })
    $embeddedMetadata = Get-LatexEmbeddedMetadata -ResolvedText $resolved
    return [pscustomobject]@{
        root_path             = $root
        entrypoint            = [System.IO.Path]::GetRelativePath($root, $entrypoint.path).Replace('\', '/')
        entrypoint_selection  = $entrypoint.selection
        file_count            = $fingerprint.count
        tex_file_count        = $texFiles.Count
        tree_sha256           = $fingerprint.sha256
        package_control_files = $packageControl
        embedded_metadata     = $embeddedMetadata
    }
}
