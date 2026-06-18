using System;
using System.Collections.Generic;
using Clustering.Graphical.HdbScan;
using Graphs.Distance;

// Smoke test for the closed-form HDBSCAN lift: three well-separated 2-D blobs
// plus scattered noise. Expect 3 clusters of ~30 and a handful of -1 (noise).
// Verifies the vendored closure actually compiles and clusters with no SPCX deps.

var rng = new Random(42);
const int dim = 2;
var pts = new List<double[]>();

(double cx, double cy)[] centers = { (0, 0), (10, 0), (5, 8) };
foreach (var (cx, cy) in centers)
    for (int i = 0; i < 30; i++)
        pts.Add(new[] { cx + rng.NextDouble() - 0.5, cy + rng.NextDouble() - 0.5 });

for (int i = 0; i < 6; i++)
    pts.Add(new[] { rng.NextDouble() * 15.0, rng.NextDouble() * 12.0 });

int n = pts.Count;
var data = new double[n * dim];
for (int i = 0; i < n; i++)
{
    data[i * dim] = pts[i][0];
    data[i * dim + 1] = pts[i][1];
}

var runner = new HdbscanRunner(n);
var res = runner.Run(data, dim, minPts: 5, new EuclideanMetric(),
                     minClusterSize: 5, allowSingleCluster: false);

var hist = new SortedDictionary<int, int>();
foreach (var label in res.Labels)
    hist[label] = hist.GetValueOrDefault(label) + 1;

Console.WriteLine($"N={n}  clusters={res.ClusterCount}");
foreach (var kv in hist)
    Console.WriteLine($"  label {kv.Key,3}: {kv.Value}");
