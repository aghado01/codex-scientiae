using System;

namespace CodexSci.Doccer;

/// <summary>
/// A named stamp for validating one exact total occurrence cover. The policy names the caller's
/// structural use; total declared-window coverage and overlap admission remain the fixed semantics
/// of <see cref="CoverView"/>.
/// </summary>
public sealed class CoverPolicy
{
    public CoverPolicy(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A cover-policy name is required.", nameof(name));
        }

        Name = name;
    }

    public string Name { get; }
}

/// <summary>
/// An exact selection whose occurrence spans collectively cover one declared window. Overlap,
/// nesting, parallel equal geometry, and meeting are allowed. Construction validates without
/// ordering, deleting, or choosing claims.
/// </summary>
public sealed class CoverView
{
    private CoverView(
        ClaimSelection selection,
        TextSpan window,
        CoverPolicy policy,
        SpanSet coverage)
    {
        Selection = selection;
        Window = window;
        Policy = policy;
        Coverage = coverage;
    }

    /// <summary>The exact occurrence population validated as a total cover.</summary>
    public ClaimSelection Selection { get; }

    public SpanBatch Basis => Selection.Basis;

    public TextMaster Master => Basis.Master;

    /// <summary>The exact declared window covered by the selected occurrences.</summary>
    public TextSpan Window { get; }

    /// <summary>The exact named policy object supplied for this validation.</summary>
    public CoverPolicy Policy { get; }

    /// <summary>Normalized selected material; overlap and identity remain in <see cref="Selection"/>.</summary>
    public SpanSet Coverage { get; }

    /// <summary>
    /// Validates one exact total cover. Every selected span must lie inside
    /// <paramref name="window"/>, and their normalized material must leave no position of that
    /// window uncovered. Overlap and repeated geometry are retained in the exact selection.
    /// </summary>
    public static CoverView Create(
        ClaimSelection selection,
        TextSpan window,
        CoverPolicy policy)
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
                    $"Selected claim #{ordinal} span {span} lies outside cover window {window}.",
                    nameof(selection));
            }
        }

        var coverage = selection.Coverage();
        var windowMaterial = SpanSet.Create(selection.Master, new[] { window });
        var gaps = windowMaterial.Subtract(coverage);
        if (gaps.Count != 0)
        {
            throw new ArgumentException(
                $"Selected claims leave {gaps.Count} material gap(s) inside cover window {window}.",
                nameof(selection));
        }

        return new CoverView(selection, window, policy, coverage);
    }
}
