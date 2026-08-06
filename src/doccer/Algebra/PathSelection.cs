using System;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>The exact guarantee made by the first K4b flat-path policy.</summary>
public enum PathSelectionGuarantee
{
    /// <summary>Globally minimum sum of retained edge costs among complete admissible paths.</summary>
    MinimumAdditiveCost = 0,
}

/// <summary>The deterministic tie rule applied after the objective score compares equal.</summary>
public enum PathTieBreak
{
    /// <summary>Compare complete source-batch ordinal sequences lexicographically.</summary>
    LexicographicOrdinal = 0,
}

/// <summary>The path-feasibility contract required by a selection problem.</summary>
public enum PathFeasibility
{
    /// <summary>The selected path must exactly cover the full graph window.</summary>
    CompletePath = 0,
}

/// <summary>
/// An exact-graph policy that snapshots one nonnegative Int64 cost per candidate and promises
/// minimum additive cost with lexicographic ordinal ties. The caller owns the costs' meaning;
/// Doccer retains only their required diagnostic name and unit.
/// </summary>
public sealed class AdditivePathPolicy
{
    private readonly long[] _costs;

    private AdditivePathPolicy(
        CandidateRegionGraph graph,
        string name,
        string unit,
        long[] costs)
    {
        Graph = graph;
        Name = name;
        Unit = unit;
        _costs = costs;
    }

    /// <summary>The exact source graph whose candidate ordinals index this policy.</summary>
    public CandidateRegionGraph Graph { get; }

    /// <summary>The caller's stable diagnostic name for this objective.</summary>
    public string Name { get; }

    /// <summary>The caller's opaque score-unit stamp; Doccer performs no unit conversion.</summary>
    public string Unit { get; }

    public PathSelectionGuarantee Guarantee => PathSelectionGuarantee.MinimumAdditiveCost;

    public PathTieBreak TieBreak => PathTieBreak.LexicographicOrdinal;

    /// <summary>
    /// Evaluates <paramref name="edgeCost"/> exactly once for every graph candidate and retains
    /// the resulting immutable table. The sum of all candidate costs must fit in Int64, which
    /// bounds every possible path score because costs are nonnegative.
    /// </summary>
    public static AdditivePathPolicy Create(
        CandidateRegionGraph graph,
        string name,
        string unit,
        Func<SpanRecord, long> edgeCost)
    {
        ArgumentNullException.ThrowIfNull(graph);
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A path-policy name is required.", nameof(name));
        }

        if (string.IsNullOrWhiteSpace(unit))
        {
            throw new ArgumentException("A path-cost unit is required.", nameof(unit));
        }

        ArgumentNullException.ThrowIfNull(edgeCost);
        var costs = new long[graph.Source.Count];
        long totalCostBound = 0;
        foreach (var ordinal in graph)
        {
            var cost = edgeCost(graph.Source[ordinal]);
            if (cost < 0)
            {
                throw new ArgumentOutOfRangeException(
                    nameof(edgeCost),
                    cost,
                    $"Candidate #{ordinal} has a negative path cost.");
            }

            try
            {
                totalCostBound = checked(totalCostBound + cost);
            }
            catch (OverflowException exception)
            {
                throw new ArgumentException(
                    "The sum of candidate path costs exceeds Int64.MaxValue.",
                    nameof(edgeCost),
                    exception);
            }

            costs[ordinal] = cost;
        }

        return new AdditivePathPolicy(graph, name, unit, costs);
    }

    /// <summary>Returns the retained cost of one exact source-graph candidate ordinal.</summary>
    public long CostOf(int ordinal)
    {
        if (!Graph.Contains(ordinal))
        {
            throw new ArgumentException(
                $"Ordinal #{ordinal} is not a candidate edge of the policy graph.",
                nameof(ordinal));
        }

        return _costs[ordinal];
    }
}

/// <summary>
/// One exact candidate-graph problem for minimum-additive-cost complete-path selection. Hard
/// constraints are already evaluated into <see cref="AdmissibleCandidates"/>; no opaque
/// whole-selection feasibility callback is retained.
/// </summary>
public sealed class PathSelectionProblem
{
    private PathSelectionProblem(
        CandidateRegionGraph graph,
        ClaimSelection admissibleCandidates,
        AdditivePathPolicy policy,
        CandidateRegionGraph admissibleGraph,
        ClaimSelection excludedCandidates)
    {
        Graph = graph;
        AdmissibleCandidates = admissibleCandidates;
        Policy = policy;
        AdmissibleGraph = admissibleGraph;
        ExcludedCandidates = excludedCandidates;
    }

    /// <summary>The exact source graph containing every candidate considered by the caller.</summary>
    public CandidateRegionGraph Graph { get; }

    public SpanBatch Source => Graph.Source;

    public TextMaster Master => Graph.Master;

    public TextSpan Window => Graph.Window;

    /// <summary>The exact hard-constraint-admitted subset retained from the source graph.</summary>
    public ClaimSelection AdmissibleCandidates { get; }

    /// <summary>The exact feasibility graph formed from the admissible subset and source window.</summary>
    public CandidateRegionGraph AdmissibleGraph { get; }

    /// <summary>Source-graph candidates removed by the caller's hard admissibility decision.</summary>
    public ClaimSelection ExcludedCandidates { get; }

    /// <summary>The exact snapshotted objective and tie policy object.</summary>
    public AdditivePathPolicy Policy { get; }

    public PathFeasibility Feasibility => PathFeasibility.CompletePath;

    public static PathSelectionProblem Create(
        CandidateRegionGraph graph,
        ClaimSelection admissibleCandidates,
        AdditivePathPolicy policy)
    {
        ArgumentNullException.ThrowIfNull(graph);
        ArgumentNullException.ThrowIfNull(admissibleCandidates);
        ArgumentNullException.ThrowIfNull(policy);
        if (!ReferenceEquals(admissibleCandidates.Basis, graph.Source))
        {
            throw new InvalidOperationException(
                "Admissible candidates must use the source graph's exact frozen-batch basis.");
        }

        if (!ReferenceEquals(policy.Graph, graph))
        {
            throw new InvalidOperationException(
                "A path-selection problem and policy must stamp the same exact graph object.");
        }

        foreach (var ordinal in admissibleCandidates)
        {
            if (!graph.Contains(ordinal))
            {
                throw new ArgumentException(
                    $"Admissible ordinal #{ordinal} is not a candidate edge of the source graph.",
                    nameof(admissibleCandidates));
            }
        }

        return new PathSelectionProblem(
            graph,
            admissibleCandidates,
            policy,
            CandidateRegionGraph.Create(admissibleCandidates, graph.Window),
            graph.Candidates.Subtract(admissibleCandidates));
    }
}

/// <summary>
/// Path-specific selection failure evidence. K4a feasibility diagnostics are computed on the
/// exact admissible graph while this value retains the full source problem and objective stamp.
/// </summary>
public sealed class PathSelectionResidual
{
    internal PathSelectionResidual(
        PathSelectionProblem problem,
        SegmentationResidual feasibility)
    {
        if (!ReferenceEquals(problem.AdmissibleGraph, feasibility.Graph))
        {
            throw new InvalidOperationException(
                "A path-selection residual must use its problem's exact admissible graph.");
        }

        Problem = problem;
        Feasibility = feasibility;
    }

    public PathSelectionProblem Problem { get; }

    public CandidateRegionGraph Graph => Problem.Graph;

    public CandidateRegionGraph AdmissibleGraph => Problem.AdmissibleGraph;

    public AdditivePathPolicy Policy => Problem.Policy;

    /// <summary>K4a gap and dead-branch evidence on the exact admissible graph.</summary>
    public SegmentationResidual Feasibility { get; }

    public SpanSet CoverageGaps => Feasibility.CoverageGaps;

    public IReadOnlyList<int> DeadEndBoundaries => Feasibility.DeadEndBoundaries;

    public ClaimSelection DeadEndCandidates => Feasibility.DeadEndCandidates;
}

/// <summary>
/// The exact problem- and policy-stamped outcome of additive complete-path selection. Exactly one
/// of <see cref="Partition"/> and <see cref="Residual"/> is present.
/// </summary>
public sealed class PathSelectionResult
{
    private PathSelectionResult(
        PathSelectionProblem problem,
        PartitionView? partition,
        long? score,
        ClaimSelection selectedCandidates,
        ClaimSelection rejectedCandidates,
        PathSelectionResidual? residual)
    {
        Problem = problem;
        Partition = partition;
        Score = score;
        SelectedCandidates = selectedCandidates;
        RejectedCandidates = rejectedCandidates;
        Residual = residual;
    }

    public PathSelectionProblem Problem { get; }

    public CandidateRegionGraph Graph => Problem.Graph;

    public CandidateRegionGraph AdmissibleGraph => Problem.AdmissibleGraph;

    public AdditivePathPolicy Policy => Problem.Policy;

    public PathFeasibility Feasibility => Problem.Feasibility;

    public PathSelectionGuarantee Guarantee => Policy.Guarantee;

    public PathTieBreak TieBreak => Policy.TieBreak;

    public PartitionView? Partition { get; }

    /// <summary>The minimum complete-path score, or null when no admissible complete path exists.</summary>
    public long? Score { get; }

    public string ScoreUnit => Policy.Unit;

    public ClaimSelection SelectedCandidates { get; }

    /// <summary>Admissible candidates not selected by this exact objective and tie policy.</summary>
    public ClaimSelection RejectedCandidates { get; }

    /// <summary>Candidates removed by the caller's hard admissibility decision.</summary>
    public ClaimSelection ExcludedCandidates => Problem.ExcludedCandidates;

    public PathSelectionResidual? Residual { get; }

    public bool IsComplete => Partition is not null;

    internal static PathSelectionResult Complete(
        PathSelectionProblem problem,
        PartitionView partition,
        long score)
    {
        if (!ReferenceEquals(problem.Graph, partition.Graph))
        {
            throw new InvalidOperationException(
                "A selected partition must stamp the problem's exact source graph.");
        }

        var inadmissible = partition.Selection.Subtract(problem.AdmissibleCandidates);
        if (!inadmissible.IsEmpty)
        {
            throw new InvalidOperationException(
                "A selected partition contains candidates excluded by the problem.");
        }

        long verifiedScore = 0;
        foreach (var ordinal in partition)
        {
            verifiedScore = checked(verifiedScore + problem.Policy.CostOf(ordinal));
        }

        if (score != verifiedScore)
        {
            throw new InvalidOperationException(
                $"Selected path score {score} does not equal retained edge-cost sum {verifiedScore}.");
        }

        return new PathSelectionResult(
            problem,
            partition,
            score,
            partition.Selection,
            problem.AdmissibleCandidates.Subtract(partition.Selection),
            null);
    }

    internal static PathSelectionResult Failed(
        PathSelectionProblem problem,
        PathSelectionResidual residual)
    {
        if (!ReferenceEquals(problem, residual.Problem))
        {
            throw new InvalidOperationException(
                "A failed path-selection result and residual must stamp the same exact problem.");
        }

        return new PathSelectionResult(
            problem,
            null,
            null,
            ClaimSelection.None(problem.Source),
            problem.AdmissibleCandidates,
            residual);
    }
}

/// <summary>Reference execution for the first objective-bearing flat-path selection contract.</summary>
public static class PathSelection
{
    /// <summary>
    /// Selects the globally minimum additive-cost admissible complete path. Equal scores use the
    /// lexicographically smallest full ordinal sequence. Production uses finite DAG dynamic
    /// programming and does not enumerate all paths.
    /// </summary>
    public static PathSelectionResult Select(PathSelectionProblem problem)
    {
        ArgumentNullException.ThrowIfNull(problem);
        var boundarySet = new SortedSet<int>
        {
            problem.Window.Start,
            problem.Window.End,
        };
        foreach (var ordinal in problem.AdmissibleCandidates)
        {
            var edge = problem.Source[ordinal].Span;
            boundarySet.Add(edge.Start);
            boundarySet.Add(edge.End);
        }

        var boundaries = new int[boundarySet.Count];
        boundarySet.CopyTo(boundaries);
        var bestByBoundary = new Dictionary<int, PathPlan>
        {
            [problem.Window.End] = new PathPlan(0, Array.Empty<int>()),
        };

        for (var boundaryIndex = boundaries.Length - 1; boundaryIndex >= 0; boundaryIndex--)
        {
            var boundary = boundaries[boundaryIndex];
            if (boundary == problem.Window.End)
            {
                continue;
            }

            PathPlan? best = null;
            foreach (var ordinal in problem.AdmissibleCandidates)
            {
                var edge = problem.Source[ordinal].Span;
                if (edge.Start != boundary || !bestByBoundary.TryGetValue(edge.End, out var suffix))
                {
                    continue;
                }

                var ordinals = new int[suffix.Ordinals.Length + 1];
                ordinals[0] = ordinal;
                Array.Copy(suffix.Ordinals, 0, ordinals, 1, suffix.Ordinals.Length);
                var candidate = new PathPlan(
                    checked(problem.Policy.CostOf(ordinal) + suffix.Score),
                    ordinals);
                if (best is null || Compare(candidate, best) < 0)
                {
                    best = candidate;
                }
            }

            if (best is not null)
            {
                bestByBoundary.Add(boundary, best);
            }
        }

        if (!bestByBoundary.TryGetValue(problem.Window.Start, out var selected))
        {
            var reachability = ReachabilityView.Create(problem.AdmissibleGraph);
            if (reachability.HasCompletePath)
            {
                throw new InvalidOperationException(
                    "Admissible geometry reports a complete path, but path selection found none.");
            }

            var feasibility = new SegmentationResidual(problem.AdmissibleGraph, reachability);
            if (feasibility.IsEmpty)
            {
                throw new InvalidOperationException(
                    "An infeasible nonempty path-selection problem produced no residual evidence.");
            }

            return PathSelectionResult.Failed(
                problem,
                new PathSelectionResidual(problem, feasibility));
        }

        return PathSelectionResult.Complete(
            problem,
            PartitionView.Create(problem.Graph, selected.Ordinals),
            selected.Score);
    }

    private static int Compare(PathPlan left, PathPlan right)
    {
        var scoreComparison = left.Score.CompareTo(right.Score);
        if (scoreComparison != 0)
        {
            return scoreComparison;
        }

        var shared = Math.Min(left.Ordinals.Length, right.Ordinals.Length);
        for (var index = 0; index < shared; index++)
        {
            var ordinalComparison = left.Ordinals[index].CompareTo(right.Ordinals[index]);
            if (ordinalComparison != 0)
            {
                return ordinalComparison;
            }
        }

        return left.Ordinals.Length.CompareTo(right.Ordinals.Length);
    }

    private sealed record PathPlan(long Score, int[] Ordinals);
}
