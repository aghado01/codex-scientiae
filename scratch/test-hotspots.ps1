. src\serving.ps1
$chunksPath = "C:\Users\azrie\PDenv\UserGithub\codex-scientiae\ingestion\corpora\voroninski\1109.4499v1\.scratch\1109.4499v1.chunks.jsonl"
Get-IrHotspots -ChunksPath $chunksPath | ConvertTo-Json -Depth 5
