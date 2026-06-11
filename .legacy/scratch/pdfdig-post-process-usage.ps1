Import-Module C:\Users\azrie\PDenv\UserGithub\PowerShellCore\ps.core.pdfdig\scripts\pdfdig-post-process.psm1

$mdfile = "C:\Users\azrie\PDenv\UserGithub\PowerShellCore\ps.core.pdfdig\.depr\converted\hybrid\2505.18844v3.md"

# Dry-run on the docling output to see what gets stripped
Invoke-OpenDataLoaderPostProcess -InputPath $mdfile -DryRun

# Real run — writes 2505.18844v3.cleaned.md and 2505.18844v3.cleaned.json next to input
Invoke-OpenDataLoaderPostProcess -InputPath $mdfile

# Diagnostic dump — see how each block was classified before committing to a run
Get-MarkdownBlockReport -InputPath $mdfile |
Where-Object { $_.Kind -in @('POLLUTION_CANDIDATE', 'AMBIGUOUS', 'PANEL_LABEL') } |
Format-Table
