using System;
using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using System.Runtime.CompilerServices;

namespace CodexSci.Doccer;

/// <summary>
/// An immutable occurrence selection over one exact frozen <see cref="SpanBatch"/>. Membership is
/// batch-local ordinal identity: compatible masters do not make selections interchangeable.
/// Canonical enumeration is ascending ordinal; geometry and priority are separate record queries.
/// </summary>
public sealed class ClaimSelection : IReadOnlyCollection<int>, IEquatable<ClaimSelection>
{
    private const int WordShift = 6;
    private const int WordBits = 64;
    private const int WordMask = WordBits - 1;

    private readonly ulong[] _words;

    private ClaimSelection(SpanBatch basis, ulong[] words, int count)
    {
        Basis = basis;
        _words = words;
        Count = count;
    }

    /// <summary>The exact frozen batch whose ordinals form this selection's universe.</summary>
    public SpanBatch Basis { get; }

    public TextMaster Master => Basis.Master;

    public int Count { get; }

    public bool IsEmpty => Count == 0;

    public static ClaimSelection None(SpanBatch basis)
    {
        ArgumentNullException.ThrowIfNull(basis);
        return new ClaimSelection(basis, new ulong[WordCount(basis.Count)], 0);
    }

    public static ClaimSelection All(SpanBatch basis)
    {
        ArgumentNullException.ThrowIfNull(basis);
        var words = new ulong[WordCount(basis.Count)];
        Array.Fill(words, ulong.MaxValue);
        MaskUnusedTail(words, basis.Count);
        return new ClaimSelection(basis, words, basis.Count);
    }

    /// <summary>
    /// Copies an ordinal population into a selection. Repeated ordinals coalesce; every ordinal
    /// must belong to <paramref name="basis"/>.
    /// </summary>
    public static ClaimSelection Create(SpanBatch basis, IEnumerable<int> ordinals)
    {
        ArgumentNullException.ThrowIfNull(basis);
        ArgumentNullException.ThrowIfNull(ordinals);

        var words = new ulong[WordCount(basis.Count)];
        var count = 0;
        foreach (var ordinal in ordinals)
        {
            ValidateOrdinal(basis, ordinal);
            var word = ordinal >> WordShift;
            var bit = 1UL << (ordinal & WordMask);
            if ((words[word] & bit) == 0)
            {
                words[word] |= bit;
                count++;
            }
        }

        return new ClaimSelection(basis, words, count);
    }

    /// <summary>Selects claims by evaluating one predicate exactly once per basis ordinal.</summary>
    public static ClaimSelection FromPredicate(SpanBatch basis, Func<SpanRecord, bool> predicate)
    {
        ArgumentNullException.ThrowIfNull(basis);
        ArgumentNullException.ThrowIfNull(predicate);

        var words = new ulong[WordCount(basis.Count)];
        var count = 0;
        for (var ordinal = 0; ordinal < basis.Count; ordinal++)
        {
            if (!predicate(basis[ordinal]))
            {
                continue;
            }

            words[ordinal >> WordShift] |= 1UL << (ordinal & WordMask);
            count++;
        }

        return new ClaimSelection(basis, words, count);
    }

    /// <summary>Tests batch-local membership; an ordinal outside the basis is not a proposition.</summary>
    public bool Contains(int ordinal)
    {
        ValidateOrdinal(Basis, ordinal);
        return (_words[ordinal >> WordShift] & (1UL << (ordinal & WordMask))) != 0;
    }

    public ClaimSelection Union(ClaimSelection other) =>
        Combine(other, static (left, right) => left | right);

    public ClaimSelection Intersect(ClaimSelection other) =>
        Combine(other, static (left, right) => left & right);

    public ClaimSelection Subtract(ClaimSelection other) =>
        Combine(other, static (left, right) => left & ~right);

    /// <summary>The relative complement inside this selection's exact batch universe.</summary>
    public ClaimSelection Complement()
    {
        var words = new ulong[_words.Length];
        for (var i = 0; i < words.Length; i++)
        {
            words[i] = ~_words[i];
        }

        MaskUnusedTail(words, Basis.Count);
        return new ClaimSelection(Basis, words, Basis.Count - Count);
    }

    /// <summary>
    /// Projects selected claims into a named query order. The returned order is not selection
    /// identity and canonical ordinal enumeration remains unchanged.
    /// </summary>
    public IReadOnlyList<SpanRecord> Records(ClaimOrder order = ClaimOrder.Geometry)
    {
        ClaimOrdering.Validate(order);
        var records = new SpanRecord[Count];
        var index = 0;
        foreach (var ordinal in this)
        {
            records[index++] = Basis[ordinal];
        }

        Array.Sort(records, (left, right) => ClaimOrdering.Compare(left, right, order));
        return Array.AsReadOnly(records);
    }

    /// <summary>
    /// Forgets occurrence identity and normalizes the selected geometry into a region set.
    /// Equal, overlapping, and adjacent claim spans may therefore collapse.
    /// </summary>
    public SpanSet Coverage()
    {
        var spans = new TextSpan[Count];
        var index = 0;
        foreach (var ordinal in this)
        {
            spans[index++] = Basis[ordinal].Span;
        }

        return SpanSet.Create(Basis.Master, spans);
    }

    public bool Equals(ClaimSelection? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        if (other is null || !ReferenceEquals(Basis, other.Basis) || Count != other.Count)
        {
            return false;
        }

        return _words.AsSpan().SequenceEqual(other._words);
    }

    public override bool Equals(object? obj) => obj is ClaimSelection other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(RuntimeHelpers.GetHashCode(Basis));
        hash.Add(Count);
        foreach (var word in _words)
        {
            hash.Add(word);
        }

        return hash.ToHashCode();
    }

    public IEnumerator<int> GetEnumerator()
    {
        for (var ordinal = 0; ordinal < Basis.Count; ordinal++)
        {
            if ((_words[ordinal >> WordShift] & (1UL << (ordinal & WordMask))) != 0)
            {
                yield return ordinal;
            }
        }
    }

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    private ClaimSelection Combine(ClaimSelection other, Func<ulong, ulong, ulong> operation)
    {
        EnsureSameBasis(other);
        var words = new ulong[_words.Length];
        var count = 0;
        for (var i = 0; i < words.Length; i++)
        {
            words[i] = operation(_words[i], other._words[i]);
            count += BitOperations.PopCount(words[i]);
        }

        return new ClaimSelection(Basis, words, count);
    }

    private void EnsureSameBasis(ClaimSelection other)
    {
        ArgumentNullException.ThrowIfNull(other);
        if (!ReferenceEquals(Basis, other.Basis))
        {
            throw new InvalidOperationException(
                "Claim selections have different frozen-batch bases; batch-local ordinals cannot be mixed.");
        }
    }

    private static void ValidateOrdinal(SpanBatch basis, int ordinal)
    {
        if ((uint)ordinal >= (uint)basis.Count)
        {
            throw new ArgumentOutOfRangeException(nameof(ordinal), ordinal, "Ordinal is outside the selection basis.");
        }
    }

    private static int WordCount(int ordinalCount) => (ordinalCount + WordMask) >> WordShift;

    private static void MaskUnusedTail(ulong[] words, int ordinalCount)
    {
        if (words.Length == 0 || (ordinalCount & WordMask) == 0)
        {
            return;
        }

        words[^1] &= (1UL << (ordinalCount & WordMask)) - 1UL;
    }
}
