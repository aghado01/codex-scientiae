using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>
/// How a claim belongs to the lines it lies on — a declared policy, never an implicit choice
/// (the D8 discipline: boundary behavior is part of a measure's declaration, established here
/// for the grain the first density measures will run over).
/// </summary>
public enum LineMembership
{
    /// <summary>A claim belongs to every line its span touches (occupancy).</summary>
    EveryLineTouched = 0,

    /// <summary>A claim belongs only to the line its span starts on (attribution — each claim exactly once).</summary>
    StartLineOnly = 1,
}

/// <summary>
/// Claim-fact selectors over what a claim actually carries, mirroring <see cref="AtomFacts"/>:
/// each is a plain <c>SpanRecord -> key</c> function, so <see cref="Grouping.ByKey"/> accepts
/// these and any caller-supplied selector on the same footing (D22). Compose facts by returning
/// a tuple — <c>record =&gt; (record.Kind, record.Source)</c> groups on both.
/// </summary>
public static class ClaimFacts
{
    public static Func<SpanRecord, string> Kind { get; } = static record => record.Kind;

    public static Func<SpanRecord, string> Source { get; } = static record => record.Source;

    /// <summary>Null for claims from producers that record no rule; null is a legitimate group key.</summary>
    public static Func<SpanRecord, string?> RuleId { get; } = static record => record.RuleId;

    public static Func<SpanRecord, int> Priority { get; } = static record => record.Priority;

    public static Func<SpanRecord, SpanLevel> Level { get; } = static record => record.Level;
}

/// <summary>
/// One group of a keyed batch grouping: the key the group formed on and the member ordinals in
/// ascending order. Ordinals index the source batch — a group never copies or re-resolves
/// claims.
/// </summary>
public readonly record struct ClaimGroup<TKey>(TKey Key, IReadOnlyList<int> Ordinals);

/// <summary>
/// One line of a <see cref="LineGroupView"/>: the line index, its full partition extent
/// (<see cref="TextTopology.GetLineExtent"/> — deliberately not D15's content extent, which is
/// a matching convention rather than the partition grain), and the member ordinals in ascending
/// order.
/// </summary>
public readonly record struct LineGroup(int LineIndex, TextSpan Extent, IReadOnlyList<int> Ordinals);

/// <summary>
/// The claim-major batch projection onto the line grain: one <see cref="LineRange"/> per
/// ordinal. A basis-stamped derived view — it answers "over what was I computed" with typed
/// references: the source batch and, through it, the master.
/// </summary>
public sealed class LineProjection
{
    internal LineProjection(SpanBatch source, ReadOnlyCollection<LineRange> ranges)
    {
        Source = source;
        Ranges = ranges;
    }

    public TextMaster Master => Source.Master;

    public SpanBatch Source { get; }

    /// <summary>Per-ordinal line ranges, ordinal-aligned with the source batch.</summary>
    public IReadOnlyList<LineRange> Ranges { get; }
}

/// <summary>
/// The line-major grouping of a batch onto its master's line grain, total over the line count —
/// claimless lines are present and empty. Basis-stamped: source batch, master, and the named
/// membership policy the grouping ran under.
/// </summary>
public sealed class LineGroupView
{
    internal LineGroupView(SpanBatch source, LineMembership membership, ReadOnlyCollection<LineGroup> lines)
    {
        Source = source;
        Membership = membership;
        Lines = lines;
    }

    public TextMaster Master => Source.Master;

    public SpanBatch Source { get; }

    public LineMembership Membership { get; }

    /// <summary>One entry per line of the master, index-aligned with the line topology.</summary>
    public IReadOnlyList<LineGroup> Lines { get; }
}

/// <summary>Batch-level project: the lift operation, named separately per D7.</summary>
public static class Projection
{
    /// <summary>
    /// Projects every claim onto the half-open range of lines it intersects, via the span-level
    /// <see cref="TextTopology.Project"/>. Claims are non-empty by construction, so the
    /// insertion-point convention never applies here.
    /// </summary>
    public static LineProjection Project(SpanBatch batch)
    {
        ArgumentNullException.ThrowIfNull(batch);
        var topology = batch.Master.Topology;
        var ranges = new LineRange[batch.Count];
        for (var ordinal = 0; ordinal < batch.Count; ordinal++)
        {
            ranges[ordinal] = topology.Project(batch[ordinal].Span);
        }

        return new LineProjection(batch, Array.AsReadOnly(ranges));
    }
}

/// <summary>Batch-level group: the lift operation, named separately per D7.</summary>
public static class Grouping
{
    /// <summary>
    /// Groups a batch's claims under an explicit key — the batch sibling of
    /// <see cref="TextTopology.EmitRuns"/>' break-key discipline (D4): the key is the whole of
    /// the caller's typing decision, and each group carries the key it formed on. The
    /// deterministic contract is the point: groups appear in first-appearance order (the
    /// interning precedent), ordinals ascend within a group, and a caller comparer is honored.
    /// Key-only grouping touches no line topology (D12: cost scales with what is touched).
    /// </summary>
    public static IReadOnlyList<ClaimGroup<TKey>> ByKey<TKey>(
        SpanBatch batch,
        Func<SpanRecord, TKey> key,
        IEqualityComparer<TKey>? comparer = null)
    {
        ArgumentNullException.ThrowIfNull(batch);
        ArgumentNullException.ThrowIfNull(key);

        var equality = comparer ?? EqualityComparer<TKey>.Default;
        var groups = new List<(TKey Key, List<int> Ordinals)>();
        // A dictionary cannot hold a null key, but null is a legitimate fact value (an absent
        // rule id), so the null group is tracked beside the lookup rather than inside it —
        // TKey stays unconstrained and the notnull mismatch below is impossible by the branch.
#pragma warning disable CS8714 // null keys are diverted before the dictionary is touched
        var lookup = new Dictionary<TKey, int>(equality);
#pragma warning restore CS8714
        var nullIndex = -1;
        for (var ordinal = 0; ordinal < batch.Count; ordinal++)
        {
            // One key evaluation per claim: the selector is caller code and may be arbitrarily
            // expensive.
            var value = key(batch[ordinal]);
            int index;
            if (value is null)
            {
                if (nullIndex < 0)
                {
                    nullIndex = groups.Count;
                    groups.Add((value, new List<int>()));
                }

                index = nullIndex;
            }
            else if (!lookup.TryGetValue(value, out index))
            {
                index = groups.Count;
                lookup.Add(value, index);
                groups.Add((value, new List<int>()));
            }

            groups[index].Ordinals.Add(ordinal);
        }

        var result = new ClaimGroup<TKey>[groups.Count];
        for (var i = 0; i < result.Length; i++)
        {
            result[i] = new ClaimGroup<TKey>(groups[i].Key, groups[i].Ordinals.AsReadOnly());
        }

        return Array.AsReadOnly(result);
    }

    /// <summary>
    /// Groups a batch's claims onto the master's line grain under a named membership policy.
    /// Total over the line count: a claimless line (including an empty final line) is present
    /// with an empty group, because the line grain is a partition, not a summary of where
    /// claims happen to be.
    /// </summary>
    public static LineGroupView ByLine(
        SpanBatch batch,
        LineMembership membership = LineMembership.EveryLineTouched)
    {
        ArgumentNullException.ThrowIfNull(batch);
        if (!Enum.IsDefined(membership))
        {
            throw new ArgumentOutOfRangeException(nameof(membership), membership, "Undefined LineMembership value.");
        }

        var topology = batch.Master.Topology;
        var members = new List<int>[topology.LineCount];
        for (var line = 0; line < members.Length; line++)
        {
            members[line] = new List<int>();
        }

        for (var ordinal = 0; ordinal < batch.Count; ordinal++)
        {
            if (membership == LineMembership.StartLineOnly)
            {
                members[topology.GetLineIndex(batch[ordinal].Span.Start)].Add(ordinal);
                continue;
            }

            var range = topology.Project(batch[ordinal].Span);
            for (var line = range.Start; line < range.End; line++)
            {
                members[line].Add(ordinal);
            }
        }

        var lines = new LineGroup[members.Length];
        for (var line = 0; line < lines.Length; line++)
        {
            lines[line] = new LineGroup(line, topology.GetLineExtent(line), members[line].AsReadOnly());
        }

        return new LineGroupView(batch, membership, Array.AsReadOnly(lines));
    }
}
