using System;
using System.Collections.Generic;

namespace CodexSci.Hdbscan;

/// <summary>
/// External clustering-quality scores comparing a predicted labelling against ground
/// truth: Purity, NMI (arithmetic-normalized), Adjusted Rand Index, Homogeneity,
/// Completeness, and V-measure. Definitions match scikit-learn's <c>sklearn.metrics</c>
/// so every score is cross-checkable against a trusted reference implementation — that
/// cross-checkability is the point: these are the ruler used to test the clustering, so
/// the ruler is pinned to a known standard and unit-tested against hand-derived values.
///
/// Labels are consumed verbatim: HDBSCAN noise (label −1) is treated as its own cluster,
/// exactly as <c>sklearn.metrics</c> would (the CLI reports noise_count separately). All
/// six scores are ratios or pair-counts, so the mutual-information log base cancels —
/// natural log is used internally.
/// </summary>
public static class ClusterEvaluators
{
    /// <summary>Computes all six scores from equal-length integer label arrays.</summary>
    public static EvaluatorScores Compute(ReadOnlySpan<int> truth, ReadOnlySpan<int> pred)
    {
        if (truth.Length != pred.Length)
            throw new ArgumentException("truth and pred must have equal length.");
        int n = truth.Length;
        if (n == 0) return new EvaluatorScores(0, 0, 0, 0, 0, 0);

        // Dense-encode both labelings into contiguous row/column indices.
        var rowOf = new Dictionary<int, int>();
        var colOf = new Dictionary<int, int>();
        for (int i = 0; i < n; i++)
        {
            if (!rowOf.ContainsKey(truth[i])) rowOf[truth[i]] = rowOf.Count;
            if (!colOf.ContainsKey(pred[i]))  colOf[pred[i]]  = colOf.Count;
        }
        int R = rowOf.Count, C = colOf.Count;

        var cont = new long[R * C];   // contingency table (rows = truth, cols = pred)
        var a    = new long[R];       // truth class sizes
        var b    = new long[C];       // predicted cluster sizes
        for (int i = 0; i < n; i++)
        {
            int r = rowOf[truth[i]];
            int c = colOf[pred[i]];
            cont[r * C + c]++;
            a[r]++;
            b[c]++;
        }

        double nD = n;

        // Purity: Σ_c max_r cont[r,c] / n
        long puritySum = 0;
        for (int c = 0; c < C; c++)
        {
            long best = 0;
            for (int r = 0; r < R; r++)
            {
                long v = cont[r * C + c];
                if (v > best) best = v;
            }
            puritySum += best;
        }
        double purity = puritySum / nD;

        // Entropies (nats) and mutual information.
        double hC = Entropy(a, nD);
        double hK = Entropy(b, nD);
        double mi = 0.0;
        for (int r = 0; r < R; r++)
        {
            long ar = a[r];
            for (int c = 0; c < C; c++)
            {
                long nij = cont[r * C + c];
                if (nij == 0) continue;
                // (nij/n) · ln( (nij·n) / (a_r·b_c) )
                mi += (nij / nD) * Math.Log((nij * nD) / ((double)ar * b[c]));
            }
        }
        if (mi < 0.0) mi = 0.0;   // clamp floating-point noise

        double homogeneity  = hC > 0.0 ? Clamp01(mi / hC) : 1.0;
        double completeness = hK > 0.0 ? Clamp01(mi / hK) : 1.0;
        double vMeasure = (homogeneity + completeness) > 0.0
            ? 2.0 * homogeneity * completeness / (homogeneity + completeness)
            : 0.0;

        double denom = (hC + hK) / 2.0;                 // arithmetic normalizer (sklearn default)
        double nmi = denom > 0.0 ? Clamp01(mi / denom) : 1.0;   // both single-label → perfect agreement

        double ari = AdjustedRandIndex(cont, a, b, R, C, n);

        return new EvaluatorScores(purity, nmi, ari, homogeneity, completeness, vMeasure);
    }

    private static double Entropy(long[] counts, double n)
    {
        double h = 0.0;
        for (int i = 0; i < counts.Length; i++)
        {
            long c = counts[i];
            if (c == 0) continue;
            double p = c / n;
            h -= p * Math.Log(p);
        }
        return h;
    }

    /// <summary>
    /// Pair-counting Adjusted Rand Index — the exact form of
    /// <c>sklearn.metrics.adjusted_rand_score</c>, including its perfect-agreement
    /// short-circuit. Computed via the pair-confusion counts (tp/fp/fn/tn) so it is
    /// numerically identical to sklearn rather than an algebraically-equivalent rewrite.
    /// </summary>
    private static double AdjustedRandIndex(long[] cont, long[] a, long[] b, int R, int C, int n)
    {
        long tp = 0;
        for (int i = 0; i < cont.Length; i++) tp += Comb2(cont[i]);   // pairs together in BOTH
        long tpFp = 0; for (int c = 0; c < C; c++) tpFp += Comb2(b[c]); // pairs together in pred
        long tpFn = 0; for (int r = 0; r < R; r++) tpFn += Comb2(a[r]); // pairs together in truth
        long total = Comb2(n);
        long fp = tpFp - tp;
        long fn = tpFn - tp;
        long tn = total - tp - fp - fn;

        if (fp == 0 && fn == 0) return 1.0;   // identical partitions (0/0 guard)
        double num = 2.0 * ((double)tp * tn - (double)fn * fp);
        double den = (double)(tp + fn) * (fn + tn) + (double)(tp + fp) * (fp + tn);
        return den == 0.0 ? 0.0 : num / den;
    }

    private static long Comb2(long k) => k < 2 ? 0 : k * (k - 1) / 2;

    private static double Clamp01(double v) => v < 0.0 ? 0.0 : (v > 1.0 ? 1.0 : v);
}

/// <summary>
/// External evaluator scores (all sklearn-compatible). Higher is better; ARI can be
/// negative (worse than chance). Emitted as summary.json's <c>evaluator_scores</c> block
/// when the input carries ground-truth labels. V-measure is provably identical to the
/// arithmetic NMI — a built-in consistency check.
/// </summary>
public readonly record struct EvaluatorScores(
    double Purity,
    double Nmi,
    double Ari,
    double Homogeneity,
    double Completeness,
    double VMeasure);
