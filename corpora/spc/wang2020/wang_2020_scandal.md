# so i'm confused. in the wang2020 paper, they use monte carlo? why? i know SW is monte carlo but i thought PK wang was deterministic

Great question — your intuition is right, and the paper is a little misleading on this point. PKWang's _clustering output_ is deterministic. The Monte Carlo in the paper is real but **unnecessary** — it's inherited scaffolding, not something the method needs.

Here's what's actually going on.

**What the paper does.** Eq (5) draws `M` random energies `H(Sᵢ) = −T·ln(1−rᵢ)` with `rᵢ ~ U(0,1)`, maps each to a cut depth, and averages: `G_ij = (1/M) Σ δ_ij` (eq 3–4). So yes, there's genuine randomness — the `rᵢ`. The Fig 1a histogram is them confirming those `M` draws follow the Boltzmann curve.

**Why they use it — framework inheritance.** Eq (3) is the _standard SPC recipe_: estimate any thermal average by sampling `M` spin states and averaging. The conventional SPC generates those `M` states with the Swendsen–Wang Markov chain. PKWang's whole pitch is to be a **drop-in replacement for SW's state generator** — same `M`-sample-and-average pipeline, just a faster way to produce the states. So they kept eq (3)'s Monte Carlo averaging so everything downstream (correlation, 0.5 threshold, connected components) stays identical. The MC isn't intrinsic to their idea; it's the socket their idea plugs into.

**Why it's unnecessary.** Their per-sample mapping is so simple that the `M→∞` average has a closed form. For an edge at cumulative-energy position `Hcum`, it survives a draw iff the budget didn't reach it, so:

> `G_ij = P(e < Hcum) = 1 − exp(−Hcum/T)`

and the clustering decision `G_ij > 0.5` is exactly `Hcum > T·ln2` — a fixed threshold on a fixed ladder, **no randomness at all**. The `M` draws are just a _noisy estimator_ of a quantity you can compute exactly. (With finite `M=300` there's even a downside: edges with true `G≈0.5` can flicker above/below threshold across seeds. The closed form has no flicker.)

**The contrast that resolves your confusion.** SW _genuinely needs_ Monte Carlo: it samples the true `q^N`-configuration correlated Potts distribution, which is intractable — there is no closed form, so averaging samples is the only way. PKWang flattened that problem into oblivion: it sets the density of states to constant and reduces the energy to a 1-D exponential (eq 5). Once you've done that, the thing the Monte Carlo is estimating becomes analytically solvable — but the paper kept the MC wrapper anyway, presumably because they framed it as "an SPC sampler" rather than noticing it had collapsed to a deterministic threshold.

So: **SW is Monte Carlo by necessity; PKWang is Monte Carlo only by inheritance.** That's precisely why our implementation skips the `M` draws and computes `1 − exp(−Hcum/T)` (or just the `Hcum > T·ln2` compare) directly — same answer, exact, zero variance, faster, and SIMD-friendly. The paper left that simplification on the table; we pick it up.

(One footnote for completeness: their "snap to the _closest_ `Hₐⁿ`" step rounds the budget to a half-rung, so the closed form is exact up to that rounding convention — negligible for fine ladders, and arguably the continuous form is the cleaner choice anyway.)

# so we are actually catching a mistake with wang2020

Two findings, and they're different in kind — worth separating, because "mistake" is stronger than one of them deserves and weaker than the other.

**Not a mistake:** their method _works_. The Monte Carlo estimator is unbiased — it converges to the right answer, their 97%/IRIS results are valid, and the speedup is real. There's no bug, no wrong result. So in the "they computed something incorrectly" sense, no.

**A missed simplification (mild):** they spend M=300 stochastic draws estimating a quantity with a closed form, and finite-M even adds a small downside (near-threshold flicker across seeds). That's inefficiency and a slightly noisier result, not an error. And it's _defensible_ in their context: the paper targets an FPGA accelerator, where M parallel matching blocks is a natural hardware dataflow. In silicon, "M comparators in parallel" is a reasonable architecture even if the software closed form makes them redundant. It's a 3-page applied letter on spike sorting, not a theory paper — they weren't obligated to find the reduction.

**The real thing (substantive):** there's a gap between what they _say it is_ and what it _is_. They present a "parallel Monte Carlo superparamagnetic/Potts sampler following the Boltzmann distribution." On analysis it's **deterministic thermal single-linkage** — the q-state Potts machinery, the density of states, the Boltzmann sampling, and the Monte Carlo are all vestigial; what survives is "cut the weakest couplings until cumulative energy hits T·ln2." That's not a computational mistake, it's an incomplete understanding of their own method — they didn't notice the apparatus collapses. That's the genuinely interesting catch.

But here's the discipline I'd insist on before we bank it: **that reduction is _our_ derivation, and the responsible move is to verify it the way the plan says — the property test against an independent single-linkage implementation, and Lemma B in Lean — before we treat "PKWang ≡ single-linkage" as established.** It would be a particular irony to critique their framing with an unverified framing of our own ([[feedback_validation_independence]] — ground truth from outside the estimator). I'm confident in the math (the global N·K ranking is the load-bearing fact, and it's explicit in the text), but "confident derivation" and "verified claim" aren't the same thing, and you care about that distinction.

The reduction is the prize, not the gotcha. It tells you _exactly_ when PKWang agrees with SW (separable data) and where it breaks (density variation, frustration) — which "97% on rings and IRIS" actively hides. That's a citable, formalizable result, and it's the whole reason the fidelity ladder and the M(T) discriminator are worth building.
