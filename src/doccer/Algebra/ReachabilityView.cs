using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>
/// An exact-graph-stamped view of Boolean geometry reachability and its boundary diagnostics.
/// Claim identity remains on <see cref="Graph"/>; <see cref="Closure"/> is the explicit
/// identity-forgetting projection supplied by K3.
/// </summary>
public sealed class ReachabilityView
{
    private readonly ReadOnlyCollection<int> _forwardReachableBoundaries;
    private readonly ReadOnlyCollection<int> _backwardReachableBoundaries;
    private readonly ReadOnlyCollection<int> _deadEndBoundaries;

    private ReachabilityView(
        CandidateRegionGraph graph,
        LocatedRelation closure,
        int[] forwardReachableBoundaries,
        int[] backwardReachableBoundaries,
        int[] deadEndBoundaries,
        ClaimSelection deadEndCandidates)
    {
        Graph = graph;
        Closure = closure;
        _forwardReachableBoundaries = Array.AsReadOnly(forwardReachableBoundaries);
        _backwardReachableBoundaries = Array.AsReadOnly(backwardReachableBoundaries);
        _deadEndBoundaries = Array.AsReadOnly(deadEndBoundaries);
        DeadEndCandidates = deadEndCandidates;
    }

    /// <summary>The exact candidate graph whose diagnostics this value describes.</summary>
    public CandidateRegionGraph Graph { get; }

    public SpanBatch Source => Graph.Source;

    public TextMaster Master => Graph.Master;

    public TextSpan Window => Graph.Window;

    /// <summary>The sole geometry closure, produced through the graph's explicit projection.</summary>
    public LocatedRelation Closure { get; }

    /// <summary>Scalar-valid boundaries reachable from <see cref="TextSpan.Start"/> of the window.</summary>
    public IReadOnlyList<int> ForwardReachableBoundaries => _forwardReachableBoundaries;

    /// <summary>Scalar-valid boundaries from which <see cref="TextSpan.End"/> of the window is reachable.</summary>
    public IReadOnlyList<int> BackwardReachableBoundaries => _backwardReachableBoundaries;

    /// <summary>
    /// Distinct ascending ends of reachable candidate branches that cannot reach the window end.
    /// These diagnostics can be nonempty even when another complete branch exists.
    /// </summary>
    public IReadOnlyList<int> DeadEndBoundaries => _deadEndBoundaries;

    /// <summary>Exact graph ordinals whose reachable branches cannot reach the window end.</summary>
    public ClaimSelection DeadEndCandidates { get; }

    public bool HasCompletePath => CanReach(Window.Start, Window.End);

    public static ReachabilityView Create(CandidateRegionGraph graph)
    {
        ArgumentNullException.ThrowIfNull(graph);
        var closure = graph.ToLocatedRelation().Reachability();
        var forward = new List<int>();
        var backward = new List<int>();
        foreach (var boundary in LocatedSemantics.ValidBoundaries(graph.Master, graph.Window))
        {
            if (closure.Contains(new TextSpan(graph.Window.Start, boundary)))
            {
                forward.Add(boundary);
            }

            if (closure.Contains(new TextSpan(boundary, graph.Window.End)))
            {
                backward.Add(boundary);
            }
        }

        var deadOrdinals = new List<int>();
        var deadBoundaries = new SortedSet<int>();
        foreach (var ordinal in graph)
        {
            var edge = graph.Source[ordinal].Span;
            if (closure.Contains(new TextSpan(graph.Window.Start, edge.Start)) &&
                !closure.Contains(new TextSpan(edge.End, graph.Window.End)))
            {
                deadOrdinals.Add(ordinal);
                deadBoundaries.Add(edge.End);
            }
        }

        var deadBoundaryArray = new int[deadBoundaries.Count];
        deadBoundaries.CopyTo(deadBoundaryArray);
        return new ReachabilityView(
            graph,
            closure,
            forward.ToArray(),
            backward.ToArray(),
            deadBoundaryArray,
            ClaimSelection.Create(graph.Source, deadOrdinals));
    }

    /// <summary>Tests one validated geometry reachability fact within the exact graph window.</summary>
    public bool CanReach(int start, int end)
    {
        var extent = new TextSpan(start, end);
        Master.ValidateSpan(extent);
        if (!Window.Contains(extent))
        {
            throw new ArgumentOutOfRangeException(
                nameof(start),
                extent,
                $"Reachability extent {extent} lies outside graph window {Window}.");
        }

        return Closure.Contains(extent);
    }

    public bool IsReachableFromWindowStart(int boundary)
    {
        ValidateBoundary(boundary);
        return Closure.Contains(new TextSpan(Window.Start, boundary));
    }

    public bool CanReachWindowEnd(int boundary)
    {
        ValidateBoundary(boundary);
        return Closure.Contains(new TextSpan(boundary, Window.End));
    }

    private void ValidateBoundary(int boundary)
    {
        if (boundary < Window.Start || boundary > Window.End)
        {
            throw new ArgumentOutOfRangeException(
                nameof(boundary),
                boundary,
                $"Boundary lies outside graph window {Window}.");
        }

        if (!Master.IsScalarBoundary(boundary))
        {
            throw new ArgumentException(
                $"Boundary {boundary} splits a UTF-16 surrogate pair.",
                nameof(boundary));
        }
    }
}
