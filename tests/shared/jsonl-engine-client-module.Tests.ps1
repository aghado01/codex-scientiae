#requires -Version 7.0

BeforeDiscovery {
    $repository = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $candidate = Join-Path $repository '.venv/Scripts/python.exe'
    if (-not [System.IO.File]::Exists($candidate)) {
        $candidate = Join-Path $repository '.venv/bin/python'
    }
    $script:JsonlClientPythonAvailable = [System.IO.File]::Exists($candidate)
}

BeforeAll {
    $script:RepoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $script:Manifest = Join-Path $script:RepoRoot `
        'src/shared/jsonl-engine-client/jsonl-engine-client.psd1'
    $script:Python = Join-Path $script:RepoRoot '.venv/Scripts/python.exe'
    if (-not [System.IO.File]::Exists($script:Python)) {
        $script:Python = Join-Path $script:RepoRoot '.venv/bin/python'
    }
    $script:Utf8 = [System.Text.UTF8Encoding]::new($false, $true)

    function New-JsonlClientTestLauncher {
        param(
            [Parameter(Mandatory)] [string] $Directory,
            [Parameter(Mandatory)] [string] $Name,
            [Parameter(Mandatory)] [string] $Source
        )

        $sourcePath = Join-Path $Directory "$Name.py"
        [System.IO.File]::WriteAllText($sourcePath, $Source, $script:Utf8)
        if ($IsWindows) {
            $launcherPath = Join-Path $Directory "$Name.cmd"
            $launcher = "@echo off`r`n`"$script:Python`" `"$sourcePath`"`r`nexit /b %ERRORLEVEL%`r`n"
            [System.IO.File]::WriteAllText($launcherPath, $launcher, [System.Text.Encoding]::ASCII)
            return $launcherPath
        }

        $launcherPath = Join-Path $Directory $Name
        $launcher = "#!/bin/sh`nexec '$script:Python' '$sourcePath'`n"
        [System.IO.File]::WriteAllText($launcherPath, $launcher, $script:Utf8)
        [System.IO.File]::SetUnixFileMode($launcherPath, [System.IO.UnixFileMode]493)
        return $launcherPath
    }

    $script:ExpectedExports = @(
        'Find-JsonlRecord'
        'Get-JsonlCount'
        'Get-JsonlEngineCapability'
        'Get-JsonlHead'
        'Get-JsonlInfo'
        'Get-JsonlRange'
        'Get-JsonlRecord'
        'Get-JsonlSchema'
        'Get-JsonlSignature'
        'Get-JsonlTail'
        'Invoke-JsonlEngineCommand'
        'New-JsonlEngineInputFile'
        'New-JsonlSnapshot'
        'Read-JsonDocument'
        'Select-JsonlPath'
        'Test-JsonlStore'
    )
}

Describe 'jsonl-engine-client module' {
    It 'imports only its declared surface from outside the repository working directory' {
        $before = @(Get-ChildItem -LiteralPath (Split-Path $script:Manifest -Parent) `
                -Recurse -File | ForEach-Object FullName | Sort-Object)
        Push-Location $TestDrive
        try {
            Import-Module -Name $script:Manifest -Force -ErrorAction Stop -WarningAction Stop
            Import-Module -Name $script:Manifest -ErrorAction Stop -WarningAction Stop
        }
        finally {
            Pop-Location
        }

        $actual = @((Get-Command -Module jsonl-engine-client).Name | Sort-Object)
        $actual | Should -Be $script:ExpectedExports
        Get-Command Resolve-JsonlEngineRuntime -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        Get-Command Invoke-JsonlEngineProcess -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        @(Get-Alias | Where-Object Source -eq 'jsonl-engine-client').Count | Should -Be 0

        $after = @(Get-ChildItem -LiteralPath (Split-Path $script:Manifest -Parent) `
                -Recurse -File | ForEach-Object FullName | Sort-Object)
        $after | Should -Be $before
    }

    It 'uses the repository interpreter by default and accepts the same interpreter explicitly' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        [System.IO.File]::Exists($script:Python) | Should -BeTrue
        $default = Get-JsonlEngineCapability
        $explicit = Get-JsonlEngineCapability -PythonPath $script:Python

        $default.protocol | Should -Be 'codex-scientiae/jsonl-engine-cli'
        $default.version | Should -Be 1
        $default.framing | Should -BeTrue
        @($default.verbs).Count | Should -Be 16
        @($default.verbs) | Should -Contain 'deposit'
        @($default.verbs) | Should -Contain 'validate-json'
        $explicit | ConvertTo-Json -Compress | Should -Be ($default | ConvertTo-Json -Compress)
        { Get-JsonlEngineCapability -PythonPath (Join-Path $TestDrive 'missing-python.exe') } |
            Should -Throw '*interpreter not found*'

        $prior = [System.Environment]::GetEnvironmentVariable('CODEX_JSONL_ENGINE_PYTHON')
        try {
            $env:CODEX_JSONL_ENGINE_PYTHON = Join-Path $TestDrive 'ambient-missing.exe'
            { Get-JsonlEngineCapability } | Should -Throw '*interpreter not found*'
            (Get-JsonlEngineCapability -PythonPath $script:Python).version | Should -Be 1
        }
        finally {
            if ($null -eq $prior) {
                Remove-Item Env:CODEX_JSONL_ENGINE_PYTHON -ErrorAction SilentlyContinue
            }
            else {
                $env:CODEX_JSONL_ENGINE_PYTHON = $prior
            }
        }
    }

    It 'preserves one frame per array, scalar, null, and object across a spaced Unicode path' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $path = Join-Path $TestDrive 'values space 日本語.jsonl'
        [System.IO.File]::WriteAllText(
            $path,
            "[1,2]`n7`nnull`n{`"name`":`"日本語`",`"math`":`"∫`"}`n",
            $script:Utf8)

        $values = @(Get-JsonlHead -Path $path -Count 4)
        $values.Count | Should -Be 4
        $values[0].GetType().FullName | Should -Be 'System.Object[]'
        @($values[0]) | Should -Be @(1, 2)
        $values[1] | Should -Be 7
        $values[2].GetType().FullName |
            Should -Be 'System.Management.Automation.Language.NullString'
        ($values[2] | ConvertTo-Json -Compress) | Should -Be 'null'
        $values[3].name | Should -Be '日本語'
        $values[3].math | Should -Be '∫'

        $frames = @(Get-JsonlHead -Path $path -Count 4 -AsFrame)
        $frames.Count | Should -Be 4
        @($frames.sequence) | Should -Be @(0, 1, 2, 3)
        @($frames | ForEach-Object { $_.PSObject.TypeNames[0] } | Select-Object -Unique) |
            Should -Be @('JsonlEngine.CliValueFrame')
    }

    It 'resolves a relative artifact path against the caller location' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $callerDirectory = Join-Path $TestDrive 'relative-artifact-caller'
        [void][System.IO.Directory]::CreateDirectory($callerDirectory)
        $leaf = "caller-$([guid]::NewGuid().ToString('N')).jsonl"
        [System.IO.File]::WriteAllText(
            (Join-Path $callerDirectory $leaf), "{`"n`":17}`n", $script:Utf8)

        Push-Location $callerDirectory
        try {
            $record = Get-JsonlRecord -Path (Join-Path '.' $leaf) -At 0
        }
        finally {
            Pop-Location
        }

        $record.n | Should -Be 17
    }

    It 'resolves a relative snapshot destination against the caller location' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $source = Join-Path $TestDrive 'relative-snapshot-source.jsonl'
        [System.IO.File]::WriteAllText($source, "{`"n`":23}`n", $script:Utf8)
        $callerDirectory = Join-Path $TestDrive 'relative-snapshot-caller'
        [void][System.IO.Directory]::CreateDirectory($callerDirectory)
        $leaf = "snapshot-$([guid]::NewGuid().ToString('N')).jsonl"
        $callerDestination = Join-Path $callerDirectory $leaf
        $unexpectedRepositoryDestination = Join-Path $script:RepoRoot $leaf

        try {
            Push-Location $callerDirectory
            try {
                New-JsonlSnapshot -Path $source -Destination (Join-Path '.' $leaf) | Out-Null
            }
            finally {
                Pop-Location
            }

            [System.IO.File]::Exists($callerDestination) | Should -BeTrue
            [System.IO.File]::ReadAllText($callerDestination, $script:Utf8) |
                Should -Be "{`"n`":23}`n"
            [System.IO.File]::Exists($unexpectedRepositoryDestination) | Should -BeFalse
        }
        finally {
            if ([System.IO.File]::Exists($unexpectedRepositoryDestination)) {
                [System.IO.File]::Delete($unexpectedRepositoryDestination)
            }
        }
    }

    It 'retains case-distinct object keys in hashtable mode' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $path = Join-Path $TestDrive 'case-keys.jsonl'
        [System.IO.File]::WriteAllText($path, "{`"A`":1,`"a`":2}`n", $script:Utf8)

        $record = Get-JsonlRecord -Path $path -At 0 -AsHashtable
        $record.GetType().FullName | Should -Be 'System.Management.Automation.OrderedHashtable'
        $record['A'] | Should -Be 1
        $record['a'] | Should -Be 2
        { Get-JsonlRecord -Path $path -At 0 } | Should -Throw '*-AsHashTable*'
    }

    It 'keeps stderr separate and translates argument and runtime failures' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        { Invoke-JsonlEngineCommand -Verb head } |
            Should -Throw '*exit code 2*ArgumentError*required*'
        { Get-JsonlRecord -Path (Join-Path $TestDrive 'absent.jsonl') -At 0 } |
            Should -Throw '*exit code 1*FileNotFoundError*'
    }

    It 'enforces a total timeout and terminates the launched descendant process' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $pidPath = Join-Path $TestDrive 'descendant.pid'
        $pidLiteral = ConvertTo-Json -InputObject $pidPath -Compress
        $fakePython = New-JsonlClientTestLauncher -Directory $TestDrive -Name 'slow-python' -Source @"
import subprocess
import sys
import time

child = subprocess.Popen([sys.executable, "-c", "import time; time.sleep(60)"])
with open($pidLiteral, "w", encoding="ascii") as marker:
    marker.write(str(child.pid))
    marker.flush()
time.sleep(60)
"@

        $clock = [System.Diagnostics.Stopwatch]::StartNew()
        { Invoke-JsonlEngineCommand -Verb capabilities -PythonPath $fakePython -TimeoutSeconds 2 } |
            Should -Throw '*timed out after 2 s*'
        $clock.Stop()
        $clock.Elapsed.TotalSeconds | Should -BeLessThan 10
        [System.IO.File]::Exists($pidPath) | Should -BeTrue

        $descendantPid = [int][System.IO.File]::ReadAllText($pidPath)
        $descendantAlive = $true
        for ($attempt = 0; $attempt -lt 100; $attempt++) {
            try {
                $descendant = [System.Diagnostics.Process]::GetProcessById($descendantPid)
                $descendantAlive = -not $descendant.HasExited
                $descendant.Dispose()
            }
            catch [System.ArgumentException] {
                $descendantAlive = $false
            }
            if (-not $descendantAlive) { break }
            Start-Sleep -Milliseconds 50
        }
        try {
            $descendantAlive | Should -BeFalse
        }
        finally {
            if ($descendantAlive) {
                try {
                    $descendant = [System.Diagnostics.Process]::GetProcessById($descendantPid)
                    $descendant.Kill($true)
                    [void]$descendant.WaitForExit(5000)
                    $descendant.Dispose()
                }
                catch [System.ArgumentException] {
                    # It exited between the assertion and best-effort test cleanup.
                }
            }
        }
    }

    It 'rejects ambiguous view requests before starting Python' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $path = Join-Path $TestDrive 'one.jsonl'
        [System.IO.File]::WriteAllText($path, "{`"n`":1}`n", $script:Utf8)

        { Get-JsonlHead $path -AtSignature -Unbounded } |
            Should -Throw '*mutually exclusive*'
        { Get-JsonlHead $path -View Signed -Unbounded } |
            Should -Throw '*cannot be combined*'
    }

    It 'supports typed and legacy raw-JSON find values without quoting ambiguity' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $path = Join-Path $TestDrive 'find.jsonl'
        [System.IO.File]::WriteAllText(
            $path,
            "{`"name`":`"alpha`",`"n`":1}`n{`"name`":`"beta`",`"n`":2}`n",
            $script:Utf8)

        @(Find-JsonlRecord $path /name eq '"beta"').name | Should -Be @('beta')
        @(Find-JsonlRecord $path /name eq -JsonValue '"alpha"').name |
            Should -Be @('alpha')
        @(Find-JsonlRecord $path /name eq -InputObject 'alpha').name | Should -Be @('alpha')
        @(Find-JsonlRecord $path /n gt -InputObject 1).name | Should -Be @('beta')
        { Find-JsonlRecord $path /n eq -InputObject ([double]::NaN) } |
            Should -Throw '*non-finite double*'
        { Find-JsonlRecord $path /name exists -InputObject 'unused' } |
            Should -Throw '*does not accept*'
    }

    It 'preserves the compatibility facade named -Value raw-JSON contract' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $path = Join-Path $TestDrive 'legacy-named-find.jsonl'
        [System.IO.File]::WriteAllText(
            $path,
            "{`"name`":`"alpha`"}`n{`"name`":`"beta`"}`n",
            $script:Utf8)

        @(Find-JsonlRecord $path /name eq -Value '"beta"').name | Should -Be @('beta')
    }

    It 'rejects non-integer version and sequence fields instead of coercing them' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $invalidFrames = [ordered]@{
            version = '{"protocol":"codex-scientiae/jsonl-engine-cli","version":"1","type":"value","sequence":0,"value":1}'
            sequence = '{"protocol":"codex-scientiae/jsonl-engine-cli","version":1,"type":"value","sequence":"0","value":1}'
        }
        $accepted = [System.Collections.Generic.List[string]]::new()
        foreach ($case in $invalidFrames.GetEnumerator()) {
            $lineLiteral = ConvertTo-Json -InputObject ($case.Value + "`n") -Compress
            $fakePython = New-JsonlClientTestLauncher -Directory $TestDrive `
                -Name "invalid-$($case.Key)-frame" `
                -Source "import sys`nsys.stdout.write($lineLiteral)`n"
            try {
                Invoke-JsonlEngineCommand -Verb capabilities -PythonPath $fakePython | Out-Null
                $accepted.Add([string]$case.Key)
            }
            catch {
                # Rejection is the protocol contract under test.
            }
        }

        $accepted.ToArray() | Should -BeNullOrEmpty
    }

    It 'accepts only one exactly typed JSON error frame on stderr' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $validError = '{"protocol":"codex-scientiae/jsonl-engine-cli","version":1,"type":"error","error":"ProbeError","message":"probe failed"}'
        $errorCases = @(
            [pscustomobject]@{ Name = 'exact'; Lines = @($validError); Structured = $true }
            [pscustomobject]@{
                Name = 'string-version'
                Lines = @('{"protocol":"codex-scientiae/jsonl-engine-cli","version":"1","type":"error","error":"ProbeError","message":"probe failed"}')
                Structured = $false
            }
            [pscustomobject]@{
                Name = 'numeric-error'
                Lines = @('{"protocol":"codex-scientiae/jsonl-engine-cli","version":1,"type":"error","error":7,"message":"probe failed"}')
                Structured = $false
            }
            [pscustomobject]@{
                Name = 'extra-line'
                Lines = @('unexpected diagnostic', $validError)
                Structured = $false
            }
        )

        $mismatches = [System.Collections.Generic.List[string]]::new()
        foreach ($case in $errorCases) {
            $sourceLines = [System.Collections.Generic.List[string]]::new()
            $sourceLines.Add('import sys')
            foreach ($line in $case.Lines) {
                $lineLiteral = ConvertTo-Json -InputObject ($line + "`n") -Compress
                $sourceLines.Add("sys.stderr.write($lineLiteral)")
            }
            $sourceLines.Add('raise SystemExit(1)')
            $fakePython = New-JsonlClientTestLauncher -Directory $TestDrive `
                -Name "error-$($case.Name)" -Source (($sourceLines.ToArray() -join "`n") + "`n")

            $failure = $null
            try {
                Invoke-JsonlEngineCommand -Verb capabilities -PythonPath $fakePython | Out-Null
            }
            catch {
                $failure = $_.Exception
            }
            if ($null -eq $failure) {
                $mismatches.Add("$($case.Name): no terminating error")
                continue
            }
            $isStructured = $null -ne $failure.Data['ProtocolError']
            if ($isStructured -ne $case.Structured) {
                $mismatches.Add("$($case.Name): structured=$isStructured")
            }
        }

        $mismatches.ToArray() | Should -BeNullOrEmpty
    }

    It 'rejects invalid UTF-8 protocol bytes instead of replacing them' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $fakePython = New-JsonlClientTestLauncher -Directory $TestDrive `
            -Name 'invalid-utf8-frame' -Source @'
import sys
sys.stdout.buffer.write(b'{"protocol":"codex-scientiae/jsonl-engine-cli","version":1,"type":"value","sequence":0,"value":"\xff"}\n')
'@
        $values = [System.Collections.Generic.List[object]]::new()
        $failure = $null
        try {
            Invoke-JsonlEngineCommand -Verb capabilities -PythonPath $fakePython |
                ForEach-Object { $values.Add($_) }
        }
        catch {
            $failure = $_.Exception
        }

        $values.Count | Should -Be 0
        $failure | Should -Not -BeNullOrEmpty
    }

    It 'does not release partial values when the engine later exits with failure' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $path = Join-Path $TestDrive 'late-failure.jsonl'
        [System.IO.File]::WriteAllText($path, "{`"n`":1}`nnot-json`n", $script:Utf8)
        $values = [System.Collections.Generic.List[object]]::new()
        $failure = $null
        try {
            Get-JsonlHead -Path $path -Count 2 | ForEach-Object { $values.Add($_) }
        }
        catch {
            $failure = $_.Exception
        }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Message | Should -Match 'JsonReaderError'
        $values.Count | Should -Be 0
    }

    It 'stages strict UTF-8 LF input and reports caller versus temporary ownership' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $path = Join-Path $TestDrive 'request space 日本語.json'
        $result = New-JsonlEngineInputFile -InputObject ([ordered]@{
                text = '∫ 日本語'
                rows = @([ordered]@{ n = 1 })
            }) -Path $path
        $bytes = [System.IO.File]::ReadAllBytes($result.Path)

        $result.PSObject.TypeNames[0] | Should -Be 'JsonlEngine.InputFile'
        $result.IsTemporary | Should -BeFalse
        $bytes[-1] | Should -Be 10
        ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and
            $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) | Should -BeFalse
        (Read-JsonDocument $result.Path).text | Should -Be '∫ 日本語'
        { New-JsonlEngineInputFile -InputObject @{} -Path $path } |
            Should -Throw '*already exists*'
        { New-JsonlEngineInputFile -InputObject @{ value = [double]::NaN } `
                -Path (Join-Path $TestDrive 'nan.json') } |
            Should -Throw '*non-finite double*'
        $failureParent = Join-Path $TestDrive 'serialization-failure-parent'
        { New-JsonlEngineInputFile -InputObject @{ value = [double]::NaN } `
                -Path (Join-Path $failureParent 'nan.json') } |
            Should -Throw '*non-finite double*'
        [System.IO.Directory]::Exists($failureParent) | Should -BeFalse
        New-JsonlEngineInputFile -InputObject @{ text = 'replacement' } -Path $path `
            -ExistingFile Replace | Out-Null
        (Read-JsonDocument $path).text | Should -Be 'replacement'
        @(Get-ChildItem -LiteralPath $TestDrive -Filter '*.tmp' -File).Count | Should -Be 0

        $configuredScratch = Join-Path $TestDrive 'configured-json-scratch'
        $priorScratch = [System.Environment]::GetEnvironmentVariable('CODEX_JSON_SCRATCH_ROOT')
        $temporary = $null
        try {
            $env:CODEX_JSON_SCRATCH_ROOT = $configuredScratch
            $temporary = New-JsonlEngineInputFile -InputObject $null
            $temporary.IsTemporary | Should -BeTrue
            [System.IO.Path]::GetDirectoryName($temporary.Path) |
                Should -Be ([System.IO.Path]::GetFullPath($configuredScratch))
            @(Read-JsonDocument $temporary.Path).Count | Should -Be 1
        }
        finally {
            if ($null -ne $temporary -and [System.IO.File]::Exists($temporary.Path)) {
                [System.IO.File]::Delete($temporary.Path)
            }
            if ($null -eq $priorScratch) {
                Remove-Item Env:CODEX_JSON_SCRATCH_ROOT -ErrorAction SilentlyContinue
            }
            else {
                $env:CODEX_JSON_SCRATCH_ROOT = $priorScratch
            }
        }
    }

    It 'returns the first requested value from a large successful buffered result' `
            -Skip:(-not $script:JsonlClientPythonAvailable) {
        $path = Join-Path $TestDrive 'many.jsonl'
        $builder = [System.Text.StringBuilder]::new()
        for ($index = 0; $index -lt 5000; $index++) {
            [void]$builder.Append("{`"n`":$index}`n")
        }
        [System.IO.File]::WriteAllText($path, $builder.ToString(), $script:Utf8)

        $clock = [System.Diagnostics.Stopwatch]::StartNew()
        $first = @(Get-JsonlHead $path 5000 | Select-Object -First 1)
        $clock.Stop()
        $first.Count | Should -Be 1
        $first[0].n | Should -Be 0
        $clock.Elapsed.TotalSeconds | Should -BeLessThan 15
    }
}
