using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>The closed material posture of one positive output piece.</summary>
public enum OutputPieceKind
{
    Copy = 0,
    OriginMapped = 1,
    Synthetic = 2,
}

/// <summary>The identity fields for the new output master and its singleton origin slot.</summary>
public sealed class MaterializationTarget
{
    public MaterializationTarget(string documentId, long revision, string outputTag)
    {
        if (string.IsNullOrWhiteSpace(documentId))
        {
            throw new ArgumentException("A target document identity is required.", nameof(documentId));
        }

        if (revision < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(revision));
        }

        if (string.IsNullOrWhiteSpace(outputTag))
        {
            throw new ArgumentException("A target output-slot tag is required.", nameof(outputTag));
        }

        DocumentId = documentId;
        Revision = revision;
        OutputTag = outputTag;
    }

    public string DocumentId { get; }

    public long Revision { get; }

    public string OutputTag { get; }
}

/// <summary>One piece-local output-atom to plan-source origin assertion.</summary>
public readonly record struct PieceOrigin
{
    public PieceOrigin(int outputAtomOrdinal, OriginAtom source)
    {
        if (outputAtomOrdinal < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(outputAtomOrdinal));
        }

        OutputAtomOrdinal = outputAtomOrdinal;
        Source = source;
    }

    public int OutputAtomOrdinal { get; }

    public OriginAtom Source { get; }
}

/// <summary>
/// One immutable positive output instruction. Factory construction keeps copy, origin-mapped, and
/// synthetic state disjoint.
/// </summary>
public sealed class OutputPiece
{
    private static readonly ReadOnlyCollection<PieceOrigin> EmptyOrigins =
        Array.AsReadOnly(Array.Empty<PieceOrigin>());

    private OutputPiece(
        OutputPieceKind kind,
        int? sourceSlotOrdinal,
        TextSpan? sourceSpan,
        string? literal,
        PieceOrigin[] origins,
        string? syntheticExplanation,
        FactReference? derivation)
    {
        Kind = kind;
        SourceSlotOrdinal = sourceSlotOrdinal;
        SourceSpan = sourceSpan;
        Literal = literal;
        Origins = origins.Length == 0 ? EmptyOrigins : Array.AsReadOnly(origins);
        SyntheticExplanation = syntheticExplanation;
        Derivation = derivation;
    }

    public OutputPieceKind Kind { get; }

    public int? SourceSlotOrdinal { get; }

    public TextSpan? SourceSpan { get; }

    public string? Literal { get; }

    public IReadOnlyList<PieceOrigin> Origins { get; }

    public string? SyntheticExplanation { get; }

    public FactReference? Derivation { get; }

    public static OutputPiece Copy(
        int sourceSlotOrdinal,
        TextSpan sourceSpan,
        FactReference? derivation = null)
    {
        if (sourceSlotOrdinal < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(sourceSlotOrdinal));
        }

        if (sourceSpan.IsEmpty)
        {
            throw new ArgumentException("A copy span must be nonempty.", nameof(sourceSpan));
        }

        ValidateDerivation(derivation);
        return new OutputPiece(
            OutputPieceKind.Copy,
            sourceSlotOrdinal,
            sourceSpan,
            null,
            Array.Empty<PieceOrigin>(),
            null,
            derivation);
    }

    public static OutputPiece OriginMapped(
        string literal,
        IEnumerable<PieceOrigin> origins,
        FactReference? derivation = null)
    {
        ArgumentNullException.ThrowIfNull(literal);
        ArgumentNullException.ThrowIfNull(origins);
        if (literal.Length == 0)
        {
            throw new ArgumentException("An origin-mapped literal must be nonempty.", nameof(literal));
        }

        ValidateDerivation(derivation);

        var atomCount = TextTopology.Build(literal).AtomCount;
        var canonical = new List<PieceOrigin>();
        foreach (var origin in origins)
        {
            if ((uint)origin.OutputAtomOrdinal >= (uint)atomCount)
            {
                throw new ArgumentException(
                    "A piece origin names an unavailable local output atom.",
                    nameof(origins));
            }

            canonical.Add(origin);
        }

        canonical.Sort(CompareCanonicalOrigins);
        if (canonical.Count > 1)
        {
            var write = 1;
            for (var read = 1; read < canonical.Count; read++)
            {
                if (canonical[read] != canonical[write - 1])
                {
                    canonical[write++] = canonical[read];
                }
            }

            if (write < canonical.Count)
            {
                canonical.RemoveRange(write, canonical.Count - write);
            }
        }

        var present = new bool[atomCount];
        foreach (var origin in canonical)
        {
            present[origin.OutputAtomOrdinal] = true;
        }

        for (var atomOrdinal = 0; atomOrdinal < present.Length; atomOrdinal++)
        {
            if (!present[atomOrdinal])
            {
                throw new ArgumentException(
                    $"Local output atom {atomOrdinal} has no declared source origin.",
                    nameof(origins));
            }
        }

        return new OutputPiece(
            OutputPieceKind.OriginMapped,
            null,
            null,
            literal,
            canonical.ToArray(),
            null,
            derivation);
    }

    public static OutputPiece Synthetic(
        string literal,
        string syntheticExplanation,
        FactReference? derivation = null)
    {
        ArgumentNullException.ThrowIfNull(literal);
        if (literal.Length == 0)
        {
            throw new ArgumentException("A synthetic literal must be nonempty.", nameof(literal));
        }

        if (string.IsNullOrWhiteSpace(syntheticExplanation))
        {
            throw new ArgumentException(
                "A synthetic explanation is required.",
                nameof(syntheticExplanation));
        }

        ValidateDerivation(derivation);
        return new OutputPiece(
            OutputPieceKind.Synthetic,
            null,
            null,
            literal,
            Array.Empty<PieceOrigin>(),
            syntheticExplanation,
            derivation);
    }

    private static void ValidateDerivation(FactReference? derivation)
    {
        if (derivation.HasValue && derivation.Value == default)
        {
            throw new ArgumentException(
                "A supplied derivation must be an initialized fact reference.",
                nameof(derivation));
        }
    }

    private static int CompareCanonicalOrigins(PieceOrigin left, PieceOrigin right)
    {
        var comparison = left.OutputAtomOrdinal.CompareTo(right.OutputAtomOrdinal);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = left.Source.SlotOrdinal.CompareTo(right.Source.SlotOrdinal);
        return comparison != 0
            ? comparison
            : left.Source.AtomOrdinal.CompareTo(right.Source.AtomOrdinal);
    }
}
