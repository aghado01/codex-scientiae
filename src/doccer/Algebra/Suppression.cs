using System;

namespace CodexSci.Doccer;

/// <summary>
/// Named suppression queries: derived region sets computed from claims a caller nominates as
/// suppressors.
/// </summary>
/// <remarks>
/// <para>
/// Suppression is a query policy, never a claim property. No claim carries <c>is_mask</c> or any
/// equivalent flag, because whether a claim suppresses is not a fact about the claim — it is the
/// caller's question. One code-block claim suppresses heading recognition under one query and is
/// the primary target of a language collector under the next, and both readings must remain
/// available from the same batch. The engine therefore executes whichever suppression the caller
/// names, through the predicate, and never selects one.
/// </para>
/// <para>
/// These are compositions over primitives that already exist: <see cref="ClaimSelection.Coverage"/>
/// to derive the suppressed region and <see cref="SpanSet"/> algebra to take its complement.
/// Nothing here is new mechanism, and callers may compose further in the same algebra — several
/// suppressors union their excluded regions, and narrowing to an existing region is an intersection
/// with it. A precomputed "suppression bitmap", as sketched in the legwork, would be an
/// acceleration of exactly this query: same results, different representation, still never a
/// property stored on a claim.
/// </para>
/// </remarks>
public static class Suppression
{
    /// <summary>
    /// The region the nominated suppressors cover: the normalized union of their spans.
    /// </summary>
    /// <param name="batch">The claim set to select suppressors from.</param>
    /// <param name="suppressor">Names which claims suppress. This is the caller's policy.</param>
    public static SpanSet Excluded(SpanBatch batch, Func<SpanRecord, bool> suppressor)
    {
        ArgumentNullException.ThrowIfNull(batch);
        ArgumentNullException.ThrowIfNull(suppressor);
        return Excluded(ClaimSelection.FromPredicate(batch, suppressor));
    }

    /// <summary>The normalized region covered by an exact suppressor occurrence selection.</summary>
    public static SpanSet Excluded(ClaimSelection suppressors)
    {
        ArgumentNullException.ThrowIfNull(suppressors);
        return suppressors.Coverage();
    }

    /// <summary>
    /// The region left open by the nominated suppressors: the master extent minus
    /// <c>Excluded</c>. This is the set to hand a scoped collector so that recognition runs
    /// only where the suppressors permit and no match can bridge a suppressed gap.
    /// </summary>
    /// <param name="batch">The claim set to select suppressors from.</param>
    /// <param name="suppressor">Names which claims suppress. This is the caller's policy.</param>
    public static SpanSet Admitted(SpanBatch batch, Func<SpanRecord, bool> suppressor) =>
        Excluded(batch, suppressor).Complement();

    /// <summary>The master extent left open by an exact suppressor occurrence selection.</summary>
    public static SpanSet Admitted(ClaimSelection suppressors) =>
        Excluded(suppressors).Complement();
}
