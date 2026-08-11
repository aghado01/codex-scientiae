using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>One tagged master slot in an <see cref="OriginBasis"/>.</summary>
public sealed class OriginSlot
{
    public OriginSlot(string tag, TextMaster master)
    {
        if (string.IsNullOrWhiteSpace(tag))
        {
            throw new ArgumentException("An origin-slot tag is required.", nameof(tag));
        }

        Tag = tag;
        Master = master ?? throw new ArgumentNullException(nameof(master));
    }

    /// <summary>The slot-local namespace, compared by exact ordinal equality.</summary>
    public string Tag { get; }

    /// <summary>The exact coordinate-space object carried by this slot.</summary>
    public TextMaster Master { get; }
}

/// <summary>
/// An exact, ordered namespace of tagged text-master slots. Basis identity is object identity:
/// separately created bases remain distinct even when all slots carry the same tags and compatible
/// masters.
/// </summary>
public sealed class OriginBasis : IReadOnlyList<OriginSlot>
{
    private readonly OriginSlot[] _slots;
    private readonly ReadOnlyCollection<OriginSlot> _slotView;

    private OriginBasis(OriginSlot[] slots)
    {
        _slots = slots;
        _slotView = Array.AsReadOnly(_slots);
    }

    public int Count => _slots.Length;

    public OriginSlot this[int index]
    {
        get
        {
            if ((uint)index >= (uint)_slots.Length)
            {
                throw new ArgumentOutOfRangeException(nameof(index));
            }

            return _slots[index];
        }
    }

    /// <summary>The immutable ordered slot sequence.</summary>
    public IReadOnlyList<OriginSlot> Slots => _slotView;

    public static OriginBasis Create(IEnumerable<OriginSlot> slots)
    {
        ArgumentNullException.ThrowIfNull(slots);

        var collected = new List<OriginSlot>();
        var tags = new HashSet<string>(StringComparer.Ordinal);
        foreach (var slot in slots)
        {
            if (slot is null)
            {
                throw new ArgumentException("Origin-basis slots must be non-null.", nameof(slots));
            }

            if (!tags.Add(slot.Tag))
            {
                throw new ArgumentException(
                    $"The origin-slot tag '{slot.Tag}' occurs more than once.",
                    nameof(slots));
            }

            collected.Add(slot);
        }

        return new OriginBasis(collected.ToArray());
    }

    public IEnumerator<OriginSlot> GetEnumerator() =>
        ((IEnumerable<OriginSlot>)_slots).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => _slots.GetEnumerator();

    internal void ValidateAtom(OriginAtom atom, string parameterName)
    {
        if ((uint)atom.SlotOrdinal >= (uint)_slots.Length)
        {
            throw new ArgumentException(
                $"Origin atom {atom} names an unavailable basis slot.",
                parameterName);
        }

        var topology = _slots[atom.SlotOrdinal].Master.Topology;
        if ((uint)atom.AtomOrdinal >= (uint)topology.AtomCount)
        {
            throw new ArgumentException(
                $"Origin atom {atom} names an unavailable text atom.",
                parameterName);
        }
    }

    internal IEnumerable<OriginAtom> EnumerateAtoms()
    {
        for (var slotOrdinal = 0; slotOrdinal < _slots.Length; slotOrdinal++)
        {
            var atomCount = _slots[slotOrdinal].Master.Topology.AtomCount;
            for (var atomOrdinal = 0; atomOrdinal < atomCount; atomOrdinal++)
            {
                yield return new OriginAtom(slotOrdinal, atomOrdinal);
            }
        }
    }
}
