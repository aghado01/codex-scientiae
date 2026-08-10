#requires -Version 7
<#
.SYNOPSIS
  Verify and publish the Doccer engine payload to packages/doccer.

.DESCRIPTION
  First-party engine source lives under src/doccer. This brewery recipe places all
  compilation intermediates and publish staging under artifacts/doccer (bin and obj via
  Directory.Build.props, publish below), runs the dependency-free contract harness, and
  releases the reusable assembly plus thin CLI to packages/doccer. artifacts/ is working
  output only — the delivered payload lives in packages/.
#>
[CmdletBinding()]
param(
    [ValidateSet('Debug', 'Release')]
    [string] $Configuration = 'Release',
    [string] $Runtime = 'win-x64',
    [switch] $SelfContained,
    [switch] $SkipTests
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$testsProject = Join-Path $PSScriptRoot 'Doccer.Tests.csproj'
$cliProject = Join-Path $PSScriptRoot 'Doccer.Cli.csproj'
$packageDir = Join-Path $repo 'packages/doccer'
# Publish staging is a stage of doccer's own build, so it lives with doccer's other build
# output under artifacts/doccer — never a top-level artifacts/publish bucket. Nothing is
# delivered from artifacts: the payload is released to packages/doccer below.
$stagingDir = Join-Path $repo 'artifacts/doccer/publish'
$packagesRoot = [IO.Path]::GetFullPath((Join-Path $repo 'packages'))
$artifactsRoot = [IO.Path]::GetFullPath((Join-Path $repo 'artifacts'))

if ([IO.Path]::GetDirectoryName([IO.Path]::GetFullPath($packageDir)) -ne $packagesRoot) {
    throw "Refusing unsafe package target: $packageDir"
}
if (-not [IO.Path]::GetFullPath($stagingDir).StartsWith($artifactsRoot + [IO.Path]::DirectorySeparatorChar)) {
    throw "Refusing unsafe staging target: $stagingDir"
}

$harnessChecks = $null
if (-not $SkipTests) {
    $harnessOutput = & dotnet run --project $testsProject -c $Configuration
    if ($LASTEXITCODE -ne 0) { throw "Doccer contract harness failed ($LASTEXITCODE)." }
    $harnessOutput | Write-Host
    $harnessMatch = [regex]::Match(($harnessOutput -join "`n"), 'harness: (\d+) checks passed')
    if ($harnessMatch.Success) { $harnessChecks = [int]$harnessMatch.Groups[1].Value }
}

if (Test-Path -LiteralPath $stagingDir) {
    Remove-Item -LiteralPath $stagingDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $stagingDir | Out-Null

$publishArgs = @(
    'publish', $cliProject
    '-c', $Configuration
    '-r', $Runtime
    ($SelfContained ? '--self-contained' : '--no-self-contained')
    '-p:PublishSingleFile=false'
    '-o', $stagingDir
)

& dotnet @publishArgs
if ($LASTEXITCODE -ne 0) { throw "Doccer publish failed ($LASTEXITCODE)." }

$assembly = Join-Path $stagingDir 'CodexSci.Doccer.dll'
$executable = Join-Path $stagingDir 'doccer.exe'
if (-not (Test-Path -LiteralPath $assembly) -or -not (Test-Path -LiteralPath $executable)) {
    throw 'Publish succeeded but the expected Doccer library and CLI payloads were not both found.'
}

if (Test-Path -LiteralPath $packageDir) {
    Remove-Item -LiteralPath $packageDir -Recurse -Force
}
Move-Item -LiteralPath $stagingDir -Destination $packageDir

# Smoke-test the DELIVERED payload, not the build output: load the packaged assembly, assert the
# public surface consumers bind against, and run the packaged CLI once. Runs in a child process
# so the loaded DLL is never locked by this session. The manifest is written only after this
# passes — a package without doccer.manifest.json is an unverified package.
$smokeScript = @'
param([string] $PackageDir)
$ErrorActionPreference = 'Stop'
$assembly = [System.Reflection.Assembly]::LoadFrom((Join-Path $PackageDir 'CodexSci.Doccer.dll'))
$expectedTypes = @(
    'CodexSci.Doccer.TextMaster'
    'CodexSci.Doccer.TextSpan'
    'CodexSci.Doccer.TextTopology'
    'CodexSci.Doccer.SpanBatch'
    'CodexSci.Doccer.SpanBatchBuilder'
    'CodexSci.Doccer.ClaimSelection'
    'CodexSci.Doccer.ClaimPairView'
    'CodexSci.Doccer.ClaimPairWitnessView'
    'CodexSci.Doccer.PairingPolicy'
    'CodexSci.Doccer.PairingResult'
    'CodexSci.Doccer.PairingFaults'
    'CodexSci.Doccer.Pairing'
    'CodexSci.Doccer.SortedSpanLookup'
    'CodexSci.Doccer.SpanSet'
    'CodexSci.Doccer.LocatedRelation'
    'CodexSci.Doccer.CandidateRegionGraph'
    'CodexSci.Doccer.ReachabilityView'
    'CodexSci.Doccer.PartitionView'
    'CodexSci.Doccer.SegmentationPolicy'
    'CodexSci.Doccer.SegmentationResult'
    'CodexSci.Doccer.SegmentationResidual'
    'CodexSci.Doccer.Segmentation'
    'CodexSci.Doccer.PathSelectionGuarantee'
    'CodexSci.Doccer.PathTieBreak'
    'CodexSci.Doccer.PathFeasibility'
    'CodexSci.Doccer.AdditivePathPolicy'
    'CodexSci.Doccer.PathSelectionProblem'
    'CodexSci.Doccer.PathSelectionResidual'
    'CodexSci.Doccer.PathSelectionResult'
    'CodexSci.Doccer.PathSelection'
    'CodexSci.Doccer.PackingPolicy'
    'CodexSci.Doccer.PackingView'
    'CodexSci.Doccer.CoverPolicy'
    'CodexSci.Doccer.CoverView'
    'CodexSci.Doccer.LaminarCrossingRule'
    'CodexSci.Doccer.LaminarFamilyPolicy'
    'CodexSci.Doccer.LaminarGroup'
    'CodexSci.Doccer.LaminarView'
    'CodexSci.Doccer.LaminarAdmissionOrder'
    'CodexSci.Doccer.LaminarAdmissionGuarantee'
    'CodexSci.Doccer.LaminarAdmissionPolicy'
    'CodexSci.Doccer.LaminarAdmissionResult'
    'CodexSci.Doccer.Laminarizer'
    'CodexSci.Doccer.HierarchyConstruction'
    'CodexSci.Doccer.HierarchyTieBreak'
    'CodexSci.Doccer.HierarchyPolicy'
    'CodexSci.Doccer.HierarchyEdge'
    'CodexSci.Doccer.HierarchyView'
    'CodexSci.Doccer.LaminarHierarchy'
    'CodexSci.Doccer.ResolutionLayerPolicy'
    'CodexSci.Doccer.ResolutionView'
    'CodexSci.Doccer.ResolutionMapContract'
    'CodexSci.Doccer.ResolutionMapPolicy'
    'CodexSci.Doccer.ResolutionEdge'
    'CodexSci.Doccer.ResolutionMap'
    'CodexSci.Doccer.FactKey'
    'CodexSci.Doccer.CanonicalFactTable'
    'CodexSci.Doccer.FactReference'
    'CodexSci.Doccer.SupportEdge'
    'CodexSci.Doccer.SupportHypergraph'
    'CodexSci.Doccer.GroundRule'
    'CodexSci.Doccer.SaturationProblem'
    'CodexSci.Doccer.SaturationResult'
    'CodexSci.Doccer.FactSaturation'
    'CodexSci.Doccer.BooleanVector'
    'CodexSci.Doccer.BooleanPrefixParityResult'
    'CodexSci.Doccer.Utf16UnitMask'
    'CodexSci.Doccer.Utf16PrefixParityContinuation'
    'CodexSci.Doccer.Utf16PrefixParityResult'
    'CodexSci.Doccer.UnitClassifierStamp'
    'CodexSci.Doccer.UnitTruthState'
    'CodexSci.Doccer.Utf16UnitClassification'
    'CodexSci.Doccer.Utf16ClassificationPrefixParityResult'
    'CodexSci.Doccer.UnitMaskClaimStamp'
    'CodexSci.Doccer.Utf16UnitHarvestResult'
    'CodexSci.Doccer.Utf16ClaimEmissionResult'
    'CodexSci.Doccer.RegexCollector'
    'CodexSci.Doccer.PatternRule'
    'CodexSci.Doccer.ExecutionScope'
    'CodexSci.Doccer.PatternRuleLoader'
    'CodexSci.Doccer.AllenAlgebra'
    'CodexSci.Doccer.IntervalJoins'
    'CodexSci.Doccer.Suppression'
    'CodexSci.Doccer.DoccerValidation'
)
foreach ($typeName in $expectedTypes) {
    $expectedType = $assembly.GetType($typeName, $false)
    if ($null -eq $expectedType -or -not $expectedType.IsPublic) {
        throw "Packaged assembly is missing expected public type $typeName."
    }
}
$lookup = $assembly.GetType('CodexSci.Doccer.SortedSpanLookup', $true)
if ($null -eq $lookup.GetMethod('FindContaining')) {
    throw 'Packaged SortedSpanLookup is missing FindContaining.'
}
$pairView = $assembly.GetType('CodexSci.Doccer.ClaimPairView', $true)
if ($null -eq $pairView.GetMethod('ComposePairs') -or
    $null -eq $pairView.GetMethod('GroupMiddleWitnesses')) {
    throw 'Packaged ClaimPairView is missing its exact composition surface.'
}
$pairing = $assembly.GetType('CodexSci.Doccer.Pairing', $true)
$pairingResult = $assembly.GetType('CodexSci.Doccer.PairingResult', $true)
if ($null -eq $pairing.GetMethod('Pair') -or
    $null -eq $pairingResult.GetMethod('PairedRegions')) {
    throw 'Packaged pairing surface is incomplete.'
}
$segmentation = $assembly.GetType('CodexSci.Doccer.Segmentation', $true)
$reachability = $assembly.GetType('CodexSci.Doccer.ReachabilityView', $true)
$partition = $assembly.GetType('CodexSci.Doccer.PartitionView', $true)
if ($null -eq $segmentation.GetMethod('FirstOrdinalCompletePath') -or
    $null -eq $reachability.GetMethod('Create') -or
    $null -eq $partition.GetMethod('Create')) {
    throw 'Packaged K4a segmentation surface is incomplete.'
}
$pathPolicy = $assembly.GetType('CodexSci.Doccer.AdditivePathPolicy', $true)
$pathProblem = $assembly.GetType('CodexSci.Doccer.PathSelectionProblem', $true)
$pathSelection = $assembly.GetType('CodexSci.Doccer.PathSelection', $true)
if ($null -eq $pathPolicy.GetMethod('Create') -or
    $null -eq $pathProblem.GetMethod('Create') -or
    $null -eq $pathSelection.GetMethod('Select')) {
    throw 'Packaged K4b path-selection surface is incomplete.'
}
$packing = $assembly.GetType('CodexSci.Doccer.PackingView', $true)
$cover = $assembly.GetType('CodexSci.Doccer.CoverView', $true)
$laminar = $assembly.GetType('CodexSci.Doccer.LaminarView', $true)
$laminarizer = $assembly.GetType('CodexSci.Doccer.Laminarizer', $true)
$hierarchy = $assembly.GetType('CodexSci.Doccer.HierarchyView', $true)
$laminarHierarchy = $assembly.GetType('CodexSci.Doccer.LaminarHierarchy', $true)
$resolution = $assembly.GetType('CodexSci.Doccer.ResolutionView', $true)
$resolutionMap = $assembly.GetType('CodexSci.Doccer.ResolutionMap', $true)
if ($null -eq $packing.GetMethod('Create') -or
    $null -eq $cover.GetMethod('Create') -or
    $null -eq $laminar.GetMethod('Create') -or
    $null -eq $laminarizer.GetMethod('Admit') -or
    $null -eq $hierarchy.GetMethod('Create') -or
    $null -eq $laminarHierarchy.GetMethod('NearestContainers') -or
    $null -eq $resolution.GetMethod('Create') -or
    $null -eq $resolutionMap.GetMethod('Create')) {
    throw 'Packaged K4c structural-family surface is incomplete.'
}
$factTable = $assembly.GetType('CodexSci.Doccer.CanonicalFactTable', $true)
$supportGraph = $assembly.GetType('CodexSci.Doccer.SupportHypergraph', $true)
$groundRule = $assembly.GetType('CodexSci.Doccer.GroundRule', $true)
$saturationProblem = $assembly.GetType('CodexSci.Doccer.SaturationProblem', $true)
$saturationResult = $assembly.GetType('CodexSci.Doccer.SaturationResult', $true)
$factSaturation = $assembly.GetType('CodexSci.Doccer.FactSaturation', $true)
$problemCreate = $saturationProblem.GetMethod('Create')
$saturate = $factSaturation.GetMethod('Saturate')
if ($groundRule.GetConstructors().Count -ne 1 -or
    $null -eq $groundRule.GetProperty('Conclusion') -or
    $null -eq $groundRule.GetProperty('RuleId') -or
    $null -eq $groundRule.GetProperty('Premises') -or
    $null -eq $groundRule.GetProperty('Parameters') -or
    $null -eq $groundRule.GetProperty('OccurrenceOrdinals') -or
    $null -eq $factTable.GetMethod('Create') -or
    $null -eq $supportGraph.GetMethod('Create') -or
    $null -eq $problemCreate -or -not $problemCreate.IsStatic -or
    $problemCreate.ReturnType -ne $saturationProblem -or
    $null -eq $saturationProblem.GetProperty('Initial') -or
    $null -eq $saturationProblem.GetProperty('Rules') -or
    $null -eq $saturate -or -not $saturate.IsStatic -or
    $saturate.ReturnType -ne $saturationResult -or
    $saturationResult.GetConstructors().Count -ne 0 -or
    $null -eq $saturationResult.GetProperty('Problem') -or
    $null -eq $saturationResult.GetProperty('Graph') -or
    $null -eq $saturationResult.GetProperty('Facts')) {
    throw 'Packaged K5 fact and saturation surface is incomplete.'
}

function Require-PublicMethod {
    param(
        [Type] $Type,
        [string] $Name,
        [bool] $Static,
        [Type] $ReturnType,
        [Type[]] $ParameterTypes
    )

    if ($null -eq $ParameterTypes) {
        $ParameterTypes = [Type[]]@()
    }
    $flags = [Reflection.BindingFlags]::Public -bor
        $(if ($Static) { [Reflection.BindingFlags]::Static } else { [Reflection.BindingFlags]::Instance })
    $method = $Type.GetMethod($Name, $flags, $null, $ParameterTypes, $null)
    if ($null -eq $method -or $method.ReturnType -ne $ReturnType) {
        throw "Packaged $($Type.Name).$Name has the wrong public signature."
    }
}

function Require-PublicProperty {
    param([Type] $Type, [string] $Name, [Type] $PropertyType)

    $property = $Type.GetProperty(
        $Name,
        [Reflection.BindingFlags]::Public -bor [Reflection.BindingFlags]::Instance)
    if ($null -eq $property -or $property.PropertyType -ne $PropertyType -or -not $property.CanRead) {
        throw "Packaged $($Type.Name).$Name has the wrong public property shape."
    }
}

$booleanVector = $assembly.GetType('CodexSci.Doccer.BooleanVector', $true)
$booleanScan = $assembly.GetType('CodexSci.Doccer.BooleanPrefixParityResult', $true)
$unitMask = $assembly.GetType('CodexSci.Doccer.Utf16UnitMask', $true)
$continuation = $assembly.GetType('CodexSci.Doccer.Utf16PrefixParityContinuation', $true)
$unitScan = $assembly.GetType('CodexSci.Doccer.Utf16PrefixParityResult', $true)
$classifierStamp = $assembly.GetType('CodexSci.Doccer.UnitClassifierStamp', $true)
$truthState = $assembly.GetType('CodexSci.Doccer.UnitTruthState', $true)
$classification = $assembly.GetType('CodexSci.Doccer.Utf16UnitClassification', $true)
$classifiedScan = $assembly.GetType('CodexSci.Doccer.Utf16ClassificationPrefixParityResult', $true)
$claimStamp = $assembly.GetType('CodexSci.Doccer.UnitMaskClaimStamp', $true)
$harvest = $assembly.GetType('CodexSci.Doccer.Utf16UnitHarvestResult', $true)
$emission = $assembly.GetType('CodexSci.Doccer.Utf16ClaimEmissionResult', $true)
$textMaster = $assembly.GetType('CodexSci.Doccer.TextMaster', $true)
$textSpan = $assembly.GetType('CodexSci.Doccer.TextSpan', $true)
$spanLevel = $assembly.GetType('CodexSci.Doccer.SpanLevel', $true)
$spanBatchBuilder = $assembly.GetType('CodexSci.Doccer.SpanBatchBuilder', $true)
$spanSet = $assembly.GetType('CodexSci.Doccer.SpanSet', $true)
$genericEnumerableInt = [Collections.Generic.IEnumerable[int]]
$genericReadOnlyCollectionInt = [Collections.Generic.IReadOnlyCollection[int]]
$genericReadOnlyListInt = [Collections.Generic.IReadOnlyList[int]]
$equatableDefinition = [IEquatable[int]].GetGenericTypeDefinition()
$equatableBooleanVector = $equatableDefinition.MakeGenericType($booleanVector)
$equatableUnitMask = $equatableDefinition.MakeGenericType($unitMask)

if ($booleanVector.GetConstructors().Count -ne 0 -or
    $null -eq $unitMask.GetConstructor([Type[]]@($textMaster, $textSpan, $booleanVector)) -or
    $continuation.GetConstructors().Count -ne 0 -or
    $booleanScan.GetConstructors().Count -ne 0 -or
    $unitScan.GetConstructors().Count -ne 0 -or
    $null -eq $classifierStamp.GetConstructor([Type[]]@([string])) -or
    $null -eq $classification.GetConstructor([Type[]]@($classifierStamp, $unitMask, $unitMask)) -or
    $classifiedScan.GetConstructors().Count -ne 0 -or
    $null -eq $claimStamp.GetConstructor([Type[]]@([string], $spanLevel, [string], [int], [string])) -or
    $harvest.GetConstructors().Count -ne 0 -or
    $emission.GetConstructors().Count -ne 0 -or
    -not $genericReadOnlyCollectionInt.IsAssignableFrom($booleanVector) -or
    -not $genericReadOnlyCollectionInt.IsAssignableFrom($unitMask) -or
    -not $equatableBooleanVector.IsAssignableFrom($booleanVector) -or
    -not $equatableUnitMask.IsAssignableFrom($unitMask) -or
    -not $truthState.IsEnum -or
    (($truthState.GetEnumNames() -join ',') -ne 'KnownFalse,KnownTrue,Unknown')) {
    throw 'Packaged V1 carrier or result construction surface is incomplete.'
}

$null = Require-PublicMethod $booleanVector 'None' $true $booleanVector ([Type[]]@([int]))
$null = Require-PublicMethod $booleanVector 'All' $true $booleanVector ([Type[]]@([int]))
$null = Require-PublicMethod $booleanVector 'Create' $true $booleanVector ([Type[]]@([int], $genericEnumerableInt))
foreach ($name in @('Or', 'And', 'Xor', 'AndNot')) {
    $null = Require-PublicMethod $booleanVector $name $false $booleanVector ([Type[]]@($booleanVector))
}
foreach ($name in @('Not', 'AdjacentTransitions')) {
    $parameters = if ($name -eq 'AdjacentTransitions') { [Type[]]@([bool]) } else { [Type[]]@() }
    $null = Require-PublicMethod $booleanVector $name $false $booleanVector $parameters
}
$null = Require-PublicMethod $booleanVector 'ShiftTowardHigherOrdinals' $false $booleanVector ([Type[]]@([int]))
$null = Require-PublicMethod $booleanVector 'ShiftTowardLowerOrdinals' $false $booleanVector ([Type[]]@([int]))
$null = Require-PublicMethod $booleanVector 'Parity' $false ([bool]) ([Type[]]@())
$null = Require-PublicMethod $booleanVector 'PrefixParity' $false $booleanScan ([Type[]]@([bool]))
$null = Require-PublicMethod $booleanVector 'Contains' $false ([bool]) ([Type[]]@([int]))
$null = Require-PublicProperty $booleanVector 'Length' ([int])
$null = Require-PublicProperty $booleanVector 'Population' ([int])
$null = Require-PublicProperty $booleanVector 'Count' ([int])
$null = Require-PublicProperty $booleanVector 'IsEmpty' ([bool])
$null = Require-PublicProperty $booleanVector 'Item' ([bool])
$null = Require-PublicProperty $booleanScan 'Vector' $booleanVector
$null = Require-PublicProperty $booleanScan 'CarryOut' ([bool])

$null = Require-PublicMethod $unitMask 'Union' $false $unitMask ([Type[]]@($unitMask))
$null = Require-PublicMethod $unitMask 'Intersect' $false $unitMask ([Type[]]@($unitMask))
$null = Require-PublicMethod $unitMask 'SymmetricDifference' $false $unitMask ([Type[]]@($unitMask))
$null = Require-PublicMethod $unitMask 'Subtract' $false $unitMask ([Type[]]@($unitMask))
$null = Require-PublicMethod $unitMask 'Complement' $false $unitMask ([Type[]]@())
$null = Require-PublicMethod $unitMask 'ShiftTowardHigherOrdinals' $false $unitMask ([Type[]]@([int]))
$null = Require-PublicMethod $unitMask 'ShiftTowardLowerOrdinals' $false $unitMask ([Type[]]@([int]))
$null = Require-PublicMethod $unitMask 'ContainsLocalOrdinal' $false ([bool]) ([Type[]]@([int]))
$null = Require-PublicMethod $unitMask 'ContainsOffset' $false ([bool]) ([Type[]]@([int]))
$null = Require-PublicMethod $unitMask 'PrefixParity' $false $unitScan ([Type[]]@([bool]))
$null = Require-PublicMethod $unitMask 'HarvestScalarSpans' $false $harvest ([Type[]]@())
$null = Require-PublicProperty $unitMask 'Master' $textMaster
$null = Require-PublicProperty $unitMask 'Window' $textSpan
$null = Require-PublicProperty $unitMask 'Vector' $booleanVector
$null = Require-PublicProperty $unitMask 'Length' ([int])
$null = Require-PublicProperty $unitMask 'Population' ([int])
$null = Require-PublicProperty $unitMask 'Count' ([int])
$null = Require-PublicProperty $unitMask 'IsEmpty' ([bool])
$null = Require-PublicProperty $unitMask 'Item' ([bool])
$null = Require-PublicMethod $continuation 'Seed' $true $continuation ([Type[]]@($textMaster, [int], [bool]))
$null = Require-PublicMethod $continuation 'Continue' $false $unitScan ([Type[]]@($unitMask))
$null = Require-PublicProperty $continuation 'Master' $textMaster
$null = Require-PublicProperty $continuation 'NextOffset' ([int])
$null = Require-PublicProperty $continuation 'Carry' ([bool])
$null = Require-PublicProperty $unitScan 'Input' $unitMask
$null = Require-PublicProperty $unitScan 'States' $unitMask
$null = Require-PublicProperty $unitScan 'Continuation' $continuation
$null = Require-PublicProperty $unitScan 'CarryOut' ([bool])

$null = Require-PublicProperty $classifierStamp 'Name' ([string])
$null = Require-PublicProperty $classification 'Classifier' $classifierStamp
$null = Require-PublicProperty $classification 'Matches' $unitMask
$null = Require-PublicProperty $classification 'Unknown' $unitMask
$null = Require-PublicProperty $classification 'Master' $textMaster
$null = Require-PublicProperty $classification 'Window' $textSpan
$null = Require-PublicProperty $classification 'IsComplete' ([bool])
$null = Require-PublicMethod $classification 'PrefixParity' $false $classifiedScan ([Type[]]@($truthState))
$null = Require-PublicMethod $classification 'HarvestScalarSpans' $false $harvest ([Type[]]@())
$null = Require-PublicProperty $classifiedScan 'Source' $classification
$null = Require-PublicProperty $classifiedScan 'Classifier' $classifierStamp
$null = Require-PublicProperty $classifiedScan 'KnownTrueStates' $unitMask
$null = Require-PublicProperty $classifiedScan 'UnknownStates' $unitMask
$null = Require-PublicProperty $classifiedScan 'CarryOut' $truthState

$null = Require-PublicProperty $claimStamp 'Kind' ([string])
$null = Require-PublicProperty $claimStamp 'Level' $spanLevel
$null = Require-PublicProperty $claimStamp 'Source' ([string])
$null = Require-PublicProperty $claimStamp 'Priority' ([int])
$null = Require-PublicProperty $claimStamp 'RuleId' ([string])
$null = Require-PublicProperty $harvest 'SourceMask' $unitMask
$null = Require-PublicProperty $harvest 'SourceClassification' $classification
$null = Require-PublicProperty $harvest 'AdmittedSpans' $spanSet
$null = Require-PublicProperty $harvest 'BoundaryResidual' $unitMask
$null = Require-PublicProperty $harvest 'ClassifierUnknown' $unitMask
$null = Require-PublicMethod $harvest 'EmitClaims' $false $emission ([Type[]]@($spanBatchBuilder, $claimStamp))
$null = Require-PublicProperty $emission 'Harvest' $harvest
$null = Require-PublicProperty $emission 'Builder' $spanBatchBuilder
$null = Require-PublicProperty $emission 'Evidence' $claimStamp
$null = Require-PublicProperty $emission 'Ordinals' $genericReadOnlyListInt

$relation = & (Join-Path $PackageDir 'doccer.exe') relate 0 5 5 9
if ($LASTEXITCODE -ne 0 -or $relation -ne 'Meets') {
    throw "Packaged CLI failed its smoke run (exit $LASTEXITCODE, output '$relation')."
}
'@
$smokePath = Join-Path ([IO.Path]::GetTempPath()) "doccer-smoke-$([guid]::NewGuid().ToString('N')).ps1"
Set-Content -LiteralPath $smokePath -Value $smokeScript -Encoding utf8
try {
    & pwsh -NoProfile -File $smokePath -PackageDir $packageDir
    if ($LASTEXITCODE -ne 0) { throw "Doccer package smoke test failed ($LASTEXITCODE)." }
}
finally {
    Remove-Item -LiteralPath $smokePath -Force -ErrorAction SilentlyContinue
}

# The manifest answers "what source revision does this payload represent?" — the question a
# selectively refreshed package otherwise cannot answer.
$sourceCommit = (& git -C $repo rev-parse HEAD).Trim()
$sourceDirty = [bool](& git -C $repo status --porcelain -- src/doccer brewery/doccer tests/doccer)
$targetFramework = [regex]::Match(
    (Get-Content -LiteralPath (Join-Path $repo 'Directory.Build.props') -Raw),
    '<TargetFramework>([^<]+)</TargetFramework>').Groups[1].Value
$manifest = [ordered]@{
    name             = 'doccer'
    schemaVersion    = 1
    sourceCommit     = $sourceCommit
    sourceDirty      = $sourceDirty
    buildTimestampUtc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    configuration    = $Configuration
    runtime          = $Runtime
    targetFramework  = $targetFramework
    selfContained    = [bool]$SelfContained
    harnessChecks    = $harnessChecks
    assemblySha256   = (Get-FileHash -LiteralPath (Join-Path $packageDir 'CodexSci.Doccer.dll') -Algorithm SHA256).Hash
}
$manifestPath = Join-Path $packageDir 'doccer.manifest.json'
[IO.File]::WriteAllText($manifestPath, ($manifest | ConvertTo-Json), [Text.UTF8Encoding]::new($false))

Write-Host "Doccer payload refreshed at $packageDir" -ForegroundColor Green
Write-Host "  commit $sourceCommit$(if ($sourceDirty) { ' (dirty)' }); harness checks: $($harnessChecks ?? 'skipped')" -ForegroundColor Green
