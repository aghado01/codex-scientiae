# Typography in PDF conversion — the synthesis

**Status: ORIENTATION BRIEF, minted 2026-07-17.** Lifts the typography insights out of the lane
notes where they accumulated — the figure-lane thrust history
([../clustering/tier3-engineering-plan.md](../clustering/tier3-engineering-plan.md)), the truffle
stage-0 falsifier + rescope ([../truffle/design-notes.md](../truffle/design-notes.md)), and the
closing-the-gap discussion ([../pdfdig-lane/sol-closing-the-gap-discussion.md](../pdfdig-lane/sol-closing-the-gap-discussion.md))
— into one statement of what typography IS to this project, what it has measurably delivered, and
the principles that govern its use. The MVP frame this slots into is the cut line: pdfdig =
confidence-bounded document-local converter, parity with the per-document LaTeX oracle in the
pre-publish format.

## §1 — Why typography is central: the surviving channel

A PDF is what remains after a typesetting system consumes semantic structure (headings, captions,
theorems, math, footnotes) and emits positioned glyphs. The semantics are gone; the **typography
that ENCODED them survives intact** — size ladders, weight changes, font switches, spacing
discipline, positional convention. Typography is not a "feature" of the layout problem; it is the
channel through which document structure was transmitted, and therefore the channel through which
it must be re-inferred. pdfdig's identity as the deterministic inverse of the VLM approach rests
on this: the information is *in the file*, put there deliberately by a typesetting system
following near-universal conventions.

Two corollaries:

- **TeX documents are the high-SNR end of the channel.** TeX quantizes (magstep size ladders,
  CM font-family role encoding — CMMI/CMSY/MSBM literally name math roles), so the signal is
  crisp. Office/journal pipelines emit continuous size jitter (the tier_merge_gap discovery:
  specimen 2504.09042 has 18 raw sizes in a 0.4pt band) — same conventions, blurrier channel.
  Producer identity is itself a typographic observable.
- **The oracle side never needs typography** — it has source truth. Typography is precisely the
  bare-PDF substitute for source truth, which is why `known_role_frac` and the mode statistics
  are the oracle-FREE confidence vocabulary (what the spc corpus exercises).

## §2 — What is measured, not hoped

1. **Typographic modes are real, crisp, and document-local** (truffle stage-0 falsifier, PASSED:
   9–24 modes/doc across 6 papers/4 corpora, 0.1–3.1% noise, membership ≈ 1.0, wide stability
   plateaus). Discovery is a solved sub-problem; no further clustering machinery is needed to
   find the modes.
2. **Modes ≠ roles** (same probe: NMI vs pig `type` 0.02–0.11 — modes are FINER than roles).
   "The larger bold mode" does not intrinsically mean H1 vs title vs theorem label. The open
   problem is the mode→role map, not the modes.
3. **Ordinal, em-normalized statistics transport.** The figure lane's knobs — every one a
   relative statistic of a proven species — held out-of-sample untouched (kisungyou first
   transport gate: PRIMARY 1.0, zero overs on confident-oracle papers). This is the empirical
   license for the ordinality principle below.
4. **Typography's assertions fail where its vetoes succeed** — the heading over-promotion bug
   class, the β₁/shape furniture rule (veto), the in-flow backbone (veto), the sequence grammar
   (veto). Thrice-confirmed in the figure lane, now doctrine (§3.3).

## §3 — The four working principles

### 3.1 Ordinality — relative always, absolute never

Typographic convention is ordinal: headings are *larger/rarer than body*, footnotes *smaller*,
captions *styled distinctly from prose*, script glyphs *smaller than base with displaced
baseline*. Absolute values (10pt vs 11pt) are template accidents that do not transport; ordinal
statements are near-universal. Therefore every threshold in every lane is relative: mode rank,
deviation from the body centroid, gaps in em (body-size normalized), page-position quantiles,
size RATIOS (the math assembler's 10/7/5 script ladder is a ratio test). New thresholds enter
only as relative, em-normalized statistics of proven species — the standing protocol clause.

### 3.2 Document-locality — calibrate per document, persist nothing

One document = one author + one template = one consistent typographic regime; across documents
the regimes vary freely. So: body_size calibrated per document; caption style LEARNED from the
paper's own pass-1 claims (`caption_split`'s style guard — "Fig. N" vs "Figure N:" is a
per-document fact); modes discovered per document; any completer tree fit per document and
DISCARDED. Persistent trained models (the XGBoost road) are ruled out on identity grounds:
they import cross-document distribution dependence into a converter whose whole value is
document-self-containment. The oracle serves as offline VALIDATOR of the rules, never as a
runtime trainer.

### 3.3 The claim/veto asymmetry — typography vetoes reliably, asserts weakly

A typographic fact can *kill* an interpretation with near-certainty ("body-sized and
sequence-illegal ⇒ not H1"; "no areal member + β₁=0 + strip-shaped ⇒ furniture"; "covered by the
prose backbone ⇒ not a float") but can rarely *prove* one alone ("bold and large" might be a
heading, a title, an emphasized lead-in). Positive claims require convergent independent
evidence: cue + geometry + learned style for captions; size + rarity + whitespace + outline
corroboration + sequence legality for headings; font-role + baseline structure for math.
Design consequence: build vetoes freely, build assertions only as multi-evidence anchors with
claim/abstain leaves.

### 3.4 The identifiability boundary — typography localizes; it does not adjudicate semantics

Typography's terminal deliverable is not an answer but a well-posed question: candidates
generated, impossibilities vetoed, ambiguity LOCALIZED, evidence packaged. When the remaining
choice requires understanding what the text *means* (run-in heading vs bold paragraph lead,
cue-less caption recognition, intentional-emphasis anomalies), forcing it through more intricate
rules trades transparent abstention for silent false confidence. Those questions route to the
pdfdig resolver (the membrane sibling) as narrow adjudications over the typographic evidence
packet. The stopping rule: push the model-free lane while a measurable PDF-intrinsic signal
remains unspent; stop when the residual is semantic.

## §4 — Where typography already lives in the stack (inventory)

| Lane | Typographic machinery | Trust mode |
|---|---|---|
| Calibration | per-document body_size; heading tier ladders + tier_merge_gap; bold-by-name (IsBold unreliable — font-name `-Medi`/`CMBX` cues) | foundation |
| Figure lane | em-normalization of every knob; V_letters evidence view (≤4em blocks near ink); caption cue+style+geometry attachment; caption_split learned style guard | evidence + veto |
| Math lane | font-role identification (CMMI/CMSY/MSBM); size-ratio script nesting (math-assembler); display-math width/math-frac gates | assertion (high-SNR channel) |
| Structure/headings | tier ladder + outline cross-derivation (confirmation = flag, never gate); heading over-promotion = the cautionary bug class | anchor + veto |
| Furniture | margin-position + orientation (running heads, stamps); periodicity | veto |
| truffle (role lane) | modes → ordinal anchors → sequence-veto grammar → role-boundary probe | the typography-native experiment |
| Parity yardstick | typography-inferred structure scored against source-declared structure (conversion-metric skeleton axis) | measurement |
| Oracle-free health | known_role_frac, mode statistics (the spc/PDF-only corpus's instruments) | confidence vocabulary |

## §5 — Producer fingerprints and channel defects

Typography also identifies the *transmitter*: TeX-origin detection (Producer + CM fonts),
office-pipeline jitter (continuous size bands), Docling's ghost layer (font=null ∧ size=12 =
placeholder, not typography — a channel artifact to be excluded, the promoter fix), old
journal-house producers (the spc corpus's %PDF-1.1 era — the stress case where conventions
predate modern producers). Reading the fingerprint calibrates how much to trust the channel
per document — a future confidence input, already partially operational in classify.json
calibration.

## §6 — What typography must never do

- Assert a role from a single typographic fact (the asymmetry, §3.3).
- Use an absolute threshold (§3.1).
- Carry state across documents (§3.2) — no cached models, no cross-paper style priors.
- Resolve semantic ambiguity by rule intricacy (§3.4) — abstain and route instead.
- Silently guess when the glyph layer itself is absent/corrupt — escalate; never hallucinate.

## §7 — Where it goes next (the cut line, typography's steps)

1. **Truffle Stage 1 = the role-boundary probe** (gated on A3/D + src-reorg skeleton): anchors +
   vetoes over the modes; oracle-validated precision/coverage/abstention per role; residual
   census in four classes. The census IS the typography experiment — it measures exactly where
   §3.4's boundary sits and generates the freeze's acceptance metrics.
2. **Evidence packets**: typographic mode, rank-relative-to-body, stability, and competing
   candidates become the core of the resolver's per-item evidence (the model sees typography's
   *summary*, not raw glyphs).
3. **Parity scoring**: the conversion-metric skeleton axis scores typography-inferred structure
   against the oracle per document — typography's report card, in the pre-publish format.

Everything beyond (learned trees, RF-proximity metrics, isolation scoring, SPC over typographic
couplings) buys entry against the census's measured residuals — never before.
