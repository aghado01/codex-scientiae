$ErrorActionPreference = 'Stop'
. 'C:\Users\azrie\.claude\tools\jso-jackson\claude-jso-run.ps1'

$sessionPath = 'C:\Users\azrie\.claude\projects\c--Users-azrie-PDenv-UserGithub-PowerShellCore-ps-core-pwshspc\cf897fa2-a7a2-49bb-9372-bd6bd51b33ff.jsonl'
$sourceDir = Split-Path $sessionPath -Parent
$sessionId = [System.IO.Path]::GetFileNameWithoutExtension($sessionPath)
$markdownDir = Join-Path $env:CLAUDE_CONFIG_DIR 'tmp\markdown'

$result = Invoke-ClaudeThreadExport -SourceDir $sourceDir -SessionIds $sessionId -MarkdownDir $markdownDir -Format Structural

$result | Select-Object ThreadId, MarkdownPath, WorkingDir, @{Name='MergedRecords';Expression={$_.Stats.MergedRecords}}, @{Name='SessionCount';Expression={$_.Stats.SessionCount}}, @{Name='SubagentCount';Expression={$_.Stats.SubagentCount}} | Format-List | Out-String
