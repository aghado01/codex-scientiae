using System;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>An exact reference-identity stamp naming one unit-classification procedure.</summary>
public sealed class UnitClassifierStamp
{
    public UnitClassifierStamp(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A classifier name is required.", nameof(name));
        }

        Name = name;
    }

    public string Name { get; }

    public override string ToString() => Name;
}

/// <summary>Three-state evidence used at a classified prefix scan boundary.</summary>
public enum UnitTruthState
{
    KnownFalse = 0,
    KnownTrue = 1,
    Unknown = 2,
}

/// <summary>
/// One exact classifier's known-match and unknown unit populations. Units in neither mask are
/// known false; match and unknown populations are disjoint.
/// </summary>
public sealed class Utf16UnitClassification
{
    public Utf16UnitClassification(
        UnitClassifierStamp classifier,
        Utf16UnitMask matches,
        Utf16UnitMask unknown)
    {
        ArgumentNullException.ThrowIfNull(classifier);
        ArgumentNullException.ThrowIfNull(matches);
        ArgumentNullException.ThrowIfNull(unknown);
        matches.EnsureSameBasis(unknown);
        if (!matches.Vector.And(unknown.Vector).IsEmpty)
        {
            throw new ArgumentException("Known-match and unknown unit populations must be disjoint.");
        }

        Classifier = classifier;
        Matches = matches;
        Unknown = unknown;
    }

    public UnitClassifierStamp Classifier { get; }

    public Utf16UnitMask Matches { get; }

    public Utf16UnitMask Unknown { get; }

    public TextMaster Master => Matches.Master;

    public TextSpan Window => Matches.Window;

    public bool IsComplete => Unknown.IsEmpty;

    /// <summary>
    /// Scans classified transition evidence. Once the entering state or any event is unknown, all
    /// subsequent states and carry-out remain unknown.
    /// </summary>
    public Utf16ClassificationPrefixParityResult PrefixParity(
        UnitTruthState carryIn = UnitTruthState.KnownFalse)
    {
        ValidateTruthState(carryIn);
        var knownTrue = new List<int>();
        var propagatedUnknown = new List<int>();
        var state = carryIn == UnitTruthState.KnownTrue;
        var uncertain = carryIn == UnitTruthState.Unknown;

        for (var ordinal = 0; ordinal < Matches.Length; ordinal++)
        {
            if (!uncertain)
            {
                if (Unknown[ordinal])
                {
                    uncertain = true;
                }
                else if (Matches[ordinal])
                {
                    state = !state;
                }
            }

            if (uncertain)
            {
                propagatedUnknown.Add(ordinal);
            }
            else if (state)
            {
                knownTrue.Add(ordinal);
            }
        }

        var knownTrueMask = new Utf16UnitMask(
            Master,
            Window,
            BooleanVector.Create(Window.Length, knownTrue));
        var unknownMask = new Utf16UnitMask(
            Master,
            Window,
            BooleanVector.Create(Window.Length, propagatedUnknown));
        var carryOut = uncertain
            ? UnitTruthState.Unknown
            : state ? UnitTruthState.KnownTrue : UnitTruthState.KnownFalse;
        return new Utf16ClassificationPrefixParityResult(
            this,
            knownTrueMask,
            unknownMask,
            carryOut);
    }

    /// <summary>Harvests complete known-match atoms and preserves classifier unknowns separately.</summary>
    public Utf16UnitHarvestResult HarvestScalarSpans() => UnitMaskHarvest.Harvest(this);

    private static void ValidateTruthState(UnitTruthState state)
    {
        if (!Enum.IsDefined(state))
        {
            throw new ArgumentOutOfRangeException(nameof(state), state, "Undefined unit truth state.");
        }
    }
}

/// <summary>
/// Classified inclusive prefix state: known-true positions, uncertainty suffix, and typed final
/// evidence, all stamped by the exact source classification.
/// </summary>
public sealed class Utf16ClassificationPrefixParityResult
{
    internal Utf16ClassificationPrefixParityResult(
        Utf16UnitClassification source,
        Utf16UnitMask knownTrueStates,
        Utf16UnitMask unknownStates,
        UnitTruthState carryOut)
    {
        Source = source;
        KnownTrueStates = knownTrueStates;
        UnknownStates = unknownStates;
        CarryOut = carryOut;
    }

    public Utf16UnitClassification Source { get; }

    public UnitClassifierStamp Classifier => Source.Classifier;

    public Utf16UnitMask KnownTrueStates { get; }

    public Utf16UnitMask UnknownStates { get; }

    public UnitTruthState CarryOut { get; }
}
