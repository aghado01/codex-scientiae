using System;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>The deliberately narrow reference operation stamped on a K4a segmentation result.</summary>
public enum SegmentationPolicy
{
    /// <summary>At each boundary, take the lowest viable exact-basis candidate ordinal.</summary>
    FirstOrdinalCompletePath = 0,
}

/// <summary>Graph-feasibility evidence from a failed complete-path traversal.</summary>
public sealed class SegmentationResidual
{
    internal SegmentationResidual(CandidateRegionGraph graph, ReachabilityView reachability)
    {
        if (!graph.Equals(reachability.Graph))
        {
            throw new InvalidOperationException(
                "A segmentation residual and its reachability view must stamp equal graph definitions on one exact batch.");
        }

        Graph = graph;
        Reachability = reachability;
        CoverageGaps = SpanSet
            .Create(graph.Master, new[] { graph.Window })
            .Subtract(graph.Candidates.Coverage());
    }

    public CandidateRegionGraph Graph { get; }

    public SpanBatch Source => Graph.Source;

    public TextMaster Master => Graph.Master;

    public TextSpan Window => Graph.Window;

    public ReachabilityView Reachability { get; }

    /// <summary>Normalized window material absent from the union of every candidate edge.</summary>
    public SpanSet CoverageGaps { get; }

    /// <summary>Distinct reachable branch ends that cannot reach the window end.</summary>
    public IReadOnlyList<int> DeadEndBoundaries => Reachability.DeadEndBoundaries;

    /// <summary>Exact candidate ordinals on reachable branches that cannot complete.</summary>
    public ClaimSelection DeadEndCandidates => Reachability.DeadEndCandidates;

    public bool HasCoverageGaps => CoverageGaps.Count != 0;

    public bool HasConnectivityDeadEnds => DeadEndCandidates.Count != 0;

    public bool IsEmpty => !HasCoverageGaps && !HasConnectivityDeadEnds;
}

/// <summary>
/// The exact-graph- and policy-stamped outcome of one K4a reference traversal. Exactly one of
/// <see cref="Partition"/> and <see cref="Residual"/> is present.
/// </summary>
public sealed class SegmentationResult
{
    private SegmentationResult(
        CandidateRegionGraph graph,
        ReachabilityView reachability,
        SegmentationPolicy policy,
        PartitionView? partition,
        SegmentationResidual? residual)
    {
        Graph = graph;
        Reachability = reachability;
        Policy = policy;
        Partition = partition;
        Residual = residual;
    }

    public CandidateRegionGraph Graph { get; }

    public SpanBatch Source => Graph.Source;

    public TextMaster Master => Graph.Master;

    public TextSpan Window => Graph.Window;

    public ReachabilityView Reachability { get; }

    public SegmentationPolicy Policy { get; }

    public PartitionView? Partition { get; }

    public SegmentationResidual? Residual { get; }

    public bool IsComplete => Partition is not null;

    internal static SegmentationResult Complete(
        CandidateRegionGraph graph,
        ReachabilityView reachability,
        SegmentationPolicy policy,
        PartitionView partition)
    {
        if (!graph.Equals(reachability.Graph) || !graph.Equals(partition.Graph))
        {
            throw new InvalidOperationException(
                "A segmentation result, reachability view, and partition must stamp equal graph definitions on one exact batch.");
        }

        return new SegmentationResult(graph, reachability, policy, partition, null);
    }

    internal static SegmentationResult Failed(
        CandidateRegionGraph graph,
        ReachabilityView reachability,
        SegmentationPolicy policy,
        SegmentationResidual residual)
    {
        if (!graph.Equals(reachability.Graph) || !graph.Equals(residual.Graph))
        {
            throw new InvalidOperationException(
                "A segmentation result, reachability view, and residual must stamp equal graph definitions on one exact batch.");
        }

        return new SegmentationResult(graph, reachability, policy, null, residual);
    }
}

/// <summary>Reference operations over one finite exact-basis candidate graph.</summary>
public static class Segmentation
{
    /// <summary>
    /// Returns a complete exact-ordinal partition whenever one exists. At each boundary the
    /// lowest graph ordinal whose end can still reach the window end is selected. This is a
    /// deterministic witness policy, not an optimizer and not an all-path enumeration API.
    /// </summary>
    public static SegmentationResult FirstOrdinalCompletePath(CandidateRegionGraph graph)
    {
        ArgumentNullException.ThrowIfNull(graph);
        const SegmentationPolicy policy = SegmentationPolicy.FirstOrdinalCompletePath;
        var reachability = ReachabilityView.Create(graph);
        if (!reachability.HasCompletePath)
        {
            var residual = new SegmentationResidual(graph, reachability);
            if (residual.IsEmpty)
            {
                throw new InvalidOperationException(
                    "An incomplete nonempty candidate graph produced no feasibility evidence.");
            }

            return SegmentationResult.Failed(graph, reachability, policy, residual);
        }

        var path = new List<int>();
        var cursor = graph.Window.Start;
        while (cursor < graph.Window.End)
        {
            var chosen = -1;
            foreach (var ordinal in graph)
            {
                var edge = graph.Source[ordinal].Span;
                if (edge.Start == cursor && reachability.CanReachWindowEnd(edge.End))
                {
                    chosen = ordinal;
                    break;
                }
            }

            if (chosen < 0)
            {
                throw new InvalidOperationException(
                    $"Geometry closure reports a complete path, but no viable graph edge leaves boundary {cursor}.");
            }

            path.Add(chosen);
            cursor = graph.Source[chosen].Span.End;
        }

        var partition = PartitionView.Create(graph, path);
        return SegmentationResult.Complete(graph, reachability, policy, partition);
    }
}
