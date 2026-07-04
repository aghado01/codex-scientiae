namespace CodexSci.Hdbscan;

/// <summary>
/// Merge-tree DTO carrying the Phase-4 single-linkage merges. <see cref="CostAxis"/>
/// names the y-axis units (mutual-reachability distance, the value the condensation pass
/// inverts to λ = 1/d). Preserved on the result so downstream plotting / re-analysis can
/// render the tree without re-running the pipeline.
/// </summary>
public sealed record Dendrogram(DendrogramNode[] Merges, int LeafCount, string CostAxis);
