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

## Next (stage 1, not started)

1. Cluster-relative feature emitter: per line — mode id, mode rank by size, mode
   frequency, deviation-from-centroid, membership; plus gap/em to prev line, indent.
2. Oracle alignment → role labels on latex-covered gauntlet papers ({slug}-latex.md
   headings/math spans vs pig nodes).
3. Train role trees (heading/body/caption/reference/display-math/figure-text); eval
   two-population style vs pig `type` heuristics; feature importances answer whether
   IsBold/thickness/gap actually carry signal.
4. Transition-matrix count + Viterbi decode; measure heading-sequence legality lift.
