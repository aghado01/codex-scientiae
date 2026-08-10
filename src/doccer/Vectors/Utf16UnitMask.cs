using System;
using System.Collections;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>
/// An immutable Boolean mask over one exact numeric UTF-16 code-unit window. Direct masks may
/// begin, end, or select inside a surrogate pair; scalar safety belongs to explicit harvest.
/// </summary>
public sealed class Utf16UnitMask : IReadOnlyCollection<int>, IEquatable<Utf16UnitMask>
{
    public Utf16UnitMask(TextMaster master, TextSpan window, BooleanVector vector)
    {
        ArgumentNullException.ThrowIfNull(master);
        ArgumentNullException.ThrowIfNull(vector);
        if (window.End > master.Length)
        {
            throw new ArgumentOutOfRangeException(nameof(window), window, "Window exceeds the master length.");
        }

        if (vector.Length != window.Length)
        {
            throw new ArgumentException("Vector length must equal the UTF-16 window length.", nameof(vector));
        }

        Master = master;
        Window = window;
        Vector = vector;
    }

    public TextMaster Master { get; }

    public TextSpan Window { get; }

    public BooleanVector Vector { get; }

    public int Length => Vector.Length;

    public int Population => Vector.Population;

    /// <summary>The selected-offset population, for ascending absolute-offset enumeration.</summary>
    public int Count => Population;

    public bool IsEmpty => Vector.IsEmpty;

    /// <summary>Returns the bit at a window-local ordinal.</summary>
    public bool this[int localOrdinal] => Vector[localOrdinal];

    public bool ContainsLocalOrdinal(int localOrdinal) => Vector.Contains(localOrdinal);

    /// <summary>Returns the bit at one absolute code-unit offset inside the exact window.</summary>
    public bool ContainsOffset(int offset)
    {
        if (!Window.Contains(offset))
        {
            throw new ArgumentOutOfRangeException(nameof(offset), offset, "Offset is outside the mask window.");
        }

        return Vector[offset - Window.Start];
    }

    public Utf16UnitMask Union(Utf16UnitMask other) =>
        Combine(other, static (left, right) => left.Or(right));

    public Utf16UnitMask Intersect(Utf16UnitMask other) =>
        Combine(other, static (left, right) => left.And(right));

    public Utf16UnitMask SymmetricDifference(Utf16UnitMask other) =>
        Combine(other, static (left, right) => left.Xor(right));

    public Utf16UnitMask Subtract(Utf16UnitMask other) =>
        Combine(other, static (left, right) => left.AndNot(right));

    public Utf16UnitMask Complement() => new(Master, Window, Vector.Not());

    public Utf16UnitMask ShiftTowardHigherOrdinals(int distance) =>
        new(Master, Window, Vector.ShiftTowardHigherOrdinals(distance));

    public Utf16UnitMask ShiftTowardLowerOrdinals(int distance) =>
        new(Master, Window, Vector.ShiftTowardLowerOrdinals(distance));

    /// <summary>Runs an inclusive prefix-parity scan beginning at this window's start.</summary>
    public Utf16PrefixParityResult PrefixParity(bool carryIn = false)
    {
        var result = Vector.PrefixParity(carryIn);
        var states = new Utf16UnitMask(Master, Window, result.Vector);
        var continuation = Utf16PrefixParityContinuation.Create(Master, Window.End, result.CarryOut);
        return new Utf16PrefixParityResult(this, states, continuation);
    }

    /// <summary>Harvests complete selected topology atoms and retains partial atoms as residue.</summary>
    public Utf16UnitHarvestResult HarvestScalarSpans() => UnitMaskHarvest.Harvest(this);

    public bool Equals(Utf16UnitMask? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        return other is not null &&
               Window == other.Window &&
               Master.IsCompatibleWith(other.Master) &&
               Vector.Equals(other.Vector);
    }

    public override bool Equals(object? obj) => obj is Utf16UnitMask other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(Master.DocumentId, StringComparer.Ordinal);
        hash.Add(Master.Revision);
        hash.Add(Master.AddressUnit);
        hash.Add(Master.Length);
        hash.Add(Master.Fingerprint, StringComparer.Ordinal);
        hash.Add(Window);
        hash.Add(Vector);
        return hash.ToHashCode();
    }

    /// <summary>Enumerates selected absolute UTF-16 code-unit offsets in ascending order.</summary>
    public IEnumerator<int> GetEnumerator()
    {
        foreach (var localOrdinal in Vector)
        {
            yield return Window.Start + localOrdinal;
        }
    }

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    internal bool HasSameBasisAs(Utf16UnitMask? other) =>
        other is not null && Window == other.Window && Master.IsCompatibleWith(other.Master);

    internal void EnsureSameBasis(Utf16UnitMask other)
    {
        ArgumentNullException.ThrowIfNull(other);
        if (!HasSameBasisAs(other))
        {
            throw new InvalidOperationException(
                "UTF-16 unit masks require compatible masters and equal numeric windows.");
        }
    }

    private Utf16UnitMask Combine(
        Utf16UnitMask other,
        Func<BooleanVector, BooleanVector, BooleanVector> operation)
    {
        EnsureSameBasis(other);
        return new Utf16UnitMask(Master, Window, operation(Vector, other.Vector));
    }
}

/// <summary>
/// Material-stamped carry for the next contiguous UTF-16 mask chunk. The next chunk must start at
/// <see cref="NextOffset"/> on a compatible master.
/// </summary>
public sealed class Utf16PrefixParityContinuation
{
    private Utf16PrefixParityContinuation(TextMaster master, int nextOffset, bool carry)
    {
        Master = master;
        NextOffset = nextOffset;
        Carry = carry;
    }

    public TextMaster Master { get; }

    public int NextOffset { get; }

    public bool Carry { get; }

    public static Utf16PrefixParityContinuation Seed(
        TextMaster master,
        int nextOffset,
        bool carry = false)
    {
        ArgumentNullException.ThrowIfNull(master);
        if ((uint)nextOffset > (uint)master.Length)
        {
            throw new ArgumentOutOfRangeException(nameof(nextOffset));
        }

        return new Utf16PrefixParityContinuation(master, nextOffset, carry);
    }

    /// <summary>Scans the next exactly contiguous chunk and advances this typed continuation.</summary>
    public Utf16PrefixParityResult Continue(Utf16UnitMask next)
    {
        ArgumentNullException.ThrowIfNull(next);
        Master.EnsureCompatibleWith(next.Master);
        if (next.Window.Start != NextOffset)
        {
            throw new InvalidOperationException(
                $"Next mask must start at offset {NextOffset}; received {next.Window.Start}.");
        }

        var result = next.Vector.PrefixParity(Carry);
        var states = new Utf16UnitMask(next.Master, next.Window, result.Vector);
        var continuation = Create(Master, next.Window.End, result.CarryOut);
        return new Utf16PrefixParityResult(next, states, continuation);
    }

    internal static Utf16PrefixParityContinuation Create(TextMaster master, int nextOffset, bool carry) =>
        new(master, nextOffset, carry);
}

/// <summary>One scanned UTF-16 state mask together with its exact input and typed carry-out.</summary>
public sealed class Utf16PrefixParityResult
{
    internal Utf16PrefixParityResult(
        Utf16UnitMask input,
        Utf16UnitMask states,
        Utf16PrefixParityContinuation continuation)
    {
        Input = input;
        States = states;
        Continuation = continuation;
    }

    public Utf16UnitMask Input { get; }

    public Utf16UnitMask States { get; }

    public Utf16PrefixParityContinuation Continuation { get; }

    public bool CarryOut => Continuation.Carry;
}
