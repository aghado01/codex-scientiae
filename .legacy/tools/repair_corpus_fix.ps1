param(
    [string]$Path = 'c:\Users\azrie\PDenv\UserGithub\codex-scientiae\corpora\V.Voroninski\1506.01437v2.md'
)
if (-not (Test-Path $Path)) { Write-Error "File not found: $Path"; exit 2 }
$orig = Get-Content -Raw -Encoding UTF8 -Path $Path
$bak = "$Path.bak3"
Set-Content -Path $bak -Value $orig -Encoding UTF8

# 1) Fix '{$_' -> '_{'
$orig = $orig -replace '\{\$_', '_{'

# 2) Fix occurrences like '}{$_' -> '}_{'
$orig = $orig -replace '\}\{\$_', '}_{'

# 3) Remove stray sequences like '{$_' leftover with variants
$orig = $orig -replace '\{\$','_{'

# 4) Collapse spaces inside braces {  a b  } -> {ab}
$orig = [regex]::Replace($orig, '\{\s*([^{}]+?)\s*\}', { param($m) '{' + ($m.Groups[1].Value -replace '\s+','') + '}' }, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# 5) Remove spaces between command and brace: \cmd { -> \cmd{
$orig = [regex]::Replace($orig, '(\\[a-zA-Z]+)\s*\{', '$1{')

# 6) Replace sequences like 'v{_{ij}}' accidental nesting from previous steps
$orig = $orig -replace '\{_\{', '_{'

# 7) Replace stray sequences like '{$_ij}' that may remain
$orig = $orig -replace '\{\$_([a-zA-Z0-9]+)\}', '_{$1}'

# 8) Normalize multiple spaces
$orig = $orig -replace '[ \t]{2,}',' '

Set-Content -Path $Path -Value $orig -Encoding UTF8
Write-Output "corpus-fix-applied"
