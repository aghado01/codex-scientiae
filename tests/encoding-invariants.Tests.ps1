#requires -Version 7.0
<#
  tests/encoding-invariants.Tests.ps1 — the PowerShell encoding/determinism footgun taxonomy,
  CODIFIED as executable invariants at the jsonl substrate chokepoint.

  Why this suite exists: the codex has been bitten repeatedly by the same family of silent
  corruptions — culture-sensitive string ops no-oping on ligatures (membrane era), PSObject
  pipeline-wrapping poisoning serialization, nullable auto-unwrap making guards read
  always-false, if-expression unrolling, serializer escaping dialects forking bytes on math
  glyphs, and nondeterministic word order breaking re-run diffability. Cross-derivation
  ("convergent lines of evidence") only works over byte-stable, glyph-faithful artifacts, so
  these properties are enforced HERE, not remembered.

  Three tiers:
    1. GLYPH GAUNTLET  nasty codepoints round-trip byte-exact through write + indexed seek.
    2. CHOKEPOINT      serializer parity, BOM-lessness, .jidx exactness, write determinism,
                       fallback behavior (correct output + loud telemetry).
    3. TRAP CANARIES   the taxonomy itself as assertions — if a future PS/Newtonsoft version
                       changes wrapping/unrolling/escaping behavior, these fire first.
#>

BeforeAll {
    . "$PSScriptRoot/../src/shared/jsonl.ps1"

    # the gauntlet: every glyph class that has bitten or could bite
    $script:Gauntlet = @(
        '𝒮𝔽𝕏 𝑝𝟙'                          # SMP math alphanumerics (surrogate pairs)
        'ﬁﬂﬀﬃﬄ ﬆ'                          # ligature block (the corpus ~1800 class)
        "repl$([char]0xFFFD)char"           # U+FFFD must survive, flagged never replaced
        "a$([char]0x0338)b"                 # combining solidus (the ≠ decomposition)
        '‖u‖ → kuk ∈ ℤ δγ'                  # BMP math + arrows (CMSY correction class)
        '<x> & ''q'' "d" \ /'               # escaping dialect probes (EscapeHtml divergence class)
        "tab`there nl->|linebreak|<-"       # control chars (escaped as \t \n in JSON)
        "nbsp$([char]0x00A0)zw$([char]0x200B)end"  # invisible-width traps
    )
    # \r and \n inside content are JSON-escaped so they never fracture JSONL lines; the literal
    # newline case is exercised via the pipe-delimited marker above written through a record
    $script:Gauntlet[6] = $script:Gauntlet[6].Replace('|linebreak|', "`n")

    function New-GauntletRecord([int]$i, [string]$g) {
        # lane-shaped record built the SANCTIONED way: literals, casts, direct expressions
        [ordered]@{
            id     = $i
            text   = $g
            bx     = @(1.25, -2.5, 367.75, 0.0)
            nested = [ordered]@{ inner = $g; n = $null }
            arr    = @($g, 42, $null, $true)
            flag   = $false
        }
    }
    $script:TmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "enc-inv-$([guid]::NewGuid())"
    New-Item -ItemType Directory -Path $script:TmpDir | Out-Null
}
AfterAll {
    if (Test-Path $script:TmpDir) { Remove-Item $script:TmpDir -Recurse -Force -ErrorAction SilentlyContinue }
}

Describe 'glyph gauntlet round-trip (write -> bytes -> indexed seek)' {
    BeforeAll {
        $script:recs = @(); $i = 0
        foreach ($g in $script:Gauntlet) { $script:recs += ,(New-GauntletRecord $i $g); $i++ }
        $script:outPath = Join-Path $script:TmpDir 'gauntlet.jsonl'
        $null = Write-JsonlStage -Records $script:recs -OutputPath $script:outPath -Stage 'test/gauntlet'
    }

    It 'emits UTF-8 with NO BOM' {
        $bytes = [System.IO.File]::ReadAllBytes($script:outPath)
        -not ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) | Should -BeTrue
    }

    It 'round-trips every gauntlet string codepoint-exact through indexed seek' {
        for ($i = 0; $i -lt $script:Gauntlet.Count; $i++) {
            $rec = Read-JsonlRecord -Path $script:outPath -At $i
            [string]::Equals($rec.text, $script:Gauntlet[$i], [StringComparison]::Ordinal) |
                Should -BeTrue -Because "gauntlet[$i] must survive byte-exact (ordinal), got: $($rec.text)"
            [string]::Equals($rec.nested.inner, $script:Gauntlet[$i], [StringComparison]::Ordinal) | Should -BeTrue
        }
    }

    It 'every .jidx offset lands exactly on a record-start byte, multibyte content notwithstanding' {
        $idx = [JsonlIndex]::Load("$script:outPath.jidx")
        $idx.LineCount | Should -Be $script:Gauntlet.Count
        $bytes = [System.IO.File]::ReadAllBytes($script:outPath)
        for ($i = 0; $i -lt $idx.LineCount; $i++) {
            $bytes[$idx.Offset($i)] | Should -Be 0x7B -Because "offset $i must point at '{'"
        }
    }

    It 'zero fast-path fallbacks for records built the sanctioned way' {
        $before = $script:NsjFallbacks
        $null = Write-JsonlStage -Records $script:recs -OutputPath (Join-Path $script:TmpDir 'g2.jsonl') -Stage 'test/gauntlet2'
        $script:NsjFallbacks - $before | Should -Be 0
    }
}

Describe 'chokepoint: serializer parity + write determinism' {
    It 'Newtonsoft fast path (IDictionary) and cmdlet path (PSCustomObject) produce IDENTICAL bytes' {
        # same data, two record shapes -> two serializer paths -> byte-equal lines
        $i = 0
        foreach ($g in $script:Gauntlet) {
            $ht = New-GauntletRecord $i $g
            $pso = [pscustomobject]$ht
            $pHt  = Join-Path $script:TmpDir "parity-ht-$i.jsonl"
            $pPso = Join-Path $script:TmpDir "parity-pso-$i.jsonl"
            $null = Write-JsonlStage -Records @($ht)  -OutputPath $pHt  -Stage 'test/parity'
            $null = Write-JsonlStage -Records @($pso) -OutputPath $pPso -Stage 'test/parity'
            $a = [System.IO.File]::ReadAllBytes($pHt); $b = [System.IO.File]::ReadAllBytes($pPso)
            [System.Linq.Enumerable]::SequenceEqual($a, $b) | Should -BeTrue -Because "gauntlet[$i] must serialize identically on both paths"
            $i++
        }
    }

    It 'writing the same records twice yields byte-identical .jsonl AND .jidx' {
        $recs = @(); $i = 0
        foreach ($g in $script:Gauntlet) { $recs += ,(New-GauntletRecord $i $g); $i++ }
        $d1 = Join-Path $script:TmpDir 'det-a.jsonl'; $d2 = Join-Path $script:TmpDir 'det-b.jsonl'
        $null = Write-JsonlStage -Records $recs -OutputPath $d1 -Stage 'test/det'
        $null = Write-JsonlStage -Records $recs -OutputPath $d2 -Stage 'test/det'
        (Get-FileHash $d1).Hash | Should -Be (Get-FileHash $d2).Hash
        (Get-FileHash "$d1.jidx").Hash | Should -Be (Get-FileHash "$d2.jidx").Hash
    }

    It 'a PSObject-poisoned record degrades to the cmdlet path: output correct, telemetry loud' {
        $poisoned = [ordered]@{ id = 0; page = (@(3, 1, 2) | Sort-Object | Select-Object -First 1); text = 'x' }
        $pPath = Join-Path $script:TmpDir 'poison.jsonl'
        $before = $script:NsjFallbacks
        $warnings = @()
        $null = Write-JsonlStage -Records @($poisoned) -OutputPath $pPath -Stage 'test/poison' -WarningVariable warnings -WarningAction SilentlyContinue
        ($script:NsjFallbacks - $before) | Should -BeGreaterThan 0 -Because 'the fallback counter is the visibility channel'
        $warnings.Count | Should -BeGreaterThan 0 -Because 'the emitting stage must be TOLD it shipped a wrapped value'
        $back = Read-JsonlRecord -Path $pPath -At 0
        $back.page | Should -Be 1 -Because 'fallback output must still be semantically correct'
    }
}

Describe 'trap canaries (the taxonomy as assertions — fire on PS/Newtonsoft behavior drift)' {
    BeforeAll {
        $script:nsj = [Newtonsoft.Json.JsonSerializerSettings]::new()
        $script:nsj.StringEscapeHandling = [Newtonsoft.Json.StringEscapeHandling]::Default
        $script:nsj.Formatting = [Newtonsoft.Json.Formatting]::None
    }

    It 'pipeline-emitted values ARE PSObject-wrapped (Newtonsoft refuses them)' {
        $v = @(2, 1) | Sort-Object | Select-Object -First 1
        { [Newtonsoft.Json.JsonConvert]::SerializeObject(@{ x = $v }, $script:nsj) } | Should -Throw
    }

    It 'if-expression values, @() over collections, and hashtable members are NOT wrapped' {
        $ifv = if ($true) { 'math' } else { 'prose' }
        $ss = [System.Collections.Generic.SortedSet[string]]::new(); [void]$ss.Add('a')
        $ht = @{ n = 0 }; $ht.n++
        [Newtonsoft.Json.JsonConvert]::SerializeObject([ordered]@{ a = $ifv; b = @($ss); c = $ht.n }, $script:nsj) |
            Should -Be '{"a":"math","b":["a"],"c":1}'
    }

    It 'ConvertTo-Json keeps <>&'' literal (Default escaping, NOT EscapeHtml) — the parity contract' {
        # if this ever fails, PS changed its default and the fast path must follow suit
        ('<&>' | ConvertTo-Json -Compress) | Should -Be '"<&>"'
    }

    It 'culture-sensitive equality lies about ligatures; ordinal tells the truth' {
        # the membrane text-mutation trap: 'fi' -eq 'ﬁ' is culture-dependent — never gate writes on it
        [string]::Equals('fi', 'ﬁ', [StringComparison]::Ordinal) | Should -BeFalse
        'ﬁ'.Normalize([System.Text.NormalizationForm]::FormKC) | Should -Be 'fi'
    }

    It 'PS auto-unwraps Nullable returns — .HasValue on a result is a silent always-false guard' {
        # the capability-map probe-3 lesson, pinned: a REAL PdfRectangle? comes back unwrapped
        $nullable = [System.Nullable[int]]5
        $nullable.GetType().FullName | Should -Be 'System.Int32' -Because 'PS strips the Nullable wrapper on assignment'
    }
}
