using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;

namespace CodexSci.Doccer;

/// <summary>
/// An immutable flat candidate graph over one exact frozen claim batch and one retained window.
/// Selected claim ordinals are parallel identity-bearing edges from their span start to end; equal
/// geometry remains distinct until the explicit <see cref="ToLocatedRelation"/> projection.
/// </summary>
public sealed class CandidateRegionGraph : IReadOnlyCollection<int>, IEquatable<CandidateRegionGraph>
{
    private CandidateRegionGraph(ClaimSelection candidates, TextSpan window)
    {
        Candidates = candidates;
        Window = window;
    }

    /// <summary>The exact frozen occurrence basis inherited through <see cref="Candidates"/>.</summary>
    public SpanBatch Source => Candidates.Basis;

    public TextMaster Master => Source.Master;

    /// <summary>The exact immutable population whose ordinals are graph-edge identities.</summary>
    public ClaimSelection Candidates { get; }

    /// <summary>The exact retained graph window on <see cref="Master"/>.</summary>
    public TextSpan Window { get; }

    public int Count => Candidates.Count;

    public bool IsEmpty => Candidates.IsEmpty;

    /// <summary>
    /// Constructs a graph from an exact occurrence selection. Every selected claim must be
    /// nonempty and wholly contained in the validated window; construction never clips, filters,
    /// or expands candidates.
    /// </summary>
    public static CandidateRegionGraph Create(ClaimSelection candidates, TextSpan window)
    {
        ArgumentNullException.ThrowIfNull(candidates);
        candidates.Master.ValidateSpan(window);
        foreach (var ordinal in candidates)
        {
            var span = candidates.Basis[ordinal].Span;
            if (span.IsEmpty)
            {
                throw new ArgumentException(
                    $"Candidate claim #{ordinal} has an empty extent; graph edges must consume text.",
                    nameof(candidates));
            }

            if (!window.Contains(span))
            {
                throw new ArgumentException(
                    $"Candidate claim #{ordinal} extent {span} lies outside graph window {window}.",
                    nameof(candidates));
            }
        }

        return new CandidateRegionGraph(candidates, window);
    }

    /// <summary>Tests exact graph-edge membership by source-batch ordinal.</summary>
    public bool Contains(int ordinal) => Candidates.Contains(ordinal);

    /// <summary>
    /// Explicitly forgets claim-occurrence identity and projects selected edge geometry onto the
    /// compatible-master/exact-window located carrier. Parallel equal-geometry ordinals collapse
    /// at this call and cannot be recovered from its result.
    /// </summary>
    public LocatedRelation ToLocatedRelation()
    {
        var geometry = new TextSpan[Count];
        var index = 0;
        foreach (var ordinal in Candidates)
        {
            geometry[index++] = Source[ordinal].Span;
        }

        return LocatedRelation.Create(Master, Window, geometry);
    }

    /// <summary>
    /// Compares graph definitions on one exact occurrence basis. Equal graphs retain the same
    /// frozen-batch reference, window, and candidate ordinal set; compatible-but-distinct batches
    /// remain unequal.
    /// </summary>
    public bool Equals(CandidateRegionGraph? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        return other is not null &&
               ReferenceEquals(Source, other.Source) &&
               Window == other.Window &&
               Candidates.Equals(other.Candidates);
    }

    public override bool Equals(object? obj) => obj is CandidateRegionGraph other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(RuntimeHelpers.GetHashCode(Source));
        hash.Add(Window);
        hash.Add(Candidates);
        return hash.ToHashCode();
    }

    public IEnumerator<int> GetEnumerator() => Candidates.GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}
