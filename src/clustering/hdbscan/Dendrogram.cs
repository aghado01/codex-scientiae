namespace Clustering.Dendrograms;

/// <summary>
/// Merge-tree wrapper — closed-form stub of the SPCX Dendrogram DTO. Carries the
/// Phase-4 single-linkage merges; HDBSCAN constructs it and exposes it on the
/// result. CostAxis names the y-axis units (mutual-reachability distance, the
/// value the condensation pass inverts to λ = 1/d). The full SPCX version adds
/// rendering/persistence helpers this lift doesn't need.
/// </summary>
public sealed record Dendrogram(DendrogramNode[] Merges, int LeafCount, string CostAxis);
