Here’s a clean deconstruction focused on what is actually necessary.
The goal is a solid measurement IR (the shared typed chunk stream for prose + math registers). Everything else is secondary until that exists and can be scored against the oracle.

1. Necessary problems for pdfdig to reach the measurement IR
These are the problems that must be solved (or honestly residualized with good evidence) before Stage-0 parity measurement on the registers becomes meaningful:







































































#Necessary ProblemWhy it is required for the measurement IRCurrent status1Faithful substrateEverything downstream is only as good as the atomsStrong (letters + geometry + paths + outline + health)2Document-local regime / style-palette recoveryNeeded to separate body / script / display / heading configurationsPartial (order-statistics ladder). DESIGN.md already points at the redesign3Reading-order claims with uncertaintyWithout it the chunk stream has no reliable orderPartial (RecursiveXYCut is a single unwitnessed claim)4Math vs prose isolationThe fundamental register boundaryStrong for classic TeX fonts; weaker on SF / unknown fonts5Glyph → lexical surface + 1.5-D scriptsNeeded so math chunks have a usable surface stringStrong (math-assembler)6Inline vs display boundary decisionsDirectly determines $ vs $$ in the IRFragile — major source of oversegmentation and false confidence72-D math residual packagingFractions, matrices, aligned blocks, etc. cannot be solved deterministically yetFlagged + math-evidence, but packets not yet uniformly small/constrained8Heading / section hierarchy (or residual)Required for structural parityPartial — premature commitment and outline mismatch still common9Projection into typed, flagged, provenance-linked chunksThis is the measurement IRExists on pdfdig side; not yet symmetric with oracle10Uniform uncertainty / margin emissionSo Stage-0 can compute false-confidence and residual compressionPattern exists; not yet uniform
Not necessary for the first solid measurement IR (can stay residual or later lanes):

Full semantic tables
Complex multi-column edge cases
Equation number / tag recovery
Full cross-reference resolution
Glyph-built diagrams / raster-blind figures beyond the current PRIMARY

If the ten items above are solid, you can already measure coverage × fidelity on the math and prose registers. That is the completeness bar for this stage of the reboot.

2. Stores taxonomy — what is irreducible vs. reshapeable
Truly irreducible (world knowledge / encoding facts)

Symbol / glyph → LaTeX command maps (font-aware). Geometry cannot invent that \mathbb{R} means blackboard-bold R.
Producer-map and origin cues.
Small core of caption cue words and similar linguistic conventions.
Any lexical mapping that is cultural rather than geometric.

These stay as stores. Do not try to “learn” them per document.
Strong candidates for unsupervised / hierarchical replacement or augmentation

Style-palette / role recovery (the biggest opportunity).
The current size + bold tier ladder is a quantized approximation that works well on clean TeX but degrades on continuous or multi-modal documents.
Better formulation (exactly as DESIGN.md §1.3 says): recover the latent style palette of the document (mixture model, hierarchical clustering, or tree methods over size/weight/family/position/recurrence), then assign roles to configurations rather than individual lines via a small relational grammar + witnesses (outline, position, alternation with body).
This dissolves many of the special cases in the current decision ladder.
Reading order.
Single RecursiveXYCut claim is brittle. A second geometric or baseline-flow witness + explicit disagreement flag is higher leverage than more ladder complexity.
Math vs prose isolation beyond font names.
Document-local clustering on geometric + contextual features (local density, alignment, operator-like neighbors, whitespace patterns) can augment the font-role store, especially for non-classic math fonts.
Competing 2-D assemblies.
Instead of only emitting needs_2d_assembly, use hierarchical clustering or multi-scale methods on the local glyph + path cloud to propose a small set of competing groupings. The residual packet then carries the competitors rather than a single broken surface. This is pure discovery; the agent still adjudicates.

Policy / fitted ladders
Most of the long decision-order ladders and many thresholds in classify-config are candidates to be thinned. Prefer multi-view discovery → competing hypotheses → typed dominance rules or agent adjudication over deep single-view cascades.

3. PdfPig + feature engineering headroom
You are probably under-using the substrate. Richer derived features that stay inside perception:

Local density and whitespace descriptors
Alignment graphs (shared baselines, shared x-coordinates, vertical alignment of operators)
Path–glyph interaction features (glyph sitting on a thin rule = strong fraction-bar candidate)
Multi-scale neighborhood statistics
Stability of groupings across parameter ranges (the persistent-homology idea you already like)
More detailed font descriptor and rendering-mode signals when available
Baseline flow / continuity features for reading-order witnesses

These can feed both the palette recovery and the competing-hypothesis generators without violating “perception ≠ interpretation.”

4. How much life is left in the cascade / ladder motif?
Quite a bit for forced tier-0 decisions with clear margins, almost none for ambiguous or continuous cases.
Useful remaining roles for ladders:

Typed dominance rules when two witnesses disagree (outline vs typography, etc.)
Fast, deterministic filters with large margins (obvious furniture, obvious page numbers)
Final projection rules once regimes are known

Poor remaining roles:

Long ordered decision lists that try to resolve every edge case by priority
Treating the ladder as the primary way to discover structure rather than to adjudicate already-discovered candidates

The healthy pattern going forward is:
Multi-view unsupervised discovery (regimes, partitions, alignments)
→ small set of competing hypotheses with evidence
→ typed dominance or residual packet
→ agent only on the residual
This is more robust and directly improves the quality of the measurement IR (higher accepted fraction, lower false-confidence, smaller residuals).

Bottom line for the reboot
Keep the multi-lane substrate, flag-as-currency, 1.5-D assembler, math-evidence briefs, figure veto ladder, em-normalization, irreducible stores, and the overall perception/interpretation separation.
Reshape role identification into palette + configuration recovery, add witnesses for reading order, make residual packaging first-class (competing hypotheses), and emit uniform margins so the measurement IR can score confidence properly.
Explore aggressively with hierarchical / mixture / multi-scale methods and richer PdfPig-derived features inside the discovery stages. Do not let them make final semantic decisions.
The necessary surface to reach a useful measurement IR is smaller and more focused than the full eventual system. Solving the ten problems in the first table cleanly is the right completeness target for this phase.
Would you like to go deeper next on one of these:

A concrete sketch of the style-palette recovery formulation,
The residual packet shape for 2-D math under the competing-hypotheses model,
Or the minimal fields the measurement IR must have so Stage-0 can actually be implemented?
I'm trying to peel away as many rules as possible and looking at the rules I already have in place and wondering how i might be able to do things differently to not need them in some cases. Like if i exploit the pdfpig substrate more. Can we flesh out things i might get from that that i'm not yet, in more detail?Yes. There is substantial headroom in the PdfPig substrate that you are not yet fully exploiting.
The current letters.jsonl already captures a good baseline, but PdfPig (and the content stream underneath it) exposes more geometric, metric, and graphics-state signal that can turn several classes of hard-coded rules into discovery or strong geometric evidence.
Here is a concrete inventory, ordered by leverage for peeling rules.
1. Richer per-glyph / letter signals (easy wins to project first)
PdfPig’s Letter already gives you more than most people use:

StartBaseLine / EndBaseLine — the actual baseline segment, not a single y-value. This is better for rotation, slant, and building precise baseline-flow graphs.
GlyphRectangleLoose — uses the font’s Ascent/Descent instead of the tight ink bbox. More consistent across a font and better for vertical regime detection.
PointSize vs the internal FontSize.
TextRenderingMode (Fill, Stroke, FillThenStroke, Invisible, Clip variants, etc.).
Separate FillColor and StrokeColor.
TextOrientation and TextSequence (order of ShowText operations).

FontDetails / IFont (via GetFont()) is the biggest under-used source:

Ascent, Descent, CapHeight, XHeight
StemV / StemH
ItalicAngle
Flags (serif, script, italic, fixed-pitch, symbolic, etc.)
FontBBox
Encoding / ToUnicode map details and completeness
Font program type (Type1, TrueType, Type0/CID, Type3)

Why this peels rules:
You can normalize size and baseline to the font’s own metrics (e.g. size / XHeight or size / CapHeight) instead of relying only on body-modal size ratios and absolute thresholds. This makes regime discovery (body / script / display / heading) far more robust across documents and reduces the need for many of the current size-ratio and bold-tail special cases. It also gives a cleaner signal for math isolation when the font-role store is incomplete (cmbright-style cases).
2. Path geometry — currently the most under-exploited for math
Your current paths.jsonl keeps bbox + stroked/filled + simple rule tags. PdfPig can give you the full path construction:

Exact command sequence (m, l, c, v, y, re, h, …)
All control points and curve types
Graphics state at paint time (line width, dash pattern, join, cap, colors)

High-value derived relations:

Path–glyph incidence / proximity: “this horizontal rule sits under a run of glyphs at a consistent distance and length” → strong fraction-bar candidate.
Glyphs enclosed between two parallel horizontal rules → matrix / cases / array candidate.
Vertical rules + aligned glyphs → possible delimiters or matrix columns.
Closed rectangular paths containing regularly spaced glyphs.

This is pure geometric evidence. It lets you generate competing 2-D assembly hypotheses instead of only flagging needs_2d_assembly after the fact. The residual packet then carries the actual geometric competitors rather than a broken surface + a flag. That is one of the cleanest ways to shrink residual size and reduce reliance on later rules or agent invention.
3. Derived relational and multi-scale features (the real rule-peeling power)
These are computed from the richer substrate and stay firmly in the perception layer:

Alignment graphs
Edges between glyphs for: shared baseline (within tight tolerance), shared left/right edge, vertically stacked within size ratio, common x-center, etc. These become the backbone for both reading-order witnesses and 2-D structure candidates.
Baseline-flow / trajectory features
Sequence of baseline deltas and orientations along candidate reading orders. Excellent second witness for reading order (and for detecting when RecursiveXYCut is wrong).
Local density and whitespace fields at multiple scales
Useful for column detection, figure vs text separation, and math region isolation.
Configuration signatures
Vectors of (font-metric-normalized size, weight/flags, family, local density, position relative to body mode, rendering mode consistency, nearby path density). These are the natural input for style-palette recovery / mixture models / hierarchical clustering — exactly the redesign direction in DESIGN.md §1.3. This is how you move from “line-level decision ladder” to “configuration-level role assignment.”
Persistence / multi-scale stability
How stable a cluster or alignment is across a range of distance or density parameters. Directly supports the competing-hypotheses approach and gives a natural confidence/margin signal.
Spacing anomalies
Large advances, overlapping glyphs, unusually tight or loose character spacing — often diagnostic of math or special layout.

4. How this maps to peeling specific rule classes













































Current rule-heavy areaWhat richer substrate enablesPotential reduction in rulesSize/bold tier ladder for headingsFont-metric-normalized features + configuration signatures + palette recoveryLargeMath vs prose isolationFont metrics + local density + path proximity + rendering modeMedium–LargeScript attachment ratiosMore precise baseline segments + font metricsMediumFraction / 2-D detectionFull path commands + path–glyph topology → competing hypothesesLargeReading orderBaseline-flow graphs as second witnessMediumFurniture / invisible textTextRenderingMode + near-edge + densityMediumSome caption / cue rulesStronger geometric attachment + densitySmall–Medium
The irreducible stores (symbol maps, producer-map, core caption cues) stay. Almost everything else that is currently a long decision ladder or threshold list becomes a candidate for “discover candidates + witnesses + margins → residual only when truly ambiguous.”
Recommended enrichment order

Immediate (low effort, high return)
Project FontDetails metrics, TextRenderingMode, Fill/StrokeColor, GlyphRectangleLoose, StartBaseLine/EndBaseLine, PointSize into letters.jsonl.
Next
Upgrade paths to carry full command sequences + control points (or a compact topological summary).
Then
Build the derived graphs and configuration features that feed palette recovery and competing 2-D hypotheses.

This stays strictly inside perception. Interpretation still happens downstream with explicit uncertainty. You simply give the discovery and residual stages much better evidence, so fewer rules are required to force decisions.
Would you like me to sketch concrete additional fields for the next version of letters.jsonl and paths.jsonl, or go deeper on how the alignment graph + path–glyph topology would generate competing 2-D math hypotheses?and speaking of which, the pdfpig substrate offers a variety of different like you say, and i would want to use those in clustering. I haven't written it but i have a secondary HDBSCAN clustering approach in the works for symbolic feature. one of the things im trying to do is delineate all of the features i might be able to use or engineer, and use in clustering to different ends towards the end goalYes. Here’s a practical feature catalog organized for clustering work, especially your secondary (symbolic/typographic) HDBSCAN and multi-view discovery toward the measurement IR.
I group features by the end they primarily serve, then list the most useful atomic + engineered signals in each group. You can mix them; many features serve multiple goals.

1. Style-Palette / Regime Discovery
(body, script, display, heading configurations, math-font clusters)
This is the highest-leverage clustering target for peeling the current size/bold ladders.
Atomic (per glyph)

Font-metric-normalized size: size / XHeight, size / CapHeight, size / Ascent, size / body_mode
Font family / name (hashed or embedded)
Font Flags (serif, script, italic, symbolic, fixed-pitch)
StemV / weight proxy
ItalicAngle + bbox-vs-advance discrepancy (slant proxy)
TextRenderingMode + Fill/StrokeColor
PointSize vs internal FontSize

Engineered / local

Configuration signature vector: (normalized size, weight, family embedding, local density, vertical position relative to body mode, rendering-mode consistency)
Multi-scale local density (glyphs in several ε-balls)
Recurrence / frequency of the same signature on the page or document

Natural methods: HDBSCAN or Gaussian mixture / hierarchical clustering on the configuration vectors. Cluster configurations, then assign roles to them via relational grammar + witnesses (outline, position, alternation with body).

2. Math vs Prose Isolation
(which glyphs belong to the math register)
Atomic

Font-role prior (from store) + Font Flags / family
Unicode category / script (Math Symbol, Letter, Number, etc.)
Is-operator-like / is-delimiter heuristics (lightweight, from Unicode or small table)
RenderingMode (stroked operators are common)
Normalized size relative to body

Engineered / relational

Local density of math-candidate glyphs
Distance to nearest horizontal path (fraction-bar proximity)
Alignment strength with neighboring math-like glyphs
Baseline offset distribution within a small window
Color / rendering-mode consistency within the local neighborhood

Natural methods: Secondary HDBSCAN on the symbolic feature vector, or a joint clustering that mixes typographic + geometric features. Can also be used as a soft prior for the main regime clustering.

3. 1.5-D Script Attachment & Simple Structure
(sub/superscripts, limits on operators)
Atomic

Baseline y (absolute + relative to local median or parent candidate)
Size ratio to nearest larger glyph above/below
Horizontal overlap or center-distance to candidate base
Advance width / size ratio

Engineered

Vertical stack score = f(size ratio, baseline delta, horizontal proximity)
Shared-x or center-alignment strength
Nesting depth proxy (recursive size-tier descent already exists; clustering can propose candidates)

Natural methods: Local pairwise or small-group clustering / graph edges that become script-attachment candidates. These feed the existing recursive assembler or become competing hypotheses.

4. Competing 2-D Assemblies
(fractions, matrices, cases, aligned blocks, radicals)
This is where full path geometry + relational features pay off most.
Path features

Full command sequence or summary (horizontal rule, vertical rule, closed rect, curve complexity)
Length, orientation, line width, dash
Exact control points (for precise topology)

Path–glyph relational

Distance from glyph baseline to nearest horizontal path
Containment: glyph inside path-bounded region
Glyphs lying between two parallel horizontal rules
Vertical alignment of glyphs with vertical rules or delimiters
Local path density around a glyph or run

Glyph relational (within candidate region)

Horizontal / vertical alignment graphs
Regular spacing / gridness score
Multi-scale density or persistence features of the local point cloud

Natural methods:

Hierarchical clustering or HDBSCAN on local glyph + path features inside candidate regions
Generate a small set of competing partitions (single display, fraction, matrix rows, etc.) rather than a single answer
Persistence diagrams for scale-stable components

These competing hypotheses become the content of richer residual packets.

5. Reading-Order & Layout Witnesses
Features

Baseline trajectory (sequence of baseline deltas and orientations)
Shared-baseline strength along a candidate order
Left-edge / column-band clustering
Whitespace corridor features
Continuity score of a proposed reading order (how well baselines and advances flow)

Natural methods: Graph-based or secondary clustering that produces an alternative reading-order claim. Disagreement with RecursiveXYCut becomes a flag + residual, exactly as the constitution wants (witnesses over silent arbitration).

6. Supporting / Confidence Features
(useful across clusterings and for the measurement IR)

Local density at multiple scales
Isolation / outlier score of a glyph relative to its cluster
Stability of cluster membership across a range of HDBSCAN parameters (or distance thresholds) → natural margin / confidence signal
Rendering-mode and color consistency within a putative region
Font-metric completeness (missing XHeight/CapHeight is itself a signal)


Practical notes for your secondary HDBSCAN
For the symbolic/typographic HDBSCAN you are planning, a strong starting feature vector per glyph (or per small run) is:
text[
  size / body_mode,
  size / XHeight (or CapHeight),
  baseline_offset_from_local_median,
  advance / size,
  font_family_embedding or hash,
  font_flags_vector,
  stemV_normalized,
  rendering_mode_onehot,
  local_density_ε1, local_density_ε2,
  dist_to_nearest_horizontal_path,
  unicode_category_features,
  is_math_font_prior
]
You can run this:

On all glyphs → regime / palette discovery
On math-candidate glyphs only → finer internal structure
With different distance metrics or after a learned embedding if the raw space is awkward

The geometric (path-based) HDBSCAN you already have for figures and the symbolic one become complementary views. Agreement is silent confirmation; disagreement or low-stability clusters become residuals or competing hypotheses.

Suggested prioritization for implementation

Project the easy atomic enrichments into letters.jsonl (FontDetails metrics, RenderingMode, colors, loose rect, baseline segments).
Define the symbolic feature vector above and run the secondary HDBSCAN for regime discovery.
Add path–glyph relational features next — this unlocks the competing 2-D hypothesis generator.
Build the alignment / baseline-flow graphs as witnesses.
Only then decide which remaining ladders can be thinned or removed.

This keeps everything inside perception, gives clustering real signal to work with, and directly improves the quality of the chunks that reach the measurement IR (higher accepted fraction, more informative residuals, lower false-confidence).
Would you like me to turn any of these groups into a more formal feature specification (field names, normalization, distance considerations) for the secondary HDBSCAN, or sketch how the competing 2-D hypotheses would be represented as residual packets?