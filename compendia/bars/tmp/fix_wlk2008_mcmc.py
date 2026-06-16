from pathlib import Path

p = Path(__file__).resolve().parents[1] / "WLK2008.md"
text = p.read_text(encoding="utf-8")
start = text.index("\n$$\n< If backwards elimination fails")
end = text.index("\n$$\n\n$$\n\\mu_{D,curr}", start)
replacement = """

If backwards elimination fails to find a valid subset, the procedure tries to fit a model with the minimum number of knots that have positive prior probability, with the knots equally spaced. If the model fails to be fit, exit.

Set $M_{\\text{curr}}$ to the resulting model.

```text
maxBIC <- 0
total_iterations <- burnin_iterations + sampling_iterations

for i <- 0 to total_iterations - 1
    u ~ U(0, 1)

    if (u < birth_probability)
        s ~ Discrete Uniform(ξ_curr)
        r <- s
        t ~ Beta(a = τ*r, b = (1 - r)*τ)
        ξ_cand <- (ξ_curr ∪ {t}) \\ {s}
        k_cand <- k_curr + 1
        Form the natural spline design basis for M_cand -> X_{D,cand}
        Fit the Poisson regression model for M_cand
        if (fit of M_cand failed)
            accept_probability <- 0
        else
            dens <- q(M_cand | M_curr) * k_curr
            accept_probability <- min(1, exp(ℓ_cand - ℓ_curr + log(k_curr) - log(dens) - 0.5*log(n)))
        comment: ℓ is the profile likelihood

    else if (1 - u < death_probability)
        t ~ Discrete Uniform(ξ_curr)
        ξ_cand <- ξ_curr \\ {t}
        k_cand <- k_curr - 1
        Form the natural spline design basis for M_cand -> X_{D,cand}
        Fit the Poisson regression model for M_cand. See function description below.
        if (fit of M_cand failed)
            accept_probability <- 0
        else
            dens <- q(M_curr | M_cand) * k_cand
            accept_probability <- min(1, exp(ℓ_cand - ℓ_curr + log(k_cand + 1) - log(dens) + 0.5*log(n)))

    else
        s ~ Discrete Uniform(ξ_curr)
        r <- s
        t ~ Beta(a = τ*r, b = (1 - r)*τ)
        ξ_cand <- (ξ_curr \\ {s}) ∪ {t}
        k_cand <- k_curr
        Form the natural spline design basis for M_cand -> X_{D,cand}
        Fit the Poisson regression model for M_cand
        if (fit of M_cand failed)
            accept_probability <- 0
        else
            accept_probability <- min(1, exp(ℓ_cand - ℓ_curr))

    u2 ~ U(0, 1)
    if (u2 < accept_probability)
        M_curr <- M_cand

    Generate random coefficient vector β_curr for M_curr
```
"""
p.write_text(text[:start] + replacement + text[end:], encoding="utf-8")
print("WLK2008 MCMC block replaced")
