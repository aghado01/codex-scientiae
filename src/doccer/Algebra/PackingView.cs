using System;

namespace CodexSci.Doccer;

/// <summary>
/// A named stamp for validating one exact disjoint occurrence packing. The policy names the
/// caller's structural use; disjointness, gap admission, and exact-window containment remain the
/// fixed semantics of <see cref="PackingView"/>.
/// </summary>
public sealed class PackingPolicy
{
    public PackingPolicy(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A packing-policy name is required.", nameof(name));
        }

        Name = name;
    }

    public string Name { get; }
}

/// <summary>
/// An exact selection whose occurrence spans are pairwise disjoint inside one declared window.
/// Meeting and material gaps are allowed. Construction validates without deleting or choosing
/// claims, and the exact selection and policy object remain available even when the view is empty.
/// </summary>
public sealed class PackingView
{
    private PackingView(
        ClaimSelection selection,
        TextSpan window,
        PackingPolicy policy,
        SpanSet coverage,
        SpanSet gaps)
    {
        Selection = selection;
        Window = window;
        Policy = policy;
        Coverage = coverage;
        Gaps = gaps;
    }

    /// <summary>The exact occurrence population validated as a packing.</summary>
    public ClaimSelection Selection { get; }

    public SpanBatch Basis => Selection.Basis;

    public TextMaster Master => Basis.Master;

    /// <summary>The exact declared window containing every selected occurrence.</summary>
    public TextSpan Window { get; }

    /// <summary>The exact named policy object supplied for this validation.</summary>
    public PackingPolicy Policy { get; }

    /// <summary>Normalized selected material; occurrence identity remains in <see cref="Selection"/>.</summary>
    public SpanSet Coverage { get; }

    /// <summary>Normalized material in <see cref="Window"/> not covered by the packing.</summary>
    public SpanSet Gaps { get; }

    /// <summary>
    /// Validates one exact packing. Every selected span must lie inside <paramref name="window"/>,
    /// and no two selected occurrences may share material. Meeting spans remain disjoint.
    /// </summary>
    public static PackingView Create(
        ClaimSelection selection,
        TextSpan window,
        PackingPolicy policy)
    {
        ArgumentNullException.ThrowIfNull(selection);
        ArgumentNullException.ThrowIfNull(policy);
        selection.Master.ValidateSpan(window);

        foreach (var ordinal in selection)
        {
            var span = selection.Basis[ordinal].Span;
            if (!window.Contains(span))
            {
                throw new ArgumentException(
                    $"Selected claim #{ordinal} span {span} lies outside packing window {window}.",
                    nameof(selection));
            }
        }

        foreach (var leftOrdinal in selection)
        {
            var left = selection.Basis[leftOrdinal].Span;
            foreach (var rightOrdinal in selection)
            {
                if (rightOrdinal <= leftOrdinal)
                {
                    continue;
                }

                var right = selection.Basis[rightOrdinal].Span;
                if (left.Intersects(right))
                {
                    throw new ArgumentException(
                        $"Selected claims #{leftOrdinal} {left} and #{rightOrdinal} {right} " +
                        "share material; a packing must be pairwise disjoint.",
                        nameof(selection));
                }
            }
        }

        var coverage = selection.Coverage();
        var windowMaterial = SpanSet.Create(selection.Master, new[] { window });
        return new PackingView(
            selection,
            window,
            policy,
            coverage,
            windowMaterial.Subtract(coverage));
    }
}
