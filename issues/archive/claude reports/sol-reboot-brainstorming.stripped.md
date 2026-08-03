# Compare opendataloader PDF and Miner

> lets review `packages/opendataloader-pdf`, I want to do a deep dive into the way it works and how it breaks the problem down like we did with analysis of MinerU `D:\aghado01\codex-scientiae\issues\sol-minerU-breakdown.md`. I want to understand the java path and its heuristics, how PDF gets decomposed and triaged. And then try to cross-examine against minerU. Both of them use VLMs, they are trying to solve the same problem, but they break the problem down differently and with different architecture and mechanisms


Completed the deep dive and cross-examination:

[OpenDataLoader PDF architecture breakdown](C:/Users/azrie/Documents/Codex/2026-07-22/lets/outputs/sol-opendataloader-pdf-breakdown.md)

Core findings:

- OpenDataLoader is a born-PDF semantic compiler: operators → native chunks → geometric/typographic heuristics → semantic graph.
- Its auto hybrid triage is primarily a Unicode-failure and table detector—not a general page-difficulty classifier.
- Backend routing is whole-page; MinerU’s hybrid architecture reconciles evidence at finer region/channel granularity.
- OpenDataLoader’s explicit local VLM is optional picture-description enrichment. MinerU makes page-image VLM parsing first-class.
- Important pressure points include portrait scans and formulas not automatically routing, Java/hybrid-Java pipeline drift, sparse-page range overprocessing, and partly dormant XY-Cut++ logic.
- The report includes the tagged-PDF lane, exact veraPDF decomposition, heuristic thresholds, backend reconciliation, IR comparison, failure modes, diagrams, and commit-pinned source links.

Both reviewed repositories remain unchanged. This was a static source trace; no live hybrid backend was run, and Maven was unavailable on the current command path.

> This is good, alot to process. I think what i have in mind shares aspects of both of them, and I'm still trying to formulate what my approach actually is and how I will utilize reasoning models in conjunction with pdfpig/clustering. I think one distinction of my approach is leaning much more heavily into clustering and potentially some decision-tree methods like I've discussed here `D:\aghado01\codex-scientiae\issues\src-reorg\grok-retrospectives-review.md`. So much going on, oof


Yeah—there really is a lot here. But rereading the retrospective makes me think your architecture is already more coherent than it feels. You’re not choosing between OpenDataLoader and MinerU; you’re defining a third decomposition.

A provisional formulation:

> A cluster-first, evidence-preserving PDF transducer that derives competing structural hypotheses from born PDF signals, resolves clear cases with deterministic witnesses and lightweight learned policies, and escalates only genuine residual ambiguity to reasoning models.

That gives the three approaches distinct centers of gravity:

| System         | Primary discovery mechanism                                | Models mainly do                                       |
| -------------- | ---------------------------------------------------------- | ------------------------------------------------------ |
| OpenDataLoader | Ordered geometric and typographic heuristics               | Handle selected difficult pages                        |
| MinerU         | Learned visual segmentation and recognition                | Produce most semantic structure                        |
| Your approach  | Multi-view clustering and relational hypothesis generation | Adjudicate, route, and interpret unresolved structures |

The crucial difference is that clustering isn’t merely one table detector or preprocessing utility in your design. It discovers the document’s own regimes: body typography, heading configurations, math configurations, furniture, alignments, recurring layouts, baseline flows, and anomalous objects. That lets the document participate in defining its parser rather than being fed through one fixed universal cascade.

I’d currently picture the system as:

```text
PdfPig born evidence
    ↓
atomic and relational feature views
    ↓
multi-scale clustering / graph discovery
    ↓
small set of competing structural hypotheses
    ↓
deterministic witnesses + shallow trees/forests
    ↓
confidence boundary
    ├── accepted → measurement/manuscript IR
    └── residual → reasoning-model adjudication
```

The method families then have cleanly separated jobs:

- **Clustering discovers:** What configurations and regimes exist in this document?
- **Graphs generate relations:** Which glyphs, paths, baselines, and regions plausibly belong together?
- **Decision trees/forests score or route:** Given these candidates and witnesses, which hypothesis is supported strongly enough? Is this case anomalous?
- **Deterministic rules enforce invariants:** Impossible geometry, clear dominance, formal grammar constraints, and high-margin cases.
- **Reasoning models adjudicate residuals:** Given two or three explicit hypotheses and their evidence, which interpretation best explains the page?
- **Markpig formalizes:** Once a mathematical interpretation is accepted, turn it into a canonical AST and surface representation.

That means trees shouldn’t become a new giant parsing cascade. Their most natural uses are narrower:

- Random Forests or Extra Trees score candidate headings, captions, list structures, math groupings, or reading-order alternatives.
- Isolation Forest identifies unusual configurations that should become residuals, not decide what those configurations mean.
- A learned routing tree predicts which evidence channel or specialist should inspect a case.
- Feature importance reveals which old hand-written rules are genuinely supported and which can be removed.
- Resolved residuals become training data, gradually moving recurring cases out of the reasoning-model path.

The reasoning model also has a more precise role than “parse this page.” It receives a compact evidence packet:

```text
candidate A
candidate B
supporting and contradicting witnesses
source glyph/path IDs
local rendering
document-level analogues
requested decision
```

It should return an auditable adjudication tied back to that evidence—or decline when the evidence is insufficient. That preserves the retrospective’s most important boundary: uncertainty remains explicit and out-of-band rather than being laundered into confident Markdown.

So I think your deepest organizing principle may be:

> **Discovery before classification; competing hypotheses before adjudication; provenance before projection.**

You do not need to decide every algorithm yet. The stable architectural commitments already seem to be:

1. PdfPig evidence is never thrown away prematurely.
2. Clustering proposes structure rather than assigning final semantics.
3. Easy, high-margin decisions remain deterministic and cheap.
4. Ambiguous cases preserve multiple hypotheses.
5. Trees learn boundaries and routing policies.
6. Reasoning models operate at the residual confidence boundary.
7. Final Markdown is a projection of accepted structure, not the working memory of the parser.

That is a real architecture—not just a bag of techniques. The next useful step is probably a short “architecture charter” that names these layers and assigns ownership, before diving into another implementation subsystem.

> I'm not satisfied with this architecture, its still too nebulous. I want to focus on identifying my breakdown of the problem, and what I can solve by using clustering with different atomic/engineered feature sets. Like that discussion, I was thinking about identifying headers using isolation forest in conjunction with hdbscan and certain features

Agreed. My previous framing was still too system-shaped. The useful unit is not “the architecture”; it is a catalog of inference problems, with an explicit account of what clustering can and cannot solve for each one.

The recurring contract should be:

| Question           | Meaning                                                               |
| ------------------ | --------------------------------------------------------------------- |
| Population         | What objects are being clustered—glyphs, lines, blocks, paths, pages? |
| Scope              | One neighborhood, page, document, or corpus?                          |
| Feature view       | Which atomic and engineered evidence is visible?                      |
| Discovery target   | What latent grouping should clustering reveal?                        |
| Output             | Memberships, regimes, noise scores, or competing partitions?          |
| Semantic remainder | What clustering cannot name or decide?                                |

## A more concrete decomposition

| Problem                | Population                            | Clustering can discover                                       | Clustering cannot determine alone                                |
| ---------------------- | ------------------------------------- | ------------------------------------------------------------- | ---------------------------------------------------------------- |
| Glyphs → lines         | glyphs on a page                      | baseline and spacing groups                                   | spaces, reading direction, unusual scripts                       |
| Lines → paragraphs     | lines in a region                     | leading, indentation, alignment, and style regimes            | whether a block is prose, caption, quotation, etc.               |
| Typography regimes     | glyph runs or lines across a document | body styles, heading styles, math styles, rare configurations | semantic names for those regimes                                 |
| Columns and page zones | lines/blocks on a page                | spatial partitions and recurring alignments                   | final reading order across ambiguous partitions                  |
| Running furniture      | lines/blocks across pages             | repeated positional/textual families                          | header versus footer versus page number versus recurring content |
| Lists                  | lines and prefix configurations       | indentation and label-alignment families                      | numbered heading versus list item                                |
| Tables                 | words, rules, and paths               | x/y bands, alignment families, candidate rows and columns     | cell spans and semantic table interpretation                     |
| Math regions           | glyph/path neighborhoods              | distinct 2-D configurations, size tiers, baseline families    | final Math AST and attachment choices                            |
| Figures and captions   | images/path regions plus nearby text  | stable proximity/configuration groups                         | whether nearby prose is truly a caption                          |

This is closer to your actual breakdown: a collection of differently scoped discovery problems, not one universal clustering pass.

## Atomic versus engineered evidence

Your feature taxonomy can be made much more precise.

### 1. Born atomic features

Directly available from PdfPig:

- bbox and baseline;
- glyph advance, width, and height;
- font identity and metrics;
- font size, weight, italic state;
- fill/stroke color and rendering mode;
- character/Unicode category;
- transformation and rotation;
- path geometry;
- XObject membership;
- clipping and graphics-state information.

### 2. Local relational features

Computed between nearby atoms:

- baseline difference;
- horizontal and vertical gaps;
- overlap and containment;
- shared centers or edges;
- font/style equality;
- relative size;
- path–glyph proximity;
- local density;
- nearest-neighbor configuration;
- alignment-graph membership.

### 3. Document-relative features

These are often more useful to clustering than the raw values:

- font size divided by document body mode;
- gap divided by median leading;
- position normalized by page dimensions;
- distance from a body-style cluster;
- font/style rarity;
- indentation relative to the local column;
- deviation from the dominant baseline flow;
- whitespace separation relative to neighboring blocks.

### 4. Cross-page recurrence features

Necessary for furniture and repeated configurations:

- fraction of pages on which the configuration occurs;
- normalized-position variance;
- text-template similarity;
- digit/date-normalized text signature;
- font/style consistency;
- odd/even-page periodicity;
- run length and missing-page pattern;
- recurrence within the same page zone.

Rather than concatenate all of these into one giant feature vector, I would treat them as separate views. Geometry clustering, typography clustering, and recurrence clustering can produce independent witnesses.

## Headers: a concrete HDBSCAN + Isolation Forest decomposition

Assuming “header” means running page furniture, the observation unit should be a completed line or small line configuration—not a glyph.

A running header is not simply an anomaly. It is:

> A recurrent family of lines that is spatially stable, separated from body flow, and usually atypical relative to ordinary page content.

That distinction determines the division of labor.

### Phase 1: discover the body regimes

Run HDBSCAN over line-level flow/style features such as:

```text
font-size ratio
dominant font regime
line height
normalized width
leading above and below
left/right alignment
indent relative to column
local text density
```

This identifies one or more ordinary body regimes without assuming that the document has exactly one body style.

The useful outputs are:

- cluster membership;
- membership probability;
- HDBSCAN noise status;
- distance from the nearest body regime.

### Phase 2: score deviation from ordinary flow

Use Isolation Forest over engineered line features:

```text
normalized x/y position
distance from body regime
font/style rarity
whitespace separation
line width and density
neighbor configuration
```

Isolation Forest answers:

> How unusual is this line relative to the document’s ordinary line population?

It does **not** answer whether the line is a header. Chapter titles, captions, display equations, and isolated footnotes may also score as anomalous.

The isolation score becomes another feature or witness.

### Phase 3: find recurrence families

Take the union of:

- high-isolation lines;
- HDBSCAN noise;
- lines far from body regimes;
- optionally, lines near page extremes.

Now cluster those candidates across pages using a different feature view:

```text
normalized bbox
font/style regime
digit-normalized text signature
lexical similarity
page parity
```

HDBSCAN or hierarchical clustering with a composite/precomputed distance can discover families such as:

- the same running title on every page;
- alternating author/title headers on odd/even pages;
- page numbers with varying digits;
- repeated footer notices.

### Phase 4: classify the discovered family

The decision unit is now the recurrence family, not the individual line. Family-level features include:

```text
page coverage
longest consecutive run
odd/even periodicity
mean normalized position
position variance
style entropy
text-template similarity
median isolation score
median distance from body
whitespace separation from body
```

A shallow decision tree or Random Forest can then distinguish:

```text
running_header
running_footer
page_number
section_heading
repeated_content
unknown
```

Conceptually:

```text
line instances
    ├── HDBSCAN: ordinary flow/style regimes
    ├── Isolation Forest: deviation score
    ↓
candidate non-body lines
    ↓
cross-page HDBSCAN: recurrence families
    ↓
family-level tree: semantic role
```

The decisive header evidence is therefore not `high isolation`. It is approximately:

```text
recurrent family
+ low positional variance
+ top-page location
+ separation from body flow
+ compatible page coverage/periodicity
```

This handles several hard cases naturally:

- A chapter heading is anomalous and near the top, but usually lacks recurrence.
- Page numbers recur but have a recognizable normalized numeric template.
- Alternating running heads become two periodic families.
- A first-page omission does not destroy a density-based recurrence family.
- A repeated table heading inside the body lacks extremal position and body separation.

## The broader methodological distinction

For each subproblem, you can now ask three separate questions:

1. **Grouping:** Which observations belong together?
   - HDBSCAN, DBSCAN, hierarchical clustering, graph communities.

2. **Regime/anomaly:** Which configurations are ordinary or unusual?
   - HDBSCAN membership/noise, Isolation Forest, LOF.

3. **Role:** What does the discovered group mean?
   - family-level trees, deterministic invariants, or residual reasoning.

That separation is much less nebulous than “clustering proposes; reasoning decides.” It tells you exactly where each method enters and what object it consumes.

The next design artifact should therefore be a **clusterability matrix**, not a general architecture charter. Each row should define one problem like running headers, with:

```text
target entity
population and scope
atomic features
engineered features
clustering views
candidate-generation rule
family-level features
semantic classifier
known confounders
evaluation and ablations
```

Running headers are a good first complete row because they exercise all four evidence scales: atomic typography, local flow, document-relative anomaly, and cross-page recurrence.

> No the idea i had for isolation forest was to actually apply it to cluster labeled data in order to refine discovery along some given set of axes

Right—that is materially different. I treated Isolation Forest as an upstream anomaly filter. You mean it as a **cluster-conditioned refinement operator**:

> First discover coarse regimes with HDBSCAN. Then, within each labeled cluster, use Isolation Forest over a deliberately chosen secondary feature space to expose hidden heterogeneity along particular axes.

So the pattern is:

```text
primary feature view
    ↓
HDBSCAN
    ↓
coarse labeled clusters
    ↓
Isolation Forest within each cluster
using selected refinement axes
    ↓
cluster core + axis-specific outliers
    ↓
recluster coherent outliers / emit competing subdivision
```

The cluster label should normally define the population on which the forest is trained—not be inserted as an ordinal numeric feature.

## Why this is powerful

A cluster may be coherent in the feature space that created it but heterogeneous in another view.

For example, clustering lines on typography might produce:

```text
cluster 4:
  10 pt Times Roman
  normal weight
  similar line height
```

That cluster could contain:

- body paragraphs;
- running headers using the body font;
- footnotes;
- table cells;
- figure-source notes.

HDBSCAN has correctly discovered a typographic regime. It has not failed. You then ask whether that regime contains exceptional configurations along another set of axes:

```text
normalized page position
distance from body flow
local whitespace
line width
cross-page recurrence
neighbor configuration
```

A cluster-conditioned Isolation Forest can identify the lines that are unusual **relative to other members of the same typographic regime**. That is much more meaningful than asking whether they are globally unusual relative to every line in the document.

## Running-header example

### Primary discovery

Cluster line instances using a typography/shape feature view:

```text
font metrics
font-size ratio
weight and italic state
rendering mode
line height
character density
capitalization profile
```

Suppose HDBSCAN places ordinary body lines and same-font running headers together.

### Conditional refinement

For that particular cluster, train an Isolation Forest over structural axes:

```text
y / page height
x / page width
normalized line width
whitespace above and below
distance from the local body envelope
page-frequency of normalized text
position variance of matching text
odd/even-page recurrence
```

The forest asks:

> Which members are structurally exceptional among lines that are typographically alike?

Running headers may emerge as a small outlying subset because they combine extremal y-position, unusual separation from body flow, and cross-page recurrence.

### Coherence test

The isolated points are not immediately labeled headers. Recluster them in the refinement/recurrence space:

```text
axis outliers
    ↓
secondary HDBSCAN
    ├── stable repeated top-page family → header hypothesis
    ├── stable repeated bottom family → footer hypothesis
    ├── numeric alternating family → page-number hypothesis
    └── incoherent singleton points → residual noise
```

That final reclustering distinguishes **hidden substructure** from arbitrary anomalies.

## The resulting primitive

This gives you a reusable discovery operation:

```text
Refine(
    cluster_labels,
    conditioning_scope,
    refinement_features,
    anomaly_model,
    coherence_test
)
```

Its output is richer than revised labels:

```text
cluster core
candidate subclusters
axis-outlier memberships
anomaly margins
features responsible for separation
stability across runs
unresolved residuals
```

You could use the same operation repeatedly with different refinement views:

| Coarse cluster           | Refinement axes                    | Possible discovery                         |
| ------------------------ | ---------------------------------- | ------------------------------------------ |
| typography regime        | page position + recurrence         | headers, footers, furniture                |
| body-like lines          | indentation + prefix geometry      | lists and quotations                       |
| small-font regime        | page zone + neighbor relations     | footnotes versus captions                  |
| math-font regime         | baseline delta + size ratio        | scripts, limits, detached symbols          |
| aligned text regime      | x-bands + repeated baselines       | borderless table columns                   |
| path/glyph configuration | containment + overlap + recurrence | decorations, radicals, fraction structures |

## Important methodological consequence

Your problem breakdown may therefore be organized around **successive views of the same labeled population**, rather than a fixed sequence of semantic detectors.

For each discovery problem, specify:

1. **Primary population** — glyphs, lines, blocks, configurations.
2. **Primary clustering view** — what kind of similarity creates the coarse regime?
3. **Refinement axes** — along which orthogonal evidence could that regime hide substructure?
4. **Conditional anomaly population** — entire cluster, cluster/page intersection, or local neighborhood?
5. **Coherence test** — do the isolated members form a stable secondary cluster?
6. **Interpretation candidates** — what roles could explain the subdivision?

The key is that Isolation Forest does not merely say “this looks weird.” It says:

> Within a population already known to be alike in one respect, these members separate unusually quickly when examined along another specified set of axes.

That is a much sharper discovery mechanism—and it makes the selection of primary versus refinement feature spaces central to your actual breakdown of the PDF problem.

> i thought isolation forest was unsupervised?

Yes—Isolation Forest is unsupervised. My phrase “cluster-conditioned” did not mean using cluster labels as prediction targets.

The intended operation is:

```text
HDBSCAN(X_primary) → cluster labels

For each cluster c:
    Xc = points assigned to c
    IsolationForest.fit(X_refinement for Xc)
    → anomaly scores within c
```

The HDBSCAN label only selects the population used to fit each forest. Isolation Forest receives no target variable and does not learn “header” labels. It learns what is ordinary within that cluster along the refinement axes.

For example:

```text
HDBSCAN typography cluster:
    all 10 pt Times Roman lines

Isolation Forest fitted within that cluster on:
    normalized y-position
    whitespace separation
    recurrence
    line width
    distance from body flow
```

It may identify a small subset as unusual along those axes. Those points might form running headers—but that interpretation comes later through recurrence clustering, deterministic evidence, or another classifier.

Three related designs should be kept distinct:

1. **Cluster-conditioned Isolation Forest — unsupervised**

   Use HDBSCAN labels to partition the data, then fit an independent Isolation Forest within each partition.

2. **Cluster label included as an Isolation Forest feature — still unsupervised**

   The label becomes just another input value. This is usually less attractive because numeric cluster IDs have no meaningful ordering, and one-hot encoding mostly reproduces the partitioning less cleanly.

3. **Random Forest trained to predict HDBSCAN labels — supervised with pseudo-labels**

   Here the cluster labels are targets. This can approximate cluster boundaries, identify important features, or generalize assignments, but it is no longer Isolation Forest.

So your idea is indeed unsupervised if it is:

> HDBSCAN discovers coarse regimes; Isolation Forest examines each regime for hidden deviations along a secondary feature view.

The complete refinement operation is still something you construct around Isolation Forest:

```text
coarse cluster
→ unsupervised anomaly scores
→ candidate exceptional subset
→ test whether that subset forms coherent secondary clusters
→ retain subdivision or leave as residual
```

Isolation Forest supplies the conditional anomaly ranking. It does not itself assign the refined semantic classes.

> I think I was thinking isolation forest would help segment different types of outliers within a given cluster, which doesn't resolve their identity, but might prove useful as a clue for a reasoning agent to resolve. Take this idea across clusters, and even different clusterings, and I'm thinking about some kind of consensus or reconciliation potentially

Yes—this is substantially more precise. You’re describing **multi-view, cluster-conditioned anomaly decomposition**, followed by reconciliation.

One technical qualification: vanilla Isolation Forest produces an anomaly score, not outlier types. The segmentation appears when you retain more information than the scalar score and cluster the anomalous members by how they differ.

## Within one cluster

Suppose HDBSCAN discovers a coarse cluster \(C\). For every member, calculate:

- Isolation Forest anomaly score;
- robust residuals from the cluster center or distribution;
- per-axis anomaly contributions;
- optionally, forest path/leaf signatures.

For a typography cluster, an outlier signature might look like:

```text
position:       strongly exceptional
recurrence:     strongly exceptional
font size:      ordinary
line width:     moderately exceptional
body distance:  strongly exceptional
capitalization: ordinary
```

Another outlier in the same typography cluster might be:

```text
position:       ordinary
recurrence:     ordinary
font size:      ordinary
line width:     strongly exceptional
body distance:  moderately exceptional
capitalization: strongly exceptional
```

Both are anomalous members of the same coarse cluster, but for different reasons. Cluster those signatures and you obtain **outlier modes**:

```text
coarse cluster
    ├── core
    ├── outlier mode A: positional + recurrent
    ├── outlier mode B: width + capitalization
    └── isolated residuals with no coherent mode
```

The first mode might later support a running-header interpretation. The second might support a short heading or label interpretation. Isolation Forest has not identified either role; it has exposed structured heterogeneity.

## Useful representations for outlier segmentation

The simplest representation is often best:

```text
outlier vector =
    robust standardized residuals from its parent cluster
    + isolation score
    + membership probability
```

For example:

```text
[
  residual_y_position,
  residual_x_position,
  residual_font_size,
  residual_line_width,
  residual_whitespace_above,
  residual_recurrence,
  residual_body_distance,
  isolation_score,
  hdbscan_membership_probability
]
```

You can then HDBSCAN those outlier vectors.

More sophisticated alternatives include:

- **Per-feature Isolation Forest contributions:** which axes caused short isolation paths?
- **Forest leaf/path embeddings:** points with similar isolation behavior across trees receive similar representations.
- **Multiple typed forests:** one forest for spatial features, one for recurrence, one for typography, one for local flow. Their scores form an interpretable anomaly signature.

I particularly like the typed-forest version for your use case:

```text
anomaly signature =
[
    spatial_anomaly,
    typographic_anomaly,
    recurrence_anomaly,
    flow_anomaly,
    path_glyph_anomaly
]
```

That avoids asking one forest to make sense of every heterogeneous feature at once.

## Across different clusterings

Now repeat this over several deliberately different views of the same line population:

```text
Typography clustering
Geometry/layout clustering
Cross-page recurrence clustering
Local-flow clustering
Lexical/configuration clustering
```

Each object accumulates a witness record:

```text
line 173:
  typography:
    cluster = T4
    membership = 0.94
    spatial anomaly within T4 = 0.91

  geometry:
    cluster = G_top_margin
    membership = 0.88
    typographic anomaly within G_top_margin = 0.22

  recurrence:
    cluster = R_odd_page_title
    membership = 0.97

  flow:
    cluster = noise
    separation from body = high
```

That is much more informative than any single predicted label.

## Header example

Consider three kinds of top-page lines:

### Running header

```text
Typography view:
  ordinary member of a body-like font cluster
  strong positional/flow outlier within that cluster

Geometry view:
  stable top-page cluster

Recurrence view:
  strong repeated or odd/even family

Flow view:
  consistently detached from body flow
```

### Chapter heading

```text
Typography view:
  distinct large-font cluster

Geometry view:
  top-page or upper-body cluster

Recurrence view:
  no stable repeated family

Flow view:
  connects to the following body section
```

### Accidental top-page body line

```text
Typography view:
  body cluster

Geometry view:
  upper-page cluster

Recurrence view:
  no repeated family

Flow view:
  ordinary continuation of body flow
```

None of those views alone identifies the semantic role. Their cross-view signatures make the alternatives structurally distinguishable.

## Consensus should be evidence accumulation, not majority voting

A useful reconciliation structure is a co-association/evidence graph.

- Nodes are lines, glyph configurations, or blocks.
- Positive edges record that two objects repeatedly cluster together.
- Edge weights accumulate across views and scales.
- Negative or conflict edges record strong separation.
- Outlier-mode hyperedges record that a subset is exceptional in the same way relative to a parent regime.

Conceptually:

```text
association(i,j) =
    typographic co-membership
  + geometric co-membership
  + recurrence co-membership
  + shared anomaly mode
  + relational witnesses
  - strong separation evidence
```

Stable consensus communities become accepted structural candidates. Strongly incompatible partitions remain competing hypotheses rather than being averaged away.

This yields three outcomes:

1. **Consensus core**

   Several independent views support the same grouping.

2. **Complementary explanation**

   Different views reveal different aspects of one configuration: typography says “ordinary,” spatial refinement says “exceptional,” recurrence says “stable family.”

3. **Genuine conflict**

   Two strong views imply incompatible groupings. This is what the reasoning agent should receive.

## Reasoning-agent packet

The agent should not receive “anomaly score 0.83” in isolation. It should receive a translated evidence packet:

```text
Candidate set: lines L17, L93, L168, L241

Agreements:
- same normalized top-page position on 27/30 pages
- two alternating textual templates on odd/even pages
- same typographic regime as body text
- consistently outside the dominant baseline-flow graph

Conditional anomalies:
- spatial anomaly within typography cluster: high
- recurrence anomaly within typography cluster: high
- typographic anomaly within top-margin cluster: low

Competing interpretations:
1. alternating running header
2. repeated section label
3. body text accidentally placed in top margin

Counterevidence:
- absent on chapter-opening pages
- no continuation relation to following body blocks
```

That is excellent material for a reasoning model because the model is resolving identity from structured, contrasting evidence—not being asked to rediscover the geometry.

So the full idea is:

```text
multiple primary clusterings
    ↓
cluster-conditioned Isolation Forests
    ↓
outlier signatures
    ↓
outlier-mode clustering
    ↓
cross-view evidence graph
    ↓
consensus structures + explicit conflicts
    ↓
reasoning-agent reconciliation
```

That feels much closer to the distinctive mechanism you have in mind. It is neither OpenDataLoader’s ordered heuristic cascade nor MinerU’s learned page segmentation. It is an ensemble of unsupervised structural views that turns agreement and disagreement into explicit evidence.

> But I still want to draw quite a bit from opendataloader and minerU. The way they gather evidence, parse structure deterministically, assemble IRs, in order to help me figure out how to set up my clustering-based discovery. Like I eventually want to build something like OpenDataLoader's JSON. Like before getting to a markdown output, I need to build my JSONL IR that contains all of the content in a sequence of chunks, with a target schema identical to what I will build with the new latex converter in order to be able to carefully measure fidelity. Im thinking of the overarching challenge as solving a sort of inverse manuscript recovery, where all pdfs can be viewed as a surjection onto some canonical manuscript format or envelope. This means I need to be able to linearize different layouts by some kind of reading order convention, maybe being opinionated at times, as well as map section titles as headers, body text in between them, extract images and caption text and link them. I also think that its limiting to just break things down page by page like i did before. I think I want to start from whole-document clustering and then do hierarchical analysis and persistent homology from there, because within a given document, the roles of fonts and style cues and typography and what not should generally be internally consistent

Yes. This makes the center of the system much clearer:

> The target manuscript IR defines the inverse problem. PdfPig, clustering, deterministic assembly, and reasoning models are different mechanisms for recovering that IR from incomplete rendered evidence.

Clustering is not the architecture by itself. It is your main discovery mechanism inside a larger inverse-recovery pipeline.

## The inverse-manuscript framing

More precisely, suppose the forward process is:

```text
manuscript structure
+ styling
+ layout policy
+ rendering implementation
→ PDF
```

Many different manuscript/style/layout combinations can produce observationally equivalent PDFs. Rendering therefore destroys information; the inverse is set-valued.

You are not trying to recover the exact original source. You are defining a canonical selection:

```text
PDF
→ best-supported canonical manuscript
```

The objective is something like:

```text
recover(pdf) =
    canonical manuscript candidate
    maximizing:
        compatibility with PDF evidence
      + document-internal consistency
      + canonicalization policy
```

This is where being opinionated is unavoidable and legitimate. Multi-column layouts, floating figures, sidebars, footnotes, and repeated furniture do not always imply one uniquely correct linear order. The canonical manuscript profile defines which representative you select from the valid equivalence class.

So reading order is not merely a late layout heuristic. It is part of the definition of your inverse.

## You probably need three distinct IRs

Trying to make one JSONL format serve every stage would blur important distinctions.

### 1. PDF evidence IR

Lossless or near-lossless, non-linear, PdfPig-specific:

```text
glyphs
text-showing operations
baselines
font and graphics state
paths
XObjects and images
page coordinates
bookmarks
annotations
structure tags where available
source relationships
```

This is analogous to OpenDataLoader’s veraPDF object substrate. It preserves everything discovery may need.

### 2. Discovery/hypothesis IR

Still non-linear and potentially contradictory:

```text
clusters and memberships
typography regimes
page-template families
candidate blocks
candidate headings
candidate figures and captions
reading-order constraints
outlier modes
competing groupings
confidence and disagreement
provenance back to evidence atoms
```

This is where your multi-view clustering, Isolation Forest refinements, persistent structures, deterministic witnesses, and reasoning-agent decisions live.

MinerU’s `middle.json` points in this direction, although it generally contains the selected interpretation rather than preserving a full hypothesis ensemble.

### 3. Canonical manuscript JSONL

Linear, origin-neutral, and shared with the LaTeX converter:

```text
heading
prose
list item
math inline/display
figure
caption
table
quotation
footnote
...
```

This is the measurement contract and the source of Markdown.

```text
PDF evidence graph
    → discovery/hypothesis graph
        → canonical manuscript.jsonl
            → Markdown

LaTeX AST
    → canonical manuscript.jsonl
        → Markdown
```

The PDF and LaTeX evidence representations do not need to match. Their accepted manuscript chunk streams do.

## Whole-document discovery should precede page interpretation

I agree strongly with moving away from independently parsing each page.

A better principle is:

> Establish document-global regimes first; interpret page-local structures conditionally within those regimes.

Pages remain useful coordinate systems, but they are not independent semantic documents.

A plausible discovery order is:

### 1. Document inventory

Collect every atomic signal and calculate document-level robust statistics:

- font and metric inventory;
- glyph-size and line-height distributions;
- page dimensions and rotations;
- color/rendering regimes;
- path and image inventories;
- normalized page-position distributions;
- baseline and spacing distributions.

### 2. Page-template regimes

Cluster page-level summaries to discover:

- ordinary body pages;
- chapter-opening pages;
- front matter;
- appendices;
- landscape/table inserts;
- bibliography/index layouts;
- scanned or image-heavy pages.

This guards against an overly strong assumption that the entire document has one homogeneous typographic system. Internal consistency is usually strong, but it may be piecewise consistent.

### 3. Document-global typography regimes

Cluster glyph runs or lines across the whole document using typography/shape views:

- font metrics and identity;
- size ratios;
- weight and slant;
- rendering mode and color;
- capitalization and character composition;
- line height and density.

These are initially unnamed configurations—not “body,” “heading,” or “caption.”

Cluster-conditioned anomaly decomposition can then expose hidden subtypes along spatial, recurrence, or flow axes.

### 4. Cross-page recurrence regimes

Cluster line/block configurations by:

- normalized position;
- text-template similarity;
- typography membership;
- page coverage;
- positional variance;
- odd/even periodicity;
- neighboring whitespace.

This provides evidence for headers, footers, page numbers, repeated section labels, and recurring page structures.

### 5. Page-local geometric hierarchy

Now analyze individual pages using the global discoveries as priors:

```text
glyphs
→ baseline groups
→ lines
→ blocks
→ columns/regions
→ local reading-order constraints
```

A ten-point Times line is no longer interpreted in isolation. It arrives with evidence that it belongs to document typography cluster `T4`, which is dominant in body-flow configurations but also has a recurrent top-margin outlier mode.

### 6. Document-level semantic and relational assembly

Use the resulting configurations to infer:

- section hierarchy;
- paragraph continuation across pages;
- lists;
- figure–caption relationships;
- table continuation;
- footnotes;
- references;
- page furniture;
- candidate reading order.

This is where local page structures become one manuscript.

## Reading order should be a constrained graph

I would avoid making a single XY-Cut-like algorithm responsible for canonical linearization.

Instead, construct a partial-order graph from multiple witnesses:

```text
A precedes B
A contains B
B continues A
C is caption_of Figure F
D belongs_to Section S
E is page furniture and excluded from manuscript flow
```

Evidence can come from:

- column and region partitions;
- baseline flow;
- vertical and horizontal separation;
- document typography regimes;
- section transitions;
- cross-page continuation;
- figure/caption geometry;
- bookmarks or structure tags;
- alternative visual/model interpretations.

Then produce a total order using a versioned canonicalization profile:

```text
manuscript-order/0.1:
- section headings precede their body
- columns are read in declared column order
- captions immediately follow their figure
- footnotes follow the containing page’s body
- running furniture is excluded
- floating figures are placed according to a specified convention
```

If the constraint graph has a cycle or two similarly supported linearizations, preserve that conflict in the hypothesis IR. A deterministic policy or reasoning model can select the canonical output while retaining why the choice was necessary.

## Figures and captions illustrate the full method

A figure need not be one image XObject. It may be:

- one raster image;
- several image tiles;
- a collection of vector paths;
- paths plus text labels;
- a composite group.

Your discovery layer can propose figure regions from image/path/glyph relations. Caption candidates come from nearby line configurations, typography regimes, numbering recurrence, lexical forms, and alignment.

The accepted manuscript stream can represent them separately:

```json
{"id":"fig:7","ordinal":42,"kind":"figure","asset_id":"asset:7"}
{"id":"cap:7","ordinal":43,"kind":"caption","text":"Figure 3. ...","relations":{"caption_of":"fig:7"}}
```

The same schema can be emitted from LaTeX `figure` and `caption` nodes, making figure/caption recovery directly measurable.

## What to borrow from each project

| Source         | Worth borrowing                                                                                                                                                                     |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| OpenDataLoader | Exact born-PDF evidence, font/path/image provenance, deterministic typed assembly, tagged-PDF evidence, cross-page passes, common JSON serialization                                |
| MinerU         | Explicit developmental IR, multiple evidence channels, specialized table/formula/OCR analysis, native-text restoration, document postprocessing                                     |
| Your approach  | Whole-document regime discovery, multi-view clustering, cluster-conditioned anomaly modes, persistence/stability, preserved competing hypotheses, paired-LaTeX fidelity measurement |

The important departures are:

- Do not let OpenDataLoader’s fixed ordered cascade become the primary discovery mechanism.
- Do not let MinerU’s page/model result become the unquestioned semantic owner.
- Do not let page boundaries define the highest level of analysis.
- Do not collapse disagreement before it has been measured.

## Where persistent homology fits

HDBSCAN already constructs a density hierarchy and scores cluster stability, so it gives you something closely related to zero-dimensional persistence.

Formal persistent-homology machinery becomes useful when you want to ask whether structures survive across:

- neighborhood radii;
- distance thresholds;
- feature subsets;
- page/regime scopes;
- graph-construction parameters.

For typography and recurrence, \(H_0\)-style component persistence is likely the first useful tool. Higher-dimensional features may eventually help with grid/path complexes, but I would not make them foundational until there is a concrete topological signal to recover.

The operational principle is:

> A candidate structure earns trust when it persists across reasonable perturbations of scale, view, and clustering parameters.

## The target JSONL is therefore the first real specification

A shared chunk should contain origin-neutral manuscript semantics:

```json
{
  "id": "chunk:0042",
  "ordinal": 42,
  "kind": "heading",
  "depth": 2,
  "text": "Experimental Results",
  "canonical": "Experimental Results",
  "status": "accepted",
  "relations": {
    "parent": "section:0011",
    "prev": "chunk:0041",
    "next": "chunk:0043"
  },
  "source": {
    "origin": "pdf",
    "page": 7,
    "atom_ids": ["glyph:8891", "glyph:8892"],
    "bbox": [72, 611, 283, 635]
  }
}
```

The LaTeX converter emits the same fields, with a LaTeX range instead of PDF atoms and geometry. The semantic envelope is identical; provenance is source-specific.

That yields a much sharper overall breakdown:

```text
1. Define the canonical manuscript envelope.
2. Capture source-native evidence without premature semantics.
3. Discover document-global regimes and persistent configurations.
4. Generate local and cross-page structural hypotheses.
5. Reconcile multiple views into semantic relations and order constraints.
6. Select an opinionated canonical linearization.
7. Emit the shared manuscript JSONL.
8. Align PDF-derived and LaTeX-derived chunk streams to measure fidelity.
9. Render Markdown as a pure projection.
```

In that formulation, OpenDataLoader and MinerU are not competing blueprints. They are rich catalogs of evidence sources, deterministic processors, specialist recognizers, IR decisions, and failure modes that you can selectively incorporate into an explicitly whole-document inverse-recovery system.

> yea there are stages of IR in my current mental model, the ones you are talking about are preliminary to the target IR, which would essentially be one step away from rendering a markdown based on it. The reason for targeting this "final IR" is precisely because i want to be able to measure similarity against the same data structure generated by corresponding latex extraction on the same source material, which is the same inverse problem, but much more tractable and well defined, not even really needing a reasoning model. Getting to this point would be the crux of my new gauntlet development loop where I iterate on the pipeline and measure precisely the differences. Then exporting final IR to markdown is an implementation detail

Exactly. Then the target IR is not merely the last internal representation—it is the system’s **semantic ABI and measurement boundary**.

The compiler analogy is unusually clean:

```text
PDF frontend
  PdfPig evidence
  → discovery/hypothesis IRs
  → inferred canonical manuscript IR
                         ↘
                           Markdown renderer

LaTeX frontend
  LaTeX AST
  → deterministic normalization
  → reference canonical manuscript IR
                         ↗
```

The PDF frontend is an ill-posed inverse problem. The LaTeX frontend performs the same canonical projection from a source that retains much more structure. Both must ultimately satisfy the same contract.

Markdown is just one backend.

## What “final IR” means

The final IR should contain every semantic decision needed for rendering. The Markdown renderer should not decide:

- whether something is a heading or paragraph;
- heading depth;
- reading order;
- paragraph boundaries;
- whether text is a list item;
- whether text is a caption;
- which figure a caption belongs to;
- whether math is inline or display;
- how table cells relate;
- whether content is page furniture.

If the renderer must infer any of those, the IR is not final enough.

The renderer should mainly perform:

```text
IR node → Markdown syntax
escaping
asset path resolution
chosen rendering profile
```

## Properties of the shared contract

The canonical manuscript IR needs to be:

1. **Source-neutral**

   PDF and LaTeX provenance differ, but `kind`, content, hierarchy, relations, and order mean the same thing.

2. **Canonically ordered**

   The chunk sequence represents the selected manuscript reading convention, not PDF paint order or LaTeX source-file order.

3. **Structurally complete**

   Hierarchy and non-sequential relationships must be explicit even though JSONL supplies a linear serialization.

4. **Renderer-complete**

   No semantic inference remains for Markdown generation.

5. **Alignable**

   Chunk boundaries and canonicalization rules are precise enough to compare the two streams.

6. **Versioned**

   A change in paragraph, heading, math, figure, or ordering policy changes the IR contract version.

7. **Traceable**

   Every PDF-derived chunk can be traced backward through hypotheses to glyphs, paths, images, and pages. Every LaTeX-derived chunk can be traced to source ranges or AST nodes.

The top-level semantic payload should be identical. Provenance can be a tagged union:

```json
"source": {
  "origin": "pdf",
  "page": 7,
  "atom_ids": ["glyph:8891", "glyph:8892"],
  "bbox": [72, 611, 283, 635]
}
```

versus:

```json
"source": {
  "origin": "latex",
  "file": "results.tex",
  "range": [1842, 1869],
  "ast_ids": ["node:293"]
}
```

Those source fields support diagnosis but should normally be excluded from semantic fidelity scoring.

## The real gauntlet loop

The development loop becomes:

```text
paired LaTeX source + rendered PDF
        │
        ├── LaTeX canonicalizer → reference manuscript.jsonl
        │
        └── PDF recovery pipeline → candidate manuscript.jsonl
                                      + evidence/hypothesis ledger
        │
        └── structural alignment and fidelity report
```

Then:

1. Locate the first meaningful divergence.
2. Trace the candidate chunk back through its discovery decisions.
3. Modify features, clustering, reconciliation, or deterministic assembly.
4. Regenerate the candidate IR.
5. Measure which discrepancies were fixed and which regressions appeared.

That is much stronger than comparing Markdown. Markdown prematurely collapses structure and introduces irrelevant differences involving escaping, whitespace, image syntax, and rendering preferences.

## Chunk boundaries are part of the specification

The comparison is only meaningful if both frontends target the same semantic segmentation rules.

For example:

| Construct       | Canonical unit                                                                 |
| --------------- | ------------------------------------------------------------------------------ |
| Heading         | one heading chunk                                                              |
| Paragraph       | one prose chunk, possibly containing typed spans                               |
| List            | list container plus ordered list-item chunks, or explicitly related flat items |
| Display formula | one math-display chunk                                                         |
| Inline formula  | typed span within its containing prose/list chunk                              |
| Figure          | figure chunk referencing an asset                                              |
| Caption         | independent caption chunk linked to the figure                                 |
| Table           | table chunk with explicit row/cell structure                                   |
| Footnote        | footnote chunk related to its anchor                                           |
| Page furniture  | excluded from manuscript stream but retained in evidence/discard ledger        |

Even with a precise contract, the PDF side may split one reference paragraph into two or merge two paragraphs. Therefore the aligner must support:

```text
1 ↔ 1
1 ↔ many
many ↔ 1
missing ↔ 1
reordered groups
```

It should not assume matching ordinals imply matching chunks.

## Fidelity should remain multidimensional

A single similarity number would conceal too much. The gauntlet should report at least:

- **coverage fidelity:** was every reference unit recovered?
- **chunk-boundary fidelity:** were units split or merged correctly?
- **order fidelity:** is the canonical sequence correct?
- **kind fidelity:** heading versus paragraph versus caption, etc.?
- **hierarchy fidelity:** heading depth, parent section, nesting?
- **text fidelity:** characters, words, whitespace, dehyphenation?
- **math fidelity:** canonical AST or semantic equivalence?
- **asset fidelity:** were figures/images recovered?
- **relation fidelity:** caption-of, footnote anchor, continuation, parent?
- **false-confidence rate:** which incorrect structures were emitted as settled?
- **ambiguity recall:** did the PDF pipeline preserve uncertainty where the evidence was genuinely inadequate?

You can later derive an aggregate score, but the dimensional report is what makes the gauntlet actionable.

## This also disciplines the clustering work

Clustering quality should not be judged mainly by silhouette scores or whether clusters “look sensible.” Each discovery mechanism should have an explicit downstream jurisdiction in the final IR.

| Discovery mechanism          | Final-IR consequences                           |
| ---------------------------- | ----------------------------------------------- |
| Typography regimes           | heading/body/caption candidates, emphasis spans |
| Cross-page recurrence        | removal of headers, footers, and page numbers   |
| Baseline/flow clustering     | line and paragraph boundaries                   |
| Layout partitions            | reading-order constraints                       |
| Heading configurations       | `kind`, `depth`, and section parentage          |
| List configurations          | item boundaries and nesting                     |
| Image/path grouping          | figure assets and regions                       |
| Caption discovery            | caption chunks and `caption_of` relations       |
| Math configuration discovery | inline/display math spans and AST inputs        |
| Table discovery              | rows, columns, cells, and continuation          |

An experiment earns its place when it reduces specific final-IR discrepancies on the paired gauntlet without increasing false confidence elsewhere.

That gives you unusually strong credit assignment. If a recurrence clustering change improves furniture exclusion but damages section headings, the exact affected chunks and fields are visible.

## The LaTeX path is more than an oracle file generator

It defines and continuously tests the canonicalization contract itself.

LaTeX still contains presentational ambiguity—custom macros, manual spacing, class-specific behavior, source-file indirection—but it retains explicit sectioning, environments, math structure, lists, figures, captions, labels, and references. Resolving those into your manuscript envelope is largely deterministic.

That lets you stabilize:

```text
canonical chunk kinds
boundary rules
hierarchy rules
normalization
math representation
figure/caption representation
linearization policy
```

before asking the PDF pipeline to infer them.

So the development order becomes very sharp:

1. Define and version the final manuscript IR.
2. Make LaTeX emit a trustworthy reference stream.
3. Build the aligner and multidimensional scorer.
4. Make the PDF pipeline emit any schema-valid candidate stream.
5. Use the gauntlet discrepancies to drive discovery development.
6. Treat Markdown export as a deliberately boring pure projection.

That final IR is therefore the crux in exactly the sense you mean: it is simultaneously the recovery target, the contract shared by both frontends, the unit of fidelity measurement, and the boundary after which the inverse problem is finished.

> I was thinking a slightly more coarse contrasting of headers and intervening spans of contiguous body text, accounting for changes of page and irregularities or interruptions by figures. this makes the alignment easier because I can get this more reliably in PDF and its easy in latex

Yes—that is a much better target granularity. Taking “header” here to mean a section heading, you’re proposing an **anchor-and-interval representation**:

```text
section heading
→ contiguous body span
→ figure/caption interruption
→ contiguous body span
→ next section heading
```

Page boundaries do not define manuscript chunks. They remain provenance boundaries inside a body span.

## Coarse anchors, fine payload

The top-level units can be deliberately coarse:

```text
heading
body_span
figure
body_span
heading
body_span
...
```

But a `body_span` can still retain paragraph breaks, inline math, citations, emphasis, and other information needed for Markdown. The coarse unit is primarily the unit of alignment.

That avoids making paragraph segmentation accuracy a prerequisite for comparing the two frontends.

```json
{
  "id": "heading:methods",
  "ordinal": 12,
  "kind": "heading",
  "level": 2,
  "text": "Methods",
  "section_id": "section:methods"
}
```

```json
{
  "id": "body:methods:0",
  "ordinal": 13,
  "kind": "body_span",
  "section_id": "section:methods",
  "content": [
    {
      "kind": "paragraph",
      "text": "We first construct..."
    },
    {
      "kind": "paragraph",
      "text": "The resulting model..."
    }
  ],
  "source_segments": [
    {
      "page": 4,
      "atom_ids": ["glyph:4001", "glyph:4002"],
      "bbox": [72, 91, 521, 694]
    },
    {
      "page": 5,
      "atom_ids": ["glyph:5101", "glyph:5102"],
      "bbox": [72, 531, 521, 704]
    }
  ]
}
```

```json
{
  "id": "figure:methods:1",
  "ordinal": 14,
  "kind": "figure",
  "section_id": "section:methods",
  "asset_id": "asset:figure-3",
  "caption": {
    "text": "Figure 3. Overview of the processing pipeline."
  }
}
```

```json
{
  "id": "body:methods:1",
  "ordinal": 15,
  "kind": "body_span",
  "section_id": "section:methods",
  "content": [
    {
      "kind": "paragraph",
      "text": "After applying the transformation..."
    }
  ]
}
```

The JSONL sequence is coarse and stable, while the nested content remains renderer-complete.

## Why this makes alignment easier

The alignment can be hierarchical.

### First: align section-heading anchors

Use:

- normalized heading text;
- relative order;
- inferred heading level;
- parent section;
- neighboring heading identities.

LaTeX provides these almost directly. PDF discovery only has to recover a comparatively sparse set of strong structural anchors.

### Second: align the intervals between headings

Once heading pairs are matched:

```text
LaTeX body under “Methods”
↕
PDF body recovered under “Methods”
```

The aligner no longer has to solve document-wide correspondence. It compares bounded intervals.

### Third: align interruptions within each interval

Figures can be matched through:

- caption text;
- figure number;
- image similarity or asset identity;
- neighboring textual references;
- position within the section.

The matched figures subdivide a large body interval further:

```text
heading
  body before figure
  figure
  body after figure
next heading
```

This gives you increasingly local comparison regions without depending on fragile page or paragraph boundaries.

## Page changes become provenance, not semantics

A body span can begin on page 3 and continue onto page 4. Its source mapping records that transition, but its canonical identity does not change.

That separates two questions:

```text
What is the manuscript unit?
    body_span:results:0

Where did its evidence appear?
    page 3 lower region
    page 4 upper region
```

Running headers, footers, page numbers, and other furniture can occur between those source segments without entering the canonical span.

This is exactly where whole-document clustering helps: it identifies recurring page-level configurations so they can be excluded while the body flow is stitched across page boundaries.

## Figures require an explicit canonical placement policy

A complication is LaTeX floating. The figure environment’s source position and its rendered PDF position may differ.

Your IR should distinguish:

- **visual placement:** where the figure appeared in the PDF;
- **manuscript anchor:** where the canonical stream inserts it.

For example:

```json
"placement": {
  "pdf_page": 5,
  "visual_after": "source-segment:5:17"
},
"relations": {
  "anchor_after": "body:methods:0",
  "belongs_to": "section:methods"
}
```

The LaTeX path may derive the manuscript anchor from the environment’s source location. The PDF path must infer it from visual position, caption numbering, section membership, and nearby references.

When exact anchoring is uncertain, section membership may still be confidently recoverable. Your scorer can distinguish:

```text
figure recovered correctly
caption recovered correctly
section association correct
precise linear insertion incorrect
```

## This narrows the PDF discovery problem nicely

The initial PDF pipeline no longer needs to solve every semantic distinction before becoming measurable. It needs to recover four major things:

1. **Section-heading anchors**

   Which lines/configurations interrupt body flow and establish section boundaries? What is their hierarchy?

2. **Body-flow continuity**

   Which text configurations form the intervening manuscript flow, including continuation across pages and around furniture?

3. **Non-body interruption objects**

   Figures, captions, tables, and perhaps major display-math objects that interrupt or attach to the flow.

4. **Canonical order**

   How should those anchors, intervals, and interruptions be linearized?

Clustering can be organized around those exact targets:

| Discovery               | Useful whole-document evidence                                              |
| ----------------------- | --------------------------------------------------------------------------- |
| Heading configurations  | typography regimes, isolation modes, recurrence, following-body transitions |
| Body regimes            | dominant typography, leading, alignment, density, baseline-flow graphs      |
| Cross-page continuation | matching body regimes, margin transitions, sentence continuity              |
| Furniture exclusion     | cross-page positional/text recurrence                                       |
| Figure regions          | image/path grouping and exclusion from text flow                            |
| Captions                | typography modes, proximity, numbering, lexical configuration               |
| Heading hierarchy       | font/style partial order, numbering, transition patterns                    |
| Reading order           | layout-template clusters plus body-flow constraints                         |

## A minimal target IR may be enough initially

Version `manuscript-ir/0.1` could restrict its top-level kinds to:

```text
heading
body_span
figure
table
residual_block
```

With:

- captions nested in or explicitly linked to figures/tables;
- paragraphs and inline structures nested inside `body_span`;
- page furniture omitted from the canonical stream;
- source-specific evidence stored as provenance;
- uncertainty retained in a parallel ledger.

Later versions can promote lists, quotations, footnotes, display math, or other structures to top-level chunks if the gauntlet demonstrates that doing so improves useful fidelity measurement.

The central idea is excellent:

> Use sparse, reliably recoverable structural anchors to partition the manuscript into large comparable intervals, then measure finer fidelity inside those intervals.

That should make the PDF–LaTeX alignment much more stable than attempting to align independently inferred page blocks or paragraphs across the complete document.

> a separate part of the challenge is contrastive identification of prose versus math register, including inline math as much as possible and reasoning model support for disambiguating when its not clear, as well as math blocks that intervene in body text. Also I think that because a given section may run across pages, if I don't do clustering on the whole document, then its harder for me to get that sequence of headers and section bodies, with the math register embedded within those contiguous section bodies (which may bleed across pages)

That suggests a much more precise decomposition. There are two largely orthogonal recovery problems:

1. **Manuscript flow:** headings, section boundaries, body continuity, figures, page transitions, and reading order.
2. **Register segmentation:** prose versus inline math versus display math inside that recovered flow.

The canonical sequence becomes:

```text
heading
body_span:
    prose + inline math + prose + inline math ...
math_display
body_span:
    prose + inline math ...
figure/caption
body_span:
    prose ...
next heading
```

A page change does not create an IR boundary. A change of manuscript role does.

## A useful coarse chunk contract

Top-level JSONL records could initially be:

```text
heading
body_span
math_display
figure
table
residual_block
```

Where `body_span` means:

> A maximal contiguous run of body-flow text, possibly crossing pages, whose inline content alternates between prose and math register.

For example:

```json
{
  "id": "body:methods:0",
  "ordinal": 17,
  "kind": "body_span",
  "section_id": "section:methods",
  "spans": [
    {
      "kind": "prose",
      "text": "Let "
    },
    {
      "kind": "math_inline",
      "surface": "x",
      "canonical": "x"
    },
    {
      "kind": "prose",
      "text": " denote the normalized input and let "
    },
    {
      "kind": "math_inline",
      "surface": "f(x)",
      "canonical": "f(x)"
    },
    {
      "kind": "prose",
      "text": " be the resulting transformation."
    }
  ],
  "source_segments": [
    {
      "page": 4,
      "atom_ids": ["glyph:4001", "glyph:4002"],
      "bbox": [72, 84, 520, 704]
    },
    {
      "page": 5,
      "atom_ids": ["glyph:5101", "glyph:5102"],
      "bbox": [72, 601, 520, 706]
    }
  ]
}
```

A display equation interrupts that span:

```json
{
  "id": "math:methods:1",
  "ordinal": 18,
  "kind": "math_display",
  "section_id": "section:methods",
  "surface": "y = W x + b",
  "canonical": "...",
  "equation_number": "3"
}
```

Then another body span resumes:

```json
{
  "id": "body:methods:1",
  "ordinal": 19,
  "kind": "body_span",
  "section_id": "section:methods",
  "spans": [
    {
      "kind": "prose",
      "text": "Equation 3 is then applied to each observation."
    }
  ]
}
```

This is directly renderable, but its hierarchy also makes fidelity measurement tractable:

```text
document
→ sections
→ top-level content events
→ inline register spans
→ text/math content
```

## Why whole-document discovery matters for math register

Inline math is often ambiguous locally:

```text
x
A
I
sin
log
R
10
p
```

Font identity alone cannot resolve these:

- an italic word may still be prose;
- a Roman word may occur inside math through `\\mathrm` or `\\text`;
- the same character can occur in prose and mathematical roles;
- PDF font subsets can obscure the original font family;
- simple inline expressions may contain no operators.

But the rest of the document supplies a powerful contrastive reference.

### Display math can bootstrap a document-local math atlas

High-confidence display equations are easier to discover from:

- centering and whitespace;
- equation numbering;
- strong baseline variation;
- superscript/subscript tiers;
- operators and delimiters;
- two-dimensional glyph arrangements;
- characteristic font/glyph regimes.

Once discovered, they reveal:

- fonts and glyph encodings used in math;
- operator vocabulary;
- variable-like symbols;
- size-tier relationships;
- spacing behavior;
- superscript/subscript configurations;
- Roman-text conventions inside equations.

That becomes document-global evidence for inline segmentation.

For example, an isolated italic `x` in prose is much more plausibly inline math if the same font/glyph configuration occurs repeatedly as a variable in display equations.

## A contrastive register pipeline

### 1. Discover prose regimes

Cluster document-wide line/glyph-run configurations using:

- word-likeness and spacing;
- dominant body fonts;
- baseline stability;
- character-category distributions;
- ordinary sentence punctuation;
- local leading and flow;
- recurrence throughout body regions.

This produces one or more prose regimes rather than one hard-coded body style.

### 2. Discover high-confidence math regimes

Use display blocks and strongly mathematical local configurations:

- operator/delimiter density;
- vertical stacking;
- script-size tiers;
- baseline dispersion;
- fraction/radical/path relationships;
- equation-number geometry;
- math-associated fonts and glyphs.

### 3. Examine body-flow text contrastively

Within body spans, represent local windows using multiple views:

```text
typographic:
    font regime
    size ratio
    italic/weight
    rendering mode

lexical:
    word-likeness
    operator/delimiter classes
    digit/symbol composition
    neighboring tokens

geometric:
    baseline shift
    script attachment
    inter-glyph spacing
    vertical overlap

document-global:
    association with display-math regimes
    recurrence as a mathematical symbol
    association with prose vocabulary

contextual:
    preceding/following words
    delimiter pairing
    sentence position
```

HDBSCAN can discover coarse register configurations. Cluster-conditioned Isolation Forests can expose exceptional segments within prose-like clusters—for example, body-font characters behaving unusually along symbol-recurrence, spacing, or baseline axes.

### 4. Produce competing inline segmentations

For an ambiguous sentence:

```text
Let x denote the input.
```

The discovery layer might produce:

```text
Hypothesis A:
    prose("Let ")
    math_inline("x")
    prose(" denote the input.")

Hypothesis B:
    prose("Let x denote the input.")
```

Evidence for A:

```text
- x uses document math-variable font regime
- same glyph configuration occurs in 31 display equations
- single-letter variables recur after “let”
```

Evidence for B:

```text
- no delimiter or operator
- baseline is identical to surrounding prose
```

That is an appropriate residual for a reasoning model. The model is deciding between explicit register segmentations, not parsing an entire page.

## Section flow should be document-global too

The body sequence can be modeled as a graph whose nodes are candidate lines/blocks and whose edges mean likely continuation:

```text
same document-global body regime
compatible column/template
sentence or word continuation
ordinary leading
cross-page margin transition
not recurring furniture
not a heading boundary
not consumed by a figure/table/math block
```

A section heading starts a new flow partition. Page transitions merely contribute different geometric evidence.

Conceptually:

```text
whole-document atoms
    ↓
global typography and register regimes
    ↓
page-template and furniture discovery
    ↓
document-wide body-flow graph
    ↓
partition flow at heading anchors
    ↓
segment section flow by display math / figures / tables
    ↓
contrastively segment prose and inline math inside body spans
```

This is different from:

```text
parse page 1
parse page 2
parse page 3
then try to stitch the results
```

Instead, pages are local coordinate frames inside a document-level semantic flow.

## The alignment becomes hierarchical

The LaTeX converter can produce the same structure almost deterministically:

1. Align section headings.
2. Compare the top-level event sequence within each section:

   ```text
   body_span, math_display, body_span, figure, body_span
   ```

3. Compare prose content within matched body spans.
4. Compare inline prose/math segmentation.
5. Compare canonical math representations.
6. Compare figure captions and relations.

This localizes errors cleanly:

```text
section recovered correctly
body order correct
display equation correctly placed
text content correct
inline x misclassified as prose
```

Rather than one vague Markdown mismatch, the gauntlet can identify exactly which inverse-recovery layer failed.

So your target is not merely “headers plus text.” It is becoming:

> A section-anchored, page-independent manuscript stream in which body flow is segmented into prose/math register spans and interrupted by typed block objects such as display equations and figures.

Whole-document clustering is essential because both major tasks—recovering cross-page section flow and learning the document’s prose/math contrast—depend on evidence accumulated across the complete document.

> right, so part of the challenge is masking the math register and using a model to adjudicate the ambiguous runs by reviewing the masked regions and surrounding contiguous context e.g. hotspots, somehow

Yes. That suggests a concrete mechanism: **typed, geometry-preserving masks plus hotspot adjudication**.

The mask should not delete math evidence. It should remove math from prose-oriented analysis while preserving its location, extent, ordering, and provenance.

## Three mask states

Every candidate region or run can have:

```text
accepted_math
accepted_prose
ambiguous_register
```

In the working body-flow representation:

```text
"The loss is" <MATH_INLINE:m17> "where" <AMBIGUOUS:r23> "."
```

Each placeholder retains:

```text
glyph IDs
bbox and baseline
page/source segments
candidate boundaries
original surface
cluster memberships
anomaly signatures
```

For display math:

```text
body flow
→ <MATH_DISPLAY:m42>
→ resumed body flow
```

The display placeholder preserves block geometry and acts as a flow interruption.

## Why the masks must preserve geometry

Simply removing mathematical glyphs could cause false reconstruction:

```text
prose before math + prose after math
```

might be joined as though the math never occupied space.

Instead, maintain two simultaneous views:

1. **Logical view**

   Math content is excluded from prose typography, word-spacing, and language-flow clustering.

2. **Geometric view**

   The placeholder still occupies its bbox, participates in reading order, and prevents inappropriate joining.

That lets prose discovery treat math as a typed hole rather than noise.

## How hotspots emerge

A hotspot is a region where the evidence does not support one stable register assignment. Signals could include:

- disagreement among typography, lexical, geometric, and contextual clusterings;
- unstable boundaries across clustering scales;
- low HDBSCAN membership probability;
- cluster-conditioned Isolation Forest modes;
- equal similarity to prose and math regimes;
- math-associated fonts used in prose-like context;
- prose-associated fonts inside operator/delimiter configurations;
- unbalanced delimiters;
- unusual baseline or script attachment;
- disagreement between born text and a visual model;
- a decision that materially changes body-span continuity.

A useful priority score is:

```text
hotspot priority =
    register uncertainty
  × structural impact
  × downstream alignment impact
```

An isolated ambiguous symbol inside a sentence may have high register uncertainty but modest structural impact. A run whose interpretation determines whether two body spans join across a page can receive higher priority.

## The adjudication packet

The reasoning model should receive a compact, deliberately assembled packet—not the entire page without guidance.

### 1. Original visual crop

A high-resolution crop showing:

- the candidate run;
- the full containing line;
- preceding and following lines;
- optional overlays for glyph boxes, baselines, and candidate boundaries.

The candidate should be highlighted, not visually erased.

### 2. Counterfactual masked context

```text
Previous sentence from the contiguous body flow.

"The corresponding value of [HOTSPOT:r23] is then substituted into
the objective."

Following sentence from the contiguous body flow.
```

Because body flow is document-global, this context may cross a page boundary.

### 3. Candidate interpretations

```json
[
  {
    "id": "a",
    "segmentation": [
      { "kind": "prose", "text": "the value of " },
      { "kind": "math_inline", "text": "x_i" },
      { "kind": "prose", "text": " is" }
    ]
  },
  {
    "id": "b",
    "segmentation": [{ "kind": "prose", "text": "the value of x_i is" }]
  }
]
```

### 4. Document-global evidence

Provide selected analogues:

```text
- The glyph/font configuration for x_i occurs in 19 accepted display equations.
- Similar single-letter runs are classified as inline math in 37 body locations.
- The surrounding prose typography belongs to body cluster T2.
- This run is a geometric outlier within T2 along baseline and spacing axes.
```

Also provide counterexamples from high-confidence prose when useful.

### 5. Structural consequences

```text
If A:
- preserve one body span containing an inline-math segment

If B:
- preserve one prose-only body span

If C:
- split the line at the candidate boundary
```

The model can therefore reason about both local register and document structure.

## Separate register adjudication from math recognition

The first model decision should be:

```text
prose
math_inline
math_display
mixed
unresolved
```

and, if needed, the exact boundaries.

Only after the region is accepted as mathematical should a math recognizer or reasoning pass construct its canonical representation.

That avoids conflating:

```text
Is this math?
```

with:

```text
What mathematical structure does it express?
```

A run can be confidently classified as math while its exact LaTeX/AST remains residual.

## Model output should be constrained

For example:

```json
{
  "hotspot_id": "r23",
  "decision": "math_inline",
  "selected_candidate": "a",
  "boundaries": {
    "start_atom": "glyph:7121",
    "end_atom": "glyph:7123"
  },
  "confidence": 0.86,
  "evidence_codes": [
    "display_math_analogue",
    "math_font_regime",
    "sentence_context"
  ],
  "requires_math_parse": true,
  "abstain_reason": null
}
```

The reasoning model should be allowed to abstain. An unresolved mask is better than silently placing ambiguous text in the wrong register.

## The process can be iterative

```text
high-confidence prose/math seeds
    ↓
construct typed masks
    ↓
recover body flow around geometry-preserving placeholders
    ↓
identify high-impact ambiguity hotspots
    ↓
reasoning/VLM adjudication
    ↓
update masks
    ↓
recompute affected local flow and final-IR spans
```

This has an EM-like quality, but it need not rerun the whole document after every decision. Only affected neighborhoods and cross-page flow edges need reconsideration.

## How it lands in the final IR

After adjudication:

```text
heading
body_span:
    prose
    math_inline
    prose
math_display
body_span:
    prose
figure
body_span:
    prose
```

The mask disappears as a working construct. Its accepted semantic node takes its place. The evidence, alternatives, and adjudication remain in the preliminary ledger for gauntlet diagnosis.

This gives the reasoning model a narrow, high-value role:

> Resolve explicit register and boundary ambiguities at hotspots using visual evidence, contiguous manuscript context, and document-global analogues.

That is much more controlled than asking a model to parse pages, while still exploiting reasoning where clustering and deterministic evidence genuinely cannot establish identity.

> well, i might be able to work out the manuscript flow and normalize the reading order into the latent linear document graph by discovery and assembly, and then do the masking based on evidence extracted from geometry. Part of my challenge here is not only posing the intermediate challenges but also the order of operations. i might use similar techniques for differnt problems along the way

Yes. The order of operations is part of the research problem, not just implementation plumbing.

Your proposed ordering resolves an important circularity:

> Recover a provisional manuscript flow from geometry and document-global structure first; then use that flow as context for prose/math masking; then repair only the portions of the flow affected by the register decisions.

The key is that the first flow graph need not know what every interruption means.

## Use opaque interruptions during initial flow recovery

Geometry can often establish:

```text
text continues here
something occupies this region
text resumes here
```

before determining whether the intervening region is:

```text
display math
figure
table
code
decoration
unknown
```

Represent it provisionally:

```text
body-flow node
→ opaque interruption region R17
→ body-flow node
```

The region retains its glyphs, paths, images, bbox, and candidate relations. Later register analysis can replace it with:

```text
math_display
```

or figure analysis can replace it with:

```text
figure + caption
```

This lets geometry support reading order without forcing premature semantic identity.

## A plausible dependency order

| Stage                           | Consumes                 | Produces                                                                       |
| ------------------------------- | ------------------------ | ------------------------------------------------------------------------------ |
| 1. Atomic extraction            | PDF                      | immutable glyph/path/image/font evidence                                       |
| 2. Whole-document discovery     | atomic evidence          | typography regimes, page templates, recurrence families, high-confidence seeds |
| 3. Structural grouping          | atoms + global regimes   | lines, blocks, image/path regions, opaque interruptions                        |
| 4. Provisional flow graph       | structural groups        | page-local precedence and candidate cross-page continuation edges              |
| 5. Anchor and section discovery | flow + global regimes    | headings, furniture exclusion, section partitions, provisional linear skeleton |
| 6. Register masking             | section flow + geometry  | prose spans, inline-math masks, display-math nodes, ambiguity hotspots         |
| 7. Specialized assembly         | typed regions            | math ASTs, figures/captions, tables, lists, other relations                    |
| 8. Reconciliation               | all hypotheses           | resolved partial-order graph plus explicit residual conflicts                  |
| 9. Canonical linearization      | resolved graph + profile | final manuscript JSONL                                                         |

The central sequence is:

```text
whole-document regimes
    ↓
geometry-preserving structural graph
    ↓
provisional manuscript flow
    ↓
register masking with contiguous context
    ↓
local flow repair
    ↓
final canonical sequence
```

## Why flow-first helps register identification

Once you have provisional flow, an ambiguous run no longer gets only page-local context.

It can receive:

```text
preceding manuscript text
candidate run
following manuscript text
```

even when:

- the preceding text is on the previous page;
- a running header intervenes physically;
- the run lies beside a figure;
- the next line begins in another column;
- the section began several pages earlier.

That is much stronger context for a reasoning model than “the line above and the line below in page coordinates.”

The model can review:

```text
visual crop
+ geometric evidence
+ contiguous manuscript context
+ document-global math/prose analogues
```

## Register masking can trigger local flow repair

A later decision may invalidate part of the provisional graph.

For example, a region initially treated as three body lines may be adjudicated as one display equation. That changes:

- paragraph joining;
- before/after spacing;
- body-span boundaries;
- equation-number attachment;
- perhaps column-flow edges.

But it should not require rerunning the entire document.

Track dependencies:

```text
flow edges E41–E48 depend on region R17
```

Then replacing `R17` with `math_display` invalidates and recomputes only those edges and their immediate section neighborhood.

This argues for non-destructive stages:

- atoms remain immutable;
- cluster assignments are annotations;
- hypotheses remain addressable;
- flow edges record their supporting evidence;
- accepted identities replace placeholders only in derived views.

## The repeated techniques become a discovery toolkit

You do not need a unique algorithm for every semantic problem. You need reusable operators instantiated with different populations, scopes, and features.

### Cluster

```text
Cluster(
    entities,
    feature_view,
    scope,
    distance,
    stability_policy
)
```

Examples:

- glyph runs by typography;
- pages by template;
- lines by body-flow configuration;
- blocks by normalized recurrence.

### Refine

```text
Refine(
    parent_cluster,
    secondary_axes,
    isolation_model,
    outlier_coherence_test
)
```

Examples:

- spatial outlier modes within a typography cluster;
- inline-math modes within a body regime;
- caption-like modes within a small-font cluster.

### Assemble

```text
Assemble(
    entities,
    relational_witnesses,
    constraints
)
```

Examples:

- glyphs into lines;
- blocks into body flow;
- scripts into math candidates;
- captions into figure relationships.

### Reconcile

```text
Reconcile(
    competing_partitions,
    anomaly_modes,
    graph_constraints,
    persistence,
    optional_model_decisions
)
```

### Mask

```text
Mask(
    accepted_or_ambiguous_region,
    logical_type,
    geometry_preservation_policy
)
```

The same machinery recurs, but each job has a typed output and an explicit place in the dependency graph.

## Some dependencies are naturally cyclical

Several problems cannot be solved in one strictly forward pass:

```text
body regime helps identify headings
headings define body intervals
cleaner body intervals improve the body regime
```

Similarly:

```text
flow context helps identify inline math
math masking improves prose flow
improved flow changes the context
```

The answer is bounded refinement, not pretending the cycle does not exist.

A reasonable pattern is:

1. Bootstrap from high-margin evidence.
2. Build a provisional graph.
3. Discover/refine exceptions.
4. Recompute affected regions.
5. Stop when assignments and final-IR output stabilize.

The gauntlet can measure convergence and whether additional rounds actually improve fidelity.

## Use the gauntlet to test operation order

Because both pipelines target the same final IR, you can experimentally compare:

```text
global clustering → flow → math masking
global clustering → math seeds → flow
page flow → global reconciliation → math masking
flow → one refinement round
flow → repeated refinement until stable
```

Evaluate each ordering by downstream effects:

- heading and section alignment;
- cross-page body continuity;
- inline register fidelity;
- display-math placement;
- figure interruption placement;
- false-confidence rate;
- runtime and reasoning-model demand.

So the stage ordering does not need to be settled entirely by intuition. Implement the major passes as cached, provenance-preserving transformations, and make ordering/ablation part of the gauntlet.

My strongest current hypothesis would be:

> **Global regimes first, provisional geometry-based flow second, register masking third, localized semantic repair fourth.**

That gives math adjudication the contiguous manuscript context it needs without requiring the initial reading-order system to understand math before it can construct the flow.

> and I think i'm also trying to figure out how different types of features might be informative taken together. For example, to solve the manuscript graph ordering and flow, whatever else i do using geometric cues or typesetting or typography or whatever, page number should definitely be part of the discovery as well as assembly. and im sure there are other things like this where its not as simple as clustering on typography features and examining evidence. Posing the feature vectors and exposing the right axes is crucial

Exactly. “Feature vector” may actually be too narrow a term for what you need.

Some evidence belongs in an entity vector, some belongs on relations between entities, some conditions the population being analyzed, and some should become an assembly constraint. Page number is a perfect example because it participates in all four roles.

## Page identity is several distinct signals

Separate:

```text
physical_page_index
PDF logical page label
printed page-number candidate
normalized position within document
page-template regime
```

They mean different things.

| Signal                       | Possible use                                                 |
| ---------------------------- | ------------------------------------------------------------ |
| Physical page index          | document topology and cross-page precedence                  |
| Page-index difference        | candidate continuation edge strength                         |
| Logical page label           | front-matter/body transitions; Roman versus Arabic numbering |
| Printed page number          | furniture discovery and page-label verification              |
| Page parity                  | alternating running headers and layouts                      |
| Normalized document position | front matter, main body, appendices, references              |
| Page-template cluster        | determines how local geometry should be interpreted          |

Putting raw page index into every HDBSCAN vector would be harmful: it could cause typography regimes to split merely because their instances occur far apart in the document.

But excluding page identity from the system would discard essential ordering, recurrence, and transition evidence.

The solution is to give features typed roles.

## Four kinds of feature placement

### 1. Entity features

Properties of one glyph, line, block, or region:

```text
font metrics
size ratio
bbox
normalized page position
character composition
cluster membership
body-regime distance
math-regime distance
page index
```

These are suitable for clustering or node classification.

### 2. Relational or edge features

Properties of a candidate relationship \(u \rightarrow v\):

```text
same page
page delta
vertical and horizontal gap
shared column/template
baseline compatibility
typography compatibility
sentence continuation
hyphen continuation
intervening objects
heading boundary
bottom-of-page → top-of-next-page transition
```

These belong on the manuscript-flow graph, not in one object’s vector.

For example:

```text
edge(block_47 → block_48):
    page_delta = 1
    source_position = bottom_to_top
    same_body_regime = true
    sentence_continuation = strong
    intervening_furniture = ignored
    figure_interruption = false
```

### 3. Conditioning features

These define the appropriate comparison population:

```text
document ID
page-template regime
section candidate
typography cluster
column regime
language/script
page parity
```

For example, an Isolation Forest might be fitted within:

```text
typography cluster T4
AND page-template regime P2
```

without treating those labels as numeric dimensions.

### 4. Constraints and priors

Some evidence should directly constrain assembly:

```text
physical page 7 generally precedes physical page 8
a section heading precedes its section body
a caption remains attached to its figure
running furniture does not interrupt body flow
a display equation occupies a definite position in the section stream
```

These are not clustering features. They are hard or soft constraints on valid manuscript graphs.

## Use different feature containers

Instead of one universal matrix, maintain several typed structures:

```text
node_features[entity_id]
edge_features[source_id, target_id]
group_features[cluster_id]
document_features[document_id]
constraints[]
```

Then each discovery job declares what it consumes.

For manuscript-flow recovery:

```text
nodes:
    line/block configurations

node features:
    geometry
    typography regime
    body/heading scores
    page and template context

candidate edge features:
    page delta
    geometric continuation
    column compatibility
    lexical continuation
    style consistency
    intervening-region evidence

constraints:
    page topology
    section anchors
    exclusion of furniture
```

The flow problem is therefore not fundamentally a point-clustering problem. Clustering discovers the regimes from which useful node and group features arise; assembly operates primarily over relation features and constraints.

## The same evidence can serve different roles in different jobs

Consider `page_index`.

### Global typography clustering

```text
Do not include page_index in the primary distance.
After clustering, examine each cluster’s distribution over pages.
```

The distribution becomes an engineered feature:

```text
page coverage
first/last occurrence
contiguous run
document-position concentration
```

### Page-template clustering

Page position may be useful:

```text
front matter tends to occur near document start
appendices and references near document end
```

But it should remain a weak feature so geometry/layout can override it.

### Furniture discovery

Page identity becomes central:

```text
recurrence across pages
odd/even alternation
position variance
missing-page pattern
printed-number progression
```

### Flow assembly

Use relational forms:

```text
page_delta
same_page
adjacent_page
bottom_to_top_transition
```

### Section inference

Use document-position distributions:

```text
style cluster begins at page 1 and disappears after page 3
heading configuration appears throughout pages 4–60
bibliography configuration occurs only near the end
```

This is why a feature registry needs to describe not just how a feature is calculated, but how it is permitted to enter different analyses.

## Feature views and fusion strategies

For any discovery problem, explicitly choose among four combination strategies.

### Early fusion

Concatenate compatible features into one normalized vector:

```text
font size ratio
line height
weight
italic
character density
```

Good when the features jointly define one notion of similarity.

### Late fusion

Run separate clusterings:

```text
typography clustering
geometry clustering
recurrence clustering
```

Then reconcile memberships.

Good when each view captures a distinct kind of structure and arbitrary scaling would blur their meanings.

### Conditional refinement

```text
cluster on typography
→ examine spatial/recurrence outliers within each typography cluster
```

This is the HDBSCAN plus Isolation Forest idea.

### Relational assembly

Use entity discoveries as features in a graph:

```text
typography memberships
+ geometry
+ page topology
+ lexical continuity
→ flow-edge hypotheses
```

Good for reading order, section continuity, caption attachment, and script attachment.

The gauntlet can test which fusion strategy works for each problem.

## A concrete manuscript-flow feature contract

### Node unit

Candidate text block.

### Intrinsic view

```text
bbox and normalized page position
line count
typography-cluster distribution
text density
capitalization
punctuation endings
body/heading/math memberships
```

### Context view

```text
page-template cluster
column assignment
section-anchor neighborhood
nearby figure/math regions
document-relative position
```

### Candidate edge view

For every plausible successor:

```text
page delta
same/adjacent column
geometric gap
font/style continuity
sentence continuity
hyphenation continuity
indent compatibility
intervening heading
intervening display object
flow crossing penalty
```

### Constraints

```text
section anchors partition flow
excluded furniture cannot be a body successor
negative page movement is normally forbidden
caption–figure relations remain adjacent under canonicalization
```

### Output

Not one total order immediately, but:

```text
weighted partial-order graph
+ competing successor edges
+ reasons supporting each edge
```

Later reconciliation and the canonicalization profile select the total manuscript order.

## Feature provenance matters too

Every engineered feature should retain how it was derived:

```json
{
  "name": "cross_page_continuation",
  "entity_type": "block_edge",
  "value": 0.91,
  "inputs": [
    "page_delta",
    "body_regime_match",
    "sentence_continuation",
    "bottom_to_top_geometry"
  ],
  "normalization": "document-local-v1",
  "available_at_stage": "provisional-flow",
  "used_by": ["flow-assembler", "reasoning-hotspot-builder"]
}
```

That makes model adjudication and gauntlet diagnosis much more informative. A failed flow edge can be traced to the features that supported it.

## The real design object is a feature grammar

For each feature, specify:

```text
entity level
atomic or engineered
scalar/categorical/vector/relational/constraint
scope
normalization
invariances
stage of availability
valid fusion modes
consuming discovery jobs
provenance
```

Then each problem—typography regimes, heading discovery, body flow, math masking, furniture, captions—selects a typed subset of that grammar.

So yes: posing the axes correctly is central. But the deeper point is:

> The important decision is not only which features exist; it is whether each feature defines similarity, conditions a local model, describes a relation, or constrains the assembled manuscript.

That distinction should prevent you from forcing every useful signal into increasingly overloaded clustering vectors.

> What about if i had a high dimensional clustering and I did selective projections to lower dimensional embeddings of the clusters e.g. remove page number signals and observe how certain clusters or subsets of the data merge as a result. The exact strategy for doing this more systematically and in general is unclear but i think this would be useful for being able to flexibly examine different constrained views on a more complete dataset

Yes. This is a principled idea: **counterfactual clustering over controlled feature projections**.

You are asking:

> Which structures persist when particular evidence is hidden, weakened, or emphasized—and which distinctions exist only because of that evidence?

Removing page-number signals is an intervention on the feature space. If two clusters merge afterward, page-related evidence was helping maintain their separation.

## Do not privilege the full-dimensional clustering too strongly

Keep one complete feature substrate, but treat full-dimensional clustering as one view among several:

```text
complete entity/evidence table
    ├── full view
    ├── page-invariant view
    ├── typography-only view
    ├── geometry-only view
    ├── recurrence view
    ├── flow-context view
    └── selected combinations
```

For each view, recompute distances, neighborhoods, and clustering. Projecting already assigned high-dimensional clusters is useful for visualization, but it does not tell you what HDBSCAN would discover in the projected space.

Removing dimensions can change density geometry in nontrivial ways:

- clusters can merge;
- clusters can split;
- points can enter or leave noise;
- membership probabilities can change;
- a previously dense cluster can disappear.

So the primary comparison object should be the resulting partitions, not merely the plotted projections.

## Define feature groups, not just individual columns

A manageable registry might begin with:

```text
P: page identity and document position
G: normalized geometry
T: typography and font metrics
F: local flow and neighborhood
R: cross-page recurrence
L: lexical/register composition
X: path/image/glyph relationships
```

Each group should produce either a normalized vector or its own distance matrix:

```text
D_page
D_geometry
D_typography
D_flow
D_recurrence
D_lexical
D_graphics
```

A composite view can then use:

\[
D_w(i,j)=
w_P D_P(i,j)+
w_G D_G(i,j)+
w_T D_T(i,j)+
w_F D_F(i,j)+
w_R D_R(i,j)+
w_L D_L(i,j)+
w_X D_X(i,j)
\]

The group distances need comparable scaling so a group with fifty columns does not dominate one with three.

Now “remove page signals” is simply:

```text
wP = 0
```

rather than destructively creating a different dataset.

## A systematic family of views

You do not need to test every one of \(2^n\) feature subsets. Use an organized sequence.

### 1. Leave-one-group-out

```text
full
full - page
full - typography
full - geometry
full - recurrence
...
```

This asks which groups are necessary to preserve full-view distinctions.

### 2. Single-view discovery

```text
page only
typography only
geometry only
flow only
recurrence only
```

This reveals the native structure of each evidence family.

### 3. Designed combinations

Based on specific problems:

```text
typography + geometry
typography + recurrence
geometry + flow + page
typography + lexical + math-context
geometry + recurrence + page-parity
```

### 4. Continuous weight sweeps

Instead of moving immediately from page weight `1` to `0`:

```text
wP = 1.0
wP = 0.75
wP = 0.50
wP = 0.25
wP = 0.0
```

Track where clusters merge, split, or lose stability.

This gives a kind of **feature-weight persistence path**. A distinction that survives until page weight is almost zero differs from one that disappears as soon as page evidence is slightly weakened.

### 5. Randomized subspace ensembles

Sample feature-group weights or subsets, rerun clustering, and accumulate co-membership frequencies. This estimates whether a grouping is stable across many plausible views rather than one hand-selected vector.

## Build a merge/split correspondence graph

Represent every discovered cluster as:

```text
(view, parameters, cluster_id)
```

Connect clusters across views using membership overlap:

```text
Jaccard overlap
weighted overlap using soft memberships
containment ratio
shared stable-core fraction
```

This produces a graph like:

```text
Full:C7
  ├── page-invariant:C3       92% overlap
  ├── typography-only:C11     81% overlap
  └── recurrence-only:C2      47% overlap

Full:C8
  └── page-invariant:C3       88% overlap
```

Here `C7` and `C8` both map into page-invariant `C3`, suggesting that their full-view separation was page-dependent.

Useful partition-level metrics include:

- adjusted mutual information;
- variation of information;
- adjusted Rand index;
- pairwise co-association changes;
- cluster persistence/stability;
- noise transition rates.

For interpretation, membership overlap and pairwise changes are often more useful than one global score.

## Pairwise co-association is a powerful common currency

For every pair of entities \(i,j\), record:

\[
A\_{ij}^{(v)} =
\begin{cases}
1 & \text{if co-clustered in view }v \\
0 & \text{otherwise}
\end{cases}
\]

With soft clustering, use a graded value derived from membership strength.

Across views:

\[
A*{ij} = \sum_v w_v A*{ij}^{(v)}
\]

Now you can ask:

```text
Which pairs associate only when page evidence is active?
Which associate under typography and geometry independently?
Which never associate except in the full overloaded vector?
Which remain associated under nearly every projection?
```

That directly supports consensus assembly.

## Example: page-dependent heading configurations

Suppose the full view produces:

```text
C4: chapter headings on pages 1–20
C9: visually similar chapter headings on pages 21–40
```

Under `full - page`:

```text
C4 + C9 → C2
```

Under typography-only:

```text
C4 + C9 → T1
```

Under geometry-only:

```text
C4 + C9 → G3
```

This indicates that the split probably reflects document position rather than a genuine typographic or geometric distinction.

Alternatively:

```text
full - page:
    C4 remains separate from C9

typography-only:
    separate

geometry-only:
    merge
```

Now the evidence suggests a genuine typography change, perhaps a new document regime or appendix style.

The merge/split behavior itself becomes evidence.

## Distinguish projection from embedding

These are related but different operations.

### Feature projection or ablation

```text
remove page features
retain typography + geometry
```

This is interpretable because you know exactly which evidence was removed.

### Linear embedding

PCA or a learned linear projection can expose dominant combinations while retaining some feature interpretability.

### Nonlinear embedding

UMAP, t-SNE, diffusion maps, etc. can reveal useful shapes but may distort:

- density;
- distance;
- cluster size;
- separation;
- neighborhood relationships.

Use nonlinear embeddings primarily for inspection unless clustering stability has been independently verified in the selected feature space. Do not infer that two clusters truly merged simply because their 2-D UMAP clouds overlap.

For visual comparison across projections, compare cluster memberships and co-association, not raw embedding coordinates.

## If you require monotonic “removing evidence only merges”

Standard HDBSCAN will not guarantee this. Removing a feature can also split clusters because the density structure is recomputed.

If monotonicity is important for interpretation, construct it explicitly.

One approach is a multi-view similarity graph:

```text
edge(i,j) exists if:
    typography similarity passes
AND geometry similarity passes
AND page compatibility passes
```

Removing the page constraint can only add edges:

```text
typography passes
AND geometry passes
```

Connected components can therefore only merge, never split.

More generally, separate view-specific partitions can be combined using the partition lattice:

- their common refinement preserves every distinction made by the selected views;
- removing one view relaxes the refinement and permits merges.

This is stricter and often more fragmented than HDBSCAN, but it gives clean logical semantics.

A practical system can use both:

- HDBSCAN projection experiments for flexible discovery;
- a constraint/partition lattice for monotonic explanatory views.

## Store a feature-dependence signature

Each cluster or candidate structure can accumulate something like:

```json
{
  "cluster": "full:C7",
  "stable_core_fraction": 0.84,
  "projection_behavior": {
    "without_page": {
      "action": "merge",
      "with": "full:C8",
      "target": "page-invariant:C3"
    },
    "without_typography": {
      "action": "dissolve_into_noise"
    },
    "without_geometry": {
      "action": "stable"
    },
    "recurrence_only": {
      "action": "partial_match",
      "overlap": 0.71
    }
  },
  "interpretation": {
    "page_dependent": true,
    "typography_dependent": true,
    "geometry_dependent": false
  }
}
```

That would be excellent input to a reasoning agent:

> These two configurations are separated only when page identity is visible; they merge under both typography-only and geometry-only views.

That is far more informative than handing it a cluster label.

## A declarative view specification

Each experiment could be versioned as:

```yaml
name: page-invariant-typography-geometry
entity: text_line
scope: document

include:
  - typography
  - normalized_geometry

exclude:
  - physical_page_index
  - document_position
  - page_parity

conditioning:
  - page_template_regime

distance:
  typography: 0.55
  normalized_geometry: 0.45

clusterer:
  type: hdbscan
  min_cluster_size: 8
  min_samples: 4
```

This makes projections reproducible and lets the gauntlet compare feature views as pipeline configurations.

The general mechanism you’re reaching for is therefore:

> Maintain one complete evidence substrate, define controlled projections or metric interventions over typed feature groups, rerun discovery under those views, and treat cluster persistence, merging, splitting, and noise transitions as evidence about which axes support each structural distinction.

That provides the flexibility you want without committing every problem to one overloaded high-dimensional clustering.

> I also wonder about how dendrogram, hierarchical and/or multiresolution analysis could fit in here. Also, persistent homology and in particular how a conditioned backbone similar in spirit to SIFTS but with more principled anchors or something like that could be useful here

This is where the hierarchy can become more than a visualization: it can encode which groupings survive changes of scale, view, and conditioning. I’m checking your local SIFTS discussion first, because “conditioned backbone” seems to refer to a specific earlier mechanism and I don’t want to substitute a generic interpretation for yours.


Yes—SIFTS points toward a much more concrete architecture: a **conditioned evidence filtration built around a partial manuscript backbone**.

The crucial qualification is that SIFTS already knows the sequence. Your system is trying to recover it.

## What SIFTS actually contributes

In [SIFTS2013.md](/D:/aghado01/codex-scientiae/compendia/ph/SIFTS2013.md:243):

- SIF constructs a Vietoris–Rips filtration from semantic distances between document units. It ignores order.
- SIFTS first adds edges between every consecutive pair \(x*i,x*{i+1}\).
- Those “time-skeleton” edges exist at filtration time zero, regardless of semantic distance.
- Similarity edges then appear as the threshold loosens.
- A similarity tie-back to an earlier unit can close a persistent \(H_1\) loop around part of the fixed sequence.

That is elegant because document order is observed. But directly copying it for PDF recovery would be circular: your \(x*i \rightarrow x*{i+1}\) sequence is precisely what you do not yet know.

So your analogue should not begin with a complete linear skeleton. It should begin with a **certified partial skeleton**.

## The conditioned-backbone formulation

Let \(V\) be candidate manuscript units—probably lines initially, later aggregated blocks.

For a conditioning context \(c\) and evidence view \(v\), construct:

\[
K*{c,v}(\tau)
=
\operatorname{Cl}\left(
B_c
\;\cup\;
\{e \mid a*{c,v}(e) \leq \tau\}
\right)
\]

where:

- \(B_c\) is a partial backbone of sufficiently trustworthy relationships.
- \(a\_{c,v}(e)\) is the activation threshold of a candidate relationship under one evidence view.
- \(\tau\) progressively admits less certain relationships.
- \(\operatorname{Cl}\) turns the graph into a clique complex when persistent homology is desired.

Unlike SIFTS, you would not implement the backbone by overwriting distances with zero. Keep backbone edges separate so their origin remains explicit.

The backbone should also be conditioned rather than universal. There may be different \(B_c\) for:

- a page-template regime;
- a column or geometric zone;
- a typography regime;
- a provisional body-text family;
- a figure/caption neighborhood;
- a cross-page continuation hypothesis.

This lets the same geometry mean different things in different document regimes.

## What should qualify as an anchor?

I would distinguish three levels.

### Hard anchors

Relationships entailed almost directly by the PDF:

- glyph containment in a text run;
- confidently reconstructed glyph order along one baseline;
- object and bounding-box provenance;
- physical page ordering;
- containment and overlap relationships;
- known figure/XObject boundaries.

Physical page order is an anchor at the coarse level, but it does not tell you which column exit connects to which column entrance.

### Certified structural anchors

Not logically guaranteed, but supported independently:

- two line fragments with compatible baselines, spacing, font state, and content-stream adjacency;
- stable body-text cores surviving several feature views;
- repeated page-template regions;
- high-margin local continuation edges;
- column regimes supported by whitespace, alignment, and recurrence;
- figure–caption associations supported by proximity, lexical pattern, and exclusivity.

Certification could be based on something like:

\[
\text{anchor strength}
=
\text{view agreement}
\times
\text{scale persistence}
\times
\text{local margin}
\times
\text{constraint consistency}
\]

### Soft anchors

Plausible relationships that enter early in a filtration but are not placed in \(B_c\):

- heading-to-following-body attachment;
- cross-page paragraph continuation;
- ambiguous column transition;
- inline-math versus prose continuation;
- caption association with multiple nearby figures.

These remain revisable.

This separation also resolves the page-number issue from the previous discussion: you can remove page features from a typography projection while retaining physical page order as a backbone constraint. “Ignore page number as a clustering feature” does not have to mean “pretend page order is unknown.”

## Several hierarchies, not one dendrogram

There are at least four distinct hierarchies here, and conflating them would make the architecture nebulous again.

| Hierarchy            | What it organizes                                    | What it answers                             |
| -------------------- | ---------------------------------------------------- | ------------------------------------------- |
| Compositional        | glyph → run → line → block → region                  | What contains what?                         |
| Similarity/density   | typography or geometry families                      | Which entities behave alike?                |
| Flow assembly        | local chains → columns → page transitions → sections | What follows what?                          |
| Manuscript semantics | heading levels → sections → section bodies           | What role does the recovered sequence play? |

A cluster dendrogram belongs primarily to the second category. It should not automatically become the section hierarchy.

Likewise, deterministic aggregation from glyphs to lines is not the same operation as hierarchical clustering. You want explicit mappings between these levels so evidence can travel upward and downward without losing provenance.

## Where dendrograms and HDBSCAN fit

A dendrogram is best understood as a family of candidate partitions over scale, not something you cut once.

For your purposes, it can expose:

- when body-text variants merge;
- whether heading candidates form their own branch or merely a tail around body text;
- whether captions separate before references and footnotes do;
- which distinctions disappear when page or typography signals are ablated;
- which points repeatedly remain peripheral across resolutions.

HDBSCAN’s condensed tree already provides a density-based version of this idea. Its cluster stability is closely related in spirit to \(H_0\) persistence, though it uses mutual-reachability density rather than a plain metric threshold.

Your Isolation Forest idea fits naturally at nodes in this hierarchy:

1. Find a stable cluster or branch.
2. Condition on that population.
3. Run Isolation Forest over a selected secondary feature set.
4. Track each entity’s anomaly signature across parent and child branches.
5. Cluster the anomaly signatures into different outlier modes.

That gives you a **multiresolution anomaly trajectory**. A line might be anomalous globally because it is a caption, ordinary inside a caption family, but anomalous again because it is actually a table note. That trajectory is more informative to a reasoning agent than one global anomaly score.

## Persistent homology: start with \(H_0\)

\(H_0\) is immediately relevant:

- births represent initially separate entities or cores;
- deaths represent merge events;
- long-lived components suggest robust regimes;
- short-lived components suggest bridges, noise, or weak distinctions.

For ordinary single-linkage clustering, the \(H_0\) barcode and dendrogram encode essentially the same merge history. This is explicitly noted in the SIFTS paper.

The value is not merely finding “the best clustering.” It is identifying:

- stable cores;
- unstable bridges;
- threshold-sensitive attachments;
- candidate anchors that survive broad scale intervals.

These persistent cores can condition subsequent local clustering and graph assembly.

## What \(H_1\) could mean in your system

\(H_1\) is potentially useful, but only after deciding what an edge means. A loop has no universal manuscript interpretation.

In different typed graphs, a persistent loop might indicate:

- **flow graph:** competing reading-order routes that later reconverge;
- **typography graph:** a recurring style family connected through several intermediate variants;
- **page-template graph:** a repeated structural pattern across page regimes;
- **section-flow backbone:** a nonlocal recurrence analogous to SIFTS’s tie-back;
- **figure/text graph:** ambiguous detours around a figure or display-math interruption.

For reading-order recovery, a loop may be evidence of contradiction or ambiguity rather than meaningful document topology. That is still useful: extract a representative cycle and present only those lines, edges, provenance records, and visual crops to the reasoning model.

That creates a principled hotspot:

> “These six blocks admit two persistent flow routes. Here is the evidence supporting each edge and the surrounding section context.”

That is far better than asking the model to reconstruct the whole page.

I would defer \(H_2\) and higher. They could eventually characterize grids or more complicated region arrangements, but \(H_0\) plus carefully designed \(H_1\) complexes already gives you plenty.

## Multiview persistence needs care

Threshold variation inside one fixed metric produces a genuine nested filtration.

Feature ablation does not necessarily do that. Removing page signals or changing feature weights can make some edges appear and others disappear, so the complexes are not nested.

A practical hierarchy would be:

1. Compute ordinary persistence separately within each controlled view.
2. Match persistent components and cycles across views.
3. Measure cross-view support for each core, edge, and representative cycle.
4. Use zigzag persistence later if the discrete view sequence has a meaningful order.
5. Treat full multiparameter persistence as a later research direction; initially use controlled one-dimensional slices or weight “vineyards.”

This prevents “persistence” from becoming a vague synonym for “appeared in several experiments.”

## A plausible order of operations

The pipeline now looks less like a classifier cascade and more like iterative graph recovery:

1. Extract immutable PDF atoms, geometry, typography, object identity, and provenance—drawing heavily from OpenDataLoader’s deterministic evidence gathering.

2. Produce document-global normalizations and multi-view cluster hierarchies. The analysis is whole-document, even when particular relationships are local.

3. Identify persistent cores and page-template regimes. A dominant body-text core is probably one of the earliest useful reference manifolds.

4. Run cluster-conditioned Isolation Forest analyses at selected branches and scales. Preserve anomaly vectors and modes without assigning semantic identities yet.

5. Construct a partial conditioned backbone from hard and certified anchors.

6. Admit uncertain relationships through typed filtrations. Examine \(H_0\) merges, unstable attachments, and meaningful \(H_1\) cycle representatives.

7. Reconcile views and invoke reasoning only for residual branch points, cycles, mask ambiguities, and competing role hypotheses.

8. Assemble the latent directed manuscript graph, then derive heading/body spans, embedded math, figures, captions, and ultimately the source-neutral final IR.

The directed flow graph should remain separate from its undirected topological shadow. Ordinary persistent homology can diagnose the latter; directionality and acyclicity still need explicit assembly constraints.

## The architectural distinction

OpenDataLoader gives you deterministic atoms, evidence, provenance, and conservative semantic assembly. MinerU gives you learned region and role proposals. Your distinctive layer could be:

> **document-global, multiview recovery of a conditioned manuscript backbone through persistent cluster cores, anomaly refinement, and topology-guided reconciliation.**

The topology would not determine identity. It would determine which structures are stable, which attachments are contingent, and which small regions deserve reasoning.

That feels considerably more precise than “use clustering and persistent homology”: the central object is the evolving evidence graph, and clustering, dendrograms, Isolation Forest, persistence, deterministic heuristics, and reasoning models are different instruments for interrogating and completing it.

> So identifying the anchors kind of smells like inference on hidden states, with the most likely or most plausible configuration being estimated. Like, I will independently be extracting candidate section title lines and spans of body text. Then I know there's this latent directed graph with unknown anchors, and maybe I infer it with high confidence by how surprisingly well certain proposals are. almost like solving a linear system of equations, very loosely speaking, and assuming i have enough evidence to constrain the problem adequately

Yes. I think this is the conceptual shift that makes the architecture snap into focus:

> The anchors are not necessarily inputs to inference. Many of them are conclusions of inference—decisions that remain stable across the plausible manuscript configurations.

This is closer to **abductive structured inference over a latent manuscript grammar** than ordinary clustering.

## Observed evidence versus hidden manuscript

You observe:

- PDF atoms, geometry, typography, page position, and content-stream order;
- candidate lines and regions;
- high-recall heading proposals;
- overlapping body-span proposals;
- possible math, figures, captions, artifacts, and page-template elements;
- clustering memberships, outlier signatures, and persistence evidence.

The hidden configuration might contain variables such as:

- \(r_i\): manuscript role of unit \(i\);
- \(e\_{ij}\): whether \(j\) follows \(i\);
- \(s_i\): section membership;
- \(h_i\): heading level;
- \(a_i\): attachment parent for captions, figures, notes, and math;
- \(b_i\): whether a body span begins, continues, or ends;
- whether each candidate unit or edge is selected at all.

Then the problem becomes approximately:

\[
Z^\* =
\arg\max_Z
\left[
\text{local evidence}

- \text{relational fit}
- \text{segment coherence}
- \text{document-wide consistency}

* \text{constraint violations}
  \right]
  \]

That is a factor graph, weighted constraint problem, or MAP structured-prediction problem depending on how you implement it.

Clustering does not need to solve the manuscript. It supplies factors:

- “These lines belong to the dominant body regime.”
- “These rare lines form three distinct anomaly modes.”
- “This candidate heading resembles six other section-transition lines.”
- “This continuation edge is geometrically ordinary within this column regime.”
- “This line remains peripheral across several cluster resolutions.”

## Constrain the graph topology aggressively

The latent structure probably should not be modeled as an arbitrary directed graph. The canonical manuscript envelope already gives you a strong structural prior:

- a principally linear directed manuscript spine;
- section boundaries placed along that spine;
- body spans occupying intervals of the spine;
- heading nodes opening sections;
- display math, figures, and tables interrupting—but not necessarily terminating—body spans;
- captions and notes attached as typed side structures;
- a section tree induced by heading rank;
- page boundaries retained only as provenance and coarse ordering constraints.

So it is more like:

```text
directed manuscript spine
    ├── section segmentation
    ├── heading hierarchy
    ├── inline register annotations
    └── typed side attachments
```

This dramatically reduces the hypothesis space.

If reading order were already known, section recovery would resemble a semi-Markov model: infer variable-length heading and body segments rather than independently labeling each line. Because reading order is also hidden, you need to jointly—or iteratively—infer:

1. which candidate nodes participate;
2. their order;
3. their segment roles;
4. their attachments.

A candidate-order DAG can encode physically possible successor edges. A constrained optimizer can then select a near-linear path or path cover while scoring section and role consistency.

## “Surprisingly well” is global explanatory power

What you are describing is abductive reasoning: prefer the configuration that makes the largest amount of independently observed evidence unsurprising.

Suppose one line is proposed as a heading. By itself, increased font size is weak. But that proposal becomes powerful if it simultaneously explains:

- an upstream body-span termination;
- a downstream body-span beginning;
- unusual vertical whitespace;
- numbering syntax;
- recurrence of the same typographic regime elsewhere;
- alignment with other heading candidates;
- a plausible heading-level sequence;
- continuity of body prose across the following pages.

The proposal’s strength is not the sum of isolated classifier scores. It is the reduction in incoherence across the entire manuscript hypothesis.

That could be expressed as a likelihood ratio or an MDL-style gain:

\[
\operatorname{gain}(H)
=
\operatorname{fit}(H)

- \operatorname{fit}(\text{null})
- \operatorname{complexity}(H)
  \]

A good configuration explains many observations without inventing numerous exceptions.

One major caution: heading and body-span proposal systems may reuse the same typography and whitespace features. Their agreement is then not independent evidence. Evidence provenance matters so that the global scorer does not count the same font-size observation three times under different names.

## Anchors as posterior invariants

Rather than declaring an anchor whenever one detector is confident, define an anchor decision \(d\) through its behavior across plausible configurations:

\[
d \in B\_\alpha
\quad\text{when}\quad
P(d\mid X) > 1-\alpha
\]

and ideally when it remains stable under:

- the top \(k\) near-optimal manuscript configurations;
- modest feature-weight perturbations;
- removal of individual feature families;
- clustering resolution changes;
- alternative candidate segmentations;
- different reasonable local geometric models.

This produces a posterior backbone containing things such as:

- a line’s role is almost certainly body;
- this local ordering edge appears in 99% of plausible configurations;
- this heading candidate consistently opens the same downstream span;
- these two body fragments continue across a page boundary;
- this caption attaches to the same figure under every competitive solution.

The unresolved remainder is not noise. It is the precise uncertainty frontier for further analysis or reasoning-model adjudication.

You could estimate this with exact marginals for tractable subproblems, or more practically through:

- \(k\)-best solutions;
- perturb-and-resolve runs;
- bootstrapped feature views;
- weight sweeps;
- proposal ablations;
- an ensemble of constrained solutions.

The backbone is then the consensus of the posterior ensemble—not merely the result of one clustering.

## Your linear-equation analogy is useful

It is not literally linear because the variables are mostly discrete and the constraints combinatorial. But the analogy captures **identifiability**.

Each genuinely independent observation reduces the space of feasible manuscripts. Redundant evidence does not add much effective rank.

For example:

- typography alone may leave five heading interpretations;
- whitespace eliminates two;
- cross-document recurrence eliminates another;
- section-sequence consistency eliminates one;
- prose continuity makes the final configuration overwhelmingly preferable.

Conversely, some PDFs remain underdetermined. Two reading orders may be equally consistent with all available evidence. In that case the system needs either:

- an explicit canonical reading-order convention;
- a reasoning-model judgment;
- or retained uncertainty in the hypothesis IR.

Posterior concentration, entropy, and the gap between the best and second-best configurations become measures of whether the available evidence constrains the inverse problem adequately.

## How this changes the pipeline

A strong iterative version would be:

1. Generate overlapping, high-recall candidates rather than committing early.

2. Use whole-document clustering and hierarchy to produce regime evidence, persistent cores, and anomaly modes.

3. Construct the feasible candidate manuscript graph.

4. Solve for several globally coherent configurations, not just one.

5. Extract the invariant decisions as the current backbone.

6. Identify high-entropy branch points, competing segmentations, and persistent cycles.

7. Give reasoning models those localized alternatives with visual and contiguous manuscript context.

8. Add the resulting evidence and solve again.

Persistent homology then complements posterior inference:

- \(H_0\) persistence identifies stable evidence populations and attachment scales.
- \(H_1\) representatives can expose competing routes or nonlocal tie-backs.
- Posterior stability determines whether a particular role or edge is actually an anchor.

So topology describes stability in the evidence geometry, while structured inference determines which stable structures best explain a manuscript.

I think the most precise name for what you are converging on is something like:

> **posterior recovery of a latent manuscript graph from multiview PDF evidence**

The clustering system discovers the evidence geometry; the constrained latent-state model converts that geometry into manuscript hypotheses; and the anchors are the high-confidence invariants that emerge from reconciliation.

> both opendataloader pdf and minerU both do a pretty good job with their document processing in terms of solving the document's reading order. Not perfect, but that's something that comes out of their automation rather than models, if only implicitly. Maybe I should study their deconstruction and assembly procedures more closely for what information they read and how they use it


Yes. The code already supports that instinct: their reading-order quality is not one isolated sorter. It emerges from the entire sequence of **deconstruction, suppression, grouping, ordering, and reassembly**.

One correction: MinerU’s current pipeline is not entirely model-free. Its PP-DocLayoutV2 path contains a specialized learned reading-order head—not a reasoning model or general VLM, but still a model. It predicts pairwise order scores from layout boxes and class labels, and deterministic code turns those scores into a total ranking. OpenDataLoader’s Java ordering path is geometric and deterministic.

## What OpenDataLoader actually does

The core path in [DocumentProcessor.java](/D:/aghado01/packages/opendataloader-pdf/java/opendataloader-pdf-core/src/main/java/org/opendataloader/pdf/processors/DocumentProcessor.java:174) is approximately:

1. Extract page artifacts from the PDF object structure.
2. Filter and normalize raw content.
3. Merge nearby chunks and split chunks around whitespace.
4. Detect tables.
5. Combine chunks into text lines.
6. detect recurring headers and footers across pages.
7. Form paragraphs, lists, and heading candidates.
8. Assign stable IDs and link captions.
9. Reconcile lists, tables, and heading levels across pages.
10. Finally sort the resulting semantic objects.

Its optional final reading-order step is [XYCutPlusPlusSorter.java](/D:/aghado01/packages/opendataloader-pdf/java/opendataloader-pdf-core/src/main/java/org/opendataloader/pdf/processors/readingorder/XYCutPlusPlusSorter.java:25):

- discard objects lacking geometry;
- optionally mask cross-layout objects;
- search for horizontal and vertical whitespace cuts;
- choose the larger sufficiently wide gap;
- recursively partition the page;
- fall back to top-to-bottom, left-to-right ordering;
- reinsert cross-layout objects by vertical position.

The significant point is that XY-Cut is operating on objects that have already become lines, paragraphs, headings, tables, and captions—not raw glyphs. Much of its success belongs to the quality of those input units.

The source audit also reveals why studying implementations matters:

- The default cross-layout parameter is `beta = 2.0`; under its `width >= beta * maxWidth` rule, that effectively disables cross-layout detection.
- A density ratio is computed and passed as a horizontal/vertical preference, but the current recursion ultimately chooses the larger valid gap and does not meaningfully use that preference.

So OpenDataLoader’s good results may derive less from every advertised XY-Cut++ enhancement than from its prior object normalization and semantic consolidation.

## What MinerU actually does

In the PP-DocLayoutV2 pipeline, [pp_doclayoutv2.py](/D:/aghado01/packages/MinerU/mineru/model/layout/pp_doclayoutv2.py:719) has a learned reading-order component:

- detected boxes and predicted layout classes become embeddings;
- a neural head produces pairwise order logits;
- pairwise scores are converted into votes;
- boxes are ranked by those votes;
- the final rank is written as each region’s `index`.

Then [pipeline_magic_model.py](/D:/aghado01/packages/MinerU/mineru/backend/pipeline/pipeline_magic_model.py:70) performs deterministic assembly:

- normalize coordinates and remove degenerate regions;
- separate inline-formula and OCR spans from ordinary layout blocks;
- sort regions by the learned `index`;
- match native/OCR spans into the detected regions;
- reconstruct lines using geometric overlap;
- sort spans within each line;
- classify figures, tables, charts, equations, titles, and text;
- move headers, footers, page numbers, asides, and footnotes into `discarded_blocks`.

Its document-level paragraph procedure is particularly relevant. [para_split.py](/D:/aghado01/packages/MinerU/mineru/backend/pipeline/para_split.py:417) flattens blocks from every page into one ordered sequence. It then:

- divides the sequence at titles, abstracts, and display equations;
- detects text/list/index regimes;
- tests adjacent blocks for continuation;
- considers indentation, width compatibility, punctuation, uppercase and numeric starts, line endings, and page identity;
- merges qualifying blocks;
- records cross-page continuations explicitly.

Finally, [model_json_to_middle_json.py](/D:/aghado01/packages/MinerU/mineru/backend/pipeline/model_json_to_middle_json.py:216) runs paragraph assembly, cross-page table merging, title leveling, and final normalization.

Thus MinerU’s order is:

> learned region ordering → deterministic span binding → geometric line recovery → heuristic paragraph and cross-page assembly.

## The more useful comparison

| Stage                | OpenDataLoader Java                            | MinerU pipeline                                |
| -------------------- | ---------------------------------------------- | ---------------------------------------------- |
| Initial evidence     | Native PDF objects                             | Raster layout detections plus native/OCR spans |
| Region identity      | Deterministic object processing                | Learned layout classes                         |
| Page ordering        | Recursive geometric whitespace cuts            | Learned pairwise order ranking                 |
| Line formation       | Chunk compatibility probabilities and geometry | Span overlap and coordinate sorting            |
| Artifact removal     | Cross-page recurrence and content filtering    | Detected header/footer/page-number roles       |
| Paragraph formation  | Line-merge probabilities and alignment         | Geometry, punctuation, casing, indentation     |
| Cross-page assembly  | Neighbor list/table and heading reconciliation | Global paragraph pass and table continuation   |
| Final representation | Semantic `IObject` sequence                    | `middle.json` page/block sequence              |

Neither is simply “predict reading order.” Each progressively converts a messy ordering problem into an easier one.

## What to capture from them

I would study their procedures as **evidence-generating algorithms**, not just final sorters. Instrument each decision so it exposes:

- source and target objects;
- proposed predecessor/successor edges;
- recursive cut tree;
- horizontal and vertical gap magnitudes;
- chosen cut and runner-up;
- column membership;
- span-to-line and line-to-block membership;
- discarded-object reason;
- paragraph-merge conditions that passed and failed;
- cross-page continuation evidence;
- learned pairwise order score, where available;
- whether the decision survives alternative parameters.

Instead of merely receiving:

```text
A, B, C, D, E
```

your system should receive evidence like:

```text
A precedes B:
  horizontal-cut ancestry
  gap margin = 18.2
  same column regime
  supported by model pairwise score
  contradicted by content-stream order
```

That is exactly the material needed for your posterior manuscript-graph inference.

## How this fits your approach

You can treat the systems as independent proposal mechanisms:

- OpenDataLoader contributes a deterministic geometric and born-PDF hypothesis.
- MinerU contributes a learned region-order hypothesis and deterministic continuation heuristics.
- PdfPig contributes high-resolution native geometry and text state.
- Your clustering supplies document-global typography regimes, anomaly modes, and recurrence structure.
- The reasoning model examines only disagreements and low-margin graph regions.

The anchor backbone then consists of edges or groupings that remain stable across these mechanisms—not whichever order one pipeline emitted.

The best next experiment would be to choose a small set of PDFs with corresponding LaTeX, emit a staged “decision ledger” from both pipelines, and compare against the LaTeX-derived manuscript graph. For every final error, identify the earliest divergence:

1. wrong atom or span;
2. wrong line grouping;
3. wrong region classification;
4. wrong page-order edge;
5. wrong paragraph continuation;
6. wrong cross-page attachment;
7. wrong section assembly.

That would turn OpenDataLoader and MinerU from systems to imitate into empirical decompositions of the inverse problem—and show which of their subproblems your clustering architecture actually needs to replace, augment, or simply reuse.

> I definitly think I can take inspiration from each of their respective operational paths to arriving at an orderd document order, and I already have xycut++ in the current implementation. The picture emerging from me is that there is likely an initial global discovery phase, there's some kind of recursive process that zooms in from global to local and merges/reconciles evidence, before the ordering is determined, and then after manuscript graph ordering, then the math/prose contrastive analysis.. I wonder if instead of a beta free parameter, I could somehow calibrate or auto-tune somehow from within document data

Yes—assuming you mean XYCut++’s cross-layout width multiplier, beta is exactly the kind of parameter that should become **document-conditioned evidence**, not remain a universal constant.

More strongly: “cross-layout” should probably be inferred relative to a proposed partition, not assigned from width alone.

## Replace width thresholding with structural evidence

A cross-layout element is important because it masks an otherwise coherent cut. That suggests a counterfactual test.

For candidate element \(e\) and candidate cut \(c\), measure:

\[
\Delta\_{\text{gap}}(e,c)
=
\operatorname{gap}(c\mid V\setminus e)

- \operatorname{gap}(c\mid V)
  \]

If removing \(e\):

- reveals a strong whitespace valley;
- leaves substantial content on both sides;
- produces column groups recurring elsewhere in the document;
- and \(e\) geometrically overlaps both groups;

then \(e\) is probably a cross-layout bridge.

This is more informative than:

\[
\operatorname{width}(e) \geq \beta\operatorname{maxWidth}
\]

because a wide figure, short body line, full-width heading, and page footer interact with the layout differently even when their widths are similar.

A useful bridge signature might contain:

- normalized width within the current region;
- number of inferred columns intersected;
- gap improvement when masked;
- support on both sides of the cut;
- alignment with candidate column boundaries;
- recurrence of the resulting partition across pages;
- typography and role-cluster membership;
- vertical whitespace above and below;
- whether the element is a stable anomaly inside its local regime.

Your cluster-conditioned Isolation Forest could help propose unusual bridge modes, but the counterfactual cut effect supplies the relational evidence that node features alone cannot.

## Three increasingly principled calibration strategies

### 1. Sweep beta and retain the stable plateau

This is the easiest strong baseline.

Run recursive decomposition over a reasonable beta grid and record:

- cut-tree structure;
- selected horizontal and vertical cuts;
- resulting order edges;
- cross-layout classifications;
- second-best cuts and margins.

Then find intervals where the important decisions remain stable. Do not necessarily choose one beta immediately:

\[
P(G\mid X)
\approx
\sum\_{\beta}
P(G\mid X,\beta)P(\beta\mid X)
\]

In practical terms:

- edges surviving most plausible beta values become anchors;
- beta-sensitive branches remain hypotheses;
- the reasoning model sees only unstable regions;
- if one interval produces much greater global coherence, the posterior naturally concentrates there.

This turns beta into a filtration or nuisance parameter to marginalize rather than a magic number to guess.

### 2. Estimate beta from document width regimes

During global discovery, normalize region widths by the page content box or inferred column width:

\[
r*i=\frac{w_i}{W*{\text{content}}}
\qquad\text{or}\qquad
r*i=\frac{w_i}{\widetilde{W}*{\text{column}}}
\]

Within each layout regime, you may see modes corresponding to:

- ordinary column-contained blocks;
- narrow artifacts;
- full-width or cross-column blocks.

A density valley or mixture-model posterior boundary can replace a fixed beta. More importantly, estimate it per **layout regime**, not necessarily per document:

- front matter may be single-column;
- body pages may be two-column;
- appendices may change templates;
- odd/even pages may have mirrored margins.

A hierarchical estimate could let regime-specific values fall back toward a document-wide prior when data is sparse.

### 3. Eliminate beta through soft bridge inference

Ultimately, avoid making cross-layout masking a binary preprocessing decision.

For every candidate element, infer:

\[
P(\text{bridge}\mid e,c,\text{document evidence})
\]

Then either:

- weight its contribution to the projection profile;
- generate both masked and unmasked cut hypotheses;
- or let it enter the cut tree at an uncertainty-dependent threshold.

This makes cross-layout status part of the latent configuration rather than something fixed before ordering.

## Internal objectives for auto-calibration

The document contains several self-consistency signals you can optimize without gold reading order:

- stability of cuts under small parameter changes;
- recurrence of column boundaries across pages in the same regime;
- compactness of resulting alignment families;
- preservation of high-confidence local successor edges;
- low incidence of retrograde or crossing order edges;
- contiguous body-text runs;
- plausible heading-to-body transitions;
- few unexplained exceptions;
- consistency across geometric, typography, and model-derived views.

An MDL-like objective would be natural:

\[
J =
L(\text{layout regimes})

- L(\text{elements}\mid\text{regimes})
- \lambda_1\text{fragmentation}
- \lambda_2\text{flow violations}
- \lambda_3\text{exceptions}
  \]

Choose—or weight—the beta region producing the simplest coherent explanation of the document.

Avoid optimizing only the number or size of whitespace cuts; that generally rewards over-segmentation.

## The recursive architecture emerging

I think your order of operations is becoming:

1. **Global document discovery**

   Infer page-template regimes, recurring typography families, likely body cores, column-width distributions, repeated headers/footers, alignment modes, and coarse obstacle regions.

2. **Top-down decomposition**

   At each document/page/region node, propose several horizontal and vertical cuts. Condition their scores on the relevant global regime.

3. **Counterfactual bridge analysis**

   Determine which objects conceal otherwise persistent cuts. Preserve both masked and unmasked alternatives when uncertain.

4. **Local refinement**

   Recluster within discovered regions, run cluster-conditioned anomaly analysis, reconstruct lines and blocks, and update cut evidence.

5. **Bottom-up reconciliation**

   Assemble child-region orderings into parent hypotheses. Retain second-best cuts and margins instead of greedily freezing every recursion.

6. **Global manuscript-graph inference**

   Select a coherent directed spine and typed side attachments. Stable decisions across cut trees, parameters, and feature views form the posterior backbone.

7. **Math/prose contrastive recovery**

   Once contiguous manuscript context exists, resolve inline and display math using geometry-derived masks, neighboring prose, document-global analogues, and reasoning-model adjudication.

The only adjustment I would make to the last separation is that obvious figures, tables, and display-math-shaped regions must participate earlier as geometry-preserving opaque obstacles. Their fine-grained register interpretation can wait until after ordering.

The especially promising idea is that the recursive cut tree need not itself be the answer. It becomes a generator of hierarchical order constraints, margins, and competing graph proposals. The final manuscript ordering is selected only after those local decompositions have been reconciled against document-global evidence.
