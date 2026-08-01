using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;

namespace CodexSci.Doccer;

/// <summary>A unique accepted geometry with every same-extent claim preserved.</summary>
public sealed class LaminarNode
{
    private readonly List<LaminarNode> _children = new();
    private readonly ReadOnlyCollection<LaminarNode> _childrenView;

    internal LaminarNode(TextSpan span, IReadOnlyList<SpanRecord> claims)
    {
        Span = span;
        Claims = Array.AsReadOnly(claims.ToArray());
        _childrenView = _children.AsReadOnly();
    }

    public TextSpan Span { get; }

    public IReadOnlyList<SpanRecord> Claims { get; }

    public IReadOnlyList<LaminarNode> Children => _childrenView;

    internal void AddChild(LaminarNode child) => _children.Add(child);
}

/// <summary>Priority-resolved laminar forest plus the crossing claims it could not admit.</summary>
public sealed class LaminarView
{
    internal LaminarView(
        IReadOnlyList<SpanRecord> accepted,
        IReadOnlyList<SpanRecord> crossingResidue,
        IReadOnlyList<LaminarNode> roots)
    {
        Accepted = Array.AsReadOnly(accepted.ToArray());
        CrossingResidue = Array.AsReadOnly(crossingResidue.ToArray());
        Roots = Array.AsReadOnly(roots.ToArray());
    }

    public IReadOnlyList<SpanRecord> Accepted { get; }

    public IReadOnlyList<SpanRecord> CrossingResidue { get; }

    public IReadOnlyList<LaminarNode> Roots { get; }
}

public static class Laminarizer
{
    /// <summary>
    /// Greedily selects non-crossing geometries by highest priority, then earliest start, longest
    /// extent, and first claim ordinal. Equal geometries remain grouped rather than competing.
    /// </summary>
    public static LaminarView Extract(SpanBatch batch, Func<SpanRecord, bool>? predicate = null)
    {
        ArgumentNullException.ThrowIfNull(batch);

        var groups = batch
            .Where(record => predicate is null || predicate(record))
            .GroupBy(record => record.Span)
            .Select(group => new GeometryGroup(group.Key, group.OrderBy(record => record.Ordinal).ToArray()))
            .OrderByDescending(group => group.Priority)
            .ThenBy(group => group.Span.Start)
            .ThenByDescending(group => group.Span.End)
            .ThenBy(group => group.FirstOrdinal)
            .ToArray();

        var acceptedGroups = new List<GeometryGroup>();
        var rejectedGroups = new List<GeometryGroup>();
        foreach (var candidate in groups)
        {
            if (acceptedGroups.Any(existing => candidate.Span.Crosses(existing.Span)))
            {
                rejectedGroups.Add(candidate);
            }
            else
            {
                acceptedGroups.Add(candidate);
            }
        }

        var treeOrder = acceptedGroups
            .OrderBy(group => group.Span.Start)
            .ThenByDescending(group => group.Span.End)
            .ThenBy(group => group.FirstOrdinal)
            .ToArray();

        var roots = new List<LaminarNode>();
        var stack = new Stack<LaminarNode>();
        foreach (var group in treeOrder)
        {
            var node = new LaminarNode(group.Span, group.Claims);
            while (stack.Count > 0 && !stack.Peek().Span.ProperlyContains(node.Span))
            {
                stack.Pop();
            }

            if (stack.Count == 0)
            {
                roots.Add(node);
            }
            else
            {
                stack.Peek().AddChild(node);
            }

            stack.Push(node);
        }

        var accepted = acceptedGroups
            .SelectMany(group => group.Claims)
            .OrderBy(record => record.Ordinal)
            .ToArray();
        var residue = rejectedGroups
            .SelectMany(group => group.Claims)
            .OrderBy(record => record.Ordinal)
            .ToArray();

        return new LaminarView(accepted, residue, roots);
    }

    private sealed class GeometryGroup
    {
        public GeometryGroup(TextSpan span, SpanRecord[] claims)
        {
            Span = span;
            Claims = claims;
            Priority = claims.Max(record => record.Priority);
            FirstOrdinal = claims.Min(record => record.Ordinal);
        }

        public TextSpan Span { get; }
        public SpanRecord[] Claims { get; }
        public int Priority { get; }
        public int FirstOrdinal { get; }
    }
}
