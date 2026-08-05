using System;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>
/// A named caller-supplied compatibility rule for strict stack pairing. Open and close roles are
/// supplied separately as exact <see cref="ClaimSelection"/> values; this policy owns only the
/// meaning of a compatible opener/closer pair. The result retains this exact policy object as its
/// execution stamp.
/// </summary>
public sealed class PairingPolicy
{
    private readonly Func<SpanRecord, SpanRecord, bool> _compatibility;

    public PairingPolicy(
        string name,
        Func<SpanRecord, SpanRecord, bool> compatibility)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A pairing policy name is required.", nameof(name));
        }

        Name = name;
        _compatibility = compatibility ?? throw new ArgumentNullException(nameof(compatibility));
    }

    /// <summary>The caller's stable diagnostic name for this compatibility rule.</summary>
    public string Name { get; }

    /// <summary>Constructs a policy whose opener and closer keys must compare equal.</summary>
    public static PairingPolicy ByKey<TKey>(
        string name,
        Func<SpanRecord, TKey> key,
        IEqualityComparer<TKey>? comparer = null)
    {
        ArgumentNullException.ThrowIfNull(key);
        var equality = comparer ?? EqualityComparer<TKey>.Default;
        return new PairingPolicy(
            name,
            (opener, closer) => equality.Equals(key(opener), key(closer)));
    }

    /// <summary>Evaluates the caller-supplied rule for one top-opener/closer comparison.</summary>
    public bool IsCompatible(SpanRecord opener, SpanRecord closer) =>
        _compatibility(opener, closer);
}

/// <summary>
/// Complete identity-bearing residue from one pairing execution. Unary populations remain exact
/// <see cref="ClaimSelection"/> values; incompatible top-opener/closer evidence additionally
/// remains an exact <see cref="ClaimPairView"/>.
/// </summary>
public sealed class PairingFaults
{
    internal PairingFaults(
        ClaimSelection unclosedOpens,
        ClaimSelection danglingCloses,
        ClaimPairView mismatchedPairs)
    {
        UnclosedOpens = unclosedOpens;
        DanglingCloses = danglingCloses;
        MismatchedPairs = mismatchedPairs;
        MismatchedOpens = mismatchedPairs.ProjectLeft();
        MismatchedCloses = mismatchedPairs.ProjectRight();
        OpenResidue = unclosedOpens.Union(MismatchedOpens);
        CloseResidue = danglingCloses.Union(MismatchedCloses);
    }

    /// <summary>Open occurrences left on the stack after the final token.</summary>
    public ClaimSelection UnclosedOpens { get; }

    /// <summary>Close occurrences encountered while the stack was empty.</summary>
    public ClaimSelection DanglingCloses { get; }

    /// <summary>
    /// Incompatible top-opener/closer pairs. Both endpoints are consumed into fault residue; the
    /// reference policy never searches below the top opener for a compatible alternative.
    /// </summary>
    public ClaimPairView MismatchedPairs { get; }

    public ClaimSelection MismatchedOpens { get; }

    public ClaimSelection MismatchedCloses { get; }

    /// <summary>Every unmatched open occurrence, partitioned by unclosed versus mismatched.</summary>
    public ClaimSelection OpenResidue { get; }

    /// <summary>Every unmatched close occurrence, partitioned by dangling versus mismatched.</summary>
    public ClaimSelection CloseResidue { get; }

    public bool IsEmpty => OpenResidue.IsEmpty && CloseResidue.IsEmpty;
}

/// <summary>
/// The basis- and policy-stamped output of one strict stack pairing. Every considered opener and
/// closer is either an endpoint of <see cref="MatchEdges"/> or belongs to the corresponding unary
/// fault residue; matching performs no repair and implies neither containment nor parenthood.
/// </summary>
public sealed class PairingResult
{
    internal PairingResult(
        ClaimSelection openInput,
        ClaimSelection closeInput,
        PairingPolicy policy,
        ClaimPairView matchEdges,
        PairingFaults faults)
    {
        OpenInput = openInput;
        CloseInput = closeInput;
        Policy = policy;
        MatchEdges = matchEdges;
        Faults = faults;
    }

    public TextMaster Master => OpenInput.Master;

    /// <summary>The exact occurrence population assigned the open role.</summary>
    public ClaimSelection OpenInput { get; }

    /// <summary>The exact occurrence population assigned the close role.</summary>
    public ClaimSelection CloseInput { get; }

    /// <summary>The exact named compatibility policy object used for this execution.</summary>
    public PairingPolicy Policy { get; }

    /// <summary>
    /// Accepted opener/closer edges over the two exact input bases. Strict stack execution makes
    /// these edges forward, partial one-to-one, and noncrossing.
    /// </summary>
    public ClaimPairView MatchEdges { get; }

    public PairingFaults Faults { get; }

    /// <summary>
    /// Forgets occurrence identity by projecting each accepted edge to the closed envelope from
    /// the opener's start through the closer's end and normalizing those envelopes as a
    /// <see cref="SpanSet"/>. Nested, overlapping, or adjacent envelopes may therefore collapse.
    /// </summary>
    public SpanSet PairedRegions()
    {
        if (MatchEdges.IsEmpty)
        {
            return SpanSet.Empty(Master);
        }

        var regions = new TextSpan[MatchEdges.Count];
        var index = 0;
        foreach (var edge in MatchEdges)
        {
            var opener = MatchEdges.LeftBasis[edge.LeftOrdinal].Span;
            var closer = MatchEdges.RightBasis[edge.RightOrdinal].Span;
            regions[index++] = new TextSpan(opener.Start, closer.End);
        }

        return SpanSet.Create(Master, regions);
    }
}

/// <summary>
/// Reference strict stack pairing over a finite, non-overlapping token stream. Role populations
/// and compatibility meaning are caller inputs; stack discipline and complete residue are engine
/// semantics.
/// </summary>
public static class Pairing
{
    /// <summary>
    /// Pairs exact open and close selections in geometric token order. Selected token spans must
    /// be pairwise non-overlapping across both populations, so reading order is intrinsic rather
    /// than manufactured by a role or insertion-order tie-break. On a closer, the top opener is
    /// consumed: compatible endpoints become a match; incompatible endpoints become mismatch
    /// evidence. An empty stack yields a dangling closer, and remaining openers are unclosed.
    /// </summary>
    public static PairingResult Pair(
        ClaimSelection opens,
        ClaimSelection closes,
        PairingPolicy policy)
    {
        ArgumentNullException.ThrowIfNull(opens);
        ArgumentNullException.ThrowIfNull(closes);
        ArgumentNullException.ThrowIfNull(policy);
        opens.Master.EnsureCompatibleWith(closes.Master);
        EnsureDistinctRoles(opens, closes);

        var tokens = new List<PairingToken>(opens.Count + closes.Count);
        foreach (var ordinal in opens)
        {
            tokens.Add(new PairingToken(true, ordinal, opens.Basis[ordinal].Span));
        }

        foreach (var ordinal in closes)
        {
            tokens.Add(new PairingToken(false, ordinal, closes.Basis[ordinal].Span));
        }

        tokens.Sort(CompareTokens);
        EnsureStrictTokenOrder(tokens);

        var stack = new Stack<int>();
        var matches = new List<(int LeftOrdinal, int RightOrdinal)>();
        var mismatches = new List<(int LeftOrdinal, int RightOrdinal)>();
        var danglingCloses = new List<int>();

        foreach (var token in tokens)
        {
            if (token.IsOpen)
            {
                stack.Push(token.Ordinal);
                continue;
            }

            if (stack.Count == 0)
            {
                danglingCloses.Add(token.Ordinal);
                continue;
            }

            var openOrdinal = stack.Pop();
            if (policy.IsCompatible(opens.Basis[openOrdinal], closes.Basis[token.Ordinal]))
            {
                matches.Add((openOrdinal, token.Ordinal));
            }
            else
            {
                mismatches.Add((openOrdinal, token.Ordinal));
            }
        }

        var unclosedOpens = new List<int>(stack.Count);
        while (stack.Count > 0)
        {
            unclosedOpens.Add(stack.Pop());
        }

        var matchEdges = ClaimPairView.Create(opens.Basis, closes.Basis, matches);
        var mismatchPairs = ClaimPairView.Create(opens.Basis, closes.Basis, mismatches);
        var faults = new PairingFaults(
            ClaimSelection.Create(opens.Basis, unclosedOpens),
            ClaimSelection.Create(closes.Basis, danglingCloses),
            mismatchPairs);

        return new PairingResult(opens, closes, policy, matchEdges, faults);
    }

    private static void EnsureDistinctRoles(ClaimSelection opens, ClaimSelection closes)
    {
        if (!ReferenceEquals(opens.Basis, closes.Basis))
        {
            return;
        }

        foreach (var ordinal in opens)
        {
            if (closes.Contains(ordinal))
            {
                throw new ArgumentException(
                    "One occurrence cannot belong to both open and close role selections.",
                    nameof(closes));
            }
        }
    }

    private static void EnsureStrictTokenOrder(IReadOnlyList<PairingToken> tokens)
    {
        for (var i = 1; i < tokens.Count; i++)
        {
            if (tokens[i - 1].Span.End > tokens[i].Span.Start)
            {
                throw new InvalidOperationException(
                    "Selected pairing tokens overlap; strict stack order requires one non-overlapping token stream.");
            }
        }
    }

    private static int CompareTokens(PairingToken left, PairingToken right)
    {
        var comparison = left.Span.Start.CompareTo(right.Span.Start);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = left.Span.End.CompareTo(right.Span.End);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = left.IsOpen.CompareTo(right.IsOpen);
        return comparison != 0 ? comparison : left.Ordinal.CompareTo(right.Ordinal);
    }

    private readonly record struct PairingToken(bool IsOpen, int Ordinal, TextSpan Span);
}
