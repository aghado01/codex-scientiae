. src\serving.ps1
$res = Invoke-Dispatch -Root ingestion -Paper '1109.4499v1'
$res | ConvertTo-Json -Depth 5
