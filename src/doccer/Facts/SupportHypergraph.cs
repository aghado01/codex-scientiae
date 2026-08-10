using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>
/// One immutable supplied support edge (D43): a conclusion fact ordinal, a required rule ID, and
/// ordered premise-fact, parameter, and originating-occurrence tuples. Order is significant and
/// duplicates are preserved inside one edge. An edge is supplied evidence, not an executable
/// callback and not a claim that Doccer has verified the adapter's domain reasoning; ordinals
/// resolve only against the exact bases retained by a <see cref="SupportHypergraph"/>.
/// </summary>
public sealed class SupportEdge : IEquatable<SupportEdge>
{
    private readonly int[] _premises;
    private readonly string[] _parameters;
    private readonly int[] _occurrences;
    private readonly ReadOnlyCollection<int> _premiseView;
    private readonly ReadOnlyCollection<string> _parameterView;
    private readonly ReadOnlyCollection<int> _occurrenceView;

    public SupportEdge(
        int conclusionOrdinal,
        string ruleId,
        IEnumerable<int> premiseOrdinals,
        IEnumerable<string> parameters,
        IEnumerable<int> occurrenceOrdinals)
    {
        if (conclusionOrdinal < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(conclusionOrdinal));
        }

        if (string.IsNullOrWhiteSpace(ruleId))
        {
            throw new ArgumentException("A support rule ID is required.", nameof(ruleId));
        }

        ArgumentNullException.ThrowIfNull(premiseOrdinals);
        ArgumentNullException.ThrowIfNull(parameters);
        ArgumentNullException.ThrowIfNull(occurrenceOrdinals);

        ConclusionOrdinal = conclusionOrdinal;
        RuleId = ruleId;

        // Snapshot every tuple: order and duplicates are significant, and a caller's sequence
        // must not be able to mutate the edge after construction.
        var collectedPremises = new List<int>();
        foreach (var ordinal in premiseOrdinals)
        {
            if (ordinal < 0)
            {
                throw new ArgumentOutOfRangeException(nameof(premiseOrdinals), ordinal, "Premise ordinals must be non-negative.");
            }

            collectedPremises.Add(ordinal);
        }

        var collectedParameters = new List<string>();
        foreach (var parameter in parameters)
        {
            if (parameter is null)
            {
                throw new ArgumentException("Support parameters must be non-null strings.", nameof(parameters));
            }

            collectedParameters.Add(parameter);
        }

        var collectedOccurrences = new List<int>();
        foreach (var ordinal in occurrenceOrdinals)
        {
            if (ordinal < 0)
            {
                throw new ArgumentOutOfRangeException(nameof(occurrenceOrdinals), ordinal, "Occurrence ordinals must be non-negative.");
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

    public int ConclusionOrdinal { get; }

    public string RuleId { get; }

    /// <summary>Ordered premise fact ordinals; the empty tuple is a zero-arity seed.</summary>
    public IReadOnlyList<int> PremiseOrdinals => _premiseView;

    /// <summary>Ordered rule parameter strings.</summary>
    public IReadOnlyList<string> Parameters => _parameterView;

    /// <summary>Ordered originating occurrence ordinals into the retained exact batch.</summary>
    public IReadOnlyList<int> OccurrenceOrdinals => _occurrenceView;

    public bool Equals(SupportEdge? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        if (other is null ||
            ConclusionOrdinal != other.ConclusionOrdinal ||
            !StringComparer.Ordinal.Equals(RuleId, other.RuleId) ||
            !_premises.AsSpan().SequenceEqual(other._premises) ||
            _parameters.Length != other._parameters.Length ||
            !_occurrences.AsSpan().SequenceEqual(other._occurrences))
        {
            return false;
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

    public override bool Equals(object? obj) => obj is SupportEdge other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(ConclusionOrdinal);
        hash.Add(RuleId, StringComparer.Ordinal);
        foreach (var ordinal in _premises)
        {
            hash.Add(ordinal);
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
        $"{RuleId}: [{string.Join(",", _premises)}] => #{ConclusionOrdinal}";

    /// <summary>
    /// The canonical representational edge order: conclusion, rule, premise tuple, parameter
    /// tuple, then occurrence tuple. Zero exactly when the edges are value-equal.
    /// </summary>
    internal static int CompareCanonical(SupportEdge left, SupportEdge right)
    {
        var comparison = left.ConclusionOrdinal.CompareTo(right.ConclusionOrdinal);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = string.CompareOrdinal(left.RuleId, right.RuleId);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = CompareTuple(left._premises, right._premises);
        if (comparison != 0)
        {
            return comparison;
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
/// Alternative and joint support over one exact fact/occurrence basis (D43): one exact
/// <see cref="CanonicalFactTable"/> reference, one exact frozen compatible-master
/// <see cref="SpanBatch"/>, and an immutable set of structurally validated
/// <see cref="SupportEdge"/> values. Exact duplicate edges collapse; a different rule, premise
/// path, parameter tuple, or occurrence tuple remains an alternative support for the same
/// conclusion. Cycles and self-support are representable, and K5a promises structural
/// well-formedness only — K5b owns rule execution and any derived-support completeness claim.
/// </summary>
public sealed class SupportHypergraph : IReadOnlyList<SupportEdge>
{
    private readonly SupportEdge[] _edges;

    private SupportHypergraph(CanonicalFactTable facts, SpanBatch occurrences, SupportEdge[] edges)
    {
        Facts = facts;
        Occurrences = occurrences;
        _edges = edges;
    }

    /// <summary>The exact retained fact table every fact ordinal resolves against.</summary>
    public CanonicalFactTable Facts { get; }

    /// <summary>The exact retained occurrence basis every occurrence ordinal resolves against.</summary>
    public SpanBatch Occurrences { get; }

    public TextMaster Master => Facts.Master;

    public int Count => _edges.Length;

    public bool IsEmpty => _edges.Length == 0;

    public SupportEdge this[int index]
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

    /// <summary>
    /// Validates every edge against the exact bases and collapses exact duplicate edges.
    /// Enumeration uses the canonical conclusion/rule/premise/parameter/occurrence order
    /// independent of supply order.
    /// </summary>
    public static SupportHypergraph Create(
        CanonicalFactTable facts,
        SpanBatch occurrences,
        IEnumerable<SupportEdge> edges)
    {
        ArgumentNullException.ThrowIfNull(facts);
        ArgumentNullException.ThrowIfNull(occurrences);
        ArgumentNullException.ThrowIfNull(edges);
        facts.Master.EnsureCompatibleWith(occurrences.Master);

        var collected = new List<SupportEdge>();
        foreach (var edge in edges)
        {
            if (edge is null)
            {
                throw new ArgumentException("Support edges must be non-null.", nameof(edges));
            }

            EnsureFactOrdinal(facts, edge.ConclusionOrdinal, edge, "conclusion");
            foreach (var premise in edge.PremiseOrdinals)
            {
                EnsureFactOrdinal(facts, premise, edge, "premise");
            }

            foreach (var occurrence in edge.OccurrenceOrdinals)
            {
                if (occurrence >= occurrences.Count)
                {
                    throw new ArgumentException(
                        $"Support edge '{edge}' occurrence ordinal #{occurrence} is outside the exact occurrence batch of {occurrences.Count}.",
                        nameof(edges));
                }
            }

            collected.Add(edge);
        }

        collected.Sort(SupportEdge.CompareCanonical);
        var distinct = new List<SupportEdge>(collected.Count);
        foreach (var edge in collected)
        {
            if (distinct.Count == 0 || SupportEdge.CompareCanonical(distinct[^1], edge) != 0)
            {
                distinct.Add(edge);
            }
        }

        return new SupportHypergraph(facts, occurrences, distinct.ToArray());
    }

    /// <summary>
    /// Returns the retained supports concluding at one fact, in canonical edge order. A fact with
    /// no support edge is a legal answer, not a defect.
    /// </summary>
    public IReadOnlyList<SupportEdge> SupportsOf(int conclusionOrdinal)
    {
        if ((uint)conclusionOrdinal >= (uint)Facts.Count)
        {
            throw new ArgumentOutOfRangeException(nameof(conclusionOrdinal));
        }

        var supports = new List<SupportEdge>();
        foreach (var edge in _edges)
        {
            if (edge.ConclusionOrdinal == conclusionOrdinal)
            {
                supports.Add(edge);
            }
        }

        return supports.AsReadOnly();
    }

    public IEnumerator<SupportEdge> GetEnumerator() =>
        ((IEnumerable<SupportEdge>)_edges).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    private static void EnsureFactOrdinal(
        CanonicalFactTable facts,
        int ordinal,
        SupportEdge edge,
        string role)
    {
        if (ordinal >= facts.Count)
        {
            throw new ArgumentException(
                $"Support edge '{edge}' {role} fact ordinal #{ordinal} is outside the exact fact table of {facts.Count}.",
                "edges");
        }
    }
}
