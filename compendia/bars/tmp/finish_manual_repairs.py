#!/usr/bin/env python3
"""Apply diagnosed manual repairs for bars compendium."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# --- BM2021 ---
bm = (ROOT / "BM2021.md").read_text(encoding="utf-8")
bm = bm.replace(
    r"$\rho : R \to [0; +\infty)$",
    r"$\rho : R \to [0, +\infty)$",
)
(ROOT / "BM2021.md").write_text(bm, encoding="utf-8")

# --- MRA2015 body ---
mra = (ROOT / "MRA2015.md").read_text(encoding="utf-8")

old_piecewise = r"""$$
b _ { \gamma } ^ { ( t + 1 ) } = \left \{ \begin{array} { l l } { b _ { \gamma } ^ { * } } & { w i t h \text { probability } \alpha _ { \gamma } } \\ { b _ { \gamma } ^ { ( t ) } } & { w i t h \text { probability } 1 - \alpha _ { b _ { \gamma } } , } \end{array}
$$"""

new_piecewise = r"""$$
b _ { \gamma } ^ { ( t + 1 ) } = \begin{cases} \ b _ { \gamma } ^ { * } & \text {with probability $\alpha_{\gamma}$} \\ \ b _ { \gamma } ^ { ( t ) } & \text {with probability $1-\alpha_{\gamma}$} , \end{cases}
$$"""

mra = mra.replace(old_piecewise, new_piecewise)

mra = mra.replace(
    r"IG \left ( \frac { 1 } { 2 } ( \nu _ { 2 } + 1 ) ) , \nu _ { 2 } \eta + \frac { 1 } { G _ { 2 } ^ { 2 } } \right ) .",
    r"IG \left ( \frac { 1 } { 2 } ( \nu _ { 2 } + 1 ) , \nu _ { 2 } \eta + \frac { 1 } { G _ { 2 } ^ { 2 } } \right ) .",
)

(ROOT / "MRA2015.md").write_text(mra, encoding="utf-8")

# --- MRA2015 appendices ---
app_path = ROOT / "references" / "MRA2015.appendices.md"
app = app_path.read_text(encoding="utf-8")

old_theta = r"""$$
1 . \, & \, Sampling \, \theta \\ p ( \theta | b , \beta , \gamma , \tau , \xi _ { 1 } , y ) \quad \otimes \quad p ( y | b , \theta , \tau ) p ( b | \tau , \xi _ { 1 } ) p ( \beta ) p ( \tau ) p ( \xi _ { 1 } | \rho _ { 1 } ) \\ & \quad \otimes \quad \exp \left \{ - \frac { \tau } { 2 } ( y - T \theta ) ^ { \prime } ( y - T \theta ) \right \} \times \exp \left \{ - \frac { 1 } { 2 } \tau \xi _ { 1 } b ^ { \prime } D , b \right \} \times \exp \left \{ - \frac { 1 } { 2 \sigma _ { 2 } ^ { 3 } } \beta ^ { \prime } \beta \right \} \\ & = \quad \exp \left \{ - \frac { \tau } { 2 } ( y - T \theta ) ^ { \prime } ( y - T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ - \frac { \tau } { 2 } ( y ^ { \prime } - \theta ^ { \prime } T ^ { \prime } ) ( y - T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ - \frac { \tau } { 2 } ( y ^ { \prime } y - 2 \theta ^ { \prime } T ^ { \prime } y + \theta ^ { \prime } T ^ { \prime } T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & \quad \otimes \quad \exp \left \{ - \frac { \tau } { 2 } ( - 2 \theta ^ { \prime } T ^ { \prime } y + \theta ^ { \prime } T ^ { \prime } T \theta ) - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ \tau \theta ^ { \prime } T y - \frac { \tau } { 2 } \theta ^ { \prime } T T \theta - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda _ { y } \theta \right \} \\ & = \quad \exp \left \{ \tau \theta ^ { \prime } T y - \frac { 1 } { 2 } \theta ^ { \prime } [ \tau T ^ { \prime } T + \Lambda _ { y } ] \theta \right \} \\ & = \quad \exp \left \{ \tau \theta ^ { \prime } T y - \frac { 1 } { 2 } \theta ^ { \prime } [ \tau T ^ { \prime } T + \Lambda _ { y } ] \theta \right \} \\ & \quad \otimes \quad \exp \left \{ \tau T ^ { \prime } T + \Lambda _ { y } \theta \right \} .
$$"""

new_theta = r"""$$
\begin{aligned}
1. \quad & \text{Sampling } \theta \\
p(\theta \mid b, \beta, \gamma, \tau, \xi_1, y) &\propto p(y \mid b, \theta, \tau)\, p(b \mid \tau, \xi_1)\, p(\beta)\, p(\tau)\, p(\xi_1 \mid \rho_1) \\
&\propto \exp\left\{ -\frac{\tau}{2} (y - T\theta)'(y - T\theta) \right\} \exp\left\{ -\frac{1}{2} \tau \xi_1 b' D_\gamma b \right\} \exp\left\{ -\frac{1}{2\sigma_\beta^2} \beta'\beta \right\} \\
&= \exp\left\{ -\frac{\tau}{2} (y - T\theta)'(y - T\theta) - \frac{1}{2} \theta' \Lambda_y \theta \right\} \\
&= \exp\left\{ -\frac{\tau}{2} (y' y - 2\theta' T' y + \theta' T' T \theta) - \frac{1}{2} \theta' \Lambda_y \theta \right\} \\
&= \exp\left\{ \tau \theta' T' y - \frac{1}{2} \theta' [\tau T' T + \Lambda_y] \theta \right\}
\end{aligned}
$$"""

app = app.replace(old_theta, new_theta)
app = app.replace(
    "Note that Q θ = ( τT T + Λ y ) − 1 . By solving for µ θ , i.e., Q − 1 θ µ θ = τT y ⇒ µ θ = τQ θ T y .",
    "Note that $Q_\\theta = (\\tau T' T + \\Lambda_y)^{-1}$. By solving for $\\mu_\\theta$, i.e., $Q_\\theta^{-1} \\mu_\\theta = \\tau T' y \\Rightarrow \\mu_\\theta = \\tau Q_\\theta T' y$.",
)

# Truncate intertext sludge in partial derivatives block
start_pd = app.find("Partial derivatives:\n\n$$")
end_pd = app.find("where z γ j is the j th row", start_pd)
if start_pd != -1 and end_pd != -1:
    new_pd = r"""Partial derivatives:

$$
\begin{aligned}
\log p(b_\gamma \mid \gamma, b, \tau, \xi_1, \xi_2) &= \frac{1}{2}\sum_{j=1}^{K_\kappa} z_{\gamma_j}' b_\gamma - \frac{1}{2}\tau\xi_1\sum_{j=1}^{K_\kappa} b_j^2 \exp\{z_{\gamma_j}' b_\gamma\} - \frac{1}{2}\tau\xi_1\xi_2 b_\gamma' b_\gamma \\
\frac{\partial \log p(b_\gamma \mid \gamma, b, \tau, \xi_1, \xi_2)}{\partial b_\gamma} &= \frac{1}{2} Z_\gamma' \mathbf{1} - \frac{1}{2}\tau\xi_1\sum_{j=1}^{K_\kappa} b_j^2 \exp\{z_{\gamma_j}' b_\gamma\} z_{\gamma_j} - \tau\xi_1\xi_2 b_\gamma \\
\frac{\partial^2 \log p(b_\gamma \mid \gamma, b, \tau, \xi_1, \xi_2)}{\partial b_\gamma \partial b_\gamma'} &= -\frac{1}{2}\tau\xi_1\sum_{j=1}^{K_\kappa} b_j^2 \exp\{z_{\gamma_j}' b_\gamma\} z_{\gamma_j} z_{\gamma_j}' - \tau\xi_1\xi_2 I_{K_\ell+q},
\end{aligned}
$$

"""
    app = app[:start_pd] + new_pd + app[end_pd:]

# Fence B.3 R code blocks
for heading, marker in [
    ("### B.3.1 Non-Adaptive Whittle\n\n", "### B.3.2 Adaptive Whittle"),
    ("### B.3.2 Adaptive Whittle\n\n", None),
]:
    idx = app.find(heading)
    if idx == -1:
        continue
    code_start = idx + len(heading)
    if marker:
        code_end = app.find(marker, code_start)
    else:
        code_end = len(app)
    code = app[code_start:code_end].rstrip()
    if not code.startswith("```"):
        app = app[:code_start] + "```r\n" + code + "\n```\n\n" + app[code_end:]

app_path.write_text(app, encoding="utf-8")

# --- WLK2008 ---
wlk = (ROOT / "WLK2008.md").read_text(encoding="utf-8")

old_poisson = r"""Our ability to use Kooperberg’s implementation for density estimation rests on the duality of fitting Poisson process intensity functions and fitting probability densities: the inhomogeneous Poisson likelihood for an intensity function $\lambda = \lambda(t)$ based on a sequence of event times $t_1, t_2, \dots, t_n$ in an interval $(0, T]$ is

$$
P ( t _ { 1 } , \dots
$$ , t _ { n } )
$$

Here the number of events $ N $ is a Poisson random variable with expectation . Conditionally on the number of events $ N = n $ the probability density becomes

$$
P ( t _ { 1 } , \dots
$$

If we set

$$
f ( t ) = & \frac { \lambda ( t ) } { \int _ { 0 } ^ { T } \lambda ( u ) \, d u }
$$

then it becomes clear that estimation of $ \lambda(t) $ amounts to estimation of the probability density $ f(t) $, together with estimation of FILL_ME_IN. We use $ N = n $ as an estimate of FILL_ME_IN, and apply logspline to estimate $ f(t) $. logspline returns a set of knots for a cubic spline, and these are used as initial values for BARS in the Poisson case."""

new_poisson = r"""Our ability to use Kooperberg’s implementation for density estimation rests on the duality of fitting Poisson process intensity functions and fitting probability densities: the inhomogeneous Poisson likelihood for an intensity function $\lambda = \lambda(t)$ based on a sequence of event times $t_1, t_2, \dots, t_n$ in an interval $(0, T]$ is

$$
P(t_1, \dots, t_n) \propto \exp\left(-\int_0^T \lambda(u)\, du\right) \prod_{i=1}^n \lambda(t_i).
$$

Here the number of events $N$ is a Poisson random variable with expectation $\Lambda = \int_0^T \lambda(u)\, du$. Conditionally on the number of events $N = n$, the probability density becomes

$$
P(t_1, \dots, t_n \mid N = n) = \frac{n!}{\Lambda^n} \exp\left(-\int_0^T \lambda(u)\, du\right) \prod_{i=1}^n \lambda(t_i).
$$

If we set

$$
f(t) = \frac{\lambda(t)}{\int_0^T \lambda(u)\, du},
$$

then it becomes clear that estimation of $\lambda(t)$ amounts to estimation of the probability density $f(t)$, together with estimation of $\Lambda$. We use $N = n$ as an estimate of $\Lambda$, and apply logspline to estimate $f(t)$. logspline returns a set of knots for a cubic spline, and these are used as initial values for BARS in the Poisson case."""

wlk = wlk.replace(old_poisson, new_poisson)

# Replace shattered MCMC pseudo-code block
mcmc_start = wlk.find(
    "Remove knots through backwards elimination until a subset is found such that 1) the model fit does not fail, 2) the model has the greatest likelihood among the models with the same number of knots in which the fit does not fail, and 3) the knot subset has positive prior probability. If all models with a given number of knots fail to be fit, the model in which has the smallest condition number is selected, and the procedure continues by trying to remove an additional knot.\n\n$$"
)
mcmc_end = wlk.find("\n$$\n\n\\mu_{D,curr}", mcmc_start)
if mcmc_start != -1 and mcmc_end != -1:
    mcmc_replacement = r"""Remove knots through backwards elimination until a subset is found such that 1) the model fit does not fail, 2) the model has the greatest likelihood among the models with the same number of knots in which the fit does not fail, and 3) the knot subset has positive prior probability. If all models with a given number of knots fail to be fit, the model in which has the smallest condition number is selected, and the procedure continues by trying to remove an additional knot.

If backwards elimination fails to find a valid subset, the procedure tries to fit a model with the minimum number of knots that have positive prior probability, with the knots equally spaced. If the model fails to be fit, exit.

Set $M_{\text{curr}}$ to the resulting model.

```text
maxBIC <- 0
total_iterations <- burnin_iterations + sampling_iterations

for i <- 0 to total_iterations - 1
    u ~ U(0, 1)

    if (u < birth_probability)
        s ~ Discrete Uniform(ξ_curr)
        r <- s
        t ~ Beta(a = τ*r, b = (1 - r)*τ)
        ξ_cand <- (ξ_curr ∪ {t}) \ {s}
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
        ξ_cand <- ξ_curr \ {t}
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
        ξ_cand <- (ξ_curr \ {s}) ∪ {t}
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
    wlk = wlk[:mcmc_start] + mcmc_replacement + wlk[mcmc_end + 1 :]

# Clean up orphaned fragments after MCMC block
wlk = wlk.replace(", $ curr $ ).\n\n", "")
wlk = wlk.replace(
    "$$\nk_{cand} \\leftarrow k_{curr} - 1\n$$\n\n",
    "",
)

(ROOT / "WLK2008.md").write_text(wlk, encoding="utf-8")

print("Manual repairs applied.")
