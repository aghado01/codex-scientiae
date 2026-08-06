using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>The construction semantics carried by an exact hierarchy result.</summary>
public enum HierarchyConstruction
{
    /// <summary>Every edge was supplied explicitly by the caller.</summary>
    ExplicitEdges = 0,

    /// <summary>Edges are immediate nearest-strict-container projections from a laminar family.</summary>
    NearestStrictContainer = 1,
}

/// <summary>The occurrence tie rule, if any, used while constructing hierarchy edges.</summary>
public enum HierarchyTieBreak
{
    /// <summary>Explicit edges require no occurrence tie resolution.</summary>
    None = 0,

    /// <summary>Choose the lowest ordinal when one geometry has several occurrences.</summary>
    LowestOrdinal = 1,
}

/// <summary>
/// A required named hierarchy policy. Construction and tie behavior are explicit stamps rather
/// than implications recovered from the resulting edge geometry.
/// </summary>
public sealed class HierarchyPolicy
{
    private HierarchyPolicy(
        string name,
        HierarchyConstruction construction,
        HierarchyTieBreak tieBreak)
    {
        Name = name;
        Construction = construction;
        TieBreak = tieBreak;
    }

    public string Name { get; }

    public HierarchyConstruction Construction { get; }

    public HierarchyTieBreak TieBreak { get; }

    /// <summary>A policy for validating caller-supplied edges without geometric inference.</summary>
    public static HierarchyPolicy Explicit(string name) =>
        Create(name, HierarchyConstruction.ExplicitEdges, HierarchyTieBreak.None);

    /// <summary>
    /// The one containment-derived policy: immediate strict containers, resolving equal parent
    /// geometry to its lowest selected occurrence ordinal.
    /// </summary>
    public static HierarchyPolicy NearestContainer(string name) =>
        Create(
            name,
            HierarchyConstruction.NearestStrictContainer,
            HierarchyTieBreak.LowestOrdinal);

    private static HierarchyPolicy Create(
        string name,
        HierarchyConstruction construction,
        HierarchyTieBreak tieBreak)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A hierarchy policy name is required.", nameof(name));
        }

        return new HierarchyPolicy(name, construction, tieBreak);
    }
}

/// <summary>
/// One explicitly evidenced child-to-parent occurrence edge. Ordinals resolve against the exact
/// node selection retained by the containing <see cref="HierarchyView"/>.
/// </summary>
public readonly record struct HierarchyEdge(
    int ChildOrdinal,
    int ParentOrdinal,
    string Derivation);

/// <summary>
/// An immutable exact-selection hierarchy DAG. Edges express direct caller-supplied or projected
/// parenthood; the view neither infers containment edges nor closes or reduces the relation.
/// </summary>
public sealed class HierarchyView : IReadOnlyList<HierarchyEdge>
{
    private readonly HierarchyEdge[] _edges;
    private readonly ReadOnlyCollection<HierarchyEdge> _edgeView;

    private HierarchyView(
        ClaimSelection nodes,
        TextSpan window,
        HierarchyPolicy policy,
        HierarchyEdge[] edges,
        LaminarView? sourceLaminarFamily)
    {
        Nodes = nodes;
        Window = window;
        Policy = policy;
        _edges = edges;
        _edgeView = Array.AsReadOnly(_edges);
        SourceLaminarFamily = sourceLaminarFamily;
        Roots = SelectNodesWithoutParents(nodes, edges);
        Leaves = SelectNodesWithoutChildren(nodes, edges);
    }

    /// <summary>The exact occurrence population whose ordinals are hierarchy nodes.</summary>
    public ClaimSelection Nodes { get; }

    public SpanBatch Basis => Nodes.Basis;

    public TextMaster Master => Basis.Master;

    public TextSpan Window { get; }

    /// <summary>The exact named policy object used to construct this view.</summary>
    public HierarchyPolicy Policy { get; }

    /// <summary>
    /// The exact laminar family projected by <see cref="LaminarHierarchy.NearestContainers"/>, or
    /// <see langword="null"/> for an explicitly supplied general hierarchy.
    /// </summary>
    public LaminarView? SourceLaminarFamily { get; }

    /// <summary>Direct edges in canonical child-ordinal, parent-ordinal order.</summary>
    public IReadOnlyList<HierarchyEdge> Edges => _edgeView;

    /// <summary>Selected nodes having no direct parent edge.</summary>
    public ClaimSelection Roots { get; }

    /// <summary>Selected nodes having no direct child edge.</summary>
    public ClaimSelection Leaves { get; }

    public int Count => _edges.Length;

    public bool IsEmpty => _edges.Length == 0;

    public HierarchyEdge this[int index] => _edges[index];

    /// <summary>
    /// Validates an explicitly supplied DAG. Parenthood is not inferred from node geometry and
    /// disconnected nodes, multiple parents, and transitive edges are retained.
    /// </summary>
    public static HierarchyView Create(
        ClaimSelection nodes,
        TextSpan window,
        HierarchyPolicy policy,
        IEnumerable<HierarchyEdge> edges)
    {
        ArgumentNullException.ThrowIfNull(policy);
        if (policy.Construction != HierarchyConstruction.ExplicitEdges ||
            policy.TieBreak != HierarchyTieBreak.None)
        {
            throw new ArgumentException(
                "Explicit hierarchy construction requires an Explicit hierarchy policy.",
                nameof(policy));
        }

        return CreateCore(nodes, window, policy, edges, sourceLaminarFamily: null);
    }

    /// <summary>Tests direct edge membership; no transitive closure is implied.</summary>
    public bool ContainsEdge(int childOrdinal, int parentOrdinal)
    {
        EnsureSelectedNode(childOrdinal, nameof(childOrdinal));
        EnsureSelectedNode(parentOrdinal, nameof(parentOrdinal));

        var low = 0;
        var high = _edges.Length - 1;
        while (low <= high)
        {
            var middle = low + ((high - low) / 2);
            var candidate = _edges[middle];
            var comparison = Compare(candidate, childOrdinal, parentOrdinal);
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

    /// <summary>Returns this node's direct parents in ascending ordinal order.</summary>
    public IReadOnlyList<int> ParentsOf(int childOrdinal)
    {
        EnsureSelectedNode(childOrdinal, nameof(childOrdinal));
        var parents = new List<int>();
        foreach (var edge in _edges)
        {
            if (edge.ChildOrdinal == childOrdinal)
            {
                parents.Add(edge.ParentOrdinal);
            }
        }

        return parents.AsReadOnly();
    }

    /// <summary>Returns this node's direct children in ascending ordinal order.</summary>
    public IReadOnlyList<int> ChildrenOf(int parentOrdinal)
    {
        EnsureSelectedNode(parentOrdinal, nameof(parentOrdinal));
        var children = new List<int>();
        foreach (var edge in _edges)
        {
            if (edge.ParentOrdinal == parentOrdinal)
            {
                children.Add(edge.ChildOrdinal);
            }
        }

        // Edge order is child-major, so matching children are already ascending and unique.
        return children.AsReadOnly();
    }

    public IEnumerator<HierarchyEdge> GetEnumerator() =>
        ((IEnumerable<HierarchyEdge>)_edges).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    internal static HierarchyView CreateNearestContainerProjection(
        LaminarView family,
        HierarchyPolicy policy,
        IEnumerable<HierarchyEdge> edges)
    {
        ArgumentNullException.ThrowIfNull(family);
        ArgumentNullException.ThrowIfNull(policy);
        if (policy.Construction != HierarchyConstruction.NearestStrictContainer ||
            policy.TieBreak != HierarchyTieBreak.LowestOrdinal)
        {
            throw new ArgumentException(
                "Nearest-container projection requires a NearestContainer hierarchy policy.",
                nameof(policy));
        }

        return CreateCore(
            family.Selection,
            family.Window,
            policy,
            edges,
            family);
    }

    private static HierarchyView CreateCore(
        ClaimSelection nodes,
        TextSpan window,
        HierarchyPolicy policy,
        IEnumerable<HierarchyEdge> edges,
        LaminarView? sourceLaminarFamily)
    {
        ArgumentNullException.ThrowIfNull(nodes);
        ArgumentNullException.ThrowIfNull(policy);
        ArgumentNullException.ThrowIfNull(edges);
        nodes.Master.ValidateSpan(window);

        foreach (var ordinal in nodes)
        {
            if (!window.Contains(nodes.Basis[ordinal].Span))
            {
                throw new ArgumentException(
                    $"Hierarchy node #{ordinal} extent {nodes.Basis[ordinal].Span} lies outside declared window {window}.",
                    nameof(nodes));
            }
        }

        if (sourceLaminarFamily is not null &&
            (!ReferenceEquals(sourceLaminarFamily.Selection, nodes) ||
             sourceLaminarFamily.Window != window))
        {
            throw new InvalidOperationException(
                "A projected hierarchy must retain its exact laminar-family selection and window.");
        }

        var collected = new List<HierarchyEdge>();
        var seen = new HashSet<(int ChildOrdinal, int ParentOrdinal)>();
        foreach (var edge in edges)
        {
            EnsureSelectedNode(nodes, edge.ChildOrdinal, nameof(edges));
            EnsureSelectedNode(nodes, edge.ParentOrdinal, nameof(edges));
            if (edge.ChildOrdinal == edge.ParentOrdinal)
            {
                throw new ArgumentException(
                    $"Hierarchy self edge #{edge.ChildOrdinal} -> #{edge.ParentOrdinal} is invalid.",
                    nameof(edges));
            }

            if (string.IsNullOrWhiteSpace(edge.Derivation))
            {
                throw new ArgumentException(
                    $"Hierarchy edge #{edge.ChildOrdinal} -> #{edge.ParentOrdinal} requires a derivation label.",
                    nameof(edges));
            }

            if (!seen.Add((edge.ChildOrdinal, edge.ParentOrdinal)))
            {
                throw new ArgumentException(
                    $"Duplicate hierarchy edge #{edge.ChildOrdinal} -> #{edge.ParentOrdinal} is invalid.",
                    nameof(edges));
            }

            collected.Add(edge);
        }

        collected.Sort(static (left, right) =>
        {
            var comparison = left.ChildOrdinal.CompareTo(right.ChildOrdinal);
            return comparison != 0
                ? comparison
                : left.ParentOrdinal.CompareTo(right.ParentOrdinal);
        });

        var frozen = collected.ToArray();
        EnsureAcyclic(nodes, frozen);
        return new HierarchyView(nodes, window, policy, frozen, sourceLaminarFamily);
    }

    private void EnsureSelectedNode(int ordinal, string parameterName) =>
        EnsureSelectedNode(Nodes, ordinal, parameterName);

    private static void EnsureSelectedNode(
        ClaimSelection nodes,
        int ordinal,
        string parameterName)
    {
        if ((uint)ordinal >= (uint)nodes.Basis.Count)
        {
            throw new ArgumentOutOfRangeException(
                parameterName,
                ordinal,
                "Ordinal is outside the hierarchy basis.");
        }

        if (!nodes.Contains(ordinal))
        {
            throw new ArgumentException(
                $"Ordinal #{ordinal} is not in the hierarchy's exact node selection.",
                parameterName);
        }
    }

    private static void EnsureAcyclic(ClaimSelection nodes, IReadOnlyList<HierarchyEdge> edges)
    {
        var outgoing = new List<int>?[nodes.Basis.Count];
        var incomingCount = new int[nodes.Basis.Count];
        foreach (var edge in edges)
        {
            outgoing[edge.ChildOrdinal] ??= new List<int>();
            outgoing[edge.ChildOrdinal]!.Add(edge.ParentOrdinal);
            incomingCount[edge.ParentOrdinal]++;
        }

        var ready = new Queue<int>();
        foreach (var ordinal in nodes)
        {
            if (incomingCount[ordinal] == 0)
            {
                ready.Enqueue(ordinal);
            }
        }

        var visited = 0;
        while (ready.Count > 0)
        {
            var ordinal = ready.Dequeue();
            visited++;
            var targets = outgoing[ordinal];
            if (targets is null)
            {
                continue;
            }

            foreach (var target in targets)
            {
                incomingCount[target]--;
                if (incomingCount[target] == 0)
                {
                    ready.Enqueue(target);
                }
            }
        }

        if (visited != nodes.Count)
        {
            throw new ArgumentException(
                "Hierarchy edges contain a directed cycle.",
                nameof(edges));
        }
    }

    private static ClaimSelection SelectNodesWithoutParents(
        ClaimSelection nodes,
        IReadOnlyList<HierarchyEdge> edges)
    {
        var hasParent = new bool[nodes.Basis.Count];
        foreach (var edge in edges)
        {
            hasParent[edge.ChildOrdinal] = true;
        }

        var roots = new List<int>();
        foreach (var ordinal in nodes)
        {
            if (!hasParent[ordinal])
            {
                roots.Add(ordinal);
            }
        }

        return ClaimSelection.Create(nodes.Basis, roots);
    }

    private static ClaimSelection SelectNodesWithoutChildren(
        ClaimSelection nodes,
        IReadOnlyList<HierarchyEdge> edges)
    {
        var hasChild = new bool[nodes.Basis.Count];
        foreach (var edge in edges)
        {
            hasChild[edge.ParentOrdinal] = true;
        }

        var leaves = new List<int>();
        foreach (var ordinal in nodes)
        {
            if (!hasChild[ordinal])
            {
                leaves.Add(ordinal);
            }
        }

        return ClaimSelection.Create(nodes.Basis, leaves);
    }

    private static int Compare(HierarchyEdge edge, int childOrdinal, int parentOrdinal)
    {
        var comparison = edge.ChildOrdinal.CompareTo(childOrdinal);
        return comparison != 0 ? comparison : edge.ParentOrdinal.CompareTo(parentOrdinal);
    }
}

/// <summary>Containment-derived hierarchy projections over an already validated laminar family.</summary>
public static class LaminarHierarchy
{
    /// <summary>
    /// Gives every non-root occurrence one immediate strict-container parent. Equal parent
    /// geometry is resolved only by the supplied policy's lowest-ordinal tie rule.
    /// </summary>
    public static HierarchyView NearestContainers(
        LaminarView family,
        HierarchyPolicy policy)
    {
        ArgumentNullException.ThrowIfNull(family);
        ArgumentNullException.ThrowIfNull(policy);
        if (policy.Construction != HierarchyConstruction.NearestStrictContainer ||
            policy.TieBreak != HierarchyTieBreak.LowestOrdinal)
        {
            throw new ArgumentException(
                "Nearest-container projection requires a NearestContainer hierarchy policy.",
                nameof(policy));
        }

        var edges = new List<HierarchyEdge>();
        foreach (var child in family.Groups)
        {
            var nearestIndex = -1;
            for (var candidateIndex = 0; candidateIndex < family.Groups.Count; candidateIndex++)
            {
                var candidate = family.Groups[candidateIndex];
                if (!candidate.Span.ProperlyContains(child.Span))
                {
                    continue;
                }

                if (nearestIndex < 0 ||
                    family.Groups[nearestIndex].Span.ProperlyContains(candidate.Span))
                {
                    nearestIndex = candidateIndex;
                }
            }

            if (nearestIndex < 0)
            {
                continue;
            }

            var nearest = family.Groups[nearestIndex];
            foreach (var childOrdinal in child.Members)
            {
                edges.Add(new HierarchyEdge(
                    childOrdinal,
                    nearest.FirstOrdinal,
                    policy.Name));
            }
        }

        return HierarchyView.CreateNearestContainerProjection(family, policy, edges);
    }
}
