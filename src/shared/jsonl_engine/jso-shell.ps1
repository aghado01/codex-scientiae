#requires -Version 7.0
<#
  Compatibility importer for the manifest-backed PowerShell JSONL-engine client.

  Existing callers may continue to dot-source this path while migrating to an explicit import of
  src/shared/jsonl-engine-client/jsonl-engine-client.psd1. All runtime resolution, subprocess,
  protocol, error, and cmdlet behavior lives in that module; this file defines no second surface.
#>

$manifest = [System.IO.Path]::GetFullPath(
    (Join-Path $PSScriptRoot '../jsonl-engine-client/jsonl-engine-client.psd1'))
if (-not [System.IO.File]::Exists($manifest)) {
    throw "jsonl engine PowerShell client manifest not found: '$manifest'"
}
Import-Module -Name $manifest -ErrorAction Stop
