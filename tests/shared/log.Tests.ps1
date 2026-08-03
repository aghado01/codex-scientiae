#requires -Version 7.0
# src/shared/log.ps1 — the per-run execution trace. Intrinsic validation: sink resolution, level
# gates on both sinks, JSONL parseability + codepoint safety (UTF-8-no-BOM, LF), the join/Force
# contract, timed steps that rethrow, and the not-started grace path. No corpus, TestDrive only.

BeforeAll {
    . "$PSScriptRoot/../../src/shared/log.ps1"

    $script:SavedEnv = @{
        DIR     = $env:CODEX_RUNLOG_DIR
        LEVEL   = $env:CODEX_RUNLOG_LEVEL
        CONSOLE = $env:CODEX_RUNLOG_CONSOLE
    }

    # the mirror writes via [Console]::Error — capture it deterministically, no Mock mechanics
    function Invoke-WithStdErr([scriptblock]$Body) {
        $sw = [System.IO.StringWriter]::new()
        $old = [Console]::Error
        [Console]::SetError($sw)
        try { & $Body } finally { [Console]::SetError($old) }
        return $sw.ToString()
    }

    function Read-TraceRecords([string]$Path) {
        @([System.IO.File]::ReadLines($Path) | Where-Object { $_ } | ForEach-Object { $_ | ConvertFrom-Json })
    }
}

AfterAll {
    $env:CODEX_RUNLOG_DIR = $script:SavedEnv.DIR
    $env:CODEX_RUNLOG_LEVEL = $script:SavedEnv.LEVEL
    $env:CODEX_RUNLOG_CONSOLE = $script:SavedEnv.CONSOLE
}

Describe 'run log substrate' {
    BeforeEach {
        $env:CODEX_RUNLOG_DIR = $null
        $env:CODEX_RUNLOG_LEVEL = $null
        $env:CODEX_RUNLOG_CONSOLE = $null
    }
    AfterEach {
        Stop-RunLog | Out-Null
    }

    Describe 'sink resolution' {
        It '-LogPath wins verbatim and the file appears' {
            $p = Join-Path $TestDrive 'explicit.jsonl'
            $got = Start-RunLog -Module t -LogPath $p -Force
            $got | Should -Be $p
            Test-Path -LiteralPath $p | Should -BeTrue
        }
        It '-RunDir lands trace.jsonl inside the run dir' {
            $d = Join-Path $TestDrive 'run1'; New-Item -ItemType Directory -Path $d | Out-Null
            $got = Start-RunLog -Module t -RunDir $d -Force
            $got | Should -Be (Join-Path $d 'trace.jsonl')
        }
        It 'CODEX_RUNLOG_DIR joins a parent run; a taken trace.jsonl means a sibling file, never a shared one' {
            $d = Join-Path $TestDrive 'parent-run'; New-Item -ItemType Directory -Path $d | Out-Null
            $env:CODEX_RUNLOG_DIR = $d
            (Start-RunLog -Module kid -Force) | Should -Be (Join-Path $d 'trace.jsonl')
            Stop-RunLog | Out-Null
            (Start-RunLog -Module kid2 -Force) | Should -Be (Join-Path $d "trace-kid2-$PID.jsonl")
        }
        It '-Export publishes the dir for children' {
            $d = Join-Path $TestDrive 'run-exp'; New-Item -ItemType Directory -Path $d | Out-Null
            Start-RunLog -Module t -RunDir $d -Export -Force | Out-Null
            $env:CODEX_RUNLOG_DIR | Should -Be $d
        }
        It 'a second Start JOINS the live context; -Force replaces it' {
            $p1 = Start-RunLog -Module first -LogPath (Join-Path $TestDrive 'a.jsonl') -Force
            (Start-RunLog -Module second -LogPath (Join-Path $TestDrive 'b.jsonl')) | Should -Be $p1
            (Start-RunLog -Module third -LogPath (Join-Path $TestDrive 'c.jsonl') -Force) | Should -Not -Be $p1
        }
    }

    Describe 'record shape + codepoint safety' {
        It 'records parse; ts/el/lvl/comp/msg present; run start carries module+pid; el is monotonic' {
            $p = Start-RunLog -Module shape -LogPath (Join-Path $TestDrive 'shape.jsonl') -Force
            Write-RunLog 'first'
            Write-RunLog 'second' -Level debug -Component sub
            $recs = Read-TraceRecords $p
            $recs.Count | Should -Be 3
            $recs[0].msg | Should -Be 'run start'
            $recs[0].data.module | Should -Be 'shape'
            $recs[0].data.pid | Should -Be $PID
            $recs[1].lvl | Should -Be 'info'
            $recs[1].comp | Should -Be 'shape'
            $recs[2].comp | Should -Be 'sub'
            # ConvertFrom-Json types ISO strings as [datetime] — assert the wire format on the raw line
            $recs[2].ts | Should -BeOfType [datetime]
            @([System.IO.File]::ReadLines($p))[2] | Should -Match '"ts":"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}[+-]\d{2}:\d{2}"'
            [long]$recs[2].el | Should -BeGreaterOrEqual ([long]$recs[1].el)
        }
        It 'data payload nests and round-trips; SMP + ligature codepoints survive' {
            $p = Start-RunLog -Module uni -LogPath (Join-Path $TestDrive 'uni.jsonl') -Force
            Write-RunLog "field 𝔽 ligature ﬁ" -Data @{ n = 3; inner = @{ path = 'x/y' } }
            $r = (Read-TraceRecords $p)[-1]
            $r.msg | Should -Be "field 𝔽 ligature ﬁ"
            $r.data.n | Should -Be 3
            $r.data.inner.path | Should -Be 'x/y'
        }
        It 'file bytes: UTF-8 without BOM, LF only' {
            $p = Start-RunLog -Module enc -LogPath (Join-Path $TestDrive 'enc.jsonl') -Force
            Write-RunLog 'ﬂow 𝒞'
            $bytes = [System.IO.File]::ReadAllBytes($p)
            ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) | Should -BeFalse
            [Array]::IndexOf($bytes, [byte]0x0D) | Should -Be (-1)
        }
    }

    Describe 'level gates' {
        It 'FileLevel info drops trace/debug from the file' {
            $p = Start-RunLog -Module gate -LogPath (Join-Path $TestDrive 'gate.jsonl') -FileLevel info -Force
            Write-RunLog 'noise' -Level trace
            Write-RunLog 'detail' -Level debug
            Invoke-WithStdErr { Write-RunLog 'kept' -Level warn } | Out-Null
            @((Read-TraceRecords $p) | ForEach-Object msg) | Should -Be @('run start', 'kept')
        }
        It 'console mirrors warn+ by default, stays silent below' {
            Start-RunLog -Module con -LogPath (Join-Path $TestDrive 'con.jsonl') -Force | Out-Null
            $err = Invoke-WithStdErr { Write-RunLog 'quiet info'; Write-RunLog 'loud' -Level warn }
            $err | Should -Not -Match 'quiet info'
            $err | Should -Match 'WARN\s+\[con\] loud'
        }
        It 'CODEX_RUNLOG_CONSOLE=off silences even errors; CODEX_RUNLOG_LEVEL overrides the file gate' {
            $env:CODEX_RUNLOG_CONSOLE = 'off'
            $env:CODEX_RUNLOG_LEVEL = 'error'
            $p = Start-RunLog -Module env -LogPath (Join-Path $TestDrive 'env.jsonl') -Force
            $err = Invoke-WithStdErr { Write-RunLog 'bad' -Level error; Write-RunLog 'mid' -Level warn }
            $err | Should -Be ''
            @((Read-TraceRecords $p) | ForEach-Object msg) | Should -Be @('bad')   # run start (info) gated too
        }
    }

    Describe 'timed steps' {
        It 'success: passes the result through, step end carries ok=true and a duration' {
            $p = Start-RunLog -Module step -LogPath (Join-Path $TestDrive 'step.jsonl') -Force
            $out = Measure-RunStep 'work' { 41 + 1 }
            $out | Should -Be 42
            $end = (Read-TraceRecords $p) | Where-Object { $_.data.step -eq 'work' -and $_.lvl -eq 'debug' }
            $end.data.ok | Should -BeTrue
            [long]$end.data.ms | Should -BeGreaterOrEqual 0
        }
        It 'failure: logs error with ok=false and RETHROWS' {
            $p = Start-RunLog -Module step2 -LogPath (Join-Path $TestDrive 'step2.jsonl') -Force
            { Invoke-WithStdErr { Measure-RunStep 'boom' { throw 'kaput' } } } | Should -Throw '*kaput*'
            $err = (Read-TraceRecords $p) | Where-Object { $_.lvl -eq 'error' }
            $err.data.ok | Should -BeFalse
            $err.msg | Should -Match 'kaput'
        }
    }

    Describe 'lifecycle + slicing' {
        It 'Stop writes the summary (total ms, warn/error counts), closes, returns the path; second Stop is null' {
            $p = Start-RunLog -Module life -LogPath (Join-Path $TestDrive 'life.jsonl') -Force
            Invoke-WithStdErr { Write-RunLog 'w1' -Level warn; Write-RunLog 'w2' -Level warn; Write-RunLog 'e1' -Level error } | Out-Null
            (Stop-RunLog) | Should -Be $p
            $end = (Read-TraceRecords $p)[-1]
            $end.msg | Should -Be 'run end'
            $end.data.warn | Should -Be 2
            $end.data.error | Should -Be 1
            (Stop-RunLog) | Should -BeNull
        }
        It 'not started: Write-RunLog never throws, warn+ still reaches stderr, nothing lands on disk' {
            Stop-RunLog | Out-Null
            $err = Invoke-WithStdErr { Write-RunLog 'lost info'; Write-RunLog 'seen' -Level warn }
            $err | Should -Match 'seen'
            $err | Should -Not -Match 'lost info'
        }
        It 'Get-RunLog slices by MinLevel and Component' {
            $p = Start-RunLog -Module slice -LogPath (Join-Path $TestDrive 'slice.jsonl') -Force
            Write-RunLog 'a' -Level debug -Component alpha
            Invoke-WithStdErr { Write-RunLog 'b' -Level warn -Component alpha; Write-RunLog 'c' -Level warn -Component beta } | Out-Null
            Stop-RunLog | Out-Null
            @(Get-RunLog $p -MinLevel warn).Count | Should -Be 2
            $hits = @(Get-RunLog $p -MinLevel debug -Component alpha)
            @($hits | ForEach-Object msg) | Should -Be @('a', 'b')
        }
    }
}
