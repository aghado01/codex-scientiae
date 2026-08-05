using System;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>The thirteen mutually exclusive relations of Allen's interval algebra.</summary>
public enum AllenRelation
{
    Before = 0,
    Meets = 1,
    Overlaps = 2,
    FinishedBy = 3,
    Contains = 4,
    Starts = 5,
    Equal = 6,
    StartedBy = 7,
    During = 8,
    Finishes = 9,
    OverlappedBy = 10,
    MetBy = 11,
    After = 12,
}

public static class AllenAlgebra
{
    public static AllenRelation Relate(TextSpan left, TextSpan right)
    {
        if (left.IsEmpty || right.IsEmpty)
        {
            throw new ArgumentException("Allen relations require non-empty intervals.");
        }

        if (left.End < right.Start)
        {
            return AllenRelation.Before;
        }

        if (left.End == right.Start)
        {
            return AllenRelation.Meets;
        }

        if (left.Start > right.End)
        {
            return AllenRelation.After;
        }

        if (left.Start == right.End)
        {
            return AllenRelation.MetBy;
        }

        if (left.Start == right.Start)
        {
            if (left.End == right.End)
            {
                return AllenRelation.Equal;
            }

            return left.End < right.End ? AllenRelation.Starts : AllenRelation.StartedBy;
        }

        if (left.End == right.End)
        {
            return left.Start < right.Start ? AllenRelation.FinishedBy : AllenRelation.Finishes;
        }

        if (left.Start < right.Start)
        {
            return left.End < right.End ? AllenRelation.Overlaps : AllenRelation.Contains;
        }

        return left.End < right.End ? AllenRelation.During : AllenRelation.OverlappedBy;
    }

    public static AllenRelation Inverse(AllenRelation relation) => relation switch
    {
        AllenRelation.Before => AllenRelation.After,
        AllenRelation.Meets => AllenRelation.MetBy,
        AllenRelation.Overlaps => AllenRelation.OverlappedBy,
        AllenRelation.FinishedBy => AllenRelation.Finishes,
        AllenRelation.Contains => AllenRelation.During,
        AllenRelation.Starts => AllenRelation.StartedBy,
        AllenRelation.Equal => AllenRelation.Equal,
        AllenRelation.StartedBy => AllenRelation.Starts,
        AllenRelation.During => AllenRelation.Contains,
        AllenRelation.Finishes => AllenRelation.FinishedBy,
        AllenRelation.OverlappedBy => AllenRelation.Overlaps,
        AllenRelation.MetBy => AllenRelation.Meets,
        AllenRelation.After => AllenRelation.Before,
        _ => throw new ArgumentOutOfRangeException(nameof(relation)),
    };
}

/// <summary>One result row from a relation join.</summary>
public readonly record struct SpanJoin(SpanRecord Left, SpanRecord Right, AllenRelation Relation);

public static class IntervalJoins
{
    /// <summary>
    /// Reference relation join. The deliberately simple O(L*R) implementation fixes semantics first;
    /// indexed join strategies can replace it without changing the result contract.
    /// This method carries no performance contract: time and allocation characteristics may change
    /// freely between versions, and consumers must not rely on them.
    /// </summary>
    public static IReadOnlyList<SpanJoin> Join(
        SpanBatch left,
        SpanBatch right,
        IReadOnlySet<AllenRelation>? relations = null)
    {
        ArgumentNullException.ThrowIfNull(left);
        ArgumentNullException.ThrowIfNull(right);
        left.Master.EnsureCompatibleWith(right.Master);

        var results = new List<SpanJoin>();
        foreach (var leftRecord in left)
        {
            foreach (var rightRecord in right)
            {
                var relation = AllenAlgebra.Relate(leftRecord.Span, rightRecord.Span);
                if (relations is null || relations.Contains(relation))
                {
                    results.Add(new SpanJoin(leftRecord, rightRecord, relation));
                }
            }
        }

        return results.AsReadOnly();
    }
}
