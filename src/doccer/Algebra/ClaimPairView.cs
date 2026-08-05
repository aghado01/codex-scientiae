using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Runtime.CompilerServices;

namespace CodexSci.Doccer;

/// <summary>
/// One exact occurrence edge. Ordinals resolve against the containing view's explicit left and
/// right bases; <see cref="Relation"/> is the Allen relation derived from those two claim spans.
/// </summary>
public readonly record struct ClaimPair(
    int LeftOrdinal,
    int RightOrdinal,
    AllenRelation Relation);

/// <summary>
/// Every exact middle occurrence realizing one outer pair in a single pair-view composition.
/// Middle ordinals are ascending and resolve against the containing witness view's middle basis.
/// </summary>
public readonly record struct ClaimPairWitnessGroup(
    int LeftOrdinal,
    int RightOrdinal,
    IReadOnlyList<int> MiddleOrdinals);

/// <summary>
/// A transparent, basis-stamped witness query for one exact pair composition. This is not a
/// normalized support carrier: it has no persistence, associativity, or bracket-independence
/// contract of its own.
/// </summary>
public sealed class ClaimPairWitnessView : IReadOnlyList<ClaimPairWitnessGroup>
{
    private readonly ClaimPairWitnessGroup[] _groups;
    private readonly ReadOnlyCollection<ClaimPairWitnessGroup> _groupsView;

    internal ClaimPairWitnessView(
        SpanBatch leftBasis,
        SpanBatch middleBasis,
        SpanBatch rightBasis,
        ClaimPairWitnessGroup[] groups)
    {
        LeftBasis = leftBasis;
        MiddleBasis = middleBasis;
        RightBasis = rightBasis;
        _groups = groups;
        _groupsView = Array.AsReadOnly(_groups);
    }

    public SpanBatch LeftBasis { get; }

    public SpanBatch MiddleBasis { get; }

    public SpanBatch RightBasis { get; }

    public IReadOnlyList<ClaimPairWitnessGroup> Groups => _groupsView;

    public int Count => _groups.Length;

    public ClaimPairWitnessGroup this[int index] => _groups[index];

    public IEnumerator<ClaimPairWitnessGroup> GetEnumerator() =>
        ((IEnumerable<ClaimPairWitnessGroup>)_groups).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}

/// <summary>
/// An immutable exact finite relation between claim occurrences on two explicit frozen batches.
/// Identity is the ordered pair of exact basis references plus extensional ordinal-pair
/// membership. Canonical enumeration is lexicographic by (left ordinal, right ordinal); the Allen
/// label is derived evidence and never substitutes for occurrence identity.
/// </summary>
public sealed class ClaimPairView : IReadOnlyCollection<ClaimPair>, IEquatable<ClaimPairView>
{
    private readonly ClaimPair[] _pairs;

    private ClaimPairView(SpanBatch leftBasis, SpanBatch rightBasis, ClaimPair[] pairs)
    {
        LeftBasis = leftBasis;
        RightBasis = rightBasis;
        _pairs = pairs;
    }

    public SpanBatch LeftBasis { get; }

    public SpanBatch RightBasis { get; }

    public int Count => _pairs.Length;

    public bool IsEmpty => _pairs.Length == 0;

    /// <summary>An empty exact relation over two compatible, explicitly retained bases.</summary>
    public static ClaimPairView None(SpanBatch leftBasis, SpanBatch rightBasis)
    {
        EnsureCompatibleBases(leftBasis, rightBasis);
        return new ClaimPairView(leftBasis, rightBasis, Array.Empty<ClaimPair>());
    }

    /// <summary>
    /// Constructs an exact relation from ordinal pairs. Input order and duplicates are forgotten;
    /// every ordinal is validated and every Allen label is derived from the retained bases.
    /// </summary>
    public static ClaimPairView Create(
        SpanBatch leftBasis,
        SpanBatch rightBasis,
        IEnumerable<(int LeftOrdinal, int RightOrdinal)> pairs)
    {
        EnsureCompatibleBases(leftBasis, rightBasis);
        ArgumentNullException.ThrowIfNull(pairs);

        var keys = new SortedSet<(int LeftOrdinal, int RightOrdinal)>();
        foreach (var pair in pairs)
        {
            ValidateOrdinal(leftBasis, pair.LeftOrdinal, nameof(pair.LeftOrdinal));
            ValidateOrdinal(rightBasis, pair.RightOrdinal, nameof(pair.RightOrdinal));
            keys.Add(pair);
        }

        return FromSortedKeys(leftBasis, rightBasis, keys);
    }

    /// <summary>
    /// Relates every occurrence pair and retains exactly the edges whose derived Allen atom is in
    /// <paramref name="relations"/>. This is the one reference geometry-join implementation.
    /// </summary>
    public static ClaimPairView Relate(
        SpanBatch leftBasis,
        SpanBatch rightBasis,
        AllenRelationSet relations)
    {
        EnsureCompatibleBases(leftBasis, rightBasis);
        if (relations.IsEmpty)
        {
            return new ClaimPairView(leftBasis, rightBasis, Array.Empty<ClaimPair>());
        }

        var pairs = new List<ClaimPair>();
        for (var left = 0; left < leftBasis.Count; left++)
        {
            for (var right = 0; right < rightBasis.Count; right++)
            {
                var relation = AllenAlgebra.Relate(leftBasis[left].Span, rightBasis[right].Span);
                if (relations.Contains(relation))
                {
                    pairs.Add(new ClaimPair(left, right, relation));
                }
            }
        }

        return new ClaimPairView(leftBasis, rightBasis, pairs.ToArray());
    }

    /// <summary>
    /// The occurrence identity relation: the ordinal diagonal on one exact frozen batch. This is
    /// narrower than filtering the batch against itself for geometric Allen equality when two
    /// distinct claims have equal spans.
    /// </summary>
    public static ClaimPairView Identity(SpanBatch basis)
    {
        ArgumentNullException.ThrowIfNull(basis);
        var pairs = new ClaimPair[basis.Count];
        for (var ordinal = 0; ordinal < basis.Count; ordinal++)
        {
            pairs[ordinal] = new ClaimPair(ordinal, ordinal, AllenRelation.Equal);
        }

        return new ClaimPairView(basis, basis, pairs);
    }

    /// <summary>Tests exact ordinal-pair membership; out-of-basis ordinals are undefined.</summary>
    public bool Contains(int leftOrdinal, int rightOrdinal)
    {
        ValidateOrdinal(LeftBasis, leftOrdinal, nameof(leftOrdinal));
        ValidateOrdinal(RightBasis, rightOrdinal, nameof(rightOrdinal));

        var low = 0;
        var high = _pairs.Length - 1;
        while (low <= high)
        {
            var middle = low + ((high - low) / 2);
            var comparison = Compare(_pairs[middle], leftOrdinal, rightOrdinal);
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

    public ClaimPairView Converse()
    {
        var pairs = new ClaimPair[_pairs.Length];
        for (var i = 0; i < _pairs.Length; i++)
        {
            var pair = _pairs[i];
            pairs[i] = new ClaimPair(
                pair.RightOrdinal,
                pair.LeftOrdinal,
                AllenAlgebra.Inverse(pair.Relation));
        }

        Array.Sort(pairs, static (left, right) => Compare(left, right.LeftOrdinal, right.RightOrdinal));
        return new ClaimPairView(RightBasis, LeftBasis, pairs);
    }

    public ClaimSelection ProjectLeft()
    {
        var ordinals = new int[_pairs.Length];
        for (var i = 0; i < _pairs.Length; i++)
        {
            ordinals[i] = _pairs[i].LeftOrdinal;
        }

        return ClaimSelection.Create(LeftBasis, ordinals);
    }

    public ClaimSelection ProjectRight()
    {
        var ordinals = new int[_pairs.Length];
        for (var i = 0; i < _pairs.Length; i++)
        {
            ordinals[i] = _pairs[i].RightOrdinal;
        }

        return ClaimSelection.Create(RightBasis, ordinals);
    }

    public ClaimPairView SemiJoinLeft(ClaimSelection selection)
    {
        EnsureSelectionBasis(selection, LeftBasis, "left");
        var pairs = new List<ClaimPair>();
        foreach (var pair in _pairs)
        {
            if (selection.Contains(pair.LeftOrdinal))
            {
                pairs.Add(pair);
            }
        }

        return new ClaimPairView(LeftBasis, RightBasis, pairs.ToArray());
    }

    public ClaimPairView SemiJoinRight(ClaimSelection selection)
    {
        EnsureSelectionBasis(selection, RightBasis, "right");
        var pairs = new List<ClaimPair>();
        foreach (var pair in _pairs)
        {
            if (selection.Contains(pair.RightOrdinal))
            {
                pairs.Add(pair);
            }
        }

        return new ClaimPairView(LeftBasis, RightBasis, pairs.ToArray());
    }

    /// <summary>
    /// Ordinary exact relation composition over an identical middle frozen batch. Every output
    /// edge has an actual middle ordinal; duplicate outer pairs collapse. This method never calls
    /// qualitative <see cref="AllenRelationSet.AllenCompose"/> to create exact edges.
    /// </summary>
    public ClaimPairView ComposePairs(ClaimPairView other)
    {
        EnsureComposable(other);
        var outerPairs = new SortedSet<(int LeftOrdinal, int RightOrdinal)>();
        foreach (var leftPair in _pairs)
        {
            foreach (var rightPair in other._pairs)
            {
                if (leftPair.RightOrdinal == rightPair.LeftOrdinal)
                {
                    outerPairs.Add((leftPair.LeftOrdinal, rightPair.RightOrdinal));
                }
            }
        }

        return FromSortedKeys(LeftBasis, other.RightBasis, outerPairs);
    }

    /// <summary>
    /// Reports every exact middle ordinal for each outer edge of this one composition. The
    /// extensional result remains <see cref="ComposePairs"/>; these groups are transparent query
    /// evidence rather than normalized proof identity.
    /// </summary>
    public ClaimPairWitnessView GroupMiddleWitnesses(ClaimPairView other)
    {
        EnsureComposable(other);
        var grouped = new SortedDictionary<
            (int LeftOrdinal, int RightOrdinal),
            SortedSet<int>>();

        foreach (var leftPair in _pairs)
        {
            foreach (var rightPair in other._pairs)
            {
                if (leftPair.RightOrdinal != rightPair.LeftOrdinal)
                {
                    continue;
                }

                var key = (leftPair.LeftOrdinal, rightPair.RightOrdinal);
                if (!grouped.TryGetValue(key, out var middles))
                {
                    middles = new SortedSet<int>();
                    grouped.Add(key, middles);
                }

                middles.Add(leftPair.RightOrdinal);
            }
        }

        var groups = new ClaimPairWitnessGroup[grouped.Count];
        var index = 0;
        foreach (var entry in grouped)
        {
            var middleOrdinals = new int[entry.Value.Count];
            entry.Value.CopyTo(middleOrdinals);
            groups[index++] = new ClaimPairWitnessGroup(
                entry.Key.LeftOrdinal,
                entry.Key.RightOrdinal,
                Array.AsReadOnly(middleOrdinals));
        }

        return new ClaimPairWitnessView(
            LeftBasis,
            RightBasis,
            other.RightBasis,
            groups);
    }

    public bool Equals(ClaimPairView? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        return other is not null &&
               ReferenceEquals(LeftBasis, other.LeftBasis) &&
               ReferenceEquals(RightBasis, other.RightBasis) &&
               _pairs.AsSpan().SequenceEqual(other._pairs);
    }

    public override bool Equals(object? obj) => obj is ClaimPairView other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(RuntimeHelpers.GetHashCode(LeftBasis));
        hash.Add(RuntimeHelpers.GetHashCode(RightBasis));
        foreach (var pair in _pairs)
        {
            hash.Add(pair);
        }

        return hash.ToHashCode();
    }

    public IEnumerator<ClaimPair> GetEnumerator() =>
        ((IEnumerable<ClaimPair>)_pairs).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    private static ClaimPairView FromSortedKeys(
        SpanBatch leftBasis,
        SpanBatch rightBasis,
        IEnumerable<(int LeftOrdinal, int RightOrdinal)> keys)
    {
        EnsureCompatibleBases(leftBasis, rightBasis);
        var pairs = new List<ClaimPair>();
        foreach (var key in keys)
        {
            var relation = AllenAlgebra.Relate(
                leftBasis[key.LeftOrdinal].Span,
                rightBasis[key.RightOrdinal].Span);
            pairs.Add(new ClaimPair(key.LeftOrdinal, key.RightOrdinal, relation));
        }

        return new ClaimPairView(leftBasis, rightBasis, pairs.ToArray());
    }

    private void EnsureComposable(ClaimPairView other)
    {
        ArgumentNullException.ThrowIfNull(other);
        if (!ReferenceEquals(RightBasis, other.LeftBasis))
        {
            throw new InvalidOperationException(
                "Pair views do not share the identical frozen middle batch required for exact composition.");
        }
    }

    private static void EnsureSelectionBasis(
        ClaimSelection selection,
        SpanBatch expectedBasis,
        string side)
    {
        ArgumentNullException.ThrowIfNull(selection);
        if (!ReferenceEquals(selection.Basis, expectedBasis))
        {
            throw new InvalidOperationException(
                $"The {side} semijoin selection does not use the pair view's exact {side} basis.");
        }
    }

    private static void EnsureCompatibleBases(SpanBatch leftBasis, SpanBatch rightBasis)
    {
        ArgumentNullException.ThrowIfNull(leftBasis);
        ArgumentNullException.ThrowIfNull(rightBasis);
        leftBasis.Master.EnsureCompatibleWith(rightBasis.Master);
    }

    private static void ValidateOrdinal(SpanBatch basis, int ordinal, string parameterName)
    {
        if ((uint)ordinal >= (uint)basis.Count)
        {
            throw new ArgumentOutOfRangeException(
                parameterName,
                ordinal,
                "Ordinal is outside the pair-view basis.");
        }
    }

    private static int Compare(ClaimPair pair, int leftOrdinal, int rightOrdinal)
    {
        var comparison = pair.LeftOrdinal.CompareTo(leftOrdinal);
        return comparison != 0 ? comparison : pair.RightOrdinal.CompareTo(rightOrdinal);
    }
}
