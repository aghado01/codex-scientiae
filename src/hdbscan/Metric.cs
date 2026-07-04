using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace CodexSci.Hdbscan;

/// <summary>
/// Struct-generic distance contract for the clustering engine. Metrics are value types
/// so <see cref="HdbscanRunner.Run{TMetric}"/> and the MST hot loop inline the per-edge
/// weight with no virtual dispatch. Both overloads are abstract (deliberately NOT a
/// default interface method): a DIM would box the struct on a constrained generic call
/// and defeat the whole point of the value-type design, so every metric supplies the
/// <c>ref</c>-based form the implicit Prim loop calls directly.
/// </summary>
public interface IDistanceMetric
{
    /// <summary>Distance between two equal-length feature vectors.</summary>
    double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b);

    /// <summary>
    /// Distance between two <paramref name="dim"/>-length rows addressed by reference.
    /// The MST inner loop calls this form to avoid re-slicing; implementations forward
    /// to the span overload via <c>MemoryMarshal.CreateReadOnlySpan</c>.
    /// </summary>
    double Distance(ref double a, ref double b, int dim);
}

/// <summary>Euclidean (L2). The default metric for planar point clouds (e.g. bbox centroids).</summary>
public readonly struct EuclideanMetric : IDistanceMetric
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b)
    {
        double sum = 0.0;
        for (int i = 0; i < a.Length; i++)
        {
            double d = a[i] - b[i];
            sum += d * d;
        }
        return Math.Sqrt(sum);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ref double a, ref double b, int dim)
        => Distance(MemoryMarshal.CreateReadOnlySpan(ref a, dim),
                    MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}

/// <summary>Manhattan (L1 / city-block): Σ|aᵢ − bᵢ|.</summary>
public readonly struct ManhattanMetric : IDistanceMetric
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b)
    {
        double sum = 0.0;
        for (int i = 0; i < a.Length; i++)
            sum += Math.Abs(a[i] - b[i]);
        return sum;
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ref double a, ref double b, int dim)
        => Distance(MemoryMarshal.CreateReadOnlySpan(ref a, dim),
                    MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}

/// <summary>Chebyshev (L∞): maxᵢ|aᵢ − bᵢ|.</summary>
public readonly struct ChebyshevMetric : IDistanceMetric
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b)
    {
        double m = 0.0;
        for (int i = 0; i < a.Length; i++)
        {
            double d = Math.Abs(a[i] - b[i]);
            if (d > m) m = d;
        }
        return m;
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ref double a, ref double b, int dim)
        => Distance(MemoryMarshal.CreateReadOnlySpan(ref a, dim),
                    MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}

/// <summary>
/// Minkowski of order <c>p ≥ 1</c>: (Σ|aᵢ − bᵢ|ᵖ)^(1/p). p=1 recovers Manhattan, p=2
/// Euclidean; the dedicated structs are faster for those, this covers the general case.
/// </summary>
public readonly struct MinkowskiMetric : IDistanceMetric
{
    private readonly double _p;
    private readonly double _invP;

    public MinkowskiMetric(double p)
    {
        if (!(p >= 1.0))
            throw new ArgumentOutOfRangeException(nameof(p), "Minkowski order p must be >= 1.");
        _p = p;
        _invP = 1.0 / p;
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b)
    {
        double sum = 0.0;
        for (int i = 0; i < a.Length; i++)
            sum += Math.Pow(Math.Abs(a[i] - b[i]), _p);
        return Math.Pow(sum, _invP);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ref double a, ref double b, int dim)
        => Distance(MemoryMarshal.CreateReadOnlySpan(ref a, dim),
                    MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}

/// <summary>
/// Cosine dissimilarity: 1 − (a·b)/(‖a‖‖b‖) ∈ [0, 2]. Not a true metric, but a valid
/// dissimilarity for mutual-reachability density clustering. Zero vectors are treated as
/// coincident (distance 0).
/// </summary>
public readonly struct CosineMetric : IDistanceMetric
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b)
    {
        double dot = 0.0, na = 0.0, nb = 0.0;
        for (int i = 0; i < a.Length; i++)
        {
            dot += a[i] * b[i];
            na  += a[i] * a[i];
            nb  += b[i] * b[i];
        }
        double denom = Math.Sqrt(na) * Math.Sqrt(nb);
        if (denom == 0.0) return 0.0;
        double cos = dot / denom;
        if (cos > 1.0) cos = 1.0; else if (cos < -1.0) cos = -1.0;
        return 1.0 - cos;
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ref double a, ref double b, int dim)
        => Distance(MemoryMarshal.CreateReadOnlySpan(ref a, dim),
                    MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}

/// <summary>
/// Hamming distance: the proportion of components that differ, count(aᵢ ≠ bᵢ) / dim ∈ [0, 1]
/// (scipy convention). Intended for discrete / categorical-encoded vectors — it uses exact
/// equality on the component values, so it is only meaningful when features are discrete.
/// </summary>
public readonly struct HammingMetric : IDistanceMetric
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b)
    {
        if (a.Length == 0) return 0.0;
        int diff = 0;
        for (int i = 0; i < a.Length; i++)
            if (a[i] != b[i]) diff++;
        return (double)diff / a.Length;
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ref double a, ref double b, int dim)
        => Distance(MemoryMarshal.CreateReadOnlySpan(ref a, dim),
                    MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}

/// <summary>
/// Poincaré-ball hyperbolic distance:
///   d(u, v) = arcosh( 1 + 2·‖u − v‖² / ((1 − ‖u‖²)(1 − ‖v‖²)) ).
/// Points are expected in the open unit ball (‖x‖ &lt; 1) — the natural domain of hyperbolic
/// embeddings. For numerical safety near/outside the boundary the (1 − ‖·‖²) factors are
/// floored at a small positive epsilon, so a boundary point yields a large-but-finite
/// distance instead of NaN/∞ rather than corrupting the whole clustering. Sanity identity
/// used in the tests: d(0, x) = 2·artanh(‖x‖) = ln((1 + ‖x‖)/(1 − ‖x‖)).
/// </summary>
public readonly struct PoincareMetric : IDistanceMetric
{
    private const double BoundaryEps = 1e-12;

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b)
    {
        double sqDiff = 0.0, sqA = 0.0, sqB = 0.0;
        for (int i = 0; i < a.Length; i++)
        {
            double d = a[i] - b[i];
            sqDiff += d * d;
            sqA += a[i] * a[i];
            sqB += b[i] * b[i];
        }
        double da = 1.0 - sqA; if (da < BoundaryEps) da = BoundaryEps;
        double db = 1.0 - sqB; if (db < BoundaryEps) db = BoundaryEps;
        double arg = 1.0 + 2.0 * sqDiff / (da * db);
        if (arg < 1.0) arg = 1.0;   // guard the acosh domain against float noise
        return Math.Acosh(arg);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ref double a, ref double b, int dim)
        => Distance(MemoryMarshal.CreateReadOnlySpan(ref a, dim),
                    MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}

/// <summary>
/// Hyperboloid (Lorentz) model of hyperbolic space: points on the upper sheet
/// ⟨x,x⟩_L = −1 (x₀ &gt; 0), with ⟨u,v⟩_L = −u₀v₀ + Σ_{i≥1} uᵢvᵢ. Distance is
/// d(u,v) = arcosh(−⟨u,v⟩_L) = arcosh(u₀v₀ − Σ_{i≥1} uᵢvᵢ); the argument is ≥ 1 on the
/// sheet and floored at 1 for float safety. n-dimensional hyperbolic space uses (n+1)
/// coordinates here — the first is the "time" component — so, unlike Poincaré, hyperboloid
/// data is one column wider than the geometry's intrinsic dimension. Numerically steadier
/// than Poincaré for points far from the origin (no boundary blow-up). Isometric to the
/// Poincaré ball, so the two agree on distance point-for-point (verified in the test harness).
/// </summary>
public readonly struct HyperboloidMetric : IDistanceMetric
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b)
    {
        double s = a[0] * b[0];                                 // u₀v₀
        for (int i = 1; i < a.Length; i++) s -= a[i] * b[i];    // − Σ_{i≥1} uᵢvᵢ
        if (s < 1.0) s = 1.0;                                   // guard the acosh domain
        return Math.Acosh(s);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ref double a, ref double b, int dim)
        => Distance(MemoryMarshal.CreateReadOnlySpan(ref a, dim),
                    MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}

/// <summary>
/// Minimum distance between two axis-aligned bounding boxes — a layout-segmentation
/// dissimilarity, not a point metric. Each vector packs a k-dimensional box as
/// [lo₀…lo_{k−1}, hi₀…hi_{k−1}] (a 2-D bbox is <c>[x0, y0, x1, y1]</c>). Per axis the gap is
/// the interval separation (0 when the intervals overlap); the per-axis gaps combine as the
/// Euclidean corner-to-corner distance √(Σ gapᵢ²) — exactly the nearest-point distance between
/// the boxes. Overlapping boxes are distance 0, so HDBSCAN reads density over white-space gaps:
/// a figure is a dense low-gap blob and stray rules / page furniture fall out as noise. A
/// symmetric non-negative dissimilarity with d(A,A)=0 — all mutual reachability needs (it is not
/// a true metric; that's fine). Anisotropy (vertical vs horizontal gap statistics) is handled
/// upstream by scaling the box coordinates before feeding them: scaling a coordinate is identical
/// to weighting its axis, so the metric itself stays parameter-free.
/// </summary>
public readonly struct RectangleGapMetric : IDistanceMetric
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b)
    {
        int k = a.Length / 2;   // [lo₀…lo_{k−1}, hi₀…hi_{k−1}]
        double sumSq = 0.0;
        for (int i = 0; i < k; i++)
        {
            double gap   = b[i] - a[k + i];   // b entirely above a on axis i
            double other = a[i] - b[k + i];   // a entirely above b on axis i
            if (other > gap) gap = other;
            if (gap < 0.0) gap = 0.0;         // intervals overlap → no gap on this axis
            sumSq += gap * gap;
        }
        return Math.Sqrt(sumSq);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public double Distance(ref double a, ref double b, int dim)
        => Distance(MemoryMarshal.CreateReadOnlySpan(ref a, dim),
                    MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}
