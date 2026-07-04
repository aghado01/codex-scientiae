using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace CodexSci.Hdbscan;

/// <summary>
/// Zero-allocation implicit Prim's MST over the mutual-reachability graph. No edge list is
/// materialised — the dense N×N weight matrix is evaluated on the fly inside the hot loop,
/// which is why Prim (incremental tree growth from a seed) fits: the weights are implicit
/// and cheaper to recompute than to store. Struct-generic over the distance metric so the
/// JIT inlines the per-edge weight with no virtual dispatch in the inner loop.
/// </summary>
public static class Prim
{
    /// <summary>
    /// Computes the minimum spanning tree over the mutual-reachability metric for HDBSCAN.
    /// The weight between two nodes is <c>max(core(u), core(v), metric.Distance(u, v))</c>;
    /// the distance is inlined through the struct-generic <typeparamref name="TMetric"/> so
    /// no virtual dispatch occurs in the inner loop.
    /// </summary>
    /// <param name="data">Flat row-major buffer, length <c>N × dim</c>.</param>
    /// <param name="n">Node count.</param>
    /// <param name="dim">Per-row dimensionality.</param>
    /// <param name="coreDistances">Pre-computed core distance per node; the
    /// mutual-reachability lift. Length ≥ <paramref name="n"/>.</param>
    /// <param name="visited">Caller-owned scratch, length ≥ <paramref name="n"/>;
    /// zero before each call.</param>
    /// <param name="minWeight">Caller-owned scratch, length ≥ <paramref name="n"/>;
    /// fill with <see cref="double.PositiveInfinity"/> before each call.</param>
    /// <param name="parent">Output MST parent indices, length ≥ <paramref name="n"/>;
    /// <c>parent[0]</c> is the root (self-referential).</param>
    /// <param name="metric">Distance metric struct; consumed by value so the JIT can inline
    /// its <c>Distance(ref double, ref double, int)</c> in the relaxation loop.</param>
    public static void ComputeMutualReachabilityMst<TMetric>(
        ReadOnlySpan<double> data,
        int                  n,
        int                  dim,
        ReadOnlySpan<double> coreDistances,
        Span<bool>           visited,
        Span<double>         minWeight,
        Span<int>            parent,
        TMetric              metric)
        where TMetric : struct, IDistanceMetric
    {
        if (n <= 0)  return;
        if (n == 1) { parent[0] = 0; return; }

        // Seed: start from node 0.
        minWeight[0] = 0.0;
        parent[0]    = 0;

        ref double dataRef = ref MemoryMarshal.GetReference(data);

        for (int step = 0; step < n; step++)
        {
            // O(N) argmin over unvisited nodes.
            int    u       = -1;
            double bestW   = double.PositiveInfinity;
            for (int v = 0; v < n; v++)
            {
                if (!visited[v] && minWeight[v] < bestW)
                {
                    bestW = minWeight[v];
                    u     = v;
                }
            }

            if (u < 0) break;   // disconnected remainder — should not occur on dense data
            visited[u] = true;

            // Relax edges from u.  Mutual reachability weight:
            //   w(u,v) = max(core(u), core(v), d(u,v))
            ref double rowURef = ref Unsafe.Add(ref dataRef, u * dim);
            double coreU = coreDistances[u];

            for (int v = 0; v < n; v++)
            {
                if (visited[v]) continue;

                ref double rowVRef = ref Unsafe.Add(ref dataRef, v * dim);
                double dist = metric.Distance(ref rowURef, ref rowVRef, dim);
                double w    = Math.Max(coreU, Math.Max(coreDistances[v], dist));

                if (w < minWeight[v])
                {
                    minWeight[v] = w;
                    parent[v]    = u;
                }
            }
        }
    }
}
