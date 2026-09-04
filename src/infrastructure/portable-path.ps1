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
