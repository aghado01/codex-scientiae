# Benchmark harvest — ingestion as an opportunistic challenge-trial factory

**Status:** core PROTOTYPED (2026-07-03). Ingestion does double duty: while converting/repairing
papers it harvests **well-posed, isolatable repair problems** into a growing challenge library,
uniqueness-gated and difficulty-tagged. For the benchmarking ambition. Siblings:
`gated-math-repair.md` (the repair loop this taps), `issues/conversion-metric/` (the grader),
the LaTeX oracle lanes (strong ground truth), SPCX `hashish` (the production novelty engine).

## The realization — the problem-unit already exists

A dispatched repair **work-unit IS a well-posed problem**: a flagged chunk + its evidence + an
objective gate. Harvesting is capturing it *before* repair, tagged. No new problem-definition needed —
just a tap on the stream ingestion already produces.

**Supervision has two grades, both already in the pipeline:**
- **Gate** (`render_check` + delimiter balance) — objective pass/fail on ANY proposed solution.
  Weak (many solutions pass) but ALWAYS available. Trials are gate-graded today.
- **Oracle** (dual-availability `{slug}.latex.md`) — the source-derived reference answer. Strong, but
  needs the conversion-metric aligner to map the oracle equation onto this span. Recorded as
  `oracle_available` now; `reference` filled when the aligner lands (oracle-upgradeable).

## A harvested trial (the schema, prototyped in `src/benchmark.ps1`)

```jsonc
{ "id": "2508.11646-68", "problem_type": "math_repair",
  "source": { "paper": "2508.11646", "chunk_id": 68 },
  "input":  { "content": "<flattened/broken LaTeX>",
              "evidence": "<the math_evidence transcript: glyph tier table + spatial sketch>" },
  "ground_truth": { "gate": "render_check+balance", "oracle_available": false, "reference": null },
  "difficulty": { "class": "unbalanced_delimiters,needs_2d_assembly", "imbalance": 1,
                  "length": 42, "nest_depth": 3, "rows": 1, "has_oracle": false,
                  "score": 6.87, "tier": "medium" },
  "signature": ["<token-shingles for the novelty check>"],
  "provenance": { "harvested_via": "ingestion", "novelty": "novel content" } }
```

The **input carries the geometry** (`math_evidence`), not just the flattened LaTeX — so a solver
(model or future deterministic tier) reasons over the same evidence the converter had. That makes the
trial genuinely solvable, not a guessing game.

## The uniqueness gate — NOT dedup (the user's discipline)

"Some redundancy isn't bad, and similar-but-different-on-difficulty is especially useful." So the gate
is a **novelty + difficulty-diversity** keep/skip, not a duplicate filter:

- **novel content** (max Jaccard < threshold) → keep.
- **near-duplicate, under the per-tier redundancy cap** → keep (some redundancy is fine — variance is
  signal).
- **near-duplicate content but a DIFFERENT difficulty tier** → keep (the especially-useful case: same
  shape, harder/easier instance).
- **near-duplicate at the SAME tier, cap full** → skip (the only rejection).

Prototype similarity = token 2-shingle Jaccard (a PROOF signal, O(N) per candidate). **Production =
SPCX `hashish`** (MinHash+LSH — sublinear near-neighbour, plus containment/SimHash/Brotli-NCD; the
conversion-metric's atomic layer already ports it). Swap the signature/compare, keep the gate logic.

Verified on 2508.11646: 80 flagged formulas → harvested with `medium`/`easy` tiers + evidence; the cap
demonstrated (harvest one problem 3× at cap 2 → keep, keep, skip).

## Difficulty tagging (heuristic now, calibratable later)

Content-cheap score: `2·|imbalance| + log(len) + 1.5·nest_depth + 2·rows` → easy/medium/hard. `rows`
(newline count) proxies multi-row structure (fractions/matrices = harder); `nest_depth` proxies script
nesting. `has_oracle` is a SEPARATE supervision axis, not difficulty. The heuristic is a starting
bucket — the honest calibration is *observed solve-rate* (a trial the model+gate solve 95% of the time
is easy regardless of the formula); that back-calibration is a downstream pass once solve data exists.

## What this is NOT (yet) — the honest boundary

- **No oracle-aligned reference answers** — needs the conversion-metric aligner. Trials are gate-graded
  until then. This is the single biggest upgrade (weak → strong supervision).
- **No production novelty engine** — the prototype Jaccard is O(N); `hashish` MinHash+LSH is the
  scalable swap before the library is large.
- **Not wired into dispatch** — `Export-BenchmarkTrial` is callable; the "ingestion double-duty" tap
  (harvest each flagged chunk at preprocess/dispatch time) + a `harvest` MCP verb are the next wiring.
- **Difficulty is a heuristic** — calibrate against solve-rate once trials are being attempted.
- **Only `math_repair`** prototyped — the same shape generalizes to heading-level, delimiter, and
  every other dispatchable class (the problem-type axis).

## Build order

1. `Export-BenchmarkTrial` + difficulty + novelty gate (PROTOTYPED).
2. Ingestion tap: harvest flagged chunks at preprocess/dispatch; `harvest` MCP verb (opt-in, like
   `reflect`).
3. `hashish` swap for the novelty engine when the library grows.
4. Oracle-aligned references via the conversion-metric aligner (weak → strong supervision).
5. Solve-rate calibration of the difficulty buckets.
6. Other problem types (heading_level, …).
