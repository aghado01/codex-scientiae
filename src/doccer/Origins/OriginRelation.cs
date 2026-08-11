using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Runtime.CompilerServices;

namespace CodexSci.Doccer;

/// <summary>A basis-relative text atom coordinate.</summary>
public readonly record struct OriginAtom
{
    public OriginAtom(int slotOrdinal, int atomOrdinal)
    {
        if (slotOrdinal < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(slotOrdinal));
        }

        if (atomOrdinal < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(atomOrdinal));
        }

        SlotOrdinal = slotOrdinal;
        AtomOrdinal = atomOrdinal;
    }

    public int SlotOrdinal { get; }

    public int AtomOrdinal { get; }

    public override string ToString() => $"{SlotOrdinal}:{AtomOrdinal}";
}

/// <summary>One directed output-atom to source-atom origin assertion.</summary>
public readonly record struct OriginEdge(OriginAtom Output, OriginAtom Source);

/// <summary>
/// A finite, exact-basis-stamped relation from output material to source material. Edges are
/// canonicalized by output slot, output atom, source slot, then source atom.
/// </summary>
public sealed class OriginRelation : IReadOnlyList<OriginEdge>, IEquatable<OriginRelation>
{
    private readonly OriginEdge[] _edges;

    private OriginRelation(
        OriginBasis outputBasis,
        OriginBasis sourceBasis,
        OriginEdge[] edges)
    {
        OutputBasis = outputBasis;
        SourceBasis = sourceBasis;
        _edges = edges;
    }

    public OriginBasis OutputBasis { get; }

    public OriginBasis SourceBasis { get; }

    public int Count => _edges.Length;

    public bool IsEmpty => _edges.Length == 0;

    public OriginEdge this[int index]
    {
        get
        {
            if ((uint)index >= (uint)_edges.Length)
            {
                throw new ArgumentOutOfRangeException(nameof(index));
            }

            return _edges[index];
        }
    }

    /// <summary>True when every output atom names at most one source atom.</summary>
    public bool IsFunctional
    {
        get
        {
            for (var i = 1; i < _edges.Length; i++)
            {
                if (_edges[i - 1].Output == _edges[i].Output)
                {
                    return false;
                }
            }

            return true;
        }
    }

    /// <summary>True when every atom in the output basis names at least one source atom.</summary>
    public bool IsTotal
    {
        get
        {
            var present = new HashSet<OriginAtom>();
            foreach (var edge in _edges)
            {
                present.Add(edge.Output);
            }

            foreach (var atom in OutputBasis.EnumerateAtoms())
            {
                if (!present.Contains(atom))
                {
                    return false;
                }
            }

            return true;
        }
    }

    /// <summary>True when every source atom is named by at most one output atom.</summary>
    public bool IsInjective
    {
        get
        {
            var outputsBySource = new Dictionary<OriginAtom, OriginAtom>();
            foreach (var edge in _edges)
            {
                if (outputsBySource.TryGetValue(edge.Source, out var output) &&
                    output != edge.Output)
                {
                    return false;
                }

                outputsBySource[edge.Source] = edge.Output;
            }

            return true;
        }
    }

    public static OriginRelation Create(
        OriginBasis outputBasis,
        OriginBasis sourceBasis,
        IEnumerable<OriginEdge> edges)
    {
        ArgumentNullException.ThrowIfNull(outputBasis);
        ArgumentNullException.ThrowIfNull(sourceBasis);
        ArgumentNullException.ThrowIfNull(edges);

        var canonical = new List<OriginEdge>();
        foreach (var edge in edges)
        {
            outputBasis.ValidateAtom(edge.Output, nameof(edges));
            sourceBasis.ValidateAtom(edge.Source, nameof(edges));
            canonical.Add(edge);
        }

        canonical.Sort(CompareCanonical);
        if (canonical.Count > 1)
        {
            var write = 1;
            for (var read = 1; read < canonical.Count; read++)
            {
                if (canonical[read] != canonical[write - 1])
                {
                    canonical[write++] = canonical[read];
                }
            }

            if (write < canonical.Count)
            {
                canonical.RemoveRange(write, canonical.Count - write);
            }
        }

        return new OriginRelation(outputBasis, sourceBasis, canonical.ToArray());
    }

    /// <summary>The empty relation carrying the supplied exact output and source basis stamps.</summary>
    public static OriginRelation None(OriginBasis outputBasis, OriginBasis sourceBasis) =>
        Create(outputBasis, sourceBasis, Array.Empty<OriginEdge>());

    /// <summary>The complete atom diagonal over one exact basis.</summary>
    public static OriginRelation Identity(OriginBasis basis)
    {
        ArgumentNullException.ThrowIfNull(basis);
        var edges = new List<OriginEdge>();
        foreach (var atom in basis.EnumerateAtoms())
        {
            edges.Add(new OriginEdge(atom, atom));
        }

        return new OriginRelation(basis, basis, edges.ToArray());
    }

    /// <summary>
    /// Relational composition in origin direction. This relation's exact source basis must be the
    /// next relation's exact output basis; compatible or value-identical substitutes are refused.
    /// </summary>
    public OriginRelation ComposeOrigins(OriginRelation next)
    {
        ArgumentNullException.ThrowIfNull(next);
        if (!ReferenceEquals(SourceBasis, next.OutputBasis))
        {
            throw new InvalidOperationException(
                "Origin composition requires the exact shared middle basis object.");
        }

        var nextSourcesByOutput = new Dictionary<OriginAtom, List<OriginAtom>>();
        foreach (var edge in next._edges)
        {
            if (!nextSourcesByOutput.TryGetValue(edge.Output, out var sources))
            {
                sources = new List<OriginAtom>();
                nextSourcesByOutput.Add(edge.Output, sources);
            }

            sources.Add(edge.Source);
        }

        var composed = new List<OriginEdge>();
        foreach (var edge in _edges)
        {
            if (!nextSourcesByOutput.TryGetValue(edge.Source, out var sources))
            {
                continue;
            }

            foreach (var source in sources)
            {
                composed.Add(new OriginEdge(edge.Output, source));
            }
        }

        return Create(OutputBasis, next.SourceBasis, composed);
    }

    /// <summary>
    /// Projects one scalar-bounded output span through this relation, retaining one normalized
    /// source region set per source-basis slot.
    /// </summary>
    public OriginProjection ProjectSources(int outputSlotOrdinal, TextSpan outputSpan)
    {
        if ((uint)outputSlotOrdinal >= (uint)OutputBasis.Count)
        {
            throw new ArgumentOutOfRangeException(nameof(outputSlotOrdinal));
        }

        var outputMaster = OutputBasis[outputSlotOrdinal].Master;
        outputMaster.ValidateSpan(outputSpan);

        var selectedAtoms = new HashSet<int>();
        if (!outputSpan.IsEmpty)
        {
            var atoms = outputMaster.Topology.Atoms;
            for (var atomOrdinal = 0; atomOrdinal < atoms.Count; atomOrdinal++)
            {
                if (outputSpan.Contains(atoms[atomOrdinal].Span))
                {
                    selectedAtoms.Add(atomOrdinal);
                }
            }
        }

        var spansBySourceSlot = new List<TextSpan>[SourceBasis.Count];
        for (var slotOrdinal = 0; slotOrdinal < spansBySourceSlot.Length; slotOrdinal++)
        {
            spansBySourceSlot[slotOrdinal] = new List<TextSpan>();
        }

        foreach (var edge in _edges)
        {
            if (edge.Output.SlotOrdinal != outputSlotOrdinal ||
                !selectedAtoms.Contains(edge.Output.AtomOrdinal))
            {
                continue;
            }

            var sourceSlot = edge.Source.SlotOrdinal;
            spansBySourceSlot[sourceSlot].Add(
                SourceBasis[sourceSlot].Master.Topology.Atoms[edge.Source.AtomOrdinal].Span);
        }

        var regions = new SpanSet[SourceBasis.Count];
        for (var slotOrdinal = 0; slotOrdinal < regions.Length; slotOrdinal++)
        {
            regions[slotOrdinal] = SpanSet.Create(
                SourceBasis[slotOrdinal].Master,
                spansBySourceSlot[slotOrdinal]);
        }

        return new OriginProjection(this, outputSlotOrdinal, outputSpan, regions);
    }

    /// <summary>
    /// Embeds a text slice as child-atom to parent-atom origin. Both bases must be singletons and
    /// must carry the slice's exact child and parent master objects respectively.
    /// </summary>
    public static OriginRelation FromTextSlice(
        TextSlice slice,
        OriginBasis childBasis,
        OriginBasis parentBasis)
    {
        ArgumentNullException.ThrowIfNull(slice);
        ArgumentNullException.ThrowIfNull(childBasis);
        ArgumentNullException.ThrowIfNull(parentBasis);

        if (childBasis.Count != 1 || parentBasis.Count != 1)
        {
            throw new InvalidOperationException(
                "Text-slice origin embedding requires singleton child and parent bases.");
        }

        if (!ReferenceEquals(childBasis[0].Master, slice.Child) ||
            !ReferenceEquals(parentBasis[0].Master, slice.Parent))
        {
            throw new InvalidOperationException(
                "Text-slice origin embedding requires the slice's exact child and parent masters.");
        }

        var parentAtomsBySpan = new Dictionary<TextSpan, int>();
        var parentAtoms = slice.Parent.Topology.Atoms;
        for (var atomOrdinal = 0; atomOrdinal < parentAtoms.Count; atomOrdinal++)
        {
            parentAtomsBySpan.Add(parentAtoms[atomOrdinal].Span, atomOrdinal);
        }

        var edges = new List<OriginEdge>();
        var childAtoms = slice.Child.Topology.Atoms;
        for (var childAtomOrdinal = 0; childAtomOrdinal < childAtoms.Count; childAtomOrdinal++)
        {
            var parentSpan = slice.ToParent(childAtoms[childAtomOrdinal].Span);
            if (!parentAtomsBySpan.TryGetValue(parentSpan, out var parentAtomOrdinal))
            {
                throw new InvalidOperationException(
                    "A slice child atom did not correspond to one exact parent atom.");
            }

            edges.Add(new OriginEdge(
                new OriginAtom(0, childAtomOrdinal),
                new OriginAtom(0, parentAtomOrdinal)));
        }

        return new OriginRelation(childBasis, parentBasis, edges.ToArray());
    }

    public bool Equals(OriginRelation? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        if (other is null ||
            !ReferenceEquals(OutputBasis, other.OutputBasis) ||
            !ReferenceEquals(SourceBasis, other.SourceBasis) ||
            _edges.Length != other._edges.Length)
        {
            return false;
        }

        return _edges.AsSpan().SequenceEqual(other._edges);
    }

    public override bool Equals(object? obj) => obj is OriginRelation other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(RuntimeHelpers.GetHashCode(OutputBasis));
        hash.Add(RuntimeHelpers.GetHashCode(SourceBasis));
        foreach (var edge in _edges)
        {
            hash.Add(edge);
        }

        return hash.ToHashCode();
    }

    public IEnumerator<OriginEdge> GetEnumerator() =>
        ((IEnumerable<OriginEdge>)_edges).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => _edges.GetEnumerator();

    private static int CompareCanonical(OriginEdge left, OriginEdge right)
    {
        var comparison = left.Output.SlotOrdinal.CompareTo(right.Output.SlotOrdinal);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = left.Output.AtomOrdinal.CompareTo(right.Output.AtomOrdinal);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = left.Source.SlotOrdinal.CompareTo(right.Source.SlotOrdinal);
        return comparison != 0
            ? comparison
            : left.Source.AtomOrdinal.CompareTo(right.Source.AtomOrdinal);
    }
}

/// <summary>
/// The exact-relation-stamped source image of one output span. Entries retain source-basis slot
/// order, including separate entries for slots carrying compatible or identical masters.
/// </summary>
public sealed class OriginProjection : IReadOnlyList<SpanSet>
{
    private readonly SpanSet[] _sourceRegions;
    private readonly ReadOnlyCollection<SpanSet> _sourceRegionView;

    internal OriginProjection(
        OriginRelation relation,
        int outputSlotOrdinal,
        TextSpan outputSpan,
        SpanSet[] sourceRegions)
    {
        Relation = relation;
        OutputSlotOrdinal = outputSlotOrdinal;
        OutputSpan = outputSpan;
        _sourceRegions = sourceRegions;
        _sourceRegionView = Array.AsReadOnly(_sourceRegions);
    }

    public OriginRelation Relation { get; }

    public int OutputSlotOrdinal { get; }

    public TextSpan OutputSpan { get; }

    public IReadOnlyList<SpanSet> SourceRegions => _sourceRegionView;

    public int Count => _sourceRegions.Length;

    public SpanSet this[int index]
    {
        get
        {
            if ((uint)index >= (uint)_sourceRegions.Length)
            {
                throw new ArgumentOutOfRangeException(nameof(index));
            }

            return _sourceRegions[index];
        }
    }

    public IEnumerator<SpanSet> GetEnumerator() =>
        ((IEnumerable<SpanSet>)_sourceRegions).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => _sourceRegions.GetEnumerator();
}
