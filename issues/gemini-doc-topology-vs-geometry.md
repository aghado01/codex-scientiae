# I wonder about leveraging document 'topology' vs 'geometry' in the pdf extraction clustering challenge

Shifting the extraction challenge from a purely geometric problem to a topological one is a massive conceptual upgrade. It addresses the exact friction point you are seeing with fragmentation: geometry measures how things sit in rigid space, while topology measures how things are fundamentally connected, regardless of how they are stretched or spaced across the page.

Your current `RectangleGapMetric` in `Metric.cs` is strictly geometric. It assumes that physical proximity (density of whitespace gaps) equates to semantic grouping. This shatters completely on sparse, highly structured figures like scatter plots, complex diagrams, or tables, where the internal gaps between data points are often larger than the external margins separating the figure from the main text.

Here is what a topological pivot looks like in the context of your ingestion pipeline.

### **1. Seeding "Jail-broken" Graph Constructions**

Right now, your HDBSCAN runner dynamically computes a mutual reachability Minimum Spanning Tree (MST) based purely on the metric space in `Prim.cs`. To leverage topology, you stop relying solely on a flat metric computation to build the graph.

Instead, you create a "jail-broken" graph. Before HDBSCAN runs its density estimation, you inject hard, topological edges into the distance matrix (or the MST generation). If two paths share a topological invariant—such as strict spatial containment (Path A is completely inside Path B) or path intersection (a line connects two separate text boxes)—their distance is forced to $0$, regardless of the physical coordinates. You are essentially pre-wiring the connectivity graph based on document structure rather than letting the density algorithm guess the structure from raw coordinate distances.

### **2. Warping the Space with Non-Euclidean Metrics**

Document layouts are not flat, continuous $\mathbb{R}^2$ planes. They are highly structured manifolds where space behaves differently depending on the axis and the presence of visual boundaries.

Moving beyond simple bounding box gaps, you can define a non-Euclidean metric space where the distance between two nodes is modulated by their semantic alignment. For example, two elements that share a precise left-alignment axis might be considered topologically close, even if there is a large vertical geometric gap between them. You warp the manifold so that structurally aligned paths are pulled together, while elements separated by a drawn rule (a stroke path acting as a boundary constraint) are pushed infinitely far apart.

### **3. Multiresolution Filtration (TDA)**

Document structure fundamentally exists at multiple resolutions simultaneously. At a macro resolution, a page consists of three blobs (header, body, figure). At a micro resolution, the figure is a chaotic cloud of thousands of distinct SVG paths.

Applying principles from Topological Data Analysis (TDA), specifically filtrations, you don't have to choose a single spatial scale (like a static `minPts` or `minClusterSize` ). By tracking the persistence of connected components as you sweep a spatial parameter (or a temporal one, if analyzing sequential rendering), you can identify structural features that persist across multiple scales. A caption and a plot might merge late in the spatial filtration, but their internal connectivity persists early and strongly, allowing you to extract the hierarchical structure (a Reeb graph or MAPPER integration) rather than just flat clusters.

---

By redefining the feature space as a modular framework of topological relationships rather than a raw coordinate array, HDBSCAN ceases to be a simple spatial clusterer and becomes an engine for finding dense _semantic_ subgraphs.

Given the architecture in `HdbscanRunner`, would you prefer to inject these topological priors by modifying the distance metric itself, or by directly intercepting and rewriting the edges in the MST before the dendrogram is built?

# I dont necessarily mean replacing, i mean a combined approach to leverage both

I see exactly where you're going. A combined approach is the sweet spot: using topological priors to anchor the unquestionable relationships (the "skeleton" of the figure), while relying on the continuous geometric density to organically group the floating elements (text, stray markers, isolated points) where strict topological rules fail.

I've digested the shards of your C# engine, and the architecture you've set up—specifically the decoupling of the metric and the MST generation—makes injecting this hybrid logic highly elegant. Rather than relying on a strict, homogeneous geometric distance, you can embrace a broader modular framework utilizing "jail-broken" graph constructions to fuse both paradigms.

Here are two ways to seamlessly weave topology into your existing geometric density engine, leveraging the high-performance .NET 10 baseline you've established.

### 1. The Pre-Wired MST (Topological Override)

Right now, `Prim.cs` builds the spanning tree purely by evaluating the geometric `metric.Distance` and calculating the mutual reachability. You can "jail-break" this graph construction by supplying an auxiliary boolean adjacency matrix (or a sparse edge list) of known topological links.

Before the density algorithm even runs its $O(N^2)$ distance checks, you identify paths that share a strict topological invariant—for example, a glyph path that is fully contained within a rectangular boundary path, or a tick mark that physically intersects an axis line.

In `Prim.ComputeMutualReachabilityMst`, you simply intercept the weight calculation:

```csharp
// Inside the inner loop of Prim.cs:
double dist = isTopologicallyLinked(u, v)
    ? 0.0
    : metric.Distance(ref rowURef, ref rowVRef, dim);

```

By forcing the distance to `0.0` for known topological neighbors, HDBSCAN guarantees they will be clustered together, absorbing them into the same core-distance neighborhood. The geometric `RectangleGapMetric` then naturally handles the rest of the page, bridging the gaps between these pre-fused topological islands based on density.

### 2. The Warped Space (Hybrid Non-Euclidean Metric)

If a binary topological override is too aggressive, you can combine them continuously within the metric itself. You expand your `paths.jsonl` output to include topological features—like an alignment vector or a parent-container ID—alongside the physical coordinates.

You then author a new metric (e.g., `TopoGeometricMetric`) that computes the base `RectangleGapMetric` but scales the distance based on topological similarity.

$$d_{hybrid}(a, b) = d_{gap}(a, b) \times e^{-\gamma \cdot T(a, b)}$$

Where $T(a, b)$ is a measure of topological alignment (e.g., sharing a distinct horizontal baseline). If they are aligned, the exponent shrinks the physical gap, warping the metric space to pull them closer together. If a PDF rule (a visual dividing line) exists between them, you apply a massive penalty, pushing them infinitely far apart regardless of their geometric proximity.

This creates a thermodynamic landscape where the "valleys" (clusters) are carved by both physical closeness and structural alignment. Because you are running this in C#, you can easily use SIMD intrinsics to evaluate this slightly more complex math across your vectors without sacrificing your batch processing speeds.

---

Both approaches keep HDBSCAN as the ultimate arbiter of the final regions, but they feed it a much richer, layout-aware reality.

Are you currently extracting enough structural metadata (like intersections or containment) from `PdfPig` during the `ConvertTo-FigureRegions` phase to populate either a sparse topological graph or these alignment vectors?
