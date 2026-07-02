# conversion-metric — aligned, typed fidelity scoring for PDF→markdown conversions

**Status:** DESIGN (2026-07-02) — the grading harness `latex-ingest.ps1`'s header already references
(`src/conversion-metric.ps1`, not yet built). Grades a CANDIDATE conversion (opendataloader today,
pdfdig tomorrow) against the LaTeX-oracle GROUND TRUTH on dual-availability papers.
**Related:** `issues/latex-math-oracle/math-bank-oracle-lane.md` (the oracle + the aligner this reuses),
pdfdig SHAPE.md's dogfood section ("the easy case is the test oracle for the hard one"), the membrane
benchmarking thread (this metric is its scoring half).

---

## The core principle: alignment precedes measurement

Unaligned whole-document similarity conflates the four failure modes that matter — omission,
corruption, duplication, disorder — into one meaningless number. The metric is therefore built as
**align typed units → score each pair with a type-appropriate atomic metric → compose upward**, with
document-level direct measures kept as a *separate, cross-checking* lens (never the grade).

**The units are already defined — do not invent a chunking for the metric.** The oracle side ships
pre-chunked: the math bank (display equations, doc-ordered, eq-numbered), the structure skeleton
(headings with levels), numbered references, ordered figure/diagram markers, and prose = what lies
between structural anchors. The candidate side is the membrane chunk stream (typed
heading/formula/prose/table) or pdfdig's classified lines. And the ALIGNER is the oracle lane's
aligner — skeleton matching (normalized-title + monotone order) partitions both documents into
section scopes; within a scope, each type lane aligns by its own anchors (eq-no + math-token overlap
for equations; order + shingle overlap for prose; numbers for references). One aligner, two consumers:
repair assist and grading.

**Alignment confidence is part of the report, not an internal detail.** A misaligned pair scores as
fake corruption — the metric's main failure mode. So: anchors first, monotone (order-preserving)
matching for the rest, and below-threshold pairs land in an explicit `unaligned` bucket rather than
being force-matched. Only confident pairs contribute fidelity scores; the buckets contribute to
coverage.

## Where the candidate metrics actually belong

| Candidate | Verdict | Its correct home |
|---|---|---|
| **Jaccard/Dice** | YES — the atomic workhorse | Partial credit on token MULTISETS: math-token Jaccard for equations (corruption-tolerant), word n-gram (shingle) Jaccard for prose alignment scoring |
| **Cosine** | mostly redundant | Over term-frequency vectors it is soft Jaccard; over embeddings it imports non-determinism — keep out of the core (exploratory lens at most) |
| **KL divergence** | not a grade | A CORPUS-LEVEL DRIFT DIAGNOSTIC: symbol-distribution divergence between candidate and oracle exposes *systematic* corruption classes (the `‖→k` substitution shows as mass displacement between specific symbols) — run it across docs to find engine bug classes, never to score one doc |
| **LSH/MinHash** | not needed yet | An alignment ACCELERATOR (approximate nearest-neighbor), not a metric. At 43–70 docs, brute-force + monotone DP is fine; revisit only at corpus scale |
| **Edit distance** (unlisted but needed) | YES | Prose is ORDERED — token-level edit-distance ratio (WER-style) is the prose atomic score; Jaccard alone is order-blind |
| **Exact-match-after-normalization** (unlisted) | YES | The math gold standard: canonical-KaTeX token sequences equal after normalization ⇒ fidelity 1.0. Partial credit only below that bar |

## Atomic scores, per type lane

All deterministic; all in the shared canonical register (both sides are canonical-KaTeX markdown —
same-vocabulary diffs, the point of the target-register decision):

- **Math** (the crown jewel): tokenize LaTeX (commands atomic, braces structural, whitespace dead);
  score = 1.0 on normalized exact match, else math-token multiset Jaccard; plus a `renders` bit from
  `Test-MathRenders -Spans` (a candidate equation that doesn't even compile is capped). Upgrade path:
  when mathdig's math AST exists, exact-match/Jaccard on token strings become equality/tree-edit
  distance on `unique(mathjax ∪ katex)` nodes — same lane, better primitive.
- **Prose**: normalize (ligatures, quotes, dashes, whitespace), then token-level edit-distance ratio.
- **Structure**: heading precision/recall (vs skeleton), level agreement on matched pairs, and order
  agreement (Kendall tau) — the zoning/promotion failure classes land here.
- **Tables**: grid shape agreement (rows × cols) + cell-content Jaccard on aligned cells.
- **References**: per-number match rate + per-entry edit-distance ratio (the ghost-layer merge class
  lands here).
- **Figures/diagrams**: count + order agreement on markers/links (opendataloader's missed images land
  here).

## Composition — coverage × fidelity, never mean-of-pairs alone

Omissions never appear in aligned pairs, so a composite that averages pair scores silently rewards
dropping hard content. Per type lane:

- **recall** = oracle units with a confident candidate match / oracle units
- **precision** = candidate units grounded in the oracle / candidate units (duplication and
  ghost-layer fabrication burn precision)
- **fidelity** = mean atomic score over confident pairs
- **lane score** = recall-weighted fidelity (report all three, never just the blend)

**Document composite** = explicit-weighted lane scores (weights in config, math-heavy by default —
this corpus's raison d'être). **Document-level direct measures** ride alongside as the cross-check:
whole-doc normalized token Jaccard (smoke), length ratio, unit-count ratios, corpus KL drift, and the
alignment-free render-gate rate (fraction of candidate math that compiles). Disagreement between the
holistic lens and the composite is an ALIGNER bug signal, which is exactly why both exist.

## The report is a work-list, not just a number

Output per doc: `{slug}.metric.json` (lane scores + composite + counts) **plus a per-unit JSONL** —
`{unit, type, oracle_ref, candidate_ref, aligned, confidence, score, why}` — the same
pointer-not-content shape as the membrane's hotspots. Consequences: the worst-scoring units are
dispatchable repair targets; pdfdig regression runs diff per-unit JSONLs between engine versions
(which equations regressed, not just "the number moved"); and the benchmarking thread gets its
scoreboard for free.

## Staging

1. **Stage 0 (build now, serves the opendataloader lane immediately):** skeleton alignment + the math
   and structure lanes only — eq recall, math-token fidelity, render rate, heading P/R. The bank +
   skeleton supply the units; `get_oracle`'s scoring signals are the pair scorer.
2. **Stage 1:** prose/tables/references lanes, composite weights, per-unit JSONL, `conversion-metric.ps1`
   + MCP surface (paper-addressed, run-pinnable — grade any run, diff two runs).
3. **Stage 2 (post-mathdig / pdfdig maturity):** math AST tree-edit distance; pdfdig's render-back
   verifier as an additional per-formula dimension (agreement between forward-render and page = a
   fidelity bit that needs no oracle at all).

## Reuse inventory — ThermoMapper's `hashish` module (reviewed 2026-07-02)

SPCX carries a dependency-free, engine-grade C# similarity library (`src/hashish`, namespace `Hashish`)
that covers most of the atomic layer:

- **`JaccardContainment`** — Similarity/Dice AND **Containment** (asymmetric). Amendment to the math
  lane above: score = exact-match, else the containment PAIR (oracle→candidate, candidate→oracle) with
  Jaccard as summary — containment separates omission from fabrication at the unit level, which
  symmetric Jaccard conflates.
- **`TokenizerPreprocessing`** — NFKC normalization built in (folds ligatures `ﬁ→fi` — the corpus's
  standing normalization class). ADOPT NFKC as the metric's defined prose normalization; PowerShell
  reaches it natively (`.Normalize([Text.NormalizationForm]::FormKC)`), no port needed.
- **`Levenshtein.Similarity`** — the prose atomic ratio, already [0,1], already optimized.
- **`NormalizedCompressionDistance`** (Brotli) — a BETTER holistic lens than whole-doc Jaccard:
  parameter-free, alignment-free candidate↔oracle cross-check.
- **`SimHash`** (BM25-weighted, 64-bit + Hamming) — run-to-run tripwire: fingerprint per run artifact,
  Hamming distance = "did the engine change move the output," for pennies. Slots into the runs layout.
- **`MinHash` + banded LSH index** — not for scoring at ≤70 docs, but real near-term job: corpus
  near-duplicate detection (v1/v2 of a paper, re-staged copies — ph-temp vs membrane-testing).
- KL/JS for the drift diagnostic live in SPCX `maths/information` (`JSDistance`, `Shannon`), not
  hashish — prefer JS (symmetric, bounded).

**Gaps (the genuinely new builds):** a LaTeX-aware tokenizer (`\w+` shreds `\mathbb{R}`; commands must
be atoms) and the monotone unit-alignment DP. Both small.

**doccer connection (reviewed 2026-07-02; spcx `src_dev/doccer` Phase-0 design + the prior
membrane-integration record in MarkBrain):** both gaps are doccer-shaped — the LaTeX tokenizer is an
inventory *language pack* (declarative pattern entries, `language: latex`, math commands as atoms), and
unit alignment is an interval-algebra primitive. The membrane's `masks.ps1` is already a WORKING,
property-tested fragment of doccer's Phase-2 algebra layer (law tests over random masks, pincer,
SMP-codepoint safety) — the natural seed if Phase 2 gets scoped by this metric as its first paying
consumer. Adopt doccer's Tier-2 vocabulary for the aligner's self-check: the "holistic vs composite
disagreement = aligner alarm" above IS a cross-derivation pairing; report it as an `agreement_score`.
The parked byte-exact OffsetMap (doccer's immutable-master contract) now has three consumers waiting:
source-anchored `propose_edit`, the `splice_md` byte lane, and this metric's per-unit pointers.

**Integration path:** Stage 0 = PS ports of Jaccard/containment (~30 lines) + native NFKC; when the
metric matures (or pdfdig arrives), load hashish wholesale as the engine dll (pure BCL, Add-Type-able) —
the C#-engine/PS-driver convention. Note: hashish's center of gravity is text similarity — MarkPig/codex
territory; likely homed in ThermoMapper by history, candidate for the MarkPig family eventually.

## Open questions

- Weight defaults for the composite (math 0.4 / structure 0.2 / prose 0.2 / tables+refs+figures 0.2?)
  — decide from what the corpus actually punishes; keep in config, never hardcode.
- Prose unit granularity: paragraph (natural, coarser) vs sentence (finer alignment, more brittle
  splitting) — start paragraph-level.
- Inline math: score inside the prose lane (as tokens) or as its own micro-lane? Start inside prose;
  display math is where the money is.
- Normalization table shared with the membrane detectors (ligatures/quotes) — factor once, use in
  both.
