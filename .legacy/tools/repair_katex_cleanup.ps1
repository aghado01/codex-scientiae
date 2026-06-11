param(
    [string]$Path = 'c:\Users\azrie\PDenv\UserGithub\codex-scientiae\corpora\V.Voroninski\1506.01437v2.md'
)
if (-not (Test-Path $Path)) { Write-Error "File not found: $Path"; exit 2 }
$orig = Get-Content -Raw -Encoding UTF8 -Path $Path
$bak = "$Path.bak2"
Set-Content -Path $bak -Value $orig -Encoding UTF8

# Normalize \intertext{...}
$orig = [regex]::Replace($orig, '\\intertext\s*\{\s*(.*?)\s*\}', '\\intertext{$1}', [System.Text.RegularExpressions.RegexOptions]::Singleline)

# Remove spaces after LaTeX commands before brace: \cmd { -> \cmd{
$orig = [regex]::Replace($orig, '(\\[a-zA-Z]+)\s*\{', '$1{')

# Collapse spaces inside braces for simple tokens: { \delta } -> {\delta}
$orig = [regex]::Replace($orig, '\{\s*([^{}]+?)\s*\}', { param($m) "{" + ($m.Groups[1].Value -replace '\\s+','') + "}" }, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# Fix subscripts like t _ { i j } -> t_{ij}
$orig = [regex]::Replace($orig, '([A-Za-z\\\}]+)\s*_\s*\{\s*([^\}]+?)\s*\}', { param($m) $a=$m.Groups[1].Value; $b=($m.Groups[2].Value -replace '\\s+',''); return "$a{$" + "_" + "$b}" }, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# Simpler subscripts replacement: X_{i j} -> X_{ij}
$orig = [regex]::Replace($orig, '_\{\s*([^}]+?)\s*\}', { param($m) "_{" + ($m.Groups[1].Value -replace '\\s+','') + "}" }, [System.Text.RegularExpressions.RegexOptions]::Singleline)

# Replace literal Unicode tildes/hats with LaTeX commands (best-effort)
$orig = $orig -replace '˜','\\tilde{}'
$orig = $orig -replace 'ˆ','\\hat{}'

# Replace escaped \_ before brace with plain _
$orig = $orig -replace '\\\_\{','_{'

Set-Content -Path $Path -Value $orig -Encoding UTF8
Write-Output "cleanup-applied"
