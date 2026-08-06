using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>
/// A named stamp for one exact occurrence-resolution layer. The name is caller vocabulary; it is
/// not derived from claim kind, <see cref="SpanLevel"/>, or a measurement unit.
/// </summary>
public sealed class ResolutionLayerPolicy
{
    public ResolutionLayerPolicy(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A resolution-layer policy name is required.", nameof(name));
        }

        Name = name;
    }

    public string Name { get; }
}

/// <summary>
/// One exact occurrence population carrying a caller-named resolution-layer stamp. The view
/// deliberately imposes no packing, cover, partition, or laminar invariant.
/// </summary>
public sealed class ResolutionView
{
    private ResolutionView(
        ClaimSelection selection,
        TextSpan window,
        ResolutionLayerPolicy policy)
    {
        Selection = selection;
        Window = window;
        Policy = policy;
    }

    /// <summary>The exact occurrence population assigned to this resolution layer.</summary>
    public ClaimSelection Selection { get; }

    public SpanBatch Basis => Selection.Basis;

    public TextMaster Master => Basis.Master;

    /// <summary>The exact declared window containing every layer member.</summary>
    public TextSpan Window { get; }

    /// <summary>The exact caller-supplied layer policy object.</summary>
    public ResolutionLayerPolicy Policy { get; }

    public string Name => Policy.Name;

    public int Count => Selection.Count;

    public bool IsEmpty => Selection.IsEmpty;

    /// <summary>Tests membership in this exact layer; out-of-basis ordinals are undefined.</summary>
    public bool Contains(int ordinal) => Selection.Contains(ordinal);

    /// <summary>Projects this layer's members into an explicitly requested claim order.</summary>
    public IReadOnlyList<SpanRecord> Records(ClaimOrder order = ClaimOrder.Geometry) =>
        Selection.Records(order);

    /// <summary>
    /// Creates one named exact resolution layer. Every selected occurrence must be contained by
    /// <paramref name="window"/>; no relationship among the selected occurrences is implied.
    /// </summary>
    public static ResolutionView Create(
        ClaimSelection selection,
        TextSpan window,
        ResolutionLayerPolicy policy)
    {
        ArgumentNullException.ThrowIfNull(selection);
        ArgumentNullException.ThrowIfNull(policy);
        selection.Master.ValidateSpan(window);

        foreach (var ordinal in selection)
        {
            var span = selection.Basis[ordinal].Span;
            if (!window.Contains(span))
            {
                throw new ArgumentException(
                    $"Resolution member #{ordinal} span {span} lies outside layer window {window}.",
                    nameof(selection));
            }
        }

        return new ResolutionView(selection, window, policy);
    }
}

/// <summary>The validation contract attached to one explicit resolution map.</summary>
public enum ResolutionMapContract
{
    /// <summary>An explicit many-to-many relation; isolated layer members are allowed.</summary>
    Incidence = 0,

    /// <summary>Every fine member has one target and every coarse member receives a fine member.</summary>
    FunctionalAggregation = 1,

    /// <summary>Functional aggregation whose incident fine material exactly covers each coarse span.</summary>
    ExactAggregation = 2,
}

/// <summary>A named policy selecting one of the three distinct resolution-map contracts.</summary>
public sealed class ResolutionMapPolicy
{
    public ResolutionMapPolicy(string name, ResolutionMapContract contract)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A resolution-map policy name is required.", nameof(name));
        }

        if (!Enum.IsDefined(contract))
        {
            throw new ArgumentOutOfRangeException(nameof(contract), contract, "Undefined resolution-map contract.");
        }

        Name = name;
        Contract = contract;
    }

    public string Name { get; }

    public ResolutionMapContract Contract { get; }

    public static ResolutionMapPolicy Incidence(string name) =>
        new(name, ResolutionMapContract.Incidence);

    public static ResolutionMapPolicy FunctionalAggregation(string name) =>
        new(name, ResolutionMapContract.FunctionalAggregation);

    public static ResolutionMapPolicy ExactAggregation(string name) =>
        new(name, ResolutionMapContract.ExactAggregation);
}

/// <summary>
/// One explicit same-master resolution edge. Ordinals resolve against the containing map's exact
/// fine and coarse layer objects.
/// </summary>
public readonly record struct ResolutionEdge(int FineOrdinal, int CoarseOrdinal);

/// <summary>
/// An immutable explicit same-master incidence or aggregation relation between two named exact
/// resolution layers. Canonical edge order is lexicographic by fine then coarse ordinal.
/// </summary>
public sealed class ResolutionMap : IReadOnlyList<ResolutionEdge>
{
    private readonly ResolutionEdge[] _edges;
    private readonly ReadOnlyCollection<ResolutionEdge> _edgeView;

    private ResolutionMap(
        ResolutionView fine,
        ResolutionView coarse,
        ResolutionMapPolicy policy,
        ResolutionEdge[] edges)
    {
        Fine = fine;
        Coarse = coarse;
        Policy = policy;
        _edges = edges;
        _edgeView = Array.AsReadOnly(_edges);
    }

    /// <summary>The exact fine layer object whose occurrence ordinals form edge sources.</summary>
    public ResolutionView Fine { get; }

    /// <summary>The exact coarse layer object whose occurrence ordinals form edge targets.</summary>
    public ResolutionView Coarse { get; }

    /// <summary>The exact named map-policy object supplied at construction.</summary>
    public ResolutionMapPolicy Policy { get; }

    public ResolutionMapContract Contract => Policy.Contract;

    /// <summary>Explicit edges in canonical fine-ordinal, coarse-ordinal order.</summary>
    public IReadOnlyList<ResolutionEdge> Edges => _edgeView;

    public int Count => _edges.Length;

    public bool IsEmpty => _edges.Length == 0;

    public ResolutionEdge this[int index] => _edges[index];

    /// <summary>
    /// Creates one explicit resolution relation. Geometry validates supplied edges but never
    /// creates them: every endpoint must be a layer member and each fine span must be contained by
    /// its stated coarse span.
    /// </summary>
    public static ResolutionMap Create(
        ResolutionView fine,
        ResolutionView coarse,
        ResolutionMapPolicy policy,
        IEnumerable<ResolutionEdge> edges)
    {
        ArgumentNullException.ThrowIfNull(fine);
        ArgumentNullException.ThrowIfNull(coarse);
        ArgumentNullException.ThrowIfNull(policy);
        ArgumentNullException.ThrowIfNull(edges);

        fine.Master.EnsureCompatibleWith(coarse.Master);
        if (fine.Window != coarse.Window)
        {
            throw new InvalidOperationException(
                $"Resolution layers declare different windows: {fine.Window} and {coarse.Window}.");
        }

        var ordered = new SortedSet<ResolutionEdge>(ResolutionEdgeComparer.Instance);
        foreach (var edge in edges)
        {
            EnsureLayerMember(fine, edge.FineOrdinal, "fine", nameof(edges));
            EnsureLayerMember(coarse, edge.CoarseOrdinal, "coarse", nameof(edges));

            var fineSpan = fine.Basis[edge.FineOrdinal].Span;
            var coarseSpan = coarse.Basis[edge.CoarseOrdinal].Span;
            if (!coarseSpan.Contains(fineSpan))
            {
                throw new ArgumentException(
                    $"Fine member #{edge.FineOrdinal} span {fineSpan} is not contained by " +
                    $"coarse member #{edge.CoarseOrdinal} span {coarseSpan}.",
                    nameof(edges));
            }

            if (!ordered.Add(edge))
            {
                throw new ArgumentException(
                    $"Resolution edge ({edge.FineOrdinal}, {edge.CoarseOrdinal}) is duplicated.",
                    nameof(edges));
            }
        }

        var retainedEdges = new ResolutionEdge[ordered.Count];
        ordered.CopyTo(retainedEdges);
        ValidateContract(fine, coarse, policy.Contract, retainedEdges, nameof(edges));
        return new ResolutionMap(fine, coarse, policy, retainedEdges);
    }

    /// <summary>Tests explicit edge membership; both ordinals must belong to their exact layers.</summary>
    public bool ContainsEdge(int fineOrdinal, int coarseOrdinal)
    {
        EnsureLayerMember(Fine, fineOrdinal, "fine", nameof(fineOrdinal));
        EnsureLayerMember(Coarse, coarseOrdinal, "coarse", nameof(coarseOrdinal));

        var target = new ResolutionEdge(fineOrdinal, coarseOrdinal);
        return Array.BinarySearch(_edges, target, ResolutionEdgeComparer.Instance) >= 0;
    }

    /// <summary>An alias for <see cref="ContainsEdge"/>.</summary>
    public bool Contains(int fineOrdinal, int coarseOrdinal) =>
        ContainsEdge(fineOrdinal, coarseOrdinal);

    /// <summary>Returns every explicit coarse target of one exact fine-layer member.</summary>
    public ClaimSelection CoarseTargets(int fineOrdinal)
    {
        EnsureLayerMember(Fine, fineOrdinal, "fine", nameof(fineOrdinal));
        var ordinals = new List<int>();
        foreach (var edge in _edges)
        {
            if (edge.FineOrdinal == fineOrdinal)
            {
                ordinals.Add(edge.CoarseOrdinal);
            }
        }

        return ClaimSelection.Create(Coarse.Basis, ordinals);
    }

    /// <summary>Returns every explicit fine member incident to one exact coarse-layer member.</summary>
    public ClaimSelection FineMembers(int coarseOrdinal)
    {
        EnsureLayerMember(Coarse, coarseOrdinal, "coarse", nameof(coarseOrdinal));
        var ordinals = new List<int>();
        foreach (var edge in _edges)
        {
            if (edge.CoarseOrdinal == coarseOrdinal)
            {
                ordinals.Add(edge.FineOrdinal);
            }
        }

        return ClaimSelection.Create(Fine.Basis, ordinals);
    }

    /// <summary>The fine-layer members occurring in at least one explicit edge.</summary>
    public ClaimSelection ProjectFine()
    {
        var ordinals = new int[_edges.Length];
        for (var index = 0; index < _edges.Length; index++)
        {
            ordinals[index] = _edges[index].FineOrdinal;
        }

        return ClaimSelection.Create(Fine.Basis, ordinals);
    }

    /// <summary>The coarse-layer members occurring in at least one explicit edge.</summary>
    public ClaimSelection ProjectCoarse()
    {
        var ordinals = new int[_edges.Length];
        for (var index = 0; index < _edges.Length; index++)
        {
            ordinals[index] = _edges[index].CoarseOrdinal;
        }

        return ClaimSelection.Create(Coarse.Basis, ordinals);
    }

    public IEnumerator<ResolutionEdge> GetEnumerator() =>
        ((IEnumerable<ResolutionEdge>)_edges).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    private static void ValidateContract(
        ResolutionView fine,
        ResolutionView coarse,
        ResolutionMapContract contract,
        IReadOnlyList<ResolutionEdge> edges,
        string parameterName)
    {
        if (contract == ResolutionMapContract.Incidence)
        {
            return;
        }

        var fineDegrees = new int[fine.Basis.Count];
        var coarseDegrees = new int[coarse.Basis.Count];
        foreach (var edge in edges)
        {
            fineDegrees[edge.FineOrdinal]++;
            coarseDegrees[edge.CoarseOrdinal]++;
        }

        foreach (var ordinal in fine.Selection)
        {
            if (fineDegrees[ordinal] != 1)
            {
                throw new ArgumentException(
                    $"Fine member #{ordinal} has {fineDegrees[ordinal]} coarse targets; " +
                    "functional aggregation requires exactly one.",
                    parameterName);
            }
        }

        foreach (var ordinal in coarse.Selection)
        {
            if (coarseDegrees[ordinal] == 0)
            {
                throw new ArgumentException(
                    $"Coarse member #{ordinal} receives no fine member; functional aggregation " +
                    "requires every coarse member to receive at least one.",
                    parameterName);
            }
        }

        if (contract != ResolutionMapContract.ExactAggregation)
        {
            return;
        }

        foreach (var coarseOrdinal in coarse.Selection)
        {
            var fineMaterial = new List<TextSpan>();
            foreach (var edge in edges)
            {
                if (edge.CoarseOrdinal == coarseOrdinal)
                {
                    fineMaterial.Add(fine.Basis[edge.FineOrdinal].Span);
                }
            }

            var actual = SpanSet.Create(fine.Master, fineMaterial);
            var expected = SpanSet.Create(
                coarse.Master,
                new[] { coarse.Basis[coarseOrdinal].Span });
            if (!actual.Equals(expected))
            {
                throw new ArgumentException(
                    $"Fine material incident to coarse member #{coarseOrdinal} does not exactly " +
                    $"cover coarse span {coarse.Basis[coarseOrdinal].Span}.",
                    parameterName);
            }
        }
    }

    private static void EnsureLayerMember(
        ResolutionView layer,
        int ordinal,
        string layerName,
        string parameterName)
    {
        if ((uint)ordinal >= (uint)layer.Basis.Count)
        {
            throw new ArgumentOutOfRangeException(
                parameterName,
                ordinal,
                $"Ordinal #{ordinal} is outside the {layerName} layer basis.");
        }

        if (!layer.Selection.Contains(ordinal))
        {
            throw new ArgumentException(
                $"Ordinal #{ordinal} does not belong to the exact {layerName} resolution layer.",
                parameterName);
        }
    }

    private sealed class ResolutionEdgeComparer : IComparer<ResolutionEdge>
    {
        public static ResolutionEdgeComparer Instance { get; } = new();

        public int Compare(ResolutionEdge left, ResolutionEdge right)
        {
            var comparison = left.FineOrdinal.CompareTo(right.FineOrdinal);
            return comparison != 0
                ? comparison
                : left.CoarseOrdinal.CompareTo(right.CoarseOrdinal);
        }
    }
}
