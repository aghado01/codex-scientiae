function Resolve-BatchPlanPath {
    param([Parameter(Mandatory)] [string] $Path, [Parameter(Mandatory)] [string] $BasePath)
    if ([System.IO.Path]::IsPathFullyQualified($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }
    return [System.IO.Path]::GetFullPath($Path, $BasePath)
}

function Resolve-BatchPlanModuleReference {
    param(
        [Parameter(Mandatory)] [string] $Module,
        [Parameter(Mandatory)] [string] $BasePath
    )
    if ([string]::IsNullOrWhiteSpace($Module)) { throw 'module reference must not be empty' }
    $looksLikePath = [System.IO.Path]::IsPathFullyQualified($Module) -or
        $Module.Contains([System.IO.Path]::DirectorySeparatorChar) -or
        $Module.Contains([System.IO.Path]::AltDirectorySeparatorChar) -or
        [System.IO.Path]::GetExtension($Module) -in @('.psd1', '.psm1', '.dll')
    if ($looksLikePath) {
        $resolved = Resolve-BatchPlanPath -Path $Module -BasePath $BasePath
        if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) {
            throw "module is unavailable: '$Module'"
        }
        return (Resolve-Path -LiteralPath $resolved).Path
    }
    if ($null -eq (Get-Module -ListAvailable -Name $Module | Select-Object -First 1)) {
        throw "module is unavailable: '$Module'"
    }
    return $Module
}
