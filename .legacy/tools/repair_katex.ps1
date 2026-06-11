param(
    [string]$Path = 'c:\Users\azrie\PDenv\UserGithub\PowerShellCore\ps.core.pdfdig\converted\Voroninski\1506.01437v2\full\1506.01437v2.md'
)

if (-not (Test-Path $Path)) { Write-Error "File not found: $Path"; exit 2 }
$orig = Get-Content -Raw -Encoding UTF8 -Path $Path
$bak = "$Path.bak"
Set-Content -Path $bak -Value $orig -Encoding UTF8

# Normalize \intertext{...}
$orig = [regex]::Replace($orig, '\\intertext\s*\{\s*(.*?)\s*\}', '\\intertext{$1}', [System.Text.RegularExpressions.RegexOptions]::Singleline)

# Replace $$...$$ blocks containing & or \intertext with aligned environment
$pattern = '(?s)\$\$(.*?)\$\$'
$evaluator = {
    param($m)
    $inner = $m.Groups[1].Value
    if ($inner -match '&' -or $inner -match '\\intertext' -or $inner -match '\\\\') {
        if ($inner -match '\\begin\{aligned\}' -or $inner -match '\\begin\{align') { return $m.Value }
        $trimmed = $inner.Trim("`r`n")
        return "$$`n\\begin{aligned}`n$trimmed`n\\end{aligned}`n$$"
    } else { return $m.Value }
}

try {
    $new = [regex]::Replace($orig, $pattern, $evaluator, [System.Text.RegularExpressions.RegexOptions]::Singleline)
} catch {
    Write-Error "Regex replacement failed: $_"
    exit 3
}

if ($new -ne $orig) {
    Set-Content -Path $Path -Value $new -Encoding UTF8
    Write-Output "modified"
} else {
    Write-Output "no changes"
}
