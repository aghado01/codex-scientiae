using System;
using System.Collections.Generic;
using System.Linq;

namespace CodexSci.Doccer;

/// <summary>The crossing invariant validated by a laminar-family view.</summary>
public enum LaminarCrossingRule
{
    /// <summary>Properly crossing extents are forbidden; nesting, equality, and disjointness remain valid.</summary>
    NoProperCrossing = 0,
}

/// <summary>A named validation stamp for one exact laminar family.</summary>
public sealed class LaminarFamilyPolicy
{
    public LaminarFamilyPolicy(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A laminar-family policy name is required.", nameof(name));
        }

        Name = name;
    }

    public string Name { get; }

    public LaminarCrossingRule CrossingRule => LaminarCrossingRule.NoProperCrossing;
}

/// <summary>An equal-geometry group retaining every exact source-batch occurrence.</summary>
public sealed class LaminarGroup
{
    internal LaminarGroup(TextSpan span, ClaimSelection members)
    {
        if (members.IsEmpty)
        {
            throw new ArgumentException("A laminar geometry group cannot be empty.", nameof(members));
        }

        foreach (var ordinal in members)
        {
            if (members.Basis[ordinal].Span != span)
            {
                throw new ArgumentException(
                    "Every laminar group member must have the group's exact geometry.",
                    nameof(members));
            }
        }

        Span = span;
        Members = members;
        FirstOrdinal = members.First();
    }

    public TextSpan Span { get; }

    public ClaimSelection Members { get; }

    public int FirstOrdinal { get; }

    internal int MaximumPriority
    {
        get
        {
            var maximum = int.MinValue;
            foreach (var ordinal in Members)
            {
                maximum = Math.Max(maximum, Members.Basis[ordinal].Priority);
            }

            return maximum;
        }
    }
}

/// <summary>
/// A validation-only view of one exact no-crossing occurrence family. Construction never filters
/// candidates and contains no parent relation; admission and hierarchy projection are separate.
/// </summary>
public sealed class LaminarView
{
    private LaminarView(
        ClaimSelection selection,
        TextSpan window,
        LaminarFamilyPolicy policy,
        LaminarGroup[] groups)
    {
        Selection = selection;
        Window = window;
        Policy = policy;
        Groups = Array.AsReadOnly(groups);
        Coverage = selection.Coverage();
    }

    public ClaimSelection Selection { get; }

    public SpanBatch Basis => Selection.Basis;

    public TextMaster Master => Selection.Master;

    public TextSpan Window { get; }

    public LaminarFamilyPolicy Policy { get; }

    public IReadOnlyList<LaminarGroup> Groups { get; }

    public SpanSet Coverage { get; }

    public int Count => Selection.Count;

    public int GroupCount => Groups.Count;

    public bool IsEmpty => Selection.IsEmpty;

    public static LaminarView Create(
        ClaimSelection selection,
        TextSpan window,
        LaminarFamilyPolicy policy)
    {
        ArgumentNullException.ThrowIfNull(selection);
        ArgumentNullException.ThrowIfNull(policy);
        selection.Master.ValidateSpan(window);
        var ordinals = selection.ToArray();
        for (var left = 0; left < ordinals.Length; left++)
        {
            var leftSpan = selection.Basis[ordinals[left]].Span;
            if (!window.Contains(leftSpan))
            {
                throw new ArgumentException(
                    $"Selected claim #{ordinals[left]} lies outside the declared laminar window.",
                    nameof(selection));
            }

            for (var right = left + 1; right < ordinals.Length; right++)
            {
                var rightSpan = selection.Basis[ordinals[right]].Span;
                if (leftSpan.Crosses(rightSpan))
                {
                    throw new ArgumentException(
                        $"Selected claims #{ordinals[left]} and #{ordinals[right]} cross.",
                        nameof(selection));
                }
            }
        }

        return new LaminarView(selection, window, policy, BuildGroups(selection));
    }

    internal static LaminarGroup[] BuildGroups(ClaimSelection selection) =>
        selection
            .GroupBy(ordinal => selection.Basis[ordinal].Span)
            .Select(group => new LaminarGroup(
                group.Key,
                ClaimSelection.Create(selection.Basis, group)))
            .OrderBy(group => group.Span.Start)
            .ThenByDescending(group => group.Span.End)
            .ThenBy(group => group.FirstOrdinal)
            .ToArray();
}

/// <summary>The deterministic order used by the first named laminar admission policy.</summary>
public enum LaminarAdmissionOrder
{
    /// <summary>Group maximum priority descending, then start, longer end, and first ordinal.</summary>
    PriorityThenGeometry = 0,
}

/// <summary>The exact guarantee made by greedy laminar admission.</summary>
public enum LaminarAdmissionGuarantee
{
    /// <summary>No rejected equal-geometry group can be added without crossing an admitted group.</summary>
    InclusionMaximal = 0,
}

/// <summary>A named policy for deterministic, inclusion-maximal greedy laminar admission.</summary>
public sealed class LaminarAdmissionPolicy
{
    private LaminarAdmissionPolicy(string name, LaminarFamilyPolicy familyPolicy)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A laminar-admission policy name is required.", nameof(name));
        }

        Name = name;
        FamilyPolicy = familyPolicy;
    }

    public string Name { get; }

    public LaminarFamilyPolicy FamilyPolicy { get; }

    public LaminarAdmissionOrder Order => LaminarAdmissionOrder.PriorityThenGeometry;

    public LaminarAdmissionGuarantee Guarantee => LaminarAdmissionGuarantee.InclusionMaximal;

    public static LaminarAdmissionPolicy PriorityThenGeometry(
        string name,
        LaminarFamilyPolicy familyPolicy)
    {
        ArgumentNullException.ThrowIfNull(familyPolicy);
        return new LaminarAdmissionPolicy(name, familyPolicy);
    }
}

/// <summary>
/// Exact population and policy evidence from one greedy laminar admission. Accepted occurrences
/// and crossing residue form a disjoint partition of <see cref="Candidates"/>.
/// </summary>
public sealed class LaminarAdmissionResult
{
    internal LaminarAdmissionResult(
        ClaimSelection candidates,
        LaminarAdmissionPolicy policy,
        LaminarView accepted,
        ClaimSelection crossingResidue)
    {
        if (!ReferenceEquals(candidates.Basis, accepted.Basis) ||
            !ReferenceEquals(candidates.Basis, crossingResidue.Basis))
        {
            throw new InvalidOperationException(
                "A laminar admission result must retain one exact frozen-batch basis.");
        }

        if (!accepted.Selection.Intersect(crossingResidue).IsEmpty ||
            !accepted.Selection.Union(crossingResidue).Equals(candidates))
        {
            throw new InvalidOperationException(
                "Accepted laminar occurrences and crossing residue must partition the candidates.");
        }

        if (!ReferenceEquals(policy.FamilyPolicy, accepted.Policy))
        {
            throw new InvalidOperationException(
                "The accepted family must retain the admission policy's exact validation policy.");
        }

        Candidates = candidates;
        Policy = policy;
        Accepted = accepted;
        CrossingResidue = crossingResidue;
    }

    public ClaimSelection Candidates { get; }

    public SpanBatch Basis => Candidates.Basis;

    public TextMaster Master => Candidates.Master;

    public TextSpan Window => Accepted.Window;

    public LaminarAdmissionPolicy Policy { get; }

    public LaminarAdmissionGuarantee Guarantee => Policy.Guarantee;

    public LaminarAdmissionOrder Order => Policy.Order;

    public LaminarView Accepted { get; }

    public ClaimSelection AcceptedCandidates => Accepted.Selection;

    public ClaimSelection CrossingResidue { get; }
}

/// <summary>Reference deterministic greedy admission for exact laminar candidate selections.</summary>
public static class Laminarizer
{
    public static LaminarAdmissionResult Admit(
        ClaimSelection candidates,
        TextSpan window,
        LaminarAdmissionPolicy policy)
    {
        ArgumentNullException.ThrowIfNull(candidates);
        ArgumentNullException.ThrowIfNull(policy);
        candidates.Master.ValidateSpan(window);
        var groups = LaminarView.BuildGroups(candidates)
            .OrderByDescending(group => group.MaximumPriority)
            .ThenBy(group => group.Span.Start)
            .ThenByDescending(group => group.Span.End)
            .ThenBy(group => group.FirstOrdinal)
            .ToArray();

        var acceptedGroups = new List<LaminarGroup>();
        var acceptedOrdinals = new List<int>();
        foreach (var candidate in groups)
        {
            if (!window.Contains(candidate.Span))
            {
                throw new ArgumentException(
                    $"Candidate claim #{candidate.FirstOrdinal} lies outside the declared laminar window.",
                    nameof(candidates));
            }

            if (acceptedGroups.Any(existing => candidate.Span.Crosses(existing.Span)))
            {
                continue;
            }

            acceptedGroups.Add(candidate);
            acceptedOrdinals.AddRange(candidate.Members);
        }

        var acceptedSelection = ClaimSelection.Create(candidates.Basis, acceptedOrdinals);
        var residue = candidates.Subtract(acceptedSelection);
        var accepted = LaminarView.Create(
            acceptedSelection,
            window,
            policy.FamilyPolicy);

        return new LaminarAdmissionResult(candidates, policy, accepted, residue);
    }
}
