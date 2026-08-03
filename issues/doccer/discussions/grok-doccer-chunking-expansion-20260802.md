**Multiresolution chunker factory — design expansion on top of the proposed kernel**

A multiresolution chunker factory is a natural second application. It shares the same foundation (claims over ordered carriers, qualitative relations, witness-retaining joins, lattices, derivations) but demands a different emphasis: simultaneous hierarchical partitions at multiple grains, with explicit inter-level geometry and domain-controlled aggregation.

The tokenizer-factory machinery already supplies most of the required substrate. The additional expansion is modest and local.

### What the use case actually needs

Chunking of structured documents and code typically requires:

- Multiple simultaneous partitions of the same material (coarse outline + medium sections + fine statements/tokens).
- Hierarchical containment that is usually laminar but may tolerate controlled overlap or concurrent analyses.
- Domain-supplied recognizers that propose candidate chunks at each grain (Markdown ATX headings, AST nodes, semantic sections, function bodies, etc.).
- Consistency constraints across grains (“every fine chunk is During some medium chunk”, “coarse chunks form a partition”, “no crossing between levels”).
- Ability to project, aggregate, or select views at any chosen resolution without destroying the others.
- Lineage so that a fine chunk can be traced to the coarse chunk that contains it, and vice versa.

These are not parser problems; they are problems of multi-scale claim geometry + policy-driven selection.

### What the current proposed kernel already covers

- Candidate recognition at any grain → ordinary collectors emitting claims of different kinds / levels.
- Flat sequential partitions → TokenLattice / path selection (already planned for the tokenizer factory).
- Containment forests → LaminarView (already present) and the future hierarchical variants of the lattice.
- Inter-claim geometry → AllenRelationSet + ClaimPairView (exact joins that retain witnesses).
- Selection and Boolean combination of evidence → ClaimSet.
- Provenance → derivation hyperedges and origin records.

The missing pieces are therefore thin.

### Targeted expansions required

**1. Multi-grain / hierarchical segmentation views**

Extend the TokenLattice idea into a family of hierarchical carriers:

- A **flat segmentation** remains a path (or ordered partition) of non-overlapping claims that Meet successively and cover a window.
- A **hierarchical segmentation** is a laminar forest (or a small set of concurrent forests) whose nodes are claims, with explicit parent/child links justified by Contains / During.
- A **multi-resolution view** is a collection of such segmentations, indexed by a discrete grain (or by claim Level / kind), together with the cross-grain ClaimPairView that records the containment or adjacency relations between them.

The key new value type is something like:

```text
HierarchicalSegmentation
  Window
  Nodes          // ClaimSet or ordered list of claim ordinals
  Parent links   // derived from exact Contains/During joins
  Roots
  Residual / crossing claims
```

or a lighter `MultiResolutionView` that simply holds several ClaimSets (one per grain) plus the inter-grain pair relation.

Laminarizer already computes one maximal forest; the expansion is to treat that result as a first-class, basis-stamped value that can itself be queried, filtered, and joined.

**2. Aggregation / coarsening operators**

Domain knowledge often wants to _derive_ a coarser chunk from a set of finer ones (e.g., “the contiguous sequence of statements that form a function body”). This is a special case of the structural deduction already planned:

- Premises: a ClaimSet of fine claims that form a path and are During a candidate coarse region.
- Conclusion: a new coarse claim whose span is the hull (or the exact union if it is contiguous).
- Derivation retains the fine premises.

No new algebra is required; the existing positive-deduction / chart-style machinery is sufficient once it can target a different grain. The only addition is an explicit “hull / contiguous-cover” projection that turns a ClaimSet into a single span when the set forms a path.

**3. Cross-grain consistency as ordinary constraints**

Once ClaimPairView exists, inter-resolution constraints are just filters or path-consistency steps on the pair relation between two grains:

- every fine claim must be During or Equal some coarse claim;
- coarse claims form a partition;
- no fine claim crosses a coarse boundary.

These are ordinary uses of AllenRelationSet + exact joins. They do not require a new sort.

**4. Grain as metadata, not a new carrier**

Prefer to keep grain as a property of claims (Level, kind, or an explicit Grain tag) rather than inventing a separate “resolution” object. Multi-resolution then becomes a view that groups ClaimSets by that property and materializes the cross-group geometry. This keeps the kernel small.

**5. Projection and selection policies remain external**

Which resolution is “primary”, whether concurrent overlapping chunkings are retained, how residuals are treated, and which aggregation rule is preferred are all adapter or orchestration policy. The kernel only supplies the geometric and relational vocabulary that lets those policies be expressed cleanly.

### What does _not_ need to expand

- The Allen relation-set algebra stays exactly as proposed.
- ClaimSet and ClaimPairView stay as proposed.
- TokenLattice stays as the flat sequential carrier; hierarchical views sit beside it or are built from it.
- Derivation and origin machinery are already general enough for both tokenizers and multi-scale chunks.
- No need for a full RCC-style region calculus or non-convex generalized Allen relations; the existing Boolean SpanSet + exact containment joins suffice for the hierarchical case.

### Resulting shape

The tokenizer factory and the multiresolution chunker factory become two instruments on the same kernel:

- Tokenizer factory emphasizes candidate edges, paths, and flat sequentialization.
- Chunker factory emphasizes multi-grain ClaimSets, hierarchical forests, and cross-grain containment joins.

Both rely on the same closed carriers (AllenRelationSet, ClaimSet, ClaimPairView, lattice/forest views, derivations). Domain adapters supply the recognition rules and the aggregation preferences; the kernel supplies the geometry, the relations, and the ability to keep multiple resolutions alive simultaneously.

The expansion required on top of the design in the deep-dive is therefore small and local: promote hierarchical / multi-grain segmentation views to first-class, basis-stamped values, and make sure the structural-deduction layer can target different grains. Everything else is already on the critical path for the tokenizer factory.

That keeps the kernel coherent: one many-sorted algebra over ordered carriers, two (and later more) families of instruments that differ mainly in which views and policies they emphasize.
