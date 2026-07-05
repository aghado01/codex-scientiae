# Benchmark harvest — a post-hoc harvest of scoreable repair trials

**Status:** core PROTOTYPED (2026-07-03), concept refined toward post-hoc + oracle ground truth.
The benchmarking **sibling of `reflect`**: a POST-HOC, opt-in review of a run's worked examples that
captures the benchmark-worthy ones — the well-framed challenge + its evidence + the prompt it was
posed with + the LaTeX-oracle **ground truth** — into a growing, uniqueness-gated challenge library.
Siblings: `gated-math-repair.md` (the loop it reviews), `issues/conversion-metric/` (the scorer that
consumes the oracle reference), the LaTeX oracle lanes (the ground-truth source), SPCX `hashish`
(the production novelty engine).

## Post-hoc, like reflection (not an inline tap)

Harvest runs at a run boundary, after the work — the same shape as `reflect`, on the same substrate
(the run's audit), asking a benchmarking question instead of a promotion one:

| | `reflect` | `harvest` |
|---|---|---|
| looks at | the run's worked examples | the run's worked examples |
| asks | "any generalizable RULE to surface?" | "any well-posed PROBLEM worth adding?" |
| gates on | novelty vs the promotion queue | novelty vs the trial library (add anything new?) |
| output | a candidate for human review | a scoreable trial in the library |
| discipline | machine surfaces, human decides | agent judges value; novelty is decision-support |

The novelty question — *do these examples add anything the library doesn't already have?* — is part
of the post-hoc review, not a silent append filter. The agent reviews the run's candidates against the
library; the uniqueness signal (below) is the evidence, the agent's judgment is the call (some
redundancy is fine; a harder/easier instance of a known shape is valuable).

## The realization — the problem-unit already exists

A dispatched repair **work-unit IS a well-posed problem**: a flagged chunk + its evidence + an
objective gate. And by the time harvest runs post-hoc, that unit was ALSO *attempted* — so the run
holds the prompt it was posed with and the solution the session produced. Harvesting captures the
whole framed instance, then pairs it with the oracle answer to make it scoreable.

**Supervision has two grades — and harvest's job is to close the gap to the strong one:**
- **Gate** (`render_check` + delimiter balance) — objective pass/fail on ANY proposed solution.
  Weak (many wrong solutions still render) but ALWAYS available.
- **Oracle** (dual-availability `{slug}.latex.md`) — the source-derived **reference answer**: the
  objective substrate a benchmark scores against (how close is a solution to the truth, not merely
  does-it-render). This is what turns a solvable puzzle into a scoreable benchmark, and capturing it
  at harvest time is the loop-closer (see "Oracle ground truth" below).

## A harvested trial (the refined schema)

A complete benchmark instance = the challenge, how it was posed, and the objective answer:

```jsonc
{ "id": "2508.11646-68", "problem_type": "math_repair",
  "source": { "paper": "2508.11646", "chunk_id": 68 },
  "challenge": {
    "content":  "<flattened/broken LaTeX the converter emitted>",
    "evidence": "<math_evidence transcript: glyph tier table + spatial sketch — the geometry a solver reasons over>",
    "prompt":   "<the exact instruction the session posed the repair with: the playbook recipe + evidence framing>"
  },
  "ground_truth": {
    "reference":       "<the oracle's LaTeX for THIS equation — the objective answer to score against>",
    "reference_source":"latex_oracle",           // 'latex_oracle' | null (gate-only when no oracle)
    "alignment":       "agent",                   // how the oracle span was matched: 'agent' | 'auto' (conversion-metric)
    "gate":            "render_check+balance"      // the weak, always-available floor
  },
  "session_solution": "<what the run produced — a baseline attempt, NOT ground truth>",
  "difficulty": { "class": "unbalanced_delimiters,needs_2d_assembly", "imbalance": 1,
                  "length": 42, "nest_depth": 3, "rows": 1, "score": 6.87, "tier": "medium" },
  "signature":  ["<shingles for the novelty check>"],
  "provenance": { "harvested_via": "post-hoc review", "run": "<stamp>", "novelty": "novel content" } }
```

Three things make it a real trial rather than a scrap:
- **challenge.evidence** — the geometry (`math_evidence`), so a solver reasons over what the converter
  saw, not a guessing game.
- **challenge.prompt** — the exact framing the session used. Captured so the trial is REPRODUCIBLE and
  so you can benchmark *approach variations* against a fixed problem (different prompt, same challenge).
  A well-posed problem includes how it was posed.
- **ground_truth.reference** — the oracle answer (below). Without it a trial is only gate-checkable
  ("does a solution render"); with it a trial is *scoreable* ("how close to the truth").

`session_solution` is kept as a BASELINE (what this run's model produced), explicitly not the truth —
useful for regression ("did we get better than last time") but never the scoring target.

## Oracle ground truth — the loop-closer, the scoring substrate

A benchmark needs a known answer. For dual-availability papers the LaTeX oracle IS that answer: the
source-derived, render-valid LaTeX for the very equation the converter mangled. Capturing it at
harvest time closes the loop — the trial now carries `challenge` (the geometry problem) AND
`ground_truth.reference` (the correct output), which is exactly what the conversion-metric scorer
consumes (math token fidelity, structure P/R) to grade a solution objectively, beyond does-it-render.

**Getting the reference is a span-alignment problem — with a bootstrap and a scale path:**
- **Bootstrap — agent-aligned (available NOW, fits the post-hoc frame).** Harvest is post-hoc and
  agent-in-the-loop: the agent just repaired this equation, read the paper, and can find the matching
  equation in `{slug}.latex.md` by inspection. It records that oracle span as the reference
  (`alignment: "agent"`). No aligner needed to start collecting scoreable trials.
- **Scale — auto-aligned (the conversion-metric aligner).** The math-bank/skeleton aligner
  (`issues/conversion-metric/`, `issues/latex-math-oracle/`) maps oracle equations to spans
  deterministically at volume (`alignment: "auto"`). Same field, mechanized.

Discipline that keeps this honest (from the oracle briefs): the oracle is authoritative for *what the
math says* but fallible in *how it converted* — so a captured reference is itself floored by KaTeX
render-validity before it's trusted as truth. A reference that doesn't render is a converter bug in
the oracle, not a ground truth; flag it, don't enshrine it. And the modality wall still holds: the
oracle reference is the SCORING answer key, never fed to the pig converter (distillation, not
delegation — `gated-math-repair.md`).

Papers with no oracle still harvest — gate-graded only (`reference_source: null`), a solvable trial
without a fidelity score. They are the majority (the source-less ocean); the oracle-backed minority is
the calibrated, scoreable core.

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
nesting. Oracle-availability is NOT a difficulty tag — it's a supervision axis (it lives in
`ground_truth`, deciding scoreable-vs-gate-only, orthogonal to how hard the problem is). The heuristic
is a starting bucket — the honest calibration is *observed solve-rate* (a trial the model+gate solve
95% of the time is easy regardless of the formula); that back-calibration is a downstream pass once
solve data exists.

## Prototype vs the refined target — the honest boundary

`src/benchmark.ps1` + the `harvest` MCP verb (opt-in, gated with `reflect` behind `-Experimental`)
implement **part** of the refined concept. What's there and what the refinement adds:

| Trial part | Prototype (now) | Refined target |
|---|---|---|
| challenge.content + evidence | ✅ captured | ✅ |
| challenge.prompt | ✗ not captured | the session's repair prompt/recipe — **add** |
| ground_truth.reference (oracle) | ✗ only `oracle_available` bool | the aligned oracle LaTeX — **add** (agent-align bootstrap, auto-align at scale) |
| session_solution baseline | ✗ | the run's produced fix — **add** |
| difficulty tags + novelty gate | ✅ (heuristic Jaccard) | calibrate on solve-rate; `hashish` MinHash+LSH |
| post-hoc framing | partial (on-demand per-paper verb) | review the run's WORKED examples (audit), not just flagged chunks |

Two of these are the substance of this refinement: **prompt capture** (reproducibility + approach
benchmarking) and **oracle ground truth** (the scoring substrate that closes the loop). Both are
reachable now — the prompt is in the session's dispatch/slice, the oracle reference is agent-alignable
in the post-hoc review — without waiting on the conversion-metric aligner (that's the scale path).

Also still open: production novelty engine (`hashish` vs the O(N) Jaccard); solve-rate difficulty
calibration; and the other problem types (heading_level, delimiter, …) beyond `math_repair`.

## Build order

1. `Export-BenchmarkTrial` + difficulty + novelty gate + `harvest` verb (PROTOTYPED, opt-in).
2. **Refine to the post-hoc trial (this doc):** capture `challenge.prompt` (from the session) +
   `session_solution` baseline; add `ground_truth.reference` via **agent alignment** to the oracle in
   the post-hoc review (bootstrap — no aligner dependency).
3. Auto-align oracle references at scale via the conversion-metric aligner (`alignment: "auto"`).
4. `hashish` swap for the novelty engine when the library grows.
5. Solve-rate calibration of the difficulty buckets (the truest "hard" is what solvers miss).
6. Other problem types (heading_level, …).
