PDF parsing is notoriously hostile territory, and tackling figure extraction by treating page elements as a point cloud is a highly elegant approach. Your C# implementation is remarkably clean, and using a zero-overlap distance calculation like `RectangleGapMetric` is mathematically sound for this feature space.

However, the fragmentation you are seeing highlights a fundamental friction in the current architecture: you are trying to solve structural layout problems purely through density estimation.

Here is how you can refine the clustering stage to make it more robust.

### **1. Separate Graph Priors from Spatial Scale**

The current pipeline relies entirely on tuning the spatial scale (via `minPts`, `minClusterSize`, and your epsilon defragmentation loop) to group internal figure fragments. But figure composition isn't just a continuous density field; it's governed by foundational connectivity assumptions, or graph priors.

If a caption is visually distant from a plot, tweaking the density granularity (spatial scale) to merge them will inevitably cause false positives elsewhere, bleeding into adjacent columns or text blocks.

Instead of forcing HDBSCAN to learn the page structure from raw gaps, inject a structural graph prior _before_ clustering. You can pre-collapse highly correlated paths (e.g., paths that physically intersect or share an exact bounding box, like axes and grid lines) into composite nodes. By passing a pre-reduced graph to HDBSCAN, the density algorithm only has to handle the macro-level spatial scale of the page, eliminating the need for the hacky epsilon de-frag loop.

### **2. Introduce Anisotropy via Coordinate Scaling**

The brief explicitly notes that your `RectangleGapMetric` is isotropic. In document layouts, vertical and horizontal space are not equivalent. A $10$-point vertical gap might just be line-spacing (tightly connected), while a $10$-point horizontal gap could be a hard column boundary (disconnected).

You can easily handle this upstream before the data hits the clustering engine. Apply an affine transformation to scale the $x$ and $y$ coordinates of your bounding boxes differently based on the page's modal font size or known column widths.

### **3. Enrich the Metric**

Your `RectangleGapMetric` calculates $d(A,B) = \sqrt{\sum \max(0, \text{gap}_i)^2}$. This is fast, but it is entirely blind to the geometry of the boxes. Two massive boxes separated by $5$ points are treated identically to two microscopic glyphs separated by $5$ points.

You can modify the feature space to include normalized area or aspect ratio, moving from a 4D space to a 5D or 6D space. Since you are building this in modern .NET and are clearly comfortable with manual memory management and bare-metal speeds, processing these slightly larger vectors using `Vector512` intrinsics would keep the metric dispatch blisteringly fast even with the added dimensionality.

### **4. Resolve Raster Blindness Upstream**

The absence of XObjects (raster images) in `paths.jsonl` is a fatal flaw for a figure-detection algorithm. Many academic figures are essentially single large bitmaps wrapped in a PDF bounding box.

If HDBSCAN cannot see the bitmap, it will only cluster the surrounding axes or labels, leading to severe fragmentation. `PdfPig` has robust support for extracting image XObjects and their transformation matrices. You must emit these image bounding boxes into your JSONL IR alongside the vector paths before running the clustering step.

The brief mentions a "Tier-2 occupancy/RLSA reformulation" as a potential replacement for this setup. Given the inherent limitations of pure density clustering on highly structured 2D layouts, are you planning to abandon the point-cloud HDBSCAN approach entirely in favor of Run Length Smoothing on a rasterized grid, or do you want to try stabilizing the vector-math approach first?

---

Fair enough. If the RLSA reformulation is slated as a downstream additive layer rather than a complete rewrite, stabilizing and tuning the vector-math density clustering is definitely the right immediate move.

Since you are keeping HDBSCAN as the core engine for this stage, here is how you can mitigate the fragmentation and raster-blindness within the current architecture:

### **1. Implement Anisotropy via Coordinate Scaling**

You don't need to rewrite `RectangleGapMetric` to make it layout-aware. You can mathematically distort the space before the data even hits the clustering engine.

During the `ConvertTo-FigureRegions` phase, apply a static multiplier to the $y$-coordinates (e.g., stretch the $y$-axis or compress the $x$-axis) before writing to `paths.jsonl`. By stretching the vertical axis, vertical gaps artificially cost more than horizontal ones. This allows the isotropic gap metric to naturally separate dense columns without shattering internally gappy figures that span horizontally.

### **2. Expand to a 5D/6D Feature Space**

To prevent massive bounding boxes and tiny glyphs from being treated identically, you can inject normalized `area_em2` or aspect ratio directly into the JSONL vector.

If you update the metric to consume a 5- or 6-dimensional array, the distance calculations will naturally take a slight hit. However, since your kernel is in C#, you could easily drop in `Vector512` intrinsics for the expanded metric dispatch to brute-force the calculations and keep it running at bare-metal speeds.

### **3. Leverage the Existing Graph Modularity**

I noticed you kept the architecture beautifully clean by having the HDBSCAN runner consume the core `Prim` primitive directly for the MST rather than relying on redundant internal wrappers.

Because that primitive is isolated, if you eventually decide to apply a _graph prior_ to merge intersecting bounding boxes (like grid lines and axes) before they even reach the density estimation phase, you have the exact hook you need to pass pre-collapsed nodes into the tree.

### **4. Expose the XObjects**

This is the most critical block for your batch process. `paths.jsonl` must be updated to include the bounding boxes of PDF XObjects. Without the bitmaps, the clustering algorithm is essentially trying to deduce the presence of a planet by only looking at its moons.

---

Which of these structural fixes—injecting the XObjects to cure the raster blindness, or applying coordinate scaling for anisotropy—do you want to tackle first in the extraction script?
