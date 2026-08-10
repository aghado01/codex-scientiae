using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>
/// One finite positive ground implication (D44). The conclusion and ordered premises are semantic
/// <see cref="FactKey"/> values. The rule ID, parameter tuple, and exact-batch occurrence tuple are
/// support evidence and do not affect enablement. The value contains no matcher, guard, callback,
/// or access to a fact store.
/// </summary>
public sealed class GroundRule : IEquatable<GroundRule>
{
    private readonly FactKey[] _premises;
    private readonly string[] _parameters;
    private readonly int[] _occurrences;
    private readonly ReadOnlyCollection<FactKey> _premiseView;
    private readonly ReadOnlyCollection<string> _parameterView;
    private readonly ReadOnlyCollection<int> _occurrenceView;

    public GroundRule(
        FactKey conclusion,
        string ruleId,
        IEnumerable<FactKey> premises,
        IEnumerable<string> parameters,
        IEnumerable<int> occurrenceOrdinals)
    {
        ArgumentNullException.ThrowIfNull(conclusion);
        if (string.IsNullOrWhiteSpace(ruleId))
        {
            throw new ArgumentException("A ground-rule ID is required.", nameof(ruleId));
        }

        ArgumentNullException.ThrowIfNull(premises);
        ArgumentNullException.ThrowIfNull(parameters);
        ArgumentNullException.ThrowIfNull(occurrenceOrdinals);

        Conclusion = conclusion;
        RuleId = ruleId;

        var collectedPremises = new List<FactKey>();
        foreach (var premise in premises)
        {
            if (premise is null)
            {
                throw new ArgumentException("Ground-rule premises must be non-null facts.", nameof(premises));
            }

            collectedPremises.Add(premise);
        }

        var collectedParameters = new List<string>();
        foreach (var parameter in parameters)
        {
            if (parameter is null)
            {
                throw new ArgumentException(
                    "Ground-rule parameters must be non-null strings.",
                    nameof(parameters));
            }

            collectedParameters.Add(parameter);
        }

        var collectedOccurrences = new List<int>();
        foreach (var ordinal in occurrenceOrdinals)
        {
            if (ordinal < 0)
            {
                throw new ArgumentOutOfRangeException(
                    nameof(occurrenceOrdinals),
                    ordinal,
                    "Ground-rule occurrence ordinals must be non-negative.");
            }

            collectedOccurrences.Add(ordinal);
        }

        _premises = collectedPremises.ToArray();
        _parameters = collectedParameters.ToArray();
        _occurrences = collectedOccurrences.ToArray();
        _premiseView = Array.AsReadOnly(_premises);
        _parameterView = Array.AsReadOnly(_parameters);
        _occurrenceView = Array.AsReadOnly(_occurrences);
    }

    public FactKey Conclusion { get; }

    public string RuleId { get; }

    /// <summary>
    /// Ordered premise keys. Order and duplicates are retained as evidence; enablement requires
    /// the fact named at every position to be reached and does not consume a resource.
    /// </summary>
    public IReadOnlyList<FactKey> Premises => _premiseView;

    /// <summary>Ordered support parameter strings.</summary>
    public IReadOnlyList<string> Parameters => _parameterView;

    /// <summary>Ordered originating ordinals into a problem's exact occurrence batch.</summary>
    public IReadOnlyList<int> OccurrenceOrdinals => _occurrenceView;

    public bool Equals(GroundRule? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        if (other is null ||
            !Conclusion.Equals(other.Conclusion) ||
            !StringComparer.Ordinal.Equals(RuleId, other.RuleId) ||
            _premises.Length != other._premises.Length ||
            _parameters.Length != other._parameters.Length ||
            !_occurrences.AsSpan().SequenceEqual(other._occurrences))
        {
            return false;
        }

        for (var i = 0; i < _premises.Length; i++)
        {
            if (!_premises[i].Equals(other._premises[i]))
            {
                return false;
            }
        }

        for (var i = 0; i < _parameters.Length; i++)
        {
            if (!StringComparer.Ordinal.Equals(_parameters[i], other._parameters[i]))
            {
                return false;
            }
        }

        return true;
    }

    public override bool Equals(object? obj) => obj is GroundRule other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(Conclusion);
        hash.Add(RuleId, StringComparer.Ordinal);
        foreach (var premise in _premises)
        {
            hash.Add(premise);
        }

        foreach (var parameter in _parameters)
        {
            hash.Add(parameter, StringComparer.Ordinal);
        }

        foreach (var ordinal in _occurrences)
        {
            hash.Add(ordinal);
        }

        return hash.ToHashCode();
    }

    public override string ToString() =>
        $"{RuleId}: [{string.Join(",", (IEnumerable<FactKey>)_premises)}] => {Conclusion}";

    /// <summary>
    /// Canonical representational order by conclusion, rule ID, premise tuple, parameter tuple,
    /// and occurrence tuple. Zero exactly when two rules are value-equal.
    /// </summary>
    internal static int CompareCanonical(GroundRule left, GroundRule right)
    {
        var comparison = FactKey.CompareCanonical(left.Conclusion, right.Conclusion);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = string.CompareOrdinal(left.RuleId, right.RuleId);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = left._premises.Length.CompareTo(right._premises.Length);
        if (comparison != 0)
        {
            return comparison;
        }

        for (var i = 0; i < left._premises.Length; i++)
        {
            comparison = FactKey.CompareCanonical(left._premises[i], right._premises[i]);
            if (comparison != 0)
            {
                return comparison;
            }
        }

        comparison = left._parameters.Length.CompareTo(right._parameters.Length);
        if (comparison != 0)
        {
            return comparison;
        }

        for (var i = 0; i < left._parameters.Length; i++)
        {
            comparison = string.CompareOrdinal(left._parameters[i], right._parameters[i]);
            if (comparison != 0)
            {
                return comparison;
            }
        }

        return CompareTuple(left._occurrences, right._occurrences);
    }

    private static int CompareTuple(int[] left, int[] right)
    {
        var comparison = left.Length.CompareTo(right.Length);
        if (comparison != 0)
        {
            return comparison;
        }

        for (var i = 0; i < left.Length; i++)
        {
            comparison = left[i].CompareTo(right[i]);
            if (comparison != 0)
            {
                return comparison;
            }
        }

        return 0;
    }
}

/// <summary>
/// One finite D44 saturation input: an exact immutable initial support graph and a canonical set
/// of validated ground rules. The candidate universe is derived from the initial fact table and
/// every premise and conclusion named by the rules.
/// </summary>
public sealed class SaturationProblem
{
    private readonly GroundRule[] _rules;
    private readonly ReadOnlyCollection<GroundRule> _ruleView;

    private SaturationProblem(
        SupportHypergraph initial,
        GroundRule[] rules)
    {
        Initial = initial;
        _rules = rules;
        _ruleView = Array.AsReadOnly(_rules);
    }

    /// <summary>The exact retained initial evidence graph.</summary>
    public SupportHypergraph Initial { get; }

    public CanonicalFactTable InitialFacts => Initial.Facts;

    public SpanBatch Occurrences => Initial.Occurrences;

    public TextMaster Master => Initial.Master;

    /// <summary>Distinct ground rules in canonical order.</summary>
    public IReadOnlyList<GroundRule> Rules => _ruleView;

    /// <summary>
    /// Retains the exact initial graph, validates each rule against its master and occurrence
    /// batch, and snapshots, orders, and deduplicates the finite rule sequence.
    /// </summary>
    public static SaturationProblem Create(
        SupportHypergraph initial,
        IEnumerable<GroundRule> rules)
    {
        ArgumentNullException.ThrowIfNull(initial);
        ArgumentNullException.ThrowIfNull(rules);

        var collectedRules = new List<GroundRule>();
        foreach (var rule in rules)
        {
            if (rule is null)
            {
                throw new ArgumentException("Ground rules must be non-null.", nameof(rules));
            }

            ValidateKey(initial.Master, rule.Conclusion);
            foreach (var premise in rule.Premises)
            {
                ValidateKey(initial.Master, premise);
            }

            foreach (var occurrence in rule.OccurrenceOrdinals)
            {
                if (occurrence >= initial.Occurrences.Count)
                {
                    throw new ArgumentException(
                        $"Ground rule '{rule}' occurrence ordinal #{occurrence} is outside the exact occurrence batch of {initial.Occurrences.Count}.",
                        nameof(rules));
                }
            }

            collectedRules.Add(rule);
        }

        collectedRules.Sort(GroundRule.CompareCanonical);
        var distinctRules = new List<GroundRule>(collectedRules.Count);
        foreach (var rule in collectedRules)
        {
            if (distinctRules.Count == 0 || GroundRule.CompareCanonical(distinctRules[^1], rule) != 0)
            {
                distinctRules.Add(rule);
            }
        }

        return new SaturationProblem(initial, distinctRules.ToArray());
    }

    private static void ValidateKey(TextMaster master, FactKey key)
    {
        foreach (var extent in key.Geometry)
        {
            master.ValidateSpan(extent);
        }
    }
}

/// <summary>
/// One exact-problem-stamped D44 saturation result. The result graph and its canonical fact table
/// are newly frozen values over the problem's exact occurrence batch.
/// </summary>
public sealed class SaturationResult
{
    internal SaturationResult(SaturationProblem problem, SupportHypergraph graph)
    {
        if (!ReferenceEquals(problem.Occurrences, graph.Occurrences))
        {
            throw new InvalidOperationException(
                "A saturation result must retain its problem's exact occurrence batch.");
        }

        Problem = problem;
        Graph = graph;
    }

    public SaturationProblem Problem { get; }

    public SupportHypergraph Graph { get; }

    public CanonicalFactTable Facts => Graph.Facts;
}

/// <summary>Reference finite positive saturation over D44 ground rules.</summary>
public static class FactSaturation
{
    /// <summary>
    /// Computes the least reached fact set in semantic-key space, retains every rule enabled by
    /// that final set, and projects all initial and rule support into a newly canonicalized graph.
    /// </summary>
    public static SaturationResult Saturate(SaturationProblem problem)
    {
        ArgumentNullException.ThrowIfNull(problem);

        var reached = new HashSet<FactKey>();
        var agenda = new Queue<FactKey>();
        foreach (var fact in problem.InitialFacts)
        {
            if (reached.Add(fact))
            {
                agenda.Enqueue(fact);
            }
        }

        foreach (var rule in problem.Rules)
        {
            if (rule.Premises.Count == 0 && reached.Add(rule.Conclusion))
            {
                agenda.Enqueue(rule.Conclusion);
            }
        }

        while (agenda.Count != 0)
        {
            _ = agenda.Dequeue();
            foreach (var rule in problem.Rules)
            {
                if (IsEnabled(rule, reached) && reached.Add(rule.Conclusion))
                {
                    agenda.Enqueue(rule.Conclusion);
                }
            }
        }

        var facts = CanonicalFactTable.Create(problem.Master, reached);
        var edges = new List<SupportEdge>(problem.Initial.Count + problem.Rules.Count);

        foreach (var edge in problem.Initial)
        {
            edges.Add(new SupportEdge(
                Resolve(facts, problem.InitialFacts[edge.ConclusionOrdinal]),
                edge.RuleId,
                ResolvePremises(facts, problem.InitialFacts, edge.PremiseOrdinals),
                edge.Parameters,
                edge.OccurrenceOrdinals));
        }

        foreach (var rule in problem.Rules)
        {
            if (!IsEnabled(rule, reached))
            {
                continue;
            }

            edges.Add(new SupportEdge(
                Resolve(facts, rule.Conclusion),
                rule.RuleId,
                ResolvePremises(facts, rule.Premises),
                rule.Parameters,
                rule.OccurrenceOrdinals));
        }

        var graph = SupportHypergraph.Create(facts, problem.Occurrences, edges);
        return new SaturationResult(problem, graph);
    }

    private static bool IsEnabled(GroundRule rule, HashSet<FactKey> reached)
    {
        foreach (var premise in rule.Premises)
        {
            if (!reached.Contains(premise))
            {
                return false;
            }
        }

        return true;
    }

    private static int Resolve(CanonicalFactTable facts, FactKey key)
    {
        if (!facts.TryGetOrdinal(key, out var ordinal))
        {
            throw new InvalidOperationException($"Reached fact '{key}' is absent from the final table.");
        }

        return ordinal;
    }

    private static int[] ResolvePremises(
        CanonicalFactTable target,
        CanonicalFactTable source,
        IReadOnlyList<int> sourceOrdinals)
    {
        var resolved = new int[sourceOrdinals.Count];
        for (var i = 0; i < sourceOrdinals.Count; i++)
        {
            resolved[i] = Resolve(target, source[sourceOrdinals[i]]);
        }

        return resolved;
    }

    private static int[] ResolvePremises(
        CanonicalFactTable target,
        IReadOnlyList<FactKey> premises)
    {
        var resolved = new int[premises.Count];
        for (var i = 0; i < premises.Count; i++)
        {
            resolved[i] = Resolve(target, premises[i]);
        }

        return resolved;
    }
}
