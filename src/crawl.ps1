#requires -Version 7.0
<#
  src/crawl.ps1 — targeted filesystem crawler.

  Two lifts, no more: the .NET enumeration primitive from reposnapshot's FileSystemCrawler
  ([IO.Directory]::EnumerateFileSystemEntries — lazy, no per-entry FileInfo, far cheaper than
  the PowerShell provider's -Recurse), and the LEVELED include/exclude semantics from
  repo-audit's IgnoreEngine — where include and exclude are one match test of inverse polarity,
  not include-as-special-override. None of the gitignore-file machinery (sentinels, inheritance,
  the five-stage compile): the caller passes the globs and the polarity.

  Deploy it to look for only the files that matter and pass over the noise:

    Invoke-Crawl -Root <dir> -Patterns '**/.scratch/*.chunks.jsonl'              # Include (default)
    Invoke-Crawl -Root <dir> -Patterns '**/*.json' -Semantics Include
    Invoke-Crawl -Root <dir> -Patterns '**/*.png'  -Semantics Exclude            # everything but images

  Globs match the root-relative, forward-slash path: ** = any (crosses /), * = any non-/, ? = one
  non-/. Use a leading **/ to match at any depth. -PruneDirs short-circuits whole subtrees by
  directory name before they're walked.
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
        [string[]]$PruneDirs = @('.git', 'node_modules')
    )
    $rootFull = [System.IO.Path]::GetFullPath($Root)
    if (-not [System.IO.Directory]::Exists($rootFull)) { return }
    $rx = [regex]::new('(?i)^(?:' + (($Patterns | ForEach-Object { ConvertTo-GlobRegex $_ }) -join '|') + ')$')
    $prune = [System.Collections.Generic.HashSet[string]]::new($PruneDirs, [System.StringComparer]::OrdinalIgnoreCase)

    $stack = [System.Collections.Generic.Stack[string]]::new()
    $stack.Push($rootFull)
    while ($stack.Count) {
        $dir = $stack.Pop()
        $entries = try { [System.IO.Directory]::EnumerateFileSystemEntries($dir) } catch { @() }
        foreach ($entry in $entries) {
            $attrs = try { [System.IO.File]::GetAttributes($entry) } catch { continue }
            if ($attrs.HasFlag([System.IO.FileAttributes]::Directory)) {
                if ($attrs.HasFlag([System.IO.FileAttributes]::ReparsePoint)) { continue }
                if ($prune.Contains([System.IO.Path]::GetFileName($entry))) { continue }
                $stack.Push($entry)
            }
            else {
                $rel = [System.IO.Path]::GetRelativePath($rootFull, $entry) -replace '\\', '/'
                if (Test-Keep $rel $rx $Semantics) { $entry }
            }
        }
    }
}
