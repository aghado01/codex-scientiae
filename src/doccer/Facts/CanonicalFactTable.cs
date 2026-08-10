using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;

namespace CodexSci.Doccer;

/// <summary>
/// The canonical semantic fact store (D43): one retained <see cref="TextMaster"/> and one row per
/// distinct <see cref="FactKey"/>. Construction snapshots the proposals, validates every geometry
/// argument on the retained master, collapses exact duplicate keys, and enumerates in the fixed
/// canonical order independent of proposal order. Table-local ordinals are not durable or
/// cross-table identifiers; F2 owns any persisted fact identity.
/// </summary>
public sealed class CanonicalFactTable : IReadOnlyList<FactKey>, IEquatable<CanonicalFactTable>
{
    private readonly FactKey[] _facts;

    private CanonicalFactTable(TextMaster master, FactKey[] facts)
    {
        Master = master;
        _facts = facts;
    }

    public TextMaster Master { get; }

    public int Count => _facts.Length;

    public bool IsEmpty => _facts.Length == 0;

    public FactKey this[int ordinal]
    {
        get
        {
            if ((uint)ordinal >= (uint)_facts.Length)
            {
                throw new ArgumentOutOfRangeException(nameof(ordinal));
            }

            return _facts[ordinal];
        }
    }

    /// <summary>
    /// Validates every proposal's geometry on the master (empty extents and zero-arity geometry
    /// are admitted) and collapses exact duplicate keys into one canonical row each.
    /// </summary>
    public static CanonicalFactTable Create(TextMaster master, IEnumerable<FactKey> proposals)
    {
        ArgumentNullException.ThrowIfNull(master);
        ArgumentNullException.ThrowIfNull(proposals);

        var collected = new List<FactKey>();
        foreach (var proposal in proposals)
        {
            if (proposal is null)
            {
                throw new ArgumentException("Fact proposals must be non-null.", nameof(proposals));
            }

            foreach (var extent in proposal.Geometry)
            {
                master.ValidateSpan(extent);
            }

            collected.Add(proposal);
        }

        collected.Sort(FactKey.CompareCanonical);
        var distinct = new List<FactKey>(collected.Count);
        foreach (var key in collected)
        {
            if (distinct.Count == 0 || FactKey.CompareCanonical(distinct[^1], key) != 0)
            {
                distinct.Add(key);
            }
        }

        return new CanonicalFactTable(master, distinct.ToArray());
    }

    /// <summary>Finds the table-local ordinal of a value-equal key, if one is retained.</summary>
    public bool TryGetOrdinal(FactKey key, out int ordinal)
    {
        ArgumentNullException.ThrowIfNull(key);
        var low = 0;
        var high = _facts.Length - 1;
        while (low <= high)
        {
            var middle = low + ((high - low) / 2);
            var comparison = FactKey.CompareCanonical(_facts[middle], key);
            if (comparison == 0)
            {
                ordinal = middle;
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

        ordinal = -1;
        return false;
    }

    /// <summary>
    /// Value equality: compatible masters and equal canonical key sequences. Exact-table evidence
    /// identity is <see cref="FactReference"/>'s stricter business, not this comparison's.
    /// </summary>
    public bool Equals(CanonicalFactTable? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        if (other is null ||
            !Master.IsCompatibleWith(other.Master) ||
            _facts.Length != other._facts.Length)
        {
            return false;
        }

        for (var i = 0; i < _facts.Length; i++)
        {
            if (!_facts[i].Equals(other._facts[i]))
            {
                return false;
            }
        }

        return true;
    }

    public override bool Equals(object? obj) => obj is CanonicalFactTable other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(Master.DocumentId, StringComparer.Ordinal);
        hash.Add(Master.Revision);
        hash.Add(Master.Fingerprint, StringComparer.Ordinal);
        foreach (var fact in _facts)
        {
            hash.Add(fact);
        }

        return hash.ToHashCode();
    }

    public IEnumerator<FactKey> GetEnumerator() =>
        ((IEnumerable<FactKey>)_facts).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}

/// <summary>
/// The exact fact-table evidence handle (D43): one exact <see cref="CanonicalFactTable"/>
/// reference plus one validated fact ordinal. This is K7's optional narrow justification seam and
/// requires no support graph. Equality is exact-table reference identity — two value-equal but
/// separately constructed tables do not make their references interchangeable — and
/// <see cref="Key"/> is the explicit projection back to semantic identity.
/// </summary>
public readonly struct FactReference : IEquatable<FactReference>
{
    private readonly CanonicalFactTable? _table;

    public FactReference(CanonicalFactTable table, int ordinal)
    {
        ArgumentNullException.ThrowIfNull(table);
        if ((uint)ordinal >= (uint)table.Count)
        {
            throw new ArgumentOutOfRangeException(
                nameof(ordinal),
                ordinal,
                "Ordinal is outside the fact table.");
        }

        _table = table;
        Ordinal = ordinal;
    }

    public CanonicalFactTable Table =>
        _table ?? throw new InvalidOperationException("Uninitialized fact reference.");

    public int Ordinal { get; }

    /// <summary>The referenced semantic fact key.</summary>
    public FactKey Key => Table[Ordinal];

    public bool Equals(FactReference other) =>
        ReferenceEquals(_table, other._table) && Ordinal == other.Ordinal;

    public override bool Equals(object? obj) => obj is FactReference other && Equals(other);

    public override int GetHashCode() =>
        HashCode.Combine(_table is null ? 0 : RuntimeHelpers.GetHashCode(_table), Ordinal);

    public static bool operator ==(FactReference left, FactReference right) => left.Equals(right);

    public static bool operator !=(FactReference left, FactReference right) => !left.Equals(right);

    public override string ToString() =>
        _table is null ? "uninitialized fact reference" : $"fact #{Ordinal} {_table[Ordinal]}";
}
