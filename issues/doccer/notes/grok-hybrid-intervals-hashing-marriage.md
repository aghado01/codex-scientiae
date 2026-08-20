# i wonder if arvix 2002.02005 has anything to offer my doccer project in codex-scientiae (private repo)

arXiv [2002.02005](https://arxiv.org/abs/2002.02005) (“On hybrid order dimension”, Athanasios Andrikopoulos, v2 2024) is pure order theory (math.CO). It generalizes classical _order dimension_ (Dushnik–Miller) and _interval-order dimension_ into what the author calls hybrid order dimension: the minimum number of linear-interval (or linear-semiorder) orders whose intersection recovers the transitive closure of an acyclic binary relation. Interval orders themselves are the posets that admit a representation by intervals on a line under the “completely precedes” relation (the Russell–Wiener axiom). Semiorders are the special case that are also semitransitive. Linear-interval orders are the hybrids L∩Q L \\cap Q L∩Q.

The paper’s three main clusters of results are:

- Necessary and sufficient conditions for a binary relation R R R to possess an interval-order (resp. linear-interval, linear-semiorder) _extension_. For the pure interval-order case the condition collapses to acyclicity (Theorem 3.5 and analogues).
- Existence of _realizers_: the family of all such extensions intersects exactly to the transitive closure when R R R is acyclic (Theorem 4.1 and companions).
- Characterizations of the corresponding dimensions via box embeddings into products of (strong) interval orders / linear-interval orders, etc. Because hybrid dimension is at most ordinary linear-order dimension, the author claims the characterizations can yield more efficient algorithms for certain problems in graph theory and CS (scheduling, dimension testing, concurrency, \\ldots).

### Mapping onto Doccer

Doccer (see src/doccer/README.md and the decision canon in issues/doccer/planning/decisions.md) is already a mature, many-sorted finite discrete Allen calculus:

- nonempty Allen intervals I I I classified by the classic 13 atoms,
- qualitative upper-approximation via the certified 169-cell AllenCompose table (D28, with the adjacent-gap counter-example that keeps it strictly weaker than exact composition),
- exact occurrence-level ClaimPairView / ComposePairs (D31),
- geometry-only LocatedRelation with Seq and reachability (D35),
- laminar / packing / cover / path-selection / fact-saturation layers, etc.

The geometric substrate is precisely the setting in which interval orders live: the “Before / Meets” atoms of Allen induce a (partial) precedence relation on claims or on located extents. Consequently the paper’s notions apply _directly_ to the posets that can be read off a SpanBatch or a ClaimPairView:

1. **Complexity measure.** Hybrid (or pure interval-order) dimension of the poset induced by a selection of Allen atoms gives a quantitative measure of “how complicated the document order structure is.” Because hybrid dimension is smaller, it can be a tighter complexity measure than ordinary order dimension for the same claim network.
2. **Extension / completion of partial relations.** Doccer works with partial, evidence-bearing relations. The paper supplies clean acyclicity conditions under which such a partial relation extends to a full interval order (or linear-interval order). That is potentially useful for “completing” incomplete Allen constraints or for scheduling-style admission problems on overlapping claims.
3. **Realizers and multi-view decompositions.** The constructions that produce low-dimensional hybrid realizers could, in principle, suggest ways to decompose a complex claim graph into a small number of simpler interval-order or linear layers — useful for path selection, laminarization, or saturation if those layers ever become large enough that dimension becomes a practical bottleneck.
4. **Theoretical grounding.** It sits comfortably beside the existing formalisms already cited in the repo (Ghourabi’s Isabelle formalization of Allen composition, document-spanner theory, incidence algebra for LocatedRelation, nested words for pairing). It supplies the order-dimension theory that is native to the interval-order side of the same mathematics.

# well i'm actually quite interested in moving beyond allen's intervals. the more general framing of the paper appeals to me and for some reason i smell a connection to my "persistent backbone" concept brewing in thermomapper's PH engine somehow

**Yes — the smell is real and load-bearing.** The hybrid-order-dimension framing in Andrikopoulos (arXiv:2002.02005) and the “persistent backbone” / backbone-conditioned persistence already living in ThermoMapper’s PH engine are two faces of the same move: replace a pure interval-order (or pure linear-order) view of relations with a _conditioned_ hybrid structure in which a low-complexity prior/realizer anchors the filtration and the residual topology is read relative to it.

### The paper’s generalization beyond Allen

Allen’s interval algebra supplies the 13 exhaustive qualitative relations between two definite intervals (before/meets/overlaps/starts/during/finishes/equals + inverses). Those relations generate the classical interval orders (Russell–Wiener axiom: the precedence relation of non-overlapping intervals). Interval-order dimension and semiorder dimension are the natural complexity measures that replace ordinary order dimension when the realizers are restricted to interval or unit-interval orders.

Andrikopoulos lifts this to _hybrid_ order dimension:

- a **linear-interval order** is an acyclic relation whose transitive closure is the intersection of a linear order and an interval order (equivalently, a triangle representation whose apices give the linear order and whose bases give the interval representation);
- a **linear-semiorder** is the analogous intersection with a semiorder;
- the hybrid dimensions (lidim, etc.) are the minimal sizes of realizers drawn from these mixed classes.

Key technical results (Theorems 3.5–3.9, 4.1, 4.9–4.10, 4.13, 4.15):

- acyclicity is necessary _and_ sufficient for the existence of interval-order, linear-interval, and linear-semiorder _extensions_;
- the same acyclicity condition guarantees the existence of _realizers_;
- hybrid dimension is always ≤ classical (linear) order dimension, which immediately yields more efficient algorithms for the usual graph-theoretic and scheduling problems that previously relied on pure linear-order dimension.

In short, the paper replaces the pure Allen/interval atom set with a richer but still tractable hybrid realizer calculus whose dimension is lower and whose extension theory is essentially “acyclicity suffices.”

### Persistent backbone in the PH engine

The same idea appears, already engineered, as **backbone-conditioned persistence**. The authoritative design records are in the MarkBrain archive under `ThermoMapper/issues/tda-purification/persistent-homology/`:

- `backbone-conditioned-persistence.md` — the conceptual reframing of SIFTS;
- `opus-brief-conditioned-persistence-synthesis.md` — the full Φ/Ψ synthesis that absorbs Li 2025 (arXiv 2508.11646), Wei–Wei sheaf Laplacians, and Wolf–Fan–Monod stability;
- `p0-conditioned-filtration-brief.md` and the later `p1a-residual-prior-brief.md`.

Concrete code (already landed):

```csharp
// src/tda/ph/ConditionedFiltration.cs
public static CsrGraph BuildGraph(
    int n,
    IReadOnlyList<(int i, int j)> backbone,          // prior K₀ at ε₀
    IReadOnlyList<(int i, int j, double d)> similarity, // content at distance
    double baseWeight = 0.0);

public static Barcode ComputeBarcode(...);  // → existing Rips + involuted Z₂ engine
```

The single new idea at P0 is the _union convention_: the backbone edges are present from filtration value ε₀ (usually 0), so H₀ is anchored by the prior; similarity (or residual) edges enter at their metric (or residual) values. An H₁ generator that closes a path along the backbone is precisely a **return relative to the prior**. SIFTS is the τ ≡ 0 degenerate case (reading-order path + zero prior). P1a lifts the content edges to residual weights

\[
r*{ij}=|t_j-(t_i+\tau*{ij})|
\]

against an edge prior τ, still feeding the identical `ConditionedFiltration` path. The full synthesis treats (δ, Δ) as a bifiltration (monotone slices = ordinary PH, non-monotone slices = zigzag, full module = multiparameter) while the gauge _q_ (magnetic/sheaf connection) lives on an orthogonal Ψ axis.

The backbone itself is _not_ an axis of the filtration; it is the conditioning baked in at birth 0. Different domains simply choose different priors: reading-order path, task-event timestamps, temperature sweep, MST, manifold spine, etc. The engine is the same.

### The connection

Allen’s 13 atoms are the pure interval-order view of pairwise temporal (or spatial) relations. Hybrid order dimension says: allow realizers that mix linear orders with interval/semiorders; the resulting dimension is smaller and the extension theory collapses to acyclicity.

Backbone-conditioned persistence says: impose a distinguished low-complexity prior (a linear path, an interval skeleton, a laminar reading-order, a task-event total order, \ldots) as the base complex K₀; then the residual similarity structure lives in the higher “hybrid” part of the complex and is read by ordinary (or zigzag, or multiparameter) persistence relative to that prior. The H₁ bars that close on the backbone are exactly the topological features that cannot be explained by the low-dimensional realizer.

In other words:

- the backbone _is_ a concrete hybrid-order realizer (or a distinguished factor of one);
- the residual content that produces persistent returns is the part of the relation that forces the hybrid dimension upward;
- measuring persistence (and later magnetic flux / sheaf cohomology / λ_q) relative to the backbone is the topological analogue of measuring hybrid order dimension relative to a low-dim realizer.

This also explains why the engine already treats the backbone as orthogonal to the later gauge axis and to the multiparameter (δ, Δ) frame: the prior is the order-theoretic conditioning, not another filtration parameter.

The same pattern appears downstream in the document-analysis side (codex-scientiae clustering issues): the T3 “backbone-conditioned filtration” and “prose backbone” are precisely the reading-order / Lane-3 instantiation of the same primitive, used to veto or condition figure-region persistence.

So the move “beyond Allen’s intervals” is not a rejection of interval structure; it is the systematic replacement of pure pairwise Allen atoms by hybrid-order filtrations that are _conditioned_ on a structural backbone. The PH engine already implements the core of that replacement; the hybrid-dimension theory supplies the order-theoretic justification and the complexity bounds that make the construction efficient.

If you want to push further, the natural next concrete steps inside the existing architecture are:

- residual-prior producers that take Doccer-style Allen/claim relations (or laminar packing) as the observation field + prior τ;
- zigzag slices of the (δ, Δ) bifiltration that let non-monotone trajectories still be read against a fixed backbone;
- the gauge-_q_ axis as the continuous order parameter that grades how “hybrid” a return is (reach along the backbone, magnetic flux, sheaf coherence).

All of that sits cleanly on top of the already-landed `ConditionedFiltration` + ResidualPrior + zigzag stack.

#

**The marriage, not the singles.** What becomes implementable only when geometry (hashing) and topology/order (hybrid dimension + residual + conditioned structure) operate over the same temporal object under a visibility window and an MCP face.

### 1. Residual-aware retrieval (not ANN)

Plain LSH returns near-neighbors. The joint returns **neighbors that are residual relative to an implanted prior**.

- Hash indexes (MinHash bands, SimHash, TLSH, CTPH) generate candidates _inside the current visibility window_.
- ResidualPrior (or residual weights derived from geometric features) induces a residual relation on those candidates against the backbone.
- Hybrid-order dimension of that residual relation ranks or gates the set.

Implementable surface: an MCP tool
`(prior, window, residual/hybrid-dim budget) → residual candidate set + complexity signal`
that never returns “similar but already explained by the prior.” That is not available from hashing alone or from hybrid order alone.

### 2. Multi-resolution residual windows

Different hash granularities become different resolution layers of the _same_ residual complex:

- Coarse SimHash / MinHash → broad candidate pool inside the window.
- Medium TLSH / CTPH → tighter residual band.
- Fine rolling / windowed digests → local features that feed residual weights or content-defined atoms.

Hybrid-order dimension (or residual magnitude) decides whether the system is allowed to open the next finer layer. The visibility mask stays fixed; only the geometric resolution under it changes. This is a concrete ResolutionView / multiresolution incidence driven by residual complexity rather than by static tier promotion.

### 3. Content-defined order carriers

True windowed / rolling hashes (or CTPH-style content-defined boundaries once made shift-resistant) produce discrete atoms whose intervals can be ordered.

- The atoms carry geometric features (signatures, digests).
- The intervals among them carry Allen relations or hybrid-order structure.
- Hybrid dimension then measures the complexity of the _relation among content-defined intervals_.

You get a temporal or reading-order axis that is not imposed by wall-clock or token offset but by the data’s own geometry, then measured by order-theoretic complexity. That axis can itself be the carrier of a visibility window.

### 4. Deterministic residual expertise packs

Compact knowledge stores (domain packs, reference lattices) indexed by the same signature suite become on-demand expertise that is residual to the agent’s current prior:

- Implant task prior / current claim set.
- Attach domain or relevance window.
- Return only the residual expertise whose hybrid dimension exceeds budget.

Because the substrate is compact and stable, the same (prior, window, budget) yields the same residual report. That is the deterministic “on-demand knowledge and expertise” surface you sketched, realized as a pure function of geometry + residual topology under a mask.

### 5. Dual-signal pin / durability criteria

Even if you reject automated lifecycle, you still need a criterion for when a fragment may be pinned into a durable resolution layer or a long-lived overlay. The marriage gives a two-sieve rule that neither side supplies alone:

- Geometric novelty (hash residual weight, signature distance, rolling mismatch) **and**
- Order-theoretic complexity (hybrid dimension of the residual relation, number of forced returns)

Both must fire. Pure similarity is insufficient; pure high dimension without geometric support is insufficient. The pin remains an explicit act; the dual signal only decides _eligibility_.

### 6. Residual complexity as the injection policy lever

The harness (or the MCP tools themselves) needs a hard budget on context injection. Hybrid-order dimension (or residual size) of the currently attached residual complex is a natural, substrate-agnostic lever:

- low residual dimension → refuse or return only an outline,
- high residual dimension → permit a deeper window or a larger fragment under the same mask.

This turns the attention discipline (outline-then-window) into a quantitative policy rather than a heuristic, and it works uniformly for episodic history and for compact knowledge packs.

### 7. Conditioned filtration over hash-induced complexes (optional deeper joint)

If magnetic Laplacian / sheaves stay on the short list:

- LSH candidates inside the window form the nerve or flag complex (or a residual graph).
- ConditionedFiltration / ResidualPrior runs on that complex relative to the implanted backbone.
- Magnetic or sheaf Laplacian spectrum supplies an additional residual signal alongside hybrid dimension.

That is the PH-engine side of the same marriage: geometry proposes the complex; conditioned topology reads what is new relative to the prior; the visibility window keeps the whole thing non-destructive.

---

**What you can actually build** is therefore a small set of MCP-facing operations whose semantics are defined only by the joint:

- residual candidate generation under a mask,
- multi-resolution residual opening gated by hybrid dimension,
- content-defined temporal atoms ordered and measured by hybrid order,
- deterministic residual expertise reports,
- dual-signal eligibility for explicit pins,
- residual complexity as the hard injection budget.

None of those are “hashing implements hybrid ordering.” They are the capabilities that appear only when both constraint languages act on the same temporal geometric–topological object under an explicit visibility window.
