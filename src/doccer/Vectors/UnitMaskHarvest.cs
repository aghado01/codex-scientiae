using System;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>
/// Immutable evidence copied into every claim emitted from one completed unit-mask harvest.
/// </summary>
public sealed class UnitMaskClaimStamp
{
    public UnitMaskClaimStamp(
        string kind,
        SpanLevel level,
        string source,
        int priority = 0,
        string? ruleId = null)
    {
        if (string.IsNullOrWhiteSpace(kind))
        {
            throw new ArgumentException("A claim kind is required.", nameof(kind));
        }

        if (!Enum.IsDefined(level))
        {
            throw new ArgumentOutOfRangeException(nameof(level), level, "Undefined span level.");
        }

        if (string.IsNullOrWhiteSpace(source))
        {
            throw new ArgumentException("A claim source is required.", nameof(source));
        }

        Kind = kind;
        Level = level;
        Source = source;
        Priority = priority;
        RuleId = ruleId;
    }

    public string Kind { get; }

    public SpanLevel Level { get; }

    public string Source { get; }

    public int Priority { get; }

    public string? RuleId { get; }
}

/// <summary>
/// Scalar-safe harvest of one direct mask or one exact classification. Complete selected topology
/// atoms become normalized spans; partial selected atoms and classifier unknowns remain separate.
/// </summary>
public sealed class Utf16UnitHarvestResult
{
    internal Utf16UnitHarvestResult(
        Utf16UnitMask sourceMask,
        Utf16UnitClassification? sourceClassification,
        SpanSet admittedSpans,
        Utf16UnitMask boundaryResidual,
        Utf16UnitMask classifierUnknown)
    {
        SourceMask = sourceMask;
        SourceClassification = sourceClassification;
        AdmittedSpans = admittedSpans;
        BoundaryResidual = boundaryResidual;
        ClassifierUnknown = classifierUnknown;
    }

    public Utf16UnitMask SourceMask { get; }

    public Utf16UnitClassification? SourceClassification { get; }

    public SpanSet AdmittedSpans { get; }

    public Utf16UnitMask BoundaryResidual { get; }

    public Utf16UnitMask ClassifierUnknown { get; }

    /// <summary>
    /// Emits one claim per admitted nonempty normalized span. Every request precondition and every
    /// claim is validated before the first builder mutation; residuals remain in this result.
    /// </summary>
    public Utf16ClaimEmissionResult EmitClaims(
        SpanBatchBuilder builder,
        UnitMaskClaimStamp evidence)
    {
        ArgumentNullException.ThrowIfNull(builder);
        ArgumentNullException.ThrowIfNull(evidence);
        if (builder.IsFrozen)
        {
            throw new InvalidOperationException("Claims cannot be emitted to a frozen span batch builder.");
        }

        builder.Master.EnsureCompatibleWith(AdmittedSpans.Master);
        var claims = new SpanClaim[AdmittedSpans.Count];
        for (var i = 0; i < claims.Length; i++)
        {
            var span = AdmittedSpans[i];
            builder.Master.ValidateSpan(span, allowEmpty: false);
            claims[i] = new SpanClaim(
                span,
                evidence.Kind,
                evidence.Level,
                evidence.Source,
                evidence.Priority,
                evidence.RuleId);
        }

        var ordinals = new int[claims.Length];
        for (var i = 0; i < claims.Length; i++)
        {
            ordinals[i] = builder.Add(claims[i]);
        }

        return new Utf16ClaimEmissionResult(this, builder, evidence, ordinals);
    }
}

/// <summary>Exact harvest, destination builder, evidence, and ordinals from one claim emission.</summary>
public sealed class Utf16ClaimEmissionResult
{
    private readonly IReadOnlyList<int> _ordinals;

    internal Utf16ClaimEmissionResult(
        Utf16UnitHarvestResult harvest,
        SpanBatchBuilder builder,
        UnitMaskClaimStamp evidence,
        int[] ordinals)
    {
        Harvest = harvest;
        Builder = builder;
        Evidence = evidence;
        _ordinals = Array.AsReadOnly(ordinals);
    }

    public Utf16UnitHarvestResult Harvest { get; }

    public SpanBatchBuilder Builder { get; }

    public UnitMaskClaimStamp Evidence { get; }

    public IReadOnlyList<int> Ordinals => _ordinals;
}

internal static class UnitMaskHarvest
{
    public static Utf16UnitHarvestResult Harvest(Utf16UnitMask source)
    {
        ArgumentNullException.ThrowIfNull(source);
        var unknown = new Utf16UnitMask(
            source.Master,
            source.Window,
            BooleanVector.None(source.Length));
        return HarvestCore(source, null, unknown);
    }

    public static Utf16UnitHarvestResult Harvest(Utf16UnitClassification source)
    {
        ArgumentNullException.ThrowIfNull(source);
        return HarvestCore(source.Matches, source, source.Unknown);
    }

    private static Utf16UnitHarvestResult HarvestCore(
        Utf16UnitMask source,
        Utf16UnitClassification? classification,
        Utf16UnitMask classifierUnknown)
    {
        var admitted = new List<TextSpan>();
        var boundaryOrdinals = new List<int>();
        if (!source.IsEmpty)
        {
            foreach (var atom in source.Master.Topology.Atoms)
            {
                if (atom.Span.End <= source.Window.Start)
                {
                    continue;
                }

                if (atom.Span.Start >= source.Window.End)
                {
                    break;
                }

                var intersectionStart = Math.Max(atom.Span.Start, source.Window.Start);
                var intersectionEnd = Math.Min(atom.Span.End, source.Window.End);
                var selected = false;
                for (var offset = intersectionStart; offset < intersectionEnd; offset++)
                {
                    if (source.Vector[offset - source.Window.Start])
                    {
                        selected = true;
                        break;
                    }
                }

                if (!selected)
                {
                    continue;
                }

                var completeAndSelected = source.Window.Contains(atom.Span);
                if (completeAndSelected)
                {
                    for (var offset = atom.Span.Start; offset < atom.Span.End; offset++)
                    {
                        if (!source.Vector[offset - source.Window.Start])
                        {
                            completeAndSelected = false;
                            break;
                        }
                    }
                }

                if (completeAndSelected)
                {
                    admitted.Add(atom.Span);
                    continue;
                }

                for (var offset = intersectionStart; offset < intersectionEnd; offset++)
                {
                    if (source.Vector[offset - source.Window.Start])
                    {
                        boundaryOrdinals.Add(offset - source.Window.Start);
                    }
                }
            }
        }

        var spans = SpanSet.Create(source.Master, admitted);
        var boundary = new Utf16UnitMask(
            source.Master,
            source.Window,
            BooleanVector.Create(source.Length, boundaryOrdinals));
        return new Utf16UnitHarvestResult(
            source,
            classification,
            spans,
            boundary,
            classifierUnknown);
    }
}
