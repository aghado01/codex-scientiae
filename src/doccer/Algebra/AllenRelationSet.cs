using System;
using System.Collections;
using System.Collections.Generic;
using System.Numerics;

namespace CodexSci.Doccer;

/// <summary>
/// An immutable Boolean value over the thirteen Allen atoms. This is a qualitative geometry value:
/// it carries neither a master basis nor claim-occurrence identity, and it never includes empty
/// spans. Canonical qualitative composition is a separate K1b operation.
/// </summary>
public readonly struct AllenRelationSet :
    IReadOnlyCollection<AllenRelation>,
    IEquatable<AllenRelationSet>
{
    private const int RelationCount = 13;
    private const ushort AllBits = (1 << RelationCount) - 1;

    // Row-major in the frozen AllenRelation ordinal order. These 169 cells are the canonical
    // qualitative composition table, encoded as literal atom masks rather than derived at runtime.
    // The contract harness constructs its expected table independently from endpoint predicates on
    // the exhaustive six-boundary model.
    private static readonly ushort[] CanonicalAtomicComposition =
    {
        // Before
        0x0001, 0x0001, 0x0001, 0x0001, 0x0001, 0x0001, 0x0001, 0x0001, 0x0127, 0x0127, 0x0127, 0x0127, 0x1FFF,
        // Meets
        0x0001, 0x0001, 0x0001, 0x0001, 0x0001, 0x0002, 0x0002, 0x0002, 0x0124, 0x0124, 0x0124, 0x0248, 0x1C90,
        // Overlaps
        0x0001, 0x0001, 0x0007, 0x0007, 0x001F, 0x0004, 0x0004, 0x001C, 0x0124, 0x0124, 0x07FC, 0x0490, 0x1C90,
        // FinishedBy
        0x0001, 0x0002, 0x0004, 0x0008, 0x0010, 0x0004, 0x0008, 0x0010, 0x0124, 0x0248, 0x0490, 0x0490, 0x1C90,
        // Contains
        0x001F, 0x001C, 0x001C, 0x0010, 0x0010, 0x001C, 0x0010, 0x0010, 0x07FC, 0x0490, 0x0490, 0x0490, 0x1C90,
        // Starts
        0x0001, 0x0001, 0x0007, 0x0007, 0x001F, 0x0020, 0x0020, 0x00E0, 0x0100, 0x0100, 0x0700, 0x0800, 0x1000,
        // Equal
        0x0001, 0x0002, 0x0004, 0x0008, 0x0010, 0x0020, 0x0040, 0x0080, 0x0100, 0x0200, 0x0400, 0x0800, 0x1000,
        // StartedBy
        0x001F, 0x001C, 0x001C, 0x0010, 0x0010, 0x00E0, 0x0080, 0x0080, 0x0700, 0x0400, 0x0400, 0x0800, 0x1000,
        // During
        0x0001, 0x0001, 0x0127, 0x0127, 0x1FFF, 0x0100, 0x0100, 0x1F00, 0x0100, 0x0100, 0x1F00, 0x1000, 0x1000,
        // Finishes
        0x0001, 0x0002, 0x0124, 0x0248, 0x1C90, 0x0100, 0x0200, 0x1C00, 0x0100, 0x0200, 0x1C00, 0x1000, 0x1000,
        // OverlappedBy
        0x001F, 0x001C, 0x07FC, 0x0490, 0x1C90, 0x0700, 0x0400, 0x1C00, 0x0700, 0x0400, 0x1C00, 0x1000, 0x1000,
        // MetBy
        0x001F, 0x00E0, 0x0700, 0x0800, 0x1000, 0x0700, 0x0800, 0x1000, 0x0700, 0x0800, 0x1000, 0x1000, 0x1000,
        // After
        0x1FFF, 0x1F00, 0x1F00, 0x1000, 0x1000, 0x1F00, 0x1000, 0x1000, 0x1F00, 0x1000, 0x1000, 0x1000, 0x1000,
    };

    private readonly ushort _bits;

    private AllenRelationSet(ushort bits)
    {
        _bits = bits;
    }

    /// <summary>The empty relation union.</summary>
    public static AllenRelationSet None => default;

    /// <summary>The union of all thirteen Allen atoms.</summary>
    public static AllenRelationSet All => new(AllBits);

    /// <summary>The singleton containing geometric equality.</summary>
    public static AllenRelationSet Equal => Singleton(AllenRelation.Equal);

    public int Count => BitOperations.PopCount((uint)_bits);

    public bool IsEmpty => _bits == 0;

    public static AllenRelationSet Singleton(AllenRelation relation) => new(BitFor(relation));

    public static AllenRelationSet Create(IEnumerable<AllenRelation> relations)
    {
        ArgumentNullException.ThrowIfNull(relations);

        ushort bits = 0;
        foreach (var relation in relations)
        {
            bits |= BitFor(relation);
        }

        return new AllenRelationSet(bits);
    }

    public bool Contains(AllenRelation relation) => (_bits & BitFor(relation)) != 0;

    public bool IsSubsetOf(AllenRelationSet other) => (_bits & other._bits) == _bits;

    public AllenRelationSet Union(AllenRelationSet other) =>
        new((ushort)(_bits | other._bits));

    public AllenRelationSet Intersect(AllenRelationSet other) =>
        new((ushort)(_bits & other._bits));

    public AllenRelationSet Complement() => new((ushort)(AllBits ^ _bits));

    public AllenRelationSet Converse()
    {
        ushort converse = 0;
        for (var index = 0; index < RelationCount; index++)
        {
            var bit = (ushort)(1 << index);
            if ((_bits & bit) != 0)
            {
                converse |= BitFor(AllenAlgebra.Inverse((AllenRelation)index));
            }
        }

        return new AllenRelationSet(converse);
    }

    /// <summary>
    /// Canonical qualitative composition over Allen atom unions. This is the domain-level upper
    /// approximation across interval models, not exact composition over one finite text master.
    /// </summary>
    public AllenRelationSet AllenCompose(AllenRelationSet other)
    {
        ushort composition = 0;
        for (var left = 0; left < RelationCount; left++)
        {
            if ((_bits & (1 << left)) == 0)
            {
                continue;
            }

            for (var right = 0; right < RelationCount; right++)
            {
                if ((other._bits & (1 << right)) != 0)
                {
                    composition |= CanonicalAtomicComposition[(left * RelationCount) + right];
                }
            }
        }

        return new AllenRelationSet(composition);
    }

    public bool Equals(AllenRelationSet other) => _bits == other._bits;

    public override bool Equals(object? obj) => obj is AllenRelationSet other && Equals(other);

    public override int GetHashCode() => _bits.GetHashCode();

    public static bool operator ==(AllenRelationSet left, AllenRelationSet right) => left.Equals(right);

    public static bool operator !=(AllenRelationSet left, AllenRelationSet right) => !left.Equals(right);

    public IEnumerator<AllenRelation> GetEnumerator()
    {
        var bits = _bits;
        for (var index = 0; index < RelationCount; index++)
        {
            if ((bits & (1 << index)) != 0)
            {
                yield return (AllenRelation)index;
            }
        }
    }

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    private static ushort BitFor(AllenRelation relation)
    {
        var index = (int)relation;
        if ((uint)index >= RelationCount)
        {
            throw new ArgumentOutOfRangeException(
                nameof(relation),
                relation,
                "Undefined AllenRelation value.");
        }

        return (ushort)(1 << index);
    }
}
