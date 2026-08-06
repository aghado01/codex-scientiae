using System;
using System.Collections;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>
/// An immutable Boolean relation over located extents inside one declared text window. This is a
/// geometry value: compatible masters share the same basis, equal extents collapse, and no claim
/// occurrence, label, producer, cost, or path identity is retained.
/// </summary>
/// <remarks>
/// Empty extents are admitted because the complete declared-window diagonal is the identity for
/// <see cref="Seq"/>. This carrier is therefore distinct from the nonempty Allen interval carrier
/// and from occurrence-bearing <see cref="CandidateRegionGraph"/> edges.
/// </remarks>
public sealed class LocatedRelation : IReadOnlyList<TextSpan>, IEquatable<LocatedRelation>
{
    private readonly TextSpan[] _edges;

    private LocatedRelation(TextMaster master, TextSpan window, TextSpan[] edges)
    {
        Master = master;
        Window = window;
        _edges = edges;
    }

    /// <summary>A representative of the compatible immutable coordinate space.</summary>
    public TextMaster Master { get; }

    /// <summary>The exact window whose scalar-valid boundaries form this relation's carrier.</summary>
    public TextSpan Window { get; }

    public int Count => _edges.Length;

    public bool IsEmpty => _edges.Length == 0;

    public TextSpan this[int index] => _edges[index];

    /// <summary>The empty relation on one compatible-master/exact-window basis.</summary>
    public static LocatedRelation Empty(TextMaster master, TextSpan window)
    {
        ValidateBasis(master, window);
        return new LocatedRelation(master, window, Array.Empty<TextSpan>());
    }

    /// <summary>
    /// The complete diagonal relation: one empty extent at every scalar-valid boundary in the
    /// declared window, including both endpoints.
    /// </summary>
    public static LocatedRelation Identity(TextMaster master, TextSpan window)
    {
        ValidateBasis(master, window);
        var boundaries = LocatedSemantics.ValidBoundaries(master, window);
        var diagonal = new TextSpan[boundaries.Count];
        for (var i = 0; i < boundaries.Count; i++)
        {
            diagonal[i] = new TextSpan(boundaries[i], boundaries[i]);
        }

        return new LocatedRelation(master, window, diagonal);
    }

    /// <summary>
    /// Constructs a geometry relation. Input order and duplicates are forgotten; every extent,
    /// including an empty one, must be scalar-valid and contained in the exact declared window.
    /// </summary>
    public static LocatedRelation Create(
        TextMaster master,
        TextSpan window,
        IEnumerable<TextSpan> edges)
    {
        ValidateBasis(master, window);
        ArgumentNullException.ThrowIfNull(edges);

        var ordered = new List<TextSpan>();
        foreach (var edge in edges)
        {
            master.ValidateSpan(edge);
            if (!window.Contains(edge))
            {
                throw new ArgumentException(
                    $"Located extent {edge} lies outside the declared window {window}.",
                    nameof(edges));
            }

            ordered.Add(edge);
        }

        ordered.Sort(Compare);
        if (ordered.Count == 0)
        {
            return new LocatedRelation(master, window, Array.Empty<TextSpan>());
        }

        var unique = new List<TextSpan>(ordered.Count) { ordered[0] };
        for (var i = 1; i < ordered.Count; i++)
        {
            if (ordered[i] != unique[^1])
            {
                unique.Add(ordered[i]);
            }
        }

        return new LocatedRelation(master, window, unique.ToArray());
    }

    /// <summary>Tests geometry membership on this relation's declared basis.</summary>
    public bool Contains(TextSpan edge)
    {
        var low = 0;
        var high = _edges.Length - 1;
        while (low <= high)
        {
            var middle = low + ((high - low) / 2);
            var comparison = Compare(_edges[middle], edge);
            if (comparison == 0)
            {
                return true;
            }

            if (comparison < 0)
            {
                low = middle + 1;
            }
            else
            {
                high = middle - 1;
            }
        }

        return false;
    }

    public LocatedRelation Union(LocatedRelation other)
    {
        EnsureSameBasis(other);
        var combined = new TextSpan[Count + other.Count];
        Array.Copy(_edges, combined, Count);
        Array.Copy(other._edges, 0, combined, Count, other.Count);
        return Create(Master, Window, combined);
    }

    /// <summary>
    /// Shared-boundary relation composition. Two located extents compose exactly when the left
    /// end equals the right start; unlike Allen <c>Meets</c>, this admits diagonal empties.
    /// </summary>
    public LocatedRelation Seq(LocatedRelation other)
    {
        EnsureSameBasis(other);
        var composed = new List<TextSpan>();
        foreach (var left in _edges)
        {
            foreach (var right in other._edges)
            {
                if (LocatedSemantics.CanSeq(left, right))
                {
                    composed.Add(new TextSpan(left.Start, right.End));
                }
            }
        }

        return Create(Master, Window, composed);
    }

    /// <summary>Projects away diagonal extents, retaining only strictly consuming edges.</summary>
    public LocatedRelation Consuming()
    {
        var consuming = new List<TextSpan>(_edges.Length);
        foreach (var edge in _edges)
        {
            if (!edge.IsEmpty)
            {
                consuming.Add(edge);
            }
        }

        return new LocatedRelation(Master, Window, consuming.ToArray());
    }

    /// <summary>
    /// Reflexive-transitive Boolean geometry reachability: the full declared-window diagonal plus
    /// every path through strictly consuming edges. This is the direct finite reference backend.
    /// </summary>
    public LocatedRelation Reachability()
    {
        var adjacency = new Dictionary<int, List<int>>();
        foreach (var edge in _edges)
        {
            if (edge.IsEmpty)
            {
                continue;
            }

            if (!adjacency.TryGetValue(edge.Start, out var ends))
            {
                ends = new List<int>();
                adjacency.Add(edge.Start, ends);
            }

            ends.Add(edge.End);
        }

        var reachable = new List<TextSpan>();
        foreach (var start in LocatedSemantics.ValidBoundaries(Master, Window))
        {
            reachable.Add(new TextSpan(start, start));
            var visited = new HashSet<int> { start };
            var pending = new Stack<int>();
            pending.Push(start);
            while (pending.Count > 0)
            {
                var boundary = pending.Pop();
                if (!adjacency.TryGetValue(boundary, out var ends))
                {
                    continue;
                }

                foreach (var end in ends)
                {
                    if (!visited.Add(end))
                    {
                        continue;
                    }

                    reachable.Add(new TextSpan(start, end));
                    pending.Push(end);
                }
            }
        }

        return Create(Master, Window, reachable);
    }

    public bool Equals(LocatedRelation? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        return other is not null &&
               Master.IsCompatibleWith(other.Master) &&
               Window == other.Window &&
               _edges.AsSpan().SequenceEqual(other._edges);
    }

    public override bool Equals(object? obj) => obj is LocatedRelation other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(Master.DocumentId, StringComparer.Ordinal);
        hash.Add(Master.Revision);
        hash.Add(Master.Fingerprint, StringComparer.Ordinal);
        hash.Add(Window);
        foreach (var edge in _edges)
        {
            hash.Add(edge);
        }

        return hash.ToHashCode();
    }

    public IEnumerator<TextSpan> GetEnumerator() =>
        ((IEnumerable<TextSpan>)_edges).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    private void EnsureSameBasis(LocatedRelation other)
    {
        ArgumentNullException.ThrowIfNull(other);
        Master.EnsureCompatibleWith(other.Master);
        if (Window != other.Window)
        {
            throw new InvalidOperationException(
                $"Located relations have different declared windows: {Window} and {other.Window}.");
        }
    }

    private static void ValidateBasis(TextMaster master, TextSpan window)
    {
        ArgumentNullException.ThrowIfNull(master);
        master.ValidateSpan(window);
    }

    private static int Compare(TextSpan left, TextSpan right)
    {
        var comparison = left.Start.CompareTo(right.Start);
        return comparison != 0 ? comparison : left.End.CompareTo(right.End);
    }
}
