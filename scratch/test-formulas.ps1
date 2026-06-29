$chunks = Get-Content "D:\aghado01\codex-scientiae\ingestion\corpora\voroninski\1109.4499v1\.scratch\1109.4499v1.chunks.jsonl" | ConvertFrom-Json
$chunks | Where-Object { $_.type -eq 'formula' -and $_.fidelity -ne 'faithful' } | Select-Object id, fidelity, corruption_type, seam, content | ConvertTo-Json
