using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>
/// The result of one gap-cadence measurement — a basis-stamped derived measure (D21): it answers
/// "over what was I computed" with the source batch, its master, the declared window, the
/// declared address unit, and the exact population measured. Statistics are facts, present
/// whenever they are defined; meaning thresholds (how many occurrences make a cadence
/// trustworthy, what cv counts as "evenly spaced") belong to consumers, never here (D10).
/// </summary>
public sealed class GapCadenceMeasure
{
    internal GapCadenceMeasure(
        ClaimSelection population,
        TextSpan window,
        ReadOnlyCollection<int> ordinals,
        int? medianGap,
        double? meanGap,
        double? gapCv,
        double? spanFraction)
    {
        Population = population;
        Window = window;
        Ordinals = ordinals;
        MedianGap = medianGap;
        MeanGap = meanGap;
        GapCv = gapCv;
        SpanFraction = spanFraction;
    }

    /// <summary>The exact measured occurrence population, before query-order projection.</summary>
    public ClaimSelection Population { get; }

    public SpanBatch Source => Population.Basis;

    public TextMaster Master => Source.Master;

    /// <summary>The declared denominator basis, in master coordinates.</summary>
    public TextSpan Window { get; }

    /// <summary>The declared measurement unit — mdnav measured bytes; doccer says what it measures.</summary>
    public AddressUnit Unit => Master.AddressUnit;

    /// <summary>
    /// The measured population as ordinals into the source batch, in deterministic start order
    /// (start ascending, end descending, then ordinal). This is the exclusion record: what the
    /// caller's predicate and the window admission actually kept, as checkable evidence rather
    /// than a lost delegate.
    /// </summary>
    public IReadOnlyList<int> Ordinals { get; }

    /// <summary>Number of successive-start gaps: population size minus one, floored at zero.</summary>
    public int GapCount => Math.Max(0, Ordinals.Count - 1);

    /// <summary>
    /// Upper median of the gaps (the mdnav template convention — stays in the integer value
    /// domain, no averaging). Null when there are no gaps.
    /// </summary>
    public int? MedianGap { get; }

    public double? MeanGap { get; }

    /// <summary>
    /// Coefficient of variation of the gaps (population standard deviation over mean; 0 when
    /// the mean is 0, per the template). Near zero means evenly spaced — the population is
    /// partitioning the window; large means bursty. Where "near" and "large" begin is the
    /// consumer's judgment.
    /// </summary>
    public double? GapCv { get; }

    /// <summary>
    /// (last start − first start) / window length: how much of the window the population's
    /// occurrences stretch across. Null when fewer than two claims were measured.
    /// </summary>
    public double? SpanFraction { get; }
}

/// <summary>
/// Gap cadence — the first individually named density measure (D8; contract D23), transcribed
/// from the mdnav profiler's cadence facts. The name pins the semantics: gaps are measured
/// between successive claim <b>starts</b>. An end-to-start interstice measure would be a
/// separate named measure, never a parameter — named measures carry no semantic knobs.
/// </summary>
public static class GapCadence
{
    /// <summary>
    /// Measures the start-to-start gap cadence of a claim population. Every D8 component is
    /// declared: the numerator facts are the gap statistics; the denominator basis is
    /// <paramref name="window"/> (default: the master extent), whose length divides the span
    /// fraction; the boundary policy is start-anchoring — the window admits a claim iff its
    /// span starts within the window; exclusions may arrive through the caller's
    /// <paramref name="include"/> predicate convenience, which is converted to an exact selection
    /// and recorded on the result as both its population and ordered ordinals.
    /// </summary>
    public static GapCadenceMeasure Measure(
        SpanBatch batch,
        Func<SpanRecord, bool>? include = null,
        TextSpan? window = null)
    {
        ArgumentNullException.ThrowIfNull(batch);
        var selection = include is null
            ? ClaimSelection.All(batch)
            : ClaimSelection.FromPredicate(batch, include);
        return Measure(selection, window);
    }

    /// <summary>
    /// Measures one exact occurrence selection. Window admission may narrow the input selection;
    /// the exact admitted set is retained as <see cref="GapCadenceMeasure.Population"/> and its
    /// start-ordered projection is retained as <see cref="GapCadenceMeasure.Ordinals"/>.
    /// </summary>
    public static GapCadenceMeasure Measure(
        ClaimSelection selection,
        TextSpan? window = null)
    {
        ArgumentNullException.ThrowIfNull(selection);
        var batch = selection.Basis;
        var extent = window ?? batch.Master.Extent;
        batch.Master.ValidateSpan(extent);

        var admitted = new List<int>();
        foreach (var ordinal in selection)
        {
            var record = batch[ordinal];
            if (record.Span.Start < extent.Start || record.Span.Start >= extent.End)
            {
                continue;
            }

            admitted.Add(ordinal);
        }

        var population = ClaimSelection.Create(batch, admitted);

        // Deterministic start order regardless of insertion order: start ascending, end
        // descending, then ordinal — the same total order the sorted lookup uses.
        admitted.Sort((left, right) => ClaimOrdering.Compare(batch, left, right, ClaimOrder.Geometry));

        int? medianGap = null;
        double? meanGap = null;
        double? gapCv = null;
        double? spanFraction = null;
        if (admitted.Count >= 2)
        {
            var gaps = new int[admitted.Count - 1];
            for (var i = 1; i < admitted.Count; i++)
            {
                gaps[i - 1] = batch.Starts[admitted[i]] - batch.Starts[admitted[i - 1]];
            }

            double sum = 0;
            foreach (var gap in gaps)
            {
                sum += gap;
            }

            var mean = sum / gaps.Length;
            double squares = 0;
            foreach (var gap in gaps)
            {
                squares += (gap - mean) * (gap - mean);
            }

            var deviation = Math.Sqrt(squares / gaps.Length);

            var sorted = (int[])gaps.Clone();
            Array.Sort(sorted);
            medianGap = sorted[sorted.Length / 2];
            meanGap = mean;
            gapCv = mean != 0 ? deviation / mean : 0;
            // A two-member population implies a non-empty window, so the division is safe.
            spanFraction =
                (batch.Starts[admitted[^1]] - batch.Starts[admitted[0]]) / (double)extent.Length;
        }

        return new GapCadenceMeasure(
            population,
            extent,
            admitted.AsReadOnly(),
            medianGap,
            meanGap,
            gapCv,
            spanFraction);
    }
}
