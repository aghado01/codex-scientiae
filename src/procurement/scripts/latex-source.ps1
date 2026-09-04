#requires -Version 7.0
<#
  LaTeX source deposit helpers under procurement.

  Independently callable steps for archive expansion, tree validation, publication of `{slug}-tex/`,
  probe ledger assembly, and jsonl_engine `deposit` publication of `article.json`. Workflow scripts
  compose these steps; `Publish-LatexSourceTree` and `New-LatexSourceDeposit` are the standard
  compositions. No dependency on the latex-ingest converter.
#>

. "$PSScriptRoot/../../infrastructure/portable-path.ps1"
. "$PSScriptRoot/../../infrastructure/crawl.ps1"
. "$PSScriptRoot/../../infrastructure/probe-ledger.ps1"
Import-Module (Join-Path $PSScriptRoot '../../jsonl_engine-client/jsonl_engine-client.psd1') `
    -ErrorAction Stop

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
            $hasher = [System.Security.Cryptography.SHA256]::Create()
            try {
                $archiveHashBytes = $hasher.ComputeHash($input)
                $archiveSha256 = [System.Convert]::ToHexString($archiveHashBytes).ToLowerInvariant()
            }
            finally {
                $hasher.Dispose()
            }
            $input.Position = 0
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

        try {
            [void]@(Invoke-Crawl -Root $stage -Patterns '**/*' -FailOnReparse)
        } catch {
            if ($_.Exception.Message -like '*reparse point*') {
                $path = if ($_.Exception.Message -match "'([^']+)'") { $Matches[1] } else { $stage }
                throw "source extraction contains a reparse point: '$path'"
            }
            throw
        }
        [System.IO.Directory]::Move($stage, $destination)
        return [pscustomobject]@{
            archive_path     = $archive
            destination_path = $destination
            archive_kind     = $kind
            archive_entries  = $entryCount
            archive_sha256   = $archiveSha256
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

    $texFiles = @(Invoke-Crawl -Root $root -Patterns '**/*.tex' -FailOnReparse | Sort-Object)
    if (-not $texFiles.Count) { throw "no .tex source found under '$root'" }
    $candidates = [System.Collections.Generic.List[string]]::new()
    foreach ($path in $texFiles) {
        $text = Remove-LatexLineComments (Read-LatexSourceText $path)
        if ($text -match '\\documentclass(?:\s*\[[^\]]*\])?\s*\{') { $candidates.Add($path) }
    }
    if ($candidates.Count -eq 0) { throw "no LaTeX entrypoint with a document class declaration found under '$root'" }
    if ($candidates.Count -eq 1) { return [pscustomobject]@{ path = $candidates[0]; selection = 'single-candidate' } }

    $preferredNames = [System.Collections.Generic.List[string]]::new()
    if ($Slug) { $preferredNames.Add("$Slug.tex") }
    $preferredNames.Add('main.tex')
    foreach ($preferred in $preferredNames) {
        $hits = @($candidates | Where-Object {
                [System.IO.Path]::GetFileName($_).Equals($preferred, [System.StringComparison]::OrdinalIgnoreCase)
            })
        if ($hits.Count -eq 1) {
            return [pscustomobject]@{ path = $hits[0]; selection = "preferred-name:$preferred" }
        }
    }
    $relativeCandidates = @($candidates | ForEach-Object { [System.IO.Path]::GetRelativePath($root, $_) })
    throw "ambiguous LaTeX entrypoint; specify -MainTex. Candidates: $($relativeCandidates -join ', ')"
}

function Resolve-LatexSourceInputs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$MainPath,
        [string]$RootPath = '',
        [int]$MaxDepth = 32,
        [ValidateSet('Stop', 'Keep', 'Drop')] [string]$UnresolvedInputAction = 'Stop',
        [System.Collections.IList]$Unresolved = $null
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
            return [regex]::Replace($text, '\\(?<command>input|include|subfile)(?![A-Za-z])(?:\s*\{(?<braced>[^{}]+)\}|\s*(?<bare>[^\s\\{}\[\]\x25][^\s\\{}%]*))', {
                    param($match)
                    $command = $match.Groups['command'].Value
                    $captured = if ($match.Groups['braced'].Success) {
                        $match.Groups['braced'].Value
                    } else {
                        $match.Groups['bare'].Value
                    }
                    $name = $captured.Trim()
                    if (-not $name -or $name.IndexOf([char]0) -ge 0) {
                        throw "empty or invalid LaTeX $command target in '$full'"
                    }
                    $candidates = @($name, "$name.tex") | Select-Object -Unique | ForEach-Object {
                        # TeX keeps the compile root as its working directory
                        # while processing nested inputs.
                        [System.IO.Path]::GetFullPath((Join-Path $root $_))
                    }
                    $inputPath = $candidates | Where-Object {
                        (Test-LatexPathWithinRoot -Path $_ -Root $root) -and [System.IO.File]::Exists($_)
                    } | Select-Object -First 1
                    if (-not $inputPath) {
                        $message = "unresolved or out-of-root LaTeX $command target '$name' referenced by '$full'"
                        if ($UnresolvedInputAction -eq 'Stop') { throw $message }
                        if ($null -ne $Unresolved) {
                            $referencedBy = [System.IO.Path]::GetRelativePath($root, $full).Replace('\', '/')
                            [void]$Unresolved.Add([pscustomobject]@{
                                command       = $command
                                literal       = $name
                                referenced_by = $referencedBy
                            })
                        } else {
                            Write-Warning $message
                        }
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
    try {
        [void]@(Invoke-Crawl -Root $root -Patterns '**/*' -FailOnReparse)
    } catch {
        if ($_.Exception.Message -like '*reparse point*') {
            $path = if ($_.Exception.Message -match "'([^']+)'") { $Matches[1] } else { $root }
            throw "source tree contains a reparse point: '$path'"
        }
        throw
    }
    return $root
}

function Get-LatexSourceTreeFingerprint {
    param([Parameter(Mandatory)] [string]$RootPath)
    $root = Assert-LatexSourceTreeHasNoReparsePoint -RootPath $RootPath
    $filesByRelativePath = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $portablePaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($fullName in @(Invoke-Crawl -Root $root -Patterns '**/*' -FailOnReparse)) {
        $nativeRelative = [System.IO.Path]::GetRelativePath($root, $fullName)
        if (-not $IsWindows -and $nativeRelative.Contains('\')) {
            throw "source tree contains a non-portable backslash in a filename: '$nativeRelative'"
        }
        $relative = $nativeRelative.Replace([System.IO.Path]::DirectorySeparatorChar, '/')
        if (-not $portablePaths.Add($relative)) {
            throw "source tree contains duplicate or case-colliding portable paths: '$relative'"
        }
        $filesByRelativePath.Add($relative, $fullName)
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

    $texFiles = @(Invoke-Crawl -Root $root -Patterns '**/*.tex' -FailOnReparse)
    foreach ($texFile in $texFiles) { $null = Read-LatexSourceText $texFile }
    $entrypoint = Get-LatexSourceEntrypoint -RootPath $root -Slug $Slug -MainTex $MainTex
    $unresolved = [System.Collections.Generic.List[object]]::new()
    $resolved = Resolve-LatexSourceInputs -MainPath $entrypoint.path -RootPath $root `
        -UnresolvedInputAction Keep -Unresolved $unresolved
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
        unresolved_inputs     = $unresolved.ToArray()
    }
}

function Read-SourceDepositJson {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [long]$MaxBytes = 32MB
    )
    $strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
    $stream = [System.IO.File]::Open(
        $Path,
        [System.IO.FileMode]::Open,
        [System.IO.FileAccess]::Read,
        [System.IO.FileShare]::Read)
    try {
        if ($stream.Length -gt $MaxBytes) {
            throw "JSON file exceeds the $MaxBytes-byte boundary: '$Path'"
        }
        $bytes = [byte[]]::new([int]$stream.Length)
        $stream.ReadExactly($bytes)
        $json = $strictUtf8.GetString($bytes)
    } catch [System.Text.DecoderFallbackException] {
        throw "JSON file is not valid UTF-8: '$Path'"
    } finally {
        $stream.Dispose()
    }
    try {
        $document = [System.Text.Json.JsonDocument]::Parse($json)
        $document.Dispose()
        return ($json | ConvertFrom-Json -AsHashtable -Depth 100)
    } catch {
        throw "invalid JSON file '$Path': $($_.Exception.Message)"
    }
}

function Test-ExistingSourceDeposit {
    param(
        [Parameter(Mandatory)] [System.Collections.IDictionary]$Manifest,
        [Parameter(Mandatory)] [string]$ManifestPath,
        [Parameter(Mandatory)] [string]$DocumentDir,
        [Parameter(Mandatory)] [string]$Slug
    )
    $isArticle = [string]$Manifest.schema -eq 'codex-scientiae/article/0.1'
    if ([string]$Manifest.schema -notin @(
            'codex-scientiae/article/0.1',
            'codex-scientiae/document-metadata/0.1'
        ) -or
        [string]$Manifest.state -ne 'source-ready' -or
        [string]$Manifest.slug -ne $Slug) {
        throw "existing deposit manifest is not source-ready for '$Slug': '$ManifestPath'"
    }
    if ($isArticle) {
        if (-not [string]::Equals(
                [System.IO.Path]::GetFileName($ManifestPath),
                'article.json',
                [System.StringComparison]::Ordinal) -or
            -not [string]::Equals(
                (Split-Path -Leaf (Split-Path -Parent $ManifestPath)),
                $Slug,
                [System.StringComparison]::Ordinal)) {
            throw "canonical article location does not match slug '$Slug': '$ManifestPath'"
        }
        foreach ($required in @(
                'initialized_utc', 'title', 'authors', 'abstract', 'identifiers', 'categories',
                'evidence', 'source_forms', 'validation')) {
            if (-not $Manifest.Contains($required)) {
                throw "canonical article is missing required field '$required': '$ManifestPath'"
            }
        }
    }
    $archiveForm = @($Manifest.source_forms | Where-Object { $_.role -eq 'latex-source-archive' })
    $treeForm = @($Manifest.source_forms | Where-Object { $_.role -eq 'latex-source-tree' })
    if ($archiveForm.Count -ne 1 -or $treeForm.Count -ne 1) {
        throw "existing deposit manifest does not declare exactly one LaTeX archive and source tree: '$ManifestPath'"
    }
    $archivePath = [System.IO.Path]::GetFullPath((Join-Path $DocumentDir ([string]$archiveForm[0].path)))
    $treePath = [System.IO.Path]::GetFullPath((Join-Path $DocumentDir ([string]$treeForm[0].path)))
    if (-not (Test-LatexPathWithinRoot -Path $archivePath -Root $DocumentDir) -or
        -not (Test-LatexPathWithinRoot -Path $treePath -Root $DocumentDir) -or
        (Test-PathHasReparsePoint -Path $archivePath) -or
        (Test-PathHasReparsePoint -Path $treePath) -or
        -not [System.IO.File]::Exists($archivePath) -or
        -not [System.IO.Directory]::Exists($treePath)) {
        throw "existing deposit manifest points to missing or out-of-root source material: '$ManifestPath'"
    }
    $archiveHash = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($archiveHash -ne [string]$archiveForm[0].sha256) {
        throw "source archive no longer matches deposit manifest: '$archivePath'"
    }
    $treeHash = (Get-LatexSourceTreeFingerprint -RootPath $treePath).sha256
    if ($treeHash -ne [string]$treeForm[0].sha256) {
        throw "source tree no longer matches deposit manifest: '$treePath'"
    }
    return [pscustomobject]@{
        status        = 'already-initialized'
        metadata_path = $ManifestPath
        archive_path  = $archivePath
        source_path   = $treePath
        manifest      = $Manifest
    }
}

function Resolve-SourceDepositScopedPath {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string]$DocumentDir
    )
    $candidate = if ([System.IO.Path]::IsPathRooted($Path)) {
        $Path
    } else {
        Join-Path $DocumentDir $Path
    }
    return (Resolve-Path -LiteralPath $candidate -ErrorAction Stop).Path
}

function Resolve-SourceDepositArchive {
    param(
        [Parameter(Mandatory)] [string]$DocumentDir,
        [Parameter(Mandatory)] [string]$Slug,
        [string]$ArchivePath = ''
    )
    $canonical = Join-Path $DocumentDir "$Slug.tar.gz"
    $alias = Join-Path $DocumentDir "arXiv-$Slug.tar.gz"
    if ($ArchivePath) {
        $selected = Resolve-SourceDepositScopedPath -Path $ArchivePath -DocumentDir $DocumentDir
        if (-not (Test-LatexPathWithinRoot -Path $selected -Root $DocumentDir) -or
            (Test-PathHasReparsePoint -Path $selected) -or
            -not [System.IO.File]::Exists($selected)) {
            throw "source archive must be a file inside the document directory: '$ArchivePath'"
        }
        $leaf = Split-Path -Leaf $selected
        if ($leaf -cnotin @("$Slug.tar.gz", "arXiv-$Slug.tar.gz")) {
            throw "source archive must be named '$Slug.tar.gz' or 'arXiv-$Slug.tar.gz', not '$leaf'"
        }
        return $selected
    }
    $found = @(@($canonical, $alias) | Where-Object { [System.IO.File]::Exists($_) })
    if ($found.Count -eq 0) {
        throw "no source archive found; expected '$Slug.tar.gz' or 'arXiv-$Slug.tar.gz' in '$DocumentDir'"
    }
    if ($found.Count -gt 1) {
        throw "both canonical and alias source archives exist; refusing to choose between '$canonical' and '$alias'"
    }
    $selected = [System.IO.Path]::GetFullPath($found[0])
    if (Test-PathHasReparsePoint -Path $selected) {
        throw "source archive must not traverse a symbolic link or reparse point: '$selected'"
    }
    return $selected
}

function Resolve-SourceDepositProviderMetadata {
    param(
        [Parameter(Mandatory)] [string]$DocumentDir,
        [Parameter(Mandatory)] [string]$Slug,
        [string]$ProviderMetadataPath = ''
    )
    if ($ProviderMetadataPath) {
        $selected = Resolve-SourceDepositScopedPath -Path $ProviderMetadataPath -DocumentDir $DocumentDir
        if (-not (Test-LatexPathWithinRoot -Path $selected -Root $DocumentDir) -or
            (Test-PathHasReparsePoint -Path $selected) -or
            -not [System.IO.File]::Exists($selected)) {
            throw "provider metadata must be a file inside the document directory: '$ProviderMetadataPath'"
        }
        return $selected
    }
    $candidate = Join-Path $DocumentDir "$Slug.arxiv.json"
    if (Test-PathHasReparsePoint -Path $candidate) {
        throw "provider metadata must not traverse a symbolic link or reparse point: '$candidate'"
    }
    if ([System.IO.File]::Exists($candidate)) { return [System.IO.Path]::GetFullPath($candidate) }
    return $null
}

function Resolve-SourceDepositMetadataBundle {
    <#
    .SYNOPSIS
        Resolve a validated API metadata bundle inside the document deposit.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$DocumentDir,
        [Parameter(Mandatory)] [string]$Slug,
        [string]$MetadataBundlePath = ''
    )
    if ($MetadataBundlePath) {
        $selected = Resolve-SourceDepositScopedPath -Path $MetadataBundlePath -DocumentDir $DocumentDir
        if (-not (Test-LatexPathWithinRoot -Path $selected -Root $DocumentDir) -or
            (Test-PathHasReparsePoint -Path $selected) -or
            -not [System.IO.File]::Exists($selected)) {
            throw "API metadata bundle must be a file inside the document directory: '$MetadataBundlePath'"
        }
        return $selected
    }
    $candidate = Join-Path $DocumentDir "$Slug.api-metadata.json"
    if (Test-PathHasReparsePoint -Path $candidate) {
        throw "API metadata bundle must not traverse a symbolic link or reparse point: '$candidate'"
    }
    if ([System.IO.File]::Exists($candidate)) { return [System.IO.Path]::GetFullPath($candidate) }
    return $null
}

if ($null -eq $script:SourceDepositHeldLocks) {
    $script:SourceDepositHeldLocks =
        [System.Collections.Concurrent.ConcurrentDictionary[string, byte]]::new(
            [System.StringComparer]::Ordinal)
}

function Enter-SourceDepositLock {
    param([Parameter(Mandatory)] [string]$DocumentDir, [int]$TimeoutSeconds = 15)
    $canonical = [System.IO.Path]::GetFullPath($DocumentDir)
    if ([System.OperatingSystem]::IsWindows()) { $canonical = $canonical.ToUpperInvariant() }
    $digest = [System.Convert]::ToHexString(
        [System.Security.Cryptography.SHA256]::HashData(
            [System.Text.UTF8Encoding]::new($false).GetBytes($canonical)
        )
    ).ToLowerInvariant()
    $name = "codex-scientiae-source-deposit-$($digest.Substring(0, 32))"
    if (-not $script:SourceDepositHeldLocks.TryAdd($name, [byte]0)) {
        throw "timed out waiting for the source-deposit lock: '$canonical'"
    }

    $mutex = $null
    $acquired = $false
    try {
        $mutex = [System.Threading.Mutex]::new($false, $name)
        try {
            $acquired = $mutex.WaitOne([TimeSpan]::FromSeconds([math]::Max(0, $TimeoutSeconds)))
        }
        catch [System.Threading.AbandonedMutexException] {
            # The prior owner died while holding the mutex; this caller now owns it.
            $acquired = $true
        }
        if (-not $acquired) {
            throw "timed out waiting for the source-deposit lock: '$canonical'"
        }
        return [pscustomobject]@{ name = $name; mutex = $mutex }
    }
    catch {
        if ($mutex) { $mutex.Dispose() }
        [byte]$removed = 0
        [void]$script:SourceDepositHeldLocks.TryRemove($name, [ref]$removed)
        throw
    }
}

function Exit-SourceDepositLock {
    param([object]$Lock)
    if (-not $Lock) { return }
    try { $Lock.mutex.ReleaseMutex() }
    finally {
        $Lock.mutex.Dispose()
        [byte]$removed = 0
        [void]$script:SourceDepositHeldLocks.TryRemove([string]$Lock.name, [ref]$removed)
    }
}

# The probe set this transaction is accountable for. Adding a probe to the code without adding it
# here fails Assert-ProbeCoverage, and so does the reverse — an entry no code path backs.
$script:DepositProbes = @(
    'gzip-readable',
    'archive-members-confined',
    'no-links-or-reparse-points',
    'tex-valid-utf8',
    'entrypoint-unambiguous',
    'literal-inputs-resolved',
    'document-environment-present'
)

function New-DepositProbeLedger {
    <#
    .SYNOPSIS
        Record what the transaction actually established about this deposit.
    .DESCRIPTION
        Built once, from the authoritative validation — Test-LatexSourceTree runs twice in the
        recovery path (candidate and existing tree) and the ledger describes the tree that was
        published, not both attempts.

        Every entry here corresponds to a guard that already threw on failure. Recording happens on
        the success side; this never converts a throw into a result.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]$Expansion,
        [Parameter(Mandatory)]$Validation
    )

    $ledger = [ProbeLedger]::new()
    $kind = [string]$Expansion.archive_kind

    # Both branches decompress before anything else; a non-gzip stream throws in Expand-LatexSourceArchive.
    $ledger.Record('gzip-readable', 'passed', @{ archive_kind = $kind })

    # Member confinement is a property of the tar path only. The single-TeX gzip shape expands one
    # payload — there are no members, so there is nothing to confine and nothing to claim.
    if ($kind -eq 'tar+gzip') {
        $ledger.Record('archive-members-confined', 'passed', @{ entries = $Expansion.archive_entries })
    } else {
        $ledger.Record('archive-members-confined', 'not-applicable', @{
            reason       = 'single-payload gzip archive has no members to confine'
            archive_kind = $kind
        })
    }

    # Scanned on the extraction destination and again across the published tree.
    $ledger.Record('no-links-or-reparse-points', 'passed', @{ files = $Validation.file_count })

    # Read-LatexSourceText decodes every .tex under the root with a throwing UTF-8 decoder.
    $ledger.Record('tex-valid-utf8', 'passed', @{ tex_files = $Validation.tex_file_count })

    # 'explicit' means -MainTex named the entrypoint and Get-LatexSourceEntrypoint returned before
    # the candidate scan. Nothing established that the tree was unambiguous — an operator decided.
    $selection = [string]$Validation.entrypoint_selection
    if ($selection -eq 'explicit') {
        $ledger.Record('entrypoint-unambiguous', 'not-applicable', @{
            reason     = 'entrypoint named explicitly; the ambiguity scan did not run'
            selection  = $selection
            entrypoint = [string]$Validation.entrypoint
        })
    } else {
        $ledger.Record('entrypoint-unambiguous', 'passed', @{
            selection  = $selection
            entrypoint = [string]$Validation.entrypoint
        })
    }

    # Test-LatexSourceTree keeps missing literal inputs in the resolved text and names the holes.
    # Escape, cycle, and depth still throw. A total graph is passed; a hole is waived, not passed.
    $holes = if ($null -eq $Validation.unresolved_inputs) { @() } else { @($Validation.unresolved_inputs) }
    if ($holes.Count -gt 0) {
        $ledger.Record('literal-inputs-resolved', 'waived', @{
            reason      = 'literal input targets are missing from the source tree'
            unresolved  = $holes
        })
    } else {
        $ledger.Record('literal-inputs-resolved', 'passed', @{ unresolved = @() })
    }

    # \begin{document} in the fully resolved text, not in the entrypoint file alone.
    $ledger.Record('document-environment-present', 'passed', @{ basis = 'resolved-input-text' })

    $ledger.AssertCoverage($script:DepositProbes)
    return $ledger
}

function Resolve-LatexSourceDepositRoot {
    <#
    .SYNOPSIS
        Resolve and validate the document directory plus slug for a source deposit.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$DocumentDir,
        [string]$Slug = ''
    )

    $documentRoot = (Resolve-Path -LiteralPath $DocumentDir -ErrorAction Stop).Path
    if (-not [System.IO.Directory]::Exists($documentRoot)) {
        throw "document deposit is not a directory: '$documentRoot'"
    }
    if (Test-PathHasReparsePoint -Path $documentRoot) {
        throw "document deposit must not traverse a symbolic link or reparse point: '$documentRoot'"
    }
    if (-not $Slug) { $Slug = Split-Path -Leaf $documentRoot }
    if (-not (Test-PortableLeaf -Value $Slug)) {
        throw "slug must be one portable directory-leaf name: '$Slug'"
    }
    $directoryLeaf = Split-Path -Leaf $documentRoot
    if (-not [string]::Equals($Slug, $directoryLeaf, [System.StringComparison]::Ordinal)) {
        throw "slug '$Slug' does not match document directory leaf '$directoryLeaf'"
    }
    return [pscustomobject]@{
        DocumentDir = $documentRoot
        Slug        = $Slug
    }
}

function Assert-SourceDepositProviderMatchesSlug {
    <#
    .SYNOPSIS
        Refuse provider metadata whose idv disagrees with the deposit slug.
    #>
    [CmdletBinding()]
    param(
        [string]$ProviderPath,
        [Parameter(Mandatory)][string]$Slug
    )
    if (-not $ProviderPath) { return }
    $provider = Read-SourceDepositJson -Path $ProviderPath
    if ($provider.idv -and [string]$provider.idv -ne $Slug) {
        throw "provider metadata idv '$($provider.idv)' does not match deposit slug '$Slug'"
    }
}

function Assert-SourceDepositMetadataMatchesSlug {
    <#
    .SYNOPSIS
        Refuse an API metadata bundle addressed to another deposit.
    #>
    [CmdletBinding()]
    param(
        [string]$MetadataPath,
        [Parameter(Mandatory)][string]$Slug
    )
    if (-not $MetadataPath) { return }
    $metadata = Read-SourceDepositJson -Path $MetadataPath
    if ([string]$metadata.schema -ne 'codex-scientiae/deposit-metadata/0.1') {
        throw "API metadata bundle has an unsupported schema: '$MetadataPath'"
    }
    if ([string]$metadata.deposit_slug -cne $Slug) {
        throw "API metadata bundle slug '$($metadata.deposit_slug)' does not match deposit slug '$Slug'"
    }
}

function ConvertTo-CanonicalSourceDepositArchive {
    <#
    .SYNOPSIS
        Normalize an accepted archive path to `{slug}.tar.gz` inside the deposit.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ArchivePath,
        [Parameter(Mandatory)][string]$DocumentDir,
        [Parameter(Mandatory)][string]$Slug
    )
    $canonicalArchive = Join-Path $DocumentDir "$Slug.tar.gz"
    if (Test-LatexPathsEqual -Left $ArchivePath -Right $canonicalArchive) {
        return $canonicalArchive
    }
    if ([System.IO.File]::Exists($canonicalArchive)) {
        throw "canonical archive appeared during initialization; refusing to overwrite: '$canonicalArchive'"
    }
    [System.IO.File]::Move($ArchivePath, $canonicalArchive, $false)
    return $canonicalArchive
}

function Install-LatexSourceTree {
    <#
    .SYNOPSIS
        Promote a privately validated candidate tree to `{slug}-tex/`, or recover a matching tree.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$DocumentDir,
        [Parameter(Mandatory)][string]$Slug,
        [Parameter(Mandatory)][string]$CandidatePath,
        [Parameter(Mandatory)]$CandidateValidation,
        [string]$MainTex = ''
    )

    $sourcePath = Join-Path $DocumentDir "$Slug-tex"
    if ([System.IO.Directory]::Exists($sourcePath)) {
        $existingValidation = Test-LatexSourceTree -RootPath $sourcePath -Slug $Slug -MainTex $MainTex
        if ($existingValidation.tree_sha256 -ne $CandidateValidation.tree_sha256) {
            throw "existing source tree differs from the validated archive; refusing to overwrite: '$sourcePath'"
        }
        Remove-LatexPrivatePath -Path $CandidatePath -ExpectedParent $DocumentDir
        return [pscustomobject]@{
            SourcePath  = $sourcePath
            Validation  = $existingValidation
            Publication = 'recovered-existing-tree'
        }
    }

    [System.IO.Directory]::Move($CandidatePath, $sourcePath)
    return [pscustomobject]@{
        SourcePath  = $sourcePath
        Validation  = $CandidateValidation
        Publication = 'published-new-tree'
    }
}

function New-LatexSourceDepositFacts {
    <#
    .SYNOPSIS
        Build the scalar/path boundary payload consumed by jsonl_engine deposit.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$DocumentDir,
        [Parameter(Mandatory)][string]$Slug,
        [Parameter(Mandatory)][string]$ArchivePath,
        [Parameter(Mandatory)]$Expansion,
        [Parameter(Mandatory)][string]$SourcePath,
        [Parameter(Mandatory)]$Validation,
        [Parameter(Mandatory)][string]$Publication,
        [Parameter(Mandatory)]$Ledger,
        [string]$ProviderPath = '',
        [string]$MetadataPath = ''
    )

    $relative = {
        param([string]$Path)
        if (-not $Path) { return $null }
        return [System.IO.Path]::GetRelativePath($DocumentDir, $Path).Replace('\', '/')
    }
    $pdfPath = Join-Path $DocumentDir "$Slug.pdf"
    $htmlPath = Join-Path $DocumentDir "$Slug-html"
    return [pscustomobject]@{
        Skipped             = $false
        DocumentDir         = $DocumentDir
        Slug                = $Slug
        Archive             = (& $relative $ArchivePath)
        ArchiveSha256       = [string]$Expansion.archive_sha256
        ArchiveKind         = [string]$Expansion.archive_kind
        Tree                = (& $relative $SourcePath)
        TreeSha256          = [string]$Validation.tree_sha256
        Files               = [int]$Validation.file_count
        TexFiles            = [int]$Validation.tex_file_count
        Entrypoint          = [string]$Validation.entrypoint
        EntrypointSelection = [string]$Validation.entrypoint_selection
        ProviderJson        = (& $relative $ProviderPath)
        MetadataJson        = (& $relative $MetadataPath)
        Pdf                 = $(if ([System.IO.File]::Exists($pdfPath)) { (& $relative $pdfPath) } else { $null })
        Html                = $(if ([System.IO.Directory]::Exists($htmlPath)) { (& $relative $htmlPath) } else { $null })
        Publication         = $Publication
        Findings            = [pscustomobject]@{
            checks                = $Ledger.Results()
            declarations          = $Validation.embedded_metadata
            package_control_files = @($Validation.package_control_files)
        }
    }
}

function Resolve-SafeLatexSourceFindingsPath {
    <#
    .SYNOPSIS
        Resolve FindingsPath and refuse deposit-interior or reparse-bearing addresses.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$DocumentDir,
        [Parameter(Mandatory)][string]$FindingsPath
    )

    $documentRoot = [System.IO.Path]::GetFullPath($DocumentDir)
    $findingsFull = if ([System.IO.Path]::IsPathFullyQualified($FindingsPath)) {
        [System.IO.Path]::GetFullPath($FindingsPath)
    }
    else {
        [System.IO.Path]::GetFullPath($FindingsPath, (Get-Location).Path)
    }
    $pathComparison = if ([System.OperatingSystem]::IsWindows()) {
        [System.StringComparison]::OrdinalIgnoreCase
    }
    else { [System.StringComparison]::Ordinal }
    $documentPrefix = $documentRoot.TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    ) + [System.IO.Path]::DirectorySeparatorChar
    if ([string]::Equals($findingsFull, $documentRoot, $pathComparison) -or
        $findingsFull.StartsWith($documentPrefix, $pathComparison)) {
        throw "FindingsPath must be outside the document deposit: '$findingsFull'"
    }
    if (Test-PathHasReparsePoint -Path $findingsFull) {
        throw "FindingsPath must not traverse a symbolic link or reparse point: '$findingsFull'"
    }
    return $findingsFull
}

function Invoke-JsonlEngineArticleDeposit {
    <#
    .SYNOPSIS
        Publish or validate article.json from prepared source-deposit facts.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]$Facts,
        [string]$FindingsPath = '',
        [switch]$KeepFindings,
        [string]$PythonPath = '',
        [ValidateRange(1, 3600)][int]$EngineTimeoutSeconds = 300
    )

    $documentRoot = [string]$Facts.DocumentDir
    if ($FindingsPath) {
        $FindingsPath = Resolve-SafeLatexSourceFindingsPath -DocumentDir $documentRoot `
            -FindingsPath $FindingsPath
    }

    $inputFileArguments = @{ InputObject = $Facts.Findings }
    if ($FindingsPath) {
        $inputFileArguments.Path = $FindingsPath
    }
    $findingsInput = jsonl_engine-client\New-JsonlEngineInputFile @inputFileArguments
    $findingsFile = $findingsInput.Path
    try {
        try {
            [void](Resolve-SafeLatexSourceFindingsPath -DocumentDir $documentRoot -FindingsPath $findingsFile)
        }
        catch {
            if ([System.IO.File]::Exists($findingsFile)) {
                [System.IO.File]::Delete($findingsFile)
            }
            throw
        }
        $argument = [System.Collections.Generic.List[string]]::new()
        $argument.Add('--document-dir');         $argument.Add($Facts.DocumentDir)
        $argument.Add('--slug');                 $argument.Add($Facts.Slug)
        $argument.Add('--archive');              $argument.Add($Facts.Archive)
        $argument.Add('--archive-sha256');       $argument.Add($Facts.ArchiveSha256)
        $argument.Add('--archive-kind');         $argument.Add($Facts.ArchiveKind)
        $argument.Add('--tree');                 $argument.Add($Facts.Tree)
        $argument.Add('--tree-sha256');          $argument.Add($Facts.TreeSha256)
        $argument.Add('--files');                $argument.Add([string]$Facts.Files)
        $argument.Add('--tex-files');            $argument.Add([string]$Facts.TexFiles)
        $argument.Add('--entrypoint');           $argument.Add($Facts.Entrypoint)
        $argument.Add('--entrypoint-selection'); $argument.Add($Facts.EntrypointSelection)
        $argument.Add('--publication');          $argument.Add($Facts.Publication)
        $argument.Add('--findings-json');        $argument.Add($findingsFile)
        if ($Facts.ProviderJson) {
            $argument.Add('--provider-json'); $argument.Add($Facts.ProviderJson)
        }
        if ($Facts.MetadataJson) {
            $argument.Add('--metadata-json'); $argument.Add($Facts.MetadataJson)
            $argument.Add('--metadata-extension')
            $argument.Add('procurement.storage.article:get_procurement_article_metadata_extension')
        }
        if ($Facts.Pdf) { $argument.Add('--pdf'); $argument.Add($Facts.Pdf) }
        if ($Facts.Html) { $argument.Add('--html'); $argument.Add($Facts.Html) }

        $frames = @(jsonl_engine-client\Invoke-JsonlEngineCommand -Verb 'deposit' `
                -Argument $argument.ToArray() -PythonPath $PythonPath `
                -TimeoutSeconds $EngineTimeoutSeconds)
        if ($frames.Count -ne 1) {
            throw "jsonl engine verb 'deposit' returned $($frames.Count) values; expected exactly one"
        }
        $engineOutput = $frames[0].value
        $expectedArticle = [System.IO.Path]::GetFullPath((Join-Path $Facts.DocumentDir 'article.json'))
        $returnedArticle = [System.IO.Path]::GetFullPath([string]$engineOutput.article_path)
        $pathComparison = if ([System.OperatingSystem]::IsWindows()) {
            [System.StringComparison]::OrdinalIgnoreCase
        }
        else { [System.StringComparison]::Ordinal }
        if (-not $engineOutput -or -not $engineOutput.article -or
            [string]$engineOutput.article.slug -ne [string]$Facts.Slug -or
            -not [string]::Equals($returnedArticle, $expectedArticle, $pathComparison)) {
            throw "jsonl engine verb 'deposit' returned an article outside the requested deposit"
        }
        return [pscustomobject]@{
            Skipped      = -not [bool]$engineOutput.created
            Status       = [string]$engineOutput.status
            DocumentDir  = $Facts.DocumentDir
            Slug         = $Facts.Slug
            Publication  = [string]$engineOutput.article.validation.publication
            ManifestPath = [string]$engineOutput.article_path
            EngineOutput = $engineOutput
        }
    } finally {
        if (-not $KeepFindings -and $findingsInput.IsTemporary -and
            [System.IO.File]::Exists($findingsFile)) {
            [System.IO.File]::Delete($findingsFile)
        }
    }
}

function Publish-LatexSourceTree {
    <#
    .SYNOPSIS
        Standard composition: lock, expand, validate, install `{slug}-tex/`, return deposit facts.
    .DESCRIPTION
        Composes the independently callable deposit steps under one document lock. Optional
        FinalizePublication runs before the lock is released (used by New-LatexSourceDeposit).
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$DocumentDir,
        [string]$Slug = '',
        [string]$ArchivePath = '',
        [string]$ProviderMetadataPath = '',
        [string]$MetadataBundlePath = '',
        [string]$MainTex = '',
        [long]$MaxExpandedBytes = 4GB,
        [int]$MaxEntries = 100000,
        [int]$LockTimeoutSeconds = 15,
        [Parameter(DontShow)][scriptblock]$FinalizePublication
    )

    $identity = Resolve-LatexSourceDepositRoot -DocumentDir $DocumentDir -Slug $Slug
    $documentRoot = [string]$identity.DocumentDir
    $Slug = [string]$identity.Slug
    if ($ProviderMetadataPath -and $MetadataBundlePath) {
        throw 'ProviderMetadataPath and MetadataBundlePath are mutually exclusive'
    }

    $lock = $null
    $candidate = $null
    try {
        $lock = Enter-SourceDepositLock -DocumentDir $documentRoot -TimeoutSeconds $LockTimeoutSeconds

        $archive = Resolve-SourceDepositArchive -DocumentDir $documentRoot -Slug $Slug -ArchivePath $ArchivePath
        $providerPath = Resolve-SourceDepositProviderMetadata -DocumentDir $documentRoot -Slug $Slug `
            -ProviderMetadataPath $ProviderMetadataPath
        Assert-SourceDepositProviderMatchesSlug -ProviderPath $providerPath -Slug $Slug
        $metadataPath = Resolve-SourceDepositMetadataBundle -DocumentDir $documentRoot -Slug $Slug `
            -MetadataBundlePath $MetadataBundlePath
        if ($providerPath -and $metadataPath) {
            throw "both legacy provider metadata and API metadata bundle exist for '$Slug'; refusing to choose"
        }
        Assert-SourceDepositMetadataMatchesSlug -MetadataPath $metadataPath -Slug $Slug

        $pdfPath = Join-Path $documentRoot "$Slug.pdf"
        if (Test-PathHasReparsePoint -Path $pdfPath) {
            throw "PDF source must not traverse a symbolic link or reparse point: '$pdfPath'"
        }
        $htmlPath = Join-Path $documentRoot "$Slug-html"
        if (Test-PathHasReparsePoint -Path $htmlPath) {
            throw "HTML source must not traverse a symbolic link or reparse point: '$htmlPath'"
        }

        $nonce = [guid]::NewGuid().ToString('N')
        $candidate = Join-Path $documentRoot ".$Slug-tex.validate-$nonce"
        $expansion = Expand-LatexSourceArchive -ArchivePath $archive -DestinationPath $candidate `
            -MaxExpandedBytes $MaxExpandedBytes -MaxEntries $MaxEntries
        $candidateValidation = Test-LatexSourceTree -RootPath $candidate -Slug $Slug -MainTex $MainTex

        $currentArchiveSha256 = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($currentArchiveSha256 -cne [string]$expansion.archive_sha256) {
            throw "source archive changed after expansion: '$archive'"
        }

        $archive = ConvertTo-CanonicalSourceDepositArchive -ArchivePath $archive `
            -DocumentDir $documentRoot -Slug $Slug
        $installed = Install-LatexSourceTree -DocumentDir $documentRoot -Slug $Slug `
            -CandidatePath $candidate -CandidateValidation $candidateValidation -MainTex $MainTex
        $candidate = $null

        $ledger = New-DepositProbeLedger -Expansion $expansion -Validation $installed.Validation
        $facts = New-LatexSourceDepositFacts `
            -DocumentDir $documentRoot `
            -Slug $Slug `
            -ArchivePath $archive `
            -Expansion $expansion `
            -SourcePath $installed.SourcePath `
            -Validation $installed.Validation `
            -Publication $installed.Publication `
            -Ledger $ledger `
            -ProviderPath $providerPath `
            -MetadataPath $metadataPath

        if ($FinalizePublication) {
            return & $FinalizePublication $facts
        }
        return $facts
    } finally {
        try {
            if ($candidate -and [System.IO.Directory]::Exists($candidate)) {
                Remove-LatexPrivatePath -Path $candidate -ExpectedParent $documentRoot
            }
        }
        finally {
            Exit-SourceDepositLock -Lock $lock
        }
    }
}

function New-LatexSourceDeposit {
    <#
    .SYNOPSIS
        Standard composition: publish the source tree, then write/validate article.json.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$DocumentDir,
        [string]$Slug = '',
        [string]$ArchivePath = '',
        [string]$ProviderMetadataPath = '',
        [string]$MetadataBundlePath = '',
        [string]$MainTex = '',
        [string]$FindingsPath = '',
        [switch]$KeepFindings,
        [string]$PythonPath = '',
        [ValidateRange(1, 3600)][int]$EngineTimeoutSeconds = 300,
        [long]$MaxExpandedBytes = 4GB,
        [int]$MaxEntries = 100000,
        [int]$LockTimeoutSeconds = 15
    )

    $identity = Resolve-LatexSourceDepositRoot -DocumentDir $DocumentDir -Slug $Slug
    if ($FindingsPath) {
        # Freeze caller-relative resolution before any archive expansion / tree publication.
        $FindingsPath = Resolve-SafeLatexSourceFindingsPath -DocumentDir $identity.DocumentDir `
            -FindingsPath $FindingsPath
    }

    # GetNewClosure() isolates the scriptblock from sibling functions in this file; capture the
    # deposit step explicitly so the composition can still call it while the document lock is held.
    $invokeArticleDeposit = ${function:Invoke-JsonlEngineArticleDeposit}
    $finalize = {
        param($facts)
        return & $invokeArticleDeposit -Facts $facts `
            -FindingsPath $FindingsPath `
            -KeepFindings:$KeepFindings `
            -PythonPath $PythonPath `
            -EngineTimeoutSeconds $EngineTimeoutSeconds
    }.GetNewClosure()

    return Publish-LatexSourceTree -DocumentDir $identity.DocumentDir -Slug $identity.Slug `
        -ArchivePath $ArchivePath -ProviderMetadataPath $ProviderMetadataPath `
        -MetadataBundlePath $MetadataBundlePath -MainTex $MainTex `
        -MaxExpandedBytes $MaxExpandedBytes -MaxEntries $MaxEntries `
        -LockTimeoutSeconds $LockTimeoutSeconds -FinalizePublication $finalize
}
