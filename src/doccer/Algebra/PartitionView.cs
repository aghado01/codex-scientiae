using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Runtime.CompilerServices;

namespace CodexSci.Doccer;

/// <summary>
/// An immutable exact-graph-stamped path whose claim ordinals form an ordered, disjoint,
/// gap-free, total cover of the graph window.
/// </summary>
public sealed class PartitionView : IReadOnlyList<int>, IEquatable<PartitionView>
{
    private readonly int[] _ordinals;
    private readonly ReadOnlyCollection<int> _ordinalView;

    private PartitionView(CandidateRegionGraph graph, int[] ordinals)
    {
        Graph = graph;
        _ordinals = ordinals;
        _ordinalView = Array.AsReadOnly(_ordinals);
        Selection = ClaimSelection.Create(graph.Source, ordinals);
    }

    /// <summary>The exact candidate graph whose ordinal edges form this partition.</summary>
    public CandidateRegionGraph Graph { get; }

    public SpanBatch Source => Graph.Source;

    public TextMaster Master => Graph.Master;

    public TextSpan Window => Graph.Window;

    /// <summary>Unordered exact membership; enumerate this view to retain path order.</summary>
    public ClaimSelection Selection { get; }

    /// <summary>An immutable ordered ordinal projection for callers that need a named property.</summary>
    public IReadOnlyList<int> Ordinals => _ordinalView;

    public int Count => _ordinals.Length;

    public bool IsEmpty => _ordinals.Length == 0;

    public int this[int index] => _ordinals[index];

    public static PartitionView Create(
        CandidateRegionGraph graph,
        IEnumerable<int> ordinals)
    {
        ArgumentNullException.ThrowIfNull(graph);
        ArgumentNullException.ThrowIfNull(ordinals);

        var ordered = new List<int>();
        var seen = new HashSet<int>();
        foreach (var ordinal in ordinals)
        {
            if (!graph.Contains(ordinal))
            {
                throw new ArgumentException(
                    $"Ordinal #{ordinal} is not a candidate edge of the source graph.",
                    nameof(ordinals));
            }

            if (!seen.Add(ordinal))
            {
                throw new ArgumentException(
                    $"Ordinal #{ordinal} appears more than once in the partition path.",
                    nameof(ordinals));
            }

            ordered.Add(ordinal);
        }

        if (graph.Window.IsEmpty)
        {
            if (ordered.Count != 0)
            {
                throw new ArgumentException(
                    "An empty graph window admits only the zero-edge partition.",
                    nameof(ordinals));
            }

            return new PartitionView(graph, Array.Empty<int>());
        }

        if (ordered.Count == 0)
        {
            throw new ArgumentException(
                "A nonempty graph window requires at least one partition edge.",
                nameof(ordinals));
        }

        var first = graph.Source[ordered[0]].Span;
        if (first.Start != graph.Window.Start)
        {
            throw new ArgumentException(
                $"Partition starts at {first.Start}, not graph-window start {graph.Window.Start}.",
                nameof(ordinals));
        }

        var previous = first;
        for (var i = 1; i < ordered.Count; i++)
        {
            var current = graph.Source[ordered[i]].Span;
            if (!LocatedSemantics.CanSeq(previous, current))
            {
                throw new ArgumentException(
                    $"Partition edges #{ordered[i - 1]} {previous} and #{ordered[i]} {current} do not share a boundary.",
                    nameof(ordinals));
            }

            previous = current;
        }

        if (previous.End != graph.Window.End)
        {
            throw new ArgumentException(
                $"Partition ends at {previous.End}, not graph-window end {graph.Window.End}.",
                nameof(ordinals));
        }

        return new PartitionView(graph, ordered.ToArray());
    }

    public bool Equals(PartitionView? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        return other is not null &&
               ReferenceEquals(Graph, other.Graph) &&
               _ordinals.AsSpan().SequenceEqual(other._ordinals);
    }

    public override bool Equals(object? obj) => obj is PartitionView other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(RuntimeHelpers.GetHashCode(Graph));
        foreach (var ordinal in _ordinals)
        {
            hash.Add(ordinal);
        }

        return hash.ToHashCode();
    }

    public IEnumerator<int> GetEnumerator() =>
        ((IEnumerable<int>)_ordinals).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}
