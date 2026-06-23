# Three Engines for Void & Minimal-Cycle Inference — a layered fold

*Status — 2026-06-22: concept synthesis from a three-turn ideation thread (compressive phase
retrieval → RJMCMC → GA/population-MCMC), each proposed as "a different way to attack the void
boundary reconstruction problem." The finding is that they are **not rivals** — they serve three
different layers of the same problem, and one of them (population-MCMC) is a general engine worth
building in its own right.*

> One substrate (the minimal-persistent-cycle / void problem), three engines stacked on it. The
> exact min-cut of Dey–Hou–Mandal is the **degenerate, exact-data point** that all three reduce to;
> each engine earns its keep only where a different assumption of that exact picture breaks.

Anchors:
- Substrate: [`compendia/ph/1907.04889v2.md`](../compendia/ph/1907.04889v2.md) — Dey–Hou–Mandal,
  *Computing Minimal Persistent Cycles*, §4 (void boundary reconstruction, embedded case) and the
  hardness map in Table 1 (§1).
- Engine-1 source: [`compendia/ph/`](../compendia/ph/) Voroninski 2008.10579v1 (compressive phase
  retrieval) + the angular/phase-synchronization line.
- Engine-2 source: [`compendia/bars/_CONTENTS.md`](../compendia/bars/_CONTENTS.md) — the RJMCMC
  corpus already feeding the ThermoMapper paper.
- Engine-3 source: **ingestion backlog (to wire — see §Literature).**

---

## 0. The shared substrate

DHM's problem: compute a **minimal persistent d-cycle** for an interval, on a complex K. Their
paper is really a hardness map:

| Problem | Restriction on K | d | Hardness |
|---|---|---|---|
| `PCYC-FIN` | arbitrary complex, finite interval | ≥1 | **NP-hard** |
| `WPCYC-FIN` | weak (d+1)-pseudomanifold | ≥1 | Polynomial (min-cut) |
| `PCYC-INF` | arbitrary, infinite interval | =1 | Polynomial |
| `WPCYC-INF` | weak pseudomanifold, **not embedded** | ≥2 | **NP-hard** |
| `WEPCYC-INF` | weak pseudomanifold **embedded in Rᵈ⁺¹** | ≥2 | Polynomial (§4, void reconstruction → min-cut) |

The §4 void-boundary algorithm lives on the *embedded* island. It reduces minimal-cycle to **min-cut
on a dual graph** (vertices ↔ (d+1)-simplices *and* voids; edges ↔ d-simplices). Min-cut returns the
single optimal **bipartition** `(S,T)` separating σ's two sides — exact, polynomial.

The objects of inference hiding inside the problem:

1. **number of voids `k`** — unknown, and it *changes along the filtration* (transdimensional).
2. **the partition / labeling** — which void each dual-graph vertex belongs to (a k-way partition;
   min-cut solves only the 2-way restriction).
3. **the orientation field** — for each boundary d-simplex, which side/void it faces (a Z₂ sign per
   simplex, under a global cycle-consistency constraint ∂ζ = 0).
4. **the nesting forest** — the laminar containment of void boundaries; DHM dodge it (Ω(n²)) by
   *assuming* d-connectivity.

Three engines, three of these layers.

---

## 1. The fold (the one table to keep)

| Engine | Layer it serves | Regime where it pays | Returns | Category error (don't) | Reduces to min-cut when… |
|---|---|---|---|---|---|
| **Synchronization / connection-Laplacian** (the *skeleton* of compressive phase retrieval) | orientation field (3) | sign/orientation is ambiguous or noisy | a globally consistent Z₂/O(1) sign field | …using it for the deep *generative prior* part of CPR — irrelevant here | orientation is locally determined by exact geometry |
| **RJMCMC** (transdimensional Bayesian partition) | void-count + partition (1,2) and nesting (4) | geometry is noisy/sampled; "real void vs. noise void?" | posterior over `k`, boundaries, nesting; Bayes factors | …running it on exact data (posterior collapses to a point mass — strictly worse than min-cut) | data exact → MAP bipartition = min-cut |
| **GA / population-MCMC** | the optimization itself (minimal weight) | the **NP-hard mainland** (`PCYC-FIN`, non-embedded `WPCYC-INF`, general complexes) | a good (not provably optimal) cycle; or a tempered posterior | …using it on the polynomial island where min-cut is exact | exact polynomial instance → just call min-cut |

The orientation row is the part of phase retrieval that genuinely transfers (recover a sign field
under a consistency constraint = group synchronization, classically solved by a connection
Laplacian); the deep generative-prior headline of Voroninski does **not** apply, because the
substrate isn't sample-starved. See the thread's turn-1 reasoning.

---

## 2. Engine 1 — phaseless skeleton → synchronization (orientation layer)

Strip compressive phase retrieval to its shape: *recover a hidden sign/phase field from
magnitude-only data, disambiguated by a global consistency constraint.* That is exactly what §4.1
does — an unoriented d-simplex has "lost its side" (cf. |Ay| losing sgn(Ay)); reconstruction
recovers the orientation, with ∂ζ = 0 as the disambiguating prior. This is **Z₂ / O(1) group
synchronization** (Singer angular-synchronization lineage), whose spectral solver is the
**connection / Hodge Laplacian** — i.e. the same operator the broader research program treats as the
geometry↔topology bridge (ker L_k ≅ homology). On *exact* data the orientation is locally determined
and min-cut absorbs it; synchronization is the tool when vertex coordinates are noisy or the local
pairing is ambiguous.

**Verdict:** real, but narrow — it is the orientation *layer*, not a replacement for the algorithm.

---

## 3. Engine 2 — RJMCMC (region-count / partition layer)

The void structure is a **partition of the dual-graph vertices** into regions (each = one void + its
incident (d+1)-simplices, plus a distinguished unbounded void). Green (GRE1995) is, almost uncannily,
a transdimensional partition sampler whose two 2-D applications — §5 Voronoi image segmentation and
§6 partition models — are the same shape:

- transdimensional index `k` ↔ number of voids;
- birth / death / split / merge (the **discrete jumps**) ↔ a void appearing, two voids merging, a
  boundary fracturing/coalescing — which by Alexander duality (DHM Prop 4.1) are **homology events**,
  i.e. the entries of the persistence pairing. So RJMCMC birth/death over voids is the
  *uncertainty-aware Bayesian analog of the persistence pairing of voids*.
- min-cut = MAP **2-partition**; RJMCMC = posterior over the full **k-way** partition.

**Where it pays:** noisy/sampled geometry. The Poisson prior `p(k)` is the Bayesian Occam razor that
persistence bar-length thresholding fakes by hand; `B_{k₀k₁}` gives calibrated "real void vs. noise
void." This is the layer already built into the ThermoMapper paper via the bars corpus, and it ties
to the backbone-conditioned-persistence framing (a tessellation/partition prior *is*
prior-conditioned persistence).

**Honest breakage:** exact data → point mass (use min-cut); mixing degrades on large partitions
(Green flags this himself, §7); detailed-balance bookkeeping for *geometric* void-births needs the
§5-style dimension-matching Jacobian; sampling ≠ minimizing (loses the optimality guarantee).

That last weakness — **mixing on multimodal partition landscapes** — is precisely what Engine 3 repairs.

---

## 4. Engine 3 — GA / population-MCMC (**the one to build**)

Special attention, deliberately generalized beyond the void problem, because this engine is wanted
for other reasons and should be built once, substrate-agnostic.

### 4.1 The general object

Combinatorial search/sampling over a structured discrete space:
- **a linear subspace over a finite field** — Z₂ chains/cycles (minimal-cycle & localization
  problems), but also the coset/syndrome structure of linear codes, Boolean CSP, parity systems;
- **a partition / labeling space** — voids, mixtures, change-points, segmentations;
- **a tree/forest space** — nesting structure, hierarchies.

### 4.2 Why Z₂ makes the cycle case unusually clean (the non-obvious payoff)

Encode a candidate cycle as a **bit-vector over d-simplices**. Because the cycle group is a
**vector space over GF(2)**:

- **Crossover = symmetric difference (Z₂ sum).** The sum of two cycles is a cycle → XOR crossover is
  *closed in the feasible set*. No repair, no penalty terms.
- **Mutation = add ∂ of a random (d+1)-simplex.** Adding a boundary keeps you in the **same homology
  class** → mutation explores within the coset (the born-at-β/dies-at-δ class).
- **Fitness = cycle weight**, with ∂ζ a cheap sparse GF(2) mat-vec.

This is a general principle worth stating once: *when the feasible set is a linear subspace over a
finite field, the natural genetic operators (field addition, generator-addition) respect the
constraint for free.* Most GAs bleed efficiency fighting infeasibility; here they don't. The same
structure recurs in coding theory and parity-constrained optimization — so the engine's Z₂ core is
reusable far beyond cycles.

A GA in this encoding attacks the minimal-weight objective **directly over chain space and never
builds the void/nesting structure at all** — it sidesteps the §4.1 reconstruction (and its embedding
+ d-connectivity assumptions), trading exact-but-assumption-heavy for assumption-light-but-heuristic.

### 4.3 GA and RJMCMC are the same engine at two temperatures

- GA targets an **optimum** (point estimate; free to use greedy, non-reversible operators).
- RJMCMC targets a **posterior** (uncertainty; detailed balance).
- Same energy: GA fitness = RJMCMC negative-log-posterior.

The unifier is **population MCMC / evolutionary Monte Carlo**: crossover-style recombination moves
*inside* an MCMC, across a population of chains, usually on a temperature ladder. This is the general
engine:

- **within-model moves** — recombination/crossover across the population (fixes the multimodal
  mixing that single-chain RJMCMC chokes on — the Engine-2 weakness);
- **between-model moves** — RJMCMC birth/death/split/merge with dimension-matching (the
  transdimensional bridge);
- **temperature ladder** — parallel tempering for rugged landscapes;
- **limits** — T→0 + greedy selection ⇒ pure GA optimizer (MAP); single chain, reversible moves ⇒
  pure RJMCMC sampler (posterior). The engine *contains* both of the other turns' proposals as
  endpoints.

### 4.4 Buildable spec (substrate-agnostic)

- **State:** a population of genomes; genome encodings pluggable —
  Z₂ bit-vector (cycles/codes), partition/labeling (voids/mixtures), tree (nesting).
- **Operators:** crossover (XOR for Z₂; partition-recombination otherwise); mutation
  (add-generator / point-flip / split-merge); transdimensional birth/death as a length-changing
  "mutation" carrying its Jacobian.
- **Acceptance:** switchable — GA tournament/elitist selection **or** Metropolis-within-move with
  detailed balance (the two are mutually exclusive per move; see hazard below).
- **Schedule:** temperature ladder + exchange moves.
- **Objective plug:** weight (cycles), negative-log-posterior (Bayesian void structure), or any
  black-box fitness.

### 4.5 Honest hazards

1. **Reversibility vs. optimization is a real fork.** Crossover that improves fitness greedily
   breaks detailed balance — that's fine for a MAP optimizer, fatal for a calibrated sampler. To keep
   it a valid sampler you need the Liang–Wong-style construction (symmetric recombination + proper
   acceptance). **Decide up front which you want**, or support both as modes.
2. **Constraint-preservation is free only for linear-over-a-field feasible sets.** Partition/tree
   encodings need explicit feasibility handling.
3. **Mixing is still hard**; tempering helps but adds chains/cost.
4. **No optimality guarantee** — only justified off the polynomial island. On the island, call min-cut.

---

## 5. The combined picture

```
                         minimal persistent cycle / void structure
                                        │
        ┌───────────────────────────────┼───────────────────────────────┐
   orientation layer              region/partition layer            optimization
   (Engine 1)                     (Engine 2)                         (Engine 3)
   synchronization /              transdimensional RJMCMC            GA / population-MCMC
   connection-Laplacian           posterior over k, boundaries       minimal-weight on the
   (Z₂ sign field)                (ThermoMapper-resident)            NP-hard mainland
        │                               │                                │
        └───────── all collapse to ─────┴──────── DHM exact min-cut ──────┘
                         (embedded, exact-data, polynomial island)
```

Engine 3 is also the **mixing repair** for Engine 2, and contains Engines'-2-and-GA as temperature
limits — which is why it's the one general thing worth building.

---

## 6. Literature wiring

**Engine 2 — RJMCMC corpus (in repo, feeding ThermoMapper)** —
[`compendia/bars/_CONTENTS.md`](../compendia/bars/_CONTENTS.md):
- `GRE1995` — Green, Reversible-Jump MCMC. The foundation; §5 Voronoi segmentation and §6 partition
  models are the direct structural templates for void partitioning.
- `TN2020` — RJMCMC for multi-model inference (metabolic flux). The closest thing to a *general
  transdimensional engine* already in the corpus — inter/intra-model transition densities split out.
- `DMGK2001` — free-knot splines; clean RJMCMC mechanics + detailed-balance appendix.
- `HYK2024` — modern RJMCMC knot inference **with manifold denoising** (bridges to the geometry side).
- `HTR2005` — exact Bayesian piecewise-constant via dynamic programming: the *non-sampling*
  alternative; worth contrasting (when is exact DP cheaper than a sampler?).
- `WLK2008` — BARS C implementation: engine/implementation reference.

**Engine 1 — phase retrieval / synchronization** —
[`compendia/ph/`](../compendia/ph/) Voroninski 2008.10579v1 (finalized); the unprepped
`corpora/voroninski/*` backlog is the likely home of further phase-retrieval / phase-synchronization
material — flag any angular-synchronization / connection-Laplacian items when prepping.

**Substrate** — [`compendia/ph/1907.04889v2.md`](../compendia/ph/1907.04889v2.md) (DHM §4–5).

**Engine 3 — GA / population-MCMC corpus** — *staged raw PDFs, pre-ingestion, at
`PowerShellCore/ps.core.pdfdig/pdfs/ga/` (not yet in the codex-scientiae membrane root).* Five papers,
identified and grouped by the role they play in the build:

*Provably-correct samplers — these settle the §7.1 fork: yes, population recombination can keep detailed balance:*
- **Hu & Tsui 2010**, "Distributed Evolutionary Monte Carlo for Bayesian Computing", *CSDA* 54:688–697
  [`hu2010.pdf`] — evolves a population of chains via genetic operators with **proven target stationarity**,
  for multimodal/high-dimensional *real-valued* targets, distributed/parallel. The "keep it a valid sampler"
  + scaling reference.
- **Laskey & Myers 2003**, "Population Markov Chain Monte Carlo", *Machine Learning* 50:175–196
  [`A_1020206129842.pdf`] — popMCMC: a population of Metropolis–Hastings samplers sharing statistics to inform
  each other's proposals; shows explicitly that EAs violating **local reversibility** lose population diversity
  vs. popMCMC. Applied to learning Bayesian-network structure with hidden variables — a *different substrate*,
  i.e. direct evidence for the substrate-agnostic build.

*The foundational hybrid + the operators:*
- **Liang & Wong 2000**, "Evolutionary Monte Carlo: Applications to Cp Model Sampling and Change Point Problem",
  *Statistica Sinica* 10:317–342 [`Sinica00.pdf`] — **the cornerstone.** Population of chains at different
  temperatures, updated by mutation (Metropolis) + crossover (partial state swap) + exchange (full state swap)
  + parallel tempering. This *is* the Engine-3 architecture of §4.3 — and its **change-point** application ties
  straight to GRE1995 §4 and the zigzag thread.
- **ter Braak — Differential Evolution Markov Chain (DE-MC)** [`Braak2001.pdf`; report dated Aug 2005,
  user-cited "Braak 2001"; canonical journal version *Stat. & Comput.* 2006] — "Genetic algorithms and MCMC:
  DE-MC makes Bayesian computing easy." The continuous recombination operator: proposal from the *difference of
  two other chains' states*. The real-valued within-population move (vertex coords, heights) — complements the
  Z₂ XOR crossover of the discrete cycle layer.

*Foundations (reference-tier):*
- **Whitley, "A Genetic Algorithm Tutorial"** [`ga_tutorial.pdf`] — canonical GA + parallel island/cellular
  models + the schema theorem and exact models of the canonical GA (the theory for *why* recombination works;
  hyperplane sampling).

**Build-relevant finding:** the corpus already de-risks §7.1's central question — Hu–Tsui (proven stationarity),
Laskey–Myers (reversibility ⇒ diversity), and Liang–Wong's exchange operator together show population
recombination *with* detailed balance, so a **dual-mode** (valid sampler ∧ MAP optimizer) engine is
well-precedented. Still to acquire if wanted: Geyer (parallel tempering — the temperature-ladder primitive) and
an EDA reference (Mühlenbein / Larrañaga).

---

## 7. Open decisions (before building Engine 3)

1. **Sampler or optimizer or both?** Detailed-balance population MCMC vs. greedy GA is a per-move
   fork (§4.5.1). A dual-mode engine is possible but doubles the acceptance machinery.
2. **Orientation layer: co-evolve or delegate?** Fold the Z₂ sign field into the genome, or leave it
   to the synchronization/Hodge solver (Engine 1) and have Engine 3 work only over homology classes.
3. **Where it lands in code.** Standalone substrate-agnostic engine vs. a module inside the PH-engine
   port (SPCX / ThermoMapper). The substrate-agnostic-instrument telos argues for standalone with
   pluggable encodings + objective.

## What this file deliberately does NOT do

- No commitment to an implementation language/home — that's decision (7.3).
- No claim that any engine beats min-cut on the polynomial island — none do; that's the point.
- The GA/population-MCMC corpus is identified (§6) but still **staged pre-ingestion** at
  `ps.core.pdfdig/pdfs/ga/` — pulling it into the membrane root is a separate step, not done here.
