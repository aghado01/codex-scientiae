using System;
using System.Collections.Generic;
using CodexSci.Hdbscan;

// Trust harness for the HDBSCAN engine + external evaluators. Dependency-free (no test
// framework): each Check prints PASS/FAIL and the process exits non-zero if any assertion
// fails, so `dotnet run --project projects/tests` is a CI-able correctness + regression gate.
//
// Three layers:
//   1. Evaluator unit correctness — hand-derived / sklearn-verified values on tiny inputs,
//      so the ruler itself is trustworthy before it's used to grade clustering.
//   2. Clustering correctness — HDBSCAN on cleanly-separated blobs must score ARI = 1.0
//      against the known blob membership (absolute correctness, no sklearn needed).
//   3. Determinism — identical output across runs (the MstEdge tiebreak guards regressions).

int failures = 0;
void Check(string name, bool ok)
{
    Console.WriteLine($"  [{(ok ? "PASS" : "FAIL")}] {name}");
    if (!ok) failures++;
}
void Near(string name, double got, double want, double tol = 1e-9)
    => Check($"{name} (got {got:G6}, want {want:G6})", Math.Abs(got - want) <= tol);

// ── Layer 1: evaluator unit correctness ─────────────────────────────────────────────
Console.WriteLine("Evaluator unit tests:");

// A: perfect agreement up to relabeling → all scores 1.0
{
    var s = ClusterEvaluators.Compute(new[] { 0, 0, 1, 1 }, new[] { 1, 1, 0, 0 });
    Near("A.ari",          s.Ari,          1.0);
    Near("A.nmi",          s.Nmi,          1.0);
    Near("A.homogeneity",  s.Homogeneity,  1.0);
    Near("A.completeness", s.Completeness, 1.0);
    Near("A.v_measure",    s.VMeasure,     1.0);
    Near("A.purity",       s.Purity,       1.0);
}

// B: sklearn doc example — true=[0,0,1,1], pred=[0,0,1,2]
//    homogeneity=1, completeness=2/3, v=0.8, nmi=0.8, ari=8/14, purity=1
{
    var s = ClusterEvaluators.Compute(new[] { 0, 0, 1, 1 }, new[] { 0, 0, 1, 2 });
    Near("B.homogeneity",  s.Homogeneity,  1.0);
    Near("B.completeness", s.Completeness, 2.0 / 3.0);
    Near("B.v_measure",    s.VMeasure,     0.8);
    Near("B.nmi",          s.Nmi,          0.8);
    Near("B.ari",          s.Ari,          4.0 / 7.0);
    Near("B.purity",       s.Purity,       1.0);
}

// C: independent labelings — true=[0,0,1,1], pred=[0,1,0,1] → ARI negative
{
    var s = ClusterEvaluators.Compute(new[] { 0, 0, 1, 1 }, new[] { 0, 1, 0, 1 });
    Near("C.ari",          s.Ari,          -0.5);
    Near("C.nmi",          s.Nmi,          0.0);
    Near("C.homogeneity",  s.Homogeneity,  0.0);
    Near("C.v_measure",    s.VMeasure,     0.0);
    Near("C.purity",       s.Purity,       0.5);
}

// Identity: V-measure ≡ arithmetic NMI (independent internal cross-check)
{
    var s = ClusterEvaluators.Compute(new[] { 0, 0, 1, 1, 2, 2 }, new[] { 0, 0, 1, 2, 2, 2 });
    Near("identity: v_measure == nmi", s.VMeasure, s.Nmi);
}

// ── Layer 1b: distance-metric unit correctness (hand-verified) ───────────────────────
Console.WriteLine("Metric unit tests:");
{
    Near("euclidean (3,4)",     new EuclideanMetric().Distance(new double[] { 0, 0 }, new double[] { 3, 4 }), 5.0);
    Near("manhattan (3,4)",     new ManhattanMetric().Distance(new double[] { 0, 0 }, new double[] { 3, 4 }), 7.0);
    Near("chebyshev (3,4)",     new ChebyshevMetric().Distance(new double[] { 0, 0 }, new double[] { 3, 4 }), 4.0);
    Near("minkowski p=3",       new MinkowskiMetric(3).Distance(new double[] { 0, 0 }, new double[] { 1, 1 }), Math.Pow(2, 1.0 / 3.0));
    Near("cosine orthogonal",   new CosineMetric().Distance(new double[] { 1, 0 }, new double[] { 0, 1 }), 1.0);
    Near("cosine identical",    new CosineMetric().Distance(new double[] { 1, 1 }, new double[] { 2, 2 }), 0.0);

    var ham = new HammingMetric();
    Near("hamming 2/4",         ham.Distance(new double[] { 0, 1, 0, 1 }, new double[] { 0, 0, 1, 1 }), 0.5);
    Near("hamming identical",   ham.Distance(new double[] { 1, 2, 3 }, new double[] { 1, 2, 3 }), 0.0);
    Near("hamming all differ",  ham.Distance(new double[] { 1, 1, 1 }, new double[] { 2, 2, 2 }), 1.0);

    var poi = new PoincareMetric();
    Near("poincare d(0,x)=ln3", poi.Distance(new double[] { 0, 0 }, new double[] { 0.5, 0 }), Math.Log(3.0));
    Near("poincare identity",   poi.Distance(new double[] { 0, 0 }, new double[] { 0.7, 0 }), 2.0 * Math.Atanh(0.7));
    Near("poincare d(x,x)=0",   poi.Distance(new double[] { 0.3, 0.2 }, new double[] { 0.3, 0.2 }), 0.0);
    Near("poincare symmetry",   poi.Distance(new double[] { 0.1, 0.2 }, new double[] { -0.3, 0.1 }),
                                poi.Distance(new double[] { -0.3, 0.1 }, new double[] { 0.1, 0.2 }));
    Check("poincare boundary is finite",
          double.IsFinite(poi.Distance(new double[] { 0.999999, 0 }, new double[] { -0.999999, 0 })));

    var hyp = new HyperboloidMetric();
    double t = 0.9;   // origin (1,0) to (cosh t, sinh t) is exactly t
    Near("hyperboloid d(origin, r=t)", hyp.Distance(new double[] { 1, 0 }, new double[] { Math.Cosh(t), Math.Sinh(t) }), t);
    Near("hyperboloid d(x,x)=0",       hyp.Distance(new double[] { Math.Cosh(0.4), Math.Sinh(0.4) }, new double[] { Math.Cosh(0.4), Math.Sinh(0.4) }), 0.0);
    // isometry cross-check: map Poincaré points onto the hyperboloid, distances must agree
    double[] MapToHyperboloid(double[] pt)
    {
        double sq = 0.0; foreach (var c in pt) sq += c * c;
        double denom = 1.0 - sq;
        var x = new double[pt.Length + 1];
        x[0] = (1.0 + sq) / denom;
        for (int i = 0; i < pt.Length; i++) x[i + 1] = 2.0 * pt[i] / denom;
        return x;
    }
    double[] pa = { 0.3, 0.1 }, pb = { -0.2, 0.4 };
    Near("hyperboloid ≡ poincare (isometry)", hyp.Distance(MapToHyperboloid(pa), MapToHyperboloid(pb)), poi.Distance(pa, pb));

    var rg = new RectangleGapMetric();
    Near("rect-gap horizontal", rg.Distance(new double[] { 0, 0, 10, 10 }, new double[] { 20, 0, 30, 10 }), 10.0);
    Near("rect-gap overlap=0",  rg.Distance(new double[] { 0, 0, 10, 10 }, new double[] { 5, 5, 15, 15 }), 0.0);
    Near("rect-gap diagonal",   rg.Distance(new double[] { 0, 0, 10, 10 }, new double[] { 13, 14, 20, 20 }), 5.0);
}

// ── Layer 2b: rectangle-gap layout segmentation (figures cluster, strays → noise) ────
Console.WriteLine("Rectangle-gap layout segmentation:");
{
    var boxes = new List<double[]>();
    var isStray = new List<bool>();
    // Two dense figure blobs: 4×3 grids of 6-pt boxes on a 10-pt pitch (4-pt gaps).
    foreach (int xoff in new[] { 0, 100 })
        for (int gx = 0; gx < 4; gx++)
            for (int gy = 0; gy < 3; gy++)
            {
                double x0 = xoff + gx * 10, y0 = gy * 10;
                boxes.Add(new double[] { x0, y0, x0 + 6, y0 + 6 });   // [x0,y0,x1,y1]
                isStray.Add(false);
            }
    // Three isolated stray rules, each far (>80pt) from both figures and each other.
    boxes.Add(new double[] { 0, 300, 140, 301 });  isStray.Add(true);  // top rule
    boxes.Add(new double[] { 0, -100, 140, -99 }); isStray.Add(true);  // footer rule
    boxes.Add(new double[] { 400, 0, 410, 6 });    isStray.Add(true);  // far-right note

    int n = boxes.Count;
    var data = new double[n * 4];
    for (int i = 0; i < n; i++) Array.Copy(boxes[i], 0, data, i * 4, 4);

    var res = new HdbscanRunner(n).Run(data, 4, minPts: 3, new RectangleGapMetric(),
                                       minClusterSize: 3, allowSingleCluster: false);

    Check($"rect-gap: 2 figure clusters (got {res.ClusterCount})", res.ClusterCount == 2);

    int strayNoise = 0, strayTotal = 0, figNoise = 0;
    for (int i = 0; i < n; i++)
    {
        if (isStray[i]) { strayTotal++; if (res.Labels[i] < 0) strayNoise++; }
        else if (res.Labels[i] < 0) figNoise++;
    }
    Check($"rect-gap: all {strayTotal} strays fall out as noise (got {strayNoise})", strayNoise == strayTotal);
    Check($"rect-gap: no figure box is noise (got {figNoise})", figNoise == 0);

    int l1 = res.Labels[0], l2 = res.Labels[12];   // first box of each figure
    bool fig1One = l1 >= 0, fig2One = l2 >= 0;
    for (int i = 0;  i < 12; i++) if (res.Labels[i] != l1) fig1One = false;
    for (int i = 12; i < 24; i++) if (res.Labels[i] != l2) fig2One = false;
    Check("rect-gap: figure 1 is a single cluster", fig1One);
    Check("rect-gap: figure 2 is a single cluster", fig2One);
    Check("rect-gap: the two figures are distinct clusters", l1 != l2);
}

// ── Layer 2: HDBSCAN correctness on cleanly-separated blobs ──────────────────────────
Console.WriteLine("Clustering correctness (clean blobs):");
{
    const int dim = 2, per = 12;
    (double cx, double cy)[] centers = { (0, 0), (20, 0), (10, 20) };
    var pts = new List<double[]>();
    var truth = new List<int>();
    var rng = new Random(7);
    for (int k = 0; k < centers.Length; k++)
        for (int i = 0; i < per; i++)
        {
            pts.Add(new[] { centers[k].cx + (rng.NextDouble() - 0.5), centers[k].cy + (rng.NextDouble() - 0.5) });
            truth.Add(k);
        }
    int n = pts.Count;
    var data = new double[n * dim];
    for (int i = 0; i < n; i++) { data[i * dim] = pts[i][0]; data[i * dim + 1] = pts[i][1]; }

    var res = new HdbscanRunner(n).Run(data, dim, minPts: 5, new EuclideanMetric(),
                                       minClusterSize: 5, allowSingleCluster: false);

    Check($"cluster_count == 3 (got {res.ClusterCount})", res.ClusterCount == 3);
    int noise = 0; foreach (var l in res.Labels) if (l < 0) noise++;
    Check($"noise == 0 (got {noise})", noise == 0);

    var s = ClusterEvaluators.Compute(truth.ToArray(), res.Labels);
    Near("blobs.ari",          s.Ari,          1.0);
    Near("blobs.homogeneity",  s.Homogeneity,  1.0);
    Near("blobs.completeness", s.Completeness, 1.0);
    Near("blobs.v_measure",    s.VMeasure,     1.0);
    Near("blobs.purity",       s.Purity,       1.0);
}

// ── Layer 3: determinism / regression guard ─────────────────────────────────────────
Console.WriteLine("Determinism:");
{
    var rng = new Random(11);
    int n = 40, dim = 3;
    var data = new double[n * dim];
    for (int i = 0; i < data.Length; i++) data[i] = rng.NextDouble() * 5.0;

    var r1 = new HdbscanRunner(n).Run(data, dim, 4, new EuclideanMetric());
    var r2 = new HdbscanRunner(n).Run(data, dim, 4, new EuclideanMetric());

    bool sameLabels = true;
    for (int i = 0; i < n; i++) if (r1.Labels[i] != r2.Labels[i]) { sameLabels = false; break; }
    Check("labels identical across runs", sameLabels);

    bool sameTree = r1.Dendrogram.Merges.Length == r2.Dendrogram.Merges.Length;
    for (int i = 0; sameTree && i < r1.Dendrogram.Merges.Length; i++)
    {
        var m1 = r1.Dendrogram.Merges[i];
        var m2 = r2.Dendrogram.Merges[i];
        if (m1.Distance != m2.Distance || m1.LeftChild != m2.LeftChild || m1.RightChild != m2.RightChild)
            sameTree = false;
    }
    Check("dendrogram identical across runs", sameTree);
}

Console.WriteLine();
Console.WriteLine(failures == 0 ? "ALL PASS" : $"{failures} FAILURE(S)");
return failures == 0 ? 0 : 1;
