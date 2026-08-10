#requires -Version 7.0
<#
  src/logistics/crawl.ps1 — targeted filesystem crawler.

  Two lifts, no more: the .NET enumeration primitive from reposnapshot's FileSystemCrawler
  (DirectoryInfo.EnumerateFileSystemInfos — lazy, attributes from the find data, no per-entry
  FileInfo / GetAttributes round-trip), and the LEVELED include/exclude semantics from
  repo-audit's IgnoreEngine — where include and exclude are one match test of inverse polarity,
  not include-as-special-override. None of the gitignore-file machinery (sentinels, inheritance,
  the five-stage compile): the caller passes the globs and the polarity.

  Deploy it to look for only the files that matter and pass over the noise:

    Invoke-Crawl -Root <dir> -Patterns '**/.runs/*/*.chunks.jsonl'               # Include (default)
    Invoke-Crawl -Root <dir> -Patterns '**/*.json' -Semantics Include
    Invoke-Crawl -Root <dir> -Patterns '**/*.png'  -Semantics Exclude            # everything but images
    Invoke-Crawl -Root <dir> -Patterns '**/*' -FailOnReparse                   # strict scoped walk
    Invoke-Crawl -Root <dir> -Patterns '**/*.md' -PruneDirs '.git','node_modules'

  Globs match the root-relative, forward-slash path: ** = any (crosses /), * = any non-/, ? = one
  non-/. Use a leading **/ to match at any depth. -PruneDirs (default none) short-circuits whole
  subtrees by directory name before they're walked. Reparse points (symlinks/junctions) are skipped
  by default; -FailOnReparse throws instead — use that for confinement-sensitive walks.
#>

function ConvertTo-GlobRegex([string]$Glob) {
    $e = [regex]::Escape(($Glob -replace '\\', '/'))
    $e = $e -replace '\\\*\\\*/', '(?:.*/)?'  # **/ -> zero or more leading dirs (incl none)
    $e = $e -replace '\\\*\\\*',  '.*'        # **  -> any (crosses separators)
    $e = $e -replace '\\\*',      '[^/]*'     # *   -> any run within a segment
    $e = $e -replace '\\\?',      '[^/]'      # ?   -> one char within a segment
    return $e
}

# one match test, inverse polarity — the leveled semantics
function Test-Keep([string]$RelPath, [regex]$Rx, [string]$Semantics) {
    $m = $Rx.IsMatch($RelPath)
    if ($Semantics -eq 'Include') { return $m } else { return -not $m }
}

function Invoke-Crawl {
    [CmdletBinding()] param(
        [Parameter(Mandatory)][string]$Root,
        [Parameter(Mandatory)][string[]]$Patterns,
        [ValidateSet('Include', 'Exclude')][string]$Semantics = 'Include',
        [string[]]$PruneDirs = @(),
        [switch]$FailOnReparse
    )
    $rootFull = [System.IO.Path]::GetFullPath($Root)
    if (-not [System.IO.Directory]::Exists($rootFull)) { return }

    $rx = [regex]::new(
        '^(?:' + (($Patterns | ForEach-Object { ConvertTo-GlobRegex $_ }) -join '|') + ')$',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor
            [System.Text.RegularExpressions.RegexOptions]::CultureInvariant -bor
            [System.Text.RegularExpressions.RegexOptions]::Compiled)

    $prune = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($name in @($PruneDirs)) {
        if (-not [string]::IsNullOrWhiteSpace($name)) { [void]$prune.Add($name) }
    }
    $havePrune = $prune.Count -gt 0
    $failOnReparse = [bool]$FailOnReparse
    $include = $Semantics -eq 'Include'
    # Children of $rootFull are "$rootFull$sep…"; relative path is the suffix after the separator.
    $rootPrefixLength = $rootFull.Length
    $pathComparison = if ($IsWindows) {
        [System.StringComparison]::OrdinalIgnoreCase
    } else {
        [System.StringComparison]::Ordinal
    }

    $stack = [System.Collections.Generic.Stack[string]]::new()
    $stack.Push($rootFull)
    while ($stack.Count) {
        $dir = $stack.Pop()
        $infos = try {
            [System.IO.DirectoryInfo]::new($dir).EnumerateFileSystemInfos()
        } catch {
            @()
        }
        foreach ($info in $infos) {
            $attrs = $info.Attributes
            $isReparse = ($attrs -band [System.IO.FileAttributes]::ReparsePoint) -ne 0
            if (($attrs -band [System.IO.FileAttributes]::Directory) -ne 0) {
                if ($isReparse) {
                    if ($failOnReparse) { throw "crawl encountered a reparse point: '$($info.FullName)'" }
                    continue
                }
                if ($havePrune -and $prune.Contains($info.Name)) { continue }
                $stack.Push($info.FullName)
                continue
            }

            if ($isReparse -and $failOnReparse) {
                throw "crawl encountered a reparse point: '$($info.FullName)'"
            }

            $entry = $info.FullName
            if ($entry.Length -le $rootPrefixLength -or
                -not $entry.StartsWith($rootFull, $pathComparison)) {
                continue
            }
            # Skip the directory separator between root and relative suffix.
            $rel = $entry.Substring($rootPrefixLength + 1).Replace('\', '/')
            $matched = $rx.IsMatch($rel)
            if (($include -and $matched) -or (-not $include -and -not $matched)) {
                $entry
            }
        }
    }
}
