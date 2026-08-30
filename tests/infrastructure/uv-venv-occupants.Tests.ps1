#requires -Version 7.0

BeforeAll {
    $script:RepositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
    . (Join-Path $script:RepositoryRoot 'brewery/uv/venv-occupants.ps1')
    $script:VenvPython = Join-Path $script:RepositoryRoot '.venv\Scripts\python.exe'
    $script:ConsoleScript = Join-Path $script:RepositoryRoot '.venv\Scripts\scientiae-procurement.exe'
    $script:PackageUv = Join-Path $script:RepositoryRoot 'packages\uv\uv.exe'
}

Describe 'project venv occupants' {
    It 'matches this checkout venv python and console script' {
        Test-ProjectVenvOccupant -RepositoryRoot $script:RepositoryRoot -ProcessId 4242 `
            -ExecutablePath $script:VenvPython | Should -BeTrue
        Test-ProjectVenvOccupant -RepositoryRoot $script:RepositoryRoot -ProcessId 4242 `
            -ExecutablePath $script:ConsoleScript | Should -BeTrue
    }

    It 'matches the pinned uv host running scientiae-procurement' {
        $command = '"' + $script:PackageUv + '" run --project . --locked --no-sync --no-dev --offline scientiae-procurement'
        Test-ProjectVenvOccupant -RepositoryRoot $script:RepositoryRoot -ProcessId 4242 `
            -ExecutablePath $script:PackageUv -CommandLine $command | Should -BeTrue
    }

    It 'does not match the restore uv process or unrelated executables' {
        Test-ProjectVenvOccupant -RepositoryRoot $script:RepositoryRoot -ProcessId 4242 `
            -ExecutablePath $script:PackageUv -CommandLine ('"' + $script:PackageUv + '" sync --project .') |
            Should -BeFalse
        Test-ProjectVenvOccupant -RepositoryRoot $script:RepositoryRoot -ProcessId $PID `
            -ExecutablePath $script:VenvPython | Should -BeFalse
        Test-ProjectVenvOccupant -RepositoryRoot $script:RepositoryRoot -ProcessId 4242 `
            -ExecutablePath 'C:\Windows\System32\notepad.exe' | Should -BeFalse
    }
}
