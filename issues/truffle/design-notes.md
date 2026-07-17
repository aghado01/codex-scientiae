# truffle — semi-supervised typographic role classification (design notes)

*2026-07-17. Ideation thread + stage-0 falsifier. Working name: truffle (a pig using
trees to root out buried structure).*

## Concept

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

## Engine decision (locked 2026-07-17): dep-free C# XGBoost, sibling to hdbscan

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
  byte-identical model.json).

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

## Stage 1 (on unblock)

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
