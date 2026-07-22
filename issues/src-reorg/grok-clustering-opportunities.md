**Yes. There is substantial headroom in the PdfPig substrate that you are not yet fully exploiting.**

The current `letters.jsonl` already captures a good baseline, but PdfPig (and the content stream underneath it) exposes more geometric, metric, and graphics-state signal that can turn several classes of hard-coded rules into discovery or strong geometric evidence.

Here is a concrete inventory, ordered by leverage for peeling rules.

### 1. Richer per-glyph / letter signals (easy wins to project first)

PdfPig’s `Letter` already gives you more than most people use:

- **StartBaseLine / EndBaseLine** — the actual baseline _segment_, not a single y-value. This is better for rotation, slant, and building precise baseline-flow graphs.
- **GlyphRectangleLoose** — uses the font’s Ascent/Descent instead of the tight ink bbox. More consistent across a font and better for vertical regime detection.
- **PointSize** vs the internal `FontSize`.
- **TextRenderingMode** (Fill, Stroke, FillThenStroke, Invisible, Clip variants, etc.).
- Separate **FillColor** and **StrokeColor**.
- **TextOrientation** and **TextSequence** (order of ShowText operations).

**FontDetails / IFont (via GetFont())** is the biggest under-used source:

- Ascent, Descent, CapHeight, XHeight
- StemV / StemH
- ItalicAngle
- Flags (serif, script, italic, fixed-pitch, symbolic, etc.)
- FontBBox
- Encoding / ToUnicode map details and completeness
- Font program type (Type1, TrueType, Type0/CID, Type3)

**Why this peels rules:**
You can normalize size and baseline _to the font’s own metrics_ (e.g. size / XHeight or size / CapHeight) instead of relying only on body-modal size ratios and absolute thresholds. This makes regime discovery (body / script / display / heading) far more robust across documents and reduces the need for many of the current size-ratio and bold-tail special cases. It also gives a cleaner signal for math isolation when the font-role store is incomplete (cmbright-style cases).

### 2. Path geometry — currently the most under-exploited for math

Your current `paths.jsonl` keeps bbox + stroked/filled + simple rule tags. PdfPig can give you the full path construction:

- Exact command sequence (m, l, c, v, y, re, h, …)
- All control points and curve types
- Graphics state at paint time (line width, dash pattern, join, cap, colors)

**High-value derived relations:**

- Path–glyph incidence / proximity: “this horizontal rule sits under a run of glyphs at a consistent distance and length” → strong fraction-bar candidate.
- Glyphs enclosed between two parallel horizontal rules → matrix / cases / array candidate.
- Vertical rules + aligned glyphs → possible delimiters or matrix columns.
- Closed rectangular paths containing regularly spaced glyphs.

This is pure geometric evidence. It lets you _generate_ competing 2-D assembly hypotheses instead of only flagging `needs_2d_assembly` after the fact. The residual packet then carries the actual geometric competitors rather than a broken surface + a flag. That is one of the cleanest ways to shrink residual size and reduce reliance on later rules or agent invention.

### 3. Derived relational and multi-scale features (the real rule-peeling power)

These are computed from the richer substrate and stay firmly in the perception layer:

- **Alignment graphs**
  Edges between glyphs for: shared baseline (within tight tolerance), shared left/right edge, vertically stacked within size ratio, common x-center, etc. These become the backbone for both reading-order witnesses and 2-D structure candidates.

- **Baseline-flow / trajectory features**
  Sequence of baseline deltas and orientations along candidate reading orders. Excellent second witness for reading order (and for detecting when RecursiveXYCut is wrong).

- **Local density and whitespace fields** at multiple scales
  Useful for column detection, figure vs text separation, and math region isolation.

- **Configuration signatures**
  Vectors of (font-metric-normalized size, weight/flags, family, local density, position relative to body mode, rendering mode consistency, nearby path density). These are the natural input for style-palette recovery / mixture models / hierarchical clustering — exactly the redesign direction in DESIGN.md §1.3. This is how you move from “line-level decision ladder” to “configuration-level role assignment.”

- **Persistence / multi-scale stability**
  How stable a cluster or alignment is across a range of distance or density parameters. Directly supports the competing-hypotheses approach and gives a natural confidence/margin signal.

- **Spacing anomalies**
  Large advances, overlapping glyphs, unusually tight or loose character spacing — often diagnostic of math or special layout.

### 4. How this maps to peeling specific rule classes

| Current rule-heavy area            | What richer substrate enables                                                 | Potential reduction in rules |
| ---------------------------------- | ----------------------------------------------------------------------------- | ---------------------------- |
| Size/bold tier ladder for headings | Font-metric-normalized features + configuration signatures + palette recovery | Large                        |
| Math vs prose isolation            | Font metrics + local density + path proximity + rendering mode                | Medium–Large                 |
| Script attachment ratios           | More precise baseline segments + font metrics                                 | Medium                       |
| Fraction / 2-D detection           | Full path commands + path–glyph topology → competing hypotheses               | Large                        |
| Reading order                      | Baseline-flow graphs as second witness                                        | Medium                       |
| Furniture / invisible text         | TextRenderingMode + near-edge + density                                       | Medium                       |
| Some caption / cue rules           | Stronger geometric attachment + density                                       | Small–Medium                 |

The irreducible stores (symbol maps, producer-map, core caption cues) stay. Almost everything else that is currently a long decision ladder or threshold list becomes a candidate for “discover candidates + witnesses + margins → residual only when truly ambiguous.”

### Recommended enrichment order

1. **Immediate (low effort, high return)**
   Project FontDetails metrics, TextRenderingMode, Fill/StrokeColor, GlyphRectangleLoose, StartBaseLine/EndBaseLine, PointSize into `letters.jsonl`.

2. **Next**
   Upgrade paths to carry full command sequences + control points (or a compact topological summary).

3. **Then**
   Build the derived graphs and configuration features that feed palette recovery and competing 2-D hypotheses.

I group features by the **end they primarily serve**, then list the most useful atomic + engineered signals in each group. You can mix them; many features serve multiple goals.

---

### 1. Style-Palette / Regime Discovery

_(body, script, display, heading configurations, math-font clusters)_
This is the highest-leverage clustering target for peeling the current size/bold ladders.

**Atomic (per glyph)**

- Font-metric-normalized size: `size / XHeight`, `size / CapHeight`, `size / Ascent`, `size / body_mode`
- Font family / name (hashed or embedded)
- Font Flags (serif, script, italic, symbolic, fixed-pitch)
- StemV / weight proxy
- ItalicAngle + bbox-vs-advance discrepancy (slant proxy)
- TextRenderingMode + Fill/StrokeColor
- PointSize vs internal FontSize

**Engineered / local**

- Configuration signature vector: (normalized size, weight, family embedding, local density, vertical position relative to body mode, rendering-mode consistency)
- Multi-scale local density (glyphs in several ε-balls)
- Recurrence / frequency of the same signature on the page or document

**Natural methods**: HDBSCAN or Gaussian mixture / hierarchical clustering on the configuration vectors. Cluster _configurations_, then assign roles to them via relational grammar + witnesses (outline, position, alternation with body).

---

### 2. Math vs Prose Isolation

_(which glyphs belong to the math register)_

**Atomic**

- Font-role prior (from store) + Font Flags / family
- Unicode category / script (Math Symbol, Letter, Number, etc.)
- Is-operator-like / is-delimiter heuristics (lightweight, from Unicode or small table)
- RenderingMode (stroked operators are common)
- Normalized size relative to body

**Engineered / relational**

- Local density of math-candidate glyphs
- Distance to nearest horizontal path (fraction-bar proximity)
- Alignment strength with neighboring math-like glyphs
- Baseline offset distribution within a small window
- Color / rendering-mode consistency within the local neighborhood

**Natural methods**: Secondary HDBSCAN on the symbolic feature vector, or a joint clustering that mixes typographic + geometric features. Can also be used as a soft prior for the main regime clustering.

---

### 3. 1.5-D Script Attachment & Simple Structure

_(sub/superscripts, limits on operators)_

**Atomic**

- Baseline y (absolute + relative to local median or parent candidate)
- Size ratio to nearest larger glyph above/below
- Horizontal overlap or center-distance to candidate base
- Advance width / size ratio

**Engineered**

- Vertical stack score = f(size ratio, baseline delta, horizontal proximity)
- Shared-x or center-alignment strength
- Nesting depth proxy (recursive size-tier descent already exists; clustering can propose candidates)

**Natural methods**: Local pairwise or small-group clustering / graph edges that become script-attachment candidates. These feed the existing recursive assembler or become competing hypotheses.

---

### 4. Competing 2-D Assemblies

_(fractions, matrices, cases, aligned blocks, radicals)_
This is where full path geometry + relational features pay off most.

**Path features**

- Full command sequence or summary (horizontal rule, vertical rule, closed rect, curve complexity)
- Length, orientation, line width, dash
- Exact control points (for precise topology)

**Path–glyph relational**

- Distance from glyph baseline to nearest horizontal path
- Containment: glyph inside path-bounded region
- Glyphs lying between two parallel horizontal rules
- Vertical alignment of glyphs with vertical rules or delimiters
- Local path density around a glyph or run

**Glyph relational (within candidate region)**

- Horizontal / vertical alignment graphs
- Regular spacing / gridness score
- Multi-scale density or persistence features of the local point cloud

**Natural methods**:

- Hierarchical clustering or HDBSCAN on local glyph + path features inside candidate regions
- Generate a _small set of competing partitions_ (single display, fraction, matrix rows, etc.) rather than a single answer
- Persistence diagrams for scale-stable components

These competing hypotheses become the content of richer residual packets.

---

### 5. Reading-Order & Layout Witnesses

**Features**

- Baseline trajectory (sequence of baseline deltas and orientations)
- Shared-baseline strength along a candidate order
- Left-edge / column-band clustering
- Whitespace corridor features
- Continuity score of a proposed reading order (how well baselines and advances flow)

**Natural methods**: Graph-based or secondary clustering that produces an alternative reading-order claim. Disagreement with RecursiveXYCut becomes a flag + residual, exactly as the constitution wants (witnesses over silent arbitration).

---

### 6. Supporting / Confidence Features

_(useful across clusterings and for the measurement IR)_

- Local density at multiple scales
- Isolation / outlier score of a glyph relative to its cluster
- Stability of cluster membership across a range of HDBSCAN parameters (or distance thresholds) → natural margin / confidence signal
- Rendering-mode and color consistency within a putative region
- Font-metric completeness (missing XHeight/CapHeight is itself a signal)

---

### Practical notes for your secondary HDBSCAN

For the **symbolic/typographic HDBSCAN** you are planning, a strong starting feature vector per glyph (or per small run) is:

```
[
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
```

You can run this:

- On all glyphs → regime / palette discovery
- On math-candidate glyphs only → finer internal structure
- With different distance metrics or after a learned embedding if the raw space is awkward

The geometric (path-based) HDBSCAN you already have for figures and the symbolic one become complementary views. Agreement is silent confirmation; disagreement or low-stability clusters become residuals or competing hypotheses.

---

### Suggested prioritization for implementation

1. **Project the easy atomic enrichments** into `letters.jsonl` (FontDetails metrics, RenderingMode, colors, loose rect, baseline segments).
2. **Define the symbolic feature vector** above and run the secondary HDBSCAN for regime discovery.
3. **Add path–glyph relational features** next — this unlocks the competing 2-D hypothesis generator.
4. **Build the alignment / baseline-flow graphs** as witnesses.
5. Only then decide which remaining ladders can be thinned or removed.
