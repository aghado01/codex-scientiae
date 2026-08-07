#requires -Version 7.0
# Compatibility is tested separately so the replacement core has no legacy path/name behavior.

BeforeAll {
    . "$PSScriptRoot/../../src/shared/jso-ops/jsonl-v2-compat.ps1"
    $script:Utf8 = [System.Text.UTF8Encoding]::new($false, $true)

    function Write-TestJsoiV1Index([string]$JsonlPath, [string]$IndexPath) {
        $bytes = [System.IO.File]::ReadAllBytes($JsonlPath)
        $offsets = [System.Collections.Generic.List[long]]::new()
        if ($bytes.Length -gt 0) { $offsets.Add(0L) }
        $i = [Array]::IndexOf($bytes, [byte]0x0A)
        while ($i -ge 0 -and ($i + 1) -lt $bytes.Length) {
            $offsets.Add([long]($i + 1))
            $i = [Array]::IndexOf($bytes, [byte]0x0A, $i + 1)
        }
        $fs = [System.IO.FileStream]::new($IndexPath, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write)
        $bw = [System.IO.BinaryWriter]::new($fs)
        try {
            $bw.Write([System.Text.Encoding]::ASCII.GetBytes('JSOI'))
            $bw.Write([int]1)
            $bw.Write([int]$offsets.Count)
            foreach ($offset in $offsets) { $bw.Write([long]$offset) }
        } finally { $bw.Dispose(); $fs.Dispose() }
    }
}

Describe 'jsonl-v2 compatibility compartment' {
    It 'reads a legacy records.jsonl.jidx without teaching the core that path convention' {
        $path = Join-Path $TestDrive 'legacy.jsonl'
        [System.IO.File]::WriteAllText($path, "{`"id`":0}`n{`"id`":1}`n", $script:Utf8)
        $legacyIndex = "$path.jidx"
        Write-TestJsoiV1Index -JsonlPath $path -IndexPath $legacyIndex

        Resolve-JsonlIndexPath $path | Should -Be (Join-Path $TestDrive 'legacy.jidx')
        Resolve-JsonlCompatibleIndexPath $path | Should -Be $legacyIndex
        (Read-JsonlRecord -Path $path -At 1).id | Should -Be 1
    }

    It 'prefers a canonical v2 index when both conventions exist and never rewrites the legacy file' {
        $path = Join-Path $TestDrive 'both.jsonl'
        Write-Jsonl -Records @(@{ id = 0 }, @{ id = 1 }) -Path $path | Out-Null
        $legacyIndex = "$path.jidx"
        Write-TestJsoiV1Index -JsonlPath $path -IndexPath $legacyIndex
        $legacyBefore = [Convert]::ToHexString([System.IO.File]::ReadAllBytes($legacyIndex))

        $canonical = (New-JsonlIndex -Path $path).IndexPath
        Resolve-JsonlCompatibleIndexPath $path | Should -Be $canonical
        (Read-JsonlRecord -Path $path -At 0).id | Should -Be 0
        [Convert]::ToHexString([System.IO.File]::ReadAllBytes($legacyIndex)) | Should -Be $legacyBefore
    }

    It 'can read a JSOI v1 index already using the canonical filename' {
        $path = Join-Path $TestDrive 'canonical-v1.jsonl'
        [System.IO.File]::WriteAllText($path, "{`"id`":0}`n{`"id`":1}`n", $script:Utf8)
        $canonicalV1 = Resolve-JsonlIndexPath $path
        Write-TestJsoiV1Index -JsonlPath $path -IndexPath $canonicalV1

        Resolve-JsonlCompatibleIndexPath $path | Should -Be $canonicalV1
        (Read-JsonlRecord -Path $path -At 1).id | Should -Be 1
    }
}
