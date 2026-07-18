# truffle — document-local typographic role lane (design notes)

*2026-07-17. Ideation thread + stage-0 falsifier. Working name: truffle (a pig using
trees to root out buried structure).*

> **⚠ READING ORDER (both-roads-live fix, 2026-07-17):** this document contains BOTH the
> original supervised architecture (§Concept, next — **SUPERSEDED**, retained solely as the
> predeclared fallback spec) and the current road (§RESCOPE 2026-07-17, further revised by
> [the Sol closing-the-gap discussion](../pdfdig-lane/sol-closing-the-gap-discussion.md):
> **Stage 1 = a role-boundary PROBE, not a classifier**; CART-on-mode-labels rejected;
> per-document completer CART only from role anchors under resampling stability). Read
> §RESCOPE first. Doctrine home for the typographic layer:
> [../typography/typography-in-pdf-conversion.md](../typography/typography-in-pdf-conversion.md).

## Concept — ORIGINAL SUPERVISED ARCHITECTURE (SUPERSEDED; fallback spec only)

Gradient-boosted trees (XGBoost/LightGBM-class) over the pig IR's line-level typographic
features, wrapped in a semi-supervised harness where the unsupervised layer supervises the
supervised one — the spike-sorting pattern (SPC cores seed GMM completion) retargeted at
type. Division of labor:

- **HDBSCAN per document** = SW/SPC core-finder (both are persistence constructions:
  temperature filtration ≈ lambda filtration; membership probability ≈ two-point
  correlation). Canonicalizes each document's typography into modes; the GMM-completion
  role is already inside HDBSCAN's membership gradient — free.
- **Trees** = the genuinely new tier: carry labels *across* documents into a richer
  feature space (cluster-relative features, gap/em, baseline shift). NOT the completer —
  discriminative learners trained on cores extrapolate hard; sample-weight by membership,
  give an explicit abstain/noise class fed by HDBSCAN −1.
- **LaTeX oracle** = auto-labeler (align pig output to oracle ground truth → line roles,
  space/no-space, math spans) + active-learning budget spent on boundary/disagreement
  points, not cores. Also novelty detector: a document whose mode geometry matches nothing
  in training = out-of-distribution, abstain at document level.
- **Sequence tier**: trees emit per-line posteriors; a Viterbi/linear-chain decode over
  oracle-counted transition matrix enforces legal role sequences (kills H1→H3 illegal
  jumps = the heading over-promotion pathology). Reading order is a *backbone* —
  this is backbone-conditioned persistence, structural edition.
- **Doctrine**: cluster layer can VETO classifier assertions (never assert figure-hood);
  disagreement → work-list JSONL for human review; every model artifact gates against the
  gauntlet; the irreducible residue (run-in headings, XeLaTeX unicode-math without CM font
  flags) is the membrane's semantic territory — route, don't guess.
- **Deployment shape**: train offline, dump ensemble to JSON, walk with a ~100-line
  dependency-free C# evaluator (hashish-style) or transpile to generated source. No ML
  runtime ships. Monotone constraints (e.g. P(heading) non-decreasing in size) bake
  typographic priors into the learned model.

## Stage-0 falsifier — RESULT: HOLDS

Predeclared claim: per-document typographic clusters are crisp and stably separable (the
"superparamagnetic window" for type). If mush → re-scope to raw-feature trees.

Probe: `probes/typographic-modes-calib.ps1` (iteration record in header). 6 papers,
4 corpora (ph-zigzag, voroninski, spc/Domany1999 = 1990s typography, kisungyou), newest
pig runs, hdbscan.exe euclidean over intrinsic line typography.

- **Crisp**: v2 (size + style axes): noise 0.1–3.1%, membership ≈ 1.000, 9–24 modes/doc.
- **Plateau**: wide SPC-style windows at the mode count (log10-widths 0.22–0.78; best:
  c=24 stable across d 0.10→0.60pt on 2111.15058v3).
- **Two-scale structure**: micro = font|size tuples (v1 with thickness: purity 0.92–0.995
  but 2–4x over-resolved by thickness micro-quantization), macro = role-shaped modes
  (v2: body roman / math italic / CMBX heading material / CMR8 footnote / tiny
  sans figure-axis labels / rotated arXiv stamp). Condensed tree carries both levels.
- **Modes ≠ roles** (pig-type NMI 0.02–0.11): unsupervised canonicalizes, doesn't
  classify — the supervised layer is necessary, as designed.
- Thickness: drop from clustering, keep as downstream display-math signal.

## Engine decision (2026-07-17): dep-free C# XGBoost, sibling to hdbscan

> **SUPERSEDED in its RUNTIME role, same day — see §Rescope below.** The converter is
> unsupervised-in-spirit; a persistent trained model conflicts. This section is retained
> as the governing spec IF a runtime supervised tier is ever re-justified (the
> §Rescope records the fallback trigger). Until then `xgboost.exe` is NOT built;
> any offline adjudication uses reference tooling (never shipped).

A from-scratch XGBoost-style GBDT engine as a **second C# project under the repo build
convention** — the exact shape hdbscan proved out:

- Source `src/xgboost/` (post-reorg: `src/boost/`, functional-named like `cluster/`),
  thin csproj `projects/xgboost/`, `scripts/build-xgboost.ps1` → `bin/xgboost/xgboost.exe`,
  namespace `CodexSci.Xgboost`, PS wrapper `Invoke-Xgboost.ps1`. Zero runtime deps —
  no ML.NET, no native libs; System.Text.Json only (same posture as hdbscan.exe).
- **One CLI, two verbs**: `train` (CSV/JSONL in → model.json + eval report) and `score`
  (model.json + rows in → per-class posteriors + abstain margin). model.json = the full
  dumped ensemble — versioned, diffable, auditable; committed alongside the calibration
  that produced it and gated like any knob.
- Algorithm scope v1: exact-greedy splits (corpus is small; histogram method deferred),
  softmax multiclass, second-order objective, L1/L2 + min-child-weight regularization,
  **monotone constraints** (the principled-priors bridge, e.g. P(heading) non-decreasing
  in size-rank), per-instance **sample weights** (membership-probability discounting),
  early stopping on a held-out corpus split.
- **Trust harness mirrors hdbscan's**: unit harness `tests/xgboost/Program.cs` pinning
  behavior against reference fixtures (agreement with the reference xgboost
  implementation on canned tabular sets, same posture as the sklearn-pinned evaluators),
  Pester e2e `tests/xgboost.Tests.ps1` driving the CLI; determinism test (same input →
  byte-identical model.json — train twice, hash both).

### Implementation notes (adopted from gemini-notes.md, WITH corrections)

External review ([gemini-notes.md](gemini-notes.md) — notes, not spec) proposed a skeleton;
the following is the adopted subset with the four corrections that make it spec-grade:

- **Tree = flat contiguous struct array, primitive-only traversal** (adopted verbatim —
  matches the hdbscan house style: dense ids, index children, `-1` sentinel leaves).
  Scorer walks `features[node.FeatureIndex] < node.SplitValue` with `<` semantics
  IDENTICAL between trainer and scorer; split thresholds stored at full double precision
  (a float midpoint `(a+b)/2` can collapse onto an operand and re-route boundary rows).
- **Exact-greedy split search** (adopted; corpus is small) but NOT via per-node
  `Array.Sort` with a lambda: .NET introsort is UNSTABLE, so tied feature values
  enumerate nondeterministically → floating-point accumulation order shifts → near-tie
  splits flip → byte-identical breaks at the TRAINING layer. Correct substrate:
  column-major pre-sorted index lists built once (tiebreak by instance index —
  mandatory, not a nicety), filtered per node.
- **Accumulators are `double`, fixed scalar order** — gradient/hessian sums G/H/GL/HL
  never float, never SIMD-reduced (or partitioned deterministically). Feature STORAGE
  may stay float; sums and leaf weights may not.
- **Monotone constraints via [lower, upper] bound propagation down the tree** — the
  review's sibling-weight comparison at split time is insufficient (a constraint honored
  at depth 2 can be violated at depth 5); propagate bounds, clamp/reject at every split.
  ~10 lines, structural.
- **Sample weights fold into the gradients** (adopted verbatim: multiply g_i/h_i by
  weight before accumulation — the membership-probability discount costs nothing).
- **Softmax multiclass = K trees per boosting round**, gradients from cross-entropy vs
  the current ensemble's softmax (adopted verbatim).
- **No missing-value default direction in v1** — truffle features are dense by
  construction; sparsity-aware routing is scope creep until a feature needs it.

### Determinism contract (model.json is an archival record, not a cache)

Byte-identical = two stacked guarantees; training is the hard half, serialization the
easy one:

1. **Training determinism by construction**: stable sorts w/ index tiebreaks; fixed-order
   double accumulation; no parallel float reductions; v1 OMITS row/column subsampling so
   no RNG exists to seed (the Workflow no-`Date.now()` posture: nondeterminism excluded,
   not patched).
2. **Serialization determinism by discipline**: no reflection-defaults — `Utf8JsonWriter`
   in explicit field order; arrays only (no dictionary enumeration order); doubles via
   .NET shortest-round-trip (culture-invariant); no indentation variance; UTF-8 no BOM;
   NO embedded timestamps — provenance is injected into a header block, never sampled.
3. **Provenance header, house idiom**: content hash + engine version + train-set
   signature — the `.sig`/sha256-fail-loud family the pig IR and toc design already use;
   `score` verifies loud on mismatch. Principle: a trained model asserts "this exact
   input produced this exact artifact," and gauntlet gating / drift detection / rollback
   all depend on that being checkable. Same requirement the SPCX archivory/SPRED threads
   are circling — convergence noted, implementations deliberately SEPARATE (house idiom
   here; any unification is a future explicit SPCX import decision, not a dependency
   drifting in through truffle).

## Integration map

One IR, two orthogonal cluster embeddings, one supervision hub, one backbone primitive:

- **convert (pig IR)** — substrate and first customer. nodes.jsonl feeds the emitter;
  role posteriors flow back as (a) the deferred heading-over-promotion ENGINE guard (the
  IR-role signal that retires the post-hoc md-repair regex), (b) `known_role_frac`
  upgraded from health signal to calibrated coverage, (c) eventually digit-role for the
  C# Markpig.Pdf frontier (truffle prototypes PS-side here, distills across later).
- **cluster (hdbscan.exe)** — unchanged engine, second embedding. Figure lane clusters
  page-geometry; truffle clusters typography. Per-doc mode discovery = the
  canonicalization stage (cluster-relative features are what the trees see; raw pt never
  crosses documents). Future shared artifact: bagged-HDBSCAN co-association matrix =
  soft affinity graph = the same object the SPCX diffusion-coupling refiner consumes.
- **figure lane (gauntlet)** — mutual cross-feed, veto direction preserved. Stage-0's
  tiny-sans modes (DejaVu/Helvetica/Arial 4–6.5pt) give a per-document figure-text
  typography prior (vs letters-calib's absolute cuts) → candidate V_letters
  strengthening AFTER the A3/D fork lands, never mid-probe. Reverse: settled figure
  regions label lines as figure-text for training. Two views (geometry, typography)
  co-train at lane granularity.
- **membrane / latex oracle** — supervision hub. The aligner is the SECOND consumer of
  D-0's text-anchor idiom (build once: D-0 aligns oracle→glyph-clusters for figure
  truth; truffle aligns oracle→nodes for role truth). Oracle also prices the
  active-learning budget (spend on boundary/disagreement, cores come free) and anchors
  document-level novelty detection (mode geometry unlike training manifold → OOD,
  abstain at paper granularity). Residue routing: genuinely semantic ambiguity (run-in
  headings, XeLaTeX unicode-math with no CM font signal) → membrane tier, flagged not
  guessed.
- **gauntlet battery** — every model artifact is an increment: gates via the standard
  two-population comparison, drift in a retrained model surfaces as battery regression.
  Disagreement/abstain lines emit to work-list JSONL (promotion-candidates pattern;
  machine never promotes).
- **PH backbone** — reading order is a structural backbone; the Viterbi tier (tree
  emissions × oracle-counted transition matrix) is backbone-conditioned persistence,
  structural edition — first production instance of the flagship primitive, low-stakes
  rehearsal for the neural-manifold work. The condensed tree's two-scale structure
  (tuples ⊂ role modes) is itself the persistence object stage-0 verified.

## Sequencing (locked 2026-07-17): wait for the fork, prep the layout

Stage 1 GATES on: (1) the clustering frontier's A3/D fork resolving battery-green
(predeclared rule stands — truffle does not preempt it), (2) the src-reorg module
skeleton (truffle files land in their module home, not pre-move src/). Rationale +
placeholder layout: reorg-plan.md target tree (`boost/`, `truffle/`). Expected wait is
short (frontier estimates the fork at an afternoon + one bounded implementation).
Meanwhile truffle costs nothing parked: stage-0 verdict locked in the probe header,
oracle coverage verified (66 gauntlet `-latex.md` papers: 10/10 ph-zigzag, 22
voroninski, 23 kisungyou, 9 mapper, 0 spc — spc is the transport/OOD corpus).

## Stage 1 as originally scoped (superseded by §Rescope — kept for the record)

1. Cluster-relative feature emitter (`truffle/emit-features`): per line — mode id, mode
   rank by size, mode frequency, deviation-from-centroid, membership; plus gap/em to
   prev line, indent, page position; thickness re-enters HERE (display-math signal),
   not in clustering.
2. Oracle alignment (`truffle/align-oracle`, extends D-0 idiom) → role labels on the
   latex-covered gauntlet papers ({slug}-latex.md headings/math spans vs pig nodes).
3. `xgboost.exe` v1 + trust harness; train role trees
   (heading/body/caption/reference/display-math/figure-text/furniture); eval
   two-population vs pig `type` baseline; feature importances adjudicate
   IsBold/thickness/gap empirically.
4. Transition-matrix count + Viterbi decode (`truffle/decode-viterbi`); measure
   heading-sequence legality lift on the battery.

## The transfer question (2026-07-17, user-raised) — recorded as context for the rescope

The SPC→GMM coupling in the user's spike-sorting work was TRANSIENT per run — correctly,
because neuron identities are run-scoped (nothing exists for a persistent model to be a
model OF) and no external supervision existed. Typographic ROLES do share identity
across documents and the oracle does exist, so cross-document transfer is *possible*
here — but possible ≠ wanted (see §Rescope). Stage-0 validated per-document crispness
only; it says NOTHING about cross-document stability of the role→relative-signature
map. Had the supervised tier proceeded, its predeclared falsifier would have been
**leave-one-corpus-out** eval (pooled random splits leak class-file conventions), with a
**mode-level classifier head as primary** (~15 mode signatures/doc, small transfer
surface — structurally the SPC-GMM shape, persistent knowledge entering only at "which
core is which role") and a line-level head as intra-mode contextual refinement. This
design is the recorded FALLBACK if the unsupervised rescope plateaus below acceptance.

## RESCOPE 2026-07-17: unsupervised-in-spirit — the converter carries no training history

**Constraint (user, doctrine-level):** pdfdig is in spirit unsupervised — each document
processed from its own evidence, no reliance on a history of previous runs. A persistent
trained model introduces irreducible, distribution-dependent modeling uncertainty with
illegible per-case errors; pdfdig exists as the deterministic geometry-primary INVERSE
of VLM-primary tools, and a shipped learned model would re-import a smaller copy of what
was inverted away. Rule: if a role cannot be established from THIS document's data plus
universal typographic convention → **forgo** (abstain → membrane), don't model.

**What survives untouched:** the typography angle itself (stage-0 is a fact about the
DATA, not about any learner), per-document HDBSCAN canonicalization, the condensed
tree's two-scale structure, cluster-relative features, work-list routing, gauntlet
gating, the D-0-idiom aligner (now building VALIDATION labels — see below).

**The per-document arboreal stack (all transient, deterministic, label-free):**

1. **The condensed tree IS the tree method** — already built, already validated; the
   unsupervised hierarchy over typographic space is the primary arboreal object.
2. **Ordinal role priors** — role semantics from UNIVERSAL typographic convention
   (typography's physics, not learned history), expressed over cluster-relative mode
   statistics: body = dominant mode; heading = rarer ∧ (larger ∨ bolder) ∧ precedes-gap
   ∧ sequence-legal; footnote = smaller ∧ page-bottom; caption = adjacent to figure
   region; figure-text = tiny ∧ inside region; furniture = positionally periodic.
   Deterministic constraint-ranking over ~15 modes/doc. These are principled signals in
   the no-magic-strings sense — ordinal and relational, never absolute pt values.
3. **Per-document distilled CART** — the tree-shaped SPC→GMM analog: fit a shallow tree
   to THIS document's own cluster labels, use it to assign stragglers/noise lines to
   modes, emit its rules as the per-document audit record, discard. Transient completer;
   zero transfer; human-readable ("size ≥ 11.9 ∧ bold → mode 7").
4. **Sequence grammar, hand-authored** — the legality automaton is universal document
   grammar (H1→H3 without H2 is illegal STRUCTURE, not statistics); decode enforces
   legality without learned transition weights.
5. **Isolation forest (optional probe)** — per-document, unsupervised by construction:
   continuous line-anomaly scores below/beside the mode structure → work-list routing.
   Small, dep-free-able; candidate not commitment.
6. **RF-proximity (upgrade path only)** — Breiman's unsupervised trick: forest
   discriminates real lines vs marginal-permuted synthetic copy; proximity matrix =
   per-document adaptive similarity, mixed continuous/categorical NATIVE (retires the
   arbitrary FlagWeightPt=2.0 scaling), feeds HDBSCAN — or SPC, since a proximity
   matrix is literally a coupling matrix. Reach for it ONLY if the hand-chosen feature
   space demonstrably falls short (stage-0 says it does not yet).

**Oracle demoted: trainer → VALIDATOR.** The 66 latex-covered papers become the offline
test bench: measure ordinal-rule accuracy per role, per corpus (per-rule confusion +
forgo-rate + membrane-routing rate). Supervision as *evaluation* keeps runtime
unsupervised while quantifying exactly how often "forgo" happens and which rules earn
trust. The aligner (D-0 idiom, second consumer) is UNCHANGED in priority — it now
builds validation labels instead of training labels.

**Fallback trigger (predeclared):** if the ordinal-rule stack plateaus below acceptance
on the oracle bench for a role class where the mode-head transfer design (§above) shows
clean leave-one-corpus-out separation, the supervised tier may be revisited — as an
explicit doctrine decision, not a drift.

**Consequences:** `boost/`/`xgboost.exe` deferred indefinitely (instrument-tier at
most; offline adjudication uses reference tooling, nothing ships). Reorg placeholder
comment updated to match.

## Stage 1 REVISED (on unblock; gates unchanged: A3/D fork + reorg skeleton)

1. Feature emitter (`truffle/emit-features`) — unchanged from original scoping.
2. Oracle aligner (`truffle/align-oracle`, D-0 idiom) — unchanged mechanics; output is
   the VALIDATION bench.
3. Ordinal role rules (`truffle/role-rules`) + validation harness: rule-set accuracy vs
   oracle labels across 66 papers; per-rule confusion, forgo-rate; two-population vs
   pig `type` baseline.
4. Distilled-CART completer probe + hand-authored grammar decode
   (`truffle/decode-grammar`); heading-sequence legality lift on the battery.
5. iForest work-list probe (optional, if residue warrants).
