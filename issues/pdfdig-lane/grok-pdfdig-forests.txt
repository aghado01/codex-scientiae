# Tree based methods 


**Decision-tree family methods** (CART-style recursive partitioning and their ensembles) form a distinctive paradigm for data analysis and segmentation. They build hierarchical axis-aligned (or, in rarer variants, oblique) splits that capture non-linearities and feature interactions without strong parametric assumptions on the data distribution. This makes them powerful for tabular data with mixed continuous/categorical features, missing values, and heterogeneous scales—settings where pure distance- or density-based methods often struggle.

### Supervised core: Decision Trees, Random Forests, and Gradient Boosting
Single decision trees (CART, C4.5, etc.) produce highly interpretable partitions and are classic tools for *segmentation* (customer profiles, risk tiers, medical decision pathways). They overfit easily on noisy data.

**Random Forests** (Breiman) address this via bagging + random feature subsets at each split. Strengths include:
- Strong out-of-the-box performance and robustness to noise/overfitting.
- Built-in out-of-bag (OOB) estimates, variable importance (Gini or permutation), and a proximity matrix (fraction of trees in which two points land in the same terminal node).
- Excellent handling of mixed-type data and interactions.
- Natural parallelization.

Drawbacks: less aggressive accuracy than modern boosting on many tabular benchmarks; the model is less “sparse” and can be harder to interpret than a single tree (though SHAP and partial dependence help).

**Gradient boosting machines**, especially XGBoost, LightGBM, and CatBoost, build trees sequentially to correct residuals. They typically deliver higher predictive accuracy through regularization, shrinkage, column/row sampling, and optimized split finding. Specializations:
- XGBoost: highly tuned, handles sparsity/missing values well, strong multi-class and ranking support.
- LightGBM: histogram-based, extremely fast and memory-efficient on large/sparse data.
- CatBoost: ordered target statistics and oblivious trees for superior categorical handling and reduced prediction shift.

These are purely supervised. When ground-truth or proxy labels exist they excel at classification/regression and at *supervised segmentation*. When labels are absent they are not directly usable without adaptation.

### Unsupervised and anomaly-oriented variants
**Isolation Forest** is the purest unsupervised member of the family. It grows random trees by repeatedly selecting a random feature and a random split value until points are isolated. Anomalies (points that differ in any coordinate) tend to have short average path lengths. Advantages: linearithmic scaling, effective in moderately high dimensions, no density estimation or distance matrix required, and a natural “null”/outlier score. Limitations: primarily detects global or easily isolable anomalies rather than discovering multiple dense clusters; dense clusters of anomalies can be harder to flag; pure random splits can be less efficient than density-aware methods in very structured data. Extended Isolation Forest and related variants mitigate some axis-aligned and multi-modal issues. It is complementary to clustering: filter obvious outliers first, or score points after clustering.

**Unsupervised Random Forests** (Breiman’s contrastive approach and later refinements) generate synthetic data by independently sampling the marginals of each feature (or permuting), train a RF to distinguish real from synthetic points, then extract the proximity matrix among the real points only. The resulting similarity captures complex interactions and works especially well on mixed categorical/numerical data where Euclidean or even specialized distances are awkward. The proximity matrix can then be fed to hierarchical clustering, spectral clustering, MDS, or even HDBSCAN-style algorithms. This turns the RF into a powerful non-parametric similarity learner rather than a pure density estimator.

**CLTree (Clustering via Decision Trees)** and related “clustering trees” turn the recursive partitioning idea directly toward density. One influential formulation (Liu et al.) treats observed points as class Y and implicitly introduces uniformly distributed synthetic points as class N. A decision tree is grown with a density-aware or lookahead gain criterion that favors cuts isolating high-density (Y-dominated) regions from sparse (N-dominated) space. The resulting hierarchical hyper-rectangles describe dense clusters and empty regions; pruning parameters control minimum size and relative density. This yields interpretable, axis-aligned dense segments and naturally surfaces outliers/sparse areas. Related work uses variance reduction or other homogeneity criteria for top-down clustering trees.

Other variants include Extremely Randomized Trees (ExtraTrees), Mondrian forests (for online/streaming settings), and density-estimation trees. Gradient boosting is less commonly used in pure unsupervised mode, though residual-fitting ideas appear in some density or autoencoder hybrids.

**Overall merits for clustering/segmentation versus other paradigms**
- Strengths relative to k-means/GMM: no spherical or elliptical assumption; automatic interaction capture; native mixed-type support; feature importance for interpretation; robust to irrelevant features (especially RF).
- Strengths relative to pure hierarchical or spectral methods: inductive models (new points can be assigned without recomputing everything), scalability on large tabular data, and probabilistic outputs from ensembles.
- Weaknesses: axis-aligned bias (mitigated by deep ensembles and feature engineering); discrete rather than continuous density modeling; less natural discovery of arbitrary non-convex shapes purely from geometry unless adapted (proximities or CLTree-style density isolation help); can require careful regularization.
- Specializations: RF + proximities or CLTree for mixed-data segmentation; Isolation Forest for anomaly/null detection; boosted trees when high-accuracy discriminative models are needed on (pseudo-)labeled data.

### Hybrid use with density-based or physics-inspired clustering (SPC, HDBSCAN, etc.)
Your proposed pipeline—use a method that reliably labels dense cores, then train a tree ensemble on those partial labels to resolve ambiguous edge cases or assign a null/noise class—is a natural and powerful form of *cluster-then-classify* / selective pseudo-labeling / self-training.

**SPC here most naturally refers to Superparamagnetic Clustering** (Blatt, Wiseman & Domany, *Phys. Rev. Lett.* 1996 and follow-ups). Data points are treated as Potts spins with interactions that decay with (dis)similarity (often KNN-based). At intermediate temperatures the system enters a superparamagnetic phase in which tightly coupled groups of spins (dense, coherent regions) align internally while remaining weakly coupled to other groups. Clusters emerge from the resulting domains; the approach is hierarchical in temperature, does not require a pre-specified number of clusters, and can leave points unassigned. Fast/approximate variants (including maximum-likelihood and simulated-annealing implementations) exist. It is conceptually close to density-based methods in its emphasis on local coherence and has been applied in spike sorting, finance hierarchies, and protein sequence analysis. (There is also a 2021 deep-learning paper titled “Selective Pseudo-Label Clustering,” which is thematically close to the hybrid idea itself but less likely the intended base method.)

HDBSCAN (or DBSCAN) supplies an even more widely implemented alternative with explicit core-point, border-point, and noise semantics plus hierarchical stability.

**Concrete hybrid workflow**
1. Run SPC (or HDBSCAN / Density Peaks / etc.) and extract high-confidence core points belonging to each discovered cluster. Optionally label a subset of clear outliers as a null class if the method surfaces them.
2. Train a multi-class Random Forest or XGBoost (objective multi:softprob or equivalent) on the core-labeled points only. Class weights or focal loss can address size imbalance. Optionally augment features with density scores, core distances, or SPC membership strengths to retain local geometric information.
3. For the remaining (ambiguous/edge) points, obtain predicted probabilities. Assign to the argmax cluster if the maximum probability exceeds a tunable threshold (or if entropy is low); otherwise assign to null/noise. Soft memberships can be retained for downstream analysis.
4. Optional iteration (self-training): add high-confidence predictions back into the labeled set and retrain.

**Advantages of the hybrid**
- Density/physics methods supply reliable, assumption-light core labels and arbitrary-shape discovery; trees supply a global discriminative model that leverages feature interactions, mixed types, and high-dimensional structure more gracefully than pure nearest-neighbor or density extrapolation.
- Inductive: new points can be scored without re-running the full clustering.
- Probabilistic outputs give a principled soft-assignment or null mechanism (HDBSCAN-style semantics via confidence rather than pure geometric reachability).
- Feature importances / SHAP values explain *what* separates the clusters—valuable for analysis beyond mere labels.
- Robustness: ensembles tolerate moderate label noise in the cores; trees handle categorical features and missingness natively.
- Especially attractive on mixed-type or moderately high-dimensional tabular data where pure distance-based border assignment suffers from the curse of dimensionality.

**Drawbacks and caveats**
- Core-selection threshold is critical: too strict yields too few labels (under-fitting); too loose injects noisy labels. Validation via stability, silhouette-like metrics on held-out structure, or domain knowledge is needed.
- Trees can impose axis-aligned decision surfaces that slightly distort the original density-derived shapes, though deep ensembles and interaction capture mitigate this.
- Two-stage computation and the need to tune both the clustering parameters and the confidence threshold.
- If the data are purely geometric and continuous with clear density structure, pure soft HDBSCAN (or SPC hierarchical cuts) may be more faithful and simpler. The hybrid adds the most value when additional informative features exist, when an inductive/deployable model is required, or when interpretability of the assignment rules matters.
- Class imbalance and representation bias (cores may not fully sample the variability of borders) must be monitored.

**Related and complementary ideas**
- Unsupervised RF proximities can themselves be clustered or used as a similarity kernel inside density methods.
- Isolation Forest can pre-filter global anomalies, supply an extra anomaly-score feature, or serve as a one-class model per discovered cluster.
- One can train one-class models (Isolation Forest, one-class RF variants) per core and use them for soft assignment/novelty detection.
- Stacking density features into the tree model, or using the tree only for refinement while preserving original cluster metrics, further blends the strengths.

In short, the tree family offers a continuum from pure unsupervised anomaly detection (Isolation Forest) and density-oriented partitioning (CLTree, unsupervised RF proximities) through high-accuracy supervised segmentation (RF / XGBoost family). Pairing a core-labeling method such as Superparamagnetic Clustering or HDBSCAN with a subsequent RF or boosted-tree classifier is a coherent, practical way to obtain robust, interpretable, inductive assignments of ambiguous points and a null class—particularly effective on the mixed, interaction-rich tabular data that trees handle best. The precise gains depend on data characteristics, but the conceptual complementarity is strong.



# Big picture, as I'm reassessing and planning to reboot my pdf and tex conversion work in a new dedicated repo, I have been wondering about different decision tree and forests type methods, like isolation forest, random forest and others and how those might be useful in conjunction with clustering given the more complete utilization of my `PdfPig` IR and such

**Yes — tree and forest methods fit naturally alongside clustering once the PdfPig IR is richer.** They solve different parts of the same problem and can help you peel more rules while staying inside the perception / interpretation separation.

Here’s a practical big-picture view of how they complement each other for the reboot.

### 1. Distinct roles

| Method family | Strength | Natural jurisdiction in this system |
|---------------|----------|-------------------------------------|
| **HDBSCAN / hierarchical / mixture clustering** | Discovering stable regimes, configurations, and competing partitions (unsupervised structure discovery) | Style-palette recovery, math vs prose isolation, 2-D candidate regions, reading-order alternatives |
| **Isolation Forest** | Detecting anomalies / outliers without labels | Furniture, rare configurations, low-density glyphs, path outliers, low-confidence residuals |
| **Random Forest / Extra Trees / Gradient Boosted Trees** | Supervised or semi-supervised scoring, feature importance, learning simple decision boundaries from dual-availability papers | Predicting oracle roles/boundaries, ranking feature usefulness, distilling candidate tier-0 rules |
| **Single decision trees** | Interpretable rules | Discovering simple, human-readable dominance or veto rules that can later be promoted to code |

Clustering finds the structure. Trees/forests help decide *how trustworthy* that structure is, detect the weird cases, and (when oracle labels exist) learn which features actually matter.

### 2. High-value conjunction patterns

**A. Clustering → Isolation Forest (within-cluster anomaly detection)**  
Run the secondary symbolic HDBSCAN (or palette clustering) first.  
Then run Isolation Forest *inside* each major cluster (or on the residual points).  
This cleanly separates:
- Core members of a regime (high confidence)
- Boundary / low-density members (candidates for residual or competing hypotheses)
- True outliers (furniture, OCR garbage, rare symbols)

This gives you a natural margin signal for the measurement IR without hard thresholds.

**B. Dual-availability papers as a training signal for forests**  
On papers that have both PDF and LaTeX oracle:
- Extract the rich feature vectors (the ones we catalogued earlier).
- Label glyphs / configurations / boundaries from the oracle (math vs prose, heading vs body, inline vs display, etc.).
- Train a Random Forest (or ExtraTrees) to predict those labels.
- Use:
  - Feature importances → which engineered features are actually carrying signal (guides what to keep in the IR and what to drop).
  - The forest itself as a soft scorer or as a generator of candidate simple rules.
  - Partial dependence / SHAP-style views to understand interactions (size × font flags × local density, etc.).

This is one of the cleanest ways to turn the oracle into a teacher for feature selection and rule discovery, while still keeping the final runtime path free of the model if you want (distill the stable patterns into tier-0 rules or simple witnesses).

**C. Trees as rule proposers, not final deciders**  
Grow shallow, interpretable trees on the dual-availability data to propose dominance or veto rules (“if outline agrees and size > 1.15× body and not math-heavy → heading candidate”).  
Then subject those proposed rules to the normal gate discipline.  
Only promote the ones that survive calibration + transport.  
This is how the system can *grow more deterministic over time* (the flywheel in DESIGN.md §6) without you hand-writing every ladder.

**D. Isolation Forest as a global “weirdness” detector**  
Run it on the full page or document feature space as an early filter for:
- Page furniture
- Nested or rotated text that should be residualized early
- Path outliers that should not enter the main figure clustering

This reduces the load on later stages.

### 3. Where this helps the reboot most

- **Style-palette recovery**: Clustering finds the latent configurations; forests tell you which features discriminate them and can score membership confidence.
- **Math register isolation**: Symbolic HDBSCAN + Isolation Forest on the residuals gives cleaner math vs prose separation with explicit low-confidence tails.
- **2-D residual quality**: Clustering proposes competing assemblies; Isolation Forest or a small forest can rank how geometricly coherent each competitor is.
- **False-confidence reduction**: Outlier scores and forest predictive uncertainty become first-class margin signals that the measurement IR can consume.
- **Rule peeling**: Feature importances + distilled shallow trees give you an empirical basis for deleting or simplifying current ladders instead of guessing.

### 4. Practical stance for the new repo

Keep the core doctrine:
- Clustering and Isolation Forest stay unsupervised / perception-side (or lightly supervised only on dual-availability data for analysis).
- Any forest that predicts semantic labels should be treated as a *teacher* or *scorer*, not as the final authority in the runtime path unless it is heavily gated and measured.
- Prefer distilling stable patterns into explicit, inspectable rules or witnesses over shipping a black-box forest in the main conversion path.

A clean architecture sketch:

```
Rich PdfPig IR
    ↓
Multi-view clustering (geometric HDBSCAN + symbolic HDBSCAN + palette)
    ↓
Isolation Forest (global + within-cluster) → outlier / margin scores
    ↓
Competing hypotheses + confidence / residual packaging
    ↓
(on dual-availability papers only) Random Forest analysis → feature ranking + candidate rules
    ↓
Measurement IR (typed chunks with status + margins)
```

This combination lets you push much further on discovery while keeping the final decisions either forced (tier-0), residualized, or agent-adjudicated — exactly as the constitution requires.

Would you like me to sketch a concrete experimental plan for the dual-availability papers (what labels to extract from the oracle, what forest setup, how to use the importances), or go deeper on how Isolation Forest scores should appear in the residual packets / measurement IR?

# yea i've been thinking about using forests as part of the bridge to the reasoning model's job which is likely evolving into not only residuals but for making semantic decisions. Packaged correctly and with correct epistemic guidance, perhaps somehow this could help as part of the contextual evidence for a given unit task assigned to a model or its subagents. Also, a theme i've noticed in the clustering work is that clusters often have different kinds of outliers, which i believe has shown up already in the headers problem. Please do check me on this if you can but does it make sense?

**Yes, both points make sense and fit cleanly.**

### 1. Different kinds of outliers inside clusters

This is a real and useful observation. Clusters (especially regime / palette / heading-candidate clusters) almost never have a single homogeneous “noise” class. Empirically we already see several distinct outlier types in the headings work:

- **Margin / borderline members** — size or weight just over the threshold, still statistically close to body.
- **Mixed-role or run-in lines** — bold prefix + regular tail, or math-heavy lines that happen to be large.
- **Outline-supported but typographically weak** — the classic `outline_fragment` / numbering mismatch cases that get demoted or over-promoted.
- **Typographically strong but outline-absent or conflicting**.
- **Local density / isolation outliers** — large isolated text that is actually a caption, figure label, or page furniture.
- **Unknown or rare font-role points**.

Treating all of these as one residual bag loses information. Distinguishing the *kind* of outlier lets you:

- Apply different typed dominance rules or safe defaults.
- Package much more precise evidence briefs for the agent.
- Measure which residual classes are actually hard for the model versus which ones are just poorly typed upstream.

Isolation Forest (global + within-cluster) is a natural tool here. It surfaces continuous isolation scores and can help separate these modes when combined with a few simple post-hoc checks on the same feature vector.

### 2. Forests as epistemic packaging for the reasoning tier

This is a strong, constitutionally compatible direction.

The reasoning tier is already evolving from “only pure residuals” toward more semantic decisions. Forests can sit in the evidence layer of that expansion without becoming the decision maker:

- **Isolation Forest** supplies unsupervised, document-local anomaly / isolation scores and can help type the outliers above.
- **Random Forest / Extra Trees** (trained only on dual-availability papers) can supply:
  - Soft class probabilities or competing-label scores
  - Feature attributions / local explanations (“this point is being pulled toward heading mainly by size + outline agreement; density and math_frac argue against”)
  - Predictive uncertainty

Packaged correctly, these become first-class soft evidence inside the unit-task brief, exactly analogous to how `math-evidence` already projects geometry into a text form the model can use.

A sketch of the packaging contract:

```json
{
  "question": "Is this a heading, and at what depth?",
  "unit_features": { ... },
  "cluster": {
    "id": "...",
    "membership_strength": 0.71,
    "outlier_kind": "margin_size_outline_conflict",
    "isolation_score": 0.82
  },
  "forest_evidence": {
    "type": "supervised_rf_dual_availability",
    "trained_on": "N papers, config_hash=...",
    "predicted_labels": {"heading": 0.64, "body": 0.29, "other": 0.07},
    "top_supporting_features": ["size_ratio", "outline_agreement"],
    "top_opposing_features": ["math_frac", "local_density"],
    "epistemic_status": "soft evidence only — not authoritative"
  },
  "geometric_evidence": { ... },
  "constraints": ["must be consistent with outline witness if present", "prefer abstention over false positive"],
  "verifier": "deterministic heading grammar + render/lint"
}
```

Key principles that keep this clean:

- Forests never decide. They only enrich the evidence brief.
- Epistemic status is explicit (“unsupervised isolation score”, “supervised soft prediction trained on dual-availability data”).
- The agent still proposes; the deterministic verifier still gates.
- Consistent agent decisions on a given residual class can later be distilled into better features or tier-0 rules (the flywheel).

This turns the different kinds of outliers from a nuisance into a feature: each type can carry a slightly different evidence package and prompt, which should improve both residual compression and the quality of the semantic decisions the model is asked to make.

The overall shape stays faithful to the constitution: richer perception and discovery upstream, better-typed evidence for the reasoning tier, and no silent resolution of disagreement.

Does this match the direction you were sensing, or do you want to push further on how the outlier typing or the forest evidence should be structured for specific unit tasks (headings vs 2-D math vs inline/display boundary)?




# I was kind of thinking of using isolation or random forest *within clusters labeled by hdbscan*, symbolic or geometric, as a way of trying to inductively disambiguate or refine the discovery of, for example, headers.


**Yes — that is a clean and productive pattern.**

Using Isolation Forest (or a lightweight forest) *inside* HDBSCAN clusters is one of the better ways to move from coarse regime discovery to finer, more reliable structure without writing more ladders.

### How the pattern works for headings

1. **Primary clustering (symbolic or joint geometric+symbolic HDBSCAN)**  
   Produces candidate regimes / configurations. One or more of these clusters will contain most of the heading-like material (large size, higher weight, certain fonts, positional recurrence, etc.).

2. **Within-cluster Isolation Forest (or local density + isolation scoring)**  
   Run on the members of the heading-candidate cluster(s) using the same or a refined feature vector.  
   This surfaces the internal structure of the cluster:
   - Core, high-density, low-isolation members → strongest heading candidates.
   - Margin / borderline members → size or weight just across the threshold.
   - Mixed-role or run-in points.
   - Outline-supported but typographically weak points.
   - Local outliers that happened to land in the cluster (captions, figure labels, page numbers, math that is large, etc.).

3. **Inductive refinement**  
   The isolation scores + a few cheap relational checks (outline agreement, position in the page, local density, math_frac, bold-tail ratio, etc.) let you *type* the members of the cluster instead of treating the whole cluster as uniform.  
   You can then:
   - Promote the core low-isolation members more confidently (or with higher margin).
   - Send the different outlier kinds into more precise residual packets or competing hypotheses.
   - Apply typed dominance rules only where the evidence is strong (e.g., core + outline agreement → accept; high isolation + no outline → residual or demote).

This is inductive in the useful sense: the clustering proposes a hypothesis about a regime; the within-cluster forest tests the coherence of that hypothesis and exposes its internal heterogeneity. You are not forcing a single decision on every member of the cluster.

### Why this is better than the pure ladder for headings

The current heading ladder has to hard-code many of the distinctions above (run-in detection, math-heavy veto, outline fragment handling, etc.).  
By letting HDBSCAN first group the plausible candidates and then letting Isolation Forest characterize the *kinds* of members inside that group, many of those distinctions become observable properties of the data rather than special cases in a decision list.

The same pattern generalizes:
- Inside a “math” cluster → refine inline vs display vs operator-heavy vs residual 2-D.
- Inside a large-size cluster → separate true headings from display math, section numbers, captions, etc.
- Inside figure-related clusters → separate clean regions from strays or furniture that leaked in.

### Epistemic status and jurisdiction

This stays cleanly on the perception / discovery side:
- HDBSCAN + within-cluster Isolation Forest are still unsupervised (or only lightly informed by dual-availability analysis).
- They produce typed candidates + scores + outlier kinds.
- Final acceptance, residual packaging, or agent adjudication still follows the normal jurisdiction ladder.
- The forest is not making the semantic decision; it is refining the discovery so the downstream decision (or residual) is better informed.

When you later look at dual-availability papers, you can also train a small supervised forest *on top of* these within-cluster features to see which isolation patterns actually predict oracle heading status. That becomes analysis and potential rule distillation, not runtime authority.

### Practical sketch for headings

```
Symbolic (or joint) HDBSCAN
    → heading-candidate cluster(s)
        → Isolation Forest inside the cluster
            → core members (low isolation)
            → margin members
            → mixed-role / run-in
            → outline-conflict or outline-only
            → local density outliers
        → typed candidates + scores + evidence
            → dominance rules or residual packets
```

This gives you a much more nuanced view of the “heading” regime than a flat cluster or a long decision ladder, and it directly addresses the multi-type outlier phenomenon you observed.

It is a good direction for the reboot. It keeps the discovery machinery data-driven while still producing the typed, confidence-aware candidates that the measurement IR and the reasoning tier need.

Do you want to pressure-test this pattern on the other major residual classes (especially inline/display math boundaries or 2-D candidates), or refine the feature vector that should be used for the within-cluster Isolation Forest on headings?