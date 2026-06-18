using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace Graphs.Distance;

/// <summary>
/// Distance-metric contract for the vendored HDBSCAN. Struct-generic so the JIT
/// inlines the per-edge weight in the MST hot loop. This is the closed-form trim
/// of the SPCX metric: just the two Distance overloads the algorithm calls. The
/// full SPCX interface also exposes MetricProperties (bandwidth/geometry/bounds
/// metadata) which layout clustering doesn't consume — left behind on purpose.
/// </summary>
public interface IDistanceMetric
{
    double Distance(ReadOnlySpan<double> a, ReadOnlySpan<double> b);

    double Distance(ref double a, ref double b, int dim)
        => Distance(
            MemoryMarshal.CreateReadOnlySpan(ref a, dim),
            MemoryMarshal.CreateReadOnlySpan(ref b, dim));
}

/// <summary>
/// Plain L2. The closed-form metric for 2-D layout point clouds (bbox centroids).
/// </summary>
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
}
