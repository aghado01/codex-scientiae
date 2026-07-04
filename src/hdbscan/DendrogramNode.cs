namespace CodexSci.Hdbscan;

/// <summary>
/// One merge event in an agglomerative single-linkage dendrogram. Leaves are points
/// <c>0..N-1</c>; internal merge nodes get dense ids <c>N..2N-2</c> in build order.
/// <see cref="LeftChild"/> / <see cref="RightChild"/> reference either.
/// </summary>
/// <remarks>
/// <para><b>Cost axis.</b> <see cref="Distance"/> is the scalar at which the two subtrees
/// merge; the build pass emits merges in monotone non-decreasing <see cref="Distance"/>
/// order (Kruskal single-linkage over the mutual-reachability MST).
/// <see cref="Dendrogram.CostAxis"/> documents the physical interpretation.</para>
/// <para><b>λ convention.</b> HDBSCAN's excess-of-mass pass consumes <c>λ = 1/Distance</c>;
/// that conversion lives in the consumer, keeping this record neutral across cost-axis
/// interpretations.</para>
/// </remarks>
public readonly record struct DendrogramNode(
    int    LeftChild,
    int    RightChild,
    double Distance,
    int    Size);
