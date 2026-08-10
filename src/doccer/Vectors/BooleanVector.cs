using System;
using System.Collections;
using System.Collections.Generic;
using System.Numerics;

namespace CodexSci.Doccer;

/// <summary>
/// An immutable finite Boolean sequence. Logical length and bit values define identity; packed
/// words are private representation and bits beyond <see cref="Length"/> have no semantics.
/// </summary>
public sealed class BooleanVector : IReadOnlyCollection<int>, IEquatable<BooleanVector>
{
    private const int WordShift = 6;
    private const int WordBits = 64;
    private const int WordMask = WordBits - 1;

    private readonly ulong[] _words;

    private BooleanVector(int length, ulong[] words)
    {
        Length = length;
        _words = words;
        Population = CountPopulation(words, length);
    }

    /// <summary>The number of logical bits.</summary>
    public int Length { get; }

    /// <summary>The number of set logical bits.</summary>
    public int Population { get; }

    /// <summary>The set-bit population, for ascending set-ordinal enumeration.</summary>
    public int Count => Population;

    public bool IsEmpty => Population == 0;

    /// <summary>Returns the logical bit at <paramref name="ordinal"/>.</summary>
    public bool this[int ordinal] => Contains(ordinal);

    public static BooleanVector None(int length)
    {
        ValidateLength(length);
        return new BooleanVector(length, new ulong[WordCount(length)]);
    }

    public static BooleanVector All(int length)
    {
        ValidateLength(length);
        var words = new ulong[WordCount(length)];
        Array.Fill(words, ulong.MaxValue);
        MaskUnusedTail(words, length);
        return new BooleanVector(length, words);
    }

    /// <summary>
    /// Copies a set-ordinal population. Repeated ordinals coalesce and every ordinal must be in
    /// the declared logical range.
    /// </summary>
    public static BooleanVector Create(int length, IEnumerable<int> setOrdinals)
    {
        ValidateLength(length);
        ArgumentNullException.ThrowIfNull(setOrdinals);

        var words = new ulong[WordCount(length)];
        foreach (var ordinal in setOrdinals)
        {
            ValidateOrdinal(length, ordinal);
            words[ordinal >> WordShift] |= 1UL << (ordinal & WordMask);
        }

        return new BooleanVector(length, words);
    }

    /// <summary>Tests a logical bit; an ordinal outside the vector is not a proposition.</summary>
    public bool Contains(int ordinal)
    {
        ValidateOrdinal(Length, ordinal);
        return (LogicalWord(ordinal >> WordShift) & (1UL << (ordinal & WordMask))) != 0;
    }

    public BooleanVector Or(BooleanVector other) =>
        Combine(other, static (left, right) => left | right);

    public BooleanVector And(BooleanVector other) =>
        Combine(other, static (left, right) => left & right);

    public BooleanVector Xor(BooleanVector other) =>
        Combine(other, static (left, right) => left ^ right);

    public BooleanVector AndNot(BooleanVector other) =>
        Combine(other, static (left, right) => left & ~right);

    public BooleanVector Not()
    {
        var words = new ulong[_words.Length];
        for (var i = 0; i < words.Length; i++)
        {
            words[i] = ~LogicalWord(i);
        }

        MaskUnusedTail(words, Length);
        return new BooleanVector(Length, words);
    }

    /// <summary>Moves logical bits to greater ordinals and fills vacated positions with false.</summary>
    public BooleanVector ShiftTowardHigherOrdinals(int distance)
    {
        ValidateDistance(distance);
        if (distance == 0)
        {
            return new BooleanVector(Length, LogicalWordsCopy());
        }

        if (distance >= Length)
        {
            return None(Length);
        }

        var words = new ulong[_words.Length];
        var wholeWords = distance >> WordShift;
        var inner = distance & WordMask;
        for (var source = 0; source < _words.Length; source++)
        {
            var value = LogicalWord(source);
            var target = source + wholeWords;
            if (target >= words.Length)
            {
                break;
            }

            words[target] |= value << inner;
            if (inner != 0 && target + 1 < words.Length)
            {
                words[target + 1] |= value >> (WordBits - inner);
            }
        }

        MaskUnusedTail(words, Length);
        return new BooleanVector(Length, words);
    }

    /// <summary>Moves logical bits to lesser ordinals and fills vacated positions with false.</summary>
    public BooleanVector ShiftTowardLowerOrdinals(int distance)
    {
        ValidateDistance(distance);
        if (distance == 0)
        {
            return new BooleanVector(Length, LogicalWordsCopy());
        }

        if (distance >= Length)
        {
            return None(Length);
        }

        var words = new ulong[_words.Length];
        var wholeWords = distance >> WordShift;
        var inner = distance & WordMask;
        for (var source = wholeWords; source < _words.Length; source++)
        {
            var value = LogicalWord(source);
            var target = source - wholeWords;
            words[target] |= value >> inner;
            if (inner != 0 && target > 0)
            {
                words[target - 1] |= value << (WordBits - inner);
            }
        }

        MaskUnusedTail(words, Length);
        return new BooleanVector(Length, words);
    }

    /// <summary>Returns the XOR reduction of the logical bits.</summary>
    public bool Parity()
    {
        var parity = false;
        for (var i = 0; i < _words.Length; i++)
        {
            parity ^= (BitOperations.PopCount(LogicalWord(i)) & 1) != 0;
        }

        return parity;
    }

    /// <summary>
    /// Computes the forward inclusive prefix XOR. State at ordinal i is the entering carry XOR
    /// every input bit through i; carry-out is the final state.
    /// </summary>
    public BooleanPrefixParityResult PrefixParity(bool carryIn = false)
    {
        var words = new ulong[_words.Length];
        var state = carryIn;
        for (var ordinal = 0; ordinal < Length; ordinal++)
        {
            if (this[ordinal])
            {
                state = !state;
            }

            if (state)
            {
                words[ordinal >> WordShift] |= 1UL << (ordinal & WordMask);
            }
        }

        return new BooleanPrefixParityResult(new BooleanVector(Length, words), state);
    }

    /// <summary>
    /// Reconstructs transition bits from this state sequence and the state immediately preceding
    /// ordinal zero.
    /// </summary>
    public BooleanVector AdjacentTransitions(bool precedingState = false)
    {
        var words = new ulong[_words.Length];
        var previous = precedingState;
        for (var ordinal = 0; ordinal < Length; ordinal++)
        {
            var current = this[ordinal];
            if (previous != current)
            {
                words[ordinal >> WordShift] |= 1UL << (ordinal & WordMask);
            }

            previous = current;
        }

        return new BooleanVector(Length, words);
    }

    public bool Equals(BooleanVector? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        if (other is null || Length != other.Length || Population != other.Population)
        {
            return false;
        }

        for (var i = 0; i < _words.Length; i++)
        {
            if (LogicalWord(i) != other.LogicalWord(i))
            {
                return false;
            }
        }

        return true;
    }

    public override bool Equals(object? obj) => obj is BooleanVector other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(Length);
        for (var i = 0; i < _words.Length; i++)
        {
            hash.Add(LogicalWord(i));
        }

        return hash.ToHashCode();
    }

    public IEnumerator<int> GetEnumerator()
    {
        for (var wordIndex = 0; wordIndex < _words.Length; wordIndex++)
        {
            var word = LogicalWord(wordIndex);
            while (word != 0)
            {
                var bit = BitOperations.TrailingZeroCount(word);
                yield return (wordIndex << WordShift) + bit;
                word &= word - 1;
            }
        }
    }

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    /// <summary>
    /// Constructs a vector whose unused physical tail is deliberately not normalized. This is an
    /// internal assurance seam proving that public semantics never observe storage beyond Length.
    /// </summary>
    internal static BooleanVector FromPhysicalWordsForTesting(int length, IEnumerable<ulong> words)
    {
        ValidateLength(length);
        ArgumentNullException.ThrowIfNull(words);
        var snapshot = new List<ulong>(words).ToArray();
        if (snapshot.Length != WordCount(length))
        {
            throw new ArgumentException("Physical word count does not match logical length.", nameof(words));
        }

        return new BooleanVector(length, snapshot);
    }

    private BooleanVector Combine(BooleanVector other, Func<ulong, ulong, ulong> operation)
    {
        EnsureSameLength(other);
        var words = new ulong[_words.Length];
        for (var i = 0; i < words.Length; i++)
        {
            words[i] = operation(LogicalWord(i), other.LogicalWord(i));
        }

        MaskUnusedTail(words, Length);
        return new BooleanVector(Length, words);
    }

    private void EnsureSameLength(BooleanVector other)
    {
        ArgumentNullException.ThrowIfNull(other);
        if (Length != other.Length)
        {
            throw new ArgumentException("Boolean vectors must have equal logical lengths.", nameof(other));
        }
    }

    private ulong LogicalWord(int index) =>
        index == _words.Length - 1 ? _words[index] & TailMask(Length) : _words[index];

    private ulong[] LogicalWordsCopy()
    {
        var words = (ulong[])_words.Clone();
        MaskUnusedTail(words, Length);
        return words;
    }

    private static int CountPopulation(ulong[] words, int length)
    {
        var count = 0;
        for (var i = 0; i < words.Length; i++)
        {
            var word = i == words.Length - 1 ? words[i] & TailMask(length) : words[i];
            count += BitOperations.PopCount(word);
        }

        return count;
    }

    private static int WordCount(int length) =>
        checked((int)(((long)length + WordMask) >> WordShift));

    private static ulong TailMask(int length)
    {
        var used = length & WordMask;
        return used == 0 ? ulong.MaxValue : (1UL << used) - 1UL;
    }

    private static void MaskUnusedTail(ulong[] words, int length)
    {
        if (words.Length != 0)
        {
            words[^1] &= TailMask(length);
        }
    }

    private static void ValidateLength(int length)
    {
        if (length < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(length));
        }
    }

    private static void ValidateDistance(int distance)
    {
        if (distance < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(distance));
        }
    }

    private static void ValidateOrdinal(int length, int ordinal)
    {
        if ((uint)ordinal >= (uint)length)
        {
            throw new ArgumentOutOfRangeException(nameof(ordinal), ordinal, "Ordinal is outside the vector.");
        }
    }
}

/// <summary>The value and carry-out produced by one inclusive Boolean prefix-parity scan.</summary>
public sealed class BooleanPrefixParityResult
{
    internal BooleanPrefixParityResult(BooleanVector vector, bool carryOut)
    {
        Vector = vector;
        CarryOut = carryOut;
    }

    public BooleanVector Vector { get; }

    public bool CarryOut { get; }
}
