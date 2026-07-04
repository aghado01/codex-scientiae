using System;

namespace CodexSci.Hdbscan;

/// <summary>
/// Full HDBSCAN pipeline. Pre-allocates all scratch at construction time and
/// reuses it across <see cref="Run{TMetric}"/> calls on data of the same N.
///
/// Pipeline phases:
///   1. Core-distance computation  — k-NN distance per point (minPts neighbour).
///   2. Implicit Prim's MST        — <see cref="Prim.ComputeMutualReachabilityMst{TMetric}"/>
///      over the mutual reachability graph; zero edge-list allocation.
///   3. Edge materialisation       — N−1 <see cref="MstEdge"/> structs, sorted
///      ascending by weight (Kruskal order).
///   4. Dendrogram construction    — single-linkage merge tree via UnionFind;
///      emits <see cref="DendrogramNode"/>[N−1].
///   5. Condensation + extraction  — λ-stability / excess-of-mass pass;
///      produces <see cref="HdbscanResult"/>.
/// </summary>
public sealed class HdbscanRunner
{
    private readonly int      _n;
    private readonly UnionFind _uf;         // capacity 2N−1; Reset() between runs
    private readonly double[]  _coreDist;
    private readonly bool[]    _visited;
    private readonly double[]  _minWeight;
    private readonly int[]     _parent;
    private readonly MstEdge[] _mstEdges;

    public HdbscanRunner(int n)
    {
        if (n < 2) throw new ArgumentOutOfRangeException(nameof(n), "Must be >= 2.");
        _n = n;
        _uf = new UnionFind(2 * n - 1);
        _coreDist = new double[n];
        _visited = new bool[n];
        _minWeight = new double[n];
        _parent = new int[n];
        _mstEdges = new MstEdge[n - 1];
    }

    /// <param name="data">Flat row-major buffer, length N × dim.</param>
    /// <param name="dim">Dimensionality of each row in <paramref name="data"/>.</param>
    /// <param name="minPts">Smoothing parameter for core-distance computation (≥ 2).</param>
    /// <param name="metric">Distance metric; struct-generic so the JIT inlines the call.</param>
    /// <param name="minClusterSize">Minimum size for a subtree to be treated as
    /// a "real" cluster during condensation. Smaller subtrees fall out of their
    /// parent. Defaults to <paramref name="minPts"/> when null. Controls cluster
    /// granularity, not the cluster count: larger values → fewer/bigger clusters.</param>
    /// <param name="allowSingleCluster">If true, the root cluster can be selected
    /// by EOM — useful when the input is one dense blob with outliers (mapper-style
    /// cover patches). If false, datasets with no real splits return all-noise
    /// (sklearn default behaviour).</param>
    /// <param name="clusterSelectionEpsilon">Optional HDBSCAN/DBSCAN hybrid: merge any two
    /// clusters separated by a mutual-reachability distance below this value (0 disables). Any
    /// selected cluster born from a finer split walks up to its lowest ancestor born at a split
    /// ≥ epsilon — de-fragments over-split structure without reverting to a single global cut.</param>
    public HdbscanResult Run<TMetric>(
        ReadOnlySpan<double> data,
        int                  dim,
        int                  minPts,
        TMetric              metric,
        int?                 minClusterSize          = null,
        bool                 allowSingleCluster      = true,
        double               clusterSelectionEpsilon = 0.0)
        where TMetric : struct, IDistanceMetric
    {
        if (minPts < 2)
            throw new ArgumentOutOfRangeException(nameof(minPts), "Must be >= 2.");

        int effMinClusterSize = minClusterSize ?? minPts;
        if (effMinClusterSize < 2)
            throw new ArgumentOutOfRangeException(nameof(minClusterSize), "Must be >= 2.");

        int n = _n;

        // ── Phase 1: core distances ───────────────────────────────────────────
        CoreDistances.Compute(data, n, dim, minPts, metric, _coreDist.AsSpan());

        // ── Phase 2: implicit Prim's MST + edge materialisation ─────────────
        for (int i = 0; i < n; i++)
        {
            _visited[i] = false;
            _minWeight[i] = double.PositiveInfinity;
            _parent[i] = -1;
        }

        Prim.ComputeMutualReachabilityMst(
            data, n, dim,
            _coreDist.AsSpan(),
            _visited.AsSpan(),
            _minWeight.AsSpan(),
            _parent.AsSpan(),
            metric);

        for (int v = 1; v < n; v++)
            _mstEdges[v - 1] = new MstEdge(_parent[v], v, _minWeight[v]);

        Array.Sort(_mstEdges, 0, n - 1);

        // ── Phase 4: build dendrogram ─────────────────────────────────────────
        DendrogramNode[] tree = DendrogramBuilder.BuildSingleLinkageDendrogram(
            _mstEdges.AsSpan(0, n - 1), n, _uf);

        // Wrap the raw merge sequence in the shared Dendrogram DTO so the
        // persistence without reproducing the build pass. CostAxis names
        // the y-axis units (mutual-reachability distance, the same value
        // HDBSCAN's condensation pass inverts to λ = 1/d).
        var dendrogram = new Dendrogram(
            Merges:    tree,
            LeafCount: n,
            CostAxis:  "mutual_reachability_distance");

        // ── Phase 5: condense + extract clusters ─────────────────────────────
        return ExtractClusters(tree, n, effMinClusterSize, allowSingleCluster, dendrogram, clusterSelectionEpsilon);
    }

    // ── Phase 5 ───────────────────────────────────────────────────────────────

    /// <summary>
    /// HDBSCAN cluster extraction. Walks the dendrogram top-down (λ-increasing)
    /// and condenses it into a tree of "real" clusters; then runs excess-of-mass
    /// selection over the condensed tree.
    ///
    /// Each dendrogram split is classified by the size of its two subtrees:
    ///   • both ≥ minClusterSize → "real split": parent cluster dies, two new
    ///     condensed clusters are born; all remaining leaves contribute
    ///     (λ_split − λ_birth) to the dying parent's stability.
    ///   • exactly one ≥ minClusterSize → small side falls out of the parent;
    ///     only the small-side leaves contribute; big side continues.
    ///   • both &lt; minClusterSize → whole remaining subtree falls out;
    ///     all remaining leaves contribute.
    ///
    /// EOM: cluster C is tentatively selected iff stability(C) ≥
    ///   Σ subtreeStability(child); a top-down sweep then deselects any cluster
    ///   that has a selected ancestor. The root (id 0) is never selected, so a
    ///   dataset with no real splits returns all-noise (matches sklearn's
    ///   default <c>allow_single_cluster=False</c>).
    /// </summary>
    private static HdbscanResult ExtractClusters(
        DendrogramNode[] tree,
        int              n,
        int              minClusterSize,
        bool             allowSingleCluster,
        Dendrogram       dendrogram,
        double           clusterSelectionEpsilon)
    {
        int numMerges = tree.Length;

        // ── Condensation ─────────────────────────────────────────────────────
        // Condensed-cluster bookkeeping. Upper bound: 2N − 1 (root + two new
        // clusters per real split, ≤ N−1 real splits). Allocate 2N for slack.
        //   cBirth[C] = λ at which C was born (parent's split λ; 0 for root).
        //   cDeath[C] = λ at which C dies (set at real-split or both-too-small).
        //   cStab[C]  = HDBSCAN stability accumulator.
        int      maxCondensed = 2 * n;
        int[]    cParent      = new int[maxCondensed];
        double[] cBirth       = new double[maxCondensed];
        double[] cDeath       = new double[maxCondensed];
        double[] cStab        = new double[maxCondensed];
        cParent[0] = -1;
        cBirth[0]  = 0.0;
        int numCondensed = 1;   // root = id 0

        // clusterAtMerge[i] = condensed cluster id containing the subtree rooted
        // at internal node (n + i). -1 means the subtree already fell out — skip
        // and propagate the sentinel down to internal grandchildren.
        int[] clusterAtMerge = new int[numMerges];
        if (numMerges > 0)
        {
            Array.Fill(clusterAtMerge, -1);
            clusterAtMerge[numMerges - 1] = 0;
        }

        // clusterAtLeaf[x]     — deepest condensed cluster x belongs to (default 0).
        // leafFalloutLambda[x] — λ at which x fell out of that deepest cluster.
        //   Set at the falls-out / both-too-small event that removed x from its
        //   then-current cluster; never set at real splits (those transition x
        //   into a deeper cluster, they don't end x's membership at the leaf
        //   level — see probability formula below).
        int[]    clusterAtLeaf     = new int[n];
        double[] leafFalloutLambda = new double[n];
        int[]    dfsStack          = new int[n];   // scratch for TagLeaves/TagFallout

        for (int i = numMerges - 1; i >= 0; i--)
        {
            int parentCid = clusterAtMerge[i];
            int leftId    = tree[i].LeftChild;
            int rightId   = tree[i].RightChild;

            if (parentCid < 0)
            {
                if (leftId  >= n) clusterAtMerge[leftId  - n] = -1;
                if (rightId >= n) clusterAtMerge[rightId - n] = -1;
                continue;
            }

            int leftSize  = leftId  < n ? 1 : tree[leftId  - n].Size;
            int rightSize = rightId < n ? 1 : tree[rightId - n].Size;

            double splitLambda = tree[i].Distance > 0.0
                ? 1.0 / tree[i].Distance
                : double.PositiveInfinity;
            double pBirth = cBirth[parentCid];

            bool leftBig  = leftSize  >= minClusterSize;
            bool rightBig = rightSize >= minClusterSize;

            if (leftBig && rightBig)
            {
                // Real split: parent dies at splitLambda; two new clusters born.
                cStab[parentCid]  += (leftSize + rightSize) * (splitLambda - pBirth);
                cDeath[parentCid] = splitLambda;

                int newLeftCid  = numCondensed++;
                int newRightCid = numCondensed++;
                cParent[newLeftCid]  = parentCid; cBirth[newLeftCid]  = splitLambda;
                cParent[newRightCid] = parentCid; cBirth[newRightCid] = splitLambda;

                DendrogramBuilder.VisitLeaves(tree, leftId,  n, dfsStack, leaf => clusterAtLeaf[leaf] = newLeftCid);
                DendrogramBuilder.VisitLeaves(tree, rightId, n, dfsStack, leaf => clusterAtLeaf[leaf] = newRightCid);

                if (leftId  >= n) clusterAtMerge[leftId  - n] = newLeftCid;
                if (rightId >= n) clusterAtMerge[rightId - n] = newRightCid;
            }
            else if (leftBig)
            {
                // Right (small) side falls out; left side continues in parent.
                cStab[parentCid] += rightSize * (splitLambda - pBirth);
                DendrogramBuilder.VisitLeaves(tree, rightId, n, dfsStack, leaf => leafFalloutLambda[leaf] = splitLambda);
                if (leftId  >= n) clusterAtMerge[leftId  - n] = parentCid;
                if (rightId >= n) clusterAtMerge[rightId - n] = -1;
            }
            else if (rightBig)
            {
                cStab[parentCid] += leftSize * (splitLambda - pBirth);
                DendrogramBuilder.VisitLeaves(tree, leftId, n, dfsStack, leaf => leafFalloutLambda[leaf] = splitLambda);
                if (rightId >= n) clusterAtMerge[rightId - n] = parentCid;
                if (leftId  >= n) clusterAtMerge[leftId  - n] = -1;
            }
            else
            {
                // Both too small — parent dies; whole remainder falls out.
                cStab[parentCid]  += (leftSize + rightSize) * (splitLambda - pBirth);
                cDeath[parentCid] = splitLambda;
                DendrogramBuilder.VisitLeaves(tree, leftId,  n, dfsStack, leaf => leafFalloutLambda[leaf] = splitLambda);
                DendrogramBuilder.VisitLeaves(tree, rightId, n, dfsStack, leaf => leafFalloutLambda[leaf] = splitLambda);
                if (leftId  >= n) clusterAtMerge[leftId  - n] = -1;
                if (rightId >= n) clusterAtMerge[rightId - n] = -1;
            }
        }

        // ── Excess-of-mass selection ─────────────────────────────────────────
        // Bottom-up (parent id < child id, so reverse index order suffices):
        // subtreeStab[C] = max(stability[C], Σ subtreeStab[child]). Tentatively
        // select C iff its own stability wins. Root (id 0) is only eligible
        // when allowSingleCluster is true.
        int loopStart = allowSingleCluster ? 0 : 1;
        double[] childSum    = new double[numCondensed];
        double[] subtreeStab = new double[numCondensed];
        bool[]   selected    = new bool[numCondensed];

        for (int i = numCondensed - 1; i >= loopStart; i--)
        {
            double own  = cStab[i];
            double kids = childSum[i];
            if (own >= kids)
            {
                subtreeStab[i] = own;
                selected[i]    = true;
            }
            else
            {
                subtreeStab[i] = kids;
            }
            int p = cParent[i];
            if (p >= 0) childSum[p] += subtreeStab[i];
        }

        // Top-down: deselect any cluster whose ancestor was selected.
        bool[] hasSelectedAncestor = new bool[numCondensed];
        for (int i = 1; i < numCondensed; i++)
        {
            int p = cParent[i];
            hasSelectedAncestor[i] = hasSelectedAncestor[p] || selected[p];
            if (hasSelectedAncestor[i]) selected[i] = false;
        }

        // ── Cluster-selection-epsilon (optional HDBSCAN/DBSCAN hybrid) ───────
        // Merge clusters separated by less than epsilon: any selected cluster born from a
        // split at distance < epsilon walks up to its lowest ancestor born at a split ≥ epsilon.
        // cBirth[c] is the birth λ, so the birth split-distance is 1/cBirth[c] (root: cBirth=0
        // → +inf, so the walk stops there). This is the reference `cluster_selection_epsilon` —
        // it de-fragments over-split structure (one figure shattered into density-coherent
        // sub-blobs) without reverting to a single global threshold.
        if (clusterSelectionEpsilon > 0.0)
        {
            bool[] epsSelected = new bool[numCondensed];
            for (int c = loopStart; c < numCondensed; c++)
            {
                if (!selected[c]) continue;
                int cur = c, prev = c;
                while (cParent[cur] >= 0)
                {
                    double birthDist = cBirth[cur] > 0.0 ? 1.0 / cBirth[cur] : double.PositiveInfinity;
                    if (birthDist < clusterSelectionEpsilon) { prev = cur; cur = cParent[cur]; }
                    else break;
                }
                if (cur == 0 && !allowSingleCluster) cur = prev;   // don't collapse to the disallowed root
                epsSelected[cur] = true;
            }
            Array.Copy(epsSelected, selected, numCondensed);

            // Re-enforce the antichain (drop any merged ancestor now nested under another).
            Array.Clear(hasSelectedAncestor, 0, numCondensed);
            for (int i = 1; i < numCondensed; i++)
            {
                int p = cParent[i];
                hasSelectedAncestor[i] = hasSelectedAncestor[p] || selected[p];
                if (hasSelectedAncestor[i]) selected[i] = false;
            }
        }

        // ── Label assignment + membership probability ────────────────────────
        // Dense-label each selected cluster. For each leaf, walk up the
        // condensed chain to the nearest selected ancestor.
        //
        // Probability formula for leaf x assigned to selected cluster L:
        //   • Case 1 (clusterAtLeaf[x] == L): x fell out of L at leafFalloutLambda[x].
        //       prob = leafFalloutLambda[x] / cDeath[L]   ∈ [0, 1]
        //   • Case 2 (L is a strict ancestor of clusterAtLeaf[x]): x stayed in L
        //       all the way until L died (it transitioned into a descendant at L's
        //       split, but L's death λ is what bounds the membership window).
        //       prob = 1.0 (full member).
        int[] cidLabel = new int[numCondensed];
        Array.Fill(cidLabel, -1);
        int clusterCount = 0;
        for (int i = loopStart; i < numCondensed; i++)
            if (selected[i]) cidLabel[i] = clusterCount++;

        int[]    labels     = new int[n];
        double[] memberProb = new double[n];
        for (int x = 0; x < n; x++)
        {
            int deepest = clusterAtLeaf[x];
            int cid     = deepest;
            while (cid >= 0 && cidLabel[cid] < 0)
                cid = cParent[cid];

            if (cid < 0)
            {
                labels[x]     = -1;
                memberProb[x] = 0.0;
            }
            else
            {
                labels[x] = cidLabel[cid];
                double lambdaMax = cDeath[cid];
                if (cid == deepest)
                {
                    double lambdaIn = leafFalloutLambda[x];
                    memberProb[x] = lambdaMax > 0.0 && !double.IsInfinity(lambdaMax)
                        ? Math.Min(1.0, lambdaIn / lambdaMax)
                        : 1.0;
                }
                else
                {
                    memberProb[x] = 1.0;
                }
            }
        }

        return new HdbscanResult(labels, memberProb, clusterCount, dendrogram);
    }
}
/// <summary>
/// Output of a completed <see cref="HdbscanRunner.Run{TMetric}"/> call.
///
/// <see cref="Labels"/>: cluster index per point in [0, ClusterCount), or
///   −1 for noise points.
/// <see cref="MembershipProbabilities"/>: soft assignment score ∈ [0, 1] for
///   each point. For a point x labelled to cluster L:
///   λ_fallout(x) / λ_death(L) when x's deepest condensed cluster is L itself
///   (the point may have left L early via a small-side falls-out); 1.0 when L
///   is a strict ancestor of x's deepest cluster (x stayed in L until L died).
///   0.0 for noise points.
/// </summary>
public sealed class HdbscanResult(
    int[]      labels,
    double[]   membershipProbabilities,
    int        clusterCount,
    Dendrogram dendrogram)
{
    public int[]      Labels                   { get; } = labels;
    public double[]   MembershipProbabilities  { get; } = membershipProbabilities;
    public int        ClusterCount             { get; } = clusterCount;

    /// <summary>
    /// Raw single-linkage dendrogram produced in Phase 4. Cost axis is
    /// mutual-reachability distance; λ = 1/cost is the persistence
    /// scalar HDBSCAN's condensation pass consumes. Preserved on the
    /// result so downstream plotting / re-analysis (and the CLI's
    /// dendrogram.json writer) can render the merge tree without
    /// re-running the pipeline.
    /// </summary>
    public Dendrogram Dendrogram               { get; } = dendrogram;

    public bool IsNoise(int pointIndex) => Labels[pointIndex] < 0;
}

// ── Internal helpers ──────────────────────────────────────────────────────────
//
// The single-linkage dendrogram record (<c>DendrogramNode</c>) is a standalone
// merge-tree primitive, so any agglomerative algorithm can emit the same shape.
// The HDBSCAN convention applies here: nodes 0..N-1 are leaves; nodes N..2N-2 are
// internal merge nodes assigned by the UnionFind during Kruskal's pass; Distance
// is the mutual-reachability weight, and λ = 1/Distance is the persistence value
// the excess-of-mass selection pass consumes.
