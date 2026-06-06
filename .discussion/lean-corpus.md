Since you are running modern PowerShell, we can leverage ForEach-Object -Parallel to blast through the Verso output directory, utilizing all your logical cores to spin up Pandoc processes concurrently. This will mirror the directory structure and convert everything to GitHub Flavored Markdown (gfm), which is the gold standard format for LLM context and RAG chunking.

Here is the ingestion script.

The Pandoc Ingestion Pipeline
You will need Pandoc installed (winget install pandoc if you don't have it on this machine). Save this as something like Invoke-CorpusIngestion.ps1.

PowerShell
[CmdletBinding()]
param (
[Parameter(Mandatory=$false)]
[string]$InputDir = ".\reference-manual\.lake\build\doc", # Verso HTML output path

    [Parameter(Mandatory=$false)]
    [string]$OutputDir = ".\codex-scientiae\lean-manual",    # Your corpus destination

    [Parameter(Mandatory=$false)]
    [string]$PandocFormat = "gfm"                            # GitHub Flavored Markdown

)

# Ensure output root exists

if (-not (Test-Path $OutputDir)) {
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Resolve absolute paths to avoid context loss inside the parallel runspace

$resolvedInDir = (Resolve-Path $InputDir).Path
$resolvedOutDir = (Resolve-Path $OutputDir).Path

$HtmlFiles = Get-ChildItem -Path $resolvedInDir -Filter "\*.html" -Recurse

if ($HtmlFiles.Count -eq 0) {
Write-Warning "No HTML files found in $resolvedInDir. Ensure Verso has run."
exit
}

Write-Host "Discovered $($HtmlFiles.Count) HTML documents. Initializing parallel Pandoc conversion..." -ForegroundColor Cyan

# Fire up the parallel execution pool

$HtmlFiles | ForEach-Object -Parallel {
$file = $\_
$inRoot = $using:resolvedInDir
$outRoot = $using:resolvedOutDir
$format = $using:PandocFormat

    # Reconstruct the exact directory tree in the output folder
    $relativePath = $file.DirectoryName.Substring($inRoot.Length).TrimStart('\', '/')
    $targetDir = Join-Path $outRoot $relativePath

    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    $outFilePath = Join-Path $targetDir ($file.BaseName + ".md")

    try {
        # --wrap=none is critical for LLM corpus building; it stops pandoc from
        # inserting hard line breaks at 80 characters, keeping paragraphs contiguous.
        pandoc.exe -f html -t $format --wrap=none $file.FullName -o $outFilePath
        Write-Host "[OK] Converted: $($file.Name)" -ForegroundColor DarkGray
    }
    catch {
        Write-Error "[FAIL] Pandoc choked on $($file.Name): $_"
    }

} -ThrottleLimit ([Environment]::ProcessorCount)

Write-Host "Corpus successfully generated at $resolvedOutDir." -ForegroundColor Green

### Why this configuration matters for codex-scientiae:

--wrap=none: This is the most important flag for RAG/LLM ingestion. By default, Pandoc hard-wraps text at 80 characters. This introduces arbitrary newline characters into the middle of sentences, which can heavily disrupt semantic chunking algorithms later on. This flag forces paragraphs to remain as single, contiguous strings.

Format gfm over markdown: GitHub Flavored Markdown guarantees that the code blocks (which will contain all your Lean 4 syntax) are fenced with standard triple backticks, and that tables are rendered cleanly. Standard Markdown often falls back to 4-space indentation for code, which can cause parsing errors when building your prompt contexts.

Directory Mirroring: Because Verso at --depth 2 creates subdirectories for major parts and chapters, the script dynamically recreates that exact folder tree in your output directory, preserving the structural hierarchy of the manual.
