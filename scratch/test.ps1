. src\serving.ps1

$chunks = @(
  [pscustomobject]@{ id = 1; type = 'formula'; page = 1; content = 'x =' }
  [pscustomobject]@{ id = 2; type = 'formula'; page = 1; content = '\left( \frac{1}{2}' }
  [pscustomobject]@{ id = 3; type = 'formula'; page = 1; content = '+ y \right)' }
)

Write-Host "Running Group-MathHotspots on unbalanced chunks..."
$spans = Group-MathHotspots $chunks
Write-Host "Spans count: $($spans.Count)"
if ($spans.Count -gt 0) {
    $spans | ConvertTo-Json -Depth 5
}
